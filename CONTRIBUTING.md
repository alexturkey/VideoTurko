# Contributing / Katkı

## English (authoritative)

Thank you for helping. You do not need to be an expert, and most useful changes need **no GPU**.

**What helps most:** tests on other GPUs (card, driver, frame count, time, VRAM peak, result of the gates; use the Hardware test issue form), clearer install steps, typo and translation fixes, and measured memory improvements.

### Your first pull request in 5 steps
1. **Fork** the repository (Fork button on GitHub), then clone your fork.
2. **Branch and change one thing**: `git switch -c fix/short-name`.
3. **Run the checks** (a few seconds, no GPU, needs Python 3): `python -I -X utf8 scripts/denetim.py --hizli` (on Windows, one command that finds Python for you: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\on_kontrol.ps1`; it prints PASSED or RED)
4. **Commit and push** to your fork. Use your GitHub no-reply e-mail (see "Your commit e-mail" below).
5. **Open the pull request** and fill in the short template. Not sure it is ready? Open it as a **draft**; we will say what to fix. Our goal is a first reply within 7 days: a goal of a small volunteer project, not a promise.

### What we accept and what we decline
| Accepted | Declined (with a kind reason) |
|---|---|
| A test report from another GPU, with the log | Lower quality to go faster (fewer steps, other cfg, tiled VAE): quality settings are fixed |
| Docs, typo and translation fixes | Model weights, videos or other large binaries |
| A script fix that shows the problem and the fix | Claims nobody ran ("should work") |
| A patch that is byte-identical on 56 frames, or marked experimental and default-off | Personal paths, names, e-mails, tokens |
| A memory saving with a measurement | Invisible or bidirectional Unicode, obfuscated code, downloads from hosts not listed in `PRIVACY.md`, telemetry |

A decline is about the rule, never about you.

### Evidence labels (use them in the pull request and in docs)
- **[measured]** you ran it and kept the log or numbers.
- **[read]** you read it in a file or document (give the path).
- **[computed]** derived from measured numbers.
- **[user-reported]** someone else reported it; not reproduced.
- **[guess]** not checked.

Do not write "works" about something you did not run. A labelled guess is welcome; an unlabelled one is not.

### Two kinds of change
- **Docs and scripts** (`README*`, `docs/`, `scripts/`, templates): no GPU needed. Run the checks above. If you change `scripts/kur.ps1` or `scripts/uret.ps1`, compare the `-Kuru` (dry run) output before and after; the default command line and the quality settings must not change.
- **Patches and engine behaviour** (`patches/`): a 56-frame run must be byte-identical to the reference (`docs/KANITLAR.md`, `scripts/bayt_kiyas.py`), or the patch is clearly marked experimental and default-off. Patch files stay LF. This needs a GPU; if you have none, open an issue and describe the idea.

### No GPU? You can still help
Read the install steps and tell us where you got stuck, fix a sentence in a translation, add a missing "what you see / what to do" row to `docs/SIK_HATALAR.md`, improve a script's error message, or run `python -I -X utf8 -m unittest discover -s tests`. These are real contributions.

### One language is enough
Write your pull request in English or Turkish (any language is fine if that is what you have; we will cope). You do not have to write both: if your change touches a section, a maintainer writes the other language. For README content changes edit `README.md` (the English source); the 29 translations are updated together by the maintainers. A typo fix inside one translation is welcome: run `python -I -X utf8 scripts/dil_eslik_denetimi.py` afterwards. For the license and security text, English is authoritative in every language.

### Your commit e-mail
Commits keep their e-mail in history for good. To keep your address private use the GitHub no-reply address: **GitHub > Settings > Emails > "Keep my email addresses private"**, then `git config user.email "<ID>+<username>@users.noreply.github.com"` (the ID is shown on that page). Commits with another address are accepted; our checks only warn.

### Also
- Security problems: do not open a public issue; see `SECURITY.md`.
- Working with an AI coding agent: read `AGENTS.md`; the agent must never accept the model license for you. Ask it to run `scripts\tani.ps1` first and to keep its progress in `DURUM.md`.
- Contributions are accepted under the repository's MIT license (the same license as the code). The model and its outputs stay under the MiniMax license (`docs/LISANS_UYARISI.md`).
- Be kind: `CODE_OF_CONDUCT.md`.
- No package dependencies exist, so no dependency bot is configured.

## Türkçe

Teşekkürler. Uzman olmanız gerekmez; işe yarayan değişikliklerin çoğu **ekran kartı istemez**.

**En değerli katkı:** başka kartlarda test (kart, sürücü, kare sayısı, süre, VRAM tepesi, kapıların sonucu; Donanım testi formunu kullanın), daha net kurulum adımları, yazım ve çeviri düzeltmeleri, ölçülmüş bellek iyileştirmeleri.

### İlk PR'ınız 5 adımda
1. Repoyu **fork'layın** (GitHub'da Fork düğmesi), fork'unuzu klonlayın.
2. **Dal açın, tek şeyi değiştirin**: `git switch -c fix/kisa-ad`.
3. **Kontrolleri çalıştırın** (birkaç saniye, GPU yok, Python 3 gerekir): `python -I -X utf8 scripts/denetim.py --hizli` (Windows'ta Python'u kendisi bulan tek komut: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\on_kontrol.ps1`; GEÇTİ ya da KIRMIZI yazar)
4. Fork'unuza **commit ve push**. GitHub no-reply e-postanızı kullanın (aşağıda).
5. **PR açın**, kısa şablonu doldurun. Hazır mı emin değilseniz **taslak (draft)** açın; neyi düzelteceğinizi söyleriz. Hedefimiz ilk yanıtı 7 gün içinde vermek: küçük bir gönüllü projenin hedefi, taahhüdü değil.

### Neyi alırız, neyi geri çeviririz
| Alırız | Gerekçesini nazikçe söyleyerek geri çeviririz |
|---|---|
| Başka kartta test raporu (günlükle) | Hız için kaliteyi düşürmek (az adım, başka cfg, karolu VAE): kalite ayarları sabit |
| Belge, yazım, çeviri düzeltmesi | Model ağırlığı, video, büyük ikili dosya |
| Sorunu ve çözümü gösteren betik düzeltmesi | Kimsenin çalıştırmadığı iddia ("çalışmalı") |
| 56 karede bayt-aynı yama ya da deneysel ve varsayılan kapalı işaretli yama | Kişisel yol, ad, e-posta, token |
| Ölçümlü bellek kazancı | Görünmez/çift yönlü Unicode, gizlenmiş kod, `PRIVACY.md`'de olmayan adresten indirme, telemetri |

Ret kurala dairdir, size değil.

### Kanıt etiketleri (PR'da ve belgelerde kullanın)
**[ölçtüm]** çalıştırdınız, günlük/sayı elinizde; **[okudum]** dosya ya da belgede okudunuz (yolunu yazın); **[hesap]** ölçülen sayılardan türetildi; **[kullanıcı bildirdi]** başkası bildirdi, tekrarlanmadı; **[tahmin]** denenmedi. Çalıştırmadığınız şey için "çalışır" yazmayın; etiketli tahmin makbuldür.

### İki tür değişiklik
- **Belge ve betik** (`README*`, `docs/`, `scripts/`, şablonlar): GPU gerekmez; yukarıdaki kontrolü çalıştırın. `scripts/kur.ps1` ya da `scripts/uret.ps1` değişirse `-Kuru` (kuru çalışma) çıktısını önce/sonra kıyaslayın; varsayılan komut satırı ve kalite ayarları değişmez.
- **Yama ve motor davranışı** (`patches/`): 56 karede referansla bayt-aynı olmalı (`docs/KANITLAR.md`, `scripts/bayt_kiyas.py`) ya da açıkça deneysel ve varsayılan kapalı işaretlenmeli; yama dosyaları LF kalır. GPU gerekir; kartınız yoksa fikri issue olarak yazın.

### GPU'nuz yok mu? Yine de yardım edebilirsiniz
Kurulum adımlarını okuyup nerede takıldığınızı söylemek, bir çeviride cümle düzeltmek, `docs/SIK_HATALAR.md`'ye eksik bir "ne görürsünüz / ne yapılır" satırı eklemek, bir betiğin hata mesajını netleştirmek ya da `python -I -X utf8 -m unittest discover -s tests` çalıştırmak gerçek katkıdır.

### Tek dil yeter
PR'ınızı İngilizce ya da Türkçe yazın (elinizdeki dil neyse o da olur). İkisini birden yazmanız gerekmez: değişiklik bir bölüme dokunuyorsa diğer dili bakımcı yazar. README içerik değişikliği için `README.md`'yi (İngilizce kaynak) düzenleyin; 29 çeviri bakımcılar tarafından birlikte güncellenir. Bir çevirideki yazım hatası düzeltmesi hoş karşılanır: sonra `python -I -X utf8 scripts/dil_eslik_denetimi.py` çalıştırın. Lisans ve güvenlik metninde her dilde İngilizce esastır.

### Commit e-postanız
Commit'teki e-posta geçmişte kalıcıdır. Gizli kalması için GitHub no-reply adresini kullanın: **GitHub > Settings > Emails > "Keep my email addresses private"**, sonra `git config user.email "<ID>+<kullanici>@users.noreply.github.com"` (ID aynı sayfada yazar). Başka adresli commit de kabul edilir; kontrollerimiz yalnız uyarır.

### Ayrıca
Güvenlik sorunu: herkese açık issue açmayın, `SECURITY.md`. Yapay zeka ajanıyla çalışıyorsanız `AGENTS.md`: ajan sizin yerinize model lisansını asla kabul etmez. Ajanınıza önce `scripts\tani.ps1` çalıştırmasını ve ilerlemesini `DURUM.md` dosyasında tutmasını söyleyin. Katkılar deponun MIT lisansı (kodla aynı) altında kabul edilir; model ve çıktıları MiniMax lisansında kalır (`docs/LISANS_UYARISI.md`). Nazik olun: `CODE_OF_CONDUCT.md`.
