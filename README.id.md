# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · Bahasa Indonesia · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

Terjemahan mengikuti README bahasa Inggris ini. Jika terjemahan berbeda atau tertinggal, teks bahasa Inggris yang berlaku, terutama untuk teks lisensi dan keamanan ([`SECURITY.md`](SECURITY.md) dan [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) hanya dipelihara dalam bahasa Inggris dan Turki).

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **Sebelum mulai (lisensi, wilayah):** repositori ini berlisensi MIT dan hanya berisi patch dan skrip. Model MiniMax H3 yang diunduhnya berada di bawah MiniMax H3 Community License: wilayahnya tidak mencakup Uni Eropa, Inggris Raya, Korea Selatan, dan Amerika Serikat, dan model, turunannya **serta keluarannya (video yang Anda hasilkan)** tidak boleh digunakan, didistribusikan, atau ditampilkan di sana (V.4). Penggunaan komersial diizinkan dalam batas ketentuan lisensi. Baca [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) sebelum memasang; ini bukan nasihat hukum.

> **Dalam 30 detik:** kartu grafis 4 GB bisa membuat video MiniMax H3 sepanjang 209 frame (8,7 dtk) dalam satu kali proses: terverifikasi pada satu mesin (GTX 1050 Ti 4 GB; instalasi `kur.ps1` lengkap pada folder kosong belum diverifikasi dari awal sampai akhir) [terukur: 209 frame dengan binary rilis melalui `uret.ps1`, run U209; latent identik byte demi byte dengan run dengan build pengembangan; frame dan audio pada video identik, sha file berbeda karena kontainer; bukti disimpan oleh penulis, tidak ada di repo ini]; dengan `-InitImg` (gambar ke video) paling banyak 192 frame (8,0 dtk) [terukur: run B192]; 209 frame memakan waktu sekitar 57 menit, batas waktu bawaan 80 menit [terukur: run U209]; 3 langkah di bawah adalah cara menjalankannya.

VideoTurko: patch memori stable-diffusion.cpp beserta resep menjalankan MiniMax H3 text-to-video di GTX 1050 Ti 4 GB, hingga 209 frame (8,7 dtk) dalam satu kali proses; image-to-video (`-InitImg`) hingga 192 frame (8,0 dtk) (209 frame diverifikasi dengan rantai byte; identik byte dengan proses tanpa patch pada pemeriksaan 56 dan 141 frame).

## Mulai cepat (Windows, 3 langkah)
**Status: skrip instalasi/penggunaan di bawah masih diselesaikan dan uji clean-root belum dilakukan; tidak ada yang di sini diklaim berfungsi sampai uji itu lulus (lihat "Status dan batasan").**

1. **Unduh** repositori ini (tombol hijau **Code**, lalu **Download ZIP**) dan ekstrak ke folder PENDEK, misalnya `C:\vt`.
2. **Pasang: klik dua kali `kur.cmd`** (jendela hitam terbuka dan menampilkan setiap langkah; menutupnya menghentikan pemasangan, dan menjalankannya lagi melanjutkan dari tempat berhenti: berkas model yang terunduh separuh dilanjutkan [dibaca: skrip unduh menyimpan berkas `.part` dan melanjutkan darinya; kelanjutan penuh 29 GiB belum diukur]). Jika Windows memberi peringatan tentang berkas yang diunduh, gunakan perintah PowerShell di bawah sebagai gantinya [saran, belum diuji pada ZIP yang diunduh]. Lebih suka baris perintah? Buka PowerShell di folder itu (ketik `powershell` di bilah alamat Explorer) dan jalankan pemasangan yang sama:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   Root instalasi adalah folder hasil ekstrak (engine masuk ke `engine\bin`, model ke `model`); untuk memakai lokasi lain, atur dulu variabel lingkungan `VT_ROOT`. Skrip memeriksa GPU, driver, RAM, dan disk, mengambil engine dan model (zip engine dan file model yang baru diunduh diperiksa sha256; file model yang sudah ada dengan ukuran yang benar hanya diperiksa ukurannya, `scripts\modelleri_indir.ps1 -Dogrula` menjalankan pemeriksaan sha256 penuh), menjalankan pemeriksaan nyata singkat, dan mencetak READY hanya jika pemeriksaan itu lulus [rancangan: `kur.ps1` belum pernah dijalankan penuh di folder bersih; kalimat ini diperbarui setelah uji folder bersih]. `-ExecutionPolicy Bypass` hanya berlaku untuk proses ini; baca `scripts\kur.ps1` terlebih dahulu, seperti pada installer mana pun.
   Zip engine diunduh dari rilis GitHub v0.1.0 (dipublikasikan 2026-11-19; sha256-nya dikunci di `kur.ps1`). Jika offline atau memakai build sendiri, berikan zip lokal: `-MotorZip <path> -CudaZip <path>`. Zip lokal juga diperiksa dengan sha256 terkunci yang sama (file `.sha256` di sampingnya diabaikan), jadi harus zip rilis; untuk build sendiri, atur dulu `VT_MOTOR_SHA256` / `VT_CUDA_SHA256` ke sha256 build tersebut. sha256 yang salah menghentikan proses dengan exit 1. Hanya `.exe`/`.dll` yang masuk ke `engine\bin`; lisensi dan README masuk ke `engine\lisanslar\<zip name>\`. [dicoba dengan zip dist sebelum rilis: `.sha256` pendamping beserta peringatan merujuk-diri-sendiri, binary dan DLL terpasang, `sd-cli --help` berjalan; sha binary terpasang cocok (`c5cebe78...`, `e5d3d329...`); langkah model dan pemeriksaan 5 frame pada `kur.ps1` BELUM dijalankan di GPU sungguhan]
   **Lisensi model:** sebelum langkah model, installer mencetak ringkasan lisensi (`docs/LISANS_KABUL.txt`, teks lengkap `docs/LISANS_UYARISI.md`: MiniMax H3 Community License, batasan wilayah yang juga mencakup video hasil generasi, aturan komersial dan label AI) dan meminta Anda menerimanya (`E` = ya). Bacalah terlebih dahulu. Untuk eksekusi tanpa pengawasan Anda bisa memberikan `-LisansKabul E`, yang berarti Anda sudah membaca dan menerimanya sendiri; jangan menambahkannya atas nama orang lain. (Agen AI: ikuti `AGENTS.md`; jangan pernah mengetik E tanpa persetujuan pengguna.) Tanpa persetujuan, `kur.ps1` berhenti dengan exit code 2 dan tidak mengunduh model apa pun.
3. **Video pertama Anda (56 frame, sekitar 11 mnt pada GTX 1050 Ti kami** [terukur: 641 dtk, run R0, `docs/OLCUMLER.md`; kartu lain tidak diukur]**)**: saat pemasang mencetak `HAZIR / READY`, jalankan
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (jalan pintas: seret berkas teks prompt ke `uret.cmd`, atau jalankan `uret.cmd docs\ornek_istem_R0.txt`: run 56 frame yang sama). Videonya ada di `runs\`. Lalu tulis prompt Anda sendiri dalam berkas teks (satu paragraf bahasa Inggris, kalimat `audio:` opsional) dan jalankan klip terpanjang yang kami cakup (bawaan, sekitar 57 mnt [terukur: run U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   `-Kare` mengikuti kisi 17k+5 (56, 73, ... 192, 209); bawaan 209 (8,7 dtk), panjang terpanjang yang kami cakup. VAE berjalan di proses terpisah, tidak pernah dipecah menjadi tile [run engine nyata melalui `uret.ps1` dengan binary rilis, VAE proses terpisah, lulus pada run U209].

   Panduan menulis prompt: [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (pola satu pengambilan gambar tanpa putus, potongan waktu yang sama panjang, dua contoh lengkap).

| Persyaratan | Nilai |
|---|---|
| OS | Windows 10/11, 64-bit |
| GPU | NVIDIA, 4 GB atau lebih; diuji hanya pada GTX 1050 Ti (sm_61); margin tipis (3777/4096 MiB pada 209 frame): layar atau browser yang sibuk bisa menggagalkan proses; tidak ada kartu 4 GB lain yang dicoba |
| RAM | 16 GB (puncak sekitar 11 GB; tutup program lain) |
| Disk | minimal 32 GiB kosong (disarankan 40 GiB atau lebih: di antara 32 dan 40 pemasang mencetak peringatan, `[VT-W-DISK-PAY]` [terukur: run `-Kuru` dengan disk simulasi]), model di SSD (NVMe lebih baik) |
| Unduhan | zip engine 36,8 MB + zip runtime CUDA 567,5 MB [terukur] + model 31.473.112.040 byte (sekitar 29,3 GiB) [dibaca: ukuran di `scripts/modeller.json`]; total sekitar 30 GiB |
| Model | tidak disertakan; diambil oleh installer di bawah lisensi MiniMax (lihat peringatan di bawah). Model (29,3 GiB, 31.473.112.040 byte di `scripts/modeller.json`) tidak ada di repositori atau rilis ini: batas ukuran file/rilis GitHub berlaku, dan `kur.ps1` mengunduhnya dari sumber resmi dengan verifikasi sha256. |

Kode keluar `kur.ps1`: 0 READY, 1 galat, 2 butuh masukan pengguna (lisensi, atau belum ada rilis/zip), 3 perangkat keras atau disk tidak mencukupi, 4 dihentikan (file DUR). `uret.ps1` hanya menerima hasil jika file `.avi` ada, jumlah frame benar, dan log bersih [terukur: satu run nyata melalui `uret.ps1` pada binary rilis, run U209, 209 frame, gerbang lulus]. Kode keluar `uret.ps1`: 0 DONE (gerbang kualitas lulus), 1 galat atau keluaran tidak valid (termasuk video tanpa aliran audio), 2 dihentikan (file DUR), 5 `KAPI RED` (gerbang kualitas gagal: klip tidak diterima, keputusan ada di tangan Anda), 6 gerbang tidak dapat dijalankan (klip tidak diterima). Rincian di AGENTS.md. [terukur: kode keluar 0, 1 (video bisu), 5, dan 6 pada skenario dengan engine palsu dan gerbang palsu; engine nyata: exit 0 pada run U209]

### Pemecahan masalah (rincian: `docs/SIK_HATALAR.md`)
Baris galat dari skrip kami membawa kode tetap, misalnya `HATA: [VT-E-DLL] ...` atau `UYARI: [VT-W-DISK-PAY] ...`. Cari kodenya di [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) (contoh jangkar `#vt-e-dll`) atau di `docs/hata_imzalari.json`, dan tulis kodenya di issue Anda. Kolom pertama tabel di bawah tetap seperti yang dicetak (jangan terjemahkan kode dan teks log).

| Yang Anda lihat | Artinya, dan yang harus dilakukan |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | Jangan menjalankan `sd-cli.exe` secara manual; jalankan `scripts\kur.ps1`, yang menempatkan DLL CUDA pada tempatnya. |
| `failed during weight preparation` pada `blocks.0` (#1, #3, #5) | VRAM tidak cukup pada gerbang memori: pakai jumlah frame yang lebih kecil pada kisi 17k+5, tutup program GPU lain, pertahankan flag bawaan. |
| `retrying with temporal tiling` (#6) | VAE beralih ke mode tiling; keluarannya tidak valid untuk keperluan kualitas. Jalankan ulang. |
| Run berakhir di batas waktu, tanpa video (#7) | Naikkan `-TavanDk` untuk klip panjang (batas waktu bawaan: 80 menit untuk 209 frame, diatur oleh `uret.ps1`; run 209 frame kami memakan waktu 57 menit [terukur: run U209]). |
| Exit code kosong tetapi "finished" (#14) | Wrapper membaca exit code terlalu cepat; jalankan ulang, dan periksa bahwa file video ada. |
| Sistem melambat, swapping (#18) | Engine memakai sekitar 10-11 GB RAM; tutup browser dan program lain. |
| sha256 tidak cocok / unduhan gagal | Biasanya unduhan terputus: jalankan perintah yang sama lagi, file yang sudah terverifikasi dilewati. |

**Terkendala atau penasaran?** [`SUPPORT.md`](SUPPORT.md) (tempat bertanya; waktu balasan adalah target, bukan komitmen) · [`PRIVACY.md`](PRIVACY.md) (tanpa telemetri; jaringan hanya dipakai untuk mengunduh mesin dan model dari host yang terdaftar) · [`SECURITY.md`](SECURITY.md) (laporan privat) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (pull request pertama dalam 5 langkah; tidak perlu GPU untuk dokumen dan skrip).

### Baru di v0.1.1: lebih banyak opsi (rincian: `AGENTS.md`, `docs/SIK_HATALAR.md` 19-23)
Tanpa opsi-opsi ini tidak ada yang berubah pada kartu 4 GB (pemeriksaan byte 56 frame terhadap referensi kami kembali lulus dengan v0.1.1 [terukur]). Tambahkan `-Kuru` ke perintah apa pun untuk melihat apa yang akan dijalankan.
- `-EndImg`: berikan juga frame terakhir (frame pertama dan terakhir, "FLF"); batasnya 175 frame pada kartu di bawah 8 GB (192 tidak muat di 4 GB), 192 pada kartu 8 GB ke atas. Di GTX 1050 Ti kami opsi ini selalu berjalan dalam dua proses: 56 frame 1040 dtk, 175 frame 2887 dtk (48 menit), keduanya lulus gerbang [terukur]. Tips menulis prompt: `docs/ISTEM_YAZIMI.md`.
- `-W` / `-H`: ukuran lain, misalnya vertikal 384x640; kelipatan 32, luas minimal 640x384 (tidak pernah lebih kecil). Belum diuji pada 4 GB; pada kartu di bawah 8 GB, ukuran yang melampaui pekerjaan terbesar yang pernah kami ukur akan ditolak. Ambang gerbang kualitas dikalibrasi pada 640x384.
- `-TekAsama`: satu proses alih-alih dua, khusus kartu besar; tidak pernah diaktifkan secara otomatis.
- GPU yang lebih baru (compute capability 7.0+, misalnya RTX 20/30/40): `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` diatur otomatis kecuali Anda mengaturnya sendiri; ini memperbaiki video yang hitam total pada 141+ frame di RTX 4070 Ti milik pelapor [dilaporkan pengguna, issue #1]. Tanpa Python + OpenCV, `uret.ps1` kini berhenti dengan exit 6 sebelum pekerjaan GPU (tidak ada video yang dibuat, tidak ada RED yang menyesatkan).
- Terima kasih kepada @SinanC73 atas laporan RTX 4070 Ti yang mendorong perubahan ini ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1)).

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

## Profil kecepatan opsional (paket kecepatan; mati secara bawaan)
Tidak satu pun di bawah ini mengubah proses bawaan (640x384, 209 frame, 3414 s pada kartu kami). Ini tiga sel terukur di luarnya, masing-masing profil bernama dari `uret.ps1`; semuanya membutuhkan mesin paket kecepatan (mesin rilis ditambah patch 0021, 0023, 0024, semuanya mati secara bawaan: `docs/YAMALAR.md`). Pasang dengan `scripts\kur.ps1 -HizPaketi` (zip lokal berfungsi dengan `-MotorZip`), lalu tambahkan `-Profil <name>`; `-Kuru` menampilkan apa yang akan dijalankan. Paket kecepatan dirilis bersama versi v0.1.4.

| Profil | Ukuran, panjang | Total waktu pada GTX 1050 Ti 4 GB | Status |
|---|---|---|---|
| (tanpa, bawaan) | 640x384, hingga 209 frame (8,7 s) | 209 frame: 3414 s | terverifikasi, tidak berubah |
| `yuksek832` | 832x480, 141 frame (5,9 s) | sekitar 55-56 mnt | dapat dipakai, dua prompt [terukur] |
| `yuksek832 -Kare 124` | 832x480, 124 frame (5,2 s) | sekitar 45-46 mnt, tanpa flag kecepatan | dapat dipakai, dua prompt [terukur] |
| `yuksek896` | 896x512, 124 frame (5,2 s) | sekitar 56-57,5 mnt | dapat dipakai, dua prompt [terukur] |
| `uzun260` | 640x384, 260 frame (10,8 s) | 78 mnt terukur tanpa keluar dini; dengan keluar dini sekitar 71-72 mnt [perkiraan: tidak diukur dari ujung ke ujung lewat `uret.ps1`] | bersyarat dan eksperimental |

- **Margin sempit:** pada 832x480 x 141 gerbang memori hanya menyisakan ruang satu digit MB (5,7 dan 6,8 MB pada dua proses penuh). Dua prompt panjang (1520 dan 2041 karakter) hanya diperiksa dengan membaca gerbang untuk langkah 1 dan sebagian langkah 2, tidak dijalankan penuh: ruang 10,9 dan 4,0 MB. Proses lain mana pun yang memakai memori kartu (peramban, layar kedua) bisa membuatnya gagal; kalau begitu gunakan `-Kare 124` atau ukuran bawaan [terukur, GTX 1050 Ti 4 GB].
- **`uzun260` bersyarat:** batas memorinya sangat sempit (puncak VRAM 3903 dari 4096 MiB), pemakaian memori bersama naik 45 dan 61 MiB (batas 68), dan tidak ada acuan tanpa flag untuk kesamaan byte, sehingga tidak ditawarkan sebagai fitur biasa. Patch 0023 diterima hanya untuk sel ini.
- **Tidak ditawarkan:** 832x480 pada 158 frame tidak muat dengan patch yang disertakan (di gerbang langkah 2 kurang sekitar 280 MB); 175 frame hanya diperiksa lewat pembacaan gerbang (blok pertama kurang sekitar 275 MB, tanpa uji penuh). Profil hanya menawarkan 141 frame. Ukuran dan jumlah frame lain ditolak oleh `-Profil` (gunakan jalur bawaan).
- Kualitas bawaan tidak disentuh: 6 langkah, cfg 1, VAE tanpa tile, 17k+5 frame. Di mana flag aktif, keluaran dibandingkan byte demi byte dengan video tanpa flag pada ukuran yang muat untuk proses tanpa flag (`docs/YAMALAR.md`); pada 832x480 x 141 dan 896x512 x 124 proses tanpa flag tidak muat, sehingga kesamaan di sana bertumpu pada sel terdekat, bukan perbandingan langsung [terukur, dibaca].
- Tahap 1 dari proses dua tahap kini berakhir begitu berkas laten lengkap (`VT_ERKEN_CIKIS=0` mematikannya).

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

## Apa ini
Sekumpulan patch kecil memori/penjadwalan untuk stable-diffusion.cpp beserta resep penggunaan, pemeriksaan, dan pengukuran yang memungkinkan MiniMax H3 (DiT 33B; kami menjalankan GGUF HyperFlow Flash 13.7B Q4_K_M; text encoder Qwen3-VL 32B terpisah) berjalan di GPU Pascal 4 GB (GTX 1050 Ti, RAM sistem 16 GB).
- Panjang satu-proses yang benar-benar kami hasilkan dan lulus gerbang kualitas kami: 56, 141, 158, 175, 192, 209 frame pada 640x384, 24 fps (209 frame = 8,7 dtk), dengan audio buatan H3 sendiri [terukur: 209 frame dengan binary rilis melalui `uret.ps1`, run U209; latent identik byte demi byte dengan run dengan build pengembangan; frame dan audio pada video identik, sha file berbeda karena kontainer; bukti disimpan oleh penulis, tidak ada di repo ini]. 209 adalah panjang terpanjang yang kami tonton dan kami nilai mulus [dilaporkan pengguna, 2026-11-19, video ditonton penuh; file: keluaran F209V2, 8,708 dtk].
- **Klaim identik-byte, dengan cakupan yang jujur:** keluaran diperiksa identik byte dengan referensi tanpa patch hanya untuk 56 dan 141 frame. Untuk 158/175/192/209 frame kami memakai flag yang sama dan rantai binary yang sama; tidak ada referensi byte langsung (build tanpa patch tidak bisa menjalankan panjang itu di GPU ini).
- Pengaturan kualitas tidak pernah diturunkan: model/kuantisasi sama, 6 langkah, cfg 1, 640x384, seed sama, VAE tanpa tiling.
- Kami tidak mengklaim sebagai yang pertama: kami mencari dan tidak menemukan contoh luar untuk ini di 4 GB, tetapi itu bukan bukti bahwa tidak ada.

## Tata letak
- `patches/` patch untuk commit stable-diffusion.cpp yang dikunci (lihat catatan di sana)
- `scripts/` skrip build, jalankan, VAE proses terpisah, pembantu gerbang/konsistensi (`doku_norm.py`: lihat catatan skala di bawah)
- `docs/KURULUM.md` perangkat keras, langkah build dan jalankan (EN+TR)
- `docs/YAMALAR.md` daftar patch, `docs/KANITLAR.md` bukti, `docs/KAPILAR.md` tabel gerbang kualitas, `docs/OLCUMLER.md` pengukuran, `docs/SIK_HATALAR.md` kesalahan umum, `docs/LISANS_UYARISI.md` seluruh butir lisensi
- `scripts/` indeks singkat: `hiz_kos3.ps1` wrapper jalankan (`-Kuru` mencetak perintah persisnya), `uretim_kapi.ps1` gerbang kualitas, `dikis_denetim.py` pemeriksaan sambungan, `doku_norm.py` noise ternormalisasi tekstur, `bayt_kiyas.py` perbandingan byte, `derleme_sablonu.ps1` templat build (hanya menghentikan helper telemetri Visual Studio `vctip.exe` yang mulai setelah build-nya sendiri berjalan, yang kalau tidak akan menahan proses build selama beberapa menit; proses `vctip.exe` lainnya dibiarkan)

## Gerbang kualitas (cara hasil diterima)

Gerbang ini tidak memeriksa konsistensi gerak (lompatan skala atau posisi objek): tonton seluruh video sebelum menerimanya.
1. Jumlah frame dan audio ada; tidak ada fallback memori atau baris ALLOC_FAILED di log.
2. Gerbang noise mentah: residu median-filter <= 1,5 (skala 0-255).
3. Noise ternormalisasi tekstur, `scripts/doku_norm.py` (versi repo ini): N = residu median / tekstur Sobel, setiap frame ke-6. **Catatan skala:** pada versi ini 10 klip terukur menghasilkan N = 0,034-0,052 (tabel di `docs/KAPILAR.md`; seperempat terakhir F192/F209V2 mencapai 0,062) dan ambang gerbang tambahan adalah N <= 0,065. Implementasi lain mengukur 0,028-0,036 pada klip yang sama, sehingga ambang TIDAK dapat dipertukarkan antarversi. Pada tekstur yang sangat halus (barisan rumput) N bersih adalah 0,075, jadi ambang berlaku per keluarga adegan. Estimator frekuensi tinggi yang kokoh (sigma-HH <= 1,5; bersih 0,74-1,19, noise tambahan s=2 menghasilkan 2,2-3,0) adalah gerbang tambahan yang direkomendasikan.

Cakupan: VideoTurko membahas SATU kali jalan saja (hingga 209 bingkai, sekitar 8,7 dtk). Uji perangkaian kami sendiri menunjukkan sambungan yang terlihat (adegan tidak berlanjut mulus), jadi film yang lebih panjang tidak termasuk yang kami verifikasi. Untuk merangkai ada panduan komunitas `docs/KLIP_ZINCIRI.md` dan alat bantu kami khusus CPU `scripts/zincir.py` (`plan`, `son-kare`, `bagla`; tidak pernah menjalankan mesin); kualitas film yang dirangkai tidak kami ukur [belum dicoba], jadi periksa setiap sambungan dengan mata dan dengan `scripts/dikis_denetim.py`.
Pengaturan adalah milik Anda: 209 frame adalah bawaan yang kami uji pada kartu 4 GB, bukan batas yang harus Anda pakai. Pilih jumlah frame mana pun pada kisi 17k+5 (56, 73, ... 192, 209; lihat `docs/KURULUM.md`), ubah prompt, seed, resolusi, atau flag apa pun sesuka Anda. Klip yang lebih pendek butuh lebih sedikit memori dan waktu; GPU yang lebih besar mungkin muat lebih banyak.

## Peringatan lisensi model
**VideoTurko hanya berisi patch dan skrip (MIT); siapa pun yang memakai model dan keluarannya bertanggung jawab sendiri atas lisensi MiniMax.** Bukan nasihat hukum. Berikut klausul MiniMax H3 Community License (2 Agustus 2026) diringkas beserta nomornya; lisensi itu sendiri yang mengikat: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

Lisensi MIT repositori ini tidak mencakup bobot model; lihat [`NOTICE`](NOTICE). Repo ini TIDAK berisi bobot model (tidak ada MiniMax H3, GGUF HyperFlow-H3-Flash, atau file VAE). Proyek ini tidak berafiliasi dengan atau didukung oleh MiniMax. Penggunaan komersial TIDAK dilarang (ini bukan lisensi non-komersial); syaratnya ada di bawah.

**Wilayah (Applicable Territory)**
- **Preamble, I.3, I.5:** Seluruh dunia, KECUALI Uni Eropa, Britania Raya, Republik Korea, dan Amerika Serikat. Memakai model berarti menerima lisensi.
- **II:** Lisensi bebas royalti, tidak dapat dipindahtangankan, terbatas untuk menggunakan, mereproduksi, mendistribusikan, membuat turunan, dan memodifikasi, hanya di dalam wilayah dan sesuai dengan perjanjian serta Exhibit A. Orang di wilayah yang dikecualikan dapat meminta lisensi terpisah dari MiniMax.
- **V.4:** Menggunakan, mereproduksi, memodifikasi, mendistribusikan, atau menampilkan model, turunannya, DAN KELUARANNYA (video/audio hasil generasi) di luar wilayah tidak diizinkan. **Jadi mempublikasikan atau menampilkan video hasil generasi di UE/Inggris/Korea Selatan/AS berada di luar lisensi.**
- **Exhibit A-1:** Penggunaan di luar wilayah melanggar Acceptable Use Policy.

**Distribusi (III)** (repo ini tidak mendistribusikan model; jika Anda yang melakukannya)
- **III.1:** Berikan salinan lisensi kepada setiap penerima. **III.2:** Tandai file yang dimodifikasi dengan pemberitahuan yang mencolok.
- **III.3:** Dianjurkan (tidak wajib): pemberitahuan "Powered by MiniMax H3", penanda hasil generasi AI pada file yang dihasilkan, artikel publik.
- **III.4:** Distribusi HARUS disertai file NOTICE berisi: "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12:** mempublikasikan konten ke lingkungan publik mana pun tanpa mengungkapkan dengan jelas bahwa konten itu dibuat mesin dilarang: beri label pada video hasil generasi AI saat Anda mempublikasikannya (daftar lengkap: `docs/LISANS_UYARISI.md`).
- **III (paragraf terakhir):** Anda boleh menambahkan hak cipta Anda sendiri pada modifikasi Anda, tetapi tidak boleh memberlakukan syarat tambahan atau berbeda atas penggunaan/distribusi; aturan wilayah tetap berlaku.

**Ketentuan komersial (IV)**
- **IV.1:** Jika produk/layanan komersial Anda menghasilkan pendapatan tahunan lebih dari USD 20 juta (atau setara), dapatkan otorisasi tertulis SEBELUMNYA dari api@minimax.io (subjek "MiniMax H3 licensing - authorization request").
- **IV.2:** Antarmuka produk/layanan komersial yang memakai model ini harus menampilkan "MiniMax H3" secara mencolok.

**Pembatasan penggunaan (V)**
- **V.1:** Patuhi hukum yang berlaku (termasuk kepatuhan perdagangan) dan Exhibit A. **V.2:** Ikat setiap orang yang Anda beri akses dengan ketentuan yang setidaknya sama melindunginya dengan pembatasan ini dan beri tahu mereka.
- **V.3:** Anda tidak boleh memakai model atau KELUARANNYA untuk meningkatkan model AI lain (selain MiniMax H3 dan turunannya). (I.11: distilasi dan pelatihan pada keluaran sintetis menjadikan sebuah model "turunan"; keluaran itu sendiri bukan turunan.)
- **V.5:** Jika Anda menawarkan kepada pihak ketiga produk/layanan/layanan hosting yang menghasilkan keluaran dengan model ini: sebelum dan selama operasi, pengamanan teknis dan organisasi yang wajar, mekanisme pelaporan, penyelidikan cepat, dan penghapusan/penonaktifan/penangguhan pelanggar berulang.

**Merek dagang dan hak (VI)**
- **VI.1:** Anda memiliki karya turunan dan turunan model yang Anda buat (tunduk pada hak MiniMax). **VI.2:** Nama/merek MiniMax tidak dilisensikan (di luar yang diperlukan untuk mendeskripsikan dan mendistribusikan); merek "MiniMax H3" hanya boleh dipakai untuk memenuhi III.3, di dalam wilayah; jangan menyiratkan afiliasi.
- **VI.3:** Jika Anda menggugat MiniMax atau siapa pun dengan menyatakan bahwa materi/keluaran melanggar hak Anda, semua lisensi Anda berakhir pada hari itu; Anda membela dan mengganti rugi MiniMax atas klaim pihak ketiga yang timbul dari penggunaan/distribusi oleh Anda atau orang lain.
- **VI.4:** MiniMax tidak mengklaim hak atas keluaran; Anda dan pengguna Anda bertanggung jawab atas keluaran dan penggunaannya.

**Penafian dan pengakhiran (VII, VIII, IX)**
- **VII.1:** Tidak ada kewajiban dukungan/pembaruan. **VII.2:** Model dan keluaran disediakan "AS IS", tanpa jaminan; Anda yang menentukan kesesuaian dan menanggung risikonya. **VII.3:** MiniMax dan afiliasinya tidak bertanggung jawab atas kerugian apa pun (sejauh diizinkan hukum).
- **VIII.1:** Berlaku sejak penerimaan/akses. **VIII.2:** Jika terjadi pelanggaran, MiniMax dapat mengakhiri; Anda wajib berhenti memakai/mendistribusikan, menghapus salinan, dan memberi tahu penerima (VI.1, VI.3, VII, IX tetap berlaku).
- **IX:** Hukum HKSAR Hong Kong; yurisdiksi eksklusif pengadilan Hong Kong (UN CISG dikecualikan).
- **Catatan tambahan:** encoder MiniMax H3 memakai Qwen3-VL-32B (Apache 2.0).

**Acceptable Use Policy (Exhibit A)** (JANGAN memakai model, turunan, atau keluaran untuk)
- A-1 penggunaan di luar wilayah; A-2 melanggar hukum atau HKI pihak ketiga; A-3 membahayakan diri sendiri atau orang lain; A-4 mengalihgunakan/mendistribusikan keluaran untuk merugikan; A-5 menghindari pengamanan; A-6 mengeksploitasi/membahayakan anak di bawah umur; A-7 informasi palsu yang dapat diverifikasi untuk merugikan orang lain atau memengaruhi pemilu; A-8 keterlibatan daring palsu (ulasan palsu dsb.); A-9 pencemaran nama baik, perendahan, pelecehan; A-10 malware; A-11 data pribadi untuk merugikan orang lain; **A-12 mempublikasikan konten ke lingkungan publik mana pun (termasuk unggahan bot) tanpa mengungkapkan secara jelas dan mencolok bahwa konten itu dibuat mesin**; A-13 peniruan identitas tanpa persetujuan; A-14 keputusan otomatis berisiko tinggi di bidang kritis (penegakan hukum, imigrasi, kesehatan, infrastruktur kritis, kredit, ketenagakerjaan, perumahan, pendidikan, penilaian sosial, asuransi, dsb.); A-15 melanggar standar sosial, etika, moral negara/wilayah lain; A-16 ekstremisme kekerasan/terorisme; A-17 diskriminasi/kerugian berdasarkan karakteristik yang dilindungi; A-18 mengeksploitasi kelompok rentan; **A-19 tujuan militer**; A-20 kegiatan profesional tanpa izin/lisensi (keuangan, hukum, medis, dsb.).
- Catatan: ini adalah ringkasan dalam bahasa sederhana; teks lisensi berbahasa Inggris yang berlaku jika ada keraguan.

## Label bukti

Satu set untuk semua dokumen (penulisan lama dalam tanda kurung):
- **[terukur]** (TR: ölçtüm, olctum): dijalankan di proyek ini, jalur bukti ada.
- **[dibaca]** (TR: okudum yol, okudum): sumber atau skrip dibaca, tidak dijalankan.
- **[rancangan]** (TR: tasarım, tasarim): dirancang, belum terlihat dalam run nyata.
- **[perkiraan]** (TR: tahmin): belum diverifikasi.
- **[belum dicoba]** (TR: denenmedi): belum pernah dijalankan.
- **[dilaporkan pengguna]** (TR: kullanıcı bildirdi): dinyatakan oleh pengguna, dengan tanggal; tidak diukur secara independen.
- **[dihitung]** (TR: hesap; penulisan lama: calculated, hesap): angka turunan dari masukan terukur, bukan hasil pengukuran itu sendiri; penurunannya ditulis di sebelahnya. [proposal] / [öneri] pada teks lama = [perkiraan].

Nama run yang dipakai dalam tanda kurung (nama run internal kami, bukan file di repo ini): U209 = 209 frame dengan binary rilis melalui `uret.ps1`; B209 dan B192 = run image-to-video (`-InitImg`) pada 209 dan 192 frame; B56VT2 = binary rilis, 56 frame, dibandingkan dengan referensi byte 56 frame R0; F209b, F209V2, F209V2K = run 209 frame pada build pengembangan (rincian: `docs/OLCUMLER.md`).

## Keterbatasan yang diketahui
- **Bukti byte** (cara mereproduksinya sendiri: `docs/KANITLAR.md`, "R0 ve latent referansi nasil uretilir"; diverifikasi pada kartu sm_61 kami, GPU lain mungkin tidak identik byte [perkiraan]): dengan seri patch kami (flag memori aktif) run 56 frame menghasilkan sha256 `0979f156d548169b...`, identik dengan referensi [terukur]; pada 141 frame sha256 latent `E5D028F8632BE4FE...` identik (dengan flag 0013/0014). Frame 158 sampai 209 tidak memiliki referensi byte langsung; rantai gerbang adalah buktinya. Lulus gerbang numerik tidak menjamin klip yang bagus: konsistensi gerak sepanjang waktu diperiksa dengan mata (lihat `docs/KAPILAR.md`).
- **209 frame, set flag yang mana:** bukti rantai byte 209 frame diambil dengan set flag F209V2 pada build pengembangan (tanpa flag block-tail, dibangun tanpa patch 0019/0020); `uret.ps1` memakai resep ini untuk 209 frame [dibaca: skripnya; run engine nyata melalui `uret.ps1` lulus pada run U209].
- Diverifikasi oleh kami pada satu kartu (GTX 1050 Ti 4 GB); laporan dari luar untuk kartu lain didaftar beserta labelnya di `docs/KART_PROFILLERI.md` [dilaporkan pengguna].
- **Binary mana yang diukur:** latent 141 frame dan rantai byte diukur dengan build pengembangan kami. Binary rilis yang Anda unduh adalah build baru: gerbang byte 56 frame-nya lulus (butir berikutnya) dan run 209 frame melalui `uret.ps1` lulus gerbang (run U209, 3414 dtk, puncak VRAM 3777 MiB) [terukur]; terhadap run 209 frame dengan build pengembangan, latent identik byte demi byte; pada video, frame (md5) dan audio identik, sha256 file AVI berbeda karena kontainer [terukur] (lihat `docs/OLCUMLER.md`, bagian 0).
- **Binary rilis, 56 frame:** binary rilis (sd-cli `c5cebe78...`, stable-diffusion.dll `e5d3d329...`) menghasilkan keluaran 56 frame identik byte dengan R0 (sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`; md5 per frame dan audio identik), dijalankan langsung dengan flag bawaan (tanpa variabel `SD_*`), exit code 0, 601 dtk [terukur: run B56VT2, 2026-11-19; bukti disimpan oleh penulis, tidak ada di repo ini]. Cakupan: hanya kartu sm_61 kami dan 56 frame; bukan uji instalasi clean-root; latent 141 frame dan rantai 209 diukur dengan binary yang lebih lama dan TIDAK diulang dengan binary ini [belum dicoba]. Percobaan pertama (B56VT, lewat skrip pembantu) berakhir tanpa suara setelah 58 dtk, penyebab tidak diketahui [perkiraan: tekanan memori]; percobaan kedua menjalankan `sd-cli` secara langsung.
- Skrip instalasi dan penggunaan belum diverifikasi dari folder kosong (uji clean-root tertunda).
- Peta jalan dan langkah berikutnya: `ROADMAP.md`.

## Status dan batasan
- Diverifikasi pada satu mesin (GTX 1050 Ti 4 GB, RAM 16 GB, i7-7700HQ). Kartu 4 GB lain dan ukuran RAM lain bisa berbeda.
- **Bawaan 209 frame (8,7 dtk):** lulus gerbang kualitas kami (noise 1,08, run F209V2K) [terukur: 209 frame dengan binary rilis melalui `uret.ps1`, run U209; latent identik byte demi byte dengan run dengan build pengembangan; frame dan audio pada video identik, sha file berbeda karena kontainer; bukti disimpan oleh penulis, tidak ada di repo ini]. Pada 209 frame puncak VRAM DiT adalah 3777 MiB dari 4096 MiB (run F209b dan U209; pembacaan `nvidia-smi` seluruh kartu), margin tipis: beban GPU lain (layar, aplikasi lain) bisa membuat proses gagal pada `blocks.0`; diuji hanya pada GTX 1050 Ti. Status layar selama proses itu tidak dicatat; jika layar Anda berjalan di kartu ini, VRAM yang tersedia lebih sedikit [perkiraan: beban layar Windows sekitar 100-300 MB]; bila perlu, sambungkan layar ke GPU terintegrasi [saran, belum diuji]. Sampling memakan 2730 dtk (run U209: langkah 436-483 dtk) dan dekode VAE proses terpisah 173 dtk (tahap 2 total 193 dtk bersama dekode audio) [terukur: U209 binary rilis; run pengembangan lama: 2664 dtk dan 174 dtk]. Pada tahap 1 VAE dalam proses kehabisan memori dan beralih ke temporal tiling (320 dtk); keluaran itu dibuang, video berasal dari tahap 2 tanpa tiling. Puncak RAM tidak diukur pada U209. Klip yang lebih panjang dari 209 frame bukan bagian dari rilis ini.
- **Image-to-video (`-InitImg`):** dengan gambar awal, batasnya 192 frame (8,0 dtk pada 24 fps) di GPU ini: 209 frame tidak muat (kurang sekitar 17,5 MB VRAM pada blok 0: butuh 2587 MB, tersedia 2570 MB); 192 frame berjalan melalui `uret.ps1` dalam 3086 dtk dengan puncak VRAM 3783 MiB dan gerbang lulus [terukur: run B209 dan B192, 2026-11-20, satu adegan; bukti disimpan oleh penulis, tidak ada di repo ini]. Belum dicoba pada GPU lain [belum dicoba].
- **RAM kosong itu penting:** Anda butuh sekitar 11 GB RAM KOSONG (proses engine memegang sekitar 11 GB) [terukur]. Dengan RAM kosong yang terlalu sedikit, proses bisa mati tanpa pesan galat [perkiraan: kami mengamatinya satu kali dengan sekitar 300 MB RAM kosong saat `sd-cli` memegang sekitar 10 GB]. Jangan membuka program besar lain saat proses berjalan: pada mesin 16 GB hanya sekitar 0,3-0,5 GB yang tersisa, dan di bawah tekanan memori proses bisa mati tanpa suara. Sebelum mulai, tutup browser, game, dan program besar lain, lalu periksa RAM yang kosong.
- **Uji clean-root tertunda:** skrip instalasi dan penggunaan belum diverifikasi dari folder kosong hanya dengan petunjuk ini; bagian ini akan diperbarui saat uji itu (termasuk perbandingan byte 56 frame dengan referensi) dicatat.
- Tidak ada video hasil generasi yang disertakan di sini.

<!-- i18n-source: README.md sha256:4d4973e30a37 -->
