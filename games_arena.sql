-- Create tables

DROP TABLE IF EXISTS customers;
CREATE TABLE customers
             (
              cust_id VARCHAR(12) PRIMARY KEY,
			  first_name VARCHAR (12),
			  last_name VARCHAR (12)
			 );

DROP TABLE IF EXISTS food_drinks;
CREATE TABLE food_drinks 
             (
              item_id VARCHAR(5) PRIMARY KEY,
			  item_name	VARCHAR(20),
			  item_category	VARCHAR(15),
			  item_size	VARCHAR(10),
			  item_price FLOAT
			  );

DROP TABLE IF EXISTS game_items;
CREATE TABLE game_items
             (
             item_id VARCHAR(5) PRIMARY KEY,
			 item_name VARCHAR(14),
			 hourly_rent FLOAT   
			 );

DROP TABLE IF EXISTS orders;			 
CREATE TABLE orders
             (
             row_id	VARCHAR(10) PRIMARY KEY,
             order_id VARCHAR(8),
             date DATE,
             item_name VARCHAR(22),
             item_id VARCHAR(4),
             quantity INT,
             customer_id VARCHAR(10)
             );

DROP TABLE IF EXISTS rentals;
CREATE TABLE rentals
            (
            rental_id VARCHAR(6) PRIMARY KEY,
			date DATE,
			item_name VARCHAR(14),
			item_id	VARCHAR(5),
			customer_id	VARCHAR(10),
			start_time TIME,
			end_time TIME, 
			rental_duration FLOAT
			);

DROP TABLE IF EXISTS staff;
CREATE TABLE staff
            (
            staff_id VARCHAR(5) PRIMARY KEY,
			first_name VARCHAR(12),
			last_name VARCHAR(12),
			position VARCHAR(24),
			hourly_rate FLOAT
			);

DROP TABLE IF EXISTS shift;
CREATE TABLE shift
           (
           shift_id	VARCHAR(5) PRIMARY KEY,
		   day_of_week VARCHAR(10),
		   start_time TIME,
		   end_time TIME
		   ); 

DROP TABLE IF EXISTS work_rotation;
CREATE TABLE work_rotation
          (
          row_id VARCHAR(5) PRIMARY KEY,
		  rota_id VARCHAR(10),
		  date DATE,
		  shift_id VARCHAR(5),
		  staff_id VARCHAR(5)
		  ); 

		 
-- SQL Queries

-- 1. List all rentals that occurred on April 1, 2025.

   SELECT * FROM rentals 
   WHERE date = '2025-04-01'; 
   
-- 2. Count how many times a chess set was rented.

   SELECT COUNT(*) 
   FROM rentals
   WHERE item_name = 'Chess Set';   

-- 3. Show all staff assigned to shift `sh03` on April 1, 2025.

   SELECT 
      wr.shift_id,
      wr.staff_id,
      s.position,
      sh.start_time,
      sh.end_time
   FROM work_rotation wr
   JOIN staff s ON wr.staff_id = s.staff_id
   JOIN  shift sh ON wr.shift_id = sh.shift_id
   WHERE wr.shift_id = 'sh03'  AND wr.date = '2025-04-01'
   ORDER BY wr.staff_id;

-- 4. List food items ordered by customer `C0000456`. 

   SELECT 
       DISTINCT customer_id, item_name
   FROM orders 
   WHERE customer_id = 'C0000456' AND item_name IS NOT NULL;

-- 5. Find rentals with a duration of exactly 2.5 hours. 

   SELECT * FROM rentals
   WHERE rental_duration = 2.5;

-- 6. Count how many unique customers placed food orders.

   SELECT COUNT(DISTINCT customer_id) 
   FROM orders;
   
-- 7. List all rentals that started after 18:00 (6 PM).

   SELECT * FROM rentals
   WHERE start_time > '18:00';

-- 8. Show the total quantity of "Latte" drinks ordered. 

   SELECT SUM(quantity) 
   FROM orders 
   WHERE item_name = 'Latte';

-- 9. Calculate the average rental duration for "Monopoly Set". 

   SELECT 
       g.item_name,
       ROUND(AVG(r.rental_duration)::numeric, 2) AS average_rental_duration_hours
   FROM rentals r
   JOIN game_items g ON r.item_id = g.item_id
   WHERE g.item_name = 'Monopoly Set'
   GROUP BY g.item_name;

-- 10. Find customers who rented board games AND placed food orders on April 1, 2025. 

   SELECT DISTINCT
      c.cust_id,
      c.first_name,
      c.last_name,
      o.item_name AS food_item_name,
      r.item_name AS game_item_name
   FROM customers c
   JOIN rentals r ON c.cust_id = r.customer_id
   JOIN orders o ON c.cust_id = o.customer_id
   WHERE r.date = '2025-04-01' AND o.date = '2025-04-01'
   ORDER BY 
      c.last_name, c.first_name, o.item_name; 

-- 11. List the top 3 most rented board games by count.

   SELECT 
      g.item_name AS board_game,
      COUNT(r.rental_id) AS rental_count
   FROM rentals r
   JOIN game_items g ON r.item_id = g.item_id
   GROUP BY g.item_name
   ORDER BY rental_count DESC
   LIMIT 3;

-- 12. Calculate total revenue from food orders.

   SELECT 
       ROUND(SUM(fd.item_price * o.quantity)::NUMERIC, 2) AS total_food_revenue
   FROM orders o
   JOIN food_drinks fd ON o.item_id = fd.item_id;   

-- 13. Identify staff who worked both shifts (`sh03` and `sh04`) on April 1, 2025.

    SELECT 
       s.staff_id,
       s.first_name,
       s.last_name,
       s.position
    FROM staff s
    WHERE 
        s.staff_id IN (
        -- Staff who worked sh03
        SELECT wr1.staff_id
        FROM work_rotation wr1
        WHERE wr1.shift_id = 'sh03' 
        AND wr1.date = '2025-04-01'
        )
    AND s.staff_id IN (
        -- Staff who worked sh04
        SELECT wr2.staff_id
        FROM work_rotation wr2
        WHERE wr2.shift_id = 'sh04' 
        AND wr2.date = '2025-04-01'
      )
ORDER BY 
    s.last_name, s.first_name;

-- 14. Find the busiest hour for board game rentals on April 1, 2025 (most rentals starting).

    SELECT 
        EXTRACT(HOUR FROM start_time) AS hour_of_day,
        COUNT(*) AS rental_count
    FROM rentals
    WHERE date = '2025-04-01'
    GROUP BY 
       EXTRACT(HOUR FROM start_time)
    ORDER BY rental_count DESC
    LIMIT 1

-- 15. List customers who ordered both "Beef Burger" and "Coke".

    SELECT DISTINCT
        c.cust_id,
        c.first_name,
        c.last_name,
		fd1.item_name,
		fd2.item_name
    FROM customers c
    JOIN orders o1 ON c.cust_id = o1.customer_id
    JOIN food_drinks fd1 ON o1.item_id = fd1.item_id
    JOIN orders o2 ON c.cust_id = o2.customer_id
    JOIN food_drinks fd2 ON o2.item_id = fd2.item_id
    WHERE fd1.item_name = 'Beef Burger' AND fd2.item_name = 'Coke';

-- 16. Calculate the average number of food items per order. 

    SELECT 
        ROUND(AVG(item_count), 2) AS avg_items_per_order
    FROM (
    SELECT 
        order_id,
        SUM(quantity) AS item_count
    FROM orders
    GROUP BY order_id
    ) AS order_totals;    

-- 17. Find rentals where the board game was rented for more than 3 hours.

    SELECT 
        r.rental_id,
        r.date,
        r.item_name AS game_name,
        r.start_time,
        r.end_time,
        r.rental_duration AS duration_hours,
        c.first_name || ' ' || c.last_name AS customer_name
    FROM rentals r
    JOIN customers c ON r.customer_id = c.cust_id
    WHERE r.rental_duration > 3
    ORDER BY 
    r.rental_duration DESC;
  
-- 18. Count how many staff worked each shift on April 1, 2025.

    SELECT 
       wr.shift_id,
       sh.day_of_week,
       sh.start_time,
       sh.end_time,
       COUNT(wr.staff_id) AS staff_count,
       STRING_AGG(s.first_name || ' ' || s.last_name, ', ' ORDER BY s.last_name) AS staff_names
    FROM work_rotation wr
    JOIN shift sh ON wr.shift_id = sh.shift_id
    JOIN staff s ON wr.staff_id = s.staff_id
    WHERE wr.date = '2025-04-01'
    GROUP BY 
          wr.shift_id, sh.day_of_week, sh.start_time, sh.end_time
    ORDER BY 
          sh.start_time;
  
-- 19. Identify customers who rented the same board game multiple times on the same day.

    SELECT 
         c.cust_id,
         c.first_name || ' ' || c.last_name AS customer_name,
         r.item_name AS game_name,
         r.date,
         COUNT(*) AS rental_count
    FROM rentals r
    JOIN customers c ON r.customer_id = c.cust_id
    GROUP BY 
         c.cust_id, c.first_name, c.last_name, r.item_name, r.date
    HAVING 
        COUNT(*) > 1
    ORDER BY r.date, rental_count DESC;

-- 20. Calculate the percentage of rentals that lasted longer than the average rental duration.

    WITH 
	avg_duration AS (
      SELECT AVG(rental_duration) AS value FROM rentals
      ),
   counts AS (
      SELECT
        COUNT(*) AS total_count,
        SUM(CASE WHEN rental_duration > (SELECT value FROM avg_duration) THEN 1 ELSE 0 END) AS above_avg_count
      FROM rentals
     )
   SELECT
    (SELECT value FROM avg_duration) AS average_duration,
       total_count,
       above_avg_count,
       ROUND((above_avg_count::numeric / total_count) * 100, 2) AS percentage_above_avg
   FROM counts;

-- 21. Rank customers by total spending on food.

   SELECT
     c.cust_id,
     c.first_name || ' ' || c.last_name AS customer_name,
     ROUND(SUM(fd.item_price * o.quantity)::numeric, 2) AS total_spent,
     RANK() OVER (ORDER BY SUM(fd.item_price * o.quantity) DESC) AS spending_rank
   FROM customers c
   JOIN orders o ON c.cust_id = o.customer_id
   JOIN food_drinks fd ON o.item_id = fd.item_id
   GROUP BY
     c.cust_id, c.first_name, c.last_name
   ORDER BY total_spent DESC; 

-- 22. Detect anomalies: Find rentals with end times that don’t match start_time + rental_duration.

   SELECT 
     r.rental_id,
     r.date,
     r.item_name,
     r.start_time,
     r.end_time AS recorded_end_time,
     r.rental_duration,
     (r.start_time + (r.rental_duration * INTERVAL '1 hour')) AS calculated_end_time,
    CASE 
        WHEN r.end_time <> (r.start_time + (r.rental_duration * INTERVAL '1 hour')) 
        THEN 'MISMATCH' 
        ELSE 'OK' 
    END AS status
  FROM rentals r
  WHERE 
    -- Find records where end_time doesn't match the calculated value
    r.end_time <> (r.start_time + (r.rental_duration * INTERVAL '1 hour'))
  ORDER BY r.date, r.start_time;

-- 23. Calculate the 3-hour moving average of board game rentals on April 1, 2025. 

  WITH hourly_counts AS (
    SELECT 
        DATE_TRUNC('hour', start_time) AS hour_start,
        COUNT(*) AS rentals_count
    FROM rentals
    WHERE date = '2025-04-01'
    GROUP BY DATE_TRUNC('hour', start_time)
    )
  SELECT 
      TO_CHAR(hour_start, 'HH24:MI') AS hour,
      rentals_count,
      ROUND(AVG(rentals_count) OVER (
        ORDER BY hour_start
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 1) AS three_hour_moving_avg
  FROM hourly_counts
  ORDER BY 
    hour_start; 

-- 24. Find staff members who handled the most rentals. 

   WITH shift_rentals AS (
    SELECT 
        wr.staff_id,
        r.rental_id
    FROM 
        work_rotation wr
    JOIN 
        shift sh ON wr.shift_id = sh.shift_id
    JOIN 
        rentals r ON wr.date = r.date
        AND (
            (r.start_time::time >= sh.start_time AND r.start_time::time < sh.end_time)
            OR (r.end_time::time > sh.start_time AND r.end_time::time <= sh.end_time)
        )
   )
   SELECT 
    s.staff_id,
    s.first_name || ' ' || s.last_name AS staff_name,
    s.position,
    COUNT(sr.rental_id) AS rentals_handled
  FROM staff s
  JOIN shift_rentals sr ON s.staff_id = sr.staff_id
  GROUP BY 
    s.staff_id, s.first_name, s.last_name, s.position
  ORDER BY rentals_handled DESC
  LIMIT 5;

-- 25. Predict demand: Calculate the 7-day moving average of rentals per board game.  

  WITH daily_rentals AS (
    SELECT
        r.item_id,
        gi.item_name,
        r.date,
        COUNT(*) AS daily_count
    FROM
        rentals r
    JOIN
        game_items gi ON r.item_id = gi.item_id
    GROUP BY
        r.item_id, gi.item_name, r.date
    )
  SELECT
    item_id,
    item_name,
    date,
    daily_count,
    ROUND(AVG(daily_count) OVER (
        PARTITION BY item_id
        ORDER BY date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) AS seven_day_moving_avg
  FROM daily_rentals
  ORDER BY item_name, date;
  
-- 26. Optimize staffing: Identify shifts with the highest food order volumes.

  SELECT
    sh.day_of_week,
    TO_CHAR(sh.start_time, 'HH24:MI') || ' - ' || TO_CHAR(sh.end_time, 'HH24:MI') AS shift_time,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(o.quantity) AS total_items_ordered
  FROM orders o
  JOIN work_rotation wr ON o.date = wr.date
  JOIN shift sh ON wr.shift_id = sh.shift_id
  WHERE o.date BETWEEN '2025-04-01' AND '2025-04-07'
  GROUP BY
    sh.day_of_week, sh.start_time, sh.end_time
  ORDER BY total_items_ordered DESC
  LIMIT 5;
      
-- 27. Find customers who rented board games for longer than the average duration and spent more than 50 on food, and rank them based on rental hours

  WITH 
  -- Calculate average rental duration
  avg_rental AS (
    SELECT AVG(rental_duration) AS avg_duration FROM rentals
  ),

  -- Calculate food spending per customer
  customer_food_spending AS (
    SELECT 
        o.customer_id,
        SUM(fd.item_price * o.quantity) AS total_food_spending
    FROM 
        orders o
    JOIN 
        food_drinks fd ON o.item_id = fd.item_id
    GROUP BY 
        o.customer_id
    HAVING 
        SUM(fd.item_price * o.quantity) > 50
   ),

  -- Calculate rental hours per customer
 customer_rental_hours AS (
    SELECT 
        r.customer_id,
        c.first_name,
        c.last_name,
        SUM(r.rental_duration) AS total_rental_hours
    FROM 
        rentals r
    JOIN 
        customers c ON r.customer_id = c.cust_id
    GROUP BY 
        r.customer_id, c.first_name, c.last_name
    HAVING 
        SUM(r.rental_duration) > (SELECT avg_duration FROM avg_rental)
  )

  -- Final result with ranking
  SELECT 
    cr.customer_id,
    cr.first_name,
    cr.last_name,
    cr.total_rental_hours,
    cfs.total_food_spending,
    RANK() OVER (ORDER BY cr.total_rental_hours DESC) AS rental_rank
  FROM customer_rental_hours cr
  JOIN customer_food_spending cfs ON cr.customer_id = cfs.customer_id
  ORDER BY rental_rank;

-- 28. What is the daily revenue generated from food/beverage sales and board game rentals?

  WITH daily_food_revenue AS (
    -- Calculate daily food/beverage revenue
    SELECT
        o.date,
        ROUND(SUM(fd.item_price * o.quantity)::numeric, 2) AS food_revenue
    FROM
        orders o
    JOIN
        food_drinks fd ON o.item_id = fd.item_id
    GROUP BY
        o.date
    ),

  daily_rental_revenue AS (
    -- Calculate daily rental revenue
    SELECT
        r.date,
        ROUND(SUM(gi.hourly_rent * r.rental_duration)::numeric, 2) AS rental_revenue
    FROM
        rentals r
    JOIN
        game_items gi ON r.item_id = gi.item_id
    GROUP BY
        r.date
   )

   -- Combine both revenue streams
   SELECT
    COALESCE(f.date, r.date) AS date,
    COALESCE(f.food_revenue, 0) AS food_revenue,
    COALESCE(r.rental_revenue, 0) AS rental_revenue,
    COALESCE(f.food_revenue, 0) + COALESCE(r.rental_revenue, 0) AS total_daily_revenue
   FROM daily_food_revenue f
   FULL OUTER JOIN daily_rental_revenue r ON f.date = r.date
   ORDER BY date; 
	
-- 29. What is the total revenue generated from food/beverage sales and board game rentals?

 WITH 
  -- Calculate total food and beverage revenue
 food_revenue AS (
    SELECT ROUND(SUM(fd.item_price * o.quantity)::numeric, 2) AS total
    FROM orders o
    JOIN food_drinks fd ON o.item_id = fd.item_id
  ),

  -- Calculate total board game rental revenue
  rental_revenue AS (
    SELECT ROUND(SUM(gi.hourly_rent * r.rental_duration)::numeric, 2) AS total
    FROM rentals r
    JOIN game_items gi ON r.item_id = gi.item_id
  )

  -- Combine both revenue streams
  SELECT 
    f.total AS food_beverage_revenue,
    r.total AS rental_revenue,
    (f.total + r.total) AS combined_total_revenue
  FROM food_revenue f
  CROSS JOIN rental_revenue r;

-- 30. What is the total cost (food/beverage sales + board game rentals) for customer 'C0000456':  

  WITH 
  -- Calculate food/beverage costs for the customer
  customer_food_cost AS (
    SELECT 
        ROUND(SUM(fd.item_price * o.quantity)::numeric, 2) AS food_total
    FROM 
        orders o
    JOIN 
        food_drinks fd ON o.item_id = fd.item_id
    WHERE 
        o.customer_id = 'C0000456'
  ),

  -- Calculate rental costs for the customer
  customer_rental_cost AS (
    SELECT 
        ROUND(SUM(gi.hourly_rent * r.rental_duration)::numeric, 2) AS rental_total
    FROM 
        rentals r
    JOIN 
        game_items gi ON r.item_id = gi.item_id
    WHERE 
        r.customer_id = 'C0000456'
  )

  -- Combine both costs
  SELECT 
    c.cust_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    COALESCE(f.food_total, 0) AS food_beverage_cost,
    COALESCE(r.rental_total, 0) AS rental_cost,
    COALESCE(f.food_total, 0) + COALESCE(r.rental_total, 0) AS total_cost
  FROM customers c
  LEFT JOIN customer_food_cost f ON 1=1
  LEFT JOIN customer_rental_cost r ON 1=1
  WHERE c.cust_id = 'C0000456'