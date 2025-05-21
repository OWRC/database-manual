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
(and VAL_DEF2); note that this can include date-formatted information.

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

#### D_INT_FORM_ASSIGN 

#### D_INT_FORM_ASSIGN_FINAL 

#### D_INT_LOGGER_QC 

#### D_INT_LOGGER_QC_DDS 

#### D_INT_OFFSET 

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
