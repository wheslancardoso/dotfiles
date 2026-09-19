#!/usr/bin/env python3
"""
Compilador Soberano da Base de Emojis em Português do Brasil (PT-BR)
Combina:
- Unicode Consortium Official emoji-test.txt (Grupos e Subgrupos)
- Unicode CLDR pt annotations (Nomes oficiais e palavras-chave em PT-BR)
- Unicode CLDR pt derived annotations (Emojis compostos e bandeiras)
- Dicionário Enriquecido de Gírias e Sinônimos Brasileiros (joinha, kkk, foguinho, etc.)
- Normalização de Acentos para busca instantânea (ex: coracao -> coração, cafe -> café)
"""

import json
import re
import unicodedata
import urllib.request
from pathlib import Path

CATEGORY_MAP = {
    "Smileys & Emotion": "😀 Rostos & Emoções",
    "People & Body": "👋 Pessoas & Gestos",
    "Animals & Nature": "🐶 Animais & Natureza",
    "Food & Drink": "🍕 Comidas & Bebidas",
    "Travel & Places": "✈️ Viagens & Lugares",
    "Activities": "⚽ Atividades & Esportes",
    "Objects": "💡 Objetos",
    "Symbols": "🔣 Símbolos",
    "Flags": "🇧🇷 Bandeiras",
}

SLANG_MAP = {
    "👍": ["joinha", "positivo", "top", "blz", "beleza", "valeu", "curtir", "joia", "concordo", "sim", "dahora"],
    "👎": ["negativo", "descurtir", "ruim", "nao", "reprovar", "paia", "bosta"],
    "😂": ["kkk", "kkkk", "gargalhada", "chorando de rir", "engracado", "rir", "risada", "lol", "hahaha", "morrendo de rir"],
    "🤣": ["rofl", "morrendo de rir", "capotando", "gargalhar", "rolando de rir", "muito bom"],
    "❤️": ["coracao", "amor", "paixao", "crush", "namoro", "vida", "love", "coracaozinho"],
    "🥰": ["apaixonado", "fofo", "fofura", "carinho", "derretido", "encantado", "meigo"],
    "😍": ["olhos de coracao", "crush", "lindo", "maravilhoso", "perfeito", "gato", "gata", "apaixonada"],
    "🥺": ["pidom", "por favor", "do", "coitado", "olhar de gatinho", "suplica", "implorando", "fofo"],
    "🤡": ["palhaco", "palhacada", "trouxa", "iludido", "otario", "fiz papel de palhaco", "circo"],
    "💀": ["morto", "morte", "faleci", "morri", "caveira", "dead", "fim", "morri de rir"],
    "☠️": ["perigo", "veneno", "morte", "pirata", "caveira"],
    "🔥": ["fogo", "foguinho", "chama", "hype", "top", "bombando", "quente", "pegando fogo", "fire"],
    "💰": ["dinheiro", "grana", "pix", "rico", "salario", "pagamento", "dindin", "capital", "rico"],
    "🤑": ["olho gordo", "ganancioso", "dinheiro na boca", "pix", "rico", "milionario"],
    "💸": ["dinheiro voando", "gastando", "falencia", "boleto", "pagar", "grana voando"],
    "💵": ["dolar", "grana", "nota", "dinheiro", "cedula"],
    "💳": ["cartao", "credito", "debito", "pagamento", "nubank"],
    "☕": ["cafe", "cafezinho", "cafeina", "expresso", "bom dia", "acordar", "inverno"],
    "🍺": ["cerveja", "cervejinha", "chopp", "brinde", "sextou", "boteco", "bar", "gelada", "breja"],
    "🍻": ["brinde", "chopp", "canecos", "cervejas", "saude", "prost", "happy hour"],
    "🥂": ["brinde", "champanhe", "comemoracao", "tacas", "tim tim"],
    "🍷": ["vinho", "tinto", "taca", "jantar", "elegante"],
    "🥳": ["festa", "aniversario", "parabens", "comemorar", "ebaa", "balada", "celebracao"],
    "🎉": ["parabens", "festa", "confete", "conquista", "sucesso", "uhu"],
    "🎂": ["bolo", "aniversario", "parabens", "parabens pra voce", "vela"],
    "🤔": ["pensando", "duvida", "hmmm", "sera", "pensativo", "pensador", "filosofo"],
    "🧐": ["analisando", "monoculo", "detetive", "suspeito", "hum", "interessante"],
    "🤨": ["desconfiado", "sobrancelha levantada", "sei nao", "hum", "duvido"],
    "👀": ["olhos", "olhando", "stalker", "de olho", "fofoca", "vendo", "olhada", "curioso"],
    "🇧🇷": ["brasil", "brasileiro", "verde e amarelo", "patria", "br"],
    "🙏": ["amem", "rezar", "oracao", "gratidao", "obrigado", "valeu", "namaste", "por favor", "fe", "deus"],
    "✨": ["brilho", "estrelas", "magia", "glow", "brilhante", "especial", "clean"],
    "💩": ["coco", "merda", "bosta", "fezes", "poo"],
    "🤦": ["facepalm", "que vergonha", "nao acredito", "burro", "mao na cara"],
    "🤷": ["sei la", "dar de ombros", "tanto faz", "e dai", "nao sei"],
    "🥱": ["sono", "tedio", "bocejo", "dormir", "cansado"],
    "😴": ["dormindo", "sono", "zzz", "cama", "capotou"],
    "🍕": ["pizza", "comida", "fome", "lanche", "sexta"],
    "🍔": ["hamburguer", "lanche", "podrao", "fast food", "burger"],
    "🍟": ["batata frita", "fritas", "lanche"],
    "🌭": ["cachorro quente", "hotdog"],
    "🥩": ["churrasco", "carne", "picanha", "churras"],
    "🥑": ["abacate", "fitness", "guacamole"],
    "🚀": ["foguete", "voar", "lancamento", "to the moon", "subir", "turbo", "rapido", "decolar"],
    "💯": ["cem", "100", "perfeito", "nota dez", "mandou bem", "exato"],
    "💪": ["forca", "forte", "academia", "musculo", "treino", "fitness", "foco"],
    "🤙": ["shaka", "hang loose", "tranquilo", "tamo junto", "tmj", "de boa", "alo"],
    "🤝": ["aperto de mao", "acordo", "fechado", "negocio", "parceria", "tmj"],
    "🖕": ["dedo do meio", "vsf", "foda-se", "palavrao", "raiva"],
    "✌️": ["paz", "paz e amor", "vitoria", "dois", "tranquilo"],
    "🤞": ["figas", "torcendo", "sorte", "tomara", "dedos cruzados"],
    "🤟": ["rock", "te amo", "metal", "heavy metal"],
    "🤘": ["rock and roll", "chifre", "metal", "rockeiro"],
    "🎯": ["alvo", "na mosca", "certeiro", "meta", "foco"],
    "⚡": ["raio", "eletrico", "rapido", "energia", "trovao", "flash", "choque"],
    "💡": ["ideia", "lampada", "pensamento", "eureka", "genial", "luz"],
    "🧠": ["cerebro", "inteligente", "mente", "pensar", "qi"],
    "❤️‍🔥": ["coracao em chamas", "paixao ardente", "fogo", "amor quente"],
    "💔": ["coracao partido", "triste", "tristeza", "termino", "bad", "choro", "sofrimento", "dor"],
    "😭": ["choro", "chorando", "desespero", "triste", "tristeza", "lagrimas", "pranto", "bad"],
    "😢": ["choro", "choro triste", "lagrima", "triste", "tristeza", "depressao", "bad"],
    "😔": ["triste", "tristeza", "deprimido", "abatido", "bad", "desanimado", "chateado", "pra baixo"],
    "😞": ["triste", "tristeza", "decepcionado", "desapontado", "chateado", "bad"],
    "🙁": ["triste", "tristeza", "tristinho", "chateado", "pra baixo"],
    "☹️": ["triste", "tristeza", "descontente", "chateado"],
    "😥": ["triste", "tristeza", "aliviado", "chateado"],
    "🥺": ["triste", "implorando", "pidom", "do", "dó", "carecia", "por favor"],
    "😟": ["triste", "preocupado", "chateado", "apreensivo"],
    "😿": ["triste", "tristeza", "gato chorando", "choro"],
    "😀": ["feliz", "alegre", "sorriso", "contente", "riso", "positivo"],
    "😃": ["feliz", "alegre", "sorridente", "contente", "animado"],
    "😄": ["feliz", "alegre", "sorrindo", "contente", "radiante"],
    "😁": ["feliz", "sorrisao", "alegre", "dentes"],
    "😆": ["feliz", "kkk", "gargalhada", "engracado", "rir"],
    "😱": ["medo", "susto", "assustado", "panico", "chocado"],
    "😨": ["medo", "assustado", "receio", "apavorado"],
    "😰": ["ansiedade", "ansioso", "medo", "nervoso", "suor frio"],
    "😡": ["raiva", "bravo", "furioso", "pistola", "vermelho de raiva", "odio", "puto"],
    "😠": ["bravo", "irritado", "nervoso", "raiva"],
    "🤬": ["palavrao", "xingando", "puto", "revoltado", "censurado", "odio"],
    "🤮": ["vomito", "vomitando", "enjoo", "nojo", "eca"],
    "🤢": ["nausea", "nojo", "verde", "enjoado"],
    "😎": ["oculos escuros", "estiloso", "cool", "foda", "chefao", "tranquilo"],
    "🤓": ["nerd", "estudioso", "oculos", "inteligente", "cdf"],
    "🤤": ["babando", "delicia", "agua na boca", "gostoso"],
    "🤫": ["shhh", "segredo", "silencio", "quieto", "calado"],
    "🤥": ["mentiroso", "pinocchio", "nariz comprido", "mentira"],
    "🥵": ["calor", "quente", "suando", "abafado"],
    "🥶": ["frio", "gelado", "congelando", "inverno"],
    "👻": ["fantasma", "boo", "espere", "halloween", "assustador"],
    "🤖": ["robo", "bot", "ia", "inteligencia artificial", "maquina"],
    "🎮": ["videogame", "jogo", "controle", "game", "gamer", "jogar"],
    "🎧": ["fone", "musica", "ouvindo", "headphone", "audio"],
    "📱": ["celular", "iphone", "smartphone", "zap", "telefone"],
    "💻": ["notebook", "computador", "laptop", "pc", "trabalho", "programar"],
    "⌨️": ["teclado", "digitar", "codigo", "dev"],
}

NOISE_CLEANUP = {
    "😮‍💨": ["triste"], # É alívio / exalação / cansaço
    "🪊": ["triste"],   # É instrumento musical trombone
}

def strip_accents(text: str) -> str:
    return "".join(c for c in unicodedata.normalize("NFD", text) if unicodedata.category(c) != "Mn").lower()

def main():
    print("1. Baixando Unicode Official emoji-test.txt...")
    url_test = "https://unicode.org/Public/emoji/latest/emoji-test.txt"
    with urllib.request.urlopen(url_test) as resp:
        test_lines = resp.read().decode("utf-8").splitlines()

    print("2. Baixando CLDR PT-BR annotations...")
    url_cldr = "https://raw.githubusercontent.com/unicode-org/cldr-json/main/cldr-json/cldr-annotations-full/annotations/pt/annotations.json"
    with urllib.request.urlopen(url_cldr) as resp:
        cldr_pt = json.loads(resp.read().decode("utf-8"))["annotations"]["annotations"]

    print("3. Baixando CLDR PT-BR derived annotations...")
    url_cldr_dev = "https://raw.githubusercontent.com/unicode-org/cldr-json/main/cldr-json/cldr-annotations-derived-full/annotationsDerived/pt/annotations.json"
    with urllib.request.urlopen(url_cldr_dev) as resp:
        cldr_derived = json.loads(resp.read().decode("utf-8"))["annotationsDerived"]["annotations"]

    cldr_all = {**cldr_derived, **cldr_pt}

    print("4. Processando grupos e metadados...")
    emojis_list = []
    seen = set()
    curr_group = "Smileys & Emotion"
    curr_subgroup = ""

    # Modificadores de tom de pele para ordenação
    skin_tones = ["🏻", "🏼", "🏽", "🏾", "🏿"]

    for line in test_lines:
        line = line.strip()
        if line.startswith("# group:"):
            g = line.replace("# group:", "").strip()
            if g in CATEGORY_MAP:
                curr_group = g
            elif g == "Component":
                continue
        elif line.startswith("# subgroup:"):
            curr_subgroup = line.replace("# subgroup:", "").strip()
        elif line and not line.startswith("#"):
            if "; fully-qualified" in line:
                parts = line.split("#")
                if len(parts) == 2:
                    meta = parts[1].strip()
                    m = re.match(r"^(\S+)\s+(E\d+\.\d+)\s+(.+)$", meta)
                    if m:
                        char = m.group(1)
                        en_name = m.group(3)

                        if char in seen:
                            continue
                        seen.add(char)

                        # Verifica dados CLDR em português
                        cldr_info = cldr_all.get(char, {})
                        pt_tts = cldr_info.get("tts", [en_name])[0]
                        pt_keywords = cldr_info.get("default", [])

                        # Se não achou em cldr_all, tenta sem variation selector (\ufe0f)
                        char_novs = char.replace("\ufe0f", "")
                        if not pt_keywords and char_novs in cldr_all:
                            cldr_info = cldr_all[char_novs]
                            pt_tts = cldr_info.get("tts", [en_name])[0]
                            pt_keywords = cldr_info.get("default", [])

                        # Adiciona gírias e sinônimos brasileiros
                        slang = SLANG_MAP.get(char, [])
                        if not slang and char_novs in SLANG_MAP:
                            slang = SLANG_MAP[char_novs]

                        # Agrupa todas as palavras-chave
                        all_kw = set()
                        all_kw.add(pt_tts.lower())
                        all_kw.add(en_name.lower())
                        for kw in pt_keywords:
                            all_kw.add(kw.lower())
                        for s in slang:
                            all_kw.add(s.lower())

                        # Limpa ruídos indesejados
                        noise_words = NOISE_CLEANUP.get(char, [])
                        if not noise_words and char_novs in NOISE_CLEANUP:
                            noise_words = NOISE_CLEANUP[char_novs]
                        for nw in noise_words:
                            all_kw.discard(nw.lower())

                        # Gera termos sem acento para busca perfeita
                        search_terms = set()
                        for term in all_kw:
                            search_terms.add(term)
                            stripped = strip_accents(term)
                            if stripped != term:
                                search_terms.add(stripped)

                        for nw in noise_words:
                            search_terms.discard(nw.lower())
                            search_terms.discard(strip_accents(nw))

                        # Verifica se é variação de tom de pele
                        has_skin_tone = any(st in char for st in skin_tones)

                        group_label = CATEGORY_MAP.get(curr_group, "💡 Objetos")

                        emojis_list.append({
                            "char": char,
                            "name": pt_tts.capitalize(),
                            "en_name": en_name,
                            "group": group_label,
                            "subgroup": curr_subgroup,
                            "keywords": sorted(list(all_kw)),
                            "search_text": " ".join(sorted(list(search_terms))),
                            "has_skin_tone": has_skin_tone
                        })

    # Prioriza emojis base sem tom de pele primeiro, depois variações
    emojis_list.sort(key=lambda x: (x["has_skin_tone"]))

    out_path = Path("/home/lan/dotfiles/home/dot_config/rofi/emoji_pt_br.json")
    out_path.parent.mkdir(parents=True, exist_ok=True)
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(emojis_list, f, ensure_ascii=False, indent=2)

    print(f"✔ Sucesso! {len(emojis_list)} emojis compilados em: {out_path}")

if __name__ == "__main__":
    main()
