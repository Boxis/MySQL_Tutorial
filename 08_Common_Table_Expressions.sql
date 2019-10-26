## Section 8. Common Table Expressions

# An Introduction to MySQL CTE
# Learn how to use MySQL CTE or common table expression to construct complex queries in a more readable manner.

# What is a common table expression or CTE
# A named temporary result set that exists only within execution scope of a single SQL statement 
# e.g. SELECT, INSERT, UDPATE, or DELETE.

# Similar to a derived table, a CTE is not stored as an object and last only during the execution of a query.

# Unlike a derived table, a CTE can be self-referencing (a recursive CTE) or can be referened multiple
# times in the same query. In addition, a CTE provides better readability and performance in comparison
# with a derived table.

# MySQL CTE syntax
# CTE structure includes the name, an optional column list, and a query that defines the CTE.
# After the CTE is defined, you can use it as a view in a SELECT, INSERT, UPDATE, DELETE or CREATE VIEW
# statement.

WITH cte_name (column_list) AS (
    query
) 
SELECT * FROM cte_name;

# The columns in the query must be the same as the number of columns in the column_list.
# If you omit the column_list, the CTE will use the column list of the query that defines the CTE

# Simple MySQL CTE examples
WITH customers_in_usa AS (
    SELECT 
        customerName, state
    FROM
        customers
    WHERE
        country = 'USA'
) SELECT 
    customerName
 FROM
    customers_in_usa
 WHERE
    state = 'CA'
 ORDER BY customerName;
 
 # In the above example, the name of the CTE is customers_in_usa, the query that defines the CTE returns two
 # columns, customerName and state. Hence, the customers_in_usa CTE returns all customers located in the USA.
 
 # After defining the customers_in_usa CTE, we referenced in the SELECT statement to select only customers located
 # in California.
 
 WITH topsales2003 AS (
    SELECT 
        salesRepEmployeeNumber employeeNumber,
        SUM(quantityOrdered * priceEach) sales
    FROM
        orders
            INNER JOIN
        orderdetails USING (orderNumber)
            INNER JOIN
        customers USING (customerNumber)
    WHERE
        YEAR(shippedDate) = 2003
            AND status = 'Shipped'
    GROUP BY salesRepEmployeeNumber
    ORDER BY sales DESC
    LIMIT 5
)
SELECT 
    employeeNumber, 
    firstName, 
    lastName, 
    sales
FROM
    employees
        JOIN
    topsales2003 USING (employeeNumber);

# In this exmaple, the CTE returns the top 5 sales rep in 2003. After that, we referenced to the
# topsales2003 CTE to get additoinal info about each sales rep including first and last name.

# A more advanced MySQL CTE example

WITH salesrep AS (
    SELECT 
        employeeNumber,
        CONCAT(firstName, ' ', lastName) AS salesrepName
    FROM
        employees
    WHERE
        jobTitle = 'Sales Rep'
),
customer_salesrep AS (
    SELECT 
        customerName, salesrepName
    FROM
        customers
            INNER JOIN
        salesrep ON employeeNumber = salesrepEmployeeNumber
)
SELECT 
    *
FROM
    customer_salesrep
ORDER BY customerName;

# In this example, we have two CTEs in the same query. The first CTE (salesrep) gets the employees
# whose job titles are the sales representative. The second CTE (customer_salesrep) references the first
# CTE in the INNER JOIN clause to get the sales rep and customers of whom each sales rep is in charge.

# After having the second CTE, we query data from that CTE using a simple SELECT statement with the
# ORDER BY clause.

# The WITH clause usages
# There are some contexts that you can use the WITH clause to make common table expressions:

# First, a WITH clause can be used at the beginning of SELECT, UPDATE, and DELETE statements:
WITH ... SELECT ...
WITH ... UPDATE ...
WITH ... DELETE ...

# Second, a WITH clause can be used at the beginning of a subquery or a derived table subquery:
SELECT ... WHERE id IN (WITH ... SELECT ...);
 
SELECT * FROM (WITH ... SELECT ...) AS derived_table;

# Third, a WITH clause can be used immediately preceding SELECT of the statements that include a SELECT
# clause:
CREATE TABLE ... WITH ... SELECT ...
CREATE VIEW ... WITH ... SELECT ...
INSERT ... WITH ... SELECT ...
REPLACE ... WITH ... SELECT ...
DECLARE CURSOR ... WITH ... SELECT ...
EXPLAIN ... WITH ... SELECT ...


# A Definitive Guide To MySQL Recursive CTE
# Learn about MySQL recursive CTE and how to use it to traverse hierarchical data.

# Introduction to MySQL recursive CTE
# A recursive CTE is a CTE that has a subquery which refers to the CTE name itself.
# The following illustrates the syntax of a recursive CTE

WITH RECURSIVE cte_name AS (
    initial_query  -- anchor member
    UNION ALL
    recursive_query -- recursive member that references to the CTE name
)
SELECT * FROM cte_name;

# A recursive CTE consists of three main parts:
	# An intial query that forms the base result set of the CTE structure. The inital query part is referred to
    # as an anchor member.
    # A recursive query part is a query that references to the CTE name, therfore, it is called a recursive
    # member. The recursive member is joined with the anchor member by a UNION ALL or UNION DISTINCT operator.
    # A termination condition that ensures the recursion stops when the recursive member returns no row.

# The execution order of a recursive CTE is as follows:
	# 1. First, separate the members into two: anchor and recursive members.
    # 2. Next, execute the anchor member to form the base result set (R0) and use this base result set for
    # the next iteration.
    # 3. Then, execute the recursive member with Ri result set as an input and make Ri+1 as an output.
    # 4. After that, repeat the third step until the recursive member returns an empty result set, in other
    # words, the termination condition is met.
    # 5. Finally, combine result sets from R0 to Rn using UNION ALL operator.

# Recursive member restrictions
# The recursive member must not contain the following constructs:
	# Aggregate functions e.g. MAX, MIN, SUM, AVG, COUNT, etc.
    # GROUP BY clause
    # ORDER BY clause
    # LIMIT clause
    # DISTINCT
    
# Note, the above constraint does not apply to the anchor member. Also, the prohibition on DISTINCT
# applies only when you use UNION operator. In case you use the UNION DISTINCT operator, the DISTINCT
# is permitted.

# In addition, the recursive member can only reference the CTE name once and in its FROM clause, not in any subquery.

# Simple MySQL recursive CTE example

WITH RECURSIVE cte_count (n) 
AS (
      SELECT 1
      UNION ALL
      SELECT n + 1 
      FROM cte_count 
      WHERE n < 3
    )
SELECT n 
FROM cte_count;

SELECT 1
# is the anchor that returns 1 as the base result set.

# The following query
SELECT n + 1
FROM cte_count
WHERE n < 3
# is the recursive member because it references to the name of the CTE which is cte_count.

# The expression n < 3 in the recurisve member is the termiantion condition. Once n equals 3, the
# recursive member returns an empty set that will stop the recrusion.

# The execution steps of the recursive CTE is as follows:
	# 1. First, separate the anchor and recrusive members.
    # 2. Next, the anchor member forms the initial row (SELECT 1) therefore the first iteration produces 1 + 1 = 2 with n = 1.
    # 3. Then, the second iteration operates on the output of the first iteration (2) and produces 2 + 1 = 3 with n = 2.
    # 4. After that, before the third operation (n = 3), the termination condition (n < 3) is met therefore the query stops.
    # 5. Finally, combine all result sets 1, 2, and 3 using the UNION ALL operator
    
# Using MySQL recursive CTE to traverse the hierarchical data

WITH RECURSIVE employee_paths AS
  ( SELECT employeeNumber,
           reportsTo managerNumber,
           officeCode, 
           1 lvl
   FROM employees
   WHERE reportsTo IS NULL
     UNION ALL
     SELECT e.employeeNumber,
            e.reportsTo,
            e.officeCode,
            lvl+1
     FROM employees e
     INNER JOIN employee_paths ep ON ep.employeeNumber = e.reportsTo )
SELECT employeeNumber,
       managerNumber,
       lvl,
       city
FROM employee_paths ep
INNER JOIN offices o USING (officeCode)
ORDER BY lvl, city;




















