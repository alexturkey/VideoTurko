# Kendin derle / Build it yourself (EN + TR)

EN: Advanced appendix. Normal users follow the 3-step Quick start in README.md; this page is for building the engine from source.
TR: Ek bolum (ileri duzey). Normal kullanici README.md icindeki 3 adimi izler; bu sayfa motoru kaynaktan derlemek icindir.

Placeholders: `<ROOT>` = a short neutral working directory, `<MODEL_DIR>` = where the model files live. Never put a personal path in scripts.

## 0. Install help: the dry-run report, double-click files, disk, resume
EN:
- **Dry run first (changes nothing):** `kur.cmd -Kuru` (or `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1 -Kuru`) prints a report and downloads and writes nothing. Lines starting with `HATA:` stop the install and must be fixed; lines starting with `UYARI:` are warnings you may accept. The last line is `== KURU ON RAPOR TAMAM: N HATA, M UYARI`. Exit code 3 means at least one `HATA:` was listed (hardware or disk), 0 means none. Every line carries a stable code such as `[VT-E-DISK]`: look it up in `docs/SIK_HATALAR.md` (anchor `#vt-e-disk`) or `docs/hata_imzalari.json`, and put the code in your issue. [measured: dry runs on a copy root, including a fake free-disk value]
- **Double-click files (Windows):** `kur.cmd` runs `scripts\kur.ps1` and passes extra flags (such as `-Kuru`) on; `uret.cmd` takes a prompt text file (drag it onto `uret.cmd`, or `uret.cmd docs\ornek_istem_R0.txt`) and makes the first 56-frame video; any other arguments go to `scripts\uret.ps1` unchanged. Both wait for a key only when started by double-click (not in a terminal run). If Windows warns about a downloaded file, use the PowerShell command from the README instead [advice, not tested on a downloaded ZIP]. [measured: `cmd /c` runs in a folder with spaces and non-ASCII letters; a double-click start was simulated, not done by hand]
- **Disk:** at least 32 GiB free on the model drive; 40 GiB or more is recommended. Between 32 and 40 GiB the installer prints `UYARI: [VT-W-DISK-PAY]` and continues; below 32 it stops with `HATA:` and exit code 3 [measured: fake-disk dry runs at 31.9, 32, 35, 39.9, 40 and 45 GiB].
- **Interrupted download:** a half-downloaded model file stays as a `.part` file; run the same command again and the download continues from it, and a wrong sha256 deletes the `.part` file with a warning [read: `scripts/modelleri_indir.ps1`; the status report with a `.part` over 2 GiB was run, a full 29 GiB resume was not measured, so do not count on it blindly].

TR:
- **Önce kuru çalışma (hiçbir şeyi değiştirmez):** `kur.cmd -Kuru` (ya da `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1 -Kuru`) rapor yazar, hiçbir şey indirmez ve yazmaz. `HATA:` ile başlayan satırlar kurulumu durdurur, düzeltilmelidir; `UYARI:` satırları kabul edebileceğiniz uyarılardır. Son satır `== KURU ON RAPOR TAMAM: N HATA, M UYARI`. Çıkış kodu 3 = en az bir `HATA:` listelendi (donanım ya da disk), 0 = hiç yok. Her satır `[VT-E-DISK]` gibi sabit bir kod taşır: kodu `docs/SIK_HATALAR.md` (bağlantı `#vt-e-disk`) ya da `docs/hata_imzalari.json` içinde arayın ve kodu issue'nuza yazın. [ölçtüm: kopya kökte kuru çalışmalar, sahte boş disk değeri dahil]
- **Çift tıklanan dosyalar (Windows):** `kur.cmd`, `scripts\kur.ps1` dosyasını çalıştırır ve ek bayrakları (`-Kuru` gibi) iletir; `uret.cmd` bir istem metin dosyası alır (dosyayı `uret.cmd` üzerine sürükleyin ya da `uret.cmd docs\ornek_istem_R0.txt`) ve 56 karelik ilk videoyu üretir; başka argümanlar `scripts\uret.ps1` dosyasına aynen gider. İkisi de yalnız çift tıklayınca bir tuş bekler (terminalden çalıştırmada beklemez). Windows indirilen dosya için uyarırsa README'deki PowerShell komutunu kullanın [öneri, indirilmiş ZIP'te denenmedi]. [ölçtüm: boşluklu ve Türkçe harfli klasörde `cmd /c` koşuları; çift tık taklit edildi, elle yapılmadı]
- **Disk:** model sürücüsünde en az 32 GiB boş; 40 GiB ve üzeri önerilir. 32 ile 40 GiB arasında kurulum `UYARI: [VT-W-DISK-PAY]` yazar ve sürer; 32'nin altında `HATA:` ve çıkış kodu 3 ile durur [ölçtüm: 31,9, 32, 35, 39,9, 40 ve 45 GiB sahte disk ile kuru koşular].
- **Yarım kalan indirme:** yarım inen model dosyası `.part` olarak kalır; aynı komutu yeniden çalıştırın, indirme ondan sürer; yanlış sha256 `.part` dosyasını uyarıyla siler [okudum: `scripts/modelleri_indir.ps1`; 2 GiB'ı aşan `.part` ile durum raporu koşuldu, tam 29 GiB'lik devam ölçülmedi: kör güvenmeyin].

## 1. Hardware (measured on the reference machine)
- GPU GTX 1050 Ti 4 GB (Pascal, compute capability 6.1), driver 581.29, PCIe Gen3 x8; RAM 15.9 GB (about 9 GB usable); i7-7700HQ 4 cores/8 threads, AVX2 (no AVX-512).
- Put the models on an NVMe SSD (about 1.4 GB/s); on a 2.5-inch HDD (50-130 MB/s) the first steps are 15-25x slower.
- Pascal has no int8 tensor cores, BF16, FP8 or NVFP4: only GGUF K-quants through the dp4a MMQ path are used.

TR: GTX 1050 Ti 4 GB (Pascal, CC 6.1), sürücü 581.29, PCIe Gen3 x8, RAM 15,9 GB (~9 GB kullanılabilir), i7-7700HQ AVX2 (AVX-512 yok). Modeller NVMe'de olsun; HDD'de ilk adımlar 15-25 kat yavaş. Pascal'da int8/BF16/FP8 yok, yalnız GGUF K-nicem (dp4a MMQ).

## 2. Build
Visual Studio 2022 Build Tools (x64 tools), CMake + Ninja, CUDA 12.8 (nvcc). Build in a neutral short root (the `__FILE__` macro embeds source paths into binaries):
```
cmake -S <ROOT>/src -B <ROOT>/build -G Ninja -DCMAKE_BUILD_TYPE=Release -DSD_CUDA=ON -DCMAKE_CUDA_ARCHITECTURES=61 -DGGML_NATIVE=OFF -DGGML_BACKEND_DL=ON
cmake --build <ROOT>/build
```
For RTX 50 series (Blackwell, compute capability 12.x) there are three ways, none measured by us on an RTX 50 card [not tried]: (1) our release engine with the v0.1.1 script at 56 frames (already installed by `kur.ps1`, runs our quality gates; try this first); if the video is black: (2) the stock stable-diffusion.cpp release `master-1106-532d2c1` (Windows CUDA 12 build; its build file lists `CMAKE_CUDA_ARCHITECTURES='61;70;75;80;86;89;90;100;120'` [read: build.yml at that tag]); it has none of our memory patches, our quality gates were not run on it, and the MiniMax H3 license acceptance (`docs/LISANS_KABUL.txt`) still applies (the acceptance step of `kur.ps1` does not run with it); (3) a native build with `-DCMAKE_CUDA_ARCHITECTURES=120` and CUDA 12.8.1 or newer, if the video is black [user-reported, not measured by us]. Step-by-step recipe: `docs/RTX5060_SM120_DERLEME.md`; test report: `docs/RTX5060_TEST_RAPORU.md`.

Apply `patches/` onto the pinned stable-diffusion.cpp commit first. Put the CUDA runtime DLLs (cudart, cublas) on PATH, otherwise `sd-cli` exits with STATUS_DLL_NOT_FOUND. Before publishing a binary, scan it for personal paths (UTF-8 and UTF-16): the count must be 0.

TR: RTX 50 serisi (compute capability 12.x) için üç yol var, hiçbirini RTX 50 kartta biz ölçmedik [denenmedi]: (1) bizim sürüm motoru v0.1.1 betiğiyle 56 karede (`kur.ps1` zaten kurar, kalite kapılarımız koşar; önce bunu deneyin); video siyahsa: (2) hazır stable-diffusion.cpp sürümü `master-1106-532d2c1` (Windows CUDA 12 derlemesi; derleme dosyasında `CMAKE_CUDA_ARCHITECTURES='61;70;75;80;86;89;90;100;120'` yazar [okudum: o etikette build.yml]); bizim bellek yamalarımız yok, kalite kapılarımız onda koşturulmadı, MiniMax H3 lisans kabulü (`docs/LISANS_KABUL.txt`) yine geçerli (`kur.ps1` kabul adımı onunla çalışmaz); (3) video siyahsa `-DCMAKE_CUDA_ARCHITECTURES=120` ve CUDA 12.8.1+ ile yerel derleme [kullanıcı bildirdi, biz ölçmedik]. Tarif: `docs/RTX5060_SM120_DERLEME.md`.

TR: VS 2022 Build Tools + CMake/Ninja + CUDA 12.8; nötr kısa kökte derle; yamaları sabit commit'e uygula; cudart/cublas DLL'leri PATH'e; yayından önce ikiliyi kişisel yol için tara (UTF-8 + UTF-16 sıfır olmalı).

## 3. Models (not included)
HyperFlow-H3-Flash DiT (Q4_K_M), Qwen3-VL-32B text encoder (Q4_K_M), Sol video VAE (fp16), audio VAE (fp32). Download from the official pages with a pinned commit and verify sha256. The model license is the MiniMax H3 Community License (see README).


Model files (pinned commits, sizes and sha256 are in `scripts/modeller.json`; total 29.31 GiB). A newly downloaded model file is sha256-verified before it counts as done; a model file that already exists with the right size is skipped after a size check only, so run `modelleri_indir.ps1 -Dogrula` (or link with `-ModelKlasoru`, which hashes) for a full sha256 check [read: scripts/modelleri_indir.ps1]. Two separate ways:
- (a) Target folder `<MODEL_DIR>`: `kur.ps1` with env `VT_MODEL_DIR` (default `<ROOT>\model`), or `scripts/modelleri_indir.ps1 -Hedef <dir>` directly. Default `-Kuru` = report only; `-Dogrula` = size+sha256 check; `-Baslat -LisansKabul E|Y` = download. Pinned-commit HTTPS only, `.part` + Range resume, size+sha256 verified before the file is put in place; a corrupt `.part` is deleted with a warning and restarts from zero. A `DUR` file stops it cleanly.
- (b) Link an existing folder: `kur.ps1 -ModelKlasoru <existing_folder>`. For each of the four files in `modeller.json` the file there is hashed (sha256; reads up to ~29 GB, minutes on an HDD); if it matches, it is hard-linked (same drive) or copied into `<MODEL_DIR>` and NOT downloaded. A missing or non-matching file prints a warning and is downloaded normally. The existing folder is only read, never modified. [not tried: not yet run with the real model files]
- Disk: at least 32 GiB free on the model drive (29.31 GiB of files). Time: the 605 MB audio VAE took 66 s including sha256 (~9 MB/s here) [measured, small file only]; the full 29.31 GiB is roughly 55 min at that rate [tahmin], it depends on your line speed.
- License: the script shows `docs/LISANS_KABUL.txt` and does not download until you pass `-LisansKabul E` (TR) or `Y` (EN); the acceptance is stored next to the models.
TR: (a) Hedef klasor: `VT_MODEL_DIR` (varsayilan `<ROOT>\model`) ya da `modelleri_indir.ps1 -Hedef <klasor>`; indirme + sha256 dogrulama. (b) Var olan klasoru bagla: `kur.ps1 -ModelKlasoru <klasor>`; dort dosyanin sha256'si eslesirse hardlink (ayni surucu) ya da kopya ile baglanir, indirilmez; eslesmeyen uyari verip normal iner; kaynak klasore dokunulmaz. Modeller sha256 ile dogrulanmadan HAZIR denmez. Disk en az 32 GiB bos (29,31 GiB dosya); sure: 605 MB ses VAE 66 sn olculdu, tam indirme ~55 dk [tahmin], hat hizina bagli.
## 4. Run recipe
Full command (exact flags, as used by `scripts/hiz_kos3.ps1`; run `scripts/hiz_kos3.ps1 -Kuru` to print the exact command line without running it):
```powershell
sd-cli -M vid_gen `
  --diffusion-model <MODEL_DIR>/minimax_h3_fl2va_hyperflow_flash_14b-Q4_K_M.gguf `
  --llm <MODEL_DIR>/qwen3vl_32b_minimax_h3-Q4_K_M.gguf `
  --vae <MODEL_DIR>/minimax_h3_sol_vae_fp16.safetensors `
  --audio-vae <MODEL_DIR>/minimax_h3_audio_vae_fp32.safetensors `
  --prompt-file <prompt.txt> -W 640 -H 384 --video-frames <N> --fps 24 `
  --steps 6 --sampling-method euler --sigmas hyperflow-h3-flash-6 --cfg-scale 1.0 `
  --rng cpu --seed 42 -t 4 --flash-attn 'off,diffusion=on' `
  --model-args minimax_h3_attn_chunk_budget=0.05 `
  --offload-to-cpu --mmap --backend te=cpu `
  --log-level debug -o <out>.avi
```
For the later parts of a long video add `--init-img <real last frame of the previous part>` before `--log-level`. `<N>` follows 17k+5: 39, 56, 73, 90, 107, 124, 141, 158, 175, 192, 209. Use NO `--vae-tiling` and NO `--temporal-tiling` (the non-tiled VAE is the quality reference; `hiz_kos3.ps1` always runs with the non-tiled VAE: `--vae-tiling` and `--temporal-tiling` are not added). `<out>.avi` is the output file (`-o`).
Measured: 56 frames about 560-590 s, 175 frames about 2300 s per pass; VRAM peak about 3.8-3.9 GB; RAM peak about 11.5 GB (close other applications).

TR: aynı komut; `hiz_kos3.ps1` her zaman karosuz VAE ile koşar (`--vae-tiling` ve `--temporal-tiling` eklenmez); karosuz VAE kalite referansıdır; sonraki parçalarda `--init-img` önceki parçanın GERÇEK son karesi. Ölçülen: 56 kare ~560-590 sn, 175 kare ~2300 sn; VRAM tepe ~3,8-3,9 GB; RAM tepe ~11,5 GB.

## 5. Checks and common mistakes
Quality gates are in the README. Common mistakes: (1) init image taken from the wrong frame (we once used frame 205 of 209 and the seam SSIM dropped to 0.66), (2) trusting the raw noise gate on dense textures (use the texture-normalised or sigma-HH gates), (3) missing DLLs on PATH, (4) running two GPU jobs at once (use a single GPU lock), (5) RAM pressure: with less than 16 GB RAM the model reads may fall into the page file. (6) exit 6 `KAPI CALISMADI`: Python without `opencv-python`/`numpy` (the gate did not run; it is not a RED). (7) all-black video at 141+ frames on newer cards (compute capability 7.0+): `uret.ps1` sets `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` there (`docs/SIK_HATALAR.md` 19); `hiz_kos3.ps1` (this research runner) applies the same rule since v0.1.1 (only if every card is 7.0+; a value you set yourself is kept).

TR: sık hatalar: yanlış kareden başlangıç görseli, dokulu sahnede ham gürültü kapısına güvenmek, DLL eksikliği, aynı anda iki GPU işi, RAM baskısı, opencv'siz python (çıkış 6, RED değil), yeni kartta (7.0+) 141 kare ve üstünde siyah video (f32 otomatik).

## 6. Privacy
No personal paths, user names, e-mail addresses or chat IDs in this repo; docs use `<ROOT>` and `<MODEL_DIR>`. No model weights or generated videos are included.

## 7. Linux (experimental)
EN: Linux scripts came in PR #8 (contributor @xmtaha). Status: experimental; the maintainers have not run a GPU job on Linux. Only evidence: [user-reported, PR #8] 56 frames on an RTX 4060 Ti 8 GB; 141 and 209 frames were not measured on Linux [not tried]. The Windows engine choice (`scripts/kart_tablosu.json`, the stock engine) is not used on Linux: you build the engine yourself.
- **Needs:** an NVIDIA driver (`nvidia-smi` works, 4 GB VRAM or more, compute capability 6.1 or higher), the CUDA Toolkit (`nvcc`), `git`, `cmake`, `python3`; at least 32 GiB free on the model drive (models about 29.3 GiB) and room for the source and build under the root [guess: about 10 GiB more on the root drive].
- **Dry run first (changes nothing):** `./kur.sh --kuru`. It writes, downloads and builds nothing and reports readiness through its exit code (0 ready, 3 hardware or disk not enough, 2 license needed).
- **Install:** `./kur.sh` (`--lisans-kabul E` only if you have read and accepted the model license yourself; `--dogrula` runs the full sha256 check of existing models; `--kontrol-atla` skips the 5-frame check and then never prints READY). Order: GPU, disk (model drive), license, Python environment (`.venv` and `.onbellek/pip` under the root, `--only-binary`), engine (a clone of stable-diffusion.cpp at a pinned commit and a build with our patches, which are checked against `patches/SHA256SUMS`; it needs a long time [not measured]), models (sha256), a real 5-frame check, READY only if the check passed.
- **Run:** `./uret.sh --istem docs/ornek_istem_R0.txt --kare 56` (options: `--kare 56|141|209`, `-W`, `-H`, `--init-img`, `--end-img`, `--tek-asama`, `--tavan-dk N`, `--kuru`). Same rules as `uret.ps1` (token formula, frame counts 17k+5 up to 209, 640x384 by default, two-stage threshold, `f32` from compute capability 7.0, quality gate thresholds, non-tiled VAE); `--kuru` prints the plan and writes nothing. Stop with a `DUR` file in the root. Exit codes: 0 done, 1 error, 2 usage error or stop file, 5 quality gate RED, 6 gate could not run.
- **Layout and removal:** everything is under the root (`.venv`, `.onbellek/pip`, `engine/src`, `engine/build`, `engine/bin`, `model/`, `runs/`); removal is deleting the root. See the README, "Disk layout and removal".

TR: Linux betikleri PR #8 ile geldi (katkıcı @xmtaha). Durum: deneysel; bakımcılar Linux'ta GPU koşusu yapmadı. Tek kanıt: [user-reported, PR #8] RTX 4060 Ti 8 GB'ta 56 kare; 141 ve 209 kare Linux'ta ölçülmedi [not tried]. Windows'taki motor seçimi (`scripts/kart_tablosu.json`, stock motor) Linux'ta kullanılmaz: motoru kendiniz derlersiniz.
- **Gerekenler:** NVIDIA sürücüsü (`nvidia-smi` çalışmalı, 4 GB ya da üstü VRAM, compute capability 6.1 ya da üstü), CUDA Toolkit (`nvcc`), `git`, `cmake`, `python3`; model sürücüsünde en az 32 GiB boş (modeller yaklaşık 29,3 GiB) ve kök altında kaynak ile derleme için yer [tahmin: kök sürücüsünde yaklaşık 10 GiB daha].
- **Önce kuru çalıştırın (hiçbir şey değiştirmez):** `./kur.sh --kuru`. Yazmaz, indirmez, derlemez; hazırlık durumunu çıkış koduyla bildirir (0 hazır, 3 donanım ya da disk yetmiyor, 2 lisans gerekli).
- **Kurulum:** `./kur.sh` (`--lisans-kabul E` yalnız model lisansını okuyup kabul ettiyseniz; `--dogrula` var olan modellerin tam sha256 denetimini yapar; `--kontrol-atla` 5 karelik kontrolü atlar ve sonra asla HAZIR yazmaz). Sıra: GPU, disk (model sürücüsü), lisans, Python ortamı (kök altında `.venv` ve `.onbellek/pip`, `--only-binary`), motor (stable-diffusion.cpp'nin sabit commit'te klonu ve yamalarımızla derleme; yamalar `patches/SHA256SUMS` ile doğrulanır; uzun sürer [ölçülmedi]), modeller (sha256), gerçek 5 karelik kontrol, kontrol geçerse HAZIR.
- **Çalıştırma:** `./uret.sh --istem docs/ornek_istem_R0.txt --kare 56` (seçenekler: `--kare 56|141|209`, `-W`, `-H`, `--init-img`, `--end-img`, `--tek-asama`, `--tavan-dk N`, `--kuru`). `uret.ps1` ile aynı kurallar (jeton formülü, kare sayısı 17k+5 en fazla 209, varsayılan 640x384, iki aşama eşiği, compute capability 7.0'dan `f32`, kalite kapısı eşikleri, karosuz VAE); `--kuru` planı yazar, hiçbir şey yazmaz. Kökte `DUR` dosyasıyla durdurulur. Çıkış kodları: 0 tamam, 1 hata, 2 kullanım hatası ya da durdurma dosyası, 5 kalite kapısı RED, 6 kapı çalışamadı.
- **Düzen ve kaldırma:** her şey kök altındadır (`.venv`, `.onbellek/pip`, `engine/src`, `engine/build`, `engine/bin`, `model/`, `runs/`); kaldırma kökü silmektir. README, "Disk layout and removal".
