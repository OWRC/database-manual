
--***** G_10_21_03

--***** we can now start reassigning the various ids in the various tables
--***** using the new lookup tables or reassigning them in-place if they're
--***** not relational ids

--***** M_D_BOREHOLE

select
dbore.LOC_ID
,y.new_LOC_ID
,dbore.BH_ID
,y.new_BH_ID
from 
MOE_20240326.dbo.M_D_BOREHOLE as dbore
inner join MOE_20240326.dbo.YC_20240326_new_LOC_ID_BH_ID as y
on dbore.LOC_ID=y.BORE_HOLE_ID


update MOE_20240326.dbo.M_D_BOREHOLE
set
LOC_ID=y.new_LOC_ID
,BH_ID=y.new_BH_ID
from 
MOE_20240326.dbo.M_D_BOREHOLE as dbore
inner join MOE_20240326.dbo.YC_20240326_new_LOC_ID_BH_ID as y
on dbore.LOC_ID=y.BORE_HOLE_ID

--***** M_D_BOREHOLE_CONSTRUCTION

select
dbc.BH_ID
,y.new_BH_ID
from 
MOE_20240326.dbo.M_D_BOREHOLE_CONSTRUCTION as dbc
inner join MOE_20240326.dbo.YC_20240326_new_LOC_ID_BH_ID as y
on dbc.BH_ID=y.BORE_HOLE_ID

update MOE_20240326.dbo.M_D_BOREHOLE_CONSTRUCTION
set
BH_ID=y.new_BH_ID 
from 
MOE_20240326.dbo.M_D_BOREHOLE_CONSTRUCTION as dbc
inner join MOE_20240326.dbo.YC_20240326_new_LOC_ID_BH_ID as y
on dbc.BH_ID=y.BORE_HOLE_ID

-- don't forget to update the SYS_RECORD_ID value; how many are there

select
count(*) 
from 
MOE_20240326.dbo.M_D_BOREHOLE_CONSTRUCTION

-- 2016.05.31 78921 rows
-- 2017.09.05 42915 rows
-- 2018.05.30 41014 rows
-- v20190509 24434 rows
-- v20200721 31060 rows
-- v20210119 66718 rows
-- v20220328 23115 rows
-- v20230324 26307 rows
-- v20240326 33681 rows

select
b.SYS_RECORD_ID
,t2.SYS_RECORD_ID
,t2.new_SRI
from 
MOE_20240326.dbo.M_D_BOREHOLE_CONSTRUCTION as b
inner join
(
select
t.new_SRI
,ROW_NUMBER() over (order by t.new_SRI) as SYS_RECORD_ID
from 
(
select
top 75000
v.NEW_ID as new_SRI
from 
OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_001 as v
where 
v.NEW_ID 
not in
(
select SYS_RECORD_ID from OAK_20160831_MASTER.dbo.D_BOREHOLE_CONSTRUCTION
)
) as t
) as t2
on b.SYS_RECORD_ID=t2.SYS_RECORD_ID


update MOE_20240326.dbo.M_D_BOREHOLE_CONSTRUCTION
set 
SYS_RECORD_ID=t2.new_SRI
from 
MOE_20240326.dbo.M_D_BOREHOLE_CONSTRUCTION as b
inner join
(
select
t.new_SRI
,ROW_NUMBER() over (order by t.new_SRI) as SYS_RECORD_ID
from 
(
select
top 75000
v.NEW_ID as new_SRI
from 
OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_001 as v
where 
v.NEW_ID 
not in
(
select SYS_RECORD_ID from OAK_20160831_MASTER.dbo.D_BOREHOLE_CONSTRUCTION
)
) as t
) as t2
on b.SYS_RECORD_ID=t2.SYS_RECORD_ID

--***** FM_D_GEOLOGY_FEATURE

select
dgf.LOC_ID
,ycl.new_LOC_ID
from 
MOE_20240326.dbo.M_D_GEOLOGY_FEATURE as dgf
inner join MOE_20240326.dbo.YC_20240326_new_LOC_ID_BH_ID as ycl
on dgf.LOC_ID=ycl.BORE_HOLE_ID


update MOE_20240326.dbo.M_D_GEOLOGY_FEATURE
set
LOC_ID=ycl.new_LOC_ID
from 
MOE_20240326.dbo.M_D_GEOLOGY_FEATURE as dgf
inner join MOE_20240326.dbo.YC_20240326_new_LOC_ID_BH_ID as ycl
on dgf.LOC_ID=ycl.BORE_HOLE_ID


-- also update the SYS_RECORD_ID field

-- how many records are there

select
count(*) 
from 
MOE_20240326.dbo.M_D_GEOLOGY_FEATURE

-- 2016.05.31 25932 records
-- 2017.09.05 14093
-- 2018.05.30 15252
-- v20190509 8344 rows 
-- v20200721 7253 rows
-- v20210119 15401 rows
-- v20220328 3786 rows
-- v20230324 3021 rows
-- v20240326 3336 rows

select
t1.SYS_RECORD_ID
,t2.NEW_ID as new_SYS_RECORD_ID
from
MOE_20240326.dbo.M_D_GEOLOGY_FEATURE as dgf
inner join
(
select
dbc.SYS_RECORD_ID
,ROW_NUMBER() over (order by SYS_RECORD_ID) as rnum
from 
MOE_20240326.dbo.M_D_GEOLOGY_FEATURE as dbc
) as t1
on 
dgf.SYS_RECORD_ID=t1.SYS_RECORD_ID
inner join 
(
select
top 20000
vr.NEW_ID 
,ROW_NUMBER() over (order by NEW_ID) as rnum
from 
OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_001 as vr
where
vr.NEW_ID
not in
(
select FEATURE_ID from [OAK_20160831_MASTER].dbo.D_GEOLOGY_FEATURE
)
) as t2
on
t1.rnum=t2.rnum


update MOE_20240326.dbo.M_D_GEOLOGY_FEATURE
set
SYS_RECORD_ID=t2.NEW_ID
from 
MOE_20240326.dbo.M_D_GEOLOGY_FEATURE as dgf
inner join
(
select
dbc.SYS_RECORD_ID
,ROW_NUMBER() over (order by SYS_RECORD_ID) as rnum
from 
MOE_20240326.dbo.M_D_GEOLOGY_FEATURE as dbc
) as t1
on 
dgf.SYS_RECORD_ID=t1.SYS_RECORD_ID
inner join 
(
select
top 20000
vr.NEW_ID 
,ROW_NUMBER() over (order by NEW_ID) as rnum
from 
OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_001 as vr
where
vr.NEW_ID
not in
(
select FEATURE_ID from [OAK_20160831_MASTER].dbo.D_GEOLOGY_FEATURE
)
) as t2
on
t1.rnum=t2.rnum

--***** FM_D_GEOLOGY_LAYER

select
dgl.LOC_ID
,ycl.new_LOC_ID
from 
MOE_20240326.dbo.M_D_GEOLOGY_LAYER as dgl
inner join MOE_20240326.dbo.YC_20240326_new_LOC_ID_BH_ID as ycl
on dgl.LOC_ID=ycl.BORE_HOLE_ID


update MOE_20240326.dbo.M_D_GEOLOGY_LAYER
set
LOC_ID=ycl.new_LOC_ID
from 
MOE_20240326.dbo.M_D_GEOLOGY_LAYER as dgl
inner join MOE_20240326.dbo.YC_20240326_new_LOC_ID_BH_ID as ycl
on dgl.LOC_ID=ycl.BORE_HOLE_ID

-- also update the SYS_RECORD_ID field

-- how many records are there

select
count(*) 
from 
MOE_20240326.dbo.M_D_GEOLOGY_LAYER

-- 2016.05.31 67491 records
-- 2017.09.05 35838
-- 2018.05.30 34050
-- v20190509 19071 rows 
-- v20200721 25005 rows
-- v20210119 49283 rows
-- v20220328 14034 rows
-- v20230324 14014 rows
-- v20240326 19366 rows

select
t1.SYS_RECORD_ID
,t2.NEW_ID as new_SYS_RECORD_ID
from
MOE_20240326.dbo.M_D_GEOLOGY_LAYER as dgl
inner join
(
select
dbc.SYS_RECORD_ID
,ROW_NUMBER() over (order by SYS_RECORD_ID) as rnum
from 
MOE_20240326.dbo.M_D_GEOLOGY_LAYER as dbc
) as t1
on 
dgl.SYS_RECORD_ID=t1.SYS_RECORD_ID
inner join 
(
select
top 60000
vr.NEW_ID 
,ROW_NUMBER() over (order by NEW_ID) as rnum
from 
OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_001 as vr
where
vr.NEW_ID
not in
(
select GEOL_ID from [OAK_20160831_MASTER].dbo.D_GEOLOGY_LAYER
)
) as t2
on
t1.rnum=t2.rnum


update MOE_20240326.dbo.M_D_GEOLOGY_LAYER
set
SYS_RECORD_ID=t2.NEW_ID
from
MOE_20240326.dbo.M_D_GEOLOGY_LAYER as dgl
inner join
(
select
dbc.SYS_RECORD_ID
,ROW_NUMBER() over (order by SYS_RECORD_ID) as rnum
from 
MOE_20240326.dbo.M_D_GEOLOGY_LAYER as dbc
) as t1
on 
dgl.SYS_RECORD_ID=t1.SYS_RECORD_ID
inner join 
(
select
top 60000
vr.NEW_ID 
,ROW_NUMBER() over (order by NEW_ID) as rnum
from 
OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_001 as vr
where
vr.NEW_ID
not in
(
select GEOL_ID from OAK_20160831_MASTER.dbo.D_GEOLOGY_LAYER
)
) as t2
on
t1.rnum=t2.rnum

--***** M_D_LOCATION

select
dloc.LOC_ID
,ycl.new_LOC_ID
from 
MOE_20240326.dbo.M_D_LOCATION as dloc
inner join MOE_20240326.dbo.YC_20240326_new_LOC_ID_BH_ID as ycl
on dloc.LOC_ID=ycl.BORE_HOLE_ID


update MOE_20240326.dbo.M_D_LOCATION
set
LOC_ID=ycl.new_LOC_ID
from 
MOE_20240326.dbo.M_D_LOCATION as dloc
inner join MOE_20240326.dbo.YC_20240326_new_LOC_ID_BH_ID as ycl
on dloc.LOC_ID=ycl.BORE_HOLE_ID


-- also update LOC_MASTER_LOC_ID

select
dloc.LOC_MASTER_LOC_ID
,ycl.new_LOC_ID
from 
MOE_20240326.dbo.M_D_LOCATION as dloc
inner join MOE_20240326.dbo.YC_20240326_new_LOC_ID_BH_ID as ycl
on dloc.LOC_MASTER_LOC_ID=ycl.BORE_HOLE_ID


update MOE_20240326.dbo.M_D_LOCATION
set
LOC_MASTER_LOC_ID=ycl.new_LOC_ID
from 
MOE_20240326.dbo.M_D_LOCATION as dloc
inner join MOE_20240326.dbo.YC_20240326_new_LOC_ID_BH_ID as ycl
on dloc.LOC_MASTER_LOC_ID=ycl.BORE_HOLE_ID


--***** M_D_LOCATION_ALIAS

select
dla.LOC_ID
,ycl.new_LOC_ID
from 
MOE_20240326.dbo.M_D_LOCATION_ALIAS as dla
inner join MOE_20240326.dbo.YC_20240326_new_LOC_ID_BH_ID as ycl
on dla.LOC_ID=ycl.BORE_HOLE_ID


update MOE_20240326.dbo.M_D_LOCATION_ALIAS
set
LOC_ID=ycl.new_LOC_ID
,SYS_RECORD_ID=ycl.new_LOC_ID
from 
MOE_20240326.dbo.M_D_LOCATION_ALIAS as dla
inner join MOE_20240326.dbo.YC_20240326_new_LOC_ID_BH_ID as ycl
on dla.LOC_ID=ycl.BORE_HOLE_ID

--***** 20210119
--***** At this point, the D_LOCATION_SPATIAL_HIST has already been created; the
--***** D_LOCATION_SPATIAL table will be created in G_10_24_01; the creation of
--***** D_LOCATION_ELEV and D_LOCATION_ELEV_HIST has been removed

--select
--*
--into MOE_20240326.dbo.M_D_LOCATION_SPATIAL_HIST_bck
--from 
--MOE_20240326.dbo.M_D_LOCATION_SPATIAL_HIST as dlsh
--
--drop table m_d_location_spatial_hist_bck

select
dlsh.LOC_ID
,ycl.new_LOC_ID
from 
MOE_20240326.dbo.M_D_LOCATION_SPATIAL_HIST as dlsh
inner join MOE_20240326.dbo.YC_20240326_new_LOC_ID_BH_ID as ycl
on dlsh.LOC_ID=ycl.BORE_HOLE_ID

update MOE_20240326.dbo.M_D_LOCATION_SPATIAL_HIST
set
LOC_ID=ycl.new_LOC_ID
from 
MOE_20240326.dbo.M_D_LOCATION_SPATIAL_HIST as dlsh
inner join MOE_20240326.dbo.YC_20240326_new_LOC_ID_BH_ID as ycl
on dlsh.LOC_ID=ycl.BORE_HOLE_ID


--***** M_D_LOCATION_PURPOSE

select
dpurp.LOC_ID
,ycl.new_LOC_ID
from 
MOE_20240326.dbo.M_D_LOCATION_PURPOSE as dpurp
inner join MOE_20240326.dbo.YC_20240326_new_LOC_ID_BH_ID as ycl
on dpurp.LOC_ID=ycl.BORE_HOLE_ID


update MOE_20240326.dbo.M_D_LOCATION_PURPOSE
set
LOC_ID=ycl.new_LOC_ID
from 
MOE_20240326.dbo.M_D_LOCATION_PURPOSE as dpurp
inner join MOE_20240326.dbo.YC_20240326_new_LOC_ID_BH_ID as ycl
on dpurp.LOC_ID=ycl.BORE_HOLE_ID

--alter table MOE_20240326.dbo.M_D_LOCATION_PURPOSE add SYS_RECORD_ID int 

--alter table MOE_20240326.dbo.M_D_LOCATION_PURPOSE add rkey int

-- make sure to update the count of random SYS_RECORD_IDs

select
count(*) 
from 
MOE_20240326.dbo.M_D_LOCATION_PURPOSE

-- v20210119 25519 rows
-- v20230424 18826 rows
-- v20240326 23131 rows

select
dpurp.LOC_ID
,dpurp.SYS_RECORD_ID
,dpurp.rkey
,t2.rkey
,t2.sri
from 
MOE_20240326.dbo.M_D_LOCATION_PURPOSE as dpurp
inner join
(
select
t.sri
,row_number() over (order by t.sri) as rkey
from 
(
select
top 30000
v.new_id as sri
from 
oak_20160831_master.dbo.v_sys_random_id_bulk_001 as v
where 
v.new_id not in
( select sys_record_id from oak_20160831_master.dbo.d_location_purpose )
) as t
) as t2
on dpurp.rkey=t2.rkey

update MOE_20240326.dbo.M_D_LOCATION_PURPOSE
set
sys_record_id= t2.sri
from 
MOE_20240326.dbo.M_D_LOCATION_PURPOSE as dpurp
inner join
(
select
t.sri
,row_number() over (order by t.sri) as rkey
from 
(
select
top 30000
v.new_id as sri
from 
oak_20160831_master.dbo.v_sys_random_id_bulk_001 as v
where 
v.new_id not in
( select sys_record_id from oak_20160831_master.dbo.d_location_purpose )
) as t
) as t2
on dpurp.rkey=t2.rkey

--***** FM_D_LOCATION_QA

select
dlq.LOC_ID
,ycl.new_LOC_ID
from 
MOE_20240326.dbo.M_D_LOCATION_QA as dlq
inner join MOE_20240326.dbo.YC_20240326_new_LOC_ID_BH_ID as ycl
on dlq.LOC_ID=ycl.BORE_HOLE_ID


update MOE_20240326.dbo.M_D_LOCATION_QA
set
LOC_ID=ycl.new_LOC_ID
from 
MOE_20240326.dbo.M_D_LOCATION_QA as dlq
inner join MOE_20240326.dbo.YC_20240326_new_LOC_ID_BH_ID as ycl
on dlq.LOC_ID=ycl.BORE_HOLE_ID

--***** M_D_INTERVAL


-- first the LOC_ID

select
dint.LOC_ID
,ycl.new_LOC_ID
from 
MOE_20240326.dbo.M_D_INTERVAL as dint
inner join MOE_20240326.dbo.YC_20240326_new_LOC_ID_BH_ID as ycl
on dint.LOC_ID=ycl.BORE_HOLE_ID


update MOE_20240326.dbo.M_D_INTERVAL
set
LOC_ID=ycl.new_LOC_ID
from 
MOE_20240326.dbo.M_D_INTERVAL as dint
inner join MOE_20240326.dbo.YC_20240326_new_LOC_ID_BH_ID as ycl
on dint.LOC_ID=ycl.BORE_HOLE_ID

-- then the INT_ID

select
dint.INT_ID
,yci.new_INT_ID
from 
MOE_20240326.dbo.M_D_INTERVAL as dint
inner join MOE_20240326.dbo.YC_20240326_new_INT_ID as yci
on dint.INT_ID=yci.INT_ID


update MOE_20240326.dbo.M_D_INTERVAL
set
INT_ID=yci.new_INT_ID
from 
MOE_20240326.dbo.M_D_INTERVAL as dint
inner join MOE_20240326.dbo.YC_20240326_new_INT_ID as yci
on dint.INT_ID=yci.INT_ID

--***** FM_D_INTERVAL_MONITOR

select
dmon.INT_ID
,yci.new_INT_ID
from 
MOE_20240326.dbo.M_D_INTERVAL_MONITOR as dmon
inner join MOE_20240326.dbo.YC_20240326_new_INT_ID as yci
on dmon.INT_ID=yci.INT_ID


update MOE_20240326.dbo.M_D_INTERVAL_MONITOR
set
INT_ID=yci.new_INT_ID
from 
MOE_20240326.dbo.M_D_INTERVAL_MONITOR as dmon
inner join MOE_20240326.dbo.YC_20240326_new_INT_ID as yci
on dmon.INT_ID=yci.INT_ID

-- update SYS_RECORD_ID, how many records are there

select
COUNT(*)
from 
MOE_20240326.dbo.M_D_INTERVAL_MONITOR 

-- 2016.05.31 28567 rows
-- 2017.09.05 17431
-- 2018.05.30 15705
-- v20190509 11930 rows 
-- v20200721 11830 rows
-- v20210119 24767 rows
-- v20220328 15269 rows
-- v20230324 18850 rows
-- v20240326 23170 rows

select
dim.SYS_RECORD_ID
,t2.new_SRI
from 
MOE_20240326.dbo.M_D_INTERVAL_MONITOR as dim
inner join
(
select
t1.new_SRI
,ROW_NUMBER() over (order by t1.new_SRI) as SYS_RECORD_ID
from 
(
select
top 30000
vr.NEW_ID as new_SRI
from 
OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_001 as vr
where
vr.NEW_ID
not in
(
select MON_ID from OAK_20160831_MASTER.dbo.D_INTERVAL_MONITOR
)
) as t1
) as t2
on dim.SYS_RECORD_ID=t2.SYS_RECORD_ID


update MOE_20240326.dbo.M_D_INTERVAL_MONITOR
set
SYS_RECORD_ID=t2.new_SRI
from 
MOE_20240326.dbo.M_D_INTERVAL_MONITOR as dim
inner join
(
select
t1.new_SRI
,ROW_NUMBER() over (order by t1.new_SRI) as SYS_RECORD_ID
from 
(
select
top 30000
vr.NEW_ID as new_SRI
from 
OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_001 as vr
where
vr.NEW_ID
not in
(
select MON_ID from OAK_20160831_MASTER.dbo.D_INTERVAL_MONITOR
)
) as t1
) as t2
on dim.SYS_RECORD_ID=t2.SYS_RECORD_ID

--***** Update D_INTERVAL_REF_ELEV

select
dref.INT_ID
,yci.new_INT_ID
from 
MOE_20240326.dbo.M_D_INTERVAL_REF_ELEV as dref
inner join MOE_20240326.dbo.YC_20240326_new_INT_ID as yci
on dref.INT_ID=yci.INT_ID


update MOE_20240326.dbo.M_D_INTERVAL_REF_ELEV
set
INT_ID=yci.new_INT_ID
from 
MOE_20240326.dbo.M_D_INTERVAL_REF_ELEV as dref
inner join MOE_20240326.dbo.YC_20240326_new_INT_ID as yci
on dref.INT_ID=yci.INT_ID

-- update SYS_RECORD_ID, how many records are there

select
COUNT(*)
from 
MOE_20240326.dbo.M_D_INTERVAL_REF_ELEV

-- 2016.05.31 28188 rows
-- 2017.09.05 17185
-- 2018.05.30 15578
-- v20190509 11851 rows 
-- v20200721 11830 rows
-- v20210119 24619 rows
-- v20220328 15235 rows
-- v20230324 18826 rows
-- v20240326 23131 rows

select
dim.SYS_RECORD_ID
,t2.new_SRI
from 
MOE_20240326.dbo.M_D_INTERVAL_REF_ELEV as dim
inner join
(
select
t1.new_SRI
,ROW_NUMBER() over (order by t1.new_SRI) as SYS_RECORD_ID
from 
(
select
top 30000
vr.NEW_ID as new_SRI
from 
OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_001 as vr
where
vr.NEW_ID
not in
(
select SYS_RECORD_ID from OAK_20160831_MASTER.dbo.D_INTERVAL_REF_ELEV
)
) as t1
) as t2
on dim.SYS_RECORD_ID=t2.SYS_RECORD_ID


update MOE_20240326.dbo.M_D_INTERVAL_REF_ELEV
set
SYS_RECORD_ID=t2.new_SRI
from 
MOE_20240326.dbo.M_D_INTERVAL_REF_ELEV as dim
inner join
(
select
t1.new_SRI
,ROW_NUMBER() over (order by t1.new_SRI) as SYS_RECORD_ID
from 
(
select
top 30000
vr.NEW_ID as new_SRI
from 
OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_001 as vr
where
vr.NEW_ID
not in
(
select SYS_RECORD_ID from OAK_20160831_MASTER.dbo.D_INTERVAL_REF_ELEV
)
) as t1
) as t2
on dim.SYS_RECORD_ID=t2.SYS_RECORD_ID


--***** Update D_INTERVAL_TEMPORAL_2

select
dit2.INT_ID
,yci.new_INT_ID
from 
MOE_20240326.dbo.M_D_INTERVAL_TEMPORAL_2 as dit2
inner join MOE_20240326.dbo.YC_20240326_new_INT_ID as yci
on dit2.INT_ID=yci.INT_ID


update MOE_20240326.dbo.M_D_INTERVAL_TEMPORAL_2
set
INT_ID=yci.new_INT_ID
from 
MOE_20240326.dbo.M_D_INTERVAL_TEMPORAL_2 as dit2
inner join MOE_20240326.dbo.YC_20240326_new_INT_ID as yci
on dit2.INT_ID=yci.INT_ID

-- update SYS_RECORD_ID, how many records are there

select
COUNT(*)
from 
MOE_20240326.dbo.M_D_INTERVAL_TEMPORAL_2

-- 2016.05.31 127810 rows
-- 2017.09.05 63645
-- 2018.05.30 83176
-- v20190509 33105 rows 
-- v20200721 51364 rows
-- v20210119 68226 rows
-- v20220328 12872 rows
-- v20230324 8486 rows
-- v20240326 11217 rows

select
dim.SYS_RECORD_ID
,t2.new_SRI
from 
MOE_20240326.dbo.M_D_INTERVAL_TEMPORAL_2 as dim
inner join
(
select
t1.new_SRI
,ROW_NUMBER() over (order by t1.new_SRI) as SYS_RECORD_ID
from 
(
select
top 90000
vr.NEW_ID as new_SRI
from 
OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_BULK_001 as vr
where
vr.NEW_ID
not in
(
select SYS_RECORD_ID from OAK_20160831_MASTER.dbo.D_INTERVAL_TEMPORAL_2
)
) as t1
) as t2
on dim.SYS_RECORD_ID=t2.SYS_RECORD_ID


update MOE_20240326.dbo.M_D_INTERVAL_TEMPORAL_2
set
SYS_RECORD_ID=t2.new_SRI
from 
MOE_20240326.dbo.M_D_INTERVAL_TEMPORAL_2 as dim
inner join
(
select
t1.new_SRI
,ROW_NUMBER() over (order by t1.new_SRI) as SYS_RECORD_ID
from 
(
select
top 90000
vr.NEW_ID as new_SRI
from 
OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_BULK_001 as vr
where
vr.NEW_ID
not in
(
select SYS_RECORD_ID from OAK_20160831_MASTER.dbo.D_INTERVAL_TEMPORAL_2
)
) as t1
) as t2
on dim.SYS_RECORD_ID=t2.SYS_RECORD_ID

-- in case of errors in inserting, we can reset the sys_record_ids here

select
dim.sys_record_id
,t.rkey
from 
MOE_20240326.dbo.M_D_INTERVAL_TEMPORAL_2 as dim
inner join
(
select
sys_record_id
,row_number() over (order by sys_record_id) as rkey
from
MOE_20240326.dbo.M_D_INTERVAL_TEMPORAL_2
) as t
on dim.sys_record_id=t.sys_record_id 

update MOE_20240326.dbo.M_D_INTERVAL_TEMPORAL_2
set
sys_record_id= t.rkey
from 
MOE_20240326.dbo.M_D_INTERVAL_TEMPORAL_2 as dim
inner join
(
select
sys_record_id
,row_number() over (order by sys_record_id) as rkey
from
MOE_20240326.dbo.M_D_INTERVAL_TEMPORAL_2
) as t
on dim.sys_record_id=t.sys_record_id

--***** Update D_PUMPTEST

select
dpump.INT_ID
,yci.new_INT_ID
from 
MOE_20240326.dbo.M_D_PUMPTEST as dpump
inner join MOE_20240326.dbo.YC_20240326_new_INT_ID as yci
on dpump.INT_ID=yci.INT_ID


update MOE_20240326.dbo.M_D_PUMPTEST
set
INT_ID=yci.new_INT_ID
from 
MOE_20240326.dbo.M_D_PUMPTEST as dpump
inner join MOE_20240326.dbo.YC_20240326_new_INT_ID as yci
on dpump.INT_ID=yci.INT_ID

-- modify the PUMP_TEST_ID, how many are there

select
COUNT(*)
from 
MOE_20240326.dbo.M_D_PUMPTEST

-- 2016.05.31 6268 rows
-- 2017.09.05 3150
-- 2018.05.30 5333
-- v20190509 1549 rows 
-- v20200721 2238 rows
-- v20210119 3048 rows
-- v20220328 525 rows
-- v20230324 306 rows
-- v20240326 420 rows

select
dpump.PUMP_TEST_ID
,ycp.new_PUMP_TEST_ID
from 
MOE_20240326.dbo.M_D_PUMPTEST as dpump
inner join MOE_20240326.dbo.YC_20240326_new_PUMP_TEST_ID as ycp
on dpump.PUMP_TEST_ID=ycp.PUMP_TEST_ID


update MOE_20240326.dbo.M_D_PUMPTEST
set
PUMP_TEST_ID=ycp.new_PUMP_TEST_ID
from 
MOE_20240326.dbo.M_D_PUMPTEST as dpump
inner join MOE_20240326.dbo.YC_20240326_new_PUMP_TEST_ID as ycp
on dpump.PUMP_TEST_ID=ycp.PUMP_TEST_ID


--***** Update D_PUMPTEST_STEP

select
dps.PUMP_TEST_ID
,ycp.new_PUMP_TEST_ID
from 
MOE_20240326.dbo.M_D_PUMPTEST_STEP as dps
inner join MOE_20240326.dbo.YC_20240326_new_PUMP_TEST_ID as ycp
on dps.PUMP_TEST_ID=ycp.PUMP_TEST_ID


update MOE_20240326.dbo.M_D_PUMPTEST_STEP
set
PUMP_TEST_ID=ycp.new_PUMP_TEST_ID
from 
MOE_20240326.dbo.M_D_PUMPTEST_STEP as dps
inner join MOE_20240326.dbo.YC_20240326_new_PUMP_TEST_ID as ycp
on dps.PUMP_TEST_ID=ycp.PUMP_TEST_ID

--select
--*
--from 
--MOE_20240326.dbo.M_D_PUMPTEST_STEP

-- how many are there

select
COUNT(*)
from 
MOE_20240326.dbo.M_D_PUMPTEST_STEP

-- modify the PUMP_TEST_ID, how many rows

-- 2016.05.31 5601 rows
-- 2017.09.05 2784
-- 2018.05.30 3849
-- v20190509 1383 rows
-- v20200721 2094 rows 
-- v20210119 2830 rows
-- v20220328 504 rows
-- v20230324 302 rows
-- v20240326 415 rows

-- modify the SYS_RECORD_ID

select
dps.SYS_RECORD_ID
,t2.new_SRI
from 
MOE_20240326.dbo.M_D_PUMPTEST_STEP as dps
inner join
(
select
t1.new_SRI
,ROW_NUMBER() over (order by t1.new_SRI) as SYS_RECORD_ID
from 
(
select
top 5000
vr.NEW_ID as new_SRI
from 
OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_001 as vr
where
vr.NEW_ID
not in
(
select SYS_RECORD_ID from OAK_20160831_MASTER.dbo.D_PUMPTEST_STEP
)
) as t1
) as t2
on dps.SYS_RECORD_ID=t2.SYS_RECORD_ID


update MOE_20240326.dbo.M_D_PUMPTEST_STEP
set
SYS_RECORD_ID=t2.new_SRI
from 
MOE_20240326.dbo.M_D_PUMPTEST_STEP as dps
inner join
(
select
t1.new_SRI
,ROW_NUMBER() over (order by t1.new_SRI) as SYS_RECORD_ID
from 
(
select
top 5000
vr.NEW_ID as new_SRI
from 
OAK_20160831_MASTER.dbo.V_SYS_RANDOM_ID_001 as vr
where
vr.NEW_ID
not in
(
select SYS_RECORD_ID from OAK_20160831_MASTER.dbo.D_PUMPTEST_STEP
)
) as t1
) as t2
on dps.SYS_RECORD_ID=t2.SYS_RECORD_ID







