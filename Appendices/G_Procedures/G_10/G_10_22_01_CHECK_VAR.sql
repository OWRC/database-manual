
--***** G_10_22_01

--***** Various checks for the populated tables

--***** M_D_BOREHOLE

select
*
from 
MOE_20260813.dbo.m_d_borehole
where 
bh_bottom_depth<0

-- v20260813 33 rows

-- change negative values to positive values

update MOE_20260813.dbo.m_d_borehole
set
bh_bottom_elev= bh_gnd_elev - abs( bh_bottom_depth )
,bh_bottom_depth= abs( bh_bottom_depth )
where
loc_id in 
(
1005958625
,1006466206
,1006167487
,1005066564
,1003905453
,1004907165
,1005255694
,1005066740
,1005153189
,1007164982
,1007515378
,1006567642
,1006360079
,1004534805
,1005356003
,1006569771
,1005742829
,1005776800
,1005289637
,1008515954
,1005403746
,1008646766
,1008489825
,1005644355
,1005958138
,1005965116
,1005742814
,1005964783
,1004686608
,1003653250
,1003715621
,1003143394
,1003143380
)


-- check if the r_bh_driller_code table has been updated

select
*
from 
oak_20160831_master.dbo.r_bh_driller_code 
order by
sys_time_stamp
desc

-- this is the maximum driller code number
-- v20210119 74521 in master db
-- v20220328 74550 in master db
-- v20230324 74576 in master db
-- v20240326 74604 in master db
-- v20250711 74665 in master db

select
max( bh_driller_code )
from 
oak_20160831_master.dbo.r_bh_driller_code

-- check the reverse order, just in case

select
*
from 
oak_20160831_master.dbo.r_bh_driller_code 
order by
bh_driller_code
desc

--select * from oak_20160831_master.dbo.r_bh_driller_code where bh_driller_code= 74522

select
*
from 
moe_20260813.dbo.m_r_bh_driller_code
order by
bh_driller_code

-- v20210119 74522 min 74550 max
-- v20220328 74522 min 74576 max
-- v20230324 74578 min 74602 max
-- v20240326 74605 min 74641 max
-- v20250711 74694 min 74721 max

select
min( bh_driller_code ) as min_bh_driller_code
,max( bh_driller_code ) as max_bh_driller_code
from 
moe_20260813.dbo.m_r_bh_driller_code

set identity_insert oak_20160831_master.dbo.r_bh_driller_code on

-- Update DATA_ID

-- note that for v20220328 there was an error for bh_driller_codes <= 74550; check
-- this next time

-- v20240326 no errors returned
-- v20250711 
-- v20260813 no new driller codes

insert into oak_20160831_master.dbo.r_bh_driller_code
(
bh_driller_code
,bh_driller_description
,bh_driller_description_long
,bh_driller_alt_code
,data_id
)
select
bh_driller_code
,bh_driller_description
,bh_driller_description_long
,bh_driller_alt_code
,528 as data_id
from 
moe_20260813.dbo.m_r_bh_driller_code
--where
--bh_driller_code>74550

set identity_insert oak_20160831_master.dbo.r_bh_driller_code off

--***** M_D_BOREHOLE_CONSTRUCTION

select
*
from 
MOE_20260813.dbo.m_d_borehole_construction

-- check for top depths where no bottom depths indicated; this is only for
-- locations where no bottom depth is found in D_BOREHOLE

-- v20240326 399 rows
-- v20260813 238 rows

select
dbore.loc_id
,dbore.bh_comment
,dbore.*
,dbc.*
from 
MOE_20260813.dbo.m_d_borehole_construction as dbc
inner join MOE_20260813.dbo.m_d_borehole as dbore
on dbc.bh_id=dbore.bh_id
where
dbc.con_top_ouom is not null 
and dbc.con_bot_ouom is null
and dbore.bh_bottom_depth is null

-- v20260813 155 fixes

update MOE_20260813.dbo.m_d_borehole
set
bh_bottom_elev= bh_gnd_elev - abs( case when con_unit_ouom = 'ft' then con_top_ouom * 0.3048 else con_top_ouom end )
,bh_bottom_depth= abs( case when con_unit_ouom = 'ft' then con_top_ouom * 0.3048 else con_top_ouom end )
,bh_bottom_ouom= abs( case when con_unit_ouom = 'ft' then con_top_ouom * 0.3048 else con_top_ouom end )
from 
MOE_20260813.dbo.m_d_borehole_construction as dbc
inner join MOE_20260813.dbo.m_d_borehole as dbore
on dbc.bh_id=dbore.bh_id
where
dbc.con_top_ouom is not null 
and dbc.con_bot_ouom is null
and dbore.bh_bottom_depth is null


-- check the con_diameter_unit_ouom; inch or cm only

select
distinct( con_diameter_unit_ouom )
from 
MOE_20260813.dbo.m_d_borehole_construction

-- v20260813 fixes

select * from MOE_20260813.dbo.m_d_borehole_construction where con_diameter_unit_ouom= 'm'

update MOE_20260813.dbo.m_d_borehole_construction
set
con_diameter_ouom= con_diameter_ouom * 100
,con_diameter_unit_ouom= 'cm'
where
con_diameter_unit_ouom= 'm'

update MOE_20260813.dbo.m_d_borehole_construction
set
con_diameter_ouom= con_diameter_ouom/10
,con_diameter_unit_ouom= 'cm'
where
con_diameter_unit_ouom= 'mm'

update MOE_20260813.dbo.m_d_borehole_construction
set
con_diameter_unit_ouom= null
where
con_diameter_unit_ouom= 'GPM'


--***** M_D_LOCATION

-- LOC_ADDRESS_INFO1 and LOC_CON

select
*
from 
MOE_20260813.dbo.m_d_location
where 
len(loc_con)=0

update MOE_20260813.dbo.m_d_location
set
loc_con=null
where 
len(loc_con)=0

select
*
from 
MOE_20260813.dbo.m_d_location
where 
len(loc_address_info1)=0

update MOE_20260813.dbo.m_d_location
set
loc_address_info1=null
where 
len(loc_address_info1)=0

-- LOC_COUNTY_CODE

select
*
from 
MOE_20260813.dbo.m_d_location
where
loc_county_code=99

-- LOC_TOWNSHIP_CODE

select
*
from 
moe_20260813.dbo.m_d_location
where 
loc_township_code=9999


select
*
from 
moe_20260813.dbo.m_d_location
where 
len(loc_township_code)=0

select * from oak_20160831_master.dbo.d_location where loc_township_code is null

select
t.loc_township_code
,r.loc_township_code as r_loc_township_code
from 
(
select
loc_township_code
from 
moe_20260813.dbo.m_d_location
group by
loc_township_code
) as t
left outer join oak_20160831_master.dbo.r_loc_township_code as r
on t.loc_township_code=r.loc_township_code


-- v20260813 fixes

select
*
from 
moe_20260813.dbo.m_d_location
where
loc_township_code in ( 22, 30, 37, 47, 48, 53, 55 )

update moe_20260813.dbo.m_d_location
set
loc_township_code= loc_township_code * 1000
where
loc_township_code in ( 22, 30, 37, 47, 48, 53, 55 )

update moe_20260813.dbo.m_d_location
set
loc_township_code= null
where
loc_township_code= 0

update moe_20260813.dbo.m_d_location
set
loc_township_code= null
where
loc_township_code in ( 45502, 45503 )

-- LOC_COUNTY_CODE

select
t.loc_county_code
,r.loc_county_code as r_loc_county_code
from 
(
select
loc_county_code
from 
MOE_20260813.dbo.m_d_location
group by
loc_county_code
) as t
left outer join oak_20160831_master.dbo.r_loc_county_code as r
on t.loc_county_code=r.loc_county_code

-- v20260813 fixes

update MOE_20260813.dbo.m_d_location
set
loc_county_code= null
where
loc_county_code= 0


-- LOC_COORD_EASTING

select
*
from 
MOE_20260813.dbo.m_d_location
where 
loc_coord_easting is null


--***** M_D_GEOLOGY_FEATURE

-- is the feature top negative

select 
*
from 
MOE_20260813.dbo.m_d_geology_feature
where 
feature_top_ouom<0

update MOE_20260813.dbo.m_d_geology_feature
set
feature_top_ouom= abs( feature_top_ouom )
where
feature_top_ouom<0


--***** M_D_GEOLOGY_LAYER

-- are there any negative values

select
*
from 
MOE_20260813.dbo.m_d_geology_layer
where
geol_top_ouom<0
or geol_bot_ouom<0

update MOE_20260813.dbo.m_d_geology_layer
set
geol_top_ouom= abs( geol_top_ouom )
where
geol_top_ouom < 0

update MOE_20260813.dbo.m_d_geology_layer
set
geol_bot_ouom= abs( geol_bot_ouom )
where
geol_bot_ouom < 0



-- is the geol_top_ouom > geol_bot_ouom

select
*
from 
MOE_20260813.dbo.m_d_geology_layer
where
geol_top_ouom > geol_bot_ouom

update MOE_20260813.dbo.m_d_geology_layer
set
geol_top_ouom= geol_bot_ouom
,geol_bot_ouom= geol_top_ouom
where 
geol_top_ouom > geol_bot_ouom



-- is the first material null or unknown while there is a secondary material

select
*
from 
MOE_20260813.dbo.m_d_geology_layer
where 
( geol_mat1_code is null or geol_mat1_code=0 )
and ( geol_mat2_code is not null and geol_mat2_code<>0 )

update MOE_20260813.dbo.m_d_geology_layer
set
geol_mat1_code= geol_mat2_code
,geol_mat2_code= null
where 
( geol_mat1_code is null or geol_mat1_code=0 )
and ( geol_mat2_code is not null and geol_mat2_code<>0 )


select
t.geol_mat1_code
,r.geol_mat1_code as r_geol_mat1_code
from
(
select
geol_mat1_code
from 
moe_20260813.dbo.m_d_geology_layer as m
group by
geol_mat1_code
) as t
left outer join oak_20160831_master.dbo.r_geol_mat1_code as r
on t.geol_mat1_code=r.geol_mat1_code


-- v20260813 fixes

update moe_20260813.dbo.m_d_geology_layer
set
geol_mat1_code= null
where
geol_mat1_code= 0

update moe_20260813.dbo.m_d_geology_layer
set
geol_mat2_code= null
where
geol_mat2_code= 0

update moe_20260813.dbo.m_d_geology_layer
set
geol_mat3_code= null
where
geol_mat3_code= 0

--***** D_INTERVAL_MONITOR

-- is the bottom of the interval above the top of the interval

select
*
from 
MOE_20260813.dbo.m_d_interval_monitor
where
mon_top_ouom > mon_bot_ouom

-- does the bottom of the interval match the top

select
*
from 
MOE_20260813.dbo.m_d_interval_monitor
where
mon_top_ouom = mon_bot_ouom

update MOE_20260813.dbo.m_d_interval_monitor
set
mon_top_ouom= mon_top_ouom - 
case
when mon_unit_ouom like 'm' then 0.3
when mon_unit_ouom like 'ft' then 1
end
where
mon_top_ouom = mon_bot_ouom


--***** M_D_LOCATION_PURPOSE

-- check for purpose duplicates

select
*
from 
(
select
loc_id
,primary_purpose_code
,secondary_purpose_code
,min(sys_record_id) as min_sys_record_id
,count(*) as rcount
from 
MOE_20260813.dbo.m_d_location_purpose
group by 
loc_id,primary_purpose_code,secondary_purpose_code
) as t
where
t.rcount>1

delete from MOE_20260813.dbo.m_d_location_purpose
where
sys_record_id in
(
select
dpurp.sys_record_id
from
MOE_20260813.dbo.m_d_location_purpose as dpurp
inner join
(
select
t.loc_id
,t.primary_purpose_code as ppc
,t.secondary_purpose_code as spc
,t.min_sys_record_id
from 
(
select
loc_id
,primary_purpose_code
,secondary_purpose_code
,min(sys_record_id) as min_sys_record_id
,count(*) as rcount
from 
MOE_20260813.dbo.m_d_location_purpose
group by 
loc_id,primary_purpose_code,secondary_purpose_code
) as t
where
t.rcount>1
) as t2
on dpurp.loc_id=t2.loc_id and dpurp.primary_purpose_code=t2.ppc and dpurp.secondary_purpose_code=t2.spc
where
dpurp.sys_record_id<>t2.min_sys_record_id
)

select
t.primary_purpose_code
,r.purpose_primary_code as r_primary_purpose_code
from
(
select
primary_purpose_code
from 
moe_20260813.dbo.m_d_location_purpose
group by
primary_purpose_code
) as t
left outer join oak_20160831_master.dbo.r_purpose_primary_code as r
on t.primary_purpose_code=r.purpose_primary_code

-- v20260813 fixes

update moe_20260813.dbo.m_d_location_purpose
set
primary_purpose_code= 1
where
primary_purpose_code= 50


--***** CHECK DATETIMES

--***** M_D_LOCATION

select
loc_id
,loc_start_date
from 
MOE_20260813.dbo.m_d_location
where
loc_start_date is not null
order by
loc_start_date

-- v20260813 fixes

update MOE_20260813.dbo.m_d_location
set
loc_start_date= '2020-01-15'
where
loc_id= 1006095988

--***** M_D_BOREHOLE

select
loc_id
,bh_drill_end_date
from 
MOE_20260813.dbo.m_d_borehole
where
bh_drill_end_date is not null
order by
bh_drill_end_date

update MOE_20260813.dbo.m_d_borehole
set
bh_drill_end_date= '2020-01-15'
where
loc_id= 1006095988


--***** M_D_INTERVAL

select
int_id
,int_start_date
from 
MOE_20260813.dbo.m_d_interval
where
int_start_date is not null
order by
int_start_date

update MOE_20260813.dbo.m_d_interval
set
int_start_date= '2020-01-15'
where
int_id= 241181995


--***** M_D_INTERVAL_REF_ELEV

select
int_id
,ref_elev_start_date
from 
MOE_20260813.dbo.m_d_interval_ref_elev
where
ref_elev_start_date is not null
order by
ref_elev_start_date

update MOE_20260813.dbo.m_d_interval_ref_elev
set
ref_elev_start_date= '2020-01-15'
where
int_id= 241181995


--***** M_D_PUMPTEST

select
int_id
,pumptest_date
from 
MOE_20260813.dbo.m_d_pumptest
where
pumptest_date is not null
order by
pumptest_date



--***** M_D_PUMPTEST_STEP

select
pump_test_id
,pump_start
,pump_end
from 
MOE_20260813.dbo.m_d_pumptest_step
where
pump_start is not null
or pump_end is not null
order by
pump_start,pump_end




--***** M_D_INTERVAL_TEMPORAL_2


select
sys_record_id
,rd_date
from 
MOE_20260813.dbo.m_d_interval_temporal_2
where
rd_date is not null
order by
rd_date



select
*
from 
(
select
sys_record_id
,count(*) as rcount
from 
MOE_20260813.dbo.m_d_interval_temporal_2
group by
sys_record_id
) as t
where
t.rcount>1

select
*
into MOE_20260813.dbo.m_d_interval_temporal_2b
from 
MOE_20260813.dbo.m_d_interval_temporal_2
where
sys_record_id in 
(
select
sys_record_id
from 
(
select
sys_record_id
,count(*) as rcount
from 
MOE_20260813.dbo.m_d_interval_temporal_2
group by
sys_record_id
) as t
where
t.rcount>1
)
order by
sys_record_id


select
*
from 
MOE_20260813.dbo.m_d_interval_temporal_2b


delete from MOE_20260813.dbo.m_d_interval_temporal_2
where sys_record_id in 
(
select
sys_record_id
from 
(
select
sys_record_id
,count(*) as rcount
from 
MOE_20260813.dbo.m_d_interval_temporal_2
group by
sys_record_id
) as t
where
t.rcount>1
)


select
*
from 
MOE_20260813.dbo.m_d_interval_temporal_2b

update MOE_20260813.dbo.m_d_interval_temporal_2b
set
sys_record_id= t2.sri
from 
MOE_20260813.dbo.m_d_interval_temporal_2b as d
inner join
(
select
t.sri
,row_number() over (order by t.sri) as rkey
from 
(
select
top 5000
new_id as sri
from 
oak_20160831_master.dbo.v_sys_random_id_bulk_001 
where
new_id not in 
( select sys_record_id from oak_20160831_master.dbo.d_interval_temporal_2 )
) as t
) as t2
on d.id=t2.rkey




