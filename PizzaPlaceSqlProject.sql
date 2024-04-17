/* This dataset has been retrieved from the website mavenanalytics.io. The data consist of a year's worth of sales from a fictitious pizza company that include, the date and time of each order, the type of pizza sold, the size of the pizza, the ingredients, and the quantity. 

   In this project I will demonstrate how to perform any data cleaning if neccessary for analysis, transform any rows of data to the correct data type, extract the day and month from the date columns, and the processing of data for mathematical calculations. 

   Objectives: The owner of this pizza company wants to cut losses and capitalize on profits. He has employed our team to help him achieve this goal and handed over multiple sheets of data that he wants to be analyzed. Here is a list of questions that the owner has asked us and we are tasked with the challenge of answering those questions to help him grow his business in the direction of his liking. 

   Questions: 
   How many customers do we have each day? 

   Are there any peak hours?

   How many pizzas are typically in a order?

   Do we have any bestsellers?

   How much money did we make this year? 

   Can we identify any seasonality in the sales?

   Are there any pizzas we should take off the menu, or any promotions we could leverage? */



/* To begin, we first need to identify what table we will need to analyze for this question. 
   Once we have identified the table, we can now begin with our first question. */

--  How many customers do we have each day? --
select count(order_id) "num of cus",
       month(date) "month",
       datename(dw, date) "day of week",
	   date
from orders 
group by datename(dw, date),
		 month(date),
		 date
--having month(date) = 
--and date = ''
--or month(date) = 
--and date = ''
order by date;

/* The code above shows us the number of customers by day. 
   We can delete the tick marks to uncomment and fill in any 
   value we want after the equal sign for search of specific 
   days based on specific conditions. */

-- Are there any peak hours? --
select *,
	case 
		when h."hour" = 9 then '9am'
		when h."hour" =10 then '10am'
		when h."hour" = 11 then '11am'
		when h."hour" = 12 then '12pm'
		when h."hour" = 13 then '1pm'
		when h."hour" = 14 then '2pm'
		when h."hour" = 15 then '3pm'
		when h."hour" = 16 then '4pm'
		when h."hour" = 17 then '5pm'
		when h."hour" = 18 then '6pm'
		when h."hour" = 19 then '7pm'
		when h."hour" = 20 then '8pm'
		when h."hour" = 21 then '9pm'
		when h."hour" = 22 then '10pm'
		when h."hour" = 23 then '11pm'
	end as "peak hours"
from (select ph."num of customers", ph."hour", ph."day", ph."date"
      from (select *, dense_rank() over(partition by "hour" order by "num of customers" desc) "peak"
            from (select count(distinct order_id) "num of customers",
                         datepart(hour, time) "hour",
		                 datename(dw, date) "day",
		                 date
                 from orders
                 group by datepart(hour, time),
                          datename(dw, date),
		                  date) p) ph 
      where ph.peak = 1
      and ph.[num of customers] >= 14) h
order by h.[num of customers] desc;

-- How many pizzas are typically in a order? (Average pizzas per order?) --
select cast
      (cast(sum(quantity) as decimal(10,2)) / 
       cast(count(distinct order_id) as decimal(10,2)) 
	                                                  as decimal(10,2)) "average pizzas per order"
from order_details;

/* This code displays the average number of pizzas per order, which is 2.32 pizzas per order.
   Now we can move on to the next question. */

-- Do we have any best sellers --
select top 5 pizza_id, 
       sum(quantity) "total sold"
from order_details
group by pizza_id
order by [total sold] desc;

/* We'll also take a look at the top 5 least sellers. */
select top 5 pizza_id, 
       sum(quantity) "total sold"
from order_details
group by pizza_id
order by [total sold] asc;

/* Great! Now that we have those numbers figured out, lets move on to the next question */

-- How much money did we make this year? --
select concat('$', cast(sum(t."total") as decimal(10,2))) "total sales"
from (select sum(p.price) "total", 
             p.pizza_id,
	         d.order_id
      from order_details d
      inner join pizzas p
      on d.pizza_id = p.pizza_id
      group by p.pizza_id,
               d.order_id) t;

/* Ok, so now we have the total sales for the year, which was $801944.70. Lets 
   move on to the next question. */

-- Can we identify any seasonality in the sales? --
with season_sales as (select s."total sales" "total sales",
                             s."month"
                      from (select sum(p.price) "total sales",
                                   month(o.date) "month",
	                               p.pizza_id,
	                               d.order_id
                            from pizzas p 
                            inner join order_details d
                            on p.pizza_id = d.pizza_id
                            inner join orders o
                            on d.order_id = o.order_id
                            group by month(o.date),
                                     p.pizza_id,
		                             d.order_id) s)
select season_sales."month",
       concat('$', cast(sum(season_sales."total sales") as decimal(10,2))) "total sales",
		case
			when season_sales."month" = 1 then 'January'
			when season_sales."month" = 2 then 'Feburary'
			when season_sales."month" = 3 then 'March'
			when season_sales."month" = 4 then 'April'
			when season_sales."month" = 5 then 'May'
			when season_sales."month" = 6 then 'June'
			when season_sales."month" = 7 then 'July'
			when season_sales."month" = 8 then 'August'
			when season_sales."month" = 9 then 'September'
			when season_sales."month" = 10 then 'October'
			when season_sales."month" = 11 then 'November'
			when season_sales."month" = 12 then 'December'
		end as "month names"
from season_sales
where season_sales."month" in (1,3,5,7,11)
group by season_sales."month"
order by season_sales."month" asc;

/* The above query returns the months where the total sales were above 68k. 
   With the highest month being in July with over 71k in sales, and the lowest 
   month being in January with over 68k in total sales. */

/* Now to move on to the owners last question... */

-- Are there any pizzas we should take off the menu, or any promotions we could leverage? -- 

/* My recommendations for the owner: 
   
   I suggest cutting cost by removing the bottom 10 selling pizzas from the menu. I would also
   suggest that to increase business, the owner can possibly run promotions during the months 
   where total sales are below satisfaction. Perhaps offer buy 2 pizzas get a third free, buy
   1 large pizza get another one discounted. */







