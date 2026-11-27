# AMD Radeon PRO W7900D 48 GB on Linux with ROCm

Community report, one machine. [measured] unless marked otherwise. Quality settings are the fixed ones
(6 steps, cfg 1, 640x384, non-tiled VAE, seed 42); nothing here changes them.

**Card:** AMD Radeon PRO W7900D, 48 GB (51,522,830,336 B), `gfx1100` (RDNA 3), no CUDA. [measured: `rocm-smi --showmeminfo vram`]
**Stack:** ROCm 7.2.4, HIP 7.2, container image `radeon-cloud-global/rc/base` (Ubuntu, Python 3.12), 16 cores and
55 GB RAM as the instance quota (the node itself reports 128 cores), 98 GB `/workspace`. [measured: `nproc`, `free -g`]
`cmake` is not in the image; `pip install cmake ninja` works and builds fine. [measured]

## Build

Stock tree (no patches), the configuration used for most of the numbers below:

```bash
cmake -B build -DSD_HIPBLAS=ON -DCMAKE_BUILD_TYPE=Release -DAMDGPU_TARGETS=gfx1100
cmake --build build -j 16        # about 6 minutes, 0 errors
```

`patches/` (all 24 sdcpp patches) also applies and builds, with two extra steps:

```bash
# the series carries a `diff --git a/ggml b/ggml` submodule hunk; skip it
git apply -3 --exclude=ggml patches/sdcpp/<NN-name>.patch   # applied in SERIES.txt order
# 01-taban-hiz-yamalari uses cudaEventCreate/cudaEventElapsedTime, which the HIP vendor header lacks:
#   ggml/src/ggml-cuda/vendors/hip.h
#define cudaEventCreate hipEventCreate
#define cudaEventElapsedTime hipEventElapsedTime
```

After those two lines the patched tree compiles with zero errors. [measured] The black-video result below is
identical on both trees, so it is not caused by the patches.

## Command line

```bash
sd-cli -M vid_gen \
  --diffusion-model <MODEL_DIR>/minimax_h3_fl2va_hyperflow_flash_14b-Q4_K_M.gguf \
  --llm <MODEL_DIR>/qwen3vl_32b_minimax_h3-Q4_K_M.gguf \
  --vae <MODEL_DIR>/minimax_h3_sol_vae_fp16.safetensors \
  --audio-vae <MODEL_DIR>/minimax_h3_audio_vae_fp32.safetensors \
  --prompt-file prompt.txt -W 640 -H 384 --video-frames <N> --fps 24 \
  --steps 6 --sampling-method euler --sigmas hyperflow-h3-flash-6 --cfg-scale 1.0 \
  --rng cpu --seed 42 -t 8 --flash-attn off -o out.avi
```

With 48 GB, `--offload-to-cpu`, `--mmap` and `--backend te=cpu` are not needed up to about 89 frames; the
weights and the text encoder stay on the card. [measured] The `AMD_ROCM.md` Windows recipe (budget 0.03,
offload, `te=cpu`) runs on this card too and gives the same output, only slower.

## Runs

| Frames | Video | `generate_video` | VRAM peak | Output |
|---|---|---|---|---|
| 33 | 1.4 s | 41 s (52 s wall, model load included) | 15 GB | correct, kitten surfing |
| 65 | 2.7 s | about 40 s | 15 GB | correct |
| 89 | 3.7 s | about 70 s | 15 GB | correct |
| 121 | 5.0 s | - | 37 GB (no offload) | **black** |
| 193 | 8.0 s | 278 s | 38 GB (budget 0.05, no offload) | **black** |
| 209 | 8.7 s | 242 s (patched, offload, budget 0.03) | 15 GB | **black** |
| 209 | 8.7 s | 220 s (stock, offload, `te=cpu`) | - | **black** |
| 480 | 20.0 s | 888 s (budget 0.3, offload) | 22 GB | **black** |

Every "black" file is a full-length, correctly muxed AVI with audio; only the picture is uniformly black.
The same seed and prompt at 89 frames is fine, so it is a threshold, not a random failure. It is **not VRAM**
(the peaks above are far below 48 GB) and it is the same with and without `patches/`.

## Image-to-video

`--init-img <png>` (65 frames, same settings) exits with **139 (SIGSEGV)**, no output file. [measured, twice:
one run in the foreground, one under `setsid`] Not investigated further here.

## Workaround used for a 20 s clip

Generate 89-frame segments (different seeds) and concatenate them with ffmpeg:

```bash
ffmpeg -f concat -safe 0 -i liste.txt -t 20 -c:v libx264 -preset veryfast -crf 20 -c:a aac out.mp4
```

Six segments = 20.0 s, about 8 minutes of generation plus a few seconds of concatenation. [measured] The joins
are cuts, not continuous motion: every segment is a new take.

## What is still open

- Where exactly the black output starts (between 89 and 121 frames) and whether a different attention/chunk
  setting avoids it.
- Whether the Vulkan build behaves the same on this card. [guess] This report is the ROCm path only.
- `--flash-attn diffusion=on` was not tried; every run above used `--flash-attn off`.

## Türkçe özet

Radeon PRO W7900D 48 GB (gfx1100, ROCm 7.2.4, Linux) üzerinde VideoTurko çalışıyor: stok sd.cpp
`-DSD_HIPBLAS=ON -DAMDGPU_TARGETS=gfx1100` ile derlenir, yamalar da uygulanır (iki HIP makrosu eklenerek),
modeller 31,5 GB. **89 kareye kadar çıktı doğru** (33 kare 52 sn, 89 kare ~70 sn, VRAM ~15 GB); **121 kare ve
üstü simsiyah** çıkıyor — VRAM yetersizliği değil, yamasız derlemede de aynı. `--init-img` (görselden devam)
segfault veriyor. 20 saniyelik klip, 89 karelik parçalar üretilip ffmpeg ile birleştirilerek ~8 dakikada alındı.
