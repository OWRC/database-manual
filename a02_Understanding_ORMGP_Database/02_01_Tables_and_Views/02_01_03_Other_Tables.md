---
title:  "Section 2.1.3"
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
                    '02_01_03_Other_Tables.html')
                )
            }
        )
---

## Section 2.1.3 Other Tables

Other table prefixes are used within the database.  These include S_\* to
denote *system* tables and W_\* to denote *web* (i.e. internet) tables.  The
former are not generally accessed directly by a user; the latter are general
summary tables that provide information to the ORMGP website.

Each of the W_\* data tables contain summaries of information used
specifically for *web* access, especially with regard to online mapping
(almost all contain a GEOM field for coordinates).  Each of the tables
includes a GIS_ID field with values greater than zero.  Such a key is required
by the software being used as the mapping backend (i.e.  ArcGIS and
Geocortext, ????).  Note that all W_\* tables are re-populated weekly and rely
upon information present in the D_LOC_SUMMARY and D_INT_SUMMARY tables (though
not exclusively).

#### S_CONSTANT

This table stores the ORMGP database constant values that are used within
various views as a control upon their returned results.  Both single values
(VAL_DEF, VALI and VALF) as well as ranges (the former in combination with
VAL_DEF2, VALI2 and VALF2) are held here.  Note that (to allow a certain
flexibility): *DEF* represents the default value (stored as text); *I*
represents an integer value; and *F* represents a floating point value.  Not
all of the fields will be populated.

#### S_DESC_FIELD

Stores the names and text descriptions for fields located within the tables
and views within the ORMGP database schema.

#### S_DESC_TABLE

Stores the names and text descriptions for the main tables found within the
ORMGP database schema.

#### S_DESC_VIEW

Stores the names and text descriptions for the views found within the ORMGP
database schema.

#### W_GEN

This table contains *general* location information, mainly focused on
locations that make use of the D_LOC_BOREHOLE table.  Temporal data
availability and ranges is also listed.  This is related to D_LOC using
LOC_ID.

##### Field - GEOL_FEAT

This field is used to assemble the 'Water Found' information as commonly
defined on the MOE water-well master sheets.  As more than one water type can
be specified, these have been converted to a text-string of 0/1 values such
as '001001'.  For additional details, refer to the description of
V_SYS_W_GENERAL_GEOL_FEAT (which assembles the data for this field).

#### W_GEN_DOCUMENT

This table contains information from the D_LOC and D_LOC_DOCUMENT tables and
includes a formatted bibliographic reference field (BIBLIO).  This is related
to D_LOC using LOC_ID.  

#### W_GEN_GROUP

This table contains information regarding the various groupings (and types) of
wells (as found in D_GRP_LOCATION and related tables).

#### W_GEN_GW_LEVEL

This table contains daily averages of water levels as well as (if available)
manual water levels for any interval with more than thirty records.  This table is
used in conjunction with W_GEN_SCREEN for plotting purposes.   This is
related to D_LOC using LOC_ID and D_INT using INT_ID.  

#### W_GEN_OTHER

This table contains summary information for non-borehole locations as
specified in the field TYPE (e.g. Climate Stations and Surface Water
Stations).  It is related to D_LOC using LOC_ID and D_INTL using
INT_ID.  

#### W_GEN_PICK

This table contains the picks (as found in D_LOC_PICK) as well as associated
location information.

#### W_GEN_SCREEN

This table contains summary information for screened borehole intervals 
as described in R_INT_TYPE_CODE.  It is related to
D_LOC using LOC_ID and D_INT using INT_ID.  This table is used as a
locational reference for information in W_GENERAL_GW_LEVEL.  

*Last Modified: 2025-05-28*
