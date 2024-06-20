/* This dataset was retrieved from the Kaggle website. This dataset provides a comprehensive overview of online sales transactions across different product categories. Each row represents a single transaction
   with detailed information such as the order ID, date, category, product name, quantity sold, unit price, total price, region, and payment method. In this SQL project I will find trends and
   analyze patterns to unlock actionable insights. I will utilize SQL to clean the dataset by checking for and removing duplicate rows of data and null values. Then I will transform the data by extracting the
   month and day from the date column to get a more in depth analysis. I will then process the data by calculating sums, averages, maximums, and minimum values from the unit sold and unit price columns. Lastly,
   I will answer the business questions about the dataset passed along by the stakeholder.

   Questions:
		1) Can you analyze sales trends over time to identify seasonal patterns or growth opportunities?
		2) Can you explore the popularity of different product categories across regions?
		3) Can you investigate the immpact of payment methods on sales volume or revenue?
		4) Can you identify top-selling products within each category to optimize inventory and marketing strategies?
		5) Can you evaluate the performance of specific products or categories in different regions to tailor marketing campaigns accordingly?
*/

-- Checking for null values  --

-- Number of nulls in the Transaction_ID column
select count(*) "Num of Nulls"
from [Online Sales Data]
where Transaction_ID is null;
/* 
Num of Nulls
------------
0
*/
--Number of nulls in the Date column
select count(*) "Num of Nulls"
from [Online Sales Data]
where Date is null;
/*
Num of Nulls
------------
0
*/
-- Number of nulls in the Product_Category column
select count(*) "Num of Nulls"
from [Online Sales Data]
where Product_Category is null;
/*
Num of Nulls
------------
0
*/
-- Number of nulls in the Product_Name column
select count(*) "Num of Nulls"
from [Online Sales Data]
where Product_Name is null;
/*
Num of Nulls
------------
0
*/
-- Number of nulls in the Units_Sold column
select count(*) "Num of Nulls"
from [Online Sales Data]
where Units_Sold is null;
/*
Num of Nulls
------------
0
*/
-- Number of nulls in the Unit_Price column
select count(*) "Num of Nulls"
from [Online Sales Data]
where Unit_Price is null;
/*
Num of Nulls
------------
0
*/
-- Number of nulls in the Total_Revenue column
select count(*) "Num of Nulls"
from [Online Sales Data]
where Total_Revenue is null;
/*
Num of Nulls
------------
0
*/
-- Number of nulls in the Region column
select count(*) "Num of Nulls"
from [Online Sales Data]
where Region is null;
/*Num of Nulls
------------
0
*/
-- Number of nulls in the Payment_Method column
select count(*) "Num of Nulls"
from [Online Sales Data]
where Payment_Method is null;
/*
Num of Nulls
------------
0
*/
-- This dataset contains no null values, I will now move on to checking this dataset for duplicate rows of data.

-- Checking for duplicate rows of data --
select *
from (select *, row_number() over(partition by Transaction_ID order by Date asc) "Duplicate rows of data"
      from [Online Sales Data]) d
where d.[Duplicate rows of data] = 2;
/*
Transaction_ID  Date   Product_Category   Product_Name   Units_Sold  Unit_Price   Total_Revenue  Region   Payment_Method   Duplicate rows of data
--------------  ----   ----------------   ------------   ----------  ----------   -------------  ------   --------------   ----------------------

The query returned empty, indicating that there are 0 rows of duplicated data within this dataset.
*/

-- Now I will move on to answering the business questions for the stakeholder 

-- 1) Can you analyze sales trends over time to identify seasonal patterns or growth opportunities?
-- Sales by Month --
select s."Sales Month",
	   round(s.[Total Sales by Month], 2) "Total Sales by Month",
	case
		when s."Sales Month" = 1 then 'January'
		when s."Sales Month" = 2 then 'Feburary'
		when s."Sales Month" = 3 then 'March'
		when s."Sales Month" = 4 then 'April'
		when s."Sales Month" = 5 then 'May'
		when s."Sales Month" = 6 then 'June'
		when s."Sales Month" = 7 then 'July'
		when s."Sales Month" = 8 then 'August'
	end as "Month Name"
from (select month(Date) "Sales Month",
             sum(Total_Revenue) "Total Sales by Month" 
      from [Online Sales Data]
      group by month(Date)) s
order by s.[Total Sales by Month] desc;
/*
Sales Month Total Sales by Month   Month Name
----------- ---------------------- ----------
1           14548.32               January
3           12849.24               March
4           12451.69               April
2           10803.37               Feburary
5           8455.49                May
6           7384.55                June
8           7278.11                August
7           6797.08                July

The data indicates that most revenue is generated during the first 4 months of the year, with January bringing in the most revenue. The next 4 months of the year generate the least amount of profit with the 
month of July generating the least amount of revenue. Possible growth opportunities for the least selling months could be running sales and discounts during those months to potentially generate more profit.
*/
-- Sales by Day of the Week --
select datename(dw, Date) "Sales Day",
       round(sum(Total_Revenue), 2) "Total Sales by Day"
from [Online Sales Data]
group by datename(dw, Date)
order by [Total Sales by Day] desc;
/*
Sales Day                      Total Sales by Day
------------------------------ ----------------------
Tuesday                        13518.34
Friday                         12918.74
Monday                         12253.35
Saturday                       11494.02
Sunday                         11153.3
Wednesday                      10402.14
Thursday                       8827.96

From the data it is clear that Tuesdays, Fridays, and Mondays generate the most revenue, while Wednesdays and Thursdays generate less. Perhaps running specials on products during those days will increase profits.
*/

-- 2) Can you explore the popularity of different product categories across regions?
select round(sum(Total_Revenue), 2) "Total Sales",
       Product_Category,
	   Region
from [Online Sales Data]
group by Product_Category,
         Region
order by [Total Sales] desc;
/*
Total Sales            Product_Category           Region
---------------------- -------------------------- -------------
34982.41               Electronics                North America
18646.16               Home Appliances            Europe
14326.52               Sports                     Asia
8128.93                Clothing                   Asia
2621.9                 Beauty Products            Europe
1861.93                Books                      North America

Electronics are the most popular category in the North America region with a $34,982.41 in total sales. Home Appliances are the second most popular category in the Europe region with $18,646.16 in total sales. While 
Sports ae the third most popular category in the Asia region with $14,326.52 in total sales.
*/

-- 3) Can you investigate the impact of payment methods on sales volume or revenue?
select count(Units_Sold) "Num of Units Sold",
       round(sum(Total_Revenue), 2) "Total Revenue",
	   Payment_Method
from [Online Sales Data]
group by Payment_Method
order by [Total Revenue] desc,
         [Num of Units Sold] desc;
/*
Num of Units Sold Total Revenue          Payment_Method
----------------- ---------------------- --------------
120               51170.86               Credit Card
80                21268.06               PayPal
40                8128.93                Debit Card

The payment method that generated the most revenue was Credit Cards with a total revenue of $51,170.86. PayPal generated the second highest revenue with $21,268.06. While Debit Cards generated the least amount of revenue 
with $8,128.93. More products are bought using Credit Cards than any other payment method.
*/

-- 4) Can you identify top-selling products within each category to optimize inventory and marketing strategies?
-- Top 10 Selling Products by Category --
select *
from (select *, row_number() over(partition by t.Product_Category order by t."Total Revenue" desc) "Top 10 Products by Category"
      from (select Product_Name,
                   Product_Category,
	               round(sum(Total_Revenue), 2) "Total Revenue"
            from [Online Sales Data]
            group by Product_Category,
                     Product_Name) t) tp
where tp.[Top 10 Products by Category] <= 10;
/*
Product_Name                                                                                         Product_Category                                   Total Revenue          Top 10 Products by Category
---------------------------------------------------------------------------------------------------- -------------------------------------------------- ---------------------- ---------------------------
Dyson Supersonic Hair Dryer                                                                          Beauty Products                                    399.99                 1
La Mer Crème de la Mer Moisturizer                                                                   Beauty Products                                    190                    2
Chanel No. 5 Perfume                                                                                 Beauty Products                                    129.99                 3
Tom Ford Black Orchid Perfume                                                                        Beauty Products                                    125                    4
Sunday Riley Good Genes                                                                              Beauty Products                                    105                    5
Estee Lauder Advanced Night Repair                                                                   Beauty Products                                    105                    6
Lancome La Vie Est Belle                                                                             Beauty Products                                    102                    7
Charlotte Tilbury Magic Cream                                                                        Beauty Products                                    100                    8
Neutrogena Skincare Set                                                                              Beauty Products                                    89.99                  9
Kiehl's Midnight Recovery Concentrate                                                                Beauty Products                                    82                     10
The Silent Patient by Alex Michaelides                                                               Books                                              134.95                 1
Becoming by Michelle Obama                                                                           Books                                              130                    2
Salt, Fat, Acid, Heat by Samin Nosrat                                                                Books                                              107.97                 3
The Catcher in the Rye by J.D. Salinger                                                              Books                                              88.93                  4
Educated by Tara Westover                                                                            Books                                              84                     5
1984 by George Orwell                                                                                Books                                              79.96                  6
Where the Crawdads Sing by Delia Owens                                                               Books                                              75.96                  7
Harry Potter and the Sorcerer's Stone                                                                Books                                              74.97                  8
Dune by Frank Herbert                                                                                Books                                              71.96                  9
Atomic Habits by James Clear                                                                         Books                                              67.96                  10
Nike Air Force 1                                                                                     Clothing                                           539.94                 1
North Face Down Jacket                                                                               Clothing                                           499.98                 2
Ray-Ban Aviator Sunglasses                                                                           Clothing                                           464.97                 3
Adidas Ultraboost Running Shoes                                                                      Clothing                                           359.98                 4
Adidas Ultraboost Shoes                                                                              Clothing                                           359.98                 5
Adidas Originals Superstar Sneakers                                                                  Clothing                                           319.96                 6
Lululemon Align Leggings                                                                             Clothing                                           294                    7
Patagonia Better Sweater                                                                             Clothing                                           279.98                 8
Nike Air Force 1 Sneakers                                                                            Clothing                                           270                    9
Adidas Originals Trefoil Hoodie                                                                      Clothing                                           259.96                 10
Canon EOS R5 Camera                                                                                  Electronics                                        3899.99                1
MacBook Pro 16-inch                                                                                  Electronics                                        2499.99                2
Apple MacBook Pro 16-inch                                                                            Electronics                                        2399                   3
iPhone 14 Pro                                                                                        Electronics                                        1999.98                4
HP Spectre x360 Laptop                                                                               Electronics                                        1599.99                5
Samsung Odyssey G9 Gaming Monitor                                                                    Electronics                                        1499.99                6
Samsung Galaxy Tab S8                                                                                Electronics                                        1499.98                7
Microsoft Surface Laptop 4                                                                           Electronics                                        1299.99                8
Apple MacBook Air                                                                                    Electronics                                        1199.99                9
Samsung QLED 4K TV                                                                                   Electronics                                        1199.99                10
LG OLED TV                                                                                           Home Appliances                                    2599.98                1
Roomba i7+                                                                                           Home Appliances                                    1599.98                2
Blueair Classic 480i                                                                                 Home Appliances                                    1199.98                3
De'Longhi Magnifica Espresso Machine                                                                 Home Appliances                                    899.99                 4
Dyson Supersonic Hair Dryer                                                                          Home Appliances                                    799.98                 5
Shark IQ Robot Vacuum                                                                                Home Appliances                                    699.98                 6
Eufy RoboVac 11S                                                                                     Home Appliances                                    659.97                 7
Breville Smart Grill                                                                                 Home Appliances                                    599.9                  8
Anova Precision Oven                                                                                 Home Appliances                                    599                    9
Keurig K-Elite Coffee Maker                                                                          Home Appliances                                    529.97                 10
Peloton Bike                                                                                         Sports                                             1895                   1
Garmin Fenix 6X Pro                                                                                  Sports                                             999.99                 2
Bowflex SelectTech 1090 Adjustable Dumbbells                                                         Sports                                             699.99                 3
Fitbit Versa 3                                                                                       Sports                                             689.85                 4
Garmin Forerunner 945                                                                                Sports                                             599.99                 5
Garmin Edge 530                                                                                      Sports                                             599.98                 6
Babolat Pure Drive Tennis Racket                                                                     Sports                                             599.97                 7
Polar Vantage V2                                                                                     Sports                                             499.95                 8
Manduka PRO Yoga Mat                                                                                 Sports                                             479.96                 9
GoPro HERO9 Black                                                                                    Sports                                             449.99                 10

The above results display the top 10 products by revenue. This could be a good indicator as to what products should be maintained in inventory.
*/

-- 5) Can you evaluate the performance of specific products or categories in different regions to tailor marketing campaigns accordingly?
select *
from (select *, row_number() over(partition by Region order by "Total Revenue" desc) "Top 10 Products"
      from (select Product_Name,
                   Region,
	               round(sum(Total_Revenue), 2) "Total Revenue"
            from [Online Sales Data]
            group by Product_Name,
                     Region) t) tp
where tp.[Top 10 Products] <= 10;
/*
Product_Name                                                                                         Region                                             Total Revenue          Top 10 Products
---------------------------------------------------------------------------------------------------- -------------------------------------------------- ---------------------- --------------------
Peloton Bike                                                                                         Asia                                               1895                   1
Garmin Fenix 6X Pro                                                                                  Asia                                               999.99                 2
Bowflex SelectTech 1090 Adjustable Dumbbells                                                         Asia                                               699.99                 3
Fitbit Versa 3                                                                                       Asia                                               689.85                 4
Garmin Forerunner 945                                                                                Asia                                               599.99                 5
Garmin Edge 530                                                                                      Asia                                               599.98                 6
Babolat Pure Drive Tennis Racket                                                                     Asia                                               599.97                 7
Nike Air Force 1                                                                                     Asia                                               539.94                 8
North Face Down Jacket                                                                               Asia                                               499.98                 9
Polar Vantage V2                                                                                     Asia                                               499.95                 10
LG OLED TV                                                                                           Europe                                             2599.98                1
Roomba i7+                                                                                           Europe                                             1599.98                2
Blueair Classic 480i                                                                                 Europe                                             1199.98                3
Dyson Supersonic Hair Dryer                                                                          Europe                                             1199.97                4
De'Longhi Magnifica Espresso Machine                                                                 Europe                                             899.99                 5
Shark IQ Robot Vacuum                                                                                Europe                                             699.98                 6
Eufy RoboVac 11S                                                                                     Europe                                             659.97                 7
Breville Smart Grill                                                                                 Europe                                             599.9                  8
Anova Precision Oven                                                                                 Europe                                             599                    9
Keurig K-Elite Coffee Maker                                                                          Europe                                             529.97                 10
Canon EOS R5 Camera                                                                                  North America                                      3899.99                1
MacBook Pro 16-inch                                                                                  North America                                      2499.99                2
Apple MacBook Pro 16-inch                                                                            North America                                      2399                   3
iPhone 14 Pro                                                                                        North America                                      1999.98                4
HP Spectre x360 Laptop                                                                               North America                                      1599.99                5
Samsung Odyssey G9 Gaming Monitor                                                                    North America                                      1499.99                6
Samsung Galaxy Tab S8                                                                                North America                                      1499.98                7
Microsoft Surface Laptop 4                                                                           North America                                      1299.99                8
Samsung QLED 4K TV                                                                                   North America                                      1199.99                9
Apple MacBook Air                                                                                    North America                                      1199.99                10

The above results are the top 10 selling products in each region, marketing campaigns should be directed towards these products as they are the most popular products.


In conclusion, I have demonstrated how to use SQL to manipulate, transform, and process data in order to answer business questions. I have created a database, loaded data into a database, cleaned that data, 
 transformed the data, and processed that data.
*/