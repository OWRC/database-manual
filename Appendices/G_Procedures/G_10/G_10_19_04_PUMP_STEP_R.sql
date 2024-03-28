
--***** G_10_19_04

--***** repeat the pumptest extract for recovery data; these are the same scripts 
--***** as previous files but using R as a filter instead

-- note that we need to add the end of the drawdown test to the time of
-- the recovery test

-- 2018.05.30 3849 rows
-- v20190509 1383 rows
-- v20200721 2094 rows
-- v20210119 2830 rows
-- v20220328 504 rows
-- v20230324 302 rows
-- v20240326 415 rows

select 
ycps.Pump_Test_id
,max(ycps.PUMP_END) as enddate
from 
MOE_20240326.dbo.YC_20240326_PUMP_STEP as ycps
where 
ycps.TestType='D' 
group by
ycps.Pump_Test_id

-- extract the information; note that we're adding it to the d_pump_step table for now;
-- this will not get added to the actual table but is used as a source for d_int_temp_2

--***** UPDATE DATA_ID

-- 2018.05.30 35294 rows
-- v20190509 14816 rows 
-- v20200721 23376 rows
-- v20210119 30423 rows
-- v20220328 5659 rows
-- v20230324 3863 rows
-- v20240326 5254 rows

select
curr.Pump_Test_id
,dateadd(minute,curr.TestDuration,mt.enddate) as [PUMP_END]
,cast(526 as int) as DATA_ID
,null as [SYS_RECORD_ID]
,null as [rnum]
,curr.TestType as [testtype]
,curr.TestLevel as [testlevel]
,curr.TESTLEVEL_UOM as [testlevel_uom]
from
(
	select
	moeptd.Pump_Test_id
	,moeptd.TestDuration
	,moeptd.TestType
	,moeptd.TestLevel
	,moeptd.TESTLEVEL_UOM
	from 
	MOE_20240326.dbo.TblPump_Test_Detail as moeptd
	where 
	moeptd.TestType='R'
) as [curr]
inner join 
(
	select 
	ycps.Pump_Test_id
	,max(ycps.PUMP_END) as enddate
	from 
	MOE_20240326.dbo.YC_20240326_PUMP_STEP as ycps
	where 
	ycps.TestType='D' 
	group by
	ycps.Pump_Test_id
) as mt
on
curr.Pump_Test_id=mt.Pump_Test_id
inner join MOE_20240326.dbo.TblPump_Test as moept
on curr.Pump_Test_id=moept.PUMP_TEST_ID
inner join MOE_20240326.dbo.M_D_PUMPTEST as dpump
on curr.Pump_Test_id=dpump.pump_test_id
inner join MOE_20240326.dbo.TblPipe as moep
on moept.PIPE_ID=moep.PIPE_ID
inner join MOE_20240326.dbo.YC_20240326_BH_ID as ycb
on moep.Bore_Hole_ID=ycb.BORE_HOLE_ID
inner join MOE_20240326.dbo.M_D_LOCATION as dloc
on ycb.BORE_HOLE_ID=dloc.LOC_ID
order by 
curr.Pump_Test_id,PUMP_END

insert into MOE_20240326.dbo.YC_20240326_PUMP_STEP
(
[PUMP_TEST_ID]
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
,dateadd(minute,curr.TestDuration,mt.enddate) as [PUMP_END]
,cast(526 as int) as DATA_ID
,null as [SYS_RECORD_ID]
,null as [rnum]
,curr.TestType as [testtype]
,curr.TestLevel as [testlevel]
,curr.TESTLEVEL_UOM as [testlevel_uom]
from
(
	select
	moeptd.Pump_Test_id
	,moeptd.TestDuration
	,moeptd.TestType
	,moeptd.TestLevel
	,moeptd.TESTLEVEL_UOM
	from 
	MOE_20240326.dbo.TblPump_Test_Detail as moeptd
	where 
	moeptd.TestType='R'
) as [curr]
inner join 
(
	select 
	ycps.Pump_Test_id
	,max(ycps.PUMP_END) as enddate
	from 
	MOE_20240326.dbo.YC_20240326_PUMP_STEP as ycps
	where 
	ycps.TestType='D' 
	group by
	ycps.Pump_Test_id
) as mt
on
curr.Pump_Test_id=mt.Pump_Test_id
inner join MOE_20240326.dbo.TblPump_Test as moept
on curr.Pump_Test_id=moept.PUMP_TEST_ID
inner join MOE_20240326.dbo.M_D_PUMPTEST as dpump
on curr.Pump_Test_id=dpump.pump_test_id
inner join MOE_20240326.dbo.TblPipe as moep
on moept.PIPE_ID=moep.PIPE_ID
inner join MOE_20240326.dbo.YC_20240326_BH_ID as ycb
on moep.Bore_Hole_ID=ycb.BORE_HOLE_ID
inner join MOE_20240326.dbo.M_D_LOCATION as dloc
on ycb.BORE_HOLE_ID=dloc.LOC_ID
order by 
curr.Pump_Test_id,PUMP_END





