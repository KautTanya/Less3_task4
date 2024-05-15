---Спочатку додаю необхідні дані до бази

CREATE TABLE library_branches (
    library_id SERIAL PRIMARY KEY,
    library_name VARCHAR(20)
);

INSERT INTO library_branches(library_name) VALUES 
	('A'),
	('B'),
	('C'),
	('D'),
	('E'),
	('F'),
	('G'),
	('K');


ALTER TABLE workers ADD COLUMN library_id INTEGER;

UPDATE workers SET library_id = 1 WHERE library_filia = '1';
UPDATE workers SET library_id = 2 WHERE library_filia = '2';
UPDATE workers SET library_id = 3 WHERE library_filia = '3';
UPDATE workers SET library_id = 4 WHERE library_filia = '4';

ALTER TABLE workers DROP COLUMN library_filia;

ALTER TABLE workers
ADD CONSTRAINT fk_library
FOREIGN KEY (library_id) REFERENCES library_branches(library_id);

INSERT INTO users(users_name, phone_number, email, address, country) VALUES 
	('user15', '+380991234515', 'user15@example.com', 'вул. Пушкіна, 15', 'USA'),
	('user16', '+380992345616', 'user16@example.com', 'вул. Пушкіна, 16', 'USA'),
	('user17', '+380993456717', 'user17@example.com', 'вул. Гоголя, 27', 'USA');

--- Необхідні запити


--Пов'яжіть таблиці users та borrow_records, використовуючи INNER JOIN на id користувача та user_id запису про позичання. Виведіть імена користувачів (first_name, last_name) та borrow_date.

SELECT users.users_name, book_loans.loan_date
FROM users
INNER JOIN book_loans ON users.users_id = book_loans.users_id;

--Додайте до попереднього запиту групування по користувачам (first_name, last_name). Виведіть імена користувачів та кількість їхніх записів про позичання.

SELECT users.users_name, COUNT(book_loans.users_id)
FROM users
INNER JOIN book_loans ON users.users_id = book_loans.users_id
GROUP BY users.users_name;

-- До попереднього запиту додайте сортування за кількістю записів про позичання від більшого до меншого (DESC) і обмежте вивід першими 10 результатами. 2. Виведіть інформацію про всіх користувачів і книги, які вони позичили (якщо позичили). Для цього використайте LEFT JOIN між таблицями users, borrow_records, book_copies та books.

SELECT users.users_name, COUNT(book_loans.users_id)
FROM users
INNER JOIN book_loans ON users.users_id = book_loans.users_id
GROUP BY users.users_name
ORDER BY COUNT(book_loans.users_id) DESC
LIMIT 10;

--Виведіть інформацію про всіх користувачів і книги, які вони позичили (якщо позичили). Для цього використайте LEFT JOIN між таблицями users, borrow_records, book_copies та books.

SELECT users.users_name, books.title
FROM users
LEFT JOIN book_loans ON users.users_id = book_loans.users_id
LEFT JOIN books ON book_loans.book_id = books.book_id;

--Додайте до попереднього запиту умову вибірки лише тих користувачів, які позичили хоча б одну книгу (WHERE books.title IS NOT NULL).

SELECT users.users_name, books.title
FROM users
LEFT JOIN book_loans ON users.users_id = book_loans.users_id
LEFT JOIN books ON book_loans.book_id = books.book_id
WHERE books.title IS NOT NULL;

--Додайте до попереднього запиту агрегатну функцію для підрахунку кількості книг, які позичив кожен користувач.

SELECT users.users_name, COUNT(users.users_name)
FROM users
LEFT JOIN book_loans ON users.users_id = book_loans.users_id
LEFT JOIN books ON book_loans.book_id = books.book_id
WHERE books.title IS NOT NULL
GROUP BY users.users_name

--Використайте FULL JOIN для з'єднання таблиць employees та library_branches, виведіть імена співробітників та назву філії, в якій вони працюють.

SELECT workers.workers_name, library_branches.library_name
FROM workers
FULL JOIN library_branches ON workers.library_id = library_branches.library_id

--Додайте до попереднього запиту з'єднання з третьою таблицею users, з'єднайте її по country, а потім відфільтруйте результат, щоб показати лише тих користувачів і співробітників, які проживають у США.

SELECT workers.workers_name, users.users_name, library_branches.library_name, users.country
FROM workers
FULL JOIN library_branches ON workers.library_id = library_branches.library_id
FULL JOIN users ON users.country = workers.country
WHERE users.country = 'USA';