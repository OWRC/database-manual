
--**** G_10_21_02

--***** create a series of new INT_IDs to update the associted interval
--***** tables

-- how many intervals are we dealing with

select COUNT(*) from MOE_20260813.dbo.M_D_INTERVAL

-- 2016.05.31 28188 records
-- 2017.09.05 17185 records
-- 2018.05.30 15578 records
-- v20190509 11851 rows
-- v20200721 11760 rows
-- v20210119 24619 rows
-- v20220328 15235 rows
-- v20230324 18826 rows
-- v20240326 23131 rows
-- v20250711 18379 rows
-- v20260813 129172 rows

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
MOE_20260813.dbo.M_D_INTERVAL as dint
) as t1
inner join
(
select
top 200000
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
into MOE_20260813.dbo.YC_20260813_new_INT_ID
from 
(
select
dint.INT_ID
,ROW_NUMBER() over (order by INT_ID) as rnum
from 
MOE_20260813.dbo.M_D_INTERVAL as dint
) as t1
inner join
(
select
top 200000
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

select COUNT(*) from MOE_20260813.dbo.M_D_PUMPTEST

-- 2016.05.31 6268
-- 2017.09.05 3150
-- 2018.05.30 5333 
-- v20190509 1549 rows
-- v20200721 2238 rows
-- v20210119 3048 rows
-- v20220328 525 rows
-- v20230324 306 rows
-- v20240326 420 rows
-- v20250711 488 rows
-- v20260813 66946 rows

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
MOE_20260813.dbo.M_D_PUMPTEST as dpump
) as t1
inner join
(
select
top 100000
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
into MOE_20260813.dbo.YC_20260813_new_PUMP_TEST_ID
from 
(
select
dpump.PUMP_TEST_ID
,ROW_NUMBER() over (order by PUMP_TEST_ID) as rnum
from 
MOE_20260813.dbo.M_D_PUMPTEST as dpump
) as t1
inner join
(
select
top 100000
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




