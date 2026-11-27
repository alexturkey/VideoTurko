# AGENTS.md: setting up and using VideoTurko (for AI coding agents)

Goal: run MiniMax H3 text-to-video (image-to-video with `-InitImg`: up to 192 frames, 8.0 s) on a **Windows 10/11 PC with a 4 GB NVIDIA GPU** (tested: GTX 1050 Ti), up to 209 frames (8.7 s) in one pass (default; 209 frames are verified by a byte chain). This repo has patches for stable-diffusion.cpp, run scripts, quality gates and measurements. It contains no model weights and no videos. `CLAUDE.md` and `GEMINI.md` point here. In a hurry: `AGENTS_HIZLI.md` is a 12-step decision tree with an exit code to action table (English and Turkish); `llms.txt` is the index for crawlers and agents.

One sentence of status: 209 frames (the default) are verified by a byte chain on the development build and passed the quality gates; the release binary passed the 56-frame byte gate and a 209-frame run through `uret.ps1` (run U209); against the development-build 209 run the latent is byte-identical, video frames and audio identical, file sha differs (container) [measured, one machine: GTX 1050 Ti 4 GB, sm_61].

The models (29.3 GiB) are not in this repository or release (size limits); `kur.ps1` downloads them from the official source; a newly downloaded file is sha256-checked, a file already present with the right size is only size-checked (`scripts\modelleri_indir.ps1 -Dogrula` for the full sha256 check) [read: scripts/modelleri_indir.ps1].

Evidence labels ([measured], [read], [design], [guess], [not tried], [computed]) are defined once in README.md, section Evidence labels.

## First, do this (agents)
- **Run first:** `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\tani.ps1`. Read-only: it prints the system, the card, the `kur.ps1 -Kuru` dry run and a DEVIATIONS section (Python versions, locally changed files, `VT_*` overrides, model files present, known model copies). Read it to the user in plain words.
- **Keep a notebook:** `DURUM.md` in the root (git-ignored; `<ROOT>` instead of paths). Top three lines: `Now:` / `Next:` / `Question for you:`; below, one line per step with [measured] / [read] / [guess] and the command it came from. Update it after every step.
- **NEVER:** lower a quality setting; type `-LisansKabul E` for the user (only after the user read the license text on screen and said yes); use `-Zorla`; change system Python, PATH, registry or the user profile.
- **ASK first:** delete, move or re-download anything; install Python or packages; start the trial generation.
- **Same error twice:** stop; take the code and the first 20 log lines to the user. The 12-step card with exit codes is `AGENTS_HIZLI.md`.

## Requirements (measured on the test machine)
Windows 10/11 64-bit, NVIDIA GPU with 4 GB or more (tested: GTX 1050 Ti 4 GB; DiT VRAM peak 3777 MiB at 209 frames [measured: F209b and U209 release binary]).
- The margin is thin (whole-card `nvidia-smi` reading; the display state during that run was not recorded): other GPU load (the display, other applications) can make a run fail at `blocks.0`; tested only on a GTX 1050 Ti.
- If your display runs on this card, less VRAM is available [guess: about 100-300 MB for a Windows display]; if needed, connect the display to an integrated GPU [advice, not tested], 16 GB RAM (peak about 11 GB), 32 GiB free disk (models about 31 GB in total), Python 3 with `opencv-python` and `numpy` for the quality gate (`py -3 -m pip install opencv-python numpy`; `scripts/uretim_kapi.ps1`, `scripts/doku_norm.py`; set `VT_PYTHON` to that interpreter).
- **`uret.ps1` checks this BEFORE the GPU job** by running `python -I -c "import cv2, numpy"` (the `VT_PYTHON` interpreter, default `python`).
- If that fails (no Python; the Windows Store `python.exe` alias that only exits 9009; OpenCV or numpy missing) it stops with **exit 6** and no video is made, so a long run is not wasted on a gate that cannot run. `-Kuru` only prints that line, `-Kontrol` skips the check.
- Run on its own, `scripts/uretim_kapi.ps1` also exits 6 `KAPI CALISMADI` in these cases (never 5/RED) [read: `scripts/uret.ps1`, `scripts/uretim_kapi.ps1`].
- FFmpeg (for example `winget install Gyan.FFmpeg`) is optional: `ffprobe` counts the frames of the result, `ffmpeg` only draws the 12-frame contact sheet (`pafta_<name>.png`); both are looked up in `VT_FFMPEG` (ffmpeg only), `PATH` and `engine\bin` (the release does not ship them; `engine\bin` only helps if you put them there).
- When they are missing the frame count falls back to the AVI header and the contact sheet is skipped with an info line; the gate decision does not change.

## Hard rules (do not break them)
- **Quality is fixed:** 6 steps, cfg 1, 24 fps, seed 42, same model and quantization; size 640x384 by default. Never lower them to save time or memory. `-W`/`-H` may only keep or raise the picture area (multiples of 32, area at least 640x384), never shrink it.
- **No tiled VAE:** never add `--vae-tiling` or `--temporal-tiling`. A log line `retrying with temporal tiling` means the output is invalid; run again, do not accept it.
- **Frame counts follow 17k+5:** 56, 73, 90, 107, 124, 141, 158, 175, 192, 209. Any other number is rounded up by the engine. With `-InitImg` the cap is 192 frames; with `-EndImg` 175 frames on cards under 8 GB (192 on 8 GB+ cards, not measured by us).
- **One GPU job at a time.** Close other GPU programs. About 10-11 GB RAM is used; close browsers.
- **Patches are LF** (`.gitattributes` protects them). Do not convert them to CRLF; their hashes matter.
- **Evidence rule:** write "works" only for something you saw run in an empty folder using only these instructions. Label claims as measured / read from a file / guess.
- **Model license:** the model is not ours. Read `docs/LISANS_UYARISI.md` and `docs/LISANS_KABUL.txt` before downloading. Territory limits apply to outputs too.
- No personal paths, user names, e-mail addresses or tokens in anything you commit. Use `<ROOT>` and `<MODEL_DIR>`.

## Install (3 steps)
1. Extract the repo to a short folder, for example `C:\vt`. That folder is the install root: engine goes to `engine\bin`, models to `model`, runs to `runs`. `kur.ps1` and `uret.ps1` have no root parameter; to use another place set `VT_ROOT` before running them.
2. `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1` (`-Kuru` only reports what it would do: one full pre-report with every HATA/UYARI in a single list, the download URLs, rough times and what happens if you stop; it writes nothing; exit 3 if a HATA is listed).
   - It checks GPU, driver, RAM and disk (at least 32 GiB free on the model drive when models are missing; the old 47 GiB check had no source and was removed), fetches engine and models (new downloads sha256-checked; existing model files size-checked only, `-Dogrula` for sha256), runs a tiny real generation and prints READY only if that worked.
   - Safe to re-run: verified files are skipped. [design: `kur.ps1` has not been run in full in a clean folder; this will be updated after the clean-folder test; the license step was measured] The engine zip comes from the GitHub release v0.1.0 (published 2026-11-19; sha256 pinned in `kur.ps1`).
   - Offline or with your own build, pass local zips instead: `-MotorZip <path> -CudaZip <path>` (built into `dist/`, not stored in the repository).
3. `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209` (default 209; longer lengths are not supported) (`-Kuru` prints the commands without running them). Sample prompt: `docs/ornek_istem_R0.txt` (one English paragraph, optional `audio:` sentence). Output: `-Cikti <file>.avi`; without it the video goes to `<VT_ROOT>\runs\<date>_<N>kare\video.avi`.
   Prompt pattern (one continuous shot, four equal time slices, fixed identity, sound layers, two full examples): `docs/ISTEM_YAZIMI.md`.

## Card class and engine (`kur.ps1` chooses; agent rules)
`kur.ps1` reads the card (compute capability from `nvidia-smi`; for AMD the Windows display adapter name, VRAM and compute capability are not read) and picks the engine from one table, `scripts/kart_tablosu.json` (reader: `scripts/kart.ps1`, used by `kur.ps1` and `uret.ps1`).
- The README table "Which engine does my card get?" is the same data with its evidence.
- Classes (the engine each compute capability gets):
  - Pascal (6.1-6.9) gets the release engine and is the only VERIFIED class (GTX 1050 Ti).
  - Turing/Volta (7.x) gets the stock CUDA engine, UNTRIED.
  - Ampere (8.0-8.8) stock CUDA, COMMUNITY (PR #6, RTX 3070 8 GB).
  - Ada (8.9) stock CUDA engine with `f32`, COMMUNITY (stock 2.3-3x faster than the release engine on one RTX 4070 Laptop [user-reported, issue #25] and 2.6x on an RTX 3060 [user-reported, issue #24]; earlier reports ran the release engine: issue #1, PR #5; the release engine is built only for `sm_61`, so only Pascal keeps it by default).
  - Hopper and newer data-centre (9-11) stock CUDA, UNTRIED.
  - Blackwell (12+, RTX 50) stock CUDA, UNTRIED (no stock run on an RTX 50 card; the release `sm_61` engine gave a black video there [user-reported, PR #3] and a local `sm_120` build worked).
  - AMD stock Vulkan with `minimax_h3_attn_chunk_budget=0.03`, COMMUNITY (RX 9070 XT); ROCm is not automatic (it needs `hipblas.dll`).
  - Intel and anything else: no automatic engine, `kur.ps1` stops with an error and the user may choose with `-MotorTuru release_sm61|stock_cuda12|stock_vulkan`.
- A local zip given with `-MotorZip` / `-CudaZip` counts as the release engine. The stock engine is stable-diffusion.cpp `master-1106-532d2c1` (sha256 pinned in the table); it adds about 1.2 GiB unpacked (CUDA) or about 0.08 GiB (Vulkan) [measured: zip central directory, maintainers].
- It runs in a single process (the two-stage keys of the repo patches do not exist in it); the quality settings and the quality gate are the same.
Rules for you:
1. Run `-Kuru` first and read the `Motor secimi: <id> (kart sinifi <class>; durum <status>)` line to the user. If the status is `denenmemis` (untried) or `topluluk` (community), say so plainly: nobody (or only a community user, not us) has measured this class; a `[VT-W-GPU-DENENMEDI]` warning carries the same text. Do not call it supported.
2. Never switch the engine by hand to "fix" something (`-MotorTuru`, `VT_ENGINE_BIN`) unless the user asks; never write `dogrulanmis` (verified) into `scripts/kart_tablosu.json` or any document for a class we have not measured. A card is added to the table only through a PR with evidence (README box "Add your card").
3. If the VRAM is not enough the engine stops early with `[VT-E-VRAM]`; the hint is a shorter `-Kare`. Do not lower quality settings.
4. ROCm and Intel are not automatic: take it to the user. The license rule is unchanged: the user accepts the MiniMax H3 license on every path.
5. The install layout rules below apply as written; the stock engine folders are part of the root.

## Linux (experimental)
The Linux path (`./kur.sh`, `./uret.sh`, from PR #8) is EXPERIMENTAL: the maintainers have not run a GPU job on Linux; the only evidence is [user-reported, PR #8] 56 frames on an RTX 4060 Ti 8 GB, and 141/209 frames were not measured on Linux [not tried]. Tell the user so.
- Rules for you:
  - (1) run `./kur.sh --kuru` first (it writes, downloads and builds nothing; the exit code is the readiness: 0 ready, 2 license needed, 3 hardware or disk not enough) and read its output to the user
  - (2) the build clones stable-diffusion.cpp and compiles it with our patches and takes a long time: say that, get the user's yes (and the license decision, never type `--lisans-kabul E` yourself) before `./kur.sh`, run it in the background and poll
  - (3) the engine, the patches (checked against `patches/SHA256SUMS`) and the quality settings do not change (6 steps, cfg 1, 640x384, non-tiled VAE, frame counts 17k+5); the Windows card table, the stock engine and Vulkan are NOT used on Linux
  - (4) `./uret.sh` follows the rules of `uret.ps1` (exit codes 0 done, 1 error, 2 usage error or stop file, 5 gate RED, 6 gate could not run; the same "Exit 5 or 6 is not accepted" rule)
  - (5) everything lives under the root (`.venv`, `.onbellek/pip`, `engine/src`, `engine/build`, `engine/bin`, `model`, `runs`); the install layout rules below apply unchanged.
- Steps and options: `docs/KURULUM.md` section 7.

## Install layout and agent discipline
These rules apply to you (an AI agent) and to any sub-agent you start. They exist so that installing VideoTurko leaves nothing behind outside its folder and downloads nothing twice.

1. **One root.** Everything lives under one root folder, `<VT_ROOT>` (default: the folder you extracted; set `VT_ROOT` before running the scripts to use another place).
   - The release engine is in `engine\bin`; when your card gets the stock engine it is in `engine\stock_cuda12\bin` or `engine\stock_vulkan\bin` (only one of them, with its license files in `lisanslar\` next to it) and the choice is recorded in `engine\secili_motor.json` (`uret.ps1` reads it; `VT_ENGINE_BIN` wins when set).
   - The models (29.3 GiB) are in `model`, downloaded zips and their unpacking leftovers in `indirme`, finished videos in `runs`; an optional Python environment for the quality gate goes to `<VT_ROOT>\.venv`. Only the folders that are really used are created.
2. **No trace outside the root.** `kur.ps1` and `uret.ps1` run no `pip`, `uv` or Hugging Face tool (the models and the engine come from VideoTurko's own sha256-checked downloader), so there are no package or model caches to redirect and none are written. The optional gate packages are the one place a package manager appears: install them into the root, not into the system Python and not into the user profile:
   ```powershell
   py -3 -m venv "<VT_ROOT>\.venv"; "<VT_ROOT>\.venv\Scripts\python.exe" -m pip install --require-hashes --only-binary=:all: --cache-dir "<VT_ROOT>\.onbellek\pip" -r scripts\kapi-gereksinim-windows.txt
   ```
   It pins opencv-python 4.12.0.88 and numpy 2.2.6 by sha256; fallback: `pip install opencv-python numpy`. Point `VT_PYTHON` at `<VT_ROOT>\.venv\Scripts\python.exe` (or leave it unset: when `<VT_ROOT>\.venv` exists the scripts use it).
   - If a tool you add later uses `HF_HOME`, `HF_HUB_CACHE` or `TORCH_HOME`, point them into the root as well. The scripts set none of `PIP_CACHE_DIR`, `UV_CACHE_DIR`, `TMP` or `TEMP` themselves, and a value you set yourself is never touched.
   - The scripts do not change the system PATH, the user profile, the registry or any global setting, and you must not either (no `setx`, no profile edits, no `reg add`).
3. **No double download.** A complete file with the right sha256 is skipped; an interrupted download continues from its `.part` file; a model file already present with the right size is kept (`scripts\modelleri_indir.ps1 -Dogrula` runs the full sha256 check).
   - If the user already has the model, point the installer at it with `-ModelKlasoru <folder>`: files whose sha256 matches are linked, not downloaded (a hard link when it is the same drive: the data exists once, so deleting the source folder later does not free the space; on another drive it is a COPY, about 29 GiB twice).
   - Never fetch the same model into a second place and never start a second `kur.ps1` while one is running.
4. **Measure first.** Run `scripts\kur.ps1 -Kuru` (dry run: writes nothing) and read every `HATA:` / `UYARI:` line before any download. Tell the user the size, the sources and the model license, and wait for a yes (never type the license acceptance for the user).
5. **Show before you delete.** Before removing anything (a half install, `indirme` leftovers, an old environment) show the user the path, the size and the reason. The supported uninstall is deleting the root folder (see "Layout" in `README.md`); never delete outside it, never delete the user's own models. The scripts do not delete your files or anything outside the root; they delete only their own leftovers (`.part` files, unpacking folders, a model file that failed its sha256 check).
6. **Same error twice: stop.** Do not try a third time; take the code and the first 20 lines of output to the user.
7. **Sub-agents follow the same rules.** Put these rules in the brief of any agent you start; one GPU job and one install at a time; no agent edits the install scripts to get past a check.

## Options added in v0.1.1 (copy, paste, change the file names)
Run `-Kuru` first with the same options: it prints the exact engine command and environment without using the GPU. Defaults are unchanged: without these options the command is the same as in v0.1.0 except the flash-attention flag spelling (`--flash-attn off,diffusion=on` instead of the deprecated `--diffusion-fa`; same mode in the engine code [read: engine `examples/common/common.cpp`]).

- **First and last frame (`-EndImg`, "FLF"):** give the frame the clip must end on; the model fills the motion between.
  - On cards under 8 GB (or when VRAM cannot be read; 8 GB cards report 8151-8192 MiB, the threshold is 8000; the script treats 6 GB cards like 4 GB ones; we have no 6 GB data) the cap is 175 frames (192 did not fit) and `-EndImg` always switches to two processes; without `-Kare` it uses 175. On 8 GB+ cards the cap is 192, as with `-InitImg`.
  - On our GTX 1050 Ti (4 GB) it always runs in two processes (one process ran out of VRAM even at 56 frames): 56 frames 1040 s (VRAM peak 3597 MiB), 175 frames 2887 s = 48 min (3721 MiB), both passed the gate; 192 frames did not fit [measured, 2026-11-20].
  - Not measured by us: `-EndImg` without `-InitImg`, and FLF on 8 GB+ cards (a 12 GB card passed 141 frames [user-reported, issue #1]). Prompt tips: `docs/ISTEM_YAZIMI.md`, section "First and last frame".
  ```powershell
  powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 141 -InitImg ilk_kare.png -EndImg son_kare.png
  ```
- **Picture size (`-W` width, `-H` height):** default 640x384 (landscape). Both must be multiples of 32 (720 is refused: the engine would round it up to 736) and the area must be at least 640x384 (smaller = lower quality, refused). Vertical 9:16 example. Any size other than the default is **not tested on 4 GB**.
  - On cards under 8 GB (or when VRAM cannot be read; 8 GB cards report 8151-8192 MiB, the threshold is 8000) a non-default size is refused above the largest job measured on 4 GB (14880 tokens = 209 frames at 640x384; 13680 with `-InitImg`; 12480 with `-EndImg`); on 8-11 GB cards the cap is 16320 tokens (an RTX 4070 Laptop ran 1280x768 at 56 frames [user-reported, issue #26]; we did not measure it); `VT_MAX_JETON` overrides that cap at your own risk.
  - `-Kuru` prints the token count. The quality-gate thresholds are calibrated at 640x384: at larger sizes the raw noise reads lower, so a pass there is weaker evidence (watch the clip).
  ```powershell
  powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 56 -W 384 -H 640
  ```
- **Single process on large cards (`-TekAsama`):** by default runs whose token count is above 7680 (at 640x384: 108 frames and more) use two processes (DiT, then a separate VAE process), which a 4 GB card needs. `-TekAsama` forces one process; use it only on a large card (a 12 GB report ran 141 frames this way [user-reported, issue #1]); on 4 GB it is expected to fall back to the tiled VAE, which the script rejects as invalid [guess]. It is never switched on automatically.
  ```powershell
  powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 141 -TekAsama
  ```
- **Newer GPUs (compute capability 7.0 or higher, e.g. RTX 20/30/40):** `uret.ps1` sets `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` automatically when you have not set it yourself. Reason: a 12 GB RTX 4070 Ti produced an all-black video (NaN) at 141 frames and more without it [user-reported, issue #1]. Nothing changes on the GTX 1050 Ti (6.1). `-Kuru` shows whether it was set. To run without it, set your own value first (`auto` = the engine's own choice):
  ```powershell
  $env:GGML_CUDA_CUBLAS_COMPUTE_TYPE = 'auto'; powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 56
  ```
- **Gate cannot run (exit 6):** install Python 3 (python.org; the Windows Store alias does not count) and the gate's packages once, then run `uret.ps1` again. If a video already exists (for example from v0.1.0), re-check it without generating again:
  ```powershell
  py -3 -m pip install opencv-python numpy
  powershell -NoProfile -File scripts\uretim_kapi.ps1 -Dizin <output folder> -Ad video -Kare 56
  ```

**Long runs (209 frames: total 3414 s (57 min; default time cap 80 min for 209 frames): sampling 2730 s, separate-process VAE decode 173 s [measured: run U209, release binary through `uret.ps1`; older development runs through the research wrapper `hiz_kos3`: 2664 s and 174 s]):** start it hidden in the background and poll, do not block on it:
```powershell
Start-Process powershell -WindowStyle Hidden -ArgumentList '-NoProfile','-File','scripts\uret.ps1','-Istem','istem.txt','-Kare','209','-Cikti','C:\vt\out\clip.avi'
```
Progress: the log files `ham_out_<name>_a1.txt` (DiT stage) and `ham_out_<name>_a2.txt` (VAE stage) in the output folder; a DiT step takes about 436-483 s [measured: U209, steps 1-6; F209b: hot steps about 435 s].
- Stage 1 may print `VAE decode ran out of memory; retrying with temporal tiling`: that tiled output is discarded, the result comes from stage 2 [measured: U209].
- Stop cleanly by creating `<VT_ROOT>\DUR` (the script prints DURDU, kills the engine and does not resume: it restarts from the beginning) [DUR/DURDU through `uret.ps1`: not tried]. When it ends it prints `TAMAM <seconds>: <file>` and, if Python and OpenCV are present, `KAPI GECTI` or `KAPI RED`.

**License acceptance is the human's decision:** `kur.ps1` asks for acceptance of the model license (`docs/LISANS_KABUL.txt`). Show it to the user and let the user answer; never pass `-LisansKabul E` on the user's behalf without their explicit consent.
- If there is no acceptance (for example an unattended run that cannot reach the user), `kur.ps1` stops with exit code 2 and downloads no model, in all three cases we ran [measured in a clean-folder test: `-NonInteractive` with closed input, `-NonInteractive` with an empty pipe, and an interactive empty Enter]; in the non-interactive cases it prints a message asking you to get the acceptance from the user and rerun with `-LisansKabul E`.
- Never run `kur.ps1` in a way that waits for a question without the user's confirmation: run `-Kuru` first, get the acceptance from the user, then run it with `-LisansKabul`. Do not create the acceptance record `.lisans_kabul.txt` by hand (the downloader writes it after a real acceptance).
- Ask the user, do not continue to the model step until the acceptance arrives, and never type E yourself.

Environment overrides: `VT_ROOT`, `VT_ENGINE_BIN` (a folder other than the one in `engine\secili_motor.json` makes `uret.ps1` treat the engine as the patched release type; `VT_ENGINE_TYPE=stock|release` overrides that), `VT_MODEL_DIR`, `VT_CUDA_BIN`, `VT_PYTHON`, `VT_FFMPEG`, `VT_MAX_KARE`, `VT_MAX_JETON`, `VT_GPU_CC` and `VT_GPU_VRAM` (testing only: override the compute-capability and total-VRAM MiB readings); engine variable `GGML_CUDA_CUBLAS_COMPUTE_TYPE` (left as you set it; otherwise `f32` on compute capability 7.0+).
- **Several GPUs:** only single-GPU runs were measured. `sd-cli` uses CUDA device 0; `uret.ps1` decides on the cautious side: the smallest total VRAM and the smallest compute capability among all cards (`f32` only if every card is 7.0+), and prints an info line.
- Pick the card with `CUDA_VISIBLE_DEVICES` if needed [read: `scripts/uret.ps1`; multi-GPU not tried]. Stop a running job by creating `<VT_ROOT>\DUR` (the scripts print DURDU).

## How to verify a result
- Frame count and audio present; no `[E]`, `ALLOC_FAILED` or `compute failed` in the log.
- `scripts/uretim_kapi.ps1`: raw noise <= 1.5, middle flow > 0.05; `scripts/doku_norm.py` texture-normalised noise (scale note in the README).
- Byte check against the reference on 56 frames with `scripts/bayt_kiyas.py` (reference sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`). Only 56 and 141 frames have a byte reference. The reference file R0 is not distributed; how to produce it yourself is described in `docs/KANITLAR.md` ("R0 ve latent referansi nasil uretilir").
- Chaining parts with `--init-img`: use the REAL last frame of the previous video (frame count minus one), never frame 205 of 209. Seams were visible in our tests, so chaining is not part of this project; `uret.ps1 -InitImg <real last frame>` exists only for users who want to try it, it was tested once (one scene, image-to-video) up to 192 frames [measured: runs B209 and B192].
- `-InitImg` (image-to-video): the cap is 192 frames (8.0 s at 24 fps) on this GPU; 209 frames did not fit (about 17.5 MB of VRAM short); 192 frames ran in 3086 s, VRAM peak 3783 MiB, gate passed [measured: runs B209 and B192, 2026-11-20, one scene]; other GPUs [not tried]. `uret.ps1` enforces this cap (`-EndImg`: 175 frames, see "Options added in v0.1.1").

## Common mistakes
See `docs/SIK_HATALAR.md` (numbered). Top ones: DLL not found (do not start `sd-cli.exe` by hand), VRAM gate failure at `blocks.0` (use fewer frames), silent tiled-VAE fallback, time cap too short for 209 frames, exit code read too early, RAM pressure.
**Stable error codes:** every `HATA:`/`UYARI:` line and every `throw` of `kur.ps1`, `uret.ps1` and `modelleri_indir.ps1` carries a code after the heading, for example `HATA: [VT-E-DISK] ...` or `UYARI: [VT-W-DISK-PAY] ...`.
- Look the code up in `docs/hata_imzalari.json` (EN and TR first step, plain-substring log signatures) and in `docs/SIK_HATALAR.md` (one anchor per code, lowercase, for example `#vt-e-dll`). Headings and exit codes did not change, so existing parsers and the MCP server keep working.
- Quote the code when you report a problem to the user or in an issue. Humans can double-click `kur.cmd` / `uret.cmd` (they wait for a key only when double-clicked); you run `kur.ps1 -Kuru` first, then `kur.ps1`, and never pass `-LisansKabul` for the user.
- After READY, `kur.ps1` prints the first-video command (56 frames, about 11 min on a GTX 1050 Ti [measured by the authors]).

Quality gate and motion: This gate does not check motion consistency (object scale or position jumps): watch the whole video before accepting it. The 209 recipe (runs F209b/F209V2): stage 1 margin 1, EMBED_CUT, DROP_QUEUED, EVICT_PAST, ATTN and QKV set-out, QKV/MLP chunk 64; stage 2 margin 256, VAE margin 256, cut cache 100 MB, no tiling fallback, VAE embed cut [read: `uret.ps1`]. 209 is the longest length watched in full and found smooth [user-reported, 2026-11-19, video watched in full; file: F209V2 output, 8.708 s].

Local engine zip check: since the release, a local zip is checked against the sha256 pinned in `kur.ps1` (a `.sha256` file beside the zip is ignored), so it must be the release zip; for your own build set `VT_MOTOR_SHA256` / `VT_CUDA_SHA256` to its sha256 first [read: `scripts/kur.ps1`]. A wrong sha256 stops with exit 1. [measured before the release: 5 scenarios with the sidecar path; evidence kept by the authors, not in this repo]

## Exit codes and success criteria
`kur.ps1` exit codes [read from the script, checked with grep; the license and engine-zip cases were measured]: 0 READY, 1 error (download, sha256 or check failed), 2 user input needed (license not accepted or cannot be asked non-interactively; no release yet or a wrong `-MotorZip`/`-CudaZip`), 3 hardware or disk insufficient, 4 DURDU (stopped by the `DUR` file).

`uret.ps1` exit codes (separate from `kur.ps1`) [measured: 4 scenarios with a real ffmpeg AVI, a fake `sd-cli` and a fake gate: passed 0, RED 5, silent video 1, no python 6; real engine and real OpenCV gate through `uret.ps1` on the release binary: exit 0 in run U209; evidence kept by the authors, not in this repo]:
- 0 DONE (printed only when the quality gate passed; `-Kuru` dry run also exits 0 without running anything)
- 1 error or invalid output (a `throw`, no explicit `exit 1`: bad input, GPU busy, `TavanDk` time cap hit, no latent, tiled-VAE or memory error in the logs, no or too small `.avi`, wrong frame count, no audio stream)
- 2 DURDU (stopped by the `DUR` file)
- 5 `KAPI RED` (gate failed: the clip is NOT accepted, the decision is the user's; reasons in `docs/KAPILAR.md` and `runs\olaylar.txt`)
- 6 gate cannot run (no Python, the Windows Store alias that exits 9009, or Python without `opencv-python`/`numpy`): checked BEFORE the GPU job, so no video is made (`KAPI CALISAMAZ`); if the gate still fails after generation (`KAPI CALISMADI`) the video exists but is NOT accepted.
- Fix: install Python 3 and `py -3 -m pip install opencv-python numpy`, see "Options added in v0.1.1". Before v0.1.1 a Python without OpenCV gave a misleading 5 (RED).
- Never report success on exit codes 5 or 6. [read: the `exit` lines in `scripts/uret.ps1` (search for `exit `; line numbers are not quoted here because they move); code 1 comes from `throw`.]

`uret.ps1` counts a run as successful only when all of these hold together: the `.avi` exists, the frame count is right (ffprobe, or the AVI header `dwTotalFrames` when ffprobe is missing), and the logs are clean (no tiled-VAE fallback, no memory error).
- The engine's exit code alone is not the criterion (a non-zero code is a warning). Free VRAM at the whole-card peak of 296 MiB or less (on a 4096 MiB card: the same as the old 3800 MiB peak rule; on larger cards relative to their size) is only a WARNING, not a failure.
- **Quality gate and audio:** `uret.ps1` checks the audio stream with ffprobe (real outputs carry video plus pcm_s16le audio [measured: B141K ffprobe]); a video without audio is INVALID (exit 1); if ffprobe cannot list streams the script only warns.
- On both pass and RED the script prints that the quality gate does NOT check license compliance: use of the output (region limit V.4, AI label A-12, commercial IV) is your responsibility, see `docs/LISANS_UYARISI.md` [design: tested with a fake engine; evidence kept by the authors, not in this repo].
- Do not tell a user that a passed gate means the video may be published. [design: `uret.ps1` has not been run against the real `sd-cli` yet; the `Handle`/`WaitForExit` exit-code race was not tested with the real engine, so nothing depends on the exit code alone; to be confirmed in a real run.]

## RTX 50 series (Blackwell, compute capability 12.x)
Note: `kur.ps1` now selects the stock CUDA engine for this class (UNTRIED: no stock run on an RTX 50 card). The steps below describe the measured paths from the contributor's report (release engine first, then a local `sm_120` build); use them when the stock engine does not work, and report the result.
Reported by a contributor on an RTX 5060 Laptop 8 GB (@baadir, PRs #2 and #3) [user-reported, not measured by us: we have no RTX 50 card]: with the release engine (v0.1.0 zip, built only for `sm_61`) and the v0.1.0 script, videos of 56+ frames (and `-InitImg` at 22/39 frames) came out all black (NaN latent); `--flash-attn off`, chunk sizes, two-stage VAE, `GGML_CUDA_FORCE_*` and seed changes did not help.
- A native `sm_120` build (CUDA 12.8.1+, `-DCMAKE_CUDA_ARCHITECTURES=120`, same patches) passed all gates up to 209 frames (356 s, peak 7438/8151 MiB).
- Not tested yet: the release engine with the v0.1.1 script, which turns on `f32` cuBLAS for compute capability 7.0+ (RTX 50 included) and fixed the black video on an RTX 4070 Ti [user-reported, issue #1].
Agent steps on an RTX 50 machine:
1. Check `nvidia-smi --query-gpu=compute_cap --format=csv,noheader`. If it is 12.x, `uret.ps1` also prints a warning.
2. Try the release engine first with 56 frames (`-Kare 56`). If the gate passes and the video is not black, keep it.
3. If it is black, build natively: `docs/RTX5060_SM120_DERLEME.md` (VS 2022 Build Tools x64, CMake + Ninja, CUDA 12.8.1+, Git; ask the user before installing anything). Put the build in `engine\bin_sm120` and set `VT_ENGINE_BIN` to it (the MCP server picks that folder by itself). Run 56 frames again and check the gate.
4. Do not change quality settings to "fix" it. Test report: `docs/RTX5060_TEST_RAPORU.md`; please report the result of step 2 in an issue (it decides the root cause).
RTX 20/30/40 cards (7.x-8.x): one RTX 4070 Ti ran the release engine with the `f32` setting (automatic since v0.1.1) without a new build [user-reported, issue #1, one card]; other models in these series are not tested. Per-card results: `docs/KART_PROFILLERI.md`.

## MCP server (optional)
`mcp/videoturko_mcp.py` is a local stdio MCP server contributed in PR #2: it lets an agent start a run (`generate_video`), follow it (`job_status`), cancel it and list jobs, without reading the repository each time. It calls `scripts\uret.ps1` with the fixed quality settings and reports a job as `done` only when the script exit code is 0 (5 = `rejected` by the gate, 6 = gate could not run). Setup and tools: `mcp/README.md`. [read and tested by us with a fake `uret.ps1` only; real runs user-reported on an RTX 5060]
**`init_image` is only a file path the user gave you.** Never pick a file yourself: by default (`VT_MCP_INIT_DIR` unset, unchanged behaviour) the server accepts any file it can read and the engine puts it inside the video.
- Setting `VT_MCP_INIT_DIR` (a folder, or several separated by `;`; `VT_MCP_INIT_DIR=girdi` means only `<ROOT>/girdi/`) restricts it to `<ROOT>/girdi/` plus the listed folders: `..`, symlinks and junctions below the allowed folder, `:` stream names, UNC and drive-relative paths are refused; `status()` reports the mode in its `init_image` field.
- `VT_MCP_ALLOW_INIT=0` still turns `init_image` off completely. Limit [read, tested with temp folders and a stub server]: the check happens before the engine opens the file, so only let trusted people write into the allowed folder.

## Where things are
`patches/` (list in `docs/YAMALAR.md`), `scripts/`, `docs/KURULUM.md` (build from source), `docs/KANITLAR.md` (evidence, model sha256), `docs/KAPILAR.md` (gates), `docs/OLCUMLER.md` (measurements), `docs/ISTEM_YAZIMI.md` (prompt writing), `docs/ARASTIRMA.md` (background, rejected patches, lessons), `docs/KART_PROFILLERI.md` (per-card results), `docs/RTX5060_SM120_DERLEME.md` and `docs/RTX5060_TEST_RAPORU.md` (RTX 50 build and report), `docs/KLIP_ZINCIRI.md` (clip chaining), `mcp/README.md` (MCP server), `AGENTS_HIZLI.md` (quick card), `llms.txt` (index), `docs/hata_imzalari.json` (error codes).
