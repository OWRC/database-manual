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

Each record here indicates a specific check that can be performed against a
location or interval.  This is related to a combination of a table and/or
particular field within that table.  The type of check made (e.g. any of depth
or elevation, missing values, etc...) is determined by its CHECK_TYPE_CODE (as
found in R_CHECK_TYPE_CODE).

#### R_CHECK_PROCESS_CODE

The final result of a record check is referenced here.  This can include
whether the check validated the current information or that the information
needed to be modified.  The inability to locate source data can also be
indicated; this would allow for a later check of these tagged locations.  An
example of this would be missing MOE PDF documents from the Water Well
Database.

#### R_CHECK_TYPE_CODE

The specific type of check made is indicated here.  This can be one of
elevations, depths, missing values, units, etc...  This table is referenced
from R_CHECK_CODE.

#### R_CON_TYPE_CODE

The information within this table is referenced from D_LOC_BOREHOLE_CONS and
provide an indication of the means by which a borehole was constructed.  This
includes various types of borehole casing and annulus material.  Groupings of
the types (e.g. all the instances of casing materials) is listed through the
ALT_CODE field.

#### R_COUNTY_CODE

Adapted from the MOE Water Well Database, this table allows linking to an Ontario
county (found in COUNTY_DESC) for a particular spatial location.  Note
that this is, in general, only populated from the MOE Water Well Database.  As
county boundaries have changed over time, the use of GIS may be more
appropriate to determine the current county information.  This table is
referenced from D_LOC_ADDRESS.

#### R_DOC_AUTHOR_AGENCY_CODE

Author agencies (as found in DOC_AUTHOR_AGENCY_DESC) are the employer
or associated agency of the documents author as specified through DOC_AUTHOR in
D_LOC_DOCUMENT.  This is referenced from the DOC_AUTHOR_AGENCY\* fields in
that table (two of which are coded, the third is free-form text).

#### R_DOC_CLIENT_AGENCY_CODE

Client agencies (as found in DOC_CLIENT_AGENCY_DESC) reflect the agency
for which particular document in the report library has been prepared (e.g. a water
supply study undertaken for the community of *Ballantrae* would have *York
Region* as the client agency).  This is referenced through DOC_CLIENT_AGENCY\* in
D_LOC_DOCUMENT.  Only a single field is coded, the other field is for
free-form text descriptions and can be used where a document has been prepared
for more than one client agency.

#### R_DOC_JOURNAL_CODE

This holds a list of journals to which a journal article, found within
D_LOC_DOCUMENT, was originally sourced.

#### R_DOC_LOCATION_CODE

This table is used to describe the location and/or the areal extent to which a
particular document in D_LOC_DOCUMENT is attributed (by DOC_LOCATION_CODE).
Most reports should be local (i.e. site specific) or regional (associated with
a municipality or region) in nature.  Further codes allow for specification of
provincial, national or international documents.  Note that any coordinates
associated with a report (as found in D_LOC_SPATIAL_HIST) provide a general
indication of the area to which the document applies.

#### R_DOC_TOPIC_CODE

These are topics that are attributed to a particular report (and includes, for
example, landfill, climate, geophysics, etc...).  This is related through
DOC_TOPIC\*_CODE in D_LOC_DOCUMENT.  Note that there are three available
fields that can be used to capture the variety of topics to capture topic
details).

#### R_DOC_TYPE_CODE

The original type of the document or report whether it be a consultant
report, a USGS report, journal paper, etc...  This is related through
DOC_TYPE_CODE in D_LOC_DOCUMENT.

#### R_DRILL_METHOD_CODE

This is the variety of methods by which a borehole can be drilled.  This is
related through the DRILL_METHOD_CODE in D_LOC_BOREHOLE.

#### R_DRILLER_CODE

This identifies the driller (or drilling company) for a particular borehole
location.  This is related through DRILLER_CODE in the D_LOC_BOREHOLE table.
The codes are generally sourced from the MOE Water Well Database and, as much
as possible, the driller descriptions have been populated with the name of the
particular drilling company (the MOE Driller Number is then placed in the
ALT_CODE field).

#### R_FORM_MODEL_CODE

Details regarding geologic and hydrogeologic models that are used (or have 
been archived) by the ORMGP are recorded here.  These are referenced
internally in the database in the formation assignment tables (i.e.
D_INT_FORM_ASSIGN and D_INT_FORM_ASSIGN_FINAL).  Additional information
relating to the ORMGP archival methodology, describing its external storage
environment, is also found here.

Fields of particular note, within this table, include:

* FORM_MODEL_DESC - the short, general reference name of the particular model
* FORM_MODEL_DESC_LONG - the full model description, likely taken from the
  report source
* FORM_MODEL_DATE - the official date of the model
* FORM_MODEL_CODEBASE - the software base of the model (e.g. MODFLOW, FEFLOW)
* FORM_MODEL_PLATFORM - the actual software used for the model (e.g. FEFLOW,
  MIKE ZERO)
* FORM_MODEL_CREATOR - generally the original consulting company creator
* FORM_MODEL_CLIENT - the main client for whom the model was created
* FORM_MODEL_NLAYERS - the number of layers within the model
* EXT_MODEL_ID - the external directory number containing the model and its
  related files
* EXT_SHP_PATH - the polygon representing the area coverage of the model (this
  is a reference to the external storage directory)
* EXT_GDEF_PATH - the name of the GDEF file for the model
* DFID - the document folder identifier linking to the model report in
  D_LOC_DOCUMENT
* AREA_CODE - if defined, the polygon representing the area coverage of the
  model, stored internally within the ORMGP database (within R_AREA_CODE)

#### R_GEOL_MAT_CODE

These are the material descriptions used to characterize the geologic layers
within a borehole as found in D_LOC_GEOL_LAYER (and referenced by MAT_CODE).

Note that many of the supporting tables from the previous ORMGP database
schema have been combined into this single table.  This includes:
R_GEOL_MAT\*_CODE, R_GEOL_TEXTURE_CODE, R_GEOL_MOISTURE_CODE,
R_GEOL_CONSISTENCY_CODE and R_GEOL_ORGANIC_CODE.  These material code groups
are indicated through the ALT_CODE field.  

Of particular importance is the MAT_ROCK field, indicating that the recorded
material is identified as a bedrock unit.  This is used for automatic
population of the BEDROCKD field in D_LOC_BOREHOLE table.

#### R_GEOL_MATC_CODE

These are the list of colours that are referenced by MATC_CODE in
D_LOC_GEOL_LAYER allowing the colour of the geologic layer to be specified.
Most of these are adapted from the original MOE Water Well database codes.

#### R_GEOL_MATGSC_CODE

These are the codes used by the Geological Survey of Canada, as interpreted
from the original MOE material codes, designating various geologic types.  The
original map code is held in MATGSC_ORG with the geologic description found in
MATGSC_DESC.  This is referenced from D_LOC_GEOL_LAYER through the MATGSC_CODE
field.  Note that the records in the latter table have only been incompletely
populated.

#### R_GEOL_UNIT_CODE

This table contains the various geologic units as encountered, generally,
within the ORMGP study area.  These unit descriptions have been derived from a
variety of sources, mainly from the Ontario Geological Survey and the
Geological Survey of canada.  The formal name of the geologic unit is found in
GEOL_UNIT_DESC (a more complete description of the unit is held within
GEOL_UNIT_DESC_LONG).  Formations that are used, informally, within
the ORMGP have an *ORMGP* tag appended. 

The material codes held within this table (i.e. within MAT\*_CODE) have not
been maintained in this version of the database schema.  The material codes
did not match those found with the R_GEOL_MAT_CODE table.  The AQUIFER field,
usually only populated for the ORMGP layers, is used to indicate an aquifer
layer when a non-null value of *1* is found.

This table is referenced from a number of other tables including, for example,
D_INT_FORM_ASSIGN and D_LOC_GEOL_LAYER.

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
