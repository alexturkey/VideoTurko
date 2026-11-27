# VideoTurko uret.ps1: tek komutla video (istem dosyasi + kare sayisi).  EN: one command text-to-video / image-to-video.
# Kullanim / usage:
#   powershell -NoProfile -File scripts\uret.ps1 -Istem istem.txt                       (209 kare, 8,7 sn)
#   powershell -NoProfile -File scripts\uret.ps1 -Istem istem.txt -Kare 141 -Cikti video.avi
#   powershell -NoProfile -File scripts\uret.ps1 -Istem istem.txt -InitImg onceki_son_kare.png   (parca zinciri)
#   powershell -NoProfile -File scripts\uret.ps1 -Istem istem.txt -InitImg ilk.png -EndImg son.png -Kare 107   (ilk + son kare / first + last frame)
#   powershell -NoProfile -File scripts\uret.ps1 -Istem istem.txt -W 384 -H 640 -Kare 56   (dikey / vertical; 32'nin kati, alan >= 640x384)
#   powershell -NoProfile -File scripts\uret.ps1 -Istem istem.txt -Profil yuksek832    (ISTEGE BAGLI: 832x480, 141 kare = 5,9 sn, ~55 dk; yamali hiz motoru gerekir)
#   -Profil: yuksek832 (832x480 x 141 ya da 124 kare) | yuksek896 (896x512 x 124 kare) | uzun260 (640x384 x 260 kare = 10,8 sn, KOSULLU/DENEYSEL). Varsayilan (profilsiz) 640x384 x 209 DEGISMEZ.
#   -Kuru : komutlari ve ortam degiskenlerini yazar, calistirmaz / print only, do not run
#   -TekAsama : iki asamayi elle kapatir (buyuk VRAM'li kartlar icin; 4 GB'da 108+ karede VAE bellege sigmaz) / force single process
# Sabitler (kalite): 6 adim, cfg 1, tohum 42, KAROSUZ VAE (--vae-tiling/--temporal-tiling HICBIR ZAMAN eklenmez).
# Cozunurluk: varsayilan 640x384 (olculen ve bayt kanitli tek boyut). -W/-H: 32'nin kati, alan en az 640x384 (kalite dusurulmez);
#   baska boyutlar 4 GB'da DENENMEDI ve kalite kapisi esikleri 640x384 icin kalibre (baska boyutta uyari basilir).
# -InitImg varken tavan $KareInit kare; ikisi de yokken $KareSabit. -EndImg: kucuk kartta (VRAM < $KucukKartMiB = 8000 MiB ya da okunamadi) HER ZAMAN iki asama ve tavan
#   $KareEnd4GB (175) [olctum 1050 Ti: ilk+son kare tek asamada 56 karede ve iki asamada 192'de sigmadi; iki asamada 56 ve 175 GECTI]; 8 GB ve ustu kartta tavan $KareInit (FLF orada bizce olculmedi).
#   -EndImg tek basina (-InitImg'siz) olculmedi.
# Kare sayisi 17k+5 olmali: 5, 22, 39, 56, 73, 90, 107, 124, 141, 158, 175, 192, 209 (209 = bilinen sinir; daha uzunu DENENMEDI; tavan: $KareSabit / VT_MAX_KARE).
# Not: VRAM tepe 209 karede 3777 MiB olculdu [olctum, tum kart]; daha uzun kareler icin VRAM/RAM verisi yok (denenmedi).
# Iki asama (1: DiT latent'i kaydeder, 2: AYRI surecte VAE cozer) jeton sayisina gore: jeton = (W/32)*(H/32)*latent_kare, latent_kare = ((Kare-5)/17)*5+2;
#   jeton > 7680 ise iki asama. 640x384'te bu "108 kare ve ustu" ile aynidir (107: 7680 tek surec, 124: 8880 iki asama).
# GPU compute capability >= 7.0 ise ve GGML_CUDA_CUBLAS_COMPUTE_TYPE ayarli degilse f32 yapilir (sm89'da >=141 karede fp16 tasmasi -> siyah video; issue #1).
#   GTX 1050 Ti (6.1) icin hicbir sey degismez.
# Ortam / environment: VT_ROOT (varsayilan: bu betigin ust klasoru), VT_ENGINE_BIN (sd-cli.exe klasoru), VT_MODEL_DIR (model dosyalari),
#   VT_CUDA_BIN (cudart/cublas DLL klasoru, istege bagli), VT_PYTHON (kalite kapisi icin python + opencv),
#   VT_MAX_JETON (4 GB kartta standart disi boyut icin jeton tavanini gecici ezer; sonuc garanti degil), VT_GPU_CC / VT_GPU_VRAM (compute capability / toplam VRAM MiB okumasini ezer, test icin).
# Deneysel / teshis anahtarlari (varsayilan KAPALI; ayarlanmazsa varsayilan davranis degismez; bkz. docs\RTX5060_SM120_DERLEME.md):
#   VT_ATTN_BUDGET (0..1, varsayilan 0.05), VT_IKI_ASAMA=1 (iki asamayi zorlar), VT_NO_FA=1 (--flash-attn off),
#   VT_MAX_VRAM (--max-vram, GB, sayi > 0), VT_CHUNK_MB (QKV/MLP chunk MB, 1..4096, varsayilan 64).
#   Gecersiz deger yok sayilir (UYARI). Ayarliysa UYARI yazilir ve runs\olaylar.txt'ye kaydedilir: bu cikti kalite kurallari
#   (AGENTS.md Hard rules) disina cikabilir ve kalite kapisi bunu yakalamaz; olcum ya da paylasim icin kullanmayin.
#   Model/nicemleme degistiren anahtar (alternatif DiT, --tensor-type-rules) bilerek YOK.
# Durdurma / stop: <VT_ROOT>\DUR dosyasi olusturun; betik DURDU yazar, sd-cli'yi kapatir (latent kaldiysa yeniden baslatinca devam etmez, bastan kosar).
param(
    [Parameter(Mandatory)][string]$Istem,
    [int]$Kare = 0,   # 0 = varsayilan: $KareSabit
    [string]$Cikti = "",
    [string]$InitImg = "",
    [int]$TavanDk = 0,
    [int]$Seed = 42,
    [string]$EndImg = "",
    [int]$W = 640,
    [int]$H = 384,
    [string]$Profil = "",   # istege bagli hiz profili (yuksek832 | yuksek896 | uzun260); bos = varsayilan 640x384
    [switch]$TekAsama,
    [switch]$Kuru,
    [switch]$Kontrol
)
$ErrorActionPreference = 'Stop'
$KareSabit = 209   # TEK SABIT SAYI: varsayilan -Kare VE kare tavani (yalniz bu satir degisir). Daha buyuk kare reddedilir (denenmedi).
$KareInit = 192   # TEK SABIT SAYI: -InitImg (resimden/onceki klipten devam) ile en fazla kare (192 / 24 fps = 8,0 sn). Tek GPU, tek sahne olculdu; baska GPU'larda denenmedi.
$KareEnd4GB = 175   # TEK SABIT SAYI: 4 GB kartta -EndImg ile en fazla kare (175 / 24 fps = 7,3 sn; iki asama). 192 sigmadi [olctum 1050 Ti, FLF192 ve FLF175].
$KucukKartMiB = 8000   # TEK SABIT SAYI: bu degerin altindaki (ya da VRAM'i okunamayan) kart 'kucuk' sayilir: -EndImg her zaman iki asama + tavan $KareEnd4GB, standart disi boyutta jeton tavani. 8 GB kartlar 8151-8192 MiB bildirir (8192 degil), bu yuzden esik 8192'nin biraz altinda [olculdu: RTX 4070 Laptop 8188; okundu: docs/KART_PROFILLERI.md, issue #26]. 6 GB ve alti hala kucuk; 8 GB icin jeton tavani olculmedi (dis olcum: 16320 jeton gecti).
$OrtaKartUstMiB = 11000   # TEK SABIT SAYI: 8000 ile bu deger arasindaki kart '8 GB sinifi' sayilir (10 GB dahil, 11 GB ve ustu degil).
$Jeton8GB = 16320   # TEK SABIT SAYI: 8 GB sinifinda standart disi boyutta jeton tavani; RTX 4070 Laptop 1280x768 56 kare = 16320 jeton gecti, 23328 sigmadi [kullanici bildirdi, issue #26]; bizce olculmedi.
$KareVarsayilan = ($Kare -eq 0)
if ($Kare -eq 0) { $Kare = $(if ($InitImg -or $EndImg) { $KareInit } else { $KareSabit }) }
$Root = $(if ($env:VT_ROOT) { $env:VT_ROOT } else { (Resolve-Path (Join-Path $PSScriptRoot '..')).Path })
$Motor = $(if ($env:VT_ENGINE_BIN) { $env:VT_ENGINE_BIN } else { Join-Path $Root 'engine\bin' })
$ModelDir = $(if ($env:VT_MODEL_DIR) { $env:VT_MODEL_DIR } else { Join-Path $Root 'model' })
. (Join-Path $PSScriptRoot 'kart.ps1')   # kart tanima + scripts/kart_tablosu.json (yalniz okur)
$KartTabloU = Kart-Tablo-Oku (Join-Path $PSScriptRoot 'kart_tablosu.json')
# kur.ps1 secilen motoru engine\secili_motor.json'a yazar; VT_ENGINE_BIN verilirse o kazanir. Dosya yoksa eski yol (engine\bin): GTX 1050 Ti ve eski kurulumlar degismez.
$Secili = $null; $SeciliYol = Join-Path (Join-Path $Root 'engine') 'secili_motor.json'
if (Test-Path -LiteralPath $SeciliYol) { try { $Secili = (Get-Content -LiteralPath $SeciliYol -Raw -Encoding UTF8 | ConvertFrom-Json) } catch { $Secili = $null } }
$MotorStock = $false
if ($Secili -and $Secili.motor) {
    if (-not $env:VT_ENGINE_BIN -and $Secili.bin) { $Motor = Join-Path $Root ([string]$Secili.bin -replace '/', '\') }
    $MotorStock = ([string]$Secili.motor -like 'stock_*')
    # VT_ENGINE_BIN baska bir klasoru gosteriyorsa secili_motor.json'daki TUR o klasore ait degil (issue #24): o klasor release (yamali) motor sayilir.
    # Kendi stock motorunuzu VT_ENGINE_BIN ile veriyorsaniz VT_ENGINE_TYPE=stock yazin; yamali motoru zorlamak icin VT_ENGINE_TYPE=release.
    if ($env:VT_ENGINE_BIN -and $Secili.bin) {
        $tipFark = $false
        try { $tipFark = ([IO.Path]::GetFullPath($env:VT_ENGINE_BIN).TrimEnd('\','/') -ne [IO.Path]::GetFullPath((Join-Path $Root ([string]$Secili.bin -replace '/', '\'))).TrimEnd('\','/')) } catch { $tipFark = $false }
        if ($tipFark) { $MotorStock = $false; Write-Output ("bilgi: VT_ENGINE_BIN secili motor klasorunden ({0}) farkli: motor turu release (yamali, iki asama) sayildi; stock ise VT_ENGINE_TYPE=stock verin" -f $Secili.motor) }
    }
}
if ($env:VT_ENGINE_TYPE) {
    switch -Regex ($env:VT_ENGINE_TYPE.Trim().ToLowerInvariant()) {
        '^stock' { $MotorStock = $true; if (-not ($Secili -and $Secili.motor)) { $Secili = [pscustomobject]@{ motor = 'stock_elle'; bin = ''; kart_sinifi = '' } }; Write-Output "bilgi: VT_ENGINE_TYPE=stock: motor turu stock (tek surec)"; break }
        '^release' { $MotorStock = $false; Write-Output "bilgi: VT_ENGINE_TYPE=release: motor turu release (yamali, iki asama)"; break }
        default { Write-Output ("UYARI: VT_ENGINE_TYPE='{0}' tanimsiz (stock | release), yok sayildi" -f $env:VT_ENGINE_TYPE) }
    }
}

# --- GPU bilgisi (yalniz okuma; okunamazsa -1 ve hicbir sey degismez) ---
$GpuTop = -1; $GpuCc = -1.0; $GpuSayi = 0
$Inv = [Globalization.CultureInfo]::InvariantCulture; $Flt = [Globalization.NumberStyles]::Float
if (Get-Command nvidia-smi.exe -ErrorAction SilentlyContinue) {
    # Birden cok GPU: sd-cli CUDA 0'i kullanir, nvidia-smi sirasi farkli olabilir. Temkinli taraf: EN KUCUK toplam VRAM ve EN KUCUK compute capability
    #   (f32 yalniz tum kartlar >= 7.0 ise). Herhangi bir kartin cc'si okunamazsa cc okunamadi (-1) sayilir. Yalniz tek GPU ile olculdu.
    try { foreach ($qm in @(& nvidia-smi.exe --query-gpu=memory.total --format=csv,noheader,nounits 2>$null)) { $tmpM = 0; if ([int]::TryParse(("$qm").Trim(), [ref]$tmpM) -and $tmpM -gt 0) { $GpuSayi++; if ($GpuTop -lt 0 -or $tmpM -lt $GpuTop) { $GpuTop = $tmpM } } } } catch { }
    try { $ccIlk = $true; foreach ($qc in @(& nvidia-smi.exe --query-gpu=compute_cap --format=csv,noheader,nounits 2>$null)) { $tmpC = 0.0; if ([double]::TryParse(("$qc").Trim(), $Flt, $Inv, [ref]$tmpC)) { if ($ccIlk -or $tmpC -lt $GpuCc) { $GpuCc = $tmpC }; $ccIlk = $false } else { $GpuCc = -1.0; break } } } catch { $GpuCc = -1.0 }
}
# Test ezmeleri: ondalik virgul de kabul (7,5 = 7.5); okunamazsa acik uyari, yok sayilir.
if ($env:VT_GPU_CC) { $tmpC = 0.0; if ([double]::TryParse($env:VT_GPU_CC.Trim().Replace(',', '.'), $Flt, $Inv, [ref]$tmpC)) { $GpuCc = $tmpC } else { Write-Output ("UYARI: VT_GPU_CC='{0}' sayi olarak okunamadi, yok sayildi (ornek: 8.9 ya da 8,9)" -f $env:VT_GPU_CC) } }
if ($env:VT_GPU_VRAM) { $tmpV = 0.0; if ([double]::TryParse($env:VT_GPU_VRAM.Trim().Replace(',', '.'), $Flt, $Inv, [ref]$tmpV) -and $tmpV -gt 0) { $GpuTop = [int][Math]::Floor($tmpV) } else { Write-Output ("UYARI: VT_GPU_VRAM='{0}' sayi (MiB) olarak okunamadi, yok sayildi (ornek: 12282)" -f $env:VT_GPU_VRAM) } }
if ($GpuSayi -gt 1) { Write-Output ("bilgi: {0} GPU goruldu; sd-cli CUDA 0'i kullanir. Betik temkinli tarafla karar verir: en kucuk VRAM {1} MiB, en kucuk compute capability {2} (f32 yalniz tum kartlar >= 7.0 ise). Yalniz tek GPU ile olculdu; karti CUDA_VISIBLE_DEVICES ile secebilirsiniz." -f $GpuSayi, $GpuTop, $(if ($GpuCc -lt 0) { 'okunamadi' } else { $GpuCc.ToString($Inv) })) }
if ($GpuCc -ge 12.0 -and -not $MotorStock) { Write-Output ("UYARI: [VT-W-BLACKWELL] compute capability {0} (RTX 50 serisi / Blackwell): hazir motor yalniz sm_61 icin derli; bir kullanici bu kartta 56+ karede siyah video bildirdi (v0.1.0 betigiyle; v0.1.1 f32 ayariyla denenmedi). Once 56 kare deneyin; video siyahsa iki yol var: (a) stable-diffusion.cpp (leejet) hazir CUDA surumu master-1106-532d2c1, derleme dosyasinda sm_120 dahil [okudum], bu kartta denenmedi, bizim bellek yamalarimiz yok: dis rapor docs\KART_PROFILLERI.md; (b) motoru sm_120 icin derleyip VT_ENGINE_BINi ona verin: docs\RTX5060_SM120_DERLEME.md. Kendi sm_120 derlemenizi kullaniyorsaniz bu uyariyi yok sayin." -f $GpuCc.ToString($Inv)) }
# Kart sinifi (scripts/kart_tablosu.json): ek ayar (f32, model argumani). NVIDIA: compute capability'den (eski cc >= 7.0 kuraliyla ayni sonuc); cc okunamazsa (AMD) kur.ps1'in yazdigi sinif.
$SinifU = $null
if ($GpuCc -ge 0) { $SinifU = Kart-Sinif $KartTabloU 'nvidia' $GpuCc }
elseif ($Secili -and $Secili.kart_sinifi) { foreach ($ks in $KartTabloU.kartlar) { if ($ks.id -eq [string]$Secili.kart_sinifi) { $SinifU = $ks } } }
$KucukKart = ($GpuTop -lt $KucukKartMiB)   # VRAM okunamadiysa (-1) kucuk sayilir (temkinli)
# 8 GB sinifi (8000 <= VRAM < 11000 MiB): jeton tavani $Jeton8GB (issue #26: RTX 4070 Laptop 16320 jeton gecti [kullanici bildirdi]); -EndImg eski kuralda (yalniz < $KucukKartMiB kisitli).
$OrtaKart = (-not $KucukKart) -and ($GpuTop -lt $OrtaKartUstMiB)
$EndKisit = $KucukKart   # -EndImg kisiti yalniz kucuk kartta (8 GB sinifi eski davranis: 192 kare, PR #16)
$KareEndTavan = $(if ($EndKisit) { $KareEnd4GB } else { $KareInit })
if ($EndImg -and $KareVarsayilan) { $Kare = $KareEndTavan }

# --- Istege bagli hiz profilleri (kullanici karari 2026-11-27: kullanilabilir ama ISTEGE BAGLI; varsayilan 640x384 x 209 degismez) ---
# Her profil GTX 1050 Ti 4 GB'ta OLCULMUS tek bir hucredir (docs/OLCUMLER.md "Hiz paketi", patches/sdcpp/22, 24, 25 notlari). Yalniz yamali hiz motoruyla kosar:
#   engine\bin\HIZ_PAKETI.txt (motor zip'inde gelir; yama 0021 + 0023 + 0024). Eski motor bayraklari sessizce yok sayar ve ~1 saat sonra bellekte dusersiniz: bu yuzden once reddedilir.
#   Kendi derlediginiz motor icin VT_HIZ_MOTOR=1 (UYARI; sonuc garanti degil).
$ProfilAd = "$Profil".Trim().ToLowerInvariant()
$ProfilKareler = @(); $ProfilVarsayilanKare = 0; $ProfilYama = @(); $ProfilDeneysel = $false; $ProfilSure = ''
$ProfilEnv1 = [ordered]@{}; $ProfilEnv2 = [ordered]@{}
if ($ProfilAd) {
    if ($ProfilAd -eq 'yuksek832') {
        $PW = 832; $PH = 480; $ProfilKareler = @(124, 141); $ProfilVarsayilanKare = 141; $ProfilYama = @('0021', '0024'); $ProfilSure = '141 kare ~55-56 dk, 124 kare ~45-46 dk [olctum]'
        $ProfilEnv1['SD_ATTN_HEAD_QKV'] = '1'; $ProfilEnv2['SD_VAE_BLOCK_SPLIT'] = '2'
    } elseif ($ProfilAd -eq 'yuksek896') {
        $PW = 896; $PH = 512; $ProfilKareler = @(124); $ProfilVarsayilanKare = 124; $ProfilYama = @('0021', '0024'); $ProfilSure = '~56-58 dk [olctum]'
        $ProfilEnv1['SD_ATTN_HEAD_QKV'] = '1'; $ProfilEnv2['SD_VAE_BLOCK_SPLIT'] = '2'
    } elseif ($ProfilAd -eq 'uzun260') {
        $PW = 640; $PH = 384; $ProfilKareler = @(260); $ProfilVarsayilanKare = 260; $ProfilYama = @('0021', '0023'); $ProfilDeneysel = $true; $ProfilSure = '~71-72 dk [tahmin: erken cikisli 260 kare uctan uca olculmedi]; erken cikissiz 78 dk olculdu'
        $ProfilEnv1['SD_ATTN_HEAD_QKV'] = '1'
        $ProfilEnv2['SD_VRAM_MARGIN_MB'] = '1'; $ProfilEnv2['SD_VAE_VRAM_MARGIN_MB'] = '1'; $ProfilEnv2['SD_VRAM_SHORT_OK_MB'] = '32'
    } else { throw "[VT-E-PROFIL] bilinmeyen -Profil '$Profil' (yuksek832 | yuksek896 | uzun260; bos birakirsaniz varsayilan 640x384)" }
    if ($InitImg -or $EndImg -or $TekAsama) { throw "[VT-E-PROFIL] -Profil $ProfilAd ile -InitImg / -EndImg / -TekAsama birlikte kullanilmaz (profil yalniz olculen metinden-videoya iki asamali hucredir)" }
    if (($PSBoundParameters.ContainsKey('W') -and $W -ne $PW) -or ($PSBoundParameters.ContainsKey('H') -and $H -ne $PH)) { throw "[VT-E-PROFIL] -Profil $ProfilAd boyutu ${PW}x${PH}'dir; verilen -W/-H farkli (profili birakin ya da -W/-H vermeyin)" }
    $W = $PW; $H = $PH
    if ($KareVarsayilan) { $Kare = $ProfilVarsayilanKare }
    if ($ProfilKareler -notcontains $Kare) { throw ("[VT-E-PROFIL] -Profil {0} yalniz olculen kare sayilarinda calisir: {1} (verilen: {2}). Baska sayi icin profilsiz kosun ({3} kareye kadar 640x384)." -f $ProfilAd, ($ProfilKareler -join ' / '), $Kare, $KareSabit) }
}

# --- dogrulamalar ---
if ($Kare -lt 5 -or (($Kare - 5) % 17) -ne 0) { throw "[VT-E-KARE] Kare sayisi 17k+5 olmali (5, 22, 39, ... 17k+5; en fazla $KareSabit). Verilen: $Kare" }
if ($InitImg -and $Kare -gt $KareInit) { throw "[VT-E-KARE] -InitImg ile en fazla $KareInit kare (8,0 sn) desteklenir: bu GPU'da $KareSabit kare -InitImg ile bellege sigmadi; baska GPU'larda denenmedi. -Kare $KareInit ya da daha kucugunu verin. Verilen: $Kare" }
if ($EndImg -and $EndKisit -and $Kare -gt $KareEnd4GB) { throw "[VT-E-KARE] -EndImg ile bu kartta (VRAM $(if ($GpuTop -lt 0) { 'okunamadi, 8 GB alti sayildi' } else { "$GpuTop MiB; 8 GB alti" })) en fazla $KareEnd4GB kare (7,3 sn): 192 bu kartta sigmadi, 175 olculdu (GTX 1050 Ti, iki asama). -Kare $KareEnd4GB ya da daha kucugunu verin. Verilen: $Kare" }
if ($EndImg -and $Kare -gt $KareInit) { throw "[VT-E-KARE] -EndImg ile en fazla $KareInit kare (8,0 sn) desteklenir (-InitImg ile ayni tavan; 8 GB ve ustu kartta FLF bizce olculmedi). -Kare $KareInit ya da daha kucugunu verin. Verilen: $Kare" }
# Kare tavani = $KareSabit (dogrulanan en uzun kare). VT_MAX_KARE ile gecici ezilir (sonuc garanti degil).
$KareTavan = $(if ($ProfilAd) { ($ProfilKareler | Measure-Object -Maximum).Maximum } elseif ($env:VT_MAX_KARE) { [int]$env:VT_MAX_KARE } else { $KareSabit })
if ($Kare -gt $KareTavan) { throw "[VT-E-KARE] Kare sayisi $KareTavan degerinden buyuk desteklenmiyor (denenmedi). Verilen: $Kare" }
# Cozunurluk: motor W/H'yi 32'nin katina YUKARI yuvarlar (720 -> 736); sessiz degisiklik olmasin diye burada reddedilir.
if ($PSBoundParameters.ContainsKey('W') -xor $PSBoundParameters.ContainsKey('H')) { throw "[VT-E-BOYUT] -W ve -H birlikte verilmeli (yalniz biri verilirse oteki 640/384 kalir ve beklenmedik boyut cikar). Dikey: -W 384 -H 640. Verilen: ${W}x${H}" }
if ($W -le 0 -or $H -le 0 -or ($W % 32) -ne 0 -or ($H % 32) -ne 0) { throw "[VT-E-BOYUT] -W ve -H 32'nin kati olmali (motor yukari yuvarlar: 720 -> 736). Ornek: 640x384, 384x640, 832x480, 1280x736. Verilen: ${W}x${H}" }
if (($W * $H) -lt (640 * 384)) { throw "[VT-E-BOYUT] -W x -H alani en az 640x384 (245760 piksel) olmali: kalite dusurulmez. Dikey icin -W 384 -H 640. Verilen: ${W}x${H}" }
$Standart = ($W -eq 640 -and $H -eq 384)
$LatKare = $(if ($Kare -le 5) { 2 } else { [int][Math]::Floor(($Kare - 5) / 17) * 5 + 2 })
$Jeton = [int](($W / 32) * ($H / 32) * $LatKare)
# Kucuk kart (VRAM < $KucukKartMiB ya da okunamadi): standart disi boyutta jeton tavani = 640x384'te olculen en buyuk (209 kare 14880; -InitImg ile 192 kare 13680; -EndImg ile 175 kare 12480).
$JetonTavan = $(if ($EndImg) { 12480 } elseif ($InitImg) { 13680 } elseif ($OrtaKart) { $Jeton8GB } else { 14880 })
if ($env:VT_MAX_JETON) { $JetonTavan = [int]$env:VT_MAX_JETON }
if (-not $Standart -and -not $ProfilAd -and ($KucukKart -or $OrtaKart -or $env:VT_MAX_JETON) -and $Jeton -gt $JetonTavan) {
    throw ("[VT-E-BOYUT] {0}x{1} ve {2} kare = {3} jeton; bu kartta tavan {4} jeton ({7}; VRAM {5}). Daha kisa -Kare ya da daha kucuk boyut verin; VT_MAX_JETON ile gecici ezilir (sonuc garanti degil){6}.{8}" -f $W, $H, $Kare, $Jeton, $JetonTavan, $(if ($GpuTop -lt 0) { 'okunamadi, 8 GB alti sayildi' } else { "$GpuTop MiB" }), $(if ($GpuTop -lt 0) { '; nvidia-smi VRAM okuyamadi: buyuk kartiniz varsa VT_GPU_VRAM=<MiB> ile toplam VRAM verilebilir (test amacli, sonuc garanti degil)' } else { '' }), $(if ($OrtaKart -and -not $EndImg -and -not $InitImg) { '8 GB sinifinda bildirilen en buyuk is 16320 jeton, bizce olculmedi' } else { '4 GB''da olculen en buyuk is' }), $(if ($KucukKart -and -not $EndImg -and -not $InitImg) { ' Olculen yuksek cozunurluk hucreleri (istege bagli, yamali hiz motoru gerekir): -Profil yuksek832 (832x480 x 141 kare) ya da -Profil yuksek896 (896x512 x 124 kare).' } else { '' }))
}
if ($ProfilAd) {
    if ($MotorStock) { throw "[VT-E-PROFIL] -Profil $ProfilAd yamali hiz motoru ister; secili motor stock (yama anahtarlari yok). Profilsiz kosun." }
    if (-not $Kuru -and $env:VT_HIZ_MOTOR -ne '1') {
        $hizDosya = Join-Path $Motor 'HIZ_PAKETI.txt'; $hizYama = ''
        if (Test-Path -LiteralPath $hizDosya) { try { $hizYama = (Get-Content -LiteralPath $hizDosya -Raw -Encoding UTF8) } catch { $hizYama = '' } }
        $hizEksik = @($ProfilYama | Where-Object { $hizYama -notmatch $_ })
        if ($hizEksik.Count -gt 0) { throw ("[VT-E-MOTOR-ESKI] -Profil {0} icin motorda {1} yamasi gerekli ({2} bulunamadi: {3}). Eski motor bayraklari yok sayar ve ~1 saat sonra bellekte dusersiniz. Hiz paketi motor zip'ini kurun (scripts\kur.ps1) ya da kendi derlediginiz motor icin VT_HIZ_MOTOR=1 verin." -f $ProfilAd, ($ProfilYama -join ' + '), $hizDosya, ($hizEksik -join ' ')) }
    }
    if (-not $Kuru -and $env:VT_HIZ_MOTOR -eq '1') { Write-Output 'UYARI: VT_HIZ_MOTOR=1: motordaki hiz yamalari (0021/0023/0024) sizin sorumlulugunuzda; sonuc garanti degil.' }
}
if (-not (Test-Path -LiteralPath $Istem)) { throw "[VT-E-ISTEM] istem dosyasi yok: $Istem" }
if ($InitImg -and -not (Test-Path -LiteralPath $InitImg -PathType Leaf)) { throw "[VT-E-ISTEM] -InitImg dosyasi bulunamadi: $InitImg (ilk kare gorseli, PNG/JPG; video boyutunda verin)" }
if ($EndImg -and -not (Test-Path -LiteralPath $EndImg -PathType Leaf)) { throw "[VT-E-ISTEM] -EndImg dosyasi bulunamadi: $EndImg (son kare gorseli, PNG/JPG; video boyutunda verin, motor farkli boyutu esnetir)" }
# --- deneysel VT_* anahtarlari: dogrula; gecersizse varsayilan + UYARI; aktifse UYARI + olaylar kaydi ---
$VtAktif = @()
$VtAttn = '0.05'; $VtChunk = '64'; $VtMaxVram = ''; $VtNoFa = $false; $VtIki = $false
if ($env:VT_ATTN_BUDGET) { $tmpA = 0.0; if ([double]::TryParse($env:VT_ATTN_BUDGET.Trim().Replace(',', '.'), $Flt, $Inv, [ref]$tmpA) -and $tmpA -ge 0 -and $tmpA -le 1) { $VtAttn = $tmpA.ToString($Inv); $VtAktif += "VT_ATTN_BUDGET=$VtAttn" } else { Write-Output ("UYARI: VT_ATTN_BUDGET='{0}' 0 ile 1 arasi sayi olarak okunamadi, yok sayildi" -f $env:VT_ATTN_BUDGET) } }
if ($env:VT_CHUNK_MB) { $tmpC2 = 0; if ([int]::TryParse($env:VT_CHUNK_MB.Trim(), [Globalization.NumberStyles]::Integer, $Inv, [ref]$tmpC2) -and $tmpC2 -ge 1 -and $tmpC2 -le 4096) { $VtChunk = "$tmpC2"; $VtAktif += "VT_CHUNK_MB=$VtChunk" } else { Write-Output ("UYARI: VT_CHUNK_MB='{0}' 1..4096 tam sayi (MB) olarak okunamadi, yok sayildi" -f $env:VT_CHUNK_MB) } }
if ($env:VT_MAX_VRAM) { $tmpM = 0.0; if ([double]::TryParse($env:VT_MAX_VRAM.Trim().Replace(',', '.'), $Flt, $Inv, [ref]$tmpM) -and $tmpM -gt 0 -and $tmpM -le 1024) { $VtMaxVram = $tmpM.ToString($Inv); $VtAktif += "VT_MAX_VRAM=$VtMaxVram" } else { Write-Output ("UYARI: VT_MAX_VRAM='{0}' sayi (> 0) olarak okunamadi, yok sayildi" -f $env:VT_MAX_VRAM) } }
if ($env:VT_NO_FA -eq '1') { $VtNoFa = $true; $VtAktif += 'VT_NO_FA=1' }
if ($env:VT_IKI_ASAMA -eq '1') { $VtIki = $true; $VtAktif += 'VT_IKI_ASAMA=1' }
if ($VtAktif.Count -gt 0) {
    $VtMesaj = 'UYARI: [VT-W-DENEYSEL] deneysel VT_* aktif (' + ($VtAktif -join ' ') + '); cikti kalite kurallari disina cikabilir, kalite kapisi bunu yakalamaz: olcum/paylasim icin kullanmayin'
    Write-Output $VtMesaj
    if (-not $Kuru) { try { New-Item -ItemType Directory -Force (Join-Path $Root 'runs') | Out-Null; Add-Content -LiteralPath (Join-Path $Root 'runs\olaylar.txt') -Value ((Get-Date -Format 'HH:mm:ss') + ' | ' + $VtMesaj) -Encoding ASCII } catch { } }
}
if (-not $env:VT_ATTN_BUDGET) { $ekB = Kart-Ek-Model-Arg $SinifU 'minimax_h3_attn_chunk_budget'; if ($ekB) { $VtAttn = $ekB } }   # tablodan olculmus ek ayar (bellek butcesi; kalite ayari degil)
if ($MotorStock) { Write-Output ("bilgi: stable-diffusion.cpp stock motoru ({0}); kart sinifi {1} (durum: {2}); motor klasoru {3}. Tek surec (iki asamali repo yamalari yok); kalite ayarlari ayni, kalite kapisi calisir. Bakimcilar bu kart sinifinda uret.ps1 yolunu olcmedi: docs/KART_PROFILLERI.md." -f $Secili.motor, $(if ($SinifU) { $SinifU.id } else { '?' }), (Kart-Durum $SinifU ''), $Motor) }
$sd = Join-Path $Motor 'sd-cli.exe'
$DiT = Join-Path $ModelDir 'minimax_h3_fl2va_hyperflow_flash_14b-Q4_K_M.gguf'
$TE = Join-Path $ModelDir 'qwen3vl_32b_minimax_h3-Q4_K_M.gguf'
$VAE = Join-Path $ModelDir 'minimax_h3_sol_vae_fp16.safetensors'
$AVAE = Join-Path $ModelDir 'minimax_h3_audio_vae_fp32.safetensors'
if (-not $Kuru) {
    foreach ($f in @($sd, $DiT, $TE, $VAE, $AVAE)) { if (-not (Test-Path -LiteralPath $f)) { throw "[VT-E-DOSYA] dosya yok: $f (once scripts\kur.ps1 calistirin)" } }
    if ($InitImg -and -not (Test-Path -LiteralPath $InitImg)) { throw "InitImg yok: $InitImg" }
}

# --- cikti yeri ---
if (-not $Cikti) { $Cikti = Join-Path $Root ("runs\{0}_{1}kare\video.avi" -f (Get-Date -Format 'yyyyMMdd-HHmmss'), $Kare) }
if (-not [IO.Path]::IsPathRooted($Cikti)) { $Cikti = Join-Path (Get-Location).Path $Cikti }
if ([IO.Path]::GetExtension($Cikti) -ne '.avi') { $Cikti = [IO.Path]::ChangeExtension($Cikti, '.avi') }
$Dizin = Split-Path -Parent $Cikti
$Ad = [IO.Path]::GetFileNameWithoutExtension($Cikti)
$Latent = Join-Path $Dizin ($Ad + '_latent.bin')
$Istem = (Resolve-Path -LiteralPath $Istem).Path
if ($InitImg) { $InitImg = (Resolve-Path -LiteralPath $InitImg).Path }
if ($EndImg) { $EndImg = (Resolve-Path -LiteralPath $EndImg).Path }
$AlanKat = ($W * $H) / 245760.0   # 640x384 = 1,0 (varsayilanda tavan degismez)
if ($TavanDk -le 0) { $TavanDk = [int][Math]::Max(30, [Math]::Ceiling(80.0 * $Kare / 209 * $AlanKat)) }   # 209 kare = 80 dk (olculen ~48 dk DiT + VAE, x1,4 pay); alanla olceklenir

function Ortak-Arg([string]$Out) {
    $faVal = $(if ($VtNoFa) { 'off' } else { 'off,diffusion=on' })
    $a = @('-M', 'vid_gen', '--diffusion-model', $DiT, '--llm', $TE, '--vae', $VAE, '--audio-vae', $AVAE,
        '--prompt-file', $Istem, '-W', "$W", '-H', "$H", '--video-frames', "$Kare", '--fps', '24',
        '--steps', '6', '--sampling-method', 'euler', '--sigmas', 'hyperflow-h3-flash-6', '--cfg-scale', '1.0',
        '--rng', 'cpu', '--seed', "$Seed", '-t', '4', '--flash-attn', $faVal,   # varsayilan: eski --diffusion-fa ile ayni ayar
        '--model-args', "minimax_h3_attn_chunk_budget=$VtAttn",
        '--offload-to-cpu', '--mmap', '--backend', 'te=cpu')
    if ($VtMaxVram) { $a += @('--max-vram', $VtMaxVram) }
    if ($InitImg) { $a += @('--init-img', $InitImg) }
    if ($EndImg) { $a += @('--end-img', $EndImg) }
    $a += @('--log-level', 'debug', '-o', $Out)
    return $a
}
# Ortam: jeton > 7680 iki asama (640x384'te 108+ kare ile ayni; dogrulanmis tarif: 209 icin DiT asamasi + ayri VAE asamasi; 141 icin ayri VAE kare+ses md5 bayt aynisi).
# -TekAsama: elle tek surec (buyuk VRAM'li kart); varsayilan degismez.
# -EndImg kucuk kartta (< $KucukKartMiB) her zaman iki asama: tek asamada 56 karede bile sigmadi [olctum 1050 Ti FLF56; iki asamada FLF56b GECTI].
$IkiAsama = (($Jeton -gt 7680) -or ($EndImg -and $EndKisit) -or $VtIki) -and -not $TekAsama
if ($MotorStock) { $IkiAsama = $false }   # stock motorda SD_* yama anahtarlari yok: iki asama anlamsiz, tek surec
$Env1 = [ordered]@{}
$Env2 = [ordered]@{}
$ChunkMB = $VtChunk
if ($IkiAsama) {
    $Env1['SD_VRAM_MARGIN_MB'] = '1'; $Env1['SD_H3_EMBED_CUT'] = '1'; $Env1['SD_H3_DROP_QUEUED'] = '1'; $Env1['SD_H3_EVICT_PAST'] = '1'
    $Env1['SD_ATTN_SET_OUT'] = '1'; $Env1['SD_QKV_CHUNK_MB'] = $ChunkMB; $Env1['SD_QKV_SET_OUT'] = '1'; $Env1['SD_MLP_CHUNK_MB'] = $ChunkMB
    $Env1['SD_VIDEO_LATENT_SAVE'] = $Latent   # F209b/F209V2 tarifi; MLP_SET_OUT KAPALI (bellegi artirir)
    $Env2['SD_VRAM_MARGIN_MB'] = '256'; $Env2['SD_VAE_VRAM_MARGIN_MB'] = '256'; $Env2['SD_CUT_CACHE_HOST_MB'] = '100'
    $Env2['SD_VAE_NO_TILING_FALLBACK'] = '1'; $Env2['SD_VAE_EMBED_CUT'] = '1'; $Env2['SD_VIDEO_LATENT_LOAD'] = $Latent
} else {
    $Env1['SD_VAE_NO_TILING_FALLBACK'] = '1'
}
if ($ProfilAd -and $IkiAsama) {
    foreach ($k in $ProfilEnv1.Keys) { $Env1[$k] = $ProfilEnv1[$k] }
    foreach ($k in $ProfilEnv2.Keys) { $Env2[$k] = $ProfilEnv2[$k] }
    Write-Output ("bilgi: -Profil {0}: {1}x{2}, {3} kare ({4} sn), iki asama; asama 1 +{5}, asama 2 +{6}; sure {7}. GTX 1050 Ti 4 GB'ta olculen hucredir; bellek payi dar (tek haneli MB): kartta baska surec yer tutuyorsa sigmayabilir, o zaman profilsiz kosun. Varsayilan 640x384 x {8} degismedi." -f $ProfilAd, $W, $H, $Kare, ([Math]::Round($Kare / 24.0, 1).ToString($Inv)), (($ProfilEnv1.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join ' '), (($ProfilEnv2.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join ' '), $ProfilSure, $KareSabit)
    if ($ProfilDeneysel) { Write-Output 'UYARI: [VT-W-DENEYSEL] uzun260 KOSULLU ve DENEYSEL: bellek siniri cok dar (VRAM tepe 3903 / 4096 MiB, paylasimli bellek artisi +61 / +68 MiB), bayraksiz referans yok (cikti tekrarlanabilir, surum-esit degil), repo uret.ps1 yolunda 260 kare uctan uca olculmedi. Yama 0023 yalniz bu hucre icin kabul edildi.' }
}
# cuBLAS f32: compute capability >= 7.0 ve kullanici ayarlamadiysa (sm89'da fp16 >=141 karede tasiyor: siyah video, issue #1). 6.1 (1050 Ti) ve okunamayan cc: dokunulmaz.
$EkEnvU = Kart-Ek-Env $SinifU   # kart_tablosu.json: cc >= 7.0 siniflarinda GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32; kullanici kendisi ayarladiysa dokunulmaz
foreach ($ek in $EkEnvU.Keys) { if (-not [Environment]::GetEnvironmentVariable($ek)) { $Env1[$ek] = $EkEnvU[$ek]; $Env2[$ek] = $EkEnvU[$ek] } }

# Kalite kapisi on kontrolu, GPU isinden ONCE: python + opencv + numpy calistirilarak denenir (Windows'ta python kurulu degilken bile
#   Microsoft Store kisayolu WindowsApps\python.exe bulunur ve 9009 ile cikar; Get-Command yetmez). Basarisizsa video uretilmez, cikis 6.
#   -Kontrol (kur.ps1 kontrol uretimi, kapi yok): atlanir. -Kuru: yalniz bilgi satiri.
if (-not $Kontrol) {
    $pyK = $(if ($env:VT_PYTHON) { $env:VT_PYTHON } elseif (Test-Path -LiteralPath (Join-Path $Root '.venv/Scripts/python.exe')) { Join-Path $Root '.venv/Scripts/python.exe' } else { 'python' }); $pyTamam = $false; $pyKod = 'bulunamadi'
    if (Get-Command $pyK -ErrorAction SilentlyContinue) {
        $eapP = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
        try { $null = & $pyK -I -c "import cv2, numpy" 2>&1; $pyKod = "$LASTEXITCODE"; $pyTamam = ($LASTEXITCODE -eq 0) } catch { $pyKod = 'calistirilamadi' } finally { $ErrorActionPreference = $eapP }
    }
    if (-not $pyTamam) {
        $pyMesaj = "KAPI CALISAMAZ: [VT-E-PY] python + opencv-python + numpy hazir degil ($pyK, sonuc $pyKod; 9009 = Windows Store kisayolu, python kurulu degil). Python 3 kurun (python.org), sonra 'py -3 -m pip install opencv-python numpy'; ya da VT_PYTHON ile python.exe yolunu verin. Dis iz birakmamak icin: kokte venv kurun ('py -3 -m venv <VT_ROOT>/.venv'), paketi oradan yukleyin ('<VT_ROOT>/.venv/Scripts/python.exe -m pip install --cache-dir <VT_ROOT>/.onbellek/pip opencv-python numpy'); .venv varsa VT_PYTHON gerekmez."
        if ($Kuru) { Write-Output "bilgi: $pyMesaj (-Kuru: yalniz bilgi)" }
        else { Write-Output "$pyMesaj Video uretilmedi: GPU isi baslamadan durduruldu (cikis 6)."; exit 6 }
    }
}

if ($Kuru) {
    Write-Output "KURU: kare=$Kare iki_asama=$IkiAsama tavan=${TavanDk}dk cikti=$Cikti"
    Write-Output ("KURU bilgi: cozunurluk={0}x{1} jeton={2} tek_asama_elle={3} gpu_cc={4} gpu_vram={5} MiB f32={6}" -f $W, $H, $Jeton, [bool]$TekAsama, $GpuCc.ToString([Globalization.CultureInfo]::InvariantCulture), $GpuTop, $Env1.Contains('GGML_CUDA_CUBLAS_COMPUTE_TYPE'))
    Write-Output ("ASAMA 1 ortam: " + (($Env1.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join ' '))
    Write-Output ("ASAMA 1 komut: sd-cli.exe " + ((Ortak-Arg $Cikti) -join ' '))
    if ($IkiAsama) {
        Write-Output ("ASAMA 2 ortam: " + (($Env2.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join ' '))
        Write-Output ("ASAMA 2 komut: sd-cli.exe " + ((Ortak-Arg $Cikti) -join ' '))
    }
    exit 0
}

New-Item -ItemType Directory -Force $Dizin | Out-Null
$DurDosya = Join-Path $Root 'DUR'
$Kilit = Join-Path $Root 'runs\gpu.kilit'
New-Item -ItemType Directory -Force (Split-Path -Parent $Kilit) | Out-Null
if (Test-Path -LiteralPath $Kilit) {
    $eskiPid = 0; [int]::TryParse((Get-Content -LiteralPath $Kilit -ErrorAction SilentlyContinue | Select-Object -First 1), [ref]$eskiPid) | Out-Null
    if ($eskiPid -gt 0 -and (Get-Process -Id $eskiPid -ErrorAction SilentlyContinue)) { throw "[VT-E-KILIT] GPU baska bir uret.ps1 tarafindan kullaniliyor (PID $eskiPid). Tek GPU isi calistirin." }
}
Set-Content -LiteralPath $Kilit -Value $PID -Encoding ASCII

# C1 (hiz, 2026-11-25): iki asamada asama 1 latent'i yazdiktan sonra ses VAE + bellege sigmayan (karoya dusen) VAE'yi kosar; o cikti ATILIR
# (gecerli video asama 2'den). Latent dosyasi TAM yazilip kapandiysa asama 1 sureci sonlandirilir. Latent baytlari degismez. Kapatmak: VT_ERKEN_CIKIS=0.
# Tamlik olcutu: dosya bu asamada yazildi + baslik 'SDLAT001' + boyut = 12 + 8*ndim + 4*carpim(sekil) + tek basina (paylasimsiz) acilabiliyor (yazan kapatmis).
function Latent-Tam([string]$Yol, [datetime]$Sonra) {
    try {
        if (-not (Test-Path -LiteralPath $Yol)) { return $false }
        $fi = Get-Item -LiteralPath $Yol
        if ($fi.LastWriteTime -lt $Sonra -or $fi.Length -lt 1MB) { return $false }
        $fs = [IO.File]::Open($Yol, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::None)
        try {
            $br = New-Object IO.BinaryReader($fs)
            if ([Text.Encoding]::ASCII.GetString($br.ReadBytes(8)) -ne 'SDLAT001') { return $false }
            $nd = $br.ReadInt32(); if ($nd -lt 1 -or $nd -gt 8) { return $false }
            [long]$carpim = 1; for ($i = 0; $i -lt $nd; $i++) { $d = $br.ReadInt64(); if ($d -lt 1) { return $false }; $carpim *= $d }
            return ($fs.Length -eq (12 + 8 * $nd + 4 * $carpim))
        } finally { $fs.Dispose() }
    } catch { return $false }
}
function Asama-Kos([string]$Etiket, $EnvHash, [string]$ErkenLatent = '') {
    $out = Join-Path $Dizin ("ham_out_{0}{1}.txt" -f $Ad, $Etiket); $err = Join-Path $Dizin ("ham_err_{0}{1}.txt" -f $Ad, $Etiket)
    $eski = @{}
    foreach ($k in $EnvHash.Keys) { $eski[$k] = [Environment]::GetEnvironmentVariable($k); [Environment]::SetEnvironmentVariable($k, $EnvHash[$k]) }
    $eskiPath = $env:PATH
    if ($env:VT_CUDA_BIN) { $env:PATH = "$($env:VT_CUDA_BIN);$Motor;$env:PATH" } else { $env:PATH = "$Motor;$env:PATH" }
    try {
        $argStr = (Ortak-Arg $Cikti | ForEach-Object { if ($_ -match '\s') { '"' + $_ + '"' } else { $_ } }) -join ' '
        $sp = Start-Process -FilePath $sd -ArgumentList $argStr -WindowStyle Hidden -PassThru -RedirectStandardOutput $out -RedirectStandardError $err
        $null = $sp.Handle   # PS 5.1: tutamaci hemen al, yoksa ExitCode bos gelir
        $t0 = Get-Date; $kod = $null
        while (-not $sp.HasExited) {
            Start-Sleep -Seconds 5
            $smi = Get-Command nvidia-smi.exe -ErrorAction SilentlyContinue
            if ($smi) { $m = 0; if ([int]::TryParse((& nvidia-smi.exe --query-gpu=memory.used --format=csv,noheader,nounits 2>$null | Select-Object -First 1), [ref]$m) -and $m -gt $script:VramTepe) { $script:VramTepe = $m } }
            if (Test-Path -LiteralPath $DurDosya) { & taskkill.exe /T /F /PID $sp.Id | Out-Null; Write-Output "DURDU (DUR dosyasi) asama$Etiket"; exit 2 }
            if ($ErkenLatent -and -not $sp.HasExited -and (Latent-Tam $ErkenLatent $t0)) {
                & taskkill.exe /T /F /PID $sp.Id | Out-Null; $sp.WaitForExit(); $script:ErkenCikti = $true
                Write-Host ("bilgi: asama$Etiket latent tam yazildi ({0:N0} sn); atilacak VAE kosulmadan surec sonlandirildi (VT_ERKEN_CIKIS=0 ile kapanir)" -f ((Get-Date) - $t0).TotalSeconds)
                return 0
            }
            if (((Get-Date) - $t0).TotalMinutes -gt $TavanDk) { & taskkill.exe /T /F /PID $sp.Id | Out-Null; throw "[VT-E-TAVAN] TAVAN: asama$Etiket $TavanDk dk'yi asti, kesildi (uzun kosu icin -TavanDk arttirin)" }
        }
        $sp.WaitForExit(); $kod = $sp.ExitCode
    } finally {
        foreach ($k in $EnvHash.Keys) { [Environment]::SetEnvironmentVariable($k, $eski[$k]) }
        $env:PATH = $eskiPath
    }
    return $kod
}
function Log-Temiz([string]$Etiket) {
    # Karolu VAE geri-dususu, bellek yetmedi satirlari, [E] hata satiri => gecersiz
    foreach ($n in @(("ham_out_{0}{1}.txt" -f $Ad, $Etiket), ("ham_err_{0}{1}.txt" -f $Ad, $Etiket))) {
        $p = Join-Path $Dizin $n
        if ((Test-Path -LiteralPath $p) -and (Select-String -LiteralPath $p -Pattern 'temporal tiling|retrying with|ALLOC_FAILED|cannot make enough memory' -Quiet)) { return $false }
    }
    return $true
}

function Avi-KareSayisi([string]$Yol) {
    # AVI ana baslik (avih) dwTotalFrames, dosya ofseti 48. Okunamazsa -1. [tasarim, gercek kosuda gorulecek]
    try {
        $fs = [IO.File]::Open($Yol, 'Open', 'Read', 'ReadWrite'); try { $b = New-Object byte[] 56; [void]$fs.Read($b, 0, 56) } finally { $fs.Close() }
        if ([Text.Encoding]::ASCII.GetString($b, 0, 4) -ne 'RIFF' -or [Text.Encoding]::ASCII.GetString($b, 8, 4) -ne 'AVI ' -or [Text.Encoding]::ASCII.GetString($b, 24, 4) -ne 'avih') { return -1 }
        $n = [BitConverter]::ToUInt32($b, 48); if ($n -le 0) { return -1 }
        return [int]$n
    } catch { return -1 }
}

function Vram-Ipucu {
    # Yalniz hata YORUMLAMA: kalite ayari/komut degismez. Kesin degil: "olabilir".
    $bulundu = $false
    foreach ($n in @("ham_out_${Ad}_a1.txt", "ham_err_${Ad}_a1.txt", "ham_out_${Ad}_a2.txt", "ham_err_${Ad}_a2.txt")) {
        $p = Join-Path $Dizin $n
        if ((Test-Path -LiteralPath $p) -and (Select-String -LiteralPath $p -Pattern 'failed during weight preparation|ALLOC_FAILED|cannot make enough memory|out of memory|vae decode compute failed|need [0-9.]+ ?MB.{0,60}budget' -Quiet)) { $bulundu = $true }
    }
    if ($script:VramTepe -gt 0 -or $script:VramBas -ge 0) { Write-Output ("VRAM (kosu basarisiz; nvidia-smi, tum kart, 5 sn ornek): baslangic kullanimi {0} MiB, tepe {1} MiB, toplam {2} MiB" -f $script:VramBas, $script:VramTepe, $script:VramTop) }   # #24: basarisiz kosuda da gorunsun
    if ($bulundu) {
        Write-Output '[VT-E-VRAM] VRAM yetmedi olabilir (kesin degil): logda bellek ayirma/agirlik hazirlama hatasi var.'
        Write-Output '  Once: diger uygulamalari ve ikinci ekrani kapatin, yeniden deneyin (ekran yuku VRAM tepesini artirir).'
        if ($GpuTop -ge $OrtaKartUstMiB) { Write-Output '  Bu kart buyuk (11 GB ve ustu): once baslangic VRAM kullanimini dusurun (tarayici, sohbet uygulamalari, widget); kare azaltmak son care (12 GB kartlarda 209 kare sigdigi bildirildi [kullanici bildirdi, issue #23, issue #24]). Ayrinti: docs\SIK_HATALAR.md A.1' }
        elseif ($Kare - 17 -ge 56) { Write-Output ("  Olmazsa daha kisa deneyin: -Kare {0} (56..$KareSabit, 17k+5 gridi). Ayrinti: docs\SIK_HATALAR.md A.1" -f ($Kare - 17)) }
        else { Write-Output '  Ayrinti: docs\SIK_HATALAR.md A.1 (bu kare sayisindan daha kisasi onerilmiyor)' }
    }
}

$script:VramTepe = 0; $script:VramBas = -1; $script:VramTop = -1
$smi0 = Get-Command nvidia-smi.exe -ErrorAction SilentlyContinue
if ($smi0) {   # baslangic kullanimi (ekrani GPU'ya bagli kartta bosta dolu olabilir) ve toplam; yalniz bilgi
    $q0 = (& nvidia-smi.exe --query-gpu=memory.used,memory.total --format=csv,noheader,nounits 2>$null | Select-Object -First 1)
    if ($q0) { $f0 = @($q0 -split ',' | ForEach-Object { $_.Trim() }); $u0 = 0; $m0 = 0; if ($f0.Count -ge 2 -and [int]::TryParse($f0[0], [ref]$u0) -and [int]::TryParse($f0[1], [ref]$m0)) { $script:VramBas = $u0; $script:VramTop = $m0 } }
}
$t00 = Get-Date
try {
    Write-Output ("uret: {0} kare, {1}x{2}, {3} asama, cikti {4}" -f $Kare, $W, $H, $(if ($IkiAsama) { 2 } else { 1 }), $Cikti)
    if ($Env1.Contains('GGML_CUDA_CUBLAS_COMPUTE_TYPE')) { Write-Output ("bilgi: compute capability {0} >= 7.0: GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32 (uzun videoda siyah kare onlemi; kendiniz ayarlarsaniz dokunulmaz)" -f $GpuCc.ToString([Globalization.CultureInfo]::InvariantCulture)) }
    if ($GpuCc -lt 0 -and $Kare -ge 141 -and -not $env:GGML_CUDA_CUBLAS_COMPUTE_TYPE) { Write-Output 'bilgi: GPU compute capability okunamadi (eski surucu ya da nvidia-smi yok): f32 ayari yapilmadi. RTX 20xx ve ustu kartta 141+ karede video siyah cikarsa GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32 ayarlayip yeniden deneyin (docs\SIK_HATALAR.md).' }
    if ($TekAsama -and $EndImg -and $KucukKart) { Write-Output 'UYARI: -TekAsama + -EndImg 8 GB alti kartta: ilk+son kare tek asamada 56 karede bile VRAM''e sigmadi [olctum 1050 Ti]; -TekAsama olmadan calistirin (iki asama 56 ve 175 karede gecti).' }
    if ($TekAsama -and $Jeton -gt 7680) { Write-Output 'bilgi: -TekAsama: iki asama elle kapatildi; 4 GB kartta bu uzunlukta VAE bellege sigmayabilir (log karolu geri-dususu gosterirse cikti GECERSIZ sayilir).' }
    if (-not $Standart -and -not $ProfilAd) { Write-Output ("bilgi: {0}x{1} standart disi boyut (olculen ve bayt kanitli tek boyut 640x384; bu boyut 4 GB'da denenmedi)" -f $W, $H) }
    if (Test-Path -LiteralPath $Cikti) { Remove-Item -LiteralPath $Cikti -Force }   # eski avi basari sayilmasin
    $script:ErkenCikti = $false
    $k1 = $(if ($IkiAsama -and $env:VT_ERKEN_CIKIS -ne '0') { Asama-Kos '_a1' $Env1 $Latent } else { Asama-Kos '_a1' $Env1 })
    if ($IkiAsama) {
        if (-not (Test-Path -LiteralPath $Latent) -or (Get-Item -LiteralPath $Latent).Length -lt 1MB) { throw "[VT-E-LATENT] asama 1 latent yazmadi (cikis $k1; cikis -1073740791 / GGML_ASSERT offset 1<<30 ise is motorun yama sinirini astiysa: daha kucuk boyut ya da kare deneyin); ham_err_${Ad}_a1.txt'e bakin" }
        Write-Output ("asama 1 tamam (latent {0:N1} MB), asama 2 (ayri surec VAE) basliyor" -f ((Get-Item -LiteralPath $Latent).Length / 1MB))
        if (Test-Path -LiteralPath $Cikti) { Remove-Item -LiteralPath $Cikti -Force }
        $k2 = Asama-Kos '_a2' $Env2
        if ($k2 -ne 0) { Write-Output "UYARI: asama 2 cikis kodu '$k2' (tek basina basari olcutu degil; avi + kare sayisi + log denetlenir)" }
        if (-not (Log-Temiz '_a2')) { throw "[VT-E-TILING] asama 2 logunda karolu VAE geri-dususu ya da bellek hatasi (karolu VAE calismamis olabilir; bellek hatasiysa [VT-E-VRAM] satirina bakin): cikti GECERSIZ" }
    } else {
        if ($k1 -ne 0) { Write-Output "UYARI: sd-cli cikis kodu '$k1' (tek basina basari olcutu degil; avi + kare sayisi + log denetlenir)" }
        if (-not (Log-Temiz '_a1')) { throw "[VT-E-TILING] logda karolu VAE geri-dususu ya da bellek hatasi (karolu VAE calismamis olabilir; bellek hatasiysa [VT-E-VRAM] satirina bakin): cikti GECERSIZ" }
    }
    if (-not (Test-Path -LiteralPath $Cikti) -or (Get-Item -LiteralPath $Cikti).Length -lt 10KB) { throw "[VT-E-CIKTI] cikti dosyasi yok ya da cok kucuk: $Cikti" }
    # BASARI OLCUTU (birlikte): avi var + kare sayisi + log temiz (+ VRAM tepe uyarisi); cikis kodu tek basina olcut degil. [tasarim, gercek kosuda gorulecek]
    $ffprobe = $null; foreach ($c in @((Join-Path $Motor 'ffprobe.exe'), 'ffprobe')) { $g = Get-Command $c -ErrorAction SilentlyContinue; if ($g) { $ffprobe = $g.Source; break } }
    $n = -1
    if ($ffprobe) { try { $eap = $ErrorActionPreference; $ErrorActionPreference = 'Continue'; $r = & $ffprobe -v error -select_streams v:0 -count_packets -show_entries stream=nb_read_packets -of csv=p=0 $Cikti 2>$null; $tmp = 0; if ([int]::TryParse(("$r").Trim(), [ref]$tmp)) { $n = $tmp } } catch { } finally { $ErrorActionPreference = $eap } }
    $kaynak = 'ffprobe'
    if ($n -lt 0) { $n = Avi-KareSayisi $Cikti; $kaynak = 'avi basligi' }
    if ($n -ge 0) {
        if ($n -ne $Kare) { throw "[VT-E-KARESAYISI] kare sayisi $n ($kaynak), beklenen ${Kare}: cikti GECERSIZ" }
        Write-Output "kare sayisi dogrulandi: $n ($kaynak)"
    } else { Write-Output "UYARI: kare sayisi okunamadi (ffprobe yok, avi basligi okunamadi); dogrulanmadi" }
    if ($script:VramTepe -gt 0) {
        if ($script:VramTop -gt 0) { Write-Output ("VRAM tepe (nvidia-smi, tum kart, 5 sn ornek): tepe {0} / toplam {1} MiB, bos {2} MiB, baslangic kullanimi {3} MiB (ekrani GPU'ya bagliysa baslangicta dolu olabilir)" -f $script:VramTepe, $script:VramTop, ($script:VramTop - $script:VramTepe), $script:VramBas) }
        else { Write-Output ("VRAM tepe (nvidia-smi, tum kart, 5 sn ornek): {0} MiB" -f $script:VramTepe) }
        # Esik: bos VRAM <= 296 MiB (4096 MiB kartta eski "tepe >= 3800" ile ayni); toplam okunamazsa eski kural.
        $incemarj = $(if ($script:VramTop -gt 0) { ($script:VramTop - $script:VramTepe) -le 296 } else { $script:VramTepe -ge 3800 })
        if ($incemarj) { Write-Output 'UYARI: [VT-W-VRAM-MARJ] bos VRAM 296 MiB ya da alti: ince marj, baska ekran/uygulama yuku varsa sonraki kosu dusebilir (docs\SIK_HATALAR.md A.1)' }
    }
    # ses akisi: model ses uretir (olculen cikti: video + pcm_s16le ses); ffprobe akis listesini okuyabildi ve ses yoksa GECERSIZ. [tasarim, gercek kosuda gorulecek]
    if ($ffprobe) {
        try { $eap = $ErrorActionPreference; $ErrorActionPreference = 'Continue'; $tur = @(& $ffprobe -v error -show_entries stream=codec_type -of csv=p=0 $Cikti 2>$null) } catch { $tur = @() } finally { $ErrorActionPreference = $eap }
        $tur = @($tur | ForEach-Object { "$_".Trim() } | Where-Object { $_ })
        if ($tur -contains 'video') {
            if ($tur -contains 'audio') { Write-Output 'ses akisi var' } else { throw '[VT-E-SES] ses akisi yok: cikti GECERSIZ (model ses uretir; ham_out logunu ve istemdeki audio: cumlesini kontrol edin)' }
        } else { Write-Output 'UYARI: ffprobe akis listesini okuyamadi, ses akisi dogrulanmadi' }
    }
    # kalite kapisi: sonuc basari olcutune DAHIL. TAMAM yalniz kapi gecince. Esiklere dokunulmaz (docs\KAPILAR.md). Cikis: 5 = KAPI RED, 6 = kapi calismadi.
    if (-not $Kontrol) {
        $py = $(if ($env:VT_PYTHON) { $env:VT_PYTHON } elseif (Test-Path -LiteralPath (Join-Path $Root '.venv/Scripts/python.exe')) { Join-Path $Root '.venv/Scripts/python.exe' } else { 'python' })
        if (-not (Get-Command $py -ErrorAction SilentlyContinue)) {
            Write-Output ("VIDEO URETILDI ama KAPI CALISMADI [VT-E-PY] (python yok; VT_PYTHON ayarlayin, opencv-python gerekir): klip kabul edilmedi sayilir: {0}" -f $Cikti)
            exit 6
        }
        & powershell.exe -NoProfile -File (Join-Path $PSScriptRoot 'uretim_kapi.ps1') -Dizin $Dizin -Ad $Ad -Kare $Kare -DokuNorm
        $kapiKod = $LASTEXITCODE
        if (-not $Standart) { Write-Output ("UYARI: kalite kapisi esikleri 640x384 icin kalibre; {0}x{1} boyutunda gurultu/N degerleri karsilastirilamaz (yuksek cozunurlukte gurultu dogal olarak dusuk okunur). Videoyu gozle izleyin (docs\KAPILAR.md)." -f $W, $H) }
        if ($kapiKod -eq 6) {
            Write-Output ("VIDEO URETILDI ama KAPI CALISMADI [VT-E-PY] (python'da opencv-python/numpy yok ya da python calismadi; 'py -3 -m pip install opencv-python numpy', VT_PYTHON): klip kabul edilmedi sayilir: {0}" -f $Cikti)
            exit 6
        }
        if ($kapiKod -ne 0) {
            Write-Output 'KAPI RED: [VT-E-KAPI-RED] klip kabul edilmez, karar kullanicinindir; nedenini docs\KAPILAR.md ve runs\olaylar.txt icinde okuyun (dokulu sahnede sigma-HH ile de bakin).'
            Write-Output 'Kalite kapisi lisans uygunlugunu denetlemez; cikti kullanimi (bolge V.4, AI etiketi A-12, ticari IV) sizin sorumlulugunuzdadir: docs\LISANS_UYARISI.md'
            Write-Output "This gate does not check motion consistency (object scale or position jumps): watch the whole video before accepting it."
            Write-Output 'Bu kapi hareket tutarliligini (nesne olcegi/konum sicramasi) denetlemez: kabul etmeden once videonun tamamini izleyin.'
            exit 5
        }
        Write-Output 'KAPI GECTI'
        Write-Output 'Kalite kapisi lisans uygunlugunu denetlemez; cikti kullanimi (bolge V.4, AI etiketi A-12, ticari IV) sizin sorumlulugunuzdadir: docs\LISANS_UYARISI.md'
        Write-Output "This gate does not check motion consistency (object scale or position jumps): watch the whole video before accepting it."
        Write-Output 'Bu kapi hareket tutarliligini (nesne olcegi/konum sicramasi) denetlemez: kabul etmeden once videonun tamamini izleyin.'
    }
    Write-Output ("TAMAM {0:N0} sn: {1}" -f ((Get-Date) - $t00).TotalSeconds, $Cikti)
    exit 0
} catch {
    Vram-Ipucu
    throw
} finally {
    Remove-Item -LiteralPath $Kilit -Force -ErrorAction SilentlyContinue
}



