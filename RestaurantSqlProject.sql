/* This dataset is from the mavenanalytics.io website. In this project, we will be analyzing a quarter's worth of orders from a fictitious restaurant serving international cuisisne, including the date and time of each order, the itmes ordered, and additional details on the type, name, and price of the items. 

Objective: The owner of the restaurant has reached out to us and asked us to comb through the data to identify any trends and to answer a few business questions. This task will completed by utilizing the power of SQL. 

Questions:

What were the least and most ordered items?

What categories weer they in?

What do the highest spent orders look like?

Which items did they buy and how much did they spend?

Were there certain times that had more or less orders?

Which cuisines should we focus on developing more menu items for based on the data? */


-- Upon downloading this dataset, the order_details_csv table imported a few columns with the incorrect data types. In order to assure the most accurate analysis, we will have to convert those columns to the proper data type.

-------------------------------------------------------------------------------------------------------------------
/* DATA CLEANING/ TRANSFORMATION */

-- Converting the column order_id to int datatype
update order_details
set order_details_id = convert(int, order_details_id);

-- Converting the column order_details_id to int datatype
update order_details
set order_id = convert(int, order_id);

-- Removing null values (in this case, 'NULL' string) from the column item_id in order to convert column to int
delete from order_details
where item_id = 'NULL';

-- Converting the column item_id to int datatype
update order_details
set item_id = convert(int, item_id)
---------------------------------------------------------------------------------------------------------------

--  1) What were the least and most ordered items?
with cte as (select *, rank() over(order by m."times ordered" desc) "ordered"
             from (select count(distinct d.order_id) "times ordered",
                          i.item_name
                   from order_details d
                   inner join menu_items i
                   on d.item_id = i.menu_item_id
                   group by i.item_name) m)
select cte."times ordered",
       cte.item_name
from cte
where cte.ordered in (1, 32);

/* 596	    Edamame
   123	    Chicken Tacos */
-------------------------------------------------------------------------------------------------
-- The results indicate Edamame was ordered 596 times and Chicken Tacos were ordered 123 times --
-------------------------------------------------------------------------------------------------

-- 2) What categories were they in?
with cte as (select *, rank() over(order by m."times ordered" desc) "ordered"
             from (select count(distinct d.order_id) "times ordered",
                          i.item_name,
						  i.category
                   from order_details d
                   inner join menu_items i
                   on d.item_id = i.menu_item_id
                   group by i.item_name,
				            i.category) m)
select cte."times ordered",
       cte.item_name,
	   cte.category
from cte
where cte.ordered in (1, 32);

/* 596	  Edamame	       Asian
   123	  Chicken Tacos	   Mexican */
-------------------------------------------------------------------------------------------------------------
-- The results shows us that the most ordered category is Asian, and the least ordered category is Mexican --
-------------------------------------------------------------------------------------------------------------

-- 3) What do the highest spend orders look like?
select top 10 h.item_name,
              h.category,
	          h."total spent"
from (select count(d.order_details_id) "num of orders",
             cast(sum(i.price) as decimal(10,2)) "total spent",
             d.item_id,
	         i.category,
	         i.item_name
     from order_details d
     inner join menu_items i
     on d.item_id = i.menu_item_id
     group by d.item_id,
		      i.category,
		      i.item_name) h
order by [total spent] desc;

/* Korean Beef Bowl	        Asian	     10554.60
   Spaghetti & Meatballs	Italian	     8436.50
   Tofu Pad Thai	        Asian	     8149.00
   Cheeseburger	            American	 8132.85
   Hamburger	            American	 8054.90
   Orange Chicken	        Asian	     7524.00
   Eggplant Parmesan	    Italian	     7119.00
   Steak Torta	            Mexican	     6821.55
   Chicken Parmesan	        Italian	     6533.80
   Pork Ramen	            Asian	     6462.00 */
----------------------------------------------------------------------
-- The results are from the top 10 ordered dishes in the restaurant --
----------------------------------------------------------------------

-- 4) Which items did they buy and how much did they spend?

-- (We can use the results from above to answer this question.) --

/*   Top 10 items bought: Korean Beef Bowl
                        Spaghetti & Meatballs
                        Tofu Pad Thai
                        Cheeseburger
                        Hamburger
                        Orange Chicken
                        Eggplant Parmesan
                        Steak Torta
                        Chicken Parmesan
                        Pork Ramen

  The total spent for those items: 10554.60
                                   8436.50
                                   8149.00
                                   8132.85
                                   8054.90
                                   7524.00
                                   7119.00
                                   6821.55
                                   6533.80
                                   6462.00   */
---------------------------------------------------------------------

-- 5) Were there certain times that had more or less orders?
select h."num of orders",
	case
		when h."order hour" = 10 then '10am'
		when h."order hour" = 11 then '11am'
		when h."order hour" = 12 then '12pm'
		when h."order hour" = 13 then '1pm'
		when h."order hour" = 14 then '2pm'
		when h."order hour" = 15 then '3pm'
		when h."order hour" = 16 then '4pm'
		when h."order hour" = 17 then '5pm'
		when h."order hour" = 18 then '6pm'
		when h."order hour" = 19 then '7p'
		when h."order hour" = 20 then '8pm'
		when h."order hour" = 21 then '9pm'
		when h."order hour" = 22 then '10pm'
		when h."order hour" = 23 then '11pm'
		when h."order hour" = 24 then '12am'
	end as "hour"
from (select count(d.order_details_id) "num of orders",
             datepart(hour, d.order_time) "order hour"
      from order_details d
      group by datepart(hour, d.order_time)) h
order by [num of orders] desc;

/* num of orders        hour
   -------------        ----
   1659                 12pm
   1558                 1pm
   1355                 5pm
   1290                 6pm
   1074                 7p
   1035                 4pm
   956                  2pm
   882                  8pm
   743                  3pm
   624                  11am
   600                  9pm
   305                  10pm
   11                   11pm
   5                    10am */
-------------------------------------------------------------
-- Result set returning the num of orders by hour -- 
-------------------------------------------------------------

-- 6) Which cuisines should we focus on developing more menu items for based on the data?
select top 10 h.item_name,
              h.category,
	          h."total spent"
from (select count(d.order_details_id) "num of orders",
             cast(sum(i.price) as decimal(10,2)) "total spent",
             d.item_id,
	         i.category,
	         i.item_name
     from order_details d
     inner join menu_items i
     on d.item_id = i.menu_item_id
     group by d.item_id,
		      i.category,
		      i.item_name) h
order by [total spent] asc;

/* item_name                                          category                                           total spent
-------------------------------------------------- -------------------------------------------------- ---------------------------------------
Chicken Tacos                                      Mexican                                            1469.85
Potstickers                                        Asian                                              1845.00
Chips & Guacamole                                  Mexican                                            2133.00
Hot Dog                                            American                                           2313.00
Cheese Quesadillas                                 Mexican                                            2446.50
Veggie Burger                                      American                                           2499.00
Steak Tacos                                        Mexican                                            2985.30
Edamame                                            Asian                                              3100.00
Cheese Lasagna                                     Italian                                            3208.50
Chips & Salsa                                      Mexican                                            3227.00
---------------------------------------------------------------------------------------------------------------------------------------------
Recommendations: 

Based on the above date of the top 10 least selling items, I would recommend developing more menu itmes for these dishes.
--------------------------------------------------------------------------------------------------------------------------------------------- 