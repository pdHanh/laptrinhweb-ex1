-- 1. Liệt kê các hóa đơn của khách hàng: mã user, tên user, mã hóa đơn
SELECT u.user_id, u.user_name, o.order_id
FROM users u
JOIN orders o ON u.user_id = o.user_id;

-- 2. Liệt kê số lượng các hóa đơn của khách hàng: mã user, tên user, số đơn hàng
SELECT u.user_id, u.user_name, COUNT(o.order_id) AS so_don_hang
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id   -- LEFT JOIN để hiển thị cả user chưa có đơn (số đơn = 0)
GROUP BY u.user_id, u.user_name;

-- 3. Liệt kê thông tin hóa đơn: mã đơn hàng, số sản phẩm
SELECT order_id, COUNT(product_id) AS so_san_pham
FROM order_details
GROUP BY order_id;

-- 4. Liệt kê thông tin mua hàng của người dùng: mã user, tên user, mã đơn hàng, tên sản phẩm
--    Lưu ý: gộp nhóm theo đơn hàng, tránh hiển thị xen kẽ các đơn hàng với nhau
--    Ý nghĩa: hiển thị mỗi đơn hàng cùng danh sách sản phẩm, sắp xếp theo user và đơn hàng
SELECT u.user_id, u.user_name, o.order_id, p.product_name
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
ORDER BY u.user_id, o.order_id;   -- sắp xếp để các đơn hàng cùng user không bị trộn lẫn

-- 5. Liệt kê 7 người dùng có số lượng đơn hàng nhiều nhất
SELECT u.user_id, u.user_name, COUNT(o.order_id) AS so_don_hang
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.user_name
ORDER BY so_don_hang DESC
LIMIT 7;

-- 6. Liệt kê 7 người dùng mua sản phẩm có tên chứa 'Samsung' hoặc 'Apple'
--    Hiển thị: mã user, tên user, mã đơn hàng, tên sản phẩm
SELECT DISTINCT u.user_id, u.user_name, o.order_id, p.product_name
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
WHERE p.product_name LIKE '%Samsung%' OR p.product_name LIKE '%Apple%'
ORDER BY u.user_id, o.order_id
LIMIT 7;   -- giới hạn 7 dòng (có thể là 7 người dùng đầu tiên, nhưng yêu cầu đề là 7 người dùng)
-- Lưu ý: Đề "liệt kê 7 người dùng" có thể hiểu là 7 user, không phải 7 dòng.
-- Nếu cần đúng 7 user thì dùng subquery hoặc GROUP BY user trước, nhưng yêu cầu hiển thị cả sản phẩm nên tạm dùng LIMIT 7 dòng.

-- 7. Liệt kê danh sách mua hàng của user bao gồm giá tiền của mỗi đơn hàng
--    Hiển thị: mã user, tên user, mã đơn hàng, tổng tiền
SELECT u.user_id, u.user_name, o.order_id, SUM(p.product_price) AS tong_tien
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY u.user_id, u.user_name, o.order_id;

-- 8. Mỗi user chỉ chọn ra 1 đơn hàng có tổng tiền lớn nhất.
--    Nếu có nhiều đơn cùng tổng tiền lớn nhất, chọn đơn có order_id nhỏ nhất.
SELECT t.user_id, t.user_name, t.order_id, t.tong_tien
FROM (
    SELECT u.user_id, u.user_name, o.order_id, SUM(p.product_price) AS tong_tien,
           ROW_NUMBER() OVER (PARTITION BY u.user_id ORDER BY SUM(p.product_price) DESC, o.order_id ASC) AS rn
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY u.user_id, u.user_name, o.order_id
) t
WHERE t.rn = 1;

-- 9. Mỗi user chỉ chọn ra 1 đơn hàng có tổng tiền nhỏ nhất, kèm số sản phẩm.
--    Nếu có nhiều đơn cùng tổng tiền nhỏ nhất, chọn đơn có order_id nhỏ nhất.
SELECT t.user_id, t.user_name, t.order_id, t.tong_tien, t.so_san_pham
FROM (
    SELECT u.user_id, u.user_name, o.order_id,
           SUM(p.product_price) AS tong_tien,
           COUNT(od.product_id) AS so_san_pham,
           ROW_NUMBER() OVER (PARTITION BY u.user_id ORDER BY SUM(p.product_price) ASC, o.order_id ASC) AS rn
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY u.user_id, u.user_name, o.order_id
) t
WHERE t.rn = 1;

-- 10. Mỗi user chỉ chọn ra 1 đơn hàng có số sản phẩm nhiều nhất, kèm tổng tiền và số sản phẩm.
--     Nếu có nhiều đơn cùng số lượng sản phẩm nhiều nhất, chọn đơn có tổng tiền lớn nhất (hoặc order_id nhỏ nhất).
SELECT t.user_id, t.user_name, t.order_id, t.tong_tien, t.so_san_pham
FROM (
    SELECT u.user_id, u.user_name, o.order_id,
           SUM(p.product_price) AS tong_tien,
           COUNT(od.product_id) AS so_san_pham,
           ROW_NUMBER() OVER (PARTITION BY u.user_id ORDER BY COUNT(od.product_id) DESC, SUM(p.product_price) DESC, o.order_id ASC) AS rn
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY u.user_id, u.user_name, o.order_id
) t
WHERE t.rn = 1;