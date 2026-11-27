# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · Ελληνικά · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

Οι μεταφράσεις ακολουθούν αυτό το αγγλικό README. Αν μια μετάφραση διαφέρει ή υστερεί, ισχύει το αγγλικό κείμενο, ιδίως για το κείμενο της άδειας και της ασφάλειας (τα [`SECURITY.md`](SECURITY.md) και [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) διατηρούνται μόνο στα αγγλικά και στα τουρκικά).

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **Πριν ξεκινήσετε (άδεια, περιοχή):** αυτό το αποθετήριο είναι MIT και περιέχει μόνο patches και scripts. Το μοντέλο MiniMax H3 που κατεβάζει διέπεται από την MiniMax H3 Community License: η περιοχή της εξαιρεί την Ευρωπαϊκή Ένωση, το Ηνωμένο Βασίλειο, τη Νότια Κορέα και τις Ηνωμένες Πολιτείες, και το μοντέλο, τα παράγωγα **και τα αποτελέσματα (τα βίντεο που δημιουργείτε)** δεν επιτρέπεται να χρησιμοποιούνται, να διανέμονται ή να εμφανίζονται εκεί (V.4). Η εμπορική χρήση επιτρέπεται εντός των όρων της άδειας. Διαβάστε το [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) πριν από την εγκατάσταση· αυτό δεν αποτελεί νομική συμβουλή.

> **Σε 30 δευτερόλεπτα:** μια κάρτα γραφικών 4 GB μπορεί να φτιάξει ένα βίντεο MiniMax H3 των 209 καρέ (8,7 s) με ένα μόνο πέρασμα: επαληθεύτηκε σε ένα μηχάνημα (GTX 1050 Ti 4 GB· η πλήρης εγκατάσταση με `kur.ps1` σε κενό φάκελο δεν έχει ακόμα επαληθευτεί από άκρη σε άκρη) [μετρήθηκε: 209 καρέ με το binary της κυκλοφορίας μέσω `uret.ps1`, εκτέλεση U209· το latent είναι byte-προς-byte ίδιο με την εκτέλεση του development build· τα καρέ και ο ήχος στο βίντεο είναι ίδια, το sha του αρχείου διαφέρει λόγω του container· τα τεκμήρια τα κρατούν οι συντάκτες και δεν βρίσκονται σε αυτό το αποθετήριο]· με `-InitImg` (image-to-video) το πολύ 192 καρέ (8,0 s) [μετρήθηκε: εκτέλεση B192]· τα 209 καρέ θέλουν περίπου 57 λεπτά, με προεπιλεγμένο χρονικό όριο 80 λεπτά [μετρήθηκε: εκτέλεση U209]· τα 3 βήματα παρακάτω δείχνουν πώς να το τρέξετε.

> **Χρησιμοποιείτε πράκτορα προγραμματισμού με τεχνητή νοημοσύνη (Codex, Claude Code, Gemini, Cursor);** Δώστε του αυτή τη μία πρόταση: «Διάβασε το `AGENTS_HIZLI.md` ως το τέλος, τρέξε πρώτα το `scripts\tani.ps1`, κράτα την πρόοδό σου στο `DURUM.md` και ρώτα με πριν διαγράψεις ή μετακινήσεις οτιδήποτε, αλλάξεις το Python του συστήματος ή το PATH, μειώσεις μια ρύθμιση ποιότητας ή αποδεχτείς την άδεια χρήσης του μοντέλου εκ μέρους μου.» Ο πράκτορας θα διαγνώσει αυτόν τον υπολογιστή, θα γράψει μια λίστα ελέγχου και θα σας ρωτά σε κάθε απόφαση· η άδεια του μοντέλου παραμένει δική σας απόφαση.

VideoTurko: patches μνήμης για το stable-diffusion.cpp και συνταγές για να τρέξει η δημιουργία βίντεο από κείμενο (text-to-video) του MiniMax H3 σε μια GTX 1050 Ti 4 GB, έως 209 καρέ (8,7 s) με ένα μόνο πέρασμα· το image-to-video (`-InitImg`) φτάνει έως 192 καρέ (8,0 s) (τα 209 καρέ επαληθεύτηκαν με αλυσίδα byte· byte-προς-byte ίδιο με την εκτέλεση χωρίς patches στους ελέγχους των 56 και 141 καρέ).

## Γρήγορη εκκίνηση (Windows, 3 βήματα)
**Κατάσταση: τα scripts εγκατάστασης και εκτέλεσης παρακάτω ολοκληρώνονται ακόμα και το clean-root test εκκρεμεί· τίποτα εδώ δεν ισχυρίζεται ότι δουλεύει μέχρι να περάσει εκείνος ο έλεγχος (δείτε «Κατάσταση και όρια»).**

1. **Κατεβάστε** αυτό το αποθετήριο (πράσινο κουμπί **Code**, μετά **Download ZIP**) και αποσυμπιέστε το σε ΣΥΝΤΟΜΟ φάκελο, για παράδειγμα `C:\vt`.
2. **Εγκατάσταση: διπλό κλικ στο `kur.cmd`** (ανοίγει ένα μαύρο παράθυρο που δείχνει κάθε βήμα· αν το κλείσετε, η εγκατάσταση σταματά, και αν την ξανατρέξετε συνεχίζει από εκεί που έμεινε: ένα μισοκατεβασμένο αρχείο μοντέλου συνεχίζεται [διαβάστηκε: το script λήψης κρατά ένα αρχείο `.part` και συνεχίζει από αυτό· πλήρης συνέχιση 29 GiB δεν μετρήθηκε]). Αν τα Windows προειδοποιήσουν για το αρχείο που κατεβάσατε, χρησιμοποιήστε αντί γι’ αυτό την εντολή PowerShell παρακάτω [συμβουλή, δεν δοκιμάστηκε με κατεβασμένο ZIP]. Προτιμάτε τη γραμμή εντολών; Ανοίξτε το PowerShell σε αυτόν τον φάκελο (πληκτρολογήστε `powershell` στη γραμμή διευθύνσεων της Εξερεύνησης) και τρέξτε την ίδια εγκατάσταση:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   Ο φάκελος εγκατάστασης είναι αυτός που αποσυμπιέσατε (η μηχανή μπαίνει στο `engine\bin`, τα μοντέλα στο `model`)· για άλλο σημείο ορίστε πρώτα τη μεταβλητή περιβάλλοντος `VT_ROOT`. Το script ελέγχει GPU, driver, RAM και δίσκο, κατεβάζει τη μηχανή και τα μοντέλα (τα zip της μηχανής και τα μοντέλα που μόλις κατέβηκαν ελέγχονται με sha256· ένα αρχείο μοντέλου που υπάρχει ήδη με σωστό μέγεθος ελέγχεται μόνο ως προς το μέγεθος, ενώ το `scripts\modelleri_indir.ps1 -Dogrula` τρέχει τον πλήρη έλεγχο sha256), κάνει έναν σύντομο πραγματικό έλεγχο και τυπώνει READY μόνο αν ο έλεγχος πέρασε [σχεδιασμός: το `kur.ps1` δεν έχει τρέξει ολόκληρο σε καθαρό φάκελο· αυτή η πρόταση θα ενημερωθεί μετά τη δοκιμή σε καθαρό φάκελο]. Το `-ExecutionPolicy Bypass` ισχύει μόνο για αυτή τη διεργασία· διαβάστε πρώτα το `scripts\kur.ps1`, όπως με κάθε installer.
   Το zip της μηχανής κατεβαίνει από το release v0.1.0 στο GitHub (δημοσιεύτηκε 2026-11-19· το sha256 του είναι σταθερά ορισμένο στο `kur.ps1`). Χωρίς σύνδεση στο internet ή με δικό σας build, δώστε τοπικά zip: `-MotorZip <path> -CudaZip <path>`. Ένα τοπικό zip ελέγχεται με το ίδιο σταθερά ορισμένο sha256 (ένα αρχείο `.sha256` δίπλα του αγνοείται), άρα πρέπει να είναι το zip του release· για δικό σας build ορίστε πρώτα στα `VT_MOTOR_SHA256` / `VT_CUDA_SHA256` το sha256 του. Ένα λάθος sha256 σταματά με exit 1. Στο `engine\bin` πηγαίνουν μόνο `.exe`/`.dll`· οι άδειες και το README πηγαίνουν στο `engine\lisanslar\<zip name>\`. [δοκιμάστηκε με τα dist zip πριν από το release: το πλευρικό `.sha256` μαζί με την αυτοαναφορική προειδοποίηση, τοποθετήθηκαν το binary και τα DLL, έτρεξε το `sd-cli --help`· τα sha των εγκατεστημένων binary ταίριαξαν (`c5cebe78...`, `e5d3d329...`)· το βήμα των μοντέλων και ο έλεγχος 5 καρέ του `kur.ps1` ΔΕΝ έχουν τρέξει ακόμα σε πραγματική GPU]
   **Άδεια μοντέλου:** πριν από το βήμα των μοντέλων ο installer τυπώνει τη σύνοψη της άδειας (`docs/LISANS_KABUL.txt`, πλήρες κείμενο `docs/LISANS_UYARISI.md`: MiniMax H3 Community License, γεωγραφικοί περιορισμοί που καλύπτουν και τα βίντεο που παράγονται, κανόνες για εμπορική χρήση και επισήμανση AI) και σας ζητά να την αποδεχτείτε (`E` = ναι). Διαβάστε την πρώτα. Σε εκτελέσεις χωρίς παρακολούθηση μπορείτε να περάσετε `-LisansKabul E`, που σημαίνει ότι την έχετε διαβάσει και αποδεχτεί οι ίδιοι· μην το προσθέτετε για λογαριασμό κάποιου άλλου. (Βοηθοί AI: ακολουθήστε το `AGENTS.md`· ποτέ μην πληκτρολογείτε E χωρίς τη συναίνεση του χρήστη.) Χωρίς αποδοχή το `kur.ps1` σταματά με κωδικό εξόδου 2 και δεν κατεβάζει κανένα μοντέλο.
3. **Το πρώτο σας βίντεο (56 καρέ, περίπου 11 λεπτά στη GTX 1050 Ti μας** [μετρήθηκε: 641 s, εκτέλεση R0, `docs/OLCUMLER.md`· άλλες κάρτες δεν μετρήθηκαν]**)**: όταν το πρόγραμμα εγκατάστασης τυπώσει `HAZIR / READY`, τρέξτε
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (συντόμευση: σύρετε ένα αρχείο κειμένου με το prompt πάνω στο `uret.cmd` ή τρέξτε `uret.cmd docs\ornek_istem_R0.txt`: η ίδια εκτέλεση 56 καρέ). Το βίντεο βρίσκεται στο `runs\`. Έπειτα γράψτε το δικό σας prompt σε ένα αρχείο κειμένου (μία παράγραφος στα αγγλικά, προαιρετική πρόταση `audio:`) και τρέξτε το μεγαλύτερο κλιπ που καλύπτουμε (προεπιλογή, περίπου 57 λεπτά [μετρήθηκε: εκτέλεση U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   Το `-Kare` ακολουθεί το πλέγμα 17k+5 (56, 73, ... 192, 209)· προεπιλογή 209 (8,7 s), το μεγαλύτερο μήκος που καλύπτουμε. Το VAE τρέχει σε ξεχωριστή διεργασία, ποτέ σε tiles [πραγματική εκτέλεση της μηχανής μέσω `uret.ps1` με το binary της κυκλοφορίας, VAE σε ξεχωριστή διεργασία, πέρασε στην εκτέλεση U209].

   Οδηγός συγγραφής prompt: [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (μοτίβο μίας συνεχούς λήψης, ίσα χρονικά τμήματα, δύο πλήρη παραδείγματα).

| Απαίτηση | Τιμή |
|---|---|
| Λειτουργικό σύστημα | Windows 10/11, 64-bit |
| GPU | NVIDIA, 4 GB ή περισσότερα· δοκιμάστηκε μόνο σε GTX 1050 Ti (sm_61)· λεπτό περιθώριο (3777/4096 MiB στα 209 καρέ): μια φορτωμένη οθόνη ή ένας browser μπορεί να χαλάσει την εκτέλεση· δεν δοκιμάστηκε καμία άλλη κάρτα 4 GB |
| RAM | 16 GB (κορυφή περίπου 11 GB· κλείστε τα άλλα προγράμματα) |
| Δίσκος | τουλάχιστον 32 GiB ελεύθερα (συνιστώνται 40 GiB ή περισσότερα: μεταξύ 32 και 40 το πρόγραμμα εγκατάστασης τυπώνει προειδοποίηση, `[VT-W-DISK-PAY]` [μετρήθηκε: εκτελέσεις `-Kuru` με προσομοιωμένο δίσκο]), μοντέλα σε SSD (κατά προτίμηση NVMe) |
| Λήψη | zip μηχανής 36,8 MB + zip CUDA runtime 567,5 MB [μετρήθηκε] + μοντέλα 31.473.112.040 bytes (περίπου 29,3 GiB) [διαβάστηκε: τα μεγέθη στο `scripts/modeller.json`]· περίπου 30 GiB συνολικά |
| Μοντέλα | δεν περιλαμβάνονται· τα κατεβάζει ο installer υπό την άδεια MiniMax (δείτε την προειδοποίηση παρακάτω). Τα μοντέλα (29,3 GiB, 31.473.112.040 bytes στο `scripts/modeller.json`) δεν βρίσκονται σε αυτό το αποθετήριο ούτε στο release: ισχύουν τα όρια μεγέθους αρχείων/release του GitHub, και το `kur.ps1` τα κατεβάζει από την επίσημη πηγή με επαλήθευση sha256. |

Κωδικοί εξόδου του `kur.ps1`: 0 READY, 1 σφάλμα, 2 απαιτείται είσοδος χρήστη (άδεια, ή δεν υπάρχει ακόμα release/zip), 3 ανεπαρκής υλικός εξοπλισμός ή δίσκος, 4 διακοπή (αρχείο DUR). Το `uret.ps1` δέχεται μια εκτέλεση μόνο αν υπάρχει το `.avi`, ο αριθμός καρέ είναι σωστός και τα logs είναι καθαρά [μετρήθηκε: μία πραγματική εκτέλεση μέσω `uret.ps1` με το binary της κυκλοφορίας, εκτέλεση U209, 209 καρέ, η πύλη πέρασε]. Κωδικοί εξόδου του `uret.ps1`: 0 DONE (πέρασε η πύλη ποιότητας), 1 σφάλμα ή άκυρη έξοδος (μαζί με βίντεο χωρίς ροή ήχου), 2 διακοπή (αρχείο DUR), 5 `KAPI RED` (απέτυχε η πύλη ποιότητας: το κλιπ δεν γίνεται δεκτό, η απόφαση είναι δική σας), 6 η πύλη δεν μπόρεσε να τρέξει (το κλιπ δεν γίνεται δεκτό). Λεπτομέρειες στο AGENTS.md. [μετρήθηκε: κωδικοί εξόδου 0, 1 (βίντεο χωρίς ήχο), 5 και 6 σε σενάρια με ψεύτικη μηχανή και ψεύτικη πύλη· πραγματική μηχανή: έξοδος 0 στην εκτέλεση U209]

### Αντιμετώπιση προβλημάτων (λεπτομέρειες: `docs/SIK_HATALAR.md`)
Οι γραμμές σφάλματος των scripts μας φέρουν σταθερό κωδικό, για παράδειγμα `HATA: [VT-E-DLL] ...` ή `UYARI: [VT-W-DISK-PAY] ...`. Αναζητήστε τον κωδικό στο [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) (παράδειγμα άγκυρας `#vt-e-dll`) ή στο `docs/hata_imzalari.json` και γράψτε τον κωδικό στο issue σας. Η πρώτη στήλη του πίνακα παρακάτω μένει όπως τυπώνεται (μην μεταφράζετε κωδικούς και κείμενο logs).

| Τι βλέπετε | Τι σημαίνει, τι να κάνετε |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | Μην ξεκινάτε το `sd-cli.exe` με το χέρι· τρέξτε το `scripts\kur.ps1`, που τοποθετεί τα DLL της CUDA στη θέση τους. |
| `failed during weight preparation` στο `blocks.0` (#1, #3, #5) | Δεν υπάρχει αρκετή VRAM στην πύλη μνήμης: χρησιμοποιήστε μικρότερο αριθμό καρέ στο πλέγμα 17k+5, κλείστε άλλα προγράμματα που χρησιμοποιούν τη GPU, κρατήστε τα flags που παραδίδονται. |
| `retrying with temporal tiling` (#6) | Το VAE έπεσε σε tiling· η έξοδος είναι άκυρη για σκοπούς ποιότητας. Τρέξτε ξανά. |
| Η εκτέλεση τελειώνει στο χρονικό όριο, χωρίς βίντεο (#7) | Αυξήστε το `-TavanDk` για μεγάλα κλιπ (προεπιλεγμένο χρονικό όριο: 80 λεπτά για 209 καρέ, ορίζεται από το `uret.ps1`· η δική μας εκτέλεση των 209 καρέ κράτησε 57 λεπτά [μετρήθηκε: εκτέλεση U209]). |
| Ο κωδικός εξόδου είναι κενός αλλά γράφει "finished" (#14) | Το wrapper διάβασε τον κωδικό εξόδου πολύ νωρίς· τρέξτε ξανά και ελέγξτε ότι υπάρχει το αρχείο βίντεο. |
| Το σύστημα επιβραδύνεται, γίνεται swapping (#18) | Η μηχανή χρησιμοποιεί περίπου 10-11 GB RAM· κλείστε browsers και άλλα προγράμματα. |
| Ασυμφωνία sha256 / αποτυχία λήψης | Συνήθως μια διακοπείσα λήψη: τρέξτε ξανά την ίδια εντολή, τα επαληθευμένα αρχεία παραλείπονται. |

**Κολλήσατε ή έχετε περιέργεια;** [`SUPPORT.md`](SUPPORT.md) (πού να ρωτήσετε· οι χρόνοι απάντησης είναι στόχοι, όχι δεσμεύσεις) · [`PRIVACY.md`](PRIVACY.md) (χωρίς τηλεμετρία· το δίκτυο χρησιμοποιείται μόνο για λήψη του engine και των μοντέλων από τους αναφερόμενους hosts) · [`SECURITY.md`](SECURITY.md) (ιδιωτική αναφορά) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (πρώτο pull request σε 5 βήματα· για έγγραφα και scripts δεν χρειάζεται GPU).

### Νέο στο v0.1.1: περισσότερες επιλογές (λεπτομέρειες: `AGENTS.md`, `docs/SIK_HATALAR.md` 19-23)
Χωρίς αυτές τις επιλογές τίποτα δεν αλλάζει σε κάρτα 4 GB (ο έλεγχος byte στα 56 καρέ έναντι της αναφοράς μας πέρασε ξανά με το v0.1.1 [μετρήθηκε]). Προσθέστε `-Kuru` σε οποιαδήποτε εντολή για να δείτε τι θα εκτελεστεί.
- `-EndImg`: δώστε και το τελευταίο καρέ (πρώτο και τελευταίο καρέ, «FLF»)· ανώτατο όριο 175 καρέ σε κάρτες κάτω από 8 GB (τα 192 δεν χώρεσαν σε 4 GB), 192 σε κάρτες 8 GB και άνω. Στη δική μας GTX 1050 Ti τρέχει πάντα σε δύο διεργασίες: 56 καρέ σε 1040 s, 175 καρέ σε 2887 s (48 λεπτά), και οι δύο εκτελέσεις πέρασαν την πύλη ποιότητας [μετρήθηκε]. Συμβουλές για το prompt: `docs/ISTEM_YAZIMI.md`.
- `-W` / `-H`: άλλα μεγέθη, π.χ. κάθετο 384x640· πολλαπλάσια του 32, εμβαδόν τουλάχιστον 640x384 (ποτέ μικρότερο). Δεν δοκιμάστηκε σε 4 GB· σε κάρτες κάτω από 8 GB απορρίπτονται μεγέθη που ξεπερνούν τη μεγαλύτερη δουλειά που έχουμε μετρήσει. Τα κατώφλια της πύλης ποιότητας είναι βαθμονομημένα στα 640x384.
- `-TekAsama`: μία διεργασία αντί για δύο, μόνο για μεγάλες κάρτες· δεν ενεργοποιείται ποτέ αυτόματα.
- Νεότερες GPU (compute capability 7.0+, π.χ. RTX 20/30/40): το `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` ορίζεται αυτόματα, εκτός αν το έχετε ορίσει εσείς· αυτό διόρθωσε το εντελώς μαύρο βίντεο από 141 καρέ και πάνω στην RTX 4070 Ti του χρήστη που το ανέφερε [δήλωση χρήστη, issue #1]. Χωρίς Python + OpenCV, το `uret.ps1` σταματά πλέον με κωδικό εξόδου 6 πριν από την εργασία στη GPU (δεν δημιουργείται βίντεο, ούτε παραπλανητικό RED).
- Ευχαριστούμε τον @SinanC73 για την αναφορά από RTX 4070 Ti που οδήγησε σε αυτές τις αλλαγές ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1)).

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

## Προαιρετικά προφίλ ταχύτητας (πακέτο ταχύτητας· απενεργοποιημένα από προεπιλογή)
Τίποτα από τα παρακάτω δεν αλλάζει την προεπιλεγμένη εκτέλεση (640x384, 209 καρέ, 3414 s στην κάρτα μας). Είναι τρία μετρημένα κελιά πέρα από αυτήν, καθένα ένα επώνυμο προφίλ του `uret.ps1`· χρειάζονται τη μηχανή του πακέτου ταχύτητας (η μηχανή της κυκλοφορίας συν τα patch 0021, 0023, 0024, όλα απενεργοποιημένα από προεπιλογή: `docs/YAMALAR.md`). Εγκαταστήστε την με `scripts\kur.ps1 -HizPaketi` (ένα τοπικό zip λειτουργεί με `-MotorZip`) και μετά προσθέστε `-Profil <name>`· το `-Kuru` εκτυπώνει τι θα εκτελεστεί. Το πακέτο ταχύτητας δημοσιεύεται με την έκδοση v0.1.4.

| Προφίλ | Μέγεθος, διάρκεια | Συνολικός χρόνος σε GTX 1050 Ti 4 GB | Κατάσταση |
|---|---|---|---|
| (κανένα, προεπιλογή) | 640x384, έως 209 καρέ (8,7 s) | 209 καρέ: 3414 s | επαληθευμένο, αμετάβλητο |
| `yuksek832` | 832x480, 141 καρέ (5,9 s) | περίπου 55-56 λεπτά | χρησιμοποιήσιμο, δύο prompt [μετρήθηκε] |
| `yuksek832 -Kare 124` | 832x480, 124 καρέ (5,2 s) | περίπου 45-46 λεπτά, δεν χρειάζεται σημαία ταχύτητας | χρησιμοποιήσιμο, δύο prompt [μετρήθηκε] |
| `yuksek896` | 896x512, 124 καρέ (5,2 s) | περίπου 56-57,5 λεπτά | χρησιμοποιήσιμο, δύο prompt [μετρήθηκε] |
| `uzun260` | 640x384, 260 καρέ (10,8 s) | 78 λεπτά μετρημένα χωρίς την πρόωρη έξοδο· με αυτήν περίπου 71-72 λεπτά [εικασία: δεν μετρήθηκε από άκρη σε άκρη μέσω `uret.ps1`] | υπό όρους και πειραματικό |

- **Στενό περιθώριο:** στα 832x480 x 141 η πύλη μνήμης αφήνει μονοψήφιο περιθώριο σε MB (5,7 και 6,8 MB στις δύο πλήρεις εκτελέσεις). Δύο μεγάλα prompt (1520 και 2041 χαρακτήρες) ελέγχθηκαν μόνο διαβάζοντας την πύλη για το βήμα 1 και μέρος του βήματος 2, χωρίς πλήρη εκτέλεση: περιθώριο 10,9 και 4,0 MB. Οποιαδήποτε άλλη διεργασία κρατά μνήμη της κάρτας (πρόγραμμα περιήγησης, δεύτερη οθόνη) μπορεί να οδηγήσει σε αποτυχία· τότε χρησιμοποιήστε `-Kare 124` ή το προεπιλεγμένο μέγεθος [μετρήθηκε, GTX 1050 Ti 4 GB].
- **Το `uzun260` είναι υπό όρους:** το όριο μνήμης είναι πολύ στενό (κορυφή VRAM 3903 από 4096 MiB), η χρήση κοινόχρηστης μνήμης αυξήθηκε κατά 45 και 61 MiB (όριο 68) και δεν υπάρχει αναφορά χωρίς σημαίες για ισότητα byte προς byte, γι' αυτό δεν προσφέρεται ως απλό χαρακτηριστικό. Το patch 0023 γίνεται δεκτό μόνο για αυτό το ένα κελί.
- **Δεν προσφέρεται:** το το το 832x480 με 158 καρέ δεν χωράει με τα παραδιδόμενα patches (στην πύλη του βήματος 2 λείπουν περίπου 280 MB)· τα 175 καρέ ελέγχθηκαν μόνο με ανάγνωση της πύλης (έλειπαν περίπου 275 MB στο πρώτο μπλοκ, χωρίς πλήρη εκτέλεση). Το προφίλ προσφέρει μόνο 141 καρέ. Άλλα μεγέθη και πλήθη καρέ απορρίπτονται από το `-Profil` (χρησιμοποιήστε την προεπιλεγμένη διαδρομή).
- Η προεπιλεγμένη ποιότητα μένει άθικτη: 6 βήματα, cfg 1, VAE χωρίς πλακίδια, 17k+5 καρέ. Όπου οι σημαίες είναι ενεργές, η έξοδος συγκρίθηκε byte προς byte με το βίντεο χωρίς σημαίες στα μεγέθη όπου χωράει η εκτέλεση χωρίς σημαίες (`docs/YAMALAR.md`)· στα 832x480 x 141 και 896x512 x 124 η εκτέλεση χωρίς σημαίες δεν χωράει, οπότε η ισότητα εκεί στηρίζεται στα πλησιέστερα κελιά και όχι σε άμεση σύγκριση [μετρήθηκε, διαβάστηκε].
- Το στάδιο 1 μιας εκτέλεσης δύο σταδίων τελειώνει πλέον μόλις ολοκληρωθεί το αρχείο latent (το `VT_ERKEN_CIKIS=0` το απενεργοποιεί).

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

## Τι είναι αυτό
Ένα σύνολο από μικρά patches μνήμης/χρονοδρομολόγησης για το stable-diffusion.cpp, μαζί με τη συνταγή εκτέλεσης, τους ελέγχους και τις μετρήσεις που επιτρέπουν στο MiniMax H3 (DiT 33B· εμείς τρέχουμε το HyperFlow Flash 13.7B Q4_K_M GGUF· ο text encoder Qwen3-VL 32B είναι ξεχωριστός) να τρέξει σε GPU Pascal 4 GB (GTX 1050 Ti, 16 GB RAM συστήματος).
- Μήκη ενός περάσματος που πράγματι παράξαμε και πέρασαν τις πύλες ποιότητάς μας: 56, 141, 158, 175, 192, 209 καρέ στα 640x384, 24 fps (209 καρέ = 8,7 s), με τον ήχο που παράγει το ίδιο το H3 [μετρήθηκε: 209 καρέ με το binary της κυκλοφορίας μέσω `uret.ps1`, εκτέλεση U209· το latent είναι byte-προς-byte ίδιο με την εκτέλεση του development build· τα καρέ και ο ήχος στο βίντεο είναι ίδια, το sha του αρχείου διαφέρει λόγω του container· τα τεκμήρια τα κρατούν οι συντάκτες και δεν βρίσκονται σε αυτό το αποθετήριο]. Τα 209 είναι το μεγαλύτερο μήκος που παρακολουθήσαμε και βρήκαμε ομαλό [δήλωση χρήστη, 2026-11-19, το βίντεο παρακολουθήθηκε ολόκληρο· αρχείο: έξοδος F209V2, 8,708 s].
- **Ισχυρισμός byte-προς-byte ίδιου αποτελέσματος, με ειλικρινή οριοθέτηση:** οι έξοδοι ελέγχθηκαν ως byte-προς-byte ίδιες με την αναφορά χωρίς patches μόνο για 56 και 141 καρέ. Για 158/175/192/209 καρέ χρησιμοποιήσαμε τα ίδια flags και την ίδια αλυσίδα binary· δεν υπάρχει άμεση αναφορά σε επίπεδο byte (το build χωρίς patches δεν μπορεί να τρέξει αυτά τα μήκη σε αυτή τη GPU).
- Οι ρυθμίσεις ποιότητας δεν μειώνονται ποτέ: ίδιο μοντέλο/κβαντισμός, 6 steps, cfg 1, 640x384, ίδιο seed, VAE χωρίς tiling.
- Δεν ισχυριζόμαστε ότι είμαστε οι πρώτοι: ψάξαμε και δεν βρήκαμε εξωτερικό παράδειγμα αυτού σε 4 GB, κάτι που δεν αποδεικνύει ότι δεν υπάρχει.

## Διάρθρωση
- `patches/` patches πάνω σε συγκεκριμένο, καρφωμένο commit του stable-diffusion.cpp (δείτε τις σημειώσεις εκεί)
- `scripts/` build, εκτέλεση, VAE σε ξεχωριστή διεργασία, βοηθητικά εργαλεία πύλης/συνέπειας (`doku_norm.py`: δείτε τη σημείωση κλίμακας παρακάτω)
- `docs/KURULUM.md` υλικό, build και βήματα εκτέλεσης (EN+TR)
- `docs/YAMALAR.md` λίστα των patches, `docs/KANITLAR.md` τεκμήρια, `docs/KAPILAR.md` πίνακας πυλών ποιότητας, `docs/OLCUMLER.md` μετρήσεις, `docs/SIK_HATALAR.md` συνηθισμένα λάθη, `docs/LISANS_UYARISI.md` πλήρη στοιχεία της άδειας
- `scripts/` σύντομος κατάλογος: `hiz_kos3.ps1` wrapper εκτέλεσης (το `-Kuru` τυπώνει την ακριβή εντολή), `uretim_kapi.ps1` πύλη ποιότητας, `dikis_denetim.py` έλεγχος ραφών, `doku_norm.py` θόρυβος κανονικοποιημένος ως προς την υφή, `bayt_kiyas.py` σύγκριση byte, `derleme_sablonu.ps1` πρότυπο build (σταματά μόνο τη βοηθητική διεργασία τηλεμετρίας του Visual Studio `vctip.exe` που ξεκίνησε αφού είχε αρχίσει το δικό του build, η οποία διαφορετικά κρατά τη διεργασία του build συνδεδεμένη για λεπτά· οι άλλες διεργασίες `vctip.exe` δεν πειράζονται)

## Πύλες ποιότητας (πώς γίνεται δεκτό ένα αποτέλεσμα)

Αυτή η πύλη δεν ελέγχει τη συνέπεια της κίνησης (άλματα κλίμακας ή θέσης των αντικειμένων): παρακολουθήστε ολόκληρο το βίντεο πριν το αποδεχτείτε.
1. Αριθμός καρέ και παρουσία ήχου· καμία γραμμή memory fallback ή ALLOC_FAILED στο log.
2. Πύλη ακατέργαστου θορύβου: υπόλοιπο median-filter <= 1,5 (κλίμακα 0-255).
3. Θόρυβος κανονικοποιημένος ως προς την υφή, `scripts/doku_norm.py` (η έκδοση αυτού του αποθετηρίου): N = διάμεσο υπόλοιπο / υφή Sobel, ανά 6ο καρέ. **Σημείωση κλίμακας:** σε αυτή την έκδοση τα 10 κλιπ που μετρήθηκαν δίνουν N = 0,034-0,052 (πίνακας στο `docs/KAPILAR.md`· το τελευταίο τέταρτο των F192/F209V2 φτάνει το 0,062) και το όριο της πρόσθετης πύλης είναι N <= 0,065. Μια διαφορετική υλοποίηση μέτρησε 0,028-0,036 στα ίδια κλιπ, άρα τα όρια ΔΕΝ είναι εναλλάξιμα ανάμεσα σε εκδόσεις. Σε πολύ λεπτές υφές (σειρές χόρτου) το καθαρό N ήταν 0,075, άρα το όριο ορίζεται ανά οικογένεια σκηνής. Ένας εύρωστος εκτιμητής υψηλών συχνοτήτων (sigma-HH <= 1,5· καθαρά 0,74-1,19, με προστιθέμενο θόρυβο s=2 δίνει 2,2-3,0) είναι η προτεινόμενη πρόσθετη πύλη.

Εύρος: το VideoTurko αφορά ΜΙΑ ενιαία διέλευση (έως 209 καρέ, περίπου 8,7 δευτ.). Η δική μας δοκιμή αλυσιδωτής σύνδεσης έδειξε ορατές ραφές (η σκηνή δεν συνεχίζεται καθαρά), άρα οι μεγαλύτερες ταινίες δεν ανήκουν σε όσα επαληθεύουμε. Για αλυσιδωτή σύνδεση υπάρχει ο οδηγός της κοινότητας `docs/KLIP_ZINCIRI.md` και το βοήθημά μας μόνο για CPU `scripts/zincir.py` (`plan`, `son-kare`, `bagla`· δεν ξεκινά ποτέ τη μηχανή)· την ποιότητα των αλυσιδωτών ταινιών δεν τη μετρήσαμε [δεν δοκιμάστηκε], γι' αυτό ελέγξτε κάθε ραφή με το μάτι και με το `scripts/dikis_denetim.py`.
Οι ρυθμίσεις είναι δικές σας: τα 209 καρέ είναι η δοκιμασμένη προεπιλογή μας σε κάρτα 4 GB, όχι όριο που πρέπει να τηρήσετε. Διαλέξτε οποιονδήποτε αριθμό καρέ στο πλέγμα 17k+5 (56, 73, ... 192, 209· δείτε το `docs/KURULUM.md`), αλλάξτε το prompt, το seed, την ανάλυση ή οποιοδήποτε flag θέλετε. Τα συντομότερα κλιπ θέλουν λιγότερη μνήμη και χρόνο· οι μεγαλύτερες GPU μπορεί να χωρούν περισσότερα.

## Προειδοποίηση για την άδεια του μοντέλου
**Το VideoTurko περιέχει μόνο patches και scripts (MIT)· όποιος χρησιμοποιεί το μοντέλο και τις εξόδους του φέρει ο ίδιος την ευθύνη για την άδεια MiniMax.** Δεν αποτελεί νομική συμβουλή. Παρακάτω βρίσκονται οι όροι της MiniMax H3 Community License (2 Αυγούστου 2026), συνοψισμένοι με τους αριθμούς τους· δεσμευτική είναι η ίδια η άδεια: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

Η άδεια MIT αυτού του αποθετηρίου δεν καλύπτει τα βάρη του μοντέλου· δείτε [`NOTICE`](NOTICE). Αυτό το αποθετήριο ΔΕΝ περιέχει βάρη μοντέλου (κανένα αρχείο MiniMax H3, HyperFlow-H3-Flash GGUF ή VAE). Αυτό το έργο δεν συνδέεται με τη MiniMax ούτε έχει την έγκρισή της. Η εμπορική χρήση ΔΕΝ απαγορεύεται (δεν πρόκειται για άδεια μη εμπορικής χρήσης)· οι προϋποθέσεις είναι παρακάτω.

**Επικράτεια (Applicable Territory)**
- **Προοίμιο, I.3, I.5:** Παγκοσμίως, ΕΞΑΙΡΟΥΝΤΑΙ η Ευρωπαϊκή Ένωση, το Ηνωμένο Βασίλειο, η Δημοκρατία της Κορέας και οι Ηνωμένες Πολιτείες. Η χρήση του μοντέλου θεωρείται αποδοχή της άδειας.
- **II:** Δωρεάν (royalty-free), μη μεταβιβάσιμη, περιορισμένη άδεια χρήσης, αναπαραγωγής, διανομής, δημιουργίας παράγωγων και τροποποίησης, μόνο εντός της επικράτειας και σύμφωνα με τη συμφωνία και το Exhibit A. Όσοι βρίσκονται σε εξαιρούμενες επικράτειες μπορούν να ζητήσουν ξεχωριστή άδεια από τη MiniMax.
- **V.4:** Η χρήση, αναπαραγωγή, τροποποίηση, διανομή ή προβολή του μοντέλου, των παράγωγών του ΚΑΙ ΤΩΝ ΕΞΟΔΩΝ (βίντεο/ήχος που παράγονται) εκτός της επικράτειας δεν επιτρέπεται. **Άρα η δημοσίευση ή προβολή παραγμένων βίντεο στην ΕΕ/ΗΒ/Νότια Κορέα/ΗΠΑ βρίσκεται εκτός της άδειας.**
- **Exhibit A-1:** Η χρήση εκτός της επικράτειας παραβιάζει την Acceptable Use Policy.

**Διανομή (III)** (αυτό το αποθετήριο δεν διανέμει το μοντέλο· αν το διανέμετε εσείς)
- **III.1:** Δώστε σε κάθε παραλήπτη αντίγραφο της άδειας. **III.2:** Σημειώστε τα τροποποιημένα αρχεία με εμφανείς ειδοποιήσεις.
- **III.3:** Ενθαρρύνεται (δεν είναι υποχρεωτικό): ειδοποίηση "Powered by MiniMax H3", αναγνωριστικό δημιουργίας από AI στα παραγόμενα αρχεία, δημόσια περιγραφή.
- **III.4:** Οι διανομές ΠΡΕΠΕΙ να συνοδεύονται από αρχείο NOTICE με το κείμενο: "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12:** απαγορεύεται η δημοσίευση περιεχομένου σε οποιοδήποτε δημόσιο περιβάλλον χωρίς σαφή γνωστοποίηση ότι έχει παραχθεί από μηχανή: επισημάνετε τα βίντεο που παράγονται με AI όταν τα δημοσιεύετε (πλήρης λίστα: `docs/LISANS_UYARISI.md`).
- **III (τελευταία παράγραφος):** Μπορείτε να προσθέσετε δικά σας πνευματικά δικαιώματα στις τροποποιήσεις σας, αλλά δεν μπορείτε να επιβάλετε πρόσθετους ή διαφορετικούς όρους χρήσης/διανομής· οι κανόνες επικράτειας ισχύουν ούτως ή άλλως.

**Εμπορικοί όροι (IV)**
- **IV.1:** Αν τα εμπορικά προϊόντα/υπηρεσίες σας παράγουν ετήσια έσοδα άνω των 20 εκατομμυρίων USD (ή ισόποσο), λάβετε ΠΡΟΗΓΟΥΜΕΝΗ γραπτή έγκριση από το api@minimax.io (θέμα "MiniMax H3 licensing - authorization request").
- **IV.2:** Το UI ενός εμπορικού προϊόντος/υπηρεσίας που χρησιμοποιεί το μοντέλο πρέπει να εμφανίζει εμφανώς "MiniMax H3".

**Περιορισμοί χρήσης (V)**
- **V.1:** Συμμορφωθείτε με το ισχύον δίκαιο (συμπεριλαμβανομένης της συμμόρφωσης στο εμπόριο) και το Exhibit A. **V.2:** Δεσμεύστε όσους αποκτούν πρόσβαση μέσω εσάς με όρους τουλάχιστον εξίσου προστατευτικούς με αυτούς τους περιορισμούς και ενημερώστε τους.
- **V.3:** Δεν επιτρέπεται να χρησιμοποιήσετε το μοντέλο ή τις ΕΞΟΔΟΥΣ του για τη βελτίωση οποιουδήποτε άλλου μοντέλου AI (εκτός του MiniMax H3 και των παράγωγών του). (I.11: η distillation και η εκπαίδευση σε συνθετικές εξόδους καθιστούν ένα μοντέλο "παράγωγο"· οι ίδιες οι έξοδοι δεν είναι παράγωγα.)
- **V.5:** Αν προσφέρετε σε τρίτους προϊόν/υπηρεσία/φιλοξενούμενη υπηρεσία που παράγει εξόδους με το μοντέλο: πριν και καθ' όλη τη λειτουργία, εύλογα τεχνικά και οργανωτικά μέτρα προστασίας, μηχανισμός αναφοράς, άμεση διερεύνηση, και αφαίρεση/απενεργοποίηση/αναστολή των χρηστών που παραβιάζουν επανειλημμένα.

**Εμπορικό σήμα και δικαιώματα (VI)**
- **VI.1:** Σας ανήκουν τα παράγωγα έργα και τα παράγωγα του μοντέλου που δημιουργείτε (με την επιφύλαξη των δικαιωμάτων της MiniMax). **VI.2:** Τα ονόματα/σήματα της MiniMax δεν αδειοδοτούνται (πέραν όσων χρειάζονται για την περιγραφή και τη διανομή)· το σήμα "MiniMax H3" μπορεί να χρησιμοποιηθεί μόνο για συμμόρφωση με το III.3, εντός της επικράτειας· μην υπονοείτε σχέση με τη MiniMax.
- **VI.3:** Αν μηνύσετε τη MiniMax ή οποιονδήποτε ισχυριζόμενοι ότι τα υλικά/οι έξοδοι παραβιάζουν τα δικαιώματά σας, όλες οι άδειές σας λήγουν εκείνη την ημέρα· υπερασπίζεστε και αποζημιώνετε τη MiniMax έναντι αξιώσεων τρίτων που προκύπτουν από τη δική σας ή άλλων χρήση/διανομή.
- **VI.4:** Η MiniMax δεν διεκδικεί δικαιώματα επί των εξόδων· εσείς και οι χρήστες σας είστε υπεύθυνοι για τις εξόδους και τη χρήση τους.

**Αποποιήσεις και λήξη (VII, VIII, IX)**
- **VII.1:** Καμία υποχρέωση υποστήριξης/ενημέρωσης. **VII.2:** Το μοντέλο και οι έξοδοι παρέχονται "AS IS", χωρίς εγγυήσεις· εσείς κρίνετε την καταλληλότητα και αναλαμβάνετε τον κίνδυνο. **VII.3:** Η MiniMax και οι συνδεδεμένες εταιρείες δεν ευθύνονται για καμία ζημία (στον βαθμό που το επιτρέπει ο νόμος).
- **VIII.1:** Ισχύει από την αποδοχή/πρόσβαση. **VIII.2:** Σε περίπτωση παραβίασης η MiniMax μπορεί να καταγγείλει την άδεια· πρέπει να σταματήσετε τη χρήση/διανομή, να διαγράψετε τα αντίγραφα και να ενημερώσετε τους παραλήπτες (τα VI.1, VI.3, VII, IX παραμένουν σε ισχύ).
- **IX:** Δίκαιο της Ειδικής Διοικητικής Περιφέρειας του Χονγκ Κονγκ· αποκλειστική δικαιοδοσία των δικαστηρίων του Χονγκ Κονγκ (εξαιρείται η CISG του ΟΗΕ).
- **Πρόσθετη σημείωση:** ο encoder του MiniMax H3 χρησιμοποιεί το Qwen3-VL-32B (Apache 2.0).

**Acceptable Use Policy (Exhibit A)** (ΜΗΝ χρησιμοποιείτε το μοντέλο, τα παράγωγα ή τις εξόδους για)
- A-1 χρήση εκτός της επικράτειας· A-2 παραβίαση νόμων ή πνευματικής ιδιοκτησίας τρίτων· A-3 βλάβη στον εαυτό σας ή σε άλλους· A-4 επαναχρησιμοποίηση/διανομή εξόδων για βλάβη· A-5 παράκαμψη μέτρων προστασίας· A-6 εκμετάλλευση/βλάβη ανηλίκων· A-7 επαληθεύσιμα ψευδείς πληροφορίες για βλάβη άλλων ή επηρεασμό εκλογών· A-8 ψεύτικη διαδικτυακή αλληλεπίδραση (ψεύτικες κριτικές κ.λπ.)· A-9 δυσφήμιση, διασυρμός, παρενόχληση· A-10 κακόβουλο λογισμικό· A-11 προσωπικά δεδομένα για βλάβη άλλων· **A-12 δημοσίευση περιεχομένου σε οποιοδήποτε δημόσιο περιβάλλον (συμπεριλαμβανομένων αναρτήσεων από bots) χωρίς σαφή και εμφανή γνωστοποίηση ότι έχει παραχθεί από μηχανή**· A-13 πλαστοπροσωπία χωρίς συναίνεση· A-14 αυτοματοποιημένες αποφάσεις υψηλού κινδύνου σε κρίσιμους τομείς (επιβολή του νόμου, μετανάστευση, υγεία, κρίσιμες υποδομές, πίστωση, απασχόληση, στέγαση, εκπαίδευση, κοινωνική βαθμολόγηση, ασφάλιση κ.λπ.)· A-15 παραβίαση κοινωνικών, ηθικών προτύπων άλλων χωρών/περιοχών· A-16 βίαιος εξτρεμισμός/τρομοκρατία· A-17 διακρίσεις/βλάβη με βάση προστατευόμενα χαρακτηριστικά· A-18 εκμετάλλευση ευάλωτων πληθυσμών· **A-19 στρατιωτικοί σκοποί**· A-20 μη εξουσιοδοτημένη/χωρίς άδεια επαγγελματική δραστηριότητα (οικονομική, νομική, ιατρική κ.λπ.).
- Σημείωση: αυτή είναι μια σύνοψη σε απλή γλώσσα· σε περίπτωση αμφιβολίας υπερισχύει το αγγλικό κείμενο της άδειας.

## Ετικέτες τεκμηρίων

Ένα κοινό σύνολο για όλα τα έγγραφα (παλαιότερες γραφές σε παρένθεση):
- **[μετρήθηκε]** (TR: ölçtüm, olctum): τρέχτηκε σε αυτό το έργο, υπάρχει διαδρομή τεκμηρίου.
- **[διαβάστηκε]** (TR: okudum yol, okudum): διαβάστηκε η πηγή ή το script, δεν εκτελέστηκε.
- **[σχεδιασμός]** (TR: tasarım, tasarim): σχεδιάστηκε, δεν έχει ακόμα φανεί σε πραγματική εκτέλεση.
- **[εικασία]** (TR: tahmin): δεν έχει επαληθευτεί.
- **[δεν δοκιμάστηκε]** (TR: denenmedi): δεν έχει τρέξει ποτέ.
- **[δήλωση χρήστη]** (TR: kullanıcı bildirdi): δηλώθηκε από τον χρήστη, με ημερομηνία· δεν μετρήθηκε ανεξάρτητα.
- **[υπολογίστηκε]** (TR: hesap· παλαιότερες γραφές: calculated, hesap): αριθμός που προκύπτει από μετρημένα δεδομένα, δεν μετρήθηκε ο ίδιος· η παραγωγή του γράφεται δίπλα του. [πρόταση] / [öneri] σε παλαιότερο κείμενο = [εικασία].

Ονόματα εκτελέσεων που χρησιμοποιούνται σε αγκύλες (δικά μας ονόματα εκτελέσεων, όχι αρχεία αυτού του αποθετηρίου): U209 = 209 καρέ με το binary της κυκλοφορίας μέσω `uret.ps1`· B209 και B192 = εκτελέσεις image-to-video (`-InitImg`) στα 209 και 192 καρέ· B56VT2 = binary κυκλοφορίας, 56 καρέ, σε σύγκριση με την αναφορά byte των 56 καρέ R0· F209b, F209V2, F209V2K = εκτελέσεις 209 καρέ στο development build (λεπτομέρειες: `docs/OLCUMLER.md`).

## Γνωστοί περιορισμοί
- **Απόδειξη σε επίπεδο byte** (πώς να την αναπαράγετε μόνοι σας: `docs/KANITLAR.md`, "R0 ve latent referansi nasil uretilir"· επαληθεύτηκε στην κάρτα μας sm_61, άλλες GPU μπορεί να μην είναι byte-προς-byte ίδιες [εικασία]): με τη σειρά των patches μας (με ενεργά τα flags μνήμης) μια εκτέλεση 56 καρέ έδωσε sha256 `0979f156d548169b...`, ίδιο με την αναφορά [μετρήθηκε]· στα 141 καρέ το sha256 του latent `E5D028F8632BE4FE...` ήταν ίδιο (με τα flags 0013/0014). Τα καρέ 158 έως 209 δεν έχουν άμεση αναφορά σε επίπεδο byte· η αλυσίδα πυλών είναι το τεκμήριο. Το πέρασμα των αριθμητικών πυλών δεν εγγυάται ένα καλό κλιπ: η συνέπεια της κίνησης στον χρόνο ελέγχεται με το μάτι (δείτε το `docs/KAPILAR.md`).
- **209 καρέ, ποιο σύνολο flags:** το τεκμήριο της αλυσίδας byte για τα 209 καρέ λήφθηκε με το σύνολο flags F209V2 στο development build (χωρίς flags block-tail, build χωρίς τα patches 0019/0020)· το `uret.ps1` χρησιμοποιεί αυτή τη συνταγή για 209 καρέ [διαβάστηκε: το script· μια πραγματική εκτέλεση της μηχανής μέσω `uret.ps1` πέρασε στην εκτέλεση U209].
- Επαληθευμένο από εμάς σε μία κάρτα (GTX 1050 Ti 4 GB)· οι εξωτερικές αναφορές για άλλες κάρτες καταγράφονται με τις ετικέτες τους στο `docs/KART_PROFILLERI.md` [δήλωση χρήστη].
- **Ποιο binary μετρήθηκε:** το latent των 141 καρέ και η αλυσίδα byte μετρήθηκαν με τα development builds μας. Το binary της κυκλοφορίας που κατεβάζετε είναι νέο build: η πύλη byte των 56 καρέ πέρασε (επόμενο στοιχείο) και μια εκτέλεση 209 καρέ μέσω `uret.ps1` πέρασε την πύλη (εκτέλεση U209, 3414 s, κορυφή VRAM 3777 MiB) [μετρήθηκε]· σε σύγκριση με την εκτέλεση 209 του development build το latent είναι byte-προς-byte ίδιο· στο βίντεο τα καρέ (md5) και ο ήχος είναι ίδια, το sha256 του αρχείου AVI διαφέρει λόγω του container [μετρήθηκε] (δείτε το `docs/OLCUMLER.md`, ενότητα 0).
- **Binary κυκλοφορίας, 56 καρέ:** το binary της κυκλοφορίας (sd-cli `c5cebe78...`, stable-diffusion.dll `e5d3d329...`) έδωσε αποτέλεσμα 56 καρέ byte-προς-byte ίδιο με το R0 (sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`· ίδιο md5 ανά καρέ και ίδιος ήχος), τρέχοντας απευθείας με τα προεπιλεγμένα flags (χωρίς μεταβλητές `SD_*`), κωδικός εξόδου 0, 601 s [μετρήθηκε: εκτέλεση B56VT2, 2026-11-19· τα τεκμήρια τα κρατούν οι συντάκτες και δεν βρίσκονται σε αυτό το αποθετήριο]. Εύρος: μόνο η κάρτα μας sm_61 και τα 56 καρέ· δεν είναι δοκιμή εγκατάστασης από καθαρό φάκελο· το latent των 141 καρέ και η αλυσίδα των 209 μετρήθηκαν με το παλαιότερο binary και ΔΕΝ επαναλήφθηκαν με αυτό [δεν δοκιμάστηκε]. Μια πρώτη απόπειρα (B56VT, μέσω βοηθητικού script) τελείωσε σιωπηλά μετά από 58 s, άγνωστη αιτία [εικασία: πίεση μνήμης]· η δεύτερη απόπειρα έτρεξε απευθείας το `sd-cli`.
- Τα scripts εγκατάστασης και εκτέλεσης δεν έχουν ακόμα επαληθευτεί από κενό φάκελο (το clean-root test εκκρεμεί).
- Οδικός χάρτης και επόμενα βήματα: `ROADMAP.md`.

## Κατάσταση και όρια
- Επαληθεύτηκε σε ένα μηχάνημα (GTX 1050 Ti 4 GB, 16 GB RAM, i7-7700HQ). Άλλες κάρτες 4 GB και άλλα μεγέθη RAM μπορεί να διαφέρουν.
- **Προεπιλογή 209 καρέ (8,7 s):** πέρασε τις πύλες ποιότητάς μας (θόρυβος 1,08, εκτέλεση F209V2K) [μετρήθηκε: 209 καρέ με το binary της κυκλοφορίας μέσω `uret.ps1`, εκτέλεση U209· το latent είναι byte-προς-byte ίδιο με την εκτέλεση του development build· τα καρέ και ο ήχος στο βίντεο είναι ίδια, το sha του αρχείου διαφέρει λόγω του container· τα τεκμήρια τα κρατούν οι συντάκτες και δεν βρίσκονται σε αυτό το αποθετήριο]. Στα 209 καρέ η κορυφή VRAM του DiT ήταν 3777 MiB από 4096 MiB (εκτελέσεις F209b και U209· ένδειξη `nvidia-smi` για ολόκληρη την κάρτα), λεπτό περιθώριο: άλλο φορτίο στη GPU (η οθόνη, άλλες εφαρμογές) μπορεί να κάνει την εκτέλεση να αποτύχει στο `blocks.0`· δοκιμάστηκε μόνο σε GTX 1050 Ti. Η κατάσταση της οθόνης κατά την εκτέλεση δεν καταγράφηκε· αν η οθόνη σας τρέχει σε αυτή την κάρτα, υπάρχει λιγότερη διαθέσιμη VRAM [εικασία: φορτίο οθόνης των Windows περίπου 100-300 MB]· αν χρειαστεί, συνδέστε την οθόνη σε ενσωματωμένη GPU [συμβουλή, δεν δοκιμάστηκε]. Το sampling κράτησε 2730 s (εκτέλεση U209: steps των 436-483 s) και η αποκωδικοποίηση VAE σε ξεχωριστή διεργασία 173 s (το στάδιο 2 συνολικά 193 s με την αποκωδικοποίηση του ήχου) [μετρήθηκε: U209 binary κυκλοφορίας· παλαιότερες εκτελέσεις development: 2664 s και 174 s]. Στο στάδιο 1 το VAE εντός διεργασίας ξέμεινε από μνήμη και έπεσε σε temporal tiling (320 s)· αυτή η έξοδος απορρίπτεται, το βίντεο προέρχεται από το στάδιο 2 χωρίς tiling. Η κορυφή RAM δεν μετρήθηκε στο U209. Κλιπ μεγαλύτερα από 209 καρέ δεν αποτελούν μέρος αυτής της κυκλοφορίας.
- **Image-to-video (`-InitImg`):** με εικόνα εκκίνησης το όριο είναι 192 καρέ (8,0 s στα 24 fps) σε αυτή τη GPU: τα 209 καρέ δεν χώρεσαν (έλειπαν περίπου 17,5 MB VRAM στο block 0: χρειάζονταν 2587 MB, διαθέσιμα 2570 MB)· τα 192 καρέ έτρεξαν μέσω `uret.ps1` σε 3086 s με κορυφή VRAM 3783 MiB και η πύλη πέρασε [μετρήθηκε: εκτελέσεις B209 και B192, 2026-11-20, μία σκηνή· τα τεκμήρια τα κρατούν οι συντάκτες και δεν βρίσκονται σε αυτό το αποθετήριο]. Δεν δοκιμάστηκε σε άλλες GPU [δεν δοκιμάστηκε].
- **Η ελεύθερη RAM μετράει:** χρειάζονται περίπου 11 GB ΕΛΕΥΘΕΡΗΣ RAM (η διεργασία της μηχανής κρατά περίπου 11 GB) [μετρήθηκε]. Με πολύ λίγη ελεύθερη RAM η διεργασία μπορεί να πεθάνει χωρίς μήνυμα σφάλματος [εικασία: το παρατηρήσαμε μία φορά με περίπου 300 MB ελεύθερη RAM ενώ το `sd-cli` κρατούσε περίπου 10 GB]. Μην ανοίγετε άλλα μεγάλα προγράμματα όσο τρέχει: σε μηχάνημα 16 GB μένουν ελεύθερα μόνο περίπου 0,3-0,5 GB, και υπό πίεση μνήμης η εκτέλεση μπορεί να πεθάνει σιωπηλά. Πριν ξεκινήσετε, κλείστε browsers, παιχνίδια και άλλα μεγάλα προγράμματα και ελέγξτε την ελεύθερη RAM.
- **Το clean-root test εκκρεμεί:** τα scripts εγκατάστασης και εκτέλεσης δεν έχουν ακόμα επαληθευτεί από κενό φάκελο μόνο με αυτές τις οδηγίες· αυτή η ενότητα θα ενημερωθεί όταν καταγραφεί εκείνη η δοκιμή (μαζί με σύγκριση byte 56 καρέ με την αναφορά).
- Δεν διανέμονται εδώ παραγμένα βίντεο.

<!-- i18n-source: README.md sha256:a26a5a878a5f -->
