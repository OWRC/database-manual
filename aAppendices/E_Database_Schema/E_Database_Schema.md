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

#### Introduction

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

#### Common Fields and Changes in the New Database Schema

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

#### Tables Present in the New Database Schema

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

* GEOL_MAT\*_CODE -> MAT_CODE
* GEOL_MAT\*_DESCRIPTION -> MAT_DESC
* GEOL_MAT\*_DESCRIPTION_LONG -> MAT_DESC_LONG
* GEOL_MAT1_ROCK -> MAT_ROCK

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

* DATA_ID -> SYS_TEMP2 (for linking purposes)

***D_GRP_INT***

This replaces D_GROUP_INTERVAL.

* GROUP_INT_CODE -> SYS_TEMP2 (for linking purposes)

***D_GRP_LOC***

This replaces D_GROUP_LOCATION.

* GROUP_LOC_CODE is copied to SYS_TEMP2 (for linking purposes)

***D_GRP_OTH***

This is a new table and is currently empty.

***D_INT***

This replaces D_INTERVAL.

* INT_ID -> SYS_TEMP2 (for linking purposes)
* INT_CONFIDENTIALITY_CODE -> ACCESS_CODE

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

* SYS_RECORD_ID -> SYS_TEMP2 (for linking purposes)
* SOIL_BLOW_COUNT -> VALI

The MOISTURE field from D_INTERVAL_SOIL is also copied.

* SYS_RECORD_ID is copied to SYS_TEMP2
* SOIL_MOISTURE is copied to VALF

The RECOVERY field from D_INTERVAL_SOIL is also copied.

* SYS_RECORD_ID is copied to SYS_TEMP2
* SOIL_RECOVERY is copied to VALF

***D_INT_ATTR_RD***

This replaces D_INTERVAL_ATTRIBUTE_VALUES.

* SYS_RECORD_ID -> SYS_TEMP2 (for linking purposes)
* ATT_VALUE -> RD_VALUE
* ATT_NAME_OUOM -> RD_NAME_OUOM
* ATT_VALUE_OUOM -> RD_VALUE_OUOM
* ATT_UNIT_OUOM -> RD_UNIT_OUOM

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

* SYS_RECORD_ID -> SYS_TEMP2 (for linking purposes)

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

* SYS_RECORD_ID -> SYS_TEMP2 (for linking purposes)

***D_INT_TEMPORAL_3***

This replaces D_INTERVAL_TEMPORAL_3.

* SYS_RECORD_ID is copied to SYS_TEMP2 (for linking purposes)

***D_LOC***

This replaces D_LOCATION.

* LOC_ID -> SYS_TEMP2 (for linking purposes)
* LOC_ORIGINAL_NAME -> LOC_NAME_ORG
* LOC_STATUS_CODE -> STATUS_CODE 
* LOC_CONFIDENTIALITY_CODE -> ACCESS_CODE 

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

* LOC_ID -> SYS_TEMP2 (for linking purposes)
* LOC_COMMENT_LONG -> ATTR_DESC_LONG

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

* SYS_RECORD_ID -> SYS_TEMP2 (for linking purposes)
* QUAT_GEOL -> VALF
* AVI_FEB2003_FINAL -> VALI

The DOC_YN_\* fields are copied from D_DOCUMENT.

* DOC_YN_* is copied to VALI
* DOC_YN_ENTERED_* is copied to VALI2

D_LOC_ATTR_RD

Replaces D_LOCATION_ATTRIBUTE_VALUE.

D_LOC_BOREHOLE

Replaces D_BOREHOLE.

bh_bottom_depth -> botd
bh_bottom_ouom -> bot_ouom
bh_bottom_unit_ouom -> unit_ouom
bh_bedrock_elev -> bedrock (depth calculated)
bh_drill_method_code -> drill_method_code
bh_driller_code -> driller_code
bh_logged_person -> logged_by
bh_check_person -> checked_by
bh_drill_start_date -> drill_start_date
bh_drill_end_date -> drill_end_date
bh_diameter -> diam
bh_diameter_ouom -> diam_ouom
bh_diameter_unit_ouom -> diam_unit_ouom
bh_dip -> dip
bh_azimuth -> azimuth
bh_comment -> drill_comment

D_LOC_BOREHOLE_CONS

Replaces D_BOREHOLE_CONSTRUCTION.

bh_id -> sys_temp2 (temporary, for linking purposes)
con_subtype_code -> con_type_code
con_top_ouom -> top_ouom
con_bot_ouom -> bot_ouom
con_unit_ouom -> unit_ouom
con_diameter -> diam
con_diameter_ouom -> diam_ouom
con_diameter_unit_ouom -> diam_unit_ouom




















##### Tables Present in the Old Database Schema




*Last Modified: 2025-05-22*
