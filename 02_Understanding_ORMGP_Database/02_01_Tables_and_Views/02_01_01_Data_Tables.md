---
title:  "Section 2.1.1"
author: "ormgpmd"
date:   "20221114"
output: html_document
knit:   (
            function(input_file, encoding) {
                out_dir <- '';
                rmarkdown::render(
                    input_file,
                    encoding=encoding,
                    output_file=file.path(dirname(input_file), out_dir,
                    '02_01_01_Data_Tables.html')
                )
            }
        )
---
## Section 2.1.1 Data Tables (D_\*)

Prefixed with 'D_', these tables are populated with data specific to the table
(name).  A (short) discussion of these tables, as used by the ORMGP, follows.

#### D_AREA_GEOM

This table takes uses the spatial geometry type in SQL SERVER to store various
polygons used within the ORMGP.  These include, for example, the extents of
the regions (Durham, Peel, Toronto and York) as well as the Conservation
Authority partners.  The GEOM field holds the native spatial geometry while
the GEOM_WKB holds the 'Well-Known-Binary' format.  Various views rely upon
these objects to delimit locations by area (instead of using, previously, the
D_LOCATION_AGENCY table).

#### D_BOREHOLE

This table is used to store the main details related to a well installation
including such attributes as elevation (BH_GND_ELEV), date installed/completed
(BH_DRILL_START_DATE/BH_DRILL_END_DATE), drilling method
(BH_DRILL_METHOD_CODE) and driller (BH_DRILLER_CODE), depths (BH_BOTTOM_ELEV
and BH_BOTTOM_DEPTH - as a side note if the depth is not directly provided, it
can be calculated from, or checked against, either the construction details,
found in D_BOREHOLE_CONSTRUCTION, or from geology as found in
D_GEOLOGY_LAYER).  Every well or borehole in the database should have a record
in the D_BOREHOLE table and there is a one-to-one relationship between objects
in this table and that of D_LOCATION.

In addition to wells or boreholes, additional geologic-related locations can
be found here in order to be included when working with cross-sections
(within, for example, Viewlog).  A specified top- and bottom-elevation is
required in these cases and an 'artificial borehole' record is introduced.
The following location types are can be currently found in this table

* Well or Borehole
* Archive
* Surface Water
* Outcrop
* Oil and Gas Well
* Geological Section
* Bedrock Outcrop
* Testpit

Refer to Section 2.4 with regard to the assignment of elevations within this table.

#### D_BOREHOLE_CONSTRUCTION

Construction details including depths (CON_TOP_ELEV and CON_BOT_ELEV) ,
diameter (CON_DIAMETER) and type (CON_SUBTYPE_CODE) are specified here.  This
includes information on, for example, casing(s), sand packs and seals (a
listing of construction types can be found in R_CON_SUBTYPE_CODE and
R_CON_TYPE_CODE).  Within this table, there can be many records/rows
associated with a particular borehole.  Note that the CON_DIAMETER field is
not currently converted to a standard unit system (cm) - users should refer to
the CON_DIAMETER_OUOM and CON_DIAMETER_UNIT_OUOM fields.

#### D_CLIMATE

Contains the source information from Environment Canada regarding the climate
stations within the ORMGP database.  Note that this table is infrequently used
and generally only contains historical source data (e.g. Latitude & Longitude)
that can be used for for back-checking.  Most of the information in this table
has been incorporated into the D_LOCATION table.  This table should be
discarded in a subsequent database version.

#### D_DATA_SOURCE

Used for tracking data that comes into the database and is mostly used for: i)
locations that are added (either through agencies, consultants or reports); or
ii) temporal data that has been incorporated (and includes the agency as well
as file directory structure and source name).  Even though the DATA_ID field
is present in almost all tables, it is frequently left blank or is inherited
from the same DATA_ID from the D_LOCATION table.  The overall intent of the
table is to identify the data's original source. 

This table is automatically updated when uploading temporal files (e.g. water
levels, pumping rates, etc.) through SiteFX.  When locations are being input,
or when manually uploading temporal data directly into the database this table
must be directly edited by the user.  The primary fields of interest in the
latter case are

* DATA_ID: a randomly generated integer used as a primary key in this table (i.e. this value should not be duplicated)
* DATA_TYPE: a single work describing the type of data being loaded (e.g. 'Waterlevels'); usually blank for a non-temporal data import
* DATA_DESCRIPTION: a short description of the data being imported; should usually be identified with a project and an area 
* DATA_FILENAME: the source filename (whether it be an Excel, Access or other type of file); ideally this file should be made accessible to the ORMGP to be used for back-checking in the cases of data errors/problems
* DATA_ADDED_USER: the user name, usually the users Windows or SQL login name
* DATA_ADDED_DATE: this field is automatically updated (if the information is being added by SiteFX); the date is actually when the records were added to the appropriate tables
* LOC_ID: This can be used to link a data source to a specific report within the ORMGP report library

#### D_DOCUMENT

This table holds general bibliographic information (e.g. author, date, client,
etc...) concerning documents found in the ORMGP document library.  Also
specifies whether additional data is present in the report (e.g. boreholes,
water levels, pumping, geology, etc.) and whether that information has been
entered into the database - this is enabled through a series of true/false
fields.  

Documents have been tagged as a location type (refer to R_LOC_TYPE_CODE) and
each document, if available, has coordinates associated with it allowing
plotting along with other locations.  Note that the document identifier (the
DOC_FOLDER_ID) and the title of the report is found in the D_LOCATION table in
the LOC_NAME and LOC_NAME_ALT1 fields (respectively).

#### D_DOCUMENT_ASSOCIATION

This table allows specification of a link between documents found in the ORMGP
document library and a particular location (e.g. boreholes).  This allows, for
example, the user to determine what report(s) a particular location/entity is
tied to, thus allowing back-checking of, for example, the geology or water
levels.  Any particular location can be referenced by multiple reports.

#### D_DOCUMENT_ASSOCIATION_INTERVAL

Similar to D_DOCUMENT_ASSOCIATION, this table allows a link to be specified
between documents found in the ORMGP document library and a particular
interval (e.g. screens).  Any particular interval can be referenced by
multiple reports.

#### D_GEOLOGY_FEATURE

This table is provided as support for geologic features which may not fit into
D_GEOLOGY_LAYER (see below) due to size constraints (especially with regard to
material descriptions) or for inclusion of hydrogeological features such as
water found depth (and type) or the presence of fractures or other similarly
planar features that do not necessarily have both a top and bottom elevation.
Note that this table is currently used almost exclusively for recording the
water found depths reported by drillers within the MOE Water Well database.

#### D_GEOLOGY_LAYER

This is a key table that holds the geologic record (specified by from- and
to-depths) related to a particular location (e.g. boreholes, outcrop,
trenches, etc...) describing the sequential stratigraphic layers encountered.
Note that through SiteFX, the original depths (GEOL_TOP_OUOM and
GEOL_BOT_OUOM, based on units specified in GEOL_UNIT_OUOM) are converted to
elevations for visualization or comparison based on the ground elevation in
BH_GND_ELEV from the D_BOREHOLE table.  Note that the BH_GND_ELEV value should
match that in ASSIGNED_ELEV in the D_LOCATION_ELEV table.  The longer term
intent is to remove the elevation fields from D_BOREHOLE.

Four material types can be assigned for each geological layer (additional
material types - or additional details - can be included by using the
D_GEOLOGY_FEATURE table; note that the former is discouraged).  The material
types that can be used to describe a layer are largely taken from the original
MOE database - however a few additional geological 'Materials' have been
added.  Refer to R_GEOL_MAT1_CODE ('_MAT2_' through '_MAT4_' look-up tables
are also available but each are equivalent and only used for reducing internal
database complexity) for available material types/codes.  Any layer may be
linked to a 'Geologic Formation' (see R_GEOL_UNIT_CODE) through the use of the
GEOL_UNIT field.  In addition, the incorporation of the 'GSC Codes'
(GEOL_MAT_GSC_CODE) allows for a re-interpretation (as necessary) of the
geologic layers through methodology developed by the GSC in the late 1990's.

Additional information on colour, consistency, moisture, texture and organics
can also be recorded (each has a look-up table as well).  It should be noted
however that these fields (except for colour) were incorporated into the
database as a result of their presence in the various geotechnical databases
that were merged into the Master database.  As a result they are generally not
populated for the MOE well records.  Indeed some terms such as 'Dense' are
material codes within the MOE structure.  The fields are also not accessed
readily through SiteFX.

Using the GEOL_SUBCLASS_CODE field, users can specify (as necessary) alternate
geologic descriptions/interpretations for the location/borehole (see
R_GEOL_SUBCLASS_CODE).  A value of '5' (the default) indicates the 'Original
(or Corrected)' description (if present, this value indicates that the geology
has been re-evaluated , usually by reviewing the borehole documentation, and
possibly corrected).  At present, alternate interpretations can be specified
based upon PICKS (i.e. a '4' - 'Other (e.g. Picks)') or just as 'Alternate'
(i.e. a '6'; when, for example, the database contains both an MOE description
and a consultant's original report for a borehole).  If there is a problem
with the original geologic descriptions (usually related to lack of elevations
or depths), a GEOL_SUBCLASS_CODE of '7' (i.e. 'Original (Invalid)') can be
applied.  If so, there may be a code of '6' (i.e. 'Original (or Corrected)')
applied to an alternate-corrected interpretation.  See also R_GEOL_CLASS_CODE.
For a NULL values in GEOL_SUBCLASS_CODE, it is assumed the layer to be
original/unmodified (this should be the default).

Refer to Section 3.3.4 for details-by-example regarding the assignment of
geologic information to this table.

#### D_GEOPHYSICAL_LOG_\*

This includes each of

* D_GEOPHYSICAL_LOG_DATABIN
* D_GEOPHYSICAL_LOG_FIELD_DETAILS
* D_GEOPHYSICAL_LOG_LITHO_DESCRIPTIONS
* D_GEOPHYSICAL_LOG_LOCATION_DETAILS
  
These four tables are likely to be re-evaluated in the next version of the
database in that much of the information contained in these four tables is
already located elsewhere in the database.  Together the four tables contain
the geophysical logging results from those wells that have been logged.
Viewlog currently links to these tables to display the geophysical logs in
section.  Due to the considerable size of the information related to
geophysical logging, the geophysical data is stored in the
D_GEOPHYSICAL_LOG_DATABIN table as Binary-Large-Object (BLOB) files.  As such,
specialty software (e.g. Viewlog) or queries are required to access the data.
These fields should reevaluated in a future database version.

'HoleName' is the primary key relating all the geophysical tables and
D_GEOPHYSICAL_LOG_LOCATION_DETAILS provides the link to D_LOCATION through
LocID (i.e. LOC_ID).  

#### D_GROUP_INTERVAL

This table allows intervals (based upon their INT_ID) to be associated
together based upon a GROUP_INT_CODE.  For example, all of the screens
(intervals) that have been sampled for isotopes form a group; intervals that
are measured during a pumping test could also be grouped.  The current groups
are described/listed/found in R_GROUP_INT_CODE.  

#### D_GROUP_LOCATION

Allows locations (based upon their LOC_ID) to be associated together based
upon a GROUP_LOC_CODE.  As an example, all of the PGMN wells have been grouped
together (GROUP_LOC_CODE '99').  The current groups are described/listed/found
in R_GROUP_LOC_CODE.

#### D_INTERVAL

This is a key table that houses the main information related to intervals,
where an interval is the base entity (representing real-word objects like, for
example, a well screen) for linking temporal data within the database.  All
temporal data (i.e. measured values relative to a particular date; whether it
be a water level, pumping record, surface water flow measurement,
precipitation data at a climate station, etc...) must tie to a particular
interval which, in turn (in this table), is tied to a particular location
(using the identifier fields LOC_ID and INT_ID).  Any particular location can
have multiple intervals.  So, for example, one borehole could have many
screens.  

This table does not contain much information other than the interval name
(INT_NAME, INT_NAME_ALT1) which is, in general, equivalent to that of the
LOC_NAME.  Also present is the INT_NAME_MAP field (similar to the LOC_NAME_MAP
field in D_LOCATION) which is to be used for storing 'short' names that can be
used when plotting.  The INT_TYPE_CODE, an important field, allows intervals
to be specified as a particular type (e.g. whether the particular interval is
a climate gauge, soil sample, surface water gauge, a reported screen, an open
hole in bedrock, etc...); a full list of available types is found in
R_INT_TYPE_CODE. 

A re-examination was undertaken of the use of the INT_TYPE_CODE with specific
reference to surface water stations.  As a result, these have been simplified
to two distinct types (i.e. 'Surface Water Flow Gauge' and 'Surface Water -
All').  Further distinctions have been made at the primary and secondary use
codes as found in D_LOCATION_PURPOSE.

Some locations (many located in Durham) have multiple intervals tied to
specific single screen.  In this case, the interval is recording information
based upon either of the 'raw' water samples that are being collected or the
'treated' water samples that are being analyzed.  This difference should be
captured by the INT_SAMPLE_TYPE_DESC field (a free form text field) with the
former being specified as 'raw' and the latter being specified as 'treated'.

#### D_INTERVAL_ALIAS

This table allows additional names to be associated with intervals (through an
INT_ID) as found in D_INTERVAL (note that three names INT_NAME, INT_NAME_ALT1
and INT_NAME_ALT2 are already available for naming intervals in the D_INTERVAL
table).

#### D_INTERVAL_FORM_ASSIGN

This table has been completely reevaluated (for the second time) in comparison
with previous versions of the database.  This version allows for multiple
model representations (as listed in R_FORM_MODEL_CODE) to be easily
incorporated, tracking the associated information for each model-to-interval
relationship.  

Multiple geologic models (incorporated into the ORMGP program) have been
interpreted for each interval present in this table.  Any particular interval
can be found to be in a different geologic unit depending upon the geological
interpretation at the time of the surface/model construction.  Note that these
are updated automatically (refer to Appendix G for details) when any relevant
information (e.g. coordinates or depths) are changed.

Further details and how the table is populated can be found in Sections 2.4.1
and 2.4.5.

Only intervals (i.e. INT_ID's) found in either of D_INTERVAL_MONITOR or
D_INTERVAL_SOIL (with valid top- and bottom-elevations/depths) will be present
in this table.  The fields in the table include:

* ASSIGNED_UNIT is the geologic unit, for this particular geologic model to which the interval is assigned (see FORM_MODEL_CODE)
* FORM_MODEL_CODE identifies the geologic model to which this record for this interval applies (where there will be one record for each interval for each geologic model being examined)
* SLAYER is the surficial geologic unit for this location/interval.
* TLAYER is the geologic unit in which the top of the interval lies
* BLAYER is the geologic unit in which the bottom of the interval lies
* PLAYER is the previous/upper geologic unit above the top of the interval
* PLAYER_VDIST is the distance from the top of the interval to the top of the previous geologic unit
* TNLAYER is the next geologic unit down from the top of the interval
* TNLAYER_VDIST is the distance from the top of the interval to the top of the next geologic unit (down from the top of the interval)
* NLAYER is the next geologic unit down from the bottom of the interval
* NLAYER_VDIST is the distance from the bottom of the interval to the top of the next geologic unit (from the bottom of the interval)
* BPLAYER is the previous geologic unit up from the bottom of the interval
* BPLAYER_VDIST is the distance from the bottom of the interval to the top of the previous geologic unit (from the bottom of the interval)
* THICKNESS_M is the thickness of the geologic unit (normally an aquifer) to which this interval has been assigned (as stored in ASSIGNED_UNIT)
* T is the Transmissivity (m2/s; also T_SCR)
* K is the Hydraulic Conductivity (m/s; also K_SCR)
* T_ITER is the number of iterations necessary to calculate T (also T_ITER_SCR)
* T_ERR is the final calculated error difference between this calculated T and the previously calculated T (also T_ERR_SCR)
* SC_LPMM is the calculated Specific Capacity incorporating Well Loss (liters-per-minute per metre; also SC_LPMM_SCR)

The second set of calculated fields, namely those with *_SCR* appended, use
the screen length to calculate the particular parameter instead of using the
THICKNESS_M value.  The methodology is otherwise equivalent.

#### D_INTERVAL_FORM_ASSIGN_FINAL

The ASSIGNED_UNIT for the specific INT_ID in this table  is considered to be
the 'best guess' allowing a complete geologic representation across the entire
study area using the various available models.  Refer to Section 2.4.1 for
details on how this field is populated and for a listing of the geologic
models evaluated.

The fields in the table include:

* ASSIGNED_UNIT is the appropriate 'final' (or 'best') geologic unit that should be associated with this interval based upon the geologic models represented in D_INTERVAL_FORM_ASSIGN (see OVERRIDE_UNIT for an exception)
* OVERRIDE_UNIT is the geologic unit which should be assigned to this interval; if populated, this field will take precedence over any geologic unit found in D_INTERVAL_FORM_ASSIGN; values should be assigned to this field only until an appropriate geologic model is representative for this interval at which point the field should be set to NULL
* MANUAL_UNIT is the geologic unit which has been defined for this interval by some trusted, external source (e.g. a high-quality consultant report) - either of the DATA_ID or FINAL_COMMENT fields should indicate this source; this is for reference or historical purposes only (and can be used to temporarily populate OVERRIDE_UNIT)

#### D_INTERVAL_MONITOR

This table provides details of the (possibly assumed) screened interval for,
in general, well or borehole locations.  In many cases, when reported, the
screen top and bottom depth are provided - these are (subsequently) converted
into elevations (usually by SiteFX).  For wells that have no reported screen,
the database defaults to assigning a one foot long screen (or 0.3m for those
wells whose OUOM units are metric) just above the bottom of the hole (this
"Assumed Screen" type of interval is captured in the R_INT_TYPE_CODE table).
There can only be one interval monitor record for each interval. 

The following interval types are currently found in this table

* Assumed Open Hole (Bot. of Casing to Bot. of Hole)
* Assumed Open Hole (Top of Bedrock to Bot. of Hole)
* Assumed Screen (Overburden Well, 1ft Screen assigned); this is assumed to be above the bottom of the borehole/well
* Assumed Screen (Top/Bot of info only); this is usually applied when only a single (top or bottom) depth value is present, usually from D_BOREHOLE_CONSTRUCTION; a 1 ft screen is assumed
* Pumping Station
* Reported Open Hole
* Reported Screen
* Screen Information Omitted
* Surface Water Spot Stage Elevation (this should be removed)

#### D_INTERVAL_PROPERTY

This table is currently underutilized and will be re-evaluated in the next
version of the database.

#### D_INTERVAL_REF_ELEV

Water levels measured in a well are generally taken either from the 'Top of
Pipe' (or reference point) or from ground surface.  In order to convert
recorded water level depths to elevations, the elevation of this 'reference'
point is recorded in this table.  Each REF_ELEV (reference elevation) value
has a start and end date tied to it, bracketing the period at which any
particular elevation is applied.  Multiple elevations resulting from, for
example, damage to the monitoring pipe that modify the reference elevation are
recorded in this way.  For locations where no reference elevation has been
recorded, a default 0.75m stick-up is assumed and the ASSIGNED_ELEV from
D_LOCATION_ELEV is used as a ground level (this information is stored in the
REF_COMMENT field and is generally of the form 'ASSIGNED_ELEV + 0.75m').  A
new field, REF_STICK_UP, is used to store the height of the reference point
(above the ground surface) in meters.  New SiteFX fields (REF_OFFSET,
REF_OFFSET_OUOM and REF_OFFSET_UNIT_OUOM) now perform the same function.  All
the numeric values previously held (as a temporary measure) in REF_POINT have
been copied into REF_STICK_UP.

In the case that no valid date exists in REF_ELEV_START_DATE for a particular
interval, the default non-null value '1867-07-01' or '1967-07-01' will be
assumed (as a marker).   Note that a valid date must exist for comparison
purposes.

#### D_INTERVAL_SOIL

The top and bottom elevations (converted, generally, from depths) from which a
soil sample is taken are recorded here, allowing temporal data to be
associated with the sample (including laboratory and other physical/field
measurements).  The table also directly houses three specific soil related
measurements: the actual blow count necessary for penetrating a 6-inch depth
when split-spoon sampling; the recovery percentage; and the estimated moisture
percentage.  Note that each of these are 'field' measurements.

For those soil intervals without a top- or bottom-depth (one of, not both), an
assumed 0.1m depth is assigned.  An appropriate comment is also included in
SOIL_COMMENT.

#### D_INTERVAL_TEMPORAL_\* Tables

The volume of temporal data increases rapidly in comparison with the location
data.  As such (especially with regard to D_INTERVAL_TEMPORAL_2), accessing
these tables can be slow in comparison with other D_* tables.  Through the use
of indexing (and etc...) efforts have been made to optimize these tables to
reduce access times.  The use of D_INTERVAL_TEMPORAL_3 (previously unused) has
now been implemented.

#### D_INTERVAL_TEMPORAL_1A and D_INTERVAL_TEMPORAL_1B

These tables record the results from samples that have been taken from a
specific interval (usually a well screen) and sent to a laboratory for
analyses.  Laboratory (e.g. Lab ID, Lab sample #, etc.) and sample information
(sample date, sample type - water vs soil, etc?) are recorded in table '1A'
and the results of the sample analysis (individual parameters such as Mg, Na,
etc.) are recorded in table '1B'.  The testing of one sample for many
parameters (e.g. testing for Fe, Ca, Mg, etc...) results in multiple records
(one row for each parameter) in '1B' but only a single record (one row for the
sample) in '1A'.  Parameter names/codes are listed in the R_RD_NAME_CODE
table.

Note that a particular parameter may have multiple real-world names associated
with it due to different laboratory reporting terms (e.g. Zinc (total); Zinc
as Zn; Zn; Zinc by ICPMS; Zinc (ICPMS)); the R_RD_NAME_CODE table should have
only one of these names available, the one most commonly used (or chosen as
most applicable by the ORMGP).  The R_READING_NAME_ALIAS table contains those
additional names tagged to a particular value RD_NAME_CODE - on import into
the database, these 'aliases' are converted to the appropriate (single)
reading name code.

#### D_INTERVAL_TEMPORAL_2

This table records any 'field' data for a particular interval for a particular
date.  For these measurements there is no need to track a sample or
laboratory, therefore the data need only be added to one table.  This results
in one parameter per record/row.  Water levels (both logger and manual) and
stream flow data would be prime examples of information stored herein.
However, the table also holds some field measured pH, conductivity and other
similar data.  Parameter names are listed in the R_RD_NAME_CODE table.
Additional information (where available) regarding the instrumentation used
for collecting the particular value can be recorded in RD_TYPE_CODE - refer to
the R_RD_TYPE_CODE look-up table for available types.

Refer to the above discussion (under D_INTERVAL_TEMPORAL_1A) with regard to
the reading name codes (RD_NAME_CODE) and the use of aliases in the database.

#### D_INTERVAL_TEMPORAL_3

A similar description applies here as to that of D_INTERVAL_TEMPORAL_2.
However, as of 'Database Version 6', this table contains information available
from climate stations (which previously resided in the second temporal
table).

#### D_INTERVAL_TEMPORAL_5

A similar description applies here as to that of D_INTERVAL_TEMPORAL_2.
However, as of 'Database Version 6', this table contains information available
from surface water stations (which previously resided in the second temporal
table).

#### D_LOCATION

A location is a natural, constructed or artificial (i.e. a place-holder)
object and is the primary means of representing real-world entities (e.g. a
borehole, climate station, surface water gauge, documents, etc...) within the
database.  Refer to R_LOC_TYPE_CODE for a list of available location types.
D_LOCATION should be considered the central table in all database queries by
users where information is being sought on an object-by-object basis.

Locations should never be deleted from the database (an exception would be in
the case of duplicates); for those locations that cease to be in operation,
its status would be changed from active to either inactive, decommissioned,
abandoned or archived (as appropriate).

The key fields found within this table relate to two main features of a
location:

* Naming; there are five naming fields available in this table - LOC_NAME, LOC_NAME_ALT1, LOC_NAME _ALT2, LOC_ORIGINAL NAME, LOC_NAME_MAP
* Spatial location (LOC_COORD_EASTING, LOC_COORD_NORTHING); all locations are
* re-projected (if necessary) to NAD83, UTM Zone 17 (the original coordinates
* are stored in the equivalent '_OUOM' fields); a coordinate tracking system
* has been implemented within the table D_LOCATION_SPATIAL_HIST

Other more minor attributes of a Location that are stored in this table include:

* the Lot and Concession (mainly from the MOE) 
* Ownership information (for owners of many wells; e.g. York Region);
* Location status (e.g. active, decommissioned, in-active, etc.)
* Address and Contact info
* Confidentiality code (not currently used but established to assist in screening locations that are not to be widely circulated (set by partner agencies)

Regarding the naming of locations, the following general guidelines are provided: 

* LOC_NAME is intended to be relatively short for easy display purposes
* LOC_NAME_ALT1 is intended to convey information about consultants, geography and/or location ownership
* LOC_ORIGINAL_NAME is primarily used for the MOE identification number or as the original name of the well (also found in D_LOCATION_ALIAS); where the well is not a part of the MOE database, the original name can reflect the name assigned by the consultant/owner at the time of drilling; in some cases, this identifier is currently the same as the LOC_NAME
* LOC_NAME_ALT2 - this field is currently not used to any great extent; in the future we could add in the MOE's Tag Number or Audit Number (these are both currently found in the D_LOCATION_ALIAS table)
* LOC_NAME_MAP - this name is limited to 6 characters and is designed to show a very localized name that would show up easily when posted in a map 

When assigning a name to a new location, the user should think about key
features of the name that might be used by someone in the future if they were
querying to see if the location is in the database.  Due to the high incidence
of duplicates over the past few years the naming of key wells has become much
more explicit so that the chances of someone re-entering a well are
minimized.

Additional details regarding naming conventions are outlined in Section
3.3.1.

One method of associating locations is through the LOC_MASTER_ID field.  If
the LOC_ID and LOC_MASTER_ID fields are equivalent, it indicates that no other
locations have been linked (or are associated) to this one.  Alternatively, if
the LOC_MASTER_ID differs from the LOC_ID, it indicates an association between
locations.  In such a case the LOC_MASTER_ID would be set as the LOC_ID from
the 'master' location.  An example of its use is the tracking of MOE WWDB
nested wells.  Also, updated surface water stations are linked to their
old/original locations in this manner.

Through the D_GROUP_LOCATION table, locations can also be grouped into
families to reflect (for example) nested monitoring wells or an amalgamation
of locations (such as a pump house).

#### D_LOCATION_ACTIVITY

This table is, currently, not actively used and will be re-evaluated in the
next version of the database.

The original intent of the table was to track significant changes occurring
within the database.  'S_' system tables have now replaced the need for this
table's functionality.

#### D_LOCATION_ALIAS

Where additional names (beyond the number currently available in D_LOCATION
table) are required (or known) for a particular location, these names are
stored here, tagged by their LOC_ID.  For the more recently drilled MOE wells,
the Audit Number and the Tag Number are stored in this table.  As of 'Database
Version 6', the MOE 'Well_ID' and 'Bore_Hole_ID' are stored here as well.

SiteFX looks at this table (as well) when searching for a specified location
name.

#### D_LOCATION_ATTR

Attributes for a particular location that don't fit into the various
fields available in the location-based data tables (i.e. those tables that
contain a LOC_ID column) can be stored here.  These attributes are defined
using the ATTR_CODE field (which links to the R_ATTR_CODE table).  Similar in
structure to the S_CONSTANT table, the attributes can be integer (VALI),
floating point (VALF) or character values (VAL_DEF).  Ranges of values can be
specified using the secondary field available for each the previous types.

As an example, for surface water stations, the stream segment identifier along
which a location occurs is now stored here as opposed to being available
through the D_SURFACEWATER table.

#### D_LOCATION_GEOM

This table holds the spatial geometry of each location using both the
Microsoft SQL Server geometry type (GEOM) as well as the 'Well-Known-Binary'
format (GEOM_WKB).  Not all external software supports both formats.  These
are calculated from the coordinates in D_LOCATION and are assigned the 'UTM
Z17 NAD93' projection (EPSG code 26917).  For tracking of changes in the
coordinate values (in D_LOCATION), the COORD_CHECK field is incremented
(initially from a NULL value to '1') whenever the calculated geometry differs
from that stored in this table.  This acts as a tag to indicate that the
location should be checked.

#### D_LOCATION_PURPOSE

This table records the primary and secondary purpose codes for each location.
The available codes are an amalgamation of those from the original MOE Water
Well database, but they have been supplemented, largely (but not exclusively)
from the purposes used to track MOE issued Water Taking Permits (refer to
R_PURPOSE_PRIMARY and R_PURPOSE_SECONDARY for details).  Note that, for the
MOE wells, many of the purpose classifications were based upon the original
well owner's name (e.g. wells drilled for a church could reasonably accurately
be coded with a PURPOSE_PRIMARY_CODE of '1' - 'Water Supply' and a
SECONDARY_PURPOSE_CODE of '53' - 'Church').  With the removal of this
information after 2006 (due to privacy concerns), this coding ability has been
lost and therefore, the purpose codes for more recently incorporated wells
less accurately reflect their purpose.

Note that the MOE still maintains a mix of purpose and status in the 'Status
Field' within their database (e.g. Water Supply, Observation Wells,
Abandoned-Supply, etc...).  This MOE code is currently stored in the BH_STATUS
field of the D_BOREHOLE table.  The MOE also maintains the USE_1ST and USE_2ND
fields, which are stored in the equivalent LOC_MOE_USE_1ST and LOC_MOE_USE_2ND
fields in the D_LOCATION table (in the ORMGP database).  These fields are now
used to translate a code into the LOC_PURPOSE table for the newly imported MOE
wells (refer to Appendix G for the methodology).

#### D_LOCATION_QA

This table provides two major fields for tracking uncertainty, both of which
originated with the MOE water well record database:
* the QA_COORD_CONFIDENCE_CODE tracks errors associated with the coordinates (e.g. horizontal error); refer to R_QA_COORD_CONFIDENCE_CODE for error values
* the QA_ELEV_CONFIDENCE_CODE tracks errors associated with the elevation (e.g. vertical error); refer to R_QA_ELEV_CONFIDENCE_CODE for error values

Within the ORMGP database the functionality of the QA_ELEV_CONFIDENCE CODE has
been redesigned to simply record whether a particular location has had its
elevation accurately surveyed or a DEM value assigned.  A
QA_ELEV_CONFIDENCE_CODE of '1' indicates that the location has been surveyed
and a DEM elevation will not be assigned (note that the QA_ELEV_SOURCE,
QA_ELEV_METHOD and QA_ELEV_COMMENT fields can be used to store information
regarding the type of survey undertaken).  All other locations are regularly
assigned an elevation from the most up-to-date DEM surface as supplied via the
MNR (see D_LOCATION_ELEV and D_LOCATION_ELEV_HIST, above, for details).  Any
legacy QA_ELEV_CONFIDENCE CODES (i.e. those greater than 1 with the exception
of the DEM codes) found in the table no longer serve any practical function.

As a general rule a QA_COORD_CONFIDENCE_CODE value of '5' or less (i.e.
equivalent to a maximum tolerance of 300 m or less horizontal error) is used
to separate 'good' locations from 'erroneous' locations.  The QA codes are
included in all of the views (i.e. built-in queries) within the database so
that the user can specify or define their own QA acceptability when querying
the database.

In the case of reassignment of the original MOE (assigned) coordinate
confidence code (i.e. through re-evaluation of the location), the original MOE
value will be stored in QA_COORD_CONFIDENCE_CODE_ORIG and the value then
replaced (by the updated value) in QA_COORD_CONFIDENCE_CODE.  In particular,
this has been used where the coordinates are obviously wrong and have been
assigned a new code of '117' (i.e. 'Outside of Ontario or Invalid').

Two fields, the QA_PUMPING_CODE, and QA_WL_STATIC are currently under
evaluation and contents should be ignored.  The QA_DATA_SOURCE_CODE reflects
the MOE coding of the location (well) source (typically the code for MOE wells
is '1', 'from Driller'); refer to the R_LOC_DATA_SOURCE_CODE for possible
codes.  This field has not been populated for any of the non-MOE wells in the
database.

Note that all Locations in the D_LOCATION table should have an associated
record in this table.

#### D_LOCATION_QC

Records are added to this table in order to track checks or changes to
locations (and associated intervals) within the database.  This is used to
prevent unnecessary re-examination of data for possibly problematic data for
locations that have already been checked or corrected.  The marked
check/correction can be table-general (e.g. pumptest and pumping rates)
through table-field specific (e.g. screen top and bottom depths).  This is
indicated by the CHECK_CODE (indicating the actual check performed) and
CHECK_PROCESS_CODE (indicating the success or failure, in various ways, of the
check or correction).  These are referenced through R_CHECK_CODE and
R_CHECK_PROCESS_CODE.  Note that there will (likely) be multiple records per
location as each could describe a separate check undertaken (and possibly at
another date, as indicated by PROCESS_DATE).  The INT_ID should only be
populated when the check is performed against an interval (linked to a
location).  An additional COMMENT can be included to more fully describe the
information being evaluated.

#### D_LOCATION_SPATIAL

This table holds the SPAT_ID (linked to D_LOCATION_SPATIAL_HIST) which is
considered current to the location.  The view V_SYS_LOC_COORDS will use this
relationship to return these coordinates and elevation for this location.

#### D_LOCATION_SPATIAL_HIST

This table tracks changes in the coordinates for a particular location.  All
coordinates that have been assigned/used by a location should be stored here;
the current coordinates will be indicated through the
LOC_ID/SPAT_ID values in D_LOCATION_SPATIAL.  The QA codes for both coordinate
and elevation data will also be represented here.

The X and Y fields are the default coordinates for the program and should
match LOC_COORD_EASTING and LOC_COORD_NORTHING (respectively) in D_LOCATION
(i.e. they are all UTM Zone 17, NAD83 datum coordinates; this will be matched
with a '26917' value in EPSG_CODE).  Their equivalent latitude and longitude
values (also with a datum of NAD83) are also stored here (and accessed by
applications whose default coordinates are latitude/longitude).  Additional
EPSG codes may be specifed for the LAT and LONG fields as well as the _OUOM
fields.

The LOC_COORD_HIST_CODE and LOC_ELEV_CODE field are used to track the source
of the possible changes in the coordinate and elevation values.  Comments
concerning the coordinate source and method(s) used can be found in
LOC_COORD_METHOD, LOC_ELEV_METHOD, LOC_COORD_COMMENT and LOC_ELEV_COMMENT.
The LOC_COORD_DATE and LOC_ELEV_DATE will match if the source of each set of
values was the same; they will otherwise pertain to their souce data (for
example in the case where an elevation is from a specified DEM - the
LOC_ELEV_DATE should match the this data source).

#### D_LOCATION_SUMMARY

This table stores weekly-calculated or -updated information for each location
in D_LOCATION; the main purpose of which is to speed up various general views
available to users of the database (instead of calculating these values
on-the-fly).  Some of the data here, normally tied to intervals, is summarized
for all intervals found at the particular location.

#### D_LOCATION_VULNERABILITY

This is a legacy table from an exercise carried out in 2003 for the MOE to
delineate areas on the Oak Ridges Moraine that were potentially vulnerable to
contamination.  The values (0, 1, or 2) in the 'AVI_Feb2003_Final 3tier' field
are directly tied to a Low/Med/High vulnerability based on the 2003 procedure
as agreed to by the MOE at the time.  These values directly correlate to and
are reflected in the vulnerability map that constitutes part of the ORM
Conservation.  This table should be reevaluated in a future version of the
database.

#### D_LOGGER_CALIBRATION_READINGS

This table is required by and is populated through SiteFX.  This table is used
for the import of logger data.  Further details ???

#### D_LOGGER_CORRECTION

This table is required by and is populated through SiteFX.  This table is used
for the import of logger data and identifies when logger data has been
adjusted by a fixed amount to match a manual measurement.   Further details
???

#### D_LOGGER_INVENTORY

This table is required by and is populated through SiteFX.  This table is used
for the import of logger data.  Further details ??? 

#### D_LOGGER_NAME

This table is required by and is populated through SiteFX.  This table is used
for the import of logger data and tracks the name of loggers and the interval
that they are associated with.  

#### D_OWNER

This table was created prior to the MOE removing the OWN_NAME from their
database for concerns of privacy.  At the time, the table was meant to provide
a useful searching and/or grouping tool particularly for Municipal and
Conservation Authority wells, but it also allowed wells drilled by larger
companies (e.g. development companies) or other organizations (e.g. Ontario
Hydro) to be grouped together.   The owners listed here are linked to
D_LOCATION through OWN_ID.  With the onset of the D_GROUP_LOCATION table the
need for the D_OWNER table has diminished and the role this table plays in
future versions of the database will be re-evaluated.t

#### D_PICK

This table was previously referenced as PICKS.  The table contains the
FORMATION name (e.g. 'Top of Thorncliffe Fm') and the elevation of the pick
(TOP_ELEV) as well as the user who made the pick (SYS_USER_STAMP) and the time
(SYS_TIME_STAMP) at which it was made.    The current ground elevation
(GND_ELEV) for the location is also stored.  The field GEOL_UNIT_CODE is
currently non-populated - in the future this should be used as an alternate to
the text field FORMATION.  The SESSIONNUM field is mainly historical,
originally used to identify distinct sessions when incorporating pick
information from multiple Microsoft Access databases. 

Each pick row is linked to D_LOCATION via its LOC_ID.

In some instances, multiple formations are specified within the FORMATION
field.  This was used to facilitate *pinch-outs* of overlying units.  The last
unit specified has the value of TOP_ELEV.

#### D_PICK_EXTERNAL

Similar to D_PICK, the records in this table contain formation information
(using both the FORMATION and GEOL_UNIT_CODE fields) tied to a specific
coordinate (x,y) location as well as an elevation (z).  These do not
correspond, however, to the database location schema but are instead
self-referencing where all information concerning a record occurs either
within this table or within the linked data source (through DATA_ID which must
be populated).  This includes the various quality assurance information
(normally found in D_LOCATION_QA) as well as supplementary elevation
information (as found in D_LOCATION_SPATIAL_HIST).  In particular, the latter
should reference the particular ground surface elevation (usually a DEM) used
as a reference base while the RD_VALUE_OUOM should be populated using the
depth of the 'pick'.  This latter value can be calculated if the original
value was an elevation.

The date of the source (or the source data) should be included in the PDATE
field (which should match Z_DATE unless this was calculated using a difference
source).  The default mode is a single record equated to a single 'pick'.  In
the case where a polyline (or polygon) was used to to capture coordinate
information and its original form is important with regard to its inclusion
within the database, the PGROUP field can be used to 'name' the associated
records and their order can be specified within the PORDER field.  In most
cases these fields will not be populated.

This table was first used to capture outcrop locations (and their elevation)
from the Gao et al (2006) dataset.

#### D_PROJECT_LOCATION

Currently empty.  This table is part of the structure for a future release of SiteFX (version 6; some support in version 5) and is to be used to control access (by partner agencies) to locations within their areal extent.  This is part of the replacement for the original D_LOCATION_AGENCY table and relates to D_LOCATION using LOC_ID.

#### D_PROJECT_USER_GROUP

Currently empty.  This table is part of the structure for a future release of
SiteFX (version 6; some support in version 5) and is to be used to control
access (by partner agencies) to locations within their areal extent.  This is
part of the replacement for the original D_LOCATION_AGENCY table and relates
to R_PROJECT_TIER2_CODE using PRJ_TIER2_CODE.

#### D_PTTW

This table incorporates information from the 'Permit to Take Water'
spreadsheet available through the MOE.  The methodology for doing so is
described in Appendix G.  Note that when possible, the particular permit (a
location type) has been linked to a source location (e.g. a well) through the
LOC_MASTER_LOC_ID in D_LOCATION.

The interpreted source type (PTTW_SOURCEID_CODE) and water type
(PTTW_WATER_SOURCE_CODE; either, or both, of ground or surface water) is
identified.

#### D_PTTW_RELATED

This table specifically links all permits tied together through subsequent
permit numbers (PTTW_PERMIT_NUMBER in D_PTTW; e.g. renewed permits) as
indicated by a PTTW_PERMIT_NUMBER having a PTTW_AMENDED_BY or PTTW_EXPIRED_BY
in D_PTTW (where these new permits could, again, have been expired or amended;
this is considered a left-to-right relationship).  The INVERSE_RELATED field
(a true/false field) indicates where a PTTW_PERMIT_NUMBER is referenced by
either PTTW_AMENDED_BY or PTTW_EXPIRED_BY (a right-to-left relationship; i.e.
the inverse of the previous) only. 

#### D_PTTW_RELATED_SRC

This table has been implemented as an alternative to the general relation
between a PTTW record and a location based upon the LOC_MASTER_LOC_ID of the
former.  Here, they are directly tracked using LOC_ID and LOC_ID_SRC; the
latter will indicate the location of the water source.  In some cases, a
single permit may reference more than a single source.  In addition, a single
location may have more than one interval - the INT_ID_SRC ties the permit to
the specific interval for the given location.

#### D_PUMPTEST

Most of the information in the table comes from the MOE database and contains
the date and time of the pump test and the driller's recommended pump rates
and depths deduced from the test properties of the overall pump test.  Note
that the actual pumping values (and times) are found in the
D_INTERVAL_TEMPORAL_2 table.  

#### D_PUMPTEST_STEP

This table lists the pump rate (and units) of each step for each pump test
(along with the duration).  Note that all pumping values (and times) are found
in the D_INTERVAL_TEMPORAL_2 table. 

#### D_SITE

This table is required by SiteFX and allows locations to be linked to a
particular site or project.  This table contains a single record - indicative
of the ORMGP 'site' (a value of '1') - this links to the SITE_ID column in
D_LOCATION (which must be populated).

#### D_SURFACEWATER

The use of this table is disparaged.  It was originally implemented to capture
specific information related to surface water stations within the database
(i.e. LOC_TYPE_CODEs of '6').  This included drainage area and the original
elevation and coordinates for the particular location.  This information
should now be captured in the D_LOCATION_ATTR table.

In addition, the various subtypes of surface water locations could be found
here (e.g. FWIS locations, spotflow locations, etc...) outside of that
specified in D_INTERVAL.  This capability has been shifted to the
D_LOCATION_PURPOSE code where existing and new purpose codes have been
incorporated to capture these surfacewater subtypes.

The former means of associating surface water locations based on their
occurrance along a stream segment has been shifted to the D_LOCATION_ATTR
table.

#### D_VERSION

This table is required by SiteFX and contains the 'Database_Version', used
internally by that program.

#### D_VERSION_CURRENT

This table contains the current primary and secondary versions (i.e. the dated
version) of the database.  The single row, here, is accessed when distributing
a subset of the database to specify the PRIMARY_VERSION and SECONDARY_VERSION
(as well as the CUT_VERSION which is populated in the output database) within
the distributed database itself.  This specific combination of primary and
secondary codes are directly linked to D_VERSION_CURRENT_HIST which contains
specific information concerning the various database versions.

The VERSION_COMMENT should be updated whenever the SECONDARY_VERSION is
changed (it should provide an explanation for the change and should also be
captured in D_VERSION_CURRENT_HIST).  This information should also be tracked
in Appendix E (the Database Timeline).

#### D_VERSION_CURRENT_HIST

This table contains the description for each combination of primary and
secondary database versions and updates (these are dated versions, i.e. with
format [yyyymmdd]).  A primary and secondary version comment should describe
the update of modification of the database.

#### D_VERSION_STATUS

This table captures the 'status' of the database at various stages, tied to
the 'Dated Version' (both primary and secondary).  This includes the number of
records for each available location type, each available interval type and
each available reading group code type.

*Last Modified: 2022-11-14*
