
--***** G_10_02_02

--***** determine those BORE_HOLE_IDs that contain formation information; these
--***** should be, likely, master LOC_IDs

-- this is the base query, used subsequently

--select
--f.BORE_HOLE_ID 
--,count(*) as rcount
--from 
--[MOE_20160531].dbo.tblFormation as f
--inner join [MOE_20160531].dbo.YC_20160531_BH_ID as y
--on f.BORE_HOLE_ID=y.BORE_HOLE_ID 
--group by 
--f.bore_hole_id

-- check if there multiple formations specified by WELL_ID; this should
-- return no rows if there is only a single master borehole (where this is
-- defined as having formation information; we're looking here for WEL_IDs 
-- with multiple BORE_HOLE_IDs that each have formation info)

-- v20180530 no rows are returned
-- v20180530 no rows are returned
-- v20190509 no rows are returned
-- v20200721 no rows are returned
-- v20210119 no rows are returned
-- v20220328 no rows are returned
-- v20230324 no rows are returned
-- v20240326 no rows are returned
-- v20250711 no rows are returned

select
t2.WELL_ID
,t2.rcount
from 
(
select 
y.WELL_ID 
,count(*) as rcount
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y
inner join 
(
select
f.BORE_HOLE_ID 
,count(*) as rcount
from 
MOE_20250711.dbo.tblFormation as f
inner join MOE_20250711.dbo.YC_20250711_BH_ID as y
on f.BORE_HOLE_ID=y.BORE_HOLE_ID 
group by 
f.bore_hole_id
) as t
on y.BORE_HOLE_ID=t.BORE_HOLE_ID
group by
y.WELL_ID
) as t2
where
t2.rcount>1

-- assign the BORE_HOLE_ID to the LOC_MASTER_LOC_ID for those that contain
-- formation information

-- v20180530 0 rows apply
-- v20190509 7890 rows updated
-- v20200721 8138 rows updated
-- v20210119 17458 rows updated
-- v20220328 5856 rows updated
-- v20230324 6554 rows updated
-- v20240326 8682 rows updated
-- v20250711 6756 rows updated

update MOE_20250711.dbo.YC_20250711_BH_ID
set
LOC_MASTER_LOC_ID=y.BORE_HOLE_ID
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y
inner join
(
select
f.BORE_HOLE_ID 
,count(*) as rcount
from 
MOE_20250711.dbo.tblFormation as f
inner join MOE_20250711.dbo.YC_20250711_BH_ID as y
on f.BORE_HOLE_ID=y.BORE_HOLE_ID 
group by 
f.bore_hole_id
) as t
on
y.BORE_HOLE_ID=t.BORE_HOLE_ID

-- determine those locations that do not have a LOC_MASTER_LOC_ID assigned; they
-- will have a value of 1; assign the appropriate BORE_HOLE_ID

-- this is the base statement

select
y.WELL_ID 
,y.BORE_HOLE_ID 
,y.LOC_MASTER_LOC_ID 
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y
where 
LOC_MASTER_LOC_ID<>1

-- check, again, that only a single distinct WELL_ID will occur in each row;
-- this should return no rows

-- v20190509 0 rows returned
-- v20200721 0 rows returned
-- v20210119 0 rows returned
-- v20220328 0 rows returned
-- v20230324 0 rows returned
-- v20240326 0 rows returned
-- v20250711 0 rows returned

select
t2.WELL_ID
,t2.rcount
from 
(
select 
t.WELL_ID 
,count(*) as rcount
from 
(
select
y.WELL_ID 
,y.BORE_HOLE_ID 
,y.LOC_MASTER_LOC_ID 
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y
where 
LOC_MASTER_LOC_ID<>1
) as t
group by 
t.WELL_ID 
) as t2
where 
t2.rcount>1

-- assign the appropriate BORE_HOLE_ID based on the WELL_ID cluster; if
-- no rows are returned, there are no cluster wells

-- all those with a
-- LOC_MASTER_LOC_ID of 1, then, need to be evaluated to find the 
-- master location; this will be undertaken at a later step

-- v20180530 426 rows returned
-- v20190509 0 rows returned
-- v20200721 0 rows returned
-- v20210119 525 rows returned
-- v20220328 19 rows returned
-- v20230324 0 rows returned
-- v20240326 0 rows returned
-- v20250711 0 rows returned

select
y.*
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y
inner join
(
select
y.WELL_ID 
,y.BORE_HOLE_ID 
,y.LOC_MASTER_LOC_ID 
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y
where 
LOC_MASTER_LOC_ID<>1
) as t
on y.WELL_ID=t.WELL_ID
where 
y.LOC_MASTER_LOC_ID=1

-- v20180530 3641 rows returned with loc_master_loc_id equal to 1
-- v20190509 3961 rows returned with loc_master_loc_id equal to 1
-- v20200721 3622 rows returned with loc_master_loc_id equal to 1
-- v20210119 7161 rows returned
-- v20220328 9379 rows returned
-- v20230324 12272 rows returned
-- v20240326 14449 rows returned
-- v20250711 11623 rows returned

select
*
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y
where 
y.loc_master_loc_id= 1

-- we'll make all the 1 values a null for ease in both cluster and 
-- single BORE_HOLE_IDs

update MOE_20250711.dbo.YC_20250711_BH_ID
set
LOC_MASTER_LOC_ID=null 
where 
LOC_MASTER_LOC_ID=1




