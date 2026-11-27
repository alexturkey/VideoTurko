# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · ไทย · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

คำแปลอิงตาม README ภาษาอังกฤษฉบับนี้ หากคำแปลต่างออกไปหรือล้าหลัง ให้ถือข้อความภาษาอังกฤษเป็นหลัก โดยเฉพาะข้อความเรื่องสัญญาอนุญาตและความปลอดภัย ([`SECURITY.md`](SECURITY.md) และ [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) ดูแลเฉพาะภาษาอังกฤษและภาษาตุรกี)

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **ก่อนเริ่ม (สัญญาอนุญาต, ขอบเขตพื้นที่):** รีโพนี้ใช้สัญญาอนุญาต MIT และมีเฉพาะแพตช์และสคริปต์ โมเดล MiniMax H3 ที่ดาวน์โหลดอยู่ภายใต้ MiniMax H3 Community License ซึ่งขอบเขตพื้นที่ไม่รวมสหภาพยุโรป สหราชอาณาจักร เกาหลีใต้ และสหรัฐอเมริกา และห้ามใช้ แจกจ่าย หรือแสดงโมเดล ผลงานดัดแปลง **และผลลัพธ์ (วิดีโอที่คุณสร้าง)** ในพื้นที่เหล่านั้น (V.4) การใช้เชิงพาณิชย์ทำได้ภายใต้เงื่อนไขของสัญญาอนุญาต โปรดอ่าน [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) ก่อนติดตั้ง นี่ไม่ใช่คำแนะนำทางกฎหมาย

> **สรุปใน 30 วินาที:** การ์ดจอ 4 GB สามารถสร้างวิดีโอ MiniMax H3 ความยาว 209 frame (8.7 วินาที) ได้ในรอบเดียว ตรวจสอบแล้วบนเครื่องเดียว (GTX 1050 Ti 4 GB) ส่วนการติดตั้งแบบเต็มด้วย `kur.ps1` ในโฟลเดอร์ว่างยังไม่ได้ตรวจสอบตั้งแต่ต้นจนจบ [วัดจริง: 209 frame ด้วย release binary ผ่าน `uret.ps1` รอบรัน U209; latent เหมือนกับรอบรันของ development build ทุกไบต์; frame และเสียงในวิดีโอเหมือนกัน ส่วน sha ของไฟล์ต่างกันเพราะ container; หลักฐานผู้เขียนเก็บไว้เอง ไม่ได้อยู่ใน repo นี้]; เมื่อใช้ `-InitImg` (image-to-video) ได้สูงสุด 192 frame (8.0 วินาที) [วัดจริง: รอบรัน B192]; 209 frame ใช้เวลาประมาณ 57 นาที เพดานเวลาเริ่มต้นคือ 80 นาที [วัดจริง: รอบรัน U209]; 3 ขั้นตอนด้านล่างคือวิธีรัน

VideoTurko: แพตช์ด้านหน่วยความจำสำหรับ stable-diffusion.cpp พร้อมสูตรการรัน เพื่อรัน MiniMax H3 text-to-video บน GTX 1050 Ti 4 GB ได้สูงสุด 209 frame (8.7 วินาที) ในรอบเดียว; image-to-video (`-InitImg`) ได้สูงสุด 192 frame (8.0 วินาที) (209 frame ตรวจสอบด้วย byte chain; ตรงกับรอบรันที่ไม่ได้แพตช์ทุกไบต์ในการตรวจที่ 56 และ 141 frame)

## เริ่มต้นอย่างเร็ว (Windows, 3 ขั้นตอน)
**สถานะ: สคริปต์ติดตั้ง/รันด้านล่างกำลังปรับให้เสร็จ และการทดสอบ clean-root ยังค้างอยู่ จนกว่าการทดสอบนั้นจะผ่าน ยังไม่ยืนยันว่าสิ่งใดในที่นี้ใช้งานได้ (ดู "สถานะและข้อจำกัด")**

1. **ดาวน์โหลด** repository นี้ (ปุ่ม **Code** สีเขียว แล้วเลือก **Download ZIP**) และแตกไฟล์ไปไว้ในโฟลเดอร์ที่พาธสั้น ๆ เช่น `C:\vt`
2. **ติดตั้ง: ดับเบิลคลิก `kur.cmd`** (หน้าต่างสีดำจะเปิดและแสดงแต่ละขั้นตอน การปิดหน้าต่างจะหยุดการติดตั้ง และการรันอีกครั้งจะทำต่อจากจุดที่หยุด: ไฟล์โมเดลที่ดาวน์โหลดค้างไว้ครึ่งหนึ่งจะถูกดาวน์โหลดต่อ [อ่านแล้ว: สคริปต์ดาวน์โหลดเก็บไฟล์ `.part` และทำต่อจากไฟล์นั้น ยังไม่ได้วัดการดาวน์โหลดต่อเต็ม 29 GiB]) หาก Windows เตือนเรื่องไฟล์ที่ดาวน์โหลดมา ให้ใช้คำสั่ง PowerShell ด้านล่างแทน [คำแนะนำ ยังไม่ได้ทดสอบกับ ZIP ที่ดาวน์โหลดมา] ชอบบรรทัดคำสั่งมากกว่า? เปิด PowerShell ในโฟลเดอร์นั้น (พิมพ์ `powershell` ในแถบที่อยู่ของ Explorer) แล้วรันการติดตั้งเดียวกัน:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   โฟลเดอร์ราก (root) ของการติดตั้งคือโฟลเดอร์ที่แตกไฟล์ไว้ (engine อยู่ใน `engine\bin`, โมเดลอยู่ใน `model`); หากต้องการใช้ที่อื่น ให้ตั้งตัวแปรสภาพแวดล้อม `VT_ROOT` ก่อน สคริปต์จะตรวจสอบ GPU, driver, RAM และดิสก์ ดึง engine และโมเดล (ไฟล์ zip ของ engine และไฟล์โมเดลที่เพิ่งดาวน์โหลดจะถูกตรวจ sha256; ไฟล์โมเดลที่มีอยู่แล้วและขนาดถูกต้องจะตรวจเฉพาะขนาด ส่วน `scripts\modelleri_indir.ps1 -Dogrula` จะรันการตรวจ sha256 แบบเต็ม) รันการตรวจจริงสั้น ๆ หนึ่งครั้ง และพิมพ์ READY ก็ต่อเมื่อการตรวจนั้นผ่านเท่านั้น [ออกแบบ: `kur.ps1` ยังไม่เคยรันครบทั้งหมดในโฟลเดอร์สะอาด; ประโยคนี้จะอัปเดตหลังการทดสอบโฟลเดอร์สะอาด] `-ExecutionPolicy Bypass` มีผลกับ process เดียวนี้เท่านั้น; เช่นเดียวกับตัวติดตั้งทั่วไป ควรอ่าน `scripts\kur.ps1` ก่อน
   zip ของ engine ดาวน์โหลดจาก GitHub release v0.1.0 (เผยแพร่เมื่อ 19 พฤศจิกายน 2026; sha256 ของไฟล์ถูกกำหนดตายตัวไว้ใน `kur.ps1`) หากออฟไลน์หรือใช้ build ของคุณเอง ให้ระบุ zip ในเครื่อง: `-MotorZip <path> -CudaZip <path>` zip ในเครื่องก็ถูกตรวจด้วย sha256 ที่กำหนดตายตัวค่าเดียวกัน (ไฟล์ `.sha256` ที่อยู่ข้าง zip จะถูกเพิกเฉย) ดังนั้นต้องเป็น zip ของ release; สำหรับ build ของคุณเอง ให้ตั้ง `VT_MOTOR_SHA256` / `VT_CUDA_SHA256` เป็น sha256 ของ build นั้นก่อน หาก sha256 ผิด จะหยุดด้วย exit 1 มีเฉพาะ `.exe`/`.dll` เท่านั้นที่ไปอยู่ใน `engine\bin`; ใบอนุญาตและ README ไปอยู่ใน `engine\lisanslar\<zip name>\` [ลองแล้ว: ด้วย dist zip ก่อนเผยแพร่ release ยืนยัน sidecar `.sha256` พร้อมคำเตือนการอ้างอิงตัวเอง, วาง binary และ DLL แล้ว, `sd-cli --help` รันได้; sha ของ binary ที่ติดตั้งตรงกัน (`c5cebe78...`, `e5d3d329...`); ขั้นตอนโมเดลและการตรวจ 5 frame ของ `kur.ps1` ยังไม่เคยรันบน GPU จริง]
   **ใบอนุญาตของโมเดล:** ก่อนขั้นตอนโมเดล ตัวติดตั้งจะพิมพ์สรุปใบอนุญาต (`docs/LISANS_KABUL.txt`, ฉบับเต็มคือ `docs/LISANS_UYARISI.md`: MiniMax H3 Community License, ข้อจำกัดด้านอาณาเขตที่ครอบคลุมถึงวิดีโอที่สร้างขึ้นด้วย, กฎด้านการใช้เชิงพาณิชย์และการระบุว่าเป็น AI) และขอให้ยอมรับ (`E` = ยอมรับ) ควรอ่านก่อน สำหรับการรันโดยไม่มีคนเฝ้า สามารถส่ง `-LisansKabul E` ซึ่งหมายความว่าคุณอ่านและยอมรับด้วยตัวเองแล้ว; อย่าใส่แทนผู้อื่น (สำหรับ AI agent: ปฏิบัติตาม `AGENTS.md`; ห้ามพิมพ์ E โดยไม่ได้รับความยินยอมจากผู้ใช้) หากไม่ยอมรับ `kur.ps1` จะหยุดด้วย exit code 2 และไม่ดาวน์โหลดโมเดลใด ๆ
3. **วิดีโอแรกของคุณ (56 frame ประมาณ 11 นาทีบน GTX 1050 Ti ของเรา** [วัดจริง: 641 วินาที รอบรัน R0 `docs/OLCUMLER.md` ไม่ได้วัดการ์ดใบอื่น]**)**: เมื่อตัวติดตั้งพิมพ์ `HAZIR / READY` ให้รัน
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (ทางลัด: ลากไฟล์ข้อความพรอมต์ไปวางบน `uret.cmd` หรือรัน `uret.cmd docs\ornek_istem_R0.txt` ซึ่งเป็นการรัน 56 frame แบบเดียวกัน) วิดีโออยู่ใน `runs\` จากนั้นเขียนพรอมต์ของคุณเองลงไฟล์ข้อความ (ภาษาอังกฤษหนึ่งย่อหน้า มีประโยค `audio:` หรือไม่ก็ได้) แล้วรันคลิปที่ยาวที่สุดที่เรารองรับ (ค่าเริ่มต้น ประมาณ 57 นาที [วัดจริง: รอบรัน U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   `-Kare` เป็นไปตาม grid 17k+5 (56, 73, ... 192, 209); ค่าเริ่มต้นคือ 209 (8.7 วินาที) ซึ่งเป็นความยาวสูงสุดที่เรารองรับ VAE รันใน process แยก และไม่เคยแบ่งเป็น tile [รัน engine จริงผ่าน `uret.ps1` ด้วย release binary โดยให้ VAE อยู่ใน process แยก ผ่านในรอบรัน U209]

   คู่มือเขียนพรอมต์: [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (รูปแบบช็อตต่อเนื่องช็อตเดียว ช่วงเวลาเท่า ๆ กัน และตัวอย่างเต็มสองตัวอย่าง)

| ข้อกำหนด | ค่า |
|---|---|
| OS | Windows 10/11, 64 บิต |
| GPU | NVIDIA, 4 GB ขึ้นไป; ทดสอบเฉพาะ GTX 1050 Ti (sm_61); ส่วนเผื่อค่อนข้างน้อย (3777/4096 MiB ที่ 209 frame): หน้าจอที่ใช้งานหนักหรือเบราว์เซอร์อาจทำให้การรันล้มเหลว; ยังไม่ได้ลองการ์ด 4 GB รุ่นอื่น |
| RAM | 16 GB (ค่าสูงสุดประมาณ 11 GB; ปิดโปรแกรมอื่น) |
| ดิสก์ | ว่างอย่างน้อย 32 GiB (แนะนำ 40 GiB ขึ้นไป: ระหว่าง 32 ถึง 40 ตัวติดตั้งจะพิมพ์คำเตือน `[VT-W-DISK-PAY]` [วัดจริง: การรัน `-Kuru` ด้วยดิสก์จำลอง]) เก็บโมเดลบน SSD (แนะนำ NVMe) |
| ดาวน์โหลด | engine zip 36.8 MB + CUDA runtime zip 567.5 MB [วัดจริง] + โมเดล 31,473,112,040 ไบต์ (ประมาณ 29.3 GiB) [อ่านแล้ว: ขนาดอยู่ใน `scripts/modeller.json`]; รวมประมาณ 30 GiB |
| โมเดล | ไม่รวมมาด้วย; ตัวติดตั้งดึงมาให้ภายใต้ใบอนุญาตของ MiniMax (ดูคำเตือนด้านล่าง) โมเดล (29.3 GiB, 31,473,112,040 ไบต์ใน `scripts/modeller.json`) ไม่อยู่ใน repository หรือ release นี้: GitHub มีข้อจำกัดขนาดไฟล์/release และ `kur.ps1` ดาวน์โหลดจากแหล่งทางการพร้อมตรวจ sha256 |

exit code ของ `kur.ps1`: 0 READY, 1 ข้อผิดพลาด, 2 ต้องการข้อมูลจากผู้ใช้ (ใบอนุญาต หรือยังไม่มี release/zip), 3 ฮาร์ดแวร์หรือดิสก์ไม่พอ, 4 หยุดแล้ว (ไฟล์ DUR) `uret.ps1` จะรับผลการรันก็ต่อเมื่อมีไฟล์ `.avi` จำนวน frame ถูกต้อง และ log สะอาด [วัดจริง: รันจริงหนึ่งครั้งผ่าน `uret.ps1` บน release binary, รอบรัน U209, 209 frame, ผ่านด่านตรวจ] exit code ของ `uret.ps1`: 0 DONE (ผ่านด่านตรวจคุณภาพ), 1 ข้อผิดพลาดหรือเอาต์พุตไม่ถูกต้อง (รวมถึงวิดีโอที่ไม่มี audio stream), 2 หยุดแล้ว (ไฟล์ DUR), 5 `KAPI RED` (ด่านตรวจคุณภาพไม่ผ่าน: คลิปไม่ได้รับการยอมรับ ผู้ตัดสินใจคือคุณ), 6 ไม่สามารถรันด่านตรวจได้ (คลิปไม่ได้รับการยอมรับ) รายละเอียดอยู่ใน AGENTS.md [วัดจริง: exit code 0, 1 (วิดีโอไม่มีเสียง), 5 และ 6 ในสถานการณ์ที่ใช้ engine ปลอมและด่านตรวจปลอม; engine จริง: exit 0 ในรอบรัน U209]

### การแก้ปัญหา (รายละเอียด: `docs/SIK_HATALAR.md`)
บรรทัดข้อผิดพลาดของสคริปต์เรามีรหัสคงที่ เช่น `HATA: [VT-E-DLL] ...` หรือ `UYARI: [VT-W-DISK-PAY] ...` ให้ค้นรหัสใน [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) (ตัวอย่างจุดยึด `#vt-e-dll`) หรือใน `docs/hata_imzalari.json` และใส่รหัสนั้นใน issue ของคุณ คอลัมน์แรกของตารางด้านล่างคงไว้ตามที่พิมพ์ (ไม่ต้องแปลรหัสและข้อความล็อก)

| สิ่งที่เห็น | ความหมาย และสิ่งที่ควรทำ |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | อย่าเปิด `sd-cli.exe` ด้วยมือ; ให้รัน `scripts\kur.ps1` ซึ่งจะวาง DLL ของ CUDA ให้ถูกที่ |
| `failed during weight preparation` ที่ `blocks.0` (#1, #3, #5) | VRAM ไม่พอที่ด่านตรวจหน่วยความจำ: ใช้จำนวน frame ที่น้อยลงบน grid 17k+5, ปิดโปรแกรมอื่นที่ใช้ GPU, และคง flag ที่แถมมาไว้ตามเดิม |
| `retrying with temporal tiling` (#6) | VAE ถอยไปใช้การแบ่ง tile; เอาต์พุตใช้ไม่ได้สำหรับการประเมินคุณภาพ ให้รันใหม่ |
| การรันจบที่เพดานเวลา ไม่มีวิดีโอ (#7) | เพิ่ม `-TavanDk` สำหรับคลิปยาว (เพดานเวลาเริ่มต้น: 80 นาทีสำหรับ 209 frame ตั้งโดย `uret.ps1`; การรัน 209 frame ของเราใช้เวลา 57 นาที [วัดจริง: รอบรัน U209]) |
| exit code ว่าง แต่แสดง "finished" (#14) | wrapper อ่าน exit code เร็วเกินไป; รันใหม่ และตรวจว่ามีไฟล์วิดีโออยู่จริง |
| ระบบช้าลง มีการ swap (#18) | engine ใช้ RAM ประมาณ 10-11 GB; ปิดเบราว์เซอร์และโปรแกรมอื่น |
| sha256 ไม่ตรง / ดาวน์โหลดล้มเหลว | มักเกิดจากการดาวน์โหลดถูกขัดจังหวะ: รันคำสั่งเดิมอีกครั้ง ไฟล์ที่ตรวจแล้วจะถูกข้าม |

**ติดขัดหรืออยากรู้เพิ่ม?** [`SUPPORT.md`](SUPPORT.md) (ถามที่ไหน เวลาตอบเป็นเป้าหมาย ไม่ใช่คำมั่น) · [`PRIVACY.md`](PRIVACY.md) (ไม่มีเทเลเมทรี ใช้เครือข่ายเฉพาะดาวน์โหลด engine และโมเดลจากโฮสต์ที่ระบุไว้) · [`SECURITY.md`](SECURITY.md) (รายงานแบบส่วนตัว) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (pull request แรกใน 5 ขั้นตอน ไม่ต้องใช้ GPU สำหรับเอกสารและสคริปต์)

### ใหม่ใน v0.1.1: ตัวเลือกเพิ่มเติม (รายละเอียด: `AGENTS.md`, `docs/SIK_HATALAR.md` 19-23)
หากไม่ใช้ตัวเลือกเหล่านี้ จะไม่มีอะไรเปลี่ยนบนการ์ด 4 GB (การตรวจระดับไบต์ที่ 56 frame เทียบกับค่าอ้างอิงของเรา ผ่านอีกครั้งกับ v0.1.1 [วัดจริง]) เติม `-Kuru` ต่อท้ายคำสั่งใดก็ได้เพื่อดูว่าจะรันอะไร
- `-EndImg`: ระบุ frame สุดท้ายด้วย (frame แรกและ frame สุดท้าย, "FLF"); เพดานคือ 175 frame บนการ์ดที่ต่ำกว่า 8 GB (192 ไม่พอดีบน 4 GB) และ 192 บนการ์ด 8 GB ขึ้นไป บน GTX 1050 Ti ของเรารันเป็น 2 process เสมอ: 56 frame ใช้ 1040 วินาที, 175 frame ใช้ 2887 วินาที (48 นาที) ทั้งสองผ่านด่านตรวจ [วัดจริง] เคล็ดลับการเขียนพรอมต์: `docs/ISTEM_YAZIMI.md`
- `-W` / `-H`: ขนาดอื่น เช่น แนวตั้ง 384x640; ต้องเป็นผลคูณของ 32 และพื้นที่อย่างน้อย 640x384 (เล็กกว่านี้ไม่ได้) ยังไม่ได้ทดสอบบน 4 GB; บนการ์ดที่ต่ำกว่า 8 GB ขนาดที่เกินงานใหญ่ที่สุดที่เราวัดไว้จะถูกปฏิเสธ เกณฑ์ของด่านตรวจคุณภาพปรับเทียบไว้ที่ 640x384
- `-TekAsama`: ใช้ process เดียวแทน 2 process สำหรับการ์ดขนาดใหญ่เท่านั้น และจะไม่ถูกเปิดใช้โดยอัตโนมัติ
- GPU รุ่นใหม่กว่า (compute capability 7.0+ เช่น RTX 20/30/40): หากคุณไม่ได้ตั้งค่าเอง ระบบจะตั้ง `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` ให้โดยอัตโนมัติ ซึ่งแก้ปัญหาวิดีโอดำทั้งคลิปที่ 141 frame ขึ้นไปบน RTX 4070 Ti ของผู้รายงานได้ [ผู้ใช้รายงาน, issue #1] ตอนนี้หากไม่มี Python + OpenCV `uret.ps1` จะหยุดด้วย exit 6 ก่อนงาน GPU (ไม่มีการสร้างวิดีโอ และไม่มี RED ที่ทำให้เข้าใจผิด)
- ขอบคุณ @SinanC73 สำหรับรายงานจาก RTX 4070 Ti ที่นำไปสู่การเปลี่ยนแปลงเหล่านี้ ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1))

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

## โปรไฟล์ความเร็วแบบเลือกได้ (ชุดเร่งความเร็ว; ปิดไว้เป็นค่าเริ่มต้น)
ไม่มีข้อใดด้านล่างเปลี่ยนการรันค่าเริ่มต้น (640x384, 209 เฟรม, 3414 วินาทีบนการ์ดของเรา) นี่คือเซลล์ที่วัดแล้วสามเซลล์นอกเหนือจากนั้น แต่ละเซลล์เป็นโปรไฟล์ที่มีชื่อของ `uret.ps1` ต้องใช้เอนจินของชุดเร่งความเร็ว (เอนจินรุ่นปล่อยบวกแพตช์ 0021, 0023, 0024 ซึ่งปิดไว้เป็นค่าเริ่มต้นทั้งหมด: `docs/YAMALAR.md`) ติดตั้งด้วย `scripts\kur.ps1 -HizPaketi` (zip ในเครื่องใช้ได้กับ `-MotorZip`) แล้วเพิ่ม `-Profil <name>`; `-Kuru` จะพิมพ์สิ่งที่จะรัน

| โปรไฟล์ | ขนาด, ความยาว | เวลารวมบน GTX 1050 Ti 4 GB | สถานะ |
|---|---|---|---|
| (ไม่มี, ค่าเริ่มต้น) | 640x384, สูงสุด 209 เฟรม (8.7 วินาที) | 209 เฟรม: 3414 วินาที | ตรวจสอบแล้ว ไม่เปลี่ยนแปลง |
| `yuksek832` | 832x480, 141 เฟรม (5.9 วินาที) | ประมาณ 55-56 นาที | ใช้งานได้ พร้อมต์สองชุด [วัดจริง] |
| `yuksek832 -Kare 124` | 832x480, 124 เฟรม (5.2 วินาที) | ประมาณ 45-46 นาที ไม่ต้องใช้แฟลกความเร็ว | ใช้งานได้ พร้อมต์สองชุด [วัดจริง] |
| `yuksek896` | 896x512, 124 เฟรม (5.2 วินาที) | ประมาณ 56-57.5 นาที | ใช้งานได้ พร้อมต์สองชุด [วัดจริง] |
| `uzun260` | 640x384, 260 เฟรม (10.8 วินาที) | วัดได้ 78 นาทีเมื่อไม่มีการออกก่อนกำหนด; เมื่อมีประมาณ 71-72 นาที [คาดเดา: ไม่ได้วัดตลอดทางผ่าน `uret.ps1`] | มีเงื่อนไขและเป็นการทดลอง |

- **ส่วนต่างแคบ:** ที่ 832x480 x 141 ประตูหน่วยความจำเหลือส่วนต่างเพียงหลักเดียวเป็น MB (5.7 และ 6.8 MB ในการรันเต็มสองครั้ง) พร้อมต์ยาวสองชุด (1520 และ 2041 อักขระ) ตรวจเพียงโดยอ่านประตูของขั้นตอนที่ 1 และบางส่วนของขั้นตอนที่ 2 ไม่ได้รันจนจบ: ส่วนต่าง 10.9 และ 4.0 MB โปรเซสอื่นที่ครอบครองหน่วยความจำการ์ด (เบราว์เซอร์, จอที่สอง) อาจทำให้ล้มเหลวได้ เมื่อเป็นเช่นนั้นให้ใช้ `-Kare 124` หรือขนาดค่าเริ่มต้น [วัดจริง, GTX 1050 Ti 4 GB]
- **`uzun260` มีเงื่อนไข:** ขีดจำกัดหน่วยความจำแคบมาก (VRAM สูงสุด 3903 จาก 4096 MiB) การใช้หน่วยความจำที่ใช้ร่วมกันเพิ่มขึ้น 61 และ 68 MiB และไม่มีค่าอ้างอิงที่ปิดแฟลกสำหรับความเท่ากันระดับไบต์ จึงไม่เสนอเป็นฟีเจอร์ทั่วไป แพตช์ 0023 รับไว้เฉพาะเซลล์นี้เซลล์เดียว
- **ไม่เสนอ:** 832x480 ที่ 158 หรือ 175 เฟรมไม่พอดี การค้นหาความยาวจบลงที่ 141 เฟรมตรงนั้น ขนาดและจำนวนเฟรมอื่นถูก `-Profil` ปฏิเสธ (ใช้เส้นทางค่าเริ่มต้น)
- คุณภาพค่าเริ่มต้นไม่ถูกแตะต้อง: 6 ขั้น, cfg 1, VAE ไม่แบ่งไทล์, 17k+5 เฟรม ในที่ที่เปิดแฟลก ผลลัพธ์ถูกเทียบกับวิดีโอที่ไม่เปิดแฟลกทีละไบต์ในขนาดที่การรันแบบไม่เปิดแฟลกพอดี (`docs/YAMALAR.md`); ที่ 832x480 x 141 และ 896x512 x 124 การรันแบบไม่เปิดแฟลกไม่พอดี ความเท่ากันตรงนั้นจึงอิงเซลล์ที่ใกล้ที่สุด ไม่ใช่การเทียบโดยตรง [วัดจริง, อ่านแล้ว]
- ขั้นตอนที่ 1 ของการรันสองขั้นตอนตอนนี้จบทันทีที่ไฟล์ latent สมบูรณ์ (`VT_ERKEN_CIKIS=0` ปิดสิ่งนี้)

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

## นี่คืออะไร
ชุดแพตช์ขนาดเล็กด้านหน่วยความจำ/การจัดตารางสำหรับ stable-diffusion.cpp พร้อมสูตรการรัน การตรวจสอบ และผลการวัด ที่ทำให้ MiniMax H3 (DiT 33B; เรารัน HyperFlow Flash 13.7B Q4_K_M GGUF; text encoder Qwen3-VL 32B แยกต่างหาก) รันบน GPU ตระกูล Pascal 4 GB (GTX 1050 Ti, RAM ระบบ 16 GB) ได้
- ความยาวแบบรอบเดียวที่เราสร้างขึ้นจริงและผ่านด่านตรวจคุณภาพ: 56, 141, 158, 175, 192, 209 frame ที่ 640x384, 24 fps (209 frame = 8.7 วินาที) พร้อมเสียงที่ H3 สร้างเอง [วัดจริง: 209 frame ด้วย release binary ผ่าน `uret.ps1` รอบรัน U209; latent เหมือนกับรอบรันของ development build ทุกไบต์; frame และเสียงในวิดีโอเหมือนกัน ส่วน sha ของไฟล์ต่างกันเพราะ container; หลักฐานผู้เขียนเก็บไว้เอง ไม่ได้อยู่ใน repo นี้] 209 คือความยาวสูงสุดที่เราดูแล้วพบว่าลื่นไหล [ผู้ใช้รายงาน, 2026-11-19, ดูวิดีโอครบทั้งหมด; ไฟล์: เอาต์พุต F209V2, 8.708 วินาที]
- **ข้อกล่าวอ้างเรื่องตรงกันทุกไบต์ ระบุขอบเขตตามจริง:** ตรวจว่าเอาต์พุตตรงกับค่าอ้างอิงที่ไม่ได้แพตช์ทุกไบต์เฉพาะที่ 56 และ 141 frame เท่านั้น สำหรับ 158/175/192/209 frame เราใช้ flag ชุดเดียวกันและ binary chain เดียวกัน; ไม่มีค่าอ้างอิงระดับไบต์โดยตรง (build ที่ไม่ได้แพตช์รันความยาวเหล่านั้นบน GPU นี้ไม่ได้)
- ไม่เคยลดการตั้งค่าคุณภาพ: โมเดล/quantization เดียวกัน, 6 step, cfg 1, 640x384, seed เดียวกัน, VAE แบบไม่แบ่ง tile
- เราไม่ได้อ้างว่าเป็นรายแรก: เราค้นหาแล้วไม่พบตัวอย่างภายนอกที่ทำเช่นนี้บน 4 GB ซึ่งไม่ใช่หลักฐานว่าไม่มีอยู่

## โครงสร้าง
- `patches/` แพตช์สำหรับ commit ของ stable-diffusion.cpp ที่ปักไว้ (ดูหมายเหตุในนั้น)
- `scripts/` build, รัน, VAE แบบ process แยก, ตัวช่วยด่านตรวจ/ความสอดคล้อง (`doku_norm.py`: ดูหมายเหตุเรื่อง scale ด้านล่าง)
- `docs/KURULUM.md` ฮาร์ดแวร์ ขั้นตอน build และการรัน (EN+TR)
- `docs/YAMALAR.md` รายการแพตช์, `docs/KANITLAR.md` หลักฐาน, `docs/KAPILAR.md` ตารางด่านตรวจคุณภาพ, `docs/OLCUMLER.md` ผลการวัด, `docs/SIK_HATALAR.md` ข้อผิดพลาดที่พบบ่อย, `docs/LISANS_UYARISI.md` รายการใบอนุญาตฉบับเต็ม
- ดัชนีสั้นของ `scripts/`: `hiz_kos3.ps1` wrapper สำหรับรัน (`-Kuru` พิมพ์คำสั่งที่แน่นอน), `uretim_kapi.ps1` ด่านตรวจคุณภาพ, `dikis_denetim.py` ตรวจรอยต่อ, `doku_norm.py` noise ที่ปรับ texture ให้เป็นมาตรฐาน, `bayt_kiyas.py` เปรียบเทียบไบต์, `derleme_sablonu.ps1` แม่แบบ build (หยุดเฉพาะตัวช่วย telemetry ของ Visual Studio ชื่อ `vctip.exe` ที่เริ่มทำงานหลังจาก build ของตัวเองเริ่มแล้วเท่านั้น ซึ่งไม่เช่นนั้นจะทำให้ process ของ build ค้างอยู่อีกหลายนาที; process `vctip.exe` อื่นไม่ถูกแตะต้อง)

## ด่านตรวจคุณภาพ (วิธียอมรับผลลัพธ์)

ด่านตรวจนี้ไม่ได้ตรวจความสอดคล้องของการเคลื่อนไหว (การกระโดดของขนาดหรือตำแหน่งวัตถุ): ให้ดูวิดีโอทั้งคลิปก่อนยอมรับ
1. จำนวน frame และเสียงต้องมี; ใน log ต้องไม่มีบรรทัด memory fallback หรือ ALLOC_FAILED
2. ด่าน raw noise: ค่าเศษเหลือของ median filter <= 1.5 (สเกล 0-255)
3. noise ที่ปรับ texture ให้เป็นมาตรฐาน, `scripts/doku_norm.py` (เวอร์ชันของ repo นี้): N = ค่ามัธยฐานของเศษเหลือ / texture แบบ Sobel, เก็บทุก ๆ 6 frame **หมายเหตุเรื่อง scale:** ในเวอร์ชันนี้ คลิปที่วัดแล้ว 10 คลิปให้ N = 0.034-0.052 (ตารางใน `docs/KAPILAR.md`; หนึ่งในสี่สุดท้ายของ F192/F209V2 ถึง 0.062) และเกณฑ์ของด่านเสริมคือ N <= 0.065 การ implement อีกแบบหนึ่งวัดได้ 0.028-0.036 บนคลิปเดียวกัน ดังนั้นเกณฑ์ใช้แทนกันระหว่างเวอร์ชันไม่ได้ บน texture ที่ละเอียดมาก (แถวหญ้า) ค่า N ของภาพสะอาดคือ 0.075 เกณฑ์จึงกำหนดตามกลุ่มของฉาก ตัวประมาณความถี่สูงแบบทนทาน (sigma-HH <= 1.5; ภาพสะอาด 0.74-1.19, เมื่อเติม noise s=2 ได้ 2.2-3.0) เป็นด่านเสริมที่แนะนำ

ขอบเขต: VideoTurko เกี่ยวกับการรัน 1 รอบเดียว (สูงสุด 209 เฟรม ประมาณ 8.7 วินาที) การทดสอบการต่อคลิปของเราเองพบรอยต่อที่มองเห็นได้ (ฉากไม่ต่อเนื่องอย่างสะอาด) ภาพยนตร์ที่ยาวกว่านี้จึงไม่อยู่ในสิ่งที่เราตรวจสอบ สำหรับการต่อคลิปมีคู่มือจากชุมชน `docs/KLIP_ZINCIRI.md` และเครื่องมือช่วยของเราที่ใช้ CPU อย่างเดียว `scripts/zincir.py` (`plan`, `son-kare`, `bagla`; ไม่เคยสตาร์ตเอนจิน) เรายังไม่ได้วัดคุณภาพของภาพยนตร์ที่ต่อกัน [ยังไม่ได้ลอง] ดังนั้นโปรดตรวจรอยต่อทุกจุดด้วยตาและด้วย `scripts/dikis_denetim.py`
การตั้งค่าเป็นของคุณ: 209 frame คือค่าเริ่มต้นที่เราทดสอบบนการ์ด 4 GB ไม่ใช่ขีดจำกัดที่ต้องใช้ เลือกจำนวน frame ใดก็ได้บน grid 17k+5 (56, 73, ... 192, 209; ดู `docs/KURULUM.md`) เปลี่ยน prompt, seed, ความละเอียด หรือ flag ใด ๆ ได้ตามต้องการ คลิปที่สั้นกว่าใช้หน่วยความจำและเวลาน้อยกว่า; GPU ที่ใหญ่กว่าอาจรองรับได้มากกว่า

## คำเตือนเรื่องใบอนุญาตของโมเดล
**VideoTurko มีเฉพาะแพตช์และสคริปต์ (MIT); ผู้ที่ใช้โมเดลและเอาต์พุตของโมเดลต้องรับผิดชอบเรื่องใบอนุญาตของ MiniMax ด้วยตัวเอง** ไม่ใช่คำแนะนำทางกฎหมาย ด้านล่างคือข้อกำหนดของ MiniMax H3 Community License (2 สิงหาคม 2026) ที่สรุปไว้พร้อมเลขข้อ; ตัวใบอนุญาตเองคือฉบับที่มีผลผูกพัน: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

สัญญาอนุญาต MIT ของรีโพนี้ไม่ครอบคลุมน้ำหนักโมเดล ดู [`NOTICE`](NOTICE) repo นี้ไม่มีไฟล์น้ำหนักของโมเดลเลย (ไม่มี MiniMax H3, HyperFlow-H3-Flash GGUF หรือไฟล์ VAE) โปรเจกต์นี้ไม่ได้เกี่ยวข้องหรือได้รับการรับรองจาก MiniMax การใช้เชิงพาณิชย์ไม่ได้ถูกห้าม (ไม่ใช่ใบอนุญาตแบบไม่แสวงหากำไร); เงื่อนไขอยู่ด้านล่าง

**อาณาเขต (Applicable Territory)**
- **คำนำ, I.3, I.5:** ทั่วโลก ยกเว้นสหภาพยุโรป สหราชอาณาจักร สาธารณรัฐเกาหลี (Republic of Korea) และสหรัฐอเมริกา การใช้โมเดลถือว่ายอมรับใบอนุญาต
- **II:** ใบอนุญาตแบบจำกัด ปลอดค่าลิขสิทธิ์ โอนไม่ได้ สำหรับการใช้ ทำซ้ำ แจกจ่าย สร้างงานต่อยอด และแก้ไข เฉพาะภายในอาณาเขตและเป็นไปตามข้อตกลงและ Exhibit A ผู้ที่อยู่ในอาณาเขตที่ถูกยกเว้นสามารถขอใบอนุญาตแยกต่างหากจาก MiniMax ได้
- **V.4:** การใช้ ทำซ้ำ แก้ไข แจกจ่าย หรือแสดงโมเดล งานต่อยอดของโมเดล และเอาต์พุต (วิดีโอ/เสียงที่สร้างขึ้น) นอกอาณาเขตไม่ได้รับอนุญาต **ดังนั้นการเผยแพร่หรือแสดงวิดีโอที่สร้างขึ้นใน EU/สหราชอาณาจักร/เกาหลีใต้/สหรัฐอเมริกาอยู่นอกขอบเขตของใบอนุญาต**
- **Exhibit A-1:** การใช้นอกอาณาเขตเป็นการละเมิด Acceptable Use Policy

**การแจกจ่าย (III)** (repo นี้ไม่ได้แจกจ่ายโมเดล; หากคุณแจกจ่าย)
- **III.1:** มอบสำเนาใบอนุญาตให้ผู้รับทุกราย **III.2:** ทำเครื่องหมายไฟล์ที่แก้ไขด้วยประกาศที่เห็นได้ชัด
- **III.3:** สนับสนุน (ไม่บังคับ): ประกาศ "Powered by MiniMax H3", ตัวระบุว่าสร้างด้วย AI บนไฟล์ที่ผลิต, บทความเผยแพร่สู่สาธารณะ
- **III.4:** การแจกจ่ายต้องมีไฟล์ NOTICE แนบมาด้วยเสมอ โดยมีข้อความ: "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12:** ห้ามเผยแพร่เนื้อหาในสภาพแวดล้อมสาธารณะใด ๆ โดยไม่เปิดเผยอย่างชัดเจนว่าสร้างโดยเครื่อง: ให้ติดป้ายวิดีโอที่สร้างด้วย AI เมื่อเผยแพร่ (รายการเต็ม: `docs/LISANS_UYARISI.md`)
- **III (ย่อหน้าสุดท้าย):** คุณอาจใส่ลิขสิทธิ์ของตนเองสำหรับส่วนที่คุณแก้ไข แต่ห้ามกำหนดเงื่อนไขเพิ่มเติมหรือแตกต่างออกไปเกี่ยวกับการใช้/แจกจ่าย; กฎเรื่องอาณาเขตยังคงใช้บังคับ

**เงื่อนไขเชิงพาณิชย์ (IV)**
- **IV.1:** หากผลิตภัณฑ์/บริการเชิงพาณิชย์ของคุณสร้างรายได้เกิน USD 20 million (หรือเทียบเท่า) ต่อปี ให้ขออนุญาตเป็นลายลักษณ์อักษรล่วงหน้าจาก api@minimax.io (หัวเรื่อง "MiniMax H3 licensing - authorization request")
- **IV.2:** UI ของผลิตภัณฑ์/บริการเชิงพาณิชย์ที่ใช้โมเดลต้องแสดง "MiniMax H3" อย่างเด่นชัด

**ข้อจำกัดการใช้งาน (V)**
- **V.1:** ปฏิบัติตามกฎหมายที่เกี่ยวข้อง (รวมถึงการปฏิบัติตามกฎระเบียบทางการค้า) และ Exhibit A **V.2:** ผูกมัดทุกคนที่คุณให้สิทธิ์เข้าถึงด้วยข้อกำหนดที่ให้การคุ้มครองไม่น้อยกว่าข้อจำกัดเหล่านี้ และแจ้งให้ทราบ
- **V.3:** ห้ามใช้โมเดลหรือเอาต์พุตของโมเดลเพื่อปรับปรุงโมเดล AI อื่นใด (นอกจาก MiniMax H3 และงานต่อยอดของมัน) (I.11: การกลั่นความรู้ (distillation) และการฝึกบนเอาต์พุตสังเคราะห์ทำให้โมเดลนั้นเป็น "งานต่อยอด"; ตัวเอาต์พุตเองไม่ใช่งานต่อยอด)
- **V.5:** หากคุณให้บุคคลที่สามใช้ผลิตภัณฑ์/บริการ/บริการแบบโฮสต์ที่สร้างเอาต์พุตด้วยโมเดล: ก่อนและตลอดการให้บริการ ต้องมีมาตรการป้องกันทางเทคนิคและองค์กรที่สมเหตุสมผล กลไกการรายงาน การสอบสวนโดยเร็ว และการลบ/ปิดใช้งาน/ระงับผู้ที่ฝ่าฝืนซ้ำ

**เครื่องหมายการค้าและสิทธิ (VI)**
- **VI.1:** คุณเป็นเจ้าของงานดัดแปลงและงานต่อยอดของโมเดลที่คุณสร้างขึ้น (ภายใต้สิทธิของ MiniMax) **VI.2:** ชื่อ/เครื่องหมายการค้าของ MiniMax ไม่ได้รับอนุญาต (เกินกว่าที่จำเป็นต่อการอธิบายและแจกจ่าย); เครื่องหมาย "MiniMax H3" ใช้ได้เฉพาะเพื่อปฏิบัติตาม III.3 ภายในอาณาเขตเท่านั้น; ห้ามสื่อว่ามีความเกี่ยวข้องกัน
- **VI.3:** หากคุณฟ้อง MiniMax หรือผู้ใดโดยกล่าวหาว่าสื่อ/เอาต์พุตละเมิดสิทธิของคุณ ใบอนุญาตทั้งหมดของคุณสิ้นสุดลงในวันนั้น; คุณต้องปกป้องและชดใช้ให้ MiniMax จากข้อเรียกร้องของบุคคลที่สามอันเกิดจากการใช้/แจกจ่ายของคุณหรือของผู้อื่น
- **VI.4:** MiniMax ไม่อ้างสิทธิใด ๆ เหนือเอาต์พุต; คุณและผู้ใช้ของคุณรับผิดชอบเอาต์พุตและการใช้งานเอาต์พุต

**ข้อสงวนสิทธิ์และการสิ้นสุด (VII, VIII, IX)**
- **VII.1:** ไม่มีหน้าที่ให้การสนับสนุน/อัปเดต **VII.2:** โมเดลและเอาต์พุตให้ "ตามสภาพ" ("AS IS") ไม่มีการรับประกันใด ๆ; คุณเป็นผู้ตัดสินความเหมาะสมและรับความเสี่ยงเอง **VII.3:** MiniMax และบริษัทในเครือไม่รับผิดชอบต่อความเสียหายใด ๆ (เท่าที่กฎหมายอนุญาต)
- **VIII.1:** มีผลเมื่อยอมรับ/เข้าถึง **VIII.2:** เมื่อมีการฝ่าฝืน MiniMax อาจยกเลิกได้; คุณต้องหยุดใช้/แจกจ่าย ลบสำเนา และแจ้งผู้รับ (VI.1, VI.3, VII, IX ยังคงมีผล)
- **IX:** กฎหมายของเขตบริหารพิเศษฮ่องกง; ศาลฮ่องกงมีเขตอำนาจเฉพาะ (ไม่รวม UN CISG)
- **หมายเหตุเพิ่มเติม:** encoder ของ MiniMax H3 ใช้ Qwen3-VL-32B (Apache 2.0)

**นโยบายการใช้งานที่ยอมรับได้ (Acceptable Use Policy, Exhibit A)** (ห้ามใช้โมเดล งานต่อยอด หรือเอาต์พุตเพื่อ)
- A-1 การใช้นอกอาณาเขต; A-2 การละเมิดกฎหมายหรือทรัพย์สินทางปัญญาของบุคคลที่สาม; A-3 การทำร้ายตนเองหรือผู้อื่น; A-4 การนำเอาต์พุตไปใช้ใหม่/แจกจ่ายเพื่อก่อให้เกิดอันตราย; A-5 การหลีกเลี่ยงมาตรการป้องกัน; A-6 การแสวงหาประโยชน์/ทำร้ายผู้เยาว์; A-7 ข้อมูลเท็จที่พิสูจน์ได้เพื่อทำร้ายผู้อื่นหรือมีอิทธิพลต่อการเลือกตั้ง; A-8 การสร้างปฏิสัมพันธ์ออนไลน์ปลอม (เช่น รีวิวปลอม); A-9 การหมิ่นประมาท ดูหมิ่น คุกคาม; A-10 มัลแวร์; A-11 ข้อมูลส่วนบุคคลเพื่อทำร้ายผู้อื่น; **A-12 การเผยแพร่เนื้อหาในสภาพแวดล้อมสาธารณะใด ๆ (รวมถึงโพสต์ของบอท) โดยไม่เปิดเผยอย่างชัดเจนและเด่นชัดว่าสร้างโดยเครื่อง**; A-13 การสวมรอยโดยไม่ได้รับความยินยอม; A-14 การตัดสินใจอัตโนมัติที่มีความเสี่ยงสูงในด้านสำคัญ (การบังคับใช้กฎหมาย การตรวจคนเข้าเมือง สุขภาพ โครงสร้างพื้นฐานสำคัญ สินเชื่อ การจ้างงาน ที่อยู่อาศัย การศึกษา การให้คะแนนทางสังคม ประกันภัย ฯลฯ); A-15 การละเมิดมาตรฐานทางสังคม จริยธรรม ศีลธรรมของประเทศ/ภูมิภาคอื่น; A-16 ลัทธิสุดโต่งที่ใช้ความรุนแรง/การก่อการร้าย; A-17 การเลือกปฏิบัติ/ทำร้ายโดยอาศัยลักษณะที่ได้รับการคุ้มครอง; A-18 การแสวงหาประโยชน์จากกลุ่มเปราะบาง; **A-19 วัตถุประสงค์ทางทหาร**; A-20 การประกอบวิชาชีพโดยไม่ได้รับอนุญาต/ไม่มีใบอนุญาต (การเงิน กฎหมาย การแพทย์ ฯลฯ)
- หมายเหตุ: นี่เป็นบทสรุปด้วยภาษาที่เข้าใจง่าย; หากมีข้อสงสัย ให้ถือข้อความใบอนุญาตภาษาอังกฤษเป็นหลัก

## ป้ายกำกับหลักฐาน

ชุดเดียวสำหรับทุกเอกสาร (การเขียนแบบเก่าอยู่ในวงเล็บ):
- **[วัดจริง]** (อังกฤษ: measured, TR: ölçtüm, olctum): รันในโปรเจกต์นี้ และมีพาธของหลักฐาน
- **[อ่านแล้ว]** (อังกฤษ: read, TR: okudum yol, okudum): อ่านซอร์สหรือสคริปต์แล้ว แต่ไม่ได้รัน
- **[ออกแบบ]** (อังกฤษ: design, TR: tasarım, tasarim): ออกแบบไว้ ยังไม่เห็นผลในการรันจริง
- **[คาดเดา]** (อังกฤษ: guess, TR: tahmin): ยังไม่ได้ตรวจสอบ
- **[ยังไม่ได้ลอง]** (อังกฤษ: not tried, TR: denenmedi): ไม่เคยรัน
- **[ผู้ใช้รายงาน]** (อังกฤษ: user-reported, TR: kullanıcı bildirdi): ผู้ใช้แจ้งไว้พร้อมวันที่; ไม่ได้วัดอย่างอิสระ
- **[คำนวณ]** (อังกฤษ: computed, TR: hesap; การเขียนแบบเก่า: calculated, hesap): ตัวเลขที่คำนวณจากข้อมูลนำเข้าที่วัดมา ตัวเลขนั้นเองไม่ได้ถูกวัด; วิธีคำนวณเขียนไว้ข้าง ๆ [ข้อเสนอ] / [öneri] ในข้อความเก่า = [คาดเดา]

ชื่อรอบรันที่ใช้ในวงเล็บเหลี่ยม (เป็นชื่อรอบรันของเราเอง ไม่ใช่ไฟล์ใน repo นี้): U209 = 209 frame ด้วย release binary ผ่าน `uret.ps1`; B209 และ B192 = รอบรัน image-to-video (`-InitImg`) ที่ 209 และ 192 frame; B56VT2 = release binary, 56 frame, เปรียบเทียบกับค่าอ้างอิงระดับไบต์ R0 ที่ 56 frame; F209b, F209V2, F209V2K = รอบรัน 209 frame บน development build (รายละเอียด: `docs/OLCUMLER.md`)

## ข้อจำกัดที่ทราบ
- **หลักฐานระดับไบต์** (วิธีทำซ้ำด้วยตัวเอง: `docs/KANITLAR.md`, "R0 ve latent referansi nasil uretilir"; ตรวจสอบบนการ์ด sm_61 ของเรา GPU อื่นอาจไม่ตรงกันทุกไบต์ [คาดเดา]): ด้วยชุดแพตช์ของเรา (เปิด flag ด้านหน่วยความจำ) การรัน 56 frame ให้ sha256 `0979f156d548169b...` ตรงกับค่าอ้างอิง [วัดจริง]; ที่ 141 frame sha256 ของ latent `E5D028F8632BE4FE...` ตรงกัน (พร้อม flag 0013/0014) frame ที่ 158 ถึง 209 ไม่มีค่าอ้างอิงระดับไบต์โดยตรง; หลักฐานคือห่วงโซ่ของด่านตรวจ การผ่านด่านตรวจเชิงตัวเลขไม่ได้รับประกันว่าคลิปดี: ความสอดคล้องของการเคลื่อนไหวตามเวลาตรวจด้วยตา (ดู `docs/KAPILAR.md`)
- **209 frame ใช้ flag ชุดไหน:** หลักฐาน byte chain ที่ 209 frame ได้จากชุด flag F209V2 บน development build (ไม่มี flag block-tail, build โดยไม่มีแพตช์ 0019/0020); `uret.ps1` ใช้สูตรนี้สำหรับ 209 frame [อ่านแล้ว: สคริปต์; การรัน engine จริงผ่าน `uret.ps1` ผ่านแล้วในรอบรัน U209]
- เราตรวจสอบบนการ์ดเดียว (GTX 1050 Ti 4 GB); รายงานจากภายนอกสำหรับการ์ดอื่นแสดงพร้อมป้ายกำกับใน `docs/KART_PROFILLERI.md` [ผู้ใช้รายงาน]
- **วัดกับ binary ตัวไหน:** latent ที่ 141 frame และ byte chain วัดด้วย development build ของเรา release binary ที่ดาวน์โหลดคือ build ใหม่: ด่านตรวจระดับไบต์ที่ 56 frame ผ่านแล้ว (ข้อถัดไป) และการรัน 209 frame ผ่าน `uret.ps1` ผ่านด่านตรวจ (รอบรัน U209, 3414 วินาที, VRAM สูงสุด 3777 MiB) [วัดจริง]; เทียบกับการรัน 209 ของ development build latent ตรงกันทุกไบต์; ในวิดีโอ frame (md5) และเสียงเหมือนกัน ส่วน sha256 ของไฟล์ AVI ต่างกันเพราะ container [วัดจริง] (ดู `docs/OLCUMLER.md` ส่วนที่ 0)
- **release binary, 56 frame:** release binary (sd-cli `c5cebe78...`, stable-diffusion.dll `e5d3d329...`) ให้ผล 56 frame ที่ตรงกับ R0 ทุกไบต์ (sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`; md5 ของแต่ละ frame และเสียงเหมือนกัน) รันโดยตรงด้วย flag ค่าเริ่มต้น (ไม่มีตัวแปร `SD_*`), exit code 0, 601 วินาที [วัดจริง: รอบรัน B56VT2, 2026-11-19; หลักฐานผู้เขียนเก็บไว้เอง ไม่ได้อยู่ใน repo นี้] ขอบเขต: เฉพาะการ์ด sm_61 ของเราและ 56 frame; ไม่ใช่การทดสอบติดตั้งแบบ clean-root; latent ที่ 141 frame และห่วงโซ่ที่ 209 วัดด้วย binary รุ่นเก่ากว่า และยังไม่ได้ทำซ้ำด้วยตัวนี้ [ยังไม่ได้ลอง] ความพยายามครั้งแรก (B56VT ผ่านสคริปต์ช่วย) จบลงอย่างเงียบ ๆ หลัง 58 วินาที ไม่ทราบสาเหตุ [คาดเดา: หน่วยความจำตึง]; ความพยายามครั้งที่สองรัน `sd-cli` โดยตรง
- สคริปต์ติดตั้งและรันยังไม่ได้ตรวจสอบจากโฟลเดอร์ว่าง (การทดสอบ clean-root ยังค้างอยู่)
- แผนงานและขั้นตอนถัดไป: `ROADMAP.md`

## สถานะและข้อจำกัด
- ตรวจสอบบนเครื่องเดียว (GTX 1050 Ti 4 GB, RAM 16 GB, i7-7700HQ) การ์ด 4 GB รุ่นอื่นและขนาด RAM อื่นอาจให้ผลต่างกัน
- **ค่าเริ่มต้น 209 frame (8.7 วินาที):** ผ่านด่านตรวจคุณภาพของเรา (noise 1.08, รอบรัน F209V2K) [วัดจริง: 209 frame ด้วย release binary ผ่าน `uret.ps1` รอบรัน U209; latent เหมือนกับรอบรันของ development build ทุกไบต์; frame และเสียงในวิดีโอเหมือนกัน ส่วน sha ของไฟล์ต่างกันเพราะ container; หลักฐานผู้เขียนเก็บไว้เอง ไม่ได้อยู่ใน repo นี้] ที่ 209 frame VRAM สูงสุดของ DiT คือ 3777 MiB จาก 4096 MiB (รอบรัน F209b และ U209; ค่า `nvidia-smi` ของทั้งการ์ด) ส่วนเผื่อค่อนข้างน้อย: โหลดอื่นบน GPU (การแสดงผล, แอปพลิเคชันอื่น) อาจทำให้การรันล้มเหลวที่ `blocks.0`; ทดสอบเฉพาะ GTX 1050 Ti สถานะการแสดงผลระหว่างการรันนั้นไม่ได้บันทึกไว้; หากหน้าจอของคุณใช้การ์ดใบนี้ จะเหลือ VRAM น้อยลง [คาดเดา: โหลดการแสดงผลของ Windows ประมาณ 100-300 MB]; หากจำเป็น ให้ต่อหน้าจอเข้ากับ GPU ออนบอร์ด [คำแนะนำ ยังไม่ได้ทดสอบ] sampling ใช้เวลา 2730 วินาที (รอบรัน U209: แต่ละ step 436-483 วินาที) และการถอดรหัส VAE ใน process แยกใช้เวลา 173 วินาที (ขั้นที่ 2 รวม 193 วินาทีเมื่อรวมการถอดรหัสเสียง) [วัดจริง: U209 release binary; การรัน development build ก่อนหน้า: 2664 วินาทีและ 174 วินาที] ในขั้นที่ 1 VAE ภายใน process หน่วยความจำไม่พอและถอยไปใช้ temporal tiling (320 วินาที); เอาต์พุตนั้นถูกทิ้ง วิดีโอมาจากขั้นที่ 2 ที่ไม่แบ่ง tile ไม่ได้วัด RAM สูงสุดใน U209 คลิปที่ยาวกว่า 209 frame ไม่อยู่ใน release นี้
- **Image-to-video (`-InitImg`):** เมื่อมีภาพเริ่มต้น เพดานบน GPU นี้คือ 192 frame (8.0 วินาทีที่ 24 fps): 209 frame ไม่พอดี (VRAM ขาดประมาณ 17.5 MB ที่ block 0: ต้องการ 2587 MB, ใช้ได้ 2570 MB); 192 frame รันผ่าน `uret.ps1` ใน 3086 วินาที VRAM สูงสุด 3783 MiB และผ่านด่านตรวจ [วัดจริง: รอบรัน B209 และ B192, 2026-11-20, หนึ่งฉาก; หลักฐานผู้เขียนเก็บไว้เอง ไม่ได้อยู่ใน repo นี้] ยังไม่ได้ลองบน GPU อื่น [ยังไม่ได้ลอง]
- **RAM ว่างสำคัญ:** ต้องมี RAM ว่างประมาณ 11 GB (process ของ engine ใช้ประมาณ 11 GB) [วัดจริง] หาก RAM ว่างน้อยเกินไป process อาจดับไปโดยไม่มีข้อความแสดงข้อผิดพลาด [คาดเดา: เราสังเกตเห็นหนึ่งครั้งเมื่อ RAM ว่างประมาณ 300 MB ขณะที่ `sd-cli` ใช้ประมาณ 10 GB] อย่าเปิดโปรแกรมใหญ่อื่นระหว่างรัน: บนเครื่อง 16 GB จะเหลือว่างเพียงประมาณ 0.3-0.5 GB และเมื่อหน่วยความจำตึง การรันอาจดับไปอย่างเงียบ ๆ ก่อนเริ่ม ให้ปิดเบราว์เซอร์ เกม และโปรแกรมใหญ่อื่น ๆ แล้วตรวจ RAM ว่าง
- **การทดสอบ clean-root ยังค้างอยู่:** สคริปต์ติดตั้งและรันยังไม่ได้ตรวจสอบจากโฟลเดอร์ว่างโดยใช้เพียงคำแนะนำเหล่านี้; ส่วนนี้จะอัปเดตเมื่อบันทึกการทดสอบนั้น (รวมถึงการเปรียบเทียบระดับไบต์ที่ 56 frame กับค่าอ้างอิง) แล้ว
- ไม่มีวิดีโอที่สร้างขึ้นรวมมาในที่นี้

<!-- i18n-source: README.md sha256:67497404d89b -->
