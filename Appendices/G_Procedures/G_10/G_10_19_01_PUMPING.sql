
--***** G_10_19_01

--***** We can now assemble the pump test data;  both the MOE WWDB and the YPDT-CAMC
--***** database use two tables to hold the test information and the subsequent
--***** recorded levels

-- assemble the test information first; the pumptest name is the WELL_ID;
-- this, I believe, is the base query used further down; don't run yet

--***** DO NOT RUN

--select 
--dint.INT_ID as PUMP_TEST_ID
--,dint.INT_ID
--,case
--when dint.INT_START_DATE is not null then dint.INT_START_DATE 
--else cast('1867-07-01' as datetime)
--end as [PUMPTEST_DATE]
--,cast(ycb.WELL_ID as varchar(20)) as PUMPTEST_NAME
--,ROW_NUMBER() over (order by dint.INT_ID) as rnum
--from 
--[MOE_20160531].dbo.TblPipe as moetp
--inner join [MOE_20160531].dbo.YC_20160531_BH_ID as ycb
--on moetp.Bore_Hole_ID=ycb.BORE_HOLE_ID
--inner join [MOE_20160531].dbo.TblPump_Test as moept
--on moetp.PIPE_ID=moept.PIPE_ID
--inner join [MOE_20160531].dbo.M_D_LOCATION as dloc
--on ycb.LOC_ID=dloc.LOC_ID
--inner join [MOE_20160531].dbo.M_D_INTERVAL as dint
--on dloc.LOC_ID=dint.LOC_ID
--inner join [MOE_20160531].dbo.M_D_INTERVAL_REF_ELEV as dire
--on dint.INT_ID=dire.INT_ID
--where 
--moept.Pump_Set_at is not null -- check the other parameters

--***** start here

-- what wells are marked as flowing; update FM_D_INT_MON, note that this
-- is a tag only

-- count of wells marked as flowing

-- 2016.05.31 235 wells
-- 2017.09.05 128 wells
-- 2018.05.30 96 wells
-- v20190509 37 wells 
-- v20200721 49 rows
-- v20210119 74 rows
-- v20220328 10 rows
-- v20230324 15 rows
-- v20240326 14 rows

select
COUNT(*) as rcount
from 
MOE_20240326.dbo.M_D_INTERVAL_MONITOR as dim
where
dim.INT_ID
in
(
select 
dint.INT_ID
from 
MOE_20240326.dbo.TblPipe as moetp
inner join MOE_20240326.dbo.YC_20240326_BH_ID as ycb
on moetp.Bore_Hole_ID=ycb.BORE_HOLE_ID
inner join MOE_20240326.dbo.TblPump_Test as moept
on moetp.PIPE_ID=moept.PIPE_ID
inner join MOE_20240326.dbo.M_D_LOCATION as dloc
on ycb.BORE_HOLE_ID=dloc.LOC_ID
inner join MOE_20240326.dbo.M_D_INTERVAL as dint
on dloc.LOC_ID=dint.LOC_ID
where 
moept.FLOWING like 'Y'
)


update MOE_20240326.dbo.M_D_INTERVAL_MONITOR
set
MON_FLOWING=1
where 
INT_ID 
in
(
select 
dint.INT_ID
from 
MOE_20240326.dbo.TblPipe as moetp
inner join MOE_20240326.dbo.YC_20240326_BH_ID as ycb
on moetp.Bore_Hole_ID=ycb.BORE_HOLE_ID
inner join MOE_20240326.dbo.TblPump_Test as moept
on moetp.PIPE_ID=moept.PIPE_ID
inner join MOE_20240326.dbo.M_D_LOCATION as dloc
on ycb.BORE_HOLE_ID=dloc.LOC_ID
inner join MOE_20240326.dbo.M_D_INTERVAL as dint
on dloc.LOC_ID=dint.LOC_ID
where 
moept.FLOWING like 'Y'
)

-- when we want to check for flowing wells, use 'is not null' for comparison

-- do we want to pull the ones with a rate and recommended rate, but nothing
-- else, and have no entries in the second table (for these)?

-- we're assuming all rates of GPM are IGPM; there are 4.55 litres per imperial gallon

--***** UPDATE DATA_ID

-- 2017.09.05 3150 rows
-- 2018.05.30 5333 rows
-- v20190509 1549 rows 
-- v20200721 2238 rows
-- v20210119 3048 rows
-- v20220328 525 rows
-- v20230324 
-- v20240326 420 rows

select 
moept.PUMP_TEST_ID
,dint.INT_ID
,dint.INT_START_DATE as [PUMPTEST_DATE]
,cast(ycb.WELL_ID as varchar(20)) as PUMPTEST_NAME
,cast(
case 
when moept.LEVELS_UOM='ft' then moept.Recom_depth*0.3048
else moept.Recom_depth
end as float) as [REC_PUMP_DEPTH_METERS]
,cast(
case 
when moept.RATE_UOM='LPM' then moept.Recom_rate/4.55
else moept.Recom_rate
end as float) as [REC_PUMP_RATE_IGPM]
,cast(
case 
when moept.RATE_UOM='LPM' then moept.Flowing_rate/4.55
else moept.Flowing_rate
end as float) as [FLOWING_RATE_IGPM]
,cast(526 as int) as [DATA_ID]
,cast(
case 
when moept.PUMPING_TEST_METHOD is null then null 
when moept.PUMPING_TEST_METHOD=0       then null
when moept.PUMPING_TEST_METHOD=1       then 1
when moept.PUMPING_TEST_METHOD=2       then 2
when moept.PUMPING_TEST_METHOD=3       then 4
when moept.PUMPING_TEST_METHOD=4       then 8
when moept.PUMPING_TEST_METHOD=5       then 9
else 10
end as int) as [PUMPTEST_METHOD_CODE]
,cast(1 as int) as [PUMPTEST_TYPE_CODE]  -- this is a constant rate indicator
,cast(
case
when moept.WATER_STATE_AFTER_TEST is null then 0
else moept.WATER_STATE_AFTER_TEST
end as int) as [WATER_CLARITY_CODE]
,ROW_NUMBER() over (order by dint.INT_ID) as rnum
from 
MOE_20240326.dbo.TblPipe as moetp
inner join MOE_20240326.dbo.YC_20240326_BH_ID as ycb
on moetp.Bore_Hole_ID=ycb.BORE_HOLE_ID
inner join MOE_20240326.dbo.TblPump_Test as moept
on moetp.PIPE_ID=moept.PIPE_ID
inner join MOE_20240326.dbo.M_D_LOCATION as dloc
on ycb.BORE_HOLE_ID=dloc.LOC_ID
inner join MOE_20240326.dbo.M_D_INTERVAL as dint
on dloc.LOC_ID=dint.LOC_ID
where
(
moept.Recom_depth is not null 
or moept.Recom_rate is not null 
or moept.Flowing_rate is not null 
or moept.PUMP_TEST_ID in (select PUMP_TEST_ID from MOE_20240326.dbo.TblPump_Test_Detail)
)


select 
moept.PUMP_TEST_ID
,dint.INT_ID
,dint.INT_START_DATE as [PUMPTEST_DATE]
,cast(ycb.WELL_ID as varchar(20)) as PUMPTEST_NAME
,cast(
case 
when moept.LEVELS_UOM='ft' then moept.Recom_depth*0.3048
else moept.Recom_depth
end as float) as [REC_PUMP_DEPTH_METERS]
,cast(
case 
when moept.RATE_UOM='LPM' then moept.Recom_rate/4.55
else moept.Recom_rate
end as float) as [REC_PUMP_RATE_IGPM]
,cast(
case 
when moept.RATE_UOM='LPM' then moept.Flowing_rate/4.55
else moept.Flowing_rate
end as float) as [FLOWING_RATE_IGPM]
,cast(526 as int) as [DATA_ID]
,cast(
case 
when moept.PUMPING_TEST_METHOD is null then null 
when moept.PUMPING_TEST_METHOD=0       then null
when moept.PUMPING_TEST_METHOD=1       then 1
when moept.PUMPING_TEST_METHOD=2       then 2
when moept.PUMPING_TEST_METHOD=3       then 4
when moept.PUMPING_TEST_METHOD=4       then 8
when moept.PUMPING_TEST_METHOD=5       then 9
else 10
end as int) as [PUMPTEST_METHOD_CODE]
,cast(1 as int) as [PUMPTEST_TYPE_CODE]  -- this is a constant rate indicator
,cast(
case
when moept.WATER_STATE_AFTER_TEST is null then 0
else moept.WATER_STATE_AFTER_TEST
end as int) as [WATER_CLARITY_CODE]
,ROW_NUMBER() over (order by dint.INT_ID) as rnum
into MOE_20240326.dbo.M_D_PUMPTEST
from 
MOE_20240326.dbo.TblPipe as moetp
inner join MOE_20240326.dbo.YC_20240326_BH_ID as ycb
on moetp.Bore_Hole_ID=ycb.BORE_HOLE_ID
inner join MOE_20240326.dbo.TblPump_Test as moept
on moetp.PIPE_ID=moept.PIPE_ID
inner join MOE_20240326.dbo.M_D_LOCATION as dloc
on ycb.BORE_HOLE_ID=dloc.LOC_ID
inner join MOE_20240326.dbo.M_D_INTERVAL as dint
on dloc.LOC_ID=dint.LOC_ID
where
(
moept.Recom_depth is not null 
or moept.Recom_rate is not null 
or moept.Flowing_rate is not null 
or moept.PUMP_TEST_ID in (select PUMP_TEST_ID from MOE_20240326.dbo.TblPump_Test_Detail)
)


-- recommended rates into D_PUMPTEST
-- actual rate into D_PUMPTEST_STEP

-- adjust MON_FLOWING or FLOWING_RATE_IGPM through various rules

-- null FLOWING_RATE_IGPM when no MON_FLOWING and REC_PUMP_RATE_IGPM=FLOWING_RATE_IGPM

-- 2016.05.31 14 rows
-- 2017.09.05 5 rows
-- 2018.05.30 4 rows
-- v20190509 3 rows 
-- v20200721 4 rows
-- v20210119 4 rows
-- v20220328 0 rows
-- v20230324 0 rows
-- v20240326 0 rows

select
dpump.PUMP_TEST_ID
from 
MOE_20240326.dbo.M_D_PUMPTEST as dpump
where
dpump.INT_ID
not in
(
select
dim.INT_ID
from 
MOE_20240326.dbo.M_D_INTERVAL_MONITOR as dim
where
dim.MON_FLOWING is not null 
)
and dpump.REC_PUMP_RATE_IGPM=dpump.FLOWING_RATE_IGPM


update MOE_20240326.dbo.M_D_PUMPTEST
set
FLOWING_RATE_IGPM=null 
from 
MOE_20240326.dbo.M_D_PUMPTEST as dpump
where
dpump.INT_ID
not in
(
select
dim.INT_ID
from 
MOE_20240326.dbo.M_D_INTERVAL_MONITOR as dim
where
dim.MON_FLOWING is not null 
)
and dpump.REC_PUMP_RATE_IGPM=dpump.FLOWING_RATE_IGPM


-- no REC_PUMP_RATE_IGPM but FLOWING_RATE_IGPM; tag MON_FLOWING

-- 2016.05.31 20 records
-- 2017.09.05 14 records
-- 2018.05.30 16 records
-- v20190509 14 records 
-- v20200721 2 rows
-- v20210119 14 rows
-- v20220328 3 rows
-- v20230324 0 rows
-- v20240326 0 rows

select
dim.INT_ID
from 
MOE_20240326.dbo.M_D_INTERVAL_MONITOR as dim
where
dim.INT_ID
in
(
select 
dpump.INT_ID 
from 
MOE_20240326.dbo.M_D_PUMPTEST as dpump
where
dpump.INT_ID
in 
(
select
dim.INT_ID
from 
MOE_20240326.dbo.M_D_INTERVAL_MONITOR as dim
where
dim.MON_FLOWING is null 
)
and dpump.REC_PUMP_RATE_IGPM is null 
and dpump.FLOWING_RATE_IGPM is not null 
)


update MOE_20240326.dbo.M_D_INTERVAL_MONITOR
set
MON_FLOWING=1
from 
MOE_20240326.dbo.M_D_INTERVAL_MONITOR as dim
where
dim.INT_ID
in
(
select 
dpump.INT_ID 
from 
MOE_20240326.dbo.M_D_PUMPTEST as dpump
where
dpump.INT_ID
in 
(
select
dim.INT_ID
from 
MOE_20240326.dbo.M_D_INTERVAL_MONITOR as dim
where
dim.MON_FLOWING is null 
)
and dpump.REC_PUMP_RATE_IGPM is null 
and dpump.FLOWING_RATE_IGPM is not null 
)


-- FLOWING_RATE_IGPM less than REC_PUMP_RATE_IGPM and no MON_FLOWING; tag MON_FLOWING

-- 2016.05.31 199 records
-- 2017.09.05 51 records
-- 2018.05.30 55 records
-- v20190509 44 rows 
-- v20200721 61 rows
-- v20210119 56 rows
-- v20220328 16 rows
-- v20230324 5 rows
-- v20240326 0 rows

select
dim.INT_ID
from 
MOE_20240326.dbo.M_D_INTERVAL_MONITOR as dim
where
dim.INT_ID
in
(
select 
dpump.INT_ID 
from 
MOE_20240326.dbo.M_D_PUMPTEST as dpump
where
dpump.INT_ID
in 
(
select
dim.INT_ID
from 
MOE_20240326.dbo.M_D_INTERVAL_MONITOR as dim
where
dim.MON_FLOWING is null 
)
and dpump.FLOWING_RATE_IGPM<dpump.REC_PUMP_RATE_IGPM
)


update MOE_20240326.dbo.M_D_INTERVAL_MONITOR
set
MON_FLOWING=1
from 
MOE_20240326.dbo.M_D_INTERVAL_MONITOR as dim
where
dim.INT_ID
in
(
select 
dpump.INT_ID 
from 
MOE_20240326.dbo.M_D_PUMPTEST as dpump
where
dpump.INT_ID
in 
(
select
dim.INT_ID
from 
MOE_20240326.dbo.M_D_INTERVAL_MONITOR as dim
where
dim.MON_FLOWING is null 
)
and dpump.FLOWING_RATE_IGPM<dpump.REC_PUMP_RATE_IGPM
)


-- if FLOWING_RATE_IGPM is greater than REC_PUMP_RATE_IGPM and MON_FLOWING is not
-- tagged, null FLOWING_RATE_IGPM; this is considered an error

-- 2016.05.31 22 records
-- 2017.09.05 12 records
-- 2018.05.30 9 records
-- v20190509 9 records 
-- v20200721 8 rows
-- v20210119 8 rows
-- v20220328 0 rows
-- v20230324 0 rows
-- v20240326 0 rows

select
dpump.INT_ID
from 
MOE_20240326.dbo.M_D_PUMPTEST as dpump
where
dpump.INT_ID
in
(
select 
dpump.INT_ID 
from 
MOE_20240326.dbo.M_D_PUMPTEST as dpump
where
dpump.INT_ID
in 
(
select
dim.INT_ID
from 
MOE_20240326.dbo.M_D_INTERVAL_MONITOR as dim
where
dim.MON_FLOWING is null 
)
and dpump.FLOWING_RATE_IGPM>dpump.REC_PUMP_RATE_IGPM
)


update MOE_20240326.dbo.M_D_PUMPTEST
set
FLOWING_RATE_IGPM=null 
from 
MOE_20240326.dbo.M_D_PUMPTEST as dpump
where
dpump.INT_ID
in
(
select 
dpump.INT_ID 
from 
MOE_20240326.dbo.M_D_PUMPTEST as dpump
where
dpump.INT_ID
in 
(
select
dim.INT_ID
from 
MOE_20240326.dbo.M_D_INTERVAL_MONITOR as dim
where
dim.MON_FLOWING is null 
)
and dpump.FLOWING_RATE_IGPM>dpump.REC_PUMP_RATE_IGPM
)

--***** IMPORTANT 20131104: NO LONGER USED 

-- 20131030 there is no need to perform the remainder - the values in TblPump_Test we would
-- use to create pump_step are duplicated in TblPump_Test_Detail; ignore the remainder

-- create a pumptest step/record for the values in TblPump_Test using the PUMP_TEST_ID as
-- the key - this will have to be checked (for non-duplication)

-- note that we're converting HR and MIN into one interval of seconds due to how
-- dateadd() works; also, we're adding testtype, testlevel and testlevel_uom as placeholders

--select 
--convert(int,moept.PUMP_TEST_ID) as [PUMP_TEST_ID]
--,convert(real,moept.[Pumping_rate]) as [PUMP_RATE]
--,CONVERT(varchar(50),moept.RATE_UOM) as [PUMP_RATE_UNITS]
--,convert(real,moept.[Pumping_rate]) as [PUMP_RATE_OUOM]
--,CONVERT(varchar(50),moept.RATE_UOM) as [PUMP_RATE_UNITS_OUOM]
--,dpump.PUMPTEST_DATE as [PUMP_START]
--,DATEADD(second,
--case 
--when moept.PUMPING_DURATION_HR is not null then moept.PUMPING_DURATION_HR*3600
--else 0
--end 
--+ 
--case
--when moept.PUMPING_DURATION_MIN is not null then moept.PUMPING_DURATION_MIN*60
--else 0
--end
--,
--dpump.PUMPTEST_DATE) 
--as [PUMP_END]
--,convert(int,567) as [DATA_ID]
--,null as [SYS_RECORD_ID]
--,CONVERT(int,null) as [rnum]
--,convert(varchar(2),null) as testtype
--,convert(float,null) as testlevel
--,convert(varchar(50),null) as testlevel_uom
--from 
--[MOE_201304].dbo.TblPipe as moetp
--inner join 
--[MOE_201304].dbo.YC_20130923_BHID as ycb
--on
--moetp.Bore_Hole_ID=ycb.BORE_HOLE_ID
--inner join 
--[MOE_201304].dbo.TblPump_Test as moept
--on
--moetp.PIPE_ID=moept.PIPE_ID
--inner join 
--[MOE_201304].dbo.FM_D_PUMPTEST as dpump
--on
--moept.PUMP_TEST_ID=dpump.PUMP_TEST_ID
--inner join 
--[MOE_201304].dbo.FM_D_LOCATION as dloc
--on
--ycb.LOC_ID=dloc.LOC_ID
--inner join 
--[MOE_201304].dbo.FM_D_INTERVAL as dint
--on
--dloc.LOC_ID=dint.LOC_ID
--where 
--dloc.LOC_COORD_EASTING != -9999
--and (moept.[Pumping_rate] is not null or moept.[Pumping_rate] is not null)

--select 
--convert(int,moept.PUMP_TEST_ID) as [PUMP_TEST_ID]
--,convert(real,moept.[Pumping_rate]) as [PUMP_RATE]
--,CONVERT(varchar(50),moept.RATE_UOM) as [PUMP_RATE_UNITS]
--,convert(real,moept.[Pumping_rate]) as [PUMP_RATE_OUOM]
--,CONVERT(varchar(50),moept.RATE_UOM) as [PUMP_RATE_UNITS_OUOM]
--,dpump.PUMPTEST_DATE as [PUMP_START]
--,DATEADD(second,
--case 
--when moept.PUMPING_DURATION_HR is not null then moept.PUMPING_DURATION_HR*3600
--else 0
--end 
--+ 
--case
--when moept.PUMPING_DURATION_MIN is not null then moept.PUMPING_DURATION_MIN*60
--else 0
--end
--,
--dpump.PUMPTEST_DATE) 
--as [PUMP_END]
--,convert(int,567) as [DATA_ID]
--,null as [SYS_RECORD_ID]
--,CONVERT(int,null) as [rnum]
--,convert(varchar(2),null) as testtype
--,convert(float,null) as testlevel
--,convert(varchar(50),null) as testlevel_uom
--into
--[MOE_201304].dbo.FM_D_PUMPTEST_STEP
--from 
--[MOE_201304].dbo.TblPipe as moetp
--inner join 
--[MOE_201304].dbo.YC_20130923_BHID as ycb
--on
--moetp.Bore_Hole_ID=ycb.BORE_HOLE_ID
--inner join 
--[MOE_201304].dbo.TblPump_Test as moept
--on
--moetp.PIPE_ID=moept.PIPE_ID
--inner join 
--[MOE_201304].dbo.FM_D_PUMPTEST as dpump
--on
--moept.PUMP_TEST_ID=dpump.PUMP_TEST_ID
--inner join 
--[MOE_201304].dbo.FM_D_LOCATION as dloc
--on
--ycb.LOC_ID=dloc.LOC_ID
--inner join 
--[MOE_201304].dbo.FM_D_INTERVAL as dint
--on
--dloc.LOC_ID=dint.LOC_ID
--where 
--dloc.LOC_COORD_EASTING != -9999
--and (moept.[Pumping_rate] is not null or moept.[Pumping_rate] is not null)

-- if there is one PUMP_TEST_ID, there must only be one INT_ID; currently these
-- PUMP_TEST_IDs point to multiple INT_IDs; fix this - refer to next script file


