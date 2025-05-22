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
    the tables within the update database schema
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

This replaces R_CON_SUBTYPE_CODE and the the original R_CONT_TYPE_CODE.  The
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

Copied.

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























##### Tables Present in the Old Database Schema




*Last Modified: 2025-05-22*
