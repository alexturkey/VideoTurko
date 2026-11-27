# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · 한국어 · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

번역본은 이 영어 README를 따릅니다. 번역이 다르거나 뒤처져 있으면 특히 라이선스와 보안 문구는 영어 텍스트가 기준입니다([`SECURITY.md`](SECURITY.md)와 [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md)는 영어와 터키어로만 관리됩니다).

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **시작하기 전에(라이선스, 지역):** 이 저장소는 MIT이며 패치와 스크립트만 포함합니다. 내려받는 MiniMax H3 모델은 MiniMax H3 Community License를 따르며, 적용 지역에서 유럽연합, 영국, 대한민국, 미국이 제외됩니다. 모델, 파생물 **및 출력물(생성한 영상)**은 그곳에서 사용, 배포, 표시할 수 없습니다(V.4). 상업적 사용은 라이선스 조건 안에서 허용됩니다. 설치하기 전에 [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md)를 읽으세요. 이것은 법률 자문이 아닙니다.

> **30초 요약:** 4 GB 그래픽카드로 MiniMax H3의 209 프레임(8.7초) 영상을 한 번의 패스로 만들 수 있습니다. 확인은 한 대의 PC(GTX 1050 Ti 4 GB)에서만 했으며, 빈 폴더에서 `kur.ps1`을 전체 설치하는 과정은 아직 끝까지 검증하지 않았습니다 [측정: 릴리스 바이너리로 `uret.ps1`을 통해 209 프레임, 실행 U209. latent는 개발 빌드 실행과 바이트 단위로 동일. 영상 안의 프레임과 오디오는 동일하며 파일 sha는 컨테이너 때문에 다름. 증거는 작성자가 보관 중이며 이 저장소에는 없음]. `-InitImg`(image-to-video)에서는 최대 192 프레임(8.0초)입니다 [측정: 실행 B192]. 209 프레임에는 약 57분이 걸리고 기본 시간 제한은 80분입니다 [측정: 실행 U209]. 아래 3단계가 실행 방법입니다.

VideoTurko: 4 GB GTX 1050 Ti에서 MiniMax H3 text-to-video를 돌리기 위한 stable-diffusion.cpp 메모리 패치와 실행 레시피입니다. 한 번의 패스로 최대 209 프레임(8.7초), image-to-video(`-InitImg`)는 최대 192 프레임(8.0초)까지 지원합니다(209 프레임은 바이트 체인으로 검증, 56 및 141 프레임 확인에서는 패치하지 않은 실행과 바이트 단위로 동일).

## 빠른 시작 (Windows, 3단계)
**상태: 아래 설치·실행 스크립트는 마무리 중이며 clean-root 테스트가 아직 남아 있습니다. 이 테스트를 통과하기 전까지는 여기 적힌 어떤 것도 동작한다고 주장하지 않습니다(「상태와 한계」 참고).**

1. **다운로드**: 이 저장소를 내려받아(초록색 **Code** 버튼, 이어서 **Download ZIP**) `C:\vt`처럼 경로가 짧은 폴더에 압축을 풉니다.
2. **설치: `kur.cmd`를 더블클릭**(검은 창이 열리며 각 단계를 보여 줍니다. 창을 닫으면 설치가 멈추고, 다시 실행하면 멈춘 곳에서 이어집니다. 반쯤 내려받은 모델 파일은 이어받습니다 [읽음: 다운로드 스크립트가 `.part` 파일을 보관하고 거기서 이어받음. 전체 29 GiB 이어받기는 측정하지 않음]). 내려받은 파일에 대해 Windows가 경고하면 아래 PowerShell 명령을 대신 사용하세요 [조언, 내려받은 ZIP에서는 테스트하지 않음]. 명령줄을 선호하시나요? 그 폴더에서 PowerShell을 열고(탐색기 주소 표시줄에 `powershell` 입력) 같은 설치를 실행하세요:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   설치 루트는 압축을 푼 폴더입니다(엔진은 `engine\bin`, 모델은 `model`에 들어갑니다). 다른 위치를 쓰려면 먼저 환경 변수 `VT_ROOT`를 설정하세요. 스크립트는 GPU, 드라이버, RAM, 디스크를 확인하고, 엔진과 모델을 받아 오며(엔진 zip과 새로 받은 모델 파일은 sha256으로 검증합니다. 이미 있는 모델 파일은 크기가 맞으면 크기만 확인하며, `scripts\modelleri_indir.ps1 -Dogrula`로 전체 sha256 검증을 실행할 수 있습니다), 짧은 실제 점검을 실행한 뒤, 그 점검을 통과했을 때만 READY를 출력합니다 [설계: `kur.ps1`은 깨끗한 폴더에서 전체를 실행해 본 적이 없습니다. 이 문장은 clean-folder 테스트 뒤에 갱신합니다]. `-ExecutionPolicy Bypass`는 이 한 프로세스에만 적용됩니다. 어떤 설치 프로그램이든 마찬가지로, 먼저 `scripts\kur.ps1`을 읽어 보세요.
   엔진 zip은 GitHub 릴리스 v0.1.0에서 받습니다(2026년 11월 19일 공개, sha256은 `kur.ps1`에 고정되어 있습니다). 오프라인이거나 직접 빌드한 것을 쓸 때는 로컬 zip을 지정하세요: `-MotorZip <path> -CudaZip <path>`. 로컬 zip도 같은 고정 sha256으로 검사합니다(옆에 있는 `.sha256` 파일은 무시됩니다). 따라서 릴리스 zip이어야 하며, 직접 빌드한 것을 쓸 때는 먼저 `VT_MOTOR_SHA256` / `VT_CUDA_SHA256`에 그 sha256을 설정하세요. sha256이 틀리면 exit 1로 멈춥니다. `engine\bin`에는 `.exe`/`.dll`만 들어가고, 라이선스와 README는 `engine\lisanslar\<zip name>\`에 들어갑니다. [시도: 릴리스 전에 dist zip으로 sidecar `.sha256`과 자기 참조 경고, 바이너리와 DLL 배치, `sd-cli --help` 실행을 확인. 설치된 바이너리의 sha도 일치(`c5cebe78...`, `e5d3d329...`). `kur.ps1`의 모델 단계와 5 프레임 점검은 실제 GPU에서 아직 실행하지 않음]
   **모델 라이선스:** 모델 단계 전에 설치 프로그램이 라이선스 요약(`docs/LISANS_KABUL.txt`, 전문은 `docs/LISANS_UYARISI.md`: MiniMax H3 Community License, 생성된 영상에도 적용되는 지역 제한, 상업적 이용과 AI 표시 규칙)을 출력하고 동의를 묻습니다(`E` = 예). 먼저 읽어 보세요. 무인 실행에서는 `-LisansKabul E`를 넘길 수 있는데, 이는 본인이 직접 읽고 동의했다는 뜻입니다. 다른 사람을 대신해 붙이지 마세요. (AI 에이전트: `AGENTS.md`를 따르고, 사용자의 동의 없이 E를 입력하지 마세요.) 동의하지 않으면 `kur.ps1`은 종료 코드 2로 멈추며 모델을 다운로드하지 않습니다.
3. **첫 영상(56프레임, 우리 GTX 1050 Ti에서 약 11분**[측정: 641초, 실행 R0, `docs/OLCUMLER.md`; 다른 카드는 측정하지 않음]**)**: 설치 프로그램이 `HAZIR / READY`를 출력하면 다음을 실행하세요
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (단축 방법: 프롬프트 텍스트 파일을 `uret.cmd` 위로 끌어다 놓거나 `uret.cmd docs\ornek_istem_R0.txt`를 실행하세요. 같은 56프레임 실행입니다). 영상은 `runs\`에 있습니다. 그다음 자신의 프롬프트를 텍스트 파일에 쓰고(영어 한 단락, 선택적 `audio:` 문장) 우리가 지원하는 가장 긴 클립을 실행하세요(기본값, 약 57분 [측정: 실행 U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   `-Kare`는 17k+5 그리드(56, 73, ... 192, 209)를 따릅니다. 기본값은 209(8.7초)이며 지원하는 가장 긴 길이입니다. VAE는 별도 프로세스에서 실행하며 타일링하지 않습니다 [릴리스 바이너리로 `uret.ps1`을 통해 실제 엔진을 실행. 별도 프로세스 VAE로 실행 U209 통과].

   프롬프트 작성 가이드: [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (끊김 없는 원테이크 패턴, 균등한 시간 구간, 전체 예시 두 개).

| 요구 사항 | 값 |
|---|---|
| OS | Windows 10/11, 64비트 |
| GPU | NVIDIA, 4 GB 이상. GTX 1050 Ti(sm_61)에서만 테스트함. 여유가 적음(209 프레임에서 3777/4096 MiB). 화면 출력이 많거나 브라우저가 열려 있으면 실행이 실패할 수 있음. 다른 4 GB 카드는 시도하지 않음 |
| RAM | 16 GB(피크 약 11 GB. 다른 프로그램은 종료할 것) |
| 디스크 | 여유 공간 32 GiB 이상(40 GiB 이상 권장: 32~40 사이에서는 설치 프로그램이 경고를 출력, `[VT-W-DISK-PAY]` [측정: 디스크를 가정한 `-Kuru` 실행]), 모델은 SSD에(NVMe 권장) |
| 다운로드 | 엔진 zip 36.8 MB + CUDA 런타임 zip 567.5 MB [측정] + 모델 31,473,112,040 바이트(약 29.3 GiB) [읽음: 크기는 `scripts/modeller.json`]. 합계 약 30 GiB |
| 모델 | 포함되어 있지 않음. MiniMax 라이선스에 따라 설치 프로그램이 받아 옴(아래 경고 참고). 모델(29.3 GiB, `scripts/modeller.json`의 31,473,112,040 바이트)은 이 저장소나 릴리스에 없습니다. GitHub의 파일·릴리스 크기 제한이 적용되므로 `kur.ps1`이 공식 배포처에서 sha256 검증과 함께 내려받습니다. |

`kur.ps1` 종료 코드: 0 READY, 1 오류, 2 사용자 입력 필요(라이선스, 또는 아직 릴리스/zip 없음), 3 하드웨어 또는 디스크 부족, 4 중지됨(DUR 파일). `uret.ps1`은 `.avi`가 존재하고, 프레임 수가 맞고, 로그가 깨끗할 때만 실행 결과를 인정합니다 [측정: 릴리스 바이너리로 `uret.ps1`을 통한 실제 실행 1회, 실행 U209, 209 프레임, 게이트 통과]. `uret.ps1` 종료 코드: 0 DONE(품질 게이트 통과), 1 오류 또는 잘못된 출력(오디오 스트림이 없는 영상 포함), 2 중지됨(DUR 파일), 5 `KAPI RED`(품질 게이트 실패: 클립은 인정되지 않으며 판단은 사용자 몫), 6 게이트를 실행하지 못함(클립은 인정되지 않음). 자세한 내용은 AGENTS.md를 참고하세요. [측정: 가짜 엔진과 가짜 게이트를 쓴 시나리오에서 종료 코드 0, 1(무음 영상), 5, 6 확인. 실제 엔진: 실행 U209에서 종료 코드 0]

### 문제 해결 (자세한 내용: `docs/SIK_HATALAR.md`)
우리 스크립트의 오류 줄에는 고정된 코드가 붙습니다. 예: `HATA: [VT-E-DLL] ...` 또는 `UYARI: [VT-W-DISK-PAY] ...`. 코드는 [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md)(앵커 예 `#vt-e-dll`) 또는 `docs/hata_imzalari.json`에서 찾고, issue에도 코드를 적어 주세요. 아래 표의 첫 번째 열은 출력된 그대로 둡니다(코드와 로그 문구는 번역하지 않습니다).

| 보이는 증상 | 의미와 대처 |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | `sd-cli.exe`를 직접 실행하지 마세요. `scripts\kur.ps1`을 실행하면 CUDA DLL이 제자리에 놓입니다. |
| `blocks.0`에서 `failed during weight preparation` (#1, #3, #5) | 메모리 게이트에서 VRAM이 부족합니다. 17k+5 그리드에서 프레임 수를 줄이고, 다른 GPU 프로그램을 종료하고, 함께 제공된 플래그는 그대로 두세요. |
| `retrying with temporal tiling` (#6) | VAE가 타일링으로 대체되었습니다. 품질 평가용으로는 출력이 유효하지 않으니 다시 실행하세요. |
| 시간 제한에서 종료되고 영상이 없음 (#7) | 긴 클립은 `-TavanDk`를 늘리세요(기본 시간 제한: 209 프레임에서 80분, `uret.ps1`이 설정. 우리 209 프레임 실행은 57분 걸림 [측정: 실행 U209]). |
| 종료 코드는 비어 있는데 "finished"로 표시됨 (#14) | 래퍼가 종료 코드를 너무 일찍 읽었습니다. 다시 실행하고 영상 파일이 있는지 확인하세요. |
| 시스템이 느려지고 스왑 발생 (#18) | 엔진은 RAM을 약 10-11 GB 사용합니다. 브라우저와 다른 프로그램을 종료하세요. |
| sha256 불일치 / 다운로드 실패 | 대개 다운로드가 중단된 경우입니다. 같은 명령을 다시 실행하세요. 검증이 끝난 파일은 건너뜁니다. |

**막히셨나요, 궁금하신가요?** [`SUPPORT.md`](SUPPORT.md)(질문할 곳. 답변 시간은 목표이며 약속이 아닙니다) · [`PRIVACY.md`](PRIVACY.md)(텔레메트리 없음. 네트워크는 엔진과 모델을 내려받을 때만, 나열된 호스트에서 사용) · [`SECURITY.md`](SECURITY.md)(비공개 제보) · [`CONTRIBUTING.md`](CONTRIBUTING.md)(5단계로 첫 pull request. 문서와 스크립트에는 GPU가 필요 없음).

### v0.1.1 새 기능: 옵션 추가 (자세한 내용: `AGENTS.md`, `docs/SIK_HATALAR.md` 19-23)
이 옵션들을 쓰지 않으면 4 GB 카드에서는 아무것도 바뀌지 않습니다(우리 기준과 비교한 56 프레임 바이트 점검은 v0.1.1에서도 다시 통과했습니다 [측정]). 어떤 명령이든 `-Kuru`를 붙이면 무엇이 실행될지 미리 볼 수 있습니다.
- `-EndImg`: 마지막 프레임도 지정합니다(첫 프레임과 마지막 프레임, "FLF"). 상한은 8 GB 미만 카드에서 175 프레임(4 GB에서는 192가 들어가지 않았음), 8 GB 이상 카드에서 192입니다. 우리 GTX 1050 Ti에서는 항상 두 개의 프로세스로 실행됩니다: 56 프레임 1040초, 175 프레임 2887초(48분), 둘 다 게이트를 통과했습니다 [측정]. 프롬프트 팁: `docs/ISTEM_YAZIMI.md`.
- `-W` / `-H`: 다른 크기, 예를 들어 세로 384x640. 32의 배수여야 하며 면적은 640x384 이상입니다(이보다 작게는 안 됩니다). 4 GB에서는 테스트하지 않았습니다. 8 GB 미만 카드에서는 우리가 측정한 가장 큰 작업을 넘는 크기는 거부됩니다. 품질 게이트 임계값은 640x384 기준으로 보정되어 있습니다.
- `-TekAsama`: 두 프로세스 대신 한 프로세스로 실행합니다. 큰 카드 전용이며 자동으로 켜지지 않습니다.
- 비교적 새로운 GPU(compute capability 7.0+, 예: RTX 20/30/40): 직접 설정하지 않았다면 `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32`가 자동으로 설정됩니다. 이 설정으로 보고자의 RTX 4070 Ti에서 141 프레임 이상일 때 영상 전체가 검게 나오던 문제가 해결되었습니다 [사용자 보고, issue #1]. 이제 Python + OpenCV가 없으면 `uret.ps1`은 GPU 작업 전에 exit 6으로 멈춥니다(영상은 만들어지지 않고, 오해를 부르는 RED도 없습니다).
- 이번 변경의 계기가 된 RTX 4070 Ti 보고를 해 주신 @SinanC73 님께 감사드립니다([issue #1](https://github.com/alexturkey/VideoTurko/issues/1)).

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

## 선택적 속도 프로필(속도 팩, 기본값은 꺼짐)
아래 어느 것도 기본 실행(640x384, 209 프레임, 우리 카드에서 3414초)을 바꾸지 않습니다. 기본값 너머에서 측정한 세 개의 셀이며, 각각 `uret.ps1`의 이름 붙은 프로필입니다. 속도 팩 엔진(릴리스 엔진에 패치 0021, 0023, 0024를 더한 것, 모두 기본값은 꺼짐: `docs/YAMALAR.md`)이 필요합니다. `scripts\kur.ps1 -HizPaketi`로 설치하고(로컬 zip은 `-MotorZip`으로 사용할 수 있습니다) 그다음 `-Profil <name>`을 붙입니다. `-Kuru`는 실행될 내용을 출력합니다.

| 프로필 | 크기, 길이 | GTX 1050 Ti 4 GB에서의 총 시간 | 상태 |
|---|---|---|---|
| (없음, 기본값) | 640x384, 최대 209 프레임(8.7초) | 209 프레임: 3414초 | 검증됨, 변경 없음 |
| `yuksek832` | 832x480, 141 프레임(5.9초) | 약 55-56분 | 사용 가능, 프롬프트 두 개 [측정] |
| `yuksek832 -Kare 124` | 832x480, 124 프레임(5.2초) | 약 45-46분, 속도 플래그 불필요 | 사용 가능, 프롬프트 두 개 [측정] |
| `yuksek896` | 896x512, 124 프레임(5.2초) | 약 56-57.5분 | 사용 가능, 프롬프트 두 개 [측정] |
| `uzun260` | 640x384, 260 프레임(10.8초) | 조기 종료 없이 78분 측정; 조기 종료 시 약 71-72분 [추정: `uret.ps1`을 통한 전 구간은 측정하지 않음] | 조건부, 실험적 |

- **좁은 여유:** 832x480 x 141에서 메모리 게이트의 여유는 한 자리 MB입니다(전체 실행 두 번에서 5.7 MB와 6.8 MB). 긴 프롬프트 두 개(1520자와 2041자)는 1단계와 2단계 일부의 게이트를 읽어서만 확인했고 끝까지 실행하지 않았습니다: 여유 10.9 MB와 4.0 MB. 카드 메모리를 쓰는 다른 프로세스(브라우저, 두 번째 모니터)가 있으면 실패할 수 있으며, 그럴 때는 `-Kare 124`나 기본 크기를 쓰세요 [측정, GTX 1050 Ti 4 GB].
- **`uzun260`은 조건부입니다:** 메모리 한계가 매우 좁고(VRAM 최대 4096 MiB 중 3903 MiB), 공유 메모리 사용량이 61 MiB와 68 MiB 늘었으며, 바이트 일치를 위한 플래그 없는 기준이 없어서 일반 기능으로 제공하지 않습니다. 패치 0023은 이 한 셀에 대해서만 받아들였습니다.
- **제공하지 않음:** 832x480에서 158 또는 175 프레임은 들어가지 않습니다. 길이 탐색은 거기서 141 프레임에서 끝났습니다. 다른 크기와 프레임 수는 `-Profil`이 거부합니다(기본 경로를 쓰세요).
- 기본 품질은 그대로입니다: 6단계, cfg 1, 타일 없는 VAE, 17k+5 프레임. 플래그가 켜진 곳에서는, 플래그 없는 실행이 들어가는 크기에서 출력을 플래그 없는 영상과 바이트 단위로 비교했습니다(`docs/YAMALAR.md`). 832x480 x 141과 896x512 x 124에서는 플래그 없는 실행이 들어가지 않으므로, 거기서의 일치는 직접 비교가 아니라 가장 가까운 셀에 근거합니다 [측정, 읽음].
- 2단계 실행의 1단계는 이제 잠재 파일이 완성되는 즉시 끝납니다(`VT_ERKEN_CIKIS=0`으로 끌 수 있습니다).

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

## 이 프로젝트는 무엇인가
stable-diffusion.cpp용 작은 메모리·스케줄링 패치와, 실행 레시피, 점검, 측정 자료의 모음입니다. 이를 통해 MiniMax H3(33B DiT. 우리는 HyperFlow Flash 13.7B Q4_K_M GGUF를 실행하며, 32B Qwen3-VL 텍스트 인코더는 별도입니다)를 4 GB Pascal GPU(GTX 1050 Ti, 시스템 RAM 16 GB)에서 실행할 수 있습니다.
- 실제로 생성했고 품질 게이트를 통과한 단일 패스 길이: 640x384, 24 fps에서 56, 141, 158, 175, 192, 209 프레임(209 프레임 = 8.7초), H3가 직접 생성한 오디오 포함 [측정: 릴리스 바이너리로 `uret.ps1`을 통해 209 프레임, 실행 U209. latent는 개발 빌드 실행과 바이트 단위로 동일. 영상 안의 프레임과 오디오는 동일하며 파일 sha는 컨테이너 때문에 다름. 증거는 작성자가 보관 중이며 이 저장소에는 없음]. 209는 우리가 직접 보고 부드럽다고 확인한 가장 긴 길이입니다 [사용자 보고, 2026-11-19, 영상 전체 시청. 파일: F209V2 출력, 8.708초].
- **바이트 동일 주장, 범위를 정직하게 밝히면:** 패치하지 않은 기준과 바이트 단위로 동일함을 확인한 것은 56과 141 프레임뿐입니다. 158/175/192/209 프레임에서는 같은 플래그와 같은 바이너리 체인을 썼지만, 직접적인 바이트 기준은 없습니다(패치하지 않은 빌드는 이 GPU에서 그 길이를 실행할 수 없습니다).
- 품질 설정은 절대 낮추지 않습니다: 같은 모델/양자화, 6 스텝, cfg 1, 640x384, 같은 시드, 타일링하지 않은 VAE.
- 우리가 최초라고 주장하지 않습니다. 찾아본 결과 4 GB에서 이를 구현한 외부 사례를 찾지 못했지만, 그것이 존재하지 않는다는 증거는 아닙니다.

## 구성
- `patches/` 고정된 stable-diffusion.cpp 커밋에 대한 패치(그곳의 메모 참고)
- `scripts/` 빌드, 실행, 별도 프로세스 VAE, 게이트/일관성 도우미(`doku_norm.py`: 아래 스케일 참고 사항 확인)
- `docs/KURULUM.md` 하드웨어, 빌드, 실행 단계(EN+TR)
- `docs/YAMALAR.md` 패치 목록, `docs/KANITLAR.md` 증거, `docs/KAPILAR.md` 품질 게이트 표, `docs/OLCUMLER.md` 측정, `docs/SIK_HATALAR.md` 자주 하는 실수, `docs/LISANS_UYARISI.md` 라이선스 전체 항목
- `scripts/` 짧은 색인: `hiz_kos3.ps1` 실행 래퍼(`-Kuru`는 정확한 명령을 출력), `uretim_kapi.ps1` 품질 게이트, `dikis_denetim.py` 이음매 점검, `doku_norm.py` 텍스처 정규화 노이즈, `bayt_kiyas.py` 바이트 비교, `derleme_sablonu.ps1` 빌드 템플릿(자신의 빌드가 시작된 뒤에 실행된 Visual Studio 텔레메트리 도우미 `vctip.exe`만 종료합니다. 이를 두면 빌드 프로세스가 몇 분 동안 붙잡혀 있게 됩니다. 다른 `vctip.exe` 프로세스는 건드리지 않습니다)

## 품질 게이트 (결과를 인정하는 방법)

이 게이트는 움직임의 일관성(물체의 크기나 위치가 튀는 현상)을 검사하지 않습니다. 결과를 인정하기 전에 영상 전체를 직접 시청하세요.
1. 프레임 수와 오디오 존재 여부. 로그에 메모리 폴백이나 ALLOC_FAILED 줄이 없을 것.
2. 원시 노이즈 게이트: median 필터 잔차 <= 1.5 (0-255 스케일).
3. 텍스처 정규화 노이즈, `scripts/doku_norm.py`(이 저장소의 버전): N = 잔차 median / Sobel 텍스처, 6번째 프레임마다. **스케일 참고 사항:** 이 버전에서 측정한 10개 클립은 N = 0.034-0.052입니다(표는 `docs/KAPILAR.md`, F192/F209V2의 마지막 4분의 1은 0.062에 이름). 추가 게이트의 임계값은 N <= 0.065입니다. 다른 구현에서는 같은 클립에서 0.028-0.036이 측정되었으므로, 임계값은 버전 간에 호환되지 "않습니다". 매우 미세한 텍스처(잔디 열)에서는 깨끗한 N이 0.075였으므로, 임계값은 장면 계열마다 따로 정합니다. 견고한 고주파 추정량(sigma-HH <= 1.5. 깨끗한 경우 0.74-1.19, 노이즈 s=2를 더하면 2.2-3.0)을 추가 게이트로 권장합니다.

범위: VideoTurko 는 단일 패스 한 번(최대 209프레임, 약 8.7초)을 다룹니다. 우리가 직접 한 연결 테스트에서는 이음매가 보였습니다(장면이 깔끔하게 이어지지 않음). 따라서 더 긴 영화는 우리가 검증하는 범위에 포함되지 않습니다. 연결에는 커뮤니티 가이드 `docs/KLIP_ZINCIRI.md` 와 CPU 만 쓰는 보조 도구 `scripts/zincir.py`(`plan`, `son-kare`, `bagla`; 엔진을 절대 시작하지 않음)가 있습니다. 이어 붙인 영화의 품질은 측정하지 않았으므로 [미시도], 모든 이음매를 눈으로 그리고 `scripts/dikis_denetim.py` 로 확인하세요.
설정은 사용자의 자유입니다. 209 프레임은 4 GB 카드에서 우리가 테스트한 기본값이지, 반드시 따라야 하는 한계가 아닙니다. 17k+5 그리드(56, 73, ... 192, 209. `docs/KURULUM.md` 참고)에서 원하는 프레임 수를 고르고, 프롬프트, 시드, 해상도, 각종 플래그를 마음대로 바꾸세요. 짧은 클립은 메모리와 시간이 덜 들고, 더 큰 GPU에서는 더 긴 길이도 들어갈 수 있습니다.

## 모델 라이선스 경고
**VideoTurko에는 패치와 스크립트(MIT)만 들어 있습니다. 모델과 그 출력물을 사용하는 사람이 MiniMax 라이선스에 대한 책임을 직접 집니다.** 법률 자문이 아닙니다. 아래는 MiniMax H3 Community License(2026년 8월 2일)의 조항을 번호와 함께 요약한 것입니다. 구속력이 있는 것은 라이선스 원문입니다: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

이 저장소의 MIT 라이선스는 모델 가중치를 포함하지 않습니다. [`NOTICE`](NOTICE)를 참고하세요. 이 저장소에는 모델 가중치가 전혀 없습니다(MiniMax H3, HyperFlow-H3-Flash GGUF, VAE 파일 없음). 이 프로젝트는 MiniMax와 제휴하거나 승인을 받은 것이 아닙니다. 상업적 이용이 금지되어 있지는 않습니다(비상업 라이선스가 아닙니다). 조건은 아래와 같습니다.

**지역 (Applicable Territory)**
- **전문, I.3, I.5:** 전 세계. 단 유럽연합, 영국, 대한민국, 미국은 제외. 모델을 사용하면 라이선스에 동의한 것으로 봅니다.
- **II:** 사용, 복제, 배포, 파생물 생성, 수정에 대한 무상, 양도 불가, 제한적 라이선스. 지역 안에서만, 그리고 계약과 Exhibit A를 준수하는 경우에만 해당합니다. 제외된 지역의 사람은 MiniMax에 별도 라이선스를 요청할 수 있습니다.
- **V.4:** 지역 밖에서 모델, 그 파생물, 그리고 **출력물**(생성된 영상/오디오)을 사용, 복제, 수정, 배포, 표시하는 것은 허용되지 않습니다. **따라서 생성한 영상을 EU/영국/대한민국/미국에서 공개하거나 상영하는 것은 라이선스 범위 밖입니다.**
- **Exhibit A-1:** 지역 밖에서의 사용은 Acceptable Use Policy 위반입니다.

**배포 (III)** (이 저장소는 모델을 배포하지 않습니다. 직접 배포하는 경우)
- **III.1:** 모든 수령자에게 라이선스 사본을 제공할 것. **III.2:** 수정한 파일에 눈에 띄는 고지를 표시할 것.
- **III.3:** 권장(필수 아님): "Powered by MiniMax H3" 표시, 만든 파일에 AI 생성 식별자 붙이기, 공개 설명 글.
- **III.4:** 배포물에는 반드시 NOTICE 파일을 함께 제공하고 다음 문구를 넣을 것: "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12:** 기계가 생성했다는 사실을 명확히 밝히지 않고 콘텐츠를 공개 환경에 게시하는 것은 금지됩니다. AI로 생성한 영상은 게시할 때 그 사실을 표시하세요(전체 목록: `docs/LISANS_UYARISI.md`).
- **III (마지막 단락):** 자신이 수정한 부분에 자신의 저작권을 표시할 수 있으나, 사용/배포에 추가적이거나 다른 조건을 부과할 수 없습니다. 지역 규칙은 계속 적용됩니다.

**상업적 조건 (IV)**
- **IV.1:** 상업 제품/서비스의 연간 매출이 20 million USD(또는 그에 상당하는 금액)를 넘으면 api@minimax.io(제목 "MiniMax H3 licensing - authorization request")로 사전에 서면 승인을 받을 것.
- **IV.2:** 모델을 사용하는 상업 제품/서비스의 UI에 "MiniMax H3"를 눈에 띄게 표시할 것.

**사용 제한 (V)**
- **V.1:** 적용되는 법률(무역 규정 준수 포함)과 Exhibit A를 준수할 것. **V.2:** 접근 권한을 주는 모든 사람을 이 제한과 같거나 더 보호적인 조건으로 구속하고 이를 통지할 것.
- **V.3:** 모델이나 그 **출력물**을 다른 AI 모델(MiniMax H3와 그 파생물 제외)을 개선하는 데 사용할 수 없습니다. (I.11: 증류와 합성 출력물 학습으로 만든 모델은 "파생물"이 됩니다. 출력물 자체는 파생물이 아닙니다.)
- **V.5:** 제3자에게 모델로 출력물을 생성하는 제품/서비스/호스팅 서비스를 제공하는 경우: 운영 전과 운영 중에 합리적인 기술적·조직적 보호 장치, 신고 수단, 신속한 조사, 반복 위반자의 삭제/비활성화/정지를 갖출 것.

**상표와 권리 (VI)**
- **VI.1:** 자신이 만든 2차적 저작물과 모델 파생물은 자신이 소유합니다(MiniMax의 권리가 우선). **VI.2:** MiniMax의 이름/상표는 허락되지 않습니다(설명과 배포에 필요한 범위 제외). "MiniMax H3" 상표는 III.3을 준수하기 위한 목적으로만, 지역 안에서 사용할 수 있습니다. 제휴 관계가 있는 것처럼 보이게 하지 마세요.
- **VI.3:** 자료나 출력물이 자신의 권리를 침해한다고 주장하며 MiniMax 또는 다른 누군가를 고소하면, 그날로 자신의 모든 라이선스가 종료됩니다. 본인 또는 타인의 사용/배포로 생긴 제3자의 청구로부터 MiniMax를 방어하고 면책해야 합니다.
- **VI.4:** MiniMax는 출력물에 대한 권리를 주장하지 않습니다. 출력물과 그 사용에 대한 책임은 사용자 본인과 그 사용자들에게 있습니다.

**면책과 종료 (VII, VIII, IX)**
- **VII.1:** 지원/업데이트 의무 없음. **VII.2:** 모델과 출력물은 "있는 그대로(AS IS)" 제공되며 보증이 없습니다. 적합성은 본인이 판단하고 위험도 본인이 부담합니다. **VII.3:** MiniMax와 계열사는 법이 허용하는 범위에서 어떠한 손해에 대해서도 책임지지 않습니다.
- **VIII.1:** 동의 또는 접근 시점부터 효력 발생. **VIII.2:** 위반 시 MiniMax는 종료할 수 있으며, 사용자는 사용/배포를 중단하고 사본을 삭제하고 수령자에게 알려야 합니다(VI.1, VI.3, VII, IX는 존속).
- **IX:** 홍콩 특별행정구 법. 홍콩 법원의 전속 관할(UN CISG 제외).
- **추가 참고:** MiniMax H3의 인코더는 Qwen3-VL-32B(Apache 2.0)를 사용합니다.

**Acceptable Use Policy (Exhibit A)** (모델, 파생물, 출력물을 다음 목적으로 사용하지 마십시오)
- A-1 지역 밖에서의 사용, A-2 법률 또는 제3자 지식재산권 위반, A-3 자신이나 타인에 대한 위해, A-4 출력물을 해를 끼치는 용도로 전용/배포, A-5 보호 장치 우회, A-6 미성년자 착취/위해, A-7 타인을 해치거나 선거에 영향을 주기 위한 검증 가능한 허위 정보, A-8 가짜 온라인 참여(가짜 리뷰 등), A-9 명예훼손, 비방, 괴롭힘, A-10 악성코드, A-11 타인을 해치기 위한 개인정보 사용, **A-12 기계가 생성했다는 사실을 명확하고 눈에 띄게 밝히지 않고 콘텐츠를 공개 환경(봇 게시물 포함)에 게시하는 것**, A-13 동의 없는 사칭, A-14 핵심 분야(법 집행, 이민, 보건, 핵심 인프라, 신용, 고용, 주거, 교육, 사회적 점수 부여, 보험 등)에서의 고위험 자동화 의사결정, A-15 다른 국가/지역의 사회적, 윤리적, 도덕적 기준 위반, A-16 폭력적 극단주의/테러, A-17 보호되는 특성에 따른 차별/위해, A-18 취약 계층 착취, **A-19 군사적 목적**, A-20 허가/면허 없는 전문 활동(금융, 법률, 의료 등).
- 참고: 이것은 쉬운 말로 풀어 쓴 요약입니다. 의문이 있으면 영어 라이선스 원문이 우선합니다.

## 증거 라벨

모든 문서에 공통인 한 세트입니다(이전 표기는 괄호 안):
- **[측정]** (영어: measured, TR: ölçtüm, olctum): 이 프로젝트에서 실행했으며 증거 경로가 있음.
- **[읽음]** (영어: read, TR: okudum yol, okudum): 소스나 스크립트를 읽었으나 실행하지는 않음.
- **[설계]** (영어: design, TR: tasarım, tasarim): 설계만 했고 실제 실행에서는 아직 확인하지 못함.
- **[추정]** (영어: guess, TR: tahmin): 검증되지 않음.
- **[미시도]** (영어: not tried, TR: denenmedi): 한 번도 실행한 적 없음.
- **[사용자 보고]** (영어: user-reported, TR: kullanıcı bildirdi): 사용자가 날짜와 함께 말한 것. 독립적으로 측정하지 않음.
- **[계산]** (영어: computed, TR: hesap. 이전 표기: calculated, hesap): 측정한 입력에서 도출한 수치로, 그 자체를 측정한 것은 아님. 도출 과정은 수치 옆에 적음. 이전 글의 [제안] / [öneri]는 [추정]에 해당.

괄호 안에 쓰는 실행 이름(우리 자체의 실행 이름이며 이 저장소에 있는 파일이 아닙니다): U209 = 릴리스 바이너리로 `uret.ps1`을 통해 실행한 209 프레임. B209와 B192 = 209 및 192 프레임의 image-to-video(`-InitImg`) 실행. B56VT2 = 릴리스 바이너리, 56 프레임, 56 프레임 바이트 기준 R0와 비교. F209b, F209V2, F209V2K = 개발 빌드에서의 209 프레임 실행(자세한 내용: `docs/OLCUMLER.md`).

## 알려진 한계
- **바이트 증명**(직접 재현하는 방법: `docs/KANITLAR.md`의 "R0 ve latent referansi nasil uretilir". 우리의 sm_61 카드에서 확인했으며, 다른 GPU에서는 바이트 단위로 동일하지 않을 수 있음 [추정]): 우리 패치 시리즈(메모리 플래그 켬)로 56 프레임을 실행하면 sha256 `0979f156d548169b...`가 나왔고, 이는 기준과 동일했습니다 [측정]. 141 프레임에서는 latent sha256 `E5D028F8632BE4FE...`이(0013/0014 플래그 사용 시) 동일했습니다. 158~209 프레임에는 직접적인 바이트 기준이 없으며, 게이트 체인이 증거입니다. 수치 게이트를 통과했다고 좋은 클립이 보장되지는 않습니다. 시간에 따른 움직임의 일관성은 눈으로 확인합니다(`docs/KAPILAR.md` 참고).
- **209 프레임, 어떤 플래그 세트인가:** 209 프레임 바이트 체인 증거는 개발 빌드에서 F209V2 플래그 세트(block-tail 플래그 없음, 패치 0019/0020 없이 빌드)로 얻었습니다. `uret.ps1`은 209 프레임에 이 레시피를 사용합니다 [읽음: 스크립트. `uret.ps1`을 통한 실제 엔진 실행이 실행 U209에서 통과].
- 우리가 검증한 것은 카드 한 장(GTX 1050 Ti 4 GB)뿐이며, 다른 카드에 대한 외부 보고는 라벨과 함께 `docs/KART_PROFILLERI.md` 에 정리되어 있습니다 [사용자 보고].
- **어떤 바이너리를 측정했는가:** 141 프레임 latent와 바이트 체인은 우리 개발 빌드로 측정했습니다. 내려받는 릴리스 바이너리는 새로 빌드한 것으로, 56 프레임 바이트 게이트를 통과했고(다음 항목) `uret.ps1`을 통한 209 프레임 실행도 게이트를 통과했습니다(실행 U209, 3414초, VRAM 피크 3777 MiB) [측정]. 개발 빌드의 209 실행과 비교해 latent는 바이트 단위로 동일하고, 영상에서 프레임(md5)과 오디오는 동일하며, AVI 파일의 sha256은 컨테이너 때문에 다릅니다 [측정](`docs/OLCUMLER.md`의 섹션 0 참고).
- **릴리스 바이너리, 56 프레임:** 릴리스 바이너리(sd-cli `c5cebe78...`, stable-diffusion.dll `e5d3d329...`)는 56 프레임 결과를 R0와 바이트 단위로 동일하게 만들었습니다(sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`. 프레임별 md5와 오디오도 동일). 기본 플래그로 직접 실행(`SD_*` 변수 없음), 종료 코드 0, 601초 [측정: 실행 B56VT2, 2026-11-19. 증거는 작성자가 보관 중이며 이 저장소에는 없음]. 범위: 우리 sm_61 카드와 56 프레임에 한함. clean-root 설치 테스트가 아님. 141 프레임 latent와 209 체인은 이전 바이너리로 측정했으며 이 바이너리로는 반복하지 않았음 [미시도]. 첫 시도(B56VT, 도우미 스크립트 경유)는 58초 뒤 아무 출력 없이 끝났고 원인은 알 수 없습니다 [추정: 메모리 압박]. 두 번째 시도에서는 `sd-cli`를 직접 실행했습니다.
- 설치와 실행 스크립트는 아직 빈 폴더에서 검증하지 않았습니다(clean-root 테스트 대기 중).
- 로드맵과 다음 단계: `ROADMAP.md`.

## 상태와 한계
- 한 대의 PC(GTX 1050 Ti 4 GB, RAM 16 GB, i7-7700HQ)에서 검증했습니다. 다른 4 GB 카드나 다른 RAM 용량에서는 결과가 다를 수 있습니다.
- **기본 209 프레임(8.7초):** 우리 품질 게이트를 통과했습니다(노이즈 1.08, 실행 F209V2K) [측정: 릴리스 바이너리로 `uret.ps1`을 통해 209 프레임, 실행 U209. latent는 개발 빌드 실행과 바이트 단위로 동일. 영상 안의 프레임과 오디오는 동일하며 파일 sha는 컨테이너 때문에 다름. 증거는 작성자가 보관 중이며 이 저장소에는 없음]. 209 프레임에서 DiT의 VRAM 피크는 4096 MiB 중 3777 MiB였습니다(실행 F209b와 U209. 카드 전체 기준 `nvidia-smi` 값). 여유가 적어서, 다른 GPU 부하(화면 출력, 다른 애플리케이션)가 있으면 실행이 `blocks.0`에서 실패할 수 있습니다. GTX 1050 Ti에서만 테스트했습니다. 그 실행 중 화면 출력 상태는 기록하지 않았습니다. 화면이 이 카드에서 출력된다면 사용할 수 있는 VRAM이 줄어듭니다 [추정: Windows 화면 출력 부하 약 100-300 MB]. 필요하면 모니터를 내장 GPU에 연결하세요 [권고, 미시도]. 샘플링에는 2730초(실행 U209: 스텝당 436-483초), 별도 프로세스 VAE 디코딩에는 173초가 걸렸습니다(오디오 디코딩을 포함한 2단계 합계 193초) [측정: U209 릴리스 바이너리. 이전 개발 빌드 실행: 2664초와 174초]. 1단계에서는 프로세스 내 VAE의 메모리가 부족해 temporal tiling으로 대체되었습니다(320초). 그 출력은 폐기되며, 영상은 타일링하지 않은 2단계에서 나옵니다. U209에서는 RAM 피크를 측정하지 않았습니다. 209 프레임보다 긴 클립은 이번 릴리스에 포함되지 않습니다.
- **image-to-video(`-InitImg`):** 초기 이미지를 쓰면 이 GPU에서의 상한은 192 프레임(24 fps에서 8.0초)입니다. 209 프레임은 들어가지 않았습니다(block 0에서 VRAM이 약 17.5 MB 부족: 필요 2587 MB, 사용 가능 2570 MB). 192 프레임은 `uret.ps1`을 통해 3086초에 실행되었고 VRAM 피크는 3783 MiB였으며 게이트를 통과했습니다 [측정: 실행 B209와 B192, 2026-11-20, 장면 1개. 증거는 작성자가 보관 중이며 이 저장소에는 없음]. 다른 GPU에서는 시도하지 않았습니다 [미시도].
- **여유 RAM이 중요합니다:** 여유 RAM이 약 11 GB 필요합니다(엔진 프로세스가 약 11 GB를 차지합니다) [측정]. 여유 RAM이 너무 적으면 프로세스가 오류 메시지 없이 종료될 수 있습니다 [추정: 여유 RAM이 약 300 MB이고 `sd-cli`가 약 10 GB를 차지하던 때에 한 번 관찰함]. 실행 중에는 다른 큰 프로그램을 열지 마세요. 16 GB PC에서는 여유가 0.3-0.5 GB 정도만 남으며, 메모리 압박 상태에서는 실행이 조용히 종료될 수 있습니다. 시작하기 전에 브라우저, 게임, 그 밖의 큰 프로그램을 종료하고 여유 RAM을 확인하세요.
- **clean-root 테스트 대기 중:** 설치와 실행 스크립트는 이 안내만으로 빈 폴더에서 검증한 적이 아직 없습니다. 그 테스트(기준에 대한 56 프레임 바이트 비교 포함)를 기록하면 이 섹션을 갱신하겠습니다.
- 생성된 영상은 여기에 포함되어 있지 않습니다.

<!-- i18n-source: README.md sha256:67497404d89b -->
