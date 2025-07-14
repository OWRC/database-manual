
--***** G_10_18_01

--***** Static water levels; these are located in the TblPump_Test
--***** table so we'll need to access the PIPE_ID; refer to 
--***** G_10_15_09_SCR_INT_ID_SRE.sql where this has already been done

-- check with and without the D_INTERVAL table as a check

-- 2016.05.31 6704 without, 6704 with
-- 2017.09.05 3385 without, 3385 with
-- 2018.05.30 5761 without, 5761 with; match
-- v20190509 1684 without, 1684 with; match
-- v20200721 2400 without, 2400 with; match
-- v20210119 3780 without, 3780 with; match
-- v20220328 920 without; 920 with; match
-- v20230324 707 without; 707 with; match
-- v20240326 633 without; 633 with; match
-- v20250711 602 without; 602 with; match

SELECT 
moept.[PIPE_ID]
--,dim.INT_ID 
,t1.LOC_ID
,[WELL_ID]
,[Static_lev]
,[LEVELS_UOM]
FROM MOE_20250711.[dbo].[TblPump_Test] as moept
inner join
(
select
moetp.PIPE_ID
,ycb.BORE_HOLE_ID as LOC_ID
from 
MOE_20250711.dbo.[YC_20250711_BH_ID] as ycb
inner join MOE_20250711.dbo.TblPipe as moetp
on ycb.BORE_HOLE_ID=moetp.Bore_Hole_ID
) as t1
on
moept.PIPE_ID=t1.PIPE_ID
--***** disable/enable the following
inner join MOE_20250711.dbo.M_D_INTERVAL as dim
on t1.LOC_ID=dim.LOC_ID
--*****
where
moept.Static_lev is not null 

-- as the counts match, we don't need to perform some of the following checks

---- is there a missing loc_id
--
----select
----*
----from 
----[MOE_201304].dbo.FM_D_LOCATION as dloc
----inner join 
----[MOE_201304].dbo.YC_20130923_COORDS as ycc
----on
----dloc.LOC_ID=ycc.LOC_ID
----where 
----ycc.LOC_COORD_EASTING != -9999
----and dloc.LOC_ID 
----not in
----(
----select LOC_ID from [MOE_201304].dbo.FM_D_INTERVAL
----)
--
---- no, there must be two statics for a single location; find it
--
---- no duplicate INT_ID
--
----select
----COUNT(*) 
----from 
----[MOE_20160531].dbo.M_D_INTERVAL
----group by
----INT_ID 
--
---- could there be multiple pipe_id for a single loc_id
--
---- 2016.05.31 24540 without grouping by loc_id, 24539 when grouping by loc_id (one multiple)
---- 2017.09.05 13562 with grouping, 13562 without grouping (no multiples)
---- 2018.05.30 14346 with grouping, 14346 without grouping; match, no multiples
--
--select
----moetp.PIPE_ID
--ycb.BORE_HOLE_ID
----**** enable/disable the following in conjunction with below
----,COUNT(*) as rcount
----*****
--from 
--MOE_20250711.dbo.YC_20250711_BH_ID as ycb
--inner join MOE_20250711.dbo.TblPipe as moetp
--on ycb.BORE_HOLE_ID=moetp.Bore_Hole_ID
----***** enable/disable the following
----group by
----ycb.BORE_HOLE_ID
----*****
--
--select
--*
--from 
--(
--select
----moetp.PIPE_ID
--ycb.LOC_ID
--,COUNT(*) as rcount
--from 
--[MOE_20160531].dbo.[YC_20160531_BH_ID] as ycb
--inner join [MOE_20160531].dbo.TblPipe as moetp
--on ycb.BORE_HOLE_ID=moetp.Bore_Hole_ID
--group by
--ycb.LOC_ID
--) as t1
--where 
--t1.rcount>1
--
---- LOC_IDs with multiple (2 in all cases)
---- 1005338189
---- 1 in total; this matches the disparity above
--
--select
--*
--from 
--[MOE_20160531].dbo.M_D_INTERVAL as dim
--where
--dim.LOC_ID in (1005338189)
--
---- map LOC_ID to INT_ID
---- 1005338189	1005338189
--
--select 
--moetp.* 
--,dint.INT_ID
--,cast(0 as int) as RD_TYPE_CODE
--,cast(628 as int) as RD_NAME_CODE
--,cast(null as datetime) as [RD_DATE]
--,cast(null as float) as [RD_VALUE]
--,cast(null as int) as [UNIT_CODE]
--,moept.Static_lev as [RD_VALUE_OUOM]
--,moept.LEVELS_UOM as [RD_UNIT_OUOM]
--,cast(518 as int) as DATA_ID
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
--where 
--moept.Static_lev is not null 
--and ycb.LOC_ID in (1005338189)
--
---- no rows returned, check the PIPE_ID
--
--SELECT 
--[PIPE_ID]
--,[WELL_ID]
--,[casing_number]
--,[Bore_Hole_ID]
--,[Comment]
--,[Alt_name]
--FROM [MOE_20160531].[dbo].[tblPipe]
--where
--bore_hole_id=1005338189
--
---- two rows; they appear to be duplicate; check the tblPump_Test
--
--SELECT 
--[PUMP_TEST_ID]
--,[PIPE_ID]
--,[WELL_ID]
--,[Pump_Set_at]
--,[Static_lev]
--,[Final_lev_after_pumping]
--,[Recom_depth]
--,[Pumping_rate]
--,[Flowing_rate]
--,[Recom_rate]
--,[LEVELS_UOM]
--,[RATE_UOM]
--,[WATER_STATE_AFTER_TEST]
--,[PUMPING_TEST_METHOD]
--,[PUMPING_DURATION_HR]
--,[PUMPING_DURATION_MIN]
--,[FLOWING]
--FROM [MOE_20160531].[dbo].[tblPump_Test]
--where 
--pipe_id in (1005615749,1005615940)
--
---- there are no statics
--
---- look at the casings
--
--SELECT 
--[CASING_ID]
--,[PIPE_ID]
--,[WELL_ID]
--,[LAYER]
--,[MATERIAL]
--,[DEPTH_FROM]
--,[DEPTH_TO]
--,[CASING_DIAMETER]
--,[CASING_DIAMETER_UOM]
--,[CASING_DEPTH_UOM]
--FROM [MOE_20160531].[dbo].[tblCasing]
--where 
--pipe_id in (1005615749,1005615940)

-- these appear to be duplicates
-- CASING_ID (1005615755,1005615942)

--***** if there are no checks/modifications to be made, we can carry on with the following

--***** CHANGE DATA_ID

--***** 20210119 Updated to include D_LOCATION_SPATIAL_HIST

-- lets pull the statics by INT_ID

-- 2017.09.05 3385 rows
-- 2018.05.30 5761 rows
-- v20190509 1684 rows
-- v20200721 2400 rows
-- v20210119 
-- v20240326 633 rows
-- v20250711 602 rows

select 
dint.INT_ID
,cast(0 as int) as RD_TYPE_CODE
,cast(628 as int) as RD_NAME_CODE
,dint.INT_START_DATE as [RD_DATE]
,cast(
case
when moept.LEVELS_UOM like 'ft' then delev.bh_gnd_elev-(0.3048*moept.Static_lev) 
else delev.bh_gnd_elev-moept.Static_lev 
end
as float
) as[RD_VALUE]
,cast(6 as int) as UNIT_CODE
,cast('Water Level - Manual - Static' as varchar(255)) as RD_NAME_OUOM
,cast(moept.Static_lev as float) as [RD_VALUE_OUOM]
,cast(moept.LEVELS_UOM as varchar(50)) as [RD_UNIT_OUOM]
,cast(1 as int) as [REC_STATUS_CODE]
,cast(null as varchar(255)) as RD_COMMENT
,cast(528 as int) as DATA_ID
,ROW_NUMBER() over (order by dint.INT_ID) as SYS_RECORD_ID
from 
MOE_20250711.dbo.TblPipe as moetp
inner join MOE_20250711.dbo.YC_20250711_BH_ID as ycb
on moetp.Bore_Hole_ID=ycb.BORE_HOLE_ID
inner join MOE_20250711.dbo.TblPump_Test as moept
on moetp.PIPE_ID=moept.PIPE_ID
inner join MOE_20250711.dbo.M_D_LOCATION as dloc
on ycb.BORE_HOLE_ID=dloc.LOC_ID
inner join MOE_20250711.dbo.M_D_INTERVAL as dint
on dloc.LOC_ID=dint.LOC_ID
inner join MOE_20250711.dbo.M_D_BOREHOLE as delev
on dloc.loc_id=delev.loc_id
where 
moept.Static_lev is not null 
and delev.bh_gnd_elev is not null



select 
dint.INT_ID
,cast(0 as int) as RD_TYPE_CODE
,cast(628 as int) as RD_NAME_CODE
,dint.INT_START_DATE as [RD_DATE]
,cast(
case
when moept.LEVELS_UOM like 'ft' then delev.bh_gnd_elev-(0.3048*moept.Static_lev) 
else delev.bh_gnd_elev-moept.Static_lev 
end
as float
) as[RD_VALUE]
,cast(6 as int) as UNIT_CODE
,cast('Water Level - Manual - Static' as varchar(255)) as RD_NAME_OUOM
,cast(moept.Static_lev as float) as [RD_VALUE_OUOM]
,cast(moept.LEVELS_UOM as varchar(50)) as [RD_UNIT_OUOM]
,cast(1 as int) as [REC_STATUS_CODE]
,cast(null as varchar(255)) as RD_COMMENT
,cast(528 as int) as DATA_ID
,ROW_NUMBER() over (order by dint.INT_ID) as SYS_RECORD_ID
into MOE_20250711.dbo.M_D_INTERVAL_TEMPORAL_2
from 
MOE_20250711.dbo.TblPipe as moetp
inner join MOE_20250711.dbo.YC_20250711_BH_ID as ycb
on moetp.Bore_Hole_ID=ycb.BORE_HOLE_ID
inner join MOE_20250711.dbo.TblPump_Test as moept
on moetp.PIPE_ID=moept.PIPE_ID
inner join MOE_20250711.dbo.M_D_LOCATION as dloc
on ycb.BORE_HOLE_ID=dloc.LOC_ID
inner join MOE_20250711.dbo.M_D_INTERVAL as dint
on dloc.LOC_ID=dint.LOC_ID
inner join MOE_20250711.dbo.M_D_BOREHOLE as delev
on dloc.loc_id=delev.loc_id
where 
moept.Static_lev is not null 
and delev.bh_gnd_elev is not null




-- check for duplicate INT_IDs; 

-- 2016.05.31 no duplicates
-- 2017.09.05 no duplicates
-- 2018.05.30 no duplicates
-- v20190509 0 rows 
-- v20200721 4 duplicates (8 rows)
-- v20210119 1 duplicate (2 rows)
-- v20220329 0 rows
-- v20230324 0 rows
-- v20240326 0 rows
-- v20250711 0 rows

select
*
from 
MOE_20250711.dbo.m_d_interval_temporal_2 as dit2
where
dit2.int_id
in
(
select
t1.int_id
from 
(
select
dit2.int_id
,COUNT(*) as rcount
from 
MOE_20250711.dbo.m_d_interval_temporal_2 as dit2
group by 
dit2.int_id
) as t1
where 
t1.rcount>1
)

-- remove the extraneous rows

--***** v20210119

delete from MOE_20250711.dbo.m_d_interval_temporal_2
where 
sys_record_id in ( 1548 )

--***** v20200721 

--delete from MOE_20250711.dbo.m_d_interval_temporal_2
--where 
--sys_record_id in ( 858, 913, 1723, 1774 )

--***** v201304
--delete from [MOE_201304].dbo.fm_d_interval_temporal_2 
--where 
--sys_record_id in (240289481,240289888,240290594)

