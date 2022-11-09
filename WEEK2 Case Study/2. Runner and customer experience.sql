-- HOW MANY RUNNERS SIGNED UP FOR EACH WEEK

SELECT 
DAYOFWEEK(registration_date) AS reg_week,
COUNT(runner_id) AS no_of_runners
FROM runners
GROUP BY DAYOFWEEK(registration_date)
ORDER BY reg_week;

-- THE AVERAGE TIME IN MINUTES IT TOOK FOR THE RUNNER TO ARRIVE AT THE HEADQUATERS TO PICK UP ORDER

SELECT runner_id, AVG(duration) AS avg_distance
FROM runner_orders
GROUP BY runner_id;

-- AVG DISTANCE TRAVELLED BY EACH CUSTOMER

SELECT customer_id, ROUND(AVG(distance),1) AS avg_distance
FROM customer_orders c
JOIN runner_orders r
ON c.order_id = r.order_id
GROUP BY customer_id;

-- DIFFERENCE BETWEEN LONGEST AND SHORTEST DILIVERY TIME

WITH duration AS(
SELECT MAX(duration) AS max_duration,
		MIN(duration) AS min_duration
FROM runner_orders
WHERE duration IS NOT NULL)
SELECT max_duration - min_duration 
FROM duration;

SELECT CASE WHEN duration IS NULL THEN 0
		ELSE duration END
FROM runner_orders;
-- SELECT max_duration - min_duration 

SELECT duration FROM runner_orders





-- AVG SPEED FOR EACH RUNNER FOR EACH DELIVERY

SELECT DISTINCT runner_id,order_id,
		ROUND(AVG(distance/duration),1) AS avg_speed
FROM runner_orders
GROUP BY runner_id, order_id;


-- SUCCESSFUL PERCENTAGE FOR EACH DELIVERY

WITH cte_per AS
(SELECT runner_id,
		SUM(CASE WHEN distance IS NOT NULL THEN 1
		ELSE 0 END) AS pass
       --  COUNT(order_id) AS total
FROM runner_orders
WHERE distance IS NOT NULL
GROUP BY runner_id)

SELECT pass * 















