SHOW TABLES;

DESCRIBE book;

SELECT * FROM author;
SELECT * FROM publisher;
SELECT * FROM book;
SELECT * FROM customer;
SELECT * FROM cust_order;
SELECT * FROM order_line;
SELECT * FROM order_history;

SELECT * FROM customer;
SELECT b.title, a.author_first_name, a.author_last_name
FROM book b
JOIN book_author ba ON b.book_id = ba.book_id
JOIN author a ON ba.author_id = a.author_id;

