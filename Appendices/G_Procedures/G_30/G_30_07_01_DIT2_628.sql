
--***** G.30.07.01 D_INTERVAL_TEMPORAL_2 BORE_HOLE_IDs and INT_IDs

-- determine those intervals that do not have a static water
-- level in DIT2

-- note that we're using the complete list of boreholes related
-- to the MOEDB that are currently present in the ORMDB

-- assemble the BORE_HOLE_IDs for which we'll pull water level data;
-- add some indexes to the resulting table

-- v20200721 1069 rows
-- v20210119 45 rows
-- v20220328 131 rows
-- v20230324 589
-- v20240326 1722

select
dint.int_id
,v.moe_bore_hole_id
into moe_20240326.dbo.ORMGP_20240326_upd_DIT2_628
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
oak_20160831_master.dbo.d_interval_temporal_2
where 
rd_type_code=0
and rd_name_code=628
group by
int_id
) as d2
on dint.int_id=d2.int_id
inner join moe_20240326.dbo.tblpipe as moetp
on v.moe_bore_hole_id=moetp.bore_hole_id
inner join moe_20240326.dbo.tblpump_test as moept
on moetp.pipe_id=moept.pipe_id
where 
d2.int_id is null
and moept.static_lev is not null
group by
dint.int_id,v.moe_bore_hole_id

select count(*) as rcount from moe_20240326.dbo.ORMGP_20240326_upd_DIT2_628

-- now we'll generate the DIT2 compatible table; run this first
-- to see if we're missing bh_gnd_elev values

-- update DATA_ID and SYS_TEMP

-- v20200721 1065 rows
-- v20210119 41 rows
-- v20220328 127 rows
-- v20230324 585 rows
-- v20240326 1718

select 
dbore.LOC_ID
,dint.INT_ID
,cast(0 as int) as RD_TYPE_CODE
,cast(628 as int) as RD_NAME_CODE
,case
when dint.int_start_date is null then cast( '1867-07-01' as datetime ) 
else dint.INT_START_DATE 
end as [RD_DATE]
,cast(
case
when moept.LEVELS_UOM like 'ft' then dbore.bh_gnd_elev-(0.3048*moept.Static_lev) 
else dbore.bh_gnd_elev-moept.Static_lev 
end
as float
) as[RD_VALUE]
,cast(6 as int) as UNIT_CODE
,cast('Water Level - Manual - Static' as varchar(255)) as RD_NAME_OUOM
,cast(moept.Static_lev as float) as [RD_VALUE_OUOM]
,cast(moept.LEVELS_UOM as varchar(50)) as [RD_UNIT_OUOM]
,cast(1 as int) as [REC_STATUS_CODE]
,cast(null as varchar(255)) as RD_COMMENT
,cast(526 as int) as DATA_ID
,cast(null as int) as SYS_RECORD_ID
,ROW_NUMBER() over (order by dint.INT_ID) as rkey
into moe_20240326.dbo.O_D_INTERVAL_TEMPORAL_2_628
from 
moe_20240326.dbo.ormgp_20240326_upd_dit2_628 as d2
inner join moe_20240326.dbo.tblpipe as moetp
on d2.moe_bore_hole_id=moetp.bore_hole_id
inner join moe_20240326.dbo.tblpump_test as moept
on moetp.pipe_id=moept.pipe_id
inner join oak_20160831_master.dbo.d_interval as dint
on d2.int_id=dint.int_id
inner join oak_20160831_master.dbo.d_borehole as dbore
on dint.loc_id=dbore.loc_id

select count(*) as rcount from moe_20240326.dbo.O_D_INTERVAL_TEMPORAL_2_628

-- look for those rows where a NULL RD_VALUE occurs; this is
-- likely a result from a NULL BH_GND_ELEV in D_BOREHOLE;
-- check this

-- v20200721 0 rows
-- v20210119 2 rows
-- v20220328 0 rows
-- v20230324 0 rows
-- v20240326 0 rows

--create view V_MOE_20240326_UPD_ELEVS2 as
select
d2.loc_id
,dloc.loc_coord_easting as x
,dloc.loc_coord_northing as y
--,dbore.bh_gnd_elev
from 
moe_20240326.dbo.o_d_interval_temporal_2_628 as d2
inner join oak_20160831_master.dbo.d_location as dloc
on d2.loc_id=dloc.loc_id
inner join oak_20160831_master.dbo.d_borehole as dbore
on d2.loc_id=dbore.loc_id
where 
d2.rd_value is null

--***** 20240326 the following was previously disabled; it appears to only be used when
--***** a null bh_gnd_elev is present in d_borehole

-- create a table of elevations linked to a LOC_ID; update
-- the D_BOREHOLE table

--update oak_20160831_master.dbo.d_borehole
--set
--bh_gnd_elev= m.value
--,bh_gnd_elev_ouom= m.value
--,bh_gnd_elev_unit_ouom= 'masl'
--,bh_dem_gnd_elev= m.value
--from 
--oak_20160831_master.dbo.d_borehole as dbore
--inner join temphold.dbo.moe_20240326_upd_elevs2 as m
--on dbore.loc_id=m.loc_id

-- populate the SYS_RECORD_IDs

update moe_20240326.dbo.o_d_interval_temporal_2_628
set
sys_record_id= t2.sri
from 
moe_20240326.dbo.o_d_interval_temporal_2_628 as d
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
( select sys_record_id from oak_20160831_master.dbo.d_interval_temporal_2 )
) as t
) as t2
on d.rkey=t2.rkey

-- incorporate the static WLS in DIT2

-- v20210119 41 rows
-- v20220328 127 rows
-- v20230324 585
-- v20240326 1718

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
SYS_TEMP1,
SYS_TEMP2, 
[SYS_RECORD_ID]
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
cast( '20240328n' as varchar(255) ) as SYS_TEMP1,
cast( 20240328 as int ) as SYS_TEMP2, 
[SYS_RECORD_ID]
from 
moe_20240326.dbo.o_d_interval_temporal_2_628 

