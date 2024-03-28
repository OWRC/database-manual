
--***** G.30.03.01 D_BOREHOLE_CONSTRUCTION BORE_HOLE_ID

-- determine those BORE_HOLE_IDs that do not have any records/screens in D_INTERVAL
-- these are the report screens

-- get all the affected BORE_HOLE_IDs

-- v20190509 20734 rows
-- v20200810 21147
-- v20210119 20457
-- v20220328 27610
-- v20230324 26974
-- v20240326 35884

-- note that in some cases, there could-be/are multiple BORE_HOLE_IDs for a single
-- LOC_ID; the extra rows are considered to be decommissioned or modified well records

select
dbore.loc_id
,v.moe_bore_hole_id
into moe_20240326.dbo.ORMGP_20240326_base_DBHCONS
from 
oak_20160831_master.dbo.d_borehole as dbore
inner join oak_20160831_master.dbo.d_location as dloc
on dbore.loc_id=dloc.loc_id
inner join oak_20160831_master.dbo.d_location_qa as dlqa
on dbore.loc_id=dlqa.loc_id
inner join oak_20160831_master.dbo.v_sys_agency_ypdt as yc
on dbore.loc_id=yc.loc_id
left outer join 
(
select
loc_id
,count(*) as rcount
from 
oak_20160831_master.dbo.d_borehole_construction as dbc
inner join oak_20160831_master.dbo.d_borehole as dbore
on dbc.bh_id=dbore.bh_id
group by 
dbore.loc_id
) as d
on dbore.loc_id=d.loc_id
inner join oak_20160831_master.dbo.v_sys_moe_locations as v
on dbore.loc_id=v.loc_id
where 
d.rcount is null
and dloc.loc_type_code=1
and dlqa.qa_coord_confidence_code<>117
and v.moe_bore_hole_id is not null
group by
dbore.loc_id,v.moe_bore_hole_id

select
count(*) 
from 
moe_20240326.dbo.ORMGP_20240326_base_DBHCONS

-- assemble the casing information

-- v20190509 6942 rows
-- v20200810 3210 rpws
-- v20210119 518 rows
-- v20220328 191 rows
-- v20230324 1781 rows
-- v20240326 10094 rows

select
-- note that we're using BORE_HOLE_ID as a temporary BH_ID
y.LOC_ID
,y.moe_BORE_HOLE_ID as BH_ID
,case
when moec.MATERIAL is null then 10      -- unknown
when moec.MATERIAL = 1     then 21      -- steel casing
when moec.MATERIAL = 2     then 16      -- galvanized
when moec.MATERIAL = 3     then 23      -- concrete
when moec.MATERIAL = 4     then 24      -- open hole
when moec.MATERIAL = 5     then 25      -- plastic
when moec.MATERIAL = 6     then 32      -- fibreglass
end 
as [CON_SUBTYPE_CODE]
,moec.DEPTH_FROM as [CON_TOP_OUOM]
,moec.DEPTH_TO as [CON_BOT_OUOM]
,moec.CASING_DEPTH_UOM as [CON_UNIT_OUOM]
,moec.CASING_DIAMETER as [CON_DIAMETER_OUOM]
,moec.CASING_DIAMETER_UOM as [CON_DIAMETER_UNIT_OUOM]
,convert(varchar(255),null) as CON_COMMENT
into MOE_20240326.dbo.ORMGP_20240326_upd_DBHCONS
from 
MOE_20240326.dbo.ORMGP_20240326_base_DBHCONS as y
inner join MOE_20240326.dbo.TblPipe as moep
on y.moe_BORE_HOLE_ID=moep.Bore_Hole_ID
inner join MOE_20240326.dbo.TblCasing as moec
on moep.PIPE_ID=moec.PIPE_ID
where
not
(
moec.DEPTH_TO is null 
and moec.CASING_DEPTH_UOM is null 
and moec.CASING_DIAMETER is null 
and moec.CASING_DIAMETER_UOM is null
)

select
count(*)
from 
MOE_20240326.dbo.ORMGP_20240326_upd_DBHCONS

-- assemble the plug information

-- v20190509 11138 rows
-- v20200721 5085 rows
-- v20210119 1010 rows
-- v20220328 538 
-- v20230324 4589 (2808)
-- v20240326 30881 (20787)

insert into MOE_20240326.dbo.ORMGP_20240326_upd_DBHCONS
(LOC_ID,BH_ID,CON_SUBTYPE_CODE,CON_TOP_OUOM,CON_BOT_OUOM,CON_UNIT_OUOM)
select 
-- note that we're using BORE_HOLE_ID as a temporary BH_ID
y.LOC_ID
,y.moe_BORE_HOLE_ID as BH_ID
,31 as CON_SUBTYPE_CODE
,moep.PLUG_FROM as [CON_TOP_OUOM]
,moep.PLUG_TO   as [CON_BOT_OUOM]
,moep.PLUG_DEPTH_UOM as [CON_UNIT_OUOM]
from 
MOE_20240326.dbo.ORMGP_20240326_base_DBHCONS as y
inner join MOE_20240326.dbo.TblPlug as moep
on y.moe_BORE_HOLE_ID=moep.BORE_HOLE_ID
where 
not 
(
moep.PLUG_FROM is null 
and moep.PLUG_TO is null 
and moep.PLUG_DEPTH_UOM is null 
)

select
count(*)
from 
MOE_20240326.dbo.ORMGP_20240326_upd_DBHCONS

-- check that the tops are less than the bottom

-- v20190509 1456 rows
-- v20200721 256 rows
-- v20210119 163 rows
-- v20230324 384 rows
-- v20240326 1948 rows

SELECT 
[BH_ID]
,[CON_SUBTYPE_CODE]
,[CON_TOP_OUOM]
,[CON_BOT_OUOM]
,[CON_UNIT_OUOM]
,[CON_DIAMETER_OUOM]
,[CON_DIAMETER_UNIT_OUOM]
,[CON_COMMENT]
FROM MOE_20240326.[dbo].ORMGP_20240326_upd_DBHCONS
where
CON_TOP_OUOM>CON_BOT_OUOM

update MOE_20240326.[dbo].ORMGP_20240326_upd_DBHCONS
set
CON_TOP_OUOM=CON_BOT_OUOM
,CON_BOT_OUOM=CON_TOP_OUOM
,CON_COMMENT='Exchanged top and bot values'
where
CON_TOP_OUOM>CON_BOT_OUOM

-- create the O_D_BOREHOLE_CONSTRUCTION table
-- introduce a counter until we replace with a random identifier

-- update the DATA_ID and SYS_TEMP values

-- v20190509 18080 rows
-- v20200721 8295 rows
-- v20210119 1528 rows
-- v20220328 538 
-- v20230324 4589 rows
-- v20240326 30881 rows

SELECT 
d.[BH_ID]
,[CON_SUBTYPE_CODE]
,[CON_TOP_OUOM]
,[CON_BOT_OUOM]
,[CON_UNIT_OUOM]
,[CON_DIAMETER_OUOM]
,[CON_DIAMETER_UNIT_OUOM]
,[CON_COMMENT]
,cast( 526 as int ) as DATA_ID
,cast(null as int) as SYS_RECORD_ID
,cast( '20240326i' as varchar(255) ) as SYS_TEMP1
,cast( 20240326 as int ) as SYS_TEMP2
,ROW_NUMBER() over (order by y.BH_ID) as rkey
,y.bh_id as moe_bore_hole_id
into moe_20240326.dbo.O_D_BOREHOLE_CONSTRUCTION
FROM 
MOE_20240326.[dbo].ORMGP_20240326_upd_DBHCONS as y
inner join oak_20160831_master.dbo.d_borehole as d
on y.loc_id=d.loc_id

select
count(*)
from 
moe_20240326.dbo.O_D_BOREHOLE_CONSTRUCTION

-- update the SYS_RECORD_ID
-- remember to change the number of rows created

select
od.bh_id
,od.rkey
,t2.sys_record_id
from 
moe_20240326.dbo.o_d_borehole_construction as od
inner join
(
select
t.sys_record_id
,row_number() over (order by t.sys_record_id) as rkey
from 
(
select
top 35000
v.new_id as sys_record_id
from 
oak_20160831_master.dbo.v_sys_random_id_bulk_001 as v
where 
v.new_id not in
( select sys_record_id from oak_20160831_master.dbo.d_borehole_construction )
) as t
) as t2
on od.rkey=t2.rkey

update moe_20240326.dbo.o_d_borehole_construction
set
sys_record_id=t2.sys_record_id
from 
moe_20240326.dbo.o_d_borehole_construction as od
inner join
(
select
t.sys_record_id
,row_number() over (order by t.sys_record_id) as rkey
from 
(
select
top 35000
v.new_id as sys_record_id
from 
oak_20160831_master.dbo.v_sys_random_id_bulk_001 as v
where 
v.new_id not in
( select sys_record_id from oak_20160831_master.dbo.d_borehole_construction )
) as t
) as t2
on od.rkey=t2.rkey

-- insert the O_D_BOREHOLE_CONSTRUCTION table into D_BOREHOLE_CONSTRUCTION

insert into oak_20160831_master.dbo.d_borehole_construction
(
[BH_ID], 
[CON_SUBTYPE_CODE], 
[CON_TOP_OUOM], 
[CON_BOT_OUOM], 
[CON_UNIT_OUOM], 
[CON_DIAMETER_OUOM], 
[CON_DIAMETER_UNIT_OUOM], 
[CON_COMMENT], 
[DATA_ID], 
[SYS_RECORD_ID], 
[SYS_TEMP1], 
[SYS_TEMP2]
)
select
[BH_ID], 
[CON_SUBTYPE_CODE], 
[CON_TOP_OUOM], 
[CON_BOT_OUOM], 
[CON_UNIT_OUOM], 
[CON_DIAMETER_OUOM], 
[CON_DIAMETER_UNIT_OUOM], 
[CON_COMMENT], 
[DATA_ID], 
[SYS_RECORD_ID], 
[SYS_TEMP1], 
[SYS_TEMP2]
from 
moe_20240326.dbo.o_d_borehole_construction


