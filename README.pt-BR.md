# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · Português (BR) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

As traduções seguem este README em inglês. Se uma tradução divergir ou ficar atrasada, o texto em inglês prevalece, principalmente no texto de licença e de segurança ([`SECURITY.md`](SECURITY.md) e [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) são mantidos apenas em inglês e turco).

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **Antes de começar (licença, território):** este repositório é MIT e contém apenas patches e scripts. O modelo MiniMax H3 que ele baixa está sob a MiniMax H3 Community License: o território dela exclui a União Europeia, o Reino Unido, a Coreia do Sul e os Estados Unidos, e o modelo, os derivados **e as saídas (os vídeos que você gera)** não podem ser usados, distribuídos nem exibidos lá (V.4). O uso comercial é permitido dentro dos termos da licença. Leia [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) antes de instalar; isto não é aconselhamento jurídico.

> **Em 30 segundos:** uma placa de vídeo de 4 GB consegue gerar um vídeo MiniMax H3 de 209 quadros (8,7 s) em uma única passada: verificado em uma única máquina (GTX 1050 Ti de 4 GB; a instalação completa com `kur.ps1` em uma pasta vazia ainda não foi verificada de ponta a ponta) [medido: 209 quadros com o binário da versão publicada por meio do `uret.ps1`, execução U209; latente idêntico byte a byte ao da execução com o binário de desenvolvimento; quadros e áudio idênticos no vídeo, o sha do arquivo difere por causa do contêiner; as evidências ficam com os autores, não estão neste repositório]; com `-InitImg` (imagem para vídeo) no máximo 192 quadros (8,0 s) [medido: execução B192]; 209 quadros levam cerca de 57 min, o limite de tempo padrão é de 80 min [medido: execução U209]; os 3 passos abaixo mostram como executar.

VideoTurko: patches de memória para o stable-diffusion.cpp e receitas para rodar o MiniMax H3 de texto para vídeo em uma GTX 1050 Ti de 4 GB, até 209 quadros (8,7 s) em uma única passada; imagem para vídeo (`-InitImg`) até 192 quadros (8,0 s) (209 quadros verificados por uma cadeia de bytes; idêntico byte a byte à execução sem patches nas verificações de 56 e 141 quadros).

## Início rápido (Windows, 3 passos)
**Status: os scripts de instalação e execução abaixo estão sendo finalizados e o teste em raiz limpa está pendente; nada aqui é dado como funcionando até que esse teste passe (veja "Status e limites").**

1. **Baixe** este repositório (botão verde **Code**, depois **Download ZIP**) e extraia em uma pasta CURTA, por exemplo `C:\vt`.
2. **Instalar: dê dois cliques em `kur.cmd`** (abre uma janela preta que mostra cada etapa; fechá-la interrompe a instalação, e executar de novo continua de onde parou: um arquivo de modelo baixado pela metade é retomado [lido: o script de download mantém um arquivo `.part` e continua a partir dele; uma retomada completa de 29 GiB não foi medida]). Se o Windows avisar sobre o arquivo baixado, use o comando do PowerShell abaixo [recomendação, não testada com um ZIP baixado]. Prefere a linha de comando? Abra o PowerShell nessa pasta (digite `powershell` na barra de endereços do Explorer) e execute a mesma instalação:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   A raiz da instalação é a pasta que você extraiu (o motor vai para `engine\bin`, os modelos para `model`); para usar outro local, defina antes a variável de ambiente `VT_ROOT`. O script verifica GPU, driver, RAM e disco, baixa o motor e os modelos (os zips do motor e os arquivos de modelo recém-baixados são verificados com sha256; um arquivo de modelo já presente com o tamanho certo é verificado apenas pelo tamanho, `scripts\modelleri_indir.ps1 -Dogrula` executa a verificação sha256 completa), roda uma rápida verificação real e imprime READY somente se essa verificação passou [projeto: o `kur.ps1` não foi executado por inteiro em uma pasta limpa; esta frase será atualizada depois do teste em pasta limpa]. O `-ExecutionPolicy Bypass` vale apenas para este processo; leia o `scripts\kur.ps1` antes, como com qualquer instalador.
   O zip do motor vem da versão v0.1.0 do GitHub (publicada em 2026-11-19; o sha256 dela está fixado no `kur.ps1`). Offline ou com sua própria compilação, informe zips locais: `-MotorZip <path> -CudaZip <path>`. Um zip local é conferido com o mesmo sha256 fixado (um arquivo `.sha256` ao lado é ignorado), então ele precisa ser o zip da versão publicada; para sua própria compilação, defina antes `VT_MOTOR_SHA256` / `VT_CUDA_SHA256` com o sha256 dela. Um sha256 errado para com exit 1. Apenas `.exe`/`.dll` vão para `engine\bin`; licenças e README vão para `engine\lisanslar\<zip name>\`. [testado com os zips de dist antes da publicação: o `.sha256` ao lado mais o aviso autorreferente, binário e DLLs colocados, `sd-cli --help` rodou; os sha dos binários instalados bateram (`c5cebe78...`, `e5d3d329...`); a etapa dos modelos e a verificação de 5 quadros do `kur.ps1` AINDA NÃO foram executadas em uma GPU real]
   **Licença do modelo:** antes da etapa dos modelos o instalador mostra o resumo da licença (`docs/LISANS_KABUL.txt`, texto completo `docs/LISANS_UYARISI.md`: MiniMax H3 Community License, limites territoriais que também cobrem os vídeos gerados, regras comerciais e de rotulagem de IA) e pede que você aceite (`E` = sim). Leia antes. Para execuções sem supervisão você pode passar `-LisansKabul E`, o que significa que você mesmo leu e aceitou; não o adicione por outra pessoa. (Agentes de IA: sigam o `AGENTS.md`; nunca digitem E sem o consentimento do usuário.) Sem aceite, o `kur.ps1` para com código de saída 2 e não baixa nenhum modelo.
3. **Seu primeiro vídeo (56 quadros, cerca de 11 min na nossa GTX 1050 Ti** [medido: 641 s, execução R0, `docs/OLCUMLER.md`; outras placas não medidas]**)**: quando o instalador imprimir `HAZIR / READY`, execute
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (atalho: arraste um arquivo de texto com o prompt para `uret.cmd`, ou execute `uret.cmd docs\ornek_istem_R0.txt`: a mesma execução de 56 quadros). O vídeo fica em `runs\`. Depois escreva seu próprio prompt em um arquivo de texto (um parágrafo em inglês, frase `audio:` opcional) e execute o clipe mais longo que cobrimos (padrão, cerca de 57 min [medido: execução U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   O `-Kare` segue a grade 17k+5 (56, 73, ... 192, 209); o padrão é 209 (8,7 s), a duração mais longa que cobrimos. O VAE roda em um processo separado, nunca em blocos (tiling) [uma execução real do motor por meio do `uret.ps1` com o binário da versão publicada, VAE em processo separado, passou na execução U209].

   Guia para escrever o prompt: [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (padrão de uma tomada contínua, fatias de tempo iguais, dois exemplos completos).

| Requisito | Valor |
|---|---|
| SO | Windows 10/11, 64 bits |
| GPU | NVIDIA, 4 GB ou mais; testado apenas em GTX 1050 Ti (sm_61); margem estreita (3777/4096 MiB com 209 quadros): uma tela em uso ou um navegador aberto pode quebrar a execução; nenhuma outra placa de 4 GB foi testada |
| RAM | 16 GB (pico de cerca de 11 GB; feche outros programas) |
| Disco | pelo menos 32 GiB livres (recomendado 40 GiB ou mais: entre 32 e 40 o instalador mostra um aviso, `[VT-W-DISK-PAY]` [medido: execuções de `-Kuru` com disco simulado]), modelos em um SSD (de preferência NVMe) |
| Download | zip do motor 36,8 MB + zip do runtime CUDA 567,5 MB [medido] + modelos 31.473.112.040 bytes (cerca de 29,3 GiB) [lido: tamanhos em `scripts/modeller.json`]; cerca de 30 GiB no total |
| Modelos | não incluídos; baixados pelo instalador sob a licença da MiniMax (veja o aviso abaixo). Os modelos (29,3 GiB, 31.473.112.040 bytes em `scripts/modeller.json`) não estão neste repositório nem na versão publicada: valem os limites de tamanho de arquivos e releases do GitHub, e o `kur.ps1` os baixa da fonte oficial com verificação sha256. |

Códigos de saída do `kur.ps1`: 0 READY, 1 erro, 2 é preciso uma ação do usuário (licença, ou ainda não há versão/zip), 3 hardware ou disco insuficientes, 4 interrompido (arquivo DUR). O `uret.ps1` só aceita uma execução se o `.avi` existir, o número de quadros estiver certo e os logs estiverem limpos [medido: uma execução real por meio do `uret.ps1` com o binário da versão publicada, execução U209, 209 quadros, portão aprovado]. Códigos de saída do `uret.ps1`: 0 DONE (portão de qualidade aprovado), 1 erro ou saída inválida (inclusive vídeo sem faixa de áudio), 2 interrompido (arquivo DUR), 5 `KAPI RED` (portão de qualidade reprovado: o clipe não é aceito, a decisão é sua), 6 o portão não pôde ser executado (clipe não aceito). Detalhes no AGENTS.md. [medido: códigos de saída 0, 1 (vídeo sem áudio), 5 e 6 em cenários com um motor falso e um portão falso; motor real: exit 0 na execução U209]

### Solução de problemas (detalhes: `docs/SIK_HATALAR.md`)
As linhas de erro dos nossos scripts trazem um código estável, por exemplo `HATA: [VT-E-DLL] ...` ou `UYARI: [VT-W-DISK-PAY] ...`. Procure o código em [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) (exemplo de âncora `#vt-e-dll`) ou em `docs/hata_imzalari.json` e coloque o código na sua issue. A primeira coluna da tabela abaixo fica como é impressa (não traduza códigos nem texto de log).

| O que você vê | O que significa e o que fazer |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | Não inicie o `sd-cli.exe` manualmente; execute `scripts\kur.ps1`, que coloca as DLLs do CUDA no lugar. |
| `failed during weight preparation` em `blocks.0` (#1, #3, #5) | VRAM insuficiente no portão de memória: use menos quadros na grade 17k+5, feche outros programas que usam a GPU e mantenha as opções que acompanham o projeto. |
| `retrying with temporal tiling` (#6) | O VAE recorreu ao tiling; a saída é inválida para fins de qualidade. Execute de novo. |
| A execução termina no limite de tempo, sem vídeo (#7) | Aumente o `-TavanDk` para clipes longos (limite de tempo padrão: 80 min para 209 quadros, definido pelo `uret.ps1`; nossa execução de 209 quadros levou 57 min [medido: execução U209]). |
| Código de saída vazio, mas "terminou" (#14) | O wrapper leu o código de saída cedo demais; execute de novo e confira se o arquivo de vídeo existe. |
| O sistema fica lento, usando swap (#18) | O motor usa cerca de 10-11 GB de RAM; feche navegadores e outros programas. |
| sha256 não confere / o download falhou | Normalmente um download interrompido: execute o mesmo comando de novo, os arquivos já verificados são pulados. |

**Travou ou está curioso?** [`SUPPORT.md`](SUPPORT.md) (onde perguntar; prazos de resposta são metas, não compromissos) · [`PRIVACY.md`](PRIVACY.md) (sem telemetria; a rede só é usada para baixar o motor e os modelos, dos hosts listados) · [`SECURITY.md`](SECURITY.md) (relato privado de vulnerabilidades) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (primeiro pull request em 5 passos; não é preciso GPU para documentos e scripts).

### Novidades da v0.1.1: mais opções (detalhes: `AGENTS.md`, `docs/SIK_HATALAR.md` 19-23)
Sem essas opções nada muda em uma placa de 4 GB (a verificação byte a byte de 56 quadros contra a nossa referência passou de novo com a v0.1.1 [medido]). Acrescente `-Kuru` a qualquer comando para ver o que seria executado.
- `-EndImg`: informe também o último quadro (primeiro e último quadro, "FLF"); limite de 175 quadros em placas com menos de 8 GB (192 não coube em 4 GB), 192 em placas de 8 GB ou mais. Na nossa GTX 1050 Ti ele roda sempre em dois processos: 56 quadros em 1040 s, 175 quadros em 2887 s (48 min), ambos aprovados no portão [medido]. Dicas para o prompt: `docs/ISTEM_YAZIMI.md`.
- `-W` / `-H`: outros tamanhos, por exemplo vertical 384x640; múltiplos de 32, área de pelo menos 640x384 (nunca menor). Não testado em 4 GB; em placas com menos de 8 GB, tamanhos além da nossa maior execução medida são recusados. Os limiares do portão de qualidade são calibrados em 640x384.
- `-TekAsama`: um processo em vez de dois, só para placas grandes; nunca é ativado automaticamente.
- GPUs mais novas (compute capability 7.0+, por exemplo RTX 20/30/40): `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` é definido automaticamente, a menos que você mesmo o defina; isso corrigiu um vídeo totalmente preto a partir de 141 quadros na RTX 4070 Ti de quem relatou [relatado pelo usuário, issue #1]. Sem Python + OpenCV, o `uret.ps1` agora para com exit 6 antes do trabalho na GPU (nenhum vídeo gerado, sem RED enganoso).
- Obrigado a @SinanC73 pelo relato sobre a RTX 4070 Ti que levou a essas mudanças ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1)).

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

## Perfis de velocidade opcionais (pacote de velocidade; desligados por padrão)
Nada abaixo muda a execução padrão (640x384, 209 quadros, 3414 s na nossa placa). São três células medidas além dela, cada uma um perfil nomeado do `uret.ps1`; elas precisam do motor do pacote de velocidade (o motor da release mais os patches 0021, 0023 e 0024, todos desligados por padrão: `docs/YAMALAR.md`). Instale com `scripts\kur.ps1 -HizPaketi` (um zip local funciona com `-MotorZip`) e depois acrescente `-Profil <name>`; `-Kuru` mostra o que seria executado. O pacote de velocidade é publicado com a versão v0.1.4.

| Perfil | Tamanho, duração | Tempo total em uma GTX 1050 Ti 4 GB | Status |
|---|---|---|---|
| (nenhum, padrão) | 640x384, até 209 quadros (8,7 s) | 209 quadros: 3414 s | verificado, inalterado |
| `yuksek832` | 832x480, 141 quadros (5,9 s) | cerca de 55-56 min | utilizável, dois prompts [medido] |
| `yuksek832 -Kare 124` | 832x480, 124 quadros (5,2 s) | cerca de 45-46 min, sem flag de velocidade | utilizável, dois prompts [medido] |
| `yuksek896` | 896x512, 124 quadros (5,2 s) | cerca de 56-57,5 min | utilizável, dois prompts [medido] |
| `uzun260` | 640x384, 260 quadros (10,8 s) | 78 min medidos sem a saída antecipada; com ela, cerca de 71-72 min [estimativa: não medido de ponta a ponta pelo `uret.ps1`] | condicional e experimental |

- **Margem estreita:** a 832x480 x 141 o portão de memória deixa uma margem de apenas um dígito em MB (5,7 e 6,8 MB nas duas execuções completas). Dois prompts longos (1520 e 2041 caracteres) foram verificados apenas lendo o portão do passo 1 e de parte do passo 2, sem execução completa: margem de 10,9 e 4,0 MB. Qualquer outro processo que ocupe a memória da placa (navegador, segundo monitor) pode fazê-lo falhar; nesse caso use `-Kare 124` ou o tamanho padrão [medido, GTX 1050 Ti 4 GB].
- **`uzun260` é condicional:** o limite de memória é muito estreito (pico de VRAM 3903 de 4096 MiB), o uso de memória compartilhada cresceu 45 e 61 MiB (limite 68) e não existe referência sem flags para a igualdade byte a byte, por isso não é oferecido como recurso comum. O patch 0023 é aceito apenas para esta célula.
- **Não oferecido:** 832x480 com 158 quadros não cabe com os patches incluídos (na comporta do passo 2 faltam cerca de 280 MB); 175 quadros só foi verificado lendo a comporta (faltavam cerca de 275 MB no primeiro bloco, sem execução completa). O perfil oferece apenas 141 quadros. Outros tamanhos e números de quadros são recusados por `-Profil` (use o caminho padrão).
- A qualidade padrão não é tocada: 6 passos, cfg 1, VAE sem tiles, 17k+5 quadros. Onde as flags estão ligadas, a saída foi comparada byte a byte com o vídeo sem flags nos tamanhos em que a execução sem flags cabe (`docs/YAMALAR.md`); em 832x480 x 141 e 896x512 x 124 a execução sem flags não cabe, então a igualdade ali se apoia nas células mais próximas, não em uma comparação direta [medido, lido].
- A etapa 1 de uma execução em duas etapas agora termina assim que o arquivo latente está completo (`VT_ERKEN_CIKIS=0` desliga isso).

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

## O que é isto
Um conjunto de pequenos patches de memória e agendamento para o stable-diffusion.cpp, mais a receita de execução, as verificações e as medições que permitem rodar o MiniMax H3 (DiT de 33B; rodamos o GGUF HyperFlow Flash 13.7B Q4_K_M; o codificador de texto Qwen3-VL de 32B é separado) em uma GPU Pascal de 4 GB (GTX 1050 Ti, 16 GB de RAM do sistema).
- Durações em uma única passada que de fato produzimos e que passaram em nossos portões de qualidade: 56, 141, 158, 175, 192, 209 quadros em 640x384, 24 fps (209 quadros = 8,7 s), com o áudio gerado pelo próprio H3 [medido: 209 quadros com o binário da versão publicada por meio do `uret.ps1`, execução U209; latente idêntico byte a byte ao da execução com o binário de desenvolvimento; quadros e áudio idênticos no vídeo, o sha do arquivo difere por causa do contêiner; as evidências ficam com os autores, não estão neste repositório]. 209 é a duração mais longa que assistimos e achamos fluida [relatado pelo usuário, 2026-11-19, vídeo assistido por inteiro; arquivo: saída do F209V2, 8,708 s].
- **Afirmação de resultado idêntico byte a byte, com o escopo correto:** as saídas foram verificadas como idênticas byte a byte à referência sem patches apenas com 56 e 141 quadros. Com 158/175/192/209 quadros usamos as mesmas opções e a mesma cadeia de binários; não há referência direta byte a byte (a versão sem patches não consegue rodar essas durações nesta GPU).
- As configurações de qualidade nunca são reduzidas: mesmo modelo/quantização, 6 passos, cfg 1, 640x384, mesma seed, VAE sem tiling.
- Não afirmamos ser os primeiros: pesquisamos e não achamos nenhum exemplo externo disto em 4 GB, o que não prova que não exista.

## Estrutura
- `patches/` patches sobre um commit fixo do stable-diffusion.cpp (veja as notas lá)
- `scripts/` compilação, execução, VAE em processo separado, auxiliares de portão/consistência (`doku_norm.py`: veja a nota de escala abaixo)
- `docs/KURULUM.md` hardware, etapas de compilação e execução (EN+TR)
- `docs/YAMALAR.md` lista de patches, `docs/KANITLAR.md` evidências, `docs/KAPILAR.md` tabela de portões de qualidade, `docs/OLCUMLER.md` medições, `docs/SIK_HATALAR.md` erros comuns, `docs/LISANS_UYARISI.md` todos os itens da licença
- `scripts/` índice curto: `hiz_kos3.ps1` wrapper de execução (`-Kuru` imprime o comando exato), `uretim_kapi.ps1` portão de qualidade, `dikis_denetim.py` verificação de emendas, `doku_norm.py` ruído normalizado por textura, `bayt_kiyas.py` comparação byte a byte, `derleme_sablonu.ps1` modelo de compilação (encerra apenas o auxiliar de telemetria do Visual Studio `vctip.exe` que iniciou depois da sua própria compilação, o qual, de outro modo, mantém o processo de compilação preso por minutos; os demais processos `vctip.exe` não são tocados)

## Portões de qualidade (como um resultado é aceito)

Este portão não verifica a consistência do movimento (saltos de escala ou de posição de objetos): assista ao vídeo inteiro antes de aceitá-lo.
1. Número de quadros e áudio presente; sem fallback de memória nem linhas ALLOC_FAILED no log.
2. Portão de ruído bruto: resíduo do filtro de mediana <= 1,5 (escala 0-255).
3. Ruído normalizado por textura, `scripts/doku_norm.py` (a versão deste repositório): N = resíduo mediano / textura de Sobel, a cada 6º quadro. **Nota de escala:** nesta versão os 10 clipes medidos dão N = 0,034-0,052 (tabela em `docs/KAPILAR.md`; o último quarto de F192/F209V2 chega a 0,062) e o limiar do portão extra é N <= 0,065. Outra implementação mediu 0,028-0,036 nos mesmos clipes, então os limiares NÃO são intercambiáveis entre versões. Em texturas muito finas (fileiras de grama) o N limpo foi 0,075, então o limiar é por família de cenas. Um estimador robusto de alta frequência (sigma-HH <= 1,5; limpo 0,74-1,19, com ruído adicionado s=2 dá 2,2-3,0) é o portão extra recomendado.

Escopo: o VideoTurko trata de UMA única passagem (até 209 quadros, cerca de 8,7 s). Nosso próprio teste de encadeamento mostrou emendas visíveis (a cena não continua de forma limpa), então filmes mais longos não fazem parte do que verificamos. Para encadear há o guia da comunidade `docs/KLIP_ZINCIRI.md` e nosso utilitário só de CPU `scripts/zincir.py` (`plan`, `son-kare`, `bagla`; ele nunca inicia o motor); não medimos a qualidade de filmes encadeados [não testado], por isso confira cada emenda a olho e com `scripts/dikis_denetim.py`.
Suas configurações são suas: 209 quadros é o nosso padrão testado em uma placa de 4 GB, não um limite que você precise usar. Escolha qualquer número de quadros da grade 17k+5 (56, 73, ... 192, 209; veja `docs/KURULUM.md`), mude o prompt, a seed, a resolução ou qualquer opção como quiser. Clipes mais curtos usam menos memória e tempo; GPUs maiores podem comportar mais.

## Aviso sobre a licença do modelo
**O VideoTurko contém apenas patches e scripts (MIT); quem usa o modelo e suas saídas é quem responde pela licença da MiniMax.** Não é aconselhamento jurídico. Abaixo estão as cláusulas da MiniMax H3 Community License (2 de agosto de 2026) resumidas com a numeração; a licença em si é a que vale: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

A licença MIT deste repositório não cobre os pesos do modelo; veja [`NOTICE`](NOTICE). Este repositório NÃO contém pesos de modelo (nenhum arquivo do MiniMax H3, do GGUF HyperFlow-H3-Flash nem do VAE). Este projeto não é afiliado à MiniMax nem endossado por ela. O uso comercial NÃO é proibido (não é uma licença não comercial); as condições estão abaixo.

**Território (Applicable Territory)**
- **Preâmbulo, I.3, I.5:** No mundo todo, EXCETO a União Europeia, o Reino Unido, a República da Coreia e os Estados Unidos. Usar o modelo conta como aceitar a licença.
- **II:** Licença limitada, intransferível e isenta de royalties para usar, reproduzir, distribuir, criar obras derivadas e modificar, apenas dentro do território e em conformidade com o contrato e o Exhibit A. Pessoas em territórios excluídos podem pedir à MiniMax uma licença separada.
- **V.4:** Usar, reproduzir, modificar, distribuir ou exibir o modelo, seus derivados E SUAS SAÍDAS (vídeo/áudio gerado) fora do território não é autorizado. **Portanto, publicar ou exibir vídeos gerados na UE, no Reino Unido, na Coreia do Sul ou nos EUA está fora da licença.**
- **Exhibit A-1:** O uso fora do território viola a Acceptable Use Policy.

**Distribuição (III)** (este repositório não distribui o modelo; caso você distribua)
- **III.1:** Entregue a cada destinatário uma cópia da licença. **III.2:** Marque os arquivos modificados com avisos bem visíveis.
- **III.3:** Recomendado (não obrigatório): um aviso "Powered by MiniMax H3", um identificador de geração por IA nos arquivos produzidos, um texto público sobre o trabalho.
- **III.4:** As distribuições DEVEM vir acompanhadas de um arquivo NOTICE com: "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12:** é proibido publicar conteúdo em qualquer ambiente público sem declarar claramente que ele foi gerado por máquina: rotule como gerados por IA os vídeos que você publicar (lista completa: `docs/LISANS_UYARISI.md`).
- **III (último parágrafo):** Você pode adicionar seu próprio copyright às suas modificações, mas não pode impor termos adicionais ou diferentes sobre o uso/distribuição; as regras territoriais continuam valendo.

**Condições comerciais (IV)**
- **IV.1:** Se seus produtos/serviços comerciais geram mais de 20 milhões de USD (ou o equivalente) de receita anual, obtenha autorização PRÉVIA por escrito em api@minimax.io (assunto "MiniMax H3 licensing - authorization request").
- **IV.2:** A interface de um produto/serviço comercial que use o modelo deve exibir de forma destacada "MiniMax H3".

**Restrições de uso (V)**
- **V.1:** Cumpra a lei aplicável (inclusive a de conformidade comercial) e o Exhibit A. **V.2:** Vincule todos a quem você der acesso a termos ao menos tão protetores quanto estas restrições e avise-os.
- **V.3:** Você não pode usar o modelo nem suas SAÍDAS para melhorar nenhum outro modelo de IA (exceto o MiniMax H3 e seus derivados). (I.11: a destilação e o treinamento com saídas sintéticas tornam um modelo um "derivado"; as saídas em si não são derivados.)
- **V.5:** Se você oferecer a terceiros um produto/serviço/serviço hospedado que gere saídas com o modelo: antes e durante toda a operação, salvaguardas técnicas e organizacionais razoáveis, um mecanismo de denúncia, apuração imediata e remoção/desativação/suspensão de infratores reincidentes.

**Marca e direitos (VI)**
- **VI.1:** Você é dono das obras derivadas e dos derivados do modelo que criar (sujeito aos direitos da MiniMax). **VI.2:** Os nomes/marcas da MiniMax não são licenciados (além do necessário para descrever e distribuir); a marca "MiniMax H3" só pode ser usada para cumprir o III.3, dentro do território; não sugira afiliação.
- **VI.3:** Se você processar a MiniMax ou qualquer pessoa alegando que os materiais/saídas violam seus direitos, todas as suas licenças terminam nesse dia; você defende e indeniza a MiniMax contra reclamações de terceiros decorrentes do uso/distribuição por você ou por outros.
- **VI.4:** A MiniMax não reivindica direitos sobre as saídas; você e seus usuários são responsáveis pelas saídas e pelo uso delas.

**Isenções de responsabilidade e rescisão (VII, VIII, IX)**
- **VII.1:** Sem obrigação de dar suporte/atualizar. **VII.2:** O modelo e as saídas são fornecidos "AS IS", sem garantias; você decide se servem e assume o risco. **VII.3:** A MiniMax e suas afiliadas não respondem por nenhum dano (na medida em que a lei permitir).
- **VIII.1:** Vigora a partir do aceite/acesso. **VIII.2:** Em caso de violação a MiniMax pode rescindir; você deve parar de usar/distribuir, apagar as cópias e avisar os destinatários (VI.1, VI.3, VII, IX continuam valendo).
- **IX:** Lei da RAE de Hong Kong; jurisdição exclusiva dos tribunais de Hong Kong (a CISG da ONU é excluída).
- **Observação adicional:** o codificador do MiniMax H3 usa o Qwen3-VL-32B (Apache 2.0).

**Política de Uso Aceitável (Exhibit A)** (NÃO use o modelo, os derivados nem as saídas para)
- A-1 uso fora do território; A-2 violar leis ou a propriedade intelectual de terceiros; A-3 prejudicar a si mesmo ou a outros; A-4 reaproveitar/distribuir saídas para causar dano; A-5 burlar salvaguardas; A-6 explorar/prejudicar menores; A-7 informação comprovadamente falsa para prejudicar outros ou influenciar eleições; A-8 engajamento falso on-line (avaliações falsas etc.); A-9 difamação, depreciação, assédio; A-10 malware; A-11 dados pessoais para prejudicar outros; **A-12 publicar conteúdo em qualquer ambiente público (inclusive postagens de bots) sem declarar de forma clara e destacada que foi gerado por máquina**; A-13 falsa identidade sem consentimento; A-14 decisões automatizadas de alto risco em áreas críticas (aplicação da lei, imigração, saúde, infraestrutura crítica, crédito, emprego, moradia, educação, pontuação social, seguros etc.); A-15 violar padrões sociais, éticos e morais de outros países/regiões; A-16 extremismo violento/terrorismo; A-17 discriminação/dano com base em características protegidas; A-18 explorar populações vulneráveis; **A-19 fins militares**; A-20 atividade profissional não autorizada/sem licença (financeira, jurídica, médica etc.).
- Observação: este é um resumo em linguagem simples; em caso de dúvida, prevalece o texto da licença em inglês.

## Rótulos de evidência

Um único conjunto para todos os documentos (entre colchetes, as grafias antigas):
- **[medido]** (TR: ölçtüm, olctum): executado neste projeto, o caminho da evidência existe.
- **[lido]** (TR: okudum yol, okudum): a fonte ou o script foi lido, não executado.
- **[projeto]** (TR: tasarım, tasarim): projetado, ainda não visto em uma execução real.
- **[estimativa]** (TR: tahmin): não verificado.
- **[não testado]** (TR: denenmedi): nunca executado.
- **[relatado pelo usuário]** (TR: kullanıcı bildirdi): declarado pelo usuário, com data; não medido de forma independente.
- **[calculado]** (TR: hesap; grafias antigas: calculated, hesap): um número derivado de entradas medidas, não medido em si; a derivação está escrita ao lado. [proposal] / [öneri] em textos antigos = [estimativa].

Nomes de execução usados entre colchetes (nossos próprios nomes de execução, não arquivos deste repositório): U209 = 209 quadros com o binário da versão publicada por meio do `uret.ps1`; B209 e B192 = execuções de imagem para vídeo (`-InitImg`) com 209 e 192 quadros; B56VT2 = binário da versão publicada, 56 quadros, comparado com a referência byte a byte de 56 quadros R0; F209b, F209V2, F209V2K = execuções de 209 quadros no build de desenvolvimento (detalhes: `docs/OLCUMLER.md`).

## Limitações conhecidas
- **Prova byte a byte** (como reproduzi-la você mesmo: `docs/KANITLAR.md`, "R0 ve latent referansi nasil uretilir"; verificada em nossa placa sm_61, outras GPUs podem não ser idênticas byte a byte [estimativa]): com nossa série de patches (opções de memória ligadas) uma execução de 56 quadros deu sha256 `0979f156d548169b...`, idêntico à referência [medido]; com 141 quadros o sha256 do latente `E5D028F8632BE4FE...` foi idêntico (com as opções 0013/0014). Os quadros de 158 a 209 não têm referência direta byte a byte; a cadeia de portões é a evidência. Passar nos portões numéricos não garante um bom clipe: a consistência do movimento ao longo do tempo é conferida a olho (veja `docs/KAPILAR.md`).
- **209 quadros, com qual conjunto de opções:** a evidência da cadeia de bytes de 209 quadros foi obtida com o conjunto de opções F209V2 no build de desenvolvimento (sem opções de cauda de bloco, compilado sem os patches 0019/0020); o `uret.ps1` usa essa receita para 209 quadros [lido: o script; uma execução real do motor por meio do `uret.ps1` passou na execução U209].
- Verificado por nós em uma placa (GTX 1050 Ti 4 GB); relatos externos de outras placas estão listados com seus rótulos em `docs/KART_PROFILLERI.md` [relatado pelo usuário].
- **Qual binário foi medido:** o latente de 141 quadros e a cadeia de bytes foram medidos com nossos builds de desenvolvimento. O binário da versão publicada que você baixa é um build novo: seu portão byte a byte de 56 quadros passou (próximo item) e uma execução de 209 quadros por meio do `uret.ps1` passou no portão (execução U209, 3414 s, pico de VRAM 3777 MiB) [medido]; em relação à execução de 209 com o binário de desenvolvimento o latente é idêntico byte a byte; no vídeo os quadros (md5) e o áudio são idênticos, o sha256 do arquivo AVI difere por causa do contêiner [medido] (veja `docs/OLCUMLER.md`, seção 0).
- **Binário da versão publicada, 56 quadros:** o binário da versão publicada (sd-cli `c5cebe78...`, stable-diffusion.dll `e5d3d329...`) deu um resultado de 56 quadros idêntico byte a byte ao R0 (sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`; md5 por quadro e áudio idênticos), executado diretamente com as opções padrão (sem variáveis `SD_*`), código de saída 0, 601 s [medido: execução B56VT2, 2026-11-19; as evidências ficam com os autores, não estão neste repositório]. Escopo: apenas nossa placa sm_61 e 56 quadros; não é um teste de instalação em raiz limpa; o latente de 141 quadros e a cadeia de 209 foram medidos com o binário anterior e NÃO foram repetidos com este [não testado]. Uma primeira tentativa (B56VT, por meio de um script auxiliar) terminou em silêncio após 58 s, causa desconhecida [estimativa: pressão de memória]; a segunda tentativa executou o `sd-cli` diretamente.
- Os scripts de instalação e execução ainda não foram verificados a partir de uma pasta vazia (teste em raiz limpa pendente).
- Roteiro e próximos passos: `ROADMAP.md`.

## Status e limites
- Verificado em uma única máquina (GTX 1050 Ti de 4 GB, 16 GB de RAM, i7-7700HQ). Outras placas de 4 GB e outros tamanhos de RAM podem diferir.
- **209 quadros por padrão (8,7 s):** passou em nossos portões de qualidade (ruído 1,08, execução F209V2K) [medido: 209 quadros com o binário da versão publicada por meio do `uret.ps1`, execução U209; latente idêntico byte a byte ao da execução com o binário de desenvolvimento; quadros e áudio idênticos no vídeo, o sha do arquivo difere por causa do contêiner; as evidências ficam com os autores, não estão neste repositório]. Com 209 quadros o pico de VRAM do DiT foi de 3777 MiB de 4096 MiB (execuções F209b e U209; leitura do `nvidia-smi` da placa inteira), uma margem estreita: outra carga na GPU (a tela, outros aplicativos) pode fazer a execução falhar em `blocks.0`; testado apenas em uma GTX 1050 Ti. O estado da tela durante essa execução não foi registrado; se a sua tela roda nesta placa, há menos VRAM disponível [estimativa: uma carga de tela do Windows de cerca de 100-300 MB]; se preciso, conecte a tela a uma GPU integrada [recomendação, não testada]. A amostragem levou 2730 s (execução U209: passos de 436-483 s) e a decodificação do VAE em processo separado 173 s (a etapa 2 no total 193 s com a decodificação do áudio) [medido: U209, binário da versão publicada; execuções de desenvolvimento anteriores: 2664 s e 174 s]. Na etapa 1 o VAE dentro do processo ficou sem memória e recorreu ao tiling temporal (320 s); essa saída é descartada, o vídeo vem da etapa 2 sem tiling. O pico de RAM não foi medido no U209. Clipes mais longos que 209 quadros não fazem parte desta versão.
- **Imagem para vídeo (`-InitImg`):** com uma imagem inicial o limite é de 192 quadros (8,0 s a 24 fps) nesta GPU: 209 quadros não couberam (faltaram cerca de 17,5 MB de VRAM no bloco 0: necessários 2587 MB, disponíveis 2570 MB); 192 quadros rodaram por meio do `uret.ps1` em 3086 s com pico de VRAM de 3783 MiB e o portão foi aprovado [medido: execuções B209 e B192, 2026-11-20, uma cena; as evidências ficam com os autores, não estão neste repositório]. Não testado em outras GPUs [não testado].
- **A RAM livre importa:** você precisa de cerca de 11 GB de RAM LIVRE (o processo do motor ocupa cerca de 11 GB) [medido]. Com pouca RAM livre o processo pode morrer sem mensagem de erro [estimativa: observamos isso uma vez com cerca de 300 MB de RAM livre enquanto o `sd-cli` ocupava cerca de 10 GB]. Não abra outros programas grandes enquanto roda: em uma máquina de 16 GB sobram livres apenas cerca de 0,3-0,5 GB, e sob pressão de memória a execução pode morrer em silêncio. Antes de começar, feche navegadores, jogos e outros programas grandes e confira a RAM livre.
- **Teste em raiz limpa pendente:** os scripts de instalação e execução ainda não foram verificados a partir de uma pasta vazia usando só estas instruções; esta seção será atualizada quando esse teste (incluindo uma comparação byte a byte de 56 quadros com a referência) for registrado.
- Nenhum vídeo gerado é distribuído aqui.

<!-- i18n-source: README.md sha256:4d4973e30a37 -->
