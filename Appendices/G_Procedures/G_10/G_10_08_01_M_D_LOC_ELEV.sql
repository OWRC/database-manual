
--***** G_10_08_01

--***** extract D_LOCATION_SPATIAL_HIST equivalent

-- the DEM elevations using the coordinates in the D_LOCATION table
-- have been determined externally to this translation scheme and 
-- are present in YC_20130923_COORDS; the MOE elevation is being
-- pulled from the TblBore_Hole table and is assumed to be masl

-- check whether any QA codes of 1 have been specified
-- v20170531 there are none present
-- v20180530 there are none present
-- v20190509 there are none present
-- v20200721 0 present
-- v20210119 0 present
-- v20220328 0 present
-- v20230324 0 present
-- v20240326 0 present
-- v20250711 0 present
-- v20260813 0 present

select
dlqa.*
from 
MOE_20260813.dbo.M_D_LOCATION_QA as dlqa
where 
QA_ELEV_CONFIDENCE_CODE=1
or QA_COORD_CONFIDENCE_CODE=1

-- populate D_LOCATION_SPATIAL_HIST with the original coordinates and elevations

-- update LOC_COORD_DATE, LOC_COORD_DATA_ID, LOC_ELEV_DATE, LOC_ELEV_DATA_ID

--***** 20260813 check if LOC_ELEV is populated; if not, only load MNR DEM coordinate records

-- v20260813 0 records have MOE elevations; bypass

select
y.BORE_HOLE_ID as LOC_ID
,cast(4 as int) as LOC_COORD_HIST_CODE
,cast( '2026-08-13' as datetime ) as LOC_COORD_DATE
,ycoord.x as X
,ycoord.y as Y
,cast( 26917 as int ) as EPSG_CODE
,ycoord.east83 as X_OUOM
,ycoord.north83 as Y_OUOM
,cast( ( case when ycoord.zone=17 then 26917 else 26918 end ) as int ) as EPSG_CODE_OUOM
,dlqa.qa_coord_confidence_code as QA_COORD_CODE
,cast( 529 as int ) as LOC_COORD_DATA_ID
,cast( ( case when m.location_method is not null and len(m.location_method)>0 then m.location_method else null end ) as varchar(255) ) as LOC_COORD_METHOD
,cast( ( case when m.elevation is not null then 2 else null end ) as int ) as LOC_ELEV_CODE 
,cast( ( case when m.elevation is not null then '2026-08-13' else null end ) as datetime ) as LOC_ELEV_DATE
,cast(m.ELEVATION as float) as LOC_ELEV
,cast( ( case when m.elevation is not null then 6 else null end ) as int ) as LOC_ELEV_UNIT_CODE
,cast(m.ELEVATION as float) as LOC_ELEV_OUOM
,cast( ( case when m.elevation is not null then 'masl' else null end ) as varchar(50) ) as LOC_ELEV_UNIT_OUOM
,cast( null as int ) as QA_ELEV_CODE
,cast( ( case when m.elevation is not null then 529 else null end ) as int ) as LOC_ELEV_DATA_ID
,cast( ( case when m.elevrc is not null and len(m.elevrc)>0 then m.elevrc else null end ) as varchar(255) ) as LOC_ELEV_COMMENT
from 
MOE_20260813.dbo.YC_20260813_BH_ID as y
inner join MOE_20260813.dbo.TblBore_Hole as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
inner join MOE_20260813.dbo.YC_20260813_BORE_HOLE_ID_COORDS_YC as ycoord
on y.bore_hole_id=ycoord.bore_hole_id
inner join MOE_20260813.dbo.M_D_LOCATION_QA as dlqa
on y.bore_hole_id=dlqa.loc_id

select
y.BORE_HOLE_ID as LOC_ID
,cast(4 as int) as LOC_COORD_HIST_CODE
,cast( '2025-07-11' as datetime ) as LOC_COORD_DATE
,ycoord.x as X
,ycoord.y as Y
,cast( 26917 as int ) as EPSG_CODE
,ycoord.east83 as X_OUOM
,ycoord.north83 as Y_OUOM
,cast( ( case when ycoord.zone=17 then 26917 else 26918 end ) as int ) as EPSG_CODE_OUOM
,dlqa.qa_coord_confidence_code as QA_COORD_CODE
,cast( 528 as int ) as LOC_COORD_DATA_ID
,cast( ( case when m.location_method is not null and len(m.location_method)>0 then m.location_method else null end ) as varchar(255) ) as LOC_COORD_METHOD
,cast( ( case when m.elevation is not null then 2 else null end ) as int ) as LOC_ELEV_CODE 
,cast( ( case when m.elevation is not null then '2025-07-11' else null end ) as datetime ) as LOC_ELEV_DATE
,cast(m.ELEVATION as float) as LOC_ELEV
,cast( ( case when m.elevation is not null then 6 else null end ) as int ) as LOC_ELEV_UNIT_CODE
,cast(m.ELEVATION as float) as LOC_ELEV_OUOM
,cast( ( case when m.elevation is not null then 'masl' else null end ) as varchar(50) ) as LOC_ELEV_UNIT_OUOM
,cast( null as int ) as QA_ELEV_CODE
,cast( ( case when m.elevation is not null then 528 else null end ) as int ) as LOC_ELEV_DATA_ID
,cast( ( case when m.elevrc is not null and len(m.elevrc)>0 then m.elevrc else null end ) as varchar(255) ) as LOC_ELEV_COMMENT
into MOE_20260813.dbo.M_D_LOCATION_SPATIAL_HIST
from 
MOE_20260813.dbo.YC_20260813_BH_ID as y
inner join MOE_20260813.dbo.TblBore_Hole as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
inner join MOE_20260813.dbo.YC_20260813_BORE_HOLE_ID_COORDS_YC as ycoord
on y.bore_hole_id=ycoord.bore_hole_id
inner join MOE_20260813.dbo.M_D_LOCATION_QA as dlqa
on y.bore_hole_id=dlqa.loc_id

-- populate D_LOCATION_SPATIAL_HIST with the DEM elevations

-- update LOC_COORD_DATE, LOC_COORD_DATA_ID, LOC_ELEV_DATE, LOC_ELEV_DATA_ID

select
y.BORE_HOLE_ID as LOC_ID
,cast(4 as int) as LOC_COORD_HIST_CODE
,cast( '2026-08-13' as datetime ) as LOC_COORD_DATE
,ycoord.x as X
,ycoord.y as Y
,cast( 26917 as int ) as EPSG_CODE
,ycoord.east83 as X_OUOM
,ycoord.north83 as Y_OUOM
,cast( ( case when ycoord.zone=17 then 26917 else 26918 end ) as int ) as EPSG_CODE_OUOM
,dlqa.qa_coord_confidence_code as QA_COORD_CODE
,cast( 529 as int ) as LOC_COORD_DATA_ID
,cast( ( case when m.location_method is not null and len(m.location_method)>0 then m.location_method else null end ) as varchar(255) ) as LOC_COORD_METHOD
--,cast( ( case when ye.dem_mnr=-9999 then 5 else 3 end ) as int ) as LOC_ELEV_CODE
,3 as LOC_ELEV_CODE
,cast( '2026-08-13' as datetime ) as LOC_ELEV_DATE
--,cast( ( case when ye.dem_mnr=-9999 then ye.dem_srtm else ye.dem_mnr end ) as float ) as LOC_ELEV
,ye.dem_mnr as LOC_ELEV
,cast( 6 as int ) as LOC_ELEV_UNIT_CODE
--,cast( ( case when ye.dem_mnr=-9999 then ye.dem_srtm else ye.dem_mnr end ) as float ) as LOC_ELEV_OUOM
,ye.dem_mnr as LOC_ELEV_OUOm
,cast( 'masl' as varchar(50) ) as LOC_ELEV_UNIT_OUOM
,cast( 10 as int ) as QA_ELEV_CODE
,cast( null as int ) as LOC_ELEV_DATA_ID
,cast( null as varchar(255) ) as LOC_ELEV_COMMENT
from 
MOE_20260813.dbo.YC_20260813_BH_ID as y
inner join MOE_20260813.dbo.YC_20260813_BORE_HOLE_ID_ELEVS as ye
on y.bore_hole_id=ye.bore_hole_id
inner join MOE_20260813.dbo.TblBore_Hole as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
inner join MOE_20260813.dbo.YC_20260813_BORE_HOLE_ID_COORDS_YC as ycoord
on y.bore_hole_id=ycoord.bore_hole_id
inner join MOE_20260813.dbo.M_D_LOCATION_QA as dlqa
on y.bore_hole_id=dlqa.loc_id


--insert into MOE_20260813.dbo.M_D_LOCATION_SPATIAL_HIST
--(
--LOC_ID
--,LOC_COORD_HIST_CODE
--,LOC_COORD_DATE
--,X
--,Y
--,EPSG_CODE
--,X_OUOM
--,Y_OUOM
--,EPSG_CODE_OUOM
--,QA_COORD_CODE
--,LOC_COORD_DATA_ID
--,LOC_COORD_METHOD
--,LOC_ELEV_CODE
--,LOC_ELEV_DATE
--,LOC_ELEV
--,LOC_ELEV_UNIT_CODE
--,LOC_ELEV_OUOM
--,LOC_ELEV_UNIT_OUOM
--,QA_ELEV_CODE
--,LOC_ELEV_DATA_ID
--,LOC_ELEV_COMMENT
--)
select
y.BORE_HOLE_ID as LOC_ID
,cast(4 as int) as LOC_COORD_HIST_CODE
,cast( '2026-08-13' as datetime ) as LOC_COORD_DATE
,ycoord.x as X
,ycoord.y as Y
,cast( 26917 as int ) as EPSG_CODE
,ycoord.east83 as X_OUOM
,ycoord.north83 as Y_OUOM
,cast( ( case when ycoord.zone=17 then 26917 else 26918 end ) as int ) as EPSG_CODE_OUOM
,dlqa.qa_coord_confidence_code as QA_COORD_CODE
,cast( 529 as int ) as LOC_COORD_DATA_ID
,cast( ( case when m.location_method is not null and len(m.location_method)>0 then m.location_method else null end ) as varchar(255) ) as LOC_COORD_METHOD
--,cast( ( case when ye.dem_mnr=-9999 then 5 else 3 end ) as int ) as LOC_ELEV_CODE
,3 as LOC_ELEV_CODE
,cast( '2026-08-13' as datetime ) as LOC_ELEV_DATE
--,cast( ( case when ye.dem_mnr=-9999 then ye.dem_srtm else ye.dem_mnr end ) as float ) as LOC_ELEV
,ye.dem_mnr as LOC_ELEV
,cast( 6 as int ) as LOC_ELEV_UNIT_CODE
--,cast( ( case when ye.dem_mnr=-9999 then ye.dem_srtm else ye.dem_mnr end ) as float ) as LOC_ELEV_OUOM
,ye.dem_mnr as LOC_ELEV_OUOm
,cast( 'masl' as varchar(50) ) as LOC_ELEV_UNIT_OUOM
,cast( 10 as int ) as QA_ELEV_CODE
,cast( null as int ) as LOC_ELEV_DATA_ID
,cast( null as varchar(255) ) as LOC_ELEV_COMMENT
into MOE_20260813.dbo.M_D_LOCATION_SPATIAL_HIST
from 
MOE_20260813.dbo.YC_20260813_BH_ID as y
inner join MOE_20260813.dbo.YC_20260813_BORE_HOLE_ID_ELEVS as ye
on y.bore_hole_id=ye.bore_hole_id
inner join MOE_20260813.dbo.TblBore_Hole as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
inner join MOE_20260813.dbo.YC_20260813_BORE_HOLE_ID_COORDS_YC as ycoord
on y.bore_hole_id=ycoord.bore_hole_id
inner join MOE_20260813.dbo.M_D_LOCATION_QA as dlqa
on y.bore_hole_id=dlqa.loc_id


-- If there were any elevations using the SRTM values, change the affected '3' elevation codes to '5'; refer to
-- the code after the counts  


-- How many original
-- v20230324 18826 (null)
-- v20230324 0 (2)
-- v20240326 0
-- v20250711 0
-- v20260813 0

select count(*) from MOE_20260813.dbo.M_D_LOCATION_SPATIAL_HIST where loc_coord_hist_code= 4 and ( loc_elev_code= 2 ) -- or loc_elev_code is null )

-- How many MNR or SRTM
-- v20230324 18826
-- v20240326 23131 
-- v20250711 18379
-- v20260813 129172

select count(*) from MOE_20260813.dbo.M_D_LOCATION_SPATIAL_HIST where loc_coord_hist_code= 4 and loc_elev_code in ( 3, 5 )

-- v20210119 49238 rows
-- v20220328 30470 rows
-- v20230324 37652 rows
-- v20240326 46262 rows
-- v20250711 36758 rows
-- v20260813 129172 rows

select
count(*) 
from 
MOE_20260813.dbo.M_D_LOCATION_SPATIAL_HIST

-- Note that D_LOCATION_SPATIAL will be created at a later step



--***** 20250711

-- following were updated (from -9999) 

-- 1009601791,539269,4804951	369
-- 1009514880,539085,4814041	320
-- 1009514877,539074,4814053	320
-- 1009514874,539057,4814045	320

select
*
from 
MOE_20260813.dbo.M_D_LOCATION_SPATIAL_HIST
where
loc_id in 
(
1009601791
,1009514880
,1009514877
,1009514874
)
and loc_elev_code= 3

update MOE_20260813.dbo.M_D_LOCATION_SPATIAL_HIST
set
loc_elev_code= 5
where
loc_id in 
(
1009601791
,1009514880
,1009514877
,1009514874
)
and loc_elev_code= 3


