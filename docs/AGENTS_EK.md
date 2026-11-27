# AGENTS_EK.md: details moved out of AGENTS.md (for AI coding agents)

AGENTS.md stays under 32 KiB because some agents (Codex) silently cut a longer file. The rules that must never be missed stay in AGENTS.md; the long measured details live here. AGENTS.md wins if the two ever differ.

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
