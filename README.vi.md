# VideoTurko

[English](README.md) · [Türkçe](README.tr.md) · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Español](README.es.md) · [Русский](README.ru.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [العربية](README.ar.md) · [Português (BR)](README.pt-BR.md) · [Italiano](README.it.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [Bahasa Indonesia](README.id.md) · Tiếng Việt · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Українська](README.uk.md) · [فارسی](README.fa.md) · [עברית](README.he.md) · [ไทย](README.th.md) · [বাংলা](README.bn.md) · [اردو](README.ur.md) · [Ελληνικά](README.el.md) · [Čeština](README.cs.md) · [Română](README.ro.md) · [Magyar](README.hu.md) · [Svenska](README.sv.md) · [Azərbaycanca](README.az.md) · [Bahasa Melayu](README.ms.md)

Các bản dịch bám theo README tiếng Anh này. Nếu một bản dịch khác hoặc chậm hơn, văn bản tiếng Anh là chuẩn, đặc biệt với phần giấy phép và bảo mật ([`SECURITY.md`](SECURITY.md) và [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) chỉ được duy trì bằng tiếng Anh và tiếng Thổ Nhĩ Kỳ).

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![GPU](https://img.shields.io/badge/NVIDIA-4%20GB%20(sm__61)-76b900) ![License](https://img.shields.io/badge/code-MIT-green) ![Status](https://img.shields.io/badge/status-clean--root%20test%20pending-orange)

> **Trước khi bắt đầu (giấy phép, phạm vi lãnh thổ):** kho này dùng giấy phép MIT và chỉ chứa bản vá và script. Mô hình MiniMax H3 mà nó tải về thuộc MiniMax H3 Community License: lãnh thổ áp dụng loại trừ Liên minh châu Âu, Vương quốc Anh, Hàn Quốc và Hoa Kỳ, và mô hình, sản phẩm phái sinh **cùng đầu ra (các video bạn tạo)** không được sử dụng, phân phối hay hiển thị ở đó (V.4). Việc sử dụng thương mại được phép trong phạm vi điều khoản giấy phép. Hãy đọc [`docs/LISANS_UYARISI.md`](docs/LISANS_UYARISI.md) trước khi cài; đây không phải tư vấn pháp lý.

> **Tóm tắt trong 30 giây:** một card đồ họa 4 GB có thể tạo video MiniMax H3 dài 209 khung hình (8,7 giây) trong một lượt chạy duy nhất. Đã kiểm chứng trên một máy (GTX 1050 Ti 4 GB); việc cài đặt đầy đủ bằng `kur.ps1` trong một thư mục trống thì chưa được kiểm chứng từ đầu đến cuối [đã đo: 209 khung hình với bản nhị phân release qua `uret.ps1`, lần chạy U209; latent giống hệt từng byte so với lần chạy bản build phát triển; khung hình và âm thanh trong video giống hệt nhau, sha của tệp khác vì container; bằng chứng do tác giả giữ, không có trong repo này]; với `-InitImg` (image-to-video) tối đa 192 khung hình (8,0 giây) [đã đo: lần chạy B192]; 209 khung hình mất khoảng 57 phút, giới hạn thời gian mặc định là 80 phút [đã đo: lần chạy U209]; 3 bước bên dưới là cách chạy.

VideoTurko: các bản vá bộ nhớ cho stable-diffusion.cpp cùng công thức chạy MiniMax H3 text-to-video trên GTX 1050 Ti 4 GB, tối đa 209 khung hình (8,7 giây) trong một lượt; image-to-video (`-InitImg`) tối đa 192 khung hình (8,0 giây) (209 khung hình được kiểm chứng bằng chuỗi byte; giống hệt từng byte so với lần chạy chưa vá ở các phép kiểm tra 56 và 141 khung hình).

## Bắt đầu nhanh (Windows, 3 bước)
**Trạng thái: các script cài đặt/chạy bên dưới đang được hoàn thiện và bài kiểm tra clean-root chưa được thực hiện; chưa có nội dung nào ở đây được khẳng định là hoạt động cho đến khi bài kiểm tra đó đạt (xem "Trạng thái và giới hạn").**

1. **Tải về** repo này (nút **Code** màu xanh lá, rồi **Download ZIP**) và giải nén vào một thư mục có đường dẫn NGẮN, ví dụ `C:\vt`.
2. **Cài đặt: bấm đúp `kur.cmd`** (một cửa sổ đen mở ra và hiện từng bước; đóng nó sẽ dừng cài đặt, chạy lại sẽ tiếp tục từ chỗ dừng: tệp mô hình tải dở được tải tiếp [đã đọc: script tải giữ một tệp `.part` và tiếp tục từ đó; chưa đo việc tải tiếp trọn 29 GiB]). Nếu Windows cảnh báo về tệp đã tải, hãy dùng lệnh PowerShell bên dưới thay thế [lời khuyên, chưa thử trên ZIP đã tải]. Thích dòng lệnh hơn? Mở PowerShell trong thư mục đó (gõ `powershell` vào thanh địa chỉ của Explorer) và chạy cùng bước cài đặt:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\kur.ps1
   ```
   Thư mục gốc cài đặt là thư mục bạn đã giải nén (engine nằm trong `engine\bin`, mô hình nằm trong `model`); nếu muốn dùng chỗ khác, hãy đặt biến môi trường `VT_ROOT` trước. Script kiểm tra GPU, driver, RAM và ổ đĩa, tải engine và các mô hình (tệp zip của engine và các tệp mô hình mới tải được kiểm tra sha256; tệp mô hình đã có sẵn với kích thước đúng chỉ được kiểm tra kích thước, còn `scripts\modelleri_indir.ps1 -Dogrula` sẽ chạy kiểm tra sha256 đầy đủ), chạy một phép kiểm tra thực ngắn, và chỉ in READY nếu phép kiểm tra đó đạt [thiết kế: `kur.ps1` chưa từng được chạy đầy đủ trong một thư mục sạch; câu này sẽ được cập nhật sau bài kiểm tra thư mục sạch]. `-ExecutionPolicy Bypass` chỉ áp dụng cho một tiến trình này; như với mọi trình cài đặt, hãy đọc `scripts\kur.ps1` trước.
   Zip engine được tải từ bản release v0.1.0 trên GitHub (phát hành ngày 2026-11-19; sha256 của nó được ghim cố định trong `kur.ps1`). Khi không có mạng hoặc dùng bản build của riêng bạn, hãy cung cấp tệp zip cục bộ: `-MotorZip <path> -CudaZip <path>`. Zip cục bộ cũng được kiểm tra với cùng sha256 đã ghim (tệp `.sha256` nằm cạnh nó bị bỏ qua), nên nó phải là zip của release; với bản build của riêng bạn, trước tiên hãy đặt `VT_MOTOR_SHA256` / `VT_CUDA_SHA256` thành sha256 của bản đó. sha256 sai thì dừng với exit 1. Chỉ `.exe`/`.dll` được đặt vào `engine\bin`; giấy phép và README được đặt vào `engine\lisanslar\<zip name>\`. [đã thử: với các zip dist trước khi phát hành release, tệp sidecar `.sha256` cùng cảnh báo tự tham chiếu, bản nhị phân và các DLL được đặt đúng chỗ, `sd-cli --help` chạy được; sha của các bản nhị phân đã cài khớp (`c5cebe78...`, `e5d3d329...`); bước mô hình và phép kiểm tra 5 khung hình của `kur.ps1` CHƯA được chạy trên GPU thật]
   **Giấy phép mô hình:** trước bước mô hình, trình cài đặt in bản tóm tắt giấy phép (`docs/LISANS_KABUL.txt`, toàn văn ở `docs/LISANS_UYARISI.md`: MiniMax H3 Community License, giới hạn lãnh thổ áp dụng cả cho video được tạo ra, các quy tắc về thương mại và gắn nhãn AI) và yêu cầu bạn chấp nhận (`E` = đồng ý). Hãy đọc trước. Với lần chạy không giám sát, bạn có thể truyền `-LisansKabul E`, nghĩa là chính bạn đã đọc và chấp nhận; đừng thêm nó thay cho người khác. (Với AI agent: hãy làm theo `AGENTS.md`; không bao giờ gõ E khi chưa có sự đồng ý của người dùng.) Nếu không chấp nhận, `kur.ps1` dừng với mã thoát 2 và không tải mô hình nào.
3. **Video đầu tiên của bạn (56 khung hình, khoảng 11 phút trên GTX 1050 Ti của chúng tôi** [đã đo: 641 giây, lần chạy R0, `docs/OLCUMLER.md`; các card khác chưa đo]**)**: khi trình cài đặt in `HAZIR / READY`, hãy chạy
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem docs\ornek_istem_R0.txt -Kare 56
   ```
   (lối tắt: kéo tệp văn bản prompt thả lên `uret.cmd`, hoặc chạy `uret.cmd docs\ornek_istem_R0.txt`: cùng lần chạy 56 khung hình). Video nằm trong `runs\`. Sau đó viết prompt của riêng bạn vào một tệp văn bản (một đoạn tiếng Anh, câu `audio:` tùy chọn) và chạy đoạn clip dài nhất mà chúng tôi hỗ trợ (mặc định, khoảng 57 phút [đã đo: lần chạy U209]):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uret.ps1 -Istem istem.txt -Kare 209
   ```
   `-Kare` theo lưới 17k+5 (56, 73, ... 192, 209); mặc định 209 (8,7 giây), độ dài lớn nhất mà chúng tôi hỗ trợ. VAE chạy trong một tiến trình riêng, không bao giờ chia tile [một lần chạy engine thật qua `uret.ps1` với bản nhị phân release, VAE trong tiến trình riêng, đã đạt ở lần chạy U209].

   Hướng dẫn viết prompt: [`docs/ISTEM_YAZIMI.md`](docs/ISTEM_YAZIMI.md) (mẫu một cú máy liên tục, các đoạn thời gian bằng nhau, hai ví dụ đầy đủ).

| Yêu cầu | Giá trị |
|---|---|
| Hệ điều hành | Windows 10/11, 64 bit |
| GPU | NVIDIA, từ 4 GB trở lên; chỉ được thử trên GTX 1050 Ti (sm_61); biên dự phòng rất hẹp (3777/4096 MiB ở 209 khung hình): màn hình đang bận hoặc trình duyệt có thể làm hỏng lần chạy; chưa thử card 4 GB nào khác |
| RAM | 16 GB (đỉnh khoảng 11 GB; hãy đóng các chương trình khác) |
| Ổ đĩa | trống ít nhất 32 GiB (khuyến nghị 40 GiB trở lên: trong khoảng 32 đến 40 trình cài đặt in cảnh báo, `[VT-W-DISK-PAY]` [đã đo: các lần chạy `-Kuru` với ổ đĩa giả lập]), mô hình đặt trên SSD (ưu tiên NVMe) |
| Dung lượng tải | zip engine 36,8 MB + zip CUDA runtime 567,5 MB [đã đo] + mô hình 31.473.112.040 byte (khoảng 29,3 GiB) [đã đọc: kích thước trong `scripts/modeller.json`]; tổng cộng khoảng 30 GiB |
| Mô hình | Không đi kèm; trình cài đặt tải về theo giấy phép MiniMax (xem cảnh báo bên dưới). Các mô hình (29,3 GiB, 31.473.112.040 byte trong `scripts/modeller.json`) không nằm trong repo hay release này: giới hạn kích thước tệp/release của GitHub áp dụng, và `kur.ps1` tải chúng từ nguồn chính thức kèm xác minh sha256. |

Mã thoát của `kur.ps1`: 0 READY, 1 lỗi, 2 cần người dùng nhập (giấy phép, hoặc chưa có release/zip), 3 phần cứng hoặc ổ đĩa không đủ, 4 đã dừng (tệp DUR). `uret.ps1` chỉ chấp nhận một lần chạy nếu tệp `.avi` tồn tại, số khung hình đúng và log sạch [đã đo: một lần chạy thật qua `uret.ps1` trên bản nhị phân release, lần chạy U209, 209 khung hình, cổng kiểm tra đạt]. Mã thoát của `uret.ps1`: 0 DONE (cổng chất lượng đạt), 1 lỗi hoặc đầu ra không hợp lệ (kể cả video không có luồng âm thanh), 2 đã dừng (tệp DUR), 5 `KAPI RED` (cổng chất lượng không đạt: clip không được chấp nhận, quyết định thuộc về bạn), 6 không chạy được cổng kiểm tra (clip không được chấp nhận). Chi tiết trong AGENTS.md. [đã đo: các mã thoát 0, 1 (video không có tiếng), 5 và 6 trong các kịch bản dùng engine giả và cổng kiểm tra giả; engine thật: mã thoát 0 ở lần chạy U209]

### Khắc phục sự cố (chi tiết: `docs/SIK_HATALAR.md`)
Các dòng lỗi từ script của chúng tôi mang một mã cố định, ví dụ `HATA: [VT-E-DLL] ...` hoặc `UYARI: [VT-W-DISK-PAY] ...`. Hãy tra mã trong [`docs/SIK_HATALAR.md`](docs/SIK_HATALAR.md) (ví dụ neo `#vt-e-dll`) hoặc trong `docs/hata_imzalari.json`, và ghi mã vào issue của bạn. Cột đầu của bảng dưới đây giữ nguyên như được in (không dịch mã và nội dung log).

| Bạn thấy | Ý nghĩa và cách xử lý |
|---|---|
| `STATUS_DLL_NOT_FOUND` / `cudart64_12.dll not found` (#13) | Đừng tự khởi động `sd-cli.exe`; hãy chạy `scripts\kur.ps1`, script này sẽ đặt các DLL CUDA đúng chỗ. |
| `failed during weight preparation` tại `blocks.0` (#1, #3, #5) | Không đủ VRAM ở cổng bộ nhớ: dùng số khung hình nhỏ hơn trên lưới 17k+5, đóng các chương trình GPU khác, giữ nguyên các cờ đi kèm. |
| `retrying with temporal tiling` (#6) | VAE đã chuyển sang chia tile; đầu ra không hợp lệ cho mục đích đánh giá chất lượng. Hãy chạy lại. |
| Lần chạy kết thúc vì hết giới hạn thời gian, không có video (#7) | Tăng `-TavanDk` cho các clip dài (giới hạn thời gian mặc định: 80 phút cho 209 khung hình, do `uret.ps1` đặt; lần chạy 209 khung hình của chúng tôi mất 57 phút [đã đo: lần chạy U209]). |
| Mã thoát trống nhưng hiển thị "finished" (#14) | Script bao ngoài đọc mã thoát quá sớm; hãy chạy lại và kiểm tra tệp video có tồn tại. |
| Hệ thống chậm đi, bị swap (#18) | Engine dùng khoảng 10-11 GB RAM; hãy đóng trình duyệt và các chương trình khác. |
| sha256 không khớp / tải thất bại | Thường là do tải bị ngắt giữa chừng: chạy lại đúng lệnh đó, các tệp đã được xác minh sẽ được bỏ qua. |

**Bị kẹt hay tò mò?** [`SUPPORT.md`](SUPPORT.md) (hỏi ở đâu; thời gian phản hồi là mục tiêu, không phải cam kết) · [`PRIVACY.md`](PRIVACY.md) (không có telemetry; mạng chỉ dùng để tải engine và mô hình từ các máy chủ được liệt kê) · [`SECURITY.md`](SECURITY.md) (báo cáo riêng tư) · [`CONTRIBUTING.md`](CONTRIBUTING.md) (pull request đầu tiên trong 5 bước; không cần GPU cho tài liệu và script).

### Mới trong v0.1.1: thêm tùy chọn (chi tiết: `AGENTS.md`, `docs/SIK_HATALAR.md` 19-23)
Nếu không dùng các tùy chọn này thì trên card 4 GB không có gì thay đổi (phép kiểm tra byte 56 khung hình so với bản tham chiếu của chúng tôi lại đạt với v0.1.1 [đã đo]). Thêm `-Kuru` vào bất kỳ lệnh nào để xem những gì sẽ được chạy.
- `-EndImg`: cung cấp thêm khung hình cuối (khung hình đầu và cuối, "FLF"); tối đa 175 khung hình trên card dưới 8 GB (192 không vừa trên 4 GB), 192 trên card từ 8 GB trở lên. Trên GTX 1050 Ti của chúng tôi, tùy chọn này luôn chạy thành hai tiến trình: 56 khung hình 1040 giây, 175 khung hình 2887 giây (48 phút), cả hai đều đạt cổng kiểm tra [đã đo]. Mẹo viết prompt: `docs/ISTEM_YAZIMI.md`.
- `-W` / `-H`: kích thước khác, ví dụ dọc 384x640; bội số của 32, diện tích ít nhất 640x384 (không bao giờ nhỏ hơn). Chưa thử trên 4 GB; trên card dưới 8 GB, kích thước vượt quá tác vụ lớn nhất mà chúng tôi đã đo sẽ bị từ chối. Ngưỡng của cổng chất lượng được hiệu chỉnh theo 640x384.
- `-TekAsama`: một tiến trình thay vì hai, chỉ dành cho card lớn; không bao giờ tự động bật.
- GPU đời mới hơn (compute capability 7.0+, ví dụ RTX 20/30/40): `GGML_CUDA_CUBLAS_COMPUTE_TYPE=f32` được đặt tự động trừ khi bạn tự đặt; điều này đã khắc phục lỗi video đen hoàn toàn ở 141+ khung hình trên RTX 4070 Ti của người báo lỗi [người dùng báo cáo, issue #1]. Khi không có Python + OpenCV, `uret.ps1` giờ dừng với exit 6 trước tác vụ GPU (không tạo video, không có RED gây hiểu nhầm).
- Cảm ơn @SinanC73 vì báo cáo trên RTX 4070 Ti đã dẫn đến những thay đổi này ([issue #1](https://github.com/alexturkey/VideoTurko/issues/1)).

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

## Hồ sơ tốc độ tùy chọn (gói tốc độ; mặc định tắt)
Không mục nào dưới đây thay đổi lần chạy mặc định (640x384, 209 khung hình, 3414 giây trên card của chúng tôi). Đây là ba ô đã đo nằm ngoài mặc định, mỗi ô là một hồ sơ có tên của `uret.ps1`; chúng cần engine của gói tốc độ (engine bản phát hành cùng các bản vá 0021, 0023, 0024, tất cả mặc định tắt: `docs/YAMALAR.md`). Cài bằng `scripts\kur.ps1 -HizPaketi` (zip cục bộ dùng được với `-MotorZip`), rồi thêm `-Profil <name>`; `-Kuru` in ra những gì sẽ chạy. Gói tốc độ được phát hành cùng phiên bản v0.1.4.

| Hồ sơ | Kích thước, độ dài | Tổng thời gian trên GTX 1050 Ti 4 GB | Trạng thái |
|---|---|---|---|
| (không có, mặc định) | 640x384, tối đa 209 khung hình (8,7 giây) | 209 khung hình: 3414 giây | đã xác minh, không đổi |
| `yuksek832` | 832x480, 141 khung hình (5,9 giây) | khoảng 55-56 phút | dùng được, hai prompt [đã đo] |
| `yuksek832 -Kare 124` | 832x480, 124 khung hình (5,2 giây) | khoảng 45-46 phút, không cần cờ tốc độ | dùng được, hai prompt [đã đo] |
| `yuksek896` | 896x512, 124 khung hình (5,2 giây) | khoảng 56-57,5 phút | dùng được, hai prompt [đã đo] |
| `uzun260` | 640x384, 260 khung hình (10,8 giây) | 78 phút đo được khi không có thoát sớm; với thoát sớm khoảng 71-72 phút [phỏng đoán: chưa đo trọn vẹn qua `uret.ps1`] | có điều kiện và thử nghiệm |

- **Biên hẹp:** ở 832x480 x 141, cổng bộ nhớ chỉ chừa biên một chữ số MB (5,7 và 6,8 MB trong hai lần chạy đầy đủ). Hai prompt dài (1520 và 2041 ký tự) chỉ được kiểm tra bằng cách đọc cổng cho bước 1 và một phần bước 2, không chạy đầy đủ: biên 10,9 và 4,0 MB. Bất kỳ tiến trình nào khác đang giữ bộ nhớ card (trình duyệt, màn hình thứ hai) có thể làm lần chạy thất bại; khi đó hãy dùng `-Kare 124` hoặc kích thước mặc định [đã đo, GTX 1050 Ti 4 GB].
- **`uzun260` có điều kiện:** giới hạn bộ nhớ rất hẹp (đỉnh VRAM 3903 trên 4096 MiB), mức dùng bộ nhớ dùng chung tăng 45 và 61 MiB (giới hạn 68), và không có tham chiếu không cờ để so sánh bằng nhau từng byte, nên nó không được cung cấp như một tính năng thông thường. Bản vá 0023 chỉ được chấp nhận cho riêng ô này.
- **Không cung cấp:** 832x480 ở 158 khung hình không vừa với các bản vá kèm theo (ở cổng của bước 2 thiếu khoảng 280 MB); 175 khung hình chỉ được xem bằng cách đọc cổng (khối đầu thiếu khoảng 275 MB, không chạy đầy đủ). Hồ sơ chỉ cung cấp 141 khung hình. `-Profil` từ chối các kích thước và số khung hình khác (hãy dùng đường mặc định).
- Chất lượng mặc định không bị động đến: 6 bước, cfg 1, VAE không chia ô, 17k+5 khung hình. Ở nơi cờ được bật, đầu ra đã được so sánh từng byte với video không cờ tại các kích thước mà lần chạy không cờ vừa (`docs/YAMALAR.md`); ở 832x480 x 141 và 896x512 x 124 lần chạy không cờ không vừa, nên sự bằng nhau ở đó dựa trên các ô gần nhất, không phải so sánh trực tiếp [đã đo, đã đọc].
- Giai đoạn 1 của lần chạy hai giai đoạn giờ kết thúc ngay khi tệp tiềm ẩn hoàn tất (`VT_ERKEN_CIKIS=0` tắt việc này).

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

## Đây là gì
Một bộ các bản vá nhỏ về bộ nhớ/lập lịch cho stable-diffusion.cpp, cùng công thức chạy, các phép kiểm tra và số liệu đo, giúp MiniMax H3 (DiT 33B; chúng tôi chạy bản GGUF HyperFlow Flash 13.7B Q4_K_M; bộ mã hóa văn bản Qwen3-VL 32B là phần riêng) chạy được trên GPU Pascal 4 GB (GTX 1050 Ti, RAM hệ thống 16 GB).
- Các độ dài một lượt mà chúng tôi thực sự đã tạo ra và vượt qua các cổng chất lượng: 56, 141, 158, 175, 192, 209 khung hình ở 640x384, 24 fps (209 khung hình = 8,7 giây), kèm âm thanh do chính H3 tạo ra [đã đo: 209 khung hình với bản nhị phân release qua `uret.ps1`, lần chạy U209; latent giống hệt từng byte so với lần chạy bản build phát triển; khung hình và âm thanh trong video giống hệt nhau, sha của tệp khác vì container; bằng chứng do tác giả giữ, không có trong repo này]. 209 là độ dài lớn nhất mà chúng tôi đã xem và thấy mượt [người dùng báo cáo, 2026-11-19, đã xem toàn bộ video; tệp: đầu ra F209V2, 8,708 giây].
- **Tuyên bố giống hệt từng byte, nêu đúng phạm vi:** đầu ra chỉ được kiểm tra là giống hệt từng byte so với bản tham chiếu chưa vá ở 56 và 141 khung hình. Với 158/175/192/209 khung hình, chúng tôi dùng cùng các cờ và cùng chuỗi nhị phân; không có tham chiếu byte trực tiếp (bản build chưa vá không thể chạy các độ dài đó trên GPU này).
- Cài đặt chất lượng không bao giờ bị hạ: cùng mô hình/lượng tử hóa, 6 bước, cfg 1, 640x384, cùng seed, VAE không chia tile.
- Chúng tôi không tự nhận là đầu tiên: chúng tôi đã tìm và không thấy ví dụ bên ngoài nào làm được điều này trên 4 GB, nhưng đó không phải là bằng chứng rằng chưa có.

## Cấu trúc thư mục
- `patches/` các bản vá cho một commit stable-diffusion.cpp đã được cố định (xem ghi chú ở đó)
- `scripts/` build, chạy, VAE trong tiến trình riêng, các công cụ hỗ trợ cổng kiểm tra/độ nhất quán (`doku_norm.py`: xem ghi chú về thang đo bên dưới)
- `docs/KURULUM.md` phần cứng, các bước build và chạy (EN+TR)
- `docs/YAMALAR.md` danh sách bản vá, `docs/KANITLAR.md` bằng chứng, `docs/KAPILAR.md` bảng các cổng chất lượng, `docs/OLCUMLER.md` các số đo, `docs/SIK_HATALAR.md` các lỗi thường gặp, `docs/LISANS_UYARISI.md` toàn bộ các mục giấy phép
- Mục lục ngắn của `scripts/`: `hiz_kos3.ps1` script bao ngoài để chạy (`-Kuru` in ra đúng lệnh), `uretim_kapi.ps1` cổng chất lượng, `dikis_denetim.py` kiểm tra đường nối, `doku_norm.py` nhiễu chuẩn hóa theo kết cấu, `bayt_kiyas.py` so sánh byte, `derleme_sablonu.ps1` mẫu build (chỉ dừng tiến trình trợ giúp telemetry của Visual Studio `vctip.exe` được khởi động sau khi chính lần build đó bắt đầu, vì nếu không nó giữ tiến trình build bị treo thêm vài phút; các tiến trình `vctip.exe` khác được để yên)

## Các cổng chất lượng (cách chấp nhận một kết quả)

Cổng này không kiểm tra tính nhất quán của chuyển động (nhảy về kích thước hoặc vị trí của vật thể): hãy xem toàn bộ video trước khi chấp nhận.
1. Số khung hình và âm thanh có mặt; không có dòng dự phòng bộ nhớ hay ALLOC_FAILED trong log.
2. Cổng nhiễu thô: phần dư của bộ lọc trung vị <= 1,5 (thang 0-255).
3. Nhiễu chuẩn hóa theo kết cấu, `scripts/doku_norm.py` (phiên bản của repo này): N = phần dư trung vị / kết cấu Sobel, mỗi 6 khung hình lấy một. **Lưu ý về thang đo:** trong phiên bản này, 10 clip đã đo cho N = 0,034-0,052 (bảng trong `docs/KAPILAR.md`; một phần tư cuối của F192/F209V2 đạt 0,062) và ngưỡng của cổng bổ sung là N <= 0,065. Một cách triển khai khác đo được 0,028-0,036 trên cùng các clip, nên các ngưỡng KHÔNG thể hoán đổi giữa các phiên bản. Với kết cấu rất mịn (các hàng cỏ), N của ảnh sạch là 0,075, nên ngưỡng được đặt theo từng họ cảnh. Một bộ ước lượng tần số cao bền vững (sigma-HH <= 1,5; ảnh sạch 0,74-1,19, thêm nhiễu s=2 cho 2,2-3,0) là cổng bổ sung được khuyến nghị.

Phạm vi: VideoTurko chỉ nói về MỘT lượt chạy duy nhất (tối đa 209 khung hình, khoảng 8,7 giây). Thử nghiệm ghép nối của chính chúng tôi cho thấy đường nối lộ rõ (cảnh không tiếp nối sạch), nên phim dài hơn không nằm trong những gì chúng tôi xác minh. Để ghép nối có hướng dẫn của cộng đồng `docs/KLIP_ZINCIRI.md` và công cụ chỉ dùng CPU của chúng tôi `scripts/zincir.py` (`plan`, `son-kare`, `bagla`; nó không bao giờ khởi động engine); chất lượng phim ghép chúng tôi chưa đo [chưa thử], vì vậy hãy kiểm tra từng đường nối bằng mắt và bằng `scripts/dikis_denetim.py`.
Cài đặt là của bạn: 209 khung hình là mặc định chúng tôi đã thử trên card 4 GB, không phải giới hạn bạn buộc phải dùng. Hãy chọn bất kỳ số khung hình nào trên lưới 17k+5 (56, 73, ... 192, 209; xem `docs/KURULUM.md`), đổi prompt, seed, độ phân giải hoặc bất kỳ cờ nào tùy ý. Clip ngắn hơn cần ít bộ nhớ và thời gian hơn; GPU lớn hơn có thể chứa được nhiều hơn.

## Cảnh báo giấy phép mô hình
**VideoTurko chỉ chứa các bản vá và script (MIT); ai sử dụng mô hình và đầu ra của nó phải tự chịu trách nhiệm về giấy phép MiniMax.** Đây không phải là tư vấn pháp lý. Bên dưới là các điều khoản của MiniMax H3 Community License (ngày 2 tháng 8 năm 2026) được tóm tắt kèm số điều; bản giấy phép mới là văn bản có giá trị ràng buộc: https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

Giấy phép MIT của kho này không bao gồm trọng số mô hình; xem [`NOTICE`](NOTICE). Repo này KHÔNG chứa trọng số mô hình nào (không có tệp MiniMax H3, GGUF HyperFlow-H3-Flash hay VAE). Dự án này không liên kết với MiniMax và không được MiniMax chứng thực. Việc sử dụng thương mại KHÔNG bị cấm (đây không phải giấy phép phi thương mại); các điều kiện nằm bên dưới.

**Lãnh thổ (Applicable Territory)**
- **Lời mở đầu, I.3, I.5:** Toàn thế giới, TRỪ Liên minh châu Âu, Vương quốc Anh, Hàn Quốc (Republic of Korea) và Hoa Kỳ. Việc sử dụng mô hình được coi là chấp nhận giấy phép.
- **II:** Giấy phép giới hạn, miễn phí bản quyền, không thể chuyển nhượng để sử dụng, sao chép, phân phối, tạo tác phẩm phái sinh và sửa đổi, chỉ trong lãnh thổ và tuân thủ thỏa thuận cùng Exhibit A. Những người ở lãnh thổ bị loại trừ có thể xin MiniMax một giấy phép riêng.
- **V.4:** Việc sử dụng, sao chép, sửa đổi, phân phối hoặc hiển thị mô hình, các tác phẩm phái sinh của nó VÀ ĐẦU RA (video/âm thanh được tạo ra) bên ngoài lãnh thổ là không được ủy quyền. **Vì vậy, việc đăng hoặc trình chiếu video được tạo ra tại EU/Anh/Hàn Quốc/Hoa Kỳ nằm ngoài phạm vi giấy phép.**
- **Exhibit A-1:** Sử dụng bên ngoài lãnh thổ vi phạm Acceptable Use Policy.

**Phân phối (III)** (repo này không phân phối mô hình; nếu bạn phân phối)
- **III.1:** Cung cấp cho mọi người nhận một bản sao giấy phép. **III.2:** Đánh dấu các tệp đã sửa đổi bằng thông báo nổi bật.
- **III.3:** Được khuyến khích (không bắt buộc): thông báo "Powered by MiniMax H3", dấu hiệu nhận biết nội dung do AI tạo ra trên các tệp đã tạo, một bài viết công khai.
- **III.4:** Các bản phân phối PHẢI kèm theo một tệp NOTICE với nội dung: "MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
- **Exhibit A-12:** cấm đăng nội dung lên bất kỳ môi trường công khai nào mà không công bố rõ ràng rằng nội dung do máy tạo ra: hãy gắn nhãn các video do AI tạo ra khi đăng (danh sách đầy đủ: `docs/LISANS_UYARISI.md`).
- **III (đoạn cuối):** Bạn có thể thêm bản quyền của riêng mình cho các phần sửa đổi của bạn nhưng không được áp đặt các điều khoản bổ sung hoặc khác về sử dụng/phân phối; các quy tắc về lãnh thổ vẫn áp dụng.

**Điều khoản thương mại (IV)**
- **IV.1:** Nếu sản phẩm/dịch vụ thương mại của bạn tạo ra doanh thu hằng năm trên 20 million USD (hoặc giá trị tương đương), hãy xin TRƯỚC văn bản ủy quyền từ api@minimax.io (tiêu đề "MiniMax H3 licensing - authorization request").
- **IV.2:** Giao diện (UI) của sản phẩm/dịch vụ thương mại sử dụng mô hình phải hiển thị nổi bật "MiniMax H3".

**Hạn chế sử dụng (V)**
- **V.1:** Tuân thủ pháp luật hiện hành (bao gồm tuân thủ thương mại) và Exhibit A. **V.2:** Ràng buộc mọi người mà bạn cấp quyền truy cập bằng các điều khoản bảo vệ ít nhất tương đương các hạn chế này và thông báo cho họ.
- **V.3:** Bạn không được dùng mô hình hoặc ĐẦU RA của nó để cải thiện bất kỳ mô hình AI nào khác (ngoài MiniMax H3 và các phái sinh của nó). (I.11: chưng cất và huấn luyện trên đầu ra tổng hợp khiến một mô hình trở thành "phái sinh"; bản thân đầu ra không phải là phái sinh.)
- **V.5:** Nếu bạn cung cấp cho bên thứ ba một sản phẩm/dịch vụ/dịch vụ lưu trữ tạo ra đầu ra bằng mô hình: trước và trong suốt quá trình vận hành, phải có các biện pháp bảo vệ kỹ thuật và tổ chức hợp lý, cơ chế báo cáo, điều tra kịp thời, và gỡ bỏ/vô hiệu hóa/đình chỉ những người vi phạm lặp lại.

**Nhãn hiệu và quyền (VI)**
- **VI.1:** Bạn sở hữu các tác phẩm phái sinh và phái sinh của mô hình mà bạn tạo ra (tùy thuộc vào quyền của MiniMax). **VI.2:** Tên/nhãn hiệu của MiniMax không được cấp phép (ngoài mức cần thiết để mô tả và phân phối); nhãn hiệu "MiniMax H3" chỉ được dùng để tuân thủ III.3, trong phạm vi lãnh thổ; không được ngụ ý có liên kết.
- **VI.3:** Nếu bạn kiện MiniMax hoặc bất kỳ ai với cáo buộc rằng các tài liệu/đầu ra xâm phạm quyền của bạn, mọi giấy phép của bạn chấm dứt ngay trong ngày hôm đó; bạn phải bảo vệ và bồi thường cho MiniMax trước các khiếu nại của bên thứ ba phát sinh từ việc sử dụng/phân phối của bạn hoặc của người khác.
- **VI.4:** MiniMax không đòi quyền nào đối với đầu ra; bạn và người dùng của bạn chịu trách nhiệm về đầu ra và việc sử dụng chúng.

**Tuyên bố miễn trừ trách nhiệm và chấm dứt (VII, VIII, IX)**
- **VII.1:** Không có nghĩa vụ hỗ trợ/cập nhật. **VII.2:** Mô hình và đầu ra được cung cấp "NGUYÊN TRẠNG" ("AS IS"), không có bảo đảm nào; bạn tự quyết định mức độ phù hợp và chấp nhận rủi ro. **VII.3:** MiniMax và các công ty liên kết không chịu trách nhiệm về bất kỳ thiệt hại nào (trong phạm vi pháp luật cho phép).
- **VIII.1:** Có hiệu lực khi chấp nhận/truy cập. **VIII.2:** Khi vi phạm, MiniMax có thể chấm dứt; bạn phải ngừng sử dụng/phân phối, xóa các bản sao và thông báo cho người nhận (VI.1, VI.3, VII, IX vẫn còn hiệu lực).
- **IX:** Luật của Đặc khu Hành chính Hồng Kông; thẩm quyền xét xử độc quyền của tòa án Hồng Kông (loại trừ CISG của Liên Hợp Quốc).
- **Ghi chú bổ sung:** bộ mã hóa của MiniMax H3 dùng Qwen3-VL-32B (Apache 2.0).

**Chính sách sử dụng chấp nhận được (Acceptable Use Policy, Exhibit A)** (KHÔNG dùng mô hình, các phái sinh hoặc đầu ra cho những mục đích sau)
- A-1 sử dụng bên ngoài lãnh thổ; A-2 vi phạm pháp luật hoặc sở hữu trí tuệ của bên thứ ba; A-3 gây hại cho bản thân hoặc người khác; A-4 dùng lại/phân phối đầu ra để gây hại; A-5 vượt qua các biện pháp bảo vệ; A-6 bóc lột/gây hại cho trẻ vị thành niên; A-7 thông tin sai sự thật có thể kiểm chứng nhằm gây hại cho người khác hoặc tác động đến bầu cử; A-8 tương tác trực tuyến giả (đánh giá giả, v.v.); A-9 phỉ báng, bôi nhọ, quấy rối; A-10 phần mềm độc hại; A-11 dữ liệu cá nhân dùng để gây hại cho người khác; **A-12 đăng nội dung lên bất kỳ môi trường công khai nào (kể cả bài đăng của bot) mà không công bố rõ ràng và nổi bật rằng nội dung do máy tạo ra**; A-13 mạo danh khi không có sự đồng ý; A-14 các quyết định tự động có rủi ro cao trong các lĩnh vực trọng yếu (thực thi pháp luật, nhập cư, y tế, hạ tầng trọng yếu, tín dụng, việc làm, nhà ở, giáo dục, chấm điểm xã hội, bảo hiểm, v.v.); A-15 vi phạm các chuẩn mực xã hội, đạo đức, luân lý của các quốc gia/khu vực khác; A-16 chủ nghĩa cực đoan bạo lực/khủng bố; A-17 phân biệt đối xử/gây hại dựa trên các đặc điểm được bảo vệ; A-18 bóc lột các nhóm dễ bị tổn thương; **A-19 mục đích quân sự**; A-20 hoạt động chuyên môn không được phép/không có giấy phép (tài chính, pháp lý, y tế, v.v.).
- Lưu ý: đây là bản tóm tắt bằng ngôn ngữ thông thường; nếu có nghi ngờ, văn bản giấy phép tiếng Anh được ưu tiên.

## Nhãn bằng chứng

Một bộ nhãn dùng chung cho mọi tài liệu (cách viết cũ trong ngoặc):
- **[đã đo]** (tiếng Anh: measured, TR: ölçtüm, olctum): đã chạy trong dự án này, có đường dẫn bằng chứng.
- **[đã đọc]** (tiếng Anh: read, TR: okudum yol, okudum): đã đọc mã nguồn hoặc script, chưa chạy.
- **[thiết kế]** (tiếng Anh: design, TR: tasarım, tasarim): đã thiết kế, chưa thấy trong một lần chạy thật.
- **[phỏng đoán]** (tiếng Anh: guess, TR: tahmin): chưa được xác minh.
- **[chưa thử]** (tiếng Anh: not tried, TR: denenmedi): chưa từng chạy.
- **[người dùng báo cáo]** (tiếng Anh: user-reported, TR: kullanıcı bildirdi): do người dùng nêu, có ghi ngày; không được đo độc lập.
- **[tính toán]** (tiếng Anh: computed, TR: hesap; cách viết cũ: calculated, hesap): một con số suy ra từ các đầu vào đã đo, bản thân nó không phải là số đo; phép suy ra được viết ngay bên cạnh. [đề xuất] / [öneri] trong văn bản cũ = [phỏng đoán].

Tên các lần chạy được dùng trong ngoặc vuông (là tên lần chạy của riêng chúng tôi, không phải tệp trong repo này): U209 = 209 khung hình với bản nhị phân release qua `uret.ps1`; B209 và B192 = các lần chạy image-to-video (`-InitImg`) ở 209 và 192 khung hình; B56VT2 = bản nhị phân release, 56 khung hình, so với tham chiếu byte 56 khung hình R0; F209b, F209V2, F209V2K = các lần chạy 209 khung hình trên bản build phát triển (chi tiết: `docs/OLCUMLER.md`).

## Hạn chế đã biết
- **Bằng chứng byte** (cách tự tái tạo: `docs/KANITLAR.md`, "R0 ve latent referansi nasil uretilir"; đã xác minh trên card sm_61 của chúng tôi, các GPU khác có thể không giống hệt từng byte [phỏng đoán]): với chuỗi bản vá của chúng tôi (bật các cờ bộ nhớ), một lần chạy 56 khung hình cho sha256 `0979f156d548169b...`, giống hệt bản tham chiếu [đã đo]; ở 141 khung hình, sha256 của latent `E5D028F8632BE4FE...` giống hệt (với các cờ 0013/0014). Các khung hình từ 158 đến 209 không có tham chiếu byte trực tiếp; chuỗi các cổng kiểm tra là bằng chứng. Vượt qua các cổng kiểm tra bằng số liệu không bảo đảm clip tốt: tính nhất quán của chuyển động theo thời gian được kiểm tra bằng mắt (xem `docs/KAPILAR.md`).
- **209 khung hình, dùng bộ cờ nào:** bằng chứng chuỗi byte ở 209 khung hình được lấy với bộ cờ F209V2 trên bản build phát triển (không có cờ block-tail, build không có các bản vá 0019/0020); `uret.ps1` dùng công thức này cho 209 khung hình [đã đọc: script; một lần chạy engine thật qua `uret.ps1` đã đạt ở lần chạy U209].
- Chúng tôi đã xác minh trên một card (GTX 1050 Ti 4 GB); các báo cáo bên ngoài về card khác được liệt kê kèm nhãn trong `docs/KART_PROFILLERI.md` [người dùng báo cáo].
- **Đã đo bản nhị phân nào:** latent 141 khung hình và chuỗi byte được đo bằng các bản build phát triển của chúng tôi. Bản nhị phân release bạn tải về là một bản build mới: cổng byte 56 khung hình của nó đã đạt (mục tiếp theo) và một lần chạy 209 khung hình qua `uret.ps1` đã vượt qua cổng kiểm tra (lần chạy U209, 3414 giây, đỉnh VRAM 3777 MiB) [đã đo]; so với lần chạy 209 của bản build phát triển, latent giống hệt từng byte; trong video, các khung hình (md5) và âm thanh giống hệt nhau, sha256 của tệp AVI khác vì container [đã đo] (xem `docs/OLCUMLER.md`, mục 0).
- **Bản nhị phân release, 56 khung hình:** bản nhị phân release (sd-cli `c5cebe78...`, stable-diffusion.dll `e5d3d329...`) cho kết quả 56 khung hình giống hệt từng byte so với R0 (sha256 `0979f156d548169be03acd1a9d7617102a75333aa48a28d6bbfd1cc5fa3f604d`; md5 từng khung hình và âm thanh giống hệt), chạy trực tiếp với các cờ mặc định (không có biến `SD_*`), mã thoát 0, 601 giây [đã đo: lần chạy B56VT2, 2026-11-19; bằng chứng do tác giả giữ, không có trong repo này]. Phạm vi: chỉ card sm_61 của chúng tôi và 56 khung hình; không phải bài kiểm tra cài đặt clean-root; latent 141 khung hình và chuỗi 209 được đo bằng bản nhị phân cũ hơn và CHƯA được lặp lại với bản này [chưa thử]. Lần thử đầu tiên (B56VT, qua một script trợ giúp) kết thúc âm thầm sau 58 giây, không rõ nguyên nhân [phỏng đoán: áp lực bộ nhớ]; lần thử thứ hai chạy trực tiếp `sd-cli`.
- Các script cài đặt và chạy chưa được xác minh từ một thư mục trống (bài kiểm tra clean-root chưa thực hiện).
- Lộ trình và các bước tiếp theo: `ROADMAP.md`.

## Trạng thái và giới hạn
- Đã xác minh trên một máy (GTX 1050 Ti 4 GB, RAM 16 GB, i7-7700HQ). Các card 4 GB khác và các dung lượng RAM khác có thể cho kết quả khác.
- **Mặc định 209 khung hình (8,7 giây):** đã vượt qua các cổng chất lượng của chúng tôi (nhiễu 1,08, lần chạy F209V2K) [đã đo: 209 khung hình với bản nhị phân release qua `uret.ps1`, lần chạy U209; latent giống hệt từng byte so với lần chạy bản build phát triển; khung hình và âm thanh trong video giống hệt nhau, sha của tệp khác vì container; bằng chứng do tác giả giữ, không có trong repo này]. Ở 209 khung hình, đỉnh VRAM của DiT là 3777 MiB trên 4096 MiB (các lần chạy F209b và U209; số đọc `nvidia-smi` của toàn card), biên dự phòng rất hẹp: tải GPU khác (màn hình, các ứng dụng khác) có thể làm lần chạy thất bại tại `blocks.0`; chỉ được thử trên GTX 1050 Ti. Trạng thái màn hình trong lần chạy đó không được ghi lại; nếu màn hình của bạn chạy trên card này, VRAM khả dụng sẽ ít hơn [phỏng đoán: tải hiển thị của Windows khoảng 100-300 MB]; nếu cần, hãy nối màn hình vào GPU tích hợp [khuyến nghị, chưa kiểm thử]. Quá trình sampling mất 2730 giây (lần chạy U209: các bước 436-483 giây) và giải mã VAE trong tiến trình riêng mất 173 giây (giai đoạn 2 tổng cộng 193 giây gồm cả giải mã âm thanh) [đã đo: bản nhị phân release U209; các lần chạy bản build phát triển trước đó: 2664 giây và 174 giây]. Ở giai đoạn 1, VAE trong tiến trình hết bộ nhớ và chuyển sang temporal tiling (320 giây); đầu ra đó bị loại bỏ, video đến từ giai đoạn 2 không chia tile. Đỉnh RAM không được đo ở U209. Các clip dài hơn 209 khung hình không thuộc bản phát hành này.
- **Image-to-video (`-InitImg`):** với ảnh khởi tạo, giới hạn trên GPU này là 192 khung hình (8,0 giây ở 24 fps): 209 khung hình không vừa (thiếu khoảng 17,5 MB VRAM tại block 0: cần 2587 MB, khả dụng 2570 MB); 192 khung hình đã chạy qua `uret.ps1` trong 3086 giây với đỉnh VRAM 3783 MiB và cổng kiểm tra đạt [đã đo: các lần chạy B209 và B192, 2026-11-20, một cảnh; bằng chứng do tác giả giữ, không có trong repo này]. Chưa thử trên các GPU khác [chưa thử].
- **RAM trống quan trọng:** bạn cần khoảng 11 GB RAM TRỐNG (tiến trình engine giữ khoảng 11 GB) [đã đo]. Khi RAM trống quá ít, tiến trình có thể chết mà không có thông báo lỗi [phỏng đoán: chúng tôi đã quan sát một lần khi RAM trống khoảng 300 MB trong lúc `sd-cli` giữ khoảng 10 GB]. Đừng mở các chương trình lớn khác khi đang chạy: trên máy 16 GB chỉ còn trống khoảng 0,3-0,5 GB, và dưới áp lực bộ nhớ, lần chạy có thể chết trong im lặng. Trước khi bắt đầu, hãy đóng trình duyệt, game và các chương trình lớn khác rồi kiểm tra RAM trống.
- **Bài kiểm tra clean-root chưa thực hiện:** các script cài đặt và chạy chưa được xác minh từ một thư mục trống chỉ bằng các hướng dẫn này; mục này sẽ được cập nhật khi bài kiểm tra đó (gồm cả phép so sánh byte 56 khung hình với bản tham chiếu) được ghi nhận.
- Không có video được tạo ra nào đi kèm ở đây.

<!-- i18n-source: README.md sha256:4d4973e30a37 -->
