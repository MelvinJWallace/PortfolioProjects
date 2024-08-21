/* 
This dataset is on motor vehicle collisions reported by the New York City Police Department from January of 2021 through April of 2023. Each record represents an individual collision, including the date, time, and location of the accident 
(borough, zip code, street name, latitude/longitude), vehicle and victims involved, and contirbuting factors.

I will utilize functions and queries in Sql to clean the dataset if necessary, to extract the month and day from the date colunn, and to perform calculations. I will also perform exploratory analysis.

RECOMMENDED ANALYSIS:
	1. Compare the percentage of total accidents by month. Is there any noticable seasonal patterns?
	2. Break down accident frequency by day of the week and by hour of the day. Based on the results, when do accidents occur most frequently?
	3. On which particular street were the most accidents reported? What does that represent as a percentage of all reported accidents?
	4. What was the most common contributing factors for the accidents reported in this sample (based on vehicle 1)? What about for accidents specifically?

(Source: NYC OpenData)
*/

/*
Before I begin my analysis,  I will then examine the columns in this table by checking to see if there are any duplicated rows in this table, the number of null values for each column, and the number of distinct values per column. 
*/

-- DATA EXAMINATION --

-- First 5 rows of NYC_Collisions Table
select top 5 * from NYC_Collisions order by Date asc;
/*
Collision_ID Date       Time             Borough                                            Street_Name                                        Cross_Street                                       Latitude               Longitude              Contributing_Factor                                                                                  Vehicle_Type                                       Persons_Injured Persons_Killed Pedestrians_Injured Pedestrians_Killed Cyclists_Injured Cyclists_Killed Motorists_Injured Motorists_Killed
------------ ---------- ---------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ---------------------- ---------------------- ---------------------------------------------------------------------------------------------------- -------------------------------------------------- --------------- -------------- ------------------- ------------------ ---------------- --------------- ----------------- ----------------
4380963      2021-01-01 18:45:00.0000000 Manhattan                                          Harlem River Drive                                 NULL                                               40.8486289978027       -73.927619934082       Pedestrian/Bicyclist/Other Pedestrian Error/Confusion                                                Passenger Vehicle                                  0               0              0                   0                  0                0               0                 0
4380940      2021-01-01 07:40:00.0000000 Brooklyn                                           Cortelyou Road                                     Mc Donald Avenue                                   40.6379089355469       -73.9786376953125      Unspecified                                                                                          Passenger Vehicle                                  0               0              0                   0                  0                0               0                 0
4380949      2021-01-01 19:30:00.0000000 Bronx                                              Sedgwick Avenue                                    Vancortlandt Avenue West                           40.8827018737793       -73.8927307128906      NULL                                                                                                 Not Reported                                       0               0              0                   0                  0                0               0                 0
4382769      2021-01-01 06:00:00.0000000 Staten Island                                      West Shore Expressway                              NULL                                               NULL                   NULL                   Fell Asleep                                                                                          Passenger Vehicle                                  0               0              0                   0                  0                0               0                 0
4441905      2021-01-01 05:28:00.0000000 Brooklyn                                           Lafayette Avenue                                   NULL                                               40.6873016357422       -73.9736557006836      Unspecified                                                                                          Passenger Vehicle                                  0               0              0                   0                  0                0               0                 0
*/

-- Last 5 rows of NYC_Collisions Table
select top 5 * from NYC_Collisions order by Date desc;
/*
Collision_ID Date       Time             Borough                                            Street_Name                                        Cross_Street                                       Latitude               Longitude              Contributing_Factor                                                                                  Vehicle_Type                                       Persons_Injured Persons_Killed Pedestrians_Injured Pedestrians_Killed Cyclists_Injured Cyclists_Killed Motorists_Injured Motorists_Killed
------------ ---------- ---------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ---------------------- ---------------------- ---------------------------------------------------------------------------------------------------- -------------------------------------------------- --------------- -------------- ------------------- ------------------ ---------------- --------------- ----------------- ----------------
4619477      2023-04-09 03:50:00.0000000 Queens                                             Francis Lewis Boulevard                            Whitehall Terrace                                  40.7217788696289       -73.7600250244141      Unspecified                                                                                          Passenger Vehicle                                  0               0              0                   0                  0                0               0                 0
4619619      2023-04-09 16:44:00.0000000 Bronx                                              Sound View Avenue                                  Lacombe Avenue                                     40.8152656555176       -73.8597259521484      Unsafe Speed                                                                                         Passenger Vehicle                                  0               0              0                   0                  0                0               0                 0
4619923      2023-04-09 16:30:00.0000000 Manhattan                                          5 Avenue                                           NULL                                               40.7642593383789       -73.9730224609375      Driver Inattention/Distraction                                                                       Passenger Vehicle                                  0               0              0                   0                  0                0               0                 0
4619178      2023-04-09 00:35:00.0000000 Manhattan                                          1 Avenue                                           East 57 Street                                     40.7583084106445       -73.9629364013672      Other Vehicular                                                                                      Passenger Vehicle                                  0               0              0                   0                  0                0               0                 0
4619557      2023-04-09 21:55:00.0000000 Brooklyn                                           Wilson Avenue                                      Jefferson Street                                   40.7021903991699       -73.9283447265625      Driver Inattention/Distraction                                                                       Taxi                                               3               0              0                   0                  0                0               3                 0
*/

------------------------------------------------
-- Checking table for any duplicate rows of data
------------------------------------------------
select *
from (select *, row_number() over(partition by Collision_ID order by Date) "Duplicate rows of data"
      from NYC_Collisions) d
where d.[Duplicate rows of data] = 2;
/*
Collision_ID Date       Time             Borough                                            Street_Name                                        Cross_Street                                       Latitude               Longitude              Contributing_Factor                                                                                  Vehicle_Type                                       Persons_Injured Persons_Killed Pedestrians_Injured Pedestrians_Killed Cyclists_Injured Cyclists_Killed Motorists_Injured Motorists_Killed Duplicate rows of data
------------ ---------- ---------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ---------------------- ---------------------- ---------------------------------------------------------------------------------------------------- -------------------------------------------------- --------------- -------------- ------------------- ------------------ ---------------- --------------- ----------------- ---------------- ----------------------
There are 0 rows of duplicate data in this table.
*/

----------------------------------------------------
-- Checking the number of null values in each column 
----------------------------------------------------
select Collision_ID from NYC_Collisions where Collision_ID is null;
/* 
The column Collision_ID has 0 rows of null values.
*/
select Date from NYC_Collisions where Date is null;
/* 
The colun Date has 0 rows of null values.
*/
select Time from NYC_Collisions where Time is null;
/*
The column Time has 0 rows of null values.
*/
select Borough from NYC_Collisions where Borough is null;
/* 
The column Borough has 7,197 rows of null values.
*/
select Street_Name from NYC_Collisions where Street_Name is null;
/*
The colunn Streeet_Name has 363 rows of null values.
*/
select Cross_Street from NYC_Collisions where Cross_Street is null;
/* 
The column Cross_Street has 0 rows of null values.
*/
select Latitude from NYC_Collisions where Latitude is null;
/*
The column Latitude has 22,323 rows of null values.
*/
select Longitude from NYC_Collisions where Longitude is null;
/*
The column Longitude has 22,324 rows of null values.
*/
select Contributing_Factor from NYC_Collisions where Contributing_Factor is null;
/*
The column Contributing_Factor has 1,287 rows of null values.
*/
select Vehicle_Type from NYC_Collisions where Vehicle_Type is null;
/* 
The column Vehicle_Type has 0 rows of null values.
*/
select Persons_Injured from NYC_Collisions where Persons_Injured is null;
/*
The column Persons_Injured has 1 row of null values.
*/
select Persons_Killed from NYC_Collisions where Persons_Killed is null;
/*
The column Persons_Killed has 0 rows of null values.
*/
select Pedestrians_Injured from NYC_Collisions where Pedestrians_Injured is null;
/*
The column Peeistrians_Injured has 0 rows of null values.
*/
select Pedestrians_Killed from NYC_Collisions where Pedestrians_Killed is null;
/*
The column Pedestrians_Killed has 2 rows of nulll values.
*/
select Cyclists_Injured from NYC_Collisions where Cyclists_Injured is null;
/*
The column Cyclists_Injured has 163 rows of null values.
*/
select Cyclists_Killed from NYC_Collisions where Cyclists_Killed is null;
/*
The column Cyclists_Killed has 0 rows of null values.
*/
select Motorists_Injured from NYC_Collisions where Motorists_Injured is null;
/*
The column Motorists_Injured has 0 rows of null values.
*/
select Motorists_Killed from NYC_Collisions where Motorists_Killed is null;
/*
The column Motorists_Killed has 0 rows of null values.
*/

------------------------------------------------------
-- Checking the number of unique values in each column
------------------------------------------------------
select count(distinct Collision_ID) "Num of Unique Collision_ID" from NYC_Collisions;
/*
Unique Collision_ID
-------------------
238,421
*/
select count(distinct Date) "Num of Unique Date" from NYC_Collisions;
/*
Num of Unique Date
------------------
829
*/
select count(distinct Time) "Num of Unique Time" from NYC_Collisions;
/*
Num of Unique Time
------------------
1,440
*/
select count(distinct Borough) "Num of Unique Borough" from NYC_Collisions;
/*
Num of Unique Borough
---------------------
5
*/
select count(distinct Street_Name) "Num of Unique Street_Name" from NYC_Collisions;
/*
Num of Unique Street_Name
-------------------------
6,139
*/
select count(distinct Cross_Street) "Num of Unique Cross_Street" from NYC_Collisions;
/*
Num of Unique Cross_Street
--------------------------
5,971
*/
select count(distinct Latitude) "Num of Unique Latitude" from NYC_Collisions;
/*
Num of Unique Latitude
----------------------
51572
*/
select count(distinct Longitude) "Num of Unique Longitude" from NYC_Collisions;
/*
Num of Unique Longitude
-----------------------
36534
*/
select count(distinct Contributing_Factor) "Num of Unique Contributing_Factor" from NYC_Collisions;
/*
Num of Unique Contributing_Factor
---------------------------------
55
*/
select count(distinct Vehicle_Type) "Num of Unique Vehicle_Type" from NYC_Collisions;
/*
Num of Unique Vehicle_Type
--------------------------
17
*/
select count(distinct Persons_Injured) "Num of Unique Persons_Injured" from NYC_Collisions;
/*
Num of Unique Persons_Injured
-----------------------------
23
*/
select count(distinct Persons_Killed) "Num of Unique Persons_Killed" from NYC_Collisions;
/*
Num of Unique Persons_Killed
----------------------------
4
*/
select count(distinct Pedestrians_Injured) "Num of Unique Pedestrins_Injured" from NYC_Collisions;
/*
Num of Unique Pedestrins_Injured
--------------------------------
8
*/
select count(distinct Pedestrians_Killed) "Num of Unique Pedestrins_Killed" from NYC_Collisions;
/*
Num of Unique Pedestrins_Killed
-------------------------------
2
*/
select count(distinct Cyclists_Injured) "Num of Unique Cyclists_Injured" from NYC_Collisions;
/*
Num of Unique Cyclists_Injured
------------------------------
2
*/
select count(distinct Cyclists_Killed) "Num of Unique Cyclists_Killed" from NYC_Collisions;
/*
Num of Unique Cyclists_Killed
-----------------------------
2
*/
select count(distinct Motorists_Injured) "Num of Unique Motorist_Injured" from NYC_Collisions;
/*
Num of Unique Motorist_Injured
------------------------------
21
*/
select count(distinct Motorists_Killed) "Num of Unique Motorist_Killed" from NYC_Collisions;
/*
Num of Unique Motorist_Killed
-----------------------------
4
*/

/*
Now I have a better understanding of the data that I am working with in this table. For this dataset, there is not any data cleaning that needs to be performed. However, I could extract the month, day, and hour of the day from the Date and Time columns
and assign those values to their own seperate columns respectively but in this case, I will use functions to get those values.
*/

-- QUESTIONS --

-- 1. Compare the percentage of total accidents by month. Is there any noticable seasonal patterns? --
with jan_percentage as (select count(Collision_ID) "Jan Num of Accidents", (select count(Collision_ID) 
                                                                            from NYC_Collisions) "Total Accidents"
                        from NYC_Collisions
                        where month(Date) = 1),
	 feb_percentage as (select count(COllision_ID) "Feb Num of Accidents", (select count(Collision_ID)
	                                                                        from NYC_Collisions) "Total Accidents"
						from NYC_Collisions
						where month(Date) = 2),
     mar_percentage as (select count(COllision_ID) "Mar Num of Accidents", (select count(Collision_ID)
	                                                                        from NYC_Collisions) "Total Accidents"
						from NYC_Collisions
						where month(Date) = 3),
     apr_percentage as (select count(COllision_ID) "Apr Num of Accidents", (select count(Collision_ID)
	                                                                        from NYC_Collisions) "Total Accidents"
						from NYC_Collisions
						where month(Date) = 4),
     may_percentage as (select count(COllision_ID) "May Num of Accidents", (select count(Collision_ID)
	                                                                        from NYC_Collisions) "Total Accidents"
						from NYC_Collisions
						where month(Date) = 5),
     jun_percentage as (select count(COllision_ID) "Jun Num of Accidents", (select count(Collision_ID)
	                                                                        from NYC_Collisions) "Total Accidents"
						from NYC_Collisions
						where month(Date) = 6),
     jul_percentage as (select count(COllision_ID) "Jul Num of Accidents", (select count(Collision_ID)
	                                                                        from NYC_Collisions) "Total Accidents"
						from NYC_Collisions
						where month(Date) = 7),
     aug_percentage as (select count(COllision_ID) "Aug Num of Accidents", (select count(Collision_ID)
	                                                                        from NYC_Collisions) "Total Accidents"
						from NYC_Collisions
						where month(Date) = 8),
     sep_percentage as (select count(COllision_ID) "Sep Num of Accidents", (select count(Collision_ID)
	                                                                        from NYC_Collisions) "Total Accidents"
						from NYC_Collisions
						where month(Date) = 9),
     oct_percentage as (select count(COllision_ID) "Oct Num of Accidents", (select count(Collision_ID)
	                                                                        from NYC_Collisions) "Total Accidents"
						from NYC_Collisions
						where month(Date) = 10),
     nov_percentage as (select count(COllision_ID) "Nov Num of Accidents", (select count(Collision_ID)
	                                                                        from NYC_Collisions) "Total Accidents"
						from NYC_Collisions
						where month(Date) = 11),
     dec_percentage as (select count(COllision_ID) "Dec Num of Accidents", (select count(Collision_ID)
	                                                                        from NYC_Collisions) "Total Accidents"
						from NYC_Collisions
						where month(Date) = 12)
select concat(round(convert(float, jan_percentage."Jan Num of Accidents") / convert(float, jan_percentage."Total Accidents") * 100, 2), '%') "Jan Percentage of Accidents",
       concat(round(convert(float, feb_percentage."Feb Num of Accidents") / convert(float, feb_percentage."Total Accidents") * 100, 2), '%') "Feb Percentage of Accidents",
	   concat(round(convert(float, mar_percentage."Mar Num of Accidents") / convert(float, mar_percentage."Total Accidents") * 100, 2), '%') "Mar Percentage of Accidents",
	   concat(round(convert(float, apr_percentage."Apr Num of Accidents") / convert(float, apr_percentage."Total Accidents") * 100, 2), '%') "Apr Percentage of Accidents",
	   concat(round(convert(float, may_percentage."May Num of Accidents") / convert(float, may_percentage."Total Accidents") * 100, 2), '%') "May Percentage of Accidents",
	   concat(round(convert(float, jun_percentage."Jun Num of Accidents") / convert(float, jun_percentage."Total Accidents") * 100, 2), '%') "Jun Percentage of Accidents",
	   concat(round(convert(float, jul_percentage."Jul Num of Accidents") / convert(float, jul_percentage."Total Accidents") * 100, 2), '%') "Jul Percentage of Accidents",
	   concat(round(convert(float, aug_percentage."Aug Num of Accidents") / convert(float, aug_percentage."Total Accidents") * 100, 2), '%') "Aug Percentage of Accidents",
	   concat(round(convert(float, sep_percentage."Sep Num of Accidents") / convert(float, sep_percentage."Total Accidents") * 100, 2), '%') "Sep Percentage of Accidents",
	   concat(round(convert(float, oct_percentage."Oct Num of Accidents") / convert(float, oct_percentage."Total Accidents") * 100, 2), '%') "Oct Percentage of Accidents",
	   concat(round(convert(float, nov_percentage."Nov Num of Accidents") / convert(float, nov_percentage."Total Accidents") * 100, 2), '%') "Nov Percentage of Accidents",
	   concat(round(convert(float, dec_percentage."Dec Num of Accidents") / convert(float, dec_percentage."Total Accidents") * 100, 2), '%') "Dec Percentage of Accidents"
from jan_percentage,
     feb_percentage,
	 mar_percentage,
	 apr_percentage,
	 may_percentage,
	 jun_percentage,
	 jul_percentage,
	 aug_percentage,
	 sep_percentage,
	 oct_percentage,
	 nov_percentage, 
	 dec_percentage;
/*
Jan Percentage of Accidents Feb Percentage of Accidents Mar Percentage of Accidents Apr Percentage of Accidents May Percentage of Accidents Jun Percentage of Accidents Jul Percentage of Accidents Aug Percentage of Accidents Sep Percentage of Accidents Oct Percentage of Accidents Nov Percentage of Accidents Dec Percentage of Accidents
--------------------------- --------------------------- --------------------------- --------------------------- --------------------------- --------------------------- --------------------------- --------------------------- --------------------------- --------------------------- --------------------------- ---------------------------
9.66%                       8.89%                       10.53%                      8.04%                       8.28%                       8.42%                       7.92%                       7.89%                       7.87%                       8.03%                       7.36%                       7.11%
*
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
The highest percentage of accidents by month occur during the end of winter in the month of March. The percentages of accidents increase slightly through the spring season until the first month of summer season, where they begin to slightly decrease 
half way into the fall season.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

-- 2. Break down accident frequency by day of the week and by hour of the day. Based on the results, when do accidents occur most frequently? --
select top 20 m."Accident Day", 
              m."Accident Time", 
	          sum("Num of Accidents") "Total Accidents by Day and Hour"
from (select *, 
		case
			when "Accident Hour" = 0 then '12 am'
			when "Accident Hour" = 1 then '1 am'
			when "Accident Hour" = 2 then '2 am'
			when "Accident Hour" = 3 then '3 am'
			when "Accident Hour" = 4 then '4 am'
			when "Accident Hour" = 5 then '5 am'
			when "Accident Hour" = 6 then '6 am'
			when "Accident Hour" = 7 then '7 am'
			when "Accident Hour" = 8 then '8 am'
			when "Accident Hour" = 9 then '9 am'
			when "Accident Hour" = 10 then '10 am'
			when "Accident Hour" = 11 then '11 am'
			when "Accident Hour" = 12 then '12 pm'
			when "Accident Hour" = 13 then '1 pm'
			when "Accident Hour" = 14 then '2 pm'
			when "Accident Hour" = 15 then '3 pm'
			when "Accident Hour" = 16 then '4 pm'
			when "Accident Hour" = 17 then '5 pm'
			when "Accident Hour" = 18 then '6 pm'
			when "Accident Hour" = 19 then '7 pm'
			when "Accident Hour" = 20 then '8 pm'
			when "Accident Hour" = 21 then '9 pm'
			when "Accident Hour" = 22 then '10 pm'
			when "Accident Hour" = 23 then '11 pm'
			when "Accident Hour" = 24 then '12 pm'
		end as "Accident Time"
	 from (select distinct datename(dw, Date) "Accident Day",
				  datepart(hour, Time) "Accident Hour",
				  count(Collision_ID) "Num of Accidents"
		   from NYC_Collisions
           group by datename(dw, Date),
                    datepart(hour, Time)) t) m
group by m.[Accident Day],
         m.[Accident Time],
		 m.[Num of Accidents] 
order by m.[Num of Accidents] desc;
/*
Accident Day                   Accident Time Total Accidents by Day and Hour
------------------------------ ------------- -------------------------------
Friday                         5 pm          2463
Friday                         4 pm          2447
Friday                         3 pm          2386
Wednesday                      4 pm          2379
Thursday                       5 pm          2341
Thursday                       4 pm          2314
Tuesday                        5 pm          2277
Wednesday                      5 pm          2261
Tuesday                        4 pm          2253
Tuesday                        3 pm          2253
Wednesday                      3 pm          2253
Friday                         6 pm          2216
Thursday                       3 pm          2215
Friday                         2 pm          2164
Tuesday                        8 am          2154
Monday                         4 pm          2150
Wednesday                      2 pm          2143
Monday                         5 pm          2130
Thursday                       2 pm          2124
Thursday                       6 pm          2101
----------------------------------------------------------------------------------------------------------------------------------------------------------
The above results display the top 20 most frequent days and times that the most accidents occur. Fridays between 3 and 5 pm experience the most accidents.
----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

-- 3. On which particular street were the most accidents reported? What does that represent as a percentage of all reported accidents? --
 -- Top 10 Streets that Reported the Most Accidents
select top 10 Street_Name, 
       count(Street_Name) "Count of Street"
from NYC_Collisions
group by Street_Name
order by [Count of Street] desc;
/* 
Street_Name                                        Count of Street
-------------------------------------------------- ---------------
Belt Parkway                                       3728
Broadway                                           2794
Atlantic Avenue                                    2230
Long Island Expressway                             2165
Brooklyn Queens Expressway                         2159
Fdr Drive                                          1899
3 Avenue                                           1732
Grand Central Pkwy                                 1639
Cross Island Parkway                               1579
Major Deegan Expressway                            1566
-------------------------------------------------------------------------------------------
The most accidents were reported on the street Belt Parkway, with 3,728 accidents reported.
-------------------------------------------------------------------------------------------
*/
 -- Percentage of Accidents Reported on Belt Parkway to all Reported Accidents
select concat(round((convert(float, m."Belt Parkway") / convert(float, m."All Streets")) * 100, 2) * 100, '%') "Belt Parkway Percentage of all Reported Accidents"
from (select count(Street_Name) "Belt Parkway", (select count(Street_Name)
                                                 from NYC_Collisions) "All Streets"
      from NYC_Collisions
      where Street_Name = 'Belt Parkway') m;
/*
Belt Parkway Percentage of all Reported Accidents
-------------------------------------------------
157%
------------------------------------------------------------------------
As a percentage, Belt Parkway represents 157% of all accidents reported.
------------------------------------------------------------------------
*/

-- 4. What was the most common contributing factors for the accidents reported in this sample (based on motorcycles)? What about for all vehicles? --
 -- Top 10 Contributing Factors for Accidents Reported involving Motorcycles
select top 10 Contributing_Factor, 
	          count(Contributing_Factor) "Count of Contributing Factor",
	          Vehicle_Type
from NYC_Collisions
where Vehicle_Type = 'Motorcycle'
and Contributing_Factor is not null
group by Contributing_Factor,
         Vehicle_Type
order by "Count of Contributing Factor" desc;
/*
Contributing_Factor                                                                                  Count of Contributing Factor Vehicle_Type
---------------------------------------------------------------------------------------------------- ---------------------------- --------------------------------------------------
Driver Inattention/Distraction                                                                       453                          Motorcycle
Unspecified                                                                                          424                          Motorcycle
Failure to Yield Right-of-Way                                                                        145                          Motorcycle
Unsafe Speed                                                                                         130                          Motorcycle
Passing or Lane Usage Improper                                                                       111                          Motorcycle
Following Too Closely                                                                                93                           Motorcycle
Driver Inexperience                                                                                  83                           Motorcycle
Traffic Control Disregarded                                                                          77                           Motorcycle
Backing Unsafely                                                                                     66                           Motorcycle
Turning Improperly                                                                                   62                           Motorcycle
-------------------------------------------------------------------------------------------------------------------------------------------------------------
The list above indicates that the most common contributing factors for accidents reported for the vehicle type motorcycle was driver inattention/distraction.
-------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
select top 10 Contributing_Factor, 
	          count(Contributing_Factor) "Count of Contributing Factor",
	          Vehicle_Type
from NYC_Collisions
where Contributing_Factor is not null
group by Contributing_Factor,
         Vehicle_Type
order by "Count of Contributing Factor" desc;
/*
Contributing_Factor                                                                                  Count of Contributing Factor Vehicle_Type
---------------------------------------------------------------------------------------------------- ---------------------------- --------------------------------------------------
Unspecified                                                                                          50799                        Passenger Vehicle
Driver Inattention/Distraction                                                                       49219                        Passenger Vehicle
Failure to Yield Right-of-Way                                                                        13746                        Passenger Vehicle
Following Too Closely                                                                                13708                        Passenger Vehicle
Passing or Lane Usage Improper                                                                       8831                         Passenger Vehicle
Unsafe Speed                                                                                         7477                         Passenger Vehicle
Passing Too Closely                                                                                  7339                         Passenger Vehicle
Backing Unsafely                                                                                     6429                         Passenger Vehicle
Traffic Control Disregarded                                                                          5671                         Passenger Vehicle
Other Vehicular                                                                                      5460                         Passenger Vehicle
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
The most contributing factor for accidents for all vehicles was unspecified, with the vehicle type being a passenger vehicle. The second most contributing factor for accidents for all vehicles was driver inattention/distraction, with the vehicle type also 
being passenger vehicles.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

-- EDA --
 -- Count of Accidents a Year by Month
select year(Date) "Accident Year",
       sum(case when month(Date) = 1 then 1 else 0 end) Jan,
	   sum(case when month(Date) = 2 then 1 else 0 end) Feb,
	   sum(case when month(Date) = 3 then 1 else 0 end) Mar,
	   sum(case when month(Date) = 4 then 1 else 0 end) Apr,
	   sum(case when month(Date) = 5 then 1 else 0 end) May,
	   sum(case when month(Date) = 6 then 1 else 0 end) Jun,
	   sum(case when month(Date) = 7 then 1 else 0 end) Jul,
	   sum(case when month(Date) = 8 then 1 else 0 end) Aug,
	   sum(case when month(Date) = 9 then 1 else 0 end) Sep,
	   sum(case when month(Date) = 10 then 1 else 0 end) Oct,
	   sum(case when month(Date) = 11 then 1 else 0 end) Nov,
	   sum(case when month(Date) = 12 then 1 else 0 end) Dec
from NYC_Collisions
group by year(Date)
order by [Accident Year] asc;
/*
Accident Year Jan         Feb         Mar         Apr         May         Jun         Jul         Aug         Sep         Oct         Nov         Dec
------------- ----------- ----------- ----------- ----------- ----------- ----------- ----------- ----------- ----------- ----------- ----------- -----------
2021          7719        6976        8262        8752        10289       10608       10002       9880        9896        10204       9375        8583
2022          7915        7390        8856        8545        9460        9471        8870        8921        8875        8944        8168        8365
2023          7390        6841        7981        1883        0           0           0           0           0           0           0           0
*/
--select count(Collision_ID) "Num of Accidents",
--       year(Date) "Accident Year",
--	   case
--		when month(Date) = 1 then 'Jan'
--		when month(Date) = 2 then 'Feb'
--		when month(Date) = 3 then 'Mar'
--		when month(Date) = 4 then 'Apr'
--		when month(Date) = 5 then 'May'
--		when month(Date) = 6 then 'Jun'
--		when month(Date) = 7 then 'Jul'
--		when month(Date) = 8 then 'Aug'
--		when month(Date) = 9 then 'Sep'
--		when month(Date) = 10 then 'Oct'
--		when month(Date) = 11 then 'Nov'
--		when month(Date) = 12 then 'Dec'
--	   end as "Month"
--from NYC_Collisions
--group by year(Date),
--         month(Date)
--order by month(Date) asc,
--         [Accident Year] asc;

 -- Accidents by Borough
select count(Collision_ID) "Num of Accidents",
       Borough
from NYC_Collisions
where Borough is not null
group by Borough
order by [Num of Accidents] desc;
/*
Num of Accidents Borough
---------------- --------------------------------------------------
76416            Brooklyn
63751            Queens
41255            Bronx
38234            Manhattan
11568            Staten Island
---------------------------------------------------------------------------------------------------------------------------------------------------------
The most accidents occur in the borough of Brooklyn with 76,416 accidents, while the borough Staten Island has the least amount of accidents with 11,568.
---------------------------------------------------------------------------------------------------------------------------------------------------------
*/

 -- Most Common Contributing Factors by Borough
select *
from (select Contributing_Factor, Borough, count(Contributing_Factor) "Count", row_number() over(partition by Borough order by count(Contributing_Factor) desc) "Most Common Contributing Factor by Borough"
      from NYC_Collisions
      where Borough is not null
      and Contributing_Factor is not null
      group by Contributing_Factor,
               Borough) m
where m.[Most Common Contributing Factor by Borough] = 1
order by m.Count desc;
/*
Contributing_Factor                                                                                  Borough                                            Count       Most Common Contributing Factor by Borough
---------------------------------------------------------------------------------------------------- -------------------------------------------------- ----------- ------------------------------------------
Unspecified                                                                                          Brooklyn                                           21803       1
Driver Inattention/Distraction                                                                       Queens                                             15639       1
Unspecified                                                                                          Bronx                                              12177       1
Driver Inattention/Distraction                                                                       Manhattan                                          10345       1
Driver Inattention/Distraction                                                                       Staten Island                                      3511        1
*/

 -- Percentage of People Killed vs People Injured
select concat(round((convert(float, "Num of Persons Killed") / convert(float, "Num of Persons Injured")) * 100, 2), '%') "Percentage of People Killed vs Injured"
from (select sum(Persons_Injured) "Num of Persons Injured",
             sum(Persons_Killed) "Num of Persons Killed"
from NYC_Collisions
where Persons_Injured is not null) p;
/*
Percentage of People Killed vs Injured
--------------------------------------
0.55%
-------------------------------------------------------------
0.55% percent of all people injured in accidents were killed.
-------------------------------------------------------------
*/

 -- Percentage of Pedestrians Killed vs Pedestrians Injured
select concat(round((convert(float, "Num of Pedestrians Killed") / convert(float, "Num of Pedestrians Injured")) * 100, 2), '%') "Percentage of Pedestrians Killed vs Injured"
from (select sum(Pedestrians_Injured) "Num of Pedestrians Injured", (select count(Pedestrians_Killed)
                                                                     from NYC_Collisions
															         where Pedestrians_Killed = 1) "Num of Pedestrians Killed"
      from NYC_Collisions) p;
/*
Percentage of Pedestrians Killed vs Injured
-------------------------------------------
1.49%
----------------------------------------------------------
1.49% of all pedestrians injured in accidents were killed.
----------------------------------------------------------
*/

 -- Percentage of Cyclists Killed vs Cyclists Injured
select concat(round((convert(float, "Num of Cyclists Killed") / convert(float, "Num of Cyclists Injured")) * 100, 2), '%') "Percentage of Cyclists Killed vs Injured"
from (select count(Cyclists_Injured) "Num of Cyclists Injured", (select count(Cyclists_Killed)
                                                                 from NYC_Collisions
								                                 where Cyclists_Killed = 1) "Num of Cyclists Killed"
      from NYC_Collisions
      where Cyclists_Injured = 1) p;
/*
Percentage of Cyclists Killed vs Injured
----------------------------------------
0.44%
-------------------------------------------------------
0.44% of all cyclists injured in accidents were killed.
-------------------------------------------------------
*/

 -- Percentage of Motorists Killed vs Motorists Injured
select concat(round((convert(float, "Num of Motorists Killed") / convert(float, "Num of Motorists Injured")) * 100, 2), '%') "Percentage of Motorists Killed vs Injured"
from (select sum(Motorists_Injured) "Num of Motorists Injured",
             sum(Motorists_Killed) "Num of Motorists Killed"
      from NYC_Collisions) p;
/*
Percentage of Motorists Killed vs Injured
-----------------------------------------
0.33%
--------------------------------------------------------
0.33% of all motorists injured in accidents were killed.
--------------------------------------------------------
*/

 -- Persons Killed by Borough
select sum(Persons_Killed) "Num of Persons Killed",
       Borough
from NYC_Collisions
where Borough is not null
group by Borough
order by [Num of Persons Killed] desc;
/*
Num of Persons Killed Borough
--------------------- --------------------------------------------------
183                   Brooklyn
161                   Queens
124                   Bronx
105                   Manhattan
37                    Staten Island
-------------------------------------------------------
The most people were killed in the borough of Brooklyn.
-------------------------------------------------------
*/

 -- Pedestrians Killed by Borough
select count(Pedestrians_Killed) "Num of Pedestrians Killed",
Borough
from NYC_Collisions
where Pedestrians_Killed = 1
and Borough is not null
group by Borough
order by [Num of Pedestrians Killed] desc;
/*
Num of Pedestrians Killed Borough
------------------------- --------------------------------------------------
97                        Brooklyn
67                        Queens
55                        Manhattan
41                        Bronx
14                        Staten Island
------------------------------------------------------------
The most pedestrians were killed in the borough of Brooklyn.
------------------------------------------------------------
*/

 -- Cyclists Killed by Borough
select count(Cyclists_Killed) "Num of Cyclists Killed",
       Borough 
from NYC_Collisions
where Cyclists_Killed = 1
and Borough is not null
group by Borough
order by [Num of Cyclists Killed] desc;
/*
Num of Cyclists Killed Borough
---------------------- --------------------------------------------------
12                     Brooklyn
11                     Manhattan
11                     Bronx
9                      Queens
1                      Staten Island
--------------------------------------------------------------
The most cyclists were killed were in the borough of Brooklyn.
--------------------------------------------------------------
*/

 -- Motorists Killed by Borough
select sum(Motorists_Killed) "Num of Motorists Killed",
       Borough 
from NYC_Collisions
where Borough is not null
group by Borough
order by [Num of Motorists Killed] desc;
/*
Num of Motorists Killed Borough
----------------------- --------------------------------------------------
80                      Queens
62                      Bronx
59                      Brooklyn
32                      Manhattan
21                      Staten Island
--------------------------------------------------------
The most motorists were killed in the borough of Queens.
--------------------------------------------------------
*/

-- RECOMMENDATIONS: --
/* 
The highest percentage of accidents by month occur during the end of winter and gradually increase until the beginning of sumemr, while the most frequent days and times that accidents occur are on Fridays between the hours of 3 and 5pm. With this information,
perhaps the city could implement some sort of speed trap or increase police patrol to get the attention of drivers. The street Belt Parkway has the most reported accidents with 3,728 accidents and as a percentage, that represents 157% of all reported accidents.
The data indicates that the most common contributing factors for motorcycle drivers is driver inattention or distraction. The most common contributing factor for reported accidents for all vehicle types is the passenger vehicle, with driver inattention and 
distraction being the biggest cause. With this information, to possibly limit these kinds of accidents, the city could perhaps issue higher fines for drivers who are proven to be distracted. 

-- OBSERVATIONS: --

What was noticed from data is that the most accidents occur in the borough of Brooklyn with 76,416 accidents. The borough of State Island has the least amount of accidents with only 11,568. This fact could be investigated further to find out why the difference.
The data also indicates that 0.55% of all people injured in accidents were killed. 1.49% of all pedestrians injured in accidents were killed, 0.44% of all cyclists injured in accidents were killed, and 0.33% of all motorists injured in accidents were killed.
Lastly, the data tells me that the borough of brooklyn had the most people, pedestrians, and cyclists killed, while the most motorists were killed in the borough of Queens. 
*/