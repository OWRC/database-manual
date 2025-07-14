
--***** G_10_02_01

--***** create a table containing the various keys we'll use for boreholes with
--***** geology information

select
 y.BORE_HOLE_ID
,y.WELL_ID
,ROW_NUMBER() over (order by y.BORE_HOLE_ID) as [bore_hold_id_rnum]
,cast(null as int) as [LOC_ID]
,cast(null as int) as [BH_ID]
,convert(int,1) as [LOC_MASTER_LOC_ID]
,convert(float,null) as [FM_MAX_DEPTH]
,convert(varchar(50),null) as [FM_MAX_DEPTH_UNITS]
,convert(float,null) as [MOE_MAX_DEPTH]
,convert(varchar(50),null) as [MOE_MAX_DEPTH_UNITS]
,convert(float,null) as [CON_MAX_DEPTH]
,convert(varchar(50),null) as [CON_MAX_DEPTH_UNITS]
,convert(float,null) as [MAX_DEPTH_M]
,cast(null as int) as NOFORMATION
from 
MOE_20250711.dbo.YC_20250711_BORE_HOLE_ID_COORDS_YC as y

select
 y.BORE_HOLE_ID
,y.WELL_ID
,ROW_NUMBER() over (order by y.BORE_HOLE_ID) as [bore_hold_id_rnum]
,cast(null as int) as [LOC_ID]
,cast(null as int) as [BH_ID]
,convert(int,1) as [LOC_MASTER_LOC_ID]
,convert(float,null) as [FM_MAX_DEPTH]
,convert(varchar(50),null) as [FM_MAX_DEPTH_UNITS]
,convert(float,null) as [MOE_MAX_DEPTH]
,convert(varchar(50),null) as [MOE_MAX_DEPTH_UNITS]
,convert(float,null) as [CON_MAX_DEPTH]
,convert(varchar(50),null) as [CON_MAX_DEPTH_UNITS]
,convert(float,null) as [MAX_DEPTH_M]
,cast(null as int) as NOFORMATION
into MOE_20250711.dbo.YC_20250711_BH_ID
from 
MOE_20250711.dbo.YC_20250711_BORE_HOLE_ID_COORDS_YC as y

-- v20200721 11760 rows
-- v20210119 24619 rows
-- v20220328 15235 rows
-- v20230324 18826 rows
-- v20240326 23131 rows
-- v20250711 18379 rows

select
count(*)
from 
MOE_20250711.dbo.YC_20250711_BH_ID





