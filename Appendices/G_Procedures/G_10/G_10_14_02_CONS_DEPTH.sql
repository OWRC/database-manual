
--***** G_10_14_02

--***** now we can calculate the depths based upon the construction details

select 
ycm.BH_ID
,max(ycm.CON_BOT_OUOM) as [CON_MAX_DEPTH]
,ycm.CON_UNIT_OUOM as CON_MAX_DEPTH_UNITS
,COUNT(*) as rcount
from 
MOE_20240326.dbo.YC_20240326_BH_ID as ycb
inner join MOE_20240326.dbo.M_D_BOREHOLE_CONSTRUCTION as ycm
on ycb.BORE_HOLE_ID=ycm.BH_ID
group by
ycm.BH_ID,ycm.CON_UNIT_OUOM

-- v20170905 13550 rows updated
-- v20180530 14096 rows updated
-- v20190509 7894 rows updated
-- v20200721 9845 rows
-- v20210119 20755 rows
-- v20220328 6231 rows
-- v20230324 8682 rows

update MOE_20240326.dbo.YC_20240326_BH_ID 
set 
CON_MAX_DEPTH=yccon.CON_MAX_DEPTH
,CON_MAX_DEPTH_UNITS=yccon.CON_MAX_DEPTH_UNITS
from 
MOE_20240326.dbo.YC_20240326_BH_ID as ycb
inner join
(
select 
ycm.BH_ID
,max(ycm.CON_BOT_OUOM) as [CON_MAX_DEPTH]
,ycm.CON_UNIT_OUOM as CON_MAX_DEPTH_UNITS
,COUNT(*) as rcount
from 
MOE_20240326.dbo.YC_20240326_BH_ID as ycb
inner join MOE_20240326.dbo.M_D_BOREHOLE_CONSTRUCTION as ycm
on ycb.BORE_HOLE_ID=ycm.BH_ID
group by
ycm.BH_ID,ycm.CON_UNIT_OUOM
) as yccon
on
ycb.BORE_HOLE_ID=yccon.BH_ID


