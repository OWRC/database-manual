
--***** G_10_13_03

--***** Assemble the D_GEOLOGY_LAYER information; refer to the 
--***** write-up for details concerning material code reassignments

-- assemble the D_GEOL_LAY table; 

-- v20170905 approx 29000 rows returned
-- v20180530 34050 rows
-- v20190509 19071 rows
-- v20200721 25005 rows
-- v20210126 49283 rows
-- v20220328 14034 rows
-- v20230324 14014 rows
-- v20240327 19366 rows

select
-- note that we're substituting the BORE_HOLE_ID for LOC_ID
ycb.BORE_HOLE_ID as LOC_ID
,case
 when moef.COLOR is null or moef.COLOR=0 then null 
 else moef.COLOR 
end 
as [GEOL_MAT_COLOUR_CODE]
,moef.FORMATION_TOP_DEPTH as GEOL_TOP_OUOM 
,moef.FORMATION_END_DEPTH as GEOL_BOT_OUOM
,moef.FORMATION_END_DEPTH_UOM as GEOL_UNIT_OUOM
,moef.LAYER as GEOL_MOE_LAYER
,case 
 -- check if all mat fields are null
 when moef.MAT1 is null and moef.MAT2 is null and moef.MAT3 is null then 0
 -- if mat1 is null but mat2 is not, make mat1=mat2
 when moef.MAT1 is null and moef.MAT2 is not null then moef.MAT2 
 -- if mat1 and mat2 is null but mat3 is not, make mat1=mat3
 when moef.MAT1 is null and moef.MAT2 is null and moef.MAT3 is not null then moef.MAT3 
 else moef.MAT1 
end as GEOL_MAT1_CODE
,case 
 -- if all mat fields are null, leave mat2 as is
 -- if mat1 is null, mat2 has been moved to mat1, return null
 -- we won't move mat3 to mat2
 when moef.MAT1 is null and moef.MAT2 is not null then null 
 else moef.MAT2 
end as GEOL_MAT2_CODE
,case 
 -- if mat1 and mat2 is null but mat3 is not, make mat1=mat3
 when moef.MAT1 is null and moef.MAT2 is null and moef.MAT3 is not null then null 
 else moef.MAT3 
end as GEOL_MAT3_CODE
-- include some comments if we've messed about with the mat codes
,case 
 when moef.MAT1 is null and moef.MAT2 is null and moef.MAT3 is null then     'No material, assigned unknown'
 when moef.MAT1 is null and moef.MAT2 is not null then                       'No mat1, assigned mat2 to mat1'
 when moef.MAT1 is null and moef.MAT2 is null and moef.MAT3 is not null then 'No mat1 or mat2, assigned mat3 to mat1'
 else null 
end as GEOL_COMMENT
,ROW_NUMBER() over (order by ycb.LOC_ID) as SYS_RECORD_ID
from 
MOE_20240326.dbo.YC_20240326_BH_ID as ycb
inner join MOE_20240326.dbo.TblFormation as moef
on ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID

select
-- note that we're substituting the BORE_HOLE_ID for LOC_ID
ycb.BORE_HOLE_ID as LOC_ID
,case
 when moef.COLOR is null or moef.COLOR=0 then null 
 else moef.COLOR 
end 
as [GEOL_MAT_COLOUR_CODE]
,moef.FORMATION_TOP_DEPTH as GEOL_TOP_OUOM 
,moef.FORMATION_END_DEPTH as GEOL_BOT_OUOM
,moef.FORMATION_END_DEPTH_UOM as GEOL_UNIT_OUOM
,moef.LAYER as GEOL_MOE_LAYER
,case 
 -- check if all mat fields are null
 when moef.MAT1 is null and moef.MAT2 is null and moef.MAT3 is null then 0
 -- if mat1 is null but mat2 is not, make mat1=mat2
 when moef.MAT1 is null and moef.MAT2 is not null then moef.MAT2 
 -- if mat1 and mat2 is null but mat3 is not, make mat1=mat3
 when moef.MAT1 is null and moef.MAT2 is null and moef.MAT3 is not null then moef.MAT3 
 else moef.MAT1 
end as GEOL_MAT1_CODE
,case 
 -- if all mat fields are null, leave mat2 as is
 -- if mat1 is null, mat2 has been moved to mat1, return null
 -- we won't move mat3 to mat2
 when moef.MAT1 is null and moef.MAT2 is not null then null 
 else moef.MAT2 
end as GEOL_MAT2_CODE
,case 
 -- if mat1 and mat2 is null but mat3 is not, make mat1=mat3
 when moef.MAT1 is null and moef.MAT2 is null and moef.MAT3 is not null then null 
 else moef.MAT3 
end as GEOL_MAT3_CODE
-- include some comments if we've messed about with the mat codes
,case 
 when moef.MAT1 is null and moef.MAT2 is null and moef.MAT3 is null then     'No material, assigned unknown'
 when moef.MAT1 is null and moef.MAT2 is not null then                       'No mat1, assigned mat2 to mat1'
 when moef.MAT1 is null and moef.MAT2 is null and moef.MAT3 is not null then 'No mat1 or mat2, assigned mat3 to mat1'
 else null 
end as GEOL_COMMENT
,ROW_NUMBER() over (order by ycb.LOC_ID) as SYS_RECORD_ID
into MOE_20240326.dbo.M_D_GEOLOGY_LAYER
from 
MOE_20240326.dbo.YC_20240326_BH_ID as ycb
inner join MOE_20240326.dbo.TblFormation as moef
on ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID



