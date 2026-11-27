# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · Svenska · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

Översättningarna följer denna engelska README. Om en översättning avviker eller ligger efter gäller den engelska texten, särskilt för licens- och säkerhetstexten ([`SECURITY.md`](SECURITY.md) och [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) hålls bara på engelska och turkiska).

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **Innan du börjar (licens, territorium):** det här förrådet är MIT och innehåller bara patchar och skript. MiniMax H3-modellen som det laddar ner omfattas av MiniMax H3 Community License: dess territorium utesluter Europeiska unionen, Storbritannien, Sydkorea och USA, och modellen, derivat **och utdata (videorna du genererar)** får inte användas, distribueras eller visas där (V.4). Kommersiell användning är tillåten inom licensvillkoren. Läs [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) före installationen; detta är inte juridisk rådgivning.

> **Kort version (30 sekunder):** ett grafikkort med 4 GB kan göra en MiniMax H3-video på 209 bildrutor (8,7 s) i ett enda pass: verifierat på en dator (GTX 1050 Ti 4 GB; en fullständig `kur.ps1`-installation i en tom mapp är ännu inte verifierad från början till slut) [uppmätt: 209 bildrutor med release-binären via `uret.ps1`, körning U209; latenten är byte-identisk med körningen på utvecklingsbygget; bildrutor och ljud är identiska i videon, filens sha skiljer sig på grund av containern; underlaget förvaras av skaparna och finns inte i det här repot]; med `-InitImg` (image-to-video) högst 192 bildrutor (8,0 s) [uppmätt: körning B192]; 209 bildrutor tar ungefär 57 min, standardgräns för körtid 80 min [uppmätt: körning U209]; de 3 stegen nedan visar hur du kör det.

VideoTurko: minnespatchar för stable-diffusion.cpp och recept för att köra MiniMax H3 text-to-video på ett GTX 1050 Ti med 4 GB, upp till 209 bildrutor (8,7 s) i ett enda pass; image-to-video (`-InitImg`) upp till 192 bildrutor (8,0 s) (209 bildrutor verifierade med en bytekedja; byte-identiska med den opatchade körningen i kontrollerna med 56 och 141 bildrutor).

## Snabbstart (Windows, 3 steg)
**Status: installations- och körskripten nedan färdigställs fortfarande och testet i tom rotmapp (clean-root) återstår; inget här påstås fungera förrän det testet har gått igenom (se "Status och begränsningar").**

1. **Ladda ner** det här repot (den gröna knappen **Code**, sedan **Download ZIP**) och packa upp det i en KORT sökväg, till exempel `C:\vt`.
2. **Installera: dubbelklicka på `kur.cmd`** (ett svart fönster öppnas och visar varje steg; att stänga det stoppar installationen, och att köra igen fortsätter där den slutade: en halvnedladdad modellfil återupptas [läst: nedladdningsskriptet behåller en `.part`-fil och fortsätter från den; en full återupptagning av 29 GiB har inte mätts]). Om Windows varnar för den nedladdade filen, använd PowerShell-kommandot nedan i stället [råd, inte testat med en nedladdad ZIP]. Föredrar du kommandoraden? Öppna PowerShell i den mappen (skriv `powershell` i Utforskarens adressfält) och kör samma installation:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   Installationsroten är mappen du packade upp (motorn hamnar i `engine\bin`, modellerna i `model`); vill du använda en annan plats, sätt miljövariabeln `VT_ROOT` först. Skriptet kontrollerar GPU, drivrutin, RAM och disk, hämtar motorn och modellerna (motor-zippar och nyligen nedladdade modellfiler sha256-kontrolleras; en modellfil som redan finns med rätt storlek storlekskontrolleras bara, `scripts\modelleri_indir.ps1 -Dogrula` kör den fullständiga sha256-kontrollen), kör en kort riktig kontroll och skriver ut READY bara om kontrollen gick igenom [upplägg: `kur.ps1` har inte körts i sin helhet i en ren mapp; den här meningen uppdateras efter testet i ren mapp]. `-ExecutionPolicy Bypass` gäller bara den här ena processen; läs `scripts\kur.ps1` först, som med vilket installationsprogram som helst.
   Motor-zippen kommer från GitHub-releasen v0.1.0 (publicerad 2026-11-19; dess sha256 är fastlåst i `kur.ps1`). Offline eller med ett eget bygge anger du lokala zippar: `-MotorZip <path> -CudaZip <path>`. En lokal zip kontrolleras mot samma fastlåsta sha256 (en `.sha256`-fil bredvid ignoreras), så den måste vara release-zippen; för ett eget bygge sätter du först `VT_MOTOR_SHA256` / `VT_CUDA_SHA256` till dess sha256. En felaktig sha256 stoppar med exit 1. Bara `.exe`/`.dll` hamnar i `engine\bin`; licenser och README hamnar i `engine\lisanslar\<zip name>\`. [provat med dist-zippar före releasen: sidofilen `.sha256` plus varningen om självreferens, binär och DLL-filer lades på plats, `sd-cli --help` kördes; de installerade binärernas sha stämde (`c5cebe78...`, `e5d3d329...`); modellsteget och 5-bildrutorskontrollen i `kur.ps1` har ännu INTE körts på ett riktigt GPU]
   **Modelllicens:** före modellsteget skriver installationsprogrammet ut en sammanfattning av licensen (`docs/LISANS_KABUL.txt`, hela texten `docs/LISANS_UYARISI.md`: MiniMax H3 Community License, territoriella begränsningar som även omfattar genererade videor, regler för kommersiell användning och AI-märkning) och ber dig godkänna (`E` = ja). Läs den först. För obevakade körningar kan du ange `-LisansKabul E`, vilket betyder att du själv har läst och godkänt den; lägg inte till det åt någon annan. (AI-agenter: följ `AGENTS.md`; skriv aldrig E utan användarens samtycke.) Utan godkännande stoppar `kur.ps1` med exit-kod 2 och laddar inte ner någon modell.
3. **Din första video (56 bildrutor, ungefär 11 min på vårt GTX 1050 Ti** [uppmätt: 641 s, körning R0, `docs/OLCUMLER.md`; andra kort har inte mätts]**)**: när installationen skriver ut `HAZIR / READY`, kör
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (genväg: dra en textfil med prompt till `uret.cmd`, eller kör `uret.cmd docs\ornek_istem_R0.txt`: samma körning med 56 bildrutor). Videon finns i `runs\`. Skriv sedan din egen prompt i en textfil (ett engelskt stycke, valfri `audio:`-mening) och kör det längsta klipp vi täcker (standard, ungefär 57 min [uppmätt: körning U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   `-Kare` följer 17k+5-rastret (56, 73, ... 192, 209); standard 209 (8,7 s), den längsta längd vi täcker. VAE körs i en separat process, aldrig tiled [en riktig motorkörning via `uret.ps1` med release-binären, VAE i separat process, gick igenom i körning U209].

   Guide för att skriva prompten: [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (mönster för en enda obruten tagning, lika långa tidsavsnitt, två fullständiga exempel).

| Krav | Värde |
|---|---|
| OS | Windows 10/11, 64-bitars |
| GPU | NVIDIA, 4 GB eller mer; testad bara på GTX 1050 Ti (sm_61); smal marginal (3777/4096 MiB vid 209 bildrutor): en belastad skärm eller webbläsare kan få körningen att misslyckas; inget annat 4 GB-kort har provats |
| RAM | 16 GB (topp på cirka 11 GB; stäng andra program) |
| Disk | minst 32 GiB ledigt (40 GiB eller mer rekommenderas: mellan 32 och 40 skriver installationen ut en varning, `[VT-W-DISK-PAY]` [uppmätt: `-Kuru`-körningar med simulerad disk]), modeller på en SSD (helst NVMe) |
| Nedladdning | motor-zip 36,8 MB + CUDA-runtime-zip 567,5 MB [uppmätt] + modeller 31 473 112 040 byte (cirka 29,3 GiB) [läst: storlekar i `scripts/modeller.json`]; cirka 30 GiB totalt |
| Modeller | ingår inte; hämtas av installationsprogrammet under MiniMax-licensen (se varningen nedan). Modellerna (29,3 GiB, 31 473 112 040 byte i `scripts/modeller.json`) finns inte i det här repot eller i releasen: GitHubs gränser för fil- och releasestorlek gäller, och `kur.ps1` laddar ner dem från den officiella källan med sha256-verifiering. |

Exit-koder för `kur.ps1`: 0 READY, 1 fel, 2 användarinmatning behövs (licens, eller ännu ingen release/zip), 3 otillräcklig hårdvara eller disk, 4 stoppad (DUR-fil). `uret.ps1` godkänner en körning bara om `.avi`-filen finns, antalet bildrutor stämmer och loggarna är rena [uppmätt: en riktig körning via `uret.ps1` på release-binären, körning U209, 209 bildrutor, grinden passerades]. Exit-koder för `uret.ps1`: 0 DONE (kvalitetsgrinden passerades), 1 fel eller ogiltig utdata (inklusive en video utan ljudspår), 2 stoppad (DUR-fil), 5 `KAPI RED` (kvalitetsgrinden underkände: klippet är inte godkänt, beslutet är ditt), 6 grinden kunde inte köras (klippet är inte godkänt). Detaljer i AGENTS.md. [uppmätt: exit-koderna 0, 1 (ljudlös video), 5 och 6 i scenarier med en låtsasmotor och en låtsasgrind; riktig motor: exit 0 i körning U209]

### Felsökning (detaljer: `docs/SIK_HATALAR.md`)
Felrader från våra skript bär en stabil kod, till exempel `HATA: [VT-E-DLL] ...` eller `UYARI: [VT-W-DISK-PAY] ...`. Slå upp koden i [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) (ankarexempel `#vt-e-dll`) eller i `docs/hata_imzalari.json` och skriv koden i ditt ärende (issue). Första kolumnen i tabellen nedan förblir som utskriven (översätt inte koder och loggtext).

| Du ser | Vad det betyder, vad du gör |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | Starta inte `sd-cli.exe` för hand; kör `scripts\kur.ps1`, som lägger CUDA-DLL-filerna på plats. |
| `failed during weight preparation` vid `blocks.0` (#1, #3, #5) | Inte tillräckligt med VRAM vid minnesgrinden: använd ett lägre antal bildrutor på 17k+5-rastret, stäng andra GPU-program, behåll de medföljande flaggorna. |
| `retrying with temporal tiling` (#6) | VAE föll tillbaka på tiling; utdatan är ogiltig för kvalitetsändamål. Kör igen. |
| Körningen slutar vid tidsgränsen, ingen video (#7) | Höj `-TavanDk` för långa klipp (standardgräns: 80 min för 209 bildrutor, satt av `uret.ps1`; vår körning med 209 bildrutor tog 57 min [uppmätt: körning U209]). |
| Exit-koden är tom men "finished" (#14) | Wrappern läste exit-koden för tidigt; kör igen och kontrollera att videofilen finns. |
| Systemet blir segt, swappar (#18) | Motorn använder cirka 10-11 GB RAM; stäng webbläsare och andra program. |
| sha256-avvikelse / nedladdningen misslyckades | Oftast en avbruten nedladdning: kör samma kommando igen, verifierade filer hoppas över. |

**Har du kört fast eller är nyfiken?** [`SUPPORT.md`](SUPPORT.md) (var du frågar; svarstider är mål, inte åtaganden) · [`PRIVACY.md`](PRIVACY.md) (ingen telemetri; nätverket används bara för att ladda ner motorn och modellerna, från listade värdar) · [`SECURITY.md`](SECURITY.md) (privat rapportering) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (första pull request i 5 steg; ingen GPU behövs för dokument och skript).

### Nytt i v0.1.1: fler alternativ (detaljer: `AGENTS.md`, `docs/SIK_HATALAR.md` 19-23)
Utan de här alternativen ändras ingenting på ett 4 GB-kort (bytekontrollen med 56 bildrutor mot vår referens gick igenom igen med v0.1.1 [uppmätt]). Lägg till `-Kuru` på valfritt kommando för att se vad som skulle köras.
- `-EndImg`: ange även den sista bildrutan (första och sista bildruta, "FLF"); tak på 175 bildrutor på kort under 8 GB (192 fick inte plats på 4 GB), 192 på kort med 8 GB eller mer. På vårt GTX 1050 Ti körs det alltid i två processer: 56 bildrutor 1040 s, 175 bildrutor 2887 s (48 min), båda passerade grinden [uppmätt]. Tips för prompten: `docs/ISTEM_YAZIMI.md`.
- `-W` / `-H`: andra storlekar, t.ex. stående 384x640; multiplar av 32, yta minst 640x384 (aldrig mindre). Inte testat på 4 GB; på kort under 8 GB avvisas storlekar som går utöver vår största uppmätta körning. Kvalitetsgrindens tröskelvärden är kalibrerade för 640x384.
- `-TekAsama`: en process i stället för två, bara för stora kort; slås aldrig på automatiskt.
- Nyare GPU:er (compute capability 7.0+, t.ex. RTX 20/30/40): `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` sätts automatiskt om du inte har satt den själv; det åtgärdade en helt svart video vid 141 bildrutor och fler på rapportörens RTX 4070 Ti [användarrapporterat, issue #1]. Utan Python + OpenCV stoppar `uret.ps1` nu med exit 6 före GPU-jobbet (ingen video skapas, ingen missvisande RED).
- Tack till @SinanC73 för rapporten om RTX 4070 Ti som ledde till de här ändringarna ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1)).

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

## Valfria hastighetsprofiler (hastighetspaket; avstängda som standard)
Inget nedan ändrar standardkörningen (640x384, 209 bildrutor, 3414 s på vårt kort). Det är tre uppmätta celler utöver den, var och en en namngiven profil i `uret.ps1`; de kräver hastighetspaketets motor (releasemotorn plus patcharna 0021, 0023 och 0024, alla avstängda som standard: `docs/YAMALAR.md`). Installera den med `scripts\kur.ps1 -HizPaketi` (ett lokalt zip fungerar med `-MotorZip`) och lägg sedan till `-Profil <name>`; `-Kuru` visar vad som skulle köras.

| Profil | Storlek, längd | Total tid på ett GTX 1050 Ti 4 GB | Status |
|---|---|---|---|
| (ingen, standard) | 640x384, upp till 209 bildrutor (8,7 s) | 209 bildrutor: 3414 s | verifierad, oförändrad |
| `yuksek832` | 832x480, 141 bildrutor (5,9 s) | cirka 55-56 min | användbar, två prompter [uppmätt] |
| `yuksek832 -Kare 124` | 832x480, 124 bildrutor (5,2 s) | cirka 45-46 min, ingen hastighetsflagga behövs | användbar, två prompter [uppmätt] |
| `yuksek896` | 896x512, 124 bildrutor (5,2 s) | cirka 56-57,5 min | användbar, två prompter [uppmätt] |
| `uzun260` | 640x384, 260 bildrutor (10,8 s) | 78 min uppmätt utan den tidiga avslutningen; med den cirka 71-72 min [gissning: inte mätt från början till slut via `uret.ps1`] | villkorad och experimentell |

- **Smal marginal:** vid 832x480 x 141 lämnar minnesgrinden bara en ensiffrig marginal i MB (5,7 och 6,8 MB i de två fullständiga körningarna). Två långa prompter (1520 och 2041 tecken) kontrollerades endast genom att läsa grinden för steg 1 och en del av steg 2, de kördes inte fullt ut: marginal 10,9 och 4,0 MB. Varje annan process som håller kortets minne (webbläsare, andra skärm) kan få den att misslyckas; använd då `-Kare 124` eller standardstorleken [uppmätt, GTX 1050 Ti 4 GB].
- **`uzun260` är villkorad:** minnesgränsen är mycket snäv (VRAM-topp 3903 av 4096 MiB), användningen av delat minne ökade med 61 och 68 MiB, och det finns ingen referens utan flaggor för bytelikhet, så den erbjuds inte som en vanlig funktion. Patch 0023 godtas bara för denna enda cell.
- **Erbjuds inte:** 832x480 med 158 eller 175 bildrutor ryms inte; längdsökningen slutade där vid 141 bildrutor. Andra storlekar och antal bildrutor avvisas av `-Profil` (använd standardvägen).
- Standardkvaliteten är orörd: 6 steg, cfg 1, VAE utan rutor, 17k+5 bildrutor. Där flaggor är på har utdata jämförts byte för byte med videon utan flaggor vid de storlekar där körningen utan flaggor ryms (`docs/YAMALAR.md`); vid 832x480 x 141 och 896x512 x 124 ryms inte körningen utan flaggor, så likheten där vilar på de närmaste cellerna, inte på en direkt jämförelse [uppmätt, läst].
- Steg 1 i en tvåstegskörning slutar nu så snart den latenta filen är komplett (`VT_ERKEN_CIKIS=0` stänger av det).

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

## Vad det här är
En uppsättning små minnes- och schemaläggningspatchar för stable-diffusion.cpp samt körrecept, kontroller och mätningar som gör att MiniMax H3 (33B DiT; vi kör HyperFlow Flash 13.7B Q4_K_M GGUF; textencodern Qwen3-VL på 32B är separat) kan köras på ett Pascal-GPU med 4 GB (GTX 1050 Ti, 16 GB systemminne).
- Längder i ett enda pass som vi faktiskt har producerat och som passerade våra kvalitetsgrindar: 56, 141, 158, 175, 192, 209 bildrutor i 640x384, 24 fps (209 bildrutor = 8,7 s), med H3:s eget genererade ljud [uppmätt: 209 bildrutor med release-binären via `uret.ps1`, körning U209; latenten är byte-identisk med körningen på utvecklingsbygget; bildrutor och ljud är identiska i videon, filens sha skiljer sig på grund av containern; underlaget förvaras av skaparna och finns inte i det här repot]. 209 är den längsta längd vi har tittat på och funnit jämn [användarrapporterat, 2026-11-19, videon sedd i sin helhet; fil: F209V2-utdata, 8,708 s].
- **Byte-identiskt påstående, ärligt avgränsat:** utdata kontrollerades som byte-identisk med den opatchade referensen bara för 56 och 141 bildrutor. För 158/175/192/209 bildrutor använde vi samma flaggor och samma binärkedja; det finns ingen direkt byte-referens (det opatchade bygget kan inte köra de längderna på det här GPU:t).
- Kvalitetsinställningarna sänks aldrig: samma modell/kvantisering, 6 steg, cfg 1, 640x384, samma seed, VAE utan tiling.
- Vi påstår inte att vi är först: vi sökte och hittade inget externt exempel på detta med 4 GB, vilket inte är något bevis för att inget sådant finns.

## Struktur
- `patches/` patchar mot en låst stable-diffusion.cpp-commit (se anteckningarna där)
- `scripts/` bygg-, kör- och separat-process-VAE-skript samt hjälpmedel för grind och konsekvens (`doku_norm.py`: se skalanteckningen nedan)
- `docs/KURULUM.md` hårdvara, bygg- och körsteg (EN+TR)
- `docs/YAMALAR.md` patchlista, `docs/KANITLAR.md` underlag, `docs/KAPILAR.md` tabell över kvalitetsgrindar, `docs/OLCUMLER.md` mätningar, `docs/SIK_HATALAR.md` vanliga misstag, `docs/LISANS_UYARISI.md` licenspunkterna i sin helhet
- `scripts/` kort index: `hiz_kos3.ps1` körwrapper (`-Kuru` skriver ut det exakta kommandot), `uretim_kapi.ps1` kvalitetsgrind, `dikis_denetim.py` skarvkontroll, `doku_norm.py` texturnormaliserat brus, `bayt_kiyas.py` bytejämförelse, `derleme_sablonu.ps1` byggmall (stoppar bara Visual Studios telemetrihjälpare `vctip.exe` som startade efter att det egna bygget började och som annars håller byggprocessen kvar i flera minuter; andra `vctip.exe`-processer lämnas ifred)

## Kvalitetsgrindar (hur ett resultat godkänns)

Grinden kontrollerar inte rörelsekonsekvens (hopp i objektets skala eller position): titta på hela videon innan du godkänner den.
1. Antal bildrutor och ljud finns; inga minnesfallback- eller ALLOC_FAILED-rader i loggen.
2. Grind för rått brus: medianfilterrester <= 1,5 (skala 0-255).
3. Texturnormaliserat brus, `scripts/doku_norm.py` (det här repots version): N = medianrest / Sobel-textur, var 6:e bildruta. **Skalanteckning:** i den här versionen ger de 10 uppmätta klippen N = 0,034-0,052 (tabell i `docs/KAPILAR.md`; sista kvartalet av F192/F209V2 når 0,062) och tröskeln för extragrinden är N <= 0,065. En annan implementation mätte 0,028-0,036 på samma klipp, så trösklar är INTE utbytbara mellan versioner. På mycket fina texturer (gräsrader) var rent N 0,075, så tröskeln gäller per scenfamilj. En robust högfrekvensskattare (sigma-HH <= 1,5; rent 0,74-1,19, tillagt brus s=2 ger 2,2-3,0) är den rekommenderade extragrinden.

Omfattning: VideoTurko gäller ETT enda pass (upp till 209 bildrutor, cirka 8,7 s). Vårt eget test med hopkedjning visade synliga skarvar (scenen fortsätter inte rent), så längre filmer ingår inte i det vi verifierar. För hopkedjning finns communityguiden `docs/KLIP_ZINCIRI.md` och vårt CPU-hjälpverktyg `scripts/zincir.py` (`plan`, `son-kare`, `bagla`; det startar aldrig motorn); kvaliteten på hopkedjade filmer har vi inte mätt [ej provat], så kontrollera varje skarv med ögat och med `scripts/dikis_denetim.py`.
Dina inställningar är dina: 209 bildrutor är vår testade standard på ett 4 GB-kort, inte en gräns du måste följa. Välj valfritt antal bildrutor på 17k+5-rastret (56, 73, ... 192, 209; se `docs/KURULUM.md`), ändra prompt, seed, upplösning eller vilken flagga du vill. Kortare klipp kräver mindre minne och tid; större GPU:er kan rymma mer.

## Varning för modelllicensen
**VideoTurko innehåller bara patchar och skript (MIT); den som använder modellen och dess utdata ansvarar själv för MiniMax-licensen.** Inte juridisk rådgivning. Nedan sammanfattas klausulerna i MiniMax H3 Community License (2 augusti 2026) med deras nummer; själva licensen är den bindande: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

MIT-licensen för det här förrådet täcker inte modellvikterna; se [`NOTICE`](NOTICE). Det här repot innehåller INGA modellvikter (inga filer för MiniMax H3, HyperFlow-H3-Flash GGUF eller VAE). Projektet är inte knutet till eller godkänt av MiniMax. Kommersiell användning är INTE förbjuden (det är inte en licens för enbart icke-kommersiellt bruk); villkoren står nedan.

**Territorium (Applicable Territory)**
- **Preambel, I.3, I.5:** Hela världen, UTOM Europeiska unionen, Storbritannien, Republiken Korea och USA. Att använda modellen räknas som att godta licensen.
- **II:** Royaltyfri, icke överlåtbar, begränsad licens att använda, reproducera, distribuera, skapa derivat och ändra, enbart inom territoriet och i enlighet med avtalet och Exhibit A. Personer i undantagna territorier kan be MiniMax om en separat licens.
- **V.4:** Att använda, reproducera, ändra, distribuera eller visa modellen, dess derivat OCH UTDATA (genererad video/genererat ljud) utanför territoriet är inte tillåtet. **Att publicera eller visa genererade videor i EU/Storbritannien/Sydkorea/USA ligger alltså utanför licensen.**
- **Exhibit A-1:** Användning utanför territoriet strider mot Acceptable Use Policy.

**Distribution (III)** (det här repot distribuerar inte modellen; om du gör det)
- **III.1:** Ge varje mottagare en kopia av licensen. **III.2:** Märk ändrade filer med tydliga meddelanden.
- **III.3:** Uppmuntras (inte obligatoriskt): notisen "Powered by MiniMax H3", en identifierare för AI-generering på producerade filer, en offentlig beskrivning.
- **III.4:** Distributioner MÅSTE åtföljas av en NOTICE-fil med: "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12:** att publicera innehåll i någon offentlig miljö utan att tydligt ange att det är maskingenererat är förbjudet: märk AI-genererade videor när du publicerar dem (hela listan: `docs/LISANS_UYARISI.md`).
- **III (sista stycket):** Du får lägga till din egen upphovsrätt för dina ändringar men får inte ställa ytterligare eller avvikande villkor för användning/distribution; territoriereglerna gäller fortfarande.

**Kommersiella villkor (IV)**
- **IV.1:** Om dina kommersiella produkter/tjänster genererar mer än 20 miljoner USD (eller motsvarande) i årlig omsättning, inhämta FÖRE användning skriftligt tillstånd från api@minimax.io (ämne "MiniMax H3 licensing - authorization request").
- **IV.2:** Gränssnittet i en kommersiell produkt/tjänst som använder modellen måste tydligt visa "MiniMax H3".

**Användningsbegränsningar (V)**
- **V.1:** Följ tillämplig lag (inklusive handelsregler) och Exhibit A. **V.2:** Bind alla du ger åtkomst genom villkor som är minst lika skyddande som dessa begränsningar och underrätta dem.
- **V.3:** Du får inte använda modellen eller dess UTDATA för att förbättra någon annan AI-modell (annan än MiniMax H3 och dess derivat). (I.11: destillering och träning på syntetiska utdata gör en modell till ett "derivat"; utdatan i sig är inte derivat.)
- **V.5:** Om du erbjuder tredje part en produkt/tjänst/värdtjänst som genererar utdata med modellen: före och under hela driften rimliga tekniska och organisatoriska skyddsåtgärder, en rapporteringsmekanism, skyndsam utredning samt borttagning/avaktivering/avstängning av upprepade överträdare.

**Varumärke och rättigheter (VI)**
- **VI.1:** Du äger de derivatverk och modellderivat du skapar (med förbehåll för MiniMax rättigheter). **VI.2:** MiniMax namn/märken licensieras inte (utöver vad som behövs för att beskriva och distribuera); märket "MiniMax H3" får bara användas för att följa III.3, inom territoriet; antyd ingen anknytning.
- **VI.3:** Om du stämmer MiniMax eller någon annan och hävdar att materialet/utdatan gör intrång i dina rättigheter upphör alla dina licenser samma dag; du försvarar och håller MiniMax skadeslöst mot tredjepartskrav som följer av din eller andras användning/distribution.
- **VI.4:** MiniMax gör inga anspråk på utdatan; du och dina användare ansvarar för utdatan och dess användning.

**Friskrivningar och upphörande (VII, VIII, IX)**
- **VII.1:** Ingen skyldighet att ge support/uppdatera. **VII.2:** Modellen och utdatan tillhandahålls "AS IS", utan garantier; du avgör lämpligheten och bär risken. **VII.3:** MiniMax och närstående bolag ansvarar inte för några skador (i den utsträckning lagen tillåter).
- **VIII.1:** Gäller från godkännande/åtkomst. **VIII.2:** Vid brott kan MiniMax säga upp avtalet; du måste sluta använda/distribuera, radera kopior och underrätta mottagare (VI.1, VI.3, VII, IX gäller fortfarande).
- **IX:** Hongkongs SAR:s lag; exklusiv behörighet för domstolarna i Hongkong (FN:s köplag CISG undantagen).
- **Ytterligare anmärkning:** MiniMax H3:s encoder använder Qwen3-VL-32B (Apache 2.0).

**Acceptable Use Policy (Exhibit A)** (använd INTE modellen, derivaten eller utdatan för)
- A-1 användning utanför territoriet; A-2 brott mot lagar eller tredje parts immateriella rättigheter; A-3 att skada dig själv eller andra; A-4 att omvandla/distribuera utdata i skadligt syfte; A-5 att kringgå skyddsåtgärder; A-6 att utnyttja/skada minderåriga; A-7 verifierbart falsk information för att skada andra eller påverka val; A-8 falskt engagemang på nätet (falska recensioner med mera); A-9 förtal, nedvärdering, trakasserier; A-10 skadlig kod; A-11 personuppgifter för att skada andra; **A-12 att publicera innehåll i någon offentlig miljö (inklusive botinlägg) utan att tydligt och framträdande ange att det är maskingenererat**; A-13 att utge sig för att vara någon annan utan samtycke; A-14 automatiserade beslut med hög risk inom kritiska områden (brottsbekämpning, migration, hälsa, kritisk infrastruktur, kredit, anställning, bostad, utbildning, social poängsättning, försäkring med mera); A-15 att bryta mot andra länders/regioners sociala, etiska och moraliska normer; A-16 våldsbejakande extremism/terrorism; A-17 diskriminering/skada på grund av skyddade egenskaper; A-18 att utnyttja sårbara grupper; **A-19 militära ändamål**; A-20 obehörig/olicensierad yrkesverksamhet (finansiell, juridisk, medicinsk med mera).
- Obs: det här är en sammanfattning på vanligt språk, inte ett juridiskt utlåtande; den engelska licenstexten gäller vid tvekan.

## Underlagsetiketter

En uppsättning för alla dokument (äldre stavningar inom parentes):
- **[uppmätt]** (TR: ölçtüm, olctum): körd i det här projektet, underlagssökväg finns.
- **[läst]** (TR: okudum yol, okudum): källa eller skript lästes, kördes inte.
- **[upplägg]** (TR: tasarım, tasarim): utformat, ännu inte sett i en riktig körning.
- **[gissning]** (TR: tahmin): inte verifierat.
- **[ej provat]** (TR: denenmedi): aldrig körd.
- **[användarrapporterat]** (TR: kullanıcı bildirdi): uppgivet av användaren, med datum; inte oberoende uppmätt.
- **[beräknat]** (TR: hesap; äldre stavningar: calculated, hesap): ett tal som härletts ur uppmätta indata, inte uppmätt i sig; härledningen står bredvid. [förslag] / [öneri] i äldre text = [gissning].

Körningsnamn som används inom hakparentes (våra egna körningsnamn, inte filer i det här repot): U209 = 209 bildrutor med release-binären via `uret.ps1`; B209 och B192 = image-to-video-körningar (`-InitImg`) med 209 och 192 bildrutor; B56VT2 = release-binär, 56 bildrutor, jämförd med byte-referensen R0 för 56 bildrutor; F209b, F209V2, F209V2K = körningar med 209 bildrutor på utvecklingsbygget (detaljer: `docs/OLCUMLER.md`).

## Kända begränsningar
- **Bytebevis** (så reproducerar du det själv: `docs/KANITLAR.md`, "R0 ve latent referansi nasil uretilir"; verifierat på vårt sm_61-kort, andra GPU:er är kanske inte byte-identiska [gissning]): med vår patchserie (minnesflaggor på) gav en körning med 56 bildrutor sha256 `0979f156d548169b...`, identisk med referensen [uppmätt]; vid 141 bildrutor var latentens sha256 `E5D028F8632BE4FE...` identisk (med flaggorna 0013/0014). För 158 till 209 bildrutor finns ingen direkt byte-referens; grindkedjan är underlaget. Att de numeriska grindarna passeras garanterar inte ett bra klipp: rörelsekonsekvens över tid kontrolleras med ögat (se `docs/KAPILAR.md`).
- **209 bildrutor, vilken flaggsats:** bytekedjans underlag för 209 bildrutor togs med flaggsatsen F209V2 på utvecklingsbygget (inga block-tail-flaggor, byggt utan patchar 0019/0020); `uret.ps1` använder det receptet för 209 bildrutor [läst: skriptet; en riktig motorkörning via `uret.ps1` gick igenom i körning U209].
- Verifierat av oss på ett kort (GTX 1050 Ti 4 GB); externa rapporter om andra kort listas med sina etiketter i `docs/KART_PROFILLERI.md` [användarrapporterat].
- **Vilken binär som mättes:** latenten för 141 bildrutor och bytekedjan mättes med våra utvecklingsbyggen. Release-binären du laddar ner är ett nytt bygge: dess byte-grind för 56 bildrutor passerades (nästa punkt) och en körning med 209 bildrutor via `uret.ps1` passerade grinden (körning U209, 3414 s, VRAM-topp 3777 MiB) [uppmätt]; mot utvecklingsbyggets körning med 209 bildrutor är latenten byte-identisk; i videon är bildrutorna (md5) och ljudet identiska, AVI-filens sha256 skiljer sig på grund av containern [uppmätt] (se `docs/OLCUMLER.md`, avsnitt 0).
- **Release-binär, 56 bildrutor:** release-binären (sd-cli `c5cebe78...`, stable-diffusion.dll `e5d3d329...`) gav ett resultat för 56 bildrutor som var byte-identiskt med R0 (sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`; md5 per bildruta och ljud identiska), körd direkt med standardflaggor (inga `SD_*`-variabler), exit-kod 0, 601 s [uppmätt: körning B56VT2, 2026-11-19; underlaget förvaras av skaparna och finns inte i det här repot]. Omfattning: bara vårt sm_61-kort och 56 bildrutor; inte ett installationstest i tom rotmapp; latenten för 141 bildrutor och 209-kedjan mättes med den äldre binären och upprepades INTE med den här [ej provat]. Ett första försök (B56VT, via ett hjälpskript) tog slut tyst efter 58 s, orsak okänd [gissning: minnestryck]; det andra försöket körde `sd-cli` direkt.
- Installations- och körskripten har ännu inte verifierats från en tom mapp (test i tom rotmapp återstår).
- Färdplan och nästa steg: `ROADMAP.md`.

## Status och begränsningar
- Verifierat på en dator (GTX 1050 Ti 4 GB, 16 GB RAM, i7-7700HQ). Andra 4 GB-kort och andra RAM-storlekar kan skilja sig åt.
- **Standard 209 bildrutor (8,7 s):** passerade våra kvalitetsgrindar (brus 1,08, körning F209V2K) [uppmätt: 209 bildrutor med release-binären via `uret.ps1`, körning U209; latenten är byte-identisk med körningen på utvecklingsbygget; bildrutor och ljud är identiska i videon, filens sha skiljer sig på grund av containern; underlaget förvaras av skaparna och finns inte i det här repot]. Vid 209 bildrutor låg DiT:s VRAM-topp på 3777 MiB av 4096 MiB (körningarna F209b och U209; avläsning av hela kortet med `nvidia-smi`), en smal marginal: annan GPU-belastning (skärmen, andra program) kan få körningen att misslyckas vid `blocks.0`; testad bara på ett GTX 1050 Ti. Skärmens tillstånd under den körningen noterades inte; om din skärm körs på det här kortet finns mindre VRAM tillgängligt [gissning: en Windows-skärmbelastning på cirka 100-300 MB]; vid behov, anslut skärmen till ett integrerat GPU [råd, ej testat]. Samplingen tog 2730 s (körning U209: steg på 436-483 s) och VAE-avkodningen i separat process 173 s (steg 2 totalt 193 s med ljudavkodningen) [uppmätt: U209 release-binär; äldre utvecklingskörningar: 2664 s och 174 s]. I steg 1 fick VAE i processen slut på minne och föll tillbaka på temporal tiling (320 s); den utdatan kasseras, videon kommer från steg 2 utan tiling. Högsta RAM-användning mättes inte i U209. Längre klipp än 209 bildrutor ingår inte i den här releasen.
- **Image-to-video (`-InitImg`):** med en startbild är taket 192 bildrutor (8,0 s vid 24 fps) på det här GPU:t: 209 bildrutor fick inte plats (cirka 17,5 MB VRAM saknades vid block 0: behov 2587 MB, tillgängligt 2570 MB); 192 bildrutor kördes via `uret.ps1` på 3086 s med en VRAM-topp på 3783 MiB och grinden passerades [uppmätt: körningarna B209 och B192, 2026-11-20, en scen; underlaget förvaras av skaparna och finns inte i det här repot]. Inte provat på andra GPU:er [ej provat].
- **Ledigt RAM spelar roll:** du behöver cirka 11 GB LEDIGT RAM (motorprocessen håller cirka 11 GB) [uppmätt]. Med för lite ledigt RAM kan processen dö utan felmeddelande [gissning: vi såg det en gång med cirka 300 MB ledigt RAM medan `sd-cli` höll cirka 10 GB]. Öppna inga andra stora program medan den körs: på en dator med 16 GB blir bara cirka 0,3-0,5 GB över, och under minnestryck kan körningen dö tyst. Innan du startar, stäng webbläsare, spel och andra stora program och kontrollera hur mycket RAM som är ledigt.
- **Test i tom rotmapp återstår:** installations- och körskripten har ännu inte verifierats från en tom mapp med enbart de här instruktionerna; det här avsnittet uppdateras när det testet (inklusive en byte-jämförelse med 56 bildrutor mot referensen) är dokumenterat.
- Inga genererade videor levereras här.

<!-- i18n-source: README.md sha256:67497404d89b -->
