# VideoTurko tani.ps1 (diagnosis report / teshis raporu)
# EN: Collects a short, privacy-filtered report you can paste into an issue: Windows and PowerShell version, GPU (nvidia-smi),
#     RAM, free disk, the VideoTurko version, the dry-run report of kur.ps1 (-Kuru: reads and prints, installs nothing), and
#     optional log files you name with -Log. It then matches the text against docs\hata_imzalari.json (plain sub-strings) and
#     lists the stable error codes (VT-E-...) with the first step. It sends NOTHING: no network, it does not upload or post
#     itself; it only prints (and writes a file if you give -Cikti). Your user name, machine name, home folder, e-mail
#     addresses, tokens, other drive letters and 8.3 short names are replaced with <...> markers before anything is shown.
#     The filter is a rough pattern: READ the report before you paste it; it is not a privacy guarantee.
#       powershell -NoProfile -ExecutionPolicy Bypass -File scripts\tani.ps1                  (text report)
#       ... -File scripts\tani.ps1 -Json                                                       (same as JSON, ASCII)
#       ... -File scripts\tani.ps1 -KartSatiri                                                 (one line for an issue title/card)
#       ... -File scripts\tani.ps1 -Log C:\vt\runs\x.log -Cikti tani_raporu.txt               (add a log, write a file)
#     Options: -KuruAtla (skip the kur.ps1 dry run), -Gizle name1,name2 (extra words to hide), env VT_TANI_GIZLE (same, ';' separated).
# TR: Bir issue'ya yapistirabileceginiz kisa, gizlilik suzgecinden gecmis bir rapor toplar: Windows ve PowerShell surumu, kart
#     (nvidia-smi), RAM, bos disk, VideoTurko surumu, kur.ps1 kuru calisma raporu (-Kuru: okur ve yazar, hicbir sey kurmaz) ve
#     -Log ile verdiginiz dosyalar. Sonra metni docs\hata_imzalari.json ile (duz alt dize) eslestirir ve kararli hata kodlarini
#     (VT-E-...) ilk adimla listeler. HICBIR SEY GONDERMEZ: ag yok, kendiliginden yuklemez ve paylasmaz; yalniz ekrana yazar
#     (-Cikti verirseniz dosyaya da yazar). Kullanici adiniz, makine adiniz, ev klasoruz, e-posta, anahtar, diger surucu harfleri ve
#     8.3 kisa adlar gosterilmeden once <...> isaretiyle degistirilir. Suzgec kaba bir desendir: yapistirmadan once raporu OKUYUN;
#     gizlilik garantisi degildir.
# Exit codes / cikis kodlari: 0 report made / rapor uretildi (even if errors were found / hata bulunsa da), 6 could not run / calismadi.
#     DEVIATIONS / SAPMA section (read only): Python versions (py -0p) and which one is first on PATH, locally changed tracked files
#     (git status, names only), VT_* environment overrides, model files present / missing / wrong size, and known copies of those model
#     files in the Hugging Face cache (name and size only, nothing is hashed or moved). An agent reads it to answer "what differs from the defaults".
# Safe: it only reads files and runs read-only commands (nvidia-smi, py -0p, git --no-optional-locks status, scripts\kur.ps1 -Kuru). No windows, no changes.
[CmdletBinding()]
param(
    [switch]$Json,
    [switch]$KartSatiri,
    [switch]$KuruAtla,
    [string[]]$Log = @(),
    [string]$Cikti = '',
    [string[]]$Gizle = @()
)
$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding($false) } catch { }
$kok = Split-Path -Parent $PSScriptRoot

# ------------------------------------------------------------------ gizlilik suzgeci / privacy filter
$adlar = New-Object System.Collections.ArrayList     # @(@{Metin=...; Isaret=...})
function AdEkle([string]$metin, [string]$isaret) {
    if ($metin -and $metin.Trim().Length -ge 3) {
        [void]$adlar.Add(@{ Metin = $metin.Trim(); Isaret = $isaret })
        # a name with spaces also shows up in file names as Name_Part, Name-Part, Name.Part or NamePart
        if ($metin.Trim() -match ' ' -and $isaret -notmatch '^<(ROOT|HOME|TEMP)') {
            foreach ($ayrac in @('_', '-', '.', '')) { [void]$adlar.Add(@{ Metin = ($metin.Trim() -replace ' +', $ayrac); Isaret = $isaret }) }
        }
    }
}
# longest first so that a full path is replaced before the name inside it
AdEkle $kok '<ROOT>'
AdEkle ($kok -replace '\\', '/') '<ROOT>'
AdEkle $env:USERPROFILE '<HOME>'
AdEkle ($env:USERPROFILE -replace '\\', '/') '<HOME>'
AdEkle $env:TEMP '<TEMP>'
AdEkle $env:LOCALAPPDATA '<HOME>\AppData\Local'
AdEkle $env:APPDATA '<HOME>\AppData\Roaming'
AdEkle $env:HOMEPATH '<HOME>'
if ($env:USERPROFILE) { AdEkle (Split-Path -Leaf $env:USERPROFILE) '<USER>' }
AdEkle $env:USERNAME '<USER>'
try { AdEkle ([Environment]::UserName) '<USER>' } catch { }
AdEkle $env:COMPUTERNAME '<MACHINE>'
AdEkle $env:USERDOMAIN '<MACHINE>'
try { AdEkle ([Environment]::MachineName) '<MACHINE>' } catch { }
foreach ($g in $Gizle) { AdEkle $g '<HIDDEN>' }
if ($env:VT_TANI_GIZLE) { foreach ($g in ($env:VT_TANI_GIZLE -split ';')) { AdEkle $g '<HIDDEN>' } }
$adlarSirali = @($adlar | Sort-Object { $_.Metin.Length } -Descending)

$ro = [System.Text.RegularExpressions.RegexOptions]
$IC = $ro::IgnoreCase
# secrets (same families as scripts/gizlilik_denetimi.py)
$reSir = New-Object System.Text.RegularExpressions.Regex(('\bsk-(?:ant-|proj-)?[A-Za-z0-9_-]{20,}' +
    '|\bAIza[0-9A-Za-z_-]{35}\b|\bgh[pousr]_[A-Za-z0-9]{36,}\b|\bgithub_pat_[A-Za-z0-9_]{22,}\b|\bhf_[A-Za-z0-9]{30,}\b' +
    '|\bgsk_[A-Za-z0-9]{40,}\b|\bxox[abprs]-[A-Za-z0-9-]{10,}|\bAKIA[0-9A-Z]{16}\b|\b\d{8,10}:AA[A-Za-z0-9_-]{30,}\b' +
    '|-----BEGIN (?:RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----|discord(?:app)?\.com/api/webhooks/\d+' +
    '|\b(?:api[_-]?key|secret|token|password|passwd)\s*[=:]\s*[''"][A-Za-z0-9_\-./+=]{16,}[''"]'), $IC)
$reHome1 = New-Object System.Text.RegularExpressions.Regex('\b[A-Za-z]:[\\/]+(?:Users|Documents and Settings)[\\/]+[^\\/"''`<>|*?\r\n]+', $IC)
$reHome2 = New-Object System.Text.RegularExpressions.Regex('(?<![\w.])/(?:c|mnt/c)/Users/[^/"''`<>|*?\r\n]+', $IC)
$reHome3 = New-Object System.Text.RegularExpressions.Regex('(?<![\w.])/(?:home|Users)/[A-Za-z0-9_.-]+(?=/)', $IC)
$reUnc = New-Object System.Text.RegularExpressions.Regex('\\\\[^\\/\s"''`<>|*?]+(?=[\\/])', $IC)
# other drives: the folder part goes too (a folder name can be private), the file name stays; a folder name may hold up to 4 words
$reSurucu = New-Object System.Text.RegularExpressions.Regex('(?<![\w`])[D-Zd-z]:[\\/]+(?:[^\\/\s"''`<>|*?]+(?: [^\\/\s"''`<>|*?]+){0,3}[\\/]+)*', $IC)
$reKisa = New-Object System.Text.RegularExpressions.Regex('[A-Za-z0-9_]{2,8}~[0-9](?=[\\/\s"'']|$)', $IC)
$reEposta = New-Object System.Text.RegularExpressions.Regex('(?<![A-Za-z0-9])[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+(?:\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}\b', $IC)

function Gizle-Metin([string]$s) {
    if ([string]::IsNullOrEmpty($s)) { return $s }
    foreach ($a in $adlarSirali) {
        $s = [regex]::Replace($s, [regex]::Escape($a.Metin), $a.Isaret.Replace('$', '$$'), $IC)
    }
    $s = $reHome1.Replace($s, '<HOME>')
    $s = $reHome2.Replace($s, '<HOME>')
    $s = $reHome3.Replace($s, '<HOME>')
    $s = $reUnc.Replace($s, '\\<SERVER>')
    $s = $reSurucu.Replace($s, '<DRIVE>:\<DIR>\')
    $s = $reKisa.Replace($s, '<SHORTNAME>')
    $s = $reSir.Replace($s, '<SECRET>')
    $s = $reEposta.Replace($s, '<EMAIL>')
    # last safety net: if a known name is STILL inside, drop the whole line (fail closed)
    $guvenli = New-Object System.Collections.ArrayList
    foreach ($satir in ($s -split "`r?`n")) {
        $kaldi = $false
        foreach ($a in $adlarSirali) { if ($a.Metin.Length -ge 3 -and $satir.IndexOf($a.Metin, [StringComparison]::OrdinalIgnoreCase) -ge 0) { $kaldi = $true; break } }
        if ($kaldi) { [void]$guvenli.Add('<line removed: a private name survived the filter / satir silindi: ozel ad suzgeci gecti>') } else { [void]$guvenli.Add($satir) }
    }
    return ($guvenli -join "`n")
}

# ------------------------------------------------------------------ olcumler / measurements (read only)
function Say-Hata([string]$m) { [Console]::Error.WriteLine($m) }

$sistem = [ordered]@{ windows = ''; powershell = ''; gpu = ''; vram_mb = ''; surucu = ''; cc = ''; ram_gb = ''; bos_disk_gib = ''; surum = '' }
try { $os = Get-CimInstance Win32_OperatingSystem; $sistem.windows = ('{0} (build {1})' -f $os.Caption, $os.BuildNumber) } catch { $sistem.windows = 'unknown' }
$sistem.powershell = $PSVersionTable.PSVersion.ToString()
try { $cs = Get-CimInstance Win32_ComputerSystem; $sistem.ram_gb = [string][math]::Round($cs.TotalPhysicalMemory / 1GB, 1) } catch { $sistem.ram_gb = 'unknown' }
try {
    $ad = (Split-Path -Qualifier $kok)
    if ($ad -and $ad.Length -ge 2 -and $ad[1] -eq ':') {
        $d = New-Object System.IO.DriveInfo($ad.Substring(0, 1))
        $sistem.bos_disk_gib = [string][math]::Round($d.AvailableFreeSpace / 1GB, 1)
    } else { $sistem.bos_disk_gib = 'unknown' }
} catch { $sistem.bos_disk_gib = 'unknown' }
$sistem.gpu = 'none (nvidia-smi missing or silent)'
$smi = Get-Command nvidia-smi -ErrorAction SilentlyContinue
if ($smi) {
    foreach ($alanlar in @('name,memory.total,driver_version,compute_cap', 'name,memory.total,driver_version')) {
        try {
            $c = & $smi.Source "--query-gpu=$alanlar" '--format=csv,noheader,nounits' 2>$null
            if ($LASTEXITCODE -eq 0 -and $c) {
                $p = ("$(@($c)[0])" -split ',') | ForEach-Object { $_.Trim() }
                $sistem.gpu = $p[0]; $sistem.vram_mb = $p[1]; $sistem.surucu = $p[2]
                if ($p.Count -ge 4) { $sistem.cc = $p[3] }
                break
            }
        } catch { }
    }
}
if ($sistem.gpu -like 'none*') {
    # No nvidia-smi: add the display adapter NAME only (helps AMD / non-NVIDIA reports; see docs/AMD_ROCM.md). Name only, no ids.
    try {
        $adlar = @(Get-CimInstance Win32_VideoController | ForEach-Object { "$($_.Name)".Trim() } | Where-Object { $_ })
        if ($adlar.Count -gt 0) { $sistem.gpu = $sistem.gpu + '; display adapter: ' + ($adlar -join ' + ') }
    } catch { }
}
$cl = Join-Path $kok 'CHANGELOG.md'
$sistem.surum = 'unknown'
if (Test-Path -LiteralPath $cl) {
    foreach ($satir in (Get-Content -LiteralPath $cl -Encoding UTF8 -TotalCount 80)) {
        if ($satir -match '^##\s+(v\d[^\s]*)') { $sistem.surum = $Matches[1]; break }
    }
}

# the kur.ps1 dry run (read only; it downloads and writes nothing)
$kuru = [ordered]@{ calisti = $false; hata = 0; uyari = 0; satirlar = @() }
$ham = ''
if (-not $KuruAtla) {
    $kurPs = Join-Path $PSScriptRoot 'kur.ps1'
    if (Test-Path -LiteralPath $kurPs) {
        try {
            $ErrorActionPreference = 'Continue'
            $kc = & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $kurPs -Kuru 2>&1 | Out-String
            $ErrorActionPreference = 'Stop'
            $ham += $kc + "`n"
            $kuru.calisti = $true
            $sat = New-Object System.Collections.ArrayList
            foreach ($l in ($kc -split "`r?`n")) {
                if ($l -match '^\s*(HATA:|UYARI:|EKSIK:)' -or $l -match 'KURU ON RAPOR TAMAM' -or $l -match 'bos disk:') { [void]$sat.Add($l.TrimEnd()) }
                if ($l -match 'KURU ON RAPOR TAMAM:\s*(\d+)\s*HATA,\s*(\d+)\s*UYARI') { $kuru.hata = [int]$Matches[1]; $kuru.uyari = [int]$Matches[2] }
            }
            $kuru.satirlar = @($sat)
        } catch { $ErrorActionPreference = 'Stop'; Say-Hata "UYARI: kur.ps1 -Kuru could not run / calismadi: $($_.Exception.Message)" }
    }
}

# deviations from the defaults (read only; sapma): Python, local changes, VT_* overrides, model files, known copies
$sapma = [ordered]@{ python = @(); python_ilk = ''; git = 'not a git checkout or git missing'; degisen = @(); vt_env = @(); modeller = @(); kopyalar = @() }
try {
    $py = Get-Command py -ErrorAction SilentlyContinue
    if ($py) {
        $o = @(& $py.Source -0p 2>$null)
        $sapma.python = @($o | ForEach-Object { "$_".Trim() } | Where-Object { $_ -and $_ -notmatch '^(Installed Python|No Installed)' } | Select-Object -First 12)
    }
    $pc = @(Get-Command python -All -ErrorAction SilentlyContinue | Select-Object -First 3)
    if ($pc.Count -gt 0) {
        $ilk = $pc[0].Source
        if ($ilk -match 'WindowsApps') { $sapma.python_ilk = 'first on PATH is the Microsoft Store shortcut (exit 9009: it is not a real Python)' }
        else { $v = "$(& $ilk --version 2>&1)".Trim(); $sapma.python_ilk = "first on PATH: $v ($ilk)" }
    } else { $sapma.python_ilk = 'no python on PATH' }
} catch { $sapma.python_ilk = 'could not read Python versions' }
try {
    $gitK = Get-Command git -ErrorAction SilentlyContinue
    if ($gitK -and (Test-Path -LiteralPath (Join-Path $kok '.git'))) {
        $gs = @(& $gitK.Source --no-optional-locks -C $kok status --short -uno 2>$null)
        $sapma.degisen = @($gs | ForEach-Object { "$_".Trim() } | Where-Object { $_ } | Select-Object -First 40)
        $sapma.git = $(if ($sapma.degisen.Count -eq 0) { 'tracked files unchanged' } else { "$($sapma.degisen.Count) tracked file(s) changed" })
    }
} catch { $sapma.git = 'could not read git status' }
try {
    $sapma.vt_env = @(Get-ChildItem Env: | Where-Object { $_.Name -like 'VT_*' -and $_.Name -ne 'VT_TANI_GIZLE' } | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Value)" })
} catch { }
$modelKok = $(if ($env:VT_ROOT) { $env:VT_ROOT } else { $kok })
$modelDir = $(if ($env:VT_MODEL_DIR) { $env:VT_MODEL_DIR } else { Join-Path $modelKok 'model' })
$hfDirs = @()
foreach ($h in @($(if ($env:HF_HUB_CACHE) { $env:HF_HUB_CACHE }), $(if ($env:HF_HOME) { Join-Path $env:HF_HOME 'hub' }), $(if ($env:USERPROFILE) { Join-Path $env:USERPROFILE '.cache\huggingface\hub' }))) {
    if ($h -and (Test-Path -LiteralPath $h -PathType Container) -and ($hfDirs -notcontains $h)) { $hfDirs += $h }
}
try {
    $mj = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'modeller.json') -Raw -Encoding UTF8 | ConvertFrom-Json
    foreach ($d in $mj.dosyalar) {
        $yol = Join-Path $modelDir $d.hedef
        if (Test-Path -LiteralPath $yol -PathType Leaf) {
            $bt = (Get-Item -LiteralPath $yol).Length
            $dur = $(if ($bt -eq [int64]$d.boyut) { 'present, size matches (sha256 not read: scripts\modelleri_indir.ps1 -Dogrula checks it)' } else { "present but size $bt differs from expected $($d.boyut)" })
        } else { $dur = 'missing' }
        $sapma.modeller += , ("$($d.hedef): $dur")
        if ($dur -eq 'missing') {
            foreach ($hd in $hfDirs) {
                $f = Get-ChildItem -LiteralPath $hd -Recurse -File -Filter $d.hedef -ErrorAction SilentlyContinue | Select-Object -First 1
                if ($f) { $sapma.kopyalar += , ("$($d.hedef): a copy exists in the Hugging Face cache, $([math]::Round($f.Length / 1GB, 2)) GiB ($(if ($f.Length -eq [int64]$d.boyut) { 'size matches: kur.ps1 -ModelKlasoru can reuse it after the user agrees' } else { 'size differs: do not reuse' }))"); break }
            }
        }
    }
} catch { $sapma.modeller = @('could not read scripts\modeller.json') }

# log files the user named (last 400 lines, at most 2 MB each)
$loglar = @()
foreach ($lf in $Log) {
    try {
        $fi = Get-Item -LiteralPath $lf -ErrorAction Stop
        if ($fi.Length -gt 2MB) { $icerik = (Get-Content -LiteralPath $lf -Encoding UTF8 -Tail 400) } else { $icerik = @(Get-Content -LiteralPath $lf -Encoding UTF8) | Select-Object -Last 400 }
        $metin = ($icerik -join "`n")
        $ham += $metin + "`n"
        $loglar += , @{ ad = (Gizle-Metin $fi.Name); satirlar = @(((Gizle-Metin $metin) -split "`n") | Select-Object -Last 20) }
    } catch { $loglar += , @{ ad = '(unreadable / okunamadi)'; satirlar = @() } }
}

# ------------------------------------------------------------------ hata imzasi eslestirme / signature matching (plain sub-strings)
$maskeli = Gizle-Metin $ham
$bulunan = @()
$imzaYol = Join-Path $kok 'docs\hata_imzalari.json'
$imzaDurum = 'ok'
if (Test-Path -LiteralPath $imzaYol) {
    try {
        $j = Get-Content -LiteralPath $imzaYol -Raw -Encoding UTF8 | ConvertFrom-Json
        foreach ($k in $j.kodlar) {
            $hit = $false
            foreach ($im in $k.imza) { if ($im -and $maskeli.IndexOf([string]$im, [StringComparison]::OrdinalIgnoreCase) -ge 0) { $hit = $true; break } }
            if ($hit) {
                $bulunan += , ([ordered]@{ kod = $k.kod; tur = $k.tur; baslik_en = $k.baslik_en; baslik_tr = $k.baslik_tr; ilk_adim_en = $k.ilk_adim_en; ilk_adim_tr = $k.ilk_adim_tr; capa = $k.capa })
            }
        }
    } catch { $imzaDurum = 'unreadable' }
} else { $imzaDurum = 'missing' }
# errors before warnings
$bulunan = @($bulunan | Sort-Object { if ($_.tur -eq 'hata') { 0 } else { 1 } }, { $_.kod })

$uyari = 'Nothing was sent anywhere. The filter hides names, paths, e-mails and tokens by pattern; read the report before you paste it, it is not a guarantee. / Hicbir yere gonderilmedi. Suzgec adlari, yollari, e-postalari ve anahtarlari desenle gizler; yapistirmadan once raporu okuyun, garanti degildir.'

$sistemM = [ordered]@{}
foreach ($k in $sistem.Keys) { $sistemM[$k] = Gizle-Metin ([string]$sistem[$k]) }
$kuruM = [ordered]@{ calisti = $kuru.calisti; hata = $kuru.hata; uyari = $kuru.uyari; satirlar = @(@($kuru.satirlar) | ForEach-Object { Gizle-Metin $_ }) }
$kodlar = @($bulunan | ForEach-Object { $_.kod })
$sapmaM = [ordered]@{}
foreach ($k in $sapma.Keys) { if ($sapma[$k] -is [string]) { $sapmaM[$k] = Gizle-Metin $sapma[$k] } else { $sapmaM[$k] = @(@($sapma[$k]) | ForEach-Object { Gizle-Metin ([string]$_) }) } }

# ------------------------------------------------------------------ cikti / output
if ($KartSatiri) {
    $kart = 'VT {0} | {1} | {2} {3} MB cc {4} | RAM {5} GB | disk {6} GiB free | kur -Kuru: {7} | imza: {8}' -f $sistemM.surum, $sistemM.windows, $sistemM.gpu, $sistemM.vram_mb, $sistemM.cc, $sistemM.ram_gb, $sistemM.bos_disk_gib, $(if ($kuruM.calisti) { "$($kuruM.hata) HATA $($kuruM.uyari) UYARI" } else { 'not run' }), $(if ($kodlar.Count) { ($kodlar -join ',') } else { 'none' })
    $son = ((Gizle-Metin $kart) -replace '[\r\n]+', ' ')
} elseif ($Json) {
    $nesne = [ordered]@{
        arac = 'VideoTurko tani.ps1'; format = 1
        sistem = $sistemM; kuru = $kuruM; sapma = $sapmaM
        bulunan_kodlar = @($bulunan); imza_dosyasi = $imzaDurum
        loglar = @($loglar); uyari = $uyari
    }
    $js = $nesne | ConvertTo-Json -Depth 6
    # ASCII only: any non-ASCII char becomes \uXXXX (safe on every console code page)
    $sb = New-Object System.Text.StringBuilder
    foreach ($ch in $js.ToCharArray()) { if ([int]$ch -gt 126 -or ([int]$ch -lt 32 -and $ch -ne "`n" -and $ch -ne "`r" -and $ch -ne "`t")) { [void]$sb.AppendFormat('\u{0:x4}', [int]$ch) } else { [void]$sb.Append($ch) } }
    $son = $sb.ToString()
} else {
    $t = New-Object System.Collections.ArrayList
    [void]$t.Add('== VideoTurko tani raporu / diagnosis report (nothing is sent / hicbir sey gonderilmez)')
    [void]$t.Add("version / surum : $($sistemM.surum)")
    [void]$t.Add("Windows         : $($sistemM.windows) | PowerShell $($sistemM.powershell)")
    [void]$t.Add("GPU             : $($sistemM.gpu) | VRAM $($sistemM.vram_mb) MB | driver $($sistemM.surucu) | cc $($sistemM.cc)")
    [void]$t.Add("RAM / disk      : $($sistemM.ram_gb) GB RAM | $($sistemM.bos_disk_gib) GiB free on the drive of the folder / klasorun surucusunde bos")
    if ($kuruM.calisti) {
        [void]$t.Add("kur.ps1 -Kuru   : $($kuruM.hata) HATA, $($kuruM.uyari) UYARI")
        foreach ($l in $kuruM.satirlar) { [void]$t.Add("  $l") }
    } else { [void]$t.Add('kur.ps1 -Kuru   : not run / calistirilmadi') }
    [void]$t.Add('DEVIATIONS / SAPMA (read only):')
    [void]$t.Add("  Python          : $($sapmaM.python_ilk)")
    foreach ($l in $sapmaM.python) { [void]$t.Add("    py -0p: $l") }
    if (-not $sapmaM.python.Count) { [void]$t.Add('    py -0p: the py launcher lists no Python') }
    [void]$t.Add("  git             : $($sapmaM.git)")
    foreach ($l in $sapmaM.degisen) { [void]$t.Add("    $l") }
    [void]$t.Add("  VT_* overrides  : $(if ($sapmaM.vt_env.Count) { $sapmaM.vt_env -join ' ' } else { 'none' })")
    foreach ($l in $sapmaM.modeller) { [void]$t.Add("  model           : $l") }
    foreach ($l in $sapmaM.kopyalar) { [void]$t.Add("  known copy      : $l") }
    foreach ($lg in $loglar) {
        [void]$t.Add("log $($lg.ad) (last lines / son satirlar):")
        foreach ($l in $lg.satirlar) { [void]$t.Add("  $l") }
    }
    if ($bulunan.Count) {
        [void]$t.Add('error codes found / bulunan hata kodlari:')
        foreach ($b in $bulunan) {
            [void]$t.Add("  [$($b.kod)] $($b.baslik_en) / $($b.baslik_tr)")
            [void]$t.Add("    EN: $($b.ilk_adim_en)")
            [void]$t.Add("    TR: $($b.ilk_adim_tr)")
            [void]$t.Add("    more / ayrinti: $($b.capa)")
        }
    } else { [void]$t.Add("error codes found / bulunan hata kodlari: none / yok (signature file: $imzaDurum)") }
    [void]$t.Add($uyari)
    $son = ((Gizle-Metin ($t -join "`n")))
}

if ($Cikti) {
    try { [System.IO.File]::WriteAllText($(if ([System.IO.Path]::IsPathRooted($Cikti)) { $Cikti } else { Join-Path (Get-Location).Path $Cikti }), ($son + "`r`n"), (New-Object System.Text.UTF8Encoding($false))) }
    catch { Say-Hata "HATA: could not write the file / dosya yazilamadi: $($_.Exception.Message)"; exit 6 }
}
Write-Output $son
exit 0
