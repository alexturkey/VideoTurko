"""Tests for AGENTS_HIZLI.md, llms.txt and GEMINI.md (KL-18). Stdlib unittest, no network, no GPU.

    python -I -X utf8 -m unittest discover -s tests -v

The quick card must stay true: every code it names exists in docs/hata_imzalari.json, every file it links exists,
the decision tree has exactly 12 steps in both languages, and the rules an agent must not miss are still there.
"""

import json
import re
import unittest
from pathlib import Path

KOK = Path(__file__).resolve().parents[1]
HIZLI = (KOK / "AGENTS_HIZLI.md").read_text(encoding="utf-8")
BS = chr(92)


class Icerik(unittest.TestCase):
    def setUp(self):
        i = HIZLI.index("\n## T")
        self.en, self.tr = HIZLI[:i], HIZLI[i:]

    def test_iki_dil_on_iki_adim(self):
        for ad, parca in (("EN", self.en), ("TR", self.tr)):
            adimlar = re.findall(r"(?m)^(\d+)\. ", parca)
            self.assertEqual(adimlar, [str(i) for i in range(1, 13)], ad)

    def test_adlandirilan_kodlar_json_da_var_ve_iki_dilde_ayni(self):
        kodlar = {k["kod"] for k in json.loads((KOK / "docs" / "hata_imzalari.json").read_text(encoding="utf-8"))["kodlar"]}
        en = set(re.findall(r"VT-[EW]-[A-Z0-9-]+", self.en))
        tr = set(re.findall(r"VT-[EW]-[A-Z0-9-]+", self.tr))
        self.assertTrue(en, "kod yok")
        self.assertEqual(en, tr, "EN ve TR ayni kodlari anmali")
        self.assertEqual(en - kodlar, set(), "JSON'da olmayan kod")

    def test_cikis_kodu_tablosu_iki_dilde_ayni_satir_sayisi(self):
        sat = lambda p: [l for l in p.splitlines() if l.startswith("| `kur.ps1`") or l.startswith("| `uret.ps1`")]
        self.assertEqual(len(sat(self.en)), 9)
        self.assertEqual(len(sat(self.tr)), 9)

    def test_exit3_kullaniciya_goturulur_ve_zorla_yasak(self):
        for parca in (self.en, self.tr):
            satir = next(l for l in parca.splitlines() if l.startswith("| `kur.ps1` | 3 |"))
            self.assertIn("**", satir)  # kalin: kullaniciya goturulur
            self.assertIn("-Zorla", satir)
        self.assertIn("**Take it to the user**", self.en)
        self.assertIn("**Kullanıcıya götür**", self.tr)

    def test_degismez_kurallar_duruyor(self):
        for parca in (self.en, self.tr):
            for s in ("-LisansKabul E", "VT_MCP_INIT_DIR", "<ROOT>", "-Kuru", "-Zorla"):
                self.assertIn(s, parca, s)
        self.assertIn("6 steps, cfg 1", self.en)
        self.assertIn("6 adım, cfg 1", self.tr)
        self.assertIn("is ONLY a file path the user gave you", self.en)
        self.assertIn("YALNIZ kullanıcının sana verdiği dosya yoludur", self.tr)

    def test_baglanti_verilen_dosyalar_var(self):
        for yol in set(re.findall(r"\[`?([A-Za-z_./]+\.(?:md|json|txt))`?\]\(", HIZLI)) | set(re.findall(r"`((?:docs|mcp)/[A-Za-z_./]+)`", HIZLI)):
            self.assertTrue((KOK / yol).exists(), yol)

    def test_komut_satirlari_gercek_betige_isaret_eder(self):
        for m in re.findall(r"`powershell [^`]*-File (scripts" + re.escape(BS) + r"[a-z_]+\.ps1)[^`]*`", HIZLI):
            self.assertTrue((KOK / m.replace(BS, "/")).exists(), m)
        self.assertIn("-Istem docs" + BS + "ornek_istem_R0.txt -Kare 56", HIZLI)
        self.assertTrue((KOK / "docs" / "ornek_istem_R0.txt").exists())

    def test_dosya_ascii_disi_yalniz_turkce_harf_ve_lf(self):
        ham = (KOK / "AGENTS_HIZLI.md").read_bytes()
        self.assertNotIn(b"\r", ham)
        self.assertNotIn(b"\x00", ham)
        izinli = set("çÇğĞıİöÖşŞüÜ")
        for c in HIZLI:
            self.assertTrue(ord(c) < 128 or c in izinli, f"beklenmeyen karakter U+{ord(c):04X}")


class Isaretciler(unittest.TestCase):
    def test_llms_txt_bicimi_ve_baglantilari(self):
        t = (KOK / "llms.txt").read_text(encoding="utf-8")
        self.assertTrue(t.startswith("# VideoTurko\n"))
        self.assertIn("\n> ", t)
        self.assertTrue(all(ord(c) < 128 for c in t))
        for url in re.findall(r"\]\((https?://[^)]+)\)", t):
            self.assertTrue(url.startswith("https://github.com/alexturkey/VideoTurko/blob/main/"), url)
            self.assertTrue((KOK / url.split("/blob/main/")[1]).exists(), url)
        self.assertIn("AGENTS_HIZLI.md", t)
        self.assertIn("only a file path the user gave you", t)

    def test_gemini_ve_claude_isaretcisi_agents_e_bakar(self):
        for ad in ("GEMINI.md", "CLAUDE.md"):
            self.assertIn("@AGENTS.md", (KOK / ad).read_text(encoding="utf-8"), ad)

    def test_agents_md_hizli_karti_ve_init_image_kuralini_anar(self):
        a = (KOK / "AGENTS.md").read_text(encoding="utf-8")
        self.assertIn("AGENTS_HIZLI.md", a)
        self.assertIn("`init_image` is only a file path the user gave you", a)
        self.assertIn("VT_MCP_INIT_DIR", a)

    def test_agents_md_32_kib_alti_ve_lisans_kurali_acik(self):
        ham = (KOK / "AGENTS.md").read_bytes()
        self.assertLess(len(ham), 32768, "AGENTS.md 32 KiB'i gecerse bazi ajanlar sessizce keser; ayrinti docs/AGENTS_EK.md'ye")
        a = ham.decode("utf-8")
        self.assertIn("-LisansKabul", a)
        self.assertIn("ONLY after the user", a)
        self.assertTrue((KOK / "docs" / "AGENTS_EK.md").exists())
        for parca in ("RTX 50 series", "MCP server"):
            self.assertIn(parca, (KOK / "docs" / "AGENTS_EK.md").read_text(encoding="utf-8"))


if __name__ == "__main__":
    unittest.main()
