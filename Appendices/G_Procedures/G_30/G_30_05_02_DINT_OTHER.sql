
--***** G.30.05.02 D_INTERVAL Other Screen Type

-- determine whether the BORE_HOLE_IDs that we've extracted have a 
-- screen other than one that was 'reported' (which was found in 
-- the previous script)

-- this is the open hole; bottom of casing to bottom of hole
-- INT_TYPE_CODE 21

-- make sure to check that the mon_top_ouom and mon_bot_ouom fields
-- are being populated; the mon_top_ouom will be null if the casing
-- depth is not known - this should be checked and corrected 
-- (not shown here)

-- v20200721 0 rows
-- v20210119 0 rows
-- v20220328 0 rows
-- v20230324 0 rows

insert into moe_20230324.dbo.ormgp_20230324_upd_dintmon
(
loc_id, tmp_int_id, tmp_int_type_code, mon_top_ouom, mon_bot_ouom, mon_unit_ouom, mon_comment
)
select
orm.LOC_ID
,orm.moe_bore_hole_id as tmp_INT_ID
,cast( 21 as int ) as tmp_INT_TYPE_CODE
,od.casing_max_depth_m as MON_TOP_OUOM
,od.max_depth_m as MON_BOT_OUOM
,cast( 'm' as varchar(50) ) as MON_UNIT_OUOM
,cast( 'open hole; bottom-of-casing to bottom-of-hole' as varchar(255) ) as MON_CMMENT
from 
moe_20230324.dbo.ormgp_20230324_base_dint as orm
inner join moe_20230324.dbo.ormgp_20230324_upd_depth as od
on orm.moe_bore_hole_id=od.moe_bore_hole_id
inner join moe_20230324.dbo.tblbore_hole as moebh
on orm.moe_bore_hole_id=moebh.bore_hole_id
where
moebh.OPEN_HOLE='Y'
and orm.moe_bore_hole_id not in
( select tmp_int_id from moe_20230324.dbo.ormgp_20230324_upd_dintmon )

select
count(*)
from 
moe_20230324.dbo.ormgp_20230324_upd_dintmon
where 
tmp_int_type_code= 21

-- top of bedrock to bottom of hole
-- INT_TYPE_CODE 22

-- note that this query can take some time to complete

-- v20200721 511 rows
-- v20210119 9 rows
-- v20220328 21 rows
-- v20230324 287

insert into moe_20230324.dbo.ormgp_20230324_upd_dintmon
(
loc_id, int_id, tmp_INT_ID, tmp_int_type_code, mon_top_ouom, mon_bot_ouom, mon_unit_ouom, mon_comment
)
select
orm.LOC_ID
,orm.INT_ID
,orm.moe_bore_hole_id as tmp_INT_ID
,cast( 22 as int ) as tmp_INT_TYPE_CODE
,t2.geol_top_m as MON_TOP_OUOM
,od.max_depth_m as MON_BOT_OUOM
,'m' as MON_UNIT_OUOM
,cast( 'bedrock, no valid casing; open hole, top-of-bedrock to bottom-of-hole' as varchar(255) ) as MON_COMMENT
from 
moe_20230324.dbo.ormgp_20230324_base_dint as orm
inner join moe_20230324.dbo.ormgp_20230324_upd_depth as od
on orm.moe_bore_hole_id=od.moe_bore_hole_id
inner join
(
select
t.moe_bore_hole_id
,min(t.geol_top_m) as geol_top_m
,max(t.geol_bot_m) as geol_bot_m
from
(
select
orm.moe_bore_hole_id
,case
when mform.formation_end_depth_uom = 'ft' then mform.formation_top_depth * 0.3048
else mform.formation_top_depth
end as geol_top_m
,case
when mform.formation_end_depth_uom = 'ft' then mform.formation_end_depth * 0.3048
else mform.formation_end_depth
end as geol_bot_m
from 
moe_20230324.dbo.ormgp_20230324_base_dint as orm
inner join moe_20230324.dbo.tblformation as mform
on orm.moe_bore_hole_id=mform.bore_hole_id
inner join oak_20160831_master.dbo.r_geol_mat1_code as rgmc
on cast( mform.mat1 as int )=rgmc.geol_mat1_code
where 
rgmc.geol_mat1_rock=1
) as t
group by
t.moe_bore_hole_id
) as t2
on orm.moe_bore_hole_id=t2.moe_bore_hole_id
where 
orm.moe_bore_hole_id not in
( select tmp_int_id from moe_20230324.dbo.ormgp_20230324_upd_dintmon )

select
count(*)
from 
moe_20230324.dbo.ormgp_20230324_upd_dintmon
where 
tmp_int_type_code= 22


-- the remainder should be considered to be overburden wells
-- INT_TYPE_CODE 19

-- only those with valid depths are considered

-- v20200721 581 rows
-- v20210119 20 rows
-- v20220328 76 rows
-- v20230324 336 rows

insert into moe_20230324.dbo.ormgp_20230324_upd_dintmon
(
loc_id, int_id, tmp_int_id, tmp_int_type_code, mon_top_ouom, mon_bot_ouom, mon_unit_ouom, mon_comment
)
select 
orm.LOC_ID
,orm.INT_ID
,orm.moe_bore_hole_id as tmp_INT_ID
,19 as tmp_INT_TYPE_CODE
,( od.max_depth_m - 0.3 ) as MON_TOP_OUOM
,od.max_depth_m as MON_BOT_OUOM
,cast( 'm' as varchar(50) ) as MON_UNIT_OUOM
,cast( 'overburden; assumed screen, 0.3m above bottom-of-hole' as varchar(255) ) as MON_COMMENT
from 
moe_20230324.dbo.ormgp_20230324_base_dint as orm
inner join moe_20230324.dbo.ormgp_20230324_upd_depth as od
on orm.moe_bore_hole_id=od.moe_bore_hole_id
where 
od.max_depth_m is not null
and orm.moe_bore_hole_id not in
( select tmp_int_id from moe_20230324.dbo.ormgp_20230324_upd_dintmon )


select
count(*)
from 
moe_20230324.dbo.ormgp_20230324_upd_dintmon
where 
tmp_int_type_code= 19




















