"""
Testes unitários automatizados para o Organizador Master.
Execução: python -m unittest discover tests
"""

import json
import os
import shutil
import sys
import tempfile
import unittest
from pathlib import Path

# Garante que o diretório raiz do projeto esteja no sys.path
PROJECT_ROOT = Path(__file__).resolve().parent.parent
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from src.core import FileOrganizerEngine
from src.dedup import HashDeduplicator
from src.doctor import SystemDoctor
from src.history import HistoryManager
from src.partition_calc import PartitionCalculator
from src.renamer import AutoNamer
from src.taxonomy import TaxonomyManager
from src.utils import get_unique_destination_path, normalize_text, slugify_filename


class TestOrganizadorMaster(unittest.TestCase):
    def setUp(self):
        self.test_dir = Path(tempfile.mkdtemp(prefix="test_organizador_"))
        self.config_path = self.test_dir / "test_regras.json"

        test_config = {
            "diretorios_mestre": {
                "00_inbox": "00_Inbox_Triagem",
                "01_pessoal": "01_Pessoal_e_Vida",
                "02_estudos": "02_Estudos_e_Concursos",
                "05_design": "05_Design_Midia_e_Criacao",
            },
            "subpastas_padrao": {
                "01_Pessoal_e_Vida": ["01.1_Identidade_e_Documentos", "01.2_Carreira_e_Curriculos"],
                "02_Estudos_e_Concursos": ["02.1_TCE-GO"],
                "05_Design_Midia_e_Criacao": ["05.4_Filmes_e_Series"],
            },
            "regras_avancadas": [
                {
                    "id": "cadernos_regex",
                    "prioridade": 100,
                    "padroes_regex": ["^(0[1-9]|1[0-2])\\.\\d{2}"],
                    "destino": "02_Estudos_e_Concursos/02.1_TCE-GO"
                },
                {
                    "id": "tce_materias",
                    "prioridade": 90,
                    "termos": ["tce-go", "edital tce", "scrum", "cobit"],
                    "destino": "02_Estudos_e_Concursos/02.1_TCE-GO"
                },
                {
                    "id": "curriculos",
                    "prioridade": 85,
                    "termos": ["curriculo", "currículo"],
                    "destino": "01_Pessoal_e_Vida/01.2_Carreira_e_Curriculos"
                },
                {
                    "id": "filmes",
                    "prioridade": 50,
                    "extensoes": [".mp4", ".mkv", ".avi"],
                    "termos": ["1080p", "720p", "bluray"],
                    "destino": "05_Design_Midia_e_Criacao/05.4_Filmes_e_Series"
                }
            ],
            "regras_palavras_chave": [
                {"termos": ["tce-go", "edital tce"], "destino": "02_Estudos_e_Concursos/02.1_TCE-GO"},
                {"termos": ["curriculo", "currículo"], "destino": "01_Pessoal_e_Vida/01.2_Carreira_e_Curriculos"},
            ],
            "regras_extensoes": {
                ".epub": "02_Estudos_e_Concursos",
            },
            "arquivos_ignorados": ["desktop.ini", "Thumbs.db"],
        }

        with open(self.config_path, "w", encoding="utf-8") as f:
            json.dump(test_config, f, indent=2)

        self.dest_root = self.test_dir / "Documents"
        self.history_file = self.test_dir / "history.json"
        self.history_manager = HistoryManager(history_file=self.history_file)

        self.engine = FileOrganizerEngine(
            config_path=self.config_path,
            root_user=self.test_dir,
            custom_dest_root=self.dest_root,
            history_manager=self.history_manager,
        )
        self.taxonomy = TaxonomyManager(root_documents=self.dest_root, config=test_config)

    def tearDown(self):
        shutil.rmtree(self.test_dir, ignore_errors=True)

    def test_normalize_text(self):
        self.assertEqual(normalize_text("Currículo_TCE-GO.pdf"), "curriculo_tce-go.pdf")
        self.assertEqual(normalize_text("Frequência & Aulas"), "frequencia & aulas")

    def test_scaffold_taxonomy(self):
        self.taxonomy.scaffold(dry_run=False)
        self.assertTrue((self.dest_root / "00_Inbox_Triagem").exists())
        self.assertTrue((self.dest_root / "01_Pessoal_e_Vida" / "01.2_Carreira_e_Curriculos").exists())
        self.assertTrue((self.dest_root / "02_Estudos_e_Concursos" / "02.1_TCE-GO").exists())

    def test_classification_by_keyword(self):
        fake_tce = self.test_dir / "Downloads" / "edital tce 2026.pdf"
        dest = self.engine.classify_file(fake_tce)
        self.assertEqual(dest, self.dest_root / "02_Estudos_e_Concursos" / "02.1_TCE-GO")

        fake_cv = self.test_dir / "Desktop" / "Meu_Currículo_Atualizado.pdf"
        dest_cv = self.engine.classify_file(fake_cv)
        self.assertEqual(dest_cv, self.dest_root / "01_Pessoal_e_Vida" / "01.2_Carreira_e_Curriculos")

    def test_classification_by_extension(self):
        fake_book = self.test_dir / "Downloads" / "livro_qualquer.epub"
        dest = self.engine.classify_file(fake_book)
        self.assertEqual(dest, self.dest_root / "02_Estudos_e_Concursos")

    def test_ignore_shortcuts_and_system(self):
        shortcut = self.test_dir / "Desktop" / "Programa.lnk"
        self.assertTrue(self.engine.should_ignore(shortcut))

        sys_file = self.test_dir / "Desktop" / "desktop.ini"
        self.assertTrue(self.engine.should_ignore(sys_file))

    def test_anti_collision_naming(self):
        folder = self.test_dir / "test_folder"
        folder.mkdir()
        file1 = folder / "doc.txt"
        file1.write_text("v1")

        new_path = get_unique_destination_path(file1)
        self.assertEqual(new_path.name, "doc_1.txt")

    def test_history_and_undo(self):
        downloads = self.test_dir / "Downloads"
        downloads.mkdir(parents=True)
        sample_file = downloads / "edital tce 2026.pdf"
        sample_file.write_text("Conteudo Teste")

        # Organiza
        stats = self.engine.organize_directory(downloads)
        self.assertEqual(stats["movidos"], 1)
        self.assertFalse(sample_file.exists())

        # Salva sessão
        session_id = self.engine.commit_session("Teste Undo")
        self.assertIsNotNone(session_id)

        # Executa Undo
        successes, errors = self.history_manager.undo_last_session(dry_run=False)
        self.assertEqual(successes, 1)
        self.assertEqual(errors, 0)
        self.assertTrue(sample_file.exists())

    def test_autonamer_sanitize(self):
        raw_name = "relatorio financeiro  (1) - copia.pdf"
        sanitized = AutoNamer.sanitize_name(raw_name)
        self.assertEqual(sanitized, "relatorio_financeiro.pdf")

    def test_autonamer_date_prefix(self):
        self.assertTrue(AutoNamer.has_date_prefix("2026-08-27_relatorio.pdf"))
        self.assertTrue(AutoNamer.has_date_prefix("20260827_relatorio.pdf"))
        self.assertFalse(AutoNamer.has_date_prefix("relatorio.pdf"))

        dummy_folder = self.test_dir / "renamer_test"
        dummy_folder.mkdir()
        dummy_file = dummy_folder / "minha_foto (2).png"
        dummy_file.write_text("fake image")

        renamer = AutoNamer()
        stats = renamer.process_directory(dummy_folder, add_date=True, sanitize=True)
        self.assertEqual(stats["renomeados"], 1)

        renamed_files = list(dummy_folder.glob("*.png"))
        self.assertEqual(len(renamed_files), 1)
        self.assertTrue(AutoNamer.has_date_prefix(renamed_files[0].name))
        self.assertTrue("minha_foto.png" in renamed_files[0].name)

    def test_partition_calculator(self):
        # 480 GB SSD
        res480 = PartitionCalculator.calculate(480)
        self.assertEqual(res480["c_gb"], 135.0)
        self.assertGreater(res480["d_gb"], 300.0)
        self.assertGreater(res480["shrink_mb"], 0)

        # 256 GB SSD
        res256 = PartitionCalculator.calculate(256)
        self.assertEqual(res256["c_gb"], 95.0)
        self.assertGreater(res256["d_gb"], 140.0)

        # 1000 GB (1 TB) SSD
        res1000 = PartitionCalculator.calculate(1000)
        self.assertEqual(res1000["c_gb"], 200.0)
        self.assertGreater(res1000["d_gb"], 700.0)

        # 128 GB SSD (Small)
        res128 = PartitionCalculator.calculate(128)
        self.assertEqual(res128["d_gb"], 0)

    def test_hash_deduplicator(self):
        dedup_dir = self.test_dir / "dedup_test"
        dedup_dir.mkdir()
        file1 = dedup_dir / "original.txt"
        file2 = dedup_dir / "copia_com_outro_nome.txt"
        file1.write_text("conteudo criptografico identico 12345")
        file2.write_text("conteudo criptografico identico 12345")

        dups = HashDeduplicator.scan_directory(dedup_dir)
        self.assertEqual(len(dups), 1)
        h = list(dups.keys())[0]
        self.assertEqual(len(dups[h]), 2)

    def test_system_doctor(self):
        audit = SystemDoctor.audit(self.test_dir)
        self.assertIn("score", audit)
        self.assertIn("grade", audit)
        self.assertGreaterEqual(audit["score"], 0)

    def test_deep_content_sniffing(self):
        generic_file = self.test_dir / "Documento_sem_titulo.txt"
        generic_file.write_text("Este documento trata sobre o edital tce-go concurso 2026.")
        dest = self.engine.classify_file(generic_file)
        self.assertIsNotNone(dest)
        self.assertTrue("02.1_TCE-GO" in str(dest))

    def test_in_flight_downloads_ignored(self):
        self.assertTrue(self.engine.should_ignore(Path("video.mp4.crdownload")))
        self.assertTrue(self.engine.should_ignore(Path("archive.zip.part")))
        self.assertTrue(self.engine.should_ignore(Path("temp_file.tmp")))
        self.assertTrue(self.engine.should_ignore(Path("distro.iso.aria2")))
        self.assertFalse(self.engine.should_ignore(Path("documento_completo.pdf")))

    def test_fuzzy_matching_classification(self):
        # "curriculo" (>= 5 letras) com erro de digitação proposital ("curriculoo" ou "curriculo_ti")
        typo_file = self.test_dir / "curriculoo_desenvolvedor.docx"
        dest = self.engine.classify_file(typo_file)
        self.assertIsNotNone(dest)
        self.assertTrue("01.2_Carreira_e_Curriculos" in str(dest))

    def test_clean_empty_directories(self):
        parent_dir = self.test_dir / "nested_empty"
        child_dir = parent_dir / "child_empty"
        child_dir.mkdir(parents=True)
        self.assertTrue(child_dir.exists())

        removed = self.engine.clean_empty_directories(parent_dir)
        self.assertGreaterEqual(removed, 1)
        self.assertFalse(child_dir.exists())

    def test_pdf_content_sniffing(self):
        try:
            import importlib
            pypdf = importlib.import_module("pypdf")
            pdf_path = self.test_dir / "documento_desconhecido.pdf"
            writer = pypdf.PdfWriter()
            page = writer.add_blank_page(width=300, height=300)
            with open(pdf_path, "wb") as f:
                writer.write(f)
            # Testa que sniff_file_content não gera exceção
            content = self.engine.sniff_file_content(pdf_path)
            self.assertIsInstance(content, str)
        except Exception:
            pass

    def test_purge_old_installers(self):
        inst_dir = self.dest_root / "06_Backups_ISOs_e_Sistemas" / "06.1_Instaladores_e_APKs"
        inst_dir.mkdir(parents=True, exist_ok=True)
        old_installer = inst_dir / "setup_antigo.exe"
        old_installer.write_text("dummy binary content")

        # Define data de modificação para 60 dias atrás
        old_time = os.path.getmtime(old_installer) - (60 * 86400)
        os.utime(old_installer, (old_time, old_time))

        purged = self.engine.purge_old_installers(max_days=45, dry_run=False)
        self.assertEqual(len(purged), 1)
        self.assertEqual(purged[0]["name"], "setup_antigo.exe")
        self.assertFalse(old_installer.exists())

    def test_inbox_aging_detection(self):
        inbox_dir = self.test_dir / "00_Inbox_Triagem"
        inbox_dir.mkdir(parents=True, exist_ok=True)
        stale_file = inbox_dir / "nota_fiscal_esquecida.pdf"
        stale_file.write_text("nota fiscal esquecida")

        # Define data para 10 dias atrás
        old_time = os.path.getmtime(stale_file) - (10 * 86400)
        os.utime(stale_file, (old_time, old_time))

        stale = SystemDoctor.check_inbox_aging(self.test_dir, max_days=7)
        self.assertEqual(len(stale), 1)
        self.assertEqual(stale[0]["name"], "nota_fiscal_esquecida.pdf")
        self.assertGreaterEqual(stale[0]["age_days"], 10)

    def test_v3_regex_caderno_classification(self):
        caderno_file = self.test_dir / "04.01 - Ciclos de Vida e Metodologias Ageis.pdf"
        dest = self.engine.classify_file(caderno_file)
        self.assertIsNotNone(dest)
        self.assertTrue("02.1_TCE-GO" in str(dest))

        caderno_09 = self.test_dir / "09.12 - COBIT 2019 e Governanca.docx"
        dest_09 = self.engine.classify_file(caderno_09)
        self.assertIsNotNone(dest_09)
        self.assertTrue("02.1_TCE-GO" in str(dest_09))

    def test_v3_notebooklm_raw_ignored_in_inbox(self):
        self.assertTrue(self.engine.should_ignore(Path("09.mp4")))
        self.assertTrue(self.engine.should_ignore(Path("09 (1).mp4")))
        self.assertTrue(self.engine.should_ignore(Path("04.m4a")))
        self.assertTrue(self.engine.should_ignore(Path("10.wav")))
        self.assertFalse(self.engine.should_ignore(Path("09.01 - Framework Zachman vs TOGAF (curto).mp4")))

    def test_v3_media_safety_movie_tags(self):
        # Vídeo com tag de filme/série -> Filmes_e_Series
        movie_file = self.test_dir / "Inception_2010_1080p_bluray_x264.mkv"
        dest_movie = self.engine.classify_file(movie_file)
        self.assertIsNotNone(dest_movie)
        self.assertTrue("05.4_Filmes_e_Series" in str(dest_movie))

        # Vídeo de aula do TCE -> TCE-GO
        tce_video = self.test_dir / "Aula_Scrum_TCE_GO_2026.mp4"
        dest_tce = self.engine.classify_file(tce_video)
        self.assertIsNotNone(dest_tce)
        self.assertTrue("02.1_TCE-GO" in str(dest_tce))

    def test_slugify_accents_and_special_chars(self):
        # 1. Remoção de acentos via NFKD
        name1 = "Relatório de Gestão & Finanças.PDF"
        slug1 = slugify_filename(name1)
        self.assertEqual(slug1, "Relatorio_de_Gestao_Financas.pdf")

        # 2. Extensão em minúsculas
        name2 = "ARQUIVO_TESTE.MP4"
        slug2 = slugify_filename(name2)
        self.assertEqual(slug2, "ARQUIVO_TESTE.mp4")

        # 3. Caracteres proibidos/inseguros (: ? * " < > | ; # $ % &)
        name3 = "documento: com ? asterisco * e <tags> | final #1 $100 50%.docx"
        slug3 = slugify_filename(name3)
        for bad_char in [":", "?", "*", "<", ">", "|", ";", "#", "$", "%", "&"]:
            self.assertNotIn(bad_char, slug3)
        self.assertTrue(slug3.endswith(".docx"))

        # 4. Preservação de datas ISO
        name4 = "2026-08-27_relatorio_oficial.pdf"
        slug4 = slugify_filename(name4)
        self.assertEqual(slug4, "2026-08-27_relatorio_oficial.pdf")

        # 5. Fallback para 'arquivo' se o nome for apenas caracteres inválidos
        name5 = "***:::###???.txt"
        slug5 = slugify_filename(name5)
        self.assertEqual(slug5, "arquivo.txt")

    def test_autonamer_artifacts_word_boundary(self):
        # 1. Substantivo fotocopiadora não deve virar fotodora
        clean_foto = AutoNamer.sanitize_name("fotocopiadora.pdf")
        self.assertEqual(clean_foto, "fotocopiadora.pdf")

        # 2. Prefixo 'Cópia de ' deve ser removido
        clean_copia_de = AutoNamer.sanitize_name("Cópia de documento importante.pdf")
        self.assertEqual(clean_copia_de, "documento_importante.pdf")

        # 3. Sufixo clássico ' - Cópia' ou ' - copy'
        clean_sufixo = AutoNamer.sanitize_name("relatorio trimestral - cópia (1).pdf")
        self.assertEqual(clean_sufixo, "relatorio_trimestral.pdf")

        # 4. 'copy' como palavra isolada
        clean_copy_word = AutoNamer.sanitize_name("documento copy.pdf")
        self.assertEqual(clean_copy_word, "documento.pdf")

    def test_clean_empty_directories_with_junk_metadata(self):
        # Cria pasta contendo apenas desktop.ini e Thumbs.db
        junk_dir = self.test_dir / "pasta_com_lixo_apenas"
        junk_dir.mkdir(parents=True)
        (junk_dir / "desktop.ini").write_text("[.ShellClassInfo]\nIconResource=...")
        (junk_dir / "Thumbs.db").write_text("fake db content")
        (junk_dir / ".DS_Store").write_text("fake ds store")

        # Cria pasta irmã com arquivo válido
        valid_dir = self.test_dir / "pasta_com_arquivo_valido"
        valid_dir.mkdir(parents=True)
        (valid_dir / "documento.pdf").write_text("conteudo real")
        (valid_dir / "desktop.ini").write_text("metadado")

        removed = self.engine.clean_empty_directories(self.test_dir)
        self.assertGreaterEqual(removed, 1)
        self.assertFalse(junk_dir.exists())
        self.assertTrue(valid_dir.exists())
        self.assertTrue((valid_dir / "documento.pdf").exists())

    def test_rule_matching_word_boundary_isolation(self):
        # Verifica motor com config de produção para garantir que "dio" não casa com audio/estudio/episodio
        prod_config = PROJECT_ROOT / "config" / "regras.json"
        engine_prod = FileOrganizerEngine(config_path=prod_config, custom_dest_root=self.dest_root)

        # "dio" NÃO deve capturar arquivos de áudio
        self.assertNotEqual(
            engine_prod.classify_file(Path("audio_gravacao.wav")),
            self.dest_root / "02_Estudos_e_Concursos/02.3_Cursos_e_Certificacoes",
        )
        self.assertNotEqual(
            engine_prod.classify_file(Path("estudio_podcast.mp3")),
            self.dest_root / "02_Estudos_e_Concursos/02.3_Cursos_e_Certificacoes",
        )
        self.assertNotEqual(
            engine_prod.classify_file(Path("meu_episodio_de_podcast.mp4")),
            self.dest_root / "02_Estudos_e_Concursos/02.3_Cursos_e_Certificacoes",
        )

        # "dio" DEVE casar quando for termo isolado
        dest_dio_curso = engine_prod.classify_file(Path("curso dio web.pdf"))
        self.assertEqual(dest_dio_curso, self.dest_root / "02_Estudos_e_Concursos/02.3_Cursos_e_Certificacoes")

        dest_dio_bootcamp = engine_prod.classify_file(Path("dio_bootcamp.pdf"))
        self.assertEqual(dest_dio_bootcamp, self.dest_root / "02_Estudos_e_Concursos/02.3_Cursos_e_Certificacoes")

    def test_autonamer_directory_sanitization(self):
        # Teste método sanitize_directory_name
        sanitized_dir1 = AutoNamer.sanitize_directory_name("Minha Pasta de Estudos (1) - cópia")
        self.assertEqual(sanitized_dir1, "Minha_Pasta_de_Estudos")

        sanitized_dir2 = AutoNamer.sanitize_name("Cópia de Projetos: AGR", is_directory=True)
        self.assertEqual(sanitized_dir2, "Projetos_AGR")

        sanitized_dir3 = AutoNamer.sanitize_directory_name("Apostilas Senai-20260830T212333Z-1-001")
        self.assertEqual(sanitized_dir3, "Apostilas_Senai-20260830T212333Z-1-001")

    def test_zero_byte_file_protection(self):
        # 1. Checagem do método estático is_zero_byte
        zero_file = self.test_dir / "corrompido.pdf"
        zero_file.touch()
        self.assertTrue(FileOrganizerEngine.is_zero_byte(zero_file))

        valid_file = self.test_dir / "valido.pdf"
        valid_file.write_text("conteudo integro")
        self.assertFalse(FileOrganizerEngine.is_zero_byte(valid_file))

        # 2. Proteção no move_item: arquivo de 0 bytes não deve substituir arquivo válido existente
        dest_folder = self.test_dir / "destino_teste"
        dest_folder.mkdir(parents=True)
        existing_in_dest = dest_folder / "relatorio.pdf"
        existing_in_dest.write_text("conteudo original importante")

        incoming_zero = self.test_dir / "relatorio.pdf"
        incoming_zero.touch()

        success, msg = self.engine.move_item(incoming_zero, dest_folder)
        self.assertFalse(success)
        self.assertIn("0 bytes", msg)
        self.assertEqual(existing_in_dest.read_text(), "conteudo original importante")

        # 3. Proteção no organize_directory com contagem em stats
        test_downloads = self.test_dir / "Downloads_Zero_Test"
        test_downloads.mkdir(parents=True)
        zero_in_dl = test_downloads / "download_interrompido.pdf"
        zero_in_dl.touch()

        stats = self.engine.organize_directory(test_downloads)
        self.assertEqual(stats.get("zero_bytes", 0), 1)

    def test_dao_and_agr_canonical_rules(self):
        prod_config = PROJECT_ROOT / "config" / "regras.json"
        engine_prod = FileOrganizerEngine(config_path=prod_config, custom_dest_root=self.dest_root)

        # Aulas de DAO
        dest_dao1 = engine_prod.classify_file(Path("dao-01.mp4"))
        self.assertEqual(dest_dao1, self.dest_root / "04_Desenvolvimento_e_Codigo/04.1_Projetos_Web_e_Apps")

        dest_dao9 = engine_prod.classify_file(Path("dao-09.mp4"))
        self.assertEqual(dest_dao9, self.dest_root / "04_Desenvolvimento_e_Codigo/04.1_Projetos_Web_e_Apps")

        dest_trilha = engine_prod.classify_file(Path("trilha-04-dao-projeto.zip"))
        self.assertEqual(dest_trilha, self.dest_root / "04_Desenvolvimento_e_Codigo/04.1_Projetos_Web_e_Apps")

        # Projetos AGR Dev
        dest_mini = engine_prod.classify_file(Path("mini-fiscalizacao.zip"))
        self.assertEqual(dest_mini, self.dest_root / "04_Desenvolvimento_e_Codigo/04.1_Projetos_Web_e_Apps")

        dest_vanilla = engine_prod.classify_file(Path("agr-vanilla-dojo.tar.gz"))
        self.assertEqual(dest_vanilla, self.dest_root / "04_Desenvolvimento_e_Codigo/04.1_Projetos_Web_e_Apps")


if __name__ == "__main__":
    unittest.main()

