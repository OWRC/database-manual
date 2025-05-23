---
title:  "Appendix E"
author: "ormgpmd"
date:   "20250522"
output: html_document
knit:   (
            function(input_file, encoding) {
                out_dir <- '';
                rmarkdown::render(
                    input_file,
                    encoding=encoding,
                    output_file=file.path(dirname(input_file), out_dir,
                    'E_Database_Schema.html')
                )
            }
        )
---

## Appendix E - ORMGP Database Schema Update

### Introduction

A major schema update was drafted to convert the ORMGP database between
**Version 7** (dated version **20160831.20241206**) and **Version 8** (dated
version **20250207.20250520**).  This is outlined in the following three
sections:

* Common Fields and Changes in the New Database Schema
    + This provides an overview of the fields that are present throughout all
    the tables within the updated database schema
* Tables Present in the New Database Schema
    + This lists all tables present within the new databas schema and
    indicates the original source of the populated information
* Tables Present in the Old Database Schema
    + This lists all tables present in the previous database schema and
    indicates whether the table is to be dropped or where the records within
    the table end up in the new database schema

### Common Fields and Changes in the New Database Schema

For all reference (i.e. R_\*) tables:

* All \*_DESCRIPTION fields become \*_DESC
* All \*_DESCRIPTION_LONG fields become \*_DESC_LONG
* All \*_ALT_CODE fields become ALT_CODE; this will be present in each table
* All \*_ABBR fields become ABBR_DESC; this will be present in each table

For (almost) all tables, the following fileds will be present:

* COMMENT; note that this replaces the previous \*_COMMENT field in each table
* DATA_ID
* SYS_LAST_MODIFIED
* SYS_LAST_MODIFIED_BY
* SYS_TIME_STAMP
* SYS_USER_STAMP

### Tables Present in the New Database Schema

***R_ACCESS_CODE***

This replaces R_CONFIDENTIALITY_CODE.

* CONFIDENTIALITY_CODE is copied to ACCESS_CODE

***R_AREA_CODE***

This replaces D_AREA_GEOM.

***R_AREA_TYPE_CODE***

This is a new table.

***R_ATTR_CODE***

This table is copied.

***R_BH_STATUS_CODE***

This table is copied.

***R_CHECK_CODE***

This table is copied.

***R_CHECK_PROCESS_CODE***

This table is copied.

***R_CHECK_TYPE_CODE***

This table is copied.

***R_CON_TYPE_CODE***

This replaces R_CON_SUBTYPE_CODE and the the original R_CON_TYPE_CODE.  The
ALT_CODE field is populated by the original CON_TYPE_CODE.

* CON_SUBTYPE_CODE is copied to CON_TYPE_CODE

***R_COUNTY_CODE***

This replaces R_LOC_COUNTY_CODE.

* LOC_COUNTY_CODE is copied to COUNTY_CODE
* LOC_COUNTY_DESCRIPTION is copied to COUNTY_DESC

***R_DOC_AUTHOR_AGENCY_CODE***

This table is copied.

***R_DOC_CLIENT_AGENCY_CODE***

This table is copied.

***R_DOC_JOURNAL_CODE***

This table is copied.

***R_DOC_LOCATION_CODE***

This table is copied.

***R_DOC_TOPIC_CODE***

This table is copied.

***R_DOC_TYPE_CODE***

This table is copied.

***R_DRILLER_CODE***

This replaces R_BH_DRILLER_CODE.

* BH_DRILLER_CODE is copied to DRILLER_CODE
* BH_DRILLER_DESCRIPTION is copied to DRILLER_DESC
* BH_DRILLER_DESCRIPTION_LONG is copied to DRILLER_DESC_LONG

***R_DRILL_METHOD_CODE***

This replaces R_BH_DRILL_METHOD_CODE.

* BH_DRILL_METHOD_CODE is copied to DRILL_METHOD_CODE
* BH_DRILL_METHOD_DESCRIPTION is copied to DRILL_METHOD_DESC

***R_FORM_MODEL_CODE***

This table is copied.

* AREA_ID is copied to AREA_CODE

***R_GEOL_MAT_CODE***

This replaces all R_GEOL_MAT\*_CODE, R_GEOL_CONSISTENCY_CODE,
R_GEOL_MOISTURE_CODE, R_GEOL_ORGANIC_CODE and R_GEOL_TEXTURE_CODE tables.

* GEOL_MAT\*_CODE is copied to MAT_CODE
* GEOL_MAT\*_DESCRIPTION is copied to MAT_DESC
* GEOL_MAT\*_DESCRIPTION_LONG is copied to MAT_DESC_LONG
* GEOL_MAT1_ROCK is copied to MAT_ROCK

***R_GEOL_MATC_CODE***

This replaces R_GEOL_MAT_COLOUR_CODE.

* GEOL_MAT_COLOUR_CODE is copied to MATC_CODE
* GEOL_MAT_COLOUR_DESCRIPTION is copied to MATC_DESC

***R_GEOL_MATGSC_CODE***

This replaces R_GEOL_MAT_GSC_CODE.

* GEOL_MAT_GSC_CODE is copied to MATGSC_ORG
* GEOL_MAT_GSC_DESCRIPTION is copied to MATGSC_DESC

***R_GEOL_UNIT_CODE***

This table is copied.  All the MAT\*_CODE fields are disabled (the values no
longer match the existing material tables).

***R_GEOPHYS_LOG_TYPE_CODE***

This table is copied.

***R_GROUP_INT_CODE***

This table is copied.

* GROUP_INT_CODE is copied to SYS_TEMP2 (for linking purposes)

***R_GROUP_INT_TYPE_CODE***

This table is copied.

***R_GROUP_LOC_CODE***

This table is copied.

* GROUP_LOC_CODE is copied to SYS_TEMP2 (for linking purposes)

***R_GROUP_LOC_TYPE_CODE***

This table is copied.

***R_GROUP_OTH_CODE***

This table is copied.

***R_GROUP_OTH_TYPE_CODE***

This table is copied.

***R_GROUP_PICK_CODE***

This table is copied.

***R_GROUP_PICK_TYPE_CODE***

This is an added table and is copied.

***R_INT_ALIAS_TYPE_CODE***

This table is copied.

***R_INT_TYPE_CODE***

This table is copied.

***R_LOC_ALIAS_TYPE_CODE***

This table is copied.

***R_LOC_COORD_CODE***

This replaces R_LOC_COORD_HIST_CODE.

***R_LOC_ELEV_CODE***

This table is copied.

***R_LOC_TYPE_CODE***

This table is copied.

***R_OWN_TYPE_CODE***

This table is copied.

***R_PROJECT_CODE***

This is a new table and is copied.

* PROJECT_CODE is copied to PROJ_CODE
* PROJECT_DESCRIPTION is copied to PROJ_DESC
* PROJECT_DESCRIPTION_LONG is copied to PROJ_DESC_LONG

***R_PTTW_SRCID_CODE***

This replaces R_PTTW_SOURCEID_CODE.

* PTTW_SOURCEID_CODE is copied to PTTW_SRCID_CODE
* PTTW_SOURCEID_DESCRIPTION is copied to PTTW_SRCID_DESC
* PTTW_SOURCEID_DESCRIPTION_LONG is copied to PTTW_SRCID_DESC_LONG

***R_PTTW_WATERSRC_CODE***

This replaces R_PTTW_WATER_SOURCE_CODE.

* PTTW_WATER_SOURCE_CODE is copied to PTTW_WATERSRC_CODE
* PTTW_WATER_SOURCE_DESCRIPTION is copied to PTTW_WATERSRC_DESC

***R_PUMPTEST_METHOD_CODE***

This is copied.

* PUMPTEST_METHOD_CODE is copied to PT_METHOD_CODE
* PUMPTEST_METHOD_DESCRIPTION is copied to PT_METHOD_DESC

***R_PUMPTEST_TYPE_CODE***

This table is copied.

* PUMPTEST_TYPE_CODE is copied to PT_TYPE_CODE
* PUMPTEST_TYPE_DESCRIPTION is copied to PT_TYPE_DESC

***R_PURPOSE_PRI_CODE***

This replaces R_PURPOSE_PRIMARY_CODE.

* PURPOSE_PRIMARY_CODE is copied to PURPOSE_PRI_CODE
* PURPOSE_PRIMARY_DESCRIPTION is copied to PURPOSE_PRI_DESC
* PURPOSE_PRIMARY_DESCRIPTION_LONG is copied to PURPOSE_PRI_DESC_LONG

***R_PURPOSE_SEC_CODE***

This replaces R_PURPOSE_SECONDARY_CODE.

* PURPOSE_SECONDARY_CODE is copied to PURPOSE_SEC_CODE
* PURPOSE_SECONDARY_DESCRIPTION is copied to PURPOSE_SEC_DESC

***R_QA_COORD_CODE***

This replaces R_QA_COORD_CONFIDENCE_CODE.

* QA_COORD_CONFIDENCE_CODE is copied to QA_COORD_CODE

***R_QA_ELEV_CODE***

This replaces R_QA_ELEV_CONFIDENCE_CODE.

* QA_ELEV_CONFIDENCE_CODE is copied to QA_ELEV_CODE

***R_RD_GROUP_CODE***

This replaces R_READING_GROUP_CODE.

* READING_GROUP_CODE is copied to RD_GROUP_CODE
* READING_GROUP_NAME is copied to RD_GROUP_DESC
* READING_GROUP_NAME_LONG is copied to RD_GROUP_DESC_LONG

***R_RD_NAME_ALIAS***

This replaces R_READING_NAME_ALIAS.

* READING_NAME_ALIAS is copied to RD_NAME_ALIAS

***R_RD_NAME_CODE***

This table is copied.

* READING_GROUP_CODE is copied to RD_GROUP_CODE
* RD_NAME_CAS is copied to CAS_RN
* RD_NAME_DEFAULT_MDL is copied to DEF_MDL
* RD_NAME_DEFAULT_UNIT is copied to SYS_TEMP1
* RD_NAME_DEFAULT is copied to UNIT_CODE

***R_RD_TYPE_CODE***

This table is copied.

***R_REC_STATUS_CODE***

This table is copied.

***R_REL_TYPE_CODE***

This table is copied.

***R_SAM_TYPE_CODE***

This table is copied.

***R_STATUS_CODE***

This replaces R_LOC_STATUS_CODE.

* LOC_STATUS_CODE is copied to STATUS_CODE
* LOC_STATUS_DESCRIPTION is copied to STATUS_DESC
* LOC_STATUS_DESCRIPTION_LONG is copied to STATUS_DESC_LONG

***R_TOWNSHIP_CODE***

This replaces R_LOC_TOWNSHIP_CODE.

* LOC_TOWNSHIP_CODE is copied to TOWNSHIP_CODE
* LOC_COUNTY_CODE is copied to COUNTY_CODE
* LOC_TOWNSHIP_DESCRIPTION is copied to TOWNSHIP_DESC

***R_UNIT_ALIAS***

This is a new table and will be subsequently populated.

***R_UNIT_CODE***

This table is copied.

***R_WATER_CLARITY_CODE***

This table is copied.

***R_WQ_STANDARD***

This table is copied.

* DWS_ID is copied to DWS_CODE
* DWS_SOURCE_CODE is copied to DWS_SRC_CODE

***R_WQ_STANDARD_SOURCE***

This table is copied.

* DWS_SOURCE_CODE is copied to DWS_SRC_CODE
* DWS_SOURCE_DESC is copied to DWS_SRC_DESC
* DWS_SOURCE_DESC_LONG is copied to DWS_SRC_DES_LONG

***D_DATA_SOURCE***

This table is copied.

* DATA_ID is copied to SYS_TEMP2 (for linking purposes)

***D_GRP_INT***

This replaces D_GROUP_INTERVAL.

* GROUP_INT_CODE is copied to SYS_TEMP2 (for linking purposes)

***D_GRP_LOC***

This replaces D_GROUP_LOCATION.

* GROUP_LOC_CODE is copied to SYS_TEMP2 (for linking purposes)

***D_GRP_OTH***

This is a new table and is currently empty.

***D_INT***

This replaces D_INTERVAL.

* INT_ID is copied to SYS_TEMP2 (for linking purposes)
* INT_CONFIDENTIALITY_CODE is copied to ACCESS_CODE

***D_INT_ALIAS***

This replaces D_INTERVAL_ALIAS.  If INT_NAME_ALIAS is numeric (and an integer) 
then populate INT_NAME_ALIAS_ID with the converted value.

***D_INT_ATTR***

This replaces D_INTERVAL_ATTRIBUTE.  Additional data from D_INTERVAL_SOIL will
also be copied here.  Note that SYS_TEMP1 has a datetime that is being
captured in ATTR_DATE.

* ATT_ID is copied to SYS_TEMP2 (for linking purposes)
* ATTR_DEPTH_TOP_OUOM is copied to TOP_OUOM
* ATTR_DEPTH_BOT_OUOM is copied to BOT_OUOM
* ATTR_DEPTH_UNIT_OUOM is copied to TB_UNIT_OUOM
* ATT_DESCRIPTION is copied to COMMENT

The BLOW_COUNT field from D_INTERVAL_SOIL is also copied.

* SYS_RECORD_ID is copied to SYS_TEMP2 (for linking purposes)
* SOIL_BLOW_COUNT is copied to VALI

The MOISTURE field from D_INTERVAL_SOIL is also copied.

* SYS_RECORD_ID is copied to SYS_TEMP2
* SOIL_MOISTURE is copied to VALF

The RECOVERY field from D_INTERVAL_SOIL is also copied.

* SYS_RECORD_ID is copied to SYS_TEMP2
* SOIL_RECOVERY is copied to VALF

***D_INT_ATTR_RD***

This replaces D_INTERVAL_ATTRIBUTE_VALUES.

* SYS_RECORD_ID is copied to SYS_TEMP2 (for linking purposes)
* ATT_VALUE is copied to RD_VALUE
* ATT_NAME_OUOM is copied to RD_NAME_OUOM
* ATT_VALUE_OUOM is copied to RD_VALUE_OUOM
* ATT_UNIT_OUOM is copied to RD_UNIT_OUOM

***D_INT_DEPTH***

This replaces D_INTERVAL_MONITOR and D_INTERVAL_SOIL.

These fields are copied from D_INTERVAL_MONITOR.

* MON_ID is copied to SYS_TEMP2
* MON_TOP_DEPTH_M is copied to TOPD
* MON_BOT_DEPTH_M is copied to BOTD
* MON_TOP_OUOM is copied to TOP_OUOM
* MON_BOT_OUOM is copied to BOT_OUOM
* MON_SCREEN_MATERIAL is copied to SCR_MAT
* MON_SCREEN_SLOT is copied to SCR_SLOT
* MON_DIAMETER is copied to DIAM
* MON_DIAMETER_OUOM is copied to DIAM_OUOM
* MON_DIAMETER_UNIT_OUOM is copied to DIAM_UNIT_OUOM

These fields are copied from D_INTERVAL_SOIL.

* SYS_RECORD_ID is copied to SYS_TEMP2
* SOIL_TOP_M is copied to TOPD
* SOIL_BOT_M is copied to BOTD
* SOIL_TOP_OUOM is copied to TOP_OUOM
* SOIL_BOT_OUOM is copied to BOT_OUOM
* SOIL_UNIT_OUOM is copied to UNIT_OUOM

***D_INT_FORM_ASSIGN***

This replaces D_INTERVAL_FORM_ASSIGN.

* SYS_RECORD_ID is copied to SYS_TEMP2 (for linking purposes)

***D_INT_FORM_ASSIGN_FINAL***

This replaces D_INTERVAL_FORM_ASSIGN_FINAL.  In the new schema, the DIFA_ID
field references the ASSIGNED_UNIT in D_INT_FORM_ASSIGN (instead of
duplicating the value).

***D_INT_LOGGER_QC***

This field replaces D_LOGGER_QC.

* INT_ID is copied to SYS_TEMP2 (for linking purposes)

***D_INT_LOGGER_QC_DDS***

This replaces D_LOGGER_QC_DDS.

***D_INT_OFFSET***

This replaces D_INTERVAL_REF_ELEV.  Note that the SPAT_ID field is populated
from D_LOC_SPATIAL_HIST.

* SYS_RECORD_ID is copied to SYS_TEMP2 (for linking purposes)
* REF_ELEV_START_DATE is copied to START_DATE
* REF_ELEV_END_DATE is copied to END_DATE

***D_INT_PUMPTEST***

This replaces D_PUMPTEST.

* PUMP_TEST_ID is copied to SYS_TEMP2 (for linking purposes)
* PUMPTEST_DATE is copied to PT_DATE 
* PUMPTEST_NAME is copied to PT_NAME
* REC_PUMP_DEPTH_METERS is copied to REC_PUMP_DEPTH_M
* PUMPTEST_METHOD_CODE is copied to PT_METHOD_CODE
* PUMPTEST_TYPE_CODE is copied to PT_TYPE_CODE

***D_INT_PUMPTEST_STEP***

This replaces D_PUMPTEST_STEP.  Note that PT_ID is from the populated
D_INT_PUMPTEST table.

* SYS_RECORD_ID is copied to SYS_TEMP2 (for linking purposes)

***D_INT_SUMMARY***

This table is to be (automatically) populated.

***D_INT_TEMPORAL_1A***

This replaces D_INTERVAL_TEMPORAL_1A.  When correcting for any SAM_ID groups
linked through the SYS_ANALYSIS_ID, the lowest SAM_ID value is chosen.

* SAM_ID is copied to SYS_TEMP2
* SAM_SAMPLE_NAME is copied to SAM_NAME
* SAM_SAMPLE_DATE is copied to SAM_DATE
* SAN_ANALYSIS_DATE is copied to LAB_ANALYSIS_DATE
* SAM_LAB_SAMPLE_ID is copied to LAB_SAMPLE_ID
* SAM_LAB_JOB_NUMBER is copied to LAB_JOB_NUMBER
* SAM_INTERNAL_ID is copied to COMMENT_LONG
* SAM_SAMPLE_NAME_OUOM is copied to COMMENT_LONG
* SAM_DATA_FILE is copied to COMMENT_LONG

***D_INT_TEMPORAL_1B***

This replaces D_INTERVAL_TEMPORAL_1B.  When correcting for SAM_ID groups
linked through the SYS_ANALYSIS_ID, the lowest SAM_ID value is chosen.

* SYS_RECORD_ID is copied to SYS_TEMP2 (for linking purposes)

***D_INT_TEMPORAL_2***

This replaces D_INTERVAL_TEMPORAL_2.

* SYS_RECORD_ID is copied to SYS_TEMP2 (for linking purposes)

***D_INT_TEMPORAL_3***

This replaces D_INTERVAL_TEMPORAL_3.

* SYS_RECORD_ID is copied to SYS_TEMP2 (for linking purposes)

***D_LOC***

This replaces D_LOCATION.

* LOC_ID is copied to SYS_TEMP2 (for linking purposes)
* LOC_ORIGINAL_NAME is copied to LOC_NAME_ORG
* LOC_STATUS_CODE is copied to STATUS_CODE 
* LOC_CONFIDENTIALITY_CODE is copied to ACCESS_CODE 

***D_LOC_ADDRESS***

A new table, this contains fields originally from D_LOCATION.

* LOC_ADDRESS_CODE is copied to LOC_ADDRESS_PCODE
* LOC_CONTACT_PHONE_NUM is copied to LOC_CONTACT_PHONE
* LOC_CONTACT_NAME_FIRST is copied to LOC_CONTACT_NAME
* LOC_CONTACT_NAME_LAST is copied to LOC_CONTACT_NAME

***D_LOC_ALIAS***

This replaces D_LOCATION_ALIAS.  If LOC_NAME_ALIAS is numeric (and an integer)
it is converted and copied to LOC_NAME_ALIAS_ID

***D_LOC_AREA***

This is a new table and replaces the use of the \*_AREA_ID fields in
D_LOCATION_SUMMARY.  This table is to be automatically populated.

***D_LOC_ATTR***

This replaces D_LOCATION_ATTR and includes data from D_LOCATION,
D_GEOLOGY_FEATURE, D_LOCATION_VULNERABILITY and D_DOCUMENT.  Note that text
fields are being pulled from R_LOC_WATERSHED1_CODE and R_LOC_WATERSHED2_CODE
for the LOC_WATERSHED\* fields in D_LOCATION.

* VAL_UNIT_CODE is copied to UNIT_CODE
* VAL_DEF_UNIT_OUOM is copied to UNIT_OUOM

The LOC_WATERSHED\* fields (and matching text) is copied from D_LOCATION.

* LOC_ID is copied to SYS_TEMP2 (for linking purposes)
* LOC_WATERSHED1_CODE is copied to VALI
* LOC_WATERSHED2_CODE is copied to VALI2
* LOC_WATERSHED1_NAME is copied to VAL_DEF
* LOC_WATERSHED2_NAME is copied to VAL_DEF2

The LOC_COMMENT_LONG field is copied from D_LOCATION.

* LOC_ID is copied to SYS_TEMP2 (for linking purposes)
* LOC_COMMENT_LONG is copied to ATTR_DESC_LONG

The DOC_KEYWORD\* fields (collapsed to a single text string) are copied from
D_DOCUMENT.

* LOC_ID is copied to SYS_TEMP2 (for linking purposes)
* KEYWORDS is copied to ATTR_DESC_LONG

Fields are copied from D_GEOLOGY_FEATURE.

* FEATURE_ID is copied to SYS_TEMP2 (for linking purposes)
* FEATURE_DESCRIPTION is copied to ATTR_DESC
* FEATURE_TOP_OUOM is copied to TOP_OUOM
* FEATURE_BOT_OUOM is copied to BOT_OUOM
* FEATURE_UNIT_OUOM is copied to TB_UNIT_OUOM

Fields are copied from D_LOCATION_VULNERABILITY.

* SYS_RECORD_ID is copied to SYS_TEMP2 (for linking purposes)
* QUAT_GEOL is copied to VALF
* AVI_FEB2003_FINAL is copied to VALI

The DOC_YN_\* fields are copied from D_DOCUMENT.

* DOC_YN_* is copied to VALI
* DOC_YN_ENTERED_* is copied to VALI2

***D_LOC_ATTR_RD***

This replaces D_LOCATION_ATTRIBUTE_VALUE.

***D_LOC_BOREHOLE***

This replaces D_BOREHOLE.

* BH_BOTTOM_DEPTH is copied to BOTD
* BH_BOTTOM_OUOM is copied to BOT_OUOM
* BH_BOTTOM_UNIT_OUOM is copied to UNIT_OUOM
* BH_BEDROCK_ELEV is copied to BEDROCK (the depth is calculated)
* BH_DRILL_METHOD_CODE is copied to DRILL_METHOD_CODE
* BH_DRILLER_CODE is copied to DRILLER_CODE
* BH_LOGGED_PERSON is copied to LOGGED_BY
* BH_CHECK_PERSON is copied to CHECKED_BY
* BH_DRILL_START_DATE is copied to DRILL_START_DATE
* BH_DRILL_END_DATE is copied to DRILL_END_DATE
* BH_DIAMETER is copied to DIAM
* BH_DIAMETER_OUOM is copied to DIAM_OUOM
* BH_DIAMETER_UNIT_OUOM is copied to DIAM_UNIT_OUOM
* BH_DIP is copied to DIP
* BH_AZIMUTH is copied to AZIMUTH
* BH_COMMENT is copied to DRILL_COMMENT

***D_LOC_BOREHOLE_CONS***

This replaces D_BOREHOLE_CONSTRUCTION.

* BH_ID is copied to SYS_TEMP2 (for linking purposes)
* CON_SUBTYPE_CODE is copied to CON_TYPE_CODE
* CON_TOP_OUOM is copied to TOP_OUOM
* CON_BOT_OUOM is copied to BOT_OUOM
* CON_UNIT_OUOM is copied to UNIT_OUOM
* CON_DIAMETER is copied to DIAM
* CON_DIAMETER_OUOM is copied to DIAM_OUOM
* CON_DIAMETER_UNIT_OUOM is copied to DIAM_UNIT_OUOM

***D_LOC_DOCUMENT***

This replaces D_DOCUMENT.  Almost all DOC_YN_\* and DOC_KEYWORD\* have been
moved to D_LOC_ATTR. 

* DOC_ID is copied to SYS_TEMP2 (for linking purposes)
* DOC_FOLDER_ID is copied to DFID
* DOC_AUTHOR_AGENCY_CODE is copied to DOC_AUTHOR_AGENCY1_CODE
* DOC_CLIENT_AGENCY_CODE is copied to DOC_CLIENT_AGENCY1_CODE
* DOC_TOPIC_CODE is copied to DOC_TOPIC1_CODE
* DOC_DOCUMENT_NUMBER is copied to DOC_ORG_NUMBER
* DOC_PROJECT_NUMBER is copied to DOC_ORG_PROJECT
* DOC_YN_DRAFT is copied to DOC_DRAFT
* DOC_YN_PARTIAL is copied to DOC_PARTIAL

***D_LOC_GEOL_LAYER***

This replaces D_GEOLOGY_LAYER.

* GEOL_ID is copied to SYS_TEMP2
* GEOL_TOP_OUOM is copied to TOP_OUOM
* GEOL_BOT_OUOM is copied to BOT_OUOM
* GEOL_UNIT_OUOM is copied to UNIT_OUOM
* GEOL_MAT_COLOUR_CODE is copied to MATC_CODE
* GEOL_MAT1_CODE is copied to MAT1_CODE
* GEOL_MAT2_CODE is copied to MAT2_CODE
* GEOL_MAT3_CODE is copied to MAT3_CODE
* GEOL_MAT4_CODE is copied to MAT4_CODE
* GEOL_DESCRIPTION is copied to GEOL_DESC
* MAP_UNIT_NUMBER is copied to MATGSC_UNIT
* GEOL_UNIT_CODE is copied to GEOL_ORIGINAL_UNIT  
* GEOL_SUBCLASS_CODE is copied to REC_STATUS_CODE
* GEOL_CONSISTENCY_CODE is copied to MATD_CODE
* GEOL_MOISTURE_CODE is copied to MATM_CODE
* GEOL_TEXTURE_CODE is copied to MATT_CODE
* GEOL_ORGANIC_CODE is copied to MATO_CODE
* GEOL_MAT_GSC_CODE is copied to MATGSC_CODE

***D_LOC_GEOPHYS_LOG_DATA***

This replaces D_LOCATION_GEOPHYS_LOG_DATA (a new table).

***D_LOC_GEOPHYS_LOG_DETAILS***

This replaces D_LOCATION_GEOPHYS_LOG_DETAILS (a new table).

***D_LOC_GEOPHYS_LOG_TYPE***

This replaces D_LOCATION_GEOPHYS_LOG_TYPE (a new table).

***D_LOC_PICK***

This replaces D_PICK.

* SYS_RECORD_ID is copied to SYS_TEMP2 (for linking purposes)
* TOP_ELEV is copied to TOPD (this is calculated)
* FORMATION is copied to COMMENT

***D_LOC_PROJECT***

A new table that is to be populated.

***D_LOC_PTTW***

This replaces D_PTTW.

* PTTW_PERMIT_NUMBER is copied to PTTW_PERMIT
* PTTW_SOURCEID_CODE is copied to PTTW_SRCID_CODE
* PTTW_SOURCEID_OUOM is copied to PTTW_SRCID_OUOM
* PTTW_WATER_SOURCE_CODE is copied to PTTW_WATERSRC_CODE

***D_LOC_PURPOSE***

This replaces D_LOCATION_PURPOSE.  Note that the original content is being
moved to D_LOC_PURPOSE_HIST and the current purpose set is referenced herein.

***D_LOC_PURPOSE_HIST***

This replaces D_LOCATION_PURPOSE.

* SYS_RECORD_ID is copied to SYS_TEMP2 (for linking purposes)
* PURPOSE_PRIMARY_CODE is copied to PURPOSE_PRI_CODE
* PURPOSE_SECONDARY_CODE is copied to PURPOSE_SEC_CODE

***D_LOC_QC***

This replaces D_LOCATION_QC and is copied.

***D_LOC_RELATED***

This replaces D_LOCATION_RELATED, D_DOCUMENT_ASSOCIATION and
D_PTTW_RELATED_SRC.  Note that this also replaces the use of
LOC_MASTER_LOC_ID.

***D_LOC_SPATIAL***

This replaces D_LOCATION_SPATIAL.

***D_LOC_SPATIAL_HIST***

This replaces D_LOCATION_SPATIAL_HIST.

* LOC_COORD_HIST_CODE is copied to LOC_COORD_CODE

***D_LOC_SUMMARY***

This table is to be (automatically) populated.

***D_GROUP_INTERVAL***

This table is copied.

***D_GRP_LOC***

This replaces D_GROUP_LOCATION and is copied.

***D_GRP_OTH***

This is a new table and is currently empty.

***D_OWNER***

This table is copied.

***D_PICK_EXTERNAL***

This table is copied.

* FORMATION is copied to GEOL_COMMENT
* PICK_COMMENT is copied to COMMENT

***D_VERSION***

This replaces D_VERSION_CURRENT.

***D_VERSION_HIST***

This replaces D_VERSION_CURRENT_HIST.

***D_VERSION_STATUS***

This table is copied.

* READING_GROUP_CODE is copied to RD_GROUP_CODE
* READING_GROUP_NAME is copied to RD_GROUP_NAME

***S_CONSTANT***

This table is copied.

***S_DESC_FIELD***

Currently not populated.

***S_DESC_TABLE***

This table is copied.

***S_DESC_VIEW***

This table is copied.

***W_GEN***

This replaces W_GENERAL and will be automatically populated.

***W_GEN_DOCUMENT***

This replaces W_GENERAL_DOCUMENT and will be automatically populated.

***W_GEN_GEOL_LAYER***

This replaces W_GEOLOGY_LAYER and will be automatically populated.

***W_GEN_GROUP***

This replaces W_GENERAL_GROUP and will be automatically populated.

***W_GEN_GW_LEVEL***

This replaces W_GENERAL_GW_LEVEL and will be automatically populated.

***W_GEN_LOC_MET***

This replaces W_GENERAL_LOC_MET and will be automatically populated.

***W_GEN_LOC_SW***

This replaces W_GENERAL_LOC_SW and will be automatically populated.

***W_GEN_OTHER***

This replaces W_GENERAL_OTHER and will be automatcially populated.

***W_GEN_PICK***

This replaces W_GENERAL_PICK and will be automatically populated.

***W_GEN_SCREEN***

This replaces W_GENERAL_SCREEN and will be automatically populated.

### Tables Present in the Old Database Schema

***D_AREA_GEOM***

Moved to R_AREA_CODE.

***D_BOREHOLE***

Moved to D_LOC_BOREHOLE.

***D_BOREHOLE_CONSTRUCTION***

Moved to D_LOC_BOREHOLE_CONS.

***D_CLIMATE*** 

Dropped.

***D_CRITERIA*** 

Dropped.

***D_DATA_INFO*** 

Dropped.

***D_DATA_SOURCE*** 

Copied.

***D_DATABASE_NOTE***

Dropped.

***D_DOCUMENT***

Moved to D_LOC_DOCUMENT.  The DOC_YN\* and DOC_KEYWORD\* fields are moved
D_LOC_ATTR.

***D_DOCUMENT_ASSOCIATION***

Moved to D_LOC_RELATED.

***D_DOCUMENT_ASSOCIATION_INTERVAL***

Dropped.

***D_GEOLOGY_FEATURE***

Moved to D_LOC_ATTR.

***D_GEOLOGY_LAYER***

Moved to D_LOC_GEOL_LAYER.

***D_GEOPHYSICAL_LOG_DATABIN***

An empty table.  Capability moved to D_LOG_GEOPHYS_DATA.

***D_GEOPHYSICAL_LOG_FIELD_DETAILS***

An empty table.  Capability moved to D_LOG_GEOPHYS_DETAILS.

***D_GEOPHYSICAL_LOG_LITHO_DESCRIPTIONS***

Dropped.

***D_GEOPHYSICAL_LOG_LOCATION_DETAILS***

An empty table.  Capability moved to D_LOG_GEOPHYS_TYPE.

***D_GROUP_INTERVAL***

Moved to D_GRP_INT.

***D_GROUP_LOCATION***

Moved to D_GRP_LOC.

***D_GROUP_READING***

Dropped.  Capability moved to D_GRP_OTH.

***D_INTERVAL***

Moved to D_INT.

***D_INTERVAL_ADVERSE_EVENT*** 

Dropped.

***D_INTERVAL_ALIAS***

Moved to D_INT_ALIAS.

***D_INTERVAL_ATTR***

Dropped.

***D_INTERVAL_ATTRIBUTE***

Moved to D_INT_ATTR.

***D_INTERVAL_ATTRIBUTE_LOOKUP*** 

Dropped.

***D_INTERVAL_ATTRIBUTE_VALUE**

Moved to D_INT_ATTR_RD.

***D_INTERVAL_FORM_ASSIGN***

Moved to D_INT_FORM_ASSIGN.

***D_INTERVAL_FORM_ASSIGN_FINAL***

Moved to D_INT_FORM_ASSIGN_FINAL.

***D_INTERVAL_INFO**

Dropped.

***D_INTERVAL_INFO_DETAIL***

Dropped.

***D_INTERVAL_MONITOR***

Moved to D_INT_DEPTH.

***D_INTERVAL_PROPERTY***

Dropped.

***D_INTERVAL_QC_DATA***

New table to be reviewed.

***D_INTERVAL_REF_ELEV***

Moved to D_INT_OFFSET.

***D_INTERVAL_SOIL***

Moved to D_INT_DEPTH.

***D_INTERVAL_SUMMARY***

Moved to D_INT_SUMMARY.

***D_INTERVAL_TEMPORAL_1A***

Moved to D_INT_TEMPORAL_1A.

***D_INTERVAL_TEMPORAL_1B***

Moved to D_INT_TEMPORAL_1B.

***D_INTERVAL_TEMPORAL_2***

Moved to D_INT_TEMPORAL_2.

***D_INTERVAL_TEMPORAL_3***

Moved to D_INT_TEMPORAL_3.

***D_INTERVAL_TEMPORAL_4***

Dropped.

***D_INTERVAL_TEMPORAL_5***

Dropped.

***D_LOCATION***

Moved to D_LOC and D_LOC_ADDRESS.

***D_LOCATION_ACTIVITY***

To be dropped.  Note that there is some detail here that may or may-not be
useful.  The contents (if kept) could be moved to D_LOC_QC.

***D_LOCATION_ALIAS***

Moved to D_LOC_ALIAS.

***D_LOCATION_ATTR***

Moved to D_LOC_ATTR.

***D_LOCATION_ATTRIBUTE***

Dropped (currenty empty).  Capability moved to D_LOC_ATTR.

***D_LOCATION_ATTRIBUTE_LOOKUP***

Dropped.

***D_LOCATION_ATTRIBUTE_VALUE***

Dropped (currently empty).  Capability moved to D_LOC_ATTR_RD.

***D_LOCATION_DEPTH_DATA***

Dropped (currently empty).  Capability moved to D_LOC_ATTR and D_LOC_ATTR_RD.

**D_LOCATION_GEOM***

Dropped.  Capability moved to D_LOC_SPATIAL_HIST.

***D_LOCATION_GEOPHYS_LOG_DATA***

Moved to D_LOC_GEOPHYS_LOG_DATA.

***D_LOCATION_GEOPHYS_LOG_DETAILS***

Moved to D_LOC_GEOPHYS_LOG_DETAILS.

***D_LOCATION_GEOPHYS_LOG_TYPE***

Moved to D_LOC_GEOPHYS_LOG_TYPE.

***D_LOCATION_INFO***

Dropped.

***D_LOCATION_INFO_DETAIL***

Dropped

***D_LOCATION_PURPOSE***

Moved to D_LOC_PURPOSE and D_LOC_PURPOSE_HIST.

***D_LOCATION_QA***

Dropped.  Capability moved to D_LOC_SPATIAL_HIST.

***D_LOCATION_QC***

Moved to D_LOC_QC.

***D_LOCATION_RELATED***

Moved to D_LOC_RELATED.

***D_LOCATION_SPATIAL***

Moved to D_LOC_SPATIAL.

***D_LOCATION_SPATIAL_HIST***

Moved to D_LOC_SPATIAL_HIST.

***D_LOCATION_SUMMARY***

Moved to D_LOC_SUMMARY.  

***D_LOCATION_VULNERABILITY***

To be dropped.  The detail here is copied to D_LOC_ATTR.

***D_LOGGER_BARO_COMPENSATION***

Dropped.

***D_LOGGER_CALIBRATION***

Dropped.

***D_LOGGER_CALIBRATION_READINGS***

Dropped.

***D_LOGGER_CORRECTION***

Dropped.

***D_LOGGER_INSTALLATION***

Dropped.

***D_LOGGER_INVENTORY***

Dropped.

***D_LOGGER_INVENTORY_MODULE***

Dropped.

***D_LOGGER_INVENTORY_MODULE_ATTRIBUTE***

Dropped.

***D_LOGGER_INVENTORY_SENSOR***

Dropped.

***D_LOGGER_INVENTORY_SIM***

Dropped.

***D_LOGGER_NAME***

Dropped.

***D_LOGGER_QC***

Moved to D_INT_LOGGER_QC.

***D_LOGGER_QC_DDS***

Moved to D_INT_LOGGER_QC_DDS.

***D_OWNER***

Copied.

***D_PICK***

Moved to D_LOC_PICK.

***D_PICK_EXTERNAL***

Copied.

***D_PROJECT_LOCATION***

Dropped.

***D_PROJECT_USER_GROUP*** 

Dropped.

***D_PTTW***

Moved to D_LOC_PTTW.

***D_PTTW_RELATED***

Dropped.  This capability can be calculated on-the-fly using a view.

***D_PTTW_RELATED_SRC***

Moved to D_LOC_RELATED.

***D_PUMPTEST***

Moved to D_INT_PUMPTEST.

***D_PUMPTEST_STEP***

Moved to D_INT_PUMPTEST_STEP.

***D_SITE***

Dropped.

***D_SURFACEWATER***

Dropped.

***D_USER_GROUP***

Dropped.

***D_VERSION***

Dropped.

***D_VERSION_CURRENT***

Moved to D_VERSION.

***D_VERSION_CURRENT_HIST***

Moved to D_VERSION_HIST.

***D_VERSION_STATUS***

Copied.

***R_ACTIVITY_CODE***

Dropped.

***R_ADVERSE_COMMENT_CODE***

Dropped.

***R_ADVERSE_TYPE_CODE***

Dropped.

***R_ATTR_CODE***

Copied.

***R_BH_DRILL_METHOD_CODE***

Moved to R_DRILL_METHOD_CODE.

***R_BH_DRILLER_CODE***

Moved to R_DRILLER_CODE.

***R_BH_STATUS_CODE***

Copied.

***R_CHECK_CODE***

Copied.

***R_CHECK_PROCESS_CODE***

Copied.

***R_CHECK_TYPE_CODE***

Copied.

***R_CON_SUBTYPE_CODE***

Moved to R_CON_TYPE_CODE.

***R_CON_TYPE_CODE***

Moved to R_CON_TYPE_CODE (ALT_CODE).

***R_CONFIDENTIALITY_CODE***

Moved to R_ACCESS_CODE.

***R_CONFIGURATION_CODE***

Dropped.

***R_CONV_CLASS_CODE***

Dropped.

***R_CRIT_GROUP_CODE***

Dropped.

***R_CRIT_TYPE_CODE***

Dropped.

***R_DOC_AUTHOR_AGENCY_CODE***

Copied.

***R_DOC_CLIENT_AGENCY_CODE***

Copied.

***R_DOC_FORMAT_CODE***

Dropped.

***R_DOC_JOURNAL_CODE***

Copied.

***R_DOC_LANGUAGE_CODE***

Dropped.

***R_DOC_LOCATION_CODE***

Copied.

***R_DOC_TOPIC_CODE***

Copied.

***R_DOC_TYPE_CODE***

Copied.

***R_EQ_GROUP_CODE***

Dropped.

***R_EQ_TYPE_CODE***

Dropped.

***R_FEATURE_CODE***

Dropped.  Capability moved to R_ATTR_CODE.

***R_FORM_MODEL_CODE***

Copied.

***R_GEOL_CLASS_CODE***

Dropped.

***R_GEOL_CONSISTENCY_CODE***

Dropped. Capability moved to R_GEOL_MAT_CODE.

***R_GEOL_LAYERTYPE_CODE***

Dropped.  Text descriptions moved to GEOL_DESCRIPTION.

***R_GEOL_MAT1_CODE***

Moved to R_GEOL_MAT_CODE.

***R_GEOL_MAT2_CODE***

Consolidated with R_GEOL_MAT_CODE.

***R_GEOL_MAT3_CODE***

Consolidated with R_GEOL_MAT_CODE.

***R_GEOL_MAT4_CODE***

Consolidated with R_GEOL_MAT_CODE.

***R_GEOL_MAT_COLOUR_CODE***

Moved to R_GEOL_MATC_CODE.

***R_GEOL_MAT_GSC_CODE***

Moved to R_GEOL_MATGSC_CODE.

***R_GEOL_MOISTURE_CODE***

Moved to R_GEOL_MAT_CODE.

***R_GEOL_ORGANIC_CODE***

Moved to R_GEOL_MAT_CODE.

***R_GEOL_SUBCLASS_CODE***

Moved to R_REC_STATUS_CODE.

***R_GEOL_TEXTURE_CODE***

Moved to R_GEOL_MAT_CODE.

***R_GEOL_UNIT_CODE***

Copied.

***R_GEOPHYS_LOG_TYPE_CODE***

Copied.

***R_GROUP_INT_CODE***

Moved to R_GRP_INT_CODE.

***R_GROUP_INT_TYPE_CODE***

Moved to R_GRP_INT_TYPE_CODE.

***R_GROUP_LOC_CODE***

Moved to R_GRP_LOC_CODE.

***R_GROUP_LOC_TYPE_CODE***

Moved to R_GRP_LOC_TYPE_CODE.

***R_GROUP_PICK_CODE***

Moved to R_GRP_PICK_CODE.

***R_GROUP_READING_CODE***

Dropped.  Capability moved to R_GRP_OTH_CODE.

***R_GROUP_READING_TYPE_CODE***

Dropped.  Capability moved to R_GRP_OTH_TYPE_CODE.

***R_INT_ALIAS_TYPE_CODE***

Copied.

***R_INT_REGULATORY_CODE***

Dropped.

***R_INT_SAMPLE_MATRIX_DESC***

Dropped.

***R_INT_SAMPLE_TYPE_DESC***

Dropped.

***R_INT_SAMPLE_USER_FILTER_DESC***

Dropped.

***R_INT_TYPE_CODE***

Copied.

***R_LI_BATTERY_CODE***

Dropped.

***R_LMD_STATUS_CODE***

Dropped.

***R_LMD_TYPE_CODE***

Dropped.

***R_LMD_TYPE_CODE_ATTRIBUTE***

Dropped.

***R_LOC_ALIAS_TYPE_CODE***

Copied.

***R_LOC_COORD_CODE***

Dropped.

***R_LOC_COORD_HIST_CODE***

Moved to R_LOC_COORD_CODE.

***R_LOC_COORD_OUOM_ALIAS***

Dropped.

***R_LOC_COORD_OUOM_CODE***

Dropped.  Capability captured in D_LOC_SPATIAL_HIST.

***R_LOC_CORR_WATER_CODE***

Dropped.

***R_LOC_COUNTY_CODE***

Moved to R_COUNTY_CODE.

***R_LOC_DATA_SOURCE_CODE***

Moved to R_DATA_SRC_CODE.

***R_LOC_ELEV_CODE***

Copied.

***R_LOC_INFO_CODE***

Dropped.

***R_LOC_INFO_GROUP_CODE***

Dropped.

***R_LOC_INFO_TYPE_CODE***

Dropped.

***R_LOC_MOE_USE_PRIMARY_CODE***

Dropped.  Moved to D_LOC_PURPOSE_HIST.

***R_LOC_MOE_USE_SECONDARY_CODE***

Dropped.  Moved to D_LOC_PURPOSE_HIST.

***R_LOC_STATUS_CODE***

Moved to R_STATUS_CODE.

***R_LOC_TIER1_CODE***

Dropped.

***R_LOC_TIER2_CODE***

Dropped.

***R_LOC_TIER3_CODE***

Dropped.

***R_LOC_TOWNSHIP_CODE***

Moved to R_TOWNSHIP_CODE.

***R_LOC_TYPE_CODE***

Copied.

***R_LOC_WATERSHED1_CODE***

Dropped. Capability moved to D_LOC_ATTR.

***R_LOC_WATERSHED2_CODE***

Dropped. Capability moved to D_LOC_ATTR.

***R_LOC_WATERSHED3_CODE***

Dropped.

***R_LOGGER_TYPE_CODE***

Dropped.

***R_LOGGER_TYPE_READING***

Dropped.

***R_LSR_TYPE_CODE***

Dropped.

***R_LSR_TYPE_READING***

Dropped.

***R_OWN_TYPE_CODE***

Copied.

***R_PROJECT_AGENCY_CODE***

Dropped.

***R_PROJECT_CODE***

Copied.

***R_PROJECT_TIER1_CODE***

Dropped.

***R_PROJECT_TIER2_CODE***

Dropped.

***R_PROJECT_TYPE_CODE***

Dropped.

***R_PTTW_SOURCEID_CODE***

Moved to R_PTTW_SRCID_CODE.

***R_PTTW_WATER_SOURCE_CODE***

Moved to R_PTTW_WATERSRC_CODE.

***R_PUMPTEST_METHOD_CODE***

Copied.

***R_PUMPTEST_TYPE_CODE***

Copied.

***R_PURPOSE_PRIMARY_CODE***

Moved to R_PURPOSE_PRI_CODE.

***R_PURPOSE_SECONDARY_CODE***

Moved to R_PURPOSE_SEC_CODE.

***R_QA_COORD_CONFIDENCE_CODE***

Moved to R_QA_COORD_CODE.

***R_QA_ELEV_CONFIDENCE_CODE***

Moved to R_QA_ELEV_CODE.

***R_RD_FILTER_CODE***

Dropped.

***R_RD_LOOKUP_CODE***

Dropped.

***R_RD_NAME_CODE***

Copied.

***R_RD_NAME_GROUPS***

Dropped.  Capability moved to R_GRP_OTHER.

***R_RD_NAME_LOOKUP***

Dropped.

***R_RD_TYPE_CODE***

Copied.

***R_READING_GROUP_CODE***

Moved to R_RD_GROUP_CODE.

***R_READING_NAME_ALIAS***

Moved to R_RD_NAME_ALIAS.

***R_REC_STATUS_CODE***

Copied.

***R_REL_TYPE_CODE***

Copied.

***R_SAM_TYPE_CODE***

Copied.

***R_SAM_TYPE_KEYWORD***

Dropped.

***R_SW_SUBTYPE_CODE***

Dropped.

***R_SYS_GROUP_SEARCH_CODE***

Not handled currently and should be examined.

***R_SYS_GROUP_TYPE_CODE***

Dropped.

***R_SYS_INT_DETAIL_CODE***

Dropped.

***R_SYS_REF_TYPE_CODE***

Dropped.

***R_SYS_VALUE_QUALIFIER***

Dropped.

***R_UNIT_CODE***

Copied.

***R_UNIT_CONV***

Dropped.

***R_USER_CODE***

Dropped.

***R_USER_GROUP_CODE***

Dropped.

***R_USER_GROUP_TYPE_CODE***

Dropped.

***R_WATER_CLARITY_CODE***

Copied.

***R_WQ_STANDARD***

Copied.

***R_WQ_STANDARD_SOURCE***

Copied.

***S_ARCHIVE***

Dropped.

***S_CHANGE_HISTORY***

Dropped.

***S_CONSTANT***

Copied.

***S_DATA_SEARCH_INTERVALS***

Dropped.

***S_DESC_FIELD***

Empty.

***S_DESC_TABLE***

Copied.

***S_DESC_VIEW***

Copied.

***S_GLOBALSAVED_SITEANALYSISGROUP***

Dropped.

***S_GLOBALSAVED_SITEANALYSISHEADER***

Dropped.

***S_GROUP_SEARCH***

Dropped.

***S_IMPORT_MAPPINGS***

Dropped.

***S_SAM_D_Analysis***

Dropped.

***S_SAM_D_Analysis_Group***

Dropped.

***S_SAM_D_Field_Identifier***

Dropped.

***S_SAM_D_Reconcile_Details***

Dropped.

***S_SAM_D_Reconcile_Details_Manual***

Dropped.

***S_SAM_D_Sam_Chain***

Dropped.

***S_SAM_D_Sam_Chain_Details***

Dropped.

***S_SAM_D_Sample***

Dropped.

***S_SAM_D_SampleFieldData***

Dropped.

***S_SAM_D_SampleProgramNotes***

Dropped.

***S_SAM_R_Analysis***

Dropped.

***S_SAM_R_Analysis_Bottle***

Dropped.

***S_SAM_R_Analysis_Group***

Dropped.

***S_SAM_R_Bottle***

Dropped.

***S_SAM_R_Chain_Number***

Dropped.

***S_SAM_R_Lab***

Dropped.

***S_SAM_R_ParaAnalysisGroup***

Dropped.

***S_SAM_R_ProjectNumber***

Dropped.

***S_SAM_R_SamplingGroupIntervals***

Dropped.

***S_SAM_R_SamplingGroups***

Dropped.

***S_SAM_R_SamplingGroupsFreq***

Dropped.

***S_SAM_R_SamplingIntervalFreq***

Dropped.

***S_SAM_R_Staff***

Dropped.

***S_SiteDataSummaryCache***

Dropped.

***S_SiteDataSummaryCacheInterval***

Dropped.

***S_SPEED_TEST***

Dropped.

***S_USER***

Dropped.

***S_USER_SETDB***

Dropped.

***W_GENERAL***

Moved to W_GEN.

***W_GENERAL_DOCUMENT***

Moved to W_GEN_DOCUMENT.

***W_GENERAL_GROUP***

Moved to W_GEN_GROUP.

***W_GENERAL_GW_LEVEL***

Moved to W_GEN_GW_LEVEL.

***W_GENERAL_LOC_MET***

Moved to W_GEN_LOC_MET.

***W_GENERAL_LOC_SW***

Moved to W_GEN_LOC_SW.

***W_GENERAL_OTHER***

Moved to W_GEN_OTHER.

***W_GENERAL_PICK***

Moved to W_GEN_PICK.

***W_GENERAL_SCREEN***

Moved to W_GEN_SCREEN.

***W_GEOLOGY_LAYER***

Moved to W_GEN_GEOL_LAYER.

*Last Modified: 2025-05-22*
