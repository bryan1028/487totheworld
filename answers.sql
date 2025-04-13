CREATE DATABASE bookstore;
USE bookstore;


-- Create book_language table
CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_name VARCHAR(50) NOT NULL,
    language_code VARCHAR(5) NOT NULL,
    UNIQUE (language_code)
);

-- Create publisher table
CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(100) NOT NULL,
    publisher_email VARCHAR(100),
    publisher_phone VARCHAR(20),
    publisher_website VARCHAR(100),
    date_added TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create author table
CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_first_name VARCHAR(50) NOT NULL,
    author_last_name VARCHAR(50) NOT NULL,
    author_bio TEXT,
    date_of_birth DATE,
    nationality VARCHAR(50),
    date_added TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_author_name (author_last_name, author_first_name)
);

-- Create book table
CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    isbn13 CHAR(13) UNIQUE,
    isbn10 CHAR(10) UNIQUE,
    publication_date DATE,
    publisher_id INT,
    language_id INT,
    page_count INT,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT,
    cover_image VARCHAR(255),
    stock_quantity INT NOT NULL DEFAULT 0,
    date_added TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id),
    FOREIGN KEY (language_id) REFERENCES book_language(language_id),
    INDEX idx_book_title (title),
    INDEX idx_isbn (isbn13, isbn10)
);

-- Create book_author junction table for many-to-many relationship
CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    is_primary_author BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES author(author_id) ON DELETE CASCADE
);

-- Create country table
CREATE TABLE country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL,
    country_code CHAR(2) NOT NULL UNIQUE
);

-- Create address table
CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    address_line1 VARCHAR(100) NOT NULL,
    address_line2 VARCHAR(100),
    city VARCHAR(50) NOT NULL,
    state_province VARCHAR(50),
    postal_code VARCHAR(20) NOT NULL,
    country_id INT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES country(country_id),
    INDEX idx_address_location (city, state_province, country_id)
);

-- Create address_status table
CREATE TABLE address_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(30) NOT NULL UNIQUE,
    description VARCHAR(255)
);

-- Create customer table
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    date_registered TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    INDEX idx_customer_name (last_name, first_name),
    INDEX idx_customer_email (email)
);

-- Create customer_address junction table
CREATE TABLE customer_address (
    customer_id INT,
    address_id INT,
    status_id INT NOT NULL,
    is_default BOOLEAN DEFAULT FALSE,
    date_added TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (address_id) REFERENCES address(address_id) ON DELETE CASCADE,
    FOREIGN KEY (status_id) REFERENCES address_status(status_id)
);

-- Create shipping_method table
CREATE TABLE shipping_method (
    shipping_method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(50) NOT NULL,
    cost DECIMAL(10, 2) NOT NULL,
    estimated_days INT,
    is_active BOOLEAN DEFAULT TRUE
);

-- Create order_status table
CREATE TABLE order_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(30) NOT NULL UNIQUE,
    description VARCHAR(255)
);

-- Create cust_order table
CREATE TABLE cust_order (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    shipping_address_id INT NOT NULL,
    billing_address_id INT NOT NULL,
    shipping_method_id INT NOT NULL,
    order_total DECIMAL(10, 2) NOT NULL,
    status_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_address_id) REFERENCES address(address_id),
    FOREIGN KEY (billing_address_id) REFERENCES address(address_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(shipping_method_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id),
    INDEX idx_order_customer (customer_id),
    INDEX idx_order_date (order_date),
    INDEX idx_order_status (status_id)
);

-- Create order_line table
CREATE TABLE order_line (
    order_line_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL,
    price_per_unit DECIMAL(10, 2) NOT NULL,
    line_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    INDEX idx_order_line_order (order_id)
);

-- Create order_history table
CREATE TABLE order_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    status_id INT NOT NULL,
    status_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    updated_by VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id) ON DELETE CASCADE,
    FOREIGN KEY (status_id) REFERENCES order_status(status_id),
    INDEX idx_history_order (order_id),
    INDEX idx_history_date (status_date)
);
-- Insert sample data into book_language
INSERT INTO book_language (language_name, language_code) VALUES
('English', 'en'),
('Spanish', 'es'),
('French', 'fr'),
('German', 'de'),
('Kiswahili', 'sw'),
('Japanese', 'ja');

-- Insert sample data into publisher
INSERT INTO publisher (publisher_name, publisher_email, publisher_phone, publisher_website) VALUES
('Penguin Random House', 'info@penguinrandomhouse.com', '212-782-9000', 'www.penguinrandomhouse.com'),
('HarperCollins', 'info@harpercollins.com', '212-207-7000', 'www.harpercollins.com'),
('Simon & Schuster', 'customer.service@simonandschuster.com', '800-223-2336', 'www.simonandschuster.com'),
('Macmillan Publishers', 'customerservice@mpsvirginia.com', '888-330-8477', 'www.macmillan.com'),
('Oxford University Press', 'customerservice.us@oup.com', '800-445-9714', 'www.oup.com');

-- Insert sample data into author
INSERT INTO author (author_first_name, author_last_name, author_bio, date_of_birth, nationality) VALUES
('J.K.', 'Rowling', 'British author best known for the Harry Potter series', '1965-07-31', 'British'),
('Chimamanda', 'Adichie', 'Nigerian author of award-winning fiction', '1977-09-15', 'Nigerian'),
('Jane', 'Austen', 'English novelist known for her six major novels', '1775-12-16', 'British'),
('Ngugi wa', 'Thiong\'o', 'Kenyan writer and academic', '1938-01-05', 'Kenyan'),
('George', 'Orwell', 'English novelist, essayist, and critic', '1903-06-25', 'British'),
('Wangari', 'Maathai', 'Kenyan environmental activist and author', '1940-04-01', 'Kenyan');

-- Insert sample data into book
INSERT INTO book (title, isbn13, isbn10, publication_date, publisher_id, language_id, page_count, price, description, stock_quantity) VALUES
('Harry Potter and the Philosopher\'s Stone', '9780747532743', '0747532745', '1997-06-26', 1, 1, 223, 19.99, 'The first novel in the Harry Potter series.', 150),
('Half of a Yellow Sun', '9780007200283', '0007200285', '2006-08-11', 2, 1, 433, 15.99, 'A novel by Chimamanda Adichie.', 75),
('Pride and Prejudice', '9780141439518', '0141439513', '1813-01-28', 3, 1, 432, 9.99, 'A romantic novel by Jane Austen.', 100),
('Decolonising the Mind', '9780852555019', '0852555016', '1986-01-01', 4, 5, 114, 14.99, 'A landmark essay collection by Ngugi wa Thiong\'o.', 50),
('1984', '9780451524935', '0451524934', '1949-06-08', 5, 1, 328, 12.99, 'A dystopian novel by George Orwell.', 120),
('Unbowed', '9780307275202', '0307275205', '2006-09-04', 1, 1, 326, 24.99, 'Memoir by Wangari Maathai.', 200);

-- Insert sample data into book_author
INSERT INTO book_author (book_id, author_id, is_primary_author) VALUES
(1, 1, TRUE),
(2, 2, TRUE),
(3, 3, TRUE),
(4, 4, TRUE),
(5, 5, TRUE),
(6, 6, TRUE);

-- Insert sample data into country
INSERT INTO country (country_name, country_code) VALUES
('United States', 'US'),
('United Kingdom', 'GB'),
('Kenya', 'KE'),
('Nigeria', 'NG'),
('Germany', 'DE'),
('France', 'FR'),
('Japan', 'JP'),
('Ghana', 'GH');

-- Insert sample data into address
INSERT INTO address (address_line1, address_line2, city, state_province, postal_code, country_id) VALUES
('123 Main St', 'Apt 4B', 'New York', 'NY', '10001', 1),
('456 High Street', NULL, 'London', NULL, 'SW1A 1AA', 2),
('789 Kimathi Avenue', 'Suite 10', 'Nairobi', NULL, '00100', 3),
('101 Broad Street', NULL, 'Lagos', 'Lagos State', '101233', 4),
('202 Baker Street', 'Floor 3', 'Los Angeles', 'CA', '90001', 1),
('303 Accra Road', NULL, 'Accra', NULL, '00233', 8);

-- Insert sample data into address_status
INSERT INTO address_status (status_name, description) VALUES
('Current', 'Address is currently in use'),
('Previous', 'Address was previously used but is no longer current'),
('Inactive', 'Address is no longer in use'),
('Temporary', 'Address is temporary');

-- Insert sample data into customer
INSERT INTO customer (first_name, last_name, email, phone, password_hash, is_active) VALUES
('Wanjiku', 'Kamau', 'wanjiku.kamau@example.com', '254-555-1234', SHA2('password123', 256), TRUE),
('Emma', 'Johnson', 'emma.johnson@example.com', '646-555-5678', SHA2('securepass', 256), TRUE),
('Oluwaseun', 'Adeyemi', 'oluwaseun.adeyemi@example.com', '234-555-9012', SHA2('adeyemi2023', 256), TRUE),
('Sarah', 'Davis', 'sarah.davis@example.com', '415-555-3456', SHA2('davis1234', 256), TRUE),
('Kofi', 'Mensah', 'kofi.mensah@example.com', '233-555-7890', SHA2('mensahpass', 256), TRUE);

-- Insert sample data into customer_address
INSERT INTO customer_address (customer_id, address_id, status_id, is_default) VALUES
(1, 1, 1, TRUE),
(2, 2, 1, TRUE),
(3, 3, 1, TRUE),
(4, 4, 1, TRUE),
(5, 5, 1, TRUE),
(1, 6, 2, FALSE);

-- Insert sample data into shipping_method
INSERT INTO shipping_method (method_name, cost, estimated_days, is_active) VALUES
('Standard Shipping', 4.99, 5, TRUE),
('Express Shipping', 9.99, 2, TRUE),
('Next Day Delivery', 14.99, 1, TRUE),
('International Standard', 19.99, 10, TRUE),
('International Express', 29.99, 5, TRUE);

-- Insert sample data into order_status
INSERT INTO order_status (status_name, description) VALUES
('Pending', 'Order has been placed but not yet processed'),
('Processing', 'Order is being processed'),
('Shipped', 'Order has been shipped'),
('Delivered', 'Order has been delivered'),
('Cancelled', 'Order has been cancelled'),
('Returned', 'Order has been returned');

-- Insert sample data into cust_order
INSERT INTO cust_order (customer_id, shipping_address_id, billing_address_id, shipping_method_id, order_total, status_id) VALUES
(1, 1, 1, 1, 24.98, 3),
(2, 2, 2, 2, 15.99, 2),
(3, 3, 3, 1, 19.99, 1),
(4, 4, 4, 3, 24.99, 4),
(5, 5, 5, 1, 12.99, 3);

-- Insert sample data into order_line
INSERT INTO order_line (order_id, book_id, quantity, price_per_unit, line_total) VALUES
(1, 1, 1, 19.99, 19.99),
(1, 3, 1, 9.99, 9.99),
(2, 2, 1, 15.99, 15.99),
(3, 1, 1, 19.99, 19.99),
(4, 6, 1, 24.99, 24.99),
(5, 5, 1, 12.99, 12.99);

-- Insert sample data into order_history
INSERT INTO order_history (order_id, status_id, notes, updated_by) VALUES
(1, 1, 'Order placed', 'System'),
(1, 2, 'Payment confirmed', 'System'),
(1, 3, 'Package shipped via USPS', 'Akinyi Odhiambo'),
(2, 1, 'Order placed', 'System'),
(2, 2, 'Processing started', 'Jane Smith'),
(3, 1, 'Order placed', 'System'),
(4, 1, 'Order placed', 'System'),
(4, 2, 'Payment confirmed', 'System'),
(4, 3, 'Package shipped via FedEx', 'Chinedu Okonkwo'),
(4, 4, 'Package delivered', 'System'),
(5, 1, 'Order placed', 'System'),
(5, 2, 'Payment confirmed', 'System'),
(5, 3, 'Package shipped via UPS', 'Amara Nwosu');

-- Create users with different levels of access

-- Create users with different levels of access
-- 1. Admin user with full access
DROP USER IF EXISTS 'bookstore_admin'@'localhost';
CREATE USER 'bookstore_admin'@'localhost' IDENTIFIED BY 'admin_secure_password';
GRANT ALL PRIVILEGES ON bookstore.* TO 'bookstore_admin'@'localhost';

-- 2. Manager user with select, insert, update privileges (no drop/alter/create)
DROP USER IF EXISTS 'bookstore_manager'@'localhost';
CREATE USER 'bookstore_manager'@'localhost' IDENTIFIED BY 'manager_secure_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON bookstore.* TO 'bookstore_manager'@'localhost';

-- 3. Sales staff with limited access - can view products, manage orders
DROP USER IF EXISTS 'bookstore_sales'@'localhost';
CREATE USER 'bookstore_sales'@'localhost' IDENTIFIED BY 'sales_secure_password';
GRANT SELECT ON bookstore.book TO 'bookstore_sales'@'localhost';
GRANT SELECT ON bookstore.book_author TO 'bookstore_sales'@'localhost';
GRANT SELECT ON bookstore.author TO 'bookstore_sales'@'localhost';
GRANT SELECT ON bookstore.publisher TO 'bookstore_sales'@'localhost';
GRANT SELECT ON bookstore.customer TO 'bookstore_sales'@'localhost';
GRANT SELECT, INSERT, UPDATE ON bookstore.cust_order TO 'bookstore_sales'@'localhost';
GRANT SELECT, INSERT, UPDATE ON bookstore.order_line TO 'bookstore_sales'@'localhost';
GRANT SELECT, INSERT ON bookstore.order_history TO 'bookstore_sales'@'localhost';

-- 4. Customer service with read-only access to customer and order data
DROP USER IF EXISTS 'bookstore_service'@'localhost';
CREATE USER 'bookstore_service'@'localhost' IDENTIFIED BY 'service_secure_password';
GRANT SELECT ON bookstore.customer TO 'bookstore_service'@'localhost';
GRANT SELECT ON bookstore.customer_address TO 'bookstore_service'@'localhost';
GRANT SELECT ON bookstore.address TO 'bookstore_service'@'localhost';
GRANT SELECT ON bookstore.cust_order TO 'bookstore_service'@'localhost';
GRANT SELECT ON bookstore.order_line TO 'bookstore_service'@'localhost';
GRANT SELECT ON bookstore.order_history TO 'bookstore_service'@'localhost';

-- 5. Read-only user for reporting and analytics
DROP USER IF EXISTS 'bookstore_reports'@'localhost';
CREATE USER 'bookstore_reports'@'localhost' IDENTIFIED BY 'reports_secure_password';
GRANT SELECT ON bookstore.* TO 'bookstore_reports'@'localhost';

-- Apply the changes
FLUSH PRIVILEGES;