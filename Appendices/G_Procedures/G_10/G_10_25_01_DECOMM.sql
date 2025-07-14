
--**** G_10_25_01

--***** this script examines the presence of the ABANDONMENT_REC field; a Y in this field
--***** indicates that the well is an abandonment record

--SELECT
--WELL_ID,
--AUDIT_NO,
--TAG,
--FINAL_STA,
--DATA_SRC,
--CONTRACTOR,
--DATE_RECEIVED,
--FORMVERSION,
--COUNTY,
--MUNIC_CODE,
--CONREG,
--CONN,
--LOT,
--STREET,
--CITY,
--SITE,
--OWNER,
--USE_2ND,
--USE_1ST,
--selected_flag,
--data_entry_status,
--ABANDONMENT_REC
--FROM moe_20250711."dbo"."tblWWR"
--where
--abandonment_rec is not null

-- note the use of the cast() to associate the well identifiers between the MOE
-- and master database

-- 2017.09.05 Y records 23377; null records 23377; either of these can be used (i.e. either not null or 'Y')
-- 2018.05.30 Y records 26345; null records 26345 
-- v20190509 Y records 28180; (not?) null records 28180
-- v20200721 Y records 30806; not null records 30806 [checking to see if anything but 'Y' is present]
-- v20210119 Y records 35377; not null records 35377 [check to see if anything but 'Y' is presnet]; okay
-- v20220328 Y records 37146; not null records 37146; match is okay
-- v20230324 Y records 42202; not null records 42204; match is off by one
-- v20240326 Y records 45084; not null records 45084; match is okay
-- v20250711 Y records 51299; not null records 51299; match is okay

select
count(*)
--v.*
--,d.loc_type_code
from 
oak_20160831_master.dbo.v_sys_moe_locations as v
inner join moe_20250711.dbo.tblwwr as m
on v.moe_well_id=cast(m.well_id as int)
inner join oak_20160831_master.dbo.d_location as d
on v.loc_id=d.loc_id
where
--abandonment_rec is not null
abandonment_rec = 'Y'

-- 2017.09.05 only 'Y' or NULL 
-- 2018.05.30 only 'Y' or NULL
-- v20190509 only Y or NULL
-- v20200721 only Y or NULL
-- v20210119 only Y or NULL present
-- v20220328 only Y or NULL present
-- v20230324 only Y or NULL present
-- v20240326 only Y or NULL present
-- v20250711 only Y or null present

select
distinct(abandonment_rec)
from 
moe_20250711.dbo.tblwwr


--***** Examine the supposed Abandonment/Decommissioned wells

-- note that previous to (and including) 20170905, this would have applied to all 
-- MOE wells that have been imported

-- 2017.09.05 23377 rows total
-- 2017.09.05  3193 rows specific to DATA_ID 519
-- 2017.09.05 23154 new decommissioned, the remainder already tagged

-- check all versus just the current DATA_ID

-- 2018.05.30 4868 decommissioned; 2550 rows specific to DATA_ID 520
-- v20190509 6581 decommissioned; 1374 rows specific to DATA_ID 521 
-- v20200721 2029 decommissioned specific to DATA_ID 522; 7757 total; 4604 with loc_status_code of 22 (this accounnts for 6633)
-- v20210119 4554 decommissioned specific to DATA_ID 523; 12324 total; 6628 with loc_status_code of 22  
-- v20220328 1653 decommissioned specific to DATA_ID 524;
-- v20230324 

-- get all the records

select
cast(well_id as int) as well_id
into MOE_20250711.dbo.YC_20250711_ABANDON_ALL
from 
MOE_20250711.dbo.tblWWR
where
abandonment_rec is not null

--drop table YC_20250711_ABANDON_ALL

-- v20200721 50574 rows
-- v20210119 53632 rows
-- v20220328 55451 rows
-- v20230324 63051 rows
-- v20240326 66884 rows
-- v20250711 75913 rows

select
count(*) 
from 
MOE_20250711.dbo.YC_20250711_ABANDON_ALL

-- v20210119 4554 tied to DATA_ID 523
-- v20220328 1653 tied to DATA_ID 524 
-- v20230324 3375 tied to DATA_ID 525
-- v20240326 2304 tied to DATA_ID 526
-- v20250711 3730 tied to DATA_ID 528

select
count(*)
--v.*
--,d.LOC_TYPE_CODE
from 
OAK_20160831_MASTER.dbo.D_LOCATION as d
inner join OAK_20160831_MASTER.dbo.V_SYS_MOE_LOCATIONS as v
on d.loc_id=v.loc_id
inner join MOE_20250711.dbo.YC_20250711_ABANDON_ALL as m
on v.moe_well_id=m.well_id
where 
d.LOC_TYPE_CODE=1
and d.DATA_ID=528
--and d.loc_status_code=22

-- update the LOC_TYPE_CODE; change the current value of '1' (Borehole or Well) to '27' (Decommissioned)

--***** 20240326 moved the following to the end (after loc_status_code) 

-- 2017.09.05 23154 records updated
-- 2018.05.30 0 records updated; refer to the check option, below
-- v20190509 1374 rows updated
-- v20200721 not processed; use loc_status_code instead
-- v20210119 not processed; use loc_status_code instead
-- v20230324 not processed; use loc_status_code instead
-- v20240326 processed; use both loc_status_code and deommissioned loc type

--select
--v.*
--from 
--OAK_20160831_MASTER.dbo.D_LOCATION as d
--inner join OAK_20160831_MASTER.dbo.V_SYS_MOE_LOCATIONS as v
--on d.loc_id=v.loc_id
--inner join MOE_20250711.dbo.YC_20250711_ABANDON_ALL as m
--on v.moe_well_id=m.well_id
--where 
--d.LOC_TYPE_CODE=1
--and d.DATA_ID=526

--update OAK_20160831_MASTER.dbo.D_LOCATION 
--set
--LOC_TYPE_CODE=27
--from 
--OAK_20160831_MASTER.dbo.D_LOCATION as d
--inner join OAK_20160831_MASTER.dbo.V_SYS_MOE_LOCATIONS as v
--on d.loc_id=v.loc_id
--inner join MOE_20250711.dbo.YC_20250711_ABANDON_ALL as m
--on v.moe_well_id=m.well_id
--where 
--d.LOC_TYPE_CODE=1
--and d.DATA_ID=526

-- as an alternative, we can keep these locations as loc_type_code '1' and tag them with a
-- loc_status_code of '22' (moe abandonment) allowing them to be viewed in section

-- this involves removing the current loc_status_code, make sure that this is captured in
-- the original moe db

--select
--d.loc_id
--,d.loc_type_code
--,d.loc_status_code
--,y.loc_status_code as moe_loc_status_code
--,m.final_sta
--,d.data_id
--from 
--OAK_20160831_MASTER.dbo.D_LOCATION as d
--inner join OAK_20160831_MASTER.dbo.V_SYS_MOE_LOCATIONS as v
--on d.loc_id=v.loc_id
--inner join MOE_20250711.dbo.tblWWR as m
--on v.MOE_WELL_ID=cast(m.WELL_ID as int)
--left outer join MOE_20250711.dbo.YC_20250711_FINAL_STATUS as y
--on m.final_sta=y.final_sta
--where 
--m.ABANDONMENT_REC is not null
--and d.LOC_TYPE_CODE=1

-- 2018.05.30 it is captured

--insert into r_loc_status_code
--(loc_status_description,loc_status_description_long)
--values
--('MOE Abandonment Record','YPDT Coding - Temporarily used to designate an MOE record with a (possibly new) ABANDONMENT_REC tag; these are to be evaluated for marking as decommissioned instead')

-- change the loc_status_code to 22 for these locations

-- for v20190509, changed LOC_TYPE_CODE to 27 and changed the status code as well

--***** 20230324 change loc_status_code update from 22 (which has been removed) to 7

-- 2018.05.30 4868 records
-- v20190509 1374 records
-- v20200721 2029 records
-- v20210119 4554 records
-- v20220328 1653 records
-- v20230324 3375 records
-- v20240326 2304 rows
-- v20250711 3730 rows

select
count(*)
from 
OAK_20160831_MASTER.dbo.D_LOCATION as d
inner join OAK_20160831_MASTER.dbo.V_SYS_MOE_LOCATIONS as v
on d.loc_id=v.loc_id
inner join MOE_20250711.dbo.YC_20250711_ABANDON_ALL as m
on v.moe_well_id=m.well_id
where 
d.DATA_ID=528


update OAK_20160831_MASTER.dbo.D_LOCATION
set
loc_status_code= 7
from 
OAK_20160831_MASTER.dbo.D_LOCATION as d
inner join OAK_20160831_MASTER.dbo.V_SYS_MOE_LOCATIONS as v
on d.loc_id=v.loc_id
inner join MOE_20250711.dbo.YC_20250711_ABANDON_ALL as m
on v.moe_well_id=m.well_id
where 
d.DATA_ID=528


-- update the loc_type_code (moved here from above) 

-- 2017.09.05 23154 records updated
-- 2018.05.30 0 records updated; refer to the check option, below
-- v20190509 1374 rows updated
-- v20200721 not processed; use loc_status_code instead
-- v20210119 not processed; use loc_status_code instead
-- v20230324 not processed; use loc_status_code instead
-- v20240326 processed; use both loc_status_code and deommissioned loc type

select
d.*
from 
OAK_20160831_MASTER.dbo.D_LOCATION as d
where 
d.LOC_TYPE_CODE=1
and d.loc_status_code= 7
and d.DATA_ID=528

update OAK_20160831_MASTER.dbo.D_LOCATION 
set
LOC_TYPE_CODE=27
from 
OAK_20160831_MASTER.dbo.D_LOCATION as d
where 
d.LOC_TYPE_CODE=1
and d.loc_status_code= 7
and d.DATA_ID=528





