
--***** G_10_08_01

--***** extract D_LOCATION_ELEV equivalent

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

select
dlqa.*
from 
MOE_20250711.dbo.M_D_LOCATION_QA as dlqa
where 
QA_ELEV_CONFIDENCE_CODE=1
or QA_COORD_CONFIDENCE_CODE=1

-- populate D_LOCATION_SPATIAL_HIST with the original coordinates and elevations

-- update LOC_COORD_DATE, LOC_COORD_DATA_ID, LOC_ELEV_DATE, LOC_ELEV_DATA_ID

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
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y
inner join MOE_20250711.dbo.TblBore_Hole as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
inner join MOE_20250711.dbo.YC_20250711_BORE_HOLE_ID_COORDS_YC as ycoord
on y.bore_hole_id=ycoord.bore_hole_id
inner join MOE_20250711.dbo.M_D_LOCATION_QA as dlqa
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
into MOE_20250711.dbo.M_D_LOCATION_SPATIAL_HIST
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y
inner join MOE_20250711.dbo.TblBore_Hole as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
inner join MOE_20250711.dbo.YC_20250711_BORE_HOLE_ID_COORDS_YC as ycoord
on y.bore_hole_id=ycoord.bore_hole_id
inner join MOE_20250711.dbo.M_D_LOCATION_QA as dlqa
on y.bore_hole_id=dlqa.loc_id

-- populate D_LOCATION_SPATIAL_HIST with the DEM elevations

--***** 20230324
--***** disabled SRTM population

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
--,cast( ( case when ye.dem_mnr=-9999 then 5 else 3 end ) as int ) as LOC_ELEV_CODE
,3 as LOC_ELEV_CODE
,cast( '2025-07-11' as datetime ) as LOC_ELEV_DATE
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
MOE_20250711.dbo.YC_20250711_BH_ID as y
inner join MOE_20250711.dbo.YC_20250711_BORE_HOLE_ID_ELEVS as ye
on y.bore_hole_id=ye.bore_hole_id
inner join MOE_20250711.dbo.TblBore_Hole as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
inner join MOE_20250711.dbo.YC_20250711_BORE_HOLE_ID_COORDS_YC as ycoord
on y.bore_hole_id=ycoord.bore_hole_id
inner join MOE_20250711.dbo.M_D_LOCATION_QA as dlqa
on y.bore_hole_id=dlqa.loc_id


insert into MOE_20250711.dbo.M_D_LOCATION_SPATIAL_HIST
(
LOC_ID
,LOC_COORD_HIST_CODE
,LOC_COORD_DATE
,X
,Y
,EPSG_CODE
,X_OUOM
,Y_OUOM
,EPSG_CODE_OUOM
,QA_COORD_CODE
,LOC_COORD_DATA_ID
,LOC_COORD_METHOD
,LOC_ELEV_CODE
,LOC_ELEV_DATE
,LOC_ELEV
,LOC_ELEV_UNIT_CODE
,LOC_ELEV_OUOM
,LOC_ELEV_UNIT_OUOM
,QA_ELEV_CODE
,LOC_ELEV_DATA_ID
,LOC_ELEV_COMMENT
)
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
--,cast( ( case when ye.dem_mnr=-9999 then 5 else 3 end ) as int ) as LOC_ELEV_CODE
,3 as LOC_ELEV_CODE
,cast( '2025-07-11' as datetime ) as LOC_ELEV_DATE
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
MOE_20250711.dbo.YC_20250711_BH_ID as y
inner join MOE_20250711.dbo.YC_20250711_BORE_HOLE_ID_ELEVS as ye
on y.bore_hole_id=ye.bore_hole_id
inner join MOE_20250711.dbo.TblBore_Hole as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
inner join MOE_20250711.dbo.YC_20250711_BORE_HOLE_ID_COORDS_YC as ycoord
on y.bore_hole_id=ycoord.bore_hole_id
inner join MOE_20250711.dbo.M_D_LOCATION_QA as dlqa
on y.bore_hole_id=dlqa.loc_id


-- If there were any elevations using the SRTM values, change the affected '3' elevation codes to '5'; refer to
-- the code after the counts  


-- How many original
-- v20230324 18826 (null)
-- v20230324 0 (2)
-- v20240326 0
-- v20250711 0

select count(*) from MOE_20250711.dbo.M_D_LOCATION_SPATIAL_HIST where loc_coord_hist_code= 4 and ( loc_elev_code= 2 ) -- or loc_elev_code is null )

-- How many MNR or SRTM
-- v20230324 18826
-- v20240326 23131 
-- v20250711 18379

select count(*) from MOE_20250711.dbo.M_D_LOCATION_SPATIAL_HIST where loc_coord_hist_code= 4 and loc_elev_code in ( 3, 5 )

-- v20210119 49238 rows
-- v20220328 30470 rows
-- v20230324 37652 rows
-- v20240326 46262 rows
-- v20250711 36758 rows

select
count(*) 
from 
MOE_20250711.dbo.M_D_LOCATION_SPATIAL_HIST

-- Note that D_LOCAITON_SPATIAL will be created at a later step



--***** 20250711

-- following were updated (from -9999) 

-- 1009601791,539269,4804951	369
-- 1009514880,539085,4814041	320
-- 1009514877,539074,4814053	320
-- 1009514874,539057,4814045	320

select
*
from 
MOE_20250711.dbo.M_D_LOCATION_SPATIAL_HIST
where
loc_id in 
(
1009601791
,1009514880
,1009514877
,1009514874
)
and loc_elev_code= 3

update MOE_20250711.dbo.M_D_LOCATION_SPATIAL_HIST
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


--***** v20210119
--***** The following scripts were used for populating the old D_LOCATION_ELEV_HIST table
--**** now disparaged

-- populate the D_LOCATION_ELEV_HIST

-- Original Elevations; LOC_ELEV_CODE 2

-- v20200721 0 original elevations (create an empty table)

select
y.BORE_HOLE_ID as LOC_ID
,ROW_NUMBER() over (order by y.BORE_HOLE_ID) as LOC_ELEV_ID
,cast(2 as int) as LOC_ELEV_CODE
,cast(m.ELEVATION as float) as LOC_ELEV_MASL
-- we'll use SYS_TEMP2 to note which rows is the assigned elevation
,cast(null as int) as SYS_TEMP2
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y
inner join MOE_20250711.dbo.TblBore_Hole as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
--where 
--m.ELEVATION is not null

select
y.BORE_HOLE_ID as LOC_ID
,ROW_NUMBER() over (order by y.BORE_HOLE_ID) as LOC_ELEV_ID
,cast(2 as int) as LOC_ELEV_CODE
,cast(m.ELEVATION as float) as LOC_ELEV_MASL
-- we'll use SYS_TEMP2 to note which rows is the assigned elevation
,cast(null as int) as SYS_TEMP2
into MOE_20250711.dbo.M_D_LOCATION_ELEV_HIST
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y
inner join MOE_20250711.dbo.TblBore_Hole as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
where 
m.ELEVATION is not null

-- DEM MNR v2; LOC_ELEV_CODE 3

-- find the largest LOC_ELEV_ID

select 
max(LOC_ELEV_ID) 
from 
MOE_20250711.dbo.M_D_LOCATION_ELEV_HIST

-- v20170905 17151 max
-- v20180530 15487 max
-- v20190509 3403 max
-- v20200721 null value

-- use this number to insert additional IDs into the table

-- v20200721 11759 rows

select
y.BORE_HOLE_ID as LOC_ID
,0 + ROW_NUMBER() over (order by y.BORE_HOLE_ID) as LOC_ELEV_ID
,cast(3 as int) as LOC_ELEV_CODE
,e.DEM_MNR as LOC_ELEV_MASL
-- we'll use SYS_TEMP2 to note which rows is the assigned elevation
,cast(1 as int) as SYS_TEMP2
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y
inner join MOE_20250711.dbo.YC_20250711_BORE_HOLE_ID_ELEVS as e
on y.BORE_HOLE_ID=e.BORE_HOLE_ID
where
e.DEM_MNR <> -9999

insert into MOE_20250711.dbo.M_D_LOCATION_ELEV_HIST
(LOC_ID,LOC_ELEV_ID,LOC_ELEV_CODE,LOC_ELEV_MASL,SYS_TEMP2)
select
y.BORE_HOLE_ID as LOC_ID
,3403 + ROW_NUMBER() over (order by y.BORE_HOLE_ID) as LOC_ELEV_ID
,cast(3 as int) as LOC_ELEV_CODE
,e.DEM_MNR as LOC_ELEV_MASL
-- we'll use SYS_TEMP2 to note which rows is the assigned elevation
,cast(1 as int) as SYS_TEMP2
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y
inner join MOE_20250711.dbo.YC_20250711_BORE_HOLE_ID_ELEVS as e
on y.BORE_HOLE_ID=e.BORE_HOLE_ID
where
e.DEM_MNR <> -9999

-- DEM SRTM v4.1; LOC_ELEV_CODE 5

-- find the largest LOC_ELEV_ID

select 
max(LOC_ELEV_ID) 
from 
MOE_20250711.dbo.M_D_LOCATION_ELEV_HIST

-- v20170905 34336 max
-- v20180530 31062 max
-- v20190509 15253 max
-- v20200721 15162 max

-- use this number to insert additional IDs into the table

-- v20200721 11610 rows

select
y.BORE_HOLE_ID as LOC_ID
,15162 + ROW_NUMBER() over (order by y.BORE_HOLE_ID) as LOC_ELEV_ID
,cast(5 as int) as LOC_ELEV_CODE
,e.DEM_SRTM as LOC_ELEV_MASL
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y
inner join MOE_20250711.dbo.YC_20250711_BORE_HOLE_ID_ELEVS as e
on y.BORE_HOLE_ID=e.BORE_HOLE_ID
where 
e.DEM_SRTM <> -9999

insert into MOE_20250711.dbo.M_D_LOCATION_ELEV_HIST
(LOC_ID,LOC_ELEV_ID,LOC_ELEV_CODE,LOC_ELEV_MASL)
select
y.BORE_HOLE_ID as LOC_ID
,15253 + ROW_NUMBER() over (order by y.BORE_HOLE_ID) as LOC_ELEV_ID
,cast(5 as int) as LOC_ELEV_CODE
,e.DEM_SRTM as LOC_ELEV_MASL
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y
inner join MOE_20250711.dbo.YC_20250711_BORE_HOLE_ID_ELEVS as e
on y.BORE_HOLE_ID=e.BORE_HOLE_ID
where 
e.DEM_SRTM <> -9999

-- check whether the SRTM DEM value should be considered the assigned elevation

-- v20200721 1 row

select
*
from 
MOE_20250711.dbo.M_D_LOCATION_ELEV_HIST as dleh
left outer join
(
select
loc_id
,sys_temp2
from
MOE_20250711.dbo.M_D_LOCATION_ELEV_HIST
where
sys_temp2=1
) as t
on dleh.loc_id=t.loc_id
where 
dleh.loc_elev_code=5
and t.sys_temp2 is null

update MOE_20250711.dbo.M_D_LOCATION_ELEV_HIST
set
sys_temp2= 1
from 
MOE_20250711.dbo.M_D_LOCATION_ELEV_HIST as dleh
left outer join
(
select
loc_id
,sys_temp2
from
MOE_20250711.dbo.M_D_LOCATION_ELEV_HIST
where
sys_temp2=1
) as t
on dleh.loc_id=t.loc_id
where 
dleh.loc_elev_code=5
and t.sys_temp2 is null

-- v20180530 15578 rows 
-- v20190509 11851 rows
-- v20200721 11760 rows

select
count(*) 
from 
MOE_20250711.dbo.M_D_LOCATION_ELEV_HIST as m
where 
m.sys_temp2=1

-- create D_LOCATION_ELEV containing the ASSIGNED_ELEV

-- as of 20200730, the tables D_LOCATION_SPATIAL and D_LOCATION_SPATIAL_HIST are
-- being used to track coordinate and elevation changes; at this point, we will 
-- create the old D_LOCATION_ELEV and D_LOCATION_ELEV_HIST tables (as the former
-- is used for some field updates) but then use these for creating the updated
-- tables; sometime in the future, this methodology should be updated

select
LOC_ID
,LOC_ELEV_ID
,LOC_ELEV_MASL as ASSIGNED_ELEV
from 
MOE_20250711.dbo.M_D_LOCATION_ELEV_HIST
where 
SYS_TEMP2=1

select
LOC_ID
,LOC_ELEV_ID
,LOC_ELEV_MASL as ASSIGNED_ELEV
into MOE_20250711.dbo.M_D_LOCATION_ELEV
from 
MOE_20250711.dbo.M_D_LOCATION_ELEV_HIST
where 
SYS_TEMP2=1

--drop table m_d_location_elev

-- v20170905
-- loc_elev_code 2 17151 rows (Original)
--               3 17185 rows (MNR)
--               5 17185 rows (SRTM)
-- v20180530
-- loc_elev_code 2 15487
--               3 15575 rows
--               5 15578 rows
-- v20190509
-- loc_elev_code 2 3403
--               3 11850 rows
--               5 11727 rows

-- v20200721
-- loc_elev-code 2 0
--               3 11759
--               5 11610

select
count(*)
from 
MOE_20250711.dbo.m_d_location_elev_hist
where 
--loc_elev_code= 5
--loc_elev_code= 3
loc_elev_code= 2

-- v20170905 17185 rows 
-- v20180530 15578 rows
-- v20190509 11851 rows
-- v20200721 11760 rows
 
select
count(*) 
from 
MOE_20250711.dbo.M_D_LOCATION_ELEV

-- v20200721 23369 rows

select
count(*) 
from 
MOE_20250711.dbo.M_D_LOCATION_ELEV_HIST





