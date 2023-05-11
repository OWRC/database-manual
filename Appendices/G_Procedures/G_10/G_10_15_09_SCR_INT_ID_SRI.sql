
--***** G_10_15_09


--***** 

--***** Create some holder INT_ID and SYS_RECORD_ID values for the FM_D_INTERVAL__MONITOR
--***** table; we're not referencing the master D_INT_MON table

-- examine the number of rows in YC_????????_DINTMON and the YC_????????_BHID/COORDS tables;
-- if these don't match, are there multiple screens per location?


-- 2016.08.31 28575 records here
-- 2017.09.05 17413 records here
-- 2018.05.30 15706 rows
-- v20190509 11930 rows
-- v20200721 11834 rows
-- v20210119 24769 rows
-- v20220328 15269 rows
-- v20230324 18850 rows

select
COUNT(*)
FROM 
MOE_20230324.[dbo].[YC_20230324_DINTMON]


-- 2016.05.31 28188 records total
-- 2017.09.05 17185 records total
-- 2018.05.30 15578 rows
-- v20190509 11851 rows 
-- v20200721 11760 rows
-- v20210119 24619 rows
-- v20220328 15235 rows
-- v20230324 18826 rows

select
COUNT(*) 
from 
MOE_20230324.dbo.[YC_20230324_BH_ID] as ycb

-- remember only those records also in YC_20130923_COORDS will be present

-- check if these are duplicates; they appear to be all reported screens, i.e.
-- not created through construction or formation details; 

-- 2016.05.31 754 total - this is the likely cause of the mismatch
-- 2017.09.05 439 total - this is the likely cause of the mismatch
-- 2018.05.30 215 total - note that there is more intervals than locations
-- v20190509 150 total - 
-- v20200721 146 total - more intervals than locations
-- v20210119 290 total - more intervals than locations
-- v20220328 62 total - more intervals than locations
-- v20230324 46 total - more intervals than locations

select
*
from 
MOE_20230324.dbo.YC_20230324_DINTMON as dim
inner join 
(
select
dim.TMP_LOC_ID
,COUNT(*) as rcount
from 
MOE_20230324.dbo.YC_20230324_DINTMON as dim
group by 
dim.TMP_LOC_ID
) as t1
on dim.TMP_LOC_ID=t1.TMP_LOC_ID
where 
t1.rcount>1
order by 
dim.TMP_LOC_ID,dim.MON_TOP_OUOM


-- are there multiple screens per location; check if there are multiple static
-- water levels for a particular location

-- extract all the static water levels based on loc_id

-- 2018.05.30 5761 rows
-- v20190509 1684 rows 
-- v20200721 2400 rows
-- v20210119 3780 rows
-- v20230324 707 rows

SELECT 
moept.[PIPE_ID]
,t1.BORE_HOLE_ID
,[WELL_ID]
,[Static_lev]
,[LEVELS_UOM]
FROM 
MOE_20230324.[dbo].[TblPump_Test] as moept
inner join
(
select
moetp.PIPE_ID
,ycb.BORE_HOLE_ID
from 
MOE_20230324.dbo.[YC_20230324_BH_ID] as ycb
inner join MOE_20230324.dbo.TblPipe as moetp
on ycb.BORE_HOLE_ID=moetp.Bore_Hole_ID
) as t1
on moept.PIPE_ID=t1.PIPE_ID
where
moept.Static_lev is not null 

-- is there more than one static level per loc_id

select 
t3.BORE_HOLE_ID
,t3.rcount
from 
(
select 
t2.BORE_HOLE_ID
,COUNT(*) as rcount
from 
(
--*****
SELECT 
moept.[PIPE_ID]
,t1.BORE_HOLE_ID
,[WELL_ID]
,[Static_lev]
,[LEVELS_UOM]
FROM 
MOE_20230324.[dbo].[TblPump_Test] as moept
inner join
(
select
moetp.PIPE_ID
,ycb.BORE_HOLE_ID
from 
MOE_20230324.dbo.[YC_20230324_BH_ID] as ycb
inner join MOE_20230324.dbo.TblPipe as moetp
on ycb.BORE_HOLE_ID=moetp.Bore_Hole_ID
) as t1
on moept.PIPE_ID=t1.PIPE_ID
where
moept.Static_lev is not null
--*****
) as t2
group by
t2.BORE_HOLE_ID
) as t3
where 
t3.rcount>1

-- 2016.05.31 no locations with multiple records
-- 2017.09.05 no locations with multiple records
-- 2018.05.30 no locations with multiple records
-- v20190509 0 rows with multiple records
-- v20200721 4 rows with multiple records
-- v20210119 2 rows with multiple records
-- v20220328 0 rows with multiple records
-- v20230324 0 rows with multiple records

-- make sure the bot>top values

-- 2017.09.05 291 rows
-- 2018.05.30 279 rows
-- v20190509 223 rows
-- v20200721 134 rows
-- v20210119 499 rows
-- v20220328 59 rows
-- v20230324 1 row

select
ycd.*
from 
MOE_20230324.dbo.YC_20230324_DINTMON as ycd
where 
ycd.MON_BOT_OUOM<ycd.MON_TOP_OUOM


update MOE_20230324.dbo.YC_20230324_DINTMON
set
MON_TOP_OUOM=MON_BOT_OUOM 
,MON_BOT_OUOM=MON_TOP_OUOM 
where 
MON_BOT_OUOM<MON_TOP_OUOM

-- check if there is duplicate (or null) values for the screen info, other than
-- mon_top_ouom and mon_bot_ouom

-- 2016.05.31 0 rows 
-- 2017.09.05 0 rows
-- 2018.05.30 2 rows
-- v20190509 0 rows
-- v20200721 8 rows (4 locations)
-- v20210119 4 rows (2 locations)
-- v20220328 0 rows
-- v20230324 0 rows

select 
test.TMP_LOC_ID
,ycd.*
from 
(
select 
TMP_LOC_ID
,COUNT(*) as rcount
from 
MOE_20230324.dbo.YC_20230324_DINTMON as ycd
group by
TMP_LOC_ID,MON_SCREEN_SLOT,MON_SCREEN_MATERIAL,MON_DIAMETER_OUOM,MON_DIAMETER_UNIT_OUOM,MON_TOP_OUOM,MON_BOT_OUOM
) as test
inner join 
MOE_20230324.dbo.YC_20230324_DINTMON as ycd
on test.TMP_LOC_ID=ycd.TMP_LOC_ID
where 
test.rcount>1
order by
test.TMP_LOC_ID

-- if there are, these will need to be fixed after assigning an INT_ID and SYS_RECORD_ID (as, right now, we cannot
-- access a particular row in the table)

-- 2018.05.30: TMP_LOC_ID 1006595138

-- v20200721

--1007328019
--1007412804
--1007526939
--1007602401

-- v20210119

-- 1007689836
-- 1007700533

-- copy dintmon into M_D_INTERVAL_MONITOR; note that we're using a counter for SYS_RECORD_ID and
-- tmp_LOC_ID for tmp_INT_ID

-- 2016.05.31 28575 rows
-- 2017.09.05 17413 rows
-- 2018.05.30 15706 rows
-- v20190509 11930 rows 
-- v20200721 11834
-- v20210119 24769 rows
-- v20220328 15269 rows
-- v20230324 18850 rows

select 
TMP_LOC_ID as INT_ID
,dim.tmp_INT_TYPE_CODE 
,dim.MON_SCREEN_SLOT
,cast(moeccm.DES as varchar(255)) as MON_SCREEN_MATERIAL
,dim.MON_DIAMETER_OUOM
,dim.MON_DIAMETER_UNIT_OUOM
,dim.MON_TOP_OUOM
,dim.MON_BOT_OUOM
,dim.MON_UNIT_OUOM
,dim.MON_COMMENT
,cast(null as int) as MON_FLOWING
,row_number() over (order by dim.TMP_LOC_ID) as SYS_RECORD_ID
from 
MOE_20230324.dbo.YC_20230324_DINTMON as dim
left outer join MOE_20230324.dbo._code_casing_material as moeccm
on dim.MON_SCREEN_MATERIAL=moeccm.CODE

 --check that the number of rows from YC_20130923_DINTMON matches the
 --rownumber count
 
 -- 2016.05.31 28575 rows
 -- 2017.09.05 17413 rows
 -- 2018.05.30 15706 rows (match)
 -- v20190509 11930 (matches)
 -- v20200721 11834 (matches)
 -- v20210119 24769 rows (matches)
 -- v20220328 15269 rows (matches)
 -- v20230324 18850 rows (matches)

select
COUNT(*)
from 
MOE_20230324.dbo.YC_20230324_DINTMON as dim

-- create if it matched

select 
TMP_LOC_ID as INT_ID
,dim.tmp_INT_TYPE_CODE 
,dim.MON_SCREEN_SLOT
,cast(moeccm.DES as varchar(255)) as MON_SCREEN_MATERIAL
,dim.MON_DIAMETER_OUOM
,dim.MON_DIAMETER_UNIT_OUOM
,dim.MON_TOP_OUOM
,dim.MON_BOT_OUOM
,dim.MON_UNIT_OUOM
,dim.MON_COMMENT
,cast(null as int) as MON_FLOWING
,row_number() over (order by dim.TMP_LOC_ID) as SYS_RECORD_ID
into MOE_20230324.dbo.M_D_INTERVAL_MONITOR
from 
MOE_20230324.dbo.YC_20230324_DINTMON as dim
left outer join MOE_20230324.dbo._code_casing_material as moeccm
on dim.MON_SCREEN_MATERIAL=moeccm.CODE

-- remove the duplicates (found earlier)

-- 2017.09.05 0 duplicates
-- 2018.05.30 2 duplicates (i.e. one location)
-- v20190509 0 duplicates
-- v20200721 
-- v20210119 2 duplicates
-- v20220328 0 rows
-- v20230324 0 rows

select 
y.*
from 
(
select 
INT_ID
,COUNT(*) as rcount
from 
MOE_20230324.dbo.M_D_INTERVAL_MONITOR as y
group by
INT_ID,MON_SCREEN_SLOT,MON_SCREEN_MATERIAL,MON_DIAMETER_OUOM,MON_DIAMETER_UNIT_OUOM,MON_TOP_OUOM,MON_BOT_OUOM
) as test
inner join 
MOE_20230324.dbo.M_D_INTERVAL_MONITOR as y
on
test.INT_ID=y.INT_ID
where 
test.rcount>1
order by
test.INT_ID


delete from MOE_20230324.dbo.M_D_INTERVAL_MONITOR
where 
SYS_RECORD_ID in
(
select
dim.SYS_RECORD_ID
from 
MOE_20230324.dbo.M_D_INTERVAL_MONITOR as dim
inner join
(
select
t.INT_ID 
,t.keep_SRI
from 
(
select 
INT_ID
,COUNT(*) as rcount
,min(SYS_RECORD_ID) as keep_SRI
from 
[MOE_20230324].dbo.M_D_INTERVAL_MONITOR as dim
group by
INT_ID,MON_SCREEN_SLOT,MON_SCREEN_MATERIAL,MON_DIAMETER_OUOM,MON_DIAMETER_UNIT_OUOM,MON_TOP_OUOM,MON_BOT_OUOM
) as t
where t.rcount>1
) as t2
on dim.INT_ID=t2.INT_ID 
where 
dim.SYS_RECORD_ID<>t2.keep_SRI
)

-- do we need to re-introduce any

-- 2017.09.05 0 rows
-- 2018.05.30 0 rows
-- v20190509 0 rows 
-- v20200721 0 rows
-- v20210119 0 rows
-- v20220328 0 rows
-- v20230324 0 rows

select
b.*
from 
MOE_20230324.dbo.YC_20230324_BH_ID as b
where 
BORE_HOLE_ID 
not in
(
select
INT_ID
from 
MOE_20230324.dbo.M_D_INTERVAL_MONITOR
group by
INT_ID
)


--***** 20230324 added the following

-- check for duplications in the created table

-- v20230324 46 duplicates

select 
t2.rcount
,m.*
from 
MOE_20230324.dbo.M_D_INTERVAL_MONITOR as m
inner join
(
select
int_id
,rcount
from 
(
select
int_id
,count(*) as rcount
from 
MOE_20230324.dbo.M_D_INTERVAL_MONITOR
group by
int_id
) as t
where
t.rcount>1
) as t2
on m.int_id=t2.int_id


