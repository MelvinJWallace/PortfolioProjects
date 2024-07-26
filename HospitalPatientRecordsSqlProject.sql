/* 
   I will be playing the role of an Analytics Consultant for Massachusetts General Hospital (MGH). I have been asked to build a high-level KPI report for the executive team, based on a subset of patient records.
   The purpose of the report is to give stakeholders visibility into the hospital's recent performance, and answer the following questions:

   - How many patients have been admitted or readmitted over time?
   - How long are patients staying in the hospital, on average?
   - How much is the average cost per visit?
   - How many procedures are covered by insurance?

   The CEO has asked me to summarize any insights that I can derive from the sample provided.

** The dataset for this project has been retrieved from the mavenanalytics.io website. This is synthetic data on roughly 1000 patients of Massachussets General Hospital from the years of 2011 through 2022, which
   includes information on patient demographics, insurance coverage, and medical encounter and procedures.                                                                                                         
*/

/* Before I begin my analysis and answering of the questions, I will start by examining the data. This will let me know if any data cleaning is necessary. 

   I will start by viewing the first and last 5 rows of each table to check for consistency.
*/

-----------------------
-- DATA EXAMINATION --
-----------------------

select top 5 *from encounters 
/*
Id                                                 START                                              STOP                                               PATIENT                                            ORGANIZATION                                       PAYER                                              ENCOUNTERCLASS                                     CODE        DESCRIPTION                                                           BASE_ENCOUNTER_COST    TOTAL_CLAIM_COST       PAYER_COVERAGE         REASONCODE           REASONDESCRIPTION
-------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ----------- --------------------------------------------------------------------- ---------------------- ---------------------- ---------------------- -------------------- -----------------
32c84703-2481-49cd-d571-3899d5820253               2011-01-02T09:26:36Z                               2011-01-02T12:58:36Z                               3de74169-7f67-9304-91d4-757e0f3a14d2               d78e84ec-30aa-3bba-a33a-f29a3a454662               b1c428d6-4f07-31e0-90f0-68ffa6ff8c76               ambulatory                                         185347001   Encounter for problem (procedure)                                     85.5500030517578       1018.02001953125       0                      NULL                 NULL
c98059da-320a-c0a6-fced-c8815f3e3f39               2011-01-03T05:44:39Z                               2011-01-03T06:01:42Z                               d9ec2e44-32e9-9148-179a-1653348cc4e2               d78e84ec-30aa-3bba-a33a-f29a3a454662               b1c428d6-4f07-31e0-90f0-68ffa6ff8c76               outpatient                                         308335008   Patient encounter procedure                                           142.580001831055       2619.36010742188       0                      NULL                 NULL
4ad28a3a-2479-782b-f29c-d5b3f41a001e               2011-01-03T14:32:11Z                               2011-01-03T14:47:11Z                               73babadf-5b2b-fee7-189e-6f41ff213e01               d78e84ec-30aa-3bba-a33a-f29a3a454662               7caa7254-5050-3b5e-9eae-bd5ea30e809c               outpatient                                         185349003   Encounter for check up (procedure)                                    85.5500030517578       461.589996337891       305.269989013672       NULL                 NULL
c3f4da61-e4b4-21d5-587a-fbc89943bc19               2011-01-03T16:24:45Z                               2011-01-03T16:39:45Z                               3b46a0b7-0f34-9b9a-c319-ace4a1f58c0b               d78e84ec-30aa-3bba-a33a-f29a3a454662               b1c428d6-4f07-31e0-90f0-68ffa6ff8c76               wellness                                           162673000   General examination of patient (procedure)                            136.800003051758       1784.23999023438       0                      NULL                 NULL
a9183b4f-2572-72ea-54c2-b3cd038b4be7               2011-01-03T17:36:53Z                               2011-01-03T17:51:53Z                               fa006887-d93c-d302-8b89-f3c25f88c0e1               d78e84ec-30aa-3bba-a33a-f29a3a454662               42c4fca7-f8a9-3cd1-982a-dd9751bf3e2a               ambulatory                                         390906007   Follow-up encounter                                                   85.5500030517578       234.720001220703       0                      55822004             Hyperlipidemia
*/
select top 5 * from encounters order by [START] desc
/*
Id                                                 START                                              STOP                                               PATIENT                                            ORGANIZATION                                       PAYER                                              ENCOUNTERCLASS                                     CODE        DESCRIPTION                                                           BASE_ENCOUNTER_COST    TOTAL_CLAIM_COST       PAYER_COVERAGE         REASONCODE           REASONDESCRIPTION
-------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ----------- --------------------------------------------------------------------- ---------------------- ---------------------- ---------------------- -------------------- -----------------
64dfd3ce-7123-fa23-ec24-f74b492553e2               2022-02-05T20:27:36Z                               2022-02-05T20:42:36Z                               e2d8e1ed-6f63-54e2-d14e-8346799e92ef               d78e84ec-30aa-3bba-a33a-f29a3a454662               7caa7254-5050-3b5e-9eae-bd5ea30e809c               wellness                                           308646001   Death Certification                                                   136.800003051758       0                      0                      88805009             Chronic congestive heart failure (disorder)
01b57f06-cebe-a3e4-4423-a796ffb0c35d               2022-01-29T20:35:37Z                               2022-01-29T20:50:37Z                               ff1b3c26-53a6-4590-ce79-a3f7269274ea               d78e84ec-30aa-3bba-a33a-f29a3a454662               b1c428d6-4f07-31e0-90f0-68ffa6ff8c76               ambulatory                                         424619006   Prenatal visit                                                        142.580001831055       11984.2900390625       0                      72892002             Normal pregnancy
7d435668-0813-eb3b-0f26-cb741fb39561               2022-01-29T20:35:37Z                               2022-01-29T20:50:37Z                               ff1b3c26-53a6-4590-ce79-a3f7269274ea               d78e84ec-30aa-3bba-a33a-f29a3a454662               b1c428d6-4f07-31e0-90f0-68ffa6ff8c76               wellness                                           162673000   General examination of patient (procedure)                            136.800003051758       408.799987792969       0                      NULL                 NULL
07710480-9d6b-9c9b-87c3-c1d54df4069d               2022-01-29T20:12:53Z                               2022-01-29T20:27:53Z                               20a4bc24-6b69-2f5c-dc74-1df390cae25b               d78e84ec-30aa-3bba-a33a-f29a3a454662               7caa7254-5050-3b5e-9eae-bd5ea30e809c               urgentcare                                         702927004   Urgent care clinic (procedure)                                        142.580001831055       10588.33984375         8438.669921875         NULL                 NULL
917bb534-2ed3-e1f5-ac27-74f314d19c63               2022-01-29T11:42:06Z                               2022-01-29T11:57:06Z                               0c122290-8c15-77ac-b418-2fea4e8a8e6a               d78e84ec-30aa-3bba-a33a-f29a3a454662               7c4411ce-02f1-39b5-b9ec-dfbea9ad3c1a               outpatient                                         185349003   Encounter for check up (procedure)                                    85.5500030517578       85.5500030517578       24.2700004577637       NULL                 NULL

(This table will require some data cleaning, I will need to clean the 'START' and 'STOP' columns by creating new start date/time and stop date/time columns and convert them to the correct date and time datatypes)
*/
select top 5 * from organizations
/*
Id                                                 NAME                                               ADDRESS                                            CITY                                               STATE                                              ZIP    LAT                    LON
-------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ------ ---------------------- ----------------------
d78e84ec-30aa-3bba-a33a-f29a3a454662               MASSACHUSETTS GENERAL HOSPITAL                     55 FRUIT STREET                                    BOSTON                                             MA                                                 2114   42.3628120422363       -71.0691833496094

(This table only has one row and does not require any data cleaning)
*/
select top 5 * from patients order by BIRTHDATE asc
/*
Id                                                 BIRTHDATE  DEATHDATE  PREFIX                                             FIRST                                              LAST                                               SUFFIX                                             MAIDEN                                             MARITAL                                            RACE                                               ETHNICITY                                          GENDER                                             BIRTHPLACE                                         ADDRESS                                            CITY                                               STATE                                              COUNTY                                             ZIP    LAT                    LON
-------------------------------------------------- ---------- ---------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ------ ---------------------- ----------------------
fc81fad8-86e1-4df2-0613-25019adf3e5d               1922-03-24 NULL       Mrs.                                               Elwanda490                                         Casper496                                          NULL                                               Hoeger474                                          M                                                  black                                              nonhispanic                                        F                                                  Pembroke  Massachusetts  US                        631 Reynolds Fort                                  Medford                                            Massachusetts                                      Middlesex County                                   2155   42.3491630554199       -71.1282653808594
de1f6a21-bdd3-0ccd-8a3c-b06e98a13cf2               1922-03-30 NULL       Mrs.                                               Lulu18                                             Carter549                                          NULL                                               Turcotte120                                        M                                                  white                                              nonhispanic                                        F                                                  Waltham  Massachusetts  US                         932 Legros Glen                                    Cambridge                                          Massachusetts                                      Middlesex County                                   2139   42.384105682373        -71.0722122192383
d1629b63-3486-1537-a088-cd641d231e86               1922-04-13 NULL       Mr.                                                Lazaro919                                          Osinski784                                         NULL                                               NULL                                               M                                                  white                                              nonhispanic                                        M                                                  West Concord  Massachusetts  US                    300 Abbott Overpass Suite 29                       Hull                                               Massachusetts                                      Plymouth County                                    2045   42.2887420654297       -70.9357757568359
b2b5f8d2-9ba8-f517-5ce5-3f246a0eee52               1922-04-15 NULL       Mr.                                                Horace32                                           Cremin516                                          NULL                                               NULL                                               S                                                  white                                              nonhispanic                                        M                                                  Duxbury  Massachusetts  US                         867 Auer Landing                                   Hingham                                            Massachusetts                                      Plymouth County                                    2043   42.2542839050293       -70.9002532958984
2607919d-bfeb-acb1-9bf4-3716a460f970               1922-05-31 2012-07-11 Mr.                                                Armando772                                         Barela183                                          NULL                                               NULL                                               M                                                  white                                              hispanic                                           M                                                  Juarez  Chihuahua  MX                              462 Boyle Esplanade                                Boston                                             Massachusetts                                      Suffolk County                                     2118   42.3552627563477       -71.0415344238281
*/
select top 5 * from patients order by BIRTHDATE desc
/*
Id                                                 BIRTHDATE  DEATHDATE  PREFIX                                             FIRST                                              LAST                                               SUFFIX                                             MAIDEN                                             MARITAL                                            RACE                                               ETHNICITY                                          GENDER                                             BIRTHPLACE                                         ADDRESS                                            CITY                                               STATE                                              COUNTY                                             ZIP    LAT                    LON
-------------------------------------------------- ---------- ---------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ------ ---------------------- ----------------------
1278fd47-3048-8534-9bc5-07a90d596b01               1991-11-27 NULL       Mrs.                                               Jerica256                                          Glover433                                          NULL                                               Roberts511                                         M                                                  other                                              nonhispanic                                        F                                                  Plymouth  Massachusetts  US                        289 Ledner Fort Suite 96                           Boston                                             Massachusetts                                      Suffolk County                                     2199   42.329475402832        -71.0164489746094
b1718eb9-d687-b7f6-d6a3-ed99fb61d3f8               1991-10-04 NULL       Mrs.                                               Keva141                                            Cummerata161                                       NULL                                               Rau926                                             M                                                  white                                              nonhispanic                                        F                                                  Northborough  Massachusetts  US                    950 Hudson Parade                                  Quincy                                             Massachusetts                                      Norfolk County                                     2186   42.2870941162109       -71.0203018188477
238ae918-f31e-2866-4dc5-de654dc5df20               1991-10-01 NULL       Mrs.                                               Ricarda574                                         Crooks415                                          NULL                                               Bosco882                                           M                                                  white                                              nonhispanic                                        F                                                  Marlborough  Massachusetts  US                     543 Greenholt Extension                            Boston                                             Massachusetts                                      Suffolk County                                     2163   42.379768371582        -71.0643768310547
cfad5cec-7809-7ba0-716b-5c892a4c3e9f               1991-09-23 NULL       Mr.                                                Daniel959                                          Feeney44                                           NULL                                               NULL                                               M                                                  white                                              nonhispanic                                        M                                                  Westborough  Massachusetts  US                     474 Breitenberg Branch                             Chelsea                                            Massachusetts                                      Suffolk County                                     2149   42.3740272521973       -71.0386657714844
b190fd1c-295d-b2de-7844-f1836f081dc0               1991-08-03 NULL       Mrs.                                               Diana207                                           Espinal146                                         NULL                                               √Åvalos396                                         M                                                  black                                              hispanic                                           F                                                  Salisbury  Saint Joseph Parish  DM                 807 Hyatt Junction Apt 41                          Boston                                             Massachusetts                                      Suffolk County                                     2114   42.3795776367188       -71.0474700927734

(This table will require some data cleaning. The columns 'FIRST', 'LAST', 'MAIDEN', and 'BIRTHPLACE' will need to be cleaned up)
*/
select top 5 * from payers order by NAME asc
/*
Id                                                 NAME                                               ADDRESS                                            CITY                                               STATE_HEADQUARTERED                                ZIP         PHONE
-------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ----------- --------------------------------------------------
4d71f845-a6a9-3c39-b242-14d25ef86a8d               Aetna                                              151 Farmington Ave                                 Hartford                                           CT                                                 6156        1-800-872-3862
42c4fca7-f8a9-3cd1-982a-dd9751bf3e2a               Anthem                                             220 Virginia Ave                                   Indianapolis                                       IN                                                 46204       1-800-331-1476
6e2f1a2d-27bd-3701-8d08-dae202c58632               Blue Cross Blue Shield                             Michigan Plaza                                     Chicago                                            IL                                                 60007       1-800-262-2583
047f6ec3-6215-35eb-9608-f9dda363a44c               Cigna Health                                       900 Cottage Grove Rd                               Bloomfield                                         CT                                                 6002        1-800-997-1654
b3221cfc-24fb-339e-823d-bc4136cbc4ed               Dual Eligible                                      7500 Security Blvd                                 Baltimore                                          MD                                                 21244       1-877-267-2323
*/
select top 5 * from payers order by NAME desc
/*
Id                                                 NAME                                               ADDRESS                                            CITY                                               STATE_HEADQUARTERED                                ZIP         PHONE
-------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ----------- --------------------------------------------------
5059a55e-5d6e-34d1-b6cb-d83d16e57bcf               UnitedHealthcare                                   9800 Healthcare Lane                               Minnetonka                                         MN                                                 55436       1-888-545-5205
b1c428d6-4f07-31e0-90f0-68ffa6ff8c76               NO_INSURANCE                                       NULL                                               NULL                                               NULL                                               NULL        NULL
7caa7254-5050-3b5e-9eae-bd5ea30e809c               Medicare                                           7500 Security Blvd                                 Baltimore                                          MD                                                 21244       1-800-633-4227
7c4411ce-02f1-39b5-b9ec-dfbea9ad3c1a               Medicaid                                           7500 Security Blvd                                 Baltimore                                          MD                                                 21244       1-877-267-2323
d47b3510-2895-3b70-9897-342d681c769d               Humana                                             500 West Main St                                   Louisville                                         KY                                                 40018       1-844-330-7799

(This table is sufficient and does not require any data cleaning)
*/
select top 5 * from procedures order by START asc
/*
START                                              STOP                                               PATIENT                                            ENCOUNTER                                          CODE                 DESCRIPTION                                                                                                                                                                                                                                                      BASE_COST   REASONCODE           REASONDESCRIPTION
-------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----------- -------------------- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
2011-01-02T09:26:36Z                               2011-01-02T12:58:36Z                               3de74169-7f67-9304-91d4-757e0f3a14d2               32c84703-2481-49cd-d571-3899d5820253               265764009            Renal dialysis (procedure)                                                                                                                                                                                                                                       903         NULL                 NULL
2011-01-03T05:44:39Z                               2011-01-03T06:01:42Z                               d9ec2e44-32e9-9148-179a-1653348cc4e2               c98059da-320a-c0a6-fced-c8815f3e3f39               76601001             Intramuscular injection                                                                                                                                                                                                                                          2477        NULL                 NULL
2011-01-04T14:49:55Z                               2011-01-04T15:04:55Z                               d856d6e6-4c98-e7a2-129b-44076c63d008               2cfd4ddd-ad13-fe1e-528b-15051cea2ec3               703423002            Combined chemotherapy and radiation therapy (procedure)                                                                                                                                                                                                          11620       363406005            Malignant tumor of colon
2011-01-05T04:02:09Z                               2011-01-05T04:17:09Z                               bc9d59c3-0a30-6e3b-f47d-022e4f03c8de               17966936-0878-f4db-128b-a43ae10d0878               173160006            Diagnostic fiberoptic bronchoscopy (procedure)                                                                                                                                                                                                                   9796        162573006            Suspected lung cancer (situation)
2011-01-05T12:58:36Z                               2011-01-05T16:42:36Z                               3de74169-7f67-9304-91d4-757e0f3a14d2               9de5f0b0-4ba4-ce6f-45fb-b55c202f31a5               265764009            Renal dialysis (procedure)  
*/
select top 5 * from procedures order by START desc
/*
START                                              STOP                                               PATIENT                                            ENCOUNTER                                          CODE                 DESCRIPTION                                                                                                                                                                                                                                                      BASE_COST   REASONCODE           REASONDESCRIPTION
-------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -------------------- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----------- -------------------- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
2022-01-29T20:35:37Z                               2022-01-29T20:50:37Z                               ff1b3c26-53a6-4590-ce79-a3f7269274ea               01b57f06-cebe-a3e4-4423-a796ffb0c35d               430193006            Medication Reconciliation (procedure)                                                                                                                                                                                                                            413         NULL                 NULL
2022-01-29T20:35:37Z                               2022-01-29T20:50:37Z                               ff1b3c26-53a6-4590-ce79-a3f7269274ea               01b57f06-cebe-a3e4-4423-a796ffb0c35d               274804006            Evaluation of uterine fundal height                                                                                                                                                                                                                              3238        72892002             Normal pregnancy
2022-01-29T20:35:37Z                               2022-01-29T20:50:37Z                               ff1b3c26-53a6-4590-ce79-a3f7269274ea               01b57f06-cebe-a3e4-4423-a796ffb0c35d               225158009            Auscultation of the fetal heart                                                                                                                                                                                                                                  7045        72892002             Normal pregnancy
2022-01-29T20:35:37Z                               2022-01-29T20:50:37Z                               ff1b3c26-53a6-4590-ce79-a3f7269274ea               01b57f06-cebe-a3e4-4423-a796ffb0c35d               118001005            Streptococcus pneumoniae group B antigen test                                                                                                                                                                                                                    1559        72892002             Normal pregnancy
2022-01-29T20:35:37Z                               2022-01-29T21:08:12Z                               ff1b3c26-53a6-4590-ce79-a3f7269274ea               01b57f06-cebe-a3e4-4423-a796ffb0c35d               710824005            Assessment of health and social care needs (procedure)  

(This table also will require some data cleaning. I will need to clean the 'START' and 'STOP' columns and convert them to the correct datatypes)
*/

--------------------
-- DATA CLEANING --
--------------------

-- So I will begin with the 'encounters' table. I will create 2 new columns; 'Start_Date_Time', and Stop_Date_Time' and convert those columns to datetime datatypes. Then I will extract the values from
-- the original 'START' and 'STOP' columns and replace those values with the cleaned values that can be stored in the newly created columns with the proper datatypes.
alter table encounters
add Start_Date_Time datetime;

alter table encounters
add Stop_Date_Time datetime;

-- (Now the two new columns have been added to the table 'encounters', Now I will clean those new columns by filling them with the values of the original 'START' and 'STOP' column values minus the non numeric characters.)
update encounters
set Start_Date_Time = replace(START, '[A-Z]', ' ');

update encounters
set Stop_Date_Time = replace(STOP, '[A-Z]', ' ');

-- (Now the two new columns have been filled with the correct values, I will preview a few rows of the data to verify.)
select top 3 Start_Date_Time, Stop_Date_Time
from encounters;
/*
Start_Date_Time         Stop_Date_Time
----------------------- -----------------------
2011-01-02 09:26:36.000 2011-01-02 12:58:36.000
2011-01-03 05:44:39.000 2011-01-03 06:01:42.000
2011-01-03 14:32:11.000 2011-01-03 14:47:11.000
*/

-- I will test both new columns to verify that I can extract the year, month, and day from them, as well as the hour, minute, and second from them. 
select top 3 year(Start_Date_Time) "start year",
             month(Start_Date_Time) "start month",
	         day(Start_Date_Time) "start day",
			 datepart(hour, Start_Date_Time) "start hour",
			 datepart(minute, Start_Date_Time) "start minute",
			 datepart(second, Start_Date_Time) "start second"
from encounters;
/*
start year  start month start day   start hour  start minute start second
----------- ----------- ----------- ----------- ------------ ------------
2011        1           2           9           26           36
2011        1           3           5           44           39
2011        1           3           14          32           11
*/

select top 3 year(Stop_Date_Time) "stop year",
             month(Stop_Date_Time) "stop month",
	         day(Stop_Date_Time) "stop day",
			 datepart(hour, Stop_Date_Time) "stop hour",
			 datepart(minute, Stop_Date_Time) "stop minute",
			 datepart(second, Stop_Date_Time) "stop second"
from encounters;
/*
stop year   stop month  stop day    stop hour   stop minute stop second
----------- ----------- ----------- ----------- ----------- -----------
2011        1           2           12          58          36
2011        1           3           6           1           42
2011        1           3           14          47          11
*/

-- The next table I will begin with is the 'patients' table. This table has 3 columns 'FIRST', 'LAST', and 'MAIDEN' that have numeric characters at the end of the names that need to be removed. I will create 
-- new column names for each column with the cleaned values from the original columns. I will also split the 'BIRTHPLACE' column and extract the Country value from it and create a seperate columns for
-- those values.
alter table patients
add First_Name varchar(100);

alter table patients
add Last_Name varchar(100);

alter table patients
add Maiden_Name varchar(100);

-- Now that the new columns have been added, I will now fill those columns with the values of the cleaned columns.
update patients
set First_Name = translate(FIRST, '0123456789', '          ');

update patients
set Last_Name = translate(LAST, '0123456789', '          ');

update patients
set Maiden_Name = translate(MAIDEN, '0123456789', '          ');

-- I will check the first 3 rows of the new columns to make sure all of the values are correct.
select top 3 First_Name, Last_Name, Maiden_Name
from patients;
/*
First_Name                                  Last_Name                                             Maiden_Name
------------------------------------------- ----------------------------------------------------- -----------
Nikita                                      Erdman                                                Leannon  
Zane                                        Hodkiewicz                                            NULL
Quinn                                       Marquardt                                             NULL

Perfect! The values in the new columns now have all of the numeric characters removed, and are reflecting just the names.
*/

-- Now I can create the new column and fill it with the values from the 'BIRTHPLACE' column associated with the country.
alter table patients
add Birth_Country varchar(50);

update patients
set Birth_Country = right(BIRTHPLACE, 2);

-- I will verify that the changes have been made.
select top 10 Birth_Country from patients
/*
Birth_Country
--------------------------------------------------
US
US
US
US
US
US
CN
US
US
US
*/

-- ( I can now move on to the last table, the 'procedures' table, where I will extract the date and time from the 'START' and 'STOP' columns and enter those values into their own seperate created columns.)
alter table procedures
add Procedure_Start_Date_Time datetime;

alter table procedures
add Procedure_Stop_Date_Time datetime;

-- Now that I have created the two new columns, I will fill them with the values from the original columns, minus the non numeric characters.
update procedures
set Procedure_Start_Date_Time = replace(START, '[A-Z]', ' ');

update procedures 
set Procedure_Stop_Date_Time = replace(STOP, '[A-Z]', ' ');

-- I will view the first few rows of the new columns to ensure the data is correct.
select top 3 Procedure_Start_Date_Time, Procedure_Stop_Date_Time
from procedures;
/*
Procedure_Start_Date_Time Procedure_Stop_Date_Time
------------------------- ------------------------
2011-01-02 09:26:36.000   2011-01-02 12:58:36.000
2011-01-03 05:44:39.000   2011-01-03 06:01:42.000
2011-01-04 14:49:55.000   2011-01-04 15:04:55.000
*/

-- I will test both date columns to verify that I can extract the year, month, and day from them, as well as the hour, minute, and second from them. 
select top 3 year(Procedure_Start_Date_Time) "procedure start year",
             month(Procedure_Start_Date_Time) "procedure start month",
	         datename(day, Procedure_Start_Date_Time) "procedure start day",
			 datepart(hour, Procedure_Start_Date_Time) "procedure start hour",
			 datepart(minute, Procedure_Start_Date_Time) "procedure start minute",
			 datepart(second, Procedure_Start_Date_Time) "procedure start second"
from procedures;
/*
procedure start year procedure start month procedure start day            procedure start hour procedure start minute procedure start second
-------------------- --------------------- ------------------------------ -------------------- ---------------------- ----------------------
2011                 1                     2                              9                    26                     36
2011                 1                     3                              5                    44                     39
2011                 1                     4                              14                   49                     55
*/

select top 3 year(Procedure_Stop_Date_Time) "procedure stop year",
             month(Procedure_Stop_Date_Time) "procedure stop month",
	         day(Procedure_Stop_Date_Time) "procedure stop day",
	         datepart(hour, Procedure_Stop_Date_Time) "procedure stop hour",
	         datepart(minute, Procedure_Stop_Date_Time) "procedure stop minute",
	         datepart(second, Procedure_Stop_Date_Time) "procedure stop second"
from procedures;
/*
procedure stop year procedure stop month procedure stop day procedure stop hour procedure stop minute procedure stop second
------------------- -------------------- ------------------ ------------------- --------------------- ---------------------
2011                1                    2                  12                  58                    36
2011                1                    3                  6                   1                     42
2011                1                    4                  15                  4                     55
*/

-- Checking for duplicate rows of data in each table
select *
from (select *, row_number() over(partition by id order by Start_Date asc) "duplicates rows in 'encounters' table"
      from encounters) d
where d.[duplicates rows in 'encounters' table] >= 2;
/*
Id     START      STOP      PATIENT      ORGANIZATION      PAYER      ENCOUNTERCLASS      CODE        DESCRIPTION         BASE_ENCOUNTER_COST    TOTAL_CLAIM_COST       PAYER_COVERAGE         REASONCODE        REASONDESCRIPTION       Start_Date   Stop_Date    Start_Time       Stop_Time        duplicates rows in 'encounters' table
-------------------------------------------------- -------------------------------------------------- ---------------------------------------------------- ---------------------- ---------------------- -------------------- ----------------------------------   ---------------- ---------------- -------------------------------------

The table 'encounters' has 0 rows of duplicated data.
*/
select *
from (select *, row_number() over(partition by id order by id) "duplicate rows in 'organization' table"
      from organizations) d
where d.[duplicate rows in 'organization' table] >= 2;
/*
Id             NAME            ADDRESS           CITY                STATE           ZIP    LAT          LON          duplicate rows in 'organization' table
-------------- --------------- ----------------- ------------------------------------------ ------------------------- --------------------------------------

The table 'organizations' has 0 rows of duplicated data.
*/
select *
from (select *, row_number() over(partition by Id order by BIRTHDATE asc) "duplicate rows in 'patients' table"
      from patients) d
where d.[duplicate rows in 'patients' table] >= 2;
/*
Id      BIRTHDATE  DEATHDATE  PREFIX    FIRST    LAST     SUFFIX      MAIDEN     MARITAL       RACE     ETHNICITY       GENDER    BIRTHPLACE       ADDRESS      CITY     STATE      COUNTY        ZIP    LAT         LON        First_Name         Last_Name            Maiden_Name            Birth_Country       duplicate rows in 'patients' table
------- ---------- ---------- --------- -------- -------- ----------- --------- ------------- --------- --------------- --------- ---------------- ------------ -------- ---------- ------------- ------ ----------- ---------- ------------------ -------------------- ---------------------- ------------------- ----------------------------------

The table 'patients' has 0 rows of duplicated data.
*/
select *
from (select *, row_number() over(partition by Id order by Id) "Duplicate rows in 'payers' table"
      from payers) d
where d.[Duplicate rows in 'payers' table] >= 2;
/*
Id      NAME      ADDRESS       CITY        STATE_HEADQUARTERED        ZIP         PHONE       Duplicate rows in 'payers' table
------- --------- ------------- ----------- -------------------------- ----------- ----------- --------------------------------

The table 'payers' has 0 rows of duplicated data.
*/
select count(*) "Num of duplicate patients"
from (select *, row_number() over(partition by PATIENT order by Procedure_Start_Date asc) "Duplicate rows in 'procedures' table"
      from procedures) d
where d.[Duplicate rows in 'procedures' table] >= 2;
/* Num of duplicate patients
-------------------------
46908

Out of all the patients, 46,908 of them have been seen more than once.
*/

-- Now that all of the tables have been cleaned, I can now move on to answering the questions inquired by the stakeholders.

--------------
-- QUESTIONS:
--------------

 -- 1) How many patients have been admitted or readmitted over time?

  -- Total Patients Admitted --
select count(distinct Id) "Num of Patients"
from encounters
order by [Num of Patients] desc;
/*
Num of Patients
---------------
27891

---------------------------------------------------------
There has been 27,891 patients admitted to this hospital.
---------------------------------------------------------
*/

 -- 2) How long are patients staying in the hospital, on average?

  -- Avg Stay in Hospital in Minutes --
select avg(datediff(minute, Start_Date_Time, Stop_Date_Time)) "Average Minutes Stayed in Hospital by Patients"
from encounters;
/*
Average Minutes Stayed in Hospital by Patients
----------------------------------------------
435

---------------------------------------------------------
The average patients stay in the hospital is 435 minutes.
---------------------------------------------------------
*/

  -- Avg Stay in Hospital in Hours -- 
select avg(datediff(hour, Start_Date_Time, Stop_Date_Time)) "Average Hours Stayed in Hospital by Patients"
from encounters;
/*
Average Hours Stayed in Hospital by Patients
--------------------------------------------
7

-----------------------------------------------------
The average patients stay in the hospital is 7 hours.
-----------------------------------------------------
*/

 -- 3) How much is the average cost per visit?

  -- Avg Base Cost Per Visit --
select round(avg(BASE_ENCOUNTER_COST), 2) "Average Base Cost Per Visit"
from encounters;
/*
Average Base Cost Per Visit
---------------------------
116.18

--------------------------------------------------------
The average base cost per visit for patients is $116.18.
--------------------------------------------------------
*/

  -- Avg Total Claim Cost Per Visit --
select round(avg(TOTAL_CLAIM_COST), 2) "Average Total Claim Cost Per Visit"
from encounters;
/*
Average Total Claim Cost Per Visit
----------------------------------
3639.68

-----------------------------------------------------------------
The average total claim cost per visit for patients is $3,639.68.
-----------------------------------------------------------------
*/

 -- 4) How many procedures are covered by insurance?
select count(p.ENCOUNTER) "Num of Procedures Covered by Insurance"
from encounters e
inner join procedures p
on p.ENCOUNTER = e.Id
inner join payers pa
on e.PAYER = pa.Id
where pa.NAME not like 'NO_INSURANCE'
/*
Num of Procedures Covered by Insurance
--------------------------------------
32599

---------------------------------------------------------------------
There has been 32,599 procedures that have been covered by insurance.
---------------------------------------------------------------------
*/

--------------------------------
 --EXPLORATORY DATA ANALYSIS --
 -------------------------------

  -- Total Patients Admitted by Year --
select count(distinct Id) "Num of Patients",
       year(Start_Date_Time) "Admitted Year"
from encounters
group by year(Start_Date_Time)
order by [Admitted Year] asc;
/*
Num of Patients Admitted Year
--------------- -------------
1336            2011
2106            2012
2495            2013
3885            2014
2469            2015
2451            2016
2360            2017
2292            2018
2228            2019
2519            2020
3530            2021
220             2022
*/

  -- Total Patients Admitted by Month --
select *,
	case
		when "Admitted Month" = 1 then 'January'
		when "Admitted Month" = 2 then 'Feburary'
		when "Admitted Month" = 3 then 'March'
		when "Admitted Month" = 4 then 'April'
		when "Admitted Month" = 5 then 'May'
		when "Admitted Month" = 6 then 'June'
		when "Admitted Month" = 7 then 'July'
		when "Admitted Month" = 8 then 'August'
		when "Admitted Month" = 9 then 'September'
		when "Admitted Month" = 10 then 'October'
		when "Admitted Month" = 11 then 'November'
		when "Admitted Month" = 12 then 'December'
	end as "Month Name"
from (select count(distinct Id) "Num of Patients",
             month(Start_Date_Time) "Admitted Month"
      from encounters
      group by month(Start_Date_Time)) m
order by m.[Admitted Month] asc;
/*
Num of Patients Admitted Month Month Name
--------------- -------------- ----------
2217            1              January
3028            2              Feburary
2688            3              March
2312            4              April
2374            5              May
2181            6              June
2182            7              July
2129            8              August
2113            9              September
2087            10             October
2333            11             November
2247            12             December
*/

  -- Total Patients Admitted by Day --
select *,
	case 
		when "Admitted Day" = 1 then 'Monday'
		when "Admitted Day" = 2 then 'Tuesday'
		when "Admitted Day" = 3 then 'Wednesday'
		when "Admitted Day" = 4 then 'Thursday'
		when "Admitted Day" = 5 then 'Friday'
		when "Admitted Day" = 6 then 'Saturday'
		when "Admitted Day" = 7 then 'Sunday'
	end as "Day Name"
from (select count(distinct Id) "Number of Patients",
             datepart(dw, Start_Date_Time) "Admitted Day"
      from encounters
      group by datepart(dw, Start_Date_Time)) d
order by d.[Admitted Day] asc;
/*
Number of Patients Admitted Day Day Name
------------------ ------------ ---------
3973               1            Monday
4405               2            Tuesday
3644               3            Wednesday
4370               4            Thursday
3477               5            Friday
4059               6            Saturday
3963               7            Sunday
*/

  -- Min Stay in Hospital in Minutes --
select min(datediff(minute, Start_Date_Time, Stop_Date_Time)) "Minimum Minutes Stayed in Hospital by Patients"
from encounters;
/*
Minimum Minutes Stayed in Hospital by Patients
----------------------------------------------
15

---------------------------------------------------------
The minimum patients stay in the hospital was 15 minutes.
---------------------------------------------------------
*/

  -- Max Stay in Hospital in Hours --
select max(datediff(hour, Start_Date_Time, Stop_Date_Time)) "Maximum Hours Stayed in Hospital by Patients"
from encounters;
/*
Maximum Hours Stayed in Hospital by Patients
--------------------------------------------
44930

-----------------------------------------------------------------------------
The maximum patients stay in the hospital was 44,930 hours, which is 5 years.
-----------------------------------------------------------------------------
*/

  -- Max Base Cost Per Visit --
select round(max(BASE_ENCOUNTER_COST), 2) "Maximum Base Cost Per Visit"
from encounters;
/*
Maximum Base Cost Per Visit
---------------------------
146.18

--------------------------------------------------------
The maximum base cost per visit for patients is $146.18.
--------------------------------------------------------
*/

  -- Min Base Cost Per Visit -- 
select round(min(BASE_ENCOUNTER_COST), 2) "Minimum Base Cost Per Visit"
from encounters;
/*
Minimum Base Cost Per Visit
---------------------------
85.55

-------------------------------------------------------
The minimum base cost per visit for patients is $85.55.
-------------------------------------------------------
*/

  -- Avg Base Cost Per Visit by Encounter Class --
select round(avg(BASE_ENCOUNTER_COST), 2) "Average Base Cost Per Visit by Encounter Class",
       ENCOUNTERCLASS
from encounters
group by ENCOUNTERCLASS
order by [Average Base Cost Per Visit by Encounter Class] desc;
/*
Average Base Cost Per Visit by Encounter Class ENCOUNTERCLASS
---------------------------------------------- --------------------------------------------------
145.25                                         emergency
142.58                                         urgentcare
136.8                                          wellness
113.67                                         inpatient
105.73                                         ambulatory
105.04                                         outpatient
*/

  -- Avg Base Cost Per Visit by Gender --
select round(avg(e.BASE_ENCOUNTER_COST), 2) "Average Base Cost Per Visit by Gender",
       pa.GENDER
from encounters e
inner join patients pa
on e.PATIENT = pa.Id
group by pa.GENDER
order by [Average Base Cost Per Visit by Gender] desc;
/*
Average Base Cost Per Visit by Gender GENDER
------------------------------------- --------------------------------------------------
117.21                                M
115.29                                F
*/

  -- Average Base Cost Per Visit by Race --
select round(avg(e.BASE_ENCOUNTER_COST), 2) "Average Base Cost Per Visit by Race",
       pa.RACE
from encounters e
inner join patients pa
on e.PATIENT = pa.Id
group by pa.RACE
order by [Average Base Cost Per Visit by Race] desc;
/*
Average Base Cost Per Visit by Race RACE
----------------------------------- --------------------------------------------------
123.92                              native
123.69                              hawaiian
121.53                              asian
121.16                              black
120.93                              other
113.81                              white
*/

  -- Average Base Cost Per Visit by Marital Status --
select round(avg(e.BASE_ENCOUNTER_COST), 2) "Avg Base Cost Per Visit by Marital Status",
       p.MARITAL
from encounters e
inner join patients p
on e.PATIENT = p.Id
where p.MARITAL is not null
group by p.MARITAL
order by [Avg Base Cost Per Visit by Marital Status] desc;
/*
Avg Base Cost Per Visit by Marital Status MARITAL
----------------------------------------- --------------------------------------------------
116.44                                    M
114.77                                    S
*/

  -- Average Base Cost Per Visit by City --
select round(avg(e.BASE_ENCOUNTER_COST), 2) "Avg Base Cost Per Visit by City",
       p.CITY
from encounters e
inner join patients p
on e.PATIENT = p.Id
group by p.CITY
order by [Avg Base Cost Per Visit by City] desc;
/*
Avg Base Cost Per Visit by Gender CITY
--------------------------------- --------------------------------------------------
143.78                            Milton
142.58                            Newton
142.58                            Belmont
142.58                            Waltham
142.58                            Watertown
135.68                            Norwell
130.93                            Brookline
130.26                            Cohasset
129.89                            Cambridge
128.01                            Everett
127.74                            Lynnfield
123.8                             Malden
122.83                            Chelsea
121.35                            Hingham
120.08                            Somerville
117.89                            Medford
117.69                            Boston
117.19                            Winthrop
114.32                            Quincy
113.23                            Braintree
110.65                            Winchester
108.43                            Revere
107.96                            Weymouth
106.13                            Stoneham
104.9                             Reading
102.25                            Scituate
100.82                            North Scituate
96.66                             Melrose
90.19                             Hull
*/

  -- Max Total Claim Cost Per Visit --
select round(max(TOTAL_CLAIM_COST), 2) "Maximum Total Claim Cost Per Visit"
from encounters;
/*
Maximum Total Claim Cost Per Visit
----------------------------------
641882.69

-------------------------------------------------------------------
The maximum total claim cost per visit for patients is $641,882.69.
-------------------------------------------------------------------
*/

  -- Min Total Claim Cost Per Visit -- 
select round(min(TOTAL_CLAIM_COST), 2) "Minimum Total Claim Cost Per Visit"
from encounters;
/*
Minimum Total Claim Cost Per Visit
----------------------------------
0

----------------------------------------------------------
The minimum total claim cost per visit for patients is $0.
----------------------------------------------------------
*/

  -- Avg Total Claim Cost Per Visit by Encounter Class -- 
select round(avg(TOTAL_CLAIM_COST), 2) "Average Total Claim Cost Per Visit by Encounter Class",
       ENCOUNTERCLASS
from encounters
group by ENCOUNTERCLASS
order by [Average Total Claim Cost Per Visit by Encounter Class] desc;
/*
Average Total Claim Cost Per Visit by Encounter Class ENCOUNTERCLASS
----------------------------------------------------- --------------------------------------------------
7761.35                                               inpatient
6369.16                                               urgentcare
4629.65                                               emergency
4260.71                                               wellness
2894.11                                               ambulatory
2237.3                                                outpatient
*/

  -- Avg Total Claim Cost Per Visit by Gender --
select round(avg(e.TOTAL_CLAIM_COST), 2) "Avg Total Claim Cost Per Visit by Gender",
       p.GENDER
from encounters e
inner join patients p
on e.PATIENT = p.Id
group by p.GENDER
order by [Avg Total Claim Cost Per Visit by Gender] desc;
/*
Avg Total Claim Cost Per Visit by Gender GENDER
---------------------------------------- --------------------------------------------------
4085.33                                  M
3252.47                                  F
*/

  -- Avg Total Claim Cost Per Visit by Race --
select round(avg(e.TOTAL_CLAIM_COST), 2) "Avg Total Claim Cost Per Visit by Race",
       p.RACE
from encounters e
inner join patients p
on e.PATIENT = p.Id
group by p.RACE
order by [Avg Total Claim Cost Per Visit by Race] desc;
/*
Avg Total Claim Cost Per Visit by Race RACE
-------------------------------------- --------------------------------------------------
7827.5                                 native
5193.19                                black
4151.51                                hawaiian
3600.21                                other
3230.67                                white
2584.95                                asian
*/

  -- Avg Total Claim Cost Per Visit by Marital Status --
select round(avg(e.TOTAL_CLAIM_COST), 2) "Avg Total Claim Cost Per Visit by Marital Status",
       p.MARITAL
from encounters e
inner join patients p
on e.PATIENT = p.Id
where p.MARITAL is not null
group by p.MARITAL
order by [Avg Total Claim Cost Per Visit by Marital Status] desc;
/*
Avg Total Claim Cost Per Visit by Marital Status MARITAL
------------------------------------------------ --------------------------------------------------
3760.56                                          M
2972.97                                          S
*/

  -- Avg Total Claim Cost Per Visit by City --
select round(avg(e.TOTAL_CLAIM_COST), 2) "Avg Base Cost Per Visit by City",
       p.CITY
from encounters e
inner join patients p
on e.PATIENT = p.Id
group by p.CITY
order by [Avg Base Cost Per Visit by City] desc;
/*
Avg Base Cost Per Visit by City CITY
------------------------------- --------------------------------------------------
16409.28                        Melrose
11507.13                        Norwell
7388.09                         Cohasset
6982.4                          Brookline
5604.49                         Somerville
5236.94                         Hingham
5027.43                         Everett
4113.87                         Boston
4029.69                         Newton
3622.94                         Revere
3435.73                         Scituate
3105.75                         Cambridge
3086.29                         Quincy
3052.76                         Braintree
2631.42                         Milton
2554.54                         Chelsea
2142.62                         Hull
1996.73                         Winthrop
1914.16                         North Scituate
1829.94                         Malden
1766.01                         Medford
1670.07                         Weymouth
1410.3                          Reading
1019.25                         Stoneham
600.68                          Winchester
455.6                           Lynnfield
181.44                          Belmont
142.58                          Waltham
142.58                          Watertown
*/

   -- Number of Procedures Covered by Insurace Type --
select distinct count(p.ENCOUNTER) "Number of Procedures Covered by Insurance Type",
                pa.NAME
from encounters e
inner join procedures p
on p.ENCOUNTER = e.Id
inner join payers pa
on e.PAYER = pa.Id
where pa.NAME not like 'NO_INSURANCE'
group by pa.NAME
order by [Number of Procedures Covered by Insurance Type] desc;
/*
Number of Procedures by Insurance Type NAME
-------------------------------------- --------------------------------------------------
19512                                  Medicare
2893                                   Medicaid
1999                                   Humana
1599                                   Cigna Health
1512                                   Blue Cross Blue Shield
1457                                   Aetna
1262                                   UnitedHealthcare
1203                                   Anthem
1162                                   Dual Eligible

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Medicare insurance covers the most procedures under insurance, covering 19,512 procedures. While Medicaid covers the second most proedures under insurance, covering 2,893 procedures.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

   -- Number of Procedures Covered by Insurace Type by Gender --
select distinct count(p.ENCOUNTER) "Number of Procedures Covered by Insurance Type by Gender",
                pa.NAME,
				pat.GENDER
from encounters e
inner join procedures p
on p.ENCOUNTER = e.Id
inner join payers pa
on e.PAYER = pa.Id
inner join patients pat
on e.PATIENT = pat.Id
where pa.NAME not like 'NO_INSURANCE'
group by pa.NAME,
         pat.GENDER
order by [Number of Procedures Covered by Insurance Type by Gender] desc;
/*
Number of Procedures Covered by Insurance Type NAME                                               GENDER
---------------------------------------------- -------------------------------------------------- --------------------------------------------------
11487                                          Medicare                                           M
8025                                           Medicare                                           F
2499                                           Medicaid                                           F
1149                                           Humana                                             F
1034                                           Cigna Health                                       F
1013                                           Blue Cross Blue Shield                             F
857                                            UnitedHealthcare                                   F
850                                            Humana                                             M
836                                            Aetna                                              F
753                                            Anthem                                             F
636                                            Dual Eligible                                      F
621                                            Aetna                                              M
565                                            Cigna Health                                       M
526                                            Dual Eligible                                      M
499                                            Blue Cross Blue Shield                             M
450                                            Anthem                                             M
405                                            UnitedHealthcare                                   M
394                                            Medicaid                                           M
*/

  -- Number of Procedures Covered by Insurance by Country --
select distinct count(p.ENCOUNTER) "Number of Procedures Covered by Insurance by Country",
				pat.Birth_Country
from encounters e
inner join procedures p
on p.ENCOUNTER = e.Id
inner join payers pa
on e.PAYER = pa.Id
inner join patients pat
on e.PATIENT = pat.Id
where pa.NAME not like 'NO_INSURANCE'
group by pat.Birth_Country
order by [Number of Procedures Covered by Insurance by Country] desc;
/*
Number of Procedures Covered by Insurance by Country Birth_Country
---------------------------------------------------- --------------------------------------------------
28786                                                US
708                                                  MX
486                                                  DE
345                                                  HN
297                                                  DM
273                                                  PR
243                                                  VN
232                                                  CN
195                                                  SA
179                                                  CO
109                                                  CL
109                                                  PE
107                                                  GT
94                                                   SV
73                                                   KR
59                                                   JP
55                                                   VE
53                                                   HT
50                                                   PA
45                                                   FR
25                                                   CU
20                                                   AR
16                                                   CR
14                                                   DO
11                                                   JM
9                                                    IT
3                                                    GR
2                                                    IN
1                                                    RU
*/

/* This is the conclusion of my Sql Hospital Patient Records project. In this project I have demonstrated how to import multiple csv files into Sql, how to perform data cleaning in Sql by transforming, manipulating, and extracting values from existing columns
   to store in newly created columns, and how to convert datatypes. I also demonstrated how to utilize a inner join to combine multiple tables to extract the required values. Lastly, I demonstrated how utilize Sql functions to calculate avg, max, and min values 
   from numeric columns, as well as time series columns.
   */