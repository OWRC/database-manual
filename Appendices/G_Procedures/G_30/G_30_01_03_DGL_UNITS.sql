
--***** G.30.01.03 D_GEOLOGY_LAYER Units

--***** Make sure units are either in ft or m for the geology in TblFormation

-- v20190509 0 rows 
-- v20200721 0 rows
-- v20210119 0 rows
-- v20220328 0 rows
-- v20230324 0 rows

select 
od.LOC_ID
,mf.*
from 
MOE_20230324.dbo.TblFormation as mf
inner join MOE_20230324.dbo.ORMGP_20230324_upd_DGL as od
on mf.bore_hole_id=od.moe_bore_hole_id
where 
not(mf.FORMATION_END_DEPTH_UOM in ('ft','m'))
order by
od.loc_id,mf.formation_top_depth

-- No rows were found in v20190509; the following will need to be updated before
-- using in subsequent MOEDB versions

-- if in inches, change to ft

--select 
-- moef.*
--from 
--[MOE_201304].dbo.YC_20130911_BHID as ycb
--inner join 
--[MOE_201304].dbo.TblFormation as moef
--on
--ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID
--where 
--moef.FORMATION_END_DEPTH_UOM='inch'

--update [MOE_201304].dbo.TblFormation
--set
-- FORMATION_TOP_DEPTH=FORMATION_END_DEPTH/12
--,FORMATION_END_DEPTH=FORMATION_END_DEPTH/12
--,FORMATION_END_DEPTH_UOM='ft'
--from 
--[MOE_201304].dbo.YC_20130911_BHID as ycb
--inner join 
--[MOE_201304].dbo.TblFormation as moef
--on
--ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID
--where 
--moef.FORMATION_END_DEPTH_UOM='inch'

-- if in cm, change to m

--select 
-- moef.*
--from 
--[MOE_20230324].dbo.YC_20230324_BH_ID as ycb
--inner join [MOE_20230324].dbo.TblFormation as moef
--on ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID
--where 
--moef.FORMATION_END_DEPTH_UOM='cm'
--
--update [MOE_20230324].dbo.TblFormation
--set
-- FORMATION_TOP_DEPTH=FORMATION_END_DEPTH/100
--,FORMATION_END_DEPTH=FORMATION_END_DEPTH/100
--,FORMATION_END_DEPTH_UOM='m'
--from 
--[MOE_20230324].dbo.YC_20230324_BH_ID as ycb
--inner join [MOE_20230324].dbo.TblFormation as moef
--on ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID
--where 
--moef.FORMATION_END_DEPTH_UOM='cm'

-- if in mm, change to m

--select 
-- moef.*
--from 
--MOE_20230324.dbo.YC_20230324_BH_ID as ycb
--inner join MOE_20230324.dbo.TblFormation as moef
--on ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID
--where 
--moef.FORMATION_END_DEPTH_UOM='mm'
--
--update MOE_20230324.dbo.TblFormation
--set
-- FORMATION_TOP_DEPTH=FORMATION_END_DEPTH/1000
--,FORMATION_END_DEPTH=FORMATION_END_DEPTH/1000
--,FORMATION_END_DEPTH_UOM='m'
--from 
--MOE_20230324.dbo.YC_20230324_BH_ID as ycb
--inner join MOE_20230324.dbo.TblFormation as moef
--on ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID
--where 
--moef.FORMATION_END_DEPTH_UOM='mm'

--***** miscellaneous corrections

--update MOE_20230324.dbo.TblFormation
--set
--formation_end_depth=5
--where 
--formation_id= 1006414320
--
--update MOE_20230324.dbo.TblFormation
--set
--formation_top_depth=5
--,formation_end_depth=150
--where 
--formation_id= 1006414321





