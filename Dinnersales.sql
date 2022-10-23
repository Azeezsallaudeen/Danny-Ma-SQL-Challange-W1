CREATE DATABASE sales_sql;

USE sales_sql;

CREATE TABLE sales (
CustomerID varchar(15),
Order_date varchar (15),
Product_ID int
);

 INSERT INTO sales 
			(CustomerID, 
			Order_date,
			Product_ID)
 VALUES('A', '2021-01-01',   '1'),
		('A', '2021-01-01',	 '2'),
		('A', '2021-01-07',	 '2'),
		('A', '2021-01-11',  '3'),
		('A', '2021-01-11',  '3'),
		('B', '2021-01-01',	 '2'),
		('B', '2021-01-02',	 '2'),
		('B', '2021-01-04',	 '1'),
		('B', '2021-01-11',	 '1'),
		('B', '2021-01-16',	 '3'),
		('B', '2021-02-01',	 '3'),
		('C', '2021-01-01',  '3'),
		('C', '2021-01-01',  '3'),
		('C', '2021-01-07',  '3');
            
        
        
-- Table For Menu    
    
CREATE TABLE menu (
product_id varchar(50),
product_name varchar (50),
price numeric
);

 INSERT INTO menu (product_id, product_name, price)
  VALUES
	('1',	'sushi',	'10'),
	('2',	'curry',	'15'),
	('3',	'ramen',	'12');
			
            
-- Table For Members

CREATE TABLE members (
customer_id varchar(50),
join_date datetime
);

INSERT INTO members(customer_id, join_date)
VALUES
	('A',	'2021-01-07'),
	('B',	'2021-01-09');
    
 -- TOTAL AMOUNT EACH CUSTOMER SPENT AT A RESTAURANT   
 
 SELECT 
	s.customer_id, 
	SUM(m.price) AS amount_spent
 FROM sales s
 JOIN menu m
 ON
	s.product_id = m.product_id
 GROUP BY s.customer_id;

-- HOW MANY DAYS EACH CUSTOMER VISITED THE RESTAURANT

SELECT 
	customer_id,
	COUNT(order_date) AS days_visited
FROM sales
GROUP BY customer_id;

-- FIRST ITEM PURCHASED BY EACH CUSTOMER ON THE MENU

WITH new_list AS 
				(SELECT s.customer_id, s.order_date, m.product_name,
				ROW_NUMBER() OVER(PARTITION BY customer_id) AS first_item
				FROM menu m
				JOIN sales s
				ON m.product_id = s.product_id)
SELECT * FROM new_list
WHERE first_item < 2;

-- MOST PURCHASED ITEM BY EACH CUSTOMER AND HOW MANY TIMES IS IT PURCHASED

WITH most_purchased AS 
(SELECT 
	s.customer_id, 
    m.product_name,
    COUNT(m.product_name) AS times_purchased
FROM sales s
JOIN menu m
ON
	s.product_id = m.product_id
GROUP BY s.customer_id, m.product_name)
SELECT * FROM most_purchased
ORDER BY times_purchased DESC
LIMIT 1;

-- ITEMS PURCHASED BY CUSTOMER AFTER BECOMING A MEMBER

SELECT y.customer_id, y.product_name AS previous_ordered
FROM 
(SELECT s.customer_id, m.join_date, s.order_date, me.product_name
FROM sales s
LEFT JOIN members m
ON s.customer_id = m.customer_id
JOIN menu me
ON me.product_id = s.product_id) AS y
WHERE y.join_date < y.order_date 
ORDER BY y.customer_id;

-- ITEM PURCHASED BEFORE THE CUSTOMER BECAME A MEMBER

SELECT y.customer_id, y.product_name AS previous_ordered
FROM 
(SELECT s.customer_id, m.join_date, s.order_date, me.product_name
FROM sales s
LEFT JOIN members m
ON s.customer_id = m.customer_id
JOIN menu me
ON me.product_id = s.product_id) AS y
WHERE y.join_date > y.order_date 
ORDER BY y.customer_id;

-- TOTAL ITEM AND AMOUNT SPENT BY EACH CUSTOMER BEFORE BECOMING A MEMEBER

SELECT 
	s.customer_id, 
	SUM(m.price) AS totaL_price,
    COUNT(order_date) AS item_count
FROM sales s
JOIN menu m
ON
	s.product_id = m.product_id
JOIN members me
ON s.customer_id = me.customer_id
WHERE me.join_date > s.order_date 
GROUP BY s.customer_id ;

-- TOTAL ITEM AND AMOUNT SPENT BY EACH CUSTOMER AFTER BECOMING A MEMEBER

SELECT 
	s.customer_id, 
	SUM(m.price) AS totaL_price,
    COUNT(order_date) AS item_count
FROM sales s
JOIN menu m
ON
	s.product_id = m.product_id
JOIN members me
ON s.customer_id = me.customer_id
WHERE me.join_date < s.order_date 
GROUP BY s.customer_id;

-- POINTS CUSTOMERS WILL HAVE IF EACH DOLLAR EQUATES TO 10 POINTS

SELECT DISTINCT(s.customer_id), m.product_name,
(CASE WHEN m.product_id = 1 THEN m.price * 20
	WHEN m.product_id = 2 THEN m.price * 10
    WHEN m.product_id = 3 THEN m.price * 10
    END) AS points
FROM sales s
JOIN menu m
ON s.product_id = m.product_id 
ORDER BY s.customer_id;

-- POINTS CUSTOMERS WILL HAVE IF EACH DOLLAR EQUATES TO 10 POINTS

SELECT DISTINCT(s.customer_id), m.product_name,
(CASE WHEN m.product_id = 1 AND s.order_date <= me.join_date THEN m.price * 20
	WHEN m.product_id = 2 AND s.order_date <= me.join_date THEN m.price * 20
    WHEN m.product_id = 3 AND s.order_date <= me.join_date THEN m.price * 20
    ELSE 'No point' END) AS points
FROM sales s
JOIN menu m
ON s.product_id = m.product_id 
JOIN members me
ON me.customer_id = s.customer_id
ORDER BY s.customer_id















