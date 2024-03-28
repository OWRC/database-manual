
--***** G_10_15_08

--***** The final step is to add the remaining locations/intervals; these will
--***** be given a 'screen information omitted' tag

-- these will be the ones not in YC_20160531_DINTMON and will not have a valid
-- maximum depth

-- 2017.09.05 4024 rows
-- 2018.05.30 1603 rows
-- v20190509 4421 rows
-- v20200721 1941 rows
-- v20210119 4146 rows
-- v20220328 9095 rows
-- v20230324 12394 rows
-- v20240326 14700 rows

select 
ycb.BORE_HOLE_ID as tmp_LOC_ID
,28 as tmp_INT_TYPE_CODE
,'no valid screen determined' as MON_COMMENT
from 
MOE_20240326.dbo.YC_20240326_BH_ID as ycb
where 
ycb.BORE_HOLE_ID 
not in
( select tmp_LOC_ID from MOE_20240326.dbo.YC_20240326_DINTMON )
and ycb.MAX_DEPTH_M is null

-- note that we're going to put these in YC_20160531_DINTMON temporarily
-- as placeholders for the final M_D_INTERVAL table; they should not be moved
-- across to the M_D_INTERVAL_MONITOR table

insert into MOE_20240326.dbo.YC_20240326_DINTMON
(TMP_LOC_ID,TMP_INT_TYPE_CODE,MON_COMMENT)
select 
ycb.BORE_HOLE_ID as tmp_LOC_ID
,28 as tmp_INT_TYPE_CODE
,'no valid screen determined' as MON_COMMENT
from 
MOE_20240326.dbo.YC_20240326_BH_ID as ycb
where 
ycb.BORE_HOLE_ID 
not in
( select tmp_LOC_ID from MOE_20240326.dbo.YC_20240326_DINTMON )
and ycb.MAX_DEPTH_M is null

--***** 20200731

select
*
from 
MOE_20240326.dbo.YC_20240326_DINTMON
where 
tmp_int_type_code= 28

