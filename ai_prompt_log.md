# Nhật ký sử dụng AI (AI Prompt Log) - AutoRide

- **Câu hỏi 1:** Trao đổi về việc tối ưu hóa kiểu dữ liệu `DECIMAL(10,2)` thay vì `FLOAT` khi lưu trữ các trường tài chính như `security_deposit`, `late_fee`, `damage_fee` để tránh sai số làm tròn số học (Precision error).
- **Câu hỏi 2:** Phân tích sự khác biệt giữa quan hệ 1-1 và 1-N khi thiết kế bảng lưu trữ Biên bản kiểm tra xe (`Inspections`) và quyết định chọn quan hệ 1-N (một hợp đồng có thể trải qua nhiều lần kiểm tra hoặc biên bản lịch sử).
- **Câu hỏi 3:** Nhờ AI hỗ trợ xây dựng câu lệnh `SELECT` kết hợp hàm `COALESCE` để tính toán chính xác số tiền hoàn lại (`refund_amount`) cho khách hàng và xử lý an toàn các giá trị trống.
