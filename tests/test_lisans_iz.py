"""Tests for the license guard in scripts/kur.ps1 (model step). Stdlib unittest, no network, no GPU, nothing is downloaded.

    python -I -X utf8 -m unittest discover -s tests -p test_lisans_iz.py -v

Rule (AGENTS.md): -LisansKabul only after the user was shown the license text and clearly said yes. The guard is a convenience and
a deterrent, NOT proof (an agent can write DURUM.md itself): when -LisansKabul is given and the input is redirected (agent, script),
<ROOT>\DURUM.md must hold a line `LISANS-KABUL: <the user's words> | <time>`. A human typing in a terminal and CI (VT_CI=1) are not affected.
The positive cases stop at the DUR file (exit 4, DURDU) right after the guard, so no model is ever downloaded.
"""

import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

KOK = Path(__file__).resolve().parents[1]
KUR = KOK / "scripts" / "kur.ps1"
PS = os.name == "nt" and shutil.which("powershell.exe")
CF = getattr(subprocess, "CREATE_NO_WINDOW", 0)


def kos(root, ek_env=None, flag=True):
    env = dict(os.environ, VT_ROOT=str(root))
    for k in ("VT_KURU_SAHTE", "VT_CI"):
        env.pop(k, None)
    env.update(ek_env or {})
    arg = ["powershell.exe", "-NoProfile", "-NonInteractive", "-ExecutionPolicy", "Bypass", "-File", str(KUR), "-Adim", "model"]
    if flag:
        arg += ["-LisansKabul", "E"]
    p = subprocess.run(arg, capture_output=True, env=env, cwd=str(KOK), creationflags=CF, timeout=120, stdin=subprocess.DEVNULL)
    return p.returncode, (p.stdout + p.stderr).decode("utf-8", "replace")


@unittest.skipUnless(PS, "Windows PowerShell gerekir")
class LisansIzi(unittest.TestCase):
    def kok(self):
        t = tempfile.mkdtemp(prefix="vt_lisans_")
        self.addCleanup(shutil.rmtree, t, True)
        Path(t, "DUR").write_text("x", encoding="ascii")   # stops right after the guard: nothing can be downloaded
        return Path(t)

    def test_izsiz_reddedilir_exit2(self):
        k = self.kok()
        kod, c = kos(k)
        self.assertEqual(kod, 2, c)
        self.assertIn("[VT-E-LISANS]", c)
        self.assertIn("DURUM.md", c)
        self.assertNotIn("DURDU", c)

    def test_iz_varsa_gecer_dur_dosyasinda_durur(self):
        k = self.kok()
        (k / "DURUM.md").write_text("# durum\n- LISANS-KABUL: evet kabul ediyorum, metni okudum | 2026-11-27 14:00\n", encoding="utf-8")
        kod, c = kos(k)
        self.assertEqual(kod, 4, c)
        self.assertIn("DURDU", c)

    def test_yer_tutucu_satir_gecmez(self):
        k = self.kok()
        (k / "DURUM.md").write_text("LISANS-KABUL: <kullanicinin sozu> | <saat>\n", encoding="utf-8")
        kod, c = kos(k)
        self.assertEqual(kod, 2, c)

    def test_bos_soz_gecmez(self):
        k = self.kok()
        (k / "DURUM.md").write_text("LISANS-KABUL:\nbaska satir\n", encoding="utf-8")
        kod, c = kos(k)
        self.assertEqual(kod, 2, c)

    def test_ci_degiskeni_korumayi_atlar(self):
        k = self.kok()
        kod, c = kos(k, {"VT_CI": "1"})
        self.assertEqual(kod, 4, c)
        self.assertIn("DURDU", c)

    def test_bayraksiz_calisma_etkilenmez(self):
        k = self.kok()
        (k / "DUR").unlink()
        kod, c = kos(k, flag=False)
        self.assertEqual(kod, 2, c)                    # no flag: the old path, the prompt cannot be answered, exit 2
        self.assertIn("[VT-E-LISANS]", c)
        self.assertNotIn("DURUM.md", c)                # the old message, not the guard's

    def test_kuru_etkilenmez(self):
        k = self.kok()
        (k / "DUR").unlink()                           # -Kuru must run to the end without the stop file
        env = dict(os.environ, VT_ROOT=str(k))
        env.pop("VT_KURU_SAHTE", None)
        p = subprocess.run(["powershell.exe", "-NoProfile", "-NonInteractive", "-ExecutionPolicy", "Bypass", "-File", str(KUR), "-Kuru",
                            "-Adim", "model", "-LisansKabul", "E"], capture_output=True, env=env, cwd=str(KOK), creationflags=CF,
                           timeout=120, stdin=subprocess.DEVNULL)
        self.assertEqual(p.returncode, 0, (p.stdout + p.stderr).decode("utf-8", "replace")[-500:])

    def test_betik_ascii_ve_kural_belgede(self):
        self.assertTrue(all(b < 128 for b in KUR.read_bytes()))
        a = (KOK / "AGENTS.md").read_text(encoding="utf-8")
        h = (KOK / "AGENTS_HIZLI.md").read_text(encoding="utf-8")
        for metin in (a, h):
            self.assertIn("LISANS-KABUL:", metin)


if __name__ == "__main__":
    unittest.main()
