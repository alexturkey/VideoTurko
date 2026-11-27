# Patches (YAMALAR)

All patches are default OFF: with no env flag set the program behaves like the base. Rule: trimming never touches quality: every patch had to give byte-identical output to the reference (56 frames, sha256 0979f156...; plus 141 frames) before it was accepted. Tiled/approximate VAE, fewer steps, lower cfg or resolution are not used.

Base: upstream stable-diffusion.cpp 32d516c (master-1088) + `01-taban-hiz-yamalari`; ggml d803c238 + `ggml/01-ggml-taban`. Order: `SERIES.txt`.

| Patch | What it does | Env flag | Evidence | Status |
|---|---|---|---|---|
| taban | Base: earlier speed patches on top of upstream 32d516c (K-17 starting state) | - | Reference state for all gates (R0) | base state |
| 0001 | Save/load the sampled video latent so the VAE can run in a separate process | SD_VIDEO_LATENT_SAVE=<file>, SD_VIDEO_LATENT_LOAD=<file> | Bit-exact float32 round trip; F192V/F209V2 used it (video + audio latent stored) | tool/measurement (no arithmetic) |
| 0002 | Upstream stable-diffusion.cpp PR #2369 (H3 VAE encoder padding), encode path only. NOT ours: attribution to the PR author; kept because later patches apply on top of it | - | Upstream change, not measured here | upstream (PR #2369), not ours |
| 0003 | Model-loader polling sleep split into 5 ms slices | - | Byte-identical output, timing only | tool/measurement (no arithmetic) |
| 0004 | Ask the OS to read the mmap-ed model ahead (PrefetchVirtualMemory) | SD_PREFETCH_MMAP_MATCH=<substring of model file name> | Order of reads only; bytes unchanged | tool/measurement (no arithmetic) |
| 0006 | Cap the MLP token chunk so fc1/swiglu intermediates stay small | SD_MLP_CHUNK_MB=<MB> | B56C3/B56M4: 56 frames byte-identical to R0 | byte-identical gate passed |
| 0006b | Chunked QKV projection. ALONE it raises the peak by +121.5 MB (copies + concat): use together with SD_QKV_SET_OUT (0014) | SD_QKV_CHUNK_MB=<MB> | Measured +121.5 MB alone; byte gate together with 0014 (B141K) | byte-identical gate passed |
| 0006c | Equal-sized chunks when the env cap is set (no tiny tail chunk: small batches may pick another matmul kernel) | (with SD_MLP_CHUNK_MB) | Same binary as the 0006 gates (committed before DERLEME4, which carried B56M4k/B56C3); evidence is shared with 0006, not a separate gate | byte-identical gate passed (with 0006) |
| 0007 | Graph-cut tensors of at least N MB captured into host RAM instead of VRAM (pure copy) | SD_CUT_CACHE_HOST_MB=<MB> | B56H9k R0; F209V2K/F141Vh2K byte-identical (with 0017) | byte-identical gate passed |
| 0009 | Own graph segment after the input embedding (DiT) | SD_H3_EMBED_CUT=1 | B56H4: sha 0979f156 = R0 | byte-identical gate passed |
| 0010 | Drop the queued weight prefetch when the capacity gate fails | SD_H3_DROP_QUEUED=1 | B56H4: sha 0979f156 = R0 (placement only) | byte-identical gate passed |
| 0011 | Evict earlier segments weights when the capacity gate fails | SD_H3_EVICT_PAST=1 | B56H4: sha 0979f156 = R0 (placement only) | byte-identical gate passed |
| 0012 | Offline liveness estimate per segment graph (diagnostic; the real compute buffer was about 2x the estimate) | SD_PEAK_DUMP=<segment N> | No arithmetic; diagnostic output only | tool/measurement (no arithmetic) |
| 0013 | Attention head-group outputs written into one preallocated tensor (set_inplace, pure copy) | SD_ATTN_SET_OUT=1 | B141K: sha E5D028F8632BE4FE = P5_141 reference (with 0014/0006) | byte-identical gate passed |
| 0014 | Chunked q/k/v written into preallocated tensors (set_inplace, pure copy) | SD_QKV_SET_OUT=1 (+ SD_QKV_CHUNK_MB) | B141K: sha E5D028F8632BE4FE | byte-identical gate passed |
| 0015 | MLP chunk outputs written into one destination (set_inplace, pure copy) | SD_MLP_SET_OUT=1 | B56H9k, B56H10b, B56H11: 56 frames sha256 0979f156... = R0. Alone raised memory (+320 MB @209): destination was a graph-start leaf, fixed by 0020 | byte-identical gate passed (56 frames) |
| 0016 | Never fall back to tiled (approximate) VAE decode; return the error instead | SD_VAE_NO_TILING_FALLBACK=1 | Used in F209V2 (tiling 0); error return only | byte-identical gate passed |
| 0017 | Capacity estimate no longer counts cut tensors that go to host RAM (with 0007) | SD_CUT_CACHE_HOST_MB=<MB> | F209V2K/F141Vh2K byte-identical; estimate only | byte-identical gate passed |
| 0018 | Own graph segment for the VAE embedding + register concat | SD_VAE_EMBED_CUT=1 | F209V2K: 209 frames, tiling 0, byte gates passed | byte-identical gate passed |
| 0019 | Per-chunk block tail (out_proj + residual + norm2 + MLP + gated residual) into one destination | SD_BLOCK_TAIL_FUSE=1 | B56H11: 56 frames sha256 0979f156... = R0 (with MLP_SET_OUT). No byte reference at 141+ frames; effect not visible in the log | byte-identical gate passed (56 frames) |
| 0020 | 0015/0019 destination created by ggml_pad of the first chunk (op, not a graph-start leaf) | (with SD_MLP_SET_OUT / SD_BLOCK_TAIL_FUSE) | B56H10b, B56H11: 0979f156... = R0; not used by the 209 run | byte-identical gate passed (56 frames) |
| 0021 | Attention q/k/v projected per head group instead of all heads at once (smaller working buffers); needed for 640x384 x 260, 832x480 x 141 and 896x512 x 124 (stage 1) | SD_ATTN_HEAD_QKV=1 | 56 and 209 frames byte-identical to the flag-off run, 832x480 x 124 same latent; 260, 141-frame and 896x512 sampling do not fit without it, so no flag-off reference there; at 209 frames it is slower (+2.8 %) and not used. Details: `patches/sdcpp/22-p0021-attn-head-qkv.md` | byte-identical gate passed up to 209 frames; experimental, off by default |
| 0023 | Accept a small CUDA shortfall (last resort) instead of falling back | SD_VRAM_SHORT_OK_MB=32 (stage 2) | 56 / 209 / 243 frames byte-identical; 640x384 x 260 untiled VAE, video 6a8ba11a... in two runs, shortfall 8.33 MB. Scope: 640x384 x 260 only | conditional, experimental, off by default; not used by the 832x480 / 896x512 cells |
| 0024 | Extra graph cuts inside each sol VAE decoder block (smaller VAE working buffer); enables the untiled decode of 832x480 x 141 and 896x512 x 124 | SD_VAE_BLOCK_SPLIT=2 (stage 2) | 11 of 11 decodes byte-identical to the flag-off video (640x384 at 56 / 209 / 260, 768x448 x 56, 832x480 x 124); the two high-resolution cells decode untiled only with it | byte-identical gate passed; opt-in profile, off by default |
| 0005 (ggml) | CUDA op timing table file | GGML_CUDA_OPTIME_FILE | measurement tool | tool/measurement |

## Notes
- 0006b (SD_QKV_CHUNK_MB) alone raises the memory peak by +121.5 MB: use it together with SD_QKV_SET_OUT (0014).
- 0015, 0019, 0020 are included: experimental, default off, not used by any recipe, byte-identical to R0 on 56 frames only (R0 sha256 0979f156...); 0019's effect is not visible in the log. / 0015, 0019, 0020 dahildir: deneysel, varsayilan kapali, hicbir tarifte kullanilmaz, yalniz 56 karede R0 ile bayt ayni.
- The PR #2369 patch is upstream work by its author; kept only because later patches apply on top of it.

## File name - patch no - upstream attribution
| File (patches/sdcpp/) | Patch no | Attribution / base |
|---|---|---|
| 01-taban-hiz-yamalari | base | ours; on upstream stable-diffusion.cpp 32d516c |
| 02-p0001-video-latent-save-load | 0001 | ours |
| 03-p0002-pr2369-h3-vae-encode | 0002 | upstream PR #2369 (not ours; author credit goes to the PR author) |
| 04-p0003-model-loader-sleep | 0003 | ours |
| 05-p0004-prefetch-mmap | 0004 | ours |
| 06-p0006-mlp-chunk | 0006 | ours |
| 07-p0006b-qkv-chunk | 0006b | ours |
| 08-p0006c-equal-chunks | 0006c | ours (same gates as 0006) |
| 09-p0007-cut-cache-host | 0007 | ours |
| 10-p0009-embed-cut | 0009 | ours |
| 11-p0010-drop-queued | 0010 | ours |
| 12-p0011-evict-past | 0011 | ours |
| 13-p0012-peak-dump | 0012 | ours |
| 14-p0013-attn-set-out | 0013 | ours |
| 15-p0014-qkv-set-out | 0014 | ours |
| 16-p0015-mlp-set-out | 0015 | ours |
| 17-p0016-vae-no-tiling-fallback | 0016 | ours |
| 18-p0017-cutcache-host-estimate | 0017 | ours |
| 19-p0018-vae-embed-cut | 0018 | ours |
| 20-p0019-block-tail-fuse | 0019 | ours |
| 21-p0020-lazy-destination | 0020 | ours |
| 22-p0021-attn-head-qkv | 0021 | ours |
| 24-p0023-vram-short-ok | 0023 | ours (file number 23 is not used: patch 0022 was tried and dropped) |
| 25-p0024-vae-block-split | 0024 | ours |
| ggml/01-ggml-taban, 02-p0005-optime-file, 03-p0005-optime-fix | 0005 (ggml) | ours; ggml d803c238 |
Number 0008 is not in the table (never written).

Note on `ggml/02-p0005-optime-file.patch` and `ggml/03-p0005-optime-fix.patch`: patch 02 contains a raw NUL byte where the C source should read the character literal for the end of a string (`path[0] == <NUL>` instead of `'\0'`); patch 03 corrects exactly that line, so the two files are consistent as a series. Git therefore treats them as binary files. They are kept byte-for-byte as we built and tested them (changing a patch file changes its hash); apply the series in order, 02 then 03. This affects only a diagnostic timing-table feature (0005, measurement tool), not the output.
