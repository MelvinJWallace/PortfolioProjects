/* 
This is a project that I will be completing utilizing SQL. The dataset used for this project is the Chicago Traffic Crashes dataset, which was retrieved from the Kaggle website consisting of traffic accidents in the city of chicago from the years 
2013 through 2024. In this project, I will query information that can be used to create a Chicago Accident Dashboard. 

Questions: 

	1) How many total accidents have been recorded? By year, month, and day?
	2) What years have the most fatal injuries happen in?
	3) What is the most common weather condition for all accidents? By year, month, and day?
	4) What is the most common weather condition for all fatal accidents by year, month, and day?
	5) What is the most common crash type for all accidents? By year, month, and day?
	6) What is the most common crash type for fatal accidents? By year, month, and day?
	7) What is the most common roadway surface condition for accidents? By year, month, and day?
	8) What is the most common roadway surface condition for fatal accidents? By year, month, and day?
	9) What is the count of damage by year?
	10) What is the average time from accident to police notification?
	11) What is the most common primary contributory cause in all accidents? By year, month, and day?
	12) What is the count of the most severe injury? By year, month, and day?

Requirements:

	1) Primary KPI - Total accident values for current year and year over year growth.
	2) Primary KP1 - Total accident severity for current year and year over year growth.
	3) Secondary KPI - Total accidents with respect to speed limit.
	4) Accidents by road type for current year.
	5) Current year accidents by weather condition.


*/ 

-- So now that I have the data loaded into my database, I can now preview the first and last 5 rows of data to check for consistency
-- First 5 rows of dataset --
select top 5 *
from Chicago_Traffic_Crashes;
/*
CRASH_RECORD_ID                                                                                                                                        CRASH_DATE_EST_I                                   CRASH_DATE                  POSTED_SPEED_LIMIT TRAFFIC_CONTROL_DEVICE                             DEVICE_CONDITION                                   WEATHER_CONDITION                                  LIGHTING_CONDITION                                 FIRST_CRASH_TYPE                                   TRAFFICWAY_TYPE                                    LANE_CNT    ALIGNMENT                                          ROADWAY_SURFACE_COND                               ROAD_DEFECT                                        REPORT_TYPE                                        CRASH_TYPE                                         INTERSECTION_RELATED_I NOT_RIGHT_OF_WAY_I HIT_AND_RUN_I DAMAGE                                             DATE_POLICE_NOTIFIED        PRIM_CONTRIBUTORY_CAUSE                                                                              SEC_CONTRIBUTORY_CAUSE                                                                               STREET_NO   STREET_DIRECTION                                   STREET_NAME                                        BEAT_OF_OCCURRENCE PHOTOS_TAKEN_I STATEMENTS_TAKEN_I DOORING_I WORK_ZONE_I WORK_ZONE_TYPE                                     WORKERS_PRESENT_I                                  NUM_UNITS   MOST_SEVERE_INJURY                                 INJURIES_TOTAL INJURIES_FATAL INJURIES_INCAPACITATING INJURIES_NON_INCAPACITATING INJURIES_REPORTED_NOT_EVIDENT INJURIES_NO_INDICATION INJURIES_UNKNOWN CRASH_HOUR  CRASH_DAY_OF_WEEK CRASH_MONTH LATITUDE               LONGITUDE              LOCATION
------------------------------------------------------------------------------------------------------------------------------------------------------ -------------------------------------------------- --------------------------- ------------------ -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ----------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ---------------------- ------------------ ------------- -------------------------------------------------- --------------------------- ---------------------------------------------------------------------------------------------------- ---------------------------------------------------------------------------------------------------- ----------- -------------------------------------------------- -------------------------------------------------- ------------------ -------------- ------------------ --------- ----------- -------------------------------------------------- -------------------------------------------------- ----------- -------------------------------------------------- -------------- -------------- ----------------------- --------------------------- ----------------------------- ---------------------- ---------------- ----------- ----------------- ----------- ---------------------- ---------------------- --------------------------------------------------
23a79931ef555d54118f64dc9be2cf2dbf59636ce253f7a1179c4a1c091442a6eeab8352220c7c56ca1ff7c4b4b0fc345c74e3e85ecb9d43deeb66b5f803d4a0                       NULL                                               2023-09-05 19:05:00.0000000 30                 TRAFFIC SIGNAL                                     FUNCTIONING PROPERLY                               CLEAR                                              DUSK                                               ANGLE                                              FIVE POINT, OR MORE                                NULL        STRAIGHT AND LEVEL                                 DRY                                                NO DEFECTS                                         ON SCENE                                           INJURY AND / OR TOW DUE TO CRASH                   1                      NULL               NULL          OVER $1,500                                        2023-09-05 19:05:00.0000000 UNABLE TO DETERMINE                                                                                  NOT APPLICABLE                                                                                       5500        S                                                  WENTWORTH AVE                                      225                NULL           NULL               NULL      NULL        NULL                                               NULL                                               2           INCAPACITATING INJURY                              3              0              1                       2                           0                             2                      0                19          3                 9           NULL                   NULL                   NULL
2675c13fd0f474d730a5b780968b3cafc7c12d7adb661fa8a3093c0658d5a0d51b720fc9e031a1ddd83c761a8e2aa7283573557db246f4c9e956aaa58719cacf                       NULL                                               2023-09-22 18:45:00.0000000 50                 NO CONTROLS                                        NO CONTROLS                                        CLEAR                                              DARKNESS, LIGHTED ROAD                             REAR END                                           DIVIDED - W/MEDIAN BARRIER                         NULL        STRAIGHT AND LEVEL                                 DRY                                                NO DEFECTS                                         ON SCENE                                           NO INJURY / DRIVE AWAY                             NULL                   NULL               NULL          OVER $1,500                                        2023-09-22 18:50:00.0000000 FOLLOWING TOO CLOSELY                                                                                FOLLOWING TOO CLOSELY                                                                                7900        S                                                  CHICAGO SKYWAY OB                                  411                NULL           NULL               NULL      NULL        NULL                                               NULL                                               2           NO INDICATION OF INJURY                            0              0              0                       0                           0                             2                      0                18          6                 9           NULL                   NULL                   NULL
5f54a59fcb087b12ae5b1acff96a3caf4f2d37e79f8db4106558b34b8a6d2b81af02cf91b576ecd7ced08ffd10fcfd940a84f7613125b89d33636e6075064e22                       NULL                                               2023-07-29 14:45:00.0000000 30                 TRAFFIC SIGNAL                                     FUNCTIONING PROPERLY                               CLEAR                                              DAYLIGHT                                           PARKED MOTOR VEHICLE                               DIVIDED - W/MEDIAN (NOT RAISED)                    NULL        STRAIGHT AND LEVEL                                 DRY                                                NO DEFECTS                                         ON SCENE                                           NO INJURY / DRIVE AWAY                             NULL                   NULL               1             OVER $1,500                                        2023-07-29 14:45:00.0000000 FAILING TO REDUCE SPEED TO AVOID CRASH                                                               OPERATING VEHICLE IN ERRATIC, RECKLESS, CARELESS, NEGLIGENT OR AGGRESSIVE MANNER                     2101        S                                                  ASHLAND AVE                                        1235               NULL           NULL               NULL      NULL        NULL                                               NULL                                               4           NO INDICATION OF INJURY                            0              0              0                       0                           0                             1                      0                14          7                 7           41.8541221618652       -87.665901184082       POINT (-87.665902342962 41.854120262952)
7ebf015016f83d09b321afd671a836d6b148330535d5df85f232edb575a7f2a42e61b9747067e89c4e7a73e69efc819c9003ed153e19765f2ecc6f7b2421c98d                       NULL                                               2023-08-09 23:00:00.0000000 30                 NO CONTROLS                                        NO CONTROLS                                        CLEAR                                              DARKNESS, LIGHTED ROAD                             SIDESWIPE SAME DIRECTION                           NOT DIVIDED                                        NULL        STRAIGHT AND LEVEL                                 DRY                                                NO DEFECTS                                         ON SCENE                                           NO INJURY / DRIVE AWAY                             NULL                   NULL               NULL          OVER $1,500                                        2023-08-09 23:40:00.0000000 FAILING TO YIELD RIGHT-OF-WAY                                                                        NOT APPLICABLE                                                                                       10020       W                                                  BALMORAL AVE                                       1650               NULL           NULL               NULL      NULL        NULL                                               NULL                                               2           NO INDICATION OF INJURY                            0              0              0                       0                           0                             2                      0                23          4                 8           NULL                   NULL                   NULL
6c1659069e9c6285a650e70d6f9b574ed5f64c12888479093dfeef179c0344ec6d2057eae224b5c0d5dfc278c0a237f8c22543f07fdef2e4a95a3849871c9345                       NULL                                               2023-08-18 12:50:00.0000000 15                 OTHER                                              FUNCTIONING PROPERLY                               CLEAR                                              DAYLIGHT                                           REAR END                                           OTHER                                              NULL        STRAIGHT AND LEVEL                                 DRY                                                NO DEFECTS                                         ON SCENE                                           INJURY AND / OR TOW DUE TO CRASH                   NULL                   NULL               NULL          OVER $1,500                                        2023-08-18 12:55:00.0000000 FOLLOWING TOO CLOSELY                                                                                DISTRACTION - FROM INSIDE VEHICLE                                                                    700         W                                                  OHARE ST                                           1654               NULL           NULL               NULL      NULL        NULL                                               NULL                                               2           NONINCAPACITATING INJURY                           1              0              0                       1                           0                             1                      0                12          6                 8           NULL                   NULL                   NULL
*/
-- Last 5 rows of dataset --
select top 5 *
from Chicago_Traffic_Crashes
order by CRASH_RECORD_ID desc;
/*
CRASH_RECORD_ID                                                                                                                                        CRASH_DATE_EST_I                                   CRASH_DATE                  POSTED_SPEED_LIMIT TRAFFIC_CONTROL_DEVICE                             DEVICE_CONDITION                                   WEATHER_CONDITION                                  LIGHTING_CONDITION                                 FIRST_CRASH_TYPE                                   TRAFFICWAY_TYPE                                    LANE_CNT    ALIGNMENT                                          ROADWAY_SURFACE_COND                               ROAD_DEFECT                                        REPORT_TYPE                                        CRASH_TYPE                                         INTERSECTION_RELATED_I NOT_RIGHT_OF_WAY_I HIT_AND_RUN_I DAMAGE                                             DATE_POLICE_NOTIFIED        PRIM_CONTRIBUTORY_CAUSE                                                                              SEC_CONTRIBUTORY_CAUSE                                                                               STREET_NO   STREET_DIRECTION                                   STREET_NAME                                        BEAT_OF_OCCURRENCE PHOTOS_TAKEN_I STATEMENTS_TAKEN_I DOORING_I WORK_ZONE_I WORK_ZONE_TYPE                                     WORKERS_PRESENT_I                                  NUM_UNITS   MOST_SEVERE_INJURY                                 INJURIES_TOTAL INJURIES_FATAL INJURIES_INCAPACITATING INJURIES_NON_INCAPACITATING INJURIES_REPORTED_NOT_EVIDENT INJURIES_NO_INDICATION INJURIES_UNKNOWN CRASH_HOUR  CRASH_DAY_OF_WEEK CRASH_MONTH LATITUDE               LONGITUDE              LOCATION
------------------------------------------------------------------------------------------------------------------------------------------------------ -------------------------------------------------- --------------------------- ------------------ -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ----------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ---------------------- ------------------ ------------- -------------------------------------------------- --------------------------- ---------------------------------------------------------------------------------------------------- ---------------------------------------------------------------------------------------------------- ----------- -------------------------------------------------- -------------------------------------------------- ------------------ -------------- ------------------ --------- ----------- -------------------------------------------------- -------------------------------------------------- ----------- -------------------------------------------------- -------------- -------------- ----------------------- --------------------------- ----------------------------- ---------------------- ---------------- ----------- ----------------- ----------- ---------------------- ---------------------- --------------------------------------------------
ffffe577251dc1cc67f2f823b595e5028427a210e2a40e7a1240f09533d35f33353f94dab96310e9fd80ed126c2190487b78c7709cb39550201e63df40532e54                       NULL                                               2020-02-20 08:00:00.0000000 30                 TRAFFIC SIGNAL                                     FUNCTIONING PROPERLY                               CLEAR                                              DAYLIGHT                                           TURNING                                            NOT DIVIDED                                        NULL        STRAIGHT AND LEVEL                                 DRY                                                NO DEFECTS                                         ON SCENE                                           NO INJURY / DRIVE AWAY                             NULL                   NULL               1             $501 - $1,500                                      2020-02-20 08:05:00.0000000 FAILING TO YIELD RIGHT-OF-WAY                                                                        IMPROPER OVERTAKING/PASSING                                                                          1600        N                                                  HALSTED ST                                         1813               NULL           NULL               NULL      NULL        NULL                                               NULL                                               2           NO INDICATION OF INJURY                            0              0              0                       0                           0                             2                      0                8           5                 2           41.9109420776367       -87.6484222412109      POINT (-87.64841904273 41.910940643916)
ffffe467b0d2d95c897e8c2721941f87dede1661a3b60ce3dc1002fd6d39bbc83c905a714cedd434a82ed26c76e69efbe8cfba009e58f0e166b175a912759231                       NULL                                               2018-07-19 15:40:00.0000000 30                 UNKNOWN                                            UNKNOWN                                            UNKNOWN                                            UNKNOWN                                            SIDESWIPE SAME DIRECTION                           NOT DIVIDED                                        NULL        STRAIGHT AND LEVEL                                 UNKNOWN                                            UNKNOWN                                            NOT ON SCENE (DESK REPORT)                         NO INJURY / DRIVE AWAY                             NULL                   NULL               NULL          OVER $1,500                                        2018-07-19 16:30:00.0000000 UNABLE TO DETERMINE                                                                                  NOT APPLICABLE                                                                                       400         W                                                  BELMONT AVE                                        1925               NULL           NULL               NULL      NULL        NULL                                               NULL                                               2           NO INDICATION OF INJURY                            0              0              0                       0                           0                             2                      0                15          5                 7           41.940242767334        -87.6396408081055      POINT (-87.639639114276 41.940241193256)
ffffd143cf6dc784876069140869d2d7240800894501081aee054006bfb707114f666b4fdc03a4398a71da0552ef6461b3bbd20cb1c05facf1ea14b854ffeaec                       NULL                                               2022-12-24 19:10:00.0000000 30                 NO CONTROLS                                        NO CONTROLS                                        SNOW                                               DARKNESS, LIGHTED ROAD                             SIDESWIPE SAME DIRECTION                           DIVIDED - W/MEDIAN (NOT RAISED)                    NULL        STRAIGHT AND LEVEL                                 SNOW OR SLUSH                                      UNKNOWN                                            NOT ON SCENE (DESK REPORT)                         NO INJURY / DRIVE AWAY                             NULL                   NULL               1             OVER $1,500                                        2022-12-24 20:15:00.0000000 IMPROPER LANE USAGE                                                                                  UNABLE TO DETERMINE                                                                                  4100        S                                                  WABASH AVE                                         213                NULL           NULL               NULL      NULL        NULL                                               NULL                                               2           NO INDICATION OF INJURY                            0              0              0                       0                           0                             2                      0                19          7                 12          41.8200340270996       -87.624885559082       POINT (-87.624889061275 41.820034136833)
ffffc802346fd6f48f99117898fbc558237a3052c327b875d4dabc837f7e59680b6fafaddf58d95ac0a0e8406f4b7f2024f0cc8517739756ac043a756ccb0b11                       NULL                                               2020-07-28 07:30:00.0000000 30                 NO CONTROLS                                        NO CONTROLS                                        CLEAR                                              DAYLIGHT                                           HEAD ON                                            NOT DIVIDED                                        NULL        STRAIGHT AND LEVEL                                 DRY                                                NO DEFECTS                                         ON SCENE                                           INJURY AND / OR TOW DUE TO CRASH                   NULL                   NULL               NULL          OVER $1,500                                        2020-07-28 07:38:00.0000000 UNDER THE INFLUENCE OF ALCOHOL/DRUGS (USE WHEN ARREST IS EFFECTED)                                   PHYSICAL CONDITION OF DRIVER                                                                         922         N                                                  HOMAN AVE                                          1121               NULL           NULL               NULL      NULL        NULL                                               NULL                                               2           REPORTED, NOT EVIDENT                              1              0              0                       0                           1                             2                      0                7           3                 7           41.8979454040527       -87.7116622924805      POINT (-87.711661384741 41.897943912705)
ffffc784918a94c6d5ec9cdced500004faafc6a9e6e01b4ee4c6e5dd9f9f1a29faa55f329086abe588ecbd3ec14e13914f936aaadf417971bd9c924f5d2bdf03                       NULL                                               2020-09-29 11:45:00.0000000 30                 NO CONTROLS                                        NO CONTROLS                                        CLEAR                                              DAYLIGHT                                           PARKED MOTOR VEHICLE                               NOT DIVIDED                                        NULL        STRAIGHT AND LEVEL                                 DRY                                                NO DEFECTS                                         NOT ON SCENE (DESK REPORT)                         NO INJURY / DRIVE AWAY                             NULL                   NULL               NULL          $501 - $1,500                                      2020-10-08 15:26:00.0000000 NOT APPLICABLE                                                                                       NOT APPLICABLE                                                                                       4309        S                                                  ARCHER AVE                                         922                NULL           NULL               NULL      NULL        NULL                                               NULL                                               2           NO INDICATION OF INJURY                            0              0              0                       0                           0                             1                      0                11          3                 9           41.8151588439941       -87.7022705078125      POINT (-87.702273174906 41.81515906522)
*/

/* This dataset has a few columns with null values. However, for this analysis it will not be neccessary to remove them.

   I will now check the dataset for any duplicate rows of data
*/

-- Checking for duplicate rows of data --
select *
from (select *, row_number() over(partition by CRASH_RECORD_ID order by CRASH_DATE asc) "Duplicate Rows of Data"
      from Chicago_Traffic_Crashes) d
where d.[Duplicate Rows of Data] >= 2;
/*
CRASH_RECORD_ID                                                                                                                                        CRASH_DATE_EST_I                                   CRASH_DATE                  POSTED_SPEED_LIMIT TRAFFIC_CONTROL_DEVICE                             DEVICE_CONDITION                                   WEATHER_CONDITION                                  LIGHTING_CONDITION                                 FIRST_CRASH_TYPE                                   TRAFFICWAY_TYPE                                    LANE_CNT    ALIGNMENT                                          ROADWAY_SURFACE_COND                               ROAD_DEFECT                                        REPORT_TYPE                                        CRASH_TYPE                                         INTERSECTION_RELATED_I NOT_RIGHT_OF_WAY_I HIT_AND_RUN_I DAMAGE                                             DATE_POLICE_NOTIFIED        PRIM_CONTRIBUTORY_CAUSE                                                                              SEC_CONTRIBUTORY_CAUSE                                                                               STREET_NO   STREET_DIRECTION                                   STREET_NAME                                        BEAT_OF_OCCURRENCE PHOTOS_TAKEN_I STATEMENTS_TAKEN_I DOORING_I WORK_ZONE_I WORK_ZONE_TYPE                                     WORKERS_PRESENT_I                                  NUM_UNITS   MOST_SEVERE_INJURY                                 INJURIES_TOTAL INJURIES_FATAL INJURIES_INCAPACITATING INJURIES_NON_INCAPACITATING INJURIES_REPORTED_NOT_EVIDENT INJURIES_NO_INDICATION INJURIES_UNKNOWN CRASH_HOUR  CRASH_DAY_OF_WEEK CRASH_MONTH LATITUDE               LONGITUDE              LOCATION                                           Duplicate Rows of Data
------------------------------------------------------------------------------------------------------------------------------------------------------ -------------------------------------------------- --------------------------- ------------------ -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ----------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ---------------------- ------------------ ------------- -------------------------------------------------- --------------------------- ---------------------------------------------------------------------------------------------------- ---------------------------------------------------------------------------------------------------- ----------- -------------------------------------------------- -------------------------------------------------- ------------------ -------------- ------------------ --------- ----------- -------------------------------------------------- -------------------------------------------------- ----------- -------------------------------------------------- -------------- -------------- ----------------------- --------------------------- ----------------------------- ---------------------- ---------------- ----------- ----------------- ----------- ---------------------- ---------------------- -------------------------------------------------- ----------------------

The query returned empty, indicating that there are no duplicate rows of data within this dataset.

Now that I have correctly imported my data, verified that all of the datatypes are in the correct format, and performed some data cleaning, I will now begin to answer the questions.
*/

-- QUESTIONS: 
 -- 1) How many total accidents have been recorded? By year, month, and day?
  -- Accidents by Year --
select count(CRASH_RECORD_ID) "Number of Accidents",
       year(CRASH_DATE) "Accident Year"
from Chicago_Traffic_Crashes
group by year(CRASH_DATE)
order by [Accident Year] asc;
/*
Number of Accidents Accident Year
------------------- -------------
2                   2013
6                   2014
9829                2015
44297               2016
83786               2017
118950              2018
117762              2019
92092               2020
108763              2021
108401              2022
110560              2023
508                 2024
*/

  -- Accidents by Month --
select *, 
	case
		when "Accident Month" = 1 then 'January'
		when "Accident Month" = 2 then 'Feburary'
		when "Accident Month" = 3 then 'March'
		when "Accident Month" = 4 then 'April'
		when "Accident Month" = 5 then 'May'
		when "Accident Month" = 6 then 'June'
		when "Accident Month" = 7 then 'July'
		when "Accident Month" = 8 then 'August'
		when "Accident Month" = 9 then 'September'
		when "Accident Month" = 10 then 'October'
		when "Accident Month" = 11 then 'November'
		when "Accident Month" = 12 then 'December'
	end as "Months"
from (select count(CRASH_RECORD_ID) "Number of Accidents",
             month(CRASH_DATE) "Accident Month"
      from Chicago_Traffic_Crashes
      group by month(CRASH_DATE)) m
order by [Accident Month] asc;
/*
Number of Accidents Accident Month Months
------------------- -------------- ---------
58340               1              January
57483               2              Feburary
58886               3              March
57163               4              April
66529               5              May
67555               6              June
68961               7              July
70896               8              August
72409               9              September
76794               10             October
69243               11             November
70697               12             December
*/

  -- Accidents by Day --
select count(CRASH_RECORD_ID) "Number of Accidents",
       datename(dw, CRASH_DATE) "Accident Day"
from Chicago_Traffic_Crashes
group by datename(dw, CRASH_DATE)
order by [Number of Accidents] desc;
/*
Number of Accidents Accident Day
------------------- ------------------------------
129222              Friday
117702              Saturday
114038              Thursday
113351              Tuesday
112517              Wednesday
109399              Monday
98727               Sunday
*/

 -- 2) What years have the most fatal injuries happen in?
select count(INJURIES_FATAL) "Number of Fatal Injuries",
       year(CRASH_DATE) "Accident Year"
from Chicago_Traffic_Crashes
where INJURIES_FATAL is not null
group by year(CRASH_DATE)
order by [Number of Fatal Injuries] desc;
/*
Number of Fatal Injuries Accident Year
------------------------ -------------
118729                   2018
117497                   2019
110300                   2023
108515                   2021
108107                   2022
91857                    2020
83640                    2017
44241                    2016
9814                     2015
507                      2024
6                        2014
2                        2013
*/

 -- 3) What is the most common weather condition for all accidents? By year, month, and day?
  -- Weather Conditions for Accidents by Year --
select m.WEATHER_CONDITION,
       m.[Number of Conditions],
	   m.[Accident Year]
from (select a.*, row_number() over(partition by a."Accident Year" order by a."Number of Conditions" desc) "Most Common Condition"
      from (select WEATHER_CONDITION,
                   count(WEATHER_CONDITION) "Number of Conditions",
                   year(CRASH_DATE) "Accident Year"
            from Chicago_Traffic_Crashes
            group by year(CRASH_DATE),
                     WEATHER_CONDITION) a) m
where m.[Most Common Condition] <= 1;
/*
WEATHER_CONDITION                                  Number of Conditions Accident Year
-------------------------------------------------- -------------------- -------------
CLEAR                                              2                    2013
CLEAR                                              3                    2014
CLEAR                                              7472                 2015
CLEAR                                              35422                2016
CLEAR                                              67663                2017
CLEAR                                              94006                2018
CLEAR                                              91604                2019
CLEAR                                              74199                2020
CLEAR                                              86702                2021
CLEAR                                              83680                2022
CLEAR                                              83851                2023
CLEAR                                              360                  2024
*/

  -- Weather Conditions for Accidents by Month --
select *,
	case 
		when "Accident Month" = 1 then 'January'
		when "Accident Month" = 2 then 'Feburary'
		when "Accident Month" = 3 then 'March'
		when "Accident Month" = 4 then 'April'
		when "Accident Month" = 5 then 'May'
		when "Accident Month" = 6 then 'June'
		when "Accident Month" = 7 then 'July'
		when "Accident Month" = 8 then 'August'
		when "Accident Month" = 9 then 'September'
		when "Accident Month" = 10 then 'October'
		when "Accident Month" = 11 then 'November'
		when "Accident Month" = 12 then 'December'
	end as "Months"
from (select m.WEATHER_CONDITION,
             m.[Number of Conditions],
	         m.[Accident Month]
      from (select a.*, row_number() over(partition by a."Accident Month" order by a."Number of Conditions" desc) "Most Common Condition"
            from (select WEATHER_CONDITION,
                         count(WEATHER_CONDITION) "Number of Conditions",
                         month(CRASH_DATE) "Accident Month"
                  from Chicago_Traffic_Crashes
                  group by month(CRASH_DATE),
                           WEATHER_CONDITION) a) m
      where m.[Most Common Condition] <= 1) mm;
/*
WEATHER_CONDITION                                  Number of Conditions Accident Month Months
-------------------------------------------------- -------------------- -------------- ---------
CLEAR                                              38981                1              January
CLEAR                                              39714                2              Feburary
CLEAR                                              46479                3              March
CLEAR                                              43735                4              April
CLEAR                                              53902                5              May
CLEAR                                              57274                6              June
CLEAR                                              60269                7              July
CLEAR                                              61744                8              August
CLEAR                                              61361                9              September
CLEAR                                              56761                10             October
CLEAR                                              53237                11             November
CLEAR                                              51507                12             December
*/

  -- Weather Conditions for Accidents by Day --
select m.WEATHER_CONDITION,
       m.[Number of Conditions],
	   m.[Accident Day]
from (select a.*, row_number() over(partition by a."Accident Day" order by a."Number of Conditions" desc) "Most Common Condition"
      from (select WEATHER_CONDITION,
                   count(WEATHER_CONDITION) "Number of Conditions",
                   datename(dw, CRASH_DATE) "Accident Day"
            from Chicago_Traffic_Crashes
            group by datename(dw, CRASH_DATE),
                     WEATHER_CONDITION) a) m
where m.[Most Common Condition] <= 1
order by [Number of Conditions] desc;
/*
WEATHER_CONDITION                                  Number of Conditions Accident Day
-------------------------------------------------- -------------------- ------------------------------
CLEAR                                              102035               Friday
CLEAR                                              91016                Saturday
CLEAR                                              90354                Tuesday
CLEAR                                              90284                Thursday
CLEAR                                              88802                Wednesday
CLEAR                                              86113                Monday
CLEAR                                              76360                Sunday
*/

 -- 4) What is the most common weather condition for all fatal accidents by year, month, and day?
  -- Weather Conditions for Fatal Accidents by Year --
select m.WEATHER_CONDITION,
       m.INJURIES_FATAL, 
	   m."Accident Year"
from (select *, row_number() over(partition by a."Accident Year" order by a."INJURIES_FATAL" desc) "Fatal Accident by Weather Condition"
      from (select WEATHER_CONDITION,
                   INJURIES_FATAL,
	               year(CRASH_DATE) "Accident Year"
            from Chicago_Traffic_Crashes
            where INJURIES_FATAL > 1
            group by year(CRASH_DATE),
                     WEATHER_CONDITION,
		             INJURIES_FATAL) a) m
where m.[Fatal Accident by Weather Condition] <= 1;
/*
WEATHER_CONDITION                                  INJURIES_FATAL Accident Year
-------------------------------------------------- -------------- -------------
CLEAR                                              4              2017
CLEAR                                              3              2018
RAIN                                               3              2019
CLEAR                                              3              2020
CLEAR                                              2              2021
CLEAR                                              3              2022
CLEAR                                              3              2023
*/

   -- Weather Conditions for Fatal Accidents by Month --
select *,
	case 
		when "Accident Month" = 1 then 'January'
		when "Accident Month" = 2 then 'Feburary'
		when "Accident Month" = 3 then 'March'
		when "Accident Month" = 4 then 'April'
		when "Accident Month" = 5 then 'May'
		when "Accident Month" = 6 then 'June'
		when "Accident Month" = 7 then 'July'
		when "Accident Month" = 8 then 'August'
		when "Accident Month" = 9 then 'September'
		when "Accident Month" = 10 then 'October'
		when "Accident Month" = 11 then 'November'
		when "Accident Month" = 12 then 'December'
	end as "Months"
from (select m.WEATHER_CONDITION,
             m.INJURIES_FATAL, 
	         m."Accident Month"
      from (select *, row_number() over(partition by a."Accident Month" order by a."INJURIES_FATAL" desc) "Fatal Accident by Weather Condition"
            from (select WEATHER_CONDITION,
                         INJURIES_FATAL,
	                     month(CRASH_DATE) "Accident Month"
                  from Chicago_Traffic_Crashes
                  where INJURIES_FATAL > 1
                  group by month(CRASH_DATE),
                           WEATHER_CONDITION,
		                   INJURIES_FATAL) a) m
where m.[Fatal Accident by Weather Condition] <= 1) mm;
/*
WEATHER_CONDITION                                  INJURIES_FATAL Accident Month Months
-------------------------------------------------- -------------- -------------- ---------
RAIN                                               3              1              January
CLEAR                                              3              2              Feburary
CLEAR                                              2              3              March
CLEAR                                              2              4              April
CLEAR                                              4              5              May
CLEAR                                              3              6              June
CLEAR                                              2              7              July
CLEAR                                              3              8              August
CLEAR                                              3              9              September
CLEAR                                              3              10             October
CLEAR                                              2              11             November
CLEAR                                              2              12             December
*/

   -- Weather Conditions for Fatal Accidents by Day --
select m.WEATHER_CONDITION,
       m.INJURIES_FATAL,
	   m.[Accident Day]
from (select a.*, row_number() over(partition by a."Accident Day" order by a.INJURIES_FATAL desc) "Fatal Accident by Weather Condition"
      from (select WEATHER_CONDITION,
                   INJURIES_FATAL,
                   datename(dw, CRASH_DATE) "Accident Day"
            from Chicago_Traffic_Crashes
            group by datename(dw, CRASH_DATE),
                     WEATHER_CONDITION,
					 INJURIES_FATAL) a) m
where m.[Fatal Accident by Weather Condition] <= 1
order by INJURIES_FATAL desc;
/*
WEATHER_CONDITION                                  INJURIES_FATAL Accident Day
-------------------------------------------------- -------------- ------------------------------
CLEAR                                              4              Sunday
RAIN                                               3              Friday
CLEAR                                              3              Monday
CLEAR                                              3              Saturday
CLEAR                                              3              Wednesday
CLEAR                                              2              Thursday
CLEAR                                              2              Tuesday
*/

 -- 5) What is the most common crash type for all accidents? By year, month, and day?
  -- Crash Type by Year -- 
select a.CRASH_TYPE,
       a.[Number of Crashes],
	   a.[Accident Year]
from (select *, row_number() over(partition by t."Accident Year" order by t."Number of Crashes" desc) "Crash Type by Accident"
      from (select CRASH_TYPE,
                   count(CRASH_TYPE) "Number of Crashes",
	               year(CRASH_DATE) "Accident Year"
            from Chicago_Traffic_Crashes
            group by CRASH_TYPE,
                     year(CRASH_DATE)) t) a
where a.[Crash Type by Accident] = 1;
/*
CRASH_TYPE                                         Number of Crashes Accident Year
-------------------------------------------------- ----------------- -------------
INJURY AND / OR TOW DUE TO CRASH                   2                 2013
NO INJURY / DRIVE AWAY                             5                 2014
NO INJURY / DRIVE AWAY                             9027              2015
NO INJURY / DRIVE AWAY                             40036             2016
NO INJURY / DRIVE AWAY                             66193             2017
NO INJURY / DRIVE AWAY                             87310             2018
NO INJURY / DRIVE AWAY                             86534             2019
NO INJURY / DRIVE AWAY                             63140             2020
NO INJURY / DRIVE AWAY                             75272             2021
NO INJURY / DRIVE AWAY                             76629             2022
NO INJURY / DRIVE AWAY                             78695             2023
NO INJURY / DRIVE AWAY                             336               2024
*/

  -- Crash Type by Month --
select a.CRASH_TYPE,
       a.[Number of Crashes],
	   a.[Accident Month],
	case 
		when "Accident Month" = 1 then 'January'
		when "Accident Month" = 2 then 'Feburary'
		when "Accident Month" = 3 then 'March'
		when "Accident Month" = 4 then 'April'
		when "Accident Month" = 5 then 'May'
		when "Accident Month" = 6 then 'June'
		when "Accident Month" = 7 then 'July'
		when "Accident Month" = 8 then 'August'
		when "Accident Month" = 9 then 'September'
		when "Accident Month" = 10 then 'October'
		when "Accident Month" = 11 then 'November'
		when "Accident Month" = 12 then 'December'
	end as "Months"
from (select *, row_number() over(partition by t."Accident Month" order by t."Number of Crashes" desc) "Crash Type by Accident"
      from (select CRASH_TYPE,
                   count(CRASH_TYPE) "Number of Crashes",
	               month(CRASH_DATE) "Accident Month"
           from Chicago_Traffic_Crashes
           group by CRASH_TYPE,
                    month(CRASH_DATE)) t) a
where a.[Crash Type by Accident] <= 1;
/*
CRASH_TYPE                                         Number of Crashes Accident Month Months
-------------------------------------------------- ----------------- -------------- ---------
NO INJURY / DRIVE AWAY                             42981             1              January
NO INJURY / DRIVE AWAY                             43796             2              Feburary
NO INJURY / DRIVE AWAY                             43871             3              March
NO INJURY / DRIVE AWAY                             41936             4              April
NO INJURY / DRIVE AWAY                             49045             5              May
NO INJURY / DRIVE AWAY                             49556             6              June
NO INJURY / DRIVE AWAY                             49904             7              July
NO INJURY / DRIVE AWAY                             51658             8              August
NO INJURY / DRIVE AWAY                             52850             9              September
NO INJURY / DRIVE AWAY                             55780             10             October
NO INJURY / DRIVE AWAY                             50526             11             November
NO INJURY / DRIVE AWAY                             51274             12             December
*/

   -- Crash Type by Day --
select a.CRASH_TYPE,
       a.[Number of Crashes],
	   a.[Accident Day]
from (select *, row_number() over(partition by t."Accident Day" order by t."Number of Crashes" desc) "Crash Type by Accident"
      from (select CRASH_TYPE,
                   count(CRASH_TYPE) "Number of Crashes",
	               datename(dw, CRASH_DATE) "Accident Day"
            from Chicago_Traffic_Crashes
            group by CRASH_TYPE,
                     datename(dw, CRASH_DATE)) t) a
where a.[Crash Type by Accident] <= 1
order by a.[Number of Crashes] desc;
/*
CRASH_TYPE                                         Number of Crashes Accident Day
-------------------------------------------------- ----------------- ------------------------------
NO INJURY / DRIVE AWAY                             96172             Friday
NO INJURY / DRIVE AWAY                             84838             Tuesday
NO INJURY / DRIVE AWAY                             84746             Thursday
NO INJURY / DRIVE AWAY                             84193             Saturday
NO INJURY / DRIVE AWAY                             84049             Wednesday
NO INJURY / DRIVE AWAY                             81379             Monday
NO INJURY / DRIVE AWAY                             67800             Sunday

*/

 -- 6) What is the most common crash type for fatal accidents? By year, month, and day?
  -- Crash Type for Fatal Accidents by Year --
select a.CRASH_TYPE,
       a.[Number of Crashes],
	   a.[Accident Year]
from (select *, row_number() over(partition by t."Accident Year" order by t."Number of Crashes" desc) "Crash Type by Accident"
      from (select CRASH_TYPE,
                   count(CRASH_TYPE) "Number of Crashes",
	               year(CRASH_DATE) "Accident Year"
            from Chicago_Traffic_Crashes
			where INJURIES_FATAL >= 1
            group by CRASH_TYPE,
                     year(CRASH_DATE)) t) a
where a.[Crash Type by Accident] = 1;
/*
CRASH_TYPE                                         Number of Crashes Accident Year
-------------------------------------------------- ----------------- -------------
INJURY AND / OR TOW DUE TO CRASH                   3                 2015
INJURY AND / OR TOW DUE TO CRASH                   14                2016
INJURY AND / OR TOW DUE TO CRASH                   78                2017
INJURY AND / OR TOW DUE TO CRASH                   114               2018
INJURY AND / OR TOW DUE TO CRASH                   102               2019
INJURY AND / OR TOW DUE TO CRASH                   134               2020
INJURY AND / OR TOW DUE TO CRASH                   156               2021
INJURY AND / OR TOW DUE TO CRASH                   135               2022
INJURY AND / OR TOW DUE TO CRASH                   140               2023
*/

   -- Crash Type for Fatal Accidents by Month --
select a.CRASH_TYPE,
       a.[Number of Crashes],
	   a.[Accident Month],
	case 
		when "Accident Month" = 1 then 'January'
		when "Accident Month" = 2 then 'Feburary'
		when "Accident Month" = 3 then 'March'
		when "Accident Month" = 4 then 'April'
		when "Accident Month" = 5 then 'May'
		when "Accident Month" = 6 then 'June'
		when "Accident Month" = 7 then 'July'
		when "Accident Month" = 8 then 'August'
		when "Accident Month" = 9 then 'September'
		when "Accident Month" = 10 then 'October'
		when "Accident Month" = 11 then 'November'
		when "Accident Month" = 12 then 'December'
	end as "Months"
from (select *, row_number() over(partition by t."Accident Month" order by t."Number of Crashes" desc) "Crash Type by Accident"
      from (select CRASH_TYPE,
                   count(CRASH_TYPE) "Number of Crashes",
	               month(CRASH_DATE) "Accident Month"
           from Chicago_Traffic_Crashes
		   where INJURIES_FATAL >= 1
           group by CRASH_TYPE,
                    month(CRASH_DATE)) t) a
where a.[Crash Type by Accident] <= 1;
/*
CRASH_TYPE                                         Number of Crashes Accident Month Months
-------------------------------------------------- ----------------- -------------- ---------
INJURY AND / OR TOW DUE TO CRASH                   65                1              January
INJURY AND / OR TOW DUE TO CRASH                   51                2              Feburary
INJURY AND / OR TOW DUE TO CRASH                   57                3              March
INJURY AND / OR TOW DUE TO CRASH                   53                4              April
INJURY AND / OR TOW DUE TO CRASH                   70                5              May
INJURY AND / OR TOW DUE TO CRASH                   74                6              June
INJURY AND / OR TOW DUE TO CRASH                   97                7              July
INJURY AND / OR TOW DUE TO CRASH                   88                8              August
INJURY AND / OR TOW DUE TO CRASH                   89                9              September
INJURY AND / OR TOW DUE TO CRASH                   80                10             October
INJURY AND / OR TOW DUE TO CRASH                   70                11             November
INJURY AND / OR TOW DUE TO CRASH                   82                12             December
*/

   -- Crash Type for Fatal Accidents by Day --
select a.CRASH_TYPE,
       a.[Number of Crashes],
	   a.[Accident Day]
from (select *, row_number() over(partition by t."Accident Day" order by t."Number of Crashes" desc) "Crash Type by Accident"
      from (select CRASH_TYPE,
                   count(CRASH_TYPE) "Number of Crashes",
	               datename(dw, CRASH_DATE) "Accident Day"
            from Chicago_Traffic_Crashes
			where INJURIES_FATAL >= 1
            group by CRASH_TYPE,
                     datename(dw, CRASH_DATE)) t) a
where a.[Crash Type by Accident] <= 1
order by a.[Number of Crashes] desc;
/*
CRASH_TYPE                                         Number of Crashes Accident Day
-------------------------------------------------- ----------------- ------------------------------
INJURY AND / OR TOW DUE TO CRASH                   156               Sunday
INJURY AND / OR TOW DUE TO CRASH                   146               Saturday
INJURY AND / OR TOW DUE TO CRASH                   128               Thursday
INJURY AND / OR TOW DUE TO CRASH                   123               Friday
INJURY AND / OR TOW DUE TO CRASH                   121               Wednesday
INJURY AND / OR TOW DUE TO CRASH                   111               Monday
INJURY AND / OR TOW DUE TO CRASH                   91                Tuesday

*/

 -- 7) What is the most common roadway surface condition for accidents? By year, month, and day?
  -- Surface Conditions for Accidents by Year --
select c."ROADWAY_SURFACE_COND",
       c."Number of Conditions",
	   c."Accident Year"
from (select *, row_number() over(partition by a."Accident Year" order by "Number of Conditions" desc) "Roadway Conditions"
      from (select ROADWAY_SURFACE_COND,
                   count(ROADWAY_SURFACE_COND) "Number of Conditions",
	               year(CRASH_DATE) "Accident Year"
           from Chicago_Traffic_Crashes
           group by ROADWAY_SURFACE_COND,
                    year(CRASH_DATE)) a) c
where c.[Roadway Conditions] <= 1;
/*
ROADWAY_SURFACE_COND                               Number of Conditions Accident Year
-------------------------------------------------- -------------------- -------------
DRY                                                2                    2013
DRY                                                3                    2014
DRY                                                7000                 2015
DRY                                                33532                2016
DRY                                                65216                2017
DRY                                                88588                2018
DRY                                                86127                2019
DRY                                                71213                2020
DRY                                                81231                2021
DRY                                                76601                2022
DRY                                                78955                2023
DRY                                                331                  2024
*/

  -- Surface Conditions for Accidents by Month --
select c."ROADWAY_SURFACE_COND",
       c."Number of Conditions",
	   c."Accident Month",
		case
			when "Accident Month" = 1 then 'January'
			when "Accident Month" = 2 then 'Febuary'
			when "Accident Month" = 3 then 'March'
			when "Accident Month" = 4 then 'April'
			when "Accident Month" = 5 then 'May'
			when "Accident Month" = 6 then 'June'
			when "Accident Month" = 7 then 'July'
			when "Accident Month" = 8 then 'August'
			when "Accident Month" = 9 then 'September'
			when "Accident Month" = 10 then 'October'
			when "Accident Month" = 11 then 'November'
			when "Accident Month" = 12 then 'December'
		end as "Months"
from (select *, row_number() over(partition by a."Accident Month" order by a."Number of Conditions" desc) "Roadway Conditions"
      from (select ROADWAY_SURFACE_COND,
                   count(ROADWAY_SURFACE_COND) "Number of Conditions",
	               month(CRASH_DATE) "Accident Month"
            from Chicago_Traffic_Crashes
            group by ROADWAY_SURFACE_COND,
                     month(CRASH_DATE)) a) c
where c.[Roadway Conditions] <= 1;
/*
ROADWAY_SURFACE_COND                               Number of Conditions Accident Month Months
-------------------------------------------------- -------------------- -------------- ---------
DRY                                                31767                1              January
DRY                                                31809                2              Febuary
DRY                                                44767                3              March
DRY                                                42341                4              April
DRY                                                52199                5              May
DRY                                                55625                6              June
DRY                                                58355                7              July
DRY                                                59759                8              August
DRY                                                59612                9              September
DRY                                                55203                10             October
DRY                                                50247                11             November
DRY                                                47115                12             December
*/

  -- Surface Conditions for Accidents by Day --
select c."ROADWAY_SURFACE_COND",
       c."Number of Conditions",
	   c."Accident Day"
from (select *, row_number() over(partition by a."Accident Day" order by a."Number of Conditions" desc) "Roadway Conditions"
      from (select ROADWAY_SURFACE_COND,
                   count(ROADWAY_SURFACE_COND) "Number of Conditions",
	               datename(dw, CRASH_DATE) "Accident Day"
            from Chicago_Traffic_Crashes
            group by ROADWAY_SURFACE_COND,
                     datename(dw, CRASH_DATE)) a) c
where c.[Roadway Conditions] <= 1
order by c.[Number of Conditions] desc;
/*
ROADWAY_SURFACE_COND                               Number of Conditions Accident Day
-------------------------------------------------- -------------------- ------------------------------
DRY                                                96612                Friday
DRY                                                85862                Saturday
DRY                                                85517                Thursday
DRY                                                85028                Tuesday
DRY                                                83383                Wednesday
DRY                                                80942                Monday
DRY                                                71455                Sunday
*/

  -- 8) What is the most common roadway surface condition for fatal accidents? By year, month, and day?
   -- Surface Condition for Fatal Accidents by Year --
select c."ROADWAY_SURFACE_COND",
       c."Number of Conditions",
	   c."Accident Year"
from (select *, row_number() over(partition by a."Accident Year" order by a."Number of Conditions" desc) "Roadway Conditions"
      from (select ROADWAY_SURFACE_COND,
                   count(ROADWAY_SURFACE_COND) "Number of Conditions",
	               year(CRASH_DATE) "Accident Year"
            from Chicago_Traffic_Crashes
	        where INJURIES_FATAL >= 1
            group by ROADWAY_SURFACE_COND,
                     year(CRASH_DATE)) a) c
where c.[Roadway Conditions] <= 1;
/*
ROADWAY_SURFACE_COND                               Number of Conditions Accident Year
-------------------------------------------------- -------------------- -------------
DRY                                                3                    2015
DRY                                                13                   2016
DRY                                                68                   2017
DRY                                                81                   2018
DRY                                                77                   2019
DRY                                                113                  2020
DRY                                                126                  2021
DRY                                                103                  2022
DRY                                                102                  2023
*/

  -- Surface Conditions for Fatal Accidents by Month --
select c."ROADWAY_SURFACE_COND",
       c."Number of Conditions",
	   c."Accident Month",
			case
				when "Accident Month" = 1 then 'January'
				when "Accident Month" = 2 then 'Feburary'
				when "Accident Month" = 3 then 'March'
				when "Accident Month" = 4 then 'April'
				when "Accident Month" = 5 then 'May'
				when "Accident Month" = 6 then 'June'
				when "Accident Month" = 7 then 'July'
				when "Accident Month" = 8 then 'August'
				when "Accident Month" = 9 then 'September'
				when "Accident Month" = 10 then 'October'
				when "Accident Month" = 11 then 'November'
				when "Accident Month" = 12 then 'December'
			end as "Months"
from (select *, row_number() over(partition by a."Accident Month" order by a."Number of Conditions" desc) "Roadway Conditions"
      from (select ROADWAY_SURFACE_COND,
                   count(ROADWAY_SURFACE_COND) "Number of Conditions",
	               month(CRASH_DATE) "Accident Month"
            from Chicago_Traffic_Crashes
            where INJURIES_FATAL >= 1
            group by ROADWAY_SURFACE_COND,
                     month(CRASH_DATE)) a) c
where c.[Roadway Conditions] <= 1;
/*
ROADWAY_SURFACE_COND                               Number of Conditions Accident Month Months
-------------------------------------------------- -------------------- -------------- ---------
DRY                                                32                   1              January
DRY                                                25                   2              Feburary
DRY                                                41                   3              March
DRY                                                44                   4              April
DRY                                                58                   5              May
DRY                                                65                   6              June
DRY                                                89                   7              July
DRY                                                77                   8              August
DRY                                                75                   9              September
DRY                                                67                   10             October
DRY                                                54                   11             November
DRY                                                59                   12             December
*/

   --Surface Conditions for Fatal Accidents by Day -- 
select c."ROADWAY_SURFACE_COND",
       c."Number of Conditions",
	   c."Accident Day"
from (select *, row_number() over(partition by a."Accident Day" order by a."Number of Conditions" desc) "Roadway Conditions"
      from (select ROADWAY_SURFACE_COND,
                   count(ROADWAY_SURFACE_COND) "Number of Conditions",
	               datename(dw, CRASH_DATE) "Accident Day"
            from Chicago_Traffic_Crashes
	        where INJURIES_FATAL >= 1
            group by ROADWAY_SURFACE_COND,
                     datename(dw, CRASH_DATE)) a) c
where c.[Roadway Conditions] <= 1
order by c.[Number of Conditions] desc;
/*
ROADWAY_SURFACE_COND                               Number of Conditions Accident Day
-------------------------------------------------- -------------------- ------------------------------
DRY                                                121                  Sunday
DRY                                                118                  Saturday
DRY                                                99                   Thursday
DRY                                                97                   Wednesday
DRY                                                96                   Friday
DRY                                                86                   Monday
DRY                                                69                   Tuesday
*/

  -- 9) What is the count of damage by year?
select d.DAMAGE,
       d."Count of Damage",
	   d."Accident Year"
from (select *, dense_rank() over(partition by a."Accident Year"order by a."Count of Damage" desc) "Damage_C"
      from (select DAMAGE,
                   count(DAMAGE) "Count of Damage",
	               year(CRASH_DATE) "Accident Year"
            from Chicago_Traffic_Crashes
            group by DAMAGE,
                     year(CRASH_DATE)) a) d
where d.Damage_C <= 1;
/*
DAMAGE                                             Count of Damage Accident Year
-------------------------------------------------- --------------- -------------
$501 - $1,500                                      1               2013
OVER $1,500                                        1               2013
$501 - $1,500                                      3               2014
OVER $1,500                                        3               2014
OVER $1,500                                        4865            2015
OVER $1,500                                        23069           2016
OVER $1,500                                        46736           2017
OVER $1,500                                        68356           2018
OVER $1,500                                        68076           2019
OVER $1,500                                        57760           2020
OVER $1,500                                        71839           2021
OVER $1,500                                        73391           2022
OVER $1,500                                        77022           2023
OVER $1,500                                        392             2024
*/

  -- 10) What is the average time from accident to police notification?
   -- Avg Hours for Accidents to be Reported --
select avg(datediff(hour, CRASH_DATE, DATE_POLICE_NOTIFIED)) "Avg Accident Notification Time in Hours"
from Chicago_Traffic_Crashes;
/*
Avg Accident Notification Time in Hours
---------------------------------------
15
*/
			         
   -- Avg Hours for Accident to be Reported by Year --		  
select year(CRASH_DATE) "Accident Year",
       avg(datediff(hour, CRASH_DATE, DATE_POLICE_NOTIFIED)) "Avg Accident Notification Time in Hours"
from Chicago_Traffic_Crashes
group by year(CRASH_DATE)
order by [Accident Year] asc;
/*
Accident Year Avg Accident Notification Time in Hours
------------- ---------------------------------------
2013          26292
2014          24354
2015          55
2016          24
2017          15
2018          13
2019          12
2020          13
2021          13
2022          14
2023          13
2024          3

Lookng at the years 2013 and 2014, I can see that the average amount of hours to report an accident is exceptionally large.
I will look further into that to verify that the data is correct.
*/

select CRASH_DATE, DATE_POLICE_NOTIFIED
from Chicago_Traffic_Crashes
where year(CRASH_DATE) in (2013, 2014);
/*
CRASH_DATE                  DATE_POLICE_NOTIFIED
--------------------------- ---------------------------
2013-06-01 20:29:00.0000000 2013-06-01 20:31:00.0000000
2014-01-18 18:14:00.0000000 2018-09-19 19:00:00.0000000
2014-02-24 19:45:00.0000000 2016-02-25 14:30:00.0000000
2014-11-11 20:00:00.0000000 2015-11-12 14:40:00.0000000
2014-01-21 07:40:00.0000000 2016-01-21 07:50:00.0000000
2014-06-25 19:00:00.0000000 2019-06-25 17:50:00.0000000
2013-03-03 16:48:00.0000000 2019-03-03 16:49:00.0000000
2014-08-20 16:50:00.0000000 2016-08-20 20:32:00.0000000

Ok, now I understand that during those years most of the accidents were reported at minimum two years after the occurance. This explains why the average amount of hours to report an accident is so much higher during those years.
*/

  -- 11) What is the most common primary contributory cause in all accidents? By year, month, and day?
   -- Top 3 Primary Causes for Accidents by Year -- 
select p."PRIM_CONTRIBUTORY_CAUSE",
       p."Num of Causes",
	   p."Accident Year"
from (select *, dense_rank() over(partition by a."Accident Year" order by a."Num of Causes" desc) "Primary"
      from (select PRIM_CONTRIBUTORY_CAUSE,
                   count(PRIM_CONTRIBUTORY_CAUSE) "Num of Causes",
	               year(CRASH_DATE) "Accident Year"
            from Chicago_Traffic_Crashes
            group by PRIM_CONTRIBUTORY_CAUSE,
                     year(CRASH_DATE)) a) p
where p."Primary" in (1,2,3);
/*
PRIM_CONTRIBUTORY_CAUSE                                                                              Num of Causes Accident Year
---------------------------------------------------------------------------------------------------- ------------- -------------
UNABLE TO DETERMINE                                                                                  1             2013
IMPROPER LANE USAGE                                                                                  1             2013
UNABLE TO DETERMINE                                                                                  4             2014
FAILING TO YIELD RIGHT-OF-WAY                                                                        1             2014
IMPROPER OVERTAKING/PASSING                                                                          1             2014
UNABLE TO DETERMINE                                                                                  3545          2015
FOLLOWING TOO CLOSELY                                                                                1357          2015
FAILING TO YIELD RIGHT-OF-WAY                                                                        946           2015
UNABLE TO DETERMINE                                                                                  17022         2016
FOLLOWING TOO CLOSELY                                                                                5705          2016
FAILING TO YIELD RIGHT-OF-WAY                                                                        4217          2016
UNABLE TO DETERMINE                                                                                  30604         2017
FOLLOWING TOO CLOSELY                                                                                9955          2017
FAILING TO YIELD RIGHT-OF-WAY                                                                        9810          2017
UNABLE TO DETERMINE                                                                                  41139         2018
FAILING TO YIELD RIGHT-OF-WAY                                                                        14089         2018
FOLLOWING TOO CLOSELY                                                                                12674         2018
UNABLE TO DETERMINE                                                                                  43143         2019
FAILING TO YIELD RIGHT-OF-WAY                                                                        12951         2019
FOLLOWING TOO CLOSELY                                                                                12164         2019
UNABLE TO DETERMINE                                                                                  36333         2020
FAILING TO YIELD RIGHT-OF-WAY                                                                        9708          2020
FOLLOWING TOO CLOSELY                                                                                8213          2020
UNABLE TO DETERMINE                                                                                  44837         2021
FAILING TO YIELD RIGHT-OF-WAY                                                                        11182         2021
FOLLOWING TOO CLOSELY                                                                                9069          2021
UNABLE TO DETERMINE                                                                                  45824         2022
FAILING TO YIELD RIGHT-OF-WAY                                                                        11815         2022
FOLLOWING TOO CLOSELY                                                                                9164          2022
UNABLE TO DETERMINE                                                                                  46182         2023
FAILING TO YIELD RIGHT-OF-WAY                                                                        12480         2023
FOLLOWING TOO CLOSELY                                                                                9286          2023
UNABLE TO DETERMINE                                                                                  208           2024
FAILING TO YIELD RIGHT-OF-WAY                                                                        52            2024
FOLLOWING TOO CLOSELY                                                                                35            2024
*/

   -- Top 3 Primary Causes for Accidents by Month --
select p."PRIM_CONTRIBUTORY_CAUSE",
       p."Num of Causes",
	   p."Accident Month",
			case
				when "Accident Month" = 1 then 'January'
				when "Accident Month" = 2 then 'Feburary'
				when "Accident Month" = 3 then 'March'
				when "Accident Month" = 4 then 'April'
				when "Accident Month" = 5 then 'May'
				when "Accident Month" = 6 then 'June'
				when "Accident Month" = 7 then 'July'
				when "Accident Month" = 8 then 'August'
				when "Accident Month" = 9 then 'September'
				when "Accident Month" = 10 then 'October'
				when "Accident Month" = 11 then 'November'
				when "Accident Month" = 12 then 'December'
			end as "Months"
from (select *, row_number() over(partition by a."Accident Month" order by a."Num of Causes" desc) "Primary"
      from (select PRIM_CONTRIBUTORY_CAUSE,
                   count(PRIM_CONTRIBUTORY_CAUSE) "Num of Causes",
	               month(CRASH_DATE) "Accident Month"
            from Chicago_Traffic_Crashes
            group by PRIM_CONTRIBUTORY_CAUSE,
                     month(CRASH_DATE)) a) p
where p."Primary" in (1, 2, 3);
/*
PRIM_CONTRIBUTORY_CAUSE                                                                              Num of Causes Accident Month Months
---------------------------------------------------------------------------------------------------- ------------- -------------- ---------
UNABLE TO DETERMINE                                                                                  22325         1              January
FAILING TO YIELD RIGHT-OF-WAY                                                                        6174          1              January
FOLLOWING TOO CLOSELY                                                                                5766          1              January
UNABLE TO DETERMINE                                                                                  22313         2              Feburary
FAILING TO YIELD RIGHT-OF-WAY                                                                        6013          2              Feburary
FOLLOWING TOO CLOSELY                                                                                5473          2              Feburary
UNABLE TO DETERMINE                                                                                  22972         3              March
FAILING TO YIELD RIGHT-OF-WAY                                                                        6553          3              March
FOLLOWING TOO CLOSELY                                                                                5491          3              March
UNABLE TO DETERMINE                                                                                  21890         4              April
FAILING TO YIELD RIGHT-OF-WAY                                                                        6328          4              April
FOLLOWING TOO CLOSELY                                                                                5435          4              April
UNABLE TO DETERMINE                                                                                  25788         5              May
FAILING TO YIELD RIGHT-OF-WAY                                                                        7302          5              May
FOLLOWING TOO CLOSELY                                                                                6575          5              May
UNABLE TO DETERMINE                                                                                  26355         6              June
FAILING TO YIELD RIGHT-OF-WAY                                                                        7347          6              June
FOLLOWING TOO CLOSELY                                                                                6697          6              June
UNABLE TO DETERMINE                                                                                  27030         7              July
FAILING TO YIELD RIGHT-OF-WAY                                                                        7314          7              July
FOLLOWING TOO CLOSELY                                                                                6704          7              July
UNABLE TO DETERMINE                                                                                  28026         8              August
FAILING TO YIELD RIGHT-OF-WAY                                                                        7620          8              August
FOLLOWING TOO CLOSELY                                                                                6928          8              August
UNABLE TO DETERMINE                                                                                  28474         9              September
FAILING TO YIELD RIGHT-OF-WAY                                                                        7999          9              September
FOLLOWING TOO CLOSELY                                                                                7234          9              September
UNABLE TO DETERMINE                                                                                  29742         10             October
FAILING TO YIELD RIGHT-OF-WAY                                                                        8837          10             October
FOLLOWING TOO CLOSELY                                                                                7581          10             October
UNABLE TO DETERMINE                                                                                  26936         11             November
FAILING TO YIELD RIGHT-OF-WAY                                                                        7750          11             November
FOLLOWING TOO CLOSELY                                                                                6854          11             November
UNABLE TO DETERMINE                                                                                  26991         12             December
FAILING TO YIELD RIGHT-OF-WAY                                                                        8014          12             December
FOLLOWING TOO CLOSELY                                                                                6884          12             December
*/

   -- Top 3 Primary Causes for Accidents by Day -- 
select p."PRIM_CONTRIBUTORY_CAUSE", 
       p."Num of Causes",
	   p."Accident Day"
from (select *, row_number() over(partition by a."Accident Day" order by a."Num of Causes" desc) "Primary"
      from (select PRIM_CONTRIBUTORY_CAUSE,
                   count(PRIM_CONTRIBUTORY_CAUSE) "Num of Causes",
	               datename(dw, CRASH_DATE) "Accident Day"
            from Chicago_Traffic_Crashes
            group by PRIM_CONTRIBUTORY_CAUSE,
                     datename(dw, CRASH_DATE)) a) p
where p."Primary" in (1, 2, 3);
/*\
PRIM_CONTRIBUTORY_CAUSE                                                                              Num of Causes Accident Day
---------------------------------------------------------------------------------------------------- ------------- ------------------------------
UNABLE TO DETERMINE                                                                                  49040         Friday
FAILING TO YIELD RIGHT-OF-WAY                                                                        14771         Friday
FOLLOWING TOO CLOSELY                                                                                13182         Friday
UNABLE TO DETERMINE                                                                                  43117         Monday
FAILING TO YIELD RIGHT-OF-WAY                                                                        11765         Monday
FOLLOWING TOO CLOSELY                                                                                10723         Monday
UNABLE TO DETERMINE                                                                                  46065         Saturday
FAILING TO YIELD RIGHT-OF-WAY                                                                        12271         Saturday
FOLLOWING TOO CLOSELY                                                                                10832         Saturday
UNABLE TO DETERMINE                                                                                  39979         Sunday
FAILING TO YIELD RIGHT-OF-WAY                                                                        9408          Sunday
FOLLOWING TOO CLOSELY                                                                                8295          Sunday
UNABLE TO DETERMINE                                                                                  43567         Thursday
FAILING TO YIELD RIGHT-OF-WAY                                                                        13173         Thursday
FOLLOWING TOO CLOSELY                                                                                11549         Thursday
UNABLE TO DETERMINE                                                                                  43872         Tuesday
FAILING TO YIELD RIGHT-OF-WAY                                                                        12902         Tuesday
FOLLOWING TOO CLOSELY                                                                                11592         Tuesday
UNABLE TO DETERMINE                                                                                  43202         Wednesday
FAILING TO YIELD RIGHT-OF-WAY                                                                        12961         Wednesday
FOLLOWING TOO CLOSELY                                                                                11449         Wednesday
*/

  -- 12) What is the count of the most severe injury? By year, month, and day?
   -- Top 2 Injury Types by Year --
select i."MOST_SEVERE_INJURY",
       i."Num of Injuries",
	   i."Accident Year"
from (select *, dense_rank() over(partition by a."Accident Year" order by a."Num of Injuries" desc) "Injuries"
      from (select MOST_SEVERE_INJURY,
                   count(MOST_SEVERE_INJURY) "Num of Injuries",
	               year(CRASH_DATE) "Accident Year"
            from Chicago_Traffic_Crashes
            where MOST_SEVERE_INJURY is not null
            group by MOST_SEVERE_INJURY,
                     year(CRASH_DATE)) a) i
where i."Injuries" in (1,2);
/*
MOST_SEVERE_INJURY                                 Num of Injuries Accident Year
-------------------------------------------------- --------------- -------------
REPORTED, NOT EVIDENT                              1               2013
NONINCAPACITATING INJURY                           1               2013
NO INDICATION OF INJURY                            5               2014
NONINCAPACITATING INJURY                           1               2014
NO INDICATION OF INJURY                            9288            2015
REPORTED, NOT EVIDENT                              271             2015
NO INDICATION OF INJURY                            41570           2016
NONINCAPACITATING INJURY                           1202            2016
NO INDICATION OF INJURY                            73993           2017
NONINCAPACITATING INJURY                           5041            2017
NO INDICATION OF INJURY                            102140          2018
NONINCAPACITATING INJURY                           9335            2018
NO INDICATION OF INJURY                            101182          2019
NONINCAPACITATING INJURY                           9210            2019
NO INDICATION OF INJURY                            77690           2020
NONINCAPACITATING INJURY                           8135            2020
NO INDICATION OF INJURY                            92184           2021
NONINCAPACITATING INJURY                           9610            2021
NO INDICATION OF INJURY                            92074           2022
NONINCAPACITATING INJURY                           9304            2022
NO INDICATION OF INJURY                            93558           2023
NONINCAPACITATING INJURY                           9558            2023
NO INDICATION OF INJURY                            417             2024
NONINCAPACITATING INJURY                           53              2024
*/

   -- Top 2 Injury Types by Month --
select t."MOST_SEVERE_INJURY",
       t."Num of Injuries",
	   t."Accident Month",
			case
				when "Accident Month" = 1 then 'January'
				when "Accident Month" = 2 then 'Feburary'
				when "Accident Month" = 3 then 'March'
				when "Accident Month" = 4 then 'April'
				when "Accident Month" = 5 then 'May'
				when "Accident Month" = 6 then 'June'
				when "Accident Month" = 7 then 'July'
				when "Accident Month" = 8 then 'August'
				when "Accident Month" = 9 then 'September'
				when "Accident Month" = 10 then 'October'
				when "Accident Month" = 11 then 'November'
				when "Accident Month" = 12 then 'December'
			end as "Months"
from (select *, row_number() over(partition by a."Accident Month" order by a."Num of Injuries" desc) "Injuries"
      from (select MOST_SEVERE_INJURY,
                   count(MOST_SEVERE_INJURY) "Num of Injuries",
	               month(CRASH_DATE) "Accident Month"
            from Chicago_Traffic_Crashes
            where MOST_SEVERE_INJURY is not null
            group by MOST_SEVERE_INJURY,
                     month(CRASH_DATE)) a) t
where t.Injuries in (1, 2);
/*
MOST_SEVERE_INJURY                                 Num of Injuries Accident Month Months
-------------------------------------------------- --------------- -------------- ---------
NO INDICATION OF INJURY                            50916           1              January
NONINCAPACITATING INJURY                           4027            1              January
NO INDICATION OF INJURY                            50855           2              Feburary
NONINCAPACITATING INJURY                           3490            2              Feburary
NO INDICATION OF INJURY                            51412           3              March
NONINCAPACITATING INJURY                           4028            3              March
NO INDICATION OF INJURY                            49451           4              April
NONINCAPACITATING INJURY                           4248            4              April
NO INDICATION OF INJURY                            57136           5              May
NONINCAPACITATING INJURY                           5306            5              May
NO INDICATION OF INJURY                            57663           6              June
NONINCAPACITATING INJURY                           5683            6              June
NO INDICATION OF INJURY                            58428           7              July
NONINCAPACITATING INJURY                           6015            7              July
NO INDICATION OF INJURY                            60269           8              August
NONINCAPACITATING INJURY                           6159            8              August
NO INDICATION OF INJURY                            61532           9              September
NONINCAPACITATING INJURY                           6159            9              September
NO INDICATION OF INJURY                            65490           10             October
NONINCAPACITATING INJURY                           6225            10             October
NO INDICATION OF INJURY                            59664           11             November
NONINCAPACITATING INJURY                           5231            11             November
NO INDICATION OF INJURY                            61285           12             December
NONINCAPACITATING INJURY                           5080            12             December
*/

   -- Top 2 Injury Types by Day --
select t."MOST_SEVERE_INJURY",
       t."Num of Injuries",
	   t."Accident Day"
from (select *, row_number() over(partition by a."Accident Day" order by a."Num of Injuries" desc) "Injuries"
      from (select MOST_SEVERE_INJURY,
                   count(MOST_SEVERE_INJURY) "Num of Injuries",
	               datename(dw, CRASH_DATE) "Accident Day"
            from Chicago_Traffic_Crashes
            where MOST_SEVERE_INJURY is not null
            group by MOST_SEVERE_INJURY,
                     datename(dw, CRASH_DATE)) a) t
where t.Injuries in (1, 2);
/*
MOST_SEVERE_INJURY                                 Num of Injuries Accident Day
-------------------------------------------------- --------------- ------------------------------
NO INDICATION OF INJURY                            111750          Friday
NONINCAPACITATING INJURY                           9669            Friday
NO INDICATION OF INJURY                            94491           Monday
NONINCAPACITATING INJURY                           8142            Monday
NO INDICATION OF INJURY                            101076          Saturday
NONINCAPACITATING INJURY                           9238            Saturday
NO INDICATION OF INJURY                            83992           Sunday
NONINCAPACITATING INJURY                           8352            Sunday
NO INDICATION OF INJURY                            98257           Thursday
NONINCAPACITATING INJURY                           8823            Thursday
NO INDICATION OF INJURY                            97688           Tuesday
NONINCAPACITATING INJURY                           8632            Tuesday
NO INDICATION OF INJURY                            96847           Wednesday
NONINCAPACITATING INJURY                           8795            Wednesday
*/

-- REQUIREMENTS:
 -- 1) Primary KPI - Total accident values for current year and year over year growth.
select count(CRASH_RECORD_ID) "Total Accidents 2024"
from Chicago_Traffic_Crashes
where year(CRASH_DATE) = '2024'
/*
Total Accidents 2024
--------------------
508
*/
select cy."num" / py."den" as YOY_Growth_for_Accidents
from (select cast(count(CRASH_RECORD_ID) as decimal(10,2)) - (select cast(count(CRASH_RECORD_ID) as decimal(10,2))
                                                              from Chicago_Traffic_Crashes
								                              where year(CRASH_DATE) = '2023') "num"
      from Chicago_Traffic_Crashes
      where year(CRASH_DATE) = '2024') cy,
     (select count(CRASH_RECORD_ID) "den"
      from Chicago_Traffic_Crashes
      where year(CRASH_DATE) = '2023') py;
/*
YOY_Growth_for_Accidents
---------------------------------------
-0.9954052098408
*/

 -- 2) Primary KP1 - Total accident severity for current year and year over year growth.
select MOST_SEVERE_INJURY "Most Severe Injury 2024",
       count(MOST_SEVERE_INJURY) "Num of Occurences"
from Chicago_Traffic_Crashes
where MOST_SEVERE_INJURY is not null
and year(CRASH_DATE) = '2024'
group by MOST_SEVERE_INJURY
/*
Most Severe Injury 2024                            Num of Occurences
-------------------------------------------------- -----------------
INCAPACITATING INJURY                              9
NO INDICATION OF INJURY                            417
NONINCAPACITATING INJURY                           53
REPORTED, NOT EVIDENT                              28
*/
select cy."num" / py."den" as YOY_Growth_for_Fatal_Injuries
from (select cast(count(MOST_SEVERE_INJURY) as decimal(10,2)) - (select cast(count(MOST_SEVERE_INJURY) as decimal(10,2)) 
	                                                       from Chicago_Traffic_Crashes
														   where year(CRASH_DATE) = '2023'
														   and MOST_SEVERE_INJURY is not null
														   and INJURIES_FATAL >= 1) "num"
      from Chicago_Traffic_Crashes
      where year(CRASH_DATE) = '2024'
      and MOST_SEVERE_INJURY is not null
	  and INJURIES_FATAL >= 1) cy,
     (select cast(count(MOST_SEVERE_INJURY) as decimal(10,2)) "den"
      from Chicago_Traffic_Crashes
      where year(CRASH_DATE) = '2023'
      and MOST_SEVERE_INJURY is not null
	  and INJURIES_FATAL >= 1) py;
/*
YOY_Growth_for_Fatal_Injuries
---------------------------------------
-1.0000000000000
*/
select cy."num" / py."den" as YOY_Growth_for_Incapacitating_Injuries
from (select cast(count(MOST_SEVERE_INJURY) as decimal(10,2)) - (select cast(count(MOST_SEVERE_INJURY) as decimal(10,2)) 
	                                                       from Chicago_Traffic_Crashes
														   where year(CRASH_DATE) = '2023'
														   and MOST_SEVERE_INJURY is not null
														   and INJURIES_INCAPACITATING >= 1) "num"
      from Chicago_Traffic_Crashes
      where year(CRASH_DATE) = '2024'
      and MOST_SEVERE_INJURY is not null
	  and INJURIES_INCAPACITATING >= 1) cy,
     (select cast(count(MOST_SEVERE_INJURY) as decimal(10,2)) "den"
      from Chicago_Traffic_Crashes
      where year(CRASH_DATE) = '2023'
      and MOST_SEVERE_INJURY is not null
	  and INJURIES_INCAPACITATING >= 1) py;
/*
YOY_Growth_for_Incapacitating_Injuries
---------------------------------------
-0.9952928870292
*/
select cy."num" / py."den" as YOY_Growth_for_Non_Incapacitating_Injuries
from (select cast(count(MOST_SEVERE_INJURY) as decimal(10,2)) - (select cast(count(MOST_SEVERE_INJURY) as decimal(10,2)) 
	                                                       from Chicago_Traffic_Crashes
														   where year(CRASH_DATE) = '2023'
														   and MOST_SEVERE_INJURY is not null
														   and INJURIES_NON_INCAPACITATING >= 1) "num"
      from Chicago_Traffic_Crashes
      where year(CRASH_DATE) = '2024'
      and MOST_SEVERE_INJURY is not null
	  and INJURIES_NON_INCAPACITATING >= 1) cy,
     (select cast(count(MOST_SEVERE_INJURY) as decimal(10,2)) "den"
      from Chicago_Traffic_Crashes
      where year(CRASH_DATE) = '2023'
      and MOST_SEVERE_INJURY is not null
	  and INJURIES_NON_INCAPACITATING >= 1) py;
/*
YOY_Growth_for_Non_Incapacitating_Injuries
------------------------------------------
-0.9944405134943
*/
select cy."num" / py."den" as YOY_Growth_for_Reported_Not_Evident_Injuries
from (select cast(count(MOST_SEVERE_INJURY) as decimal(10,2)) - (select cast(count(MOST_SEVERE_INJURY) as decimal(10,2)) 
	                                                       from Chicago_Traffic_Crashes
														   where year(CRASH_DATE) = '2023'
														   and MOST_SEVERE_INJURY is not null
														   and INJURIES_REPORTED_NOT_EVIDENT >= 1) "num"
      from Chicago_Traffic_Crashes
      where year(CRASH_DATE) = '2024'
      and MOST_SEVERE_INJURY is not null
	  and INJURIES_REPORTED_NOT_EVIDENT >= 1) cy,
     (select cast(count(MOST_SEVERE_INJURY) as decimal(10,2)) "den"
      from Chicago_Traffic_Crashes
      where year(CRASH_DATE) = '2023'
      and MOST_SEVERE_INJURY is not null
	  and INJURIES_REPORTED_NOT_EVIDENT >= 1) py;
/*
YOY_Growth_for_Reported_Not_Evident_Injuries
--------------------------------------------
-0.9937314992164
*/
select cy."num" / py."den" as YOY_Growth_for_No_Indication_Injuries
from (select cast(count(MOST_SEVERE_INJURY) as decimal(10,2)) - (select cast(count(MOST_SEVERE_INJURY) as decimal(10,2)) 
	                                                       from Chicago_Traffic_Crashes
														   where year(CRASH_DATE) = '2023'
														   and MOST_SEVERE_INJURY is not null
														   and INJURIES_NO_INDICATION >= 1) "num"
      from Chicago_Traffic_Crashes
      where year(CRASH_DATE) = '2024'
      and MOST_SEVERE_INJURY is not null
	  and INJURIES_NO_INDICATION >= 1) cy,
     (select cast(count(MOST_SEVERE_INJURY) as decimal(10,2)) "den"
      from Chicago_Traffic_Crashes
      where year(CRASH_DATE) = '2023'
      and MOST_SEVERE_INJURY is not null
	  and INJURIES_NO_INDICATION >= 1) py;
/*
YOY_Growth_for_No_Indication_Injuries
---------------------------------------
-0.9954687688607
*/

 -- 3) Secondary KPI - Total accidents with respect to speed limit.
select distinct POSTED_SPEED_LIMIT,
                count(CRASH_RECORD_ID) "Num of Accidents"
from Chicago_Traffic_Crashes
group by POSTED_SPEED_LIMIT
order by [Num of Accidents] desc;
/*
POSTED_SPEED_LIMIT Num of Accidents
------------------ ----------------
30                 584923
35                 53296
25                 50243
20                 33134
15                 28212
10                 18491
40                 7606
0                  7398
45                 5284
5                  4638
55                 780
50                 225
3                  190
9                  96
39                 83
99                 66
60                 49
1                  41
24                 37
2                  28
32                 19
65                 18
34                 14
33                 13
11                 11
26                 9
6                  7
36                 6
7                  5
70                 5
14                 3
12                 3
29                 3
22                 3
4                  2
23                 2
8                  2
31                 2
38                 2
18                 2
16                 1
62                 1
49                 1
63                 1
44                 1
*/

 -- 4) Accidents by road type for current year.
select TRAFFICWAY_TYPE, 
       count(CRASH_RECORD_ID) "Num of Accidents"
from Chicago_Traffic_Crashes
where year(CRASH_DATE) = '2024'
group by TRAFFICWAY_TYPE
order by [Num of Accidents] desc;
/*
TRAFFICWAY_TYPE                                    Num of Accidents
-------------------------------------------------- ----------------
NOT DIVIDED                                        193
FOUR WAY                                           81
ONE-WAY                                            56
DIVIDED - W/MEDIAN (NOT RAISED)                    55
DIVIDED - W/MEDIAN BARRIER                         32
PARKING LOT                                        32
OTHER                                              17
T-INTERSECTION                                     12
UNKNOWN                                            8
ALLEY                                              7
CENTER TURN LANE                                   5
NOT REPORTED                                       4
DRIVEWAY                                           2
FIVE POINT, OR MORE                                2
UNKNOWN INTERSECTION TYPE                          2
*/

 -- 5) Current year accidents by weather condition.
select WEATHER_CONDITION,
       count(CRASH_RECORD_ID) "Num of Accidents"
from Chicago_Traffic_Crashes
where year(CRASH_DATE) = '2024'
group by WEATHER_CONDITION
order by "Num of Accidents" desc;
/*
WEATHER_CONDITION                                  Num of Accidents
-------------------------------------------------- ----------------
CLEAR                                              360
UNKNOWN                                            59
CLOUDY/OVERCAST                                    34
SNOW                                               26
RAIN                                               17
FREEZING RAIN/DRIZZLE                              4
OTHER                                              4
FOG/SMOKE/HAZE                                     2
SLEET/HAIL                                         1
BLOWING SNOW                                       1
*/

-- This concludes my analysis of this dataset. I have utilized the power of Sql to answer a host of questions and to calculate and identify a few key point indicators for business needs.