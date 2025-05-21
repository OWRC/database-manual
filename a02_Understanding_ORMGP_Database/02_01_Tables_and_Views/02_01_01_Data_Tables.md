---
title:  "Section 2.1.1"
author: "ormgpmd"
date:   "20250521"
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

This table allows intervals (using INT_ID) to be associated
together based upon a GRP_INT_CODE.  For example, all of the screens
(intervals) that have been sampled for isotopes form a group; intervals that
are measured during a pumping test could also be grouped.  The current
groupings can be found in R_GRP_INT_CODE.

#### D_GRP_LOC 

Allows locations (usingr LOC_ID) to be associated together based
upon a GRP_LOC_CODE.  As an example, all of the PGMN wells have been grouped
together (GRP_LOC_CODE '99').  The current groupings are found
in R_GRP_LOC_CODE.

#### D_GRP_OTH 

NO DESCRIPTION

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

Refer also to D_LOC_ALIAS (which performs a similar function for locations).

#### D_INT_ATTR 

Attributes for a particular interval that do not fit easily into the variety
of fields available within the interval based data tables (i.e. the D_INT\*
tables) can be stored here.  Specific types are assigned through the ATTR_CODE
field (which links to the R_ATTR_CODE table).  This includes, for example,
*Soil Blow Count* or *Soil Recovery* values that were formerly found in
D_INTERVAL_SOIL in previous version of the ORMGP database.  Numeric attributes
can be stored in either the VALI field for integers or VALF field for real
numbers.  Ranges can be specified using the matching fields available, i.e.
VALI2 and VALF2.  Both default and text attributes can be stored in VAL_DEF
(and VAL_DEF2); note that this can include date-formatted information.  Note
that the *flowing* attribute (originally found in D_INTERVAL_MONITOR) is now
located here.

Where data (e.g. temperature and conductivity) is collected for a particular
interval (e.g. a screen) for a series of depths, these depth values can be
captured here (using TOPD for top depth and TOPB for bottom depth).  Readings
taken at these depths can then be stored (referenced using the IATTR_ID field)
within the D_INT_ATTR_RD table.  This set of psuedo-intervals could then be
grouped based upon their DATA_ID (or through the D_GRP_OTH table).

Refer also to D_LOC_ATTR (whcih performs a similar function for locations).

#### D_INT_ATTR_RD 

Similar in format to the various temporal tables (e.g. D_INT_TEMPORAL_2), this
table allows parameter readings to be stored that relate to a particular interval
attribute identifier (IATTR_ID) found in D_INT_ATTR (and ultimitely to a
particular INT_ID).  In this manner, point measurements (i.e. associated with
a depth) can be assocated with an interval (that would also have a depth; an
example of this would be temperature readings at various depths within a
screened well).

#### D_INT_DEPTH 

The depth information associated with intervals (for certain interval types)
is found here.  This replaces D_INTERVAL_MONITOR and D_INTERVAL_SOIL from
previous versions of the ORMGP database.  In general, the top and bottom
depths of the particular interval are recorded along with its diameter (as
appropriate).  The INT_TYPE_CODE (from D_INT) will specify whether the depths
have been reported or if they've been assumed (or calculated) based upon
alternate information.  For example, where only casing information has been
included, the bottom of the screen is specified as one foot below the bottom
casing depth specified.  Refer to R_INT_TYPE_CODE for further details.

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

#### D_INT_LOGGER_QC_DDS 

#### D_INT_OFFSET 

Some depths are relative to a particular point of measure instead of to the
ground surface at a particular location.  In particular, water levels measured
in a well are generally taken either from the *Top of Pipe* or the *Top of
Casing* (i.e. a reference point) instead of from the ground surface.  As such,
a means by which to correct the measured value against the ground surface
must be available.  

If the offset distance is recorded, i.e. the distance between the reference
location and the ground surface, this can be used to correct the measured
value.  The actual value of the offset is located in the D_LOC_SPATIAL_HIST
(DLSH) table.  This ties the offset value closely to the coordinates and
ground elevation of the particular location.  As such, each record in this
this table now references a record in DLSH.  Here, though, the valid start and
end date for the particular offset (and elevation/coordinate combination) are
stored.  This allows the offset value to change with that change (and its
affected time period) captured through the use of these two tables (i.e. this
one and DLSH).

A change in the offset can result from damage to the monitoring pipe or from a
more accurate survey of the reference point.  If no offset is specified for a
particular location, a default of *0.75m* is assigned (and noted as such int
he comments).

In some cases, no valid date exists to populate the START_DATE field.  When
this occurs, a false date of *1867-07-01* or *1967-07-01* is assumed instead,
functioning as a marker (of an unknown date).  Note that a valid date must
exist for each record in this table for comparison purposes.

#### D_INT_PTTW 

#### D_INT_PUMPTEST 

#### D_INT_PUMPTEST_STEP 

#### D_INT_SUMMARY 

#### D_INT_TEMPORAL_1A 

#### D_INT_TEMPORAL_1B 

#### D_INT_TEMPORAL_2 

#### D_INT_TEMPORAL_3 

#### D_LOC 

#### D_LOC_ADDRESS 

#### D_LOC_ALIAS 

#### D_LOC_AREA 

#### D_LOC_ATTR 

#### D_LOC_ATTR_RD 

#### D_LOC_BOREHOLE 

#### D_LOC_BOREHOLE_CONS 

#### D_LOC_DOCUMENT 

#### D_LOC_GEOL_LAYER 

#### D_LOC_GEOPHYS_LOG_DATA 

#### D_LOC_GEOPHYS_LOG_DETAILS 

#### D_LOC_GEOPHYS_LOG_TYPE 

#### D_LOC_PICK 

#### D_LOC_PROJECT 

#### D_LOC_PTTW 

#### D_LOC_PURPOSE 

#### D_LOC_PURPOSE_HIST 

#### D_LOC_QC 

#### D_LOC_RELATED 

#### D_LOC_SPATIAL 

#### D_LOC_SPATIAL_HIST 

#### D_LOC_SUMMARY 

#### D_OWNER 

#### D_PICK_EXTERNAL 

#### D_VERSION 

#### D_VERSION_HIST 

#### D_VERSION_STATUS

*Last Modified: 2025-05-21*
