
--***** G_10_10_01

--***** Assemble D_BOREHOLE_CONSTRUCTION

-- Note that we're making a tmp D_B_CONS table to assemble all construction elements
-- first before coming up with some random sys_record_ids

-- the CASING information; at least one casing info field must not be empty; we
-- don't need the sys_record_id yet

-- v20180530 18133 rows 
-- v20190509 9021 rows
-- v20200721 10902 rows
-- v20210119 22672 rows
-- v20220328 6551 rows
-- v20230324 6709 rows
-- v20240326 8670 rows

select
-- note that we're using BORE_HOLE_ID as a temporary BH_ID
y.BORE_HOLE_ID as BH_ID
,case
when moec.MATERIAL is null then 10      -- unknown
when moec.MATERIAL = 1     then 21      -- steel casing
when moec.MATERIAL = 2     then 16      -- galvanized
when moec.MATERIAL = 3     then 23      -- concrete
when moec.MATERIAL = 4     then 24      -- open hole
when moec.MATERIAL = 5     then 25      -- plastic
when moec.MATERIAL = 6     then 32      -- fibreglass
when moec.MATERIAL = 7     then 10      -- unknown/other
when moec.MATERIAL = 8     then 52      -- stainless steel
else -9999
end 
as [CON_SUBTYPE_CODE]
,moec.DEPTH_FROM as [CON_TOP_OUOM]
,moec.DEPTH_TO as [CON_BOT_OUOM]
,moec.CASING_DEPTH_UOM as [CON_UNIT_OUOM]
,moec.CASING_DIAMETER as [CON_DIAMETER_OUOM]
,moec.CASING_DIAMETER_UOM as [CON_DIAMETER_UNIT_OUOM]
,convert(varchar(255),null) as CON_COMMENT
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
inner join MOE_20240326.dbo.TblPipe as moep
on y.BORE_HOLE_ID=moep.Bore_Hole_ID
inner join MOE_20240326.dbo.TblCasing as moec
on moep.PIPE_ID=moec.PIPE_ID
where
not
(
moec.DEPTH_TO is null 
and moec.CASING_DEPTH_UOM is null 
and moec.CASING_DIAMETER is null 
and moec.CASING_DIAMETER_UOM is null
)

select
-- note that we're using BORE_HOLE_ID as a temporary BH_ID
y.BORE_HOLE_ID as BH_ID
,case
when moec.MATERIAL is null then 10      -- unknown
when moec.MATERIAL = 1     then 21      -- steel casing
when moec.MATERIAL = 2     then 16      -- galvanized
when moec.MATERIAL = 3     then 23      -- concrete
when moec.MATERIAL = 4     then 24      -- open hole
when moec.MATERIAL = 5     then 25      -- plastic
when moec.MATERIAL = 6     then 32      -- fibreglass
when moec.MATERIAL = 7     then 10      -- unknown/other
when moec.MATERIAL = 8     then 52      -- stainless steel
else -9999
end 
as [CON_SUBTYPE_CODE]
,moec.DEPTH_FROM as [CON_TOP_OUOM]
,moec.DEPTH_TO as [CON_BOT_OUOM]
,moec.CASING_DEPTH_UOM as [CON_UNIT_OUOM]
,moec.CASING_DIAMETER as [CON_DIAMETER_OUOM]
,moec.CASING_DIAMETER_UOM as [CON_DIAMETER_UNIT_OUOM]
,convert(varchar(255),null) as CON_COMMENT
into MOE_20240326.dbo.YC_20240326_DBHCONS
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
inner join MOE_20240326.dbo.TblPipe as moep
on y.BORE_HOLE_ID=moep.Bore_Hole_ID
inner join MOE_20240326.dbo.TblCasing as moec
on moep.PIPE_ID=moec.PIPE_ID
where
not
(
moec.DEPTH_TO is null 
and moec.CASING_DEPTH_UOM is null 
and moec.CASING_DIAMETER is null 
and moec.CASING_DIAMETER_UOM is null
)

-- the PLUG information

-- as of 20220328, changed CON_SUBTUPE_CODE from the default 31 to 29

-- v20170905 27210 rows 
-- v20180531 22881 rows
-- v20190509 15413 rows
-- v20200721 20158 rows
-- v20210119 44046 rows
-- v20220328 16564 rows
-- v20230324 19598 rows
-- v20240326 25011 rows

insert into MOE_20240326.dbo.YC_20240326_DBHCONS
(BH_ID,CON_SUBTYPE_CODE,CON_TOP_OUOM,CON_BOT_OUOM,CON_UNIT_OUOM)
select 
-- note that we're using BORE_HOLE_ID as a temporary BH_ID
ycb.BORE_HOLE_ID as BH_ID
,29 as CON_SUBTYPE_CODE
,moep.PLUG_FROM as [CON_TOP_OUOM]
,moep.PLUG_TO   as [CON_BOT_OUOM]
,moep.PLUG_DEPTH_UOM as [CON_UNIT_OUOM]
from 
MOE_20240326.dbo.YC_20240326_BH_ID as ycb
inner join MOE_20240326.dbo.TblPlug as moep
on ycb.BORE_HOLE_ID=moep.BORE_HOLE_ID
where 
not 
(
moep.PLUG_FROM is null 
and moep.PLUG_TO is null 
and moep.PLUG_DEPTH_UOM is null 
)

-- check that CON_TOP_OUOM is above (less than) CON_BOT_OUOM

-- v20170905 4188 rows 
-- v20180530 3240 rows
-- v20190509 2519 rows
-- v20200721 2377 rows
-- v20210119 5083 rows
-- v20220328 451 rows
-- v20230324 7 rows
-- v20240326 12 rows

SELECT 
[BH_ID]
,[CON_SUBTYPE_CODE]
,[CON_TOP_OUOM]
,[CON_BOT_OUOM]
,[CON_UNIT_OUOM]
,[CON_DIAMETER_OUOM]
,[CON_DIAMETER_UNIT_OUOM]
,[CON_COMMENT]
FROM MOE_20240326.[dbo].[YC_20240326_DBHCONS]
where
CON_TOP_OUOM>CON_BOT_OUOM
--and CON_COMMENT is not null

update MOE_20240326.[dbo].[YC_20240326_DBHCONS]
set
CON_TOP_OUOM=CON_BOT_OUOM
,CON_BOT_OUOM=CON_TOP_OUOM
,CON_COMMENT='Exchanged top and bot values'
where
CON_TOP_OUOM>CON_BOT_OUOM

--drop table yc_20240326_dbhcons

-- check temporary dbhcons table

-- v20240326 33681 records

select * from MOE_20240326.[dbo].[YC_20240326_DBHCONS]


--***** 20200731

-- add STAINLESS STEEL

insert into r_con_subtype_code
( con_type_code, con_subtype_description )
values 
( 3, 'Casing - Stainless Steel' )

