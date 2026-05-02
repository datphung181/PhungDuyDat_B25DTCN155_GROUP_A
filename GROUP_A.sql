CREATE DATABASE rikkei_store;
USE rikkei_store;

-- USERS
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    address VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- CATEGORIES
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL
);

-- PRODUCTS
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL CHECK (stock >= 0),
    category_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- ORDERS
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending','Paid','Cancelled') DEFAULT 'Pending',
    total_money DECIMAL(12,2) NOT NULL,
    shipping_address VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ORDER DETAILS
CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    price_at_purchase DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


-- USERS
INSERT INTO users (full_name, email, address) VALUES
('Nguyen Van A', 'a@gmail.com', 'Hanoi'),
('Tran Thi B', 'b@gmail.com', 'HCM'),
('Le Van C', 'c@gmail.com', 'Danang'),
('Pham Thi D', 'd@gmail.com', 'Hue'),
('Hoang Van E', 'e@gmail.com', 'Can Tho');

-- CATEGORIES
INSERT INTO categories (category_name) VALUES
('Electronics'),
('Fashion'),
('Books'),
('Home'),
('Sports');

-- PRODUCTS
INSERT INTO products (product_name, price, stock, category_id) VALUES
('iPhone 15', 20000000, 10, 1),
('Laptop Dell', 15000000, 5, 1),
('T-Shirt', 200000, 50, 2),
('Novel Book', 100000, 30, 3),
('Football', 300000, 20, 5);

-- ORDERS
INSERT INTO orders (user_id, status, total_money, shipping_address) VALUES
(1, 'Paid', 20200000, 'Hanoi'),
(2, 'Paid', 15000000, 'HCM'),
(3, 'Pending', 300000, 'Danang'),
(1, 'Paid', 100000, 'Hanoi'),
(4, 'Cancelled', 200000, 'Hue');

-- ORDER DETAILS
INSERT INTO order_details (order_id, product_id, quantity, price_at_purchase) VALUES
(1, 1, 1, 20000000),
(1, 5, 1, 300000),
(2, 2, 1, 15000000),
(3, 5, 1, 300000),
(4, 4, 1, 100000),
(5, 3, 1, 200000);

SELECT o.order_id, o.order_date, u.full_name, o.total_money
FROM orders o
JOIN users u ON o.user_id = u.user_id;

SELECT p.* FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Electronics';

SELECT user_id, full_name, email FROM users;

SELECT SUM(total_money) AS total_revenue FROM orders;

SELECT p.product_id, p.product_name, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_id, p.product_name;

SELECT p.product_id, p.product_name, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity DESC
LIMIT 1;

SELECT o.order_id, u.full_name, o.total_money,
       SUM(od.quantity) AS total_items
FROM orders o
JOIN users u ON o.user_id = u.user_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id, u.full_name, o.total_money;

SELECT u.user_id, u.full_name, COUNT(o.order_id) AS total_orders
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.full_name;

SELECT * FROM products
WHERE price > (SELECT AVG(price) FROM products);

SELECT * FROM orders
ORDER BY total_money DESC
LIMIT 1;

SELECT p.product_id, p.product_name, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity DESC, p.product_id ASC
LIMIT 3;


