SELECT * FROM datanalysis.coffee_shop_sales;

DESCRIBE coffee_shop_sales


UPDATE coffee_shop_sales
SET transaction_date = str_to_date(transaction_date, '%m/%d/%Y');

ALTER TABLE coffee_shop_sales
MODIFY COLUMN transaction_date DATE;

UPDATE coffee_shop_sales
SET transaction_time = STR_TO_DATE(transaction_time, '%H:%i:%s');

ALTER TABLE coffee_shop_sales
MODIFY COLUMN transaction_time TIME;

SELECT ROUND(SUM(unit_price * transaction_qty)) as Total_Sales 
FROM coffee_shop_sales 
-- WHERE MONTH(transaction_date) = 5 -- for specific month

SELECT CONCAT((ROUND(SUM(unit_price * transaction_qty)))/1000, "K") as Total_Sales 
FROM coffee_shop_sales 
-- WHERE MONTH(transaction_date) = 5

SELECT 
    MONTH(transaction_date) AS month, -- number of months
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales, -- total sales column
    (SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1) -- month sales difference
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(unit_price * transaction_qty), 1) -- Division 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage -- percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for months of April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
    
    -- Total sum
    SELECT 
    CONCAT(ROUND(SUM(unit_price * transaction_qty) / 1000, 1),'K') AS total_sales,
    CONCAT(ROUND(COUNT(transaction_id) / 1000, 1),'K') AS total_orders,
    CONCAT(ROUND(SUM(transaction_qty) / 1000, 1),'K') AS total_quantity_sold
FROM 
    coffee_shop_sales
WHERE 
    transaction_date = '2023-05-18'; -- For 18 May 2023
    
-- Average sales
SELECT (ROUND(AVG(total_sales), 1)) AS average_sales
FROM (
    SELECT 
        SUM(unit_price * transaction_qty) AS total_sales
    FROM 
        coffee_shop_sales
	WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        transaction_date
) AS internal_query;

-- total sales by store locations
SELECT 
	store_location,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) =5 
GROUP BY store_location
ORDER BY 	SUM(unit_price * transaction_qty) DESC

SELECT 
	product_category,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5 
GROUP BY product_category
ORDER BY SUM(unit_price * transaction_qty) DESC

-- SALES BY PRODUCTS (TOP 10)
SELECT 
	product_type,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5 
GROUP BY product_type
ORDER BY SUM(unit_price * transaction_qty) DESC
LIMIT 10


















