
--***** G_10_15_03

--***** open hole screens for D_INTERVAL_MONITOR

-- find those wells classified as open hole; a screen in an open hole is considered
-- to be from the bottom of any casing down to the bottom of the hole; these intervals
-- should not already be in d_int_form as there is no reported screen

-- check against reported screens; there should be none

-- 2017.09.05 0 rows returned
-- 2018.05.30 0 rows 
-- v20190509 0 rows
-- v20200721 0 rows 
-- v20210119 0 rows
-- v20220328 0 rows
-- v20230324 0 rows

select 
ycb.BORE_HOLE_ID
,ycdim.TMP_LOC_ID 
,moebh.*
from 
MOE_20230324.dbo.YC_20230324_BH_ID as ycb
inner join MOE_20230324.dbo.TblBore_Hole as moebh
on ycb.BORE_HOLE_ID=moebh.BORE_HOLE_ID
inner join MOE_20230324.dbo.YC_20230324_DINTMON as ycdim
on ycb.BORE_HOLE_ID=ycdim.TMP_LOC_ID
where 
moebh.OPEN_HOLE='Y'

-- how many open hole with casing; this is provided as a check
-- 1 is returned

-- 2017.09.05 0 rows returned
-- 2018.05.30 18 rows
-- v20190509 0 rows
-- v20200721 0 rows
-- v20210119 7 rows
-- v20220328 0 rows
-- v20230324 0 rows

select 
ycb.BORE_HOLE_ID 
from 
MOE_20230324.dbo.YC_20230324_BH_ID as ycb
inner join MOE_20230324.dbo.TblBore_Hole as moebh
on ycb.BORE_HOLE_ID=moebh.BORE_HOLE_ID
left outer join MOE_20230324.dbo.M_D_BOREHOLE_CONSTRUCTION as ycbc
on ycb.BORE_HOLE_ID=ycbc.BH_ID
where 
moebh.OPEN_HOLE='Y'
-- this a list of casing info
and ycbc.CON_SUBTYPE_CODE in (9,16,21,23,25,32)

-- examine the results of those wells that have casing and are considered
-- open hole

-- 2017.09.05 following was not run; 0 rows above
-- 2018.05.30 18 rows
-- v20190509 0 rows 
-- v20200721 0 rows 
-- v20210119 7 rows
-- v20220328 0 rows
-- v20230324 0 rows

select 
ycb.BORE_HOLE_ID as TMP_LOC_ID
,21 as TMP_INT_TYPE_CODE
--,cd.CASING_DEPTH as MON_TOP_OUOM
,case
when cd.CASING_DEPTH is not null then cd.CASING_DEPTH
else ycb.CON_MAX_DEPTH
end as MON_TOP_OUOM
,ycb.MAX_DEPTH_M as MON_BOT_OUOM
,'m' as MON_UNIT_OUOM
--,(ycb.MAX_DEPTH_M-cd.CASING_DEPTH) as DIFF_OPEN_HOLE
,'open hole; bottom-of-casing to bottom-of-hole' as MON_COMMENT
from 
[MOE_20230324].dbo.YC_20230324_BH_ID as ycb
inner join [MOE_20230324].dbo.TblBore_Hole as moebh
on ycb.BORE_HOLE_ID=moebh.BORE_HOLE_ID
left outer join
(
select 
cd.BH_ID
,max(CON_BOT_OUOM) as [CASING_DEPTH]
from 
(
select
ycbc.BH_ID
,case
when ycbc.CON_UNIT_OUOM='ft' then ycbc.CON_BOT_OUOM*0.3048
else ycbc.CON_BOT_OUOM 
end 
as CON_BOT_OUOM
from 
[MOE_20230324].dbo.M_D_BOREHOLE_CONSTRUCTION as ycbc
where 
ycbc.CON_SUBTYPE_CODE in (9,16,21,23,25,32)
) as cd
group by
cd.BH_ID
) as cd
on
ycb.BH_ID=cd.BH_ID
where 
moebh.OPEN_HOLE='Y'
--and (ycb.MAX_DEPTH_M-cd.CASING_DEPTH)>0

-- add these results to the temporary interval monitor table

insert into MOE_20230324.dbo.YC_20230324_DINTMON
(TMP_LOC_ID,TMP_INT_TYPE_CODE,MON_TOP_OUOM,MON_BOT_OUOM,MON_UNIT_OUOM,MON_COMMENT)
select 
ycb.BORE_HOLE_ID as TMP_LOC_ID
,21 as TMP_INT_TYPE_CODE
--,cd.CASING_DEPTH as MON_TOP_OUOM
,case
when cd.CASING_DEPTH is not null then cd.CASING_DEPTH
else ycb.CON_MAX_DEPTH
end as MON_TOP_OUOM
,ycb.MAX_DEPTH_M as MON_BOT_OUOM
,'m' as MON_UNIT_OUOM
--,(ycb.MAX_DEPTH_M-cd.CASING_DEPTH) as DIFF_OPEN_HOLE
,'open hole; bottom-of-casing to bottom-of-hole' as MON_COMMENT
from 
[MOE_20230324].dbo.YC_20230324_BH_ID as ycb
inner join [MOE_20230324].dbo.TblBore_Hole as moebh
on ycb.BORE_HOLE_ID=moebh.BORE_HOLE_ID
left outer join
(
select 
cd.BH_ID
,max(CON_BOT_OUOM) as [CASING_DEPTH]
from 
(
select
ycbc.BH_ID
,case
when ycbc.CON_UNIT_OUOM='ft' then ycbc.CON_BOT_OUOM*0.3048
else ycbc.CON_BOT_OUOM 
end 
as CON_BOT_OUOM
from 
[MOE_20230324].dbo.M_D_BOREHOLE_CONSTRUCTION as ycbc
where 
ycbc.CON_SUBTYPE_CODE in (9,16,21,23,25,32)
) as cd
group by
cd.BH_ID
) as cd
on
ycb.BH_ID=cd.BH_ID
where 
moebh.OPEN_HOLE='Y'
--and (ycb.MAX_DEPTH_M-cd.CASING_DEPTH)>0

-- Checks

select
*
from 
[MOE_20230324].dbo.YC_20230324_BH_ID as y
where 
y.bore_hole_id in
(
23052329
,23052382
,23053204
,1001482870
,1001498987
,1001600664
,1001721327
,1001721495
,1001745700
,1001745703
,1001854103
,1001854115
,1001854130
,1002025972
,1002416189
,1002809410
,1003332084
,1003492261
)

select
*
from 
[MOE_20230324].dbo.YC_20230324_DINTMON
where 
tmp_int_type_code= 21



