
--***** G.30.05.01 D_INTERVAL BORE_HOLE_ID

-- determine those BORE_HOLE_IDs that do not have any records/screens in D_INTERVAL
-- these are the report screens

-- get all the affected BORE_HOLE_IDs

--***** 20190612 This needs to be updated to only examine those intervals
--***** which are a 'screen' type (for boreholes); the initial run-through of
--***** this process did not do so

drop table ORMGP_20250711_base_DINT

-- v20200721 30088 rows
-- v20210119 28339 rows
-- v20220328 35587
-- v20230324 34225
-- v20240326 43328
-- v20250711 53453

select
t.*
,dint.int_id
into moe_20250711.dbo.ORMGP_20250711_base_DINT
from 
(
select
dbore.loc_id
,v.moe_bore_hole_id
from 
oak_20160831_master.dbo.d_borehole as dbore
inner join oak_20160831_master.dbo.d_location as dloc
on dbore.loc_id=dloc.loc_id
inner join oak_20160831_master.dbo.d_location_qa as dlqa
on dbore.loc_id=dlqa.loc_id
--inner join oak_20160831_master.dbo.v_sys_agency_ypdt as yc
--on dbore.loc_id=yc.loc_id
inner join oak_20160831_master.dbo.d_location_summary as yc
on dbore.loc_id=yc.loc_id
--inner join oak_20160831_master.dbo.v_sys_moe_locations as v
inner join ORMGP_20250711_MOE_LOCNS as v
on dbore.loc_id=v.loc_id
left outer join oak_20160831_master.dbo.d_interval as dint
on dbore.loc_id=dint.loc_id
where 
yc.ormgp_area is not null
and (dint.int_id is null or dint.int_type_code=28)
and dloc.loc_type_code=1
and dlqa.qa_coord_confidence_code<>117
and v.moe_bore_hole_id is not null
group by
dbore.loc_id,v.moe_bore_hole_id
) as t
left outer join oak_20160831_master.dbo.d_interval as dint
on t.loc_id=dint.loc_id

select
count(*)
from 
moe_20250711.dbo.ORMGP_20250711_base_DINT


-- get those that actually have reported screens; this creates the dintmon table

-- v20190509 2152 rows
-- v20200721 1697 rows
-- v20210119 445 rows
-- v20220328 92 rows
-- v20230324 925
-- v20240328 7278
-- v20250711 2860

select 
d.LOC_ID
,d.INT_ID
,d.moe_bore_hole_id as TMP_INT_ID
,18 as tmp_INT_TYPE_CODE
,moeslot.CONV_YC_SLOT as MON_SCREEN_SLOT
,moes.SCRN_MATERIAL as MON_SCREEN_MATERIAL
,moes.SCRN_DIAMETER as MON_DIAMETER_OUOM
,moes.SCRN_DIAMETER_UOM as MON_DIAMETER_UNIT_OUOM
,moes.SCRN_TOP_DEPTH as MON_TOP_OUOM
,moes.SCRN_END_DEPTH as MON_BOT_OUOM
,moes.SCRN_DEPTH_UOM as MON_UNIT_OUOM
,cast(null as varchar(255)) as MON_COMMENT
into moe_20250711.dbo.ORMGP_20250711_upd_DINTMON
from 
moe_20250711.dbo.ORMGP_20250711_base_DINT as d
inner join 
MOE_20250711.dbo.TblPipe as moep
on d.moe_bore_hole_id=moep.Bore_Hole_ID
inner join
MOE_20250711.dbo.TblScreen as moes
on moep.PIPE_ID=moes.PIPE_ID
left outer join
MOE_20250711.dbo.YC_20250711_MOE_SLOT as moeslot
on moes.Slot=moeslot.MOE_SLOT
where 
moes.SCRN_TOP_DEPTH is not null 
or moes.SCRN_END_DEPTH is not null

select
count(*) 
from 
moe_20250711.dbo.ORMGP_20250711_upd_DINTMON

drop table moe_20250711.dbo.ORMGP_20250711_upd_DINTMON

