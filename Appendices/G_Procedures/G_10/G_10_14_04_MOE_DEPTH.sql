
--***** G_10_14_04

--***** Determine the MOE reported maximum depth

-- don't forget to check record counts in the case that multiple units
-- are used in specifying the depths (the group by includes the unit so 
-- this information will be separated out)

-- v20170905 no non- ft or m units
-- v20180530 0 rows
-- v20190509 0 rows
-- v20200721 0 rows
-- v20210119 0 rows
-- v20220328 0 rows
-- v20230324 0 rows
-- v20240326 0 rows
-- v20250711 0 rows 

select
moeh.Bore_Hole_ID
,max(moeh.Depth_to) as MOE_MAX_DEPTH
,moeh.HOLE_DEPTH_UOM as MOE_MAX_DEPTH_UNITS
,COUNT(*) as rcount
from 
MOE_20250711.dbo.TblHole as moeh
inner join MOE_20250711.dbo.YC_20250711_BH_ID as ycb
on moeh.Bore_Hole_ID=ycb.BORE_HOLE_ID
where 
moeh.Depth_to is not null
and MOE_MAX_DEPTH_UNITS not in ('ft','m')
group by 
moeh.Bore_Hole_ID,moeh.HOLE_DEPTH_UOM
order by
rcount desc,BORE_HOLE_ID

-- check that we're not returning multiple counts per borehole

-- v20190905 0 rows returned
-- v20180530 0 rows returned
-- v20190509 0 rows returned
-- v20200721 0 rows
-- v20210119 0 rows
-- v20220328 0 rows
-- v20240326 0 rows
-- v20250711 0 rows

select
urc.Bore_Hole_ID
,urc.rcount
from 
(
select
crc.Bore_Hole_ID
,COUNT(*) as rcount
from 
(
select
moeh.Bore_Hole_ID
,max(moeh.Depth_to) as MOE_MAX_DEPTH
,moeh.HOLE_DEPTH_UOM as MOE_MAX_DEPTH_UNITS
from 
MOE_20250711.dbo.TblHole as moeh
inner join MOE_20250711.dbo.YC_20250711_BH_ID as ycb
on moeh.Bore_Hole_ID=ycb.BORE_HOLE_ID
where 
moeh.Depth_to is not null
group by 
moeh.Bore_Hole_ID,moeh.HOLE_DEPTH_UOM
) as crc
group by 
crc.Bore_Hole_ID
) as urc
where urc.rcount>1

-- update the fields

-- v20170905 10630 rows updated
-- v20180530 96644 rows udpated
-- v20190509 5974 rows updated
-- v20200721 8014 rows
-- v20210119 16390 rows
-- v20220328 4789 rows
-- v20240324 7036 rows
-- v20250711 5917 rows

update MOE_20250711.dbo.YC_20250711_BH_ID
set
MOE_MAX_DEPTH=moe_depth.MOE_MAX_DEPTH
,MOE_MAX_DEPTH_UNITS=moe_depth.MOE_MAX_DEPTH_UNITS
from 
MOE_20250711.dbo.YC_20250711_BH_ID as ycbh
inner join 
(
select
 moeh.Bore_Hole_ID
,max(moeh.Depth_to) as MOE_MAX_DEPTH
,moeh.HOLE_DEPTH_UOM as MOE_MAX_DEPTH_UNITS
from 
MOE_20250711.dbo.TblHole as moeh
inner join MOE_20250711.dbo.YC_20250711_BH_ID as ycb
on moeh.Bore_Hole_ID=ycb.BORE_HOLE_ID
where 
moeh.Depth_to is not null
group by 
moeh.Bore_Hole_ID,moeh.HOLE_DEPTH_UOM
) as moe_depth
on
ycbh.BORE_HOLE_ID=moe_depth.Bore_Hole_ID


