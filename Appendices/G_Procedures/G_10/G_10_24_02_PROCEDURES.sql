
--**** G_10_24_02

--***** Remember to update the DATA_ID in the following scripts

-- 2018.05.30 DATA_ID 520
-- v20190509 DATA_ID 521 
-- v20200721 DATA_ID 522
-- v20210119 DATA_ID 523
-- v20220328 DATA_ID 524
-- v20230324 DATA_ID 525
-- v20240326 DATA_ID 526

--***** 20200721 
--***** The following has been automated

--***** D_LOCATION_GEOM
--***** insert the new locations into D_LOCATION_GEOM (both the GEOM and GEOM_WKB fields)

-- 2018.05.30 15578 locations
-- v20190509 

--select
--v.LOC_ID
--,v.GEOM
--from 
--oak_20160831_master.dbo.v_sys_loc_geometry as v
--inner join oak_20160831_master.dbo.d_location as dloc
--on v.loc_id=dloc.loc_id
--inner join oak_20160831_master.dbo.d_location_qa as dlqa
--on v.loc_id=dlqa.loc_id
--where 
--dloc.data_id= 521 
--and dlqa.qa_coord_confidence_code<>117

--insert into oak_20160831_master.dbo.d_location_geom
--( LOC_ID,GEOM )
--select
--v.LOC_ID
--,v.GEOM
--from 
--oak_20160831_master.dbo.v_sys_loc_geometry as v
--inner join oak_20160831_master.dbo.d_location as dloc
--on v.loc_id=dloc.loc_id
--inner join oak_20160831_master.dbo.d_location_qa as dlqa
--on v.loc_id=dlqa.loc_id
--where 
--dloc.data_id= 521 
--and dlqa.qa_coord_confidence_code<>117
----and v.loc_id not in
----( select loc_id from oak_20160831_master.dbo.d_location_geom )

--select
----v.LOC_ID
----,v.GEOM_WKB
--count(*)
--from 
--oak_20160831_master.dbo.v_sys_loc_geometry_wkb as v
--inner join oak_20160831_master.dbo.d_location as dloc
--on v.loc_id=dloc.loc_id
--inner join oak_20160831_master.dbo.d_location_qa as dlqa
--on v.loc_id=dlqa.loc_id
--where 
--dloc.data_id= 521 
--and dlqa.qa_coord_confidence_code<>117

--update oak_20160831_master.dbo.d_location_geom
--set
--GEOM_WKB=v.GEOM_WKB
--from 
--oak_20160831_master.dbo.v_sys_loc_geometry_wkb as v
--inner join oak_20160831_master.dbo.d_location as dloc
--on v.loc_id=dloc.loc_id
--inner join oak_20160831_master.dbo.d_location_qa as dlqa
--on v.loc_id=dlqa.loc_id
--where 
--dloc.data_id= 521 
--and dlqa.qa_coord_confidence_code<>117

--***** D_LOCATION
--***** check the _OUOM coordinates; the Y coord is soemtimes assigned incorrectly (dropping precision)

select
dloc.loc_id
,dloc.loc_coord_easting_ouom
,dloc.loc_coord_northing_ouom
,t.x
,t.y
from 
oak_20160831_master.dbo.d_location as dloc
inner join 
(
select
dloc.loc_id
,cast( convert(bigint,dloc.loc_coord_easting_ouom) as varchar(20) )  as x
,cast( convert(bigint,dloc.loc_coord_northing_ouom) as varchar(20) ) as y
from 
moe_20240326.dbo.m_d_location as dloc
) as t
on dloc.loc_id=t.loc_id

update oak_20160831_master.dbo.d_location
set
loc_coord_easting_ouom=t.x
,loc_coord_northing_ouom=t.y
,sys_temp1= '20240326d'
,sys_temp2= 20240326
from 
oak_20160831_master.dbo.d_location as dloc
inner join 
(
select
dloc.loc_id
,cast( convert(bigint,dloc.loc_coord_easting_ouom) as varchar(20) )  as x
,cast( convert(bigint,dloc.loc_coord_northing_ouom) as varchar(20) ) as y
from 
moe_20240326.dbo.m_d_location as dloc
) as t
on dloc.loc_id=t.loc_id

--***** 20200721
--***** D_LOCATION_COORD_HIST has been replaced by the D_LOCATION_SPATIAL* tables

--***** D_LOCATION_COORD_HIST
--***** add the current location coordinates to the coordinate history table;
--***** don't forget to mark them as 'current'

--select
--dloc.loc_id
--,dloc.loc_coord_easting
--,dloc.loc_coord_northing
--,dloc.loc_coord_easting_ouom
--,dloc.loc_coord_northing_ouom
--,dloc.loc_coord_ouom_code 
--,1 as loc_coord_hist_code
--,1 as current_coord
--,dlqa.qa_coord_confidence_code 
--,dloc.data_id
--,delev.loc_elev_id 
--from 
--oak_20160831_master.dbo.d_location as dloc
--inner join oak_20160831_master.dbo.d_location_qa as dlqa
--on dloc.loc_id=dlqa.loc_id
--inner join oak_20160831_master.dbo.d_location_elev as delev
--on dloc.loc_id=delev.loc_id
--where
--dloc.data_id=521
--and dlqa.qa_coord_confidence_code<>117

--insert into oak_20160831_master.dbo.d_location_coord_hist
--(
--loc_id
--,x_utmz17nad83
--,y_utmz17nad83
--,x_ouom
--,y_ouom
--,loc_coord_ouom_code
--,loc_coord_hist_code
--,current_coord
--,qa_coord_confidence_code
--,data_id
--,loc_elev_id
--)
--select
--dloc.loc_id
--,dloc.loc_coord_easting
--,dloc.loc_coord_northing
--,dloc.loc_coord_easting_ouom
--,dloc.loc_coord_northing_ouom
--,dloc.loc_coord_ouom_code 
--,1 as loc_coord_hist_code
--,1 as current_coord
--,dlqa.qa_coord_confidence_code 
--,dloc.data_id
--,delev.loc_elev_id 
--from 
--oak_20160831_master.dbo.d_location as dloc
--inner join oak_20160831_master.dbo.d_location_qa as dlqa
--on dloc.loc_id=dlqa.loc_id
--inner join oak_20160831_master.dbo.d_location_elev as delev
--on dloc.loc_id=delev.loc_id
--where
--dloc.data_id=521
--and dlqa.qa_coord_confidence_code<>117

--***** D_GEOLOGY_LAYER
--***** check elevations in the D_GEOLOGY_LAYER table

--select
--dgl.*
--from 
--oak_20160831_master.dbo.d_geology_layer as dgl
--inner join oak_20160831_master.dbo.d_location as dloc
--on dgl.loc_id=dloc.loc_id
--where 
--dloc.data_id= 522
--order by
--dgl.geol_top_ouom desc

--select
--count(*)
--from 
--oak_20160831_master.dbo.d_geology_layer as dgl
--inner join oak_20160831_master.dbo.v_sys_geol_lay_elevs as v
--on dgl.geol_id=v.geol_id
--inner join oak_20160831_master.dbo.d_location as dloc
--on v.loc_id=dloc.loc_id
--where 
--dloc.data_id= 522


--***** Update elevations

-- Update DATA_ID


--***** D_GEOLOGY_LAYER

-- 2018.05.30 32463 rows
-- v20190509 16691 rows 
-- v20200721 24067 rows
-- v20210119 46518 rows
-- v20220328 
-- v20230324 12087 rows
-- v20240326 16347 rows

select
v.*
from 
oak_20160831_master.dbo.d_geology_layer as dgl
inner join oak_20160831_master.dbo.v_sys_geol_lay_elevs as v
on dgl.geol_id=v.geol_id
inner join oak_20160831_master.dbo.d_location as dloc
on v.loc_id=dloc.loc_id
where 
dloc.data_id= 526


update oak_20160831_master.dbo.d_geology_layer 
set
geol_top_elev=v.new_geol_top_elev
,geol_bot_elev=v.new_geol_bot_elev
,sys_temp1= '20240326d'
,sys_temp2= 20240326
from 
oak_20160831_master.dbo.d_geology_layer as dgl
inner join oak_20160831_master.dbo.v_sys_geol_lay_elevs as v
on dgl.geol_id=v.geol_id
inner join oak_20160831_master.dbo.d_location as dloc
on v.loc_id=dloc.loc_id
where 
dloc.data_id= 526


--***** D_BOREHOLE
--***** update with bedrock elevations

-- 2018.05.30 6039 rows
-- v20190509 1470 rows 
-- v20200721 2291 rows
-- v20210119 3631 rows
-- v20220328 763 rows
-- v20230324 742 rows
-- v20240326 

select
v.*
from 
oak_20160831_master.dbo.d_borehole as dbore
inner join oak_20160831_master.dbo.v_sys_bh_bedrock_elev as v
on dbore.loc_id=v.loc_id 
inner join oak_20160831_master.dbo.d_location as dloc
on v.loc_id=dloc.loc_id
where 
dloc.data_id= 526

update oak_20160831_master.dbo.d_borehole
set
bh_bedrock_elev= v.new_bh_bedrock_elev
,sys_temp1= '20240326e'
,sys_temp2= 20240326
from 
oak_20160831_master.dbo.d_borehole as dbore
inner join oak_20160831_master.dbo.v_sys_bh_bedrock_elev as v
on dbore.loc_id=v.loc_id 
inner join oak_20160831_master.dbo.d_location as dloc
on v.loc_id=dloc.loc_id
where 
dloc.data_id= 526



--***** D_INTERVAL_MONITOR

--***** remove DIMs that do not have a valid screen

-- 2018.05.30 1603 rows
-- v20190509 4421 rows
-- v20200721 1941 rows
-- v20210119 4146 rows
-- v20220328 9095 rows
-- v20230324 12394 rows
-- v20240326 14700 rows

select
count(*)
from 
oak_20160831_master.dbo.d_interval_monitor as dim
inner join oak_20160831_master.dbo.d_interval as dint
on dim.int_id=dint.int_id
inner join oak_20160831_master.dbo.d_location as dloc
on dint.loc_id=dloc.loc_id
where 
dint.int_type_code= 28
and dloc.data_id= 526

delete from oak_20160831_master.dbo.d_interval_monitor
where 
mon_id in
(
select
dim.mon_id
from 
oak_20160831_master.dbo.d_interval_monitor as dim
inner join oak_20160831_master.dbo.d_interval as dint
on dim.int_id=dint.int_id
inner join oak_20160831_master.dbo.d_location as dloc
on dint.loc_id=dloc.loc_id
where 
dint.int_type_code= 28
and dloc.data_id= 526
)

--***** update monitor elevations and depth-in-metres

-- 2018.05.30 14006 rows
-- v20190509 7461 rows 
-- v20200721 9817 rows
-- v20210119 20455 rows
-- v20220328 
-- v20230324 6406 rows
-- v20240326 8463 rows

select
v.*
from 
oak_20160831_master.dbo.d_interval_monitor as dim
inner join oak_20160831_master.dbo.v_sys_int_mon_elevs as v
on dim.mon_id=v.mon_id
inner join oak_20160831_master.dbo.d_interval as dint
on dim.int_id=dint.int_id
inner join oak_20160831_master.dbo.d_location as dloc
on dint.loc_id=dloc.loc_id
where 
dloc.data_id= 526


update oak_20160831_master.dbo.d_interval_monitor
set
mon_top_elev= v.new_mon_top_elev
,mon_bot_elev= v.new_mon_bot_elev
,sys_temp1= '20240326e'
,sys_temp2= 20240326
from 
oak_20160831_master.dbo.d_interval_monitor as dim
inner join oak_20160831_master.dbo.v_sys_int_mon_elevs as v
on dim.mon_id=v.mon_id
inner join oak_20160831_master.dbo.d_interval as dint
on dim.int_id=dint.int_id
inner join oak_20160831_master.dbo.d_location as dloc
on dint.loc_id=dloc.loc_id
where 
dloc.data_id= 526

-- populate DIM top and bottom depths

-- 2018.05.30 14006 rows
-- v20190509 7461 rows 
-- v20200721 9815 rows
-- v20210119 20455
-- v20220328 6117 rows
-- v20230324 6406 rows
-- v20240326 

select
v.*
from 
oak_20160831_master.dbo.d_interval_monitor as dim
inner join oak_20160831_master.dbo.v_sys_int_mon_depths_m as v
on dim.mon_id=v.mon_id
inner join oak_20160831_master.dbo.d_interval as dint
on dim.int_id=dint.int_id
inner join oak_20160831_master.dbo.d_location as dloc
on dint.loc_id=dloc.loc_id
where 
dloc.data_id= 526


update oak_20160831_master.dbo.d_interval_monitor
set
mon_top_depth_m=v.new_mon_top_depth_m
,mon_bot_depth_m=v.new_mon_bot_depth_m
,sys_temp1= '20240326f'
,sys_temp2= 20240326
from 
oak_20160831_master.dbo.d_interval_monitor as dim
inner join oak_20160831_master.dbo.v_sys_int_mon_depths_m as v
on dim.mon_id=v.mon_id
inner join oak_20160831_master.dbo.d_interval as dint
on dim.int_id=dint.int_id
inner join oak_20160831_master.dbo.d_location as dloc
on dint.loc_id=dloc.loc_id
where 
dloc.data_id= 526





