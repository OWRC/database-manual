
--***** G_10_04_02

--***** MOE 1ST and 2ND use codes matched; create a lookup table for conversion; 
--***** we've changed any null vaulues to 0

--***** 20200928 Changed null/0 translatation from 4 to 0

-- v20210119 104985 rows
-- v20220328 121175 rows
-- v20230324 143706 rows
-- v20240326 153211 rows
-- v20250711 167109 rows

update MOE_20250711.dbo.TblWWR
set
USE_1ST=0
where
USE_1ST is null 

-- v20210119 488451 rows
-- v20220328 510907 rows
-- v20230324 543675 rows
-- v20240326 579850 rows
-- v20250711 608704 rows

update MOE_20250711.dbo.TblWWR
set
USE_2ND=0
where
USE_2ND is null 

select
 wwr.USE_1ST
,case 
     when wwr.USE_1ST is null then 0   -- Unknown
     when wwr.USE_1ST='0'     then 0   -- Unknown
     when wwr.USE_1ST='A'     then 10  -- OTHER
     when wwr.USE_1ST='B'     then 11  -- TEST HOLE
     when wwr.USE_1ST='C'     then 12  -- DEWATERING
     when wwr.USE_1ST='D'     then 13  -- MONITORING
	 when wwr.USE_1ST='E'     then 14  -- Monitoring and Test Hole
     else wwr.USE_1ST
 end
 as [MOE_USE]
from 
MOE_20250711.dbo.TblWWR as wwr
group by
USE_1ST
order by 
USE_1ST


select
 wwr.USE_1ST
,case 
     when wwr.USE_1ST is null then 0   -- Unknown
     when wwr.USE_1ST='0'     then 0   -- Unknown
     when wwr.USE_1ST='A'     then 10  -- OTHER
     when wwr.USE_1ST='B'     then 11  -- TEST HOLE
     when wwr.USE_1ST='C'     then 12  -- DEWATERING
     when wwr.USE_1ST='D'     then 13  -- MONITORING
	 when wwr.USE_1ST='E'     then 14  -- Monitoring and Test Hole
     else wwr.USE_1ST
 end
 as [MOE_USE]
into 
MOE_20250711.dbo.YC_20250711_MOE_USE
from 
MOE_20250711.dbo.TblWWR as wwr
group by
USE_1ST
order by 
USE_1ST

-- no new codes for USE_2ND; do not need to add to the MOE_USE table

select
 wwr.USE_2ND
,case 
     when wwr.USE_2ND is null then 0   -- Unknown
     when wwr.USE_2ND='0'     then 0   -- Unknown
     when wwr.USE_2ND='A'     then 10  -- OTHER
     when wwr.USE_2ND='B'     then 11  -- TEST HOLE
     when wwr.USE_2ND='C'     then 12  -- DEWATERING
     when wwr.USE_2ND='D'     then 13  -- MONITORING
	 when wwr.USE_2ND='E'     then 14  -- Monitoring and Test Hole
     else wwr.USE_2ND
 end
 as [MOE_USE]
from 
MOE_20250711.dbo.TblWWR as wwr
group by
USE_2ND
order by 
USE_2ND

