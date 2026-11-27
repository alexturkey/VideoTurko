"""Tests for the optional speed profiles of scripts/uret.ps1 (-Profil yuksek832 | yuksek896 | uzun260).
No GPU, no network, no engine: fake card readings (VT_GPU_CC / VT_GPU_VRAM), a throw-away VT_ROOT and uret.ps1 -Kuru; the engine check
(HIZ_PAKETI.txt) is exercised without -Kuru, where it fails before any file or GPU work.

python -B -m unittest discover -s tests -p "test_hiz_profilleri.py" -v"""
import os
import re
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

KOK = Path(__file__).resolve().parents[1]
SC = KOK / "scripts"
PS = shutil.which("powershell") or "powershell.exe"
TEMIZ = ("VT_ROOT", "VT_ENGINE_BIN", "VT_ENGINE_TYPE", "VT_MODEL_DIR", "VT_PYTHON", "VT_MAX_JETON", "VT_MAX_KARE", "VT_GPU_CC", "VT_GPU_VRAM", "VT_HIZ_MOTOR",
         "VT_ERKEN_CIKIS", "VT_IKI_ASAMA", "VT_ATTN_BUDGET", "VT_CHUNK_MB", "VT_MAX_VRAM", "VT_NO_FA")


def uret(t, *args, kuru=True, ek_env=None):
    istem = Path(t) / "i.txt"
    istem.write_text("a lake", encoding="ascii")
    env = {k: v for k, v in os.environ.items() if k not in TEMIZ}
    env.update({"VT_ROOT": t, "VT_GPU_CC": "6.1", "VT_GPU_VRAM": "4096"})
    env.update(ek_env or {})
    komut = [PS, "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", str(SC / "uret.ps1"), "-Istem", str(istem)] + (["-Kuru"] if kuru else []) + list(args)
    r = subprocess.run(komut, capture_output=True, text=True, encoding="utf-8", errors="replace", env=env, timeout=150, stdin=subprocess.DEVNULL)
    return r.returncode, r.stdout + r.stderr


def asama(cikti, no):
    m = re.search(r"^ASAMA %d ortam: (.*)$" % no, cikti, re.M)
    return m.group(1) if m else ""


class Profiller(unittest.TestCase):
    def test_yuksek832_141_ortam_ve_boyut(self):
        with tempfile.TemporaryDirectory() as t:
            kod, c = uret(t, "-Profil", "yuksek832")
        self.assertEqual(kod, 0, c)
        self.assertIn("kare=141 iki_asama=True", c)
        self.assertIn("cozunurluk=832x480 jeton=16380", c)
        self.assertIn("SD_ATTN_HEAD_QKV=1", asama(c, 1))
        self.assertNotIn("SD_VAE_BLOCK_SPLIT", asama(c, 1))
        self.assertIn("SD_VAE_BLOCK_SPLIT=2", asama(c, 2))
        self.assertNotIn("SD_ATTN_HEAD_QKV", asama(c, 2))
        self.assertNotIn("SD_VRAM_SHORT_OK_MB", asama(c, 2))   # 0023 is not part of the 832x480 cell
        self.assertIn("-W 832 -H 480 --video-frames 141", c)
        for sabit in ("--steps 6", "--cfg-scale 1.0", "--seed 42"):
            self.assertIn(sabit, c)
        self.assertNotIn("tiling", c.replace("karosuz", ""))   # the tile-less VAE rule: no tiling flag is ever added

    def test_yuksek832_124_bayraksiz_olculdugu_gibi(self):
        with tempfile.TemporaryDirectory() as t:
            kod, c = uret(t, "-Profil", "yuksek832", "-Kare", "124")
        self.assertEqual(kod, 0, c)
        self.assertIn("kare=124", c)
        for ad in ("SD_ATTN_HEAD_QKV", "SD_VAE_BLOCK_SPLIT", "SD_VRAM_SHORT_OK_MB"):
            self.assertNotIn(ad, asama(c, 1) + asama(c, 2))   # the 124-frame cell was measured with no speed flags

    def test_yuksek896_124(self):
        with tempfile.TemporaryDirectory() as t:
            kod, c = uret(t, "-Profil", "yuksek896")
        self.assertEqual(kod, 0, c)
        self.assertIn("cozunurluk=896x512", c)
        self.assertIn("kare=124", c)
        self.assertIn("SD_ATTN_HEAD_QKV=1", asama(c, 1))
        self.assertIn("SD_VAE_BLOCK_SPLIT=2", asama(c, 2))

    def test_uzun260_bellege_yakin_etiketi_ve_0023_yalniz_asama_2(self):
        with tempfile.TemporaryDirectory() as t:
            kod, c = uret(t, "-Profil", "uzun260")
        self.assertEqual(kod, 0, c)
        self.assertIn("kare=260", c)
        self.assertIn("cozunurluk=640x384", c)
        self.assertNotIn("VT-W-DENEYSEL", c)               # label "conditional/experimental" is gone (user accepted the second scene)
        self.assertNotIn("KOSULLU", c)
        self.assertIn("bellege yakin", c)
        self.assertIn("2000 karakter", c)                  # the stated limit: prompts measured up to about 2000 characters
        self.assertIn("SD_ATTN_HEAD_QKV=1", asama(c, 1))
        self.assertNotIn("SD_VRAM_SHORT_OK_MB", asama(c, 1))
        self.assertIn("SD_VRAM_SHORT_OK_MB=32", asama(c, 2))
        self.assertIn("SD_VRAM_MARGIN_MB=1 ", asama(c, 2) + " ")
        self.assertNotIn("SD_BLOCK_TAIL_FUSE", asama(c, 1))   # fails together with HEAD_QKV at 260 frames

    def test_varsayilan_degismedi(self):
        with tempfile.TemporaryDirectory() as t:
            kod, c = uret(t)
        self.assertEqual(kod, 0, c)
        self.assertIn("kare=209 iki_asama=True", c)
        self.assertIn("cozunurluk=640x384 jeton=14880", c)
        for ad in ("SD_ATTN_HEAD_QKV", "SD_VAE_BLOCK_SPLIT", "SD_VRAM_SHORT_OK_MB"):
            self.assertNotIn(ad, asama(c, 1) + asama(c, 2))
        self.assertNotIn("-Profil", c)

    def test_profilsiz_uzun_kare_ve_yuksek_cozunurluk_hala_reddedilir(self):
        with tempfile.TemporaryDirectory() as t:
            kod, c = uret(t, "-Kare", "260")
            self.assertNotEqual(kod, 0)
            self.assertIn("VT-E-KARE", c)
            kod, c = uret(t, "-W", "832", "-H", "480", "-Kare", "141")
            self.assertNotEqual(kod, 0)
            self.assertIn("VT-E-BOYUT", c)
            self.assertIn("-Profil yuksek832", c)   # the refusal points to the profile

    def test_profil_reddedilenler(self):
        with tempfile.TemporaryDirectory() as t:
            for args, parca in (
                (["-Profil", "yuksek832", "-Kare", "158"], "yalniz olculen kare"),     # 158 does not fit
                (["-Profil", "yuksek832", "-Kare", "209"], "yalniz olculen kare"),
                (["-Profil", "yuksek896", "-Kare", "141"], "yalniz olculen kare"),
                (["-Profil", "uzun260", "-Kare", "209"], "yalniz olculen kare"),
                (["-Profil", "yuksek832", "-W", "640", "-H", "384"], "boyutu 832x480"),
                (["-Profil", "yuksek832", "-TekAsama"], "birlikte kullanilmaz"),
                (["-Profil", "yuksek832", "-InitImg", "x.png"], "birlikte kullanilmaz"),
                (["-Profil", "bilinmeyen"], "bilinmeyen -Profil"),
            ):
                with self.subTest(args=args):
                    kod, c = uret(t, *args)
                    self.assertNotEqual(kod, 0, c)
                    self.assertIn("VT-E-PROFIL", c)
                    self.assertIn(parca, c.replace("\r", "").replace("\n", " "))

    def test_stock_motor_profili_reddeder(self):
        with tempfile.TemporaryDirectory() as t:
            kod, c = uret(t, "-Profil", "yuksek832", ek_env={"VT_ENGINE_TYPE": "stock"})
        self.assertNotEqual(kod, 0)
        self.assertIn("VT-E-PROFIL", c)
        self.assertIn("stock", c)


class MotorKontrolu(unittest.TestCase):
    """Without -Kuru the profile checks the engine marker before any file or GPU work."""

    def marker(self, t, metin):
        d = Path(t) / "engine" / "bin"
        d.mkdir(parents=True)
        (d / "HIZ_PAKETI.txt").write_text(metin, encoding="ascii")

    def test_markersiz_motor_reddedilir(self):
        with tempfile.TemporaryDirectory() as t:
            for profil in ("yuksek832", "yuksek896", "uzun260"):
                with self.subTest(profil=profil):
                    kod, c = uret(t, "-Profil", profil, kuru=False)
                    self.assertNotEqual(kod, 0)
                    self.assertIn("VT-E-MOTOR-ESKI", c)

    def test_eksik_yamali_marker_reddedilir(self):
        with tempfile.TemporaryDirectory() as t:
            self.marker(t, "patches: 0021\n")   # 0024 is missing for the 832x480 cell
            kod, c = uret(t, "-Profil", "yuksek832", kuru=False)
        self.assertNotEqual(kod, 0)
        self.assertIn("VT-E-MOTOR-ESKI", c)
        self.assertIn("0024", c)

    def test_832_124_yamasiz_motorla_calisir(self):
        with tempfile.TemporaryDirectory() as t:
            kod, c = uret(t, "-Profil", "yuksek832", "-Kare", "124", kuru=False)
        self.assertNotIn("VT-E-MOTOR-ESKI", c)   # no patch is needed for that cell
        self.assertIn("VT-E-DOSYA", c)

    def test_tam_marker_kabul_edilir_ve_sonraki_kapiya_gecer(self):
        with tempfile.TemporaryDirectory() as t:
            self.marker(t, "patches: 0021 0023 0024\n")
            for profil in ("yuksek832", "yuksek896", "uzun260"):
                with self.subTest(profil=profil):
                    kod, c = uret(t, "-Profil", profil, kuru=False)
                    self.assertNotIn("VT-E-MOTOR-ESKI", c)
                    self.assertIn("VT-E-DOSYA", c)   # next gate: no sd-cli / model files in the throw-away root

    def test_kendi_motorum_anahtari(self):
        with tempfile.TemporaryDirectory() as t:
            kod, c = uret(t, "-Profil", "yuksek832", kuru=False, ek_env={"VT_HIZ_MOTOR": "1"})
        self.assertNotIn("VT-E-MOTOR-ESKI", c)
        self.assertIn("VT_HIZ_MOTOR=1", c)


if __name__ == "__main__":
    unittest.main()
