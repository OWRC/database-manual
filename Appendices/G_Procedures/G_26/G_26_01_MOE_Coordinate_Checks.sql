
--***** G_26_01 = MOE Coordinate Checks

--***** Include any coordinate updates in D_LOCATION_COORD_HIST; these should be tagged with 
--***** a LOC_COORD_HIST_CODE of 5 with the DATA_ID of the current import

-- note that as of 20200721, this has been updated to match the D_LOCATION_SPATIAL_HIST
-- format for direct insertion; updates of related tables are not shown here

--***** DATA_ID Update

-- 2016.05.31 518
-- 2018.05.30 520
-- v20190509 521
-- v20200721 522
-- v20210202 523 
-- v20220328 524
-- v20230324 525

--***** Coordinate Check - MOE Z17/Z18 Coordinates (transformed)

-- The coordinates for Z17 and Z18 should be combined into a single table for reference; this
-- needs to be created/updated as part of the MOE import process; note the fields (in the following query)
-- required as part of the process

--***** v20210119
--***** These two zones are now combined in the table YC_20220328_BORE_HOLE_ID_COORDS_YC_SRC;
--***** a number of checks have already been performed with regard to its creation using
--***** the G.10 instructions

--***** v20220328 
--***** These two zones are now combined in the table YC_20220328_BORE_HOLE_ID_COORDS_YC; zone_orig
--***** is now just zone; we're using the table created in G.10.1

--***** 20230324
--***** Note that all coordinates have been translated to zone 17 and we are comparing all locations
--***** based upon the bore_hole_id/loc_id combination no matter the current QA_COORD_CODE; this is being
--***** added to DLSH as a record only as these records should not be necessarily trusted

-- v20230324 1009 rows

-- uncomment the insert part of the statement to add to DLSH

--insert into oak_20160831_master.dbo.d_location_spatial_hist
--(
--loc_id, loc_coord_hist_code, loc_coord_date, x, y, epsg_code, x_ouom, y_ouom, epsg_code_ouom, qa_coord_code, loc_coord_method, loc_coord_data_id,
--loc_elev_code, loc_elev_date, loc_elev, loc_elev_unit_code, qa_elev_code, sys_temp1, sys_temp2 
--)
select
dloc.LOC_ID
,cast( 5 as int ) as LOC_COORD_HIST_CODE 
,cast( '2023-03-24' as datetime ) as LOC_COORD_DATE
,m.x as X
,m.y as Y
,cast( 26917 as int ) as EPSG_CODE
,m.x as X_OUOM
,m.y as Y_OUOM
,26917 as EPSG_CODE_OUOM
,case
when m.utmrc is not null then cast(m.utmrc as int) 
else null
end as QA_COORD_CODE
,cast(
case
when m.location_method is not null then m.location_method + '; '
else ''
end
+
case
when m.improvement_location_method is not null then m.improvement_location_method + '; '
else ''
end
+
case
when m.improvement_location_source is not null then m.improvement_location_source + '; '
else ''
end
as varchar(255)) as LOC_COORD_METHOD
,cast( 525 as int ) as LOC_COORD_DATA_ID
,case
when m.elevation is not null then cast( 2 as int ) 
else null
end as LOC_ELEV_CODE
,case 
when m.elevation is not null then cast( '2023-03-24' as datetime ) 
else null
end as LOC_ELEV_DATE
,m.elevation as LOC_ELEV
,case
when m.elevation is not null then cast( 6 as int ) 
else null
end as LOC_ELEV_UNIT_CODE
,case
when len(m.elevrc)>0 and isnumeric( m.elevrc )=1 then cast(m.elevrc as int) 
else null
end as QA_ELEV_CODE
,cast( '20230324f' as varchar(255) ) as SYS_TEMP1
,cast( 20230324 as int ) as SYS_TEMP2
from 
moe_20230324.dbo.tblbore_hole_byzone_xy as m
inner join oak_20160831_master.dbo.d_location_alias as dla
on m.bore_hole_id=cast(dla.loc_name_alias as int)
inner join oak_20160831_master.dbo.d_location as dloc
on dla.loc_id=dloc.loc_id
inner join oak_20160831_master.dbo.v_sys_loc_coords_all as v
on dla.loc_id=v.loc_id
where
dla.loc_alias_type_code= 3
-- do not include the current DATA_ID
and (dloc.data_id is null or dloc.data_id<>525)
and m.utmrc<>9
and 
(
not( m.x between ( v.x - 5 ) and (v.x + 5) )
or not( m.y between (v.y - 5 ) and ( v.y + 5 ) )
) 
and not( dla.loc_id in ( select distinct( loc_id ) from oak_20160831_master.dbo.d_location_spatial_hist where loc_coord_hist_code= 5 ) )


-- check the inserted rows

select * from oak_20160831_master.dbo.d_location_spatial_hist where loc_coord_hist_code= 5 and loc_coord_data_id= 525

-- remove the blank values

select
*
from 
oak_20160831_master.dbo.d_location_spatial_hist
where
loc_coord_hist_code= 5
and loc_coord_data_id= 525
and len(loc_coord_method)=0

update oak_20160831_master.dbo.d_location_spatial_hist
set
loc_coord_method= null
where
loc_coord_hist_code= 5
and loc_coord_data_id= 525
and len(loc_coord_method)=0


-- check the locations that have been updated in comparison with the current coordinate information;
-- make sure to update DEF_MOE_UPD_DID in S_CONSTANT to the latest MOE import


select
*
from 
v_sys_chk_loc_coords_moe_upd
order by
loc_id


-- QA_COORD_CODE 9

-- for those that have an original QA_COORD_CODE of 9, replace with the updated coordinates (if the new QA_COORD_CODE is lower);
-- this is the base script; change the SYS_TEMP1 and SYS_TEMP2 values; note that we're tagging D_LOCATION_GEOM with a CHECK_CODE
-- of 10000 to indicate that the elevation needs to be populated/processed

select
v2.loc_id
,v2.spat_id
,v2.x
,v2.y
,'20230511a' as sys_temp1
,20230511 as sys_temp2
from 
v_sys_chk_loc_coords_moe_upd as v1
inner join v_sys_chk_loc_coords_moe_upd as v2
on v1.loc_id=v2.loc_id
where
v1.qa_coord_code= 9
and v2.qa_coord_code < v1.qa_coord_code


select
dls.*
from
d_location_spatial as dls
inner join
(
select
v2.loc_id
,v2.spat_id
,v2.x
,v2.y
,'20230511a' as sys_temp1
,20230511 as sys_temp2
from 
v_sys_chk_loc_coords_moe_upd as v1
inner join v_sys_chk_loc_coords_moe_upd as v2
on v1.loc_id=v2.loc_id
where
v1.qa_coord_code= 9
and v2.qa_coord_code < v1.qa_coord_code
) as t
on dls.loc_id=t.loc_id


update d_location_spatial
set
spat_id= t.spat_id
,spatial_comment= null
,sys_temp1= t.sys_temp1
,sys_temp2= t.sys_temp2
from
d_location_spatial as dls
inner join
(
select
v2.loc_id
,v2.spat_id
,v2.x
,v2.y
,'20230511a' as sys_temp1
,20230511 as sys_temp2
from 
v_sys_chk_loc_coords_moe_upd as v1
inner join v_sys_chk_loc_coords_moe_upd as v2
on v1.loc_id=v2.loc_id
where
v1.qa_coord_code= 9
and v2.qa_coord_code < v1.qa_coord_code
) as t
on dls.loc_id=t.loc_id


select
d.*
from 
d_location as d
inner join v_sys_loc_coords as v
on d.loc_id=v.loc_id
where
v.sys_temp1= '20230511a'


update d_location
set
loc_coord_easting= v.x
,loc_coord_northing= v.y
,loc_coord_code= null
,loc_coord_easting_ouom= null
,loc_coord_northing_ouom= null
,loc_coord_ouom_code= null
from 
d_location as d
inner join v_sys_loc_coords as v
on d.loc_id=v.loc_id
where
v.sys_temp1= '20230511a'


select
d.*
from 
d_location_qa as d
inner join v_sys_loc_coords as v
on d.loc_id=v.loc_id
where
v.sys_temp1= '20230511a'


update d_location_qa
set
qa_coord_confidence_code= v.qa_coord_code
,qa_coord_source= null
,qa_coord_method= null
,qa_coord_comment= null
,qa_elev_confidence_code= 10
,qa_elev_source= null
,qa_elev_method= null
,qa_elev_comment= null
,qa_elev_survey_date= null
,qa_data_source_code= null
from 
d_location_qa as d
inner join v_sys_loc_coords as v
on d.loc_id=v.loc_id
where
v.sys_temp1= '20230511a'


select
dlg.*
from 
d_location_geom as dlg
inner join v_sys_loc_coords as v
on dlg.loc_id=v.loc_id
inner join v_sys_loc_geometry as vg
on dlg.loc_id=vg.loc_id
inner join v_sys_loc_geometry_wkb as vw
on dlg.loc_id=vw.loc_id
where
v.sys_temp1= '20230511a'


update d_location_geom
set
coord_check= 10000
,geom= vg.geom
,geom_wkb= vw.geom_wkb
,sys_temp1= v.sys_temp1
,sys_temp2= v.sys_temp2
from 
d_location_geom as dlg
inner join v_sys_loc_coords as v
on dlg.loc_id=v.loc_id
inner join v_sys_loc_geometry as vg
on dlg.loc_id=vg.loc_id
inner join v_sys_loc_geometry_wkb as vw
on dlg.loc_id=vw.loc_id
where
v.sys_temp1= '20230511a'



-- QA_COORD_CODE <9 
-- examine those locations with QA codes less than 9; this is the base query



select
v2.loc_id
,v2.spat_id
,v2.x
,v2.y
,'20230511b' as sys_temp1
,20230511 as sys_temp2
from 
v_sys_chk_loc_coords_moe_upd as v1
inner join v_sys_chk_loc_coords_moe_upd as v2
on v1.loc_id=v2.loc_id
where
v1.qa_coord_code< 9
and v2.qa_coord_code < v1.qa_coord_code


-- compare the values

select
v.loc_id
,v.x
,t.x as x_new
,v.y
,t.y as y_new
,v.qa_coord_code
,t.qa_coord_code as qa_coord_code_new
from
v_sys_loc_coords_all as v
inner join
(
select
v2.loc_id
,v2.spat_id
,v2.x
,v2.y
,v2.qa_coord_code
,'20230511b' as sys_temp1
,20230511 as sys_temp2
from 
v_sys_chk_loc_coords_moe_upd as v1
inner join v_sys_chk_loc_coords_moe_upd as v2
on v1.loc_id=v2.loc_id
where
v1.qa_coord_code< 9
and v2.qa_coord_code < v1.qa_coord_code
) as t
on v.loc_id=t.loc_id


update d_location_spatial
set
spat_id= t.spat_id
,spatial_comment= null
,sys_temp1= t.sys_temp1
,sys_temp2= t.sys_temp2
from
d_location_spatial as dls
inner join
(
select
v2.loc_id
,v2.spat_id
,v2.x
,v2.y
,'20230511b' as sys_temp1
,20230511 as sys_temp2
from 
v_sys_chk_loc_coords_moe_upd as v1
inner join v_sys_chk_loc_coords_moe_upd as v2
on v1.loc_id=v2.loc_id
where
v1.qa_coord_code< 9
and v2.qa_coord_code < v1.qa_coord_code
) as t
on dls.loc_id=t.loc_id


select
d.*
from 
d_location as d
inner join v_sys_loc_coords as v
on d.loc_id=v.loc_id
where
v.sys_temp1= '20230511b'


update d_location
set
loc_coord_easting= v.x
,loc_coord_northing= v.y
,loc_coord_code= null
,loc_coord_easting_ouom= null
,loc_coord_northing_ouom= null
,loc_coord_ouom_code= null
from 
d_location as d
inner join v_sys_loc_coords as v
on d.loc_id=v.loc_id
where
v.sys_temp1= '20230511b'


select
d.*
from 
d_location_qa as d
inner join v_sys_loc_coords as v
on d.loc_id=v.loc_id
where
v.sys_temp1= '20230511b'


update d_location_qa
set
qa_coord_confidence_code= v.qa_coord_code
,qa_coord_source= null
,qa_coord_method= null
,qa_coord_comment= null
,qa_elev_confidence_code= 10
,qa_elev_source= null
,qa_elev_method= null
,qa_elev_comment= null
,qa_elev_survey_date= null
,qa_data_source_code= null
from 
d_location_qa as d
inner join v_sys_loc_coords as v
on d.loc_id=v.loc_id
where
v.sys_temp1= '20230511b'


select
dlg.*
from 
d_location_geom as dlg
inner join v_sys_loc_coords as v
on dlg.loc_id=v.loc_id
inner join v_sys_loc_geometry as vg
on dlg.loc_id=vg.loc_id
inner join v_sys_loc_geometry_wkb as vw
on dlg.loc_id=vw.loc_id
where
v.sys_temp1= '20230511b'


update d_location_geom
set
coord_check= 10000
,geom= vg.geom
,geom_wkb= vw.geom_wkb
,sys_temp1= v.sys_temp1
,sys_temp2= v.sys_temp2
from 
d_location_geom as dlg
inner join v_sys_loc_coords as v
on dlg.loc_id=v.loc_id
inner join v_sys_loc_geometry as vg
on dlg.loc_id=vg.loc_id
inner join v_sys_loc_geometry_wkb as vw
on dlg.loc_id=vw.loc_id
where
v.sys_temp1= '20230511b'




select
*
from
d_location_geom
where
coord_check= 10000





--***** 20230324
--***** All of the following should not be used

--***** These are the old counts

-- v20200721 417008 rows
-- v20210119 380097 rows (bore_hole_id)
--           689971 rows (well_id)
-- v20220328 481987 rows (loc_id)

--select
--v.loc_id
--,v.moe_well_id
--,v.moe_bore_hole_id
--,vc.spat_id
--,vc.x
--,c.east83
--,cast( null as float) as east83_17
--,vc.y
--,c.north83
--,cast(null as float) as north83_17
--,c.zone
--,c.utmrc
--,vc.qa_coord_code
--,c.location_method
--,c.improvement_location_source
--,c.improvement_location_method
--,c.elevation
--,c.elevrc
--,row_number() over (order by v.loc_id) as rkey
--into moe_20220328.dbo.YC_20220328_BORE_HOLE_ID_COORDS_CMP
--from 
--oak_20160831_master.dbo.v_sys_moe_locations as v
--inner join oak_20160831_master.dbo.d_location as dloc
--on v.loc_id=dloc.loc_id
--inner join moe_20220328.dbo.tblbore_hole as c
--on v.moe_bore_hole_id=c.bore_hole_id
--inner join oak_20160831_master.dbo.v_sys_loc_coords as vc
--on v.loc_id=vc.loc_id
--where 
--dloc.data_id<>524
--and c.zone in (17,18)
--and v.loc_id not in 
--(
--select
--distinct( loc_id ) as loc_id
--from
--oak_20160831_master.dbo.d_location_spatial_hist
--where
--loc_coord_hist_code= 6
--)

--select count(*) from moe_20220328.dbo.YC_20220328_BORE_HOLE_ID_COORDS_CMP
--
--drop table moe_20220328.dbo.yc_20220328_bore_hole_id_coords_cmp
--
--drop table moe_20220328.dbo.yc_20220328_bore_hole_id_coords_upd

-- remove the duplicates based on LOC_ID

-- v20210119 11083 duplicates (well_id)
--           8 duplicates (bore_hole_id)
-- v20220328 150 duplicates

--select
--t.*
--from 
--(
--select
--loc_id
--,min(rkey) as rkey_keep
--,count(*) as rcount
--from 
--moe_20220328.dbo.YC_20220328_BORE_HOLE_ID_COORDS_CMP
--group by
--loc_id
--) as t
--where
--t.rcount>1

--delete from moe_20220328.dbo.YC_20220328_BORE_HOLE_ID_COORDS_CMP 
--where
--rkey in
--(
--select
--m.rkey
--from 
--moe_20220328.dbo.YC_20220328_BORE_HOLE_ID_COORDS_CMP as m
--inner join
--(
--select
--t.loc_id
--,t.rkey_keep
--from 
--(
--select
--loc_id
--,min(rkey) as rkey_keep
--,count(*) as rcount
--from 
--moe_20220328.dbo.YC_20220328_BORE_HOLE_ID_COORDS_CMP
--group by
--loc_id
--) as t
--where
--t.rcount>1
--) as t2
--on m.loc_id=t2.loc_id
--where
--m.rkey<>t2.rkey_keep
--)

-- after transoformation of coordinates, the resulting table will be named
-- YC_20220328_BORE_HOLE_ID_COORDS_UPD

--***** Coordinate Check 01 - MOE Coordinates - Township (QA 118)

-- remember, these didn't have valid coordinates; these are township centroids

-- the text fields should be checked for zero-length

-- update DATA_ID, SYS_TEMP1 and SYS_TEMP2

--select * from MOE_20220328.dbo.YC_20220328_BORE_HOLE_ID_COORDS_CMP where qa_coord_code= 118
--
---- 2018.05.30 0 rows
---- v20200721 240 rows
---- v20210119 770 rows
--
--
--select
--dloc.LOC_ID
--,dloc.LOC_COORD_EASTING
--,dloc.LOC_COORD_NORTHING
--,cast( 5 as int ) as LOC_COORD_HIST_CODE 
--,cast( '2023-03-24' as datetime ) as LOC_COORD_DATE
--,m.x as X
--,m.y as Y
--,cast( 26917 as int ) as EPSG_CODE
--,m.x as X_OUOM
--,m.y as Y_OUOM
--,26917 as EPSG_CODE_OUOM
--,case
--when m.utmrc is not null then cast(m.utmrc as int) 
--else null
--end as QA_COORD_CODE
--,cast(
--case
--when m.location_method is not null then m.location_method + '; '
--else ''
--end
--+
--case
--when m.improvement_location_method is not null then m.improvement_location_method + '; '
--else ''
--end
--+
--case
--when m.improvement_location_source is not null then m.improvement_location_source + '; '
--else ''
--end
--as varchar(255)) as LOC_COORD_METHOD
--,cast( 525 as int ) as LOC_COORD_DATA_ID
--,case
--when m.elevation is not null then cast( 2 as int ) 
--else null
--end as LOC_ELEV_CODE
--,case 
--when m.elevation is not null then cast( '2023-03-24' as datetime ) 
--else null
--end as LOC_ELEV_DATE
--,m.elevation as LOC_ELEV
--,case
--when m.elevation is not null then cast( 6 as int ) 
--else null
--end as LOC_ELEV_UNIT_CODE
--,case
--when len(m.elevrc)>0 and isnumeric( m.elevrc )=1 then cast(m.elevrc as int) 
--else null
--end as QA_ELEV_CODE
--,cast( '20230324f' as varchar(255) ) as SYS_TEMP1
--,cast( 20230324 as int ) as SYS_TEMP2
--from 
--moe_20230324.dbo.tblbore_hole_byzone_xy as m
--inner join oak_20160831_master.dbo.d_location_alias as dla
--on m.bore_hole_id=cast(dla.loc_name_alias as int)
--inner join oak_20160831_master.dbo.d_location as dloc
--on dla.loc_id=dloc.loc_id
--inner join oak_20160831_master.dbo.v_sys_loc_coords as v
--on dla.loc_id=v.loc_id
--where
--dla.loc_alias_type_code= 3
---- do not include the current DATA_ID
--and (dloc.data_id is null or dloc.data_id<>525)
--and m.utmrc<>9
--and 
--(
--not( m.x between ( v.x - 5 ) and (v.x + 5) )
--or not( m.y between (v.y - 5 ) and ( v.y + 5 ) )
--) 
--and not( dla.loc_id in ( select distinct( loc_id ) from oak_20160831_master.dbo.d_location_spatial_hist where loc_coord_hist_code= 5 ) )
--
--select * from moe_20230324.dbo.tblbore_hole_byzone_xy
--
----***** 20230324 
----***** This is the previous check
--
----select
----dloc.LOC_ID
----,dloc.LOC_COORD_EASTING
----,dloc.LOC_COORD_NORTHING
----,cast( 5 as int ) as LOC_COORD_HIST_CODE 
----,cast( '2022-03-28' as datetime ) as LOC_COORD_DATE
----,m.east83_17 as X
----,m.north83_17 as Y
----,cast( 26917 as int ) as EPSG_CODE
----,m.east83 as X_OUOM
----,m.north83 as Y_OUOM
----,case
----when m.zone='18' then 26918
----else 26917
----end as EPSG_CODE_OUOM
----,case
----when m.utmrc is not null then cast(m.utmrc as int) 
----else null
----end as QA_COORD_CODE
----,cast(
----case
----when m.location_method is not null then m.location_method + '; '
----else ''
----end
----+
----case
----when m.improvement_location_method is not null then m.improvement_location_method + '; '
----else ''
----end
----+
----case
----when m.improvement_location_source is not null then m.improvement_location_source + '; '
----else ''
----end
----as varchar(255)) as LOC_COORD_METHOD
----,cast( 'Updated from QA_COORD_CODE 118' as varchar(255) ) as LOC_COORD_COMMENT
----,cast( 524 as int ) as LOC_COORD_DATA_ID
----,case
----when m.elevation is not null then cast( 2 as int ) 
----else null
----end as LOC_ELEV_CODE
----,case 
----when m.elevation is not null then cast( '2022-03-28' as datetime ) 
----else null
----end as LOC_ELEV_DATE
----,m.elevation as LOC_ELEV
----,case
----when m.elevation is not null then cast( 6 as int ) 
----else null
----end as LOC_ELEV_UNIT_CODE
----,case
----when len(m.elevrc)>0 and isnumeric( m.elevrc )=1 then cast(m.elevrc as int) 
----else null
----end as QA_ELEV_CODE
----,cast( '20220510a' as varchar(255) ) as SYS_TEMP1
----,cast( 20220510 as int ) as SYS_TEMP2
----from 
----moe_20220328.dbo.yc_20220328_bore_hole_id_coords_upd as m
----inner join oak_20160831_master.dbo.d_location as dloc
----on m.loc_id=dloc.loc_id
----inner join oak_20160831_master.dbo.d_location_qa as dlqa
----on dloc.loc_id=dlqa.loc_id
----where
------ make sure to not include the current DATA_ID
----( dloc.data_id is null or dloc.data_id<>524 )
----and dlqa.qa_coord_confidence_code= 118
----and m.east83_17 is not null and m.north83_17 is not null
----and m.utmrc<>9
----and 
----(
----not( m.east83_17 between ( m.x - 5 ) and (m.x + 5) )
----or not( m.north83_17 between (m.y - 5 ) and ( m.y + 5 ) )
----)
--
--
--insert into oak_20160831_master.dbo.d_location_spatial_hist
--(
--loc_id
--,loc_coord_hist_code
--,loc_coord_date
--,x
--,y
--,epsg_code
--,x_ouom
--,y_ouom
--,epsg_code_ouom
--,qa_coord_code
--,loc_coord_method
--,loc_coord_comment
--,loc_coord_data_id
--,loc_elev_code
--,loc_elev_date
--,loc_elev
--,loc_elev_unit_code
--,qa_elev_code
--,sys_temp1
--,sys_temp2
--)
--select
--dloc.LOC_ID
--,cast( 5 as int ) as LOC_COORD_HIST_CODE 
--,cast( '2022-03-28' as datetime ) as LOC_COORD_DATE
--,m.east83_17 as X
--,m.north83_17 as Y
--,cast( 26917 as int ) as EPSG_CODE
--,m.east83 as X_OUOM
--,m.north83 as Y_OUOM
--,case
--when m.zone='18' then 26918
--else 26917
--end as EPSG_CODE_OUOM
--,case
--when m.utmrc is not null then cast(m.utmrc as int) 
--else null
--end as QA_COORD_CODE
--,cast(
--case
--when m.location_method is not null then m.location_method + '; '
--else ''
--end
--+
--case
--when m.improvement_location_method is not null then m.improvement_location_method + '; '
--else ''
--end
--+
--case
--when m.improvement_location_source is not null then m.improvement_location_source + '; '
--else ''
--end
--as varchar(255)) as LOC_COORD_METHOD
--,cast( 'Updated from QA_COORD_CODE 118' as varchar(255) ) as LOC_COORD_COMMENT
--,cast( 524 as int ) as LOC_COORD_DATA_ID
--,case
--when m.elevation is not null then cast( 2 as int ) 
--else null
--end as LOC_ELEV_CODE
--,case 
--when m.elevation is not null then cast( '2022-03-28' as datetime ) 
--else null
--end as LOC_ELEV_DATE
--,m.elevation as LOC_ELEV
--,case
--when m.elevation is not null then cast( 6 as int ) 
--else null
--end as LOC_ELEV_UNIT_CODE
--,case
--when len(m.elevrc)>0 and isnumeric( m.elevrc )=1 then cast(m.elevrc as int) 
--else null
--end as QA_ELEV_CODE
--,cast( '20220510a' as varchar(255) ) as SYS_TEMP1
--,cast( 20220510 as int ) as SYS_TEMP2
--from 
--moe_20220328.dbo.yc_20220328_bore_hole_id_coords_upd as m
--inner join oak_20160831_master.dbo.d_location as dloc
--on m.loc_id=dloc.loc_id
--inner join oak_20160831_master.dbo.d_location_qa as dlqa
--on dloc.loc_id=dlqa.loc_id
--where
---- make sure to not include the current DATA_ID
--( dloc.data_id is null or dloc.data_id<>524 )
--and dlqa.qa_coord_confidence_code= 118
--and m.east83_17 is not null and m.north83_17 is not null
--and m.utmrc<>9
--and 
--(
--not( m.east83_17 between ( m.x - 5 ) and (m.x + 5) )
--or not( m.north83_17 between (m.y - 5 ) and ( m.y + 5 ) )
--)
--
--
---- v20220328 270 rows
--
--
--select
--*
--from 
--oak_20160831_master.dbo.d_location_spatial_hist
--where
--sys_temp1= '20220510a'
--
--
----***** Coordinate Check 02 - MOE Coordinates - Invalid (QA 117)
--
---- add the present field to the YC_20220328_BORE_HOLE_ID_COORDS_UPD table
--
--alter table YC_20220328_BORE_HOLE_ID_COORDS_UPD add present int
--
---- we need to tag those whose coordinates are already present in the 
---- master database
--
---- v20210119 2 rows
---- v20220328 0 rows
--
--select
--m.*
--from 
--moe_20220328.dbo.yc_20220328_bore_hole_id_coords_upd as m
--inner join oak_20160831_master.dbo.d_location_qa as dlqa
--on m.loc_id=dlqa.loc_id
--inner join 
--(
--select
--loc_id
--,x
--,y
--from 
--oak_20160831_master.dbo.d_location_spatial_hist
--where
--x is not null and y is not null
--group by
--loc_id,x,y
--) as t
--on m.loc_id=t.loc_id and m.east83=t.x and m.north83=t.y
--where
--dlqa.qa_coord_confidence_code= 117
--
--update moe_20220328.dbo.yc_20220328_bore_hole_id_coords_upd
--set
--present= 1
--from 
--moe_20220328.dbo.yc_20220328_bore_hole_id_coords_upd as m
--inner join oak_20160831_master.dbo.d_location_qa as dlqa
--on m.loc_id=dlqa.loc_id
--inner join 
--(
--select
--loc_id
--,x
--,y
--from 
--oak_20160831_master.dbo.d_location_spatial_hist
--where
--x is not null and y is not null
--group by
--loc_id,x,y
--) as t
--on m.loc_id=t.loc_id and m.east83=t.x and m.north83=t.y
--where
--dlqa.qa_coord_confidence_code= 117
--
---- 2018.05.30 UTMZ17 2 rows; UTMZ18 0 rows
---- v20190509 UTMZ17 2 rows; UTMZ18 0 rows
---- v20200721 1 row (note that z17 and z18 tests are no longer necessary)
---- v20210119 0 rows
--
---- update DATA_ID, SYS_TEMP1 and SYS_TEMP2 as well as the dates
--
--select
--dloc.LOC_ID
--,dloc.LOC_COORD_EASTING
--,dloc.LOC_COORD_NORTHING
--,cast( 5 as int ) as LOC_COORD_HIST_CODE 
--,cast( '2021-01-19' as datetime ) as LOC_COORD_DATE
--,m.east83 as X
--,m.north83 as Y
--,cast( 26917 as int ) as EPSG_CODE
--,m.east83_orig as X_OUOM
--,m.north83_orig as Y_OUOM
--,case
--when m.zone_orig=18 then 26918
--else 26917
--end as EPSG_CODE_OUOM
----,m.utmrc as QA_COORD_CODE
--,case
--when m.utmrc is not null then cast(m.utmrc as int) 
--else null
--end as QA_COORD_CODE
--,cast(
--case
--when m.location_method is not null then m.location_method + '; '
--else ''
--end
--+
--case
--when m.improvement_location_method is not null then m.improvement_location_method + '; '
--else ''
--end
--+
--case
--when m.improvement_location_source is not null then m.improvement_location_source + '; '
--else ''
--end
--as varchar(255)) as LOC_COORD_METHOD
--,cast( 'Updated from QA_COORD_CODE [117]' as varchar(255) ) as LOC_COORD_COMMENT
--,cast( 523 as int ) as LOC_COORD_DATA_ID
--,case
--when m.elevation is not null then cast( 2 as int ) 
--else null
--end as LOC_ELEV_CODE
--,case 
--when m.elevation is not null then cast( '2021-01-19' as datetime ) 
--else null
--end as LOC_ELEV_DATE
--,m.elevation as LOC_ELEV
--,case
--when m.elevation is not null then cast( 6 as int ) 
--else null
--end as LOC_ELEV_UNIT_CODE
----,m.elevrc as QA_ELEV_CODE
--,case
--when len(m.elevrc)>0 then cast(m.elevrc as int) 
--else null
--end as QA_ELEV_CODE
--,cast( '20210202b' as varchar(255) ) as SYS_TEMP1
--,cast( 20210202 as int ) as SYS_TEMP2
--from 
--moe_20220328.dbo.yc_20220328_bore_hole_id_coords_upd as m
--inner join oak_20160831_master.dbo.d_location as dloc
--on m.loc_id=dloc.loc_id
--inner join oak_20160831_master.dbo.d_location_qa as dlqa
--on dloc.loc_id=dlqa.loc_id
--where
--dlqa.qa_coord_confidence_code= 117
--and m.present is null
--and 
--(
--not( dloc.loc_coord_easting between (m.east83 - 1) and (m.east83 + 1) )
--or not( dloc.loc_coord_northing between (m.north83 - 1) and (m.north83 + 1) )
--)
--
--
--insert into d_location_spatial_hist
--(
--loc_id
--,loc_coord_hist_code
--,loc_coord_date
--,x
--,y
--,epsg_code
--,x_ouom
--,y_ouom
--,epsg_code_ouom
--,qa_coord_code
--,loc_coord_method
--,loc_coord_comment
--,loc_coord_data_id
--,loc_elev_code
--,loc_elev_date
--,loc_elev
--,loc_elev_unit_code
--,qa_elev_code
--,sys_temp1
--,sys_temp2
--)
--select
--dloc.LOC_ID
--,dloc.LOC_COORD_EASTING
--,dloc.LOC_COORD_NORTHING
--,cast( 5 as int ) as LOC_COORD_HIST_CODE 
--,cast( '2021-01-19' as datetime ) as LOC_COORD_DATE
--,m.east83 as X
--,m.north83 as Y
--,cast( 26917 as int ) as EPSG_CODE
--,m.east83_orig as X_OUOM
--,m.north83_orig as Y_OUOM
--,case
--when m.zone_orig=18 then 26918
--else 26917
--end as EPSG_CODE_OUOM
----,m.utmrc as QA_COORD_CODE
--,case
--when m.utmrc is not null then cast(m.utmrc as int) 
--else null
--end as QA_COORD_CODE
--,cast(
--case
--when m.location_method is not null then m.location_method + '; '
--else ''
--end
--+
--case
--when m.improvement_location_method is not null then m.improvement_location_method + '; '
--else ''
--end
--+
--case
--when m.improvement_location_source is not null then m.improvement_location_source + '; '
--else ''
--end
--as varchar(255)) as LOC_COORD_METHOD
--,cast( 'Updated from QA_COORD_CODE [117]' as varchar(255) ) as LOC_COORD_COMMENT
--,cast( 523 as int ) as LOC_COORD_DATA_ID
--,case
--when m.elevation is not null then cast( 2 as int ) 
--else null
--end as LOC_ELEV_CODE
--,case 
--when m.elevation is not null then cast( '2021-01-19' as datetime ) 
--else null
--end as LOC_ELEV_DATE
--,m.elevation as LOC_ELEV
--,case
--when m.elevation is not null then cast( 6 as int ) 
--else null
--end as LOC_ELEV_UNIT_CODE
----,m.elevrc as QA_ELEV_CODE
--,case
--when len(m.elevrc)>0 then cast(m.elevrc as int) 
--else null
--end as QA_ELEV_CODE
--,cast( '20210202b' as varchar(255) ) as SYS_TEMP1
--,cast( 20210202 as int ) as SYS_TEMP2
--from 
--moe_20220328.dbo.yc_20220328_bore_hole_id_coords_upd as m
--inner join oak_20160831_master.dbo.d_location as dloc
--on m.loc_id=dloc.loc_id
--inner join oak_20160831_master.dbo.d_location_qa as dlqa
--on dloc.loc_id=dlqa.loc_id
--where
--dlqa.qa_coord_confidence_code= 117
--and m.present is null
--and 
--(
--not( dloc.loc_coord_easting between (m.east83 - 1) and (m.east83 + 1) )
--or not( dloc.loc_coord_northing between (m.north83 - 1) and (m.north83 + 1) )
--)
--
--
----***** Coordinate Check 03 - MOE Coordinates - Valid Coordinates (non-QA 117)
----***** note that we're excluding QA 117/118; we're also excluding MOE
----***** coordinates that have already been loaded
--
---- make sure to check whether these have already been added to DLSH; remember, these
---- return those records that are currently present and need to be marked
--
---- v20210119 240200
---- v20220328 320803 rows
--
--select
----count(*)
--m.*
--from 
--moe_20220328.dbo.yc_20220328_bore_hole_id_coords_upd as m
--inner join oak_20160831_master.dbo.d_location_qa as dlqa
--on m.loc_id=dlqa.loc_id
--inner join 
--(
--select
--loc_id
--,x
--,y
--from 
--oak_20160831_master.dbo.d_location_spatial_hist
--where
--x is not null and y is not null
--group by
--loc_id,x,y
--) as t
--on m.loc_id=t.loc_id and m.east83_17=t.x and m.north83_17=t.y
--where
--dlqa.qa_coord_confidence_code not in ( 117, 118 )
--
---- reset present if a mistake has been made (v20220328)
--update moe_20220328.dbo.yc_20220328_bore_hole_id_coords_upd
--set
--present= null
--where
--present= 2
--
--
--update moe_20220328.dbo.yc_20220328_bore_hole_id_coords_upd
--set
--present= 2
--from 
--moe_20220328.dbo.yc_20220328_bore_hole_id_coords_upd as m
--inner join oak_20160831_master.dbo.d_location_qa as dlqa
--on m.loc_id=dlqa.loc_id
--inner join 
--(
--select
--loc_id
--,x
--,y
--from 
--oak_20160831_master.dbo.d_location_spatial_hist
--where
--x is not null and y is not null
--group by
--loc_id,x,y
--) as t
--on m.loc_id=t.loc_id and m.east83_17=t.x and m.north83_17=t.y
--where
--dlqa.qa_coord_confidence_code not in ( 117, 118 )
--
---- We're going to round the final coordinates for locations in Zone 18
--
---- Don't forget to change the values of DATA_ID, SYS_TEMP1 and SYS_TEMP2
--
---- 2018.05.30 8355 records
---- v20190509 192 rows
---- v20200721 12977 rows
---- v20210119 121 rows
---- v20220328 0 rows
--
--
--select
--dloc.LOC_ID
--,dloc.LOC_COORD_EASTING
--,dloc.LOC_COORD_NORTHING
--,cast( 5 as int ) as LOC_COORD_HIST_CODE 
--,cast( '2022-03-28' as datetime ) as LOC_COORD_DATE
--,m.east83_17 as X
--,m.north83_17 as Y
--,cast( 26917 as int ) as EPSG_CODE
--,m.east83 as X_OUOM
--,m.north83 as Y_OUOM
--,case
--when m.zone=18 then 26918
--else 26917
--end as EPSG_CODE_OUOM
--,case
--when m.utmrc is not null and isnumeric( m.utmrc )=1 then cast(m.utmrc as int) 
--else null
--end as QA_COORD_CODE
--,cast(
--case
--when m.location_method is not null then m.location_method + '; '
--else ''
--end
--+
--case
--when m.improvement_location_method is not null then m.improvement_location_method + '; '
--else ''
--end
--+
--case
--when m.improvement_location_source is not null then m.improvement_location_source + '; '
--else ''
--end
--as varchar(255)) as LOC_COORD_METHOD
--,cast( 'Updated from various QA_COORD_CODEs (CHECK03)' as varchar(255) ) as LOC_COORD_COMMENT
--,cast( 524 as int ) as LOC_COORD_DATA_ID
--,case
--when m.elevation is not null then cast( 2 as int ) 
--else null
--end as LOC_ELEV_CODE
--,case 
--when m.elevation is not null then cast( '2022-03-28' as datetime ) 
--else null
--end as LOC_ELEV_DATE
--,m.elevation as LOC_ELEV
--,case
--when m.elevation is not null then cast( 6 as int ) 
--else null
--end as LOC_ELEV_UNIT_CODE
----,m.elevrc as QA_ELEV_CODE
--,case
--when len(m.elevrc)>0 then cast(m.elevrc as int) 
--else null
--end as QA_ELEV_CODE
--,cast( '20220510c' as varchar(255) ) as SYS_TEMP1
--,cast( 20220510 as int ) as SYS_TEMP2
--from 
--moe_20220328.dbo.yc_20220328_bore_hole_id_coords_upd as m
--inner join oak_20160831_master.dbo.d_location as dloc
--on m.loc_id=dloc.loc_id
--inner join oak_20160831_master.dbo.d_location_qa as dlqa
--on dloc.loc_id=dlqa.loc_id
--where
--(dloc.data_id is null or dloc.data_id<>524 )
--and dlqa.qa_coord_confidence_code not in ( 117, 118 )
--and m.present is null
--and 
--(
--not( dloc.loc_coord_easting between (m.east83_17 - 1) and (m.east83_17 + 1) )
--or not( dloc.loc_coord_northing between (m.north83_17 - 1) and (m.north83_17 + 1) )
--)
--and m.east83_17 is not null and m.north83_17 is not null
--and m.east83_17 between ( 100000 ) and ( 1000000 )
--and m.north83_17 between ( 1000000 ) and ( 6000000 )
--and dloc.loc_id not in
--(
--select
--distinct(loc_id)
--from 
--oak_20160831_master.dbo.d_location_spatial_hist
--where
--loc_coord_hist_code=5
--)
--
--
--insert into oak_20160831_master.dbo.d_location_spatial_hist
--(
--loc_id
--,loc_coord_hist_code
--,loc_coord_date
--,x
--,y
--,epsg_code
--,x_ouom
--,y_ouom
--,epsg_code_ouom
--,qa_coord_code
--,loc_coord_method
--,loc_coord_comment
--,loc_coord_data_id
--,loc_elev_code
--,loc_elev_date
--,loc_elev
--,loc_elev_unit_code
--,qa_elev_code
--,sys_temp1
--,sys_temp2
--)
--select
--dloc.LOC_ID
--,cast( 5 as int ) as LOC_COORD_HIST_CODE 
--,cast( '2022-03-28' as datetime ) as LOC_COORD_DATE
--,m.east83_17 as X
--,m.north83_17 as Y
--,cast( 26917 as int ) as EPSG_CODE
--,m.east83 as X_OUOM
--,m.north83 as Y_OUOM
--,case
--when m.zone=18 then 26918
--else 26917
--end as EPSG_CODE_OUOM
----,m.utmrc as QA_COORD_CODE
--,case
--when m.utmrc is not null and isnumeric( m.utmrc )=1 then cast(m.utmrc as int) 
--else null
--end as QA_COORD_CODE
--,cast(
--case
--when m.location_method is not null then m.location_method + '; '
--else ''
--end
--+
--case
--when m.improvement_location_method is not null then m.improvement_location_method + '; '
--else ''
--end
--+
--case
--when m.improvement_location_source is not null then m.improvement_location_source + '; '
--else ''
--end
--as varchar(255)) as LOC_COORD_METHOD
--,cast( 'Updated from various QA_COORD_CODEs (CHECK03)' as varchar(255) ) as LOC_COORD_COMMENT
--,cast( 524 as int ) as LOC_COORD_DATA_ID
--,case
--when m.elevation is not null then cast( 2 as int ) 
--else null
--end as LOC_ELEV_CODE
--,case 
--when m.elevation is not null then cast( '2022-03-28' as datetime ) 
--else null
--end as LOC_ELEV_DATE
--,m.elevation as LOC_ELEV
--,case
--when m.elevation is not null then cast( 6 as int ) 
--else null
--end as LOC_ELEV_UNIT_CODE
----,m.elevrc as QA_ELEV_CODE
--,case
--when len(m.elevrc)>0 then cast(m.elevrc as int) 
--else null
--end as QA_ELEV_CODE
--,cast( '20220328c' as varchar(255) ) as SYS_TEMP1
--,cast( 20220328 as int ) as SYS_TEMP2
--from 
--moe_20220328.dbo.yc_20220328_bore_hole_id_coords_upd as m
--inner join oak_20160831_master.dbo.d_location as dloc
--on m.loc_id=dloc.loc_id
--inner join oak_20160831_master.dbo.d_location_qa as dlqa
--on dloc.loc_id=dlqa.loc_id
--where
--(dloc.data_id is null or dloc.data_id<>524 )
--and dlqa.qa_coord_confidence_code not in ( 117, 118 )
--and m.present is null
--and 
--(
--not( dloc.loc_coord_easting between (m.east83_17 - 1) and (m.east83_17 + 1) )
--or not( dloc.loc_coord_northing between (m.north83_17 - 1) and (m.north83_17 + 1) )
--)
--and m.east83_17 is not null and m.north83_17 is not null
--and m.east83_17 between ( 100000 ) and ( 1000000 )
--and m.north83_17 between ( 1000000 ) and ( 6000000 )
--and dloc.loc_id not in
--(
--select
--distinct(loc_id)
--from 
--oak_20160831_master.dbo.d_location_spatial_hist
--where
--loc_coord_hist_code=5
--)
--
--
----***** Coordinate Check 06 - MOE Coordinates - Invalid (QA 117 or 118)
--
---- these we will populate with the MNR DEM elevations
--
---- change the DATA_ID, dates and SYS_TEMP* fields
--
---- v20190509 0 rows
---- v20200721 241 rows
---- v20210202 770 rows
---- v20220328 270 rows
--
--select
--dloc.loc_id
--,dlsh.loc_coord_hist_code
--,dlsh.loc_coord_date
--,dlsh.x
--,dlsh.y
--,dlsh.epsg_code
--,dlsh.x_ouom
--,dlsh.y_ouom
--,dlsh.epsg_code_ouom
--,dlsh.qa_coord_code
--,dlsh.loc_coord_data_id
--,dlsh.loc_coord_method 
--,dlsh.loc_coord_comment 
--,3 as loc_elev_code
--,cast( '2022-03-28' as datetime ) as loc_elev_date
--,6 as loc_elev_unit_code
--,10 as qa_elev_code
--,'20220328d' as sys_temp1
--,20220328 as sys_temp2
--from 
--oak_20160831_master.dbo.d_location as dloc
--inner join oak_20160831_master.dbo.d_location_qa as dlqa
--on dloc.loc_id=dlqa.loc_id
--inner join oak_20160831_master.dbo.d_location_spatial_hist as dlsh
--on dloc.loc_id=dlsh.loc_id
--where 
--dlqa.qa_coord_confidence_code in ( 117, 118 )
--and dlsh.loc_coord_data_id= 524
--and ( dlsh.qa_elev_code is null or dlsh.qa_elev_code<>1 )
--
--select
--*
--from 
--oak_20160831_master.dbo.d_location_spatial_hist
--where
--sys_temp1= '20220328d'
--
--insert into oak_20160831_master.dbo.d_location_spatial_hist
--(
--loc_id
--,loc_coord_hist_code
--,loc_coord_date
--,x
--,y
--,epsg_code
--,x_ouom
--,y_ouom
--,epsg_code_ouom
--,qa_coord_code
--,loc_coord_data_id
--,loc_coord_method
--,loc_coord_comment
--,loc_elev_code
--,loc_elev_date
--,loc_elev_unit_code
--,qa_elev_code
--,sys_temp1
--,sys_temp2
--)
--select
--dloc.loc_id
--,dlsh.loc_coord_hist_code
--,dlsh.loc_coord_date
--,dlsh.x
--,dlsh.y
--,dlsh.epsg_code
--,dlsh.x_ouom
--,dlsh.y_ouom
--,dlsh.epsg_code_ouom
--,dlsh.qa_coord_code
--,dlsh.loc_coord_data_id
--,dlsh.loc_coord_method 
--,dlsh.loc_coord_comment 
--,3 as loc_elev_code
--,cast( '2022-03-28' as datetime ) as loc_elev_date
--,6 as loc_elev_unit_code
--,10 as qa_elev_code
--,'20220328d' as sys_temp1
--,20220328 as sys_temp2
--from 
--oak_20160831_master.dbo.d_location as dloc
--inner join oak_20160831_master.dbo.d_location_qa as dlqa
--on dloc.loc_id=dlqa.loc_id
--inner join oak_20160831_master.dbo.d_location_spatial_hist as dlsh
--on dloc.loc_id=dlsh.loc_id
--where 
--dlqa.qa_coord_confidence_code in ( 117, 118 )
--and dlsh.loc_coord_data_id= 524
--and ( dlsh.qa_elev_code is null or dlsh.qa_elev_code<>1 )
--
--
----***** Coordinate Check 07 - MOE Coordinates - QA Improvement
--
---- check for QA code updates; also, check to see if these have previously been corrected
--
---- make sure to update DATA_ID, SYS_TEMP* and various other fields
--
---- the following does not include separation of QA 9 and the remainder
---- v20190509 45 rows
--
---- we'll first check against current QA codes of 9; note that we don't want the elevations
---- as these will be updated with the current DEM
--
---- v20200721 4796 rows (8219 rows total)
---- v20210119 0 rows
---- v20220328 0 rows
--
--select
--dlsh.loc_id
--,dlsh.loc_coord_hist_code
--,dlsh.loc_coord_date
--,dlsh.x
--,dlsh.y
--,dlsh.epsg_code
--,dlsh.x_ouom
--,dlsh.y_ouom
--,dlsh.epsg_code_ouom
--,dlsh.qa_coord_code
--,dlsh.loc_coord_method
--,dlsh.loc_coord_comment + '; Updated from QA_COORD_CODE 9 (CHECK07)' as loc_coord_comment
--,dlsh.loc_coord_data_id
--,cast( 3 as int ) as loc_elev_code
--,cast( '2022-03-28' as datetime ) as loc_elev_date
--,cast( 6 as int ) as loc_elev_unit_code
--,cast( 10 as int ) as qa_elev_code
--,'20220510e' as sys_temp1
--,20220510 as sys_temp2
--from 
--oak_20160831_master.dbo.d_location_spatial_hist as dlsh
--inner join oak_20160831_master.dbo.v_sys_loc_coords as v
--on dlsh.loc_id=v.loc_id
--where 
--dlsh.sys_temp1= '20220328b'
--and dlsh.qa_coord_code < v.qa_coord_code
--and v.qa_coord_code= 9
--
--insert into d_location_spatial_hist
--(
--loc_id
--,loc_coord_hist_code
--,loc_coord_date
--,x
--,y
--,epsg_code
--,x_ouom
--,y_ouom
--,epsg_code_ouom
--,qa_coord_code
--,loc_coord_method
--,loc_coord_comment
--,loc_coord_data_id
--,loc_elev_code
--,loc_elev_date
--,loc_elev_unit_code
--,qa_elev_code
--,sys_temp1
--,sys_temp2
--)
--select
--dlsh.loc_id
--,dlsh.loc_coord_hist_code
--,dlsh.loc_coord_date
--,dlsh.x
--,dlsh.y
--,dlsh.epsg_code
--,dlsh.x_ouom
--,dlsh.y_ouom
--,dlsh.epsg_code_ouom
--,dlsh.qa_coord_code
--,dlsh.loc_coord_method
--,dlsh.loc_coord_comment + '; Updated from QA_COORD_CODE 9 (CHECK07)' as loc_coord_comment
--,dlsh.loc_coord_data_id
--,cast( 3 as int ) as loc_elev_code
--,cast( '2022-03-28' as datetime ) as loc_elev_date
--,cast( 6 as int ) as loc_elev_unit_code
--,cast( 10 as int ) as qa_elev_code
--,'20220510e' as sys_temp1
--,20220510 as sys_temp2
--from 
--oak_20160831_master.dbo.d_location_spatial_hist as dlsh
--inner join oak_20160831_master.dbo.v_sys_loc_coords as v
--on dlsh.loc_id=v.loc_id
--where 
--dlsh.sys_temp1= '20220328b'
--and dlsh.qa_coord_code < v.qa_coord_code
--and v.qa_coord_code= 9
--
--
---- we'll now check against the remaing current QA codes; note that we don't want the elevations
---- as these will be updated with the current DEM
--
---- v20200721 3423 rows (3359 after checking for manual edits)
---- v20210119 0 rows
---- v20220328 0 rows
--
--select
--dlsh.loc_id
--,dlsh.loc_coord_hist_code
--,dlsh.loc_coord_date
--,dlsh.x
--,dlsh.y
--,dlsh.epsg_code
--,dlsh.x_ouom
--,dlsh.y_ouom
--,dlsh.epsg_code_ouom
--,dlsh.qa_coord_code
--,dlsh.loc_coord_method
--,dlsh.loc_coord_comment + '; Updated from QA_COORD_CODE ' + cast( v.qa_coord_code as varchar(255) ) + ' (CHECK07)' as loc_coord_comment
--,dlsh.loc_coord_data_id
--,cast( 3 as int ) as loc_elev_code
--,cast( '2022-03-28' as datetime ) as loc_elev_date
--,cast( 6 as int ) as loc_elev_unit_code
--,cast( 10 as int ) as qa_elev_code
--,'20220510f' as sys_temp1
--,20220510 as sys_temp2
--from 
--oak_20160831_master.dbo.d_location_spatial_hist as dlsh
--inner join oak_20160831_master.dbo.v_sys_loc_coords as v
--on dlsh.loc_id=v.loc_id
--inner join oak_20160831_master.dbo.d_location_spatial_hist as dlsh2
--on v.spat_id=dlsh2.spat_id
--where 
--dlsh.sys_temp1= '20220510b'
--and dlsh.qa_coord_code < v.qa_coord_code
--and v.qa_coord_code <> 9 
--and dlsh2.loc_coord_hist_code < 6
--
---- have any of these been updated manually; assign a LOC_COORD_HIST_CODE of '8' to these;
---- note that we're reviewing the comment fields, the sys_user_stamp field and loc_elev_code
---- field (the latter for those marked as 'surveyed'); the loc_coord_hist_code is being used
---- as an initial filter as anything 6 or above has been manually edited (in some way)
--
---- v20210119 0 rows
---- v20220328 0 rows
--
--select
--dlsh2.*
----distinct( dlsh2.loc_coord_comment )
--from 
--oak_20160831_master.dbo.d_location_spatial_hist as dlsh
--inner join oak_20160831_master.dbo.v_sys_loc_coords as v
--on dlsh.loc_id=v.loc_id
--inner join oak_20160831_master.dbo.d_location_spatial_hist as dlsh2
--on v.spat_id=dlsh2.spat_id
--where
--dlsh.sys_temp1= '20220510b'
--and dlsh.qa_coord_code < v.qa_coord_code
--and v.qa_coord_code <> 9 
--and dlsh2.loc_coord_hist_code < 6
--
---- insert these into d_location_spatial_hist and update the elevations; tag the DLS table
--
--insert into d_location_spatial_hist
--(
--loc_id
--,loc_coord_hist_code
--,loc_coord_date
--,x
--,y
--,epsg_code
--,x_ouom
--,y_ouom
--,epsg_code_ouom
--,qa_coord_code
--,loc_coord_method
--,loc_coord_comment
--,loc_coord_data_id
--,loc_elev_code
--,loc_elev_date 
--,loc_elev_unit_code
--,qa_elev_code
--,sys_temp1
--,sys_temp2
--)
--select
--dlsh.loc_id
--,dlsh.loc_coord_hist_code
--,dlsh.loc_coord_date
--,dlsh.x
--,dlsh.y
--,dlsh.epsg_code
--,dlsh.x_ouom
--,dlsh.y_ouom
--,dlsh.epsg_code_ouom
--,dlsh.qa_coord_code
--,dlsh.loc_coord_method
--,dlsh.loc_coord_comment + '; Updated from QA_COORD_CODE ' + cast( v.qa_coord_code as varchar(255) ) + ' (CHECK07)' as loc_coord_comment
--,dlsh.loc_coord_data_id
--,cast( 3 as int ) as loc_elev_code
--,cast( '2022-03-28' as datetime ) as loc_elev_date
--,cast( 6 as int ) as loc_elev_unit_code
--,cast( 10 as int ) as qa_elev_code
--,'20220510b' as sys_temp1
--,20220510 as sys_temp2
--from 
--d_location_spatial_hist as dlsh
--inner join v_sys_loc_coords as v
--on dlsh.loc_id=v.loc_id
--inner join d_location_spatial_hist as dlsh2
--on v.spat_id=dlsh2.spat_id
--where 
--dlsh.sys_temp1= '20220510b'
--and dlsh.qa_coord_code < v.qa_coord_code
--and v.qa_coord_code <> 9 
--and dlsh2.loc_coord_hist_code < 6
