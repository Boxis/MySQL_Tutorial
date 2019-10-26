## Section 7. Subqueries

# MySQL Subquery
# A MySQL subquery is a query nested within another query such as SELECT, INSERT, UPDATE, or DELETE.
# A subquery can be neseted inside another subquery.

# A subquery is called an innery query while the query that contains the subquery is called an outer
# query. A subquery can be used anywhere that expression is used and must be closed in parentheses.

# The following query returns employees who work in offices located in the USA.

SELECT
	lastName, firstName
FROM
	employees
WHERE
	officeCode IN (SELECT
			officeCode
        FROM
			offices
		WHERE
			country = 'USA');

# Subquery runs first and returns a result set. Then, this result set is used as an input
# for the outer query.alter

# MySQL subquery in WHERE clause

# Can use comparison operators e.g., =, >, < to compare a single value returned by the subquery
# with the expression in the WHERE clause.

# The following query returns the customer who has the maximum payment.

SELECT
	customerNumber,
    checkNumber,
    amount
FROM
	payments
WHERE
	amount = (SELECT MAX(amount) FROM payments);

# The following shows customers where payments are greater than the average payment using a subquery:
SELECT
	customerNumber,
    checkNumber,
    amount
FROM
	payments
WHERE
	amount > (SELECT
				AVG(amount)
			FROM
				payments);

# MySQL subquery with IN and NOT IN operators
# If a subquery returns more than one value, you can use other operators such as IN or NOT IN operator
# in the WHERE clause

# Subquery example: use NOT IN opeartor to find customers who have not placed any order as follows:
SELECT 
    customerName
FROM
    customers
WHERE
    customerNumber NOT IN (SELECT DISTINCT
            customerNumber
        FROM
            orders);

# MySQL subquery in the FROM clause
# Can use the subquery in the FROM clause, the result set returned from a subquery is used as a
# temporary table. This table is referred to as a derived table or materialized subquery.

# Following subquery finds the maximum, minimum, and average number of items in sale orders:

SELECT 
    MAX(items), 
    MIN(items), 
    FLOOR(AVG(items))
FROM
    (SELECT 
        orderNumber, COUNT(orderNumber) AS items
    FROM
        orderdetails
    GROUP BY orderNumber) AS lineitems;

# Note that the FLOOR() is used to remove decimal places from the average values of items.

# MySQL correlated subquery

# Previous example, the subquery is independent. Meaning you can execute it as a standalone query:
SELECT 
    orderNumber, 
    COUNT(orderNumber) AS items
FROM
    orderdetails
GROUP BY orderNumber;

# A correlated subquery is a subquery that uses data from the outer query. It depends on the outer query.
# A correlated subquery is evaluted once for each row in the outer query.

# Example: Select products whose buy prices are greater than the average buy price of all products
# in each product line.
SELECT 
    productname, 
    buyprice
FROM
    products p1
WHERE
    buyprice > (SELECT 
            AVG(buyprice)
        FROM
            products
        WHERE
            productline = p1.productline);
            
# The inner query executes for every product line because product line is changed for every row.
# The average buy price will also change. The outer query filters only products whose buy price is
# greater than the average buy price per product line from the subquery.

# MySQL subquery with EXISTS and NOT EXISTS

# When a subquery is used with the EXISTS or NOT EXISTS operator, a subquery returns a Boolean value
# of TRUE or FALSE. The following query illustrates a subquery used with the EXISTS operator:
SELECT 
    *
FROM
    table_name
WHERE
    EXISTS( subquery );
# If the subquery returns any rows, EXISTS subquery returns TRUE, otherwise it returns FALSE
# EXISTS and NOT EXISTS are often used in correlated subqueries.

# Example: Finds sales orders whose total values are greater than 60K.
SELECT 
    orderNumber, 
    SUM(priceEach * quantityOrdered) total
FROM
    orderdetails
        INNER JOIN
    orders USING (orderNumber)
GROUP BY orderNumber
HAVING SUM(priceEach * quantityOrdered) > 60000;

# It returns 3 rows, meaning that there are 3 sales orders whose total values are greater than 60K.

# You can use the query above as a correlated subquery to find customers who placed at least one sales
# order with the total value greater than 60K by using the EXISTS operator:
SELECT 
    customerNumber, 
    customerName
FROM
    customers
WHERE
    EXISTS( SELECT 
            orderNumber, SUM(priceEach * quantityOrdered)
        FROM
            orderdetails
                INNER JOIN
            orders USING (orderNumber)
        WHERE
            customerNumber = customers.customerNumber
        GROUP BY orderNumber
        HAVING SUM(priceEach * quantityOrdered) > 60000);

        
# An Essential Guide to MySQL Derived Table

# Introduction to MySQL derived table
# A derived table is a virtual table returned from a SELECT statement. A derived table is similar to a
# temporary table, but using a derived table in the SELECT statement is much simpler than a temporary 
# table because it does not require steps of creating a temporary table.

# The term derived table and subquery is often used interchangeably. When a stand-alone subquery is used 
# in the FROM clause of a SELECT statement, we call it a derived table.

# Deriverd table must have an alias

SELECT 
    column_list
FROM
    (SELECT 
        column_list
    FROM
        table_1) derived_table_name;
WHERE derived_table_name.c1 > 0;

# A simple MySQL derived table example

# Following query gets top 5 products by sales revenue in 2003 from orders and orderdetails tables:
SELECT 
    productCode, 
    ROUND(SUM(quantityOrdered * priceEach)) sales
FROM
    orderdetails
        INNER JOIN
    orders USING (orderNumber)
WHERE
    YEAR(shippedDate) = 2003
GROUP BY productCode
ORDER BY sales DESC
LIMIT 5;

# You can use the result of this query as a derived table and join it with the products table as follows:
SELECT 
    productName, sales
FROM
    (SELECT 
        productCode, 
        ROUND(SUM(quantityOrdered * priceEach)) sales
    FROM
        orderdetails
    INNER JOIN orders USING (orderNumber)
    WHERE
        YEAR(shippedDate) = 2003
    GROUP BY productCode
    ORDER BY sales DESC
    LIMIT 5) top5products2003
INNER JOIN
    products USING (productCode);

# A more complex MySQL derived table example

# Suppose you have to classify the customers in the year 2003 into 3 groups: platinum, gold and silver.
# You need to know the number of customers in each group with the following conditions:
	# 1. Plantinum customers who have orders with volume greater than 100K
    # 2. Gold customers who have orders with volume between 10K and 100K
    # 3. Silver customers who have orders with volume less than 10K
# To construct this query, first, you need to put each custoemr into their respective group using
# CASE expression and GROUP BY clause as follows:

SELECT 
    customerNumber,
    ROUND(SUM(quantityOrdered * priceEach)) sales,
    (CASE
        WHEN SUM(quantityOrdered * priceEach) < 10000 THEN 'Silver'
        WHEN SUM(quantityOrdered * priceEach) BETWEEN 10000 AND 100000 THEN 'Gold'
        WHEN SUM(quantityOrdered * priceEach) > 100000 THEN 'Platinum'
    END) customerGroup
FROM
    orderdetails
        INNER JOIN
    orders USING (orderNumber)
WHERE
    YEAR(shippedDate) = 2003
GROUP BY customerNumber;

# Then, you use this query as the derived table and perform following grouping:
SELECT 
    customerGroup, 
    COUNT(cg.customerGroup) AS groupCount
FROM
    (SELECT 
        customerNumber,
            ROUND(SUM(quantityOrdered * priceEach)) sales,
            (CASE
                WHEN SUM(quantityOrdered * priceEach) < 10000 THEN 'Silver'
                WHEN SUM(quantityOrdered * priceEach) BETWEEN 10000 AND 100000 THEN 'Gold'
                WHEN SUM(quantityOrdered * priceEach) > 100000 THEN 'Platinum'
            END) customerGroup
    FROM
        orderdetails
    INNER JOIN orders USING (orderNumber)
    WHERE
        YEAR(shippedDate) = 2003
    GROUP BY customerNumber) cg
GROUP BY cg.customerGroup;   


# MySQL EXISTS

# Introduction to MySQL EXISTS operator
# The EXISTS operator is a Boolean operator that returns either true or false. The EXISTS operator is often
# used to test for the existence of rows returned by the subquery.

# The following illustrates the basic syntax of the EXISTS operator:
SELECT 
    select_list
FROM
    a_table
WHERE
    [NOT] EXISTS(subquery);

# If subquery returns at least one row, the EXISTS operator returns true, otherwise, it returns false.
# Terminates processing immediately if it finds matching row, can improve performance of query.

# MySQL EXISTS operator examples

# MySQL SELECT EXISTS examples

# The following statement uses the EXISTS operator to find the customer who has at least one order:
    
SELECT 
    customerNumber, 
    customerName
FROM
    customers
WHERE
    EXISTS(
    SELECT 
            1
        FROM
            orders
        WHERE
            orders.customernumber 
        = customers.customernumber);

# The following example uses the NOT EXISTS operator to find customers who do not have any orders:
SELECT 
    customerNumber, 
    customerName
FROM
    customers
WHERE
    NOT EXISTS( 
    SELECT 
            1
        FROM
            orders
        WHERE
            orders.customernumber = customers.customernumber
    );

# MySQL UPDATE EXISTS examples

# The following statement finds employees who work at the office in San Franciso:
SELECT 
    employeenumber, 
    firstname, 
    lastname, 
    extension
FROM
    employees
WHERE
    EXISTS( 
        SELECT 
            1
        FROM
            offices
        WHERE
            city = 'San Francisco' AND 
           offices.officeCode = employees.officeCode);

# This example adds the number 1 to the phone extension of employees who work at the office in
# San Franciso:
UPDATE employees 
SET 
    extension = CONCAT(extension, '1')
WHERE
    EXISTS( 
        SELECT 
            1
        FROM
            offices
        WHERE
            city = 'San Francisco'
                AND offices.officeCode = employees.officeCode);

# MySQL INSERT EXISTS example
# Suppose you want to archive customers who don't have any sales order in a separate table. To do this,
# you can use these steps:

# First, create a new table for archiving the customers by copying the structure from the customers table:
CREATE TABLE customers_archive 
LIKE customers;

# Second, insert customers who do not have any sales order into the customers_archive table using the
# following INSERT statement.
INSERT INTO customers_archive
SELECT * 
FROM customers
WHERE NOT EXISTS( 
   SELECT 1
   FROM
       orders
   WHERE
       orders.customernumber = customers.customernumber
);

# Third, query data from customers_archive table to verify the insert operation.
SELECT * FROM customers_archive;

# MySQL DELETE EXISTS example

# One final task in archiving the customer data is to delete the customers that exist in the
# customers_archive table from the customers table.

# To do this, you can use the EXISTS operator in WHERE clause of the DELETE statement as follows:
DELETE FROM customers
WHERE EXISTS( 
    SELECT 
        1
    FROM
        customers_archive a
    
    WHERE
        a.customernumber = customers.customerNumber);

# MySQL EXISTS operator vs. IN operator
# To find the customer who has placed at least one order, you can use the IN operator as shown in the
# following query:
SELECT 
    customerNumber, 
    customerName
FROM
    customers
WHERE
    customerNumber IN (
        SELECT 
            customerNumber
        FROM
            orders);

# Let's compare the query that uses the IN operator with the one that uses the EXISTS operator by using
# the EXPLAIN statement.
EXPLAIN SELECT 
    customerNumber, 
    customerName
FROM
    customers
WHERE
    EXISTS( 
        SELECT 
            1
        FROM
            orders
        WHERE
            orders.customernumber = customers.customernumber);

# Now check the performance of the query that uses the IN operator.
SELECT 
    customerNumber, customerName
FROM
    customers
WHERE
    customerNumber IN (SELECT 
            customerNumber
        FROM
            orders);

# The query that uses the EXISTS operator is much faster than the one that uses the IN operator.
# EXISTS operator works based on the "at least found" principle. The EXISTS stops
# scanning the table when a matching row is found.

# IN operator is combined with a subquery, MySQL must process the subquery first and then uses the result of the 
# subquery to process the whole query.alter

# The general rule of thumb is that if the subquery contains a large volume of data, the EXISTS operator
# provides better performance.

# However, the query that uses the IN operator will perform faster if the result set returned from the 
# subquery is very small.

# For example, the following statement uses the IN operator selects all employees who work at the office 
# in San Franciso.
SELECT 
    employeenumber, 
    firstname, 
    lastname
FROM
    employees
WHERE
    officeCode IN (SELECT 
            officeCode
        FROM
            offices
        WHERE
            offices.city = 'San Francisco');
            










                







