
--***** G_10_15_06

--***** Determine which holes are to be assigned top of bedrock to
--***** bottom of hole intervals/screens

-- top of bedrock to bottom of hole

-- 2017.09.05 1750 rows
-- 2018.05.30 4774 rows
-- v20190509 844 rows
-- v20200721 1378 rows
-- v20210119 1973 rows
-- v20220328 313 rows
-- v20230324 158 rows

select
bi.LOC_ID as tmp_LOC_ID
,22 as tmp_INT_TYPE_CODE
,bi.MON_TOP_OUOM
,case 
when ybc.MAX_DEPTH_M>bi.MON_BOT_OUOM then ybc.MAX_DEPTH_M
else bi.MON_BOT_OUOM
end 
as MON_BOT_OUOM
,'m' as MON_UNIT_OUOM
,'bedrock, no valid casing; open hole, top-of-bedrock to bottom-of-hole' as MON_COMMENT
from  
(  
select 
fmdgl.LOC_ID
,case 
when fmdgl.GEOL_UNIT_OUOM='ft' then MIN(fmdgl.GEOL_TOP_OUOM)*0.3048
else MIN(fmdgl.GEOL_TOP_OUOM)
end as MON_TOP_OUOM
,case 
when fmdgl.GEOL_UNIT_OUOM='ft' then MAX(fmdgl.GEOL_BOT_OUOM)*0.3048
else MAX(fmdgl.GEOL_BOT_OUOM)
end as MON_BOT_OUOM
from 
MOE_20230324.dbo.M_D_GEOLOGY_LAYER as fmdgl
inner join OAK_20160831_MASTER.dbo.R_GEOL_MAT1_CODE as rgmc
on fmdgl.GEOL_MAT1_CODE=rgmc.GEOL_MAT1_CODE
where 
fmdgl.LOC_ID
in
( 
select
ybc.BORE_HOLE_ID as LOC_ID
from 
MOE_20230324.dbo.YC_20230324_BH_ID as ybc
where
ybc.BORE_HOLE_ID 
not in
( select tmp_LOC_ID from MOE_20230324.dbo.YC_20230324_DINTMON )
)
and rgmc.GEOL_MAT1_ROCK=1
group by
fmdgl.LOC_ID,fmdgl.GEOL_UNIT_OUOM
) as bi
inner join MOE_20230324.dbo.YC_20230324_BH_ID as ybc
on bi.LOC_ID=ybc.BORE_HOLE_ID   


insert into MOE_20230324.dbo.YC_20230324_DINTMON
(tmp_LOC_ID,tmp_INT_TYPE_CODE,MON_TOP_OUOM,MON_BOT_OUOM,MON_UNIT_OUOM,MON_COMMENT)
select
bi.LOC_ID as tmp_LOC_ID
,22 as tmp_INT_TYPE_CODE
,bi.MON_TOP_OUOM
,case 
when ybc.MAX_DEPTH_M>bi.MON_BOT_OUOM then ybc.MAX_DEPTH_M
else bi.MON_BOT_OUOM
end 
as MON_BOT_OUOM
,'m' as MON_UNIT_OUOM
,'bedrock, no valid casing; open hole, top-of-bedrock to bottom-of-hole' as MON_COMMENT
from  
(  
select 
fmdgl.LOC_ID
,case 
when fmdgl.GEOL_UNIT_OUOM='ft' then MIN(fmdgl.GEOL_TOP_OUOM)*0.3048
else MIN(fmdgl.GEOL_TOP_OUOM)
end as MON_TOP_OUOM
,case 
when fmdgl.GEOL_UNIT_OUOM='ft' then MAX(fmdgl.GEOL_BOT_OUOM)*0.3048
else MAX(fmdgl.GEOL_BOT_OUOM)
end as MON_BOT_OUOM
from 
MOE_20230324.dbo.M_D_GEOLOGY_LAYER as fmdgl
inner join OAK_20160831_MASTER.dbo.R_GEOL_MAT1_CODE as rgmc
on fmdgl.GEOL_MAT1_CODE=rgmc.GEOL_MAT1_CODE
where 
fmdgl.LOC_ID
in
( 
select
ybc.BORE_HOLE_ID as LOC_ID
from 
MOE_20230324.dbo.YC_20230324_BH_ID as ybc
where
ybc.BORE_HOLE_ID 
not in
( select tmp_LOC_ID from MOE_20230324.dbo.YC_20230324_DINTMON )
)
and rgmc.GEOL_MAT1_ROCK=1
group by
fmdgl.LOC_ID,fmdgl.GEOL_UNIT_OUOM
) as bi
inner join MOE_20230324.dbo.YC_20230324_BH_ID as ybc
on bi.LOC_ID=ybc.BORE_HOLE_ID



