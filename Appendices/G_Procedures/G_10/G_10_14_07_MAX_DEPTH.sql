
--**** G_10_14_07

--***** Determine the MAX_DEPTH_M

-- check if the depth units are not m or ft; none of these should return rows

-- v20170905 0 rows returned for all
-- v20180530 0 rows 
-- v20190509 0 rows for all
-- v20200721 0 rows for all
-- v20210119 0 rows for all
-- v20220328 0 rows for all
-- v20230324 0 rows for all
-- v20240326 0 rows

select 
 ycb.*
from 
MOE_20240326.dbo.YC_20240326_BH_ID as ycb
where 
ycb.FM_MAX_DEPTH_UNITS is not null 
--and not(ycb.FM_MAX_DEPTH_UNITS in ('ft','m'))
--and not(ycb.MOE_MAX_DEPTH_UNITS in ('ft','m'))
and not(ycb.CON_MAX_DEPTH_UNITS in ('ft','m'))

-- determine the ultimate, maximum depth

-- v20170905 13150 rows updated
-- v20180530 13948 rows
-- v20190509 7409 rows
-- v20200721 9804 rows
-- v20210119 20425 rows
-- v20220328 6128 rows
-- v20230324 6416 rows
-- v20240326 8429 rows

select
depths.BORE_HOLE_ID
,max(depths.adepth) as [MAX_DEPTH_M]
from 
(
(
select
ycb.BORE_HOLE_ID
,ycb.FM_MAX_DEPTH as adepth
from 
MOE_20240326.dbo.YC_20240326_BH_ID as ycb
where ycb.FM_MAX_DEPTH is not null
)
union
(
select
 ycb.BORE_HOLE_ID
,ycb.MOE_MAX_DEPTH as adepth
from 
MOE_20240326.dbo.YC_20240326_BH_ID as ycb
where ycb.MOE_MAX_DEPTH is not null
)
union 
(
select
 ycb.BORE_HOLE_ID
,ycb.CON_MAX_DEPTH as adepth
from 
MOE_20240326.dbo.YC_20240326_BH_ID as ycb
where CON_MAX_DEPTH is not null
)
) as depths
group by
depths.BORE_HOLE_ID

-- v20170905 13150 rows updated
-- v20180530 13948 rows
-- v20190509 7409 rows
-- v20200721 9804 rows
-- v20210119 20425 rows
-- v20220328 6128 rows
-- v20230324 6416 rows
-- v20240326 8429 rows

update MOE_20240326.dbo.YC_20240326_BH_ID
set
MAX_DEPTH_M=md.MAX_DEPTH_M
from 
MOE_20240326.dbo.YC_20240326_BH_ID as ycb
inner join 
(
select
depths.BORE_HOLE_ID
,max(depths.adepth) as [MAX_DEPTH_M]
from 
(
(
select
ycb.BORE_HOLE_ID
,ycb.FM_MAX_DEPTH as adepth
from 
MOE_20240326.dbo.YC_20240326_BH_ID as ycb
where ycb.FM_MAX_DEPTH is not null
)
union
(
select
ycb.BORE_HOLE_ID
,ycb.MOE_MAX_DEPTH as adepth
from 
MOE_20240326.dbo.YC_20240326_BH_ID as ycb
where ycb.MOE_MAX_DEPTH is not null
)
union 
(
select
ycb.BORE_HOLE_ID
,ycb.CON_MAX_DEPTH as adepth
from 
MOE_20240326.dbo.YC_20240326_BH_ID as ycb
where ycb.CON_MAX_DEPTH is not null
)
) as depths
group by
depths.BORE_HOLE_ID
) as md
on ycb.BORE_HOLE_ID=md.BORE_HOLE_ID

-- which of our locations doesn't have a depth applied

-- v20160531 ~4202 rows before looking at the possible max depths, below; 4171 after
-- v20170905 4035 rows before looking at the possible max depths, below; 4024 after
-- v20180530 1630 rows (before); 1603 after
-- v20190509 4442 rows (before); 4421 after
-- v20200721 1956 rows (before); 
-- v20210119 4194 rows (before); 4146 rows (after)
-- v20220328 9107 rows (before); 9095 rows (after)
-- v20230324 12410 rows (before); 
-- v20240326 14702 rows (before); 14700 (after)

select 
ycb.BORE_HOLE_ID
from 
MOE_20240326.dbo.YC_20240326_BH_ID as ycb
where
ycb.MAX_DEPTH_M is null 

-- are there alternate locations from which we can pull depths
-- try the M_D_GEOLOGY_FEATURE; 

-- v20160531 8 returned; this was the last one examined re: possible max depths
-- v20170905 0 returned
-- v20180531 0 rows
-- v20190509 0 rows
-- v20200721 0 rows 
-- v20210119 0 rows
-- v20220328 0 rows
-- v20230324 0 rows
-- v20240326 0 rows

select
y.BORE_HOLE_ID
,y.MAX_DEPTH_M
,t.depth_m
--update MOE_20240326.dbo.YC_20160531_BH_ID
--set
--MAX_DEPTH_M=t.depth_m
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
inner join
(
select
test.LOC_ID
,max(test.depth) as depth_m
from
(
SELECT 
LOC_ID
,case
 when FEATURE_UNIT_OUOM='ft' then FEATURE_TOP_OUOM*0.3048
 else FEATURE_TOP_OUOM 
 end as [depth]
FROM MOE_20240326.[dbo].[M_D_GEOLOGY_FEATURE]
) as test
where
test.depth is not null
and test.LOC_ID in
(
select 
ycb.loc_id  
from 
MOE_20240326.dbo.YC_20240326_BH_ID as ycb
where 
MAX_DEPTH_M is null
)
group by
loc_id 
) as t
on y.BORE_HOLE_ID=t.LOC_ID

-- screen information; are there any depths

-- v20160531 9 returned
-- v20170905 1 returned
-- v20180530 0 rows
-- v20190509 0 rows
-- v20200721 0 rows 
-- v20210119 3 rows 
-- v20220328 0 rows
-- v20230324 0 rows
-- v20240326 0 rows

select
ycb.BORE_HOLE_ID
,moescr.SCRN_TOP_DEPTH
,moescr.SCRN_END_DEPTH
,case
 when moescr.SCRN_DEPTH_UOM='ft' then moescr.SCRN_END_DEPTH*0.3048
 else moescr.SCRN_END_DEPTH
 end as [depth_m]
from 
MOE_20240326.dbo.TblScreen as moescr
inner join MOE_20240326.dbo.TblPipe as moepip
on moescr.PIPE_ID=moepip.PIPE_ID
inner join MOE_20240326.dbo.YC_20240326_BH_ID as ycb
on moepip.Bore_Hole_ID=ycb.BORE_HOLE_ID
where
ycb.MAX_DEPTH_M is null
and moescr.SCRN_END_DEPTH is not null

-- v20200721 0 rows
-- v20210119 3 rows
-- v20220328 0 rows
-- v20230324 0 rows
-- v20240326 0 rows

select
y.LOC_ID
,y.MAX_DEPTH_M
,t.depth_m
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
inner join
(
select
ycb.BORE_HOLE_ID
,moescr.SCRN_TOP_DEPTH
,moescr.SCRN_END_DEPTH
,case
 when moescr.SCRN_DEPTH_UOM='ft' then moescr.SCRN_END_DEPTH*0.3048
 else moescr.SCRN_END_DEPTH
 end as [depth_m]
from 
MOE_20240326.dbo.TblScreen as moescr
inner join MOE_20240326.dbo.TblPipe as moepip
on moescr.PIPE_ID=moepip.PIPE_ID
inner join MOE_20240326.dbo.YC_20240326_BH_ID as ycb
on moepip.Bore_Hole_ID=ycb.BORE_HOLE_ID
where
ycb.MAX_DEPTH_M is null
and moescr.SCRN_END_DEPTH is not null
) as t
on y.BORE_HOLE_ID=t.BORE_HOLE_ID

-- v20240326 0 rows

update MOE_20240326.dbo.YC_20240326_BH_ID
set
MAX_DEPTH_M=t.depth_m
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
inner join
(
select
ycb.BORE_HOLE_ID
,moescr.SCRN_TOP_DEPTH
,moescr.SCRN_END_DEPTH
,case
 when moescr.SCRN_DEPTH_UOM='ft' then moescr.SCRN_END_DEPTH*0.3048
 else moescr.SCRN_END_DEPTH
 end as [depth_m]
from 
MOE_20240326.dbo.TblScreen as moescr
inner join MOE_20240326.dbo.TblPipe as moepip
on moescr.PIPE_ID=moepip.PIPE_ID
inner join MOE_20240326.dbo.YC_20240326_BH_ID as ycb
on moepip.Bore_Hole_ID=ycb.BORE_HOLE_ID
where
ycb.MAX_DEPTH_M is null
and moescr.SCRN_END_DEPTH is not null
) as t
on y.BORE_HOLE_ID=t.BORE_HOLE_ID


-- try the level at which the pump was set for pumping tests

-- v20160531 16 returned
-- v20170905 7 returned
-- v20180530 16 rows 
-- v20190509 7 rows
-- v20200721 5 rows
-- v20210119 16 rows
-- v20220328 5 rows
-- v20230324 0 rows
-- v20240326 0 rows

select
y.LOC_ID
,y.MAX_DEPTH_M
,t.depth_m
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
inner join
(
select
ycc.BORE_HOLE_ID
,case
 when moepum.LEVELS_UOM='ft' then moepum.Pump_Set_at*0.3048
 else moepum.Pump_Set_at 
 end as [depth_m]
from 
MOE_20240326.[dbo].[TblPump_Test] as moepum
inner join MOE_20240326.dbo.TblPipe as moepip
on moepum.PIPE_ID=moepip.PIPE_ID
inner join MOE_20240326.dbo.YC_20240326_BH_ID as ycc
on moepip.Bore_Hole_ID=ycc.BORE_HOLE_ID
where
ycc.MAX_DEPTH_M is null
and moepum.Pump_Set_at is not null
) as t
on y.BORE_HOLE_ID=t.BORE_HOLE_ID


update MOE_20240326.dbo.YC_20240326_BH_ID
set
MAX_DEPTH_M=t.depth_m
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
inner join
(
select
ycc.BORE_HOLE_ID
,case
 when moepum.LEVELS_UOM='ft' then moepum.Pump_Set_at*0.3048
 else moepum.Pump_Set_at 
 end as [depth_m]
from 
MOE_20240326.[dbo].[TblPump_Test] as moepum
inner join MOE_20240326.dbo.TblPipe as moepip
on moepum.PIPE_ID=moepip.PIPE_ID
inner join MOE_20240326.dbo.YC_20240326_BH_ID as ycc
on moepip.Bore_Hole_ID=ycc.BORE_HOLE_ID
where
ycc.MAX_DEPTH_M is null
and moepum.Pump_Set_at is not null
) as t
on y.BORE_HOLE_ID=t.BORE_HOLE_ID

-- examine water depths

-- v20170905 3 rows returned
-- v20180530 11 rows returned
-- v20190509 14 rows 
-- v20200721 10 rows
-- v20210119 29 rows
-- v20220328 7 rows
-- v20230324 16 rows
-- v20240326 2 rows

select
y.LOC_ID
,y.MAX_DEPTH_M
,t.depth_m
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
inner join
(
select 
ycc.BORE_HOLE_ID
,case
 when moewat.water_found_depth_uom='ft' then moewat.water_found_depth*0.3048
 else moewat.water_found_depth
 end as depth_m
from 
MOE_20240326.dbo.TblWater as moewat
inner join MOE_20240326.dbo.TblPipe as moepip
on moewat.PIPE_ID=moepip.PIPE_ID
inner join MOE_20240326.dbo.YC_20240326_BH_ID as ycc
on moepip.Bore_Hole_ID=ycc.BORE_HOLE_ID
where
ycc.MAX_DEPTH_M is null
and moewat.water_found_depth is not null
) as t
on y.BORE_HOLE_ID=t.BORE_HOLE_ID
where 
t.depth_m>0


update MOE_20240326.dbo.YC_20240326_BH_ID
set
MAX_DEPTH_M=t.depth_m
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
inner join
(
select 
ycc.BORE_HOLE_ID
,case
 when moewat.water_found_depth_uom='ft' then moewat.water_found_depth*0.3048
 else moewat.water_found_depth
 end as depth_m
from 
MOE_20240326.dbo.TblWater as moewat
inner join MOE_20240326.dbo.TblPipe as moepip
on moewat.PIPE_ID=moepip.PIPE_ID
inner join MOE_20240326.dbo.YC_20240326_BH_ID as ycc
on moepip.Bore_Hole_ID=ycc.BORE_HOLE_ID
where
ycc.MAX_DEPTH_M is null
and moewat.water_found_depth is not null
) as t
on y.BORE_HOLE_ID=t.BORE_HOLE_ID
where
t.depth_m>0 


