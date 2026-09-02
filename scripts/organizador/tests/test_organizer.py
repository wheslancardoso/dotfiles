"""
Testes unitários automatizados para o Organizador Master.
Execução: python -m unittest discover tests
"""

import json
import shutil
import tempfile
import unittest
from pathlib import Path

from src.core import FileOrganizerEngine
from src.history import HistoryManager
from src.partition_calc import PartitionCalculator
from src.renamer import AutoNamer
from src.taxonomy import TaxonomyManager
from src.utils import get_unique_destination_path, normalize_text


class TestOrganizadorMaster(unittest.TestCase):
    def setUp(self):
        self.test_dir = Path(tempfile.mkdtemp(prefix="test_organizador_"))
        self.config_path = self.test_dir / "test_regras.json"

        test_config = {
            "diretorios_mestre": {
                "00_inbox": "00_Inbox_Triagem",
                "01_pessoal": "01_Pessoal_e_Vida",
                "02_estudos": "02_Estudos_e_Concursos",
            },
            "subpastas_padrao": {
                "01_Pessoal_e_Vida": ["01.1_Identidade_e_Documentos", "01.2_Carreira_e_Curriculos"],
                "02_Estudos_e_Concursos": ["02.1_TCE-GO"],
            },
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


if __name__ == "__main__":
    unittest.main()
