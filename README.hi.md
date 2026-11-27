# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · हिन्दी · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

अनुवाद इस अंग्रेज़ी README का अनुसरण करते हैं। यदि कोई अनुवाद अलग हो या पीछे रह जाए, तो विशेषकर लाइसेंस और सुरक्षा पाठ के लिए अंग्रेज़ी पाठ ही प्रामाणिक है ([`SECURITY.md`](SECURITY.md) और [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) केवल अंग्रेज़ी और तुर्की में रखे जाते हैं)।

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **शुरू करने से पहले (लाइसेंस, क्षेत्र):** यह रिपॉज़िटरी MIT है और इसमें केवल पैच और स्क्रिप्ट हैं। यह जो MiniMax H3 मॉडल डाउनलोड करती है वह MiniMax H3 Community License के अंतर्गत है: इसके क्षेत्र में यूरोपीय संघ, यूनाइटेड किंगडम, दक्षिण कोरिया और संयुक्त राज्य अमेरिका शामिल नहीं हैं, और मॉडल, व्युत्पन्न **तथा आउटपुट (आपके बनाए वीडियो)** का वहाँ उपयोग, वितरण या प्रदर्शन नहीं किया जा सकता (V.4)। लाइसेंस की शर्तों के भीतर व्यावसायिक उपयोग की अनुमति है। इंस्टॉल करने से पहले [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) पढ़ें; यह कानूनी सलाह नहीं है।

> **30 सेकंड में:** 4 GB का ग्राफ़िक्स कार्ड एक ही पास में 209 फ़्रेम (8.7 सेकंड) का MiniMax H3 वीडियो बना सकता है: एक मशीन पर सत्यापित (GTX 1050 Ti 4 GB; खाली फ़ोल्डर में पूरा `kur.ps1` इंस्टॉलेशन शुरू से अंत तक अभी सत्यापित नहीं हुआ है) [मापा गया: 209 फ़्रेम, रिलीज़ बाइनरी के साथ `uret.ps1` के ज़रिए, रन U209; latent डेवलपमेंट-बिल्ड के रन से बाइट-दर-बाइट समान; वीडियो में फ़्रेम और ऑडियो समान, फ़ाइल का sha कंटेनर के कारण अलग; प्रमाण लेखकों के पास सुरक्षित हैं, इस रिपॉज़िटरी में नहीं]; `-InitImg` (इमेज से वीडियो) के साथ अधिकतम 192 फ़्रेम (8.0 सेकंड) [मापा गया: रन B192]; 209 फ़्रेम में लगभग 57 मिनट लगते हैं, डिफ़ॉल्ट समय-सीमा 80 मिनट [मापा गया: रन U209]; नीचे के 3 चरण इसे चलाने का तरीका हैं।

> **क्या आप AI कोडिंग एजेंट (Codex, Claude Code, Gemini, Cursor) इस्तेमाल कर रहे हैं?** उसे बस यही एक वाक्य दें: “`AGENTS_HIZLI.md` को अंत तक पढ़ो, पहले `scripts\tani.ps1` चलाओ, अपनी प्रगति `DURUM.md` में रखो, और कुछ भी हटाने या ले जाने, सिस्टम Python या PATH बदलने, गुणवत्ता की कोई सेटिंग घटाने, या मेरी ओर से मॉडल का लाइसेंस स्वीकार करने से पहले मुझसे पूछो।” एजेंट इस पीसी की जाँच करेगा, एक चेकलिस्ट लिखेगा और हर निर्णय पर आपसे पूछेगा; मॉडल का लाइसेंस आपका ही निर्णय रहेगा।

VideoTurko: stable-diffusion.cpp के मेमोरी पैच और चलाने की विधि, जिससे MiniMax H3 text-to-video 4 GB की GTX 1050 Ti पर एक ही पास में 209 फ़्रेम (8.7 सेकंड) तक चलता है; image-to-video (`-InitImg`) 192 फ़्रेम (8.0 सेकंड) तक (209 फ़्रेम बाइट-श्रृंखला से सत्यापित; 56 और 141 फ़्रेम की जाँच में बिना पैच वाले रन के साथ बाइट-समान)।

## त्वरित शुरुआत (Windows, 3 चरण)
**स्थिति: नीचे की इंस्टॉल/रन स्क्रिप्ट अभी पूरी की जा रही हैं और clean-root परीक्षण बाकी है; जब तक वह परीक्षण पास नहीं होता, यहाँ कुछ भी काम करने का दावा नहीं किया जाता ("स्थिति और सीमाएँ" देखें)।**

1. इस रिपॉज़िटरी को **डाउनलोड** करें (हरा **Code** बटन, फिर **Download ZIP**) और किसी छोटे नाम वाले फ़ोल्डर में एक्सट्रैक्ट करें, जैसे `C:\vt`।
2. **इंस्टॉल: `kur.cmd` पर डबल-क्लिक करें** (एक काली विंडो खुलती है और हर चरण दिखाती है; उसे बंद करने से इंस्टॉल रुक जाता है, और दोबारा चलाने पर वह जहाँ रुका था वहीं से जारी रहता है: आधी डाउनलोड हुई मॉडल फ़ाइल वहीं से जारी रखी जाती है [पढ़ा गया: डाउनलोड स्क्रिप्ट एक `.part` फ़ाइल रखती है और उसी से आगे बढ़ती है; पूरे 29 GiB के डाउनलोड को बीच से जारी रखना नहीं मापा गया])। यदि Windows डाउनलोड की गई फ़ाइल के बारे में चेतावनी दे, तो इसके बजाय नीचे दिया PowerShell कमांड इस्तेमाल करें [सलाह, डाउनलोड किए गए ZIP पर परखा नहीं गया]। कमांड लाइन पसंद है? उस फ़ोल्डर में PowerShell खोलें (Explorer की एड्रेस बार में `powershell` टाइप करें) और वही इंस्टॉल चलाएँ:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   इंस्टॉल रूट वही फ़ोल्डर है जिसे आपने एक्सट्रैक्ट किया (इंजन `engine\bin` में, मॉडल `model` में जाते हैं); कोई और जगह चुनने के लिए पहले एनवायरनमेंट वेरिएबल `VT_ROOT` सेट करें। यह GPU, ड्राइवर, RAM और डिस्क जाँचता है, इंजन और मॉडल लाता है (इंजन zip और नए डाउनलोड हुई मॉडल फ़ाइलों की sha256 जाँच होती है; सही आकार वाली पहले से मौजूद मॉडल फ़ाइल की केवल आकार जाँच होती है, `scripts\modelleri_indir.ps1 -Dogrula` पूरी sha256 जाँच चलाता है), एक छोटी असली जाँच चलाता है, और READY तभी छापता है जब वह जाँच पास हो [डिज़ाइन: `kur.ps1` साफ़ फ़ोल्डर में अभी पूरा नहीं चलाया गया; साफ़-फ़ोल्डर परीक्षण के बाद यह वाक्य अपडेट होगा]। `-ExecutionPolicy Bypass` केवल इसी प्रोसेस पर लागू होता है; किसी भी इंस्टॉलर की तरह पहले `scripts\kur.ps1` पढ़ लें।
   इंजन zip GitHub रिलीज़ v0.1.0 से आता है (19 नवंबर 2026 को प्रकाशित; इसका sha256 `kur.ps1` में तय है)। ऑफ़लाइन होने पर या अपने बिल्ड के साथ लोकल zip दें: `-MotorZip <path> -CudaZip <path>`। लोकल zip भी उसी तय sha256 से जाँची जाती है (उसके बगल की `.sha256` फ़ाइल अनदेखी होती है), इसलिए वह रिलीज़ वाली zip ही होनी चाहिए; अपने बिल्ड के लिए पहले `VT_MOTOR_SHA256` / `VT_CUDA_SHA256` में उसका sha256 सेट करें। गलत sha256 पर exit 1 के साथ रुक जाता है। केवल `.exe`/`.dll` फ़ाइलें `engine\bin` में जाती हैं; लाइसेंस और README `engine\lisanslar\<zip name>\` में जाते हैं। [आज़माया: रिलीज़ से पहले dist zip के साथ: साथ वाली `.sha256` और स्व-संदर्भी चेतावनी, बाइनरी और DLL अपनी जगह रखी गईं, `sd-cli --help` चला; इंस्टॉल हुई बाइनरी के sha मेल खाए (`c5cebe78...`, `e5d3d329...`); `kur.ps1` का मॉडल चरण और 5-फ़्रेम जाँच असली GPU पर अभी नहीं चलाई गई]
   **मॉडल लाइसेंस:** मॉडल चरण से पहले इंस्टॉलर लाइसेंस का सार दिखाता है (`docs/LISANS_KABUL.txt`, पूरा पाठ `docs/LISANS_UYARISI.md`: MiniMax H3 Community License, क्षेत्र-सीमाएँ जो बनाए गए वीडियो पर भी लागू होती हैं, व्यावसायिक और AI-लेबल नियम) और आपसे स्वीकार करने को कहता है (`E` = हाँ)। पहले इसे पढ़ें। बिना निगरानी के चलाने के लिए आप `-LisansKabul E` दे सकते हैं, जिसका मतलब है कि आपने इसे खुद पढ़ा और स्वीकार किया है; किसी और की ओर से इसे न जोड़ें। (AI एजेंट: `AGENTS.md` का पालन करें; उपयोगकर्ता की सहमति के बिना कभी E टाइप न करें।) स्वीकृति के बिना `kur.ps1` exit code 2 के साथ रुक जाता है और कोई मॉडल डाउनलोड नहीं करता।
3. **आपका पहला वीडियो (56 फ़्रेम, हमारे GTX 1050 Ti पर लगभग 11 मिनट** [मापा गया: 641 सेकंड, रन R0, `docs/OLCUMLER.md`; अन्य कार्ड नहीं मापे गए]**)**: जब इंस्टॉलर `HAZIR / READY` छापे, तब यह चलाएँ
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (शॉर्टकट: प्रॉम्प्ट की टेक्स्ट फ़ाइल को `uret.cmd` पर खींचकर छोड़ें, या `uret.cmd docs\ornek_istem_R0.txt` चलाएँ: वही 56 फ़्रेम का रन)। वीडियो `runs\` में है। फिर अपना प्रॉम्प्ट एक टेक्स्ट फ़ाइल में लिखें (अंग्रेज़ी में एक अनुच्छेद, वैकल्पिक `audio:` वाक्य) और हमारी समर्थित सबसे लंबी क्लिप चलाएँ (डिफ़ॉल्ट, लगभग 57 मिनट [मापा गया: रन U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   `-Kare` 17k+5 ग्रिड का पालन करता है (56, 73, ... 192, 209); डिफ़ॉल्ट 209 (8.7 सेकंड) है, जो हमारी सबसे लंबी कवर की गई लंबाई है। VAE अलग प्रोसेस में चलता है, कभी टाइल नहीं होता [रिलीज़ बाइनरी के साथ `uret.ps1` के ज़रिए असली इंजन रन, अलग-प्रोसेस VAE, रन U209 में पास हुआ]।

   प्रॉम्प्ट लिखने की मार्गदर्शिका: [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (एक लगातार शॉट का पैटर्न, बराबर समय-खंड, दो पूरे उदाहरण)।

| आवश्यकता | मान |
|---|---|
| OS | Windows 10/11, 64-bit |
| GPU | NVIDIA, 4 GB या अधिक; केवल GTX 1050 Ti (sm_61) पर परखा गया; बहुत कम मार्जिन (209 फ़्रेम पर 3777/4096 MiB): व्यस्त स्क्रीन या ब्राउज़र रन बिगाड़ सकता है; कोई और 4 GB कार्ड नहीं आज़माया गया |
| RAM | 16 GB (शिखर लगभग 11 GB; दूसरे प्रोग्राम बंद करें) |
| डिस्क | कम से कम 32 GiB खाली (40 GiB या अधिक अनुशंसित: 32 से 40 के बीच इंस्टॉलर चेतावनी छापता है, `[VT-W-DISK-PAY]` [मापा गया: नकली डिस्क के साथ `-Kuru` रन]), मॉडल SSD पर (NVMe बेहतर) |
| डाउनलोड | इंजन zip 36.8 MB + CUDA runtime zip 567.5 MB [मापा गया] + मॉडल 31,473,112,040 बाइट (लगभग 29.3 GiB) [पढ़ा गया: आकार `scripts/modeller.json` में]; कुल लगभग 30 GiB |
| मॉडल | शामिल नहीं; इंस्टॉलर MiniMax लाइसेंस के तहत लाता है (नीचे चेतावनी देखें)। मॉडल (29.3 GiB, `scripts/modeller.json` में 31,473,112,040 बाइट) इस रिपॉज़िटरी या रिलीज़ में नहीं हैं: GitHub की फ़ाइल/रिलीज़ आकार-सीमाएँ लागू हैं, और `kur.ps1` उन्हें आधिकारिक स्रोत से sha256 सत्यापन के साथ डाउनलोड करता है। |

`kur.ps1` के exit code: 0 READY, 1 त्रुटि, 2 उपयोगकर्ता का इनपुट चाहिए (लाइसेंस, या अभी रिलीज़/zip नहीं), 3 हार्डवेयर या डिस्क अपर्याप्त, 4 रोका गया (DUR फ़ाइल)। `uret.ps1` किसी रन को तभी स्वीकार करता है जब `.avi` फ़ाइल मौजूद हो, फ़्रेम संख्या सही हो और लॉग साफ़ हों [मापा गया: रिलीज़ बाइनरी पर `uret.ps1` के ज़रिए एक असली रन, रन U209, 209 फ़्रेम, गेट पास]। `uret.ps1` के exit code: 0 DONE (गुणवत्ता गेट पास), 1 त्रुटि या अमान्य आउटपुट (ऑडियो स्ट्रीम के बिना वीडियो सहित), 2 रोका गया (DUR फ़ाइल), 5 `KAPI RED` (गुणवत्ता गेट विफल: क्लिप स्वीकार नहीं, निर्णय आपका), 6 गेट चल नहीं सका (क्लिप स्वीकार नहीं)। विवरण AGENTS.md में। [मापा गया: नकली इंजन और नकली गेट वाले परिदृश्यों में exit code 0, 1 (मूक वीडियो), 5 और 6; असली इंजन: रन U209 में exit 0]

### समस्या निवारण (विवरण: `docs/SIK_HATALAR.md`)
हमारी स्क्रिप्टों की त्रुटि पंक्तियों में एक स्थिर कोड होता है, जैसे `HATA: [VT-E-DLL] ...` या `UYARI: [VT-W-DISK-PAY] ...`। कोड को [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) (एंकर का उदाहरण `#vt-e-dll`) या `docs/hata_imzalari.json` में खोजें, और कोड को अपने issue में लिखें। नीचे की तालिका का पहला स्तंभ जैसा छपता है वैसा ही रहता है (कोड और लॉग पाठ का अनुवाद न करें)।

| आप क्या देखते हैं | इसका मतलब और क्या करें |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | `sd-cli.exe` हाथ से न चलाएँ; `scripts\kur.ps1` चलाएँ, जो CUDA DLL सही जगह रखता है। |
| `blocks.0` पर `failed during weight preparation` (#1, #3, #5) | मेमोरी गेट पर VRAM पर्याप्त नहीं: 17k+5 ग्रिड पर कम फ़्रेम संख्या चुनें, दूसरे GPU प्रोग्राम बंद करें, साथ आए flag न बदलें। |
| `retrying with temporal tiling` (#6) | VAE tiling पर लौट गया; गुणवत्ता की दृष्टि से आउटपुट अमान्य है। दोबारा चलाएँ। |
| रन समय-सीमा पर खत्म, वीडियो नहीं (#7) | लंबी क्लिप के लिए `-TavanDk` बढ़ाएँ (डिफ़ॉल्ट समय-सीमा: 209 फ़्रेम के लिए 80 मिनट, `uret.ps1` तय करता है; हमारे 209-फ़्रेम रन में 57 मिनट लगे [मापा गया: रन U209])। |
| Exit code खाली पर "finished" (#14) | रैपर ने exit code बहुत जल्दी पढ़ लिया; दोबारा चलाएँ और जाँचें कि वीडियो फ़ाइल मौजूद है। |
| सिस्टम धीमा, swapping (#18) | इंजन लगभग 10-11 GB RAM लेता है; ब्राउज़र और दूसरे प्रोग्राम बंद करें। |
| sha256 मेल नहीं खाता / डाउनलोड विफल | आमतौर पर डाउनलोड बीच में टूटा है: वही कमांड फिर चलाएँ, सत्यापित फ़ाइलें छोड़ दी जाती हैं। |

**अटक गए हैं या जिज्ञासा है?** [`SUPPORT.md`](SUPPORT.md) (कहाँ पूछें; उत्तर का समय लक्ष्य है, वचन नहीं) · [`PRIVACY.md`](PRIVACY.md) (कोई टेलीमेट्री नहीं; नेटवर्क केवल इंजन और मॉडल डाउनलोड करने के लिए, सूचीबद्ध होस्ट से उपयोग होता है) · [`SECURITY.md`](SECURITY.md) (निजी रिपोर्ट) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (5 चरणों में पहला pull request; दस्तावेज़ और स्क्रिप्ट के लिए GPU ज़रूरी नहीं)।

### v0.1.1 में नया: और विकल्प (विवरण: `AGENTS.md`, `docs/SIK_HATALAR.md` 19-23)
इन विकल्पों के बिना 4 GB कार्ड पर कुछ नहीं बदलता (हमारे संदर्भ के मुकाबले 56-फ़्रेम बाइट जाँच v0.1.1 के साथ फिर से पास हुई [मापा गया])। क्या चलेगा, यह देखने के लिए किसी भी कमांड में `-Kuru` जोड़ें।
- `-EndImg`: आखिरी फ़्रेम भी दें (पहला और आखिरी फ़्रेम, "FLF"); 8 GB से कम वाले कार्ड पर सीमा 175 फ़्रेम (4 GB पर 192 नहीं समाए), 8 GB या उससे बड़े कार्ड पर 192। हमारे GTX 1050 Ti पर यह हमेशा दो प्रोसेस में चलता है: 56 फ़्रेम 1040 सेकंड, 175 फ़्रेम 2887 सेकंड (48 मिनट), दोनों ने गेट पास किया [मापा गया]। प्रॉम्प्ट के सुझाव: `docs/ISTEM_YAZIMI.md`।
- `-W` / `-H`: दूसरे आकार, जैसे वर्टिकल 384x640; 32 के गुणज, क्षेत्रफल कम से कम 640x384 (इससे छोटा कभी नहीं)। 4 GB पर परखा नहीं गया; 8 GB से कम वाले कार्ड पर हमारे मापे गए सबसे बड़े काम से बड़े आकार अस्वीकार कर दिए जाते हैं। गुणवत्ता गेट की सीमाएँ 640x384 पर कैलिब्रेट की गई हैं।
- `-TekAsama`: दो प्रोसेस की जगह एक प्रोसेस, केवल बड़े कार्ड के लिए; यह कभी अपने-आप चालू नहीं होता।
- नए GPU (compute capability 7.0+, जैसे RTX 20/30/40): अगर आपने खुद सेट नहीं किया है, तो `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` अपने-आप सेट हो जाता है; इससे रिपोर्ट करने वाले के RTX 4070 Ti पर 141 या उससे ज़्यादा फ़्रेम पर पूरी तरह काला वीडियो आने की समस्या ठीक हुई [उपयोगकर्ता ने बताया, issue #1]। Python + OpenCV न होने पर `uret.ps1` अब GPU काम से पहले exit 6 के साथ रुक जाता है (कोई वीडियो नहीं बनता, कोई भ्रामक RED नहीं)।
- इन बदलावों की वजह बनी RTX 4070 Ti रिपोर्ट के लिए @SinanC73 का धन्यवाद ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1))।

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

## वैकल्पिक गति प्रोफ़ाइल (स्पीड पैक; डिफ़ॉल्ट रूप से बंद)
नीचे दिए गए किसी भी बदलाव से डिफ़ॉल्ट रन नहीं बदलता (640x384, 209 फ़्रेम, हमारे कार्ड पर 3414 s)। ये उसके आगे के तीन मापे हुए सेल हैं, हर एक `uret.ps1` का एक नामित प्रोफ़ाइल है; इन्हें स्पीड-पैक इंजन चाहिए (रिलीज़ इंजन के साथ पैच 0021, 0023, 0024, सभी डिफ़ॉल्ट रूप से बंद: `docs/YAMALAR.md`)। इसे `scripts\kur.ps1 -HizPaketi` से इंस्टॉल करें (लोकल zip `-MotorZip` के साथ चलता है), फिर `-Profil <name>` जोड़ें; `-Kuru` छापता है कि क्या चलेगा। स्पीड पैक v0.1.4 रिलीज़ के साथ प्रकाशित होगा।

| प्रोफ़ाइल | आकार, लंबाई | GTX 1050 Ti 4 GB पर कुल समय | स्थिति |
|---|---|---|---|
| (कोई नहीं, डिफ़ॉल्ट) | 640x384, अधिकतम 209 फ़्रेम (8.7 s) | 209 फ़्रेम: 3414 s | सत्यापित, अपरिवर्तित |
| `yuksek832` | 832x480, 141 फ़्रेम (5.9 s) | लगभग 55-56 मिनट | उपयोग योग्य, दो प्रॉम्प्ट [मापा गया] |
| `yuksek832 -Kare 124` | 832x480, 124 फ़्रेम (5.2 s) | लगभग 45-46 मिनट, किसी स्पीड फ़्लैग की ज़रूरत नहीं | उपयोग योग्य, दो प्रॉम्प्ट [मापा गया] |
| `yuksek896` | 896x512, 124 फ़्रेम (5.2 s) | लगभग 56-57.5 मिनट | उपयोग योग्य, दो प्रॉम्प्ट [मापा गया] |
| `uzun260` | 640x384, 260 फ़्रेम (10.8 s) | जल्दी निकास के बिना 78 मिनट मापे गए; उसके साथ लगभग 71-72 मिनट [अनुमान: `uret.ps1` के ज़रिए शुरू से अंत तक नहीं मापा गया] | सशर्त और प्रायोगिक |

- **संकरा मार्जिन:** 832x480 x 141 पर मेमोरी गेट एक अंक के MB जितना ही मार्जिन छोड़ता है (दोनों पूरे रन में 5.7 और 6.8 MB)। दो लंबे प्रॉम्प्ट (1520 और 2041 अक्षर) केवल चरण 1 और चरण 2 के एक हिस्से के लिए गेट पढ़कर जाँचे गए, पूरे नहीं चलाए गए: मार्जिन 10.9 और 4.0 MB। कार्ड की मेमोरी रोकने वाली कोई भी दूसरी प्रक्रिया (ब्राउज़र, दूसरा डिस्प्ले) इसे विफल कर सकती है; तब `-Kare 124` या डिफ़ॉल्ट आकार इस्तेमाल करें [मापा गया, GTX 1050 Ti 4 GB]।
- **`uzun260` सशर्त है:** मेमोरी सीमा बहुत संकरी है (VRAM शिखर 4096 MiB में से 3903), साझा मेमोरी का उपयोग 45 और 61 MiB (सीमा 68) बढ़ा, और बाइट-समानता के लिए फ़्लैग-रहित संदर्भ मौजूद नहीं है, इसलिए इसे सामान्य सुविधा के रूप में नहीं दिया जाता। पैच 0023 केवल इसी एक सेल के लिए स्वीकार किया गया है।
- **नहीं दिया जाता:** 832x480 पर 158 फ़्रेम शामिल पैचों के साथ नहीं समाते (चरण 2 के गेट पर लगभग 280 MB कम पड़ते हैं); 175 फ़्रेम की जाँच केवल गेट पढ़कर हुई (पहले ब्लॉक में लगभग 275 MB कम पड़े, पूरा रन नहीं हुआ)। प्रोफ़ाइल केवल 141 फ़्रेम देती है। अन्य आकार और फ़्रेम संख्याएँ `-Profil` अस्वीकार कर देता है (डिफ़ॉल्ट रास्ता इस्तेमाल करें)।
- डिफ़ॉल्ट गुणवत्ता अछूती है: 6 चरण, cfg 1, बिना टाइल वाला VAE, 17k+5 फ़्रेम। जहाँ फ़्लैग चालू हैं, वहाँ उन आकारों पर जिनमें फ़्लैग-रहित रन समाता है, आउटपुट को फ़्लैग-रहित वीडियो से बाइट-दर-बाइट मिलाया गया (`docs/YAMALAR.md`); 832x480 x 141 और 896x512 x 124 पर फ़्लैग-रहित रन नहीं समाता, इसलिए वहाँ समानता सीधी तुलना पर नहीं बल्कि सबसे नज़दीकी सेलों पर टिकी है [मापा गया, पढ़ा गया]।
- दो-चरणीय रन का चरण 1 अब लेटेंट फ़ाइल पूरी होते ही समाप्त हो जाता है (`VT_ERKEN_CIKIS=0` इसे बंद करता है)।

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

## यह क्या है
stable-diffusion.cpp के लिए छोटे मेमोरी/शेड्यूलिंग पैच का एक समूह, साथ में चलाने की विधि, जाँचें और माप, जिनसे MiniMax H3 (33B DiT; हम HyperFlow Flash 13.7B Q4_K_M GGUF चलाते हैं; 32B Qwen3-VL टेक्स्ट एन्कोडर अलग है) 4 GB के Pascal GPU (GTX 1050 Ti, 16 GB सिस्टम RAM) पर चलता है।
- एक-पास की वे लंबाइयाँ जो हमने सचमुच बनाईं और अपने गुणवत्ता गेट पार कीं: 640x384, 24 fps पर 56, 141, 158, 175, 192, 209 फ़्रेम (209 फ़्रेम = 8.7 सेकंड), H3 के अपने बनाए ऑडियो के साथ [मापा गया: 209 फ़्रेम, रिलीज़ बाइनरी के साथ `uret.ps1` के ज़रिए, रन U209; latent डेवलपमेंट-बिल्ड के रन से बाइट-दर-बाइट समान; वीडियो में फ़्रेम और ऑडियो समान, फ़ाइल का sha कंटेनर के कारण अलग; प्रमाण लेखकों के पास सुरक्षित हैं, इस रिपॉज़िटरी में नहीं]। 209 वह सबसे लंबी लंबाई है जिसे हमने देखा और सहज पाया [उपयोगकर्ता ने बताया, 2026-11-19, वीडियो पूरा देखा गया; फ़ाइल: F209V2 आउटपुट, 8.708 सेकंड]।
- **बाइट-समानता का दावा, ईमानदार दायरे के साथ:** आउटपुट की बाइट-समानता बिना पैच वाले संदर्भ से केवल 56 और 141 फ़्रेम के लिए जाँची गई। 158/175/192/209 फ़्रेम के लिए हमने वही flag और वही बाइनरी-श्रृंखला इस्तेमाल की; कोई सीधा बाइट संदर्भ नहीं है (बिना पैच वाला बिल्ड इस GPU पर वे लंबाइयाँ चला ही नहीं सकता)।
- गुणवत्ता सेटिंग कभी घटाई नहीं जातीं: वही मॉडल/क्वांटाइज़ेशन, 6 steps, cfg 1, 640x384, वही seed, बिना tiling वाला VAE।
- हम पहले होने का दावा नहीं करते: हमने खोजा और 4 GB पर इसका कोई बाहरी उदाहरण नहीं मिला, जो इस बात का प्रमाण नहीं कि कोई है ही नहीं।

## संरचना
- `patches/` एक तय किए गए stable-diffusion.cpp commit के लिए पैच (वहाँ के नोट देखें)
- `scripts/` बिल्ड, रन, अलग-प्रोसेस VAE, गेट/संगति सहायक (`doku_norm.py`: नीचे स्केल का नोट देखें)
- `docs/KURULUM.md` हार्डवेयर, बिल्ड और रन के चरण (EN+TR)
- `docs/YAMALAR.md` पैच सूची, `docs/KANITLAR.md` प्रमाण, `docs/KAPILAR.md` गुणवत्ता गेट तालिका, `docs/OLCUMLER.md` माप, `docs/SIK_HATALAR.md` आम गलतियाँ, `docs/LISANS_UYARISI.md` लाइसेंस की पूरी मदें
- `scripts/` संक्षिप्त सूची: `hiz_kos3.ps1` रन रैपर (`-Kuru` सटीक कमांड छापता है), `uretim_kapi.ps1` गुणवत्ता गेट, `dikis_denetim.py` जोड़ की जाँच, `doku_norm.py` बनावट-सामान्यीकृत noise, `bayt_kiyas.py` बाइट तुलना, `derleme_sablonu.ps1` बिल्ड टेम्पलेट (केवल Visual Studio का telemetry सहायक `vctip.exe` रोकता है जो अपने बिल्ड के शुरू होने के बाद शुरू हुआ, जो अन्यथा बिल्ड प्रोसेस को कई मिनट अटकाए रखता है; बाकी `vctip.exe` प्रोसेस छोड़ दिए जाते हैं)

## गुणवत्ता गेट (परिणाम कैसे स्वीकार होता है)

यह गेट गति की संगति (वस्तु के आकार या स्थिति की छलांग) नहीं जाँचता: स्वीकार करने से पहले पूरा वीडियो देखें।
1. फ़्रेम संख्या और ऑडियो मौजूद; लॉग में कोई memory fallback या ALLOC_FAILED पंक्ति नहीं।
2. कच्चा noise गेट: median-filter अवशेष <= 1.5 (0-255 स्केल)।
3. बनावट-सामान्यीकृत noise, `scripts/doku_norm.py` (इस रिपॉज़िटरी का संस्करण): N = median अवशेष / Sobel बनावट, हर 6वाँ फ़्रेम। **स्केल नोट:** इस संस्करण में 10 मापी गई क्लिप का N = 0.034-0.052 आता है (तालिका `docs/KAPILAR.md` में; F192/F209V2 की आख़िरी चौथाई 0.062 तक पहुँचती है) और अतिरिक्त गेट की सीमा N <= 0.065 है। दूसरे कार्यान्वयन ने उन्हीं क्लिप पर 0.028-0.036 मापा, इसलिए संस्करणों के बीच सीमाएँ आपस में बदली नहीं जा सकतीं। बहुत महीन बनावट (घास की कतारें) पर साफ़ N 0.075 था, इसलिए सीमा दृश्य-परिवार के अनुसार है। मज़बूत उच्च-आवृत्ति अनुमानक (sigma-HH <= 1.5; साफ़ 0.74-1.19, s=2 का जोड़ा गया noise 2.2-3.0 देता है) अनुशंसित अतिरिक्त गेट है।

दायरा: VideoTurko केवल एक ही पास (अधिकतम 209 फ़्रेम, लगभग 8.7 सेकंड) के बारे में है। हमारे अपने जोड़ने के परीक्षण में दिखने वाले जोड़ मिले (दृश्य साफ़ तरीके से आगे नहीं बढ़ता), इसलिए लंबी फ़िल्में हमारे सत्यापन का हिस्सा नहीं हैं। जोड़ने के लिए समुदाय की गाइड `docs/KLIP_ZINCIRI.md` और केवल CPU वाला हमारा सहायक `scripts/zincir.py` है (`plan`, `son-kare`, `bagla`; यह इंजन को कभी शुरू नहीं करता); जोड़ी गई फ़िल्मों की गुणवत्ता हमने नहीं मापी [आज़माया नहीं], इसलिए हर जोड़ को आँख से और `scripts/dikis_denetim.py` से जाँचें।
आपकी सेटिंग आपकी अपनी हैं: 209 फ़्रेम 4 GB कार्ड पर हमारा परखा हुआ डिफ़ॉल्ट है, कोई सीमा नहीं जिसे आपको मानना ही हो। 17k+5 ग्रिड पर कोई भी फ़्रेम संख्या चुनें (56, 73, ... 192, 209; `docs/KURULUM.md` देखें), prompt, seed, रेज़ोल्यूशन या कोई भी flag अपनी इच्छा से बदलें। छोटी क्लिप को कम मेमोरी और समय चाहिए; बड़े GPU पर शायद अधिक समाए।

## मॉडल लाइसेंस चेतावनी
**VideoTurko में केवल पैच और स्क्रिप्ट हैं (MIT); जो भी मॉडल और उसके आउटपुट का उपयोग करता है, MiniMax लाइसेंस की ज़िम्मेदारी स्वयं उसी की है।** यह कानूनी सलाह नहीं है। नीचे MiniMax H3 Community License (August 2, 2026) की धाराएँ उनके क्रमांकों के साथ संक्षेप में दी गई हैं; बाध्यकारी स्वयं लाइसेंस है: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

इस रिपॉज़िटरी का MIT लाइसेंस मॉडल वेट को कवर नहीं करता; देखें [`NOTICE`](NOTICE)। इस रिपॉज़िटरी में कोई मॉडल वेट नहीं हैं (न MiniMax H3, न HyperFlow-H3-Flash GGUF, न VAE फ़ाइलें)। यह प्रोजेक्ट MiniMax से संबद्ध नहीं है और न उसके द्वारा समर्थित है। व्यावसायिक उपयोग निषिद्ध नहीं है (यह गैर-व्यावसायिक लाइसेंस नहीं है); शर्तें नीचे हैं।

**क्षेत्र (Applicable Territory)**
- **Preamble, I.3, I.5:** पूरी दुनिया, यूरोपीय संघ, यूनाइटेड किंगडम, कोरिया गणराज्य और संयुक्त राज्य अमेरिका को छोड़कर। मॉडल का उपयोग करना लाइसेंस स्वीकार करना माना जाता है।
- **II:** रॉयल्टी-मुक्त, अहस्तांतरणीय, सीमित लाइसेंस, उपयोग करने, पुनरुत्पादन करने, वितरित करने, व्युत्पन्न बनाने और संशोधित करने के लिए, केवल क्षेत्र के भीतर और समझौते तथा Exhibit A के अनुपालन में। बाहर रखे गए क्षेत्रों के लोग MiniMax से अलग लाइसेंस माँग सकते हैं।
- **V.4:** क्षेत्र के बाहर मॉडल, उसके व्युत्पन्नों और आउटपुट (बनाए गए वीडियो/ऑडियो) का उपयोग, पुनरुत्पादन, संशोधन, वितरण या प्रदर्शन अधिकृत नहीं है। **इसलिए बनाए गए वीडियो को EU/UK/दक्षिण कोरिया/US में प्रकाशित या दिखाना लाइसेंस के बाहर है।**
- **Exhibit A-1:** क्षेत्र के बाहर उपयोग Acceptable Use Policy का उल्लंघन है।

**वितरण (III)** (यह रिपॉज़िटरी मॉडल वितरित नहीं करती; अगर आप करें तो)
- **III.1:** हर प्राप्तकर्ता को लाइसेंस की एक प्रति दें। **III.2:** संशोधित फ़ाइलों पर स्पष्ट सूचना लगाएँ।
- **III.3:** प्रोत्साहित (अनिवार्य नहीं): "Powered by MiniMax H3" सूचना, बनाई गई फ़ाइलों पर AI-निर्मित होने का पहचानकर्ता, सार्वजनिक लेख।
- **III.4:** वितरण के साथ NOTICE फ़ाइल अनिवार्य रूप से होनी चाहिए, जिसमें यह हो: "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12:** किसी भी सार्वजनिक माध्यम पर सामग्री को यह स्पष्ट बताए बिना प्रकाशित करना कि वह मशीन से बनी है, निषिद्ध है: AI से बने वीडियो प्रकाशित करते समय उन पर लेबल लगाएँ (पूरी सूची: `docs/LISANS_UYARISI.md`)।
- **III (अंतिम अनुच्छेद):** आप अपने संशोधनों पर अपना कॉपीराइट जोड़ सकते हैं, पर उपयोग/वितरण पर कोई अतिरिक्त या अलग शर्तें नहीं थोप सकते; क्षेत्र के नियम फिर भी लागू रहते हैं।

**व्यावसायिक शर्तें (IV)**
- **IV.1:** अगर आपके व्यावसायिक उत्पाद/सेवाएँ सालाना USD 20 million (या समकक्ष) से अधिक राजस्व पैदा करती हैं, तो api@minimax.io से पहले लिखित अनुमति लें (विषय "MiniMax H3 licensing - authorization request")।
- **IV.2:** मॉडल का उपयोग करने वाले व्यावसायिक उत्पाद/सेवा के UI में "MiniMax H3" प्रमुखता से दिखना चाहिए।

**उपयोग प्रतिबंध (V)**
- **V.1:** लागू कानून (व्यापार अनुपालन सहित) और Exhibit A का पालन करें। **V.2:** जिन्हें भी आप पहुँच दें, उन्हें ऐसी शर्तों से बाँधें जो कम से कम इन प्रतिबंधों जितनी सुरक्षात्मक हों, और उन्हें सूचित करें।
- **V.3:** आप मॉडल या उसके आउटपुट का उपयोग किसी अन्य AI मॉडल को बेहतर बनाने में नहीं कर सकते (MiniMax H3 और उसके व्युत्पन्नों के अलावा)। (I.11: distillation और सिंथेटिक आउटपुट पर प्रशिक्षण किसी मॉडल को "व्युत्पन्न" बनाते हैं; आउटपुट स्वयं व्युत्पन्न नहीं हैं।)
- **V.5:** अगर आप तीसरे पक्षों को ऐसा उत्पाद/सेवा/होस्टेड सेवा देते हैं जो मॉडल से आउटपुट बनाती है: संचालन से पहले और उसके दौरान उचित तकनीकी और संगठनात्मक सुरक्षा उपाय, रिपोर्टिंग तंत्र, त्वरित जाँच, और बार-बार उल्लंघन करने वालों को हटाना/अक्षम करना/निलंबित करना।

**ट्रेडमार्क और अधिकार (VI)**
- **VI.1:** आपके बनाए व्युत्पन्न कार्यों और मॉडल व्युत्पन्नों के मालिक आप हैं (MiniMax के अधिकारों के अधीन)। **VI.2:** MiniMax के नाम/चिह्न लाइसेंस में शामिल नहीं हैं (वर्णन और वितरण के लिए आवश्यक से अधिक); "MiniMax H3" चिह्न केवल III.3 के पालन के लिए, क्षेत्र के भीतर उपयोग हो सकता है; संबद्धता का आभास न दें।
- **VI.3:** अगर आप MiniMax या किसी पर यह आरोप लगाकर मुकदमा करते हैं कि सामग्री/आउटपुट आपके अधिकारों का उल्लंघन करते हैं, तो आपके सभी लाइसेंस उसी दिन समाप्त हो जाते हैं; आपके या दूसरों के उपयोग/वितरण से उठे तीसरे पक्ष के दावों के विरुद्ध आप MiniMax का बचाव करेंगे और उसकी क्षतिपूर्ति करेंगे।
- **VI.4:** MiniMax आउटपुट पर कोई अधिकार नहीं जताता; आउटपुट और उनके उपयोग की ज़िम्मेदारी आपकी और आपके उपयोगकर्ताओं की है।

**अस्वीकरण और समाप्ति (VII, VIII, IX)**
- **VII.1:** सहायता/अपडेट देने का कोई दायित्व नहीं। **VII.2:** मॉडल और आउटपुट "AS IS" दिए जाते हैं, कोई वारंटी नहीं; उपयुक्तता आप तय करते हैं और जोखिम आप उठाते हैं। **VII.3:** MiniMax और उसके सहयोगी किसी भी क्षति के लिए उत्तरदायी नहीं हैं (कानून जहाँ तक अनुमति दे)।
- **VIII.1:** स्वीकृति/पहुँच के साथ प्रभावी। **VIII.2:** उल्लंघन होने पर MiniMax समाप्त कर सकता है; आपको उपयोग/वितरण बंद करना, प्रतियाँ हटाना और प्राप्तकर्ताओं को सूचित करना होगा (VI.1, VI.3, VII, IX जारी रहते हैं)।
- **IX:** Hong Kong SAR का कानून; Hong Kong की अदालतों का विशेष क्षेत्राधिकार (UN CISG बाहर)।
- **अतिरिक्त नोट:** MiniMax H3 का एन्कोडर Qwen3-VL-32B (Apache 2.0) का उपयोग करता है।

**Acceptable Use Policy (Exhibit A)** (मॉडल, व्युत्पन्नों या आउटपुट का इनके लिए उपयोग न करें)
- A-1 क्षेत्र के बाहर उपयोग; A-2 कानून या तीसरे पक्ष की बौद्धिक संपदा का उल्लंघन; A-3 स्वयं को या दूसरों को हानि पहुँचाना; A-4 आउटपुट को हानि पहुँचाने के लिए दोबारा उपयोग/वितरित करना; A-5 सुरक्षा उपायों को दरकिनार करना; A-6 नाबालिगों का शोषण/उन्हें हानि; A-7 दूसरों को हानि पहुँचाने या चुनावों को प्रभावित करने के लिए सत्यापन-योग्य रूप से झूठी जानकारी; A-8 नकली ऑनलाइन जुड़ाव (नकली समीक्षाएँ आदि); A-9 मानहानि, अपमान, उत्पीड़न; A-10 malware; A-11 दूसरों को हानि पहुँचाने के लिए व्यक्तिगत डेटा; **A-12 किसी भी सार्वजनिक माध्यम (बॉट पोस्ट सहित) पर सामग्री को यह स्पष्ट और प्रमुखता से बताए बिना प्रकाशित करना कि वह मशीन से बनी है**; A-13 सहमति के बिना किसी का रूप धारण करना; A-14 महत्वपूर्ण क्षेत्रों (कानून प्रवर्तन, आप्रवासन, स्वास्थ्य, महत्वपूर्ण अवसंरचना, क्रेडिट, रोज़गार, आवास, शिक्षा, सामाजिक स्कोरिंग, बीमा आदि) में उच्च-जोखिम स्वचालित निर्णय; A-15 अन्य देशों/क्षेत्रों के सामाजिक, नैतिक मानकों का उल्लंघन; A-16 हिंसक उग्रवाद/आतंकवाद; A-17 संरक्षित विशेषताओं के आधार पर भेदभाव/हानि; A-18 कमज़ोर आबादी का शोषण; **A-19 सैन्य उद्देश्य**; A-20 बिना अनुमति/लाइसेंस के पेशेवर गतिविधि (वित्तीय, कानूनी, चिकित्सीय आदि)।
- नोट: यह सरल भाषा में सार है; संदेह की स्थिति में अंग्रेज़ी लाइसेंस पाठ मान्य है।

## प्रमाण लेबल

सभी दस्तावेज़ों के लिए एक ही समूह (पुरानी वर्तनी कोष्ठक में):
- **[मापा गया]** (TR: ölçtüm, olctum): इस प्रोजेक्ट में चलाया गया, प्रमाण का पथ मौजूद है।
- **[पढ़ा गया]** (TR: okudum yol, okudum): स्रोत या स्क्रिप्ट पढ़ी गई, चलाई नहीं गई।
- **[डिज़ाइन]** (TR: tasarım, tasarim): डिज़ाइन किया गया, असली रन में अभी देखा नहीं गया।
- **[अनुमान]** (TR: tahmin): सत्यापित नहीं।
- **[आज़माया नहीं]** (TR: denenmedi): कभी चलाया नहीं गया।
- **[उपयोगकर्ता ने बताया]** (TR: kullanıcı bildirdi): उपयोगकर्ता ने तारीख के साथ बताया; स्वतंत्र रूप से मापा नहीं गया।
- **[गणना]** (TR: hesap; पुरानी वर्तनी: calculated, hesap): मापे गए इनपुट से निकाली गई संख्या, स्वयं मापी नहीं गई; निकालने का तरीका उसके पास लिखा है। पुराने पाठ में [proposal] / [öneri] = [अनुमान]।

कोष्ठक में इस्तेमाल हुए रन के नाम (हमारे अपने रन के नाम, इस रिपॉज़िटरी की फ़ाइलें नहीं): U209 = रिलीज़ बाइनरी के साथ `uret.ps1` के ज़रिए 209 फ़्रेम; B209 और B192 = 209 और 192 फ़्रेम पर image-to-video (`-InitImg`) रन; B56VT2 = रिलीज़ बाइनरी, 56 फ़्रेम, 56-फ़्रेम बाइट संदर्भ R0 से तुलना; F209b, F209V2, F209V2K = डेवलपमेंट बिल्ड पर 209-फ़्रेम रन (विवरण: `docs/OLCUMLER.md`)।

## ज्ञात सीमाएँ
- **बाइट प्रमाण** (खुद कैसे दोहराएँ: `docs/KANITLAR.md`, "R0 ve latent referansi nasil uretilir"; हमारे sm_61 कार्ड पर सत्यापित, दूसरे GPU पर बाइट-समान न भी हो सकता है [अनुमान]): हमारी पैच श्रृंखला के साथ (memory flag चालू) 56 फ़्रेम के रन ने sha256 `0979f156d548169b...` दिया, जो संदर्भ के समान है [मापा गया]; 141 फ़्रेम पर latent का sha256 `E5D028F8632BE4FE...` समान था (0013/0014 flag के साथ)। 158 से 209 फ़्रेम का कोई सीधा बाइट संदर्भ नहीं है; गेट-श्रृंखला ही प्रमाण है। संख्यात्मक गेट पास होना अच्छी क्लिप की गारंटी नहीं है: समय के साथ गति की संगति आँख से जाँची जाती है (`docs/KAPILAR.md` देखें)।
- **209 फ़्रेम, कौन-सा flag समूह:** 209-फ़्रेम की बाइट-श्रृंखला का प्रमाण डेवलपमेंट बिल्ड पर F209V2 flag समूह से लिया गया (block-tail flag नहीं, पैच 0019/0020 के बिना बना); `uret.ps1` 209 फ़्रेम के लिए यही विधि इस्तेमाल करता है [पढ़ा गया: स्क्रिप्ट; `uret.ps1` के ज़रिए असली इंजन रन रन U209 में पास हुआ]।
- हमारे द्वारा एक कार्ड (GTX 1050 Ti 4 GB) पर सत्यापित; अन्य कार्डों की बाहरी रिपोर्टें उनके लेबल सहित `docs/KART_PROFILLERI.md` में सूचीबद्ध हैं [उपयोगकर्ता ने बताया]।
- **कौन-सी बाइनरी मापी गई:** 141-फ़्रेम का latent और बाइट-श्रृंखला हमारे डेवलपमेंट बिल्ड से मापे गए। आप जो रिलीज़ बाइनरी डाउनलोड करते हैं वह नया बिल्ड है: उसका 56-फ़्रेम बाइट गेट पास हुआ (अगली मद) और `uret.ps1` के ज़रिए 209-फ़्रेम का रन गेट पास कर गया (रन U209, 3414 सेकंड, VRAM शिखर 3777 MiB) [मापा गया]; डेवलपमेंट-बिल्ड के 209 रन की तुलना में latent बाइट-दर-बाइट समान है; वीडियो में फ़्रेम (md5) और ऑडियो समान हैं, AVI फ़ाइल का sha256 कंटेनर के कारण अलग है [मापा गया] (`docs/OLCUMLER.md`, भाग 0 देखें)।
- **रिलीज़ बाइनरी, 56 फ़्रेम:** रिलीज़ बाइनरी (sd-cli `c5cebe78...`, stable-diffusion.dll `e5d3d329...`) ने R0 के साथ बाइट-समान 56-फ़्रेम परिणाम दिया (sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`; हर फ़्रेम का md5 और ऑडियो समान), सीधे डिफ़ॉल्ट flag के साथ चलाया (कोई `SD_*` वेरिएबल नहीं), exit code 0, 601 सेकंड [मापा गया: रन B56VT2, 2026-11-19; प्रमाण लेखकों के पास सुरक्षित हैं, इस रिपॉज़िटरी में नहीं]। दायरा: केवल हमारा sm_61 कार्ड और 56 फ़्रेम; यह clean-root इंस्टॉल परीक्षण नहीं है; 141-फ़्रेम latent और 209 श्रृंखला पुरानी बाइनरी से मापी गईं और इस बाइनरी से दोहराई नहीं गईं [आज़माया नहीं]। पहला प्रयास (B56VT, सहायक स्क्रिप्ट के ज़रिए) 58 सेकंड बाद चुपचाप खत्म हो गया, कारण अज्ञात [अनुमान: memory pressure]; दूसरे प्रयास ने `sd-cli` सीधे चलाया।
- इंस्टॉल और रन स्क्रिप्ट अभी खाली फ़ोल्डर से सत्यापित नहीं हुई हैं (clean-root परीक्षण बाकी है)।
- रोडमैप और अगले कदम: `ROADMAP.md`।

## स्थिति और सीमाएँ
- एक मशीन पर सत्यापित (GTX 1050 Ti 4 GB, 16 GB RAM, i7-7700HQ)। दूसरे 4 GB कार्ड और RAM आकार अलग हो सकते हैं।
- **डिफ़ॉल्ट 209 फ़्रेम (8.7 सेकंड):** हमारे गुणवत्ता गेट पास हुए (noise 1.08, रन F209V2K) [मापा गया: 209 फ़्रेम, रिलीज़ बाइनरी के साथ `uret.ps1` के ज़रिए, रन U209; latent डेवलपमेंट-बिल्ड के रन से बाइट-दर-बाइट समान; वीडियो में फ़्रेम और ऑडियो समान, फ़ाइल का sha कंटेनर के कारण अलग; प्रमाण लेखकों के पास सुरक्षित हैं, इस रिपॉज़िटरी में नहीं]। 209 फ़्रेम पर DiT का VRAM शिखर 4096 MiB में से 3777 MiB था (रन F209b और U209; पूरे कार्ड की `nvidia-smi` रीडिंग), बहुत कम मार्जिन: दूसरा GPU लोड (स्क्रीन, दूसरे ऐप) रन को `blocks.0` पर विफल कर सकता है; केवल GTX 1050 Ti पर परखा गया। उस रन के दौरान स्क्रीन की स्थिति दर्ज नहीं की गई; अगर आपकी स्क्रीन इसी कार्ड पर चलती है तो उपलब्ध VRAM कम होगी [अनुमान: Windows स्क्रीन लोड लगभग 100-300 MB]; ज़रूरत हो तो स्क्रीन को integrated GPU से जोड़ें [सलाह, परखी नहीं]। Sampling में 2730 सेकंड लगे (रन U209: steps 436-483 सेकंड) और अलग-प्रोसेस VAE decode में 173 सेकंड (ऑडियो decode सहित चरण 2 कुल 193 सेकंड) [मापा गया: U209 रिलीज़ बाइनरी; पुराने डेवलपमेंट रन: 2664 सेकंड और 174 सेकंड]। चरण 1 में इन-प्रोसेस VAE की मेमोरी खत्म हुई और वह temporal tiling पर लौट गया (320 सेकंड); वह आउटपुट फेंक दिया जाता है, वीडियो बिना tiling वाले चरण 2 से आता है। U209 में RAM शिखर मापा नहीं गया। 209 फ़्रेम से लंबी क्लिप इस रिलीज़ का हिस्सा नहीं हैं।
- **Image-to-video (`-InitImg`):** शुरुआती इमेज के साथ इस GPU पर सीमा 192 फ़्रेम (24 fps पर 8.0 सेकंड) है: 209 फ़्रेम नहीं समाए (block 0 पर लगभग 17.5 MB VRAM कम: ज़रूरत 2587 MB, उपलब्ध 2570 MB); 192 फ़्रेम `uret.ps1` के ज़रिए 3086 सेकंड में चले, VRAM शिखर 3783 MiB और गेट पास [मापा गया: रन B209 और B192, 2026-11-20, एक दृश्य; प्रमाण लेखकों के पास सुरक्षित हैं, इस रिपॉज़िटरी में नहीं]। दूसरे GPU पर नहीं आज़माया गया [आज़माया नहीं]।
- **खाली RAM मायने रखती है:** आपको लगभग 11 GB खाली RAM चाहिए (इंजन प्रोसेस लगभग 11 GB रखता है) [मापा गया]। बहुत कम खाली RAM होने पर प्रोसेस बिना किसी त्रुटि संदेश के मर सकता है [अनुमान: हमने इसे एक बार देखा, जब लगभग 300 MB RAM खाली थी और `sd-cli` लगभग 10 GB रखे था]। चलने के दौरान कोई और बड़ा प्रोग्राम न खोलें: 16 GB की मशीन पर केवल लगभग 0.3-0.5 GB खाली बचती है, और मेमोरी के दबाव में रन चुपचाप मर सकता है। शुरू करने से पहले ब्राउज़र, गेम और दूसरे बड़े प्रोग्राम बंद करें और खाली RAM जाँचें।
- **Clean-root परीक्षण बाकी है:** इंस्टॉल और रन स्क्रिप्ट अभी केवल इन निर्देशों से खाली फ़ोल्डर में सत्यापित नहीं हुई हैं; जब वह परीक्षण (संदर्भ से 56-फ़्रेम बाइट तुलना सहित) दर्ज होगा, यह भाग अपडेट होगा।
- यहाँ कोई बनाया हुआ वीडियो शामिल नहीं है।

<!-- i18n-source: README.md sha256:a26a5a878a5f -->
