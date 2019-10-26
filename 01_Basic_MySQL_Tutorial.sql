/*********************************************** 
** File: 01_Basic_MySQL_Tutorial
** Desc: explains some basic SQL statements
** Author: bx
** Date: 17/10/2019
** Ref: http://www.mysqltutorial.org/basic-mysql-tutorial.aspx
************************************************/
## Section 1. Getting Started with MySQL
# http://www.mysqltutorial.org/install-mysql/
USE classicmodels;

## Section 2. Querying data
SELECT select_list
FROM table_name;

# A) Using the MySQL SELECT statement to retreive data from a single column example
SELECT lastName
FROM employees;

# B) Using MySQL SELECT statement to query data from multiple columns example
SELECT
	lastname,
	firstname,
    jobtitle
FROM
	employees;

# C) Using MySQL SELECT statement to retrieve data from all columns example
SELECT *
FROM employees;


## Section 3. Sorting data
SELECT
	select_list
FROM
	table_name
ORDER BY
	column1 [ASC|DESC],
    column2 [ASC|DESC],
    ...;

# By default, ORDER BY uses ASC 

# A) Using MySQL ORDER BY clause to sort values in one column example
SELECT
	contactLastname,
    contactFirstname
FROM
	customers
ORDER BY
	contactLastname;

SELECT
	contactLastname,
    contactFirstname
FROM
	customers
ORDER BY
	contactLastname DESC;

# B) Using MySQL ORDER BY clause to sort values in multiple columns example
SELECT
	contactLastname,
    contactFirstname
FROM
	customers
ORDER BY
	contactLastname DESC,
    contactFirstname ASC;

# C) Using MySQL ORDER BY to sort a result set by an expression example
SELECT
	orderNumber,
    orderlinenumber,
    quantityOrdered * priceEach
FROM
	orderdetails
ORDER BY
	quantityOrdered * priceEach DESC;

SELECT 
    orderNumber,
    orderLineNumber,
    quantityOrdered * priceEach AS subtotal
FROM
    orderdetails
ORDER BY subtotal DESC;

# Using MySQL ORDER BY to sort data using a custom list
SELECT
	orderNumber,
    status
FROM
	orders
ORDER BY
	FIELD(status,
		'In Process',
        'On Hold',
        'Cancelled',
        'Resolved',
        'Disputed',
        'Shipped');


