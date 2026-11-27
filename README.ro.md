# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · Română · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

Traducerile urmează acest README în engleză. Dacă o traducere diferă sau rămâne în urmă, textul în engleză este cel valabil, mai ales pentru textul despre licență și securitate ([`SECURITY.md`](SECURITY.md) și [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) sunt păstrate doar în engleză și turcă).

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **Înainte să începeți (licență, teritoriu):** acest depozit este MIT și conține doar patch-uri și scripturi. Modelul MiniMax H3 pe care îl descarcă este sub MiniMax H3 Community License: teritoriul ei exclude Uniunea Europeană, Regatul Unit, Coreea de Sud și Statele Unite, iar modelul, derivatele **și ieșirile (videoclipurile pe care le generați)** nu pot fi folosite, distribuite sau afișate acolo (V.4). Utilizarea comercială este permisă în limitele termenilor licenței. Citiți [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) înainte de instalare; aceasta nu este consultanță juridică.

> **În 30 de secunde:** o placă video de 4 GB poate genera un videoclip MiniMax H3 de 209 de cadre (8,7 s) dintr-o singură trecere: verificat pe un singur calculator (GTX 1050 Ti 4 GB; instalarea completă cu `kur.ps1` într-un folder gol nu a fost încă verificată cap-coadă) [măsurat: 209 cadre cu binarul de release prin `uret.ps1`, rularea U209; latentul identic la nivel de octet cu rularea build-ului de dezvoltare; cadrele și sunetul sunt identice în videoclip, sha-ul fișierului diferă din cauza containerului; dovezile sunt păstrate de autori, nu se află în acest depozit]; cu `-InitImg` (imagine-în-video) cel mult 192 de cadre (8,0 s) [măsurat: rularea B192]; 209 cadre durează aproximativ 57 min, limita de timp implicită este de 80 min [măsurat: rularea U209]; cei 3 pași de mai jos arată cum se rulează.

VideoTurko: patch-uri de memorie pentru stable-diffusion.cpp și rețete pentru a rula generarea text-în-video MiniMax H3 pe un GTX 1050 Ti de 4 GB, până la 209 cadre (8,7 s) dintr-o singură trecere; imagine-în-video (`-InitImg`) până la 192 de cadre (8,0 s) (209 cadre verificate printr-un lanț de octeți; identic la nivel de octet cu rularea fără patch-uri la verificările de 56 și 141 de cadre).

## Pornire rapidă (Windows, 3 pași)
**Stare: scripturile de instalare și rulare de mai jos sunt în curs de finalizare, iar testul pe un folder gol (clean-root) este în așteptare; nimic de aici nu se afirmă că funcționează până când acest test nu este trecut (vedeți „Stare și limite”).**

1. **Descărcați** acest depozit (butonul verde **Code**, apoi **Download ZIP**) și extrageți-l într-un folder cu cale SCURTĂ, de exemplu `C:\vt`.
2. **Instalare: dați dublu clic pe `kur.cmd`** (se deschide o fereastră neagră care arată fiecare pas; închiderea ei oprește instalarea, iar rularea din nou continuă de unde a rămas: un fișier de model descărcat pe jumătate este reluat [citit: scriptul de descărcare păstrează un fișier `.part` și continuă de la el; reluarea completă pentru 29 GiB nu a fost măsurată]). Dacă Windows avertizează în legătură cu fișierul descărcat, folosiți în schimb comanda PowerShell de mai jos [sfat, netestat pe un ZIP descărcat]. Preferați linia de comandă? Deschideți PowerShell în acel dosar (tastați `powershell` în bara de adrese din Explorer) și rulați aceeași instalare:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   Rădăcina instalării este folderul extras (motorul ajunge în `engine\bin`, modelele în `model`); pentru alt loc setați mai întâi variabila de mediu `VT_ROOT`. Scriptul verifică GPU-ul, driverul, RAM-ul și discul, descarcă motorul și modelele (arhivele zip ale motorului și fișierele de model descărcate acum sunt verificate cu sha256; un fișier de model deja prezent, cu dimensiunea corectă, este verificat doar după dimensiune, iar `scripts\modelleri_indir.ps1 -Dogrula` rulează verificarea sha256 completă), rulează o scurtă verificare reală și afișează READY numai dacă verificarea a trecut [proiectat: `kur.ps1` nu a fost rulat integral într-un folder curat; această propoziție se actualizează după testul în folder curat]. `-ExecutionPolicy Bypass` se aplică numai acestui proces; citiți mai întâi `scripts\kur.ps1`, ca la orice program de instalare.
   Zip-ul motorului vine din release-ul GitHub v0.1.0 (publicat pe 2026-11-19; sha256-ul său este fixat în `kur.ps1`). Fără internet sau cu propriul build, indicați arhive locale: `-MotorZip <path> -CudaZip <path>`. O arhivă locală este verificată cu același sha256 fixat (un fișier `.sha256` de lângă ea este ignorat), deci trebuie să fie zip-ul din release; pentru propriul build setați mai întâi `VT_MOTOR_SHA256` / `VT_CUDA_SHA256` la sha256-ul acestuia. Un sha256 greșit oprește scriptul cu exit 1. Numai `.exe`/`.dll` ajung în `engine\bin`; licențele și README-ul ajung în `engine\lisanslar\<zip name>\`. [încercat cu arhivele dist înainte de release: fișierul însoțitor `.sha256` plus avertismentul de auto-referință, binarul și DLL-urile plasate, `sd-cli --help` a rulat; sha-urile binarelor instalate au coincis (`c5cebe78...`, `e5d3d329...`); pasul cu modelele și verificarea de 5 cadre din `kur.ps1` NU au fost încă rulate pe un GPU real]
   **Licența modelului:** înainte de pasul cu modelele, programul de instalare afișează rezumatul licenței (`docs/LISANS_KABUL.txt`, textul complet în `docs/LISANS_UYARISI.md`: MiniMax H3 Community License, limite teritoriale care se aplică și videoclipurilor generate, reguli privind uzul comercial și etichetarea AI) și vă cere acceptul (`E` = da). Citiți-o mai întâi. Pentru rulări fără supraveghere puteți transmite `-LisansKabul E`, ceea ce înseamnă că ați citit și ați acceptat licența personal; nu o adăugați în locul altcuiva. (Agenți AI: urmați `AGENTS.md`; nu tastați niciodată E fără acordul utilizatorului.) Fără acceptare, `kur.ps1` se oprește cu codul de ieșire 2 și nu descarcă niciun model.
3. **Primul dumneavoastră videoclip (56 de cadre, cam 11 min pe GTX 1050 Ti-ul nostru** [măsurat: 641 s, rularea R0, `docs/OLCUMLER.md`; alte plăci nemăsurate]**)**: când instalatorul afișează `HAZIR / READY`, rulați
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (scurtătură: trageți un fișier text cu prompt peste `uret.cmd` sau rulați `uret.cmd docs\ornek_istem_R0.txt`: aceeași rulare de 56 de cadre). Videoclipul este în `runs\`. Apoi scrieți propriul prompt într-un fișier text (un paragraf în engleză, propoziție `audio:` opțională) și rulați cel mai lung clip pe care îl acoperim (implicit, cam 57 min [măsurat: rularea U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   `-Kare` urmează grila 17k+5 (56, 73, ... 192, 209); implicit 209 (8,7 s), cea mai lungă durată pe care o acoperim. VAE rulează într-un proces separat, niciodată pe dale (tiled) [o rulare reală a motorului prin `uret.ps1` cu binarul de release, cu VAE în proces separat, a trecut în rularea U209].

   Ghid de scriere a promptului: [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (tipar de cadru continuu unic, segmente de timp egale, două exemple complete).

| Cerință | Valoare |
|---|---|
| SO | Windows 10/11, 64 de biți |
| GPU | NVIDIA, 4 GB sau mai mult; testat numai pe GTX 1050 Ti (sm_61); marjă mică (3777/4096 MiB la 209 cadre): un ecran încărcat sau un browser pot întrerupe rularea; nicio altă placă de 4 GB nu a fost încercată |
| RAM | 16 GB (vârf de aproximativ 11 GB; închideți celelalte programe) |
| Disc | cel puțin 32 GiB liberi (se recomandă 40 GiB sau mai mult: între 32 și 40 instalatorul afișează un avertisment, `[VT-W-DISK-PAY]` [măsurat: rulări `-Kuru` cu disc simulat]), modele pe un SSD (de preferat NVMe) |
| Descărcare | zip motor 36,8 MB + zip runtime CUDA 567,5 MB [măsurat] + modele 31.473.112.040 octeți (aproximativ 29,3 GiB) [citit: dimensiunile din `scripts/modeller.json`]; în total aproximativ 30 GiB |
| Modele | neincluse; descărcate de programul de instalare sub licența MiniMax (vedeți avertismentul de mai jos). Modelele (29,3 GiB, 31.473.112.040 octeți în `scripts/modeller.json`) nu se află în acest depozit și nici în release: se aplică limitele GitHub pentru dimensiunea fișierelor/release-urilor, iar `kur.ps1` le descarcă din sursa oficială cu verificare sha256. |

Codurile de ieșire ale `kur.ps1`: 0 READY, 1 eroare, 2 este nevoie de intervenția utilizatorului (licență sau încă niciun release/zip), 3 hardware sau disc insuficient, 4 oprit (fișier DUR). `uret.ps1` acceptă o rulare numai dacă fișierul `.avi` există, numărul de cadre este corect și jurnalele sunt curate [măsurat: o rulare reală prin `uret.ps1` pe binarul de release, rularea U209, 209 cadre, poarta de calitate trecută]. Codurile de ieșire ale `uret.ps1`: 0 DONE (poarta de calitate trecută), 1 eroare sau ieșire invalidă (inclusiv un videoclip fără flux audio), 2 oprit (fișier DUR), 5 `KAPI RED` (poarta de calitate a eșuat: clipul nu este acceptat, decizia vă aparține), 6 poarta nu a putut rula (clipul nu este acceptat). Detalii în AGENTS.md. [măsurat: codurile de ieșire 0, 1 (videoclip fără sunet), 5 și 6 în scenarii cu un motor fals și o poartă falsă; motor real: ieșire 0 în rularea U209]

### Depanare (detalii: `docs/SIK_HATALAR.md`)
Liniile de eroare ale scripturilor noastre poartă un cod stabil, de exemplu `HATA: [VT-E-DLL] ...` sau `UYARI: [VT-W-DISK-PAY] ...`. Căutați codul în [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) (exemplu de ancoră `#vt-e-dll`) sau în `docs/hata_imzalari.json` și scrieți codul în issue-ul dumneavoastră. Prima coloană a tabelului de mai jos rămâne așa cum este afișată (nu traduceți codurile și textul jurnalelor).

| Ce vedeți | Ce înseamnă, ce de făcut |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | Nu porniți `sd-cli.exe` manual; rulați `scripts\kur.ps1`, care pune DLL-urile CUDA la locul lor. |
| `failed during weight preparation` la `blocks.0` (#1, #3, #5) | VRAM insuficient la poarta de memorie: folosiți un număr mai mic de cadre de pe grila 17k+5, închideți alte programe care folosesc GPU-ul, păstrați opțiunile livrate. |
| `retrying with temporal tiling` (#6) | VAE a revenit la rularea pe dale; rezultatul nu este valid pentru evaluarea calității. Rulați din nou. |
| Rularea se încheie la limita de timp, fără videoclip (#7) | Măriți `-TavanDk` pentru clipuri lungi (limita de timp implicită: 80 min pentru 209 cadre, stabilită de `uret.ps1`; rularea noastră de 209 cadre a durat 57 min [măsurat: rularea U209]). |
| Cod de ieșire gol, dar „finished” (#14) | Scriptul a citit codul de ieșire prea devreme; rulați din nou și verificați că fișierul video există. |
| Sistemul încetinește, swapping (#18) | Motorul folosește aproximativ 10-11 GB de RAM; închideți browserele și celelalte programe. |
| sha256 diferit / descărcare eșuată | De obicei o descărcare întreruptă: rulați aceeași comandă din nou, fișierele verificate sunt sărite. |

**Blocat sau curios?** [`SUPPORT.md`](SUPPORT.md) (unde puteți întreba; timpii de răspuns sunt ținte, nu angajamente) · [`PRIVACY.md`](PRIVACY.md) (fără telemetrie; rețeaua este folosită doar pentru descărcarea motorului și a modelelor, de la gazdele listate) · [`SECURITY.md`](SECURITY.md) (raportare privată) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (primul pull request în 5 pași; pentru documente și scripturi nu este nevoie de GPU).

### Nou în v0.1.1: mai multe opțiuni (detalii: `AGENTS.md`, `docs/SIK_HATALAR.md` 19-23)
Fără aceste opțiuni nu se schimbă nimic pe o placă de 4 GB (verificarea la nivel de octet pe 56 de cadre față de referința noastră a trecut din nou cu v0.1.1 [măsurat]). Adăugați `-Kuru` la orice comandă pentru a vedea ce s-ar rula.
- `-EndImg`: dați și ultimul cadru (primul și ultimul cadru, „FLF”); plafon de 175 de cadre pe plăcile sub 8 GB (192 nu au încăput pe 4 GB), 192 pe plăcile de 8 GB sau mai mult. Pe GTX 1050 Ti-ul nostru rulează întotdeauna în două procese: 56 de cadre în 1040 s, 175 de cadre în 2887 s (48 min), ambele rulări au trecut de poarta de calitate [măsurat]. Sfaturi pentru prompt: `docs/ISTEM_YAZIMI.md`.
- `-W` / `-H`: alte dimensiuni, de exemplu vertical 384x640; multipli de 32, suprafață de cel puțin 640x384 (niciodată mai mică). Netestat pe 4 GB; pe plăcile sub 8 GB, dimensiunile care depășesc cea mai mare sarcină măsurată de noi sunt refuzate. Pragurile porții de calitate sunt calibrate la 640x384.
- `-TekAsama`: un singur proces în loc de două, doar pentru plăci mari; nu se activează niciodată automat.
- GPU-uri mai noi (compute capability 7.0+, de exemplu RTX 20/30/40): `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` este setat automat dacă nu l-ați setat dumneavoastră; aceasta a rezolvat videoclipul complet negru de la 141 de cadre în sus pe placa RTX 4070 Ti a celui care a raportat [raportat de utilizator, issue #1]. Fără Python + OpenCV, `uret.ps1` se oprește acum cu codul de ieșire 6 înainte de lucrul pe GPU (nu se produce niciun video, niciun RED înșelător).
- Mulțumim lui @SinanC73 pentru raportul de pe RTX 4070 Ti care a dus la aceste schimbări ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1)).

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

## Profiluri de viteză opționale (pachet de viteză; dezactivate implicit)
Nimic din cele de mai jos nu schimbă rularea implicită (640x384, 209 cadre, 3414 s pe placa noastră). Sunt trei celule măsurate dincolo de ea, fiecare un profil denumit al `uret.ps1`; au nevoie de motorul pachetului de viteză (motorul din release plus patch-urile 0021, 0023, 0024, toate dezactivate implicit: `docs/YAMALAR.md`). Instalați-l cu `scripts\kur.ps1 -HizPaketi` (un zip local funcționează cu `-MotorZip`), apoi adăugați `-Profil <name>`; `-Kuru` afișează ce s-ar executa.

| Profil | Dimensiune, lungime | Timp total pe un GTX 1050 Ti 4 GB | Stare |
|---|---|---|---|
| (niciunul, implicit) | 640x384, până la 209 cadre (8,7 s) | 209 cadre: 3414 s | verificat, neschimbat |
| `yuksek832` | 832x480, 141 cadre (5,9 s) | aproximativ 55-56 min | utilizabil, două prompturi [măsurat] |
| `yuksek832 -Kare 124` | 832x480, 124 cadre (5,2 s) | aproximativ 45-46 min, fără indicator de viteză | utilizabil, două prompturi [măsurat] |
| `yuksek896` | 896x512, 124 cadre (5,2 s) | aproximativ 56-57,5 min | utilizabil, două prompturi [măsurat] |
| `uzun260` | 640x384, 260 cadre (10,8 s) | 78 min măsurate fără ieșirea timpurie; cu ea aproximativ 71-72 min [presupunere: nemăsurat cap la cap prin `uret.ps1`] | condiționat și experimental |

- **Marjă îngustă:** la 832x480 x 141 poarta de memorie lasă o marjă de o singură cifră în MB (5,7 și 6,8 MB în cele două rulări complete). Două prompturi lungi (1520 și 2041 de caractere) au fost verificate doar citind poarta pentru pasul 1 și o parte din pasul 2, fără rulare completă: marjă 10,9 și 4,0 MB. Orice alt proces care ocupă memoria plăcii (browser, al doilea monitor) poate face rularea să eșueze; atunci folosiți `-Kare 124` sau dimensiunea implicită [măsurat, GTX 1050 Ti 4 GB].
- **`uzun260` este condiționat:** limita de memorie este foarte îngustă (vârf VRAM 3903 din 4096 MiB), utilizarea memoriei partajate a crescut cu 61 și 68 MiB, iar pentru egalitatea la nivel de octet nu există o referință fără indicatori, deci nu este oferit ca funcție obișnuită. Patch-ul 0023 este acceptat doar pentru această celulă.
- **Neoferit:** 832x480 la 158 sau 175 de cadre nu încape; căutarea lungimii s-a oprit acolo la 141 de cadre. Alte dimensiuni și numere de cadre sunt refuzate de `-Profil` (folosiți calea implicită).
- Calitatea implicită rămâne neatinsă: 6 pași, cfg 1, VAE fără dale, 17k+5 cadre. Acolo unde indicatorii sunt activi, ieșirea a fost comparată octet cu octet cu videoclipul fără indicatori la dimensiunile la care rularea fără indicatori încape (`docs/YAMALAR.md`); la 832x480 x 141 și 896x512 x 124 rularea fără indicatori nu încape, așa că egalitatea se sprijină acolo pe cele mai apropiate celule, nu pe o comparație directă [măsurat, citit].
- Etapa 1 a unei rulări în două etape se încheie acum imediat ce fișierul latent este complet (`VT_ERKEN_CIKIS=0` o dezactivează).

## Disk layout and removal

> Translation of this section is pending; the English text is authoritative. / Bu bölümün çevirisi bekliyor; İngilizce metin esastır.

Everything VideoTurko installs lives in one root folder, `<VT_ROOT>` (default: the folder you extracted; set the environment variable `VT_ROOT` before running the scripts to use another place). Nothing is written to the system PATH, the user profile or the registry.

| Folder under `<VT_ROOT>` | What is in it | Size |
|---|---|---|
| `engine\bin`, `engine\lisanslar` | the release engine (exe and DLLs; GTX 10xx and RTX 40xx) and the license files of its zips | not measured |
| `engine\stock_cuda12\bin` or `engine\stock_vulkan\bin` | only one of them, when your card gets the stock stable-diffusion.cpp engine (the installer picks it); its license files sit next to it in `lisanslar\` | about 1.2 GiB unpacked (CUDA) or about 0.08 GiB (Vulkan) [measured: zip central directory, maintainers] |
| `engine\secili_motor.json` | which engine `kur.ps1` selected; `uret.ps1` reads it (`VT_ENGINE_BIN` wins when set) | tiny |
| `model` | the model files, downloaded from the official source and sha256-checked | 29.3 GiB [read: `AGENTS.md`] |
| `indirme` | downloaded zips and their unpacking leftovers | not measured |
| `runs` | your finished videos | grows with use |
| `.venv` (optional) | the Python environment for the quality gate (opencv-python, numpy) | not measured |

The install scripts run no `pip`, `uv` or Hugging Face tool, so they write no package or model cache. Only if you install the optional gate packages yourself, keep the cache in the root too: `py -3 -m venv <VT_ROOT>\.venv`, then `<VT_ROOT>\.venv\Scripts\python.exe -m pip install --cache-dir <VT_ROOT>\.onbellek\pip opencv-python numpy`; the scripts use `<VT_ROOT>\.venv` when it exists (unless `VT_PYTHON` is set).

On Linux (`./kur.sh`, experimental) the same root holds:

| Linux path under `<VT_ROOT>` | What is in it |
|---|---|
| `.venv`, `.onbellek/pip` | the Python environment (opencv-python-headless, numpy) and its pip cache; always created by `kur.sh` |
| `engine/src`, `engine/build` | the stable-diffusion.cpp source at the pinned commit and the build folder |
| `engine/toolchain` | only if the build needs a local toolchain |
| `engine/bin`, `engine/.yamalar_tamam` | the built `sd-cli` with its `SHA256SUMS`, and the marker that the patches were applied |
| `model/`, `runs/` | as on Windows |

**Already downloaded the model?** Point the installer at it with `-ModelKlasoru <folder>`: files whose sha256 matches are linked instead of downloaded. On the same drive this is a hard link (the data exists once, so deleting the source folder later does not free the space); on another drive it is a COPY (about 29 GiB twice). A complete file with the right sha256 is skipped, and an interrupted download continues from its `.part` file.

**Removal:** close VideoTurko, copy out the videos you want to keep from `runs`, then delete the `<VT_ROOT>` folder. That is the whole uninstall. Not ours to remove: a `pip install` you made into the system Python (use a `.venv` as above to avoid that) and anything installed with `winget`.

## Which engine does my card get? (automatic)

> Translation of this section is pending; the English text is authoritative. / Bu bölümün çevirisi bekliyor; İngilizce metin esastır.

`kur.cmd` reads your card (the compute capability from `nvidia-smi`; for AMD the Windows display adapter name) and picks the engine itself. Before anything is downloaded, `scripts\kur.ps1 -Kuru` shows the choice in one line: `Motor secimi: <id> (kart sinifi <class>; durum <status>)`. Nothing else to decide: double-click `kur.cmd`. To choose by hand: `-MotorTuru release_sm61`, `-MotorTuru stock_cuda12` or `-MotorTuru stock_vulkan` (a local zip given with `-MotorZip` / `-CudaZip` counts as the release engine). The table behind this is `scripts/kart_tablosu.json`.

Status words: **verified** = the maintainers measured it; **community** = a user reported it, we did not measure it; **untried** = nobody has reported a run.

| Card class | Engine chosen | Status | Evidence |
|---|---|---|---|
| GTX 10xx (Pascal, compute capability 6.1-6.9) | release engine (`sm_61`, our patches) | verified, GTX 1050 Ti only | [measured] `docs/OLCUMLER.md`; other Pascal cards [guess: same architecture] |
| RTX 20xx, GTX 16xx (Turing/Volta, 7.x) | stock CUDA engine | untried | [read] the stock build lists `sm_70` and `sm_75`; no run reported |
| RTX 30xx (Ampere, 8.0-8.8) | stock CUDA engine | community | [user-reported, PR #6] RTX 3070 8 GB, run outside `uret.ps1`, quality gate not run; no measurement on 6 GB laptop cards [guess: same architecture] |
| RTX 40xx (Ada, 8.9) | stock CUDA engine, `f32` | community | [user-reported, issue #25] RTX 4070 Laptop 8 GB: stock engine 209 frames 275 s vs release engine 620 s, gates passed on both (stock run outside `uret.ps1`); [user-reported, issue #24] RTX 3060 12 GB (Ampere): stock 2.6x faster than release at 209 frames; earlier reports ran the release engine: [user-reported, issue #1] RTX 4070 Ti, [user-reported, PR #5] RTX 4060 with a local `sm_89` build. Override: `-MotorTuru` / `VT_ENGINE_TYPE` |
| Hopper and newer data-centre cards (9.0-11.x) | stock CUDA engine | untried | [read] the stock build lists `sm_90` and `sm_100`; no run reported |
| RTX 50xx (Blackwell, 12.0 and up) | stock CUDA engine | untried | [read] the stock build lists `sm_120`; no stock run on an RTX 50 card; [user-reported, PR #3] the release `sm_61` engine gave a black video at 56+ frames and a local `sm_120` build worked |
| AMD Radeon | stock Vulkan engine, `minimax_h3_attn_chunk_budget=0.03` | community | [user-reported] RX 9070 XT 16 GB, 209 frames; ROCm is not automatic (it needs `hipblas.dll`) |
| Intel, anything else | none automatic | n/a | `kur.ps1` stops with an error; choose by hand with `-MotorTuru` |

The `f32` setting (`GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32`) is applied automatically on NVIDIA cards with compute capability 7.0 or higher. The stock engine runs in a single process (the two-stage keys of our patches do not exist in it); the quality settings are the same on every card (6 steps, cfg 1, 640x384, non-tiled VAE) and the quality gate runs the same way. If the VRAM is not enough the engine stops early with `[VT-E-VRAM]`, which suggests a shorter `-Kare`. On a card class that is not verified you get the warning `[VT-W-GPU-DENENMEDI]` with its status and evidence. A stock engine adds about 1.2 GiB unpacked (CUDA; zips 412 MB and 563 MB) or about 0.08 GiB (Vulkan; zip 30 MB) under `engine\` [measured: zip central directory, maintainers]. Details per card: `docs/KART_PROFILLERI.md`. A longer film from several clips: `docs/KLIP_ZINCIRI.md`, `scripts/zincir.py` [user-reported]; chained-film quality not measured by us [not tried].

> **Add your card (pull request).** One short PR is enough: (1) the line printed by `nvidia-smi --query-gpu=name,memory.total,driver_version,compute_cap --format=csv,noheader,nounits`; (2) the output of `scripts\kur.ps1 -Kuru`; (3) a summary of your `uret.ps1` run (frames, time, peak VRAM if you have it), every number labelled [measured], [read] or [guess]; (4) a new row in `docs/KART_PROFILLERI.md` and, if the engine choice should change, a suggestion for `scripts/kart_tablosu.json`. A PR that changes the quality settings (6 steps, cfg 1, 640x384, non-tiled VAE) cannot be accepted. See `CONTRIBUTING.md`.

License: accepting the MiniMax H3 license (`docs/LISANS_KABUL.txt`) applies on every path.

## Linux (experimental)

> Translation of this section is pending; the English text is authoritative. / Bu bölümün çevirisi bekliyor; İngilizce metin esastır.

**Status: experimental.** The maintainers have not run a GPU job on Linux. The only evidence is [user-reported, PR #8] 56 frames on an RTX 4060 Ti 8 GB (contributor @xmtaha); 141 and 209 frames were not measured on Linux [not tried]. The Windows engine choice (the stock engine, `scripts/kart_tablosu.json`) does not apply on Linux: you build the engine yourself from pinned sources with our patches.

Needs: an NVIDIA driver (`nvidia-smi` works; 4 GB of VRAM or more), the CUDA Toolkit (`nvcc`), `git`, `cmake` and `python3`; about 29.3 GiB for the models (at least 32 GiB free on the model drive) plus room for the source and the build under the root [guess: about 10 GiB more on the root drive; not measured].

```bash
./kur.sh --kuru
./kur.sh
./uret.sh --istem docs/ornek_istem_R0.txt --kare 56
```

`./kur.sh --kuru` changes nothing (it writes, downloads and builds nothing) and reports readiness through its exit code. `./kur.sh` checks the GPU (compute capability 6.1 or higher), the disk and the model license (it asks you; `--lisans-kabul E` means you have read and accepted it yourself), creates a Python environment under the root (`.venv`, pip cache `.onbellek/pip`), clones and builds stable-diffusion.cpp at a pinned commit with the patches checked against `patches/SHA256SUMS` (the build takes a long time [not measured]), downloads the models with sha256 checks, runs a real 5-frame check, and prints READY only if that check passed (`--kontrol-atla` skips the check and never prints READY). `./uret.sh` follows the same rules as `uret.ps1`: frame counts 17k+5 up to 209 (192 with `--init-img`), 640x384 by default, the same two-stage threshold, `f32` on cards with compute capability 7.0 or higher, the same quality gate, and the quality settings are fixed on every system (6 steps, cfg 1, non-tiled VAE). Exit codes of `kur.sh`: 0 ready, 1 error, 2 license needed, 3 hardware or disk not enough; of `uret.sh`: 0 done, 1 error, 2 usage error or stop file, 5 quality gate RED, 6 gate could not run.

## Ce este
Un set de patch-uri mici de memorie și planificare pentru stable-diffusion.cpp, plus rețeta de rulare, verificările și măsurătorile care permit rularea MiniMax H3 (DiT de 33B; noi rulăm HyperFlow Flash 13.7B Q4_K_M GGUF; encoderul de text Qwen3-VL de 32B este separat) pe un GPU Pascal de 4 GB (GTX 1050 Ti, 16 GB de RAM de sistem).
- Durate dintr-o singură trecere pe care le-am produs efectiv și care au trecut porțile noastre de calitate: 56, 141, 158, 175, 192, 209 cadre la 640x384, 24 fps (209 cadre = 8,7 s), cu sunetul generat chiar de H3 [măsurat: 209 cadre cu binarul de release prin `uret.ps1`, rularea U209; latentul identic la nivel de octet cu rularea build-ului de dezvoltare; cadrele și sunetul sunt identice în videoclip, sha-ul fișierului diferă din cauza containerului; dovezile sunt păstrate de autori, nu se află în acest depozit]. 209 este cea mai lungă durată pe care am vizionat-o și am găsit-o fluidă [raportat de utilizator, 2026-11-19, videoclip vizionat integral; fișier: ieșirea F209V2, 8,708 s].
- **Afirmația de identitate la nivel de octet, delimitată cinstit:** ieșirile au fost verificate ca identice la nivel de octet cu referința fără patch-uri numai pentru 56 și 141 de cadre. Pentru 158/175/192/209 de cadre am folosit aceleași opțiuni și același lanț de binare; nu există o referință directă la nivel de octet (build-ul fără patch-uri nu poate rula aceste durate pe acest GPU).
- Setările de calitate nu sunt coborâte niciodată: același model/aceeași cuantizare, 6 pași, cfg 1, 640x384, același seed, VAE fără dale.
- Nu pretindem că suntem primii: am căutat și nu am găsit niciun exemplu extern al acestui lucru pe 4 GB, ceea ce nu dovedește că nu există.

## Structura
- `patches/` patch-uri pentru un commit fixat al stable-diffusion.cpp (vedeți notele de acolo)
- `scripts/` compilare, rulare, VAE în proces separat, utilitare pentru porți/consistență (`doku_norm.py`: vedeți nota despre scară de mai jos)
- `docs/KURULUM.md` hardware, pașii de compilare și rulare (EN+TR)
- `docs/YAMALAR.md` lista patch-urilor, `docs/KANITLAR.md` dovezi, `docs/KAPILAR.md` tabelul porților de calitate, `docs/OLCUMLER.md` măsurători, `docs/SIK_HATALAR.md` greșeli frecvente, `docs/LISANS_UYARISI.md` lista completă a punctelor din licență
- `scripts/` index scurt: `hiz_kos3.ps1` script de rulare (`-Kuru` afișează comanda exactă), `uretim_kapi.ps1` poarta de calitate, `dikis_denetim.py` verificarea cusăturilor, `doku_norm.py` zgomot normalizat după textură, `bayt_kiyas.py` comparare la nivel de octet, `derleme_sablonu.ps1` șablon de compilare (oprește numai procesul auxiliar de telemetrie Visual Studio `vctip.exe` pornit după începerea propriei compilări, care altfel ține procesul de compilare atașat minute în șir; celelalte procese `vctip.exe` sunt lăsate în pace)

## Porți de calitate (cum se acceptă un rezultat)

Această poartă nu verifică consistența mișcării (salturi de scară sau de poziție ale obiectelor): vizionați întregul videoclip înainte de a-l accepta.
1. Numărul de cadre și sunetul prezente; fără revenire la alocare de rezervă și fără linii ALLOC_FAILED în jurnal.
2. Poarta zgomotului brut: reziduul filtrului median <= 1,5 (scara 0-255).
3. Zgomot normalizat după textură, `scripts/doku_norm.py` (versiunea acestui depozit): N = reziduu median / textură Sobel, la fiecare al 6-lea cadru. **Notă despre scară:** în această versiune cele 10 clipuri măsurate dau N = 0,034-0,052 (tabel în `docs/KAPILAR.md`; ultimul sfert din F192/F209V2 ajunge la 0,062), iar pragul porții suplimentare este N <= 0,065. O altă implementare a măsurat 0,028-0,036 pe aceleași clipuri, deci pragurile NU sunt interschimbabile între versiuni. Pe texturi foarte fine (rânduri de iarbă) N curat a fost 0,075, deci pragul se stabilește pe familie de scene. Un estimator robust de înaltă frecvență (sigma-HH <= 1,5; curat 0,74-1,19, zgomotul adăugat s=2 dă 2,2-3,0) este poarta suplimentară recomandată.

Domeniu: VideoTurko se ocupă de O SINGURĂ trecere (până la 209 cadre, aproximativ 8,7 s). Propriul nostru test de înlănțuire a arătat îmbinări vizibile (scena nu continuă curat), deci filmele mai lungi nu fac parte din ceea ce verificăm. Pentru înlănțuire există ghidul comunității `docs/KLIP_ZINCIRI.md` și utilitarul nostru doar pe CPU `scripts/zincir.py` (`plan`, `son-kare`, `bagla`; nu pornește niciodată motorul); calitatea filmelor înlănțuite nu am măsurat-o [neîncercat], deci verificați fiecare îmbinare cu ochiul și cu `scripts/dikis_denetim.py`.
Setările sunt ale dumneavoastră: 209 cadre este valoarea implicită testată de noi pe o placă de 4 GB, nu o limită pe care trebuie să o folosiți. Alegeți orice număr de cadre de pe grila 17k+5 (56, 73, ... 192, 209; vedeți `docs/KURULUM.md`), schimbați prompt-ul, seed-ul, rezoluția sau orice opțiune după preferință. Clipurile mai scurte cer mai puțină memorie și timp; GPU-urile mai mari pot suporta mai mult.

## Avertisment privind licența modelului
**VideoTurko conține numai patch-uri și scripturi (MIT); cine folosește modelul și ieșirile lui răspunde personal pentru licența MiniMax.** Nu reprezintă consultanță juridică. Mai jos sunt clauzele MiniMax H3 Community License (2 august 2026) rezumate cu numerele lor; licența însăși este cea obligatorie: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

Licența MIT a acestui depozit nu acoperă ponderile modelului; vedeți [`NOTICE`](NOTICE). Acest depozit NU conține ponderi de model (niciun fișier MiniMax H3, HyperFlow-H3-Flash GGUF sau VAE). Acest proiect nu este afiliat cu MiniMax și nu este susținut de MiniMax. Uzul comercial NU este interzis (nu este o licență necomercială); condițiile sunt mai jos.

**Teritoriu (Applicable Territory)**
- **Preambul, I.3, I.5:** În întreaga lume, CU EXCEPȚIA Uniunii Europene, Regatului Unit, Republicii Coreea și Statelor Unite. Folosirea modelului înseamnă acceptarea licenței.
- **II:** Licență fără redevențe, netransferabilă, limitată, de a folosi, reproduce, distribui, crea derivate și modifica, numai în interiorul teritoriului și în conformitate cu acordul și cu Exhibit A. Persoanele din teritoriile excluse pot cere MiniMax o licență separată.
- **V.4:** Folosirea, reproducerea, modificarea, distribuirea sau afișarea modelului, a derivatelor lui ȘI A IEȘIRILOR (video/audio generat) în afara teritoriului nu este autorizată. **Așadar publicarea sau afișarea videoclipurilor generate în UE/Regatul Unit/Coreea de Sud/SUA este în afara licenței.**
- **Exhibit A-1:** Folosirea în afara teritoriului încalcă Acceptable Use Policy.

**Distribuire (III)** (acest depozit nu distribuie modelul; dacă îl distribuiți dumneavoastră)
- **III.1:** Dați fiecărui destinatar o copie a licenței. **III.2:** Marcați fișierele modificate cu notificări vizibile.
- **III.3:** Încurajat (nu obligatoriu): mențiunea „Powered by MiniMax H3”, un identificator de generare AI pe fișierele produse, o prezentare publică.
- **III.4:** Distribuirile TREBUIE însoțite de un fișier NOTICE cu: „MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved.”
- **Exhibit A-12:** publicarea de conținut în orice mediu public fără a dezvălui clar că este generat de mașină este interzisă: etichetați videoclipurile generate de AI când le publicați (lista completă: `docs/LISANS_UYARISI.md`).
- **III (ultimul paragraf):** Puteți adăuga propriul copyright pentru modificările dumneavoastră, dar nu puteți impune termeni suplimentari sau diferiți privind folosirea/distribuirea; regulile teritoriale se aplică în continuare.

**Condiții comerciale (IV)**
- **IV.1:** Dacă produsele/serviciile dumneavoastră comerciale generează un venit anual de peste 20 de milioane USD (sau echivalent), obțineți o autorizare scrisă PREALABILĂ de la api@minimax.io (subiect „MiniMax H3 licensing - authorization request”).
- **IV.2:** Interfața unui produs/serviciu comercial care folosește modelul trebuie să afișeze vizibil „MiniMax H3”.

**Restricții de utilizare (V)**
- **V.1:** Respectați legea aplicabilă (inclusiv conformitatea comercială) și Exhibit A. **V.2:** Obligați pe oricine căruia îi dați acces prin termeni cel puțin la fel de protectori ca aceste restricții și notificați-i.
- **V.3:** Nu puteți folosi modelul sau IEȘIRILE lui pentru a îmbunătăți un alt model AI (în afară de MiniMax H3 și derivatele sale). (I.11: distilarea și antrenarea pe ieșiri sintetice fac dintr-un model un „derivat”; ieșirile în sine nu sunt derivate.)
- **V.5:** Dacă oferiți unor terți un produs/serviciu/serviciu găzduit care generează ieșiri cu modelul: înainte și pe tot parcursul funcționării, măsuri tehnice și organizatorice rezonabile, un mecanism de raportare, investigare promptă și eliminarea/dezactivarea/suspendarea celor care încalcă repetat.

**Mărci comerciale și drepturi (VI)**
- **VI.1:** Dețineți lucrările derivate și derivatele de model pe care le creați (sub rezerva drepturilor MiniMax). **VI.2:** Numele/mărcile MiniMax nu sunt licențiate (dincolo de ce este necesar pentru a descrie și distribui); marca „MiniMax H3” poate fi folosită numai pentru respectarea III.3, în interiorul teritoriului; nu sugerați o afiliere.
- **VI.3:** Dacă dați în judecată MiniMax sau pe oricine, susținând că materialele/ieșirile vă încalcă drepturile, toate licențele dumneavoastră încetează în acea zi; apărați și despăgubiți MiniMax împotriva pretențiilor terților rezultate din folosirea/distribuirea de către dumneavoastră sau de către alții.
- **VI.4:** MiniMax nu revendică niciun drept asupra ieșirilor; dumneavoastră și utilizatorii dumneavoastră răspundeți pentru ieșiri și pentru folosirea lor.

**Declinări de răspundere și încetare (VII, VIII, IX)**
- **VII.1:** Nicio obligație de suport/actualizare. **VII.2:** Modelul și ieșirile sunt oferite „AS IS”, fără garanții; dumneavoastră decideți dacă sunt potrivite și vă asumați riscul. **VII.3:** MiniMax și afiliații nu răspund pentru niciun prejudiciu (în măsura permisă de lege).
- **VIII.1:** Intră în vigoare la acceptare/acces. **VIII.2:** La încălcare MiniMax poate înceta licența; trebuie să încetați folosirea/distribuirea, să ștergeți copiile și să notificați destinatarii (VI.1, VI.3, VII, IX rămân în vigoare).
- **IX:** Legea RAS Hong Kong; jurisdicția exclusivă a instanțelor din Hong Kong (UN CISG exclusă).
- **Notă suplimentară:** encoderul MiniMax H3 folosește Qwen3-VL-32B (Apache 2.0).

**Acceptable Use Policy (Exhibit A)** (NU folosiți modelul, derivatele sau ieșirile pentru)
- A-1 folosire în afara teritoriului; A-2 încălcarea legilor sau a proprietății intelectuale a terților; A-3 vătămarea dumneavoastră sau a altora; A-4 refolosirea/distribuirea ieșirilor pentru a face rău; A-5 ocolirea măsurilor de protecție; A-6 exploatarea/vătămarea minorilor; A-7 informații verificabil false pentru a face rău altora sau pentru a influența alegeri; A-8 implicare online falsă (recenzii false etc.); A-9 defăimare, denigrare, hărțuire; A-10 malware; A-11 date personale folosite pentru a face rău altora; **A-12 publicarea de conținut în orice mediu public (inclusiv postări ale boților) fără a dezvălui clar și vizibil că este generat de mașină**; A-13 uzurpare de identitate fără consimțământ; A-14 decizii automatizate cu risc ridicat în domenii critice (aplicarea legii, imigrație, sănătate, infrastructură critică, credit, angajare, locuințe, educație, scoring social, asigurări etc.); A-15 încălcarea standardelor sociale, etice, morale ale altor țări/regiuni; A-16 extremism violent/terorism; A-17 discriminare/vătămare pe baza unor caracteristici protejate; A-18 exploatarea populațiilor vulnerabile; **A-19 scopuri militare**; A-20 activitate profesională neautorizată/nelicențiată (financiară, juridică, medicală etc.).
- Notă: acesta este un rezumat în limbaj simplu; în caz de îndoială, prevalează textul englez al licenței.

## Etichete de dovadă

Un singur set pentru toate documentele (grafiile mai vechi între paranteze):
- **[măsurat]** (TR: ölçtüm, olctum): rulat în acest proiect, există calea dovezii.
- **[citit]** (TR: okudum yol, okudum): sursa sau scriptul au fost citite, nu rulate.
- **[proiectat]** (TR: tasarım, tasarim): proiectat, încă nevăzut într-o rulare reală.
- **[presupunere]** (TR: tahmin): neverificat.
- **[neîncercat]** (TR: denenmedi): niciodată rulat.
- **[raportat de utilizator]** (TR: kullanıcı bildirdi): declarat de utilizator, cu dată; nemăsurat independent.
- **[calculat]** (TR: hesap; grafii mai vechi: calculated, hesap): un număr dedus din intrări măsurate, nemăsurat el însuși; deducția este scrisă alături. [propunere] / [öneri] în textul mai vechi = [presupunere].

Numele de rulări folosite între paranteze (numele noastre proprii de rulări, nu fișiere din acest depozit): U209 = 209 cadre cu binarul de release prin `uret.ps1`; B209 și B192 = rulări imagine-în-video (`-InitImg`) la 209 și 192 de cadre; B56VT2 = binar de release, 56 de cadre, comparat cu referința la nivel de octet R0 de 56 de cadre; F209b, F209V2, F209V2K = rulări de 209 cadre pe build-ul de dezvoltare (detalii: `docs/OLCUMLER.md`).

## Limite cunoscute
- **Dovada la nivel de octet** (cum o reproduceți singur: `docs/KANITLAR.md`, „R0 ve latent referansi nasil uretilir”; verificată pe placa noastră sm_61, alte GPU-uri pot să nu fie identice la nivel de octet [presupunere]): cu seria noastră de patch-uri (opțiunile de memorie active) o rulare de 56 de cadre a dat sha256 `0979f156d548169b...`, identic cu referința [măsurat]; la 141 de cadre sha256-ul latentului `E5D028F8632BE4FE...` a fost identic (cu opțiunile 0013/0014). Pentru cadrele 158-209 nu există referință directă la nivel de octet; lanțul de porți este dovada. Trecerea porților numerice nu garantează un clip bun: consistența mișcării în timp se verifică vizual (vedeți `docs/KAPILAR.md`).
- **209 cadre, ce set de opțiuni:** dovada prin lanțul de octeți pentru 209 cadre a fost obținută cu setul de opțiuni F209V2 pe build-ul de dezvoltare (fără opțiuni de bloc-final, compilat fără patch-urile 0019/0020); `uret.ps1` folosește această rețetă pentru 209 cadre [citit: scriptul; o rulare reală a motorului prin `uret.ps1` a trecut în rularea U209].
- Verificat de noi pe o singură placă (GTX 1050 Ti 4 GB); rapoartele externe despre alte plăci sunt listate cu etichetele lor în `docs/KART_PROFILLERI.md` [raportat de utilizator].
- **Ce binar a fost măsurat:** latentul de 141 de cadre și lanțul de octeți au fost măsurate cu build-urile noastre de dezvoltare. Binarul de release pe care îl descărcați este un build nou: poarta lui de octeți la 56 de cadre a trecut (punctul următor), iar o rulare de 209 cadre prin `uret.ps1` a trecut poarta (rularea U209, 3414 s, vârf VRAM 3777 MiB) [măsurat]; față de rularea de 209 cadre a build-ului de dezvoltare latentul este identic la nivel de octet; în videoclip cadrele (md5) și sunetul sunt identice, sha256-ul fișierului AVI diferă din cauza containerului [măsurat] (vedeți `docs/OLCUMLER.md`, secțiunea 0).
- **Binar de release, 56 de cadre:** binarul de release (sd-cli `c5cebe78...`, stable-diffusion.dll `e5d3d329...`) a dat un rezultat de 56 de cadre identic la nivel de octet cu R0 (sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`; md5 pe cadre și sunetul identice), rulat direct cu opțiunile implicite (fără variabile `SD_*`), cod de ieșire 0, 601 s [măsurat: rularea B56VT2, 2026-11-19; dovezile sunt păstrate de autori, nu se află în acest depozit]. Domeniu: numai placa noastră sm_61 și 56 de cadre; nu este un test de instalare pe folder gol; latentul de 141 de cadre și lanțul de 209 au fost măsurate cu binarul mai vechi și NU au fost repetate cu acesta [neîncercat]. O primă încercare (B56VT, printr-un script auxiliar) s-a încheiat în tăcere după 58 s, cauză necunoscută [presupunere: presiune pe memorie]; a doua încercare a rulat `sd-cli` direct.
- Scripturile de instalare și rulare nu au fost încă verificate dintr-un folder gol (testul în folder curat este în așteptare).
- Foaia de parcurs și pașii următori: `ROADMAP.md`.

## Stare și limite
- Verificat pe un singur calculator (GTX 1050 Ti 4 GB, 16 GB RAM, i7-7700HQ). Alte plăci de 4 GB și alte capacități de RAM pot diferi.
- **Implicit 209 cadre (8,7 s):** a trecut porțile noastre de calitate (zgomot 1,08, rularea F209V2K) [măsurat: 209 cadre cu binarul de release prin `uret.ps1`, rularea U209; latentul identic la nivel de octet cu rularea build-ului de dezvoltare; cadrele și sunetul sunt identice în videoclip, sha-ul fișierului diferă din cauza containerului; dovezile sunt păstrate de autori, nu se află în acest depozit]. La 209 cadre vârful VRAM al DiT a fost 3777 MiB din 4096 MiB (rulările F209b și U209; citire `nvidia-smi` pentru întreaga placă), o marjă mică: altă încărcare a GPU-ului (ecranul, alte aplicații) poate face rularea să eșueze la `blocks.0`; testat numai pe un GTX 1050 Ti. Starea ecranului în timpul acelei rulări nu a fost înregistrată; dacă ecranul dumneavoastră rulează pe această placă, rămâne mai puțin VRAM disponibil [presupunere: o încărcare de afișare Windows de aproximativ 100-300 MB]; la nevoie, conectați ecranul la un GPU integrat [sfat, netestat]. Sampling-ul a durat 2730 s (rularea U209: pași de 436-483 s), iar decodarea VAE în proces separat 173 s (etapa 2 în total 193 s cu decodarea audio) [măsurat: U209 binar de release; rulări mai vechi de dezvoltare: 2664 s și 174 s]. În etapa 1 VAE-ul din același proces a rămas fără memorie și a revenit la rularea temporală pe dale (320 s); acea ieșire este aruncată, videoclipul provine din etapa 2, fără dale. Vârful de RAM nu a fost măsurat în U209. Clipurile mai lungi de 209 cadre nu fac parte din acest release.
- **Imagine-în-video (`-InitImg`):** cu o imagine inițială limita este de 192 de cadre (8,0 s la 24 fps) pe acest GPU: 209 cadre nu au încăput (lipseau aproximativ 17,5 MB de VRAM la blocul 0: necesari 2587 MB, disponibili 2570 MB); 192 de cadre au rulat prin `uret.ps1` în 3086 s cu un vârf VRAM de 3783 MiB, iar poarta a trecut [măsurat: rulările B209 și B192, 2026-11-20, o singură scenă; dovezile sunt păstrate de autori, nu se află în acest depozit]. Neîncercat pe alte GPU-uri [neîncercat].
- **RAM-ul liber contează:** aveți nevoie de aproximativ 11 GB de RAM LIBER (procesul motorului ține aproximativ 11 GB) [măsurat]. Cu prea puțin RAM liber procesul poate muri fără niciun mesaj de eroare [presupunere: am observat acest lucru o dată, cu aproximativ 300 MB de RAM liber în timp ce `sd-cli` ținea aproximativ 10 GB]. Nu deschideți alte programe mari cât rulează: pe un calculator de 16 GB rămân libere doar aproximativ 0,3-0,5 GB, iar sub presiune pe memorie rularea poate muri în tăcere. Înainte de pornire, închideți browserele, jocurile și alte programe mari și verificați RAM-ul liber.
- **Testul în folder curat este în așteptare:** scripturile de instalare și rulare nu au fost încă verificate dintr-un folder gol, folosind numai aceste instrucțiuni; această secțiune se va actualiza când testul (inclusiv o comparare la nivel de octet pe 56 de cadre cu referința) va fi înregistrat.
- Nu se livrează aici videoclipuri generate.

<!-- i18n-source: README.md sha256:67497404d89b -->
