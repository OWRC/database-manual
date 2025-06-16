---
title:  "Section 2.5"
author: "ORMGP"
date:   "20250616"
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
the viewing or analysis of particular datasets.  In addition, groupings of
non-locational (and non-interval) records are possible within the ORMGP database.

## Section 2.5.1 ORMGP Study Area

The spatial geometry of the ORMGP Study Area can be found in the R_AREA_CODE
table.  This is used, in comparison with the point geometry of each
location (held in the D_LOC_SPATIAL table), to determine those locations
that fall within the ORMGP Study Area.  This is especially important with regard to
population of the various W_\* tables (that contain a subset of the locations held
within the ORMGP database).  As this is distinct from other areas (e.g. the
extents of a conservation area or the extents of a geologic model), this
relation is stored within the D_LOC_PROJECT table instead.  Refer to **Section
2.5.4** for additional details.

## Section 2.5.2 Study Areas

#### LOC_AREA and LOC_STUDY (D_LOC)

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

Groups allow locations or intervals to be tagged as being associated - whether
this be related to a particular project or study, spatial area, monitoring
personnel, etc...  Any individual location/interval can be associated with
multiple groups.  In general, groups would apply to a smaller number of
locations than would be assocated through the use of D_LOC_AREA as described
in **Section 2.5.2**.

Groups are defined through three data tables 

* D_GRP_INTERVAL
* D_GRP_LOCATION
* D_GRP_OTHER

and six look-up tables

* R_GRP_INT_CODE
* R_GRP_INT_TYPE_CODE
* R_GRP_LOC_CODE
* R_GRP_LOC_TYPE_CODE
* R_GRP_OTH_CODE
* R_GRP_OTH_TYPE_CODE

For the location tables,  these allow any set of location identifiers (i.e.
LOC_ID) to be associated with any specified group with a well defined and
meaningful name (as found in R_GROUP_LOC_CODE; e.g. *Simcoe - Wasaga Beach -
All Municipal Wells (102)*).  Each group can correspond to a particular type
which can include, for example:

* Well Nest (6)
* Well Grouping - Pumping Well Influenced (7)

In the first case, these are locations that would occur at the same site
location but have differing coordinates (refer to **Section 2.7** as an
example).  The latter case, these would be wells that appear to be responding
to pumping at a pumping well.  Unless specified in this manner, these would
not naturally be assocated within the ORMGP database.

The interval tables are used in much the same way.  In this case, though, they
are working at the interval (i.e. INT_ID) level as opposed to the location
level.  Note that for Multi-Screen Installations (as described in **Section
2.7**), multiple intervals found at a single location are considered to be
grouped or nested without being present within any of the grouping tables.

The *other* grouping tables differ from the LOC_ID and INT_ID based tables.
These are set to allow any set of keys to be grouped together.  As such, the
R_GRP_OTH_TYPE_CODE table takes on greater importance as it will determine how
the grouping of values is to be handled within the database (and to what
tables the particular keys apply.  An example use would be to group together
parameters from R_RD_NAME_CODE as an alternative to the default groupings
available in R_RD_GROUP_CODE.

#### R_RD_GROUP_CODE

Most parameters within the R_RD_NAME_CODE are assigned a default grouping,
commonly related to chemistry, through the RD_GROUP_CODE field.  This relates
to the R_RD_GROUP_CODE table.  These include:

* Chemistry - General (Water or Soil/Rock) (26)
* Chemistry - Metals (Water or Soil/Rock) (2)
* Chemistry - PAHs (Water or Soil/Rock) (20)
* Chemistry - PFAS (Water or Soil/Rock) (40)
* Chemistry - PHCs (Water or Soil/Rock) (33)
* Chemistry - SVOCs (Water or Soil/Rock) (29)
* Chemistry - VOCs (Water or Soil/Rock) (3)
* Discharge/Production - From Wells (Municipal/Artesian/Other) (35)
* Hydraulic Properties (30)
* Meteorological (22)
* Miscellaneous (Unassigned) (39)
* Soil/Rock - Chemistry (31)
* Soil/Rock - Geophysics (34)
* Soil/Rock - Physical (37)
* Soil/Rock - Physical - Grainsize (32)
* Stream Flow Related (25)
* Water - Bacteriological Related (36)
* Water - Dissolved Gases (38)
* Water - Extractables (5)
* Water - Isotopes (15)
* Water Level (23)
* Water - Major Ions (1)
* Water - Miscellaneous Organics (28)
* Water - Pesticides & Herbicides (4)

Only a single default group is available in this manner.  Multiple groupings
of these parameters can be accomplished through the D_GRP_OTHER and related
tables.

#### D_PICK_EXTERNAL and R_GRP_PICK_CODE

A special case of a group occurs with regard to D_PICK_EXTERNAL.  Here, the
PGROUP field is used to associate (and name) points (i.e. picks) that are part
of a polyline or polygonal feature (for the latter, these points would
delineate its edge).  This allows, along with PORDER (which stores the order
of the points), the object to be recreated as necessary (for example, to
export to an external GIS package).  Each PGROUP must be specified in
R_GRP_PICK_CODE, allowing the object to be related to a particular feature.
Note that PGROUP is equivalent to GRP_PICK_CODE in the latter table.

## Section 2.5.4 Projects

The D_LOC_PROJECT table is used to tag locations (by LOC_ID) that are
associated with particular *projects* within the ORMGP.  In particular, those
locations that fall within the ORMGP Study Area are found here, assigned a
PROJ_CODE of *Oakridges Moraine Groundwater Project - Study Area (1)*.  Note
that a LOC_ID can be assigned to multiple projects within this table.  

Any additional specified project need not reside within the ORMGP Study Area.
This allows multiple datasets to be stored within the ORMGP database without
confusion with regard to area overlap or location duplication.  For example,
a City of Ottawa series of locations were incorporated within the ORMGP
database.  These are tagged as being assocated with that project (i.e. *City
of Ottawa - Study Area (2)*).  Those locations are ignored through queries
accessing the ORMGP locations.  This is especially important with regard to
the population of the W_\* tables (various summary tables used for general
website access).  Here, both sets of locations will be available; these will
be treated differently, however, based upon their PROJ_CODE.  The primary
reason for this being that the coordinates of the Ottawa dataset are projected
differently (UTM Zone 18) than that of the regular ORMGP locations (UTM Zone
17).

*Last Modified: 2025-06-16*
