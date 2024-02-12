/* 
This is a dataset on Chicago traffic crashes and was retrieved from the Kaggle website. This dataset consist of 
accident related data from the years 2015 through 2023. In this SQL project, I will write code to answer the questions
below:

1) Total fatal injuries?
2) Total incapacitating injures?
3) Total non-incapacitating injuries?
4) Total injuries and percentage of total with respect to most severe injury?
5) Maximum injuries by roadway surface condition?
6) Monthly trend showing comparison of injuries for current year and previous year?
7) Maximum injuries by first crash type for current year?
8) Distribution of total injuries by damage?
9) Relation between fatal injuries by crash type?

The results of the queries will be used to validate a PowerBI dashboard that will visualize the results from this
query.

Before I begin, I will first check if the dataset needs any data cleaning. This could consist of checking for and 
removing any duplicated rows of data, correcting any spelling errors and checking for and removing null values.

Finall, I will conduct some data processing. This would consist of potentially creating calculated columns as well as
creating a year and month column to help with providing insights.
*/

--select top 5 * from ChicagoTrafficCrashes

--Lets check for any duplicated rows of data:
select d.*
from (select *, row_number() over(partition by CRASH_RECORD_ID order by CRASH_RECORD_ID) "duplicated data"
      from ChicagoTrafficCrashes) d
where d.[duplicated data] = 2;

/* This bit of code utilizes the Window Function Row_Number to create a column that numbers all distinct rows.
By adding the where clause, it will check to see if that row is duplicated */
-- (There are no duplicated rows in this dataset.) --

-- Now I will check for any null values within our dataset: 
--select *
--from ChicagoTrafficCrashes
--where REPORT_TYPE is null;

--select *
--from ChicagoTrafficCrashes
--where STREET_DIRECTION is null;

--select *
--from ChicagoTrafficCrashes
--where BEAT_OF_OCCURRENCE is null;

--select *
--from ChicagoTrafficCrashes
--where MOST_SEVERE_INJURY is null;

--select *
--from ChicagoTrafficCrashes
--where INJURIES_TOTAL is null;

--select *
--from ChicagoTrafficCrashes
--where INJURIES_FATAL is null;

--select *
--from ChicagoTrafficCrashes
--where INJURIES_INCAPACITATING is null;

--select *
--from ChicagoTrafficCrashes
--where INJURIES_NON_INCAPACITATING is null;

--select *
--from ChicagoTrafficCrashes
--where INJURIES_REPORTED_NOT_EVIDENT is null;

--select *
--from ChicagoTrafficCrashes
--where INJURIES_NO_INDICATION is null;

--select *
--from ChicagoTrafficCrashes
--where INJURIES_UNKNOWN is null;

/* So there are a quite a few columns that have null values in them. In this situation I will remove the null values
from the dataset. If not, I risk distorting the results of analysis. */
--Delete From ChicagoTrafficCrashes
--Where REPORT_TYPE is null;

--Delete From ChicagoTrafficCrashes
--Where STREET_DIRECTION is null;

--Delete From ChicagoTrafficCrashes
--Where BEAT_OF_OCCURRENCE is null;

--Delete From ChicagoTrafficCrashes
--Where REPORT_TYPE is null;

--Delete From ChicagoTrafficCrashes

--Where MOST_SEVERE_INJURY is null;
/* Perfect, now all of the rows with null values have been removed from the dataset. */

/* Now I will proceed with data processing: (In this case, I can use different functions to extract the info needed.)
such as; year, month, day, and number of minutes. */

-- How many accidents were there by year?
select count(CRASH_RECORD_ID) "NUM_OF_ACCIDENTS", 
       year(CRASH_DATE) "ACCIDENT_YEAR"
from ChicagoTrafficCrashes
group by year(CRASH_DATE) 
order by NUM_OF_ACCIDENTS desc;

-- How many fatal accidents were there by year?
select count(CRASH_RECORD_ID) "NUM_OF_FATAL_ACCIDENTS",
       year(CRASH_DATE) "ACCIDENT_YEAR"
from ChicagoTrafficCrashes
where INJURIES_FATAL >= 1
group by year(CRASH_DATE)
order by NUM_OF_FATAL_ACCIDENTS desc;

-- How many incapacitating accidents were there by year?
select count(CRASH_RECORD_ID) "NUM_OF_INJURIES_INCAPACITATING_ACCIDENTS",
       year(CRASH_DATE) "ACCIDENT_YEAR"
from ChicagoTrafficCrashes
where INJURIES_INCAPACITATING >= 1
group by year(CRASH_DATE)
order by NUM_OF_INJURIES_INCAPACITATING_ACCIDENTS desc;

-- How many non-incapacitating accidents were there by year?
select count(CRASH_RECORD_ID) "NUM_OF_INJURIES_NON_INCAPACITATING_ACCIDENTS",
       year(CRASH_DATE) "ACCIDENT_YEAR"
from ChicagoTrafficCrashes
where INJURIES_NON_INCAPACITATING >= 1
group by year(CRASH_DATE)
order by NUM_OF_INJURIES_NON_INCAPACITATING_ACCIDENTS desc;

-- How many accidents were there by month?
select m.NUM_OF_ACCIDENTS,
	case when m."MONTH" = 1 then 'January'
		 when m."MONTH" = 2 then 'Feburary'
		 when m."MONTH" = 3 then 'March'
		 when m."MONTH" = 4 then 'April'
		 when m."MONTH" = 5 then 'May'
		 when m."MONTH" = 6 then 'June'
		 when m."MONTH" = 7 then 'July'
		 when m."MONTH" = 8 then 'August'
		 when m."MONTH" = 9 then 'September'
		 when m."MONTH" = 10 then 'October'
		 when m."MONTH" = 11 then 'November'
		 when m."MONTH" = 12 then 'December'
	end as "MONTH_NAMES"
from (select count(CRASH_RECORD_ID) "NUM_OF_ACCIDENTS",
             datepart(month, CRASH_DATE) "MONTH"
      from ChicagoTrafficCrashes
      group by datepart(month, CRASH_DATE)) m
order by "NUM_OF_ACCIDENTS" desc;

-- How many fatal accidents were there by month?
select m.NUM_OF_FATAL_ACCIDENTS,
	case when m."MONTH" = 1 then 'January'
		 when m."MONTH" = 2 then 'Feburary'
		 when m."MONTH" = 3 then 'March'
		 when m."MONTH" = 4 then 'April'
		 when m."MONTH" = 5 then 'May'
		 when m."MONTH" = 6 then 'June'
		 when m."MONTH" = 7 then 'July'
		 when m."MONTH" = 8 then 'August'
		 when m."MONTH" = 9 then 'September'
		 when m."MONTH" = 10 then 'October'
		 when m."MONTH" = 11 then 'November'
		 when m."MONTH" = 12 then 'December'
	end as "MONTH_NAMES"
from (select count(CRASH_RECORD_ID) "NUM_OF_FATAL_ACCIDENTS",
             datepart(month, CRASH_DATE) "MONTH"
      from ChicagoTrafficCrashes
	  where INJURIES_FATAL >= 1
      group by datepart(month, CRASH_DATE)) m
order by "NUM_OF_FATAL_ACCIDENTS" desc;

-- How many incapacitating accidents were there by month?
select m.NUM_OF_INJURIES_INCAPACITATING_ACCIDENTS,
	case when m."MONTH" = 1 then 'January'
		 when m."MONTH" = 2 then 'Feburary'
		 when m."MONTH" = 3 then 'March'
		 when m."MONTH" = 4 then 'April'
		 when m."MONTH" = 5 then 'May'
		 when m."MONTH" = 6 then 'June'
		 when m."MONTH" = 7 then 'July'
		 when m."MONTH" = 8 then 'August'
		 when m."MONTH" = 9 then 'September'
		 when m."MONTH" = 10 then 'October'
		 when m."MONTH" = 11 then 'November'
		 when m."MONTH" = 12 then 'December'
	end as "MONTH_NAMES"
from (select count(CRASH_RECORD_ID) "NUM_OF_INJURIES_INCAPACITATING_ACCIDENTS",
             datepart(month, CRASH_DATE) "MONTH"
      from ChicagoTrafficCrashes
	  where INJURIES_INCAPACITATING >= 1
      group by datepart(month, CRASH_DATE)) m
order by "NUM_OF_INJURIES_INCAPACITATING_ACCIDENTS" desc;

-- How many non-incapacitating accidents were there by month?
select m.NUM_OF_INJURIES_NON_INCAPACITATING_ACCIDENTS,
	case when m."MONTH" = 1 then 'January'
		 when m."MONTH" = 2 then 'Feburary'
		 when m."MONTH" = 3 then 'March'
		 when m."MONTH" = 4 then 'April'
		 when m."MONTH" = 5 then 'May'
		 when m."MONTH" = 6 then 'June'
		 when m."MONTH" = 7 then 'July'
		 when m."MONTH" = 8 then 'August'
		 when m."MONTH" = 9 then 'September'
		 when m."MONTH" = 10 then 'October'
		 when m."MONTH" = 11 then 'November'
		 when m."MONTH" = 12 then 'December'
	end as "MONTH_NAMES"
from (select count(CRASH_RECORD_ID) "NUM_OF_INJURIES_NON_INCAPACITATING_ACCIDENTS",
             datepart(month, CRASH_DATE) "MONTH"
      from ChicagoTrafficCrashes
	  where INJURIES_NON_INCAPACITATING >= 1
      group by datepart(month, CRASH_DATE)) m
order by "NUM_OF_INJURIES_NON_INCAPACITATING_ACCIDENTS" desc;

-- How many accidents were there by day?
select count(CRASH_RECORD_ID) "NUM_OF_ACCIDENTS",
       datename(dw, CRASH_DATE) "ACCIDENT_DAY"
from ChicagoTrafficCrashes
group by datename(dw, CRASH_DATE) 
order by "NUM_OF_ACCIDENTS" desc;

-- On average, how long did it take for the police to be notified from the time of a accident?
select avg(datediff(minute, CRASH_DATE, DATE_POLICE_NOTIFIED)) "AVG_MINS_FOR_POLICE_TO_BE_NOTIFIED"
from ChicagoTrafficCrashes;

-- What was the average time it took for police to be notified from the time of a fatal injury?
select avg(datediff(minute, CRASH_DATE, DATE_POLICE_NOTIFIED)) "AVG_MINS_FOR_POLICE_TO_BE_NOTIFIED"
from ChicagoTrafficCrashes
where INJURIES_FATAL >= 1;

-- What was the maximum time it took for police to be notified from the time of a accident?
select max(datediff(minute, CRASH_DATE, DATE_POLICE_NOTIFIED)) "MAX_MINS_FOR_POLICE_TO_BE_NOTIFIED"
from ChicagoTrafficCrashes;

-- What was the maximum time it took for police to be notified from the time of a incapacitating related injury?
select max(datediff(minute, CRASH_DATE, DATE_POLICE_NOTIFIED)) "MAX_MINS_FOR_POLICE_TO_BE_NOTIFIED"
from ChicagoTrafficCrashes
where INJURIES_INCAPACITATING >= 1;

-- How many total fatal injuries were there?
select sum(INJURIES_FATAL) "TOTAL_FATAL_INJURIES"
from ChicagoTrafficCrashes;

-- How many total incapacitating injuries were there?
select sum(INJURIES_INCAPACITATING) "TOTAL_INCAPACITATING_INJURIES"
from ChicagoTrafficCrashes;

-- How many total non-incapacitating injuries were there?
select sum(INJURIES_NON_INCAPACITATING) "TOTAL_NON_INCAPACITATING_INJURIES"
from ChicagoTrafficCrashes;

-- How many total injuries were there in respect to the most severe injuries?
select sum(INJURIES_TOTAL) "TOTAL_INJURIES",
       MOST_SEVERE_INJURY
from ChicagoTrafficCrashes
group by MOST_SEVERE_INJURY
order by TOTAL_INJURIES desc;

-- Whats the maximum amount of injuries by roadway surface condition?
select max(INJURIES_TOTAL) "MAX_INJURIES",
       ROADWAY_SURFACE_COND
from ChicagoTrafficCrashes
group by ROADWAY_SURFACE_COND;

-- Whats the year over year growth for total injuries?
select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "24/23 YOY GROWTH FOR INJURIES"
from (select cast(sum(INJURIES_TOTAL) as decimal(10, 2)) - (select cast(sum(INJURIES_TOTAL) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2023') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2024') cy, 
      (select cast(sum(INJURIES_TOTAL) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2023') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "23/22 YOY GROWTH FOR INJURIES"
from (select cast(sum(INJURIES_TOTAL) as decimal(10, 2)) - (select cast(sum(INJURIES_TOTAL) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2022') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2023') cy, 
      (select cast(sum(INJURIES_TOTAL) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2022') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "22/21 YOY GROWTH FOR INJURIES"
from (select cast(sum(INJURIES_TOTAL) as decimal(10, 2)) - (select cast(sum(INJURIES_TOTAL) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2021') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2022') cy, 
      (select cast(sum(INJURIES_TOTAL) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2021') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "21/20 YOY GROWTH FOR INJURIES"
from (select cast(sum(INJURIES_TOTAL) as decimal(10, 2)) - (select cast(sum(INJURIES_TOTAL) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2020') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2021') cy, 
      (select cast(sum(INJURIES_TOTAL) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2020') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "20/19 YOY GROWTH FOR INJURIES"
from (select cast(sum(INJURIES_TOTAL) as decimal(10, 2)) - (select cast(sum(INJURIES_TOTAL) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2019') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2020') cy, 
      (select cast(sum(INJURIES_TOTAL) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2019') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "19/18 YOY GROWTH FOR INJURIES"
from (select cast(sum(INJURIES_TOTAL) as decimal(10, 2)) - (select cast(sum(INJURIES_TOTAL) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2018') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2019') cy, 
      (select cast(sum(INJURIES_TOTAL) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2018') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "18/17 YOY GROWTH FOR INJURIES"
from (select cast(sum(INJURIES_TOTAL) as decimal(10, 2)) - (select cast(sum(INJURIES_TOTAL) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2017') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2018') cy, 
      (select cast(sum(INJURIES_TOTAL) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2017') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "17/16 YOY GROWTH FOR INJURIES"
from (select cast(sum(INJURIES_TOTAL) as decimal(10, 2)) - (select cast(sum(INJURIES_TOTAL) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2016') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2017') cy, 
      (select cast(sum(INJURIES_TOTAL) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2016') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "16/15 YOY GROWTH FOR INJURIES"
from (select cast(sum(INJURIES_TOTAL) as decimal(10, 2)) - (select cast(sum(INJURIES_TOTAL) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2015') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2016') cy, 
      (select cast(sum(INJURIES_TOTAL) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2015') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "15/14 YOY GROWTH FOR INJURIES"
from (select cast(sum(INJURIES_TOTAL) as decimal(10, 2)) - (select cast(sum(INJURIES_TOTAL) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2014') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2015') cy, 
      (select cast(sum(INJURIES_TOTAL) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2014') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "14/13 YOY GROWTH FOR INJURIES"
from (select cast(sum(INJURIES_TOTAL) as decimal(10, 2)) - (select cast(sum(INJURIES_TOTAL) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2013') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2014') cy, 
      (select cast(sum(INJURIES_TOTAL) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2013') py;
													  
-- Whats the year over year growth for fatal injuries?
select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "24/23 YOY GROWTH FOR FATAL INJURIES"
from (select cast(sum(INJURIES_FATAL) as decimal(10, 2)) - (select cast(sum(INJURIES_FATAL) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2023') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2024') cy, 
      (select cast(sum(INJURIES_FATAL) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2023') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "23/22 YOY GROWTH FOR FATAL INJURIES"
from (select cast(sum(INJURIES_FATAL) as decimal(10, 2)) - (select cast(sum(INJURIES_FATAL) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2022') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2023') cy, 
      (select cast(sum(INJURIES_FATAL) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2022') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "22/21 YOY GROWTH FOR FATAL INJURIES"
from (select cast(sum(INJURIES_FATAL) as decimal(10, 2)) - (select cast(sum(INJURIES_FATAL) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2021') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2022') cy, 
      (select cast(sum(INJURIES_FATAL) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2021') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "21/20 YOY GROWTH FOR FATAL INJURIES"
from (select cast(sum(INJURIES_FATAL) as decimal(10, 2)) - (select cast(sum(INJURIES_FATAL) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2020') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2021') cy, 
      (select cast(sum(INJURIES_FATAL) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2020') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "20/19 YOY GROWTH FOR FATAL INJURIES"
from (select cast(sum(INJURIES_FATAL) as decimal(10, 2)) - (select cast(sum(INJURIES_FATAL) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2019') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2020') cy, 
      (select cast(sum(INJURIES_FATAL) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2019') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "19/18 YOY GROWTH FOR FATAL INJURIES"
from (select cast(sum(INJURIES_FATAL) as decimal(10, 2)) - (select cast(sum(INJURIES_FATAL) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2018') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2019') cy, 
      (select cast(sum(INJURIES_FATAL) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2018') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "18/17 YOY GROWTH FOR FATAL INJURIES"
from (select cast(sum(INJURIES_FATAL) as decimal(10, 2)) - (select cast(sum(INJURIES_FATAL) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2017') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2018') cy, 
      (select cast(sum(INJURIES_FATAL) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2017') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "17/16 YOY GROWTH FOR FATAL INJURIES"
from (select cast(sum(INJURIES_FATAL) as decimal(10, 2)) - (select cast(sum(INJURIES_FATAL) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2016') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2017') cy, 
      (select cast(sum(INJURIES_FATAL) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2016') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "16/15 YOY GROWTH FOR FATAL INJURIES"
from (select cast(sum(INJURIES_FATAL) as decimal(10, 2)) - (select cast(sum(INJURIES_FATAL) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2015') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2016') cy, 
      (select cast(sum(INJURIES_FATAL) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2015') py;

-- Whats the year over year growth for incapacitating injuries?
select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "24/23 YOY GROWTH FOR INJURIES_INCAPACITATING"
from (select cast(sum(INJURIES_INCAPACITATING) as decimal(10, 2)) - (select cast(sum(INJURIES_INCAPACITATING) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2023') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2024') cy, 
      (select cast(sum(INJURIES_INCAPACITATING) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2023') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "23/22 YOY GROWTH FOR INJURIES_INCAPACITATING"
from (select cast(sum(INJURIES_INCAPACITATING) as decimal(10, 2)) - (select cast(sum(INJURIES_INCAPACITATING) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2022') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2023') cy, 
      (select cast(sum(INJURIES_INCAPACITATING) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2022') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "22/21 YOY GROWTH FOR INJURIES_INCAPACITATING"
from (select cast(sum(INJURIES_INCAPACITATING) as decimal(10, 2)) - (select cast(sum(INJURIES_INCAPACITATING) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2021') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2022') cy, 
      (select cast(sum(INJURIES_INCAPACITATING) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2021') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "21/20 YOY GROWTH FOR INJURIES_INCAPACITATING"
from (select cast(sum(INJURIES_INCAPACITATING) as decimal(10, 2)) - (select cast(sum(INJURIES_INCAPACITATING) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2020') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2021') cy, 
      (select cast(sum(INJURIES_INCAPACITATING) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2020') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "20/19 YOY GROWTH FOR INJURIES_INCAPACITATING"
from (select cast(sum(INJURIES_INCAPACITATING) as decimal(10, 2)) - (select cast(sum(INJURIES_INCAPACITATING) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2019') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2020') cy, 
      (select cast(sum(INJURIES_INCAPACITATING) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2019') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "19/18 YOY GROWTH FOR INJURIES_INCAPACITATINGS"
from (select cast(sum(INJURIES_INCAPACITATING) as decimal(10, 2)) - (select cast(sum(INJURIES_INCAPACITATING) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2018') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2019') cy, 
      (select cast(sum(INJURIES_INCAPACITATING) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2018') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "18/17 YOY GROWTH FOR INJURIES_INCAPACITATINGS"
from (select cast(sum(INJURIES_INCAPACITATING) as decimal(10, 2)) - (select cast(sum(INJURIES_INCAPACITATING) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2017') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2018') cy, 
      (select cast(sum(INJURIES_INCAPACITATING) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2017') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "17/16 YOY GROWTH FOR INJURIES_INCAPACITATING"
from (select cast(sum(INJURIES_INCAPACITATING) as decimal(10, 2)) - (select cast(sum(INJURIES_INCAPACITATING) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2016') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2017') cy, 
      (select cast(sum(INJURIES_INCAPACITATING) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2016') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "16/15 YOY GROWTH FOR INJURIES_INCAPACITATING"
from (select cast(sum(INJURIES_INCAPACITATING) as decimal(10, 2)) - (select cast(sum(INJURIES_INCAPACITATING) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2015') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2016') cy, 
      (select cast(sum(INJURIES_INCAPACITATING) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2015') py;

--select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "15/14 YOY GROWTH FOR INJURIES_INCAPACITATINGS" ---
--from (select cast(sum(INJURIES_INCAPACITATING) as decimal(10, 2)) - (select cast(sum(INJURIES_INCAPACITATING) as decimal(10,2)) ---------------------
--                                                            from ChicagoTrafficCrashes ----------------------------------------------------------------
--													        where year(CRASH_DATE) = '2014') "num" --------------------------------------------------------
--      from ChicagoTrafficCrashes ---------------------------------------------------------------------------------------------------------------------------
--      where year(CRASH_DATE) = '2015') cy, -------------------------------------------------------------------------------------------------------------------- (No info for these years)
--      (select cast(sum(INJURIES_INCAPACITATING) as decimal(10,2)) "den" ------------------------------------------------------------------------------------
--       from ChicagoTrafficCrashes ----------------------------------------------------------------------------------------------------------------------
--       where year(CRASH_DATE) = '2014') py; --------------------------------------------------------------------------------------------------------

--select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "14/13 YOY GROWTH FOR INJURIES_INCAPACITATING" ---
--from (select cast(sum(INJURIES_INCAPACITATING) as decimal(10, 2)) - (select cast(sum(INJURIES_INCAPACITATING) as decimal(10,2)) ---------------------
--                                                            from ChicagoTrafficCrashes ---------------------------------------------------------------
--													        where year(CRASH_DATE) = '2013') "num" ---------------------------------------------------------
--      from ChicagoTrafficCrashes  --------------------------------------------------------------------------------------------------------------------------
--      where year(CRASH_DATE) = '2014') cy, -------------------------------------------------------------------------------------------------------------------- (No info for these years)
--      (select cast(sum(INJURIES_INCAPACITATING) as decimal(10,2)) "den" ----------------------------------------------------------------------------------
--       from ChicagoTrafficCrashes --------------------------------------------------------------------------------------------------------------------
--       where year(CRASH_DATE) = '2013') py; ------------------------------------------------------------------------------------------------------

-- Whats the year over year growth for non-incapacitating injuries?
select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "24/23 YOY GROWTH FOR INJURIES_NON_INCAPACITATING"
from (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10, 2)) - (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2023') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2024') cy, 
      (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2023') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "23/22 YOY GROWTH FOR INJURIES_NON_INCAPACITATING"
from (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10, 2)) - (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2022') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2023') cy, 
      (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2022') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "22/21 YOY GROWTH FOR INJURIES_NON_INCAPACITATING"
from (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10, 2)) - (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2021') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2022') cy, 
      (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2021') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "21/20 YOY GROWTH FOR INJURIES_NON_INCAPACITATING"
from (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10, 2)) - (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2020') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2021') cy, 
      (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2020') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "20/19 YOY GROWTH FOR INJURIES_NON_INCAPACITATING"
from (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10, 2)) - (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2019') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2020') cy, 
      (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2019') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "19/18 YOY GROWTH FOR INJURIES_NON_INCAPACITATING"
from (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10, 2)) - (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2018') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2019') cy, 
      (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2018') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "18/17 YOY GROWTH FOR INJURIES_NON_INCAPACITATING"
from (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10, 2)) - (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2017') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2018') cy, 
      (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2017') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "17/16 YOY GROWTH FOR INJURIES_NON_INCAPACITATING"
from (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10, 2)) - (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2016') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2017') cy, 
      (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2016') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "16/15 YOY GROWTH FOR INJURIES_NON_INCAPACITATING"
from (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10, 2)) - (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2015') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2016') cy, 
      (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2015') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "15/14 YOY GROWTH FOR INJURIES_NON_INCAPACITATING"
from (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10, 2)) - (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2014') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2015') cy, 
      (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2014') py;

select concat(cast(sum(cy."num") as decimal(10,2)) / cast(sum(py."den") as decimal(10,2)), '%') "14/13 YOY GROWTH FOR INJURIES_NON_INCAPACITATING"
from (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10, 2)) - (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10,2)) 
                                                            from ChicagoTrafficCrashes
													        where year(CRASH_DATE) = '2013') "num"
      from ChicagoTrafficCrashes
      where year(CRASH_DATE) = '2014') cy, 
      (select cast(sum(INJURIES_NON_INCAPACITATING) as decimal(10,2)) "den"
       from ChicagoTrafficCrashes
       where year(CRASH_DATE) = '2013') py;

-- Whats the maximum number of injuries per accident by first crash type for each year?
select max(INJURIES_TOTAL) "MAX_NUM_OF_INJURIES_PER_ACCIDENT", 
       CRASH_TYPE, year(CRASH_DATE) "ACCIDENT_YEAR"
from ChicagoTrafficCrashes
group by year(CRASH_DATE), CRASH_TYPE
order by "ACCIDENT_YEAR" desc;

-- How many injuries by first crash type happened every year?
select count(INJURIES_TOTAL) "COUNT_OF_INJURIES", 
       CRASH_TYPE, year(CRASH_DATE) "ACCIDENT_YEAR"
from ChicagoTrafficCrashes
group by year(CRASH_DATE), CRASH_TYPE
order by "ACCIDENT_YEAR" desc;

-- What is the distribution of total injuries by damage? 
select count(INJURIES_TOTAL) "COUNT_OF_INJURIES", 
       DAMAGE
from ChicagoTrafficCrashes
group by DAMAGE
order by "COUNT_OF_INJURIES" desc;

-- What is the distribution of fatal injuries by damage?
select count(INJURIES_TOTAL) "NUM_OF_FATAL_INJURIES",
       DAMAGE
from ChicagoTrafficCrashes
where INJURIES_FATAL >= 1
group by DAMAGE
order by "NUM_OF_FATAL_INJURIES" desc;

/* This concludes our analysis of this dataset. We have been able to answere quite a few questions that provide insights into better understandingt the data. 
The next step will be taking this data over to PowerBi to visualize some of the insights that I've created code for. */        

