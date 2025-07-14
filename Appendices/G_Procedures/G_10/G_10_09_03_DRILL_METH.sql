
--***** G_10_09_03

--***** Create Drill Method comparison table

select
y.BORE_HOLE_ID
,m.METHOD_CONSTRUCTION_CODE
,case
     when m.METHOD_CONSTRUCTION_CODE is null then 0 
     when m.METHOD_CONSTRUCTION_CODE = '0' then 0           -- Unknown
     when m.METHOD_CONSTRUCTION_CODE = '1' then 1           -- Cable-tool
     when m.METHOD_CONSTRUCTION_CODE = '2' then 2           -- Rotary Conventional
     when m.METHOD_CONSTRUCTION_CODE = '3' then 3           -- Rotary Reverse
     when m.METHOD_CONSTRUCTION_CODE = '4' then 4           -- Rotary Air
     when m.METHOD_CONSTRUCTION_CODE = '5' then 5           -- Air Percussion
     when m.METHOD_CONSTRUCTION_CODE = '6' then 6           -- Boring
     when m.METHOD_CONSTRUCTION_CODE = '7' then 7           -- Diamond
     when m.METHOD_CONSTRUCTION_CODE = '8' then 8           -- Jetting
     when m.METHOD_CONSTRUCTION_CODE = '9' then 9           -- Driving
     when m.METHOD_CONSTRUCTION_CODE = 'A' then 10          -- Hand auger digging
     when m.METHOD_CONSTRUCTION_CODE = 'B' then 0           -- Other Method
     when m.METHOD_CONSTRUCTION_CODE = 'C' then 0           -- TBD
     when m.METHOD_CONSTRUCTION_CODE = 'D' then 9           -- Direct Push
     when m.METHOD_CONSTRUCTION_CODE = 'E' then 12          -- Auger (solid stem auger)
     when m.METHOD_CONSTRUCTION_CODE = 'F' then 13          -- Hollow stem auger
     when m.METHOD_CONSTRUCTION_CODE = 'G' then 12          -- Solid stem auger
     when m.METHOD_CONSTRUCTION_CODE = 'H' then 16          -- Geoprobe
     when m.METHOD_CONSTRUCTION_CODE = 'I' then 43          -- Sonic
     when m.METHOD_CONSTRUCTION_CODE = 'X' then 44          -- Vacuum (Truck)
     when m.METHOD_CONSTRUCTION_CODE = 'Y' then 18          -- ADDED: a YC code only - Pionjar
	when m.METHOD_CONSTRUCTION_CODE = 'Z' then 46          -- ADDED: a YC code only - Rotary (dual)
     else 0
 end 
 as BH_DRILL_METHOD_CODE
,cast( null as varchar(255) ) as BH_COMMENT
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y
inner join MOE_20250711.[dbo].[TblMethod_Construction] as m
on y.BORE_HOLE_ID= m.BORE_HOLE_ID

select
y.BORE_HOLE_ID
,m.METHOD_CONSTRUCTION_CODE
,case
     when m.METHOD_CONSTRUCTION_CODE is null then 0 
     when m.METHOD_CONSTRUCTION_CODE = '0' then 0           -- Unknown
     when m.METHOD_CONSTRUCTION_CODE = '1' then 1           -- Cable-tool
     when m.METHOD_CONSTRUCTION_CODE = '2' then 2           -- Rotary Conventional
     when m.METHOD_CONSTRUCTION_CODE = '3' then 3           -- Rotary Reverse
     when m.METHOD_CONSTRUCTION_CODE = '4' then 4           -- Rotary Air
     when m.METHOD_CONSTRUCTION_CODE = '5' then 5           -- Air Percussion
     when m.METHOD_CONSTRUCTION_CODE = '6' then 6           -- Boring
     when m.METHOD_CONSTRUCTION_CODE = '7' then 7           -- Diamond
     when m.METHOD_CONSTRUCTION_CODE = '8' then 8           -- Jetting
     when m.METHOD_CONSTRUCTION_CODE = '9' then 9           -- Driving
     when m.METHOD_CONSTRUCTION_CODE = 'A' then 10          -- Hand auger digging
     when m.METHOD_CONSTRUCTION_CODE = 'B' then 0           -- Other Method
     when m.METHOD_CONSTRUCTION_CODE = 'C' then 0           -- TBD
     when m.METHOD_CONSTRUCTION_CODE = 'D' then 9           -- Direct Push
     when m.METHOD_CONSTRUCTION_CODE = 'E' then 12          -- Auger (solid stem auger)
     when m.METHOD_CONSTRUCTION_CODE = 'F' then 13          -- Hollow stem auger
     when m.METHOD_CONSTRUCTION_CODE = 'G' then 12          -- Solid stem auger
     when m.METHOD_CONSTRUCTION_CODE = 'H' then 16          -- Geoprobe
     when m.METHOD_CONSTRUCTION_CODE = 'I' then 43          -- Sonic
     when m.METHOD_CONSTRUCTION_CODE = 'Y' then 18          -- ADDED: a YC code only - Pionjar
     when m.METHOD_CONSTRUCTION_CODE = 'Z' then 46          -- ADDED: a YC code only - Rotary (dual)
     else 0
 end 
 as BH_DRILL_METHOD_CODE
,cast( null as varchar(255) ) as BH_COMMENT
into MOE_20250711.dbo.YC_20250711_DRILL_CODE
from 
MOE_20250711.dbo.YC_20250711_BH_ID as y
inner join MOE_20250711.[dbo].[TblMethod_Construction] as m
on y.BORE_HOLE_ID= m.BORE_HOLE_ID

--drop table YC_20250711_DRILL_CODE

-- v20180530 379 rows
-- v20180530 7043 rows 
-- v20190509 7894 rows
-- v20200721 9373 rows
-- v20210119 20063 rows
-- v20220328 5439 rows
-- v20230324 5926 rows
-- v20240326 7955 rows
-- v20250711 5760 rows

select
count(*) 
from 
MOE_20250711.dbo.YC_20250711_DRILL_CODE

--alter table YC_20250711_DRILL_CODE add BH_COMMENT varchar(255)




