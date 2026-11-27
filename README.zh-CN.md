# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · 简体中文 · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

译文以本英文 README 为准。若译文与之不一致或滞后,以英文文本为准,尤其是许可证和安全文本([`SECURITY.md`](SECURITY.md) 与 [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) 仅提供英文和土耳其文)。

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **开始之前(许可证、地域):** 本仓库为 MIT 许可,只包含补丁和脚本。它下载的 MiniMax H3 模型适用 MiniMax H3 Community License:其适用地域不包括欧盟、英国、韩国和美国,模型、衍生品**以及输出(你生成的视频)**不得在这些地区使用、分发或展示(V.4)。在许可条款范围内允许商业使用。安装前请阅读 [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md);这不是法律意见。

> **30 秒速览：** 一张 4 GB 显卡即可单次生成 209 帧（8.7 秒）的 MiniMax H3 视频。已在一台机器（GTX 1050 Ti 4 GB）上验证；在空文件夹中完整安装 `kur.ps1` 的全流程尚未端到端验证 [实测: 使用 release 二进制，经 `uret.ps1` 生成 209 帧，运行 U209；latent 与开发版构建的运行逐字节一致；视频中的帧和音频一致，文件 sha 因容器不同而不同；证据由作者保存，不在本仓库中]；使用 `-InitImg`（图生视频）时最多 192 帧（8.0 秒）[实测: 运行 B192]；209 帧约需 57 分钟，默认时间上限为 80 分钟 [实测: 运行 U209]；下面的 3 个步骤就是运行方法。

VideoTurko：一套 stable-diffusion.cpp 内存补丁与运行方案，让 4 GB 的 GTX 1050 Ti 也能运行 MiniMax H3 文生视频（text-to-video），单次最多 209 帧（8.7 秒）；图生视频（image-to-video，`-InitImg`）最多 192 帧（8.0 秒）（209 帧已通过字节链验证；在 56 帧和 141 帧的检查中，与未打补丁的运行逐字节一致）。

## 快速开始（Windows，3 步）
**状态：下面的安装/运行脚本仍在完善中，clean-root 测试尚未完成；在该测试通过之前，这里的任何内容都不声称可以正常工作（见“状态与限制”）。**

1. **下载**本仓库（绿色的 **Code** 按钮，然后点 **Download ZIP**），解压到一个路径较短的文件夹，例如 `C:\vt`。
2. **安装:双击 `kur.cmd`**(会打开一个黑色窗口并显示每一步;关闭窗口会中止安装,再次运行会接着继续:下载到一半的模型文件会续传 [已读:下载脚本保留一个 `.part` 文件并从它继续;完整 29 GiB 的续传未测量])。如果 Windows 对下载的文件发出警告,请改用下面的 PowerShell 命令 [建议,未在下载的 ZIP 上测试]。更喜欢命令行?在该文件夹打开 PowerShell(在资源管理器地址栏输入 `powershell`),运行同样的安装:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   安装根目录就是你解压出来的文件夹（引擎放在 `engine\bin`，模型放在 `model`）；如需使用其他位置，请先设置环境变量 `VT_ROOT`。脚本会检查 GPU、驱动、内存和磁盘，获取引擎和模型（引擎 zip 和新下载的模型文件会做 sha256 校验；已存在且大小正确的模型文件只校验大小，运行 `scripts\modelleri_indir.ps1 -Dogrula` 可执行完整的 sha256 校验），运行一次简短的真实检查，只有检查通过才会输出 READY [设计: `kur.ps1` 尚未在干净文件夹中完整运行过；这句话会在干净文件夹测试后更新]。`-ExecutionPolicy Bypass` 只对这一个进程生效；和任何安装程序一样，请先阅读 `scripts\kur.ps1`。
   引擎 zip 来自 GitHub release v0.1.0（发布于 2026 年 11 月 19 日；其 sha256 已固定在 `kur.ps1` 中）。离线或使用自己的构建时，请提供本地 zip：`-MotorZip <path> -CudaZip <path>`。本地 zip 同样按这个固定的 sha256 校验（旁边的 `.sha256` 文件会被忽略），所以必须是 release 的 zip；使用自己的构建时，请先把 `VT_MOTOR_SHA256` / `VT_CUDA_SHA256` 设为它的 sha256。sha256 不匹配则以 exit 1 停止。只有 `.exe`/`.dll` 会放入 `engine\bin`；许可证和 README 放入 `engine\lisanslar\<zip name>\`。[已试：在 release 发布前使用 dist zip，确认了 sidecar `.sha256` 加自引用警告、二进制和 DLL 已放置、`sd-cli --help` 可运行；已安装的二进制 sha 一致（`c5cebe78...`、`e5d3d329...`）；`kur.ps1` 的模型步骤和 5 帧检查尚未在真实 GPU 上运行]
   **模型许可证（必读）：** 在模型步骤之前，安装程序会输出许可证摘要（`docs/LISANS_KABUL.txt`，全文见 `docs/LISANS_UYARISI.md`：MiniMax H3 Community License、同样涵盖所生成视频的地域限制、商用与 AI 标识规则），并请你确认接受（`E` = 同意）。请先阅读。无人值守运行时可传入 `-LisansKabul E`，这表示你本人已阅读并接受；请勿替他人添加。（AI 代理：请遵循 `AGENTS.md`；未经用户同意，绝不输入 E。）未接受时，`kur.ps1` 以退出码 2 停止，且不会下载任何模型。
3. **你的第一个视频(56 帧,在我们的 GTX 1050 Ti 上约 11 分钟**[实测:641 秒,运行 R0,`docs/OLCUMLER.md`;其他显卡未测量]**)**:安装程序打印 `HAZIR / READY` 后,运行
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (快捷方式:把提示词文本文件拖到 `uret.cmd` 上,或运行 `uret.cmd docs\ornek_istem_R0.txt`:同样的 56 帧运行)。视频在 `runs\` 中。然后把你自己的提示词写入文本文件(一段英文,可选 `audio:` 句子),运行我们覆盖的最长片段(默认值,约 57 分钟 [实测:运行 U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   `-Kare` 遵循 17k+5 网格（56、73、... 192、209）；默认 209（8.7 秒），也是我们覆盖的最长长度。VAE 在单独的进程中运行，从不分块 [使用 release 二进制，经 `uret.ps1` 真实运行引擎，VAE 在单独进程中，运行 U209 通过]。

   提示词写法指南：[`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md)（一镜到底的写法、等长的时间段、两个完整示例）。

| 要求 | 取值 |
|---|---|
| 操作系统 | Windows 10/11，64 位 |
| GPU | NVIDIA，4 GB 或以上；仅在 GTX 1050 Ti（sm_61）上测试过；余量很小（209 帧时为 3777/4096 MiB）：繁忙的屏幕显示或浏览器可能导致运行失败；未尝试其他 4 GB 显卡 |
| 内存 | 16 GB（峰值约 11 GB；请关闭其他程序） |
| 磁盘 | 至少 32 GiB 可用(建议 40 GiB 及以上:32 到 40 之间安装程序会打印警告,`[VT-W-DISK-PAY]` [实测:模拟磁盘的 `-Kuru` 运行]),模型放在 SSD 上(首选 NVMe) |
| 下载量 | 引擎 zip 36.8 MB + CUDA 运行时 zip 567.5 MB [实测] + 模型 31,473,112,040 字节（约 29.3 GiB）[已读: 大小见 `scripts/modeller.json`]；合计约 30 GiB |
| 模型 | 不包含；由安装程序依据 MiniMax 许可证获取（见下方警告）。模型（29.3 GiB，`scripts/modeller.json` 中为 31,473,112,040 字节）不在本仓库或 release 中：GitHub 有文件/release 大小限制，`kur.ps1` 会从官方来源下载并进行 sha256 校验。 |

`kur.ps1` 退出码：0 READY，1 错误，2 需要用户输入（许可证，或尚无 release/zip），3 硬件或磁盘不足，4 已停止（DUR 文件）。只有 `.avi` 存在、帧数正确且日志干净时，`uret.ps1` 才会接受一次运行 [实测: 使用 release 二进制，经 `uret.ps1` 真实运行一次，运行 U209，209 帧，门禁通过]。`uret.ps1` 退出码：0 DONE（质量门禁通过），1 错误或输出无效（包括没有音频流的视频），2 已停止（DUR 文件），5 `KAPI RED`（质量门禁未通过：片段不被接受，由你决定如何处理），6 门禁无法运行（片段不被接受）。详情见 AGENTS.md。[实测: 在使用模拟引擎和模拟门禁的场景中确认了退出码 0、1（无声视频）、5 和 6；真实引擎：运行 U209 中退出码为 0]

### 故障排查（详情：`docs/SIK_HATALAR.md`）
我们脚本的错误行带有稳定的代码,例如 `HATA: [VT-E-DLL] ...` 或 `UYARI: [VT-W-DISK-PAY] ...`。请在 [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md)(锚点示例 `#vt-e-dll`)或 `docs/hata_imzalari.json` 中查找该代码,并把代码写进你的 issue。下表第一列保持原样输出(不翻译代码和日志文本)。

| 你看到的现象 | 含义与处理 |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found`（#13） | 不要手动启动 `sd-cli.exe`；请运行 `scripts\kur.ps1`，它会把 CUDA DLL 放到正确位置。 |
| 在 `blocks.0` 处出现 `failed during weight preparation`（#1、#3、#5） | 内存门禁处显存不足：在 17k+5 网格上选择更小的帧数，关闭其他占用 GPU 的程序，保持随附的参数不变。 |
| `retrying with temporal tiling`（#6） | VAE 回退到了分块；就质量评估而言该输出无效，请重新运行。 |
| 运行到时间上限就结束，没有视频（#7） | 对于较长的片段，请调大 `-TavanDk`（默认时间上限：209 帧为 80 分钟，由 `uret.ps1` 设定；我们的 209 帧运行耗时 57 分钟 [实测: 运行 U209]）。 |
| 退出码为空但显示“finished”（#14） | 包装脚本读取退出码过早；请重新运行，并确认视频文件存在。 |
| 系统变慢、出现交换（#18） | 引擎约占用 10-11 GB 内存；请关闭浏览器和其他程序。 |
| sha256 不匹配 / 下载失败 | 通常是下载被中断：重新运行同一条命令，已校验的文件会被跳过。 |

**遇到困难或感兴趣?** [`SUPPORT.md`](SUPPORT.md)(去哪里提问;回复时间是目标,不是承诺)· [`PRIVACY.md`](PRIVACY.md)(无遥测;网络仅用于下载引擎和模型,来自列出的主机)· [`SECURITY.md`](SECURITY.md)(私下报告)· [`CONTRIBUTING.md`](CONTRIBUTING.md)(5 步完成第一个 pull request;文档和脚本无需 GPU)。

### v0.1.1 新增：更多选项（详情：`AGENTS.md`、`docs/SIK_HATALAR.md` 19-23）
不使用这些选项时，4 GB 显卡上的行为没有任何变化（与我们的基准对比的 56 帧字节检查在 v0.1.1 下再次通过 [实测]）。在任意命令后加上 `-Kuru`，即可查看将要运行的内容。
- `-EndImg`：同时提供最后一帧（首尾帧，"FLF"）；显存低于 8 GB 的显卡上限为 175 帧（在 4 GB 上 192 帧放不下），8 GB 及以上的显卡为 192 帧。在我们的 GTX 1050 Ti 上始终分两个进程运行：56 帧 1040 秒，175 帧 2887 秒（48 分钟），两者均通过门禁 [实测]。提示词技巧：`docs/ISTEM_YAZIMI.md`。
- `-W` / `-H`：其他尺寸，例如竖屏 384x640；须为 32 的倍数，面积不小于 640x384（不能更小）。未在 4 GB 上测试；在显存低于 8 GB 的显卡上，超过我们实测最大任务的尺寸会被拒绝。质量门禁的阈值是按 640x384 标定的。
- `-TekAsama`：用一个进程代替两个进程，仅适用于大显存显卡；不会自动开启。
- 较新的 GPU（compute capability 7.0+，例如 RTX 20/30/40）：如果你没有自行设置，会自动设置 `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32`；这修复了报告者的 RTX 4070 Ti 上 141 帧及以上时视频全黑的问题 [用户反馈, issue #1]。没有 Python + OpenCV 时，`uret.ps1` 现在会在 GPU 任务开始前以 exit 6 停止（不生成视频，也不会给出误导性的 RED）。
- 感谢 @SinanC73 提供 RTX 4070 Ti 的报告，促成了这些改动（[issue #1](https://github.com/alexturkey/VideoTurko/issues/1)）。

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

## 可选的速度配置(速度包;默认关闭)
以下内容都不会改变默认运行(640x384、209 帧、在我们的显卡上 3414 秒)。它们是默认之外三个已测量的单元格,每个都是 `uret.ps1` 的一个命名配置;需要速度包引擎(发布版引擎加补丁 0021、0023、0024,均默认关闭:`docs/YAMALAR.md`)。用 `scripts\kur.ps1 -HizPaketi` 安装(本地 zip 可配合 `-MotorZip` 使用),然后加上 `-Profil <name>`;`-Kuru` 会打印将要运行的内容。

| 配置 | 尺寸、长度 | 在 GTX 1050 Ti 4 GB 上的总时间 | 状态 |
|---|---|---|---|
| (无,默认) | 640x384,最多 209 帧(8.7 秒) | 209 帧:3414 秒 | 已验证,未改变 |
| `yuksek832` | 832x480,141 帧(5.9 秒) | 约 55-56 分钟 | 可用,两条提示词 [实测] |
| `yuksek832 -Kare 124` | 832x480,124 帧(5.2 秒) | 约 45-46 分钟,无需速度标志 | 可用,两条提示词 [实测] |
| `yuksek896` | 896x512,124 帧(5.2 秒) | 约 56-57.5 分钟 | 可用,两条提示词 [实测] |
| `uzun260` | 640x384,260 帧(10.8 秒) | 不含提前退出实测 78 分钟;含提前退出约 71-72 分钟 [推测:未通过 `uret.ps1` 端到端测量] | 有条件,实验性 |

- **余量很窄:** 在 832x480 x 141 时,内存门只留下个位数 MB 的余量(两次完整运行分别为 5.7 和 6.8 MB)。两条长提示词(1520 和 2041 个字符)只通过读取步骤 1 和步骤 2 一部分的门来检查,没有完整运行:余量为 10.9 和 4.0 MB。任何其他占用显卡内存的进程(浏览器、第二块显示器)都可能让它失败;这时请用 `-Kare 124` 或默认尺寸 [实测,GTX 1050 Ti 4 GB]。
- **`uzun260` 是有条件的:** 内存限制非常窄(VRAM 峰值 4096 MiB 中的 3903 MiB),共享内存用量增加了 61 和 68 MiB,而且没有用于字节一致比对的关闭标志的参考,所以不作为普通功能提供。补丁 0023 只对这一个单元格接受。
- **不提供:** 832x480 在 158 或 175 帧时放不下;长度搜索在那里止于 141 帧。其他尺寸和帧数会被 `-Profil` 拒绝(请用默认路径)。
- 默认质量不受影响:6 步,cfg 1,无分块 VAE,17k+5 帧。在标志开启的地方,在关闭标志的运行能放下的尺寸上,输出已与关闭标志的视频逐字节比对(`docs/YAMALAR.md`);在 832x480 x 141 和 896x512 x 124 时关闭标志的运行放不下,所以那里的一致性依据最接近的单元格,而不是直接比对 [实测,已读]。
- 两阶段运行的阶段 1 现在在潜变量文件完整时立即结束(`VT_ERKEN_CIKIS=0` 可将其关闭)。

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

## 这是什么
一组面向 stable-diffusion.cpp 的小型内存/调度补丁，加上运行方案、检查和实测数据，使 MiniMax H3（33B 的 DiT；我们运行的是 HyperFlow Flash 13.7B Q4_K_M GGUF；32B 的 Qwen3-VL 文本编码器是独立的）能在 4 GB 的 Pascal GPU（GTX 1050 Ti，16 GB 系统内存）上运行。
- 我们实际生成并通过质量门禁的单次长度：640x384、24 fps 下的 56、141、158、175、192、209 帧（209 帧 = 8.7 秒），带有 H3 自己生成的音频 [实测: 使用 release 二进制，经 `uret.ps1` 生成 209 帧，运行 U209；latent 与开发版构建的运行逐字节一致；视频中的帧和音频一致，文件 sha 因容器不同而不同；证据由作者保存，不在本仓库中]。209 是我们看过并认为流畅的最长长度 [用户反馈, 2026-11-19，完整观看了视频；文件：F209V2 输出，8.708 秒]。
- **逐字节一致的说法，如实界定范围：** 只有 56 帧和 141 帧检查过与未打补丁的基准逐字节一致。对于 158/175/192/209 帧，我们使用了相同的参数和相同的二进制链；没有直接的字节基准（未打补丁的构建无法在这块 GPU 上运行这些长度）。
- 质量设置从不降低：相同的模型/量化、6 步、cfg 1、640x384、相同的种子、不分块的 VAE。
- 我们不声称是第一个：我们搜索过，没有找到在 4 GB 上实现这一点的外部案例，但这并不能证明不存在。

## 目录结构
- `patches/` 针对某个固定 stable-diffusion.cpp 提交的补丁（见其中的说明）
- `scripts/` 构建、运行、独立进程 VAE、门禁/一致性辅助脚本（`doku_norm.py`：见下面的尺度说明）
- `docs/KURULUM.md` 硬件、构建与运行步骤（EN+TR）
- `docs/YAMALAR.md` 补丁列表，`docs/KANITLAR.md` 证据，`docs/KAPILAR.md` 质量门禁表，`docs/OLCUMLER.md` 实测数据，`docs/SIK_HATALAR.md` 常见错误，`docs/LISANS_UYARISI.md` 许可证完整条目
- `scripts/` 简要索引：`hiz_kos3.ps1` 运行包装脚本（`-Kuru` 会输出确切的命令），`uretim_kapi.ps1` 质量门禁，`dikis_denetim.py` 接缝检查，`doku_norm.py` 纹理归一化噪声，`bayt_kiyas.py` 字节比较，`derleme_sablonu.ps1` 构建模板（只会停止在自己构建开始之后才启动的 Visual Studio 遥测辅助进程 `vctip.exe`，否则它会让构建进程多挂几分钟；其他 `vctip.exe` 进程不会被动）

## 质量门禁（结果如何被接受）

这个门禁不检查运动一致性（物体尺度或位置的跳变）：接受结果之前，请完整观看整段视频。
1. 帧数正确且有音频；日志中没有内存回退或 ALLOC_FAILED 行。
2. 原始噪声门禁：中值滤波残差 <= 1.5（0-255 尺度）。
3. 纹理归一化噪声，`scripts/doku_norm.py`（本仓库的版本）：N = 残差中值 / Sobel 纹理，每 6 帧取一次。**尺度说明：** 在这个版本中，10 个已测量的片段得到 N = 0.034-0.052（表见 `docs/KAPILAR.md`；F192/F209V2 的最后四分之一达到 0.062），额外门禁的阈值是 N <= 0.065。另一种实现在同样的片段上测得 0.028-0.036，所以不同版本之间的阈值“不能”互换。在非常细的纹理（成行的草地纹理）上，干净画面的 N 为 0.075，所以阈值要按场景类别来定。推荐使用稳健的高频估计量作为额外门禁（sigma-HH <= 1.5；干净画面为 0.74-1.19，加入 s=2 的噪声后为 2.2-3.0）。

范围：VideoTurko 针对的是单次生成（最多 209 帧，约 8.7 秒）。我们自己的拼接测试出现了可见接缝（场景无法干净地延续），因此更长的影片不属于我们验证的内容。拼接可参考社区指南 `docs/KLIP_ZINCIRI.md` 和我们仅用 CPU 的辅助脚本 `scripts/zincir.py`（`plan`、`son-kare`、`bagla`；它从不启动引擎）；拼接影片的质量我们没有测量 [未尝试]，请用眼睛并配合 `scripts/dikis_denetim.py` 检查每一处接缝。
设置由你自己决定：209 帧是我们在 4 GB 显卡上测试过的默认值，不是你必须遵守的上限。可以在 17k+5 网格（56、73、... 192、209；见 `docs/KURULUM.md`）上任选帧数，也可以随意更改提示词、种子、分辨率或任何参数。更短的片段需要更少的内存和时间；更大的 GPU 也许能容纳更多。

## 模型许可证警告
**VideoTurko 只包含补丁和脚本（MIT）；使用模型及其输出的人，须自行对 MiniMax 许可证负责。** 这不构成法律意见。下面按编号概述 MiniMax H3 Community License（2026 年 8 月 2 日）的各项条款，具有约束力的是许可证本身：https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

本仓库的 MIT 许可不涵盖模型权重;见 [`NOTICE`](NOTICE)。本仓库不包含任何模型权重（没有 MiniMax H3、HyperFlow-H3-Flash GGUF 或 VAE 文件）。本项目与 MiniMax 无关联，也未获其认可。并不禁止商业使用（这不是非商业许可证）；条件见下。

**地域（Applicable Territory）**
- **序言、I.3、I.5：** 全球，但不包括欧盟、英国、大韩民国和美国。使用该模型即视为接受许可证。
- **II：** 免版税、不可转让的有限许可，可使用、复制、分发、创作衍生品和修改，仅限于地域范围内，并须遵守协议和 Exhibit A。位于被排除地域的人可以向 MiniMax 申请单独的许可。
- **V.4：** 在地域之外使用、复制、修改、分发或展示该模型、其衍生品以及输出（生成的视频/音频），均未获授权。**因此，在欧盟/英国/韩国/美国发布或展示所生成的视频，不在许可范围之内。**
- **Exhibit A-1：** 在地域之外使用，违反 Acceptable Use Policy。

**分发（III）**（本仓库不分发模型；如果你要分发）
- **III.1：** 向每位接收者提供一份许可证副本。**III.2：** 在修改过的文件上加注明显的声明。
- **III.3：** 鼓励（非强制）：“Powered by MiniMax H3”声明、在生成的文件上加 AI 生成标识、公开的说明文章。
- **III.4：** 分发时必须附带 NOTICE 文件，内容为："MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12：** 禁止在不明确披露内容由机器生成的情况下，将其发布到任何公开环境：发布 AI 生成的视频时请加以标注（完整列表：`docs/LISANS_UYARISI.md`）。
- **III（最后一段）：** 你可以为自己的修改部分添加自己的版权声明，但不得对使用/分发附加额外或不同的条款；地域规则依然适用。

**商业条款（IV）**
- **IV.1：** 如果你的商业产品/服务年收入超过 20 million USD（或等值），须事先向 api@minimax.io 取得书面授权（邮件主题 "MiniMax H3 licensing - authorization request"）。
- **IV.2：** 使用该模型的商业产品/服务，其 UI 须显著展示 "MiniMax H3"。

**使用限制（V）**
- **V.1：** 遵守适用法律（包括贸易合规）和 Exhibit A。**V.2：** 对你提供访问权限的每个人，须以不低于这些限制的保护程度的条款加以约束，并通知他们。
- **V.3：** 不得使用该模型或其输出来改进任何其他 AI 模型（MiniMax H3 及其衍生品除外）。（I.11：蒸馏以及用合成输出训练出的模型属于“衍生品”；输出本身不是衍生品。）
- **V.5：** 如果你向第三方提供用该模型生成输出的产品/服务/托管服务：在运营之前和运营期间，须具备合理的技术和组织保障措施、举报机制、及时调查，并对屡次违规者予以删除/禁用/停权。

**商标与权利（VI）**
- **VI.1：** 你创作的衍生作品和模型衍生品归你所有（以 MiniMax 的权利为前提）。**VI.2：** MiniMax 的名称/商标未被授权（描述和分发所必需的除外）；“MiniMax H3”标识只能用于遵守 III.3，且只能在地域范围内使用；不得暗示存在关联。
- **VI.3：** 如果你起诉 MiniMax 或任何人，主张相关材料/输出侵犯了你的权利，你的所有许可当天终止；对于因你或他人使用/分发而产生的第三方索赔，你须为 MiniMax 抗辩并予以赔偿。
- **VI.4：** MiniMax 不主张对输出的任何权利；你和你的用户对输出及其使用负责。

**免责声明与终止（VII、VIII、IX）**
- **VII.1：** 无支持/更新的义务。**VII.2：** 模型和输出按“原样”（"AS IS"）提供，不作任何保证；是否适用由你自行判断，风险由你承担。**VII.3：** 在法律允许的范围内，MiniMax 及其关联方对任何损害不承担责任。
- **VIII.1：** 自接受/获取时生效。**VIII.2：** 发生违约时，MiniMax 可以终止；你必须停止使用/分发、删除副本并通知接收者（VI.1、VI.3、VII、IX 继续有效）。
- **IX：** 适用香港特别行政区法律；香港法院拥有专属管辖权（排除联合国 CISG）。
- **补充说明：** MiniMax H3 的编码器使用 Qwen3-VL-32B（Apache 2.0）。

**Acceptable Use Policy（Exhibit A）**（不得将模型、衍生品或输出用于以下用途）
- A-1 在地域之外使用；A-2 违反法律或侵犯第三方知识产权；A-3 伤害自己或他人；A-4 为造成伤害而改作/分发输出；A-5 规避保障措施；A-6 剥削/伤害未成年人；A-7 以伤害他人或影响选举为目的的可被查证为虚假的信息；A-8 虚假的网络互动（虚假评论等）；A-9 诽谤、诋毁、骚扰；A-10 恶意软件；A-11 利用个人数据伤害他人；**A-12 在不明确且显著地披露内容由机器生成的情况下，将其发布到任何公开环境（包括机器人发帖）**；A-13 未经同意的冒充；A-14 在关键领域（执法、移民、医疗、关键基础设施、信贷、就业、住房、教育、社会评分、保险等）进行高风险的自动化决策；A-15 违反其他国家/地区的社会、伦理、道德标准；A-16 暴力极端主义/恐怖主义；A-17 基于受保护特征的歧视/伤害；A-18 剥削弱势群体；**A-19 军事用途**；A-20 未经授权/无执照的专业活动（金融、法律、医疗等）。
- 注：这是通俗语言的摘要；如有疑义，以英文许可证文本为准。

## 证据标签

所有文档共用一套标签（括号内为旧写法）：
- **[实测]**（英文：measured，TR: ölçtüm, olctum）：在本项目中运行过，证据路径存在。
- **[已读]**（英文：read，TR: okudum yol, okudum）：读过源码或脚本，没有运行。
- **[设计]**（英文：design，TR: tasarım, tasarim）：已设计，尚未在真实运行中见到。
- **[推测]**（英文：guess，TR: tahmin）：未经验证。
- **[未尝试]**（英文：not tried，TR: denenmedi）：从未运行过。
- **[用户反馈]**（英文：user-reported，TR: kullanıcı bildirdi）：由用户陈述，附日期；未经独立测量。
- **[推算]**（英文：computed，TR: hesap；旧写法：calculated, hesap）：由实测输入推导出的数值，其本身不是实测值；推导过程写在数值旁边。旧文中的 [提议] / [öneri] 等同于 [推测]。

括号中使用的运行名称（是我们自己的运行名称，不是本仓库中的文件）：U209 = 使用 release 二进制、经 `uret.ps1` 生成的 209 帧；B209 和 B192 = 209 帧和 192 帧的图生视频（`-InitImg`）运行；B56VT2 = release 二进制，56 帧，与 56 帧字节基准 R0 比较；F209b、F209V2、F209V2K = 开发版构建上的 209 帧运行（详情：`docs/OLCUMLER.md`）。

## 已知限制
- **字节证明**（如何自行复现：见 `docs/KANITLAR.md`，“R0 ve latent referansi nasil uretilir”；已在我们的 sm_61 显卡上验证，其他 GPU 可能不会逐字节一致 [推测]）：使用我们的补丁系列（开启内存参数）时，一次 56 帧的运行得到 sha256 `0979f156d548169b...`，与基准一致 [实测]；在 141 帧时，latent 的 sha256 `E5D028F8632BE4FE...` 一致（带 0013/0014 参数）。158 到 209 帧没有直接的字节基准；证据是门禁链。通过数值门禁并不保证片段质量好：随时间变化的运动一致性需要靠肉眼检查（见 `docs/KAPILAR.md`）。
- **209 帧，使用哪组参数：** 209 帧字节链的证据取自开发版构建上的 F209V2 参数组（没有 block-tail 参数，构建时未包含补丁 0019/0020）；`uret.ps1` 对 209 帧使用这套方案 [已读: 该脚本；经 `uret.ps1` 的真实引擎运行在运行 U209 中通过]。
- 我们只在一张显卡（GTX 1050 Ti 4 GB）上验证过；其他显卡的外部报告连同标签列在 `docs/KART_PROFILLERI.md` 中 [用户反馈]。
- **测量的是哪个二进制：** 141 帧的 latent 和字节链是用我们的开发版构建测量的。你下载的 release 二进制是一次全新构建：它的 56 帧字节门禁已通过（见下一条），经 `uret.ps1` 的 209 帧运行也通过了门禁（运行 U209，3414 秒，显存峰值 3777 MiB）[实测]；与开发版构建的 209 运行相比，latent 逐字节一致；视频中的帧（md5）和音频一致，AVI 文件的 sha256 因容器不同而不同 [实测]（见 `docs/OLCUMLER.md` 第 0 节）。
- **release 二进制，56 帧：** release 二进制（sd-cli `c5cebe78...`，stable-diffusion.dll `e5d3d329...`）得到的 56 帧结果与 R0 逐字节一致（sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`；逐帧 md5 和音频一致），直接以默认参数运行（没有 `SD_*` 变量），退出码 0，601 秒 [实测: 运行 B56VT2，2026-11-19；证据由作者保存，不在本仓库中]。范围：仅限我们的 sm_61 显卡和 56 帧；不是 clean-root 安装测试；141 帧的 latent 和 209 的链是用旧的二进制测量的，没有用这个二进制重复 [未尝试]。第一次尝试（B56VT，通过辅助脚本）在 58 秒后悄无声息地结束，原因不明 [推测: 内存压力]；第二次尝试直接运行了 `sd-cli`。
- 安装和运行脚本尚未从空文件夹验证过（clean-root 测试待完成）。
- 路线图与后续步骤：`ROADMAP.md`。

## 状态与限制
- 已在一台机器上验证（GTX 1050 Ti 4 GB、16 GB 内存、i7-7700HQ）。其他 4 GB 显卡和其他内存容量可能有差异。
- **默认 209 帧（8.7 秒）：** 通过了我们的质量门禁（噪声 1.08，运行 F209V2K）[实测: 使用 release 二进制，经 `uret.ps1` 生成 209 帧，运行 U209；latent 与开发版构建的运行逐字节一致；视频中的帧和音频一致，文件 sha 因容器不同而不同；证据由作者保存，不在本仓库中]。在 209 帧时，DiT 的显存峰值为 4096 MiB 中的 3777 MiB（运行 F209b 和 U209；整卡 `nvidia-smi` 读数），余量很小：其他 GPU 负载（显示输出、其他应用程序）可能使运行在 `blocks.0` 处失败；仅在 GTX 1050 Ti 上测试过。那次运行时的显示状态没有记录；如果你的显示器连在这张显卡上，可用显存会更少 [推测: Windows 显示负载约 100-300 MB]；如有需要，请把显示器接到集成显卡上 [建议，未测试]。采样耗时 2730 秒（运行 U209：每步 436-483 秒），独立进程 VAE 解码耗时 173 秒（含音频解码，第 2 阶段合计 193 秒）[实测: U209 release 二进制；较早的开发版运行：2664 秒和 174 秒]。在第 1 阶段，进程内的 VAE 内存不足并回退到 temporal tiling（320 秒）；该输出已被丢弃，视频来自不分块的第 2 阶段。U209 中没有测量内存峰值。超过 209 帧的更长片段不属于本次发布。
- **图生视频（`-InitImg`）：** 有初始图像时，这块 GPU 上的上限是 192 帧（24 fps 下 8.0 秒）：209 帧放不下（在 block 0 处显存差约 17.5 MB：需要 2587 MB，可用 2570 MB）；192 帧经 `uret.ps1` 运行了 3086 秒，显存峰值 3783 MiB，门禁通过 [实测: 运行 B209 和 B192，2026-11-20，一个场景；证据由作者保存，不在本仓库中]。未在其他 GPU 上尝试 [未尝试]。
- **空闲内存很重要：** 需要约 11 GB 的空闲内存（引擎进程占用约 11 GB）[实测]。空闲内存太少时，进程可能不报任何错误就死掉 [推测: 我们曾观察到一次，当时空闲内存约 300 MB，而 `sd-cli` 占用约 10 GB]。运行期间不要打开其他大型程序：在 16 GB 的机器上只剩下约 0.3-0.5 GB 空闲，在内存压力下运行可能悄无声息地死掉。开始之前，请关闭浏览器、游戏和其他大型程序，并检查空闲内存。
- **clean-root 测试待完成：** 安装和运行脚本尚未仅按这些说明从空文件夹验证过；当该测试（包括与基准的 56 帧字节比较）记录完成后，本节会随之更新。
- 这里不附带任何生成的视频。

<!-- i18n-source: README.md sha256:67497404d89b -->
