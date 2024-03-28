
--***** G.30.01.04 D_GEOLOGY_LAYER Add

--***** Assemble the D_GEOLOGY_LAYER information; additional details
--***** can be found in G.10 concerning material code reassignments

-- this can be inserted directly into OAK_20160831_MASTER.dbo.D_GEOLOGY_LAYER

-- change DATA_ID, SYS_TEMP1 and SYS_TEMP2

-- v20190509 DATA_ID 521
-- v20200721 DATA_ID 522
-- v20210119 DATA_ID 523 
-- v20220328 DATA_ID 524 
-- v20230324 DATA_ID 525
-- v20240326 DATA_ID 526

-- v20190509 3605 rows
-- v20200721 5893 rows
-- v20210119 1315 rows
-- v20220328 374 rows
-- v20230324 4012 rows
-- v20240326 24474 rows

select
od.LOC_ID
,cast( null as int ) as GEOL_ID
,cast( case
 when moef.COLOR is null or moef.COLOR=0 then null 
 else moef.COLOR 
end as int) as [GEOL_MAT_COLOUR_CODE]
,case
when moef.FORMATION_END_DEPTH_UOM='m' then ( dbore.bh_gnd_elev - moef.formation_top_depth )
else ( dbore.bh_gnd_elev - ( moef.formation_top_depth * 0.3048 ) ) 
end as GEOL_TOP_ELEV
,case
when moef.FORMATION_END_DEPTH_UOM='m' then ( dbore.bh_gnd_elev - moef.formation_end_depth ) 
else ( dbore.bh_gnd_elev - ( moef.formation_end_depth * 0.3048 ) )
end as GEOL_BOT_ELEV
,moef.FORMATION_TOP_DEPTH as GEOL_TOP_OUOM 
,moef.FORMATION_END_DEPTH as GEOL_BOT_OUOM
,cast(moef.FORMATION_END_DEPTH_UOM as varchar(20)) as GEOL_UNIT_OUOM
,moef.LAYER as GEOL_MOE_LAYER
,cast( case 
 -- check if all mat fields are null
 when moef.MAT1 is null and moef.MAT2 is null and moef.MAT3 is null then 0
 -- if mat1 is null but mat2 is not, make mat1=mat2
 when moef.MAT1 is null and moef.MAT2 is not null then moef.MAT2 
 -- if mat1 and mat2 is null but mat3 is not, make mat1=mat3
 when moef.MAT1 is null and moef.MAT2 is null and moef.MAT3 is not null then moef.MAT3 
 else moef.MAT1 
end as int) as GEOL_MAT1_CODE
,cast( case 
 -- if all mat fields are null, leave mat2 as is
 -- if mat1 is null, mat2 has been moved to mat1, return null
 -- we won't move mat3 to mat2
 when moef.MAT1 is null and moef.MAT2 is not null then null 
 else moef.MAT2 
end as int) as GEOL_MAT2_CODE
,cast( case 
 -- if mat1 and mat2 is null but mat3 is not, make mat1=mat3
 when moef.MAT1 is null and moef.MAT2 is null and moef.MAT3 is not null then null 
 else moef.MAT3 
end as int) as GEOL_MAT3_CODE
-- include some comments if we've messed about with the mat codes
,cast( case 
 when moef.MAT1 is null and moef.MAT2 is null and moef.MAT3 is null then     'No material, assigned unknown'
 when moef.MAT1 is null and moef.MAT2 is not null then                       'No mat1, assigned mat2 to mat1'
 when moef.MAT1 is null and moef.MAT2 is null and moef.MAT3 is not null then 'No mat1 or mat2, assigned mat3 to mat1'
 else null 
end as varchar(255)) as GEOL_COMMENT
,cast( 526 as int ) as DATA_ID
,'20240326g' as SYS_TEMP1
,20240326 as SYS_TEMP2
,row_number() over (order by od.loc_id) as rkey
into MOE_20240326.dbo.O_D_GEOLOGY_LAYER
from 
MOE_20240326.dbo.ORMGP_20240326_upd_DGL as od
inner join MOE_20240326.dbo.TblFormation as moef
on od.moe_bore_hole_id=moef.bore_hole_id
inner join oak_20160831_master.dbo.d_borehole as dbore
on od.loc_id=dbore.loc_id

--drop table o_d_geology_layer

-- what is the count

select
count(*) 
from 
MOE_20240326.dbo.O_D_GEOLOGY_LAYER

-- create/update the GEOL_IDs

select
od.loc_id
,od.rkey
,t2.geol_id
from 
moe_20240326.dbo.o_d_geology_layer as od
inner join
(
select
t.geol_id
,row_number() over (order by t.geol_id) as rkey
from 
(
select
top 30000
v.new_id as geol_id
from 
oak_20160831_master.dbo.v_sys_random_id_bulk_001 as v
where 
v.new_id not in
( select geol_id from oak_20160831_master.dbo.d_geology_layer )
) as t
) as t2
on od.rkey=t2.rkey

update moe_20240326.dbo.o_d_geology_layer
set
geol_id=t2.geol_id
from 
moe_20240326.dbo.o_d_geology_layer as od
inner join
(
select
t.geol_id
,row_number() over (order by t.geol_id) as rkey
from 
(
select
top 30000
v.new_id as geol_id
from 
oak_20160831_master.dbo.v_sys_random_id_bulk_001 as v
where 
v.new_id not in
( select geol_id from oak_20160831_master.dbo.d_geology_layer )
) as t
) as t2
on od.rkey=t2.rkey

-- insert these into D_GEOLOGY_LAYER

insert into oak_20160831_master.dbo.d_geology_layer
(
[LOC_ID], 
[GEOL_ID], 
[GEOL_MAT_COLOUR_CODE], 
[GEOL_TOP_ELEV], 
[GEOL_BOT_ELEV], 
[GEOL_TOP_OUOM], 
[GEOL_BOT_OUOM], 
[GEOL_UNIT_OUOM], 
[GEOL_MOE_LAYER], 
[GEOL_MAT1_CODE], 
[GEOL_MAT2_CODE], 
[GEOL_MAT3_CODE], 
[GEOL_COMMENT], 
[DATA_ID], 
[SYS_TEMP1], 
[SYS_TEMP2]
)
select
[LOC_ID], 
[GEOL_ID], 
[GEOL_MAT_COLOUR_CODE], 
[GEOL_TOP_ELEV], 
[GEOL_BOT_ELEV], 
[GEOL_TOP_OUOM], 
[GEOL_BOT_OUOM], 
[GEOL_UNIT_OUOM], 
[GEOL_MOE_LAYER], 
[GEOL_MAT1_CODE], 
[GEOL_MAT2_CODE], 
[GEOL_MAT3_CODE], 
[GEOL_COMMENT], 
[DATA_ID], 
[SYS_TEMP1], 
[SYS_TEMP2]
from 
moe_20240326.dbo.o_d_geology_layer 





