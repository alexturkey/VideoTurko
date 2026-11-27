# VideoTurko kur.ps1: kontrol0 -> motor -> model -> KONTROL -> HAZIR.  EN: setup script, prints HAZIR/READY only after a real tiny generation works.
# Kullanim / usage (PowerShell, repo klasorunde):
#   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
#   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1 -Adim kontrol0        (yalniz donanim kontrolu)
#   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1 -Kuru                (hicbir sey indirmez/kurmaz/yazmaz: tam on rapor, tum HATA ve UYARI tek listede, sonra cikar)
#   -ModelKlasoru <yol>  (var olan model klasoru: sha256 eslesen dosya hardlink/kopya ile baglanir, indirilmez; eslesmeyen normal indirilir)
#   -Adim kontrol0,motor,model,kontrol   (varsayilan: hepsi)   -LisansKabul E|Y   -MotorZip <yerel zip>  -CudaZip <yerel zip>  -Zorla
#   -MotorTuru release_sm61|stock_cuda12|stock_vulkan  (varsayilan: kart sinifina gore otomatik, scripts/kart_tablosu.json; -Kuru ne sececegini soyler.
#      GTX 1050 Ti / Pascal: hazir release motoru, eski yol aynen. -MotorZip/-CudaZip verirseniz release motoru sayilir.)
# Her adim tekrar calistirilabilir: dogru sha256'li dosya atlanir. Durdurma: <VT_ROOT>\DUR dosyasi -> DURDU, .part korunur.
# Ortam / env: VT_ROOT, VT_ENGINE_BIN, VT_MODEL_DIR (bkz. uret.ps1). Kisisel yol yoktur.
# Cikis kodlari / exit: 0 HAZIR (ya da -Kuru raporu tamam), 1 hata, 2 lisans kabul gerekli, 3 donanim/disk yetersiz, 4 DURDU.
# Disk esigi: eksik model varsa model surucusunde en az 32 GiB bos (29,31 GiB model + motor/CUDA zip ve acma payi), modelleri_indir.ps1 -MinBosGiB ile ayni, README/AGENTS/KURULUM ile ayni (eski kur.ps1 47 istiyordu: kaynaksiz 15 GiB pay).
# Test: -Kuru ile VT_KURU_SAHTE='ram=8;bos_ram=2;disk=10;vc=yok;python=yok;gpu=yok;vram=3000;cc=5.2' sahte olcum verir (yalniz -Kuru).
param(
    [string[]]$Adim = @('kontrol0', 'motor', 'model', 'kontrol'),
    [switch]$Kuru,
    [string]$LisansKabul = '',
    [string]$MotorZip = '',
    [string]$CudaZip = '',
    [string]$ModelKlasoru = '',
    [string]$MotorTuru = '',
    [switch]$HizPaketi,   # istege bagli: hiz paketi motoru (yama 0021/0023/0024, hepsi varsayilan kapali); uret.ps1 -Profil icin gerekir
    [switch]$Zorla
)
$ErrorActionPreference = 'Stop'
$Adim = @($Adim | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim() } | Where-Object { $_ })
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Root = $(if ($env:VT_ROOT) { $env:VT_ROOT } else { (Resolve-Path (Join-Path $PSScriptRoot '..')).Path })
$Motor = $(if ($env:VT_ENGINE_BIN) { $env:VT_ENGINE_BIN } else { Join-Path $Root 'engine\bin' })
$ModelDir = $(if ($env:VT_MODEL_DIR) { $env:VT_MODEL_DIR } else { Join-Path $Root 'model' })
$DurDosya = Join-Path $Root 'DUR'
. (Join-Path $PSScriptRoot 'kart.ps1')   # kart tanima + scripts/kart_tablosu.json okuma (yalniz okur)
$KartTabloYol = $(if ($env:VT_KART_TABLOSU) { $env:VT_KART_TABLOSU } else { Join-Path $PSScriptRoot 'kart_tablosu.json' })   # VT_KART_TABLOSU: baska tablo dosyasi (test/gelismis)
$UyariBosGiB = 40   # 32-40 GiB arasi bos yer: HATA degil UYARI (pay dar; ihtiyac ~31,4 GiB, toplanti 1 karari 2026-11-20)
$MinBosGiB = 32   # 29,31 GiB model + motor/CUDA zip ve acma payi (en kotu an ~31,4 GiB) [olctum: modeller.json boyutlari + dist/ zip boyutlari]

# --- Zip adlari paketleme betigiyle ayni (motor adindaki surum numarasi yayin surumudur; VT_MOTOR_ZIP_AD ile ezilir).
# --- Release adresleri: release henuz yayinlanmadi; adres ve sha256 YER TUTUCUDUR (yayin sonrasi doldurulur).
# --- Release URLs/sha256 are PLACEHOLDERS until the release exists; override with VT_MOTOR_URL / VT_MOTOR_SHA256 / VT_CUDA_URL / VT_CUDA_SHA256.
$ZipMotor = @{ ad = $(if ($env:VT_MOTOR_ZIP_AD) { $env:VT_MOTOR_ZIP_AD } else { 'videoturko-motor-0.1.0-win64-cuda12.8-sm61.zip' }); url = $(if ($env:VT_MOTOR_URL) { $env:VT_MOTOR_URL } else { 'https://github.com/alexturkey/VideoTurko/releases/download/v0.1.0/videoturko-motor-0.1.0-win64-cuda12.8-sm61.zip' }); sha = $(if ($env:VT_MOTOR_SHA256) { $env:VT_MOTOR_SHA256 } else { '7d28ff900ef4799f75cbe91c39e0a7b260f0207a7e2a4ebd3d8450590b79a64d' }) }
$ZipCuda = @{ ad = 'videoturko-cuda-runtime-12.8-win64.zip'; url = $(if ($env:VT_CUDA_URL) { $env:VT_CUDA_URL } else { 'https://github.com/alexturkey/VideoTurko/releases/download/v0.1.0/videoturko-cuda-runtime-12.8-win64.zip' }); sha = $(if ($env:VT_CUDA_SHA256) { $env:VT_CUDA_SHA256 } else { '344a0b04f043fb9cccdfe38ec77716afb59bafb894f11f0fac2365f151777355' }) }

# Hiz paketi motoru (v0.1.4, istege bagli, -HizPaketi): ayni release motoru + yama 0021/0023/0024 (varsayilan kapali). Adres/sha256 release yayinlaninca gecerli olur; yerel zip icin -MotorZip.
if ($HizPaketi -and -not $env:VT_MOTOR_URL) {
    $ZipMotor = @{ ad = 'videoturko-motor-0.1.4-hiz-win64-cuda12.8-sm61.zip'; url = 'https://github.com/alexturkey/VideoTurko/releases/download/v0.1.4/videoturko-motor-0.1.4-hiz-win64-cuda12.8-sm61.zip'; sha = 'baa168eab0589ca28e1ad6bc86d7059ec260ef8900b93f431ea1959ce9425b8d' }
}

function Say([string]$m) { Write-Output $m }
function Dur-Kontrol { if (Test-Path -LiteralPath $DurDosya) { Say 'DURDU (DUR dosyasi)'; exit 4 } }
function Sha256([string]$p) { (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLower() }
$uyari = New-Object System.Collections.ArrayList
$hata = New-Object System.Collections.ArrayList
$script:KuruHata = $false
# Yalniz -Kuru testi icin sahte olcum (VT_KURU_SAHTE='ram=8;bos_ram=2;disk=10;vc=yok;python=yok;gpu=yok;vram=3000;cc=5.2'); gercek kurulumda YOK SAYILIR.
$Sahte = @{}
if ($Kuru -and $env:VT_KURU_SAHTE) { foreach ($kv in ($env:VT_KURU_SAHTE -split ';')) { $pp = $kv -split '=', 2; if ($pp.Count -eq 2) { $Sahte[$pp[0].Trim()] = $pp[1].Trim() } } }
$modelAdlari = @('minimax_h3_fl2va_hyperflow_flash_14b-Q4_K_M.gguf', 'qwen3vl_32b_minimax_h3-Q4_K_M.gguf', 'minimax_h3_sol_vae_fp16.safetensors', 'minimax_h3_audio_vae_fp32.safetensors')

# ---------------------------------------------------------------- kontrol0
function Hata-Ekle([string]$m, [bool]$zorlaGecer = $false) {
    # Tek liste: kontrol0 ilk HATA'da kesmez, hepsini toplar (-Kuru ve gercek kurulumda ayni kod yolu).
    if ($zorlaGecer -and $Zorla) { [void]$uyari.Add("(-Zorla ile gecildi) $m") } else { [void]$hata.Add($m) }
}
function Sahte-Al([string]$k, $gercek) { if ($Sahte.ContainsKey($k)) { return $Sahte[$k] } else { return $gercek } }
function Yol-Uyar([string]$ad, [string]$yol) {
    # Yalniz UYARI: bu yollarda gercek kosu denenmedi, ama kurulum engellenmez.
    $on = "$ad yolu"
    $oneri = 'Kisa ASCII bir yol onerilir (ornek C:\vt; VT_ROOT ile ayarlanir).'
    if ($yol -match '\s') { [void]$uyari.Add("[VT-W-YOL-BOSLUK] $on bosluk iceriyor, bu yolda gercek kosu denenmedi: $yol. $oneri") }
    if ($yol -match '[^\x00-\x7F]') { [void]$uyari.Add("[VT-W-YOL-ASCII] $on ASCII disi karakter (ornek Turkce harf) iceriyor, bu yolda gercek kosu denenmedi: $yol. $oneri") }
    if ($yol -match 'OneDrive') { [void]$uyari.Add("[VT-W-YOL-ONEDRIVE] $on OneDrive icinde: eslesme (senkron) dosyalari kilitleyebilir ve 29 GiB modeli buluta yukler: $yol. $oneri") }
    if ($yol.StartsWith('\\')) { [void]$uyari.Add("[VT-W-YOL-UNC] $on bir ag yolu (UNC): denenmedi, disk bos alani olculemez: $yol.") }
    if ($yol.Length -gt 100) { [void]$uyari.Add("[VT-W-YOL-UZUN] $on uzun ($($yol.Length) karakter): Windows 260 karakter siniri payi azalir [tahmin]: $yol. $oneri") }
}
# ---------------------------------------------------------------- kart ve motor secimi (scripts/kart_tablosu.json)
function Kart-Oku {
    # nvidia-smi; yoksa Windows ekran bagdastiricisi (AMD). Yalniz okur. uretici: nvidia | amd | diger | yok; vram MiB (-1 = bilinmiyor), cc (-1 = okunamadi).
    $k = @{ uretici = 'yok'; ad = ''; vram = -1.0; surucu = ''; cc = -1.0; sessiz = $false }
    $sahteGpu = [string](Sahte-Al 'gpu' '')
    $smi = $null
    if ($sahteGpu -ne 'yok') { $smi = Get-Command nvidia-smi.exe -ErrorAction SilentlyContinue }
    if ($sahteGpu -ne '' -and $sahteGpu -ne 'yok') {
        # yalniz -Kuru testi: sahte kart. Adi AMD ise amd, Intel ise diger, aksi halde nvidia (eski davranis).
        $k.ad = $sahteGpu; $k.vram = 4096.0; $k.surucu = 'sahte'; $k.cc = 6.1
        $k.uretici = $(if ($sahteGpu -match 'Intel') { 'diger' } elseif ((Kart-Uretici $sahteGpu) -eq 'amd') { 'amd' } else { 'nvidia' })
        if ($k.uretici -ne 'nvidia') { $k.cc = -1.0; $k.vram = -1.0 }
    }
    elseif ($smi) {
        $q = (& nvidia-smi.exe --query-gpu=name,memory.total,driver_version,compute_cap --format=csv,noheader,nounits 2>$null | Select-Object -First 1)
        if (-not $q) { $k.sessiz = $true }
        else { $c = Kart-Satir-Coz $q; if ($c) { $k.ad = $c.ad; $k.vram = $c.vram; $k.surucu = $c.surucu; $k.cc = $c.cc; $k.uretici = 'nvidia' } else { $k.sessiz = $true } }
    }
    if ($k.uretici -eq 'yok' -and -not $k.sessiz) {
        $adlar = @()
        if ($Sahte.ContainsKey('amd')) { $adlar = @($Sahte['amd']) }
        elseif ($sahteGpu -ne 'yok') { try { $adlar = @(Get-CimInstance Win32_VideoController -ErrorAction Stop | ForEach-Object { [string]$_.Name }) } catch { $adlar = @() } }
        foreach ($a in $adlar) { if ((Kart-Uretici $a) -eq 'amd') { $k.uretici = 'amd'; $k.ad = $a; break } }
    }
    if ($Sahte.ContainsKey('vram')) { $k.vram = [double]$Sahte['vram'] }
    if ($Sahte.ContainsKey('cc')) { $k.cc = Kart-CcOku $Sahte['cc'] }
    return $k
}
$KartTablo = $null
try { $KartTablo = Kart-Tablo-Oku $KartTabloYol } catch { throw "[VT-E-YOL] scripts/kart_tablosu.json okunamadi: $($_.Exception.Message)" }
$Kart = Kart-Oku
$Sinif = $(if ($Kart.uretici -eq 'yok') { $null } else { Kart-Sinif $KartTablo $Kart.uretici $Kart.cc })
$MotorId = ''; $MotorNeden = ''
if ($MotorTuru) {
    if (-not $KartTablo.motorlar.PSObject.Properties[$MotorTuru]) { throw "bilinmeyen -MotorTuru '$MotorTuru' (release_sm61, stock_cuda12, stock_vulkan)" }
    $MotorId = $MotorTuru; $MotorNeden = 'elle, -MotorTuru'
}
elseif ($MotorZip -or $CudaZip) { $MotorId = 'release_sm61'; $MotorNeden = 'yerel release zip verildi' }
elseif ($Kart.uretici -eq 'diger') { $MotorId = ''; $MotorNeden = 'bu kart icin otomatik motor yok' }
elseif ($Sinif -and $Sinif.motor) { $MotorId = [string]$Sinif.motor; $MotorNeden = "kart sinifi $($Sinif.id)" }
else { $MotorId = 'release_sm61'; $MotorNeden = 'kart tanimlanamadi: eski varsayilan yol' }
$MotorTanim = $(if ($MotorId) { $KartTablo.motorlar.$MotorId } else { $null })
if ($MotorId -and $MotorId -ne 'release_sm61' -and -not $env:VT_ENGINE_BIN) { $Motor = Join-Path $Root ([string]$MotorTanim.bin -replace '/', '\') }

function Adim-Kontrol0 {
    Say '== kontrol0: donanim ve ortam (hicbir sey indirilmez)'
    if ($Sahte.Count -gt 0) { Say ("  SAHTE OLCUM (yalniz -Kuru testi, VT_KURU_SAHTE): " + (($Sahte.Keys | Sort-Object | ForEach-Object { "$_=$($Sahte[$_])" }) -join ' ')) }
    $os = [Environment]::OSVersion.Version
    Say ("  Windows {0}.{1} build {2}" -f $os.Major, $os.Minor, $os.Build)
    if ($os.Major -lt 10) { Hata-Ekle '[VT-E-OS] Windows 10 ya da ustu gerekir' }
    # GPU (kart_tablosu.json: kart sinifi -> motor)
    if ($Kart.uretici -eq 'yok' -or $Kart.uretici -eq 'diger' -or $Kart.sessiz) {
        if ($Kart.sessiz) { Hata-Ekle '[VT-E-GPU] nvidia-smi cikti vermedi' }
        else { Hata-Ekle '[VT-E-GPU] nvidia-smi yok: NVIDIA sofor/surucu kurulu degil ya da NVIDIA/AMD kart yok (hazir sm_61 motor yalniz NVIDIA CUDA; AMD kartta kur.ps1 stock Vulkan motorunu secer). AMD ya da baska NVIDIA disi kart: docs/AMD_ROCM.md (topluluk notu, resmi destek yok / community note, not officially supported).' }
    }
    else {
        $gpuAd = $Kart.ad; $vram = [double]$Kart.vram; $ccV = [double]$Kart.cc
        $ccYazi = $(if ($ccV -ge 0) { $ccV.ToString('0.#', [Globalization.CultureInfo]::InvariantCulture) } else { '' })
        if ($Kart.uretici -eq 'amd') { Say ("  GPU: {0} (AMD; VRAM ve compute capability okunmaz)" -f $gpuAd) }
        else { Say ("  GPU: {0}, {1:N0} MiB, surucu {2}, compute capability {3}" -f $gpuAd, $vram, $Kart.surucu, $ccYazi) }
        if ($Kart.uretici -eq 'nvidia') {
            if ($vram -lt 3800) { Hata-Ekle '[VT-E-GPU-VRAM] en az 4 GB VRAM gerekir' $true }
            if ($ccV -ge 0 -and $ccV -lt 6.1) { Hata-Ekle '[VT-E-GPU-CC] compute capability 6.1 (Pascal) ya da ustu gerekir' $true }
        }
        $durum = Kart-Durum $Sinif $gpuAd
        Say ("  Motor secimi: {0} ({1}; durum {2})" -f $(if ($MotorId) { $MotorId } else { 'YOK' }), $MotorNeden, $durum)
        if ($durum -ne 'dogrulanmis') {
            $kanitNot = $(if ($Sinif -and $Sinif.kanit) { " Kanit: $($Sinif.kanit)" } else { '' })
            [void]$uyari.Add("[VT-W-GPU-DENENMEDI] Dogrulanmis donanim yalniz GTX 1050 Ti 4 GB (sm_61). $gpuAd icin bakimci olcumu yok (durum: $durum); devam edebilirsiniz ama sonuc garanti degil.$kanitNot Dis kullanici raporlari (etiketli): docs/KART_PROFILLERI.md.")
        }
    }
    # RAM (toplam: kurulum icin; bos: video kosusu icin, motor tepe ~11 GB [olctum: docs/OLCUMLER.md])
    $os2 = Get-CimInstance Win32_OperatingSystem
    $ramGB = [Math]::Round($os2.TotalVisibleMemorySize / 1MB, 1); $bosGB = [Math]::Round($os2.FreePhysicalMemory / 1MB, 1)
    $ramGB = [double](Sahte-Al 'ram' $ramGB); $bosGB = [double](Sahte-Al 'bos_ram' $bosGB)
    Say ("  RAM: toplam {0} GB, bos {1} GB" -f $ramGB, $bosGB)
    if ($ramGB -lt 12) { Hata-Ekle '[VT-E-RAM] en az 16 GB RAM onerilir (olculen RAM tepe ~11,5 GB); 12 GB alti desteklenmez' $true }
    elseif ($ramGB -lt 15.5) { [void]$uyari.Add("[VT-W-RAM] RAM $ramGB GB: 16 GB onerilir; kosu sirasinda diger uygulamalari kapatin, takas (sayfa dosyasi) yavaslatabilir.") }
    if ($bosGB -lt 11) { [void]$uyari.Add("[VT-W-RAM-BOS] Bos RAM su an $bosGB GB: motor video kosusunda tepe ~11 GB kullanir. Kurulum etkilenmez; video uretmeden once tarayici ve buyuk programlari kapatin, sonra tekrar olcun.") }
    # Disk: eksik model baytlari (modelleri_indir.ps1 ile ayni kural: eksik varsa en az $MinBosGiB GiB bos)
    $kayit = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'modeller.json') -Raw -Encoding UTF8 | ConvertFrom-Json
    $eksikBayt = 0L; $hepsiVar = $true
    foreach ($d in $kayit.dosyalar) {
        $h = Join-Path $ModelDir $d.hedef; $part = "$h.part"
        if ((Test-Path -LiteralPath $h) -and ((Get-Item -LiteralPath $h).Length -eq [long]$d.boyut)) { continue }
        $hepsiVar = $false
        $k = $(if ($ModelKlasoru) { Join-Path $ModelKlasoru $d.hedef } else { '' })
        if ($k -and (Test-Path -LiteralPath $k) -and ([IO.Path]::GetPathRoot([IO.Path]::GetFullPath($k)) -eq [IO.Path]::GetPathRoot([IO.Path]::GetFullPath($ModelDir)))) { continue }   # ayni surucuden hardlink: ek yer yok
        if (Test-Path -LiteralPath $part) { $eksikBayt += [Math]::Max([long]0, [long]$d.boyut - (Get-Item -LiteralPath $part).Length) } else { $eksikBayt += [long]$d.boyut }
    }
    $eksikGiB = [Math]::Round($eksikBayt / 1GB, 2)
    $motorVar = (Test-Path -LiteralPath (Join-Path $Motor 'sd-cli.exe'))
    $motorGiB = $(if ($motorVar -and -not $MotorZip -and -not $CudaZip) { 0 } elseif ($MotorTanim) { [double]$MotorTanim.disk_gib } else { 2.1 })   # 2 zip (0,56 GiB) + acilmis kopya + engine\bin kopyasi, en kotu an [olctum: dist/ zip boyutlari, 2,1 GiB]
    Say ("  Indirilecek model: {0} GiB (toplam {1:N2} GiB); motor+CUDA zip ve acma payi: {2} GiB" -f $eksikGiB, (($kayit.dosyalar | ForEach-Object { [long]$_.boyut } | Measure-Object -Sum).Sum / 1GB), $motorGiB)
    $surucuHarf = ''
    try { $surucuHarf = (Split-Path -Qualifier ([IO.Path]::GetFullPath($ModelDir))).TrimEnd(':') } catch { $surucuHarf = '' }
    $drv = $(if ($surucuHarf) { Get-PSDrive -Name $surucuHarf -ErrorAction SilentlyContinue } else { $null })
    if ($drv) {
        $bosGiB = [double](Sahte-Al 'disk' ([Math]::Round($drv.Free / 1GB, 1)))
        Say ("  Disk {0}: bos {1} GiB (model klasoru {2})" -f $surucuHarf, $bosGiB, $ModelDir)
        if (-not $hepsiVar -and $bosGiB -ge $MinBosGiB -and $bosGiB -lt $UyariBosGiB) { [void]$uyari.Add(("[VT-W-DISK-PAY] model surucusunde bos yer {0} GiB: esik ({1} GiB) gecildi ama pay dar (bu kurulum icin gereken ~{2} GiB). Indirme sirasinda baska bir sey diski doldurursa indirme durur; yarim .part dosyasi korunur ve yer actiktan sonra AYNI komut kaldigi yerden surer (indirici .part + Range kullanir [okudum]; .part'li rapor -Kuru ile olculdu, 29 GiB'lik gercek yeniden baslatma olculmedi). {3} GiB ya da uzeri bos yer onerilir." -f $bosGiB, $MinBosGiB, [Math]::Round($eksikGiB + $motorGiB, 1), $UyariBosGiB)) }
        if (-not $hepsiVar -and $bosGiB -lt $MinBosGiB) { Hata-Ekle ("[VT-E-DISK] model indirmek icin model surucusunde en az {0} GiB bos gerekir ({1:N2} GiB model + motor/CUDA zip ve acma payi; bos {2} GiB). Yer acin ya da VT_MODEL_DIR ile baska surucu secin." -f $MinBosGiB, $eksikGiB, $bosGiB) $true }
        try {
            $pd = Get-Partition -DriveLetter $surucuHarf -ErrorAction Stop | Get-Disk | Get-PhysicalDisk
            Say ("  Disk turu: {0}" -f $pd.MediaType)
            if ($pd.MediaType -eq 'HDD') { [void]$uyari.Add('[VT-W-HDD] Model klasoru HDD uzerinde: ilk adimlar 15-25 kat yavas olur (olculdu). NVMe/SSD onerilir (VT_MODEL_DIR).') }
        } catch { Say '  Disk turu okunamadi (atlandi)' }
        # Kok baska surucudeyse motor+CUDA zipleri orada gecici yer ister
        $kokHarf = ''
        try { $kokHarf = (Split-Path -Qualifier ([IO.Path]::GetFullPath($Root))).TrimEnd(':') } catch { $kokHarf = '' }
        if ($kokHarf -and $kokHarf -ne $surucuHarf -and $motorGiB -gt 0) {
            $kokDrv = Get-PSDrive -Name $kokHarf -ErrorAction SilentlyContinue
            if ($kokDrv) {
                $kokBos = [Math]::Round($kokDrv.Free / 1GB, 1)
                Say ("  Disk {0} (kurulum koku): bos {1} GiB" -f $kokHarf, $kokBos)
                if ($kokBos -lt 3) { Hata-Ekle ("[VT-E-DISK-KOK] kurulum kokunun suruculerinde ({0}:) motor ve CUDA zipleri icin en az 3 GiB bos gerekir (bos {1} GiB)" -f $kokHarf, $kokBos) $true }
            }
        }
    }
    # VC++
    $vcDll = Join-Path $env:SystemRoot 'System32\vcruntime140.dll'; $mpDll = Join-Path $env:SystemRoot 'System32\msvcp140.dll'
    $vcVar = (Test-Path -LiteralPath $vcDll) -and (Test-Path -LiteralPath $mpDll)
    if ((Sahte-Al 'vc' '') -eq 'yok') { $vcVar = $false }
    if ($vcVar) { Say ("  VC++ calisma zamani: var (vcruntime140 {0})" -f (Get-Item -LiteralPath $vcDll).VersionInfo.ProductVersion) }
    else { [void]$uyari.Add('[VT-W-VC] Visual C++ 2015-2022 x64 Redistributable bulunamadi (System32\vcruntime140.dll/msvcp140.dll yok): Microsoft sayfasindan kurun (sd-cli acilmazsa nedeni budur).') }
    # Python + OpenCV + numpy: kurulum icin gerekmez; uret.ps1 kalite kapisi icin ister (yoksa video uretilmez, cikis 6)
    $pyK = $(if ($env:VT_PYTHON) { $env:VT_PYTHON } elseif (Test-Path -LiteralPath (Join-Path $Root '.venv/Scripts/python.exe')) { Join-Path $Root '.venv/Scripts/python.exe' } else { 'python' }); $pyTamam = $false; $pyKod = 'bulunamadi'
    if ((Sahte-Al 'python' '') -ne 'yok' -and (Get-Command $pyK -ErrorAction SilentlyContinue)) {
        $eapP = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
        try { $null = & $pyK -I -c "import cv2, numpy" 2>&1; $pyKod = "$LASTEXITCODE"; $pyTamam = ($LASTEXITCODE -eq 0) } catch { $pyKod = 'calistirilamadi' } finally { $ErrorActionPreference = $eapP }
    }
    if ($pyTamam) { Say "  Python + opencv + numpy: var ($pyK)" }
    else { [void]$uyari.Add("[VT-W-PY] Python + opencv-python + numpy hazir degil ($pyK, sonuc $pyKod; 9009 = Windows Store kisayolu): kurulum etkilenmez ama uret.ps1 kalite kapisi icin ister, yoksa video uretilmez (cikis 6). Python 3 kurun, sonra 'py -3 -m pip install opencv-python numpy' (ya da VT_PYTHON). Dis iz birakmamak icin: kokte venv kurun ('py -3 -m venv <VT_ROOT>/.venv'), paketi oradan yukleyin ('<VT_ROOT>/.venv/Scripts/python.exe -m pip install --cache-dir <VT_ROOT>/.onbellek/pip opencv-python numpy'); .venv varsa VT_PYTHON gerekmez.") }
    # Yollar
    Yol-Uyar 'Kurulum koku' $Root
    if ($ModelDir -ne (Join-Path $Root 'model')) { Yol-Uyar 'Model klasoru' $ModelDir }
    # Ozet: tek liste
    Say '  -- ON RAPOR (tek liste) --'
    foreach ($h in $hata) { Say "  HATA: $h" }
    foreach ($u in $uyari) { Say "  UYARI: $u" }
    if ($hata.Count -eq 0 -and $uyari.Count -eq 0) { Say '  (HATA ve UYARI yok)' }
    Say ("  Tahmini sureler: model indirme yaklasik {0} dk (9 MB/sn varsayimi; 605 MB ses VAE 66 sn olculdu, tam indirme olculmedi) [tahmin]; kontrol uretimi 5 kare (RTX 4070 Ti'de 41 sn olculdu, GTX 1050 Ti'de olculmedi); ilk video 56 kare yaklasik 11 dk, 209 kare yaklasik 57 dk (GTX 1050 Ti) [olctum: yazarlarda kayit]" -f [Math]::Ceiling($eksikGiB * 1024 / 9 / 60))
    Say '  Kapatirsan ne olur: indirme yarida kesilirse .part dosyasi kalir, ayni komut kaldigi yerden surer (sha256 dogru dosyalar atlanir). Temiz durdurmak icin kurulum kokune DUR dosyasi koyun. Video kosusu kesilirse bastan kosar (latent kurtarma yok).'
    if ($hata.Count -gt 0) {
        if ($Kuru) { $script:KuruHata = $true }
        else { Say ("== kontrol0 BASARISIZ: {0} HATA (hicbir sey indirilmedi)" -f $hata.Count); exit 3 }
    }
    Say $(if ($hata.Count -gt 0) { "== kontrol0 bitti: $($hata.Count) HATA, $($uyari.Count) UYARI" } else { '== kontrol0 tamam' })
}

# ---------------------------------------------------------------- motor
function Zip-Al($z, [string]$yerel, [string]$hedefDizin) {
    New-Item -ItemType Directory -Force $hedefDizin | Out-Null
    $zipYol = $(if ($yerel) { $yerel } else { Join-Path $hedefDizin $z.ad })
    if (-not $yerel) {
        if ($z.url -like '__*' -or $z.sha -like '__*') { throw "ZIP2:release adresi/sha256 henuz yok ($($z.ad)): release yayinlanana kadar motor zip dosyasi gerekir" }
        if (-not ((Test-Path -LiteralPath $zipYol) -and ((Sha256 $zipYol) -eq $z.sha.ToLower()))) {
            $part = "$zipYol.part"
            Write-Host "  indiriliyor: $($z.ad)"
            & curl.exe -L --fail --retry 3 --retry-delay 5 -C - --progress-bar -o $part $z.url
            if ($LASTEXITCODE -ne 0) { throw "indirme basarisiz: $($z.url)" }
            $got = Sha256 $part
            if ($got -ne $z.sha.ToLower()) { Remove-Item -LiteralPath $part -Force; throw "sha256 tutmadi: $($z.ad) beklenen $($z.sha) gelen $got" }
            Move-Item -LiteralPath $part -Destination $zipYol -Force
        }
    } else {
        if (-not (Test-Path -LiteralPath $zipYol)) { throw "ZIP2:yerel zip dosyasi bulunamadi: $zipYol" }
        # Oncelik: GOMULU sha (yayin sonrasi dolu) -> yanindaki .sha256 YOK SAYILIR (ezilme yok). Yer tutucuysa yan .sha256 yedek ve BAGIMSIZ DEGIL.
        $beklenen = ''; $kaynakSha = ''
        if (-not ($z.sha -like '__*')) { $beklenen = $z.sha.ToLower(); $kaynakSha = 'gomulu' }
        elseif (Test-Path -LiteralPath "$zipYol.sha256") { $beklenen = ((Get-Content -LiteralPath "$zipYol.sha256" -TotalCount 1) -split '\s+')[0].ToLower(); $kaynakSha = 'yan .sha256' }
        if ($beklenen) {
            if ((Sha256 $zipYol) -ne $beklenen) { throw "yerel zip sha256 tutmadi ($kaynakSha): $zipYol" }
            if ($kaynakSha -eq 'yan .sha256') { Write-Host "  UYARI: yan .sha256 ile dogrulandi (self-referential, not independent: yalniz bozulmayi yakalar, kasitli degistirmeyi yakalamaz; release sha256'si henuz yok): $zipYol" }
        }
        else { Write-Host "  UYARI: sha256 dogrulanmadi (release sha256'si henuz yok ve $zipYol.sha256 dosyasi yanina konmamis): $zipYol" }
    }
    return $zipYol
}
function Adim-Motor {
    Say '== motor: sd-cli ikili + calisma zamani DLL (sha256 dogrulamali)'
    if (-not $MotorId) { Say ("MOTOR ADIMI DURDU: [VT-E-MOTOR] bu kart icin otomatik motor yok ({0}); -MotorTuru release_sm61|stock_cuda12|stock_vulkan ile elle secin (docs/KART_PROFILLERI.md)." -f $Kart.ad); exit 3 }
    Say ("  Motor secimi: {0} ({1}) -> {2}" -f $MotorId, $MotorNeden, $Motor)
    $sd = Join-Path $Motor 'sd-cli.exe'
    $dll = @($MotorTanim.gerekli_dosyalar | Where-Object { $_ -ne 'sd-cli.exe' })
    if ($MotorId -eq 'release_sm61') { $zipListe = @(@($ZipMotor, $MotorZip), @($ZipCuda, $CudaZip)) }
    else { $zipListe = @(); foreach ($tz in @($MotorTanim.zipler)) { $zipListe += , @(@{ ad = [string]$tz.ad; url = [string]$tz.url; sha = [string]$tz.sha256 }, '') } }
    $var = (Test-Path -LiteralPath $sd) -and (-not ($dll | Where-Object { -not (Test-Path -LiteralPath (Join-Path $Motor $_)) }))
    if ($var -and -not $MotorZip -and -not $CudaZip) { Say '  motor zaten var (atlandi)' }
    else {
        if ($Kuru) {
            Say "  KURU: motor zip dosyalari indirilecekti -> $($Motor)"
            foreach ($zp in $zipListe) { Say ("  URL: {0}  sha256 {1}" -f $zp[0].url, $zp[0].sha) }
            if ($MotorId -eq 'release_sm61' -and (($ZipMotor.url -like '__*') -or ($ZipCuda.url -like '__*'))) { Say '  UYARI: release adresi henuz yok: -MotorZip/-CudaZip ile yerel zip gerekir.' }
            return
        }
        $tmp = Join-Path $Root 'indirme'
        try {
        foreach ($p in $zipListe) {
            Dur-Kontrol
            $zip = Zip-Al $p[0] $p[1] $tmp
            $ac = Join-Path $tmp ('ac_' + $p[0].ad)
            if (Test-Path -LiteralPath $ac) { Remove-Item -LiteralPath $ac -Recurse -Force }
            Expand-Archive -LiteralPath $zip -DestinationPath $ac -Force
            New-Item -ItemType Directory -Force $Motor | Out-Null
            # Iki zip'te ayni adli README.txt / SHA256SUMS.txt var (icerikleri farkli): ikili ve DLL'ler $Motor'a, geri kalan (lisans, README, SHA256SUMS) zip adli alt klasore: cakisma yok.
            $dosyalar = @(Get-ChildItem -LiteralPath $ac -Recurse -File)
            $sumsL = @($dosyalar | Where-Object { $_.Name -like 'SHA256SUMS*.txt' })   # SHA256SUMS.txt ya da SHA256SUMS-motor/-cuda.txt
            foreach ($sumsF in $sumsL) {
                foreach ($satir in Get-Content -LiteralPath $sumsF.FullName) {
                    if ($satir -match '^([0-9a-fA-F]{64})\s+\*?(.+)$') {
                        $f = $dosyalar | Where-Object { $_.Name -eq $Matches[2].Trim() } | Select-Object -First 1
                        if (-not $f) { throw "zip icinde SHA256SUMS.txt'de listeli dosya yok: $($Matches[2])" }
                        if ((Sha256 $f.FullName) -ne $Matches[1].ToLower()) { throw "zip icindeki dosya sha256 tutmadi: $($f.Name)" }
                    }
                }
            }
            $lis = Join-Path (Join-Path (Split-Path -Parent $Motor) 'lisanslar') ([IO.Path]::GetFileNameWithoutExtension($zip)); New-Item -ItemType Directory -Force $lis | Out-Null
            foreach ($f in $dosyalar) {
                if ($f.Extension -in @('.exe', '.dll') -or $f.Name -eq 'HIZ_PAKETI.txt') { Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Motor $f.Name) -Force }
                else { Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $lis $f.Name) -Force }
            }
            Remove-Item -LiteralPath $ac -Recurse -Force
            Say "  yerlestirildi: $($p[0].ad)"
        }
        } catch {
            $mesaj = $_.Exception.Message; $kod = 1
            if ($mesaj.StartsWith('ZIP2:')) { $mesaj = $mesaj.Substring(5); $kod = 2 }
            $mk = $(if ($kod -eq 2) { 'VT-E-MOTOR-ZIP' } elseif ($mesaj -match 'sha256') { 'VT-E-HASH' } else { 'VT-E-MOTOR' }); Say "MOTOR ADIMI DURDU: [$mk] $mesaj"
            Say '  Yerel zip icin: -MotorZip <yol> -CudaZip <yol> verin (docs\KURULUM.md). Model indirilmedi/motor kurulmadi.'
            exit $kod
        }
    }
    # DLL yukleme yoklamasi (eksik DLL = 0xC0000135)
    if (-not (Test-Path -LiteralPath $sd)) { throw "sd-cli.exe yok: $Motor" }
    $eskiPath = $env:PATH; $env:PATH = "$Motor;$env:PATH"
    try { $sp = Start-Process -FilePath $sd -ArgumentList '--help' -WindowStyle Hidden -PassThru -Wait -RedirectStandardOutput (Join-Path $Root 'runs\yoklama_out.txt') -RedirectStandardError (Join-Path $Root 'runs\yoklama_err.txt') } catch { throw "sd-cli baslatilamadi: $($_.Exception.Message)" } finally { $env:PATH = $eskiPath }
    if ($sp.ExitCode -eq -1073741515) { throw '[VT-E-DLL] sd-cli DLL eksik (0xC0000135): cudart/cublas ve VC++ calisma zamanini kontrol edin' }
    Say "  sd-cli yoklamasi tamam (cikis $($sp.ExitCode))"
    # Secilen motoru kaydet: uret.ps1 buradan okur (VT_ENGINE_BIN verilmediyse). Yalniz bu repo kokundeki engine\secili_motor.json; baska yere yazmaz.
    $sec = [ordered]@{ motor = $MotorId; bin = ([string]$MotorTanim.bin); kart_sinifi = $(if ($Sinif) { [string]$Sinif.id } else { '' }); kart = $Kart.ad; tablo_surumu = $KartTablo.surum; tarih = (Get-Date).ToString('s') }
    New-Item -ItemType Directory -Force (Join-Path $Root 'engine') | Out-Null
    ($sec | ConvertTo-Json) | Set-Content -LiteralPath (Join-Path (Join-Path $Root 'engine') 'secili_motor.json') -Encoding ASCII
}

# ---------------------------------------------------------------- model
function Model-Bagla {
    $kayit = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'modeller.json') -Raw -Encoding UTF8 | ConvertFrom-Json
    New-Item -ItemType Directory -Force $ModelDir | Out-Null
    foreach ($d in $kayit.dosyalar) {
        Dur-Kontrol
        $k = Join-Path $ModelKlasoru $d.hedef; $h = Join-Path $ModelDir $d.hedef
        if (-not (Test-Path -LiteralPath $k)) { Say "  baglanmadi (kaynakta yok): $($d.hedef)"; continue }
        if ((Test-Path -LiteralPath $h) -and ((Get-Item -LiteralPath $h).Length -eq $d.boyut)) { Say "  zaten var: $($d.hedef)"; continue }
        Say "  sha256 hesaplaniyor: $($d.hedef) (buyuk dosya, dakikalar surer)"
        if ((Sha256 $k) -ne $d.sha256.ToLower()) { Say "  UYARI: sha256 eslesmedi, baglanmadi (indirilecek): $($d.hedef)"; continue }
        if ([IO.Path]::GetPathRoot($k) -eq [IO.Path]::GetPathRoot($h)) { & cmd.exe /c mklink /H "$h" "$k" 2>&1 | Out-Null }
        if (-not (Test-Path -LiteralPath $h)) { Say ("  NOT: baska surucu, sert baglanti olmaz: KOPYALANIYOR (ek {0:N1} GiB yer; bagli kalmasini istemiyorsaniz modeli bu surucuye tasiyin): {1}" -f ($d.boyut / 1GB), $d.hedef); Copy-Item -LiteralPath $k -Destination $h }
        Say "  BAGLANDI (yerel dosyadan, indirilmedi): $($d.hedef)"
    }
}
function Adim-Model {
    Say '== model: 4 model dosyasi (commit-sabit adres + sha256), lisans kabul gerekir'
    $ind = Join-Path $PSScriptRoot 'modelleri_indir.ps1'
    if (-not (Test-Path -LiteralPath $ind)) { throw "modelleri_indir.ps1 yok: $ind" }
    $lisans = Join-Path $PSScriptRoot '..\docs\LISANS_KABUL.txt'
    if ($Kuru) {
        & powershell.exe -NoProfile -File $ind -Kuru -Hedef $ModelDir
        $kayitK = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'modeller.json') -Raw -Encoding UTF8 | ConvertFrom-Json
        foreach ($d in $kayitK.dosyalar) { Say ("  URL: {0}  sha256 {1}  {2} bayt" -f $d.url, $d.sha256, $d.boyut) }
        Say '  KURU: lisans kabul istenmedi, hicbir sey indirilmedi.'
        return
    }
    if ($ModelKlasoru) { Model-Bagla }
    $kabul = $LisansKabul
    if (-not $kabul) {
        Get-Content -LiteralPath $lisans | ForEach-Object { Say $_ }
        try { $kabul = Read-Host 'Onay / Confirm (TR: E  |  EN: Y)' }
        catch { Say '[VT-E-LISANS] Lisans kabulu etkilesimsiz alinamadi: kullaniciya sorun, kabul gelince -LisansKabul E (ya da Y) ile calistirin; model indirilmedi.'; exit 2 }
        if ($null -eq $kabul) { $kabul = '' }
    }
    if ($kabul.Trim().ToUpper() -notin @('E', 'Y')) { Say '[VT-E-LISANS] Lisans kabul edilmedi: model indirilmeyecek.'; exit 2 }
    Dur-Kontrol
    & powershell.exe -NoProfile -File $ind -Baslat -LisansKabul $kabul.Trim().ToUpper() -Hedef $ModelDir
    $k = $LASTEXITCODE
    if ($k -eq 4) { Say 'DURDU (indirici)'; exit 4 }
    if ($k -eq 3) { Say '[VT-E-DISK] Disk yetersiz'; exit 3 }
    if ($k -eq 2) { Say '[VT-E-LISANS] Lisans kabul gerekli'; exit 2 }
    if ($k -ne 0) { throw "modelleri_indir.ps1 cikis $k" }
    Say '  modeller tamam'
}

# ---------------------------------------------------------------- kontrol (gercek cekirdek)
function Adim-Kontrol {
    Say '== kontrol: 5 karelik GERCEK uretim (uret.ps1 ile ayni cagri yolu); yalniz basariliysa HAZIR'
    if ($Kuru) { Say '  KURU: kontrol uretimi calistirilmadi'; return }
    $kd = Join-Path $Root 'runs\kontrol'; New-Item -ItemType Directory -Force $kd | Out-Null
    $istem = Join-Path $kd 'istem.txt'
    Set-Content -LiteralPath $istem -Value 'A calm lake at sunrise with gentle ripples and soft mist, cinematic, photorealistic, quiet ambient sound.' -Encoding ASCII
    $cikti = Join-Path $kd 'kontrol.avi'
    if (Test-Path -LiteralPath $cikti) { Remove-Item -LiteralPath $cikti -Force }
    $t0 = Get-Date
    & powershell.exe -NoProfile -File (Join-Path $PSScriptRoot 'uret.ps1') -Istem $istem -Kare 5 -Cikti $cikti -Kontrol -TavanDk 30
    $k = $LASTEXITCODE
    $sn = [int]((Get-Date) - $t0).TotalSeconds
    if ($k -eq 2) { Say 'DURDU'; exit 4 }
    if ($k -ne 0 -or -not (Test-Path -LiteralPath $cikti)) {
        Say "KONTROL BASARISIZ [VT-E-KONTROL] (cikis $k, $sn sn): HAZIR YAZILMAZ. Bakin: $kd\ham_err_kontrol_a1.txt"
        Say 'Sik nedenler: eksik DLL/VC++, surucu eski, model eksik/bozuk (-Adim model), VRAM/RAM yetersiz (diger uygulamalari kapatin).'
        exit 1
    }
    $kayit = [ordered]@{ hazir = $true; tarih = (Get-Date).ToString('s'); kontrol_sn = $sn; kontrol_kare = 5 }
    ($kayit | ConvertTo-Json) | Set-Content -LiteralPath (Join-Path $Root 'runs\hazir.json') -Encoding ASCII
    Say ("HAZIR / READY (kontrol uretimi {0} sn)." -f $sn)
    Say 'Ilk video (56 kare, GTX 1050 Ti''de yaklasik 11 dk [olctum: yazarlarda kayit, baska kartta olculmedi]), repo klasorunde:'
    Say '  powershell -NoProfile -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56'
    Say 'First video (56 frames, about 11 min on a GTX 1050 Ti), same command. Longer: -Kare 141 or 209 (209 = about 57 min).'
}

function Lisans-Koruma {
    # Ajan korkulugu (kolaylik ve caydirici, KANIT DEGIL: DURUM.md'yi ajan da yazabilir): -LisansKabul verilmis ve girdi yonlendirilmisse
    # (ajan/betik gibi), kok klasordeki DURUM.md'de kullanicinin sozunu tasiyan bir "LISANS-KABUL: <soz> | <saat>" satiri olmali.
    # Terminalde elle yazan insan (girdi yonlendirilmemis) ve CI (VT_CI=1) etkilenmez. Yalniz bu betik; modelleri_indir.ps1'i dogrudan cagirmayi kapsamaz.
    if ($LisansKabul -and $env:VT_CI -ne '1') {
        $yonlendirilmis = $true
        try { $yonlendirilmis = [Console]::IsInputRedirected } catch { }
        if ($yonlendirilmis) {
            $durumYol = Join-Path $Root 'DURUM.md'
            $iz = $false
            if (Test-Path -LiteralPath $durumYol) { $iz = [bool](Select-String -LiteralPath $durumYol -Pattern '^\s*(?:[-*]\s*)?LISANS-KABUL:\s*[^<\s]\S{2,}' -Quiet) }
            if (-not $iz) { Say '[VT-E-LISANS] -LisansKabul verildi ama girdi yonlendirilmis (ajan/betik gibi gorunuyor) ve kok klasordeki DURUM.md icinde kullanicinin sozunu tasiyan "LISANS-KABUL: <soz> | <saat>" satiri yok: lisansi (docs\LISANS_KABUL.txt) kullaniciya gosterin, acik "evet" sozunu alin, o satiri yazin, sonra yeniden calistirin. Bu bir kolaylik/caydirici, kanit degil; CI icin VT_CI=1. Model indirilmedi.'; exit 2 }
        }
    }
}
if (-not $Kuru -and ($Adim -contains 'model')) { Lisans-Koruma }   # motor indirmeden ve GPU isinden once reddet
if (-not $Kuru) { New-Item -ItemType Directory -Force (Join-Path $Root 'runs') | Out-Null }   # -Kuru yan etkisiz: hicbir klasor/dosya olusturulmaz
foreach ($a in $Adim) {
    Dur-Kontrol
    switch ($a) {
        'kontrol0' { Adim-Kontrol0 }
        'motor' { Adim-Motor }
        'model' { Adim-Model }
        'kontrol' { Adim-Kontrol }
        default { throw "bilinmeyen adim: $a (kontrol0, motor, model, kontrol)" }
    }
}
if ($Kuru) {
    Say ('== KURU ON RAPOR TAMAM: {0} HATA, {1} UYARI (hicbir sey indirilmedi, kurulmadi, yazilmadi)' -f $hata.Count, $uyari.Count)
    if ($script:KuruHata) { exit 3 }
}
exit 0
