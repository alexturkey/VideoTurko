# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · العربية · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

<div dir="rtl">

تتبع الترجمات ملف README الإنجليزي هذا. إذا اختلفت الترجمة أو تأخرت عنه فالنص الإنجليزي هو المرجع، خاصة في نص الترخيص والأمان (يُحتفظ بـ [`SECURITY.md`](SECURITY.md) و[`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) بالإنجليزية والتركية فقط).

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **قبل أن تبدأ (الترخيص، النطاق الجغرافي):** هذا المستودع بترخيص MIT ويحتوي على رقع وسكربتات فقط. نموذج MiniMax H3 الذي ينزّله خاضع لترخيص MiniMax H3 Community License: يستثني نطاقه الاتحاد الأوروبي والمملكة المتحدة وكوريا الجنوبية والولايات المتحدة، ولا يجوز استخدام النموذج ومشتقاته **ومخرجاته (مقاطع الفيديو التي تولّدها)** أو توزيعها أو عرضها هناك (V.4). الاستخدام التجاري مسموح ضمن شروط الترخيص. اقرأ [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) قبل التثبيت؛ وهذه ليست استشارة قانونية.

> **في 30 ثانية:** بطاقة رسوميات بسعة 4 GB تستطيع إنتاج فيديو MiniMax H3 من 209 إطارًا (8.7 ثانية) في تمريرة واحدة: جرى التحقق من ذلك على جهاز واحد (GTX 1050 Ti بسعة 4 GB؛ ولم يُتحقق بعد من التثبيت الكامل عبر `kur.ps1` في مجلد فارغ من البداية إلى النهاية) [مقيس: 209 إطارًا بالملف التنفيذي الخاص بالإصدار (release) عبر `uret.ps1`، تشغيل U209؛ المتجه الكامن (latent) مطابق بايتًا ببايت لتشغيل نسخة التطوير؛ الإطارات والصوت متطابقة في الفيديو، ويختلف sha الملف بسبب الحاوية؛ الأدلة يحتفظ بها المؤلفون وليست في هذا المستودع]؛ ومع ‎`-InitImg`‎ (من صورة إلى فيديو) بحد أقصى 192 إطارًا (8.0 ثانية) [مقيس: تشغيل B192]؛ ويستغرق إنتاج 209 إطارًا نحو 57 دقيقة، والحد الزمني الافتراضي 80 دقيقة [مقيس: تشغيل U209]؛ والخطوات الـ 3 أدناه هي طريقة التشغيل.

VideoTurko: رقع ذاكرة لـ stable-diffusion.cpp ووصفات تشغيل لتوليد فيديو من نص بنموذج MiniMax H3 على بطاقة GTX 1050 Ti بسعة 4 GB، حتى 209 إطارًا (8.7 ثانية) في تمريرة واحدة؛ وتوليد الفيديو من صورة (‎`-InitImg`‎) حتى 192 إطارًا (8.0 ثانية) (جرى التحقق من 209 إطارًا عبر سلسلة مطابقة البايتات؛ والنتيجة مطابقة بايتًا ببايت للتشغيل دون رقع في اختباري 56 و141 إطارًا).

## البدء السريع (Windows، 3 خطوات)
**الحالة: سكربتات التثبيت والتشغيل أدناه قيد الإنهاء، واختبار الجذر النظيف (clean-root) لم يُجرَ بعد؛ لا يُدّعى هنا أن شيئًا يعمل إلى أن ينجح ذلك الاختبار (انظر "الحالة والحدود").**

1. **نزّل** هذا المستودع (الزر الأخضر **Code** ثم **Download ZIP**) وفُكّ ضغطه في مجلد ذي مسار قصير، مثل `C:\vt`.
2. **التثبيت: انقر نقرًا مزدوجًا على ‎`kur.cmd`‎** (تفتح نافذة سوداء تعرض كل خطوة؛ إغلاقها يوقف التثبيت، وتشغيله مرة أخرى يتابع من حيث توقف: يُستأنف ملف النموذج المحمَّل جزئيًا [مقروء: يحتفظ سكربت التنزيل بملف ‎`.part`‎ ويتابع منه؛ لم يُقَس استئناف كامل بحجم 29 GiB]). إذا حذّرك Windows من الملف الذي نزّلته فاستخدم أمر PowerShell أدناه بدلًا من ذلك [نصيحة، لم تُختبر على ملف ZIP منزَّل]. هل تفضّل سطر الأوامر؟ افتح PowerShell في ذلك المجلد (اكتب ‎`powershell`‎ في شريط عنوان المستكشف) ونفّذ التثبيت نفسه:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   جذر التثبيت هو المجلد الذي فككت فيه الضغط (المحرك في `engine\bin` والنماذج في `model`)؛ ولاستخدام مكان آخر اضبط متغير البيئة `VT_ROOT` أولًا. يفحص السكربت وحدة GPU وبرنامج التشغيل وذاكرة RAM والقرص، ثم ينزّل المحرك والنماذج (تُفحص حزم zip الخاصة بالمحرك وملفات النماذج المنزَّلة حديثًا بـ sha256؛ أما ملف نموذج موجود أصلًا وبحجم صحيح فيُفحص حجمه فقط، ولإجراء فحص sha256 كاملًا شغّل `scripts\modelleri_indir.ps1 -Dogrula`)، ويجري فحصًا حقيقيًا قصيرًا، ولا يطبع READY إلا إذا نجح هذا الفحص [تصميم: لم يُشغَّل `kur.ps1` كاملًا في مجلد نظيف؛ تُحدَّث هذه الجملة بعد اختبار المجلد النظيف]. الخيار ‎`-ExecutionPolicy Bypass`‎ يسري على هذه العملية وحدها؛ اقرأ `scripts\kur.ps1` أولًا كما تفعل مع أي مثبّت.
   تأتي حزمة zip الخاصة بالمحرك من الإصدار (release) v0.1.0 على GitHub (نُشر في 2026-11-19؛ وقيمة sha256 الخاصة بها مثبّتة في `kur.ps1`). وإن كنت دون اتصال بالإنترنت أو تستخدم محركًا بنيته بنفسك، فمرّر حزم zip محلية: ‎`-MotorZip <path> -CudaZip <path>`‎. ويُفحص الـ zip المحلي أيضًا مقابل قيمة sha256 المثبّتة نفسها (ويُتجاهل أي ملف `.sha256` بجانبه)، لذا يجب أن يكون zip الإصدار نفسه؛ أما لمحرك بنيته بنفسك فاضبط أولًا ‎`VT_MOTOR_SHA256`‎ / ‎`VT_CUDA_SHA256`‎ على قيمة sha256 الخاصة به. وأي sha256 خاطئ يوقف التنفيذ بـ exit 1. لا يُنقل إلى `engine\bin` سوى ملفات `.exe`/`.dll`؛ أما التراخيص وملف README فتذهب إلى `engine\lisanslar\<zip name>\`‎. [جُرِّب مع حزم dist zip قبل صدور الإصدار: ملف `.sha256` المجاور مع تحذير أن الملف يشير إلى نفسه، وُضع الملف التنفيذي وملفات DLL، وعمل `sd-cli --help`؛ وتطابقت قيم sha للملفات التنفيذية المثبَّتة (`c5cebe78...`‎، `e5d3d329...`‎)؛ أما خطوة النماذج وفحص الإطارات الـ 5 في `kur.ps1` فلم تُشغَّل بعد على GPU حقيقية]
   **ترخيص النموذج:** قبل خطوة النماذج يطبع المثبّت ملخص الترخيص (`docs/LISANS_KABUL.txt`، والنص الكامل `docs/LISANS_UYARISI.md`: ترخيص MiniMax H3 Community License، وقيود النطاق الجغرافي التي تشمل الفيديوهات المولَّدة أيضًا، وقواعد الاستخدام التجاري ووسم الذكاء الاصطناعي) ويطلب منك القبول (`E` = نعم). اقرأه أولًا. وللتشغيل دون إشراف يمكنك تمرير ‎`-LisansKabul E`‎، وهذا يعني أنك قرأت الترخيص وقبلته بنفسك؛ لا تضفه نيابةً عن شخص آخر. (وكلاء الذكاء الاصطناعي: اتبعوا `AGENTS.md`؛ ولا تكتبوا E أبدًا دون موافقة المستخدم.) وبدون القبول يتوقف `kur.ps1` برمز الخروج 2 ولا ينزّل أي نموذج.
3. **أول فيديو لك (56 إطارًا، نحو 11 دقيقة على بطاقة GTX 1050 Ti لدينا** [مقيس: 641 ثانية، التشغيل R0، ‎`docs/OLCUMLER.md`‎؛ لم تُقَس بطاقات أخرى]**)**: عندما يطبع المثبّت ‎`HAZIR / READY`‎ نفّذ
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (اختصار: اسحب ملف نص الموجّه إلى ‎`uret.cmd`‎ أو نفّذ ‎`uret.cmd docs\ornek_istem_R0.txt`‎: التشغيل نفسه بـ 56 إطارًا). يوجد الفيديو في ‎`runs\`‎. بعد ذلك اكتب موجّهك الخاص في ملف نصي (فقرة واحدة بالإنجليزية، وجملة ‎`audio:`‎ اختيارية) ونفّذ أطول مقطع نغطيه (الافتراضي، نحو 57 دقيقة [مقيس: التشغيل U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   قيمة ‎`-Kare`‎ تتبع الشبكة 17k+5 (56، 73، ... 192، 209)؛ والافتراضي 209 (8.7 ثانية)، وهو أقصى طول نغطيه. يعمل VAE في عملية منفصلة ولا يُقسَّم إلى بلاطات (tiling) أبدًا [تشغيل حقيقي للمحرك عبر `uret.ps1` بالملف التنفيذي للإصدار، مع VAE في عملية منفصلة، نجح في تشغيل U209].

   دليل كتابة الموجّه (prompt): [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (نمط اللقطة المستمرة الواحدة، شرائح زمنية متساوية، مثالان كاملان).

| المتطلب | القيمة |
|---|---|
| نظام التشغيل | Windows 10/11، 64 بت |
| GPU | NVIDIA بسعة 4 GB أو أكثر؛ جُرّبت على GTX 1050 Ti (sm_61) فقط؛ هامش ضيق (3777/4096 MiB عند 209 إطارًا): شاشة مشغولة أو متصفح مفتوح قد يفسد التشغيل؛ لم تُجرَّب أي بطاقة أخرى بسعة 4 GB |
| RAM | 16 GB (الذروة نحو 11 GB؛ أغلق البرامج الأخرى) |
| القرص | ما لا يقل عن 32 GiB فارغة (يُنصح بـ 40 GiB فأكثر: بين 32 و40 يطبع المثبّت تحذيرًا، ‎`[VT-W-DISK-PAY]`‎ [مقيس: تشغيلات ‎`-Kuru`‎ بقرص محاكى])، والنماذج على SSD (يفضَّل NVMe) |
| التنزيل | حزمة المحرك zip حجمها 36.8 MB + حزمة CUDA runtime zip حجمها 567.5 MB [مقيس] + النماذج 31,473,112,040 بايت (نحو 29.3 GiB) [مقروء: الأحجام في `scripts/modeller.json`]؛ المجموع نحو 30 GiB |
| النماذج | غير مضمَّنة؛ ينزّلها المثبّت بموجب ترخيص MiniMax (انظر التحذير أدناه). النماذج (29.3 GiB، 31,473,112,040 بايت في `scripts/modeller.json`) ليست في هذا المستودع ولا في الإصدار: تسري حدود حجم الملفات والإصدارات في GitHub، وينزّلها `kur.ps1` من المصدر الرسمي مع التحقق بـ sha256. |

رموز الخروج لـ `kur.ps1`: 0 READY، 1 خطأ، 2 مطلوب إدخال من المستخدم (الترخيص، أو لا يوجد إصدار/zip بعد)، 3 العتاد أو القرص غير كافٍ، 4 أُوقف (ملف DUR). يقبل `uret.ps1` النتيجة فقط إذا وُجد ملف `.avi` وكان عدد الإطارات صحيحًا والسجلات نظيفة [مقيس: تشغيل حقيقي واحد عبر `uret.ps1` بالملف التنفيذي للإصدار، تشغيل U209، 209 إطارًا، اجتازت البوابة]. رموز الخروج لـ `uret.ps1`: 0 DONE (اجتازت بوابة الجودة)، 1 خطأ أو مخرجات غير صالحة (بما فيها فيديو بلا مسار صوتي)، 2 أُوقف (ملف DUR)، 5 `KAPI RED` (لم تجتز بوابة الجودة: المقطع غير مقبول، والقرار لك)، 6 تعذّر تشغيل البوابة (المقطع غير مقبول). التفاصيل في AGENTS.md. [مقيس: رموز الخروج 0 و1 (فيديو صامت) و5 و6 في سيناريوهات بمحرك وهمي وبوابة وهمية؛ المحرك الحقيقي: exit 0 في تشغيل U209]

### استكشاف الأخطاء وإصلاحها (التفاصيل: `docs/SIK_HATALAR.md`)
تحمل أسطر الأخطاء في سكربتاتنا رمزًا ثابتًا، مثل ‎`HATA: [VT-E-DLL] ...`‎ أو ‎`UYARI: [VT-W-DISK-PAY] ...`‎. ابحث عن الرمز في [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) (مثال المرساة ‎`#vt-e-dll`‎) أو في ‎`docs/hata_imzalari.json`‎، واكتب الرمز في issue الخاص بك. يبقى العمود الأول من الجدول أدناه كما هو مطبوع (لا تترجم الرموز ولا نص السجل).

| ما تراه | معناه وما يجب فعله |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | لا تشغّل `sd-cli.exe` يدويًا؛ شغّل `scripts\kur.ps1` الذي يضع ملفات CUDA DLL في أماكنها. |
| `failed during weight preparation` عند `blocks.0` (#1, #3, #5) | VRAM غير كافية عند بوابة الذاكرة: استخدم عدد إطارات أصغر من الشبكة 17k+5، وأغلق برامج GPU الأخرى، وأبقِ الأعلام (flags) المرفقة كما هي. |
| `retrying with temporal tiling` (#6) | تراجع VAE إلى التقسيم إلى بلاطات؛ المخرجات غير صالحة لأغراض الجودة. أعد التشغيل. |
| ينتهي التشغيل عند الحد الزمني دون فيديو (#7) | ارفع ‎`-TavanDk`‎ للمقاطع الطويلة (الحد الزمني الافتراضي: 80 دقيقة لـ 209 إطارًا، يحدده `uret.ps1`؛ وتشغيلنا لـ 209 إطارًا استغرق 57 دقيقة [مقيس: تشغيل U209]). |
| رمز الخروج فارغ لكن الرسالة "finished" (#14) | قرأ الغلاف (wrapper) رمز الخروج مبكرًا جدًا؛ أعد التشغيل وتحقق من وجود ملف الفيديو. |
| يبطؤ النظام ويبدأ التبديل (swapping) (#18) | يستهلك المحرك نحو 10-11 GB من RAM؛ أغلق المتصفحات والبرامج الأخرى. |
| عدم تطابق sha256 / فشل التنزيل | غالبًا انقطع التنزيل: شغّل الأمر نفسه مرة أخرى، وتُتخطى الملفات التي جرى التحقق منها. |

**عالق أو فضولي؟** [`SUPPORT.md`](SUPPORT.md) (أين تسأل؛ مواعيد الرد أهداف وليست التزامات) · [`PRIVACY.md`](PRIVACY.md) (لا قياس عن بُعد؛ تُستخدم الشبكة فقط لتنزيل المحرك والنماذج من المضيفين المذكورين) · [`SECURITY.md`](SECURITY.md) (إبلاغ خاص) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (أول pull request في 5 خطوات؛ لا حاجة إلى GPU للوثائق والسكربتات).

### الجديد في v0.1.1: خيارات إضافية (التفاصيل: `AGENTS.md`، `docs/SIK_HATALAR.md` 19-23)
دون هذه الخيارات لا يتغير شيء على بطاقة بسعة 4 GB (اجتاز فحص البايتات لـ 56 إطارًا مقابل مرجعنا مرة أخرى مع v0.1.1 [مقيس]). أضف ‎`-Kuru`‎ إلى أي أمر لترى ما الذي سيُشغَّل.
- الخيار ‎`-EndImg`‎: مرّر الإطار الأخير أيضًا (الإطار الأول والأخير، "FLF")؛ الحد الأقصى 175 إطارًا على البطاقات التي تقل سعتها عن 8 GB (لم يتسع 192 على 4 GB)، و192 على البطاقات بسعة 8 GB فأكثر. على بطاقتنا GTX 1050 Ti يعمل دائمًا في عمليتين: 56 إطارًا في 1040 ثانية، و175 إطارًا في 2887 ثانية (48 دقيقة)، واجتاز كلاهما البوابة [مقيس]. نصائح كتابة الموجّه (prompt): `docs/ISTEM_YAZIMI.md`.
- الخياران ‎`-W`‎ / ‎`-H`‎: أبعاد أخرى، مثل الوضع العمودي 384x640؛ من مضاعفات 32، ومساحة لا تقل عن 640x384 (لا أصغر أبدًا). لم تُجرَّب على 4 GB؛ وعلى البطاقات التي تقل سعتها عن 8 GB تُرفض الأبعاد التي تتجاوز أكبر مهمة قسناها. عتبات بوابة الجودة معايَرة على 640x384.
- الخيار ‎`-TekAsama`‎: عملية واحدة بدلًا من اثنتين، للبطاقات الكبيرة فقط؛ ولا يُفعَّل تلقائيًا أبدًا.
- بطاقات GPU الأحدث (compute capability 7.0 فأعلى، مثل RTX 20/30/40): يُضبط `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` تلقائيًا ما لم تضبطه بنفسك؛ وقد عالج هذا ظهور فيديو أسود بالكامل عند 141 إطارًا فأكثر على بطاقة RTX 4070 Ti لدى صاحب البلاغ [أبلغ المستخدم، issue #1]. وإن لم يتوفر Python + OpenCV، يتوقف `uret.ps1` الآن بـ exit 6 قبل مهمة GPU (لا يُنتَج فيديو، ولا نتيجة RED مضلِّلة).
- شكرًا لـ @SinanC73 على تقرير RTX 4070 Ti الذي أدى إلى هذه التغييرات ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1)).

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

## ملفات تعريف السرعة الاختيارية (حزمة السرعة؛ متوقفة افتراضيًا)
لا شيء مما يلي يغيّر التشغيل الافتراضي (640x384، 209 إطارات، 3414 ثانية على بطاقتنا). هذه ثلاث خلايا مقيسة خارجه، كل منها ملف تعريف مسمّى في ‎`uret.ps1`‎؛ وهي تحتاج إلى محرك حزمة السرعة (محرك الإصدار مع الرقع 0021 و0023 و0024، وكلها متوقفة افتراضيًا: ‎`docs/YAMALAR.md`‎). ثبّته بالأمر ‎`scripts\kur.ps1 -HizPaketi`‎ (يعمل ملف zip محلي مع ‎`-MotorZip`‎)، ثم أضف ‎`-Profil <name>`‎؛ و‎`-Kuru`‎ يطبع ما سيُشغَّل. تُنشر حزمة السرعة مع الإصدار v0.1.4.

| الملف | الحجم، الطول | الزمن الإجمالي على GTX 1050 Ti 4 GB | الحالة |
|---|---|---|---|
| (لا شيء، افتراضي) | 640x384، حتى 209 إطارات (8.7 ثانية) | 209 إطارات: 3414 ثانية | تم التحقق، دون تغيير |
| ‎`yuksek832`‎ | 832x480، 141 إطارًا (5.9 ثانية) | نحو 55-56 دقيقة | قابل للاستخدام، موجِّهان [مقيس] |
| ‎`yuksek832 -Kare 124`‎ | 832x480، 124 إطارًا (5.2 ثانية) | نحو 45-46 دقيقة، دون حاجة إلى راية سرعة | قابل للاستخدام، موجِّهان [مقيس] |
| ‎`yuksek896`‎ | 896x512، 124 إطارًا (5.2 ثانية) | نحو 56-57.5 دقيقة | قابل للاستخدام، موجِّهان [مقيس] |
| ‎`uzun260`‎ | 640x384، 260 إطارًا (10.8 ثانية) | 78 دقيقة مقيسة دون الخروج المبكر؛ ومعه نحو 71-72 دقيقة [تخمين: لم يُقَس من البداية إلى النهاية عبر ‎`uret.ps1`‎] | مشروط وتجريبي |

- **هامش ضيق:** عند 832x480 x 141 تترك بوابة الذاكرة هامشًا من رقم واحد بالميغابايت (5.7 و6.8 MB في التشغيلين الكاملين). فُحص موجّهان طويلان (1520 و2041 حرفًا) بقراءة البوابة للخطوة 1 وجزء من الخطوة 2 فقط، دون تشغيل كامل: الهامش 10.9 و4.0 MB. أي عملية أخرى تحجز ذاكرة البطاقة (المتصفح، شاشة ثانية) قد تتسبب في الفشل؛ عندها استخدم ‎`-Kare 124`‎ أو الحجم الافتراضي [مقيس، GTX 1050 Ti 4 GB].
- **‎`uzun260`‎ مشروط:** حد الذاكرة ضيق جدًا (ذروة VRAM 3903 من 4096 MiB)، وزاد استخدام الذاكرة المشتركة بمقدار 45 و61 MiB (68)، ولا يوجد مرجع بلا رايات للتطابق بايتًا ببايت، لذلك لا يُقدَّم كميزة عادية. الرقعة 0023 مقبولة لهذه الخلية وحدها.
- **غير مُقدَّم:** 832x480 عند 158 إطارًا نجح مع طلب قصير فقط (ومع طلب طويل تجاوز حدَّ الذاكرة المشتركة)؛ أما 175 إطارًا فقد فُحص بقراءة البوابة فقط (نقص نحو 275 MB في الكتلة الأولى، دون تشغيل كامل). يقدّم الملف التعريفي 141 إطارًا فقط. الأحجام وأعداد الإطارات الأخرى يرفضها ‎`-Profil`‎ (استخدم المسار الافتراضي).
- الجودة الافتراضية لم تُمَسّ: 6 خطوات، cfg 1، VAE بلا بلاطات، 17k+5 إطارًا. حيث تكون الرايات مفعّلة، قورن الناتج بايتًا ببايت بالفيديو بلا رايات في الأحجام التي يتسع فيها التشغيل بلا رايات (‎`docs/YAMALAR.md`‎)؛ وعند 832x480 x 141 و896x512 x 124 لا يتسع التشغيل بلا رايات، لذا يستند التطابق هناك إلى أقرب الخلايا لا إلى مقارنة مباشرة [مقيس، مقروء].
- المرحلة 1 من التشغيل ذي المرحلتين تنتهي الآن بمجرد اكتمال ملف latent (‎`VT_ERKEN_CIKIS=0`‎ يعطّل ذلك).

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

## ما هذا المشروع
مجموعة من رقع صغيرة للذاكرة والجدولة لـ stable-diffusion.cpp، مع وصفة التشغيل والفحوص والقياسات، تتيح تشغيل MiniMax H3 (نموذج DiT بحجم 33B؛ نشغّل ملف GGUF لـ HyperFlow Flash 13.7B بصيغة Q4_K_M؛ ومشفّر النص Qwen3-VL بحجم 32B منفصل) على بطاقة GPU من جيل Pascal بسعة 4 GB (GTX 1050 Ti، وذاكرة نظام 16 GB).
- أطوال التمريرة الواحدة التي أنتجناها فعلًا واجتازت بوابات الجودة لدينا: 56 و141 و158 و175 و192 و209 إطارًا بدقة 640x384 وسرعة 24 fps (209 إطارًا = 8.7 ثانية)، مع الصوت الذي يولّده H3 نفسه [مقيس: 209 إطارًا بالملف التنفيذي للإصدار عبر `uret.ps1`، تشغيل U209؛ المتجه الكامن (latent) مطابق بايتًا ببايت لتشغيل نسخة التطوير؛ الإطارات والصوت متطابقة في الفيديو، ويختلف sha الملف بسبب الحاوية؛ الأدلة يحتفظ بها المؤلفون وليست في هذا المستودع]. والطول 209 هو الأطول الذي شاهدناه ووجدناه سلسًا [أبلغ المستخدم، 2026-11-19، شوهد الفيديو كاملًا؛ الملف: مخرجات F209V2، 8.708 ثانية].
- **ادعاء مطابقة البايتات، بنطاق صادق:** فُحصت المخرجات للتأكد من مطابقتها بايتًا ببايت للمرجع دون رقع عند 56 و141 إطارًا فقط. أما عند 158/175/192/209 إطارًا فقد استخدمنا الأعلام نفسها وسلسلة الملفات التنفيذية نفسها؛ ولا يوجد مرجع بايتات مباشر (فالإصدار دون رقع لا يستطيع تشغيل هذه الأطوال على هذه الـ GPU).
- لا تُخفَّض إعدادات الجودة أبدًا: النموذج/التكميم نفسه، و6 خطوات، وcfg 1، ودقة 640x384، والبذرة (seed) نفسها، وVAE دون تقسيم إلى بلاطات.
- لا ندّعي أننا الأوائل: بحثنا فلم نجد مثالًا خارجيًا على هذا على 4 GB، وهذا ليس دليلًا على أنه غير موجود.

## بنية المجلدات
- `patches/` رقع على commit محدد (pinned) من stable-diffusion.cpp (انظر الملاحظات هناك)
- `scripts/` البناء والتشغيل وVAE في عملية منفصلة ومساعدات البوابة/الاتساق (`doku_norm.py`: انظر ملاحظة المقياس أدناه)
- `docs/KURULUM.md` العتاد وخطوات البناء والتشغيل (EN+TR)
- `docs/YAMALAR.md` قائمة الرقع، و`docs/KANITLAR.md` الأدلة، و`docs/KAPILAR.md` جدول بوابات الجودة، و`docs/OLCUMLER.md` القياسات، و`docs/SIK_HATALAR.md` الأخطاء الشائعة، و`docs/LISANS_UYARISI.md` بنود الترخيص كاملة
- فهرس مختصر لـ `scripts/`: `hiz_kos3.ps1` غلاف التشغيل (الخيار ‎`-Kuru`‎ يطبع الأمر الدقيق)، و`uretim_kapi.ps1` بوابة الجودة، و`dikis_denetim.py` فحص الدرز (الوصلات)، و`doku_norm.py` الضجيج المطبَّع بالنسيج، و`bayt_kiyas.py` مقارنة البايتات، و`derleme_sablonu.ps1` قالب البناء (يوقف فقط عملية Visual Studio المساعدة للقياس عن بُعد `vctip.exe` التي بدأت بعد بدء البناء نفسه، والتي تُبقي عملية البناء متصلة لدقائق؛ أما عمليات `vctip.exe` الأخرى فتُترك)

## بوابات الجودة (كيف تُقبل النتيجة)

لا تفحص هذه البوابة اتساق الحركة (قفزات في حجم الأجسام أو موضعها): شاهد الفيديو كاملًا قبل قبوله.
1. عدد الإطارات ووجود الصوت؛ ولا أسطر للتراجع (fallback) في الذاكرة أو ALLOC_FAILED في السجل.
2. بوابة الضجيج الخام: باقي المرشح الوسيطي <= 1.5 (على مقياس 0-255).
3. الضجيج المطبَّع بالنسيج، `scripts/doku_norm.py` (نسخة هذا المستودع): N = الباقي الوسيطي / نسيج Sobel، كل 6 إطارات. **ملاحظة المقياس:** في هذه النسخة تعطي المقاطع الـ 10 المقيسة N = 0.034-0.052 (الجدول في `docs/KAPILAR.md`؛ والربع الأخير من F192/F209V2 يبلغ 0.062) وعتبة البوابة الإضافية N <= 0.065. وقد قاس تنفيذ آخر 0.028-0.036 على المقاطع نفسها، لذا فالعتبات غير قابلة للتبادل بين النسخ. وفي النسيج الدقيق جدًا (صفوف العشب) كانت قيمة N النظيفة 0.075، فالعتبة تُحدَّد لكل عائلة مشاهد. ومقدِّر التردد العالي المتين (sigma-HH <= 1.5؛ النظيف 0.74-1.19، والضجيج المضاف s=2 يعطي 2.2-3.0) هو البوابة الإضافية الموصى بها.

النطاق: يتناول VideoTurko تمريرة واحدة فقط (حتى 209 إطارًا، نحو 8.7 ثانية). أظهر اختبار التسلسل الخاص بنا وصلات مرئية (المشهد لا يستمر بنظافة)، لذا فالأفلام الأطول ليست مما نتحقق منه. للتسلسل يوجد دليل المجتمع `docs/KLIP_ZINCIRI.md` وأداتنا المساعدة التي تعمل على المعالج فقط `scripts/zincir.py` (`plan` و`son-kare` و`bagla`؛ لا تشغّل المحرك أبدًا)؛ لم نقس جودة الأفلام المتسلسلة [لم يُجرَّب]، لذا افحص كل وصلة بالعين وباستخدام `scripts/dikis_denetim.py`.
الإعدادات لك: 209 إطارًا هو افتراضنا المجرَّب على بطاقة 4 GB، وليس حدًا ملزمًا لك. اختر أي عدد إطارات من الشبكة 17k+5 (56، 73، ... 192، 209؛ انظر `docs/KURULUM.md`)، وغيّر الموجّه (prompt) والبذرة (seed) والدقة أو أي علم كما تشاء. المقاطع الأقصر تحتاج ذاكرة ووقتًا أقل؛ وقد تتسع بطاقات GPU الأكبر لأكثر من ذلك.

## تحذير ترخيص النموذج
**يحتوي VideoTurko على رقع وسكربتات فقط (MIT)؛ ومن يستخدم النموذج ومخرجاته فهو المسؤول بنفسه عن ترخيص MiniMax.** هذا ليس استشارة قانونية. فيما يلي ملخص لبنود MiniMax H3 Community License (2 أغسطس 2026) مع أرقامها؛ والمُلزِم هو الترخيص نفسه: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

ترخيص MIT لهذا المستودع لا يشمل أوزان النموذج؛ راجع [`NOTICE`](NOTICE). لا يحتوي هذا المستودع على أي أوزان للنموذج (لا ملفات MiniMax H3 ولا HyperFlow-H3-Flash GGUF ولا VAE). هذا المشروع غير تابع لـ MiniMax ولا تصادق عليه. الاستخدام التجاري غير محظور (فهذا ليس ترخيصًا غير تجاري)؛ والشروط أدناه.

**النطاق الجغرافي (Applicable Territory)**
- **الديباجة وI.3 وI.5:** العالم كله، باستثناء الاتحاد الأوروبي والمملكة المتحدة وجمهورية كوريا والولايات المتحدة. ويُعدّ استخدام النموذج قبولًا للترخيص.
- **II:** ترخيص محدود وغير قابل للتحويل وبلا رسوم (royalty-free) لاستخدام النموذج ونسخه وتوزيعه وإنشاء أعمال مشتقة منه وتعديله، داخل النطاق الجغرافي فقط وبما يتوافق مع الاتفاقية ومع Exhibit A. ويمكن للأشخاص في المناطق المستثناة أن يطلبوا من MiniMax ترخيصًا منفصلًا.
- **V.4:** لا يُسمح باستخدام النموذج ومشتقاته **ومخرجاته** (الفيديو/الصوت المولَّد) أو نسخها أو تعديلها أو توزيعها أو عرضها خارج النطاق الجغرافي. **وبالتالي فإن نشر الفيديوهات المولَّدة أو عرضها في الاتحاد الأوروبي/المملكة المتحدة/كوريا الجنوبية/الولايات المتحدة خارج نطاق الترخيص.**
- **Exhibit A-1:** الاستخدام خارج النطاق الجغرافي يخالف سياسة الاستخدام المقبول (Acceptable Use Policy).

**التوزيع (III)** (هذا المستودع لا يوزّع النموذج؛ وهذا إن كنت أنت من يوزّعه)
- **III.1:** أعطِ كل متلقٍّ نسخة من الترخيص. **III.2:** ضع إشعارات بارزة على الملفات المعدَّلة.
- **III.3:** مُشجَّع (وليس إلزاميًا): إشعار "Powered by MiniMax H3"، ومعرِّف توليد بالذكاء الاصطناعي على الملفات المنتَجة، ومقال علني.
- **III.4:** يجب أن ترافق التوزيعات ملف NOTICE يتضمن: "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12:** يُحظر نشر محتوى في أي بيئة عامة دون الإفصاح بوضوح عن أنه مولَّد آليًا: ضع وسمًا على فيديوهات الذكاء الاصطناعي عند نشرها (القائمة الكاملة: `docs/LISANS_UYARISI.md`).
- **III (الفقرة الأخيرة):** يجوز لك إضافة حقوق النشر الخاصة بك على تعديلاتك، لكن لا يجوز فرض شروط إضافية أو مختلفة على الاستخدام/التوزيع؛ وتبقى قواعد النطاق الجغرافي سارية.

**الشروط التجارية (IV)**
- **IV.1:** إذا كانت منتجاتك/خدماتك التجارية تحقق إيرادات سنوية تتجاوز 20 مليون دولار أمريكي (USD) (أو ما يعادلها)، فاحصل على تفويض كتابي مسبق من api@minimax.io (الموضوع: "MiniMax H3 licensing - authorization request").
- **IV.2:** يجب أن تعرض واجهة المنتج/الخدمة التجارية التي تستخدم النموذج عبارة "MiniMax H3" بشكل بارز.

**قيود الاستخدام (V)**
- **V.1:** التزم بالقوانين المعمول بها (بما فيها الامتثال التجاري) وبـ Exhibit A. **V.2:** ألزِم كل من تمنحه الوصول بشروط لا تقل حماية عن هذه القيود، وأبلغهم بها.
- **V.3:** لا يجوز استخدام النموذج أو **مخرجاته** لتحسين أي نموذج ذكاء اصطناعي آخر (عدا MiniMax H3 ومشتقاته). (I.11: التقطير (distillation) والتدريب على المخرجات الاصطناعية يجعلان النموذج "مشتقًا"؛ أما المخرجات نفسها فليست مشتقات.)
- **V.5:** إذا قدّمت لأطراف ثالثة منتجًا/خدمة/خدمة مستضافة تولّد مخرجات بالنموذج: ضمانات تقنية وتنظيمية معقولة قبل التشغيل وطوال مدته، وآلية للإبلاغ، وتحقيق عاجل، وإزالة المخالفين المتكررين أو تعطيلهم أو تعليقهم.

**العلامة التجارية والحقوق (VI)**
- **VI.1:** أنت تملك الأعمال المشتقة ومشتقات النموذج التي تنشئها (مع مراعاة حقوق MiniMax). **VI.2:** أسماء MiniMax وعلاماتها غير مرخَّصة (بما يتجاوز ما يلزم للوصف والتوزيع)؛ ولا تُستخدم علامة "MiniMax H3" إلا امتثالًا لـ III.3 وداخل النطاق الجغرافي؛ ولا توحِ بوجود انتماء.
- **VI.3:** إذا رفعت دعوى على MiniMax أو على أي طرف زاعمًا أن المواد/المخرجات تنتهك حقوقك، تنتهي جميع تراخيصك في اليوم نفسه؛ وتدافع عن MiniMax وتعوّضها عن مطالبات الأطراف الثالثة الناشئة عن استخدامك أو استخدام غيرك أو توزيعهم.
- **VI.4:** لا تدّعي MiniMax أي حقوق على المخرجات؛ وأنت ومستخدموك مسؤولون عن المخرجات واستخدامها.

**إخلاء المسؤولية والإنهاء (VII وVIII وIX)**
- **VII.1:** لا التزام بالدعم أو التحديث. **VII.2:** يُقدَّم النموذج والمخرجات "AS IS" (كما هي) دون ضمانات؛ وأنت تقرر مدى الملاءمة وتتحمل المخاطرة. **VII.3:** MiniMax وشركاتها التابعة غير مسؤولة عن أي أضرار (بالقدر الذي يسمح به القانون).
- **VIII.1:** يسري عند القبول/الوصول. **VIII.2:** عند الإخلال يجوز لـ MiniMax إنهاء الترخيص؛ ويجب عليك التوقف عن الاستخدام/التوزيع وحذف النسخ وإبلاغ المتلقين (وتبقى VI.1 وVI.3 وVII وIX سارية).
- **IX:** قانون منطقة هونغ كونغ الإدارية الخاصة؛ والاختصاص القضائي الحصري لمحاكم هونغ كونغ (مع استبعاد اتفاقية الأمم المتحدة CISG).
- **ملاحظة إضافية:** يستخدم مشفّر MiniMax H3 نموذج Qwen3-VL-32B (Apache 2.0).

**سياسة الاستخدام المقبول (Exhibit A)** (لا تستخدم النموذج أو المشتقات أو المخرجات في)
- A-1 الاستخدام خارج النطاق الجغرافي؛ A-2 مخالفة القوانين أو الملكية الفكرية للغير؛ A-3 إيذاء النفس أو الآخرين؛ A-4 إعادة توظيف المخرجات أو توزيعها للإضرار؛ A-5 التحايل على الضمانات؛ A-6 استغلال القاصرين أو إيذاؤهم؛ A-7 معلومات كاذبة يمكن إثبات زيفها بقصد الإضرار بالآخرين أو التأثير في الانتخابات؛ A-8 التفاعل المزيف على الإنترنت (مراجعات مزيفة وغيرها)؛ A-9 التشهير والتنقيص والمضايقة؛ A-10 البرمجيات الخبيثة؛ A-11 البيانات الشخصية للإضرار بالآخرين؛ **A-12 نشر محتوى في أي بيئة عامة (بما فيها منشورات الروبوتات) دون الإفصاح بوضوح وبشكل بارز عن أنه مولَّد آليًا**؛ A-13 انتحال الهوية دون موافقة؛ A-14 القرارات الآلية عالية المخاطر في المجالات الحرجة (إنفاذ القانون، والهجرة، والصحة، والبنية التحتية الحرجة، والائتمان، والتوظيف، والسكن، والتعليم، والتصنيف الاجتماعي، والتأمين، وغيرها)؛ A-15 مخالفة المعايير الاجتماعية والأخلاقية والقيم السائدة لدول/مناطق أخرى؛ A-16 التطرف العنيف/الإرهاب؛ A-17 التمييز/الإيذاء على أساس الخصائص المحمية؛ A-18 استغلال الفئات المستضعفة؛ **A-19 الأغراض العسكرية**؛ A-20 ممارسة مهنية غير مصرَّح بها/دون ترخيص (مالية، قانونية، طبية، وغيرها).
- ملاحظة: هذا ملخص مبسّط؛ وعند الشك يُعتدّ بنص الترخيص الإنجليزي.

## وسوم الأدلة

مجموعة واحدة لجميع المستندات (الصيغ الأقدم بين قوسين):
- **[مقيس]** (EN: measured؛ TR: ölçtüm, olctum): شُغّل في هذا المشروع ويوجد مسار للدليل.
- **[مقروء]** (EN: read؛ TR: okudum yol, okudum): قُرئ المصدر أو السكربت ولم يُشغَّل.
- **[تصميم]** (EN: design؛ TR: tasarım, tasarim): مصمَّم ولم يُشاهد بعد في تشغيل حقيقي.
- **[تخمين]** (EN: guess؛ TR: tahmin): غير متحقَّق منه.
- **[لم يُجرَّب]** (EN: not tried؛ TR: denenmedi): لم يُشغَّل قط.
- **[أبلغ المستخدم]** (EN: user-reported؛ TR: kullanıcı bildirdi): ذكره المستخدم مع التاريخ؛ ولم يُقَس بشكل مستقل.
- **[محسوب]** (EN: computed؛ TR: hesap؛ الصيغ الأقدم: calculated, hesap): رقم مشتق من مدخلات مقيسة وليس مقيسًا بذاته؛ ويُكتب الاشتقاق بجانبه. وفي النص الأقدم [proposal] / [öneri] = [تخمين].

أسماء التشغيلات المستخدمة بين الأقواس (أسماء تشغيلاتنا نحن، وليست ملفات في هذا المستودع): U209 = ‏209 إطارًا بالملف التنفيذي للإصدار عبر `uret.ps1`؛ وB209 وB192 = تشغيلات من صورة إلى فيديو (‎`-InitImg`‎) عند 209 و192 إطارًا؛ وB56VT2 = الملف التنفيذي للإصدار، 56 إطارًا، مقارنة بمرجع البايتات R0 ذي الـ 56 إطارًا؛ وF209b وF209V2 وF209V2K = تشغيلات 209 إطارًا على نسخة التطوير (التفاصيل: `docs/OLCUMLER.md`).

## القيود المعروفة
- **إثبات البايتات** (كيف تعيد إنتاجه بنفسك: `docs/KANITLAR.md`، "R0 ve latent referansi nasil uretilir"؛ جرى التحقق على بطاقتنا sm_61، وقد لا تكون بطاقات GPU الأخرى مطابقة بايتًا ببايت [تخمين]): مع سلسلة رقعنا (أعلام الذاكرة مفعَّلة) أعطى تشغيل 56 إطارًا قيمة sha256 تساوي `0979f156d548169b...`‎، مطابقة للمرجع [مقيس]؛ وعند 141 إطارًا كانت قيمة sha256 للمتجه الكامن `E5D028F8632BE4FE...`‎ مطابقة (مع أعلام 0013/0014). ولا يوجد مرجع بايتات مباشر للإطارات من 158 إلى 209؛ وسلسلة البوابات هي الدليل. واجتياز البوابات الرقمية لا يضمن مقطعًا جيدًا: اتساق الحركة عبر الزمن يُفحص بالعين (انظر `docs/KAPILAR.md`).
- **209 إطارًا، أي مجموعة أعلام:** أُخذ دليل سلسلة البايتات لـ 209 إطارًا بمجموعة أعلام F209V2 على نسخة التطوير (دون أعلام ذيل الكتلة، ومبنية دون الرقعتين 0019/0020)؛ ويستخدم `uret.ps1` هذه الوصفة عند 209 إطارًا [مقروء: السكربت؛ ونجح تشغيل حقيقي للمحرك عبر `uret.ps1` في تشغيل U209].
- تحققنا منها على بطاقة واحدة (GTX 1050 Ti 4 GB)؛ والتقارير الخارجية عن البطاقات الأخرى مدرجة مع وسومها في `docs/KART_PROFILLERI.md` [أبلغ المستخدم].
- **أي ملف تنفيذي قيس:** قيس المتجه الكامن لـ 141 إطارًا وسلسلة البايتات بنسخ التطوير لدينا. أما الملف التنفيذي للإصدار الذي تنزّله فهو بناء جديد: اجتازت بوابة البايتات لـ 56 إطارًا (البند التالي) واجتاز تشغيل 209 إطارًا عبر `uret.ps1` البوابة (تشغيل U209، 3414 ثانية، ذروة VRAM بلغت 3777 MiB) [مقيس]؛ وبالمقارنة مع تشغيل 209 على نسخة التطوير فإن المتجه الكامن مطابق بايتًا ببايت؛ وفي الفيديو الإطارات (md5) والصوت متطابقة، ويختلف sha256 لملف AVI بسبب الحاوية [مقيس] (انظر `docs/OLCUMLER.md`، القسم 0).
- **الملف التنفيذي للإصدار، 56 إطارًا:** أعطى الملف التنفيذي للإصدار (sd-cli ‏`c5cebe78...`‎، وstable-diffusion.dll ‏`e5d3d329...`‎) نتيجة 56 إطارًا مطابقة بايتًا ببايت لـ R0 (sha256 ‏`0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`؛ وmd5 لكل إطار والصوت متطابقان)، وشُغّل مباشرة بالأعلام الافتراضية (دون متغيرات `SD_*`)، رمز الخروج 0، و601 ثانية [مقيس: تشغيل B56VT2، 2026-11-19؛ الأدلة يحتفظ بها المؤلفون وليست في هذا المستودع]. النطاق: بطاقتنا sm_61 و56 إطارًا فقط؛ وليس اختبار تثبيت من جذر نظيف؛ وقيس المتجه الكامن لـ 141 إطارًا وسلسلة 209 بالملف التنفيذي الأقدم ولم يُعاد قياسهما بهذا الملف [لم يُجرَّب]. وانتهت المحاولة الأولى (B56VT، عبر سكربت مساعد) بصمت بعد 58 ثانية، والسبب مجهول [تخمين: ضغط على الذاكرة]؛ أما المحاولة الثانية فشغّلت `sd-cli` مباشرة.
- لم يُتحقق بعد من سكربتات التثبيت والتشغيل انطلاقًا من مجلد فارغ (اختبار الجذر النظيف لم يُجرَ بعد).
- خارطة الطريق والخطوات التالية: `ROADMAP.md`.

## الحالة والحدود
- جرى التحقق على جهاز واحد (GTX 1050 Ti بسعة 4 GB، وذاكرة RAM بسعة 16 GB، ومعالج i7-7700HQ). وقد تختلف بطاقات 4 GB الأخرى وأحجام RAM الأخرى.
- **الافتراضي 209 إطارًا (8.7 ثانية):** اجتاز بوابات الجودة لدينا (الضجيج 1.08، تشغيل F209V2K) [مقيس: 209 إطارًا بالملف التنفيذي للإصدار عبر `uret.ps1`، تشغيل U209؛ المتجه الكامن (latent) مطابق بايتًا ببايت لتشغيل نسخة التطوير؛ الإطارات والصوت متطابقة في الفيديو، ويختلف sha الملف بسبب الحاوية؛ الأدلة يحتفظ بها المؤلفون وليست في هذا المستودع]. وعند 209 إطارًا بلغت ذروة VRAM لـ DiT ‏3777 MiB من أصل 4096 MiB (تشغيلا F209b وU209؛ قراءة `nvidia-smi` للبطاقة كاملة)، وهو هامش ضيق: قد يتسبب حمل GPU آخر (الشاشة، تطبيقات أخرى) في فشل التشغيل عند `blocks.0`؛ وجُرّب على GTX 1050 Ti فقط. لم تُسجَّل حالة الشاشة أثناء ذلك التشغيل؛ وإن كانت شاشتك تعمل على هذه البطاقة فسيتوفر VRAM أقل [تخمين: حمل عرض في Windows نحو 100-300 MB]؛ وعند الحاجة صِل الشاشة بوحدة GPU مدمجة [نصيحة، لم تُجرَّب]. استغرق أخذ العينات (sampling) ‏2730 ثانية (تشغيل U209: الخطوات بين 436 و483 ثانية) وفك ترميز VAE في عملية منفصلة 173 ثانية (المرحلة 2 بمجموعها 193 ثانية مع فك ترميز الصوت) [مقيس: U209 بالملف التنفيذي للإصدار؛ وفي تشغيلات التطوير الأقدم: 2664 و174 ثانية]. وفي المرحلة 1 نفدت ذاكرة VAE داخل العملية وتراجع إلى التقسيم الزمني إلى بلاطات (temporal tiling) (320 ثانية)؛ وتُهمل تلك المخرجات، ويُؤخذ الفيديو من المرحلة 2 دون تقسيم. لم تُقَس ذروة RAM في U209. المقاطع الأطول من 209 إطارًا ليست جزءًا من هذا الإصدار.
- **توليد الفيديو من صورة (‎`-InitImg`‎):** مع صورة ابتدائية يكون الحد الأقصى 192 إطارًا (8.0 ثانية بسرعة 24 fps) على هذه الـ GPU: لم يتسع 209 إطارًا (نقص نحو 17.5 MB من VRAM عند الكتلة 0: المطلوب 2587 MB والمتاح 2570 MB)؛ وجرى تشغيل 192 إطارًا عبر `uret.ps1` في 3086 ثانية وبذروة VRAM بلغت 3783 MiB واجتازت البوابة [مقيس: تشغيلا B209 وB192، 2026-11-20، مشهد واحد؛ الأدلة يحتفظ بها المؤلفون وليست في هذا المستودع]. لم يُجرَّب على بطاقات GPU أخرى [لم يُجرَّب].
- **الـ RAM الحرة مهمة:** تحتاج إلى نحو 11 GB من RAM الحرة (تحتل عملية المحرك نحو 11 GB) [مقيس]. وعند قلة RAM الحرة قد تموت العملية دون رسالة خطأ [تخمين: لاحظنا ذلك مرة واحدة عندما كانت RAM الحرة نحو 300 MB بينما كان `sd-cli` يحتل نحو 10 GB]. لا تفتح برامج كبيرة أخرى أثناء التشغيل: ففي جهاز بسعة 16 GB لا يبقى حرًا سوى نحو 0.3-0.5 GB، وتحت ضغط الذاكرة قد تموت العملية بصمت. قبل البدء أغلق المتصفحات والألعاب والبرامج الكبيرة الأخرى وتحقق من حجم RAM الحرة.
- **اختبار الجذر النظيف لم يُجرَ بعد:** لم يُتحقق بعد من سكربتات التثبيت والتشغيل انطلاقًا من مجلد فارغ بالاعتماد على هذه التعليمات وحدها؛ وسيُحدَّث هذا القسم عند تسجيل ذلك الاختبار (بما فيه مقارنة بايتات 56 إطارًا بالمرجع).
- لا تُرفق هنا أي فيديوهات مولَّدة.

</div>

<!-- i18n-source: README.md sha256:85813d39c127 -->
