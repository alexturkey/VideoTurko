# RTX 5060 (`sm_120`) Derleme Tarifi / Build Recipe (TR + EN)

> **TR:** Bu belge, VideoTurko motorunu (`sd-cli`) NVIDIA Blackwell (`sm_120`, örn. RTX 5060 Laptop 8 GB) için yerel CUDA koduyla kaynaktan derleme adımlarını ve `scripts/uret.ps1` içindeki deneysel `VT_*` anahtarlarını açıklar.
>
> **EN:** This document describes how to build the VideoTurko engine (`sd-cli`) from source with native CUDA `sm_120` kernels for NVIDIA Blackwell GPUs (e.g., RTX 5060 Laptop 8 GB), and documents the experimental `VT_*` switches in `scripts/uret.ps1`.

> **TR (not):** Bu derleme tarifi son yoldur (sıra: bizim sürüm motoru 56 karede, sonra hazır sürüm, sonra bu tarif; `docs/KURULUM.md`). Hazır stable-diffusion.cpp sürümünü denemek mümkün: `master-1106-532d2c1` Windows CUDA 12 derlemesinin derleme dosyasında `CMAKE_CUDA_ARCHITECTURES='61;70;75;80;86;89;90;100;120'` yazar [okudum: o etikette build.yml]. RTX 50 kartta denenmedi [denenmedi]; bizim bellek yamalarımız yok, kalite kapılarımız onda koşturulmadı; MiniMax H3 lisans kabulü (`docs/LISANS_KABUL.txt`) yine geçerli.
>
> **EN (note):** This build recipe is the last way (order: our release engine at 56 frames, then the stock release, then this recipe; `docs/KURULUM.md`). You can try the stock stable-diffusion.cpp release: the build file of the `master-1106-532d2c1` Windows CUDA 12 build lists `CMAKE_CUDA_ARCHITECTURES='61;70;75;80;86;89;90;100;120'` [read: build.yml at that tag]. Not tried on an RTX 50 card [not tried]; it has none of our memory patches, our quality gates were not run on it; the MiniMax H3 license acceptance (`docs/LISANS_KABUL.txt`) still applies.

Yer tutucular / Placeholders: `<ROOT>` = kısa, nötr çalışma klasörü (örn. `C:\vt`), `<BUILD>` = nötr derleme klasörü (örn. `C:\vt\build_work`). Betiklere veya derleme yollarına kişisel kullanıcı klasörü koymayın (`__FILE__` makroları kaynak yolunu ikiliye gömebilir).

---

## 1. Gereksinimler / Prerequisites

| Bileşen / Component | Sürüm / Version | Not / Note |
|---|---|---|
| OS | Windows 10 / 11 (x64) | 64-bit |
| Visual Studio Build Tools | VS 2022 (`x64` C++ toolset) | `vcvars64.bat` ile ortam başlatılır |
| CMake + Ninja | CMake 3.24+, Ninja | `-G Ninja` ile paralel derleme |
| NVIDIA CUDA Toolkit | **12.8.1+** (ücretsiz / free) | Blackwell `sm_120` desteği için 12.8+ zorunludur |
| Git | 2.40+ | `git am` / `git apply` için |

---

## 2. Kaynak Kodu Hazırlama ve Yamalar / Source & Patches

1. `stable-diffusion.cpp` deposunu sabit commit'te klonlayın (`patches/SERIES.txt` ile aynı taban):
   - `stable-diffusion.cpp`: `32d516c` (`master-1088`)
   - Alt modül `ggml`: `d803c238`

```powershell
mkdir <BUILD>
cd <BUILD>
git clone https://github.com/leejet/stable-diffusion.cpp.git src
cd src
git checkout 32d516c
git submodule update --init --recursive
```

2. `patches/SERIES.txt` sırasıyla **24 yamayı** uygulayın (önce 3 `ggml` yaması, sonra 21 `sdcpp` yaması):

```powershell
# 1) ggml alt modulu (3 yama)
Push-Location <BUILD>\src\ggml
foreach ($p in @(
    "01-ggml-taban.patch",
    "02-p0005-optime-file.patch",
    "03-p0005-optime-fix.patch"
)) {
    git apply "<ROOT>\patches\ggml\$p"
}
Pop-Location

# 2) stable-diffusion.cpp (21 yama)
Push-Location <BUILD>\src
Get-Content "<ROOT>\patches\SERIES.txt" |
    Where-Object { $_ -match '^sdcpp/' } |
    ForEach-Object { git apply "<ROOT>\patches\$_" }
Pop-Location
```

---

## 3. CMake + Ninja ile `sm_120` Derlemesi / Native `sm_120` Build

VS 2022 **x64 Native Tools Command Prompt** içinde (veya `vcvars64.bat` çağrısı sonrası) çalıştırın:

```powershell
cmake -S <BUILD>\src -B <BUILD>\build -G Ninja `
  -DCMAKE_BUILD_TYPE=Release `
  -DSD_CUDA=ON `
  -DCMAKE_CUDA_ARCHITECTURES=120 `
  -DGGML_NATIVE=OFF `
  -DGGML_BACKEND_DL=ON

cmake --build <BUILD>\build --target sd-cli
```

> `-DGGML_BACKEND_DL=ON` ile CUDA arka ucu ayrı bir DLL (`ggml-cuda.dll`) olarak derlenir. `build\bin` içinde `ggml-cuda.dll` yoksa hedefsiz derleyin: `cmake --build <BUILD>\build` [tahmin: CMake hedef bağımlılığı denenmedi]. / With `-DGGML_BACKEND_DL=ON` the CUDA backend is a separate DLL; if `ggml-cuda.dll` is missing in `build\bin`, build without `--target` [guess: not tested].

### Çıktıların Yerleştirilmesi / Installing Binaries

Mevcut `engine\bin\` klasörüne dokunmadan yeni derlemeyi `engine\bin_sm120\` altına kopyalayın:

```powershell
New-Item -ItemType Directory -Force "<ROOT>\engine\bin_sm120" | Out-Null
Copy-Item "<BUILD>\build\bin\sd-cli.exe" "<ROOT>\engine\bin_sm120\"
Copy-Item "<BUILD>\build\bin\*.dll" "<ROOT>\engine\bin_sm120\"

# CUDA 12.8 calisma zamani DLL'leri (sistem PATH'inde degilse)
$cudaBin = "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.8\bin"
foreach ($dll in @("cudart64_12.dll", "cublas64_12.dll", "cublasLt64_12.dll")) {
    Copy-Item (Join-Path $cudaBin $dll) "<ROOT>\engine\bin_sm120\"
}
```

### `sm_120` Fatbin Doğrulaması / Verify Native `sm_120` Code

```powershell
& "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.8\bin\cuobjdump.exe" --list-elf "<ROOT>\engine\bin_sm120\ggml-cuda.dll" | Select-String "sm_120"
```

Çıktıda `sm_120` ELF girişleri görünmelidir. (Eski `engine\bin\ggml-cuda.dll` yalnızca `sm_61` ELF ve `compute_61` PTX içerir.)

> **Gizlilik notu / Privacy note:** Derlenmiş ikiliyi paylaşmadan önce kişisel yol içerip içermediğini UTF-8 ve UTF-16 olarak tarayın (sayım 0 olmalı). Bu depo derlenmiş ikili dağıtmaz.

---

## 4. Çalıştırma / Running with `bin_sm120`

```powershell
$env:VT_ENGINE_BIN = "<ROOT>\engine\bin_sm120"
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
```

---

## 5. `scripts/uret.ps1` Deneysel `VT_*` Anahtarları / Experimental `VT_*` Switches

Aşağıdaki ortam değişkenleri yalnızca teşhis ve deney amaçlıdır; **varsayılan olarak kapalıdır**. Hiçbiri ayarlanmadığında `scripts/uret.ps1` upstream varsayılan davranışını birebir korur.

| Değişken / Variable | Varsayılan / Default | Açıklama (TR) | Description (EN) |
|---|---|---|---|
| `VT_ATTN_BUDGET` | `0.05` | `minimax_h3_attn_chunk_budget` değerini ezer (0..1 sayı; geçersizse yok sayılır) | Overrides `minimax_h3_attn_chunk_budget` (number 0..1; invalid values are ignored) |
| `VT_IKI_ASAMA` | kapalı / off | `1` ise 108 kare altında da iki aşamalı (DiT + ayrı VAE) koşuyu zorlar (`-TekAsama` verilmedikçe) | When `1`, forces two-stage (DiT + separate VAE) even below 108 frames (unless `-TekAsama`) |
| `VT_NO_FA` | kapalı / off | `1` ise `--flash-attn off` geçirir (varsayılan: `--flash-attn off,diffusion=on`) | When `1`, passes `--flash-attn off` instead of default `--flash-attn off,diffusion=on` |
| `VT_MAX_VRAM` | boş / unset | `--max-vram <değer>` ekler (0 < sayı <= 1024) | Appends `--max-vram <value>` (0 < number <= 1024) |
| `VT_CHUNK_MB` | `64` | İki aşamalı modda `SD_QKV_CHUNK_MB` ve `SD_MLP_CHUNK_MB` boyutunu (MB, 1..4096) ayarlar | Sets `SD_QKV_CHUNK_MB` and `SD_MLP_CHUNK_MB` (in MB) in two-stage mode |
| `VT_MARGIN_MB` | `1` | **Yalnızca Linux `scripts/uret.sh`** (`uret.ps1`'de karşılığı yok): iki aşamalı koşuda 1. aşamanın `SD_VRAM_MARGIN_MB` payını (MB, 1..4096; `0` reddedilir) ayarlar; tek aşamalı koşuda etkisizdir; 2. aşama hep 256 [kullanıcı bildirdi, PR #31] | **Linux `scripts/uret.sh` only** (no counterpart in `uret.ps1`): sets stage 1's `SD_VRAM_MARGIN_MB` margin (MB, 1..4096; `0` is rejected) in a two-stage run; no effect in a single-stage run; stage 2 always stays 256 [user-reported, PR #31] |

> **Uyarı / Warning (TR):** Bu anahtarlar çıktıyı `AGENTS.md` "Hard rules" dışına çıkarabilir ve kalite kapısı bunu yakalamaz. Aktifken `uret.ps1` UYARI yazar ve `runs\olaylar.txt`'ye kaydeder. Model/nicemleme değiştiren anahtar (alternatif DiT, `--tensor-type-rules`) bilerek yoktur; bunun için `sd-cli`'yi elle çalıştırın ve çıktıyı ölçüm olarak sunmayın.
>
> **Warning (EN):** These switches can take the output outside the `AGENTS.md` "Hard rules" and the quality gate will not catch it. When active, `uret.ps1` prints a WARNING and records it in `runs\olaylar.txt`. There is deliberately no switch that changes the model or quantization (alternative DiT, `--tensor-type-rules`); run `sd-cli` by hand for that and do not present the result as a measurement.
>
> **Doğrulama / Verification:** `powershell -NoProfile -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 209 -Kuru` komutu, hiçbir `VT_*` değişkeni ayarlı değilken upstream komut satırını ve ortam değişkenlerini değiştirmeden üretir.
