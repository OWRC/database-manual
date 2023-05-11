
--**** G_10_21_02

--***** create a series of new INT_IDs to update the associted interval
--***** tables

-- how many intervals are we dealing with

select
COUNT(*)
from 
MOE_20230324.dbo.M_D_INTERVAL

-- 2016.05.31 28188 records
-- 2017.09.05 17185 records
-- 2018.05.30 15578 records
-- v20190509 11851 rows
-- v20200721 11760 rows
-- v20210119 24619 rows
-- v20220328 15235 rows
-- v20230324 18826 rows

-- randomize these

select
t1.INT_ID
,t2.NEW_ID as [new_INT_ID]
,ROW_NUMBER() over (order by t1.INT_ID) as rnum
from 
(
select
dint.INT_ID
,ROW_NUMBER() over (order by INT_ID) as rnum
from 
MOE_20230324.dbo.M_D_INTERVAL as dint
) as t1
inner join
(
select
top 25000
v.NEW_ID
,ROW_NUMBER() over (order by NEW_ID) as rnum
from 
OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_001 as v
where 
v.NEW_ID 
not in 
(
select INT_ID from OAK_20160831_MASTER.dbo.D_INTERVAL
)
) as t2
on
t1.rnum=t2.rnum


select
t1.INT_ID
,t2.NEW_ID as [new_INT_ID]
,ROW_NUMBER() over (order by t1.INT_ID) as rnum
into MOE_20230324.dbo.YC_20230324_new_INT_ID
from 
(
select
dint.INT_ID
,ROW_NUMBER() over (order by INT_ID) as rnum
from 
MOE_20230324.dbo.M_D_INTERVAL as dint
) as t1
inner join
(
select
top 25000
v.NEW_ID
,ROW_NUMBER() over (order by NEW_ID) as rnum
from 
OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_001 as v
where 
v.NEW_ID 
not in 
(
select INT_ID from OAK_20160831_MASTER.dbo.D_INTERVAL
)
) as t2
on
t1.rnum=t2.rnum



-- now do the same with PUMP_TEST_ID for the FM_D_PUMPTEST table

-- how many records are there

select
COUNT(*)
from 
MOE_20230324.dbo.M_D_PUMPTEST

-- 2016.05.31 6268
-- 2017.09.05 3150
-- 2018.05.30 5333 
-- v20190509 1549 rows
-- v20200721 2238 rows
-- v20210119 3048 rows
-- v20220328 525 rows
-- v20230324 306 rows

-- randomize these

select
t1.PUMP_TEST_ID
,t2.NEW_ID as [new_PUMP_TEST_ID]
,ROW_NUMBER() over (order by t1.PUMP_TEST_ID) as rnum
from 
(
select
dpump.PUMP_TEST_ID
,ROW_NUMBER() over (order by PUMP_TEST_ID) as rnum
from 
MOE_20230324.dbo.M_D_PUMPTEST as dpump
) as t1
inner join
(
select
top 4000
v.NEW_ID
,ROW_NUMBER() over (order by NEW_ID) as rnum
from 
OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_001 as v
where 
v.NEW_ID 
not in 
(
select PUMP_TEST_ID from OAK_20160831_MASTER.dbo.D_PUMPTEST
)
) as t2
on
t1.rnum=t2.rnum


select
t1.PUMP_TEST_ID
,t2.NEW_ID as [new_PUMP_TEST_ID]
,ROW_NUMBER() over (order by t1.PUMP_TEST_ID) as rnum
into MOE_20230324.dbo.YC_20230324_new_PUMP_TEST_ID
from 
(
select
dpump.PUMP_TEST_ID
,ROW_NUMBER() over (order by PUMP_TEST_ID) as rnum
from 
MOE_20230324.dbo.M_D_PUMPTEST as dpump
) as t1
inner join
(
select
top 4000
v.NEW_ID
,ROW_NUMBER() over (order by NEW_ID) as rnum
from 
OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_001 as v
where 
v.NEW_ID 
not in 
(
select PUMP_TEST_ID from OAK_20160831_MASTER.dbo.D_PUMPTEST
)
) as t2
on
t1.rnum=t2.rnum

--***** 20200804
--***** The following have been disabled as the functionality have been replaced by
--***** D_LOCATION_SPATIAL and D_LOCATION_SPATIAL_HIST

--***** Do the same for M_D_LOCATION_ELEV_HIST, i.e. LOC_ELEV_ID

-- find the number of records

-- 2016.05.31 56382
-- 2017.09.05 51521
-- 2018.05.30 46640
-- v20190509 26980 rows 

--select
--COUNT(*)
--from 
--MOE_20230324.dbo.M_D_LOCATION_ELEV_HIST

-- make the look-up table

--select
--dhist.LOC_ELEV_ID
--,t2.LOC_ELEV_ID as LOC_ELEV_ID_t2
--,t2.new_LOC_ELEV_ID
--from 
--MOE_20230324.dbo.M_D_LOCATION_ELEV_HIST as dhist
--inner join 
--(
--select
--ROW_NUMBER() over (order by t1.new_LOC_ELEV_ID) as LOC_ELEV_ID
--,t1.new_LOC_ELEV_ID
--from 
--(
--select
--top 50000
--v.NEW_ID as new_LOC_ELEV_ID
--from 
--OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_001 as v
--where 
--v.NEW_ID 
--not in 
--(
--select LOC_ELEV_ID from OAK_20160831_MASTER.dbo.D_LOCATION_ELEV_HIST
--)
--) as t1
--) as t2
--on dhist.LOC_ELEV_ID=t2.LOC_ELEV_ID
--
--
--
--select
--dhist.LOC_ELEV_ID
--,t2.LOC_ELEV_ID as LOC_ELEV_ID_t2
--,t2.new_LOC_ELEV_ID
--into MOE_20230324.dbo.YC_20230324_new_LOC_ELEV_ID
--from 
--MOE_20230324.dbo.M_D_LOCATION_ELEV_HIST as dhist
--inner join 
--(
--select
--ROW_NUMBER() over (order by t1.new_LOC_ELEV_ID) as LOC_ELEV_ID
--,t1.new_LOC_ELEV_ID
--from 
--(
--select
--top 50000
--v.NEW_ID as new_LOC_ELEV_ID
--from 
--OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_001 as v
--where 
--v.NEW_ID 
--not in 
--(
--select LOC_ELEV_ID from OAK_20160831_MASTER.dbo.D_LOCATION_ELEV_HIST
--)
--) as t1
--) as t2
--on dhist.LOC_ELEV_ID=t2.LOC_ELEV_ID
