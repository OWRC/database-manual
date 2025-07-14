
--***** G_10_19_06

--***** we can now populate the D_INT_TEMP_2 table with the drawdown
--***** and recovery records of manual water levels

-- refer especially to the pumping and drawdown type codes used; the
-- name code is the same for all; we're also including a comment for
-- completeness
  
-- how many pumping (D - drawdown) and recovery (R) records are there

-- v20240326 10584 rows
-- v20250711 12345 rows

select
COUNT(*)
from 
MOE_20250711.[dbo].YC_20250711_PUMP_STEP
where
testtype is not null


-- this number should match the D and R records pulled below 

-- 2016.09.05 121106 rows
-- 2017.09.05 60260 rows
-- 2018.05.30 77415 rows
-- v20190509 31421 rows
-- v20200721 48968 rows
-- v20210119 64447 rows
-- v20220328 920 rows
-- v20230324 707 rows
-- v20240326 633 rows
-- v20250711 602 rows

-- how many records in M_D_INTERVAL_TEMPORAL_2

select 
count(*) 
from 
MOE_20250711.[dbo].[M_D_INTERVAL_TEMPORAL_2]

-- add this number to the ROW_NUMBER() to make an rkey

-- 2016.05.31 6704 rows
-- 2017.09.05 3385 rows
-- 2018.05.30 5761 rows
-- v20190509 1684 rows 
-- v20200721 2396 rows
-- v20210119 3779 rows
-- v20220328 920 rows
-- v20230324 707 rows
-- v20240326 633 rows
-- v20250711 602 rows

-- this is the base script; this should return the same number of rows
-- as YC_????????_PUMP_STEP

-- 2016.05.31 121106 rows
-- 2017.09.05 60260 rows
-- 2018.05.30 77415 rows
-- v20190509 31421 rows 
-- v20200721 
-- v20220328 11952 rows
-- v20230324 
-- v20240326 10584 rows
-- v20250711 12345 rows

--***** v20210119 Updated to include D_LOCATION_SPATIAL_HIST
--***** v20230324 disable SRTM elevations
--***** v20250711 SRTM added manually; include

select
dp.INT_ID
,case 
when dps.testtype='D' then cast(65 as int) -- i.e. moe pumping level
else cast(64 as int) -- i.e. moe recovery level
end as [RD_TYPE_CODE]
,cast(70899 as int) as [RD_NAME_CODE]  -- i.e. Water Level - Manual - Other
,dps.PUMP_END as [RD_DATE]
,case
when dps.testlevel_uom='m' then delev.loc_elev-dps.testlevel
else delev.loc_elev-(dps.testlevel*0.3048)
end as [RD_VALUE]
,cast(6 as int) as [UNIT_CODE]
,cast('Water Level - Manual - Other' as varchar(100)) as RD_NAME_OUOM
,cast(dps.testlevel as float) as RD_VALUE_OUOM
,cast(dps.testlevel_uom as varchar(50)) as RD_UNIT_OUOM
,cast(1 as int) as REC_STATUS_CODE
,case 
when dps.testtype='D' then cast('Pumping - Drawdown' as varchar(255))
else cast('Pumping - Recovery' as varchar(255))
end as [RD_COMMENT]
,dps.DATA_ID as [DATA_ID]
--***** add the number to the following row
,602 + ROW_NUMBER() over (order by dps.PUMP_END) as SYS_RECORD_ID
from 
MOE_20250711.[dbo].YC_20250711_PUMP_STEP as dps
inner join MOE_20250711.dbo.M_D_PUMPTEST as dp
on dps.PUMP_TEST_ID=dp.PUMP_TEST_ID
inner join MOE_20250711.dbo.M_D_INTERVAL as dint
on dp.INT_ID=dint.INT_ID
inner join 
(
select
dlsh.LOC_ID
,LOC_ELEV
from 
MOE_20250711.dbo.M_D_LOCATION_SPATIAL_HIST as dlsh
where
--***** 20250711 SRTM manually edited; include
dlsh.LOC_ELEV_CODE in (3,5)
---- Only load the SRTM elev if no MNR elev
--union
--select
--dlsh.LOC_ID
--,LOC_ELEV
--from 
--MOE_20250711.dbo.M_D_LOCATION_SPATIAL_HIST as dlsh
--where
--dlsh.LOC_ELEV_CODE=5
) as delev
on dint.LOC_ID=delev.LOC_ID
where
dps.testtype is not null
and delev.LOC_ELEV is not null
order by
dp.INT_ID,RD_DATE


-- insert into the d_int_temp_2 table

insert into MOE_20250711.dbo.M_D_INTERVAL_TEMPORAL_2
(
INT_ID
,RD_TYPE_CODE
,RD_NAME_CODE 
,rd_date 
,RD_VALUE
,UNIT_CODE
,RD_NAME_OUOM
,RD_VALUE_OUOM
,RD_UNIT_OUOM
,REC_STATUS_CODE
,RD_COMMENT
,DATA_ID
,SYS_RECORD_ID
)
select
dp.INT_ID
,case 
when dps.testtype='D' then cast(65 as int) -- i.e. moe pumping level
else cast(64 as int) -- i.e. moe recovery level
end as [RD_TYPE_CODE]
,cast(70899 as int) as [RD_NAME_CODE]  -- i.e. Water Level - Manual - Other
,dps.PUMP_END as [RD_DATE]
,case
when dps.testlevel_uom='m' then delev.loc_elev-dps.testlevel
else delev.loc_elev-(dps.testlevel*0.3048)
end as [RD_VALUE]
,cast(6 as int) as [UNIT_CODE]
,cast('Water Level - Manual - Other' as varchar(100)) as RD_NAME_OUOM
,cast(dps.testlevel as float) as RD_VALUE_OUOM
,cast(dps.testlevel_uom as varchar(50)) as RD_UNIT_OUOM
,cast(1 as int) as REC_STATUS_CODE
,case 
when dps.testtype='D' then cast('Pumping - Drawdown' as varchar(255))
else cast('Pumping - Recovery' as varchar(255))
end as [RD_COMMENT]
,dps.DATA_ID as [DATA_ID]
--***** add the number to the following row
,633 + ROW_NUMBER() over (order by dps.PUMP_END) as SYS_RECORD_ID
from 
MOE_20250711.[dbo].YC_20250711_PUMP_STEP as dps
inner join MOE_20250711.dbo.M_D_PUMPTEST as dp
on dps.PUMP_TEST_ID=dp.PUMP_TEST_ID
inner join MOE_20250711.dbo.M_D_INTERVAL as dint
on dp.INT_ID=dint.INT_ID
inner join 
(
select
dlsh.LOC_ID
,LOC_ELEV
from 
MOE_20250711.dbo.M_D_LOCATION_SPATIAL_HIST as dlsh
where
--***** 20250711 SRTM added manually; include both
dlsh.LOC_ELEV_CODE in (3,5)
---- Only load the SRTM elev if no MNR elev
--union
--select
--dlsh.LOC_ID
--,LOC_ELEV
--from 
--MOE_20250711.dbo.M_D_LOCATION_SPATIAL_HIST as dlsh
--where
--dlsh.LOC_ELEV_CODE=5
) as delev
on dint.LOC_ID=delev.LOC_ID
where
dps.testtype is not null
and delev.LOC_ELEV is not null
order by
dp.INT_ID,RD_DATE









