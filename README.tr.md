# VideoTurko

[English](README.md) · Türkçe · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

Çeviriler bu İngilizce README'yi izler. Bir çeviri farklıysa ya da geride kalmışsa, özellikle lisans ve güvenlik metninde İngilizce metin esastır ([`SECURITY.md`](SECURITY.md) ve [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) yalnız İngilizce ve Türkçe tutulur).

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **Başlamadan önce (lisans, bölge):** bu depo MIT'tir ve yalnız yama ve betik içerir. İndirdiği MiniMax H3 modeli MiniMax H3 Community License altındadır: bölgesi Avrupa Birliği, Birleşik Krallık, Güney Kore ve Amerika Birleşik Devletleri'ni dışarıda bırakır; model, türevleri **ve çıktıları (ürettiğiniz videolar)** orada kullanılamaz, dağıtılamaz, gösterilemez (V.4). Ticari kullanım lisans koşulları içinde serbesttir. Kurmadan önce [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) okuyun; bu hukuki tavsiye değildir.

> **30 saniyede:** 4 GB bir ekran kartı 209 karelik (8,7 sn) MiniMax H3 videosunu tek geçişte üretebiliyor: tek makinede doğrulandı (GTX 1050 Ti 4 GB; boş klasörde tam `kur.ps1` kurulumu uçtan uca henüz doğrulanmadı) [ölçtüm: 209 kare, sürüm ikilisiyle, `uret.ps1` üzerinden, koşu U209; latent bayt-aynı; videoda kareler ve ses aynı, dosya sha'sı konteyner nedeniyle farklı; kanıt yazarlarda, bu depoda yok]; `-InitImg` (resimden video) ile en çok 192 kare (8,0 sn) [ölçtüm: koşu B192]; 209 kare yaklaşık 57 dk sürer, varsayılan süre tavanı 80 dk [ölçtüm: koşu U209]; aşağıdaki 3 adım nasıl çalıştırılacağını gösterir.

VideoTurko: 4 GB GTX 1050 Ti'de MiniMax H3 ile metinden videoyu tek seferde 209 kareye (8,7 sn) kadar, resimden videoyu (`-InitImg`) 192 kareye (8,0 sn) kadar (209 kare bayt zinciriyle doğrulandı) üretmek için stable-diffusion.cpp bellek yamaları ve tarifler; 56 ve 141 karelik kontrollerde yamasız koşuyla bayt aynı.

## Hızlı başlangıç (Windows, 3 adım)
**Durum: aşağıdaki kurulum/çalıştırma betikleri tamamlanıyor ve temiz kök testi bekliyor; bu test geçene kadar burada hiçbir şeyin çalıştığı iddia edilmez ("Durum ve sınırlar").**

1. **İndir**: bu depoyu indirin (yeşil **Code** düğmesi, **Download ZIP**) ve KISA bir klasöre açın, örneğin `C:\vt`.
2. **Kur: `kur.cmd` dosyasına çift tıklayın** (siyah bir pencere açılır ve her adımı gösterir; kapatırsanız kurulum durur, yeniden çalıştırırsanız kaldığı yerden sürer: yarım inen model dosyası devam ettirilir [okudum: indirme betiği bir `.part` dosyası tutar ve ondan sürdürür; tam 29 GiB'lik devam ölçülmedi]). İndirilen dosya için Windows uyarı verirse aşağıdaki PowerShell komutunu kullanın [öneri, indirilmiş ZIP'te denenmedi]. Komut satırını mı tercih edersiniz? O klasörde PowerShell açın (Gezgin adres çubuğuna `powershell` yazın) ve aynı kurulumu çalıştırın:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   Kurulum kökü açtığınız klasördür (motor `engine\bin`, modeller `model` altına gider); başka yer için önce `VT_ROOT` ortam değişkenini ayarlayın. GPU, sürücü, RAM ve disk kontrol edilir; motor ve modeller indirilir (motor zipleri ve yeni indirilen model dosyaları sha256 ile doğrulanır; boyutu doğru olan mevcut model dosyası yalnız boyutla denetlenir, tam sha256 için `scripts\modelleri_indir.ps1 -Dogrula`); kısa gerçek bir kontrol koşulur ve yalnız o geçerse HAZIR yazar [tasarım: `kur.ps1` temiz klasörde baştan sona koşulmadı; temiz kök testinden sonra bu cümle güncellenir]. `-ExecutionPolicy Bypass` yalnız bu sürece uygulanır; her kurulum betiğinde olduğu gibi önce `scripts\kur.ps1`'i okuyun.
   Motor zip'i GitHub release v0.1.0'dan iner (2026-11-19'da yayınlandı; sha256'sı `kur.ps1` içinde sabit). İnternetsiz ya da kendi derlemenizle yerel zip verin: `-MotorZip <path> -CudaZip <path>`. Yerel zip de aynı sabit sha256 ile denetlenir (yanındaki `.sha256` dosyası yok sayılır), yani release zip'i olmalıdır; kendi derlemeniz için önce `VT_MOTOR_SHA256` / `VT_CUDA_SHA256` değişkenine onun sha256'sını verin. Yanlış sha256 çıkış 1 ile durur. `engine\bin`'e yalnız `.exe`/`.dll` gider; lisanslar ve README `engine\lisanslar\<zip name>\` altına yazılır. [release öncesi dist zipleriyle denendi: yan `.sha256` dosyası ve kendine atıf yapan uyarı, ikili ve DLL'ler yerleşti, `sd-cli --help` çalıştı; kurulu ikili sha'ları eşleşti (`c5cebe78...`, `e5d3d329...`); `kur.ps1`'in model adımı ve 5 karelik kontrolü gerçek GPU'da HENÜZ denenmedi]
   **Model lisansı:** model adımından önce kurulum lisans özetini (`docs/LISANS_KABUL.txt`, tam metin `docs/LISANS_UYARISI.md`: MiniMax H3 Community License, üretilen videoları da kapsayan bölge sınırları, ticari kullanım ve yapay zekâ etiketi kuralları) yazar ve kabul etmenizi ister (`E` = evet). Önce okuyun. Gözetimsiz çalıştırmada `-LisansKabul E` verebilirsiniz; bu, lisansı kendinizin okuyup kabul ettiğiniz anlamına gelir, başkası adına eklemeyin. (Yapay zekâ ajanları: `AGENTS.md`; kullanıcı onayı olmadan E vermeyin.) Kabul yoksa `kur.ps1` çıkış kodu 2 ile durur ve model indirmez.
3. **İlk videonuz (56 kare, GTX 1050 Ti'mizde yaklaşık 11 dk** [ölçtüm: 641 sn, koşu R0, `docs/OLCUMLER.md`; başka kartlar ölçülmedi]**)**: kurulum `HAZIR / READY` yazdığında şunu çalıştırın:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (kısayol: bir istem metin dosyasını `uret.cmd` üzerine sürükleyin ya da `uret.cmd docs\ornek_istem_R0.txt` çalıştırın: aynı 56 karelik koşu). Video `runs\` içindedir. Sonra kendi isteminizi bir metin dosyasına yazın (tek paragraf İngilizce, isteğe bağlı `audio:` cümlesi) ve kapsadığımız en uzun klibi çalıştırın (varsayılan, yaklaşık 57 dk [ölçtüm: koşu U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   `-Kare` 17k+5 dizisinden seçilir (56, 73, ... 192, 209); varsayılan 209 (8,7 sn), kapsadığımız en uzun uzunluktur. VAE ayrı süreçte ve parçasız koşar [`uret.ps1` üzerinden sürüm ikilisiyle gerçek motor koşusu, ayrı süreç VAE, U209 koşusunda geçti].

   İstem yazım rehberi: [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (kesintisiz çekim kalıbı, eşit zaman dilimleri, iki tam örnek).

| Gereksinim | Değer |
|---|---|
| İşletim sistemi | Windows 10/11, 64 bit |
| Ekran kartı | NVIDIA, 4 GB ya da üstü; yalnız GTX 1050 Ti (sm_61) ile denendi; pay ince (209 karede 3777/4096 MiB): meşgul ekran ya da tarayıcı koşuyu bozabilir; başka 4 GB kart denenmedi |
| RAM | 16 GB (tepe yaklaşık 11 GB; diğer programları kapatın) |
| Disk | en az 32 GiB boş (40 GiB ve üzeri önerilir: 32 ile 40 arasında kurulum uyarı yazar, `[VT-W-DISK-PAY]` [ölçtüm: sahte diskli `-Kuru` koşuları]), modeller SSD'de (NVMe tercih edilir) |
| İndirme | motor zip 36,8 MB + CUDA çalışma zamanı zip 567,5 MB [ölçtüm] + modeller 31.473.112.040 bayt (yaklaşık 29,3 GiB) [okudum: `scripts/modeller.json` boyutları]; toplam yaklaşık 30 GiB |
| Modeller | dahil değil; MiniMax lisansı altında kurulum betiği indirir (aşağıdaki uyarı). Modeller (29,3 GiB, `scripts/modeller.json`'da 31.473.112.040 bayt) bu depoda ya da release'te yok: GitHub dosya/release boyut sınırları geçerli ve `kur.ps1` onları resmi kaynaktan sha256 doğrulamasıyla indirir. |

`kur.ps1` çıkış kodları: 0 HAZIR, 1 hata, 2 kullanıcı girdisi gerekli (lisans ya da henüz release/zip yok), 3 donanım ya da disk yetersiz, 4 durduruldu (DUR dosyası). `uret.ps1` bir koşuyu yalnız `.avi` var, kare sayısı doğru ve loglar temizse kabul eder [ölçtüm: sürüm ikilisiyle `uret.ps1` üzerinden bir gerçek koşu, koşu U209, 209 kare, kapı geçti]. `uret.ps1` çıkış kodları: 0 TAMAM (kalite kapısı geçti), 1 hata ya da geçersiz çıktı (ses akışı olmayan video dahil), 2 durduruldu (DUR dosyası), 5 `KAPI RED` (kalite kapısı geçmedi: klip kabul edilmez, karar sizin), 6 kapı çalışamadı (klip kabul edilmez). Ayrıntı AGENTS.md'de. [ölçtüm: çıkış kodları 0, 1 (sessiz video), 5 ve 6 sahte motor ve sahte kapıyla senaryolarda; gerçek motor: U209 koşusunda çıkış 0]

### Sorun giderme (ayrıntı: `docs/SIK_HATALAR.md`)
Betiklerimizin hata satırları sabit bir kod taşır, örneğin `HATA: [VT-E-DLL] ...` ya da `UYARI: [VT-W-DISK-PAY] ...`. Kodu [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) içinde (bağlantı örneği `#vt-e-dll`) ya da `docs/hata_imzalari.json` içinde arayın ve kodu issue'nuza yazın. Aşağıdaki tablonun ilk sütunu basıldığı gibi kalır (kodlar ve günlük metni çevrilmez).

| Ne görüyorsunuz | Ne demek, ne yapılır |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | `sd-cli.exe`'yi elle başlatmayın; CUDA DLL'lerini yerine koyan `scripts\kur.ps1`'i çalıştırın. |
| `blocks.0` `failed during weight preparation` (#1, #3, #5) | Bellek kapısında VRAM yetmedi: 17k+5 dizisinden daha küçük kare sayısı seçin, diğer GPU programlarını kapatın, verilen bayrakları değiştirmeyin. |
| `retrying with temporal tiling` (#6) | VAE parçalı moda düştü; çıktı kalite açısından geçersiz. Yeniden çalıştırın. |
| Süre tavanında durdu, video yok (#7) | Uzun klipler için `-TavanDk` değerini artırın (varsayılan süre tavanı 209 kare için 80 dk, `uret.ps1` ayarlar; 209 karelik koşumuz 57 dk sürdü [ölçtüm: koşu U209]). |
| Çıkış kodu boş ama "bitti" yazdı (#14) | Sarmalayıcı çıkış kodunu erken okudu; yeniden çalıştırın ve video dosyasının varlığına bakın. |
| Sistem yavaşladı, takas (#18) | Motor yaklaşık 10-11 GB RAM kullanır; tarayıcı ve diğer programları kapatın. |
| sha256 tutmadı / indirme başarısız | Genelde yarım kalan indirme: aynı komutu tekrar çalıştırın, doğrulanmış dosyalar atlanır. |

**Takıldınız mı, merak mı ediyorsunuz?** [`SUPPORT.md`](SUPPORT.md) (nereye sorulur; yanıt süreleri hedeftir, taahhüt değil) · [`PRIVACY.md`](PRIVACY.md) (telemetri yok; ağ yalnız motoru ve modelleri indirmek için, listelenen sunuculardan kullanılır) · [`SECURITY.md`](SECURITY.md) (özel bildirim) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (5 adımda ilk pull request; belge ve betik için GPU gerekmez).

### v0.1.1 ile gelenler: yeni seçenekler (ayrıntı: `AGENTS.md`, `docs/SIK_HATALAR.md` 19-23)
Bu seçenekleri kullanmazsanız 4 GB kartta hiçbir şey değişmez (referansımıza karşı 56 karelik bayt kontrolü v0.1.1 ile yeniden geçti [ölçtüm]). Ne çalışacağını görmek için her komuta `-Kuru` ekleyin.
- `-EndImg`: son kareyi de verin (ilk-son kare, "FLF"); tavan 8 GB altı kartta 175 kare (192 kare 4 GB'a sığmadı), 8 GB ve üstünde 192. Bizim GTX 1050 Ti'de her zaman iki süreçte koşar: 56 kare 1040 sn, 175 kare 2887 sn (48 dk), ikisi de kapıdan geçti [ölçtüm]. İstem ipuçları: `docs/ISTEM_YAZIMI.md`.
- `-W` / `-H`: başka boyutlar, örneğin dikey 384x640; 32'nin katı, alan en az 640x384 (küçültme yok). 4 GB'ta denenmedi; 8 GB altı kartlarda ölçtüğümüz en büyük işi aşan boyut reddedilir. Kalite kapısı eşikleri 640x384'e göre ayarlı.
- `-TekAsama`: iki süreç yerine tek süreç; yalnız büyük kartlar için, kendiliğinden açılmaz.
- Yeni kartlar (compute capability 7.0+, örn. RTX 20/30/40): siz ayarlamadıysanız `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` otomatik yapılır; bu, rapor sahibinin RTX 4070 Ti kartında 141 kare ve üstündeki tamamen siyah videoyu düzeltti [kullanıcı bildirdi, issue #1]. Python + OpenCV yoksa `uret.ps1` artık GPU işinden önce çıkış 6 ile durur (video üretilmez, yanıltıcı RED yok).
- Bu değişikliklere yol açan RTX 4070 Ti raporu için @SinanC73'e teşekkürler ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1)).

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

## İsteğe bağlı hız profilleri (hız paketi; varsayılan kapalı)
Aşağıdakilerin hiçbiri varsayılan çalıştırmayı değiştirmez (640x384, 209 kare, kartımızda 3414 sn). Bunlar onun ötesinde ölçülmüş üç hücredir; her biri `uret.ps1`'in adlı bir profili. Hız paketi motoru gerekir (release motoru + 0021, 0023, 0024 yamaları, hepsi varsayılan kapalı: `docs/YAMALAR.md`). `scripts\kur.ps1 -HizPaketi` ile kurulur (yerel zip için `-MotorZip`), sonra `-Profil <name>` eklenir; `-Kuru` ne çalışacağını yazar.

| Profil | Boyut, uzunluk | GTX 1050 Ti 4 GB'ta toplam süre | Durum |
|---|---|---|---|
| (yok, varsayılan) | 640x384, en fazla 209 kare (8,7 sn) | 209 karede 3414 sn | doğrulanmış, değişmedi |
| `yuksek832` | 832x480, 141 kare (5,9 sn) | yaklaşık 55-56 dk | kullanılabilir, iki istem [ölçtüm] |
| `yuksek832 -Kare 124` | 832x480, 124 kare (5,2 sn) | yaklaşık 45-46 dk, hız bayrağı gerekmez | kullanılabilir, iki istem [ölçtüm] |
| `yuksek896` | 896x512, 124 kare (5,2 sn) | yaklaşık 56-57,5 dk | kullanılabilir, iki istem [ölçtüm] |
| `uzun260` | 640x384, 260 kare (10,8 sn) | erken çıkışsız 78 dk ölçüldü; erken çıkışla yaklaşık 71-72 dk [tahmin: `uret.ps1` üzerinden uçtan uca ölçülmedi] | koşullu ve deneysel |

- **Dar pay:** 832x480 x 141'de bellek kapısında pay tek haneli MB'tir (iki tam koşuda 5,7 ve 6,8 MB). İki uzun istem (1520 ve 2041 karakter) yalnız kapı okumasıyla (adım 1 ve adım 2'nin bir kısmı) bakıldı, tam koşulmadı: pay 10,9 ve 4,0 MB. Kartın belleğini tutan başka süreç (tarayıcı, ikinci ekran) bunu düşürebilir; o zaman `-Kare 124` ya da varsayılan boyut [ölçtüm, GTX 1050 Ti 4 GB].
- **`uzun260` koşulludur:** bellek sınırı çok dar (VRAM tepe 3903 / 4096 MiB), paylaşımlı bellek kullanımı 61 ve 68 MiB arttı ve bayt eşitliği için bayraksız referans yok; bu yüzden düz bir özellik gibi sunulmaz. Yama 0023 yalnız bu hücre için kabul edildi.
- **Sunulmayanlar:** 832x480'de 158 ya da 175 kare sığmıyor; uzunluk araması orada 141'de bitti. Başka boyut ve kare sayılarını `-Profil` reddeder (varsayılan yolu kullanın).
- Varsayılan kalite aynen duruyor: 6 adım, cfg 1, karosuz VAE, 17k+5 kare. Bayrakların açık olduğu yerlerde çıktı, bayraksız koşunun sığdığı boyutlarda bayraksız videoyla bayt bayt karşılaştırıldı (`docs/YAMALAR.md`); 832x480 x 141 ve 896x512 x 124'te bayraksız koşu sığmıyor, orada eşitlik doğrudan kıyasa değil en yakın hücrelere dayanır [ölçtüm, okudum].
- İki aşamalı koşuda 1. aşama artık gizli durum (latent) dosyası tamamlanır tamamlanmaz bitiyor (`VT_ERKEN_CIKIS=0` bunu kapatır).

## Disk düzeni ve kaldırma
VideoTurko'nun kurduğu her şey tek kök klasörde, `<VT_ROOT>` altında durur (varsayılan: açtığınız klasör; başka yer için betikleri çalıştırmadan önce `VT_ROOT` ortam değişkenini verin). Sistem PATH'ine, kullanıcı profiline ve registry'ye hiçbir şey yazılmaz.

| `<VT_ROOT>` altındaki klasör | İçinde ne var | Boyut |
|---|---|---|
| `engine\bin`, `engine\lisanslar` | hazır motor (exe ve DLL'ler; GTX 10xx ve RTX 40xx) ve zip'lerinin lisans dosyaları | ölçülmedi |
| `engine\stock_cuda12\bin` ya da `engine\stock_vulkan\bin` | yalnız biri, kartınız stock stable-diffusion.cpp motorunu alıyorsa (kurulum seçer); lisans dosyaları yanında `lisanslar\` içinde | açılmış yaklaşık 1,2 GiB (CUDA) ya da yaklaşık 0,08 GiB (Vulkan) [ölçtüm: zip merkezi dizini, bakımcılar] |
| `engine\secili_motor.json` | `kur.ps1`'in seçtiği motor; `uret.ps1` bunu okur (`VT_ENGINE_BIN` verilirse o kazanır) | çok küçük |
| `model` | resmî kaynaktan indirilen, sha256 denetimli model dosyaları | 29,3 GiB [okudum: `AGENTS.md`] |
| `indirme` | indirilen zip'ler ve açma artıkları | ölçülmedi |
| `runs` | bitmiş videolarınız | kullandıkça büyür |
| `.venv` (isteğe bağlı) | kalite kapısı için Python ortamı (opencv-python, numpy) | ölçülmedi |

Kurulum betikleri `pip`, `uv` ya da Hugging Face aracı çalıştırmaz; paket ya da model önbelleği yazmazlar. İsteğe bağlı kapı paketlerini kendiniz kuracaksanız önbelleği de köke koyun: `py -3 -m venv <VT_ROOT>\.venv`, sonra `<VT_ROOT>\.venv\Scripts\python.exe -m pip install --cache-dir <VT_ROOT>\.onbellek\pip opencv-python numpy`; `<VT_ROOT>\.venv` varsa betikler onu kullanır (`VT_PYTHON` verilmedikçe).

Linux'ta (`./kur.sh`, deneysel) aynı kök şunları barındırır:

| `<VT_ROOT>` altındaki Linux yolu | İçinde ne var |
|---|---|
| `.venv`, `.onbellek/pip` | Python ortamı (opencv-python-headless, numpy) ve pip önbelleği; `kur.sh` her zaman oluşturur |
| `engine/src`, `engine/build` | sabit commit'teki stable-diffusion.cpp kaynağı ve derleme klasörü |
| `engine/toolchain` | yalnız derleme yerel bir araç zinciri gerektiriyorsa |
| `engine/bin`, `engine/.yamalar_tamam` | derlenmiş `sd-cli` ve `SHA256SUMS`'ı, ve yamaların uygulandığı işareti |
| `model/`, `runs/` | Windows'taki gibi |

**Modeli zaten indirdiniz mi?** Kurulumu `-ModelKlasoru <folder>` ile ona gösterin: sha256'sı eşleşen dosyalar indirilmez, bağlanır. Aynı sürücüde bu bir sert bağdır (veri bir kez durur; kaynak klasörü sonradan silmek yer açmaz); başka sürücüde KOPYADIR (yaklaşık 29 GiB iki kez). sha256'sı doğru tam dosya atlanır, yarım indirme `.part` dosyasından sürer.

**Kaldırma:** VideoTurko'yu kapatın, `runs` içinden saklamak istediğiniz videoları kopyalayın, sonra `<VT_ROOT>` klasörünü silin; kaldırma bu kadar. Bizim silmemiz gerekmeyenler: sistem Python'una yaptığınız `pip install` (bundan kaçınmak için yukarıdaki gibi `.venv` kullanın) ve `winget` ile kurulanlar.

## Kartım hangi motoru alır? (otomatik)

`kur.cmd` kartınızı okur (`nvidia-smi`'den compute capability; AMD için Windows ekran bağdaştırıcı adı) ve motoru kendisi seçer. Bir şey indirilmeden önce `scripts\kur.ps1 -Kuru` seçimi tek satırda gösterir: `Motor secimi: <id> (kart sinifi <class>; durum <status>)`. Karar vermeniz gereken bir şey yok: `kur.cmd`'ye çift tıklayın. Elle seçmek için: `-MotorTuru release_sm61`, `-MotorTuru stock_cuda12` ya da `-MotorTuru stock_vulkan` (`-MotorZip` / `-CudaZip` ile verilen yerel zip hazır motor sayılır). Arkasındaki tablo `scripts/kart_tablosu.json`.

Durum sözcükleri: **doğrulanmış** = bakımcılar ölçtü; **topluluk** = bir kullanıcı bildirdi, biz ölçmedik; **denenmemiş** = kimse bir koşu bildirmedi.

| Kart sınıfı | Seçilen motor | Durum | Kanıt |
|---|---|---|---|
| GTX 10xx (Pascal, compute capability 6.1-6.9) | hazır motor (`sm_61`, bizim yamalarımız) | doğrulanmış, yalnız GTX 1050 Ti | [ölçtüm] `docs/OLCUMLER.md`; diğer Pascal kartlar [tahmin: aynı mimari] |
| RTX 20xx, GTX 16xx (Turing/Volta, 7.x) | stock CUDA motoru | denenmemiş | [okudum] stock derleme `sm_70` ve `sm_75` listeler; bildirilen koşu yok |
| RTX 30xx (Ampere, 8.0-8.8) | stock CUDA motoru | topluluk | [user-reported, PR #6] RTX 3070 8 GB, `uret.ps1` dışında koşuldu, kalite kapısı koşulmadı; 6 GB laptop kartlarda ölçüm yok [tahmin: aynı mimari] |
| RTX 40xx (Ada, 8.9) | stock CUDA motoru, `f32` | topluluk | [user-reported, issue #25] RTX 4070 Laptop 8 GB: stock motor 209 kare 275 s, hazır motor 620 s, kapılar ikisinde geçti (stock koşu `uret.ps1` dışında); [user-reported, issue #24] RTX 3060 12 GB (Ampere): 209 karede stock 2,6x hızlı; önceki raporlar hazır motorla: [user-reported, issue #1] RTX 4070 Ti, [user-reported, PR #5] RTX 4060, yerel `sm_89` derleme. Elle seçim: `-MotorTuru` / `VT_ENGINE_TYPE` |
| Hopper ve daha yeni veri merkezi kartları (9.0-11.x) | stock CUDA motoru | denenmemiş | [okudum] stock derleme `sm_90` ve `sm_100` listeler; bildirilen koşu yok |
| RTX 50xx (Blackwell, 12.0 ve üzeri) | stock CUDA motoru | denenmemiş | [okudum] stock derleme `sm_120` listeler; RTX 50'de stock koşu yok; [user-reported, PR #3] hazır `sm_61` motor 56+ karede siyah video verdi, yerel `sm_120` derleme çalıştı |
| AMD Radeon | stock Vulkan motoru, `minimax_h3_attn_chunk_budget=0.03` | topluluk | [user-reported] RX 9070 XT 16 GB, 209 kare; ROCm otomatik değil (`hipblas.dll` ister) |
| Intel, diğer her şey | otomatik motor yok | yok | `kur.ps1` hata verir; `-MotorTuru` ile elle seçin |

`f32` ayarı (`GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32`) compute capability 7.0 ve üzeri NVIDIA kartlarda kendiliğinden uygulanır. Stock motor tek süreçte çalışır (bizim yamalarımızın iki aşamalı anahtarları onda yoktur); kalite ayarları her kartta aynıdır (6 adım, cfg 1, 640x384, karosuz VAE) ve kalite kapısı aynı biçimde çalışır. VRAM yetmezse motor `[VT-E-VRAM]` ile erken durur ve daha kısa bir `-Kare` önerir. Doğrulanmamış bir kart sınıfında durumu ve kanıtıyla birlikte `[VT-W-GPU-DENENMEDI]` uyarısı çıkar. Stock motor `engine\` altında açılmış yaklaşık 1,2 GiB ekler (CUDA; zip'ler 412 MB ve 563 MB) ya da yaklaşık 0,08 GiB (Vulkan; zip 30 MB) [ölçtüm: zip merkezi dizini, bakımcılar]. Kart başına ayrıntı: `docs/KART_PROFILLERI.md`. Birkaç klipten uzun film: `docs/KLIP_ZINCIRI.md`, `scripts/zincir.py` [user-reported]; zincirleme film kalitesini biz ölçmedik [not tried].

> **Kartınızı ekleyin (pull request).** Kısa bir PR yeter: (1) `nvidia-smi --query-gpu=name,memory.total,driver_version,compute_cap --format=csv,noheader,nounits` komutunun bastığı satır; (2) `scripts\kur.ps1 -Kuru` çıktısı; (3) `uret.ps1` koşunuzun özeti (kare, süre, varsa tepe VRAM), her sayı [measured], [read] ya da [guess] etiketli; (4) `docs/KART_PROFILLERI.md`'ye yeni bir satır ve motor seçimi değişmeliyse `scripts/kart_tablosu.json` için öneri. Kalite ayarlarını (6 adım, cfg 1, 640x384, karosuz VAE) değiştiren bir PR kabul edilemez. Bkz. `CONTRIBUTING.md`.

Lisans: MiniMax H3 lisansını (`docs/LISANS_KABUL.txt`) kabul etmek her yolda geçerlidir.

## Linux (deneysel)

**Durum: deneysel.** Bakımcılar Linux'ta GPU koşusu yapmadı. Tek kanıt [user-reported, PR #8]: RTX 4060 Ti 8 GB'ta 56 kare (katkıcı @xmtaha); 141 ve 209 kare Linux'ta ölçülmedi [not tried]. Windows'taki motor seçimi (stock motor, `scripts/kart_tablosu.json`) Linux'ta geçerli değildir: motoru sabitlenmiş kaynaklardan bizim yamalarımızla kendiniz derlersiniz.

Gerekenler: NVIDIA sürücüsü (`nvidia-smi` çalışmalı; 4 GB ya da üstü VRAM), CUDA Toolkit (`nvcc`), `git`, `cmake` ve `python3`; modeller için yaklaşık 29,3 GiB (model sürücüsünde en az 32 GiB boş) ve kök altında kaynak ile derleme için yer [tahmin: kök sürücüsünde yaklaşık 10 GiB daha; ölçülmedi].

```bash
./kur.sh --kuru
./kur.sh
./uret.sh --istem docs/ornek_istem_R0.txt --kare 56
```

`./kur.sh --kuru` hiçbir şey değiştirmez (yazmaz, indirmez, derlemez) ve hazırlık durumunu çıkış koduyla bildirir. `./kur.sh` GPU'yu (compute capability 6.1 ya da üstü), diski ve model lisansını denetler (size sorar; `--lisans-kabul E` okuyup kabul ettiğiniz anlamına gelir), kökün altında Python ortamı kurar (`.venv`, pip önbelleği `.onbellek/pip`), stable-diffusion.cpp'yi sabit commit'te klonlayıp `patches/SHA256SUMS` ile doğrulanan yamalarla derler (derleme uzun sürer [ölçülmedi]), modelleri sha256 denetimiyle indirir, 5 karelik gerçek bir kontrol üretimi yapar ve yalnız kontrol geçerse HAZIR yazar (`--kontrol-atla` kontrolü atlar ve asla HAZIR yazmaz). `./uret.sh` `uret.ps1` ile aynı kurallara uyar: kare sayısı 17k+5 en fazla 209 (`--init-img` ile 192), varsayılan 640x384, aynı iki aşama eşiği, compute capability 7.0 ve üzeri kartlarda `f32`, aynı kalite kapısı; kalite ayarları her sistemde sabittir (6 adım, cfg 1, karosuz VAE). `kur.sh` çıkış kodları: 0 hazır, 1 hata, 2 lisans gerekli, 3 donanım ya da disk yetmiyor; `uret.sh`: 0 tamam, 1 hata, 2 kullanım hatası ya da durdurma dosyası, 5 kalite kapısı RED, 6 kapı çalışamadı.

## Bu nedir
MiniMax H3'ü (33B DiT; biz HyperFlow Flash 13,7B Q4_K_M GGUF'u çalıştırıyoruz; 32B Qwen3-VL metin kodlayıcı ayrıdır) 4 GB'lık Pascal ekran kartında (GTX 1050 Ti, 16 GB RAM) çalıştırmak için küçük bellek/zamanlama yamaları, çalıştırma tarifi, kontroller ve ölçümler.
- Gerçekten ürettiğimiz ve kalite kapılarından geçen tek geçiş uzunlukları: 640x384, 24 fps, 56, 141, 158, 175, 192, 209 kare (209 kare = 8,7 sn); sesi H3'ün kendisi üretir [ölçtüm: 209 kare, sürüm ikilisiyle, `uret.ps1` üzerinden, koşu U209; latent bayt-aynı; videoda kareler ve ses aynı, dosya sha'sı konteyner nedeniyle farklı; kanıt yazarlarda, bu depoda yok]. 209, izleyip düzgün bulduğumuz en uzun süredir [kullanıcı bildirdi, 2026-11-19, video baştan sona izlendi; dosya: F209V2 çıktısı, 8,708 sn].
- **Bayt aynılık iddiası dürüst kapsamda:** yamasız referansa bayt aynılık yalnız 56 ve 141 karede doğrulandı. 158/175/192/209 karede aynı bayraklar ve aynı ikili zinciri kullanıldı, doğrudan bayt referansı yok (yamasız sürüm bu uzunlukları bu kartta koşamıyor).
- Kalite ayarları düşürülmez: aynı model/nicemleme, 6 adım, cfg 1, 640x384, aynı tohum, parçasız VAE.
- "İlk" iddiası yok: aradık, 4 GB'ta benzer dış örnek bulamadık; bu, yok olduğunun kanıtı değildir.

## Düzen
- `patches/` (sabit stable-diffusion.cpp commit'ine yamalar; notlar orada)
- `scripts/` derleme, çalıştırma, ayrı süreç VAE, kapı/tutarlılık yardımcıları (`doku_norm.py`: ölçek notu için aşağıya bakın)
- `docs/KURULUM.md` donanım, derleme ve çalıştırma adımları (EN+TR)
- `docs/YAMALAR.md` yama listesi, `docs/KANITLAR.md` kanıt, `docs/KAPILAR.md` kalite kapıları tablosu, `docs/OLCUMLER.md` ölçümler, `docs/SIK_HATALAR.md` sık hatalar, `docs/LISANS_UYARISI.md` lisans maddelerinin tamamı
- `scripts/` kısa dizin: `hiz_kos3.ps1` çalıştırma sarmalayıcısı (`-Kuru` tam komutu yazdırır), `uretim_kapi.ps1` kalite kapısı, `dikis_denetim.py` dikiş denetimi, `doku_norm.py` dokuya göre normalize gürültü, `bayt_kiyas.py` bayt karşılaştırma, `derleme_sablonu.ps1` derleme şablonu (yalnız kendi derlemesinden sonra başlayan Visual Studio telemetri yardımcısı `vctip.exe`'yi kapatır; aksi halde derleme sürecini dakikalarca bağlı tutar; diğer `vctip.exe` süreçlerine dokunulmaz)

## Kalite kapıları

Bu kapı hareket tutarlılığını (nesne ölçeği/konum sıçraması) denetlemez: kabul etmeden önce videonun tamamını izleyin.
1. Kare sayısı doğru, ses var, günlükte bellek geri-düşme/ALLOC_FAILED satırı yok.
2. Ham gürültü kapısı: medyan süzgeç artığı <= 1,5 (0-255).
3. Dokuya göre normalize gürültü, `scripts/doku_norm.py` (bu deponun sürümü): N = medyan artık / Sobel doku, her 6. kare. **Ölçek notu:** bu sürümde ölçülen 10 klip N = 0,034-0,052 verir (tablo `docs/KAPILAR.md`; F192/F209V2 son çeyrek 0,062'ye çıkar), ek kapı eşiği N <= 0,065. Başka bir uygulama aynı kliplerde 0,028-0,036 ölçtü, yani eşikler sürümler arasında DEĞİŞTİRİLEMEZ. Çok ince dokuda (çim sırası) temiz N 0,075 çıktı: eşik sahne ailesine göre. Önerilen ek kapı: yüksek frekans bandı sağlam gürültü tahmini (sigma-HH <= 1,5; temiz 0,74-1,19, s=2 gürültüde 2,2-3,0).

Kapsam: VideoTurko TEK geçiş içindir (209 kareye kadar, yaklaşık 8,7 sn). Kendi zincirleme denememizde dikişler görünür oldu (sahne temiz devam etmiyor); bu yüzden daha uzun filmler doğruladığımız şeyin parçası değil. Zincirleme için topluluk rehberi `docs/KLIP_ZINCIRI.md` ve yalnız CPU kullanan yardımcımız `scripts/zincir.py` var (`plan`, `son-kare`, `bagla`; motoru hiç başlatmaz); zincirlenmiş filmlerin kalitesini ölçmedik [denenmedi], bu yüzden her dikişi gözle ve `scripts/dikis_denetim.py` ile kontrol edin.
Ayarlar sizin: 209 kare bizim 4 GB kartta denediğimiz varsayılandır, zorunlu değil. 17k+5 dizisinden istediğiniz kare sayısını seçin (56, 73, ... 192, 209; bkz. `docs/KURULUM.md`); istemi, tohumu, çözünürlüğü ya da herhangi bir bayrağı istediğiniz gibi değiştirin. Kısa video daha az bellek ve süre ister; büyük kartta daha fazlası sığabilir.

## Model lisans uyarısı
**VideoTurko yalnız yamalar ve betikler içerir (MIT); modeli ve çıktıları kullanan kişi MiniMax lisansından kendisi sorumludur.** Hukuki tavsiye değildir. Aşağıda MiniMax H3 Community License (2 Ağustos 2026) maddeleri numaralarıyla özetlenmiştir; bağlayıcı olan lisansın kendisidir: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

Bu deponun MIT lisansı model ağırlıklarını kapsamaz; bkz. [`NOTICE`](NOTICE). Bu depo model ağırlığı İÇERMEZ (MiniMax H3, HyperFlow-H3-Flash GGUF ve VAE dosyaları yok). Bu proje MiniMax ile bağlantılı ya da onaylı değildir. Ticari kullanım yasak DEĞİLDİR (lisans ticari-olmayan lisansı değildir); şartlar aşağıdadır.

**Bölge (Applicable Territory)**
- **Giriş, I.3, I.5:** Lisans dünya geneli, ama Avrupa Birliği, Birleşik Krallık, Güney Kore ve ABD HARİÇ. Modeli kullanmaya başlamak lisansı kabul etmek sayılır.
- **II:** Telifsiz, devredilemez, sınırlı lisans; kullanma, çoğaltma, dağıtma, türev üretme ve değiştirme yalnız bu bölgede ve sözleşme ile Ek A'ya uyarak serbesttir. Hariç bölgelerdeki kişiler MiniMax'tan ayrı lisans isteyebilir.
- **V.4:** Modeli, türevlerini VE ÇIKTILARI (ürettiğiniz video/ses) hariç bölgelerde kullanmak, çoğaltmak, değiştirmek, dağıtmak ya da göstermek için izin verilmemiştir. **Yani üretilen videoyu AB/BK/Güney Kore/ABD'de yayınlamak ya da göstermek lisans dışıdır.**
- **Ek A-1:** Bölge dışı kullanım, kabul edilebilir kullanım politikasının ihlalidir.

**Dağıtım (III)** (bu depo model dağıtmaz; modeli dağıtırsanız)
- **III.1:** Her alıcıya lisansın kopyasını verin. **III.2:** Değiştirdiğiniz dosyalara belirgin değişiklik notu koyun.
- **III.3:** Teşvik edilir (zorunlu değil): ürüne "Powered by MiniMax H3" notu, üretilen dosyalara yapay zekâ etiketi, herkese açık bir yazı.
- **III.4:** Dağıtıma şu metni içeren bir NOTICE dosyası eşlik ETMEK ZORUNDADIR: "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Ek A-12:** makine üretimi olduğunu açıkça söylemeden herkese açık ortama içerik yayma yasaktır: yapay zekâ ile üretilen videoları yayımlarken etiketleyin (tam liste: `docs/LISANS_UYARISI.md`).
- **III (son paragraf):** Değişikliklerinize kendi telifinizi koyabilirsiniz ama kullanım/dağıtım için ek ya da farklı şart koyamazsınız; bölge kuralları geçerli kalır.

**Ticari şartlar (IV)**
- **IV.1:** Ticari ürün/hizmetleriniz yıllık 20 milyon ABD dolarından (ya da karşılığından) fazla gelir getiriyorsa api@minimax.io adresinden ("MiniMax H3 licensing - authorization request" konusuyla) ÖNCEDEN yazılı izin alın.
- **IV.2:** Modeli kullanan ticari ürün/hizmetin arayüzünde "MiniMax H3" belirgin yazılmalıdır.

**Kullanım kısıtları (V)**
- **V.1:** Yürürlükteki yasalara (ticaret/ihracat uyumu dahil) ve Ek A'ya uyun. **V.2:** Modele erişim verdiğiniz herkesi en az bu kısıtlar kadar koruyucu bağlayıcı şartlara bağlayın ve onlara bildirin.
- **V.3:** Modeli ya da ÇIKTILARINI başka bir yapay zekâ modelini geliştirmek için kullanamazsınız (yalnız MiniMax H3 ve türevleri hariç). (I.11: damıtma ve sentetik veriyle eğitim de "türev" sayılır; çıktının kendisi türev sayılmaz.)
- **V.5:** Üçüncü kişilere model ile çıktı ürettiren bir ürün/hizmet/barındırılan hizmet sunarsanız: önce ve süresince makul teknik ve idari güvenlik önlemleri, ihlal bildirim mekanizması, bildirimde hızlı inceleme, içerik kaldırma/erişim kesme ve tekrarlayanı askıya alma yükümlülüğü.

**Marka ve haklar (VI)**
- **VI.1:** Yaptığınız türev işlere ve model türevlerine (MiniMax'ın haklarına tabi) siz sahipsiniz. **VI.2:** MiniMax adı/markası lisanslı değil (yalnız modeli anlatmak/dağıtmak için gerekli ölçüde); "MiniMax H3" markası yalnız III.3 uyumu için bölge içinde kullanılabilir; ortaklık ima etmeyin.
- **VI.3:** MiniMax'a ya da başkasına, materyalin/çıktının hakkınızı ihlal ettiği iddiasıyla dava açarsanız tüm lisanslarınız o gün sona erer; modelin sizce ya da başkalarınca kullanım/dağıtımından doğan üçüncü kişi taleplerinde MiniMax'ı savunur ve tazmin edersiniz.
- **VI.4:** MiniMax çıktılar üzerinde hak iddia etmez; çıktıdan ve sonraki kullanımından siz ve kullanıcılarınız sorumlusunuz.

**Sorumluluk reddi ve fesih (VII, VIII, IX)**
- **VII.1:** MiniMax destek/güncelleme/yeni sürüm vermek zorunda değil. **VII.2:** Model ve çıktılar "OLDUĞU GİBİ", garantisiz; uygunluğu belirlemek ve riski üstlenmek size ait. **VII.3:** MiniMax ve bağlıları hiçbir zarardan sorumlu değildir (yasanın izin verdiği ölçüde).
- **VIII.1:** Sözleşme kabul/erişim anında başlar. **VIII.2:** İhlalde MiniMax feshedebilir; fesihte model kullanımını/dağıtımını hemen bırakır, kopyaları silersiniz ve alıcıları bilgilendirirsiniz (VI.1, VI.3, VII, IX fesihten sonra da sürer).
- **IX:** Geçerli hukuk Hong Kong ÖİB hukukudur; yetkili mahkemeler Hong Kong mahkemeleridir (BM Mal Satımı Sözleşmesi uygulanmaz).
- **Ek not:** MiniMax H3 kodlayıcısı Qwen3-VL-32B (Apache 2.0) kullanır.

**Kabul edilebilir kullanım politikası (Ek A)** (modeli, türevlerini ve çıktıları şunlar için KULLANMAYIN)
- A-1 bölge dışı kullanım; A-2 yasaları ya da üçüncü kişilerin fikri haklarını ihlal; A-3 kendinize/başkasına zarar; A-4 çıktıyı zarar vermek için yeniden kullanma/dağıtma; A-5 güvenlik önlemlerini aşma; A-6 reşit olmayanları sömürme/zarar; A-7 zarar vermek ya da seçimleri etkilemek için doğrulanabilir biçimde yanlış bilgi; A-8 sahte çevrimiçi etkileşim (sahte yorum vb.); A-9 iftira, aşağılama, taciz; A-10 kötü amaçlı yazılım; A-11 zarar vermek için kişisel veri; **A-12 makine üretimi olduğunu açık ve belirgin söylemeden herkese açık ortama (bot gönderileri dahil) içerik yayma**; A-13 rızasız başkasını taklit; A-14 kritik alanlarda (kolluk, göç, sağlık, kritik altyapı, kredi, istihdam, konut, eğitim, sosyal puanlama, sigorta vb.) yüksek riskli otomatik karar; A-15 başka ülke/bölgelerin toplumsal, etik, ahlaki değerlerini ihlal; A-16 şiddet içerikli aşırıcılık/terör; A-17 korunan özelliklere dayalı ayrımcılık/zarar; A-18 savunmasız grupların zayıflığını istismar; **A-19 askeri amaç**; A-20 izinsiz/ruhsatsız mesleki faaliyet (finans, hukuk, tıp vb.).
- Not: Bu metin sade dilde özettir; belirsizlikte lisansın İngilizce metni geçerlidir.

## Kanıt etiketleri

Tüm belgelerde tek set (eski yazımlar parantezde):
- **[ölçtüm]** (EN: measured, olctum): bu projede koşuldu, kanıt yolu var.
- **[okudum]** (EN: read; eski yazım: okudum yol): kaynak ya da betik okundu, koşulmadı.
- **[tasarım]** (EN: design, tasarim): tasarlandı, gerçek koşuda görülmedi.
- **[tahmin]** (EN: guess): doğrulanmadı.
- **[denenmedi]** (EN: not tried): hiç koşulmadı.
- **[kullanıcı bildirdi]** (EN: user-reported): kullanıcı söyledi, tarihli; bağımsız ölçülmedi.
- **[hesap]** (EN: computed; eski yazımlar: calculated): ölçülen girdilerden türetilmiş sayı, kendisi ölçülmedi; hesap yolu yanında yazılı. Eski metindeki [öneri] / [proposal] = [tahmin].

Köşeli parantezde geçen koşu adları (bize ait koşu adları, bu depoda dosya değil): U209 = sürüm ikilisiyle `uret.ps1` üzerinden 209 kare; B209 ve B192 = resimden video (`-InitImg`) 209 ve 192 kare koşuları; B56VT2 = sürüm ikilisi, 56 kare, 56 karelik bayt referansı R0 ile kıyas; F209b, F209V2, F209V2K = geliştirme derlemesinde 209 karelik koşular (ayrıntı: `docs/OLCUMLER.md`).

## Bilinen sınırlar
- **Bayt kanıtı** (kendiniz nasıl üretirsiniz: `docs/KANITLAR.md`, "R0 ve latent referansi nasil uretilir"; sm_61 kartımızda doğrulandı, başka GPU'larda bayt aynı olmayabilir [tahmin]): yama serimizle (bellek bayrakları açık) 56 karelik koşu referansla aynı sha256 `0979f156d548169b...` verdi [ölçtüm]; 141 karede latent sha256 `E5D028F8632BE4FE...` aynı çıktı (0013/0014 bayraklarıyla). 158-209 karede doğrudan bayt referansı yok; kanıt kapı zinciridir. Sayısal kapılardan geçmek iyi klip garantisi vermez: zaman içinde hareket tutarlılığı gözle denetlenir (`docs/KAPILAR.md`).
- **209 kare, hangi bayrak seti:** 209 karelik bayt zinciri kanıtı geliştirme derlemesinde F209V2 bayrak setiyle alındı (blok-sonu bayrağı yok, 0019/0020 yamasız derleme); `uret.ps1` 209 kare için bu tarifi kullanır [okudum: betik; `uret.ps1` üzerinden gerçek motor koşusu U209'da geçti].
- Tek kartta (GTX 1050 Ti 4 GB) tarafımızca doğrulandı; diğer kartlara ait dış raporlar etiketleriyle `docs/KART_PROFILLERI.md` içinde listelenir [kullanıcı bildirdi].
- **Hangi ikili ölçüldü:** 141 kare latent ve bayt zinciri geliştirme derlemelerimizle ölçüldü. İndirdiğiniz sürüm ikilisi yeni bir derlemedir: 56 kare bayt kapısı geçti (sonraki madde) ve `uret.ps1` üzerinden 209 kare koşusu kapıyı geçti (koşu U209, 3414 sn, VRAM tepesi 3777 MiB) [ölçtüm]; geliştirme derlemesi 209 koşusuyla latent bayt-aynı; videoda kareler (md5) ve ses aynı, AVI dosya sha256'sı konteyner nedeniyle farklı [ölçtüm] (`docs/OLCUMLER.md`, bölüm 0).
- **Sürüm ikilisi, 56 kare:** sürüm ikilisi (sd-cli `c5cebe78...`, stable-diffusion.dll `e5d3d329...`) 56 karede R0 ile bayt aynı sonuç verdi (sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`; kare md5 ve ses aynı); doğrudan, varsayılan bayraklarla (hiç `SD_*` yok), çıkış kodu 0, 601 sn [ölçtüm: koşu B56VT2, 2026-11-19; kanıt yazarlarda, bu depoda yok]. Kapsam: yalnız sm_61 kartımız ve 56 kare; temiz kök kurulum testi değil; 141 kare latent ve 209 zinciri eski ikiliyle ölçüldü, bununla TEKRARLANMADI [denenmedi]. İlk deneme (B56VT, yardımcı betikle) 58 sn'de sessizce bitti, neden bilinmiyor [tahmin: bellek baskısı]; ikinci deneme `sd-cli`'yi doğrudan çalıştırdı.
- Kurulum ve çalıştırma betikleri boş klasörde henüz doğrulanmadı (temiz kök testi bekliyor).
- Yol haritası ve sonraki adımlar: `ROADMAP.md`.

## Durum ve sınırlar
- Tek makinede doğrulandı (GTX 1050 Ti 4 GB, 16 GB RAM, i7-7700HQ). Başka 4 GB kartlar ve RAM boyutları farklı olabilir.
- **Varsayılan 209 kare (8,7 sn):** kalite kapılarından geçti (gürültü 1,08, koşu F209V2K) [ölçtüm: 209 kare, sürüm ikilisiyle, `uret.ps1` üzerinden, koşu U209; latent bayt-aynı; videoda kareler ve ses aynı, dosya sha'sı konteyner nedeniyle farklı; kanıt yazarlarda, bu depoda yok]. 209 karede DiT VRAM tepesi 4096 MiB içinde 3777 MiB idi (koşular F209b ve U209; tüm kart için `nvidia-smi` okuması), pay ince: başka GPU yükü (ekran, başka uygulamalar) koşuyu `blocks.0`'da düşürebilir; yalnız GTX 1050 Ti'de denendi. O koşuda ekran durumu kayıtlı değil; ekranınız bu karta bağlıysa kullanılabilir VRAM daha azdır [tahmin: Windows ekran yükü yaklaşık 100-300 MB]; gerekirse ekranı tümleşik GPU'ya bağlayın [tavsiye, denenmedi]. Örnekleme 2730 sn (U209: adımlar 436-483 sn), ayrı süreç VAE çözmesi 173 sn sürdü (2. aşama toplam 193 sn, ses çözme dahil) [ölçtüm: U209 sürüm ikilisi; eski geliştirme koşuları: 2664 sn ve 174 sn]. 1. aşamada süreç içi VAE belleği aşıp parçalı çözmeye düştü (320 sn); o çıktı atılır, video parçasız 2. aşamadan gelir. U209'da RAM tepesi ölçülmedi. 209 kareden uzun klipler bu sürümün parçası değil.
- **Resimden video (`-InitImg`):** başlangıç resmiyle bu GPU'da tavan 192 karedir (24 fps'te 8,0 sn): 209 kare sığmadı (blok 0'da yaklaşık 17,5 MB VRAM eksik: gereken 2587 MB, boş 2570 MB); 192 kare `uret.ps1` ile 3086 sn'de koştu, VRAM tepesi 3783 MiB, kapı geçti [ölçtüm: B209 ve B192 koşuları, 2026-11-20, tek sahne; kanıt yazarlarda, bu depoda yok]. Başka GPU'lar: [denenmedi].
- **Boş RAM önemli:** yaklaşık 11 GB BOŞ RAM gerekir (motor süreci yaklaşık 11 GB tutar) [ölçtüm]. Boş RAM azsa süreç hata mesajı vermeden ölebilir [tahmin: bir kez gözledik, boş RAM yaklaşık 300 MB iken `sd-cli` yaklaşık 10 GB tutuyordu]. Koşu sürerken başka büyük program açmayın: 16 GB'lık makinede boş pay yalnız yaklaşık 0,3-0,5 GB kalır ve bellek baskısında koşu sessizce ölebilir. Başlamadan önce tarayıcı, oyun ve diğer büyük programları kapatın, boş RAM'e bakın.
- **Temiz kök testi bekliyor:** kurulum ve çalıştırma betikleri boş klasörde yalnız bu talimatla henüz doğrulanmadı; test (56 karede referansa bayt kıyası dahil) kaydedilince bu bölüm güncellenir.
- Çıktı videolar depoda yok.

<!-- i18n-source: README.md sha256:67497404d89b -->
