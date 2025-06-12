---
title:  "Section 2.6"
author: "ORMGP"
date:   "20250612"
output: html_document
knit:   (
            function(input_file, encoding) {
                out_dir <- '';
                rmarkdown::render(
                    input_file,
                    encoding=encoding,
                    output_file=file.path(dirname(input_file), out_dir,
                    '02_06_Report_Library.html')
                )
            }
        )
---

## Section 2.6 - Report Library

The report library is an expanding collection of technical reports and papers
that are found within, or relate to, the geological or hydrogeological aspects
of the ORMGP study area.  These documents consist primarily of consulting
reports, but includes provincial reports, guidance documents as well as
journal articles.  Reports have been provided from a number of sources,
including:

* Consulting reports from the Regions of Peel, York, Durham and Halton as well
  as the City of Toronto
* Consulting reports from the Conservation Authority partners
* TTC reports
* GSC reports and papers
* Ministry of Transportation of Ontario (MTO) geotechnical reports (GEOCRES)
  (provided through the Ontario Geological Survey)
* Miscellaneous public reports/journal papers/studies that the ORMGP 
  or partner agency staff) have been involved with or had access to
  previous interactions in other jobs.
* Gartner Lee Library consulting reports
* MOE Water Well Database 
* MOE geophysical logs

Each report is incorporated into the database as a new location with a unique
LOC_ID in the D_LOC table.  The full report name is stored in LOC_NAME_ALT1
while the LOC_NAME contains the document folder identifier (DFID) record in
D_LOC_DOCUMENT.  The DFID refers to a distinct directory (accessed through the
ORMGP website) containing an electronic version of the report and any
associated additional files.  Note that this document folder identifier (DFID)
will be a positive integer and can be considered a primary key within the
D_LOC_DOCUMENT table (i.e. the DFID will unique within the table).  Refer to
**Section 2.6.2** for additional details.

Document listings from the report library, in a bibliographic form, can be
generated using V_GEN_DOCUMENT_BIBLIOGRAPHY.  The report library documents are
available through the ORMGP website for download.

#### Area Coverage and Coordinates

For those documents that can be referenced
spatially by location (e.g. *Hydrogeology of the Ballantrae Area*),
coordinates are also assigned and recorded in the D_LOC_SPATIAL_HIST table.
These are determined from the report contents (e.g. a study area map) or
description through the use of an external software package (for example,
Google Maps or any standard GIS software).  In the case of the *... Ballantrae
Area*, mentioned previously, the assigned coordinates would approximate the
centre of the *Ballantrae* community.

To provide a sense of the geographic coverage of any given report, each are
assigned a study scale (through the use of a DOC_LOCATION_CODE, as found in
R_DOC_LOCATION_CODE).  This would consist, for example, as one of:

* Site
    + Site specific studies including development and most geotechnical
    reports
* Local
    + This woud include reports involving more than a single site or only part
    of a particular Region
* Regional
    + These would include reports that would cover an entire region, for
    example: Region of York; Region of Peel; etc...
* Provincial 
    + Reports in this case are generally limited to ministry documents that
    cover large portions of the Province (if not all)

Coordinates generally reflect the centre of these areal coverages.  For
example, those reports related to the Oak Ridges Moraine tend to be placed in
the middle of the moraine extents (placing them within Durham Region).
Alternatively, coordinates are specified at the major office for the
particular entity - this is commonly applied, for example, to government
documents that pertain to large areas where the document positioning would be
less than useful.  Those documents that cannot be geographically located are
not assigned coordinates; this is reflected in the QA_COORD_CODE field which
is assigned a value of *117* (i.e. invalid coordinates).

#### Important Fields

The DOC_AUTHOR field captures the report's author(s) while the the various
author agency fields, namely

* DOC_AUTHOR_AGENCY1_CODE
* DOC_AUTHOR_AGENCY2_CODE
* DOC_AUTHOR_AGENCY3

allow the specification of the agency to which the author is associated
(whether it be a consulting company, conservation authority, ministry,
etc...).  The \*_CODE fields link to R_DOC_AUTHOR_AGENCY_CODE containing a
listing of standard agencies.  The free-form text field (i.e.
DOC_AUTHOR_AGENCY3) allows additional information to be included that is not
captured by the other two fields.

If the document has been prepared for a particular client, this agency can be
referenced through

* DOC_CLIENT_AGENCY1_CODE
* DOC_CLIENT_AGENCY2

The former references the R_DOC_CLIENT_AGENCY_CODE table (listing standard
client agencies) while the latter is a free-form text field to capture any
additional information not available in the reference table.

Other, standard, information that can be recorded include:

* DOC_YEAR, DOC_MONTH and DOC_DAY
    + In most cases, only the year is specified (but null values are possible
    if the year is unknown)
* DOC_PAGE_RANGE
    + The number of pages of the report (e.g. *1-20* for a twenty page report)
* DOC_TYPE_CODE
    + The type of document or report; this includes, for example: journal
    papers; conference proceedings; books; consultant report; etc...; refer 
    to the R_DOC_TYPE_CODE table for the available types
* DOC_TOPIC\*_CODE
    + Three coded topic fields are available (linked to R_DOC_TOPIC_CODE);
    this allows the particular report to be linked to the type of information
    it relates (e.g. *Engineering - Dewatering*, *Golf Course*, etc...)
* DOC_ORG_NUMBER and DOC_ORG_PROJECT
    + Where the source of the documents is from another organization, these
    fields may contain information relative to their internal structure
* DOC_JOURNAL_CODE, DOC_JOURNAL_VOLUME and DOC_VOLUME_OTHER
    + These fields are used where the document pertains to a journal articles;
    the DOC_JOURNAL_CODE references R_DOC_JOURNAL_CODE table
* DOC_SOURCE
    + A free-form text field that allows the source of the document (e.g.
    *Ontario Geological Survey*) to be specified; note that this should be
    captured in the D_DATA_SOURCE table through the DATA_ID field
* DOC_DESCRIPTION
    + A free-form text desciption describing the contents of the DFID folder;
    this is commonly, for example, of the form *1 pdf*

## Section 2.6.1 Document Association

In Version 7 of the database, the D_DOCUMENT_ASSOCIATION table specified a
link between locations (e.g. boreholes) in the database and the documents they
were extracted from.  This capability has been shifted to the D_LOC_RELATED
table when the LOC_ID of the related location can be linked to the LOC_ID of
the document.  The specific relation is given through the REL_TYPE_CODE where
a value of *1* indicates the *Document* source (refer to the R_REL_TYPE_CODE
for other relation types).  Note that a single document can be linked to
multiple locations.

## Section 2.6.2 Directory and Files - Naming and Structure

The ORMGP Report Library is organized as a series of directories with 
numeric names.  These names relate to the document folder identifier (DFID)
found in D_LOC_DOCUMENT (and is also present in the LOC_NAME field in D_LOC).
Each directory holds, generally, a single PDF document which is the actual
report; an additional compressed file containing any data (or other
information) related to the report may be present.

The DFID is not automatically defined.  Instead, assigned ranges of values are
made available to specific users and organizations; these ranges do not
overlap.  This allows for reports to be added into a temporary database (refer
to **Section 2.6.3** for details) before final incorporation within the master
database.  The specific user who entered the report(s) is captured upon import
in the D_DATA_SOURCE table using a unique DATA_ID value.  

Note that any ranges assigned will tend to start and end at natural breaks.
Individual DFID's will not be reused (for example, if duplicates are found,
the DFID of the deleted record will not be assigned to another document) and
there may be unused values between the ranges.

Each report should follow a consistent naming structure, similar to

> \<Author last name\>\_\<Year\>\_\<Shortened title\>\_\<DFID\>.pdf

The *<>* quotes should not be included, they indicate the text that needs to
be replaced.  The *Author last name* can include up to two authors, for
example

> Eyles and Boyce_1991_Earth Science Survey of the Rouge Valley Park_3641.pdf  

If more than two authors are on the report, an *et al*
should be appended to the first authors name, similarly to

> Eyles et al_2003_Geophysical and sedimentological assessment of urban
> impacts in a Lake Ontario watershed and lagoon_2236.pdf

The optional compressed file (containing data or associated files, as noted
previously) should have a short name, only, but is not otherwise constrained.

## Section 2.6.3 - Report Entry

For those users interested in making available reports (in digital form) to
the ORMGP group, a Microsoft Access database (usually an *mdb* or *accdb*
file) is made available to assist in data entry (using the ORMGP group defined
fields and values).  This database, currently *Report Entry
Form_ORMGP_20250601_blank.mdb*, contains the reference tables and values used
in the ORMGP master database (Version 7) as well as a form that allows users
to interactively add the characteristics of their reports into a readily
imported format.  This includes an auto-increment function within the user's
assigned range (of DFID's).  

The report PDF and any associated files should be placed in a numbered
directory (as outlined in **Section 2.6.2**).  The PDF should consist either
of the original digital file, as made available through a consultant, or a
scanned version of the original hard copy.  In both bases, the PDF will be
examined and optical character recognition (OCR) will be applied as necessary.
The latter is to enable keyword searches upon the entire document, available
through the ORMGP website.

## Section 2.6.4 - Report Data and Keywords

In Version 7 of the database (and earlier), additional tags were available
indicating the presence of certain data within the particular report.  They
were of the form (for example)

* DOC_YN_LOCATION_MAP
* DOC_YN_BH_LOG
* DOC_YN_ENTERED_BH_LOG
* DOC_YN_WATERLEVEL
* DOC_YN_ENTERED_WATERLEVEL
* DOC_YN_DIGITAL_DATA
* etc...

The populated DOC_YN_ENTERED_\* field would indicate whether the available
data had been incorporated within the database.  As of Version 8 of the
database, this information is now found within the D_LOC_ATTR table.  This
references the R_ATTR_CODE table (through ATTR_CODE) containing similar
records:

* Document - Borehole Log YN (*23*)
* Document - Chemistry Data YN (*24*)
* Document - Cross Section YN (*25*)
* Document - Digital Data YN (*26*)
* Document - Pump Test YN (*27*)
* Document - Geophysics Data YN (*28*)
* Document - Geotechnical Data YN (*29*)
* Document - Location Map YN (*30*)
* Document - Waterlevel Data YN (*31*)
* Document - Modelling YN (*32*)

In this case, the VALI field in the D_LOC_ATTR table indicates the presence of
a particular dataset within the report.  The field VALI2 is used to indicate
whether that data has been entered into the database.  (In both cases, a
non-null value - *1* for instance - is used to signify the presence and
entered information.)  In this manner, additional document information types
can be added without modifying the underlying schema of the database.

In addition, previous version of the database allowed keywords to be captured
within the D_DOCUMENT table for each document.  This allowed specific
information on topics contained within the report to be included and which
could be queried as needed.  As the ORMGP Report Library documents are now
converted to a form allowing a complete text search within every document,
these keywords are not necessarily needed.  However, this information is also
captured within the D_LOC_ATTR table using the *Document - Keywords* tag
(i.e. ATTR_CODE *36*).  

One use of a keyword field was to tag records sourced from the library of R.E.
Gerber (a secondary source); these were tagged with a *REG* keyword (in
KEYWORD8).  In some cases, no digital version of the document was available.
When this has been rectified, a *REF - Found* keyword was introduced.  

*Last Modified: 2025-06-12*
