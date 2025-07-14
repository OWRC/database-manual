
--***** G_10_14_05

--***** Determine the maximum depth of the bh from geology

-- v20180530 10760 rows
-- v20190509 5670 rows
-- v20200721 7669 rows
-- v20210119 15257 rows
-- v20220328 4383 rows
-- v20230324 4831 rows
-- v20240326 6382 rows
-- v20250711 4788 rows

select 
BORE_HOLE_ID
,max(FORMATION_END_DEPTH) as [FM_MAX_DEPTH]
,FORMATION_END_DEPTH_UOM as [FM_MAX_DEPTH_UNITS]
from 
MOE_20250711.[dbo].[TblFormation]
where 
BORE_HOLE_ID 
in
(
select 
BORE_HOLE_ID 
from 
MOE_20250711.dbo.YC_20250711_BH_ID as ycb
)
and 
FORMATION_END_DEPTH is not null
group by
BORE_HOLE_ID,FORMATION_END_DEPTH_UOM

-- check that multiple units haven't been specified for depths

-- v20170905 1 row returned
-- v20180530 0 rows returned
-- v20190509 0 rows returned
-- v20200721 
-- v20210119 0 rows
-- v20220328 0 rows
-- v20230324 0 rows
-- v20240327 0 rows
-- v20250711 0 rows

select
t2.BORE_HOLE_ID
,t2.rcount
from 
(
select
t1.BORE_HOLE_ID
,COUNT(*) as rcount
from 
(
select 
BORE_HOLE_ID
,max(FORMATION_END_DEPTH) as [FM_MAX_DEPTH]
,FORMATION_END_DEPTH_UOM as [FM_MAX_DEPTH_UNITS]
from 
MOE_20250711.[dbo].[TblFormation]
where 
BORE_HOLE_ID 
in
(
select 
BORE_HOLE_ID 
from 
MOE_20250711.dbo.YC_20250711_BH_ID as ycb
)
and FORMATION_END_DEPTH is not null
group by
BORE_HOLE_ID,FORMATION_END_DEPTH_UOM
) as t1
group by
t1.BORE_HOLE_ID
) as t2
where
t2.rcount>1

-- update the fields

-- v20170905 1 BORE_HOLE_ID with varying units in TblFormation
-- v20190509 0 rows returned
-- v20200721 1 row

select
*
from 
MOE_20250711.dbo.TblFormation
where 
bore_hole_id= 1007362933

update MOE_20250711.dbo.TblFormation
set
formation_end_depth_uom='ft'
where
formation_id= 1007799730

-- v20170905 9402 rows
-- v20180530 10760 rows
-- v20190509 5670 rows
-- v20200721 7698 rows
-- v20210119 15257 rows
-- v20220328 4383 rows
-- v20230324 4831 rows
-- v20240326 6382 rows
-- v20250711 4788 rows

update MOE_20250711.dbo.YC_20250711_BH_ID 
set
fm_max_depth=fm_depth.FM_MAX_DEPTH
,fm_max_depth_units=fm_depth.FM_MAX_DEPTH_UNITS
from 
MOE_20250711.dbo.YC_20250711_BH_ID as ycb
inner join
(
select 
BORE_HOLE_ID
,max(FORMATION_END_DEPTH) as [FM_MAX_DEPTH]
,FORMATION_END_DEPTH_UOM as [FM_MAX_DEPTH_UNITS]
from 
MOE_20250711.[dbo].[TblFormation]
where 
BORE_HOLE_ID 
in
(
select 
BORE_HOLE_ID 
from 
MOE_20250711.dbo.YC_20250711_BH_ID as ycb
)
and FORMATION_END_DEPTH is not null
group by
BORE_HOLE_ID,FORMATION_END_DEPTH_UOM
) as fm_depth
on ycb.BORE_HOLE_ID=fm_depth.BORE_HOLE_ID


