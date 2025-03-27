# **Retail Sales Analysis**

## **📌 Project Overview**

This project focuses on analyzing retail sales data using SQL. The dataset contains transaction details, customer demographics, and product sales information. SQL queries are used for data analysis, transformation, and insights generation.

## **📂 Files in the Repository**

* **SQL \- Retail Sales Analysis\_utf.csv** → The dataset containing retail transactions.

* **sql\_retail\_sales\_p1.sql** → SQL queries for creating the database, table, and performing analysis.

* **README.md** → This documentation file.

## **📊 Dataset Description**

The dataset includes the following columns:

| Column Name | Data Type | Description |
| ----- | ----- | ----- |
| `transactions_id` | INT (Primary Key) | Unique transaction identifier |
| `sale_date` | DATE | Date of transaction |
| `sale_time` | TIME | Time of transaction |
| `customer_id` | INT | Customer identifier |
| `gender` | VARCHAR(10) | Gender of customer |
| `age` | INT | Customer's age |
| `category` | VARCHAR(50) | Product category (e.g., Clothing, Beauty) |
| `quantity` | INT | Number of units sold |
| `price_per_unit` | DECIMAL(10,2) | Price per unit of product |
| `cogs` | DECIMAL(10,2) | Cost of goods sold |
| `total_sale` | DECIMAL(10,2) | Total sales amount |

## **🏗️ SQL Queries Included**

### **1️⃣ Database & Table Creation**

CREATE DATABASE IF NOT EXISTS sqlproject1;  
USE sqlproject1;

CREATE TABLE IF NOT EXISTS retail (  
    transactions\_id INT PRIMARY KEY,  
    sale\_date DATE,  
    sale\_time TIME,  
    customer\_id INT,  
    gender VARCHAR(10),  
    age INT,  
    category VARCHAR(50),  
    quantity INT,  
    price\_per\_unit DECIMAL(10,2),  
    cogs DECIMAL(10,2),  
    total\_sale DECIMAL(10,2)  
);

### **2️⃣ Data Analysis Queries**

#### **🛍️ Extracting Monthly Sales Trends**

SELECT   
  EXTRACT(YEAR FROM sale\_date) AS year,  
  EXTRACT(MONTH FROM sale\_date) AS month,  
  SUM(total\_sale) AS total\_revenue  
FROM sqlproject1.retail  
GROUP BY year, month  
ORDER BY year, month;

#### **📊 Best-Selling Product Categories**

SELECT   
  category,  
  SUM(total\_sale) AS total\_sales  
FROM sqlproject1.retail  
GROUP BY category  
ORDER BY total\_sales DESC;

#### **⏰ Identifying Peak Sales Hours**

SELECT   
  CASE   
    WHEN EXTRACT(HOUR FROM sale\_time) \< 12 THEN 'Morning'  
    WHEN EXTRACT(HOUR FROM sale\_time) BETWEEN 12 AND 16 THEN 'Afternoon'  
    ELSE 'Evening'   
  END AS sales\_shift,  
  SUM(quantity) AS total\_quantity\_sold  
FROM sqlproject1.retail  
GROUP BY sales\_shift  
ORDER BY total\_quantity\_sold DESC;

#### **🎯 Customer Segmentation Based on Demographics**

SELECT   
  gender,  
  AVG(age) AS avg\_age,  
  SUM(total\_sale) AS total\_sales  
FROM sqlproject1.retail  
GROUP BY gender  
ORDER BY total\_sales DESC;

#### **🏆 Highest Monthly Average Sales**

WITH ranked\_sales AS (  
  SELECT   
    EXTRACT(YEAR FROM sale\_date) AS year,  
    EXTRACT(MONTH FROM sale\_date) AS month,  
    ROUND(AVG(total\_sale), 2\) AS average\_sale,  
    DENSE\_RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale\_date) ORDER BY AVG(total\_sale) DESC) AS rank  
  FROM sqlproject1.retail  
  GROUP BY year, month  
)  
SELECT \*  
FROM ranked\_sales  
WHERE rank \= 1;

#### **📌 Transactions with Clothing Sales Over 3 Units in Nov-2022**

SELECT   
 transactions\_id,  
 category,  
 quantity,  
 sale\_date  
FROM sqlproject1.retail  
WHERE category \= 'Clothing'  
AND quantity \> 3  
AND sale\_date BETWEEN '2022-11-01' AND '2022-11-30';

#### **🏷️ Total Sales by Category**

SELECT   
  category,  
  SUM(total\_sale) AS net\_sale  
FROM sqlproject1.retail  
GROUP BY category;

#### **📉 Average Total Sales by Month & Year**

SELECT   
  year,  
  month,  
  ROUND(AVG(total\_sale), 2\) AS average\_sale  
FROM sqlproject1.retail  
GROUP BY year, month;

#### **🌅 Sales Distribution by Time of Day**

WITH shift AS (  
  SELECT   
    CASE   
      WHEN EXTRACT(HOUR FROM sale\_time) \<= 12 THEN 'Morning'  
      WHEN EXTRACT(HOUR FROM sale\_time) BETWEEN 12 AND 17 THEN 'Afternoon'  
      ELSE 'Evening'  
    END AS shift,  
    quantity  
  FROM sqlproject1.retail  
)  
SELECT   
  shift,  
  SUM(quantity) AS num\_orders  
FROM shift  
GROUP BY shift;

## **🔍 Findings**

* **Most sales occur in the Afternoon shift**, with evenings showing moderate activity.

* **Certain categories (e.g., Clothing, Electronics) drive the majority of revenue**.

* **Customer demographics influence purchasing behavior**, with variations in spending across age groups and genders.

* **Highest monthly sales vary each year, with some months outperforming others consistently**.

* **Transactions involving clothing with high quantity purchases are limited but impactful in revenue generation**.

## **🎯 Conclusion**

By analyzing the retail sales data, businesses can optimize inventory, target promotions based on peak sales hours, and develop personalized marketing strategies. SQL is a powerful tool for gaining actionable insights from structured datasets.

---

