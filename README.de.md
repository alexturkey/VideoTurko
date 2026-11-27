# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · Deutsch · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

Übersetzungen folgen diesem englischen README. Weicht eine Übersetzung ab oder hinkt sie hinterher, gilt der englische Text, besonders für den Lizenz- und Sicherheitstext ([`SECURITY.md`](SECURITY.md) und [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) werden nur auf Englisch und Türkisch gepflegt).

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **Bevor Sie starten (Lizenz, Gebiet):** Dieses Repository steht unter MIT und enthält nur Patches und Skripte. Das heruntergeladene MiniMax-H3-Modell steht unter der MiniMax H3 Community License: Ihr Geltungsgebiet schließt die Europäische Union, das Vereinigte Königreich, Südkorea und die Vereinigten Staaten aus, und das Modell, Ableitungen **und Ausgaben (die erzeugten Videos)** dürfen dort nicht verwendet, verbreitet oder gezeigt werden (V.4). Kommerzielle Nutzung ist im Rahmen der Lizenzbedingungen erlaubt. Lesen Sie [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) vor der Installation; das ist keine Rechtsberatung.

> **In 30 Sekunden:** Eine Grafikkarte mit 4 GB kann ein MiniMax-H3-Video mit 209 Frames (8,7 s) in einem einzigen Durchlauf erzeugen: auf einem Rechner verifiziert (GTX 1050 Ti 4 GB; die vollständige Installation mit `kur.ps1` in einem leeren Ordner ist noch nicht durchgehend verifiziert) [gemessen: 209 Frames mit dem Release-Binary über `uret.ps1`, Lauf U209; Latent byte-identisch zum Lauf mit dem Entwicklungs-Build; Frames und Audio im Video identisch, die Datei-sha unterscheidet sich wegen des Containers; Belege liegen bei den Autoren, nicht in diesem Repo]; mit `-InitImg` (Image-to-Video) höchstens 192 Frames (8,0 s) [gemessen: Lauf B192]; 209 Frames dauern etwa 57 min, das Standard-Zeitlimit beträgt 80 min [gemessen: Lauf U209]; die 3 Schritte unten zeigen, wie man es ausführt.

> **Nutzen Sie einen KI-Coding-Agenten (Codex, Claude Code, Gemini, Cursor)?** Geben Sie ihm diesen einen Satz: „Lies `AGENTS_HIZLI.md` bis zum Ende, führe zuerst `scripts\tani.ps1` aus, halte deinen Fortschritt in `DURUM.md` fest und frag mich, bevor du etwas löschst oder verschiebst, das System-Python oder PATH änderst, eine Qualitätseinstellung senkst oder die Modelllizenz für mich akzeptierst.“ Der Agent diagnostiziert diesen PC, schreibt eine Checkliste und fragt Sie bei jeder Entscheidung; die Modelllizenz bleibt Ihre Entscheidung.

VideoTurko: Speicher-Patches für stable-diffusion.cpp und Rezepte, um MiniMax-H3-Text-to-Video auf einer GTX 1050 Ti mit 4 GB auszuführen, bis zu 209 Frames (8,7 s) in einem einzigen Durchlauf; Image-to-Video (`-InitImg`) bis zu 192 Frames (8,0 s) (209 Frames per Byte-Kette verifiziert; byte-identisch zum ungepatchten Lauf bei den Prüfungen mit 56 und 141 Frames).

## Schnellstart (Windows, 3 Schritte)
**Status: Die Installations- und Ausführungsskripte unten werden gerade fertiggestellt, der Clean-Root-Test steht noch aus; bis dieser Test bestanden ist, wird nicht behauptet, dass hier etwas funktioniert (siehe "Status und Grenzen").**

1. **Herunterladen:** Laden Sie dieses Repository herunter (grüner Button **Code**, dann **Download ZIP**) und entpacken Sie es in einen KURZEN Ordner, zum Beispiel `C:\vt`.
2. **Installation: Doppelklick auf `kur.cmd`** (ein schwarzes Fenster öffnet sich und zeigt jeden Schritt; Schließen stoppt die Installation, erneutes Starten setzt dort fort: eine halb heruntergeladene Modelldatei wird fortgesetzt [gelesen: das Download-Skript behält eine `.part`-Datei und setzt von dort fort; eine vollständige Fortsetzung bei 29 GiB wurde nicht gemessen]). Warnt Windows vor der heruntergeladenen Datei, nutzen Sie stattdessen den PowerShell-Befehl unten [Rat, mit heruntergeladenem ZIP nicht getestet]. Lieber die Kommandozeile? Öffnen Sie PowerShell in diesem Ordner (tippen Sie `powershell` in die Adressleiste des Explorers) und führen Sie dieselbe Installation aus:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   Das Installationsverzeichnis ist der entpackte Ordner (die Engine landet in `engine\bin`, die Modelle in `model`); um einen anderen Ort zu verwenden, setzen Sie vorher die Umgebungsvariable `VT_ROOT`. Das Skript prüft GPU, Treiber, RAM und Festplatte, lädt die Engine und die Modelle herunter (Engine-Zips und neu heruntergeladene Modelldateien werden per sha256 geprüft; eine bereits vorhandene Modelldatei mit passender Größe wird nur auf die Größe geprüft, `scripts\modelleri_indir.ps1 -Dogrula` führt die vollständige sha256-Prüfung aus), führt einen kurzen echten Test aus und gibt READY nur aus, wenn dieser Test bestanden wurde [Entwurf: `kur.ps1` wurde noch nicht vollständig in einem sauberen Ordner ausgeführt; dieser Satz wird nach dem Test im sauberen Ordner aktualisiert]. `-ExecutionPolicy Bypass` gilt nur für diesen einen Prozess; lesen Sie `scripts\kur.ps1` zuerst, wie bei jedem Installer.
   Das Engine-Zip stammt aus dem GitHub-Release v0.1.0 (Veröffentlichung: 2026-11-19; seine sha256 ist in `kur.ps1` fest hinterlegt). Offline oder mit einem eigenen Build geben Sie lokale Zips an: `-MotorZip <path> -CudaZip <path>`. Ein lokales Zip wird gegen dieselbe fest hinterlegte sha256 geprüft (eine `.sha256`-Datei daneben wird ignoriert), es muss also das Release-Zip sein; für einen eigenen Build setzen Sie vorher `VT_MOTOR_SHA256` / `VT_CUDA_SHA256` auf dessen sha256. Eine falsche sha256 beendet mit exit 1. Nur `.exe`/`.dll` gehen nach `engine\bin`; Lizenzen und README gehen nach `engine\lisanslar\<zip name>\`. [vor dem Release mit den dist-Zips versucht: die Sidecar-`.sha256` samt selbstreferenzieller Warnung, Binary und DLLs platziert, `sd-cli --help` lief; die sha der installierten Binaries stimmte überein (`c5cebe78...`, `e5d3d329...`); der Modellschritt und der 5-Frame-Test von `kur.ps1` wurden noch NICHT auf einer echten GPU ausgeführt]
   **Modelllizenz:** Vor dem Modellschritt gibt der Installer die Lizenzzusammenfassung aus (`docs/LISANS_KABUL.txt`, Volltext `docs/LISANS_UYARISI.md`: MiniMax H3 Community License, Gebietsbeschränkungen, die auch erzeugte Videos betreffen, Regeln zu kommerzieller Nutzung und KI-Kennzeichnung) und bittet um Ihre Zustimmung (`E` = ja). Lesen Sie sie zuerst. Für unbeaufsichtigte Läufe können Sie `-LisansKabul E` übergeben; das bedeutet, dass Sie die Lizenz selbst gelesen und akzeptiert haben; fügen Sie es nicht für andere hinzu. (KI-Agenten: folgen Sie `AGENTS.md`; geben Sie niemals E ohne Zustimmung des Nutzers ein.) Ohne Zustimmung bricht `kur.ps1` mit Exit-Code 2 ab und lädt kein Modell herunter.
3. **Ihr erstes Video (56 Bilder, etwa 11 Min. auf unserer GTX 1050 Ti** [gemessen: 641 s, Lauf R0, `docs/OLCUMLER.md`; andere Karten nicht gemessen]**)**: Wenn der Installer `HAZIR / READY` ausgibt, starten Sie
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (Abkürzung: Ziehen Sie eine Prompt-Textdatei auf `uret.cmd` oder führen Sie `uret.cmd docs\ornek_istem_R0.txt` aus: derselbe Lauf mit 56 Bildern). Das Video liegt in `runs\`. Schreiben Sie danach Ihren eigenen Prompt in eine Textdatei (ein englischer Absatz, optionaler `audio:`-Satz) und starten Sie den längsten Clip, den wir abdecken (Standard, etwa 57 Min. [gemessen: Lauf U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   `-Kare` folgt dem 17k+5-Raster (39, 56, 73, ... 192, 209); Standard ist 209 (8,7 s), die längste Länge, die wir abdecken. Das VAE läuft in einem separaten Prozess, nie gekachelt [ein echter Engine-Lauf über `uret.ps1` mit dem Release-Binary, VAE im separaten Prozess, bestanden in Lauf U209].

   Anleitung zum Schreiben von Prompts: [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (Muster „eine durchgehende Einstellung“, gleich lange Zeitabschnitte, zwei vollständige Beispiele).

| Anforderung | Wert |
|---|---|
| Betriebssystem | Windows 10/11, 64 Bit |
| GPU | NVIDIA, 4 GB oder mehr; nur auf der GTX 1050 Ti (sm_61) getestet; knapper Spielraum (3777/4096 MiB bei 209 Frames): ein stark belasteter Bildschirm oder Browser kann den Lauf abbrechen; keine andere 4-GB-Karte getestet |
| RAM | 16 GB (Spitze etwa 11 GB; schließen Sie andere Programme) |
| Festplatte | mindestens 32 GiB frei (40 GiB oder mehr empfohlen: zwischen 32 und 40 gibt der Installer eine Warnung aus, `[VT-W-DISK-PAY]` [gemessen: `-Kuru`-Läufe mit simuliertem Datenträger]), Modelle auf einer SSD (am besten NVMe) |
| Download | Engine-Zip 36,8 MB + CUDA-Runtime-Zip 567,5 MB [gemessen] + Modelle 31.473.112.040 Bytes (etwa 29,3 GiB) [gelesen: Größen in `scripts/modeller.json`]; insgesamt etwa 30 GiB |
| Modelle | nicht enthalten; werden vom Installer unter der MiniMax-Lizenz geladen (siehe Warnung unten). Die Modelle (29,3 GiB, 31.473.112.040 Bytes in `scripts/modeller.json`) sind weder in diesem Repository noch im Release: die Größenlimits von GitHub für Dateien und Releases gelten, und `kur.ps1` lädt sie von der offiziellen Quelle mit sha256-Prüfung herunter. |

Exit-Codes von `kur.ps1`: 0 READY, 1 Fehler, 2 Eingabe des Nutzers nötig (Lizenz, oder noch kein Release/Zip), 3 Hardware oder Festplatte unzureichend, 4 gestoppt (DUR-Datei). `uret.ps1` akzeptiert einen Lauf nur, wenn die `.avi` existiert, die Frame-Anzahl stimmt und die Logs sauber sind [gemessen: ein echter Lauf über `uret.ps1` mit dem Release-Binary, Lauf U209, 209 Frames, Gate bestanden]. Exit-Codes von `uret.ps1`: 0 DONE (Qualitäts-Gate bestanden), 1 Fehler oder ungültige Ausgabe (einschließlich eines Videos ohne Audiospur), 2 gestoppt (DUR-Datei), 5 `KAPI RED` (Qualitäts-Gate nicht bestanden: Clip nicht akzeptiert, die Entscheidung liegt bei Ihnen), 6 Gate konnte nicht laufen (Clip nicht akzeptiert). Details in AGENTS.md. [gemessen: Exit-Codes 0, 1 (Video ohne Ton), 5 und 6 in Szenarien mit einer Fake-Engine und einem Fake-Gate; echte Engine: Exit 0 in Lauf U209]

### Fehlerbehebung (Details: `docs/SIK_HATALAR.md`)
Fehlerzeilen unserer Skripte tragen einen stabilen Code, zum Beispiel `HATA: [VT-E-DLL] ...` oder `UYARI: [VT-W-DISK-PAY] ...`. Suchen Sie den Code in [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) (Ankerbeispiel `#vt-e-dll`) oder in `docs/hata_imzalari.json` und tragen Sie ihn in Ihr Issue ein. Die erste Spalte der Tabelle unten bleibt wie ausgegeben (Codes und Logtext werden nicht übersetzt).

| Sie sehen | Bedeutung und was zu tun ist |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | Starten Sie `sd-cli.exe` nicht von Hand; führen Sie `scripts\kur.ps1` aus, das die CUDA-DLLs an den richtigen Ort legt. |
| `failed during weight preparation` bei `blocks.0` (#1, #3, #5) | Nicht genug VRAM am Speicher-Gate: verwenden Sie eine kleinere Frame-Anzahl auf dem 17k+5-Raster, schließen Sie andere GPU-Programme, behalten Sie die mitgelieferten Flags bei. |
| `retrying with temporal tiling` (#6) | Das VAE ist auf Kachelung zurückgefallen; die Ausgabe ist für Qualitätszwecke ungültig. Führen Sie den Lauf erneut aus. |
| Lauf endet am Zeitlimit, kein Video (#7) | Erhöhen Sie `-TavanDk` für lange Clips (Standard-Zeitlimit: 80 min für 209 Frames, von `uret.ps1` gesetzt; unser 209-Frame-Lauf dauerte 57 min [gemessen: Lauf U209]). |
| Exit-Code leer, aber "finished" (#14) | Der Wrapper hat den Exit-Code zu früh gelesen; wiederholen Sie den Lauf und prüfen Sie, ob die Videodatei existiert. |
| System wird langsam, Auslagerung (#18) | Die Engine belegt etwa 10-11 GB RAM; schließen Sie Browser und andere Programme. |
| sha256 stimmt nicht überein / Download fehlgeschlagen | Meist ein unterbrochener Download: führen Sie denselben Befehl erneut aus, verifizierte Dateien werden übersprungen. |

**Hängen Sie fest oder sind neugierig?** [`SUPPORT.md`](SUPPORT.md) (wo man fragt; Antwortzeiten sind Ziele, keine Zusagen) · [`PRIVACY.md`](PRIVACY.md) (keine Telemetrie; das Netz dient nur zum Herunterladen von Engine und Modellen von den aufgelisteten Hosts) · [`SECURITY.md`](SECURITY.md) (vertrauliche Meldung) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (erster Pull Request in 5 Schritten; für Dokumente und Skripte ist keine GPU nötig).

### Neu in v0.1.1: weitere Optionen (Details: `AGENTS.md`, `docs/SIK_HATALAR.md` 19-23)
Ohne diese Optionen ändert sich auf einer 4-GB-Karte nichts (die 56-Frame-Byte-Prüfung gegen unsere Referenz wurde mit v0.1.1 erneut bestanden [gemessen]). Hängen Sie `-Kuru` an einen beliebigen Befehl an, um zu sehen, was ausgeführt würde.
- `-EndImg`: geben Sie zusätzlich das letzte Frame vor (erstes und letztes Frame, „FLF“); Obergrenze 175 Frames auf Karten unter 8 GB (192 passte nicht auf 4 GB), 192 auf Karten ab 8 GB. Auf unserer GTX 1050 Ti läuft dieser Modus immer in zwei Prozessen: 56 Frames 1040 s, 175 Frames 2887 s (48 min), beide haben das Gate bestanden [gemessen]. Tipps für den Prompt: `docs/ISTEM_YAZIMI.md`.
- `-W` / `-H`: andere Größen, z. B. hochkant 384x640; Vielfache von 32, Fläche mindestens 640x384 (nie kleiner). Auf 4 GB nicht getestet; auf Karten unter 8 GB werden Größen abgelehnt, die über unseren größten gemessenen Lauf hinausgehen. Die Schwellenwerte des Qualitäts-Gates sind auf 640x384 kalibriert.
- `-TekAsama`: ein Prozess statt zwei, nur für große Karten; wird nie automatisch eingeschaltet.
- Neuere GPUs (Compute Capability 7.0+, z. B. RTX 20/30/40): `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` wird automatisch gesetzt, sofern Sie es nicht selbst setzen; das hat auf der RTX 4070 Ti des Meldenden ein komplett schwarzes Video ab 141 Frames behoben [vom Nutzer berichtet, issue #1]. Ohne Python + OpenCV stoppt `uret.ps1` jetzt vor dem GPU-Job mit Exit 6 (kein Video erstellt, kein irreführendes RED).
- Danke an @SinanC73 für den Bericht zur RTX 4070 Ti, der zu diesen Änderungen geführt hat ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1)).

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

## Optionale Geschwindigkeitsprofile (Speed-Pack; standardmäßig aus)
Nichts davon ändert den Standardlauf (640x384, 209 Frames, 3414 s auf unserer Karte). Es sind drei gemessene Zellen darüber hinaus, jede ein benanntes Profil von `uret.ps1`; sie brauchen die Speed-Pack-Engine (die Release-Engine plus die Patches 0021, 0023, 0024, alle standardmäßig aus: `docs/YAMALAR.md`). Installieren Sie sie mit `scripts\kur.ps1 -HizPaketi` (ein lokales ZIP funktioniert mit `-MotorZip`) und hängen Sie dann `-Profil <name>` an; `-Kuru` zeigt, was laufen würde. Das Speed-Paket erscheint mit dem Release v0.1.4.

| Profil | Größe, Länge | Gesamtzeit auf einer GTX 1050 Ti 4 GB | Status |
|---|---|---|---|
| (keins, Standard) | 640x384, bis zu 209 Frames (8,7 s) | 209 Frames: 3414 s | verifiziert, unverändert |
| `yuksek832` | 832x480, 141 Frames (5,9 s) | etwa 55-56 Min. | nutzbar, zwei Prompts [gemessen] |
| `yuksek832 -Kare 124` | 832x480, 124 Frames (5,2 s) | etwa 45-46 Min., kein Speed-Flag nötig | nutzbar, zwei Prompts [gemessen] |
| `yuksek896` | 896x512, 124 Frames (5,2 s) | etwa 56-57,5 Min. | nutzbar, zwei Prompts [gemessen] |
| `uzun260` | 640x384, 260 Frames (10,8 s) | etwa 71 Min. [gemessen: 70,7 Min. durchgängig über `uret.ps1`, mit dem frühen Ausstieg; 78 Min. ohne ihn] | läuft nahe am Speicherlimit; Prompt bis etwa 2000 Zeichen gemessen |

- **Knapper Spielraum:** Bei 832x480 x 141 lässt das Speicher-Gate nur einstellige MB Spielraum (5,7 und 6,8 MB in den beiden vollständigen Läufen). Zwei lange Prompts (1520 und 2041 Zeichen) wurden nur durch Lesen des Gates für Schritt 1 und einen Teil von Schritt 2 geprüft, nicht vollständig ausgeführt: Spielraum 10,9 und 4,0 MB. Jeder andere Prozess, der Kartenspeicher belegt (Browser, zweiter Monitor), kann den Lauf scheitern lassen; nehmen Sie dann `-Kare 124` oder die Standardgröße [gemessen, GTX 1050 Ti 4 GB].
- **`uzun260` läuft nahe am Speicherlimit:** VRAM-Spitze 3861-3903 von 4096 MiB. Drei vollständige Läufe (zwei Szenen); die Nutzung des gemeinsamen Speichers wuchs um 28 bis 61 MiB bei einer Grenze von 68 MiB. Prompts wurden bis 1403 Zeichen in vollständigen Läufen und bis 2009 Zeichen per Gate-Lesung gemessen; bei 2527 Zeichen wurde die Grenze des gemeinsamen Speichers überschritten. Für Byte-Gleichheit gibt es bei dieser Länge keine Referenz ohne Flag. Schließen Sie andere Programme, die die GPU nutzen; scheitert ein Lauf, nehmen Sie die Standard-209 Frames. Patch 0023 wird nur für diese eine Zelle akzeptiert.
- **Nicht angeboten:** 832x480 mit 158 Frames passt mit den mitgelieferten Patches nicht (am Tor von Schritt 2 fehlen etwa 280 MB); 175 Frames wurden nur über die Torablesung geprüft (im ersten Block fehlten etwa 275 MB, kein vollständiger Lauf). Das Profil bietet nur 141 Frames an. Andere Größen und Frame-Anzahlen lehnt `-Profil` ab (nehmen Sie den Standardweg).
- Die Standardqualität bleibt unberührt: 6 Schritte, cfg 1, VAE ohne Kacheln, 17k+5 Frames. Wo Flags an sind, wurde die Ausgabe in den Größen, in denen der Lauf ohne Flags passt, Byte für Byte mit dem Video ohne Flags verglichen (`docs/YAMALAR.md`); bei 832x480 x 141 und 896x512 x 124 passt der Lauf ohne Flags nicht, dort beruht die Gleichheit auf den nächstliegenden Zellen, nicht auf einem direkten Vergleich [gemessen, gelesen].
- Stufe 1 eines zweistufigen Laufs endet jetzt, sobald die Latent-Datei vollständig ist (`VT_ERKEN_CIKIS=0` schaltet das ab).

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

## Was das ist
Eine Sammlung kleiner Speicher- und Scheduling-Patches für stable-diffusion.cpp samt Ausführungsrezept, Prüfungen und Messungen, mit denen MiniMax H3 (33B DiT; wir betreiben das HyperFlow-Flash-13.7B-Q4_K_M-GGUF; der 32B-Qwen3-VL-Text-Encoder ist separat) auf einer 4-GB-Pascal-GPU (GTX 1050 Ti, 16 GB Systemspeicher) läuft.
- Längen im Einzeldurchlauf, die wir tatsächlich erzeugt und mit unseren Qualitäts-Gates bestanden haben: 56, 141, 158, 175, 192, 209 Frames bei 640x384, 24 fps (209 Frames = 8,7 s), mit dem von H3 selbst erzeugten Audio [gemessen: 209 Frames mit dem Release-Binary über `uret.ps1`, Lauf U209; Latent byte-identisch zum Lauf mit dem Entwicklungs-Build; Frames und Audio im Video identisch, die Datei-sha unterscheidet sich wegen des Containers; Belege liegen bei den Autoren, nicht in diesem Repo]. 209 ist die längste Länge, die wir angesehen und als flüssig befunden haben [vom Nutzer berichtet, 2026-11-19, Video vollständig angesehen; Datei: Ausgabe F209V2, 8,708 s].
- **Byte-Identität, ehrlich eingegrenzt:** Die Ausgaben wurden nur für 56 und 141 Frames als byte-identisch zur ungepatchten Referenz geprüft. Für 158/175/192/209 Frames haben wir dieselben Flags und dieselbe Binary-Kette verwendet; es gibt keine direkte Byte-Referenz (der ungepatchte Build kann diese Längen auf dieser GPU nicht ausführen).
- Qualitätseinstellungen werden nie gesenkt: gleiches Modell und gleiche Quantisierung, 6 Steps, cfg 1, 640x384, gleicher Seed, nicht gekacheltes VAE.
- Wir behaupten nicht, die Ersten zu sein: wir haben gesucht und kein externes Beispiel dafür auf 4 GB gefunden, was kein Beweis ist, dass es keines gibt.

## Aufbau
- `patches/` Patches gegen einen festgelegten stable-diffusion.cpp-Commit (siehe die Hinweise dort)
- `scripts/` Build, Ausführung, VAE im separaten Prozess, Hilfsprogramme für Gate/Konsistenz (`doku_norm.py`: siehe den Hinweis zur Skala unten)
- `docs/KURULUM.md` Hardware, Build- und Ausführungsschritte (EN+TR)
- `docs/YAMALAR.md` Patch-Liste, `docs/KANITLAR.md` Belege, `docs/KAPILAR.md` Tabelle der Qualitäts-Gates, `docs/OLCUMLER.md` Messungen, `docs/SIK_HATALAR.md` häufige Fehler, `docs/LISANS_UYARISI.md` vollständige Lizenzpunkte
- `scripts/` Kurzindex: `hiz_kos3.ps1` Ausführungs-Wrapper (`-Kuru` gibt den genauen Befehl aus), `uretim_kapi.ps1` Qualitäts-Gate, `dikis_denetim.py` Nahtprüfung, `doku_norm.py` texturnormiertes Rauschen, `bayt_kiyas.py` Byte-Vergleich, `derleme_sablonu.ps1` Build-Vorlage (beendet nur den Telemetrie-Helfer von Visual Studio, `vctip.exe`, der nach Beginn des eigenen Builds gestartet wurde und sonst den Build-Prozess minutenlang festhält; andere `vctip.exe`-Prozesse bleiben unberührt)

## Qualitäts-Gates (wie ein Ergebnis akzeptiert wird)

Dieses Gate prüft die Bewegungskonsistenz nicht (Sprünge bei Objektgröße oder -position): sehen Sie sich das ganze Video an, bevor Sie es akzeptieren.
1. Frame-Anzahl und Audio vorhanden; keine Speicher-Fallbacks oder ALLOC_FAILED-Zeilen im Log.
2. Gate für rohes Rauschen: Median-Filter-Residuum <= 1,5 (Skala 0-255).
3. Texturnormiertes Rauschen, `scripts/doku_norm.py` (die Version dieses Repos): N = Median-Residuum / Sobel-Textur, jedes 6. Frame. **Hinweis zur Skala:** In dieser Version ergeben die 10 gemessenen Clips N = 0,034-0,052 (Tabelle in `docs/KAPILAR.md`; das letzte Viertel von F192/F209V2 erreicht 0,062) und der Schwellenwert des Zusatz-Gates ist N <= 0,065. Eine andere Implementierung maß auf denselben Clips 0,028-0,036, die Schwellenwerte sind also zwischen den Versionen NICHT austauschbar. Bei sehr feinen Texturen (Grasreihen) lag das saubere N bei 0,075, der Schwellenwert gilt also pro Szenenfamilie. Ein robuster Hochfrequenz-Schätzer (sigma-HH <= 1,5; sauber 0,74-1,19, hinzugefügtes Rauschen s=2 ergibt 2,2-3,0) ist das empfohlene Zusatz-Gate.

Geltungsbereich: VideoTurko befasst sich mit EINEM einzigen Durchlauf (bis zu 209 Frames, etwa 8,7 s). Unser eigener Verkettungstest zeigte sichtbare Nähte (die Szene setzt sich nicht sauber fort); längere Filme gehören daher nicht zu dem, was wir verifizieren. Zum Verketten gibt es die Community-Anleitung `docs/KLIP_ZINCIRI.md` und unser reines CPU-Hilfsprogramm `scripts/zincir.py` (`plan`, `son-kare`, `bagla`; es startet die Engine nie); die Qualität verketteter Filme haben wir nicht gemessen [nicht versucht], prüfen Sie daher jede Naht mit dem Auge und mit `scripts/dikis_denetim.py`.
Ihre Einstellungen gehören Ihnen: 209 Frames sind unser getesteter Standard auf einer 4-GB-Karte, keine Grenze, die Sie verwenden müssen. Wählen Sie eine beliebige Frame-Anzahl auf dem 17k+5-Raster (39, 56, 73, ... 192, 209; siehe `docs/KURULUM.md`), ändern Sie Prompt, Seed, Auflösung oder jedes Flag nach Belieben. Kürzere Clips brauchen weniger Speicher und Zeit; größere GPUs können mehr verkraften.

## Warnung zur Modelllizenz
**VideoTurko enthält nur Patches und Skripte (MIT); wer das Modell und seine Ausgaben nutzt, ist selbst für die MiniMax-Lizenz verantwortlich.** Keine Rechtsberatung. Unten stehen die Klauseln der MiniMax H3 Community License (2. August 2026) mit ihren Nummern zusammengefasst; verbindlich ist die Lizenz selbst: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

Die MIT-Lizenz dieses Repositorys deckt die Modellgewichte nicht ab; siehe [`NOTICE`](NOTICE). Dieses Repo enthält KEINE Modellgewichte (keine Dateien von MiniMax H3, HyperFlow-H3-Flash-GGUF oder VAE). Dieses Projekt ist weder mit MiniMax verbunden noch von MiniMax unterstützt. Kommerzielle Nutzung ist NICHT verboten (es ist keine Nicht-kommerziell-Lizenz); die Bedingungen stehen unten.

**Gebiet (Applicable Territory)**
- **Präambel, I.3, I.5:** Weltweit, AUSGENOMMEN die Europäische Union, das Vereinigte Königreich, die Republik Korea und die Vereinigten Staaten. Die Nutzung des Modells gilt als Annahme der Lizenz.
- **II:** Gebührenfreie, nicht übertragbare, beschränkte Lizenz zum Nutzen, Vervielfältigen, Verbreiten, Erstellen von Ableitungen und Verändern, nur innerhalb des Gebiets und in Übereinstimmung mit der Vereinbarung und Exhibit A. Personen in ausgeschlossenen Gebieten können bei MiniMax eine gesonderte Lizenz anfragen.
- **V.4:** Das Nutzen, Vervielfältigen, Verändern, Verbreiten oder Anzeigen des Modells, seiner Ableitungen UND AUSGABEN (erzeugtes Video/Audio) außerhalb des Gebiets ist nicht gestattet. **Das Veröffentlichen oder Zeigen erzeugter Videos in der EU/im Vereinigten Königreich/in Südkorea/in den USA liegt also außerhalb der Lizenz.**
- **Exhibit A-1:** Die Nutzung außerhalb des Gebiets verstößt gegen die Acceptable Use Policy.

**Verbreitung (III)** (dieses Repo verbreitet das Modell nicht; falls Sie es tun)
- **III.1:** Geben Sie jedem Empfänger eine Kopie der Lizenz. **III.2:** Kennzeichnen Sie geänderte Dateien mit deutlichen Hinweisen.
- **III.3:** Empfohlen (nicht verpflichtend): ein Hinweis "Powered by MiniMax H3", eine KI-Kennzeichnung auf erzeugten Dateien, ein öffentlicher Bericht.
- **III.4:** Der Verbreitung MUSS eine NOTICE-Datei beiliegen mit: "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12:** Inhalte in einer öffentlichen Umgebung zu veröffentlichen, ohne klar offenzulegen, dass sie maschinell erzeugt sind, ist verboten: kennzeichnen Sie KI-erzeugte Videos, wenn Sie sie veröffentlichen (vollständige Liste: `docs/LISANS_UYARISI.md`).
- **III (letzter Absatz):** Sie dürfen Ihr eigenes Urheberrecht an Ihren Änderungen hinzufügen, aber keine zusätzlichen oder abweichenden Bedingungen für Nutzung/Verbreitung auferlegen; die Gebietsregeln gelten weiterhin.

**Kommerzielle Bedingungen (IV)**
- **IV.1:** Wenn Ihre kommerziellen Produkte/Dienste mehr als 20 Mio. USD (oder Gegenwert) Jahresumsatz erzielen, holen Sie VORHER eine schriftliche Genehmigung bei api@minimax.io ein (Betreff "MiniMax H3 licensing - authorization request").
- **IV.2:** Die Benutzeroberfläche eines kommerziellen Produkts/Dienstes, das das Modell nutzt, muss "MiniMax H3" deutlich sichtbar anzeigen.

**Nutzungsbeschränkungen (V)**
- **V.1:** Beachten Sie das geltende Recht (einschließlich Handelsvorschriften) und Exhibit A. **V.2:** Binden Sie alle, denen Sie Zugang geben, an Bedingungen, die mindestens so schützend sind wie diese Beschränkungen, und informieren Sie sie.
- **V.3:** Sie dürfen das Modell oder seine AUSGABEN nicht verwenden, um ein anderes KI-Modell zu verbessern (außer MiniMax H3 und dessen Ableitungen). (I.11: Destillation und Training mit synthetischen Ausgaben machen ein Modell zu einer "Ableitung"; die Ausgaben selbst sind keine Ableitungen.)
- **V.5:** Wenn Sie Dritten ein Produkt/einen Dienst/einen gehosteten Dienst anbieten, der mit dem Modell Ausgaben erzeugt: vor und während des gesamten Betriebs angemessene technische und organisatorische Schutzmaßnahmen, ein Meldeverfahren, zügige Untersuchung sowie Entfernung/Deaktivierung/Sperrung wiederholter Verletzer.

**Marke und Rechte (VI)**
- **VI.1:** Die von Ihnen erstellten abgeleiteten Werke und Modellableitungen gehören Ihnen (vorbehaltlich der Rechte von MiniMax). **VI.2:** Namen/Marken von MiniMax sind nicht lizenziert (über das zur Beschreibung und Verbreitung Nötige hinaus); die Marke "MiniMax H3" darf nur zur Erfüllung von III.3 verwendet werden, innerhalb des Gebiets; erwecken Sie keinen Eindruck einer Verbindung.
- **VI.3:** Wenn Sie MiniMax oder jemand anderen verklagen mit der Behauptung, die Materialien/Ausgaben verletzten Ihre Rechte, enden alle Ihre Lizenzen an diesem Tag; Sie verteidigen MiniMax gegen Ansprüche Dritter aus Ihrer oder fremder Nutzung/Verbreitung und stellen MiniMax davon frei.
- **VI.4:** MiniMax erhebt keine Rechte an Ausgaben; Sie und Ihre Nutzer sind für die Ausgaben und deren Verwendung verantwortlich.

**Haftungsausschluss und Beendigung (VII, VIII, IX)**
- **VII.1:** Keine Pflicht zu Support/Updates. **VII.2:** Modell und Ausgaben werden "AS IS" bereitgestellt, ohne Gewährleistung; Sie entscheiden über die Eignung und tragen das Risiko. **VII.3:** MiniMax und verbundene Unternehmen haften nicht für Schäden (soweit gesetzlich zulässig).
- **VIII.1:** Wirksam mit Annahme/Zugriff. **VIII.2:** Bei Verstoß kann MiniMax kündigen; Sie müssen die Nutzung/Verbreitung einstellen, Kopien löschen und Empfänger benachrichtigen (VI.1, VI.3, VII, IX bleiben bestehen).
- **IX:** Recht der Sonderverwaltungsregion Hongkong; ausschließlicher Gerichtsstand sind die Gerichte in Hongkong (UN-Kaufrecht CISG ausgeschlossen).
- **Zusätzlicher Hinweis:** Der Encoder von MiniMax H3 verwendet Qwen3-VL-32B (Apache 2.0).

**Acceptable Use Policy (Exhibit A)** (Modell, Ableitungen oder Ausgaben NICHT verwenden für)
- A-1 Nutzung außerhalb des Gebiets; A-2 Verstoß gegen Gesetze oder geistiges Eigentum Dritter; A-3 Schädigung von sich selbst oder anderen; A-4 Umwidmung/Verbreitung von Ausgaben zu Schadenszwecken; A-5 Umgehung von Schutzvorkehrungen; A-6 Ausbeutung/Schädigung Minderjähriger; A-7 nachweislich falsche Informationen, um anderen zu schaden oder Wahlen zu beeinflussen; A-8 gefälschte Online-Interaktion (gefälschte Bewertungen usw.); A-9 Verleumdung, Herabsetzung, Belästigung; A-10 Schadsoftware; A-11 personenbezogene Daten, um anderen zu schaden; **A-12 Veröffentlichung von Inhalten in einer öffentlichen Umgebung (einschließlich Bot-Beiträgen), ohne klar und deutlich offenzulegen, dass sie maschinell erzeugt sind**; A-13 Identitätsvortäuschung ohne Einwilligung; A-14 risikoreiche automatisierte Entscheidungen in kritischen Bereichen (Strafverfolgung, Einwanderung, Gesundheit, kritische Infrastruktur, Kredit, Beschäftigung, Wohnen, Bildung, Social Scoring, Versicherung usw.); A-15 Verstoß gegen soziale, ethische und moralische Standards anderer Länder/Regionen; A-16 gewalttätiger Extremismus/Terrorismus; A-17 Diskriminierung/Schädigung aufgrund geschützter Merkmale; A-18 Ausbeutung schutzbedürftiger Gruppen; **A-19 militärische Zwecke**; A-20 nicht autorisierte/unlizenzierte berufliche Tätigkeit (Finanzen, Recht, Medizin usw.).
- Hinweis: Dies ist eine allgemeinverständliche Zusammenfassung; im Zweifel gilt der englische Lizenztext.

## Beleg-Labels

Ein Satz für alle Dokumente (ältere Schreibweisen in Klammern):
- **[gemessen]** (TR: ölçtüm, olctum): in diesem Projekt ausgeführt, Belegpfad vorhanden.
- **[gelesen]** (TR: okudum yol, okudum): Quelle oder Skript gelesen, nicht ausgeführt.
- **[Entwurf]** (TR: tasarım, tasarim): entworfen, noch nicht in einem echten Lauf gesehen.
- **[Vermutung]** (TR: tahmin): nicht verifiziert.
- **[nicht versucht]** (TR: denenmedi): nie ausgeführt.
- **[vom Nutzer berichtet]** (TR: kullanıcı bildirdi): vom Nutzer angegeben, mit Datum; nicht unabhängig gemessen.
- **[berechnet]** (TR: hesap; ältere Schreibweisen: calculated, hesap): eine aus gemessenen Eingaben abgeleitete Zahl, nicht selbst gemessen; die Herleitung steht daneben. [Vorschlag] / [öneri] in älteren Texten = [Vermutung].

In eckigen Klammern verwendete Lauf-Namen (unsere eigenen Lauf-Namen, keine Dateien in diesem Repo): U209 = 209 Frames mit dem Release-Binary über `uret.ps1`; B209 und B192 = Image-to-Video-Läufe (`-InitImg`) bei 209 und 192 Frames; B56VT2 = Release-Binary, 56 Frames, verglichen mit der 56-Frame-Byte-Referenz R0; F209b, F209V2, F209V2K = 209-Frame-Läufe mit dem Entwicklungs-Build (Details: `docs/OLCUMLER.md`).

## Bekannte Einschränkungen
- **Byte-Beweis** (wie Sie ihn selbst reproduzieren: `docs/KANITLAR.md`, "R0 ve latent referansi nasil uretilir"; auf unserer sm_61-Karte verifiziert, andere GPUs sind möglicherweise nicht byte-identisch [Vermutung]): Mit unserer Patch-Serie (Speicher-Flags an) ergab ein 56-Frame-Lauf die sha256 `0979f156d548169b...`, identisch zur Referenz [gemessen]; bei 141 Frames war die Latent-sha256 `E5D028F8632BE4FE...` identisch (mit den Flags 0013/0014). Für 158 bis 209 Frames gibt es keine direkte Byte-Referenz; die Gate-Kette ist der Beleg. Das Bestehen der numerischen Gates garantiert keinen guten Clip: die Bewegungskonsistenz über die Zeit wird mit dem Auge geprüft (siehe `docs/KAPILAR.md`).
- **209 Frames, welcher Flag-Satz:** Der Beleg der 209-Frame-Byte-Kette wurde mit dem Flag-Satz F209V2 auf dem Entwicklungs-Build erhoben (keine Block-Tail-Flags, ohne die Patches 0019/0020 gebaut); `uret.ps1` verwendet dieses Rezept für 209 Frames [gelesen: das Skript; ein echter Engine-Lauf über `uret.ps1` wurde in Lauf U209 bestanden].
- Von uns auf einer Karte verifiziert (GTX 1050 Ti 4 GB); Berichte Dritter zu anderen Karten stehen mit ihren Labels in `docs/KART_PROFILLERI.md` [vom Nutzer berichtet].
- **Welches Binary gemessen wurde:** Das 141-Frame-Latent und die Byte-Kette wurden mit unseren Entwicklungs-Builds gemessen. Das Release-Binary, das Sie herunterladen, ist ein frischer Build: sein 56-Frame-Byte-Gate wurde bestanden (nächster Punkt) und ein 209-Frame-Lauf über `uret.ps1` bestand das Gate (Lauf U209, 3414 s, VRAM-Spitze 3777 MiB) [gemessen]; gegenüber dem 209-Lauf des Entwicklungs-Builds ist das Latent byte-identisch; im Video sind die Frames (md5) und das Audio identisch, die sha256 der AVI-Datei unterscheidet sich wegen des Containers [gemessen] (siehe `docs/OLCUMLER.md`, Abschnitt 0).
- **Release-Binary, 56 Frames:** Das Release-Binary (sd-cli `c5cebe78...`, stable-diffusion.dll `e5d3d329...`) lieferte ein 56-Frame-Ergebnis, das byte-identisch zu R0 ist (sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`; md5 pro Frame und Audio identisch), direkt mit Standard-Flags ausgeführt (keine `SD_*`-Variablen), Exit-Code 0, 601 s [gemessen: Lauf B56VT2, 2026-11-19; Belege liegen bei den Autoren, nicht in diesem Repo]. Geltungsbereich: nur unsere sm_61-Karte und 56 Frames; kein Clean-Root-Installationstest; das 141-Frame-Latent und die 209-Kette wurden mit dem älteren Binary gemessen und mit diesem NICHT wiederholt [nicht versucht]. Ein erster Versuch (B56VT, über ein Hilfsskript) endete nach 58 s stillschweigend, Ursache unbekannt [Vermutung: Speicherdruck]; der zweite Versuch führte `sd-cli` direkt aus.
- Die Installations- und Ausführungsskripte wurden noch nicht aus einem leeren Ordner verifiziert (Clean-Root-Test steht aus).
- Roadmap und nächste Schritte: `ROADMAP.md`.

## Status und Grenzen
- Auf einem Rechner verifiziert (GTX 1050 Ti 4 GB, 16 GB RAM, i7-7700HQ). Andere 4-GB-Karten und andere RAM-Größen können abweichen.
- **Standard 209 Frames (8,7 s):** hat unsere Qualitäts-Gates bestanden (Rauschen 1,08, Lauf F209V2K) [gemessen: 209 Frames mit dem Release-Binary über `uret.ps1`, Lauf U209; Latent byte-identisch zum Lauf mit dem Entwicklungs-Build; Frames und Audio im Video identisch, die Datei-sha unterscheidet sich wegen des Containers; Belege liegen bei den Autoren, nicht in diesem Repo]. Bei 209 Frames lag die VRAM-Spitze des DiT bei 3777 MiB von 4096 MiB (Läufe F209b und U209; Messwert von `nvidia-smi` für die gesamte Karte), ein knapper Spielraum: andere GPU-Last (der Bildschirm, andere Anwendungen) kann den Lauf bei `blocks.0` scheitern lassen; nur auf einer GTX 1050 Ti getestet. Der Zustand des Bildschirms während dieses Laufs wurde nicht festgehalten; wenn Ihr Bildschirm an dieser Karte hängt, steht weniger VRAM zur Verfügung [Vermutung: eine Windows-Anzeigelast von etwa 100-300 MB]; falls nötig, schließen Sie den Bildschirm an eine integrierte GPU an [Empfehlung, nicht getestet]. Das Sampling dauerte 2730 s (Lauf U209: Schritte von 436-483 s) und die VAE-Dekodierung im separaten Prozess 173 s (Stufe 2 insgesamt 193 s mit der Audio-Dekodierung) [gemessen: U209 Release-Binary; ältere Entwicklungsläufe: 2664 s und 174 s]. In Stufe 1 ging dem VAE im selben Prozess der Speicher aus und es fiel auf zeitliche Kachelung zurück (320 s); diese Ausgabe wird verworfen, das Video stammt aus der nicht gekachelten Stufe 2. Die RAM-Spitze wurde in U209 nicht gemessen. Längere Clips als 209 Frames sind nicht Teil dieses Releases.
- **Image-to-Video (`-InitImg`):** Mit einem Init-Bild liegt die Obergrenze auf dieser GPU bei 192 Frames (8,0 s bei 24 fps): 209 Frames passten nicht (etwa 17,5 MB VRAM fehlten bei Block 0: benötigt 2587 MB, verfügbar 2570 MB); 192 Frames liefen über `uret.ps1` in 3086 s mit einer VRAM-Spitze von 3783 MiB und das Gate wurde bestanden [gemessen: Läufe B209 und B192, 2026-11-20, eine Szene; Belege liegen bei den Autoren, nicht in diesem Repo]. Auf anderen GPUs nicht versucht [nicht versucht].
- **Freier RAM ist entscheidend:** Sie brauchen etwa 11 GB FREIEN RAM (der Engine-Prozess belegt etwa 11 GB) [gemessen]. Bei zu wenig freiem RAM kann der Prozess ohne Fehlermeldung sterben [Vermutung: wir haben es einmal bei etwa 300 MB freiem RAM beobachtet, während `sd-cli` etwa 10 GB belegte]. Öffnen Sie während des Laufs keine anderen großen Programme: auf einem 16-GB-Rechner bleiben nur etwa 0,3-0,5 GB frei, und unter Speicherdruck kann der Lauf stillschweigend sterben. Schließen Sie vor dem Start Browser, Spiele und andere große Programme und prüfen Sie den freien RAM.
- **Clean-Root-Test steht aus:** Die Installations- und Ausführungsskripte wurden noch nicht allein mit diesen Anleitungen aus einem leeren Ordner verifiziert; dieser Abschnitt wird aktualisiert, sobald dieser Test (einschließlich eines 56-Frame-Byte-Vergleichs mit der Referenz) dokumentiert ist.
- Es werden hier keine erzeugten Videos mitgeliefert.

<!-- i18n-source: README.md sha256:cdeddf10eb78 -->
