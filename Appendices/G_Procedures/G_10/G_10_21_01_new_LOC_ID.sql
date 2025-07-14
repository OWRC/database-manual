
--***** G_10_21_01

--***** create a new series of LOC_IDs and BH_IDs we'll use to update 
--***** some of the FM_ tables before importing into the master database

--***** Note that the MOE_20250711 database needs to compare directly against
--***** the master database

-- make sure that the DATA_ID has been included in the master database

-- the DATA_ID was assigned earlier

--insert into [OAK_20120615_MASTER].[dbo].[D_DATA_SOURCE]
--(DATA_ID,DATA_TYPE,DATA_DESCRIPTION,DATA_COMMENT)
--values 
--(518,'Well Data','MOE WWR Database - 20160531 Update','Refer to Appendix G.10 in database manual for methodology')

--insert into [OAK_20160831_MASTER].[dbo].[D_DATA_SOURCE]
--(DATA_ID,DATA_TYPE,DATA_DESCRIPTION,DATA_COMMENT)
--values 
--(520,'Well Data','MOE WWR Database - 20180530 Update','Refer to Appendix G.10 in database manual for methodology')

-- 2017.09.05 used 519
-- 2018.05.30 used 520
-- v20190509 used 521
-- v20200721 522 
-- v20210119 523
-- v20220328 524
-- v20230324 525
-- v20240326 526
-- v20250711 528

select
*
from 
[OAK_20160831_MASTER].[dbo].[D_DATA_SOURCE]
where
data_id= 528

-- create the master LOC_ID

-- how many loc_ids are there

select
COUNT(*)
from 
MOE_20250711.[dbo].[M_D_LOCATION]

-- 2016.05.31 28188 locations
-- 2017.09.05 17185 locations
-- 2018.05.30 15578 locations
-- v20190509 11851 locations
-- v20200721 11760 locations
-- v20210119 24619 locations
-- v20220328 15235 locations
-- v20230324 18826 locations
-- v20240326 23131 locations
-- v20250711 18379 locations

-- how many in YC_????????_BH_ID and in M_D_BOREHOLE

select count(*) FROM MOE_20250711.[dbo].[YC_20250711_BH_ID]

select count(*) FROM MOE_20250711.[dbo].[M_D_BOREHOLE]

-- 2016.05.31 28188 in both
-- 2017.09.05 17185 in both
-- 2018.05.30 15578 in both
-- v20190509 11851 in both  
-- v20200721 11760 both
-- v20210119 24619 both (after bh_drill_method_code update - see G_10_09_05)
-- v20220328 15235 in both
-- v20230324 18826 in both
-- v20240326 23131 in both
-- v20250711 18379 in both

 -- use YC_????????_BH_ID to assemble the LOC_ID/BH_ID transformations

select
t1.BORE_HOLE_ID
,t2.NEW_ID as new_LOC_ID
,t1.BH_ID
,cast(null as int) as new_BH_ID
,ROW_NUMBER() over (order by t1.BORE_HOLE_ID) as rnum
from 
(
select
dloc.BORE_HOLE_ID
,dloc.BH_ID
,ROW_NUMBER() over (order by BORE_HOLE_ID) as rnum
from 
MOE_20250711.dbo.YC_20250711_BH_ID as dloc
) as t1
inner join
(
select
top 30000
v.NEW_ID
,ROW_NUMBER() over (order by NEW_ID) as rnum
from 
OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_BULK_001 as v
where 
v.NEW_ID 
not in 
(
select LOC_ID from OAK_20160831_MASTER.dbo.D_LOCATION
)
) as t2
on
t1.rnum=t2.rnum


select
t1.BORE_HOLE_ID
,t2.NEW_ID as new_LOC_ID
,t1.BH_ID
,cast(null as int) as new_BH_ID
,ROW_NUMBER() over (order by t1.BORE_HOLE_ID) as rnum
into MOE_20250711.dbo.YC_20250711_new_LOC_ID_BH_ID
from 
(
select
dloc.BORE_HOLE_ID
,dloc.BH_ID
,ROW_NUMBER() over (order by BORE_HOLE_ID) as rnum
from 
MOE_20250711.dbo.YC_20250711_BH_ID as dloc
) as t1
inner join
(
select
top 30000
v.NEW_ID
,ROW_NUMBER() over (order by NEW_ID) as rnum
from 
OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_BULK_001 as v
where 
v.NEW_ID 
not in 
(
select LOC_ID from OAK_20160831_MASTER.dbo.D_LOCATION
)
) as t2
on
t1.rnum=t2.rnum

drop table moe_20250711.dbo.yc_20250711_new_loc_id_bh_id


--***** 20230510 Populate new BH_ID after this (commented out) section


--***** The scripts in this next section have been moved to the bottom as no changes
--***** were necessary for 20160531

-- there should be an equivalent number of records in FM_D_BOREHOLE;
-- if there isn't check why and correct

--***** scripts, above, moved

--***** update the new_BH_ID based upon the existing BH_ID and LOC_ID

--update [MOE_20160531].dbo.YC_20160531_new_LOC_ID_BH_ID
--set
--new_BH_ID=t2.new_BH_ID

select 
y.BORE_HOLE_ID 
,t2.new_BH_ID
,y.rnum
from 
MOE_20250711.dbo.YC_20250711_new_LOC_ID_BH_ID as y
inner join
(
select
t1.new_BH_ID
,ROW_NUMBER() over (order by t1.new_BH_ID) as rnum
from 
(
select 
top 30000
v.NEW_ID as new_BH_ID
from 
OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_BULK_001 as v
where 
v.NEW_ID 
not in 
(
select BH_ID from OAK_20160831_MASTER.dbo.D_BOREHOLE
)
) as t1
) as t2 
on y.rnum=t2.rnum


update MOE_20250711.dbo.YC_20250711_new_LOC_ID_BH_ID
set
new_BH_ID=t2.new_BH_ID
from 
MOE_20250711.dbo.YC_20250711_new_LOC_ID_BH_ID as y
inner join
(
select
t1.new_BH_ID
,ROW_NUMBER() over (order by t1.new_BH_ID) as rnum
from 
(
select 
top 30000
v.NEW_ID as new_BH_ID
from 
OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_BULK_001 as v
where 
v.NEW_ID 
not in 
(
select BH_ID from OAK_20160831_MASTER.dbo.D_BOREHOLE
)
) as t1
) as t2 
on y.rnum=t2.rnum

--***** Note that the above script returned an numeric overflow conversion error; did not 
--***** repeat on a subsequent run



--***** The following were moved from above as there were no changes
--***** necessary for the 20160531 import

-- there should be an equivalent number of records in FM_D_BOREHOLE;
-- if there isn't check why and correct

--select
--COUNT(*) 
--from 
--[MOE_201304].dbo.FM_D_BOREHOLE

-- there isn't; check and correct

--select
--*
--from 
--[MOE_201304].[dbo].[FM_D_BOREHOLE]
--where 
--LOC_ID 
--not in
--(
--select LOC_ID from [MOE_201304].dbo.FM_D_LOCATION
--)

--select
--*
--from 
--[MOE_201304].[dbo].[FM_D_BOREHOLE] as dbore
--inner join 
--(
--select
--loc_id 
--,COUNT(*) as rcount
--from 
--[MOE_201304].[dbo].[FM_D_BOREHOLE]
--group by
--LOC_ID 
--) as t1
--on
--dbore.LOC_ID=t1.LOC_ID
--where
--t1.rcount>1

--delete from [MOE_201304].[dbo].[FM_D_BOREHOLE]
--where
--LOC_ID=240686121
--and BH_DIAMETER_OUOM is not null
