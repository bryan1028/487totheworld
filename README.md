# 📚 Bookstore Management System 📦

A comprehensive **MySQL-based** bookstore database designed to manage **books**, **authors**, **customers**, **orders**, and **shipping details** with built-in **user role access** 🔐.

---

## ✨ Features

- 📖 Book management with language, publisher, and author associations  
- 👤 Customer accounts and address history  
- 📦 Order processing with order statuses and historical tracking  
- 🚚 Shipping method and address status tracking  
- 🔐 Role-based user access control  

---

## 🧩 Schema Overview

**Key tables in the system:**

• `book` 📘  
• `author` ✍️  
• `book_author` 🤝  
• `book_language` 🌍  
• `publisher` 🏢  
• `customer` 👥  
• `customer_address` 🏠  
• `address` 📬  
• `address_status` 🔄  
• `country` 🗺️  
• `cust_order` 📑  
• `order_line` 🛒  
• `order_status` 📊  
• `order_history` 🕓  
• `shipping_method` 🚚  

---

## 🛠️ Database Setup

### 1. Create and Use the Database

```sql
CREATE DATABASE bookstore;  
USE bookstore;
```

---

### 2. 🧱 Table Structure

#### 📚 Core Entities

- **book_language**: Stores languages and language codes 🌐  
- **publisher**: Contains publisher contact and metadata 🏢  
- **author**: Stores author bios, nationality, and indexing for names ✍️  
- **book**: Holds book metadata, linked to publisher and language 📖  
- **book_author**: Junction table for book-author relationships (many-to-many) 🔗  

#### 🏘️ Address System

- **country**: Stores country names and ISO codes 🌎  
- **address**: Contains address lines, city, state, and postal info 📮  
- **address_status**: Tracks address state (e.g., Current, Previous) 🔄  
- **customer_address**: Links customers to addresses with statuses 📌  

#### 🧑‍💼 Customer and Orders

- **customer**: Customer registration and profile info 👤  
- **shipping_method**: Shipping types and cost estimates 🚛  
- **order_status**: Tracks the status of an order 📈  
- **cust_order**: Main order table with links to shipping/billing and status 📄  
- **order_line**: Line items within an order (book, quantity, pricing) 🛍️  
- **order_history**: Historical record of order status changes 🕰️  

---

## 🧪 Sample Data

Sample inserts are included for:

- 🗣️ Languages, publishers, and books (including ISBNs, prices, stock)  
- ✍️ Authors and their relationships to books  
- 🗺️ Countries and addresses  
- 👥 Customers with hashed passwords  
- 📦 Orders and their line items, shipping methods, and histories  

---

## 🛡️ User Roles and Permissions

### 👑 Admin: Full Access  
```sql
CREATE USER 'bookstore_admin'@'localhost' IDENTIFIED BY 'admin_secure_password';  
GRANT ALL PRIVILEGES ON bookstore.* TO 'bookstore_admin'@'localhost';
```

### 🧑‍💼 Manager: Moderate Access  
```sql
CREATE USER 'bookstore_manager'@'localhost' IDENTIFIED BY 'manager_secure_password';  
GRANT SELECT, INSERT, UPDATE, DELETE ON bookstore.* TO 'bookstore_manager'@'localhost';
```

### 💼 Sales: Restricted Access  
```sql
CREATE USER 'bookstore_sales'@'localhost' IDENTIFIED BY 'sales_secure_password';

-- Viewing access
GRANT SELECT ON bookstore.book TO 'bookstore_sales'@'localhost';  
GRANT SELECT ON bookstore.book_author TO 'bookstore_sales'@'localhost';  
GRANT SELECT ON bookstore.author TO 'bookstore_sales'@'localhost';  
GRANT SELECT ON bookstore.publisher TO 'bookstore_sales'@'localhost';  
GRANT SELECT ON bookstore.customer TO 'bookstore_sales'@'localhost';

-- Order management access
GRANT SELECT, INSERT, UPDATE ON bookstore.cust_order TO 'bookstore_sales'@'localhost';  
GRANT SELECT, INSERT, UPDATE ON bookstore.order_line TO 'bookstore_sales'@'localhost';
```

📝 *Note: Passwords and user management should be adjusted based on your actual deployment policies.*

---

## 🚀 Indexing and Optimization

- 🔍 Indexed fields on names, titles, ISBNs, and foreign keys to improve lookup performance  
- 🧮 Composite indexes where beneficial (e.g., `isbn13`, `isbn10` and author names)  

---

## 🧪 How to Use

- ⚙️ Run the SQL script in a MySQL-compatible client  
- 🧪 Use provided roles to test different levels of access  
- 🛠️ Modify or extend schema for reporting, inventory management, or analytics  

---

## 📊 ERD  
*Visual representation of schema structure*  


![bookstore drawio-4](https://github.com/user-attachments/assets/d08d25ab-c415-4af7-84cd-ebe85bd0e4d7)


## Collaborators

- [@bryan1028](https://github.com/bryan1028) 
- [@zippyrehema123](https://github.com/zippyrehema123) 
- [@fridasamkarimi](https://github.com/fridasamkarimi)


