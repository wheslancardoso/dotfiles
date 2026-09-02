#!/usr/bin/env python3
import os
import shutil
import re
from pathlib import Path

ROOT = Path('/home/lan/drive-organizacao')

DOWNLOAD_ARTIFACTS_REGEX = re.compile(
    r"(\s*\(\d+\)|\s*\[\d+\]|\s*-\s*c[oó]pia|\s*-\s*copy|\s*copia|\s*copy)",
    re.IGNORECASE,
)

def sanitize_filename(filename: str) -> str:
    path = Path(filename)
    stem = path.stem
    suffix = path.suffix

    # Remove artifacts like (1), - Copia
    stem = DOWNLOAD_ARTIFACTS_REGEX.sub("", stem)

    # Normalize whitespace
    stem = re.sub(r"\s+", "_", stem.strip())
    stem = re.sub(r"_+", "_", stem)
    stem = re.sub(r"-+", "-", stem)
    stem = stem.strip(" _-")

    if not stem:
        stem = "arquivo"

    return f"{stem}{suffix}"

def safe_move(source_path: Path, target_dir: Path) -> Path:
    target_dir.mkdir(parents=True, exist_ok=True)
    clean_name = sanitize_filename(source_path.name)
    dest_path = target_dir / clean_name

    counter = 1
    while dest_path.exists() and dest_path.resolve() != source_path.resolve():
        dest_path = target_dir / f"{dest_path.stem}_{counter}{dest_path.suffix}"
        counter += 1

    shutil.move(str(source_path), str(dest_path))
    return dest_path

def safe_move_directory(source_dir: Path, target_dir: Path):
    if not source_dir.exists():
        return
    target_dir.mkdir(parents=True, exist_ok=True)
    for item in list(source_dir.iterdir()):
        if item.name.endswith(':Zone.Identifier'):
            item.unlink()
            continue
        if item.is_dir():
            safe_move_directory(item, target_dir / item.name)
        elif item.is_file():
            safe_move(item, target_dir)

def classify_loose_file(file_path: Path) -> Path:
    name = file_path.name.lower()
    ext = file_path.suffix.lower()

    # 1. Linux Essentials
    if "linux essentials" in name or "linux_essentials" in name:
        return ROOT / "02_Estudos_e_Concursos" / "02.1_Cursos_e_Certificacoes" / "Linux_Essentials"

    # 2. ADS TCC / Artigo Científico
    if "tcc" in name or "artigo cientifico" in name or "artigo científico" in name:
        return ROOT / "02_Estudos_e_Concursos" / "02.1_Cursos_e_Certificacoes" / "ADS_TCC"

    # 3. Packet Tracer / Redes
    if ext == ".pkt" or "dhcp" in name or "rede" in name or "cisco" in name:
        return ROOT / "02_Estudos_e_Concursos" / "02.1_Cursos_e_Certificacoes" / "Redes"

    # 4. Documentos Pessoais & Identidade
    if any(k in name for k in ["certidão", "certidao", "identidade", "pis", "cpf", "rg", "cnh", "dossiê", "dossie", "passaporte", "nascimento"]):
        return ROOT / "01_Pessoal_e_Vida" / "01.1_Identidade_e_Documentos"

    # 5. Carreira & Currículos
    if any(k in name for k in ["curriculo", "currículo", "resume", "cv", "vdi", "salario", "salário", "carreira", "vagas"]):
        return ROOT / "01_Pessoal_e_Vida" / "01.2_Carreira_e_Curriculos"

    # 6. Clareza e Desenvolvimento Pessoal
    if any(k in name for k in ["personalidade", "jornada de wheslan", "clareza", "homem exemplar", "hábitos", "habitos", "pilares milenares", "visão", "visao", "mulheres", "transição", "transicao", "mindset"]):
        return ROOT / "01_Pessoal_e_Vida" / "01.3_Clareza_e_Desenvolvimento_Pessoal"

    # 7. Finanças e Contas
    if any(k in name for k in ["sap02", "planilha_de_custos", "financeiro", "extrato", "fatura", "conta", "imposto", "custos", "finanças", "financas", "nota fiscal"]):
        return ROOT / "01_Pessoal_e_Vida" / "01.4_Financas_e_Contas"

    # 8. Fresh News / Prompts IA / SOPs
    if any(k in name for k in ["fresh news", "freshnews", "prompt", "prompts", "sop", "redação agêntica", "playbook", "diretrizes técnicas", "atendimento"]):
        return ROOT / "03_Profissional_WFIX" / "03.1_IA_Prompts_e_SOPs"

    # 9. Automações & n8n
    if any(k in name for k in ["workflow", "n8n", "webhook", "automação", "automacao"]):
        return ROOT / "03_Profissional_WFIX" / "03.2_Automacoes_e_n8n"

    # 10. WhatsApp Chats & Contacts
    if "conversa do whatsapp" in name or ext == ".vcf":
        return ROOT / "03_Profissional_WFIX" / "03.4_Clientes_e_Whats"

    # 11. WFIX Empresa & Comercial
    if any(k in name for k in ["wfix", "marketing digital para manutenção", "mercado ti", "roteiros clientes", "empresa", "vendas", "orçamento"]):
        return ROOT / "03_Profissional_WFIX" / "03.3_WFIX_Empresa"

    # 12. Projetos Web & Apps
    if any(k in name for k in ["app", "web", "api rest", "módulo de assinatura", "identificadores inteligentes", "metricas", "frontend", "backend", "stack"]):
        return ROOT / "04_Desenvolvimento_e_Codigo" / "04.1_Projetos_Web_e_Apps"

    # 13. Scripts & Bancos de Dados
    if ext in [".py", ".sh", ".ps1", ".sql"]:
        return ROOT / "04_Desenvolvimento_e_Codigo" / "04.2_Scripts_e_Bancos"

    # 14. Artes, Banners, Wallpapers, Apresentações
    if ext in [".pptx"] or any(k in name for k in ["banner", "poster", "apresentação", "apresentacao", "wallpaper", "print"]):
        return ROOT / "05_Design_Midia_e_Criacao" / "05.1_Artes_e_Wallpapers"

    # 15. Áudios & Vídeos
    if ext in [".mp3", ".wav", ".ogg", ".flac", ".mp4"]:
        return ROOT / "05_Design_Midia_e_Criacao" / "05.2_Audios_e_Midias"

    # 16. Instaladores, APKs, DEBs
    if ext in [".deb", ".apk", ".exe", ".msi"] or (ext == ".zip" and "release" in name):
        return ROOT / "06_Backups_ISOs_e_Sistemas" / "06.1_Instaladores_e_APKs"

    # 17. Backups & Snapshots
    if ext in [".zip", ".rar", ".7z"] and ("backup" in name or ".agents" in name):
        return ROOT / "06_Backups_ISOs_e_Sistemas" / "06.2_Backups_e_Snapshots"

    # Fallback inteligente por extensão
    if ext in [".pdf", ".docx", ".xlsx", ".txt", ".md"]:
        return ROOT / "01_Pessoal_e_Vida" / "01.3_Clareza_e_Desenvolvimento_Pessoal"

    return ROOT / "00_Inbox_Triagem"

def main():
    print("=== INICIANDO ORGANIZAÇÃO COMPLETA DO GOOGLE DRIVE ===")

    # 1. Roteamento de Pastas Estruturadas
    mappings_dirs = [
        ("04.DIGITALIZADOS-20260830T213138Z-1-001/04.DIGITALIZADOS", ROOT / "01_Pessoal_e_Vida" / "01.1_Identidade_e_Documentos" / "04_DIGITALIZADOS"),
        ("DOCUMENTOS VÓ -20260830T212235Z-1-001/DOCUMENTOS VÓ_", ROOT / "01_Pessoal_e_Vida" / "01.1_Identidade_e_Documentos" / "Documentos_Familia"),
        ("Minha personalidade -20260830T212210Z-1-001/Minha personalidade_", ROOT / "01_Pessoal_e_Vida" / "01.3_Clareza_e_Desenvolvimento_Pessoal" / "Minha_Personalidade"),
        ("estilo-20260830T212205Z-1-001/estilo", ROOT / "01_Pessoal_e_Vida" / "01.3_Clareza_e_Desenvolvimento_Pessoal" / "Estilo"),
        ("1.0 - DOCUMENTOS-20260830T213147Z-1-002/1.0 - DOCUMENTOS/LIVROS", ROOT / "02_Estudos_e_Concursos" / "02.2_Biblioteca_e_Ebooks" / "LIVROS"),
        ("Apostilas Senai-20260830T212333Z-1-001/Apostilas Senai", ROOT / "02_Estudos_e_Concursos" / "02.1_Cursos_e_Certificacoes" / "Apostilas_SENAI"),
        ("ads tcc-20260830T213043Z-1-001/ads tcc", ROOT / "02_Estudos_e_Concursos" / "02.1_Cursos_e_Certificacoes" / "ADS_TCC"),
        ("Wfixtech-20260830T212348Z-1-001/Wfixtech", ROOT / "03_Profissional_WFIX" / "03.3_WFIX_Empresa"),
        ("Fresh News-20260830T212217Z-1-001/Fresh News", ROOT / "03_Profissional_WFIX" / "03.1_IA_Prompts_e_SOPs" / "Fresh_News"),
        ("Finance IA-20260830T212158Z-1-001/Finance IA", ROOT / "04_Desenvolvimento_e_Codigo" / "04.1_Projetos_Web_e_Apps" / "Finance_IA"),
        ("Mixtape252-20260830T212358Z-1-001/Mixtape252", ROOT / "04_Desenvolvimento_e_Codigo" / "04.1_Projetos_Web_e_Apps" / "Mixtape252"),
        ("Wallpapers-20260830T212827Z-1-001/Wallpapers", ROOT / "05_Design_Midia_e_Criacao" / "05.1_Artes_e_Wallpapers" / "Wallpapers"),
        ("PROGRAMAS-20260830T212142Z-1-001/PROGRAMAS", ROOT / "06_Backups_ISOs_e_Sistemas" / "06.1_Instaladores_e_APKs" / "PROGRAMAS"),
    ]

    for rel_src, target_path in mappings_dirs:
        src_path = ROOT / rel_src
        if src_path.exists():
            print(f"Movendo pasta estruturada: {rel_src} -> {target_path.relative_to(ROOT)}")
            safe_move_directory(src_path, target_path)

    # Move qualquer WhatsApp ZIP dentro de WFIX para 03.4_Clientes_e_Whats
    wfix_empresa = ROOT / "03_Profissional_WFIX" / "03.3_WFIX_Empresa"
    if wfix_empresa.exists():
        whats_target = ROOT / "03_Profissional_WFIX" / "03.4_Clientes_e_Whats"
        for item in list(wfix_empresa.glob("Conversa do WhatsApp*.zip")):
            safe_move(item, whats_target)

    # 2. Classificação dos Arquivos Soltos (drive-download-*)
    drive_download = ROOT / "drive-download-20260830T211332Z-1-002"
    if drive_download.exists():
        loose_files = list(drive_download.glob("*"))
        print(f"Classificando {len(loose_files)} arquivos soltos em drive-download...")
        for item in loose_files:
            if item.is_file():
                if item.name.endswith(':Zone.Identifier'):
                    item.unlink()
                    continue
                dest_dir = classify_loose_file(item)
                safe_move(item, dest_dir)

    # 3. Varredura final de sanitização de nomes em todos os arquivos de 00_ a 06_
    print("Sanitizando e padronizando nomes em toda a taxonomia mestre...")
    for master_dir in [d for d in ROOT.iterdir() if d.is_dir() and d.name.startswith("0")]:
        for file_path in list(master_dir.rglob("*")):
            if file_path.is_file():
                if file_path.name.endswith(':Zone.Identifier'):
                    file_path.unlink()
                    continue
                clean = sanitize_filename(file_path.name)
                if clean != file_path.name:
                    new_path = file_path.parent / clean
                    counter = 1
                    while new_path.exists() and new_path != file_path:
                        new_path = file_path.parent / f"{new_path.stem}_{counter}{new_path.suffix}"
                        counter += 1
                    try:
                        file_path.rename(new_path)
                    except Exception as e:
                        print(f"Erro ao renomear {file_path.name}: {e}")

    # 4. Limpeza de diretórios vazios de exportação (*-20260830T*)
    print("Limpando diretórios vazios do Google Takeout/Download...")
    for d in list(ROOT.glob("*-20260830T*")):
        if d.is_dir():
            shutil.rmtree(d, ignore_errors=True)

    print("=== ORGANIZAÇÃO CONCLUÍDA COM SUCESSO! ===")

if __name__ == "__main__":
    main()
