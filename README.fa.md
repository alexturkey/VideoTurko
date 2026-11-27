# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · فارسی · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

<div dir="rtl">

ترجمه‌ها از این README انگلیسی پیروی می‌کنند. اگر ترجمه‌ای تفاوت داشته باشد یا عقب بماند، متن انگلیسی مرجع است، به‌ویژه برای متن مجوز و امنیت ([`SECURITY.md`](SECURITY.md) و [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) فقط به انگلیسی و ترکی نگهداری می‌شوند).

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **پیش از شروع (مجوز، قلمرو):** این مخزن با مجوز MIT است و فقط وصله و اسکریپت دارد. مدل MiniMax H3 که دانلود می‌کند تحت MiniMax H3 Community License است: قلمرو آن اتحادیه اروپا، بریتانیا، کره جنوبی و ایالات متحده را کنار می‌گذارد و مدل، مشتق‌ها **و خروجی‌ها (ویدیوهایی که تولید می‌کنید)** را نباید در آن‌جا استفاده، توزیع یا نمایش داد (V.4). استفاده تجاری در چارچوب شرایط مجوز مجاز است. پیش از نصب [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) را بخوانید؛ این توصیه حقوقی نیست.

> **از یک عامل برنامه‌نویسی هوش مصنوعی (Codex, Claude Code, Gemini, Cursor) استفاده می‌کنید؟** فقط همین یک جمله را به او بدهید: «`AGENTS_HIZLI.md` را تا آخر بخوان، ابتدا `scripts\tani.ps1` را اجرا کن، پیشرفتت را در `DURUM.md` نگه دار، و پیش از حذف یا جابه‌جا کردن هر چیزی، تغییر Python سیستم یا PATH، پایین آوردن هر تنظیم کیفیت، یا پذیرفتن مجوز مدل به‌جای من، از من بپرس.» عامل این رایانه را عیب‌یابی می‌کند، یک فهرست بررسی می‌نویسد و در هر تصمیم از شما می‌پرسد؛ مجوز مدل همچنان تصمیم خود شماست.

> **در 30 ثانیه:** یک کارت گرافیک 4 GB می‌تواند یک ویدیوی MiniMax H3 با 209 فریم (8.7 ثانیه) را در یک گذر بسازد: روی یک دستگاه راستی‌آزمایی شده است (GTX 1050 Ti با 4 GB؛ نصب کامل با `kur.ps1` روی پوشهٔ خالی هنوز از ابتدا تا انتها راستی‌آزمایی نشده) [اندازه‌گیری‌شده: 209 فریم با باینری نسخهٔ انتشار (release) از طریق `uret.ps1`، اجرای U209؛ latent با اجرای نسخهٔ توسعه بایت‌به‌بایت یکسان است؛ فریم‌ها و صدا در ویدیو یکسان‌اند و sha فایل به‌دلیل کانتینر فرق دارد؛ مدارک نزد نویسندگان است و در این مخزن نیست]؛ با ‎`-InitImg`‎ (تصویر به ویدیو) حداکثر 192 فریم (8.0 ثانیه) [اندازه‌گیری‌شده: اجرای B192]؛ ساخت 209 فریم حدود 57 دقیقه طول می‌کشد و سقف زمانی پیش‌فرض 80 دقیقه است [اندازه‌گیری‌شده: اجرای U209]؛ 3 گام زیر روش اجرای آن است.

VideoTurko: وصله‌های حافظه برای stable-diffusion.cpp و دستورکارهای اجرا برای تولید ویدیو از متن با MiniMax H3 روی GTX 1050 Ti با 4 GB، تا 209 فریم (8.7 ثانیه) در یک گذر؛ تبدیل تصویر به ویدیو (‎`-InitImg`‎) تا 192 فریم (8.0 ثانیه) (209 فریم با زنجیرهٔ بایت‌به‌بایت راستی‌آزمایی شده است؛ در بررسی‌های 56 و 141 فریم، خروجی با اجرای بدون وصله بایت‌به‌بایت یکسان بود).

## شروع سریع (Windows، 3 گام)
**وضعیت: اسکریپت‌های نصب و اجرای زیر در حال تکمیل است و آزمون ریشهٔ تمیز (clean-root) هنوز انجام نشده؛ تا زمانی که آن آزمون موفق نشود، ادعا نمی‌شود که چیزی در اینجا کار می‌کند (بخش «وضعیت و محدودیت‌ها» را ببینید).**

1. این مخزن را **دانلود کنید** (دکمهٔ سبز **Code** و سپس **Download ZIP**) و در یک پوشهٔ با مسیر کوتاه، مثلاً `C:\vt`، از حالت فشرده خارج کنید.
2. **نصب: روی ‎`kur.cmd`‎ دوبار کلیک کنید** (یک پنجره سیاه باز می‌شود و هر مرحله را نشان می‌دهد؛ بستن آن نصب را متوقف می‌کند و اجرای دوباره از همان جا ادامه می‌دهد: فایل مدلی که نیمه‌کاره دانلود شده از سر گرفته می‌شود [خوانده‌شده: اسکریپت دانلود یک فایل ‎`.part`‎ نگه می‌دارد و از آن ادامه می‌دهد؛ از سرگیری کامل 29 GiB اندازه‌گیری نشد]). اگر Windows درباره فایل دانلودشده هشدار داد، به‌جای آن از دستور PowerShell زیر استفاده کنید [توصیه، روی ZIP دانلودشده آزموده نشده]. خط فرمان را ترجیح می‌دهید؟ در آن پوشه PowerShell را باز کنید (در نوار نشانی Explorer عبارت ‎`powershell`‎ را بنویسید) و همان نصب را اجرا کنید:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   ریشهٔ نصب همان پوشه‌ای است که از حالت فشرده خارج کرده‌اید (موتور در `engine\bin` و مدل‌ها در `model` قرار می‌گیرند)؛ برای مکان دیگر، ابتدا متغیر محیطی `VT_ROOT` را تنظیم کنید. اسکریپت GPU، درایور، RAM و دیسک را بررسی می‌کند، موتور و مدل‌ها را دریافت می‌کند (فایل‌های zip موتور و فایل‌های مدلی که تازه دانلود شده‌اند با sha256 بررسی می‌شوند؛ فایل مدلی که از قبل با اندازهٔ درست موجود باشد فقط از نظر اندازه بررسی می‌شود و برای بررسی کامل sha256 باید `scripts\modelleri_indir.ps1 -Dogrula` را اجرا کرد)، یک بررسی واقعی کوتاه انجام می‌دهد و فقط اگر آن بررسی موفق باشد READY چاپ می‌کند [طراحی: `kur.ps1` به‌طور کامل در یک پوشهٔ تمیز اجرا نشده؛ این جمله پس از آزمون پوشهٔ تمیز به‌روز می‌شود]. گزینهٔ ‎`-ExecutionPolicy Bypass`‎ فقط برای همین یک پردازش اعمال می‌شود؛ مثل هر نصب‌کننده‌ای، ابتدا `scripts\kur.ps1` را بخوانید.
   فایل zip موتور از نسخهٔ انتشار (release) v0.1.0 در GitHub دریافت می‌شود (منتشرشده در 2026-11-19؛ sha256 آن در `kur.ps1` ثابت شده است). اگر آفلاین هستید یا موتور را خودتان ساخته‌اید، zipهای محلی را بدهید: ‎`-MotorZip <path> -CudaZip <path>`‎. zip محلی هم با همان sha256 ثابت‌شده بررسی می‌شود (فایل `.sha256` کنار آن نادیده گرفته می‌شود)، پس باید همان zip انتشار باشد؛ برای ساخت خودتان ابتدا ‎`VT_MOTOR_SHA256`‎ / ‎`VT_CUDA_SHA256`‎ را برابر sha256 آن قرار دهید. sha256 نادرست با exit 1 متوقف می‌کند. فقط `.exe`/`.dll` به `engine\bin` می‌روند؛ مجوزها و README در `engine\lisanslar\<zip name>\`‎ قرار می‌گیرند. [آزموده‌شده با zipهای dist پیش از انتشار: فایل کناری `.sha256` به‌همراه هشدار ارجاع به خود، باینری و DLLها در جای خود قرار گرفتند، `sd-cli --help` اجرا شد؛ sha باینری‌های نصب‌شده مطابقت داشت (`c5cebe78...`‎، `e5d3d329...`‎)؛ گام مدل و بررسی 5 فریمی `kur.ps1` هنوز روی GPU واقعی اجرا نشده است]
   **مجوز مدل:** پیش از گام مدل، نصب‌کننده خلاصهٔ مجوز را چاپ می‌کند (`docs/LISANS_KABUL.txt`؛ متن کامل `docs/LISANS_UYARISI.md`: مجوز MiniMax H3 Community License، محدودیت‌های قلمرو که ویدیوهای تولیدشده را هم دربرمی‌گیرد، و قواعد تجاری و برچسب هوش مصنوعی) و از شما می‌خواهد بپذیرید (`E` = بله). ابتدا آن را بخوانید. برای اجرای بدون نظارت می‌توانید ‎`-LisansKabul E`‎ بدهید که یعنی خودتان مجوز را خوانده و پذیرفته‌اید؛ آن را برای شخص دیگری اضافه نکنید. (عامل‌های هوش مصنوعی: از `AGENTS.md` پیروی کنید؛ هرگز بدون رضایت کاربر E را وارد نکنید.) بدون پذیرش، `kur.ps1` با کد خروج 2 متوقف می‌شود و هیچ مدلی دانلود نمی‌کند.
3. **اولین ویدیوی شما (56 فریم، حدود 11 دقیقه روی GTX 1050 Ti ما** [اندازه‌گیری‌شده: 641 ثانیه، اجرای R0، ‎`docs/OLCUMLER.md`‎؛ کارت‌های دیگر اندازه‌گیری نشدند]**)**: وقتی نصب‌کننده ‎`HAZIR / READY`‎ را چاپ کرد، این را اجرا کنید
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (میان‌بر: فایل متنی پرامپت را روی ‎`uret.cmd`‎ بکشید و رها کنید، یا ‎`uret.cmd docs\ornek_istem_R0.txt`‎ را اجرا کنید: همان اجرای 56 فریمی). ویدیو در ‎`runs\`‎ است. سپس پرامپت خودتان را در یک فایل متنی بنویسید (یک پاراگراف انگلیسی، جمله اختیاری ‎`audio:`‎) و طولانی‌ترین کلیپی را که پوشش می‌دهیم اجرا کنید (پیش‌فرض، حدود 57 دقیقه [اندازه‌گیری‌شده: اجرای U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   مقدار ‎`-Kare`‎ از شبکهٔ 17k+5 پیروی می‌کند (39، 56، 73، ... 192، 209)؛ پیش‌فرض 209 است (8.7 ثانیه) که بلندترین طولی است که پوشش می‌دهیم. VAE در یک پردازش جداگانه اجرا می‌شود و هرگز کاشی‌کاری (tiling) نمی‌شود [اجرای واقعی موتور از طریق `uret.ps1` با باینری انتشار و VAE در پردازش جدا، در اجرای U209 موفق بود].

   راهنمای نوشتن پرامپت: [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (الگوی یک نمای پیوسته، بازه‌های زمانی مساوی، دو نمونهٔ کامل).

| نیازمندی | مقدار |
|---|---|
| سیستم‌عامل | Windows 10/11، 64 بیتی |
| GPU | NVIDIA با 4 GB یا بیشتر؛ فقط روی GTX 1050 Ti (sm_61) آزموده شده؛ حاشیهٔ باریک (3777/4096 MiB در 209 فریم): صفحه‌نمایش پرمصرف یا مرورگر باز می‌تواند اجرا را خراب کند؛ هیچ کارت 4 GB دیگری آزموده نشده |
| RAM | 16 GB (اوج حدود 11 GB؛ برنامه‌های دیگر را ببندید) |
| دیسک | دست کم 32 GiB فضای خالی (40 GiB یا بیشتر توصیه می‌شود: بین 32 و 40 نصب‌کننده هشدار چاپ می‌کند، ‎`[VT-W-DISK-PAY]`‎ [اندازه‌گیری‌شده: اجرای‌های ‎`-Kuru`‎ با دیسک شبیه‌سازی‌شده])، مدل‌ها روی SSD (ترجیحاً NVMe) |
| دانلود | zip موتور 36.8 MB + zip زمان‌اجرای CUDA حجم 567.5 MB [اندازه‌گیری‌شده] + مدل‌ها 31,473,112,040 بایت (حدود 29.3 GiB) [خوانده‌شده: اندازه‌ها در `scripts/modeller.json`]؛ در مجموع حدود 30 GiB |
| مدل‌ها | همراه نیستند؛ نصب‌کننده آن‌ها را تحت مجوز MiniMax دریافت می‌کند (هشدار زیر را ببینید). مدل‌ها (29.3 GiB، 31,473,112,040 بایت در `scripts/modeller.json`) در این مخزن یا انتشار نیستند: محدودیت‌های اندازهٔ فایل/انتشار GitHub اعمال می‌شود و `kur.ps1` آن‌ها را از منبع رسمی همراه با تأیید sha256 دانلود می‌کند. |

کدهای خروج `kur.ps1`: 0 READY، 1 خطا، 2 ورودی کاربر لازم است (مجوز، یا هنوز انتشار/zip وجود ندارد)، 3 سخت‌افزار یا دیسک ناکافی، 4 متوقف شده (فایل DUR). `uret.ps1` نتیجه را فقط وقتی می‌پذیرد که فایل `.avi` وجود داشته باشد، تعداد فریم درست باشد و لاگ‌ها تمیز باشند [اندازه‌گیری‌شده: یک اجرای واقعی از طریق `uret.ps1` با باینری انتشار، اجرای U209، 209 فریم، دروازه (gate) را گذراند]. کدهای خروج `uret.ps1`: 0 DONE (دروازهٔ کیفیت را گذراند)، 1 خطا یا خروجی نامعتبر (از جمله ویدیوی بدون جریان صدا)، 2 متوقف شده (فایل DUR)، 5 `KAPI RED` (دروازهٔ کیفیت را نگذراند: کلیپ پذیرفته نمی‌شود و تصمیم با شماست)، 6 دروازه اجرا نشد (کلیپ پذیرفته نمی‌شود). جزئیات در AGENTS.md. [اندازه‌گیری‌شده: کدهای خروج 0، 1 (ویدیوی بی‌صدا)، 5 و 6 در سناریوهایی با موتور جعلی و دروازهٔ جعلی؛ موتور واقعی: exit 0 در اجرای U209]

### عیب‌یابی (جزئیات: `docs/SIK_HATALAR.md`)
خطوط خطای اسکریپت‌های ما یک کد ثابت دارند، مثلاً ‎`HATA: [VT-E-DLL] ...`‎ یا ‎`UYARI: [VT-W-DISK-PAY] ...`‎. کد را در [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) (نمونه لنگر ‎`#vt-e-dll`‎) یا در ‎`docs/hata_imzalari.json`‎ جست‌وجو کنید و کد را در issue خود بنویسید. ستون اول جدول زیر همان‌طور که چاپ می‌شود می‌ماند (کدها و متن گزارش را ترجمه نکنید).

| آنچه می‌بینید | معنی و کاری که باید کرد |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | `sd-cli.exe` را دستی اجرا نکنید؛ `scripts\kur.ps1` را اجرا کنید که DLLهای CUDA را سر جایشان می‌گذارد. |
| `failed during weight preparation` در `blocks.0` (#1, #3, #5) | VRAM در دروازهٔ حافظه کافی نیست: تعداد فریم کمتری از شبکهٔ 17k+5 انتخاب کنید، برنامه‌های دیگری که از GPU استفاده می‌کنند را ببندید و پرچم‌های همراه را تغییر ندهید. |
| `retrying with temporal tiling` (#6) | VAE به کاشی‌کاری برگشته است؛ خروجی برای اهداف کیفی نامعتبر است. دوباره اجرا کنید. |
| اجرا در سقف زمانی تمام می‌شود، ویدیویی نیست (#7) | برای کلیپ‌های بلند ‎`-TavanDk`‎ را بالا ببرید (سقف زمانی پیش‌فرض: 80 دقیقه برای 209 فریم، تعیین‌شده توسط `uret.ps1`؛ اجرای 209 فریمی ما 57 دقیقه طول کشید [اندازه‌گیری‌شده: اجرای U209]). |
| کد خروج خالی است ولی «finished» نوشته شده (#14) | پوشش (wrapper) کد خروج را زیادی زود خوانده؛ دوباره اجرا کنید و وجود فایل ویدیو را بررسی کنید. |
| سیستم کند می‌شود، swap فعال است (#18) | موتور حدود 10-11 GB RAM مصرف می‌کند؛ مرورگرها و برنامه‌های دیگر را ببندید. |
| ناهمخوانی sha256 / شکست دانلود | معمولاً دانلود نیمه‌کاره قطع شده است: همان دستور را دوباره اجرا کنید، فایل‌های تأییدشده رد می‌شوند. |

**گیر کرده‌اید یا کنجکاوید؟** [`SUPPORT.md`](SUPPORT.md) (کجا بپرسید؛ زمان پاسخ هدف است، تعهد نیست) · [`PRIVACY.md`](PRIVACY.md) (بدون تله‌متری؛ شبکه فقط برای دانلود موتور و مدل‌ها از میزبان‌های فهرست‌شده استفاده می‌شود) · [`SECURITY.md`](SECURITY.md) (گزارش خصوصی) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (اولین pull request در 5 مرحله؛ برای مستندات و اسکریپت‌ها GPU لازم نیست).

### تازه‌های v0.1.1: گزینه‌های بیشتر (جزئیات: `AGENTS.md`، `docs/SIK_HATALAR.md` 19-23)
بدون این گزینه‌ها روی کارت 4 GB هیچ چیز تغییر نمی‌کند (بررسی بایتی 56 فریمی در برابر مرجع ما با v0.1.1 دوباره موفق بود [اندازه‌گیری‌شده]). برای دیدن آنچه اجرا خواهد شد، ‎`-Kuru`‎ را به هر دستوری اضافه کنید.
- گزینهٔ ‎`-EndImg`‎: فریم آخر را هم بدهید (فریم اول و آخر، "FLF")؛ سقف روی کارت‌های زیر 8 GB برابر 175 فریم است (192 روی 4 GB جا نشد) و روی کارت‌های 8 GB و بیشتر 192. روی GTX 1050 Ti ما همیشه در دو پردازش اجرا می‌شود: 56 فریم 1040 ثانیه، 175 فریم 2887 ثانیه (48 دقیقه)، و هر دو از دروازه گذشتند [اندازه‌گیری‌شده]. نکته‌های نوشتن درخواست (prompt): `docs/ISTEM_YAZIMI.md`.
- گزینه‌های ‎`-W`‎ / ‎`-H`‎: اندازه‌های دیگر، مثلاً عمودی 384x640؛ مضرب 32، با مساحت دست‌کم 640x384 (هرگز کوچک‌تر نه). روی 4 GB آزموده نشده؛ روی کارت‌های زیر 8 GB اندازه‌هایی که از بزرگ‌ترین کار اندازه‌گیری‌شدهٔ ما فراتر بروند رد می‌شوند. آستانه‌های دروازهٔ کیفیت برای 640x384 تنظیم شده‌اند.
- گزینهٔ ‎`-TekAsama`‎: یک پردازش به‌جای دو پردازش، فقط برای کارت‌های بزرگ؛ هرگز خودکار روشن نمی‌شود.
- GPUهای جدیدتر (compute capability 7.0 و بالاتر، مثلاً RTX 20/30/40): اگر خودتان `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` را تنظیم نکرده باشید، به‌طور خودکار تنظیم می‌شود؛ این کار مشکل ویدیوی کاملاً سیاه در 141 فریم و بیشتر را روی RTX 4070 Ti گزارش‌دهنده برطرف کرد [گزارش کاربر: issue #1]. بدون Python + OpenCV، `uret.ps1` اکنون پیش از کار GPU با exit 6 متوقف می‌شود (ویدیویی ساخته نمی‌شود و RED گمراه‌کننده‌ای هم در کار نیست).
- از @SinanC73 برای گزارش RTX 4070 Ti که به این تغییرات انجامید سپاسگزاریم ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1)).

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

## پروفایل‌های اختیاری سرعت (بستهٔ سرعت؛ به‌طور پیش‌فرض خاموش)
هیچ‌یک از موارد زیر اجرای پیش‌فرض را تغییر نمی‌دهد (640x384، 209 فریم، 3414 ثانیه روی کارت ما). این‌ها سه خانهٔ اندازه‌گیری‌شده فراتر از آن هستند و هرکدام یک پروفایل نام‌دار از ‎`uret.ps1`‎ است؛ به موتور بستهٔ سرعت نیاز دارند (موتور انتشار به‌علاوهٔ وصله‌های 0021، 0023، 0024 که همگی به‌طور پیش‌فرض خاموش‌اند: ‎`docs/YAMALAR.md`‎). آن را با ‎`scripts\kur.ps1 -HizPaketi`‎ نصب کنید (zip محلی با ‎`-MotorZip`‎ کار می‌کند) و سپس ‎`-Profil <name>`‎ را اضافه کنید؛ ‎`-Kuru`‎ چاپ می‌کند چه چیزی اجرا می‌شد. بستهٔ سرعت با نسخهٔ v0.1.4 منتشر می‌شود.

| پروفایل | اندازه، طول | زمان کل روی GTX 1050 Ti 4 GB | وضعیت |
|---|---|---|---|
| (هیچ، پیش‌فرض) | 640x384، تا 209 فریم (8.7 ثانیه) | 209 فریم: 3414 ثانیه | تأیید‌شده، بدون تغییر |
| ‎`yuksek832`‎ | 832x480، 141 فریم (5.9 ثانیه) | حدود 55-56 دقیقه | قابل‌استفاده، دو پرامپت [اندازه‌گیری‌شده] |
| ‎`yuksek832 -Kare 124`‎ | 832x480، 124 فریم (5.2 ثانیه) | حدود 45-46 دقیقه، بدون نیاز به پرچم سرعت | قابل‌استفاده، دو پرامپت [اندازه‌گیری‌شده] |
| ‎`yuksek896`‎ | 896x512، 124 فریم (5.2 ثانیه) | حدود 56-57.5 دقیقه | قابل‌استفاده، دو پرامپت [اندازه‌گیری‌شده] |
| ‎`uzun260`‎ | 640x384، 260 فریم (10.8 ثانیه) | حدود 71 دقیقه [اندازه‌گیری‌شده: 70.7 دقیقه به‌صورت سرتاسری از طریق ‎`uret.ps1`‎ با خروج زودهنگام؛ 78 دقیقه بدون آن] | نزدیک حد حافظه اجرا می‌شود؛ پرامپت تا حدود 2000 نویسه اندازه‌گیری شده است |

- **حاشیهٔ تنگ:** در 832x480 x 141 دروازهٔ حافظه فقط حاشیه‌ای تک‌رقمی بر حسب MB باقی می‌گذارد (5.7 و 6.8 MB در دو اجرای کامل). دو پرامپت بلند (1520 و 2041 نویسه) فقط با خواندن دروازه برای گام 1 و بخشی از گام 2 بررسی شدند و کامل اجرا نشدند: حاشیه 10.9 و 4.0 MB. هر فرایند دیگری که حافظهٔ کارت را نگه دارد (مرورگر، نمایشگر دوم) می‌تواند باعث شکست شود؛ در آن صورت از ‎`-Kare 124`‎ یا اندازهٔ پیش‌فرض استفاده کنید [اندازه‌گیری‌شده، GTX 1050 Ti 4 GB].
- **‎`uzun260`‎ نزدیک حد حافظه اجرا می‌شود:** اوج VRAM برابر 3861-3903 از 4096 MiB. سه اجرای کامل (دو صحنه)؛ مصرف حافظهٔ اشتراکی 28 تا 61 MiB در برابر حد 68 MiB بیشتر شد. پرامپت‌ها در اجراهای کامل تا 1403 نویسه و با خواندن دروازه تا 2009 نویسه اندازه‌گیری شدند؛ در 2527 نویسه از حد حافظهٔ اشتراکی فراتر رفت. در این طول مرجعی بدون پرچم برای برابری بایت‌به‌بایت وجود ندارد. برنامه‌های دیگری را که از GPU استفاده می‌کنند ببندید؛ اگر اجرا شکست خورد از 209 فریم پیش‌فرض استفاده کنید. وصلهٔ 0023 فقط برای همین یک خانه پذیرفته شده است.
- **عرضه نمی‌شود:** 832x480 با 158 فریم با وصله‌های همراه جا نمی‌شود (در دروازهٔ گام 2 حدود 280 MB کم می‌آید)؛ 175 فریم فقط با خواندن دروازه بررسی شد (در بلوک اول حدود 275 MB کم بود، اجرای کامل نشد). این پروفایل فقط 141 فریم عرضه می‌کند. اندازه‌ها و تعداد فریم‌های دیگر را ‎`-Profil`‎ رد می‌کند (از مسیر پیش‌فرض استفاده کنید).
- کیفیت پیش‌فرض دست‌نخورده است: 6 گام، cfg 1، VAE بدون کاشی، 17k+5 فریم. جایی که پرچم‌ها روشن‌اند، خروجی در اندازه‌هایی که اجرای بدون پرچم در آن‌ها جا می‌شود بایت‌به‌بایت با ویدیوی بدون پرچم مقایسه شد (‎`docs/YAMALAR.md`‎)؛ در 832x480 x 141 و 896x512 x 124 اجرای بدون پرچم جا نمی‌شود، پس برابری آنجا بر نزدیک‌ترین خانه‌ها استوار است نه بر مقایسهٔ مستقیم [اندازه‌گیری‌شده، خوانده‌شده].
- مرحلهٔ 1 اجرای دومرحله‌ای اکنون به‌محض کامل شدن فایل latent پایان می‌یابد (‎`VT_ERKEN_CIKIS=0`‎ آن را خاموش می‌کند).

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

## این پروژه چیست
مجموعه‌ای از وصله‌های کوچک حافظه/زمان‌بندی برای stable-diffusion.cpp، به‌همراه دستورکار اجرا، بررسی‌ها و اندازه‌گیری‌ها، که امکان اجرای MiniMax H3 (یک DiT با 33B؛ ما GGUF مدل HyperFlow Flash 13.7B با Q4_K_M را اجرا می‌کنیم؛ رمزگذار متن Qwen3-VL با 32B جداست) را روی یک GPU نسل Pascal با 4 GB (GTX 1050 Ti، با 16 GB RAM سیستم) فراهم می‌کند.
- طول‌های تک‌گذری که واقعاً تولید کردیم و دروازه‌های کیفیت ما را گذراندند: 56، 141، 158، 175، 192، 209 فریم با 640x384 و 24 fps (209 فریم = 8.7 ثانیه)، با صدایی که خود H3 تولید می‌کند [اندازه‌گیری‌شده: 209 فریم با باینری نسخهٔ انتشار (release) از طریق `uret.ps1`، اجرای U209؛ latent با اجرای نسخهٔ توسعه بایت‌به‌بایت یکسان است؛ فریم‌ها و صدا در ویدیو یکسان‌اند و sha فایل به‌دلیل کانتینر فرق دارد؛ مدارک نزد نویسندگان است و در این مخزن نیست]. 209 بلندترین طولی است که تماشا کردیم و روان یافتیم [گزارش کاربر: 2026-11-19، ویدیو کامل تماشا شد؛ فایل: خروجی F209V2، 8.708 ثانیه].
- **ادعای یکسانی بایتی، با دامنهٔ صادقانه:** یکسانی بایت‌به‌بایت خروجی‌ها با مرجع بدون وصله فقط برای 56 و 141 فریم بررسی شده است. برای 158/175/192/209 فریم از همان پرچم‌ها و همان زنجیرهٔ باینری استفاده کردیم؛ مرجع بایتی مستقیم وجود ندارد (نسخهٔ بدون وصله روی این GPU نمی‌تواند این طول‌ها را اجرا کند).
- تنظیمات کیفیت هرگز پایین آورده نمی‌شود: همان مدل/کوانتیزاسیون، 6 گام، cfg 1، 640x384، همان seed، VAE بدون کاشی‌کاری.
- ادعا نمی‌کنیم که اولین هستیم: جست‌وجو کردیم و نمونهٔ بیرونی‌ای از این کار روی 4 GB پیدا نکردیم، که دلیل بر نبودن آن نیست.

## ساختار پوشه‌ها
- `patches/` وصله‌ها روی یک commit مشخص‌شده (pinned) از stable-diffusion.cpp (یادداشت‌های آنجا را ببینید)
- `scripts/` ساخت (build)، اجرا، VAE در پردازش جدا، و کمک‌ابزارهای دروازه/سازگاری (`doku_norm.py`: یادداشت مقیاس زیر را ببینید)
- `docs/KURULUM.md` سخت‌افزار، مراحل ساخت و اجرا (EN+TR)
- `docs/YAMALAR.md` فهرست وصله‌ها، `docs/KANITLAR.md` مدارک، `docs/KAPILAR.md` جدول دروازه‌های کیفیت، `docs/OLCUMLER.md` اندازه‌گیری‌ها، `docs/SIK_HATALAR.md` خطاهای رایج، `docs/LISANS_UYARISI.md` همهٔ بندهای مجوز
- فهرست کوتاه `scripts/`: `hiz_kos3.ps1` پوشش اجرا (‎`-Kuru`‎ دستور دقیق را چاپ می‌کند)، `uretim_kapi.ps1` دروازهٔ کیفیت، `dikis_denetim.py` بررسی درز (محل اتصال)، `doku_norm.py` نویز نرمال‌شده با بافت، `bayt_kiyas.py` مقایسهٔ بایتی، `derleme_sablonu.ps1` قالب ساخت (فقط پردازش کمکی تله‌متری Visual Studio یعنی `vctip.exe` را که پس از شروع خود ساخت راه افتاده متوقف می‌کند، چون در غیر این صورت پردازش ساخت را چند دقیقه متصل نگه می‌دارد؛ سایر پردازش‌های `vctip.exe` دست‌نخورده می‌مانند)

## دروازه‌های کیفیت (نتیجه چگونه پذیرفته می‌شود)

این دروازه سازگاری حرکت (جهش در اندازه یا موقعیت اشیا) را بررسی نمی‌کند: پیش از پذیرفتن، کل ویدیو را تماشا کنید.
1. تعداد فریم و وجود صدا؛ و در لاگ هیچ خط مربوط به fallback حافظه یا ALLOC_FAILED نباشد.
2. دروازهٔ نویز خام: باقی‌ماندهٔ فیلتر میانه حداکثر 1.5 (مقیاس 0-255).
3. نویز نرمال‌شده با بافت، `scripts/doku_norm.py` (نسخهٔ این مخزن): N = باقی‌ماندهٔ میانه / بافت Sobel، برای هر 6 فریم یک فریم. **یادداشت مقیاس:** در این نسخه، 10 کلیپ اندازه‌گیری‌شده N = 0.034-0.052 می‌دهند (جدول در `docs/KAPILAR.md`؛ ربع آخر F192/F209V2 به 0.062 می‌رسد) و آستانهٔ دروازهٔ اضافی N حداکثر 0.065 است. یک پیاده‌سازی دیگر روی همان کلیپ‌ها 0.028-0.036 اندازه گرفت، پس آستانه‌ها بین نسخه‌ها قابل جایگزینی با یکدیگر نیستند. روی بافت‌های بسیار ریز (ردیف‌های چمن)، N تمیز برابر 0.075 بود، بنابراین آستانه برای هر خانوادهٔ صحنه جداست. یک برآوردگر استوار فرکانس بالا (sigma-HH حداکثر 1.5؛ تمیز 0.74-1.19، نویز افزوده با s=2 مقدار 2.2-3.0 می‌دهد) دروازهٔ اضافی پیشنهادی است.

دامنه: VideoTurko درباره یک گذر واحد است (تا 209 فریم، حدود 8.7 ثانیه). آزمون زنجیره‌سازی خود ما درزهای قابل‌مشاهده نشان داد (صحنه تمیز ادامه نمی‌یابد)، پس فیلم‌های بلندتر جزو چیزهایی نیستند که راستی‌آزمایی می‌کنیم. برای زنجیره‌سازی راهنمای جامعه `docs/KLIP_ZINCIRI.md` و ابزار کمکی ما که فقط CPU به کار می‌برد `scripts/zincir.py` وجود دارد (`plan`، `son-kare`، `bagla`؛ هرگز موتور را اجرا نمی‌کند)؛ کیفیت فیلم‌های زنجیره‌ای را اندازه نگرفته‌ایم [آزموده‌نشده]، پس هر درز را با چشم و با `scripts/dikis_denetim.py` بررسی کنید.
تنظیمات مال خودتان است: 209 فریم پیش‌فرض آزموده‌شدهٔ ما روی کارت 4 GB است، نه سقفی که ملزم به رعایتش باشید. هر تعداد فریم از شبکهٔ 17k+5 را انتخاب کنید (39، 56، 73، ... 192، 209؛ `docs/KURULUM.md` را ببینید)، و prompt، seed، وضوح یا هر پرچمی را به دلخواه تغییر دهید. کلیپ‌های کوتاه‌تر حافظه و زمان کمتری لازم دارند؛ GPUهای بزرگ‌تر ممکن است بیشتر را جا بدهند.

## هشدار مجوز مدل
**VideoTurko فقط شامل وصله‌ها و اسکریپت‌هاست (MIT)؛ هر کس از مدل و خروجی‌های آن استفاده می‌کند، خودش مسئول مجوز MiniMax است.** مشاورهٔ حقوقی نیست. در ادامه، بندهای MiniMax H3 Community License (2 آگوست 2026) با شماره‌هایشان خلاصه شده است؛ آنچه الزام‌آور است خود مجوز است: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

مجوز MIT این مخزن وزن‌های مدل را پوشش نمی‌دهد؛ [`NOTICE`](NOTICE) را ببینید. این مخزن هیچ وزن مدلی ندارد (نه فایل MiniMax H3، نه HyperFlow-H3-Flash GGUF و نه VAE). این پروژه وابسته به MiniMax نیست و از سوی MiniMax تأیید نشده است. استفادهٔ تجاری ممنوع نیست (این مجوز غیرتجاری نیست)؛ شرایط در ادامه آمده است.

**قلمرو (Applicable Territory)**
- **Preamble، I.3، I.5:** سراسر جهان، به‌جز اتحادیهٔ اروپا، بریتانیا، جمهوری کره (کرهٔ جنوبی) و ایالات متحده. استفاده از مدل به‌منزلهٔ پذیرش مجوز است.
- **II:** مجوزی محدود، غیرقابل‌انتقال و بدون حق‌امتیاز (royalty-free) برای استفاده، تکثیر، توزیع، ساخت آثار مشتق و تغییر، فقط درون قلمرو و مطابق با قرارداد و Exhibit A. افراد در قلمروهای مستثنا می‌توانند از MiniMax مجوز جداگانه بخواهند.
- **V.4:** استفاده، تکثیر، تغییر، توزیع یا نمایش مدل، مشتقات آن و **خروجی‌های آن** (ویدیو/صدای تولیدشده) خارج از قلمرو مجاز نیست. **بنابراین انتشار یا نمایش ویدیوهای تولیدشده در اتحادیهٔ اروپا/بریتانیا/کرهٔ جنوبی/ایالات متحده خارج از مجوز است.**
- **Exhibit A-1:** استفاده خارج از قلمرو، سیاست استفادهٔ قابل‌قبول (Acceptable Use Policy) را نقض می‌کند.

**توزیع (III)** (این مخزن مدل را توزیع نمی‌کند؛ اگر شما توزیع می‌کنید)
- **III.1:** به هر دریافت‌کننده یک نسخه از مجوز بدهید. **III.2:** فایل‌های تغییرداده‌شده را با اعلان‌های برجسته علامت‌گذاری کنید.
- **III.3:** توصیه‌شده (نه اجباری): اعلان "Powered by MiniMax H3"، شناسهٔ تولید با هوش مصنوعی روی فایل‌های تولیدشده، و یک نوشتهٔ عمومی.
- **III.4:** توزیع‌ها حتماً باید با یک فایل NOTICE همراه باشند که حاوی این عبارت است: "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12:** انتشار محتوا در هر محیط عمومی بدون اعلام روشن اینکه ماشینی تولید شده است ممنوع است: ویدیوهای تولیدشده با هوش مصنوعی را هنگام انتشار برچسب بزنید (فهرست کامل: `docs/LISANS_UYARISI.md`).
- **III (بند آخر):** می‌توانید حق نشر خودتان را بر تغییرات خود بیفزایید، اما نمی‌توانید شرایط اضافه یا متفاوتی بر استفاده/توزیع تحمیل کنید؛ قواعد قلمرو همچنان اعمال می‌شود.

**شرایط تجاری (IV)**
- **IV.1:** اگر محصولات/خدمات تجاری شما بیش از 20 میلیون دلار آمریکا (USD) (یا معادل آن) درآمد سالانه ایجاد می‌کنند، پیشاپیش از api@minimax.io مجوز کتبی بگیرید (موضوع: "MiniMax H3 licensing - authorization request").
- **IV.2:** رابط کاربری محصول/خدمت تجاری‌ای که از مدل استفاده می‌کند باید «MiniMax H3» را به‌طور برجسته نمایش دهد.

**محدودیت‌های استفاده (V)**
- **V.1:** از قوانین قابل‌اعمال (از جمله انطباق تجاری) و Exhibit A پیروی کنید. **V.2:** هر کسی را که به او دسترسی می‌دهید با شرایطی که دست‌کم به‌اندازهٔ این محدودیت‌ها حمایتی باشد متعهد کنید و به او اطلاع بدهید.
- **V.3:** نمی‌توانید از مدل یا **خروجی‌های آن** برای بهبود هیچ مدل هوش مصنوعی دیگری (به‌جز MiniMax H3 و مشتقات آن) استفاده کنید. (I.11: تقطیر (distillation) و آموزش روی خروجی‌های مصنوعی، مدل را «مشتق» می‌کند؛ خود خروجی‌ها مشتق نیستند.)
- **V.5:** اگر به اشخاص ثالث محصول/خدمت/خدمت میزبانی‌شده‌ای ارائه می‌کنید که با مدل خروجی تولید می‌کند: پیش از راه‌اندازی و در تمام مدت بهره‌برداری، تدابیر حفاظتی فنی و سازمانی معقول، سازوکار گزارش‌دهی، بررسی فوری، و حذف/غیرفعال‌سازی/تعلیق متخلفان تکراری.

**علامت تجاری و حقوق (VI)**
- **VI.1:** آثار مشتق و مشتقات مدلی که می‌سازید مال شماست (با رعایت حقوق MiniMax). **VI.2:** نام‌ها/علامت‌های MiniMax مجوز ندارند (فراتر از آنچه برای توصیف و توزیع لازم است)؛ علامت «MiniMax H3» فقط برای رعایت III.3 و درون قلمرو قابل استفاده است؛ وابستگی را القا نکنید.
- **VI.3:** اگر از MiniMax یا هر کس دیگری شکایت کنید و ادعا کنید مواد/خروجی‌ها حقوق شما را نقض می‌کنند، همهٔ مجوزهای شما همان روز پایان می‌یابد؛ شما در برابر ادعاهای اشخاص ثالث ناشی از استفاده/توزیع خودتان یا دیگران از MiniMax دفاع می‌کنید و خسارت را جبران می‌کنید.
- **VI.4:** MiniMax هیچ حقی بر خروجی‌ها ادعا نمی‌کند؛ شما و کاربرانتان مسئول خروجی‌ها و استفاده از آن‌ها هستید.

**سلب مسئولیت و فسخ (VII، VIII، IX)**
- **VII.1:** تعهدی به پشتیبانی/به‌روزرسانی نیست. **VII.2:** مدل و خروجی‌ها "AS IS" (همان‌گونه که هستند) و بدون هیچ ضمانتی ارائه می‌شوند؛ تناسب آن را شما تعیین می‌کنید و خطر را می‌پذیرید. **VII.3:** MiniMax و شرکت‌های وابسته در برابر هیچ خسارتی (تا حدی که قانون اجازه می‌دهد) مسئول نیستند.
- **VIII.1:** از زمان پذیرش/دسترسی اجرایی می‌شود. **VIII.2:** در صورت نقض، MiniMax می‌تواند مجوز را فسخ کند؛ شما باید استفاده/توزیع را متوقف کنید، نسخه‌ها را حذف کنید و به دریافت‌کنندگان اطلاع بدهید (VI.1، VI.3، VII، IX باقی می‌مانند).
- **IX:** قانون منطقهٔ ویژهٔ اداری هنگ‌کنگ؛ صلاحیت انحصاری دادگاه‌های هنگ‌کنگ (کنوانسیون CISG سازمان ملل مستثنا است).
- **یادداشت تکمیلی:** رمزگذار MiniMax H3 از Qwen3-VL-32B (Apache 2.0) استفاده می‌کند.

**سیاست استفادهٔ قابل‌قبول (Exhibit A)** (از مدل، مشتقات یا خروجی‌ها برای این موارد استفاده نکنید)
- A-1 استفاده خارج از قلمرو؛ A-2 نقض قوانین یا مالکیت فکری اشخاص ثالث؛ A-3 آسیب به خود یا دیگران؛ A-4 تغییر کاربری/توزیع خروجی‌ها برای آسیب رساندن؛ A-5 دور زدن تدابیر حفاظتی؛ A-6 سوءاستفاده یا آسیب به کودکان و نوجوانان زیر سن قانونی؛ A-7 اطلاعاتی که نادرستی آن قابل‌اثبات است برای آسیب به دیگران یا تأثیر بر انتخابات؛ A-8 تعامل آنلاین جعلی (نقدهای جعلی و مانند آن)؛ A-9 افترا، تحقیر، آزار؛ A-10 بدافزار؛ A-11 داده‌های شخصی برای آسیب به دیگران؛ **A-12 انتشار محتوا در هر محیط عمومی (از جمله پست‌های ربات) بدون اعلام روشن و برجسته اینکه ماشینی تولید شده است**؛ A-13 جعل هویت بدون رضایت؛ A-14 تصمیم‌های خودکار پرخطر در حوزه‌های حساس (اجرای قانون، مهاجرت، سلامت، زیرساخت حیاتی، اعتبار، استخدام، مسکن، آموزش، امتیازدهی اجتماعی، بیمه و مانند آن)؛ A-15 نقض هنجارهای اجتماعی، اخلاقی و ارزشی کشورها/مناطق دیگر؛ A-16 افراط‌گرایی خشونت‌آمیز/تروریسم؛ A-17 تبعیض/آسیب بر پایهٔ ویژگی‌های حمایت‌شده؛ A-18 سوءاستفاده از گروه‌های آسیب‌پذیر؛ **A-19 مقاصد نظامی**؛ A-20 فعالیت حرفه‌ای بدون مجوز (مالی، حقوقی، پزشکی و مانند آن).
- یادداشت: این خلاصه‌ای به زبان ساده است؛ در صورت تردید، متن انگلیسی مجوز مقدم است.

## برچسب‌های مدرک

یک مجموعه برای همهٔ سندها (املاهای قدیمی‌تر در پرانتز):
- **[اندازه‌گیری‌شده]** (EN: measured؛ TR: ölçtüm, olctum): در همین پروژه اجرا شده و مسیر مدرک وجود دارد.
- **[خوانده‌شده]** (EN: read؛ TR: okudum yol, okudum): منبع یا اسکریپت خوانده شده، اجرا نشده.
- **[طراحی]** (EN: design؛ TR: tasarım, tasarim): طراحی شده، هنوز در اجرای واقعی دیده نشده.
- **[حدس]** (EN: guess؛ TR: tahmin): راستی‌آزمایی نشده.
- **[آزموده‌نشده]** (EN: not tried؛ TR: denenmedi): هرگز اجرا نشده.
- **[گزارش کاربر]** (EN: user-reported؛ TR: kullanıcı bildirdi): کاربر با ذکر تاریخ اعلام کرده؛ به‌طور مستقل اندازه‌گیری نشده.
- **[محاسبه‌شده]** (EN: computed؛ TR: hesap؛ املاهای قدیمی‌تر: calculated, hesap): عددی که از ورودی‌های اندازه‌گیری‌شده به دست آمده و خودش اندازه‌گیری نشده؛ نحوهٔ محاسبه کنارش نوشته می‌شود. [proposal] / [öneri] در متن قدیمی‌تر = [حدس].

نام اجراهایی که در کروشه آمده (نام اجراهای خودمان است، نه فایل‌های این مخزن): U209 = 209 فریم با باینری انتشار از طریق `uret.ps1`؛ B209 و B192 = اجراهای تصویر به ویدیو (‎`-InitImg`‎) در 209 و 192 فریم؛ B56VT2 = باینری انتشار، 56 فریم، مقایسه‌شده با مرجع بایتی 56 فریمی R0؛ F209b، F209V2، F209V2K = اجراهای 209 فریمی روی نسخهٔ توسعه (جزئیات: `docs/OLCUMLER.md`).

## محدودیت‌های شناخته‌شده
- **اثبات بایتی** (روش بازتولید آن: `docs/KANITLAR.md`، "R0 ve latent referansi nasil uretilir"؛ روی کارت sm_61 ما راستی‌آزمایی شده، GPUهای دیگر ممکن است بایت‌به‌بایت یکسان نباشند [حدس]): با مجموعه وصله‌های ما (پرچم‌های حافظه روشن) یک اجرای 56 فریمی sha256 برابر `0979f156d548169b...`‎ داد که با مرجع یکسان بود [اندازه‌گیری‌شده]؛ در 141 فریم، sha256 مربوط به latent برابر `E5D028F8632BE4FE...`‎ یکسان بود (با پرچم‌های 0013/0014). برای فریم‌های 158 تا 209 مرجع بایتی مستقیم وجود ندارد؛ زنجیرهٔ دروازه‌ها همان مدرک است. گذراندن دروازه‌های عددی کلیپ خوب را تضمین نمی‌کند: سازگاری حرکت در طول زمان با چشم بررسی می‌شود (`docs/KAPILAR.md` را ببینید).
- **209 فریم، کدام مجموعه پرچم:** مدرک زنجیرهٔ بایتی 209 فریم با مجموعه پرچم F209V2 روی نسخهٔ توسعه گرفته شده است (بدون پرچم‌های block-tail، ساخته‌شده بدون وصله‌های 0019/0020)؛ `uret.ps1` برای 209 فریم از همین دستورکار استفاده می‌کند [خوانده‌شده: اسکریپت؛ یک اجرای واقعی موتور از طریق `uret.ps1` در اجرای U209 موفق بود].
- توسط ما روی یک کارت (GTX 1050 Ti 4 GB) راستی‌آزمایی شده؛ گزارش‌های بیرونی کارت‌های دیگر همراه برچسب‌شان در `docs/KART_PROFILLERI.md` فهرست شده‌اند [گزارش کاربر].
- **کدام باینری اندازه‌گیری شد:** latent مربوط به 141 فریم و زنجیرهٔ بایتی با ساخت‌های توسعهٔ ما اندازه‌گیری شد. باینری انتشاری که دانلود می‌کنید یک ساخت تازه است: دروازهٔ بایتی 56 فریمی آن موفق بود (مورد بعدی) و یک اجرای 209 فریمی از طریق `uret.ps1` دروازه را گذراند (اجرای U209، 3414 ثانیه، اوج VRAM برابر 3777 MiB) [اندازه‌گیری‌شده]؛ نسبت به اجرای 209 فریمی نسخهٔ توسعه، latent بایت‌به‌بایت یکسان است؛ در ویدیو فریم‌ها (md5) و صدا یکسان‌اند و sha256 فایل AVI به‌دلیل کانتینر فرق دارد [اندازه‌گیری‌شده] (`docs/OLCUMLER.md`، بخش 0 را ببینید).
- **باینری انتشار، 56 فریم:** باینری انتشار (sd-cli با `c5cebe78...`‎، stable-diffusion.dll با `e5d3d329...`‎) نتیجهٔ 56 فریمی بایت‌به‌بایت یکسان با R0 داد (sha256 برابر `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`؛ md5 هر فریم و صدا یکسان)، مستقیماً با پرچم‌های پیش‌فرض (بدون متغیرهای `SD_*`) اجرا شد، کد خروج 0، 601 ثانیه [اندازه‌گیری‌شده: اجرای B56VT2، 2026-11-19؛ مدارک نزد نویسندگان است و در این مخزن نیست]. دامنه: فقط کارت sm_61 ما و 56 فریم؛ آزمون نصب از ریشهٔ تمیز نیست؛ latent مربوط به 141 فریم و زنجیرهٔ 209 با باینری قدیمی‌تر اندازه‌گیری شد و با این باینری تکرار نشده است [آزموده‌نشده]. تلاش اول (B56VT، از طریق یک اسکریپت کمکی) پس از 58 ثانیه بی‌صدا تمام شد، علت نامعلوم [حدس: فشار حافظه]؛ تلاش دوم `sd-cli` را مستقیماً اجرا کرد.
- اسکریپت‌های نصب و اجرا هنوز از پوشهٔ خالی راستی‌آزمایی نشده‌اند (آزمون ریشهٔ تمیز در انتظار است).
- نقشهٔ راه و گام‌های بعدی: `ROADMAP.md`.

## وضعیت و محدودیت‌ها
- روی یک دستگاه راستی‌آزمایی شده است (GTX 1050 Ti با 4 GB، 16 GB RAM، i7-7700HQ). کارت‌های 4 GB دیگر و مقدارهای دیگر RAM ممکن است فرق داشته باشند.
- **پیش‌فرض 209 فریم (8.7 ثانیه):** دروازه‌های کیفیت ما را گذراند (نویز 1.08، اجرای F209V2K) [اندازه‌گیری‌شده: 209 فریم با باینری نسخهٔ انتشار (release) از طریق `uret.ps1`، اجرای U209؛ latent با اجرای نسخهٔ توسعه بایت‌به‌بایت یکسان است؛ فریم‌ها و صدا در ویدیو یکسان‌اند و sha فایل به‌دلیل کانتینر فرق دارد؛ مدارک نزد نویسندگان است و در این مخزن نیست]. در 209 فریم، اوج VRAM مربوط به DiT برابر 3777 MiB از 4096 MiB بود (اجراهای F209b و U209؛ عدد `nvidia-smi` برای کل کارت)، که حاشیه‌ای باریک است: بار دیگر روی GPU (صفحه‌نمایش، برنامه‌های دیگر) می‌تواند اجرا را در `blocks.0` ناموفق کند؛ فقط روی GTX 1050 Ti آزموده شده است. وضعیت صفحه‌نمایش در آن اجرا ثبت نشد؛ اگر صفحه‌نمایش شما روی این کارت کار می‌کند، VRAM کمتری در دسترس است [حدس: بار نمایش Windows حدود 100-300 MB]؛ در صورت نیاز، صفحه‌نمایش را به GPU یکپارچه وصل کنید [توصیه، آزموده‌نشده]. مرحلهٔ sampling برابر 2730 ثانیه طول کشید (اجرای U209: گام‌هایی بین 436 تا 483 ثانیه) و رمزگشایی VAE در پردازش جدا برابر 173 ثانیه (مرحلهٔ 2 در مجموع 193 ثانیه با رمزگشایی صدا) [اندازه‌گیری‌شده: U209 با باینری انتشار؛ اجراهای قدیمی‌تر توسعه: 2664 و 174 ثانیه]. در مرحلهٔ 1، VAE درون‌پردازشی حافظه کم آورد و به temporal tiling برگشت (320 ثانیه)؛ آن خروجی دور ریخته می‌شود و ویدیو از مرحلهٔ 2 بدون کاشی‌کاری گرفته می‌شود. اوج RAM در U209 اندازه‌گیری نشد. کلیپ‌های بلندتر از 209 فریم جزو این انتشار نیستند.
- **تصویر به ویدیو (‎`-InitImg`‎):** با تصویر اولیه، سقف روی این GPU برابر 192 فریم (8.0 ثانیه با 24 fps) است: 209 فریم جا نشد (حدود 17.5 MB VRAM در بلوک 0 کم بود: 2587 MB لازم، 2570 MB موجود)؛ 192 فریم از طریق `uret.ps1` در 3086 ثانیه اجرا شد، اوج VRAM برابر 3783 MiB بود و دروازه را گذراند [اندازه‌گیری‌شده: اجراهای B209 و B192، 2026-11-20، یک صحنه؛ مدارک نزد نویسندگان است و در این مخزن نیست]. روی GPUهای دیگر آزموده نشده [آزموده‌نشده].
- **RAM آزاد اهمیت دارد:** حدود 11 GB RAM آزاد لازم دارید (پردازش موتور حدود 11 GB اشغال می‌کند) [اندازه‌گیری‌شده]. اگر RAM آزاد کم باشد، پردازش ممکن است بدون پیام خطا بمیرد [حدس: یک بار با حدود 300 MB RAM آزاد دیدیم، در حالی که `sd-cli` حدود 10 GB اشغال کرده بود]. هنگام اجرا برنامه‌های بزرگ دیگر را باز نکنید: روی دستگاه 16 GB فقط حدود 0.3-0.5 GB آزاد می‌ماند و زیر فشار حافظه ممکن است اجرا بی‌صدا بمیرد. پیش از شروع، مرورگرها، بازی‌ها و برنامه‌های بزرگ دیگر را ببندید و RAM آزاد را بررسی کنید.
- **آزمون ریشهٔ تمیز در انتظار است:** اسکریپت‌های نصب و اجرا هنوز فقط با همین دستورالعمل‌ها از یک پوشهٔ خالی راستی‌آزمایی نشده‌اند؛ هنگامی که آن آزمون (از جمله مقایسهٔ بایتی 56 فریمی با مرجع) ثبت شود، این بخش به‌روز خواهد شد.
- هیچ ویدیوی تولیدشده‌ای اینجا همراه نیست.

</div>

<!-- i18n-source: README.md sha256:cdeddf10eb78 -->
