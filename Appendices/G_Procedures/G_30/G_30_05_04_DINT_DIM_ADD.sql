
--***** G.30.05.04 and G.30.05.05 D_INTERVAL and D_INTERVAL_MONITOR Add data to ORMDB

-- incorporate the information into the ORMDB; we'll need to update some of the
-- random ID's to do so

-- INT_IDs present

-- this can be used to check the current information and the new information

-- v20200721 2749 rows
-- v20210119 431 rows
-- v20220328 180 rows
-- v20230324 1515

select
d.int_name
,dint.int_name
,d.int_name_alt1
,dint.int_name_alt1
,d.int_type_code
,dint.int_type_code
,d.int_start_date
,dint.int_start_date
from 
moe_20230324.dbo.o_d_interval as d
inner join oak_20160831_master.dbo.d_interval as dint
on d.int_id=dint.int_id
where 
d.int_exists=1
and d.int_id is not null
and
(
( d.int_start_date <> dint.int_start_date )
or
( d.int_type_code <> dint.int_type_code )
or
( d.int_name_alt1 <> dint.int_name_alt1 )
)

-- we'll now update these

update oak_20160831_master.dbo.d_interval
set
int_name= d.int_name
,int_name_alt1= d.int_name_alt1
,int_type_code= d.int_type_code
,int_start_date= d.int_start_date
,int_confidentiality_code= d.int_confidentiality_code
,int_active= d.int_active
,data_id= d.data_id
,sys_temp1= d.sys_temp1
,sys_temp2= d.sys_temp2
from 
oak_20160831_master.dbo.d_interval as dint
inner join moe_20230324.dbo.o_d_interval as d
on dint.int_id=d.int_id
where 
d.int_exists=1
and
(
( d.int_start_date <> dint.int_start_date )
or
( d.int_type_code <> dint.int_type_code )
or
( d.int_name_alt1 <> dint.int_name_alt1 )
)

-- v20200721 max id 2758
-- v20210119 max rkey 469
-- v20220328 max rkey 182 
-- v20230324 max rkey 1516

-- note that this is the highest number
select
max(rkey) as max_rkey
from 
moe_20230324.dbo.o_d_interval as dint

-- v20200721 6 rows
-- v20210119 38 rows
-- v20220328 2
-- v20230324 1 

select
count(*) 
from 
moe_20230324.dbo.o_d_interval as dint
where 
dint.int_exists is null

select
*
from 
moe_20230324.dbo.o_d_interval as dint
where 
dint.int_exists is null

-- create the random INT_IDs, don't forget to change the count as necessary

update moe_20230324.dbo.o_d_interval
set
int_id= t2.int_id
from 
moe_20230324.dbo.o_d_interval as dint
inner join
(
select
t.int_id
,row_number() over (order by t.int_id) as rkey
from 
(
select
top 5000
v.new_id as int_id
from 
oak_20160831_master.dbo.v_sys_random_id_bulk_001 as v
where 
v.new_id not in
( select int_id from oak_20160831_master.dbo.d_interval )
) as t
) as t2
on dint.rkey=t2.rkey
where 
dint.int_exists is null

-- insert these into D_INTERVAL

insert into oak_20160831_master.dbo.d_interval
(
[LOC_ID], 
[INT_ID], 
[INT_NAME], 
[INT_NAME_ALT1], 
[INT_TYPE_CODE], 
[INT_START_DATE], 
[INT_CONFIDENTIALITY_CODE], 
[INT_ACTIVE],
[DATA_ID], 
[SYS_TEMP1], 
[SYS_TEMP2]
)
select
[LOC_ID], 
[INT_ID], 
[INT_NAME], 
[INT_NAME_ALT1], 
[INT_TYPE_CODE], 
[INT_START_DATE], 
[INT_CONFIDENTIALITY_CODE], 
[INT_ACTIVE],
[DATA_ID], 
[SYS_TEMP1], 
[SYS_TEMP2]
from 
moe_20230324.dbo.o_d_interval as d
where
d.int_exists is null

-- now that all the intervals are now in the ORMDB, add the 
-- records into D_INTERVAL_MONITOR; make sure to add an indexed 
-- key/count 

-- first we'll update the INT_IDs

-- v20200721 2789 rows
-- v20210119 474 ( 43 had null INT_IDs )
-- v20220328 189 ( 2 had null INT_IDs )
-- v20230324 1 

update moe_20230324.dbo.o_d_interval_monitor
set
int_id= dint.int_id
from 
moe_20230324.dbo.o_d_interval_monitor as dim
inner join moe_20230324.dbo.o_d_interval as dint
on dim.tmp_int_id=dint.tmp_int_id
where
dint.int_exists is null

select
*
from 
moe_20230324.dbo.o_d_interval_monitor
where
int_id is null

select
count(*) 
from 
moe_20230324.dbo.o_d_interval_monitor

-- and add the random MON_IDs; don't forget to change the count

update moe_20230324.dbo.o_d_interval_monitor
set
mon_id= t2.mon_id
from 
moe_20230324.dbo.o_d_interval_monitor as d
inner join
(
select
t.mon_id
,row_number() over (order by t.mon_id) as rkey
from 
(
select
top 5000
v.new_id as mon_id
from 
oak_20160831_master.dbo.v_sys_random_id_bulk_001 as v
where 
v.new_id not in
( select mon_id from oak_20160831_master.dbo.d_interval_monitor )
) as t
) as t2
on d.rkey=t2.rkey

-- check that these don't already exist in the master db

-- v20210119 474 rows
-- v20220328 189 rows
-- v20230324 1545

select
[INT_ID], 
[MON_SCREEN_SLOT], 
[MON_SCREEN_MATERIAL], 
[MON_DIAMETER_OUOM], 
[MON_DIAMETER_UNIT_OUOM], 
[MON_TOP_OUOM], 
[MON_BOT_OUOM], 
[MON_UNIT_OUOM], 
[MON_COMMENT], 
[MON_FLOWING], 
[MON_ID], 
[DATA_ID], 
[SYS_TEMP1], 
[SYS_TEMP2]
from
moe_20230324.dbo.o_d_interval_monitor as odim
where
odim.int_id not in
( select distinct(int_id) from oak_20160831_master.dbo.d_interval_monitor )

-- we can now insert these into D_INTERVAL_MONITOR

insert into oak_20160831_master.dbo.d_interval_monitor
(
[INT_ID], 
[MON_SCREEN_SLOT], 
[MON_SCREEN_MATERIAL], 
[MON_DIAMETER_OUOM], 
[MON_DIAMETER_UNIT_OUOM], 
[MON_TOP_OUOM], 
[MON_BOT_OUOM], 
[MON_UNIT_OUOM], 
[MON_COMMENT], 
[MON_FLOWING], 
[MON_ID], 
[DATA_ID], 
[SYS_TEMP1], 
[SYS_TEMP2]
)
select
[INT_ID], 
[MON_SCREEN_SLOT], 
[MON_SCREEN_MATERIAL], 
[MON_DIAMETER_OUOM], 
[MON_DIAMETER_UNIT_OUOM], 
[MON_TOP_OUOM], 
[MON_BOT_OUOM], 
[MON_UNIT_OUOM], 
[MON_COMMENT], 
[MON_FLOWING], 
[MON_ID], 
[DATA_ID], 
[SYS_TEMP1], 
[SYS_TEMP2]
from
moe_20230324.dbo.o_d_interval_monitor as odim
where
odim.int_id not in
( select distinct(int_id) from oak_20160831_master.dbo.d_interval_monitor )






