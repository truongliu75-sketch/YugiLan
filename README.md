# Yugi Oh Power Chaos Joey Mod – Game Yugi cho máy handheld (R36S, Trimui, muOS)

Game bài **Yugi** chạy trên máy chơi game cầm tay, kèm script **Tailscale** để chơi qua mạng LAN / chơi từ xa như đang ở chung mạng.

| Máy / Hệ điều hành | Hỗ trợ |
|---|---|
| **R36S** (ArkOS và bản clone) | ✅ |
| **Trimui** (Brick, Smart Pro, Smart, Model S) | ✅ |
| **muOS** | ✅ |

**Bài này có 2 phần:**
1. **Phần 1 – Tải và cài game Yugi** (làm trước).
2. **Phần 2 – Cài Tailscale** (tùy chọn, dùng khi muốn chơi qua mạng).

---
<img width="1536" height="2048" alt="image" src="https://github.com/user-attachments/assets/3060a7a9-b6cf-4371-9385-131922a92b53" />

# PHẦN 1 – TẢI VÀ CÀI GAME YUGI

## 1. Có gì trong bản phát hành

Theo ghi chú trong trang Releases, game đã qua các mốc cập nhật:

- **2.9**: thêm lá phép
- **3.0**: hệ thống Level
- **3.7**: +100 lá bài mới
- **3.8 / 3.9.6**: các bản cập nhật nhỏ
- **4.0**: chế độ **Leo tháp**
- **4.0.17**: chế độ **Luật đấu mạng bốc ngẫu nhiên 1 bộ trong 12 bộ**
Luôn tải bản mới nhất ở mục Releases để có đầy đủ tính năng.

## 2. Chuẩn bị

1. Máy handheld chạy **ArkOS (R36S)**, **muOS** hoặc **Trimui** (stock / NextUI / MinUI).
2. **Đầu đọc thẻ SD** để chép file từ máy tính.
3. Dung lượng thẻ còn trống (nên dư vài trăm MB).
4. Game này là **game Port** (định dạng giống các game trong PortMaster): gồm **1 file `.sh`** (file khởi chạy) và **1 thư mục** chứa dữ liệu game. Hai thứ này phải đặt **cạnh nhau** trong thư mục Ports.
5. Khuyên cài sẵn **PortMaster** trên máy (xem mục 5). Nhiều game Port cần thư viện đi kèm (runtime) mà PortMaster sẽ cài giúp.

## 3. Tải game

1. Mở trang: <https://github.com/truongliu75-sketch/YugiLan/releases/tag/ygi>
2. Kéo xuống mục **Assets**. Nếu chỉ thấy chữ "Assets", bấm vào để mở rộng danh sách file.
3. Bấm vào tên file `.zip` của game để tải về **máy tính**. (Không cần tải "Source code").
4. Giải nén file `.zip` bằng chuột phải → **Extract here** (Windows: 7-Zip hoặc WinRAR). Sau khi giải nén bạn sẽ có:
   - 1 file **`.sh`** (ví dụ `Yugi.sh`)
   - 1 **thư mục** game (ví dụ `yugi/`)
5. Nếu Assets có nhiều file, hãy đọc kỹ tên file: file nào ghi tên máy / hệ điều hành thì tải đúng loại cho máy của bạn.

> Lưu ý Windows: đừng mở file `.sh` bằng Notepad rồi lưu lại, vì sẽ làm hỏng kiểu xuống dòng và game không chạy được.

## 4. Chép game vào máy (chi tiết từng thiết bị)

**Quy tắc chung:** chép **cả file `.sh` và thư mục game** vào **thư mục Ports** của hệ điều hành. Tắt máy trước khi rút thẻ SD. Chép xong thì **Eject** thẻ rồi mới rút.

### 4.1. R36S (ArkOS)

1. Cắm thẻ SD vào máy tính. Mở phân vùng **EASYROMS**.
2. Vào thư mục **`ports`**.
3. Chép **file `.sh`** và **thư mục game** vào thẳng thư mục `ports` (không bỏ vào thư mục con khác).
4. Đường dẫn cuối cùng sẽ giống:
   ```
   EASYROMS/ports/Yugi.sh
   EASYROMS/ports/yugi/
   ```
5. Cắm thẻ lại, bật máy → EmulationStation → **Start → Game Settings → Update Gamelists** (cập nhật danh sách game).
6. Mở hệ thống **Ports** → chọn **Yugi** → bấm **A**.

Nếu máy dùng **thẻ SD thứ 2** cho game, thư mục này nằm ở thẻ thứ 2 (cũng có tên `ports`).

### 4.2. muOS

1. Cắm thẻ SD (SD1) vào máy tính.
2. Cài **PortMaster** nếu chưa có (mục 5), rồi cài thử 1 game bất kỳ từ PortMaster.
3. Mở thư mục chứa game đó trên thẻ SD. Đó là thư mục Ports của máy bạn. Thường là:
   ```
   ROMS/Ports/
   ```
   (hoặc `ports/` / `PORTS/` tùy phiên bản muOS, **hãy chép giống chỗ game PortMaster đã cài**).
4. Chép **file `.sh`** và **thư mục game** của Yugi vào đúng thư mục đó, cạnh các game Port khác.
5. Cắm thẻ lại, bật máy. Trong muOS, mở **Explore Content** (hoặc mục Ports) → **Ports** → chọn **Yugi**. Nếu chưa thấy, vào **Configuration → General Settings → Advanced → Refresh / Rescan content** (hoặc khởi động lại máy).

### 4.3. Trimui (Brick / Smart Pro / Smart…)

**Trimui stock OS:**
1. Cắm thẻ SD vào máy tính, mở thư mục **`Roms`**.
2. Vào thư mục **`PORTS`** (nếu chưa có, tạo thư mục tên `PORTS`).
3. Chép **file `.sh`** và **thư mục game** vào đó:
   ```
   Roms/PORTS/Yugi.sh
   Roms/PORTS/yugi/
   ```
4. Cắm thẻ lại, bật máy → vào mục **Ports** trong menu chính → chọn **Yugi**.

**NextUI / MinUI trên Trimui:**
1. Mở thư mục **`Roms`** → thư mục **`Ports (PORTS)`**.
2. Chép **file `.sh`** và **thư mục game** vào đó.
3. Trong menu, chọn **Ports** → **Yugi**.

> Nếu thư mục Ports của bạn có tên hơi khác, hãy chép vào **đúng chỗ các game Port khác (hoặc game cài từ PortMaster) đang nằm**. Đây là cách chắc chắn nhất.

## 5. Cài PortMaster (khuyến nghị, làm 1 lần)

PortMaster là kho game Port chính thức, đồng thời cài các thư viện cần thiết cho game Port. Tải tại <https://portmaster.games>, làm theo hướng dẫn cho đúng hệ điều hành của bạn (ArkOS, muOS, Trimui). Cần **Wi-Fi** trên máy để PortMaster hoạt động. Sau khi cài PortMaster, hãy cài thử 1 game bất kỳ để chắc là hệ thống đã sẵn sàng, rồi mới chép Yugi.

## 6. Chạy game lần đầu

1. Mở mục **Ports** → chọn **Yugi** → bấm **A**.
2. Lần đầu có thể mất vài chục giây để khởi động, màn hình có thể đen một lúc. Hãy chờ.
3. Dùng **D-pad** để di chuyển, **A** để chọn, **B** để quay lại (có thể khác một chút tùy máy).
4. Game lưu tiến trình ngay trong thư mục game, nên **không đổi tên hoặc xóa thư mục** khi đang chơi.

## 7. Game không chạy? Thử các cách sau

| Triệu chứng | Cách xử lý |
|---|---|
| Không thấy game trong menu Ports | Chép lại đúng thư mục Ports (mục 4), rồi cập nhật danh sách game hoặc khởi động lại máy. |
| Báo thiếu runtime / "Thieu LOVE runtime (love_11.5)" | Game dùng engine **LÖVE** nên cần **runtime `love_11.5`**. Mở **PortMaster** → cài (hoặc cập nhật) runtime **love_11.5** (thường nằm ở mục *Runtimes* hoặc tự tải khi cài một game LÖVE bất kỳ). Cần Wi-Fi. Xem thêm mục 7.1. |
| Mở lên rồi tự thoát ngay | Cài **PortMaster** (mục 5) để có đủ thư viện. Kiểm tra file `.sh` và thư mục game có nằm **cạnh nhau**. |
| Màn hình đen mãi | Chờ 1 phút. Nếu vẫn đen, tắt máy, chép lại game từ file zip gốc (có thể chép bị lỗi). |
| Báo thiếu file | Giải nén **đủ** file zip, đừng chép từng phần. |
| Lỗi file `.sh` | Tải lại, không sửa bằng Notepad. |
| Không có tiếng / không nhận nút | Thử khởi động lại máy; cập nhật firmware / PortMaster. |

## 8. Cập nhật game

Khi có bản mới trong Releases: Vào cài đặt trong game, chỉ cần vào đó cập nhật (yêu cầu **Wifi**).

---

# PHẦN 2 – CÀI TAILSCALE (CHƠI QUA MẠNG)

Phần này dành cho việc cài **Tailscale** để các máy (và điện thoại, PC) nằm chung một mạng riêng, không cần mở port hay chỉnh router. Làm theo các bước dưới đây với file `Tailscale_Manager.sh` trong kho này.

### T1. Chuẩn bị

Bạn cần:

1. **Máy handheld** đã cài sẵn một trong các hệ điều hành: ArkOS (R36S), muOS hoặc Trimui (stock / NextUI / MinUI).
2. **Kết nối Wi-Fi** hoạt động trên máy (xem mục T4 của từng thiết bị).
3. **Đầu đọc thẻ nhớ** (hoặc cáp USB) để chép file vào thẻ SD.
4. **Tài khoản Tailscale** (miễn phí): vào <https://login.tailscale.com>, đăng nhập bằng Google, Microsoft, GitHub hoặc Apple. Nên tạo sẵn tài khoản trước.
5. Điện thoại hoặc máy tính để **mở link xác thực** khi script hiện ra.

---

### T2. Tải script về

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

### T3. Chép file vào máy

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

### T4. Hướng dẫn chi tiết từng thiết bị

#### 4.1. R36S (ArkOS)

1. **Bật Wi-Fi**: vào mục **Options** → **Wifi** → chọn mạng → nhập mật khẩu. R36S bản gốc không có Wi-Fi sẵn nên cần **USB Wi-Fi dongle** cắm vào cổng USB-C/OTG (một số bản clone có Wi-Fi tích hợp).
2. Chép script vào `EASYROMS/tools` như bảng trên.
3. Trong EmulationStation, **cập nhật danh sách game** (Start → Game settings → Update gamelists) nếu chưa thấy script.
4. Mở **Options (hoặc Tools)** → chọn **Tailscale_Manager**.
5. Điều khiển: **D-pad** để di chuyển, **A** để chọn, **B** để thoát.
6. Máy R36S dùng ArkOS nên script sẽ cài Tailscale **chính thức** bằng `apt` (cần Internet ổn định).

#### 4.2. muOS

1. **Bật Wi-Fi**: vào **Configuration** → **Network** → bật Network → nhập SSID, mật khẩu → **Connect**. Chờ hiện địa chỉ IP.
2. Chép script vào thư mục ứng dụng như bảng trên.
3. Vào **Applications** → chọn **Tailscale_Manager**.
4. Script nhận ra muOS và cài bản Tailscale **dạng file chạy độc lập** (do muOS không có `apt`). Dữ liệu được lưu trong thư mục `tailscale_data` nằm cạnh script.
5. Dùng **D-pad + A/B** để thao tác.

#### 4.3. Trimui (Brick, Smart Pro, Smart…)

1. **Bật Wi-Fi**: vào **Settings** → **Wi-Fi** → chọn mạng → nhập mật khẩu.
2. Chép script vào thư mục `Apps` (stock) hoặc `Tools` (NextUI/MinUI) như bảng trên.
3. Mở từ menu **Apps / Tools** → chọn **Tailscale**.
4. Script tự nhận ra thiết bị (vd: Trimui Brick / Smart Pro) và đặt tên máy trên Tailscale tương ứng, ví dụ `trimui-tg5040`.

---

### T5. Sử dụng lần đầu (giống nhau trên mọi máy)

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

### T6. Dùng sau khi cài

- Các máy khác (điện thoại, PC) cài ứng dụng Tailscale và đăng nhập **cùng tài khoản** để thấy máy handheld của bạn.
- Máy chạy ở chế độ *userspace networking* (muOS / Trimui): máy handheld ra được mạng Tailscale bình thường, nhưng việc **máy khác kết nối ngược vào** máy handheld có thể bị hạn chế tùy dịch vụ.
- **Script không tự chạy khi bật máy.** Mỗi lần khởi động lại, mở script và chọn **4. Start Tailscale Service** (máy đã đăng nhập rồi thì không cần liên kết lại).
- Muốn tắt tạm: chọn **3. Stop Tailscale Service**.
- Muốn xóa hẳn: chọn **5. Uninstall Tailscale**. Sau đó vào trang admin Tailscale xóa luôn máy cũ khỏi danh sách (nếu muốn).

---

### T7. Cài offline (khi máy không tải được)

Nếu Wi-Fi yếu hoặc báo lỗi tải về:

1. Trên máy tính, vào <https://pkgs.tailscale.com/stable/> và tải file phù hợp CPU:
   - Máy 64-bit (Trimui Brick/Smart Pro, đa số R36S, muOS): `tailscale_x.y.z_arm64.tgz`
   - Máy 32-bit: `tailscale_x.y.z_arm.tgz`
2. **Đừng giải nén.** Chép nguyên file `.tgz` vào **cùng thư mục** với `Tailscale_Manager.sh`.
3. Mở script → chọn **2. Install / Link**. Script sẽ dùng file có sẵn thay vì tải.

---

### T8. Xử lý sự cố

| Triệu chứng | Cách xử lý |
|---|---|
| Không thấy script trong menu máy | Kiểm tra lại thư mục chép vào (mục T3), đảm bảo tên file đúng `.sh`, rồi khởi động lại máy / cập nhật danh sách game. |
| Bấm mở nhưng báo lỗi hoặc thoát ngay | File có thể bị đổi kiểu xuống dòng. Tải lại file gốc, **không sửa bằng Notepad**. |
| "Download failed" | Kiểm tra Wi-Fi, thử lại, hoặc dùng **cài offline** (mục T7). |
| Link đăng nhập hết thời gian | Chọn lại **2. Install / Link** để lấy link mới. |
| Status báo OFFLINE / UNLINKED | Chọn **2. Install / Link** và xác thực lại bằng link mới. |
| Sau khi tắt máy bật lại bị mất kết nối | Bình thường. Mở script → **4. Start Tailscale Service**. |
| Không chọn được bằng nút | Máy có thể chưa có `gptokeyb`. Thử cập nhật PortMaster (nếu có), hoặc báo lỗi kèm tên firmware ở mục Issues. |
| Muốn xem nhật ký lỗi | Mở file `tailscale_data/tailscaled.log` (cạnh script) trên máy tính. |

---

### T9. Lưu ý an toàn

- **Không chia sẻ link xác thực** (`login.tailscale.com/a/...`) cho người khác: ai bấm duyệt được link đó sẽ thêm thiết bị vào tài khoản của bạn.
- Hãy bật **xác thực 2 bước** cho tài khoản Google / Microsoft bạn dùng đăng nhập Tailscale.
- Khi bán hoặc cho người khác mượn máy, chọn **Uninstall** và xóa thiết bị trên trang admin Tailscale.

---

### T10. Báo lỗi / đóng góp

Nếu gặp lỗi, hãy mở **Issues** trên GitHub và ghi rõ:

- Tên máy (vd: Trimui Brick, R36S, ...)
- Hệ điều hành + phiên bản (vd: muOS 2410, ArkOS, NextUI, ...)
- Mô tả lỗi và (nếu có) nội dung file `tailscaled.log`.
