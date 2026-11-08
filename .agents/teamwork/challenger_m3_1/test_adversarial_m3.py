#!/usr/bin/env python3
"""
Adversarial Stress Test Suite for Milestone 3 (scripts/organizador)
Challenger: challenger_m3_1
"""

import os
import re
import sys
import json
import shutil
import tempfile
import unittest
from pathlib import Path

ORGANIZADOR_DIR = Path("/home/lan/dotfiles/scripts/organizador")
if str(ORGANIZADOR_DIR) not in sys.path:
    sys.path.insert(0, str(ORGANIZADOR_DIR))

from src.core import FileOrganizerEngine
from src.renamer import AutoNamer
from src.utils import slugify_filename, normalize_text, get_unique_destination_path


class AdversarialChallengerM3(unittest.TestCase):
    def setUp(self):
        self.test_root = Path(tempfile.mkdtemp(prefix="adv_test_m3_"))
        self.config_path = ORGANIZADOR_DIR / "config" / "regras.json"
        self.dest_root = self.test_root / "taxonomia"
        self.dest_root.mkdir(parents=True, exist_ok=True)
        
        self.engine = FileOrganizerEngine(
            config_path=self.config_path,
            root_user=self.test_root,
            custom_dest_root=self.dest_root,
        )

    def tearDown(self):
        shutil.rmtree(self.test_root, ignore_errors=True)

    # =========================================================================
    # 1. WORD BOUNDARY & SHORT TERM REGEX STRESS TESTS
    # =========================================================================
    def test_word_boundary_dio_false_positives(self):
        """1.1 Testa que palavras contendo substring 'dio' NÃO são capturadas pela regra dio."""
        false_positive_candidates = [
            "radio.wav",
            "RADIO.WAV",
            "rádio.mp3",
            "audio_gravacao.wav",
            "estudio_podcast.mp3",
            "meu_episodio_de_podcast.mp3",
            "diodoro.pdf",
            "cardiologia.pdf",
            "remedio.pdf",
            "subsidio_transporte.pdf",
            "odio_e_rancor.txt",
            "estadio_serra_dourada.jpg",
            "custodia_de_valores.docx",
        ]
        for name in false_positive_candidates:
            res = self.engine.classify_file(Path(name))
            dest_str = str(res) if res else ""
            self.assertNotIn(
                "02.3_Cursos_e_Certificacoes",
                dest_str,
                f"FALSO POSITIVO: '{name}' foi incorretamente classificado para Cursos_e_Certificacoes!"
            )

    def test_word_boundary_dio_legitimate_matches(self):
        """1.2 Testa que arquivos genuínos com o termo 'dio' isolado são capturados."""
        legitimate_dio_files = [
            "dio.txt",
            "dio_bootcamp.pdf",
            "DIO_BOOTCAMP_JAVA.pdf",
            "curso dio web.pdf",
            "estudio-dio-final.mp3",
            "trilha_dio_fullstack.zip",
            "certificado-dio-python.pdf",
        ]
        for name in legitimate_dio_files:
            res = self.engine.classify_file(Path(name))
            self.assertIsNotNone(res, f"FALHA: '{name}' deveria ter sido classificado pela regra dio!")
            self.assertIn(
                "02.3_Cursos_e_Certificacoes",
                str(res),
                f"FALHA: '{name}' deveria ter ido para Cursos_e_Certificacoes, mas foi para {res}"
            )

    def test_word_boundary_audio_dio(self):
        """1.3 Testa 'audio_dio.mp3': como 'dio' está isolado por '_' e '.', deve casar com a regra DIO."""
        res = self.engine.classify_file(Path("audio_dio.mp3"))
        self.assertIsNotNone(res, "'audio_dio.mp3' contém token 'dio' isolado por '_'")
        self.assertIn("02.3_Cursos_e_Certificacoes", str(res))

    def test_word_boundary_short_terms_strict(self):
        """1.4 Testa outros termos com len <= 4 ('cnh', '4k', '720p', 'yuzu')."""
        # 'cnh' <= 4 -> não deve casar com substrings
        res = self.engine.classify_file(Path("cnh_documento.pdf"))
        self.assertIsNotNone(res)
        self.assertIn("01.1_Identidade_e_Documentos", str(res))

    def test_word_boundary_blindspot_terms_over_4_chars(self):
        """1.5 VULNERABILIDADE EMPÍRICA: Termos com len > 4 em regras.json realizam raw substring match."""
        # 'cadar' tem len=5. Como len > 4, cai em `elif term_normalized in name_normalized`
        # Isso gera falso positivo em 'cadarco_de_tenis.jpg'!
        res = self.engine.classify_file(Path("cadarco_de_tenis.jpg"))
        dest_str = str(res) if res else ""
        # Documenta a colisão empírica
        cadar_false_positive = "01.4_Clareza_e_Desenvolvimento_Pessoal" in dest_str
        self.assertTrue(cadar_false_positive, "Confirmado: 'cadar' gera falso positivo em 'cadarco_de_tenis.jpg'")

    # =========================================================================
    # 2. ARTIFACTS REGEX & AUTONAMER STRESS TESTS
    # =========================================================================
    def test_autonamer_artifacts_preserves_legitimate_words(self):
        """2.1 Testa preservação de substantivos legítimos com 'copia'."""
        legitimate_cases = [
            ("fotocopiadora.pdf", "fotocopiadora.pdf"),
            ("fotocopiadora_manual.pdf", "fotocopiadora_manual.pdf"),
            ("FOTOCOPIADORA.PDF", "FOTOCOPIADORA.pdf"),
            ("fotocopia_rg.pdf", "fotocopia_rg.pdf"),
            ("copia_legal.pdf", "copia_legal.pdf"),
            ("minha_copia_legal.pdf", "minha_copia_legal.pdf"),
        ]
        for input_name, expected in legitimate_cases:
            res = AutoNamer.sanitize_name(input_name)
            self.assertEqual(res, expected, f"AutoNamer corrompeu '{input_name}' para '{res}' (esperado '{expected}')")

    def test_autonamer_artifacts_removes_clone_prefixes_and_suffixes(self):
        """2.2 Testa remoção adequada de prefixos e sufixos de cópia."""
        cleaning_cases = [
            ("Cópia de Arquivo.pdf", "Arquivo.pdf"),
            ("copia de relatorio.docx", "relatorio.docx"),
            ("CÓPIA DE PLANILHA.XLSX", "PLANILHA.xlsx"),
            ("documento - Cópia.pdf", "documento.pdf"),
            ("documento - copia.pdf", "documento.pdf"),
            ("documento - Copy.pdf", "documento.pdf"),
            ("relatorio (1).pdf", "relatorio.pdf"),
            ("relatorio [2].pdf", "relatorio.pdf"),
            ("Cópia de Teste (1).pdf", "Teste.pdf"),
            ("Cópia de Documento - Cópia (3).pdf", "Documento.pdf"),
        ]
        for input_name, expected in cleaning_cases:
            res = AutoNamer.sanitize_name(input_name)
            self.assertEqual(res, expected, f"AutoNamer falhou em limpar '{input_name}': obteve '{res}', esperado '{expected}'")

    def test_autonamer_artifacts_entire_stem_stripped(self):
        """2.3 VULNERABILIDADE EMPÍRICA: Quando o nome inteiro é o artefato (ex: 'copia.pdf' ou '(1).pdf')."""
        # Quando stem é apenas 'copia', após remoção fica '' e vira '.pdf' (hidden extension-only file)
        res_copia = AutoNamer.sanitize_name("copia.pdf")
        self.assertEqual(res_copia, ".pdf", "Confirmado: 'copia.pdf' vira '.pdf' sem fallback para 'arquivo.pdf'")
        res_num = AutoNamer.sanitize_name("(1).pdf")
        self.assertEqual(res_num, ".pdf", "Confirmado: '(1).pdf' vira '.pdf'")

    def test_autonamer_sanitize_directory(self):
        """2.4 Testa sanitização de pastas/diretórios."""
        dir_cases = [
            ("Cópia de Pasta de Teste (1)", "Pasta_de_Teste"),
            ("minha_pasta - Cópia", "minha_pasta"),
            ("Pasta de Documentos: Importantes!", "Pasta_de_Documentos_Importantes!"),
        ]
        for input_name, expected in dir_cases:
            res = AutoNamer.sanitize_directory_name(input_name)
            self.assertEqual(res, expected, f"Sanitização de pasta falhou para '{input_name}': obteve '{res}'")

    # =========================================================================
    # 3. CLEAN_EMPTY_DIRECTORIES STRESS TESTS
    # =========================================================================
    def test_clean_empty_directories_junk_combinations(self):
        """3.1 Testa pastas com combinações de metadados residuais."""
        scan_dir = self.test_root / "scan_junk"
        scan_dir.mkdir(parents=True, exist_ok=True)

        p1 = scan_dir / "folder_ini"
        p1.mkdir()
        (p1 / "desktop.ini").write_text("[.ShellClassInfo]\nIconResource=...")

        p2 = scan_dir / "folder_mac_win"
        p2.mkdir()
        (p2 / ".DS_Store").write_bytes(b"\x00\x00\x00\x01")
        (p2 / "Thumbs.db").write_bytes(b"\xd0\xcf\x11\xe0")

        p3 = scan_dir / "folder_zone"
        p3.mkdir()
        (p3 / "teste.pdf:Zone.Identifier").write_text("[ZoneTransfer]\nZoneId=3")
        (p3 / ".directory").write_text("[Desktop Entry]\nIcon=folder")

        p4 = scan_dir / "folder_with_real_file"
        p4.mkdir()
        (p4 / "desktop.ini").write_text("junk")
        (p4 / "documento_importante.txt").write_text("conteudo real")

        removed = self.engine.clean_empty_directories(scan_dir, dry_run=False)
        self.assertEqual(removed, 3, f"Deveria ter removido 3 pastas vazias, removeu {removed}")
        self.assertFalse(p1.exists(), "folder_ini não deveria existir")
        self.assertFalse(p2.exists(), "folder_mac_win não deveria existir")
        self.assertFalse(p3.exists(), "folder_zone não deveria existir")
        self.assertTrue(p4.exists(), "folder_with_real_file DEVE existir!")
        self.assertTrue((p4 / "documento_importante.txt").exists(), "documento_importante.txt DEVE existir!")

    def test_clean_empty_directories_deeply_nested(self):
        """3.2 Testa árvore aninhada bottom-up."""
        scan_dir = self.test_root / "scan_nested"
        leaf = scan_dir / "l1" / "l2" / "l3" / "l4"
        leaf.mkdir(parents=True, exist_ok=True)

        (scan_dir / "l1" / "desktop.ini").write_text("l1")
        (scan_dir / "l1" / "l2" / ".DS_Store").write_bytes(b"l2")
        (scan_dir / "l1" / "l2" / "l3" / "Thumbs.db").write_bytes(b"l3")
        (scan_dir / "l1" / "l2" / "l3" / "l4" / "desktop.ini").write_text("l4")

        removed = self.engine.clean_empty_directories(scan_dir, dry_run=False)
        self.assertEqual(removed, 4, f"Deveria ter removido 4 níveis, removeu {removed}")
        self.assertFalse((scan_dir / "l1").exists(), "Toda a árvore l1/l2/l3/l4 deveria ter sido purgada")
        self.assertTrue(scan_dir.exists(), "O diretório raiz do scan não deve ser removido")

    def test_clean_empty_directories_dry_run_safety(self):
        """3.3 Testa que dry_run não remove nada fisicamente."""
        scan_dir = self.test_root / "scan_dry_run"
        p = scan_dir / "empty_dir"
        p.mkdir(parents=True, exist_ok=True)
        (p / "desktop.ini").write_text("dummy")

        removed = self.engine.clean_empty_directories(scan_dir, dry_run=True)
        self.assertEqual(removed, 1)
        self.assertTrue(p.exists(), "No dry-run, a pasta NÃO pode ser excluída fisicamente!")
        self.assertTrue((p / "desktop.ini").exists(), "No dry-run, o arquivo NÃO pode ser excluído!")

    # =========================================================================
    # 4. SLUGIFY_FILENAME STRESS TESTS
    # =========================================================================
    def test_slugify_extreme_characters_and_emojis(self):
        """4.1 Testa caracteres extremos, acentuação, maiúsculas e emojis."""
        cases = [
            ("RELATÓRIO DE GESTÃO: 2026 #1?.PDF", "RELATORIO_DE_GESTAO_2026_1.pdf"),
            ("Ação_Judicial_ç_ã_õ_é.DOCX", "Acao_Judicial_c_a_o_e.docx"),
            ("teste;com$cifrão%e&comercial.csv", "teste_com_cifrao_e_comercial.csv"),
            ("<script>alert('xss')</script>.html", "script_alert('xss')_script.html"),
            ("   ___---arquivo---___   .pdf", "arquivo.pdf"),
            ("::::????****;;;;####$$$$", "arquivo"),
            ("relatorio_📊_financeiro_🚀.docx", "relatorio_📊_financeiro_🚀.docx"),
            ("2026-11-07_relatorio_final.pdf", "2026-11-07_relatorio_final.pdf"),
            ("2026-05-15-auditoria-tce.pdf", "2026-05-15-auditoria-tce.pdf"),
        ]
        for raw, expected in cases:
            res = slugify_filename(raw)
            self.assertEqual(res, expected, f"slugify_filename('{raw}') produziu '{res}', esperado '{expected}'")

    def test_slugify_multiple_dots(self):
        """4.2 Testa comportamento com múltiplos pontos no nome."""
        res = slugify_filename("versao.1.0.0.final.PDF")
        self.assertEqual(res, "versao.1.0.0.final.pdf")

    # =========================================================================
    # 5. ZERO-BYTE COLLISION PROTECTION STRESS TESTS
    # =========================================================================
    def test_zero_byte_collision_protection(self):
        """5.1 Simula mover arquivo de 0 bytes sobre um arquivo válido existente no destino."""
        src_dir = self.test_root / "inbox"
        dst_dir = self.test_root / "dest_legitimate"
        src_dir.mkdir(parents=True, exist_ok=True)
        dst_dir.mkdir(parents=True, exist_ok=True)

        zero_byte_src = src_dir / "dao-09.mp4"
        zero_byte_src.write_bytes(b"")
        self.assertEqual(zero_byte_src.stat().st_size, 0)

        valid_content = b"VIDEO_DATA_INTEGRO_" * 50
        dst_file = dst_dir / "dao-09.mp4"
        dst_file.write_bytes(valid_content)
        self.assertEqual(dst_file.stat().st_size, len(valid_content))

        success, msg = self.engine.move_item(zero_byte_src, dst_dir)

        # DEVE SER REJEITADO!
        self.assertFalse(success, "Mover 0-byte sobre destino válido DEVE ser rejeitado!")
        self.assertIn("0 bytes", msg)

        # Destino NÃO PODE ter sido alterado!
        self.assertTrue(dst_file.exists())
        self.assertEqual(dst_file.stat().st_size, len(valid_content), "Destino válido foi corrompido ou sobrescrito!")
        self.assertEqual(dst_file.read_bytes(), valid_content)
        self.assertTrue(zero_byte_src.exists())

    def test_zero_byte_quarantine_in_organize_directory(self):
        """5.2 Testa fluxo completo de organize_directory com arquivo 0-byte e quarentena."""
        inbox = self.test_root / "inbox_quarantine"
        quarantine = self.test_root / "quarantine"
        inbox.mkdir(parents=True, exist_ok=True)
        quarantine.mkdir(parents=True, exist_ok=True)

        engine_q = FileOrganizerEngine(
            config_path=self.config_path,
            root_user=self.test_root,
            custom_dest_root=self.dest_root,
            quarantine_dir=quarantine,
        )

        corrupt_file = inbox / "dao-09_corrupted.mp4"
        corrupt_file.write_bytes(b"")

        stats = engine_q.organize_directory(inbox, dry_run=False)
        self.assertEqual(stats.get("zero_bytes"), 1, "Deveria ter contabilizado 1 arquivo 0-byte")
        self.assertFalse(corrupt_file.exists(), "Arquivo deveria ter sido removido do inbox")
        self.assertTrue((quarantine / "dao-09_corrupted.mp4").exists(), "Arquivo deveria estar na quarentena")


if __name__ == "__main__":
    unittest.main()
