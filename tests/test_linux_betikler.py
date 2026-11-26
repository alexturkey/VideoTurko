"""Linux betikleri (scripts/uret.sh, kur.sh, derle_linux.sh, modelleri_indir.py): GPU'suz, agsiz, sahte nvidia-smi / df / sd-cli / python ile.
Linux betikleri DENEYSEL: bakimcilar Linux'ta GPU kosusu yapmadi; bu testler mantigi (jeton, kapilar, sira, yan etkisizlik) sinar, GPU kosusunu degil.
Linux scripts: fake nvidia-smi/df/sd-cli/python, no network, no GPU. Bash: Git Bash (Windows) or system bash.

python -B -m unittest tests/test_linux_betikler.py -v"""
import hashlib
import importlib.util
import io
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import unittest
import urllib.error
from pathlib import Path
from unittest import mock

KOK = Path(__file__).resolve().parents[1]
SC = KOK / "scripts"


def bul_bash():
    adaylar = [os.environ.get("VT_BASH", ""), r"C:\Program Files\Git\bin\bash.exe", r"C:\Program Files\Git\usr\bin\bash.exe"]
    if sys.platform != "win32":
        adaylar.append(shutil.which("bash") or "")
    for a in adaylar:
        if a and Path(a).is_file():
            return a
    return None


BASH = bul_bash()
PS = shutil.which("powershell") or shutil.which("pwsh")
ORTAM_TEMIZ = ("VT_ROOT", "VT_ENGINE_BIN", "VT_MODEL_DIR", "VT_PYTHON", "VT_GPU_CC", "VT_GPU_VRAM", "VT_MAX_KARE", "VT_MAX_JETON",
               "VT_ATTN_BUDGET", "VT_CHUNK_MB", "VT_MARGIN_MB", "VT_ATTN", "VT_CHUNK", "GGML_CUDA_CUBLAS_COMPUTE_TYPE", "VT_CUDA_ARCH", "VT_BUILD_JOBS")


def posix(p):
    return Path(p).as_posix()


def sh(args, env_ek=None, timeout=120, path_ek=None):
    env = {k: v for k, v in os.environ.items() if k not in ORTAM_TEMIZ}
    env.update(env_ek or {})
    if path_ek:
        env["PATH"] = path_ek + os.pathsep + env.get("PATH", "")
    return subprocess.run([BASH] + [str(a) for a in args], capture_output=True, text=True, encoding="utf-8", errors="replace",
                          env=env, timeout=timeout, stdin=subprocess.DEVNULL)


def yaz_betik(yol, icerik):
    Path(yol).write_text(icerik, encoding="utf-8", newline="\n")
    os.chmod(yol, 0o755)


def sahte_bin(klasor, smi_satir=None, df_kb=None):
    """klasor: sahte nvidia-smi (smi_satir: 'ad, vram, cc') ve df (df_kb: bos KiB) betikleri."""
    k = Path(klasor)
    k.mkdir(parents=True, exist_ok=True)
    if smi_satir is not None:
        ad, vram, cc = [x.strip() for x in smi_satir.split(",")[-3:]][0:3] if smi_satir.count(",") == 2 else (smi_satir, "", "")
        yaz_betik(k / "nvidia-smi", '#!/usr/bin/env bash\ncase "$*" in\n  *name,memory.total,compute_cap*) echo "%s";;\n  *memory.total*) echo "%s";;\n  *compute_cap*) echo "%s";;\nesac\n' % (smi_satir, vram, cc))
    if df_kb is not None:
        yaz_betik(k / "df_sahte", '#!/usr/bin/env bash\necho "Filesystem 1024-blocks Used Available Capacity Mounted"\necho "fakedev 999999999 1 %d 1%% /"\n' % df_kb)


@unittest.skipUnless(BASH, "bash (Git Bash) gerekir")
class SozdizimiVeYapi(unittest.TestCase):
    def test_bash_n(self):
        for yol in (SC / "uret.sh", SC / "kur.sh", SC / "derle_linux.sh", KOK / "kur.sh", KOK / "uret.sh"):
            with self.subTest(betik=yol.name):
                r = subprocess.run([BASH, "-n", str(yol)], capture_output=True, text=True, stdin=subprocess.DEVNULL)
                self.assertEqual(r.returncode, 0, r.stderr)

    def test_lf_satir_sonu(self):
        for yol in (SC / "uret.sh", SC / "kur.sh", SC / "derle_linux.sh", SC / "modelleri_indir.py"):
            self.assertNotIn(b"\r\n", yol.read_bytes(), yol.name)

    def test_derle_tam_hash_ve_dogrulama(self):
        d = (SC / "derle_linux.sh").read_text(encoding="utf-8")
        self.assertRegex(d, r'SDCPP_HASH="[0-9a-f]{40}"')
        self.assertRegex(d, r'GGML_HASH="[0-9a-f]{40}"')
        self.assertIn('checkout --quiet "$SDCPP_HASH"', d)
        self.assertNotRegex(d, r"checkout --quiet 32d516c\b")
        self.assertIn("sha256sum -c --quiet patches/SHA256SUMS", d)
        self.assertIn("yamalar_tamam", d)   # isaret dosyasi
        self.assertIn("SHA256SUMS", d.split("DERLE_OK")[0].split("chmod +x")[-1])   # sd-cli parmak izi

    def test_kur_sirasi_gpu_disk_lisans_sonra_klon(self):
        k = (SC / "kur.sh").read_text(encoding="utf-8")
        sira = [k.index(x) for x in ("# 1) GPU", "# 2) disk", "# 3) lisans", "# 4) python venv", "# 5) motor", "# 6) modeller", "# 7) 5 karelik")]
        self.assertEqual(sira, sorted(sira))
        # klon/derleme cagrisi (bash "...derle_linux.sh") yalniz 5. adimdan sonra; oncesinde yalniz aciklama metinleri gecer
        cagrilar = [m.start() for m in re.finditer(r'bash "[^"]*derle_linux\.sh"', k)]
        self.assertEqual(len(cagrilar), 1)
        self.assertGreater(cagrilar[0], k.index("# 5) motor"))
        self.assertEqual(k.count("HAZIR / READY"), 1)
        self.assertLess(k.index("KONTROL BASARISIZ"), k.index("HAZIR / READY"))

    def test_uret_kalite_sabitleri(self):
        u = (SC / "uret.sh").read_text(encoding="utf-8")
        for parca in ("--steps 6", "--cfg-scale 1.0", "hyperflow-h3-flash-6", "--backend", "te=cpu"):
            self.assertIn(parca, u)
        for satir in u.splitlines():
            if satir.lstrip().startswith("#"):
                continue
            self.assertNotIn("--vae-tiling", satir)
            self.assertNotIn("--temporal-tiling", satir)
        self.assertNotIn('"$SD_CLI" "${ARGS[@]}" > "$log" 2>&1 || true', u)   # sd-cli cikis kodu yutulmaz
        self.assertIn("KUCUK_KART_MIB=8000", u)


@unittest.skipUnless(BASH, "bash (Git Bash) gerekir")
class UretKuru(unittest.TestCase):
    def kos(self, *args, cc="6.1", vram="4096", ek=None):
        with tempfile.TemporaryDirectory() as t:
            istem = Path(t) / "i.txt"
            istem.write_text("a lake", encoding="ascii")
            kok = Path(t) / "kok"
            env = {"VT_ROOT": posix(kok), "VT_GPU_CC": cc, "VT_GPU_VRAM": vram}
            env.update(ek or {})
            r = sh([SC / "uret.sh", "--istem", posix(istem), *args], env)
            self.assertFalse(kok.exists(), "--kuru hicbir sey yazmamali (runs/ klasoru bile)")
        return r.returncode, r.stdout + r.stderr

    def test_kuru_yan_etkisiz_ve_kurulumsuz_makinede_calisir(self):
        kod, c = self.kos("--kare", "56", "--kuru")
        self.assertEqual(kod, 0, c)
        self.assertIn("bilgi: --kuru: su dosyalar yok", c)

    def test_jeton_iki_asama_tablosu(self):
        beklenen = {56: (4080, "False"), 124: (8880, "True"), 141: (10080, "True"), 209: (14880, "True"), 107: (7680, "False")}
        for kare, (jeton, iki) in beklenen.items():
            with self.subTest(kare=kare):
                _, c = self.kos("--kare", str(kare), "--kuru")
                self.assertIn("jeton=%d " % jeton, c)
                self.assertIn("iki_asama=%s " % iki, c)

    @unittest.skipUnless(PS, "powershell yok")
    def test_jeton_ve_ortam_uret_ps1_ile_birebir(self):
        """Ayni girdide uret.ps1 -Kuru ve uret.sh --kuru ayni jeton, ayni asama sayisi, ayni f32, ayni ortam ve ayni sd-cli argumanlarini basar."""
        def norm_ortam(s):
            return re.sub(r"SD_VIDEO_LATENT_(SAVE|LOAD)=\S+", r"SD_VIDEO_LATENT_\1=<L>", s)
        for cc, vram in (("6.1", "4096"), ("8.6", "8192"), ("8.9", "16376")):
            for kare in (56, 124, 141, 209):
                with self.subTest(cc=cc, kare=kare), tempfile.TemporaryDirectory() as t:
                    istem = Path(t) / "i.txt"
                    istem.write_text("a lake", encoding="ascii")
                    env = dict(os.environ, VT_ROOT=t + "/kok_ps", VT_GPU_CC=cc, VT_GPU_VRAM=vram)
                    for a in ORTAM_TEMIZ[3:]:
                        if a not in ("VT_GPU_CC", "VT_GPU_VRAM"):
                            env.pop(a, None)
                    p = subprocess.run([PS, "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", str(SC / "uret.ps1"), "-Istem", str(istem), "-Kare", str(kare), "-Kuru"],
                                       capture_output=True, text=True, encoding="utf-8", errors="replace", env=env, timeout=120, stdin=subprocess.DEVNULL)
                    self.assertEqual(p.returncode, 0, p.stdout + p.stderr)
                    _, s = self.kos("--kare", str(kare), "--kuru", cc=cc, vram=vram)

                    def bilgi(c):
                        m = re.search(r"jeton=(\d+) tek_asama_elle=\w+ gpu_cc=(\S+) gpu_vram=(\d+) MiB f32=(\w+)", c)
                        return m.groups() if m else None
                    self.assertEqual(bilgi(p.stdout), bilgi(s), p.stdout + s)
                    self.assertEqual(re.search(r"iki_asama=(\w+)", p.stdout).group(1), re.search(r"iki_asama=(\w+)", s).group(1))
                    for et in ("ASAMA 1 ortam: ", "ASAMA 2 ortam: "):
                        a = re.search(re.escape(et) + r"(.*)", p.stdout)
                        b = re.search(re.escape(et) + r"(.*)", s)
                        self.assertEqual(bool(a), bool(b), et)
                        if a:
                            self.assertEqual(norm_ortam(a.group(1).strip()), norm_ortam(b.group(1).strip()), et)
                    # sd-cli argumanlari: yol icermeyen parca (--steps ... --backend te=cpu) ayni
                    def ortak(c):
                        m = re.search(r"--video-frames (\d+) --fps 24 --steps 6 .*?--backend te=cpu", c)
                        return m.group(0) if m else None
                    self.assertIsNotNone(ortak(s))
                    self.assertEqual(ortak(p.stdout), ortak(s))

    def test_vt_margin_mb_yalniz_asama_1(self):
        """PR #31: VT_MARGIN_MB yalniz 1. asamanin SD_VRAM_MARGIN_MB payini degistirir; varsayilan 1 / 256; 2. asama hep 256."""
        def marj(c, et):
            return re.search(re.escape(et) + r".*?SD_VRAM_MARGIN_MB=(\d+)", c).group(1)
        for cc, vram in (("6.1", "4096"), ("8.6", "6144")):
            with self.subTest(durum="varsayilan", cc=cc):
                _, c = self.kos("--kare", "209", "--kuru", cc=cc, vram=vram)
                self.assertEqual((marj(c, "ASAMA 1 ortam: "), marj(c, "ASAMA 2 ortam: ")), ("1", "256"))
                self.assertNotIn("VT_MARGIN_MB", c)
        for deger in ("512", "1", "4096"):
            with self.subTest(durum="gecerli", deger=deger):
                _, c = self.kos("--kare", "209", "--kuru", cc="8.6", vram="6144", ek={"VT_MARGIN_MB": deger})
                self.assertEqual((marj(c, "ASAMA 1 ortam: "), marj(c, "ASAMA 2 ortam: ")), (deger, "256"))
                self.assertIn("[VT-W-DENEYSEL]", c)
                self.assertIn("VT_MARGIN_MB=" + deger, c)
                self.assertIn("yalniz iki asamali kosuda", c)

    def test_vt_margin_mb_gecersiz_degerler_yok_sayilir(self):
        for deger in ("0", "5000", "abc", "-5", "1.5", "512MB"):
            with self.subTest(deger=deger):
                kod, c = self.kos("--kare", "209", "--kuru", cc="8.6", vram="6144", ek={"VT_MARGIN_MB": deger})
                self.assertEqual(kod, 0, c)
                self.assertIn("VT_MARGIN_MB='%s' 1..4096" % deger, c)
                self.assertNotIn("[VT-W-DENEYSEL]", c)
                self.assertEqual(re.search(r"ASAMA 1 ortam: .*?SD_VRAM_MARGIN_MB=(\d+)", c).group(1), "1")

    def test_vt_margin_mb_tek_asamada_ortami_degistirmez(self):
        _, bos = self.kos("--kare", "56", "--kuru", cc="8.6", vram="6144")
        _, ayarli = self.kos("--kare", "56", "--kuru", cc="8.6", vram="6144", ek={"VT_MARGIN_MB": "512"})
        self.assertIn("iki_asama=False", ayarli)
        self.assertEqual(re.search(r"ASAMA 1 ortam: (.*)", bos).group(1), re.search(r"ASAMA 1 ortam: (.*)", ayarli).group(1))
        self.assertNotIn("SD_VRAM_MARGIN_MB", ayarli)
        self.assertIn("tek asamali kosuda etkisizdir", ayarli)   # kullanici yanilmasin

    def test_ham_sd_vram_margin_mb_artik_okunmaz(self):
        """PR #31'in ilk hali ham SD_VRAM_MARGIN_MB'yi okuyup varsayilani 512 yapiyordu; varsayilan 1/256'da kalir, ham anahtar etkisiz."""
        _, c = self.kos("--kare", "209", "--kuru", cc="6.1", vram="4096", ek={"SD_VRAM_MARGIN_MB": "512"})
        self.assertEqual(re.search(r"ASAMA 1 ortam: .*?SD_VRAM_MARGIN_MB=(\d+)", c).group(1), "1")
        self.assertEqual(re.search(r"ASAMA 2 ortam: .*?SD_VRAM_MARGIN_MB=(\d+)", c).group(1), "256")

    def test_f32_kurali(self):
        for cc, f32 in (("6.1", "False"), ("7.5", "True"), ("8.9", "True"), ("-1", "False")):
            _, c = self.kos("--kare", "56", "--kuru", cc=cc)
            self.assertIn("f32=%s" % f32, c, cc)
        _, c = self.kos("--kare", "56", "--kuru", cc="8.6", ek={"GGML_CUDA_CUBLAS_COMPUTE_TYPE": "f16"})
        self.assertIn("f32=False", c)   # kullanici ayari ezilmez
        _, c = self.kos("--kare", "56", "--kuru", cc="8,6")   # ondalik virgul
        self.assertIn("gpu_cc=8.6", c)

    def test_kucuk_kart_esigi_8192(self):
        _, c = self.kos("--kare", "56", "--kuru", vram="8191")
        self.assertIn("gpu_vram=8191", c)
        kod, c = self.kos("--kare", "209", "-W", "832", "-H", "512", "--kuru", vram="4096")   # standart disi + kucuk kart: jeton tavani
        self.assertEqual(kod, 1, c)
        self.assertIn("[VT-E-BOYUT]", c)
        kod, c = self.kos("--kare", "209", "-W", "832", "-H", "512", "--kuru", vram="8192")   # 8 GB sinifi: tavan 16320 (issue #26); 25792 jeton reddedilir
        self.assertEqual(kod, 1, c)
        self.assertIn("tavan 16320", c)
        kod, c = self.kos("--kare", "56", "-W", "1280", "-H", "768", "--kuru", vram="8188")   # 16320 jeton = bildirilen gecen is
        self.assertEqual(kod, 0, c)
        kod, c = self.kos("--kare", "209", "-W", "832", "-H", "512", "--kuru", vram="12288")   # 11 GB ve ustu: tavan uygulanmaz
        self.assertEqual(kod, 0, c)

    def test_dogrulamalar(self):
        oneri = {
            ("--kare", "100", "--kuru"): "[VT-E-KARE]",
            ("--kare", "226", "--kuru"): "[VT-E-KARE]",
            ("--kare", "abc", "--kuru"): "[VT-E-KARE]",
            ("--kare", "209", "--init-img", "{img}", "--kuru"): "[VT-E-KARE]",
            ("--kare", "192", "--end-img", "{img}", "--kuru"): "[VT-E-KARE]",   # 4 GB: tavan 175
            ("-W", "640", "--kuru"): "[VT-E-BOYUT]",
            ("-W", "100", "-H", "100", "--kuru"): "[VT-E-BOYUT]",
            ("-W", "650", "-H", "384", "--kuru"): "[VT-E-BOYUT]",
            ("-W", "320", "-H", "320", "--kuru"): "[VT-E-BOYUT]",
            ("--init-img", "yok.png", "--kuru"): "[VT-E-ISTEM]",
            ("--seed", "x1", "--kuru"): "[VT-E-ISTEM]",
        }
        with tempfile.TemporaryDirectory() as t:
            img = Path(t) / "a.png"
            img.write_bytes(b"x")
            for args, kod_beklenen in oneri.items():
                with self.subTest(args=args):
                    a = [x.replace("{img}", posix(img)) for x in args]
                    kod, c = self.kos(*a)
                    self.assertEqual(kod, 1, c)
                    self.assertIn(kod_beklenen, c)
        kod, c = self.kos("--kare", "5", "--kuru")
        self.assertEqual(kod, 0, c)
        self.assertIn("jeton=480 ", c)   # 20*12*2: kare 5 -> latent 2 (uret.ps1 ile ayni)

    def test_eksik_deger_ve_bilinmeyen(self):
        r = sh([SC / "uret.sh", "--kare"])
        self.assertEqual(r.returncode, 2)
        r = sh([SC / "uret.sh", "--yok-boyle"])
        self.assertEqual(r.returncode, 2)

    def test_tavan_dk_formulu(self):
        _, c = self.kos("--kare", "209", "--kuru")
        self.assertIn("tavan=80dk", c)
        _, c = self.kos("--kare", "5", "--kuru")
        self.assertIn("tavan=30dk", c)
        _, c = self.kos("--kare", "56", "--tavan-dk", "7", "--kuru")
        self.assertIn("tavan=7dk", c)


@unittest.skipUnless(BASH, "bash (Git Bash) gerekir")
class UretKosuSahteMotorla(unittest.TestCase):
    """Gercek kosu yolu (sahte sd-cli): sira, kapilar, log taramasi, cikis kodu raporu. Gercek video yok."""

    SAHTE_SD = r"""#!/usr/bin/env bash
# sahte sd-cli: SD_FAKE_MOD ile davranis secilir
out=""; while [[ $# -gt 0 ]]; do [[ "$1" == "-o" ]] && out="$2"; shift; done
echo "fake sd-cli asama: SAVE=${SD_VIDEO_LATENT_SAVE:-} LOAD=${SD_VIDEO_LATENT_LOAD:-} F32=${GGML_CUDA_CUBLAS_COMPUTE_TYPE:-}" >> "$SD_FAKE_KAYIT"
case "${SD_FAKE_MOD:-ok}" in
  uzun) exec sleep 60 ;;
  yok) exit 1 ;;
  tiling) echo "temporal tiling retrying with smaller tiles"; head -c 20000 /dev/zero > "$out"; exit 0 ;;
  vram) echo "ALLOC_FAILED: cannot make enough memory"; exit 1 ;;
  hata_kodlu) head -c 20000 /dev/zero > "$out"; exit 7 ;;
esac
if [[ -n "${SD_VIDEO_LATENT_SAVE:-}" ]]; then head -c 2000000 /dev/zero > "$SD_VIDEO_LATENT_SAVE"; exit 0; fi
head -c 20000 /dev/zero > "$out"; exit 0
"""
    SAHTE_PY = r"""#!/usr/bin/env bash
# sahte python: '-I -c import' basarili; dikis_denetim.py -> FAKE_KAPI_CIKTI, cikis FAKE_KAPI_KOD
if [[ "$1" == "-I" && "$2" == "-c" ]]; then exit "${FAKE_IMPORT_KOD:-0}"; fi
case "$*" in
  *dikis_denetim*) echo "$FAKE_KAPI_CIKTI"; exit "${FAKE_KAPI_KOD:-0}" ;;
  *) echo "norm 0.04"; exit 0 ;;
esac
"""

    def hazirla(self, t):
        t = Path(t)
        kok = t / "kok"
        (kok / "engine" / "bin").mkdir(parents=True)
        yaz_betik(kok / "engine" / "bin" / "sd-cli", self.SAHTE_SD)
        (kok / "model").mkdir()
        for ad in ("minimax_h3_fl2va_hyperflow_flash_14b-Q4_K_M.gguf", "qwen3vl_32b_minimax_h3-Q4_K_M.gguf", "minimax_h3_sol_vae_fp16.safetensors", "minimax_h3_audio_vae_fp32.safetensors"):
            (kok / "model" / ad).write_bytes(b"x")
        yaz_betik(t / "py", self.SAHTE_PY)
        (t / "i.txt").write_text("a lake", encoding="ascii")
        return kok

    def kos(self, kare, mod="ok", kapi=None, ek=None, kontrol=True, onceden=None):
        with tempfile.TemporaryDirectory() as t:
            kok = self.hazirla(t)
            if onceden:
                onceden(kok)
            kayit = Path(t) / "kayit.txt"
            env = {"VT_ROOT": posix(kok), "VT_PYTHON": posix(Path(t) / "py"), "VT_GPU_CC": "8.6", "VT_GPU_VRAM": "16376",
                   "SD_FAKE_MOD": mod, "SD_FAKE_KAYIT": posix(kayit),
                   "FAKE_KAPI_CIKTI": (kapi or {}).get("cikti", ""), "FAKE_KAPI_KOD": str((kapi or {}).get("kod", 0))}
            env.update(ek or {})
            args = [SC / "uret.sh", "--istem", posix(Path(t) / "i.txt"), "--kare", str(kare)] + (["--kontrol"] if kontrol else [])
            r = sh(args, env, timeout=90)
            kayit_metni = kayit.read_text(encoding="utf-8") if kayit.exists() else ""
            kaldi = sorted(p.name for p in (kok / "runs").glob("*")) if (kok / "runs").exists() else []
        return r.returncode, r.stdout + r.stderr, kayit_metni, kaldi

    def test_tek_asama_tamam_ve_kilit_kalkar(self):
        kod, c, kayit, kaldi = self.kos(56)
        self.assertEqual(kod, 0, c)
        self.assertIn("TAMAM:", c)
        self.assertEqual(kayit.count("fake sd-cli"), 1)
        self.assertIn("F32=f32", kayit)
        self.assertNotIn("gpu.kilit", kaldi)

    def test_iki_asama_latent_ve_sira(self):
        kod, c, kayit, _ = self.kos(124)
        self.assertEqual(kod, 0, c)
        satirlar = kayit.strip().splitlines()
        self.assertEqual(len(satirlar), 2)
        self.assertRegex(satirlar[0], r"SAVE=\S+latent\.bin LOAD= ")
        self.assertRegex(satirlar[1], r"SAVE= LOAD=\S+latent\.bin")

    def test_karolu_log_gecersiz(self):
        kod, c, _, _ = self.kos(56, mod="tiling")
        self.assertEqual(kod, 1, c)
        self.assertIn("[VT-E-TILING]", c)
        self.assertNotIn("TAMAM:", c)

    def test_cikti_yok_ve_vram_ipucu(self):
        kod, c, _, _ = self.kos(56, mod="vram")
        self.assertEqual(kod, 1, c)
        self.assertIn("[VT-E-VRAM]", c)
        kod, c, _, _ = self.kos(56, mod="yok")
        self.assertEqual(kod, 1, c)
        self.assertIn("[VT-E-CIKTI]", c)
        self.assertIn("sd-cli cikis kodu: 1", c)

    def test_sd_cli_cikis_kodu_raporlanir_ama_tek_olcut_degil(self):
        kod, c, _, _ = self.kos(56, mod="hata_kodlu")
        self.assertEqual(kod, 0, c)
        self.assertIn("sd-cli cikis kodu '7'", c)

    def test_dur_dosyasi(self):
        kod, c, _, _ = self.kos(56, mod="uzun", onceden=lambda kok: (kok / "DUR").write_text("x"))
        self.assertEqual(kod, 2, c)
        self.assertIn("DURDU", c)

    def test_kalite_kapisi_esikleri(self):
        def kapi(g, a, k=56):
            return {"cikti": "parca 1: kare=%d gurultu=%s (kapi<=1.5, gercek H3 56 kare 0.7-1.14) orta akis=%s son5 spike=0.1 0.1" % (k, g, a), "kod": 0}
        kod, c, _, _ = self.kos(56, kapi=kapi("1.00", "0.50"), kontrol=False)
        self.assertEqual(kod, 0, c)
        self.assertIn("KAPI GECTI", c)
        for ad, kp in (("gurultu", kapi("1.60", "0.50")), ("akis", kapi("1.00", "0.05")), ("kare", kapi("1.00", "0.50", 55))):
            with self.subTest(neden=ad):
                kod, c, _, _ = self.kos(56, kapi=kp, kontrol=False)
                self.assertEqual(kod, 5, c)
                self.assertIn("[VT-E-KAPI-RED]", c)
                self.assertNotIn("TAMAM:", c)
        kod, c, _, _ = self.kos(56, kapi={"cikti": "KAPI CALISMADI: ImportError: cv2", "kod": 6}, kontrol=False)
        self.assertEqual(kod, 6, c)
        self.assertNotIn("TAMAM:", c)

    def test_python_yoksa_gpu_isi_baslamaz(self):
        kod, c, kayit, _ = self.kos(56, kontrol=False, ek={"FAKE_IMPORT_KOD": "1"})
        self.assertEqual(kod, 6, c)
        self.assertIn("[VT-E-PY]", c)
        self.assertEqual(kayit, "", "sd-cli hic calismamali")

    def test_model_eksik(self):
        kod, c, kayit, _ = self.kos(56, onceden=lambda kok: (kok / "model" / "minimax_h3_sol_vae_fp16.safetensors").unlink())
        self.assertEqual(kod, 1, c)
        self.assertIn("[VT-E-DOSYA]", c)
        self.assertEqual(kayit, "")


@unittest.skipUnless(BASH, "bash (Git Bash) gerekir")
class KurSh(unittest.TestCase):
    def kos(self, *args, smi="NVIDIA GeForce GTX 1050 Ti, 4096, 6.1", df_kb=999999999, model_var=False, ek=None):
        with tempfile.TemporaryDirectory() as t:
            t = Path(t)
            sahte_bin(t / "bin", smi_satir=smi, df_kb=df_kb) if smi else sahte_bin(t / "bin", df_kb=df_kb)
            kok = t / "kok"
            kok.mkdir()
            if model_var:
                (kok / "model").mkdir()
                for ad in ("minimax_h3_fl2va_hyperflow_flash_14b-Q4_K_M.gguf", "qwen3vl_32b_minimax_h3-Q4_K_M.gguf", "minimax_h3_sol_vae_fp16.safetensors", "minimax_h3_audio_vae_fp32.safetensors"):
                    (kok / "model" / ad).write_bytes(b"x")
            ilk = sorted(p.name for p in kok.iterdir())
            env = {"VT_ROOT": posix(kok), "VT_DF_KOMUT": posix(t / "bin" / "df_sahte")}
            env.update(ek or {})
            r = sh([SC / "kur.sh", *args], env, path_ek=str(t / "bin"))
            son = sorted(p.name for p in kok.iterdir())
        return r.returncode, r.stdout + r.stderr, ilk, son

    def test_kuru_planli_ve_yan_etkisiz(self):
        kod, c, ilk, son = self.kos("--kuru")
        self.assertEqual(kod, 0, c)
        self.assertIn("KURU plan: motor yok", c)
        self.assertIn("KURU bitti: hicbir sey yazilmadi", c)
        self.assertEqual(ilk, son)
        self.assertNotIn("HAZIR / READY", c)

    def test_nvidia_smi_yok(self):
        kod, c, ilk, son = self.kos("--kuru", smi=None, ek={"VT_NVIDIA_SMI": "nvidia-smi-yok-boyle-komut"})
        self.assertEqual(kod, 3, c)
        self.assertIn("[VT-E-GPU]", c)
        self.assertEqual(ilk, son)

    def test_gpu_kapisi_klondan_once(self):
        for smi, kod_beklenen in (("NVIDIA GeForce GT 710, 2048, 3.5", "[VT-E-GPU-VRAM]"), ("NVIDIA Quadro K620, 4096, 5.0", "[VT-E-GPU-CC]")):
            with self.subTest(kart=smi):
                kod, c, ilk, son = self.kos(smi=smi)
                self.assertEqual(kod, 3, c)
                self.assertIn(kod_beklenen, c)
                self.assertEqual(ilk, son, "klon/venv/model baslamamali")

    def test_disk_kapisi_klondan_once(self):
        kod, c, ilk, son = self.kos(df_kb=5 * 1024 * 1024)   # 5 GiB bos
        self.assertEqual(kod, 3, c)
        self.assertIn("[VT-E-DISK]", c)
        self.assertEqual(ilk, son)
        kod, c, _, _ = self.kos("--kuru", df_kb=60 * 1024 * 1024)   # 60 GiB: yeter
        self.assertEqual(kod, 0, c)

    def test_lisans_kabul_edilmezse_klon_yok(self):
        kod, c, ilk, son = self.kos()   # stdin bos: etkilesimsiz kabul alinamaz
        self.assertEqual(kod, 2, c)
        self.assertIn("[VT-E-LISANS]", c)
        self.assertEqual(ilk, son, "lisanstan once hicbir sey olusmamali (.venv, engine, model)")
        self.assertNotIn("HAZIR / READY", c)

    def test_eski_kontrol_bayragi_kabul_edilir(self):
        kod, c, _, _ = self.kos("--kuru", "--kontrol")
        self.assertEqual(kod, 0, c)


@unittest.skipUnless(BASH and shutil.which("git"), "bash + git gerekir")
class DerleLinuxKapilari(unittest.TestCase):
    def kur(self, t):
        t = Path(t)
        repo = t / "repo"
        shutil.copytree(KOK / "patches", repo / "patches")
        (repo / "scripts").mkdir()
        shutil.copy(SC / "derle_linux.sh", repo / "scripts" / "derle_linux.sh")
        bin_ = t / "bin"
        bin_.mkdir()
        for ad in ("cmake", "nvcc"):
            yaz_betik(bin_ / ad, "#!/usr/bin/env bash\nexit 0\n")
        return repo, bin_

    def kos(self, repo, bin_, kok):
        return sh([repo / "scripts" / "derle_linux.sh"], {"VT_ROOT": posix(kok)}, path_ek=str(bin_), timeout=60)

    def test_bozuk_yama_uygulanmaz(self):
        with tempfile.TemporaryDirectory() as t:
            repo, bin_ = self.kur(t)
            ilk = next((repo / "patches" / "sdcpp").glob("*.patch"))
            ilk.write_bytes(ilk.read_bytes() + b"\n# bozuldu\n")
            kok = Path(t) / "kok"
            kok.mkdir()
            r = self.kos(repo, bin_, kok)
            self.assertEqual(r.returncode, 1, r.stdout + r.stderr)
            self.assertIn("SHA256SUMS ile uyusmuyor", r.stderr)
            self.assertFalse((kok / "engine").exists(), "klon baslamamali")

    def test_yanlis_surumdeki_kaynak_reddedilir(self):
        with tempfile.TemporaryDirectory() as t:
            repo, bin_ = self.kur(t)
            kok = Path(t) / "kok"
            src = kok / "engine" / "src"
            src.mkdir(parents=True)
            for komut in (["init", "-q"], ["-c", "user.name=t", "-c", "user.email=t@t", "commit", "-q", "--allow-empty", "-m", "x"]):
                subprocess.run(["git", "-C", str(src)] + komut, check=True, capture_output=True)
            r = self.kos(repo, bin_, kok)
            self.assertEqual(r.returncode, 1, r.stdout + r.stderr)
            self.assertIn("beklenen surumde degil", r.stderr)


def modul_yukle():
    spec = importlib.util.spec_from_file_location("vt_modelleri_indir", SC / "modelleri_indir.py")
    m = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(m)
    return m


class SahteYanit:
    def __init__(self, veri, status=200):
        self.veri, self.status, self.i = veri, status, 0

    def read(self, n=-1):
        parca = self.veri[self.i:self.i + (n if n > 0 else len(self.veri))]
        self.i += len(parca)
        return parca

    def __enter__(self):
        return self

    def __exit__(self, *a):
        return False


class ModellerIndirici416(unittest.TestCase):
    URL = "https://example.invalid/m.bin"

    def setUp(self):
        self.m = modul_yukle()
        self.veri = b"0123456789abcdef"
        self.sha = hashlib.sha256(self.veri).hexdigest()
        self.t = tempfile.TemporaryDirectory()
        self.hedef = Path(self.t.name) / "m.bin"
        self.part = Path(self.t.name) / "m.bin.part"

    def tearDown(self):
        self.t.cleanup()

    def http(self, kod):
        return urllib.error.HTTPError(self.URL, kod, "x", {}, io.BytesIO(b""))

    def test_part_tam_boyutta_416_sha_ile_tamamlanir(self):
        self.part.write_bytes(self.veri)
        with mock.patch("urllib.request.urlopen", side_effect=self.http(416)):
            self.m.indir(self.URL, self.hedef, len(self.veri), self.sha, False)
        self.assertEqual(self.hedef.read_bytes(), self.veri)
        self.assertFalse(self.part.exists())

    def test_bayat_part_416_bastan_indirilir(self):
        self.part.write_bytes(self.veri[:5])
        cagrilar = []

        def sahte(req, timeout=0):
            cagrilar.append(req.get_header("Range"))
            if req.get_header("Range"):
                raise self.http(416)
            return SahteYanit(self.veri)
        with mock.patch("urllib.request.urlopen", side_effect=sahte):
            self.m.indir(self.URL, self.hedef, len(self.veri), self.sha, False)
        self.assertEqual(self.hedef.read_bytes(), self.veri)
        self.assertEqual(cagrilar, ["bytes=5-", None])

    def test_part_tam_ama_sha_yanlis_reddedilir(self):
        self.part.write_bytes(b"x" * len(self.veri))
        with mock.patch("urllib.request.urlopen", side_effect=self.http(416)):
            with self.assertRaises(SystemExit) as c:
                self.m.indir(self.URL, self.hedef, len(self.veri), self.sha, False)
        self.assertIn("sha256 tutmadı", str(c.exception))
        self.assertFalse(self.hedef.exists())

    def test_diger_hatalar_okunur_mesajla_cikar(self):
        for hata, parca in ((self.http(404), "HTTP 404"), (urllib.error.URLError("ag yok"), "ag yok"), (TimeoutError("zaman asimi"), "zaman asimi")):
            with self.subTest(hata=parca), mock.patch("urllib.request.urlopen", side_effect=hata):
                with self.assertRaises(SystemExit) as c:
                    self.m.indir(self.URL, self.hedef, len(self.veri), self.sha, False)
                self.assertIn("indirme basarisiz", str(c.exception))
                self.assertIn(parca, str(c.exception))

    def test_normal_indirme_ve_http_reddi(self):
        with mock.patch("urllib.request.urlopen", return_value=SahteYanit(self.veri)):
            self.m.indir(self.URL, self.hedef, len(self.veri), self.sha, False)
        self.assertEqual(self.hedef.read_bytes(), self.veri)
        with self.assertRaises(SystemExit):
            self.m.indir("http://example.invalid/m.bin", Path(self.t.name) / "z.bin", 1, "0" * 64, False)


if __name__ == "__main__":
    unittest.main()
