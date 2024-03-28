
--***** G_10_15_02

--***** Reported screens in D_INTERVAL_MONITOR

-- create the reported screens where we have, at the least, a top and bottom
-- depth specified; note that we're 'parking' the INT_TYPE_CODE here - this is
-- not actually part of the D_INTERVAL_MONITOR table (it's in D_INTERVAL)
  
-- the substitution of the 'left outer join' with the 'inner join' as indicated
-- should return the same number of records so long as there is a 1-to-1 
-- relationship

-- 2016.06.31 both times a value 15312 rows was returned 
-- 2017.09.05 8622 rows
-- 2018.05.30 6314 rows
-- v20190509 5111 rows
-- v20200721 6697 rows
-- v20210119 14052 rows
-- v20220328 4772 rows
-- v20230326? 5419 rows
-- v20240326 6985 rows
 
select 
ycb.BORE_HOLE_ID as TMP_LOC_ID 
,18 as tmp_INT_TYPE_CODE
,moeslot.CONV_YC_SLOT as MON_SCREEN_SLOT
,moes.SCRN_MATERIAL as MON_SCREEN_MATERIAL
,moes.SCRN_DIAMETER as MON_DIAMETER_OUOM
,moes.SCRN_DIAMETER_UOM as MON_DIAMETER_UNIT_OUOM
,moes.SCRN_TOP_DEPTH as MON_TOP_OUOM
,moes.SCRN_END_DEPTH as MON_BOT_OUOM
,moes.SCRN_DEPTH_UOM as MON_UNIT_OUOM
,cast(null as varchar(255)) as MON_COMMENT
from 
MOE_20240326.dbo.YC_20240326_BH_ID as ycb
inner join 
--left outer join
MOE_20240326.dbo.TblPipe as moep
on ycb.BORE_HOLE_ID=moep.Bore_Hole_ID
inner join
--left outer join
MOE_20240326.dbo.TblScreen as moes
on moep.PIPE_ID=moes.PIPE_ID
left outer join
MOE_20240326.dbo.YC_20240326_MOE_SLOT as moeslot
on moes.Slot=moeslot.MOE_SLOT
where 
moes.SCRN_TOP_DEPTH is not null 
or moes.SCRN_END_DEPTH is not null 


select 
ycb.BORE_HOLE_ID as TMP_LOC_ID 
,18 as tmp_INT_TYPE_CODE
,moeslot.CONV_YC_SLOT as MON_SCREEN_SLOT
,moes.SCRN_MATERIAL as MON_SCREEN_MATERIAL
,moes.SCRN_DIAMETER as MON_DIAMETER_OUOM
,moes.SCRN_DIAMETER_UOM as MON_DIAMETER_UNIT_OUOM
,moes.SCRN_TOP_DEPTH as MON_TOP_OUOM
,moes.SCRN_END_DEPTH as MON_BOT_OUOM
,moes.SCRN_DEPTH_UOM as MON_UNIT_OUOM
,cast(null as varchar(255)) as MON_COMMENT
into MOE_20240326.dbo.YC_20240326_DINTMON
from 
MOE_20240326.dbo.YC_20240326_BH_ID as ycb
inner join 
--left outer join
MOE_20240326.dbo.TblPipe as moep
on ycb.BORE_HOLE_ID=moep.Bore_Hole_ID
inner join
--left outer join
MOE_20240326.dbo.TblScreen as moes
on moep.PIPE_ID=moes.PIPE_ID
left outer join
MOE_20240326.dbo.YC_20240326_MOE_SLOT as moeslot
on moes.Slot=moeslot.MOE_SLOT
where 
moes.SCRN_TOP_DEPTH is not null 
or moes.SCRN_END_DEPTH is not null





