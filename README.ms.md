# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · Bahasa Melayu

Terjemahan mengikuti README bahasa Inggeris ini. Jika terjemahan berbeza atau ketinggalan, teks bahasa Inggeris yang terpakai, terutamanya untuk teks lesen dan keselamatan ([`SECURITY.md`](SECURITY.md) dan [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) hanya disimpan dalam bahasa Inggeris dan Turki).

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **Sebelum bermula (lesen, wilayah):** repositori ini berlesen MIT dan hanya mengandungi patch dan skrip. Model MiniMax H3 yang dimuat turunnya tertakluk kepada MiniMax H3 Community License: wilayahnya tidak termasuk Kesatuan Eropah, United Kingdom, Korea Selatan dan Amerika Syarikat, dan model, terbitan **serta output (video yang anda jana)** tidak boleh digunakan, diedarkan atau dipaparkan di sana (V.4). Penggunaan komersial dibenarkan dalam had syarat lesen. Baca [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) sebelum memasang; ini bukan nasihat undang-undang.

> **Dalam 30 saat:** kad grafik 4 GB boleh menghasilkan video MiniMax H3 sepanjang 209 bingkai (8.7 saat) dalam satu laluan: disahkan pada satu mesin (GTX 1050 Ti 4 GB; pemasangan penuh `kur.ps1` pada folder kosong belum disahkan dari awal hingga akhir) [diukur: 209 bingkai dengan binari keluaran melalui `uret.ps1`, larian U209; latent sama bait demi bait dengan larian binaan pembangunan; bingkai dan audio dalam video sama, sha fail berbeza kerana bekas (container); bukti disimpan oleh penulis, tiada dalam repositori ini]; dengan `-InitImg` (imej ke video) paling banyak 192 bingkai (8.0 saat) [diukur: larian B192]; 209 bingkai mengambil masa kira-kira 57 minit, had masa lalai 80 minit [diukur: larian U209]; 3 langkah di bawah ialah cara menjalankannya.

> **Menggunakan ejen pengekodan AI (Codex, Claude Code, Gemini, Cursor)?** Berikan satu ayat ini kepadanya: “Baca `AGENTS_HIZLI.md` hingga habis, jalankan `scripts\tani.ps1` dahulu, simpan kemajuan anda dalam `DURUM.md`, dan tanya saya sebelum memadam atau memindahkan apa-apa, menukar Python sistem atau PATH, menurunkan sebarang tetapan kualiti, atau menerima lesen model bagi pihak saya.” Ejen akan mendiagnosis PC ini, menulis senarai semak dan bertanya kepada anda pada setiap keputusan; lesen model kekal sebagai keputusan anda.

VideoTurko: tampalan memori stable-diffusion.cpp beserta resipi untuk menjalankan MiniMax H3 text-to-video pada GTX 1050 Ti 4 GB, sehingga 209 bingkai (8.7 saat) dalam satu laluan; image-to-video (`-InitImg`) sehingga 192 bingkai (8.0 saat) (209 bingkai disahkan dengan rantai bait; sama bait dengan larian tanpa tampalan pada semakan 56 dan 141 bingkai).

## Mula pantas (Windows, 3 langkah)
**Status: skrip pemasangan/penggunaan di bawah masih disiapkan dan ujian clean-root belum dibuat; tiada apa-apa di sini didakwa berfungsi sehingga ujian itu lulus (lihat "Status dan had").**

1. **Muat turun** repositori ini (butang hijau **Code**, kemudian **Download ZIP**) dan ekstrak ke folder PENDEK, contohnya `C:\vt`.
2. **Pasang: klik dua kali `kur.cmd`** (tetingkap hitam dibuka dan menunjukkan setiap langkah; menutupnya menghentikan pemasangan, dan menjalankannya semula menyambung dari tempat ia berhenti: fail model yang dimuat turun separuh disambung semula [dibaca: skrip muat turun menyimpan fail `.part` dan menyambung daripadanya; sambungan penuh 29 GiB belum diukur]). Jika Windows memberi amaran tentang fail yang dimuat turun, gunakan arahan PowerShell di bawah sebagai ganti [nasihat, belum diuji pada ZIP yang dimuat turun]. Lebih suka baris arahan? Buka PowerShell dalam folder itu (taip `powershell` pada bar alamat Explorer) dan jalankan pemasangan yang sama:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   Akar pemasangan ialah folder yang anda ekstrak (enjin masuk ke `engine\bin`, model ke `model`); untuk menggunakan tempat lain, tetapkan pemboleh ubah persekitaran `VT_ROOT` terlebih dahulu. Skrip menyemak GPU, pemacu, RAM dan cakera, mengambil enjin dan model (zip enjin dan fail model yang baru dimuat turun disemak sha256; fail model yang sudah ada dengan saiz yang betul hanya disemak saiznya, `scripts\modelleri_indir.ps1 -Dogrula` menjalankan semakan sha256 penuh), menjalankan semakan sebenar yang ringkas, dan mencetak READY hanya jika semakan itu lulus [reka bentuk: `kur.ps1` belum pernah dijalankan sepenuhnya dalam folder bersih; ayat ini dikemas kini selepas ujian folder bersih]. `-ExecutionPolicy Bypass` hanya terpakai pada proses ini; baca `scripts\kur.ps1` dahulu, seperti pada mana-mana pemasang.
   Zip enjin diambil daripada keluaran GitHub v0.1.0 (diterbitkan pada 2026-11-19; sha256 baginya ditetapkan dalam `kur.ps1`). Jika di luar talian atau menggunakan binaan anda sendiri, berikan zip tempatan: `-MotorZip <path> -CudaZip <path>`. Zip tempatan juga disemak dengan sha256 tetap yang sama (fail `.sha256` di sebelahnya diabaikan), jadi ia mesti zip keluaran; untuk binaan anda sendiri, tetapkan dahulu `VT_MOTOR_SHA256` / `VT_CUDA_SHA256` kepada sha256 binaan itu. sha256 yang salah menghentikan proses dengan exit 1. Hanya `.exe`/`.dll` masuk ke `engine\bin`; lesen dan README masuk ke `engine\lisanslar\<zip name>\`. [dicuba dengan zip dist sebelum keluaran: `.sha256` sisian beserta amaran rujukan-sendiri, binari dan DLL diletakkan, `sd-cli --help` berjalan; sha binari yang dipasang sepadan (`c5cebe78...`, `e5d3d329...`); langkah model dan semakan 5 bingkai `kur.ps1` BELUM dijalankan pada GPU sebenar]
   **Lesen model:** sebelum langkah model, pemasang mencetak ringkasan lesen (`docs/LISANS_KABUL.txt`, teks penuh `docs/LISANS_UYARISI.md`: MiniMax H3 Community License, had wilayah yang turut meliputi video yang dijana, peraturan komersial dan label AI) dan meminta anda menerimanya (`E` = ya). Bacalah dahulu. Untuk larian tanpa pengawasan anda boleh memberikan `-LisansKabul E`, yang bermaksud anda sendiri telah membaca dan menerimanya; jangan tambahkannya bagi pihak orang lain. (Ejen AI: ikut `AGENTS.md`; jangan sekali-kali menaip E tanpa persetujuan pengguna.) Tanpa persetujuan, `kur.ps1` berhenti dengan kod keluar 2 dan tidak memuat turun sebarang model.
3. **Video pertama anda (56 bingkai, kira-kira 11 min pada GTX 1050 Ti kami** [diukur: 641 s, larian R0, `docs/OLCUMLER.md`; kad lain tidak diukur]**)**: apabila pemasang mencetak `HAZIR / READY`, jalankan
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (jalan pintas: seret fail teks prompt ke atas `uret.cmd`, atau jalankan `uret.cmd docs\ornek_istem_R0.txt`: larian 56 bingkai yang sama). Video berada dalam `runs\`. Kemudian tulis prompt anda sendiri dalam fail teks (satu perenggan bahasa Inggeris, ayat `audio:` pilihan) dan jalankan klip terpanjang yang kami liputi (lalai, kira-kira 57 min [diukur: larian U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   `-Kare` mengikut grid 17k+5 (56, 73, ... 192, 209); lalai 209 (8.7 saat), panjang terpanjang yang kami liputi. VAE berjalan dalam proses berasingan, tidak pernah dipecahkan kepada jubin (tiling) [larian enjin sebenar melalui `uret.ps1` dengan binari keluaran, VAE proses berasingan, lulus dalam larian U209].

   Panduan menulis prompt: [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (corak satu syot berterusan, kepingan masa yang sama panjang, dua contoh lengkap).

| Keperluan | Nilai |
|---|---|
| OS | Windows 10/11, 64-bit |
| GPU | NVIDIA, 4 GB atau lebih; diuji hanya pada GTX 1050 Ti (sm_61); margin nipis (3777/4096 MiB pada 209 bingkai): skrin atau pelayar yang sibuk boleh menggagalkan larian; tiada kad 4 GB lain dicuba |
| RAM | 16 GB (puncak sekitar 11 GB; tutup program lain) |
| Cakera | sekurang-kurangnya 32 GiB kosong (40 GiB atau lebih disyorkan: antara 32 dan 40 pemasang mencetak amaran, `[VT-W-DISK-PAY]` [diukur: larian `-Kuru` dengan cakera simulasi]), model pada SSD (NVMe lebih baik) |
| Muat turun | zip enjin 36.8 MB + zip runtime CUDA 567.5 MB [diukur] + model 31,473,112,040 bait (kira-kira 29.3 GiB) [dibaca: saiz dalam `scripts/modeller.json`]; kira-kira 30 GiB kesemuanya |
| Model | tidak disertakan; diambil oleh pemasang di bawah lesen MiniMax (lihat amaran di bawah). Model (29.3 GiB, 31,473,112,040 bait dalam `scripts/modeller.json`) tidak terdapat dalam repositori atau keluaran ini: had saiz fail/keluaran GitHub terpakai, dan `kur.ps1` memuat turunnya daripada sumber rasmi dengan pengesahan sha256. |

Kod keluar `kur.ps1`: 0 READY, 1 ralat, 2 input pengguna diperlukan (lesen, atau belum ada keluaran/zip), 3 perkakasan atau cakera tidak mencukupi, 4 dihentikan (fail DUR). `uret.ps1` hanya menerima larian jika fail `.avi` wujud, bilangan bingkai betul dan log bersih [diukur: satu larian sebenar melalui `uret.ps1` pada binari keluaran, larian U209, 209 bingkai, pintu lulus]. Kod keluar `uret.ps1`: 0 DONE (pintu kualiti lulus), 1 ralat atau output tidak sah (termasuk video tanpa aliran audio), 2 dihentikan (fail DUR), 5 `KAPI RED` (pintu kualiti gagal: klip tidak diterima, keputusan di tangan anda), 6 pintu tidak dapat dijalankan (klip tidak diterima). Butiran dalam AGENTS.md. [diukur: kod keluar 0, 1 (video senyap), 5 dan 6 dalam senario dengan enjin palsu dan pintu palsu; enjin sebenar: exit 0 dalam larian U209]

### Penyelesaian masalah (butiran: `docs/SIK_HATALAR.md`)
Baris ralat skrip kami membawa kod tetap, contohnya `HATA: [VT-E-DLL] ...` atau `UYARI: [VT-W-DISK-PAY] ...`. Cari kod itu dalam [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) (contoh sauh `#vt-e-dll`) atau dalam `docs/hata_imzalari.json`, dan tulis kod itu dalam issue anda. Lajur pertama jadual di bawah kekal seperti yang dicetak (jangan terjemah kod dan teks log).

| Apa yang anda lihat | Maksudnya, dan apa yang perlu dibuat |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | Jangan mulakan `sd-cli.exe` secara manual; jalankan `scripts\kur.ps1`, yang meletakkan DLL CUDA pada tempatnya. |
| `failed during weight preparation` pada `blocks.0` (#1, #3, #5) | VRAM tidak mencukupi pada pintu memori: gunakan bilangan bingkai yang lebih kecil pada grid 17k+5, tutup program GPU lain, kekalkan bendera yang disertakan. |
| `retrying with temporal tiling` (#6) | VAE jatuh kepada tiling; output tidak sah untuk tujuan kualiti. Jalankan semula. |
| Larian tamat pada had masa, tiada video (#7) | Naikkan `-TavanDk` untuk klip panjang (had masa lalai: 80 minit untuk 209 bingkai, ditetapkan oleh `uret.ps1`; larian 209 bingkai kami mengambil 57 minit [diukur: larian U209]). |
| Kod keluar kosong tetapi "finished" (#14) | Pembungkus (wrapper) membaca kod keluar terlalu awal; jalankan semula, dan semak bahawa fail video wujud. |
| Sistem menjadi perlahan, swapping (#18) | Enjin menggunakan kira-kira 10-11 GB RAM; tutup pelayar dan program lain. |
| sha256 tidak sepadan / muat turun gagal | Biasanya muat turun terganggu: jalankan arahan yang sama sekali lagi, fail yang telah disahkan dilangkau. |

**Tersekat atau ingin tahu?** [`SUPPORT.md`](SUPPORT.md) (tempat bertanya; masa balasan ialah sasaran, bukan komitmen) · [`PRIVACY.md`](PRIVACY.md) (tiada telemetri; rangkaian hanya digunakan untuk memuat turun enjin dan model, daripada hos yang disenaraikan) · [`SECURITY.md`](SECURITY.md) (laporan peribadi) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (pull request pertama dalam 5 langkah; GPU tidak diperlukan untuk dokumen dan skrip).

### Baharu dalam v0.1.1: lebih banyak pilihan (butiran: `AGENTS.md`, `docs/SIK_HATALAR.md` 19-23)
Tanpa pilihan ini, tiada apa-apa yang berubah pada kad 4 GB (semakan bait 56 bingkai terhadap rujukan kami lulus semula dengan v0.1.1 [diukur]). Tambahkan `-Kuru` pada mana-mana arahan untuk melihat apa yang akan dijalankan.
- `-EndImg`: berikan juga bingkai terakhir (bingkai pertama dan terakhir, "FLF"); had 175 bingkai pada kad di bawah 8 GB (192 tidak muat pada 4 GB), 192 pada kad 8 GB ke atas. Pada GTX 1050 Ti kami ia sentiasa berjalan dalam dua proses: 56 bingkai 1040 saat, 175 bingkai 2887 saat (48 minit), kedua-duanya lulus pintu [diukur]. Petua menulis prompt: `docs/ISTEM_YAZIMI.md`.
- `-W` / `-H`: saiz lain, contohnya menegak 384x640; gandaan 32, keluasan sekurang-kurangnya 640x384 (tidak pernah lebih kecil). Belum diuji pada 4 GB; pada kad di bawah 8 GB, saiz yang melebihi kerja terbesar yang telah kami ukur ditolak. Ambang pintu kualiti ditentukur pada 640x384.
- `-TekAsama`: satu proses dan bukannya dua, untuk kad besar sahaja; tidak pernah dihidupkan secara automatik.
- GPU yang lebih baharu (compute capability 7.0+, contohnya RTX 20/30/40): `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` ditetapkan secara automatik melainkan anda menetapkannya sendiri; ini membetulkan video hitam sepenuhnya pada 141+ bingkai pada RTX 4070 Ti milik pelapor [dilaporkan pengguna, issue #1]. Tanpa Python + OpenCV, `uret.ps1` kini berhenti dengan exit 6 sebelum kerja GPU (tiada video dihasilkan, tiada RED yang mengelirukan).
- Terima kasih kepada @SinanC73 atas laporan RTX 4070 Ti yang membawa kepada perubahan ini ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1)).

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

## Profil kelajuan pilihan (pek kelajuan; dimatikan secara lalai)
Tiada satu pun di bawah mengubah larian lalai (640x384, 209 bingkai, 3414 s pada kad kami). Ini tiga sel terukur di luarnya, masing-masing profil bernama bagi `uret.ps1`; semuanya memerlukan enjin pek kelajuan (enjin keluaran ditambah tampalan 0021, 0023, 0024, semuanya dimatikan secara lalai: `docs/YAMALAR.md`). Pasang dengan `scripts\kur.ps1 -HizPaketi` (zip tempatan berfungsi dengan `-MotorZip`), kemudian tambah `-Profil <name>`; `-Kuru` memaparkan apa yang akan dijalankan. Pakej kelajuan diterbitkan bersama keluaran v0.1.4.

| Profil | Saiz, panjang | Jumlah masa pada GTX 1050 Ti 4 GB | Status |
|---|---|---|---|
| (tiada, lalai) | 640x384, sehingga 209 bingkai (8.7 s) | 209 bingkai: 3414 s | disahkan, tidak berubah |
| `yuksek832` | 832x480, 141 bingkai (5.9 s) | kira-kira 55-56 min | boleh digunakan, dua prompt [diukur] |
| `yuksek832 -Kare 124` | 832x480, 124 bingkai (5.2 s) | kira-kira 45-46 min, tanpa bendera kelajuan | boleh digunakan, dua prompt [diukur] |
| `yuksek896` | 896x512, 124 bingkai (5.2 s) | kira-kira 56-57.5 min | boleh digunakan, dua prompt [diukur] |
| `uzun260` | 640x384, 260 bingkai (10.8 s) | 78 min diukur tanpa keluar awal; dengan keluar awal kira-kira 71-72 min [anggaran: tidak diukur hujung ke hujung melalui `uret.ps1`] | bersyarat dan eksperimen |

- **Margin sempit:** pada 832x480 x 141 pintu memori hanya meninggalkan ruang satu digit MB (5.7 dan 6.8 MB dalam dua larian penuh). Dua prompt panjang (1520 dan 2041 aksara) hanya disemak dengan membaca pintu bagi langkah 1 dan sebahagian langkah 2, tidak dijalankan sepenuhnya: ruang 10.9 dan 4.0 MB. Mana-mana proses lain yang memegang memori kad (pelayar, skrin kedua) boleh menyebabkannya gagal; jika begitu gunakan `-Kare 124` atau saiz lalai [diukur, GTX 1050 Ti 4 GB].
- **`uzun260` bersyarat:** had memori sangat sempit (puncak VRAM 3903 daripada 4096 MiB), penggunaan memori kongsi meningkat 45 dan 61 MiB (had 68), dan tiada rujukan tanpa bendera untuk kesamaan bait, jadi ia tidak ditawarkan sebagai ciri biasa. Tampalan 0023 diterima untuk sel ini sahaja.
- **Tidak ditawarkan:** 832x480 pada 158 bingkai tidak muat dengan tampalan yang disertakan (di get langkah 2 kekurangan kira-kira 280 MB); 175 bingkai hanya diperiksa melalui bacaan get (blok pertama kekurangan kira-kira 275 MB, tiada larian penuh). Profil hanya menawarkan 141 bingkai. Saiz dan bilangan bingkai lain ditolak oleh `-Profil` (gunakan laluan lalai).
- Kualiti lalai tidak disentuh: 6 langkah, cfg 1, VAE tanpa jubin, 17k+5 bingkai. Di mana bendera dihidupkan, output dibandingkan bait demi bait dengan video tanpa bendera pada saiz yang muat untuk larian tanpa bendera (`docs/YAMALAR.md`); pada 832x480 x 141 dan 896x512 x 124 larian tanpa bendera tidak muat, jadi kesamaan di sana bergantung pada sel terdekat, bukan perbandingan langsung [diukur, dibaca].
- Peringkat 1 larian dua peringkat kini tamat sebaik sahaja fail laten lengkap (`VT_ERKEN_CIKIS=0` mematikannya).

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

## Apakah ini
Satu set tampalan kecil memori/penjadualan untuk stable-diffusion.cpp beserta resipi larian, semakan dan pengukuran yang membolehkan MiniMax H3 (DiT 33B; kami menjalankan GGUF HyperFlow Flash 13.7B Q4_K_M; pengekod teks Qwen3-VL 32B adalah berasingan) berjalan pada GPU Pascal 4 GB (GTX 1050 Ti, RAM sistem 16 GB).
- Panjang satu-laluan yang benar-benar kami hasilkan dan lulus pintu kualiti kami: 56, 141, 158, 175, 192, 209 bingkai pada 640x384, 24 fps (209 bingkai = 8.7 saat), dengan audio yang dijana oleh H3 sendiri [diukur: 209 bingkai dengan binari keluaran melalui `uret.ps1`, larian U209; latent sama bait demi bait dengan larian binaan pembangunan; bingkai dan audio dalam video sama, sha fail berbeza kerana bekas (container); bukti disimpan oleh penulis, tiada dalam repositori ini]. 209 ialah panjang terpanjang yang kami tonton dan dapati lancar [dilaporkan pengguna, 2026-11-19, video ditonton sepenuhnya; fail: output F209V2, 8.708 saat].
- **Dakwaan sama-bait, dengan skop yang jujur:** output disemak sama bait dengan rujukan tanpa tampalan hanya untuk 56 dan 141 bingkai. Untuk 158/175/192/209 bingkai kami menggunakan bendera yang sama dan rantai binari yang sama; tiada rujukan bait langsung (binaan tanpa tampalan tidak dapat menjalankan panjang itu pada GPU ini).
- Tetapan kualiti tidak pernah diturunkan: model/pengkuantuman yang sama, 6 langkah, cfg 1, 640x384, seed yang sama, VAE tanpa tiling.
- Kami tidak mendakwa sebagai yang pertama: kami mencari dan tidak menemui contoh luaran untuk ini pada 4 GB, tetapi itu bukan bukti bahawa tiada yang wujud.

## Susun atur
- `patches/` tampalan terhadap commit stable-diffusion.cpp yang dikunci (lihat nota di situ)
- `scripts/` skrip binaan, larian, VAE proses berasingan, pembantu pintu/konsistensi (`doku_norm.py`: lihat nota skala di bawah)
- `docs/KURULUM.md` perkakasan, langkah binaan dan larian (EN+TR)
- `docs/YAMALAR.md` senarai tampalan, `docs/KANITLAR.md` bukti, `docs/KAPILAR.md` jadual pintu kualiti, `docs/OLCUMLER.md` pengukuran, `docs/SIK_HATALAR.md` kesilapan lazim, `docs/LISANS_UYARISI.md` semua butiran lesen
- `scripts/` indeks ringkas: `hiz_kos3.ps1` pembungkus larian (`-Kuru` mencetak arahan yang tepat), `uretim_kapi.ps1` pintu kualiti, `dikis_denetim.py` semakan sambungan, `doku_norm.py` hingar ternormal tekstur, `bayt_kiyas.py` perbandingan bait, `derleme_sablonu.ps1` templat binaan (hanya menghentikan pembantu telemetri Visual Studio `vctip.exe` yang bermula selepas binaannya sendiri bermula, yang jika tidak akan menahan proses binaan selama beberapa minit; proses `vctip.exe` yang lain dibiarkan)

## Pintu kualiti (cara hasil diterima)

Pintu ini tidak menyemak konsistensi gerakan (lonjakan skala atau kedudukan objek): tonton keseluruhan video sebelum menerimanya.
1. Bilangan bingkai dan audio wujud; tiada fallback memori atau baris ALLOC_FAILED dalam log.
2. Pintu hingar mentah: baki median-filter <= 1.5 (skala 0-255).
3. Hingar ternormal tekstur, `scripts/doku_norm.py` (versi repositori ini): N = baki median / tekstur Sobel, setiap bingkai ke-6. **Nota skala:** dalam versi ini 10 klip yang diukur memberikan N = 0.034-0.052 (jadual dalam `docs/KAPILAR.md`; suku terakhir F192/F209V2 mencapai 0.062) dan ambang pintu tambahan ialah N <= 0.065. Pelaksanaan lain mengukur 0.028-0.036 pada klip yang sama, jadi ambang TIDAK boleh ditukar ganti antara versi. Pada tekstur yang sangat halus (barisan rumput) N bersih ialah 0.075, jadi ambang adalah mengikut keluarga babak. Penganggar frekuensi tinggi yang teguh (sigma-HH <= 1.5; bersih 0.74-1.19, hingar tambahan s=2 memberikan 2.2-3.0) ialah pintu tambahan yang disyorkan.

Skop: VideoTurko adalah tentang SATU laluan sahaja (sehingga 209 bingkai, kira-kira 8,7 saat). Ujian perantaian kami sendiri menunjukkan cantuman yang kelihatan (adegan tidak bersambung dengan bersih), jadi filem yang lebih panjang bukan sebahagian daripada apa yang kami sahkan. Untuk merantai ada panduan komuniti `docs/KLIP_ZINCIRI.md` dan alat bantu kami yang hanya guna CPU `scripts/zincir.py` (`plan`, `son-kare`, `bagla`; ia tidak pernah memulakan enjin); kualiti filem yang dirantai tidak kami ukur [belum dicuba], jadi periksa setiap cantuman dengan mata dan dengan `scripts/dikis_denetim.py`.
Tetapan anda ialah milik anda: 209 bingkai ialah lalai yang kami uji pada kad 4 GB, bukan had yang mesti anda gunakan. Pilih mana-mana bilangan bingkai pada grid 17k+5 (56, 73, ... 192, 209; lihat `docs/KURULUM.md`), tukar prompt, seed, resolusi atau mana-mana bendera mengikut kehendak anda. Klip yang lebih pendek memerlukan lebih sedikit memori dan masa; GPU yang lebih besar mungkin memuatkan lebih banyak.

## Amaran lesen model
**VideoTurko hanya mengandungi tampalan dan skrip (MIT); sesiapa yang menggunakan model dan outputnya bertanggungjawab sendiri terhadap lesen MiniMax.** Bukan nasihat undang-undang. Di bawah ialah klausa MiniMax H3 Community License (2 Ogos 2026) yang diringkaskan beserta nombornya; lesen itu sendiri yang mengikat: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

Lesen MIT repositori ini tidak meliputi pemberat model; lihat [`NOTICE`](NOTICE). Repositori ini TIDAK mengandungi berat model (tiada MiniMax H3, GGUF HyperFlow-H3-Flash atau fail VAE). Projek ini tidak berafiliasi dengan atau disokong oleh MiniMax. Penggunaan komersial TIDAK dilarang (ini bukan lesen bukan-komersial); syaratnya ada di bawah.

**Wilayah (Applicable Territory)**
- **Preamble, I.3, I.5:** Seluruh dunia, KECUALI Kesatuan Eropah, United Kingdom, Republik Korea dan Amerika Syarikat. Menggunakan model dikira sebagai menerima lesen.
- **II:** Lesen bebas royalti, tidak boleh dipindah milik, terhad untuk menggunakan, menghasilkan semula, mengedar, mencipta terbitan dan mengubah suai, hanya di dalam wilayah dan mematuhi perjanjian serta Exhibit A. Orang di wilayah yang dikecualikan boleh memohon lesen berasingan daripada MiniMax.
- **V.4:** Menggunakan, menghasilkan semula, mengubah suai, mengedar atau memaparkan model, terbitannya DAN OUTPUTNYA (video/audio yang dijana) di luar wilayah tidak dibenarkan. **Jadi menerbitkan atau mempamerkan video yang dijana di EU/UK/Korea Selatan/AS adalah di luar lesen.**
- **Exhibit A-1:** Penggunaan di luar wilayah melanggar Acceptable Use Policy.

**Pengedaran (III)** (repositori ini tidak mengedar model; jika anda yang mengedarnya)
- **III.1:** Berikan setiap penerima satu salinan lesen. **III.2:** Tandakan fail yang diubah suai dengan notis yang jelas.
- **III.3:** Digalakkan (tidak wajib): notis "Powered by MiniMax H3", pengecam penjanaan AI pada fail yang dihasilkan, penulisan awam.
- **III.4:** Pengedaran MESTI disertakan dengan fail NOTICE yang mengandungi: "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12:** menerbitkan kandungan ke mana-mana persekitaran awam tanpa mendedahkan dengan jelas bahawa ia dijana mesin adalah dilarang: labelkan video yang dijana AI apabila anda menerbitkannya (senarai penuh: `docs/LISANS_UYARISI.md`).
- **III (perenggan terakhir):** Anda boleh menambah hak cipta anda sendiri pada pengubahsuaian anda tetapi tidak boleh mengenakan terma tambahan atau berbeza ke atas penggunaan/pengedaran; peraturan wilayah tetap terpakai.

**Terma komersial (IV)**
- **IV.1:** Jika produk/perkhidmatan komersial anda menjana pendapatan tahunan melebihi USD 20 juta (atau setara), dapatkan kebenaran bertulis TERLEBIH DAHULU daripada api@minimax.io (subjek "MiniMax H3 licensing - authorization request").
- **IV.2:** Antara muka produk/perkhidmatan komersial yang menggunakan model ini mesti memaparkan "MiniMax H3" dengan jelas.

**Sekatan penggunaan (V)**
- **V.1:** Patuhi undang-undang yang terpakai (termasuk pematuhan perdagangan) dan Exhibit A. **V.2:** Ikat sesiapa yang anda beri akses dengan terma yang sekurang-kurangnya sama melindungi seperti sekatan ini dan maklumkan kepada mereka.
- **V.3:** Anda tidak boleh menggunakan model atau OUTPUTNYA untuk menambah baik mana-mana model AI lain (selain MiniMax H3 dan terbitannya). (I.11: penyulingan (distillation) dan latihan pada output sintetik menjadikan sesuatu model sebagai "terbitan"; output itu sendiri bukan terbitan.)
- **V.5:** Jika anda menawarkan kepada pihak ketiga produk/perkhidmatan/perkhidmatan terhos yang menjana output dengan model ini: sebelum dan sepanjang operasi, perlindungan teknikal dan organisasi yang munasabah, mekanisme pelaporan, siasatan segera, dan pengeluaran/penyahaktifan/penggantungan pelanggar berulang.

**Cap dagangan dan hak (VI)**
- **VI.1:** Anda memiliki karya terbitan dan terbitan model yang anda cipta (tertakluk kepada hak MiniMax). **VI.2:** Nama/cap MiniMax tidak dilesenkan (selain yang diperlukan untuk menerangkan dan mengedar); cap "MiniMax H3" hanya boleh digunakan untuk mematuhi III.3, di dalam wilayah; jangan membayangkan gabungan.
- **VI.3:** Jika anda menyaman MiniMax atau sesiapa dengan mendakwa bahan/output melanggar hak anda, semua lesen anda tamat pada hari itu; anda mempertahankan dan menanggung rugi MiniMax terhadap tuntutan pihak ketiga yang timbul daripada penggunaan/pengedaran oleh anda atau orang lain.
- **VI.4:** MiniMax tidak menuntut hak ke atas output; anda dan pengguna anda bertanggungjawab ke atas output dan penggunaannya.

**Penafian dan penamatan (VII, VIII, IX)**
- **VII.1:** Tiada kewajipan sokongan/kemas kini. **VII.2:** Model dan output disediakan "AS IS", tanpa waranti; anda menentukan kesesuaian dan menanggung risikonya. **VII.3:** MiniMax dan sekutunya tidak bertanggungjawab atas sebarang kerugian (setakat yang dibenarkan undang-undang).
- **VIII.1:** Berkuat kuasa apabila diterima/diakses. **VIII.2:** Jika berlaku pelanggaran, MiniMax boleh menamatkan; anda mesti berhenti menggunakan/mengedar, memadam salinan dan memaklumkan penerima (VI.1, VI.3, VII, IX kekal berkuat kuasa).
- **IX:** Undang-undang HKSAR Hong Kong; bidang kuasa eksklusif mahkamah Hong Kong (UN CISG dikecualikan).
- **Nota tambahan:** pengekod MiniMax H3 menggunakan Qwen3-VL-32B (Apache 2.0).

**Acceptable Use Policy (Exhibit A)** (JANGAN gunakan model, terbitan atau output untuk)
- A-1 penggunaan di luar wilayah; A-2 melanggar undang-undang atau harta intelek pihak ketiga; A-3 mencederakan diri sendiri atau orang lain; A-4 menggunakan semula/mengedar output untuk mencederakan; A-5 memintas perlindungan; A-6 mengeksploitasi/mencederakan kanak-kanak; A-7 maklumat palsu yang boleh disahkan untuk mencederakan orang lain atau mempengaruhi pilihan raya; A-8 penglibatan dalam talian palsu (ulasan palsu dsb.); A-9 fitnah, penghinaan, gangguan; A-10 perisian hasad (malware); A-11 data peribadi untuk mencederakan orang lain; **A-12 menerbitkan kandungan ke mana-mana persekitaran awam (termasuk siaran bot) tanpa mendedahkan dengan jelas dan ketara bahawa ia dijana mesin**; A-13 penyamaran tanpa persetujuan; A-14 keputusan automatik berisiko tinggi dalam bidang kritikal (penguatkuasaan undang-undang, imigresen, kesihatan, infrastruktur kritikal, kredit, pekerjaan, perumahan, pendidikan, pemarkahan sosial, insurans, dsb.); A-15 melanggar piawaian sosial, etika, moral negara/wilayah lain; A-16 ekstremisme ganas/keganasan; A-17 diskriminasi/kemudaratan berdasarkan ciri yang dilindungi; A-18 mengeksploitasi kumpulan yang terdedah; **A-19 tujuan ketenteraan**; A-20 aktiviti profesional tanpa kebenaran/lesen (kewangan, undang-undang, perubatan, dsb.).
- Nota: ini ialah ringkasan dalam bahasa mudah; teks lesen bahasa Inggeris diutamakan jika ada keraguan.

## Label bukti

Satu set untuk semua dokumen (ejaan lama dalam kurungan):
- **[diukur]** (TR: ölçtüm, olctum): dijalankan dalam projek ini, laluan bukti wujud.
- **[dibaca]** (TR: okudum yol, okudum): sumber atau skrip dibaca, tidak dijalankan.
- **[reka bentuk]** (TR: tasarım, tasarim): direka, belum dilihat dalam larian sebenar.
- **[anggaran]** (TR: tahmin): belum disahkan.
- **[belum dicuba]** (TR: denenmedi): tidak pernah dijalankan.
- **[dilaporkan pengguna]** (TR: kullanıcı bildirdi): dinyatakan oleh pengguna, dengan tarikh; tidak diukur secara bebas.
- **[dikira]** (TR: hesap; ejaan lama: calculated, hesap): nombor yang diperoleh daripada input yang diukur, bukan diukur sendiri; terbitannya ditulis di sebelahnya. [proposal] / [öneri] dalam teks lama = [anggaran].

Nama larian yang digunakan dalam kurungan (nama larian dalaman kami, bukan fail dalam repositori ini): U209 = 209 bingkai dengan binari keluaran melalui `uret.ps1`; B209 dan B192 = larian image-to-video (`-InitImg`) pada 209 dan 192 bingkai; B56VT2 = binari keluaran, 56 bingkai, dibandingkan dengan rujukan bait 56 bingkai R0; F209b, F209V2, F209V2K = larian 209 bingkai pada binaan pembangunan (butiran: `docs/OLCUMLER.md`).

## Had yang diketahui
- **Bukti bait** (cara menghasilkannya sendiri: `docs/KANITLAR.md`, "R0 ve latent referansi nasil uretilir"; disahkan pada kad sm_61 kami, GPU lain mungkin tidak sama bait [anggaran]): dengan siri tampalan kami (bendera memori dihidupkan) satu larian 56 bingkai memberikan sha256 `0979f156d548169b...`, sama dengan rujukan [diukur]; pada 141 bingkai sha256 latent `E5D028F8632BE4FE...` sama (dengan bendera 0013/0014). Bingkai 158 hingga 209 tiada rujukan bait langsung; rantai pintu ialah buktinya. Lulus pintu berangka tidak menjamin klip yang baik: konsistensi gerakan dari semasa ke semasa disemak dengan mata (lihat `docs/KAPILAR.md`).
- **209 bingkai, set bendera yang mana:** bukti rantai bait 209 bingkai diambil dengan set bendera F209V2 pada binaan pembangunan (tiada bendera block-tail, dibina tanpa tampalan 0019/0020); `uret.ps1` menggunakan resipi ini untuk 209 bingkai [dibaca: skripnya; larian enjin sebenar melalui `uret.ps1` lulus dalam larian U209].
- Disahkan oleh kami pada satu kad (GTX 1050 Ti 4 GB); laporan luar untuk kad lain disenaraikan bersama labelnya dalam `docs/KART_PROFILLERI.md` [dilaporkan pengguna].
- **Binari mana yang diukur:** latent 141 bingkai dan rantai bait diukur dengan binaan pembangunan kami. Binari keluaran yang anda muat turun ialah binaan baharu: pintu bait 56 bingkainya lulus (butiran seterusnya) dan larian 209 bingkai melalui `uret.ps1` lulus pintu (larian U209, 3414 saat, puncak VRAM 3777 MiB) [diukur]; berbanding larian 209 binaan pembangunan, latent sama bait demi bait; dalam video bingkai (md5) dan audio sama, sha256 fail AVI berbeza kerana bekas (container) [diukur] (lihat `docs/OLCUMLER.md`, bahagian 0).
- **Binari keluaran, 56 bingkai:** binari keluaran (sd-cli `c5cebe78...`, stable-diffusion.dll `e5d3d329...`) memberikan hasil 56 bingkai yang sama bait dengan R0 (sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`; md5 setiap bingkai dan audio sama), dijalankan terus dengan bendera lalai (tanpa pemboleh ubah `SD_*`), kod keluar 0, 601 saat [diukur: larian B56VT2, 2026-11-19; bukti disimpan oleh penulis, tiada dalam repositori ini]. Skop: hanya kad sm_61 kami dan 56 bingkai; bukan ujian pemasangan clean-root; latent 141 bingkai dan rantai 209 diukur dengan binari yang lebih lama dan TIDAK diulang dengan binari ini [belum dicuba]. Percubaan pertama (B56VT, melalui skrip pembantu) berakhir secara senyap selepas 58 saat, punca tidak diketahui [anggaran: tekanan memori]; percubaan kedua menjalankan `sd-cli` terus.
- Skrip pemasangan dan larian belum disahkan daripada folder kosong (ujian clean-root belum dibuat).
- Pelan hala tuju dan langkah seterusnya: `ROADMAP.md`.

## Status dan had
- Disahkan pada satu mesin (GTX 1050 Ti 4 GB, RAM 16 GB, i7-7700HQ). Kad 4 GB lain dan saiz RAM lain mungkin berbeza.
- **Lalai 209 bingkai (8.7 saat):** lulus pintu kualiti kami (hingar 1.08, larian F209V2K) [diukur: 209 bingkai dengan binari keluaran melalui `uret.ps1`, larian U209; latent sama bait demi bait dengan larian binaan pembangunan; bingkai dan audio dalam video sama, sha fail berbeza kerana bekas (container); bukti disimpan oleh penulis, tiada dalam repositori ini]. Pada 209 bingkai puncak VRAM DiT ialah 3777 MiB daripada 4096 MiB (larian F209b dan U209; bacaan `nvidia-smi` seluruh kad), margin nipis: beban GPU lain (skrin, aplikasi lain) boleh menyebabkan larian gagal pada `blocks.0`; diuji hanya pada GTX 1050 Ti. Keadaan skrin semasa larian itu tidak direkodkan; jika skrin anda berjalan pada kad ini, VRAM yang tersedia lebih sedikit [anggaran: beban skrin Windows kira-kira 100-300 MB]; jika perlu, sambungkan skrin ke GPU bersepadu [nasihat, belum diuji]. Pensampelan mengambil 2730 saat (larian U209: langkah 436-483 saat) dan penyahkodan VAE proses berasingan 173 saat (peringkat 2 keseluruhan 193 saat bersama penyahkodan audio) [diukur: U209 binari keluaran; larian pembangunan lama: 2664 saat dan 174 saat]. Pada peringkat 1 VAE dalam-proses kehabisan memori dan jatuh kepada temporal tiling (320 saat); output itu dibuang, video datang daripada peringkat 2 tanpa tiling. Puncak RAM tidak diukur dalam U209. Klip yang lebih panjang daripada 209 bingkai bukan sebahagian daripada keluaran ini.
- **Image-to-video (`-InitImg`):** dengan imej awal, had ialah 192 bingkai (8.0 saat pada 24 fps) pada GPU ini: 209 bingkai tidak muat (kekurangan kira-kira 17.5 MB VRAM pada blok 0: perlu 2587 MB, tersedia 2570 MB); 192 bingkai berjalan melalui `uret.ps1` dalam 3086 saat dengan puncak VRAM 3783 MiB dan pintu lulus [diukur: larian B209 dan B192, 2026-11-20, satu babak; bukti disimpan oleh penulis, tiada dalam repositori ini]. Tidak dicuba pada GPU lain [belum dicuba].
- **RAM kosong penting:** anda memerlukan kira-kira 11 GB RAM KOSONG (proses enjin memegang kira-kira 11 GB) [diukur]. Dengan RAM kosong yang terlalu sedikit proses boleh mati tanpa mesej ralat [anggaran: kami melihatnya sekali dengan kira-kira 300 MB RAM kosong ketika `sd-cli` memegang kira-kira 10 GB]. Jangan buka program besar lain semasa ia berjalan: pada mesin 16 GB hanya kira-kira 0.3-0.5 GB tinggal kosong, dan di bawah tekanan memori larian boleh mati secara senyap. Sebelum bermula, tutup pelayar, permainan dan program besar lain, dan semak RAM yang kosong.
- **Ujian clean-root belum dibuat:** skrip pemasangan dan larian belum disahkan daripada folder kosong hanya dengan arahan ini; bahagian ini akan dikemas kini apabila ujian itu (termasuk perbandingan bait 56 bingkai dengan rujukan) direkodkan.
- Tiada video yang dijana disertakan di sini.

<!-- i18n-source: README.md sha256:a26a5a878a5f -->
