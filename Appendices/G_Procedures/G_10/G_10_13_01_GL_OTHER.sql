
--***** G_10_13_01

--***** Correct the TblFormation fields/values: change (27,other) to (0,unknown)

select
moef.MAT1 
from 
MOE_20250711.dbo.YC_20250711_BH_ID as ycb
inner join MOE_20250711.dbo.TblFormation as moef
on ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID
where 
moef.MAT1=27

update MOE_20250711.dbo.TblFormation
set
MAT1=0
from 
MOE_20250711.dbo.YC_20250711_BH_ID as ycb
inner join MOE_20250711.dbo.TblFormation as moef
on ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID
where 
moef.MAT1=27  

select
 moef.MAT2
from 
MOE_20250711.dbo.YC_20250711_BH_ID as ycb
inner join MOE_20250711.dbo.TblFormation as moef
on ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID
where 
moef.MAT2=27

update MOE_20250711.dbo.TblFormation
set
MAT2=0
from 
MOE_20250711.dbo.YC_20250711_BH_ID as ycb
inner join MOE_20250711.dbo.TblFormation as moef
on ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID
where 
moef.MAT2=27  

select
moef.MAT3
from 
MOE_20250711.dbo.YC_20250711_BH_ID as ycb
inner join MOE_20250711.dbo.TblFormation as moef
on ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID
where 
moef.MAT3=27

update MOE_20250711.dbo.TblFormation
set
MAT3=0
from 
MOE_20250711.dbo.YC_20250711_BH_ID as ycb
inner join MOE_20250711.dbo.TblFormation as moef
on ycb.BORE_HOLE_ID=moef.BORE_HOLE_ID
where 
moef.MAT3=27  

