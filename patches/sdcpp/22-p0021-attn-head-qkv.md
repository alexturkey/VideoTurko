# 0021

Attention q/k/v are projected per head group (row views of the projection weight) instead of for all heads at once, so the q/k/v working buffers shrink

- Env flag: SD_ATTN_HEAD_QKV=1 (stage 1 only; optional helpers read by the same code: SD_ATTN_SET_OUT, SD_QKV_CHUNK_MB)
- Evidence [measured, authors, GTX 1050 Ti 4 GB]: 56 frames, flag on and off: same latent (120c0ace...) and video (0979f156...); sampling 433.1 s vs 432.9 s. 209 frames with the flag: latent byte equal (1bacb4bf...), compute buffer peak 1520.37 MB (-696.5 MB), card VRAM peak 3749 vs 3769 MiB, steps +2.8 %; so at 209 frames it is no speed or memory gain and is not used there. 832x480, 124 frames: flag on vs off, same latent (72b6fdd3...), DiT compute buffer 2104.43 -> 1458.78 MB. 640x384, 260 frames: needs the flag (without it the sampling stops at the first block gate, 76 MB short); the output is reproducible (same latent 1e93df16... in two independent runs) but has no flag-off reference. 832x480, 141 frames and 896x512, 124 frames: sampling only fits with the flag (no flag-off reference either).
- Limits: 260 frames runs close to the limit (card VRAM peak 3903 of 4096 MiB, shared GPU memory growth +45 / +61 MiB against a +68 limit). SD_ATTN_HEAD_QKV=1 together with SD_BLOCK_TAIL_FUSE=1 at 260 frames fails (3rd block); use the flag alone. 226 and 243 frames with the flag were not run end to end.
- Default: OFF (no env set = stock behaviour)
- Base: upstream stable-diffusion.cpp 32d516c + 01-taban-hiz-yamalari, applied in series order.
