---
title:  "Section 2.1.1"
author: "ormgpmd"
date:   "20250909"
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

Prefixed with *D_*, these tables are populated with data specific to the table
(name).  A (short) discussion of these tables, as used by the ORMGP, follows.

#### D_DATA_SOURCE 

This table is mainly used for tracking data that is imported into the
database.  In the past, this has been focused on locations or temporal data
(either through agencies, consultants or reports).  Almost all tables now
include a DATA_ID field which can be used to link records to a data source
within this table.  When a previously imported record is updated, for example,
if the DATA_ID is not already filled, the new DATA_ID can be added to
reference the source of the modification.  For older records, the DATA_ID
field will likely be blank.

The primary fields of interest within this table include:

* DATA_ID - The primary key in this table (automatically assigned); this value
  is used to link records in other tables to a particular record souce in this
  table
* DATA_TYPE - A word or short phrase that describes the type of data being
  loaded (e.g. 'Waterlevels'); an attempt should be made to include
  information within this field; note that this is a text field instead of a
  coded field (allowing for cases where multiple type of data are being
  imported 
* DATA_DESC - A short description of the data being imported; this should
  usually be identified with a project and an area 
* DATA_FILENAME - The source filename (whether it be an Excel, Access or other
  type of file); ideally this file should be made accessible to the ORMGP as
  it can be used for back-checking in the case of possible data errors or
  other problems
* DATA_ADDED_USER - The user name of the person adding the record (note that
  his is also captured in SYS_USER_STAMP); this is typically the users network
  login name (or, potentially, a SQL Server login name)
* DATA_ADDED_DATE - The date at which the actual records (that this data
  source record references) is loaded into the database; note that this may
  not necessarily match the SYS_TIME_STAMP date

#### D_GRP_INT

This table allows intervals (using INT_ID) to be associated together based
upon a GRP_INT_CODE.  For example, all of the screens (intervals) that have
been sampled for isotopes form a group; intervals that are measured during a
pumping test could also be grouped.  The current groupings (along with the
names of the groups) can be found in R_GRP_INT_CODE.  An optional
GROUP_INT_ORDER can be specified which would list the order in which the
intervals are to be accessed or considered.

#### D_GRP_LOC 

This table allows locations (using LOC_ID) to be associated together based
upon a GRP_LOC_CODE.  As an example, all of the PGMN wells have been grouped
together (GRP_LOC_CODE *99*).  The current groupings are found in
R_GRP_LOC_CODE.  An optional GROUP_LOC_ORDER can be specified which would list
the order in which the locations are to be accessed or considered.

#### D_GRP_OTH 

Unlike D_GRP_INT and D_GRP_LOC, this table allows arbitrary groups to be
created.  Any identifier can be stored in the OTH_ID field and the grouping
(and grouping type) will control how the group is to be handled by the
database.  As an example, the R_RD_NAME_CODE table records a group code
(linked to R_RD_GROUP_CODE) for each parameter allowing grouping by the
chemistry analysis type (any of *Water - Major Ions*, *Chemistry - Metals*,
etc...).  This allows only a single parameter-to-group specification.  Adding
RD_NAME_CODE values to this table (i.e. D_GRP_OTH) allows a single parameter
to be part of any number of chemsitry groups (as required).  An optionl
GROUP_OTH_ORDER can be specified which would list the order in which the
records are to be accessed or considered.

#### D_INT 

An interval is a base entity which is used to represent real-world objects
(e.g. a well screen) to which temporal data can be linked.  Each interval is
tied, in turn, to a specific location as found in D_LOC.  Any particular
location can have multiple intervals associated with it (e.g. one borehole
could have many screens installed within it; each would have a separate
interval assigned).  Interval types are specified through the INT_TYPE_CODE
field which links to R_INT_TYPE_CODE (examples include climate stations, soil
samples, reported screens, etc...).  For surface water intervals, though,
only two general types are available (i.e. *Surface Water Flow Gauge* and
*Surface Water - All*); further distinctions are made using the primary and
secondary codes (by location) as found in D_LOC_PURPOSE.

The names assigned each interval through the fields INT_NAME, INT_NAME_ALT1
and INT_NAME_ALT2 tend to correspond to the LOC_NAME (from D_LOC).  A short
form of the name is usually available in INT_NAME_MAP and can be used for
display or mapping purposes.

Some locations (many found within Durham Region) have multiple intervals tied
to a specific single screen.  In this case, the interval is likely recording
information based upon whether *raw* or *treated* water samples are being
collected and analyzed.  The name of the interval generally reflects this
difference.  Sample data, when entered into the database, should also capture
the these differences through the use of the SAM_TYPE_CODE field (in
D_INT_TEMPORAL_1A).

#### D_INT_ALIAS 

This table allows (any number of) additional names to be associated with
intervals found in D_INT; these are referenced by their INT_ID. Note that text
fields in D_INT (e.g. INT_NAME, INT_NAME_ALT1 and INT_NAME_ALT2) are also
available for the naming of intervals.  Specific alias types are assigned
through the INT_ALIAS_TYPE_CODE field (linking to the R_INT_ALIAS_TYPE_CODE
table).  This has been used, for example, to match intervals between disparate
databases that correspond to the same general schema as the ORMGP database.
If the name used is entirely numeric (and a whole number), it is converted and
used to populate INT_NAME_ALIAS_ID.

Refer also to D_LOC_ALIAS (which performs a similar function for locations).

#### D_INT_ATTR 

Attributes for a particular interval that do not fit easily into the variety
of fields available within the interval based data tables (i.e. the D_INT\*
tables) can be stored here.  Specific types are assigned through the ATTR_CODE
field (which links to the R_ATTR_CODE table).  

The depth information associated with intervals (for certain interval types)
is found here.  This replaces the use of specific tables such as
D_INTERVAL_MONITOR and D_INTERVAL_SOIL from previous versions of the ORMGP
database.  In general, the top and bottom depths of the particular interval
are recorded.  The INT_TYPE_CODE (from D_INT) will specify whether the depths
have been reported or if they've been assumed (or calculated) based upon
alternate information.  For example, where only casing information has been
included, the bottom of the screen is specified as one foot below the bottom
casing depth specified.  Refer to R_INT_TYPE_CODE for further details.

Numeric attributes can be stored in either the VALI field for integers or VALF
field for real numbers.  Ranges can be specified using the matching fields
available, i.e.  VALI2 and VALF2.  Both default and text attributes can be
stored in VAL_DEF (and VAL_DEF2); note that this can include date-formatted
information.

Where data (e.g. temperature and conductivity) is collected for a particular
interval (e.g. a screen) for a series of depths, these depth values can be
captured here (using TOPD for top depth and TOPB for bottom depth).  Readings
taken at these depths can then be stored (referenced using the IATTR_ID field)
within the D_INT_ATTR_RD table.  This set of psuedo-intervals could then be
grouped based upon their DATA_ID (or through the D_GRP_OTH table).

Refer also to D_LOC_ATTR (whcih performs a similar function for locations).

##### D_INT_ATTR - Screened Intervals

Certain information is captured along with the depths associated with a
screen.  These include:

* VALI - Flowing; a non-null tag indicates that this is a flowing screen
* VAL_DEF - Screen Material
* VAL_DEF2 - Observed Screened Material; at the time of installation, this is
  the geologic material in which the screen was placed

These would have formerly been found in D_INTERVAL_MONITOR in the previous
versions of the ORMGP database.  Additional attributes of the screen would
then be found in the D_INT_ATTR_RD table (linked by IATTR_ID).  This includes,
for example, screen diameter and screen slot size.

##### D_INT_ATTR - Soil Intervals

Most soil intervals have limited data associated with them, usually available
upon the borehole log only.  As such, this commonly found information is 
directly stored within the D_INT_ATTR fields rather than in the D_INT_ATTR_RD
table.  These include:

* VALI - Soil Blow Count (the number of blows required for six inch travel)
* VALF - Soil Recovery (a percentage)
* VALF2 - Soil Moisture (a percentage)

These would have formerly been found in D_INTERVAL_SOIL in the previous
version of the ORMGP database.  Additional, complete, lab information would be
located within the D_INT_TEMPORAL_1A/1B tables.

#### D_INT_ATTR_RD 

Similar in format to the various temporal tables (e.g. D_INT_TEMPORAL_2), this
table allows parameter readings to be stored that relate to a particular interval
attribute identifier (IATTR_ID) found in D_INT_ATTR (and ultimitely to a
particular INT_ID).  In this manner, point measurements (i.e. associated with
a depth) can be assocated with an interval (that would also have a depth; an
example of this would be temperature readings at various depths within a
screened well).

#### D_INT_FORM_ASSIGN 

Multiple geologic models that have been adapted or incorporated into as ORMGP
datasets have been interpreted for each interval present in this table.  In
this manner, any particular interval (depending upon its location) will be
found to have a geological unit assigned to it based upon each available
model.  Note that this assignment is automatically updated allowing for a
modification of the associated records if the location has had its coordinates
or elevation changed.  Further details regarding how this table is populated
can be found in Sections 2.4.1 and 2.4.

Only those intervals (i.e. with an INT_ID) that have a valid top and bottom
depth with D_INT_DEPTH will be present in this table.

The fields available include:

* ASSIGNED_UNIT - The geologic unit, for the particular geologic model to
  which the interval is assigned (see FORM_MODEL_CODE)
* FORM_MODEL_CODE - Identifies the geologic model to which this record for
  this interval applies (where there will be one record for each interval for
  each geologic model being examined)
* SLAYER - The surficial geologic unit for this location/interval
* TLAYER - The geologic unit in which the top of the interval lies
* BLAYER - The geologic unit in which the bottom of the interval lies
* PLAYER - The previous/upper geologic unit above the top of the interval
* PLAYER_VDIST - The distance from the top of the interval to the top of the
  previous geologic unit
* TNLAYER - The next geologic unit down from the top of the interval
* TNLAYER_VDIST - The distance from the top of the interval to the top of the
  next geologic unit (down from the top of the interval)
* NLAYER - The next geologic unit down from the bottom of the interval
* NLAYER_VDIST - The distance from the bottom of the interval to the top of
  the next geologic unit (from the bottom of the interval)
* BPLAYER - The previous geologic unit up from the bottom of the interval
* BPLAYER_VDIST - The distance from the bottom of the interval to the top of
  the previous geologic unit (from the bottom of the interval)
* THICKNESS_M - The thickness of the geologic unit (normally an aquifer) to
  which this interval has been assigned (found in ASSIGNED_UNIT)
* T - The Transmissivity (m2/s; also T_SCR)
* K - The Hydraulic Conductivity (m/s; also K_SCR)
* T_ITER - The number of iterations necessary to calculate T (also T_ITER_SCR)
* T_ERR - The final calculated error difference between this calculated T and
  the previously calculated T (also T_ERR_SCR)
* SC_LPMM - The calculated Specific Capacity incorporating Well Loss
  (liters-per-minute per metre; also SC_LPMM_SCR)

The second set of calculated fields, namely those with *_SCR* appended, use
the screen length to calculate the particular parameter instead of using the
THICKNESS_M value.  The methodology for populating these fields is otherwise
equivalent and can be found in Section 2.4.5.

#### D_INT_FORM_ASSIGN_FINAL 

The record referenced in D_INT_FORM_ASSIGN (by DIFA_ID) is considered to be
the *best guess* with regard to the ASSIGNED_UNIT used for this interval.
This allows a complete geologic representation across the entire study area
using th various available models.  Refer to Section 2.4.1 for the methology
by which this final ASSIGNED_UNIT is determined.

Note that if OVERRIDE_UNIT is not null, it indicates that this geologic unit
will override any unit found through the referenced DIFA_ID.  A non-null
geologic unit in MANUAL_UNIT is for reference only; it will likely have been
pulled from a report where the unit has been identified by a third party.

#### D_INT_LOGGER_QC 

This table is used to track logger data imports as performed through the ORMGP
website toolset.  The fields found herein are related to the details found
within the imported logger file and the settings used to do so.  In
particular, the following information is captured:

* INT_ID - The interval in which the logger is found
* TID - The import key linking the record to the dataset in the temporary
  database; in addition, this is used to link to the data source identifiers
  found in D_INT_LOGGER_QC_DDS
* LOGIN_NAME - The web-based login of the user uploading the data
* DATA_UPLOADED - The date at which the data was uploaded
* FILE_NAME - The original filename of the dataset (the logger file)
* INTERVAL_NAME - The associated interval name (from INT_NAME_ALT1)
* INT_REF_ELEV - The reference elevation used for the data import
* LOGGER_NAME - The name of the logger
* LOGGER_TYPE - The logger type (a code, as specified by the user)
* LOGGER_TYPE_TEXT - The textural version of the logger type code
* LOGGER_SERIAL_NUMBER - The serial number of the logger pulled from the
  import file
* LOGGER_LOCATION - The location of the logger pulled from the import file
* LOGGER_START_DATE - The start date of the logger data
* LOGGER_END_DATE - The end date of the logger data
* LOGGER_SOURCE_DATA - This is all the header information from the original
  logger data file (unprocessed)
* LOGGER_RECORD_COUNT - The number of records in the logger import file
* IMPORT_START_DATE - The start date of the logger data being loaded (this may
  be a subset of the total data available)
* IMPORT_END_DATE - The end date of the logger data being loaded (this may be
  a subset of the total data available)
* DATA_RECORD_COUNT - The number of records imported
* COR_DATA_MANUAL_DATES - Comma-delimited list of manual waterlevels (and
  their dates) used to correct the imported logger waterlevels

#### D_INT_LOGGER_QC_DDS 

Each logger input recorded in D_INT_LOGGER_QC (and each parameter of that
import) is provided with a DATA_ID (linking the import to the D_DATA_SOURCE
table).

#### D_INT_OFFSET 

Some depths are relative to a particular point of measure instead of to the
ground surface at a particular location.  In particular, water levels measured
in a well are generally taken either from the *Top of Pipe* or the *Top of
Casing* (i.e. a reference point) instead of from the ground surface.  As such,
a means by which to correct the measured value against the ground surface
must be available.  If the offset distance is recorded, i.e. the distance
between the reference location and the ground surface, this can be used to
correct the measured value.  

The actual value of the offset is located in the D_LOC_SPATIAL_HIST
(DLSH) table.  This ties the offset value closely to the coordinates and
ground elevation of the particular location.  As such, each record in this
this table (i.e. D_INT_OFFSET) now references a record in DLSH.  Here, though,
the valid start and end date for the particular offset are stored.  This links
an offset to a particular elevation and coordinate combination.  As any of
these three values can be modified (in DLSH; creating a new record in that
table), the particular interval offset can still reference the original offset
and associated information before the modification of these values.

A change in the offset can result from damage to the monitoring pipe or from a
more accurate survey of the reference point.  If no offset is specified for a
particular location, a default of *0.75m* is assigned (and noted as such in
the comments).

In some cases, no valid date exists to populate the START_DATE field.  When
this occurs, a false date of *1867-07-01* or *1967-07-01* is assumed instead,
functioning as a marker (of an unknown date).  Note that a valid date must
exist for each record in this table for comparison purposes.

#### D_INT_PTTW 

This table incorporates information from the *Permit to Take Water* dataset
available through the MOE.  The methodology for doing so is outlined in
Appendix G.  Note that when possible, the particular permit (a location type)
has been linked to a source location (e.g. a well).  This relation is captured
in D_LOC_RELATED.

The interpreted source type (PTTW_SRCID_CODE, linking to R_PTTW_SRCID_CODE)
and water type (PTTW_WATERSRC_CODE, linking to R_PTTW_WATERSRC_CODE) is
identified.

#### D_INT_PUMPTEST 

Much of the data held in this table is sourced from the MOE Water Well
Database.  This includes the recommended pumping depth (REC_PUMP_DEPTH_M), the
recommended pumping rate (REC_PUMP_RATE_IGPM) as well as the pump test date
(PT_DATE).  Note that for the latter, these pump tests are assumed to start at
twelve midnight (this is reflected in the datetimes of the measured water
levels, during pumping, in D_INT_TEMPORAL_2).  Additional fields include:

* PT_NAME - usually, if provided, the MOE WELL_ID
* FLOWING_RATE_IGPM
* PT_METHOD_CODE - the pumptest method (linking to R_PUMPTEST_METHOD_CODE)
* PT_TYPE_CODE - the pumptest type (linking to R_PUMPTEST_TYPE_CODE)
* WATER_CLARITY_CODE - the water clarity (linking to R_WATER_CLARITY_CODE)

For non-MOE pumping tests, some of these fields will remain empty.  The
pumping rates during the pumping test are found in D_INT_PUMPTEST_STEP (and
are linked by PT_ID).

When there are monitoring wells for a particular pump test (i.e. more than the
single well is measured), these will be grouped together (for the period of
pumping) in D_GRP_INT.

#### D_INT_PUMPTEST_STEP 

This table lists the pump rate (and units) of each step for each pump test
(along with the duration).  Note that all pumping values (and times) are found
in the D_INTERVAL_TEMPORAL_2 table.  There may be more than a single record
tied to each PT_ID, especially for non-MOE pumptests, when the pumping rate
was changed over the pumping period.

#### D_INT_SUMMARY 

This table stores weekly-calculated or -updated information for each interval
found in D_INT and is used to speed up the general views available to users of
the database (i.e. V_GEN\*).  Some of these data assemblies take some time to
calculate and impacts the usability of the database when determining this
information on-the-fly.  An example would be the averaging of water levels in
D_INT_TEMPORAL_2 (where there may be many thousands of records, over time, per
interval).

#### D_INT_TEMPORAL_1A and D_INT_TEMPORAL_1B 

These tables record the results from samples that have been taken from a
specific interval (usually a well screen) and sent to a laboratory for
analyses.  Laboratory and sample information are recorded in table *1A* and
the results of the sample analysis (i.e. individual parameters such as Mg, Na,
etc...) are recorded in table *1B*.  The testing of one sample for many
parameters results in multiple records (one row for each parameter) in *1B*
but only a single record (one row for the sample) in *1A*.  Valid parameter
names and their matching codes are found in the R_RD_NAME_CODE table.

Note that a particular parameter may have multiple real-world names associated
with it due to different laboratory reporting terms (e.g.  *Zinc (total)*,
*Zinc as Zn*, *Zn*, *Zinc by ICPMS*, *Zinc (ICPMS)*).  The table
R_RD_NAME_CODE table should have only a single one of these names available,
usually the one most commonly used (or chosen as most applicable by the
ORMGP).  To avoid the use of duplicate parameter names, then, the
R_RD_NAME_ALIAS table is used.  This contains those additional names that are
then linked to a particular RD_NAME_CODE.  On import into the database, these
*aliases* are converted to the appropriate reading name code.

A COMMENT_LONG field is available for long sample and laboratory descriptions
that do not fit into any of the other provided fields.  This is a free-form
text field.  

#### D_INT_TEMPORAL_2 

This table records any *field* data for a particular interval for a particular
date.  For these measurements there is no need to track a sample or
laboratory, therefore the data is only be added to this single table (unlike
chemistry records).  This results in one parameter per record/row.  Water
levels (both logger and manual) and stream flow data would be prime examples
of information stored herein.  However, the table also holds some field
measured pH, conductivity and other similar data.  Parameter codes (and names)
are found in the R_RD_NAME_CODE table.  Additional information (where
available) regarding the instrumentation used for collecting the particular
value can be recorded in RD_TYPE_CODE.  Refer to R_RD_TYPE_CODE for available
types.

Refer to the above discussion (under D_INTERVAL_TEMPORAL_1A) with regard to
the reading name codes (RD_NAME_CODE) and the use of parameter aliases in the
database.

Note that meterological data, tied to climate stations, are stored in
D_INTERVAL_TEMPORAL_3.

#### D_INT_TEMPORAL_3 

A similar description applies here as to that of D_INTERVAL_TEMPORAL_2.
However, as of *Database Version 6*, this table contains information sourced
from climate stations, alone.

#### D_LOC 

A location is a natural, constructed or artificial 
object and is the primary means of representing real-world entities (e.g. a
borehole, climate station, surface water gauge, documents, etc...) within the
database.  Refer to R_LOC_TYPE_CODE for a list of available location types.
This table should be considered central with regard to database queries by
users where information is being sought on an object-by-object basis.

Locations should not be deleted from the database.  For those locations that
cease operation (for example), the location status should be changed (i.e.
either from active to inactive, decommissioned or abandoned as appropriate).
Exceptions would include if there are duplicate locations; these should be
combined and one record deleted.  Erroneous locations can be *archived*,
removing them from active consideration.

Information within this table relate to its name, type and status.  This
includes:

* LOC_NAME\* - Multiple fields are available for naming of this location; of
  special note are:
    + LOC_NAME - The *main* name of the location (this field cannot be null)
    + LOC_NAME_ALT1 - This is generally used (when populated) to convey
      information about consultants, geography, location or ownership
    + LOC_NAME_MAP - A *short* name used for map plotting purposes
    + LOC_NAME_ORG - This holds the MOE WELL_ID (generally but not
      exclusively)
* LOC_AREA - An optional field, gives a general indication of the region in
  which the location can be found
* LOC_STUDY - This can list the original study in which the location was
  created (e.g. a borehole drilled) or it can provide information concerning
  the region which is responsible for it
* STATUS_CODE - In general, lists its active or inactive status; this will, in
  most cases, be location type specific (refer to R_STATUS_CODE for details)
* ACCESS_CODE - Provides an indication of the level of access that should be
  given for this location (and its associated data); in general, information
  within the database is accessible to all partner agencies but it can be
  limited to certain groups (refer to R_ACCESS_CODE for details).

Details concerning naming conventions within the database is outlined in
**Section 3.3.1**.  Note that any address information (including lot and
concession data) for a particular location is now found in the D_LOC_ADDRESS
table.  Any coordinate information is found in the D_LOC_SPATIAL_HIST table.

Though LOC_STUDY can be used to group locations together (using free-form
text), the D_GRP_LOC table should be used to explicitly tie these
locations together (instead).  In addition, the D_LOC_RELATED table is used to
link related locations (replacing the use of LOC_MASTER_LOC_ID from
the previous database schema).  This occurs when, for example, multiple MOE
well identifiers are used to describe one particular borehole, one for shallow
depths other other for the remainder of the drilled record.

#### D_LOC_ADDRESS 

The information contained herein were previously found in the D_LOCATION table
in the previous database schema.  There will be a one-to-one relationship
between this table and the D_LOC table.

Here can be found the various address-related information tied to a particular
location.  This includes both lot and concession data as well as the county
and township in which the location is placed.  Fields containing contact
information are also available.  Note that most locations will not have a
record within this table.

#### D_LOC_ALIAS 

Any names associated with a location can be stored here.  This is in addition
to the name fields available in D_LOC and allows the capture of multiple
references across agencies that are relevant to one location.  In addition,
particular alias types are found here.  For MOE wells, for example, this
includes a locations *Audit Number* and *Tag Number* along with its original
*WELL_ID* and *BORE_HOLE_ID* (as found within the MOE *Water Well Database*).
These available types are found in R_LOC_ALIAS_TYPE_CODE.  Duplicate names, in
conjunction with the LOC_ALIAS_TYPE_CODE, cannot be specified.

Special consideration is given for locations that have alternate borehole logs
available. In these cases, the name of the PDF is listed here instead.  This
originally defaulted to the actual LOC_ID for the location in the previous
version of the database schema.  As there is a possibility of overlapping
numbers with this database, any added alias of this type should prepend a *B*
character to the LOC_ID (the PDF extension is assumed).

If the name used is entirely numeric (and a whole number), it is converted and
used to populate LOC_NAME_ALIAS_ID.

#### D_LOC_AREA 

This table allows any particular location to be associated with a variety of
spatial areas using a *contained-within* analysis.  The areas/polygons
available are found in R_AREA_CODE table and include the conservation areas,
regions and source water protection areas that touch on the ORMGP study area.
Further examples could include geologic and hydrogeologic model extents (as
needed).  

Note that a similar table, D_LOC_PROJECT, is used to delimit locations that
are tied to a particular project rather than a particular area.

#### D_LOC_ATTR 

Attributes for a particular location that do not fit into the various fields
available in the location-based data tables (i.e. those tables that contain a
LOC_ID column) can be stored here.  These attributes are defined using the
ATTR_CODE field (which links to the R_ATTR_CODE table).  Similar in structure
to the S_CONSTANT table, the attributes can be integer (VALI), floating point
(VALF) or character values (VAL_DEF).  Ranges of values can be specified using
the secondary field available for each the previous types.  In addition,
depths can be specified for the attribute (at the particular location).  

As an example, for surface water stations, the stream segment identifier along
which a location occurs is stored here.  Further attribute types can be found
in R_ATTR_CODE.  For locations, this includes the various *Water Found - \**
(along with their depths) from the geologic features in the MOE WWDB (and
formerly found in D_GEOLOGY_FEATURE from the previous database schema).

A set of readings, through the D_LOC_ATTR_RD table, can also be associated
with a record in this table (through the ATTR_ID).  This can be used in place
of a new interval record in D_INT in the case where there would likely be only
a single set of linked parameters.

Note that there is a matching attribute table linked by intervals
(D_INT_ATTR).

#### D_LOC_ATTR_RD 

In combination with D_LOC_ATTR, a set of parameters and their readings can be
stored here linked through their ATTR_ID.  This is an alternative to having an
interval in D_INT and with sample records in D_INT_TEMPORAL_1A and
D_INT_TEMPORAL_1B (which adds complexity and, possibly, psuedo-lab records).

Note that there is a matching attribute readings table linked by intervals
(D_INT_ATTR_RD).

#### D_LOC_BOREHOLE 

This table is used to store the main details related to a well installation
including such attributes as borehole start and end dates (DRILL_START_DATE
and DRILL_END_DATE), bottom depth (BOTD), the drilling method
(DRILL_METHOD_CODE) and associated details (e.g. DRILLER_CODE, LOGGED_BY and
CHECKED_BY).  If the location intersects bedrock, a depth to bedrock is also
stored here (BEDROCKD).  This value is automatically populated based upon the
geologic layers found in D_LOC_GEOL_LAYER.

In addition to wells or boreholes, other geologic-related locations can be
found here.  For example, details extracted from cross-sections.  In these
cases, a psuedo-borehole record is created that captures the information at
certain locations upon the geologic section.

Example location types that can be found in this table include:

* Well or Borehole
* Archive
* Surface Water
* Outcrop
* Oil and Gas Well
* Geological Section
* Bedrock Outcrop
* Testpit

Note that location types are found in the R_LOC_TYPE_CODE table.

#### D_LOC_BOREHOLE_CONS 

Construction details including depths (TOPD and BOTD , diameter (DIAM) and
type (CON_TYPE_CODE) are specified here.  This includes information on any
casing (and its material), sand packs or seals (further construction types are
listed in R_CON_TYPE_CODE).  Note that there may be many records associated
with a single borehole, each record describing a particular construction type.

#### D_LOC_DOCUMENT 

This table holds general bibliographic details (e.g. author, date published,
client, etc...) concerning documents found within the ORMGP document library.
The title of the document is stored in LOC_NAME_ALT1 (in the D_LOC table).
Each document found herein is optimally stored in the ORMGP Report Library
(refer to **Section 2.6** for details) and identified by its document folder
number (DFID).  This identifier is also found in the LOC_NAME field (in the
D_LOC table).

Documents have been tagged as a location type (refer to R_LOC_TYPE_CODE for
details) and each document has coordinates associated with it (if available
and appropriate).  This allows documents to be plotted along with other
locations, providing a spatial coverage indication.

Many documents have a variety of information that would be useful with regard
to the ORMGP database.  These are tagged as being present (e.g. does the
document have boreholes or chemistry data) and whether they have been entered
in the D_LOC_ATTR table.

Other fields of note include:

* DOC_AUTHOR_AGENCY\* - the agency at which the author is found here; multiple
  fields are available with one a free-form text field
* DOC_CLIENT_AGENCY\* - the agency for which the document was prepared; a
  free-form text field is available here as well
* DOC_LOCATION_CODE - this is provided as an indication of the area covered in
  the document; this could be local (i.e. site specific), regional or national
  (for example)
* DOC_TOPIC\* - allows the type of general topics covered by the document to
  be listed
* DOC_JOURNAL_CODE - along with DOC_JOURNAL_VOLUME and DOC_VOLUME_OTHER,
  specifies the source of an academic paper
* DOC_ORG_NUMBER - along with DOC_ORG_PROJECT, captures any information
  associated with other organizational schemes (for example, documents sourced
  from a regional municipality may have its own reference numbers) or part of
  a particular large scale project
* DOC_DRAFT - an indicator that this is a draft version of the document
* DOC_MISSING - a tag to indicate that the document is missing from the ORMGP
  Report Library
* DOC_PARTIAL - an tag to indicate that the document is incomplete

Note that many of these will have an associated reference (i.e. a R_\*) table.

#### D_LOC_GEOL_LAYER 

This is a key table that holds the geologic record related to a particular
location (e.g. boreholes, outcrop, trenches, etc...) describing the sequential
stratigraphic layers encountered and capturing their top and bottom depths
(i.e. TOPD and BOTD).  The lowermost depth for each location should
approximate the bottom depth stored in D_LOC_BOREHOLE.

In general, four material types can be assigned for each geological layer
(MAT1_CODE through MAT4_CODE; e.g. sand, silt, gravel, till, etc...).  In
addition, particular characteristics can be specified separately, including:

* MATD_CODE - the layer's consistency (e.g. compact, very stiff, firm)
* MATM_CODE - the layer's moisture level (e.g. dry, moist)
* MATO_CODE - the presence of organics (e.g. trace)
* MATT_CODE - the layer's general texture (e.g. fine to coarse, fibrous)

These material types and characteristics are referenced in the R_GEOL_MAT_CODE
table.  Many of these were originally sourced from the MOE.  Others, though,
have been included through inclusion of data from other geotechnical sources
(e.g. the Geological Survey of Canada or the Ontario Geological Survey).
Where available, the complete geologic description of a particular layer is
found in GEOL_DESC.

Refer to **Section 3.3.4** for details-by-example regarding the assignment of
geologic information to this table.

Additional geologic details could formerly be found in D_GEOLOGY_FEATURE in
previous versions of the database schema.  This capability has been shifted to
the D_LOC_ATTR table (refer to R_ATTR_CODE for details).

Each record can (automatically) be assigned to a particular geologic unit
(GEOL_ASSIGNED_UNIT).  In addition, the geologic unit at the top (GEOL_TLAYER)
and the bottom of the layer (GEOL_BLAYER) is also stored and used to populate
the GEOL_ASSIGNED_UNIT.  The means for doing so match that of the records in
D_INT_FORM_ASSIGN (where a geologic unit as assigned on an interval basis).
The MATGSC_CODE is populated using the methodology developed by the Geological
Survey of Canada (GSC) in the late 1990's (while MATGSC_UNIT references the
grouped material units on the relevant GSC mapping).

In some cases, records are tagged to indicate the reliability of any
particular geologic layer or its usage.  This was formerly accomplished using the
GEOL_SUBCLASS_CODE field.  That particular field has been dropped and the
capability has been moved to the REC_STATUS_CODE field (refer to the
R_REC_STATUS_CODE table for details).  Examples of this include:

* Geology - Do not use for populating D_LOC_PICK
* Geology - Do not use for pushdown characterization
* Geology - Alternate layers (to be incorporated)

#### D_LOC_GEOPHYS_LOG_DATA 

This is the third of three tables by which geophysical down-hole logger
information is captured.  Each record here indicates the value (RD_VALUE) and
depth (RD_DEPTH_M) recorded by a particular logging tool run (LOG_RUN_ID).  As
an aid, if available, the original record number of the data collection run is
captured (LOG_RUN_NUM).  Invalid data is tagged using the REC_STATUS_CODE
field.

#### D_LOC_GEOPHYS_LOG_DETAILS 

This is the primary table by which geophysical down-hole logger information is
captured.  Each record here will be linked to a particular location through
its LOC_ID.  The subsequent tables (i.e. D_LOC_GEOPHYS_LOG_TYPE and
D_LOC_GEOPHYS_LOG_DATA) will be linked by the LOG_ID, specified here.

Basic information concerning the logging details (at the particular location)
are found here.  These include:

* LOG_START_DATE - the starting date of the logging project
* LOG_END_DATE
* LOG_LOC_NAME - the reference name used during logging (which should
  approximate the location name, ideally)
* LOG_JOB_NAME
* LOG_COMPANY - the geophysical logging company name
* LOG_OPERATOR
* LOG_EQUIPMENT
* LOG_MAX_DEPTH_M - the maximum depth logged (from all downhole tools)
* LOC_CASING_TYPE
* LOC_CASING_DIAM_CM

#### D_LOC_GEOPHYS_LOG_TYPE 

This is the second (of three) tables by which geophysical down-hold logger
information is captured.  Each record here (by LOG_RUN_ID) describes the type
of logging tool that was used (LOG_TYPE_CODE), its starting depth
(LOG_RD_START_DEPTH_M) and sampling step (LOG_RD_STEP_M) as well as the units
(UNIT_CODE) of the values captured.  In addition, an indicator is used to
determine whether the data was collected when the tool was moving up or down
the particular borhole (LOG_DIR_UP).  Note that there may be multiple
LOG_RUN_ID records associated with a single LOG_ID.

#### D_LOC_PICK 

This table contains the GEOL_UNIT_CODE (linked to R_GEOL_UNIT_CODE) and the
depth (TOPD) at which it occurs at a particular location.  The original user
who added the record to the table is captured by SYS_USER_STAMP (the date
added is found in SYS_TIME_STAMP).  The field SESSIONNUM is present for
historical purposes and relates to the original pick assemblies within the
original Microsft Access database version.  This should now be specified
through the DATA_ID field.

Previous versions of this table had a FORMATION text field.  This was free
form in nature, containing the textural description of the geologic unit for
the particular record (e.g. Top of Thorncliffe).  This information has been
moved to the COMMENT field.  In some instances, multiple formations were
specified within the FORMATION field.  This was used to facilitate
*pinch-outs* of overlaying units.  The last unit specifed, then, would have
the value within TOPD.  This multiple unit declaration is now disparaged.

#### D_LOC_PROJECT 

This table is used to link locations (by LOC_ID) within the ORMGP database to
particular projects identified through the PROJ_CODE field.  The latter
references projects listed in R_PROJECT_CODE.  A single LOC_ID can be linked,
as necessary, to multiple projects; the location, then, can be associated with
a particular project, within the ORMGP study area or both.  The ORMGP area is
defined by set polygons found with R_AREA_CODE.

Note that a similar table, D_LOC_AREA, is used to tie locations to a spatial
area instead of a particular project.

#### D_LOC_PTTW 

This table incorporates information from the *Permit to Take Water*
dataset available through the MOE.  The methodology for doing so is
described in **Appendix G**.  Note that when possible, the particular permit (a
location type) has been linked to a source location (e.g. a well) through the
D_LOC_RELATED table.

The source type (PTTW_SRCID_CODE) and water source (PTTW_WATERSRC_CODE) is
identified.  The latter can include groundwater or surface water sources (or
both).  Where available, the original source text is included (in
PTTW_SRCID_OUOM).

Note that a single PTTW_PERMIT number can encompass multiple database
locations (i.e.  have multiple LOC_ID's).  This occurs when the source
records, tagged to a permit number, have differing values within the available
fields (e.g. multiple sets of coordinates indicate multiple sources for a
particular permit).

#### D_LOC_PURPOSE 

This table records the *current* primary and secondary purposes assigned to a
particular location.  It does not hold the purpose codes itself but, rather,
contains a reference (PURP_ID) to the D_LOC_PURPOSE_HIST table.  This table
should have a one-to-one LOC_ID relationship with D_LOC.

#### D_LOC_PURPOSE_HIST 

This table records the primary and secondary purpose codes for each location.
There may be multiple purpose records (by location) which may reflect
a change in use over time (and can be delimited by PURPOSE_DATE_START and
PURPOSE_DATE_END) or the necessity of specifying more than two purposes.  Note
that only a single primary and secondary purpose record is available through
the D_LOC_PURPOSE table and should reflect the *current* (or most important)
purpose set.

For locations sourced from the MOE Water Well Database, the original MOE
purposes are captured as separate entries within this table.  Note that, for
the original MOE wells, many of the purpose classifications were based upon
the well owner's name (e.g. wells drilled for a church could reasonably be
coded with with a PURPOSE_PRI_CODE of *1* and a PURPOSE_SEC_CODE of *52*; this
corresponds to *Water Supply* and *Church*, respectively).  The process for
assigning purpose codes in more recent version of this database is described
in **Appendix G** which uses a combination of the MOE first and second use as
well as the borehole status source fields as part of the assignment process.

#### D_LOC_QC 

Records are added to this table in order to track the checks or changes to
locations (and any associated intervals) within the database).  This is used to
prevent unnecessary re-examination of locations having possibly problematic
data.  Corrections can be general in nature, affecting multiple tables (e.g.
pumptest and pumping rates), or table and field specified (e.g. screen top and
bottom depths).  These checks are indicated by the CHECK_CODE (indicating the
actual check performed) and CHECK_PROCESS_CODE (indicating the success or
failure - in a variety of ways - of the check or correction).  These fields
refernce the R_CHECK_CODE and R_CHECK_PROCESS_CODE tables.  The date at which
the check was made is captured in PROCESS_DATE; a DATA_ID should be
specified if the checks are part of an organized search for errors.  The
INT_ID should only be populated when the check is performed against an
interval linked to a location.  An additional COMMENT can be included to more
fully describe the information being evaluated.

Note that there will likely be multiple records per location as each could
describe a separate check undertaken at a (possibly) another PROCESS_DATE (or
another DATA_ID).  This table should be used instead of making check and
correction notes in the comment fields of the various tables.

#### D_LOC_RELATED 

This table allows a relation to be created that links locations together.
This replaces the use of LOC_MASTER_LOC_ID, D_DOCUMENT_ASSOCIATION and
D_PTTW_RELATED from previous versions of the database schema.

Here, both the LOC_ID and a LOC_ID_REL fields are populated; these values
should be present in the D_LOC table and cannot be equivalent.  The
REL_TYPE_CODE indicates the type of relation between the locations (e.g. a
document containing a borehole record; a *Permit to Take Water* record that
links to a particular source location).  These relation types are specified in
R_REL_TYPE_CODE.

#### D_LOC_SPATIAL 

This table links to the D_LOC_SPATIAL_HIST table through SPAT_ID.  These are
considered the active coordinates (and associated information) for a
particular location.  The COORD_CHECK field is used, here, to indicate that
some change in coordinates (or elevation or offset) has taken place and that
the records need to be reviewed.  This was originally located in the (now
defunct) D_LOCATION_GEOM table found in the previous database schema.

#### D_LOC_SPATIAL_HIST 

This table tracks changes in the coordinates, elevations and measured offsets
(if applicable) for a particular location.  All coordinates that have been
assigned or used by a location should be stored here; the current coordinates
(and other values) will be indicated through D_LOC_SPATIAL using SPAT_ID to
reference a particular record in this table.  The quality assurance codes
(QA_COORD_CODE for coordinates and QA_ELEV_CODE for elevations) are also
represented here.  Any change in any of these values should be captured as a
new record (and the new SPAT_ID referenced).

The X and Y fields should be populated, in general, with coordinates projected
into the default coordinate system of the program.  This system, a *European
Petroluem Survey Group* (EPSG) number, should be stored in EPSG_CODE.  For the
ORMGP database (as of *2025-05-23*), the default coordinate system is
*Universal Transverse Mercator, Zone 17, NAD83* (i.e. EPSG *26917*).  These
coordinates are also converted to latitude (LAT) and longitude (LONG) for ease
of transference to external groups.  The EPSG code for these fields are stored
in EPSG_CODE_LL (as of *2025-05-23*, this is EPSG *4269* which conforms to
*NAD83 Latitude and Longitude*).  The source coordinates for each location are
stored in the X_OUOM and Y_OUOM fields along with their original projection
system (stored in EPSG_CODE_OUOM).

As the EPSG *26917* projection is limited in scope to the defined *UTM Zone
17* (i.e. some of the ORMGP study area, as of *2025-05-23*, is outside of this
designated zone) an alternate projection system can be used that is cartesian
in nature.  These coordinates are stored in X_ALT and Y_ALT with their EPSG
projection code found in EPSG_CODE_ALT.  As of *2025-05-23*, this is
*NAD83/Ontario MNR Lambert* (i.e. EPSG *3161* along with the CGVD28 vertical
reference, EPSG *5713*).

Each of these three sets of coordinates are stored as SQL Server native
geometries within the table (i.e. fields GEOM, GEOM_LL and GEOM_ALT).  The
default coordinates are also represented as *Well Known Binary* format in
GEOM_WKB.

Additional coordinate information includes the COORD_CODE (designating the
source of the coordinates), the COORD_DATE (generally the date at which the
coordinate set was entered), and QA_COORD_CODE (the coordinate accuracy as
estimated from the original sources).  The latter field references entries
within the R_QA_COORD_CODE table.  The text fields COORD_METHOD and
COORD_COMMENT allow additional coordinate descriptions to be included as
free-form text.  A data source for the coordinates, if necessary, can be
specified using COORD_DATA_ID (which links to the D_DATA_SOURCE table).  Note
that COORD_CODE references the R_COORD_CODE table.

The ground elevation that is related to the record's coordinates is found in
ELEV.  Its units should be in *metres-above-sea-level* (i.e. *masl*) which
corresponds to a UNIT_CODE of *6*.  The original elevation and units (if
available) would be stored in ELEV_OUOM and ELEV_UNIT_OUOM, respectively.  The
additional fields used to characterize the elevations include:

* ELEV_DATE - the date at which the elevation was assigned
* ELEV_CODE - the source of the elevation value (this references R_ELEV_CODE)
* QA_ELEV_CODE - the vertical accuracy of the elevation value (this references
  R_QA_ELEV_CODE)

The text fields ELEV_METHOD and ELEV_COMMENT can be used to specify additional
information concerning the elevation value.  A data source for the elevation,
if necessary, can be specified using ELEV_DATA_ID (which links to the
D_DATA_SOURCE table).

Related to the elevation value, an offset may be specified here (using OFFS)
which provides a point of reference to which certain measurements are made.  A
prime example of this are water levels which tend to use the *top-of-pipe*
instead of the ground surface as the reference point when measurements are
taken.  The offset refers to the distance between the reference point and the
ground surface (i.e. the ELEV value).  A negative value indicates the
reference point is below the ground surface (in the case of ground-level
casing tops).

The various offset fields are similar to the elevation fields available within
this table and include:

* OFFS_DATE - that date at which the offset was assigned
* OFFS - the offset value 
* OFFS_UNIT_CODE - generally a unit code of *6* (i.e. *metres*)
* OFFS_OUOM - the original offset value
* OFFS_UNIT_OUOM - the original unit of measure
* OFFS_COMMENT - additional offset description information as  free-form text
* OFFS_DATA_ID - the associated data source, if necessary, linked to
  D_DATA_SOURCe

On those occasions when an offset is necessary but has an unknown value, a
false-value if *0.75* is assigned and a note made in OFFS_COMMENT.  Note that
records in D_INT_OFFSET reference this table through SPAT_ID.  This allows
date ranges in which a particular offset is to be used for recorded
measurements.

#### D_LOC_SUMMARY 

This table stores weekly-calculated or -updated information for each location
found in D_LOC and is used to speed up the general views available to users of
the database (i.e. V_GEN\*).  Some of these data assemblies take some time to
calculate and impacts the usability of the database when determining this
information on-the-fly.  Note that some of the data found here are normally
available at the interval level and is (generally) summarized for all
intervals found at the particular location.

#### D_OWNER 

The owners listed here are linked to D_LOC through OWN_ID.  Note that not all
locations will have an owner associated with them.  Owner availability is
dependent upon the original data source (e.g. the MOE no longer lists owner
information within their Water Well Database distribution).  When present,
these records can be used to determine the locations primary and secondary
purposes.  The OWN_ID field is also found in D_LOC_PTTW.

#### D_PICK_EXTERNAL 

The records in this table contain formation information using the
GEOL_UNIT_CODE field (linking to the R_GEOL_UNIT_CODE table) in addition to
the coordinate (x,y) as well as the elevation (z) necessary to position this
point within the ORMGP study area.  This allows the records here to be
independent of the relational schema in place for regular locations (e.g.
boreholes).  This includes the various quality assurance and supplementary
coordinate and elevation information (as found in D_LOC_SPATIAL_HIST).

The data herein corresponds to *pick* information, similar to that within
D_LOC_PICK (in the latter case, a location and a depth at which the top of a
geologic unit occurs).  In most cases, though, this will be related to
geologic units that are surficial in nature (e.g. Ontario Geological Survey,
2010 and Gao et al, 2006) and will be linked to an original data source
through the DATA_ID field.  Where the depth was calculated it will, in
general, reference the ground surface elevation (usually a DEM) used as an aid
for possible correction (at a later date).

The date of the source (or the source data) should be included in the PDATE
field (this should match Z_DATE unless this was calculated using a different
source).  The default mode is a single record equated to a single *pick*.  In
the case where a polyline (or polygon) was used to to capture coordinate
information and its original form is important with regard to its inclusion
within the database, the PGROUP field (which references R_GRP_PICK_CODE) can
be used to *name* the associated records and their order can be specified
within the PORDER field.  In most cases these fields will not be populated. 

#### D_VERSION 

This table contains the current primary and secondary dated versions 
of the database.  The single row, here, is accessed when distributing
a subset of the database to specify the PRIMARY_VERSION and SECONDARY_VERSION
(as well as the CUT_VERSION which is populated in the output database) within
the distributed database itself.  This specific combination of primary and
secondary codes are directly linked to D_VERSION_CURRENT_HIST which contain
information concerning the various database versions.

#### D_VERSION_HIST 

This table contains the description for each combination of primary and
secondary database versions and updates (these are dated versions, i.e. with
the format [yyyymmdd]).  The primary and secondary version comments should
describe the update or modification of the database.

#### D_VERSION_STATUS

This table captures the *status* of the database over time and is tied
directly to its primary and secondary *dated versions*.  This includes the
number of records for each location type, each interval type and each reading
group code type.  Additional records, capturing the current status of the
database, are usually added on a monthly basis.

*Last Modified: 2025-09-09*
