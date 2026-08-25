
--***** G_10_09_05

--***** Build the M_D_BOREHOLE table

-- as of v20220328, we've added the MOE_WELL_ID and CONTRACTOR_NUM fields to bypass collation issues

select
y.BORE_HOLE_ID as BH_ID 
,y.BORE_HOLE_ID as LOC_ID
,cast(null as float) as BH_GND_ELEV
,cast(null as float) as BH_GND_ELEV_OUOM
,cast('masl' as varchar(50)) as BH_GND_ELEV_UNIT_OUOM
,cast(null as float) as BH_DEM_GND_ELEV
,cast(null as float) as BH_BOTTOM_ELEV
,cast(null as float) as BH_BOTTOM_DEPTH
,cast(null as float) as BH_BOTTOM_OUOM
,cast('mbgs' as varchar(50)) as BH_BOTTOM_UNIT_OUOM
,ydc.BH_DRILL_METHOD_CODE
,rbdc.BH_DRILLER_CODE as [BH_DRILLER_CODE]
,moebh.DATE_COMPLETED as [BH_DRILL_END_DATE]
,ycfs.BH_STATUS_CODE 
,cast(90 as int) as [BH_DIP]
,cast(0 as int) as [BH_AZIMUTH]
,cast(moeh.max_diameter as float) as BH_DIAMETER_OUOM
,cast(moeh.HOLE_DIAMETER_UOM collate database_default as varchar(50)) as BH_DIAMETER_UNIT_OUOM
,cast(moecwt.[des] collate database_default as varchar(255)) as MOE_BH_GEOLOGY_CLASS
,rtrim( cast( ydc.BH_COMMENT as varchar(255) ) ) as BH_COMMENT
,row_number() over (order by y.bore_hole_id) as rkey
from 
MOE_20260813.dbo.YC_20260813_BH_ID as y
left outer join MOE_20260813.dbo.YC_20260813_DRILL_CODE as ydc
on y.BORE_HOLE_ID=ydc.BORE_HOLE_ID
left outer join
(
select 
moeh.Bore_Hole_ID
,MAX(moeh.Diameter) as [max_diameter]
,moeh.HOLE_DIAMETER_UOM
from 
MOE_20260813.dbo.TblHole as moeh
where
moeh.diameter is not null
group by 
Bore_Hole_ID,moeh.HOLE_DIAMETER_UOM
) as moeh
on y.BORE_HOLE_ID=moeh.Bore_Hole_ID
left outer join MOE_20260813.dbo.TblWWR as moewwr
on y.MOE_WELL_ID=moewwr.MOE_WELL_ID
left outer join MOE_20260813.dbo.YC_20260813_FINAL_STATUS as ycfs
on moewwr.FINAL_STA collate database_default = ycfs.FINAL_STA
inner join MOE_20260813.dbo.TblBore_Hole as moebh
on y.BORE_HOLE_ID=moebh.BORE_HOLE_ID
left outer join MOE_20260813.dbo._code_Well_Type as moecwt
on moebh.CODEOB collate database_default = moecwt.code collate database_default
left outer join OAK_20160831_MASTER.dbo.R_BH_DRILLER_CODE as rbdc
--on moewwr.CONTRACTOR collate database_default=rbdc.BH_DRILLER_ALT_CODE collate database_default 
on moewwr.CONTRACTOR_NUM = cast( rbdc.bh_driller_alt_code as int )


select
y.BORE_HOLE_ID as BH_ID 
,y.BORE_HOLE_ID as LOC_ID
,cast(null as float) as BH_GND_ELEV
,cast(null as float) as BH_GND_ELEV_OUOM
,cast('masl' as varchar(50)) as BH_GND_ELEV_UNIT_OUOM
,cast(null as float) as BH_DEM_GND_ELEV
,cast(null as float) as BH_BOTTOM_ELEV
,cast(null as float) as BH_BOTTOM_DEPTH
,cast(null as float) as BH_BOTTOM_OUOM
,cast('mbgs' as varchar(50)) as BH_BOTTOM_UNIT_OUOM
,ydc.BH_DRILL_METHOD_CODE
,rbdc.BH_DRILLER_CODE as [BH_DRILLER_CODE]
,moebh.DATE_COMPLETED as [BH_DRILL_END_DATE]
,ycfs.BH_STATUS_CODE 
,cast(90 as int) as [BH_DIP]
,cast(0 as int) as [BH_AZIMUTH]
,cast(moeh.max_diameter as float) as BH_DIAMETER_OUOM
,cast(moeh.HOLE_DIAMETER_UOM collate database_default as varchar(50)) as BH_DIAMETER_UNIT_OUOM
,cast(moecwt.[des] collate database_default as varchar(255)) as MOE_BH_GEOLOGY_CLASS
,rtrim( cast( ydc.BH_COMMENT as varchar(255) ) ) as BH_COMMENT
,row_number() over (order by y.bore_hole_id) as rkey
into MOE_20260813.dbo.M_D_BOREHOLE
from 
MOE_20260813.dbo.YC_20260813_BH_ID as y
left outer join MOE_20260813.dbo.YC_20260813_DRILL_CODE as ydc
on y.BORE_HOLE_ID=ydc.BORE_HOLE_ID
left outer join
(
select 
moeh.Bore_Hole_ID
,MAX(moeh.Diameter) as [max_diameter]
,moeh.HOLE_DIAMETER_UOM
from 
MOE_20260813.dbo.TblHole as moeh
where
moeh.diameter is not null
group by 
Bore_Hole_ID,moeh.HOLE_DIAMETER_UOM
) as moeh
on y.BORE_HOLE_ID=moeh.Bore_Hole_ID
left outer join MOE_20260813.dbo.TblWWR as moewwr
on y.MOE_WELL_ID=moewwr.MOE_WELL_ID
left outer join MOE_20260813.dbo.YC_20260813_FINAL_STATUS as ycfs
on moewwr.FINAL_STA collate database_default = ycfs.FINAL_STA
inner join MOE_20260813.dbo.TblBore_Hole as moebh
on y.BORE_HOLE_ID=moebh.BORE_HOLE_ID
left outer join MOE_20260813.dbo._code_Well_Type as moecwt
on moebh.CODEOB collate database_default = moecwt.code collate database_default
left outer join OAK_20160831_MASTER.dbo.R_BH_DRILLER_CODE as rbdc
--on moewwr.CONTRACTOR collate database_default=rbdc.BH_DRILLER_ALT_CODE collate database_default 
on moewwr.CONTRACTOR_NUM = cast( rbdc.bh_driller_alt_code as int )


--drop table M_D_BOREHOLE

-- v20170905 17185 rows
-- v20180530 15578 rows
-- v20190509 11851 rows
-- v20200721 11760 rows
-- v20210119 25591 rows
-- v20220328 15621 rows
-- v20230324 19504 rows
-- v20240326 24032 rows
-- v20250711 18973 rows
-- v20260813 138612 rows

select
count(*)
from 
moe_20260813.dbo.m_d_borehole

--***** LOOK FOR DUPLICATE LOC_IDs in M_D_BOREHOLE (due to multiple Drill methods)

-- make a backup copy of M_D_BOREHOLE

select
*
into moe_20260813.dbo.M_D_BOREHOLE_bck
from 
moe_20260813.dbo.M_D_BOREHOLE

-- how many duplicates; create a view to ease the queries

-- v20210119 1730 rows
-- v20220328 363 rows
-- v20230324 644 rows
-- v20240326 830 rows
-- v20250711 571 rows
-- v20260813 7853 rows

-- comment out the first line when getting the count
--create view V_DBORE_DRILL_CODES as
select
dbore.rkey
,t.min_rkey
,t.max_rkey
,t.rcount
from
(
select
loc_id
,min(rkey) as min_rkey
,max(rkey) as max_rkey
,count(*) as rcount
from 
MOE_20260813.dbo.M_D_BOREHOLE
group by
loc_id
) as t
inner join MOE_20260813.dbo.M_D_BOREHOLE as dbore
on t.loc_id=dbore.loc_id
where 
t.rcount>1
and dbore.rkey=t.max_rkey

--drop view V_DBORE_DRILL_CODES

-- copy the max rkey into new table, then delete from main;
-- repeat until no more records are returned vrom V_DBORE_DRILL_CODES

-- v20210119 repeated three times
-- v20220328 repeated two times
-- v20230324 repeated three times
-- v20240326 repeated twice
-- v20250711 repeated twice
-- v20260831 repeated nine times; removed the final twenty bore_hole_id duplicates by hand

select
dbore.BH_ID
,dbore.LOC_ID
,dbore.BH_DRILL_METHOD_CODE
,dbore.rkey
--into MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_1
--into MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_2
--into MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_3
--into MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_4
--into MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_5
--into MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_6
--into MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_7
--into MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_8
--into MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_9
from 
MOE_20260813.dbo.M_D_BOREHOLE as dbore
inner join MOE_20260813.dbo.V_DBORE_DRILL_CODES as v
on dbore.rkey=v.rkey

delete from MOE_20260813.dbo.M_D_BOREHOLE
where rkey in
( 
select
rkey
from 
--MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_1
--MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_2
--MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_3
--MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_4
--MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_5
--MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_6
--MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_7
--MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_8
--MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_9
)

select * from MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_6

select * from MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_7

-- some cleanup may be necessary; after a number of runs, leave the minimum rkey for any bh_id

select * from MOE_20260813.dbo.M_D_BOREHOLE where bh_id= 1010219507

delete from MOE_20260813.dbo.M_D_BOREHOLE
where rkey in 
( 
96750
,96751
,96752
,96753
,96754
)

-- the following is used if an error was made, above

--drop table MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_1

--drop table MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_2

--drop table MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_3

--drop table MOE_20260813.dbo.M_D_BOREHOLE

--select
--*
--into MOE_20260813.dbo.M_D_BOREHOLE
--from 
--MOE_20260813.dbo.M_D_BOREHOLE_bck

-- check that the M_D_BOREHOLE table has been reduced to the same
-- count in M_D_LOCATION

-- v20210119 24619 rows - okay
-- v20220328 15235 rows - okay
-- v20230324 18826 rows - okay
-- v20240326 23131 rows - okay

select
count(*)
from 
MOE_20260813.dbo.M_D_BOREHOLE

-- delete those records in the new tables that match the first/current (i.e. they are duplicate codes)
-- i.e. first/current versus 1, versus 2, versus 3, ...

delete from MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_1
where loc_id in
(
select
y.loc_id
from 
MOE_20260813.dbo.M_D_BOREHOLE as m
inner join MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_1 as y
on m.loc_id=y.loc_id
where
m.bh_drill_method_code=y.bh_drill_method_code
)

-- delete those records that duplicate across the multiple tables
-- 1 versus 2, 1 versus 3, 1 versus 4, ..., 2 versus 3, 2 versus 4, ..., 3 versus 4, 3 versus 5, ...

delete from MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_9
where loc_id in
(
select
y2.loc_id
from 
MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_8 as y1
inner join MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_9 as y2
on y1.loc_id=y2.loc_id
where
y1.bh_drill_method_code=y2.bh_drill_method_code
)

--***** v20260813 note that the above reduced the nine tables to four

-- make a backup copy of M_D_BOREHOLE (this includes the updates to the drilling codes)

select
*
into moe_20260813.dbo.M_D_BOREHOLE_bck2
from 
moe_20260813.dbo.M_D_BOREHOLE

-- add these extra BH_DRILL_METHOD_CODES (as text) into the BH_COMMENT field


-- two tables
--***** v20260813 old method - disabled 

--update MOE_20260813.dbo.M_D_BOREHOLE
--set
--BH_COMMENT=
--case
--when bh_comment is null then t.to_add
--else bh_comment + '; ' + t.to_add
--end
--from 
--MOE_20260813.dbo.M_D_BOREHOLE as moe
--inner join
--(
--select
--dbore.LOC_ID
--,'Addn drill methods: '+ r1.bh_drill_method_description +
--case
--when d2.loc_id is not null then
--	'; ' + r2.bh_drill_method_description -- use this (only) if there are only two iterations; the following if three
--else ''
--end as to_add
--from 
--MOE_20260813.dbo.M_D_BOREHOLE as dbore
--inner join MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_1 as d1
--on dbore.loc_id=d1.loc_id
--inner join OAK_20160831_MASTER.dbo.R_BH_DRILL_METHOD_CODE as r1
--on d1.bh_drill_method_code=r1.bh_drill_method_code
--left outer join MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_2 as d2
--on dbore.loc_id=d2.loc_id 
--left outer join OAK_20160831_MASTER.dbo.R_BH_DRILL_METHOD_CODE as r2
--on d2.bh_drill_method_code=r2.bh_drill_method_code
--) as t
--on moe.loc_id=t.loc_id

-- three tables
--***** v20260813 old method - disabled 

--update MOE_20260813.dbo.M_D_BOREHOLE
--set
--BH_COMMENT=
--case
--when bh_comment is null then t.to_add
--else bh_comment + '; ' + t.to_add
--end
--from 
--MOE_20260813.dbo.M_D_BOREHOLE as moe
--inner join
--(
--select
--dbore.LOC_ID
--,'Addn drill methods: '+ r1.bh_drill_method_description +
--case
--when d2.loc_id is not null then
--	--'; ' + r2.bh_drill_method_description -- use this (only) if there are only two iterations; the following if three
--    case
--    when d3.loc_id is not null then
--         '; ' + r2.bh_drill_method_description + '; ' + r3.bh_drill_method_description
--    else '; ' + r2.bh_drill_method_description
--    end
--else ''
--end as to_add
--from 
--MOE_20260813.dbo.M_D_BOREHOLE as dbore
--inner join MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_1 as d1
--on dbore.loc_id=d1.loc_id
--inner join OAK_20160831_MASTER.dbo.R_BH_DRILL_METHOD_CODE as r1
--on d1.bh_drill_method_code=r1.bh_drill_method_code
--left outer join MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_2 as d2
--on dbore.loc_id=d2.loc_id 
--left outer join OAK_20160831_MASTER.dbo.R_BH_DRILL_METHOD_CODE as r2
--on d2.bh_drill_method_code=r2.bh_drill_method_code
--left outer join MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_3 as d3
--on dbore.loc_id=d3.loc_id
--left outer join OAK_20160831_MASTER.dbo.R_BH_DRILL_METHOD_CODE as r3
--on d3.bh_drill_method_code=r3.bh_drill_method_code
--) as t
--on moe.loc_id=t.loc_id

-- four tables
-- v20260813 - new method

update MOE_20260813.dbo.M_D_BOREHOLE
set
BH_COMMENT=
case
when bh_comment is null then t.to_add
else bh_comment + '; ' + t.to_add
end
from 
MOE_20260813.dbo.M_D_BOREHOLE as moe
inner join
(
select
t2.LOC_ID
,'Addn drill methods: ' + t2.r1_d + t2.r2_d + t2.r3_d + t2.r4_d as to_add
from 
(
select
dbore.LOC_ID
,case when r1.bh_drill_method_description is not null then r1.bh_drill_method_description + '; ' else '' end as r1_d
,case when r2.bh_drill_method_description is not null then r2.bh_drill_method_description + '; ' else '' end as r2_d
,case when r3.bh_drill_method_description is not null then r3.bh_drill_method_description + '; ' else '' end as r3_d
,case when r4.bh_drill_method_description is not null then r4.bh_drill_method_description + '; ' else '' end as r4_d
from 
MOE_20260813.dbo.M_D_BOREHOLE as dbore
inner join MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_1 as d1
on dbore.loc_id=d1.loc_id
inner join OAK_20160831_MASTER.dbo.R_BH_DRILL_METHOD_CODE as r1
on d1.bh_drill_method_code=r1.bh_drill_method_code
left outer join MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_2 as d2
on dbore.loc_id=d2.loc_id 
left outer join OAK_20160831_MASTER.dbo.R_BH_DRILL_METHOD_CODE as r2
on d2.bh_drill_method_code=r2.bh_drill_method_code
left outer join MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_3 as d3
on dbore.loc_id=d3.loc_id
left outer join OAK_20160831_MASTER.dbo.R_BH_DRILL_METHOD_CODE as r3
on d3.bh_drill_method_code=r3.bh_drill_method_code
left outer join MOE_20260813.dbo.YC_20260813_DBORE_DRILL_CODES_4 as d4
on dbore.loc_id=d4.loc_id
left outer join OAK_20160831_MASTER.dbo.R_BH_DRILL_METHOD_CODE as r4
on d4.bh_drill_method_code=r4.bh_drill_method_code
) as t2
) as t
on moe.loc_id=t.loc_id


-- check the M_D_BOREHOLE table for counts; this should match the number of records in M_D_LOCATION

-- v20240326 23131 records
-- v20250711 18379 records
-- v20260813 129172 records in dbore versus 129172 records in dloc; match

select count(*) as rcount from MOE_20260813.dbo.M_D_BOREHOLE as dbore

select count(*) as rcount from MOE_20260813.dbo.M_D_LOCATION as dloc

-- if there is an issue, delete the M_D_BOREHOLE table and copy the backup

select
*
into MOE_20260813.dbo.M_D_BOREHOLE
from 
MOE_20260813.dbo.M_D_BOREHOLE_bck



