/* The data from this project was retrieved from the website mavenanalytics.io. The data consist of all space missions from 1957 to August 2022 and includes the details on the location, 
   date, time, the result of the launch, the company responsible, the name, the price, and the status of the rocket used for the mission. 

   In this project, I will utilize SQL to import a csv file into a created database. Once the data has been imported, I will clean the data by checking for unique, duplicate, and null 
   values. I will also utilize functions to extract the day and month from the date column as well as extract the hour from the time column to get a more in depth analysis. Finally I 
   will explore the data looking for any trends and patterns and answer the given questions.

   QUESIONS:
   1) How have rocket launches trended across time?
   2) Has mission success rate increased?
   3) Which countries have had the most successful space missions?
   4) Which rocket has been used for the most space missions?
   5) Is it still active?
   6) Are there any patterns you can notice with the launch locations? 
*/


-- Now that the data has been successfully imported into the database, I will begin to check each column for unique values.
select count(distinct Company) "'Company' unique values"
from space_missions;
----------------------------------------------------
-- The column 'Company' has 62 unique values.
----------------------------------------------------

select count(distinct Location) "'Location' unique values"
from space_missions;
----------------------------------------------------
-- The column 'Location' has 158 unique values.
----------------------------------------------------

select count(distinct Date) "'Date' unique values"
from space_missions;
----------------------------------------------------
-- The column 'Date' has 4180 unique values.
----------------------------------------------------

select count(distinct Time) "'Time' unique values"
from space_missions;
----------------------------------------------------
-- The column 'Time' has 1300 unique values.
----------------------------------------------------

select count(distinct Rocket) "'Rocket' unique values"
from space_missions;
----------------------------------------------------
-- The column 'Rocket' has 370 unique values.
----------------------------------------------------

select count(distinct Mission) "'Mission' unique values"
from space_missions;
----------------------------------------------------
-- The column 'Mission' has 4555 unique values.
----------------------------------------------------

select count(distinct RocketStatus) "'RocketStatus' unique values"
from space_missions;
----------------------------------------------------
-- The column 'RocketStatus' has 2 unique values.
----------------------------------------------------

select count(distinct Price) "'Price' unique values"
from space_missions;
----------------------------------------------------
-- The column 'Price' has 65 unique values.
----------------------------------------------------

select count(distinct MissionStatus) "'MissionStatus' unique values"
from space_missions;
----------------------------------------------------
-- The column 'MissionStatus' has 4 unique values.
----------------------------------------------------

/* Now I will check this dataset for any duplicated rows of data */
with dup as (select *, row_number() over(partition by Company, Location, Date, Time, Rocket, Mission order by Date asc) "duplicated rows of data"
             from space_missions)
select dup.*
from dup
where [duplicated rows of data] = 2;
/* 
Company     Location                                                      Date         Time               Rocket            Mission                         RocketStatus      Price      MissionStatus       duplicated rows of data
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CASC        Site 9401 (SLS-2), Jiuquan Satellite Launch Center, China     2008-11-05   00:15:00.0000000   Long March 2D     Shiyan-3 & Chuangxin-1(02)      Active            29.75      Success             2
*/

-- Now that I have identified the duplicated row of data, I will now remove it from the dataset.

with del as (select *, row_number() over(partition by Company, Location, Date, Time, Rocket, Mission order by Date asc) "delete duplicates"
             from space_missions)
Delete from del
where [delete duplicates] = 2;
/*
(1 row affected)
Now in this situation, there was only 1 row of duplicated data. However, it has now been removed from the dataset. */

-- Now I will look at the count of null values in each column.
select count(Company) "num of nulls"
from space_missions
where Company is null;
----------------------------------------------------
-- There are 0 null values in the column 'Company'.
----------------------------------------------------

select count(Location) "num of nulls"
from space_missions
where Location is null;
----------------------------------------------------
-- There are 0 null values in the column 'Location'.
----------------------------------------------------

select count(Date) "num of nulls"
from space_missions
where Date is null;
----------------------------------------------------
-- There are 0 null values in the column 'Date'.
----------------------------------------------------

select count(*) "num of nulls"
from space_missions
where Time is null;
----------------------------------------------------
-- There are 127 null values in the column 'Time'.
----------------------------------------------------

select count(Rocket) "num of nulls"
from space_missions
where Rocket is null;
----------------------------------------------------
-- There are 0 null values in the column 'Rocket'.
----------------------------------------------------

select count(Mission) "num of nulls"
from space_missions
where Mission is null;
----------------------------------------------------
-- There are 0 null values in the column 'Mission'.
----------------------------------------------------

select count(RocketStatus) "num of nulls"
from space_missions
where RocketStatus is null;
--------------------------------------------------------
-- There are 0 null values in the column 'RocketStatus'.
--------------------------------------------------------

select count(*) "num of nulls"
from space_missions
where Price is null;
----------------------------------------------------
-- There are 3365 null values in the column 'Price'.
----------------------------------------------------

select count(*) "num of nulls"
from space_missions
where MissionStatus is null; 
---------------------------------------------------------
-- There are 0 null values in the column 'MissionStatus'.
---------------------------------------------------------

/* Now that I have cleaned the data up to ensure accuracy, I can move on to answering the questions.      */

-- 1) How have rocket launches trended across time? --
-- Rocket launches trend over year
with trend as (select year(Date) "Launch Year",
                      Company,
	                  count(Company) "Num of Launches"
               from space_missions
               group by year(Date),
                        Company)
select sum(trend."Num of Launches") "Total launches",
       trend."Launch Year"
from trend
group by "Launch Year"
order by [Launch Year] asc;
/*
(66 rows affected)
Total launches/ Launch Year
-------------- -----------
3              1957
28             1958
20             1959
39             1960
52             1961
82             1962
41             1963
60             1964
87             1965
101            1966
106            1967
103            1968
103            1969
107            1970
119            1971
99             1972
103            1973
98             1974
113            1975
113            1976
114            1977
97             1978
49             1979
55             1980
71             1981
67             1982
66             1983
69             1984
74             1985
62             1986
56             1987
59             1988
52             1989
80             1990
59             1991
62             1992
61             1993
64             1994
61             1995
60             1996
70             1997
68             1998
57             1999
57             2000
43             2001
49             2002
52             2003
40             2004
37             2005
49             2006
50             2007
47             2008
50             2009
37             2010
42             2011
38             2012
46             2013
53             2014
52             2015
90             2016
92             2017
117            2018
109            2019
119            2020
157            2021
93             2022
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- The data indicates that from 1957 to 1977 that the number of launces were overall increasing by year. From 1978 to 2015 the number of overall launches decreased significantly by year.
   While the years 2016 to 2022 displayed an overall increase in launches by year.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
-- Rocket launch trend over month
with trends as (select *, 
					case
						when "Launch Month" = 1 then 'January'
		                when "Launch Month" = 2 then 'Feburary'
		                when "Launch Month" = 3 then 'March'
		                when "Launch Month" = 4 then 'April'
		                when "Launch Month" = 5 then 'May'
		                when "Launch Month" = 6 then 'June'
		                when "Launch Month" = 7 then 'July'
		                when "Launch Month" = 8 then 'August'
		                when "Launch Month" = 9 then 'September'
		                when "Launch Month" = 10 then 'October'
		                when "Launch Month" = 11 then 'November'
		                when "Launch Month" = 12 then 'December'
	                end as "Months"
from (select month(Date) "Launch Month",
	         count(Company) "Num of Launches"
      from space_missions
      group by month(Date)) m)
select sum(trends."Num of Launches") "Total Launches",
       trends."Months"
from trends
group by "Launch Month",
         "Months"
order by "Launch Month" asc;
/*
(12 rows affected)
Total Launches/` Months
-------------- ---------
284            January
361            Feburary
378            March
409            April
350            May
431            June
380            July
391            August
386            September
403            October
364            November
492            December
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- The data indicates that the most amount of launches have taken place during the month of December, while the least amount of lauches have taken place in the month of January.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

-- 2) Has mission success rate increased? --
-- Mission success by year
with success as (select year(Date) "Launch Year",
                        count(Company) "Num of Launches",
		                MissionStatus 
                 from space_missions
                 where MissionStatus = 'Success'
                 group by year(Date),
                          MissionStatus), 
     failure as (select year(Date) "Launch Year",
                        count(Company) "Num of Launches",
		                MissionStatus 
                 from space_missions
                 where MissionStatus = 'Failure'
                 group by year(Date),
                          MissionStatus) 
select success."Launch Year",
       success."Num of Launches",
	   success.MissionStatus,
	   failure."Num of Launches", 
	   failure."MissionStatus"
from success,
     failure
where success.[Launch Year] = failure.[Launch Year];
/*
(66 rows affected) 
Launch Year Num of Launches MissionStatus                                                                                                                                                                                                                                                    Num of Launches MissionStatus
----------- --------------- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --------------- -------------
1957        2               Success                                                                                                                                                                                                                                                          1               Failure
1958        6               Success                                                                                                                                                                                                                                                          20              Failure
1959        8               Success                                                                                                                                                                                                                                                          9               Failure
1960        19              Success                                                                                                                                                                                                                                                          20              Failure
1961        32              Success                                                                                                                                                                                                                                                          17              Failure
1962        65              Success                                                                                                                                                                                                                                                          15              Failure
1963        29              Success                                                                                                                                                                                                                                                          12              Failure
1964        48              Success                                                                                                                                                                                                                                                          10              Failure
1965        74              Success                                                                                                                                                                                                                                                          11              Failure
1966        81              Success                                                                                                                                                                                                                                                          10              Failure
1967        87              Success                                                                                                                                                                                                                                                          11              Failure
1968        92              Success                                                                                                                                                                                                                                                          6               Failure
1969        85              Success                                                                                                                                                                                                                                                          17              Failure
1970        93              Success                                                                                                                                                                                                                                                          10              Failure
1971        105             Success                                                                                                                                                                                                                                                          12              Failure
1972        89              Success                                                                                                                                                                                                                                                          7               Failure
1973        96              Success                                                                                                                                                                                                                                                          7               Failure
1974        90              Success                                                                                                                                                                                                                                                          7               Failure
1975        107             Success                                                                                                                                                                                                                                                          6               Failure
1976        108             Success                                                                                                                                                                                                                                                          3               Failure
1977        110             Success                                                                                                                                                                                                                                                          4               Failure
1978        94              Success                                                                                                                                                                                                                                                          1               Failure
1979        46              Success                                                                                                                                                                                                                                                          2               Failure
1980        49              Success                                                                                                                                                                                                                                                          3               Failure
1981        65              Success                                                                                                                                                                                                                                                          2               Failure
1982        62              Success                                                                                                                                                                                                                                                          3               Failure
1983        65              Success                                                                                                                                                                                                                                                          1               Failure
1984        66              Success                                                                                                                                                                                                                                                          1               Failure
1985        68              Success                                                                                                                                                                                                                                                          5               Failure
1986        56              Success                                                                                                                                                                                                                                                          4               Failure
1987        53              Success                                                                                                                                                                                                                                                          2               Failure
1988        57              Success                                                                                                                                                                                                                                                          1               Failure
1989        50              Success                                                                                                                                                                                                                                                          1               Failure
1990        76              Success                                                                                                                                                                                                                                                          3               Failure
1991        54              Success                                                                                                                                                                                                                                                          3               Failure
1992        59              Success                                                                                                                                                                                                                                                          3               Failure
1993        57              Success                                                                                                                                                                                                                                                          4               Failure
1994        58              Success                                                                                                                                                                                                                                                          4               Failure
1995        53              Success                                                                                                                                                                                                                                                          5               Failure
1996        56              Success                                                                                                                                                                                                                                                          3               Failure
1997        64              Success                                                                                                                                                                                                                                                          3               Failure
1998        61              Success                                                                                                                                                                                                                                                          5               Failure
1999        51              Success                                                                                                                                                                                                                                                          6               Failure
2000        53              Success                                                                                                                                                                                                                                                          4               Failure
2001        40              Success                                                                                                                                                                                                                                                          1               Failure
2002        47              Success                                                                                                                                                                                                                                                          2               Failure
2003        48              Success                                                                                                                                                                                                                                                          3               Failure
2004        37              Success                                                                                                                                                                                                                                                          1               Failure
2005        34              Success                                                                                                                                                                                                                                                          3               Failure
2006        46              Success                                                                                                                                                                                                                                                          3               Failure
2007        46              Success                                                                                                                                                                                                                                                          2               Failure
2008        44              Success                                                                                                                                                                                                                                                          2               Failure
2009        47              Success                                                                                                                                                                                                                                                          3               Failure
2010        34              Success                                                                                                                                                                                                                                                          3               Failure
2011        40              Success                                                                                                                                                                                                                                                          1               Failure
2012        34              Success                                                                                                                                                                                                                                                          3               Failure
2013        43              Success                                                                                                                                                                                                                                                          2               Failure
2014        51              Success                                                                                                                                                                                                                                                          1               Failure
2015        48              Success                                                                                                                                                                                                                                                          3               Failure
2016        86              Success                                                                                                                                                                                                                                                          2               Failure
2017        84              Success                                                                                                                                                                                                                                                          6               Failure
2018        113             Success                                                                                                                                                                                                                                                          2               Failure
2019        100             Success                                                                                                                                                                                                                                                          6               Failure
2020        107             Success                                                                                                                                                                                                                                                          10              Failure
2021        143             Success                                                                                                                                                                                                                                                          11              Failure
2022        90              Success                                                                                                                                                                                                                                                          3               Failure
-----------------------------------------------------------------------------------------------------------------------------
-- According to the data, mission success has increased overall every year with the exception of the years 1958 through 1960.      
-----------------------------------------------------------------------------------------------------------------------------
*/
-- Mission success by month
with success as (select *, 
					case
						when "Launch Month" = 1 then 'January'
						when "Launch Month" = 2 then 'Feburary'
						when "Launch Month" = 3 then 'March'
						when "Launch Month" = 4 then 'April'
						when "Launch Month" = 5 then 'May'
						when "Launch Month" = 6 then 'June'
						when "Launch Month" = 7 then 'July'
						when "Launch Month" = 8 then 'August'
						when "Launch Month" = 9 then 'Spetember'
						when "Launch Month" = 10 then 'October'
						when "Launch Month" = 11 then 'November'
						when "Launch Month" = 12 then 'December'
				    end as "Months"
				 from (select month(Date) "Launch Month",
                              count(Company) "Num of Launches",
		                      MissionStatus 
                       from space_missions
                       where MissionStatus = 'Success'
                       group by month(Date),
                                MissionStatus) m), 
     failure as (select month(Date) "Launch Month",
                        count(Company) "Num of Launches",
		                MissionStatus 
                 from space_missions
                 where MissionStatus = 'Failure'
                 group by month(Date),
                          MissionStatus) 
select success."Months",
       success."Num of Launches",
	   success.MissionStatus,
	   failure."Num of Launches", 
	   failure."MissionStatus"
from success,
     failure
where success.[Launch Month] = failure.[Launch Month];
/*
(12 rows affected)
Months    Num of Launches MissionStatus                                                                                                                                         Num of Launches MissionStatus
--------- --------------- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
January   257             Success                                                                                                                                               19              Failure
Feburary  321             Success                                                                                                                                               32              Failure
March     345             Success                                                                                                                                               26              Failure
April     370             Success                                                                                                                                               31              Failure
May       317             Success                                                                                                                                               27              Failure
June      385             Success                                                                                                                                               36              Failure
July      343             Success                                                                                                                                               29              Failure
August    346             Success                                                                                                                                               35              Failure
Spetember 345             Success                                                                                                                                               31              Failure
October   367             Success                                                                                                                                               29              Failure
November  326             Success                                                                                                                                               32              Failure
December  439             Success                                                                                                                                               30              Failure
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- The data indicates that the highest number of mission success was in the month of December, while the highest number of mission failures was in the month of June.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

-- 3) Which countries have had the most successful space missions? --
with usa as (select count(distinct Location) "Successful USA Missions"
             from space_missions
             where Location like '%USA%'
             and MissionStatus = 'Success'),
     kaz as (select count(distinct Location) "Successful Kazakhstan Missions"
             from space_missions
             where Location like '%Kazakhstan%'
             and MissionStatus = 'Success'),
     china as (select count(distinct Location) "Successful China Missions"
               from space_missions
               where  Location like '%China%'
               and MissionStatus = 'Success'),
     india as (select count(distinct Location) "Successful India Missions"
               from space_missions
               where Location like '%India%'
               and MissionStatus = 'Success'),
     russia as (select count(distinct Location) "Successful Russia Missions"
                from space_missions
                where Location like '%Russia%'
                and MissionStatus = 'Success'),
     skorea as (select count(distinct Location) "Successful South Korea Missions"
                from space_missions
                where Location like '%South Korea%'
                and MissionStatus = 'Success'),
     kenya as (select count(distinct Location) "Successful Kenya Missions"
               from space_missions
               where Location like '%Kenya%'
               and MissionStatus = 'Success'),
     iran as (select count(distinct Location) "Successful Iran Missions"
              from space_missions
              where Location like '%Iran%'
              and MissionStatus = 'Success'),
     jap as (select count(distinct Location) "Successful Japan Missions"
             from space_missions
             where Location like '%Japan%'
             and MissionStatus = 'Success'),
     nkorea as (select count(distinct Location) "Successful North Korea Missions"
                from space_missions
                where Location like '%North Korea%'
                and MissionStatus = 'Success'),
     france as (select count(distinct Location) "Successful France Missions"
                from space_missions
                where Location like '%France%'
                and MissionStatus = 'Success'),
     brazil as (select count(distinct Location) "Successful Brazil Missions"
                from space_missions
                where Location like '%Brazil%'
                and MissionStatus = 'Success'), 
     newzealand as (select count(distinct Location) "Successful New Zealand Missions"
                    from space_missions
                    where Location like '%New Zealand%'
                    and MissionStatus = 'Success'),
     israel as (select count(distinct Location) "Successful Israel Missions"
                from space_missions
                where Location like '%Israel%'
                and MissionStatus = 'Success')
select *
from usa, russia, india, iran, israel, newzealand, nkorea,
     brazil, france, skorea, jap, china, kaz, kenya;
/*
Successful USA Missions Successful Russia Missions Successful India Missions Successful Iran Missions Successful Israel Missions Successful New Zealand Missions Successful North Korea Missions Successful Brazil Missions Successful France Missions Successful South Korea Missions Successful Japan Missions Successful China Missions Successful Kazakhstan Missions Successful Kenya Missions
----------------------- -------------------------- ------------------------- ------------------------ -------------------------- ------------------------------- ------------------------------- -------------------------- -------------------------- ------------------------------- ------------------------- ------------------------- ------------------------------ -------------------------
60                      17                         3                         2                        1                          3                               1                               0                          8                          2                               5                         16                        19                             2
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- America has had the most successful space missions, leading with 60. Kazakhstan comes second with 19 successful space missions. Russia is third with 17 successful space missons and China comes in fourth with 16 successful space missions.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/	

-- 4) Which rocket has been used for the most space missions? --
select distinct Rocket,
       count(Rocket) "Num of Use"
from space_missions
group by Rocket
order by "Num of Use" desc
offset 0 rows
fetch next 3 row only;
/*
Rocket                                                                                                                             Num of Use
---------------------------------------------------------------------------------------------------------------------------------- -----------
Cosmos-3M (11K65M)                                                                                                                 446    
------------------------------------------------------------------------------------------
-- The rocket Cosmos-3M (11K65M) has been used the most for space missions with 446 uses.
------------------------------------------------------------------------------------------
*/

-- 5) Is it still active? --
select distinct Rocket,
       count(Rocket) "Num of Use",
	   RocketStatus 
from space_missions
group by Rocket,
         RocketStatus
order by [Num of Use] desc
offset 0 rows
fetch next 1 row only;
/*
Rocket                                                                                                                                       Num of Use       RocketStatus
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Cosmos-3M (11K65M)                                                                                                                           446              Retired 
-------------------------------------------------------------------------------------------------------------------
-- The rocket with the most space missions, Cosmos-3M (11K65M), is no longer active. It has reached retired status.
-------------------------------------------------------------------------------------------------------------------
*/

-- 6) Are there any patterns you can notice with the launch locations? --
with loc_trends as (select Location,
                           Date,
						   MissionStatus,
	                   case
		                  when Location = lead(Location) over(order by Date)
		                  and Location = lead(Location, 2) over(order by Date)
		                  then Location
	                   end as "Consecutive Locations"
                    from space_missions
                    group by Location,
                             Date,
							 MissionStatus)
select loc_trends.Date,
       loc_trends.[Consecutive Locations],
	   loc_trends.MissionStatus
from loc_trends
where loc_trends.[Consecutive Locations] is not null;
/*
(13 rows affected)
Date            Consecutive Locations                                                                           MissionStatus
---------- ---------------------------------------------------------------------------------------------------- -------------
1958-08-25      Douglas F4D Skyray, Naval Air Station Point Mugu, California, USA                               Failure
1962-12-22      Site 1/5, Baikonur Cosmodrome, Kazakhstan                                                       Success
1963-11-01      Site 1/5, Baikonur Cosmodrome, Kazakhstan                                                       Success
1964-03-21      Site 1/5, Baikonur Cosmodrome, Kazakhstan                                                       Failure
1965-11-12      Site 31/6, Baikonur Cosmodrome, Kazakhstan                                                      Success
1966-11-19      Site 31/6, Baikonur Cosmodrome, Kazakhstan                                                      Success
1968-08-28      Site 31/6, Baikonur Cosmodrome, Kazakhstan                                                      Success
1973-10-03      Site 41/1, Plesetsk Cosmodrome, Russia                                                          Success
1975-08-22      Site 41/1, Plesetsk Cosmodrome, Russia                                                          Success
1978-08-22      Site 43/4, Plesetsk Cosmodrome, Russia                                                          Success
1983-09-30      Site 132/1, Plesetsk Cosmodrome, Russia                                                         Success
1987-02-20      Site 32/2, Plesetsk Cosmodrome, Russia                                                          Success
1991-01-29      Site 133/3, Plesetsk Cosmodrome, Russia                                                         Success
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- The results are displaying the launch locations that conducted at least three launch missions consecutively. The patterns that I noticed in the launch locations is that some launch locations conducted
   three consecutive launch missions. Out of those locations that conducted three consecutive launch missions, all were successful with the exception of two. Lastly, three consecutive launches only lasted
   between the year 1958 and 1991.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


This concludes my analysis on this project. I have demonstrated how to utilize SQL to import a csv file into a relational database, as well as extract, transform, and load data from a relational database. 
Utilizing my skills of manipulating data in SQL, I have been able to successfully answer the desired questions.
*/