
--**** G_10_05

--***** Use GRASS GIS extract the elevations at each borehole location

-- assemble these into the format described by the database manual, Section G.10.5

-- create a view and place it in the temphold database

create view V_MOE_LOCN_20260813 as
select
d.loc_id
,cast(d.loc_coord_easting as int) as x
,cast(d.loc_coord_northing as int) as y
from 
MOE_20260813.dbo.M_D_LOCATION as d

select
*
from 
temphold.dbo.MOE_LOCN_20260813

-- export this as a CSV file and compare against DEM (MNR 10m)

-- input file (with elevations) should be called MOE_ELEV_20260813; the
-- keys should be BORE_HOLE_ID and DEM_MNR; check for no-value locations (usually
-- found at the edge of the study area)

-- for example

select
*
from 
temphold.dbo.MOE_ELEV_20260813

-- load this into MOE_20260813 file called YC_20260813_BORE_HOLE_ID_ELEVS

-- for example

select
m.loc_id as BORE_HOLE_ID
,m.value as DEM_MNR
--,s.value as DEM_SRTM
into MOE_20260813.dbo.YC_20260813_BORE_HOLE_ID_ELEVS
from 
temphold.dbo.moe_elev_20260813 as m
--inner join moe_elev_srtm_20260813 as s
--on m.loc_id=s.loc_id

-- 11851 rows v20190509
-- 11760 rows v20200721
-- 24619 rows v20210119
-- 15235 rows v20220328
-- 18826 rows v20230324
-- 23131 rows v20240326
-- 18379 rows v20250711
-- 129172 rows v20260813 (note that two records were removed - invaid zones [44])  

select
count(*) 
from 
moe_20260813.dbo.yc_20260813_bore_hole_id_elevs

select
*
from 
moe_20260813.dbo.yc_20260813_bore_hole_id_elevs
where
dem_mnr= -9999
--dem_srtm= -9999
--dem_mnr=-9999 and dem_srtm=-9999




