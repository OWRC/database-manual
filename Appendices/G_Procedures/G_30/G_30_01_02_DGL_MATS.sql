
--***** G.30.01.02 D_GEOLOGY_LAYER Materials

--***** Correct the TblFormation fields/values: change (27,other) to (0,unknown)

-- v20190509 85 rows
-- v20200721 228 rows
-- v20210119 47 rows
-- v20220328 2 rows
-- v20230324 91 rows
-- v20240326 1907 rows
-- v20250711 511 rows

select
mf.MAT1 
from 
MOE_20250711.dbo.TblFormation as mf
inner join MOE_20250711.dbo.ORMGP_20250711_upd_DGL as od
on mf.bore_hole_id=od.moe_bore_hole_id
where 
mf.MAT1=27

update MOE_20250711.dbo.TblFormation
set
MAT1=0
from 
MOE_20250711.dbo.TblFormation as mf
inner join MOE_20250711.dbo.ORMGP_20250711_upd_DGL as od
on mf.bore_hole_id=od.moe_bore_hole_id
where 
mf.MAT1=27

-- v20190509 2 rows
-- v20200721 11 rows
-- v20210119 17 rows
-- v20220328 0 rows
-- v20230324 18 rows
-- v20240326 135 rows
-- v20250711 78 rows

select
mf.MAT2
from 
MOE_20250711.dbo.TblFormation as mf
inner join MOE_20250711.dbo.ORMGP_20250711_upd_DGL as od
on mf.bore_hole_id=od.moe_bore_hole_id
where 
mf.MAT2=27

update MOE_20250711.dbo.TblFormation
set
MAT2=0
from 
MOE_20250711.dbo.TblFormation as mf
inner join MOE_20250711.dbo.ORMGP_20250711_upd_DGL as od
on mf.bore_hole_id=od.moe_bore_hole_id
where 
mf.MAT2=27

-- v20190509 1 rows
-- v20200721 7 rows
-- v20210119 24 rows
-- v20220328 0 rows
-- v20230324 7 rows
-- v20240326 402 rows
-- v20250711 219 rows

select
mf.MAT3
from 
MOE_20250711.dbo.TblFormation as mf
inner join MOE_20250711.dbo.ORMGP_20250711_upd_DGL as od
on mf.bore_hole_id=od.moe_bore_hole_id
where 
mf.MAT3=27

update MOE_20250711.dbo.TblFormation
set
MAT3=0
from 
MOE_20250711.dbo.TblFormation as mf
inner join MOE_20250711.dbo.ORMGP_20250711_upd_DGL as od
on mf.bore_hole_id=od.moe_bore_hole_id
where 
mf.MAT3=27


