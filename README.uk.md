# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · Українська · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

Переклади відповідають цьому англійському README. Якщо переклад розходиться з ним або відстає, чинним є англійський текст, особливо щодо тексту про ліцензію та безпеку ([`SECURITY.md`](SECURITY.md) і [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) ведуться лише англійською та турецькою).

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **Перед початком (ліцензія, територія):** цей репозиторій під ліцензією MIT і містить лише патчі та скрипти. Модель MiniMax H3, яку він завантажує, поширюється за MiniMax H3 Community License: її територія не включає Європейський Союз, Велику Британію, Південну Корею та США, а модель, похідні **та результати (створені вами відео)** там не можна використовувати, поширювати чи показувати (V.4). Комерційне використання дозволене в межах умов ліцензії. Прочитайте [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) перед встановленням; це не юридична консультація.

> **Коротко (за 30 секунд):** відеокарта з 4 ГБ пам'яті може за один прохід зробити відео MiniMax H3 на 209 кадрів (8.7 с): перевірено на одній машині (GTX 1050 Ti 4 ГБ; повне встановлення `kur.ps1` у порожню теку від початку до кінця ще не перевірене) [виміряно: 209 кадрів на релізному бінарнику через `uret.ps1`, прогін U209; латент побайтово збігся з прогоном на збірці для розробки; кадри й звук у відео ідентичні, sha файлу відрізняється через контейнер; докази зберігають автори, у цьому репозиторії їх немає]; з `-InitImg` (зображення у відео) щонайбільше 192 кадри (8.0 с) [виміряно: прогін B192]; 209 кадрів рахуються близько 57 хв, типовий ліміт часу 80 хв [виміряно: прогін U209]; як це запустити, показують 3 кроки нижче.

VideoTurko: патчі пам'яті для stable-diffusion.cpp і рецепти запуску MiniMax H3 (текст у відео) на 4-гігабайтній GTX 1050 Ti, до 209 кадрів (8.7 с) за один прохід; зображення у відео (`-InitImg`) до 192 кадрів (8.0 с) (209 кадрів підтверджено ланцюжком побайтових перевірок; на перевірках у 56 і 141 кадр результат побайтово збігся з непропатченим прогоном).

## Швидкий старт (Windows, 3 кроки)
**Статус: скрипти встановлення й запуску нижче ще доопрацьовуються, тест у чистій теці не пройдено; доки він не пройдений, ми не стверджуємо, що тут усе працює (див. «Статус і обмеження»).**

1. **Завантажте** цей репозиторій (зелена кнопка **Code**, далі **Download ZIP**) і розпакуйте в КОРОТКИЙ шлях, наприклад `C:\vt`.
2. **Встановлення: двічі клацніть `kur.cmd`** (відкриється чорне вікно й покаже кожен крок; якщо закрити його, встановлення зупиниться, а повторний запуск продовжить з того місця: наполовину завантажений файл моделі докачується [прочитано: скрипт завантаження зберігає файл `.part` і продовжує з нього; повне докачування 29 GiB не вимірювали]). Якщо Windows попереджає про завантажений файл, скористайтеся натомість командою PowerShell нижче [порада, на завантаженому ZIP не перевіряли]. Віддаєте перевагу командному рядку? Відкрийте PowerShell у цій теці (введіть `powershell` в адресному рядку Провідника) і виконайте те саме встановлення:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   Корінь встановлення це тека, у яку ви розпакували архів (рушій потрапляє в `engine\bin`, моделі в `model`); щоб обрати інше місце, заздалегідь задайте змінну середовища `VT_ROOT`. Скрипт перевіряє GPU, драйвер, RAM і диск, завантажує рушій і моделі (для zip-архівів рушія та щойно завантажених файлів моделей перевіряється sha256; файл моделі, що вже лежить на місці й збігається за розміром, перевіряється лише за розміром, а повну перевірку sha256 запускає `scripts\modelleri_indir.ps1 -Dogrula`), робить коротку справжню перевірку і друкує READY, лише якщо вона пройшла [за задумом: `kur.ps1` повністю в чистій теці не запускався; це речення буде оновлено після тесту в чистій теці]. `-ExecutionPolicy Bypass` діє лише на цей один процес; як і будь-який інсталятор, спершу прочитайте `scripts\kur.ps1`.
   Zip-архів рушія завантажується з релізу v0.1.0 на GitHub (опубліковано 2026-11-19; його sha256 зафіксовано в `kur.ps1`). Без інтернету або з власною збіркою передайте локальні zip-файли: `-MotorZip <path> -CudaZip <path>`. Локальний zip перевіряється за тим самим зафіксованим sha256 (файл `.sha256` поруч ігнорується), тому це має бути zip із релізу; для власної збірки спершу задайте в `VT_MOTOR_SHA256` / `VT_CUDA_SHA256` її sha256. Неправильний sha256 зупиняє скрипт із кодом 1. В `engine\bin` потрапляють лише `.exe` і `.dll`; ліцензії та README кладуться в `engine\lisanslar\<zip name>\`. [пробували на dist-архівах до релізу: `.sha256` поруч плюс попередження про самопосилання, бінарник і DLL розкладено, `sd-cli --help` відпрацював; sha встановлених бінарників збіглися (`c5cebe78...`, `e5d3d329...`); крок із моделями та перевірку на 5 кадрів у `kur.ps1` на справжній GPU ЩЕ НЕ запускали]
   **Ліцензія моделі:** перед кроком із моделями інсталятор друкує стислий виклад ліцензії (`docs/LISANS_KABUL.txt`, повний текст `docs/LISANS_UYARISI.md`: MiniMax H3 Community License, територіальні обмеження, що поширюються і на згенеровані відео, правила комерційного використання та маркування ШІ) і просить погодитися (`E` = так). Спершу прочитайте її. Для запуску без втручання можна передати `-LisansKabul E`: це означає, що ви самі прочитали ліцензію й прийняли її; не додавайте цей прапорець за іншу людину. (ШІ-агентам: дотримуйтеся `AGENTS.md`; ніколи не вводьте E без згоди користувача.) Без згоди `kur.ps1` зупиняється з кодом виходу 2 і не завантажує жодної моделі.
3. **Ваше перше відео (56 кадрів, близько 11 хв на нашій GTX 1050 Ti** [виміряно: 641 с, запуск R0, `docs/OLCUMLER.md`; інші відеокарти не вимірювали]**)**: коли інсталятор виведе `HAZIR / READY`, виконайте
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (швидкий шлях: перетягніть текстовий файл із промптом на `uret.cmd` або виконайте `uret.cmd docs\ornek_istem_R0.txt`: той самий запуск на 56 кадрів). Відео лежить у `runs\`. Потім запишіть власний промпт у текстовий файл (один абзац англійською, необов’язкове речення `audio:`) і запустіть найдовший кліп, який ми підтримуємо (за замовчуванням, близько 57 хв [виміряно: запуск U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   `-Kare` іде за сіткою 17k+5 (56, 73, ... 192, 209); типово 209 (8.7 с), найдовша довжина, яку ми покриваємо. VAE працює в окремому процесі й ніколи не використовує тайлінг [справжній прогін рушія через `uret.ps1` на релізному бінарнику, VAE в окремому процесі, пройдено в прогоні U209].

   Посібник із написання промпта: [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (шаблон одного безперервного кадру, рівні відрізки часу, два повних приклади).

| Вимога | Значення |
|---|---|
| ОС | Windows 10/11, 64-біт |
| GPU | NVIDIA, 4 ГБ або більше; перевірено лише на GTX 1050 Ti (sm_61); запас малий (3777/4096 MiB на 209 кадрах): зайнятий екран чи браузер можуть зірвати прогін; інші карти на 4 ГБ не пробували |
| RAM | 16 ГБ (пік близько 11 ГБ; закрийте інші програми) |
| Диск | щонайменше 32 GiB вільно (рекомендовано 40 GiB і більше: при 32–40 інсталятор виводить попередження, `[VT-W-DISK-PAY]` [виміряно: запуски `-Kuru` з імітацією диска]), моделі на SSD (бажано NVMe) |
| Завантаження | zip рушія 36.8 MB + zip середовища CUDA 567.5 MB [виміряно] + моделі 31,473,112,040 байт (близько 29.3 GiB) [прочитано: розміри в `scripts/modeller.json`]; разом близько 30 GiB |
| Моделі | не входять у репозиторій; інсталятор завантажує їх за ліцензією MiniMax (див. попередження нижче). Моделі (29.3 GiB, 31,473,112,040 байт у `scripts/modeller.json`) не лежать ані в цьому репозиторії, ані в релізі: діють обмеження GitHub на розмір файлів і релізів, а `kur.ps1` завантажує їх з офіційного джерела з перевіркою sha256. |

Коди виходу `kur.ps1`: 0 READY, 1 помилка, 2 потрібне втручання користувача (ліцензія або ще немає релізу/zip), 3 недостатньо заліза або диска, 4 зупинено (файл DUR). `uret.ps1` приймає прогін, лише якщо `.avi` існує, кількість кадрів правильна, а логи чисті [виміряно: один справжній прогін через `uret.ps1` на релізному бінарнику, прогін U209, 209 кадрів, перевірку пройдено]. Коди виходу `uret.ps1`: 0 DONE (перевірку якості пройдено), 1 помилка або недійсний результат (зокрема відео без звукової доріжки), 2 зупинено (файл DUR), 5 `KAPI RED` (перевірку якості не пройдено: кліп не прийнято, рішення за вами), 6 перевірку не вдалося виконати (кліп не прийнято). Подробиці в AGENTS.md. [виміряно: коди виходу 0, 1 (відео без звуку), 5 і 6 у сценаріях із підробним рушієм і підробною перевіркою; на справжньому рушії: код 0 у прогоні U209]

### Типові проблеми (докладніше: `docs/SIK_HATALAR.md`)
Рядки помилок наших скриптів містять стабільний код, наприклад `HATA: [VT-E-DLL] ...` або `UYARI: [VT-W-DISK-PAY] ...`. Знайдіть код у [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) (приклад якоря `#vt-e-dll`) або в `docs/hata_imzalari.json` і вкажіть код у своєму issue. Перший стовпець таблиці нижче лишається таким, як надруковано (коди й текст журналу не перекладаються).

| Що ви бачите | Що це означає і що робити |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | Не запускайте `sd-cli.exe` вручну; запустіть `scripts\kur.ps1`, він розкладає DLL CUDA на місця. |
| `failed during weight preparation` на `blocks.0` (#1, #3, #5) | Не вистачило VRAM на перевірці пам'яті: візьміть менше кадрів із сітки 17k+5, закрийте інші програми, що використовують GPU, залиште прапорці з постачання. |
| `retrying with temporal tiling` (#6) | VAE відкотився на тайлінг; результат для оцінки якості недійсний. Запустіть ще раз. |
| Прогін завершився за лімітом часу, відео немає (#7) | Збільште `-TavanDk` для довгих кліпів (типовий ліміт: 80 хв для 209 кадрів, задається в `uret.ps1`; наш прогін на 209 кадрів тривав 57 хв [виміряно: прогін U209]). |
| Код виходу порожній, але написано «finished» (#14) | Обгортка прочитала код виходу надто рано; запустіть знову й перевірте, що файл відео існує. |
| Система гальмує, іде підкачування (#18) | Рушій займає близько 10-11 ГБ RAM; закрийте браузери й інші програми. |
| Розбіжність sha256 / завантаження не вдалося | Зазвичай завантаження обірвалося: виконайте ту саму команду ще раз, перевірені файли буде пропущено. |

**Застрягли чи цікаво?** [`SUPPORT.md`](SUPPORT.md) (куди звертатися; терміни відповіді це цілі, а не зобов’язання) · [`PRIVACY.md`](PRIVACY.md) (без телеметрії; мережа використовується лише для завантаження рушія та моделей з перелічених хостів) · [`SECURITY.md`](SECURITY.md) (приватне повідомлення) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (перший pull request за 5 кроків; для документів і скриптів GPU не потрібна).

### Нове у v0.1.1: додаткові параметри (докладніше: `AGENTS.md`, `docs/SIK_HATALAR.md` 19-23)
Якщо не використовувати ці параметри, на карті з 4 ГБ нічого не змінюється (побайтову перевірку на 56 кадрах проти нашого еталона знову пройдено з v0.1.1 [виміряно]). Щоб побачити, що буде запущено, додайте `-Kuru` до будь-якої команди.
- `-EndImg`: задає ще й останній кадр (перший і останній кадр, «FLF»); межа 175 кадрів на картах менше 8 ГБ (192 кадри не вмістилися в 4 ГБ), 192 на картах від 8 ГБ. На нашій GTX 1050 Ti завжди працює у двох процесах: 56 кадрів за 1040 с, 175 кадрів за 2887 с (48 хв), обидва прогони пройшли перевірку якості [виміряно]. Поради щодо промпту: `docs/ISTEM_YAZIMI.md`.
- `-W` / `-H`: інші розміри, наприклад вертикальний 384x640; кратні 32, площа не менше 640x384 (менше не можна). На 4 ГБ не перевірялося; на картах менше 8 ГБ розміри, що перевищують наш найбільший виміряний прогін, відхиляються. Пороги перевірки якості відкалібровано під 640x384.
- `-TekAsama`: один процес замість двох, лише для великих карт; сам ніколи не вмикається.
- Новіші GPU (compute capability 7.0+, наприклад RTX 20/30/40): `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` задається автоматично, якщо ви не задали його самі; це усунуло повністю чорне відео починаючи зі 141 кадру на RTX 4070 Ti автора звіту [зі слів користувача, issue #1]. Без Python + OpenCV `uret.ps1` тепер зупиняється з кодом виходу 6 ще до завдання на GPU (відео не створюється, оманливого RED немає).
- Дякуємо @SinanC73 за звіт із RTX 4070 Ti, який привів до цих змін ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1)).

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

## Необов’язкові профілі швидкості (пакет швидкості; типово вимкнені)
Нічого з наведеного нижче не змінює типовий запуск (640x384, 209 кадрів, 3414 с на нашій відеокарті). Це три виміряні комірки поза ним, кожна — іменований профіль `uret.ps1`; вони потребують рушія пакета швидкості (рушій релізу плюс патчі 0021, 0023, 0024, усі типово вимкнені: `docs/YAMALAR.md`). Встановіть його командою `scripts\kur.ps1 -HizPaketi` (локальний zip працює з `-MotorZip`), потім додайте `-Profil <name>`; `-Kuru` виводить, що було б запущено. Пакет швидкості публікується разом із релізом v0.1.4.

| Профіль | Розмір, довжина | Загальний час на GTX 1050 Ti 4 GB | Статус |
|---|---|---|---|
| (немає, типовий) | 640x384, до 209 кадрів (8,7 с) | 209 кадрів: 3414 с | перевірено, без змін |
| `yuksek832` | 832x480, 141 кадр (5,9 с) | приблизно 55-56 хв | придатний до використання, два промпти [виміряно] |
| `yuksek832 -Kare 124` | 832x480, 124 кадри (5,2 с) | приблизно 45-46 хв, прапорець швидкості не потрібен | придатний до використання, два промпти [виміряно] |
| `yuksek896` | 896x512, 124 кадри (5,2 с) | приблизно 56-57,5 хв | придатний до використання, два промпти [виміряно] |
| `uzun260` | 640x384, 260 кадрів (10,8 с) | 78 хв виміряно без раннього виходу; з ним приблизно 71-72 хв [припущення: наскрізно через `uret.ps1` не вимірювали] | умовний та експериментальний |

- **Вузький запас:** при 832x480 x 141 шлюз пам’яті залишає однозначний запас у МБ (5,7 і 6,8 МБ у двох повних запусках). Два довгі промпти (1520 і 2041 символ) перевірено лише читанням шлюзу для кроку 1 і частини кроку 2, без повного запуску: запас 10,9 і 4,0 МБ. Будь-який інший процес, що тримає пам’ять відеокарти (браузер, другий монітор), може призвести до збою; тоді використайте `-Kare 124` або типовий розмір [виміряно, GTX 1050 Ti 4 GB].
- **`uzun260` умовний:** ліміт пам’яті дуже вузький (пік VRAM 3903 із 4096 MiB), використання спільної пам’яті зросло на 45 і 61 MiB (межа 68), а еталона без прапорців для побайтової рівності немає, тому його не пропонують як звичайну можливість. Патч 0023 прийнято лише для цієї однієї комірки.
- **Не пропонується:** 832x480 при 158 кадрах не вміщується з наданими патчами (на шлюзі кроку 2 бракує близько 280 MB); 175 кадрів перевірено лише читанням шлюзу (у першому блоці бракувало близько 275 MB, повного запуску не було). Профіль пропонує лише 141 кадр. Інші розміри та кількості кадрів `-Profil` відхиляє (користуйтеся типовим шляхом).
- Типова якість недоторкана: 6 кроків, cfg 1, VAE без тайлів, 17k+5 кадрів. Де прапорці ввімкнені, вихід порівняно побайтово з відео без прапорців на розмірах, де запуск без прапорців вміщується (`docs/YAMALAR.md`); при 832x480 x 141 і 896x512 x 124 запуск без прапорців не вміщується, тож рівність там спирається на найближчі комірки, а не на пряме порівняння [виміряно, прочитано].
- Етап 1 двоетапного запуску тепер завершується, щойно файл латентів повний (`VT_ERKEN_CIKIS=0` це вимикає).

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

## Що це таке
Набір невеликих патчів пам'яті та планування для stable-diffusion.cpp плюс рецепт запуску, перевірки й вимірювання, завдяки яким MiniMax H3 (DiT на 33B; ми запускаємо GGUF HyperFlow Flash 13.7B Q4_K_M; текстовий енкодер Qwen3-VL на 32B окремий) працює на 4-гігабайтній GPU покоління Pascal (GTX 1050 Ti, 16 ГБ системної пам'яті).
- Довжини за один прохід, які ми справді отримали й які пройшли наші перевірки якості: 56, 141, 158, 175, 192, 209 кадрів при 640x384 і 24 fps (209 кадрів = 8.7 с), зі звуком, який генерує сам H3 [виміряно: 209 кадрів на релізному бінарнику через `uret.ps1`, прогін U209; латент побайтово збігся з прогоном на збірці для розробки; кадри й звук у відео ідентичні, sha файлу відрізняється через контейнер; докази зберігають автори, у цьому репозиторії їх немає]. 209 це найдовша довжина, яку ми дивилися й визнали плавною [зі слів користувача, 2026-11-19, відео переглянуто повністю; файл: результат F209V2, 8.708 с].
- **Твердження про побайтовий збіг, чесно в межах:** побайтовий збіг із непропатченим еталоном перевірено лише для 56 і 141 кадру. Для 158/175/192/209 кадрів ми використовували ті самі прапорці й той самий ланцюжок бінарників; прямого байтового еталона немає (непропатчена збірка не може запустити такі довжини на цій GPU).
- Налаштування якості ніколи не знижуються: та сама модель і квантування, 6 кроків, cfg 1, 640x384, той самий seed, VAE без тайлінгу.
- Ми не стверджуємо, що ми перші: ми шукали й не знайшли зовнішніх прикладів цього на 4 ГБ, але це не доказ того, що їх немає.

## Структура
- `patches/` патчі до зафіксованого коміту stable-diffusion.cpp (див. нотатки там)
- `scripts/` збирання, запуск, VAE в окремому процесі, допоміжні скрипти перевірок і узгодженості (`doku_norm.py`: див. примітку про шкалу нижче)
- `docs/KURULUM.md` залізо, збирання й запуск (EN+TR)
- `docs/YAMALAR.md` перелік патчів, `docs/KANITLAR.md` докази, `docs/KAPILAR.md` таблиця перевірок якості, `docs/OLCUMLER.md` вимірювання, `docs/SIK_HATALAR.md` типові помилки, `docs/LISANS_UYARISI.md` повний перелік пунктів ліцензії
- `scripts/` короткий покажчик: `hiz_kos3.ps1` обгортка запуску (`-Kuru` друкує точну команду), `uretim_kapi.ps1` перевірка якості, `dikis_denetim.py` перевірка швів, `doku_norm.py` шум, нормований на текстуру, `bayt_kiyas.py` побайтове порівняння, `derleme_sablonu.ps1` шаблон збирання (зупиняє лише допоміжний процес телеметрії Visual Studio `vctip.exe`, що запустився вже після початку самого збирання і який інакше тримає процес збирання прив'язаним на кілька хвилин; інші процеси `vctip.exe` не чіпає)

## Перевірки якості (як приймається результат)

Ця перевірка не контролює узгодженість руху (стрибки масштабу чи положення об'єктів): перегляньте відео повністю, перш ніж його приймати.
1. Кількість кадрів правильна і звук присутній; у журналі немає відкатів щодо пам'яті та рядків ALLOC_FAILED.
2. Перевірка сирого шуму: залишок після медіанного фільтра <= 1.5 (шкала 0-255).
3. Шум, нормований на текстуру, `scripts/doku_norm.py` (версія з цього репозиторію): N = медіанний залишок / текстура за Собелем, кожен 6-й кадр. **Примітка про шкалу:** у цій версії 10 виміряних кліпів дають N = 0.034-0.052 (таблиця в `docs/KAPILAR.md`; в останній чверті F192/F209V2 сягає 0.062), а поріг додаткової перевірки N <= 0.065. Інша реалізація на тих самих кліпах дала 0.028-0.036, тому пороги НЕ взаємозамінні між версіями. На дуже дрібних текстурах (ряди трави) чистий N був 0.075, тож поріг задається для кожної родини сцен. Рекомендована додаткова перевірка: стійка оцінка високих частот (sigma-HH <= 1.5; чисті кліпи 0.74-1.19, доданий шум s=2 дає 2.2-3.0).

Обсяг: VideoTurko — про ОДИН прохід (до 209 кадрів, близько 8,7 с). Наш власний тест склеювання показав помітні шви (сцена продовжується нечисто), тому довші фільми не входять до того, що ми перевіряємо. Для склеювання є посібник спільноти `docs/KLIP_ZINCIRI.md` і наш помічник лише для CPU `scripts/zincir.py` (`plan`, `son-kare`, `bagla`; він ніколи не запускає рушій); якість склеєних фільмів ми не вимірювали [не пробували], тому перевіряйте кожен шов оком і за допомогою `scripts/dikis_denetim.py`.
Налаштування ваші: 209 кадрів це наше перевірене типове значення на 4-гігабайтній карті, а не межа, якою ви зобов'язані користуватися. Оберіть будь-яку кількість кадрів із сітки 17k+5 (56, 73, ... 192, 209; див. `docs/KURULUM.md`), змінюйте промпт, seed, роздільність чи будь-який прапорець на власний розсуд. Коротші кліпи потребують менше пам'яті й часу; на потужніших GPU може вміститися більше.

## Попередження про ліцензію моделі
**VideoTurko містить лише патчі та скрипти (MIT); хто використовує модель і її результати, сам відповідає за дотримання ліцензії MiniMax.** Це не юридична консультація. Нижче пункти MiniMax H3 Community License (2 серпня 2026) у стислому викладі з номерами; обов'язкова сама ліцензія: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

Ліцензія MIT цього репозиторію не поширюється на ваги моделі; див. [`NOTICE`](NOTICE). У цьому репозиторії НЕМАЄ ваг моделей (немає файлів MiniMax H3, GGUF HyperFlow-H3-Flash і VAE). Проєкт не пов'язаний із MiniMax і не схвалений нею. Комерційне використання НЕ заборонене (це не некомерційна ліцензія); умови наведено нижче.

**Територія (Applicable Territory)**
- **Преамбула, I.3, I.5:** увесь світ, КРІМ Європейського Союзу, Великої Британії, Республіки Корея та США. Використання моделі означає прийняття ліцензії.
- **II:** безоплатна, непередавана, обмежена ліцензія на використання, відтворення, поширення, створення похідних робіт і модифікацію, лише на території та відповідно до угоди й Exhibit A. Особи у виключених територіях можуть звернутися до MiniMax по окрему ліцензію.
- **V.4:** використання, відтворення, зміна, поширення чи показ моделі, її похідних І РЕЗУЛЬТАТІВ (згенерованого відео та звуку) поза територією не дозволені. **Отже, публікація чи показ згенерованих відео в ЄС, Великій Британії, Південній Кореї та США виходить за межі ліцензії.**
- **Exhibit A-1:** використання поза територією порушує Acceptable Use Policy.

**Поширення (III)** (цей репозиторій модель не поширює; якщо поширюєте ви)
- **III.1:** передайте кожному отримувачу копію ліцензії. **III.2:** змінені файли позначте помітними повідомленнями.
- **III.3:** Бажано (не обов'язково): повідомлення "Powered by MiniMax H3", ідентифікатор ШІ-генерації на створених файлах, публічний опис роботи.
- **III.4:** до поширення ОБОВ'ЯЗКОВО додається файл NOTICE з текстом: "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12:** публікація контенту в будь-якому публічному середовищі без чіткого зазначення, що його створено машиною, заборонена: позначайте згенеровані ШІ відео під час публікації (повний перелік: `docs/LISANS_UYARISI.md`).
- **III (останній абзац):** ви можете додати власне авторське право на свої зміни, але не можете вводити додаткові чи інші умови використання та поширення; територіальні правила продовжують діяти.

**Комерційні умови (IV)**
- **IV.1:** якщо ваші комерційні продукти чи сервіси приносять понад 20 млн доларів США (або еквівалент) річного доходу, отримайте ПОПЕРЕДНЄ письмове погодження за адресою api@minimax.io (тема листа "MiniMax H3 licensing - authorization request").
- **IV.2:** в інтерфейсі комерційного продукту чи сервісу, що використовує модель, має бути помітно вказано "MiniMax H3".

**Обмеження використання (V)**
- **V.1:** дотримуйтеся чинного права (зокрема торговельного комплаєнсу) та Exhibit A. **V.2:** зобов'яжіть кожного, кому надаєте доступ, умовами не менш захисними, ніж ці обмеження, і повідомте його.
- **V.3:** не можна використовувати модель чи її РЕЗУЛЬТАТИ для покращення будь-якої іншої ШІ-моделі (крім MiniMax H3 та її похідних). (I.11: дистиляція й навчання на синтетичних результатах роблять модель «похідною»; самі результати похідними не є.)
- **V.5:** якщо ви пропонуєте третім особам продукт, сервіс чи хостований сервіс, що генерує результати за допомогою моделі: до запуску й протягом усієї роботи потрібні розумні технічні й організаційні запобіжні заходи, механізм повідомлень про порушення, оперативне розслідування та видалення, вимкнення або блокування повторних порушників.

**Торговельні марки та права (VI)**
- **VI.1:** похідні роботи й похідні моделі, які ви створюєте, належать вам (з урахуванням прав MiniMax). **VI.2:** назви й знаки MiniMax не ліцензуються (понад те, що потрібно для опису та поширення); знак "MiniMax H3" можна використовувати лише на виконання III.3 і лише на території; не створюйте враження зв'язку з MiniMax.
- **VI.3:** якщо ви подаєте позов до MiniMax чи до будь-кого, стверджуючи, що матеріали чи результати порушують ваші права, усі ваші ліцензії припиняються того самого дня; ви захищаєте MiniMax і відшкодовуєте їй збитки за вимогами третіх осіб, що виникли з вашого чи чужого використання та поширення.
- **VI.4:** MiniMax не заявляє прав на результати; ви та ваші користувачі відповідаєте за результати та їх використання.

**Відмова від гарантій і припинення (VII, VIII, IX)**
- **VII.1:** немає зобов'язання підтримувати й оновлювати. **VII.2:** модель і результати надаються "AS IS", без гарантій; ви самі вирішуєте, чи вони підходять, і берете ризик на себе. **VII.3:** MiniMax і афілійовані особи не відповідають за жодну шкоду (у межах, дозволених законом).
- **VIII.1:** набирає чинності з прийняттям або отриманням доступу. **VIII.2:** у разі порушення MiniMax може розірвати ліцензію; ви зобов'язані припинити використання й поширення, видалити копії та повідомити отримувачів (VI.1, VI.3, VII, IX зберігають силу).
- **IX:** право Гонконгу (САР); виключна юрисдикція судів Гонконгу (Конвенцію ООН про купівлю-продаж CISG виключено).
- **Додаткова примітка:** енкодер MiniMax H3 використовує Qwen3-VL-32B (Apache 2.0).

**Політика прийнятного використання (Exhibit A)** (НЕ використовуйте модель, похідні та результати для такого)
- A-1 використання поза територією; A-2 порушення законів чи інтелектуальної власності третіх осіб; A-3 заподіяння шкоди собі чи іншим; A-4 перепрофілювання чи поширення результатів на шкоду; A-5 обхід захисних заходів; A-6 експлуатація чи заподіяння шкоди неповнолітнім; A-7 завідомо хибна інформація, щоб зашкодити іншим чи вплинути на вибори; A-8 фальшива онлайн-активність (фальшиві відгуки тощо); A-9 наклеп, приниження, переслідування; A-10 шкідливе ПЗ; A-11 персональні дані на шкоду іншим; **A-12 публікація контенту в будь-якому публічному середовищі (зокрема дописи ботів) без чіткого й помітного зазначення, що його створено машиною**; A-13 вдавання з себе іншу особу без згоди; A-14 автоматизовані рішення з високим ризиком у критичних галузях (правоохоронна діяльність, міграція, охорона здоров'я, критична інфраструктура, кредитування, працевлаштування, житло, освіта, соціальний рейтинг, страхування тощо); A-15 порушення соціальних, етичних, моральних норм інших країн і регіонів; A-16 насильницький екстремізм і тероризм; A-17 дискримінація чи шкода за захищеними ознаками; A-18 експлуатація вразливих груп; **A-19 військові цілі**; A-20 несанкціонована чи неліцензована професійна діяльність (фінансова, юридична, медична тощо).
- Примітка: це стислий виклад простою мовою; у разі сумнівів пріоритет має англійський текст ліцензії.

## Мітки доказовості

Єдиний набір для всіх документів (старі написання в дужках):
- **[виміряно]** (TR: ölçtüm, olctum): виконано в цьому проєкті, шлях до доказу існує.
- **[прочитано]** (TR: okudum yol, okudum): джерело чи скрипт прочитано, але не запускалося.
- **[за задумом]** (TR: tasarım, tasarim): так задумано, але в справжньому прогоні поки не бачили.
- **[припущення]** (TR: tahmin): не перевірено.
- **[не пробували]** (TR: denenmedi): ніколи не запускалося.
- **[зі слів користувача]** (TR: kullanıcı bildirdi): повідомив користувач, із датою; незалежно не виміряно.
- **[обчислено]** (TR: hesap; старі написання: calculated, hesap): число, виведене з виміряних даних, але саме не виміряне; виведення записано поруч. [proposal] / [öneri] у старому тексті = [припущення].

Назви прогонів у квадратних дужках (наші власні назви, це не файли репозиторію): U209 = 209 кадрів на релізному бінарнику через `uret.ps1`; B209 і B192 = прогони «зображення у відео» (`-InitImg`) на 209 і 192 кадрах; B56VT2 = релізний бінарник, 56 кадрів, порівняння з побайтовим еталоном R0 на 56 кадрах; F209b, F209V2, F209V2K = прогони на 209 кадрів на збірці для розробки (подробиці: `docs/OLCUMLER.md`).

## Відомі обмеження
- **Побайтовий доказ** (як відтворити самому: `docs/KANITLAR.md`, «R0 ve latent referansi nasil uretilir»; перевірено на нашій карті sm_61, на інших GPU побайтового збігу може не бути [припущення]): з нашою серією патчів (прапорці пам'яті ввімкнено) прогін на 56 кадрів дав sha256 `0979f156d548169b...`, ідентичний еталону [виміряно]; на 141 кадрі sha256 латента `E5D028F8632BE4FE...` збігся (з прапорцями 0013/0014). Для кадрів від 158 до 209 прямого байтового еталона немає; доказом слугує ланцюжок перевірок. Проходження числових перевірок не гарантує добрий кліп: узгодженість руху в часі перевіряється на око (див. `docs/KAPILAR.md`).
- **209 кадрів, який набір прапорців:** докази побайтового ланцюжка на 209 кадрах отримано з набором прапорців F209V2 на збірці для розробки (без прапорців хвоста блоків, зібрано без патчів 0019/0020); `uret.ps1` використовує цей рецепт для 209 кадрів [прочитано: скрипт; справжній прогін рушія через `uret.ps1` пройдено в прогоні U209].
- Перевірено нами на одній карті (GTX 1050 Ti 4 GB); зовнішні звіти про інші карти перелічено з їхніми мітками в `docs/KART_PROFILLERI.md` [зі слів користувача].
- **Який бінарник вимірювали:** латент на 141 кадрі та побайтовий ланцюжок виміряно на наших збірках для розробки. Релізний бінарник, який ви завантажуєте, зібраний заново: його побайтову перевірку на 56 кадрів пройдено (наступний пункт), а прогін на 209 кадрів через `uret.ps1` пройшов перевірку (прогін U209, 3414 с, пік VRAM 3777 MiB) [виміряно]; відносно прогону на 209 кадрів на збірці для розробки латент збігається побайтово; у відео кадри (md5) і звук ідентичні, sha256 файлу AVI відрізняється через контейнер [виміряно] (див. `docs/OLCUMLER.md`, розділ 0).
- **Релізний бінарник, 56 кадрів:** релізний бінарник (sd-cli `c5cebe78...`, stable-diffusion.dll `e5d3d329...`) дав результат на 56 кадрів, побайтово ідентичний R0 (sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`; md5 кожного кадру та звук ідентичні); запуск напряму з типовими прапорцями (без змінних `SD_*`), код виходу 0, 601 с [виміряно: прогін B56VT2, 2026-11-19; докази зберігають автори, у цьому репозиторії їх немає]. Межі: лише наша карта sm_61 і 56 кадрів; це не тест встановлення в чисту теку; латент на 141 кадрі та ланцюжок на 209 вимірювали на старішому бінарнику і на цьому НЕ повторювали [не пробували]. Перша спроба (B56VT, через допоміжний скрипт) тихо завершилася за 58 с, причина невідома [припущення: брак пам'яті]; друга спроба запускала `sd-cli` напряму.
- Скрипти встановлення й запуску ще не перевірені з порожньої теки (тест у чистій теці попереду).
- Дорожня карта й наступні кроки: `ROADMAP.md`.

## Статус і обмеження
- Перевірено на одній машині (GTX 1050 Ti 4 ГБ, 16 ГБ RAM, i7-7700HQ). Інші карти на 4 ГБ й інші обсяги RAM можуть поводитися інакше.
- **Типово 209 кадрів (8.7 с):** пройшли наші перевірки якості (шум 1.08, прогін F209V2K) [виміряно: 209 кадрів на релізному бінарнику через `uret.ps1`, прогін U209; латент побайтово збігся з прогоном на збірці для розробки; кадри й звук у відео ідентичні, sha файлу відрізняється через контейнер; докази зберігають автори, у цьому репозиторії їх немає]. На 209 кадрах пік VRAM у DiT становив 3777 MiB із 4096 MiB (прогони F209b і U209; показання `nvidia-smi` по всій карті), запас малий: інше навантаження на GPU (дисплей, інші застосунки) може призвести до збою на `blocks.0`; перевірено лише на GTX 1050 Ti. Стан дисплея під час того прогону не записували; якщо дисплей працює від цієї карти, VRAM доступно менше [припущення: навантаження Windows на дисплей близько 100-300 MB]; за потреби підключіть дисплей до вбудованої графіки [порада, не перевірено]. Семплінг тривав 2730 с (прогін U209: кроки по 436-483 с), а декодування VAE в окремому процесі 173 с (етап 2 разом 193 с із декодуванням звуку) [виміряно: релізний бінарник у U209; старіші прогони на збірці для розробки: 2664 с і 174 с]. На етапі 1 VAE в основному процесі вичерпав пам'ять і відкотився на часовий тайлінг (320 с); цей результат відкидається, відео береться з етапу 2 без тайлінгу. Пік RAM у U209 не вимірювали. Кліпи довші за 209 кадрів у цей реліз не входять.
- **Зображення у відео (`-InitImg`):** з початковим зображенням межа на цій GPU 192 кадри (8.0 с при 24 fps): 209 кадрів не вмістилися (не вистачило близько 17.5 MB VRAM на блоці 0: потрібно 2587 MB, доступно 2570 MB); 192 кадри пройшли через `uret.ps1` за 3086 с з піком VRAM 3783 MiB, перевірку пройдено [виміряно: прогони B209 і B192, 2026-11-20, одна сцена; докази зберігають автори, у цьому репозиторії їх немає]. На інших GPU не пробували [не пробували].
- **Вільна RAM має значення:** потрібно близько 11 ГБ ВІЛЬНОЇ RAM (процес рушія займає близько 11 ГБ) [виміряно]. За браку вільної RAM процес може завершитися без повідомлення про помилку [припущення: ми бачили таке один раз при близько 300 MB вільної RAM, коли `sd-cli` займав близько 10 ГБ]. Не відкривайте під час роботи інші важкі програми: на машині з 16 ГБ вільними лишаються лише близько 0.3-0.5 ГБ, і за браку пам'яті прогін може тихо вмерти. Перед запуском закрийте браузери, ігри та інші важкі програми й перевірте вільну RAM.
- **Тест у чистій теці попереду:** скрипти встановлення й запуску ще не перевірені з порожньої теки лише за цією інструкцією; розділ буде оновлено, коли цей тест (зокрема побайтове порівняння 56 кадрів з еталоном) буде записано.
- Згенеровані відео тут не постачаються.

<!-- i18n-source: README.md sha256:4d4973e30a37 -->
