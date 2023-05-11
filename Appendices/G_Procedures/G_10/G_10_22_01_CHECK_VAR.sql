
--***** G_10_22_01

--***** Various checks for the populated tables

--***** M_D_BOREHOLE

select
*
from 
MOE_20230324.dbo.m_d_borehole
where 
bh_bottom_depth<0

select
*
from 
MOE_20230324.dbo.m_d_borehole_construction
where
bh_id= 1000312930

select
*
from 
MOE_20230324.dbo.m_d_borehole
where
loc_id= 1000318648

update MOE_20230324.dbo.m_d_borehole_construction
set
con_bot_ouom= 16
,con_comment= 'Changed CON_BOT_OUOM to 16.0 from -16.0'
where 
sys_record_id= 240311867

update MOE_20230324.dbo.m_d_borehole
set
bh_bottom_elev= 325.47320556640625 - ( 16 *0.3048 )
,bh_bottom_depth= 16 * 0.3048
,bh_bottom_ouom= 16
,bh_bottom_unit_ouom= 'fbgs'
where 
loc_id= 1000318648

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

select * from oak_20160831_master.dbo.r_bh_driller_code where bh_driller_code= 74522

select
*
from 
moe_20230324.dbo.m_r_bh_driller_code
order by
bh_driller_code

-- v20210119 74522 min 74550 max
-- v20220328 74522 min 74576 max
-- v20230324 74578 min 74602 max

select
min( bh_driller_code ) as min_bh_driller_code
,max( bh_driller_code ) as max_bh_driller_code
from 
moe_20230324.dbo.m_r_bh_driller_code

set identity_insert oak_20160831_master.dbo.r_bh_driller_code on

-- Update DATA_ID

-- note that for v20220328 there was an error for bh_driller_codes <= 74550; check
-- this next time

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
,525 as data_id
from 
moe_20230324.dbo.m_r_bh_driller_code
--where
--bh_driller_code>74550

set identity_insert oak_20160831_master.dbo.r_bh_driller_code off

--***** M_D_BOREHOLE_CONSTRUCTION

select
*
from 
MOE_20230324.dbo.m_d_borehole_construction

-- check for top depths where no bottom depths indicated; this is only for
-- locations where no bottom depth is found in D_BOREHOLE

select
dbore.loc_id
,dbore.bh_comment
,dbc.*
from 
MOE_20230324.dbo.m_d_borehole_construction as dbc
inner join MOE_20230324.dbo.m_d_borehole as dbore
on dbc.bh_id=dbore.bh_id
where
dbc.con_top_ouom is not null 
and dbc.con_bot_ouom is null
and dbore.bh_bottom_depth is null

select
*
from 
moe_20230324.dbo.m_d_borehole
where
loc_id= 1006228439

select
*
from 
MOE_20230324.dbo.m_d_interval
where 
loc_id in 
(
1000790266
,1000790266
,1001883370
,1001883495
)

select
*
from 
MOE_20230324.dbo.m_d_interval_temporal_2
where
int_id in
(
240250997
,240595575
,240595557
)

-- check the con_diameter_unit_ouom; inch or cm only

select
distinct( con_diameter_unit_ouom )
from 
MOE_20230324.dbo.m_d_borehole_construction

--***** M_D_LOCATION

-- LOC_ADDRESS_INFO1 and LOC_CON

select
*
from 
MOE_20230324.dbo.m_d_location
where 
len(loc_con)=0

update MOE_20230324.dbo.m_d_location
set
loc_con=null
where 
len(loc_con)=0

select
*
from 
MOE_20230324.dbo.m_d_location
where 
len(loc_address_info1)=0

update MOE_20230324.dbo.m_d_location
set
loc_address_info1=null
where 
len(loc_address_info1)=0

-- LOC_COUNTY_CODE

select
*
from 
MOE_20230324.dbo.m_d_location
where
loc_county_code=99

-- LOC_TOWNSHIP_CODE

select
*
from 
moe_20230324.dbo.m_d_location
where 
loc_township_code=9999

select
*
from 
moe_20230324.dbo.m_d_location
where 
loc_township_code is null

select
*
from 
moe_20230324.dbo.m_d_location
where 
len(loc_township_code)=0

select
distinct(md.loc_township_code)
,rltc.loc_township_code as rltc_loc_township_code
from 
moe_20230324.dbo.m_d_location as md
left outer join oak_20160831_master.dbo.r_loc_township_code as rltc
on md.loc_township_code=rltc.loc_township_code

select
t.loc_township_code
,rltc.loc_township_code as rltc_loc_township_code
FROM 
(
select
distinct(loc_township_code) as loc_township_code
from 
moe_20230324.dbo.m_d_location
) as t
left outer join oak_20160831_master.dbo.r_loc_township_code as rltc
on t.loc_township_code=rltc.loc_township_code

select
md.loc_id
,md.loc_township_code
,rltc.loc_township_code as rltc_loc_township_code
from 
moe_20230324.dbo.m_d_location as md
left outer join oak_20160831_master.dbo.r_loc_township_code as rltc
on md.loc_township_code=rltc.loc_township_code

select
*
from 
moe_20230324.dbo.m_d_location 
where
loc_township_code= 13

update moe_20230324.dbo.m_d_location 
set
loc_township_code= 13000
where
loc_township_code= 13

--update moe_20190509.dbo.m_d_location
--set
--loc_township_code= null
--where 
--loc_id in ( 240211374,240211052,240210767 )

-- LOC_COORD_EASTING

select
*
from 
MOE_20230324.dbo.m_d_location
where 
loc_coord_easting is null

--***** M_D_GEOLOGY_FEATURE

-- is the feature top negative

select 
*
from 
MOE_20230324.dbo.m_d_geology_feature
where 
feature_top_ouom<0

update MOE_20230324.dbo.m_d_geology_feature
set
feature_top_ouom= feature_top_ouom * -1
where
feature_top_ouom<0


--***** M_D_GEOLOGY_LAYER

-- are there any negative values

select
*
from 
MOE_20230324.dbo.m_d_geology_layer
where
geol_top_ouom<0
or geol_bot_ouom<0

update MOE_20230324.dbo.m_d_geology_layer
set
geol_top_ouom=0
,geol_bot_ouom=2.5
where
sys_record_id in ( 242469178, 243756949 )

update MOE_20230324.dbo.m_d_geology_layer
set
geol_bot_ouom=2.5
where
sys_record_id in ( 243756908, 242469064 )

update MOE_20230324.dbo.m_d_geology_layer
set
geol_bot_ouom= 25
where
sys_record_id= 240576396

update MOE_20230324.dbo.m_d_geology_layer
set
geol_top_ouom= 25
where
sys_record_id= 240576447

-- is the geol_top_ouom > geol_bot_ouom

select
*
from 
MOE_20230324.dbo.m_d_geology_layer
where
geol_top_ouom > geol_bot_ouom

update MOE_20230324.dbo.m_d_geology_layer
set
geol_top_ouom= geol_bot_ouom
,geol_bot_ouom= geol_top_ouom
where 
geol_top_ouom > geol_bot_ouom

-- is the first material null or unknown while there is a secondary material

select
*
from 
MOE_20230324.dbo.m_d_geology_layer
where 
( geol_mat1_code is null or geol_mat1_code=0 )
and ( geol_mat2_code is not null and geol_mat2_code<>0 )

update MOE_20230324.dbo.m_d_geology_layer
set
geol_mat1_code= geol_mat2_code
,geol_mat2_code= null
where 
( geol_mat1_code is null or geol_mat1_code=0 )
and ( geol_mat2_code is not null and geol_mat2_code<>0 )

--***** D_INTERVAL_MONITOR

-- is the bottom of the interval above the top of the interval

select
*
from 
MOE_20230324.dbo.m_d_interval_monitor
where
mon_top_ouom > mon_bot_ouom

-- does the bottom of the interval match the top

select
*
from 
MOE_20230324.dbo.m_d_interval_monitor
where
mon_top_ouom = mon_bot_ouom

update MOE_20230324.dbo.m_d_interval_monitor
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
MOE_20230324.dbo.m_d_location_purpose
group by 
loc_id,primary_purpose_code,secondary_purpose_code
) as t
where
t.rcount>1

delete from MOE_20230324.dbo.m_d_location_purpose
where
sys_record_id in
(
select
dpurp.sys_record_id
from
MOE_20230324.dbo.m_d_location_purpose as dpurp
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
MOE_20230324.dbo.m_d_location_purpose
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








