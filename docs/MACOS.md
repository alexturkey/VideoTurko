# macOS (Apple Silicon / Metal) Kurulum ve Test Raporu (TR)

> **EN summary.** Community report from PR #10 (@otnemem): VideoTurko ran on an Apple M5 Pro with 48 GB unified memory using the official stable-diffusion.cpp macOS ARM64 (Metal) release `master-1111-6874e49`, no patches, with the same quality settings (6 steps, cfg 1, 640x384, tile-less VAE, seed 42, 24 fps). Default mode: 209 frames in about 704 s; optional 48 GB mode (`TAM_METAL=1`): 56 frames in about 105 s. All numbers are [user-reported, PR #10]; the maintainers have no Mac and did not re-measure them. Mode B was checked by eye only; its numeric equivalence to Mode A is not measured. The quality gate did not run on this Mac (no OpenCV). macOS is not an officially supported platform. Helper script: `scripts/mac_uret.sh`.
>
> **Kaynak / Source:** [kullanıcı bildirdi, PR #10]; bakımcılar Mac'te ölçmedi. Bakımcıların doğruladığı tek şey: motor zip'inin sha256'sı upstream sürüm kaydıyla aynı [ölçtük, 2026-11-23]. Zip adındaki `macOS-26.7.2`, upstream'in derlediği makinenin sürümüdür; aşağıdaki macOS sürümü katkıcının makinesidir.
>
> **Lisans ve bölge / License and region:** MiniMax H3 çıktısının kullanımı AB, Birleşik Krallık, Güney Kore ve ABD'de kısıtlıdır; modeli indirmeden önce `docs/LISANS_KABUL.txt` ve `docs/LISANS_UYARISI.md` okunur. Lisansı kullanıcı kabul eder, ajan kabul etmez. / Output use is restricted in the EU, UK, South Korea and the US; read `docs/LISANS_UYARISI.md` first. The user accepts the license, never an agent.

**Donanım:** MacBook Pro (`Mac17,12`), Apple M5 Pro — 18 çekirdek CPU (6 Super + 12 Performance), 20 çekirdek dahili GPU (`MTL0`, `MTLGPUFamilyApple10`, `MTLGPUFamilyMetal4`, `recommendedMaxWorkingSetSize = 40200.90 MB`), **48 GB birleşik bellek**, **macOS 27.2.1** (`arm64`, Build `26B8132`) `[kullanıcı bildirdi]`.  
**Tarih:** 2026-11-23  
**Motor:** `stable-diffusion.cpp` resmî hazır macOS ARM64 (Metal) sürümü `master-1111-6874e49` (`sd-master-6874e49-bin-Darwin-macOS-26.7.2-arm64.zip`, 36,6 MB, sha256 `6142da141ee5662d9c2fda88c2d032d8c3b5482ad14dc988bdd74b9123b59661`), `patches/` içinden yama uygulanmadı `[kullanıcı bildirdi]`.

> **Topluluk bildirimi:** Bu deponun hazır motoru ve `.ps1` betikleri Windows + NVIDIA CUDA (`sm_61`) içindir; macOS/Metal resmî desteklenen platform değildir. Aşağıdaki tüm sayılar katkıcının bu makinede aldığı ölçümlerdir `[kullanıcı bildirdi, PR #10]`. Kalite ayarlarına dokunulmadı: **6 adım, `cfg 1.0`, `640x384` varsayılan, karosuz (parçasız) VAE, tohum `42`, `24 fps`**.

---

## 1. Kurulum Adımları

1. **Donanım ve disk ön kontrolü `[kullanıcı bildirdi]`:** `sw_vers`, `system_profiler SPHardwareDataType SPDisplaysDataType`, `vm_stat` ve `df -h` ile birleşik bellek (48 GB) ve boş SSD alanı (en az 40 GB gerekir; ölçülen 732 GiB boş) doğrulandı.
2. **Motoru indirme ve açma `[kullanıcı bildirdi]`:** `leejet/stable-diffusion.cpp` GitHub Releases sayfasından `master-1111-6874e49` etiketli `sd-master-6874e49-bin-Darwin-macOS-26.7.2-arm64.zip` arşivi (36,6 MB) indirilip `shasum -a 256` ile (`6142da141ee5662d9c2fda88c2d032d8c3b5482ad14dc988bdd74b9123b59661`) doğrulandı ve `<ROOT>/engine_mac/bin` altına açıldı. `otool -L` ile `libstable-diffusion.dylib` (`arm64`) dosyasının `Metal.framework` ve `MetalKit.framework` ile bağlı olduğu doğrulandı.
3. **4 model dosyasını indirme ve `sha256` doğrulaması `[kullanıcı bildirdi]`:** MiniMax H3 Community License (`docs/LISANS_KABUL.txt`) okunup kabul edildikten sonra `scripts/modeller.json` içindeki 4 dosya (toplam 31.473.112.040 bayt / ~29,31 GiB) `<MODEL_DIR>` altına indirilip `shasum -a 256` ile doğrulandı:
   - `minimax_h3_fl2va_hyperflow_flash_14b-Q4_K_M.gguf` (8,4 GiB)
   - `qwen3vl_32b_minimax_h3-Q4_K_M.gguf` (17,0 GiB)
   - `minimax_h3_sol_vae_fp16.safetensors` (3,3 GiB)
   - `minimax_h3_audio_vae_fp32.safetensors` (577 MiB)
4. **Cihaz doğrulaması `[kullanıcı bildirdi]`:** `<ROOT>/engine_mac/bin/sd-cli --list-devices` çıktısında `MTL0	Apple M5 Pro` satırı doğrulandı (`recommendedMaxWorkingSetSize = 40200.90 MB`).

---

## 2. İki Çalıştırma Modu (Varsayılan vs. 48 GB İsteğe Bağlı)

Kalite ayarları her iki modda da birebir aynıdır (**6 adım, `cfg 1.0`, `640x384`, `24 fps`, tohum `42`, parçasız VAE**). Mod B bellek ve hız ayarlarını değiştirir (`--flash-attn on`, `--auto-fit on`, `budget=0`); Mod A ile sayısal eşdeğerliği ölçülmedi, çıktı yalnız gözle kontrol edildi `[denenmedi]`.

### A. İlk Çalışan Hâl — Herkes İçin Varsayılan (Güvenli Bellek Modu)
Ağırlıkları bellek eşlemeli (`--mmap`) olarak RAM'de tutar, metin kodlayıcıyı CPU'da çalıştırır ve dikkat (attention) belleğini `0.03 GiB` ile sınırlar. 209 kare (8,7 sn) tek süreçte sorunsuz tamamlanır `[kullanıcı bildirdi]`:

```bash
<ROOT>/engine_mac/bin/sd-cli -M vid_gen \
  --diffusion-model <MODEL_DIR>/minimax_h3_fl2va_hyperflow_flash_14b-Q4_K_M.gguf \
  --llm <MODEL_DIR>/qwen3vl_32b_minimax_h3-Q4_K_M.gguf \
  --vae <MODEL_DIR>/minimax_h3_sol_vae_fp16.safetensors \
  --audio-vae <MODEL_DIR>/minimax_h3_audio_vae_fp32.safetensors \
  --prompt-file <ROOT>/docs/ornek_istem_R0.txt \
  -W 640 -H 384 --video-frames 209 --fps 24 \
  --steps 6 --sampling-method euler --sigmas hyperflow-h3-flash-6 --cfg-scale 1.0 \
  --rng cpu --seed 42 -t 8 --flash-attn off,diffusion=on \
  --model-args minimax_h3_attn_chunk_budget=0.03 \
  --offload-to-cpu --mmap --backend te=cpu \
  -o <ROOT>/runs/out_209.avi
```

### B. 48 GB+ Mac İçin İsteğe Bağlı Hız Ayarı (`TAM_METAL=1`)
48 GB birleşik bellekte (~38–40 GB Metal GPU çalışma alanı), `--offload-to-cpu` ve `--backend te=cpu` kaldırılıp `--auto-fit on --flash-attn on` ve `minimax_h3_attn_chunk_budget=0` verildiğinde 30,0 GB ağırlığın tamamı doğrudan `MTL0` GPU'ya yerleşir. Metin kodlama 63,7–75,8 sn'den **4,33–4,38 sn**'ye düşer (**14,5–17,5× hızlanma**), 56 kare toplam süre **172,47 sn → 105,05 sn** olur `[kullanıcı bildirdi]`:

```bash
<ROOT>/engine_mac/bin/sd-cli -M vid_gen \
  --diffusion-model <MODEL_DIR>/minimax_h3_fl2va_hyperflow_flash_14b-Q4_K_M.gguf \
  --llm <MODEL_DIR>/qwen3vl_32b_minimax_h3-Q4_K_M.gguf \
  --vae <MODEL_DIR>/minimax_h3_sol_vae_fp16.safetensors \
  --audio-vae <MODEL_DIR>/minimax_h3_audio_vae_fp32.safetensors \
  --prompt-file <ROOT>/istem.txt \
  -W 640 -H 384 --video-frames 56 --fps 24 \
  --steps 6 --sampling-method euler --sigmas hyperflow-h3-flash-6 --cfg-scale 1.0 \
  --rng cpu --seed 42 --flash-attn on --auto-fit on \
  --model-args minimax_h3_attn_chunk_budget=0 --mmap \
  -o <ROOT>/runs/out_56_metal.avi
```

*(Yardımcı betik: `scripts/mac_uret.sh` varsayılan olarak **Mod A** ile çalışır; 48 GB+ Mac'lerde isteğe bağlı `TAM_METAL=1 scripts/mac_uret.sh <istem.txt> 56` ile **Mod B** açılır.)*

---

## 3. Ölçümler `[kullanıcı bildirdi]`

### Ana 209 Kare Ölçümü (Mod A — Varsayılan, `640x384`, 8,7 sn, 6 adım, `cfg=1.0`, `seed=42`)
- **Toplam süre (`generate_video completed`):** **703,76 sn** (11 dk 44 sn) `[kullanıcı bildirdi]`
- **Metin kodlama (`get_learned_condition`):** **75,81 sn** `[kullanıcı bildirdi]`
- **6 adım örnekleme (`sampling`):** **595,54 sn** (~99 sn/adım) `[kullanıcı bildirdi]`
- **Video VAE (`decode_first_stage`, parçasız):** **27,62 sn** `[kullanıcı bildirdi]`
- **Ses VAE (`MiniMax-H3 audio VAE decode`):** **4,70 sn** `[kullanıcı bildirdi]`
- **Bellek tepesi (`/usr/bin/time -l`):** **31,62 GiB** max RSS (`mmap` dâhil), **9,32 GiB** aktif tepe (`peak memory footprint`), **0 swap** `[kullanıcı bildirdi]`

### Varsayılan (Mod A) ve 48 GB İsteğe Bağlı (Mod B) Karşılaştırma Tablosu `[kullanıcı bildirdi]`

| Mod | Koşu | Boyut | Kare | Metin Kodlama | 6 Adım Örnekleme | Video + Ses VAE | Toplam (`generate_video`) | En Yüksek Bellek (`/usr/bin/time -l`) |
|---|---|---|---:|---:|---:|---:|---:|---|
| **Mod A (Varsayılan)** | `ornek_istem_R0` | 640×384 | 56 | 15,47 sn | 118,21 sn | 12,10 + 2,24 sn | **148,03 sn** (2 dk 28 sn) | 31,20 GiB max RSS · 8,87 GiB aktif · 0 swap |
| **Mod A (Varsayılan)** | 2B dans | 640×384 | 56 | 63,74 sn | 99,82 sn | 7,45 + 1,43 sn | **172,47 sn** (2 dk 52 sn) | 28,56 GiB max RSS · 8,93 GiB aktif · 0 swap |
| **Mod B (48 GB `TAM_METAL=1`)** | 2B dans (aynı istem) | 640×384 | 56 | **4,38 sn** | **91,23 sn** | 7,86 + 1,56 sn | **105,05 sn** (1 dk 45 sn) | 30,0 GB ağırlık `MTL0`'da · 0,81 GiB CPU RSS · 1,04 GiB aktif CPU · 0 swap |
| **Mod A (Varsayılan)** | 2B dans | 640×384 | 209 | 68,31 sn | 601,80 sn | 26,59 + 4,55 sn | **701,34 sn** (11 dk 41 sn) | 30,14 GiB max RSS · 9,31 GiB aktif · 0 swap |
| **Mod A (Varsayılan)** | Robot sahnesi | 640×384 | 209 | 75,81 sn | 595,54 sn | 27,62 + 4,70 sn | **703,76 sn** (11 dk 44 sn) | 31,62 GiB max RSS · 9,32 GiB aktif · 0 swap |
| **Mod B (48 GB `TAM_METAL=1`)** | Robot (yüksek çöz.) | 960×544 | 56 | 4,33 sn | 247,92 sn | 19,78 + 1,53 sn | **273,62 sn** (4 dk 34 sn) | 30,0 GB ağırlık `MTL0`'da · 1,43 GiB CPU RSS · 1,69 GiB aktif CPU · 0 swap |
| **Mod B (`budget=0.5`)** | Robot (768p) | 1344×768 | 56 | 4,35 sn | 736,24 sn | 34,20 + 1,55 sn | **776,44 sn** (12 dk 56 sn) | 30,0 GB ağırlık `MTL0`'da · 2,60 GiB CPU RSS · 2,86 GiB aktif CPU · 0 swap |

---

## 4. Karşılaşılan Sorunlar ve Çözümleri

1. **`--list-devices` cihaz adı (`MTL0`) `[kullanıcı bildirdi]`:** Metal cihazı `metal` değil `MTL0` adıyla listelenir; kontrol betikleri `MTL0|metal` aramalıdır.
2. **İzole kabukta Metal'in gizlenmesi `[kullanıcı bildirdi]`:** Kısıtlı alt kabuklarda `sd-cli --list-devices` yalnız CPU/Accelerate görür; doğrudan macOS Terminal'inden çalıştırıldığında `MTL0` görünür.
3. **`1344x768 × 209 kare` bellek kapısı (`Mod B`) `[kullanıcı bildirdi]`:** 30,0 GB ağırlığın tamamı `MTL0`'da yerleşikken (26,01 GB aktif), `1344x768 × 209` koşusu `blocks.0` aşamasında 18,76 GB hesap tamponu istedi ve 12,32 GB boş alan yetmedi (6,39 sn'de `failed during weight preparation`). Bu uç boyutta **Mod A** (`--offload-to-cpu` + küçük `chunk_budget`) gerekir `[tahmin; 1344x768 × 209 Mod A ile henüz denenmedi]`.
4. **Uzun koşuda uyku `[kullanıcı bildirdi, PR #28]`:** Koşu sessizce kesilirse bkz. bölüm 6 madde 1; uzun koşularda `caffeinate -i` kullanın (EN: if a long run stops silently, see section 6 item 1 and wrap the command in `caffeinate -i`).

---

## 5. Kalite Kapısı (Dikiş Denetimi) Sonucu

- **Otomatik kalite kapısı (`scripts/dikis_denetim.py` / `scripts/doku_norm.py`):** `[denenmedi]` — bu Mac'te `opencv-python` (`cv2`) kurulu olmadığından sayısal gürültü ve orta akış kapısı çalıştırılamadı.
- **Günlük ve gözle doğrulama `[kullanıcı bildirdi]`:** Başarılı 7 koşunun hiçbirinde `retrying with temporal tiling`, `ALLOC_FAILED`, `[E]` veya swap görülmedi; 56 ve 209 kare çıktılar sesle birlikte baştan sona izlenerek doğrulandı.

---

## 6. İkinci Mac: Apple M4 Pro, 24 GB, motor `master-1106-532d2c1` (topluluk bildirimi, @Gperyy)

> **EN summary.** A second Mac, smaller than the one above: Apple M4 Pro (MacBook Pro laptop) with **24 GB** unified memory (`recommendedMaxWorkingSetSize = 19069.67 MB`), macOS 27.2.1. Official stable-diffusion.cpp macOS ARM64 (Metal) release `master-1106-532d2c1` (the same tag as the stock engine in `scripts/kart_tablosu.json`), no patches, **Mode A** through `scripts/mac_uret.sh` unchanged, same quality settings. 56, 124 and 209 frames all finished in one process and **passed the quality gate** (it ran this time: OpenCV in a local `.venv`). 209 frames: `generate_video` 1515.85 s, 12.18 GiB max RSS, 9.18 GiB peak footprint, no tiled-VAE fallback. Mode B (`TAM_METAL=1`) was not tried: 30 GB of weights cannot fit a 19 GB Metal working set [computed]. All numbers are [user-reported, PR #28] from one machine (contributor @Gperyy), 2026-11-24/25; the maintainers have no Mac and did not re-run anything. The one thing the maintainers checked is the engine zip size and sha256 against the upstream release record (checked 2026-11-25).
>
> **Kaynak / Source:** [kullanıcı bildirdi, PR #28] (@Gperyy); bakımcılar Mac'te ölçmedi ve tekrar etmedi. Bakımcıların doğruladığı tek şey: motor zip'inin boyutu ve sha256'sı upstream sürüm kaydıyla aynı [ölçtük, 2026-11-25]. Zip adındaki `macOS-26.7.2` upstream'in derlediği makinenin sürümüdür; aşağıdaki macOS sürümü katkıcının makinesidir.

**Donanım:** MacBook Pro dizüstü (`Mac16,8`), Apple M4 Pro — 12 çekirdek CPU (8 Performance + 4 Efficiency), 16 çekirdek GPU (`MTL0`, Metal 4, `recommendedMaxWorkingSetSize = 19069.67 MB`), **24 GB birleşik bellek**, **macOS 27.2.1** (Build `26B131`) `[kullanıcı bildirdi, PR #28]`.  
**Tarih:** 2026-11-24 / 2026-11-25  
**Motor:** `stable-diffusion.cpp` resmî hazır macOS ARM64 (Metal) sürümü `master-1106-532d2c1` (`sd-master-532d2c1-bin-Darwin-macOS-26.7.2-arm64.zip`, 38.331.254 bayt, sha256 `8146d6ffc75f8ff8f64b62a80fffee8fb714ab65e368e202084135fa07cc6f36`, upstream sürüm kaydıyla aynı), `patches/` içinden yama uygulanmadı `[kullanıcı bildirdi, PR #28]`. 4 model dosyası `scripts/modeller.json` sha256 değerleriyle doğrulandı `[kullanıcı bildirdi, PR #28]`.  
**Komut:** `scripts/mac_uret.sh docs/ornek_istem_R0.txt <kare>` (Mod A, `TAM_METAL=0`, betikte değişiklik yok). Süre ve bellek betiğin kendi `/usr/bin/time -l` çıktısından; swap `sysctl vm.swapusage` ile 10 sn'de bir örneklendi.

### Ölçümler (Mod A, `ornek_istem_R0`, 640×384, 6 adım, `cfg 1.0`, tohum 42, 24 fps) `[kullanıcı bildirdi, PR #28]`

| Kare | Metin kodlama | 6 adım örnekleme | Video + ses VAE | Toplam (`generate_video`) | Duvar saati | Max RSS | Peak footprint | Swap (önce → sonra) | Kalite kapısı |
|---:|---:|---:|---:|---:|---:|---:|---:|---|---|
| 56 | 27,09 sn | 283,28 sn | 27,48 + 3,46 sn | **341,34 sn** (5 dk 41 sn) | 344 sn | 10,79 GiB | 8,85 GiB | 2,02 → 3,94 GiB | `KAPI GECTI` gürültü 0,69, orta akış 4,02 |
| 124 | 28,25 sn | 648,34 sn | 49,26 + 5,53 sn | **731,43 sn** (12 dk 11 sn) | 735 sn | 10,99 GiB | 9,04 GiB | 1,78 → 2,14 GiB | `KAPI GECTI` gürültü 0,64, orta akış 3,20 |
| 209 | 26,97 sn | 1401,16 sn | 78,76 + 8,87 sn | **1515,85 sn** (25 dk 16 sn) | 1520 sn | 12,18 GiB | 9,18 GiB | 2,14 → 3,14 GiB | `KAPI GECTI` gürültü 0,62, orta akış 2,82 |

- Üç koşunun günlüğünde de `retrying with temporal tiling`, `ALLOC_FAILED`, `[E]` ya da `compute failed` satırı yok; video VAE parçasız çalıştı `[kullanıcı bildirdi, PR #28]`.
- `ffmpeg blackdetect` (`pix_th 0.10`, `d 0.04`): üç videoda da siyah aralık yok; en karanlık karenin ortalama parlaklığı (YAVG) en az 126. Ses akışı var (ortalama −19,6 / −14,9 / −25,1 dB) `[kullanıcı bildirdi, PR #28]`. 209 kare çıktısı 9 karelik pafta ile gözle de kontrol edildi: sahne baştan sona tutarlı `[kullanıcı bildirdi, PR #28]`.
- Swap koşudan önce de kullanımdaydı (makinede başka uygulamalar açıktı); artışın tamamı `sd-cli`'ye ait olmayabilir `[tahmin]`. Yani 24 GB'lık bir Mac'te bu koşular sırasında yaklaşık 2-4 GiB swap kullanımı görüldü `[kullanıcı bildirdi, PR #28]`.
- Yukarıdaki M5 Pro 48 GB ile kıyas (Mod A, 209 kare, 703,76 sn `[kullanıcı bildirdi, PR #10]`): bu makine yaklaşık **2,15× daha yavaş**; adım başına ~234 sn'ye karşı ~99 sn `[hesap]`. Max RSS'in 31 GiB yerine 11–12 GiB çıkması, 24 GB'ta sistemin bellek eşlemeli (`--mmap`) sayfaları geri almasından olabilir `[tahmin]`.
- Örnekleme süresi kare sayısından hızlı büyüyor: 56 → 209 karede kare 3,73× artarken örnekleme 4,95× arttı `[hesap]`.

### Karşılaşılan sorunlar

1. **Mac uykuya geçince koşu sessizce durdu `[kullanıcı bildirdi, PR #28]`:** İlk 124 kare denemesi 6 adımın 5.'sinde, günlüğe hata yazmadan kesildi (yaklaşık 10 dk sonra; neden olarak sistem uykusu tahmin ediliyor `[tahmin]`). Aynı komut `caffeinate -i` ile yeniden çalıştırıldığında sorunsuz bitti. Uzun koşularda: `caffeinate -i scripts/mac_uret.sh docs/ornek_istem_R0.txt 209`.
2. **`engine_mac/` repo klasöründeyken `scripts/denetim.py --hizli` KIRMIZI `[kullanıcı bildirdi, PR #28]`:** `engine_mac/` o sırada `.gitignore`'da yoktu (bu düzeltmeden sonra `/engine_mac/` satırı var); denetim takip edilmeyen dosyaları da taradığı için `libstable-diffusion.dylib` içindeki baytları gizli Unicode sayıyor, `start-server.bat` için de CRLF kuralı istiyor. Yerel çözüm: `engine_mac/` satırını `.git/info/exclude` dosyasına eklemek; sonra denetim GECTI. Aynı yüzden `engine_mac/` dosyaları kolayca commit'e girebilir.
3. **Kalite kapısı için OpenCV `[kullanıcı bildirdi, PR #28]`:** Sistem Python'una dokunmadan repo kökünde `.venv` kuruldu (`python3 -m venv .venv && .venv/bin/python -m pip install opencv-python-headless numpy`; OpenCV 5.1.0, numpy 2.0.2). `scripts/mac_uret.sh` bu `.venv`'i kendiliğinden buldu ve kapıyı çalıştırdı.

---

## 7. Üçüncü Mac: iMac, Apple M4, 16 GB, motor `master-1106-532d2c1` `[ölçtüm]`

> **EN summary.** The smallest Mac so far: an iMac with Apple M4 and **16 GB** unified memory (`recommendedMaxWorkingSetSize = 12713.12 MB`), macOS 27.2.1. Official stable-diffusion.cpp macOS ARM64 (Metal) release `master-1106-532d2c1` (zip sha256 `8146d6ffc75f8ff8f64b62a80fffee8fb714ab65e368e202084135fa07cc6f36`, checked at install), no patches, **Mode A** (`TAM_METAL=0`, `minimax_h3_attn_chunk_budget=0.03`) through `scripts/mac_uret.sh` unchanged, quality settings unchanged. The 5-frame install check with the sample prompt passed the quality gate (127.68 s). A 124-frame **vertical 384x640** clip with the contributor's own prompt ran in one process: `generate_video` 1683.25 s, 10.24 GiB max RSS, 9.03 GiB peak footprint, no tiled-VAE fallback, gate passed (thresholds are calibrated for 640x384). Swap was not recorded. No run at the default 640x384 longer than 5 frames yet. Mode B (`TAM_METAL=1`) was not tried: 30 GB of weights cannot fit a 12.7 GB Metal working set [computed]. Runs made by Claude on the contributor's Mac; the maintainers have not repeated them.

**Donanım:** iMac, Apple M4, **16 GB birleşik bellek** (`MTL0`, `MTLGPUFamilyApple9`, Metal 4, `recommendedMaxWorkingSetSize = 12713.12 MB`), **macOS 27.2.1** `[ölçtüm]`.
**Tarih:** 2026-11-27
**Motor:** `sd-master-532d2c1-bin-Darwin-macOS-26.7.2-arm64.zip` (`https://github.com/leejet/stable-diffusion.cpp/releases/tag/master-1106-532d2c1`, MIT), yama yok; 4 model dosyası `scripts/modeller.json` sha256 değerleriyle indirildi ve doğrulandı (MiniMax H3 Community License, lisansı kullanıcı kabul etti). Kalite kapısı için `.venv`: opencv-python-headless 5.1.0, numpy 2.5.5 (PyPI).

| Koşu | İstem | Boyut | Kare | Metin kodlama | 6 adım örnekleme | Video + ses VAE | Toplam (`generate_video`) | Max RSS / peak footprint | Kalite kapısı |
|---|---|---|---:|---:|---:|---:|---:|---|---|
| Kurulum kontrolü | `ornek_istem_R0` | 640×384 | 5 | 36,69 sn | 75,22 sn | 14,03 sn | **127,68 sn** | 9,36 GiB / 8,73 GiB | `KAPI GECTI` gürültü 0,89, orta akış 2,09 |
| Kendi istemi (Topluluk deneyi) | kendi | 384×640 dikey | 124 | 116,48 sn | 1462,31 sn | 95,07 sn | **1683,25 sn** (28 dk 3 sn) | 10,24 GiB / 9,03 GiB | `KAPI GECTI` gürültü 0,64, orta akış 1,81 (eşikler 640x384 için) |

- Swap kullanımı ölçülmedi `[ölçülmedi]`; koşular `caffeinate -i` ile yapıldı, uyku kesintisi olmadı `[ölçtüm]`.
- 124 karelik koşuda adım başına yaklaşık 244 sn `[hesap]`; aynı motor ve Mod A ile M4 Pro 24 GB'taki 640×384 124 karelik koşu (731,43 sn, `docs/MACOS.md` bölüm 6) ile kıyas yapılamaz, çünkü boyut ve istem farklı `[hesap]`.
- Bu koşular VideoTurko'nun desteklenen 640×384 varsayılanı dışında (dikey 384×640) olduğu için `docs/KART_PROFILLERI.md`'de Topluluk deneyleri bölümündedir.
