# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · Español · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

Las traducciones siguen este README en inglés. Si una traducción difiere o se queda atrás, el texto en inglés es el que vale, sobre todo para el texto de licencia y de seguridad ([`SECURITY.md`](SECURITY.md) y [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) se mantienen solo en inglés y turco).

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **Antes de empezar (licencia, territorio):** este repositorio es MIT y solo contiene parches y scripts. El modelo MiniMax H3 que descarga está bajo la MiniMax H3 Community License: su territorio excluye la Unión Europea, el Reino Unido, Corea del Sur y Estados Unidos, y el modelo, los derivados **y las salidas (los videos que generas)** no se pueden usar, distribuir ni mostrar allí (V.4). El uso comercial está permitido dentro de los términos de la licencia. Lee [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) antes de instalar; esto no es asesoramiento legal.

> **En 30 segundos:** una tarjeta gráfica de 4 GB puede generar un video MiniMax H3 de 209 fotogramas (8,7 s) en una sola pasada: verificado en una sola máquina (GTX 1050 Ti de 4 GB; la instalación completa con `kur.ps1` en una carpeta vacía aún no se ha verificado de principio a fin) [medido: 209 fotogramas con el binario de la versión publicada mediante `uret.ps1`, ejecución U209; latente idéntico byte a byte al de la ejecución con el binario de desarrollo; fotogramas y audio idénticos en el video, el sha del archivo difiere por el contenedor; las pruebas las conservan los autores, no están en este repositorio]; con `-InitImg` (imagen a video) como máximo 192 fotogramas (8,0 s) [medido: ejecución B192]; 209 fotogramas tardan unos 57 min, el límite de tiempo por defecto es de 80 min [medido: ejecución U209]; los 3 pasos de abajo explican cómo ejecutarlo.

> **¿Usa un agente de programación con IA (Codex, Claude Code, Gemini, Cursor)?** Dele esta única frase: «Lee `AGENTS_HIZLI.md` hasta el final, ejecuta primero `scripts\tani.ps1`, lleva tu progreso en `DURUM.md` y pregúntame antes de borrar o mover nada, cambiar el Python del sistema o el PATH, bajar un ajuste de calidad o aceptar la licencia del modelo por mí.» El agente diagnosticará este PC, escribirá una lista de comprobación y le preguntará en cada decisión; la licencia del modelo sigue siendo decisión suya.

VideoTurko: parches de memoria para stable-diffusion.cpp y recetas para ejecutar MiniMax H3 de texto a video en una GTX 1050 Ti de 4 GB, hasta 209 fotogramas (8,7 s) en una sola pasada; imagen a video (`-InitImg`) hasta 192 fotogramas (8,0 s) (209 fotogramas verificados mediante una cadena de bytes; idéntico byte a byte a la ejecución sin parches en las comprobaciones de 56 y 141 fotogramas).

## Inicio rápido (Windows, 3 pasos)
**Estado: los scripts de instalación y ejecución de abajo se están terminando y la prueba en raíz limpia está pendiente; no se afirma que nada de esto funcione hasta que esa prueba pase (consulta "Estado y límites").**

1. **Descarga** este repositorio (botón verde **Code**, luego **Download ZIP**) y descomprímelo en una carpeta CORTA, por ejemplo `C:\vt`.
2. **Instalar: haz doble clic en `kur.cmd`** (se abre una ventana negra que muestra cada paso; si la cierras, la instalación se detiene, y al ejecutarla de nuevo continúa donde quedó: un archivo de modelo descargado a medias se reanuda [leído: el script de descarga conserva un archivo `.part` y continúa desde él; una reanudación completa de 29 GiB no se midió]). Si Windows avisa sobre el archivo descargado, usa en su lugar el comando de PowerShell de abajo [recomendación, no probada con un ZIP descargado]. ¿Prefieres la línea de comandos? Abre PowerShell en esa carpeta (escribe `powershell` en la barra de direcciones del Explorador) y ejecuta la misma instalación:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   La raíz de instalación es la carpeta que descomprimiste (el motor va a `engine\bin`, los modelos a `model`); para usar otro lugar define antes la variable de entorno `VT_ROOT`. El script comprueba GPU, controlador, RAM y disco, descarga el motor y los modelos (los zip del motor y los archivos de modelo recién descargados se verifican con sha256; un archivo de modelo que ya existe con el tamaño correcto solo se verifica por tamaño, `scripts\modelleri_indir.ps1 -Dogrula` ejecuta la verificación sha256 completa), ejecuta una breve comprobación real e imprime READY solo si esa comprobación pasó [diseño: `kur.ps1` no se ha ejecutado completo en una carpeta limpia; esta frase se actualizará después de la prueba en carpeta limpia]. `-ExecutionPolicy Bypass` se aplica solo a este proceso; lee `scripts\kur.ps1` antes, como con cualquier instalador.
   El zip del motor viene de la versión v0.1.0 de GitHub (publicada el 2026-11-19; su sha256 está fijado en `kur.ps1`). Sin conexión o con tu propia compilación, indica zip locales: `-MotorZip <path> -CudaZip <path>`. Un zip local se comprueba con el mismo sha256 fijado (un archivo `.sha256` junto a él se ignora), así que debe ser el zip de la versión publicada; para tu propia compilación, define antes `VT_MOTOR_SHA256` / `VT_CUDA_SHA256` con su sha256. Un sha256 incorrecto se detiene con exit 1. Solo `.exe`/`.dll` van a `engine\bin`; las licencias y el README van a `engine\lisanslar\<zip name>\`. [probado con los zip de dist antes de la publicación: el `.sha256` adjunto más la advertencia autorreferencial, binario y DLL colocados, `sd-cli --help` se ejecutó; los sha de los binarios instalados coincidieron (`c5cebe78...`, `e5d3d329...`); el paso de modelos y la comprobación de 5 fotogramas de `kur.ps1` NO se han ejecutado aún en una GPU real]
   **Licencia del modelo:** antes del paso de modelos el instalador muestra el resumen de la licencia (`docs/LISANS_KABUL.txt`, texto completo `docs/LISANS_UYARISI.md`: MiniMax H3 Community License, límites territoriales que también cubren los videos generados, reglas comerciales y de etiquetado de IA) y te pide que aceptes (`E` = sí). Léela primero. Para ejecuciones desatendidas puedes pasar `-LisansKabul E`, lo que significa que la has leído y aceptado tú mismo; no lo añadas por otra persona. (Agentes de IA: sigan `AGENTS.md`; nunca escriban E sin el consentimiento del usuario.) Sin aceptación, `kur.ps1` se detiene con el código de salida 2 y no descarga ningún modelo.
3. **Tu primer video (56 fotogramas, unos 11 min en nuestra GTX 1050 Ti** [medido: 641 s, ejecución R0, `docs/OLCUMLER.md`; otras tarjetas no medidas]**)**: cuando el instalador imprima `HAZIR / READY`, ejecuta
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (atajo: arrastra un archivo de texto con el prompt sobre `uret.cmd`, o ejecuta `uret.cmd docs\ornek_istem_R0.txt`: la misma ejecución de 56 fotogramas). El video está en `runs\`. Después escribe tu propio prompt en un archivo de texto (un párrafo en inglés, frase `audio:` opcional) y ejecuta el clip más largo que cubrimos (por defecto, unos 57 min [medido: ejecución U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   `-Kare` sigue la cuadrícula 17k+5 (39, 56, 73, ... 192, 209); por defecto 209 (8,7 s), la duración más larga que cubrimos. El VAE se ejecuta en un proceso aparte, nunca por mosaicos [una ejecución real del motor mediante `uret.ps1` con el binario de la versión publicada, VAE en proceso aparte, pasó en la ejecución U209].

   Guía para escribir el prompt: [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (patrón de una toma continua, tramos de tiempo iguales, dos ejemplos completos).

| Requisito | Valor |
|---|---|
| SO | Windows 10/11, 64 bits |
| GPU | NVIDIA, 4 GB o más; probado solo en GTX 1050 Ti (sm_61); margen estrecho (3777/4096 MiB con 209 fotogramas): una pantalla o un navegador con mucha carga puede romper la ejecución; no se probó ninguna otra tarjeta de 4 GB |
| RAM | 16 GB (pico de unos 11 GB; cierra otros programas) |
| Disco | al menos 32 GiB libres (se recomiendan 40 GiB o más: entre 32 y 40 el instalador muestra un aviso, `[VT-W-DISK-PAY]` [medido: ejecuciones de `-Kuru` con disco simulado]), modelos en un SSD (mejor NVMe) |
| Descarga | zip del motor 36,8 MB + zip del runtime CUDA 567,5 MB [medido] + modelos 31.473.112.040 bytes (unos 29,3 GiB) [leído: tamaños en `scripts/modeller.json`]; unos 30 GiB en total |
| Modelos | no incluidos; los descarga el instalador bajo la licencia de MiniMax (consulta la advertencia de abajo). Los modelos (29,3 GiB, 31.473.112.040 bytes en `scripts/modeller.json`) no están en este repositorio ni en la versión publicada: se aplican los límites de tamaño de archivos y de versiones de GitHub, y `kur.ps1` los descarga de la fuente oficial con verificación sha256. |

Códigos de salida de `kur.ps1`: 0 READY, 1 error, 2 hace falta una acción del usuario (licencia, o aún no hay versión/zip), 3 hardware o disco insuficientes, 4 detenido (archivo DUR). `uret.ps1` acepta una ejecución solo si existe el `.avi`, el número de fotogramas es correcto y los registros están limpios [medido: una ejecución real mediante `uret.ps1` con el binario de la versión publicada, ejecución U209, 209 fotogramas, puerta superada]. Códigos de salida de `uret.ps1`: 0 DONE (puerta de calidad superada), 1 error o salida no válida (incluido un video sin pista de audio), 2 detenido (archivo DUR), 5 `KAPI RED` (puerta de calidad no superada: el clip no se acepta, la decisión es tuya), 6 la puerta no pudo ejecutarse (clip no aceptado). Detalles en AGENTS.md. [medido: códigos de salida 0, 1 (video sin audio), 5 y 6 en escenarios con un motor falso y una puerta falsa; motor real: exit 0 en la ejecución U209]

### Solución de problemas (detalles: `docs/SIK_HATALAR.md`)
Las líneas de error de nuestros scripts llevan un código estable, por ejemplo `HATA: [VT-E-DLL] ...` o `UYARI: [VT-W-DISK-PAY] ...`. Busca el código en [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) (ejemplo de ancla `#vt-e-dll`) o en `docs/hata_imzalari.json`, y pon el código en tu issue. La primera columna de la tabla de abajo se queda tal como se imprime (no traduzcas códigos ni texto de registros).

| Qué ves | Qué significa y qué hacer |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | No inicies `sd-cli.exe` a mano; ejecuta `scripts\kur.ps1`, que coloca las DLL de CUDA en su sitio. |
| `failed during weight preparation` en `blocks.0` (#1, #3, #5) | No hay suficiente VRAM en la puerta de memoria: usa menos fotogramas en la cuadrícula 17k+5, cierra otros programas que usen la GPU y conserva las opciones incluidas. |
| `retrying with temporal tiling` (#6) | El VAE recurrió a mosaicos; la salida no es válida a efectos de calidad. Ejecuta de nuevo. |
| La ejecución termina en el límite de tiempo, sin video (#7) | Aumenta `-TavanDk` para clips largos (límite de tiempo por defecto: 80 min para 209 fotogramas, fijado por `uret.ps1`; nuestra ejecución de 209 fotogramas tardó 57 min [medido: ejecución U209]). |
| Código de salida vacío pero "terminó" (#14) | El wrapper leyó el código de salida demasiado pronto; ejecuta de nuevo y comprueba que existe el archivo de video. |
| El sistema se ralentiza, usa el archivo de paginación (#18) | El motor usa unos 10-11 GB de RAM; cierra navegadores y otros programas. |
| sha256 no coincide / la descarga falló | Normalmente una descarga interrumpida: ejecuta el mismo comando otra vez, los archivos ya verificados se omiten. |

**¿Atascado o con curiosidad?** [`SUPPORT.md`](SUPPORT.md) (dónde preguntar; los plazos de respuesta son objetivos, no compromisos) · [`PRIVACY.md`](PRIVACY.md) (sin telemetría; la red solo se usa para descargar el motor y los modelos, desde los hosts listados) · [`SECURITY.md`](SECURITY.md) (reporte privado de vulnerabilidades) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (primer pull request en 5 pasos; no hace falta GPU para documentos y scripts).

### Novedades de la v0.1.1: más opciones (detalles: `AGENTS.md`, `docs/SIK_HATALAR.md` 19-23)
Sin estas opciones no cambia nada en una tarjeta de 4 GB (la comprobación byte a byte de 56 fotogramas contra nuestra referencia volvió a pasar con la v0.1.1 [medido]). Añade `-Kuru` a cualquier comando para ver qué se ejecutaría.
- `-EndImg`: indica también el último fotograma (primer y último fotograma, "FLF"); tope de 175 fotogramas en tarjetas de menos de 8 GB (192 no cupo en 4 GB), 192 en tarjetas de 8 GB o más. En nuestra GTX 1050 Ti siempre se ejecuta en dos procesos: 56 fotogramas en 1040 s, 175 fotogramas en 2887 s (48 min); ambos superaron la puerta [medido]. Recomendaciones para el prompt: `docs/ISTEM_YAZIMI.md`.
- `-W` / `-H`: otros tamaños, por ejemplo vertical 384x640; múltiplos de 32, área de al menos 640x384 (nunca menor). No probado en 4 GB; en tarjetas de menos de 8 GB se rechazan los tamaños que superan nuestra mayor ejecución medida. Los umbrales de la puerta de calidad están calibrados para 640x384.
- `-TekAsama`: un solo proceso en lugar de dos, solo para tarjetas grandes; nunca se activa automáticamente.
- GPU más recientes (compute capability 7.0+, p. ej. RTX 20/30/40): `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` se define automáticamente, salvo que lo definas tú; esto corrigió un video completamente negro a partir de 141 fotogramas en la RTX 4070 Ti de quien lo reportó [reportado por el usuario, issue #1]. Sin Python + OpenCV, `uret.ps1` ahora se detiene con exit 6 antes del trabajo en la GPU (no se genera video, sin un RED engañoso).
- Gracias a @SinanC73 por el reporte sobre la RTX 4070 Ti que llevó a estos cambios ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1)).

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

## Perfiles de velocidad opcionales (paquete de velocidad; desactivados por defecto)
Nada de lo siguiente cambia la ejecución por defecto (640x384, 209 fotogramas, 3414 s en nuestra tarjeta). Son tres celdas medidas más allá de ella, cada una un perfil con nombre de `uret.ps1`; necesitan el motor del paquete de velocidad (el motor de la release más los parches 0021, 0023 y 0024, todos desactivados por defecto: `docs/YAMALAR.md`). Instálelo con `scripts\kur.ps1 -HizPaketi` (un zip local funciona con `-MotorZip`) y luego añada `-Profil <name>`; `-Kuru` muestra lo que se ejecutaría. El paquete de velocidad se publica con la versión v0.1.4.

| Perfil | Tamaño, duración | Tiempo total en una GTX 1050 Ti 4 GB | Estado |
|---|---|---|---|
| (ninguno, por defecto) | 640x384, hasta 209 fotogramas (8,7 s) | 209 fotogramas: 3414 s | verificado, sin cambios |
| `yuksek832` | 832x480, 141 fotogramas (5,9 s) | unos 55-56 min | utilizable, dos prompts [medido] |
| `yuksek832 -Kare 124` | 832x480, 124 fotogramas (5,2 s) | unos 45-46 min, sin indicador de velocidad | utilizable, dos prompts [medido] |
| `yuksek896` | 896x512, 124 fotogramas (5,2 s) | unos 56-57,5 min | utilizable, dos prompts [medido] |
| `uzun260` | 640x384, 260 fotogramas (10,8 s) | unos 71 min [medido: 70,7 min de extremo a extremo con `uret.ps1`, con la salida anticipada; 78 min sin ella] | funciona cerca del límite de memoria; prompt medido hasta unos 2000 caracteres |

- **Margen estrecho:** a 832x480 x 141 la compuerta de memoria deja un margen de un solo dígito en MB (5,7 y 6,8 MB en las dos ejecuciones completas). Dos prompts largos (1520 y 2041 caracteres) solo se comprobaron leyendo la compuerta del paso 1 y parte del paso 2, sin ejecución completa: margen de 10,9 y 4,0 MB. Cualquier otro proceso que ocupe la memoria de la tarjeta (navegador, segunda pantalla) puede hacerlo fallar; entonces use `-Kare 124` o el tamaño por defecto [medido, GTX 1050 Ti 4 GB].
- **`uzun260` funciona cerca del límite de memoria:** pico de VRAM 3861-3903 de 4096 MiB. Tres ejecuciones completas (dos escenas); el uso de memoria compartida aumentó de 28 a 61 MiB frente a un límite de 68 MiB. Los prompts se midieron hasta 1403 caracteres en ejecuciones completas y hasta 2009 caracteres por lectura de la puerta; con 2527 caracteres se superó el límite de memoria compartida. No existe una referencia sin indicadores para la igualdad byte a byte con esta longitud. Cierre otros programas que usen la GPU; si una ejecución falla, use los 209 fotogramas predeterminados. El parche 0023 se acepta solo para esta celda.
- **No se ofrece:** 832x480 con 158 fotogramas no cabe con los parches incluidos (en la compuerta del paso 2 faltan unos 280 MB); 175 fotogramas solo se revisó leyendo la compuerta (faltaban unos 275 MB en el primer bloque, sin ejecución completa). El perfil ofrece únicamente 141 fotogramas. `-Profil` rechaza otros tamaños y números de fotogramas (use la ruta por defecto).
- La calidad por defecto no se toca: 6 pasos, cfg 1, VAE sin mosaicos, 17k+5 fotogramas. Donde los indicadores están activos, la salida se comparó byte a byte con el vídeo sin indicadores en los tamaños en que la ejecución sin indicadores cabe (`docs/YAMALAR.md`); a 832x480 x 141 y 896x512 x 124 la ejecución sin indicadores no cabe, así que la igualdad se apoya en las celdas más cercanas, no en una comparación directa [medido, leído].
- La etapa 1 de una ejecución en dos etapas termina ahora en cuanto el archivo latente está completo (`VT_ERKEN_CIKIS=0` lo desactiva).

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

## Qué es esto
Un conjunto de pequeños parches de memoria y planificación para stable-diffusion.cpp, junto con la receta de ejecución, las comprobaciones y las mediciones que permiten ejecutar MiniMax H3 (DiT de 33B; ejecutamos el GGUF HyperFlow Flash 13.7B Q4_K_M; el codificador de texto Qwen3-VL de 32B es aparte) en una GPU Pascal de 4 GB (GTX 1050 Ti, 16 GB de RAM del sistema).
- Duraciones en una sola pasada que producimos realmente y que superaron nuestras puertas de calidad: 56, 141, 158, 175, 192, 209 fotogramas a 640x384, 24 fps (209 fotogramas = 8,7 s), con el audio generado por el propio H3 [medido: 209 fotogramas con el binario de la versión publicada mediante `uret.ps1`, ejecución U209; latente idéntico byte a byte al de la ejecución con el binario de desarrollo; fotogramas y audio idénticos en el video, el sha del archivo difiere por el contenedor; las pruebas las conservan los autores, no están en este repositorio]. 209 es la duración más larga que vimos y que nos pareció fluida [reportado por el usuario, 2026-11-19, video visto completo; archivo: salida de F209V2, 8,708 s].
- **Afirmación de resultado idéntico byte a byte, con su alcance real:** las salidas se comprobaron idénticas byte a byte a la referencia sin parches solo con 56 y 141 fotogramas. Con 158/175/192/209 fotogramas usamos las mismas opciones y la misma cadena de binarios; no hay referencia directa byte a byte (la versión sin parches no puede ejecutar esas duraciones en esta GPU).
- La configuración de calidad nunca se reduce: mismo modelo/cuantización, 6 pasos, cfg 1, 640x384, misma semilla, VAE sin mosaicos.
- No afirmamos ser los primeros: buscamos y no encontramos ningún ejemplo externo de esto con 4 GB, lo cual no es prueba de que no exista.

## Estructura
- `patches/` parches sobre un commit fijo de stable-diffusion.cpp (consulta las notas allí)
- `scripts/` compilación, ejecución, VAE en proceso aparte, ayudas para puertas/consistencia (`doku_norm.py`: consulta la nota de escala más abajo)
- `docs/KURULUM.md` hardware, pasos de compilación y ejecución (EN+TR)
- `docs/YAMALAR.md` lista de parches, `docs/KANITLAR.md` pruebas, `docs/KAPILAR.md` tabla de puertas de calidad, `docs/OLCUMLER.md` mediciones, `docs/SIK_HATALAR.md` errores frecuentes, `docs/LISANS_UYARISI.md` todos los puntos de la licencia
- `scripts/` índice breve: `hiz_kos3.ps1` wrapper de ejecución (`-Kuru` imprime el comando exacto), `uretim_kapi.ps1` puerta de calidad, `dikis_denetim.py` comprobación de costuras, `doku_norm.py` ruido normalizado por textura, `bayt_kiyas.py` comparación byte a byte, `derleme_sablonu.ps1` plantilla de compilación (detiene solo el asistente de telemetría de Visual Studio `vctip.exe` que empezó después de su propia compilación, y que de otro modo mantiene el proceso de compilación enganchado durante minutos; los demás procesos `vctip.exe` no se tocan)

## Puertas de calidad (cómo se acepta un resultado)

Esta puerta no comprueba la consistencia del movimiento (saltos de escala o de posición de los objetos): mira el video completo antes de aceptarlo.
1. Número de fotogramas y audio presente; sin recurso a memoria alternativa ni líneas ALLOC_FAILED en el registro.
2. Puerta de ruido bruto: residuo del filtro de mediana <= 1,5 (escala 0-255).
3. Ruido normalizado por textura, `scripts/doku_norm.py` (la versión de este repositorio): N = residuo mediano / textura de Sobel, cada 6.º fotograma. **Nota de escala:** en esta versión los 10 clips medidos dan N = 0,034-0,052 (tabla en `docs/KAPILAR.md`; el último cuarto de F192/F209V2 llega a 0,062) y el umbral de la puerta adicional es N <= 0,065. Otra implementación midió 0,028-0,036 en los mismos clips, así que los umbrales NO son intercambiables entre versiones. En texturas muy finas (filas de césped) el N limpio fue 0,075, por lo que el umbral depende de la familia de escenas. Un estimador robusto de alta frecuencia (sigma-HH <= 1,5; limpio 0,74-1,19, con ruido añadido s=2 da 2,2-3,0) es la puerta adicional recomendada.

Alcance: VideoTurko trata de UNA sola pasada (hasta 209 fotogramas, unos 8,7 s). Nuestra propia prueba de encadenado mostró costuras visibles (la escena no continúa limpiamente), así que las películas más largas no forman parte de lo que verificamos. Para encadenar hay una guía de la comunidad, `docs/KLIP_ZINCIRI.md`, y nuestra utilidad solo CPU `scripts/zincir.py` (`plan`, `son-kare`, `bagla`; nunca inicia el motor); no medimos la calidad de las películas encadenadas [no probado], así que revise cada costura a ojo y con `scripts/dikis_denetim.py`.
Tu configuración es tuya: 209 fotogramas es nuestro valor por defecto probado en una tarjeta de 4 GB, no un límite que debas usar. Elige cualquier número de fotogramas de la cuadrícula 17k+5 (39, 56, 73, ... 192, 209; consulta `docs/KURULUM.md`), cambia el prompt, la semilla, la resolución o cualquier opción como prefieras. Los clips más cortos necesitan menos memoria y tiempo; las GPU más grandes pueden admitir más.

## Advertencia sobre la licencia del modelo
**VideoTurko contiene solo parches y scripts (MIT); quien use el modelo y sus salidas es el responsable de la licencia de MiniMax.** No es asesoramiento legal. A continuación se resumen, con su numeración, las cláusulas de la MiniMax H3 Community License (2 de agosto de 2026); la licencia en sí es la vinculante: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

La licencia MIT de este repositorio no cubre los pesos del modelo; consulta [`NOTICE`](NOTICE). Este repositorio NO contiene pesos del modelo (ni archivos de MiniMax H3, ni del GGUF HyperFlow-H3-Flash, ni del VAE). Este proyecto no está afiliado a MiniMax ni cuenta con su respaldo. El uso comercial NO está prohibido (no es una licencia no comercial); las condiciones están más abajo.

**Territorio (Applicable Territory)**
- **Preámbulo, I.3, I.5:** En todo el mundo, EXCLUYENDO la Unión Europea, el Reino Unido, la República de Corea y Estados Unidos. Usar el modelo cuenta como aceptar la licencia.
- **II:** Licencia limitada, intransferible y libre de regalías para usar, reproducir, distribuir, crear obras derivadas y modificar, solo dentro del territorio y conforme al acuerdo y al Exhibit A. Las personas de territorios excluidos pueden solicitar a MiniMax una licencia aparte.
- **V.4:** Usar, reproducir, modificar, distribuir o mostrar el modelo, sus derivados Y SUS SALIDAS (video/audio generado) fuera del territorio no está autorizado. **Por tanto, publicar o mostrar videos generados en la UE, el Reino Unido, Corea del Sur o EE. UU. queda fuera de la licencia.**
- **Exhibit A-1:** El uso fuera del territorio infringe la Acceptable Use Policy.

**Distribución (III)** (este repositorio no distribuye el modelo; si lo distribuyes tú)
- **III.1:** Entrega a cada destinatario una copia de la licencia. **III.2:** Marca los archivos modificados con avisos destacados.
- **III.3:** Se recomienda (no es obligatorio): un aviso "Powered by MiniMax H3", un identificador de generación por IA en los archivos producidos, un artículo público.
- **III.4:** Las distribuciones DEBEN ir acompañadas de un archivo NOTICE con: "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12:** está prohibido publicar contenido en cualquier entorno público sin revelar claramente que ha sido generado por una máquina: etiqueta los videos generados por IA al publicarlos (lista completa: `docs/LISANS_UYARISI.md`).
- **III (último párrafo):** Puedes añadir tu propio copyright a tus modificaciones, pero no puedes imponer términos adicionales o distintos sobre el uso/distribución; las reglas territoriales siguen aplicándose.

**Condiciones comerciales (IV)**
- **IV.1:** Si tus productos/servicios comerciales generan unos ingresos anuales superiores a 20 millones de USD (o su equivalente), obtén una autorización PREVIA por escrito en api@minimax.io (asunto "MiniMax H3 licensing - authorization request").
- **IV.2:** La interfaz de un producto/servicio comercial que use el modelo debe mostrar de forma destacada "MiniMax H3".

**Restricciones de uso (V)**
- **V.1:** Cumple la ley aplicable (incluido el cumplimiento comercial) y el Exhibit A. **V.2:** Somete a todas las personas a las que des acceso a términos al menos igual de protectores que estas restricciones y avísales.
- **V.3:** No puedes usar el modelo ni sus SALIDAS para mejorar ningún otro modelo de IA (aparte de MiniMax H3 y sus derivados). (I.11: la destilación y el entrenamiento con salidas sintéticas convierten un modelo en un "derivado"; las salidas en sí no son derivados.)
- **V.5:** Si ofreces a terceros un producto/servicio/servicio alojado que genere salidas con el modelo: antes y durante todo el funcionamiento, medidas técnicas y organizativas razonables, un mecanismo de denuncia, investigación diligente y retirada/desactivación/suspensión de los infractores reincidentes.

**Marcas y derechos (VI)**
- **VI.1:** Eres titular de las obras derivadas y los derivados del modelo que crees (sujeto a los derechos de MiniMax). **VI.2:** Los nombres/marcas de MiniMax no se licencian (más allá de lo necesario para describir y distribuir); la marca "MiniMax H3" solo puede usarse para cumplir III.3, dentro del territorio; no insinúes afiliación.
- **VI.3:** Si demandas a MiniMax o a cualquier otra persona alegando que los materiales/salidas infringen tus derechos, todas tus licencias terminan ese día; defiendes e indemnizas a MiniMax frente a reclamaciones de terceros derivadas del uso/distribución por tu parte o la de otros.
- **VI.4:** MiniMax no reclama derechos sobre las salidas; tú y tus usuarios son responsables de las salidas y de su uso.

**Exenciones de responsabilidad y terminación (VII, VIII, IX)**
- **VII.1:** Sin obligación de dar soporte ni de actualizar. **VII.2:** El modelo y las salidas se ofrecen "AS IS", sin garantías; tú decides si son adecuados y asumes el riesgo. **VII.3:** MiniMax y sus afiliadas no responden de ningún daño (en la medida en que la ley lo permita).
- **VIII.1:** Entra en vigor al aceptar/acceder. **VIII.2:** En caso de incumplimiento MiniMax puede dar por terminada la licencia; debes dejar de usar/distribuir, eliminar las copias y avisar a los destinatarios (VI.1, VI.3, VII, IX siguen vigentes).
- **IX:** Ley de la RAE de Hong Kong; jurisdicción exclusiva de los tribunales de Hong Kong (se excluye la CISG de la ONU).
- **Nota adicional:** el codificador de MiniMax H3 usa Qwen3-VL-32B (Apache 2.0).

**Política de uso aceptable (Exhibit A)** (NO uses el modelo, sus derivados ni sus salidas para)
- A-1 uso fuera del territorio; A-2 infringir leyes o la propiedad intelectual de terceros; A-3 dañarte a ti mismo o a otros; A-4 reutilizar/distribuir salidas para causar daño; A-5 eludir las salvaguardas; A-6 explotar/dañar a menores; A-7 información verificablemente falsa para dañar a otros o influir en elecciones; A-8 interacción falsa en línea (reseñas falsas, etc.); A-9 difamación, descrédito, acoso; A-10 malware; A-11 datos personales para dañar a otros; **A-12 publicar contenido en cualquier entorno público (incluidas publicaciones de bots) sin revelar de forma clara y destacada que ha sido generado por una máquina**; A-13 suplantación de identidad sin consentimiento; A-14 decisiones automatizadas de alto riesgo en ámbitos críticos (aplicación de la ley, inmigración, salud, infraestructuras críticas, crédito, empleo, vivienda, educación, puntuación social, seguros, etc.); A-15 infringir normas sociales, éticas o morales de otros países/regiones; A-16 extremismo violento/terrorismo; A-17 discriminación/daño por características protegidas; A-18 explotar a poblaciones vulnerables; **A-19 fines militares**; A-20 actividad profesional no autorizada/sin licencia (financiera, jurídica, médica, etc.).
- Nota: este es un resumen en lenguaje sencillo; en caso de duda prevalece el texto de la licencia en inglés.

## Etiquetas de evidencia

Un solo conjunto para todos los documentos (entre corchetes, las grafías antiguas):
- **[medido]** (TR: ölçtüm, olctum): ejecutado en este proyecto, existe la ruta de la prueba.
- **[leído]** (TR: okudum yol, okudum): se leyó la fuente o el script, no se ejecutó.
- **[diseño]** (TR: tasarım, tasarim): diseñado, aún no visto en una ejecución real.
- **[estimación]** (TR: tahmin): no verificado.
- **[no probado]** (TR: denenmedi): nunca se ejecutó.
- **[reportado por el usuario]** (TR: kullanıcı bildirdi): lo afirma el usuario, con fecha; no medido de forma independiente.
- **[calculado]** (TR: hesap; grafías antiguas: calculated, hesap): una cifra derivada de entradas medidas, no medida en sí; la derivación se escribe a su lado. [proposal] / [öneri] en textos antiguos = [estimación].

Nombres de ejecución usados entre corchetes (nuestros propios nombres de ejecución, no archivos de este repositorio): U209 = 209 fotogramas con el binario de la versión publicada mediante `uret.ps1`; B209 y B192 = ejecuciones de imagen a video (`-InitImg`) con 209 y 192 fotogramas; B56VT2 = binario de la versión publicada, 56 fotogramas, comparado con la referencia byte a byte de 56 fotogramas R0; F209b, F209V2, F209V2K = ejecuciones de 209 fotogramas con la compilación de desarrollo (detalles: `docs/OLCUMLER.md`).

## Limitaciones conocidas
- **Prueba byte a byte** (cómo reproducirla tú mismo: `docs/KANITLAR.md`, "R0 ve latent referansi nasil uretilir"; verificada en nuestra tarjeta sm_61, otras GPU pueden no ser idénticas byte a byte [estimación]): con nuestra serie de parches (opciones de memoria activadas) una ejecución de 56 fotogramas dio sha256 `0979f156d548169b...`, idéntico a la referencia [medido]; con 141 fotogramas el sha256 del latente `E5D028F8632BE4FE...` fue idéntico (con las opciones 0013/0014). Los fotogramas 158 a 209 no tienen referencia directa byte a byte; la cadena de puertas es la evidencia. Superar las puertas numéricas no garantiza un buen clip: la consistencia del movimiento en el tiempo se comprueba a ojo (consulta `docs/KAPILAR.md`).
- **209 fotogramas, con qué conjunto de opciones:** la evidencia de la cadena de bytes de 209 fotogramas se obtuvo con el conjunto de opciones F209V2 en la compilación de desarrollo (sin opciones de cola de bloque, compilada sin los parches 0019/0020); `uret.ps1` usa esta receta para 209 fotogramas [leído: el script; una ejecución real del motor mediante `uret.ps1` pasó en la ejecución U209].
- Verificado por nosotros en una tarjeta (GTX 1050 Ti 4 GB); los informes externos de otras tarjetas se listan con sus etiquetas en `docs/KART_PROFILLERI.md` [reportado por el usuario].
- **Qué binario se midió:** el latente de 141 fotogramas y la cadena de bytes se midieron con nuestras compilaciones de desarrollo. El binario de la versión publicada que descargas es una compilación nueva: su puerta byte a byte de 56 fotogramas pasó (siguiente punto) y una ejecución de 209 fotogramas mediante `uret.ps1` superó la puerta (ejecución U209, 3414 s, pico de VRAM 3777 MiB) [medido]; frente a la ejecución de 209 con el binario de desarrollo el latente es idéntico byte a byte; en el video los fotogramas (md5) y el audio son idénticos, el sha256 del archivo AVI difiere por el contenedor [medido] (consulta `docs/OLCUMLER.md`, sección 0).
- **Binario de la versión publicada, 56 fotogramas:** el binario de la versión publicada (sd-cli `c5cebe78...`, stable-diffusion.dll `e5d3d329...`) dio un resultado de 56 fotogramas idéntico byte a byte a R0 (sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`; md5 por fotograma y audio idénticos), ejecutado directamente con las opciones por defecto (sin variables `SD_*`), código de salida 0, 601 s [medido: ejecución B56VT2, 2026-11-19; las pruebas las conservan los autores, no están en este repositorio]. Alcance: solo nuestra tarjeta sm_61 y 56 fotogramas; no es una prueba de instalación en raíz limpia; el latente de 141 fotogramas y la cadena de 209 se midieron con el binario anterior y NO se repitieron con este [no probado]. Un primer intento (B56VT, mediante un script auxiliar) terminó en silencio tras 58 s, causa desconocida [estimación: presión de memoria]; el segundo intento ejecutó `sd-cli` directamente.
- Los scripts de instalación y ejecución aún no se han verificado desde una carpeta vacía (prueba en raíz limpia pendiente).
- Hoja de ruta y próximos pasos: `ROADMAP.md`.

## Estado y límites
- Verificado en una sola máquina (GTX 1050 Ti de 4 GB, 16 GB de RAM, i7-7700HQ). Otras tarjetas de 4 GB y otros tamaños de RAM pueden diferir.
- **209 fotogramas por defecto (8,7 s):** superó nuestras puertas de calidad (ruido 1,08, ejecución F209V2K) [medido: 209 fotogramas con el binario de la versión publicada mediante `uret.ps1`, ejecución U209; latente idéntico byte a byte al de la ejecución con el binario de desarrollo; fotogramas y audio idénticos en el video, el sha del archivo difiere por el contenedor; las pruebas las conservan los autores, no están en este repositorio]. Con 209 fotogramas el pico de VRAM del DiT fue de 3777 MiB de 4096 MiB (ejecuciones F209b y U209; lectura de `nvidia-smi` de toda la tarjeta), un margen estrecho: otra carga de la GPU (la pantalla, otras aplicaciones) puede hacer que la ejecución falle en `blocks.0`; probado solo en una GTX 1050 Ti. No se registró el estado de la pantalla durante esa ejecución; si tu pantalla funciona con esta tarjeta, hay menos VRAM disponible [estimación: una carga de pantalla de Windows de unos 100-300 MB]; si hace falta, conecta la pantalla a una GPU integrada [recomendación, no probada]. El muestreo tardó 2730 s (ejecución U209: pasos de 436-483 s) y la decodificación del VAE en proceso aparte 173 s (la etapa 2 en total 193 s con la decodificación del audio) [medido: U209, binario de la versión publicada; ejecuciones de desarrollo anteriores: 2664 s y 174 s]. En la etapa 1 el VAE dentro del proceso se quedó sin memoria y recurrió a mosaicos temporales (320 s); esa salida se descarta, el video procede de la etapa 2 sin mosaicos. El pico de RAM no se midió en U209. Los clips más largos que 209 fotogramas no forman parte de esta versión.
- **Imagen a video (`-InitImg`):** con una imagen inicial el límite es de 192 fotogramas (8,0 s a 24 fps) en esta GPU: 209 fotogramas no cabían (faltaban unos 17,5 MB de VRAM en el bloque 0: se necesitan 2587 MB, hay 2570 MB disponibles); 192 fotogramas se ejecutaron mediante `uret.ps1` en 3086 s con un pico de VRAM de 3783 MiB y la puerta se superó [medido: ejecuciones B209 y B192, 2026-11-20, una escena; las pruebas las conservan los autores, no están en este repositorio]. No se probó en otras GPU [no probado].
- **La RAM libre importa:** necesitas unos 11 GB de RAM LIBRE (el proceso del motor ocupa unos 11 GB) [medido]. Con muy poca RAM libre el proceso puede morir sin mensaje de error [estimación: lo observamos una vez con unos 300 MB de RAM libre mientras `sd-cli` ocupaba unos 10 GB]. No abras otros programas grandes mientras se ejecuta: en una máquina de 16 GB solo quedan libres unos 0,3-0,5 GB, y bajo presión de memoria la ejecución puede morir en silencio. Antes de empezar, cierra navegadores, juegos y otros programas grandes y comprueba la RAM libre.
- **Prueba en raíz limpia pendiente:** los scripts de instalación y ejecución aún no se han verificado desde una carpeta vacía usando solo estas instrucciones; esta sección se actualizará cuando se registre esa prueba (incluida una comparación byte a byte de 56 fotogramas con la referencia).
- Aquí no se incluye ningún video generado.

<!-- i18n-source: README.md sha256:cdeddf10eb78 -->
