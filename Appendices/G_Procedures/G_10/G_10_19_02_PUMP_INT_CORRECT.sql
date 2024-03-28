
--***** G_10_19_02

--***** determine which intervals should be assigned INT_IDs together;
--***** refer to notes below for deatils

-- the following gives us a pump_test_id for which there should be a single
-- value for each valid interval; if there is multiple int_id_old associated
-- with a single pump_test_id value then we're going to replace it with a
-- single int_id_new OR we're going to blow off int_id_old depending upon
-- which table we're accessing (those to be removed will be duplicate values)

-- previous statements seem to have caught when multiple, succeeding screens
-- were used when constructing the borehole; this statement based upon
-- pump_test_id determines how the intervals should be reassigned;
-- we'll create a YC table for lookup purposes

-- 2017.09.05 0 rows returned
-- 2018.05.30 0 rows returned
-- v20190509 0 rows returned 
-- v20200721 0 rows
-- v20210119 0 rows
-- v20220328 0 rows
-- v20230324 0 rows
-- v20240326 0 rows

select
t3.pump_test_id
,t3.int_id_new
,dpump.int_id as int_id_old
from 
(
select 
dpump.pump_test_id
,max(dpump.int_id) as int_id_new
from 
(
select
t1.pump_test_id 
,t1.rcount 
from 
(
select
pump_test_id 
,COUNT(*) as rcount
from 
MOE_20240326.[dbo].[M_D_PUMPTEST]
group by 
pump_test_id 
) as t1
where 
t1.rcount>1
) as t2
inner join 
MOE_20240326.[dbo].[M_D_PUMPTEST] as dpump
on
t2.pump_test_id=dpump.pump_test_id
group by 
dpump.pump_test_id 
) as t3
inner join
MOE_20240326.[dbo].[M_D_PUMPTEST] as dpump
on
t3.pump_test_id=dpump.pump_test_id


-- if no values are returned, meaning nothing needs to be corrected,
-- still run the following (which will create an empty table)


select
t3.pump_test_id
,t3.int_id_new
,dpump.int_id as int_id_old
into MOE_20240326.dbo.YC_20240326_PUMP_INT
from 
(
select 
dpump.pump_test_id
,max(dpump.int_id) as int_id_new
from 
(
select
t1.pump_test_id 
,t1.rcount 
from 
(
select
pump_test_id 
,COUNT(*) as rcount
from 
MOE_20240326.[dbo].[M_D_PUMPTEST]
group by 
pump_test_id 
) as t1
where 
t1.rcount>1
) as t2
inner join 
MOE_20240326.[dbo].[M_D_PUMPTEST] as dpump
on
t2.pump_test_id=dpump.pump_test_id
group by 
dpump.pump_test_id 
) as t3
inner join
MOE_20240326.[dbo].[M_D_PUMPTEST] as dpump
on
t3.pump_test_id=dpump.pump_test_id


-- if this table is empty, we don't need to proceed

-- 2016.05.31 stopped here
-- 2017.09.05 stopped here
-- 2018.05.30 stopped here
-- v20190509 stopped here 
-- v20210119 stopped here 
-- v20220328 stopped here
-- v20230324 stopped here
-- v20240326 stopped here

-- we can now reassign those intervals in d_int_mon to the appropriate
-- int_ids; remember that the sys_record_id still remains diff for 
-- each row in the table

--select
--ycpi.int_id_new
--,dim.INT_ID 
--from 
--[MOE_201304].dbo.YC_20130923_PUMP_INT as ycpi
--inner join 
--[moe_201304].dbo.FM_D_INTERVAL_MONITOR as dim
--on
--ycpi.int_id_old=dim.INT_ID

--update [MOE_201304].dbo.FM_D_INTERVAL_MONITOR
--set
--INT_ID=ycpi.int_id_new
--from 
--[MOE_201304].dbo.YC_20130923_PUMP_INT as ycpi
--inner join 
--[moe_201304].dbo.FM_D_INTERVAL_MONITOR as dim
--on
--ycpi.int_id_old=dim.INT_ID

-- now we can remove those intervals from each of
-- d_int, d_int_ref_elev, d_int_temp_2, d_pump

-- these are the INT_IDs to be removed; 91 rows

--select
--ycpi.int_id_old
--from 
--[MOE_201304].dbo.yc_20130923_pump_int as ycpi
--where 
--ycpi.int_id_old 
--not in
--(
--select int_id_new from [MOE_201304].dbo.yc_20130923_pump_int 
--)

-- the d_int table; 91 rows

--select
--dint.INT_ID
--from 
--[MOE_201304].dbo.FM_D_INTERVAL as dint
--where 
--dint.INT_ID 
--in
--(
--select
--ycpi.int_id_old
--from 
--[MOE_201304].dbo.yc_20130923_pump_int as ycpi
--where 
--ycpi.int_id_old 
--not in
--(
--select int_id_new from [MOE_201304].dbo.yc_20130923_pump_int 
--)
--)

--delete from [MOE_201304].dbo.FM_D_INTERVAL
--where 
--INT_ID 
--in
--(
--select
--ycpi.int_id_old
--from 
--[MOE_201304].dbo.yc_20130923_pump_int as ycpi
--where 
--ycpi.int_id_old 
--not in
--(
--select int_id_new from [MOE_201304].dbo.yc_20130923_pump_int 
--)
--)

---- d_int_ref_elev

--select
--di.INT_ID
--from 
--[MOE_201304].dbo.FM_D_INTERVAL_REF_ELEV as di
--where 
--di.INT_ID 
--in
--(
--select
--ycpi.int_id_old
--from 
--[MOE_201304].dbo.yc_20130923_pump_int as ycpi
--where 
--ycpi.int_id_old 
--not in
--(
--select int_id_new from [MOE_201304].dbo.yc_20130923_pump_int 
--)
--)

--delete from [MOE_201304].dbo.FM_D_INTERVAL_REF_ELEV 
--where 
--INT_ID 
--in
--(
--select
--ycpi.int_id_old
--from 
--[MOE_201304].dbo.yc_20130923_pump_int as ycpi
--where 
--ycpi.int_id_old 
--not in
--(
--select int_id_new from [MOE_201304].dbo.yc_20130923_pump_int 
--)
--)

-- d_int_temp_2

--select
--di.INT_ID
--from 
--[MOE_201304].dbo.FM_D_INTERVAL_TEMPORAL_2 as di
--where 
--di.INT_ID 
--in
--(
--select
--ycpi.int_id_old
--from 
--[MOE_201304].dbo.yc_20130923_pump_int as ycpi
--where 
--ycpi.int_id_old 
--not in
--(
--select int_id_new from [MOE_201304].dbo.yc_20130923_pump_int 
--)
--)

--delete from [MOE_201304].dbo.FM_D_INTERVAL_TEMPORAL_2
--where 
--INT_ID 
--in
--(
--select
--ycpi.int_id_old
--from 
--[MOE_201304].dbo.yc_20130923_pump_int as ycpi
--where 
--ycpi.int_id_old 
--not in
--(
--select int_id_new from [MOE_201304].dbo.yc_20130923_pump_int 
--)
--)

-- d_pump

--select
--di.INT_ID
--from 
--[MOE_201304].dbo.FM_D_PUMPTEST as di
--where 
--di.INT_ID 
--in
--(
--select
--ycpi.int_id_old
--from 
--[MOE_201304].dbo.yc_20130923_pump_int as ycpi
--where 
--ycpi.int_id_old 
--not in
--(
--select int_id_new from [MOE_201304].dbo.yc_20130923_pump_int 
--)
--)

--delete from [MOE_201304].dbo.FM_D_PUMPTEST
--where 
--INT_ID 
--in
--(
--select
--ycpi.int_id_old
--from 
--[MOE_201304].dbo.yc_20130923_pump_int as ycpi
--where 
--ycpi.int_id_old 
--not in
--(
--select int_id_new from [MOE_201304].dbo.yc_20130923_pump_int 
--)
--)

