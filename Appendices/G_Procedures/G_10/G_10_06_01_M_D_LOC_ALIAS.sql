
--***** G_10_06_01

--***** extract D_LOCATION_ALIAS equivalent; note that we're keeping WELL_ID in LOC_ORIGINAL_NAME
--***** for now for relationships

select * from MOE_20250711.dbo.M_D_LOCATION_ALIAS

-- Don't forget to add and populate MOE_WELL_ID in tblWWR (see end of script)

-- this is to track the BORE_HOLE_ID which is attached to the WELL_ID in LOC_ORIGINAL_NAME

select 
y.BORE_HOLE_ID as LOC_ID
,cast(y.BORE_HOLE_ID as varchar(255)) as LOC_NAME_ALIAS
,cast(3 as int) as [LOC_ALIAS_TYPE_CODE]
,cast(null as int) as SYS_RECORD_ID
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y

select 
y.BORE_HOLE_ID as LOC_ID
,cast(y.BORE_HOLE_ID as varchar(255)) as LOC_NAME_ALIAS
,cast(3 as int) as [LOC_ALIAS_TYPE_CODE]
,cast(null as int) as SYS_RECORD_ID
into MOE_20250711.dbo.M_D_LOCATION_ALIAS
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y

-- this is to track the WELL_ID; note that LOC_ID is the BORE_HOLE_ID (at the moment)

select
y.LOC_ID
,cast(y.LOC_ORIGINAL_NAME as varchar(255)) as LOC_NAME_ALIAS
,cast(4 as int) as [LOC_ALIAS_TYPE_CODE]
from 
MOE_20250711.dbo.M_D_LOCATION as y

insert into MOE_20250711.dbo.M_D_LOCATION_ALIAS
(LOC_ID,LOC_NAME_ALIAS,LOC_ALIAS_TYPE_CODE)
select
y.LOC_ID
,cast(y.LOC_ORIGINAL_NAME as varchar(255)) as LOC_NAME_ALIAS
,cast(4 as int) as [LOC_ALIAS_TYPE_CODE]
from 
MOE_20250711.dbo.M_D_LOCATION as y

-- this is to track the MOE Tag number which is attached to the WELL_ID; nulls are dropped

-- note that as of v20220328, we've added a MOE_WELL_ID integer field to avoid collation issues
-- (i.e. instead of using the character based WELL_ID field); this is currently accomplished by hand

select 
y.BORE_HOLE_ID as LOC_ID
,cast(m.TAG as varchar(255)) as LOC_NAME_ALIAS
,cast(1 as int) as [LOC_ALIAS_TYPE_CODE]
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y
inner join MOE_20250711.dbo.TblWWR as m
on y.MOE_WELL_ID=m.MOE_WELL_ID
where 
m.TAG is not null

insert into MOE_20250711.dbo.M_D_LOCATION_ALIAS
(LOC_ID,LOC_NAME_ALIAS,LOC_ALIAS_TYPE_CODE)
select 
y.BORE_HOLE_ID as LOC_ID
,cast(m.TAG as varchar(255)) as LOC_NAME_ALIAS
,cast(1 as int) as [LOC_ALIAS_TYPE_CODE]
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y
inner join MOE_20250711.dbo.TblWWR as m
on y.MOE_WELL_ID=m.MOE_WELL_ID
where 
m.TAG is not null

-- this is to track the MOE Audit Number which is attached to the WELL_ID

select 
y.BORE_HOLE_ID as LOC_ID
,cast(m.AUDIT_NO as varchar(255)) as LOC_NAME_ALIAS
,cast(2 as int) as [LOC_ALIAS_TYPE_CODE]
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y
inner join MOE_20250711.dbo.TblWWR as m
on y.MOE_WELL_ID=m.MOE_WELL_ID
where 
m.AUDIT_NO is not null

insert into MOE_20250711.dbo.M_D_LOCATION_ALIAS
(LOC_ID,LOC_NAME_ALIAS,LOC_ALIAS_TYPE_CODE)
select 
y.BORE_HOLE_ID as LOC_ID
,cast(m.AUDIT_NO as varchar(255)) as LOC_NAME_ALIAS
,cast(2 as int) as [LOC_ALIAS_TYPE_CODE]
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y
inner join MOE_20250711.dbo.TblWWR as m
on y.MOE_WELL_ID=m.MOE_WELL_ID
where 
m.AUDIT_NO is not null


-- v20170905
-- type 1 13917 rows
-- type 2 17062 rows
-- type 3 17185 rows
-- type 4 17185 rows
-- v20180530
-- type 1 11916 rows
-- type 2 14437 rows
-- type 3 15578 rows
-- type 4 15578 rows
-- v20190509
-- type 1 10069 rows
-- type 2 10069 rows
-- type 3 11851 rows
-- type 4 11851 rows
-- v20200721
-- type 1 10272 rows
-- type 2 11760 rows
-- type 3 11760 rows
-- type 4 11760 rows
-- v20210119
-- type 1 21163 rows
-- type 2 24610 rows
-- type 3 24619 rows
-- type 4 24619 rows
-- v20220328
-- type 1 13444 rows
-- type 2 15234 rows
-- type 3 15235 rows
-- type 4 15235 rows
-- v20230324
-- type 1 16947 rows
-- type 2 18819 rows
-- type 3 18826 rows
-- type 4 18826 rows
-- v20240326
-- type 1 21056 rows
-- type 2 23131 rows
-- type 3 23131 rows
-- type 4 23131 rows
-- v20250711
-- type 1 16590 rows
-- type 2 18375 rows
-- type 3 18379 rows
-- type 4 18379 rows

select
loc_alias_type_code
,count(*) as rcount
from 
MOE_20250711.dbo.M_D_LOCATION_ALIAS
group by
loc_alias_type_code
--where 
--LOC_ALIAS_TYPE_CODE= 1
--LOC_ALIAS_TYPE_CODE= 2
--LOC_ALIAS_TYPE_CODE= 3
--LOC_ALIAS_TYPE_CODE=  4

--delete from m_d_location_alias
--where loc_alias_type_code=4


--***** 20250711 if the MOE_WELL_ID field is not present in tblWWR and YC_20250711_BH_ID, add it

alter table TblWWR add MOE_WELL_ID int null

update MOE_20250711.dbo.TblWWR
set
MOE_WELL_ID= cast( WELL_ID as int )

alter table YC_20250711_BH_ID add MOE_WELL_ID int null

update MOE_20250711.dbo.YC_20250711_BH_ID
set
MOE_WELL_ID= cast( WELL_ID as int )




