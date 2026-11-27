# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · Русский · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

Переводы следуют этому английскому README. Если перевод расходится с ним или отстаёт, главным считается английский текст, особенно для текста о лицензии и безопасности ([`SECURITY.md`](SECURITY.md) и [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) ведутся только на английском и турецком).

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **Перед началом (лицензия, территория):** этот репозиторий под лицензией MIT и содержит только патчи и скрипты. Загружаемая им модель MiniMax H3 распространяется по MiniMax H3 Community License: её территория не включает Европейский союз, Великобританию, Южную Корею и США, а модель, производные **и результаты (созданные вами видео)** там нельзя использовать, распространять или показывать (V.4). Коммерческое использование разрешено в рамках условий лицензии. Прочитайте [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) до установки; это не юридическая консультация.

> **Коротко (за 30 секунд):** видеокарта с 4 ГБ памяти может за один проход сделать видео MiniMax H3 в 209 кадров (8.7 с): проверено на одной машине (GTX 1050 Ti 4 ГБ; полная установка `kur.ps1` в пустую папку от начала до конца ещё не проверена) [измерено: 209 кадров на релизном бинарнике через `uret.ps1`, прогон U209; латент побайтово совпал с прогоном на сборке для разработки; кадры и звук в видео идентичны, sha файла отличается из-за контейнера; доказательства хранятся у авторов, в этом репозитории их нет]; с `-InitImg` (изображение в видео) не больше 192 кадров (8.0 с) [измерено: прогон B192]; 209 кадров занимают около 57 мин, лимит времени по умолчанию 80 мин [измерено: прогон U209]; 3 шага ниже показывают, как это запустить.

VideoTurko: патчи памяти для stable-diffusion.cpp и рецепты запуска MiniMax H3 (текст в видео) на 4-гигабайтной GTX 1050 Ti, до 209 кадров (8.7 с) за один проход; изображение в видео (`-InitImg`) до 192 кадров (8.0 с) (209 кадров подтверждены цепочкой побайтовых проверок; на проверках в 56 и 141 кадр результат побайтово совпал с непропатченным прогоном).

## Быстрый старт (Windows, 3 шага)
**Статус: скрипты установки и запуска ниже ещё дорабатываются, тест в чистой папке не пройден; пока он не пройден, мы не утверждаем, что здесь всё работает (см. «Статус и ограничения»).**

1. **Скачайте** этот репозиторий (зелёная кнопка **Code**, затем **Download ZIP**) и распакуйте в КОРОТКИЙ путь, например `C:\vt`.
2. **Установка: дважды щёлкните `kur.cmd`** (откроется чёрное окно и покажет каждый шаг; если закрыть его, установка остановится, а при повторном запуске продолжится с того же места: наполовину скачанный файл модели докачивается [прочитано: скрипт загрузки хранит файл `.part` и продолжает с него; полная докачка 29 GiB не измерялась]). Если Windows предупреждает о скачанном файле, используйте вместо этого команду PowerShell ниже [совет, на скачанном ZIP не проверялось]. Предпочитаете командную строку? Откройте PowerShell в этой папке (введите `powershell` в адресной строке проводника) и выполните ту же установку:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   Корень установки — папка, в которую вы распаковали архив (движок попадает в `engine\bin`, модели в `model`); чтобы выбрать другое место, заранее задайте переменную окружения `VT_ROOT`. Скрипт проверяет GPU, драйвер, RAM и диск, скачивает движок и модели (для zip-архивов движка и заново скачанных файлов моделей проверяется sha256; файл модели, который уже лежит на месте и совпадает по размеру, проверяется только по размеру, а полную проверку sha256 запускает `scripts\modelleri_indir.ps1 -Dogrula`), делает короткую настоящую проверку и печатает READY, только если она прошла [по замыслу: `kur.ps1` целиком в чистой папке не запускался; эта фраза будет обновлена после теста в чистой папке]. `-ExecutionPolicy Bypass` действует только на этот один процесс; как и любой установщик, сначала прочитайте `scripts\kur.ps1`.
   Zip-архив движка скачивается из релиза v0.1.0 на GitHub (опубликован 2026-11-19; его sha256 зафиксирован в `kur.ps1`). Без интернета или с собственной сборкой передайте локальные zip-файлы: `-MotorZip <path> -CudaZip <path>`. Локальный zip проверяется по тому же зафиксированному sha256 (файл `.sha256` рядом игнорируется), поэтому это должен быть zip из релиза; для собственной сборки сначала задайте в `VT_MOTOR_SHA256` / `VT_CUDA_SHA256` её sha256. Неверный sha256 останавливает скрипт с кодом 1. В `engine\bin` попадают только `.exe` и `.dll`; лицензии и README кладутся в `engine\lisanslar\<zip name>\`. [пробовали на dist-архивах до релиза: `.sha256` рядом плюс предупреждение о том, что файл ссылается сам на себя, бинарник и DLL разложены, `sd-cli --help` отработал; sha установленных бинарников совпали (`c5cebe78...`, `e5d3d329...`); шаг с моделями и проверку на 5 кадров в `kur.ps1` на настоящей GPU ЕЩЁ НЕ запускали]
   **Лицензия модели:** перед шагом с моделями установщик печатает краткое содержание лицензии (`docs/LISANS_KABUL.txt`, полный текст `docs/LISANS_UYARISI.md`: MiniMax H3 Community License, территориальные ограничения, которые распространяются и на сгенерированные видео, правила коммерческого использования и маркировки ИИ) и просит согласиться (`E` = да). Сначала прочитайте её. Для запуска без вмешательства можно передать `-LisansKabul E`: это значит, что вы сами прочли лицензию и приняли её; не добавляйте этот флаг за другого человека. (ИИ-агентам: следуйте `AGENTS.md`; никогда не вводите E без согласия пользователя.) Без согласия `kur.ps1` останавливается с кодом выхода 2 и не скачивает ни одной модели.
3. **Ваше первое видео (56 кадров, около 11 мин на нашей GTX 1050 Ti** [измерено: 641 с, запуск R0, `docs/OLCUMLER.md`; другие видеокарты не измерялись]**)**: когда установщик выведет `HAZIR / READY`, выполните
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (быстрый путь: перетащите текстовый файл с промптом на `uret.cmd` или выполните `uret.cmd docs\ornek_istem_R0.txt`: тот же запуск на 56 кадров). Видео лежит в `runs\`. Затем запишите свой промпт в текстовый файл (один абзац на английском, необязательная фраза `audio:`) и запустите самый длинный клип из тех, что мы покрываем (по умолчанию, около 57 мин [измерено: запуск U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   `-Kare` следует сетке 17k+5 (56, 73, ... 192, 209); по умолчанию 209 (8.7 с), наибольшая длина, которую мы покрываем. VAE работает в отдельном процессе и никогда не использует тайлинг [настоящий прогон движка через `uret.ps1` на релизном бинарнике, VAE в отдельном процессе, пройден в прогоне U209].

   Руководство по написанию промпта: [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (шаблон одного непрерывного кадра, равные отрезки времени, два полных примера).

| Требование | Значение |
|---|---|
| ОС | Windows 10/11, 64-бит |
| GPU | NVIDIA, 4 ГБ или больше; проверено только на GTX 1050 Ti (sm_61); запас мал (3777/4096 MiB на 209 кадрах): занятый экран или браузер могут сорвать прогон; другие карты на 4 ГБ не пробовали |
| RAM | 16 ГБ (пик около 11 ГБ; закройте другие программы) |
| Диск | не менее 32 GiB свободно (рекомендуется 40 GiB и больше: при 32–40 установщик выводит предупреждение, `[VT-W-DISK-PAY]` [измерено: запуски `-Kuru` с имитацией диска]), модели на SSD (лучше NVMe) |
| Загрузка | zip движка 36.8 MB + zip среды CUDA 567.5 MB [измерено] + модели 31,473,112,040 байт (около 29.3 GiB) [прочитано: размеры в `scripts/modeller.json`]; всего около 30 GiB |
| Модели | не входят в репозиторий; установщик скачивает их по лицензии MiniMax (см. предупреждение ниже). Модели (29.3 GiB, 31,473,112,040 байт в `scripts/modeller.json`) не лежат ни в этом репозитории, ни в релизе: действуют ограничения GitHub на размер файлов и релизов, а `kur.ps1` скачивает их с официального источника с проверкой sha256. |

Коды выхода `kur.ps1`: 0 READY, 1 ошибка, 2 нужен ввод пользователя (лицензия или ещё нет релиза/zip), 3 недостаточно железа или диска, 4 остановлен (файл DUR). `uret.ps1` принимает прогон, только если `.avi` существует, число кадров верное, а логи чистые [измерено: один настоящий прогон через `uret.ps1` на релизном бинарнике, прогон U209, 209 кадров, проверка пройдена]. Коды выхода `uret.ps1`: 0 DONE (проверка качества пройдена), 1 ошибка или недопустимый результат (включая видео без звуковой дорожки), 2 остановлен (файл DUR), 5 `KAPI RED` (проверка качества не пройдена: клип не принят, решение за вами), 6 проверку не удалось выполнить (клип не принят). Подробности в AGENTS.md. [измерено: коды выхода 0, 1 (видео без звука), 5 и 6 в сценариях с поддельным движком и поддельной проверкой; на настоящем движке: код 0 в прогоне U209]

### Частые проблемы (подробнее: `docs/SIK_HATALAR.md`)
Строки ошибок наших скриптов содержат стабильный код, например `HATA: [VT-E-DLL] ...` или `UYARI: [VT-W-DISK-PAY] ...`. Найдите код в [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) (пример якоря `#vt-e-dll`) или в `docs/hata_imzalari.json` и укажите код в своём issue. Первый столбец таблицы ниже остаётся как напечатан (коды и текст логов не переводятся).

| Что вы видите | Что это значит и что делать |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | Не запускайте `sd-cli.exe` вручную; запустите `scripts\kur.ps1`, он раскладывает DLL CUDA по местам. |
| `failed during weight preparation` на `blocks.0` (#1, #3, #5) | Не хватило VRAM на проверке памяти: возьмите меньше кадров из сетки 17k+5, закройте другие программы, использующие GPU, оставьте флаги из поставки. |
| `retrying with temporal tiling` (#6) | VAE откатился на тайлинг; результат для оценки качества недействителен. Запустите ещё раз. |
| Прогон закончился по лимиту времени, видео нет (#7) | Увеличьте `-TavanDk` для длинных клипов (лимит по умолчанию: 80 мин для 209 кадров, задаётся в `uret.ps1`; наш прогон на 209 кадров занял 57 мин [измерено: прогон U209]). |
| Код выхода пустой, но написано «finished» (#14) | Обёртка прочитала код выхода слишком рано; запустите заново и проверьте, что файл видео существует. |
| Система тормозит, идёт подкачка (#18) | Движок занимает около 10-11 ГБ RAM; закройте браузеры и другие программы. |
| Несовпадение sha256 / загрузка не удалась | Обычно загрузка оборвалась: выполните ту же команду ещё раз, проверенные файлы будут пропущены. |

**Застряли или любопытно?** [`SUPPORT.md`](SUPPORT.md) (куда обращаться; сроки ответа это цели, а не обязательства) · [`PRIVACY.md`](PRIVACY.md) (без телеметрии; сеть используется только для загрузки движка и моделей с перечисленных хостов) · [`SECURITY.md`](SECURITY.md) (конфиденциальное сообщение) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (первый pull request за 5 шагов; для документов и скриптов GPU не нужна).

### Новое в v0.1.1: дополнительные параметры (подробнее: `AGENTS.md`, `docs/SIK_HATALAR.md` 19-23)
Если не использовать эти параметры, на карте с 4 ГБ ничего не меняется (побайтовая проверка на 56 кадрах против нашего эталона снова пройдена с v0.1.1 [измерено]). Чтобы увидеть, что будет запущено, добавьте `-Kuru` к любой команде.
- `-EndImg`: задаёт ещё и последний кадр (первый и последний кадр, «FLF»); предел 175 кадров на картах меньше 8 ГБ (192 кадра не поместились в 4 ГБ), 192 на картах от 8 ГБ. На нашей GTX 1050 Ti всегда работает в двух процессах: 56 кадров за 1040 с, 175 кадров за 2887 с (48 мин), оба прогона прошли проверку качества [измерено]. Советы по промпту: `docs/ISTEM_YAZIMI.md`.
- `-W` / `-H`: другие размеры, например вертикальный 384x640; кратно 32, площадь не меньше 640x384 (меньше нельзя). На 4 ГБ не проверялось; на картах меньше 8 ГБ размеры, превышающие наш самый большой измеренный прогон, отклоняются. Пороги проверки качества откалиброваны под 640x384.
- `-TekAsama`: один процесс вместо двух, только для больших карт; сам никогда не включается.
- Более новые GPU (compute capability 7.0+, например RTX 20/30/40): `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` задаётся автоматически, если вы не задали его сами; это устранило полностью чёрное видео начиная со 141 кадра на RTX 4070 Ti автора отчёта [со слов пользователя, issue #1]. Без Python + OpenCV `uret.ps1` теперь останавливается с кодом выхода 6 ещё до задачи на GPU (видео не создаётся, вводящего в заблуждение RED нет).
- Спасибо @SinanC73 за отчёт с RTX 4070 Ti, который привёл к этим изменениям ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1)).

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

## Необязательные профили скорости (пакет скорости; по умолчанию выключены)
Ничто из нижеследующего не меняет запуск по умолчанию (640x384, 209 кадров, 3414 с на нашей видеокарте). Это три измеренные ячейки сверх него, каждая — именованный профиль `uret.ps1`; им нужен движок пакета скорости (движок релиза плюс патчи 0021, 0023, 0024, все по умолчанию выключены: `docs/YAMALAR.md`). Установите его командой `scripts\kur.ps1 -HizPaketi` (локальный zip работает с `-MotorZip`), затем добавьте `-Profil <name>`; `-Kuru` выводит, что было бы запущено.

| Профиль | Размер, длина | Общее время на GTX 1050 Ti 4 GB | Статус |
|---|---|---|---|
| (нет, по умолчанию) | 640x384, до 209 кадров (8,7 с) | 209 кадров: 3414 с | проверено, без изменений |
| `yuksek832` | 832x480, 141 кадр (5,9 с) | около 55-56 мин | пригоден, два промпта [измерено] |
| `yuksek832 -Kare 124` | 832x480, 124 кадра (5,2 с) | около 45-46 мин, флаг скорости не нужен | пригоден, два промпта [измерено] |
| `yuksek896` | 896x512, 124 кадра (5,2 с) | около 56-57,5 мин | пригоден, два промпта [измерено] |
| `uzun260` | 640x384, 260 кадров (10,8 с) | 78 мин измерено без раннего выхода; с ним около 71-72 мин [предположение: сквозным запуском через `uret.ps1` не измерялось] | условный и экспериментальный |

- **Узкий запас:** при 832x480 x 141 шлюз памяти оставляет однозначный запас в МБ (5,7 и 6,8 МБ в двух полных запусках). Два длинных промпта (1520 и 2041 символ) проверены только чтением шлюза для шага 1 и части шага 2, без полного запуска: запас 10,9 и 4,0 МБ. Любой другой процесс, занимающий память видеокарты (браузер, второй монитор), может привести к сбою; тогда используйте `-Kare 124` или размер по умолчанию [измерено, GTX 1050 Ti 4 GB].
- **`uzun260` условный:** лимит памяти очень узкий (пик VRAM 3903 из 4096 MiB), использование общей памяти выросло на 61 и 68 MiB, а эталона без флагов для побайтового равенства нет, поэтому он не предлагается как обычная возможность. Патч 0023 принят только для этой одной ячейки.
- **Не предлагается:** 832x480 при 158 или 175 кадрах не помещается; поиск длины там закончился на 141 кадре. Другие размеры и числа кадров `-Profil` отклоняет (пользуйтесь путём по умолчанию).
- Качество по умолчанию не тронуто: 6 шагов, cfg 1, VAE без тайлов, 17k+5 кадров. Где флаги включены, вывод сравнивали побайтно с видео без флагов на тех размерах, где запуск без флагов помещается (`docs/YAMALAR.md`); при 832x480 x 141 и 896x512 x 124 запуск без флагов не помещается, поэтому равенство там опирается на ближайшие ячейки, а не на прямое сравнение [измерено, прочитано].
- Этап 1 двухэтапного запуска теперь завершается, как только файл латентов полностью готов (`VT_ERKEN_CIKIS=0` это отключает).

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

## Что это такое
Набор небольших патчей памяти и планирования для stable-diffusion.cpp плюс рецепт запуска, проверки и измерения, благодаря которым MiniMax H3 (DiT на 33B; мы запускаем GGUF HyperFlow Flash 13.7B Q4_K_M; текстовый энкодер Qwen3-VL на 32B отдельный) работает на 4-гигабайтной GPU поколения Pascal (GTX 1050 Ti, 16 ГБ системной памяти).
- Длины за один проход, которые мы действительно получили и которые прошли наши проверки качества: 56, 141, 158, 175, 192, 209 кадров при 640x384 и 24 fps (209 кадров = 8.7 с), со звуком, который генерирует сам H3 [измерено: 209 кадров на релизном бинарнике через `uret.ps1`, прогон U209; латент побайтово совпал с прогоном на сборке для разработки; кадры и звук в видео идентичны, sha файла отличается из-за контейнера; доказательства хранятся у авторов, в этом репозитории их нет]. 209 — самая большая длина, которую мы смотрели и сочли плавной [со слов пользователя, 2026-11-19, видео просмотрено целиком; файл: результат F209V2, 8.708 с].
- **Заявление о побайтовом совпадении, честно по границам:** побайтовое совпадение с непропатченным эталоном проверено только для 56 и 141 кадров. Для 158/175/192/209 кадров мы использовали те же флаги и ту же цепочку бинарников; прямого байтового эталона нет (непропатченная сборка не может запустить такие длины на этой GPU).
- Настройки качества никогда не снижаются: та же модель и квантование, 6 шагов, cfg 1, 640x384, тот же seed, VAE без тайлинга.
- Мы не заявляем, что мы первые: мы искали и не нашли внешних примеров этого на 4 ГБ, но это не доказательство того, что их нет.

## Структура
- `patches/` патчи к зафиксированному коммиту stable-diffusion.cpp (см. заметки там)
- `scripts/` сборка, запуск, VAE в отдельном процессе, вспомогательные скрипты проверок и согласованности (`doku_norm.py`: см. примечание о шкале ниже)
- `docs/KURULUM.md` железо, сборка и запуск (EN+TR)
- `docs/YAMALAR.md` список патчей, `docs/KANITLAR.md` доказательства, `docs/KAPILAR.md` таблица проверок качества, `docs/OLCUMLER.md` измерения, `docs/SIK_HATALAR.md` частые ошибки, `docs/LISANS_UYARISI.md` полный перечень пунктов лицензии
- `scripts/` краткий указатель: `hiz_kos3.ps1` обёртка запуска (`-Kuru` печатает точную команду), `uretim_kapi.ps1` проверка качества, `dikis_denetim.py` проверка швов, `doku_norm.py` шум, нормированный на текстуру, `bayt_kiyas.py` побайтовое сравнение, `derleme_sablonu.ps1` шаблон сборки (останавливает только вспомогательный процесс телеметрии Visual Studio `vctip.exe`, запустившийся уже после начала самой сборки, который иначе держит процесс сборки привязанным на несколько минут; остальные процессы `vctip.exe` не трогает)

## Проверки качества (как принимается результат)

Эта проверка не контролирует согласованность движения (скачки масштаба или положения объектов): просмотрите видео целиком, прежде чем принимать его.
1. Число кадров верное и звук присутствует; в логе нет откатов по памяти и строк ALLOC_FAILED.
2. Проверка сырого шума: остаток после медианного фильтра <= 1.5 (шкала 0-255).
3. Шум, нормированный на текстуру, `scripts/doku_norm.py` (версия из этого репозитория): N = медианный остаток / текстура по Собелю, каждый 6-й кадр. **Примечание о шкале:** в этой версии 10 измеренных клипов дают N = 0.034-0.052 (таблица в `docs/KAPILAR.md`; на последней четверти F192/F209V2 достигает 0.062), а порог дополнительной проверки N <= 0.065. Другая реализация на тех же клипах дала 0.028-0.036, поэтому пороги НЕ взаимозаменяемы между версиями. На очень мелких текстурах (ряды травы) чистый N был 0.075, так что порог задаётся для каждого семейства сцен. Рекомендуемая дополнительная проверка: устойчивая оценка высоких частот (sigma-HH <= 1.5; чистые клипы 0.74-1.19, добавленный шум s=2 даёт 2.2-3.0).

Область: VideoTurko — про ОДИН проход (до 209 кадров, около 8,7 с). Наш собственный тест склейки показал видимые швы (сцена продолжается нечисто), поэтому более длинные фильмы не входят в то, что мы проверяем. Для склейки есть руководство сообщества `docs/KLIP_ZINCIRI.md` и наш помощник только для CPU `scripts/zincir.py` (`plan`, `son-kare`, `bagla`; он никогда не запускает движок); качество склеенных фильмов мы не измеряли [не пробовали], поэтому проверяйте каждый шов глазами и с помощью `scripts/dikis_denetim.py`.
Настройки ваши: 209 кадров — наше проверенное значение по умолчанию на 4-гигабайтной карте, а не предел, которым вы обязаны пользоваться. Выберите любое число кадров из сетки 17k+5 (56, 73, ... 192, 209; см. `docs/KURULUM.md`), меняйте промпт, seed, разрешение или любой флаг, как вам нужно. Более короткие клипы требуют меньше памяти и времени; на более мощных GPU может поместиться больше.

## Предупреждение о лицензии модели
**VideoTurko содержит только патчи и скрипты (MIT); тот, кто использует модель и её результаты, сам отвечает за соблюдение лицензии MiniMax.** Это не юридическая консультация. Ниже пункты MiniMax H3 Community License (2 августа 2026) в кратком изложении с номерами; обязательна сама лицензия: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

Лицензия MIT этого репозитория не распространяется на веса модели; см. [`NOTICE`](NOTICE). В этом репозитории НЕТ весов моделей (нет файлов MiniMax H3, GGUF HyperFlow-H3-Flash и VAE). Проект не связан с MiniMax и не одобрен ею. Коммерческое использование НЕ запрещено (это не некоммерческая лицензия); условия приведены ниже.

**Территория (Applicable Territory)**
- **Преамбула, I.3, I.5:** весь мир, КРОМЕ Европейского союза, Великобритании, Республики Корея и США. Использование модели означает принятие лицензии.
- **II:** безвозмездная, непередаваемая, ограниченная лицензия на использование, воспроизведение, распространение, создание производных работ и модификацию, только на территории и в соответствии с соглашением и Exhibit A. Лица из исключённых стран и регионов могут запросить у MiniMax отдельную лицензию.
- **V.4:** использование, воспроизведение, изменение, распространение или показ модели, её производных И РЕЗУЛЬТАТОВ (сгенерированного видео и звука) за пределами территории не разрешены. **Таким образом, публикация или показ сгенерированных видео в ЕС, Великобритании, Южной Корее и США выходит за рамки лицензии.**
- **Exhibit A-1:** использование за пределами территории нарушает Acceptable Use Policy.

**Распространение (III)** (этот репозиторий модель не распространяет; если распространяете вы)
- **III.1:** передайте каждому получателю копию лицензии. **III.2:** изменённые файлы пометьте заметными уведомлениями.
- **III.3:** Желательно (не обязательно): уведомление "Powered by MiniMax H3", идентификатор ИИ-генерации на созданных файлах, публичное описание работы.
- **III.4:** к распространению ОБЯЗАТЕЛЬНО прилагается файл NOTICE с текстом: "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12:** публикация контента в любой публичной среде без чёткого указания, что он создан машиной, запрещена: помечайте сгенерированные ИИ видео при публикации (полный список: `docs/LISANS_UYARISI.md`).
- **III (последний абзац):** вы можете добавить собственное авторское право на свои изменения, но не можете вводить дополнительные или иные условия использования и распространения; территориальные правила продолжают действовать.

**Коммерческие условия (IV)**
- **IV.1:** если ваши коммерческие продукты или сервисы приносят более 20 млн долларов США (или эквивалент) годового дохода, получите ПРЕДВАРИТЕЛЬНОЕ письменное разрешение по адресу api@minimax.io (тема письма "MiniMax H3 licensing - authorization request").
- **IV.2:** в интерфейсе коммерческого продукта или сервиса, использующего модель, должно быть заметно указано "MiniMax H3".

**Ограничения использования (V)**
- **V.1:** соблюдайте применимое право (включая требования торгового комплаенса) и Exhibit A. **V.2:** обяжите каждого, кому вы даёте доступ, условиями не менее защитными, чем эти ограничения, и уведомите его.
- **V.3:** нельзя использовать модель или её РЕЗУЛЬТАТЫ для улучшения любой другой ИИ-модели (кроме MiniMax H3 и её производных). (I.11: дистилляция и обучение на синтетических результатах делают модель «производной»; сами результаты производными не являются.)
- **V.5:** если вы предлагаете третьим лицам продукт, сервис или хостируемый сервис, генерирующий результаты с помощью модели: до запуска и на всём протяжении работы нужны разумные технические и организационные меры защиты, механизм жалоб, оперативное расследование и удаление, отключение или блокировка повторных нарушителей.

**Товарные знаки и права (VI)**
- **VI.1:** производные работы и производные модели, которые вы создаёте, принадлежат вам (с учётом прав MiniMax). **VI.2:** названия и знаки MiniMax не лицензируются (сверх необходимого для описания и распространения); знак "MiniMax H3" можно использовать только во исполнение III.3 и только на территории; не создавайте впечатления связи с MiniMax.
- **VI.3:** если вы подаёте иск к MiniMax или к кому-либо, утверждая, что материалы или результаты нарушают ваши права, все ваши лицензии прекращаются в тот же день; вы защищаете MiniMax и возмещаете ей убытки по требованиям третьих лиц, возникшим из вашего или чужого использования и распространения.
- **VI.4:** MiniMax не заявляет прав на результаты; вы и ваши пользователи отвечаете за результаты и их использование.

**Отказ от гарантий и прекращение (VII, VIII, IX)**
- **VII.1:** нет обязательства поддерживать и обновлять. **VII.2:** модель и результаты предоставляются "AS IS", без гарантий; вы сами решаете, подходят ли они, и принимаете риск на себя. **VII.3:** MiniMax и аффилированные лица не отвечают ни за какой ущерб (в пределах, допускаемых законом).
- **VIII.1:** вступает в силу с принятием или получением доступа. **VIII.2:** при нарушении MiniMax вправе расторгнуть лицензию; вы обязаны прекратить использование и распространение, удалить копии и уведомить получателей (VI.1, VI.3, VII, IX сохраняют силу).
- **IX:** право Гонконга (САР); исключительная юрисдикция судов Гонконга (Конвенция ООН о купле-продаже CISG исключена).
- **Дополнительное примечание:** энкодер MiniMax H3 использует Qwen3-VL-32B (Apache 2.0).

**Политика допустимого использования (Exhibit A)** (НЕ используйте модель, производные и результаты для следующего)
- A-1 использование за пределами территории; A-2 нарушение законов или интеллектуальной собственности третьих лиц; A-3 причинение вреда себе или другим; A-4 перепрофилирование или распространение результатов во вред; A-5 обход защитных мер; A-6 эксплуатация или причинение вреда несовершеннолетним; A-7 заведомо ложная информация, чтобы навредить другим или повлиять на выборы; A-8 фальшивая активность в сети (фальшивые отзывы и т. п.); A-9 клевета, унижение, преследование; A-10 вредоносное ПО; A-11 персональные данные во вред другим; **A-12 публикация контента в любой публичной среде (включая посты ботов) без чёткого и заметного указания, что он создан машиной**; A-13 выдача себя за другого без согласия; A-14 автоматические решения с высоким риском в критических областях (правоохранительная деятельность, миграция, здравоохранение, критическая инфраструктура, кредитование, трудоустройство, жильё, образование, социальный рейтинг, страхование и др.); A-15 нарушение социальных, этических, моральных норм других стран и регионов; A-16 насильственный экстремизм и терроризм; A-17 дискриминация или вред по защищённым признакам; A-18 эксплуатация уязвимых групп; **A-19 военные цели**; A-20 несанкционированная или нелицензированная профессиональная деятельность (финансовая, юридическая, медицинская и т. п.).
- Примечание: это краткое изложение простым языком; в случае сомнений приоритет имеет английский текст лицензии.

## Метки доказательности

Единый набор для всех документов (старые написания в скобках):
- **[измерено]** (TR: ölçtüm, olctum): выполнено в этом проекте, путь к доказательству существует.
- **[прочитано]** (TR: okudum yol, okudum): источник или скрипт прочитан, но не запускался.
- **[по замыслу]** (TR: tasarım, tasarim): так задумано, но в настоящем прогоне пока не видели.
- **[предположение]** (TR: tahmin): не проверено.
- **[не пробовали]** (TR: denenmedi): никогда не запускалось.
- **[со слов пользователя]** (TR: kullanıcı bildirdi): сообщил пользователь, с датой; независимо не измерено.
- **[расчёт]** (TR: hesap; старые написания: calculated, hesap): число, полученное из измеренных данных, но само не измеренное; вывод записан рядом. [proposal] / [öneri] в старом тексте = [предположение].

Названия прогонов в квадратных скобках (наши собственные названия, это не файлы репозитория): U209 = 209 кадров на релизном бинарнике через `uret.ps1`; B209 и B192 = прогоны «изображение в видео» (`-InitImg`) на 209 и 192 кадрах; B56VT2 = релизный бинарник, 56 кадров, сравнение с побайтовым эталоном R0 на 56 кадрах; F209b, F209V2, F209V2K = прогоны на 209 кадров на сборке для разработки (подробности: `docs/OLCUMLER.md`).

## Известные ограничения
- **Побайтовое доказательство** (как воспроизвести самому: `docs/KANITLAR.md`, «R0 ve latent referansi nasil uretilir»; проверено на нашей карте sm_61, на других GPU побайтового совпадения может не быть [предположение]): с нашей серией патчей (флаги памяти включены) прогон на 56 кадров дал sha256 `0979f156d548169b...`, идентичный эталону [измерено]; на 141 кадре sha256 латента `E5D028F8632BE4FE...` совпал (с флагами 0013/0014). Для кадров с 158 по 209 прямого байтового эталона нет; доказательством служит цепочка проверок. Прохождение числовых проверок не гарантирует хороший клип: согласованность движения во времени проверяется на глаз (см. `docs/KAPILAR.md`).
- **209 кадров, какой набор флагов:** доказательства побайтовой цепочки на 209 кадрах получены с набором флагов F209V2 на сборке для разработки (без флагов хвоста блоков, собрано без патчей 0019/0020); `uret.ps1` использует этот рецепт для 209 кадров [прочитано: скрипт; настоящий прогон движка через `uret.ps1` пройден в прогоне U209].
- Проверено нами на одной карте (GTX 1050 Ti 4 GB); внешние отчёты о других картах перечислены с их метками в `docs/KART_PROFILLERI.md` [со слов пользователя].
- **Какой бинарник измеряли:** латент на 141 кадре и побайтовая цепочка измерены на наших сборках для разработки. Релизный бинарник, который вы скачиваете, собран заново: его побайтовая проверка на 56 кадров пройдена (следующий пункт), а прогон на 209 кадров через `uret.ps1` прошёл проверку (прогон U209, 3414 с, пик VRAM 3777 MiB) [измерено]; относительно прогона на 209 кадров на сборке для разработки латент совпадает побайтово; в видео кадры (md5) и звук идентичны, sha256 файла AVI отличается из-за контейнера [измерено] (см. `docs/OLCUMLER.md`, раздел 0).
- **Релизный бинарник, 56 кадров:** релизный бинарник (sd-cli `c5cebe78...`, stable-diffusion.dll `e5d3d329...`) дал результат на 56 кадров, побайтово совпавший с R0 (sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`; md5 каждого кадра и звук идентичны); запуск напрямую с флагами по умолчанию (без переменных `SD_*`), код выхода 0, 601 с [измерено: прогон B56VT2, 2026-11-19; доказательства хранятся у авторов, в этом репозитории их нет]. Область: только наша карта sm_61 и 56 кадров; это не тест установки в чистую папку; латент на 141 кадре и цепочку на 209 измеряли на более старом бинарнике и на этом НЕ повторяли [не пробовали]. Первая попытка (B56VT, через вспомогательный скрипт) тихо завершилась через 58 с, причина неизвестна [предположение: нехватка памяти]; вторая попытка запускала `sd-cli` напрямую.
- Скрипты установки и запуска ещё не проверены из пустой папки (тест в чистой папке впереди).
- Дорожная карта и следующие шаги: `ROADMAP.md`.

## Статус и ограничения
- Проверено на одной машине (GTX 1050 Ti 4 ГБ, 16 ГБ RAM, i7-7700HQ). Другие карты на 4 ГБ и другие объёмы RAM могут вести себя иначе.
- **По умолчанию 209 кадров (8.7 с):** прошли наши проверки качества (шум 1.08, прогон F209V2K) [измерено: 209 кадров на релизном бинарнике через `uret.ps1`, прогон U209; латент побайтово совпал с прогоном на сборке для разработки; кадры и звук в видео идентичны, sha файла отличается из-за контейнера; доказательства хранятся у авторов, в этом репозитории их нет]. На 209 кадрах пик VRAM у DiT составил 3777 MiB из 4096 MiB (прогоны F209b и U209; показания `nvidia-smi` по всей карте), запас мал: другая нагрузка на GPU (дисплей, другие приложения) может привести к сбою на `blocks.0`; проверено только на GTX 1050 Ti. Состояние дисплея во время этого прогона не записывали; если дисплей работает от этой карты, VRAM доступно меньше [предположение: нагрузка Windows на дисплей около 100-300 MB]; при необходимости подключите дисплей к встроенной графике [совет, не проверено]. Сэмплирование заняло 2730 с (прогон U209: шаги по 436-483 с), а декодирование VAE в отдельном процессе 173 с (этап 2 в сумме 193 с вместе с декодированием звука) [измерено: релизный бинарник в U209; более старые прогоны на сборке для разработки: 2664 с и 174 с]. На этапе 1 VAE в основном процессе исчерпал память и откатился на временной тайлинг (320 с); этот результат отбрасывается, видео берётся с этапа 2 без тайлинга. Пик RAM в U209 не измеряли. Клипы длиннее 209 кадров в этот релиз не входят.
- **Изображение в видео (`-InitImg`):** с начальным изображением предел на этой GPU 192 кадра (8.0 с при 24 fps): 209 кадров не поместились (не хватило около 17.5 MB VRAM на блоке 0: нужно 2587 MB, доступно 2570 MB); 192 кадра прошли через `uret.ps1` за 3086 с с пиком VRAM 3783 MiB, проверка пройдена [измерено: прогоны B209 и B192, 2026-11-20, одна сцена; доказательства хранятся у авторов, в этом репозитории их нет]. На других GPU не пробовали [не пробовали].
- **Свободная RAM важна:** нужно около 11 ГБ СВОБОДНОЙ RAM (процесс движка занимает около 11 ГБ) [измерено]. При нехватке свободной RAM процесс может завершиться без сообщения об ошибке [предположение: мы видели такое один раз при около 300 MB свободной RAM, когда `sd-cli` занимал около 10 ГБ]. Не открывайте во время работы другие тяжёлые программы: на машине с 16 ГБ свободными остаются всего около 0.3-0.5 ГБ, и при нехватке памяти прогон может тихо умереть. Перед запуском закройте браузеры, игры и другие тяжёлые программы и проверьте свободную RAM.
- **Тест в чистой папке впереди:** скрипты установки и запуска ещё не проверены из пустой папки только по этой инструкции; раздел будет обновлён, когда этот тест (включая побайтовое сравнение 56 кадров с эталоном) будет записан.
- Сгенерированные видео здесь не поставляются.

<!-- i18n-source: README.md sha256:67497404d89b -->
