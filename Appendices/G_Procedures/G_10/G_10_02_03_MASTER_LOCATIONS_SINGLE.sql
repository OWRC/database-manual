
--***** G_10_02_03

--***** find those locations that exist only of a single BORE_HOLE_ID;
--***** the BORE_HOLE_ID can be used as the master identifier

-- check to make sure that none of these non-formation 'single' WELL_IDs match against
-- the formation WELL_IDs; no rows should be returned

-- v20190509 0 rows returned
-- v20200721 0 rows returned
-- v20210119 18 rows returned
-- v20220328 0 rows returned
-- v20230324 0 rows returned
-- v20240326 0 rows returned

select
t2.WELL_ID
,t3.WELL_ID
from 
(
select
t.WELL_ID
,t.rcount
from 
(
select
y.WELL_ID
,count(*) as rcount
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
where 
LOC_MASTER_LOC_ID is null
group by
y.WELL_ID
) as t
where 
t.rcount=1
) as t2
inner join
(
select
y.WELL_ID
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
where 
y.BORE_HOLE_ID=y.LOC_MASTER_LOC_ID
group by
y.WELL_ID
) as t3
on
t2.WELL_ID=t3.WELL_ID

-- following is from v20180530

select
*
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
where 
well_id= 7148046      

-- if any locations are returned, assign the LOC_MASTER_LOC_ID determined to the
-- null value

-- v20190509 0 rows returned 
-- v20200721 0 rows returned
-- v20210119 525 rows returned
-- v20220328 19 rows returned
-- v20230324 0 rows returned
-- v20240326 0 rows returned

select
y.WELL_ID
,t.WELL_ID
,t.BORE_HOLE_ID as MASTER_BORE_HOLE_ID
,y.BORE_HOLE_ID
,t.LOC_MASTER_LOC_ID AS MASTER_LOC_MASTER_LOC_ID
,y.LOC_MASTER_LOC_ID
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
inner join 
(
select
y.WELL_ID
,y.BORE_HOLE_ID
,y.LOC_MASTER_LOC_ID
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
where 
y.loc_master_loc_id=y.bore_hole_ID
) as t
on y.well_id=t.well_id
where 
y.loc_master_loc_id is null

update MOE_20240326.dbo.YC_20240326_BH_ID
set
LOC_MASTER_LOC_ID= t.LOC_MASTER_LOC_ID
,NOFORMATION=1
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
inner join 
(
select
y.WELL_ID
,y.BORE_HOLE_ID
,y.LOC_MASTER_LOC_ID
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
where 
y.loc_master_loc_id=y.bore_hole_ID
) as t
on y.well_id=t.well_id
where 
y.loc_master_loc_id is null

-- v20200721 0 rows returned
-- v20210119 525 rows returned
-- v20220328 19 rows returned
-- v20230324 0 rows returned
-- v20240326 0 rows returned

select
*
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
where 
y.BORE_HOLE_ID<>y.LOC_MASTER_LOC_ID

update MOE_20240326.dbo.YC_20240326_BH_ID
set
NOFORMATION=1
where 
BORE_HOLE_ID<>LOC_MASTER_LOC_ID

-- assign the single WELL_ID, non-formation BORE_HOLE_IDs to
-- LOC_MASTER_LOC_ID; tag NOFORMATION with a 1 for any later
-- checks

-- v20190509 3957 rows updated
-- v20200721 3618 rows updated
-- v20210119 6487 rows updated
-- v20220328 9360 rows updated
-- v20230324 12272 rows 
-- v20240326 14449 rows

select
y.*
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
inner join
(
select
t.WELL_ID
,t.rcount
from 
(
select
y.WELL_ID
,count(*) as rcount
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
where 
LOC_MASTER_LOC_ID is null
group by
y.WELL_ID
) as t
where 
t.rcount=1
) as t
on y.WELL_ID=t.WELL_ID


update MOE_20240326.dbo.YC_20240326_BH_ID
set
LOC_MASTER_LOC_ID=y.BORE_HOLE_ID
,NOFORMATION=1
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
inner join
(
select
t.WELL_ID
,t.rcount
from 
(
select
y.WELL_ID
,count(*) as rcount
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
where 
LOC_MASTER_LOC_ID is null
group by
y.WELL_ID
) as t
where 
t.rcount=1
) as t
on y.WELL_ID=t.WELL_ID

-- are there any unassigned LOC_MASTER_LOC_ID rows

-- v20180530 58 rows have not been assigned
-- v20190509 4 rows have not been assigned
-- v20200721 4 rows have not been assigned
-- v20210119 149 rows have not been assigned
-- v20220328 0 rows have not been assigned
-- v20230324 0 rows have not been assigned
-- v20240326 0 rows have not been assigned

select 
*
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
where 
loc_master_loc_id is null







