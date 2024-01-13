/*a. Truy vấn người dùng*/ 
/*1. Lấy ra danh sách người dùng theo thứ tự tên theo Alphabet (A->Z):*/
SELECT *
FROM users
ORDER BY user_name;

/*2. Lấy ra 07 người dùng theo thứ tự tên theo Alphabet (A->Z):*/
SELECT *
FROM users
ORDER BY user_name
LIMIT 7;

/*3. Lấy ra danh sách người dùng theo thứ tự tên theo Alphabet (A->Z), trong đó tên người dùng có chữ a:*/
SELECT *
FROM users
WHERE user_name LIKE '%a%'
ORDER BY user_name;

/*4. Lấy ra danh sách người dùng trong đó tên người dùng bắt đầu bằng chữ m:*/
SELECT *
FROM users
WHERE user_name LIKE 'm%'
ORDER BY user_name;

/*5. Lấy ra danh sách người dùng trong đó tên người dùng kết thúc bằng chữ i:*/
SELECT *
FROM users
WHERE user_name LIKE '%i'
ORDER BY user_name;

/*6. Lấy ra danh sách người dùng trong đó email người dùng là Gmail (ví dụ: example@gmail.com):*/
SELECT *
FROM users
WHERE user_email LIKE '%@gmail.com%';

/*7. Lấy ra danh sách người dùng trong đó email người dùng là Gmail (ví dụ: example@gmail.com), tên người dùng bắt đầu bằng chữ m:*/
SELECT *
FROM users
WHERE user_email LIKE '%@gmail.com%'
  AND user_name LIKE 'm%'
ORDER BY user_name;

/*8. Lấy ra danh sách người dùng trong đó email người dùng là Gmail (ví dụ: example@gmail.com), tên người dùng có chữ i và tên người dùng có chiều dài lớn hơn 5:*/
SELECT *
FROM users
WHERE user_email LIKE '%@gmail.com%'
  AND user_name;

/*9. Lấy ra danh sách người dùng trong đó tên người dùng có chữ a, chiều dài từ 5 đến 9, email dùng dịch vụ Gmail, trong tên email có chữ i:*/
SELECT *
FROM users
WHERE user_name LIKE '%a%'
  AND LENGTH(user_name) BETWEEN 5 AND 9
  AND user_email LIKE '%@gmail.com%'
  AND user_email LIKE '%i%'
ORDER BY user_name;

/*10. Lấy ra danh sách người dùng trong đó tên người dùng có chữ a, chiều dài từ 5 đến 9 hoặc tên người dùng có chữ i, chiều dài nhỏ hơn 9 hoặc email dùng dịch vụ Gmail, trong tên email có chữ i:*/
SELECT *
FROM users
WHERE (user_name LIKE '%a%'
       AND LENGTH(user_name) BETWEEN 5 AND 9)
  OR (user_name LIKE '%i%'
      AND LENGTH(user_name) < 9)
  OR (user_email LIKE '%@gmail.com%'
      AND user_email LIKE '%i%')
ORDER BY user_name;

/*b. Truy vấn đơn hang*/ 
/*1. Liệt kê các hóa đơn của khách hàng, thông tin hiển thị gồm: mã user, tên user, mã hóa đơn: */
SELECT orders.user_id,
       users.user_name,
       orders.order_id
FROM orders
JOIN users ON orders.user_id = users.user_id;

/*2. Liệt kê số lượng các hóa đơn của khách hàng: mã user, tên user, số đơn hàng: */
SELECT users.user_id,
       users.user_name,
       COUNT(orders.order_id) AS total_orders
FROM users
LEFT JOIN orders ON users.user_id = orders.user_id
GROUP BY users.user_id,
         users.user_name;

/*3. Liệt kê thông tin hóa đơn: mã đơn hàng, số sản phẩm:*/
SELECT order_id,
       COUNT(product_id) AS total_products
FROM order_details
GROUP BY order_id;

/*4. Liệt kê thông tin mua hàng của người dùng: mã user, tên user, mã đơn hàng, tên sản phẩm: */
SELECT users.user_id,
       users.user_name,
       orders.order_id,
       products.product_name
FROM users
JOIN orders ON users.user_id = orders.user_id
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
ORDER BY users.user_id,
         orders.order_id;

/*5. Liệt kê 7 người dùng có số lượng đơn hàng nhiều nhất, thông tin hiển thị gồm: mã user, tên user, số lượng đơn hàng: */
SELECT users.user_id,
       users.user_name,
       COUNT(orders.order_id) AS total_orders
FROM users
LEFT JOIN orders ON users.user_id = orders.user_id
GROUP BY users.user_id,
         users.user_name
ORDER BY total_orders DESC
LIMIT 7;

/*6. Liệt kê 7 người dùng mua sản phẩm có tên: Samsung hoặc Apple trong tên sản phẩm, thông tin hiển thị gồm: mã user, tên user, mã đơn hàng, tên sản phẩm: */
SELECT users.user_id,
       users.user_name,
       orders.order_id,
       products.product_name
FROM users
JOIN orders ON users.user_id = orders.user_id
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
WHERE products.product_name LIKE 'Samsung%'
  OR products.product_name LIKE 'Apple%'
LIMIT 7;

/*7. Liệt kê danh sách mua hàng của user bao gồm giá tiền của mỗi đơn hàng, thông tin hiển thị gồm: mã user, tên user, mã đơn hàng, tổng tiền: */
SELECT users.user_id,
       users.user_name,
       orders.order_id,
       SUM(products.product_price) AS total_price
FROM users
JOIN orders ON users.user_id = orders.user_id
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
GROUP BY users.user_id,
         users.user_name,
         orders.order_id;

/*8. Liệt kê danh sách mua hàng của user bao gồm giá tiền của mỗi đơn hàng, thông tin hiển thị gồm: mã user, tên user, mã đơn hàng, tổng tiền. Mỗi user chỉ chọn ra 1 đơn hàng có giá tiền lớn nhất: */
SELECT users.user_id,
       users.user_name,
       orders.order_id,
       MAX(total_price) AS max_total_price
FROM users
JOIN orders ON users.user_id = orders.user_id
JOIN
  (SELECT order_id,
          SUM(products.product_price) AS total_price
   FROM order_details
   JOIN products ON order_details.product_id = products.product_id
   GROUP BY order_id) AS order_prices ON orders.order_id = order_prices.order_id
GROUP BY users.user_id,
         users.user_name,
         orders.order_id
ORDER BY max_total_price DESC;

/*9. Liệt kê danh sách mua hàng của user bao gồm giá tiền của mỗi đơn hàng, thông tin hiển thị gồm: mã user, tên user, mã đơn hàng, tổng tiền, số sản phẩm. Mỗi user chỉ chọn ra 1 đơn hàng có giá tiền nhỏ nhất: */
SELECT users.user_id,
       users.user_name,
       orders.order_id,
       MIN(total_price) AS min_total_price,
       COUNT(order_details.product_id) AS total_products
FROM users
JOIN orders ON users.user_id = orders.user_id
JOIN
  (SELECT order_id,
          SUM(products.product_price) AS total_price
   FROM order_details
   JOIN products ON order_details.product_id = products.product_id
   GROUP BY order_id) AS order_prices ON orders.order_id = order_prices.order_id
JOIN order_details ON orders.order_id = order_details.order_id
GROUP BY users.user_id,
         users.user_name,
         orders.order_id
ORDER BY min_total_price;

/*10. Liệt kê danh sách mua hàng của user bao gồm giá tiền của mỗi đơn hàng, thông tin hiển thị gồm: mã user, tên user, mã đơn hàng, tổng tiền, số sản phẩm. Mỗi user chỉ chọn ra 1 đơn hàng có số sản phẩm là nhiều nhất:*/
SELECT users.user_id,
       users.user_name,
       orders.order_id,
       order_prices.total_price,
       order_products.total_products
FROM users
JOIN orders ON users.user_id = orders.user_id
JOIN
  (SELECT order_id,
          SUM(products.product_price) AS total_price,
          COUNT(order_details.product_id) AS total_products
   FROM order_details
   JOIN products ON order_details.product_id = products.product_id
   GROUP BY order_id) AS order_prices ON orders.order_id = order_prices.order_id
JOIN
  (SELECT order_id,
          COUNT(product_id) AS total_products
   FROM order_details
   GROUP BY order_id) AS order_products ON orders.order_id = order_products.order_id
ORDER BY total_products DESC
LIMIT 1;