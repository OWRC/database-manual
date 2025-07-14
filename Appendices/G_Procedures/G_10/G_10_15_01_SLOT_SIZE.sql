
--***** G_10_15_01

--***** Assemble D_INTERVAL_MONITOR information

-- we're assembling d_int_mon first as we need to figure out what the 
-- interval type is before we create d_interval

-- create a look up table for the slot size; edit table changing
-- YC values to numeric only

select 
moes.Slot as MOE_SLOT
,convert(varchar(50),moes.Slot) as YC_SLOT
,cast(null as float) as CONV_YC_SLOT
from 
MOE_20250711.dbo.YC_20250711_BH_ID as ycb
inner join MOE_20250711.dbo.TblPipe as moep
on ycb.BORE_HOLE_ID=moep.Bore_Hole_ID
inner join MOE_20250711.dbo.TblScreen as moes
on moep.PIPE_ID=moes.PIPE_ID
where 
moes.SCRN_TOP_DEPTH is not null 
and moes.SCRN_END_DEPTH is not null 
group by 
moes.Slot

select 
moes.Slot as MOE_SLOT
,convert(varchar(50),moes.Slot) as YC_SLOT
,cast(null as float) as CONV_YC_SLOT
into MOE_20250711.dbo.YC_20250711_MOE_SLOT
from 
MOE_20250711.dbo.YC_20250711_BH_ID as ycb
inner join MOE_20250711.dbo.TblPipe as moep
on ycb.BORE_HOLE_ID=moep.Bore_Hole_ID
inner join MOE_20250711.dbo.TblScreen as moes
on moep.PIPE_ID=moes.PIPE_ID
where 
moes.SCRN_TOP_DEPTH is not null 
and moes.SCRN_END_DEPTH is not null 
group by 
moes.Slot

-- this table, YC_20130923_MOE_SLOT then needs to be edited
-- to conform to the YCDB slot specification which is a float
-- try running the following as a check re: conversion; note that
-- only the YC_SLOT is being converted (the MOE_SLOT stays as is
-- as part of the look-up); if the look-up table is working, no
-- errors will be returned

--***** 20190522 Used Manifold 9 to check which columns had issues
--***** 20210119 Used Manifold 9
--***** 20220328 Used Manifold 9

-- an example in this dataset is the conversion of 3/8 for the MOE
-- to a value of 0.375 for the YCDB

select
ycm.MOE_SLOT
,ycm.YC_SLOT
,cast(YC_SLOT as float) as CONV_YC_SLOT
from 
MOE_20250711.dbo.YC_20250711_MOE_SLOT as ycm

update [MOE_20250711].dbo.YC_20250711_MOE_SLOT
set
CONV_YC_SLOT=cast(YC_SLOT as float)

-- Modifications

update MOE_20250711.dbo.YC_20250711_MOE_SLOT
set
yc_slot='6'
where 
moe_slot='# 6'

update MOE_20250711.dbo.YC_20250711_MOE_SLOT
set
yc_slot='8'
where 
moe_slot='#8'

update MOE_20250711.dbo.YC_20250711_MOE_SLOT
set
yc_slot='20'
where 
moe_slot='#20'

update MOE_20250711.dbo.YC_20250711_MOE_SLOT
set
yc_slot='18'
where 
moe_slot='#18'

update MOE_20250711.dbo.YC_20250711_MOE_SLOT
set
yc_slot='10'
where 
moe_slot='#10'

update MOE_20250711.dbo.YC_20250711_MOE_SLOT
set
yc_slot='14'
where 
moe_slot='#14'

update MOE_20250711.dbo.YC_20250711_MOE_SLOT
set
yc_slot='6'
where 
moe_slot='#6'

update MOE_20250711.dbo.YC_20250711_MOE_SLOT
set
yc_slot='1'
where 
moe_slot='1-'

update MOE_20250711.dbo.YC_20250711_MOE_SLOT
set
yc_slot=null
where 
moe_slot='S/N'

update MOE_20250711.dbo.YC_20250711_MOE_SLOT
set
yc_slot='12'
where 
moe_slot='#12'







