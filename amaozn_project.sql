create database amazon;
use amazon;

CREATE TABLE amazon_sales (
    product_id VARCHAR(20),
    product_name TEXT,
    category TEXT,
    discounted_price INT,
    new_dis_price INT,
    new_act_price INT,
    actual_price INT,
    discount_percentage INT,
    rating DECIMAL(3,1),
    rating_count INT,
    about_product TEXT,
    user_id TEXT,
    user_name TEXT,
    review_id TEXT,
    review_title TEXT,
    review_content TEXT,
    img_link TEXT,
    product_link TEXT
);

select * from amazon_sales;

#Display all records from the Amazon table
SELECT COUNT(*)
FROM amazon_sales;

#Display product names, categories, and actual prices
SELECT product_name,category,actual_price
FROM amazon_sales;

#Find products with a rating greater than 4
select product_name as product
from amazon_sales
where rating > 4;

#Display the top 10 products with the highest ratings
SELECT 
    product_id,
    product_name,
    rating,
    rating_count
FROM amazon_sales
ORDER BY rating DESC, rating_count DESC
LIMIT 10;


#Find products with a discount percentage greater than 50%
select   product_id,product_name,discount_percentage as discount
from amazon_sales
where discount_percentage  > 50;  


#Find products belonging to the Electronics category
SELECT product_id,
    product_name,
    category,
    actual_price,
    discounted_price,
    rating
FROM amazon_sales
WHERE category LIKE '%Electronics%';


#Find the total number of products
select count(product_id) as products
from amazon_sales;


#Calculate the average product rating
SELECT ROUND(AVG(rating),2) AS average_product_rating
FROM amazon_sales;


#Find the maximum and minimum actual prices
SELECT
    MAX(actual_price) AS maximum_actual_price, 
    MIN(actual_price) AS minimum_actual_price
FROM amazon_sales;


#Calculate the average discount percentage
SELECT round(avg(discounted_price),1) AS avg_discounted_prices
FROM amazon_sales;


#Count the number of products in each category
SELECT
    category,
    COUNT(*) AS total_products
FROM amazon_sales
GROUP BY category
ORDER BY total_products desc;


#Find the average rating for each category
select
      category,round(avg(rating),2) as avg_rating
 from amazon_sales
 group by category;
 
 
 #Find the category with the highest number of products
 SELECT
    category,
    COUNT(*) AS total_products
FROM amazon_sales
GROUP BY category
ORDER BY total_products DESC
LIMIT 1;


#Count how many products have a rating greater than 4
select count(*) as rating
from amazon_sales
where rating > 4;
 
 
 #Find the top 5 categories by average rating
 select
       category,
       round(avg(rating),2) as avg_rating
 from amazon_sales
 group by category
 order by avg_rating desc
 limit 5;
 
 
 #Find categories containing more than 50 products
 select
      category,
      count(*) as total_products
from amazon_sales
group by category
having count(*) > 50
order by total_products desc;  


#   Identify products whose actual price is above the overall average actual price
select product_name, actual_price
from amazon_sales
where actual_price > (
   select avg(actual_price)
   from amazon_sales
   );
   
   
#Classify products into rating groups:- 
#Excellent: rating greater than or equal to 4.5
# Good: rating from 4.0 to below 4.5
# Average: rating from 3.0 to below 4.0
#Low: rating below 3.0
 select
      product_name,rating,
      case
         when rating between 4.5 and 5.0 then "excellent"
         when rating between 4.0 and 4.4 then "good"
         when rating between 3.0 and 3.9 then "average"
          else "low"
	 end as rating_group 
	from amazon_sales;
    
    
#Find the 10 products with the highest discount percentages
  select
      product_name,discount_percentage
      from amazon_sales
      order by discount_percentage desc
      limit 10;
          
  
  #Identify products with a high discount but a rating below 3.5
  select
       product_name,
       discount_percentage as high_discount,
       rating
       from amazon_sales
  where
        discount_percentage > 71 and rating <3.5
        order by discount_percentage desc;


#Calculate the average actual price and discounted price for each category
select 
     category,
     round(avg(actual_price),2) as avg_price,
     round(avg(discounted_price),2) as avg_discounted_price
     from amazon_sales
     group by category;
     
          
 #Use CASE to classify products into price bands
 select
    product_id,
    product_name,
    actual_price,
    CASE
        WHEN actual_price < 500 THEN 'Low Price'
        WHEN actual_price BETWEEN 500 AND 2000 THEN 'Medium Price'
        WHEN actual_price BETWEEN 2001 AND 5000 THEN 'High Price'
        ELSE 'Premium Price'
    END AS price_band
FROM amazon_sales
ORDER BY actual_price DESC;


#Use a CTE to find categories with above-average ratings
WITH category_ratings AS (
    SELECT
        category,
        ROUND(AVG(rating), 2) AS avg_rating
    FROM amazon_sales
    GROUP BY category
)
SELECT
    category,
    avg_rating
FROM category_ratings
WHERE avg_rating > (
    SELECT AVG(rating)
    FROM amazon_sales
)
ORDER BY avg_rating DESC;


#Use DENSE_RANK() to rank products within each category by rating

select
      product_name,
      category,
      rating,
      dense_rank() over(
      partition by category
      order by rating desc) as rating_rank
from amazon_sales;
   

#Use ROW_NUMBER() to identify the top 3 products in each category
WITH ranked_products AS (
    SELECT
        product_name,
        category,
        rating,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY rating DESC
        ) AS row_num
    FROM amazon_sales
)
SELECT product_name, category, rating, row_num
FROM ranked_products
WHERE row_num <= 3; 


#Identify missing values in important columns  #finding miising values(sum)
select 
    sum(product_id is null or trim(product_id)='') as miss_product_id,
    sum(product_name is null or trim(product_name)='')as miss_product_name,
    SUM(category IS NULL OR TRIM(category) = '') AS missing_categories,
    SUM(rating IS NULL) AS missing_ratings,
    SUM(actual_price IS NULL) AS missing_actual_prices,
    SUM(discounted_price IS NULL) AS missing_discounted_prices
  from amazon_sales;



#Check whether product IDs are duplicated
select product_id,count(*) as duplicate_count
from amazon_sales
group by product_id
having count(*) >1;


#Find products where the discounted price is greater than the actual price
SELECT product_name, actual_price, discounted_price
FROM amazon_sales
WHERE discounted_price > actual_price;


#Calculate the potential savings per product: actual price minus discounted price
select
product_name,
actual_price,
discounted_price,
round(actual_price - discounted_price ,2) as potantial_price
from amazon_sales
order by potantial_price;
 



