# Olcumler: bellek, sure ve kare tavani (Measurements)

GTX 1050 Ti 4 GB, 16 GB RAM, MiniMax H3 (33B DiT; HyperFlow Flash 13.7B Q4_K_M GGUF kosuyoruz; 32B Qwen3-VL metin kodlayici ayri), 640x384, 6 adim, tohum 42, stable-diffusion.cpp + bellek yamalari.
Etiketler: olctum = koşu kaydindan okundu (etiketin icinde kosu kimligi ve dosya yazilidir); [hesap] = olcumlerden turetildi; [tahmin] = dogrulanmadi.
Not: etiketlerdeki kosu kimlikleri ve dosya adlari (F209V2, ham_out_*.txt, ozet_*.txt) bizim yerel kosu kayitlarimizdir ve bu repoda DAGITILMAZ; okur onlari yeniden uretmek icin ayni tarifi kosar, ya da sayilari 'bizim makinede olculdu' olarak okur.
"Bayt ayni" iddiasi YALNIZ 56 ve 141 karelik kosularda kanitlidir (referansa karsi dosya/kare sha256). Daha uzun kosularda kanit gorsel/gurultu kapisidir, bayt kiyasi degildir.

## 0. Hangi ikiliyle olculdu
- 209 kare satirlari (F209b, F209V2, F209V2K): yama 0001-0018, `...-21-g248019c`, `stable-diffusion.dll` sha256 `1af9d546b6038170417c42679b8b6400588e721445ce556d107b4291e1fdba9a` [olctum: ham_out basligi + sha256 hesabi]. 158 ve altinda daha eski ikililer (olcum aninda kayitli sha yok).
- Dagitilacak release ikilisi temiz kokten YENIDEN derlendi: ayni kaynak icerigi ama ikili birebir degil (`stable-diffusion.dll` sha256 `e5d3d329541c5516618a941e41dabf84520532d8272925d4ae57a86e08f44760` [olctum sha256]); bu tablodaki sayilar ona bayt/kosu olarak TASINMAZ. Release ikilisi 56 karede R0 ile BAYT AYNI: avi sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`, kare md5 ve ses ayni; dogrudan sd-cli, bayraksiz, cikis 0, 601 sn [olctum B56VT2, 2026-11-19]. Sure disinda VRAM tepe bu kosuda olculmedi. 209 kare: release ikilisi uret.ps1 yoluyla koştu (U209, 2026-11-20): TAMAM 3414 sn (kilit calisma 3416 sn), 209 kare (ffprobe), ses akisi var, KAPI GECTI; VRAM tepe 3777/4096 MiB (nvidia-smi 5 sn ornek, bos 319 MiB); sampling 2730,42 sn (adim 470,6/482,5/437,3/437,9/462,6/436,1 sn); asama 2 (ayri surec, karosuz) VAE decode 172,99 sn, toplam 192,99 sn (ses cozme 19,6 sn dahil) [olctum U209/t_u209.log, ham_out_u209_a1.txt, ham_out_u209_a2.txt]. Asama 1'de surec ici VAE bellek yetmeyip karoluya dustu (320,5 sn); o cikti atilir, video asama 2'den gelir [olctum ham_out_u209_a1.txt]. RAM tepe olculmedi. Gelistirme derlemesi 209 kosusuyla kiyas [olctum kiyas_f209v2.json; kosu kayitlarimizda, dagitilmiyor]: latent bayt-ayni (sha 551061ec682efaba...); videoda 209 kare md5 ve ses md5 ayni (karar BAYT_AYNI, kare duzeyinde), AVI dosya sha256 farkli (c2048bb9... gelistirme, f05fb95b... release; konteyner/meta farki); 141 latent zinciri tekrarlanmadi [denenmedi].

## 1. Kare tavani tablosu (DiT tek gecis)

| Kare | Sure (video) | VRAM tepe | Sicak adim | DiT tampon | Kapi (gurultu) | Gecerlilik |
|---|---|---|---|---|---|---|
| 141 | 5,9 sn (141/24, hesap) | 3521 MiB [olctum P5_141 ozet] | kayittan cikarilmadi | - | gecti 0,85 | gecerli; bayt ayni [olctum] |
| 158 | 6,6 sn (158/24, hesap) | 3579 MiB [olctum F158] | 283,2 sn | 1733,4 MB | gecti 0,82 | gecerli |
| 175 | 7,3 sn | 3671 MiB [olctum F175] | 329,5 sn (adim 2-6 ortalamasi, turetilmis [hesap]) | 1892,6 MB | gecti 1,19 | gecerli (toplam 2293 sn, VAE ayni surec 153,6 sn) [olctum F175/ham_out_f175.txt] |
| 192 | 8,0 sn (192/24, hesap) | 3701 MiB [olctum F192] | 381,3 sn | 2064,6 MB | gecti 1,28 (F192Vp) | DiT gecerli; ayni-surec VAE karolu geri dususe girdi => F192 videosu GECERSIZ; gecerli cikti ayri surec VAE (F192Vp: karosuz, decode 152,8 sn, tepe 3487 MiB) [olctum F192Vp/ham_out_f192vp.txt] [olctum F192Vp/ozet_f192vp.txt] |
| 209 | 8,7 sn | 3777 MiB [olctum F209b] | 435,4 sn (adim 3-6 ortalamasi, turetilmis [hesap]) | 2223,2 MB | gecti 1,08 (F209V2) | F209b GECERSIZ (sure tavaninda VAE sirasinda kesildi, karolu dususe girdi); latent gecerli, gecerli cikti ayri surec VAE (F209V2: tepe 3281 MiB, decode 173,5 sn) [olctum F209V2/ham_out_f209v2.txt] [olctum F209V2/ozet_f209v2.txt] |

Notlar:
- Soguk ilk iki adim sicaktan ~+25..+30 sn yavas [olctum F192/ham_out_f192.txt] [olctum F209b/ham_out_f209b.txt]. Metin kodlama ~99 sn (baslangic-kareli kosuda ~186 sn [olctum Z3_175/ham_out_z3_175.txt]).
- RSS ~11 GB sabit (mmap), sinirlayici degil [olctum].
- Motor sureci RSS ~11 GB; bu yuzden 16 GB makinede ~11 GB bos RAM gerekir; baska buyuk uygulama acik olursa pay biter [olctum].
- Ekran yuku: VRAM sayilari tum-GPU `nvidia-smi --query-gpu=memory.used` degeridir (surec basina degil). F209b kosusunda ekran durumu kayitli degil; ekran bu karta baglanirsa pay daralir [tahmin].
- 209 karede yeni sahne (S1_209) DiT 3783 MiB, adim 435,6 sn; kapisi RED 2,37 (akis 0,58): bellek nedeni degil, sahne icerigi/kapi olcusu [olctum; neden: tahmin].
- 175 karelik ikinci parca (baslangic kareli, Z3_175): 3833 MiB, adim 349,2 sn, tampon 2206,6 MB (MLP_SET_OUT acik), kapi RED 1,86. Ayni sahnenin S2_175c kosusu 1,16 ile gecti. RED'in bellek yolundan gelmedigi hesapla beklenir (yamalar hesap sirasini degistirmez) ama 175'te bayt kiyasi yapilmadi [hesap].

## 2. Gecersiz kosular (acik)
- F192 ve F209b: ayni surecte VAE "retrying with temporal tiling"e dustu. Karolu/yaklasik VAE kabul edilmez; video atildi. Cozum: DiT latent'i kaydet, VAE'yi ayri surecte karosuz coz.
- S2_175b: 3,8 GB koruma esigi (3917 MiB) ile kesildi; yarim, gecersiz.

## 3. MLP_SET_OUT bellegi ARTIRIR
`SD_MLP_SET_OUT=1`, MLP parca ciktilarini N x 5376 f32'lik tek onceden ayrilmis tensore yazar; bu op'suz tensor grafik boyunca canli kalir ve dikkat fazi zirvesine ek biner. Boyut N x 21,5 KB: 209'da +341,7 MB [hesap, kod]. Olcumle uyumlu: ayni kare/bayrak karsilastirmalarinda tampon farki +314 MB [hesap: fark] (175) ve +320 MB [hesap: fark] (209) (iki olcumun farki; olcumler: [olctum Z3_175/ham_out_z3_175.txt] [olctum F175/ham_out_f175.txt] [olctum G209c/ham_out_g209c.txt]). Varsayilan KAPALI kalmali. Bayt kapisi (56 kare) gecmis olsa da bellek icin kullanma.

## 4. Kanitli tavan
- Kanitli tavan: 209 kare (8,71 sn) = DiT tek gecis + ayri surec karosuz VAE.

## 5. Sure ve bellek modeli
- Jeton sayisi N = 240 x L + ses + metin; L = (F-5)/17 x 5 + 2. Olculen: 209 karede N=15889 [olctum G209c/ham_out_g209c.txt] (PEAKDUMP embed CONCAT satirlari).
- DiT tampon egimi 0,13-0,14 MB/jeton (158-209) [olctum]; VRAM tepe 17 kare basi +30..92 MiB [olctum].
- Sicak adim ~ (2 x 13,83e9 x N / 3,3e12 + 4 x 7168 x 47 x N^2 / 1,1e12) x 1,126 x ~0,945 sn [hesap; 13,83e9 = GGUF basligindan sayilan nicemlenmis parametre (model karti 13.7B); 1-5% icinde dogrulandi].
- Toplam ~ 16 + metin kodlama + 6 x adim + soguk (+27..40) + VAE + 7 sn. VAE ayri surec decode ~ 17 + 2,35 x L sn [olctum: 152,8 sn @192, 173,5 sn @209].
- Sinirlayici: blocks.0 kapi sayimi (bekleyen tampon + marj <= bos VRAM), sonra 4096 MiB.

## 6. TavanDk kurali
TavanDk >= tahmini toplam sure x 1,4. F209b icin varsayilan 50 dk yetmedi (sampling 2664 sn + VAE); 209 icin >= 80 dk [tahmin]. Kopya satirda latent SAVE yolunu da degistir.

## 7. Dipnot: kalite kapisi kapsam disi iki sahne
"Kalite kapilarindan gecti" ifadesi bu iki sahneyi KAPSAMAZ:
1. S1_209V (209 kare, yeni sahne): ham gurultu olcusu 2,37, kapi RED. Doku-normalize olcu N 0,075 (yazarlarin olcegi); gozle temiz, neden sahne dokusu [tahmin]. Gurultu 2,37 [olctum S1_209V]; N 0,075 degeri yazarlarin olcusunden alindi, ham log yok [kaynak kaybolmus/tahmin].
2. Z3_175 (175 kare, baslangic kareli ikinci parca): ham gurultu 1,86, kapi RED. Doku-normalize N 0,052 / 0,036 (olcu surumune gore); ayni sahne dokusu [olctum; neden: tahmin].
3. 209 kare icin dayanak F209V2K (ayri surec VAE, gurultu 1,08, kapi gecti).
Bu RED'lerin bellek/kirpma yolundan gelmedigi hesapla beklenir (yamalar hesap sirasini degistirmez), ama bayt kiyasi yalniz 56 ve 141 karede vardir, 158-209'da yoktur [tahmin].

## 8. Dis rapor: RTX 4070 Ti 12 GB (issue #1) — BIZIM OLCUMUMUZ DEGIL / external report, NOT our measurement

Kaynak: https://github.com/alexturkey/VideoTurko/issues/1 (@SinanC73, 2026-11-20). Asagidaki sayilar o makinede o kisi tarafindan olculdu; biz tekrar etmedik. Etiket: [kullanici bildirdi, #1]. Ayrintili ve elemeli rapor icin @SinanC73'e tesekkurler.
Source: the issue above. Numbers were measured by the reporter on their machine; we did not repeat them. Thanks to @SinanC73 for a detailed report with elimination tests.

Makine: Windows 11, RTX 4070 Ti 12 GB (12282 MiB), surucu 621.01, compute capability 8.9. Kurulum `kur.ps1` sorunsuz, 5 kare kontrol 41 sn; v0.1.0 sm_61 motor zip'i bu kartta calisti. Denemeler betigin kendi kopyasinda yapildi (`-W/-H`, `-EndImg`, `-TekAsama` o kopyada; v0.1.1'deki parametreler bizim uygulamamizdir).

| Kosu | Boyut | Kare | Asama | DiT | VAE | VRAM tepe (tum kart) | Kapi |
|---|---|---|---|---|---|---|---|
| T2V, f32 yok | 384x640 | 141 | 1 ve 2 | 211,8 sn | - | - | video SIYAH (NaN) |
| T2V, `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` | 384x640 | 141 | 1 | 209,9 sn | - | 11,4 GB | RED gurultu 1,76 (dokulu col sahnesi; orta akis 0,08) |
| init | 384x640 | 56 | 1 | 65 sn | - | olculmedi | GECTI |
| init + end (FLF) | 480x832 | 56 | 1 | 165 sn | - | 11,6 GB | GECTI 0,47 |
| init + end | 576x1024 | 56 | 1 | 275 sn | - | 11,5 GB | GECTI 0,41 |
| init + end | 720x1280 (motor 736'ya yuvarlar [okudum]) | 56 | 1 | 557 sn | - | 11,6 GB | GECTI 0,32 |
| init + end | 720x1280 | 107 | 1 | - | - | - | dustu: blok 8 agirlik hazirliginda ~184 MB eksik (1024 MB guvenlik payi) |
| init + end | 720x1280 | 107 | 2 (`SD_VRAM_MARGIN_MB=1`) | 1470 sn | 42 sn | 11,9 GB | GECTI 0,39 |
| init + end (FLF), f32 | 384x640 | 141 | - | - | - | - | GECTI 0,62 (orta akis 0,27) |

Okuma notlari (bizim):
- Siyah videonun eleme tablosu (iki asama/tek asama, init yok, yatay boyut, flash-attention kapali, chunk butcesi 0,2: hepsi siyah; yalniz f32 ile duzeldi) issue'da. Kok neden icin iki aday var: `docs/SIK_HATALAR.md` 19.
- Buyuk boyutlarda gurultunun dusuk okunmasi beklenir: esikler 640x384'te kalibre (`docs/KAPILAR.md` §2). Bu tablodaki GECTI'ler 640x384 tablolariyla dogrudan karsilastirilamaz.
- `--offload-to-cpu` buyuk kartta da karti doldurur; 11-12 GB tepe "bellek yetmedi" anlamina gelmez.
- 22 karelik yatay init kosusunda "workspace capacity check" hatasi bildirildi (tek deneme, log yok); acik.
- GTX 1050 Ti'de v0.1.1 dogrulamasi (bizim olcumumuz): asagida §9.

## 9. v0.1.1 dogrulamasi: GTX 1050 Ti 4 GB (BIZIM OLCUMUMUZ, 2026-11-20)
Motor: release v0.1.0 ikilisi (degismedi); betikler v0.1.1; temiz test koku; GPU kilidiyle tek tek. Kanit kayitlari yazarlarda, repoda dagitilmaz.

| Kosu | Ayar | Sonuc | Sure | VRAM tepe (tum kart) |
|---|---|---|---|---|
| R0 56 kare (`docs/ornek_istem_R0.txt`, tohum 42) | yeni `uret.ps1` (`--flash-attn off,diffusion=on`), tek asama | BAYT AYNI: avi sha256 `0979f156...` = R0, 56/56 kare md5 ve ses md5 ayni, KAPI GECTI [olctum] | 641 sn | - |
| FLF 56 kare (`-InitImg` + `-EndImg`) | tek asama (jeton 4080) | DUSTU: segment 5/51 agirlik hazirliginda VRAM yetmedi [olctum] | 294 sn | - |
| FLF 192 kare | iki asama | DUSTU: segment 5/52 agirlik hazirligi, 459 sn sonra [olctum] | 740 sn | - |
| FLF 56 kare | iki asama (4 GB'ta zorunlu) | TAMAM, 56 kare + ses, KAPI GECTI (gurultu 0,59, orta akis 1,78), pafta gozle tutarli [olctum] | 1040 sn | 3597 / 4096 MiB |
| FLF 175 kare | iki asama | TAMAM, 175 kare + ses, KAPI GECTI (gurultu 0,75, orta akis 2,49), pafta gozle tutarli [olctum] | 2887 sn (48 dk) | 3721 / 4096 MiB |

Karar: 8 GB alti kartta (6 GB dahil; ya da VRAM okunamazsa) `-EndImg` verilince her zaman iki asama ve kare tavani 175 (192 sigmadi); `-Kare` verilmezse 175. 8 GB ve ustu kartta `-EndImg` tavani 192 (olculmedi; 6 GB kartin tek asamada sigdigina veri yok). Yalniz `-InitImg` ile tavan 192 degismez.
Girdi kareleri: U209 videosunun 0., 55. ve 174. kareleri (FLF 56: 0 -> 55, FLF 175: 0 -> 174); istem U209 istemi.
`GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` bu kartta (6.1) varsayilan KAPALI ve zorla kosulmadi: kod okumasina gore cuBLAS yolu sm61'de f32 hesapliyor, ama bf16 condition_proj yolu degisebilecegi icin kapali tutuldu [okudum; etkisi: denenmedi].
Olculmeyen: `-EndImg` tek basina (`-InitImg` olmadan); FLF 8 GB ve ustu kartta (12 GB'ta 141 kare FLF gecti: §8, dis rapor).

## 10. Speed pack: optional high-resolution and long cells (OUR MEASUREMENT, GTX 1050 Ti 4 GB, 2026-11-25 to 27)
Patches 0021, 0023 and 0024 (`docs/YAMALAR.md`), all off by default. Same quality settings (6 steps, cfg 1, tile-less VAE, seed 42). Times are the whole run (two processes). One machine, two prompts per cell unless noted [measured].

| Cell | Length | Stage 1 flag | Stage 2 flag | Total time | Note |
|---|---|---|---|---|---|
| 640x384 x 209 (default) | 8.7 s | none | none | 3414 s | verified, unchanged |
| 832x480 x 124 | 5.2 s | none | none | 45-46 min | plain engine |
| 832x480 x 141 | 5.9 s | `SD_ATTN_HEAD_QKV=1` | `SD_VAE_BLOCK_SPLIT=2` | 55-56 min | headroom at the sampling memory gate 5.7 and 6.8 MB (two full runs) |
| 896x512 x 124 | 5.2 s | `SD_ATTN_HEAD_QKV=1` | `SD_VAE_BLOCK_SPLIT=2` | 56-57.5 min | |
| 640x384 x 260 | 10.8 s | `SD_ATTN_HEAD_QKV=1` | `SD_VRAM_SHORT_OK_MB=32` (+ margins 1) | 70.7 min with the early exit (78.4 without) | VRAM peak 3861-3903 / 4096 MiB; three full runs, shared memory +45 / +61 MiB (system-wide counter) and +28 MiB (process share), limit +68; prompt up to 1403 characters in full runs, 2009 by gate reading (2527 exceeded the limit); runs close to the memory limit |

- Long prompts at 832x480 x 141: 1520 and 2041 characters were checked by reading the memory gate only (all of step 1 and the first two blocks of step 2, no full run): no failed gate, headroom 10.9 and 4.0 MB. Not a full-run result.
- 832x480 at 158 frames does not fit with the shipped patches: it dies at the step-2 gate (need 2475.5 MB, available 2195.3 MB, about 280 MB short). The one 158-frame result that passed used an extra patch that is not shipped and was not accepted. 175 frames was only gate-read (about 275 MB short at the first block, no full run). Not offered; the profile is 141 frames only.
- Byte checks: with the flags on, 56 / 209 / 243 frames at 640x384 and 832x480 x 124 are byte-identical to the flag-off result; the 260-frame decode is repeatable (two runs, same video) but has no flag-off reference. At 832x480 x 141 and 896x512 x 124 the flag-off run does not fit, so a direct comparison is impossible.
- The `uret.ps1 -Profil` wiring and the engine zip were checked by dry run and an install test; no new GPU run was made for them.
