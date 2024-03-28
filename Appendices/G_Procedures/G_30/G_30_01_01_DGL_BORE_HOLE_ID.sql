
--***** G.30.01.01 D_GEOLOGY_LAYER BORE_HOLE_ID

-- determine those BORE_HOLE_IDs that do not have any records in DGL

-- v20190509 1179 rows
-- v20200721 1855 rows
-- v20210119 461 rows
-- v20220328 105 rows
-- v20230324 1179 rows
-- v20240326 7949 rows

select
t.*
,t2.rcount_moe
--count(*) as rcount
into moe_20240326.dbo.ORMGP_20240326_upd_DGL
from 
(
select
dbore.loc_id
,v.moe_well_id
,v.moe_bore_hole_id
,dgl.rcount
,dloc.loc_type_code
from 
oak_20160831_master.dbo.d_borehole as dbore
inner join oak_20160831_master.dbo.d_location as dloc
on dbore.loc_id=dloc.loc_id
inner join oak_20160831_master.dbo.d_location_qa as dlqa
on dbore.loc_id=dlqa.loc_id
inner join oak_20160831_master.dbo.v_sys_agency_ypdt as yc
on dbore.loc_id=yc.loc_id
left outer join 
(
select
loc_id
,count(*) as rcount
from 
oak_20160831_master.dbo.d_geology_layer
group by 
loc_id
) as dgl
on dbore.loc_id=dgl.loc_id
inner join oak_20160831_master.dbo.v_sys_moe_locations as v
on dbore.loc_id=v.loc_id
where 
dgl.rcount is null
and dloc.loc_type_code=1
and dlqa.qa_coord_confidence_code<>117
) as t
inner join 
(
select
m.bore_hole_id
,count(*) as rcount_moe
from 
moe_20240326.dbo.tblformation as m
where 
m.mat1 is not null
and cast(m.mat1 as int)<>0
group by
bore_hole_id
) as t2
on t.moe_bore_hole_id=t2.bore_hole_id

-- check count of records

select
count(*) 
from
moe_20240326.dbo.ORMGP_20240326_upd_DGL

