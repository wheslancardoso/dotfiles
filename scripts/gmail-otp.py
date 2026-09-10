#!/usr/bin/env python3
"""
Gmail OTP & Verification Code Fetcher ("Ghost OTP")
Fetches 4-8 digit verification codes across configured Gmail accounts concurrently,
copies the code to clipboard (wl-copy), and dispatches visual desktop notifications.
"""

import sys
import os
import json
import ssl
import email
import imaplib
import re
import html
import subprocess
import fcntl
from datetime import datetime, timezone
from concurrent.futures import ThreadPoolExecutor, as_completed

CONFIG_PATH = os.path.expanduser("~/.config/gmail-otp/credentials.json")
LOCK_FILE = "/tmp/gmail_otp.lock"


# Keywords in Subject or Snippets that strongly indicate a verification/OTP email
OTP_SUBJECT_KEYWORDS = [
    r'c[oó]digo', r'code', r'verification', r'verificação', r'verificacao',
    r'security', r'segurança', r'seguranca', r'pin', r'token', r'senha tempor[aá]ria',
    r'confirma[cç][aã]o\s+de\s+(?:conta|e-?mail|acesso|cadastro|seguran[cç]a|identidade)',
    r'confirm\s+your\s+(?:account|email|identity|login)',
    r'one-time', r'otp', r'2fa', r'two-factor',
    r'autentica[cç][aã]o', r'authentication', r'redefini[cç][aã]o',
    r'password reset', r'valida[cç][aã]o', r'validate'
]
RE_SUBJECT_MATCH = re.compile('|'.join(OTP_SUBJECT_KEYWORDS), re.IGNORECASE)


# Patterns for clean OTP extraction
RE_CODE_CONTEXT = [
    # Explicit context: "seu código é: 123456", "código de verificação: 123-456", "use code 123456"
    re.compile(r'(?:seu\s+c[oó]digo(?:\s+de\s+(?:seguran[cç]a|acesso|valida[cç][aã]o|confirma[cç][aã]o|aplica[cç][aã]o|ativa[cç][aã]o|verifica[cç][aã]o))?|your\s+(?:verification\s+)?code|c[oó]digo|code|token|pin|senha\s+provis[oó]ria)\s*(?:[eé]|is)?\s*[:\s-]{1,5}\s*([0-9]{4,8}|[0-9]{3}[\s-][0-9]{3})\b', re.IGNORECASE),
    # Preceding code: "123456 is your code", "123456 é o seu código de verificação"
    re.compile(r'\b([0-9]{4,8})\b\s*(?:[eé]|is)\s*(?:o\s+)?(?:seu\s+)?c[oó]digo', re.IGNORECASE),
    # Formatted tags/classes: <span class="code">123456</span> or <b>123456</b> or <strong>123456</strong>
    re.compile(r'<(?:span|b|strong|div|p|h[1-4]|td)[^>]*?(?:code|otp|token|pin|digit|number|highlight)[^>]*?>\s*([0-9]{4,8}|[0-9]{3}[\s-][0-9]{3})\s*</', re.IGNORECASE),
    # Bold/standalone tags in HTML: <b>123456</b> or <strong>123456</strong>
    re.compile(r'<(?:b|strong)>\s*([0-9]{4,8}|[0-9]{3}[\s-][0-9]{3})\s*</(?:b|strong)>', re.IGNORECASE),
]

# Blacklisted numbers: years, zip codes, known false positives
BLACKLIST_PATTERNS = {
    '2023', '2024', '2025', '2026', '2027', '2028',
    '1234', '12345', '123456', '0000', '000000', '999999'
}

def clean_sender_name(sender_header):
    if not sender_header:
        return "Serviço Desconhecido"
    # Decodes MIME encoded words: =?utf-8?B?...?=
    try:
        decoded_parts = email.header.decode_header(sender_header)
        sender_header = ""
        for part, enc in decoded_parts:
            if isinstance(part, bytes):
                sender_header += part.decode(enc or 'utf-8', errors='ignore')
            else:
                sender_header += str(part)
    except Exception:
        pass

    # Extract name part before <email@domain>
    match = re.match(r'^"?([^"<]+)"?\s*(?:<.*>)?$', sender_header.strip())
    if match and match.group(1).strip():
        name = match.group(1).strip()
        # Remove unwanted quotes and extra prefixes
        name = re.sub(r'^(Equipe|Team|Suporte|Support|Security|Segurança)\s+(do|da|de|the)?\s*', '', name, flags=re.IGNORECASE)
        return name.strip() or sender_header
    return sender_header.split('@')[0].strip()

def decode_mime_text(text):
    if not text:
        return ""
    try:
        decoded_parts = email.header.decode_header(text)
        res = ""
        for part, enc in decoded_parts:
            if isinstance(part, bytes):
                res += part.decode(enc or 'utf-8', errors='ignore')
            else:
                res += str(part)
        return res
    except Exception:
        return text

def extract_body(msg):
    html_parts = []
    text_parts = []

    if msg.is_multipart():
        for part in msg.walk():
            ctype = part.get_content_type()
            cdisp = str(part.get('Content-Disposition', ''))
            if 'attachment' in cdisp:
                continue
            try:
                payload = part.get_payload(decode=True)
                if not payload:
                    continue
                charset = part.get_content_charset() or 'utf-8'
                decoded_str = payload.decode(charset, errors='ignore')
                if ctype == 'text/html':
                    html_parts.append(decoded_str)
                elif ctype == 'text/plain':
                    text_parts.append(decoded_str)
            except Exception:
                continue
    else:
        try:
            payload = msg.get_payload(decode=True)
            if payload:
                charset = msg.get_content_charset() or 'utf-8'
                decoded_str = payload.decode(charset, errors='ignore')
                if msg.get_content_type() == 'text/html':
                    html_parts.append(decoded_str)
                else:
                    text_parts.append(decoded_str)
        except Exception:
            pass

    return "\n".join(html_parts), "\n".join(text_parts)

def extract_otp(subject, html_content, text_content):
    # Check subject first
    # Many emails have OTP directly in subject: "Seu código é 492041", "123456 é seu código de verificação"
    for pat in RE_CODE_CONTEXT:
        m = pat.search(subject)
        if m:
            code = m.group(1).replace('-', '').replace(' ', '')
            if code not in BLACKLIST_PATTERNS and 4 <= len(code) <= 8:
                return code

    # Check for direct 4-8 digit isolated in subject
    sub_digit_match = re.search(r'\b([0-9]{4,8})\b', subject)
    if sub_digit_match:
        code = sub_digit_match.group(1)
        if code not in BLACKLIST_PATTERNS:
            return code

    # Search in HTML content using specific HTML/OTP rules
    if html_content:
        for pat in RE_CODE_CONTEXT:
            m = pat.search(html_content)
            if m:
                code = m.group(1).replace('-', '').replace(' ', '')
                if code not in BLACKLIST_PATTERNS and 4 <= len(code) <= 8:
                    return code

    # Search in plain text or rendered HTML text
    # Convert HTML into clean text lines (strip script/style first)
    extracted_text_sources = []
    if text_content:
        extracted_text_sources.append(text_content)
    if html_content:
        no_scripts = re.sub(r'<(script|style)[^>]*?>.*?</\1>', '', html_content, flags=re.DOTALL|re.IGNORECASE)
        clean_html_text = re.sub(r'<[^>]+>', '\n', no_scripts)
        clean_html_text = html.unescape(clean_html_text)
        extracted_text_sources.append(clean_html_text)

    for body_text in extracted_text_sources:
        for pat in RE_CODE_CONTEXT:
            m = pat.search(body_text)
            if m:
                code = m.group(1).replace('-', '').replace(' ', '')
                if code not in BLACKLIST_PATTERNS and 4 <= len(code) <= 8:
                    return code

        # Search for isolated lines containing solely the code (common in modern responsive emails like OpenAI, Discord)
        lines = [line.strip() for line in body_text.splitlines() if line.strip()]
        for line in lines:
            if re.match(r'^[0-9]{4,8}$', line):
                if line not in BLACKLIST_PATTERNS:
                    return line

        # Search surrounding lines near OTP trigger phrases
        for i, line in enumerate(lines):
            if RE_SUBJECT_MATCH.search(line):
                window = lines[max(0, i-2):min(len(lines), i+3)]
                for w_line in window:
                    m = re.search(r'\b([0-9]{4,8})\b', w_line)
                    if m:
                        code = m.group(1)
                        if code not in BLACKLIST_PATTERNS:
                            return code

    return None

def fetch_account_otps(account_info):
    name = account_info.get("name", "Account")
    email_addr = account_info.get("email")
    pwd = account_info.get("pass")

    results = []
    try:
        ctx = ssl.create_default_context()
        mail = imaplib.IMAP4_SSL("imap.gmail.com", 993, ssl_context=ctx, timeout=7)
        mail.login(email_addr, pwd)
        mail.select("INBOX", readonly=True)

        # Search recent emails (last 10-15 messages)
        status, search_data = mail.search(None, "ALL")
        if status != "OK" or not search_data[0]:
            mail.logout()
            return []

        all_ids = search_data[0].split()
        # Take the most recent 12 emails
        recent_ids = all_ids[-12:]
        recent_ids.reverse()  # Newest first

        for msg_id in recent_ids:
            try:
                res, msg_data = mail.fetch(msg_id, "(RFC822)")
                if res != "OK" or not msg_data:
                    continue

                raw_email = msg_data[0][1]
                msg = email.message_from_bytes(raw_email)

                subject = decode_mime_text(msg.get("Subject", ""))
                from_header = decode_mime_text(msg.get("From", ""))
                sender_name = clean_sender_name(from_header)
                date_str = msg.get("Date", "")

                # Quick relevance filter: Does Subject or Sender match verification keywords?
                is_otp_candidate = bool(RE_SUBJECT_MATCH.search(subject) or RE_SUBJECT_MATCH.search(from_header))
                
                html_body, text_body = extract_body(msg)

                # Even if subject didn't match, body might be a verification email
                if not is_otp_candidate:
                    if RE_SUBJECT_MATCH.search(text_body[:500]) or RE_SUBJECT_MATCH.search(html_body[:1000]):
                        is_otp_candidate = True

                if not is_otp_candidate:
                    continue

                code = extract_otp(subject, html_body, text_body)
                if code:
                    # Parse date timestamp for accurate sorting
                    ts = 0
                    try:
                        date_tuple = email.utils.parsedate_to_datetime(date_str)
                        ts = date_tuple.timestamp()
                    except Exception:
                        pass

                    results.append({
                        "account": name,
                        "email": email_addr,
                        "service": sender_name,
                        "subject": subject,
                        "code": code,
                        "timestamp": ts,
                        "date_str": date_str
                    })
                    # Found the latest code for this account, continue checking or break if sufficient
                    if len(results) >= 2:
                        break
            except Exception:
                continue

        mail.logout()
    except Exception as e:
        sys.stderr.write(f"[{name}] Erro: {e}\n")

    return results

def copy_to_clipboard(text):
    try:
        proc = subprocess.Popen(["wl-copy"], stdin=subprocess.PIPE)
        proc.communicate(input=text.encode("utf-8"))
        return True
    except Exception:
        # Fallback to xclip if on X11
        try:
            proc = subprocess.Popen(["xclip", "-selection", "clipboard"], stdin=subprocess.PIPE)
            proc.communicate(input=text.encode("utf-8"))
            return True
        except Exception:
            return False

def notify(title, message, urgency="normal"):
    try:
        subprocess.run([
            "notify-send",
            "-a", "Ghost OTP",
            "-u", urgency,
            "-i", "mail-mark-read",
            "-r", "999888",
            "-t", "4000",
            title,
            message
        ], check=False)
    except Exception:
        pass

def main():
    # Process Lock: Prevent duplicate runs if user double-presses the shortcut
    try:
        lock_fd = open(LOCK_FILE, "w")
        fcntl.flock(lock_fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except (BlockingIOError, IOError):
        # Another instance is already running right now
        sys.exit(0)

    if not os.path.isfile(CONFIG_PATH):
        print(f"Configuração não encontrada em: {CONFIG_PATH}")
        notify("Ghost OTP Erro", "Arquivo credentials.json não encontrado.", "critical")
        sys.exit(1)

    with open(CONFIG_PATH, "r") as f:
        accounts = json.load(f)


    # Concurrently fetch from all accounts
    all_codes = []
    with ThreadPoolExecutor(max_workers=len(accounts)) as executor:
        futures = [executor.submit(fetch_account_otps, acc) for acc in accounts]
        for f in as_completed(futures):
            all_codes.extend(f.result())

    if not all_codes:
        print("Nenhum código de verificação recente encontrado.")
        notify("Ghost OTP", "Nenhum código recente encontrado nas contas.", "low")
        return

    # Sort codes: newest first
    all_codes.sort(key=lambda x: x["timestamp"], reverse=True)

    # If --fzf or --menu passed, or multiple codes and requested interactive selection
    if "--fzf" in sys.argv or "--menu" in sys.argv:
        fzf_lines = [
            f"{c['code']} | {c['service']} ({c['account']}) - {c['subject'][:40]}"
            for c in all_codes
        ]
        try:
            p = subprocess.Popen(["fzf", "--prompt=Escolha o código: "], stdin=subprocess.PIPE, stdout=subprocess.PIPE, text=True)
            stdout, _ = p.communicate(input="\n".join(fzf_lines))
            if stdout.strip():
                chosen_code = stdout.strip().split('|')[0].strip()
                copy_to_clipboard(chosen_code)
                notify("Código Copiado!", f"{chosen_code} copiado para a área de transferência.")
                print(f"Código copiado: {chosen_code}")
                return
        except Exception:
            pass

    # Default action: Grab the latest code immediately!
    top = all_codes[0]
    code = top["code"]
    service = top["service"]
    account = top["account"]

    copy_to_clipboard(code)
    print(f"[Ghost OTP] Código detectado e copiado: {code} ({service} - {account})")
    notify(f"🔑 Código Copiado: {code}", f"Serviço: {service}\nConta: {account}\nPronto para colar (Ctrl+V)!")

if __name__ == "__main__":
    main()
