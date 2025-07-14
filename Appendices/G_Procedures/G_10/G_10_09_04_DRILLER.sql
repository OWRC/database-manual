
--***** G_10_09_04

--***** Add any missing MOE driller codes (i.e. CONTRACTOR) into the R_BH_DRILLER_CODE table

-- as of v20220328 we've introduced a CONTRACTOR_NUM field to TblWWR so as to avoid collation
-- issues; this should be incorporated into the methodology at an earlier point; note also that
-- the added field MOE_WELL_ID is being used

-- add the CONTRACTOR_NUM field and copy/convert CONTRACTOR; add MOE_WELL_ID field and copy/convert WELL_ID; 
-- refer to the end of this script

select
t.BH_DRILLER_DESCRIPTION
,t.BH_DRILLER_DESCRIPTION_LONG
,t.BH_DRILLER_ALT_CODE
,528 as DATA_ID
from 
(
select
cast('MOE Driller No. ' + cast(moewwr.CONTRACTOR as varchar(255)) as varchar(255)) as BH_DRILLER_DESCRIPTION
,cast('MOE Driller No. ' + cast(moewwr.CONTRACTOR as varchar(255)) as varchar(255)) as BH_DRILLER_DESCRIPTION_LONG
,cast(moewwr.CONTRACTOR as varchar(255)) as BH_DRILLER_ALT_CODE
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y
left outer join MOE_20250711.dbo.TblWWR as moewwr
on y.MOE_WELL_ID=moewwr.MOE_WELL_ID
left outer join OAK_20160831_MASTER.dbo.R_BH_DRILLER_CODE as rbdc
--on moewwr.CONTRACTOR collate database_default=rbdc.BH_DRILLER_ALT_CODE collate database_default 
on moewwr.CONTRACTOR_NUM = cast( rbdc.BH_DRILLER_ALT_CODE as int )
where 
rbdc.BH_DRILLER_CODE is null
) as t
group by
t.BH_DRILLER_DESCRIPTION,t.BH_DRILLER_DESCRIPTION_LONG,t.BH_DRILLER_ALT_CODE


-- v20170905 9 rows inserted
-- v20180530 15 rows
-- v20190509 11 rows
-- v20200721 22 rows
-- v20210119 29 rows
-- v20230324 
-- v20240326 37 rows
-- v20250711 28 rows

-- update DATA_ID

insert into [OAK_20160831_MASTER].dbo.R_BH_DRILLER_CODE
( BH_DRILLER_DESCRIPTION,BH_DRILLER_DESCRIPTION_LONG,BH_DRILLER_ALT_CODE,DATA_ID )
select
t.BH_DRILLER_DESCRIPTION
,t.BH_DRILLER_DESCRIPTION_LONG
,t.BH_DRILLER_ALT_CODE
,528 as DATA_ID
from 
(
select
cast('MOE Driller No. ' + cast(moewwr.CONTRACTOR as varchar(255)) as varchar(255)) as BH_DRILLER_DESCRIPTION
,cast('MOE Driller No. ' + cast(moewwr.CONTRACTOR as varchar(255)) as varchar(255)) as BH_DRILLER_DESCRIPTION_LONG
,cast(moewwr.CONTRACTOR as varchar(255)) as BH_DRILLER_ALT_CODE
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y
left outer join MOE_20250711.dbo.TblWWR as moewwr
on y.MOE_WELL_ID=moewwr.MOE_WELL_ID
left outer join OAK_20160831_MASTER.dbo.R_BH_DRILLER_CODE as rbdc
--on moewwr.CONTRACTOR collate database_default=rbdc.BH_DRILLER_ALT_CODE collate database_default 
on moewwr.CONTRACTOR_NUM = cast( rbdc.BH_DRILLER_ALT_CODE as int )
where 
rbdc.BH_DRILLER_CODE is null
) as t
where
t.bh_driller_description is not null
group by
t.BH_DRILLER_DESCRIPTION,t.BH_DRILLER_DESCRIPTION_LONG,t.BH_DRILLER_ALT_CODE


--***** v20170905, v20180530, v20220328
--***** as we're working against a weekly db (not the master, a backup), pull across and hold any drillers
--***** we've added in a temporary table (to be added to the master db table)

--***** v20240326 added data_id check instead of using sys_time_stamp

select
BH_DRILLER_CODE
,BH_DRILLER_DESCRIPTION
,BH_DRILLER_DESCRIPTION_LONG
,BH_DRILLER_ALT_CODE
,DATA_ID
,SYS_TIME_STAMP
,SYS_USER_STAMP
into MOE_20250711.dbo.M_R_BH_DRILLER_CODE
from
oak_20160831_master.dbo.r_bh_driller_code
where 
--sys_time_stamp>'2018-06-25'
--sys_time_stamp>'2019-05-15'
--sys_time_stamp>'2020-07-30'
--sys_time_stamp>'2021-01-19'
--sys_time_stamp>'2023-03-24'
data_id= 528
--order by
--sys_time_stamp desc


drop table MOE_20250711.dbo.M_R_BH_DRILLER_CODE



--***** 20250711

-- add the CONTRACTOR_NUM field and copy/convert CONTRACTOR; add MOE_WELL_ID field and copy/convert WELL_ID

select
*
from 
MOE_20250711.dbo.TblWWR

alter table TblWWR add CONTRACTOR_NUM int null

update MOE_20250711.dbo.TblWWR
set
contractor_num= cast( contractor as int ) 


select
*
from 
[OAK_20160831_MASTER].dbo.R_BH_DRILLER_CODE
order by
sys_time_stamp desc


delete from [OAK_20160831_MASTER].dbo.R_BH_DRILLER_CODE
where
sys_time_stamp> '2025-07-11'








