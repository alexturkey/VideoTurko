# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · עברית · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

<div dir="rtl">

התרגומים עוקבים אחר ה-README האנגלי הזה. אם תרגום שונה או מפגר, הנוסח האנגלי הוא הקובע, במיוחד בטקסט הרישיון והאבטחה ([`SECURITY.md`](SECURITY.md) ו-[`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) נשמרים באנגלית ובטורקית בלבד).

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **לפני שמתחילים (רישיון, טריטוריה):** המאגר הזה ברישיון MIT ומכיל רק תיקונים וסקריפטים. מודל MiniMax H3 שהוא מוריד כפוף ל-MiniMax H3 Community License: הטריטוריה שלו אינה כוללת את האיחוד האירופי, בריטניה, דרום קוריאה וארצות הברית, ואין להשתמש במודל, בנגזרות **ובפלטים (הסרטונים שאתם מייצרים)** שם, להפיץ או להציג אותם (V.4). שימוש מסחרי מותר במסגרת תנאי הרישיון. קראו את [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) לפני ההתקנה; זו אינה ייעוץ משפטי.

> **ב-30 שניות:** כרטיס מסך עם 4 GB יכול להפיק סרטון MiniMax H3 של 209 פריימים (8.7 שניות) במעבר אחד: אומת על מכונה אחת (GTX 1050 Ti עם 4 GB; התקנה מלאה עם `kur.ps1` בתיקייה ריקה עדיין לא אומתה מקצה לקצה) [נמדד: 209 פריימים עם הקובץ הבינארי של גרסת ההפצה (release) דרך `uret.ps1`, הרצה U209; ה-latent זהה בייט-בייט להרצת גרסת הפיתוח; הפריימים והאודיו בסרטון זהים, וה-sha של הקובץ שונה בגלל המכל (container); הראיות נשמרות אצל המחברים ואינן במאגר הזה]; עם ‎`-InitImg`‎ (מתמונה לסרטון) עד 192 פריימים (8.0 שניות) [נמדד: הרצה B192]; הפקה של 209 פריימים נמשכת כ-57 דקות, ותקרת הזמן ברירת המחדל היא 80 דקות [נמדד: הרצה U209]; 3 הצעדים שלהלן הם דרך ההרצה.

VideoTurko: טלאי זיכרון ל-stable-diffusion.cpp ומתכוני הרצה להפקת וידאו מטקסט עם MiniMax H3 על GTX 1050 Ti עם 4 GB, עד 209 פריימים (8.7 שניות) במעבר אחד; מתמונה לסרטון (‎`-InitImg`‎) עד 192 פריימים (8.0 שניות) (209 פריימים אומתו בשרשרת בייטים; זהה בייט-בייט להרצה ללא טלאים בבדיקות של 56 ו-141 פריימים).

## התחלה מהירה (Windows, 3 צעדים)
**סטטוס: סקריפטי ההתקנה וההרצה שלהלן בשלבי סיום ובדיקת השורש הנקי (clean-root) טרם בוצעה; שום דבר כאן לא מוצג כעובד עד שהבדיקה הזו תעבור (ראו "סטטוס ומגבלות").**

1. **הורידו** את המאגר הזה (הכפתור הירוק **Code** ואז **Download ZIP**) וחלצו אותו לתיקייה עם נתיב קצר, למשל `C:\vt`.
2. **התקנה: לחצו פעמיים על ‎`kur.cmd`‎** (נפתח חלון שחור שמציג כל שלב; סגירתו עוצרת את ההתקנה, והרצה חוזרת ממשיכה מהמקום שבו עצרה: קובץ מודל שהורד חלקית ממשיך [נקרא: סקריפט ההורדה שומר קובץ ‎`.part`‎ וממשיך ממנו; המשך מלא של 29 GiB לא נמדד]). אם Windows מזהיר על הקובץ שהורד, השתמשו במקום זאת בפקודת PowerShell שלהלן [עצה, לא נבדק על ZIP שהורד]. מעדיפים שורת פקודה? פתחו PowerShell בתיקייה הזו (הקלידו ‎`powershell`‎ בשורת הכתובת של סייר הקבצים) והריצו את אותה התקנה:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   שורש ההתקנה הוא התיקייה שחילצתם (המנוע נכנס ל-`engine\bin` והמודלים ל-`model`); כדי להשתמש במקום אחר הגדירו קודם את משתנה הסביבה `VT_ROOT`. הסקריפט בודק GPU, דרייבר, RAM ודיסק, מוריד את המנוע ואת המודלים (קבצי ה-zip של המנוע וקבצי מודל שהורדו זה עתה נבדקים ב-sha256; קובץ מודל שכבר קיים בגודל הנכון נבדק רק לפי גודל, ובדיקת sha256 מלאה מתבצעת עם `scripts\modelleri_indir.ps1 -Dogrula`), מריץ בדיקה אמיתית קצרה ומדפיס READY רק אם הבדיקה עברה [תכנון: `kur.ps1` טרם הורץ במלואו בתיקייה נקייה; המשפט הזה יעודכן אחרי בדיקת התיקייה הנקייה]. הדגל ‎`-ExecutionPolicy Bypass`‎ חל על התהליך הזה בלבד; כמו בכל מתקין, קראו קודם את `scripts\kur.ps1`.
   קובץ ה-zip של המנוע מגיע מגרסת ההפצה (release) v0.1.0 ב-GitHub (פורסמה ב-2026-11-19; ה-sha256 שלו קבוע בתוך `kur.ps1`). בלי חיבור לאינטרנט או עם בנייה משלכם, ספקו קובצי zip מקומיים: ‎`-MotorZip <path> -CudaZip <path>`‎. גם zip מקומי נבדק מול אותו sha256 קבוע (קובץ `.sha256` שלידו אינו נלקח בחשבון), ולכן הוא חייב להיות ה-zip של ההפצה; לבנייה משלכם הגדירו קודם את ‎`VT_MOTOR_SHA256`‎ / ‎`VT_CUDA_SHA256`‎ ל-sha256 שלה. sha256 שגוי עוצר עם exit 1. רק `.exe`/`.dll` נכנסים ל-`engine\bin`; הרישיונות וה-README נכנסים ל-`engine\lisanslar\<zip name>\`‎. [נוסה עם קובצי dist zip לפני ההפצה: קובץ `.sha256` צמוד יחד עם אזהרת ההפניה העצמית, הקובץ הבינארי וקובצי ה-DLL הונחו במקומם, `sd-cli --help` רץ; ערכי ה-sha של הבינאריים שהותקנו תאמו (`c5cebe78...`‎, `e5d3d329...`‎); שלב המודלים ובדיקת 5 הפריימים של `kur.ps1` עדיין לא הורצו על GPU אמיתי]
   **רישיון המודל:** לפני שלב המודלים המתקין מדפיס את תקציר הרישיון (`docs/LISANS_KABUL.txt`, הנוסח המלא `docs/LISANS_UYARISI.md`: MiniMax H3 Community License, מגבלות טריטוריה שחלות גם על סרטונים שנוצרו, וכללי שימוש מסחרי ותיוג בינה מלאכותית) ומבקש שתאשרו (`E` = כן). קראו אותו קודם. להרצה ללא השגחה אפשר להעביר ‎`-LisansKabul E`‎, שמשמעו שקראתם את הרישיון וקיבלתם אותו בעצמכם; אל תוסיפו אותו בשביל מישהו אחר. (סוכני בינה מלאכותית: פעלו לפי `AGENTS.md`; לעולם אל תקלידו E בלי הסכמת המשתמש.) בלי אישור `kur.ps1` נעצר עם קוד יציאה 2 ואינו מוריד שום מודל.
3. **הסרטון הראשון שלכם (56 פריימים, כ-11 דקות על ה-GTX 1050 Ti שלנו** [נמדד: 641 שניות, הרצה R0, ‎`docs/OLCUMLER.md`‎; כרטיסים אחרים לא נמדדו]**)**: כשההתקנה מדפיסה ‎`HAZIR / READY`‎, הריצו
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (קיצור דרך: גררו קובץ טקסט של פרומפט על ‎`uret.cmd`‎, או הריצו ‎`uret.cmd docs\ornek_istem_R0.txt`‎: אותה הרצה של 56 פריימים). הסרטון נמצא ב-‎`runs\`‎. אחר כך כתבו פרומפט משלכם בקובץ טקסט (פסקה אחת באנגלית, משפט ‎`audio:`‎ אופציונלי) והריצו את הקליפ הארוך ביותר שאנו מכסים (ברירת מחדל, כ-57 דקות [נמדד: הרצה U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   הערך ‎`-Kare`‎ עוקב אחרי הרשת 17k+5 (56, 73, ... 192, 209); ברירת המחדל 209 (8.7 שניות), האורך הארוך ביותר שאנו מכסים. ה-VAE רץ בתהליך נפרד ולעולם אינו מחולק לאריחים (tiling) [הרצת מנוע אמיתית דרך `uret.ps1` עם הבינארי של ההפצה, עם VAE בתהליך נפרד, עברה בהרצה U209].

   מדריך לכתיבת פרומפט: [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (תבנית של צילום רציף אחד, פרקי זמן שווים, שתי דוגמאות מלאות).

| דרישה | ערך |
|---|---|
| מערכת הפעלה | Windows 10/11, 64 סיביות |
| GPU | NVIDIA עם 4 GB או יותר; נבדק רק על GTX 1050 Ti (sm_61); מרווח צר (3777/4096 MiB ב-209 פריימים): מסך עמוס או דפדפן פתוח עלולים לשבור את ההרצה; לא נוסה אף כרטיס 4 GB אחר |
| RAM | 16 GB (שיא של כ-11 GB; סגרו תוכניות אחרות) |
| דיסק | לפחות 32 GiB פנויים (מומלץ 40 GiB ומעלה: בין 32 ל-40 ההתקנה מדפיסה אזהרה, ‎`[VT-W-DISK-PAY]`‎ [נמדד: הרצות ‎`-Kuru`‎ עם דיסק מדומה]), מודלים על SSD (עדיף NVMe) |
| הורדה | zip של המנוע 36.8 MB + zip של סביבת ההרצה CUDA בגודל 567.5 MB [נמדד] + מודלים 31,473,112,040 בייטים (כ-29.3 GiB) [נקרא: הגדלים ב-`scripts/modeller.json`]; בסך הכול כ-30 GiB |
| מודלים | לא כלולים; המתקין מוריד אותם לפי רישיון MiniMax (ראו את האזהרה להלן). המודלים (29.3 GiB, 31,473,112,040 בייטים ב-`scripts/modeller.json`) אינם במאגר הזה או בהפצה: חלות מגבלות הגודל של קבצים/הפצות ב-GitHub, ו-`kur.ps1` מוריד אותם מהמקור הרשמי עם אימות sha256. |

קודי היציאה של `kur.ps1`: 0 READY, 1 שגיאה, 2 נדרש קלט מהמשתמש (רישיון, או שעדיין אין הפצה/zip), 3 חומרה או דיסק לא מספיקים, 4 נעצר (קובץ DUR). `uret.ps1` מקבל הרצה רק אם קובץ `.avi` קיים, מספר הפריימים נכון והלוגים נקיים [נמדד: הרצה אמיתית אחת דרך `uret.ps1` על הבינארי של ההפצה, הרצה U209, 209 פריימים, השער (gate) עבר]. קודי היציאה של `uret.ps1`: 0 DONE (שער האיכות עבר), 1 שגיאה או פלט לא תקין (כולל סרטון בלי זרם אודיו), 2 נעצר (קובץ DUR), 5 `KAPI RED` (שער האיכות נכשל: הקליפ אינו מתקבל, וההחלטה שלכם), 6 השער לא הצליח לרוץ (הקליפ אינו מתקבל). פרטים ב-AGENTS.md. [נמדד: קודי יציאה 0, 1 (סרטון אילם), 5 ו-6 בתרחישים עם מנוע מזויף ושער מזויף; מנוע אמיתי: exit 0 בהרצה U209]

### פתרון תקלות (פרטים: `docs/SIK_HATALAR.md`)
שורות השגיאה של הסקריפטים שלנו נושאות קוד יציב, למשל ‎`HATA: [VT-E-DLL] ...`‎ או ‎`UYARI: [VT-W-DISK-PAY] ...`‎. חפשו את הקוד ב-[`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) (דוגמת עוגן ‎`#vt-e-dll`‎) או ב-‎`docs/hata_imzalari.json`‎, וכתבו את הקוד ב-issue שלכם. העמודה הראשונה בטבלה שלהלן נשארת כפי שהודפסה (אין לתרגם קודים וטקסט יומן).

| מה רואים | מה זה אומר ומה לעשות |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | אל תפעילו את `sd-cli.exe` ידנית; הריצו את `scripts\kur.ps1`, שמניח את קובצי ה-DLL של CUDA במקומם. |
| `failed during weight preparation` ב-`blocks.0` (#1, #3, #5) | אין מספיק VRAM בשער הזיכרון: בחרו מספר פריימים קטן יותר מהרשת 17k+5, סגרו תוכניות אחרות שמשתמשות ב-GPU ושמרו על הדגלים (flags) שסופקו. |
| `retrying with temporal tiling` (#6) | ה-VAE חזר לחלוקה לאריחים; הפלט אינו תקף לצורכי איכות. הריצו שוב. |
| ההרצה נגמרת בתקרת הזמן, אין סרטון (#7) | הגדילו את ‎`-TavanDk`‎ לקליפים ארוכים (תקרת הזמן ברירת המחדל: 80 דקות ל-209 פריימים, נקבעת על ידי `uret.ps1`; ההרצה שלנו של 209 פריימים נמשכה 57 דקות [נמדד: הרצה U209]). |
| קוד היציאה ריק אבל כתוב "finished" (#14) | העטיפה (wrapper) קראה את קוד היציאה מוקדם מדי; הריצו שוב ובדקו שקובץ הסרטון קיים. |
| המערכת מאטה, מתבצע swapping (#18) | המנוע משתמש בכ-10-11 GB של RAM; סגרו דפדפנים ותוכניות אחרות. |
| אי-התאמת sha256 / ההורדה נכשלה | בדרך כלל ההורדה נקטעה: הריצו שוב את אותה פקודה, קבצים שאומתו מדולגים. |

**נתקעתם או סקרנים?** [`SUPPORT.md`](SUPPORT.md) (איפה שואלים; זמני המענה הם יעדים, לא התחייבויות) · [`PRIVACY.md`](PRIVACY.md) (ללא טלמטריה; הרשת משמשת רק להורדת המנוע והמודלים מהמארחים הרשומים) · [`SECURITY.md`](SECURITY.md) (דיווח פרטי) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (pull request ראשון ב-5 שלבים; למסמכים ולסקריפטים אין צורך ב-GPU).

### חדש ב-v0.1.1: אפשרויות נוספות (פרטים: `AGENTS.md`, `docs/SIK_HATALAR.md` 19-23)
בלי האפשרויות האלה שום דבר לא משתנה בכרטיס עם 4 GB (בדיקת הבייטים של 56 פריימים מול הייחוס שלנו עברה שוב עם v0.1.1 [נמדד]). הוסיפו ‎`-Kuru`‎ לכל פקודה כדי לראות מה ירוץ.
- הדגל ‎`-EndImg`‎: ספקו גם את הפריים האחרון (פריים ראשון ואחרון, "FLF"); התקרה היא 175 פריימים בכרטיסים עם פחות מ-8 GB (192 פריימים לא נכנסו ב-4 GB), ו-192 בכרטיסים עם 8 GB ומעלה. ב-GTX 1050 Ti שלנו הוא רץ תמיד בשני תהליכים: 56 פריימים ב-1040 שניות, 175 פריימים ב-2887 שניות (48 דקות), ושניהם עברו את השער [נמדד]. טיפים לכתיבת הפרומפט (prompt): `docs/ISTEM_YAZIMI.md`.
- הדגלים ‎`-W`‎ / ‎`-H`‎: גדלים אחרים, למשל אנכי 384x640; כפולות של 32, ושטח של 640x384 לפחות (אף פעם לא קטן יותר). לא נוסה על 4 GB; בכרטיסים עם פחות מ-8 GB נדחים גדלים שחורגים מהעבודה הגדולה ביותר שמדדנו. ספי שער האיכות מכוילים לפי 640x384.
- הדגל ‎`-TekAsama`‎: תהליך אחד במקום שניים, לכרטיסים גדולים בלבד; לעולם אינו מופעל אוטומטית.
- כרטיסי GPU חדשים יותר (compute capability 7.0 ומעלה, למשל RTX 20/30/40): `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` מוגדר אוטומטית אלא אם הגדרתם אותו בעצמכם; זה תיקן סרטון שחור לגמרי ב-141 פריימים ומעלה ב-RTX 4070 Ti של המדווח [דווח על ידי המשתמש, issue #1]. בלי Python + OpenCV, `uret.ps1` עוצר עכשיו עם exit 6 לפני משימת ה-GPU (לא נוצר סרטון, ואין RED מטעה).
- תודה ל-@SinanC73 על הדיווח מ-RTX 4070 Ti שהוביל לשינויים האלה ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1)).

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

## פרופילי מהירות אופציונליים (חבילת מהירות; כבויה כברירת מחדל)
דבר מהאמור להלן אינו משנה את ההרצה ברירת המחדל (640x384, 209 פריימים, 3414 שניות בכרטיס שלנו). אלה שלושה תאים שנמדדו מעבר לה, כל אחד פרופיל בעל שם של ‎`uret.ps1`‎; הם דורשים את מנוע חבילת המהירות (מנוע הגרסה בתוספת התיקונים 0021, 0023, 0024, כולם כבויים כברירת מחדל: ‎`docs/YAMALAR.md`‎). התקינו אותו עם ‎`scripts\kur.ps1 -HizPaketi`‎ (קובץ zip מקומי עובד עם ‎`-MotorZip`‎), ואז הוסיפו ‎`-Profil <name>`‎; ‎`-Kuru`‎ מדפיס מה היה רץ. חבילת המהירות תפורסם עם גרסה v0.1.4.

| פרופיל | גודל, אורך | זמן כולל על GTX 1050 Ti 4 GB | מצב |
|---|---|---|---|
| (אין, ברירת מחדל) | 640x384, עד 209 פריימים (8.7 שניות) | 209 פריימים: 3414 שניות | מאומת, ללא שינוי |
| ‎`yuksek832`‎ | 832x480, 141 פריימים (5.9 שניות) | בערך 55-56 דקות | שמיש, שני פרומפטים [נמדד] |
| ‎`yuksek832 -Kare 124`‎ | 832x480, 124 פריימים (5.2 שניות) | בערך 45-46 דקות, בלי דגל מהירות | שמיש, שני פרומפטים [נמדד] |
| ‎`yuksek896`‎ | 896x512, 124 פריימים (5.2 שניות) | בערך 56-57.5 דקות | שמיש, שני פרומפטים [נמדד] |
| ‎`uzun260`‎ | 640x384, 260 פריימים (10.8 שניות) | 78 דקות נמדדו בלי היציאה המוקדמת; איתה בערך 71-72 דקות [השערה: לא נמדד מקצה לקצה דרך ‎`uret.ps1`‎] | מותנה וניסיוני |

- **מרווח צר:** ב-832x480 x 141 שער הזיכרון משאיר מרווח חד-ספרתי ב-MB (5.7 ו-6.8 MB בשתי ההרצות המלאות). שני פרומפטים ארוכים (1520 ו-2041 תווים) נבדקו רק בקריאת השער לשלב 1 ולחלק משלב 2, בלי הרצה מלאה: מרווח של 10.9 ו-4.0 MB. כל תהליך אחר שמחזיק זיכרון של הכרטיס (דפדפן, מסך שני) עלול לגרום לכישלון; אז השתמשו ב-‎`-Kare 124`‎ או בגודל ברירת המחדל [נמדד, GTX 1050 Ti 4 GB].
- **‎`uzun260`‎ מותנה:** מגבלת הזיכרון צרה מאוד (שיא VRAM 3903 מתוך 4096 MiB), השימוש בזיכרון משותף גדל ב-45 וב-61 MiB (גבול 68), ואין הפניה בלי דגלים לשוויון בייט-בייט, ולכן הוא אינו מוצע כתכונה רגילה. תיקון 0023 מתקבל רק לתא האחד הזה.
- **לא מוצע:** 832x480 ב-158 פריימים לא נכנס עם הטלאים שנשלחו (בשער של שלב 2 חסרים כ-280 MB); 175 פריימים נבדק רק בקריאת השער (בבלוק הראשון חסרו כ-275 MB, בלי הרצה מלאה). הפרופיל מציע רק 141 פריימים. גדלים ומספרי פריימים אחרים נדחים על ידי ‎`-Profil`‎ (השתמשו בנתיב ברירת המחדל).
- איכות ברירת המחדל לא נגעה: 6 שלבים, cfg 1, VAE בלי אריחים, 17k+5 פריימים. היכן שהדגלים פעילים, הפלט הושווה בייט אחר בייט לסרטון בלי דגלים בגדלים שבהם ההרצה בלי דגלים נכנסת (‎`docs/YAMALAR.md`‎); ב-832x480 x 141 וב-896x512 x 124 ההרצה בלי דגלים לא נכנסת, ולכן השוויון שם נשען על התאים הקרובים ביותר ולא על השוואה ישירה [נמדד, נקרא].
- שלב 1 של הרצה דו-שלבית מסתיים עכשיו ברגע שקובץ ה-latent שלם (‎`VT_ERKEN_CIKIS=0`‎ מכבה זאת).

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

## מה זה
סדרת טלאים קטנים לזיכרון ולתזמון עבור stable-diffusion.cpp, יחד עם מתכון ההרצה, הבדיקות והמדידות, שמאפשרים להריץ את MiniMax H3 (DiT בגודל 33B; אנו מריצים את HyperFlow Flash 13.7B בקובץ GGUF מסוג Q4_K_M; מקודד הטקסט Qwen3-VL בגודל 32B נפרד) על GPU מדור Pascal עם 4 GB (GTX 1050 Ti, עם 16 GB של RAM במערכת).
- אורכי מעבר יחיד שהפקנו בפועל ושעברו את שערי האיכות שלנו: 56, 141, 158, 175, 192, 209 פריימים ברזולוציה 640x384 ו-24 fps (209 פריימים = 8.7 שניות), עם האודיו ש-H3 עצמו מייצר [נמדד: 209 פריימים עם הקובץ הבינארי של גרסת ההפצה (release) דרך `uret.ps1`, הרצה U209; ה-latent זהה בייט-בייט להרצת גרסת הפיתוח; הפריימים והאודיו בסרטון זהים, וה-sha של הקובץ שונה בגלל המכל (container); הראיות נשמרות אצל המחברים ואינן במאגר הזה]. 209 הוא האורך הארוך ביותר שצפינו בו ומצאנו חלק [דווח על ידי המשתמש, 2026-11-19, הסרטון נצפה במלואו; קובץ: פלט F209V2, 8.708 שניות].
- **טענת זהות בייטים, בהיקף כנה:** הפלטים נבדקו כזהים בייט-בייט למקור ההשוואה ללא טלאים רק עבור 56 ו-141 פריימים. עבור 158/175/192/209 פריימים השתמשנו באותם דגלים ובאותה שרשרת בינאריים; אין מקור השוואה ישיר ברמת בייטים (הגרסה ללא טלאים אינה יכולה להריץ את האורכים האלה על ה-GPU הזה).
- הגדרות האיכות לעולם אינן מורדות: אותו מודל/קוונטיזציה, 6 צעדים, cfg 1, 640x384, אותו seed, VAE ללא אריחים.
- איננו טוענים שאנחנו הראשונים: חיפשנו ולא מצאנו דוגמה חיצונית לכך על 4 GB, וזו אינה הוכחה שאין כזו.

## מבנה התיקיות
- `patches/` טלאים מול commit נעוץ (pinned) של stable-diffusion.cpp (ראו את ההערות שם)
- `scripts/` בנייה, הרצה, VAE בתהליך נפרד ועזרי שער/עקביות (`doku_norm.py`: ראו את הערת הסקאלה להלן)
- `docs/KURULUM.md` חומרה, צעדי בנייה והרצה (EN+TR)
- `docs/YAMALAR.md` רשימת הטלאים, `docs/KANITLAR.md` ראיות, `docs/KAPILAR.md` טבלת שערי האיכות, `docs/OLCUMLER.md` מדידות, `docs/SIK_HATALAR.md` טעויות נפוצות, `docs/LISANS_UYARISI.md` כל סעיפי הרישיון
- אינדקס קצר של `scripts/`: `hiz_kos3.ps1` עטיפת הרצה (‎`-Kuru`‎ מדפיס את הפקודה המדויקת), `uretim_kapi.ps1` שער האיכות, `dikis_denetim.py` בדיקת תפרים, `doku_norm.py` רעש מנורמל לפי מרקם, `bayt_kiyas.py` השוואת בייטים, `derleme_sablonu.ps1` תבנית בנייה (עוצר רק את תהליך העזר של הטלמטריה של Visual Studio, `vctip.exe`, שהתחיל אחרי שהבנייה עצמה התחילה ושאחרת מחזיק את תהליך הבנייה מחובר במשך דקות; תהליכי `vctip.exe` אחרים נשארים)

## שערי איכות (איך מקבלים תוצאה)

השער הזה אינו בודק עקביות תנועה (קפיצות בגודל או במיקום של עצמים): צפו בסרטון כולו לפני שאתם מקבלים אותו.
1. מספר פריימים ונוכחות אודיו; בלי שורות fallback של זיכרון או ALLOC_FAILED בלוג.
2. שער רעש גולמי: שארית מסנן חציוני קטן או שווה ל-1.5 (סקאלה 0-255).
3. רעש מנורמל לפי מרקם, `scripts/doku_norm.py` (הגרסה של המאגר הזה): N = שארית חציונית / מרקם Sobel, כל 6 פריימים. **הערת סקאלה:** בגרסה הזו 10 הקליפים שנמדדו נותנים N = 0.034-0.052 (הטבלה ב-`docs/KAPILAR.md`; הרבע האחרון של F192/F209V2 מגיע ל-0.062) וסף השער הנוסף הוא N קטן או שווה ל-0.065. מימוש אחר מדד 0.028-0.036 על אותם קליפים, ולכן הספים אינם ניתנים להחלפה בין גרסאות. על מרקמים עדינים מאוד (שורות דשא) ה-N הנקי היה 0.075, כך שהסף נקבע לפי משפחת סצנות. אומד עמיד לתדרים גבוהים (sigma-HH קטן או שווה ל-1.5; נקי 0.74-1.19, רעש מוסף s=2 נותן 2.2-3.0) הוא השער הנוסף המומלץ.

היקף: VideoTurko עוסק במעבר יחיד אחד (עד 209 פריימים, כ-8.7 שניות). בבדיקת השרשור שלנו עצמנו נראו תפרים גלויים (הסצנה לא ממשיכה נקי), ולכן סרטים ארוכים יותר אינם חלק ממה שאנחנו מאמתים. לשרשור יש את מדריך הקהילה `docs/KLIP_ZINCIRI.md` ואת כלי העזר שלנו שעובד על המעבד בלבד `scripts/zincir.py` (`plan`, `son-kare`, `bagla`; הוא אינו מפעיל את המנוע לעולם); את איכות הסרטים המשורשרים לא מדדנו [לא נוסה], ולכן בדקו כל תפר בעין וב-`scripts/dikis_denetim.py`.
ההגדרות שלכם: 209 פריימים הוא ברירת המחדל שנבדקה אצלנו על כרטיס 4 GB, לא מגבלה שאתם חייבים לעמוד בה. בחרו כל מספר פריימים מהרשת 17k+5 (56, 73, ... 192, 209; ראו `docs/KURULUM.md`), ושנו את הפרומפט (prompt), ה-seed, הרזולוציה או כל דגל כרצונכם. קליפים קצרים יותר דורשים פחות זיכרון וזמן; ייתכן ש-GPU גדולים יותר יכילו יותר.

## אזהרת רישיון המודל
**VideoTurko מכיל רק טלאים וסקריפטים (MIT); מי שמשתמש במודל ובפלטים שלו אחראי בעצמו לרישיון של MiniMax.** זה אינו ייעוץ משפטי. להלן סיכום סעיפי MiniMax H3 Community License (2 באוגוסט 2026) עם מספריהם; הרישיון עצמו הוא המחייב: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

רישיון ה-MIT של המאגר הזה אינו מכסה את משקלי המודל; ראו [`NOTICE`](NOTICE). המאגר הזה אינו מכיל משקולות מודל (אין קובצי MiniMax H3, HyperFlow-H3-Flash GGUF או VAE). הפרויקט הזה אינו קשור ל-MiniMax ואינו מאושר על ידה. שימוש מסחרי אינו אסור (זה אינו רישיון לא-מסחרי); התנאים להלן.

**טריטוריה (Applicable Territory)**
- **Preamble, I.3, I.5:** כל העולם, פרט לאיחוד האירופי, לממלכה המאוחדת, לרפובליקה של קוריאה ולארצות הברית. שימוש במודל נחשב לקבלת הרישיון.
- **II:** רישיון מוגבל, בלתי ניתן להעברה וללא תמלוגים (royalty-free) לשימוש, שכפול, הפצה, יצירת עבודות נגזרות ושינוי, בתוך הטריטוריה בלבד ובהתאם להסכם ול-Exhibit A. אנשים בטריטוריות שאינן כלולות יכולים לבקש מ-MiniMax רישיון נפרד.
- **V.4:** שימוש, שכפול, שינוי, הפצה או הצגה של המודל, של נגזרותיו ושל **הפלטים שלו** (וידאו/אודיו שנוצרו) מחוץ לטריטוריה אינם מורשים. **לכן פרסום או הצגה באיחוד האירופי/בבריטניה/בדרום קוריאה/בארצות הברית של סרטונים שנוצרו (בכל מקום שבו נוצרו) הם מחוץ לרישיון.**
- **Exhibit A-1:** שימוש מחוץ לטריטוריה מפר את מדיניות השימוש המקובל (Acceptable Use Policy).

**הפצה (III)** (המאגר הזה אינו מפיץ את המודל; אם אתם מפיצים)
- **III.1:** תנו לכל מקבל עותק של הרישיון. **III.2:** סמנו קבצים ששונו בהודעות בולטות.
- **III.3:** מומלץ (לא חובה): הודעת "Powered by MiniMax H3", מזהה יצירה בבינה מלאכותית על הקבצים שהופקו, ופרסום פומבי.
- **III.4:** ההפצות חייבות להיות מלוות בקובץ NOTICE שכולל: "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12:** אסור לפרסם תוכן בכל סביבה ציבורית בלי לגלות בבירור שהוא נוצר בידי מכונה: תייגו סרטוני בינה מלאכותית כשאתם מפרסמים אותם (הרשימה המלאה: `docs/LISANS_UYARISI.md`).
- **III (הפסקה האחרונה):** מותר להוסיף זכויות יוצרים משלכם על השינויים שלכם, אך אסור להטיל תנאים נוספים או שונים על שימוש/הפצה; כללי הטריטוריה ממשיכים לחול.

**תנאים מסחריים (IV)**
- **IV.1:** אם המוצרים/השירותים המסחריים שלכם מניבים הכנסה שנתית של יותר מ-20 מיליון דולר אמריקאי (USD) (או שווה ערך), השיגו מראש אישור בכתב מ-api@minimax.io (נושא: "MiniMax H3 licensing - authorization request").
- **IV.2:** בממשק המשתמש של מוצר/שירות מסחרי שמשתמש במודל חייב להופיע "MiniMax H3" באופן בולט.

**הגבלות שימוש (V)**
- **V.1:** פעלו לפי החוק החל (כולל ציות סחר) ו-Exhibit A. **V.2:** חייבו כל מי שאתם נותנים לו גישה בתנאים שמגנים לפחות כמו ההגבלות האלה, והודיעו לו עליהם.
- **V.3:** אסור להשתמש במודל או **בפלטים שלו** כדי לשפר מודל בינה מלאכותית אחר (מלבד MiniMax H3 ונגזרותיו). (I.11: זיקוק (distillation) ואימון על פלטים סינתטיים הופכים מודל ל"נגזרת"; הפלטים עצמם אינם נגזרות.)
- **V.5:** אם אתם מציעים לצדדים שלישיים מוצר/שירות/שירות מתארח שמייצר פלטים באמצעות המודל: אמצעי הגנה טכניים וארגוניים סבירים לפני ההפעלה ובמשכה, מנגנון דיווח, בדיקה מהירה, והסרה/השבתה/השעיה של מפרים חוזרים.

**סימן מסחרי וזכויות (VI)**
- **VI.1:** העבודות הנגזרות ונגזרות המודל שאתם יוצרים שייכות לכם (בכפוף לזכויות MiniMax). **VI.2:** שמות/סימנים של MiniMax אינם מורשים (מעבר למה שנדרש לתיאור ולהפצה); אפשר להשתמש בסימן "MiniMax H3" רק כדי לעמוד ב-III.3 ובתוך הטריטוריה; אל תרמזו על קשר.
- **VI.3:** אם תתבעו את MiniMax או כל אחד אחר בטענה שהחומרים/הפלטים מפרים את זכויותיכם, כל הרישיונות שלכם מסתיימים באותו יום; אתם מגינים על MiniMax ומשפים אותה בגין תביעות של צדדים שלישיים הנובעות מהשימוש/ההפצה שלכם או של אחרים.
- **VI.4:** MiniMax אינה טוענת לזכויות כלשהן בפלטים; אתם והמשתמשים שלכם אחראים לפלטים ולשימוש בהם.

**הסרת אחריות וסיום (VII, VIII, IX)**
- **VII.1:** אין חובת תמיכה/עדכון. **VII.2:** המודל והפלטים מסופקים "AS IS" (כמות שהם), ללא אחריות; אתם קובעים את התאמתם ונושאים בסיכון. **VII.3:** MiniMax והחברות המסונפות אליה אינן אחראיות לנזקים כלשהם (במידה שהחוק מתיר).
- **VIII.1:** תקף עם הקבלה/הגישה. **VIII.2:** בעת הפרה MiniMax רשאית לסיים את הרישיון; עליכם להפסיק את השימוש/ההפצה, למחוק עותקים ולהודיע למקבלים (VI.1, VI.3, VII, IX ממשיכים לחול).
- **IX:** דין אזור המנהל המיוחד הונג קונג; סמכות שיפוט ייחודית לבתי המשפט של הונג קונג (אמנת CISG של האו"ם אינה חלה).
- **הערה נוספת:** המקודד של MiniMax H3 משתמש ב-Qwen3-VL-32B (Apache 2.0).

**מדיניות שימוש מקובל (Exhibit A)** (אין להשתמש במודל, בנגזרות או בפלטים עבור)
- A-1 שימוש מחוץ לטריטוריה; A-2 הפרת חוקים או קניין רוחני של צד שלישי; A-3 פגיעה בעצמכם או באחרים; A-4 ייעוד מחדש של פלטים או הפצתם כדי לפגוע; A-5 עקיפת אמצעי הגנה; A-6 ניצול או פגיעה בקטינים; A-7 מידע שניתן להוכיח כי הוא שקרי כדי לפגוע באחרים או להשפיע על בחירות; A-8 מעורבות מקוונת מזויפת (ביקורות מזויפות ועוד); A-9 לשון הרע, השמצה, הטרדה; A-10 תוכנה זדונית; A-11 מידע אישי כדי לפגוע באחרים; **A-12 פרסום תוכן בכל סביבה ציבורית (כולל פוסטים של בוטים) בלי לגלות בבירור ובאופן בולט שהוא נוצר בידי מכונה**; A-13 התחזות ללא הסכמה; A-14 החלטות אוטומטיות בסיכון גבוה בתחומים קריטיים (אכיפת חוק, הגירה, בריאות, תשתיות קריטיות, אשראי, תעסוקה, דיור, חינוך, דירוג חברתי, ביטוח ועוד); A-15 הפרת נורמות חברתיות, אתיות ומוסריות של מדינות/אזורים אחרים; A-16 קיצוניות אלימה/טרור; A-17 אפליה/פגיעה על בסיס מאפיינים מוגנים; A-18 ניצול אוכלוסיות פגיעות; **A-19 מטרות צבאיות**; A-20 פעילות מקצועית ללא הרשאה/ללא רישיון (פיננסית, משפטית, רפואית ועוד).
- הערה: זהו סיכום בשפה פשוטה; במקרה של ספק גובר נוסח הרישיון באנגלית.

## תוויות ראיות

מערכת אחת לכל המסמכים (איותים ישנים יותר בסוגריים):
- **[נמדד]** (EN: measured; TR: ölçtüm, olctum): הורץ בפרויקט הזה, ונתיב הראיה קיים.
- **[נקרא]** (EN: read; TR: okudum yol, okudum): המקור או הסקריפט נקראו, לא הורצו.
- **[תכנון]** (EN: design; TR: tasarım, tasarim): תוכנן ועדיין לא נראה בהרצה אמיתית.
- **[השערה]** (EN: guess; TR: tahmin): לא אומת.
- **[לא נוסה]** (EN: not tried; TR: denenmedi): מעולם לא הורץ.
- **[דווח על ידי המשתמש]** (EN: user-reported; TR: kullanıcı bildirdi): נמסר על ידי המשתמש, עם תאריך; לא נמדד באופן בלתי תלוי.
- **[חישוב]** (EN: computed; TR: hesap; איותים ישנים יותר: calculated, hesap): מספר שנגזר מקלטים שנמדדו ואינו נמדד בעצמו; הגזירה כתובה לידו. [proposal] / [öneri] בטקסט ישן יותר = [השערה].

שמות הרצות שמופיעים בסוגריים (אלה שמות ההרצות שלנו, לא קבצים במאגר הזה): U209 = 209 פריימים עם הבינארי של ההפצה דרך `uret.ps1`; B209 ו-B192 = הרצות מתמונה לסרטון (‎`-InitImg`‎) ב-209 וב-192 פריימים; B56VT2 = הבינארי של ההפצה, 56 פריימים, בהשוואה למקור הבייטים R0 של 56 פריימים; F209b, F209V2, F209V2K = הרצות של 209 פריימים על גרסת הפיתוח (פרטים: `docs/OLCUMLER.md`).

## מגבלות ידועות
- **הוכחת בייטים** (איך לשחזר אותה בעצמכם: `docs/KANITLAR.md`, "R0 ve latent referansi nasil uretilir"; אומת על כרטיס ה-sm_61 שלנו, ייתכן ש-GPU אחרים לא יהיו זהים בייט-בייט [השערה]): עם סדרת הטלאים שלנו (דגלי הזיכרון פעילים) הרצה של 56 פריימים נתנה sha256 `0979f156d548169b...`‎, זהה למקור ההשוואה [נמדד]; ב-141 פריימים ה-sha256 של ה-latent `E5D028F8632BE4FE...`‎ היה זהה (עם הדגלים 0013/0014). לפריימים 158 עד 209 אין מקור השוואה ישיר ברמת בייטים; שרשרת השערים היא הראיה. עמידה בשערים המספריים אינה מבטיחה קליפ טוב: עקביות תנועה לאורך זמן נבדקת בעין (ראו `docs/KAPILAR.md`).
- **209 פריימים, איזו קבוצת דגלים:** ראיית שרשרת הבייטים ל-209 פריימים נלקחה עם קבוצת הדגלים F209V2 על גרסת הפיתוח (בלי דגלי block-tail, נבנתה בלי הטלאים 0019/0020); `uret.ps1` משתמש במתכון הזה ל-209 פריימים [נקרא: הסקריפט; הרצת מנוע אמיתית דרך `uret.ps1` עברה בהרצה U209].
- אומת על ידינו על כרטיס אחד (GTX 1050 Ti 4 GB); דיווחים חיצוניים על כרטיסים אחרים מפורטים עם התוויות שלהם ב-`docs/KART_PROFILLERI.md` [דווח על ידי המשתמש].
- **איזה בינארי נמדד:** ה-latent של 141 פריימים ושרשרת הבייטים נמדדו עם גרסאות הפיתוח שלנו. הבינארי של ההפצה שאתם מורידים הוא בנייה חדשה: שער הבייטים של 56 פריימים עבר בו (הפריט הבא) והרצה של 209 פריימים דרך `uret.ps1` עברה את השער (הרצה U209, 3414 שניות, שיא VRAM של 3777 MiB) [נמדד]; ביחס להרצת 209 על גרסת הפיתוח ה-latent זהה בייט-בייט; בסרטון הפריימים (md5) והאודיו זהים, וה-sha256 של קובץ ה-AVI שונה בגלל המכל (container) [נמדד] (ראו `docs/OLCUMLER.md`, סעיף 0).
- **הבינארי של ההפצה, 56 פריימים:** הבינארי של ההפצה (sd-cli עם `c5cebe78...`‎, stable-diffusion.dll עם `e5d3d329...`‎) נתן תוצאה של 56 פריימים זהה בייט-בייט ל-R0 (sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`; md5 לכל פריים והאודיו זהים), הורץ ישירות עם דגלי ברירת המחדל (בלי משתני `SD_*`), קוד יציאה 0, 601 שניות [נמדד: הרצה B56VT2, 2026-11-19; הראיות נשמרות אצל המחברים ואינן במאגר הזה]. היקף: רק כרטיס ה-sm_61 שלנו ו-56 פריימים; לא בדיקת התקנה משורש נקי; ה-latent של 141 פריימים ושרשרת 209 נמדדו עם הבינארי הישן יותר ולא חזרו עליהם עם זה [לא נוסה]. ניסיון ראשון (B56VT, דרך סקריפט עזר) הסתיים בשקט אחרי 58 שניות, הסיבה לא ידועה [השערה: לחץ זיכרון]; הניסיון השני הריץ את `sd-cli` ישירות.
- סקריפטי ההתקנה וההרצה עדיין לא אומתו מתיקייה ריקה (בדיקת השורש הנקי ממתינה).
- מפת דרכים והצעדים הבאים: `ROADMAP.md`.

## סטטוס ומגבלות
- אומת על מכונה אחת (GTX 1050 Ti עם 4 GB, 16 GB RAM, i7-7700HQ). כרטיסי 4 GB אחרים וגדלי RAM אחרים עשויים להתנהג אחרת.
- **ברירת מחדל 209 פריימים (8.7 שניות):** עבר את שערי האיכות שלנו (רעש 1.08, הרצה F209V2K) [נמדד: 209 פריימים עם הקובץ הבינארי של גרסת ההפצה (release) דרך `uret.ps1`, הרצה U209; ה-latent זהה בייט-בייט להרצת גרסת הפיתוח; הפריימים והאודיו בסרטון זהים, וה-sha של הקובץ שונה בגלל המכל (container); הראיות נשמרות אצל המחברים ואינן במאגר הזה]. ב-209 פריימים שיא ה-VRAM של ה-DiT היה 3777 MiB מתוך 4096 MiB (הרצות F209b ו-U209; קריאת `nvidia-smi` של הכרטיס כולו), מרווח צר: עומס אחר על ה-GPU (המסך, יישומים אחרים) עלול לגרום להרצה להיכשל ב-`blocks.0`; נבדק רק על GTX 1050 Ti. מצב התצוגה בהרצה ההיא לא תועד; אם התצוגה שלכם רצה על הכרטיס הזה, יש פחות VRAM זמין [השערה: עומס תצוגה של Windows בסביבות 100-300 MB]; במקרה הצורך חברו את המסך ל-GPU משולב [המלצה, לא נבדקה]. שלב ה-sampling נמשך 2730 שניות (הרצה U209: צעדים של 436-483 שניות) ופענוח ה-VAE בתהליך נפרד 173 שניות (שלב 2 בסך הכול 193 שניות עם פענוח האודיו) [נמדד: U209 עם הבינארי של ההפצה; הרצות פיתוח ישנות יותר: 2664 ו-174 שניות]. בשלב 1 ה-VAE בתוך התהליך נגמר לו הזיכרון וחזר ל-temporal tiling (320 שניות); הפלט ההוא נזרק, והסרטון נלקח משלב 2 ללא אריחים. שיא ה-RAM לא נמדד ב-U209. קליפים ארוכים מ-209 פריימים אינם חלק מההפצה הזו.
- **מתמונה לסרטון (‎`-InitImg`‎):** עם תמונת התחלה התקרה על ה-GPU הזה היא 192 פריימים (8.0 שניות ב-24 fps): 209 פריימים לא נכנסו (חסרו כ-17.5 MB של VRAM בבלוק 0: נדרשו 2587 MB, זמינים 2570 MB); 192 פריימים רצו דרך `uret.ps1` ב-3086 שניות עם שיא VRAM של 3783 MiB והשער עבר [נמדד: הרצות B209 ו-B192, 2026-11-20, סצנה אחת; הראיות נשמרות אצל המחברים ואינן במאגר הזה]. לא נוסה על GPU אחרים [לא נוסה].
- **RAM פנוי חשוב:** נדרשים כ-11 GB של RAM פנוי (תהליך המנוע מחזיק כ-11 GB) [נמדד]. כשיש מעט מדי RAM פנוי התהליך עלול למות בלי הודעת שגיאה [השערה: ראינו זאת פעם אחת עם כ-300 MB של RAM פנוי בזמן ש-`sd-cli` החזיק כ-10 GB]. אל תפתחו תוכניות גדולות אחרות בזמן ההרצה: במכונה של 16 GB נשארים פנויים רק כ-0.3-0.5 GB, ותחת לחץ זיכרון ההרצה עלולה למות בשקט. לפני שמתחילים, סגרו דפדפנים, משחקים ותוכניות גדולות אחרות ובדקו כמה RAM פנוי.
- **בדיקת השורש הנקי ממתינה:** סקריפטי ההתקנה וההרצה עדיין לא אומתו מתיקייה ריקה באמצעות ההוראות האלה בלבד; הסעיף הזה יעודכן כשהבדיקה (כולל השוואת בייטים של 56 פריימים מול מקור ההשוואה) תתועד.
- אין כאן סרטונים שנוצרו.

</div>

<!-- i18n-source: README.md sha256:4d4973e30a37 -->
