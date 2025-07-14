
--***** G_10_15_04

--***** open hole without casing or without valid casing

-- NOTE: as of 20140305, some of these checks no longer work as we've only,
-- in many cases, extracted those bhs with valid coordinates (i.e. the 
-- results have already been filtered)

-- total number of screens built from open hole with casing (1)

--select
--COUNT(*) 
--from 
--MOE_20250711.dbo.YC_20250711_DINTMON as ycdim
--where
--ycdim.tmp_INT_TYPE_CODE=21

-- this returns 1 record of 'open hole' intervals with casing; how many
-- 'total open hole' records are there (not already in the YC database)

-- 2017.09.05 0 rows
-- 2018.05.30 18 rows; this was handled in the previous step
-- v20190509 0 rows
-- v20200721 0 rows
-- v20210119 7 rows
-- v20220328 0 rows
-- v20230324 0 rows
-- v20240326 0 rows
-- v20250711 0 rows

select
COUNT(*) 
from 
MOE_20250711.dbo.YC_20250711_BH_ID as ycb
inner join MOE_20250711.dbo.TblBore_Hole as moebh
on ycb.BORE_HOLE_ID=moebh.BORE_HOLE_ID
where 
moebh.OPEN_HOLE='Y'

select
ycb.*
from 
MOE_20250711.dbo.YC_20250711_BH_ID as ycb
inner join MOE_20250711.dbo.TblBore_Hole as moebh
on ycb.BORE_HOLE_ID=moebh.BORE_HOLE_ID
where 
moebh.OPEN_HOLE='Y'

-- there is 1; how many open hole without casing

-- 2017.09.05 0 rows returned
-- 2018.05.30 
-- v20190509 0 rows returned
-- v20200721 0 rows 
-- v20210119 0 rows
-- v20220328 0 rows
-- v20230324 0 rows
-- v20240326 0 rows
-- v20250711 0 rows

select 
ycb.BORE_HOLE_ID as tmp_LOC_ID
,20 as tmp_INT_TYPE_CODE
,0 as MON_TOP_OUOM
,ycb.MAX_DEPTH_M as MON_BOT_OUOM
,'m' as MON_UNIT_OUOM
,'open hole; no valid casing' as MON_COMMENT
from 
MOE_20250711.dbo.YC_20250711_BH_ID as ycb
inner join MOE_20250711.dbo.TblBore_Hole as moebh
on ycb.BORE_HOLE_ID=moebh.BORE_HOLE_ID
inner join MOE_20250711.dbo.M_D_BOREHOLE_CONSTRUCTION as ycbc
on ycb.BORE_HOLE_ID=ycbc.BH_ID
where 
moebh.OPEN_HOLE='Y'
and ycb.BORE_HOLE_ID
not in
(
select tmp_LOC_ID from MOE_20250711.dbo.YC_20250711_DINTMON
)

-- there is no 'open hole' records without casing

--select 
--ycb.LOC_ID as tmp_LOC_ID
--,20 as tmp_INT_TYPE_CODE
--,0 as MON_TOP_OUOM
--,ycb.MAX_DEPTH_M as MON_BOT_OUOM
--,'m' as MON_UNIT_OUOM
--,'open hole; no valid casing' as MON_COMMENT
--from 
--[MOE_201304].dbo.YC_20130923_BHID as ycb
--inner join 
--[MOE_201304].dbo.YC_20130923_COORDS as ycc
--on
--ycb.LOC_ID=ycc.LOC_ID
--inner join 
--[MOE_201304].dbo.TblBore_Hole as moebh
--on
--ycb.BORE_HOLE_ID=moebh.BORE_HOLE_ID
----inner join 
----[MOE_201304].dbo.fm_D_BOREHOLE_CONSTRUCTION as ycbc
----on
----ycb.BH_ID=ycbc.BH_ID
--where 
--moebh.OPEN_HOLE='Y'
--and ycb.LOC_ID
--not in
--(
--select tmp_LOC_ID from [MOE_201304].dbo.YC_20130923_DINTMON
--)

-- none, there are no 'open hole' records with invalid or no casing within the YC area
-- that are not already in the YC database; if there were any, these would have
-- corresponded to a value of '20' from the R_INT_TYPE_CODE table


-- Checks

select
*
from 
MOE_20250711.dbo.YC_20250711_DINTMON as y
where 
tmp_int_type_code= 21



