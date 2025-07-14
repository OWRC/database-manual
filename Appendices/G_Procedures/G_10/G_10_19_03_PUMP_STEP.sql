
--***** G_10_19_03

--***** determine those pump_test_id which exist in TblPump_Test_Detail which are
--***** to be incorporated into FM_D_PUMPTEST_STEP

-- this creates the intervals for each pump_test_id with the exception of the 
-- first (usually, for example, 0 to 1); another script should create that one

-- for any NULL dates in D_PUMPTEST, we'll assign a placeholder date; this is a tag
-- for a date that is not possible or likely within the database and will only apply
-- to the pumptest and it's data (as found in D_PUMPTEST, D_PUMPTEST_STEP and
-- D_INTERVAL_TEMPORAL_2); this date will be 1867-07-01; a test to extract these
-- particular records would be <1868-01-01

-- 2017.09.05 0 rows
-- 2018.05.30 0 rows
-- v20190509 0 rows 
-- v20200721 0 rows
-- v20210119 0 rows
-- v20220328 0 rows
-- v20230324 0 rows
-- v20240326 0 rows
-- v20250711 0 rows

select
*
from
MOE_20250711.dbo.M_D_PUMPTEST
where
PUMPTEST_DATE is null

-- no records returned; these were corrected in an earlier step

--update [MOE_201304].dbo.FM_D_PUMPTEST
--set
--PUMPTEST_DATE='1867-07-01'
--where
--PUMPTEST_DATE is null

--select
--*
--from 
--[MOE_201304].dbo.FM_D_PUMPTEST
--where
--PUMPTEST_DATE < '1868-01-01'

-- store the testtype, testlevel and testlevel_uom here as well for easier access, later

--***** UPDATE DATA_ID

-- 2018.05.30 38272 rows
-- v20190509 15222 rows 
-- v20200721 23498 rows
-- v20210119 31194 rows
-- v20220328 5789 rows
-- v20230324 3614 rows
-- v20240326 4915 rows
-- v20250711 5712 rows

select
curr.Pump_Test_id
,cast(moept.Pumping_rate as float) as PUMP_RATE
,cast(moept.RATE_UOM as varchar(50)) as PUMP_RATE_UNITS
,cast(moept.Pumping_rate as float) as PUMP_RATE_OUOM
,cast(moept.RATE_UOM as varchar(50)) as PUMP_RATE_UNITS_OUOM
,dateadd(minute,curr.TestDuration,dpump.PUMPTEST_DATE) as [PUMP_START]
,dateadd(minute,prev.TestDuration,dpump.PUMPTEST_DATE) as [PUMP_END]
,cast(528 as int) as DATA_ID
,null as [SYS_RECORD_ID]
,null as [rnum]
,prev.TestType as [testtype]
,prev.TestLevel as [testlevel]
,prev.TESTLEVEL_UOM as [testlevel_uom]
from
(
	select
	moeptd.Pump_Test_id
	,moeptd.TestDuration
	,ROW_NUMBER() over (order by moeptd.Pump_Test_id,moeptd.TestDuration) as rnum
	from 
	MOE_20250711.dbo.TblPump_Test_Detail as moeptd
	where 
	moeptd.TestType='D'
) as [curr]
inner join 
(
	select
	moeptd.Pump_Test_id
	,moeptd.TestDuration
	,moeptd.TestLevel
	,moeptd.TestType
	,moeptd.TESTLEVEL_UOM
	,ROW_NUMBER() over (order by moeptd.Pump_Test_id,moeptd.TestDuration) as rnum
	from 
	MOE_20250711.dbo.TblPump_Test_Detail as moeptd
	where 
	moeptd.TestType='D'
) as [prev]
on
curr.Pump_Test_id=prev.Pump_Test_id and curr.rnum=(prev.rnum-1)
inner join MOE_20250711.dbo.TblPump_Test as moept
on curr.Pump_Test_id=moept.PUMP_TEST_ID
inner join MOE_20250711.dbo.M_D_PUMPTEST as dpump
on curr.Pump_Test_id=dpump.pump_test_id
inner join MOE_20250711.dbo.TblPipe as moep
on moept.PIPE_ID=moep.PIPE_ID
inner join MOE_20250711.dbo.YC_20250711_BH_ID as ycb
on moep.Bore_Hole_ID=ycb.BORE_HOLE_ID
inner join MOE_20250711.dbo.M_D_LOCATION as dloc
on ycb.BORE_HOLE_ID=dloc.LOC_ID
order by 
curr.Pump_Test_id,PUMP_START


select
curr.Pump_Test_id
,cast(moept.Pumping_rate as float) as PUMP_RATE
,cast(moept.RATE_UOM as varchar(50)) as PUMP_RATE_UNITS
,cast(moept.Pumping_rate as float) as PUMP_RATE_OUOM
,cast(moept.RATE_UOM as varchar(50)) as PUMP_RATE_UNITS_OUOM
,dateadd(minute,curr.TestDuration,dpump.PUMPTEST_DATE) as [PUMP_START]
,dateadd(minute,prev.TestDuration,dpump.PUMPTEST_DATE) as [PUMP_END]
,cast(528 as int) as DATA_ID
,null as [SYS_RECORD_ID]
,null as [rnum]
,prev.TestType as [testtype]
,prev.TestLevel as [testlevel]
,prev.TESTLEVEL_UOM as [testlevel_uom]
into MOE_20250711.dbo.YC_20250711_PUMP_STEP
from
(
	select
	moeptd.Pump_Test_id
	,moeptd.TestDuration
	,ROW_NUMBER() over (order by moeptd.Pump_Test_id,moeptd.TestDuration) as rnum
	from 
	MOE_20250711.dbo.TblPump_Test_Detail as moeptd
	where 
	moeptd.TestType='D'
) as [curr]
inner join 
(
	select
	moeptd.Pump_Test_id
	,moeptd.TestDuration
	,moeptd.TestLevel
	,moeptd.TestType
	,moeptd.TESTLEVEL_UOM
	,ROW_NUMBER() over (order by moeptd.Pump_Test_id,moeptd.TestDuration) as rnum
	from 
	MOE_20250711.dbo.TblPump_Test_Detail as moeptd
	where 
	moeptd.TestType='D'
) as [prev]
on
curr.Pump_Test_id=prev.Pump_Test_id and curr.rnum=(prev.rnum-1)
inner join MOE_20250711.dbo.TblPump_Test as moept
on curr.Pump_Test_id=moept.PUMP_TEST_ID
inner join MOE_20250711.dbo.M_D_PUMPTEST as dpump
on curr.Pump_Test_id=dpump.pump_test_id
inner join MOE_20250711.dbo.TblPipe as moep
on moept.PIPE_ID=moep.PIPE_ID
inner join MOE_20250711.dbo.YC_20250711_BH_ID as ycb
on moep.Bore_Hole_ID=ycb.BORE_HOLE_ID
inner join MOE_20250711.dbo.M_D_LOCATION as dloc
on ycb.BORE_HOLE_ID=dloc.LOC_ID
order by 
curr.Pump_Test_id,PUMP_START


--drop table YC_20250711_PUMP_STEP

-- create the first step

--***** UPDATE DATA_ID

-- 2018.05.30 3849 rows
-- v20190509 1383 rows 
-- v20200721 2094 rows
-- v20210119 2830 rows
-- v20220328 504 rows
-- v20230324 302 rows
-- v20240326 415 rows
-- v20250711 483 rows

select
curr.Pump_Test_id
,cast(moept.Pumping_rate as float) as PUMP_RATE
,cast(moept.RATE_UOM as varchar(50)) as PUMP_RATE_UNITS
,cast(moept.Pumping_rate as float) as PUMP_RATE_OUOM
,cast(moept.RATE_UOM as varchar(50)) as PUMP_RATE_UNITS_OUOM
,dateadd(minute,0,dpump.PUMPTEST_DATE) as [PUMP_START]
,dateadd(minute,curr.TestDuration,dpump.PUMPTEST_DATE) as [PUMP_END]
,cast(528 as int) as DATA_ID
,cast(null as int) as [SYS_RECORD_ID]
,cast(null as int) as [rnum]
,moeptd.TestType as [testtype]
,moeptd.TestLevel as [testlevel]
,moeptd.TESTLEVEL_UOM as [testlevel_uom]
from
(
    select 
    moeptd.Pump_Test_id
    ,min(moeptd.TestDuration) as TestDuration
    from 
	MOE_20250711.dbo.TblPump_Test_Detail as moeptd
	where 
	moeptd.TestType='D' 
	group by
	moeptd.Pump_Test_id
) as curr
inner join MOE_20250711.dbo.TblPump_Test as moept
on curr.Pump_Test_id=moept.PUMP_TEST_ID
inner join MOE_20250711.dbo.TblPump_Test_Detail as moeptd
on curr.Pump_Test_id=moeptd.Pump_Test_id and curr.TestDuration=moeptd.TestDuration
inner join MOE_20250711.dbo.M_D_PUMPTEST as dpump
on curr.Pump_Test_id=dpump.pump_test_id
inner join MOE_20250711.dbo.TblPipe as moep
on moept.PIPE_ID=moep.PIPE_ID
inner join MOE_20250711.dbo.YC_20250711_BH_ID as ycb
on moep.Bore_Hole_ID=ycb.BORE_HOLE_ID
inner join MOE_20250711.dbo.M_D_LOCATION as dloc
on ycb.BORE_HOLE_ID=dloc.LOC_ID
where
moeptd.TestType='D'
order by 
curr.Pump_Test_id,PUMP_START


insert into MOE_20250711.dbo.YC_20250711_PUMP_STEP
(
[PUMP_TEST_ID]
,[PUMP_RATE]
,[PUMP_RATE_UNITS]
,[PUMP_RATE_OUOM]
,[PUMP_RATE_UNITS_OUOM]
,[PUMP_START]
,[PUMP_END]
,[DATA_ID]
,[SYS_RECORD_ID]
,[rnum]
,[testtype]
,[testlevel]
,[testlevel_uom]
)
select
curr.Pump_Test_id
,cast(moept.Pumping_rate as float) as PUMP_RATE
,cast(moept.RATE_UOM as varchar(50)) as PUMP_RATE_UNITS
,cast(moept.Pumping_rate as float) as PUMP_RATE_OUOM
,cast(moept.RATE_UOM as varchar(50)) as PUMP_RATE_UNITS_OUOM
,dateadd(minute,0,dpump.PUMPTEST_DATE) as [PUMP_START]
,dateadd(minute,curr.TestDuration,dpump.PUMPTEST_DATE) as [PUMP_END]
,cast(528 as int) as DATA_ID
,cast(null as int) as [SYS_RECORD_ID]
,cast(null as int) as [rnum]
,moeptd.TestType as [testtype]
,moeptd.TestLevel as [testlevel]
,moeptd.TESTLEVEL_UOM as [testlevel_uom]
from
(
    select 
    moeptd.Pump_Test_id
    ,min(moeptd.TestDuration) as TestDuration
    from 
	MOE_20250711.dbo.TblPump_Test_Detail as moeptd
	where 
	moeptd.TestType='D' 
	group by
	moeptd.Pump_Test_id
) as curr
inner join MOE_20250711.dbo.TblPump_Test as moept
on curr.Pump_Test_id=moept.PUMP_TEST_ID
inner join MOE_20250711.dbo.TblPump_Test_Detail as moeptd
on curr.Pump_Test_id=moeptd.Pump_Test_id and curr.TestDuration=moeptd.TestDuration
inner join MOE_20250711.dbo.M_D_PUMPTEST as dpump
on curr.Pump_Test_id=dpump.pump_test_id
inner join MOE_20250711.dbo.TblPipe as moep
on moept.PIPE_ID=moep.PIPE_ID
inner join MOE_20250711.dbo.YC_20250711_BH_ID as ycb
on moep.Bore_Hole_ID=ycb.BORE_HOLE_ID
inner join MOE_20250711.dbo.M_D_LOCATION as dloc
on ycb.BORE_HOLE_ID=dloc.LOC_ID
where
moeptd.TestType='D'
order by 
curr.Pump_Test_id,PUMP_START


--insert into [MOE_20160531].dbo.YC_20160531_PUMP_STEP
--(
--[PUMP_TEST_ID]
--,[PUMP_RATE]
--,[PUMP_RATE_UNITS]
--,[PUMP_RATE_OUOM]
--,[PUMP_RATE_UNITS_OUOM]
--,[PUMP_START]
--,[PUMP_END]
--,[DATA_ID]
--,[SYS_RECORD_ID]
--,[rnum]
--,[testtype]
--,[testlevel]
--,[testlevel_uom]
--)
--select
--curr.Pump_Test_id
--,cast(moept.Pumping_rate as float) as PUMP_RATE
--,cast(moept.RATE_UOM as varchar(50)) as PUMP_RATE_UNITS
--,cast(moept.Pumping_rate as float) as PUMP_RATE_OUOM
--,cast(moept.RATE_UOM as varchar(50)) as PUMP_RATE_UNITS_OUOM
--,dateadd(minute,0,dpump.PUMPTEST_DATE) as [PUMP_START]
--,dateadd(minute,curr.TestDuration,dpump.PUMPTEST_DATE) as [PUMP_END]
--,cast(518 as int) as DATA_ID
--,cast(null as int) as [SYS_RECORD_ID]
--,cast(null as int) as [rnum]
--,moeptd.TestType as [testtype]
--,moeptd.TestLevel as [testlevel]
--,moeptd.TESTLEVEL_UOM as [testlevel_uom]
--from
--(
--    select 
--    moeptd.Pump_Test_id
--    ,min(moeptd.TestDuration) as TestDuration
--    from 
--	[MOE_20160531].dbo.TblPump_Test_Detail as moeptd
--	where 
--	moeptd.TestType='D' 
--	group by
--	moeptd.Pump_Test_id
--) as curr
--inner join [MOE_20160531].dbo.TblPump_Test as moept
--on curr.Pump_Test_id=moept.PUMP_TEST_ID
--inner join [MOE_20160531].dbo.TblPump_Test_Detail as moeptd
--on curr.Pump_Test_id=moeptd.Pump_Test_id and curr.TestDuration=moeptd.TestDuration
--inner join [MOE_20160531].dbo.M_D_PUMPTEST as dpump
--on curr.Pump_Test_id=dpump.pump_test_id
--inner join [MOE_20160531].dbo.TblPipe as moep
--on moept.PIPE_ID=moep.PIPE_ID
--inner join [MOE_20160531].dbo.YC_20160531_BH_ID as ycb
--on moep.Bore_Hole_ID=ycb.BORE_HOLE_ID
--inner join [MOE_20160531].dbo.M_D_LOCATION as dloc
--on ycb.LOC_ID=dloc.LOC_ID
--where
--moeptd.TestType='D'
--order by 
--curr.Pump_Test_id,PUMP_START

