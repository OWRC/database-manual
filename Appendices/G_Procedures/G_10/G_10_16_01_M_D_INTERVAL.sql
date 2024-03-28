
--***** G_10_16_01

--***** We can now assemble the actual screen details to be incorporated
--***** as M_D_INTERVAL

-- the original name (i.e. WELL_ID) will be the INT_NAME while the
-- BORE_HOLE_ID will be the INT_NAME_ALT2

--***** UPDATE DATA_ID

--select
--*
--from 
--d_data_source
--where
--data_id= 523

--insert into d_data_source
--( data_id, data_type, data_description, data_comment )
--values 
--( 525, 'Well or Borehole', 'MOE WWR Database - 20230324', 'Refer to Appendix G.10 in the database manual for import methodology' )

-- 519 2017.09.05
-- 520 2018.05.30
-- 521 v20190509 
-- 522 v20200721 
-- 523 v20210119
-- 524 v20220328
-- 525 v20230324
-- 526 v20240326

select 
dim.INT_ID
,ycb.BORE_HOLE_ID as LOC_ID
,dloc.LOC_ORIGINAL_NAME as INT_NAME
,ycb.BORE_HOLE_ID as INT_NAME_ALT2
,dim.tmp_INT_TYPE_CODE as INT_TYPE_CODE
,case 
when dloc.LOC_START_DATE is not null then dloc.LOC_START_DATE 
else cast('1867-07-01' as datetime)
end as INT_START_DATE
,cast(1 as int) as INT_CONFIDENTIALITY_CODE
,cast(1 as int) as INT_ACTIVE
,cast(526 as int) as [DATA_ID]
from 
(
select
dim.INT_ID
,dim.INT_ID as LOC_ID
,dim.tmp_INT_TYPE_CODE
from 
MOE_20240326.dbo.M_D_INTERVAL_MONITOR as dim
group by
dim.INT_ID,dim.tmp_INT_TYPE_CODE
) as dim
inner join MOE_20240326.dbo.YC_20240326_BH_ID as ycb
on dim.LOC_ID=ycb.BORE_HOLE_ID
inner join MOE_20240326.dbo.M_D_LOCATION as dloc
on ycb.BORE_HOLE_ID=dloc.LOC_ID

-- 2017.09.05 17185 rows
-- 2018.05.30 15578 rows
-- v20190509 11851 rows 
-- v20200721 11760 rows
-- v20210119 24619 rows
-- v20220328 15235 rows
-- v20230324 18826 rows
-- v20240326 23131 rows

select 
dim.INT_ID
,ycb.BORE_HOLE_ID as LOC_ID
,dloc.LOC_ORIGINAL_NAME as INT_NAME
,ycb.BORE_HOLE_ID as INT_NAME_ALT2
,dim.tmp_INT_TYPE_CODE as INT_TYPE_CODE
,case 
when dloc.LOC_START_DATE is not null then dloc.LOC_START_DATE 
else cast('1867-07-01' as datetime)
end as INT_START_DATE
,cast(1 as int) as INT_CONFIDENTIALITY_CODE
,cast(1 as int) as INT_ACTIVE
,cast(526 as int) as [DATA_ID]
into MOE_20240326.dbo.M_D_INTERVAL
from 
(
select
dim.INT_ID
,dim.INT_ID as LOC_ID
,dim.tmp_INT_TYPE_CODE
from 
MOE_20240326.dbo.M_D_INTERVAL_MONITOR as dim
group by
dim.INT_ID,dim.tmp_INT_TYPE_CODE
) as dim
inner join MOE_20240326.dbo.YC_20240326_BH_ID as ycb
on dim.LOC_ID=ycb.BORE_HOLE_ID
inner join MOE_20240326.dbo.M_D_LOCATION as dloc
on ycb.BORE_HOLE_ID=dloc.LOC_ID

-- how many locations and intervals

-- 2017.09.05 17185 rows
-- 2018.05.30 15578 rows
-- v20190509 11851 rows 
-- v20200721 11760
-- v20210119 24619 rows
-- v20220328 15235 rows
-- v20230324 18826 rows
-- v20240326 23131 rows

select
count(*) 
from
MOE_20240326.dbo.m_d_location

-- check and make sure that there aren't any duplicate int_ids

-- 2017.09.05 0 rows
-- 2018.05.30 0 rows
-- v20190509 0 rows
-- v20200721 0 rows
-- v20210119 0 rows
-- v20220328 0 rows
-- v20230324 0 rows
-- v20240326 0 rows

select
*
from 
MOE_20240326.dbo.m_d_interval as dim
where
dim.int_id
in
(
select
t1.int_id
from 
(
select
dim.int_id
,COUNT(*) as rcount
from 
MOE_20240326.dbo.m_d_interval as dim
group by 
dim.int_id
) as t1
where 
t1.rcount>1
)

-- check and make sure we're not missing any INT_IDs (i.e. LOC_IDs/BORE_HOLE_IDs)

-- 2017.09.05 0 rows
-- 2018.05.30 0 rows
-- v20190509 0 rows 
-- v20200721 0 rows
-- v20210119 0 rows
-- v20220328 0 rows
-- v20230324 0 rows
-- v20240326 0 rows

select
b.*
from 
MOE_20240326.dbo.YC_20240326_BH_ID as b
where 
BORE_HOLE_ID 
not in
(
select
INT_ID
from 
MOE_20240326.dbo.M_D_INTERVAL_MONITOR
group by
INT_ID
)

-- get the information for any INT_IDs returned

--***** 20160531

SELECT 
[TMP_LOC_ID]
,[tmp_INT_TYPE_CODE]
,[MON_SCREEN_SLOT]
,[MON_SCREEN_MATERIAL]
,[MON_DIAMETER_OUOM]
,[MON_DIAMETER_UNIT_OUOM]
,[MON_TOP_OUOM]
,[MON_BOT_OUOM]
,[MON_UNIT_OUOM]
,[MON_COMMENT]
FROM [MOE_20160531].[dbo].[YC_20160531_DINTMON]
where 
tmp_loc_id=1005161993

-- what is the maximum SYS_RECORD_ID

select
max(SYS_RECORD_ID) as max_SRI
from 
MOE_20160531.dbo.M_D_INTERVAL_MONITOR 

-- 28575

-- introduce these values to M_D_INTERVAL_MONITOR

--insert into MOE_20160531.dbo.M_D_INTERVAL_MONITOR 
--(
--[INT_ID]
--,[tmp_INT_TYPE_CODE]
--,[MON_SCREEN_SLOT]
--,[MON_SCREEN_MATERIAL]
--,[MON_DIAMETER_OUOM]
--,[MON_DIAMETER_UNIT_OUOM]
--,[MON_TOP_OUOM]
--,[MON_BOT_OUOM]
--,[MON_UNIT_OUOM]
--,[SYS_RECORD_ID]
--)
--values
--(1005161993,18,25,1,5.5,'inch',68,71.6,'ft',28576)

--insert into MOE_20160531.dbo.M_D_INTERVAL_MONITOR 
--(
--[INT_ID]
--,[tmp_INT_TYPE_CODE]
--,[MON_SCREEN_SLOT]
--,[MON_SCREEN_MATERIAL]
--,[MON_DIAMETER_OUOM]
--,[MON_DIAMETER_UNIT_OUOM]
--,[MON_TOP_OUOM]
--,[MON_BOT_OUOM]
--,[MON_UNIT_OUOM]
--,[SYS_RECORD_ID]
--)
--values
--(1005161993,18,30,1,5.5,'inch',71.6,75,'ft',28577)

--insert into MOE_20160531.dbo.M_D_INTERVAL_MONITOR 
--(
--[INT_ID]
--,[tmp_INT_TYPE_CODE]
--,[MON_SCREEN_SLOT]
--,[MON_SCREEN_MATERIAL]
--,[MON_DIAMETER_OUOM]
--,[MON_DIAMETER_UNIT_OUOM]
--,[MON_TOP_OUOM]
--,[MON_BOT_OUOM]
--,[MON_UNIT_OUOM]
--,[SYS_RECORD_ID]
--)
--values
--(1005161993,18,14,1,5.5,'inch',75,78,'ft',28578)





