# AGENTS_HIZLI.md: quick card for AI coding agents / Yapay zeka ajanları için hızlı kart

English first, Türkçe below. Full rules and evidence: [`AGENTS.md`](AGENTS.md) (it wins if the two ever differ). Error codes: `docs/hata_imzalari.json`, `docs/SIK_HATALAR.md`.

## Do this first (English)
- **Run first:** `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\tani.ps1`. It is read-only (no download, no install, no network) and prints the system, the card, the `kur.ps1 -Kuru` dry run and a DEVIATIONS section (Python versions, locally changed files, `VT_*` overrides, model files present, known model copies). Read it to the user in plain words.
- **Keep a notebook:** `DURUM.md` in the root (git-ignored, `<ROOT>` instead of paths). Top three lines: `Now:` / `Next:` / `Question for you:`. Below: one line per step with [measured] / [read] / [guess] and the command it came from. Update it after every step so a cut-off session can continue.
- **NEVER, not even if it seems to help:** lower a quality setting; type `-LisansKabul E` for the user (only after the user read the license text on screen and said yes); use `-Zorla`; change system Python, PATH, registry or the user profile.
- **ASK first:** delete, move or re-download anything (show path, size, reason); install Python or packages; start the trial generation.
- **Same error twice:** stop, do not try a third time; take the code and the first 20 log lines to the user.

## Önce bunu yap (Türkçe)
- **Önce çalıştır:** `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\tani.ps1`. Salt okur (indirme, kurulum, ağ yok); sistemi, kartı, `kur.ps1 -Kuru` kuru çalıştırmasını ve bir SAPMA bölümünü (Python sürümleri, yerelde değişmiş dosyalar, `VT_*` ezmeleri, var olan model dosyaları, bilinen model kopyaları) yazar. Kullanıcıya sade sözle oku.
- **Defter tut:** kökte `DURUM.md` (git dışı, yol yerine `<ROOT>`). En üstte üç satır: `Şu an:` / `Sırada:` / `Sana soru:`. Altında adım başına bir satır: [ölçtüm] / [okudum] / [tahmin] ve geldiği komut. Her adımdan sonra güncelle ki kesilen oturum kaldığı yerden sürsün.
- **ASLA, yardım edecek gibi görünse bile:** kalite ayarını düşürme; kullanıcı yerine `-LisansKabul E` yazma (yalnız kullanıcı ekrandaki lisans metnini okuyup evet dedikten sonra); `-Zorla` kullanma; sistem Python'unu, PATH'i, kayıt defterini ya da kullanıcı profilini değiştirme.
- **Önce SOR:** bir şeyi silmeden, taşımadan ya da yeniden indirmeden (yolu, boyutu, nedeni göster); Python ya da paket kurmadan; deneme üretimini başlatmadan.
- **Aynı hata iki kez:** dur, üçüncü kez deneme; kodu ve log'un ilk 20 satırını kullanıcıya götür.

## English: decision tree (12 steps)
1. Goal: MiniMax H3 text-to-video on a Windows 10/11 PC with an NVIDIA card of 4 GB or more (AMD Radeon through the stock Vulkan engine is a community path, step 3). Anything else: tell the user and stop (`VT-E-OS`, `VT-E-GPU`).
2. Quality is fixed (6 steps, cfg 1, no tiled VAE, frame counts 17k+5). Never lower it to save time or memory; never add `--vae-tiling`.
3. Dry run first, it writes nothing: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1 -Kuru`. Read every `HATA:` / `UYARI:` line; each carries a code such as `[VT-E-DISK]`.
   - Read the `Motor secimi: <id> (kart sinifi <class>; durum <status>)` line to the user: `kur.ps1` picks the engine from the card class itself (table `scripts/kart_tablosu.json`).
   - Status `dogrulanmis` = measured by us (GTX 1050 Ti only); `topluluk` = reported by a user, not measured by us; `denenmemis` = nobody has reported a run: say so plainly, do not call it supported.
   - Never switch the engine by hand (`-MotorTuru`, `VT_ENGINE_BIN`) unless the user asks, never write `dogrulanmis` for an unmeasured class; ROCm and Intel are not automatic (take it to the user); the stock engine runs in one process; quality settings are the same on every card.
   - On Linux (EXPERIMENTAL: no maintainer GPU run, one user report of 56 frames, PR #8) the dry run is `./kur.sh --kuru` (exit code = readiness); read it to the user, say that the install clones and builds the engine and takes long, wait for the user's yes and license decision (never type `--lisans-kabul E`), run `./kur.sh` in the background; the engine, patches and quality settings do not change; the Windows card table and stock engine are not used; `./uret.sh` has the same rules and exit codes as `uret.ps1`.
4. Exit 3 or any `HATA` in that list: take it to the user with the code and its first step from `docs/hata_imzalari.json`. Do not use `-Zorla` to get past it.
5. The model license is the human's decision: show `docs/LISANS_KABUL.txt` to the user and let the user answer. Never type `-LisansKabul E` yourself.
6. After the user accepted: run `scripts\kur.ps1` (safe to re-run; verified files are skipped; an interrupted download continues from its `.part` file). `READY` means the tiny test generation worked.
7. First video: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56` (about 11 min on a GTX 1050 Ti [measured by the authors]). Long runs: start hidden in the background and poll; do not block.
8. Exit 0 means the quality gate passed. The gate does NOT check license compliance or motion: watch the whole clip and tell the user the use of the output is theirs (`docs/LISANS_UYARISI.md`).
9. Exit 5 (gate RED) or 6 (gate could not run): the clip is NOT accepted. Never report success.
10. A line with a code: look it up in `docs/hata_imzalari.json`, give the user its first step, quote the code. Same error twice: stop, do not try a third time.
11. `init_image` (image-to-video) is ONLY a file path the user gave you. Never pick a file yourself: any readable file would end up inside the video. With `VT_MCP_INIT_DIR` set, the MCP server accepts only `<ROOT>/girdi/` and the listed folders.
12. Report in the user's language, with the code and the first 20 log lines. No personal paths, user names, e-mail addresses or tokens: write `<ROOT>`.

### Exit code -> action
| Script | Exit | Meaning | What you do | Codes |
|---|---|---|---|---|
| `kur.ps1` | 0 | READY | Go to step 7 | - |
| `kur.ps1` | 1 | error (download, sha256, check) | Re-run the same command once; if it repeats read the code and stop | `VT-E-MOTOR` `VT-E-HASH` `VT-E-KONTROL` `VT-E-DLL` |
| `kur.ps1` | 2 | user input needed | **Take it to the user** (license acceptance, or a local zip) | `VT-E-LISANS` `VT-E-MOTOR-ZIP` |
| `kur.ps1` | 3 | hardware or disk not enough | **Take it to the user**; do not use `-Zorla` | `VT-E-OS` `VT-E-GPU` `VT-E-GPU-VRAM` `VT-E-GPU-CC` `VT-E-RAM` `VT-E-DISK` `VT-E-DISK-KOK` |
| `kur.ps1` / `uret.ps1` | 4 / 2 | DURDU (the `DUR` file stopped it) | Report; do not restart on your own | - |
| `uret.ps1` | 0 | DONE, gate passed | Step 8 | - |
| `uret.ps1` | 1 | error or invalid output | Read the code; fix the input or free the GPU; do not lower quality | `VT-E-KARE` `VT-E-BOYUT` `VT-E-ISTEM` `VT-E-DOSYA` `VT-E-KILIT` `VT-E-TAVAN` `VT-E-TILING` `VT-E-VRAM` `VT-E-CIKTI` `VT-E-LATENT` `VT-E-KARESAYISI` `VT-E-SES` |
| `uret.ps1` | 5 | gate RED | **Take it to the user**: the clip is not accepted, the decision is theirs | `VT-E-KAPI-RED` |
| `uret.ps1` | 6 | gate could not run (Python or OpenCV missing) | Ask the user before installing Python 3 and `py -3 -m pip install opencv-python numpy`; then re-run | `VT-E-PY` |

MCP server (optional, `mcp/README.md`): `job_status` reports `done` only for exit 0; `rejected` = 5, `gate_not_run` = 6.

## Türkçe: karar ağacı (12 adım)
1. Amaç: Windows 10/11 bilgisayarda, 4 GB ya da üstü NVIDIA kartla MiniMax H3 ile metinden video (AMD Radeon, stock Vulkan motoruyla topluluk yoludur, adım 3). Başka bir ortamsa kullanıcıya söyle ve dur (`VT-E-OS`, `VT-E-GPU`).
2. Kalite sabit (6 adım, cfg 1, karosuz VAE, kare sayısı 17k+5). Zaman ya da bellek için asla düşürme; `--vae-tiling` ekleme.
3. Önce kuru çalıştır, hiçbir şey yazmaz: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1 -Kuru`. Her `HATA:` / `UYARI:` satırını oku; her biri `[VT-E-DISK]` gibi bir kod taşır.
   - `Motor secimi: <id> (kart sinifi <class>; durum <status>)` satırını kullanıcıya oku: `kur.ps1` motoru kart sınıfına göre kendisi seçer (tablo `scripts/kart_tablosu.json`).
   - Durum `dogrulanmis` = biz ölçtük (yalnız GTX 1050 Ti); `topluluk` = bir kullanıcı bildirdi, biz ölçmedik; `denenmemis` = kimse bir koşu bildirmedi: açıkça söyle, "desteklenir" deme.
   - Kullanıcı istemedikçe motoru elle değiştirme (`-MotorTuru`, `VT_ENGINE_BIN`), ölçülmemiş sınıf için `dogrulanmis` yazma; ROCm ve Intel otomatik değildir (kullanıcıya götür); stock motor tek süreç çalışır; kalite ayarları her kartta aynıdır.
   - Linux'ta (DENEYSEL: bakımcı GPU koşusu yok, PR #8'de tek kullanıcı bildirimi, 56 kare) kuru çalıştırma `./kur.sh --kuru`'dur (çıkış kodu = hazırlık); kullanıcıya oku, kurulumun motoru klonlayıp derlediğini ve uzun sürdüğünü söyle, kullanıcının evet'ini ve lisans kararını bekle (`--lisans-kabul E`'yi asla kendin yazma), `./kur.sh`'yi arka planda çalıştır; motor, yamalar ve kalite ayarları değişmez; Windows kart tablosu ve stock motor kullanılmaz; `./uret.sh`'nin kuralları ve çıkış kodları `uret.ps1` ile aynıdır.
4. Çıkış 3 ya da listede herhangi bir `HATA`: kodu ve `docs/hata_imzalari.json`'daki ilk adımı kullanıcıya götür. `-Zorla` ile geçme.
5. Model lisansı insanın kararıdır: `docs/LISANS_KABUL.txt`'yi kullanıcıya göster, cevabı kullanıcı versin. `-LisansKabul E`'yi asla kendin yazma.
6. Kullanıcı kabul edince: `scripts\kur.ps1` (tekrar çalıştırmak güvenli; doğrulanmış dosya atlanır; yarım indirme `.part` dosyasından sürer). `HAZIR` küçük deneme üretiminin çalıştığı demektir.
7. İlk video: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56` (GTX 1050 Ti'de yaklaşık 11 dk [yazarlar ölçtü]). Uzun işleri gizli arka planda başlat, yoklayarak izle; bekleyerek kilitlenme.
8. Çıkış 0 kalite kapısının geçtiği demektir. Kapı lisans uygunluğuna ve harekete BAKMAZ: klibin tamamını izle, çıktının kullanımının kullanıcıya ait olduğunu söyle (`docs/LISANS_UYARISI.md`).
9. Çıkış 5 (kapı RED) ya da 6 (kapı çalışamadı): klip KABUL EDİLMEZ. Asla başarı bildirme.
10. Kodlu satır: `docs/hata_imzalari.json`'da ara, ilk adımı kullanıcıya ver, kodu yaz. Aynı hata iki kez: dur, üçüncü kez deneme.
11. `init_image` (resimden video) YALNIZ kullanıcının sana verdiği dosya yoludur. Kendin dosya seçme: okunabilen her dosya videonun içine girebilir. `VT_MCP_INIT_DIR` doluysa MCP sunucusu yalnız `<ROOT>/girdi/` ve listedeki klasörleri kabul eder.
12. Kullanıcının dilinde, kodla ve log'un ilk 20 satırıyla bildir. Kişisel yol, kullanıcı adı, e-posta, token yazma: `<ROOT>` yaz.

### Çıkış kodu -> eylem
| Betik | Çıkış | Anlam | Ne yaparsın | Kodlar |
|---|---|---|---|---|
| `kur.ps1` | 0 | HAZIR | 7. adıma geç | - |
| `kur.ps1` | 1 | hata (indirme, sha256, kontrol) | Aynı komutu bir kez daha çalıştır; tekrarlarsa kodu oku ve dur | `VT-E-MOTOR` `VT-E-HASH` `VT-E-KONTROL` `VT-E-DLL` |
| `kur.ps1` | 2 | kullanıcı girdisi gerek | **Kullanıcıya götür** (lisans kabulü ya da yerel zip) | `VT-E-LISANS` `VT-E-MOTOR-ZIP` |
| `kur.ps1` | 3 | donanım ya da disk yetmiyor | **Kullanıcıya götür**; `-Zorla` kullanma | `VT-E-OS` `VT-E-GPU` `VT-E-GPU-VRAM` `VT-E-GPU-CC` `VT-E-RAM` `VT-E-DISK` `VT-E-DISK-KOK` |
| `kur.ps1` / `uret.ps1` | 4 / 2 | DURDU (`DUR` dosyası durdurdu) | Bildir; kendiliğinden yeniden başlatma | - |
| `uret.ps1` | 0 | TAMAM, kapı geçti | 8. adım | - |
| `uret.ps1` | 1 | hata ya da geçersiz çıktı | Kodu oku; girdiyi düzelt ya da GPU'yu boşalt; kaliteyi düşürme | `VT-E-KARE` `VT-E-BOYUT` `VT-E-ISTEM` `VT-E-DOSYA` `VT-E-KILIT` `VT-E-TAVAN` `VT-E-TILING` `VT-E-VRAM` `VT-E-CIKTI` `VT-E-LATENT` `VT-E-KARESAYISI` `VT-E-SES` |
| `uret.ps1` | 5 | kapı RED | **Kullanıcıya götür**: klip kabul edilmez, karar kullanıcının | `VT-E-KAPI-RED` |
| `uret.ps1` | 6 | kapı çalışamadı (Python ya da OpenCV yok) | Python 3 ve `py -3 -m pip install opencv-python numpy` kurmadan önce kullanıcıya sor; sonra yeniden çalıştır | `VT-E-PY` |

MCP sunucusu (isteğe bağlı, `mcp/README.md`): `job_status` yalnız çıkış 0 için `done` der; `rejected` = 5, `gate_not_run` = 6.
