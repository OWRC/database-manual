
--***** A look up table for translating MOE zones to YCDB zone codes

select 
 ZONE
,count(*) as [rowcount]
,case 
     when ZONE=15 then 7
     when ZONE=16 then 8
     when ZONE=17 then 4
     when ZONE=18 then 5
     else null           -- the remainder of the zones should be invalid
 end 
 as [LOC_COORD_OUOM_CODE]
FROM 
MOE_20210119.[dbo].[TblBore_Hole] as tbh
group by
ZONE 

select 
ZONE
,count(*) as [rowcount]
,case 
     when ZONE=15 then 7
     when ZONE=16 then 8
     when ZONE=17 then 4
     when ZONE=18 then 5
     else null           -- the remainder of the zones should be invalid
 end 
 as [LOC_COORD_OUOM_CODE]
into 
MOE_20210119.dbo.YC_20210119_LOC_COORD_OUOM_CODE
FROM 
MOE_20210119.[dbo].[TblBore_Hole] as tbh
group by
ZONE 


