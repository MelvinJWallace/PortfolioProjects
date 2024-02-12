/* This dataset was retrieved from the Kaggle website and it consist of different fruit and vegetable products
from four different retailers based in Atlanta, Chicago, Los Angeles, and New York. The data also has the date,
the farm price for the product, and the average spread for the product. 

In this SQL project, I will demonstrate how to transform and manipulate the date column to extract the year and 
month to create new columns to be used for calculations. I will also find the total and average sales for the 
different retailers by month and year.

The goal of this project is to answer the questions below to provide insights into the dataset. */

-- How many different products are accounted for?
-- How many years does the dataset cover?
-- What product had the biggest avg spread?
-- What is the highest avg spread for each product?
-- What product had the biggest avg spread by year?
-- What product had the biggest avg spread by month?
-- What retail had the highest total sales?
-- What retail had the highest total sales by year?
-- What retail had the highest total sales by month?
-- What were the average retail sales?
-- What were the average retail sales by year?
-- What were the average retail sales by month?

-- select * from ProductPriceIndex --

/* So the first thing I will do in this project before I begin to answer questions will be to create a new column named 
'avgspread' and convert the 'averagespread' column to decimal datatype. To do that, I will have to remove the special 
characters from the 'averagespread' column.*/

--Creating the new column name
--alter table ProductPriceIndex
--add avgspread decimal;

--Removing special characters from the original column
--update ProductPriceIndex
--set averagespread = replace(averagespread, '%', '');

--Removing any other non numerical characters from the original column
--update ProductPriceIndex
--set averagespread = replace(averagespread, '[^0-9.]', '');

--update ProductPriceIndex
--set averagespread = replace(averagespread, ',', '');

--Adding the cleaned original columns data to the new column, converted to the proper datatype
--update ProductPriceIndex
--set avgspread = try_convert(decimal(18,0), averagespread);

/* Perfect! So now that column has been properly created, we can move on to the questions...*/

-- How many distinct products are there?
select count(distinct productname) "number of products"
from ProductPriceIndex;

select distinct productname as distinct_products
from ProductPriceIndex;

-- How many years does the dataset cover?
select count(distinct year(date)) "number of years"
from ProductPriceIndex;

select distinct year(date) "distinct years"
from ProductPriceIndex
order by year(date) asc;

-- What product had the highest avg spread?
select top 1 productname,
       concat(avgspread, '%') "avg spread percentage"
from ProductPriceIndex
order by avgspread desc;

-- What is the highest avg spread for each product?
select productname,
       concat(max(avgspread), '%') "highest avg spread percentage"
from ProductPriceIndex
group by productname
order by "highest avg spread percentage" desc;

-- What product had the highest avg spread by year?
select h.productname,
       concat(h."highest avg spread percentage by year", '%') "highest avg spread percentage by year",
	   h."year"
from (select productname,
             max(avgspread) "highest avg spread percentage by year", 
	         year(date) "year"
      from ProductPriceIndex
      group by productname, year(date)) h
order by h.[highest avg spread percentage by year] desc;

-- What product had the highest avg spread by month?
select h.productname,
       concat(h."highest avg spread percentage by month", '%') "highest avg spread percentage by month",
	   h."month"
from (select productname,
             max(avgspread) "highest avg spread percentage by month", 
	         datename(month, date) "month"
      from ProductPriceIndex
      group by productname, datename(month, date)) h
order by h.[highest avg spread percentage by month] desc;

-- What retail had the highest total sales?
select concat('$', sum(atlantaretail)) "atlanta total sales",
       concat('$', sum( chicagoretail)) "chicago total sales",
	   concat('$', sum( losangelesretail)) "la total sales",
	   concat('$', sum(newyorkretail)) "ny total sales"
from ProductPriceIndex;

-- What retail had the highest total sales by year?
select concat('$', sum(atlantaretail)) "atlanta total sales",
       concat('$', sum( chicagoretail)) "chicago total sales",
	   concat('$', sum( losangelesretail)) "la total sales",
	   concat('$', sum(newyorkretail)) "ny total sales",
	   year(date) "highest total sales by year"
from ProductPriceIndex
group by year(date)
order by "highest total sales by year" desc;

-- What retail had the highest total sales by month?
select concat('$', sum(atlantaretail)) "atlanta total sales",
       concat('$', sum( chicagoretail)) "chicago total sales",
	   concat('$', sum( losangelesretail)) "la total sales",
	   concat('$', sum(newyorkretail)) "ny total sales",
	   datename(month, date) "highest total sales by month"
from ProductPriceIndex
group by datename(month, date)
order by "highest total sales by month" desc;

-- What were the average retail sales?
select concat('$', avg(atlantaretail)) "atlanta average sales",
       concat('$', avg( chicagoretail)) "chicago average sales",
	   concat('$', avg( losangelesretail)) "la average sales",
	   concat('$', avg(newyorkretail)) "ny average sales"
from ProductPriceIndex;

-- What were the average retail sales by year?
select concat('$', avg(atlantaretail)) "atlanta average sales",
       concat('$', avg( chicagoretail)) "chicago average sales",
	   concat('$', avg( losangelesretail)) "la average sales",
	   concat('$', avg(newyorkretail)) "ny average sales",
	   year(date) "highest average sales by year"
from ProductPriceIndex
group by year(date)
order by "highest average sales by year" desc;

-- What were the average retail sales by month?
select concat('$', avg(atlantaretail)) "atlanta average sales",
       concat('$', avg( chicagoretail)) "chicago average sales",
	   concat('$', avg( losangelesretail)) "la average sales",
	   concat('$', avg(newyorkretail)) "ny average sales",
	   datename(month, date) "highest average sales by month"
from ProductPriceIndex
group by datename(month, date)
order by "highest average sales by month" desc;

/* Excellent! We have now answered all of the above questions by transforming, manipulating, and procssing the data.
The queries created above could be used to create visuals with tools such as Power BI for example. 
