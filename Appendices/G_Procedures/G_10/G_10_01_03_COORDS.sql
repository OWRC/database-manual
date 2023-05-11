
--***** G_10_01_03

--***** Select the coordinates and BORE_HOLE_ID for determining which locations to include

-- v20170905 355151 BORE_HOLE_IDs 
-- v20180530 349638 BORE_HOLE_IDs
-- v20190509 356603 BORE_HOLE_IDs
-- v20200721 366339 BORE_HOLE_IDs
-- v20220328 371492 BORE_HOLE_IDs
-- v20230324 18826  BORE_HOLE_IDs (z17/18 only)

select
count(*) 
from 
(

select
bh.BORE_HOLE_ID
,bh.WELL_ID
,cast(bh.well_id as int) as MOE_WELL_ID
,bh.ZONE
,bh.EAST83
,bh.NORTH83
from 
MOE_20230324.dbo.TblBore_Hole as bh
inner join MOE_20230324.dbo.YC_20230324_WELL_ID_AVAIL as avail
on bh.WELL_ID=avail.WELL_ID

) as t

select
bh.BORE_HOLE_ID
,bh.WELL_ID
,cast(bh.well_id as int) as MOE_WELL_ID
,bh.ZONE
,bh.EAST83
,bh.NORTH83
into MOE_20230324.dbo.YC_20230324_BORE_HOLE_ID_COORDS
from 
MOE_20230324.dbo.TblBore_Hole as bh
inner join MOE_20230324.dbo.YC_20230324_WELL_ID_AVAIL as avail
on bh.WELL_ID=avail.WELL_ID

-- a new table should be created here using an external GIS; this determines
-- whether the location lies within the YC area

select
*
from 
MOE_20230324.dbo.YC_20230324_BORE_HOLE_ID_COORDS_YC

-- v20180530 15578 BORE_HOLE_IDs
-- v20190509 11851 BORE_HOLE_IDs
-- v20200727 11760 BORE_HOLE_IDs
-- v20210119 24619 BORE_HOLE_IDs (after the v20210119 correction, detailed below); note that this includes expansion into the Halton region
-- v20220328 15235 BORE_HOLE_IDs
-- v20230324 18826 BORE_HOLE_IDs

select
count(*)
from 
MOE_20230324.dbo.YC_20230324_BORE_HOLE_ID_COORDS_YC

--***** 20230324
--***** Most of the determination of the locations within the ORMGP study area was undertaken within the external GIS due
--***** to the import issue experienced (for tblBore_Hole, as a result of a datetime conversion error)

--***** 20210119
--***** The above steps were not taken; instead, all locations withing the study area
--***** are populated into the YC_20230324_BORE_HOLE_ID_COORDS_YC table; we need to reduce
--***** this to include only those that are missing; the following steps do so; note the
--***** use of V_SYS_MOE_WELL_ID_DLA

select
*
from 
moe_20230324.dbo.yc_20230324_bore_hole_id_coords_yc

-- v20210119 24619 locations (note that this also includes the expansion into the Halton region)

select
t.*
from 
(
select
m.well_id
,m.bore_hole_id
,v.loc_id
,v.moe_well_id
from 
moe_20230324.dbo.yc_20230324_bore_hole_id_coords_yc as m
left outer join oak_20160831_master.dbo.v_sys_moe_well_id_dla as v
on m.well_id=v.moe_well_id
) as t
where
t.loc_id is null

-- delete those that have a LOC_ID already assigned; after deletion, watch in
-- subsequent steps to determine if we need to reassign the mfd_id/id columns
-- (i.e. the field being used as the rkey)

delete from moe_20230324.dbo.yc_20230324_bore_hole_id_coords_yc
where well_id in
(
select
v.moe_well_id
--,v.loc_id
from 
moe_20230324.dbo.yc_20230324_bore_hole_id_coords_yc as m
inner join oak_20160831_master.dbo.v_sys_moe_well_id_dla as v
on m.well_id=v.moe_well_id
where
v.loc_id is not null
)

--***** 20200721
--***** The following were not run - look for subseqent affected queries 

-- null the original values if they already WERE in UTMZ17 NAD83

--update MOE_20230324.dbo.YC_20230324_BORE_HOLE_ID_COORDS_YC
--set
--EAST83_ORIG=null
--,NORTH83_ORIG=null
--where 
--EAST83_ORIG=-9999

--select
--*
--from 
--MOE_20230324.dbo.YC_20230324_BORE_HOLE_ID_COORDS_YC
--where 
--NORTH83_ORIG = -9999









