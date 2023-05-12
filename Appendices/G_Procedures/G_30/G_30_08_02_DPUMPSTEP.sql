
--***** G.30.08.02 D_PUMPTEST_STEP 

-- we'll use those BORE_HOLE_IDs/INT_IDs determined in the 
-- previous step to evaluate what records need to be
-- added for this (and related) table

-- create the source table we'll use; index this table

-- V20210119 DATA_ID 523
-- v20220328 DATA_ID 524 
-- v20230324 DATA_ID 525 

-- update the DATA_ID, 

-- v20200721 9382 rows
-- v20210119 141 rows
-- v20220328 786 rows
-- v20230324 5632

select
curr.Pump_Test_id as moe_pump_test_id
,cast(moept.Pumping_rate as float) as PUMP_RATE
,cast(moept.RATE_UOM as varchar(50)) as PUMP_RATE_UNITS
,cast(moept.Pumping_rate as float) as PUMP_RATE_OUOM
,cast(moept.RATE_UOM as varchar(50)) as PUMP_RATE_UNITS_OUOM
,dateadd(minute,curr.TestDuration,dpump.PUMPTEST_DATE) as [PUMP_START]
,dateadd(minute,prev.TestDuration,dpump.PUMPTEST_DATE) as [PUMP_END]
,cast(525 as int) as DATA_ID
,null as [SYS_RECORD_ID]
,null as [rkey]
,prev.TestType as [testtype]
,prev.TestLevel as [testlevel]
,prev.TESTLEVEL_UOM as [testlevel_uom]
into MOE_20230324.dbo.ORMGP_20230324_upd_DPUMPSTEP
from
(
	select
	moeptd.Pump_Test_id
	,moeptd.TestDuration
	,ROW_NUMBER() over (order by moeptd.Pump_Test_id,moeptd.TestDuration) as rnum
	from 
	MOE_20230324.dbo.TblPump_Test_Detail as moeptd
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
	MOE_20230324.dbo.TblPump_Test_Detail as moeptd
	where 
	moeptd.TestType='D'
) as [prev]
on curr.Pump_Test_id=prev.Pump_Test_id and curr.rnum=(prev.rnum-1)
inner join MOE_20230324.dbo.TblPump_Test as moept
on curr.Pump_Test_id=moept.PUMP_TEST_ID
inner join moe_20230324.dbo.o_d_pumptest as dpump
on curr.pump_test_id=dpump.moe_pump_test_id
order by 
curr.Pump_Test_id,PUMP_START

select count(*) as rcount from MOE_20230324.dbo.ORMGP_20230324_upd_DPUMPSTEP

--drop table ORMGP_20230324_upd_DPUMPSTEP
 
-- now add the first step - the previous code create all the other steps

-- v20200721 885 rows
-- v20210119 12 rows
-- v20220328 875 rows (total of R and D)
-- v20230324 6134

insert into MOE_20230324.dbo.ORMGP_20230324_upd_DPUMPSTEP
(
moe_pump_test_id
,[PUMP_RATE]
,[PUMP_RATE_UNITS]
,[PUMP_RATE_OUOM]
,[PUMP_RATE_UNITS_OUOM]
,[PUMP_START]
,[PUMP_END]
,[DATA_ID]
,[SYS_RECORD_ID]
,[rkey]
,[testtype]
,[testlevel]
,[testlevel_uom]
)
select
curr.Pump_Test_id as moe_pump_test_id
,cast(moept.Pumping_rate as float) as PUMP_RATE
,cast(moept.RATE_UOM as varchar(50)) as PUMP_RATE_UNITS
,cast(moept.Pumping_rate as float) as PUMP_RATE_OUOM
,cast(moept.RATE_UOM as varchar(50)) as PUMP_RATE_UNITS_OUOM
,dateadd(minute,0,dpump.PUMPTEST_DATE) as [PUMP_START]
,dateadd(minute,curr.TestDuration,dpump.PUMPTEST_DATE) as [PUMP_END]
,cast(525 as int) as DATA_ID
,cast(null as int) as [SYS_RECORD_ID]
,cast(null as int) as [rkey]
,moeptd.TestType as [testtype]
,moeptd.TestLevel as [testlevel]
,moeptd.TESTLEVEL_UOM as [testlevel_uom]
from
(
    select 
    moeptd.Pump_Test_id
    ,min(moeptd.TestDuration) as TestDuration
    from 
	MOE_20230324.dbo.TblPump_Test_Detail as moeptd
	where 
	moeptd.TestType='D' 
	group by
	moeptd.Pump_Test_id
) as curr
inner join MOE_20230324.dbo.TblPump_Test as moept
on curr.Pump_Test_id=moept.PUMP_TEST_ID
inner join MOE_20230324.dbo.TblPump_Test_Detail as moeptd
on curr.Pump_Test_id=moeptd.Pump_Test_id and curr.TestDuration=moeptd.TestDuration
inner join moe_20230324.dbo.o_d_pumptest as dpump
on curr.pump_test_id=dpump.moe_pump_test_id
where
moeptd.TestType='D'
order by 
curr.Pump_Test_id,PUMP_START

select count(*) as rcount from MOE_20230324.dbo.ORMGP_20230324_upd_DPUMPSTEP

-- we can now look at the recovery information

-- v20190509 14372 rows
-- v20200721 0 rows
-- v20210119 0 rows
-- v20220328 0 rows
-- v20230324 0 rows

--insert into moe_20230324.dbo.ormgp_20230324_upd_dpumpstep
--(
--moe_pump_test_id
--,pump_end
--,data_id
--,sys_record_id
--,rkey
--,testtype
--,testlevel
--,testlevel_uom
--)
select
curr.Pump_Test_id as moe_pump_test_id
,dateadd(minute,curr.TestDuration,mt.enddate) as [PUMP_END]
,cast(525 as int) as DATA_ID
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
	MOE_20230324.dbo.TblPump_Test_Detail as moeptd
	where 
	moeptd.TestType='R'
) as [curr]
inner join 
(
	select 
	ycps.moe_Pump_Test_id
	,max(ycps.PUMP_END) as enddate
	from 
	MOE_20230324.dbo.ORMGP_20230324_upd_dpumpstep as ycps
	where 
	ycps.TestType='D' 
	group by
	ycps.moe_Pump_Test_id
) as mt
on curr.Pump_Test_id=mt.moe_Pump_Test_id
inner join MOE_20230324.dbo.TblPump_Test as moept
on curr.Pump_Test_id=moept.PUMP_TEST_ID
inner join MOE_20230324.dbo.o_D_PUMPTEST as dpump
on curr.Pump_Test_id=dpump.pump_test_id
order by 
curr.Pump_Test_id,PUMP_END

-- create the D_PUMPTEST_STEP table; this will be based upon a
-- grouping of pumping rate and units; note that only the 
-- drawdown information is being examined

-- v20190509 1449 rows
-- v20200721 879 rows
-- v20210119 12 rows
-- v20220328 83 rows
-- v20230324 502

select
cast( null as int ) as PUMP_TEST_ID
,t1.moe_PUMP_TEST_ID
,t1.PUMP_RATE
,t1.PUMP_RATE_UNITS
,t1.PUMP_RATE_OUOM
,t1.PUMP_RATE_UNITS_OUOM
,t1.PUMP_START
,t1.PUMP_END
,cast(525 as int) as DATA_ID
,t1.SYS_RECORD_ID
,t1.rkey
into MOE_20230324.dbo.O_D_PUMPTEST_STEP 
from 
(
SELECT
[moe_PUMP_TEST_ID]
,[PUMP_RATE]
,[PUMP_RATE_UNITS]
,[PUMP_RATE_OUOM]
,[PUMP_RATE_UNITS_OUOM]
,min([PUMP_START]) as [PUMP_START]
,max([PUMP_END]) as [PUMP_END]
,cast( null as int ) as SYS_RECORD_ID
,ROW_NUMBER() over (order by moe_PUMP_TEST_ID) as rkey
FROM MOE_20230324.[dbo].ormgp_20230324_upd_dpumpstep
where 
testtype='D'
group by
moe_Pump_Test_id,PUMP_RATE,PUMP_RATE_UNITS,PUMP_RATE_OUOM,PUMP_RATE_UNITS_OUOM 
) as t1

select count(*) as rcount from MOE_20230324.dbo.O_D_PUMPTEST_STEP 

-- create the compatible D_INTERVAL_TEMPORAL_2 table populated with
-- the drawdown and recovery data

-- add an indexed ID field to MOE_20230324.[dbo].ORMGP_20230324_upd_DPUMPSTEP

-- v20190509 31155 rows
-- v20200721 
-- v20210119 153 rows
-- v20220328 1033 rows
-- v20230324 6134

select
dp.INT_ID
,case 
when dps.testtype='D' then cast(65 as int) -- i.e. moe pumping level
else cast(64 as int) -- i.e. moe recovery level
end as [RD_TYPE_CODE]
,cast(70899 as int) as [RD_NAME_CODE]  -- i.e. Water Level - Manual - Other
,dps.PUMP_END as [RD_DATE]
,case
when dps.testlevel_uom='m' then dbore.bh_gnd_elev - dps.testlevel
else dbore.bh_gnd_elev - (dps.testlevel*0.3048)
end as [RD_VALUE]
,cast(6 as int) as [UNIT_CODE]
,cast('Water Level - Manual - Other' as varchar(100)) as RD_NAME_OUOM
,cast(dps.testlevel as float) as RD_VALUE_OUOM
,cast(dps.testlevel_uom as varchar(50)) as RD_UNIT_OUOM
,cast(1 as int) as REC_STATUS_CODE
,cast(
case 
when dps.testtype='D' then 'Pumping - Drawdown'
else 'Pumping - Recovery'
end as varchar(255) ) as [RD_COMMENT]
,dps.DATA_ID as [DATA_ID]
,dps.SYS_RECORD_ID
,dps.rkey 
into moe_20230324.dbo.O_D_INTERVAL_TEMPORAL_2_70899
from 
MOE_20230324.[dbo].ORMGP_20230324_upd_DPUMPSTEP as dps
inner join MOE_20230324.dbo.O_D_PUMPTEST as dp
on dps.moe_PUMP_TEST_ID=dp.moe_PUMP_TEST_ID
inner join oak_20160831_master.dbo.d_interval as dint
on dp.int_id=dint.int_id
inner join oak_20160831_master.dbo.d_borehole as dbore
on dint.loc_id=dbore.loc_id
where
dps.testtype is not null
and dbore.bh_gnd_elev is not null
order by
dp.INT_ID,RD_DATE

drop table moe_20230324.dbo.O_D_INTERVAL_TEMPORAL_2_70899

select
count(*)
from 
moe_20230324.dbo.o_d_interval_temporal_2_70899

-- update the SYS_RECORD_ID field

-- update the count to include the number of rows

-- note that for version v20220328 and v20230324, rkey was not populated; updated by hand;
-- modify this in the future

-- v20200721 10309 rows
-- v20210119 153 rows
-- v20220328 1033 rows
-- v20230324 6134

update moe_20230324.dbo.o_d_interval_temporal_2_70899
set
sys_record_id= t2.sri
from 
moe_20230324.dbo.o_d_interval_temporal_2_70899 as d
inner join
(
select
t.sri
,row_number() over (order by t.sri) as rkey
from 
(
select
top 10000
v.new_id as sri
from 
oak_20160831_master.dbo.v_sys_random_id_bulk_001 as v
where 
v.new_id not in
( select sys_record_id from oak_20160831_master.dbo.d_interval_temporal_2 ) 
) as t
) as t2
on d.rkey=t2.rkey

-- insert the records into D_INTERVAL_TEMPORAL_2

-- update SYS_TEMP1, SYS_TEMP2

-- note that duplicate rkey's can occur (based upon the grouping of fields, before); the following
-- will return an error in those cases - recalculate the sys_record_ids using a new id field

insert into oak_20160831_master.dbo.d_interval_temporal_2
(
[INT_ID], 
[RD_TYPE_CODE], 
[RD_NAME_CODE], 
[RD_DATE], 
[RD_VALUE], 
[UNIT_CODE], 
[RD_NAME_OUOM], 
[RD_VALUE_OUOM], 
[RD_UNIT_OUOM], 
[REC_STATUS_CODE], 
[RD_COMMENT], 
[DATA_ID], 
[SYS_RECORD_ID],
SYS_TEMP1,
SYS_TEMP2
)
select
[INT_ID], 
[RD_TYPE_CODE], 
[RD_NAME_CODE], 
[RD_DATE], 
[RD_VALUE], 
[UNIT_CODE], 
[RD_NAME_OUOM], 
[RD_VALUE_OUOM], 
[RD_UNIT_OUOM], 
[REC_STATUS_CODE], 
[RD_COMMENT], 
[DATA_ID], 
[SYS_RECORD_ID],
cast( '20230512f' as varchar(255) ) as SYS_TEMP1,
cast( 20230512 as int ) as SYS_TEMP2
from 
moe_20230324.dbo.o_d_interval_temporal_2_70899 



















