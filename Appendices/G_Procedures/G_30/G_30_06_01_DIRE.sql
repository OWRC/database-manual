
--***** G.30.06.01 D_INTERVAL_REF_ELEV BORE_HOLE_ID

-- determine those BORE_HOLE_IDs that do not have a reference elevation
-- in D_INTERVAL_REF_ELEV

-- note that we can use the intervals that were just created or 
-- updated in O_D_INTERVAL

-- v20210119 DATA_ID 523
-- v20220328 DATA_ID 524
-- v20230324 DATA_ID 525 

-- check, first, that a ground elevation has been specified for these 
-- updated locations

-- v20200721 0 rows
-- v20210119 0 rows
-- v20230324 0 rows

-- create view V_MOE_20230324_UPD_ELEVS as
select
dbore.loc_id
,dloc.loc_coord_easting as x
,dloc.loc_coord_northing as y
from 
moe_20230324.dbo.o_d_interval as dint
inner join oak_20160831_master.dbo.d_borehole as dbore
on dint.loc_id=dbore.loc_id
inner join oak_20160831_master.dbo.d_location as dloc
on dbore.loc_id=dloc.loc_id
left outer join oak_20160831_master.dbo.d_interval_ref_elev as dire
on dint.int_id=dire.int_id
where 
( dire.int_id is null or dire.ref_elev is null )
and dbore.bh_gnd_elev is null

-- we'll create a view from this, yank the ground elevations and 
-- populate the D_BOREHOLE table

-- update DATA_ID, SYS_TEMP1 and SYS_TEMP2

-- create the temporary DIRE table

-- v20200721 6 rows
-- v20210119 
-- v20220328 2 rows
-- v20230324 1

select
dint.INT_ID
,dire.SYS_RECORD_ID
,dint.int_start_date as REF_ELEV_START_DATE
,( dbore.bh_gnd_elev + 0.75 ) as REF_ELEV
,( dbore.bh_gnd_elev + 0.75 ) as REF_ELEV_OUOM
,cast('masl' as varchar(50)) as REF_ELEV_UNIT_OUOM
,0.75 as REF_STICK_UP
,cast('0.75' as varchar(50)) as REF_POINT
,cast( 525 as int ) as DATA_ID
,cast( '20230324a' as varchar(255) ) as SYS_TEMP1
,cast( 20230324 as int ) as SYS_TEMP2
,case
when dire.int_id is not null then 1
else null
end as int_exists
,row_number() over (order by dint.int_id) as rkey
into moe_20230324.dbo.O_D_INTERVAL_REF_ELEV
from 
moe_20230324.dbo.o_d_interval as dint
inner join oak_20160831_master.dbo.d_borehole as dbore
on dint.loc_id=dbore.loc_id
left outer join oak_20160831_master.dbo.d_interval_ref_elev as dire
on dint.int_id=dire.int_id
where 
dire.int_id is null
or dire.ref_elev is null

select count(*) as rcount from moe_20230324.dbo.O_D_INTERVAL_REF_ELEV

-- populate the SYS_RECORD_IDs that are null; don't forget to change
-- the count of rows

update moe_20230324.dbo.o_d_interval_ref_elev
set
sys_record_id= t2.sri
from 
moe_20230324.dbo.o_d_interval_ref_elev as dire
inner join
(
select
t.sri
,row_number() over (order by t.sri) as rkey
from 
(
select
top 500
v.new_id as sri
from 
oak_20160831_master.dbo.v_sys_random_id_bulk_001 as v
where 
v.new_id not in
( select sys_record_id from oak_20160831_master.dbo.d_interval_ref_elev )
) as t
) as t2
on dire.rkey=t2.rkey
where 
dire.int_exists is null

-- now we can update those records that already existed in the ORMDB

-- v20200721 0 rows
-- v20210119 0 rows
-- v20220328 0 rows
-- v20230324 0 rows

update oak_20160831_master.dbo.d_interval_ref_elev
set 
ref_elev_start_date= m.ref_elev_start_date
,ref_elev= m.ref_elev
,ref_elev_ouom= m.ref_elev_ouom
,ref_elev_unit_ouom= m.ref_elev_unit_ouom
,ref_stick_up= m.ref_stick_up
,ref_point= m.ref_point
,data_id= m.data_id
,sys_temp1= m.sys_temp1
,sys_temp2= m.sys_temp2
from 
oak_20160831_master.dbo.d_interval_ref_elev as dire
inner join moe_20230324.dbo.o_d_interval_ref_elev as m
on dire.sys_record_id=m.sys_record_id
where 
m.int_exists is not null

-- and insert the remainder

-- v20200721 6 rows
-- v20210119 38 rows
-- v20220328 2 rows
-- v20230324 1 rows

insert into oak_20160831_master.dbo.d_interval_ref_elev
(
[INT_ID], 
[SYS_RECORD_ID], 
[REF_ELEV_START_DATE], 
[REF_ELEV], 
[REF_ELEV_OUOM], 
[REF_ELEV_UNIT_OUOM], 
[REF_STICK_UP], 
[REF_POINT], 
[DATA_ID], 
[SYS_TEMP1], 
[SYS_TEMP2]
)
select 
[INT_ID], 
[SYS_RECORD_ID], 
[REF_ELEV_START_DATE], 
[REF_ELEV], 
[REF_ELEV_OUOM], 
[REF_ELEV_UNIT_OUOM], 
[REF_STICK_UP], 
[REF_POINT], 
[DATA_ID], 
[SYS_TEMP1], 
[SYS_TEMP2]
from 
moe_20230324.dbo.o_d_interval_ref_elev as m
where 
m.int_exists is null




