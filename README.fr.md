# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · Français · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

Les traductions suivent ce README en anglais. Si une traduction diffère ou prend du retard, le texte anglais fait foi, surtout pour le texte de licence et de sécurité ([`SECURITY.md`](SECURITY.md) et [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) ne sont tenus qu’en anglais et en turc).

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **Avant de commencer (licence, territoire) :** ce dépôt est sous licence MIT et ne contient que des correctifs et des scripts. Le modèle MiniMax H3 qu’il télécharge est sous la MiniMax H3 Community License : son territoire exclut l’Union européenne, le Royaume-Uni, la Corée du Sud et les États-Unis, et le modèle, ses dérivés **et ses sorties (les vidéos que vous générez)** ne doivent pas y être utilisés, distribués ni affichés (V.4). L’usage commercial est autorisé dans les limites des termes de la licence. Lisez [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) avant d’installer ; ceci n’est pas un avis juridique.

> **En 30 secondes :** une carte graphique de 4 Go peut produire une vidéo MiniMax H3 de 209 images (8,7 s) en une seule passe : vérifié sur une seule machine (GTX 1050 Ti 4 Go ; l’installation complète avec `kur.ps1` dans un dossier vide n’est pas encore vérifiée de bout en bout) [mesuré : 209 images avec le binaire de la version publiée via `uret.ps1`, exécution U209 ; latent identique octet pour octet à l’exécution avec le binaire de développement ; images et audio identiques dans la vidéo, le sha du fichier diffère à cause du conteneur ; les preuves sont conservées par les auteurs, elles ne sont pas dans ce dépôt] ; avec `-InitImg` (image vers vidéo) au plus 192 images (8,0 s) [mesuré : exécution B192] ; 209 images prennent environ 57 min, la durée maximale par défaut est de 80 min [mesuré : exécution U209] ; les 3 étapes ci-dessous expliquent comment l’exécuter.

> **Vous utilisez un agent de programmation IA (Codex, Claude Code, Gemini, Cursor) ?** Donnez-lui cette seule phrase : « Lis `AGENTS_HIZLI.md` jusqu'au bout, exécute d'abord `scripts\tani.ps1`, note ta progression dans `DURUM.md` et demande-moi avant de supprimer ou déplacer quoi que ce soit, de modifier le Python du système ou le PATH, de baisser un réglage de qualité ou d'accepter la licence du modèle à ma place. » L'agent diagnostiquera ce PC, écrira une liste de contrôle et vous demandera à chaque décision ; la licence du modèle reste votre décision.

VideoTurko : correctifs mémoire pour stable-diffusion.cpp et recettes pour exécuter MiniMax H3 en texte vers vidéo sur une GTX 1050 Ti de 4 Go, jusqu’à 209 images (8,7 s) en une seule passe ; image vers vidéo (`-InitImg`) jusqu’à 192 images (8,0 s) (209 images vérifiées par une chaîne d’octets ; identique octet pour octet à l’exécution sans correctifs sur les vérifications à 56 et 141 images).

## Démarrage rapide (Windows, 3 étapes)
**État : les scripts d’installation et d’exécution ci-dessous sont en cours de finalisation et le test en racine propre est en attente ; rien ici n’est présenté comme fonctionnel tant que ce test n’est pas réussi (voir « État et limites »).**

1. **Téléchargez** ce dépôt (bouton vert **Code**, puis **Download ZIP**) et extrayez-le dans un dossier COURT, par exemple `C:\vt`.
2. **Installer : double-cliquez sur `kur.cmd`** (une fenêtre noire s’ouvre et montre chaque étape ; la fermer arrête l’installation, la relancer reprend là où elle s’est arrêtée : un fichier de modèle à moitié téléchargé est repris [lu : le script de téléchargement garde un fichier `.part` et reprend depuis celui-ci ; une reprise complète de 29 GiB n’a pas été mesurée]). Si Windows avertit au sujet du fichier téléchargé, utilisez plutôt la commande PowerShell ci-dessous [conseil, non testé sur un ZIP téléchargé]. Vous préférez la ligne de commande ? Ouvrez PowerShell dans ce dossier (tapez `powershell` dans la barre d’adresse de l’Explorateur) et lancez la même installation :
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   La racine d’installation est le dossier que vous avez extrait (le moteur va dans `engine\bin`, les modèles dans `model`) ; pour utiliser un autre emplacement, définissez d’abord la variable d’environnement `VT_ROOT`. Le script vérifie le GPU, le pilote, la RAM et le disque, récupère le moteur et les modèles (les zips du moteur et les fichiers de modèle fraîchement téléchargés sont vérifiés par sha256 ; un fichier de modèle déjà présent avec la bonne taille n’est vérifié que par sa taille, `scripts\modelleri_indir.ps1 -Dogrula` lance la vérification sha256 complète), exécute un court contrôle réel et affiche READY uniquement si ce contrôle a réussi [conception : `kur.ps1` n’a pas été exécuté en entier dans un dossier propre ; cette phrase sera mise à jour après le test en dossier propre]. `-ExecutionPolicy Bypass` ne s’applique qu’à ce processus ; lisez d’abord `scripts\kur.ps1`, comme pour tout installateur.
   Le zip du moteur provient de la version v0.1.0 publiée sur GitHub (publication : 2026-11-19 ; son sha256 est figé dans `kur.ps1`). Hors ligne ou avec votre propre compilation, indiquez des zips locaux : `-MotorZip <path> -CudaZip <path>`. Un zip local est vérifié avec le même sha256 figé (un fichier `.sha256` placé à côté est ignoré) ; il doit donc s’agir du zip de la version publiée ; pour votre propre compilation, définissez d’abord `VT_MOTOR_SHA256` / `VT_CUDA_SHA256` avec son sha256. Un sha256 erroné s’arrête avec exit 1. Seuls les `.exe`/`.dll` vont dans `engine\bin` ; les licences et le README vont dans `engine\lisanslar\<zip name>\`. [essayé avec les zips de dist avant la publication : le `.sha256` d’accompagnement plus l’avertissement autoréférentiel, binaire et DLL en place, `sd-cli --help` s’est exécuté ; les sha des binaires installés correspondaient (`c5cebe78...`, `e5d3d329...`) ; l’étape des modèles et le contrôle de 5 images de `kur.ps1` n’ont PAS encore été exécutés sur un vrai GPU]
   **Licence du modèle :** avant l’étape des modèles, l’installateur affiche le résumé de la licence (`docs/LISANS_KABUL.txt`, texte complet `docs/LISANS_UYARISI.md` : MiniMax H3 Community License, limites territoriales qui couvrent aussi les vidéos générées, règles commerciales et d’étiquetage IA) et vous demande d’accepter (`E` = oui). Lisez-la d’abord. Pour les exécutions sans surveillance, vous pouvez passer `-LisansKabul E`, ce qui signifie que vous l’avez lue et acceptée vous-même ; ne l’ajoutez pas pour quelqu’un d’autre. (Agents IA : suivez `AGENTS.md` ; ne tapez jamais E sans le consentement de l’utilisateur.) Sans acceptation, `kur.ps1` s’arrête avec le code de sortie 2 et ne télécharge aucun modèle.
3. **Votre première vidéo (56 images, environ 11 min sur notre GTX 1050 Ti** [mesuré : 641 s, exécution R0, `docs/OLCUMLER.md` ; autres cartes non mesurées]**)** : quand l’installateur affiche `HAZIR / READY`, lancez
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (raccourci : glissez un fichier texte de prompt sur `uret.cmd`, ou lancez `uret.cmd docs\ornek_istem_R0.txt` : la même exécution de 56 images). La vidéo se trouve dans `runs\`. Écrivez ensuite votre propre prompt dans un fichier texte (un paragraphe en anglais, phrase `audio:` facultative) et lancez le clip le plus long que nous couvrons (par défaut, environ 57 min [mesuré : exécution U209]) :
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   `-Kare` suit la grille 17k+5 (39, 56, 73, ... 192, 209) ; 209 par défaut (8,7 s), la plus longue durée que nous couvrons. Le VAE s’exécute dans un processus séparé, jamais par tuiles [une exécution réelle du moteur via `uret.ps1` avec le binaire de la version publiée, VAE en processus séparé, a réussi lors de l’exécution U209].

   Guide d’écriture du prompt : [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (modèle du plan-séquence unique, tranches de temps égales, deux exemples complets).

| Prérequis | Valeur |
|---|---|
| OS | Windows 10/11, 64 bits |
| GPU | NVIDIA, 4 Go ou plus ; testé uniquement sur GTX 1050 Ti (sm_61) ; marge mince (3777/4096 MiB à 209 images) : un écran ou un navigateur très sollicité peut faire échouer l’exécution ; aucune autre carte de 4 Go n’a été essayée |
| RAM | 16 Go (pic d’environ 11 Go ; fermez les autres programmes) |
| Disque | au moins 32 GiB libres (40 GiB ou plus recommandés : entre 32 et 40 l’installateur affiche un avertissement, `[VT-W-DISK-PAY]` [mesuré : exécutions `-Kuru` avec disque simulé]), modèles sur un SSD (NVMe de préférence) |
| Téléchargement | zip du moteur 36,8 Mo + zip du runtime CUDA 567,5 Mo [mesuré] + modèles 31 473 112 040 octets (environ 29,3 GiB) [lu : tailles dans `scripts/modeller.json`] ; environ 30 GiB au total |
| Modèles | non inclus ; récupérés par l’installateur sous la licence MiniMax (voir l’avertissement ci-dessous). Les modèles (29,3 GiB, 31 473 112 040 octets dans `scripts/modeller.json`) ne sont ni dans ce dépôt ni dans la version publiée : les limites de taille de fichiers/versions de GitHub s’appliquent, et `kur.ps1` les télécharge depuis la source officielle avec vérification sha256. |

Codes de sortie de `kur.ps1` : 0 READY, 1 erreur, 2 action de l’utilisateur requise (licence, ou pas encore de version/zip), 3 matériel ou disque insuffisant, 4 arrêté (fichier DUR). `uret.ps1` n’accepte une exécution que si le `.avi` existe, si le nombre d’images est correct et si les journaux sont propres [mesuré : une exécution réelle via `uret.ps1` sur le binaire de la version publiée, exécution U209, 209 images, porte franchie]. Codes de sortie de `uret.ps1` : 0 DONE (porte de qualité franchie), 1 erreur ou sortie invalide (y compris une vidéo sans piste audio), 2 arrêté (fichier DUR), 5 `KAPI RED` (porte de qualité échouée : le clip n’est pas accepté, la décision vous revient), 6 la porte n’a pas pu s’exécuter (clip non accepté). Détails dans AGENTS.md. [mesuré : codes de sortie 0, 1 (vidéo muette), 5 et 6 dans des scénarios avec un faux moteur et une fausse porte ; moteur réel : exit 0 lors de l’exécution U209]

### Dépannage (détails : `docs/SIK_HATALAR.md`)
Les lignes d’erreur de nos scripts portent un code stable, par exemple `HATA: [VT-E-DLL] ...` ou `UYARI: [VT-W-DISK-PAY] ...`. Cherchez le code dans [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) (exemple d’ancre `#vt-e-dll`) ou dans `docs/hata_imzalari.json`, et indiquez le code dans votre issue. La première colonne du tableau ci-dessous reste telle qu’imprimée (ne traduisez ni les codes ni le texte des journaux).

| Ce que vous voyez | Ce que cela signifie, ce qu’il faut faire |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | Ne lancez pas `sd-cli.exe` à la main ; exécutez `scripts\kur.ps1`, qui place les DLL CUDA au bon endroit. |
| `failed during weight preparation` à `blocks.0` (#1, #3, #5) | VRAM insuffisante à la porte mémoire : utilisez moins d’images sur la grille 17k+5, fermez les autres programmes qui utilisent le GPU et gardez les options fournies. |
| `retrying with temporal tiling` (#6) | Le VAE est passé en mode tuiles ; la sortie est invalide pour la qualité. Relancez. |
| L’exécution s’arrête à la durée maximale, sans vidéo (#7) | Augmentez `-TavanDk` pour les longs clips (durée maximale par défaut : 80 min pour 209 images, fixée par `uret.ps1` ; notre exécution à 209 images a pris 57 min [mesuré : exécution U209]). |
| Code de sortie vide mais « terminé » (#14) | L’enveloppe a lu le code de sortie trop tôt ; relancez et vérifiez que le fichier vidéo existe. |
| Le système ralentit, swap (#18) | Le moteur utilise environ 10-11 Go de RAM ; fermez les navigateurs et les autres programmes. |
| sha256 différent / échec du téléchargement | En général un téléchargement interrompu : relancez la même commande, les fichiers déjà vérifiés sont ignorés. |

**Bloqué ou curieux ?** [`SUPPORT.md`](SUPPORT.md) (où poser vos questions ; les délais de réponse sont des objectifs, pas des engagements) · [`PRIVACY.md`](PRIVACY.md) (pas de télémétrie ; le réseau ne sert qu’à télécharger le moteur et les modèles, depuis les hôtes listés) · [`SECURITY.md`](SECURITY.md) (signalement privé) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (première pull request en 5 étapes ; pas de GPU nécessaire pour les documents et les scripts).

### Nouveautés de la v0.1.1 : plus d’options (détails : `AGENTS.md`, `docs/SIK_HATALAR.md` 19-23)
Sans ces options, rien ne change sur une carte de 4 Go (la vérification octet par octet sur 56 images par rapport à notre référence a de nouveau réussi avec la v0.1.1 [mesuré]). Ajoutez `-Kuru` à n’importe quelle commande pour voir ce qui serait exécuté.
- `-EndImg` : fournissez aussi la dernière image (première et dernière image, « FLF ») ; plafond de 175 images sur les cartes de moins de 8 Go (192 ne tenait pas sur 4 Go), 192 sur les cartes de 8 Go et plus. Sur notre GTX 1050 Ti, ce mode s’exécute toujours en deux processus : 56 images en 1040 s, 175 images en 2887 s (48 min), les deux ont franchi la porte [mesuré]. Conseils pour le prompt : `docs/ISTEM_YAZIMI.md`.
- `-W` / `-H` : d’autres tailles, par exemple 384x640 en vertical ; multiples de 32, surface d’au moins 640x384 (jamais moins). Non testé sur 4 Go ; sur les cartes de moins de 8 Go, les tailles qui dépassent notre plus grande exécution mesurée sont refusées. Les seuils de la porte de qualité sont calibrés en 640x384.
- `-TekAsama` : un seul processus au lieu de deux, réservé aux grandes cartes ; jamais activé automatiquement.
- GPU plus récents (compute capability 7.0+, par ex. RTX 20/30/40) : `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` est défini automatiquement, sauf si vous le définissez vous-même ; cela a corrigé une vidéo entièrement noire à partir de 141 images sur la RTX 4070 Ti de l’auteur du signalement [signalé par l’utilisateur, issue #1]. Sans Python + OpenCV, `uret.ps1` s’arrête désormais avec exit 6 avant la tâche GPU (aucune vidéo produite, pas de RED trompeur).
- Merci à @SinanC73 pour le rapport sur la RTX 4070 Ti qui a conduit à ces changements ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1)).

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

## Profils de vitesse facultatifs (pack de vitesse ; désactivés par défaut)
Rien de ce qui suit ne modifie l’exécution par défaut (640x384, 209 images, 3414 s sur notre carte). Ce sont trois cellules mesurées au-delà, chacune étant un profil nommé de `uret.ps1` ; elles demandent le moteur du pack de vitesse (le moteur de la release plus les correctifs 0021, 0023, 0024, tous désactivés par défaut : `docs/YAMALAR.md`). Installez-le avec `scripts\kur.ps1 -HizPaketi` (un zip local fonctionne avec `-MotorZip`), puis ajoutez `-Profil <name>` ; `-Kuru` affiche ce qui serait exécuté. Le pack de vitesse est publié avec la version v0.1.4.

| Profil | Taille, durée | Temps total sur une GTX 1050 Ti 4 GB | Statut |
|---|---|---|---|
| (aucun, par défaut) | 640x384, jusqu’à 209 images (8,7 s) | 209 images : 3414 s | vérifié, inchangé |
| `yuksek832` | 832x480, 141 images (5,9 s) | environ 55-56 min | utilisable, deux prompts [mesuré] |
| `yuksek832 -Kare 124` | 832x480, 124 images (5,2 s) | environ 45-46 min, aucun indicateur de vitesse nécessaire | utilisable, deux prompts [mesuré] |
| `yuksek896` | 896x512, 124 images (5,2 s) | environ 56-57,5 min | utilisable, deux prompts [mesuré] |
| `uzun260` | 640x384, 260 images (10,8 s) | environ 71 min [mesuré : 70,7 min de bout en bout via `uret.ps1`, avec la sortie anticipée ; 78 min sans elle] | fonctionne près de la limite mémoire ; prompt mesuré jusqu'à environ 2000 caractères |

- **Marge étroite :** à 832x480 x 141, la porte mémoire ne laisse qu’une marge à un chiffre en Mo (5,7 et 6,8 Mo dans les deux exécutions complètes). Deux longs prompts (1520 et 2041 caractères) n’ont été vérifiés qu’en lisant la porte pour l’étape 1 et une partie de l’étape 2, sans exécution complète : marge de 10,9 et 4,0 Mo. Tout autre processus qui occupe la mémoire de la carte (navigateur, second écran) peut la faire échouer ; utilisez alors `-Kare 124` ou la taille par défaut [mesuré, GTX 1050 Ti 4 GB].
- **`uzun260` fonctionne près de la limite mémoire :** pic de VRAM 3861-3903 sur 4096 MiB. Trois exécutions complètes (deux scènes) ; l’usage de mémoire partagée a augmenté de 28 à 61 MiB pour une limite de 68 MiB. Les prompts ont été mesurés jusqu’à 1403 caractères en exécution complète et jusqu’à 2009 caractères par lecture de la porte ; à 2527 caractères, la limite de mémoire partagée a été dépassée. Il n’existe pas de référence sans indicateur pour l’égalité octet par octet à cette longueur. Fermez les autres programmes qui utilisent le GPU ; si une exécution échoue, utilisez les 209 images par défaut. Le correctif 0023 n’est accepté que pour cette seule cellule.
- **Non proposé :** 832x480 à 158 images ne tient pas avec les correctifs fournis (à la porte de l’étape 2, il manque environ 280 MB) ; 175 images n’a été examiné que par lecture de la porte (il manquait environ 275 MB au premier bloc, pas d’exécution complète). Le profil ne propose que 141 images. Les autres tailles et nombres d’images sont refusés par `-Profil` (utilisez la voie par défaut).
- La qualité par défaut est intacte : 6 étapes, cfg 1, VAE sans tuiles, 17k+5 images. Là où les indicateurs sont activés, la sortie a été comparée octet par octet à la vidéo sans indicateurs aux tailles où l’exécution sans indicateurs tient (`docs/YAMALAR.md`) ; à 832x480 x 141 et 896x512 x 124, l’exécution sans indicateurs ne tient pas, l’égalité y repose donc sur les cellules les plus proches, non sur une comparaison directe [mesuré, lu].
- L’étape 1 d’une exécution en deux étapes se termine désormais dès que le fichier latent est complet (`VT_ERKEN_CIKIS=0` le désactive).

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

## De quoi s’agit-il
Un ensemble de petits correctifs de mémoire et d’ordonnancement pour stable-diffusion.cpp, ainsi que la recette d’exécution, les contrôles et les mesures qui permettent de faire tourner MiniMax H3 (DiT de 33B ; nous exécutons le GGUF HyperFlow Flash 13.7B Q4_K_M ; l’encodeur de texte Qwen3-VL de 32B est séparé) sur un GPU Pascal de 4 Go (GTX 1050 Ti, 16 Go de RAM système).
- Durées en une seule passe que nous avons réellement produites et qui ont franchi nos portes de qualité : 56, 141, 158, 175, 192, 209 images en 640x384, 24 fps (209 images = 8,7 s), avec l’audio généré par H3 lui-même [mesuré : 209 images avec le binaire de la version publiée via `uret.ps1`, exécution U209 ; latent identique octet pour octet à l’exécution avec le binaire de développement ; images et audio identiques dans la vidéo, le sha du fichier diffère à cause du conteneur ; les preuves sont conservées par les auteurs, elles ne sont pas dans ce dépôt]. 209 est la durée la plus longue que nous avons regardée et trouvée fluide [signalé par l’utilisateur, 2026-11-19, vidéo regardée en entier ; fichier : sortie F209V2, 8,708 s].
- **Affirmation d’identité octet pour octet, avec sa portée réelle :** les sorties n’ont été vérifiées identiques octet pour octet à la référence sans correctifs que pour 56 et 141 images. Pour 158/175/192/209 images, nous avons utilisé les mêmes options et la même chaîne de binaires ; il n’y a pas de référence directe octet pour octet (la version sans correctifs ne peut pas exécuter ces durées sur ce GPU).
- Les réglages de qualité ne sont jamais abaissés : même modèle/quantification, 6 étapes, cfg 1, 640x384, même graine, VAE sans tuiles.
- Nous ne prétendons pas être les premiers : nous avons cherché et n’avons trouvé aucun exemple extérieur de ceci sur 4 Go, ce qui ne prouve pas qu’il n’en existe pas.

## Organisation
- `patches/` correctifs appliqués sur un commit figé de stable-diffusion.cpp (voir les notes qui s’y trouvent)
- `scripts/` compilation, exécution, VAE en processus séparé, outils de porte/cohérence (`doku_norm.py` : voir la note d’échelle plus bas)
- `docs/KURULUM.md` matériel, étapes de compilation et d’exécution (EN+TR)
- `docs/YAMALAR.md` liste des correctifs, `docs/KANITLAR.md` preuves, `docs/KAPILAR.md` tableau des portes de qualité, `docs/OLCUMLER.md` mesures, `docs/SIK_HATALAR.md` erreurs courantes, `docs/LISANS_UYARISI.md` tous les points de la licence
- `scripts/` index court : `hiz_kos3.ps1` enveloppe d’exécution (`-Kuru` affiche la commande exacte), `uretim_kapi.ps1` porte de qualité, `dikis_denetim.py` contrôle des raccords, `doku_norm.py` bruit normalisé par la texture, `bayt_kiyas.py` comparaison octet par octet, `derleme_sablonu.ps1` modèle de compilation (n’arrête que l’assistant de télémétrie de Visual Studio `vctip.exe` démarré après sa propre compilation, qui sinon garde le processus de compilation attaché pendant des minutes ; les autres processus `vctip.exe` sont laissés tranquilles)

## Portes de qualité (comment un résultat est accepté)

Cette porte ne vérifie pas la cohérence du mouvement (sauts d’échelle ou de position des objets) : regardez la vidéo en entier avant de l’accepter.
1. Nombre d’images et audio présents ; aucun repli mémoire ni ligne ALLOC_FAILED dans le journal.
2. Porte de bruit brut : résidu du filtre médian <= 1,5 (échelle 0-255).
3. Bruit normalisé par la texture, `scripts/doku_norm.py` (la version de ce dépôt) : N = résidu médian / texture de Sobel, toutes les 6 images. **Note d’échelle :** dans cette version, les 10 clips mesurés donnent N = 0,034-0,052 (tableau dans `docs/KAPILAR.md` ; le dernier quart de F192/F209V2 atteint 0,062) et le seuil de la porte supplémentaire est N <= 0,065. Une autre implémentation a mesuré 0,028-0,036 sur les mêmes clips, donc les seuils ne sont PAS interchangeables d’une version à l’autre. Sur des textures très fines (rangées d’herbe), le N propre était de 0,075 ; le seuil dépend donc de la famille de scènes. Un estimateur robuste de haute fréquence (sigma-HH <= 1,5 ; propre 0,74-1,19, avec un bruit ajouté s=2 il donne 2,2-3,0) est la porte supplémentaire recommandée.

Portée : VideoTurko traite UNE seule passe (jusqu’à 209 images, environ 8,7 s). Notre propre test d’enchaînement a montré des raccords visibles (la scène ne continue pas proprement) ; les films plus longs ne font donc pas partie de ce que nous vérifions. Pour enchaîner, il existe le guide communautaire `docs/KLIP_ZINCIRI.md` et notre utilitaire CPU seul `scripts/zincir.py` (`plan`, `son-kare`, `bagla` ; il ne lance jamais le moteur) ; nous n’avons pas mesuré la qualité des films enchaînés [non essayé], vérifiez donc chaque raccord à l’œil et avec `scripts/dikis_denetim.py`.
Vos réglages vous appartiennent : 209 images est notre valeur par défaut testée sur une carte de 4 Go, pas une limite que vous devez utiliser. Choisissez n’importe quel nombre d’images de la grille 17k+5 (39, 56, 73, ... 192, 209 ; voir `docs/KURULUM.md`), changez le prompt, la graine, la résolution ou toute option à votre guise. Les clips plus courts demandent moins de mémoire et de temps ; des GPU plus gros peuvent en accepter davantage.

## Avertissement sur la licence du modèle
**VideoTurko ne contient que des correctifs et des scripts (MIT) ; quiconque utilise le modèle et ses sorties est responsable de la licence MiniMax.** Ceci n’est pas un avis juridique. Ci-dessous figurent les clauses de la MiniMax H3 Community License (2 août 2026) résumées avec leurs numéros ; la licence elle-même fait foi : https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

La licence MIT de ce dépôt ne couvre pas les poids du modèle ; voir [`NOTICE`](NOTICE). Ce dépôt ne contient AUCUN poids de modèle (ni MiniMax H3, ni fichier GGUF HyperFlow-H3-Flash, ni VAE). Ce projet n’est ni affilié à MiniMax ni approuvé par elle. L’usage commercial n’est PAS interdit (ce n’est pas une licence non commerciale) ; les conditions figurent ci-dessous.

**Territoire (Applicable Territory)**
- **Préambule, I.3, I.5 :** Dans le monde entier, À L’EXCLUSION de l’Union européenne, du Royaume-Uni, de la République de Corée et des États-Unis. Utiliser le modèle vaut acceptation de la licence.
- **II :** Licence limitée, non transférable et libre de redevances pour utiliser, reproduire, distribuer, créer des œuvres dérivées et modifier, uniquement à l’intérieur du territoire et dans le respect du contrat et de l’Exhibit A. Les personnes situées dans des territoires exclus peuvent demander une licence distincte à MiniMax.
- **V.4 :** Utiliser, reproduire, modifier, distribuer ou afficher le modèle, ses dérivés ET SES SORTIES (vidéo/audio générés) en dehors du territoire n’est pas autorisé. **Publier ou montrer des vidéos générées dans l’UE, au Royaume-Uni, en Corée du Sud ou aux États-Unis est donc hors licence.**
- **Exhibit A-1 :** Une utilisation en dehors du territoire enfreint l’Acceptable Use Policy.

**Distribution (III)** (ce dépôt ne distribue pas le modèle ; si vous le distribuez)
- **III.1 :** Remettez à chaque destinataire une copie de la licence. **III.2 :** Signalez les fichiers modifiés par des avis bien visibles.
- **III.3 :** Encouragé (non obligatoire) : une mention « Powered by MiniMax H3 », un identifiant de génération par IA sur les fichiers produits, un article public.
- **III.4 :** Les distributions DOIVENT être accompagnées d’un fichier NOTICE contenant : "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12 :** il est interdit de publier du contenu dans un environnement public sans indiquer clairement qu’il est généré par une machine : étiquetez les vidéos générées par IA lorsque vous les publiez (liste complète : `docs/LISANS_UYARISI.md`).
- **III (dernier paragraphe) :** Vous pouvez ajouter votre propre copyright à vos modifications mais vous ne pouvez pas imposer de conditions supplémentaires ou différentes à l’usage/à la distribution ; les règles territoriales continuent de s’appliquer.

**Conditions commerciales (IV)**
- **IV.1 :** Si vos produits/services commerciaux génèrent plus de 20 millions de USD (ou l’équivalent) de revenus annuels, obtenez une autorisation écrite PRÉALABLE auprès de api@minimax.io (objet « MiniMax H3 licensing - authorization request »).
- **IV.2 :** L’interface d’un produit/service commercial utilisant le modèle doit afficher de manière visible « MiniMax H3 ».

**Restrictions d’usage (V)**
- **V.1 :** Respectez la loi applicable (y compris la conformité commerciale) et l’Exhibit A. **V.2 :** Engagez toute personne à qui vous donnez accès par des conditions au moins aussi protectrices que ces restrictions et informez-la.
- **V.3 :** Vous ne pouvez pas utiliser le modèle ni ses SORTIES pour améliorer un autre modèle d’IA (autre que MiniMax H3 et ses dérivés). (I.11 : la distillation et l’entraînement sur des sorties synthétiques font d’un modèle un « dérivé » ; les sorties elles-mêmes ne sont pas des dérivés.)
- **V.5 :** Si vous proposez à des tiers un produit/service/service hébergé qui génère des sorties avec le modèle : avant et pendant toute l’exploitation, des garde-fous techniques et organisationnels raisonnables, un mécanisme de signalement, une enquête rapide, et le retrait/la désactivation/la suspension des contrevenants récidivistes.

**Marque et droits (VI)**
- **VI.1 :** Vous détenez les œuvres dérivées et les dérivés du modèle que vous créez (sous réserve des droits de MiniMax). **VI.2 :** Les noms/marques de MiniMax ne sont pas concédés (au-delà de ce qui est nécessaire pour décrire et distribuer) ; la marque « MiniMax H3 » ne peut être utilisée que pour se conformer à III.3, à l’intérieur du territoire ; ne suggérez aucune affiliation.
- **VI.3 :** Si vous poursuivez MiniMax ou quiconque en alléguant que les matériaux/sorties portent atteinte à vos droits, toutes vos licences prennent fin ce jour-là ; vous défendez et indemnisez MiniMax contre les réclamations de tiers découlant de votre usage/distribution ou de celui d’autrui.
- **VI.4 :** MiniMax ne revendique aucun droit sur les sorties ; vous et vos utilisateurs êtes responsables des sorties et de leur usage.

**Exclusions de garantie et résiliation (VII, VIII, IX)**
- **VII.1 :** Aucune obligation d’assistance/de mise à jour. **VII.2 :** Le modèle et les sorties sont fournis « AS IS », sans garantie ; vous décidez de leur adéquation et assumez le risque. **VII.3 :** MiniMax et ses sociétés affiliées ne sont responsables d’aucun dommage (dans la mesure permise par la loi).
- **VIII.1 :** Effet à l’acceptation/à l’accès. **VIII.2 :** En cas de manquement, MiniMax peut résilier ; vous devez cesser d’utiliser/de distribuer, supprimer les copies et prévenir les destinataires (VI.1, VI.3, VII, IX survivent).
- **IX :** Droit de la RAS de Hong Kong ; compétence exclusive des tribunaux de Hong Kong (la CVIM de l’ONU est exclue).
- **Remarque complémentaire :** l’encodeur de MiniMax H3 utilise Qwen3-VL-32B (Apache 2.0).

**Politique d’utilisation acceptable (Exhibit A)** (n’utilisez PAS le modèle, ses dérivés ni ses sorties pour)
- A-1 usage en dehors du territoire ; A-2 violation de lois ou de la propriété intellectuelle de tiers ; A-3 nuire à soi-même ou à autrui ; A-4 détourner/distribuer des sorties pour nuire ; A-5 contourner les garde-fous ; A-6 exploiter/nuire à des mineurs ; A-7 informations vérifiablement fausses pour nuire à autrui ou influencer des élections ; A-8 faux engagement en ligne (faux avis, etc.) ; A-9 diffamation, dénigrement, harcèlement ; A-10 logiciels malveillants ; A-11 données personnelles pour nuire à autrui ; **A-12 publier du contenu dans tout environnement public (y compris les publications de bots) sans indiquer de façon claire et visible qu’il est généré par une machine** ; A-13 usurpation d’identité sans consentement ; A-14 décisions automatisées à haut risque dans des domaines critiques (forces de l’ordre, immigration, santé, infrastructures critiques, crédit, emploi, logement, éducation, notation sociale, assurance, etc.) ; A-15 violation des normes sociales, éthiques et morales d’autres pays/régions ; A-16 extrémisme violent/terrorisme ; A-17 discrimination/préjudice fondés sur des caractéristiques protégées ; A-18 exploitation de populations vulnérables ; **A-19 fins militaires** ; A-20 activité professionnelle non autorisée/sans licence (financière, juridique, médicale, etc.).
- Remarque : ceci est un résumé en langage clair ; en cas de doute, le texte anglais de la licence prévaut.

## Étiquettes de preuve

Un seul jeu pour tous les documents (entre crochets, les anciennes graphies) :
- **[mesuré]** (TR : ölçtüm, olctum) : exécuté dans ce projet, le chemin de la preuve existe.
- **[lu]** (TR : okudum yol, okudum) : la source ou le script a été lu, non exécuté.
- **[conception]** (TR : tasarım, tasarim) : conçu, pas encore vu dans une exécution réelle.
- **[estimation]** (TR : tahmin) : non vérifié.
- **[non essayé]** (TR : denenmedi) : jamais exécuté.
- **[signalé par l’utilisateur]** (TR : kullanıcı bildirdi) : affirmé par l’utilisateur, avec la date ; non mesuré de façon indépendante.
- **[calculé]** (TR : hesap ; anciennes graphies : calculated, hesap) : un nombre dérivé d’entrées mesurées, non mesuré lui-même ; le calcul est écrit à côté. [proposal] / [öneri] dans les anciens textes = [estimation].

Noms d’exécution utilisés entre crochets (nos propres noms d’exécution, pas des fichiers de ce dépôt) : U209 = 209 images avec le binaire de la version publiée via `uret.ps1` ; B209 et B192 = exécutions image vers vidéo (`-InitImg`) à 209 et 192 images ; B56VT2 = binaire de la version publiée, 56 images, comparé à la référence octet pour octet de 56 images R0 ; F209b, F209V2, F209V2K = exécutions à 209 images sur la compilation de développement (détails : `docs/OLCUMLER.md`).

## Limitations connues
- **Preuve octet pour octet** (comment la reproduire vous-même : `docs/KANITLAR.md`, « R0 ve latent referansi nasil uretilir » ; vérifiée sur notre carte sm_61, d’autres GPU peuvent ne pas être identiques octet pour octet [estimation]) : avec notre série de correctifs (options mémoire activées), une exécution de 56 images a donné le sha256 `0979f156d548169b...`, identique à la référence [mesuré] ; à 141 images, le sha256 du latent `E5D028F8632BE4FE...` était identique (avec les options 0013/0014). Les images 158 à 209 n’ont pas de référence directe octet pour octet ; la chaîne de portes est la preuve. Franchir les portes numériques ne garantit pas un bon clip : la cohérence du mouvement dans le temps se vérifie à l’œil (voir `docs/KAPILAR.md`).
- **209 images, quel jeu d’options :** la preuve de la chaîne d’octets à 209 images a été obtenue avec le jeu d’options F209V2 sur la compilation de développement (sans options de queue de bloc, compilée sans les correctifs 0019/0020) ; `uret.ps1` utilise cette recette pour 209 images [lu : le script ; une exécution réelle du moteur via `uret.ps1` a réussi lors de l’exécution U209].
- Vérifié par nous sur une carte (GTX 1050 Ti 4 GB) ; les rapports externes pour d’autres cartes sont listés avec leurs étiquettes dans `docs/KART_PROFILLERI.md` [signalé par l’utilisateur].
- **Quel binaire a été mesuré :** le latent à 141 images et la chaîne d’octets ont été mesurés avec nos compilations de développement. Le binaire de la version publiée que vous téléchargez est une compilation neuve : sa porte octet pour octet à 56 images a réussi (point suivant) et une exécution à 209 images via `uret.ps1` a franchi la porte (exécution U209, 3414 s, pic de VRAM 3777 MiB) [mesuré] ; par rapport à l’exécution à 209 du binaire de développement, le latent est identique octet pour octet ; dans la vidéo, les images (md5) et l’audio sont identiques, le sha256 du fichier AVI diffère à cause du conteneur [mesuré] (voir `docs/OLCUMLER.md`, section 0).
- **Binaire de la version publiée, 56 images :** le binaire de la version publiée (sd-cli `c5cebe78...`, stable-diffusion.dll `e5d3d329...`) a donné un résultat à 56 images identique octet pour octet à R0 (sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d` ; md5 par image et audio identiques), lancé directement avec les options par défaut (sans variables `SD_*`), code de sortie 0, 601 s [mesuré : exécution B56VT2, 2026-11-19 ; les preuves sont conservées par les auteurs, elles ne sont pas dans ce dépôt]. Portée : uniquement notre carte sm_61 et 56 images ; ce n’est pas un test d’installation en racine propre ; le latent à 141 images et la chaîne à 209 ont été mesurés avec l’ancien binaire et n’ont PAS été répétés avec celui-ci [non essayé]. Une première tentative (B56VT, via un script auxiliaire) s’est arrêtée en silence après 58 s, cause inconnue [estimation : pression mémoire] ; la deuxième tentative a lancé `sd-cli` directement.
- Les scripts d’installation et d’exécution n’ont pas encore été vérifiés depuis un dossier vide (test en racine propre en attente).
- Feuille de route et prochaines étapes : `ROADMAP.md`.

## État et limites
- Vérifié sur une seule machine (GTX 1050 Ti 4 Go, 16 Go de RAM, i7-7700HQ). D’autres cartes de 4 Go et d’autres quantités de RAM peuvent donner des résultats différents.
- **209 images par défaut (8,7 s) :** a franchi nos portes de qualité (bruit 1,08, exécution F209V2K) [mesuré : 209 images avec le binaire de la version publiée via `uret.ps1`, exécution U209 ; latent identique octet pour octet à l’exécution avec le binaire de développement ; images et audio identiques dans la vidéo, le sha du fichier diffère à cause du conteneur ; les preuves sont conservées par les auteurs, elles ne sont pas dans ce dépôt]. À 209 images, le pic de VRAM du DiT était de 3777 MiB sur 4096 MiB (exécutions F209b et U209 ; relevé `nvidia-smi` de la carte entière), une marge mince : une autre charge sur le GPU (l’affichage, d’autres applications) peut faire échouer l’exécution à `blocks.0` ; testé uniquement sur une GTX 1050 Ti. L’état de l’affichage pendant cette exécution n’a pas été noté ; si votre affichage passe par cette carte, moins de VRAM est disponible [estimation : une charge d’affichage Windows d’environ 100-300 Mo] ; si besoin, branchez l’écran sur un GPU intégré [conseil, non testé]. L’échantillonnage a pris 2730 s (exécution U209 : étapes de 436-483 s) et le décodage du VAE en processus séparé 173 s (étape 2 au total 193 s avec le décodage audio) [mesuré : U209 binaire de la version publiée ; anciennes exécutions de développement : 2664 s et 174 s]. À l’étape 1, le VAE dans le processus a manqué de mémoire et est passé en tuiles temporelles (320 s) ; cette sortie est écartée, la vidéo provient de l’étape 2 sans tuiles. Le pic de RAM n’a pas été mesuré lors de U209. Les clips plus longs que 209 images ne font pas partie de cette version.
- **Image vers vidéo (`-InitImg`) :** avec une image initiale, la limite est de 192 images (8,0 s à 24 fps) sur ce GPU : 209 images n’ont pas tenu (il manquait environ 17,5 Mo de VRAM au bloc 0 : 2587 Mo nécessaires, 2570 Mo disponibles) ; 192 images ont tourné via `uret.ps1` en 3086 s avec un pic de VRAM de 3783 MiB et la porte a été franchie [mesuré : exécutions B209 et B192, 2026-11-20, une scène ; les preuves sont conservées par les auteurs, elles ne sont pas dans ce dépôt]. Non essayé sur d’autres GPU [non essayé].
- **La RAM libre compte :** il faut environ 11 Go de RAM LIBRE (le processus du moteur en occupe environ 11 Go) [mesuré]. Avec trop peu de RAM libre, le processus peut mourir sans message d’erreur [estimation : nous l’avons observé une fois avec environ 300 Mo de RAM libre alors que `sd-cli` en occupait environ 10 Go]. N’ouvrez pas d’autres gros programmes pendant l’exécution : sur une machine de 16 Go, il ne reste que 0,3-0,5 Go de libre environ, et sous pression mémoire l’exécution peut s’arrêter en silence. Avant de commencer, fermez les navigateurs, les jeux et les autres gros programmes et vérifiez la RAM libre.
- **Test en racine propre en attente :** les scripts d’installation et d’exécution n’ont pas encore été vérifiés depuis un dossier vide en n’utilisant que ces instructions ; cette section sera mise à jour lorsque ce test (y compris une comparaison octet par octet à 56 images avec la référence) sera enregistré.
- Aucune vidéo générée n’est fournie ici.

<!-- i18n-source: README.md sha256:cdeddf10eb78 -->
