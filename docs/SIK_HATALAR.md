# VideoTurko: Sik hatalar / Common pitfalls

Bu liste gercek kosulardan cikmistir (4 GB GTX 1050 Ti, stable-diffusion.cpp `sd-cli -M vid_gen`, MiniMax H3 HyperFlow Flash GGUF).
Her madde: **belirti**, **neden**, **kalici cozum**. Etiketler: [olctum] = bu projede olculdu, [okudum] = kodda/belgede goruldu, [tahmin] = dogrulanmadi.
This list comes from real runs. Each item: symptom, cause, lasting fix.

> **Otomatik motor / Automatic engine:** `kur.ps1` artik kart sinifini taniyip motoru kendisi secer ve kurar (stock stable-diffusion.cpp dahil); `-Kuru` secimi `Motor secimi:` satiriyla gosterir. Asagidaki maddelerdeki elle adimlar olculdugu gibi kalir. / `kur.ps1` now recognises the card class and picks and installs the engine itself (stock stable-diffusion.cpp included); `-Kuru` shows the choice on the `Motor secimi:` line. The manual steps in the items below stay as measured. Tablo / table: README "Which engine does my card get?".
> **Ajan ile kurulum / Agent-assisted install:** once `scripts\tani.ps1` calistirin (salt okur: sistem, kart, `kur.ps1 -Kuru`, varsayilandan SAPMA bolumu: Python surumleri, yerelde degismis dosyalar, `VT_*` ezmeleri, model dosyalari); sonucu bu listedeki kodlarla eslestirir. Ajaniniz ilerlemesini kokte `DURUM.md` dosyasinda tutsun, kalite ayarini dusurmesin, lisansi sizin yerinize kabul etmesin. / Run `scripts\tani.ps1` first (read-only; includes a DEVIATIONS section); it matches its output to the codes in this list. Your agent keeps its progress in `DURUM.md` in the root, must not lower a quality setting and must not accept the license for you.

## A. Bellek ve kapi (VRAM)

1. <a id="vt-e-vram"></a>**VRAM kapisi `blocks.0` agirlik hazirliginda dusuyor** (`segment 5/52 (blocks.0) failed during weight preparation`) [olctum]
   - Neden: yukleme kapisi `ihtiyac = bekleyen + eksik + marj`; kare sayisi buyudukce compute tamponu artar, tahliye yetmez.
   - Cozum: marj icin `SD_VRAM_MARGIN_MB=1` kullan. **`0` degeri "ayarsiz" sayilir ve 1024 MB'lik tuzaga duser** [okudum]. Kare tavani tablosu: `OLCUMLER.md`.
   - Linux `uret.sh` icin 1. asama payini bilincli yukseltmek istersen `VT_MARGIN_MB=<MB>` (1..4096; `0` reddedilir): **yalniz Linux `uret.sh`, yalniz iki asamali kosuda (209 kare gibi) ve yalniz 1. asamada** gecerli; `uret.ps1`de karsiligi yok, tek asamali kosuda etkisiz. Varsayilan 1 kalir (2. asama hep 256). RTX 3060 Laptop 6 GB Linux'ta 209 karede 1. asama `cudaMalloc failed: out of memory` ile dustu, 512 ile gecti [kullanici bildirdi, PR #31; 512 her iki asamada denendi, 512'nin yalniz 1. asamada yettigi ve 4 GB Linux kartta ne oldugu OLCULMEDI].
2. **`SD_CAPACITY_LOG` satirlari bir sonraki segmentin kapisini gosterir** (etiket kaymasi) [olctum]
   - `executing segment N` satirindan sonra yazilan CAPACITY satiri N+1'in kapisidir; olen kapiyi `segment K/52 (blocks.X) failed` satiri belirler.
3. **`SD_MLP_SET_OUT=1` bellegi azaltmaz, artirir** [okudum + olctum]
   - Hedef tensor "yaprak" oldugundan grafik basinda ayrilir ve tum blok boyunca canli kalir: 209 karede ~+342 MB (G209c'de +320 MB olculdu). Varsayilan kapali kalir; kanitli yama listesi `YAMALAR.md`.
4. **Bir yamanin tek basina kullanimi tepeyi buyutebilir**: `0006b` tek basina +121,5 MB; `SD_QKV_SET_OUT` ile birlikte kullan [olctum].
5. **Bellek tahmini yanlis girdiyle yapildi**: jeton sayisi N'yi formulle varsayma, logdaki `PEAK_DUMP` sekillerinden oku (209: N=15889); iki kosuyu karsilastirmadan once bayrak setini fark'la (ayni bayrak seti degilse "karsilastirilamaz" yaz) [olctum].

## B. VAE ve uretim

6. <a id="vt-e-tiling"></a>**Karoli VAE'ye sessiz dusus (`retrying with temporal tiling`)**: cikti gecersiz sayilir [olctum]. Cozum: DiT ve VAE'yi AYRI surecte kos (latent kaydet/yukle), `SD_VAE_NO_TILING_FALLBACK=1` ile dusus yerine hizli hata ver. 192 ve 209 kare bu yolla uretildi.
7. <a id="vt-e-tavan"></a>**Sure tavani (`-TavanDk`) kare sayisina gore ayarlanmadi**: 209 karede 6 DiT adimi bittikten sonra VAE sirasinda 50 dk tavanda olduruldu [olctum]. Kural: tavan = tahmini sure x 1,4; 209 icin en az 80 dk.
8. **Kopyalanan satirda latent/cikti yolu eski adda kaldi** (yeni kosu eski `*_latent.bin` uzerine yazdi) [olctum]: kopyada `-Deney`, `-Cikti`, `-OutDir`, `SD_VIDEO_LATENT_SAVE` ve `-TavanDk` ayri ayri dogrulanir.
9. **Zincirleme (`--init-img`) icin onceki videonun GERCEK son karesi kullanilmadi** (205. kare verildi, son kare 208'di): dikis SSIM 0,659 [olctum]. Cozum: kare sayisini `ffprobe` ile al, son kareyi cikar, orijinal videoyla 0,00 fark dogrula; birlestirirken onceki videoyu kirp, tekrar eden ilk kareyi at.
10. **Karolu VAE yedegi, adim/cfg/cozunurluk dusurmek kalite yolu degildir**: bu proje sabit ayar kullanir (6 adim, cfg 1, varsayilan 640x384; `-W/-H` alani yalniz buyutebilir, kucultemez), bellek yamalari yalniz hesabin NEREDE yapildigini degistirir ve 56/141 kare kapilarinda bayt-aynidir.

## C. Kalite kapisi

11. <a id="vt-e-kapi-red"></a>**Ham gurultu olcusu sahne dokusuna baglidir**: gri karelerde her 8. karede ortalama |kare - 3x3 medyan| yuksek frekansli dokuyu (dal, cim, toz, yakin ucak) da sayar; Z3_175 klibi 1,86 ile RED aldi ama gozle ve zamansal olcuyle bozulma yoktu [olctum]. Ek olarak dokuya normalize N (medyan artik / Sobel doku gucu) kullanilir; esik kapiyi gevsetmez, yalniz RED nedenini raporlar. Hangi `doku_norm` surumunun hangi olcekte oldugunu belgeleyin (iki surumun degerleri farkli olcekte).
12. <a id="vt-w-deneysel"></a>**Bayt kapisi bayrak setiyle yapilir**: bir yama 56 karede R0'a bayt-ayni gecmediyse reddedilir; kapi hangi env bayraklariyla kosulduysa uretim de o setle kosulmalidir. 158-209 kare icin dogrudan bayt referansi YOKTUR: "ayni bayrak ve ikili zinciri" dur [okudum].

## D. Kosucu ve Windows

13. <a id="vt-e-dll"></a>**DLL bulunamadi (`STATUS_DLL_NOT_FOUND` / 0xC0000135)**: `cudart`/`cublas` DLL'lerini calistirma PATH'ine ekle [olctum].
14. **Cikis kodu bos "bitti" yazildi**: `Process` bitmeden `ExitCode` okundu; `WaitForExit()` sonrasi oku [olctum].
15. **Turkce kulturde ondalik virgul CSV'yi kaydirdi**: bicimlemede `InvariantCulture` kullan [olctum].
16. **Durdurma isareti (`DUR` dosyasi) kosan satiri da oldurur**: "kosan satir dogal bitsin" isteniyorsa isaret satir bitince konur; satirin ozet dosyasi (`ozet=`) olmadan koşucu cikis=0'i BITTI sayar, kanit yoktur: uretim ve kapi satirlarinda ozet zorunlu [olctum].
17. **Gozlemci sessizce sondu** (izleyicinin 30 dk tavani): alarm yazilir ama okuyan kalmaz; bitis saatini kaydet, sona erince yeniden kur, uzun islerde kalp atisi ve yedek is satiri kullan [olctum].
18. **Bellek baskisi**: sd-cli ~10-11 GB RAM kullanir (16 GB sistemde); uretim sirasinda diski tarayan agir islerden kacin, bellek kritik dusunce yardimci surecler durdurulur [olctum].

## E. Diger kartlar ve kapi araclari (v0.1.1, issue #1)

19. <a id="vt-e-siyah"></a>**Yeni kartta (compute capability 7.0+) 141 kare ve ustunde video tamamen siyah** (kare ortalamasi 0; latent NaN). 56 ve 107 kare sorunsuz [kullanici bildirdi: RTX 4070 Ti 12 GB, issue #1].
   - Neden (iki aday, ayrilmadi): cuBLAS'in fp16 hesap modu uzun dizide tasiyor OLABILIR; ya da `GGML_CUDA_CUBLAS_COMPUTE_TYPE` ayarlaninca kapanan bf16 birlesik cekirdek (yalniz 8.x ve ustu kartlarda devrede) [okudum: motor `src/core/cuda/bf16.cu`; neden: tahmin]. GTX 1050 Ti'de (6.1) iki yol da zaten devre disi, bu yuzden orada gorulmedi [okudum: `ggml-cuda/common.cuh` fast_fp16_hardware_available].
   - Cozum: v0.1.1 `uret.ps1`, kart 7.0+ ise ve sen ayarlamadiysan `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` yapar; `-Kuru` ciktisinda gorunur. Hiz farki olculemedi (141 kare DiT 211,8 sn ile 209,9 sn) [kullanici bildirdi, issue #1]. Eski surumde elle, ayni PowerShell penceresinde `uret.ps1`'den once:
     `$env:GGML_CUDA_CUBLAS_COMPUTE_TYPE = 'f32'`
   - EN: all-black (NaN) video at 141+ frames on compute capability 7.0+ cards; v0.1.1 sets `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` there unless you set it yourself.
20. <a id="vt-w-py"></a><a id="vt-e-py"></a>**"KAPI RED" ama video duzgun gorunuyor; olaylar.txt'de `dikis_denetim cikti ayristirilamadi`** [olctum: ekip testi 2026-11-20, `No module named 'cv2'` veren sahte python ile; kayit yazarlarda, repoda yok]
   - Neden: python var ama `opencv-python`/`numpy` yok; v0.1.0 bunu yanlislikla RED (cikis 5) sayiyordu.
   - Ozel durum: Windows'ta python kurulu degilken bile `python` komutu bulunur (Microsoft Store kisayolu `WindowsApps\python.exe`); calistirilinca yalniz 9009 ile cikar. `Get-Command` bunu ayirmaz.
   - Cozum: v0.1.1 `uret.ps1` GPU isinden ONCE `python -I -c "import cv2, numpy"` dener; olmazsa **cikis 6** verir ve video uretmez (uzun kosu bosa gitmez). Kapi tek basina kosulursa da bu durumlarda **cikis 6 `KAPI CALISMADI`** (RED degil). Python 3'u python.org'dan kur, paketleri kur, `uret.ps1`'i yeniden calistir; elinde v0.1.0'dan kalan video varsa yalniz kapiyi kos:
     `py -3 -m pip install opencv-python numpy`
     `powershell -NoProfile -File scripts\uretim_kapi.ps1 -Dizin <cikti klasoru> -Ad video -Kare <kare>`
   - Python baska yerdeyse: `$env:VT_PYTHON = '<python.exe tam yolu>'`.
   - EN: no Python, the Windows Store alias (exit 9009) or a Python without OpenCV now gives exit 6, checked before the GPU job (no video made), never 5 (RED). Install Python 3 and `opencv-python numpy`, then run again.
21. <a id="vt-w-ffmpeg"></a>**Kirmizi "ffmpeg is not recognized" satiri, pafta (12 karelik onizleme) yok** [olctum: ekip testi 2026-11-20, uc senaryo (yanlis VT_FFMPEG, PATH'te ffmpeg yok, EAP=Stop sarmali): KAPI GECTI, cikis 0; kayit yazarlarda, repoda yok]
   - Neden: ffmpeg yalniz paftayi cizer; kapi olcutu (kare, gurultu, akis) OpenCV'den gelir. v0.1.0 yalniz `VT_FFMPEG` ve PATH'e bakiyordu.
   - Cozum: v0.1.1 ffmpeg'i `VT_FFMPEG`, PATH ve `engine\bin`'de arar (release ffmpeg icermez; `engine\bin` yalniz siz koyarsaniz ise yarar); bulamazsa acik BILGI satiri yazar, paftayi atlar. Kurmak icin `winget install Gyan.FFmpeg` (sonra yeni pencere ac) ya da `$env:VT_FFMPEG = '<ffmpeg.exe tam yolu>'`.
   - EN: ffmpeg only draws the contact sheet; when it is missing v0.1.1 warns and skips the sheet, the gate decision is unchanged.
22. <a id="vt-e-boyut"></a>**`-W 720` reddedildi** [okudum: motor `request.cpp` hizalama]
   - Neden: motor genislik/yuksekligi 32'nin katina yukari yuvarlar (720 -> 736); betik bu sessiz degisikligi kabul etmez. Dikey ornekler: 384x640, 480x832, 576x1024, 736x1280 (hepsi 32'nin kati).
   - Not: 640x384 disindaki boyutlar 4 GB'ta denenmedi; kapi esikleri 640x384'te kalibre, buyuk boyutta gurultu dusuk okunur [olctum: ekip testi 2026-11-20, F209V2 klibi 1280x768'e buyutulunce gurultu 1,08 -> 0,32, N 0,048 -> 0,020; kayit yazarlarda, repoda yok].
23. <a id="vt-w-vram-marj"></a>**12 GB+ kartta her kosuda "VRAM ince marj" uyarisi** [kullanici bildirdi, issue #1]
   - Neden: v0.1.0 esigi sabit 3800 MiB idi; `--offload-to-cpu` buyuk kartta da karti doldurur.
   - Cozum: v0.1.1 esigi "tepede bos VRAM <= 296 MiB" yapti (4096 MiB kartta eskisiyle ayni).

24. <a id="vt-w-blackwell"></a>**RTX 50 serisinde (compute capability 12.x) 56 kare ve ustunde video tamamen siyah** (`-InitImg` ile 22/39 karede de) [kullanici bildirdi: RTX 5060 Laptop 8 GB, PR #3; v0.1.0 betigiyle].
   - Neden (ayrilmadi): hazir motor yalniz `sm_61` icin derli; katkicinin hipotezi surucunun bu kodu calisirken cevirmesi [tahmin]. v0.1.1'in otomatik `f32` ayari bu kartta denenmedi.
   - Cozum sirasi: (1) v0.1.1 betigi ve hazir motorla 56 kare dene; (2) yine siyahsa iki yol: (a) stable-diffusion.cpp (leejet) hazir CUDA surumu `master-1106-532d2c1`: o surumun derleme dosyasinda `CMAKE_CUDA_ARCHITECTURES='61;70;75;80;86;89;90;100;120'` yazar [okudum: build.yml, o etikette], yani sm_120 dahil; RTX 50'de denenmedi, bizim bellek yamalarimiz yok, kalite kapisi kosmadi; RTX 3070 8 GB'de calistigi dis rapor: `docs/KART_PROFILLERI.md` [kullanici bildirdi]; (b) motoru `-DCMAKE_CUDA_ARCHITECTURES=120` ve CUDA 12.8.1+ ile derle, `VT_ENGINE_BIN`'i o klasore ver. Tarif ve test raporu: `docs/RTX5060_SM120_DERLEME.md`, `docs/RTX5060_TEST_RAPORU.md`. Bizde RTX 50 kart yok, olcmedik; (1)'in sonucunu issue olarak bildirirseniz kok neden netlesir.
   - EN: all-black video on RTX 50 reported with the v0.1.0 script; first try the release engine with the v0.1.1 script (f32 on), then build natively for sm_120 (`docs/RTX5060_SM120_DERLEME.md`).

## F. Kurulum, ortam ve girdi hatalari: kararli kodlar (v0.1.2)

Betikler `HATA:` / `UYARI:` basliginin ardindan `[VT-E-...]` ya da `[VT-W-...]` kodu yazar (basliklar ve cikis kodlari degismez). Kod listesi, EN/TR ilk adim ve log imzalari: `docs/hata_imzalari.json` (imzalar duz alt dizedir). Yeni kod ekleyince bu dosyada ayni kucuk harfli cipa (`<a id="vt-e-...">`) acilir; `tests/test_hata_imzalari.py` ikisini kiyaslar.
Codes: scripts print `[VT-E-...]` / `[VT-W-...]` after the `HATA:` / `UYARI:` heading (headings and exit codes never change); first steps in EN/TR and log signatures are in `docs/hata_imzalari.json`.

25. <a id="vt-e-gpu"></a><a id="vt-e-gpu-vram"></a><a id="vt-e-gpu-cc"></a><a id="vt-w-gpu-denenmedi"></a>**Kullanilabilir NVIDIA kart yok / VRAM az / kart eski** (`VT-E-GPU`, `VT-E-GPU-VRAM`, `VT-E-GPU-CC`, `VT-W-GPU-DENENMEDI`) [okudum: kur.ps1 kontrol0]
   - Neden: `nvidia-smi` yok ya da cikti vermiyor (surucu yok); kart 3800 MiB altinda VRAM ya da compute capability 6.1 altinda. Motor yalniz NVIDIA CUDA.
   - Cozum: NVIDIA surucusunu kurun/guncelleyin, yeni terminalde `nvidia-smi` calistirin. `-Zorla` yalniz VRAM/capability kontrolunu atlar, sonuc garanti degil. Dogrulanmis donanim yalniz GTX 1050 Ti 4 GB; baska kartlar issue'larda kullanici bildirimidir. AMD ya da baska NVIDIA disi kart: surum motoru calismaz; topluluk notu `docs/AMD_ROCM.md` (resmi destek yok, bizce olculmedi).
   - EN: no usable NVIDIA GPU (driver missing, under 3800 MiB VRAM or compute capability under 6.1); install the driver and run `nvidia-smi`; `-Zorla` only skips the check.
26. <a id="vt-e-os"></a>**Windows surumu eski** (`VT-E-OS`) [okudum]: betikler Windows 10 ya da ustu ve Windows PowerShell 5.1 icindir.
27. <a id="vt-e-ram"></a><a id="vt-w-ram"></a><a id="vt-w-ram-bos"></a>**RAM az** (`VT-E-RAM`, `VT-W-RAM`, `VT-W-RAM-BOS`) [olctum: motor RAM tepesi ~11,5 GB, `OLCUMLER.md`]
   - Cozum: 16 GB RAM onerilir, 12 GB alti desteklenmez. Uretimden once tarayici ve buyuk programlari kapatin; bos RAM uyarisi kurulumu etkilemez.
   - EN: 16 GB RAM recommended, under 12 GB unsupported; close big programs before generating.
28. <a id="vt-e-disk"></a><a id="vt-e-disk-kok"></a><a id="vt-w-disk-pay"></a><a id="vt-w-hdd"></a>**Disk yeri ve disk turu** (`VT-E-DISK`, `VT-E-DISK-KOK`, `VT-W-DISK-PAY`, `VT-W-HDD`) [olctum: modeller.json toplam 29,31 GiB; en kotu an ~31,4 GiB]
   - Neden: model surucusunde eksik model varsa en az 32 GiB bos gerekir (HATA); 32-40 GiB arasi UYARI: pay dar. Kurulum kokunun surucusu baska ise motor zipleri icin 3 GiB gerekir. HDD'de ilk adimlar cok yavas.
   - Cozum: yer acin ya da `VT_MODEL_DIR` / `VT_ROOT` ile genis bir surucu secin; NVMe/SSD onerilir. Indirme sirasinda disk dolarsa indirme durur, yarim `.part` korunur ve ayni komut yer acinca kaldigi yerden surer [okudum: `.part` + Range; `.part`'li rapor `-Kuru` ile olculdu, 29 GiB'lik gercek yeniden baslatma olculmedi].
   - EN: model drive needs 32 GiB free (HATA), 32-40 GiB is a WARNING (narrow margin); a partial download keeps its `.part` and the same command continues.
29. <a id="vt-e-hash"></a><a id="vt-w-part"></a><a id="vt-w-range"></a><a id="vt-e-url"></a><a id="vt-e-yol"></a>**Indirme: sha256, yarim dosya, adres reddi** (`VT-E-HASH`, `VT-W-PART`, `VT-W-RANGE`, `VT-E-URL`, `VT-E-YOL`) [okudum: modelleri_indir.ps1]
   - `VT-E-HASH`: dosya `modeller.json` sabitiyle eslesmedi; bozuk dosya silinir ve kullanilmaz. Indiriciyi tekrar calistirin; tekrarlarsa bu satirla issue acin, kontrolu atlamayin.
   - `VT-W-PART` / `VT-W-RANGE`: yarim `.part` Range istegiyle surer; sunucu Range kabul etmezse dosya bastan iner (yavas ama dogru).
   - `VT-E-URL` / `VT-E-YOL`: yalniz `huggingface.co` / `hf.co` uzerinde https ve model klasoru icinde bir hedef kabul edilir. `scripts/modeller.json` degismediyse issue acin.
   - Duzeltilen hata (v0.1.2) [olctum, PS 5.1]: yarim `.part` varken `-Kuru` raporu ve indirme `Cannot convert ... to Int32` ile coker ve devam edemezdi (`[math]::Max(0, long)` Int32 secenegine dusuyordu); duzeltildi, `tests/test_hata_imzalari.py` ayni durumu sinar.
   - EN: sha256 mismatch deletes the file and never uses it; a partial `.part` resumes with a Range request; only https on huggingface.co / hf.co is accepted. Fixed in v0.1.2: a leftover `.part` over 2 GiB made the status report crash instead of resuming.
30. <a id="vt-e-lisans"></a>**Lisans kabul edilmedi** (`VT-E-LISANS`, cikis 2): model indirmesi baslamaz. `docs/LISANS_KABUL.txt` metnini okuyun; yalniz kabul ediyorsaniz `-LisansKabul E` (TR) ya da `Y` (EN). Yapay zeka ajanlari kullanici adina asla kabul etmez (`AGENTS.md`). `-LisansKabul` verilmis ama girdi yonlendirilmisse (ajan/betik) `kur.ps1` kokteki `DURUM.md` icinde `LISANS-KABUL: <kullanicinin sozu> | <saat>` satirini arar; yoksa ayni kodla cikis 2 verir ve hicbir sey indirmez. Bu kanit degil kolaylik/caydiricidir; elle terminalde calisan insan ve `VT_CI=1` etkilenmez. / When `-LisansKabul` is given and the input is redirected (agent, script), `kur.ps1` looks for a `LISANS-KABUL: <the user's words> | <time>` line in `DURUM.md` in the root; without it, exit 2 with the same code and nothing is downloaded. A convenience and deterrent, not proof; a human in a terminal and `VT_CI=1` are not affected.
31. <a id="vt-e-python"></a><a id="vt-e-motor"></a><a id="vt-e-motor-zip"></a><a id="vt-e-kontrol"></a>**Motor adimi ve kontrol uretimi** (`VT-E-MOTOR`, `VT-E-MOTOR-ZIP`, `VT-E-KONTROL`) [okudum]
   - Motor: ag hatasinda ayni komut tekrar calisir (zip curl `-C -` ile surer); yerel zip: `-MotorZip` / `-CudaZip`. Release adresi yoksa `VT-E-MOTOR-ZIP`.
   - Kontrol: 5 karelik gercek uretim basarisizsa HAZIR yazilmaz; iletide adi gecen `ham_err_*` dosyasina bakin; sik nedenler: `VT-E-DLL` (madde 13), eski surucu, eksik/bozuk model, VRAM/RAM.
32. <a id="vt-w-vc"></a><a id="vt-w-yol-bosluk"></a><a id="vt-w-yol-ascii"></a><a id="vt-w-yol-onedrive"></a><a id="vt-w-yol-unc"></a><a id="vt-w-yol-uzun"></a>**Visual C++ eksik ve sorunlu yollar** (`VT-W-VC`, `VT-W-YOL-BOSLUK`, `VT-W-YOL-ASCII`, `VT-W-YOL-ONEDRIVE`, `VT-W-YOL-UNC`, `VT-W-YOL-UZUN`)
   - Hepsi UYARI, kurulum durmaz. VC++ 2015-2022 x64 Redistributable yoksa `sd-cli` acilmayabilir (madde 13). Bosluklu, Turkce karakterli, OneDrive, ag ya da cok uzun yollarda gercek kosu denenmedi; `C:\vt` gibi kisa ASCII yol ve `VT_ROOT` onerilir. (Betik bosluklu ve Turkce karakterli yolda `-Kuru` ile ve `kur.cmd` ile denendi: yalniz rapor; tam video kosusu degil.)
33. <a id="vt-e-kare"></a><a id="vt-e-istem"></a><a id="vt-e-dosya"></a><a id="vt-e-kilit"></a><a id="vt-e-cikti"></a><a id="vt-e-latent"></a><a id="vt-e-karesayisi"></a><a id="vt-e-ses"></a>**uret.ps1 girdi ve kosu denetimleri** (`VT-E-KARE`, `VT-E-ISTEM`, `VT-E-DOSYA`, `VT-E-KILIT`, `VT-E-CIKTI`, `VT-E-LATENT`, `VT-E-KARESAYISI`, `VT-E-SES`) [okudum: uret.ps1]
   - `VT-E-KARE`: 17k+5, en fazla 209 (`-InitImg` 192, 4 GB kartta `-EndImg` 175). `VT-E-ISTEM`: istem/gorsel yolu yok. `VT-E-DOSYA`: motor/model yok, once `kur.ps1`. `VT-E-KILIT`: baska `uret.ps1` GPU'yu kullaniyor, tek GPU isi (olu surecten kalan kilit yok sayilir).
   - `VT-E-CIKTI` / `VT-E-LATENT` / `VT-E-KARESAYISI` / `VT-E-SES`: cikti gecersiz sayilir; yanindaki `ham_err_*` ve `ham_out_*` loglarini okuyun, tekrarlarsa loglarla issue acin.
   - EN: frame count 17k+5 up to 209; missing prompt/engine/model files; one GPU job at a time; an invalid output (missing file, wrong frame count, no audio) is rejected on purpose.

34. <a id="vt-amd-vram-16gb"></a>**16 GB kartta (RX 9070 XT, Vulkan) uzun istemle 209 karede 6. adimda VRAM bitti** [kullanici bildirdi, PR #4]
   - Belirti: `[W] execution engine cannot make enough memory available on Vulkan0: need 512.00 MB device / 4494.18 MB budget, available 470.12 MB device / unlimited budget`, ardindan `[E] minimax_h3 segment 1/1 (graph) failed during allocated capacity check` ve `[E] sampling failed after 241.62s` (6 adimin 5'i bitmisti). Ayni 209 kare, ornek istem (380 bayt) ile bitmisti; 467 baytlik kendi istemimle bitmedi.
   - Neden [tahmin]: daha uzun istem metin parcasi sayisini artirip hesap tamponunu birkac yuz MB buyutuyor; 209 kare 16 GB'in kenarinda.
   - Cozum [kullanici bildirdi]: `--model-args minimax_h3_attn_chunk_budget=0.03` (varsayilan `0.05` yerine). Ayni istem ve 209 kareyle Vulkan'da kosu bitti (218 s, VRAM tepe 13.8 GB). Cikti kalitesinin ayni oldugu ya da bayt-ozdesligi olculmedi [tahmin: yalniz bellek planlamasi].
   - EN: on a 16 GB card (RX 9070 XT, Vulkan) a longer prompt ran out of VRAM at step 6 of 6 with 209 frames at the default `minimax_h3_attn_chunk_budget=0.05`; `0.03` finished the same prompt and frames (218 s, VRAM peak 13.8 GB) [measured, one prompt]. Output equality was not checked.

35. <a id="vt-e-profil"></a><a id="vt-e-motor-eski"></a>**`-Profil` reddedildi ya da hiz profili sigmadi** (`VT-E-PROFIL`, `VT-E-MOTOR-ESKI`) [okudum: uret.ps1; olcumler: docs/OLCUMLER.md "Hiz paketi"]
   - `VT-E-PROFIL`: yalniz uc isimli profil var (`yuksek832`: 832x480 x 141 ya da 124 kare; `yuksek896`: 896x512 x 124 kare; `uzun260`: 640x384 x 260 kare, bellege yakin calisir) ve yalniz olculen kare sayilariyla, `-W/-H`, `-InitImg`, `-EndImg`, `-TekAsama` olmadan calisir. Baska sayi ya da boyut icin profilsiz kosun (640x384, en fazla 209 kare).
   - `VT-E-MOTOR-ESKI`: profil, motor klasorunde `HIZ_PAKETI.txt` ister (hiz paketi motor zip'i: yama 0021, 0023, 0024). Eski motor `SD_ATTN_HEAD_QKV` ve `SD_VAE_BLOCK_SPLIT` bayraklarini sessizce yok sayar ve yaklasik 1 saat sonra bellekte dusersiniz; bu yuzden betik once reddeder. Cozum: `scripts\kur.ps1` ile hiz paketi motorunu kurun. Kendi derlediginiz motor icin `VT_HIZ_MOTOR=1` (sonuc garanti degil).
   - Profil kosusu `[VT-E-VRAM]` / `cannot make enough memory` ile dusarse: 832x480 x 141 hucresinde bellek payi tek haneli MB'tir (olculen en dar pay 5,7 ve 6,8 MB; 1520 ve 2041 karakterlik uzun istemlerde yalniz kapi okumasi yapildi: pay 10,9 ve 4,0 MB, tam kosu yok) [olctum, GTX 1050 Ti]. Kartta baska surec varsa (tarayici, ikinci ekran) kapatin; olmazsa `-Profil yuksek832 -Kare 124`, o da olmazsa profilsiz 640x384.
   - EN: `-Profil` knows three named, measured cells only (832x480 x 141 or 124 frames, 896x512 x 124 frames, 640x384 x 260 frames, which runs close to the memory limit) and needs the patched engine (`HIZ_PAKETI.txt` in the engine folder); an old engine would ignore the flags and run out of memory after about an hour, so the script refuses first. The 832x480 x 141 cell has single-digit MB of headroom at the memory gate; with another process on the card, or a very long prompt, fall back to 124 frames or to the default 640x384.
