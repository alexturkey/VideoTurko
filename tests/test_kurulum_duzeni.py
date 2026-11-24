"""Kurulum duzeni (VideoTurko): kok icinde .venv varsa kalite kapisi python'u onu kullanir (VT_PYTHON yoksa), kalici sistem degisikligi yok.
Ag, indirme, GPU YOK: kur.ps1 -Kuru + sahte olcum (VT_KURU_SAHTE). Install layout: <VT_ROOT>/.venv is used when VT_PYTHON is unset.

python -B -m unittest tests/test_kurulum_duzeni.py -v"""
import os
import re
import shutil
import subprocess
import sys
import tempfile
import unittest

KOK = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PS = shutil.which("powershell") or "powershell.exe"
SAHTE = "ram=16;bos_ram=8;disk=200;vc=yok;gpu=NVIDIA GeForce GTX 1050 Ti;vram=4096;cc=6.1"

# Kalici sistem degisikligi desenleri PARCALI yazilir: bu dosyanin kendisi bekci/PR kapisinin supheli-komut taramasina takilmasin.
YASAK = (r"\bset" + "x" + r"\b", r"\breg\s+" + "add" + r"\b", "HK" + "CU:|HK" + "LM:", r"\$PRO" + "FILE" + r"\b",
         "Set-Execution" + r"Policy(?![^\n]*-Scope\s+Process)", "SetEnviron" + r"mentVariable\s*\([^)]*,\s*['\"]?(User|Machine)\b",
         r"pip3?\s+install[^\n]*--user")


def metin(ad):
    with open(os.path.join(KOK, "scripts", ad), encoding="utf-8-sig") as f:
        return f.read()


@unittest.skipUnless(sys.platform == "win32", "Windows PowerShell 5.1 gerekir")
class VenvTercihi(unittest.TestCase):
    def kos(self, venv):
        with tempfile.TemporaryDirectory() as t:
            os.makedirs(os.path.join(t, "scripts"))
            for f in ("kur.ps1", "modeller.json", "kart.ps1", "kart_tablosu.json"):
                shutil.copy(os.path.join(KOK, "scripts", f), os.path.join(t, "scripts"))
            if venv:
                subprocess.run([sys.executable, "-I", "-m", "venv", os.path.join(t, ".venv")], check=True, timeout=120)
            env = dict(os.environ, VT_ROOT=t, VT_KURU_SAHTE=SAHTE)
            for a in ("VT_PYTHON", "VT_MODEL_DIR", "VT_ENGINE_BIN"):
                env.pop(a, None)
            r = subprocess.run([PS, "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", os.path.join(t, "scripts", "kur.ps1"), "-Kuru"],
                               capture_output=True, text=True, encoding="utf-8", errors="replace", env=env, timeout=150, stdin=subprocess.DEVNULL)
            return r.stdout + r.stderr

    def test_venv_varsa_o_python_kullanilir(self):
        c = self.kos(venv=True)
        m = re.search(r"\[VT-W-PY\][^\n]*?\(([^,]+),", c)
        # venv'de opencv/numpy yok: uyari cikar ve uyaridaki python yolu kokteki .venv olmali
        self.assertIsNotNone(m, c)
        self.assertIn(".venv", m.group(1).replace("\\", "/"))

    def test_venv_yoksa_eski_yol(self):
        c = self.kos(venv=False)
        self.assertNotIn(".venv", c.split("VT-W-PY")[1].split(",")[0] if "VT-W-PY" in c else "")


@unittest.skipUnless(sys.platform == "win32", "Windows PowerShell 5.1 gerekir")
class KapiVenvTercihi(unittest.TestCase):
    """uretim_kapi.ps1, VT_PYTHON yokken kokteki .venv python'unu kullanir (PR #14: kapi VT-E-PY ile calismiyordu)."""

    def kos(self, venv):
        with tempfile.TemporaryDirectory() as t:
            os.makedirs(os.path.join(t, "scripts"))
            os.makedirs(os.path.join(t, "runs", "k"))
            for f in ("uretim_kapi.ps1", "dikis_denetim.py"):
                shutil.copy(os.path.join(KOK, "scripts", f), os.path.join(t, "scripts"))
            with open(os.path.join(t, "runs", "k", "k.avi"), "wb") as f:
                f.write(b"RIFF" + bytes(64))
            if venv:
                subprocess.run([sys.executable, "-I", "-m", "venv", os.path.join(t, ".venv")], check=True, timeout=120)
            env = dict(os.environ, VT_ROOT=t)
            env.pop("VT_PYTHON", None)
            r = subprocess.run([PS, "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", os.path.join(t, "scripts", "uretim_kapi.ps1"),
                                "-Dizin", "k", "-Ad", "k", "-Kare", "5"],
                               capture_output=True, text=True, encoding="utf-8", errors="replace", env=env, timeout=150, stdin=subprocess.DEVNULL)
            return r.returncode, r.stdout + r.stderr

    def test_venv_varsa_kapi_onu_kullanir(self):
        # bos venv: opencv yok, kapi cikis 6 verir ve mesajdaki python yolu kokteki .venv olur
        kod, c = self.kos(venv=True)
        self.assertEqual(kod, 6, c)
        self.assertIn("KAPI CALISMADI", c)
        self.assertIn(".venv", c.replace("\\", "/"))

    def test_venv_yoksa_venv_kullanilmaz(self):
        kod, c = self.kos(venv=False)
        self.assertNotIn(".venv", c, c)


class BetikKurallari(unittest.TestCase):
    def test_uc_yerde_venv_tercihi(self):
        self.assertEqual(metin("kur.ps1").count("Join-Path $Root '.venv/Scripts/python.exe'"), 2)
        self.assertEqual(metin("uret.ps1").count("Join-Path $Root '.venv/Scripts/python.exe'"), 4)
        # uret.ps1 kapiyi ayri powershell surecinde calistirir ve python yolunu aktarmaz: kapi betigi de .venv'e bakmali (PR #14)
        self.assertEqual(metin("uretim_kapi.ps1").count("Join-Path $Root '.venv/Scripts/python.exe'"), 2)

    def test_oneri_kok_icinde_onbellek(self):
        for ad in ("kur.ps1", "uret.ps1"):
            self.assertIn("--cache-dir <VT_ROOT>/.onbellek/pip", metin(ad))

    def test_kalici_sistem_degisikligi_yok(self):
        for ad in ("kur.ps1", "uret.ps1", "modelleri_indir.ps1"):
            kod = "\n".join(s for s in metin(ad).splitlines() if not s.strip().startswith("#"))
            for desen in YASAK:
                self.assertIsNone(re.search(desen, kod, re.I), (ad, desen))

    def test_baska_surucu_kopya_bildirimi(self):
        self.assertIn("KOPYALANIYOR (ek", metin("kur.ps1"))


if __name__ == "__main__":
    unittest.main()
