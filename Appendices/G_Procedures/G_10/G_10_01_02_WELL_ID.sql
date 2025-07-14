
--***** G_10_01_02

--***** Determine which WELL_IDs need to be added and create an existence table
--***** listing those wells; ~768401 well_ids in original db; note that for the
--***** list of missing WELL_ID's, we're also using NULL ZONE, EAST83 and NORTH83
--***** for exclusion of rows; note also that we're adding in a counter to 
--***** allow the possibility of combining info later

--***** v20230502
--***** V_SYS_MOE_LOCATIONS now (?) incorporates a call to
--***** V_SYS_MOE_LOCATIONS_DLA to include all possible MOE locations

--***** v20210119
--***** Note that the use of V_SYS_MOE_LOCATIONS should be reevaluated during
--***** the next import; this import bypassed this section; the correction for
--***** doing so used the V_SYS_MOE_WELL_ID_DLA view instead; the previous only
--***** pulled those locations in the ORMGPDB that had a LOC_TYPE_CODE of '1',
--***** the latter does not (i.e. the former would not include those tagged for
--***** archive, error or as an upgrade); reevaluate during the next import
 
select
 distinct(missing.WELL_ID)
--,ROW_NUMBER() over (order by missing.WELL_ID) as [rnum]
,cast(null as int) as well_id_rnum
from 
(
  select 
   tbh.WELL_ID
  ,v.LOC_ID
  ,tbh.ZONE
  ,tbh.EAST83
  ,tbh.NORTH83
  from 
  MOE_20250711.dbo.TblBore_Hole as tbh
  left outer join OAK_20160831_MASTER.dbo.V_SYS_MOE_LOCATIONS as v
  on cast(tbh.WELL_ID as int)=v.MOE_WELL_ID
) as missing
inner join MOE_20250711.dbo.YC_20250711_LOC_COORD_OUOM_CODE as yccode
on missing.ZONE=yccode.ZONE
where 
missing.LOC_ID is null 
and yccode.ZONE is not null
and ( yccode.zone= 17 or yccode.zone= 18 )
and missing.EAST83 is not null 
and missing.NORTH83 is not null
--order by 
--missing.WELL_ID


select
 distinct(missing.WELL_ID)
--,ROW_NUMBER() over (order by missing.WELL_ID) as [rnum]
,cast(null as int) as well_id_rnum
into MOE_20250711.dbo.YC_20250711_WELL_ID_AVAIL
from 
(
  select 
   tbh.WELL_ID
  ,v.LOC_ID
  ,tbh.ZONE
  ,tbh.EAST83
  ,tbh.NORTH83
  from 
  MOE_20250711.dbo.TblBore_Hole as tbh
  left outer join OAK_20160831_MASTER.dbo.V_SYS_MOE_LOCATIONS as v
  on cast(tbh.WELL_ID as int)=v.MOE_WELL_ID
) as missing
inner join MOE_20250711.dbo.YC_20250711_LOC_COORD_OUOM_CODE as yccode
on missing.ZONE=yccode.ZONE
where 
missing.LOC_ID is null 
and yccode.ZONE is not null
and ( yccode.zone= 17 or yccode.zone= 18 )
and missing.EAST83 is not null 
and missing.NORTH83 is not null

-- v201304    
-- v20160521 345756 WELL_IDs not in ycdb
-- v20170905 348529 WELL_IDs not in ycdb (now using V_SYS_MOE_LOCATIONS)
-- v20180530 343016 WELL_IDs not in ycdb
-- v20190509 350473 WELL_IDs not in ormgpdb
-- v20200721 360213 WELL_IDs not in ormgpdb
-- v20210119 367677 WELL_IDs not in ormgpdb
-- v20220328 366060 WELL_IDs not in ormgpdb
-- v20230324 18826  WELL_IDs not in ormgpdb (note that this comparison has been reduced to z17/18 due to data import error for tblBore_Hole)
-- v20240326 372071
-- v20250711 308998

select
count(*)
from 
MOE_20250711.dbo.YC_20250711_WELL_ID_AVAIL

DROP TABLE "dbo"."YC_20250711_WELL_ID_AVAIL"


