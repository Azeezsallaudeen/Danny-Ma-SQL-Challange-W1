CREATE DATABASE pizzarunner_sql;

USE pizzarunner_sql;

CREATE TABLE runners(
runner_id int,
registration_date date);

INSERT INTO runners(runner_id, registration_date)
VALUES('1',	'2021-01-01'),
		('2',	'2021-01-03'),
		('3',	'2021-01-08'),
		('4',	'2021-01-15');
        
-- CUSTOMER NORDER TABLE

CREATE TABLE customer_orders(
order_id int,
customer_id int,
pizza_id int,
exclusions varchar(4),
extras varchar(4),
order_time datetime
);

INSERT INTO customer_orders(order_id, customer_id, pizza_id, exclusions, extras, order_time)
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');
        

-- RUNNER ORDER TABLE

CREATE TABLE runner_orders(
order_id int,
runner_id int,
pickup_time varchar(30),
distance varchar(15),
duration varchar(15),
cancellation varchar(15));

INSERT INTO runner_orders(order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES	('1',	'1',	'2021-01-01 18:15:34',	'20km',	'32 minutes', ''),	 
		('2',	'1',	'2021-01-01 19:10:54',	'20km',	'27 minutes', ''),	 
		('3',	'1',	'2021-01-03 00:12:37',	'13.4km',	'20 mins',	'NaN'),
		('4',	'2',	'2021-01-04 13:53:03',	'23.4',	'40',	'NaN'),
		('5',	'3',	'2021-01-08 21:10:57',	'10',	'15',	'NaN'),
		('6',	'3',	'null',	'null',	'null',	'Restaurant'),
		('7',	'2',	'2020-01-08 21:30:45',	'25km',	'25mins',	'null'),
		('8', '2',	'2020-01-10 00:15:02',	'23.4 km',	'15 minute',	'null'),
		('9',	'2',	'null',	'null',	'null',	'Customer'),
		('10',	'1',	'2020-01-11 18:50:20',	'10km',	'10minutes', 'null');
        
        
-- PIZZA NAMES TABLE

CREATE TABLE pizza_names(
pizza_id int,
pizza_name varchar(15));


INSERT INTO pizza_names(pizza_id, pizza_name)
VALUES
('1',	'Meat Lovers'),
('2',	'Vegetarian');


-- PIZZA RECIPE TABLE

CREATE TABLE pizza_recipes(
pizza_id int,
toppings varchar(25));

INSERT INTO pizza_recipes(pizza_id, toppings)
VALUES	('1',	'1, 2, 3, 4, 5, 6, 8, 10'),
		('2',	'4, 6, 7, 9, 11, 12');


-- PIZZA TOPPINGS TABLE

CREATE TABLE pizza_toppings(
topping_id int,
topping_name varchar(20));

INSERT INTO pizza_toppings(topping_id, topping_name)
VALUES
('1',	'Bacon'),
('2',	'BBQ Sauce'),
('3',	'Beef'),
('4',	'Cheese'),
('5',	'Chicken'),
('6',	'Mushrooms'),
('7',	'Onions'),
('8',	'Pepperoni'),
('9',	'Peppers'),
('10',	'Salami'),
('11',	'Tomatoes'),
('12',	'Tomato Sauce');


-- SOLUTIONS

-- AMOUNT OF PIZZA ORDERED

SELECT 
	COUNT(order_time) AS pizza_ordered
FROM customer_orders;

-- COUNT OF UNIQUE CUSTOMER ORDER

SELECT 
	COUNT(DISTINCT(order_id))
FROM customer_orders;

-- AMOUNT OF SUCCESSFUL ORDERS BY EACH RUNNERS

SELECT 
	runner_id, 
    COUNT(pickup_time) AS order_dilivered
FROM runner_orders
WHERE pickup_time IS NOT NULL
GROUP BY runner_id;

-- AMOUNT OF PIZZA TYPE DELIVERED



-- AMOUNT OF PIZZA TYPE ORDERD

SELECT pn.pizza_name, 
        COUNT(c.order_time) AS amount_ordered
FROM customer_orders c
JOIN pizza_names pn
ON c.pizza_id = pn.pizza_id
LEFT JOIN runner_orders rn
ON rn.order_id = c.order_id
GROUP BY pn.pizza_name;

-- MAXIMUM NUMBER OF PIZZA DELIVERED IN A SINGLE ORDER

WITH order_table AS
(SELECT c.order_id, COUNT(c.order_id) AS total_order
FROM  customer_orders c
JOIN runner_orders r
ON c.order_id = r.order_id
GROUP BY c.order_id)
SELECT MAX(total_order) AS max_delivered_a_day
FROM order_table
WHERE distance <> NULL;


-- HOW MANY DELIVERED PIZZA HAD AT LEAST ONE CHANGE AND HOW MANY HAS NONE

SELECT customer_id,
		SUM(CASE WHEN exclusions <> 'NULL' OR extras <> 'NULL' THEN 1
			ELSE 0
        END) AS at_least_1_change,
        
		SUM(CASE WHEN exclusions = 'NULL' AND extras = 'NULL' THEN 1
			ELSE 0
			END) AS NoChange
FROM customer_orders c
JOIN runner_orders r
ON c.order_id = r.order_id
WHERE distance != 0
GROUP BY customer_id;


-- NUMBER OF PIZZA DELIVERED THAT HAD BOTH EXCLUSION AND EXTRAS

SELECT customer_id, COUNT(pizza_id) AS total
FROM customer_orders c
INNER JOIN runner_orders r 
ON c.order_id = r.order_id
WHERE extras IS NOT NULL
	AND exclusions IS NOT NULL
GROUP BY customer_id;

-- TOTAL NUMBER OF PIZZA ORDERED FOR EACH HOUR OF THE DAY


SELECT
EXTRACT(HOUR FROM order_time) AS hours_ordered,
COUNT(pizza_id) AS total_pizza
FROM customer_orders c
JOIN runner_orders r
ON c.order_id = r.order_id
GROUP BY EXTRACT(hour FROM order_time);

-- MOST ORDERED PIZZA FOR EACH DAY OF THE WEEK

SELECT -- p.pizza_name,
DATEPART(WEEK, c.order_time) AS weekly_order
FROM customer_orders c
JOIN pizza_names p
ON c.pizza_id = p.pizza_id;
-- ORDER BY p.pizza_name


SELECT WEEKDAY(order_time)
FROM customer_orders





































-- SELECT * FROM runner_orders





  









































































        
        