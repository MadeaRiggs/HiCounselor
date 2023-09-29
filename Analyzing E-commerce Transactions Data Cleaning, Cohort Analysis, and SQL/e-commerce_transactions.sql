-- Module 3
-- Task 1: Data Download, Import, and Database Connection.

-- # -- Load the sql extention ----
-- %load_ext sql

-- # --- Load your mysql db using credentials from the "DB" area ---
-- %sql mysql+pymysql://bef7d6ac:Cab#22se@localhost/bef7d6ac

-- Task 2: What are the unique brands available in the dataset?
-- We are enquiring about the unique brands available in the dataset to gain insights into the variety of products and manufacturers present in our sales records. This information can help us understand the market presence and popularity of different brands among our customers.
%%sql
SELECT DISTINCT brand
FROM cleaned_dataset


-- Task 3: How many unique customers made transactions in the dataset?
-- We are investigating the number of unique customers who have made transactions in the dataset to assess the extent of our customer base. Understanding the total count of customers can aid in customer segmentation and targeted marketing efforts to enhance our business's customer relations and profitability.
%%sql
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM cleaned_dataset


-- Task 4: How many transactions were approved and how many were not approved?
-- We are examining the number of transactions that were approved and those that were not approved to assess the overall success rate of transactions in our dataset. This information helps us evaluate our operational efficiency and customer satisfaction, as well as identify any potential issues that may require attention to improve the approval process.
%%sql
SELECT 
    SUM(CASE WHEN order_status = 'Approved' THEN 1 ELSE 0 END) AS total_approved,
    SUM(CASE WHEN order_status <> 'Approved' THEN 1 ELSE 0 END) AS total_unapproved
FROM cleaned_dataset;


-- Task 5: List the top product lines with the highest average list price.
-- We are inquiring about the top product lines with the highest average list price to identify the product categories that generate the highest revenue for our business. This knowledge can guide pricing strategies and marketing efforts, as well as help us understand customer preferences for premium products.
%%sql
SELECT product_line, AVG(list_price) AS average_list_price
FROM cleaned_dataset
GROUP BY product_line
ORDER BY average_list_price DESC


-- Task 6: List the product_id, list_price, and standard_cost of the products where the list_price is greater than twice the standard_cost.
-- We are querying for the product_id, list_price, and standard_cost of products where the list price is greater than twice the standard cost. This analysis helps us identify products with a significant profit margin, which is crucial for pricing decisions and profitability assessment.
%%sql
SELECT product_id, list_price, standard_cost
FROM cleaned_dataset
WHERE list_price >= (2 * standard_cost)


-- Task 7: Calculate the average list_price for each product_line.
-- We are calculating the average list price for each product line to understand the pricing trends within different product categories. This information can be valuable for setting competitive prices, evaluating product line performance, and making informed decisions related to product development and marketing strategies.
%%sql
SELECT product_line, AVG(list_price) AS average_list_price
FROM cleaned_dataset
GROUP BY product_line


-- Task 8: Which brand has the maximum difference between the list_price and standard_cost for their products?
-- We are investigating which brand has the maximum difference between the list price and standard cost for their products. This analysis can help us identify brands with the potential for higher profit margins and evaluate pricing strategies across different manufacturers to optimize profitability.
%%sql
SELECT brand, MAX(list_price-standard_cost) AS price_margin
FROM cleaned_dataset
GROUP BY brand
ORDER BY price_margin DESC
LIMIT 1


-- Task 9: List the customer_id and the count of their transactions, ordered by the number of transactions in descending order.
-- We are listing the customer_id along with the count of their transactions, sorted in descending order by the number of transactions. This information can provide insights into customer behavior and loyalty, helping us identify our most valuable customers and tailor marketing strategies accordingly.
%%sql
SELECT customer_id, COUNT(transaction_id) AS transaction_count
FROM cleaned_dataset
GROUP BY customer_id
ORDER BY transaction_count DESC


-- Task 10: Find the total sales amount for each brand, sorted in descending order of total sales.
-- We are calculating the total sales amount for each brand, with the results sorted in descending order of total sales. This analysis allows us to identify the top-performing brands in terms of revenue generation, which is valuable information for marketing and inventory management.
%%sql
SELECT brand, SUM(list_price) AS total_sales
FROM cleaned_dataset
GROUP BY brand
ORDER BY total_sales DESC


-- Task 11: What are the top 5 products with the highest profit margin.
-- We are identifying the top 5 products with the highest profit margin, where the profit margin is calculated as the difference between list_price and standard_cost. This analysis helps us pinpoint the most profitable products in our inventory, guiding pricing and marketing strategies to maximize profitability.
%%sql
SELECT DISTINCT product_id, brand, product_line, (list_price-standard_cost) AS profit_margin
FROM cleaned_dataset
ORDER BY profit_margin DESC
LIMIT 5


-- Task 12: For each customer, find the total number of transactions, the total amount they spent, and their average profit per transaction
-- We are calculating three metrics for each customer:
-- Total number of transactions. Total amount spent (sum of list_price). Average profit per transaction (average profit per transaction = average list_price - average standard_cost). This analysis provides a comprehensive overview of each customer's transaction history, expenditure, and the average profitability of their purchases, helping us identify high-value customers and tailor marketing strategies accordingly.
%%sql
SELECT customer_id, 
    COUNT(DISTINCT transaction_id) AS total_transactions, 
    SUM(list_price) AS total_amount_spent,
    (AVG(list_price) - AVG(standard_cost)) AS average_profit_per_transaction

FROM cleaned_dataset
GROUP BY customer_id


-- Task 13: Find the top 5 product lines with the highest total revenue and their percentage contribution to the overall revenue.
-- We are identifying the top 5 product lines with the highest total revenue (sum of list_price) and calculating their percentage contribution to the overall revenue. This analysis helps us understand which product lines are driving the most significant portion of our sales and revenue, enabling us to focus resources and strategies accordingly.
%%sql
SELECT product_line, 
    SUM(list_price) AS total_revenue,
    (SUM(list_price) * 100) / (SELECT 
                                   SUM(list_price) 
                               FROM cleaned_dataset) AS revenue_contribution_percent
    
FROM cleaned_dataset
GROUP BY product_line
ORDER BY total_revenue DESC
LIMIT 5


-- Task 14: Identify the customers who have made at least one transaction for each product line available
-- We are identifying the customers who have made at least one transaction for each distinct product line available. This analysis helps us pinpoint the customers who have engaged with our entire product range, which can provide insights into their buying behavior and preferences across various product categories.
%%sql
SELECT customer_id
FROM cleaned_dataset
GROUP BY customer_id
HAVING COUNT(DISTINCT product_line) = (SELECT COUNT(DISTINCT product_line) FROM cleaned_dataset);
