--***** G.27 York Database - Incorporation of Temporal Data

--** This series of scripts is used to merge data from a York DB (YKDB)
--** source (in, basically but not entirely, SiteFX format) into
--** the master ORMGP database (ORMDB).  It is based on the association of
--** intervals between the databases as found in the
--** D_INTERVAL_ALIAS table (i.e. those with an INT_ALIAS_TYPE_CODE
--** of '1'.

--** Creates a series of views to assemble the data that will be
--** imported (either 'new' or 'modified' information; the latter
--** changes will take precedence over any 'current' data found
--** within the master ORMGP db).   Note that changes in this case
--** only refer to the _D_INTERVAL_TEMPORAL_2 (and related) tables.

--** To hold the YKDB exported data (i.e. for import into ORMDB)
--** a temporary database of the form 'yorkhold_<yyyymmdd>' is to
--** be created (separately).

--** Updated:      20210721
--** Updated:      20220623
--** Updated:      20230717 (20231016)
--** Updated:      20240909 (20240721)
--** Last Updated: 20250502 (20250425)

-- D_INTERVAL_TEMPORAL_1A

-- Note that this extracts all data from the YKDB; those not 
-- present in the MADB will have a NULL YPDT_SAM_ID.

-- ***** 20250502 added CN_USER_ID manually; to be incorporated later

create view v_tr_dit1a as
select
t.int_id as ypdt_int_id
,t.york_int_id
,t2.ypdt_sam_id
,dit1a.sam_id as sam_id
,dit1a.sam_sample_name
,t2.ypdt_sam_sample_name
,dit1a.sam_sample_date
,dit1a.sam_analysis_date
,dit1a.sam_lab_sample_id
,t2.ypdt_sam_lab_sample_id
,dit1a.sam_lab_job_number
,t2.ypdt_sam_lab_job_number
,dit1a.sam_internal_id
,dit1a.sam_sample_name_ouom
,dit1a.sam_type_code
,t2.ypdt_sam_type_code
,dit1a.sam_sample_date_ouom
,dit1a.sam_comment
,dit1a.sam_data_file
,dit1a.sys_time_stamp
,dit1a.data_id
,row_number() over (order by dit1a.sam_id) as rkey
from 
yorkdb_20250425.dbo.d_interval_temporal_1a as dit1a
inner join 
-- this is the york-to-ypdt int_id conversion
(
select
dia.int_id
,cast(dia.int_name_alias as int) as york_int_id
from 
oak_20160831_master.dbo.d_interval_alias as dia
where dia.int_alias_type_code=1
) as t
on dit1a.int_id=t.york_int_id
left outer join 
-- this is the current contents of the master db
(
select
dit1a.int_id
,dit1a.sam_id as ypdt_sam_id
,dit1a.sam_sample_date 
,dit1a.sam_sample_name as ypdt_sam_sample_name
,dit1a.sam_lab_sample_id as ypdt_sam_lab_sample_id
,dit1a.sam_lab_job_number as ypdt_sam_lab_job_number
,dit1a.sam_type_code as ypdt_sam_type_code
from 
oak_20160831_master.dbo.d_interval_temporal_1a as dit1a
inner join oak_20160831_master.dbo.d_interval_alias as dia
on dit1a.int_id=dia.int_id
where 
dia.int_alias_type_code=1
) as t2
on t.int_id=t2.int_id and t2.sam_sample_date=dit1a.sam_sample_date and dit1a.sam_type_code=t2.ypdt_sam_type_code

-- D_INTERVAL_TEMPORAL_1B

-- Note that there is an issue matching the RD_NAME_CODEs between 
-- the DBs; as such, this view is used to compare the RD_NAME_OUOM
-- and RD_NAME_DESCRIPTION.  Unmatched names should either be added
-- to R_READING_ALIAS (where the parameter already exists) or 
-- R_RD_NAME_CODE (if it does not).  These will have a value of
-- -'-9999' for YPDT_RD_NAME_CODE

create view v_tr_rd_name_code as
select
t.rd_name_ouom
,case
when rrnc.rd_name_code is not null then rrnc.rd_name_code
when rrna.rd_name_code is not null then rrna.rd_name_code
else -9999
end as ypdt_rd_name_code
,case
when rrnc.rd_name_code is not null then rrnc.rd_name_description
when rrna.rd_name_code is not null then rrna.reading_name_alias
else '-9999'
end as ypdt_rd_name_description
from 
(
select
distinct( dit1b.rd_name_ouom ) as rd_name_ouom
from 
yorkdb_20250425.dbo.d_interval_temporal_1b as dit1b
inner join yorkdb_20250425.dbo.v_tr_dit1a as vselect
distinct( dit1b.rd_name_ouom ) as rd_name_ouom
from 
yorkdb_20250425.dbo.d_interval_temporal_1b as dit1b
inner join yorkdb_20250425.dbo.v_tr_dit1a as v
on dit1b.sam_id=v.sam_id
on dit1b.sam_id=v.sam_id
) as t
left outer join oak_20160831_master.dbo.r_rd_name_code as rrnc
on t.rd_name_ouom like rrnc.rd_name_description
left outer join oak_20160831_master.dbo.r_reading_name_alias as rrna
on t.rd_name_ouom like rrna.reading_name_alias

-- check the reading name codes
select
*
from 
yorkdb_20250425.dbo.v_tr_rd_name_code

-- D_INTERVAL_TEMPORAL_1B; UNIT_CODE

-- Note that, similarly to RD_NAME_CODEs, the UNIT_CODEs should
-- also be examined.  These should also be incorporated (or 
-- modified) as necessary.

create view v_tr_unit_code as
select
t.rd_unit_ouom
,t.rcount
,case
when ruc.unit_code is not null then ruc.unit_code
else
case
when t.rd_unit_ouom = 'pH' then 32
when t.rd_unit_ouom = 'mV' then 106
when t.rd_unit_ouom = '/100mL' then 207
else -9999
end
end as ypdt_unit_code
,case
when ruc.unit_code is not null then ruc.unit_description
else
case
when t.rd_unit_ouom = 'pH' then 'pH Units'
when t.rd_unit_ouom = 'mV' then 'millivolts'
when t.rd_unit_ouom = '/100mL' then 'per100mL'
else '-9999'
end
end as ypdt_unit_description 
from 
(
select
rd_unit_ouom
,count(*) as rcount
from 
yorkdb_20250425.dbo.d_interval_temporal_1b as d1b
inner join yorkdb_20250425.dbo.v_tr_dit1a as v
on d1b.sam_id=v.sam_id
group by 
rd_unit_ouom
) as t
left outer join oak_20160831_master.dbo.r_unit_code as ruc
on t.rd_unit_ouom = ruc.unit_description

-- check the unit codes
select
*
from 
yorkdb_20250425.dbo.v_tr_unit_code

-- D_INTERVAL_TEMPORAL_1B

-- Note that this extracts records from D_INTERVAL_TEMPORAL_1B
-- based upon v_tr_dit1a

create view v_tr_dit1b as
select
d1b.sam_id
,v.ypdt_sam_id
,d1b.rd_value_qualifier
,d1b.rd_value
,vrnc.ypdt_rd_name_code
,vuc.ypdt_unit_code
,d1b.rd_mdl
,d1b.rd_rdl
,vrnc.ypdt_rd_name_description
,d1b.rd_value_ouom
,vuc.ypdt_unit_description
,d1b.rd_mdl_ouom
,d1b.rd_rdl_ouom
,d1b.rd_comment
,d1b.sys_record_id
,cast(null as integer) as ypdt_sys_record_id
,d1b.sys_time_stamp
,row_number() over (order by d1b.sys_record_id) as rkey
from 
yorkdb_20250425.dbo.d_interval_temporal_1b as d1b
inner join
(
select
*
from 
yorkdb_20250425.dbo.v_tr_dit1a
where 
ypdt_sam_id is null
) as v
on d1b.sam_id=v.sam_id 
inner join yorkdb_20250425.dbo.v_tr_rd_name_code as vrnc
on d1b.rd_name_ouom=vrnc.rd_name_ouom
inner join yorkdb_20250425.dbo.v_tr_unit_code as vuc
on d1b.rd_unit_ouom=vuc.rd_unit_ouom

-- This is the old version; it seems to take quite a long
-- time to run in conjunction with subsequent statements

--create view v_tr_dit1b as
--select
--d1b.sam_id
--,v.ypdt_sam_id
--,d1b.rd_value_qualifier
--,d1b.rd_value
--,vrnc.ypdt_rd_name_code
--,vuc.ypdt_unit_code
--,d1b.rd_mdl
--,d1b.rd_rdl
--,vrnc.ypdt_rd_name_description
--,d1b.rd_value_ouom
--,vuc.ypdt_unit_description
--,d1b.rd_mdl_ouom
--,d1b.rd_rdl_ouom
--,d1b.rd_comment
--,d1b.sys_record_id
--,cast(null as integer) as ypdt_sys_record_id
--,d1b.sys_time_stamp
--,row_number() over (order by d1b.sys_record_id) as rkey
--from 
--york_20170823.dbo.d_interval_temporal_1b as d1b
--inner join york_20170823.dbo.v_tr_dit1a as v
--on d1b.sam_id=v.sam_id 
--inner join york_20170823.dbo.v_tr_rd_name_code as vrnc
--on d1b.rd_name_ouom=vrnc.rd_name_ouom
--inner join york_20170823.dbo.v_tr_unit_code as vuc
--on d1b.rd_unit_ouom=vuc.rd_unit_ouom

-- Create D_INTERVAL_TEMPORAL_1A/B tables for incorporation

SELECT
ypdt_int_id,
york_int_id,
ypdt_sam_id,
sam_id,
sam_sample_name,
ypdt_sam_sample_name,
sam_sample_date,
sam_analysis_date,
sam_lab_sample_id,
ypdt_sam_lab_sample_id,
sam_lab_job_number,
ypdt_sam_lab_job_number,
sam_internal_id,
sam_sample_name_ouom,
sam_type_code,
ypdt_sam_type_code,
sam_sample_date_ouom,
sam_comment,
sam_data_file,
sys_time_stamp,
data_id,
rkey
into yorkdb_20250425.dbo.dit1a
FROM 
yorkdb_20250425.dbo.v_tr_dit1a
where 
ypdt_sam_id is null

-- v20230717 5057 records
-- v20240909 4697 records
-- v20250502 3508 records

select count(*) as rcount from yorkdb_20250425.dbo.dit1a

SELECT
sam_id,
ypdt_sam_id,
rd_value_qualifier,
rd_value,
ypdt_rd_name_code,
ypdt_unit_code,
rd_mdl,
rd_rdl,
ypdt_rd_name_description,
rd_value_ouom,
ypdt_unit_description,
rd_mdl_ouom,
rd_rdl_ouom,
rd_comment,
sys_record_id,
ypdt_sys_record_id,
sys_time_stamp,
rkey
into yorkdb_20250425.dbo.dit1b
FROM 
yorkdb_20250425.dbo.v_tr_dit1b

-- v20230717 19892 records
-- v20240909 19358 records
-- v20250502 10667 records

select count(*) as rcount from yorkdb_20250425.dbo.dit1b


--***** The dit1a and dit1b tables should now be copied to temphold (or equivalent) in order to
--***** incorporate the information into the master db


-- Make sure to add a DATA_ID to D_DATA_SOURCE for the chemistry info

select * from oak_20160831_master.dbo.d_data_source where data_id>= 240003500

insert into oak_20160831_master.dbo.d_data_source
( data_id, data_type, data_description, data_filename, data_added_date )
values 
( 240003512,'Chemistry','Updated York Data - Chemistry; York DB 20250425','SiteFX_Full_backup_20250425.bak', '2025-05-08' )


-- generate the identifiers necessary for incorporation in the master db

-- v20230717 5057 records
-- v20240909 4697 records
-- v20250425 3508 records
select * from yorkdb_20250425_subset.dbo.dit1a

-- v20230717 max rkey 286986 
-- v20240909 max rkey 461614
-- v20250425 max rkey 367692
select max(rkey) from yorkdb_20250425_subset.dbo.dit1a

-- v20230717 19892 records
-- v20240909 19358 records
-- v20250425 10667 records
select * from yorkdb_20250425_subset.dbo.dit1b

-- v20230717 max rkey 19892 
-- v20240909 max rkey 19358
-- v20250425 max rkey 10667
select max(rkey) from yorkdb_20250425_subset.dbo.dit1b

-- update the TOP count
select
y.sam_id
,y.ypdt_sam_id
,t2.sam_id_new
update yorkdb_20250425_subset.dbo.dit1a
set
ypdt_sam_id= t2.sam_id_new
from 
yorkdb_20250425_subset.dbo.dit1a as y
inner join 
(
select
t.sam_id_new
,row_number() over (order by t.sam_id_new) as rkey
from 
(
select
top 550000
new_id as sam_id_new
from 
oak_20160831_master.dbo.v_sys_random_id_001
where
new_id not in 
( select sam_id from oak_20160831_master.dbo.d_interval_temporal_1a )
) as t
) as t2
on y.rkey=t2.rkey


-- update the DATA_ID, SYS_TEMP1 and SYS_TEMP2 and insert

insert into oak_20160831_master.dbo.d_interval_temporal_1a
( int_id, sam_id, sam_sample_name, sam_sample_date, sam_analysis_date, sam_lab_sample_id, sam_lab_job_number, sam_internal_id, sam_sample_name_ouom, 
  sam_type_code, sam_sample_date_ouom, sam_comment, sys_time_stamp, data_id, sys_temp1, sys_temp2 )
select
ypdt_int_id as int_id
,ypdt_sam_id as sam_id
,sam_sample_name
,sam_sample_date
,sam_analysis_date
,sam_lab_sample_id
,sam_lab_job_number
,sam_internal_id
,sam_sample_name_ouom
,sam_type_code
,sam_sample_date_ouom
,sam_comment
,sys_time_stamp
,240003512 as data_id
,'20250508a' as sys_temp1
,20250508 as sys_temp2
from 
yorkdb_20250425_subset.dbo.dit1a

-- add the new sam_id to dit1b and create the new sys_record_id

update yorkdb_20250425_subset.dbo.dit1b
set
ypdt_sam_id= d1a.ypdt_sam_id
from 
yorkdb_20250425_subset.dbo.dit1b as d1b
inner join yorkdb_20250425_subset.dbo.dit1a as d1a
on d1b.sam_id=d1a.sam_id

-- update the TOP count
select
y.sys_record_id
,y.ypdt_sys_record_id
,t2.sri_new
update yorkdb_20250425_subset.dbo.dit1b
set
ypdt_sys_record_id= t2.sri_new
from 
yorkdb_20250425_subset.dbo.dit1b as y
inner join 
(
select
t.sri_new
,row_number() over (order by t.sri_new) as rkey
from 
(
select
top 25000
new_id as sri_new
from 
oak_20160831_master.dbo.v_sys_random_id_001
where
new_id not in 
( select sys_record_id from oak_20160831_master.dbo.d_interval_temporal_1b )
) as t
) as t2
on y.rkey=t2.rkey

-- update SYS_TEMP1 and SYS_TEMP2 and insert

insert into oak_20160831_master.dbo.d_interval_temporal_1b
( sam_id, sys_record_id, rd_name_code, rd_value, unit_code, rd_value_qualifier, rd_mdl, rd_mdl_ouom, rd_rdl, rd_rdl_ouom,
  rd_name_ouom, rd_value_ouom, rd_unit_ouom, rd_comment, sys_time_stamp, sys_temp1, sys_temp2 )
select
ypdt_sam_id as sam_id
,ypdt_sys_record_id as sys_record_id
,ypdt_rd_name_code as rd_name_code
,rd_value
,ypdt_unit_code as unit_code
,rd_value_qualifier
,rd_mdl
,rd_mdl_ouom
,rd_rdl
,rd_rdl_ouom
,ypdt_rd_name_description as rd_name_ouom
,rd_value_ouom
,ypdt_unit_description as rd_unit_ouom
,rd_comment
,sys_time_stamp
,'20250508a' as sys_temp1
,20250508 as sys_temp2
from 
yorkdb_20250425_subset.dbo.dit1b




--***** D_INTERVAL_TEMPORAL_2 creation




--** Three equivalent (format) D_INTERVAL_TEMPORAL_2 tables
--** reside in the YKDB; a view that examines the data for
--** each must be created.  The tables are:

--** D_INTERVAL_TEMPORAL_2
--** D_INTERVAL_TEMPORAL_EXT
--** D_INTERVAL_TEMPORAL_YORK
--** D_INTVL_TEMP2

--** The basic structure of each view is basically the same

--** Be sure to review the rd_name_codes that exist to make sure new ones haven't been incorporated

select * from yorkdb_20250425.dbo.r_rd_name_code 
where rd_name_code in ( select distinct( rd_name_code ) as rd_name_code from yorkdb_20250425.dbo.d_interval_temporal_2 )

-- D_INTERVAL_TEMPORAL_2

create view v_tr_dit2 as
select
t.int_id as ypdt_int_id
,t.york_int_id
,d.rd_date
,case 
    when d.rd_name_code=707 then 67
    when d.rd_name_code=711 then 85
    else null 
end as rd_type_code
,case
    when d.rd_name_code=163 then 71037 
    when d.rd_name_code=369 then 70871
    when d.rd_name_code=699 then 447
    when d.rd_name_code=700 then 629
    when d.rd_name_code=701 then 611
    when d.rd_name_code=702 then 612
    when d.rd_name_code=703 then 628
    when d.rd_name_code=706 then 70899
    when d.rd_name_code=707 then 70899
    when d.rd_name_code=711 then 629
    else null 
end as rd_name_code
,case 
    when d.unit_code=45 then d.rd_value*0.001
    else d.rd_value
end as rd_value
,case 
    when unit_code=45 then 74
    when unit_code=6  then 6
    when unit_code=3  then 3
    else null
end as unit_code
,d.rd_name_ouom
,d.rd_value_ouom
,d.rd_unit_ouom
,d.sys_record_id
,cast(null as integer) as ypdt_sys_record_id
from 
yorkdb_20250425.dbo.d_interval_temporal_2 as d
inner join 
(
select
dia.int_id
,cast(dia.int_name_alias as int) as york_int_id
from 
oak_20160831_master.dbo.d_interval_alias as dia
where dia.int_alias_type_code=1
) as t
on d.int_id=t.york_int_id
where 
d.rd_name_code in (163,369,699,700,701,702,703,706,707)

-- D_INTERVAL_TEMPORAL_EXT

create view v_tr_ditext as
select
t.int_id as ypdt_int_id
,t.york_int_id
,d.rd_date
,case 
    when d.rd_name_code=707 then 67
    when d.rd_name_code=711 then 85
    else null 
end as rd_type_code
,case
    when d.rd_name_code=163 then 71037 
    when d.rd_name_code=369 then 70871
    when d.rd_name_code=699 then 447
    when d.rd_name_code=700 then 629
    when d.rd_name_code=701 then 611
    when d.rd_name_code=702 then 612
    when d.rd_name_code=703 then 628
    when d.rd_name_code=706 then 70899
    when d.rd_name_code=707 then 70899
    when d.rd_name_code=711 then 629
    else null 
end as rd_name_code
,case 
    when d.unit_code=45 then d.rd_value*0.001
    else d.rd_value
end as rd_value
,case 
    when unit_code=45 then 74
    when unit_code=6  then 6
    when unit_code=3  then 3
    else null
end as unit_code
,d.rd_name_ouom
,d.rd_value_ouom
,d.rd_unit_ouom
,d.sys_record_id
,cast(null as integer) as ypdt_sys_record_id
from 
yorkdb_20250425.dbo.d_interval_temporal_ext as d
inner join 
(
select
dia.int_id
,cast(dia.int_name_alias as int) as york_int_id
from 
oak_20160831_master.dbo.d_interval_alias as dia
where dia.int_alias_type_code=1
) as t
on d.int_id=t.york_int_id
where 
d.rd_name_code in (163,369,699,700,701,702,703,706,707)

-- D_INTERVAL_TEMPORAL_YORK

create view v_tr_dityork as
select
t.int_id as ypdt_int_id
,t.york_int_id
,d.rd_date
,case 
    when d.rd_name_code=707 then 67
    when d.rd_name_code=711 then 85
    else null 
end as rd_type_code
,case
    when d.rd_name_code=163 then 71037 
    when d.rd_name_code=369 then 70871
    when d.rd_name_code=699 then 447
    when d.rd_name_code=700 then 629
    when d.rd_name_code=701 then 611
    when d.rd_name_code=702 then 612
    when d.rd_name_code=703 then 628
    when d.rd_name_code=706 then 70899
    when d.rd_name_code=707 then 70899
    when d.rd_name_code=711 then 629
    else null 
end as rd_name_code
,case 
    when d.unit_code=45 then d.rd_value*0.001
    else d.rd_value
end as rd_value
,case 
    when unit_code=45 then 74
    when unit_code=6  then 6
    when unit_code=3  then 3
    else null
end as unit_code
,d.rd_name_ouom
,d.rd_value_ouom
,d.rd_unit_ouom
,d.sys_record_id
,cast(null as integer) as ypdt_sys_record_id
from 
yorkdb_20250425.dbo.d_interval_temporal_york as d
inner join 
(
select
dia.int_id
,cast(dia.int_name_alias as int) as york_int_id
from 
oak_20160831_master.dbo.d_interval_alias as dia
where dia.int_alias_type_code=1
) as t
on d.int_id=t.york_int_id
where 
d.rd_name_code in (163,369,699,700,701,702,703,706,707)

-- D_INTVL_TEMP2

create view v_tr_ditvl2 as
select
t.int_id as ypdt_int_id
,t.york_int_id
,d.rd_date
,case 
    when d.rd_name_code=707 then 67
    when d.rd_name_code=711 then 85
    else null 
end as rd_type_code
,case
    when d.rd_name_code=163 then 71037 
    when d.rd_name_code=369 then 70871
    when d.rd_name_code=699 then 447
    when d.rd_name_code=700 then 629
    when d.rd_name_code=701 then 611
    when d.rd_name_code=702 then 612
    when d.rd_name_code=703 then 628
    when d.rd_name_code=706 then 70899
    when d.rd_name_code=707 then 70899
    when d.rd_name_code=711 then 629
    else null 
end as rd_name_code
,case 
    when d.unit_code=45 then d.rd_value*0.001
    else d.rd_value
end as rd_value
,case 
    when unit_code=45 then 74
    when unit_code=6  then 6
    when unit_code=3  then 3
    else null
end as unit_code
,d.rd_name_ouom
,d.rd_value_ouom
,d.rd_unit_ouom
,d.sys_record_id
,cast(null as integer) as ypdt_sys_record_id
from 
yorkdb_20250425.dbo.d_intvl_temp2 as d
inner join 
(
select
dia.int_id
,cast(dia.int_name_alias as int) as york_int_id
from 
oak_20160831_master.dbo.d_interval_alias as dia
where dia.int_alias_type_code=1
) as t
on d.int_id=t.york_int_id
where 
d.rd_name_code in (163,369,699,700,701,702,703,706,707)

-- D_INTERVAL_TEMPORAL_2 - Extract

-- Note that this creates the export DIT2 table 

select
v.ypdt_int_id
,v.york_int_id
,v.sys_record_id
,v.ypdt_sys_record_id as ormgp_add_sys_record_id
,d.sys_record_id as ormgp_cur_sys_record_id
,v.rd_date
,v.rd_type_code
,v.rd_name_code
,v.rd_value
,d.rd_value as ormgp_cur_rd_value
,v.unit_code
,v.rd_name_ouom
,v.rd_value_ouom
,v.rd_unit_ouom
,cast( null as int ) as rkey
--,row_number() over (order by v.sys_record_id) as rkey
into yorkdb_20250425.dbo.dit2
from 
yorkdb_20250425.dbo.v_tr_dit2 as v
left outer join oak_20160831_master.dbo.d_interval_temporal_2 as d
on v.ypdt_int_id=d.int_id and v.rd_date=d.rd_date and v.rd_name_code=d.rd_name_code
where 
v.rd_value is not null
and ( d.sys_record_id is null or (d.sys_record_id is not null and not( v.rd_value between (d.rd_value-0.001) and (d.rd_value+0.001) ) ) )

-- get the number of records

-- v20230717 15321950 records
-- v20240909 12604855 records
-- v20250425 11147680 records

select count(*) as rcount from yorkdb_20250425.dbo.dit2

-- get the current count

-- v20210503 13567485 max rkey
-- v20231017 15321950 max rkey
-- v20240909 12604855 max rkey
-- v20250425 no rkey is being generated (to see if the 'order by' is slowing the query)

select
max(rkey) 
from 
yorkdb_20250425.dbo.dit2

-- D_INTERVAL_TEMPORAL_EXT - Extract

-- Note that this adds to the export DIT2 table; update
-- the rkey value (i.e. addition)

insert into yorkdb_20250425.dbo.dit2
(
ypdt_int_id
,york_int_id
,sys_record_id
,ormgp_add_sys_record_id
,ormgp_cur_sys_record_id
,rd_date
,rd_type_code
,rd_name_code
,rd_value
,ormgp_cur_rd_value
,unit_code
,rd_name_ouom
,rd_value_ouom
,rd_unit_ouom
,rkey
)
select
v.ypdt_int_id
,v.york_int_id
,v.sys_record_id
,v.ypdt_sys_record_id as ormgp_add_sys_record_id
,d.sys_record_id as ormgp_cur_sys_record_id
,v.rd_date
,v.rd_type_code
,v.rd_name_code
,v.rd_value
,d.rd_value as ormgp_cur_rd_value
,v.unit_code
,v.rd_name_ouom
,v.rd_value_ouom
,v.rd_unit_ouom
,cast( null as int ) as rkey
--,( row_number() over (order by v.sys_record_id) ) + 12604855 as rkey
from 
yorkdb_20250425.dbo.v_tr_ditext as v
left outer join oak_20160831_master.dbo.d_interval_temporal_2 as d
on v.ypdt_int_id=d.int_id and v.rd_date=d.rd_date and v.rd_name_code=d.rd_name_code 
where 
v.rd_value is not null
and ( d.sys_record_id is null or (d.sys_record_id is not null and not( v.rd_value between (d.rd_value-0.001) and (d.rd_value+0.001) ) ) )

-- v20210503 13586981 max rkey
-- v20231017 15329011 max rkey
-- v20240909 12614921 max rkey
-- v20250425 11148439 records (not using max())

select count(*) as rcount from yorkdb_20250425.dbo.dit2

select
max(rkey) 
from 
yorkdb_20250425.dbo.dit2

-- D_INTERVAL_TEMPORAL_YORK - Extract

-- Note that this adds to the DIT2 export table; update
-- the rkey value (i.e. addition)

insert into yorkdb_20250425.dbo.dit2
(
ypdt_int_id
,york_int_id
,sys_record_id
,ormgp_add_sys_record_id
,ormgp_cur_sys_record_id
,rd_date
,rd_type_code
,rd_name_code
,rd_value
,ormgp_cur_rd_value
,unit_code
,rd_name_ouom
,rd_value_ouom
,rd_unit_ouom
,rkey
)
select
v.ypdt_int_id
,v.york_int_id
,v.sys_record_id
,v.ypdt_sys_record_id as ormgp_add_sys_record_id
,d.sys_record_id as ormgp_cur_sys_record_id
,v.rd_date
,v.rd_type_code
,v.rd_name_code
,v.rd_value
,d.rd_value as ormgp_cur_rd_value
,v.unit_code
,v.rd_name_ouom
,v.rd_value_ouom
,v.rd_unit_ouom
,cast( null as int ) as rkey
--,( row_number() over (order by v.sys_record_id) ) + 12614921 as rkey
from 
yorkdb_20250425.dbo.v_tr_dityork as v
left outer join oak_20160831_master.dbo.d_interval_temporal_2 as d
on v.ypdt_int_id=d.int_id and v.rd_date=d.rd_date and v.rd_name_code=d.rd_name_code 
where 
v.rd_value is not null
and ( d.sys_record_id is null or (d.sys_record_id is not null and not( v.rd_value between (d.rd_value-0.001) and (d.rd_value+0.001) ) ) )

-- v20210503 14568344 max rkey
-- v20231017 16165079 max rkey
-- v20240909 13603925 max rkey
-- v20250425 12205771 records (not using max())

select count(*) as rcount from yorkdb_20250425.dbo.dit2

select
max(rkey) 
from 
yorkdb_20250425.dbo.dit2

-- D_INTVL_TEMP2 - Extract

-- Note that this adds to the DIT2 export table; update
-- the rkey value (i.e. addition)

insert into yorkdb_20250425.dbo.dit2
(
ypdt_int_id
,york_int_id
,sys_record_id
,ormgp_add_sys_record_id
,ormgp_cur_sys_record_id
,rd_date
,rd_type_code
,rd_name_code
,rd_value
,ormgp_cur_rd_value
,unit_code
,rd_name_ouom
,rd_value_ouom
,rd_unit_ouom
,rkey
)
select
v.ypdt_int_id
,v.york_int_id
,v.sys_record_id
,v.ypdt_sys_record_id as ormgp_add_sys_record_id
,d.sys_record_id as ormgp_cur_sys_record_id
,v.rd_date
,v.rd_type_code
,v.rd_name_code
,v.rd_value
,d.rd_value as ormgp_cur_rd_value
,v.unit_code
,v.rd_name_ouom
,v.rd_value_ouom
,v.rd_unit_ouom
,cast( null as int ) as rkey
--,( row_number() over (order by v.sys_record_id) ) + 13603925 as rkey
from 
yorkdb_20250425.dbo.v_tr_ditvl2 as v
left outer join oak_20160831_master.dbo.d_interval_temporal_2 as d
on v.ypdt_int_id=d.int_id and v.rd_date=d.rd_date and v.rd_name_code=d.rd_name_code 
where 
v.rd_value is not null
and ( d.sys_record_id is null or (d.sys_record_id is not null and not( v.rd_value between (d.rd_value-0.001) and (d.rd_value+0.001) ) ) )

-- v20210503 14568355 rkey max
-- v20231017 16165090 rkey max
-- v20240909 13603936 rkey max
-- v20250425 12205782 records (not using max())

select count(*) as rcount from yorkdb_20250425.dbo.dit2

select
max(rkey) 
from 
yorkdb_20250425.dbo.dit2

-- v20210503 14568355 rows total
-- v20231017 16165090 records total
-- v20240909 13603936 records total
-- v20250425 12205782 records 

select 
count(*) 
from 
yorkdb_20250425.dbo.dit2


-- v20210503 1861164 rows updated
-- v20231017 1667806 records to be updated
-- v20240909 2146504 records to be updated
-- v20250425 5287364 records to be updated

select 
count(*) 
from 
yorkdb_20250425.dbo.dit2
where 
ormgp_cur_sys_record_id is not null


-- v20210503 12707191 rows new
-- v20231017 14497284 records new
-- v20240909 11457432 records new
-- v20250425 6918418 records new

select 
count(*) 
from 
yorkdb_20250425.dbo.dit2
where 
ormgp_cur_sys_record_id is null



-- Make sure to add a DATA_ID for each of the updated and new data

select * from oak_20160831_master.dbo.d_data_source where data_id>= 240003500

-- v20240909
-- v20250425

insert into oak_20160831_master.dbo.d_data_source
( data_id,data_type,data_description,data_filename, data_added_date )
values 
( 240003513,'Water Levels and Other','Updated York Data - Various Temporal 2 (new); York DB 20250425','SiteFX_Full_backup_20250425.bak', '2025-05-08' )

insert into oak_20160831_master.dbo.d_data_source
( data_id,data_type,data_description,data_filename, data_added_date )
values 
( 240003514,'Water Levels and Other','Updated York Data - Various Temporal 2 (replacement); York DB 20250425','SiteFX_Full_backup_20250425.bak', '2025-05-08' )

select * from yorkdb_20250425_subset.dbo.dit2

-- Those records with a non-null ormgp_cur_sys_record_id will use an update
-- query; note the DATA_ID and the removal of the _ouom field values

update oak_20160831_master.dbo.d_interval_temporal_2
set
data_id= 240003514
,rd_value= d.rd_value
,rd_value_ouom=null
,rd_unit_ouom=null
from 
oak_20160831_master.dbo.d_interval_temporal_2 as d2
inner join yorkdb_20250425_subset.dbo.dit2 as d
on d2.sys_record_id=d.ormgp_cur_sys_record_id


-- populate the ormgp_add_sys_record_id field; note that if a large number of records
-- are to be added, this will need to be done in stages (say 2,000,000 at-a-time)

--select
--*
--from 
--temphold.dbo.dit2
--where
--ormgp_cur_sys_record_id is null
--
--select
--*
--from 
--temphold.dbo.dit2
--where
--ormgp_add_sys_record_id is null
--
---- v20240909 
--
--select
--max(rkey) as rkey_max
--,count(*) as rcount
--from 
--temphold.dbo.dit2
--where
--ormgp_add_sys_record_id is not null

select
min(rkey) as rkey_min
,max(rkey) as rkey_max
,count(*) as total_records
from 
yorkdb_20250425_subset.dbo.dit2
where
ormgp_add_sys_record_id is null
and ormgp_cur_sys_record_id is null

select
max(rkey) as rkey_max
,count(*) as rcount
from 
yorkdb_20250425_subset.dbo.dit2
where
ormgp_add_sys_record_id is not null
and ormgp_cur_sys_record_id is null

--update temphold.dbo.dit2
--set
--ormgp_add_sys_record_id= null
--where
--ormgp_add_sys_record_id is not null

-- the following is run repeadedly, adding the previous max rkey to capture the next set to be imported

update yorkdb_20250425_subset.dbo.dit2
set
ormgp_add_sys_record_id= t2.sri
from 
yorkdb_20250425_subset.dbo.dit2 as d
inner join
(
select
t.sri
,row_number() over (order by t.sri) as rkey
from 
(
select
top 2000000
new_id as sri
from 
v_sys_random_id_bulk_001
where
new_id not in
( select sys_record_id from d_interval_temporal_2 )
) as t
) as t2
on d.rkey= ( t2.rkey + 10301301 )
where
d.ormgp_cur_sys_record_id is null
and d.ormgp_add_sys_record_id is null


-- Those records with a null ormgp_cur_sys_record_id will be inserted; note
-- the DATA_ID and the matching of the _ouom field values; update SYS_TEMP1 
-- for each run


insert into oak_20160831_master.dbo.d_interval_temporal_2
(
int_id,
sys_record_id,
rd_date,
rd_type_code,
rd_name_code,
rd_value,
unit_code,
rd_value_ouom,
rd_name_ouom,
rd_unit_ouom,
data_id,
sys_temp1,
sys_temp2
)
SELECT
ypdt_int_id as int_id,
ormgp_add_sys_record_id as sys_record_id,
d.rd_date,
d.rd_type_code,
d.rd_name_code,
d.rd_value,
d.unit_code,
d.rd_value as rd_value_ouom,
rrnc.rd_name_description as rd_name_ouom,
ruc.unit_description as rd_unit_ouom,
240003513 as data_id,
'20250508g' as sys_temp1,
20250508 as sys_temp2
FROM 
yorkdb_20250425_subset.dbo.dit2 as d
inner join oak_20160831_master.dbo.r_rd_name_code as rrnc
on d.rd_name_code=rrnc.rd_name_code
left outer join oak_20160831_master.dbo.r_unit_code as ruc
on d.unit_code=ruc.unit_code
where 
ormgp_cur_sys_record_id is null
and ormgp_add_sys_record_id is not null

-- use -9999 as a tag to indicate the data has been loaded into the master db;
-- make sure it doesn't exist before doing so

-- set ormgp_cur_sys_record_id to -9999 for those records that have been inserted

update yorkdb_20250425_subset.dbo.dit2
set
ormgp_cur_sys_record_id= -9999
where
ormgp_add_sys_record_id is not null
and ormgp_cur_sys_record_id is null

select
*
from 
yorkdb_20250425_subset.dbo.dit2
where
ormgp_cur_sys_record_id= -9999

--***** Look at the records that already exist in the master db but have been updated in
--***** the latest version of the york db


-- there shouldn't be any records with a null current value (original nulls have been assigned -9999)

select * from temphold.dbo.dit2 where ormgp_cur_sys_record_id is null

-- v20231018 1667806

select count(*) as rcount from temphold.dbo.dit2 where ormgp_cur_sys_record_id <> -9999

-- a few checks

select 
t2.*
from 
(
select
t.rd_value - t.ormgp_cur_rd_value as diff
,t.*
--,d.*
from 
temphold.dbo.dit2 as t
inner join oak_20160831_master.dbo.d_interval_temporal_2 as d
on t.ormgp_cur_sys_record_id=d.sys_record_id
where
t.ormgp_cur_sys_record_id is not null
and t.ormgp_cur_sys_record_id <> -9999
and t.rd_name_code<>70871
and t.rd_name_code<>447
and t.rd_name_code<>71037
) as t2
order by
diff desc


-- if the result of the checks do not seem to be problematic, substitute the new values
-- for the old values


select
t.rd_value
,t.rd_name_ouom
,t.unit_code
,t.rd_value_ouom
,t.rd_unit_ouom
,240003508 as data_id
from 
temphold.dbo.dit2 as t
inner join oak_20160831_master.dbo.d_interval_temporal_2 as d
on t.ormgp_cur_sys_record_id=d.sys_record_id
where
t.ormgp_cur_sys_record_id is not null
and t.ormgp_cur_sys_record_id <> -9999


update d_interval_temporal_2
set
rd_value= t.rd_value
,unit_code= t.unit_code
,rd_name_ouom= t.rd_name_ouom
,rd_value_ouom= t.rd_value_ouom
,rd_unit_ouom= t.rd_unit_ouom
,data_id= 240003508
,sys_temp1= '20231017u'
,sys_temp2= 20231017 
from 
temphold.dbo.dit2 as t
inner join oak_20160831_master.dbo.d_interval_temporal_2 as d
on t.ormgp_cur_sys_record_id=d.sys_record_id
where
t.ormgp_cur_sys_record_id is not null
and t.ormgp_cur_sys_record_id <> -9999


drop table dit1a

drop table dit1b

drop table dit2




