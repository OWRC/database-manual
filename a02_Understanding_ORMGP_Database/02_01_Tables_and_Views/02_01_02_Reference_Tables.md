---
title:  "Section 2.1.2"
author: "ormgpmd"
date:   "20250528"
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

#### R_COORD_CODE

This table is implemented as part of the tracking mechanism for changes in
location coordinates.  This is referenced through COORD_CODE to
D_LOC_SPATIAL_HIST. Any new or updated coordinates should be stored with an
explanation and source for the change.

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

#### R_ELEV_CODE

This table is implemented as part of the tracking mechanism for changes in
elevation for a location.  This is referenced through ELEV_CODE to
D_LOC_SPATIAL_HIST. Any new or updated elevations should be stored with an
explanation for the change.  Most elevations for locations would be linked to
a particular DEM for consistency.  However, in some instances, improved
elevation values are available through surveys.  These may be updated
periodically with the particular project (and associated region) stored here.
Note that this is supplementary to the QA_ELEV_CODE (found in
D_LOC_SPATIAL_HIST and R_QA_ELEV_CODE) which provides an estimate of the
accuracy of the elevation value.

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

Here are listed various geophysical down-hole logging tools that are linked to
the D_LOC_GEOPHYS_LOG_TYPE table (through LOG_TYPE_CODE).

#### R_GRP_INT_CODE

This table contains user-specified groupings of intervals (by INT_ID) by a
common category or attribute.  This is related through GRP_INT_CODE in
D_GRP_INT.

#### R_GRP_INT_TYPE_CODE

This table provides the capability to categorize the different groups of
intervals created and found in R_GRP_INT_CODE.  This references the latter
table through GRP_INT_TYPE_CODE.

#### R_GRP_LOC_CODE

This table contains user-specified groupings of locations (by LOC_ID) by a
common category or attribute.  This is related through GRP_LOC_CODE in
D_GRP_LOC.

#### R_GRP_LOC_TYPE_CODE

This table provides the capability to categorize the different groups of
locations created in R_GRP_LOC_CODE.  This is related to the latter table
through GRP_LOC_TYPE_CODE.

#### R_GRP_OTH_CODE

Unlike R_GRP_INT_CODE and R_GRP_LOC_CODE, this table allows any set of
identifiers to be grouped together.  The pertinent identifiers would be
assigned to the OTH_ID field.  This would allow, for example, an alternate
grouping of RD_NAME_CODE parameters (found in R_RD_NAME_CODE) to that
available through R_RD_GROUP_CODE.  How a particular grouping is used or acted
upon, then, depends upon the GRP_OTH_TYPE_CODE which links to
R_GRP_OTH_TYPE_CODE.

#### R_GRP_OTH_TYPE_CODE

The types of groupings listed here differ from those found in
R_GRP_INT_TYPE_CODE and R_GRP_LOC_TYPE_CODE.  Here the type of grouping
determines how a particular group is used or accessed.  This links to
R_GRP_OTH_CODE through GRP_OTH_TYPE_CODE.

#### R_GRP_PICK_CODE

This table contains information for groupings of geologic picks as found in
the D_PICK_EXTERNAL table.  The GRP_PICK_CODE field references the latter
table.  Outside of DATA_ID, this provides additional details concerning
specific sets of records (for example, their general location).

#### R_GRP_PICK_TYPE_CODE

This table provides the capability to categorize the different groupings of
picks created in R_GRP_PICK_CODE.  This is related to the latter table through
GRP_PICK_TYPE_CODE.

#### R_INT_ALIAS_TYPE_CODE

This table allows specification of the type of aliases available in the
D_INT_ALIAS table (through the INT_ALIAS_TYPE_CODE field).  By default,
aliases are considered to be alternate names of the interval.  It can be used,
however, to link intervals (by INT_ID) between disparate databases that use
(or are based upon) the ORMGP database schema.  This has been done, for
example, for the York Region and Halton Region databases.  One prime purpose
is to capture the field sheet names used by the ORMGP for their monitored
boreholes.

#### R_INT_TYPE_CODE

The table holds the various interval types (listed under INT_TYPE_DESC) within
the database.  Note that the interval types largely pertain to the various
screen types found within wells and boreholes.  For both the stream and
climate station locations the interval type has not been broken down into
specific equipment components (e.g. temperature recorder, rain gauge recorder,
etc...).  If necessary, this should information should instead be found
through use of the purpose codes as found in D_LOC_PURPOSE and
D_LOC_PURPOSE_HIST.  Note that the ALT_CODE field can be used to group similar
interval types.  Currently, all *screen* interval types are tagged with the
text *Screen* within this field.  This capability should be captured in the
future using D_GRP_OTH and the R_GRP_OTH tables instead.

#### R_LOC_ALIAS_TYPE_CODE

This table allows specification of the type of aliases available in the
D_LOC_ALIAS table (through the LOC_ALIAS_TYPE_CODE field).  Most aliases are
considered to be alternate names for the location.  It can be used, however,
to capture specific name types.  For example, data related to the MOE Water
Well Database are categorized and include: Tag Number; Audit Number; Well
Identifier; and Borehole Identifier.  Other types include the external file
names (without the *pdf* extension) for supplementary borehole logs that have
been scanned and stored by the ORMGP.

#### R_LOC_TYPE_CODE

This table allows specification of a location type and is referenced through
LOC_TYPE_CODE in D_LOC.  Note that not all of the location types listed in
this table can be found in the database but they allow for incorporation of
additional, varying location types into the future.

#### R_OWN_TYPE_CODE

This table was originally populated by grouping and counting the number of
wells that were listed by a particular owner in the MOE Water Well database.  All
owners that had more than a certain number of locations associated with them
were added to this table.  With the removal of the owner information from the
MOE Water Well database, these updates no longer take place (from that
source).  This is referenced through OWN_TYPE_CODE in D_OWNER.

#### R_PROJECT_CODE

Herein is listed the various projects to which locations within the ORMGP
database can be linked.  This provides a mechanism by which locations within
the ORMGP study area, for example, can be designated without having to determine this
on-the-fly using a spatial analysis (reducing overhead).  Additional projects
can be specified (e.g. City of Ottawa) with locations associated with it.  In
this way, locations can be linked to a variety of overlapping project areas.
This references the D_LOC_PROJECT table using PROJ_CODE.  

#### R_PTTW_SRCID_CODE

This table is populated from the sources found in the MOE Permit to Take Water
database.  These include a list of structures which are being used as a water
source (e.g. Well, Reservoir, Quarry, etc...).  This relates to D_LOC_PTTW
through PTTW_SRCID_CODE.

#### R_PTTW_WATERSRC_CODE

This table is based upon the type of structure or description in the original
MOE Permit to Take Water database.  A PTTW location source is classified as
one or both of *Groundwater* or *Surfacewater*.  This relates to D_LOC_PTTW
through PTTW_WATERSRC_CODE.

#### R_PUMPTEST_METHOD_CODE

Original information for this table was incorporated from the MOE Water Well
database but this has been supplemented with additional categories allowing
specification of a variety of pump test methods (e.g. Air, Bailor, Pump,
etc...; listed in PT_METHOD_DESC).  This is related through PT_METHOD_CODE
to D_LOC_PUMPTEST.

#### R_PUMPTEST_TYPE_CODE

This table allows specification of a pump test type (e.g. Constant Rate,
Variable Rate, etc...; listed in PTT_TYPE_DESC).  This is
related through PT_TYPE_CODE to D_LOC_PUMPTEST.

#### R_PURPOSE_PRI_CODE

This table allows specification of a primary purpose to a particular location
within the database.  For boreholes from the MOE Water Well database, this is
populated through a combination of uses found within that source or
through the MOE Permit to Take Water database (where a link is available
between the permit and the borehole).  Note that the purposes from the Water
Well database are listed here and included in D_LOC_PURPOSE_HIST.  For most
surface water locations, the purpose codes determine its particular type.
This is related through PURPOSE_PRI_CODE to D_LOC_PURPOSE_HIST.

#### R_PURPOSE_SEC_CODE

This table allows specification of a secondary purpose to a particular
location.  Refer to R_PURPOSE_PRI_CODE for additional details.  Note that the
purposes from the MOE Water Well database are also listed here (and included
in D_LOC_PURPOSE_HIST).  This is related through PURPOSE_SEC_CODE in
D_LOC_PURPOSE_HIST.

#### R_QA_COORD_CODE

This table was originally adapted from the MOE Water Well database table and allows
specification of the inherent horizontal error for any particular location.
Note that, in general, most users should only rely upon information with a
QA_COORD_CODE of *5* or less (this indicates a positional error of three
hundred meters or less).  Additional codes from the MOE have been included
(sourced from their *Code_Location_Method* table) with a re-interpretation to
align with the original values of *1* through *9*.  

Note that QA_COORD_CODE *117* indicates an invalid coordinate location (or a
location that occurs outside the Province of Ontario).  This is also used when
no coordinates have been associated with a location.  The use of QA_COORD_CODE
*118* is now disparaged.  It was originally an indication that no coordinates
were available but that the centroid coordinates of the locations associated
township were substituted.  Most of these have been corrected or re-assigned.

A QA_COORD_CODE of *1* indicates a surveyed location and, in general, that the
coordinates should not be changed .  It does not indicate, however, that the
elevation of the location has been surveyed (refer to R_ElEV_CODE for further
details).

This is related through QA_COORD_CODE to D_LOC_SPATIAL_HIST.

#### R_QA_ELEV_CODE

This table was originally adapted from the MOE Water Well database and allows
specification of the inherent vertical error for any particular location.
Note that a QA_ELEV_CODE of *1* is used to indicate that a location has been
surveyed for elevation (and should not, in general, be changed; a
QA_COORD_CODE of *11* indicates the latter as well).  Most of the elevation
codings are no longer used and are, instead, populated from the Ministry of
Natural Resources Digital Elevation Model (2006). This table is related
through QA_ELEV_CODE to D_LOC_SPATIAL_HIST. 

Refer to **Section 2.4.2** for additional details regarding elevation
assignment for locations.

#### R_RD_GROUP_CODE

This table groups related RD_NAME_CODE parameters, as found in R_RD_NAME_CODE.
For example, a RD_GROUP_CODE of *23* is used to indicate those parameters
assocated with water level measurements.  This is liked to the R_RD_NAME_CODE
table through the RD_GROUP_CODE field.  Note that this is the default
grouping.  Additional associations can be added using the D_GRP_OTH and
related tables.

#### R_RD_NAME_ALIAS

As chemistry data (in particular) can be sourced from many different
laboratories (each using a differing but equivalent name for any particular
parameter) a single parameter can be known by multiple names.  One name,
however, should be used within the main database table (in this case,
R_RD_NAME_CODE) to reduce the chances of excluding (temporal) data from a
query or search.  

Alternate parameter names have been stored within this table that link,
through RD_NAME_CODE, to the representative parameter name found in
R_RD_NAME_CODE.  The latter has been chosen to be the default name for the
particular parameter by the ORMGP.

#### R_RD_NAME_CODE

The table contains standardized names of parameters used within the
D_INT_TEMPORAL\* tables, referenced through the RD_NAME_CODE field.  A single
name has been chosen to represent a parameter out of all possible names
available (e.g. *Na* is to be used instead of *Sodium* though each is
equivalent).  The R_RD_NAME_ALIAS table is used to capture the various names
of a particular parameter.

Fields of particular note within this table include:

* RD_GROUP_CODE - this links to R_RD_GROUP_CODE which specifies the default
  group to which the parameter belongs
* CAS_RN - this is the *CAS Registry Number*; a unique number assigned by the
  Chemical Abstracts Service (in the United States) to every chemical
  substance described in the open scientific literature
* DEF_UNIT_CODE - the is the default unit that should be used for this
  parameter throughout the temporal tables; this links to R_UNIT_CODE
* DEF_MDL - this is the default mean-detection-limit (in  default units)
  for the particular parameter (if provided)
* DATA_ID - when new parameters are added to this table, the source of the
  parameter (i.e. where it was first used) should be indicated as an error
  checking mechanism

Refer to [https://commonchemistry.cas.org](http://commonchemistry.cas.org) for
details concerning the *Chemical Abstracts Service*.

#### R_RD_TYPE_CODE

This table allows additional information to be included for any particular
reading in the D_INT_TEMPORAL\* tables (using the RD_TYPE_CODE field).  For
example a water level reading with a code of *628* (i.e. *Water Level - Manual
- Static*) can be further tagged with an RD_TYPE_CODE of *0* (i.e. *WL - MOE
Well Record - Static*) indicating that the static reading came from the MOE
Water Well database as opposed to some alternate source.  Data loggers of
varying make can also be identified using the RD_TYPE_CODE (e.g. code *59*
is used to identify *Troll - Logger*).  Additional codes could be used to
refer to specific data loggers by type and serial number.  This can be
applied against any type of recording or measuring equipment.  Climate data
recording notes (e.g. *Climate - estimated, with snow cover*) and surface
water notes also have specific records.  

#### R_REC_STATUS_CODE

Allows any reading (or record) in a variety of tables to be tagged with
additional information, mainly related to its review status or level of
accuracy determination.  These were originally applied to the D_INT_TEMPORAL\*
tables but have been expanded to include other types of records including
geology (D_LOC_GEOL_LAYER) and geologic picks (D_LOC_PICK).  The contents of
this table reflect this expansion of use.  In general, a value of *100* or
greater indicates an issue with a particular record that removes it from use.
This is linked to all tables having a REC_STATUS_CODE field.

#### R_REL_TYPE_CODE

This table lists the various types of relations that can be specified between
locations.  This includes linking multiple borehole records to a *master*
location (as applied, for example, to cluster wells from the MOE Water Well
database), the association of documents and locations (where a borehole
record, for example, would be contained within a report) as well as the
linking of Permit to Take Water locations to their source (e.g. borehole)
locations.

This replaces the use of LOC_MASTER_LOC_ID in D_LOCATION as well as the
D_PTTW_RELATED_SRC and D_DOCUMENT_ASSOCIATION tables.  Each of these tables
(and fields) were used in the previous version of the ORMGP database schema
for linking locations and have now been dropped.

This table is linked to D_LOC_RELATED through the REL_TYPE_CODE field.

#### R_SAM_TYPE_CODE

This table allows samples in D_INT_TEMPORAL_1A to be flagged with
designations such as *Duplicate*, *Field Blank*, etc...   A SAM_TYPE_CODE of
*12* indicates a regular sample.  This is related through SAM_TYPE_CODE in the
D_INTERVAL_TEMPORAL 1A table.

#### R_STATUS_CODE

This table allows specification of the status of a location (or an interval).
The codes herein were originally related to the MOE Water Well database status
codes but these have been supplemented by records that clarify the location
(or interval) status.  In particular, specific active and inactive tags have
been added for most location types found within the ORMGP database.  This is
linked to the D_LOC and D_INT tables through the STATUS_CODE field.

#### R_TOWNSHIP_CODE

Originally adapted from the MOE Water Well database, this table allows the
linking of a location to a specific township found within the Province of
Ontario.  Note that this is generally only recorded for those locations using
the MOE Water Well database as a source.  In addition, township boundaries have
changed over time and a spatial analysis would be more appropriate to
determine the particular (current) township in which a location is found
rather than making use of the values from this table.  This is related through
TOWNSHIP_CODE to D_LOC_ADDRESS.

#### R_UNIT_ALIAS

Though not as prevalent as having multiple parameter names for a single
parameter, a single unit can also be referenced by multiple names.  One name,
however, should be used within the main database table (in this case,
R_UNIT_CODE) to reduce errors associated with combining data from a variety of
sources.

Alternate unit names, then, have been stored within this table that link,
through UNIT_CODE, to the representative unit name found in R_UNIT_CODE.  The
latter has been chosen to be the default name for the particular unit by the
ORMGP.

#### R_UNIT_CODE

This table allows specification of all allowed *system* units within the ORMGP
database.  Only a single record corresponding to a particular unit (e.g.
*mg/L*) should be present within this table (i.e. there should be no
equivalent *milligram per litre* record).  Similar to the R_RD_NAME_CODE and
R_RD_NAME_ALIAS tables, an alias table (R_UNIT_ALIAS) for units is available
to capture all variations (or descriptions) of a unit and indicate the default
unit (and UNIT_CODE) to be used within the ORMGP database.

This is linked to all tables where a UNIT_CODE field is present.  This is
mainly found in the D_INT_TEMPORAL\* tables.

#### R_WATER_CLARITY_CODE

This is adapted from the MOE Water Well database and indicates the state of
the water extracted from a well during a pumping test.  This is related to
D_INT_PUMPTEST through the WATER_CLARITY_CODE field.

#### R_WQ_STANDARD

These are the Water Quality Standards as specified by various documents (see
R_WQ_STANDARD_SOURCE for details).  Each corresponds to a specifc RD_NAME_CODE
(whhere it exists in R_RD_NAME_CODE) or a parameter description and is defined
through values of: 

* MAC - Maximum Acceptable Concentration
* IMAC - Interim Maximum Acceptable Concentration
* AO - Aesthetic Objective
* OG - Operational Guideline

Units and unit codes are associated with each group.  Note that the *DWS* in
the field names refers to *drinking water standard*.

Most field definitions are sourced from: Ontario Ministry of the Environment
(2003) Technical Support Document for Ontario Drinking Water Standards,
Objectives and Guidelines.  June, 2003.

#### R_WQ_STANDARD_SOURCE

This contains the references from which the entries in R_WQ_STANDARD were
taken.  It is linked to the latter table through the DWS_SRC_CODE field.

*Last Modified: 2025-05-28*
