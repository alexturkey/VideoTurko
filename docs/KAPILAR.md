# Quality gates / Kalite kapilari

Labels: [measured] = read from a run log or a script output; [computed] = derived from measurements; [guess] = not yet validated (older text: [proposal]).
Etiketler: [olctum] = kayittan/betik ciktisindan; [hesap] = olcumlerden turetilmis; [tahmin] = dogrulanmamis (eski yazim: [oneri]).

A result is accepted only if every gate below passes. Thresholds are fixed and are never loosened to make a clip pass. On RED the decision is the user's; on GECTI the decision is also the viewer's (watch the clip).
Bir sonuc ancak asagidaki tum kapilar gecerse kabul edilir. Esikler bir klibi gecirmek icin gevsetilmez; RED'de karar kullanicindir.

## 1. Run gate (log) / Kosu kapisi (kayit)
- Fails if the logs contain `temporal tiling`, `retrying with` or `vae decode compute failed`: a tiled/fallback VAE output is not the reference and is discarded (re-decode the saved latent in a separate process without tiling).
- No memory fallback or ALLOC_FAILED lines. `CAPACITY ... SHORT` lines mean the engine waited; they are fine only if the run then completes.
- Note: a queue status "done / exit 0" can be a false green. Always check the raw log for `[E]` or `sampling failed`.

## 2. Quality gate (`scripts/uretim_kapi.ps1 -Dizin -Ad -Kare`) / Kalite kapisi
RED if any of: frame count differs from `-Kare`; raw noise > 1.5; mean optical flow <= 0.05; log signature from gate 1. Also writes a 12-frame contact sheet. The contact sheet needs ffmpeg (`VT_FFMPEG` or `PATH`; `engine\bin` only if you put it there, the release does not ship it); without it the sheet is skipped with an info line and the verdict is unchanged. The texture-normalised N (section 3) is printed by default from v0.1.1 as information only. If Python or OpenCV/numpy is missing (including the Windows Store `python.exe` alias, exit 9009) the gate does not run: exit 6 `KAPI CALISMADI` (not RED); `uret.ps1` checks this before the GPU job and makes no video. Thresholds are calibrated at 640x384 only: the same clip (F209V2) upscaled to 1280x768 read raw noise 0.32 instead of 1.08 and N 0.020 instead of 0.048 [measured: team test 2026-11-20, the F209V2 clip rescaled; evidence kept by the authors, not in this repo]; at other sizes (`-W/-H`) a pass is weaker evidence, watch the clip. / Pafta icin ffmpeg gerekir, yoksa uyari ile atlanir, karar degismez. Python ya da OpenCV yoksa (Windows Store kisayolu 9009 dahil) kapi calismaz: cikis 6 (RED degil); `uret.ps1` bunu GPU isinden once denetler, video uretmez. Esikler yalniz 640x384'te kalibre.
- Raw noise = mean |x - medianBlur3x3(x)| on gray frames (every 8th, single frame, no motion compensation). It correlates with local sharpness, so a texture-rich scene can read higher without being degraded [measured: see section 3].
- A textured nature scene (river rapids and forest) at 260 frames (`-Profil uzun260`) was rejected on the raw-noise threshold alone (2.04 against 1.5) while it looked clean; the threshold is not changed, the owner decides, as the gate's own note allows [measured: third full 260-frame run, 2026-11, GTX 1050 Ti].

## 3. Texture-normalised noise N (`scripts/doku_norm.py`, optional extra) / Doku-normalize N
N = median residual / mean Sobel gradient (Gaussian sigma 1), every 6th frame. One version only (this repo's). Proposed extra threshold N <= 0.065 [guess]; it never replaces gate 2, it only helps explain a RED ("scene texture" vs "degradation").

Same 10 clips, this repo's version [measured]:

| Clip | Frames | Raw noise | Texture | N |
|---|---|---|---|---|
| P1_90 | 90 | 0.91 | 20.3 | 0.045 |
| P3_124 | 124 | 0.98 | 21.5 | 0.046 |
| P5_141 | 141 | 0.85 | 20.9 | 0.041 |
| P8_141 | 141 | 0.95 | 21.3 | 0.044 |
| F158 | 158 | 0.82 | 19.9 | 0.041 |
| F175 | 175 | 1.21 | 24.8 | 0.048 |
| F192 | 192 | 1.29 | 25.6 | 0.049 |
| F209V2 | 209 | 1.06 | 22.0 | 0.048 |
| Z2_90 | 90 | 0.64 | 18.5 | 0.034 |
| Z3_175 | 175 | 1.87 (RED) | 35.8 | 0.052 |

Reading: Z3_175 fails the raw gate (1.87) but has the highest texture (35.8) and N 0.052, in the same band as the clean clips (0.034-0.052): consistent with scene texture, not proof of no degradation. The last-quarter N of F192 and F209V2 is 0.062 (close to 0.065).
Scale warning: another implementation (Sobel without the pre-blur, ksize 3) measured the same clips at 0.028-0.036. Thresholds are NOT interchangeable between implementations; use only this repo's `doku_norm.py`. Very fine texture (grass rows) gave clean N 0.075, so the threshold is per scene family (clean floor + 25%).

## 3b. Seam gate (chained parts) / Dikis kapisi (`scripts/dikis_denetim.py`)
Flow-speed ratio between the end of part A and the start of part B in 0.7-1.4; direction cosine > 0.8; the init image must be the real last frame (index frames-1).

## 4. Byte gate (`scripts/bayt_kiyas.py base.avi candidate.avi`) / Bayt kapisi
Tiers: file sha256, then per-frame md5 and audio md5, then (only if they differ) PSNR/SSIM/SNR. Verdict `BAYT_AYNI` (exit 0) or RED (exit 1); `PSNR_ADAY` (every frame >= 50 dB and audio SNR >= 50 dB) needs a manager's approval. Byte identity is proven ONLY at 56 and 141 frames against the unpatched reference; longer runs rely on gates 1-3 (the unpatched build cannot run them on this GPU).

## 4b. Motion consistency over time / Zaman icinde hareket tutarliligi
This gate does not check motion consistency (object scale or position jumps): watch the whole video before accepting it. / Bu kapi hareket tutarliligini (nesne olcegi/konum sicramasi) denetlemez: kabul etmeden once videonun tamamini izleyin.
The numeric gates do not measure whether the subject stays consistent over time. Watch the whole clip; passing the gates is not a guarantee of a good clip [measured: eye check]. A short-window motion-consistency check is a [guess]: not built, not tested. / Sayisal kapilar konunun zaman icinde tutarliligini olcmez. Klibin tamamini izleyin; kapidan gecmek iyi klip garantisi degildir [olctum: goz ile kontrol]. Kisa pencereli hareket tutarliligi kontrolu bir [tahmin]: yazilmadi, denenmedi.

## 5. Order / Sira
Byte gate (if a reference exists) -> run gate -> quality gate -> optional N -> only then send or publish the clip.
