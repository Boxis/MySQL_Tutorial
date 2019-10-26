# Section 5. Joining tables
# MySQL Alias
# MySQL alias for columns
SELECT 
   [column_1 | expression] AS descriptive_name
FROM table_name;

# If alias contains spaces, you must quote it as following:
SELECT 
   [column_1 | expression] AS `descriptive name`
FROM 
   table_name;

SELECT 
    CONCAT_WS(', ', lastName, firstname)
FROM
    employees;

SELECT
   CONCAT_WS(', ', lastName, firstname) AS `Full name`
FROM
   employees;

SELECT
    CONCAT_WS(', ', lastName, firstname) `Full name`
FROM
    employees
ORDER BY
    `Full name`;

SELECT
    orderNumber `Order no.`,
    SUM(priceEach * quantityOrdered) total
FROM
    orderDetails
GROUP BY
    `Order no.`
HAVING
    total > 60000;

# Cannot use WHERE clause for alias. Due to MySQL not evaluating SELECT until after WHERE

# MySQL alias for tables
# table_name AS table_alias
# SELECT * FROM employees e;
# table_alias.column_name

SELECT 
    e.firstName, 
    e.lastName
FROM
    employees e
ORDER BY e.firstName;

SELECT
    customerName,
    COUNT(o.orderNumber) total
FROM
    customers c
INNER JOIN orders o ON c.customerNumber = o.customerNumber
GROUP BY
    customerName
ORDER BY
    total DESC;
   
SELECT
    customers.customerName,
    COUNT(orders.orderNumber) total
FROM
    customers
INNER JOIN orders ON customers.customerNumber = orders.customerNumber
GROUP BY
    customerName
ORDER BY
    total DESC;

# MySQL Join
# Introduction to MySQL join clauses
# MySQL supports following joins:
	# 1. Inner Join
    # 2. Left join
    # 3. Right Join
    # 4. Cross join

# Setting up sample tables
# First, create two tables called members and committess:
create TABLE members (
    member_id INT AUTO_INCREMENT,
    name VARCHAR(100),
    PRIMARY KEY (member_id)
);
 
CREATE TABLE committees (
    committee_id INT AUTO_INCREMENT,
    name VARCHAR(100),
    PRIMARY KEY (committee_id)
);

# Second, insert some rows into tables members and committees:
INSERT INTO members(name)
VALUES('John'),('Jane'),('Mary'),('David'),('Amelia');
 
INSERT INTO committees(name)
VALUES('John'),('Mary'),('Amelia'),('Joe');

# Third, query data from tables members and committees:
SELECT * FROM members;
SELECT * FROM committees;

# MySQL INNER JOIN clause

SELECT column_list
FROM table_1
INNER JOIN table_2 ON join_condition;

SELECT column_list
FROM table_1
INNER JOIN table_2 USING (column_name);

select 
    m.member_id, 
    m.name member1, 
    c.committee_id, 
    c.name committee1
FROM
    members m
INNER JOIN committees c 
    ON m.name = c.name;

SELECT 
    m.member_id, 
    m.name member1, 
    c.committee_id, 
    c.name committee1
FROM
    members m
INNER JOIN committees c USING(name);

# MySQL LEFT JOIN clause
SELECT column_list 
FROM table_1 
LEFT JOIN table_2 ON join_condition;

SELECT column_list 
FROM table_1 
LEFT JOIN table_2 USING (column_name);

SELECT 
    m.member_id, 
    m.name member1, 
    c.committee_id, 
    c.name committee1
FROM
    members m
LEFT JOIN committees c USING(name);

SELECT 
    m.member_id, 
    m.name member1, 
    c.committee_id, 
    c.name committee1
FROM
    members m
LEFT JOIN committees c USING(name);

SELECT 
    m.member_id, 
    m.name member1, 
    c.committee_id, 
    c.name committee1
FROM
    members m
LEFT JOIN committees c USING(name)
WHERE c.committee_id IS NULL;

# MySQL RIGHT JOIN clause
SELECT column_list 
FROM table_1 
RIGHT JOIN table_2 USING (column_name)
WHERE column_table_1 IS NULL;

SELECT 
    m.member_id, 
    m.name member1, 
    c.committee_id, 
    c.name committee1
FROM
    members m
RIGHT JOIN committees c on c.name = m.name;

SELECT 
    m.member_id, 
    m.name member1, 
    c.committee_id, 
    c.name committee1
FROM
    members m
RIGHT JOIN committees c USING(name)
WHERE m.member_id IS NULL;

# MySQL CROSS JOIN clause
# suppose first table has m rows and second table has n rows. Cross join results in mxn rows.
# Makes a Cartesian product of rows from joined tables.
SELECT 
    m.member_id, 
    m.name member1, 
    c.committee_id, 
    c.name committee1
FROM
    members m
CROSS JOIN committees c;


# MySQL INNER JOIN
# Introduction to MySQL INNER JOIN clause
SELECT
    select_list
FROM t1
INNER JOIN t2 ON join_condition1
INNER JOIN t3 ON join_condition2
...;

# MySQL INNER JOIN examples
SELECT 
    productCode, 
    productName, 
    textDescription
FROM
    products t1
INNER JOIN productlines t2 
    ON t1.productline = t2.productline;
    
SELECT 
    productCode, 
    productName, 
    textDescription
FROM
    products
INNER JOIN productlines USING (productline);

# MySQL INNER JOIN with GROUP BY clause example
SELECT 
    t1.orderNumber,
    t1.status,
    SUM(quantityOrdered * priceEach) total
FROM
    orders t1
INNER JOIN orderdetails t2 
    ON t1.orderNumber = t2.orderNumber
GROUP BY orderNumber;

SELECT 
    orderNumber,
    status,
    SUM(quantityOrdered * priceEach) total
FROM
    orders
INNER JOIN orderdetails USING (orderNumber)
GROUP BY orderNumber;

# MySQL INNER JOIN – join three tables example
SELECT 
    orderNumber,
    orderDate,
    orderLineNumber,
    productName,
    quantityOrdered,
    priceEach
FROM
    orders
INNER JOIN
    orderdetails USING (orderNumber)
INNER JOIN
    products USING (productCode)
ORDER BY 
    orderNumber, 
    orderLineNumber;
    
# MySQL INNER JOIN – join four tables example
SELECT 
    orderNumber,
    orderDate,
    customerName,
    orderLineNumber,
    productName,
    quantityOrdered,
    priceEach
FROM
    orders
INNER JOIN orderdetails 
    USING (orderNumber)
INNER JOIN products 
    USING (productCode)
INNER JOIN customers 
    USING (customerNumber)
ORDER BY 
    orderNumber, 
    orderLineNumber;
    
# MySQL INNER JOIN using other operators
# Can use other operators such as greater than (>), less than (<), and not equal (<>) to form join condition
SELECT 
    orderNumber, 
    productName, 
    msrp, 
    priceEach
FROM
    products p
INNER JOIN orderdetails o 
   ON p.productcode = o.productcode
      AND p.msrp > o.priceEach
WHERE
    p.productcode = 'S10_1678';

# MySQL LEFT JOIN
# Introduction to MySQL LEFT JOIN
SELECT 
    select_list
FROM
    t1
LEFT JOIN t2 ON 
    join_condition;
    
# MySQL LEFT JOIN examples
# 1) Using MySQL LEFT JOIN clause to join two tables
SELECT 
    customers.customerNumber, 
    customerName, 
    orderNumber, 
    status
FROM
    customers
LEFT JOIN orders ON 
    orders.customerNumber = customers.customerNumber;

SELECT
    customerNumber,
    customerName,
    orderNumber,
    status
FROM
    customers
LEFT JOIN orders USING (customerNumber);

# 2) Using MySQL LEFT JOIN clause to find unmatched rows
SELECT 
    c.customerNumber, 
    c.customerName, 
    o.orderNumber, 
    o.status
FROM
    customers c
LEFT JOIN orders o 
    ON c.customerNumber = o.customerNumber
WHERE
    orderNumber IS NULL;

# 3) Using MySQL LEFT JOIN to join three tables
SELECT 
    lastName, 
    firstName, 
    customerName, 
    checkNumber, 
    amount
FROM
    employees
LEFT JOIN customers ON 
    employeeNumber = salesRepEmployeeNumber
LEFT JOIN payments ON 
    payments.customerNumber = customers.customerNumber
ORDER BY 
    customerName, 
    checkNumber;

# Condition in WHERE clause vs. ON clause
SELECT 
    o.orderNumber, 
    customerNumber, 
    productCode
FROM
    orders o
LEFT JOIN orderDetails 
    USING (orderNumber)
WHERE
    orderNumber = 10123;

SELECT 
    o.orderNumber, 
    customerNumber, 
    productCode
FROM
    orders o
LEFT JOIN orderDetails d 
    ON o.orderNumber = d.orderNumber AND 
       o.orderNumber = 10123;
# Returns all orders but only order 10123 will have line items associated with it


# MySQL RIGHT JOIN
# Introduction to MySQL RIGHT JOIN clause
SELECT 
    select_last
FROM t1
RIGHT JOIN t2 ON 
    join_condition;

# MySQL RIGHT JOIN examples
# 1) Simple MySQL RIGHT JOIN example
SELECT 
    employeeNumber, 
    customerNumber
FROM
    customers
RIGHT JOIN employees 
    ON salesRepEmployeeNumber = employeeNumber
ORDER BY 
    employeeNumber;

# 2) Using MySQL RIGHT JOIN to find unmatching rows
SELECT 
    employeeNumber, 
    customerNumber
FROM
    customers
RIGHT JOIN employees ON 
    salesRepEmployeeNumber = employeeNumber
WHERE customerNumber is NULL
ORDER BY employeeNumber;


# MySQL CROSS JOIN
# Returns Cartesian product of rows from joined tables
SELECT * FROM t1
CROSS JOIN t2;

SELECT * FROM t1
CROSS JOIN t2
WHERE t1.id = t2.id;

# MySQL CROSS JOIN clause examples
CREATE DATABASE IF NOT EXISTS salesdb;
USE salesdb;

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    price DECIMAL(13,2 )
);
 
CREATE TABLE stores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    store_name VARCHAR(100)
);
 
CREATE TABLE sales (
    product_id INT,
    store_id INT,
    quantity DECIMAL(13 , 2 ) NOT NULL,
    sales_date DATE NOT NULL,
    PRIMARY KEY (product_id , store_id),
    FOREIGN KEY (product_id)
        REFERENCES products (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (store_id)
        REFERENCES stores (id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO products(product_name, price)
VALUES('iPhone', 699),
      ('iPad',599),
      ('Macbook Pro',1299);
 
INSERT INTO stores(store_name)
VALUES('North'),
      ('South');
 
INSERT INTO sales(store_id,product_id,quantity,sales_date)
VALUES(1,1,20,'2017-01-02'),
      (1,2,15,'2017-01-05'),
      (1,3,25,'2017-01-05'),
      (2,1,30,'2017-01-02'),
      (2,2,35,'2017-01-05');

# MySQL CROSS JOIN example
SELECT 
    store_name,
    product_name,
    SUM(quantity * price) AS revenue
FROM
    sales
        INNER JOIN
    products ON products.id = sales.product_id
        INNER JOIN
    stores ON stores.id = sales.store_id
GROUP BY store_name , product_name; 

SELECT 
    store_name, product_name
FROM
    stores AS a
        CROSS JOIN
    products AS b;

# To find out which stores have 0 sales revenue
SELECT 
    b.store_name,
    a.product_name,
    IFNULL(c.revenue, 0) AS revenue
FROM
    products AS a
        CROSS JOIN
    stores AS b
        LEFT JOIN
    (SELECT 
        stores.id AS store_id,
        products.id AS product_id,
        store_name,
            product_name,
            ROUND(SUM(quantity * price), 0) AS revenue
    FROM
        sales
    INNER JOIN products ON products.id = sales.product_id
    INNER JOIN stores ON stores.id = sales.store_id
    GROUP BY store_name , product_name) AS c ON c.store_id = b.id
        AND c.product_id= a.id
ORDER BY b.store_name;

# Uses IFNULL function to return 0 if revenue is NULL


# MySQL Self Join
# Must use table aliases

# MySQL self join examples
# 1) MySQL self join using INNER JOIN clause
SELECT 
    CONCAT(m.lastName, ', ', m.firstName) AS Manager,
    CONCAT(e.lastName, ', ', e.firstName) AS 'Direct report'
FROM
    employees e
INNER JOIN employees m ON 
    m.employeeNumber = e.reportsTo
ORDER BY 
    Manager;

# 2) MySQL self join using LEFT JOIN clause
SELECT 
    IFNULL(CONCAT(m.lastname, ', ', m.firstname),
            'Top Manager') AS 'Manager',
    CONCAT(e.lastname, ', ', e.firstname) AS 'Direct report'
FROM
    employees e
LEFT JOIN employees m ON 
    m.employeeNumber = e.reportsto
ORDER BY 
    manager DESC;

# 3) Using MySQL self join to compare successive rows
SELECT 
    c1.city, 
    c1.customerName, 
    c2.customerName
FROM
    customers c1
INNER JOIN customers c2 ON 
    c1.city = c2.city
    AND c1.customername > c2.customerName
ORDER BY 
    c1.city;
    
# In this example, the table customers is joined to itself using the following join conditions:

# c1.city = c2.city  makes sure that both customers have the same city.
# c.customerName > c2.customerName ensures that no same customer is included.















