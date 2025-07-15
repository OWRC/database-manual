
--***** G.30.05.03 D_INTERVAL and D_INTERVAL_MONITOR Build tables

-- assemble the information necessary for the DIM table

-- remember to update the DATA_ID, SYS_TEMP1 and SYS_TEMP2 fields

-- v20190509 DATA_ID 521
-- v20200721 DATA_ID 522
-- v20210119 DATA_ID 523
-- v20220328 DATA_ID 524
-- v20230324 DATA_ID 525
-- v20240326 DATA_ID 526
-- v20250711 DATA_ID 528 

-- v20200721 2789 rows
-- v20210119 474 rows
-- v20220328 189
-- v20230324 1548
-- v20240326 10019
-- v20250711 5772 

select 
dim.LOC_ID
,dim.tmp_INT_ID
,dim.tmp_INT_TYPE_CODE
,dim.INT_ID 
,dim.MON_SCREEN_SLOT
,cast(moeccm.DES as varchar(255)) as MON_SCREEN_MATERIAL
,dim.MON_DIAMETER_OUOM
,dim.MON_DIAMETER_UNIT_OUOM
,dim.MON_TOP_OUOM
,dim.MON_BOT_OUOM
,dim.MON_UNIT_OUOM
,dim.MON_COMMENT
,cast(null as int) as MON_FLOWING
,cast( null as int ) as MON_ID
,cast( 528 as int ) as DATA_ID
,cast( '20250711k' as varchar(255) ) as SYS_TEMP1
,cast( 20250711 as int ) as SYS_TEMP2
,row_number() over (order by dim.loc_id) as rkey
into moe_20250711.dbo.O_D_INTERVAL_MONITOR
from 
MOE_20250711.dbo.ORMGP_20250711_upd_DINTMON as dim
left outer join MOE_20250711.dbo._code_casing_material as moeccm
on dim.MON_SCREEN_MATERIAL=moeccm.CODE

select
count(*)
from 
moe_20250711.dbo.O_D_INTERVAL_MONITOR

drop table moe_20250711.dbo.O_D_INTERVAL_MONITOR

-- assemble the information necessary for the DINT table

-- v20200721 2758 rows
-- v20210119 469 rows
-- v20220328 182 rows
-- v20230324 1516
-- v20240326 9898
-- v20250711 5697

select
t.LOC_ID
,t.INT_ID
,t.tmp_INT_ID
,cast( v.moe_well_id as varchar(255) ) as INT_NAME
,cast( t.tmp_int_id as varchar(255) ) as INT_NAME_ALT1
,t.tmp_INT_TYPE_CODE as INT_TYPE_CODE
,case 
when moe.date_completed is not null then moe.date_completed
else cast('1867-07-01' as datetime)
end as INT_START_DATE
,cast(1 as int) as INT_CONFIDENTIALITY_CODE
,cast(1 as int) as INT_ACTIVE
,cast( case
when t.int_id is not null then 1
else null
end as int) as int_exists
,cast(528 as int) as [DATA_ID]
,cast( '20250711l' as varchar(255) ) as SYS_TEMP1
,cast( 20250711 as int ) as SYS_TEMP2
,row_number() over (order by t.int_id) as rkey
into moe_20250711.dbo.O_D_INTERVAL
from 
(
select
dim.LOC_ID
,dim.INT_ID
,dim.tmp_INT_ID
,dim.tmp_INT_TYPE_CODE
from 
moe_20250711.dbo.O_D_INTERVAL_MONITOR as dim
group by
dim.loc_id,dim.tmp_int_id,dim.int_id,dim.tmp_int_type_code
) as t
--inner join oak_20160831_master.dbo.v_sys_moe_locations as v
inner join ORMGP_20250711_MOE_LOCNS as v
on t.tmp_int_id=v.moe_bore_hole_id
inner join moe_20250711.dbo.tblbore_hole as moe
on t.tmp_int_id=moe.bore_hole_id

select
count(*) 
from 
moe_20250711.dbo.O_D_INTERVAL

drop table moe_20250711.dbo.O_D_INTERVAL

-- check to make sure that duplicate rows have not appeared

-- v20210119 2 rows; corrected (ended up removing both)
-- v20220328 0 rows
-- v20230324 0
-- v20240326 0

select
*
from 
(
select
int_name_alt1
,count(*) as rcount
from 
moe_20250711.dbo.o_d_interval
group by
int_name_alt1
) as t
where 
t.rcount>1

--***** following were the corrections applied to the duplicates
--***** determined from the previous query; note that an indexed
--***** counter was added to aid in the removal of the duplicate row

select
*
from 
moe_20250711.dbo.o_d_interval
where 
int_name_alt1 in
(
'10508420'
)
order by 
loc_id

delete from moe_20250711.dbo.o_d_interval
where 
rkey in
( 107 )

-- look at all the 'new' records

select
*
from 
moe_20250711.dbo.o_d_interval

select
*
from 
moe_20250711.dbo.o_d_interval_monitor




