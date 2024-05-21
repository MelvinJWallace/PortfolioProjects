/* The data from this project was retrieved from the website mavenanalytics.io. The data consist of a pipeline of business to business sales from a fictitious company that sells 
   computer hardware, including information on accounts, products, sales teams, and sales opportunities.  

   In this project, I will utilize SQL to import a csv file into a created database. Once the data has been imported, I will clean the data by checking for unique, duplicate, and null 
   values. I will also utilize functions to extract the day and month from the date column as well as extract the hour from the time column to get a more in depth analysis. Finally I 
   will explore the data looking for any trends and patterns and answer the given questions.

   QUESTIONS:
   1) How is each sales team performing compared to the rest?
   2) Are any sales agents lagging behind?
   3) Can you identify any quarter-over-quarter trends?
   4) Do any products have better win rates?
*/

-- I will inspect the first 3 rows of data from each table to make sure that all of the data has been imported successfully.
select top 3 * from accounts;
/* account                                            sector                                             year_established revenue                employees   office_location                                    subsidiary_of
-------------------------------------------------- -------------------------------------------------- ---------------- ---------------------- ----------- -------------------------------------------------- --------------------------------------------------
Acme Corporation                                   technolgy                                          1996             1100.0400390625        2822        United States                                      NULL
Betasoloin                                         medical                                            1999             251.410003662109       495         United States                                      NULL
Betatech                                           medical                                            1986             647.179992675781       1185        Kenya                                              NULL */
select top 3 * from products;
/* product                                            series                                             sales_price
-------------------------------------------------- -------------------------------------------------- -----------
GTX Basic                                          GTX                                                550
GTX Pro                                            GTX                                                4821
MG Special                                         MG                                                 55 */
select top 3 * from sales_pipeline;
/* opportunity_id                                     sales_agent                                        product                                            account                                            deal_stage                                         engage_date close_date close_value
-------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ----------- ---------- -----------
1C1I7A6R                                           Moses Frase                                        GTX Plus Basic                                     Cancity                                            Won                                                2016-10-20  2017-03-01 1054
Z063OYW0                                           Darcel Schlecht                                    GTXPro                                             Isdom                                              Won                                                2016-10-25  2017-03-11 4514
EC4QE1BX                                           Darcel Schlecht                                    MG Special                                         Cancity                                            Won                                                2016-10-25  2017-03-07 50 */
select top 3 * from sales_teams;
/* sales_agent                                        manager                                            regional_office
-------------------------------------------------- -------------------------------------------------- --------------------------------------------------
Anna Snelling                                      Dustin Brinkmann                                   Central
Cecily Lampkin                                     Dustin Brinkmann                                   Central
Versie Hillebrand                                  Dustin Brinkmann                                   Central */

/* So the data from all of the tables looks to be consistent, now I will check each table for any duplicate rows of data */
select *
from (select *, row_number() over(partition by account order by account) "duplicates"
      from accounts) d
where d.duplicates >= 2;
/* (0 rows affected)
account                                            sector                                             year_established revenue                employees   office_location                                    subsidiary_of                                      duplicates
-------------------------------------------------- -------------------------------------------------- ---------------- ---------------------- ----------- -------------------------------------------------- -------------------------------------------------- --------------------  
The query returned 0 rows, this tells me that there are no rows of duplicated data in the 'accounts' table. 
-----------------------------------------------------------------------------------------------------------
*/
with dup as (select *, row_number() over(partition by product order by product) "duplicates"
             from products)
select dup.*
from dup
where dup.duplicates >= 2;
/* (0 rows affected)
product                                            series                                             sales_price duplicates
-------------------------------------------------- -------------------------------------------------- ----------- --------------------
The table 'products' has 0 rows of duplicated data.
---------------------------------------------------
*/
select *
from (select *, row_number() over(partition by opportunity_id order by engage_date asc) "duplicates"
      from sales_pipeline) d
where d.duplicates >= 2;
/* (0 rows affected)
opportunity_id                                     sales_agent                                        product                                            account                                            deal_stage                                         engage_date close_date close_value duplicates
-------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ----------- ---------- ----------- --------------------
The table 'sales_pipeline' has 0 rows of duplicated data.
---------------------------------------------------------
*/
with dup as (select *, row_number() over(partition by sales_agent order by sales_agent asc) "duplicates"
             from sales_teams)
select dup.*
from dup
where dup.duplicates >= 2;
/* (0 rows affected)
sales_agent                                        manager                                            regional_office                                    duplicates
-------------------------------------------------- -------------------------------------------------- -------------------------------------------------- --------------------
There are 0 rows of data in the 'sales_teams' table.
----------------------------------------------------
*/

-- Now I will take a look at the number of unique values for each column in each table.

--'accounts table --
select count(distinct account) "num of unique accounts"
from accounts;
---------------------------------------------------------
-- There area 85 unique accounts in the 'accounts' table.
---------------------------------------------------------
select count(distinct sector) "num of unique sectors"
from accounts;
-------------------------------------------------------
-- There are 10 unique sectors in the 'accounts' table.
-------------------------------------------------------
select count(distinct year_established) "num of unique years established columns"
from accounts;
--------------------------------------------------------------------------
-- There are 35 unique 'year_established' columns in the 'accounts' table.
--------------------------------------------------------------------------
select count(distinct revenue) "num of unique revenues"
from accounts;
--------------------------------------------------------
-- There are 85 unique revenues in the 'accounts' table.
--------------------------------------------------------
select count(distinct employees) "num of unique employees"
from accounts;
---------------------------------------------------------
-- There are 85 unique employees in the 'accounts' table.
---------------------------------------------------------
select count(distinct office_location) "num of unique office locations"
from accounts;
----------------------------------------------------------------
-- There are 15 unique office locations in the 'accounts' table.
----------------------------------------------------------------
select count(distinct subsidiary_of) "num of uinique subsidiary_of's"
from accounts;
--------------------------------------------------------------
-- There are 7 unique subsidiary of's in the 'accounts' table.
--------------------------------------------------------------

--products table --
select count(distinct product) "num of unique products"
from products;
-------------------------------------------------------
-- There are 7 unique products in the 'products' table.
-------------------------------------------------------
select count(distinct series) "num of unique series"
from products;
-----------------------------------------------------
-- There are 3 unique series in the 'products' table.
-----------------------------------------------------
select count(distinct sales_price) "num of unique sales prices"
from products;
-----------------------------------------------------------
-- There are 7 unique sales prices in the 'products' table.
-----------------------------------------------------------

-- sales_pipeline table --
select count(distinct opportunity_id) "num of unique opportunity id's"
from sales_pipeline;
-------------------------------------------------------------------------
-- There are 8800 unique opportunity ids from the 'sales_pipeline' table.
-------------------------------------------------------------------------
select count(distinct sales_agent) "num of unique sales agents"
from sales_pipeline;
------------------------------------------------------------------
-- There are 30 unique sales agents in the 'sales_pipeline' table.
------------------------------------------------------------------
select count(distinct product) "num of unique products"
from sales_pipeline;
------------------------------------------------------------
-- There are 7 unique products in the 'sales_pipeline table.
------------------------------------------------------------
select count(distinct account) "num of unique accounts"
from sales_pipeline;
--------------------------------------------------------------
-- There are 85 unique accounts in the 'sales_pipeline' table.
--------------------------------------------------------------
select count(distinct deal_stage) "num of unique deal stages"
from sales_pipeline;
----------------------------------------------------------------
-- There are 4 unique deal stages in the 'sales_pipeline' table.
----------------------------------------------------------------
select count(engage_date) "num of unique engage dates"
from sales_pipeline;
--------------------------------------------------------------------
-- There are 8300 unique engage dates in the 'sales_pipeline' table.
--------------------------------------------------------------------
select count(distinct close_date) "num of unique close dates"
from sales_pipeline;
------------------------------------------------------------------
-- There are 306 unique close dates in the 'sales_pipeline' table.
------------------------------------------------------------------
select count(close_value) "num of unique close values"
from sales_pipeline;
--------------------------------------------------------------------
-- There are 6711 unique close values in the 'sales_pipeline' table.
--------------------------------------------------------------------

-- sales_teams -- 
select count(distinct sales_agent) "num of unique sales agents"
from sales_teams;
---------------------------------------------------------------
-- There are 35 unique sales agents in the 'sales_teams' table.
---------------------------------------------------------------
select count(distinct manager) "num of unique managers"
from sales_teams;
----------------------------------------------------------
-- There are 6 unique managers in the 'sales_teams' table.
----------------------------------------------------------
select count(distinct regional_office) "num of unique regional offices"
from sales_teams;
------------------------------------------------------------------
-- There are 3 unique regional offices in the 'sales teams' table.
------------------------------------------------------------------

/* Now that I have a better understanding of the data, I will now move on to answering the business questions. */

-- 1) How is each sales team performing compared to the rest? 
/* So to tackle this question, I will begin by joining all of the tables. */
select top 3 t.sales_agent, t.manager, 
	         t.regional_office, p.opportunity_id,
	         p.product, p.account,
	         p.deal_stage, p.engage_date,
	         p.close_date, p.close_value,
	         pr.series, pr.sales_price,
	         a.sector, a.year_established,
	         a.revenue, a.employees,
	         a.office_location, a.subsidiary_of
from sales_teams t
inner join sales_pipeline p
on t.sales_agent = p.sales_agent
inner join products pr
on p.product = pr.product
inner join accounts a
on p.account = a.account;
-- (preview of results) --
/*
sales_agent              manager                    regional_office          opportunity_id       product                 account          deal_stage         engage_date   close_date   close_value   series      sales_price   sector            year_established   revenue                employees   office_location         subsidiary_of
-------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ------------------------------- 
Moses Frase              Dustin Brinkmann           Central                  1C1I7A6R             GTX Plus Basic          Cancity          Won                2016-10-20    2017-03-01   1054          GTX         1096          retail            2001               718.619995117188       2448        United States           NULL
Darcel Schlecht          Melvin Marxen              Central                  EC4QE1BX             MG Special              Cancity          Won                2016-10-25    2017-03-07   50            MG          55            retail            2001               718.619995117188       2448        United States           NULL
Moses Frase              Dustin Brinkmann           Central                  MV1LWRNH             GTX Basic               Codehow          Won                2016-10-25    2017-03-09   588           GTX         550           software          1998               2714.89990234375       2641        United States           Acme Corporation
*/

-- Sales by regional office --
select distinct st.regional_office,
                round(sum(st.revenue), 2) "total revenue by manager"
from (select t.sales_agent, t.manager, 
	   t.regional_office, p.opportunity_id,
	   p.product, p.account,
	   p.deal_stage, p.engage_date,
	   p.close_date, p.close_value,
	   pr.series, pr.sales_price,
	   a.sector, a.year_established,
	   a.revenue, a.employees,
	   a.office_location, a.subsidiary_of
       from sales_teams t
       inner join sales_pipeline p
       on t.sales_agent = p.sales_agent
       inner join products pr
       on p.product = pr.product
       inner join accounts a
       on p.account = a.account) st
group by st.regional_office
order by "total revenue by manager" desc;
/* (3 rows affected)
regional_office          total revenue by manager
------------------------ ------------------------
West                     5986321.25
Central                  5015720.48
East                     4001960.16
----------------------------------------------------------------------------------------
According to the data, I can see that the sales team in the West is performing the best.
----------------------------------------------------------------------------------------
*/

-- Sales by manager -- 
select distinct st.manager,
                round(sum(st.revenue), 2) "total sales by manager",
	            st.regional_office
from (select t.sales_agent, t.manager, 
	   t.regional_office, p.opportunity_id,
	   p.product, p.account,
	   p.deal_stage, p.engage_date,
	   p.close_date, p.close_value,
	   pr.series, pr.sales_price,
	   a.sector, a.year_established,
	   a.revenue, a.employees,
	   a.office_location, a.subsidiary_of
       from sales_teams t
       inner join sales_pipeline p
       on t.sales_agent = p.sales_agent
       inner join products pr
       on p.product = pr.product
       inner join accounts a
       on p.account = a.account) st
group by st.manager,
         st.regional_office
order by "total sales by manager" desc;		
/* (6 rows affected)
manager              total sales by manager      regional_office
-------------------- ------------------------ --------------------------------------------------
Summer Sewald        3348224.06                    West
Dustin Brinkmann     2650522.81                    Central
Celia Rouche         2638097.19                    West
Melvin Marxen        2365197.67                    Central
Rocco Neubert        2262633.13                    East
Cara Losch           1739327.03                    East
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
The data indicates that the manager Summer Sewald is performing better than all other managers, while the manager Cara Losch is performing worse than the other managers.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

-- 2) Are any sales agents lagging behind?
-- Bottom 10 sales by sales agent --
select distinct top 10 st.sales_agent,
                       st.manager,
                       round(sum(st.revenue), 2) "total sales by sales agent",
	                   st.regional_office
from (select t.sales_agent, t.manager, 
	   t.regional_office, p.opportunity_id,
	   p.product, p.account,
	   p.deal_stage, p.engage_date,
	   p.close_date, p.close_value,
	   pr.series, pr.sales_price,
	   a.sector, a.year_established,
	   a.revenue, a.employees,
	   a.office_location, a.subsidiary_of
       from sales_teams t
       inner join sales_pipeline p
       on t.sales_agent = p.sales_agent
       inner join products pr
       on p.product = pr.product
       inner join accounts a
       on p.account = a.account) st
group by st.sales_agent,
         st.regional_office,
		 st.manager
order by "total sales by sales agent" asc;	
/* (10 rows affected)
sales_agent                                        manager                                       total sales by sales agent      regional_office
-------------------------------------------------- -------------------------------------------------- -------------------------- --------------------------------------------------
Wilburn Farren                                     Cara Losch                                         156063.06                  East
Garret Kinder                                      Cara Losch                                         273585.39                  East
Rosalina Dieter                                    Celia Rouche                                       285821.05                  West
Rosie Papadopoulos                                 Cara Losch                                         293414.02                  East
Elease Gluck                                       Celia Rouche                                       338646.86                  West
Cecily Lampkin                                     Dustin Brinkmann                                   355913.49                  Central
Daniell Hammack                                    Rocco Neubert                                      369798.2                   East
Boris Faz                                          Rocco Neubert                                      383009.5                   East
Marty Freudenburg                                  Melvin Marxen                                      401491.82                  Central
Moses Frase                                        Dustin Brinkmann                                   406396.55                  Central
-------------------------------------------------------------------------------------------------------------
The chart above displays the bottom 10 total sales by sales agents, their manager, and their regional office.
-------------------------------------------------------------------------------------------------------------
*/

-- 3) Can you identify any quarter-over-quarter trends?
-- 4th quarter over 3rd quarter growth --
with q4 as (select sum(t."4th qtr") "4th qtr sales"
	        from (select round(sum(a.revenue), 2) "4th qtr",
				         month(p.close_date) "close month"
		          from accounts a
		          inner join sales_pipeline p 
		          on a.account = p.account
		          where p.close_date is not null 
		          and month(p.close_date) in (10,11,12)
		          group by month(p.close_date)) t),

     q3 as (select sum(t."3rd qtr") "3rd qtr sales"
	        from (select round(sum(a.revenue), 2) "3rd qtr",
				         month(p.close_date) "close month"
		          from accounts a
		          inner join sales_pipeline p 
		          on a.account = p.account
		          where p.close_date is not null 
		          and month(p.close_date) in (7,8,9)
		          group by month(p.close_date)) t)
select ((q4."4th qtr sales" - q3."3rd qtr sales") / q3."3rd qtr sales" ) "4th qtr over 3rd qtr growth"
from q4,
     q3;
/*
4th qtr over 3rd qtr growth
---------------------------
-0.0068170465287481
*/
-- 3rd quarter over 2nd quarter growth --
with q3 as (select sum(t."3rd qtr") "3rd qtr sales"
	        from (select round(sum(a.revenue), 2) "3rd qtr",
				         month(p.close_date) "close month"
		          from accounts a
		          inner join sales_pipeline p 
		          on a.account = p.account
		          where p.close_date is not null 
		          and month(p.close_date) in (7,8,9)
		          group by month(p.close_date)) t),

     q2 as (select sum(t."2nd qtr") "2nd qtr sales"
	        from (select round(sum(a.revenue), 2) "2nd qtr",
				         month(p.close_date) "close month"
		          from accounts a
		          inner join sales_pipeline p 
		          on a.account = p.account
		          where p.close_date is not null 
		          and month(p.close_date) in (4,5,6)
		          group by month(p.close_date)) t)
select ((q3."3rd qtr sales" - q2."2nd qtr sales") / q2."2nd qtr sales" ) "3rd qtr over 2nd qtr growth"
from q3,
     q2;
/*
3rd qtr over 2nd qtr growth
---------------------------
-0.00640389690616336
*/
-- 2nd quarter over 1st quarter growth --
with q2 as (select sum(t."2nd qtr") "2nd qtr sales"
	        from (select round(sum(a.revenue), 2) "2nd qtr",
				         month(p.close_date) "close month"
		          from accounts a
		          inner join sales_pipeline p 
		          on a.account = p.account
		          where p.close_date is not null 
		          and month(p.close_date) in (4,5,6)
		          group by month(p.close_date)) t),

     q1 as (select sum(t."1st qtr") "1st qtr sales"
	        from (select round(sum(a.revenue), 2) "1st qtr",
				         month(p.close_date) "close month"
		          from accounts a
		          inner join sales_pipeline p 
		          on a.account = p.account
		          where p.close_date is not null 
		          and month(p.close_date) in (1,2,3)
		          group by month(p.close_date)) t)
select ((q2."2nd qtr sales" - q1."1st qtr sales") / q1."1st qtr sales" ) "2nd qtr over 1st qtr growth"
from q2,
     q1;
/* 
2nd qtr over 1st qtr growth
---------------------------
2.2078107028512
-- This discrepancy is more than likely due to the fact that the first quarter data only has one month 
   of sums, where as the other quarters all have 3 months of total sums.
*/

-- 4) Do any products have better win rates?
select distinct product,
       deal_stage,
       count(deal_stage) "num of wins"
from sales_pipeline
where deal_stage = 'won'
group by product,
         deal_stage
order by [num of wins] desc;	
/* (7 rows affected)
product                                            deal_stage                                         num of wins
-------------------------------------------------- -------------------------------------------------- -----------
GTX Basic                                          Won                                                915
MG Special                                         Won                                                793
GTXPro                                             Won                                                729
MG Advanced                                        Won                                                654
GTX Plus Basic                                     Won                                                653
GTX Plus Pro                                       Won                                                479
GTK 500                                            Won                                                15
---------------------------------------------------------------------------------------------------------
The product GTX Basic has the best win rate with 915 total wins, while the product GTK 500 has the lowest 
wind rate with 15 total wins.
---------------------------------------------------------------------------------------------------------



This is the conclusion of my analysis. In this project, I demonstrated how to create a database in Microsoft SQL Server and how to import multiple csv files into that database.
I then demonstrated how to check for duplicate rows of data and how to check the number of unique values in each column. From there, I demonstrated how to utilize inner join to
combine multiple tables to answer the above questions. Lastly, I demonstrated how to create temporary tables to retrieve desired information from. 
*/
