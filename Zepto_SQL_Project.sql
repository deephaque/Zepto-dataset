drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
Category VARCHAR(120),
Name VARCHAR(150) NOT NULL,
Mrp NUMERIC(8,2),
DiscountPercent NUMERIC(5,2),
AvailableQuantity INTEGER,
DiscountedSellingPrice NUMERIC(10,2),
WeightInGrams INTEGER,
OutOfStock BOOLEAN,
Quantity INTEGER
);

--- data exploration

-- count the rows
SELECT COUNT(*) FROM Zepto;

-- sample data
SELECT * FROM Zepto LIMIT 10 ;

-- NUll Values
SELECT * FROM Zepto 
WHERE name IS NULL OR
category IS NULL OR
mrp IS NULL OR
discountpercent IS NULL OR
availablequantity IS NULL OR
discountedsellingprice IS NULL OR
weightingrams IS NULL OR
outofstock IS NULL OR
quantity IS NULL ;

-- different product categories

SELECT DISTINCT category FROM Zepto ORDER BY category;

-- product in stock and out of stock

SELECT outofstock ,count(sku_id) FROM zepto GROUP BY outofstock;

-- product names present multiple times

SELECT name,COUNT(sku_id) as "no.of sku" FROM zepto
GROUP BY name 
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

--data cleaning
-- products whose prize = 0

SELECT * FROM zepto
WHERE mrp = 0 OR discountedsellingprice = 0;

DELETE FROM zepto WHERE mrp = 0 ;

SELECT * FROM zepto LIMIT 5;

-- now you can see here mrp is in paise not in ruppee so we need to change it in rupee..
UPDATE zepto SET mrp = mrp/100 , discountedsellingprice = discountedsellingprice/100;
SELECT * FROM zepto LIMIT 5;
UPDATE zepto SET mrp = mrp*100; 
SELECT * FROM zepto;


-- Business Insights Problems

-- Q1.Find the top 10 best-value product based on the discount percentage.
SELECT DISTINCT name,mrp,discountpercent FROM zepto
ORDER BY discountpercent DESC LIMIT 10;

-- Q2.What are the Products with High MRP but out of stock.
SELECT DISTINCT name,mrp,outofstock FROM zepto
WHERE outofstock = TRUE and mrp > 300
ORDER BY mrp DESC ;

-- Q3.Calculate Estimated Revenue for each category.
SELECT DISTINCT category,SUM(discountedsellingprice * availablequantity) AS Estimated_Revenue FROM zepto
GROUP BY category 
ORDER BY Estimated_Revenue;

-- Q4.Find all products where MRP is greater than 500 and discount is less than 10%.
SELECT DISTINCT name,mrp,discountpercent FROM zepto
WHERE mrp > 500 AND discountpercent < 10
ORDER BY mrp DESC,discountpercent DESC;

-- Q5.Identify the top 5 categories offering the highest average discount percentage.
SELECT category,ROUND(AVG(discountpercent),2) AS Avg_Discount_percent FROM zepto
GROUP BY category
ORDER BY Avg_Discount_percent DESC LIMIT 5 ;

-- Q6.Find the price per gram for the products above 100g and sort by the values.
SELECT DISTINCT name,weightingrams,discountedsellingprice ,ROUND(discountedsellingprice/weightingrams,3) AS price_per_gram
FROM zepto
WHERE weightingrams > 100 
ORDER BY price_per_gram DESC;

-- Q7.Group the products into WEIGHT Categories like low,medium,bulk.
SELECT DISTINCT name,weightingrams,
CASE WHEN weightingrams < 1000 THEN 'low'
     WHEN weightingrams < 5000 THEN 'medium'
	 ELSE 'bulk' END AS weight_category 
FROM zepto ;

-- Q8.What is the Total Inventory weight per Category.
SELECT category,SUM(weightingrams * availablequantity) AS total_wt_in_kg
FROM zepto
GROUP BY category 
ORDER BY total_wt_in_kg DESC;


