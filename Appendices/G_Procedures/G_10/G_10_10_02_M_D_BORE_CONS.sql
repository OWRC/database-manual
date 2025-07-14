
--***** G_10_10_02

--***** Introduce a counter (a temporary holder until we replace it with a random identifier)
--***** and create the M_D_B_BOREHOLE_CONSTRUCTION table

SELECT 
[BH_ID]
,[CON_SUBTYPE_CODE]
,[CON_TOP_OUOM]
,[CON_BOT_OUOM]
,[CON_UNIT_OUOM]
,[CON_DIAMETER_OUOM]
,[CON_DIAMETER_UNIT_OUOM]
,[CON_COMMENT]
,ROW_NUMBER() over (order by y.BH_ID) as SYS_RECORD_ID
FROM 
MOE_20250711.[dbo].[YC_20250711_DBHCONS] as y

SELECT 
[BH_ID]
,[CON_SUBTYPE_CODE]
,[CON_TOP_OUOM]
,[CON_BOT_OUOM]
,[CON_UNIT_OUOM]
,[CON_DIAMETER_OUOM]
,[CON_DIAMETER_UNIT_OUOM]
,[CON_COMMENT]
,ROW_NUMBER() over (order by y.BH_ID) as SYS_RECORD_ID
into MOE_20250711.dbo.M_D_BOREHOLE_CONSTRUCTION
FROM 
MOE_20250711.[dbo].[YC_20250711_DBHCONS] as y

-- v20170905 42915 rows 
-- v20180530 41014 rows 
-- v20190509 24434 rows
-- v20200721 31060 rows
-- v20210119 66718 rows
-- v20220328 23115 rows
-- v20230324 26307 rows
-- v20240326 33681 rows
-- v20250711 26039 rows

select
count(*) 
from 
MOE_20250711.dbo.M_D_BOREHOLE_CONSTRUCTION

--drop table m_d_borehole_construction

