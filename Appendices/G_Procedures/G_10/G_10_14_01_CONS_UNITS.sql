
--***** G_10_14_01

--***** determine the maximum depth from construction

-- make sure that the units are in m or ft only; we're doing it
-- here as there is multiple inputs into the construction table

-- v20170905 all units m or ft
-- v20180530 25 rows - inch
-- v20190509 0 rows
-- v20200721 9 rows
-- v20210119 0 rows (?)
-- v20220328 3 rows
-- v20230324 0 rows

select 
ycb.LOC_ID
,ycb.BH_ID
,ycm.*
from 
MOE_20230324.dbo.YC_20230324_BH_ID as ycb
inner join MOE_20230324.dbo.M_D_BOREHOLE_CONSTRUCTION as ycm
on ycb.BORE_HOLE_ID=ycm.BH_ID
where 
not(ycm.CON_UNIT_OUOM in ('m','ft'))

-- for construction, we're assuming anything that's an inch should be a ft
-- a note is added to CON_COMMENT for this

update MOE_20230324.dbo.M_D_BOREHOLE_CONSTRUCTION
set
 CON_UNIT_OUOM='ft'
,CON_TOP_OUOM=CON_TOP_OUOM/12
,CON_BOT_OUOM=CON_BOT_OUOM/12
,CON_COMMENT='depths original indicated as inch; converted to ft'
where 
CON_UNIT_OUOM='inch'

--***** Various corrections below

select * from MOE_20230324.dbo.M_D_BOREHOLE_CONSTRUCTION where con_unit_ouom= 'cm'

update MOE_20230324.dbo.M_D_BOREHOLE_CONSTRUCTION
set
con_unit_ouom= 'm'
,con_top_ouom= con_top_ouom/10
,con_bot_ouom= con_bot_ouom/10
,con_comment=
case
when con_comment is not null then con_comment + '; Converted depths from cm to m'
else 'Converted depths from cm to m'
end
where
con_unit_ouom= 'cm'

-- for construction we're assuming anything that's a cm should be m's
-- a note is added to CON_COMMENT for this 

--update [MOE_20160531].dbo.M_D_BOREHOLE_CONSTRUCTION
--set
--CON_UNIT_OUOM='m'
--,CON_COMMENT='depths original indicated as cm; changed to m'
--where 
--CON_UNIT_OUOM='cm'