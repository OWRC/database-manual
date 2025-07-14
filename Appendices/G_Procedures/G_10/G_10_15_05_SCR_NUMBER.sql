
--***** G_10_15_05

--***** How many locations still require a screen interval to be assigned?

-- how many screened intervals so far determined

-- 2016.05.31 15036 rows
-- 2017.09.05 8394 rows
-- 2018.05.30 6204 rows
-- v20190509 5032 rows
-- v20200721 6623 rows
-- v20210119 13911 rows
-- v20220328 4738 rows
-- v20230324 5395 rows
-- v20240326 6945 rows
-- v20250711 5247 rows

select
COUNT(*) as [Distinct_LOC_ID]
from 
(
select
ycdim.TMP_LOC_ID
,COUNT(*) as rcount
from 
MOE_20250711.dbo.YC_20250711_DINTMON ycdim
group by
ycdim.TMP_LOC_ID
) as test

-- note that we're checking for distinct LOC_IDs as a particular location
-- could have one or more screens assigned; note also that the source 
-- table we're using, i.e. YC_20250711_BH_ID, should not (and does not)
-- contain any duplicate LOC_IDs

-- this actually checks for duplicate LOC_IDs; not otherwise shown;
-- no duplicates

-- 2018.05.30 0 rows
-- v20190509 0 rows
-- v20200721 0 rows
-- v20210119 0 rows
-- v20220328 0 rows
-- v20230324 0 rows
-- v20240326 0 rows
-- v20250711 0 rows

select
BORE_HOLE_ID
,rcount
from 
(
SELECT 
ycb.BORE_HOLE_ID
,COUNT(*) as rcount
FROM MOE_20250711.[dbo].YC_20250711_BH_ID as ycb
group by ycb.BORE_HOLE_ID
) as test
where test.rcount>1

-- how many locations do not have screen info as yet

-- 2016.05.31 13152 rows
-- 2017.09.05 8791 rows
-- 2018.05.30 9374 rows
-- v20190509 6819 rows
-- v20200721 5137 rows
-- v20210119 10708 rows
-- v20220328 10497 rows
-- v20230324 13431 rows
-- v20240326 16186 rows
-- v20250711 13132 rows

select
COUNT(*) as [To_Assign_tmp_LOC_IDs]
from 
MOE_20250711.dbo.YC_20250711_BH_ID as ybc
where 
ybc.BORE_HOLE_ID 
not in
(
select distinct(tmp_LOC_ID) from MOE_20250711.dbo.YC_20250711_DINTMON
)



