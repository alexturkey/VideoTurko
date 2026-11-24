param([Parameter(Mandatory)][string]$Dizin, [Parameter(Mandatory)][string]$Ad, [Parameter(Mandatory)][int]$Kare, [switch]$DokuNorm)
$Root = $(if($env:VT_ROOT){$env:VT_ROOT}else{(Resolve-Path (Join-Path $PSScriptRoot '..')).Path})

# URETIM_KAPI: genel CPU gorsel kapi; parametreler Dizin, Ad, Kare (beklenen kare sayisi). gurultu <= 1,5 VE orta akis > 0,05 VE kare sayisi = Kare ise GECER (cikis 0); degilse RED (olaylar, cikis 1). Kapi calisamadiysa (python/opencv/numpy yok) cikis 6 = KAPI CALISMADI (RED degil). Pafta 12 kare (ffmpeg varsa; yoksa yalniz bilgi, karar etkilenmez): select mod(n,ceil(Kare/12)). Esikler 640x384 icin kalibre.
$p=$Root; $d=$(if([IO.Path]::IsPathRooted($Dizin)){$Dizin}else{Join-Path "$p\runs" $Dizin}); $ev="$p\runs\olaylar.txt"
function Yaz($m){ Write-Output $m; $s="{0} | {1}" -f (Get-Date -Format "HH:mm:ss"),$m; foreach($k in 1..8){ try{ $fs=[IO.File]::Open($ev,"Append","Write","ReadWrite"); $by=(New-Object Text.UTF8Encoding($false)).GetBytes($s+"`r`n"); $fs.Write($by,0,$by.Length); $fs.Close(); break }catch{ Start-Sleep -Milliseconds 400 } } }
$avi="$d\$Ad.avi"; if(-not (Test-Path $avi) -and (Test-Path "$d\${Ad}l.avi")){ $avi="$d\${Ad}l.avi" }
if(-not (Test-Path $avi)){ Yaz "KAPI RED: avi yok ($d)"; exit 1 }
foreach($lg in "ham_out_$Ad.txt","ham_err_$Ad.txt"){ $lp="$d\$lg"; if(Test-Path $lp){ if(Select-String -Path $lp -Pattern 'temporal tiling|retrying with|vae decode compute failed' -Quiet){ Yaz "KAPI RED: $lg icinde karolu VAE yedegi/VAE hatasi (K-17: karolu cikti gecersiz); video kullanilmaz"; exit 1 } } }
$py=$(if($env:VT_PYTHON){$env:VT_PYTHON}elseif(Test-Path -LiteralPath (Join-Path $Root '.venv/Scripts/python.exe')){Join-Path $Root '.venv/Scripts/python.exe'}else{'python'})   # uret.ps1/kur.ps1 ile ayni sira: VT_PYTHON, kokteki .venv, PATH'teki python (PR #14)
if(-not (Get-Command $py -ErrorAction SilentlyContinue)){ Yaz "KAPI CALISMADI: python bulunamadi ($py); python 3 + 'py -3 -m pip install opencv-python numpy' kurun, VT_PYTHON ile yolunu verin"; exit 6 }
$o = & $py -I "$PSScriptRoot\dikis_denetim.py" $avi 2>&1 | Out-String; $pyKod=$LASTEXITCODE
if($pyKod -eq 9009){ Yaz "KAPI CALISMADI: python kurulu degil ($py cikis 9009 = Windows Store kisayolu); python.org'dan Python 3 + 'py -3 -m pip install opencv-python numpy' kurun ya da VT_PYTHON ile python.exe yolunu verin"; exit 6 }
if($o -match 'No module named|ModuleNotFoundError|ImportError|DLL load failed|can.t open file'){ $t0=($o -replace '\s+',' ').Trim(); Yaz "KAPI CALISMADI: python'da opencv-python/numpy yok, yuklenemedi ya da denetim betigi bulunamadi ('$py -m pip install opencv-python numpy'; VT_PYTHON): $($t0.Substring(0,[Math]::Min(160,$t0.Length)))"; exit 6 }
$t=($o -replace '\s+',' ').Trim()
$m=[regex]::Match($o,'kare=(\d+) gurultu=([0-9.]+).*?orta akis=([0-9.]+)')
if(-not $m.Success){ Yaz "KAPI RED: dikis_denetim cikti ayristirilamadi: $($t.Substring(0,[Math]::Min(200,$t.Length)))"; exit 1 }
$olc=[int]$m.Groups[1].Value; $gur=[double]::Parse($m.Groups[2].Value,[Globalization.CultureInfo]::InvariantCulture); $ak=[double]::Parse($m.Groups[3].Value,[Globalization.CultureInfo]::InvariantCulture)
$ff=$null; $ffAday=@($env:VT_FFMPEG, (Join-Path $(if($env:VT_ENGINE_BIN){$env:VT_ENGINE_BIN}else{"$p\engine\bin"}) 'ffmpeg.exe'), 'ffmpeg') | Where-Object { $_ }
foreach($c in $ffAday){ $g=Get-Command $c -ErrorAction SilentlyContinue; if($g){ $ff=$g.Source; break } }
$pafta="$d\pafta_$Ad.png"; if(Test-Path $pafta){ Remove-Item $pafta -Force -ErrorAction SilentlyContinue }   # eski kosunun paftasi yeni sanilmasin
if($ff){ & $ff -v error -y -i $avi -vf "select='not(mod(n,$([int][Math]::Ceiling($Kare/12))))',scale=320:-1,tile=4x3" -frames:v 1 $pafta; if(-not (Test-Path $pafta)){ $pafta='yazilamadi (ffmpeg hata verdi)' } }
else { $pafta='yok'; Yaz "BILGI: ffmpeg bulunamadi (VT_FFMPEG, motor klasoru, PATH denendi): pafta yazilmadi, kapi karari etkilenmez. Pafta icin: winget install Gyan.FFmpeg ya da VT_FFMPEG=<ffmpeg.exe yolu>" }
if($DokuNorm){ $dn = (& $py -I "$PSScriptRoot\doku_norm.py" $avi 2>&1 | Out-String).Trim(); Yaz "DOKU_NORM (bilgi, kapi degil): $dn"; $sk = (& $py -I "$PSScriptRoot\son_kare_denetim.py" $avi 2>&1 | Out-String).Trim(); if($LASTEXITCODE -eq 0 -and $sk){ Yaz $sk } }
$ok = ($olc -eq $Kare) -and ($gur -le 1.5) -and ($ak -gt 0.05)
if($ok){ Yaz "KAPI GECTI: kare=$olc gurultu=$gur orta_akis=$ak pafta=$pafta"; exit 0 }
if(($olc -eq $Kare) -and ($ak -gt 0.05)){ Yaz "BILGI: yalniz gurultu esigi asildi; dokulu sahne (kum, cim, dal) olabilir: DOKU_NORM N degerine ve klibin kendisine bakin (docs\KAPILAR.md 3; 640x384 temiz bant N 0,034-0,052). Esik gevsetilmez." }
Yaz "KAPI RED: kare=$olc (beklenen $Kare) gurultu=$gur (<=1,5) orta_akis=$ak (>0,05); gonderim gitmez; pafta=$pafta"; exit 1
