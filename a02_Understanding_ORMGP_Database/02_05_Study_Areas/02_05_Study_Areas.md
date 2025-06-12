---
title:  "Section 2.5"
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
                    '02_05_Study_Areas.html')
                )
            }
        )
---

## Section 2.5 Study Areas, Groups and Projects

Locations within the ORMGP database generally conform to the extents of the
ORMGP Study Area with a buffer of twenty-five kilometres.  However, locations
are not limited to this area and data from beyond the study area extents do
exist within the database (for a variety of reasons).  As such, there are a
variety of ways by which locations can be grouped or tagged so as to delimit
the viewing or analysis of particular datasets.

## Section 2.5.1 ORMGP Study Area

The spatial geometry of the ORMGP Study Area can be found in the R_AREA_CODE
table.  This is used, in comparison with the point geometry of each
location (held in the D_LOC_SPATIAL table), to determine those locations
that fall within the ORMGP Study Area.  This is especially important with regard to
population of the various W_\* tables (that contain a subset of the locations held
within the ORMGP database).  As this is distinct from other areas (e.g. the
extents of a conservation area), this relation is stored within the
D_LOC_PROJECT table.  Refer to **Section 2.5.4** for additional details.

## Section 2.5.2 Study Areas

#### D_LOC - LOC_AREA and LOC_STUDY

The free-form text columns LOC_AREA and LOC_STUDY, found in
D_LOC, allow a single study area (LOC_AREA) and single project
(LOC_STUDY) to be specified for each location.  LOC_AREA, when populated,
indicates the general spatial area in which the location lies.  LOC_STUDY
generally indicates the initial (or, if known, regional) study from which the
location information was gleaned.  These particular fields are relied upon by
some of the ORMGP staff and are generally up-to-date.  

If a particular location is associated with multiple studies, they should be
included as part of a *group* as outlined in **Section 2.5.3**.

#### D_LOC_AREA and R_AREA_CODE

The D_LOC_AREA table is configured to allow locations to be tagged with the
area in which they are located where a single location can be related to
multiple areas (a one-to-many relationsip).  This is related to the
R_AREA_CODE table through AREA_CODE.  This replaces the the CA_AREA_ID
(conservation area), SWP_AREA_ID (source water protection area) and
REG_AREA_ID (region extent) fields formerly present in the the
D_LOCATION_SUMMARY table from Version 7 of the ORMGP database.

The R_AREA_CODE table contains the polygonal geometry for each of the ORMGP
conservation authorities and regions extents (with and without buffers) as
well as a variety of geologic and hydrogeologic model extents used within the
program.  The point geometry of a location can then be compared against
specified areas to determine whether they fall within particular areas extent.
If so, that relation can be stored within the D_LOC_AREA table.  As an aside,
these relations are used when extracting data from the ORMGP database for
distribution to the partner agencies.

In general, for a number of specified spatial areas, this is an automatic
comparison with the D_LOC_AREA updated on a weekly basis (refer to **Appendix
G.32** for details).  This allows correction of a location if its coordinates
have been changed for any reason.

## Section 2.5.3 Groups

TO REVIEW


Groups allow locations or intervals to be tagged as being associated - whether
this be related to a particular project or study, spatial area, monitoring
personnel, etc...  Any individual location/interval can be associated with
multiple groups (different from 'Study Areas' where only a single 'Study Area'
can be defined).

Three data tables 

* D_GROUP_INTERVAL
* D_GROUP_LOCATION
* D_GROUP_READING (currently unused)

and six look-up tables

* R_GROUP_INT_CODE
* R_GROUP_INT_TYPE_CODE
* R_GROUP_LOC_CODE
* R_GROUP_LOC_TYPE_CODE
* R_GROUP_READING_CODE (currently unused)
* R_GROUP_READING_TYPE_CODE (currently unused)

are used.  The data tables associate a LOC_ID, INT_ID or RD_NAME_CODE with a
particular GROUP_INT_CODE, GROUP_LOC_CODE or GROUP_READING_CODE.  The look-up
(R_\*) tables associate the individual \*_CODE's with a particular
user-defined group name.  Examine the view 'V_Groups_Wells_BHs' for examples
of existing location-based (i.e. grouped by LOC_ID) groups.

Refer to Section 3.2.2 for adding new groups to the database.

A special case of a group occurs with regard to D_PICK_EXTERNAL.  Here, the
PGROUP field is used to associate (and name) points/picks that are part of a
polyline or polygonal feature (for the latter, these points would delineate
its edge).  This would allow, along with PORDER (which stores the order of the
points/picks), the object to be recreated as necessary (e.g. to export to an
external GIS package).  Each PGROUP must be specified in R_GROUP_PICK_CODE,
allowing the object to be related to a particular (possibly real-world)
feature.

## Section 2.5.4 Projects

TO POPULATE

*Last Modified: 2025-06-12*
