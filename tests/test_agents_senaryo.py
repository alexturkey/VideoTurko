"""The quick card is EXECUTED, not just read (KL-18 invention "ya soyle olsaydi"): AGENTS_HIZLI.md says which exit code and
which VT-E code go together; here the real scripts are run in dry mode with fake states and the card must agree.

    python -I -X utf8 -m unittest discover -s tests -v

Windows PowerShell only (skipped elsewhere). Only `kur.ps1 -Kuru` (fake state via VT_KURU_SAHTE, never active without
-Kuru) and `uret.ps1 -Kuru` with bad input run: no download, no GPU, a throw-away VT_ROOT, nothing written there.
If a script starts to answer with another exit code or code, the card is lying and this test goes red.
"""

import os
import re
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

KOK = Path(__file__).resolve().parents[1]
PS = shutil.which("powershell")
CF = getattr(subprocess, "CREATE_NO_WINDOW", 0)
HIZLI = (KOK / "AGENTS_HIZLI.md").read_text(encoding="utf-8")
GOOD = "disk=100;ram=16;bos_ram=12;vc=var;python=var;gpu=GTX;vram=4096;cc=6.1"


def satir(parca, betik, cikis):
    """Codes named in the card row for (script, exit code); the row starts with | `betik` | cikis |."""
    for l in parca.splitlines():
        if l.startswith(f"| `{betik}` | {cikis} |"):
            return set(re.findall(r"VT-[EW]-[A-Z0-9-]+", l))
    raise AssertionError(f"card has no row for {betik} exit {cikis}")


def kos(betik, *arg, sahte=None):
    with tempfile.TemporaryDirectory(prefix="vt_senaryo_") as td:
        env = dict(os.environ, VT_ROOT=td)
        env.pop("VT_KURU_SAHTE", None)
        if sahte:
            env["VT_KURU_SAHTE"] = sahte
        p = subprocess.run([PS, "-NoProfile", "-NonInteractive", "-ExecutionPolicy", "Bypass", "-File",
                            str(KOK / "scripts" / betik), *arg], capture_output=True, env=env, timeout=180,
                           cwd=str(KOK), creationflags=CF)
        out = (p.stdout + p.stderr).decode("utf-8", "replace")
        return p.returncode, set(re.findall(r"\[(VT-E-[A-Z0-9-]+)\]", out)), \
            out, sorted(os.listdir(td))


@unittest.skipUnless(os.name == "nt" and PS, "Windows PowerShell needed")
class KartCalisiyor(unittest.TestCase):
    def kapi_kur(self, sahte, beklenen_kod):
        cikis, kodlar, out, yazilan = kos("kur.ps1", "-Kuru", "-Adim", "kontrol0", sahte=sahte)
        self.assertEqual(cikis, 3, out[-600:])
        self.assertIn(beklenen_kod, kodlar, out[-600:])
        for dil in (HIZLI.split("\n## T")[0], "\n## T" + HIZLI.split("\n## T")[1]):
            self.assertEqual(kodlar - satir(dil, "kur.ps1", 3), set(), f"card lacks a code the script printed: {kodlar}")
        self.assertEqual(yazilan, [], "dry run wrote files")

    def test_kur_disk_yetmez_exit3(self):
        self.kapi_kur(GOOD.replace("disk=100", "disk=10"), "VT-E-DISK")

    def test_kur_ram_yetmez_exit3(self):
        self.kapi_kur(GOOD.replace("ram=16;bos_ram=12", "ram=8;bos_ram=2"), "VT-E-RAM")

    def test_kur_gpu_yok_exit3(self):
        self.kapi_kur(GOOD.replace("gpu=GTX", "gpu=yok"), "VT-E-GPU")

    def test_kur_vram_az_exit3(self):
        self.kapi_kur(GOOD.replace("vram=4096", "vram=3000"), "VT-E-GPU-VRAM")

    def test_kur_eski_kart_exit3(self):
        self.kapi_kur(GOOD.replace("cc=6.1", "cc=5.2"), "VT-E-GPU-CC")

    def test_kur_saglam_durum_exit0(self):
        cikis, kodlar, out, _ = kos("kur.ps1", "-Kuru", "-Adim", "kontrol0", sahte=GOOD)
        self.assertEqual(cikis, 0, out[-600:])
        self.assertEqual(kodlar, set())

    def uret_hata(self, beklenen_kod, *arg):
        cikis, _, out, yazilan = kos("uret.ps1", "-Kuru", *arg)
        self.assertEqual(cikis, 1, out[-600:])
        self.assertIn(beklenen_kod, set(re.findall(r"VT-E-[A-Z0-9-]+", out)), out[-600:])
        for dil in (HIZLI.split("\n## T")[0], "\n## T" + HIZLI.split("\n## T")[1]):
            self.assertIn(beklenen_kod, satir(dil, "uret.ps1", 1))
        self.assertEqual(yazilan, [], "dry run wrote files")

    def test_uret_kare_gecersiz_exit1(self):
        self.uret_hata("VT-E-KARE", "-Istem", str(KOK / "docs" / "ornek_istem_R0.txt"), "-Kare", "57")

    def test_uret_boyut_gecersiz_exit1(self):
        self.uret_hata("VT-E-BOYUT", "-Istem", str(KOK / "docs" / "ornek_istem_R0.txt"), "-Kare", "56", "-W", "700",
                       "-H", "384")

    def test_uret_kare_39_gecerli_40_gecersiz(self):
        """Issue #23: the docs list 39 as a valid frame count (17k+5 grid from 5); the script agrees: 39 passes, 40 is VT-E-KARE."""
        cikis, _, out, _ = kos("uret.ps1", "-Kuru", "-Istem", str(KOK / "docs" / "ornek_istem_R0.txt"), "-Kare", "39")
        self.assertEqual(cikis, 0, out[-600:])
        self.uret_hata("VT-E-KARE", "-Istem", str(KOK / "docs" / "ornek_istem_R0.txt"), "-Kare", "40")

    def test_uret_ilk_video_komutu_kabul_edilir_exit0(self):
        cikis, _, out, _ = kos("uret.ps1", "-Kuru", "-Istem", str(KOK / "docs" / "ornek_istem_R0.txt"), "-Kare", "56")
        self.assertEqual(cikis, 0, out[-600:])


if __name__ == "__main__":
    unittest.main()
