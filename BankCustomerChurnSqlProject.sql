/* 
BANK CUSTOMER CHURN PROJECT

In this Sql project, I will be importing raw data of account information for 10,000 customers at a European bank, including details on their credit score, balance, products, and whether they have churned, into a created database.

RECOMMENDED ANALYSIS:

1. What attributes are more common among churners than non-churners? Can churn be predicted using the variables in the data?

2. What do overall demographics of the bank's customers look like?

3. Is there a difference between German, French, and Spanish customers in terms of account behavior?

4. What types of segments exist within the bank's customers?


Below is a description of the columns that I will be working with in the dataset.

Field                                              Description
----------------------------------------------------------------------------------------------------------------------------------------
CustomerId                                         A unique identifier for each customer
Surname                                            The customer's last name
CreditScore                                        A numerical value representing the customer's credit score
Geography                                          The country where the customer resides (France, Spain or Germany)
Gender                                             The customer's gender (Male or Female)
Age                                                The customer's age
Tenure                                             The number of years the customer has been with the bank
Balance                                            The customer's account balance
NumOfProducts                                      The number of bank products the customer uses (e.g., savings account, credit card)
HasCrCard                                          Whether the customer has a credit card (1 = yes, 0 = no)
IsActiveMember                                     Whether the customer is an active member (1 = yes, 0 = no)
EstimatedSalary                                    The estimated salary of the customer
Exited                                             Whether the customer has churned (1 = yes, 0 = no)

In order to get a better understanding of the data that I will be analyzing, I will inspect this data in the table by checking for any duplicate rows of data, checking the number of unique values in each column, as well as 
checking the number of null values in each column.

*/

-- DATA EXAMINATION:
-- Checking for duplicates --
select *
from (select *, row_number() over(partition by CustomerId order by CustomerId) "Duplicate rows of data"
      from Bank_Churn) d
where d.[Duplicate rows of data] = 2;
/*
CustomerId  Surname                                            CreditScore Geography                                          Gender                                             Age  Tenure Balance                NumOfProducts HasCrCard IsActiveMember EstimatedSalary        Exited Duplicate rows of data
----------- -------------------------------------------------- ----------- -------------------------------------------------- -------------------------------------------------- ---- ------ ---------------------- ------------- --------- -------------- ---------------------- ------ ----------------------

-----------------------------------------
This table has 0 rows of duplicated data.
-----------------------------------------
*/

-- Checking the number of unique values in each column --
select count(distinct CustomerId) "CustomerId" from Bank_Churn;
/*
CustomerId
-----------
10000
*/
select count(distinct Surname) "Surname" from Bank_Churn;
/*
Surname
-----------
2931
*/
select count(distinct CreditScore) "CreditScore" from Bank_Churn;
/*
CreditScore
-----------
460
*/
select count(distinct Geography) "Geography" from Bank_Churn;
/*
Geography
-----------
3
*/
select count(distinct Gender) "Gender" from Bank_Churn;
/*
Gender
-----------
2
*/
select count(distinct Age) "Age" from Bank_Churn;
/*
Age
-----------
70
*/
select count(distinct Tenure) "Age" from Bank_Churn;
/*
Age
-----------
11
*/
select count(distinct Balance) "Balance" from Bank_Churn;
/*
Balance
-----------
6382
*/
select count(distinct NumOfProducts) "NumOfProducts" from Bank_Churn;
/*
NumOfProducts
-------------
4
*/
select count(distinct HasCrCard) "HasCrCard" from Bank_Churn;
/*
HasCrCard
-----------
2
*/
select count(distinct IsActiveMember) "IsActiveMember" from Bank_Churn;
/*
IsActiveMember
--------------
2
*/
select count(distinct EstimatedSalary) "EstimatedSalary" from Bank_Churn;
/*
EstimatedSalary
---------------
9999
*/
select count(distinct Exited) "Exited" from Bank_Churn;
/*
Exited
-----------
2
*/

-- Checking the number of null values in each column --
select CustomerId from Bank_Churn where CustomerId is null;
/*
(0 rows affected)
*/
select Surname from Bank_Churn where Surname is null;
/*
(0 rows affected)
*/
select CreditScore from Bank_Churn where CreditScore is null;
/*
(0 rows affected)
*/
select Geography from Bank_Churn where Geography is null;
/*
(0 rows affected)
*/
select Gender from Bank_Churn where Gender is null;
/*
(0 rows affected)
*/
select Age from Bank_Churn where Age is null;
/*
(0 rows affected)
*/
select Tenure from Bank_Churn where Tenure is null;
/*
(0 rows affected)
*/
select Balance from Bank_Churn where Balance is null;
/*
(0 rows affected)
*/
select NumOfProducts from Bank_Churn where NumOfProducts is null;
/*
(0 rows affected)
*/
select HasCrCard from Bank_Churn where HasCrCard is null;
/*
(0 rows affected)
*/
select IsActiveMember from Bank_Churn where IsActiveMember is null;
/*
(0 rows affected)
*/
select EstimatedSalary from Bank_Churn where EstimatedSalary is null;
/*
(0 rows affected)
*/
select Exited from Bank_Churn where Exited is null;
/*
(0 rows affected)

---------------------------------------------------------
The data in this table, dbo.Bank_Churn has 0 null values.
---------------------------------------------------------
*/

/*
Now that the data has been examined, I will now move on to answering the questions associated with this project.

RECOMMENDED ANALYSIS:
*/
-- 1. a) What attributes are more common among churners than non-churners? 

-- Churners vs Non-Churners by Max/Min/Avg Credit Scores --
select  max(CreditScore) "Max credit score",
        min(CreditScore) "Min credit score", 
	avg(CreditScore) "Avg credit score", 
	Exited, 
	count(Exited) "Number of customers who churned",
		case 
			when Exited = 0 then 'No'
			when Exited = 1 then 'Yes'
		end as "Churned"
from Bank_Churn
group by Exited;
/*
Max credit score Min credit score Avg credit score Exited Number of customers who churned Churned
---------------- ---------------- ---------------- ------ ------------------------------- -------
850              405              651              0      7963                            No
850              350              645              1      2037                            Yes

------------------------------------------------------------------------------------------------------------
Customers who churn have a lower minimum and average credit score in comparison to customers who dont churn.
------------------------------------------------------------------------------------------------------------
*/
-- Percentage of Churners vs Non-Churners by Max/Min/Avg Credit Scores --
with percent_of_churn_by_credit_scores as (select max(CreditScore) "Max credit score",
                                                  min(CreditScore) "Min credit score", 
		                                  avg(CreditScore) "Avg credit score", 
		                                  Exited, 
		                                  count(Exited) "Number of customers who churned",
		                                  	case 
								when Exited = 0 then 'No'
			                                        when Exited = 1 then 'Yes'
		                                        end as "Churned"
                                           from Bank_Churn
                                           group by Exited)
select *, cast([Number of customers who churned] as decimal(10,2)) / (select cast(sum([Number of customers who churned]) as decimal(10,2))
                                                                      from percent_of_churn_by_credit_scores) * 100 "Percentage of churned customers by credit score"
from percent_of_churn_by_credit_scores
where Churned = 'Yes';
/*
Max credit score Min credit score Avg credit score Exited Number of customers who churned Churned Percentage of churned customers by credit score
---------------- ---------------- ---------------- ------ ------------------------------- ------- -----------------------------------------------
850              350              645              1      2037                            Yes     20.3700000000000

--------------------------------------------------------------------
The max/min/avg credit scores of all customers who churned is 20.3%.
--------------------------------------------------------------------
*/
-- Churners vs Non-Churners by Geography --
select Geography, 
       Exited, 
	count(Exited) "Number of customers who churned",
	   case 
	   	when Exited = 0 then 'No'
		when Exited = 1 then 'Yes'
	   end as "Churned"
from Bank_Churn
group by Geography,
         Exited
order by Geography;
/*
Geography                                          Exited Number of customers who churned Churned
-------------------------------------------------- ------ ------------------------------- -------
France                                             1      810                             Yes
France                                             0      4204                            No
Germany                                            1      814                             Yes
Germany                                            0      1695                            No
Spain                                              1      413                             Yes
Spain                                              0      2064                            No
*/
-- Percentage of Churners vs Non-Churners by Geography --
-- In France --
with churn_by_geo as (select Geography, 
                             Exited, 
	                     count(Exited) "Number of customers who churned",
	                           case 
					when Exited = 0 then 'No'
					when Exited = 1 then 'Yes'
		                   end as "Churned"
                      from Bank_Churn
                      group by Geography,
                      Exited)
select cast([Number of customers who churned] as decimal(10,2)) / (select cast(sum([Number of customers who churned]) as decimal(10,2))
                                                                   from churn_by_geo
								   where Geography = 'France') * 100 "Percentage of churners from France"
from churn_by_geo
where Geography = 'France'
and Churned = 'Yes'
order by Geography;
/*
Percentage of churners from France
---------------------------------------
16.1547666533700

---------------------------------------------------------------------------
The percentage of customers who churned in France is slightly above 16.15%.
---------------------------------------------------------------------------
*/
-- In Germany --
with churn_by_geo as (select Geography, 
                             Exited, 
	                     count(Exited) "Number of customers who churned",
	                           case 
					when Exited = 0 then 'No'
					when Exited = 1 then 'Yes'
		                   end as "Churned"
                      from Bank_Churn
                      group by Geography,
                      Exited)
select cast([Number of customers who churned] as decimal(10,2)) / (select cast(sum([Number of customers who churned]) as decimal(10,2))
                                                                   from churn_by_geo
								   where Geography = 'Germany') * 100 "Percentage of churners from Germany"
from churn_by_geo
where Geography = 'Germany'
and Churned = 'Yes'
order by Geography;
/*
Percentage of churners from Germany
---------------------------------------
32.4432044639200

--------------------------------------------------------------------
The percentage of customers who churned in Germany is around 32.44%.
--------------------------------------------------------------------
*/
-- In Spain --
with churn_by_geo as (select Geography, 
                             Exited, 
	                     count(Exited) "Number of customers who churned",
	                           case 
					when Exited = 0 then 'No'
					when Exited = 1 then 'Yes'
		                   end as "Churned"
                      from Bank_Churn
                      group by Geography,
                      Exited)
select cast([Number of customers who churned] as decimal(10,2)) / (select cast(sum([Number of customers who churned]) as decimal(10,2))
                                                                   from churn_by_geo
								   where Geography = 'Spain') * 100 "Percentage of churners from Spain"
from churn_by_geo
where Geography = 'Spain'
and Churned = 'Yes'
order by Geography;
/*
Percentage of churners from Spain
---------------------------------------
16.6733952361700

-----------------------------------------------------------
The percentage of customers who churned in Spain is 16.67%.
-----------------------------------------------------------
*/
-- Churn vs Non-Churn by Gender --
select Gender, 
       Exited, 
       count(Exited) "Number of customers who churned",
	   case 
		when Exited = 0 then 'No'
		when Exited = 1 then 'Yes'
	   end as "Churned"
from Bank_Churn
group by Gender, 
         Exited
order by Gender;
/*
Gender                                             Exited Number of customers who churned Churned
-------------------------------------------------- ------ ------------------------------- -------
Female                                             1      1139                            Yes
Female                                             0      3404                            No
Male                                               0      4559                            No
Male                                               1      898                             Yes
*/
-- Percentage of Female Churners vs Non-Churners --
with percentage_of_female_churners as (select Gender, 
                                              Exited, 
	                                      count(Exited) "Number of customers who churned",
						case 
						  when Exited = 0 then 'No'
			                          when Exited = 1 then 'Yes'
		                                end as "Churned"
                                       from Bank_Churn
                                       group by Gender, 
                                                Exited)
select cast([Number of customers who churned] as decimal(10,2)) / (select cast(sum([Number of customers who churned]) as decimal(10,2))
                                                                   from percentage_of_female_churners
								   where Gender = 'Female') * 100 "Percentage of Females who churned"
from percentage_of_female_churners
where Gender = 'Female'
and Churned = 'Yes';
/*
Percentage of Females who churned
---------------------------------------
25.0715386308600

---------------------------------
25.07% of female customers churn.
---------------------------------
*/
-- Percentage of Male Churners vs Non-Churners --
with percentage_of_male_churners as (select Gender, 
                                            Exited, 
	                                    count(Exited) "Number of customers who churned",
						case 
						   when Exited = 0 then 'No'
			                           when Exited = 1 then 'Yes'
		                                end as "Churned"
                                     from Bank_Churn
                                     group by Gender, 
                                              Exited)
select cast([Number of customers who churned] as decimal(10,2)) / (select cast(sum([Number of customers who churned]) as decimal(10,2))
                                                                   from percentage_of_male_churners
								   where Gender = 'Male') * 100 "Percentage of Males who churned"
from percentage_of_male_churners
where Gender = 'Male'
and Churned = 'Yes';
/*
Percentage of Males who churned
---------------------------------------
16.4559281656500

-------------------------------
16.45% of Male customers churn.
-------------------------------
*/
-- Churn vs Non-Churn by Age --
select max(Age) "Max age",
       min(Age) "Min age", 
       avg(Age) "Avg age", 
       Exited, 
       count(Exited) "Number of customers who churned",
	   case 
	   	when Exited = 0 then 'No'
		when Exited = 1 then 'Yes'
	   end as "Churned"
from Bank_Churn
group by Exited;
/*
Max age Min age Avg age     Exited Number of customers who churned Churned
------- ------- ----------- ------ ------------------------------- -------
92      18      37          0      7963                            No
84      18      44          1      2037                            Yes
*/
-- Churn vs Non-Churn by Tenure --
select max(Tenure) "Max years",
       min(Tenure) "Min years",
       avg(Tenure) "Avg years",
       Exited,
       count(Exited) "Number of customers who churned",
	   case 
	   	when Exited = 0 then 'No'
		when Exited = 1 then 'Yes'
	   end as "Churned"
from Bank_Churn
group by Exited;
/*
Max years Min years Avg years   Exited Number of customers who churned Churned
--------- --------- ----------- ------ ------------------------------- -------
10        0         5           0      7963                            No
10        0         4           1      2037                            Yes
*/
-- Churn vs Non-Churn by Balance --
select round(max(Balance), 2) "Max balance",
       round(min(Balance), 2) "Min balance",
       round(avg(Balance), 2) "Avg balance",
       Exited,
       count(Exited) "Number of customers who churned",
	   case 
		when Exited = 0 then 'No'
		when Exited = 1 then 'Yes'
	   end as "Churned"
from Bank_Churn
group by Exited;
/*
Max balance            Min balance            Avg balance            Exited Number of customers who churned Churned
---------------------- ---------------------- ---------------------- ------ ------------------------------- -------
221532.8               0                      72745.3                0      7963                            No
250898.09              0                      91108.54               1      2037                            Yes

--------------------------------------------------------------------------------------------------------
Customers who churn have a higher max balance at $250,898.09 amd a higher average balance at $91,108.54.
--------------------------------------------------------------------------------------------------------
*/
-- Churn vs Non-Churn by NumOfProducts --
select NumOfProducts, 
       Exited, 
       count(Exited) "Number of customers who churned",
	   case 
	     when Exited = 0 then 'No' 
	     when Exited = 1 then 'Yes'
	   end as "Churned"
from Bank_Churn
group by NumOfProducts,
         Exited
order by NumOfProducts;
/*
NumOfProducts Exited Number of customers who churned Churned
------------- ------ ------------------------------- -------
1             0      3675                            No
1             1      1409                            Yes
2             0      4242                            No
2             1      348                             Yes
3             1      220                             Yes
3             0      46                              No
4             1      60                              Yes
*/
-- Percentage of Churn vs Non-Churn by NumOfProducts --
-- Percentage of customers who churned with 1 Product --
with churn_by_num_of_products as (select NumOfProducts, 
	                                 Exited, 
	                                 count(Exited) "Number of customers who churned",
					    case 
						when Exited = 0 then 'No' 
			                        when Exited = 1 then 'Yes'
		                            end as "Churned"
                                  from Bank_Churn
                                  group by NumOfProducts,
                                           Exited)
select cast([Number of customers who churned] as decimal(10,2)) / (select cast(sum([Number of customers who churned]) as decimal(10,2))
                                                                   from churn_by_num_of_products
								   where NumOfProducts = 1) * 100 "Percentage of customers who churned with 1 product"
from churn_by_num_of_products
where Churned = 'Yes' 
and NumOfProducts = 1;
/*
Percentage of customers who churned with 1 product
--------------------------------------------------
27.7143981117200
*/
-- Percentage of customers who churned with 2 Product --
with churn_by_num_of_products as (select NumOfProducts, 
	                                 Exited, 
	                                 count(Exited) "Number of customers who churned",
					    case 
						when Exited = 0 then 'No' 
			                        when Exited = 1 then 'Yes'
		                            end as "Churned"
                                  from Bank_Churn
                                  group by NumOfProducts,
                                           Exited)
select cast([Number of customers who churned] as decimal(10,2)) / (select cast(sum([Number of customers who churned]) as decimal(10,2))
                                                                   from churn_by_num_of_products
								   where NumOfProducts = 2) * 100 "Percentage of customers who churned with 2 product"
from churn_by_num_of_products
where Churned = 'Yes' 
and NumOfProducts = 2;
/*
Percentage of customers who churned with 2 product
--------------------------------------------------
7.5816993464000
*/
-- Percentage of customers who churned with 3 Product --
with churn_by_num_of_products as (select NumOfProducts, 
	                                 Exited, 
	                                 count(Exited) "Number of customers who churned",
						case 
						   when Exited = 0 then 'No' 
			                           when Exited = 1 then 'Yes'
		                                end as "Churned"
                                  from Bank_Churn
                                  group by NumOfProducts,
                                           Exited)
select cast([Number of customers who churned] as decimal(10,2)) / (select cast(sum([Number of customers who churned]) as decimal(10,2))
                                                                   from churn_by_num_of_products
								   where NumOfProducts = 3) * 100 "Percentage of customers who churned with 3 product"
from churn_by_num_of_products
where Churned = 'Yes' 
and NumOfProducts = 3;
/*
Percentage of customers who churned with 3 product
--------------------------------------------------
82.7067669172900
*/
-- Churn vs Non-Churn by HasCrCard --
select HasCrCard, 
       Exited,
       count(Exited) "Number of customers who churned",
	   case
		when Exited = 0 then 'No'
		when Exited = 1 then 'Yes'
	   end as "Churned",
	   case 
		when HasCrCard = 0 then 'No'
		when HasCrCard = 1 then 'Yes'
	   end as "Credit Card"
from Bank_Churn
group by HasCrCard,
         Exited;
/*
HasCrCard Exited Number of customers who churned Churned Credit Card
--------- ------ ------------------------------- ------- -----------
0         0      2332                            No      No
0         1      613                             Yes     No
1         0      5631                            No      Yes
1         1      1424                            Yes     Yes
*/
-- Percentage of Churn vs Non-Churn by HasCrCard --
with credit_card_churn as (select HasCrCard, 
                           Exited,
	                   count(Exited) "Number of customers who churned",
				case
				   when Exited = 0 then 'No'
			           when Exited = 1 then 'Yes'
		                end as "Churned",
		                case 
			           when HasCrCard = 0 then 'No'
			           when HasCrCard = 1 then 'Yes'
		                end as "Credit Card"
                           from Bank_Churn
                           group by HasCrCard,
                                    Exited)
select cast([Number of customers who churned] as decimal(10,2)) / (select cast(sum([Number of customers who churned]) as decimal(10,2))
                                                                   from credit_card_churn
								   where [Credit Card] = 'Yes') * 100 "Percentage of customers who churned with credit card"
from credit_card_churn
where Churned = 'Yes'
and [Credit Card] = 'Yes';
/*
Percentage of customers who churned with credit card
----------------------------------------------------
20.1842664776700

-------------------------------------------------
20.18% of customers who had credit cards churned.
-------------------------------------------------
*/
with credit_card_churn as (select HasCrCard, 
                           Exited,
	                   count(Exited) "Number of customers who churned",
				case
				   when Exited = 0 then 'No'
			           when Exited = 1 then 'Yes'
		                end as "Churned",
		                case 
			           when HasCrCard = 0 then 'No'
			           when HasCrCard = 1 then 'Yes'
		                end as "Credit Card"
                           from Bank_Churn
                           group by HasCrCard,
                                    Exited)
select cast([Number of customers who churned] as decimal(10,2)) / (select cast(sum([Number of customers who churned]) as decimal(10,2))
                                                                   from credit_card_churn
								   where [Credit Card] = 'No') * 100 "Percentage of customers who churned with out credit card"
from credit_card_churn
where Churned = 'Yes'
and [Credit Card] = 'No';
/*
Percentage of customers who churned with out credit card
--------------------------------------------------------
20.8149405772400

------------------------------------------------------
20.81% of customers did not have credit cards churned.
------------------------------------------------------
*/
-- Churn vs Non-Churn by IsActiveMember --
select IsActiveMember,
       Exited ,
       count(Exited) "Number of customers who churned",
	   case 
	      when Exited = 0 then 'No'
	      when Exited = 1 then 'Yes'
	   end as "Churned",
	   case
	      when IsActiveMember = 0 then 'No'
	      when IsActiveMember = 1 then 'Yes'
	   end as "Active Member"
from Bank_Churn
group by IsActiveMember,
         Exited;
/*
IsActiveMember Exited Number of customers who churned Churned Active Member
-------------- ------ ------------------------------- ------- -------------
0              0      3547                            No      No
0              1      1302                            Yes     No
1              0      4416                            No      Yes
1              1      735                             Yes     Yes
*/
-- Percentage of Churn vs Non-Churn by IsActiveMember --
with churn_by_active_member as (select IsActiveMember,
                                       Exited ,
	                               count(Exited) "Number of customers who churned",
					 case 
					    when Exited = 0 then 'No'
			                    when Exited = 1 then 'Yes'
		                         end as "Churned",
		                         case
					    when IsActiveMember = 0 then 'No'
			                    when IsActiveMember = 1 then 'Yes'
		                         end as "Active Member"
                                from Bank_Churn
                                group by IsActiveMember,
                                         Exited)
select cast([Number of customers who churned] as decimal(10,2)) / (select cast(sum([Number of customers who churned]) as decimal(10,2))
                                                                   from churn_by_active_member
								   where [Active Member] = 'Yes') * 100 "Percentage of active members who churned"
from churn_by_active_member
where [Active Member] = 'Yes'
and Churned = 'Yes';
/*
Percentage of active members who churned
----------------------------------------
14.2690739662200

---------------------------------------------------------------------------
The percentage of customers that are active members that churned is 14.26%.
---------------------------------------------------------------------------
*/
with churn_by_active_member as (select IsActiveMember,
                                       Exited ,
	                               count(Exited) "Number of customers who churned",
				       	  case 
					  	when Exited = 0 then 'No'
			                        when Exited = 1 then 'Yes'
		                          end as "Churned",
		                          case
						when IsActiveMember = 0 then 'No'
			                        when IsActiveMember = 1 then 'Yes'
		                          end as "Active Member"
                                from Bank_Churn
                                group by IsActiveMember,
                                         Exited)
select cast([Number of customers who churned] as decimal(10,2)) / (select cast(sum([Number of customers who churned]) as decimal(10,2))
                                                                   from churn_by_active_member
								   where [Active Member] = 'No') * 100 "Percentage of non-active members who churned"
from churn_by_active_member
where [Active Member] = 'No'
and Churned = 'Yes';
/*
Percentage of non-active members who churned
--------------------------------------------
26.8508970921800

-------------------------------------------------------------------------------
The percentage of customers that are non-active members that churned is 26.85%.
-------------------------------------------------------------------------------
*/
-- Churn vs Non-Churn by Salary --
select round(max(EstimatedSalary), 2) "Max salary",
       round(min(EstimatedSalary), 2) "Min salary",
       round(avg(EstimatedSalary), 2) "Avg salary",
       Exited,
       count(Exited) "Number of customers who churned",
	   case
		when Exited = 0 then 'No'
		when Exited = 1 then 'Yes'
	   end as "Churned"
from Bank_Churn
group by Exited;
/*
Max salary             Min salary             Avg salary             Exited Number of customers who churned Churned
---------------------- ---------------------- ---------------------- ------ ------------------------------- -------
199992.48              90.07                  99738.39               0      7963                            No
199808.09              11.58                  101465.68              1      2037                            Yes

---------------------------------------------------------------------------------------------------------------
There is a big difference in the minimum salaries of customers who churn companred to customers who dont churn.
---------------------------------------------------------------------------------------------------------------

-- b) Can churn be predicted using the variables in the data?

Given the data, I believe that churn can be predicted by variables such as minimum wage, Geography, Gender, whether a customer is an active member or not, and the number of products a customer has. The data indicates that 
32% of customers in Germany have churned. The data also indicates that 25% of females customers have churned. 82% of all customers who churned have 3 products, which is a indication that that may be too much responsibility
for customers to handle. Lastly, 26% of customers who are not active members churn in comparinson to 14% of active members who churn.

*/
-- 2. What do overall demographics of the bank's customers look like?

-- Max/Min/Avg Credit Scores of customers --
select max(CreditScore) "Max Credit Score",
       min(CreditScore) "Min Credit Score",
       avg(CreditScore) "Avg Credit Score"
from Bank_Churn;
/*
Max Credit Score Min Credit Score Avg Credit Score
---------------- ---------------- ----------------
850              350              650
*/
-- Max/Min/Avg Credit Scores of customers by Gender --
select Gender,
       max(CreditScore) "Max Credit Score",
       min(CreditScore) "Min Credit Score",
       avg(CreditScore) "Avg Credit Score"
from Bank_Churn
group by Gender;
/*
Gender                                             Max Credit Score Min Credit Score Avg Credit Score
-------------------------------------------------- ---------------- ---------------- ----------------
Male                                               850              350              650
Female                                             850              350              650
*/
-- Number of Customers --
select count(CustomerId) "Number of customers"
from Bank_Churn;
/*
Number of customers
-------------------
10000
*/
-- Number of Customers by Gender --
select Gender, count(CustomerId) "Num of customers"
from Bank_Churn
group by Gender;
/*
Gender                                             Num of customers
-------------------------------------------------- ----------------
Male                                               5457
Female                                             4543
*/
-- Max/Min/Avg Age of Customers --
select max(Age) "Max Age", min(Age) "Min Age", avg(Age) "Avg Age"
from Bank_Churn;
/*
Max Age Min Age Avg Age
------- ------- -----------
92      18      38
*/
-- Max/Min/Avg Age of Customers by Gender --
select Gender, max(Age) "Max Age", min(Age) "Min Age", avg(Age) "Avg Age"
from Bank_Churn
group by Gender;
/*
Gender                                             Max Age Min Age Avg Age
-------------------------------------------------- ------- ------- -----------
Male                                               92      18      38
Female                                             85      18      39
*/
-- Max/Min/Avg Years Tenure --
select max(Tenure) "Max Years", min(Tenure) "Min Years", avg(Tenure) "Avg Years"
from Bank_Churn;
/*
Max Years Min Years Avg Years
--------- --------- -----------
10        0         5
*/
-- Max/Min/Avg Years Tenure by Gender --
select Gender, max(Tenure) "Max Years", min(Tenure) "Min Years", avg(Tenure) "Avg Years"
from Bank_Churn
group by Gender;
/*
Gender                                             Max Years Min Years Avg Years
-------------------------------------------------- --------- --------- -----------
Male                                               10        0         5
Female                                             10        0         4
*/
-- Max/Min/Avg Customer Balance --
select round(max(Balance), 2) "Max Balance", round(min(Balance), 2) "Min Balance", round(avg(Balance), 2) "Avg Balance"
from Bank_Churn;
/*
Max Balance            Min Balance            Avg Balance
---------------------- ---------------------- ----------------------
250898.09              0                      76485.89
*/
-- Max/Min/Avg Customer Balance by Gender --
select Gender, round(max(Balance), 2) "Max Balance", round(min(Balance), 2) "Min Balance", round(avg(Balance), 2) "Avg Balance"
from Bank_Churn
group by Gender;
/*
Gender                                             Max Balance            Min Balance            Avg Balance
-------------------------------------------------- ---------------------- ---------------------- ----------------------
Male                                               250898.09              0                      77173.97
Female                                             238387.56              0                      75659.37
*/
-- Number of Products per Customer --
select NumOfProducts, count(CustomerId) "Num of customers"
from Bank_Churn
group by NumOfProducts
order by NumOfProducts;
/*
NumOfProducts Num of customers
------------- ----------------
1             5084
2             4590
3             266
4             60
*/
-- Number of Products per Customer by Gender --
select Gender, NumOfProducts, count(CustomerId) "Num of customers"
from Bank_Churn
group by Gender, NumOfProducts
order by NumOfProducts;
/*
Gender                                             NumOfProducts Num of customers
-------------------------------------------------- ------------- ----------------
Female                                             1             2296
Male                                               1             2788
Female                                             2             2060
Male                                               2             2530
Female                                             3             149
Male                                               3             117
Female                                             4             38
Male                                               4             22
*/
-- Number of Customers who have Credit Card --
select HasCrCard, count(CustomerId) "Num of customers",
		case
		   when HasCrCard = 0 then 'No'
		   when HasCrCard = 1 then 'Yes'
		end as "Credit Card"
from Bank_Churn
group by HasCrCard;
/*
HasCrCard Num of customers Credit Card
--------- ---------------- -----------
0         2945             No
1         7055             Yes
*/
-- Number of Customers who have Credit Card by Gender --
select Gender, HasCrCard, count(CustomerId) "Num of customers",
		case 
		   when HasCrCard = 0 then 'No'
		   when HasCrCard = 1 then 'Yes'
		end as "Credit Card"
from Bank_Churn
group by Gender, HasCrCard;
/*
Gender                                             HasCrCard Num of customers Credit Card
-------------------------------------------------- --------- ---------------- -----------
Male                                               0         1594             No
Female                                             1         3192             Yes
Male                                               1         3863             Yes
Female                                             0         1351             No
*/
--Number of Customers who are Active --
select IsActiveMember, count(CustomerId) "Num of customers",
		case 
		   when IsActiveMember = 0 then 'No'
		   when IsActiveMember = 1 then 'Yes'
		end as "Active"
from Bank_Churn
group by IsActiveMember;
/*
IsActiveMember Num of customers Active
-------------- ---------------- ------
0              4849             No
1              5151             Yes
*/
-- Number of Customers who are Active by Gender --
select Gender, IsActiveMember, count(CustomerId) "Num of customers",
		case 
		   when IsActiveMember = 0 then 'No'
		   when IsActiveMember = 1 then 'Yes'
		end as "Active"
from Bank_Churn
group by Gender, IsActiveMember;
/*
Gender                                             IsActiveMember Num of customers Active
-------------------------------------------------- -------------- ---------------- ------
Male                                               0              2590             No
Female                                             1              2284             Yes
Male                                               1              2867             Yes
Female                                             0              2259             No
*/
-- Max/Min/Avg Salary for Customers --
select round(max(EstimatedSalary), 2) "Max Salary", round(min(EstimatedSalary), 2) "Min Salary", round(avg(EstimatedSalary), 2) "Avg Salary"
from Bank_Churn;
/*
Max Salary             Min Salary             Avg Salary
---------------------- ---------------------- ----------------------
199992.48              11.58                  100090.24
*/
-- Max/Min/Avg Salary for Customers by Gender --
select Gender, round(max(EstimatedSalary), 2) "Max Salary", round(min(EstimatedSalary), 2) "Min Salary", round(avg(EstimatedSalary), 2) "Avg Salary"
from Bank_Churn
group by Gender;
/*
Gender                                             Max Salary             Min Salary             Avg Salary
-------------------------------------------------- ---------------------- ---------------------- ----------------------
Male                                               199953.33              11.58                  99664.58
Female                                             199992.48              91.75                  100601.54
*/

-- 3. Is there a difference between German, French, and Spanish customers in terms of account behavior?

-- Number of Customers by Geography --
select Geography, count(CustomerId) "Num of customers"
from Bank_Churn
group by Geography;
/*
Geography                                          Num of customers
-------------------------------------------------- ----------------
Germany                                            2509
France                                             5014
Spain                                              2477
*/
-- Max/Min/Avg Credit Score by Geography --
select Geography, max(CreditScore) "Max Credit Score", min(CreditScore) "Min Credit Score", avg(CreditScore) "Avg Credit Score"
from Bank_Churn
group by Geography;
/*
Geography                                          Max Credit Score Min Credit Score Avg Credit Score
-------------------------------------------------- ---------------- ---------------- ----------------
Germany                                            850              350              651
France                                             850              350              649
Spain                                              850              350              651
*/
-- Max/Min/Avg Age of Customers by Geography --
select Geography, max(Age) "Max Age", min(Age) "Min Age", avg(Age) "Avg Age"
from Bank_Churn
group by Geography;
/*
Geography                                          Max Age Min Age Avg Age
-------------------------------------------------- ------- ------- -----------
Germany                                            84      18      39
France                                             92      18      38
Spain                                              88      18      38
*/
-- Max/Min/Avg Tenure of Customers by Geography --
select Geography, max(Tenure) "Max Years", min(Tenure) "Min Years", avg(Tenure) "Avg Age"
from Bank_Churn
group by Geography;
/*
Geography                                          Max Years Min Years Avg Age
-------------------------------------------------- --------- --------- -----------
Germany                                            10        0         5
France                                             10        0         5
Spain                                              10        0         5
*/
-- Max/Min/Avg Balance of Customers by Geography --
select Geography, round(max(Balance), 2) "Max Balance", round(min(Balance), 2) "Min Balance", round(avg(Balance), 2)"Avg Balance"
from Bank_Churn
group by Geography;
/*
Geography                                          Max Balance            Min Balance            Avg Balance
-------------------------------------------------- ---------------------- ---------------------- ----------------------
Germany                                            214346.95              27288.43               119730.12
France                                             238387.56              0                      62092.64
Spain                                              250898.09              0                      61818.15
*/
-- Number of Products Customer has by Geography --
select Geography, NumOfProducts, count(CustomerId) "Number of customers"
from Bank_Churn
group by Geography, NumOfProducts
order by NumOfProducts;
/*
Geography                                          NumOfProducts Number of customers
-------------------------------------------------- ------------- -------------------
Spain                                              1             1221
France                                             1             2514
Germany                                            1             1349
France                                             2             2367
Germany                                            2             1040
Spain                                              2             1183
Germany                                            3             96
France                                             3             104
Spain                                              3             66
Germany                                            4             24
France                                             4             29
Spain                                              4             7
*/
-- Number of Customers who have a Credit Card by Geography --
select Geography, HasCrCard, count(CustomerId) "Number of customers",
		case
		   when HasCrCard = 0 then 'No'
		   when HasCrCard = 1 then 'Yes'
		end as "Credit Card"
from Bank_Churn
group by Geography, HasCrCard
order by [Credit Card];
/*
Geography                                          HasCrCard Number of customers Credit Card
-------------------------------------------------- --------- ------------------- -----------
Germany                                            0         718                 No
France                                             0         1471                No
Spain                                              0         756                 No
France                                             1         3543                Yes
Germany                                            1         1791                Yes
Spain                                              1         1721                Yes
*/
-- Number of Customers who are Active Members by Geography --
select Geography, IsActiveMember, count(CustomerId) "Num of customers",
		case 
		   when IsActiveMember = 0 then 'Yes'
		   when IsActiveMember = 1 then 'No'
		end as "Active"
from Bank_Churn
group by Geography, IsActiveMember
order by Active;
/*
Geography                                          IsActiveMember Num of customers Active
-------------------------------------------------- -------------- ---------------- ------
France                                             1              2591             No
Germany                                            1              1248             No
Spain                                              1              1312             No
Germany                                            0              1261             Yes
France                                             0              2423             Yes
Spain                                              0              1165             Yes
*/
-- Max/Min/Avg Salary of Customers by Geography --
select Geography, round(max(EstimatedSalary), 2) "Max Salary", round(min(EstimatedSalary), 2) "Min Salary", round(avg(EstimatedSalary), 2) "Avg Salary"
from Bank_Churn
group by Geography;
/*
Geography                                          Max Salary             Min Salary             Avg Salary
-------------------------------------------------- ---------------------- ---------------------- ----------------------
Germany                                            199970.73              11.58                  101113.44
France                                             199929.17              90.07                  99899.18
Spain                                              199992.48              417.41                 99440.57
*/

/*
-- 4. What types of segments exist within the bank's customers?

The first type of segment that exist within this bank's customers are demographic, which include name, gender, and age. The last type of segment that exist in this bank's customers are geographic, which detail the countries that 
specific customers are located in.
*/
