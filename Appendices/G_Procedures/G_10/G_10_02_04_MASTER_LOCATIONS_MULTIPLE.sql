
--***** G_10_02_04

--***** assign the smallest BORE_HOLE_ID to the remainder; this can be
--***** modified at a later date, as necessary

-- this is the base query

--select
--y.*
--from 
--[MOE_20160531].dbo.YC_20160531_BH_ID as y
--where 
--y.LOC_MASTER_LOC_ID is null 

-- get the small BORE_HOLE_ID

-- v20180530 58 rows
-- v20190509 0 rows?
-- v20210119 149 rows
-- v20220328 0 rows
-- v20230324 0 rows
-- v20240326 0 rows

select
t.BORE_HOLE_ID
,y.*
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
inner join
(
select
y.WELL_ID
,min(BORE_HOLE_ID) as BORE_HOLE_ID
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
where 
y.LOC_MASTER_LOC_ID is null 
group by
y.WELL_ID
) as t
on y.WELL_ID=t.WELL_ID


update MOE_20240326.dbo.YC_20240326_BH_ID
set
LOC_MASTER_LOC_ID=t.BORE_HOLE_ID
,NOFORMATION=1
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
inner join
(
select
y.WELL_ID
,min(BORE_HOLE_ID) as BORE_HOLE_ID
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
where 
y.LOC_MASTER_LOC_ID is null 
group by
y.WELL_ID
) as t
on y.WELL_ID=t.WELL_ID

-- v20210119 0 rows returned (all compensated for)
-- v20240326 0 rows returned (all compensated for)

select
*
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
where 
loc_master_loc_id is null


