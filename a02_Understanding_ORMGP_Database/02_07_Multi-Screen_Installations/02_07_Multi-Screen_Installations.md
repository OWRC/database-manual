---
title:  "Section 2.7"
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
                    '02_07_Multi-Screen_Installations.html')
                )
            }
        )
---

## Section 2.7 Multi-Screen Installations

Multi-screen installations are a common groundwater monitoring technique used
to investigate local hydrogeological conditions.  They generally include one
or more boreholes with multiple screens (i.e. intervals or monitors) within
each borehole.  These types of boreholes have been dealt with in a variety of
ways within the ORMGP database depending upon the actual borehole or screen
characteristics and the source of the original data.

Historically the MOE water well record database (WWDB; also referred to as the
Water Well Information System, WWIS) primarily held only those wells that were
drilled for water supply purposes by companies specifically created for
drilling water supply wells.  These wells typically held only a single screen
(i.e. an interval) per borehole.  In some circumstances, two pipes were
installed in one borehole for, as an example, municipal monitoring purposes.
The MOE WWDB would only retain information for one of these two screened
intervals; the information on the second interval would be missing (in the
digital version of the WWDB).

Starting in 2003 the MOE started collecting information on boreholes that were
drilled under consultant oversight by geotechnical borehole drillers.  At this
time the MOE adopted a methodology of *clustering* wells that allowed the
geological description of one borehole (presumably the deepest borehole) to
effectively represent all other boreholes drilled on that site (refer to
**Section 2.8** for additional information).  In such cases, a
*representative* geologic description from one on-site borehole was considered
to reflect the conditions for the entire site.  All boreholes drilled on the
site are then linked in the WWDB (through the MOE WELL_ID field) with only a
single *master* location having a geological description (i.e. the other
records would not include any geological description information).  All other
on-site boreholes would include the typical information associated with an MOE
borehole (i.e. well depth, construction details, screen details, pumping test
details, etc...; refer to **Section 2.3.1** for additional details).

When these cluster wells are incorporated into the database, each borehole is
given its own unique LOC_ID in the D_LOC table and is linked to its related
boreholes through the MOE WELL_ID alias held (by each) in the D_LOC_ALIAS
table.  This is described, with further detail, in **Section 2.8**.

It is important to note that these MOE *clustered* wells are not considered to
be multi-screen installations in the typical sense.  They only share the
common geological interpretation of the *representative* well.

Multi-screen installations would include:

* Typical consultant wells where the deepest borehole is drilled first and the
  recovered soil logged to establish the geological profile
    + Generally, the deepest screen would be installed in this borehole
    + Subsequent screens are then installed in unique boreholes that are drilled
    in the immediate vicinity (within ten or twenty metres) of the original well
    to the required depth based on the interpretation of the first borehole
* Situations where multiple screens or intervals have been installed within
  one borehole with seals placed between each screen  
* Waterloo system or West Bay type installations 
    + Unique intervals down one borehole are monitored through a set of pipes
    or tubes that are directed from the monitored interval to the surface
    + In the West-Bay system (or other similar packer systems) it could become
    important to record the start and the end dates of the interval owing to
    the transient nature of the (temporary) packer intervals
    + Due to their short duration, (in cases, only long enough to perform a
    single slug test or extract a single sample) the start and end times
    should be populated within the D_INT table (i.e.  INT_START_DATE and
    INT_END_DATE) to track the many possible (and possibly overlapping)
    intervals that could exist in a single borehole

Depending upon the person entering the data, these types of multi-screen
boreholes could be entered into the database in one of two different ways:

* Multiple borehole locations are given a single location (i.e. one record in
  D_LOC)
    + This would have a single record in D_LOC_BOREHOLE, one set of
    construction details (in D_LOC_BOREHOLE_CONS) and a single set of
    coordinates (in D_LOC_SPATIAL); the source data, i.e. the separate
    boreholes, would generally be within ten or twenty metres of each other
    + The location would have, then, multiple intervals (in D_INT) to record
    the various screens found at the location; each interval would then have
    its own associated set of temporal data
    + This is the preferred methodology for multi-level nested wells.

* Each borehole, with separate coordinates, are given a separate location
  (i.e. multiple records in D_LOC)
    + Each location would have very similar coordinates but separate records
    (in D_LOC_SPATIAL)
    + The construction, depth, elevation and screen information would
    generally differ between these locations
    + Generally, the boreholes would have similar geologic descriptions; in
    some cases, the shallow wells would have not geological record provided
    + These separate locations would be linked through the D_GROUP_LOCATION
    table (as an example of a nested well)
    + This type of entry into the database is generally discouraged

In some instances (generally within the MOE WWDB) a single well can have
multiple screened intervals associated with a single casing pipe (i.e. the
well screen has been designed purposefully to leave a solid casing between two
screened intervals within an aquifer; this solid casing, for example, could
block off a silty zone within that aquifer).  Other boreholes may have an
installed screen in a coarse aquifer high in the well with a second screen set
into a second aquifer near the bottom of the well.  Since the extracted water
and recorded water levels would reflect the contribution from both aquifers,
ony one interval (with one set of temporal data) would be recorded for such
wells within the ORMGP database.  However, the multiple screen tops and
bottoms for such an interval are retained in the D_INT_DEPTH table (a view
would be used to extract the highest and lowest depths assocated with these
mutliple screens).  These borehole configurations are not common and these
wells would not be considered as multi-screen installations.

Municipal pump houses could be incorporated into the database as multi-screen
equivalents; in general, they have not been represented in this way.  Pump
houses, instead, have been assigned a LOC_ID within the database; the wells
that are linked (or contribute) to a municipal pump house (or reservoir) are
then asscoated through the D_LOC_RELATED table (or grouped within the
D_GRP_LOCATION table).

Climate and surface water stations have only a single interval assigned to
which temporal data is associated.  As such, for example, all air temperature
and rainfall recorded at a climate station would be found related to that
interval.  It is possible that these could be separated into multiple
intervals in order to capture additional information on the instrumentation
used to capture data (then there would be one interval associated with the
temperature data, a second interval associated with the rain gauge, etc...).

*Last Modified: 2025-06-12*
