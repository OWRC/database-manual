
--***** G_10_14_08

--***** populate the depths and elevations in D_BOREHOLE

--***** v20210119 updated to use the D_LOCATION_SPATIAL_HIST table
--***** v20230324 note that we're removing the use of SRTM data
--***** v20250711 SRTM data used for locations on the border of the ORMGP study area 

select
dbore.LOC_ID
,delev.LOC_ELEV
,ycb.MAX_DEPTH_M
,(delev.LOC_ELEV-ycb.MAX_DEPTH_M) as BOTTOM_ELEV
from 
MOE_20250711.dbo.M_D_BOREHOLE as dbore
inner join MOE_20250711.dbo.YC_20250711_BH_ID as ycb
on dbore.LOC_ID=ycb.BORE_HOLE_ID
inner join 
(
select
dlsh.LOC_ID
,LOC_ELEV
from 
MOE_20250711.dbo.M_D_LOCATION_SPATIAL_HIST as dlsh
where
dlsh.LOC_ELEV_CODE=3
--dlsh.LOC_ELEV_CODE=5
---- Only load the SRTM elev if no MNR elev
--union
--select
--dlsh.LOC_ID
--,LOC_ELEV
--from 
--MOE_20250711.dbo.M_D_LOCATION_SPATIAL_HIST as dlsh
--where
--dlsh.LOC_ELEV_CODE=5
) as delev
on dbore.LOC_ID=delev.LOC_ID

--select
--dbore.LOC_ID
--,delev.ASSIGNED_ELEV
--,ycb.MAX_DEPTH_M
--,(delev.ASSIGNED_ELEV-ycb.MAX_DEPTH_M) as BOTTOM_ELEV
--from 
--MOE_20250711.dbo.M_D_BOREHOLE as dbore
--inner join MOE_20250711.dbo.M_D_LOCATION_ELEV as delev
--on dbore.LOC_ID=delev.LOC_ID 
--inner join MOE_20250711.dbo.YC_20250711_BH_ID as ycb
--on dbore.LOC_ID=ycb.BORE_HOLE_ID


-- v20170905 17185 rows updated
-- v20180530 15578 rows
-- v20190509 11851 rows
-- v20200721 11760 rows
-- v20210119 25519 rows
-- v20220328 15235 rows
-- v20230324 18826 rows
-- v20240326 23131 rows
-- v20250711 18375 rows (4 rows SRTM, changed manually)

update MOE_20250711.dbo.M_D_BOREHOLE
set 
BH_GND_ELEV=delev.LOC_ELEV
,BH_GND_ELEV_OUOM=delev.LOC_ELEV
,BH_DEM_GND_ELEV=delev.LOC_ELEV
,BH_BOTTOM_ELEV=(delev.LOC_ELEV-ycb.MAX_DEPTH_M)
,BH_BOTTOM_DEPTH=ycb.MAX_DEPTH_M
,BH_BOTTOM_OUOM=ycb.MAX_DEPTH_M
from 
MOE_20250711.dbo.M_D_BOREHOLE as dbore
inner join MOE_20250711.dbo.YC_20250711_BH_ID as ycb
on dbore.LOC_ID=ycb.BORE_HOLE_ID
inner join 
(
select
dlsh.LOC_ID
,LOC_ELEV
from 
MOE_20250711.dbo.M_D_LOCATION_SPATIAL_HIST as dlsh
where
dlsh.LOC_ELEV_CODE=3 
--dlsh.LOC_ELEV_CODE=5
---- Only load the SRTM elev if no MNR elev
--union
--select
--dlsh.LOC_ID
--,LOC_ELEV
--from 
--MOE_20250711.dbo.M_D_LOCATION_SPATIAL_HIST as dlsh
--where
--dlsh.LOC_ELEV_CODE=5
) as delev
on dbore.LOC_ID=delev.LOC_ID

--update MOE_20250711.dbo.M_D_BOREHOLE
--set 
--BH_GND_ELEV=delev.ASSIGNED_ELEV
--,BH_GND_ELEV_OUOM=delev.ASSIGNED_ELEV
--,BH_DEM_GND_ELEV=delev.ASSIGNED_ELEV
--,BH_BOTTOM_ELEV=(delev.ASSIGNED_ELEV-ycb.MAX_DEPTH_M)
--,BH_BOTTOM_DEPTH=ycb.MAX_DEPTH_M
--,BH_BOTTOM_OUOM=ycb.MAX_DEPTH_M
--from 
--MOE_20250711.dbo.M_D_BOREHOLE as dbore
--inner join MOE_20250711.dbo.M_D_LOCATION_ELEV as delev
--on dbore.LOC_ID=delev.LOC_ID 
--inner join MOE_20250711.dbo.YC_20250711_BH_ID as ycb
--on dbore.LOC_ID=ycb.BORE_HOLE_ID
