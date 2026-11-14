# YugiLan – Tailscale Manager cho máy chơi game cầm tay

Script quản lý **Tailscale** (VPN mesh) dành cho các máy handheld:

| Máy / Hệ điều hành | Hỗ trợ |
|---|---|
| **R36S** (ArkOS và các bản clone) | ✅ |
| **Trimui** (Brick, Smart Pro, Smart, Model S) | ✅ |
| **muOS** | ✅ |

Script **tự nhận diện máy** (OS, thiết bị, kiến trúc CPU) rồi cài Tailscale theo cách phù hợp. Bạn chỉ cần chép file vào máy, mở lên và làm theo menu.

> Lời giới thiệu ngắn: Tailscale giúp máy của bạn "nằm chung một mạng riêng" với điện thoại, laptop, PC ở bất cứ đâu, không cần mở port hay chỉnh router.

> Credit: ý tưởng và bản gốc cho R36S là của **SjslTech**. Bản này được mở rộng để chạy trên muOS và Trimui.

---

## 1. Chuẩn bị

Bạn cần:

1. **Máy handheld** đã cài sẵn một trong các hệ điều hành: ArkOS (R36S), muOS hoặc Trimui (stock / NextUI / MinUI).
2. **Kết nối Wi-Fi** hoạt động trên máy (xem mục 4 của từng thiết bị).
3. **Đầu đọc thẻ nhớ** (hoặc cáp USB) để chép file vào thẻ SD.
4. **Tài khoản Tailscale** (miễn phí): vào <https://login.tailscale.com>, đăng nhập bằng Google, Microsoft, GitHub hoặc Apple. Nên tạo sẵn tài khoản trước.
5. Điện thoại hoặc máy tính để **mở link xác thực** khi script hiện ra.

---

## 2. Tải script về

Có 2 cách, chọn cách nào cũng được.

### Cách A – Tải cả kho (dễ nhất)

1. Mở trang <https://github.com/truongliu75-sketch/YugiLan>
2. Bấm nút xanh **Code** → **Download ZIP**.
3. Giải nén file ZIP, bạn sẽ thấy file **`Tailscale_Manager.sh`**.

### Cách B – Tải trực tiếp 1 file

1. Mở link: <https://github.com/truongliu75-sketch/YugiLan/raw/refs/heads/main/Tailscale_Manager.sh>
2. Trình duyệt hiện chữ → bấm chuột phải → **Lưu thành…** (Save as).
3. Đặt tên đúng là `Tailscale_Manager.sh`.

### ⚠️ Lỗi thường gặp khi tải trên Windows

- **Đuôi file bị đổi thành `.txt`** (thành `Tailscale_Manager.sh.txt`). Hãy bật *Hiện đuôi file* trong File Explorer (View → File name extensions) rồi đổi lại tên cho đúng.
- **Không mở file bằng Notepad rồi lưu lại**: Notepad có thể đổi kiểu xuống dòng (CRLF) làm script lỗi. Nếu cần sửa, dùng **Notepad++** và chọn kiểu xuống dòng **Unix (LF)**.

---

## 3. Chép file vào máy

Tắt máy → rút thẻ SD → cắm vào máy tính → chép file theo bảng dưới.

> Vị trí thư mục có thể khác nhau tùy bản firmware/phiên bản. Nếu bạn không thấy script trong menu, hãy xem phần **Xử lý sự cố** ở cuối.

| Thiết bị | Chép `Tailscale_Manager.sh` vào | Mở ở đâu trên máy |
|---|---|---|
| **R36S (ArkOS)** | Thẻ **EASYROMS** → thư mục `tools` | EmulationStation → mục **Options / Tools** |
| **muOS** | Thẻ SD1 → `MUOS/application` (hoặc thư mục Ports nếu bản của bạn dùng Ports) | Menu **Applications** |
| **Trimui (stock)** | Thẻ SD → thư mục `Apps` (tạo thư mục con `Tailscale`) | Menu **Apps** |
| **Trimui (NextUI / MinUI)** | Thẻ SD → `Tools/tg5040/Tailscale.pak` (đổi tên script thành `launch.sh`) | Mục **Tools** |

Mẹo: nếu thư mục `tools` / `Apps` chưa có, hãy mở thử một lần trên máy để hệ thống tự tạo, hoặc tự tạo thư mục mới.

Sau khi chép xong: **Eject (Safely remove)** thẻ SD trên máy tính, cắm lại vào máy và bật nguồn.

---

## 4. Hướng dẫn chi tiết từng thiết bị

### 4.1. R36S (ArkOS)

1. **Bật Wi-Fi**: vào mục **Options** → **Wifi** → chọn mạng → nhập mật khẩu. R36S bản gốc không có Wi-Fi sẵn nên cần **USB Wi-Fi dongle** cắm vào cổng USB-C/OTG (một số bản clone có Wi-Fi tích hợp).
2. Chép script vào `EASYROMS/tools` như bảng trên.
3. Trong EmulationStation, **cập nhật danh sách game** (Start → Game settings → Update gamelists) nếu chưa thấy script.
4. Mở **Options (hoặc Tools)** → chọn **Tailscale_Manager**.
5. Điều khiển: **D-pad** để di chuyển, **A** để chọn, **B** để thoát.
6. Máy R36S dùng ArkOS nên script sẽ cài Tailscale **chính thức** bằng `apt` (cần Internet ổn định).

### 4.2. muOS

1. **Bật Wi-Fi**: vào **Configuration** → **Network** → bật Network → nhập SSID, mật khẩu → **Connect**. Chờ hiện địa chỉ IP.
2. Chép script vào thư mục ứng dụng như bảng trên.
3. Vào **Applications** → chọn **Tailscale_Manager**.
4. Script nhận ra muOS và cài bản Tailscale **dạng file chạy độc lập** (do muOS không có `apt`). Dữ liệu được lưu trong thư mục `tailscale_data` nằm cạnh script.
5. Dùng **D-pad + A/B** để thao tác.

### 4.3. Trimui (Brick, Smart Pro, Smart…)

1. **Bật Wi-Fi**: vào **Settings** → **Wi-Fi** → chọn mạng → nhập mật khẩu.
2. Chép script vào thư mục `Apps` (stock) hoặc `Tools` (NextUI/MinUI) như bảng trên.
3. Mở từ menu **Apps / Tools** → chọn **Tailscale**.
4. Script tự nhận ra thiết bị (vd: Trimui Brick / Smart Pro) và đặt tên máy trên Tailscale tương ứng, ví dụ `trimui-tg5040`.

---

## 5. Sử dụng lần đầu (giống nhau trên mọi máy)

Menu chính có 6 mục:

| Mục | Chức năng |
|---|---|
| 1. Check Status / View IP | Xem trạng thái và địa chỉ IP Tailscale của máy |
| 2. Install / Link (Show URL) | Cài Tailscale (nếu chưa có) và hiện link đăng nhập |
| 3. Stop Tailscale Service | Tắt dịch vụ Tailscale |
| 4. Start Tailscale Service | Bật dịch vụ Tailscale |
| 5. Uninstall Tailscale | Gỡ Tailscale hoàn toàn |
| 6. Exit | Thoát script |

### Các bước cài và liên kết

1. Đảm bảo máy **đang có Internet**.
2. Chọn **2. Install / Link**.
3. Chờ script tải và cài (có thể mất vài chục giây tới vài phút tùy mạng).
4. Màn hình hiện một **link màu đỏ** dạng `https://login.tailscale.com/a/xxxxxxxx`.
5. Dùng **điện thoại hoặc máy tính** mở link đó (gõ lại cẩn thận, hoặc chụp màn hình để đọc).
6. Đăng nhập tài khoản Tailscale → bấm **Connect / Authorize** để duyệt thiết bị.
7. Quay lại máy handheld, bấm **OK**.
8. Chọn **1. Check Status** → nếu thấy **"Tailscale is ONLINE"** cùng địa chỉ IP dạng `100.x.x.x` là thành công. 🎉

Bạn cũng có thể kiểm tra trên trang <https://login.tailscale.com/admin/machines>: máy của bạn sẽ xuất hiện trong danh sách.

---

## 6. Dùng sau khi cài

- Các máy khác (điện thoại, PC) cài ứng dụng Tailscale và đăng nhập **cùng tài khoản** để thấy máy handheld của bạn.
- Máy chạy ở chế độ *userspace networking* (muOS / Trimui): máy handheld ra được mạng Tailscale bình thường, nhưng việc **máy khác kết nối ngược vào** máy handheld có thể bị hạn chế tùy dịch vụ.
- **Script không tự chạy khi bật máy.** Mỗi lần khởi động lại, mở script và chọn **4. Start Tailscale Service** (máy đã đăng nhập rồi thì không cần liên kết lại).
- Muốn tắt tạm: chọn **3. Stop Tailscale Service**.
- Muốn xóa hẳn: chọn **5. Uninstall Tailscale**. Sau đó vào trang admin Tailscale xóa luôn máy cũ khỏi danh sách (nếu muốn).

---

## 7. Cài offline (khi máy không tải được)

Nếu Wi-Fi yếu hoặc báo lỗi tải về:

1. Trên máy tính, vào <https://pkgs.tailscale.com/stable/> và tải file phù hợp CPU:
   - Máy 64-bit (Trimui Brick/Smart Pro, đa số R36S, muOS): `tailscale_x.y.z_arm64.tgz`
   - Máy 32-bit: `tailscale_x.y.z_arm.tgz`
2. **Đừng giải nén.** Chép nguyên file `.tgz` vào **cùng thư mục** với `Tailscale_Manager.sh`.
3. Mở script → chọn **2. Install / Link**. Script sẽ dùng file có sẵn thay vì tải.

---

## 8. Xử lý sự cố

| Triệu chứng | Cách xử lý |
|---|---|
| Không thấy script trong menu máy | Kiểm tra lại thư mục chép vào (mục 3), đảm bảo tên file đúng `.sh`, rồi khởi động lại máy / cập nhật danh sách game. |
| Bấm mở nhưng báo lỗi hoặc thoát ngay | File có thể bị đổi kiểu xuống dòng. Tải lại file gốc, **không sửa bằng Notepad**. |
| "Download failed" | Kiểm tra Wi-Fi, thử lại, hoặc dùng **cài offline** (mục 7). |
| Link đăng nhập hết thời gian | Chọn lại **2. Install / Link** để lấy link mới. |
| Status báo OFFLINE / UNLINKED | Chọn **2. Install / Link** và xác thực lại bằng link mới. |
| Sau khi tắt máy bật lại bị mất kết nối | Bình thường. Mở script → **4. Start Tailscale Service**. |
| Không chọn được bằng nút | Máy có thể chưa có `gptokeyb`. Thử cập nhật PortMaster (nếu có), hoặc báo lỗi kèm tên firmware ở mục Issues. |
| Muốn xem nhật ký lỗi | Mở file `tailscale_data/tailscaled.log` (cạnh script) trên máy tính. |

---

## 9. Lưu ý an toàn

- **Không chia sẻ link xác thực** (`login.tailscale.com/a/...`) cho người khác: ai bấm duyệt được link đó sẽ thêm thiết bị vào tài khoản của bạn.
- Hãy bật **xác thực 2 bước** cho tài khoản Google / Microsoft bạn dùng đăng nhập Tailscale.
- Khi bán hoặc cho người khác mượn máy, chọn **Uninstall** và xóa thiết bị trên trang admin Tailscale.

---

## 10. Báo lỗi / đóng góp

Nếu gặp lỗi, hãy mở **Issues** trên GitHub và ghi rõ:

- Tên máy (vd: Trimui Brick, R36S, ...)
- Hệ điều hành + phiên bản (vd: muOS 2410, ArkOS, NextUI, ...)
- Mô tả lỗi và (nếu có) nội dung file `tailscaled.log`.
