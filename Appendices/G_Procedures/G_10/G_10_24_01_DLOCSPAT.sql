
--***** G_10_24_01

--****** The D_LOCATION_SPATIAL_HIST and D_LOCATION_SPATIAL tables
--****** need to be populated; note this uses the previously created
--****** D_LOCATION_ELEV and D_LOCATION_ELEV_HIST tables (which are no
--****** longer used in the master db) as a base

-- M_D_LOCATION_SPATIAL_HIST

-- remember that this table uses an identity column (i.e. an automatic counter) so we didn't
-- need to add a separate identifier

-- note that some of these fields need to be manually updated

--***** v20210119 - creation of D_LOCATION_SPATIAL_HIST moved to earlier in the process

-- Remember, SPAT_ID is an identity field

select
LOC_ID
,LOC_COORD_HIST_CODE
,LOC_COORD_DATE
,X
,Y
,EPSG_CODE
,X_OUOM
,Y_OUOM
,EPSG_CODE_OUOM
,QA_COORD_CODE
,LOC_COORD_DATA_ID
,cast(LOC_COORD_METHOD as varchar(255)) as LOC_COORD_METHOD
,LOC_ELEV_CODE
,LOC_ELEV_DATE
,LOC_ELEV
,LOC_ELEV_UNIT_CODE
,LOC_ELEV_OUOM
,cast(LOC_ELEV_UNIT_OUOM as varchar(50)) as LOC_ELEV_UNIT_OUOM
,QA_ELEV_CODE
,LOC_ELEV_DATA_ID
,cast(LOC_ELEV_COMMENT as varchar(255)) as LOC_ELEV_COMMENT
,'20240326c' as SYS_TEMP1
,20240326 as SYS_TEMP2
from 
MOE_20240326.dbo.M_D_LOCATION_SPATIAL_HIST as dlsh

insert into oak_20160831_master.dbo.d_location_spatial_hist
(
LOC_ID
,LOC_COORD_HIST_CODE
,LOC_COORD_DATE
,X
,Y
,EPSG_CODE
,X_OUOM
,Y_OUOM
,EPSG_CODE_OUOM
,QA_COORD_CODE
,LOC_COORD_DATA_ID
,LOC_COORD_METHOD
,LOC_ELEV_CODE
,LOC_ELEV_DATE
,LOC_ELEV
,LOC_ELEV_UNIT_CODE
,LOC_ELEV_OUOM
,LOC_ELEV_UNIT_OUOM
,QA_ELEV_CODE
,LOC_ELEV_DATA_ID
,LOC_ELEV_COMMENT
,SYS_TEMP1
,SYS_TEMP2
)
select
LOC_ID
,LOC_COORD_HIST_CODE
,LOC_COORD_DATE
,X
,Y
,EPSG_CODE
,X_OUOM
,Y_OUOM
,EPSG_CODE_OUOM
,QA_COORD_CODE
,LOC_COORD_DATA_ID
,cast(LOC_COORD_METHOD as varchar(255)) as LOC_COORD_METHOD
,LOC_ELEV_CODE
,LOC_ELEV_DATE
,LOC_ELEV
,LOC_ELEV_UNIT_CODE
,LOC_ELEV_OUOM
,cast(LOC_ELEV_UNIT_OUOM as varchar(50)) as LOC_ELEV_UNIT_OUOM
,QA_ELEV_CODE
,LOC_ELEV_DATA_ID
,cast(LOC_ELEV_COMMENT as varchar(255)) as LOC_ELEV_COMMENT
,'20240326c' as SYS_TEMP1
,20240326 as SYS_TEMP2
from 
MOE_20240326.dbo.M_D_LOCATION_SPATIAL_HIST as dlsh


-- D_LOCATION_SPATIAL

-- Upate DATA_ID, SYS_TEMP1, SYS_TEMP2

-- as of v20220328, the following statement appears to be unnecessary

--select
--delev.LOC_ID
--,dlsh.SPAT_ID
--,'20220328a' as SYS_TEMP1
--,20220328 as SYS_TEMP2
--from 
--moe_20240326.dbo.m_d_location_spatial_hist as delev
--inner join oak_20160831_master.dbo.d_location_spatial_hist as dlsh
--on delev.loc_elev_id=dlsh.sys_temp2
--where 
--dlsh.loc_coord_data_id= 524

-- note that very few loc_elev_codes of '5' should be present (normally these result
-- from and 'edge' issue)

--***** 20230324 Removed SRTM population

select 
dlsh.LOC_ID
,dlsh.SPAT_ID
,526 as DATA_ID
,'20240326c' as SYS_TEMP1
,20240326 as SYS_TEMP2
from
(
select
d1.LOC_ID
,d1.SPAT_ID
from 
oak_20160831_master.dbo.D_LOCATION_SPATIAL_HIST as d1
where
d1.LOC_ELEV_CODE=3
and d1.loc_coord_data_id= 526
---- Only load the SRTM elev if no MNR elev
--union
--select
--d2.LOC_ID
--,d2.SPAT_ID
--from 
--oak_20160831_master.dbo.D_LOCATION_SPATIAL_HIST as d2
--where
--d2.LOC_ELEV_CODE=5
--and d2.loc_coord_data_id=525
) as dlsh

insert into OAK_20160831_MASTER.dbo.D_LOCATION_SPATIAL
(
LOC_ID
,SPAT_ID
,DATA_ID
,SYS_TEMP1
,SYS_TEMP2
)
select 
dlsh.LOC_ID
,dlsh.SPAT_ID
,526 as DATA_ID
,'20240326c' as SYS_TEMP1
,20240326 as SYS_TEMP2
from
(
select
d1.LOC_ID
,d1.SPAT_ID
from 
oak_20160831_master.dbo.D_LOCATION_SPATIAL_HIST as d1
where
d1.LOC_ELEV_CODE=3
and d1.loc_coord_data_id= 526
---- Only load the SRTM elev if no MNR elev
--union
--select
--d2.LOC_ID
--,d2.SPAT_ID
--from 
--oak_20160831_master.dbo.D_LOCATION_SPATIAL_HIST as d2
--where
--d2.LOC_ELEV_CODE=5
--and d2.loc_coord_data_id=524
) as dlsh








