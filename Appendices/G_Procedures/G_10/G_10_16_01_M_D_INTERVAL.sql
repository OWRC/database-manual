
--***** G_10_16_01

--***** We can now assemble the actual screen details to be incorporated
--***** as M_D_INTERVAL

-- the original name (i.e. WELL_ID) will be the INT_NAME while the
-- BORE_HOLE_ID will be the INT_NAME_ALT2

--***** UPDATE DATA_ID

select
*
from 
oak_20160831_master.dbo.d_data_source
where
data_id= 529

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
-- 528 v20250711
-- 529 v20260813 

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
,cast(529 as int) as [DATA_ID]
from 
(
select
dim.INT_ID
,dim.INT_ID as LOC_ID
,dim.tmp_INT_TYPE_CODE
from 
MOE_20260813.dbo.M_D_INTERVAL_MONITOR as dim
group by
dim.INT_ID,dim.tmp_INT_TYPE_CODE
) as dim
inner join MOE_20260813.dbo.YC_20260813_BH_ID as ycb
on dim.LOC_ID=ycb.BORE_HOLE_ID
inner join MOE_20260813.dbo.M_D_LOCATION as dloc
on ycb.BORE_HOLE_ID=dloc.LOC_ID

-- 2017.09.05 17185 rows
-- 2018.05.30 15578 rows
-- v20190509 11851 rows 
-- v20200721 11760 rows
-- v20210119 24619 rows
-- v20220328 15235 rows
-- v20230324 18826 rows
-- v20240326 23131 rows
-- v20250711 129172 rows

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
,cast(529 as int) as [DATA_ID]
into MOE_20260813.dbo.M_D_INTERVAL
from 
(
select
dim.INT_ID
,dim.INT_ID as LOC_ID
,dim.tmp_INT_TYPE_CODE
from 
MOE_20260813.dbo.M_D_INTERVAL_MONITOR as dim
group by
dim.INT_ID,dim.tmp_INT_TYPE_CODE
) as dim
inner join MOE_20260813.dbo.YC_20260813_BH_ID as ycb
on dim.LOC_ID=ycb.BORE_HOLE_ID
inner join MOE_20260813.dbo.M_D_LOCATION as dloc
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
-- v20250711 18379 rows
-- v20260813 129172 rows (loc_id) versus 129172 rows (int_id); match

select
count(*) 
from
MOE_20260813.dbo.m_d_location

select
count(*) 
from
MOE_20260813.dbo.m_d_interval

-- check and make sure that there aren't any duplicate int_ids

-- 2017.09.05 0 rows
-- 2018.05.30 0 rows
-- v20190509 0 rows
-- v20200721 0 rows
-- v20210119 0 rows
-- v20220328 0 rows
-- v20230324 0 rows
-- v20240326 0 rows
-- v20250711 0 rows
-- v20260813 0 rows

select
*
from 
MOE_20260813.dbo.m_d_interval as dim
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
MOE_20260813.dbo.m_d_interval as dim
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
-- v20250711 0 rows
-- v20260813 0 rows

select
b.*
from 
MOE_20260813.dbo.YC_20260813_BH_ID as b
where 
BORE_HOLE_ID 
not in
(
select
INT_ID
from 
MOE_20260813.dbo.M_D_INTERVAL_MONITOR
group by
INT_ID
)







