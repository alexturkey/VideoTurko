# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · اردو · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

<div dir="rtl">

تراجم اس انگریزی README کی پیروی کرتے ہیں۔ اگر کوئی ترجمہ مختلف ہو یا پیچھے رہ جائے تو انگریزی متن ہی معتبر ہے، خاص طور پر لائسنس اور سیکیورٹی کے متن کے لیے ([`SECURITY.md`](SECURITY.md) اور [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) صرف انگریزی اور ترکی میں رکھے جاتے ہیں)۔

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **شروع کرنے سے پہلے (لائسنس، علاقہ):** یہ ریپوزٹری MIT ہے اور اس میں صرف پیچ اور اسکرپٹس ہیں۔ یہ جو MiniMax H3 ماڈل ڈاؤن لوڈ کرتی ہے وہ MiniMax H3 Community License کے تحت ہے: اس کے علاقے میں یورپی یونین، برطانیہ، جنوبی کوریا اور امریکہ شامل نہیں ہیں، اور ماڈل، ماخوذ کام **اور آؤٹ پٹس (آپ کی بنائی ہوئی ویڈیوز)** کو وہاں استعمال، تقسیم یا ظاہر نہیں کیا جا سکتا (V.4)۔ لائسنس کی شرائط کے اندر تجارتی استعمال کی اجازت ہے۔ انسٹال کرنے سے پہلے [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) پڑھیں؛ یہ قانونی مشورہ نہیں ہے۔

> **کیا آپ اے آئی کوڈنگ ایجنٹ (Codex, Claude Code, Gemini, Cursor) استعمال کر رہے ہیں؟** اسے بس یہی ایک جملہ دیں: «`AGENTS_HIZLI.md` کو آخر تک پڑھو، پہلے `scripts\tani.ps1` چلاؤ، اپنی پیش رفت `DURUM.md` میں رکھو، اور کچھ بھی حذف یا منتقل کرنے، سسٹم Python یا PATH بدلنے، معیار کی کوئی سیٹنگ کم کرنے، یا میری جگہ ماڈل کا لائسنس قبول کرنے سے پہلے مجھ سے پوچھو۔» ایجنٹ اس پی سی کی تشخیص کرے گا، ایک چیک لسٹ لکھے گا اور ہر فیصلے پر آپ سے پوچھے گا؛ ماڈل کا لائسنس بدستور آپ ہی کا فیصلہ رہے گا۔

> **30 سیکنڈ میں:** 4 GB کا گرافکس کارڈ MiniMax H3 کی 209 فریم (8.7 سیکنڈ) کی ویڈیو ایک ہی پاس میں بنا سکتا ہے: یہ ایک مشین پر جانچا گیا ہے (GTX 1050 Ti، 4 GB؛ خالی فولڈر میں `kur.ps1` سے مکمل انسٹالیشن کی ابھی شروع سے آخر تک جانچ نہیں ہوئی) [پیمائش شدہ: ریلیز (release) بائنری کے ساتھ `uret.ps1` کے ذریعے 209 فریم، رن U209؛ latent ڈیولپمنٹ بلڈ کے رن کے ساتھ بائٹ بہ بائٹ یکساں ہے؛ ویڈیو میں فریم اور آڈیو یکساں ہیں، فائل کا sha کنٹینر کی وجہ سے مختلف ہے؛ ثبوت مصنفین کے پاس محفوظ ہیں، اس ریپوزٹری میں نہیں]؛ ‎`-InitImg`‎ (تصویر سے ویڈیو) کے ساتھ زیادہ سے زیادہ 192 فریم (8.0 سیکنڈ) [پیمائش شدہ: رن B192]؛ 209 فریم میں تقریباً 57 منٹ لگتے ہیں، ڈیفالٹ وقت کی حد 80 منٹ ہے [پیمائش شدہ: رن U209]؛ نیچے کے 3 مراحل چلانے کا طریقہ ہیں۔

VideoTurko: stable-diffusion.cpp کے میموری پیچ اور چلانے کے نسخے، تاکہ GTX 1050 Ti (4 GB) پر MiniMax H3 سے ٹیکسٹ سے ویڈیو ایک ہی پاس میں 209 فریم (8.7 سیکنڈ) تک چل سکے؛ تصویر سے ویڈیو (‎`-InitImg`‎) 192 فریم (8.0 سیکنڈ) تک (209 فریم بائٹ چین سے جانچے گئے ہیں؛ 56 اور 141 فریم کی جانچ میں بغیر پیچ والے رن کے ساتھ بائٹ بہ بائٹ یکساں)۔

## فوری آغاز (Windows، 3 مراحل)
**صورتِ حال: نیچے دیے گئے انسٹال اور رن اسکرپٹ مکمل کیے جا رہے ہیں اور صاف جڑ (clean-root) کا ٹیسٹ باقی ہے؛ جب تک وہ ٹیسٹ پاس نہ ہو، یہاں کسی چیز کے کام کرنے کا دعویٰ نہیں کیا جاتا ("صورتِ حال اور حدود" دیکھیں)۔**

1. اس ریپوزٹری کو **ڈاؤن لوڈ کریں** (سبز **Code** بٹن، پھر **Download ZIP**) اور کسی چھوٹے راستے والے فولڈر میں، مثلاً `C:\vt` میں، ایکسٹریکٹ کریں۔
2. **انسٹال: ‎`kur.cmd`‎ پر ڈبل کلک کریں** (ایک کالی ونڈو کھلتی ہے اور ہر مرحلہ دکھاتی ہے؛ اسے بند کرنے سے انسٹال رک جاتا ہے، اور دوبارہ چلانے پر وہیں سے جاری رہتا ہے جہاں رکا تھا: آدھی ڈاؤن لوڈ ہوئی ماڈل فائل دوبارہ شروع کی جاتی ہے [پڑھا گیا: ڈاؤن لوڈ اسکرپٹ ایک ‎`.part`‎ فائل رکھتی ہے اور اسی سے آگے بڑھتی ہے؛ پورے 29 GiB کی بحالی ناپی نہیں گئی])۔ اگر Windows ڈاؤن لوڈ کی گئی فائل کے بارے میں خبردار کرے تو اس کی جگہ نیچے دی گئی PowerShell کمانڈ استعمال کریں [مشورہ، ڈاؤن لوڈ کی گئی ZIP پر آزمایا نہیں گیا]۔ کمانڈ لائن پسند ہے؟ اس فولڈر میں PowerShell کھولیں (Explorer کی ایڈریس بار میں ‎`powershell`‎ لکھیں) اور وہی انسٹال چلائیں:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   انسٹالیشن کی جڑ وہی فولڈر ہے جسے آپ نے ایکسٹریکٹ کیا (انجن `engine\bin` میں اور ماڈل `model` میں جاتے ہیں)؛ کسی اور جگہ کے لیے پہلے ماحولیاتی متغیر `VT_ROOT` سیٹ کریں۔ اسکرپٹ GPU، ڈرائیور، RAM اور ڈسک کی جانچ کرتا ہے، انجن اور ماڈل ڈاؤن لوڈ کرتا ہے (انجن کی zip فائلیں اور نئی ڈاؤن لوڈ ہونے والی ماڈل فائلیں sha256 سے جانچی جاتی ہیں؛ جو ماڈل فائل پہلے سے صحیح سائز کے ساتھ موجود ہو اس کا صرف سائز دیکھا جاتا ہے، اور مکمل sha256 جانچ کے لیے `scripts\modelleri_indir.ps1 -Dogrula` چلائیں)، ایک مختصر حقیقی جانچ چلاتا ہے اور صرف اسی صورت READY چھاپتا ہے جب وہ جانچ پاس ہو [ڈیزائن: `kur.ps1` صاف فولڈر میں مکمل طور پر نہیں چلایا گیا؛ یہ جملہ صاف فولڈر کے ٹیسٹ کے بعد اپ ڈیٹ ہوگا]۔ ‎`-ExecutionPolicy Bypass`‎ صرف اسی ایک پروسیس پر لاگو ہوتا ہے؛ ہر انسٹالر کی طرح پہلے `scripts\kur.ps1` پڑھ لیں۔
   انجن کی zip فائل GitHub ریلیز (release) v0.1.0 سے آتی ہے (2026-11-19 کو شائع ہوئی؛ اس کا sha256 `kur.ps1` میں طے شدہ ہے)۔ آف لائن ہوں یا اپنا بنایا ہوا بلڈ استعمال کریں تو مقامی zip فائلیں دیں: ‎`-MotorZip <path> -CudaZip <path>`‎۔ مقامی zip بھی اسی طے شدہ sha256 سے جانچی جاتی ہے (اس کے ساتھ رکھی `.sha256` فائل نظر انداز ہوتی ہے)، اس لیے یہ ریلیز والی zip ہی ہونی چاہیے؛ اپنے بلڈ کے لیے پہلے ‎`VT_MOTOR_SHA256`‎ / ‎`VT_CUDA_SHA256`‎ میں اس کا sha256 سیٹ کریں۔ غلط sha256 exit 1 کے ساتھ روک دیتا ہے۔ `engine\bin` میں صرف `.exe`/`.dll` جاتی ہیں؛ لائسنس اور README `engine\lisanslar\<zip name>\`‎ میں رکھے جاتے ہیں۔ [ریلیز سے پہلے dist zip فائلوں کے ساتھ آزمایا گیا: ساتھ والی `.sha256` فائل اور خود حوالہ والی وارننگ، بائنری اور DLL جگہ پر رکھی گئیں، `sd-cli --help` چلا؛ نصب شدہ بائنریز کے sha مطابق نکلے (`c5cebe78...`‎، `e5d3d329...`‎)؛ `kur.ps1` کا ماڈل مرحلہ اور 5 فریم کی جانچ ابھی حقیقی GPU پر نہیں چلائی گئی]
   **ماڈل کا لائسنس:** ماڈل کے مرحلے سے پہلے انسٹالر لائسنس کا خلاصہ چھاپتا ہے (`docs/LISANS_KABUL.txt`، مکمل متن `docs/LISANS_UYARISI.md`: MiniMax H3 Community License، علاقائی پابندیاں جو تیار شدہ ویڈیوز پر بھی لاگو ہیں، تجارتی استعمال اور AI لیبل کے اصول) اور آپ سے قبولیت مانگتا ہے (`E` = ہاں)۔ پہلے اسے پڑھیں۔ بغیر نگرانی چلانے کے لیے ‎`-LisansKabul E`‎ دیا جا سکتا ہے، جس کا مطلب ہے کہ آپ نے خود لائسنس پڑھ کر قبول کیا ہے؛ اسے کسی اور کی طرف سے نہ لگائیں۔ (AI ایجنٹس: `AGENTS.md` پر عمل کریں؛ صارف کی رضامندی کے بغیر کبھی E نہ لکھیں۔) قبولیت کے بغیر `kur.ps1` ایگزٹ کوڈ 2 کے ساتھ رک جاتا ہے اور کوئی ماڈل ڈاؤن لوڈ نہیں کرتا۔
3. **آپ کی پہلی ویڈیو (56 فریم، ہمارے GTX 1050 Ti پر تقریباً 11 منٹ** [پیمائش شدہ: 641 سیکنڈ، رن R0، ‎`docs/OLCUMLER.md`‎؛ دوسرے کارڈ نہیں ناپے گئے]**)**: جب انسٹالر ‎`HAZIR / READY`‎ چھاپے تو یہ چلائیں
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (شارٹ کٹ: پرامپٹ کی ٹیکسٹ فائل کو ‎`uret.cmd`‎ پر گھسیٹ کر چھوڑیں، یا ‎`uret.cmd docs\ornek_istem_R0.txt`‎ چلائیں: وہی 56 فریم کا رن)۔ ویڈیو ‎`runs\`‎ میں ہے۔ پھر اپنا پرامپٹ ایک ٹیکسٹ فائل میں لکھیں (انگریزی میں ایک پیراگراف، اختیاری ‎`audio:`‎ جملہ) اور ہمارا سب سے طویل معاون کلپ چلائیں (ڈیفالٹ، تقریباً 57 منٹ [پیمائش شدہ: رن U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   ‎`-Kare`‎ کی قدر 17k+5 گرڈ کے مطابق ہوتی ہے (56، 73، ... 192، 209)؛ ڈیفالٹ 209 ہے (8.7 سیکنڈ)، جو ہماری جانچی ہوئی سب سے لمبی مدت ہے۔ VAE الگ پروسیس میں چلتا ہے اور کبھی ٹائلوں میں تقسیم (tiling) نہیں ہوتا [ریلیز بائنری کے ساتھ `uret.ps1` کے ذریعے حقیقی انجن رن، الگ پروسیس VAE کے ساتھ، رن U209 میں پاس ہوا]۔

   پرامپٹ لکھنے کی رہنمائی: [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (ایک مسلسل شاٹ کا نمونہ، برابر وقت کے حصے، دو مکمل مثالیں)۔

| ضرورت | قدر |
|---|---|
| آپریٹنگ سسٹم | Windows 10/11، 64 بٹ |
| GPU | NVIDIA، 4 GB یا زیادہ؛ صرف GTX 1050 Ti (sm_61) پر آزمایا گیا؛ گنجائش کم ہے (209 فریم پر 3777/4096 MiB): مصروف اسکرین یا براؤزر رن بگاڑ سکتا ہے؛ کوئی اور 4 GB کارڈ نہیں آزمایا گیا |
| RAM | 16 GB (چوٹی تقریباً 11 GB؛ دوسرے پروگرام بند کریں) |
| ڈسک | کم از کم 32 GiB خالی (40 GiB یا زیادہ تجویز کردہ: 32 سے 40 کے درمیان انسٹالر انتباہ چھاپتا ہے، ‎`[VT-W-DISK-PAY]`‎ [پیمائش شدہ: فرضی ڈسک کے ساتھ ‎`-Kuru`‎ رن])، ماڈلز SSD پر (NVMe بہتر) |
| ڈاؤن لوڈ | انجن zip 36.8 MB + CUDA runtime zip 567.5 MB [پیمائش شدہ] + ماڈل 31,473,112,040 بائٹ (تقریباً 29.3 GiB) [پڑھا گیا: سائز `scripts/modeller.json` میں]؛ کل تقریباً 30 GiB |
| ماڈل | شامل نہیں؛ انسٹالر انہیں MiniMax لائسنس کے تحت ڈاؤن لوڈ کرتا ہے (نیچے وارننگ دیکھیں)۔ ماڈل (29.3 GiB، `scripts/modeller.json` میں 31,473,112,040 بائٹ) اس ریپوزٹری یا ریلیز میں نہیں ہیں: GitHub کی فائل/ریلیز سائز کی حدیں لاگو ہیں، اور `kur.ps1` انہیں سرکاری ذریعے سے sha256 تصدیق کے ساتھ ڈاؤن لوڈ کرتا ہے۔ |

`kur.ps1` کے ایگزٹ کوڈ: 0 READY، 1 خرابی، 2 صارف کا ان پٹ درکار ہے (لائسنس، یا ابھی ریلیز/zip نہیں)، 3 ہارڈویئر یا ڈسک ناکافی، 4 روکا گیا (DUR فائل)۔ `uret.ps1` رن کو صرف تب قبول کرتا ہے جب `.avi` فائل موجود ہو، فریم کی تعداد درست ہو اور لاگ صاف ہوں [پیمائش شدہ: ریلیز بائنری پر `uret.ps1` کے ذریعے ایک حقیقی رن، رن U209، 209 فریم، گیٹ (gate) پاس ہوا]۔ `uret.ps1` کے ایگزٹ کوڈ: 0 DONE (معیار کا گیٹ پاس)، 1 خرابی یا ناقابلِ قبول آؤٹ پٹ (بغیر آڈیو اسٹریم والی ویڈیو سمیت)، 2 روکا گیا (DUR فائل)، 5 `KAPI RED` (معیار کا گیٹ پاس نہیں ہوا: کلپ قبول نہیں، فیصلہ آپ کا ہے)، 6 گیٹ چل نہ سکا (کلپ قبول نہیں)۔ تفصیل AGENTS.md میں ہے۔ [پیمائش شدہ: جعلی انجن اور جعلی گیٹ والے منظرناموں میں ایگزٹ کوڈ 0، 1 (خاموش ویڈیو)، 5 اور 6؛ حقیقی انجن: رن U209 میں exit 0]

### مسائل کا حل (تفصیل: `docs/SIK_HATALAR.md`)
ہمارے اسکرپٹس کی خرابی کی لائنوں میں ایک مستقل کوڈ ہوتا ہے، مثلاً ‎`HATA: [VT-E-DLL] ...`‎ یا ‎`UYARI: [VT-W-DISK-PAY] ...`‎۔ کوڈ کو [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) (اینکر کی مثال ‎`#vt-e-dll`‎) یا ‎`docs/hata_imzalari.json`‎ میں تلاش کریں، اور کوڈ اپنے issue میں لکھیں۔ نیچے ٹیبل کا پہلا کالم ویسا ہی رہتا ہے جیسا چھپتا ہے (کوڈز اور لاگ کا متن ترجمہ نہ کریں)۔

| آپ کیا دیکھتے ہیں | مطلب اور کیا کرنا ہے |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | `sd-cli.exe` کو ہاتھ سے نہ چلائیں؛ `scripts\kur.ps1` چلائیں، جو CUDA کی DLL فائلیں جگہ پر رکھتا ہے۔ |
| `blocks.0` پر `failed during weight preparation` (#1, #3, #5) | میموری گیٹ پر VRAM کم پڑ گئی: 17k+5 گرڈ پر کم فریم تعداد چنیں، GPU استعمال کرنے والے دوسرے پروگرام بند کریں، اور ساتھ آنے والے فلیگ (flags) نہ بدلیں۔ |
| `retrying with temporal tiling` (#6) | VAE ٹائلنگ پر چلا گیا؛ معیار کے لحاظ سے آؤٹ پٹ ناقابلِ قبول ہے۔ دوبارہ چلائیں۔ |
| رن وقت کی حد پر ختم ہو جاتا ہے، ویڈیو نہیں بنتی (#7) | لمبے کلپس کے لیے ‎`-TavanDk`‎ بڑھائیں (ڈیفالٹ وقت کی حد: 209 فریم کے لیے 80 منٹ، `uret.ps1` طے کرتا ہے؛ ہمارے 209 فریم کے رن میں 57 منٹ لگے [پیمائش شدہ: رن U209])۔ |
| ایگزٹ کوڈ خالی مگر "finished" لکھا ہے (#14) | ریپر (wrapper) نے ایگزٹ کوڈ بہت جلدی پڑھ لیا؛ دوبارہ چلائیں اور ویڈیو فائل کی موجودگی دیکھیں۔ |
| سسٹم سست ہو جاتا ہے، swapping ہو رہی ہے (#18) | انجن تقریباً 10-11 GB RAM استعمال کرتا ہے؛ براؤزر اور دوسرے پروگرام بند کریں۔ |
| sha256 میں فرق / ڈاؤن لوڈ ناکام | عموماً ڈاؤن لوڈ درمیان میں ٹوٹ گیا ہوتا ہے: وہی کمانڈ دوبارہ چلائیں، تصدیق شدہ فائلیں چھوڑ دی جاتی ہیں۔ |

**پھنس گئے ہیں یا تجسس ہے؟** [`SUPPORT.md`](SUPPORT.md) (کہاں پوچھیں؛ جواب کے اوقات ہدف ہیں، وعدہ نہیں) · [`PRIVACY.md`](PRIVACY.md) (کوئی ٹیلی میٹری نہیں؛ نیٹ ورک صرف انجن اور ماڈلز ڈاؤن لوڈ کرنے کے لیے، درج میزبانوں سے استعمال ہوتا ہے) · [`SECURITY.md`](SECURITY.md) (نجی رپورٹ) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (5 مراحل میں پہلی pull request؛ دستاویزات اور اسکرپٹس کے لیے GPU درکار نہیں)۔

### ورژن v0.1.1 میں نیا: مزید اختیارات (تفصیل: `AGENTS.md`، `docs/SIK_HATALAR.md` 19-23)
ان اختیارات کے بغیر 4 GB کارڈ پر کچھ نہیں بدلتا (ہمارے حوالے کے مقابلے میں 56 فریم کی بائٹ جانچ v0.1.1 کے ساتھ دوبارہ پاس ہوئی [پیمائش شدہ])۔ یہ دیکھنے کے لیے کہ کیا چلے گا، کسی بھی کمانڈ میں ‎`-Kuru`‎ شامل کریں۔
- اختیار ‎`-EndImg`‎: آخری فریم بھی دیں (پہلا اور آخری فریم، "FLF")؛ 8 GB سے کم والے کارڈز پر حد 175 فریم ہے (4 GB پر 192 نہیں سمایا)، 8 GB یا اس سے زیادہ والے کارڈز پر 192۔ ہمارے GTX 1050 Ti پر یہ ہمیشہ دو پروسیس میں چلتا ہے: 56 فریم 1040 سیکنڈ، 175 فریم 2887 سیکنڈ (48 منٹ)، دونوں گیٹ سے پاس ہوئے [پیمائش شدہ]۔ پرامپٹ (prompt) لکھنے کے مشورے: `docs/ISTEM_YAZIMI.md`۔
- اختیارات ‎`-W`‎ / ‎`-H`‎: دوسرے سائز، مثلاً عمودی 384x640؛ 32 کے مضرب، رقبہ کم از کم 640x384 (اس سے چھوٹا کبھی نہیں)۔ 4 GB پر نہیں آزمایا گیا؛ 8 GB سے کم والے کارڈز پر ہماری سب سے بڑی پیمائش شدہ جاب سے بڑے سائز رد کر دیے جاتے ہیں۔ معیار کے گیٹ کی حدیں 640x384 کے لحاظ سے طے کی گئی ہیں۔
- اختیار ‎`-TekAsama`‎: دو کے بجائے ایک پروسیس، صرف بڑے کارڈز کے لیے؛ یہ کبھی خود بخود آن نہیں ہوتا۔
- نئے GPU (compute capability 7.0 یا اس سے زیادہ، مثلاً RTX 20/30/40): اگر آپ نے خود سیٹ نہ کیا ہو تو `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` خود بخود سیٹ ہو جاتا ہے؛ اس سے رپورٹ کرنے والے کے RTX 4070 Ti پر 141 یا زیادہ فریم پر بالکل سیاہ ویڈیو کا مسئلہ حل ہوا [صارف کی رپورٹ, issue #1]۔ Python + OpenCV نہ ہو تو `uret.ps1` اب GPU کام سے پہلے exit 6 کے ساتھ رک جاتا ہے (کوئی ویڈیو نہیں بنتی، کوئی گمراہ کن RED نہیں)۔
- RTX 4070 Ti کی اس رپورٹ کے لیے @SinanC73 کا شکریہ جس کی بدولت یہ تبدیلیاں ہوئیں ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1))۔

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

## اختیاری رفتار کے پروفائل (اسپیڈ پیک؛ بطور ڈیفالٹ بند)
نیچے دی گئی کوئی بھی چیز ڈیفالٹ رن کو نہیں بدلتی (640x384، 209 فریم، ہمارے کارڈ پر 3414 سیکنڈ)۔ یہ اس کے علاوہ تین ناپے ہوئے خانے ہیں، ہر ایک ‎`uret.ps1`‎ کا ایک نامزد پروفائل ہے؛ انہیں اسپیڈ پیک انجن درکار ہے (ریلیز انجن اور پیچ 0021، 0023، 0024، سب بطور ڈیفالٹ بند: ‎`docs/YAMALAR.md`‎)۔ اسے ‎`scripts\kur.ps1 -HizPaketi`‎ سے انسٹال کریں (مقامی zip ‎`-MotorZip`‎ کے ساتھ چلتی ہے)، پھر ‎`-Profil <name>`‎ شامل کریں؛ ‎`-Kuru`‎ چھاپتا ہے کہ کیا چلے گا۔ اسپیڈ پیک v0.1.4 ریلیز کے ساتھ شائع ہوگا۔

| پروفائل | سائز، لمبائی | GTX 1050 Ti 4 GB پر کل وقت | حیثیت |
|---|---|---|---|
| (کوئی نہیں، ڈیفالٹ) | 640x384، زیادہ سے زیادہ 209 فریم (8.7 سیکنڈ) | 209 فریم: 3414 سیکنڈ | تصدیق شدہ، بغیر تبدیلی |
| ‎`yuksek832`‎ | 832x480، 141 فریم (5.9 سیکنڈ) | تقریباً 55-56 منٹ | قابلِ استعمال، دو پرامپٹ [پیمائش شدہ] |
| ‎`yuksek832 -Kare 124`‎ | 832x480، 124 فریم (5.2 سیکنڈ) | تقریباً 45-46 منٹ، رفتار کے فلیگ کی ضرورت نہیں | قابلِ استعمال، دو پرامپٹ [پیمائش شدہ] |
| ‎`yuksek896`‎ | 896x512، 124 فریم (5.2 سیکنڈ) | تقریباً 56-57.5 منٹ | قابلِ استعمال، دو پرامپٹ [پیمائش شدہ] |
| ‎`uzun260`‎ | 640x384، 260 فریم (10.8 سیکنڈ) | جلد اخراج کے بغیر 78 منٹ ناپے گئے؛ اس کے ساتھ تقریباً 71-72 منٹ [اندازہ: ‎`uret.ps1`‎ کے ذریعے شروع سے آخر تک نہیں ناپا گیا] | مشروط اور تجرباتی |

- **تنگ حاشیہ:** 832x480 x 141 پر میموری گیٹ صرف ایک ہندسے کے MB جتنا حاشیہ چھوڑتا ہے (دونوں مکمل رنز میں 5.7 اور 6.8 MB)۔ دو لمبے پرامپٹ (1520 اور 2041 حروف) صرف قدم 1 اور قدم 2 کے ایک حصے کا گیٹ پڑھ کر جانچے گئے، مکمل نہیں چلائے گئے: حاشیہ 10.9 اور 4.0 MB۔ کارڈ کی میموری روکنے والا کوئی بھی دوسرا عمل (براؤزر، دوسری اسکرین) اسے ناکام کر سکتا ہے؛ تب ‎`-Kare 124`‎ یا ڈیفالٹ سائز استعمال کریں [پیمائش شدہ، GTX 1050 Ti 4 GB]۔
- **‎`uzun260`‎ مشروط ہے:** میموری کی حد بہت تنگ ہے (VRAM کی چوٹی 4096 MiB میں سے 3903)، مشترکہ میموری کا استعمال 45 اور 61 MiB (حد 68) بڑھا، اور بائٹ برابری کے لیے فلیگ کے بغیر کوئی حوالہ موجود نہیں، اس لیے اسے عام فیچر کے طور پر پیش نہیں کیا جاتا۔ پیچ 0023 صرف اسی ایک خانے کے لیے قبول ہے۔
- **پیش نہیں کیا جاتا:** 832x480 پر 158 فریم فراہم کردہ پیچز کے ساتھ نہیں سماتے (مرحلہ 2 کے گیٹ پر تقریباً 280 MB کم پڑتے ہیں)؛ 175 فریم صرف گیٹ پڑھ کر دیکھے گئے (پہلے بلاک میں تقریباً 275 MB کم پڑے، مکمل رن نہیں ہوا)۔ پروفائل صرف 141 فریم دیتی ہے۔ دوسرے سائز اور فریم کی تعداد ‎`-Profil`‎ مسترد کر دیتا ہے (ڈیفالٹ راستہ استعمال کریں)۔
- ڈیفالٹ معیار کو چھیڑا نہیں گیا: 6 قدم، cfg 1، بغیر ٹائل کے VAE، 17k+5 فریم۔ جہاں فلیگ آن ہیں، وہاں ان سائزوں پر جن میں فلیگ کے بغیر رن سما جاتا ہے، آؤٹ پٹ کو فلیگ کے بغیر ویڈیو سے بائٹ بہ بائٹ ملایا گیا (‎`docs/YAMALAR.md`‎)؛ 832x480 x 141 اور 896x512 x 124 پر فلیگ کے بغیر رن نہیں سماتا، اس لیے وہاں برابری براہِ راست موازنے پر نہیں بلکہ قریب ترین خانوں پر ٹکی ہے [پیمائش شدہ، پڑھا گیا]۔
- دو مرحلوں والے رن کا مرحلہ 1 اب latent فائل مکمل ہوتے ہی ختم ہو جاتا ہے (‎`VT_ERKEN_CIKIS=0`‎ اسے بند کرتا ہے)۔

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

## یہ کیا ہے
stable-diffusion.cpp کے لیے چھوٹے میموری/شیڈولنگ پیچوں کا مجموعہ، ساتھ چلانے کا نسخہ، جانچیں اور پیمائشیں، جن کی بدولت MiniMax H3 (33B کا DiT؛ ہم HyperFlow Flash 13.7B کی Q4_K_M GGUF چلاتے ہیں؛ 32B کا Qwen3-VL ٹیکسٹ انکوڈر الگ ہے) 4 GB والے Pascal GPU (GTX 1050 Ti، 16 GB سسٹم RAM) پر چل سکتا ہے۔
- ایک پاس کی وہ لمبائیاں جو ہم نے واقعی بنائیں اور ہمارے معیار کے گیٹس سے گزریں: 640x384، 24 fps پر 56، 141، 158، 175، 192، 209 فریم (209 فریم = 8.7 سیکنڈ)، H3 کی اپنی بنائی ہوئی آڈیو کے ساتھ [پیمائش شدہ: ریلیز (release) بائنری کے ساتھ `uret.ps1` کے ذریعے 209 فریم، رن U209؛ latent ڈیولپمنٹ بلڈ کے رن کے ساتھ بائٹ بہ بائٹ یکساں ہے؛ ویڈیو میں فریم اور آڈیو یکساں ہیں، فائل کا sha کنٹینر کی وجہ سے مختلف ہے؛ ثبوت مصنفین کے پاس محفوظ ہیں، اس ریپوزٹری میں نہیں]۔ 209 سب سے لمبی مدت ہے جو ہم نے دیکھی اور رواں پائی [صارف کی رپورٹ, 2026-11-19، ویڈیو مکمل دیکھی گئی؛ فائل: F209V2 کی آؤٹ پٹ، 8.708 سیکنڈ]۔
- **بائٹ کی یکسانیت کا دعویٰ، ایمانداری سے محدود دائرے میں:** آؤٹ پٹ کو بغیر پیچ والے حوالے سے بائٹ بہ بائٹ یکساں صرف 56 اور 141 فریم کے لیے جانچا گیا۔ 158/175/192/209 فریم کے لیے ہم نے وہی فلیگ اور وہی بائنری چین استعمال کی؛ براہِ راست بائٹ حوالہ موجود نہیں (بغیر پیچ والا بلڈ اس GPU پر یہ لمبائیاں چلا ہی نہیں سکتا)۔
- معیار کی سیٹنگز کبھی کم نہیں کی جاتیں: وہی ماڈل/کوانٹائزیشن، 6 مراحل، cfg 1، 640x384، وہی seed، بغیر ٹائلنگ کا VAE۔
- ہم پہلے ہونے کا دعویٰ نہیں کرتے: ہم نے تلاش کی اور 4 GB پر اس کی کوئی بیرونی مثال نہیں ملی، جو اس بات کا ثبوت نہیں کہ کوئی موجود نہیں۔

## فولڈر کی ساخت
- `patches/` stable-diffusion.cpp کے ایک مقرر (pinned) commit کے خلاف پیچ (وہاں کے نوٹ دیکھیں)
- `scripts/` بلڈ، رن، الگ پروسیس VAE، گیٹ/ہم آہنگی کے معاون (`doku_norm.py`: نیچے اسکیل کا نوٹ دیکھیں)
- `docs/KURULUM.md` ہارڈویئر، بلڈ اور رن کے مراحل (EN+TR)
- `docs/YAMALAR.md` پیچوں کی فہرست، `docs/KANITLAR.md` ثبوت، `docs/KAPILAR.md` معیار کے گیٹس کا جدول، `docs/OLCUMLER.md` پیمائشیں، `docs/SIK_HATALAR.md` عام غلطیاں، `docs/LISANS_UYARISI.md` لائسنس کی تمام شقیں
- `scripts/` کی مختصر فہرست: `hiz_kos3.ps1` رن ریپر (‎`-Kuru`‎ درست کمانڈ چھاپتا ہے)، `uretim_kapi.ps1` معیار کا گیٹ، `dikis_denetim.py` جوڑ (seam) کی جانچ، `doku_norm.py` بافت کے لحاظ سے نارملائز کیا گیا شور، `bayt_kiyas.py` بائٹ کا موازنہ، `derleme_sablonu.ps1` بلڈ ٹیمپلیٹ (صرف Visual Studio کا ٹیلی میٹری معاون `vctip.exe` روکتا ہے جو بلڈ شروع ہونے کے بعد چلا ہو، ورنہ وہ بلڈ پروسیس کو منٹوں تک جوڑے رکھتا ہے؛ دوسری `vctip.exe` پروسیسز کو نہیں چھیڑا جاتا)

## معیار کے گیٹس (نتیجہ کیسے قبول ہوتا ہے)

یہ گیٹ حرکت کی ہم آہنگی (چیزوں کے سائز یا مقام میں چھلانگ) نہیں جانچتا: قبول کرنے سے پہلے پوری ویڈیو خود دیکھیں۔
1. فریم کی تعداد اور آڈیو کی موجودگی؛ لاگ میں میموری fallback یا ALLOC_FAILED کی کوئی لائن نہ ہو۔
2. خام شور کا گیٹ: میڈین فلٹر کا بقیہ <= 1.5 (0-255 اسکیل)۔
3. بافت کے لحاظ سے نارملائز کیا گیا شور، `scripts/doku_norm.py` (اس ریپوزٹری کا ورژن): N = میڈین بقیہ / Sobel بافت، ہر 6 فریم میں ایک۔ **اسکیل کا نوٹ:** اس ورژن میں ناپے گئے 10 کلپس N = 0.034-0.052 دیتے ہیں (جدول `docs/KAPILAR.md` میں؛ F192/F209V2 کی آخری چوتھائی 0.062 تک پہنچتی ہے) اور اضافی گیٹ کی حد N <= 0.065 ہے۔ ایک دوسرے نفاذ نے انہی کلپس پر 0.028-0.036 ناپا، اس لیے حدیں ورژنوں کے درمیان بدلی نہیں جا سکتیں۔ بہت باریک بافتوں (گھاس کی قطاروں) پر صاف N 0.075 تھا، اس لیے حد ہر منظر کے خاندان کے لیے الگ ہے۔ ایک مضبوط ہائی فریکوئنسی تخمینہ کار (sigma-HH <= 1.5؛ صاف 0.74-1.19، شامل کیا گیا شور s=2 پر 2.2-3.0 دیتا ہے) تجویز کردہ اضافی گیٹ ہے۔

دائرہ: VideoTurko صرف ایک ہی پاس (زیادہ سے زیادہ 209 فریم، تقریباً 8.7 سیکنڈ) کے بارے میں ہے۔ ہمارے اپنے جوڑنے کے ٹیسٹ میں نظر آنے والے جوڑ ملے (منظر صاف طریقے سے آگے نہیں بڑھتا)، اس لیے لمبی فلمیں ہماری تصدیق کا حصہ نہیں ہیں۔ جوڑنے کے لیے کمیونٹی گائیڈ `docs/KLIP_ZINCIRI.md` اور صرف CPU استعمال کرنے والا ہمارا معاون `scripts/zincir.py` موجود ہے (`plan`، `son-kare`، `bagla`؛ یہ انجن کو کبھی شروع نہیں کرتا)؛ جوڑی گئی فلموں کا معیار ہم نے نہیں ناپا [آزمایا نہیں گیا]، اس لیے ہر جوڑ کو آنکھ سے اور `scripts/dikis_denetim.py` سے جانچیں۔
سیٹنگز آپ کی اپنی ہیں: 209 فریم 4 GB کارڈ پر ہمارا آزمایا ہوا ڈیفالٹ ہے، کوئی ایسی حد نہیں جس کی پابندی آپ پر لازم ہو۔ 17k+5 گرڈ پر کوئی بھی فریم تعداد چنیں (56، 73، ... 192، 209؛ دیکھیں `docs/KURULUM.md`)، پرامپٹ (prompt)، seed، ریزولوشن یا کوئی بھی فلیگ اپنی مرضی سے بدلیں۔ چھوٹے کلپس کو کم میموری اور کم وقت چاہیے؛ بڑے GPU شاید زیادہ سنبھال لیں۔

## ماڈل لائسنس کی وارننگ
**VideoTurko میں صرف پیچ اور اسکرپٹ ہیں (MIT)؛ جو بھی ماڈل اور اس کی آؤٹ پٹ استعمال کرتا ہے، MiniMax لائسنس کا ذمہ دار وہ خود ہے۔** یہ قانونی مشورہ نہیں۔ نیچے MiniMax H3 Community License (2 اگست 2026) کی شقیں ان کے نمبروں کے ساتھ خلاصہ کی گئی ہیں؛ پابند کرنے والی چیز لائسنس خود ہے: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

اس ریپوزٹری کا MIT لائسنس ماڈل ویٹس کا احاطہ نہیں کرتا؛ دیکھیں [`NOTICE`](NOTICE)۔ اس ریپوزٹری میں ماڈل کے کوئی وزن (weights) نہیں ہیں (MiniMax H3، HyperFlow-H3-Flash GGUF یا VAE کی کوئی فائل نہیں)۔ یہ پروجیکٹ MiniMax سے وابستہ نہیں اور MiniMax کی طرف سے تائید شدہ نہیں۔ تجارتی استعمال ممنوع نہیں (یہ غیر تجارتی لائسنس نہیں)؛ شرائط نیچے ہیں۔

**علاقہ (Applicable Territory)**
- **Preamble، I.3، I.5:** پوری دنیا، سوائے یورپی یونین، برطانیہ، جمہوریۂ کوریا اور ریاستہائے متحدہ کے۔ ماڈل کا استعمال لائسنس کی قبولیت شمار ہوتا ہے۔
- **II:** استعمال، نقل، تقسیم، مشتق کام بنانے اور ترمیم کے لیے محدود، ناقابلِ منتقلی، رائلٹی فری (royalty-free) لائسنس، صرف علاقے کے اندر اور معاہدے اور Exhibit A کے مطابق۔ خارج شدہ علاقوں کے لوگ MiniMax سے الگ لائسنس مانگ سکتے ہیں۔
- **V.4:** ماڈل، اس کے مشتقات اور **اس کی آؤٹ پٹ** (تیار شدہ ویڈیو/آڈیو) کا علاقے سے باہر استعمال، نقل، ترمیم، تقسیم یا نمائش مجاز نہیں۔ **لہٰذا تیار شدہ ویڈیوز کو یورپی یونین/برطانیہ/جنوبی کوریا/ریاستہائے متحدہ میں شائع کرنا یا دکھانا لائسنس سے باہر ہے۔**
- **Exhibit A-1:** علاقے سے باہر استعمال قابلِ قبول استعمال کی پالیسی (Acceptable Use Policy) کی خلاف ورزی ہے۔

**تقسیم (III)** (یہ ریپوزٹری ماڈل تقسیم نہیں کرتی؛ اگر آپ کرتے ہیں)
- **III.1:** ہر وصول کنندہ کو لائسنس کی ایک نقل دیں۔ **III.2:** ترمیم شدہ فائلوں پر نمایاں نوٹس لگائیں۔
- **III.3:** ترغیب دی جاتی ہے (لازمی نہیں): "Powered by MiniMax H3" کا نوٹس، تیار شدہ فائلوں پر AI سے تیار ہونے کی شناخت، اور عوامی تحریر۔
- **III.4:** تقسیم کے ساتھ لازماً ایک NOTICE فائل ہونی چاہیے جس میں یہ عبارت ہو: "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12:** کسی بھی عوامی ماحول میں ایسا مواد شائع کرنا ممنوع ہے جس کے مشین سے بنے ہونے کا واضح اعلان نہ ہو: AI سے بنی ویڈیوز شائع کرتے وقت ان پر لیبل لگائیں (مکمل فہرست: `docs/LISANS_UYARISI.md`)۔
- **III (آخری پیراگراف):** آپ اپنی ترامیم پر اپنا کاپی رائٹ شامل کر سکتے ہیں لیکن استعمال/تقسیم پر اضافی یا مختلف شرائط عائد نہیں کر سکتے؛ علاقے کے اصول بدستور لاگو رہتے ہیں۔

**تجارتی شرائط (IV)**
- **IV.1:** اگر آپ کی تجارتی مصنوعات/خدمات سالانہ 20 ملین امریکی ڈالر (USD) (یا اس کے مساوی) سے زیادہ آمدنی پیدا کرتی ہیں تو api@minimax.io سے پیشگی تحریری اجازت لیں (موضوع: "MiniMax H3 licensing - authorization request")۔
- **IV.2:** ماڈل استعمال کرنے والی تجارتی مصنوعات/خدمات کے انٹرفیس میں "MiniMax H3" نمایاں طور پر دکھایا جانا چاہیے۔

**استعمال کی پابندیاں (V)**
- **V.1:** قابلِ اطلاق قوانین (بشمول تجارتی تعمیل) اور Exhibit A کی پابندی کریں۔ **V.2:** جس کسی کو رسائی دیں اسے ایسی شرائط کا پابند کریں جو ان پابندیوں جتنی کم از کم محافظ ہوں، اور انہیں مطلع کریں۔
- **V.3:** آپ ماڈل یا **اس کی آؤٹ پٹ** کو کسی دوسرے AI ماڈل (MiniMax H3 اور اس کے مشتقات کے علاوہ) کو بہتر بنانے کے لیے استعمال نہیں کر سکتے۔ (I.11: ڈسٹلیشن (distillation) اور مصنوعی آؤٹ پٹ پر تربیت کسی ماڈل کو "مشتق" بنا دیتی ہے؛ آؤٹ پٹ خود مشتق نہیں ہیں۔)
- **V.5:** اگر آپ تیسرے فریقوں کو ایسی مصنوع/خدمت/ہوسٹڈ سروس دیتے ہیں جو ماڈل سے آؤٹ پٹ بناتی ہے: چلانے سے پہلے اور پورے دورانیے میں معقول تکنیکی اور تنظیمی حفاظتی اقدامات، رپورٹ کرنے کا نظام، فوری تفتیش، اور بار بار خلاف ورزی کرنے والوں کو ہٹانا/غیر فعال کرنا/معطل کرنا۔

**ٹریڈ مارک اور حقوق (VI)**
- **VI.1:** آپ جو مشتق کام اور ماڈل مشتقات بناتے ہیں ان کے مالک آپ ہیں (MiniMax کے حقوق کے تابع)۔ **VI.2:** MiniMax کے نام/نشانات کا لائسنس نہیں دیا گیا (بیان اور تقسیم کے لیے ضروری حد سے آگے)؛ "MiniMax H3" کا نشان صرف III.3 کی تعمیل کے لیے اور علاقے کے اندر استعمال ہو سکتا ہے؛ وابستگی کا تاثر نہ دیں۔
- **VI.3:** اگر آپ MiniMax یا کسی اور پر یہ دعویٰ کرتے ہوئے مقدمہ کرتے ہیں کہ مواد/آؤٹ پٹ آپ کے حقوق کی خلاف ورزی کرتے ہیں تو آپ کے تمام لائسنس اسی دن ختم ہو جاتے ہیں؛ آپ کے یا دوسروں کے استعمال/تقسیم سے پیدا ہونے والے تیسرے فریق کے دعووں کے خلاف آپ MiniMax کا دفاع کریں گے اور اسے ہرجانہ ادا کریں گے۔
- **VI.4:** MiniMax آؤٹ پٹ پر کوئی حق نہیں جتاتی؛ آؤٹ پٹ اور ان کے استعمال کے ذمہ دار آپ اور آپ کے صارفین ہیں۔

**دستبرداری اور خاتمہ (VII، VIII، IX)**
- **VII.1:** معاونت/اپ ڈیٹ کی کوئی ذمہ داری نہیں۔ **VII.2:** ماڈل اور آؤٹ پٹ "AS IS" (جیسے ہیں) بغیر کسی ضمانت کے دیے جاتے ہیں؛ موزونیت کا فیصلہ آپ کرتے ہیں اور خطرہ آپ اٹھاتے ہیں۔ **VII.3:** MiniMax اور اس کی ملحقہ کمپنیاں کسی نقصان کی ذمہ دار نہیں (جہاں تک قانون اجازت دے)۔
- **VIII.1:** قبولیت/رسائی پر نافذ ہوتا ہے۔ **VIII.2:** خلاف ورزی پر MiniMax لائسنس ختم کر سکتی ہے؛ آپ کو استعمال/تقسیم بند کرنی، نقلیں حذف کرنی اور وصول کنندگان کو مطلع کرنا ہوگا (VI.1، VI.3، VII، IX باقی رہتی ہیں)۔
- **IX:** ہانگ کانگ SAR کا قانون؛ ہانگ کانگ کی عدالتوں کا خصوصی دائرۂ اختیار (اقوامِ متحدہ کا CISG خارج ہے)۔
- **اضافی نوٹ:** MiniMax H3 کا انکوڈر Qwen3-VL-32B (Apache 2.0) استعمال کرتا ہے۔

**قابلِ قبول استعمال کی پالیسی (Exhibit A)** (ماڈل، مشتقات یا آؤٹ پٹ کو ان کاموں کے لیے استعمال نہ کریں)
- A-1 علاقے سے باہر استعمال؛ A-2 قوانین یا تیسرے فریق کی املاکِ دانش کی خلاف ورزی؛ A-3 اپنے آپ کو یا دوسروں کو نقصان پہنچانا؛ A-4 آؤٹ پٹ کو نقصان پہنچانے کے لیے دوسرے مقصد میں لانا/تقسیم کرنا؛ A-5 حفاظتی اقدامات کو دور کرنا؛ A-6 نابالغوں کا استحصال/انہیں نقصان پہنچانا؛ A-7 دوسروں کو نقصان پہنچانے یا انتخابات پر اثر ڈالنے کے لیے ثابت شدہ طور پر جھوٹی معلومات؛ A-8 جعلی آن لائن سرگرمی (جعلی ریویوز وغیرہ)؛ A-9 ہتکِ عزت، تحقیر، ہراسانی؛ A-10 میلویئر؛ A-11 دوسروں کو نقصان پہنچانے کے لیے ذاتی ڈیٹا؛ **A-12 کسی بھی عوامی ماحول (بشمول بوٹ پوسٹس) میں مواد کو اس کے مشین سے بنے ہونے کا واضح اور نمایاں اعلان کیے بغیر شائع کرنا**؛ A-13 رضامندی کے بغیر کسی کا روپ دھارنا؛ A-14 اہم شعبوں میں زیادہ خطرے والے خودکار فیصلے (قانون نافذ کرنا، امیگریشن، صحت، اہم بنیادی ڈھانچہ، قرض، روزگار، رہائش، تعلیم، سماجی اسکورنگ، بیمہ وغیرہ)؛ A-15 دوسرے ممالک/خطوں کے سماجی، اخلاقی اور اقداری معیارات کی خلاف ورزی؛ A-16 پرتشدد انتہا پسندی/دہشت گردی؛ A-17 محفوظ خصوصیات کی بنیاد پر امتیاز/نقصان؛ A-18 کمزور طبقات کا استحصال؛ **A-19 فوجی مقاصد**؛ A-20 غیر مجاز/بغیر لائسنس پیشہ ورانہ سرگرمی (مالی، قانونی، طبی وغیرہ)۔
- نوٹ: یہ سادہ زبان کا خلاصہ ہے؛ شک کی صورت میں لائسنس کا انگریزی متن مقدم ہے۔

## ثبوت کے لیبل

تمام دستاویزات کے لیے ایک ہی سیٹ (پرانی املا قوسین میں):
- **[پیمائش شدہ]** (EN: measured؛ TR: ölçtüm, olctum): اسی پروجیکٹ میں چلایا گیا، ثبوت کا راستہ موجود ہے۔
- **[پڑھا گیا]** (EN: read؛ TR: okudum yol, okudum): ماخذ یا اسکرپٹ پڑھا گیا، چلایا نہیں گیا۔
- **[ڈیزائن]** (EN: design؛ TR: tasarım, tasarim): ڈیزائن کیا گیا، حقیقی رن میں ابھی نہیں دیکھا گیا۔
- **[اندازہ]** (EN: guess؛ TR: tahmin): تصدیق شدہ نہیں۔
- **[آزمایا نہیں گیا]** (EN: not tried؛ TR: denenmedi): کبھی چلایا نہیں گیا۔
- **[صارف کی رپورٹ]** (EN: user-reported؛ TR: kullanıcı bildirdi): صارف نے تاریخ کے ساتھ بتایا؛ آزادانہ پیمائش نہیں ہوئی۔
- **[حساب شدہ]** (EN: computed؛ TR: hesap؛ پرانی املا: calculated, hesap): ناپے گئے ان پٹ سے نکالا گیا عدد، جو خود ناپا نہیں گیا؛ حساب کا طریقہ اس کے ساتھ لکھا ہوتا ہے۔ پرانے متن میں [proposal] / [öneri] = [اندازہ]۔

قوسین میں استعمال ہونے والے رنز کے نام (یہ ہمارے اپنے رنز کے نام ہیں، اس ریپوزٹری کی فائلیں نہیں): U209 = ریلیز بائنری کے ساتھ `uret.ps1` کے ذریعے 209 فریم؛ B209 اور B192 = 209 اور 192 فریم پر تصویر سے ویڈیو (‎`-InitImg`‎) کے رنز؛ B56VT2 = ریلیز بائنری، 56 فریم، 56 فریم کے بائٹ حوالے R0 سے موازنہ؛ F209b، F209V2، F209V2K = ڈیولپمنٹ بلڈ پر 209 فریم کے رنز (تفصیل: `docs/OLCUMLER.md`)۔

## معلوم حدود
- **بائٹ کا ثبوت** (خود دہرانے کا طریقہ: `docs/KANITLAR.md`، "R0 ve latent referansi nasil uretilir"؛ ہمارے sm_61 کارڈ پر جانچا گیا، دوسرے GPU بائٹ بہ بائٹ یکساں نہ ہوں [اندازہ]): ہماری پیچ سیریز کے ساتھ (میموری فلیگ آن) 56 فریم کے رن نے sha256 `0979f156d548169b...`‎ دیا، جو حوالے کے ساتھ یکساں تھا [پیمائش شدہ]؛ 141 فریم پر latent کا sha256 `E5D028F8632BE4FE...`‎ یکساں تھا (0013/0014 فلیگ کے ساتھ)۔ 158 سے 209 فریم کے لیے براہِ راست بائٹ حوالہ نہیں؛ گیٹ چین ہی ثبوت ہے۔ عددی گیٹس پاس کرنا اچھے کلپ کی ضمانت نہیں: وقت کے ساتھ حرکت کی ہم آہنگی آنکھ سے جانچی جاتی ہے (دیکھیں `docs/KAPILAR.md`)۔
- **209 فریم، کون سا فلیگ سیٹ:** 209 فریم کی بائٹ چین کا ثبوت ڈیولپمنٹ بلڈ پر F209V2 فلیگ سیٹ کے ساتھ لیا گیا (block-tail فلیگ کے بغیر، پیچ 0019/0020 کے بغیر بنایا گیا)؛ `uret.ps1` 209 فریم کے لیے یہی نسخہ استعمال کرتا ہے [پڑھا گیا: اسکرپٹ؛ `uret.ps1` کے ذریعے حقیقی انجن رن رن U209 میں پاس ہوا]۔
- ہم نے ایک کارڈ (GTX 1050 Ti 4 GB) پر تصدیق کی ہے؛ دیگر کارڈز کی بیرونی رپورٹیں لیبلز کے ساتھ `docs/KART_PROFILLERI.md` میں درج ہیں [صارف کی رپورٹ]۔
- **کون سی بائنری ناپی گئی:** 141 فریم کا latent اور بائٹ چین ہمارے ڈیولپمنٹ بلڈز سے ناپے گئے۔ جو ریلیز بائنری آپ ڈاؤن لوڈ کرتے ہیں وہ ایک نیا بلڈ ہے: اس کا 56 فریم کا بائٹ گیٹ پاس ہوا (اگلا نکتہ) اور `uret.ps1` کے ذریعے 209 فریم کا رن گیٹ سے گزرا (رن U209، 3414 سیکنڈ، VRAM کی چوٹی 3777 MiB) [پیمائش شدہ]؛ ڈیولپمنٹ بلڈ کے 209 رن کے مقابلے میں latent بائٹ بہ بائٹ یکساں ہے؛ ویڈیو میں فریم (md5) اور آڈیو یکساں ہیں، AVI فائل کا sha256 کنٹینر کی وجہ سے مختلف ہے [پیمائش شدہ] (دیکھیں `docs/OLCUMLER.md`، حصہ 0)۔
- **ریلیز بائنری، 56 فریم:** ریلیز بائنری (sd-cli `c5cebe78...`‎، stable-diffusion.dll `e5d3d329...`‎) نے R0 کے ساتھ بائٹ بہ بائٹ یکساں 56 فریم کا نتیجہ دیا (sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`؛ ہر فریم کا md5 اور آڈیو یکساں)، ڈیفالٹ فلیگ کے ساتھ براہِ راست چلایا گیا (کوئی `SD_*` متغیر نہیں)، ایگزٹ کوڈ 0، 601 سیکنڈ [پیمائش شدہ: رن B56VT2، 2026-11-19؛ ثبوت مصنفین کے پاس محفوظ ہیں، اس ریپوزٹری میں نہیں]۔ دائرہ: صرف ہمارا sm_61 کارڈ اور 56 فریم؛ یہ صاف جڑ کا انسٹال ٹیسٹ نہیں؛ 141 فریم کا latent اور 209 کی چین پرانی بائنری سے ناپی گئی تھی اور اس بائنری کے ساتھ دہرائی نہیں گئی [آزمایا نہیں گیا]۔ پہلی کوشش (B56VT، معاون اسکرپٹ کے ذریعے) 58 سیکنڈ بعد خاموشی سے ختم ہو گئی، وجہ نامعلوم [اندازہ: میموری کا دباؤ]؛ دوسری کوشش میں `sd-cli` براہِ راست چلایا گیا۔
- انسٹال اور رن اسکرپٹ ابھی خالی فولڈر سے جانچے نہیں گئے (صاف جڑ کا ٹیسٹ باقی ہے)۔
- روڈ میپ اور اگلے اقدامات: `ROADMAP.md`۔

## صورتِ حال اور حدود
- ایک مشین پر جانچا گیا (GTX 1050 Ti، 4 GB، 16 GB RAM، i7-7700HQ)۔ دوسرے 4 GB کارڈ اور دوسری RAM مقداریں مختلف ہو سکتی ہیں۔
- **ڈیفالٹ 209 فریم (8.7 سیکنڈ):** ہمارے معیار کے گیٹس سے گزرا (شور 1.08، رن F209V2K) [پیمائش شدہ: ریلیز (release) بائنری کے ساتھ `uret.ps1` کے ذریعے 209 فریم، رن U209؛ latent ڈیولپمنٹ بلڈ کے رن کے ساتھ بائٹ بہ بائٹ یکساں ہے؛ ویڈیو میں فریم اور آڈیو یکساں ہیں، فائل کا sha کنٹینر کی وجہ سے مختلف ہے؛ ثبوت مصنفین کے پاس محفوظ ہیں، اس ریپوزٹری میں نہیں]۔ 209 فریم پر DiT کی VRAM چوٹی 4096 MiB میں سے 3777 MiB تھی (رنز F209b اور U209؛ پورے کارڈ کی `nvidia-smi` ریڈنگ)، یعنی گنجائش کم ہے: GPU پر کوئی اور بوجھ (ڈسپلے، دوسری ایپلی کیشنز) رن کو `blocks.0` پر ناکام کر سکتا ہے؛ صرف GTX 1050 Ti پر آزمایا گیا۔ اس رن کے دوران ڈسپلے کی حالت درج نہیں کی گئی؛ اگر آپ کا ڈسپلے اسی کارڈ پر چلتا ہے تو کم VRAM دستیاب ہوگی [اندازہ: Windows ڈسپلے کا بوجھ تقریباً 100-300 MB]؛ ضرورت ہو تو ڈسپلے کو انٹیگریٹڈ GPU سے جوڑیں [مشورہ، آزمایا نہیں گیا]۔ sampling میں 2730 سیکنڈ لگے (رن U209: مراحل 436-483 سیکنڈ کے) اور الگ پروسیس VAE ڈی کوڈ میں 173 سیکنڈ (آڈیو ڈی کوڈ سمیت مرحلہ 2 کل 193 سیکنڈ) [پیمائش شدہ: U209 ریلیز بائنری؛ پرانے ڈیولپمنٹ رنز: 2664 اور 174 سیکنڈ]۔ مرحلہ 1 میں پروسیس کے اندر والا VAE میموری سے باہر ہو گیا اور temporal tiling پر چلا گیا (320 سیکنڈ)؛ وہ آؤٹ پٹ رد کر دی جاتی ہے، ویڈیو بغیر ٹائلنگ والے مرحلہ 2 سے لی جاتی ہے۔ U209 میں RAM کی چوٹی نہیں ناپی گئی۔ 209 فریم سے لمبے کلپس اس ریلیز کا حصہ نہیں۔
- **تصویر سے ویڈیو (‎`-InitImg`‎):** ابتدائی تصویر کے ساتھ اس GPU پر حد 192 فریم ہے (24 fps پر 8.0 سیکنڈ): 209 فریم نہیں سمائے (بلاک 0 پر تقریباً 17.5 MB VRAM کم تھی: 2587 MB درکار، 2570 MB دستیاب)؛ 192 فریم `uret.ps1` کے ذریعے 3086 سیکنڈ میں چلے، VRAM کی چوٹی 3783 MiB رہی اور گیٹ پاس ہوا [پیمائش شدہ: رنز B209 اور B192، 2026-11-20، ایک منظر؛ ثبوت مصنفین کے پاس محفوظ ہیں، اس ریپوزٹری میں نہیں]۔ دوسرے GPU پر نہیں آزمایا گیا [آزمایا نہیں گیا]۔
- **خالی RAM اہم ہے:** آپ کو تقریباً 11 GB خالی RAM چاہیے (انجن پروسیس تقریباً 11 GB رکھتا ہے) [پیمائش شدہ]۔ خالی RAM بہت کم ہو تو پروسیس بغیر کسی خرابی کے پیغام کے ختم ہو سکتا ہے [اندازہ: ہم نے یہ ایک بار تقریباً 300 MB خالی RAM کے ساتھ دیکھا جب `sd-cli` تقریباً 10 GB رکھے ہوئے تھا]۔ چلتے وقت دوسرے بڑے پروگرام نہ کھولیں: 16 GB کی مشین پر صرف تقریباً 0.3-0.5 GB خالی رہتی ہے اور میموری کے دباؤ میں رن خاموشی سے ختم ہو سکتا ہے۔ شروع کرنے سے پہلے براؤزر، گیمز اور دوسرے بڑے پروگرام بند کریں اور خالی RAM دیکھ لیں۔
- **صاف جڑ کا ٹیسٹ باقی ہے:** انسٹال اور رن اسکرپٹ ابھی صرف ان ہدایات کی بنیاد پر خالی فولڈر سے جانچے نہیں گئے؛ جب وہ ٹیسٹ (بشمول حوالے کے ساتھ 56 فریم کا بائٹ موازنہ) درج ہو جائے گا تو یہ حصہ اپ ڈیٹ کیا جائے گا۔
- یہاں کوئی تیار شدہ ویڈیو شامل نہیں۔

</div>

<!-- i18n-source: README.md sha256:a26a5a878a5f -->
