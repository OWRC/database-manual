
--***** G_10_07_01

--***** extract D_LOCATION_QA equivalent

-- the QA codes match between the MOE and YC databases for both
-- coordinates and elevations; default the QA_ELEV_CONFIDENCE_CODE
-- to 10 (DEM) if the ELEVRC value is not 1

--***** 20230324
--***** no '1' values; default to 10

select 
y.BORE_HOLE_ID as LOC_ID
,case 
     when m.UTMRC is null then 9
     else m.UTMRC 
 end 
 as [QA_COORD_CONFIDENCE_CODE]
,case 
     when m.UTMRC is null then 9
     else m.UTMRC 
 end 
 as [QA_COORD_CONFIDENCE_CODE_ORIG]
,m.[LOCATION_METHOD] as [QA_COORD_METHOD]
--,case
--     when m.ELEVRC=1 then 1
--     else 10
-- end as [QA_ELEV_CONFIDENCE_CODE]
,10 as QA_ELEV_CONFIDENCE_CODE
--,m.ELEVRC as [QA_ELEV_CONFIDENCE_CODE_ORIG]
,cast(null as int) as QA_ELEV_CONFIDENCE_CODE_ORIG
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
inner join MOE_20240326.dbo.TblBore_Hole as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID


-- v20230324, error on conversion, check the values
-- v20240326 0 rows returned for ELEVRC

select 
--distinct( UTMRC ) as UTMRC
--distinct( LOCATION_METHOD ) as LOCATION_METHOD
distinct( ELEVRC ) as ELEVRC
from 
MOE_20240326.dbo.TblBore_Hole


select 
y.BORE_HOLE_ID as LOC_ID
,case 
     when m.UTMRC is null then 9
     else m.UTMRC 
 end 
 as [QA_COORD_CONFIDENCE_CODE]
,case 
     when m.UTMRC is null then 9
     else m.UTMRC 
 end 
 as [QA_COORD_CONFIDENCE_CODE_ORIG]
,m.[LOCATION_METHOD] as [QA_COORD_METHOD]
--,case
--     when m.ELEVRC=1 then 1
--     else 10
-- end as [QA_ELEV_CONFIDENCE_CODE]
,10 as QA_ELEV_CONFIDENCE_CODE
--,m.ELEVRC as [QA_ELEV_CONFIDENCE_CODE_ORIG]
,cast(null as int) as QA_ELEV_CONFIDCENCE_CODE
into MOE_20240326.dbo.M_D_LOCATION_QA
from 
MOE_20240326.dbo.YC_20240326_BH_ID as y
inner join MOE_20240326.dbo.TblBore_Hole as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID

