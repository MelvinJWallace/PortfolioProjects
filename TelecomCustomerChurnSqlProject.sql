/* In this project I will utilize the power of Sql to analyze a dataset containing churn data for a fictional Telecommunications company that provides phone and internet services to 7,043 customers in California, and includes details 
   about customer demographics, location, services, and current status.

RECOMMENDED ANALYSIS: 

	1. How many customers joined the company during the last quarter? How many customers joined?
	2. What is the customer profile for a customer that churned, joined, and stayed? Are they different?
	3. What seem to be the key drivers of customer churn?
	4. Is the company losing high value customers? If so, how can they retain them?

There are two csv files that are associated with this project, which have both been successfully uploaded to a database that I created named 'TelecomCustomerChurnDB'. This database will have two tables named 'dbo.telecom_customer_churn'
and 'dbo.telecom_zipcode_population'. The data in these files are already cleaned and is ready to be analyzed. I will start this project off by examining the data from both tables to get a better understanding of the data.
*/

-- DATA EXAMINATION:
--------------------

-- Checking the 'telecom_customer_churn' table for duplicate rows of data --
select * 
from (select *, row_number() over(partition by Customer_ID order by Customer_ID) "duplicate"
      from telecom_customer_churn) d
where d.duplicate >= 2;
/*
(0 rows affected) - There are no rows of duplicate data in this table
*/

-- Checking the 'telecom_zipcode_population' table for duplicate rows of data --
select *
from (select *, row_number() over(partition by Zip_Code order by Zip_Code) "duplicate"
      from telecom_zipcode_population) d
where d.duplicate >= 2;
/*
(0 rows affected) - There are also no rows of duplicated data in this table
*/

-- So either of my tables have any duplicate rows of data, and my data is cleaned and ready for analysis. I am ready to move on to the recommended analysis for this project. 

--RECOMMENDED ANALYSIS:
-- 1. How many customers joined the company during the last quarter? How many customers joined?

select count(Customer_ID) "Number of customers who joined during last quarter"
from telecom_customer_churn
where Customer_Status = 'Stayed';
/* 
Number of customers who joined during last quarter
--------------------------------------------------
4720

--------------------------------------------------------------------------
There were 4,720 customers who joined the company during the last quarter.
--------------------------------------------------------------------------
*/
select count(Customer_ID) "Number of customers who joined"
from telecom_customer_churn
where Customer_Status = 'Joined';
/*
Number of customers who joined
------------------------------
454

---------------------------------------------------------
There were 454 customers who recently joined the company.
---------------------------------------------------------
*/

-- 2. What is the customer profile for a customer that churned, joined, and stayed? Are they different?

select Gender, count(Gender) "Gender count", Customer_Status
from telecom_customer_churn
group by Gender, Customer_Status
order by [Gender count] desc, Customer_Status;
/*
------------------------------------------------------------------------------
The customer profile for customers that churned, joined, or stayed per gender
------------------------------------------------------------------------------
Gender                                             Gender count Customer_Status
-------------------------------------------------- ------------ --------------------------------------------------
Male                                               2382         Stayed
Female                                             2338         Stayed
Female                                             939          Churned
Male                                               930          Churned
Male                                               243          Joined
Female                                             211          Joined
*/

select Married, count(Married) "Married count", Customer_Status,
	case
		when Married = 1 then 'Married'
		when Married = 0 then 'Not Married'
	end as "Marriage Status"
from telecom_customer_churn
group by Married, Customer_Status
order by [Married count] desc, Customer_Status;
/*
---------------------------------------------------------------------------------------
The customer profile for customers that churned, joined, or stayed per marriage status
---------------------------------------------------------------------------------------
Married Married count Customer_Status                                    Marriage Status
------- ------------- -------------------------------------------------- ---------------
1       2649          Stayed                                             Married
0       2071          Stayed                                             Not Married
0       1200          Churned                                            Not Married
1       669           Churned                                            Married
0       370           Joined                                             Not Married
1       84            Joined                                             Married
*/

select Customer_Status, count(Customer_Status) "Status count"
from telecom_customer_churn
group by Customer_Status;
/*
--------------------------------------------------------------------------------------
The customer profile for customers that churned, joined, or stayed per customer status
--------------------------------------------------------------------------------------
Customer_Status                                    Status count
-------------------------------------------------- ------------
Joined                                             454
Churned                                            1869
Stayed                                             4720
*/

select Offer, count(Offer) "Number of customers", Customer_Status
from telecom_customer_churn
group by Offer, Customer_Status
order by Offer, [Number of customers] desc;
/*
-----------------------------------------------------------------------------
The customer profile for customers that churned, joined, or stayed per offer
-----------------------------------------------------------------------------
Offer                                              Number of customers Customer_Status
-------------------------------------------------- ------------------- --------------------------------------------------
None                                               2547                Stayed
None                                               1051                Churned
None                                               279                 Joined
Offer A                                            485                 Stayed
Offer A                                            35                  Churned
Offer B                                            723                 Stayed
Offer B                                            101                 Churned
Offer C                                            320                 Stayed
Offer C                                            95                  Churned
Offer D                                            441                 Stayed
Offer D                                            161                 Churned
Offer E                                            426                 Churned
Offer E                                            204                 Stayed
Offer E                                            175                 Joined
*/

select Phone_Service, count(Phone_Service) "Num of customers", Customer_Status,
	case
		when Phone_Service = 1 then 'Phone'
		when Phone_Service = 0 then 'No Phone'
	end as "Phone Status"
from telecom_customer_churn
group by Phone_Service, Customer_Status
order by [Phone Status], [Num of customers] desc;
/*
-------------------------------------------------------------------------------------
The customer profile for customers that churned, joined, or stayed per phone service 
-------------------------------------------------------------------------------------
Phone_Service Num of customers Customer_Status                                    Phone Status
------------- ---------------- -------------------------------------------------- ------------
0             474              Stayed                                             No Phone
0             170              Churned                                            No Phone
0             38               Joined                                             No Phone
1             4246             Stayed                                             Phone
1             1699             Churned                                            Phone
1             416              Joined                                             Phone
*/

select Internet_Service, count(Internet_Service) "Num of customers", Customer_Status,
	case
		when Internet_Service = 1 then 'Internet'
		when Internet_Service = 0 then 'No Internet'
	end as "Internet Status"
from telecom_customer_churn
group by Internet_Service, Customer_Status
order by Internet_Service, [Num of customers] desc;
/*
----------------------------------------------------------------------------------------
The customer profile for customers that churned, joined, or stayed per internet service
----------------------------------------------------------------------------------------
Internet_Service Num of customers Customer_Status                                    Internet Status
---------------- ---------------- -------------------------------------------------- ---------------
0                1231             Stayed                                             No Internet
0                182              Joined                                             No Internet
0                113              Churned                                            No Internet
1                3489             Stayed                                             Internet
1                1756             Churned                                            Internet
1                272              Joined                                             Internet
*/

select Internet_Type, count(Internet_Type) "Num of customers", Customer_Status
from telecom_customer_churn
where Internet_Type is not null
group by Internet_Type, Customer_Status
order by Internet_Type, [Num of customers] desc;
/*
-------------------------------------------------------------------------------------
The customer profile for customers that churned, joined, or stayed per internet type
-------------------------------------------------------------------------------------
Internet_Type                                      Num of customers Customer_Status
-------------------------------------------------- ---------------- --------------------------------------------------
Cable                                              561              Stayed
Cable                                              213              Churned
Cable                                              56               Joined
DSL                                                1230             Stayed
DSL                                                307              Churned
DSL                                                115              Joined
Fiber Optic                                        1698             Stayed
Fiber Optic                                        1236             Churned
Fiber Optic                                        101              Joined
*/

select Contract, count(Contract) "Num of customers", Customer_Status
from telecom_customer_churn
group by Contract, Customer_Status
order by Contract, [Num of customers] desc;
/*
--------------------------------------------------------------------------------
The customer profile for customers that churned, joined, or stayed per contract
--------------------------------------------------------------------------------
Contract                                           Num of customers Customer_Status
-------------------------------------------------- ---------------- --------------------------------------------------
Month-to-Month                                     1655             Churned
Month-to-Month                                     1547             Stayed
Month-to-Month                                     408              Joined
One Year                                           1360             Stayed
One Year                                           166              Churned
One Year                                           24               Joined
Two Year                                           1813             Stayed
Two Year                                           48               Churned
Two Year                                           22               Joined
*/

-- 3. What seem to be the key drivers of customer churn?

select Offer, count(Offer) "Number of customers", Customer_Status
from telecom_customer_churn
group by Offer, Customer_Status
order by Offer, [Number of customers] desc;
/*
-----------------------------------------------------------------------------------------------------------------------------------------------
The Offers seem to be one of the key drivers of customer churn, in particular Offer E. More than half of the customers who had Offer E churned.
-----------------------------------------------------------------------------------------------------------------------------------------------
Offer                                              Number of customers Customer_Status
-------------------------------------------------- ------------------- --------------------------------------------------
None                                               2547                Stayed
None                                               1051                Churned
None                                               279                 Joined
Offer A                                            485                 Stayed
Offer A                                            35                  Churned
Offer B                                            723                 Stayed
Offer B                                            101                 Churned
Offer C                                            320                 Stayed
Offer C                                            95                  Churned
Offer D                                            441                 Stayed
Offer D                                            161                 Churned
Offer E                                            426                 Churned
Offer E                                            204                 Stayed
Offer E                                            175                 Joined
*/

with cte as (select Offer, count(Offer) "Number of customers", Customer_Status
             from telecom_customer_churn
             group by Offer, Customer_Status)
select cast(sum(cte."Number of customers") as decimal(10, 2)) / (select cast(sum(cte."Number of customers") as decimal(10, 2))
                                                                 from cte
																 where cte.Offer = 'Offer E') * 100 "Percent of Offer E customers churned"
from cte
where cte.Offer = 'Offer E'
and cte.Customer_Status = 'Churned';
/*
Here is the percentage of churn amongst Offer E customers.
----------------------------------------------------------
Percent of Offer E customers churned
---------------------------------------
52.9192546583800

----------------------------------------------
Over 52% of customers utilizing Offer E churn.
----------------------------------------------
*/

select Contract, count(Contract) "Num of customers", Customer_Status 
from telecom_customer_churn
group by Contract, Customer_Status
order by Contract, [Num of customers] desc;
/*
--------------------------------------------------------------------------------------------------------------------------------------------
Another key driver for customer churn is the Contract. We can see a large number of customers who were on a month-to-month contract churned.
--------------------------------------------------------------------------------------------------------------------------------------------
Contract                                           Num of customers Customer_Status
-------------------------------------------------- ---------------- --------------------------------------------------
Month-to-Month                                     1655             Churned
Month-to-Month                                     1547             Stayed
Month-to-Month                                     408              Joined
One Year                                           1360             Stayed
One Year                                           166              Churned
One Year                                           24               Joined
Two Year                                           1813             Stayed
Two Year                                           48               Churned
Two Year                                           22               Joined
*/

with cte as (select Contract, count(Contract) "Num of customers", Customer_Status 
             from telecom_customer_churn
             group by Contract, Customer_Status)
select cast(sum(cte."Num of customers") as decimal(10, 2)) / (select cast(sum(cte."Num of customers") as decimal(10,2)) 
                                                              from cte) * 100 "Percent of Month-to-Month customer churned"
from cte
where cte.Contract = 'Month-to-Month'
and cte.Customer_Status = 'Churned';
/*
Here is the percentage of churn for month-to-month customers amongst all contracts.
-----------------------------------------------------------------------------------
Percent of Month-to-Month customer churned
------------------------------------------
23.4985091580200

-------------------------------------------------------------
Over 23% of customer churn was from month-to-month contracts.
-------------------------------------------------------------
*/

with cte as (select Contract, count(Contract) "Num of customers", Customer_Status 
             from telecom_customer_churn
             group by Contract, Customer_Status)
select cast(sum(cte."Num of customers") as decimal(10, 2)) / (select cast(sum(cte."Num of customers") as decimal(10,2)) 
                                                              from cte
															  where cte.Contract = 'Month-to-Month') * 100 "Percent of Month-to-Month customer churned"
from cte
where cte.Contract = 'Month-to-Month'
and cte.Customer_Status = 'Churned';
/*
Here is the percentage of churn amongst month-to-month customers 
----------------------------------------------------------------
Percent of Month-to-Month customer churned
------------------------------------------
45.8448753462600

---------------------------------------------------------------
Over 45% of all customers on a month-to-month contract churned.
---------------------------------------------------------------
*/

-- 4. Is the company losing high value customers? If so, how can they retain them?
select a.Customer_Status,
       a."Customer Count",
	   a."Max Revenue",
	   a."Min Revenue",
	   a."Avg Revenue",
	   b.*
from (select Customer_Status,
		     count(Customer_Status) "Customer Count",
		     round(max(Total_Revenue), 2) "Max Revenue", 
		     round(min(Total_Revenue), 2) "Min Revenue", 
		     round(avg(Total_Revenue), 2) "Avg Revenue"
	  from telecom_customer_churn
	  group by Customer_Status) a,

	(select round(a."Customer Count" * a."Avg Revenue", 2) "Potential Revenue loss from Churned Customers"
	 from (select Customer_Status,
				  count(Customer_Status) "Customer Count",
				  max(Total_Revenue) "Max Revenue",
				  min(Total_Revenue) "Min Revenue",
				  avg(Total_Revenue) "Avg Revenue"
		   from telecom_customer_churn
		   group by Customer_Status) a
	 where a.Customer_Status = 'Churned') b
where a.Customer_Status = 'Churned';
/*
Customer_Status                                    Customer Count Max Revenue            Min Revenue            Avg Revenue            Potential Revenue loss from Churned Customers
-------------------------------------------------- -------------- ---------------------- ---------------------- ---------------------- ---------------------------------------------
Churned                                            1869           11195.44               21.61                  1971.35                3684459.82

--------------------------------------------------------------------------
The potential loss of revenue from all churned customers is $3,684,459.82.
--------------------------------------------------------------------------
*/

select a.Customer_Status,
       a."Customer Count",
	   a."Max Revenue of Offer E",
	   a."Min Revenue of Offer E",
	   a."Avg Revenue of Offer E", 
	   b.*
from (select Customer_Status,
		   count(Customer_Status) "Customer Count",
		   round(max(Total_Revenue), 2) "Max Revenue of Offer E", 
		   round(min(Total_Revenue), 2) "Min Revenue of Offer E", 
		   round(avg(Total_Revenue), 2) "Avg Revenue of Offer E"
	  from telecom_customer_churn
	  where Offer = 'Offer E'
	  group by Customer_Status) a,

	 (select round(o."Customer Count" * o."Avg Revenue of Offer E", 2) "Potential Revenue loss from Churned Customers"
	  from (select Customer_Status,
				 count(Customer_Status) "Customer Count",
				 max(Total_Revenue) "Max Revenue of Offer E", 
				 min(Total_Revenue) "Min Revenue of Offer E", 
				 avg(Total_Revenue) "Avg Revenue of Offer E"
		  from telecom_customer_churn
		  where Offer = 'Offer E'
		  group by Customer_Status) o
	  where o.Customer_Status = 'Churned') b
where a.Customer_Status = 'Churned';
/*
Customer_Status                                    Customer Count Max Revenue of Offer E Min Revenue of Offer E Avg Revenue of Offer E Potential Revenue loss from Churned Customers
-------------------------------------------------- -------------- ---------------------- ---------------------- ---------------------- ---------------------------------------------
Churned                                            426            1200.86                23.24                  283.45                 120751.68

------------------------------------------------------------------------------------
The potential loss of revenue for all churned customers with Offer E is $120,751.68.
------------------------------------------------------------------------------------
*/

select a."Customer_Status",
       a."Customer Count",
	   a.[Max Revenue of Month to Month Contract],
	   a.[Min Revenue of Month to Month Contract],
	   a.[Avg Revenue of Month to Month Contract],
	   b.[Potential Revenue loss from Churned Customers]
from (select Customer_Status,
		     count(Customer_Status) "Customer Count",
		     round(max(Total_Revenue), 2) "Max Revenue of Month to Month Contract", 
		     round(min(Total_Revenue), 2) "Min Revenue of Month to Month Contract", 
		     round(avg(Total_Revenue), 2) "Avg Revenue of Month to Month Contract"
	  from telecom_customer_churn
	  where Contract = 'Month-to-Month'
	  group by Customer_Status) a,

	 (select round(m."Customer Count" * m."Avg Revenue of Month to Month Contract", 2) "Potential Revenue loss from Churned Customers"
	  from (select Customer_Status,
				  count(Customer_Status) "Customer Count",
				  max(Total_Revenue) "Max Revenue of Month to Month Contract", 
				  min(Total_Revenue) "Min Revenue of Month to Month Contract", 
				  avg(Total_Revenue) "Avg Revenue of Month to Month Contract"
		    from telecom_customer_churn
		    where Contract = 'Month-to-Month'
		    group by Customer_Status) m
	   where m.Customer_Status = 'Churned') b
where a.Customer_Status = 'Churned';
/*
Customer_Status                                    Customer Count Max Revenue of Month to Month Contract Min Revenue of Month to Month Contract Avg Revenue of Month to Month Contract Potential Revenue loss from Churned Customers
-------------------------------------------------- -------------- -------------------------------------- -------------------------------------- -------------------------------------- ---------------------------------------------
Churned                                            1655           10718.96                               21.61                                  1504.6                                 2490105.85

----------------------------------------------------------------------------------------------------
The potential loss of revenue for churned customers with a month-to-month contract is $2,490,105.85.
----------------------------------------------------------------------------------------------------
*/

select a.Customer_Status,
       a.[Customer Count],
	   a.[Max Revenue of Offer E and Month to Month Contract], 
	   a.[Min Revenue of Offer E and Month to Month Contract], 
	   a.[Avg Revenue of Offer E and Month to Month Contract], 
	   b.[Potential Revenue loss from Churned Customers]
from (select Customer_Status,
		     count(Customer_Status) "Customer Count",
		     round(max(Total_Revenue), 2) "Max Revenue of Offer E and Month to Month Contract", 
		     round(min(Total_Revenue), 2) "Min Revenue of Offer E and Month to Month Contract", 
		     round(avg(Total_Revenue), 2) "Avg Revenue of Offer E and Month to Month Contract"
	  from telecom_customer_churn
	  where Contract = 'Month-to-Month'
	  and Offer = 'Offer E'
	  group by Customer_Status) a,

	 (select round(om."Customer Count" * om."Avg Revenue of Offer E and Month to Month Contract", 2) "Potential Revenue loss from Churned Customers"
	  from (select Customer_Status,
				   count(Customer_Status) "Customer Count",
				   max(Total_Revenue) "Max Revenue of Offer E and Month to Month Contract", 
				   min(Total_Revenue) "Min Revenue of Offer E and Month to Month Contract", 
				   avg(Total_Revenue) "Avg Revenue of Offer E and Month to Month Contract"
		   from telecom_customer_churn
		   where Contract = 'Month-to-Month'
		   and Offer = 'Offer E'
		   group by Customer_Status) om
	  where om.Customer_Status = 'Churned') b
where a.Customer_Status = 'Churned';
/*
Customer_Status                                    Customer Count Max Revenue of Offer E and Month to Month Contract Min Revenue of Offer E and Month to Month Contract Avg Revenue of Offer E and Month to Month Contract Potential Revenue loss from Churned Customers
-------------------------------------------------- -------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ---------------------------------------------
Churned                                            422            1200.86                                            23.24                                              282.77                                             119327.38

----------------------------------------------------------------------------------------------------------------
The potential revenue loss for churned customers with a month-to-month contract and with Offer E is $119,327.38.
----------------------------------------------------------------------------------------------------------------
*/

select *, round(c."Customer Count" * c."Avg Revenue", 2) "Potential Revenue loss from Churned Customers"
from (select Customer_Status, 
             count(Customer_Status) "Customer Count", 
	         Internet_Type,
			 round(max(Total_Revenue), 2) "Max Revenue",
	         round(min(Total_Revenue), 2) "Min Revenue", 
	         round(avg(Total_Revenue), 2) "Avg Revenue"
      from telecom_customer_churn
      group by Customer_Status, Internet_Type) c
where c.Customer_Status = 'Churned'
order by c.[Avg Revenue] desc;
/*
Customer_Status                                    Customer Count Internet_Type                                      Max Revenue            Min Revenue            Avg Revenue            Potential Revenue loss from Churned Customers
-------------------------------------------------- -------------- -------------------------------------------------- ---------------------- ---------------------- ---------------------- ---------------------------------------------
Churned                                            1236           Fiber Optic                                        11195.44               71.35                  2444.26                3021105.36
Churned                                            213            Cable                                              9411.65                24.45                  1445.04                307793.52
Churned                                            307            DSL                                                8295.69                23.45                  1017.75                312449.25
Churned                                            113            NULL                                               4005.02                21.61                  381.48                 43107.24

------------------------------------------------------------------------------------------------------
The potential loss of revenue for churned customers with a Fiber Optic internet type is $3,021,105.36.
------------------------------------------------------------------------------------------------------
*/

select *, round(c."Customer Count" * c."Avg Revenue", 2) "Potential Revenue loss from Churnrd Customers"
from (select Customer_Status, 
             count(Customer_Status) "Customer Count", 
	         Internet_Type,
			 round(max(Total_Revenue), 2) "Max Revenue",
	         round(min(Total_Revenue), 2) "Min Revenue", 
	         round(avg(Total_Revenue), 2) "Avg Revenue",
			 Offer, 
			 Contract
      from telecom_customer_churn
      group by Customer_Status, Internet_Type, Offer, Contract) c
where c.Customer_Status = 'Churned'
and c.Offer = 'Offer E'
and Contract = 'Month-to-Month'
order by c.[Avg Revenue] desc;
/*
Customer_Status                                    Customer Count Internet_Type                                      Max Revenue            Min Revenue            Avg Revenue            Offer                                              Contract                                           Potential Revenue loss from Churnrd Customers
-------------------------------------------------- -------------- -------------------------------------------------- ---------------------- ---------------------- ---------------------- -------------------------------------------------- -------------------------------------------------- ---------------------------------------------
Churned                                            236            Fiber Optic                                        1200.86                75.97                  368.5                  Offer E                                            Month-to-Month                                     86966
Churned                                            54             Cable                                              834.49                 24.8                   194.86                 Offer E                                            Month-to-Month                                     10522.44
Churned                                            89             DSL                                                1031.42                23.45                  193.61                 Offer E                                            Month-to-Month                                     17231.29
Churned                                            43             NULL                                               633.26                 23.24                  107.15                 Offer E                                            Month-to-Month                                     4607.45

-------------------------------------------------------------------------------------------------------------------------------------------------
The potential loss of revenue for customers who churned with a month-to-month contract, Offer E, and with a Fiber Optic internet type is $86,966.
-------------------------------------------------------------------------------------------------------------------------------------------------




RECOMMENDATIONS:

The company is losing a large number of high value customers with a Fiber Optic internet type. I would recommend trying to offer those customers a different internet type. There could also be some reason as to why those customers are dissatisfied 
with the Fiber Optice internet type such as performance, or maintenace. The potential loss of revenue from the churned customers with a Fiber Optic internet type is $3,021,105.36, which was calculated by multiplying the average total revenue from 
customers who churned with a Fiber Optic internet type by the number of customers who churned with a Fiber Optic internet type. 

The company is also losing a large number of high value customers with a month-to-month contract. I would recommend possibly getting rid of the month-to-month contracts and locking customers in with more long term contracts. The potential loss of
revenue for churned customers with a month-to-month contract is $2,490,105.85.

In order to retain these customers I would recommend abandoning month-to-month contracts, this would give customers more long term stability with the company. I would also recommend looking into the Fiber Optic service. Given the fact that Fiber 
Optics is a superior internet connection and so many customers are dissatisfied with it, perhaps there is trouble with the line. Otherwise, I would recommend upselling those customers a different internet type.

*/