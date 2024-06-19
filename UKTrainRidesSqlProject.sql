/* This dataset has been retrieved from the mavenanalytics.io website. The data in this project consist of mock train data for National Rail, a company that provides 
   business services to passenger train operators in the England, Scotland, and Wales. The data also consist of the time frame for the train trips which is from December 
   of 2023 to April of 2024 and includes details on the type of ticket, the date and time for each trip, the departure and arrival stations, the ticket price, and more. 

   In this project I will I demonstrate how to use SQL to import the desired data into a created database. I will then check the data to see if any data cleaning needs to 
   take place. Following that, I will demonstrate how to check the dataset for duplicate rows as well as the number of unique and null values per column and I will extract
   the month, day, and hour values from the date columns to enhance my analysis. Lastly, I've been tasked by my manager to answer some business questions for the company 
   National Rail.

   QUESTIONS:
   1) Can you identify the most popular routes?
   2) Can you determine peak travel times?
   3) Can you analyze revenue from different ticket types and classes?
   4) Diagnose on-time performance and contributing factors?
*/

/* I will check the first and last 5 rows of the data for consistency. */

---------------------------
-- First 5 Rows of Data --
---------------------------
select top 5 * 
from railway;
/* (5 rows affected)
Transaction_ID                 Date_of_Purchase    Time_of_Purchase    Purchase_Type         Payment_Method         Railcard         Ticket_Class        Ticket_Type        Price    Departure_Station           Arrival_Destination          Date_of_Journey   Departure_Time     Arrival_Time       Actual_Arrival_Time   Journey_Status     Reason_for_Delay      Refund_Request
-------------------------------------------------- ---------------- ---------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ---------------------- ---------
da8a6ba8-b3dc-4677-b176        2023-12-08          12:41:11.0000000    Online                Contactless            Adult            Standard            Advance            43       London Paddington           Liverpool Lime Street        2024-01-01        11:00:00.0000000   13:30:00.0000000   13:30:00.0000000      On Time            NULL                  0
b0cdd1b0-f214-4197-be53        2023-12-16          11:23:01.0000000    Station               Credit Card            Adult            Standard            Advance            23       London Kings Cross          York                         2024-01-01        09:45:00.0000000   11:35:00.0000000   11:40:00.0000000      Delayed            Signal Failure        0
f3ba7a96-f713-40d9-9629        2023-12-19          19:51:27.0000000    Online                Credit Card            None             Standard            Advance            3        Liverpool Lime Street       Manchester Piccadilly        2024-01-02        18:15:00.0000000   18:45:00.0000000   18:45:00.0000000      On Time            NULL                  0
b2471f11-4fe7-4c87-8ab4        2023-12-20          23:00:36.0000000    Station               Credit Card            None             Standard            Advance            13       London Paddington           Reading                      2024-01-01        21:30:00.0000000   22:30:00.0000000   22:30:00.0000000      On Time            NULL                  0
2be00b45-0762-485e-a7a3        2023-12-27          18:22:56.0000000    Online                Contactless            None             Standard            Advance            76       Liverpool Lime Street       London Euston                2024-01-01        16:45:00.0000000   19:00:00.0000000   19:00:00.0000000      On Time            NULL                  0
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
--------------------------
-- Last 5 Rows of Data --
--------------------------
select top 5 * 
from railway
order by Date_of_Purchase desc;
/* (5 rows affected)
Transaction_ID                  Date_of_Purchase   Time_of_Purchase   Purchase_Type      Payment_Method       Railcard      Ticket_Class      Ticket_Type      Price    Departure_Station        Arrival_Destination        Date_of_Journey   Departure_Time     Arrival_Time       Actual_Arrival_Time   Journey_Status     Reason_for_Delay    Refund_Request
-------------------------------------------------- ---------------- ---------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ------------
d1ec6548-de18-43c9-92d1         2024-04-30         00:06:03.0000000   Station            Credit Card          None          Standard          Off-Peak         10       London Euston            Birmingham New Street      2024-04-30        22:30:00.0000000   23:50:00.0000000   23:50:00.0000000      On Time            NULL                0
afd42c55-5f1c-4def-b075         2024-04-30         00:20:19.0000000   Station            Contactless          None          Standard          Off-Peak         53       London Kings Cross       York                       2024-04-30        01:45:00.0000000   03:35:00.0000000   03:35:00.0000000      On Time            NULL                0
f238de9e-e897-4a2f-ab9a         2024-04-30         00:20:58.0000000   Station            Contactless          None          Standard          Off-Peak         53       London Kings Cross       York                       2024-04-30        01:45:00.0000000   03:35:00.0000000   03:35:00.0000000      On Time            NULL                0
e1e28872-5b7e-4b19-b5b8         2024-04-30         00:23:48.0000000   Station            Contactless          None          Standard          Off-Peak         53       London Kings Cross       York                       2024-04-30        01:45:00.0000000   03:35:00.0000000   03:35:00.0000000      On Time            NULL                0
2d570cac-7fa5-4389-8d00         2024-04-30         00:33:33.0000000   Online             Credit Card          None          Standard          Off-Peak         17       Manchester Piccadilly    Nottingham                 2024-04-30        02:00:00.0000000   03:00:00.0000000   03:00:00.0000000      On Time            NULL                0
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/* Now I will check the dataset for any duplicate rows of data. */
----------------------------
--Checking for Duplicates --
----------------------------
select *
from (select *, row_number() over(partition by Transaction_ID order by Date_of_Purchase asc) "duplicate rows of data"
      from railway) d
where d.[duplicate rows of data] >= 2;
/*
(0 rows affected)
-------------------------------------------------------
-- There are 0 rows of duplicated data in this dataset.
-------------------------------------------------------
*/

/* Now I'll check the number of null values in each column of the dataset. */
--------------------------------------------------
-- Checking the Number of Nulls in each Column --
--------------------------------------------------
select count(*) from railway
where Transaction_ID is null;
-------------------------------------------------------
--There are 0 null values in the column Transaction_Id
-------------------------------------------------------
select count(*) from railway
where Date_of_Purchase is null;
---------------------------------------------------------
--There are 0 null values in the column Date_of_Purchase
---------------------------------------------------------
select count(*) from railway
where Time_of_Purchase is null;
--------------------------------------------------------
--There are 0 null values in the column Time_of_Purchase
--------------------------------------------------------
select count(*) from railway
where Purchase_Type is null;
-------------------------------------------------------
--There are 0 null values in the column Purchase_Type
-------------------------------------------------------
select count(*) from railway
where Payment_Method is null;
-------------------------------------------------------
--There are 0 null values in the column Payment_Method
-------------------------------------------------------
select count(*) from railway
where Railcard is null;
--------------------------------------------------
--There are 0 null values in the column Railcard
--------------------------------------------------
select count(*) from railway
where Ticket_Class is null;
-------------------------------------------------------
--There are 0 null values in the column Ticket_Class
-------------------------------------------------------
select count(*) from railway
where Ticket_Type is null;
-------------------------------------------------------
--There are 0 null values in the column Ticket_Class
-------------------------------------------------------
select count(*) from railway
where Price is null;
----------------------------------------------
--There are 0 null values in the column Price
----------------------------------------------
select count(*) from railway
where Departure_Station is null;
----------------------------------------------------------
--There are 0 null values in the column Departure_Station
----------------------------------------------------------
select count(*) from railway
where Arrival_Destination is null;
-----------------------------------------------------------
--There are 0 null values in the column Arrival_Destination
-----------------------------------------------------------
select count(*) from railway
where Date_of_Journey is null;
-------------------------------------------------------
--There are 0 null values in the column Date_of_Journey
-------------------------------------------------------
select count(*) from railway
where Departure_Time is null;
-------------------------------------------------------
--There are 0 null values in the column Departure_Time
-------------------------------------------------------
select count(*) from railway
where Arrival_Time is null;
-------------------------------------------------------
--There are 0 null values in the column Arrival_Time
-------------------------------------------------------
select count(*) from railway
where Actual_Arrival_Time is null;
---------------------------------------------------------------
--There are 1880 null values in the column Actual_Arrival_Time
---------------------------------------------------------------
select count(*) from railway
where Journey_Status is null;
-------------------------------------------------------
--There are 0 null values in the column Journey_Status
-------------------------------------------------------
select count(*) from railway
where Reason_for_Delay is null;
------------------------------------------------------------
--There are 27481 null values in the column Reason_for_Delay
------------------------------------------------------------
select count(*) from railway
where Refund_Request is null;
-------------------------------------------------------
--There are 0 null values in the column Refund_Request
-------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
-- A couple columns hava a significant amount of null values. However, those values will not effect my analysis.
----------------------------------------------------------------------------------------------------------------

/* Now I will move on to checking the number of unique values in each column. */
------------------------------------------
-- Checking the Number of Unique Values --
------------------------------------------
select count(distinct Transaction_ID) from railway;
-----------------------------------------------------
-- There are 31653 unique Transaction_ID in the table
-----------------------------------------------------
select count(distinct Date_of_Purchase) from railway;
-----------------------------------------------------
-- There are 128 unique Date_of_Purchase in the table
-----------------------------------------------------
select count(distinct Time_of_Purchase) from railway;
-------------------------------------------------------
-- There are 24351 unique Time_of_Purchase in the table
-------------------------------------------------------
select count(distinct Purchase_Type) from railway;
-----------------------------------------------------
-- There are 2 unique Purchase_Type in the table
-----------------------------------------------------
select count(distinct Payment_Method) from railway;
--------------------------------------------------
-- There are 3 unique Payment_Method in the table
--------------------------------------------------
select count(distinct Railcard) from railway;
--------------------------------------------
-- There are 4 unique Railcaed in the table
--------------------------------------------
select count(distinct Ticket_Class) from railway;
------------------------------------------------
-- There are 2 unique Ticket_Class in the table
------------------------------------------------
select count(distinct Ticket_Type) from railway;
-----------------------------------------------
-- There are 3 unique Ticket_Type in the table
-----------------------------------------------
select count(distinct Price) from railway;
------------------------------------------
-- There are 125 unique Price in the table
------------------------------------------
select count(distinct Departure_Station) from railway;
-----------------------------------------------------
-- There are 12 unique Departure_Station in the table
-----------------------------------------------------
select count(distinct Arrival_Destination) from railway;
-------------------------------------------------------
-- There are 32 unique Arrival_Destination in the table
-------------------------------------------------------
select count(distinct Date_of_Journey) from railway;
-----------------------------------------------------
-- There are 121 unique Date_of_Journey in the table
-----------------------------------------------------
select count(distinct Departure_Time) from railway;
-----------------------------------------------------
-- There are 96 unique Departure_Time in the table
-----------------------------------------------------
select count(distinct Arrival_Time) from railway;
-------------------------------------------------
-- There are 203 unique Arrival_Time in the table
-------------------------------------------------
select count(distinct Actual_Arrival_Time) from railway;
--------------------------------------------------------
-- There are 623 unique Actual_Arrival_Time in the table
--------------------------------------------------------
select count(distinct Journey_Status) from railway;
-------------------------------------------------
-- There are 3 unique Journey_Status in the table
-------------------------------------------------
select count(distinct Reason_for_Delay) from railway;
-----------------------------------------------------
-- There are 7 unique Reason_for_Delay in the table
-----------------------------------------------------
select count(distinct Refund_Request) from railway;
-------------------------------------------------
-- There are 2 unique Refund_Request in the table
-------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
-- Now that I have examined the data and have a better understanding of it, I will now move on to answering the business questions.
------------------------------------------------------------------------------------------------------------------------------------

/* 
QUESTIONS:
	1) Can you identify the most popular routes?
-- Top 10 Most Popular Routes --
*/
select top 10 m.Departure_Station,
           m.Arrival_Destination, 
	       max(m."Most_Popular_Routes") "Popular_Routes"
from (select *, row_number() over(partition by Departure_Station, Arrival_Destination order by Date_of_Purchase asc) "Most_Popular_Routes"
      from railway) m
group by m.Departure_Station,
         m.Arrival_Destination
order by max(m."Most_Popular_Routes") desc;
/* (10 rows affected)
Departure_Station                                  Arrival_Destination                                Popular_Routes
-------------------------------------------------- -------------------------------------------------- --------------------
Manchester Piccadilly                              Liverpool Lime Street                              4628
London Euston                                      Birmingham New Street                              4209
London Kings Cross                                 York                                               3922
London Paddington                                  Reading                                            3873
London St Pancras                                  Birmingham New Street                              3471
Liverpool Lime Street                              Manchester Piccadilly                              3002
Liverpool Lime Street                              London Euston                                      1097
London Euston                                      Manchester Piccadilly                              712
Birmingham New Street                              London St Pancras                                  702
London Paddington                                  Oxford                                             485
--------------------------------------------------------------------------------------------------------------------------
The above results are the top 10 most popular routes with Manchester Piccadilly to Liverpooll Lime Street being the most 
popular with 4,628 journeys.
--------------------------------------------------------------------------------------------------------------------------
*/

/*
	2) Can you determine peak travel times?
*/
-- Top 6 travel hours by month --
select pr.[Month of Journey],
       pr.[Departure Time],
	   pr.[Count of Departure Time],
	   case
		when pr.[Month of Journey] = 1 then 'Janurary'
		when pr.[Month of Journey] = 2 then 'Feburary'
		when pr.[Month of Journey] = 3 then 'March'
		when pr.[Month of Journey] = 4 then 'April'
	   end as "Month"
from (select *, row_number() over(partition by "Month of Journey" order by "Count of Departure Time" desc) " Top Peak Hours"
      from (select month(Date_of_Journey) "Month of Journey",
	               datepart(hour, Departure_Time) "Departure Time",
	               count(datepart(hour, Departure_Time)) "Count of Departure Time"
            from railway
            group by month(Date_of_Journey),
                     datepart(hour, Departure_Time)) p) pr
where pr.[ Top Peak Hours] <= 6;
/* (24 rows affected)
Month of Journey Departure Time Count of Departure Time Month
---------------- -------------- ----------------------- --------
1                6              824                     Janurary
1                18             783                     Janurary
1                7              737                     Janurary
1                17             707                     Janurary
1                16             606                     Janurary
1                8              568                     Janurary
2                6              773                     Feburary
2                18             730                     Feburary
2                17             716                     Feburary
2                7              687                     Feburary
2                16             513                     Feburary
2                8              510                     Feburary
3                18             817                     March
3                6              809                     March
3                17             743                     March
3                7              710                     March
3                16             600                     March
3                8              554                     March
4                18             783                     April
4                17             722                     April
4                6              706                     April
4                7              661                     April
4                16             582                     April
4                8              547                     April
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
During the months of January and Feburary, the 6 most frequent travel times were 6am, 7am, 8am, 4pm, 5pm, and 6pm with the 6am hour experiencing the most number of journey's. During the months of 
March and April, the 6 most frequent travel times were also 6am, 7am, 8am, 4pm, 5pm, and 6pm. During these two months, the 6pm hour experienced the most number of journey's.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
	3) Can you analyze revenue from different ticket types and classes?
*/
--0 Total Revenu by Ticket Type and Ticket Class --
select sum(Price) "Total Revenue",
       Ticket_Type,
	   Ticket_Class
from railway
group by Ticket_Type,
         Ticket_Class
order by [Total Revenue] desc,
         Ticket_Class asc;
/* (6 rows affected)
Total Revenue          Ticket_Type                                        Ticket_Class
---------------------- -------------------------------------------------- --------------------------------------------------
242388                 Advance                                            Standard
178666                 Off-Peak                                           Standard
171468                 Anytime                                            Standard
66886                  Advance                                            First Class
44672                  Off-Peak                                           First Class
37841                  Anytime                                            First Class
---------------------------------------------------------------------------------------------------------------------------
The Advance Ticket_Type and along with the Standard Ticket_Class has produced the highest revenue with $242,386. While the 
Anytime Ticket_Type with the First Class Ticket_Class has produced the lowest revenue with $37,841.
---------------------------------------------------------------------------------------------------------------------------
*/
-- Total Revenue by Ticket_Type --
select sum(Price) "Total Revenue",
       Ticket_Type
from railway
group by Ticket_Type
order by [Total Revenue] desc,
         Ticket_Type asc;
/* (3 rows affected)
Total Revenue          Ticket_Type
---------------------- --------------------------------------------------
309274                 Advance
223338                 Off-Peak
209309                 Anytime
---------------------------------------------------------------------------------------------------------
The Advanced Ticket_Type generates the most revenue of all Ticket_Types with a total revenue of $309,274.
---------------------------------------------------------------------------------------------------------
*/
-- Total Revenue by Ticket_Class --
select sum(Price) "Total Revenue",
	   Ticket_Class
from railway
group by Ticket_Class
order by [Total Revenue] desc,
         Ticket_Class asc;
/* (2 rows affected)
Total Revenue          Ticket_Class
---------------------- --------------------------------------------------
592522                 Standard
149399                 First Class
-------------------------------------------------------------------------------------------------------------------------------
The Standard Ticket_Class generates the highest amount of revenue between both ticket classes with a total revenue of $592,522.
-------------------------------------------------------------------------------------------------------------------------------
*/

/*
	4) Diagnose on-time performance and contributing factors?
*/
select Journey_Status,
       count(Reason_for_Delay) "Count of Status", 
	   Reason_for_Delay
from railway
where Reason_for_Delay is not null
group by Journey_Status, 
         Reason_for_Delay
order by [Count of Status] desc;
/* (14 rows affected)
Journey_Status                                     Count of Status Reason_for_Delay
-------------------------------------------------- --------------- --------------------------------------------------
Delayed                                            758             Weather
Cancelled                                          519             Signal Failure
Delayed                                            472             Technical Issue
Delayed                                            451             Signal Failure
Cancelled                                          238             Staffing
Cancelled                                          237             Weather
Cancelled                                          235             Technical Issue
Cancelled                                          227             Traffic
Cancelled                                          216             Staff Shortage
Cancelled                                          208             Weather Conditions
Delayed                                            183             Staff Shortage
Delayed                                            172             Staffing
Delayed                                            169             Weather Conditions
Delayed                                            87              Traffic
------------------------------------------------------------------------------------------------------------------------------------------
The most number of journey's delayed was 758, which have been delayed due to weather. While the least number of journey's delayed was 87, 
with the reason for delay being due to traffic. The most number of journeys cancelled were 281 which were due to signal failure. While the
least number of journey's cancelled were 208, being cancelled due to weather conditions.
------------------------------------------------------------------------------------------------------------------------------------------
*/             
