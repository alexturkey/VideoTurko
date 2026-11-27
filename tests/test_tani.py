"""Tests for scripts/tani.ps1 and tani.cmd (KL-14): the privacy-filtered diagnosis report. Stdlib unittest, no network, no GPU.

    python -I -X utf8 -m unittest discover -s tests -v

Static checks run everywhere; the runs need Windows PowerShell. Fake names, paths, e-mails and tokens are built at run time
from pieces (so this file passes its own privacy gate). Only -KuruAtla runs and one real `kur.ps1 -Kuru` dry run are used.
"""

import getpass
import json
import os
import re
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

KOK = Path(__file__).resolve().parents[1]
TANI = KOK / "scripts" / "tani.ps1"
PS = os.name == "nt" and shutil.which("powershell.exe")
CF = getattr(subprocess, "CREATE_NO_WINDOW", 0)
BS = chr(92)
AD = "Test Kullan" + chr(305) + "c" + chr(305) + " " + chr(199)      # "Test Kullanici C" with Turkish letters
MAKINE = "TESTPC-" + chr(199)


def kos(args, env_ek=None, cwd=None):
    env = dict(os.environ)
    env.pop("VT_KURU_SAHTE", None)
    env.update(env_ek or {})
    p = subprocess.run(["powershell.exe", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", str(TANI)] + list(args),
                       capture_output=True, env=env, cwd=cwd, creationflags=CF, timeout=180)
    return p.returncode, p.stdout, p.stderr


def log_yaz(klasor, ad, metin):
    yol = Path(klasor) / ad
    yol.write_bytes(metin.encode("utf-8"))
    return str(yol)


def json_dizeleri(nesne):
    if isinstance(nesne, str):
        yield nesne
    elif isinstance(nesne, dict):
        for v in nesne.values():
            yield from json_dizeleri(v)
    elif isinstance(nesne, list):
        for v in nesne:
            yield from json_dizeleri(v)


class Statik(unittest.TestCase):
    def test_ascii_ve_kontrol_karakteri_yok(self):
        for yol in (TANI, KOK / "tani.cmd"):
            veri = yol.read_bytes()
            self.assertTrue(all(b < 128 for b in veri), yol.name + " ASCII olmali")
            self.assertFalse([b for b in veri if b < 32 and b not in (9, 10, 13)], yol.name + " kontrol karakteri")

    def test_cmd_crlf_ve_kalip(self):
        veri = (KOK / "tani.cmd").read_bytes()
        self.assertEqual(veri.count(b"\r\n"), veri.count(b"\n"), "tani.cmd CRLF olmali")
        metin = veri.decode("ascii")
        self.assertTrue(metin.startswith("@echo off\r\n"))
        self.assertIn("scripts" + BS + "tani.ps1", metin)
        self.assertIn("-Cikti", metin)
        self.assertIn("%*", metin)
        self.assertIn("chcp 65001", metin)
        self.assertIn(BS + "System32" + BS + "find.exe", metin)

    def test_ag_yok_gonderme_yok(self):
        """No network, no upload: the script must not contain any network or process-start cmdlet."""
        metin = TANI.read_text(encoding="ascii")
        govde = "\n".join(s for s in metin.splitlines() if not s.lstrip().startswith("#"))
        parcalar = (("Invoke-", "WebRequest"), ("Invoke-", "RestMethod"), ("Web", "Client"), ("Start-", "BitsTransfer"), ("Test-", "Connection"),
                    ("cu", "rl"), ("wg", "et"), ("Invoke-", "Expression"), ("i", "ex "), ("Download", "String"), ("Send-", "MailMessage"),
                    ("Start-", "Process"), ("ht", "tp://"), ("ht", "tps://"))
        for yasak in ("".join(p) for p in parcalar):
            self.assertNotIn(yasak, govde, yasak)

    def test_parametreler(self):
        metin = TANI.read_text(encoding="ascii")
        for p in ("[switch]$Json", "[switch]$KartSatiri", "[switch]$KuruAtla", "$Log", "$Cikti", "$Gizle"):
            self.assertIn(p, metin)


@unittest.skipUnless(PS, "Windows PowerShell gerekir")
class Gizlilik(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.gecici = tempfile.mkdtemp(prefix="vt_tani_")
        d = chr(68) + ":"
        satirlar = [
            "Loading model from C:" + BS + "Users" + BS + AD + BS + "Desktop" + BS + "x" + BS + "model.gguf",
            "unix style /c/Users/" + AD + "/proje/a.txt and /home/" + "kimse" + "/b",
            "other drive " + d + BS + "Ozel Klasor" + BS + "y.log",
            "contact " + "kisi.ozel" + chr(64) + "example.org please",
            "token " + "gh" + "p_" + "A" * 36,
            "short C:" + BS + "Temp" + BS + "TESTKU" + "~1" + BS + "AppData" + " and C:" + BS + "Users" + BS + "TESTKU" + "~1" + BS + "x",
            BS * 2 + "ofis-sunucu" + BS + "paylasim" + BS + "x",
            "hello " + AD + " and again " + AD.lower() + " and the machine " + MAKINE,
            "normal line: 56 frames, steps 6",
        ]
        cls.log = log_yaz(cls.gecici, "log_" + AD.replace(" ", "_") + ".txt", "\n".join(satirlar) + "\n")
        cls.env = {"USERNAME": AD, "COMPUTERNAME": MAKINE, "USERPROFILE": "C:" + BS + "Users" + BS + AD}

    @classmethod
    def tearDownClass(cls):
        shutil.rmtree(cls.gecici, ignore_errors=True)

    def _sizinti_yok(self, ham, ad):
        yasak_parcalar = [AD, AD.lower(), MAKINE, MAKINE.lower(), "kisi.ozel", "A" * 36, "ofis-sunucu", "TESTKU", "Ozel Klasor", "kimse",
                          "Kullan" + chr(305) + "c", "Kullan\\u0131c", "TESTPC"]
        for kodlama in ("utf-8", "utf-16-le"):
            for parca in yasak_parcalar:
                self.assertNotIn(parca.encode(kodlama), ham, "%s: %r (%s) cikti icinde" % (ad, parca, kodlama))
                self.assertNotIn(parca.lower().encode(kodlama), ham.lower() if kodlama == "utf-8" else ham, "%s: kucuk harf %r" % (ad, parca))

    def test_json_ham_ad_sifir(self):
        kod, out, err = kos(["-Json", "-KuruAtla", "-Log", self.log], self.env)
        self.assertEqual(kod, 0, err.decode("utf-8", "replace"))
        self.assertTrue(all(b < 128 for b in out), "JSON cikti ASCII olmali (\\uXXXX)")
        self._sizinti_yok(out, "json")
        nesne = json.loads(out.decode("ascii"))
        tum = "\n".join(json_dizeleri(nesne))
        for parca in (AD, AD.lower(), MAKINE, "kisi.ozel", "ofis-sunucu", "TESTKU", "Ozel Klasor", "A" * 36):
            self.assertNotIn(parca.lower(), tum.lower(), parca)
        # markers show that the filter worked (not that the lines were just lost)
        for isaret in ("<HOME>", "<USER>", "<MACHINE>", "<EMAIL>", "<SECRET>", "<DRIVE>:", "<SHORTNAME>", "<SERVER>"):
            self.assertIn(isaret, tum, isaret)
        self.assertIn("normal line: 56 frames, steps 6", tum, "normal satir korunmali")
        self.assertNotIn("line removed", tum, "son guvenlik agi tetiklenmemeli: asil suzgec isi bitirmeli")
        self.assertIn("uyari", nesne)
        self.assertEqual(nesne["bulunan_kodlar"], [])

    def test_metin_ve_kart_ve_dosya(self):
        with tempfile.TemporaryDirectory(prefix="vt_tani_cikti_") as d:
            cikti = os.path.join(d, "rapor.txt")
            kod, out, err = kos(["-KuruAtla", "-Log", self.log, "-Cikti", cikti], self.env)
            self.assertEqual(kod, 0, err.decode("utf-8", "replace"))
            self._sizinti_yok(out, "metin")
            dosya = Path(cikti).read_bytes()
            self._sizinti_yok(dosya, "dosya")
            self.assertFalse(dosya.startswith(b"\xef\xbb\xbf"), "BOM yok")
            self.assertIn(b"Nothing was sent", dosya)
        kod, out, err = kos(["-KartSatiri", "-KuruAtla", "-Log", self.log], self.env)
        self.assertEqual(kod, 0)
        self._sizinti_yok(out, "kart")
        satirlar = [s for s in out.decode("utf-8", "replace").splitlines() if s.strip()]
        self.assertEqual(len(satirlar), 1, "KartSatiri tek satir")
        self.assertTrue(satirlar[0].startswith("VT "))

    def test_gizle_parametresi_ve_ortam(self):
        yol = log_yaz(self.gecici, "kod_adi.txt", "project codename Zeppelinx and Quarkmoon here\n")
        kod, out, _ = kos(["-KuruAtla", "-Log", yol, "-Gizle", "Zeppelinx"], {"VT_TANI_GIZLE": "Quarkmoon"})
        self.assertEqual(kod, 0)
        self.assertNotIn(b"Zeppelinx", out)
        self.assertNotIn(b"Quarkmoon", out)
        self.assertIn(b"<HIDDEN>", out)

    def test_gercek_kullanici_ve_kok_yolu_cikmaz(self):
        """A real kur.ps1 -Kuru dry run (read only, ~5 s): the real user name and the folder path must not appear."""
        kod, out, err = kos(["-Json"])
        self.assertEqual(kod, 0, err.decode("utf-8", "replace"))
        nesne = json.loads(out.decode("ascii"))
        self.assertTrue(nesne["kuru"]["calisti"], "kur.ps1 -Kuru kosmali")
        tum = "\n".join(json_dizeleri(nesne)).lower()
        self.assertNotIn(str(KOK).lower(), tum)
        self.assertNotIn(str(KOK).lower().replace(BS, "/"), tum)
        gercek = getpass.getuser().lower()
        if len(gercek) >= 4:
            self.assertNotIn(gercek, tum)
        self.assertNotIn((BS + "users" + BS), tum)


@unittest.skipUnless(PS, "Windows PowerShell gerekir")
class ImzaEslestirme(unittest.TestCase):
    """5 fake errors must give the right VT-E code; a clean log gives none (matching = plain sub-strings of docs/hata_imzalari.json)."""
    VAKALAR = (
        ("VT-E-GPU", "'nvidia-smi' is not recognized as an internal or external command, operable program or batch file."),
        ("VT-E-DLL", "sd-cli.exe exited with code 0xC0000135 (STATUS_DLL_NOT_FOUND) while loading"),
        ("VT-E-PY", "ModuleNotFoundError: No module named 'cv2'"),
        ("VT-E-VRAM", "ggml_cuda: ALLOC_FAILED: cannot make enough memory on device 0"),
        ("VT-E-DISK", "disk yetersiz: DISK YETERSIZ, 3 GiB free"),
    )

    def _kodlar(self, metin):
        with tempfile.TemporaryDirectory(prefix="vt_tani_imza_") as d:
            yol = log_yaz(d, "x.log", metin + "\n")
            kod, out, err = kos(["-Json", "-KuruAtla", "-Log", yol])
            self.assertEqual(kod, 0, err.decode("utf-8", "replace"))
            nesne = json.loads(out.decode("ascii"))
            return [b["kod"] for b in nesne["bulunan_kodlar"]], nesne

    def test_bes_sahte_hata(self):
        for beklenen, metin in self.VAKALAR:
            with self.subTest(beklenen=beklenen):
                kodlar, nesne = self._kodlar(metin)
                hatalar = [k for k in kodlar if k.startswith("VT-E-")]
                self.assertEqual(hatalar, [beklenen], "%s -> %s" % (metin, kodlar))
                b = nesne["bulunan_kodlar"][0]
                self.assertTrue(b["ilk_adim_en"] and b["ilk_adim_tr"] and b["capa"].startswith("docs/SIK_HATALAR.md#"))

    def test_kucuk_harf_ve_kodlu_satir(self):
        kodlar, _ = self._kodlar("hata: [vt-e-lisans] lisans kabul edilmedi")
        self.assertIn("VT-E-LISANS", kodlar)

    def test_temiz_log_kod_vermez(self):
        kodlar, _ = self._kodlar("56 frames written, steps 6, cfg 1.0, all good")
        self.assertEqual(kodlar, [])

    def test_imza_dosyasi_yoksa_yesil_gizlenmez(self):
        """A missing signature file is reported (imza_dosyasi), never silently 'no code found'."""
        with tempfile.TemporaryDirectory(prefix="vt_tani_kopya_") as d:
            (Path(d) / "scripts").mkdir()
            shutil.copy(TANI, Path(d) / "scripts" / "tani.ps1")
            yol = log_yaz(d, "x.log", "ModuleNotFoundError: No module named 'cv2'\n")
            p = subprocess.run(["powershell.exe", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", str(Path(d) / "scripts" / "tani.ps1"),
                                "-Json", "-KuruAtla", "-Log", yol], capture_output=True, creationflags=CF, timeout=120)
            self.assertEqual(p.returncode, 0)
            nesne = json.loads(p.stdout.decode("ascii"))
            self.assertEqual(nesne["imza_dosyasi"], "missing")


@unittest.skipUnless(PS, "Windows PowerShell gerekir")
class TaniCmd(unittest.TestCase):
    def test_cmd_sarmalayici_dosya_yazar(self):
        with tempfile.TemporaryDirectory(prefix="vt_tani_cmd_") as d:
            kok = Path(d) / ("T" + chr(252) + "rk" + chr(231) + "e Klas" + chr(246) + "r")
            (kok / "scripts").mkdir(parents=True)
            (kok / "docs").mkdir()
            shutil.copy(KOK / "tani.cmd", kok / "tani.cmd")
            shutil.copy(TANI, kok / "scripts" / "tani.ps1")
            shutil.copy(KOK / "docs" / "hata_imzalari.json", kok / "docs" / "hata_imzalari.json")
            shutil.copy(KOK / "CHANGELOG.md", kok / "CHANGELOG.md")
            env = dict(os.environ, VT_NO_PAUSE="1")
            p = subprocess.run(["cmd.exe", "/c", str(kok / "tani.cmd"), "-KuruAtla"], capture_output=True, env=env, cwd=str(kok),
                               creationflags=CF, timeout=120)
            self.assertEqual(p.returncode, 0, p.stdout.decode("utf-8", "replace"))
            rapor = (kok / "tani_raporu.txt").read_bytes()
            self.assertIn(b"VideoTurko tani raporu", rapor)
            self.assertNotIn(str(kok).encode("utf-8"), rapor, "klasor yolu raporda olmamali")
            self.assertNotIn(("T" + chr(252) + "rk" + chr(231) + "e").encode("utf-8"), rapor)


@unittest.skipUnless(PS, "Windows PowerShell gerekir")
class Sapma(unittest.TestCase):
    """DEVIATIONS / SAPMA section: read only, shows VT_* overrides, keeps the privacy filter, writes nothing."""

    @staticmethod
    def _git_durum():
        if not shutil.which("git"):
            return None
        return subprocess.run(["git", "--no-optional-locks", "-C", str(KOK), "status", "--porcelain", "-uno"], capture_output=True,
                              creationflags=CF, timeout=60).stdout

    def test_bolum_var_ve_vt_ezmesi_gorunur(self):
        kod, out, err = kos(["-KuruAtla"], {"VT_MAX_KARE": "99"})
        self.assertEqual(kod, 0, err)
        metin = out.decode("utf-8", "replace")
        self.assertIn("DEVIATIONS / SAPMA", metin)
        self.assertIn("VT_MAX_KARE=99", metin)
        self.assertIn("model           : ", metin)

    def test_json_sapma_anahtarlari(self):
        kod, out, err = kos(["-Json", "-KuruAtla"], {"VT_NO_FA": "1"})
        self.assertEqual(kod, 0, err)
        s = json.loads(out.decode("ascii"))["sapma"]
        for k in ("python", "python_ilk", "git", "degisen", "vt_env", "modeller", "kopyalar"):
            self.assertIn(k, s)
        self.assertIn("VT_NO_FA=1", s["vt_env"])
        self.assertTrue(s["modeller"], "scripts/modeller.json listesi bos olmamali")

    def test_hicbir_sey_yazmaz(self):
        once = self._git_durum()
        kod, _, err = kos(["-KuruAtla"], None)
        self.assertEqual(kod, 0, err)
        self.assertEqual(self._git_durum(), once, "tani.ps1 izlenen bir dosyayi degistirdi")

    def test_ezme_degerindeki_kisisel_yol_gizlenir(self):
        yol = "C:" + BS + "Users" + BS + AD + BS + "x" + BS + "py.exe"
        kod, out, err = kos(["-KuruAtla"], {"VT_PYTHON": yol, "USERNAME": AD, "USERPROFILE": "C:" + BS + "Users" + BS + AD})
        self.assertEqual(kod, 0, err)
        for kodlama in ("utf-8", "utf-16-le"):
            self.assertNotIn(AD.encode(kodlama), out)
        self.assertIn(b"VT_PYTHON=", out)


@unittest.skipUnless(PS, "Windows PowerShell gerekir")
class NvidiaYok(unittest.TestCase):
    """No nvidia-smi (AMD or other non-NVIDIA card): the report keeps 'none (...)' and adds the display adapter NAME only."""

    def test_nvidia_smi_yokken_kart_adi_eklenir(self):
        bos = tempfile.mkdtemp(prefix="vt_tani_bos_")
        self.addCleanup(shutil.rmtree, bos, True)
        env = dict(os.environ)
        env.pop("VT_KURU_SAHTE", None)
        env["PATH"] = bos                                     # nvidia-smi cannot be found; PowerShell is started by absolute path
        p = subprocess.run([PS, "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", str(TANI), "-Json", "-KuruAtla"],
                           capture_output=True, env=env, creationflags=CF, timeout=180)
        self.assertEqual(p.returncode, 0, p.stderr.decode("utf-8", "replace"))
        gpu = json.loads(p.stdout.decode("ascii"))["sistem"]["gpu"]
        self.assertTrue(gpu.startswith("none (nvidia-smi missing"), gpu)
        self.assertIn("display adapter: ", gpu)               # name only; every Windows with a screen has an adapter
        self.assertNotIn("<", gpu.split("display adapter: ")[1][:1])


if __name__ == "__main__":
    unittest.main()
