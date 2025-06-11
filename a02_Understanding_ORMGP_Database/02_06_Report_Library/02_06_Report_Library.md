---
title:  "Section 2.6"
author: "ORMGP"
date:   "20250611"
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
associated additional files.  For those documents that can be referenced
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

Coordinates generally reflect the centre of these areal coverages.
Alternatively, coordinates are specified at the major office for the
particular entity - this is commonly applied, for example, to government
documents that pertain to large areas where the document positioning would be
less than useful.

Coordinates for these
geographically large studies are placed in the approximate centroid of the
area covered (e.g. in the case of the Oak Ridges Moraine focused reports the
coordinates are placed in the middle of the moraine in Durham Region).
Journal papers or other documents that cannot be geographically located would
not be assigned coordinates (and, generally, given a QA_CONFIDENCE_CODE of
'117'; refer to D_LOCATION_QA and R_QA_COORD_CONFIDENCE_CODE).

Also included in the database are the report author(s) (in DOC_AUTHOR), as
well as the author agency that released the report (whether it is a consulting
company, conservation authority, ministry, etc...).  This latter information
can be found in (any of) DOC_AUTHOR_AGENCY_CODE, DOC_AUTHOR_AGENCY2_CODE or
DOC_AUTHOR_AGENCY3 (refer to R_DOC_AUTHOR_AGENCY_CODE).  If a document has
been prepared for a particular client, the client agency are also populated
(i.e. DOC_CLIENT_AGENCY_CODE and, if applicable, DOC_CLIENT_AGENCY2; refer to
R_DOC_CLIENT_AGENCY_CODE).  Other typical information that would be recorded
for a report (e.g. pages, year published, journal, etc...) is also located in
the D_DOCUMENT table.

Each report is also assigned a general topic (e.g. 'Engineering - Dewatering',
'Aggregate', 'Golf Course', etc...; see DOC_TOPIC_CODE, DOC_TOPIC_CODE2 and
DOC_TOPIC_CODE3; refer also to R_DOC_TOPIC_CODE) as well as a series of
indicators stating whether the particular report includes any of:

* a location map
* cross-sections
* borehole logs
* geophysical data
* geotechnical data
* a pump test
* modeling
* chemistry data
* water levels
* a data CD

An additional tag is available to indicate whether the information has been
incorporated in the database (both are a series of boolean - yes/no - fields,
the former identified by 'DOC_YN_\*' and the latter identified by
'DOC_YN_ENTERED_\*').  Keywords have been provided in an attempt to provide
more specific information on topics included in the report and to narrow down
query results if specific information is required.  In most cases, only
documents currently in possession by the ORMGP (in digital form) will be found
in the database.  An exception to this rule was made for a set of reports
extracted from a secondary report library (R.E. Gerber) and included for
completeness (these have been tagged with a 'REG' keyword in DOC_KEYWORD8).
For those documents where a digital or hard copy has been located, this tag
has been amended to 'REG - Found' (or similar).

Document listings from the report library, in a bibliographic form, can be
generated using V_GEN_DOCUMENT_BIBLIOGRAPHY.  The report library documents are
available through the ORMGP website for download.

Note that the DOC_FOLDER_ID should be considered a primary key (i.e. a number
is assigned to only one possible report) and will consist of a positive
integer.  The number chosen for any particular report is based upon the next
natural break higher than the current maximum value found in the DOC_FOLDER_ID
field of the D_DOCUMENT table.  As such, 'breaks' will occur between ranges of
values found in this field - these 'breaks' indicate where a new set of
documents were incorporated and do not indicate that reports are missing or
deleted.  No DOC_FOLDER_ID's will be re-used.

## Section 2.6.1 Document Association

The D_DOCUMENT_ASSOCIATION table allows creation of a link between (perhaps
multiple) documents in the 'Report Library' to specific locations (e.g.
boreholes or other documents) as found in the D_LOCATION table.  For example,
a borehole could be linked to a specific report, used as a source, within the
'Report Library' (e.g. a borehole, existing within the database, has its
origins from a particular document found within the 'Report Library').  The
D_DOCUMENT_ASSOCIATION table is populated with a LOC_ID (from D_LOCATION) and
the corresponding DOC_ID (from D_DOCUMENT).  Note that this is a one-to-many
association, where a single LOC_ID can be linked to multiple DOC_IDs (if, for
example, a borehole was found to be used across multiple reports).  Use of
V_GEN_DOCUMENT_ASSOCATION allows a user to find all documents that reference a
particular location.  

A similar table, D_DOCUMENT_ASSOCIATION_INTERVAL, allows linking of specific
intervals (e.g. screens) to documents in the D_DOCUMENT table.  This table,
however, has had limited usage.

## Section 2.6.2 Directory and Files, Naming and Structure

The ORMGP Report Library is organized as a series of directories with specific
numeric names.  These names are from the DOC_FOLDER_ID column found in the
D_DOCUMENT table.  Each directory holds, generally, a single pdf document of
the actual report/document along with an optional compressed (zip) file
containing any data or related files.  Refer to Section 2.6.1, above, for
details on linking related reports using D_DOCUMENT_ASSOCIATION. 

The numeric values used in DOC_FOLDER_ID are based upon assigned ranges made
available to specific users; these ranges do not overlap.  A range-of-values
is made available to a user upon request to the ORMGP group; this is for those
actively entering reports into a temporary database (refer to Section 2.6.3,
below). Notes on specific users are included, upon import of records, in the
D_DATA_SOURCE table using a unique DATA_ID value.

Each report should follow a consistent naming structure, similar to

> \<Author last name\>\_\<Year\>\_\<Short title\>\_\<DOC_FOLDER_ID\>.pdf

The '<>' quotes should not be included - they're just present to show what
needs to be replaced.  The 'Author last name' can include up to two authors
(e.g. 'Eyles and Boyce_1991_Earth Science Survey of the Rouge Valley
Park_3641.pdf'); if more than two authors are on the report, an 'et al' should
be appended to the first author name (e.g. 'Eyles et al_2003_Geophysical and
sedimentological assessment of urban impacts in a Lake Ontario watershed and
lagoon_2236.pdf').  The optional compressed file (i.e. a zip file; containing
data or associated files, as noted above) should have a short name, only, but
is not otherwise constrained.

## Section 2.6.3 - Report Entry

For those users interested in making available reports (in digital form) to
the ORMGP group, a Microsoft Access database (an 'mdb' file) is made available
to assist in data entry (using the ORMGP group defined fields and values).
This database, currently 'Report Entry Form_ormgp_20210601.mdb', contains the
'look-up' tables and values used in the ORMGP master database as well as a
form that allows users to interactively add the characteristics of their
reports into a readily imported format.  This includes an auto-increment
function within the user's assigned range of DOC_FOLDER_ID's.  The report pdf
and any associated files should be placed in a numbered directory (as outlined
in Section 2.6.2, above).  The pdf should consist either of the original
digital file, as made available through a consultant, or the scanned hard
copy.  In both bases, the pdf will be examined and
optical-character-recognition (OCR) will be applied as necessary.  The latter
is to enable keyword searches through the ORMGP website.

*Last Modified: 2025-06-11*
