
--***** G.30.01.03 D_GEOLOGY_LAYER Units

--***** Make sure units are either in ft or m for the geology in TblFormation

-- v20190509 0 rows 
-- v20200721 0 rows
-- v20210119 0 rows
-- v20220328 0 rows
-- v20230324 0 rows
-- v20240326 34 rows
-- v20250711 2 rows

select 
od.LOC_ID
,mf.*
from 
MOE_20250711.dbo.TblFormation as mf
inner join MOE_20250711.dbo.ORMGP_20250711_upd_DGL as od
on mf.bore_hole_id=od.moe_bore_hole_id
where 
not(mf.FORMATION_END_DEPTH_UOM in ('ft','m'))
order by
od.loc_id,mf.formation_top_depth


-- if in inches, change to ft

select 
moef.*
from 
MOE_20250711.dbo.ORMGP_20250711_upd_DGL as odgl
inner join MOE_20250711.dbo.TblFormation as moef
on odgl.moe_bore_hole_id=moef.BORE_HOLE_ID
where 
moef.FORMATION_END_DEPTH_UOM='inch'

update MOE_20250711.dbo.TblFormation
set
 FORMATION_TOP_DEPTH=FORMATION_END_DEPTH/12
,FORMATION_END_DEPTH=FORMATION_END_DEPTH/12
,FORMATION_END_DEPTH_UOM='ft'
from 
MOE_20250711.dbo.ORMGP_20250711_upd_DGL as odgl
inner join MOE_20250711.dbo.TblFormation as moef
on odgl.moe_bore_hole_id=moef.BORE_HOLE_ID
where 
moef.FORMATION_END_DEPTH_UOM='inch'



--***** is top below bottom

-- v20240326 153 rows
-- v20250711 74 rows

select 
moef.*
from 
MOE_20250711.dbo.ORMGP_20250711_upd_DGL as odgl
inner join MOE_20250711.dbo.TblFormation as moef
on odgl.moe_bore_hole_id=moef.BORE_HOLE_ID
where 
moef.formation_top_depth > moef.formation_end_depth


update MOE_20250711.dbo.TblFormation
set
formation_end_depth= formation_top_depth
,formation_top_depth= formation_end_depth
from 
MOE_20250711.dbo.ORMGP_20250711_upd_DGL as odgl
inner join MOE_20250711.dbo.TblFormation as moef
on odgl.moe_bore_hole_id=moef.BORE_HOLE_ID
where 
moef.formation_top_depth > moef.formation_end_depth



-- the following will need to be updated before
-- using in subsequent MOEDB versions

-- if in cm, change to m

--select 
-- moef.*
--from 
--[MOE_20250711].dbo.YC_20250711_BH_ID as ycb
--inner join [MOE_20250711].dbo.TblFormation as moef
--on ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID
--where 
--moef.FORMATION_END_DEPTH_UOM='cm'
--
--update [MOE_20250711].dbo.TblFormation
--set
-- FORMATION_TOP_DEPTH=FORMATION_END_DEPTH/100
--,FORMATION_END_DEPTH=FORMATION_END_DEPTH/100
--,FORMATION_END_DEPTH_UOM='m'
--from 
--[MOE_20250711].dbo.YC_20250711_BH_ID as ycb
--inner join [MOE_20250711].dbo.TblFormation as moef
--on ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID
--where 
--moef.FORMATION_END_DEPTH_UOM='cm'

-- if in mm, change to m

--select 
-- moef.*
--from 
--MOE_20250711.dbo.YC_20250711_BH_ID as ycb
--inner join MOE_20250711.dbo.TblFormation as moef
--on ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID
--where 
--moef.FORMATION_END_DEPTH_UOM='mm'
--
--update MOE_20250711.dbo.TblFormation
--set
-- FORMATION_TOP_DEPTH=FORMATION_END_DEPTH/1000
--,FORMATION_END_DEPTH=FORMATION_END_DEPTH/1000
--,FORMATION_END_DEPTH_UOM='m'
--from 
--MOE_20250711.dbo.YC_20250711_BH_ID as ycb
--inner join MOE_20250711.dbo.TblFormation as moef
--on ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID
--where 
--moef.FORMATION_END_DEPTH_UOM='mm'

--***** miscellaneous corrections

--update MOE_20250711.dbo.TblFormation
--set
--formation_end_depth=5
--where 
--formation_id= 1006414320
--
--update MOE_20250711.dbo.TblFormation
--set
--formation_top_depth=5
--,formation_end_depth=150
--where 
--formation_id= 1006414321





