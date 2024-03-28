
--***** G_10_01_04

--***** Get a list of WELL_IDs that occur within the YPDT-CAMC study area

-- v20180530 15104 WELL_IDs
-- v20190509 11848 WELL_IDs
-- v20200721 11757 WELL_IDs
-- v20210119 23974 WELL_IDs
-- v20220328 15216 WELL_IDs
-- v20230324 18826 WELL_IDs
-- v20240326 23131 WELL_IDs

select
count(*) as rnum
from 
(

select
WELL_ID
,cast(null as int) as well_id_rnum
from 
MOE_20240326.dbo.YC_20240326_BORE_HOLE_ID_COORDS_YC as y
group by
WELL_ID

) as t

select
WELL_ID
,cast(null as int) as well_id_rnum
into MOE_20240326.dbo.YC_20240326_YPDT_WELL_ID
from 
MOE_20240326.dbo.YC_20240326_BORE_HOLE_ID_COORDS_YC as y
group by
WELL_ID

--***** check the sizes of the tables

-- v20180530 15104 WELL_IDs
-- v20190509 11848 WELL_IDs
-- v20200721 11757 WELL_IDs
-- v20210119 23974 WELL_IDs
-- v20220328 15216 WELL_IDs
-- v20230324 18826 WELL_IDs
-- v20240326 23131 WELL_IDs

select
count(*) 
from 
MOE_20240326.dbo.YC_20240326_YPDT_WELL_ID

-- v20180530 15578 BORE_HOLE_IDs
-- v20190509 11851 BORE_HOLE_IDs
-- v20200721 11760 BORE_HOLE_IDs
-- v20210119 24619 BORE_HOLE_IDs; note the number differences (to WELL_IDs above); likely due to expansion into Halton region
-- v20220328 15235 BORE_HOLE_IDs
-- v20230324 18826 BORE_HOLE_IDs; no multiple BORE_HOLE_IDs for a WELL_ID
-- v20240326 23131 BORE_HOLE_IDs; no multiple BORE_HOLE_IDs for a WELL_ID

select
count(*) 
from
MOE_20240326.dbo.YC_20240326_BORE_HOLE_ID_COORDS_YC



