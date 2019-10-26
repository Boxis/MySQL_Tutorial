## Section 6. Grouping data

# MySQL GROUP BY
# GROUP BY to group rows into subgroups based on values of columns or expressions.

# Introduction to MySQL GROUP BY clause
# Returns one row for each group. Reduces the number of rows int he result set.

# Often use GROUP BY with aggregate functions such as SUM, AVG, MAX, MIN, and COUNT.
SELECT 
    c1, c2,..., cn, aggregate_function(ci)
FROM
    table
WHERE
    where_conditions
GROUP BY c1 , c2,...,cn;

# GROUP BY must appear before FROM and WHERE clasuses.
# MySQL evaluates GROUP BY after the FROM, WHERE and SELECT clauses and before the HAVING, ORDER BY and LIMIT clauses

# FROM -> WHERE -> SELECT -> GROUP BY -> HAVING -> ORDER BY -> LIMIT

# MySQL GROUP BY examples

# A) Simple MySQL GROUP BY example
SELECT 
    status
FROM
    orders
GROUP BY status;

# Works like the DISTINCT operator:
SELECT DISTINCT
    status
FROM
    orders;
    
# B) Using MySQL GROUP BY with aggregate functions
SELECT 
    status, COUNT(*)
FROM
    orders
GROUP BY status;

SELECT 
    status, 
    SUM(quantityOrdered * priceEach) AS amount
FROM
    orders
INNER JOIN orderdetails 
    USING (orderNumber)
GROUP BY 
    status;

SELECT 
    orderNumber,
    SUM(quantityOrdered * priceEach) AS total
FROM
    orderdetails
GROUP BY 
    orderNumber;

# C) MySQL GROUP BY with expression example
SELECT 
    YEAR(orderDate) AS year,
    SUM(quantityOrdered * priceEach) AS total
FROM
    orders
INNER JOIN orderdetails 
    USING (orderNumber)
WHERE
    status = 'Shipped'
GROUP BY 
    YEAR(orderDate);
    
# D) Using MySQL GROUP BY with HAVING clause example
SELECT 
    YEAR(orderDate) AS year,
    SUM(quantityOrdered * priceEach) AS total
FROM
    orders
INNER JOIN orderdetails 
    USING (orderNumber)
WHERE
    status = 'Shipped'
GROUP BY 
    year
HAVING 
    year > 2003;

# The GROUP BY clause: MySQL vs. standard SQL
# Standard SQL does not allow you to use an alias in the GROUP BY. MySQL allows this.
SELECT 
    YEAR(orderDate) AS year, 
    COUNT(orderNumber)
FROM
    orders
GROUP BY 
    year;

SELECT 
    status, 
    COUNT(*) as count
FROM
    orders
GROUP BY 
    status DESC;


# MySQL HAVING

# To specify a filter condition for groups of rows or aggregates.
# Introduction to MySQL HAVING clause
SELECT 
    select_list
FROM 
    table_name
WHERE 
    search_condition
GROUP BY 
    group_by_expression
HAVING 
    group_condition;

# FROM -> WHERE -> SELECT -> GROUP BY -> HAVING -> ORDER BY -> LIMIT

# MySQL HAVING clause examples
SELECT 
    ordernumber,
    SUM(quantityOrdered) AS itemsCount,
    SUM(priceeach*quantityOrdered) AS total
FROM
    orderdetails
GROUP BY ordernumber;

SELECT 
    ordernumber,
    SUM(quantityOrdered) AS itemsCount,
    SUM(priceeach*quantityOrdered) AS total
FROM
    orderdetails
GROUP BY 
   ordernumber
HAVING 
   total > 1000;
   
SELECT 
    ordernumber,
    SUM(quantityOrdered) AS itemsCount,
    SUM(priceeach*quantityOrdered) AS total
FROM
    orderdetails
GROUP BY ordernumber
HAVING 
    total > 1000 AND 
    itemsCount > 600;

SELECT 
    a.ordernumber, 
    status, 
    SUM(priceeach*quantityOrdered) total
FROM
    orderdetails a
INNER JOIN orders b 
    ON b.ordernumber = a.ordernumber
GROUP BY  
    ordernumber, 
    status
HAVING 
    status = 'Shipped' AND 
    total > 1500;

# HAVING clause is only useful when you use it with the GROUP BY clause to generate
# the output of the high-level reports. 


# MySQL ROLLUP
# To generate subtotals and grand totals.

# Setting up a sample table
CREATE TABLE sales
SELECT
    productLine,
    YEAR(orderDate) orderYear,
    quantityOrdered * priceEach orderValue
FROM
    orderDetails
        INNER JOIN
    orders USING (orderNumber)
        INNER JOIN
    products USING (productCode)
GROUP BY
    productLine ,
    YEAR(orderDate);

SELECT 
    *
FROM
    sales;
    
# MySQL ROLLUP overview
SELECT 
    productline, 
    SUM(orderValue) totalOrderValue
FROM
    sales
GROUP BY 
    productline;

SELECT 
    SUM(orderValue) totalOrderValue
FROM
    sales;

SELECT 
    productline, 
    SUM(orderValue) totalOrderValue
FROM
    sales
GROUP BY 
    productline 
UNION ALL
SELECT 
    NULL, 
    SUM(orderValue) totalOrderValue
FROM
    sales;

# ROLLUP clause is an extension of the GROUP BY clause with following syntax:
SELECT 
    select_list
FROM 
    table_name
GROUP BY
    c1, c2, c3 WITH ROLLUP;
    
SELECT 
    productLine, 
    SUM(orderValue) totalOrderValue
FROM
    sales
GROUP BY 
    productline WITH ROLLUP;


# GROUP BY c1, c2, c3 WITH ROLLUP
# Assumes following hierarchy:
# c1 > c2 > c3
# Generates following grouping sets:
# (c1, c2, c3)
# (c1, c2)
# (c1)
# ()

SELECT 
    productLine, 
    orderYear,
    SUM(orderValue) totalOrderValue
FROM
    sales
GROUP BY 
    productline, 
    orderYear 
WITH ROLLUP;

# ROLLUP generates the subtotal row every time the product line changes and the grand total
# at the end of the result.

# Hierarchy in this case is:
# productLine > orderYear

SELECT 
    orderYear,
    productLine, 
    SUM(orderValue) totalOrderValue
FROM
    sales
GROUP BY 
    orderYear,
    productline
WITH ROLLUP;

# Hierarchy:
# orderYear > productLine

# GROUPING() function
# To check whether NULL in the result set represents the subtotals or grand totals, you use the
# GROUPING() function.
# Returns 1 when NULL occurs in a super-aggregate row, otherwise it returns 0.

SELECT 
    orderYear,
    productLine, 
    SUM(orderValue) totalOrderValue,
    GROUPING(orderYear),
    GROUPING(productLine)
FROM
    sales
GROUP BY 
    orderYear,
    productline
WITH ROLLUP;

# Often use GROUPING() function to substitute meaningful labels for super-aggregate NULL values
# instead of displaying it directly.

# Following example shows how to combine the IF() function with the GROUPING() function to
# substitute labels for the super-aggregate NULL values in orderYear and productLine columns:
SELECT 
    IF(GROUPING(orderYear),
        'All Years',
        orderYear) orderYear,
    IF(GROUPING(productLine),
        'All Product Lines',
        productLine) productLine,
    SUM(orderValue) totalOrderValue
FROM
    sales
GROUP BY 
    orderYear , 
    productline 
WITH ROLLUP;









    














