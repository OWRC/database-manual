
--***** G_10_14_06

--***** Determine the MAX_DEPTH_M

-- backup the existing table (in case of mistake)

select
*
into MOE_20230324.dbo.YC_20230324_BH_ID_bckup
from 
MOE_20230324.dbo.YC_20230324_BH_ID

-- make all the units m's; note that none of these should be null

----***** FM Depths

-- v20170905 7915 rows
-- v20180530 ???
-- v20190509 4699 rows 
-- v20200721 6409 rows
-- v20210119 11161 rows
-- v20230324 3493 rows
 
select
ycb.LOC_ID
,ycb.FM_MAX_DEPTH*0.3048 as FM_MAX_DEPTH_M
,ycb.FM_MAX_DEPTH_UNITS
from 
MOE_20230324.dbo.YC_20230324_BH_ID as ycb
where 
ycb.FM_MAX_DEPTH_UNITS='ft'
and ycb.FM_MAX_DEPTH is not null

-- v20170905 7915 rows updated 
-- v20180530 8551 rows 
-- v20190509 
-- v20200721 6409
-- v20210119 11161 rows
-- v20220328 3062 rows
-- v20230324 3493 rows

update MOE_20230324.dbo.YC_20230324_BH_ID
set
FM_MAX_DEPTH=FM_MAX_DEPTH*0.3048
,FM_MAX_DEPTH_UNITS='m'
where 
FM_MAX_DEPTH_UNITS='ft'
and FM_MAX_DEPTH is not null

-- v20170905 0 rows
-- v20180530 ???
-- v20190509 0 rows
-- v20200721 0 rows
-- v20210119 0 rows
-- v20220328 0 rows
-- v20230324 0 rows

select
*
from 
MOE_20230324.dbo.YC_20230324_BH_ID
where 
FM_MAX_DEPTH is null
and FM_MAX_DEPTH_UNITS is not null

----***** MOE Depths

-- v20170905 8983 rows
-- v20180530 ???
-- v20190509 4997 rows
-- v20200721 6743 rows
-- v20210119 11496 rows
-- v20220328 3291 rows
-- v20230324 0 rows

select
ycb.LOC_ID
,ycb.MOE_MAX_DEPTH*0.3048 as MOE_MAX_DEPTH_M
,ycb.MOE_MAX_DEPTH_UNITS
from 
MOE_20230324.dbo.YC_20230324_BH_ID as ycb
where 
ycb.MOE_MAX_DEPTH_UNITS='ft'
and ycb.MOE_MAX_DEPTH is not null

-- v20170905 8983 rows updated
-- v20180530 7089 rows
-- v20190509 4997 rows
-- v20200721 6743 rows
-- v20210119 11496 rows
-- v20220328 3291 rows
-- v20230324 0 rows

update MOE_20230324.dbo.YC_20230324_BH_ID
set
MOE_MAX_DEPTH=MOE_MAX_DEPTH*0.3048
,MOE_MAX_DEPTH_UNITS='m'
where 
MOE_MAX_DEPTH_UNITS='ft'
and MOE_MAX_DEPTH is not null

-- v20170905 0 rows
-- v20180530 0 rows
-- v20190509 0 rows
-- v20200721 0 rows
-- v20210119 0 rows
-- v20220328 0 rows
-- v20230324 0 rows

select
*
from 
MOE_20230324.dbo.YC_20230324_BH_ID
where 
MOE_MAX_DEPTH is null
and MOE_MAX_DEPTH_UNITS is not null

----***** CON Depths

-- v20170905 10628 rows
-- v20180530 ??? 
-- v20190509 5856 rows
-- v20200721 7549 rows
-- v20210119 13689 rows
-- v20220328 3711 rows
-- v20230324 4078 rows

select
ycb.LOC_ID
,ycb.CON_MAX_DEPTH*0.3048 as CON_MAX_DEPTH_M
,ycb.CON_MAX_DEPTH_UNITS
from 
MOE_20230324.dbo.YC_20230324_BH_ID as ycb
where 
ycb.CON_MAX_DEPTH_UNITS='ft'
and ycb.CON_MAX_DEPTH is not null

-- v20170905 10628 rows updated
-- v20180530 10237 rows
-- v20190509 5856 rows
-- v20200721 7549 rows
-- v20210119 13689 rows
-- v20220328 3711 rows
-- v20230324 4078 rows

update MOE_20230324.dbo.YC_20230324_BH_ID
set
CON_MAX_DEPTH=CON_MAX_DEPTH*0.3048
,CON_MAX_DEPTH_UNITS='m'
where 
CON_MAX_DEPTH_UNITS='ft'
and CON_MAX_DEPTH is not null

-- v20170905 562 rows
-- v20180530 573 rows
-- v20190509 598 rows
-- v20200721 240 rows
-- v20210119 666 rows
-- v20220328 138 rows
-- v20230324 138 rows

select
*
from 
MOE_20230324.dbo.YC_20230324_BH_ID
where 
CON_MAX_DEPTH is null
and CON_MAX_DEPTH_UNITS is not null



