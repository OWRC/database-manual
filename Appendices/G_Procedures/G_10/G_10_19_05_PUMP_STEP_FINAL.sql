
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

SELECT
[PUMP_TEST_ID]
,[PUMP_RATE]
,[PUMP_RATE_UNITS]
,[PUMP_RATE_OUOM]
,[PUMP_RATE_UNITS_OUOM]
,min([PUMP_START]) as [PUMP_START]
,max([PUMP_END]) as [PUMP_END]
FROM MOE_20240326.[dbo].[YC_20240326_PUMP_STEP]
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
,cast(526 as int) as DATA_ID
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
FROM MOE_20240326.[dbo].[YC_20240326_PUMP_STEP]
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
,cast(526 as int) as DATA_ID
,t1.SYS_RECORD_ID
into MOE_20240326.dbo.M_D_PUMPTEST_STEP 
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
FROM MOE_20240326.[dbo].[YC_20240326_PUMP_STEP]
where 
testtype='D'
group by
Pump_Test_id,PUMP_RATE,PUMP_RATE_UNITS,PUMP_RATE_OUOM,PUMP_RATE_UNITS_OUOM 
) as t1




--***** as of 20131104, the following are unnecessary as the commands
--***** dealt with having null testtype's; here we're only working
--***** with R and D step tests

-- determine those pump_test_id that carry the same info; these
-- are duplicates of testtype NULL; delete them

--select
--t2.PUMP_TEST_ID
--,t2.SYS_RECORD_ID as [tsri]
--dpsn.SYS_RECORD_ID as [dsri]
--from
--[MOE_201304].dbo.FM_D_PUMPTEST_STEP as dpsn
--inner join
--(
--select
--t1.PUMP_TEST_ID
--,t1.SYS_RECORD_ID
--from
--(
--select
--dpsn.PUMP_TEST_ID
--,COUNT(*) as rcount
--,MIN(dpsn.SYS_RECORD_ID) as SYS_RECORD_ID
--from 
--[MOE_201304].dbo.FM_D_PUMPTEST_STEP as dpsn
--where
--dpsn.testtype is null
--group by
--dpsn.PUMP_TEST_ID
--) as t1
--where 
--t1.rcount>1
--) as t2
--on
--dpsn.PUMP_TEST_ID=t2.PUMP_TEST_ID 
--where 
--dpsn.sys_record_id <> t2.SYS_RECORD_ID
--and dpsn.testtype is null
--order by 
--t2.pump_test_id,tsri

--delete from [MOE_201304].dbo.FM_D_PUMPTEST_STEP_NEW
--where
--sys_record_id 
--in
--(
--select
--dpsn.SYS_RECORD_ID as [dsri]
--from
--[MOE_201304].dbo.FM_D_PUMPTEST_STEP_NEW as dpsn
--inner join
--(
--select
--t1.PUMP_TEST_ID
--,t1.SYS_RECORD_ID
--from
--(
--select
--dpsn.PUMP_TEST_ID
--,COUNT(*) as rcount
--,MIN(dpsn.SYS_RECORD_ID) as SYS_RECORD_ID
--from 
--[MOE_201304].dbo.FM_D_PUMPTEST_STEP_NEW as dpsn
--where
--dpsn.testtype is null
--group by
--dpsn.PUMP_TEST_ID
--) as t1
--where 
--t1.rcount>1
--) as t2
--on
--dpsn.PUMP_TEST_ID=t2.PUMP_TEST_ID 
--where 
--dpsn.sys_record_id <> t2.SYS_RECORD_ID
--and dpsn.testtype is null
--)

-- check which of the null testtype remain

--select
--*
--from 
--[MOE_201304].dbo.FM_D_PUMPTEST_STEP_NEW as dpsn
--where
--testtype is null

-- and which of these match an existing D record; delete them

--select
--dpsn.sys_record_id
----,dpsn.PUMP_TEST_ID
--from 
--[MOE_201304].dbo.FM_D_PUMPTEST_STEP_NEW as dpsn
--inner join 
--(
--select 
--dpsn.sys_record_id
--,dpsn.pump_test_id
--,dpsn.pump_end
--from 
--[MOE_201304].dbo.FM_D_PUMPTEST_STEP_NEW as dpsn
--) as t1
--on
--(dpsn.pump_test_id=t1.pump_test_id and dpsn.pump_end=t1.pump_end)
--where
--testtype is null


--delete from [MOE_201304].dbo.FM_D_PUMPTEST_STEP_NEW
--where
--sys_record_id 
--in
--(
--select
--dpsn.sys_record_id
--from 
--[MOE_201304].dbo.FM_D_PUMPTEST_STEP_NEW as dpsn
--inner join 
--(
--select 
--dpsn.sys_record_id
--,dpsn.pump_test_id
--,dpsn.pump_end
--from 
--[MOE_201304].dbo.FM_D_PUMPTEST_STEP_NEW as dpsn
--) as t1
--on
--(dpsn.pump_test_id=t1.pump_test_id and dpsn.pump_end=t1.pump_end)
--where
--testtype is null
--)

-- check which of the null testtype remain; only invalid dates

--select
--*
--from 
--[MOE_201304].dbo.FM_D_PUMPTEST_STEP_NEW as dpsn
--where
--testtype is null

---- check if any pump_test_id and dates repeat

--select 
-- t1.pump_test_id
--,t1.pump_end
--,t1.sys_record_id as tsri
--,dpsn.sys_record_id as dsri
--from 
--[MOE_201304].dbo.FM_D_PUMPTEST_STEP_NEW as dpsn
--inner join
--(
--select 
--pump_test_id
--,pump_end 
--,sys_record_id 
--from 
--[MOE_201304].dbo.FM_D_PUMPTEST_STEP_NEW
--) as t1
--on
--dpsn.pump_test_id=t1.pump_test_id and dpsn.pump_end=t1.pump_end
--where
--t1.sys_record_id<>dpsn.sys_record_id 

--delete from [MOE_201304].dbo.FM_D_PUMPTEST_STEP_NEW
--where 
--sys_record_id 
--in
--(
--select 
--dpsn.sys_record_id as dsri
--from 
--[MOE_201304].dbo.FM_D_PUMPTEST_STEP_NEW as dpsn
--inner join
--(
--select 
--pump_test_id
--,pump_end 
--,sys_record_id 
--from 
--[MOE_201304].dbo.FM_D_PUMPTEST_STEP_NEW
--) as t1
--on
--dpsn.pump_test_id=t1.pump_test_id and dpsn.pump_end=t1.pump_end
--where
--t1.sys_record_id<>dpsn.sys_record_id 
--)

--select
--*
--from 
--[MOE_201304].dbo.FM_D_PUMPTEST_STEP_NEW
--order by
--pump_test_id,pump_end 