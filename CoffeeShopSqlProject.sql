/* This is a dataset taken from the mavenanalytics.io website. The dataset consist of fictitious transaction records for a fictitious company named Maven Roasters, which operates out of three different New York City locations. 
   The dataset includes the transaction date, timestamp and location, along with product-level details. 

   In this project, I assume the role of lead data analyst who has been tasked with the job of analyzing this dataset to answer the business questions of the owner of Maven Roasters. The tool that I am choosing to perform my 
   analysis will be SQL for this assignment. I will demonstrate how to load the raw dataset into a database, how to clean the dataset if neccessary, how to manipulate and transform the dataset to create new columns, how to 
   process the data to perform calculations on the neccessary columns, and lastly, how to export the dataset into PowerBI for visuals.


Owners Business Questions:

1) How have Maven Roasters sales trended over time?
2) Which days of the week tend to be busiest, and why do you think that's the case?
3) Which products are sold most and least often?
4) Which products drive the msot revenue for the business?      */                                                                                                                                                              


/* Before I start to perform my analysis and answer business questions, I will first examine my data to get a better understanding of it. */

-----------------------------------
/* Checking for duplicate rows */
-----------------------------------
select *
from (select *, row_number() over(partition by transaction_id order by transaction_id asc) "duplicate rows"
      from [Coffee Shop Sales]) d
where d.[duplicate rows] > 1;
-- Results came back empty, indicating there are no duplicate rows of data within this dataset. --

----------------------------------------------------
/* Checking the distinct values in each column */
----------------------------------------------------
select count(distinct transaction_id) "distinct count of transaction id's"
from [Coffee Shop Sales];
-- 149116 distinct values

select count(distinct transaction_date) "distinct count of transaction dates"
from [Coffee Shop Sales];
-- 181 distinct values

select count(distinct transaction_time) "distinct count of transaction times"
from [Coffee Shop Sales];
-- 25762 distinct values

select count(distinct transaction_qty) "distinct count of transaction qyt"
from [Coffee Shop Sales];
-- 6 distinct values

select count(distinct store_id) "distinct count of store id"
from [Coffee Shop Sales];
-- 3 distinct values

select count(distinct store_location) "distinct count of store location"
from [Coffee Shop Sales];
-- 3 distinct values

select count(distinct product_id) "distinct count of product id"
from [Coffee Shop Sales];
-- 80 distinct values

select count(distinct unit_price) "distinct count of unit price"
from [Coffee Shop Sales];
-- 41 distinct values

select count(distinct product_category) "distinct count of product category"
from [Coffee Shop Sales];
-- 9 distinct values

select count(distinct product_type) "distinct count of product type"
from [Coffee Shop Sales];
-- 29 distinct values

select count(distinct product_detail) "distinct count of product detail"
from [Coffee Shop Sales];
-- 80 distinct values

----------------------------------
/* Checking for any null values */
----------------------------------
select *
from [Coffee Shop Sales]
where transaction_id is null;
-- Returns 0 rows, so we have no null values in our dataset. --

/* I have a better understanding of the dataset and now I will move on with my analysis and business questions. */

------------------------------------------------------
-- 1) How have Maven Roasters sales trended over time?
------------------------------------------------------
/* Sales trended by month */
select cast(t."total sales" as decimal(10,2)) "total sales",
	case 
		when t."transaction month" = 1 then 'January'
		when t."transaction month" = 2 then 'Feburary'
		when t."transaction month" = 3 then 'March'
		when t."transaction month" = 4 then 'April'
		when t."transaction month" = 5 then 'May'
		when t."transaction month" = 6 then 'June'
	end as "month"
from (select sum(unit_price) "total sales",
             month(transaction_date) "transaction month"
      from [Coffee Shop Sales]
      group by month(transaction_date)) t
order by [transaction month] asc;
/* total sales                             month
--------------------------------------- --------
59018.04                                January
55134.34                                Feburary                   \
71833.08                                March        ---------------- (results can be used for a visualization in PowerBi or excel!)    
85709.58                                April                      /
113076.91                               May
119571.08                               June */

/* Sales by hour */
select t."total sales",
	case 
		when t."transaction hour" = 6 then '6am'
		when t."transaction hour" = 7 then '7am'
		when t."transaction hour" = 8 then '8am'
		when t."transaction hour" = 9 then '9am'
		when t."transaction hour" = 10 then '10am'
		when t."transaction hour" = 11 then '11am'
		when t."transaction hour" = 12 then '12pm'
		when t."transaction hour" = 13 then '1pm'
		when t."transaction hour" = 14 then '2pm'
		when t."transaction hour" = 15 then '3pm'
		when t."transaction hour" = 16 then '4pm'
		when t."transaction hour" = 17 then '5pm'
		when t."transaction hour" = 18 then '6pm'
		when t."transaction hour" = 19 then '7pm'
		when t."transaction hour" = 20 then '8pm'
	end as "hour"
from (select cast(sum(unit_price) as decimal(10,2)) "total sales",
             datepart(hour, transaction_time) "transaction hour"
      from [Coffee Shop Sales]
      group by datepart(hour, transaction_time)) t
order by [transaction hour] asc;
/* total sales                             hour
--------------------------------------- ----
15304.42                                6am
46098.12                                7am
60801.87                                8am
61433.38                                9am
64857.99                                10am
32538.79                                11am
28467.09                                12pm                        \
29290.90                                1pm       -------------------- (results can be displayed as a visual in PowerBi or excel!)
29513.24                                2pm                         /
30020.45                                3pm
29994.40                                4pm
28410.26                                5pm
24539.90                                6pm
20913.18                                7pm
2159.04                                 8pm */

/* Sales trended by day */
select cast(sum(unit_price) as decimal(10,2)) "total sales",
       transaction_date
from [Coffee Shop Sales]
group by transaction_date
order by transaction_date asc;
/*    total sales                             transaction_date
--------------------------------------- ----------------
1731.80                                 2023-01-01
1743.95                                 2023-01-02
1826.60                                 2023-01-03
1533.40                                 2023-01-04
1715.35                                 2023-01-05
1580.15                                 2023-01-06
1921.60                                 2023-01-07
1938.23                                 2023-01-08
2077.81                                 2023-01-09
1977.05                                 2023-01-10
1935.65                                 2023-01-11
1722.65                                 2023-01-12
2106.50                                 2023-01-13
2140.36                                 2023-01-14
2427.66                                 2023-01-15
2176.16                                 2023-01-16
2060.60                                 2023-01-17
2056.46                                 2023-01-18
2210.58                                 2023-01-19
2091.93                                 2023-01-20
2258.90                                 2023-01-21
1563.48                                 2023-01-22
1985.70                                 2023-01-23
1986.40                                 2023-01-24
1904.40                                 2023-01-25
1981.33                                 2023-01-26
1856.15                                 2023-01-27
1437.80                                 2023-01-28
1455.20                                 2023-01-29
1829.91                                 2023-01-30
1784.28                                 2023-01-31
1708.00                                 2023-02-01
1762.85                                 2023-02-02                \
1840.50                                 2023-02-03        ---------- (results can be used to display a scatter plot visual using PowerBi or excel!)
1806.10                                 2023-02-04                /
1651.75                                 2023-02-05
1532.00                                 2023-02-06
1788.45                                 2023-02-07
2053.68                                 2023-02-08
2008.63                                 2023-02-09
2113.25                                 2023-02-10
1913.79                                 2023-02-11
2179.50                                 2023-02-12
1950.53                                 2023-02-13
2093.63                                 2023-02-14
2190.10                                 2023-02-15
2341.68                                 2023-02-16
1715.60                                 2023-02-17
2188.28                                 2023-02-18
2468.15                                 2023-02-19
2234.73                                 2023-02-20
2038.88                                 2023-02-21
1948.50                                 2023-02-22
1907.51                                 2023-02-23
1958.85                                 2023-02-24
1904.00                                 2023-02-25
2065.85                                 2023-02-26
2171.95                                 2023-02-27
1597.60                                 2023-02-28
2082.55                                 2023-03-01
2101.65                                 2023-03-02
2230.10                                 2023-03-03
1950.85                                 2023-03-04
2103.45                                 2023-03-05
1848.00                                 2023-03-06
2057.95                                 2023-03-07
2661.56                                 2023-03-08
2628.12                                 2023-03-09
2585.28                                 2023-03-10
2362.95                                 2023-03-11
2326.78                                 2023-03-12
2505.20                                 2023-03-13
2689.66                                 2023-03-14
2534.98                                 2023-03-15
2574.16                                 2023-03-16
2473.45                                 2023-03-17
2626.06                                 2023-03-18
2583.38                                 2023-03-19
2561.13                                 2023-03-20
2361.90                                 2023-03-21
2264.26                                 2023-03-22
2316.53                                 2023-03-23
2400.65                                 2023-03-24
2304.55                                 2023-03-25
2216.38                                 2023-03-26
2472.45                                 2023-03-27
1964.75                                 2023-03-28
1806.75                                 2023-03-29
2135.32                                 2023-03-30
2102.28                                 2023-03-31
2587.45                                 2023-04-01
2496.05                                 2023-04-02
2543.55                                 2023-04-03
2323.45                                 2023-04-04
2560.05                                 2023-04-05
2298.50                                 2023-04-06
2711.60                                 2023-04-07
3398.11                                 2023-04-08
3103.28                                 2023-04-09
3166.95                                 2023-04-10
2826.56                                 2023-04-11
3044.03                                 2023-04-12
2892.78                                 2023-04-13
3314.15                                 2023-04-14
3052.89                                 2023-04-15
3487.19                                 2023-04-16
2812.20                                 2023-04-17
3306.72                                 2023-04-18
3326.86                                 2023-04-19
3028.18                                 2023-04-20
2870.43                                 2023-04-21
2662.93                                 2023-04-22
2958.04                                 2023-04-23
2914.55                                 2023-04-24
2870.30                                 2023-04-25
3146.10                                 2023-04-26
2931.15                                 2023-04-27
2382.45                                 2023-04-28
2095.05                                 2023-04-29
2598.03                                 2023-04-30
3304.95                                 2023-05-01
3239.80                                 2023-05-02
3359.10                                 2023-05-03
3208.55                                 2023-05-04
3328.70                                 2023-05-05
2966.45                                 2023-05-06
3285.40                                 2023-05-07
4117.71                                 2023-05-08
3955.62                                 2023-05-09
3885.23                                 2023-05-10
3630.36                                 2023-05-11
3470.83                                 2023-05-12
3882.58                                 2023-05-13
4025.15                                 2023-05-14
4046.23                                 2023-05-15
4284.48                                 2023-05-16
3600.40                                 2023-05-17
4234.12                                 2023-05-18
4257.03                                 2023-05-19
4321.03                                 2023-05-20
3911.46                                 2023-05-21
3744.26                                 2023-05-22
3547.71                                 2023-05-23
3672.45                                 2023-05-24
3531.10                                 2023-05-25
3611.20                                 2023-05-26
3750.95                                 2023-05-27
3119.10                                 2023-05-28
2846.65                                 2023-05-29
3531.83                                 2023-05-30
3406.48                                 2023-05-31
3612.30                                 2023-06-01
3537.65                                 2023-06-02
3659.45                                 2023-06-03
3453.45                                 2023-06-04
3484.25                                 2023-06-05
3227.40                                 2023-06-06
3555.65                                 2023-06-07
4617.29                                 2023-06-08
4414.66                                 2023-06-09
4210.30                                 2023-06-10
4055.46                                 2023-06-11
3950.25                                 2023-06-12
4306.76                                 2023-06-13
4658.97                                 2023-06-14
4383.14                                 2023-06-15
4596.98                                 2023-06-16
3953.35                                 2023-06-17
4614.24                                 2023-06-18
4918.06                                 2023-06-19
4258.06                                 2023-06-20
4293.73                                 2023-06-21
3753.25                                 2023-06-22
3906.26                                 2023-06-23
4012.65                                 2023-06-24
3906.75                                 2023-06-25
3980.45                                 2023-06-26
4010.05                                 2023-06-27
3335.75                                 2023-06-28
3162.35                                 2023-06-29
3742.17                                 2023-06-30   */

------------------------------------------------------------------------------------------
-- 2) Which days of the week tend to be the busiest, and why do you think that's the case?
------------------------------------------------------------------------------------------
/* Busiest Days */
select count(transaction_id) "number of customers",
       datename(dw, transaction_date) "day"
from [Coffee Shop Sales]
group by datename(dw, transaction_date)
order by [number of customers] desc;
/* number of customers day
------------------- ------------------------------
21701               Friday
21654               Thursday
21643               Monday                 \
21310               Wednesday   ------------- (results can be used to display a bar graph visual utilizing PowerBi or excel!)
21202               Tuesday                /
21096               Sunday
20510               Saturday 

The last two days of the work week and the first day of the work week are the busiest times of the week. 
My prediction is customers drink more during the end of the week to power through the last days of the week, 
which could be due to the fact that customers may sleep less during the end of the week. While the beginning 
of the week customers need more coffee to get through a weekend where sleep could be compromised.         */

---------------------------------------------------
-- 3) Which products are sold most and least often?
---------------------------------------------------
/* Most Sold Products */
select top 10 count(product_id) "num of products",
       product_detail,
	   product_type,
	   product_category
from [Coffee Shop Sales]
group by product_type,
         product_detail,
		 product_category
order by [num of products] desc;
/* Top 10 Sold Products 
num of products   product_detail                                     product_type                                       product_category
--------------- -------------------------------------------------- -------------------------------------------------- --------------------------------------------------
3076              Chocolate Croissant                                Pastry                                             Bakery
3053              Earl Grey Rg                                       Brewed Black tea                                   Tea
3029              Dark chocolate Lg                                  Hot chocolate                                      Drinking Chocolate
3026              Morning Sunrise Chai Rg                            Brewed Chai tea                                    Tea
3013              Columbian Medium Roast Rg                          Gourmet brewed coffee                              Coffee
2990              Latte                                              Barista Espresso                                   Coffee
2961              Sustainably Grown Organic Lg                       Hot chocolate                                      Drinking Chocolate
2955              Traditional Blend Chai Rg                          Brewed Chai tea                                    Tea
2951              Spicy Eye Opener Chai Lg                           Brewed Chai tea                                    Tea
2949              Peppermint Rg                                      Brewed herbal tea                                  Tea                                             */

/* Least Sold Products */
select top 10 count(product_id) "num of products",
              product_detail, 
			  product_type,
			  product_category
from [Coffee Shop Sales]
group by product_detail,
         product_type,
		 product_category
order by [num of products] asc;
/* Bottom 10 Sold Products
num of products   product_detail                                     product_type                                       product_category
--------------- -------------------------------------------------- -------------------------------------------------- --------------------------------------------------
118               Dark chocolate                                     Drinking Chocolate                                 Packaged Chocolate
122               Spicy Eye Opener Chai                              Chai tea                                           Loose Tea
134               Guatemalan Sustainably Grown                       Green beans                                        Coffee beans
142               Earl Grey                                          Black tea                                          Loose Tea
146               Jamacian Coffee River                              Premium Beans                                      Coffee beans
148               Columbian Medium Roast                             Gourmet Beans                                      Coffee beans
148               Chili Mayan                                        Drinking Chocolate                                 Packaged Chocolate
150               Primo Espresso Roast                               Espresso Beans                                     Coffee beans
152               Lemon Grass                                        Herbal tea                                         Loose Tea
153               Traditional Blend Chai                             Chai tea                                           Loose Tea          */

-------------------------------------------------------------
-- 4) Which product drives the most revenue for the business?
-------------------------------------------------------------
/* Top 10 Most Revenue Products */
select cast(sum(unit_price) as decimal(10,2)) "total revenue",
       product_category
from [Coffee Shop Sales]
group by product_category
order by [total revenue] desc;
/* total revenue                           product_category
--------------------------------------- --------------------------------------------------
176629.30                               Coffee
128035.35                               Tea
80964.14                                Bakery
47578.75                                Drinking Chocolate
36845.25                                Coffee beans
13237.00                                Branded
11213.60                                Loose Tea
5432.00                                 Flavours
4407.64                                 Packaged Chocolate    */

/* Top 10 Least Revenue Products */
select cast(sum(unit_price) as decimal(10,2)) "total revenue",
       product_category
from [Coffee Shop Sales]
group by product_category
order by [total revenue] asc;
/* total revenue                           product_category
--------------------------------------- --------------------------------------------------
4407.64                                 Packaged Chocolate
5432.00                                 Flavours
11213.60                                Loose Tea
13237.00                                Branded
36845.25                                Coffee beans
47578.75                                Drinking Chocolate
80964.14                                Bakery
128035.35                               Tea
176629.30                               Coffee   */


/* Recommendations:

I recommended that promotions take place during the first three months of the year. Total sales 
are quite lower than the months following and running some type of promotion may help increase
sales. It may also help to run some type of promotion during the first hour of operation (6am). 
That hour generates the least amount of total sales. Between 8am and 10am total sales peak and 
then begin to slowly fall until closing. Fridays, Thrusdays, and Mondays are the busiest days
of the week the organization. Once again, having some sort of promotion or sale during the other
days of the week can help bring in more customers for those days. The organizations top selling 
product categories are the drinking chocolate, tea, and coffee. While the bottom selling product
categories are packaged chocolate, loose tea, and coffee beans. Perhaps creating some new menu 
items with those product categories can bring in new sales, or the organization may think it's 
best to cut those products to limit financial loss. The products that are generating the most 
revenue are the coffee, tea, bakery, and drinking chocolate, while packaged chocolate, flavours
and loose tea are generating the lowest profits. These are items that the organization could 
consider to take off the market to limit financial loss or either remarket those items.  
*/
