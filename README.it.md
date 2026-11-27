# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · Italiano · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

Le traduzioni seguono questo README in inglese. Se una traduzione differisce o è in ritardo, fa fede il testo inglese, soprattutto per il testo su licenza e sicurezza ([`SECURITY.md`](SECURITY.md) e [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) sono mantenuti solo in inglese e turco).

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **Prima di iniziare (licenza, territorio):** questo repository è MIT e contiene solo patch e script. Il modello MiniMax H3 che scarica è sotto la MiniMax H3 Community License: il suo territorio esclude l’Unione Europea, il Regno Unito, la Corea del Sud e gli Stati Uniti, e il modello, i derivati **e gli output (i video che generi)** non possono essere usati, distribuiti o mostrati lì (V.4). L’uso commerciale è consentito entro i termini della licenza. Leggi [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) prima di installare; questo non è un parere legale.

> **In 30 secondi:** una scheda video da 4 GB può generare un video MiniMax H3 da 209 fotogrammi (8,7 s) in un solo passaggio: verificato su una sola macchina (GTX 1050 Ti da 4 GB; l'installazione completa con `kur.ps1` in una cartella vuota non è ancora stata verificata da un capo all'altro) [misurato: 209 fotogrammi con il binario della versione pubblicata tramite `uret.ps1`, esecuzione U209; latente identico byte per byte a quello dell'esecuzione con il binario di sviluppo; fotogrammi e audio identici nel video, lo sha del file differisce a causa del contenitore; le prove sono conservate dagli autori, non sono in questo repository]; con `-InitImg` (da immagine a video) al massimo 192 fotogrammi (8,0 s) [misurato: esecuzione B192]; 209 fotogrammi richiedono circa 57 min, il limite di tempo predefinito è di 80 min [misurato: esecuzione U209]; i 3 passaggi qui sotto spiegano come eseguirlo.

> **Usa un agente di programmazione IA (Codex, Claude Code, Gemini, Cursor)?** Gli dia questa sola frase: «Leggi `AGENTS_HIZLI.md` fino in fondo, esegui prima `scripts\tani.ps1`, tieni traccia dei progressi in `DURUM.md` e chiedimi prima di eliminare o spostare qualcosa, cambiare il Python di sistema o il PATH, abbassare un'impostazione di qualità o accettare la licenza del modello al posto mio.» L'agente diagnosticherà questo PC, scriverà una lista di controllo e le chiederà conferma a ogni decisione; la licenza del modello resta una sua decisione.

VideoTurko: patch di memoria per stable-diffusion.cpp e ricette per eseguire MiniMax H3 da testo a video su una GTX 1050 Ti da 4 GB, fino a 209 fotogrammi (8,7 s) in un solo passaggio; da immagine a video (`-InitImg`) fino a 192 fotogrammi (8,0 s) (209 fotogrammi verificati con una catena di byte; identico byte per byte all'esecuzione senza patch nei controlli a 56 e 141 fotogrammi).

## Avvio rapido (Windows, 3 passaggi)
**Stato: gli script di installazione ed esecuzione qui sotto sono in via di completamento e il test in radice pulita è in sospeso; nulla di quanto segue è dato per funzionante finché quel test non è superato (vedi "Stato e limiti").**

1. **Scarica** questo repository (pulsante verde **Code**, poi **Download ZIP**) ed estrailo in una cartella CORTA, per esempio `C:\vt`.
2. **Installa: fai doppio clic su `kur.cmd`** (si apre una finestra nera che mostra ogni passo; chiuderla interrompe l’installazione, rieseguirla riprende da dove si era fermata: un file di modello scaricato a metà viene ripreso [letto: lo script di download conserva un file `.part` e riparte da esso; una ripresa completa da 29 GiB non è stata misurata]). Se Windows avvisa sul file scaricato, usa invece il comando PowerShell qui sotto [consiglio, non provato su uno ZIP scaricato]. Preferisci la riga di comando? Apri PowerShell in quella cartella (scrivi `powershell` nella barra degli indirizzi di Esplora file) ed esegui la stessa installazione:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   La radice di installazione è la cartella che hai estratto (il motore va in `engine\bin`, i modelli in `model`); per usare un altro percorso imposta prima la variabile d'ambiente `VT_ROOT`. Lo script controlla GPU, driver, RAM e disco, scarica il motore e i modelli (gli zip del motore e i file di modello appena scaricati sono verificati con sha256; un file di modello già presente con la dimensione giusta è verificato solo per dimensione, `scripts\modelleri_indir.ps1 -Dogrula` esegue la verifica sha256 completa), esegue un breve controllo reale e stampa READY solo se quel controllo è andato a buon fine [progettato: `kur.ps1` non è stato eseguito per intero in una cartella pulita; questa frase verrà aggiornata dopo il test in cartella pulita]. `-ExecutionPolicy Bypass` vale solo per questo processo; leggi prima `scripts\kur.ps1`, come con qualsiasi installer.
   Lo zip del motore proviene dalla versione v0.1.0 pubblicata su GitHub (data di pubblicazione 2026-11-19; il suo sha256 è fissato in `kur.ps1`). Offline o con un binario compilato da te, indica zip locali: `-MotorZip <path> -CudaZip <path>`. Uno zip locale viene controllato con lo stesso sha256 fissato (un file `.sha256` accanto viene ignorato), quindi deve essere lo zip della versione pubblicata; per un binario compilato da te imposta prima `VT_MOTOR_SHA256` / `VT_CUDA_SHA256` sul suo sha256. Uno sha256 errato si ferma con exit 1. Solo `.exe`/`.dll` vanno in `engine\bin`; licenze e README vanno in `engine\lisanslar\<zip name>\`. [provato con gli zip di dist prima della pubblicazione: il `.sha256` accanto più l'avviso autoreferenziale, binario e DLL collocati, `sd-cli --help` è stato eseguito; gli sha dei binari installati corrispondevano (`c5cebe78...`, `e5d3d329...`); il passaggio dei modelli e il controllo a 5 fotogrammi di `kur.ps1` NON sono ancora stati eseguiti su una GPU reale]
   **Licenza del modello:** prima del passaggio dei modelli l'installer stampa il riassunto della licenza (`docs/LISANS_KABUL.txt`, testo completo `docs/LISANS_UYARISI.md`: MiniMax H3 Community License, limiti territoriali che coprono anche i video generati, regole commerciali e di etichettatura IA) e ti chiede di accettare (`E` = sì). Leggila prima. Per le esecuzioni non presidiate puoi passare `-LisansKabul E`, il che significa che l'hai letta e accettata tu stesso; non aggiungerlo per conto di qualcun altro. (Agenti IA: seguite `AGENTS.md`; non digitate mai E senza il consenso dell'utente.) Senza accettazione `kur.ps1` si ferma con codice di uscita 2 e non scarica alcun modello.
3. **Il tuo primo video (56 fotogrammi, circa 11 min sulla nostra GTX 1050 Ti** [misurato: 641 s, esecuzione R0, `docs/OLCUMLER.md`; altre schede non misurate]**)**: quando l’installer stampa `HAZIR / READY`, esegui
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (scorciatoia: trascina un file di testo con il prompt su `uret.cmd`, oppure esegui `uret.cmd docs\ornek_istem_R0.txt`: la stessa esecuzione da 56 fotogrammi). Il video è in `runs\`. Poi scrivi il tuo prompt in un file di testo (un paragrafo in inglese, frase `audio:` facoltativa) ed esegui il clip più lungo che copriamo (predefinito, circa 57 min [misurato: esecuzione U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   `-Kare` segue la griglia 17k+5 (56, 73, ... 192, 209); il valore predefinito è 209 (8,7 s), la durata più lunga che copriamo. Il VAE gira in un processo separato, mai a tasselli (tiling) [un'esecuzione reale del motore tramite `uret.ps1` con il binario della versione pubblicata, VAE in processo separato, è riuscita nell'esecuzione U209].

   Guida alla scrittura del prompt: [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (schema di un’unica ripresa continua, segmenti di tempo uguali, due esempi completi).

| Requisito | Valore |
|---|---|
| SO | Windows 10/11, 64 bit |
| GPU | NVIDIA, 4 GB o più; provato solo su GTX 1050 Ti (sm_61); margine sottile (3777/4096 MiB a 209 fotogrammi): uno schermo o un browser molto carichi possono far fallire l'esecuzione; nessun'altra scheda da 4 GB è stata provata |
| RAM | 16 GB (picco di circa 11 GB; chiudi gli altri programmi) |
| Disco | almeno 32 GiB liberi (consigliati 40 GiB o più: tra 32 e 40 l’installer stampa un avviso, `[VT-W-DISK-PAY]` [misurato: esecuzioni di `-Kuru` con disco simulato]), modelli su SSD (meglio NVMe) |
| Download | zip del motore 36,8 MB + zip del runtime CUDA 567,5 MB [misurato] + modelli 31.473.112.040 byte (circa 29,3 GiB) [letto: dimensioni in `scripts/modeller.json`]; circa 30 GiB in totale |
| Modelli | non inclusi; li scarica l'installer sotto la licenza MiniMax (vedi l'avviso qui sotto). I modelli (29,3 GiB, 31.473.112.040 byte in `scripts/modeller.json`) non sono in questo repository né nella versione pubblicata: valgono i limiti di dimensione di file e release di GitHub, e `kur.ps1` li scarica dalla fonte ufficiale con verifica sha256. |

Codici di uscita di `kur.ps1`: 0 READY, 1 errore, 2 serve un intervento dell'utente (licenza, oppure ancora nessuna versione/zip), 3 hardware o disco insufficienti, 4 interrotto (file DUR). `uret.ps1` accetta un'esecuzione solo se il file `.avi` esiste, il numero di fotogrammi è corretto e i log sono puliti [misurato: un'esecuzione reale tramite `uret.ps1` sul binario della versione pubblicata, esecuzione U209, 209 fotogrammi, controllo superato]. Codici di uscita di `uret.ps1`: 0 DONE (controllo di qualità superato), 1 errore o output non valido (compreso un video senza traccia audio), 2 interrotto (file DUR), 5 `KAPI RED` (controllo di qualità non superato: la clip non è accettata, la decisione spetta a te), 6 il controllo non è potuto partire (clip non accettata). Dettagli in AGENTS.md. [misurato: codici di uscita 0, 1 (video muto), 5 e 6 in scenari con un motore finto e un controllo finto; motore reale: exit 0 nell'esecuzione U209]

### Risoluzione dei problemi (dettagli: `docs/SIK_HATALAR.md`)
Le righe di errore dei nostri script portano un codice stabile, per esempio `HATA: [VT-E-DLL] ...` o `UYARI: [VT-W-DISK-PAY] ...`. Cerca il codice in [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) (esempio di ancora `#vt-e-dll`) o in `docs/hata_imzalari.json` e scrivi il codice nella tua issue. La prima colonna della tabella qui sotto resta com’è stampata (non tradurre codici né testo dei log).

| Cosa vedi | Cosa significa, cosa fare |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | Non avviare `sd-cli.exe` a mano; esegui `scripts\kur.ps1`, che mette al loro posto le DLL CUDA. |
| `failed during weight preparation` a `blocks.0` (#1, #3, #5) | VRAM insufficiente al controllo della memoria: usa meno fotogrammi sulla griglia 17k+5, chiudi gli altri programmi che usano la GPU e mantieni le opzioni fornite. |
| `retrying with temporal tiling` (#6) | Il VAE è ripiegato sul tiling; l'output non è valido ai fini della qualità. Esegui di nuovo. |
| L'esecuzione termina al limite di tempo, nessun video (#7) | Aumenta `-TavanDk` per le clip lunghe (limite di tempo predefinito: 80 min per 209 fotogrammi, impostato da `uret.ps1`; la nostra esecuzione a 209 fotogrammi ha richiesto 57 min [misurato: esecuzione U209]). |
| Codice di uscita vuoto ma "terminato" (#14) | Il wrapper ha letto il codice di uscita troppo presto; esegui di nuovo e controlla che il file video esista. |
| Il sistema rallenta, usa lo swap (#18) | Il motore usa circa 10-11 GB di RAM; chiudi browser e altri programmi. |
| sha256 diverso / download non riuscito | Di solito un download interrotto: esegui di nuovo lo stesso comando, i file già verificati vengono saltati. |

**Bloccato o curioso?** [`SUPPORT.md`](SUPPORT.md) (dove chiedere; i tempi di risposta sono obiettivi, non impegni) · [`PRIVACY.md`](PRIVACY.md) (nessuna telemetria; la rete serve solo a scaricare il motore e i modelli dagli host elencati) · [`SECURITY.md`](SECURITY.md) (segnalazione privata) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (primo pull request in 5 passi; per documenti e script non serve la GPU).

### Novità della v0.1.1: più opzioni (dettagli: `AGENTS.md`, `docs/SIK_HATALAR.md` 19-23)
Senza queste opzioni non cambia nulla su una scheda da 4 GB (il controllo byte per byte a 56 fotogrammi rispetto al nostro riferimento è stato superato di nuovo con la v0.1.1 [misurato]). Aggiungi `-Kuru` a qualsiasi comando per vedere cosa verrebbe eseguito.
- `-EndImg`: fornisci anche l'ultimo fotogramma (primo e ultimo fotogramma, "FLF"); limite di 175 fotogrammi sulle schede sotto gli 8 GB (192 non ci stava su 4 GB), 192 sulle schede da 8 GB in su. Sulla nostra GTX 1050 Ti gira sempre in due processi: 56 fotogrammi 1040 s, 175 fotogrammi 2887 s (48 min), entrambi hanno superato il controllo [misurato]. Consigli per il prompt: `docs/ISTEM_YAZIMI.md`.
- `-W` / `-H`: altre dimensioni, per esempio verticale 384x640; multipli di 32, area di almeno 640x384 (mai più piccola). Non provato su 4 GB; sulle schede sotto gli 8 GB vengono rifiutate le dimensioni che superano la nostra esecuzione misurata più grande. Le soglie del controllo di qualità sono calibrate su 640x384.
- `-TekAsama`: un solo processo invece di due, solo per schede grandi; non si attiva mai automaticamente.
- GPU più recenti (compute capability 7.0+, per esempio RTX 20/30/40): `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` viene impostata automaticamente se non l'hai già impostata tu; questo ha risolto un video completamente nero da 141 fotogrammi in su sulla RTX 4070 Ti di chi l'ha segnalato [segnalato dall'utente, issue #1]. Senza Python + OpenCV, `uret.ps1` ora si ferma con exit 6 prima del lavoro sulla GPU (nessun video prodotto, nessun RED fuorviante).
- Grazie a @SinanC73 per la segnalazione sulla RTX 4070 Ti che ha portato a queste modifiche ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1)).

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

## Profili di velocità opzionali (pacchetto velocità; disattivati di default)
Nulla di quanto segue cambia l’esecuzione predefinita (640x384, 209 fotogrammi, 3414 s sulla nostra scheda). Sono tre celle misurate oltre di essa, ciascuna un profilo con nome di `uret.ps1`; richiedono il motore del pacchetto velocità (il motore della release più le patch 0021, 0023 e 0024, tutte disattivate di default: `docs/YAMALAR.md`). Si installa con `scripts\kur.ps1 -HizPaketi` (uno zip locale funziona con `-MotorZip`), poi si aggiunge `-Profil <name>`; `-Kuru` mostra cosa verrebbe eseguito. Il pacchetto velocità viene pubblicato con la versione v0.1.4.

| Profilo | Dimensione, durata | Tempo totale su una GTX 1050 Ti 4 GB | Stato |
|---|---|---|---|
| (nessuno, predefinito) | 640x384, fino a 209 fotogrammi (8,7 s) | 209 fotogrammi: 3414 s | verificato, invariato |
| `yuksek832` | 832x480, 141 fotogrammi (5,9 s) | circa 55-56 min | utilizzabile, due prompt [misurato] |
| `yuksek832 -Kare 124` | 832x480, 124 fotogrammi (5,2 s) | circa 45-46 min, nessun flag di velocità necessario | utilizzabile, due prompt [misurato] |
| `yuksek896` | 896x512, 124 fotogrammi (5,2 s) | circa 56-57,5 min | utilizzabile, due prompt [misurato] |
| `uzun260` | 640x384, 260 fotogrammi (10,8 s) | circa 71 min [misurato: 70,7 min da capo a fondo tramite `uret.ps1`, con l’uscita anticipata; 78 min senza] | funziona vicino al limite di memoria; prompt misurato fino a circa 2000 caratteri |

- **Margine stretto:** a 832x480 x 141 la porta di memoria lascia un margine di una sola cifra in MB (5,7 e 6,8 MB nelle due esecuzioni complete). Due prompt lunghi (1520 e 2041 caratteri) sono stati controllati solo leggendo la porta per il passo 1 e parte del passo 2, senza esecuzione completa: margine di 10,9 e 4,0 MB. Qualsiasi altro processo che occupi la memoria della scheda (browser, secondo schermo) può farla fallire; in tal caso usare `-Kare 124` o la dimensione predefinita [misurato, GTX 1050 Ti 4 GB].
- **`uzun260` funziona vicino al limite di memoria:** picco di VRAM 3861-3903 su 4096 MiB. Tre esecuzioni complete (due scene); l’uso di memoria condivisa è aumentato da 28 a 61 MiB contro un limite di 68 MiB. I prompt sono stati misurati fino a 1403 caratteri nelle esecuzioni complete e fino a 2009 caratteri con la lettura del gate; a 2527 caratteri il limite della memoria condivisa è stato superato. Non esiste un riferimento senza flag per l’uguaglianza byte per byte a questa lunghezza. Chiuda gli altri programmi che usano la GPU; se un’esecuzione fallisce, usi i 209 fotogrammi predefiniti. La patch 0023 è accettata solo per questa cella.
- **Non offerto:** 832x480 a 158 fotogrammi non ci sta con le patch fornite (al cancello del passo 2 mancano circa 280 MB); 175 fotogrammi è stato esaminato solo leggendo il cancello (nel primo blocco mancavano circa 275 MB, nessuna esecuzione completa). Il profilo offre solo 141 fotogrammi. Altre dimensioni e numeri di fotogrammi sono rifiutati da `-Profil` (usare il percorso predefinito).
- La qualità predefinita è intatta: 6 passi, cfg 1, VAE senza tile, 17k+5 fotogrammi. Dove i flag sono attivi, l’output è stato confrontato byte per byte con il video senza flag alle dimensioni in cui l’esecuzione senza flag ci sta (`docs/YAMALAR.md`); a 832x480 x 141 e 896x512 x 124 l’esecuzione senza flag non ci sta, quindi lì l’uguaglianza poggia sulle celle più vicine, non su un confronto diretto [misurato, letto].
- La fase 1 di un’esecuzione in due fasi ora termina appena il file latente è completo (`VT_ERKEN_CIKIS=0` lo disattiva).

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

## Di cosa si tratta
Un insieme di piccole patch di memoria e di pianificazione per stable-diffusion.cpp, più la ricetta di esecuzione, i controlli e le misure che permettono di eseguire MiniMax H3 (DiT da 33B; usiamo il GGUF HyperFlow Flash 13.7B Q4_K_M; l'encoder di testo Qwen3-VL da 32B è separato) su una GPU Pascal da 4 GB (GTX 1050 Ti, 16 GB di RAM di sistema).
- Durate in un solo passaggio che abbiamo effettivamente prodotto e che hanno superato i nostri controlli di qualità: 56, 141, 158, 175, 192, 209 fotogrammi a 640x384, 24 fps (209 fotogrammi = 8,7 s), con l'audio generato da H3 stesso [misurato: 209 fotogrammi con il binario della versione pubblicata tramite `uret.ps1`, esecuzione U209; latente identico byte per byte a quello dell'esecuzione con il binario di sviluppo; fotogrammi e audio identici nel video, lo sha del file differisce a causa del contenitore; le prove sono conservate dagli autori, non sono in questo repository]. 209 è la durata più lunga che abbiamo guardato e trovato fluida [segnalato dall'utente, 2026-11-19, video guardato per intero; file: output di F209V2, 8,708 s].
- **Affermazione di identità byte per byte, con il suo reale ambito:** gli output sono stati verificati identici byte per byte al riferimento senza patch solo a 56 e 141 fotogrammi. A 158/175/192/209 fotogrammi abbiamo usato le stesse opzioni e la stessa catena di binari; non esiste un riferimento diretto byte per byte (la versione senza patch non riesce a eseguire quelle durate su questa GPU).
- Le impostazioni di qualità non vengono mai abbassate: stesso modello/quantizzazione, 6 passi, cfg 1, 640x384, stesso seed, VAE senza tiling.
- Non affermiamo di essere i primi: abbiamo cercato e non abbiamo trovato alcun esempio esterno di questo su 4 GB, il che non prova che non ne esistano.

## Struttura
- `patches/` patch su un commit fissato di stable-diffusion.cpp (vedi le note lì)
- `scripts/` compilazione, esecuzione, VAE in processo separato, strumenti di controllo/coerenza (`doku_norm.py`: vedi la nota sulla scala qui sotto)
- `docs/KURULUM.md` hardware, passaggi di compilazione ed esecuzione (EN+TR)
- `docs/YAMALAR.md` elenco delle patch, `docs/KANITLAR.md` prove, `docs/KAPILAR.md` tabella dei controlli di qualità, `docs/OLCUMLER.md` misure, `docs/SIK_HATALAR.md` errori comuni, `docs/LISANS_UYARISI.md` tutti i punti della licenza
- `scripts/` indice breve: `hiz_kos3.ps1` wrapper di esecuzione (`-Kuru` stampa il comando esatto), `uretim_kapi.ps1` controllo di qualità, `dikis_denetim.py` verifica delle giunzioni, `doku_norm.py` rumore normalizzato sulla texture, `bayt_kiyas.py` confronto byte per byte, `derleme_sablonu.ps1` modello di compilazione (ferma soltanto l'helper di telemetria di Visual Studio `vctip.exe` avviato dopo la propria compilazione, che altrimenti tiene agganciato il processo di compilazione per minuti; gli altri processi `vctip.exe` vengono lasciati in pace)

## Controlli di qualità (come si accetta un risultato)

Questo controllo non verifica la coerenza del movimento (salti di scala o di posizione degli oggetti): guarda tutto il video prima di accettarlo.
1. Numero di fotogrammi e audio presente; nessun ripiego sulla memoria né righe ALLOC_FAILED nel log.
2. Controllo del rumore grezzo: residuo del filtro mediano <= 1,5 (scala 0-255).
3. Rumore normalizzato sulla texture, `scripts/doku_norm.py` (la versione di questo repository): N = residuo mediano / texture di Sobel, ogni 6 fotogrammi. **Nota sulla scala:** in questa versione le 10 clip misurate danno N = 0,034-0,052 (tabella in `docs/KAPILAR.md`; l'ultimo quarto di F192/F209V2 arriva a 0,062) e la soglia del controllo aggiuntivo è N <= 0,065. Un'altra implementazione ha misurato 0,028-0,036 sulle stesse clip, quindi le soglie NON sono intercambiabili tra le versioni. Su texture molto fini (file di erba) l'N pulito era 0,075, quindi la soglia dipende dalla famiglia di scene. Uno stimatore robusto ad alta frequenza (sigma-HH <= 1,5; pulito 0,74-1,19, con rumore aggiunto s=2 dà 2,2-3,0) è il controllo aggiuntivo consigliato.

Ambito: VideoTurko riguarda UN solo passaggio (fino a 209 fotogrammi, circa 8,7 s). Il nostro test di concatenazione ha mostrato giunture visibili (la scena non prosegue in modo pulito), quindi i film più lunghi non fanno parte di ciò che verifichiamo. Per concatenare c’è la guida della community `docs/KLIP_ZINCIRI.md` e il nostro strumento solo CPU `scripts/zincir.py` (`plan`, `son-kare`, `bagla`; non avvia mai il motore); non abbiamo misurato la qualità dei film concatenati [non provato], quindi controlli ogni giuntura a occhio e con `scripts/dikis_denetim.py`.
Le tue impostazioni sono tue: 209 fotogrammi è il nostro valore predefinito collaudato su una scheda da 4 GB, non un limite che devi usare. Scegli qualsiasi numero di fotogrammi della griglia 17k+5 (56, 73, ... 192, 209; vedi `docs/KURULUM.md`), cambia prompt, seed, risoluzione o qualsiasi opzione come preferisci. Le clip più corte richiedono meno memoria e tempo; GPU più grandi possono reggerne di più.

## Avviso sulla licenza del modello
**VideoTurko contiene solo patch e script (MIT); chi usa il modello e i suoi output è responsabile in prima persona della licenza MiniMax.** Non è consulenza legale. Qui sotto sono riassunte, con la numerazione, le clausole della MiniMax H3 Community License (2 agosto 2026); la licenza stessa è vincolante: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

La licenza MIT di questo repository non copre i pesi del modello; vedi [`NOTICE`](NOTICE). Questo repository NON contiene pesi del modello (nessun file di MiniMax H3, del GGUF HyperFlow-H3-Flash né del VAE). Questo progetto non è affiliato a MiniMax né approvato da MiniMax. L'uso commerciale NON è vietato (non è una licenza non commerciale); le condizioni sono qui sotto.

**Territorio (Applicable Territory)**
- **Preambolo, I.3, I.5:** In tutto il mondo, ESCLUSI l'Unione Europea, il Regno Unito, la Repubblica di Corea e gli Stati Uniti. Usare il modello equivale ad accettare la licenza.
- **II:** Licenza limitata, non trasferibile e senza royalty per usare, riprodurre, distribuire, creare opere derivate e modificare, solo all'interno del territorio e nel rispetto dell'accordo e dell'Exhibit A. Chi si trova in territori esclusi può chiedere a MiniMax una licenza separata.
- **V.4:** Usare, riprodurre, modificare, distribuire o mostrare il modello, i suoi derivati E I SUOI OUTPUT (video/audio generati) al di fuori del territorio non è autorizzato. **Quindi pubblicare o mostrare video generati nell'UE, nel Regno Unito, in Corea del Sud o negli USA è al di fuori della licenza.**
- **Exhibit A-1:** L'uso al di fuori del territorio viola l'Acceptable Use Policy.

**Distribuzione (III)** (questo repository non distribuisce il modello; se lo distribuisci tu)
- **III.1:** Dai a ogni destinatario una copia della licenza. **III.2:** Contrassegna i file modificati con avvisi ben visibili.
- **III.3:** Incoraggiato (non obbligatorio): un avviso "Powered by MiniMax H3", un identificatore di generazione IA sui file prodotti, un articolo pubblico.
- **III.4:** Le distribuzioni DEVONO essere accompagnate da un file NOTICE con: "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12:** è vietato pubblicare contenuti in qualsiasi ambiente pubblico senza dichiarare chiaramente che sono generati da una macchina: etichetta come generati da IA i video che pubblichi (elenco completo: `docs/LISANS_UYARISI.md`).
- **III (ultimo paragrafo):** Puoi aggiungere il tuo copyright alle tue modifiche ma non puoi imporre condizioni aggiuntive o diverse sull'uso/sulla distribuzione; le regole territoriali restano valide.

**Condizioni commerciali (IV)**
- **IV.1:** Se i tuoi prodotti/servizi commerciali generano più di 20 milioni di USD (o l'equivalente) di ricavi annui, ottieni PRIMA un'autorizzazione scritta da api@minimax.io (oggetto "MiniMax H3 licensing - authorization request").
- **IV.2:** L'interfaccia di un prodotto/servizio commerciale che usa il modello deve mostrare in modo evidente "MiniMax H3".

**Restrizioni d'uso (V)**
- **V.1:** Rispetta la legge applicabile (compresa la conformità commerciale) e l'Exhibit A. **V.2:** Vincola chiunque tu autorizzi ad accedere con condizioni almeno altrettanto protettive di queste restrizioni e informalo.
- **V.3:** Non puoi usare il modello né i suoi OUTPUT per migliorare altri modelli di IA (diversi da MiniMax H3 e dai suoi derivati). (I.11: la distillazione e l'addestramento su output sintetici rendono un modello un "derivato"; gli output in sé non sono derivati.)
- **V.5:** Se offri a terzi un prodotto/servizio/servizio ospitato che genera output con il modello: prima e durante tutto il funzionamento, misure tecniche e organizzative ragionevoli, un meccanismo di segnalazione, indagini tempestive e rimozione/disattivazione/sospensione dei trasgressori recidivi.

**Marchio e diritti (VI)**
- **VI.1:** Sei titolare delle opere derivate e dei derivati del modello che crei (fatti salvi i diritti di MiniMax). **VI.2:** I nomi/marchi di MiniMax non sono concessi in licenza (oltre a quanto necessario per descrivere e distribuire); il marchio "MiniMax H3" può essere usato solo per rispettare III.3, all'interno del territorio; non suggerire alcuna affiliazione.
- **VI.3:** Se fai causa a MiniMax o a chiunque sostenendo che i materiali/gli output violano i tuoi diritti, tutte le tue licenze terminano quel giorno; difendi e tieni indenne MiniMax da pretese di terzi derivanti dall'uso/dalla distribuzione da parte tua o di altri.
- **VI.4:** MiniMax non rivendica diritti sugli output; tu e i tuoi utenti siete responsabili degli output e del loro uso.

**Esclusioni di garanzia e cessazione (VII, VIII, IX)**
- **VII.1:** Nessun obbligo di assistenza/aggiornamento. **VII.2:** Modello e output sono forniti "AS IS", senza garanzie; sei tu a valutarne l'idoneità e ti assumi il rischio. **VII.3:** MiniMax e le sue affiliate non rispondono di alcun danno (nei limiti consentiti dalla legge).
- **VIII.1:** Efficace con l'accettazione/l'accesso. **VIII.2:** In caso di violazione MiniMax può risolvere la licenza; devi smettere di usare/distribuire, eliminare le copie e avvisare i destinatari (VI.1, VI.3, VII, IX restano in vigore).
- **IX:** Legge della RAS di Hong Kong; giurisdizione esclusiva dei tribunali di Hong Kong (esclusa la CISG delle Nazioni Unite).
- **Nota aggiuntiva:** l'encoder di MiniMax H3 usa Qwen3-VL-32B (Apache 2.0).

**Politica d'uso accettabile (Exhibit A)** (NON usare il modello, i derivati o gli output per)
- A-1 uso al di fuori del territorio; A-2 violare leggi o la proprietà intellettuale di terzi; A-3 fare del male a te stesso o ad altri; A-4 riutilizzare/distribuire output per nuocere; A-5 aggirare le misure di salvaguardia; A-6 sfruttare/danneggiare minori; A-7 informazioni verificabilmente false per danneggiare altri o influenzare elezioni; A-8 falsa interazione online (recensioni false ecc.); A-9 diffamazione, denigrazione, molestie; A-10 malware; A-11 dati personali per danneggiare altri; **A-12 pubblicare contenuti in qualsiasi ambiente pubblico (compresi i post dei bot) senza dichiarare in modo chiaro ed evidente che sono generati da una macchina**; A-13 impersonificazione senza consenso; A-14 decisioni automatizzate ad alto rischio in ambiti critici (forze dell'ordine, immigrazione, sanità, infrastrutture critiche, credito, lavoro, alloggio, istruzione, punteggio sociale, assicurazioni ecc.); A-15 violare le norme sociali, etiche e morali di altri paesi/regioni; A-16 estremismo violento/terrorismo; A-17 discriminazione/danno basati su caratteristiche protette; A-18 sfruttamento di popolazioni vulnerabili; **A-19 scopi militari**; A-20 attività professionale non autorizzata/senza licenza (finanziaria, legale, medica ecc.).
- Nota: questo è un riassunto in linguaggio semplice; in caso di dubbio prevale il testo inglese della licenza.

## Etichette di evidenza

Un unico insieme per tutti i documenti (tra parentesi, le grafie precedenti):
- **[misurato]** (TR: ölçtüm, olctum): eseguito in questo progetto, il percorso della prova esiste.
- **[letto]** (TR: okudum yol, okudum): la fonte o lo script è stato letto, non eseguito.
- **[progettato]** (TR: tasarım, tasarim): progettato, non ancora visto in un'esecuzione reale.
- **[stima]** (TR: tahmin): non verificato.
- **[non provato]** (TR: denenmedi): mai eseguito.
- **[segnalato dall'utente]** (TR: kullanıcı bildirdi): dichiarato dall'utente, con data; non misurato in modo indipendente.
- **[calcolato]** (TR: hesap; grafie precedenti: calculated, hesap): un numero derivato da dati misurati, non misurato di per sé; il calcolo è scritto accanto. [proposal] / [öneri] nei testi precedenti = [stima].

Nomi delle esecuzioni usati tra parentesi quadre (nomi nostri, non file di questo repository): U209 = 209 fotogrammi con il binario della versione pubblicata tramite `uret.ps1`; B209 e B192 = esecuzioni da immagine a video (`-InitImg`) a 209 e 192 fotogrammi; B56VT2 = binario della versione pubblicata, 56 fotogrammi, confrontato con il riferimento byte per byte a 56 fotogrammi R0; F209b, F209V2, F209V2K = esecuzioni a 209 fotogrammi sulla compilazione di sviluppo (dettagli: `docs/OLCUMLER.md`).

## Limitazioni note
- **Prova byte per byte** (come riprodurla da te: `docs/KANITLAR.md`, "R0 ve latent referansi nasil uretilir"; verificata sulla nostra scheda sm_61, altre GPU potrebbero non essere identiche byte per byte [stima]): con la nostra serie di patch (opzioni di memoria attive) un'esecuzione a 56 fotogrammi ha dato lo sha256 `0979f156d548169b...`, identico al riferimento [misurato]; a 141 fotogrammi lo sha256 del latente `E5D028F8632BE4FE...` era identico (con le opzioni 0013/0014). I fotogrammi da 158 a 209 non hanno un riferimento diretto byte per byte; la catena di controlli è la prova. Superare i controlli numerici non garantisce una buona clip: la coerenza del movimento nel tempo si controlla a occhio (vedi `docs/KAPILAR.md`).
- **209 fotogrammi, con quale insieme di opzioni:** la prova della catena di byte a 209 fotogrammi è stata ottenuta con l'insieme di opzioni F209V2 sulla compilazione di sviluppo (senza opzioni di coda del blocco, compilata senza le patch 0019/0020); `uret.ps1` usa questa ricetta per 209 fotogrammi [letto: lo script; un'esecuzione reale del motore tramite `uret.ps1` è riuscita nell'esecuzione U209].
- Verificato da noi su una scheda (GTX 1050 Ti 4 GB); i resoconti esterni su altre schede sono elencati con le loro etichette in `docs/KART_PROFILLERI.md` [segnalato dall'utente].
- **Quale binario è stato misurato:** il latente a 141 fotogrammi e la catena di byte sono stati misurati con le nostre compilazioni di sviluppo. Il binario della versione pubblicata che scarichi è una compilazione nuova: il suo controllo byte per byte a 56 fotogrammi è riuscito (voce successiva) e un'esecuzione a 209 fotogrammi tramite `uret.ps1` ha superato il controllo (esecuzione U209, 3414 s, picco di VRAM 3777 MiB) [misurato]; rispetto all'esecuzione a 209 con il binario di sviluppo il latente è identico byte per byte; nel video i fotogrammi (md5) e l'audio sono identici, lo sha256 del file AVI differisce a causa del contenitore [misurato] (vedi `docs/OLCUMLER.md`, sezione 0).
- **Binario della versione pubblicata, 56 fotogrammi:** il binario della versione pubblicata (sd-cli `c5cebe78...`, stable-diffusion.dll `e5d3d329...`) ha dato un risultato a 56 fotogrammi identico byte per byte a R0 (sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`; md5 per fotogramma e audio identici), eseguito direttamente con le opzioni predefinite (nessuna variabile `SD_*`), codice di uscita 0, 601 s [misurato: esecuzione B56VT2, 2026-11-19; le prove sono conservate dagli autori, non sono in questo repository]. Ambito: solo la nostra scheda sm_61 e 56 fotogrammi; non è un test di installazione in radice pulita; il latente a 141 fotogrammi e la catena a 209 sono stati misurati con il binario precedente e NON sono stati ripetuti con questo [non provato]. Un primo tentativo (B56VT, tramite uno script di supporto) è terminato in silenzio dopo 58 s, causa sconosciuta [stima: pressione sulla memoria]; il secondo tentativo ha eseguito `sd-cli` direttamente.
- Gli script di installazione ed esecuzione non sono ancora stati verificati da una cartella vuota (test in radice pulita in sospeso).
- Roadmap e prossimi passi: `ROADMAP.md`.

## Stato e limiti
- Verificato su una sola macchina (GTX 1050 Ti da 4 GB, 16 GB di RAM, i7-7700HQ). Altre schede da 4 GB e altre quantità di RAM possono dare risultati diversi.
- **209 fotogrammi per impostazione predefinita (8,7 s):** ha superato i nostri controlli di qualità (rumore 1,08, esecuzione F209V2K) [misurato: 209 fotogrammi con il binario della versione pubblicata tramite `uret.ps1`, esecuzione U209; latente identico byte per byte a quello dell'esecuzione con il binario di sviluppo; fotogrammi e audio identici nel video, lo sha del file differisce a causa del contenitore; le prove sono conservate dagli autori, non sono in questo repository]. A 209 fotogrammi il picco di VRAM del DiT è stato di 3777 MiB su 4096 MiB (esecuzioni F209b e U209; lettura di `nvidia-smi` dell'intera scheda), un margine sottile: un altro carico sulla GPU (lo schermo, altre applicazioni) può far fallire l'esecuzione a `blocks.0`; provato solo su una GTX 1050 Ti. Lo stato dello schermo durante quell'esecuzione non è stato registrato; se il tuo schermo funziona su questa scheda, c'è meno VRAM disponibile [stima: un carico di visualizzazione di Windows di circa 100-300 MB]; se serve, collega lo schermo a una GPU integrata [consiglio, non provato]. Il campionamento ha richiesto 2730 s (esecuzione U209: passi da 436-483 s) e la decodifica del VAE in processo separato 173 s (fase 2 in totale 193 s con la decodifica audio) [misurato: U209 binario della versione pubblicata; esecuzioni di sviluppo precedenti: 2664 s e 174 s]. Nella fase 1 il VAE nel processo ha esaurito la memoria ed è ripiegato sul tiling temporale (320 s); quell'output viene scartato, il video proviene dalla fase 2 senza tiling. Il picco di RAM non è stato misurato in U209. Clip più lunghe di 209 fotogrammi non fanno parte di questa versione.
- **Da immagine a video (`-InitImg`):** con un'immagine iniziale il limite è di 192 fotogrammi (8,0 s a 24 fps) su questa GPU: 209 fotogrammi non ci stavano (mancavano circa 17,5 MB di VRAM al blocco 0: servono 2587 MB, disponibili 2570 MB); 192 fotogrammi sono stati eseguiti tramite `uret.ps1` in 3086 s con un picco di VRAM di 3783 MiB e il controllo è stato superato [misurato: esecuzioni B209 e B192, 2026-11-20, una scena; le prove sono conservate dagli autori, non sono in questo repository]. Non provato su altre GPU [non provato].
- **La RAM libera conta:** servono circa 11 GB di RAM LIBERA (il processo del motore ne occupa circa 11 GB) [misurato]. Con troppo poca RAM libera il processo può morire senza alcun messaggio di errore [stima: l'abbiamo osservato una volta con circa 300 MB di RAM libera mentre `sd-cli` ne occupava circa 10 GB]. Non aprire altri programmi pesanti mentre è in esecuzione: su una macchina da 16 GB restano liberi solo circa 0,3-0,5 GB e, sotto pressione sulla memoria, l'esecuzione può morire in silenzio. Prima di iniziare, chiudi browser, giochi e altri programmi pesanti e controlla la RAM libera.
- **Test in radice pulita in sospeso:** gli script di installazione ed esecuzione non sono ancora stati verificati da una cartella vuota usando solo queste istruzioni; questa sezione sarà aggiornata quando quel test (compreso un confronto byte per byte a 56 fotogrammi con il riferimento) sarà registrato.
- Qui non viene distribuito alcun video generato.

<!-- i18n-source: README.md sha256:19eaf465ff57 -->
