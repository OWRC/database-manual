
--***** G_10_12_01

--***** Assemble D_GEOLOGY_FEATURE information (water found)

-- we'll load the rows even if no depths are found; we'll use this as a 
-- marker in case someone will update it at a later time

-- v20200731 7253 rows
-- v20210126 15401 rows

select
y.BORE_HOLE_ID as LOC_ID
,case
when moew.kind is null or moew.kind=0 then null -- not specified
else moew.kind                                  -- matches YC codes
end 
as [FEATURE_CODE]
,'Water Found' as [FEATURE_DESCRIPTION]
,moew.WATER_FOUND_DEPTH as [FEATURE_TOP_OUOM]
,moew.WATER_FOUND_DEPTH_UOM as [FEATURE_UNIT_OUOM]
,ROW_NUMBER() over (order by y.LOC_ID) as [SYS_RECORD_ID]
from 
MOE_20210119.dbo.YC_20210119_BH_ID as y
inner join MOE_20210119.dbo.TblPipe as moep
on y.BORE_HOLE_ID=moep.Bore_Hole_ID
inner join MOE_20210119.[dbo].[TblWater] as moew
on moep.PIPE_ID=moew.PIPE_ID

select
y.BORE_HOLE_ID as LOC_ID
,case
when moew.kind is null or moew.kind=0 then null -- not specified
else moew.kind                                  -- matches YC codes
end 
as [FEATURE_CODE]
,'Water Found' as [FEATURE_DESCRIPTION]
,moew.WATER_FOUND_DEPTH as [FEATURE_TOP_OUOM]
,moew.WATER_FOUND_DEPTH_UOM as [FEATURE_UNIT_OUOM]
,ROW_NUMBER() over (order by y.LOC_ID) as [SYS_RECORD_ID]
into MOE_20210119.dbo.M_D_GEOLOGY_FEATURE
from 
MOE_20210119.dbo.YC_20210119_BH_ID as y
inner join MOE_20210119.dbo.TblPipe as moep
on y.BORE_HOLE_ID=moep.Bore_Hole_ID
inner join MOE_20210119.[dbo].[TblWater] as moew
on moep.PIPE_ID=moew.PIPE_ID


--drop table moe_20210119.dbo.m_d_geology_feature



