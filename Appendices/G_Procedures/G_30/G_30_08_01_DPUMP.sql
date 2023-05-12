
--***** G.30.08.01 D_PUMPTEST BORE_HOLE_IDs and INT_IDs

-- determine those intervals that do not have a static water
-- level in DIT2

-- note that we're using the complete list of boreholes related
-- to the MOEDB that are currently present in the ORMDB

-- we'll need to update the tags in DIM for any flowing wells that 
-- are tagged in the MOEDB

-- update DATA_ID and SYS_TEMP

-- v20190509 3178 rows
-- v20200721 27 rows
-- v20210119 66 rows
-- v20220328 0 rows
-- v20230324 

update oak_20160831_master.dbo.d_interval_monitor
set
mon_flowing= 1
,data_id= case
when dim.data_id is null then 525
else dim.data_id
end
,mon_comment= case
when dim.data_id is null then 'MON_FLOWING update from DATA_ID 525'
else dim.mon_comment + '; MON_FLOWING update from DATA_ID 525'
end
,sys_temp1= cast( '20230512c' as varchar(255) )
,sys_temp2= cast( 20230512 as int )
from 
oak_20160831_master.dbo.d_interval_monitor as dim
inner join oak_20160831_master.dbo.d_interval as dint
on dim.int_id=dint.int_id
inner join oak_20160831_master.dbo.v_sys_moe_locations as v
on dint.loc_id=v.loc_id
inner join oak_20160831_master.dbo.v_sys_agency_ypdt as y
on v.loc_id=y.loc_id
inner join moe_20230324.dbo.tblpipe as moetp
on v.moe_bore_hole_id=moetp.bore_hole_id
inner join moe_20230324.dbo.tblpump_test as moept
on moetp.pipe_id=moept.pipe_id
where 
moept.FLOWING like 'Y'
and dim.mon_flowing is null
and dint.int_type_code in 
( select int_type_code from oak_20160831_master.dbo.v_sys_int_type_code_screen )

-- assemble the BORE_HOLE_IDs for which we'll assemble pumping data;
-- add indexes to the resulting table

-- v20190509 1667 rows
-- v20200721 1013 rows
-- v20210119 15 rows
-- v20220328 107 rows
-- v20230324 539

select
dint.int_id
,v.moe_well_id
,v.moe_bore_hole_id
,moept.pipe_id
into moe_20230324.dbo.ORMGP_20230324_upd_DPUMP
from 
oak_20160831_master.dbo.v_sys_moe_locations as v
inner join oak_20160831_master.dbo.v_sys_agency_ypdt as y
on v.loc_id=y.loc_id
inner join oak_20160831_master.dbo.d_interval as dint
on v.loc_id=dint.loc_id
left outer join
(
select
int_id
from 
oak_20160831_master.dbo.d_pumptest
group by
int_id
) as d
on dint.int_id=d.int_id
inner join moe_20230324.dbo.tblpipe as moetp
on v.moe_bore_hole_id=moetp.bore_hole_id
inner join moe_20230324.dbo.tblpump_test as moept
on moetp.pipe_id=moept.pipe_id
where 
d.int_id is null
-- there are non-screen intervals, make sure not to include them
and dint.int_type_code in ( select int_type_code from oak_20160831_master.dbo.v_sys_int_type_code_screen )
and (
moept.Recom_depth is not null 
or moept.Recom_rate is not null 
or moept.Flowing_rate is not null 
or moept.PUMP_TEST_ID in 
(select PUMP_TEST_ID from moe_20230324.dbo.tblpump_test_detail)
)
-- only include the following if we can't index the fields
--group by
--dint.int_id,v.moe_bore_hole_id

select
count(*)
from 
moe_20230324.dbo.ORMGP_20230324_upd_DPUMP

-- assemple the D_PUMPTEST compatible table;
-- we're assuming all rates of GPM are IGPM; there are 4.55 litres per imperial gallon
-- change DATA_ID

-- update DATA_ID and SYS_TEMP

-- v20190509 1667 rows
-- v20200721 1013 rows
-- v20210119 15 rows
-- v20220328 107 rows
-- v20230324 539

select 
d.INT_ID
,cast( null as int ) as PUMP_TEST_ID
,moept.pump_test_id as moe_pump_test_id
,case
when dint.int_start_date is not null then dint.int_start_date
else cast( '1867-07-01' as datetime ) 
end as PUMPTEST_DATE
,cast(d.moe_well_id as varchar(20)) as PUMPTEST_NAME
,cast(
case 
when moept.LEVELS_UOM='ft' then moept.Recom_depth*0.3048
else moept.Recom_depth
end as float) as [REC_PUMP_DEPTH_METERS]
,cast(
case 
when moept.RATE_UOM='LPM' then moept.Recom_rate/4.55
else moept.Recom_rate
end as float) as [REC_PUMP_RATE_IGPM]
,cast(
case 
when moept.RATE_UOM='LPM' then moept.Flowing_rate/4.55
else moept.Flowing_rate
end as float) as [FLOWING_RATE_IGPM]
,cast(525 as int) as [DATA_ID]
,cast(
case 
when moept.PUMPING_TEST_METHOD is null then null 
when moept.PUMPING_TEST_METHOD=0       then null
when moept.PUMPING_TEST_METHOD=1       then 1
when moept.PUMPING_TEST_METHOD=2       then 2
when moept.PUMPING_TEST_METHOD=3       then 4
when moept.PUMPING_TEST_METHOD=4       then 8
when moept.PUMPING_TEST_METHOD=5       then 9
else 10
end as int) as [PUMPTEST_METHOD_CODE]
,cast(1 as int) as [PUMPTEST_TYPE_CODE]  -- this is a constant rate indicator
,cast(
case
when moept.WATER_STATE_AFTER_TEST is null then 0
else moept.WATER_STATE_AFTER_TEST
end as int) as [WATER_CLARITY_CODE]
,ROW_NUMBER() over (order by dint.INT_ID) as rkey
into moe_20230324.dbo.O_D_PUMPTEST
from 
moe_20230324.dbo.TblPump_Test as moept
inner join moe_20230324.dbo.ormgp_20230324_upd_dpump as d
on moept.pipe_id=d.pipe_id
inner join oak_20160831_master.dbo.d_interval as dint
on d.int_id=dint.int_id

select count(*) as rcount from moe_20230324.dbo.O_D_PUMPTEST

-- null FLOWING_RATE_IGPM when no MON_FLOWING and REC_PUMP_RATE_IGPM=FLOWING_RATE_IGPM

-- v20190609 6 rows
-- v20200721 3 rows
-- v20210119 0 rows
-- v20220328 0 rows
-- v20230324 0 rows

select
d.moe_pump_test_id
from 
moe_20230324.dbo.o_d_pumptest as d
where
d.INT_ID
not in
(
select
dim.INT_ID
from 
oak_20160831_master.dbo.d_interval_monitor as dim
where
dim.MON_FLOWING is not null 
)
and d.REC_PUMP_RATE_IGPM=d.FLOWING_RATE_IGPM

update moe_20200721.dbo.o_d_pumptest
set
flowing_rate_igpm=null
from 
moe_20200721.dbo.o_d_pumptest as d
where
d.INT_ID
not in
(
select
dim.INT_ID
from 
oak_20160831_master.dbo.d_interval_monitor as dim
where
dim.MON_FLOWING is not null 
)
and d.REC_PUMP_RATE_IGPM=d.FLOWING_RATE_IGPM

-- no REC_PUMP_RATE_IGPM but FLOWING_RATE_IGPM; tag MON_FLOWING

-- v20190509 21 rows
-- v20200721 2 rows
-- v20210119 3 rows
-- v20220328 0 rows
-- v20230324 2 rows

select
dim.MON_ID
from 
oak_20160831_master.dbo.d_interval_monitor as dim
where
dim.INT_ID
in
(
select 
d.INT_ID 
from 
moe_20230324.dbo.o_d_pumptest as d
where
d.INT_ID
in 
(
select
d2.INT_ID
from 
oak_20160831_master.dbo.d_interval_monitor as d2
where
d2.MON_FLOWING is null 
)
and d.REC_PUMP_RATE_IGPM is null 
and d.FLOWING_RATE_IGPM is not null 
)

update oak_20160831_master.dbo.d_interval_monitor
set 
mon_flowing=1
from 
oak_20160831_master.dbo.d_interval_monitor as dim
where
dim.INT_ID
in
(
select 
d.INT_ID 
from 
moe_20230324.dbo.o_d_pumptest as d
where
d.INT_ID
in 
(
select
d2.INT_ID
from 
oak_20160831_master.dbo.d_interval_monitor as d2
where
d2.MON_FLOWING is null 
)
and d.REC_PUMP_RATE_IGPM is null 
and d.FLOWING_RATE_IGPM is not null 
)

-- FLOWING_RATE_IGPM less than REC_PUMP_RATE_IGPM and no MON_FLOWING; tag MON_FLOWING

-- v20190509 50 rows
-- v20200721 11 rows
-- v20210119 0 rows
-- v20220328 2 rows
-- v20230324 9 rows

select
dim.MON_ID
from 
oak_20160831_master.dbo.d_interval_monitor as dim
where
dim.INT_ID
in
(
select 
d.INT_ID 
from 
moe_20230324.dbo.o_d_pumptest as d
where
d.INT_ID
in 
(
select
d2.INT_ID
from 
oak_20160831_master.dbo.d_interval_monitor as d2
where
d2.MON_FLOWING is null 
)
and d.FLOWING_RATE_IGPM<d.REC_PUMP_RATE_IGPM
)

update oak_20160831_master.dbo.d_interval_monitor
set
mon_flowing=1
from 
oak_20160831_master.dbo.d_interval_monitor as dim
where
dim.INT_ID
in
(
select 
d.INT_ID 
from 
moe_20230324.dbo.o_d_pumptest as d
where
d.INT_ID
in 
(
select
d2.INT_ID
from 
oak_20160831_master.dbo.d_interval_monitor as d2
where
d2.MON_FLOWING is null 
)
and d.FLOWING_RATE_IGPM<d.REC_PUMP_RATE_IGPM
)

-- if FLOWING_RATE_IGPM is greater than REC_PUMP_RATE_IGPM and MON_FLOWING is not
-- tagged, null FLOWING_RATE_IGPM; this is considered an error

-- v20190509 3 rows
-- v20200721 3 rows
-- v20210119 0 rows
-- v20220328 0 rows
-- v20230324 1 

select
dpump.INT_ID
from 
moe_20230324.dbo.o_d_pumptest as dpump
where
dpump.INT_ID
in
(
select 
d.INT_ID 
from 
moe_20230324.dbo.o_d_pumptest as d
where
dpump.INT_ID
in 
(
select
d2.INT_ID
from 
oak_20160831_master.dbo.d_interval_monitor as d2
where
d2.MON_FLOWING is null 
)
and dpump.FLOWING_RATE_IGPM>dpump.REC_PUMP_RATE_IGPM
)

update moe_20230324.dbo.o_d_pumptest
set
flowing_rate_igpm=null
from 
moe_20230324.dbo.o_d_pumptest as dpump
where
dpump.INT_ID
in
(
select 
d.INT_ID 
from 
moe_20230324.dbo.o_d_pumptest as d
where
d.INT_ID
in 
(
select
d2.INT_ID
from 
oak_20160831_master.dbo.d_interval_monitor as d2
where
d2.MON_FLOWING is null 
)
and dpump.FLOWING_RATE_IGPM>dpump.REC_PUMP_RATE_IGPM
)







