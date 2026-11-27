# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · বাংলা · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

অনুবাদগুলো এই ইংরেজি README অনুসরণ করে। কোনো অনুবাদ আলাদা হলে বা পিছিয়ে থাকলে, বিশেষ করে লাইসেন্স ও নিরাপত্তার লেখায় ইংরেজি পাঠই চূড়ান্ত ([`SECURITY.md`](SECURITY.md) ও [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) শুধু ইংরেজি ও তুর্কি ভাষায় রাখা হয়)।

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **শুরুর আগে (লাইসেন্স, অঞ্চল):** এই রিপোজিটরি MIT লাইসেন্সের এবং এতে শুধু প্যাচ ও স্ক্রিপ্ট আছে। এটি যে MiniMax H3 মডেল ডাউনলোড করে তা MiniMax H3 Community License-এর অধীন: এর অঞ্চলে ইউরোপীয় ইউনিয়ন, যুক্তরাজ্য, দক্ষিণ কোরিয়া ও যুক্তরাষ্ট্র অন্তর্ভুক্ত নয়, এবং মডেল, ডেরিভেটিভ **ও আউটপুট (আপনার তৈরি ভিডিও)** সেখানে ব্যবহার, বিতরণ বা প্রদর্শন করা যাবে না (V.4)। লাইসেন্সের শর্তের মধ্যে বাণিজ্যিক ব্যবহার অনুমোদিত। ইনস্টলের আগে [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) পড়ুন; এটি আইনি পরামর্শ নয়।

> **30 সেকেন্ডে:** একটি 4 GB গ্রাফিক্স কার্ড এক পাসে 209 ফ্রেমের (8.7 সেকেন্ড) MiniMax H3 ভিডিও বানাতে পারে: একটি মেশিনে যাচাই করা হয়েছে (GTX 1050 Ti 4 GB; ফাঁকা ফোল্ডারে পূর্ণ `kur.ps1` ইনস্টলেশন শুরু থেকে শেষ পর্যন্ত এখনো যাচাই হয়নি) [পরিমাপকৃত: রিলিজ বাইনারি দিয়ে `uret.ps1`-এর মাধ্যমে 209 ফ্রেম, রান U209; latent ডেভেলপমেন্ট-বিল্ডের রানের সঙ্গে বাইট-বাই-বাইট অভিন্ন; ভিডিওতে ফ্রেম ও অডিও অভিন্ন, ফাইলের sha কন্টেইনারের কারণে আলাদা; প্রমাণ লেখকদের কাছে সংরক্ষিত, এই রিপোজিটরিতে নেই]; `-InitImg` (ছবি থেকে ভিডিও) দিয়ে সর্বোচ্চ 192 ফ্রেম (8.0 সেকেন্ড) [পরিমাপকৃত: রান B192]; 209 ফ্রেমে প্রায় 57 মিনিট লাগে, ডিফল্ট সময়সীমা 80 মিনিট [পরিমাপকৃত: রান U209]; নিচের 3টি ধাপই এটি চালানোর পদ্ধতি।

VideoTurko: stable-diffusion.cpp-এর মেমোরি প্যাচ এবং চালানোর রেসিপি, যার সাহায্যে MiniMax H3 text-to-video 4 GB GTX 1050 Ti-তে এক পাসে 209 ফ্রেম (8.7 সেকেন্ড) পর্যন্ত চলে; image-to-video (`-InitImg`) 192 ফ্রেম (8.0 সেকেন্ড) পর্যন্ত (209 ফ্রেম বাইট-শৃঙ্খল দিয়ে যাচাই করা; 56 ও 141 ফ্রেমের পরীক্ষায় প্যাচবিহীন রানের সঙ্গে বাইট-অভিন্ন)।

## দ্রুত শুরু (Windows, 3 ধাপ)
**অবস্থা: নিচের ইনস্টল/রান স্ক্রিপ্টগুলো এখনো শেষ করা হচ্ছে এবং clean-root পরীক্ষা বাকি; সেই পরীক্ষা পাস না করা পর্যন্ত এখানে কোনো কিছু কাজ করে বলে দাবি করা হয় না ("অবস্থা ও সীমাবদ্ধতা" দেখুন)।**

1. এই রিপোজিটরি **ডাউনলোড** করুন (সবুজ **Code** বোতাম, তারপর **Download ZIP**) এবং ছোট নামের কোনো ফোল্ডারে এক্সট্র্যাক্ট করুন, যেমন `C:\vt`।
2. **ইনস্টল: `kur.cmd` ডাবল-ক্লিক করুন** (একটি কালো উইন্ডো খুলে প্রতিটি ধাপ দেখায়; বন্ধ করলে ইনস্টল থেমে যায়, আবার চালালে যেখানে থেমেছিল সেখান থেকে চলে: অর্ধেক ডাউনলোড হওয়া মডেল ফাইল আবার শুরু হয় [পড়া: ডাউনলোড স্ক্রিপ্ট একটি `.part` ফাইল রাখে এবং সেখান থেকে চালিয়ে যায়; পুরো 29 GiB পুনরায় শুরু মাপা হয়নি])। ডাউনলোড করা ফাইল নিয়ে Windows সতর্ক করলে বদলে নিচের PowerShell কমান্ড ব্যবহার করুন [পরামর্শ, ডাউনলোড করা ZIP-এ পরীক্ষা করা হয়নি]। কমান্ড লাইন পছন্দ করেন? ওই ফোল্ডারে PowerShell খুলুন (Explorer-এর অ্যাড্রেস বারে `powershell` লিখুন) এবং একই ইনস্টল চালান:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   ইনস্টল রুট হলো আপনার এক্সট্র্যাক্ট করা ফোল্ডার (ইঞ্জিন যায় `engine\bin`-এ, মডেল যায় `model`-এ); অন্য জায়গা ব্যবহার করতে আগে এনভায়রনমেন্ট ভেরিয়েবল `VT_ROOT` সেট করুন। এটি GPU, ড্রাইভার, RAM ও ডিস্ক পরীক্ষা করে, ইঞ্জিন ও মডেল আনে (ইঞ্জিন zip এবং নতুন ডাউনলোড হওয়া মডেল ফাইলের sha256 যাচাই হয়; সঠিক আকারের যে মডেল ফাইল আগে থেকেই আছে তার শুধু আকার যাচাই হয়, `scripts\modelleri_indir.ps1 -Dogrula` পূর্ণ sha256 যাচাই চালায়), একটি ছোট বাস্তব পরীক্ষা চালায়, এবং সেই পরীক্ষা পাস করলেই কেবল READY ছাপে [নকশা: `kur.ps1` পরিষ্কার ফোল্ডারে এখনো সম্পূর্ণ চালানো হয়নি; পরিষ্কার-ফোল্ডার পরীক্ষার পর এই বাক্য হালনাগাদ হবে]। `-ExecutionPolicy Bypass` শুধু এই একটি প্রসেসে প্রযোজ্য; যেকোনো ইনস্টলারের মতোই আগে `scripts\kur.ps1` পড়ে নিন।
   ইঞ্জিন zip আসে GitHub রিলিজ v0.1.0 থেকে (19 নভেম্বর 2026-এ প্রকাশিত; এর sha256 `kur.ps1`-এ নির্দিষ্ট করা আছে)। অফলাইনে বা নিজের বিল্ড দিয়ে চালালে লোকাল zip দিন: `-MotorZip <path> -CudaZip <path>`। লোকাল zip-ও একই নির্দিষ্ট sha256 দিয়ে যাচাই হয় (পাশের `.sha256` ফাইল উপেক্ষিত হয়), তাই এটি রিলিজের zip-ই হতে হবে; নিজের বিল্ডের জন্য আগে `VT_MOTOR_SHA256` / `VT_CUDA_SHA256`-এ তার sha256 সেট করুন। ভুল sha256 হলে exit 1 দিয়ে থামে। শুধু `.exe`/`.dll` যায় `engine\bin`-এ; লাইসেন্স ও README যায় `engine\lisanslar\<zip name>\`-এ। [চেষ্টা করা হয়েছে: রিলিজের আগে dist zip দিয়ে: পাশের `.sha256` ও স্ব-নির্ভর সতর্কতা, বাইনারি ও DLL বসানো হয়েছে, `sd-cli --help` চলেছে; ইনস্টল হওয়া বাইনারির sha মিলেছে (`c5cebe78...`, `e5d3d329...`); `kur.ps1`-এর মডেল ধাপ ও 5-ফ্রেম পরীক্ষা বাস্তব GPU-তে এখনো চালানো হয়নি]
   **মডেল লাইসেন্স:** মডেল ধাপের আগে ইনস্টলার লাইসেন্সের সারসংক্ষেপ দেখায় (`docs/LISANS_KABUL.txt`, পূর্ণ পাঠ `docs/LISANS_UYARISI.md`: MiniMax H3 Community License, যে অঞ্চল-সীমা তৈরি করা ভিডিওর ক্ষেত্রেও প্রযোজ্য, বাণিজ্যিক ও AI-লেবেলের নিয়ম) এবং আপনাকে মেনে নিতে বলে (`E` = হ্যাঁ)। আগে এটি পড়ুন। তত্ত্বাবধান ছাড়া চালাতে আপনি `-LisansKabul E` দিতে পারেন, যার অর্থ আপনি নিজে এটি পড়েছেন ও মেনে নিয়েছেন; অন্য কারও হয়ে এটি যোগ করবেন না। (AI এজেন্ট: `AGENTS.md` অনুসরণ করুন; ব্যবহারকারীর সম্মতি ছাড়া কখনো E লিখবেন না।) সম্মতি ছাড়া `kur.ps1` exit code 2 দিয়ে থেমে যায় এবং কোনো মডেল ডাউনলোড করে না।
3. **আপনার প্রথম ভিডিও (56 ফ্রেম, আমাদের GTX 1050 Ti-তে প্রায় 11 মিনিট** [পরিমাপকৃত: 641 সেকেন্ড, রান R0, `docs/OLCUMLER.md`; অন্য কার্ড মাপা হয়নি]**)**: ইনস্টলার `HAZIR / READY` ছাপালে চালান
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (শর্টকাট: প্রম্পটের টেক্সট ফাইল `uret.cmd`-এর ওপর টেনে ছাড়ুন, অথবা `uret.cmd docs\ornek_istem_R0.txt` চালান: একই 56 ফ্রেমের রান)। ভিডিও `runs\`-এ থাকে। তারপর নিজের প্রম্পট একটি টেক্সট ফাইলে লিখুন (ইংরেজিতে একটি অনুচ্ছেদ, ঐচ্ছিক `audio:` বাক্য) এবং আমাদের সমর্থিত সবচেয়ে দীর্ঘ ক্লিপ চালান (ডিফল্ট, প্রায় 57 মিনিট [পরিমাপকৃত: রান U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   `-Kare` 17k+5 গ্রিড অনুসরণ করে (56, 73, ... 192, 209); ডিফল্ট 209 (8.7 সেকেন্ড), যা আমাদের কভার করা দীর্ঘতম দৈর্ঘ্য। VAE আলাদা প্রসেসে চলে, কখনো টাইল করা হয় না [রিলিজ বাইনারি দিয়ে `uret.ps1`-এর মাধ্যমে বাস্তব ইঞ্জিন রান, আলাদা-প্রসেস VAE, রান U209-এ পাস করেছে]।

   প্রম্পট লেখার নির্দেশিকা: [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (একটানা একটি শট, সমান সময়ের ভাগ, দুটি পূর্ণ উদাহরণ)।

| প্রয়োজনীয়তা | মান |
|---|---|
| OS | Windows 10/11, 64-bit |
| GPU | NVIDIA, 4 GB বা তার বেশি; শুধু GTX 1050 Ti (sm_61)-এ পরীক্ষিত; সরু মার্জিন (209 ফ্রেমে 3777/4096 MiB): ব্যস্ত স্ক্রিন বা ব্রাউজার রান নষ্ট করতে পারে; অন্য কোনো 4 GB কার্ড চেষ্টা করা হয়নি |
| RAM | 16 GB (সর্বোচ্চ প্রায় 11 GB; অন্য প্রোগ্রাম বন্ধ রাখুন) |
| ডিস্ক | কমপক্ষে 32 GiB খালি (40 GiB বা বেশি সুপারিশকৃত: 32 থেকে 40-এর মধ্যে ইনস্টলার সতর্কতা ছাপে, `[VT-W-DISK-PAY]` [পরিমাপকৃত: নকল ডিস্কসহ `-Kuru` রান]), মডেল SSD-তে (NVMe ভালো) |
| ডাউনলোড | ইঞ্জিন zip 36.8 MB + CUDA runtime zip 567.5 MB [পরিমাপকৃত] + মডেল 31,473,112,040 বাইট (প্রায় 29.3 GiB) [পড়া: আকার `scripts/modeller.json`-এ]; মোট প্রায় 30 GiB |
| মডেল | অন্তর্ভুক্ত নয়; ইনস্টলার MiniMax লাইসেন্সের অধীনে আনে (নিচের সতর্কতা দেখুন)। মডেলগুলো (29.3 GiB, `scripts/modeller.json`-এ 31,473,112,040 বাইট) এই রিপোজিটরি বা রিলিজে নেই: GitHub-এর ফাইল/রিলিজ আকার-সীমা প্রযোজ্য, এবং `kur.ps1` সেগুলো অফিশিয়াল উৎস থেকে sha256 যাচাইসহ ডাউনলোড করে। |

`kur.ps1`-এর exit code: 0 READY, 1 ত্রুটি, 2 ব্যবহারকারীর ইনপুট দরকার (লাইসেন্স, বা এখনো রিলিজ/zip নেই), 3 হার্ডওয়্যার বা ডিস্ক অপর্যাপ্ত, 4 থামানো হয়েছে (DUR ফাইল)। `uret.ps1` কোনো রান গ্রহণ করে কেবল তখনই যখন `.avi` ফাইল থাকে, ফ্রেম সংখ্যা ঠিক থাকে এবং লগ পরিষ্কার থাকে [পরিমাপকৃত: রিলিজ বাইনারিতে `uret.ps1`-এর মাধ্যমে একটি বাস্তব রান, রান U209, 209 ফ্রেম, গেট পাস]। `uret.ps1`-এর exit code: 0 DONE (মান-গেট পাস), 1 ত্রুটি বা অবৈধ আউটপুট (অডিও স্ট্রিম ছাড়া ভিডিওসহ), 2 থামানো হয়েছে (DUR ফাইল), 5 `KAPI RED` (মান-গেট ব্যর্থ: ক্লিপ গৃহীত নয়, সিদ্ধান্ত আপনার), 6 গেট চালানো যায়নি (ক্লিপ গৃহীত নয়)। বিস্তারিত AGENTS.md-এ। [পরিমাপকৃত: ভুয়া ইঞ্জিন ও ভুয়া গেটসহ পরিস্থিতিতে exit code 0, 1 (নিঃশব্দ ভিডিও), 5 ও 6; বাস্তব ইঞ্জিন: রান U209-এ exit 0]

### সমস্যা সমাধান (বিস্তারিত: `docs/SIK_HATALAR.md`)
আমাদের স্ক্রিপ্টের ত্রুটির লাইনে একটি স্থির কোড থাকে, যেমন `HATA: [VT-E-DLL] ...` বা `UYARI: [VT-W-DISK-PAY] ...`। কোডটি [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) (অ্যাঙ্করের উদাহরণ `#vt-e-dll`) বা `docs/hata_imzalari.json`-এ খুঁজুন এবং কোডটি আপনার issue-তে লিখুন। নিচের টেবিলের প্রথম কলাম যেমন ছাপা হয় তেমনই থাকে (কোড ও লগের লেখা অনুবাদ করবেন না)।

| আপনি যা দেখছেন | এর অর্থ ও করণীয় |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | `sd-cli.exe` হাতে চালাবেন না; `scripts\kur.ps1` চালান, যা CUDA DLL-গুলো যথাস্থানে রাখে। |
| `blocks.0`-এ `failed during weight preparation` (#1, #3, #5) | মেমোরি গেটে VRAM যথেষ্ট নয়: 17k+5 গ্রিডে কম ফ্রেম সংখ্যা নিন, অন্য GPU প্রোগ্রাম বন্ধ করুন, সঙ্গে আসা flag বদলাবেন না। |
| `retrying with temporal tiling` (#6) | VAE tiling-এ ফিরে গেছে; মানের দিক থেকে আউটপুট অবৈধ। আবার চালান। |
| রান সময়সীমায় শেষ, ভিডিও নেই (#7) | লম্বা ক্লিপের জন্য `-TavanDk` বাড়ান (ডিফল্ট সময়সীমা: 209 ফ্রেমে 80 মিনিট, `uret.ps1` ঠিক করে; আমাদের 209-ফ্রেম রানে 57 মিনিট লেগেছে [পরিমাপকৃত: রান U209])। |
| Exit code ফাঁকা কিন্তু "finished" (#14) | র‍্যাপার exit code খুব আগে পড়ে ফেলেছে; আবার চালান এবং ভিডিও ফাইল আছে কিনা দেখুন। |
| সিস্টেম ধীর, swapping (#18) | ইঞ্জিন প্রায় 10-11 GB RAM নেয়; ব্রাউজার ও অন্য প্রোগ্রাম বন্ধ করুন। |
| sha256 মেলেনি / ডাউনলোড ব্যর্থ | সাধারণত ডাউনলোড মাঝপথে থেমেছে: একই কমান্ড আবার চালান, যাচাই হওয়া ফাইল বাদ যায়। |

**আটকে গেছেন বা কৌতূহলী?** [`SUPPORT.md`](SUPPORT.md) (কোথায় জিজ্ঞাসা করবেন; উত্তরের সময় লক্ষ্য, প্রতিশ্রুতি নয়) · [`PRIVACY.md`](PRIVACY.md) (কোনো টেলিমেট্রি নেই; নেটওয়ার্ক শুধু ইঞ্জিন ও মডেল ডাউনলোডে, তালিকাভুক্ত হোস্ট থেকে ব্যবহৃত হয়) · [`SECURITY.md`](SECURITY.md) (ব্যক্তিগত রিপোর্ট) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (5 ধাপে প্রথম pull request; ডকুমেন্ট ও স্ক্রিপ্টের জন্য GPU লাগে না)।

### v0.1.1-এ নতুন: আরও বিকল্প (বিস্তারিত: `AGENTS.md`, `docs/SIK_HATALAR.md` 19-23)
এই বিকল্পগুলো ব্যবহার না করলে 4 GB কার্ডে কিছুই বদলায় না (আমাদের রেফারেন্সের সঙ্গে তুলনায় 56-ফ্রেম বাইট পরীক্ষা v0.1.1-এর সঙ্গে আবার পাস করেছে [পরিমাপকৃত])। কী চলবে তা দেখতে যেকোনো কমান্ডে `-Kuru` যোগ করুন।
- `-EndImg`: শেষ ফ্রেমও দিন (প্রথম ও শেষ ফ্রেম, "FLF"); 8 GB-এর কম কার্ডে সীমা 175 ফ্রেম (4 GB-তে 192 ধরেনি), 8 GB বা তার বেশি কার্ডে 192। আমাদের GTX 1050 Ti-তে এটি সবসময় দুটি প্রসেসে চলে: 56 ফ্রেম 1040 সেকেন্ড, 175 ফ্রেম 2887 সেকেন্ড (48 মিনিট), দুটিই গেট পাস করেছে [পরিমাপকৃত]। প্রম্পট লেখার পরামর্শ: `docs/ISTEM_YAZIMI.md`।
- `-W` / `-H`: অন্য মাপ, যেমন উল্লম্ব 384x640; 32-এর গুণিতক, ক্ষেত্রফল অন্তত 640x384 (এর চেয়ে ছোট কখনো নয়)। 4 GB-তে পরীক্ষা করা হয়নি; 8 GB-এর কম কার্ডে আমাদের মাপা সবচেয়ে বড় কাজের চেয়ে বড় মাপ প্রত্যাখ্যাত হয়। মান-গেটের সীমাগুলো 640x384-এ ক্যালিব্রেট করা।
- `-TekAsama`: দুটির বদলে একটি প্রসেস, শুধু বড় কার্ডের জন্য; কখনো নিজে থেকে চালু হয় না।
- নতুন GPU (compute capability 7.0+, যেমন RTX 20/30/40): আপনি নিজে সেট না করলে `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` স্বয়ংক্রিয়ভাবে সেট হয়; এতে রিপোর্টকারীর RTX 4070 Ti-তে 141 বা তার বেশি ফ্রেমে পুরো কালো ভিডিওর সমস্যা ঠিক হয়েছে [ব্যবহারকারী জানিয়েছেন, issue #1]। Python + OpenCV না থাকলে `uret.ps1` এখন GPU কাজের আগেই exit 6 দিয়ে থামে (কোনো ভিডিও তৈরি হয় না, বিভ্রান্তিকর RED-ও নয়)।
- এই পরিবর্তনগুলোর পেছনে থাকা RTX 4070 Ti রিপোর্টের জন্য @SinanC73-কে ধন্যবাদ ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1))।

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

## ঐচ্ছিক গতি প্রোফাইল (স্পিড প্যাক; ডিফল্টে বন্ধ)
নিচের কোনোটিই ডিফল্ট রান বদলায় না (640x384, 209 ফ্রেম, আমাদের কার্ডে 3414 s)। এগুলো তার বাইরের তিনটি পরিমাপ করা সেল, প্রতিটি `uret.ps1`-এর একটি নামযুক্ত প্রোফাইল; এগুলোর জন্য স্পিড-প্যাক ইঞ্জিন লাগে (রিলিজ ইঞ্জিন এবং 0021, 0023, 0024 প্যাচ, সবই ডিফল্টে বন্ধ: `docs/YAMALAR.md`)। এটি `scripts\kur.ps1 -HizPaketi` দিয়ে ইনস্টল করুন (লোকাল zip `-MotorZip` দিয়ে চলে), তারপর `-Profil <name>` যোগ করুন; `-Kuru` কী চলবে তা ছাপে।

| প্রোফাইল | আকার, দৈর্ঘ্য | GTX 1050 Ti 4 GB-তে মোট সময় | অবস্থা |
|---|---|---|---|
| (কোনোটি নয়, ডিফল্ট) | 640x384, সর্বোচ্চ 209 ফ্রেম (8.7 s) | 209 ফ্রেম: 3414 s | যাচাই করা, অপরিবর্তিত |
| `yuksek832` | 832x480, 141 ফ্রেম (5.9 s) | প্রায় 55-56 মিনিট | ব্যবহারযোগ্য, দুটি প্রম্পট [পরিমাপকৃত] |
| `yuksek832 -Kare 124` | 832x480, 124 ফ্রেম (5.2 s) | প্রায় 45-46 মিনিট, কোনো গতির ফ্ল্যাগ লাগে না | ব্যবহারযোগ্য, দুটি প্রম্পট [পরিমাপকৃত] |
| `yuksek896` | 896x512, 124 ফ্রেম (5.2 s) | প্রায় 56-57.5 মিনিট | ব্যবহারযোগ্য, দুটি প্রম্পট [পরিমাপকৃত] |
| `uzun260` | 640x384, 260 ফ্রেম (10.8 s) | আগাম প্রস্থান ছাড়া 78 মিনিট পরিমাপ করা; তার সঙ্গে প্রায় 71-72 মিনিট [অনুমান: `uret.ps1`-এর মাধ্যমে শুরু থেকে শেষ পর্যন্ত পরিমাপ করা হয়নি] | শর্তসাপেক্ষ ও পরীক্ষামূলক |

- **সংকীর্ণ মার্জিন:** 832x480 x 141-এ মেমরি গেট এক অঙ্কের MB-র মতো মার্জিন রাখে (দুটি পূর্ণ রানে 5.7 ও 6.8 MB)। দুটি দীর্ঘ প্রম্পট (1520 ও 2041 অক্ষর) শুধু ধাপ 1 এবং ধাপ 2-এর একাংশের গেট পড়ে যাচাই করা হয়েছে, পুরো চালানো হয়নি: মার্জিন 10.9 ও 4.0 MB। কার্ডের মেমরি ধরে রাখা অন্য যেকোনো প্রক্রিয়া (ব্রাউজার, দ্বিতীয় ডিসপ্লে) এটিকে ব্যর্থ করতে পারে; তখন `-Kare 124` বা ডিফল্ট আকার ব্যবহার করুন [পরিমাপকৃত, GTX 1050 Ti 4 GB]।
- **`uzun260` শর্তসাপেক্ষ:** মেমরির সীমা খুবই সংকীর্ণ (VRAM-এর শীর্ষ 4096 MiB-এর মধ্যে 3903), শেয়ার্ড মেমরির ব্যবহার 61 ও 68 MiB বেড়েছে, এবং বাইট-সমতার জন্য ফ্ল্যাগ-বিহীন কোনো রেফারেন্স নেই, তাই এটি সাধারণ ফিচার হিসেবে দেওয়া হয় না। প্যাচ 0023 শুধু এই একটি সেলের জন্য গৃহীত।
- **দেওয়া হয় না:** 832x480-এ 158 বা 175 ফ্রেম আঁটে না; দৈর্ঘ্যের অনুসন্ধান সেখানে 141 ফ্রেমে শেষ হয়েছে। অন্যান্য আকার ও ফ্রেম সংখ্যা `-Profil` প্রত্যাখ্যান করে (ডিফল্ট পথ ব্যবহার করুন)।
- ডিফল্ট মান অক্ষত: 6 ধাপ, cfg 1, টাইল-বিহীন VAE, 17k+5 ফ্রেম। যেখানে ফ্ল্যাগ চালু, সেখানে ফ্ল্যাগ-বিহীন রান যে আকারে আঁটে সেগুলোতে আউটপুট ফ্ল্যাগ-বিহীন ভিডিওর সঙ্গে বাইট ধরে ধরে মেলানো হয়েছে (`docs/YAMALAR.md`); 832x480 x 141 ও 896x512 x 124-এ ফ্ল্যাগ-বিহীন রান আঁটে না, তাই সেখানে সমতা সরাসরি তুলনার ওপর নয়, নিকটতম সেলগুলোর ওপর দাঁড়িয়ে [পরিমাপকৃত, পড়া]।
- দুই-ধাপের রানের ধাপ 1 এখন ল্যাটেন্ট ফাইল সম্পূর্ণ হওয়ামাত্র শেষ হয় (`VT_ERKEN_CIKIS=0` এটি বন্ধ করে)।

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

## এটি কী
stable-diffusion.cpp-এর জন্য ছোট মেমোরি/শিডিউলিং প্যাচের একটি সেট, সঙ্গে চালানোর রেসিপি, পরীক্ষা ও পরিমাপ, যার সাহায্যে MiniMax H3 (33B DiT; আমরা HyperFlow Flash 13.7B Q4_K_M GGUF চালাই; 32B Qwen3-VL টেক্সট এনকোডার আলাদা) 4 GB Pascal GPU-তে (GTX 1050 Ti, 16 GB সিস্টেম RAM) চলে।
- এক-পাসের যে দৈর্ঘ্যগুলো আমরা সত্যিই বানিয়েছি এবং আমাদের মান-গেট পার করেছি: 640x384, 24 fps-এ 56, 141, 158, 175, 192, 209 ফ্রেম (209 ফ্রেম = 8.7 সেকেন্ড), H3-এর নিজের তৈরি অডিওসহ [পরিমাপকৃত: রিলিজ বাইনারি দিয়ে `uret.ps1`-এর মাধ্যমে 209 ফ্রেম, রান U209; latent ডেভেলপমেন্ট-বিল্ডের রানের সঙ্গে বাইট-বাই-বাইট অভিন্ন; ভিডিওতে ফ্রেম ও অডিও অভিন্ন, ফাইলের sha কন্টেইনারের কারণে আলাদা; প্রমাণ লেখকদের কাছে সংরক্ষিত, এই রিপোজিটরিতে নেই]। 209 হলো সবচেয়ে লম্বা দৈর্ঘ্য যা আমরা দেখেছি এবং মসৃণ পেয়েছি [ব্যবহারকারী জানিয়েছেন, 2026-11-19, ভিডিও সম্পূর্ণ দেখা হয়েছে; ফাইল: F209V2 আউটপুট, 8.708 সেকেন্ড]।
- **বাইট-অভিন্নতার দাবি, সৎ পরিসরসহ:** আউটপুট প্যাচবিহীন রেফারেন্সের সঙ্গে বাইট-অভিন্ন কিনা তা শুধু 56 ও 141 ফ্রেমের জন্য যাচাই করা হয়েছে। 158/175/192/209 ফ্রেমের জন্য আমরা একই flag ও একই বাইনারি-শৃঙ্খল ব্যবহার করেছি; কোনো সরাসরি বাইট রেফারেন্স নেই (প্যাচবিহীন বিল্ড এই GPU-তে ওই দৈর্ঘ্য চালাতেই পারে না)।
- মানের সেটিং কখনো কমানো হয় না: একই মডেল/কোয়ান্টাইজেশন, 6 steps, cfg 1, 640x384, একই seed, tiling-বিহীন VAE।
- আমরা প্রথম বলে দাবি করি না: আমরা খুঁজেছি এবং 4 GB-তে এর কোনো বাইরের উদাহরণ পাইনি, যা এই কথার প্রমাণ নয় যে এমন কিছু নেই।

## বিন্যাস
- `patches/` একটি নির্দিষ্ট করা stable-diffusion.cpp commit-এর বিপরীতে প্যাচ (সেখানকার নোট দেখুন)
- `scripts/` বিল্ড, রান, আলাদা-প্রসেস VAE, গেট/সামঞ্জস্য সহায়ক (`doku_norm.py`: নিচের স্কেল নোট দেখুন)
- `docs/KURULUM.md` হার্ডওয়্যার, বিল্ড ও রানের ধাপ (EN+TR)
- `docs/YAMALAR.md` প্যাচ তালিকা, `docs/KANITLAR.md` প্রমাণ, `docs/KAPILAR.md` মান-গেট সারণি, `docs/OLCUMLER.md` পরিমাপ, `docs/SIK_HATALAR.md` সাধারণ ভুল, `docs/LISANS_UYARISI.md` লাইসেন্সের সম্পূর্ণ ধারা
- `scripts/` সংক্ষিপ্ত সূচি: `hiz_kos3.ps1` রান র‍্যাপার (`-Kuru` সঠিক কমান্ড ছাপে), `uretim_kapi.ps1` মান-গেট, `dikis_denetim.py` জোড় পরীক্ষা, `doku_norm.py` টেক্সচার-স্বাভাবিকীকৃত noise, `bayt_kiyas.py` বাইট তুলনা, `derleme_sablonu.ps1` বিল্ড টেমপ্লেট (শুধু Visual Studio-র telemetry সহায়ক `vctip.exe` থামায়, যা নিজের বিল্ড শুরুর পরে চালু হয়েছিল এবং না থামালে বিল্ড প্রসেসকে কয়েক মিনিট আটকে রাখে; অন্য `vctip.exe` প্রসেস ছোঁয়া হয় না)

## মান-গেট (ফলাফল কীভাবে গৃহীত হয়)

এই গেট গতির সামঞ্জস্য (বস্তুর আকার বা অবস্থানের লাফ) পরীক্ষা করে না: গ্রহণ করার আগে পুরো ভিডিও দেখুন।
1. ফ্রেম সংখ্যা ও অডিও আছে; লগে কোনো memory fallback বা ALLOC_FAILED লাইন নেই।
2. কাঁচা noise গেট: median-filter অবশিষ্ট <= 1.5 (0-255 স্কেল)।
3. টেক্সচার-স্বাভাবিকীকৃত noise, `scripts/doku_norm.py` (এই রিপোজিটরির সংস্করণ): N = median অবশিষ্ট / Sobel টেক্সচার, প্রতি 6-তম ফ্রেমে। **স্কেল নোট:** এই সংস্করণে মাপা 10টি ক্লিপে N = 0.034-0.052 আসে (সারণি `docs/KAPILAR.md`-এ; F192/F209V2-এর শেষ এক-চতুর্থাংশে 0.062 পর্যন্ত পৌঁছায়) এবং অতিরিক্ত গেটের সীমা N <= 0.065। অন্য একটি বাস্তবায়ন একই ক্লিপে 0.028-0.036 মেপেছে, তাই সংস্করণগুলোর মধ্যে সীমা পরস্পর বদলানো যায় না। খুব সূক্ষ্ম টেক্সচারে (ঘাসের সারি) পরিষ্কার N ছিল 0.075, তাই সীমা দৃশ্য-পরিবার অনুযায়ী। একটি মজবুত উচ্চ-ফ্রিকোয়েন্সি এস্টিমেটর (sigma-HH <= 1.5; পরিষ্কার 0.74-1.19, s=2 যোগ করা noise দেয় 2.2-3.0) সুপারিশকৃত অতিরিক্ত গেট।

পরিধি: VideoTurko শুধু একটিমাত্র পাসের (সর্বোচ্চ 209 ফ্রেম, প্রায় 8.7 সেকেন্ড) বিষয়ে। আমাদের নিজস্ব জোড়া দেওয়ার পরীক্ষায় দৃশ্যমান জোড় দেখা গেছে (দৃশ্য পরিষ্কারভাবে চলতে থাকে না), তাই দীর্ঘ ফিল্ম আমরা যা যাচাই করি তার অংশ নয়। জোড়া দিতে কমিউনিটির গাইড `docs/KLIP_ZINCIRI.md` এবং শুধু CPU-তে চলা আমাদের সহায়ক `scripts/zincir.py` আছে (`plan`, `son-kare`, `bagla`; এটি কখনো ইঞ্জিন চালু করে না); জোড়া দেওয়া ফিল্মের মান আমরা পরিমাপ করিনি [চেষ্টা করা হয়নি], তাই প্রতিটি জোড় চোখে দেখে এবং `scripts/dikis_denetim.py` দিয়ে যাচাই করুন।
আপনার সেটিং আপনারই: 209 ফ্রেম 4 GB কার্ডে আমাদের পরীক্ষিত ডিফল্ট, এমন কোনো সীমা নয় যা আপনাকে মানতেই হবে। 17k+5 গ্রিডে যেকোনো ফ্রেম সংখ্যা বেছে নিন (56, 73, ... 192, 209; `docs/KURULUM.md` দেখুন), prompt, seed, রেজোলিউশন বা যেকোনো flag ইচ্ছেমতো বদলান। ছোট ক্লিপে কম মেমোরি ও সময় লাগে; বড় GPU-তে হয়তো আরও বেশি ধরবে।

## মডেল লাইসেন্স সতর্কতা
**VideoTurko-তে শুধু প্যাচ ও স্ক্রিপ্ট আছে (MIT); যিনিই মডেল ও তার আউটপুট ব্যবহার করেন, MiniMax লাইসেন্সের দায় তাঁর নিজের।** এটি আইনি পরামর্শ নয়। নিচে MiniMax H3 Community License-এর (August 2, 2026) ধারাগুলো নম্বরসহ সংক্ষেপে দেওয়া হলো; বাধ্যতামূলক হলো লাইসেন্স নিজেই: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

এই রিপোজিটরির MIT লাইসেন্স মডেল ওয়েট কভার করে না; দেখুন [`NOTICE`](NOTICE)। এই রিপোজিটরিতে কোনো মডেল ওয়েট নেই (MiniMax H3, HyperFlow-H3-Flash GGUF বা VAE ফাইল কিছুই নেই)। এই প্রকল্প MiniMax-এর সঙ্গে সম্পর্কিত নয় এবং তাদের দ্বারা সমর্থিতও নয়। বাণিজ্যিক ব্যবহার নিষিদ্ধ নয় (এটি অবাণিজ্যিক লাইসেন্স নয়); শর্তগুলো নিচে।

**অঞ্চল (Applicable Territory)**
- **Preamble, I.3, I.5:** সারা বিশ্ব, ইউরোপীয় ইউনিয়ন, যুক্তরাজ্য, কোরিয়া প্রজাতন্ত্র এবং যুক্তরাষ্ট্র বাদে। মডেল ব্যবহার করা মানেই লাইসেন্স মেনে নেওয়া।
- **II:** রয়্যালটি-মুক্ত, হস্তান্তর-অযোগ্য, সীমিত লাইসেন্স ব্যবহার, পুনরুৎপাদন, বিতরণ, ডেরিভেটিভ তৈরি ও পরিবর্তনের জন্য, শুধু অঞ্চলের ভেতরে এবং চুক্তি ও Exhibit A মেনে। বাদ পড়া অঞ্চলের মানুষ MiniMax-এর কাছে আলাদা লাইসেন্স চাইতে পারেন।
- **V.4:** অঞ্চলের বাইরে মডেল, তার ডেরিভেটিভ এবং আউটপুট (তৈরি ভিডিও/অডিও) ব্যবহার, পুনরুৎপাদন, পরিবর্তন, বিতরণ বা প্রদর্শন অনুমোদিত নয়। **অতএব তৈরি ভিডিও EU/UK/দক্ষিণ কোরিয়া/US-এ প্রকাশ বা প্রদর্শন করা লাইসেন্সের বাইরে।**
- **Exhibit A-1:** অঞ্চলের বাইরে ব্যবহার Acceptable Use Policy লঙ্ঘন করে।

**বিতরণ (III)** (এই রিপোজিটরি মডেল বিতরণ করে না; আপনি করলে)
- **III.1:** প্রতিটি প্রাপককে লাইসেন্সের একটি কপি দিন। **III.2:** পরিবর্তিত ফাইলে স্পষ্ট বিজ্ঞপ্তি দিন।
- **III.3:** উৎসাহিত (বাধ্যতামূলক নয়): "Powered by MiniMax H3" বিজ্ঞপ্তি, তৈরি ফাইলে AI-নির্মিত হওয়ার শনাক্তকারী, প্রকাশ্য লেখা।
- **III.4:** বিতরণের সঙ্গে অবশ্যই একটি NOTICE ফাইল থাকতে হবে, যাতে থাকবে: "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12:** কোনো কনটেন্ট যে মেশিনে তৈরি তা স্পষ্টভাবে না জানিয়ে যেকোনো প্রকাশ্য পরিবেশে প্রকাশ করা নিষিদ্ধ: AI-তৈরি ভিডিও প্রকাশ করার সময় লেবেল দিন (পূর্ণ তালিকা: `docs/LISANS_UYARISI.md`)।
- **III (শেষ অনুচ্ছেদ):** আপনি নিজের পরিবর্তনের ওপর নিজের কপিরাইট যোগ করতে পারেন, কিন্তু ব্যবহার/বিতরণে অতিরিক্ত বা ভিন্ন শর্ত চাপাতে পারবেন না; অঞ্চলের নিয়ম তবুও প্রযোজ্য।

**বাণিজ্যিক শর্ত (IV)**
- **IV.1:** আপনার বাণিজ্যিক পণ্য/সেবা বছরে USD 20 million (বা সমতুল্য) এর বেশি আয় করলে api@minimax.io থেকে আগে লিখিত অনুমোদন নিন (বিষয় "MiniMax H3 licensing - authorization request")।
- **IV.2:** মডেল ব্যবহারকারী বাণিজ্যিক পণ্য/সেবার UI-তে "MiniMax H3" স্পষ্টভাবে দেখাতে হবে।

**ব্যবহারের বিধিনিষেধ (V)**
- **V.1:** প্রযোজ্য আইন (বাণিজ্য-সম্মতিসহ) ও Exhibit A মেনে চলুন। **V.2:** যাঁদের আপনি প্রবেশাধিকার দেন, তাঁদের এমন শর্তে বাঁধুন যা অন্তত এই বিধিনিষেধের মতোই সুরক্ষামূলক, এবং তাঁদের জানান।
- **V.3:** আপনি মডেল বা তার আউটপুট দিয়ে অন্য কোনো AI মডেল উন্নত করতে পারবেন না (MiniMax H3 ও তার ডেরিভেটিভ ছাড়া)। (I.11: distillation এবং সিনথেটিক আউটপুটে প্রশিক্ষণ একটি মডেলকে "ডেরিভেটিভ" করে; আউটপুট নিজে ডেরিভেটিভ নয়।)
- **V.5:** আপনি তৃতীয় পক্ষকে এমন পণ্য/সেবা/হোস্টেড সেবা দিলে যা মডেল দিয়ে আউটপুট তৈরি করে: পরিচালনার আগে ও সারাক্ষণ যুক্তিসঙ্গত প্রযুক্তিগত ও সাংগঠনিক সুরক্ষা, রিপোর্টিং ব্যবস্থা, দ্রুত তদন্ত, এবং বারবার লঙ্ঘনকারীদের সরানো/নিষ্ক্রিয়/স্থগিত করা।

**ট্রেডমার্ক ও অধিকার (VI)**
- **VI.1:** আপনার তৈরি ডেরিভেটিভ কর্ম ও মডেল ডেরিভেটিভের মালিক আপনি (MiniMax-এর অধিকার সাপেক্ষে)। **VI.2:** MiniMax-এর নাম/চিহ্নের লাইসেন্স দেওয়া হয়নি (বর্ণনা ও বিতরণের জন্য যতটুকু দরকার তার বাইরে); "MiniMax H3" চিহ্ন শুধু III.3 পালনের জন্য, অঞ্চলের ভেতরে ব্যবহার করা যায়; সম্পৃক্ততার ধারণা দেবেন না।
- **VI.3:** আপনি যদি MiniMax বা অন্য কারও বিরুদ্ধে এই অভিযোগে মামলা করেন যে উপকরণ/আউটপুট আপনার অধিকার লঙ্ঘন করে, তবে আপনার সব লাইসেন্স সেদিনই শেষ হয়; আপনার বা অন্যদের ব্যবহার/বিতরণ থেকে ওঠা তৃতীয় পক্ষের দাবির বিরুদ্ধে আপনি MiniMax-কে রক্ষা করবেন ও ক্ষতিপূরণ দেবেন।
- **VI.4:** MiniMax আউটপুটের ওপর কোনো অধিকার দাবি করে না; আউটপুট ও তার ব্যবহারের দায় আপনার ও আপনার ব্যবহারকারীদের।

**দাবিত্যাগ ও সমাপ্তি (VII, VIII, IX)**
- **VII.1:** সহায়তা/হালনাগাদ দেওয়ার কোনো বাধ্যবাধকতা নেই। **VII.2:** মডেল ও আউটপুট "AS IS" দেওয়া হয়, কোনো ওয়ারেন্টি নেই; উপযোগিতা আপনি ঠিক করেন এবং ঝুঁকি আপনার। **VII.3:** MiniMax ও তার সহযোগীরা কোনো ক্ষতির জন্য দায়ী নয় (আইন যতটা অনুমতি দেয়)।
- **VIII.1:** সম্মতি/প্রবেশের সঙ্গে কার্যকর। **VIII.2:** লঙ্ঘন হলে MiniMax বাতিল করতে পারে; আপনাকে ব্যবহার/বিতরণ বন্ধ করতে, কপি মুছতে এবং প্রাপকদের জানাতে হবে (VI.1, VI.3, VII, IX বহাল থাকে)।
- **IX:** Hong Kong SAR-এর আইন; Hong Kong আদালতের একচেটিয়া এখতিয়ার (UN CISG বাদ)।
- **অতিরিক্ত নোট:** MiniMax H3-এর এনকোডার Qwen3-VL-32B (Apache 2.0) ব্যবহার করে।

**Acceptable Use Policy (Exhibit A)** (মডেল, ডেরিভেটিভ বা আউটপুট এসবের জন্য ব্যবহার করবেন না)
- A-1 অঞ্চলের বাইরে ব্যবহার; A-2 আইন বা তৃতীয় পক্ষের বুদ্ধিবৃত্তিক সম্পত্তি লঙ্ঘন; A-3 নিজের বা অন্যের ক্ষতি; A-4 ক্ষতি করতে আউটপুট নতুন উদ্দেশ্যে ব্যবহার/বিতরণ; A-5 সুরক্ষা ব্যবস্থা এড়ানো; A-6 নাবালকদের শোষণ/ক্ষতি; A-7 অন্যের ক্ষতি করতে বা নির্বাচন প্রভাবিত করতে যাচাইযোগ্যভাবে মিথ্যা তথ্য; A-8 ভুয়া অনলাইন সম্পৃক্ততা (ভুয়া রিভিউ ইত্যাদি); A-9 মানহানি, অবমাননা, হয়রানি; A-10 malware; A-11 অন্যের ক্ষতি করতে ব্যক্তিগত তথ্য; **A-12 কোনো কনটেন্ট যে মেশিনে তৈরি তা স্পষ্ট ও প্রকটভাবে না জানিয়ে যেকোনো প্রকাশ্য পরিবেশে (বট পোস্টসহ) প্রকাশ করা**; A-13 সম্মতি ছাড়া ছদ্মবেশ ধারণ; A-14 গুরুত্বপূর্ণ ক্ষেত্রে (আইন প্রয়োগ, অভিবাসন, স্বাস্থ্য, গুরুত্বপূর্ণ অবকাঠামো, ঋণ, কর্মসংস্থান, আবাসন, শিক্ষা, সামাজিক স্কোরিং, বিমা ইত্যাদি) উচ্চ-ঝুঁকির স্বয়ংক্রিয় সিদ্ধান্ত; A-15 অন্য দেশ/অঞ্চলের সামাজিক, নৈতিক মান লঙ্ঘন; A-16 সহিংস উগ্রবাদ/সন্ত্রাসবাদ; A-17 সুরক্ষিত বৈশিষ্ট্যের ভিত্তিতে বৈষম্য/ক্ষতি; A-18 দুর্বল জনগোষ্ঠীর শোষণ; **A-19 সামরিক উদ্দেশ্য**; A-20 অনুমতি/লাইসেন্স ছাড়া পেশাগত কার্যকলাপ (আর্থিক, আইনি, চিকিৎসা ইত্যাদি)।
- নোট: এটি সহজ ভাষায় সারসংক্ষেপ; সন্দেহ হলে ইংরেজি লাইসেন্স পাঠই প্রাধান্য পাবে।

## প্রমাণ লেবেল

সব নথির জন্য একই সেট (পুরোনো বানান বন্ধনীতে):
- **[পরিমাপকৃত]** (TR: ölçtüm, olctum): এই প্রকল্পে চালানো হয়েছে, প্রমাণের পথ আছে।
- **[পড়া]** (TR: okudum yol, okudum): উৎস বা স্ক্রিপ্ট পড়া হয়েছে, চালানো হয়নি।
- **[নকশা]** (TR: tasarım, tasarim): নকশা করা হয়েছে, বাস্তব রানে এখনো দেখা যায়নি।
- **[অনুমান]** (TR: tahmin): যাচাই করা হয়নি।
- **[চেষ্টা করা হয়নি]** (TR: denenmedi): কখনো চালানো হয়নি।
- **[ব্যবহারকারী জানিয়েছেন]** (TR: kullanıcı bildirdi): ব্যবহারকারী তারিখসহ জানিয়েছেন; স্বতন্ত্রভাবে পরিমাপ করা হয়নি।
- **[গণনা]** (TR: hesap; পুরোনো বানান: calculated, hesap): পরিমাপ করা ইনপুট থেকে পাওয়া সংখ্যা, নিজে পরিমাপ করা নয়; হিসাবের পদ্ধতি পাশে লেখা। পুরোনো লেখায় [proposal] / [öneri] = [অনুমান]।

বন্ধনীতে ব্যবহৃত রানের নাম (আমাদের নিজস্ব রানের নাম, এই রিপোজিটরির ফাইল নয়): U209 = রিলিজ বাইনারি দিয়ে `uret.ps1`-এর মাধ্যমে 209 ফ্রেম; B209 ও B192 = 209 ও 192 ফ্রেমে image-to-video (`-InitImg`) রান; B56VT2 = রিলিজ বাইনারি, 56 ফ্রেম, 56-ফ্রেম বাইট রেফারেন্স R0-এর সঙ্গে তুলনা; F209b, F209V2, F209V2K = ডেভেলপমেন্ট বিল্ডে 209-ফ্রেম রান (বিস্তারিত: `docs/OLCUMLER.md`)।

## জানা সীমাবদ্ধতা
- **বাইট প্রমাণ** (নিজে কীভাবে পুনরুৎপাদন করবেন: `docs/KANITLAR.md`, "R0 ve latent referansi nasil uretilir"; আমাদের sm_61 কার্ডে যাচাই করা, অন্য GPU-তে বাইট-অভিন্ন না-ও হতে পারে [অনুমান]): আমাদের প্যাচ সিরিজ দিয়ে (memory flag চালু) 56 ফ্রেমের রান sha256 `0979f156d548169b...` দিয়েছে, যা রেফারেন্সের সঙ্গে অভিন্ন [পরিমাপকৃত]; 141 ফ্রেমে latent-এর sha256 `E5D028F8632BE4FE...` অভিন্ন ছিল (0013/0014 flag সহ)। 158 থেকে 209 ফ্রেমের কোনো সরাসরি বাইট রেফারেন্স নেই; গেট-শৃঙ্খলই প্রমাণ। সংখ্যাগত গেট পাস করা ভালো ক্লিপের নিশ্চয়তা নয়: সময়ের সঙ্গে গতির সামঞ্জস্য চোখে দেখে যাচাই করা হয় (`docs/KAPILAR.md` দেখুন)।
- **209 ফ্রেম, কোন flag সেট:** 209-ফ্রেমের বাইট-শৃঙ্খলের প্রমাণ ডেভেলপমেন্ট বিল্ডে F209V2 flag সেট দিয়ে নেওয়া হয়েছে (block-tail flag নেই, 0019/0020 প্যাচ ছাড়া তৈরি); `uret.ps1` 209 ফ্রেমের জন্য এই রেসিপিই ব্যবহার করে [পড়া: স্ক্রিপ্ট; `uret.ps1`-এর মাধ্যমে বাস্তব ইঞ্জিন রান রান U209-এ পাস করেছে]।
- আমাদের দ্বারা একটি কার্ডে (GTX 1050 Ti 4 GB) যাচাইকৃত; অন্য কার্ডের বাইরের রিপোর্টগুলো লেবেলসহ `docs/KART_PROFILLERI.md`-এ তালিকাভুক্ত [ব্যবহারকারী জানিয়েছেন]।
- **কোন বাইনারি মাপা হয়েছে:** 141-ফ্রেমের latent ও বাইট-শৃঙ্খল আমাদের ডেভেলপমেন্ট বিল্ড দিয়ে মাপা হয়েছে। আপনি যে রিলিজ বাইনারি ডাউনলোড করেন সেটি নতুন বিল্ড: এর 56-ফ্রেম বাইট গেট পাস করেছে (পরের পয়েন্ট) এবং `uret.ps1`-এর মাধ্যমে 209-ফ্রেমের রান গেট পাস করেছে (রান U209, 3414 সেকেন্ড, VRAM সর্বোচ্চ 3777 MiB) [পরিমাপকৃত]; ডেভেলপমেন্ট-বিল্ডের 209 রানের তুলনায় latent বাইট-বাই-বাইট অভিন্ন; ভিডিওতে ফ্রেম (md5) ও অডিও অভিন্ন, AVI ফাইলের sha256 কন্টেইনারের কারণে আলাদা [পরিমাপকৃত] (`docs/OLCUMLER.md`, ভাগ 0 দেখুন)।
- **রিলিজ বাইনারি, 56 ফ্রেম:** রিলিজ বাইনারি (sd-cli `c5cebe78...`, stable-diffusion.dll `e5d3d329...`) R0-এর সঙ্গে বাইট-অভিন্ন 56-ফ্রেম ফল দিয়েছে (sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`; প্রতিটি ফ্রেমের md5 ও অডিও অভিন্ন), সরাসরি ডিফল্ট flag-এ চালানো (কোনো `SD_*` ভেরিয়েবল নেই), exit code 0, 601 সেকেন্ড [পরিমাপকৃত: রান B56VT2, 2026-11-19; প্রমাণ লেখকদের কাছে সংরক্ষিত, এই রিপোজিটরিতে নেই]। পরিসর: শুধু আমাদের sm_61 কার্ড ও 56 ফ্রেম; এটি clean-root ইনস্টল পরীক্ষা নয়; 141-ফ্রেম latent ও 209 শৃঙ্খল পুরোনো বাইনারিতে মাপা হয়েছিল এবং এই বাইনারিতে পুনরাবৃত্তি করা হয়নি [চেষ্টা করা হয়নি]। প্রথম প্রচেষ্টা (B56VT, সহায়ক স্ক্রিপ্টের মাধ্যমে) 58 সেকেন্ড পর নিঃশব্দে শেষ হয়ে গিয়েছিল, কারণ অজানা [অনুমান: memory pressure]; দ্বিতীয় প্রচেষ্টায় `sd-cli` সরাসরি চালানো হয়েছে।
- ইনস্টল ও রান স্ক্রিপ্ট ফাঁকা ফোল্ডার থেকে এখনো যাচাই হয়নি (clean-root পরীক্ষা বাকি)।
- রোডম্যাপ ও পরবর্তী পদক্ষেপ: `ROADMAP.md`।

## অবস্থা ও সীমাবদ্ধতা
- একটি মেশিনে যাচাই করা (GTX 1050 Ti 4 GB, 16 GB RAM, i7-7700HQ)। অন্য 4 GB কার্ড ও RAM-এর আকার ভিন্ন হতে পারে।
- **ডিফল্ট 209 ফ্রেম (8.7 সেকেন্ড):** আমাদের মান-গেট পাস করেছে (noise 1.08, রান F209V2K) [পরিমাপকৃত: রিলিজ বাইনারি দিয়ে `uret.ps1`-এর মাধ্যমে 209 ফ্রেম, রান U209; latent ডেভেলপমেন্ট-বিল্ডের রানের সঙ্গে বাইট-বাই-বাইট অভিন্ন; ভিডিওতে ফ্রেম ও অডিও অভিন্ন, ফাইলের sha কন্টেইনারের কারণে আলাদা; প্রমাণ লেখকদের কাছে সংরক্ষিত, এই রিপোজিটরিতে নেই]। 209 ফ্রেমে DiT-এর VRAM সর্বোচ্চ ছিল 4096 MiB-এর মধ্যে 3777 MiB (রান F209b ও U209; পুরো কার্ডের `nvidia-smi` রিডিং), সরু মার্জিন: অন্য GPU লোড (স্ক্রিন, অন্য অ্যাপ) রানকে `blocks.0`-এ ব্যর্থ করতে পারে; শুধু GTX 1050 Ti-তে পরীক্ষিত। ওই রানের সময় স্ক্রিনের অবস্থা নথিভুক্ত করা হয়নি; আপনার স্ক্রিন এই কার্ডে চললে কম VRAM পাওয়া যাবে [অনুমান: Windows স্ক্রিন লোড প্রায় 100-300 MB]; দরকার হলে স্ক্রিনকে integrated GPU-তে সংযুক্ত করুন [পরামর্শ, পরীক্ষিত নয়]। Sampling-এ লেগেছে 2730 সেকেন্ড (রান U209: steps 436-483 সেকেন্ড) এবং আলাদা-প্রসেস VAE decode-এ 173 সেকেন্ড (অডিও decode সহ ধাপ 2 মোট 193 সেকেন্ড) [পরিমাপকৃত: U209 রিলিজ বাইনারি; পুরোনো ডেভেলপমেন্ট রান: 2664 সেকেন্ড ও 174 সেকেন্ড]। ধাপ 1-এ ইন-প্রসেস VAE-এর মেমোরি ফুরিয়ে গিয়ে temporal tiling-এ ফিরে গিয়েছিল (320 সেকেন্ড); সেই আউটপুট বাতিল, ভিডিও আসে tiling-বিহীন ধাপ 2 থেকে। U209-এ RAM সর্বোচ্চ মাপা হয়নি। 209 ফ্রেমের চেয়ে লম্বা ক্লিপ এই রিলিজের অংশ নয়।
- **Image-to-video (`-InitImg`):** শুরুর ছবি থাকলে এই GPU-তে সীমা 192 ফ্রেম (24 fps-এ 8.0 সেকেন্ড): 209 ফ্রেম ধরেনি (block 0-তে প্রায় 17.5 MB VRAM কম: দরকার 2587 MB, আছে 2570 MB); 192 ফ্রেম `uret.ps1`-এর মাধ্যমে 3086 সেকেন্ডে চলেছে, VRAM সর্বোচ্চ 3783 MiB এবং গেট পাস [পরিমাপকৃত: রান B209 ও B192, 2026-11-20, একটি দৃশ্য; প্রমাণ লেখকদের কাছে সংরক্ষিত, এই রিপোজিটরিতে নেই]। অন্য GPU-তে চেষ্টা করা হয়নি [চেষ্টা করা হয়নি]।
- **ফাঁকা RAM গুরুত্বপূর্ণ:** আপনার প্রায় 11 GB ফাঁকা RAM লাগবে (ইঞ্জিন প্রসেস প্রায় 11 GB ধরে রাখে) [পরিমাপকৃত]। ফাঁকা RAM খুব কম হলে প্রসেস কোনো ত্রুটি বার্তা ছাড়াই মরে যেতে পারে [অনুমান: আমরা একবার এটি দেখেছি, যখন প্রায় 300 MB RAM ফাঁকা ছিল এবং `sd-cli` প্রায় 10 GB ধরে রেখেছিল]। চলার সময় অন্য বড় প্রোগ্রাম খুলবেন না: 16 GB মেশিনে মাত্র প্রায় 0.3-0.5 GB ফাঁকা থাকে, আর মেমোরি-চাপে রান নিঃশব্দে মরে যেতে পারে। শুরুর আগে ব্রাউজার, গেম ও অন্য বড় প্রোগ্রাম বন্ধ করুন এবং ফাঁকা RAM দেখে নিন।
- **Clean-root পরীক্ষা বাকি:** ইনস্টল ও রান স্ক্রিপ্ট শুধু এই নির্দেশনা দিয়ে ফাঁকা ফোল্ডারে এখনো যাচাই হয়নি; সেই পরীক্ষা (রেফারেন্সের সঙ্গে 56-ফ্রেম বাইট তুলনাসহ) নথিভুক্ত হলে এই অংশ হালনাগাদ হবে।
- এখানে তৈরি করা কোনো ভিডিও দেওয়া নেই।

<!-- i18n-source: README.md sha256:67497404d89b -->
