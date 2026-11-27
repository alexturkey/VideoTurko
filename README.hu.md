# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · Magyar · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

A fordítások ezt az angol README-t követik. Ha egy fordítás eltér vagy lemarad, az angol szöveg az irányadó, különösen a licenc- és biztonsági szövegnél (a [`SECURITY.md`](SECURITY.md) és a [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) csak angolul és törökül van karbantartva).

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **Mielőtt elkezded (licenc, terület):** ez a tárhely MIT licencű, és csak patcheket és szkripteket tartalmaz. A letöltött MiniMax H3 modell a MiniMax H3 Community License hatálya alatt áll: a hatályából ki van zárva az Európai Unió, az Egyesült Királyság, Dél-Korea és az Egyesült Államok, és a modellt, a származékokat **és a kimeneteket (az általad generált videókat)** ott nem szabad használni, terjeszteni vagy megjeleníteni (V.4). Kereskedelmi használat a licenc feltételein belül megengedett. Telepítés előtt olvasd el a [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) fájlt; ez nem jogi tanács.

> **30 másodpercben:** egy 4 GB-os videókártya egyetlen menetben el tud készíteni egy 209 képkockás (8.7 s) MiniMax H3 videót: egy gépen ellenőrizve (GTX 1050 Ti 4 GB; a `kur.ps1` teljes telepítése üres mappában még nincs végigellenőrizve) [mért: 209 képkocka a kiadási binárissal a `uret.ps1`-en keresztül, U209 futás; a latent bájtra azonos a fejlesztői build futásával; a képkockák és a hang a videóban azonosak, a fájl sha-ja a konténer miatt eltér; a bizonyítékokat a szerzők őrzik, ebben a tárolóban nincsenek]; `-InitImg` mellett (kép videóvá) legfeljebb 192 képkocka (8.0 s) [mért: B192 futás]; 209 képkocka kb. 57 percig tart, az alapértelmezett időkorlát 80 perc [mért: U209 futás]; a futtatást az alábbi 3 lépés mutatja.

VideoTurko: stable-diffusion.cpp memóriapatchek és receptek a MiniMax H3 (szövegből videó) futtatásához 4 GB-os GTX 1050 Ti-n, legfeljebb 209 képkocka (8.7 s) egyetlen menetben; kép videóvá (`-InitImg`) legfeljebb 192 képkocka (8.0 s) (a 209 képkockát bájtlánc igazolja; az 56 és 141 képkockás ellenőrzéseken az eredmény bájtra azonos volt a patchek nélküli futással).

## Gyorsindítás (Windows, 3 lépés)
**Állapot: az alábbi telepítő és futtató szkriptek még készülnek, a tiszta mappás teszt még hátravan; amíg ez nem sikerül, nem állítjuk, hogy bármi működik (lásd: „Állapot és korlátok”).**

1. **Töltsd le** ezt a tárolót (zöld **Code** gomb, majd **Download ZIP**), és csomagold ki egy RÖVID útvonalra, például `C:\vt`.
2. **Telepítés: kattints duplán a `kur.cmd` fájlra** (egy fekete ablak nyílik, és megmutatja az egyes lépéseket; bezárása leállítja a telepítést, az újbóli futtatás ott folytatja, ahol abbamaradt: a félig letöltött modellfájl folytatódik [elolvasva: a letöltő szkript egy `.part` fájlt őriz, és abból folytatja; a teljes 29 GiB-os folytatást nem mértük]). Ha a Windows figyelmeztet a letöltött fájlra, használd helyette az alábbi PowerShell-parancsot [tanács, letöltött ZIP-pel nem tesztelve]. A parancssort szereted jobban? Nyiss PowerShellt abban a mappában (írd be: `powershell` az Intéző címsorába), és futtasd ugyanezt a telepítést:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   A telepítés gyökere a mappa, ahová kicsomagoltad az archívumot (a motor az `engine\bin` mappába kerül, a modellek a `model` mappába); más hely használatához előbb állítsd be a `VT_ROOT` környezeti változót. A szkript ellenőrzi a GPU-t, az illesztőprogramot, a RAM-ot és a lemezt, letölti a motort és a modelleket (a motor zip-jeit és az újonnan letöltött modellfájlokat sha256-tal ellenőrzi; az a modellfájl, amely már ott van és a mérete helyes, csak méretre van ellenőrizve, a teljes sha256-ellenőrzést a `scripts\modelleri_indir.ps1 -Dogrula` végzi), lefuttat egy rövid valódi próbát, és csak akkor írja ki a READY-t, ha az átment [tervezett: a `kur.ps1` még nem futott végig tiszta mappában; ezt a mondatot a tiszta mappás teszt után frissítjük]. Az `-ExecutionPolicy Bypass` csak erre az egy folyamatra érvényes; mint minden telepítőt, előbb olvasd el a `scripts\kur.ps1`-et.
   A motor zip-fájlja a GitHubon közzétett v0.1.0 kiadásból töltődik le (közzétéve: 2026-11-19; a sha256-ja rögzítve van a `kur.ps1`-ben). Internet nélkül vagy saját builddel adj meg helyi zip-fájlokat: `-MotorZip <path> -CudaZip <path>`. A helyi zip-fájlt ugyanazzal a rögzített sha256-tal ellenőrzi (a mellette lévő `.sha256` fájlt figyelmen kívül hagyja), ezért a kiadási zipnek kell lennie; saját buildhez előbb állítsd be a `VT_MOTOR_SHA256` / `VT_CUDA_SHA256` változót annak sha256-jára. Rossz sha256 esetén a szkript 1-es kóddal leáll. Az `engine\bin` mappába csak `.exe` és `.dll` kerül; a licencek és a README az `engine\lisanslar\<zip name>\` mappába. [a kiadás előtt kipróbálva a dist zip-ekkel: a melletti `.sha256` és az önhivatkozásra figyelmeztetés, a bináris és a DLL-ek a helyükre kerültek, az `sd-cli --help` lefutott; a telepített binárisok sha-ja egyezett (`c5cebe78...`, `e5d3d329...`); a modelllépést és a `kur.ps1` 5 képkockás próbáját valódi GPU-n MÉG NEM futtattuk]
   **A modell licence:** a modelllépés előtt a telepítő kiírja a licenc összefoglalóját (`docs/LISANS_KABUL.txt`, teljes szöveg: `docs/LISANS_UYARISI.md`: MiniMax H3 Community License, a generált videókra is kiterjedő területi korlátok, kereskedelmi és MI-jelölési szabályok), és elfogadást kér (`E` = igen). Előbb olvasd el. Felügyelet nélküli futtatáshoz megadhatod a `-LisansKabul E` kapcsolót, ami azt jelenti, hogy te magad elolvastad és elfogadtad a licencet; ne add meg más helyett. (MI-ügynököknek: kövessétek az `AGENTS.md`-t; soha ne írjatok E-t a felhasználó beleegyezése nélkül.) Elfogadás nélkül a `kur.ps1` 2-es kilépési kóddal leáll, és nem tölt le modellt.
3. **Az első videód (56 képkocka, kb. 11 perc a mi GTX 1050 Ti kártyánkon** [mért: 641 mp, futás R0, `docs/OLCUMLER.md`; más kártyákat nem mértünk]**)**: amikor a telepítő kiírja: `HAZIR / READY`, futtasd
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (gyorsítás: húzz egy prompt-szövegfájlt az `uret.cmd` fájlra, vagy futtasd: `uret.cmd docs\ornek_istem_R0.txt`; ugyanaz az 56 képkockás futás). A videó a `runs\` mappában van. Ezután írd meg a saját promptodat egy szövegfájlba (egy angol bekezdés, opcionális `audio:` mondat), és futtasd a leghosszabb klipet, amelyet lefedünk (alapértelmezett, kb. 57 perc [mért: futás U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   A `-Kare` a 17k+5 rácsot követi (56, 73, ... 192, 209); alapértelmezés 209 (8.7 s), a leghosszabb általunk lefedett hossz. A VAE külön folyamatban fut, és soha nem csempézett (tiling) [valódi motorfutás a `uret.ps1`-en keresztül a kiadási binárissal, külön folyamatú VAE, átment az U209 futásban].

   Prompt-írási útmutató: [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (egyetlen megszakítatlan felvétel mintája, egyenlő időszeletek, két teljes példa).

| Követelmény | Érték |
|---|---|
| Operációs rendszer | Windows 10/11, 64 bites |
| GPU | NVIDIA, 4 GB vagy több; csak GTX 1050 Ti-n (sm_61) tesztelve; kicsi a tartalék (3777/4096 MiB 209 képkockánál): egy terhelt képernyő vagy böngésző megszakíthatja a futást; más 4 GB-os kártyát nem próbáltunk |
| RAM | 16 GB (csúcs kb. 11 GB; zárd be a többi programot) |
| Lemez | legalább 32 GiB szabad hely (40 GiB vagy több ajánlott: 32 és 40 között a telepítő figyelmeztetést ír ki, `[VT-W-DISK-PAY]` [mért: `-Kuru` futások szimulált lemezzel]), a modellek SSD-n (lehetőleg NVMe) |
| Letöltés | motor zip 36.8 MB + CUDA futtatókörnyezet zip 567.5 MB [mért] + modellek 31,473,112,040 bájt (kb. 29.3 GiB) [elolvasva: a méretek a `scripts/modeller.json`-ban]; összesen kb. 30 GiB |
| Modellek | nem tartozékok; a telepítő a MiniMax licenc alapján tölti le őket (lásd az alábbi figyelmeztetést). A modellek (29.3 GiB, 31,473,112,040 bájt a `scripts/modeller.json`-ban) sem ebben a tárolóban, sem a kiadásban nincsenek: a GitHub fájl- és kiadásméret-korlátai érvényesek, a `kur.ps1` pedig a hivatalos forrásból tölti le őket sha256-ellenőrzéssel. |

A `kur.ps1` kilépési kódjai: 0 READY, 1 hiba, 2 felhasználói beavatkozás kell (licenc, vagy még nincs kiadás/zip), 3 nincs elég hardver vagy lemezhely, 4 leállítva (DUR fájl). A `uret.ps1` csak akkor fogad el egy futást, ha az `.avi` létezik, a képkockák száma helyes és a naplók tiszták [mért: egy valódi futás a `uret.ps1`-en keresztül a kiadási binárissal, U209 futás, 209 képkocka, az ellenőrzés átment]. A `uret.ps1` kilépési kódjai: 0 DONE (a minőségi ellenőrzés átment), 1 hiba vagy érvénytelen kimenet (beleértve a hangsáv nélküli videót), 2 leállítva (DUR fájl), 5 `KAPI RED` (a minőségi ellenőrzés megbukott: a klipet nem fogadtuk el, a döntés a tiéd), 6 az ellenőrzést nem sikerült lefuttatni (a klipet nem fogadtuk el). Részletek az AGENTS.md-ben. [mért: 0, 1 (néma videó), 5 és 6 kilépési kód hamis motorral és hamis ellenőrzéssel készült forgatókönyvekben; valódi motorral: 0-s kilépési kód az U209 futásban]

### Hibaelhárítás (részletek: `docs/SIK_HATALAR.md`)
A szkriptjeink hibasorai állandó kódot viselnek, például `HATA: [VT-E-DLL] ...` vagy `UYARI: [VT-W-DISK-PAY] ...`. Keresd meg a kódot a [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) fájlban (horgonypélda `#vt-e-dll`) vagy a `docs/hata_imzalari.json` fájlban, és írd be a kódot az issue-dba. Az alábbi táblázat első oszlopa úgy marad, ahogy kiíródik (a kódokat és a naplószöveget nem fordítjuk).

| Ezt látod | Mit jelent, mit tegyél |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | Ne indítsd kézzel az `sd-cli.exe`-t; futtasd a `scripts\kur.ps1`-et, amely a helyére teszi a CUDA DLL-eket. |
| `failed during weight preparation` a `blocks.0`-nál (#1, #3, #5) | Nincs elég VRAM a memóriakapunál: használj kevesebb képkockát a 17k+5 rácsból, zárd be a GPU-t használó többi programot, hagyd a mellékelt kapcsolókat. |
| `retrying with temporal tiling` (#6) | A VAE csempézésre váltott; a kimenet minőségi célra érvénytelen. Futtasd újra. |
| A futás az időkorlátnál véget ér, nincs videó (#7) | Emeld a `-TavanDk` értékét hosszú klipekhez (alapértelmezett időkorlát: 80 perc 209 képkockára, a `uret.ps1` állítja be; a mi 209 képkockás futásunk 57 percig tartott [mért: U209 futás]). |
| A kilépési kód üres, de „finished” áll (#14) | A burkoló szkript túl korán olvasta a kilépési kódot; futtasd újra, és ellenőrizd, hogy a videófájl létezik. |
| A rendszer lelassul, lapozás van (#18) | A motor kb. 10-11 GB RAM-ot használ; zárd be a böngészőket és a többi programot. |
| sha256-eltérés / a letöltés sikertelen | Általában megszakadt a letöltés: futtasd újra ugyanazt a parancsot, az ellenőrzött fájlokat kihagyja. |

**Elakadtál, vagy kíváncsi vagy?** [`SUPPORT.md`](SUPPORT.md) (hol kérdezz; a válaszidők célok, nem vállalások) · [`PRIVACY.md`](PRIVACY.md) (nincs telemetria; a hálózatot csak a motor és a modellek letöltésére használjuk, a felsorolt gazdákról) · [`SECURITY.md`](SECURITY.md) (privát bejelentés) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (az első pull request 5 lépésben; dokumentumokhoz és szkriptekhez nem kell GPU).

### Újdonságok a v0.1.1-ben: további kapcsolók (részletek: `AGENTS.md`, `docs/SIK_HATALAR.md` 19-23)
Ezek nélkül a kapcsolók nélkül 4 GB-os kártyán semmi sem változik (a referenciánkhoz mért 56 képkockás bájtellenőrzés a v0.1.1-gyel is újra átment [mért]). Ha látni szeretnéd, mi futna le, add hozzá a `-Kuru` kapcsolót bármelyik parancshoz.
- `-EndImg`: az utolsó képkockát is megadhatod (első és utolsó képkocka, „FLF”); a felső határ 8 GB alatti kártyán 175 képkocka (192 nem fért bele 4 GB-ba), 8 GB-os vagy nagyobb kártyán 192. A mi GTX 1050 Ti kártyánkon mindig két folyamatban fut: 56 képkocka 1040 s, 175 képkocka 2887 s (48 perc), mindkét futás átment a minőségi ellenőrzésen [mért]. Prompttippek: `docs/ISTEM_YAZIMI.md`.
- `-W` / `-H`: más méretek, például álló 384x640; 32 többszörösei, a terület legalább 640x384 (ennél kisebb soha). 4 GB-on nem teszteltük; 8 GB alatti kártyákon a program elutasítja azokat a méreteket, amelyek túllépik a legnagyobb mért feladatunkat. A minőségi ellenőrzés küszöbei 640x384-re vannak kalibrálva.
- `-TekAsama`: kettő helyett egy folyamat, csak nagy kártyákhoz; magától soha nem kapcsol be.
- Újabb GPU-k (compute capability 7.0+, pl. RTX 20/30/40): a `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` automatikusan beállítódik, hacsak nem állítottad be magad; ez a bejelentő RTX 4070 Ti kártyáján megszüntette a 141 vagy több képkockánál jelentkező teljesen fekete videót [felhasználó jelentette, issue #1]. Python + OpenCV nélkül az `uret.ps1` most már a GPU-feladat előtt leáll 6-os kilépési kóddal (nem készül videó, nincs félrevezető RED).
- Köszönet @SinanC73 felhasználónak az RTX 4070 Ti-n készült jelentésért, amely ezekhez a változtatásokhoz vezetett ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1)).

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

## Opcionális sebességprofilok (sebességcsomag; alapból kikapcsolva)
Az alábbiak közül semmi nem változtatja meg az alapértelmezett futtatást (640x384, 209 képkocka, 3414 s a mi kártyánkon). Ez három mért cella azon túl, mindegyik az `uret.ps1` egy elnevezett profilja; a sebességcsomag motorját igénylik (a kiadási motor plusz a 0021, 0023, 0024 javítások, mind alapból kikapcsolva: `docs/YAMALAR.md`). Telepítse a `scripts\kur.ps1 -HizPaketi` paranccsal (helyi zip a `-MotorZip` kapcsolóval működik), majd adja hozzá a `-Profil <name>` kapcsolót; a `-Kuru` kiírja, mi futna le.

| Profil | Méret, hossz | Teljes idő GTX 1050 Ti 4 GB-on | Állapot |
|---|---|---|---|
| (nincs, alapértelmezett) | 640x384, legfeljebb 209 képkocka (8,7 s) | 209 képkocka: 3414 s | ellenőrzött, változatlan |
| `yuksek832` | 832x480, 141 képkocka (5,9 s) | kb. 55-56 perc | használható, két prompt [mért] |
| `yuksek832 -Kare 124` | 832x480, 124 képkocka (5,2 s) | kb. 45-46 perc, sebességkapcsoló nem kell | használható, két prompt [mért] |
| `yuksek896` | 896x512, 124 képkocka (5,2 s) | kb. 56-57,5 perc | használható, két prompt [mért] |
| `uzun260` | 640x384, 260 képkocka (10,8 s) | 78 perc mérve a korai kilépés nélkül; vele kb. 71-72 perc [feltételezés: nem mértük végig az `uret.ps1`-en keresztül] | feltételes és kísérleti |

- **Szűk tartalék:** 832x480 x 141 esetén a memóriakapu csak egyjegyű MB tartalékot hagy (5,7 és 6,8 MB a két teljes futásban). Két hosszú promptot (1520 és 2041 karakter) csak úgy ellenőriztünk, hogy az 1. lépés és a 2. lépés egy részének kapuját olvastuk, teljes futtatás nélkül: tartalék 10,9 és 4,0 MB. Bármely más, a kártya memóriáját foglaló folyamat (böngésző, második kijelző) hibát okozhat; ilyenkor használja a `-Kare 124` kapcsolót vagy az alapméretet [mért, GTX 1050 Ti 4 GB].
- **Az `uzun260` feltételes:** a memóriahatár nagyon szűk (VRAM-csúcs 3903 a 4096 MiB-ból), a megosztott memória használata 61 és 68 MiB-tal nőtt, és bájtegyezéshez nincs kapcsoló nélküli referencia, ezért nem sima funkcióként kínáljuk. A 0023 javítást csak erre az egy cellára fogadtuk el.
- **Nem kínált:** a 832x480 158 vagy 175 képkockával nem fér el; a hosszkeresés ott 141 képkockánál ért véget. Más méreteket és képkockaszámokat a `-Profil` elutasít (használja az alapértelmezett utat).
- Az alapértelmezett minőség érintetlen: 6 lépés, cfg 1, csempe nélküli VAE, 17k+5 képkocka. Ahol a kapcsolók be vannak kapcsolva, a kimenetet bájtról bájtra összevetettük a kapcsolók nélküli videóval azokon a méreteken, ahol a kapcsolók nélküli futás elfér (`docs/YAMALAR.md`); 832x480 x 141 és 896x512 x 124 esetén a kapcsolók nélküli futás nem fér el, ezért ott az egyezés a legközelebbi cellákon alapul, nem közvetlen összehasonlításon [mért, elolvasva].
- A kétlépéses futás 1. lépése most azonnal véget ér, amint a látens fájl teljes (`VT_ERKEN_CIKIS=0` kikapcsolja).

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

## Mi ez
Kisméretű memória- és ütemezési patchek a stable-diffusion.cpp-hez, valamint a futtatási recept, ellenőrzések és mérések, amelyek lehetővé teszik, hogy a MiniMax H3 (33B DiT; mi a HyperFlow Flash 13.7B Q4_K_M GGUF-et futtatjuk; a 32B Qwen3-VL szövegkódoló külön van) egy 4 GB-os, Pascal generációs GPU-n fusson (GTX 1050 Ti, 16 GB rendszermemória).
- Egy menetben ténylegesen előállított, és a minőségi ellenőrzéseinken átment hosszak: 56, 141, 158, 175, 192, 209 képkocka 640x384-ben, 24 fps mellett (209 képkocka = 8.7 s), a H3 saját generált hangjával [mért: 209 képkocka a kiadási binárissal a `uret.ps1`-en keresztül, U209 futás; a latent bájtra azonos a fejlesztői build futásával; a képkockák és a hang a videóban azonosak, a fájl sha-ja a konténer miatt eltér; a bizonyítékokat a szerzők őrzik, ebben a tárolóban nincsenek]. A 209 a leghosszabb hossz, amelyet végignéztünk és simának találtunk [felhasználó jelentette, 2026-11-19, a videót végignézte; fájl: F209V2 kimenet, 8.708 s].
- **A bájtazonossági állítás, becsületesen körülhatárolva:** a patchek nélküli referenciával való bájtazonosságot csak 56 és 141 képkockára ellenőriztük. 158/175/192/209 képkockánál ugyanazokat a kapcsolókat és ugyanazt a binárisláncot használtuk; közvetlen bájtreferencia nincs (a patchek nélküli build ezeket a hosszakat ezen a GPU-n nem tudja futtatni).
- A minőségi beállításokat soha nem csökkentjük: ugyanaz a modell és kvantálás, 6 lépés, cfg 1, 640x384, ugyanaz a seed, csempézés nélküli VAE.
- Nem állítjuk, hogy mi vagyunk az elsők: kerestünk, és nem találtunk külső példát erre 4 GB-on, ami nem bizonyíték arra, hogy ilyen nincs.

## Felépítés
- `patches/` patchek a rögzített stable-diffusion.cpp commit ellen (lásd az ottani megjegyzéseket)
- `scripts/` fordítás, futtatás, külön folyamatú VAE, ellenőrző és konzisztencia-segédszkriptek (`doku_norm.py`: lásd az alábbi skálamegjegyzést)
- `docs/KURULUM.md` hardver, fordítás és futtatás lépései (EN+TR)
- `docs/YAMALAR.md` patchlista, `docs/KANITLAR.md` bizonyítékok, `docs/KAPILAR.md` minőségi ellenőrzések táblázata, `docs/OLCUMLER.md` mérések, `docs/SIK_HATALAR.md` gyakori hibák, `docs/LISANS_UYARISI.md` a licenc pontjainak teljes listája
- `scripts/` rövid tárgymutató: `hiz_kos3.ps1` futtató burkoló (a `-Kuru` kiírja a pontos parancsot), `uretim_kapi.ps1` minőségi ellenőrzés, `dikis_denetim.py` varratellenőrzés, `doku_norm.py` textúrára normált zaj, `bayt_kiyas.py` bájtösszehasonlítás, `derleme_sablonu.ps1` fordítási sablon (csak a Visual Studio telemetriai segédfolyamatát, a `vctip.exe`-t állítja le, amely a fordítás megkezdése után indult, és amely különben percekig a fordítási folyamathoz kötve marad; a többi `vctip.exe` folyamatot békén hagyja)

## Minőségi ellenőrzések (hogyan fogadunk el egy eredményt)

Ez az ellenőrzés nem vizsgálja a mozgás konzisztenciáját (a tárgyak méretének vagy helyzetének ugrásait): az elfogadás előtt nézd végig az egész videót.
1. A képkockák száma helyes és van hang; a naplóban nincs memória miatti tartalékmegoldás és nincs ALLOC_FAILED sor.
2. Nyers zajellenőrzés: a mediánszűrő maradéka <= 1.5 (0-255 skála).
3. Textúrára normált zaj, `scripts/doku_norm.py` (a tároló saját verziója): N = medián maradék / Sobel-textúra, minden 6. képkockán. **Skálamegjegyzés:** ebben a verzióban a 10 mért klip N = 0.034-0.052 értéket ad (táblázat a `docs/KAPILAR.md`-ben; az F192/F209V2 utolsó negyedében eléri a 0.062-t), a kiegészítő ellenőrzés küszöbe N <= 0.065. Egy másik implementáció ugyanezeken a klipeken 0.028-0.036-ot mért, ezért a küszöbök verziók között NEM cserélhetők. Nagyon finom textúráknál (fűsorok) a tiszta N 0.075 volt, így a küszöb jelenetcsaládonként értendő. Az ajánlott kiegészítő ellenőrzés egy robusztus nagyfrekvenciás becslő (sigma-HH <= 1.5; tiszta klipek 0.74-1.19, hozzáadott s=2 zajnál 2.2-3.0).

Hatókör: a VideoTurko EGYETLEN menetről szól (legfeljebb 209 képkocka, kb. 8,7 mp). Saját összefűzési tesztünk látható varratokat mutatott (a jelenet nem folytatódik tisztán), ezért a hosszabb filmek nem tartoznak az általunk ellenőrzött dolgok közé. Az összefűzéshez ott a közösségi útmutató, a `docs/KLIP_ZINCIRI.md`, és a csak CPU-t használó segédeszközünk, a `scripts/zincir.py` (`plan`, `son-kare`, `bagla`; sosem indítja a motort); az összefűzött filmek minőségét nem mértük [nem próbált], ezért minden varratot nézzen meg szemmel és a `scripts/dikis_denetim.py` segítségével.
A beállítások a tieid: a 209 képkocka a mi tesztelt alapértelmezésünk egy 4 GB-os kártyán, nem korlát, amelyet használnod kellene. Válassz tetszőleges képkockaszámot a 17k+5 rácsból (56, 73, ... 192, 209; lásd `docs/KURULUM.md`), változtasd a promptot, a seedet, a felbontást vagy bármely kapcsolót kedved szerint. A rövidebb klipek kevesebb memóriát és időt igényelnek; a nagyobb GPU-k többet is elbírhatnak.

## Figyelmeztetés a modell licencéről
**A VideoTurko csak patcheket és szkripteket tartalmaz (MIT); aki a modellt és a kimeneteit használja, maga felel a MiniMax licenc betartásáért.** Ez nem jogi tanács. Az alábbiakban a MiniMax H3 Community License (2026. augusztus 2.) kikötései szerepelnek összefoglalva, számozással; a licenc maga a kötelező érvényű: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

A tárhely MIT licence nem terjed ki a modellsúlyokra; lásd: [`NOTICE`](NOTICE). Ez a tároló NEM tartalmaz modellsúlyokat (sem MiniMax H3, sem HyperFlow-H3-Flash GGUF, sem VAE fájlokat). A projekt nem áll kapcsolatban a MiniMax-szal, és a MiniMax nem támogatja. A kereskedelmi felhasználás NEM tiltott (ez nem kizárólag nem kereskedelmi célú licenc); a feltételek alább olvashatók.

**Terület (Applicable Territory)**
- **Preambulum, I.3, I.5:** az egész világ, KIVÉVE az Európai Uniót, az Egyesült Királyságot, a Koreai Köztársaságot és az Egyesült Államokat. A modell használata a licenc elfogadásának minősül.
- **II:** díjmentes, át nem ruházható, korlátozott licenc használatra, sokszorosításra, terjesztésre, származékos művek készítésére és módosításra, kizárólag a területen belül, a megállapodással és az Exhibit A-val összhangban. A kizárt területeken élők külön licencet kérhetnek a MiniMax-tól.
- **V.4:** a modell, származékai ÉS KIMENETEI (generált videó/hang) használata, sokszorosítása, módosítása, terjesztése vagy megjelenítése a területen kívül nem engedélyezett. **Tehát a generált videók közzététele vagy bemutatása az EU-ban, az Egyesült Királyságban, Dél-Koreában és az USA-ban a licenc hatókörén kívül esik.**
- **Exhibit A-1:** a területen kívüli használat sérti az Acceptable Use Policy-t.

**Terjesztés (III)** (ez a tároló nem terjeszti a modellt; ha te igen)
- **III.1:** adj minden átvevőnek egy másolatot a licencről. **III.2:** jelöld a módosított fájlokat feltűnő közleményekkel.
- **III.3:** Ajánlott (nem kötelező): "Powered by MiniMax H3" közlemény, MI-generálásra utaló azonosító az elkészített fájlokon, nyilvános ismertető.
- **III.4:** a terjesztést KÖTELEZŐEN kísérnie kell egy NOTICE fájlnak ezzel a szöveggel: "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12:** tilos tartalmat bármely nyilvános környezetben közzétenni anélkül, hogy egyértelműen jeleznéd, hogy gépi generálású: a közzétett MI-generált videókat jelöld meg (teljes lista: `docs/LISANS_UYARISI.md`).
- **III (utolsó bekezdés):** a módosításaidhoz hozzáadhatod saját szerzői jogodat, de nem szabhatsz további vagy eltérő feltételeket a használatra és terjesztésre; a területi szabályok továbbra is érvényesek.

**Kereskedelmi feltételek (IV)**
- **IV.1:** ha kereskedelmi termékeid vagy szolgáltatásaid évi 20 millió USD-nél (vagy ennek megfelelő összegnél) nagyobb bevételt generálnak, ELŐZETES írásbeli engedélyt kell kérned az api@minimax.io címen (tárgy: "MiniMax H3 licensing - authorization request").
- **IV.2:** a modellt használó kereskedelmi termék vagy szolgáltatás felületén feltűnően szerepelnie kell a "MiniMax H3" feliratnak.

**Használati korlátozások (V)**
- **V.1:** tartsd be a hatályos jogot (beleértve a kereskedelmi megfelelőséget) és az Exhibit A-t. **V.2:** mindenkit, akinek hozzáférést adsz, köss olyan feltételekhez, amelyek legalább ennyire védőek, mint ezek a korlátozások, és értesítsd őket.
- **V.3:** a modellt vagy a KIMENETEIT nem használhatod semmilyen más MI-modell javítására (a MiniMax H3-on és származékain kívül). (I.11: a desztilláció és a szintetikus kimeneteken való tanítás „származékká” teszi a modellt; maguk a kimenetek nem származékok.)
- **V.5:** ha harmadik feleknek olyan terméket, szolgáltatást vagy üzemeltetett szolgáltatást kínálsz, amely a modellel kimeneteket generál: a működés előtt és során észszerű technikai és szervezési biztosítékok, bejelentési mechanizmus, haladéktalan kivizsgálás, valamint az ismétlődő jogsértők eltávolítása, letiltása vagy felfüggesztése szükséges.

**Védjegyek és jogok (VI)**
- **VI.1:** az általad készített származékos művek és modellszármazékok a tiéid (a MiniMax jogainak fenntartásával). **VI.2:** a MiniMax nevei és védjegyei nem tartoznak a licenc alá (a leíráshoz és terjesztéshez szükségesen túl); a "MiniMax H3" védjegy kizárólag a III.3 teljesítéséhez, a területen belül használható; ne sugalmazz kapcsolatot.
- **VI.3:** ha beperled a MiniMax-ot vagy bárkit azzal, hogy az anyagok vagy kimenetek sértik a jogaidat, minden licenced aznap megszűnik; megvéded és kármentesíted a MiniMax-ot a te vagy mások használatából és terjesztéséből eredő harmadik felek követelései ellen.
- **VI.4:** a MiniMax nem tart igényt a kimenetekre; te és a felhasználóid felelősek a kimenetekért és azok használatáért.

**Felelősségkizárás és megszűnés (VII, VIII, IX)**
- **VII.1:** nincs támogatási vagy frissítési kötelezettség. **VII.2:** a modellt és a kimeneteket "AS IS" módon, garancia nélkül adják; az alkalmasságról te döntesz, a kockázatot te viseled. **VII.3:** a MiniMax és kapcsolt vállalkozásai nem felelnek semmilyen kárért (a jog által megengedett mértékig).
- **VIII.1:** az elfogadással vagy a hozzáféréssel lép hatályba. **VIII.2:** szerződésszegés esetén a MiniMax megszüntetheti a licencet; abba kell hagynod a használatot és terjesztést, törölnöd kell a másolatokat és értesítened az átvevőket (a VI.1, VI.3, VII, IX érvényben marad).
- **IX:** Hongkong KKT joga; a hongkongi bíróságok kizárólagos illetékessége (az ENSZ CISG egyezménye kizárva).
- **Kiegészítő megjegyzés:** a MiniMax H3 kódolója a Qwen3-VL-32B-t használja (Apache 2.0).

**Elfogadható használati szabályzat (Exhibit A)** (a modellt, a származékokat és a kimeneteket NE használd erre)
- A-1 használat a területen kívül; A-2 jogszabályok vagy harmadik felek szellemi tulajdonának megsértése; A-3 önmagad vagy mások károsítása; A-4 a kimenetek kárt okozó célra való átalakítása vagy terjesztése; A-5 a biztosítékok megkerülése; A-6 kiskorúak kihasználása vagy károsítása; A-7 igazolhatóan hamis információ mások károsítására vagy választások befolyásolására; A-8 hamis online aktivitás (hamis értékelések stb.); A-9 rágalmazás, lejáratás, zaklatás; A-10 kártevő; A-11 személyes adatok mások károsítására; **A-12 tartalom közzététele bármely nyilvános környezetben (beleértve a botbejegyzéseket) anélkül, hogy egyértelműen és feltűnően jeleznéd, hogy gépi generálású**; A-13 megszemélyesítés beleegyezés nélkül; A-14 nagy kockázatú automatizált döntések kritikus területeken (bűnüldözés, bevándorlás, egészségügy, kritikus infrastruktúra, hitel, foglalkoztatás, lakhatás, oktatás, társadalmi pontozás, biztosítás stb.); A-15 más országok/régiók társadalmi, etikai, erkölcsi normáinak megsértése; A-16 erőszakos szélsőségesség/terrorizmus; A-17 védett tulajdonságok alapján történő megkülönböztetés vagy károsítás; A-18 kiszolgáltatott csoportok kihasználása; **A-19 katonai célok**; A-20 jogosulatlan vagy engedély nélküli szakmai tevékenység (pénzügyi, jogi, orvosi stb.).
- Megjegyzés: ez közérthető összefoglaló; kétség esetén a licenc angol szövege az irányadó.

## Bizonyítéki címkék

Egy készlet minden dokumentumhoz (a régebbi írásmódok zárójelben):
- **[mért]** (TR: ölçtüm, olctum): ebben a projektben lefuttatva, a bizonyíték útvonala létezik.
- **[elolvasva]** (TR: okudum yol, okudum): a forrást vagy szkriptet elolvastuk, de nem futtattuk.
- **[tervezett]** (TR: tasarım, tasarim): megtervezve, valódi futásban még nem láttuk.
- **[feltételezés]** (TR: tahmin): nem ellenőrzött.
- **[nem próbált]** (TR: denenmedi): soha nem futtatott.
- **[felhasználó jelentette]** (TR: kullanıcı bildirdi): a felhasználó közölte, dátummal; függetlenül nem mérve.
- **[számított]** (TR: hesap; régebbi írásmódok: calculated, hesap): mért bemenetekből levezetett szám, maga nem mért; a levezetés mellette áll. [proposal] / [öneri] a régebbi szövegben = [feltételezés].

A szögletes zárójelben használt futásnevek (saját elnevezéseink, nem a tároló fájljai): U209 = 209 képkocka a kiadási binárissal a `uret.ps1`-en keresztül; B209 és B192 = „kép videóvá” (`-InitImg`) futások 209 és 192 képkockán; B56VT2 = kiadási bináris, 56 képkocka, összevetve az 56 képkockás R0 bájtreferenciával; F209b, F209V2, F209V2K = 209 képkockás futások a fejlesztői buildön (részletek: `docs/OLCUMLER.md`).

## Ismert korlátok
- **Bájtbizonyíték** (hogyan reprodukálhatod magad: `docs/KANITLAR.md`, „R0 ve latent referansi nasil uretilir”; a mi sm_61 kártyánkon ellenőrizve, más GPU-kon előfordulhat, hogy nem bájtazonos [feltételezés]): a patchsorozatunkkal (memóriakapcsolók bekapcsolva) egy 56 képkockás futás sha256-ja `0979f156d548169b...` volt, azonos a referenciával [mért]; 141 képkockánál a latent sha256-ja `E5D028F8632BE4FE...` azonos volt (a 0013/0014 kapcsolókkal). A 158-tól 209 képkockáig nincs közvetlen bájtreferencia; a bizonyíték az ellenőrzési lánc. A számszerű ellenőrzések teljesítése nem garantál jó klipet: a mozgás időbeli konzisztenciáját szemmel ellenőrizzük (lásd `docs/KAPILAR.md`).
- **209 képkocka, melyik kapcsolókészlet:** a 209 képkockás bájtlánc bizonyítékát az F209V2 kapcsolókészlettel vettük fel a fejlesztői buildön (blokkvég-kapcsolók nélkül, a 0019/0020 patchek nélkül fordítva); a `uret.ps1` ezt a receptet használja 209 képkockához [elolvasva: a szkript; a valódi motorfutás a `uret.ps1`-en keresztül átment az U209 futásban].
- Általunk egy kártyán ellenőrizve (GTX 1050 Ti 4 GB); a más kártyákról szóló külső beszámolók címkéikkel a `docs/KART_PROFILLERI.md` fájlban szerepelnek [felhasználó jelentette].
- **Melyik binárist mértük:** a 141 képkockás latentet és a bájtláncot a saját fejlesztői buildjeinken mértük. A letöltött kiadási bináris új fordítás: az 56 képkockás bájtellenőrzése átment (következő pont), a 209 képkockás futás a `uret.ps1`-en keresztül átment az ellenőrzésen (U209 futás, 3414 s, VRAM-csúcs 3777 MiB) [mért]; a fejlesztői build 209 képkockás futásához képest a latent bájtra azonos; a videóban a képkockák (md5) és a hang azonosak, az AVI fájl sha256-ja a konténer miatt eltér [mért] (lásd `docs/OLCUMLER.md`, 0. szakasz).
- **Kiadási bináris, 56 képkocka:** a kiadási bináris (sd-cli `c5cebe78...`, stable-diffusion.dll `e5d3d329...`) az R0-val bájtra azonos 56 képkockás eredményt adott (sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`; képkockánkénti md5 és a hang azonos), közvetlenül, alapértelmezett kapcsolókkal futtatva (`SD_*` változók nélkül), kilépési kód 0, 601 s [mért: B56VT2 futás, 2026-11-19; a bizonyítékokat a szerzők őrzik, ebben a tárolóban nincsenek]. Hatókör: csak a mi sm_61 kártyánk és 56 képkocka; nem tiszta mappás telepítési teszt; a 141 képkockás latentet és a 209-es láncot a régebbi binárissal mértük, és ezzel NEM ismételtük meg [nem próbált]. Az első kísérlet (B56VT, segédszkripten keresztül) 58 s után némán véget ért, az ok ismeretlen [feltételezés: memóriaszűkület]; a második kísérlet közvetlenül az `sd-cli`-t futtatta.
- A telepítő és futtató szkripteket még nem ellenőriztük üres mappából (a tiszta mappás teszt hátravan).
- Útiterv és következő lépések: `ROADMAP.md`.

## Állapot és korlátok
- Egy gépen ellenőrizve (GTX 1050 Ti 4 GB, 16 GB RAM, i7-7700HQ). Más 4 GB-os kártyák és más RAM-méretek eltérően viselkedhetnek.
- **Alapértelmezés: 209 képkocka (8.7 s):** átment a minőségi ellenőrzéseinken (zaj 1.08, F209V2K futás) [mért: 209 képkocka a kiadási binárissal a `uret.ps1`-en keresztül, U209 futás; a latent bájtra azonos a fejlesztői build futásával; a képkockák és a hang a videóban azonosak, a fájl sha-ja a konténer miatt eltér; a bizonyítékokat a szerzők őrzik, ebben a tárolóban nincsenek]. 209 képkockánál a DiT VRAM-csúcsa 3777 MiB volt a 4096 MiB-ból (F209b és U209 futás; a teljes kártyára vonatkozó `nvidia-smi` leolvasás), kicsi a tartalék: más GPU-terhelés (a kijelző, egyéb alkalmazások) hibát okozhat a `blocks.0`-nál; csak GTX 1050 Ti-n tesztelve. A kijelző állapotát a futás alatt nem jegyeztük fel; ha a kijelződ ezen a kártyán fut, kevesebb VRAM áll rendelkezésre [feltételezés: kb. 100-300 MB-nyi Windows-kijelzőterhelés]; szükség esetén csatlakoztasd a kijelzőt az integrált grafikához [tanács, nem tesztelt]. A mintavételezés (sampling) 2730 s-ig tartott (U209 futás: 436-483 s-os lépések), a külön folyamatú VAE-dekódolás 173 s (a 2. szakasz összesen 193 s a hangdekódolással) [mért: U209 kiadási bináris; régebbi fejlesztői futások: 2664 s és 174 s]. Az 1. szakaszban a folyamaton belüli VAE kifogyott a memóriából, és időbeli csempézésre váltott (320 s); ez a kimenet el van vetve, a videó a csempézés nélküli 2. szakaszból származik. A RAM-csúcsot az U209 futásban nem mértük. A 209 képkockánál hosszabb klipek nem részei ennek a kiadásnak.
- **Kép videóvá (`-InitImg`):** kezdőképpel a plafon 192 képkocka (8.0 s 24 fps mellett) ezen a GPU-n: a 209 képkocka nem fért el (a 0. blokknál kb. 17.5 MB VRAM hiányzott: 2587 MB kellett, 2570 MB állt rendelkezésre); a 192 képkocka 3086 s alatt lefutott a `uret.ps1`-en keresztül 3783 MiB VRAM-csúccsal, az ellenőrzés átment [mért: B209 és B192 futás, 2026-11-20, egy jelenet; a bizonyítékokat a szerzők őrzik, ebben a tárolóban nincsenek]. Más GPU-kon nem próbáltuk [nem próbált].
- **A szabad RAM számít:** kb. 11 GB SZABAD RAM kell (a motorfolyamat kb. 11 GB-ot tart) [mért]. Túl kevés szabad RAM mellett a folyamat hibaüzenet nélkül meghalhat [feltételezés: egyszer láttuk kb. 300 MB szabad RAM mellett, amikor az `sd-cli` kb. 10 GB-ot tartott]. Futás közben ne nyiss meg más nagy programokat: egy 16 GB-os gépen csak kb. 0.3-0.5 GB marad szabadon, és memóriaszűkében a futás némán elhalhat. Indítás előtt zárd be a böngészőket, játékokat és más nagy programokat, és ellenőrizd a szabad RAM-ot.
- **A tiszta mappás teszt hátravan:** a telepítő és futtató szkripteket még nem ellenőriztük üres mappából kizárólag ezen útmutató alapján; ezt a szakaszt frissítjük, amikor a teszt (köztük az 56 képkockás bájtösszehasonlítás a referenciával) rögzítésre kerül.
- Generált videókat itt nem mellékelünk.

<!-- i18n-source: README.md sha256:67497404d89b -->
