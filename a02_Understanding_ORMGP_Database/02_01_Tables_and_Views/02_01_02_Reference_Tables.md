---
title:  "Section 2.1.2"
author: "ormgpmd"
date:   "20250527"
output: html_document
knit:   (
            function(input_file, encoding) {
                out_dir <- '';
                rmarkdown::render(
                    input_file,
                    encoding=encoding,
                    output_file=file.path(dirname(input_file), out_dir,
                    '02_01_02_Reference_Tables.html')
                )
            }
        )
---

## Section 2.1.2 Reference Tables (R_\*)

Prefixed with an *R_*, these tables are populated with data that is used to
code information within the data (i.e. *D_*) tables within the ORMGP database
(refer to **Section 2.1.1**).

#### R_ACCESS_CODE

The records here allow the tagging of individual locations and/or intervals as
confidential to a particular partner or group of partners.  If a specific
location is flagged with an access code that is not null and greater than *1*
then no information will be distributed regarding the location.  Where a
particular interval is flagged, information at the location level will be
available (e.g. name, geology, etc...), but no information related to the
interval (e.g. screen details, chemistry or water level data, etc...) would be
distributed.  Note that the access to this information is restricted at the
interface rather than at the individual tables (e.g. either through a
web-interface or when using any data distribution views; an example of the
latter is the set of V_CON_\* views which is used to distribute information to
consultants).

#### R_AREA_CODE

Here, polygons are stored using the geometry types within SQL Server and are
used be used to determine locations that fall within these areas.  This
information would then be available through the D_LOC_AREA table to avoid
lengthy spatial analysis times.

The polygons include, for example, the extents of the regions (Durham, Peel,
Toronto and York) as well as the Conservation Authority partners.  The GEOM
field holds the native spatial geometry while the GEOM_WKB holds the
*Well-Known-Binary* format.  In addition, latitude and longitude geometries
are available as well as any alternate geometry used by the ORMGP (as
described in D_LOC_SPATIAL_HIST).

Each record can be associated with a particular area type (by AREA_TYPE_CODE)
which allows the polygons to be grouped.

#### R_AREA_TYPE_CODE

This table declares the type of polygons (i.e. area coverage) availabe in the
R_AREA_CODE table.  This would include conservation areas, regions, and
geological and hydrogeolgical models (for example).

#### R_ATTR_CODE

This table lists the various attributes that can be associated with a
particular LOC_ID through the D_LOCATION_ATTR table.  Examples include:
surface water drainage areas; surface water stream segment identifiers;
geologic features (formerly found in D_GEOLOGY_FEATURE in earlier versions of
the database schema); etc...

#### R_BH_STATUS_CODE

This table was adapted from the original MOE database codes and is referenced
through BH_STATUS_CODE in D_LOC_BOREHOLE.  The codes are a mix of well
use and status and are generally not used directly within the database.  When
primary and secondary uses are being determined for an MOE Water Well Database
location, this field is used as an indicator (refer to D_LOC_PURPOSE as well
as **Appendix G** for details).

#### R_CHECK_CODE

#### R_CHECK_PROCESS_CODE

#### R_CHECK_TYPE_CODE

#### R_CON_TYPE_CODE

#### R_COUNTY_CODE

#### R_DOC_AUTHOR_AGENCY_CODE

#### R_DOC_CLIENT_AGENCY_CODE

#### R_DOC_JOURNAL_CODE

#### R_DOC_LOCATION_CODE

#### R_DOC_TOPIC_CODE

#### R_DOC_TYPE_CODE

#### R_DRILL_METHOD_CODE

#### R_DRILLER_CODE

#### R_FORM_MODEL_CODE

#### R_GEOL_MAT_CODE

#### R_GEOL_MATC_CODE

#### R_GEOL_MATGSC_CODE

#### R_GEOL_UNIT_CODE

#### R_GEOPHYS_LOG_TYPE_CODE

#### R_GROUP_INT_CODE

#### R_GROUP_INT_TYPE_CODE

#### R_GROUP_LOC_CODE

#### R_GROUP_LOC_TYPE_CODE

#### R_GROUP_OTH_CODE

#### R_GROUP_OTH_TYPE_CODE

#### R_GROUP_PICK_CODE

#### R_GROUP_PICK_TYPE_CODE

#### R_INT_ALIAS_TYPE_CODE

#### R_INT_TYPE_CODE

#### R_LOC_ALIAS_TYPE_CODE

#### R_LOC_COORD_CODE

#### R_LOC_ELEV_CODE

#### R_LOC_TYPE_CODE

#### R_OWN_TYPE_CODE

#### R_PROJECT_CODE

#### R_PTTW_SRCID_CODE

#### R_PTTW_WATERSRC_CODE

#### R_PUMPTEST_METHOD_CODE

#### R_PUMPTEST_TYPE_CODE

#### R_PURPOSE_PRI_CODE

#### R_PURPOSE_SEC_CODE

#### R_QA_COORD_CODE

#### R_QA_ELEV_CODE

#### R_RD_GROUP_CODE

#### R_RD_NAME_ALIAS

#### R_RD_NAME_CODE

#### R_RD_TYPE_CODE

#### R_REC_STATUS_CODE

#### R_REL_TYPE_CODE

#### R_SAM_TYPE_CODE

#### R_STATUS_CODE

#### R_TOWNSHIP_CODE

#### R_UNIT_ALIAS

#### R_UNIT_CODE

#### R_WATER_CLARITY_CODE

#### R_WQ_STANDARD

#### R_WQ_STANDARD_SOURCE


*Last Modified: 2025-05-27*
