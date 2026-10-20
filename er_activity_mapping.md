# Phân tích ánh xạ nghiệp vụ và dữ liệu (ER-Activity Mapping)

Trong mô hình nghiệp vụ của AutoRide, quá trình trả xe có các nhánh rẽ quan trọng là tính phạt trễ giờ (late_fee) và ghi nhận hư hỏng để phạt sửa chữa (damage_fee). 
- **Lý do cần cột `damage_fee`**: Thiết kế cũ hoàn toàn bỏ trống các trường tài chính này, khiến nhân viên không có chỗ lưu trữ số tiền đền bù, dẫn đến việc phải trả lại toàn bộ tiền cọc cho khách dù xe bị hư hỏng (bốc hơi lợi nhuận) hoặc phải ghi sổ tay ngoài hệ thống. 
- **Lý do cần bảng `Inspections`**: Việc tách biên bản kiểm tra xe thành một bảng riêng liên kết khóa ngoại với `Rentals` giúp lưu trữ chi tiết lịch sử kiểm tra, vị trí hư hỏng và mô tả lỗi một cách minh bạch, tránh làm phình to hoặc sai lệch cấu trúc của bảng hợp đồng chính.
