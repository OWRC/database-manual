
--***** G_10_01_02B

--***** Determine which WELL_IDs need to be added based upon a NULL Zone using
--***** the County Code to check placement within the ORMGP study area

-- v20190509 possibly two rows match this criteria, not added
-- v20200721 possibly 43 rows match this criteria, not added at this time
-- v20210119 43 rows, not added at this time
-- v20220328 43 rows, not added at this time
-- v20230324 not examined as only z17/18 locations were examined
-- v20240326 not examined as only z17/18 locations were examined

select
b.well_id
,v.loc_id
,b.east83
,b.north83
from 
MOE_20220328.dbo.[tblBore_Hole] as b
inner join MOE_20220328.dbo.[tblWWR] as w
on b.well_id=w.well_id
left outer join oak_20160831_master.dbo.v_sys_moe_locations as v
on cast(b.well_id as int)=v.moe_well_id
where 
b.zone is null
and b.east83 is not null
and b.north83 is not null
and cast(w.[COUNTY] as int) in (49,37,57,43,67,68,51,55,48,22,27,19,45,28,42,29,69,17,25,65,64,53)
and v.loc_id is null


