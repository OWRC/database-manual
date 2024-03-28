
--***** G_10_13_02

--***** Make sure units are either in ft or m for the geology in TblFormation

-- v20160531 no changes needed to be made (they were only in m and ft)
-- v20170905 mm to change 
-- v20180530 cm to change - 8 rows
-- v20190509 0 rows 
-- v20200721 5 rows (inches)
-- v20210126 0 rows
-- v20220328 0 rows
-- v20230324 0 rows
-- v20240327 0 rows

select 
ycb.LOC_ID
,moef.*
from 
MOE_20230324.dbo.YC_20230324_BH_ID as ycb
inner join MOE_20230324.dbo.TblFormation as moef
on ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID
where 
not(moef.FORMATION_END_DEPTH_UOM in ('ft','m'))
order by
ycb.LOC_ID,moef.FORMATION_TOP_DEPTH

-- if in inches, change to ft

select 
 moef.*
from 
MOE_20230324.dbo.YC_20230324_BH_ID as ycb
inner join 
MOE_20230324.dbo.TblFormation as moef
on
ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID
where 
moef.FORMATION_END_DEPTH_UOM='inch'

update MOE_20230324.dbo.TblFormation
set
 FORMATION_TOP_DEPTH=FORMATION_END_DEPTH/12
,FORMATION_END_DEPTH=FORMATION_END_DEPTH/12
,FORMATION_END_DEPTH_UOM='ft'
from 
MOE_20230324.dbo.YC_20230324_BH_ID as ycb
inner join 
MOE_20230324.dbo.TblFormation as moef
on
ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID
where 
moef.FORMATION_END_DEPTH_UOM='inch'

-- if in cm, change to m

select 
 moef.*
from 
[MOE_20230324].dbo.YC_20230324_BH_ID as ycb
inner join [MOE_20230324].dbo.TblFormation as moef
on ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID
where 
moef.FORMATION_END_DEPTH_UOM='cm'

update [MOE_20230324].dbo.TblFormation
set
 FORMATION_TOP_DEPTH=FORMATION_END_DEPTH/100
,FORMATION_END_DEPTH=FORMATION_END_DEPTH/100
,FORMATION_END_DEPTH_UOM='m'
from 
[MOE_20230324].dbo.YC_20230324_BH_ID as ycb
inner join [MOE_20230324].dbo.TblFormation as moef
on ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID
where 
moef.FORMATION_END_DEPTH_UOM='cm'

-- if in mm, change to m

select 
 moef.*
from 
MOE_20230324.dbo.YC_20230324_BH_ID as ycb
inner join MOE_20230324.dbo.TblFormation as moef
on ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID
where 
moef.FORMATION_END_DEPTH_UOM='mm'

update MOE_20230324.dbo.TblFormation
set
 FORMATION_TOP_DEPTH=FORMATION_END_DEPTH/1000
,FORMATION_END_DEPTH=FORMATION_END_DEPTH/1000
,FORMATION_END_DEPTH_UOM='m'
from 
MOE_20230324.dbo.YC_20230324_BH_ID as ycb
inner join MOE_20230324.dbo.TblFormation as moef
on ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID
where 
moef.FORMATION_END_DEPTH_UOM='mm'

--***** miscellaneous corrections

update MOE_20230324.dbo.TblFormation
set
formation_end_depth=5
where 
formation_id= 1006414320

update MOE_20230324.dbo.TblFormation
set
formation_top_depth=5
,formation_end_depth=150
where 
formation_id= 1006414321




