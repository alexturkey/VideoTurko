# VideoTurko

English · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

Translations follow this English README. If a translation differs or lags behind, the English text is authoritative, especially for the license and security text ([`SECURITY.md`](SECURITY.md) and [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) are kept in English and Turkish only).

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **Before you start (license, territory):** this repository is MIT and contains only patches and scripts. The MiniMax H3 model it downloads is under the MiniMax H3 Community License: its territory excludes the European Union, the United Kingdom, South Korea and the United States, and the model, derivatives **and outputs (the videos you generate)** must not be used, distributed or displayed there (V.4). Commercial use is allowed within the license terms. Read [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) before installing; this is not legal advice.

> **In 30 seconds:** a 4 GB graphics card can make a 209-frame (8.7 s) MiniMax H3 video in a single pass: verified on one machine (GTX 1050 Ti 4 GB; full `kur.ps1` install on an empty folder not yet verified end to end) [measured: 209 frames with the release binary through `uret.ps1`, run U209; latent byte-identical to the development-build run; frames and audio identical in the video, the file sha differs because of the container; evidence kept by the authors, not in this repo]; with `-InitImg` (image-to-video) at most 192 frames (8.0 s) [measured: run B192]; 209 frames take about 57 min, default time cap 80 min [measured: run U209]; the 3 steps below are how to run it.

> **Using an AI coding agent (Codex, Claude Code, Gemini, Cursor)?** Give it this one sentence: "Read `AGENTS_HIZLI.md` to the end, run `scripts\tani.ps1` first, keep your progress in `DURUM.md`, and ask me before you delete or move anything, change system Python or PATH, lower a quality setting, or accept the model license for me." The agent will diagnose this PC, write a checklist and ask you at every decision; the model license stays your decision.

VideoTurko: stable-diffusion.cpp memory patches and recipes to run MiniMax H3 text-to-video on a 4 GB GTX 1050 Ti, up to 209 frames (8.7 s) in a single pass; image-to-video (`-InitImg`) up to 192 frames (8.0 s) (209 frames verified by a byte chain; byte-identical to the unpatched run on the 56- and 141-frame checks).

## Quick start (Windows, 3 steps)
**Status: the install/run scripts below are being finished and the clean-root test is pending; nothing here is claimed to work until that test passes (see "Status and limits").**

1. **Download** this repository (green **Code** button, then **Download ZIP**) and extract it to a SHORT folder, for example `C:\vt`.
2. **Install: double-click `kur.cmd`** (a black window opens and shows each step; closing it stops the install, and running it again continues: a half-downloaded model file is resumed [read: the download script keeps a `.part` file and continues it; a full 29 GiB resume was not measured]). If Windows warns about the downloaded file, use the PowerShell command below instead [advice, not tested on a downloaded ZIP]. Prefer the command line? Open PowerShell in that folder (type `powershell` in the Explorer address bar) and run the same install:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   The install root is the folder you extracted (engine goes to `engine\bin`, models to `model`); to use another place set the environment variable `VT_ROOT` first. It checks GPU, driver, RAM and disk, fetches the engine and the models (engine zips and newly downloaded model files are sha256-checked; a model file already present with the right size is only size-checked, `scripts\modelleri_indir.ps1 -Dogrula` runs the full sha256 check), runs a short real check, and prints READY only if that check passed [design: `kur.ps1` has not been run in full in a clean folder; this sentence is updated after the clean-folder test]. `-ExecutionPolicy Bypass` applies to this one process only; read `scripts\kur.ps1` first, as with any installer.
   The engine zip comes from the GitHub release v0.1.0 (published 2026-11-19; its sha256 is pinned in `kur.ps1`). Offline or with your own build, give local zips: `-MotorZip <path> -CudaZip <path>`. A local zip is checked against the same pinned sha256 (a `.sha256` file beside it is ignored), so it must be the release zip; for your own build set `VT_MOTOR_SHA256` / `VT_CUDA_SHA256` to its sha256 first. A wrong sha256 stops with exit 1. Only `.exe`/`.dll` go to `engine\bin`; licenses and README go to `engine\lisanslar\<zip name>\`. [tried with the dist zips before the release: the sidecar `.sha256` plus the self-referential warning, binary and DLLs placed, `sd-cli --help` ran; the installed binary shas matched (`c5cebe78...`, `e5d3d329...`); the model step and the 5-frame check of `kur.ps1` have NOT been run on a real GPU yet]
   **Model license:** before the model step the installer prints the license summary (`docs/LISANS_KABUL.txt`, full text `docs/LISANS_UYARISI.md`: MiniMax H3 Community License, territory limits that also cover generated videos, commercial and AI-label rules) and asks you to accept (`E` = yes). Read it first. For unattended runs you can pass `-LisansKabul E`, which means you have read and accepted it yourself; do not add it for someone else. (AI agents: follow `AGENTS.md`; never type E without the user's consent.) Without acceptance `kur.ps1` stops with exit code 2 and downloads no model.
3. **Your first video (56 frames, about 11 min on our GTX 1050 Ti** [measured: 641 s, run R0, `docs/OLCUMLER.md`; other cards not measured]**)**: when the installer prints `HAZIR / READY`, run
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (shortcut: drag a prompt text file onto `uret.cmd`, or run `uret.cmd docs\ornek_istem_R0.txt`: the same 56-frame run). The video is in `runs\`. Then put your own prompt in a text file (one English paragraph, optional `audio:` sentence) and run the longest clip we cover (default, about 57 min [measured: run U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   `-Kare` follows the 17k+5 grid (39, 56, 73, ... 192, 209); default 209 (8.7 s), the longest length we cover. The VAE runs in a separate process, never tiled [a real engine run through `uret.ps1` with the release binary, separate-process VAE, passed in run U209].

   Prompt writing guide: [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (one-continuous-shot pattern, equal time slices, two full examples).

| Requirement | Value |
|---|---|
| OS | Windows 10/11, 64-bit |
| GPU | NVIDIA, 4 GB or more; tested only on GTX 1050 Ti (sm_61); thin margin (3777/4096 MiB at 209 frames): a busy screen or browser can break the run; no other 4 GB card tried |
| RAM | 16 GB (peak about 11 GB; close other programs) |
| Disk | 32 GiB or more free (40 GiB or more recommended: between 32 and 40 the installer prints a warning, `[VT-W-DISK-PAY]` [measured: fake-disk `-Kuru` runs]), models on an SSD (NVMe preferred) |
| Download | engine zip 36.8 MB + CUDA runtime zip 567.5 MB [measured] + models 31,473,112,040 bytes (about 29.3 GiB) [read: sizes in `scripts/modeller.json`]; about 30 GiB in total |
| Models | not included; fetched by the installer under the MiniMax license (see warning below). The models (29.3 GiB, 31,473,112,040 bytes in `scripts/modeller.json`) are not in this repository or release: GitHub file/release size limits apply, and `kur.ps1` downloads them from the official source with sha256 verification. |

`kur.ps1` exit codes: 0 READY, 1 error, 2 user input needed (license, or no release/zip yet), 3 hardware or disk insufficient, 4 stopped (DUR file). `uret.ps1` accepts a run only if the `.avi` exists, the frame count is right and the logs are clean [measured: one real run through `uret.ps1` on the release binary, run U209, 209 frames, gate passed]. `uret.ps1` exit codes: 0 DONE (quality gate passed), 1 error or invalid output (including a video without an audio stream), 2 stopped (DUR file), 5 `KAPI RED` (quality gate failed: clip not accepted, the decision is yours), 6 gate could not run (clip not accepted). Details in AGENTS.md. [measured: exit codes 0, 1 (silent video), 5 and 6 in scenarios with a fake engine and a fake gate; real engine: exit 0 in run U209]

### Troubleshooting (details: `docs/SIK_HATALAR.md`)
Error lines from our scripts carry a stable code, for example `HATA: [VT-E-DLL] ...` or `UYARI: [VT-W-DISK-PAY] ...`. Look the code up in [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) (anchor example `#vt-e-dll`) or in `docs/hata_imzalari.json`, and put the code in your issue. The first column of the table below stays as printed (do not translate codes or log text).

| You see | What it means, what to do |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | Do not start `sd-cli.exe` by hand; run `scripts\kur.ps1`, which puts the CUDA DLLs in place. |
| `failed during weight preparation` at `blocks.0` (#1, #3, #5) | Not enough VRAM at the memory gate: use a smaller frame count on the 17k+5 grid, close other GPU programs, keep the shipped flags. |
| `retrying with temporal tiling` (#6) | The VAE fell back to tiling; the output is invalid for quality purposes. Run again. |
| Run ends at the time cap, no video (#7) | Raise `-TavanDk` for long clips (default time cap: 80 min for 209 frames, set by `uret.ps1`; our 209-frame run took 57 min [measured: run U209]). |
| Exit code empty but "finished" (#14) | The wrapper read the exit code too early; re-run, and check the video file exists. |
| System slows, swapping (#18) | The engine uses about 10-11 GB RAM; close browsers and other programs. |
| sha256 mismatch / download failed | Usually an interrupted download: run the same command again, verified files are skipped. |

**Stuck or curious?** [`SUPPORT.md`](SUPPORT.md) (where to ask; reply times are goals, not commitments) · [`PRIVACY.md`](PRIVACY.md) (no telemetry; the network is used only to download the engine and models, from listed hosts) · [`SECURITY.md`](SECURITY.md) (private reporting) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (first pull request in 5 steps; no GPU needed for docs and scripts).

### New in v0.1.1: more options (details: `AGENTS.md`, `docs/SIK_HATALAR.md` 19-23)
Without these options nothing changes on a 4 GB card (the 56-frame byte check against our reference passed again with v0.1.1 [measured]). Add `-Kuru` to any command to see what would run.
- `-EndImg`: give the last frame too (first-last frame, "FLF"); cap 175 frames on cards under 8 GB (192 did not fit on 4 GB), 192 on 8 GB+ cards. On our GTX 1050 Ti it always runs in two processes: 56 frames 1040 s, 175 frames 2887 s (48 min), both passed the gate [measured]. Prompt tips: `docs/ISTEM_YAZIMI.md`.
- `-W` / `-H`: other sizes, e.g. vertical 384x640; multiples of 32, area at least 640x384 (never smaller). Not tested on 4 GB; on cards under 8 GB sizes beyond our largest measured job are refused. Quality-gate thresholds are calibrated at 640x384.
- `-TekAsama`: one process instead of two, for large cards only; never switched on automatically.
- Newer GPUs (compute capability 7.0+, e.g. RTX 20/30/40): `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` is set automatically unless you set it yourself; this fixed an all-black video at 141+ frames on the reporter's RTX 4070 Ti [user-reported, issue #1]. Without Python + OpenCV, `uret.ps1` now stops with exit 6 before the GPU job (no video made, no misleading RED).
- Thanks to @SinanC73 for the RTX 4070 Ti report that led to these changes ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1)).

```powershell
# First and last frame (FLF): the clip starts on ilk_kare.png and ends on son_kare.png (up to 175 frames on 4 GB)
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 141 -InitImg ilk_kare.png -EndImg son_kare.png
# Vertical 9:16 (multiples of 32, area at least 640x384; not tested on 4 GB)
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 56 -W 384 -H 640
# One process instead of two (large cards only)
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 141 -TekAsama
# Print the exact engine command and settings without using the GPU
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 141 -Kuru
```

## Optional speed profiles (speed pack; off by default)
Nothing below changes the default run (640x384, 209 frames, 3414 s on our card). These are three measured cells beyond it, each one a named profile of `uret.ps1`; they need the speed-pack engine (the release engine plus patches 0021, 0023, 0024, all off by default: `docs/YAMALAR.md`). Install it with `scripts\kur.ps1 -HizPaketi` (a local zip works with `-MotorZip`), then add `-Profil <name>`; `-Kuru` prints what would run. The speed pack is published with release v0.1.4.

| Profile | Size, length | Total time on a GTX 1050 Ti 4 GB | Status |
|---|---|---|---|
| (none, default) | 640x384, up to 209 frames (8.7 s) | 3414 s for 209 frames | verified, unchanged |
| `yuksek832` | 832x480, 141 frames (5.9 s) | about 55-56 min | usable, two prompts [measured] |
| `yuksek832 -Kare 124` | 832x480, 124 frames (5.2 s) | about 45-46 min, no speed flag needed | usable, two prompts [measured] |
| `yuksek896` | 896x512, 124 frames (5.2 s) | about 56-57.5 min | usable, two prompts [measured] |
| `uzun260` | 640x384, 260 frames (10.8 s) | about 71 min [measured: 70.7 min end to end through `uret.ps1`, with the early exit; 78 min without it] | runs close to the memory limit; prompt measured up to about 2000 characters |

- **Narrow margin:** at 832x480 x 141 the memory gate keeps single-digit MB of headroom (5.7 and 6.8 MB in the two full runs). Two long prompts (1520 and 2041 characters) were checked only by reading the gate for step 1 and part of step 2, not run in full: headroom 10.9 and 4.0 MB. Any other process holding card memory (browser, second display) can make it fail; then use `-Kare 124` or the default size [measured, GTX 1050 Ti 4 GB].
- **`uzun260` runs close to the memory limit:** VRAM peak 3861-3903 of 4096 MiB. Three full runs (two scenes); shared-memory use grew by 28 to 61 MiB against a 68 MiB limit. Prompts were measured up to 1403 characters in full runs and 2009 characters by gate reading; at 2527 characters the shared-memory limit was exceeded. No flag-off reference exists for byte equality at this length. Close other programs that use the GPU; if a run fails, use the default 209 frames. Patch 0023 is accepted for this one cell only.
- **Not offered:** 832x480 at 158 frames does not fit with the shipped patches (it dies at the step-2 gate, about 280 MB short); 175 frames was only gate-read (about 275 MB short at the first block, no full run). The profile offers 141 frames only. Other sizes and frame counts are refused by `-Profil` (use the default path).
- Default quality is untouched: 6 steps, cfg 1, tile-less VAE, 17k+5 frames. Where flags are on, the output was checked against the flag-off video byte for byte at the sizes where the flag-off run fits (`docs/YAMALAR.md`); at 832x480 x 141 and 896x512 x 124 the flag-off run does not fit, so equality there rests on the nearest cells, not on a direct comparison [measured, read].
- Stage 1 of a two-stage run now ends as soon as the latent file is complete (`VT_ERKEN_CIKIS=0` turns that off).

## Disk layout and removal
Everything VideoTurko installs lives in one root folder, `<VT_ROOT>` (default: the folder you extracted; set the environment variable `VT_ROOT` before running the scripts to use another place). Nothing is written to the system PATH, the user profile or the registry.

| Folder under `<VT_ROOT>` | What is in it | Size |
|---|---|---|
| `engine\bin`, `engine\lisanslar` | the release engine (exe and DLLs; GTX 10xx and RTX 40xx) and the license files of its zips | not measured |
| `engine\stock_cuda12\bin` or `engine\stock_vulkan\bin` | only one of them, when your card gets the stock stable-diffusion.cpp engine (the installer picks it); its license files sit next to it in `lisanslar\` | about 1.2 GiB unpacked (CUDA) or about 0.08 GiB (Vulkan) [measured: zip central directory, maintainers] |
| `engine\secili_motor.json` | which engine `kur.ps1` selected; `uret.ps1` reads it (`VT_ENGINE_BIN` wins when set) | tiny |
| `model` | the model files, downloaded from the official source and sha256-checked | 29.3 GiB [read: `AGENTS.md`] |
| `indirme` | downloaded zips and their unpacking leftovers | not measured |
| `runs` | your finished videos | grows with use |
| `.venv` (optional) | the Python environment for the quality gate (opencv-python, numpy) | not measured |

The install scripts run no `pip`, `uv` or Hugging Face tool, so they write no package or model cache. Only if you install the optional gate packages yourself, keep the cache in the root too: `py -3 -m venv <VT_ROOT>\.venv`, then `<VT_ROOT>\.venv\Scripts\python.exe -m pip install --cache-dir <VT_ROOT>\.onbellek\pip opencv-python numpy`; the scripts use `<VT_ROOT>\.venv` when it exists (unless `VT_PYTHON` is set).

On Linux (`./kur.sh`, experimental) the same root holds:

| Linux path under `<VT_ROOT>` | What is in it |
|---|---|
| `.venv`, `.onbellek/pip` | the Python environment (opencv-python-headless, numpy) and its pip cache; always created by `kur.sh` |
| `engine/src`, `engine/build` | the stable-diffusion.cpp source at the pinned commit and the build folder |
| `engine/toolchain` | only if the build needs a local toolchain |
| `engine/bin`, `engine/.yamalar_tamam` | the built `sd-cli` with its `SHA256SUMS`, and the marker that the patches were applied |
| `model/`, `runs/` | as on Windows |

**Already downloaded the model?** Point the installer at it with `-ModelKlasoru <folder>`: files whose sha256 matches are linked instead of downloaded. On the same drive this is a hard link (the data exists once, so deleting the source folder later does not free the space); on another drive it is a COPY (about 29 GiB twice). A complete file with the right sha256 is skipped, and an interrupted download continues from its `.part` file.

**Removal:** close VideoTurko, copy out the videos you want to keep from `runs`, then delete the `<VT_ROOT>` folder. That is the whole uninstall. Not ours to remove: a `pip install` you made into the system Python (use a `.venv` as above to avoid that) and anything installed with `winget`.

## Which engine does my card get? (automatic)

`kur.cmd` reads your card (the compute capability from `nvidia-smi`; for AMD the Windows display adapter name) and picks the engine itself. Before anything is downloaded, `scripts\kur.ps1 -Kuru` shows the choice in one line: `Motor secimi: <id> (kart sinifi <class>; durum <status>)`. Nothing else to decide: double-click `kur.cmd`. To choose by hand: `-MotorTuru release_sm61`, `-MotorTuru stock_cuda12` or `-MotorTuru stock_vulkan` (a local zip given with `-MotorZip` / `-CudaZip` counts as the release engine). The table behind this is `scripts/kart_tablosu.json`.

Status words: **verified** = the maintainers measured it; **community** = a user reported it, we did not measure it; **untried** = nobody has reported a run.

| Card class | Engine chosen | Status | Evidence |
|---|---|---|---|
| GTX 10xx (Pascal, compute capability 6.1-6.9) | release engine (`sm_61`, our patches) | verified, GTX 1050 Ti only | [measured] `docs/OLCUMLER.md`; other Pascal cards [guess: same architecture] |
| RTX 20xx, GTX 16xx (Turing/Volta, 7.x) | stock CUDA engine | untried | [read] the stock build lists `sm_70` and `sm_75`; no run reported |
| RTX 30xx (Ampere, 8.0-8.8) | stock CUDA engine | community | [user-reported, PR #6] RTX 3070 8 GB, run outside `uret.ps1`, quality gate not run; no measurement on 6 GB laptop cards [guess: same architecture] |
| RTX 40xx (Ada, 8.9) | stock CUDA engine, `f32` | community | [user-reported, issue #25] RTX 4070 Laptop 8 GB: stock engine 209 frames 275 s vs release engine 620 s, gates passed on both (stock run outside `uret.ps1`); [user-reported, issue #24] RTX 3060 12 GB (Ampere): stock 2.6x faster than release at 209 frames; earlier reports ran the release engine: [user-reported, issue #1] RTX 4070 Ti, [user-reported, PR #5] RTX 4060 with a local `sm_89` build. Override: `-MotorTuru` / `VT_ENGINE_TYPE` |
| Hopper and newer data-centre cards (9.0-11.x) | stock CUDA engine | untried | [read] the stock build lists `sm_90` and `sm_100`; no run reported |
| RTX 50xx (Blackwell, 12.0 and up) | stock CUDA engine | untried | [read] the stock build lists `sm_120`; no stock run on an RTX 50 card; [user-reported, PR #3] the release `sm_61` engine gave a black video at 56+ frames and a local `sm_120` build worked |
| AMD Radeon | stock Vulkan engine, `minimax_h3_attn_chunk_budget=0.03` | community | [user-reported] RX 9070 XT 16 GB, 209 frames; ROCm is not automatic (it needs `hipblas.dll`) |
| Intel, anything else | none automatic | n/a | `kur.ps1` stops with an error; choose by hand with `-MotorTuru` |

The `f32` setting (`GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32`) is applied automatically on NVIDIA cards with compute capability 7.0 or higher. The stock engine runs in a single process (the two-stage keys of our patches do not exist in it); the quality settings are the same on every card (6 steps, cfg 1, 640x384, non-tiled VAE) and the quality gate runs the same way. If the VRAM is not enough the engine stops early with `[VT-E-VRAM]`, which suggests a shorter `-Kare`. On a card class that is not verified you get the warning `[VT-W-GPU-DENENMEDI]` with its status and evidence. A stock engine adds about 1.2 GiB unpacked (CUDA; zips 412 MB and 563 MB) or about 0.08 GiB (Vulkan; zip 30 MB) under `engine\` [measured: zip central directory, maintainers]. Details per card: `docs/KART_PROFILLERI.md`. A longer film from several clips: `docs/KLIP_ZINCIRI.md`, `scripts/zincir.py` [user-reported]; chained-film quality not measured by us [not tried].

> **Add your card (pull request).** One short PR is enough: (1) the line printed by `nvidia-smi --query-gpu=name,memory.total,driver_version,compute_cap --format=csv,noheader,nounits`; (2) the output of `scripts\kur.ps1 -Kuru`; (3) a summary of your `uret.ps1` run (frames, time, peak VRAM if you have it), every number labelled [measured], [read] or [guess]; (4) a new row in `docs/KART_PROFILLERI.md` and, if the engine choice should change, a suggestion for `scripts/kart_tablosu.json`. A PR that changes the quality settings (6 steps, cfg 1, 640x384, non-tiled VAE) cannot be accepted. See `CONTRIBUTING.md`.

License: accepting the MiniMax H3 license (`docs/LISANS_KABUL.txt`) applies on every path.

## Linux (experimental)

**Status: experimental.** The maintainers have not run a GPU job on Linux. The only evidence is [user-reported, PR #8] 56 frames on an RTX 4060 Ti 8 GB (contributor @xmtaha); 141 and 209 frames were not measured on Linux [not tried]. The Windows engine choice (the stock engine, `scripts/kart_tablosu.json`) does not apply on Linux: you build the engine yourself from pinned sources with our patches.

Needs: an NVIDIA driver (`nvidia-smi` works; 4 GB of VRAM or more), the CUDA Toolkit (`nvcc`), `git`, `cmake` and `python3`; about 29.3 GiB for the models (at least 32 GiB free on the model drive) plus room for the source and the build under the root [guess: about 10 GiB more on the root drive; not measured].

```bash
./kur.sh --kuru
./kur.sh
./uret.sh --istem docs/ornek_istem_R0.txt --kare 56
```

`./kur.sh --kuru` changes nothing (it writes, downloads and builds nothing) and reports readiness through its exit code. `./kur.sh` checks the GPU (compute capability 6.1 or higher), the disk and the model license (it asks you; `--lisans-kabul E` means you have read and accepted it yourself), creates a Python environment under the root (`.venv`, pip cache `.onbellek/pip`), clones and builds stable-diffusion.cpp at a pinned commit with the patches checked against `patches/SHA256SUMS` (the build takes a long time [not measured]), downloads the models with sha256 checks, runs a real 5-frame check, and prints READY only if that check passed (`--kontrol-atla` skips the check and never prints READY). `./uret.sh` follows the same rules as `uret.ps1`: frame counts 17k+5 up to 209 (192 with `--init-img`), 640x384 by default, the same two-stage threshold, `f32` on cards with compute capability 7.0 or higher, the same quality gate, and the quality settings are fixed on every system (6 steps, cfg 1, non-tiled VAE). Exit codes of `kur.sh`: 0 ready, 1 error, 2 license needed, 3 hardware or disk not enough; of `uret.sh`: 0 done, 1 error, 2 usage error or stop file, 5 quality gate RED, 6 gate could not run.

## What this is
A set of small memory/scheduling patches for stable-diffusion.cpp plus the run recipe, checks and measurements that let MiniMax H3 (33B DiT; we run the HyperFlow Flash 13.7B Q4_K_M GGUF; the 32B Qwen3-VL text encoder is separate) run on a 4 GB Pascal GPU (GTX 1050 Ti, 16 GB system RAM).
- Single-pass lengths we actually produced and passed our quality gates: 56, 141, 158, 175, 192, 209 frames at 640x384, 24 fps (209 frames = 8.7 s), with H3's own generated audio [measured: 209 frames with the release binary through `uret.ps1`, run U209; latent byte-identical to the development-build run; frames and audio identical in the video, the file sha differs because of the container; evidence kept by the authors, not in this repo]. 209 is the longest length we watched and found smooth [user-reported, 2026-11-19, video watched in full; file: F209V2 output, 8.708 s].
- **Byte-identical claim, honestly scoped:** outputs were checked byte-identical to the unpatched reference only for 56 and 141 frames. For 158/175/192/209 frames we used the same flags and the same binary chain; there is no direct byte reference (the unpatched build cannot run those lengths on this GPU).
- Quality settings are never lowered: same model/quantization, 6 steps, cfg 1, 640x384, same seed, non-tiled VAE.
- We do not claim to be the first: we searched and found no outside example of this on 4 GB, which is not proof that none exists.

## Layout
- `patches/` patches against a pinned stable-diffusion.cpp commit (see the notes there)
- `scripts/` build, run, separate-process VAE, gate/consistency helpers (`doku_norm.py`: see the scale note below)
- `docs/KURULUM.md` hardware, build and run steps (EN+TR)
- `docs/YAMALAR.md` patch list, `docs/KANITLAR.md` evidence, `docs/KAPILAR.md` quality gates table, `docs/OLCUMLER.md` measurements, `docs/SIK_HATALAR.md` common mistakes, `docs/LISANS_UYARISI.md` full license items
- `scripts/` short index: `hiz_kos3.ps1` run wrapper (`-Kuru` prints the exact command), `uretim_kapi.ps1` quality gate, `dikis_denetim.py` seam check, `doku_norm.py` texture-normalised noise, `bayt_kiyas.py` byte comparison, `derleme_sablonu.ps1` build template (stops only the Visual Studio telemetry helper `vctip.exe` that started after its own build began, which otherwise keeps the build process attached for minutes; other `vctip.exe` processes are left alone)

## Quality gates (how a result is accepted)

This gate does not check motion consistency (object scale or position jumps): watch the whole video before accepting it.
1. Frame count and audio present; no memory fallback or ALLOC_FAILED lines in the log.
2. Raw noise gate: median-filter residual <= 1.5 (0-255 scale).
3. Texture-normalised noise, `scripts/doku_norm.py` (this repo's version): N = median residual / Sobel texture, every 6th frame. **Scale note:** in this version the 10 measured clips give N = 0.034-0.052 (table in `docs/KAPILAR.md`; last quarter of F192/F209V2 reaches 0.062) and the extra-gate threshold is N <= 0.065. A different implementation measured 0.028-0.036 on the same clips, so thresholds are NOT interchangeable between versions. On very fine textures (grass rows) clean N was 0.075, so the threshold is per scene family. A robust high-frequency estimator (sigma-HH <= 1.5; clean 0.74-1.19, added noise s=2 gives 2.2-3.0) is the recommended extra gate.

Scope: VideoTurko is about ONE single pass (up to 209 frames, about 8.7 s). Our own chaining test showed visible seams (the scene does not continue cleanly), so longer films are not part of what we verify. For chaining, see the community guide `docs/KLIP_ZINCIRI.md` and our CPU-only helper `scripts/zincir.py` (`plan`, `son-kare`, `bagla`; it never starts the engine); we did not measure the quality of chained films [not tried], so check every seam by eye and with `scripts/dikis_denetim.py`.
Your settings are yours: 209 frames is our tested default on a 4 GB card, not a limit you must use. Pick any frame count on the 17k+5 grid (39, 56, 73, ... 192, 209; see `docs/KURULUM.md`), change the prompt, seed, resolution or any flag as you like. Shorter clips need less memory and time; larger GPUs may fit more.

## Model license warning
**VideoTurko contains only patches and scripts (MIT); whoever uses the model and its outputs is responsible for the MiniMax license themselves.** Not legal advice. Below are the clauses of the MiniMax H3 Community License (August 2, 2026) summarized with their numbers; the license itself is binding: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

The MIT license of this repository does not cover the model weights; see [`NOTICE`](NOTICE). This repo contains NO model weights (no MiniMax H3, HyperFlow-H3-Flash GGUF or VAE files). This project is not affiliated with or endorsed by MiniMax. Commercial use is NOT prohibited (it is not a non-commercial license); the conditions are below.

**Territory (Applicable Territory)**
- **Preamble, I.3, I.5:** Worldwide, EXCLUDING the European Union, the United Kingdom, the Republic of Korea and the United States. Using the model counts as accepting the license.
- **II:** Royalty-free, non-transferable, limited license to use, reproduce, distribute, create derivatives and modify, only inside the territory and in compliance with the agreement and Exhibit A. People in excluded territories may ask MiniMax for a separate license.
- **V.4:** Using, reproducing, modifying, distributing or displaying the model, its derivatives AND OUTPUTS (generated video/audio) outside the territory is not authorized. **So publishing or showing generated videos in the EU/UK/South Korea/US is outside the license.**
- **Exhibit A-1:** Use outside the territory violates the Acceptable Use Policy.

**Distribution (III)** (this repo does not distribute the model; if you do)
- **III.1:** Give every recipient a copy of the license. **III.2:** Mark modified files with prominent notices.
- **III.3:** Encouraged (not mandatory): "Powered by MiniMax H3" notice, AI-generation identifier on produced files, a public write-up.
- **III.4:** Distributions MUST be accompanied by a NOTICE file with: "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12:** publishing content to any public environment without clearly disclosing that it is machine-generated is prohibited: label AI-generated videos when you publish them (full list: `docs/LISANS_UYARISI.md`).
- **III (last paragraph):** You may add your own copyright to your modifications but may not impose additional or different terms on use/distribution; territory rules still apply.

**Commercial terms (IV)**
- **IV.1:** If your commercial products/services generate more than USD 20 million (or equivalent) yearly revenue, obtain PRIOR written authorization from api@minimax.io (subject "MiniMax H3 licensing - authorization request").
- **IV.2:** The UI of a commercial product/service using the model must prominently display "MiniMax H3".

**Use restrictions (V)**
- **V.1:** Comply with applicable law (including trade compliance) and Exhibit A. **V.2:** Bind everyone you give access to by terms at least as protective as these restrictions and notify them.
- **V.3:** You may not use the model or its OUTPUTS to improve any other AI model (other than MiniMax H3 and its derivatives). (I.11: distillation and training on synthetic outputs make a model a "derivative"; outputs themselves are not derivatives.)
- **V.5:** If you offer third parties a product/service/hosted service that generates outputs with the model: before and throughout operation, reasonable technical and organizational safeguards, a reporting mechanism, prompt investigation, and removal/disabling/suspension of repeat violators.

**Trademark and rights (VI)**
- **VI.1:** You own the derivative works and model derivatives you create (subject to MiniMax's rights). **VI.2:** MiniMax names/marks are not licensed (beyond what is needed to describe and distribute); the "MiniMax H3" mark may be used only to comply with III.3, within the territory; do not imply affiliation.
- **VI.3:** If you sue MiniMax or anyone alleging the materials/outputs infringe your rights, all your licenses end that day; you defend and indemnify MiniMax against third-party claims arising from your or others' use/distribution.
- **VI.4:** MiniMax claims no rights over outputs; you and your users are responsible for outputs and their use.

**Disclaimers and termination (VII, VIII, IX)**
- **VII.1:** No obligation to support/update. **VII.2:** Model and outputs are provided "AS IS", no warranties; you decide suitability and assume the risk. **VII.3:** MiniMax and affiliates are not liable for any damages (to the extent law permits).
- **VIII.1:** Effective on acceptance/access. **VIII.2:** On breach MiniMax may terminate; you must stop using/distributing, delete copies and notify recipients (VI.1, VI.3, VII, IX survive).
- **IX:** Hong Kong SAR law; exclusive jurisdiction of Hong Kong courts (UN CISG excluded).
- **Additional note:** MiniMax H3's encoder uses Qwen3-VL-32B (Apache 2.0).

**Acceptable Use Policy (Exhibit A)** (do NOT use the model, derivatives or outputs for)
- A-1 use outside the territory; A-2 violating laws or third-party IP; A-3 harming yourself or others; A-4 repurposing/distributing outputs to harm; A-5 circumventing safeguards; A-6 exploiting/harming minors; A-7 verifiably false information to harm others or influence elections; A-8 fake online engagement (fake reviews etc.); A-9 defamation, disparagement, harassment; A-10 malware; A-11 personal data to harm others; **A-12 publishing content to any public environment (including bot posts) without clearly and prominently disclosing it is machine-generated**; A-13 impersonation without consent; A-14 high-risk automated decisions in critical domains (law enforcement, immigration, health, critical infrastructure, credit, employment, housing, education, social scoring, insurance, etc.); A-15 violating other countries'/regions' social, ethical, moral standards; A-16 violent extremism/terrorism; A-17 discrimination/harm based on protected characteristics; A-18 exploiting vulnerable populations; **A-19 military purposes**; A-20 unauthorized/unlicensed professional activity (financial, legal, medical, etc.).
- Note: this is a plain-language summary; the English license text prevails in case of doubt.

## Evidence labels

One set for all documents (older spellings in brackets):
- **[measured]** (TR: ölçtüm, olctum): run in this project, evidence path exists.
- **[read]** (TR: okudum yol, okudum): source or script was read, not run.
- **[design]** (TR: tasarım, tasarim): designed, not yet seen in a real run.
- **[guess]** (TR: tahmin): not verified.
- **[not tried]** (TR: denenmedi): never run.
- **[user-reported]** (TR: kullanıcı bildirdi): stated by the user, with date; not independently measured.
- **[computed]** (TR: hesap; older spellings: calculated, hesap): a number derived from measured inputs, not itself measured; the derivation is written next to it. [proposal] / [öneri] in older text = [guess].

Run names used in brackets (our own run names, not files in this repo): U209 = 209 frames with the release binary through `uret.ps1`; B209 and B192 = image-to-video (`-InitImg`) runs at 209 and 192 frames; B56VT2 = release binary, 56 frames, compared with the 56-frame byte reference R0; F209b, F209V2, F209V2K = 209-frame runs on the development build (details: `docs/OLCUMLER.md`).

## Known limitations
- **Byte proof** (how to reproduce it yourself: `docs/KANITLAR.md`, "R0 ve latent referansi nasil uretilir"; verified on our sm_61 card, other GPUs may not be byte-identical [guess]): with our patch series (memory flags on) a 56-frame run gave sha256 `0979f156d548169b...`, identical to the reference [measured]; at 141 frames the latent sha256 `E5D028F8632BE4FE...` was identical (with the 0013/0014 flags). Frames 158 to 209 have no direct byte reference; the gate chain is the evidence. Passing the numeric gates does not guarantee a good clip: motion consistency over time is checked by eye (see `docs/KAPILAR.md`).
- **209 frames, which flag set:** the 209-frame byte-chain evidence was taken with the F209V2 flag set on the development build (no block-tail flags, built without patches 0019/0020); `uret.ps1` uses this recipe for 209 frames [read: the script; a real engine run through `uret.ps1` passed in run U209].
- Verified by us on one card (GTX 1050 Ti 4 GB); outside reports for other cards are listed with their labels in `docs/KART_PROFILLERI.md` [user-reported].
- **Which binary was measured:** the 141-frame latent and the byte chain were measured with our development builds. The release binary you download is a fresh build: its 56-frame byte gate passed (next item) and a 209-frame run through `uret.ps1` passed the gate (run U209, 3414 s, VRAM peak 3777 MiB) [measured]; against the development-build 209 run the latent is byte-identical; in the video the frames (md5) and the audio are identical, the AVI file sha256 differs because of the container [measured] (see `docs/OLCUMLER.md`, section 0).
- **Release binary, 56 frames:** the release binary (sd-cli `c5cebe78...`, stable-diffusion.dll `e5d3d329...`) gave a 56-frame result byte-identical to R0 (sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`; per-frame md5 and audio identical), run directly with default flags (no `SD_*` variables), exit code 0, 601 s [measured: run B56VT2, 2026-11-19; evidence kept by the authors, not in this repo]. Scope: our sm_61 card and 56 frames only; not a clean-root install test; the 141-frame latent and the 209 chain were measured with the older binary and NOT repeated with this one [not tried]. A first attempt (B56VT, via a helper script) ended silently after 58 s, cause unknown [guess: memory pressure]; the second attempt ran `sd-cli` directly.
- The install and run scripts have not been verified from an empty folder yet (clean-root test pending).
- Roadmap and next steps: `ROADMAP.md`.

## Status and limits
- Verified on one machine (GTX 1050 Ti 4 GB, 16 GB RAM, i7-7700HQ). Other 4 GB cards and other RAM sizes may differ.
- **Default 209 frames (8.7 s):** passed our quality gates (noise 1.08, run F209V2K) [measured: 209 frames with the release binary through `uret.ps1`, run U209; latent byte-identical to the development-build run; frames and audio identical in the video, the file sha differs because of the container; evidence kept by the authors, not in this repo]. At 209 frames the DiT VRAM peak was 3777 MiB of 4096 MiB (runs F209b and U209; whole-card `nvidia-smi` reading), a thin margin: other GPU load (the display, other applications) can make the run fail at `blocks.0`; tested only on a GTX 1050 Ti. The display state during that run was not recorded; if your display runs on this card, less VRAM is available [guess: a Windows display load of about 100-300 MB]; if needed, connect the display to an integrated GPU [advice, not tested]. Sampling took 2730 s (run U209: steps of 436-483 s) and the separate-process VAE decode 173 s (stage 2 in total 193 s with the audio decode) [measured: U209 release binary; older development runs: 2664 s and 174 s]. In stage 1 the in-process VAE ran out of memory and fell back to temporal tiling (320 s); that output is discarded, the video comes from the non-tiled stage 2. Peak RAM was not measured in U209. Longer clips than 209 frames are not part of this release.
- **Image-to-video (`-InitImg`):** with an init image the cap is 192 frames (8.0 s at 24 fps) on this GPU: 209 frames did not fit (about 17.5 MB of VRAM short at block 0: need 2587 MB, available 2570 MB); 192 frames ran through `uret.ps1` in 3086 s with a VRAM peak of 3783 MiB and the gate passed [measured: runs B209 and B192, 2026-11-20, one scene; evidence kept by the authors, not in this repo]. Not tried on other GPUs [not tried].
- **Free RAM matters:** you need about 11 GB of FREE RAM (the engine process holds about 11 GB) [measured]. With too little free RAM the process can die without an error message [guess: we observed it once with about 300 MB free RAM while `sd-cli` held about 10 GB]. Do not open other big programs while it runs: on a 16 GB machine only about 0.3-0.5 GB stays free, and under memory pressure the run can die silently. Before you start, close browsers, games and other big programs and check the free RAM.
- **Clean-root test pending:** the install and run scripts have not yet been verified from an empty folder using only these instructions; this section will be updated when that test (including a 56-frame byte comparison against the reference) is recorded.
- No generated videos are shipped here.

