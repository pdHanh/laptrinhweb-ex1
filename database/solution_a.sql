-- 1. Lấy danh sách người dùng theo thứ tự tên Alphabet (A->Z)
SELECT *
FROM users
ORDER BY user_name ASC;

-- 2. Lấy 07 người dùng theo thứ tự tên Alphabet (A->Z)
SELECT *
FROM users
ORDER BY user_name ASC
LIMIT 7;

-- 3. Lấy danh sách người dùng theo thứ tự tên Alphabet, trong đó tên có chữ 'a'
SELECT *
FROM users
WHERE user_name LIKE '%a%'   -- tên chứa ký tự 'a' (không phân biệt hoa/thường nếu collation không phân biệt)
ORDER BY user_name ASC;

-- 4. Lấy danh sách người dùng trong đó tên bắt đầu bằng chữ 'm'
SELECT *
FROM users
WHERE user_name LIKE 'm%';   -- LIKE 'm%' : bắt đầu bằng 'm'

-- 5. Lấy danh sách người dùng trong đó tên kết thúc bằng chữ 'i'
SELECT *
FROM users
WHERE user_name LIKE '%i';   -- LIKE '%i' : kết thúc bằng 'i'

-- 6. Lấy danh sách người dùng có email là Gmail (ví dụ: example@gmail.com)
SELECT *
FROM users
WHERE user_email LIKE '%@gmail.com';   -- đuôi email là @gmail.com

-- 7. Lấy danh sách người dùng có email Gmail và tên bắt đầu bằng chữ 'm'
SELECT *
FROM users
WHERE user_email LIKE '%@gmail.com'
  AND user_name LIKE 'm%';

-- 8. Lấy danh sách người dùng có email Gmail, tên chứa chữ 'i' và độ dài tên > 5
SELECT *
FROM users
WHERE user_email LIKE '%@gmail.com'
  AND user_name LIKE '%i%'
  AND LENGTH(user_name) > 5;   -- LENGTH tính số ký tự (không phân biệt UTF8 nếu dùng utf8mb4)

-- 9. Lấy danh sách người dùng có:
--    - tên chứa 'a', độ dài từ 5 đến 9
--    - email Gmail
--    - trong tên email (phần local, trước @) có chứa chữ 'I' (không phân biệt hoa/thường)
SELECT *
FROM users
WHERE user_name LIKE '%a%'
  AND LENGTH(user_name) BETWEEN 5 AND 9
  AND user_email LIKE '%@gmail.com'
  AND LOWER(SUBSTRING_INDEX(user_email, '@', 1)) LIKE '%i%';
  -- SUBSTRING_INDEX(user_email, '@', 1): lấy phần trước @ (local-part)
  -- LOWER chuyển về chữ thường để tìm 'i' không phân biệt hoa/thường

-- 10. Lấy danh sách người dùng thỏa mãn ít nhất một trong ba điều kiện:
--     - tên chứa 'a' và độ dài 5-9
--     - tên chứa 'i' và độ dài < 9
--     - email Gmail và trong tên email có chứa 'i'
SELECT *
FROM users
WHERE (user_name LIKE '%a%' AND LENGTH(user_name) BETWEEN 5 AND 9)
   OR (user_name LIKE '%i%' AND LENGTH(user_name) < 9)
   OR (user_email LIKE '%@gmail.com' AND LOWER(SUBSTRING_INDEX(user_email, '@', 1)) LIKE '%i%');