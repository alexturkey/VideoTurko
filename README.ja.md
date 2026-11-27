# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · 日本語 · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

翻訳はこの英語版 README に従います。翻訳が異なる場合や遅れている場合は、特にライセンスとセキュリティの文章では英語の文章が正本です([`SECURITY.md`](SECURITY.md) と [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) は英語とトルコ語のみで管理されています)。

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **始める前に(ライセンス、地域):** このリポジトリは MIT で、パッチとスクリプトだけを含みます。ダウンロードされる MiniMax H3 モデルは MiniMax H3 Community License の下にあります。対象地域には欧州連合、英国、韓国、米国は含まれず、モデル、派生物、**および出力(生成した動画)**をそれらの地域で使用・配布・表示してはいけません(V.4)。商用利用はライセンス条件の範囲内で認められます。インストール前に [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) を読んでください。これは法的助言ではありません。

> **30 秒で要点：** 4 GB のグラフィックカードで、MiniMax H3 の 209 フレーム（8.7 秒）の動画を 1 パスで生成できます。確認は 1 台のマシン（GTX 1050 Ti 4 GB）で行いました。空のフォルダーに対する `kur.ps1` のフルインストールは、まだ最初から最後までは検証していません [実測: リリースバイナリで `uret.ps1` 経由の 209 フレーム、実行 U209。latent は開発ビルドの実行とバイト単位で一致。動画内のフレームと音声は同一で、ファイルの sha はコンテナの違いにより異なる。証拠は作者が保管しており、このリポジトリには含まれない]。`-InitImg`（image-to-video）では最大 192 フレーム（8.0 秒）です [実測: 実行 B192]。209 フレームには約 57 分かかり、既定のタイムキャップは 80 分です [実測: 実行 U209]。以下の 3 ステップが実行方法です。

VideoTurko：4 GB の GTX 1050 Ti で MiniMax H3 の text-to-video を動かすための stable-diffusion.cpp 用メモリパッチとレシピです。1 パスで最大 209 フレーム（8.7 秒）、image-to-video（`-InitImg`）では最大 192 フレーム（8.0 秒）に対応します（209 フレームはバイトチェーンで検証済み。56 フレームと 141 フレームの確認では、パッチなしの実行とバイト単位で一致）。

## クイックスタート（Windows、3 ステップ）
**状況：以下のインストール・実行スクリプトは仕上げ中で、クリーンルートテストは未実施です。このテストに合格するまで、ここに書かれた内容が動作するとは主張しません（「状況と制限」を参照）。**

1. **ダウンロード**：このリポジトリをダウンロードし（緑の **Code** ボタン、続けて **Download ZIP**）、`C:\vt` のような短いパスのフォルダーに展開します。
2. **インストール: `kur.cmd` をダブルクリック**(黒いウィンドウが開き各ステップを表示します。閉じるとインストールが止まり、もう一度実行すると続きから再開します。ダウンロード途中のモデルファイルは再開されます [読了: ダウンロードスクリプトは `.part` ファイルを保持してそこから再開する。29 GiB 全体の再開は未測定])。ダウンロードしたファイルについて Windows が警告を出す場合は、代わりに下の PowerShell コマンドを使ってください [助言、ダウンロードした ZIP では未テスト]。コマンドラインがお好みですか? そのフォルダーで PowerShell を開き(エクスプローラーのアドレスバーに `powershell` と入力)、同じインストールを実行します:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   インストール先は展開したフォルダーです（エンジンは `engine\bin`、モデルは `model` に入ります）。別の場所を使う場合は、先に環境変数 `VT_ROOT` を設定してください。GPU、ドライバー、RAM、ディスクを確認し、エンジンとモデルを取得し（エンジンの zip と新規にダウンロードしたモデルファイルは sha256 で検証します。すでにあるモデルファイルはサイズが合っていればサイズだけを確認します。`scripts\modelleri_indir.ps1 -Dogrula` で完全な sha256 検証を実行できます）、短い実機チェックを実行し、そのチェックに合格した場合にだけ READY と表示します [設計: `kur.ps1` はクリーンなフォルダーで全体を実行したことがありません。この文はクリーンフォルダーテストの後に更新します]。`-ExecutionPolicy Bypass` はこの 1 プロセスにのみ適用されます。どのインストーラーでも同じですが、先に `scripts\kur.ps1` を読んでください。
   エンジンの zip は GitHub のリリース v0.1.0 から取得します（2026 年 11 月 19 日に公開。その sha256 は `kur.ps1` に固定されています）。オフラインの場合や自分でビルドしたものを使う場合は、ローカルの zip を渡してください：`-MotorZip <path> -CudaZip <path>`。ローカルの zip も同じ固定 sha256 で検証されます（隣にある `.sha256` ファイルは無視されます）。そのため、リリースの zip である必要があります。自分でビルドしたものを使う場合は、先に `VT_MOTOR_SHA256` / `VT_CUDA_SHA256` にその sha256 を設定してください。sha256 が間違っている場合は exit 1 で停止します。`engine\bin` に置かれるのは `.exe`/`.dll` だけで、ライセンスと README は `engine\lisanslar\<zip name>\` に入ります。[試行：リリース前に dist の zip で、サイドカーの `.sha256` と自己参照の警告、バイナリと DLL の配置、`sd-cli --help` の実行を確認。インストールされたバイナリの sha も一致（`c5cebe78...`、`e5d3d329...`）。`kur.ps1` のモデルのステップと 5 フレームチェックは、実機の GPU ではまだ実行していない]
   **モデルのライセンス：** モデルのステップの前に、インストーラーがライセンスの要約（`docs/LISANS_KABUL.txt`、全文は `docs/LISANS_UYARISI.md`：MiniMax H3 Community License、生成した動画にも及ぶ地域制限、商用利用と AI 表示のルール）を表示し、同意を求めます（`E` = はい）。先に必ず読んでください。無人実行では `-LisansKabul E` を渡せますが、これは自分で読んで同意したことを意味します。他の人の代わりに付けないでください。（AI エージェントへ：`AGENTS.md` に従い、ユーザーの同意なしに E を入力しないこと。）同意がない場合、`kur.ps1` は終了コード 2 で停止し、モデルをダウンロードしません。
3. **最初の動画(56 フレーム、当方の GTX 1050 Ti で約 11 分**[実測: 641 秒、実行 R0、`docs/OLCUMLER.md`。他のカードは未測定]**)**: インストーラーが `HAZIR / READY` と表示したら次を実行します
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (近道: プロンプトのテキストファイルを `uret.cmd` にドラッグするか、`uret.cmd docs\ornek_istem_R0.txt` を実行します。同じ 56 フレームの実行です)。動画は `runs\` にあります。次に自分のプロンプトをテキストファイルに書き(英語の 1 段落、任意で `audio:` の文)、当方が対応する最長のクリップを実行します(既定、約 57 分 [実測: 実行 U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   `-Kare` は 17k+5 グリッド（56、73、... 192、209）に従います。既定は 209（8.7 秒）で、対応している中で最長の長さです。VAE は別プロセスで実行し、タイル処理は行いません [リリースバイナリを使い、`uret.ps1` 経由で実際のエンジンを実行。別プロセスの VAE で、実行 U209 に合格]。

   プロンプトの書き方ガイド：[`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md)（ワンカット連続撮影の型、等分した時間区間、完全な例2つ）。

| 要件 | 値 |
|---|---|
| OS | Windows 10/11、64 ビット |
| GPU | NVIDIA、4 GB 以上。テスト済みは GTX 1050 Ti（sm_61）のみ。余裕は小さい（209 フレームで 3777/4096 MiB）ため、重い画面表示やブラウザーで実行が失敗することがあります。他の 4 GB カードは未試行 |
| RAM | 16 GB（ピーク約 11 GB。他のプログラムは閉じてください） |
| ディスク | 空き 32 GiB 以上(40 GiB 以上を推奨。32〜40 GiB のあいだはインストーラーが警告を出します。`[VT-W-DISK-PAY]` [実測: 空き容量を模擬した `-Kuru` 実行])、モデルは SSD に(NVMe 推奨) |
| ダウンロード | エンジン zip 36.8 MB + CUDA ランタイム zip 567.5 MB [実測] + モデル 31,473,112,040 バイト（約 29.3 GiB）[読了: サイズは `scripts/modeller.json`]。合計約 30 GiB |
| モデル | 同梱していません。MiniMax のライセンスに基づきインストーラーが取得します（下の警告を参照）。モデル（29.3 GiB、`scripts/modeller.json` の 31,473,112,040 バイト）はこのリポジトリにもリリースにも含まれません。GitHub のファイルサイズ・リリースサイズの制限があるため、`kur.ps1` が公式の配布元から sha256 検証つきでダウンロードします。 |

`kur.ps1` の終了コード：0 READY、1 エラー、2 ユーザーの入力が必要（ライセンス、またはリリース・zip がまだない）、3 ハードウェアまたはディスクが不足、4 停止（DUR ファイル）。`uret.ps1` は、`.avi` が存在し、フレーム数が正しく、ログに問題がない場合にだけ実行結果を受理します [実測: リリースバイナリで `uret.ps1` 経由の実機 1 回の実行、実行 U209、209 フレーム、ゲート合格]。`uret.ps1` の終了コード：0 DONE（品質ゲート合格）、1 エラーまたは無効な出力（音声ストリームのない動画を含む）、2 停止（DUR ファイル）、5 `KAPI RED`（品質ゲート不合格：クリップは受理されず、判断はあなたに委ねられます）、6 ゲートを実行できなかった（クリップは受理されない）。詳細は AGENTS.md を参照してください。[実測: 偽のエンジンと偽のゲートを使ったシナリオで終了コード 0、1（音声なしの動画）、5、6 を確認。実際のエンジン：実行 U209 で終了コード 0]

### トラブルシューティング（詳細：`docs/SIK_HATALAR.md`）
当方のスクリプトのエラー行には固定コードが付きます。例: `HATA: [VT-E-DLL] ...` や `UYARI: [VT-W-DISK-PAY] ...`。コードは [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md)(アンカーの例 `#vt-e-dll`)または `docs/hata_imzalari.json` で検索し、issue にもコードを書いてください。下の表の最初の列は出力のままです(コードとログの文は翻訳しません)。

| 表示 | 意味と対処 |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found`（#13） | `sd-cli.exe` を手動で起動しないでください。`scripts\kur.ps1` を実行すると CUDA の DLL が正しく配置されます。 |
| `blocks.0` で `failed during weight preparation`（#1、#3、#5） | メモリゲートで VRAM が足りません。17k+5 グリッドでフレーム数を減らし、他の GPU プログラムを閉じ、同梱のフラグはそのままにしてください。 |
| `retrying with temporal tiling`（#6） | VAE がタイル処理にフォールバックしました。品質評価の用途では出力は無効です。もう一度実行してください。 |
| タイムキャップで終了し、動画がない（#7） | 長いクリップでは `-TavanDk` を引き上げてください（既定のタイムキャップ：209 フレームで 80 分、`uret.ps1` が設定。当方の 209 フレームの実行は 57 分 [実測: 実行 U209]）。 |
| 終了コードが空なのに「完了」と表示される（#14） | ラッパーが終了コードを早く読みすぎています。再実行し、動画ファイルが存在することを確認してください。 |
| システムが遅くなる、スワップする（#18） | エンジンは約 10〜11 GB の RAM を使います。ブラウザーなど他のプログラムを閉じてください。 |
| sha256 の不一致 / ダウンロード失敗 | 多くはダウンロードの中断です。同じコマンドをもう一度実行してください。検証済みのファイルはスキップされます。 |

**困ったとき・気になるとき** [`SUPPORT.md`](SUPPORT.md)(質問先。返信時間は目標であり約束ではありません)· [`PRIVACY.md`](PRIVACY.md)(テレメトリーなし。ネットワークはエンジンとモデルのダウンロードにのみ、記載のホストから使います)· [`SECURITY.md`](SECURITY.md)(非公開での報告)· [`CONTRIBUTING.md`](CONTRIBUTING.md)(5 ステップで最初のプルリクエスト。ドキュメントとスクリプトに GPU は不要)。

### v0.1.1 の新機能：オプションの追加（詳細：`AGENTS.md`、`docs/SIK_HATALAR.md` 19-23）
これらのオプションを使わなければ、4 GB カードでの動作は何も変わりません（当方の基準に対する 56 フレームのバイトチェックは、v0.1.1 でも再び合格しました [実測]）。どのコマンドにも `-Kuru` を付けると、何が実行されるかを確認できます。
- `-EndImg`：最後のフレームも指定します（最初と最後のフレーム、"FLF"）。上限は 8 GB 未満のカードで 175 フレーム（4 GB では 192 は収まりませんでした）、8 GB 以上のカードでは 192 です。当方の GTX 1050 Ti では常に 2 つのプロセスで実行されます：56 フレームで 1040 秒、175 フレームで 2887 秒（48 分）、どちらもゲートに合格しました [実測]。プロンプトのコツ：`docs/ISTEM_YAZIMI.md`。
- `-W` / `-H`：ほかのサイズ、たとえば縦長の 384x640。32 の倍数で、面積は 640x384 以上です（これより小さくはできません）。4 GB では未テストです。8 GB 未満のカードでは、当方が測定した最大のジョブを超えるサイズは拒否されます。品質ゲートのしきい値は 640x384 で調整しています。
- `-TekAsama`：2 つのプロセスではなく 1 つのプロセスで実行します。大きなカード専用で、自動で有効になることはありません。
- 比較的新しい GPU（compute capability 7.0 以上、例：RTX 20/30/40）：自分で設定していない場合は `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` が自動で設定されます。これにより、報告者の RTX 4070 Ti で 141 フレーム以上の動画が真っ黒になる問題が解消しました [ユーザー報告, issue #1]。Python + OpenCV がない場合、`uret.ps1` は GPU ジョブの前に exit 6 で停止するようになりました（動画は作られず、誤解を招く RED も出ません）。
- これらの変更のきっかけとなった RTX 4070 Ti の報告をくださった @SinanC73 さんに感謝します（[issue #1](https://github.com/alexturkey/VideoTurko/issues/1)）。

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

## オプションの速度プロファイル(速度パック。既定ではオフ)
以下はいずれも既定の実行(640x384、209 フレーム、当社のカードで 3414 秒)を変えません。既定の外側にある実測済みの 3 つのセルで、それぞれ `uret.ps1` の名前付きプロファイルです。速度パックのエンジン(リリースのエンジンにパッチ 0021、0023、0024 を加えたもの。すべて既定ではオフ: `docs/YAMALAR.md`)が必要です。`scripts\kur.ps1 -HizPaketi` でインストールし(ローカルの zip は `-MotorZip` で使えます)、そのうえで `-Profil <name>` を付けます。`-Kuru` は実行される内容を表示します。高速化パックは v0.1.4 リリースとともに公開されます。

| プロファイル | サイズ、長さ | GTX 1050 Ti 4 GB での合計時間 | 状態 |
|---|---|---|---|
| (なし、既定) | 640x384、最大 209 フレーム(8.7 秒) | 209 フレーム: 3414 秒 | 検証済み、変更なし |
| `yuksek832` | 832x480、141 フレーム(5.9 秒) | 約 55-56 分 | 使用可、プロンプト 2 件 [実測] |
| `yuksek832 -Kare 124` | 832x480、124 フレーム(5.2 秒) | 約 45-46 分、速度フラグ不要 | 使用可、プロンプト 2 件 [実測] |
| `yuksek896` | 896x512、124 フレーム(5.2 秒) | 約 56-57.5 分 | 使用可、プロンプト 2 件 [実測] |
| `uzun260` | 640x384、260 フレーム(10.8 秒) | 早期終了なしで 78 分(実測)。早期終了ありでは約 71-72 分 [推測: `uret.ps1` 経由の通しでは未測定] | 条件付き・実験的 |

- **余裕が小さい:** 832x480 x 141 では、メモリゲートの余裕は 1 桁 MB です(完走した 2 回で 5.7 MB と 6.8 MB)。長いプロンプト 2 件(1520 文字と 2041 文字)は、ステップ 1 とステップ 2 の一部のゲートを読んで確認しただけで、最後まで実行していません: 余裕は 10.9 MB と 4.0 MB。カードのメモリを使う他のプロセス(ブラウザ、2 台目のディスプレイ)があると失敗することがあります。その場合は `-Kare 124` か既定のサイズを使ってください [実測、GTX 1050 Ti 4 GB]。
- **`uzun260` は条件付きです:** メモリの限界が非常に狭く(VRAM のピークは 4096 MiB 中 3903 MiB)、共有メモリの使用量が 45 MiB と 61 MiB (68) 増え、バイト一致を確かめるフラグなしの基準もないため、通常の機能としては提供しません。パッチ 0023 はこの 1 つのセルに限って受け入れています。
- **提供しないもの:** 832x480 で 158 フレームは短いプロンプトでのみ通りました(長いプロンプトでは共有メモリの上限を超えました)。175 フレームはゲートの読み取りだけで確認しました(最初のブロックで約 275 MB 不足、完全な実行なし)。プロファイルが提供するのは 141 フレームだけです。それ以外のサイズとフレーム数は `-Profil` が拒否します(既定の経路を使ってください)。
- 既定の品質は変わりません: 6 ステップ、cfg 1、タイルなし VAE、17k+5 フレーム。フラグを有効にした場合、フラグなしの実行が収まるサイズでは、出力をフラグなしの動画とバイト単位で照合しました(`docs/YAMALAR.md`)。832x480 x 141 と 896x512 x 124 ではフラグなしの実行が収まらないため、そこでの一致は直接の比較ではなく、最も近いセルに基づいています [実測、読了]。
- 2 段階実行の段階 1 は、潜在ファイルが完成した時点で終了するようになりました(`VT_ERKEN_CIKIS=0` で無効にできます)。

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

## これは何か
stable-diffusion.cpp 向けの小さなメモリ・スケジューリング用パッチと、実行レシピ、チェック、測定の一式です。これにより、MiniMax H3（33B の DiT。当方は HyperFlow Flash 13.7B Q4_K_M の GGUF を実行し、32B の Qwen3-VL テキストエンコーダーは別体）を、4 GB の Pascal GPU（GTX 1050 Ti、システム RAM 16 GB）で動かせます。
- 実際に生成し、品質ゲートを通過した 1 パスの長さ：640x384、24 fps で 56、141、158、175、192、209 フレーム（209 フレーム = 8.7 秒）、H3 自身が生成した音声つき [実測: リリースバイナリで `uret.ps1` 経由の 209 フレーム、実行 U209。latent は開発ビルドの実行とバイト単位で一致。動画内のフレームと音声は同一で、ファイルの sha はコンテナの違いにより異なる。証拠は作者が保管しており、このリポジトリには含まれない]。209 は、通して視聴して滑らかだと確認できた最長の長さです [ユーザー報告, 2026-11-19、動画を全編視聴。ファイル：F209V2 の出力、8.708 秒]。
- **バイト一致の主張、範囲を正直に示すと：** パッチなしの基準とバイト単位で一致することを確認したのは、56 フレームと 141 フレームだけです。158/175/192/209 フレームでは、同じフラグと同じバイナリチェーンを使いましたが、直接のバイト基準はありません（パッチなしのビルドは、この GPU ではそれらの長さを実行できません）。
- 品質設定は下げません：同じモデル・量子化、6 ステップ、cfg 1、640x384、同じシード、タイルなしの VAE。
- 「最初」だとは主張しません。調べた範囲では 4 GB でこれを行った外部の例は見つかりませんでしたが、それは存在しないことの証明ではありません。

## 構成
- `patches/` 固定した stable-diffusion.cpp のコミットに対するパッチ（そこにあるメモを参照）
- `scripts/` ビルド、実行、別プロセスの VAE、ゲート/一貫性のヘルパー（`doku_norm.py`：下のスケールの注記を参照）
- `docs/KURULUM.md` ハードウェア、ビルド、実行の手順（EN+TR）
- `docs/YAMALAR.md` パッチ一覧、`docs/KANITLAR.md` 証拠、`docs/KAPILAR.md` 品質ゲートの表、`docs/OLCUMLER.md` 測定、`docs/SIK_HATALAR.md` よくある間違い、`docs/LISANS_UYARISI.md` ライセンス項目の全文
- `scripts/` の簡易索引：`hiz_kos3.ps1` 実行ラッパー（`-Kuru` で正確なコマンドを表示）、`uretim_kapi.ps1` 品質ゲート、`dikis_denetim.py` つなぎ目のチェック、`doku_norm.py` テクスチャ正規化ノイズ、`bayt_kiyas.py` バイト比較、`derleme_sablonu.ps1` ビルドのテンプレート（自身のビルドが始まった後に起動した Visual Studio のテレメトリヘルパー `vctip.exe` だけを停止します。これを止めないと、ビルドプロセスが数分間つながったままになります。他の `vctip.exe` プロセスには触れません）

## 品質ゲート（結果を受理する基準）

このゲートは動きの一貫性（物体のスケールや位置の飛び）を検査しません。受理する前に動画全体を視聴してください。
1. フレーム数と音声があること。ログにメモリのフォールバックや ALLOC_FAILED の行がないこと。
2. 生ノイズのゲート：メディアンフィルターの残差 <= 1.5（0〜255 スケール）。
3. テクスチャ正規化ノイズ、`scripts/doku_norm.py`（このリポジトリの版）：N = 残差の中央値 / Sobel テクスチャ、6 フレームごと。**スケールの注記：** この版では、測定した 10 クリップで N = 0.034-0.052（表は `docs/KAPILAR.md`。F192/F209V2 の最後の 4 分の 1 は 0.062 に達する）、追加ゲートのしきい値は N <= 0.065 です。別の実装では同じクリップで 0.028-0.036 と測定されたため、しきい値は版の間で互換では**ありません**。非常に細かいテクスチャ（草の列）では、クリーンな N が 0.075 でしたので、しきい値はシーンの系統ごとに決まります。頑健な高周波推定量（sigma-HH <= 1.5。クリーンは 0.74-1.19、ノイズ s=2 を加えると 2.2-3.0）を、追加ゲートとして推奨します。

対象範囲：VideoTurko が扱うのは1回の単一パス（最大209フレーム、約8.7秒）です。私たち自身の連結テストでは継ぎ目が見えました（シーンがきれいに続きません）。そのため、より長い映画は私たちが検証する対象に含めません。連結にはコミュニティのガイド `docs/KLIP_ZINCIRI.md` と、CPU のみを使う補助ツール `scripts/zincir.py`（`plan`、`son-kare`、`bagla`。エンジンは一切起動しません）があります。連結した映画の品質は測っていないため [未試行]、すべての継ぎ目を目視と `scripts/dikis_denetim.py` で確認してください。
設定はあなたのものです。209 フレームは 4 GB カードでテストした当方の既定値であり、守るべき上限ではありません。17k+5 グリッド（56、73、... 192、209。`docs/KURULUM.md` を参照）から好きなフレーム数を選び、プロンプト、シード、解像度、各フラグを自由に変えてください。短いクリップほどメモリも時間も少なくて済み、大きな GPU ならもっと長く収まる場合があります。

## モデルライセンスに関する警告
**VideoTurko に含まれるのはパッチとスクリプト（MIT）だけです。モデルとその出力を使う人は、MiniMax のライセンスについて自分で責任を負います。** 法的助言ではありません。以下は MiniMax H3 Community License（2026 年 8 月 2 日）の条項を番号つきで要約したものです。拘束力があるのはライセンス本文です：https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

このリポジトリの MIT ライセンスはモデルの重みを対象としません。[`NOTICE`](NOTICE) を参照してください。 このリポジトリにはモデルの重みを一切含みません（MiniMax H3、HyperFlow-H3-Flash の GGUF、VAE のファイルはありません）。このプロジェクトは MiniMax と提携しておらず、承認も受けていません。商用利用は禁止されていません（非商用ライセンスではありません）。条件は以下のとおりです。

**地域（Applicable Territory）**
- **前文、I.3、I.5：** 世界全域です。ただし欧州連合、英国、大韓民国、米国を除きます。モデルを使用すると、ライセンスに同意したものとみなされます。
- **II：** 使用、複製、配布、派生物の作成、改変について、ロイヤルティ無償で、譲渡不可の、限定的なライセンスが与えられます。地域内に限り、契約と Exhibit A を遵守する場合にのみ有効です。除外地域の人は、MiniMax に別のライセンスを求めることができます。
- **V.4：** 地域外で、モデル、その派生物、および**出力**（生成した動画・音声）を使用、複製、改変、配布、表示することは認められていません。**したがって、生成した動画を EU・英国・韓国・米国で公開または上映することは、ライセンスの範囲外です。**
- **Exhibit A-1：** 地域外での使用は Acceptable Use Policy に違反します。

**配布（III）**（このリポジトリはモデルを配布しません。ご自身が配布する場合の条件です）
- **III.1：** すべての受領者にライセンスの写しを渡してください。**III.2：** 変更したファイルに目立つ表示を付けてください。
- **III.3：** 推奨されています（必須ではありません）：「Powered by MiniMax H3」の表示、生成したファイルへの AI 生成の識別子、公開の解説。
- **III.4：** 配布物には必ず NOTICE ファイルを添付し、次の文を記載してください："MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12：** 機械生成であることを明確に開示せずに、コンテンツを公開環境に公開することは禁止されています。AI 生成の動画は公開時にその旨を表示してください（全項目：`docs/LISANS_UYARISI.md`）。
- **III（最後の段落）：** 自分が行った変更部分に自分の著作権を表示することはできますが、使用・配布に追加の条件や異なる条件を課すことはできません。地域のルールは引き続き適用されます。

**商用条件（IV）**
- **IV.1：** 商用の製品・サービスの年間収益が 20 million USD（または相当額）を超える場合は、api@minimax.io（件名 "MiniMax H3 licensing - authorization request"）から事前に書面による許可を得てください。
- **IV.2：** モデルを使う商用製品・サービスの UI に、"MiniMax H3" を目立つように表示してください。

**使用制限（V）**
- **V.1：** 適用される法律（貿易コンプライアンスを含む）と Exhibit A を遵守してください。**V.2：** アクセスを与えるすべての相手を、これらの制限と同等以上に保護的な条件で拘束し、その旨を通知してください。
- **V.3：** モデルまたはその**出力**を、他の AI モデル（MiniMax H3 とその派生物を除く）の改善に使うことはできません。（I.11：蒸留や合成出力による学習を行ったモデルは「派生物」になります。出力そのものは派生物ではありません。）
- **V.5：** モデルで出力を生成する製品・サービス・ホスト型サービスを第三者に提供する場合は、運用の前および運用中に、合理的な技術的・組織的な保護措置、報告の仕組み、速やかな調査、違反を繰り返す者の削除・無効化・停止を行ってください。

**商標と権利（VI）**
- **VI.1：** 自分が作成した二次的著作物とモデルの派生物は、自分が所有します（MiniMax の権利を条件とします）。**VI.2：** MiniMax の名称・商標は許諾されません（説明と配布に必要な範囲を除く）。"MiniMax H3" の商標は、III.3 を遵守する目的で、地域内でのみ使用できます。提携関係を示唆しないでください。
- **VI.3：** MiniMax または他の誰かに対し、資料や出力が自分の権利を侵害すると主張して訴えた場合、その日にあなたのすべてのライセンスは終了します。あなたまたは他者の使用・配布から生じる第三者の請求について、MiniMax を防御し補償する必要があります。
- **VI.4：** MiniMax は出力に対する権利を主張しません。出力とその利用については、あなたとあなたのユーザーが責任を負います。

**免責と終了（VII、VIII、IX）**
- **VII.1：** サポート・更新の義務はありません。**VII.2：** モデルと出力は「現状のまま（AS IS）」で提供され、保証はありません。適合性は自分で判断し、リスクを負います。**VII.3：** MiniMax とその関連会社は、法律が許す範囲で、いかなる損害にも責任を負いません。
- **VIII.1：** 同意またはアクセスの時点で発効します。**VIII.2：** 違反があった場合、MiniMax は終了できます。あなたは使用・配布を停止し、複製を削除し、受領者に通知しなければなりません（VI.1、VI.3、VII、IX は存続します）。
- **IX：** 香港特別行政区の法律が適用され、香港の裁判所が専属管轄を持ちます（国連物品売買条約 CISG は適用除外）。
- **補足：** MiniMax H3 のエンコーダーは Qwen3-VL-32B（Apache 2.0）を使っています。

**Acceptable Use Policy（Exhibit A）**（モデル、派生物、出力を次の目的に使用してはなりません）
- A-1 地域外での使用、A-2 法律または第三者の知的財産の侵害、A-3 自分や他者への危害、A-4 危害を与える目的での出力の転用・配布、A-5 保護措置の回避、A-6 未成年者の搾取・危害、A-7 他者を害する、または選挙に影響を与える検証可能な虚偽情報、A-8 オンライン上の偽のエンゲージメント（偽レビューなど）、A-9 名誉毀損、中傷、嫌がらせ、A-10 マルウェア、A-11 他者を害する目的での個人データ、**A-12 機械生成であることを明確かつ目立つ形で開示せずに、コンテンツを公開環境（ボットによる投稿を含む）に公開すること**、A-13 同意のないなりすまし、A-14 重要分野（法執行、入国管理、医療、重要インフラ、信用、雇用、住宅、教育、ソーシャルスコアリング、保険など）における高リスクの自動意思決定、A-15 他の国・地域の社会的、倫理的、道徳的基準への違反、A-16 暴力的過激主義・テロ、A-17 保護される属性に基づく差別・危害、A-18 脆弱な人々の搾取、**A-19 軍事目的**、A-20 無許可・無資格の専門的活動（金融、法律、医療など）。
- 注：これは平易な言葉による要約です。疑義がある場合は、英語のライセンス本文が優先します。

## 証拠ラベル

すべての文書で共通の 1 セット（旧表記は括弧内）：
- **[実測]**（英：measured、TR: ölçtüm, olctum）：このプロジェクトで実行したもの。証拠のパスがある。
- **[読了]**（英：read、TR: okudum yol, okudum）：ソースまたはスクリプトを読んだが、実行はしていない。
- **[設計]**（英：design、TR: tasarım, tasarim）：設計はしたが、実機での実行ではまだ確認していない。
- **[推測]**（英：guess、TR: tahmin）：未検証。
- **[未試行]**（英：not tried、TR: denenmedi）：一度も実行していない。
- **[ユーザー報告]**（英：user-reported、TR: kullanıcı bildirdi）：ユーザーが日付つきで述べたもの。独立した測定はしていない。
- **[算出]**（英：computed、TR: hesap。旧表記：calculated, hesap）：測定した入力から導いた数値で、それ自体は測定ではない。導出は数値の隣に記す。旧い文中の [提案] / [öneri] は [推測] に読み替える。

括弧内で使う実行名（当方の実行名であり、このリポジトリにあるファイルではありません）：U209 = リリースバイナリで `uret.ps1` 経由の 209 フレーム。B209 と B192 = 209 および 192 フレームの image-to-video（`-InitImg`）の実行。B56VT2 = リリースバイナリ、56 フレーム、56 フレームのバイト基準 R0 と比較。F209b、F209V2、F209V2K = 開発ビルドでの 209 フレームの実行（詳細：`docs/OLCUMLER.md`）。

## 既知の制限
- **バイト証明**（自分で再現する方法：`docs/KANITLAR.md` の "R0 ve latent referansi nasil uretilir"。当方の sm_61 カードで確認済みで、他の GPU ではバイト単位で一致しない可能性があります [推測]）：当方のパッチシリーズ（メモリフラグ有効）で 56 フレームの実行は sha256 `0979f156d548169b...` となり、基準と同一でした [実測]。141 フレームでは、latent の sha256 `E5D028F8632BE4FE...` が（0013/0014 フラグつきで）同一でした。158〜209 フレームには直接のバイト基準がなく、証拠はゲートの連鎖です。数値ゲートに合格しても、良いクリップであるとは限りません。時間方向の動きの一貫性は、目で確認します（`docs/KAPILAR.md` を参照）。
- **209 フレーム、どのフラグセットか：** 209 フレームのバイトチェーンの証拠は、開発ビルド上の F209V2 のフラグセット（block-tail フラグなし、パッチ 0019/0020 なしでビルド）で取得しました。`uret.ps1` は 209 フレームでこのレシピを使います [読了: スクリプト。`uret.ps1` 経由の実機エンジンの実行が、実行 U209 で合格]。
- 私たちが検証したのは1枚のカード（GTX 1050 Ti 4 GB）のみ。他のカードに関する外部報告はラベル付きで `docs/KART_PROFILLERI.md` に一覧しています [ユーザー報告]。
- **どのバイナリを測定したか：** 141 フレームの latent とバイトチェーンは、当方の開発ビルドで測定しました。ダウンロードできるリリースバイナリは新規のビルドで、その 56 フレームのバイトゲートに合格し（次の項目）、`uret.ps1` 経由の 209 フレームの実行もゲートに合格しました（実行 U209、3414 秒、VRAM ピーク 3777 MiB）[実測]。開発ビルドの 209 フレームの実行に対し、latent はバイト単位で一致します。動画ではフレーム（md5）と音声が同一で、AVI ファイルの sha256 はコンテナの違いにより異なります [実測]（`docs/OLCUMLER.md` のセクション 0 を参照）。
- **リリースバイナリ、56 フレーム：** リリースバイナリ（sd-cli `c5cebe78...`、stable-diffusion.dll `e5d3d329...`）は、56 フレームの結果を R0 とバイト単位で同一に出力しました（sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`。フレームごとの md5 と音声も同一）。既定のフラグで直接実行（`SD_*` 変数なし）、終了コード 0、601 秒 [実測: 実行 B56VT2、2026-11-19。証拠は作者が保管しており、このリポジトリには含まれない]。範囲：当方の sm_61 カードと 56 フレームのみ。クリーンルートのインストールテストではありません。141 フレームの latent と 209 のチェーンは古いバイナリで測定したもので、このバイナリでは繰り返していません [未試行]。最初の試行（B56VT、ヘルパースクリプト経由）は 58 秒後に何も出力せず終了し、原因は不明です [推測: メモリ圧迫]。2 回目の試行では `sd-cli` を直接実行しました。
- インストールと実行のスクリプトは、空のフォルダーからはまだ検証していません（クリーンルートテストは未実施）。
- ロードマップと今後の予定：`ROADMAP.md`。

## 状況と制限
- 検証したのは 1 台のマシン（GTX 1050 Ti 4 GB、RAM 16 GB、i7-7700HQ）です。他の 4 GB カードや他の RAM 容量では結果が異なる可能性があります。
- **既定の 209 フレーム（8.7 秒）：** 当方の品質ゲートに合格しました（ノイズ 1.08、実行 F209V2K）[実測: リリースバイナリで `uret.ps1` 経由の 209 フレーム、実行 U209。latent は開発ビルドの実行とバイト単位で一致。動画内のフレームと音声は同一で、ファイルの sha はコンテナの違いにより異なる。証拠は作者が保管しており、このリポジトリには含まれない]。209 フレームでの DiT の VRAM ピークは、4096 MiB 中 3777 MiB でした（実行 F209b と U209。カード全体の `nvidia-smi` の読み値）。余裕は小さく、他の GPU 負荷（ディスプレイ、他のアプリケーション）があると、実行が `blocks.0` で失敗することがあります。テスト済みは GTX 1050 Ti のみです。その実行中のディスプレイの状態は記録していません。ディスプレイがこのカードで動いている場合、使える VRAM は少なくなります [推測: Windows のディスプレイ負荷は約 100〜300 MB]。必要なら、ディスプレイを内蔵 GPU に接続してください [助言・未検証]。サンプリングには 2730 秒（実行 U209：1 ステップが 436〜483 秒）、別プロセスの VAE デコードには 173 秒かかりました（音声デコードを含むステージ 2 の合計は 193 秒）[実測: U209 リリースバイナリ。以前の開発ビルドの実行：2664 秒と 174 秒]。ステージ 1 では、プロセス内の VAE がメモリ不足になり、temporal tiling にフォールバックしました（320 秒）。その出力は破棄され、動画はタイルなしのステージ 2 から作られます。U209 では RAM のピークは測定していません。209 フレームより長いクリップは、このリリースの対象外です。
- **image-to-video（`-InitImg`）：** 初期画像がある場合、この GPU での上限は 192 フレーム（24 fps で 8.0 秒）です。209 フレームは収まりませんでした（block 0 で VRAM が約 17.5 MB 不足：必要 2587 MB、利用可能 2570 MB）。192 フレームは `uret.ps1` 経由で 3086 秒、VRAM ピーク 3783 MiB で実行でき、ゲートに合格しました [実測: 実行 B209 と B192、2026-11-20、1 シーン。証拠は作者が保管しており、このリポジトリには含まれない]。他の GPU では試していません [未試行]。
- **空き RAM が重要：** 約 11 GB の空き RAM が必要です（エンジンのプロセスが約 11 GB を保持します）[実測]。空き RAM が少なすぎると、プロセスがエラーメッセージなしで終了することがあります [推測: 空き RAM が約 300 MB で、`sd-cli` が約 10 GB を保持していたときに 1 回観察した]。実行中は他の大きなプログラムを開かないでください。16 GB のマシンでは空きが 0.3〜0.5 GB ほどしか残らず、メモリ圧迫の下で実行が黙って終了することがあります。開始する前に、ブラウザー、ゲーム、その他の大きなプログラムを閉じ、空き RAM を確認してください。
- **クリーンルートテストは未実施：** インストールと実行のスクリプトは、この手順だけを使って空のフォルダーから検証したことがまだありません。そのテスト（基準に対する 56 フレームのバイト比較を含む）を記録した時点で、このセクションを更新します。
- 生成した動画は、ここには同梱していません。

<!-- i18n-source: README.md sha256:85813d39c127 -->
