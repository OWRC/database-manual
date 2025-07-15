
--***** G.30.08.03 D_PUMPTEST and D_PUMPTEST_STEP IDs 

-- we'll create a series of PUMP_TEST_IDs for the two tables
-- and then add them to the appropriate ORMDB tables

-- update SYS_TEMP1 and SYS_TEMP2

-- get the number of rows

select
count(*) 
from 
moe_20250711.dbo.o_d_pumptest

-- v20190509 1667 rows
-- v20200721 1013 rows
-- v20210119 15 rows
-- v20220328 107 rows
-- v20230324 539
-- v20240326 1617
-- v20250711 2217

update moe_20250711.dbo.o_d_pumptest
set
pump_test_id= t2.pump_test_id
from 
moe_20250711.dbo.o_d_pumptest as d
inner join 
(
select
t.pump_test_id
,row_number() over (order by t.pump_test_id) as rkey
from 
(
select
top 5000
v.new_id as pump_test_id
from 
oak_20160831_master.dbo.v_sys_random_id_bulk_001 as v
where 
v.new_id not in 
( select pump_test_id from oak_20160831_master.dbo.d_pumptest )
) as t
) as t2
on d.rkey=t2.rkey

-- insert these into D_PUMPTEST

insert into oak_20160831_master.dbo.d_pumptest
(
[INT_ID], 
[PUMP_TEST_ID], 
[PUMPTEST_DATE], 
[PUMPTEST_NAME], 
[REC_PUMP_DEPTH_METERS], 
[REC_PUMP_RATE_IGPM], 
[FLOWING_RATE_IGPM], 
[DATA_ID], 
[PUMPTEST_METHOD_CODE], 
[PUMPTEST_TYPE_CODE], 
[WATER_CLARITY_CODE], 
SYS_TEMP1,
SYS_TEMP2
)
select
[INT_ID], 
[PUMP_TEST_ID], 
[PUMPTEST_DATE], 
[PUMPTEST_NAME], 
[REC_PUMP_DEPTH_METERS], 
[REC_PUMP_RATE_IGPM], 
[FLOWING_RATE_IGPM], 
[DATA_ID], 
[PUMPTEST_METHOD_CODE], 
[PUMPTEST_TYPE_CODE], 
[WATER_CLARITY_CODE], 
cast( '20250714q' as varchar(255) ) as SYS_TEMP1,
cast( 20250714 as int ) as SYS_TEMP2
from 
moe_20250711.dbo.o_d_pumptest 

-- update the O_D_PUMPTEST_STEP table with the new PUMP_TEST_ID

-- v20190509 1449 rows
-- v20200721 879 rows
-- v20210119 12 rows
-- v20220328 83 rows
-- v20230324 502 
-- v20240326 1555
-- v20250711 2063

update moe_20250711.dbo.o_d_pumptest_step
set
pump_test_id= dp.pump_test_id
from 
moe_20250711.dbo.o_d_pumptest_Step as dps
inner join moe_20250711.dbo.o_d_pumptest as dp
on dps.moe_pump_test_id=dp.moe_pump_test_id

-- get the number of rows

select
count(*) 
from 
moe_20250711.dbo.o_d_pumptest_step


-- populate the SYS_RECORD_ID field

update moe_20250711.dbo.o_d_pumptest_step
set
sys_record_id= t2.sri
from 
moe_20250711.dbo.o_d_pumptest_step as d
inner join
(
select
t.sri
,row_number() over (order by t.sri) as rkey
from 
(
select
top 5000
v.new_id as sri
from 
oak_20160831_master.dbo.v_sys_random_id_bulk_001 as v
where 
v.new_id not in
( select sys_record_id from oak_20160831_master.dbo.d_pumptest_step )
) as t
) as t2
on d.rkey=t2.rkey

-- insert the information into the D_PUMPTEST_STEP

insert into oak_20160831_master.dbo.d_pumptest_step
(
[PUMP_TEST_ID], 
[PUMP_RATE], 
[PUMP_RATE_UNITS], 
[PUMP_RATE_OUOM], 
[PUMP_RATE_UNITS_OUOM], 
[PUMP_START], 
[PUMP_END], 
[DATA_ID], 
[SYS_RECORD_ID], 
SYS_TEMP1,
SYS_TEMP2
)
select
[PUMP_TEST_ID], 
[PUMP_RATE], 
[PUMP_RATE_UNITS], 
[PUMP_RATE_OUOM], 
[PUMP_RATE_UNITS_OUOM], 
[PUMP_START], 
[PUMP_END], 
[DATA_ID], 
[SYS_RECORD_ID], 
cast( '20250714r' as varchar(255) ) as SYS_TEMP1,
cast( 20250714 as int ) as SYS_TEMP2
from 
moe_20250711.dbo.o_d_pumptest_step







