select * from tx_deathrow

/* This dataset was retrieved from Kaggles website and is on Texas Deathrow inmates executed from 1976, when the death penalty was reinstated by the Supreme Court, to present.
   This is a public dataset created by Zi Chong Kao.
   I will clean the data up a bit and perform EDA for insights... */

-- DATA CLEANING --

-- Will create new columns to convert all datetime columns to date format --

-- Add new 'DateofBirth' column to dataset
ALTER TABLE tx_deathrow
ADD DateofBirth date;

-- Fill new 'DateofBirth' column with just the date info from the '[Date of Birth]' column
UPDATE tx_deathrow
SET DateofBirth = convert(date, [Date of Birth]);

-- Add new 'DateofOffence' column to dataset
ALTER TABLE tx_deathrow
ADD DateofOffence date;

-- Fill new 'DateofOffence' column with just the date info from the '[Date of Offence]' column
UPDATE tx_deathrow
SET DateofOffence = convert(date, [Date of Offence]);

-- Add new 'DateReceived' column to dataset
ALTER TABLE tx_deathrow
ADD DateReceived date;

-- Fill new 'DateReceived' column with just the date info from the '[Date Received]' column
UPDATE tx_deathrow
SET DateReceived = convert(date, [Date Received]);

-- Add new 'ExecutionDate' column with just the date info from the '[Execution Date]' column
ALTER TABLE tx_deathrow
ADD ExecutionDate date;

-- Fill new 'ExecutionDate' column with just the date info from the '[Execution Date]' column
UPDATE tx_deathrow
SET ExecutionDate = convert(date, [Execution Date]);

-- I will now drop the original columns that are in the datetime format
ALTER TABLE tx_deathrow
DROP COLUMN [Date of Birth], [Date of Offence], [Date Received], [Execution Date];

-- EDA --

-- Count of all executed inmates by Race
select Race, count(Race) "Race Count"
from tx_deathrow
group by Race;

-- The lowest education level of all executed inmates
select min([Highest Education Level]) "Lowest Education Level"
from tx_deathrow;

-- Number of inmates executed with the lowest education level (Used subquery to achieve output)
select count([Highest Education Level]) "Num of inmates"
from tx_deathrow
where [Highest Education Level] = all (select min([Highest Education Level])
                                       from tx_deathrow);

-- List of the executed inmates with the lowest education level	(Window Function along with cte used to achieve output)								   
with low_edu as (select *,
                        min([Highest Education Level])
						over(partition by [Highest Education Level] order by Execution desc) "lowest edu"
                 from tx_deathrow) 
select low_edu.*
from low_edu
where [lowest edu] = 3;

-- The highest education level of all executed inmates
select max([Highest Education Level]) "Higest Education Level"
from tx_deathrow;

-- Number of inmates executed with the highest education level (Used subquery to achieve output)
select count([Highest Education Level]) "Num of inmates"
from tx_deathrow
where [Highest Education Level] = all (select max([Highest Education Level])
                                       from tx_deathrow);

-- List of the executed inmates with the highest education level (Window Function along with subquery used to achieve output)
select *
from (select *,
             max([Highest Education Level]) 
			 over(partition by [Highest Education Level] order by Execution desc) "highest edu"
      from tx_deathrow) h
where h.[highest edu] = 20;

-- The average education level of all executed inmates
select avg([Highest Education Level]) "Average Education Level"
from tx_deathrow;

-- Number of inmates executed with the average education level (Subquery used to achieve output)
select count([Highest Education Level]) "Num of inmates"
from tx_deathrow
where [Highest Education Level] = all (select avg([Highest Education Level])
                                       from tx_deathrow
									   where [Highest Education Level] = 10);

-- List of the executed inmates with the average education level (Cte used to achieve output)
with avg_edu as (select *,
                        avg([Highest Education Level]) 
						over(partition by [Highest Education Level] order by Execution desc) "avg edu"
                 from tx_deathrow) 
select avg_edu.*
from avg_edu
where [avg edu] = 10;

-- The average/min/max ages of the executed inmates with the average education level
with avg_edu as (select *,
                        avg([Highest Education Level]) 
						over(partition by [Highest Education Level] order by Execution desc) "avg edu"
                 from tx_deathrow) 
select avg([Age at Execution]) "Avg Age of Execution",
       min([Age at Execution]) "Min Age of Execution",
	   max([Age at Execution]) "Max Age of Execution"
from avg_edu
where [avg edu] = 10;

-- Count of different races executed with the average education level
select distinct Race, count(Race) "Count"
from (select *, count(Race) over(partition by [Highest Education Level] order by Race) "Race Count"
      from tx_deathrow
      where Race in ('Black', 'White', 'Asian', 'Hispanic', 'Other')
      and [Highest Education Level] = 10) r
group by r.Race;

-- Percentage of races executed with the average education level
select p.*, P.Count / .88 "Percentage of Races"
from (select Race, count(Race) "Count"
      from tx_deathrow
      where Race in ('Black', 'White', 'Hispanic')
      and [Highest Education Level] = 10
      group by Race) p
group by p.Race, p.Count;

-- Count of different eye colors for inmates with an average education level
select [Eye Color], count([Eye Color]) "Count of Eye Colors"
from tx_deathrow
where [Highest Education Level] = 10
group by [Eye Color];

-- Percentage of the executed with different eye colors with an average education level
select e.*, e.[Count of Eye Colors] / .88 " Percentage of Eye Colors"
from (select [Eye Color], count([Eye Color]) "Count of Eye Colors"
      from tx_deathrow
      where [Highest Education Level] = 10
      group by [Eye Color]) e;

-- The avg/min/max weight of inmates by race executed with the average education level
select Race, avg(Weight) "Avg Weight", min(Weight) "Min Weight", max(Weight) "Max Weight"
from tx_deathrow
where [Highest Education Level] = 10
group by Race;

-- The avg/min/max weight of all inmates executed by race regardless of education level
select Race, avg(Weight) "Avg Weight", min(Weight) "Min Weight", max(Weight) "Max Weight"
from tx_deathrow
group by Race;

-- The avg/min/max weight of all inmates executed 
select avg(Weight) "Avg Weight", min(Weight) "Min Weight", max(Weight) "Max Weight"
from tx_deathrow;

-- The avg/min/max birth year of inmates by race executed with the average education level
select Race, avg(year(DateofBirth)) "Avg Birth Year", min(year(DateofBirth)) "Min Birth Year", max(year(DateofBirth)) "Max Birth Year"
from tx_deathrow
where [Highest Education Level] = 10
group by Race;

-- The avg/min/max birth year of all inmates executed by race regardless of education level
select Race, avg(year(DateofBirth)) "Avg Birth Year", min(year(DateofBirth)) "Min Birth Year", max(year(DateofBirth)) "Max Birth Year"
from tx_deathrow
group by Race;

-- The avg/min/max birth year of all inmates executed
select avg(year(DateofBirth)) "Avg Birth Year", min(year(DateofBirth)) "Min Birth Year", max(year(DateofBirth)) "Max Birth Year"
from tx_deathrow;

-- The avg/min/max offence year of inmates by race executed with the average education level
select Race, avg(year(DateofOffence)) "Avg Offence Year", min(year(DateofOffence)) "Min Offence Year", max(year(DateofOffence)) "Max Offence Year"
from tx_deathrow
where [Highest Education Level] = 10
group by Race;

-- The avg/min/max offence year of all inmates executed by race regardless of education level
select Race, avg(year(DateofOffence)) "Avg Offence Year", min(year(DateofOffence)) "Min Offence Year", max(year(DateofOffence)) "Max Offence Year"
from tx_deathrow
group by Race;

-- The avg/min/max offence year of all inmates executed
select avg(year(DateofOffence)) "Avg Offence Year", min(year(DateofOffence)) "Min Offence Year", max(year(DateofOffence)) "Max Offence Year"
from tx_deathrow

-- The avg/min/max received year of inmates by race executed with the average education level
select Race, avg(year(DateReceived)) "Avg Received Year", min(year(DateReceived)) "Min Received Year", max(year(DateReceived)) "Max Received Year"
from tx_deathrow
where [Highest Education Level] = 10
group by Race;

-- The avg/min/max received year of all inmates executed by race regardless of education level
select Race, avg(year(DateReceived)) "Avg Received Year", min(year(DateReceived)) "Min Received Year", max(year(DateReceived)) "Max Received Year"
from tx_deathrow
group by Race;

-- The avg/min/max received year of all inmates executed
select avg(year(DateReceived)) "Avg Received Year", min(year(DateReceived)) "Min Received Year", max(year(DateReceived)) "Max Received Year"
from tx_deathrow



-- The avg/min/max execution year of inmates by race executed with the average education level
select Race, avg(year(ExecutionDate)) "Avg Execution Year", min(year(ExecutionDate)) "Min Execution Year", max(year(ExecutionDate)) "Max Execution Year"
from tx_deathrow
where [Highest Education Level] = 10
group by Race;

-- The avg/min/max execution year of all inmates executed by race regardless of education level
select Race, avg(year(ExecutionDate)) "Avg Execution Year", min(year(ExecutionDate)) "Min Execution Year", max(year(ExecutionDate)) "Max Execution Year"
from tx_deathrow
group by Race;

-- The avg/min/max execution year of all inmates executed
select avg(year(ExecutionDate)) "Avg Execution Year", min(year(ExecutionDate)) "Min Execution Year", max(year(ExecutionDate)) "Max Execution Year"
from tx_deathrow

-- The avg years spent on death row before execution by race with the average education level
select Race, avg(year(ExecutionDate)) - avg(year(DateReceived)) "Avg Years on DR before Execution"
from tx_deathrow
where [Highest Education Level] = 10
group by Race;

-- Most years spent on death row before execution by race with the average education level
with most_yrs_spent as (select Race,
                               [First Name],
	                           [Last Name],
	                           max(year(ExecutionDate)) - max(year(DateReceived)) "Years on DR before Execution",
	                           row_number() over(partition by Race order by max(year(ExecutionDate)) - max(year(DateReceived)) desc) "RN"
                        from tx_deathrow
                        where [Highest Education Level] = 10
                        group by Race, [First Name], [Last Name])
select most_yrs_spent.*
from most_yrs_spent
where RN = 1;

-- Most years spent of death row before execution by race regardless of education
select *
from (select Race,
             [First Name],
	         [Last Name],
	         max(year(ExecutionDate)) - max(year(DateReceived)) "Years on DR before Execution",
	         row_number() over(partition by Race order by max(year(ExecutionDate)) - max(year(DateReceived)) desc) "RN"
      from tx_deathrow
      group by Race, [First Name], [Last Name]) m
where m.RN = 1;

-- Most years spent on death row before execution by all inmates regardless of education or race
select *
from (select [First Name],
	         [Last Name],
	         max(year(ExecutionDate)) - max(year(DateReceived)) "Years on DR before Execution",
	         row_number() over(order by max(year(ExecutionDate)) - max(year(DateReceived)) desc) "RN"
      from tx_deathrow
      group by [First Name], [Last Name]) m
where m.RN = 1;

-- Least years spent on death row before execution by race with the average education level
with least_yrs_spent as (select Race,
                               [First Name],
	                           [Last Name],
	                           max(year(ExecutionDate)) - max(year(DateReceived)) "Years on DR before Execution",
	                           row_number() over(partition by Race order by max(year(ExecutionDate)) - max(year(DateReceived)) asc) "RN"
                        from tx_deathrow
                        where [Highest Education Level] = 10
                        group by Race, [First Name], [Last Name])
select least_yrs_spent.*
from least_yrs_spent
where RN = 1;

-- Least years spent of death row before execution by race regardless of education
select *
from (select Race,
             [First Name],
	         [Last Name],
	         max(year(ExecutionDate)) - max(year(DateReceived)) "Years on DR before Execution",
	         row_number() over(partition by Race order by max(year(ExecutionDate)) - max(year(DateReceived)) asc) "RN"
      from tx_deathrow
      group by Race, [First Name], [Last Name]
	  having max(year(ExecutionDate)) - max(year(DateReceived)) is not null) l
where l.RN = 1;

-- Least years spent on death row before execution by all inmates regardless of education or race
select *
from (select [First Name],
	         [Last Name],
	         max(year(ExecutionDate)) - max(year(DateReceived)) "Years on DR before Execution",
	         row_number() over(order by max(year(ExecutionDate)) - max(year(DateReceived)) asc) "RN"
      from tx_deathrow
      group by [First Name], [Last Name]
	  having max(year(ExecutionDate)) - max(year(DateReceived)) is not null) l
where l.RN = 1;

-- LOOKING INTO LAST STATEMENTS THAT ARE APOLOGETIC IN NATURE (Any statements with sorry associated in them)

-- Count of apologetic last statements by race
select Race, count([Last Statement]) "Num of Apologetic Last Statements"
from tx_deathrow
where [Last Statement] like '%sorry%'
group by Race;

-- List of apologetic last statements by race
select Race, [Last Statement] "List of Apologetic Last Statements"
from tx_deathrow
where [Last Statement] like '%sorry%'
group by Race, [Last Statement];

-- Count of innocent proclamation statements by race
select Race, count([Last Statement]) "Num of Innocent Last Statements"
from tx_deathrow
where [Last Statement] like '%innocent%'
group by Race;

--List of innocent proclamation statements by race
select Race, [Last Statement] "List of Innocent Last Statements"
from tx_deathrow
where [Last Statement] like 'innocent%'
group by Race, [Last Name];
