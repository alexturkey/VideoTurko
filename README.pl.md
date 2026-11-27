# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · Polski · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

Tłumaczenia podążają za tym angielskim README. Jeśli tłumaczenie się różni lub jest spóźnione, obowiązuje tekst angielski, zwłaszcza w tekście o licencji i bezpieczeństwie ([`SECURITY.md`](SECURITY.md) i [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) są utrzymywane tylko po angielsku i turecku).

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **Zanim zaczniesz (licencja, terytorium):** to repozytorium jest na licencji MIT i zawiera tylko łatki i skrypty. Pobierany przez nie model MiniMax H3 podlega MiniMax H3 Community License: jej terytorium wyklucza Unię Europejską, Wielką Brytanię, Koreę Południową i Stany Zjednoczone, a modelu, pochodnych **i wyników (generowanych przez Ciebie filmów)** nie wolno tam używać, dystrybuować ani wyświetlać (V.4). Użycie komercyjne jest dozwolone w granicach warunków licencji. Przeczytaj [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) przed instalacją; to nie jest porada prawna.

> **W 30 sekund:** karta graficzna z 4 GB pamięci może w jednym przebiegu wygenerować wideo MiniMax H3 o długości 209 klatek (8.7 s): sprawdzone na jednym komputerze (GTX 1050 Ti 4 GB; pełna instalacja `kur.ps1` w pustym folderze nie została jeszcze sprawdzona od początku do końca) [zmierzone: 209 klatek na binarce wydaniowej przez `uret.ps1`, przebieg U209; latent identyczny bajt w bajt z przebiegiem na kompilacji deweloperskiej; klatki i dźwięk w wideo identyczne, sha pliku różni się z powodu kontenera; dowody przechowują autorzy, nie ma ich w tym repozytorium]; z `-InitImg` (obraz do wideo) co najwyżej 192 klatki (8.0 s) [zmierzone: przebieg B192]; 209 klatek liczy się około 57 min, domyślny limit czasu to 80 min [zmierzone: przebieg U209]; jak to uruchomić, pokazują 3 kroki poniżej.

> **Używasz agenta programistycznego AI (Codex, Claude Code, Gemini, Cursor)?** Daj mu to jedno zdanie: „Przeczytaj `AGENTS_HIZLI.md` do końca, najpierw uruchom `scripts\tani.ps1`, postępy zapisuj w `DURUM.md` i zapytaj mnie, zanim cokolwiek usuniesz lub przeniesiesz, zmienisz systemowy Python albo PATH, obniżysz ustawienie jakości lub zaakceptujesz za mnie licencję modelu.” Agent zdiagnozuje ten komputer, napisze listę kontrolną i przy każdej decyzji zapyta Ciebie; licencja modelu pozostaje Twoją decyzją.

VideoTurko: łatki pamięci do stable-diffusion.cpp oraz przepisy na uruchomienie MiniMax H3 (tekst do wideo) na 4-gigabajtowej GTX 1050 Ti, do 209 klatek (8.7 s) w jednym przebiegu; obraz do wideo (`-InitImg`) do 192 klatek (8.0 s) (209 klatek potwierdzone łańcuchem sprawdzeń bajtowych; przy sprawdzeniach na 56 i 141 klatkach wynik był identyczny bajt w bajt z przebiegiem bez łatek).

## Szybki start (Windows, 3 kroki)
**Status: poniższe skrypty instalacji i uruchomienia są jeszcze dopracowywane, a test w czystym folderze nie został wykonany; dopóki go nie przejdą, nie twierdzimy, że cokolwiek tu działa (zob. „Status i ograniczenia”).**

1. **Pobierz** to repozytorium (zielony przycisk **Code**, potem **Download ZIP**) i rozpakuj do KRÓTKIEJ ścieżki, na przykład `C:\vt`.
2. **Instalacja: kliknij dwukrotnie `kur.cmd`** (otworzy się czarne okno i pokaże każdy krok; zamknięcie go zatrzymuje instalację, a ponowne uruchomienie kontynuuje od miejsca przerwania: w połowie pobrany plik modelu jest wznawiany [przeczytane: skrypt pobierania zachowuje plik `.part` i wznawia od niego; pełne wznowienie 29 GiB nie było mierzone]). Jeśli Windows ostrzega przed pobranym plikiem, użyj zamiast tego polecenia PowerShell poniżej [rada, nie testowano na pobranym ZIP-ie]. Wolisz wiersz poleceń? Otwórz PowerShell w tym folderze (wpisz `powershell` w pasku adresu Eksploratora) i uruchom tę samą instalację:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   Katalogiem głównym instalacji jest folder, do którego rozpakowano archiwum (silnik trafia do `engine\bin`, modele do `model`); aby użyć innego miejsca, najpierw ustaw zmienną środowiskową `VT_ROOT`. Skrypt sprawdza GPU, sterownik, RAM i dysk, pobiera silnik i modele (archiwa zip silnika oraz świeżo pobrane pliki modeli są sprawdzane sumą sha256; plik modelu, który już jest na miejscu i ma właściwy rozmiar, jest sprawdzany tylko pod względem rozmiaru, a pełną weryfikację sha256 uruchamia `scripts\modelleri_indir.ps1 -Dogrula`), wykonuje krótki prawdziwy test i wypisuje READY tylko wtedy, gdy ten test przeszedł [wg projektu: `kur.ps1` nie był uruchomiony w całości w czystym folderze; to zdanie zostanie zaktualizowane po teście w czystym folderze]. `-ExecutionPolicy Bypass` działa tylko dla tego jednego procesu; tak jak w przypadku każdego instalatora, najpierw przeczytaj `scripts\kur.ps1`.
   Archiwum zip silnika pochodzi z wydania v0.1.0 na GitHubie (opublikowanego 2026-11-19; jego suma sha256 jest wpisana na stałe w `kur.ps1`). Bez internetu lub z własną kompilacją podaj lokalne archiwa zip: `-MotorZip <path> -CudaZip <path>`. Lokalne archiwum zip jest sprawdzane tą samą wpisaną na stałe sumą sha256 (plik `.sha256` obok jest ignorowany), więc musi to być archiwum z wydania; dla własnej kompilacji najpierw ustaw w `VT_MOTOR_SHA256` / `VT_CUDA_SHA256` jej sumę sha256. Błędna suma sha256 zatrzymuje skrypt z kodem 1. Do `engine\bin` trafiają tylko pliki `.exe` i `.dll`; licencje i README trafiają do `engine\lisanslar\<zip name>\`. [próbowano na archiwach dist przed wydaniem: plik `.sha256` obok plus ostrzeżenie o samoodwołaniu, binarka i biblioteki DLL rozmieszczone, `sd-cli --help` zadziałało; sumy sha zainstalowanych binarek zgodne (`c5cebe78...`, `e5d3d329...`); kroku z modelami i 5-klatkowego testu w `kur.ps1` NIE uruchomiono jeszcze na prawdziwym GPU]
   **Licencja modelu:** przed krokiem z modelami instalator wypisuje streszczenie licencji (`docs/LISANS_KABUL.txt`, pełny tekst `docs/LISANS_UYARISI.md`: MiniMax H3 Community License, ograniczenia terytorialne obejmujące także wygenerowane wideo, zasady użycia komercyjnego i oznaczania treści AI) i prosi o akceptację (`E` = tak). Przeczytaj ją najpierw. Do uruchomień bez nadzoru możesz przekazać `-LisansKabul E`, co oznacza, że licencję przeczytano i zaakceptowano samodzielnie; nie dodawaj tej flagi za kogoś innego. (Agenci AI: stosujcie się do `AGENTS.md`; nigdy nie wpisujcie E bez zgody użytkownika.) Bez akceptacji `kur.ps1` zatrzymuje się z kodem wyjścia 2 i nie pobiera żadnego modelu.
3. **Twój pierwszy film (56 klatek, około 11 min na naszej GTX 1050 Ti** [zmierzone: 641 s, przebieg R0, `docs/OLCUMLER.md`; inne karty nie były mierzone]**)**: gdy instalator wypisze `HAZIR / READY`, uruchom
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (skrót: przeciągnij plik tekstowy z promptem na `uret.cmd` albo uruchom `uret.cmd docs\ornek_istem_R0.txt`: ten sam przebieg 56 klatek). Film jest w `runs\`. Potem zapisz własny prompt w pliku tekstowym (jeden akapit po angielsku, opcjonalne zdanie `audio:`) i uruchom najdłuższy klip, jaki obsługujemy (domyślnie, około 57 min [zmierzone: przebieg U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   `-Kare` podąża za siatką 17k+5 (56, 73, ... 192, 209); domyślnie 209 (8.7 s), najdłuższa długość, jaką obejmujemy. VAE działa w osobnym procesie i nigdy nie używa kafelkowania [prawdziwy przebieg silnika przez `uret.ps1` na binarce wydaniowej, VAE w osobnym procesie, zaliczony w przebiegu U209].

   Przewodnik pisania promptu: [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (wzorzec jednego ciągłego ujęcia, równe odcinki czasu, dwa pełne przykłady).

| Wymaganie | Wartość |
|---|---|
| System | Windows 10/11, 64-bit |
| GPU | NVIDIA, 4 GB lub więcej; testowane tylko na GTX 1050 Ti (sm_61); mały zapas (3777/4096 MiB przy 209 klatkach): zajęty ekran albo przeglądarka mogą przerwać przebieg; innych kart 4 GB nie próbowano |
| RAM | 16 GB (szczyt około 11 GB; zamknij inne programy) |
| Dysk | co najmniej 32 GiB wolnego miejsca (zalecane 40 GiB lub więcej: między 32 a 40 instalator wypisuje ostrzeżenie, `[VT-W-DISK-PAY]` [zmierzone: przebiegi `-Kuru` z symulowanym dyskiem]), modele na SSD (najlepiej NVMe) |
| Pobieranie | zip silnika 36.8 MB + zip środowiska CUDA 567.5 MB [zmierzone] + modele 31,473,112,040 bajtów (około 29.3 GiB) [przeczytane: rozmiary w `scripts/modeller.json`]; łącznie około 30 GiB |
| Modele | nie są dołączone; instalator pobiera je na warunkach licencji MiniMax (zob. ostrzeżenie poniżej). Modeli (29.3 GiB, 31,473,112,040 bajtów w `scripts/modeller.json`) nie ma ani w tym repozytorium, ani w wydaniu: obowiązują limity GitHuba na rozmiar plików i wydań, a `kur.ps1` pobiera je z oficjalnego źródła z weryfikacją sha256. |

Kody wyjścia `kur.ps1`: 0 READY, 1 błąd, 2 potrzebna odpowiedź użytkownika (licencja albo brak jeszcze wydania/zip), 3 sprzęt lub dysk niewystarczający, 4 zatrzymano (plik DUR). `uret.ps1` przyjmuje przebieg tylko wtedy, gdy plik `.avi` istnieje, liczba klatek się zgadza, a logi są czyste [zmierzone: jeden prawdziwy przebieg przez `uret.ps1` na binarce wydaniowej, przebieg U209, 209 klatek, kontrola zaliczona]. Kody wyjścia `uret.ps1`: 0 DONE (kontrola jakości zaliczona), 1 błąd lub nieprawidłowy wynik (w tym wideo bez ścieżki dźwiękowej), 2 zatrzymano (plik DUR), 5 `KAPI RED` (kontrola jakości niezaliczona: klip nie został przyjęty, decyzja należy do Ciebie), 6 kontroli nie udało się wykonać (klip nie został przyjęty). Szczegóły w AGENTS.md. [zmierzone: kody wyjścia 0, 1 (wideo bez dźwięku), 5 i 6 w scenariuszach z atrapą silnika i atrapą kontroli; na prawdziwym silniku: kod 0 w przebiegu U209]

### Rozwiązywanie problemów (szczegóły: `docs/SIK_HATALAR.md`)
Linie błędów naszych skryptów niosą stały kod, na przykład `HATA: [VT-E-DLL] ...` albo `UYARI: [VT-W-DISK-PAY] ...`. Wyszukaj kod w [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) (przykład kotwicy `#vt-e-dll`) lub w `docs/hata_imzalari.json` i wpisz kod w swoim zgłoszeniu (issue). Pierwsza kolumna tabeli poniżej zostaje taka, jak wypisana (kodów i tekstu logów nie tłumaczymy).

| Co widzisz | Co to oznacza i co zrobić |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | Nie uruchamiaj `sd-cli.exe` ręcznie; uruchom `scripts\kur.ps1`, który umieszcza biblioteki DLL CUDA na miejscu. |
| `failed during weight preparation` przy `blocks.0` (#1, #3, #5) | Za mało VRAM na bramce pamięci: użyj mniejszej liczby klatek z siatki 17k+5, zamknij inne programy korzystające z GPU, zostaw flagi z dostawy. |
| `retrying with temporal tiling` (#6) | VAE przeszło na kafelkowanie; wynik jest nieważny do oceny jakości. Uruchom ponownie. |
| Przebieg kończy się na limicie czasu, brak wideo (#7) | Zwiększ `-TavanDk` dla długich klipów (domyślny limit czasu: 80 min dla 209 klatek, ustawiany przez `uret.ps1`; nasz przebieg na 209 klatkach trwał 57 min [zmierzone: przebieg U209]). |
| Kod wyjścia pusty, ale jest „finished” (#14) | Wrapper odczytał kod wyjścia zbyt wcześnie; uruchom ponownie i sprawdź, czy plik wideo istnieje. |
| System zwalnia, trwa swapowanie (#18) | Silnik zajmuje około 10-11 GB RAM; zamknij przeglądarki i inne programy. |
| Niezgodność sha256 / pobieranie nie powiodło się | Zwykle pobieranie zostało przerwane: uruchom to samo polecenie jeszcze raz, zweryfikowane pliki zostaną pominięte. |

**Utknąłeś albo jesteś ciekaw?** [`SUPPORT.md`](SUPPORT.md) (gdzie pytać; czasy odpowiedzi to cele, nie zobowiązania) · [`PRIVACY.md`](PRIVACY.md) (bez telemetrii; sieć służy tylko do pobrania silnika i modeli z wymienionych hostów) · [`SECURITY.md`](SECURITY.md) (prywatne zgłoszenie) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (pierwszy pull request w 5 krokach; do dokumentów i skryptów nie potrzeba GPU).

### Nowości w v0.1.1: dodatkowe opcje (szczegóły: `AGENTS.md`, `docs/SIK_HATALAR.md` 19-23)
Bez tych opcji na karcie 4 GB nic się nie zmienia (kontrola bajt w bajt na 56 klatkach względem naszego wzorca ponownie zaliczona w v0.1.1 [zmierzone]). Dodaj `-Kuru` do dowolnego polecenia, aby zobaczyć, co zostałoby uruchomione.
- `-EndImg`: podaj też ostatnią klatkę (pierwsza i ostatnia klatka, „FLF”); limit 175 klatek na kartach poniżej 8 GB (192 nie zmieściło się w 4 GB), 192 na kartach od 8 GB. Na naszej karcie GTX 1050 Ti zawsze działa w dwóch procesach: 56 klatek w 1040 s, 175 klatek w 2887 s (48 min), oba przebiegi zaliczyły kontrolę jakości [zmierzone]. Wskazówki do promptu: `docs/ISTEM_YAZIMI.md`.
- `-W` / `-H`: inne rozmiary, np. pionowy 384x640; wielokrotności 32, powierzchnia co najmniej 640x384 (nigdy mniejsza). Nietestowane na 4 GB; na kartach poniżej 8 GB rozmiary wykraczające poza nasze największe zmierzone zadanie są odrzucane. Progi kontroli jakości są skalibrowane dla 640x384.
- `-TekAsama`: jeden proces zamiast dwóch, tylko dla dużych kart; nigdy nie włącza się automatycznie.
- Nowsze GPU (compute capability 7.0+, np. RTX 20/30/40): `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` jest ustawiane automatycznie, chyba że ustawisz tę zmienną samodzielnie; usunęło to całkowicie czarne wideo przy 141 i więcej klatkach na RTX 4070 Ti autora zgłoszenia [zgłoszone przez użytkownika, issue #1]. Bez Pythona + OpenCV `uret.ps1` zatrzymuje się teraz z kodem wyjścia 6 przed zadaniem na GPU (wideo nie powstaje, brak mylącego RED).
- Dziękujemy @SinanC73 za raport z RTX 4070 Ti, który doprowadził do tych zmian ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1)).

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

## Opcjonalne profile szybkości (pakiet szybkości; domyślnie wyłączone)
Nic poniżej nie zmienia domyślnego uruchomienia (640x384, 209 klatek, 3414 s na naszej karcie). To trzy zmierzone komórki poza nim, każda jako nazwany profil `uret.ps1`; wymagają silnika pakietu szybkości (silnik z wydania plus łatki 0021, 0023, 0024, wszystkie domyślnie wyłączone: `docs/YAMALAR.md`). Zainstaluj go poleceniem `scripts\kur.ps1 -HizPaketi` (lokalny zip działa z `-MotorZip`), a następnie dodaj `-Profil <name>`; `-Kuru` wypisuje, co zostałoby uruchomione. Pakiet szybkości zostanie opublikowany z wydaniem v0.1.4.

| Profil | Rozmiar, długość | Całkowity czas na GTX 1050 Ti 4 GB | Status |
|---|---|---|---|
| (brak, domyślny) | 640x384, do 209 klatek (8,7 s) | 209 klatek: 3414 s | zweryfikowane, bez zmian |
| `yuksek832` | 832x480, 141 klatek (5,9 s) | około 55-56 min | użyteczne, dwa prompty [zmierzone] |
| `yuksek832 -Kare 124` | 832x480, 124 klatek (5,2 s) | około 45-46 min, bez flagi przyspieszającej | użyteczne, dwa prompty [zmierzone] |
| `yuksek896` | 896x512, 124 klatek (5,2 s) | około 56-57,5 min | użyteczne, dwa prompty [zmierzone] |
| `uzun260` | 640x384, 260 klatek (10,8 s) | około 71 min [zmierzone: 70,7 min od początku do końca przez `uret.ps1`, z wczesnym wyjściem; 78 min bez niego] | działa blisko limitu pamięci; prompt zmierzono do około 2000 znaków |

- **Wąski margines:** przy 832x480 x 141 bramka pamięci zostawia jednocyfrowy zapas w MB (5,7 i 6,8 MB w dwóch pełnych uruchomieniach). Dwa długie prompty (1520 i 2041 znaków) sprawdzono tylko przez odczyt bramki dla kroku 1 i części kroku 2, bez pełnego uruchomienia: zapas 10,9 i 4,0 MB. Każdy inny proces zajmujący pamięć karty (przeglądarka, drugi monitor) może spowodować błąd; wtedy użyj `-Kare 124` lub rozmiaru domyślnego [zmierzone, GTX 1050 Ti 4 GB].
- **`uzun260` działa blisko limitu pamięci:** szczyt VRAM 3861-3903 z 4096 MiB. Trzy pełne uruchomienia (dwie sceny); zużycie pamięci współdzielonej wzrosło o 28 do 61 MiB przy limicie 68 MiB. Prompty zmierzono do 1403 znaków w pełnych uruchomieniach i do 2009 znaków odczytem bramki; przy 2527 znakach limit pamięci współdzielonej został przekroczony. Dla tej długości nie ma odniesienia bez flag dla równości bajtowej. Zamknij inne programy używające GPU; jeśli uruchomienie się nie powiedzie, użyj domyślnych 209 klatek. Łatka 0023 jest przyjęta tylko dla tej jednej komórki.
- **Nieoferowane:** 832x480 przy 158 klatkach nie mieści się z dołączonymi łatkami (przy bramce kroku 2 brakuje ok. 280 MB); 175 klatek sprawdzono jedynie odczytem bramki (w pierwszym bloku brakowało ok. 275 MB, bez pełnego przebiegu). Profil oferuje tylko 141 klatek. Inne rozmiary i liczby klatek są odrzucane przez `-Profil` (użyj ścieżki domyślnej).
- Domyślna jakość pozostaje nietknięta: 6 kroków, cfg 1, VAE bez kafelków, 17k+5 klatek. Tam, gdzie flagi są włączone, wynik porównano bajt po bajcie z wideo bez flag w rozmiarach, w których uruchomienie bez flag się mieści (`docs/YAMALAR.md`); przy 832x480 x 141 i 896x512 x 124 uruchomienie bez flag się nie mieści, więc równość opiera się tam na najbliższych komórkach, nie na bezpośrednim porównaniu [zmierzone, przeczytane].
- Etap 1 uruchomienia dwuetapowego kończy się teraz, gdy tylko plik latentny jest kompletny (`VT_ERKEN_CIKIS=0` to wyłącza).

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

## Czym to jest
Zestaw drobnych łatek pamięci i szeregowania do stable-diffusion.cpp oraz przepis uruchomienia, kontrole i pomiary, dzięki którym MiniMax H3 (DiT 33B; uruchamiamy GGUF HyperFlow Flash 13.7B Q4_K_M; 32B enkoder tekstu Qwen3-VL jest osobny) działa na 4-gigabajtowym GPU generacji Pascal (GTX 1050 Ti, 16 GB pamięci systemowej).
- Długości w jednym przebiegu, które faktycznie wytworzyliśmy i które przeszły nasze kontrole jakości: 56, 141, 158, 175, 192, 209 klatek w 640x384 przy 24 fps (209 klatek = 8.7 s), z dźwiękiem generowanym przez sam H3 [zmierzone: 209 klatek na binarce wydaniowej przez `uret.ps1`, przebieg U209; latent identyczny bajt w bajt z przebiegiem na kompilacji deweloperskiej; klatki i dźwięk w wideo identyczne, sha pliku różni się z powodu kontenera; dowody przechowują autorzy, nie ma ich w tym repozytorium]. 209 to najdłuższa długość, jaką obejrzeliśmy i uznaliśmy za płynną [zgłoszone przez użytkownika, 2026-11-19, wideo obejrzane w całości; plik: wynik F209V2, 8.708 s].
- **Twierdzenie o zgodności bajtowej, uczciwie ograniczone:** zgodność bajtowa z wzorcem bez łatek została sprawdzona tylko dla 56 i 141 klatek. Dla 158/175/192/209 klatek użyliśmy tych samych flag i tego samego łańcucha binarek; bezpośredniego wzorca bajtowego nie ma (wersja bez łatek nie uruchomi takich długości na tym GPU).
- Ustawienia jakości nigdy nie są obniżane: ten sam model i kwantyzacja, 6 kroków, cfg 1, 640x384, ten sam seed, VAE bez kafelkowania.
- Nie twierdzimy, że jesteśmy pierwsi: szukaliśmy i nie znaleźliśmy zewnętrznego przykładu tego na 4 GB, co nie dowodzi, że takiego nie ma.

## Struktura
- `patches/` łatki do przypiętego commita stable-diffusion.cpp (zob. notatki tam)
- `scripts/` budowanie, uruchamianie, VAE w osobnym procesie, skrypty pomocnicze kontroli i spójności (`doku_norm.py`: zob. uwaga o skali poniżej)
- `docs/KURULUM.md` sprzęt, budowanie i uruchamianie (EN+TR)
- `docs/YAMALAR.md` lista łatek, `docs/KANITLAR.md` dowody, `docs/KAPILAR.md` tabela kontroli jakości, `docs/OLCUMLER.md` pomiary, `docs/SIK_HATALAR.md` częste błędy, `docs/LISANS_UYARISI.md` pełny wykaz punktów licencji
- `scripts/` krótki spis: `hiz_kos3.ps1` wrapper uruchamiania (`-Kuru` wypisuje dokładne polecenie), `uretim_kapi.ps1` kontrola jakości, `dikis_denetim.py` kontrola szwów, `doku_norm.py` szum znormalizowany względem tekstury, `bayt_kiyas.py` porównanie bajtowe, `derleme_sablonu.ps1` szablon budowania (zatrzymuje tylko pomocniczy proces telemetrii Visual Studio `vctip.exe`, który wystartował już po rozpoczęciu samego budowania i który w przeciwnym razie trzyma proces budowania podpięty przez kilka minut; inne procesy `vctip.exe` zostawia w spokoju)

## Kontrole jakości (jak przyjmowany jest wynik)

Ta kontrola nie sprawdza spójności ruchu (skoków skali lub położenia obiektów): obejrzyj całe wideo, zanim je przyjmiesz.
1. Liczba klatek się zgadza i dźwięk jest obecny; w logu brak awaryjnych przejść w zakresie pamięci i linii ALLOC_FAILED.
2. Kontrola surowego szumu: residuum filtra medianowego <= 1.5 (skala 0-255).
3. Szum znormalizowany względem tekstury, `scripts/doku_norm.py` (wersja z tego repozytorium): N = mediana residuum / tekstura Sobela, co 6. klatka. **Uwaga o skali:** w tej wersji 10 zmierzonych klipów daje N = 0.034-0.052 (tabela w `docs/KAPILAR.md`; w ostatniej ćwiartce F192/F209V2 dochodzi do 0.062), a próg dodatkowej kontroli to N <= 0.065. Inna implementacja na tych samych klipach dała 0.028-0.036, więc progi NIE są wymienne między wersjami. Na bardzo drobnych teksturach (rzędy trawy) czyste N wynosiło 0.075, więc próg ustala się dla każdej rodziny scen. Zalecana dodatkowa kontrola: odporny estymator wysokich częstotliwości (sigma-HH <= 1.5; czyste klipy 0.74-1.19, dodany szum s=2 daje 2.2-3.0).

Zakres: VideoTurko dotyczy JEDNEGO przebiegu (do 209 klatek, około 8,7 s). Nasz własny test łączenia pokazał widoczne łączenia (scena nie kontynuuje się czysto), więc dłuższe filmy nie należą do tego, co weryfikujemy. Do łączenia służy przewodnik społeczności `docs/KLIP_ZINCIRI.md` i nasze narzędzie tylko na CPU `scripts/zincir.py` (`plan`, `son-kare`, `bagla`; nigdy nie uruchamia silnika); jakości połączonych filmów nie mierzyliśmy [nie próbowano], więc sprawdzaj każde łączenie okiem i za pomocą `scripts/dikis_denetim.py`.
Ustawienia są Twoje: 209 klatek to nasza sprawdzona wartość domyślna na karcie 4 GB, a nie limit, którego musisz przestrzegać. Wybierz dowolną liczbę klatek z siatki 17k+5 (56, 73, ... 192, 209; zob. `docs/KURULUM.md`), zmieniaj prompt, seed, rozdzielczość czy dowolną flagę według uznania. Krótsze klipy wymagają mniej pamięci i czasu; większe GPU mogą pomieścić więcej.

## Ostrzeżenie o licencji modelu
**VideoTurko zawiera wyłącznie łatki i skrypty (MIT); kto używa modelu i jego wyników, sam odpowiada za przestrzeganie licencji MiniMax.** To nie jest porada prawna. Poniżej klauzule MiniMax H3 Community License (2 sierpnia 2026) w streszczeniu, z numerami; wiążąca jest sama licencja: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

Licencja MIT tego repozytorium nie obejmuje wag modelu; zobacz [`NOTICE`](NOTICE). To repozytorium NIE zawiera wag modeli (żadnych plików MiniMax H3, GGUF HyperFlow-H3-Flash ani VAE). Projekt nie jest powiązany z MiniMax ani przez nią popierany. Użycie komercyjne NIE jest zabronione (to nie jest licencja niekomercyjna); warunki poniżej.

**Terytorium (Applicable Territory)**
- **Preambuła, I.3, I.5:** cały świat, Z WYŁĄCZENIEM Unii Europejskiej, Zjednoczonego Królestwa, Republiki Korei i Stanów Zjednoczonych. Korzystanie z modelu oznacza przyjęcie licencji.
- **II:** bezpłatna, niezbywalna, ograniczona licencja na używanie, zwielokrotnianie, dystrybucję, tworzenie utworów zależnych i modyfikowanie, wyłącznie na terytorium i zgodnie z umową oraz Exhibit A. Osoby z terytoriów wyłączonych mogą poprosić MiniMax o osobną licencję.
- **V.4:** używanie, zwielokrotnianie, modyfikowanie, dystrybucja lub wyświetlanie modelu, jego pochodnych I WYNIKÓW (wygenerowanego wideo i dźwięku) poza terytorium nie jest dozwolone. **Zatem publikowanie lub pokazywanie wygenerowanych wideo w UE, Wielkiej Brytanii, Korei Południowej i USA jest poza licencją.**
- **Exhibit A-1:** użycie poza terytorium narusza Acceptable Use Policy.

**Dystrybucja (III)** (to repozytorium nie dystrybuuje modelu; jeśli robisz to Ty)
- **III.1:** przekaż każdemu odbiorcy kopię licencji. **III.2:** oznacz zmodyfikowane pliki widocznymi informacjami.
- **III.3:** Zalecane (nieobowiązkowe): informacja "Powered by MiniMax H3", identyfikator wygenerowania przez AI w wytworzonych plikach, publiczny opis pracy.
- **III.4:** do dystrybucji MUSI być dołączony plik NOTICE z tekstem: "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12:** publikowanie treści w jakimkolwiek środowisku publicznym bez wyraźnego ujawnienia, że została wygenerowana maszynowo, jest zabronione: oznaczaj wideo wygenerowane przez AI przy publikacji (pełna lista: `docs/LISANS_UYARISI.md`).
- **III (ostatni akapit):** możesz dodać własne prawa autorskie do swoich modyfikacji, ale nie możesz narzucać dodatkowych ani odmiennych warunków używania i dystrybucji; zasady terytorialne nadal obowiązują.

**Warunki komercyjne (IV)**
- **IV.1:** jeśli Twoje produkty lub usługi komercyjne generują ponad 20 mln USD (lub równowartość) rocznego przychodu, uzyskaj WCZEŚNIEJSZĄ pisemną zgodę pod adresem api@minimax.io (temat "MiniMax H3 licensing - authorization request").
- **IV.2:** interfejs produktu lub usługi komercyjnej korzystającej z modelu musi wyraźnie wyświetlać "MiniMax H3".

**Ograniczenia użycia (V)**
- **V.1:** przestrzegaj obowiązującego prawa (w tym przepisów handlowych) i Exhibit A. **V.2:** zobowiąż każdego, komu udostępniasz dostęp, warunkami co najmniej tak chroniącymi jak te ograniczenia i powiadom go.
- **V.3:** nie wolno używać modelu ani jego WYNIKÓW do ulepszania jakiegokolwiek innego modelu AI (innego niż MiniMax H3 i jego pochodne). (I.11: destylacja i trenowanie na syntetycznych wynikach czynią model „pochodnym”; same wyniki pochodnymi nie są.)
- **V.5:** jeśli oferujesz osobom trzecim produkt, usługę lub usługę hostowaną generującą wyniki za pomocą modelu: przed uruchomieniem i przez cały czas działania potrzebne są rozsądne zabezpieczenia techniczne i organizacyjne, mechanizm zgłaszania naruszeń, niezwłoczne wyjaśnianie oraz usuwanie, wyłączanie lub zawieszanie powtarzających się naruszycieli.

**Znaki towarowe i prawa (VI)**
- **VI.1:** utwory zależne i pochodne modele, które tworzysz, należą do Ciebie (z zastrzeżeniem praw MiniMax). **VI.2:** nazwy i znaki MiniMax nie są licencjonowane (poza tym, co potrzebne do opisu i dystrybucji); znaku "MiniMax H3" można używać tylko w celu spełnienia III.3, na terytorium; nie sugeruj powiązania z MiniMax.
- **VI.3:** jeśli pozwiesz MiniMax lub kogokolwiek, twierdząc, że materiały lub wyniki naruszają Twoje prawa, wszystkie Twoje licencje wygasają tego samego dnia; bronisz MiniMax i zwalniasz ją z odpowiedzialności wobec roszczeń osób trzecich wynikających z Twojego lub cudzego użycia i dystrybucji.
- **VI.4:** MiniMax nie rości sobie praw do wyników; Ty i Twoi użytkownicy odpowiadacie za wyniki i ich użycie.

**Wyłączenia odpowiedzialności i wygaśnięcie (VII, VIII, IX)**
- **VII.1:** brak obowiązku wsparcia i aktualizacji. **VII.2:** model i wyniki są dostarczane "AS IS", bez gwarancji; to Ty decydujesz o przydatności i ponosisz ryzyko. **VII.3:** MiniMax i podmioty powiązane nie odpowiadają za żadne szkody (w zakresie dozwolonym prawem).
- **VIII.1:** wchodzi w życie z chwilą akceptacji lub uzyskania dostępu. **VIII.2:** w razie naruszenia MiniMax może wypowiedzieć licencję; musisz zaprzestać używania i dystrybucji, usunąć kopie i powiadomić odbiorców (VI.1, VI.3, VII, IX pozostają w mocy).
- **IX:** prawo Specjalnego Regionu Administracyjnego Hongkongu; wyłączna jurysdykcja sądów Hongkongu (konwencja ONZ CISG wyłączona).
- **Dodatkowa uwaga:** enkoder MiniMax H3 używa Qwen3-VL-32B (Apache 2.0).

**Polityka dopuszczalnego użycia (Exhibit A)** (NIE używaj modelu, pochodnych ani wyników do poniższych celów)
- A-1 użycie poza terytorium; A-2 naruszanie prawa lub własności intelektualnej osób trzecich; A-3 szkodzenie sobie lub innym; A-4 zmiana przeznaczenia lub dystrybucja wyników w celu wyrządzenia szkody; A-5 obchodzenie zabezpieczeń; A-6 wykorzystywanie małoletnich lub szkodzenie im; A-7 dające się obalić fałszywe informacje w celu szkodzenia innym lub wpływania na wybory; A-8 fałszywa aktywność w sieci (fałszywe opinie itp.); A-9 zniesławianie, poniżanie, nękanie; A-10 złośliwe oprogramowanie; A-11 dane osobowe w celu szkodzenia innym; **A-12 publikowanie treści w jakimkolwiek środowisku publicznym (w tym wpisy botów) bez wyraźnego i widocznego ujawnienia, że została wygenerowana maszynowo**; A-13 podszywanie się pod kogoś bez zgody; A-14 zautomatyzowane decyzje wysokiego ryzyka w dziedzinach krytycznych (ściganie przestępstw, imigracja, zdrowie, infrastruktura krytyczna, kredyt, zatrudnienie, mieszkalnictwo, edukacja, scoring społeczny, ubezpieczenia itp.); A-15 naruszanie norm społecznych, etycznych i moralnych innych państw i regionów; A-16 brutalny ekstremizm i terroryzm; A-17 dyskryminacja lub krzywdzenie ze względu na cechy chronione; A-18 wykorzystywanie osób i grup szczególnie wrażliwych; **A-19 cele wojskowe**; A-20 nieuprawniona lub nielicencjonowana działalność zawodowa (finansowa, prawnicza, medyczna itp.).
- Uwaga: to jest streszczenie prostym językiem; w razie wątpliwości rozstrzyga angielski tekst licencji.

## Etykiety dowodowe

Jeden zestaw dla wszystkich dokumentów (starsze zapisy w nawiasach):
- **[zmierzone]** (TR: ölçtüm, olctum): wykonane w tym projekcie, ścieżka do dowodu istnieje.
- **[przeczytane]** (TR: okudum yol, okudum): źródło lub skrypt został przeczytany, ale nie uruchomiony.
- **[wg projektu]** (TR: tasarım, tasarim): zaprojektowane, jeszcze niewidziane w prawdziwym przebiegu.
- **[przypuszczenie]** (TR: tahmin): niezweryfikowane.
- **[nie próbowano]** (TR: denenmedi): nigdy nie uruchomiono.
- **[zgłoszone przez użytkownika]** (TR: kullanıcı bildirdi): podane przez użytkownika, z datą; niezmierzone niezależnie.
- **[wyliczone]** (TR: hesap; starsze zapisy: calculated, hesap): liczba wyprowadzona ze zmierzonych danych, sama niezmierzona; wyprowadzenie zapisano obok. [proposal] / [öneri] w starszym tekście = [przypuszczenie].

Nazwy przebiegów używane w nawiasach (nasze własne nazwy, nie pliki tego repozytorium): U209 = 209 klatek na binarce wydaniowej przez `uret.ps1`; B209 i B192 = przebiegi „obraz do wideo” (`-InitImg`) na 209 i 192 klatkach; B56VT2 = binarka wydaniowa, 56 klatek, porównana z bajtowym wzorcem R0 dla 56 klatek; F209b, F209V2, F209V2K = przebiegi na 209 klatek na kompilacji deweloperskiej (szczegóły: `docs/OLCUMLER.md`).

## Znane ograniczenia
- **Dowód bajtowy** (jak odtworzyć go samodzielnie: `docs/KANITLAR.md`, „R0 ve latent referansi nasil uretilir”; sprawdzone na naszej karcie sm_61, inne GPU mogą nie dawać zgodności bajtowej [przypuszczenie]): z naszą serią łatek (flagi pamięci włączone) przebieg na 56 klatkach dał sha256 `0979f156d548169b...`, identyczny z wzorcem [zmierzone]; przy 141 klatkach sha256 latentu `E5D028F8632BE4FE...` był identyczny (z flagami 0013/0014). Dla klatek od 158 do 209 nie ma bezpośredniego wzorca bajtowego; dowodem jest łańcuch kontroli. Przejście kontroli liczbowych nie gwarantuje dobrego klipu: spójność ruchu w czasie sprawdza się na oko (zob. `docs/KAPILAR.md`).
- **209 klatek, który zestaw flag:** dowód łańcucha bajtowego dla 209 klatek zebrano z zestawem flag F209V2 na kompilacji deweloperskiej (bez flag końca bloków, zbudowanej bez łatek 0019/0020); `uret.ps1` używa tego przepisu dla 209 klatek [przeczytane: skrypt; prawdziwy przebieg silnika przez `uret.ps1` zaliczony w przebiegu U209].
- Zweryfikowane przez nas na jednej karcie (GTX 1050 Ti 4 GB); zewnętrzne raporty o innych kartach są wymienione z etykietami w `docs/KART_PROFILLERI.md` [zgłoszone przez użytkownika].
- **Którą binarkę mierzono:** latent przy 141 klatkach i łańcuch bajtowy zmierzono na naszych kompilacjach deweloperskich. Binarka wydaniowa, którą pobierasz, jest zbudowana od nowa: jej bajtowa kontrola na 56 klatkach przeszła (następny punkt), a przebieg na 209 klatkach przez `uret.ps1` zaliczył kontrolę (przebieg U209, 3414 s, szczyt VRAM 3777 MiB) [zmierzone]; względem przebiegu 209 klatek na kompilacji deweloperskiej latent jest identyczny bajt w bajt; w wideo klatki (md5) i dźwięk są identyczne, sha256 pliku AVI różni się z powodu kontenera [zmierzone] (zob. `docs/OLCUMLER.md`, sekcja 0).
- **Binarka wydaniowa, 56 klatek:** binarka wydaniowa (sd-cli `c5cebe78...`, stable-diffusion.dll `e5d3d329...`) dała wynik na 56 klatkach identyczny bajt w bajt z R0 (sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`; md5 każdej klatki i dźwięk identyczne), uruchomiona bezpośrednio z flagami domyślnymi (bez zmiennych `SD_*`), kod wyjścia 0, 601 s [zmierzone: przebieg B56VT2, 2026-11-19; dowody przechowują autorzy, nie ma ich w tym repozytorium]. Zakres: tylko nasza karta sm_61 i 56 klatek; to nie jest test instalacji w czystym folderze; latent przy 141 klatkach i łańcuch dla 209 zmierzono na starszej binarce i NIE powtórzono na tej [nie próbowano]. Pierwsza próba (B56VT, przez skrypt pomocniczy) zakończyła się po cichu po 58 s, przyczyna nieznana [przypuszczenie: brak pamięci]; druga próba uruchamiała `sd-cli` bezpośrednio.
- Skrypty instalacji i uruchomienia nie zostały jeszcze sprawdzone z pustego folderu (test w czystym folderze przed nami).
- Plan rozwoju i następne kroki: `ROADMAP.md`.

## Status i ograniczenia
- Sprawdzone na jednym komputerze (GTX 1050 Ti 4 GB, 16 GB RAM, i7-7700HQ). Inne karty 4 GB i inne ilości RAM mogą zachowywać się inaczej.
- **Domyślnie 209 klatek (8.7 s):** przeszły nasze kontrole jakości (szum 1.08, przebieg F209V2K) [zmierzone: 209 klatek na binarce wydaniowej przez `uret.ps1`, przebieg U209; latent identyczny bajt w bajt z przebiegiem na kompilacji deweloperskiej; klatki i dźwięk w wideo identyczne, sha pliku różni się z powodu kontenera; dowody przechowują autorzy, nie ma ich w tym repozytorium]. Przy 209 klatkach szczyt VRAM dla DiT wyniósł 3777 MiB z 4096 MiB (przebiegi F209b i U209; odczyt `nvidia-smi` dla całej karty), mały zapas: inne obciążenie GPU (wyświetlacz, inne aplikacje) może spowodować błąd przy `blocks.0`; testowane tylko na GTX 1050 Ti. Stanu wyświetlacza podczas tego przebiegu nie zapisano; jeśli wyświetlacz działa na tej karcie, dostępne jest mniej VRAM [przypuszczenie: obciążenie wyświetlacza Windows rzędu 100-300 MB]; w razie potrzeby podłącz wyświetlacz do zintegrowanej grafiki [porada, nie testowano]. Próbkowanie (sampling) trwało 2730 s (przebieg U209: kroki po 436-483 s), a dekodowanie VAE w osobnym procesie 173 s (etap 2 łącznie 193 s z dekodowaniem dźwięku) [zmierzone: binarka wydaniowa w U209; starsze przebiegi na kompilacji deweloperskiej: 2664 s i 174 s]. W etapie 1 VAE w głównym procesie wyczerpało pamięć i przeszło na kafelkowanie czasowe (320 s); ten wynik jest odrzucany, wideo pochodzi z etapu 2 bez kafelkowania. Szczytu RAM w U209 nie mierzono. Klipy dłuższe niż 209 klatek nie wchodzą w skład tego wydania.
- **Obraz do wideo (`-InitImg`):** z obrazem początkowym limit na tym GPU to 192 klatki (8.0 s przy 24 fps): 209 klatek się nie zmieściło (brakowało około 17.5 MB VRAM przy bloku 0: potrzeba 2587 MB, dostępne 2570 MB); 192 klatki przeszły przez `uret.ps1` w 3086 s ze szczytem VRAM 3783 MiB, kontrola zaliczona [zmierzone: przebiegi B209 i B192, 2026-11-20, jedna scena; dowody przechowują autorzy, nie ma ich w tym repozytorium]. Na innych GPU nie próbowano [nie próbowano].
- **Wolna RAM ma znaczenie:** potrzeba około 11 GB WOLNEJ RAM (proces silnika zajmuje około 11 GB) [zmierzone]. Przy zbyt małej ilości wolnej RAM proces może zniknąć bez komunikatu o błędzie [przypuszczenie: widzieliśmy to raz przy około 300 MB wolnej RAM, gdy `sd-cli` zajmował około 10 GB]. Nie otwieraj innych dużych programów w trakcie pracy: na komputerze z 16 GB zostaje wolne tylko około 0.3-0.5 GB, a przy braku pamięci przebieg może po cichu paść. Przed startem zamknij przeglądarki, gry i inne duże programy i sprawdź ilość wolnej RAM.
- **Test w czystym folderze przed nami:** skrypty instalacji i uruchomienia nie zostały jeszcze sprawdzone z pustego folderu wyłącznie według tej instrukcji; sekcja zostanie zaktualizowana, gdy test (łącznie z bajtowym porównaniem 56 klatek z wzorcem) zostanie zapisany.
- Wygenerowane wideo nie są tu dostarczane.

<!-- i18n-source: README.md sha256:19eaf465ff57 -->
