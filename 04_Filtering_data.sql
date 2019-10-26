## Section 4. Filtering data
# MySQL WHERE
SELECT
	select_list
FROM
	table_name
WHERE
	search_condition;

# search_condition is a combo of one or more predicates using logical operator AND, OR and NOT
# in MySQL, a predicate is a Boolean expression that evaluates to TRUE, FALSE or UNKNOWN

# FROM -> WHERE -> SELECT -> ORDER BY

# 1) Using MySQL WHERE clause with equal operator example
SELECT
	lastname,
    firstname,
    jobtitle
FROM
	employees
WHERE
	jobtitle = 'Sales Rep';
    
# 2) Using MySQL WHERE clause with AND operator
SELECT
	lastname,
    firstname,
    jobtitle,
    officeCode
FROM
	employees
WHERE
	jobtitle = 'Sales Rep' AND
    officeCode = 1;

# 3) Using MySQL WHERE clause with OR operator
SELECT 
    lastName, 
    firstName, 
    jobTitle, 
    officeCode
FROM
    employees
WHERE
    jobtitle = 'Sales Rep' OR 
    officeCode = 1
ORDER BY 
    officeCode , 
    jobTitle;

# 4) Using MySQL WHERE with BETWEEN operator example
# expression BETWEEN low and high
SELECT 
    firstName, 
    lastName, 
    officeCode
FROM
    employees
WHERE
    officeCode BETWEEN 1 AND 3
ORDER BY officeCode;

# 5) Using MySQL WHERE with the LIKE operator example
# use % and _ wildcards. % wildcard matches any string or zero or more cahracters while the _ wildcard
# matches any single character.

# query finds employees with last names end with the string 'son':
SELECT 
    firstName, 
    lastName
FROM
    employees
WHERE
    lastName LIKE '%son'
ORDER BY firstName;

# 6) Using MySQL WHERE clause with the IN operator example
# value IN (value1, value2, ...)
SELECT 
    firstName, 
    lastName, 
    officeCode
FROM
    employees
WHERE
    officeCode IN (1 , 2, 3)
ORDER BY 
    officeCode;

# 7) Using MySQL WHERE clause with the IS NULL operator
# value IS NULL
SELECT 
    lastName, 
    firstName, 
    reportsTo
FROM
    employees
WHERE
    reportsTo IS NULL;

# 8) Using MySQL WHERE clause with comparsion operators
# Operator	Description
# =	  		Equal to. You can use it with almost any data types.
# <> or !=	Not equal to
# <			Less than. You typically use it with numeric and date/time data types.
# >			Greater than.
# <=		Less than or equal to
# >=		Greater than or equal to

SELECT 
    lastname, 
    firstname, 
    jobtitle
FROM
    employees
WHERE
    jobtitle <> 'Sales Rep';

SELECT 
    lastname, 
    firstname, 
    officeCode
FROM
    employees
WHERE 
    officecode > 5;
    
SELECT 
    lastname, 
    firstname, 
    officeCode
FROM
    employees
WHERE 
    officecode <= 4;
    

# MySQL DISTINCT
SELECT DISTINCT
	select_list
FROM
	table_name;

SELECT 
    lastname
FROM
    employees
ORDER BY 
    lastname;

SELECT 
    DISTINCT lastname
FROM
    employees
ORDER BY 
    lastname;
    
# MySQL DISTINCT and NULL values
SELECT DISTINCT state
FROM customers;

# MySQL DISTINCT with multiple columns
# combo of state and city distinct
SELECT DISTINCT
    state, city
FROM
    customers
WHERE
    state IS NOT NULL
ORDER BY 
    state, 
    city;

# without distinct, you get duplicates
SELECT 
    state, city
FROM
    customers
WHERE
    state IS NOT NULL
ORDER BY 
    state , 
    city;

# DISTINCT clause vs. GROUP BY clause
SELECT 
    state
FROM
    customers
GROUP BY state;
# behaves like DISTINCT

SELECT DISTINCT
    state
FROM
    customers;

# difference is that GROUP BY sorts the result set whereas DISTINCT does not

SELECT DISTINCT
    state
FROM
    customers
ORDER BY 
    state;

# MySQL DISTINCT and aggregate functions
# You can use DISTINCT with agg function (SUM, AVG, COUNT) to remove duplicate rows
# before the agg functions are applied to the result set.
SELECT 
    COUNT(DISTINCT state)
FROM
    customers
WHERE
    country = 'USA';
    
# MySQL DISTINCT with LIMIT clause
SELECT DISTINCT
    state
FROM
    customers
WHERE
    state IS NOT NULL
LIMIT 5;


# MySQL AND Operator
# AND operator to combine multiple Boolean expressions to filter data
	
# boolean_expression_1 AND boolean_expression_2
# 		TRUE	FALSE	NULL
# TRUE	TRUE	FALSE	NULL
# FALSE	FALSE	FALSE	FALSE
# NULL	NULL	FALSE	NULL

SELECT 1 = 0 AND 1 / 0 ;

SELECT 
    customername, 
    country, 
    state
FROM
    customers
WHERE
    country = 'USA' AND state = 'CA';
    
SELECT    
    customername, 
    country, 
    state, 
    creditlimit
FROM    
    customers
WHERE country = 'USA'
    AND state = 'CA'
    AND creditlimit > 100000;


# MySQL OR Operator

# boolean_expression_1 OR boolean_expression_2

#	    TRUE	FALSE	NULL
# TRUE	TRUE	TRUE	TRUE
# FALSE	TRUE	FALSE	NULL
# NULL	TRUE	NULL	NULL
	
SELECT 1 = 1 OR 1 / 0;

# Operator precedence
SELECT true OR false AND false;
# 1. evalutes AND operator, therefore false AND false returns false.
# 2. evalutes OR operator, hence, true OR false returns true.

# Change order
SELECT (true OR false) AND false;

# MySQL OR operator examples
use classicmodels;
SELECT    
    customername, 
    country
FROM    
    customers
WHERE country = 'USA' OR 
      country = 'France';

SELECT   
    customername, 
    country, 
    creditLimit
FROM   
    customers
WHERE(country = 'USA'
        OR country = 'France')
      AND creditlimit > 100000;

SELECT    
    customername, 
    country, 
    creditLimit
FROM    
    customers
WHERE country = 'USA'
        OR country = 'France'
        AND creditlimit > 10000;  

# MySQL IN
SELECT 
    column1,column2,...
FROM
    table_name
WHERE 
    (expr|column_1) IN ('value1','value2',...);
    
# MySQL IN operator examples
SELECT 
    officeCode, 
    city, 
    phone, 
    country
FROM
    offices
WHERE
    country IN ('USA' , 'France');

SELECT 
    officeCode, 
    city, 
    phone
FROM
    offices
WHERE
    country = 'USA' OR country = 'France';

SELECT 
    officeCode, 
    city, 
    phone
FROM
    offices
WHERE
    country NOT IN ('USA' , 'France');
    
# Using MySQL IN with a subquery
SELECT    
    orderNumber, 
    customerNumber, 
    status, 
    shippedDate
FROM    
    orders
WHERE orderNumber IN
(
     SELECT 
         orderNumber
     FROM 
         orderDetails
     GROUP BY 
         orderNumber
     HAVING SUM(quantityOrdered * priceEach) > 60000
);

# Whole query can be broken down into two separate queries:
SELECT 
    orderNumber
FROM
    orderDetails
GROUP BY 
    orderNumber
HAVING 
    SUM(quantityOrdered * priceEach) > 60000;

SELECT 
    orderNumber, 
    customerNumber, 
    status, 
    shippedDate
FROM
    orders
WHERE
    orderNumber IN (10165,10287,10310);

# MySQL BETWEEN

# expr [NOT] BETWEEN begin_expr AND end_expr;

# MySQL BETWEEN operator examples
# 1) Using MySQL BETWEEN with number examples
SELECT 
    productCode, 
    productName, 
    buyPrice
FROM
    products
WHERE
    buyPrice BETWEEN 90 AND 100;

SELECT 
    productCode, 
    productName, 
    buyPrice
FROM
    products
WHERE
    buyPrice >= 90 AND buyPrice <= 100;

SELECT 
    productCode, 
    productName, 
    buyPrice
FROM
    products
WHERE
    buyPrice NOT BETWEEN 20 AND 100;

SELECT 
    productCode, 
    productName, 
    buyPrice
FROM
    products
WHERE
    buyPrice < 20 OR buyPrice > 100;

# 2) Using MySQL BETWEEN with dates example
SELECT 
   orderNumber,
   requiredDate,
   status
FROM 
   orders
WHERE 
   requireddate BETWEEN 
     CAST('2003-01-01' AS DATE) AND 
     CAST('2003-01-31' AS DATE);


# MySQL LIKE
# query data based on a specified pattern

# Introduction to MySQL LIKE operator
# expression LIKE pattern ESCAPE escape_character

# the (%) wildcard matches any string of zero or more characters.
# the (_) wildcard matches any single character.

# for exmaple, s% matches any string starts with character s such as sun and six
# se_ matches any string that starts with se and followed by any character such as see and sea

# MySQL LIKE operator examples
# A) Using MySQL LIKE with the percentage (%) wildcard examples
SELECT 
    employeeNumber, 
    lastName, 
    firstName
FROM
    employees
WHERE
    firstName LIKE 'a%';

SELECT 
    employeeNumber, 
    lastName, 
    firstName
FROM
    employees
WHERE
    lastName LIKE '%on';

SELECT 
    employeeNumber, 
    lastName, 
    firstName
FROM
    employees
WHERE
    lastname LIKE '%on%';

# B) Using MySQL LIKE with underscore( _ ) wildcard examples
SELECT 
    employeeNumber, 
    lastName, 
    firstName
FROM
    employees
WHERE
    firstname LIKE 'T_m';

# C) Using MySQL LIKE operator with the NOT operator example
SELECT 
    employeeNumber, 
    lastName, 
    firstName
FROM
    employees
WHERE
    lastName NOT LIKE 'B%';

# MySQL LIKE operator with ESCAPE clause
# you can use the ESCAPE clause to specify character so that MySQL will interpret
# the wildcard character as a literal character. If you don't specify the escape explicitly,
# the backslash character \ is the default escape character
SELECT 
    productCode, 
    productName
FROM
    products
WHERE
    productCode LIKE '%\_20%';

SELECT 
    productCode, 
    productName
FROM
    products
WHERE
    productCode LIKE '%$_20%' ESCAPE '$';

# the %$_20% matches any string that contains the _20 string.


# MySQL LIMIT

# Introduction to MySQL LIMIT clause
SELECT 
    select_list
FROM
    table_name
LIMIT [offset,] row_count;

# offset specifies the offset of the first row to return. offset of first row is 0, not 1.
# row_count specifies the maximum number of rows to return.

LIMIT row_count;
LIMIT 0 , row_count;
LIMIT row_count OFFSET offset

SELECT select_list
FROM table_name
ORDER BY order_expression
LIMIT offset, row_count;

# FROM -> WHERE -> SELECT -> ORDER BY -> LIMIT

# MySQL LIMIT examples
# 1) Using MySQL LIMIT to get the highest or lowest rows
# top five customers who have highest credit:
SELECT 
    customerNumber, 
    customerName, 
    creditLimit
FROM
    customers
ORDER BY creditLimit DESC
LIMIT 5;

# lowest five custoemrs with credit score
SELECT 
    customerNumber, 
    customerName, 
    creditLimit
FROM
    customers
ORDER BY creditLimit
LIMIT 5;

# add another column in ORDER BY to constrain row in unique order:
SELECT 
    customerNumber, 
    customerName, 
    creditLimit
FROM
    customers
ORDER BY 
    creditLimit, 
    customerNumber
LIMIT 5;

# 2) Using MySQL LIMIT for pagination
# suppose you want to divide rows into pages, where each page contains a certain number of rows 
# like 5, 10, or 20.

# Use COUNT(*) to see total number of rows
SELECT COUNT(*) FROM customers;

SELECT 
    customerNumber, 
    customerName
FROM
    customers
ORDER BY customerName    
LIMIT 10;

# Shows rows 11 - 20
SELECT 
    customerNumber, 
    customerName
FROM
    customers
ORDER BY customerName    
LIMIT 10, 10;

# 3) Using MySQL LIMIT to get the nth highest or lowest value
# To gfet the nth highest or lowest value, use the following LIMIT clause:
SELECT select_list
FROM table_name
ORDER BY sort_expression
LIMIT n-1, 1;

# Find customer with second-highest credit:
SELECT 
    customerName, 
    creditLimit
FROM
    customers
ORDER BY 
    creditLimit DESC    
LIMIT 1,1;

SELECT 
    customerName, 
    creditLimit
FROM
    customers
ORDER BY 
    creditLimit DESC;
    

# MySQL IS NULL
# IS NULL operator test whether a value is NULL or not.

# Introduction to MySQL IS NULL operator
value IS NULL;

SELECT 1 IS NULL,  -- 0
       0 IS NULL,  -- 0
       NULL IS NULL; -- 1
      
# To check if a value is not ULL, you use IS NOT NULL operator as follows:
value IS NOT NULL;

SELECT 1 IS NOT NULL, -- 1
       0 IS NOT NULL, -- 1
       NULL IS NOT NULL; -- 0

# MySQL IS NULL examples
SELECT 
    customerName, 
    country, 
    salesrepemployeenumber
FROM
    customers
WHERE
    salesrepemployeenumber IS NULL
ORDER BY 
    customerName; 

SELECT 
    customerName, 
    country, 
    salesrepemployeenumber
FROM
    customers
WHERE
    salesrepemployeenumber IS NOT NULL
ORDER BY 
   customerName;

# MySQL IS NULL – specialized features
CREATE TABLE IF NOT EXISTS projects (
    id INT AUTO_INCREMENT,
    title VARCHAR(255),
    begin_date DATE NOT NULL,
    complete_date DATE NOT NULL,
    PRIMARY KEY(id)
);
 
INSERT INTO projects(title,begin_date, complete_date)
VALUES('New CRM','2020-01-01','0000-00-00'),
      ('ERP Future','2020-01-01','0000-00-00'),
      ('VR','2020-01-01','2030-01-01');
  
SELECT * FROM projects
WHERE complete_date IS NULL;

SET @@sql_auto_is_null = 1;

INSERT INTO projects(title,begin_date, complete_date)
VALUES('MRP III','2010-01-01','2020-12-31');

SELECT 
    id
FROM
    projects
WHERE
    id IS NULL;

# MySQL IS NULL Optimization
SELECT 
    customerNumber, 
    salesRepEmployeeNumber
FROM
    customers
WHERE
    salesRepEmployeeNumber IS NULL;
    
EXPLAIN SELECT 
    customerNumber, 
    salesRepEmployeeNumber
FROM
    customers
WHERE
    salesRepEmployeeNumber IS NULL;

EXPLAIN SELECT 
    customerNumber,
    salesRepEmployeeNumber
FROM
    customers
WHERE
    salesRepEmployeeNumber = 1370 OR
    salesRepEmployeeNumber IS NULL;
    
SELECT * FROM t1
WHERE c1 IS NULL;














    