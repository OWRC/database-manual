
--***** G.30.04.01 DEPTHS BORE_HOLE_ID

-- determine those BORE_HOLE_IDs that do not have any depths recorded
-- in D_BOREHOLE; note that we're adding additional fields we'll 
-- populate in subsequent steps

-- v20200721 17109 rows
-- v20210119 19269 rows
-- v20220328 24996
-- v20230324 20447
-- v20240326 31090
-- v20250711 38652

select
dbore.loc_id
,v.moe_bore_hole_id
,cast(null as float) as fm_max_depth_m
,cast(null as float) as dgf_max_depth_m
,cast(null as float) as casing_max_depth_m
,cast(null as float) as dbc_max_depth_m
,cast(null as float) as moe_max_depth_m
,cast(null as float) as max_depth_m
into moe_20250711.dbo.ORMGP_20250711_upd_DEPTH
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
where 
yc.ormgp_area is not null
and dbore.bh_bottom_ouom is null
and dloc.loc_type_code=1
and dlqa.qa_coord_confidence_code<>117
and v.moe_bore_hole_id is not null
group by
dbore.loc_id,v.moe_bore_hole_id

--drop table moe_20250711.dbo.ORMGP_20250711_upd_DEPTH

select
count(*)
from 
moe_20250711.dbo.ORMGP_20250711_upd_DEPTH

--select
--dbore.loc_id
--,v.moe_bore_hole_id
--,cast(null as float) as fm_max_depth_m
--,cast(null as float) as dgf_max_depth_m
--,cast(null as float) as dbc_max_depth_m
--,cast(null as float) as moe_max_depth_m
--,cast(null as float) as max_depth_m
--into moe_20250711.dbo.ORMGP_20250711_upd_DEPTH
--from 
--oak_20160831_master.dbo.d_borehole as dbore
--inner join oak_20160831_master.dbo.d_location as dloc
--on dbore.loc_id=dloc.loc_id
--inner join oak_20160831_master.dbo.d_location_qa as dlqa
--on dbore.loc_id=dlqa.loc_id
--inner join oak_20160831_master.dbo.v_sys_agency_ypdt as yc
--on dbore.loc_id=yc.loc_id
--inner join oak_20160831_master.dbo.v_sys_moe_locations as v
--on dbore.loc_id=v.loc_id
--where 
--dbore.bh_bottom_ouom is null
--and dloc.loc_type_code=1
--and dlqa.qa_coord_confidence_code<>117
--and v.moe_bore_hole_id is not null
--group by
--dbore.loc_id,v.moe_bore_hole_id

-- create the table 

-- determine the maximum depth from the formation info; note that
-- we're adding additional fields we'll populate in subsequent steps

-- v20200721 3252 rows
-- v20210119 5111 rows
-- v20220328 3226 
-- v20230324 1646
-- v20240326 9963
-- v20250711 5013 

update moe_20250711.dbo.ormgp_20250711_upd_depth
set
fm_max_depth_m= t2.fm_max_depth_m
from 
moe_20250711.dbo.ormgp_20250711_upd_depth as orm2
inner join
(
select
t.moe_bore_hole_id
,max(t.fm_end_depth) as fm_max_depth_m
from
(
select
orm.moe_bore_hole_id
,case
when moe.[FORMATION_END_DEPTH_UOM]='ft' then moe.[FORMATION_END_DEPTH]*0.3048
else moe.[FORMATION_END_DEPTH]
end as fm_end_depth
from 
moe_20250711.dbo.ORMGP_20250711_upd_DEPTH as orm
inner join moe_20250711.dbo.tblformation as moe
on orm.moe_bore_hole_id=moe.bore_hole_id
) as t
group by 
t.moe_bore_hole_id
) as t2
on orm2.moe_bore_hole_id=t2.moe_bore_hole_id

--update moe_20250711.dbo.ormgp_20250711_upd_depth
--set
--fm_max_depth_m= t2.fm_max_depth_m
--from 
--moe_20250711.dbo.ormgp_20250711_upd_depth as orm2
--inner join
--(
--select
--t.moe_bore_hole_id
--,max(t.fm_end_depth) as fm_max_depth_m
--from
--(
--select
--orm.moe_bore_hole_id
--,case
--when moe.[FORMATION_END_DEPTH_UOM]='ft' then moe.[FORMATION_END_DEPTH]*0.3048
--else moe.[FORMATION_END_DEPTH]
--end as fm_end_depth
--from 
--moe_20250711.dbo.ORMGP_20250711_upd_DEPTH as orm
--inner join moe_20250711.dbo.tblformation as moe
--on orm.moe_bore_hole_id=moe.bore_hole_id
--) as t
--group by 
--t.moe_bore_hole_id
--) as t2
--on orm2.moe_bore_hole_id=t2.moe_bore_hole_id

-- check the casing top- and bottom-depth inverted

-- v20200721 7196 rows
-- v20210119 7484 rows
-- v20220328 7517 
-- v20230324 7624 
-- v20240326 8067
-- v20250711 8294 

update moe_20250711.dbo.tblcasing
set
depth_from=depth_to
,depth_to=depth_from
where 
depth_from>depth_to

-- determine the maximum depth from the construction info

-- v20200721 6299 rows
-- v20210119 6705 rows
-- v20220328 4883 
-- v20230324 2014
-- v20240326 12194
-- v20250711 6755 

update moe_20250711.dbo.ormgp_20250711_upd_depth
set
dbc_max_depth_m= t2.dbc_max_depth_m
from 
moe_20250711.dbo.ormgp_20250711_upd_depth as orm
inner join
(
select
t.moe_bore_hole_id
,max(t.dbc_depth) as dbc_max_depth_m
from 
(
select
orm.moe_bore_hole_id
,case
when mcase.casing_depth_uom = 'ft' then mcase.depth_to * 0.3048
else mcase.depth_to
end as dbc_depth
from 
moe_20250711.dbo.ormgp_20250711_upd_depth as orm
inner join moe_20250711.dbo.tblbore_hole as mbore
on orm.moe_bore_hole_id=mbore.bore_hole_id
inner join moe_20250711.dbo.tblcasing as mcase
on mbore.well_id collate database_default = mcase.well_id collate database_default
union all
select
orm.moe_bore_hole_id
,case
when mplug.plug_depth_uom = 'ft' then mplug.plug_to * 0.3048
else mplug.plug_to
end as dbc_depth
from 
moe_20250711.dbo.ormgp_20250711_upd_depth as orm
inner join moe_20250711.dbo.tblplug as mplug
on orm.moe_bore_hole_id=mplug.bore_hole_id
union all
select
orm.moe_bore_hole_id
,case
when mscr.scrn_depth_uom = 'ft' then mscr.scrn_end_depth * 0.3048
else mscr.scrn_end_depth
end as dbc_depth
from 
moe_20250711.dbo.ormgp_20250711_upd_depth as orm
inner join moe_20250711.dbo.tblbore_hole as mbore
on orm.moe_bore_hole_id=mbore.bore_hole_id
inner join moe_20250711.dbo.tblscreen as mscr
on mbore.well_id collate database_default = mscr.well_id collate database_default
union all
select
orm.moe_bore_hole_id
,case
when mpump.levels_uom = 'ft' then mpump.recom_depth * 0.3048
else mpump.recom_depth
end as dbc_depth
from 
moe_20250711.dbo.ormgp_20250711_upd_depth as orm
inner join moe_20250711.dbo.tblbore_hole as mbore
on orm.moe_bore_hole_id=mbore.bore_hole_id
inner join moe_20250711.dbo.tblpump_test as mpump
on mbore.well_id collate database_default = mpump.well_id collate database_default
) as t
group by
t.moe_bore_hole_id
) as t2
on orm.moe_bore_hole_id=t2.moe_bore_hole_id

--update moe_20250711.dbo.ormgp_20250711_upd_depth
--set
--dbc_max_depth_m= t2.dbc_max_depth_m
--from 
--moe_20250711.dbo.ormgp_20250711_upd_depth as orm
--inner join
--(
--select
--t.moe_bore_hole_id
--,max(t.dbc_depth) as dbc_max_depth_m
--from 
--(
--select
--orm.moe_bore_hole_id
--,case
--when mcase.casing_depth_uom = 'ft' then mcase.depth_to * 0.3048
--else mcase.depth_to
--end as dbc_depth
--from 
--moe_20250711.dbo.ormgp_20250711_upd_depth as orm
--inner join moe_20250711.dbo.tblbore_hole as mbore
--on orm.moe_bore_hole_id=mbore.bore_hole_id
--inner join moe_20250711.dbo.tblcasing as mcase
--on mbore.well_id=mcase.well_id
--union all
--select
--orm.moe_bore_hole_id
--,case
--when mplug.plug_depth_uom = 'ft' then mplug.plug_to * 0.3048
--else mplug.plug_to
--end as dbc_depth
--from 
--moe_20250711.dbo.ormgp_20250711_upd_depth as orm
--inner join moe_20250711.dbo.tblplug as mplug
--on orm.moe_bore_hole_id=mplug.bore_hole_id
--union all
--select
--orm.moe_bore_hole_id
--,case
--when mscr.scrn_depth_uom = 'ft' then mscr.scrn_end_depth * 0.3048
--else mscr.scrn_end_depth
--end as dbc_depth
--from 
--moe_20250711.dbo.ormgp_20250711_upd_depth as orm
--inner join moe_20250711.dbo.tblbore_hole as mbore
--on orm.moe_bore_hole_id=mbore.bore_hole_id
--inner join moe_20250711.dbo.tblscreen as mscr
--on mbore.well_id=mscr.well_id
--union all
--select
--orm.moe_bore_hole_id
--,case
--when mpump.levels_uom = 'ft' then mpump.recom_depth * 0.3048
--else mpump.recom_depth
--end as dbc_depth
--from 
--moe_20250711.dbo.ormgp_20250711_upd_depth as orm
--inner join moe_20250711.dbo.tblbore_hole as mbore
--on orm.moe_bore_hole_id=mbore.bore_hole_id
--inner join moe_20250711.dbo.tblpump_test as mpump
--on mbore.well_id=mpump.well_id
--) as t
--group by
--t.moe_bore_hole_id
--) as t2
--on orm.moe_bore_hole_id=t2.moe_bore_hole_id

-- now do the casing separately

-- v20200721 6008 rows
-- v20210119 6328 rows
-- v20220328 4450 
-- v20230324 1858
-- v20240326 10886
-- v20250711 5513

update moe_20250711.dbo.ormgp_20250711_upd_depth
set
casing_max_depth_m= t2.casing_max_depth_m
from 
moe_20250711.dbo.ormgp_20250711_upd_depth as orm
inner join
(
select
t.moe_bore_hole_id
,max(t.dbc_depth) as casing_max_depth_m
from 
(
select
orm.moe_bore_hole_id
,case
when mcase.casing_depth_uom = 'ft' then mcase.depth_to * 0.3048
else mcase.depth_to
end as dbc_depth
from 
moe_20250711.dbo.ormgp_20250711_upd_depth as orm
inner join moe_20250711.dbo.tblbore_hole as mbore
on orm.moe_bore_hole_id=mbore.bore_hole_id
inner join moe_20250711.dbo.tblcasing as mcase
on mbore.well_id collate database_default = mcase.well_id collate database_default
) as t
group by 
t.moe_bore_hole_id
) as t2
on orm.moe_bore_hole_id=t2.moe_bore_hole_id


-- determine the maximum depth from the geology features

-- v20200721 5756 rows
-- v20210119 5881 rows
-- v20220328 4155 
-- v20230324 1554 
-- v20240326 4897
-- v20250711 3611 

update moe_20250711.dbo.ormgp_20250711_upd_depth
set
dgf_max_depth_m= t2.dgf_max_depth_m
from 
moe_20250711.dbo.ormgp_20250711_upd_depth as orm
inner join
(
select
t.moe_bore_hole_id
,max(t.dgf_depth) as dgf_max_depth_m
from 
(
select
orm.moe_bore_hole_id
,case
when mwater.water_found_depth_uom = 'ft' then mwater.water_found_depth * 0.3048
else mwater.water_found_depth
end as dgf_depth
from 
moe_20250711.dbo.ormgp_20250711_upd_depth as orm
inner join moe_20250711.dbo.tblbore_hole as mbore
on orm.moe_bore_hole_id=mbore.bore_hole_id
inner join moe_20250711.dbo.tblwater as mwater
on mbore.well_id collate database_default = mwater.well_id collate database_default
) as t
group by
t.moe_bore_hole_id
) as t2
on orm.moe_bore_hole_id=t2.moe_bore_hole_id

--update moe_20250711.dbo.ormgp_20250711_upd_depth
--set
--dgf_max_depth_m= t2.dgf_max_depth_m
--from 
--moe_20250711.dbo.ormgp_20250711_upd_depth as orm
--inner join
--(
--select
--t.moe_bore_hole_id
--,max(t.dgf_depth) as dgf_max_depth_m
--from 
--(
--select
--orm.moe_bore_hole_id
--,case
--when mwater.water_found_depth_uom = 'ft' then mwater.water_found_depth * 0.3048
--else mwater.water_found_depth
--end as dgf_depth
--from 
--moe_20250711.dbo.ormgp_20250711_upd_depth as orm
--inner join moe_20250711.dbo.tblbore_hole as mbore
--on orm.moe_bore_hole_id=mbore.bore_hole_id
--inner join moe_20250711.dbo.tblwater as mwater
--on mbore.well_id=mwater.well_id
--) as t
--group by
--t.moe_bore_hole_id
--) as t2
--on orm.moe_bore_hole_id=t2.moe_bore_hole_id

-- access the maximum depth determined by the MOE

-- v20200721 5954 rows
-- v20210119 6247 rows
-- v20220328 4378 
-- v20230324 1807 
-- v20240326 10168
-- v20250711 4996 

update moe_20250711.dbo.ormgp_20250711_upd_depth
set
moe_max_depth_m= t2.moe_max_depth_m
from 
moe_20250711.dbo.ormgp_20250711_upd_depth as orm
inner join
(
select
t.moe_bore_hole_id
,max(t.moe_depth) as moe_max_depth_m
from 
(
select
orm.moe_bore_hole_id
,case
when mhole.hole_depth_uom = 'ft' then mhole.depth_to * 0.3048
else mhole.depth_to
end as moe_depth
from 
moe_20250711.dbo.ormgp_20250711_upd_depth as orm
inner join moe_20250711.dbo.tblhole as mhole
on orm.moe_bore_hole_id=mhole.bore_hole_id
) as t
group by
t.moe_bore_hole_id
) as t2
on orm.moe_bore_hole_id=t2.moe_bore_hole_id


--update moe_20250711.dbo.ormgp_20250711_upd_depth
--set
--moe_max_depth_m= t2.moe_max_depth_m
--from 
--moe_20250711.dbo.ormgp_20250711_upd_depth as orm
--inner join
--(
--select
--t.moe_bore_hole_id
--,max(t.moe_depth) as moe_max_depth_m
--from 
--(
--select
--orm.moe_bore_hole_id
--,case
--when mhole.hole_depth_uom = 'ft' then mhole.depth_to * 0.3048
--else mhole.depth_to
--end as moe_depth
--from 
--moe_20250711.dbo.ormgp_20250711_upd_depth as orm
--inner join moe_20250711.dbo.tblhole as mhole
--on orm.moe_bore_hole_id=mhole.bore_hole_id
--) as t
--group by
--t.moe_bore_hole_id
--) as t2
--on orm.moe_bore_hole_id=t2.moe_bore_hole_id

-- determine the maximum depth from four fields

-- v20200721 17109 rows
-- v20210119 19269 rows
-- v20220328 24996
-- v20230324 20477 
-- v20240326 31090
-- v20250711 38652

update moe_20250711.dbo.ormgp_20250711_upd_depth
set
max_depth_m= t.max_depth_m
from 
moe_20250711.dbo.ormgp_20250711_upd_depth as orm
inner join
(
select
orm.moe_bore_hole_id
,(
select max(v) from 
(
values (fm_max_depth_m),(dgf_max_depth_m),(dbc_max_depth_m),(moe_max_depth_m)
) as value(v)
) as max_depth_m
from 
moe_20250711.dbo.ormgp_20250711_upd_depth as orm
) as t
on orm.moe_bore_hole_id=t.moe_bore_hole_id

select * from moe_20250711.dbo.ormgp_20250711_upd_depth

--***** v20240326  added code to incorporate depths in d_borehole

-- update SYS_TEMP1 and SYS_TEMP2

-- v20240326 11410 rows
-- v20250711 5594 rows

select
dbore.loc_id
,dbore.bh_gnd_elev
,dbore.bh_bottom_elev
,dbore.bh_bottom_depth
,dbore.bh_bottom_ouom
,dbore.bh_bottom_unit_ouom
,ud.max_depth_m
from 
oak_20160831_master.dbo.d_borehole as dbore
inner join moe_20250711.dbo.ORMGP_20250711_upd_DEPTH as ud
on dbore.loc_id=ud.loc_id
where
ud.max_depth_m is not null

select
dbore.loc_id
,dbore.bh_gnd_elev
,( bh_gnd_elev - ud.max_depth_m ) as bh_bottom_elev
,ud.max_depth_m as bh_bottom_depth
,ud.max_depth_m as bh_bottom_ouom
,'mbgs' as bh_bottom_unit_ouom
,ud.max_depth_m
from 
oak_20160831_master.dbo.d_borehole as dbore
inner join moe_20250711.dbo.ORMGP_20250711_upd_DEPTH as ud
on dbore.loc_id=ud.loc_id
where
ud.max_depth_m is not null

update oak_20160831_master.dbo.d_borehole
set
bh_bottom_elev= bh_gnd_elev - ud.max_depth_m
,bh_bottom_depth= ud.max_depth_m
,bh_bottom_ouom= ud.max_depth_m
,bh_bottom_unit_ouom= 'mbgs'
,sys_temp1= '20250714j'
,sys_temp2= 20250714
from 
oak_20160831_master.dbo.d_borehole as dbore
inner join moe_20250711.dbo.ORMGP_20250711_upd_DEPTH as ud
on dbore.loc_id=ud.loc_id
where
ud.max_depth_m is not null



--update moe_20250711.dbo.ormgp_20250711_upd_depth
--set
--max_depth_m= t.max_depth_m
--from 
--moe_20250711.dbo.ormgp_20250711_upd_depth as orm
--inner join
--(
--select
--orm.moe_bore_hole_id
--,(
--select max(v) from 
--(
--values (fm_max_depth_m),(dgf_max_depth_m),(dbc_max_depth_m),(moe_max_depth_m)
--) as value(v)
--) as max_depth_m
--from 
--moe_20250711.dbo.ormgp_20250711_upd_depth as orm
--) as t
--on orm.moe_bore_hole_id=t.moe_bore_hole_id


--***** 20190605 the following was used as a base for finding the 
--***** maximum depth for construction details; unused during
--***** actual processing

-- casing

select
orm.moe_bore_hole_id
,case
when mcase.casing_depth_uom = 'ft' then mcase.depth_to * 0.3048
else mcase.depth_to
end as dbc_depth
from 
moe_20250711.dbo.ormgp_20250711_upd_depth as orm
inner join moe_20250711.dbo.tblbore_hole as mbore
on orm.moe_bore_hole_id=mbore.bore_hole_id
inner join moe_20250711.dbo.tblcasing as mcase
on mbore.well_id=mcase.well_id

-- plug

select
orm.moe_bore_hole_id
,case
when mplug.plug_depth_uom = 'ft' then mplug.plug_to * 0.3048
else mplug.plug_to
end as dbc_depth
from 
moe_20250711.dbo.ormgp_20250711_upd_depth as orm
inner join moe_20250711.dbo.tblplug as mplug
on orm.moe_bore_hole_id=mplug.bore_hole_id

-- screen 

select
orm.moe_bore_hole_id
,case
when mscr.scrn_depth_uom = 'ft' then mscr.scrn_end_depth * 0.3048
else mscr.scrn_end_depth
end as dbc_depth
from 
moe_20250711.dbo.ormgp_20250711_upd_depth as orm
inner join moe_20250711.dbo.tblbore_hole as mbore
on orm.moe_bore_hole_id=mbore.bore_hole_id
inner join moe_20250711.dbo.tblscreen as mscr
on mbore.well_id=mscr.well_id

-- pumping

select
orm.moe_bore_hole_id
,case
when mpump.levels_uom = 'ft' then mpump.recom_depth * 0.3048
else mpump.recom_depth
end as dbc_depth
from 
moe_20250711.dbo.ormgp_20250711_upd_depth as orm
inner join moe_20250711.dbo.tblbore_hole as mbore
on orm.moe_bore_hole_id=mbore.bore_hole_id
inner join moe_20250711.dbo.tblpump_test as mpump
on mbore.well_id=mpump.well_id












