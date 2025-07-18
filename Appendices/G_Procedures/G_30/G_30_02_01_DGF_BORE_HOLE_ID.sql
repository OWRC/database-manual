

--***** G.30.02.01 D_GEOLOGY_FEATURE BORE_HOLE_ID

-- determine those BORE_HOLE_IDs that do not have any records in DGF

-- note that we've indexed the appropriate fields in tblWater and tblPipe

create unique nonclustered index
pipe_id_x
on tblpipe
( pipe_id )

create nonclustered index
well_id_x
on tblpipe
( well_id )

create nonclustered index
bh_id_x
on tblpipe
( bore_hole_id )

create nonclustered index
pipe_id_x
on tblwater
( pipe_id )

create nonclustered index
well_id_x
on tblwater
( well_id )

select 
loc_id
,moe_well_id
,moe_bore_hole_id 
into ORMGP_20250711_MOE_LOCNS
from 
oak_20160831_master.dbo.v_sys_moe_locations

create nonclustered index
lid_x
on ORMGP_20250711_MOE_LOCNS
( loc_id )

create nonclustered index
bhid_x
on ORMGP_20250711_MOE_LOCNS
( moe_bore_hole_id )

create nonclustered index
well_id_x
on ORMGP_20250711_MOE_LOCNS
( moe_well_id )

-- v20190509 6850 rows
-- v20200721 2699 rows
-- v20210119 307 rows
-- v20220328 146 rows
-- v20230324 1182 rows
-- v20240326 3352 rows
-- v20250711 3168 rows

drop table moe_20250711.dbo.ormgp_20250711_upd_dgf

-- v20210119 Time to Run: 663 seconds
-- v20240326 Time to Run: 662 seconds
-- v20250711 Time to Run: a few seconds after the MOE_LOCNS table is created and referenced


select
t.*
,t2.rcount_moe
--count(*) as rcount
into moe_20250711.dbo.ORMGP_20250711_upd_DGF
from 
(
select
dbore.loc_id
,v.moe_well_id
,v.moe_bore_hole_id
,dgl.rcount
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
left outer join 
(
select
loc_id
,count(*) as rcount
from 
oak_20160831_master.dbo.d_geology_feature
group by 
loc_id
) as dgl
on dbore.loc_id=dgl.loc_id
inner join ORMGP_20250711_MOE_LOCNS as v
--inner join oak_20160831_master.dbo.v_sys_moe_locations as v
on dbore.loc_id=v.loc_id
where 
yc.ormgp_area is not null
and dgl.rcount is null
and dloc.loc_type_code=1
and dlqa.qa_coord_confidence_code<>117
and v.moe_bore_hole_id is not null
) as t
inner join 
(
select
moep.bore_hole_id
,count(*) as rcount_moe
from 
MOE_20250711.dbo.TblPipe as moep
inner join MOE_20250711.[dbo].[TblWater] as moew
on moep.PIPE_ID=moew.PIPE_ID
group by
moep.bore_hole_id
) as t2
on t.moe_bore_hole_id=t2.bore_hole_id

-- count

select
count(*) 
from 
moe_20250711.dbo.ORMGP_20250711_upd_DGF



