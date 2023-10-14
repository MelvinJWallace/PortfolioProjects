-- This dataset is the US Regional Sales data that was retrieved from the Kaggle website.
select * from US_Regional_Sales_Data

-----------------------------------------------------------------------------------------

-- CLEANING UP DATA --

-----------------------------------------------------------------------------------------

--1) Creating new columns for all dates
alter table US_Regional_Sales_Data
add Procured_Date date;

alter table US_Regional_Sales_Data
add Order_Date date;

alter table US_Regional_Sales_Data
add Ship_Date date;

alter table US_Regional_Sales_Data
add Delivery_Date date;

--2) Converting all new date columns from datetime datatypes to year datatypes
update US_Regional_Sales_Data
set Procured_Date = convert(date, ProcuredDate);

update US_Regional_Sales_Data
set Order_Date = convert(date, OrderDate);

update US_Regional_Sales_Data
set Ship_Date = convert(date, ShipDate);

update US_Regional_Sales_Data
set Delivery_Date = convert(date, DeliveryDate);

--3) Removing original columns with the datetime format from data
alter table US_Regional_Sales_Data
drop column ProcuredDate, OrderDate, ShipDate, DeliveryDate;

-----------------------------------------------------------------------------------------

-- EDA --

-----------------------------------------------------------------------------------------

-- Num of total orders 
select distinct count(OrderNumber) "Total orders"
from US_Regional_Sales_Data;

-- Num of total sales teams
select count(distinct _SalesTeamID) "Number of sales teams"
from US_Regional_Sales_Data
order by 1 desc;

-- Num of total customers
select count(distinct _CustomerID) "Number of customers"
from US_Regional_Sales_Data
order by 1 desc;

-- Number of stores
select count(distinct _StoreID) "Number of stores"
from US_Regional_Sales_Data;

-- Number of products
select count(distinct _ProductID) "Number of products"
from US_Regional_Sales_Data;

-- Max Orders per Customer
select max([Order Quantity]) "Max orders per customer"
from US_Regional_Sales_Data;

-- Min Orders per Customer
select min([Order Quantity]) "Min orders per customer"
from US_Regional_Sales_Data;

-- Avg Orders per Customer
select avg([Order Quantity]) "Avg orders per customer"
from US_Regional_Sales_Data;

-- Max Discount Applied
select max([Discount Applied]) "Max discount"
from US_Regional_Sales_Data;

-- Min Discount Applied
select min([Discount Applied]) "Min discount"
from US_Regional_Sales_Data;

-- Avg Discount Applied
select avg([Discount Applied]) "Avg discount"
from US_Regional_Sales_Data;

-- Max Unit Cost
select max([Unit Cost]) "Max unit cost"
from US_Regional_Sales_Data;

-- Min Unit Cost
select min([Unit Cost]) "Min unit cost"
from US_Regional_Sales_Data;

-- Avg Unit Cost
select avg([Unit Cost]) "Avg unit cost"
from US_Regional_Sales_Data;

-- Max Procured Date 
select max(Procured_Date) "Most recent acquired date" 
from US_Regional_Sales_Data

-- Min Procured Date 
select min(Procured_Date) "Oldest acquired date"
from US_Regional_Sales_Data;

-- Max Order Date
select max(Order_Date) "Most recent order date"
from US_Regional_Sales_Data;

-- Min Order Date
select min(Order_Date) "Oldest order date"
from US_Regional_Sales_Data;

-- Max Ship Date
select max(Ship_Date) "Most recent ship date"
from US_Regional_Sales_Data;

-- Min Ship Date
select min(Ship_Date) "Oldest ship date"
from US_Regional_Sales_Data;

-- Max Delivery Date
select max(Delivery_Date) "Most recent delivery date"
from US_Regional_Sales_Data;

-- Min Delivery Date
select min(Delivery_Date) "Oldest delivery date"
from US_Regional_Sales_Data;

-- Count of all Products Acquired by Day
select datename(dw, Procured_Date) "Day", count(Procured_Date) "Count of acquired days"
from US_Regional_Sales_Data
group by datename(dw, Procured_Date)
order by [Count of acquired days] desc;

-- Count of all Products Acquired by Month
select datename(month, Procured_Date) "Month", count(Procured_Date) "Count of acquired months"
from US_Regional_Sales_Data
group by datename(month, Procured_Date)
order by [Count of acquired months] desc;

-- Count of all Products Acquired by Year
select year(Procured_Date) "Year", count(Procured_Date) "Count of acquired year"
from US_Regional_Sales_Data
group by year(Procured_Date) 
order by "Count of acquired year" desc;

-- Count of all Products Acquired by Day and Month
select datename(dw, Procured_Date) "Day", datename(month, Procured_Date) "Month", count(Procured_Date) "Count of acquired days"
from US_Regional_Sales_Data
group by datename(dw, Procured_Date), datename(month, Procured_Date)
order by [Count of acquired days] desc;

-- Count of all Products Acquired by Day and Year
select datename(dw, Procured_Date) "Day", year(Procured_Date) "Year", count(Procured_Date) "Count of acquired days" 
from US_Regional_Sales_Data
group by datename(dw, Procured_Date), year(Procured_Date)
order by [Count of acquired days] desc;

-- Count of all Products Acquired by Month and Year
select datename(month, Procured_Date) "Month", year(Procured_Date) "Year", count(Procured_Date) "Count of acquired days"
from US_Regional_Sales_Data
group by datename(month, Procured_Date), year(Procured_Date)
order by [Count of acquired days] desc;

-- Count of all Products Acquired by Day, Month and Year
select datename(dw, Procured_Date) "Day", datename(month, Procured_Date) "Month", year(Procured_Date) "Year", count(Procured_Date) "Count of acquired days"
from US_Regional_Sales_Data
group by datename(dw, Procured_Date), datename(month, Procured_Date), year(Procured_Date)
order by "Count of acquired days" desc;

-- Number of Days between Products Acquired and Products Ordered by (Order)
select *, datediff(day, Order_Date, Procured_Date) * (-1) "Day difference"
from US_Regional_Sales_Data
order by [Day difference] desc;

-- Avg number of Days from when all Products are Acquired and the Order Date
select avg(d."Day difference") * (-1) "Average days"
from (select *, datediff(day, Order_Date, Procured_Date) "Day difference"
      from US_Regional_Sales_Data) d;

-- Number of Months between Products Acquired and Products Ordered by (Order)
select *, datediff(month, Order_Date, Procured_Date) * (-1) "Month difference"
from US_Regional_Sales_Data
order by [Month difference] desc;

-- Avgeage number of Months from when all Product are Acquired and the Order Date
select avg(d."Month difference") "Average months"
from (select datediff(month, Order_Date, Procured_Date) * (-1) "Month difference"
      from US_Regional_Sales_Data) d;

-- Number of Days between Order Date and Shipping Date by (Order)
select *, datediff(day, Ship_Date, Order_Date) * (-1) "Day difference"
from US_Regional_Sales_Data
order by [Day difference] desc;

-- Average number of Days between all Order Dates and Shipping Dates
select avg(a."Day difference") "Average days"
from (select datediff(day, Ship_Date, Order_Date) * (-1) "Day difference"
      from US_Regional_Sales_Data) a;

-- Number of Days between Shipping Date and Delivery Date by (Orderr)
select *, datediff(day, Delivery_Date, Ship_Date) * (-1) "Day difference"
from US_Regional_Sales_Data
order by [Day difference] desc;

-----------------------------------------------------------------------------------------

-- VISUALIZATIONS --

-----------------------------------------------------------------------------------------

-- Average number of days between all Shipping Dates and Delivery Dates
select avg(a."Day difference") "Average Days"
from (select *, datediff(day, Delivery_Date, Ship_Date) * (-1) "Day difference"
      from US_Regional_Sales_Data) a;

-- Average days between Order Dates and Shipping Dates by Sales Channel (Sales Stores)
select distinct [Sales Channel], avg(datediff(day, Ship_Date, Order_Date) * (-1)) over(partition by [Sales Channel] order by [Sales Channel]) "Avg days between"
from US_Regional_Sales_Data;

-- Average days between Shipping Dates and Delivery Dates by Sales Channel (Sales Stores)
select distinct [Sales Channel], avg(datediff(day, Delivery_Date, Ship_Date) * (-1)) over(partition by [Sales Channel] order by [Sales Channel]) "Avg days between"
from US_Regional_Sales_Data;

--  Top 10 Sales Team ID (Sales Members) and Sales Channels (Sales Stores) that sold the most Number of Units 
select top 10 m.*
from (select distinct _SalesTeamID, [Sales Channel], count([Order Quantity]) "Most orders sold"
      from US_Regional_Sales_Data
      group by _SalesTeamID, [Sales Channel]) m
order by m.[Most orders sold] desc;

-- Top 10 Count of ProductID (Products) that were purchased by CustomerID (Customers) 
select top 10 c.*
from (select distinct _CustomerID, count(_ProductID) "Count of product"
      from US_Regional_Sales_Data
      group by _CustomerID) c
order by c.[Count of product] desc;

-- Top 10 Spending _CustomerID (Customers) on Products
with top_spending_cx as (select _CustomerID, sum([Unit Price]) * count([Order Quantity]) "Total spent on products per customer"
                         from US_Regional_Sales_Data
                         group by _CustomerID)
select top 10 top_spending_cx.*
from top_spending_cx
order by top_spending_cx.[Total spent on products per customer] desc;

-- Avg/Min/Max Unit Prices (Selling Price) per Sales Channel (Sales Store)
select [Sales Channel], avg([Unit Price]) "Avg price", min([Unit Price]) "Min price", max([Unit Price]) "Max price"
from US_Regional_Sales_Data
group by [Sales Channel]
order by "Avg price" desc;

 -- Avg/Min/Max Unit Cost (Cost) per Sales Channel (Sales Store)
 select [Sales Channel], avg([Unit Cost]) "Avg cost", min([Unit Cost]) "Min cost", max([Unit Cost]) "Max cost"
 from US_Regional_Sales_Data
 group by [Sales Channel];
 
-- Avg/Min/Max Markup (Profit Margin) per Sales Channel (Sales Store)
select [Sales Channel], avg([Unit Price] - [Unit Cost]) "Avg markup", min([Unit Price] - [Unit Cost]) "Min markup", max([Unit Price] - [Unit Cost]) "Max markup"
from US_Regional_Sales_Data
group by [Sales Channel];

-- Avg Percent Markup on Cost per Sales Channel (Sales Store)
with per_cent as (select [Sales Channel], avg([Unit Price] - [Unit Cost]) / avg([Unit Cost]) * 100 "Percent markup on cost"
                 from US_Regional_Sales_Data
                 group by [Sales Channel]) 
select per_cent.[Sales Channel], concat("Percent markup on cost", '%') "Percent"
from per_cent;

-- Avg Percent Markup on Selling Price per Sales Channel (Sales Store)
select m.[Sales Channel], concat(m."Percent markup on selling price", '%') "Percent"
from (select [Sales Channel], avg([Unit Price] - [Unit Cost]) / avg([Unit Price]) * 100 "Percent markup on selling price"
      from US_Regional_Sales_Data
      group by [Sales Channel]) m;

  


















 

