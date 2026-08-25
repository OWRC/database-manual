
--***** G_10_19_05

--***** move the pumptest step data across to the M_D_PUMPTEST_STEP
--***** table with the appropriate random keys

-- there are no null testtypes (D or R only)

-- how many rows are in the YC_20130923_PUMP_STEP table when we group/summarize
-- the data based upon the pumping rate (and units); note that only drawdown
-- records end up in FM_D_PUMPTEST_STEP

-- 2016.05.31 5601
-- 2017.09.05 2784
-- 2018.05.30 3849
-- v20190509 1383 
-- v20200721 2094 
-- v20210119 2830 rows
-- v20220328 504 rows
-- v20230324 302 rows
-- v20240326 415 rows
-- v20250711 483 rows
-- v20260813 40009 rows

SELECT
[PUMP_TEST_ID]
,[PUMP_RATE]
,[PUMP_RATE_UNITS]
,[PUMP_RATE_OUOM]
,[PUMP_RATE_UNITS_OUOM]
,min([PUMP_START]) as [PUMP_START]
,max([PUMP_END]) as [PUMP_END]
FROM MOE_20260813.[dbo].[YC_20260813_PUMP_STEP]
where 
testtype='D'
group by
Pump_Test_id,PUMP_RATE,PUMP_RATE_UNITS,PUMP_RATE_OUOM,PUMP_RATE_UNITS_OUOM 
order by 
Pump_Test_id

-- use this value for creating the random ids (?????)

-- note that we're keeping the test columns and the rnum column
-- to be used when we're adding data to the interval temporal table

--***** UPDATE DATA_ID

select
t1.PUMP_TEST_ID
,t1.PUMP_RATE
,t1.PUMP_RATE_UNITS
,t1.PUMP_RATE_OUOM
,t1.PUMP_RATE_UNITS_OUOM
,t1.PUMP_START
,t1.PUMP_END
,cast(529 as int) as DATA_ID
,t1.SYS_RECORD_ID
from 
(
SELECT
[PUMP_TEST_ID]
,[PUMP_RATE]
,[PUMP_RATE_UNITS]
,[PUMP_RATE_OUOM]
,[PUMP_RATE_UNITS_OUOM]
,min([PUMP_START]) as [PUMP_START]
,max([PUMP_END]) as [PUMP_END]
,ROW_NUMBER() over (order by PUMP_TEST_ID) as SYS_RECORD_ID
FROM MOE_20260813.[dbo].[YC_20260813_PUMP_STEP]
where 
testtype='D'
group by
Pump_Test_id,PUMP_RATE,PUMP_RATE_UNITS,PUMP_RATE_OUOM,PUMP_RATE_UNITS_OUOM 
) as t1


select
t1.PUMP_TEST_ID
,t1.PUMP_RATE
,t1.PUMP_RATE_UNITS
,t1.PUMP_RATE_OUOM
,t1.PUMP_RATE_UNITS_OUOM
,t1.PUMP_START
,t1.PUMP_END
,cast(529 as int) as DATA_ID
,t1.SYS_RECORD_ID
into MOE_20260813.dbo.M_D_PUMPTEST_STEP 
from 
(
SELECT
[PUMP_TEST_ID]
,[PUMP_RATE]
,[PUMP_RATE_UNITS]
,[PUMP_RATE_OUOM]
,[PUMP_RATE_UNITS_OUOM]
,min([PUMP_START]) as [PUMP_START]
,max([PUMP_END]) as [PUMP_END]
,ROW_NUMBER() over (order by PUMP_TEST_ID) as SYS_RECORD_ID
FROM MOE_20260813.[dbo].[YC_20260813_PUMP_STEP]
where 
testtype='D'
group by
Pump_Test_id,PUMP_RATE,PUMP_RATE_UNITS,PUMP_RATE_OUOM,PUMP_RATE_UNITS_OUOM 
) as t1




