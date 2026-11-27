# 0023

After every unload has been tried, a small CUDA shortfall is accepted and logged instead of falling back (last resort for the VAE decode of the longest clip)

- Env flag: SD_VRAM_SHORT_OK_MB=<N> (megabytes; the only tested value is 32, stage 2 only, together with SD_VRAM_MARGIN_MB=1 and SD_VAE_VRAM_MARGIN_MB=1)
- Log line when it acts: `SD_VRAM_SHORT_OK_MB: accepting device shortfall ...`
- Scope: conditional and experimental. Accepted only for the 640x384, 260-frame untiled VAE decode, with the shortfall observed there (8.33 MB, line logged twice). It is not part of any 832x480 or 896x512 recipe and was not accepted there.
- Evidence [measured, authors, GTX 1050 Ti 4 GB]: 56 / 209 / 243-frame byte gates equal to the flag-off outputs (video 0979f156..., d512de13..., 07dbf9c6...); 260 frames decoded untiled, video 6a8ba11a... in two separate runs (shared memory growth +61 MiB against the +68 limit in the production-path run).
- Not measured: any N other than 32; any shortfall larger than 8.33 MB.
- Default: OFF (no env set = stock behaviour)
- Base: upstream stable-diffusion.cpp 32d516c + 01-taban-hiz-yamalari, applied in series order (after 0021). One file, +20 lines: src/core/execution_engine.cpp.
