---
title:  "Section 2.1"
author: "ormgpmd"
date:   "20250526"
output: html_document
knit:   (
            function(input_file, encoding) {
                out_dir <- '';
                rmarkdown::render(
                    input_file,
                    encoding=encoding,
                    output_file=file.path(dirname(input_file), out_dir,
                    '02_01_Tables_and_Views.html')
                )
            }
        )
---

## Section 2.1 Tables And Views

#### *Overview*

Real world objects are stored as approximations within a database - the data
model itself describes how the object's information is stored, where it is
stored and how it is to be accessed.

Data models include the definition of tables and their fields (i.e. what
information goes where) and how tables are related.  Embedded within a table
and its field description is a definition of field types (e.g. text, date and
numeric), field size (the maximum character size or numeric range, real versus
integer values), relationships between tables and the data in the tables (e.g.
one-to-one, one-to-many), cardinality, and indexes.

In general, field names have been chosen to be as meaningful as possible to
the user, to contain no spaces or punctuation and to be unique.  Field names
in data and look-up/reference tables in general are always capitalized.

Refer to Section 2.2 with regard to relationships between the tables.  Refer
to Section 4 (Technical) for complete descriptions of individual tables, views
and fields.

#### *Identification Fields (\*ID)*

Identification fields are the internal \*ID numbers assigned to each major
entity in the database.  Each location whether a well, climate station,
surface water station report or other type, as well as the related key
attributes (e.g. boreholes, documents, screens or intervals) has a unique
integer (i.e. a whole number; e.g. LOC_ID and INT_ID) that allows
characteristics or attributes for the entity to be linked across multiple
tables (i.e. the relation or related field).  Once assigned, these unique
identifiers do not change and should not (in general) be modified.

Note that the data tables are named such that the major key that links them
are indicated (e.g. D_INT\* indicates that the INT_ID key is present; D_LOC\*
indicates that the LOC_ID is present).

#### *Data Fields*

The include the remaining fields (other than system fields as described below)
contain information related to the particular entity.  In general the data and
its nomenclature are table specific, however in many cases fields containing a
particular  type of information will have a consistent naming (e.g. RD_DATE is
consistent wherever it appears in the D_INT\* tables).

#### *Original Data Fields (\*_OUOM)*

At the time of the creation of the database it was thought that data capture
into the database (especially with respect to metric versus imperial units)
should be in its original format rather than performing conversions outside of
the database and then importing the data.  This allowed for the data to be
compared to the source files at any future date should data quality issues
arise.  Therefore the term *Original Units of Measure* (OUOM) was developed
to reflect that a particular field contained *original* data.  A
parallel series of fields, usually a similar name with the *_OUOM* suffix
removed, holds the converted/corrected data.  The conversion of the original
units into the system units (generally metric) is handled internally in the
database (and relates to the units specified in R_UNIT_CODE).

#### *System Fields*

System fields are generally located at the end of the field list in any
particular table.  These are typically used by data management software (or
interval views) to manage or track the database.  These are typically named
with *SYS_* prefix.  Examples include SYS_TIME_STAMP (the date of intial entry
of the record into a table) and SYS_USER_STAMP (the user who inserted the
particular record into a table).  Most system fields, though, should not be
used to store permanent data as they are often overwritten during internal
management tasks.  This is typical of SYS_TEMP1 (a text field) and SYS_TEMP2
(an integer field) which can be used for flagging records in the database
during a particular task.  These two fields, in particular, should not be
relied upon to maintain their value as they can be modified at any time.

The fields SYS_LAST_MODIFIED and SYS_LAST_MODIFIED_BY are updated whenever
the particular has been modified.  These function as a first-order data
tracking system (one-step only, though).

The SYS_ID field is used in many tables, functioning as a primary key.  It is
important to note that this particular field cannot be used to link tables (as
it is a standalone key for each table).

##### *Other Fields*

Other fields found in most tables include:

* COMMENT - a free-form text field
* DATA_ID - a link to the D_DATA_SOURCE table 

Most lookup (i.e. reference or *R_\**) tables also include:

* ABBR_DESC - an abbreviated description field (shorter than *\*_DESC*)
* ALT_CODE - an alternative code that may be used (in place of the primary key)

*Last Modified: 2025-05-26*
