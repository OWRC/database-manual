---
title:  "Section 2.1.2"
author: "ormgpmd"
date:   "20221214"
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

## Section 2.1.2 Look-Up/Reference Tables (R_\*)

Prefixed with an 'R_', these tables are populated with data that is used to 
code information within the 'D_' data tables (listed above).  Only those 
used by the ORMGP are included. 

#### R_ACTVITY_CODE

The table is required by SiteFX and links to the D_LOCATION_ACTIVITY table.
It is presently not effectively used within the database.

#### R_ATTR_CODE

This table lists the various attributes that can be associated with a
particular LOC_ID through the D_LOCATION_ATTR table.  Examples include:
surface water drainage areas; surface water stream segment identifiers; etc...

#### R_BH_DRILL_METHOD_CODE

This table lists various drilling methods.  This is related through
BH_DRILL_METHOD_CODE in the D_BOREHOLE table.

#### R_BH_DRILLER_CODE

Identifies the driller (or drilling company) of a particular borehole.  This
is related through BH_DRILLER_CODE in the D_BOREHOLE table.  The codes are
directly from the MOE database and, as much as possible, the
BH_DRILLER_DESCRIPTION_LONG has been populated so that the MOE codes are
related to a particular drilling company.  The BH_DRILLER_QA_CODE is largely
unpopulated but does provide an opportunity to screen well locations based on
the quality of the well driller (There should be an explanation for this
???).

#### R_BH_STATUS_CODE

This table was adapted from the original MOE database codes and is related
through BH_STATUS_CODE in the D_BOREHOLE table.  The codes are a mix of well
use and status and are generally not used directly within the database.  As
appropriate, the code has been translated to either the LOC_STATUS code in the
D_LOCATION table or to the PURPOSE_PRIMARY_CODE and/or PURPOSE_SECONDARY_CODE
in the D_LOCATION_PURPOSE table.

#### R_CHECK_CODE

Each record here indicates a specific check that can be performed against a
location or interval.  This is related to a combination of a table and/or
particular field within that table.  The type of check made (e.g. any of depth
or elevation, missing values, etc ?) is determined by its CHECK_TYPE_CODE (as
found in R_CHECK_TYPE_CODE).

#### R_CHECK_PROCESS_CODE

The final result of the check is indicated here.  This can include whether the
check validated the current information or that the information needed to be
modified.  The inability to locate source data can also be indicated (allowing
for a later check of affected locations in the instance, for example of
missing MOE PDF's).

#### R_CHECK_TYPE_CODE

The specific type of check made is indicated here.  This can be one of
elevations, depths, missing values, units, etc ?  This table is reference
through R_CHECK_CODE.

#### R_CON_SUBTYPE_CODE

Related through CON_SUBTYPE_CODE to the D_BOREHOLE_CONSTRUCTION table, this
table contains descriptions for borehole casings, seals and sandpacks. 

#### R_CON_TYPE_CODE

Related through CON_TYPE_CODE to the R_CON_SUBTYPE_CODE table (as the
construction types - i.e. the CON_TYPE's -  are generally repeated within the
construction subtype - i.e. the CON_SUBTYPE's -  descriptions, they are not
directly related to any data table).

#### R_CONFIDENTIALITY_CODE

Allows tagging of individual locations and/or intervals as confidential to a
particular partner (but could be expanded beyond partner agencies if needed).
Currently the partner agencies have not made use of the confidentiality coding
within the database.  If a specific location is flagged with a confidentiality
code then no information will be distributed regarding the location.  Where a
particular interval is flagged, information at the location/borehole level
will be made available (e.g. name, geology, etc.), but no information related
to the interval (e.g. screen details, chemistry or water level data, etc...)
would be distributed.  Such information would not be made available through
the consultant V_CON_* views.

This is related through CONFIDENTIALITY_CODE in the D_LOCATION and D_INTERVAL
tables.

#### R_CONV_CLASS_CODE

These codes are used internally within SiteFX to specify conversion details
(for example, with regard to calculation of elevations from depths).  This is
related through CONV_CLASS_CODE in D_INTERVAL and R_UNIT_CONV.

#### R_CRIT_GROUP_CODE

Originally established to provide a means of comparing, within SiteFX,
chemistry data held in the database to a specified, published criteria (e.g.
compare this sample to the Ontario Drinking Water Standards).  The table is
not currently used in the database (and is only partially populated) but is
required by SiteFX.

#### R_CRIT_TYPE_CODE

Originally established to provide a means of comparing, within SiteFX,
chemistry data held in the database to a specified, published criteria (e.g.
compare this sample to the Ontario Drinking Water Standards).  The table is
not currently used in the database (and is only partially populated) but is
required by SiteFX.

#### R_DOC_AUTHOR_AGENCY_CODE

Author agencies (as found in DOC_AUTHOR_AGENCY_DESCRIPTION) are the employer
or associated agency of the author (as specified through DOC_AUTHOR in
D_DOCUMENT).  Related through DOC_AUTHOR_AGENCY_CODE in D_DOCUMENT (note that
to account for multiple authors for a document, and therefore multiple author
agencies, the D_DOCUMENT table has two available fields containing author
agency code details and a third allowing a free-form text description).  In
some instances an author may not be associated with any particular agency and
this field, in D_DOCUMENT, would remain blank.

#### R_DOC_CLIENT_AGENCY_CODE

Client agencies (as found in DOC_CLIENT_AGENCY_DESCRIPTION) reflect the agency
for which particular document in the library has been prepared (e.g. a water
supply study undertaken for the community of 'Ballantrae' would have 'York
Region' as the client agency).  Related through DOC_CLIENT_AGENCY_CODE in
D_DOCUMENT (note that the D_DOCUMENT table has a single available field for
client agency code details and a second field allowing a free-form text
description for those cases where a document has been prepared for more than
one client agency).

#### R_DOC_FORMAT_CODE

The table is used to reflect whether a hard copy of a particular document is
available at the ORMGP office.  The DOC_FORMAT_DESCRIPTION is generally
limited to one (or both) of 'Electronic' or 'Hard Copy'.  Note that all
reports listed in D_DOCUMENT should be available as digital files in the ORMGP
report library (refer to Section 2.6).  As most documents are made available
in digital form only, the 'Hard Copy' availability will eventually become
invalid.

#### R_DOC_JOURNAL_CODE

Source journal names for papers present in the report library.  This is
related through DOC_JOURNAL_CODE in D_DOCUMENT.

#### R_DOC_LOCATION_CODE

This table is used mostly to flag: 

* Documents that are located outside of the ORMGP study area and therefore have no (valid, local) UTM coordinates (e.g. a report on Ohio tills would be flagged as 'USA' or 'Ohio' in this field)
* Documents that cover a broad region within the ORMGP study area (e.g. a report that covered groundwater within the Region of Peel would be flagged as DOC_LOCATION_CODE '3' ('Regional') even though the document would be assigned coordinates in the centroid of Peel Region.

These codes (as described in DOC_LOCATION) allow further details regarding the
location and/or spatial extent covered by the document and should be used as
supporting information when performing a report library search based upon
location.  Note that the use of this table (and associated field) is optional
when valid coordinates are available.  This is related through
DOC_LOCATION_CODE in D_DOCUMENT.

#### R_DOC_TOPIC_CODE

Topics attributed to a particular report.  This is related through
DOC_TOPIC_CODE in D_DOCUMENT (note that D_DOCUMENT has three available fields
to capture topic details).

#### R_DOC_TYPE_CODE

The original type of the document or report (e.g. Consultant Report, USGS
Report, Journal Paper, etc...).  This is related through DOC_TYPE_CODE in
D_DOCUMENT.

#### R_EQ_GROUP_CODE

This table was established to track equipment that might be used at any
location and is required by SiteFX.  The table is not currently used and the
table will be re-evaluated in the next version of the database.

#### R_EQ_TYPE_CODE

This table was established to track equipment that might be used at any
location and is required by SiteFX.  The table is not currently used and the
table will be re-evaluated in the next version of the database.

#### R_FEATURE_CODE

The information contained here were adapted from the original MOE database
codes describing the type of 'Water Found' (e.g. fresh, mineralized, iron,
etc.).  This is related through FEATURE_CODE in D_GEOLOGY_FEATURE.

#### R_FORM_ASSIGN_CODE

The codes here relate to data found in the D_INTERVAL_FORMATION_ASSIGNMENT
(DIFA) table detailing, namely, the attributes that each interval can have
with regard to a particular geologic model (see R_FORM_MODEL_CODE). 

#### R_FORM_MODEL_CODE

The codes here relate to data found in the D_INTERVAL_FORM_ASSIGN (DIFA)
table.  Any number of geologic or hydrogeologic models can be specified.  Note
that the specialty model, 'YPDT-CAMC Final' is no longer used (it was used to
indicate the interpreted geologic unit that should be assigned to a particular
interval; this was part of a previously defined methodology for populating
DIFA).  Refer to R_GEOL_UNIT_CODE and DIFA for details.

#### R_GEOL_CLASS_CODE

This table specifies the type of classification code available to the geologic
subclasses - the latter allow different geological interpretations to be
stored for the same geologic layer.  Only two options are available - either a
'lithologic' layer or a geologic 'pick'.  This is related through
GEOL_CLASS_CODE in R_GEOL_SUBCLASS_CODE.

#### R_GEOL_CONSISTENCY_CODE

The table is used to track the standard geotechnical consistency codes for
each sample/layer encountered in a borehole (e.g. compact, firm, dense, soft,
stiff, etc?).  Data is generally only provided for the geotechnical boreholes
in the database (either City of Toronto, UGAIS, or other consultant boreholes;
refer to Appendix D).  This is related through GEOL_CONSISTENCY_CODE in
D_GEOLOGY_LAYER.

#### R_GEOL_MAT_COLOUR_CODE

These codes are adapted from the original MOE database codes, assigning a
colour to a geologic layer.  This is related through GEOL_MAT_COLOUR_CODE in
D_GEOLOGY_LAYER.

#### R_GEOL_MAT_GSC_CODE

The codes used by the GSC as interpreted from the original MOE material codes.
This is related through GEOL_MAT_GSC_CODE in D_GEOLOGY_LAYER (note that the
latter has been only incompletely populated).

#### R_GEOL_MAT1_CODE (Includes MAT2, MAT3 and MAT4 descriptions)

These are the available descriptions (found in GEOL_MAT1_DESCRIPTION) for
geologic layers.  Note that there are four tables of these descriptions

* R_GEOL_MAT1_CODE
* R_GEOL_MAT2_CODE
* R_GEOL_MAT3_CODE
* R_GEOL_MAT4_CODE

All four tables are consistent (i.e. containing the same coded information) -
these multiple tables are necessary for internal use when writing queries.
The codes are largely taken from the MOE database, though several additional
geologic type/descriptions have been added.  These are related through
GEOL_MAT1_CODE in D_GEOLOGY_LAYER (this also includes each of GEOL_MAT2_CODE,
GEOL_MAT3_CODE and GEOL_MAT4_CODE).  Note that the ROCK field designates (if
true) whether the unit can be considered bedrock.

#### R_GEOL_MOISTURE_CODE

This table is used to track the standard geotechnical moisture codes for each
sample/layer encountered in a borehole (e.g. wet, moist, damp, dry).  Data is
generally only provided for the geotechnical boreholes in the database (e.g.
City of Toronto, UGAIS, or other consultant boreholes; refer to Appendix D).
This is related through GEOL_MOISTURE_CODE in D_GEOLOGY_LAYER.

#### R_GEOL_ORGANIC_CODE

This table is used to provide additional detail regarding the organic
materials within geologic layers.  Data is generally only available for the
geotechnical boreholes in the database (e.g. City of Toronto, UGAIS, or other
consultant boreholes; refer to Appendix D).  This is related through
GEOL_ORGANIC_CODE in D_GEOLOGY_LAYER.

#### R_GEOL_SUBCLASS_CODE

This table allows different geological interpretations to be stored for the
same geologic layer.  This is related through GEOL_SUBCLASS_CODE in
D_GEOLOGY_LAYER.  In D_GEOLOGY_LAYER, a blank (i.e. NULL) GEOL_SUBCLASS_CODE
generally indicates that the geologic coding is the 'original'; a value of '5'
indicates that geologic coding has been checked against the original source
and found to be valid OR has been corrected.  The other common code used is
'7' (i.e. 'Invalid'), used to remove layers from consideration.

#### R_GEOL_TEXTURE_CODE

The table is used to track the standard geotechnical texture codes for each
sample/layer encountered in a borehole (e.g. amorphous, fibrous, coarse,
etc?).  Data is generally only provided for the geotechnical boreholes in the
database (e.g. City of Toronto, UGAIS, or other consultant boreholes; refer to
Appendix D).  This is related through GEOL_TEXTURE_CODE in D_GEOLOGY_LAYER.

#### R_GEOL_UNIT_CODE

This table contains the various geologic units as encountered, generally, in
the ORMGP Study Area.  These unit descriptions have been derived from various
sources (mainly from the OGS and the GSC).  Formations that are not formally
recognized and that are used informally in the ORMGP are pre-pended with a
'YPDT' description.  This is related through GEOL_UNIT_CODE in D_GEOLOGY_LAYER
and D_INTERVAL_FORM_ASSIGN.  The AQUIFER field, usually only for the ORMGP
layers, is used to indicate (when populated by a non-null value, generally a
'1') that the unit is considered an aquifer.  This is used as part of the
logic when determining the 'Assigned Unit' in D_INTERVAL_FORM_ASSIGN.

#### R_GROUP_INT_CODE

This table contains user-specified group codes allowing the grouping of
intervals (by INT_ID) by a common category or attribute.  This is related
through GROUP_INT_CODE in D_GROUP_INTERVAL.

#### R_GROUP_INT_TYPE_CODE

This table provides the capability to categorize the different groups of
intervals created (i.e. in R_GROUP_CODE).  The table is used by SiteFX when
importing logger data (for barometric correction).  This is related through
GROUP_INT_TYPE_CODE in R_GROUP_INT_CODE.

#### R_GROUP_LOC_CODE

This table contains user-specified group codes allowing the grouping of
locations (by LOC_ID) by a common category or attribute.  This is related
through GROUP_LOC_CODE in D_GROUP_LOCATION.

#### R_GROUP_LOC_TYPE_CODE

This table provides the capability to categorize the different groups of
locations created.  This is related through GROUP_LOC_TYPE_CODE in
R_GROUP_LOC_CODE.

#### R_INT_TYPE_CODE

The table holds the various interval types (found under INT_TYPE_DESCRIPTION)
within the database.  Note that the interval types largely pertain to the
wells/boreholes in the database.  For both the stream and climate station
locations the INT_TYPE has not been broken down into specific equipment
components (e.g. temperature recorder, rain gauge recorder, etc?).  This is
related through INT_TYPE_CODE in D_INTERVAL.  The INT_TYPE_ALT_CODE field is
used here to 'group' similar interval types.    Currently, all 'screen'
interval types are tagged with the text 'Screen' in this field.

Note that the field SYS_INT_DETAIL_CODE should include a value of [2] to allow
the SiteFX software to include records from D_INTERVAL_MONITOR and
D_INTERVAL_REF_ELEV when examining the interval/location.

#### R_LOC_ALIAS_TYPE_CODE

The table provides a means to specify to what group an 'aliased' name applies.
Currently the table is being used to track the supplementary MOE database
identifiers as found in D_LOCATION_ALIAS: Tag Number; Audit Number; WELL ID;
and the Borehole ID Field.  This is related through LOC_ALIAS_TYPE_CODE in
D_LOCATION_ALIAS.

#### R_LOC_COORD_HIST_CODE

This table is implemented as part of the tracking mechanism for changes in
location coordinates.  This is related through LOC_COORD_HIST_CODE in
D_LOCATION_SPATIAL_HIST. Any 'new' coordinates should be stored with an
explanation for the change - as described in LOC_COORD_HIST_DESCRIPTION and
LOC_COORD_HIST_DESCRIPTION_LONG (or COORD_HIST_COMMENT in the referenced
table).

#### R_LOC_COORD_OUOM_CODE

This table allows the specification of the projection (and datum) of the
original coordinates for locations as found in D_LOCATION (this is now
disparaged and is not included in D_LOCATION_SPATIAL_HIST; the use of an EPSG
code is instead recommended).  Used by SiteFX when converting to system units (i.e.
UTM Zone 17, NAD 83).  This is related through LOC_COORD_OUOM_CODE in
D_LOCATION.

#### R_LOC_COUNTY_CODE

Adapted from the MOE database and allows linking to a (province of) Ontario
county (as found in LOC_COUNTY_DESCRIPTION) for a particular location (note
that this is currently used only for those wells from the MOE database given
that county boundaries have changed over time and that GIS systems can better
be used to track the particular county in which a location is found).  This is
related through LOC_COUNTY_CODE in D_LOCATION.

#### R_LOC_DATA_SOURCE_CODE

The table has been incorporated from the MOE database and slightly adapted.
In general the table is not extensively used.  The MOE used the table to
coarsely identify whether a particular well record was submitted from a
driller (most commonly) versus any other source (e.g. Consultant, MOE or MNR
Staff, Industry, etc?).  This is related through LOC_DATA_SOURCE_CODE in
D_LOCATION.

#### R_LOC_ELEV_CODE

This table is implemented as part of the tracking mechanism for changes in
elevation for a location.  This is related through LOC_ELEV_CODE in
D_LOCATION_SPATIAL_HIST. Any 'new' elevations should be stored with an
explanation for the change - as described in LOC_ELEV_DESCRIPTION and
LOC_ELEV_DESCRIPTION_LONG (or ELEV_HIST_COMMENT in the referenced table).
LOC_ELEV_SURVEY and LOC_ELEV_DEM, when the values are non-null, indicate that
the particular code can be considered to be 'surveyed' or a 'digital elevation
model' (respectively). 

#### R_LOC_MOE_USE_PRIMARY_CODE

Adapted from the MOE database and holds the original MOE primary use
descriptions (as found in LOC_USE_PRIMARY_DESCRIPTION).  This is related
through LOC_USE_PRIMARY_CODE in D_LOCATION (using the field
LOC_MOE_USE_1ST_CODE in the latter table).

#### R_LOC_MOE_USE_SECONDARY_CODE

Adapted from the MOE database and holds the original MOE secondary use
descriptions (as found in LOC_USE_SECONDARY_DESCRIPTION).  This is related
through LOC_USE_SECONDARY_CODE in D_LOCATION (using the field
LOC_MOE_USE_2ND_CODE in the latter table).

#### R_LOC_STATUS_CODE

This table allows specification of a location's current status.  The codes are
somewhat related to the MOE's status codes but additional categories have been
incorporated to clarify the location's status (e.g. categories such as
destroyed, decommissioned, etc? have been added).  This is related through
LOC_STATUS_CODE in D_LOCATION.

#### R_LOC_TOWNSHIP_CODE

Adapted from the MOE database and allows linking to a (province of) Ontario
township (as found in LOC_TOWNSHIP_DESCRIPTION) for a particular location
(note that this is generally used only for those wells from the MOE database
given that the township boundaries have changed over time and that GIS systems
can better be used to track the particular county in which a location is
found).  This is related through LOC_TOWNSHIP_CODE in D_LOCATION.

#### R_LOC_TYPE_CODE

This table allows specification of a location type and is related through
LOC_TYPE_CODE in D_LOCATION.  Note that not all of the location types listed
in this table can be found in the database but they allow for incorporation of
additional, varying location types into the future. 

#### R_LOC_WATERSHED1_CODE (includes WATERSHED2 and WATERSHED3 codes)

These tables originated from the MOE database and were designed to record the
watershed (at different scales) in which a location is found.  The tables list
all of the primary watersheds that drain from the Oak Ridges Moraine.  Using
GIS, two of the three fields (LOC_WATERSHED1_CODE and LOC_WATERSHED2_CODE) in
the D_LOCATION table were populated several years ago.  However, the fields
are not frequently used and are not regularly updated.

This is related through LOC_WATERSHED1_CODE (as well as LOC_WATERSHED2_CODE
and LOC_WATERSHED3_CODE) in D_LOCATION.

#### R_OWN_TYPE_CODE

This table was originally populated by grouping and counting the number of
wells that were listed by a particular 'owner' in the MOE database.  All
owners that had more than 5 to 10 locations associated with them were added as
an OWN_TYPE_DESCRIPTION (with associated code) to this table.  With the
removal of the owner information from the MOE database, this table and its
related D_OWNER table are no longer updated.  This is related through
OWN_TYPE_CODE in D_OWNER.

#### R_PROJECT_AGENCY_CODE

Currently empty.  This table is part of the structure for a future release of
SiteFX (version 6; some support in version 5) and is to be used to control
access (by partner agencies) to locations within their areal extent.  This is
part of the replacement for the original D_LOCATION_AGENCY table.  This
relates to R_PROJECT_TIER1_CODE using PRJ_AG_CODE.

#### R_PROJECT_TIER1_CODE

Currently empty.  This table is part of the structure for a future release of
SiteFX (version 6; some support in version 5) and is to be used to control
access (by partner agencies) to locations within their areal extent.  This is
part of the replacement for the original D_LOCATION_AGENCY table and relates
to D_PROJECT_LOCATION using PRJ_TIER1_CODE.

#### R_PROJECT_TIER2_CODE

Currently empty.  This table is part of the structure for a future release of
SiteFX (version 6; some support in version 5) and is to be used to control
access (by partner agencies) to locations within their areal extent.  This is
part of the replacement for the original D_LOCATION_AGENCY table and relates
to R_PROJECT_TIER1_CODE using PRJ_TIER1_CODE.

#### R_PROJECT_TYPE_CODE

Currently empty.  This table is part of the structure for a future release of
SiteFX (version 6; some support in version 5) and is to be used to control
access (by partner agencies) to locations within their areal extent.  This is
part of the replacement for the original D_LOCATION_AGENCY table and relates
to R_PROJECT_TIER1_CODE using PRJ_TYPE_CODE.

#### R_PTTW_SOURCEID_CODE

This table was originally populated from the sources found in the MOE 'Permit
to Take Water' database.  These include a list of structures from which are
being used as a water source (e.g. Well, Reservoir, Quarry, etc?).  This
relates to D_PTTW through PTTW_SOURCEID_CODE.

#### R_PTTW_WATER_SOURCE_CODE

This table is based upon the type of structure or description in the original
MOE 'Permit to Take Water' database; a PTTW location source is classified as
one or both of 'Groundwater' or 'Surfacewater'.  This relates to D_PTTW
through PTTW_WATER_SOURCE_CODE.

#### R_PUMPTEST_METHOD_CODE

Original information was incorporated from the MOE WWDB database but has been
supplemented with additional categories allowing specification of a pumptest
method (e.g. Air, Bailor, Pump, etc...; as found in
PUMPTEST_METHOD_DESCRIPTION).  This is related through PUMPTEST_METHOD_CODE in
D_PUMPTEST.

#### R_PUMPTEST_TYPE_CODE

This table allows specification of a pumptest type (e.g. Constant Rate,
Variable Rate, etc...; as found in PUMPTEST_TYPE_DESCRIPTION).  This is
related through PUMPTEST_TYPE_CODE in D_PUMPTEST.

#### R_PURPOSE_PRIMARY_CODE

This table allows specification of a primary purpose to a particular location
and is populated through a combination of uses found within any of 

* The MOE water well database 
* The MOE Permit to Take Water database 
* Other uses not utilized by the MOE  

This is related through PURPOSE_PRIMARY_CODE in D_LOCATION_PURPOSE.

#### R_PURPOSE_SECONDARY_CODE

This table allows specification of a secondary purpose to a particular
location.  See R_PURPOSE_PRIMARY_CODE (above) for population details.  This is
related through PURPOSE_SECONDARY_CODE in D_LOCATION_PURPOSE.

#### R_QA_COORD_CONFIDENCE_CODE

This table is adapted from the MOE water well database table and allows
specification of the inherent horizontal error (found in
QA_COORD_CONFIDENCE_DESCRIPTION) for any particular location.  Note that in
general, users (and most views) should only rely upon information with a
QA_COORD_CONFIDENCE_CODE of less than '6' (i.e. '5' - 'Margin of Error: 100 m
- 300 m' - or less).  Codes that have added over the years by the MOE in their
'Code_Location_Method' table are also found in this table with a
re-interpretation as to how they have been redefined to fit within the
original MOE reliability coding of '1' through '9'.  The special code '117'
('YPDT - Coordinate Invalid OR Outside Ontario (10km Buffer)') is used when
the coordinates are invalid - this should correspond to NULL values in both
LOC_COORD_EASTING and LOC_COORD_NORTHING (as found in D_LOCATION).  The
special code '118' ('YPDT - Assigned Township Centroid') is used when no
(valid) coordinates were available but the LOC_TOWNSHIP_CODE (in D_LOCATION)
was populated.  The centroid coordinates of the latter were then used to
populated LOC_COORD_EASTING and LOC_COORD_NORTHING as a temporary measure
(i.e. these are used as a review indicator).  Note that a code of '1' is used
to indicate a 'surveyed' location (but this does not translate into surveyed
elevation; see R_QA_ELEV_CONFIDENCE_CODE, below).

This is related through QA_COORD_CONFIDENCE_CODE in D_LOCATION_QA.

#### R_QA_ELEV_CONFIDENCE_CODE

This table is adapted from the MOE water well database table and allows
specification of the inherent vertical error (found in
QA_ELEV_CONFIDENCE_DESCRIPTION) for any particular location.  Note that a code
of '1' ('1 ft - Surveyed in field from known Bench Mark') is used to indicate
that a location has been 'surveyed' for elevation.  In general the elevation
coding is no longer used as the elevations now are no longer assigned by the
MOE and are, instead, populated from a MNR DEM.  Within the database the codes
are now only used to differentiate 'surveyed' locations ('1'; these will never
have their elevation over-written by a DEM elevation) versus 'non-surveyed'
locations ('10'; these elevation values would be over-written by a DEM value).
This is related through QA_ELEV_CONFIDENCE_CODE in D_LOCATION_QA.

Refer to Section 2.4.2 for additional details regarding location elevation
assignment.

#### R_RD_NAME_CODE

The table contains standardized names used in the D_INTERVAL_TEMPORAL_* tables
(and related through the RD_NAME_CODE field).  A single name has been chosen
to represent a parameter out of all possible names available (e.g. 'Na'
instead of 'Sodium').  The table R_READING_NAME_ALIAS (described below) is
used to associate the various possible names with the single name, stored
here.

#### R_RD_TYPE_CODE

Allows additional information to be included for any particular reading in the
D_INTERVAL_TEMPORAL_* tables (using the RD_TYPE_CODE field).  For example a
water level reading with a code of '628' ('Water Level - Manual - Static') can
be further tagged with a RD_TYPE_CODE of '0' ('WL - MOE Well Record - Static')
indicating that the static reading came from the MOE water well database.
Data loggers of varying make can also be identified using the RD_TYPE_CODE
(e.g. code '59' is used to identify 'Troll - Logger').  Additional codes refer
to specific data loggers by type and serial number; this can be applied
against any type of recording or measuring equipment.  Climate data recording
notes (e.g. 'Climate - estimated, with snow cover') and surface water notes
also have specific RD_TYPE_CODE's.  This lookup table is currently underused
in the database.

#### R_READING_GROUP_CODE

This table associates related RD_NAME_CODE's (as found in R_RD_NAME_CODE)
allowing them to be grouped as necessary.  For example, a READING_GROUP_CODE
of '23' is used to indicate all RD_NAME_CODE's that are associated with water
level measurements.  This is related through READING_GROUP_CODE in the
R_RD_NAME_CODE table.

#### R_READING_NAME_ALIAS

As chemistry data (in particular) can come from many different laboratories
(each using a differing but equivalent name for any particular parameter) a
single parameter can be known by multiple names.  A single name, only, should
be used within the 'primary' database table (i.e. R_RD_NAME_CODE) to reduce
the chances for excluding (temporal) data from a query or search.  Alternate
parameter names have been stored within this table linked to the
'chosen-representative' name (found in R_RD_NAME_CODE) that is to be used for
the particular parameter in the database.  This table is referenced by SiteFX
when converting from the OUOM specified parameter.

#### R_REC_STATUS_CODE

Allows any reading in the D_INTERVAL_TEMPORAL_1B and _2 tables to be tagged
with additional information, currently pertaining to a QA check (e.g. '1'
indicates an 'unreviewed data  record', '2' a 'reviewed - record is valid').
This table and the associated fields are not extensively used and should be
re-evaluated or updated in the next database release.  This is related through
REC_STATUS_CODE (found in both of these tables) in D_INTERVAL_TEMPORAL_1B and
D_INTERVAL_TEMPORAL_2.

#### R_SAM_TYPE_CODE

This table allows samples in D_INTERVAL_TEMPORAL_1A to be flagged with
designations such as 'Duplicate', 'Field Blank', etc...  This is related
through SAM_TYPE_CODE in the D_INTERVAL_TEMPORAL 1A table.

#### R_SAM_TYPE_KEYWORD

The table is not currently used in the database but is required by SiteFX.  It
appears to act as an alias table for the SAM_TYPE_CODE table.  This is related
through SAM_TYPE_CODE in the D_INTERVAL_TEMPORAL_1A table.

#### R_SYS_GROUP_SEARCH

This table is used and populated by SiteFX.

#### R_SYS_GROUP_TYPE_CODE

This table is used and populated by SiteFX.

#### R_SYS_INT_DETAIL_CODE

This table is used and populated by SiteFX.

#### R_SYS_VALUE_QUALIFIER

This table is used and populated by SiteFX.

#### R_UNIT_CODE

This table allows specification of all allowed 'system' unit codes within the
database.  The values, here, are paired with R_UNIT_CONV to allow SiteFX (or
other software) to convert values to specified system units.  Note that if the
OUOM units are not found within this table when importing data, SiteFX can add
them (to both R_UNIT_CODE and R_UNIT_CONV) rather than returning a 'not found'
message (though it will write the results of an import to an external log, if
desired).  This capability is user (and system-wide) selectable.  This is
related through UNIT_CODE in D_INTERVAL_TEMPORAL_1B and D_INTERVAL_TEMPORAL_2.
A new column, UNIT_DEFAULT, allows linking of equivalent units for error
checking purposes (as used by the various V_SYS_CHK_PARAM_UNITS_\* views).

#### R_UNIT_CONV

This table allows specification of the conversion of various unit codes to
specified system units.  Paired with R_UNIT_CODE (described above) and, also,
related to R_CONV_CLASS_CODE (also described above) through CONV_CLASS_CODE.
The CONV_UNIT_OUOM unit is specified (in text) along with the related output
UNIT_CODE (as found in R_RD_NAME_CODE) and with a (possible) multiplier in
CONV_UNIT_OUOM_MULTIPLIER (as necessary; this defaults to a '1' - i.e. no
change).  This allows for parameters to be defaulted to one set of 'system'
units for all parameters imported into the database.  Where CONV_CLASS_CODE
has a

* Value of '1' ('class1') - no change save by multiplier
* Value of '2' ('soil') - ?????
* Value of '3' ('elevation') - no change save by multiplier
* Value of '4' ('depth') - no change save by multiplier
* Value of '5' ('property')

For example readings imported (i.e. reported/recorded) as 'mg/kg' would be
converted to 'ug/g' for soil samples (a CONV_CLASS_CODE of '2') and to 'mg/L'
for water samples (a code of '1').

With regard to conversion of depths to elevations, SiteFX does not use the
above table.  Instead, any of the following units (as found in
D_INTERVAL_TEMPORAL_2) are automatically converted (to 'masl') if a
'reference' elevation (as found in D_INTERVAL_REF_ELEV) is specified for the
interval.

* ftbref
* fbref
* fbtop
* fbtoc
* f
* ft
* feet
* fbgs
* mbref
* mbtop
* mbtoc
* m
* metres
* meters
* meter
* metre
* mbgs

#### R_WATER_CLARITY_CODE

This is adapted from the MOE water well database and is related through
WATER_CLARITY_CODE in D_PUMPTEST.

*Last Modified: 2022-12-14*
