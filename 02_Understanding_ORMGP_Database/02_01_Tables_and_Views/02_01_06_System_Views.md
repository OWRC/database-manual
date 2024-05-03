---
title:  "Section 2.1.6"
author: "ormgpmd"
date:   "20240503"
output: html_document
knit:   (
            function(input_file, encoding) {
                out_dir <- '';
                rmarkdown::render(
                    input_file,
                    encoding=encoding,
                    output_file=file.path(dirname(input_file), out_dir,
                    '02_01_06_System_Views.html')
                )
            }
        )
---

## Section 2.1.6 System Views

These views are not meant for the general user.  Instead, many of the views
found in Section 2.1.5 use these as sources for accessing the data (D_\*) and
reference (R_\*) information within the database.  In addition, most of these
will not remove the complexities of the table and field information and will
rely upon the user having a certain familiarity with the database and the
ability to write SQL code to manipulate it.

#### V_SYS_AGENCY_\*

Each partner agency and region (as well as the ORMGP study area and the
'Source Water Protection' - SWP - areas) have three views associated with
them:

* V_SYS_AGENCY_\<partner agency\>
    + This view extracts all locations (i.e. the LOC_ID) that lie within the
    areal extent of the agency (plus a defined buffer); these locations must
    have valid coordinates (as defined by QA_COORD_CONFIDENCE_CODE) and are
    present in D_LOCATION_GEOM.   The ORMGP 'Viewlog Header Well' is included
    by default in this list.

* V_SYS_AGENCY_\<partner agency\>_ALL
    + This view includes all locations from V_SYS_AGENCY_<name> and adds all
    locations from D_DOCUMENT regardless of valid coordinates.

* V_SYS_AGENCY_\<partner agency\>_NOBUF
    + This view is similar to V_SYS_AGENCY_<name> but no buffer is added to
    the areal extent.

All of these views use the built-in spatial support of Microsoft SQL Server
when checking the geometric location against the geometric area (refer to
D_AREA_GEOM and D_LOCATION_GEOM).  Note that the 'SWP_\*' areas will generally
have a single view while the ORMGP area will have a few.

The names of the areal extents used for each partner agency are listed as
follows (the AREA_ID, from D_AREA_GEOM, is enclosed in quotes).

* CLOCA
    + CLOCA Boundary 5km Buffer ('2')
    + CLOCA Boundary ('30')
* CVC
    + CVC Boundary 5km Buffer ('3')
    + CVC Boundary ('32')
* DURHAM
    + Durham Boundary 5km Buffer ('13')
    + Durham Boundary ('40')
* GRCA
    + GRCA Boundary 5km Buffer ('4')
    + GRCA Boundary ('33')
* HALTON
    + Halton Boundary ('66')
    + Halton Boundary 5km Buffer ('67')
* HALTON_CA
    + Halton CA Boundary ('74')
    + Halton CA Boundary 5km Buffer ('75')
* KCA
    + KCA Boundary 5km Buffer ('5')
    + KCA Boundary ('34')
* LSRCA
    + LSRCA Boundary 5km Buffer ('6')
    + LSRCA Boundary ('35')
* LTRCA
    + LTRCA Boundary 5km Buffer ('7')
    + LTRCA Boundary ('36')
* NVCA
    + NVCA Boundary 5km Buffer ('8')
    + NVCA Boundary ('37')
* ORCA
    + ORCA Boundary 5km Buffer ('9')
    + ORCA Boundary ('38')
* ORMGP
    + ORMGP Boundary 20210205 (73)
    + ORMGP Boundary 20210205 25km Buffer (70)
    + ORMGP Boundary 20210205 5km Buffer (76)
* PEEL
    + Peel Boundary 5km Buffer ('14')
    + Peel Boundary ('41')
* SWP_CTC
    + SWP-CTC Boundary ('44')
* SWP_LS
    + SWP-Lake Simcoe Boundary ('60')
* SWP_TRENT
    + SWP-Trent Boundary ('51')
* TORONTO
    + Toronto Boundary 5km Buffer ('15')
    + Toronto Boundary ('42')
* TRCA
    + TRCA Boundary 20km Buffer ('61')
    + TRCA Boundary ('39')
* YORK
    + York Boundary 5km Buffer ('16')
    + York Boundary ('43')
* YPDT
    + YPDT-CAMC SWP Area - 20km Buffer ('62')

#### V_SYS_AREA_GEOMETRY_WKB

This view converts the AREA_GEOM in D_AREA_GEOM from a geometry type to a
binary type.  The latter will be in 'Well Known Binary' (WKB) format -  this
is supported by a number of external software packages.

#### V_SYS_BH_BEDROCK_ELEV

This view returns the current bedrock elevation (if present) from D_BOREHOLE
as well as calculating a new bedrock elevation from the geologic descriptions
in D_GEOLOGY_LAYER.  Note that any material type assigned a '1' value for
GEOL_MAT1_ROCK is considered bedrock for the purposes of this calculation.  In
addition, a second value is calculated for the new bedrock elevation - this is
limited to two decimal places (and is the value used for populated
BH_BEDROCK_ELEV in D_BOREHOLE).

#### V_SYS_BH_CASING_SUMMARY

This view determines the minimum and maximum casing elevations and diameters
(as well as the number of records) for each location in D_BOREHOLE.  Any
diameters are also shown in inches.  This is limited to a CON_TYPE_CODE of '3'
(i.e. 'Casing') in D_BOREHOLE_CONSTRUCTION.

#### V_SYS_BH_DIAMETER_ALL

Returns each of the: borehole diameter; construction diameter; and screen
diameter.  The largest of these is chosen as the default diameter value.  All
units are converted to meters.

#### V_SYS_BH_DROUGHT_TEST

For each location in D_LOCATION_SUMMARY, this view examines where the
WL_MASL_AVG value (from D_INTERVAL_SUMMARY) is within DEF_DROUGHT_DIFF metres
(from S_CONSTANT; this is initally set to three metres) of either the
BH_BOTTTOM_ELEV (in D_BOREHOLE) or the REC_PUMP_DEPTH_METERS (from
D_PUMPTEST).  These will be locations that are considered to be affected by
drought conditions.

Note that an indicator of [1] is returned in TEST_BOTTOM for a borehole bottom
check while an indicator of [2] will be returned in TEST_PUMP for the pump
depth check.

#### V_SYS_CHK_AGENCY_CA

This view compares the location against the various conservation authorities
areal extents returning the updated value in CA_AREA_ID_NEW.  The current
CA_AREA_ID is also returned for comparison. 

Note that a null value is returned if the location is outside of any
conservation area.

#### V_SYS_CHK_AGENCY_REG

This view compares the location against the various regions areal extents
returning the updated value in REG_AREA_ID_NEW.  The current REG_AREA_ID is
also returned for comparison.

Note that a null value is returned if the location is outside of any region.

#### V_SYS_CHK_AGENCY_SWP

This view compares the location against the various source water protection
areal extents returning the updated value in SWP_AREA_ID_NEW.  The current
SWP_AREA_ID is also returned for comparison.

Note that a null value is returned if the location is outside of any source
water protection area.

#### V_SYS_CHK_ALIAS_NAME

This view checks for duplicate LOC_NAME_ALIAS text across multiple LOC_ID's
(these cannot occur for the same LOC_ID - a built-in constraint prevents
this).  This can be used to determine where multiple LOC_ID's actually refer
to the same borehole/well (in particular, this can be easily applied against
multiple MOE WWDB imports).  However, multiple aliases can occur for MOE
nested wells; it could also occur by happenstance so an immediate problem
should not be assumed.t

#### V_SYS_CHK_ALIAS_NAME_MOE_TAG

This view uses V_SYS_CHK_ALIAS_NAME as a source, only extracting those rows
that have a LOC_ALIAS_TYPE_CODE of '1' (i.e. 'MOE Tag Number').

#### V_SYS_CHK_BH_BEDROCK_ASSIGNED

This view uses each of V_SYS_BH_BEDROCK_ELEV, V_SYS_SUMMARY_GEOL_LAYER_NUM and
D_GEOLOGY_LAYER as sources.  It returns the calculated bedrock elevation
(where GEOL_MAT1_ROCK is '1' from R_GEOL_MAT1_CODE), the elevation of the next
layer below this, the total number of geologic layers and the number of
geologic layers below the calculated bedrock elevation (ERR_GEOL_LAYER_NUM)
for a particular location.  Note that the subsequent layers cannot have a
GEOL_MAT1_ROCK of '1' nor have a GEOL_MAT1_CODE of '0' (i.e. 'Unknown') or
'105' (i.e. 'Refusal') and are not included if so.

#### V_SYS_CHK_BH_BEDROCK_ASSIGNED_ANY

This view, using V_SYS_CHK_BH_BEDROCK_ASSIGNED (above) as a base, returns
information on the geologic layers below the calculated bedrock elevation.

#### V_SYS_CHK_BH_BEDROCK_ASSIGNED_GRANITE

This view, using V_SYS_CHK_BH_BEDROCK_ASSIGNED_ANY (above) as a base, returns
rows that correspond to GEOL_MAT1_CODE of '21' (i.e. 'Granite').  Where
non-rock subsequent layers exist, this is likely an error.  Additional fields
are available to update D_GEOLOGY_LAYER (and remove the bedrock tag) if this
is the case.

#### V_SYS_CHK_BH_BEDROCK_ASSIGNED_OTHER

This view, using V_SYS_CHK_BH_BEDROCK_ASSIGNED_ANY (above) as a base, returns
rows that correspond to various GEOL_MAT1_DESCRIPTION's, including:

* Greenstone ('22')
* Basalt ('36')
* Chert ('37')
* Conglomerate ('38')
* Feldspar ('39')
* Flint ('40')
* Gneiss ('41')
* Greywacke ('42')
* Marble ('45')
* Quartz ('46')
* Soapstone ('48')

Refer to V_SYS_CHK_BH_BEDROCK_ASSIGNED_GRANITE (above) for additional
details.

#### V_SYS_CHK_BH_BEDROCK_ASSIGNED_SANDSTONE

This view, using V_SYS_CHK_BH_BEDROCK_ASSIGNED_ANY (above) as a base, returns
rows that correspond to GEOL_MAT1_CODE of '18' (i.e. 'Sandstone').  Refer to
V_SYS_CHK_BH_BEDROCK_ASSIGNED_GRANITE (above) for additional details.

#### V_SYS_CHK_BH_BEDROCK_ASSIGNED_SHALE

This view, using V_SYS_CHK_BH_BEDROCK_ASSIGNED_ANY (above) as a base, returns
rows that correspond to GEOL_MAT1_CODE of '17' (i.e. 'Shale').  Refer to
V_SYS_CHK_BH_BEDROCK_ASSIGNED_GRANITE (above) for additional details.

#### V_SYS_CHK_BH_BEDROCK_ELEV_RANGE

This view uses V_SYS_BH_BEDROCK_ELEV as a base.  It returns rows where the
BH_BEDROCK_ELEV (from D_BOREHOLE) is not within +/- 0.001m of the 'new'
calculated bedrock elevation or is NULL.

#### V_SYS_CHK_BH_CASING_BOTTOM_MAX

This view returns the deepest bottom-of-casing depth from
D_BOREHOLE_CONSTRUCTION (where CON_TYPE_CODE is '3', i.e. 'CASING', from
R_CON_TYPE_CODE).  The original 'units of measure' are returned but the depth
is converted to 'metres' (from 'fbgs' as necessary).  Note that if the
original units are not one of 'm', 'mbgs' or 'fbgs' then a '-9999' value is
returned.

#### V_SYS_CHK_BH_CONS_BOTTOM_MAX

This view returns the deepest construction detail (bottom) depth from
D_BOREHOLE_CONSTRUCTION.  Refer to V_SYS_CHK_BH_CASING_BOTTOM_MAX for
additional details.

#### V_SYS_CHK_BH_CONS_TOP_MAX

This view returns the deepest construction detail (top) depth from
D_BOREHOLE_CONSTRUCTION.  Refer to V_SYS_CHK_BH_CASING_BOTTOM_MAX for
additional details.  This is used in the case when only a top depth is present
to indicated maximum depth of a borehole.

#### V_SYS_CHK_BH_DEPTH

Using V_SYS_CHK_BH_DEPTH_BASE as a source, returns those locations that do not
have a depth in D_BOREHOLE that matches the suggested maximum depth value
determine here.t

#### V_SYS_CHK_BH_DEPTH_BASE

Returns the depths and elevations for a particular borehole extracted from a
variety of tables (e.g. D_BOREHOLE, D_BOREHOLE_CONSTRUCTION, 
D_GEOLOGY_LAYER, etc...; note that other views are used as source of these
values).  A suggest maximum depth is assembled from these values.  See also
V_SYS_CHK_BH_DEPTH.

#### V_SYS_CHK_BH_ELEV

This view returns a number of elevations associated with a borehole location
where: BH_GND_ELEV is NULL; BH_DEM_GND_ELEV is NULL; or BH_GND_ELEV_OUOM is
NULL.  These elevations can be used to populate the associated fields.  Note
that all three fields in D_BOREHOLE should contain the same value; if
BH_GND_ELEV is kept blank, SiteFX considers this row as 'new' data when
re-calculating elevations.  The QA_COORD_CONFIDENCE_CODE must not be '117'
(i.e. 'YPDT - Coordinate Invalid ?').

#### V_SYS_CHK_BH_ELEV_BASE

Returns all standard elevations and depths associated with a particular
location along with the maximum depth and lowest elevation (based on the
current BH_GND_ELEV).  All locations returned must have valid coordinates
(based on QA_COORD_CONFIDENCE_CODE).  This should be used to update the
D_BOREHOLE table to correction the depth and bottom elevation values.

#### V_SYS_CHK_BH_ELEV_BASE_UPDATE

Using V_SYS_CHK_BH_ELEV_BASE as a base, returns the current elevations and
depths as well as the new calculated depth and bottom elevation.  These can be
used to update the appropriate fields in D_BOREHOLE.  In addition, SYS_TEMP1
and SYS_TEMP2 are populated with the current date (the former as a string, the
latter as a numeric value).  The original depth units should also be updated.

#### V_SYS_CHK_BH_ELEV_BOT_ELEV

Using V_SYS_CHK_BH_ELEV_BASE_UPDATE as a base, returns those records where the
ground and borehole bottom elevation are equivalent, the calculated elevation
is not NULL and the depth is greater than zero.  This can be used to update
D_BOREHOLE.  In addition, a new BH_COMMENT field is created tracking this
update.

#### V_SYS_CHK_BH_ELEV_BOT_ELEV_DEPTH_EMPTY

Using V_SYS_CHK_BH_ELEV_BASE_UPDATE as a base, returns those records where the
borehole bottom elevation or depth is null and the newly calculated bottom
depth is greater than zero.  This can be used to update D_BOREHOLE.  In
addition, a new BH_COMMENT field is created tracking this update.

#### V_SYS_CHK_BH_ELEV_MISSING

This view returns borehole and location information where the BH_GND_ELEV and
BH_GND_ELEV_OUOM is NULL and LOC_COORD_EASTING and LOC_COORD_NORTHING are
not.

#### V_SYS_CHK_CORR_DEPTH_DBORE_FBGS

Returns records from D_BOREHOLE with re=calculated elevations and depths based
on the assumption that the current OUOM units are [fbgs] rather than [mbgs].
This should be used to update the table by limiting the affected records to
specific locations (by LOC_ID).

#### V_SYS_CHK_CORR_DEPTH_DGL_FBGS

Returns records from D_GEOLOGY_LAYER with re-calculated elevations and depths
based on the assumption that the current OUOM units are [fbgs] rather than
[mbgs].  This should be used to update the table by limited the affected
records to specific records (by GEOL_ID) or locations (by LOC_ID).

#### V_SYS_CHK_CORR_DEPTH_DGF_FBGS

Returns records from D_GEOLOGY_FEATURE with re-calculated elevations and
depths based on the assumption that the current OUOM units are [fbgs] rather
than [mbgs].  This should be used to update the table by limited the affected
records to specific records (by FEATURE_ID) or locations (by LOC_ID).

#### V_SYS_CHK_CORR_DEPTH_DIM_FBGS

Returns records from D_INTERVAL_MONITOR with re-calculated elevations and
depths based on the assumption that the current OUOM units are [fbgs] rather
than [mbgs].  This should be used to update the table by limited the affected
records to specific records (by MON_ID) or locations (by LOC_ID).

#### V_SYS_CHK_CORR_DEPTH_DIT2_FBGS

Returns records from D_INTERVAL_TEMPORAL_2 with re-calculated elevations and
depths based on the assumption that the current OUOM units are [fbgs] rather
than [mbgs].  This should be used to update the table by limited the affected
records to specific records (by SYS_RECORD_ID), intervals (by INT_ID) or
locations (by LOC_ID).

#### V_SYS_CHK_CORR_DEPTH_DPICK_FBGS

Returns records from D_PICK with re-calculated elevations and depths based on
the assumption that the original OUOM units in D_GEOLOGY_LAYER were [fbgs]
rather than [mbgs].  This should be used to update the table by limited the
affected records to specific records (by SYS_RECORD_ID) or locations (by
LOC_ID).

#### V_SYS_CHK_CORR_DEPTH_DBC_FBGS

Returns records from D_BOREHOLE_CONSTRUCTION with re-calculated elevations and
depths based on the assumption that the current OUOM units are [fbgs] rather
than [mbgs].  This should be used to update the table by limited the affected
records to specific records (by SYS_RECORD_ID) or locations (by LOC_ID or
BH_ID).

#### V_SYS_CHK_CORR_ELEV_CMP

Compares the BH_GND_ELEV (from D_BOREHOLE) to the ASSIGNED_ELEV (from
D_LOCATION_ELEV), returning those records where the difference does not fall
with the range of +/- [SYS_ELEV_RANGE] (from S_CONSTANT).  Only valid
locations are examined (i.e. excluded QA_COORD_CONFICENCE_CODEs [117] and
[118]).

Note that this can return multiple records for a location if there are
multiple records in D_LOCATION_ELEV_HIST and they fall within the range of the
BH_GND_ELEV value.

#### V_SYS_CHK_CORR_ELEV_CMP_UNQ

Using V_SYS_CHK_CORR_ELEV_CMP as a base, returns only those locations for
which a single record is found (i.e. there are not multiple values in
D_LOCATION_ELEV_HIST that can be considered possible corrections).

#### V_SYS_CHK_CORR_ELEV_D2

Returns those records from D_INTERVAL_TEMPORAL_2 where the RD_VALUE does not
match a recalculated value where the original units are expressed as depths
(e.g. [mbgs], [fbgs], etc...) within a specified uncertainty.
V_SYS_INT_REF_ELEV_RANGE is used as a base for the reference elevation.  The
original values must be populated.  This can be used to update the values in
the temporal table.

#### V_SYS_CHK_CORR_ELEV_D5

Returns those records from D_INTERVAL_TEMPORAL_5 where the RD_VALUE does not
match a recalculated value where the original units are expressed as depths
(e.g. [mbgs], [fbgs], etc...) within a specified uncertainty.
V_SYS_INT_REF_ELEV_RANGE is used as a base for the reference elevation.  The
original values must be populated.  This can be used to update the values in
the temporal table.

#### V_SYS_CHK_CORR_ELEV_DBC

Returns those records from D_BOREHOLE_CONSTRUCTION where the CON_TOP_ELEV or
CON_BOT_ELEV do not match the recalculated values within a specified
uncertainty.  This can be used to update the values in the latter table.

#### V_SYS_CHK_CORR_ELEV_DBORE

Returns those records from D_BOREHOLE where the BH_BOTTOM_ELEV does not match
the recalculated value within a specified uncertainty.  This can be used to
update the value in the latter table.

#### V_SYS_CHK_CORR_ELEV_DGF

Returns those records from D_GEOLOGY_FEATURE where the FEATURE_TOP_ELEV or
FEATURE_BOT_ELEV do not match the recalculated values within a specfiied
uncertainty.  This can be used to update the values in the latter table.

#### V_SYS_CHK_CORR_ELEV_DGL

Returns those records from D_GEOLOGY_LAYER where the GEOL_TOP_ELEV or
GEOL_BOT_ELEV do not match the recalculated values within a specfied
uncertainty.  This can be used to update the values in the latter table.

#### V_SYS_CHK_CORR_ELEV_DIM

Returns those records from D_INTERVAL_MONITOR where the MON_TOP_ELEV or
MON_BOT_ELEV do not match the recalculated values within a specified
uncertainty.  This can be used to update the values in the latter table.

#### V_SYS_CHK_CORR_ELEV_DIRE

Using V_SYS_INT_REF_ELEV_RANGE as a base, returns those records where the
REF_ELEV value (from D_INTERVAL_REF_ELEV) does not match a re-calculated
reference elevation (incorporating REF_STICK_UP and BH_GND_ELEV) within a
specified uncertainty.  This can be used to update the values in the latter
table.

#### V_SYS_CHK_CORR_ELEV_DIS

Returns those records from D_INTERVAL_SOIL where the SOIL_TOP_ELEV or
SOIL_BOT_ELEV do not match the recalculated values within a specified
uncertainty.  This can be used to update the values in the latter table.

#### V_SYS_CHK_CORR_ELEV_DPICK

Using V_SYS_CHK_ELEV_DPICK as a base, returns those records from D_PICK where
the TOP_ELEV does not match a re-calculated top elevation (within a specified
uncertainty).  This can be used to update the values in the latter table.

#### V_SYS_CHK_CORR_ELEV_TAG

This view returns those locations (and their coordinates) who have COORD_CHECK
tagged field (with a default value of [10000]) in D_LOOCATION_GEOM.  This is
used as a preliminary step in the processing of elevation corrections by
location when coordinates have been changed/updated (namely that of
determining the new elevation using an external GIS source).

#### V_SYS_CHK_CORR_TEMP_D2

Returns records from D_INTERVAL_TEMPORAL_2 that should be standardized to the
UNIT_CODE [3] (i.e. [C]).  No translation of RD_VALUEs was currently found
necessary.

#### V_SYS_CHK_CORR_WLS_BARO

In some cases, barometric data has been incorporated without correction of an
offset value; this can be found, in general where the imported values are less
than [300]; these values are corrected by adding the offset (of [950]) back to
the original value; both [cmap baro] and [map bar] are corrected

#### V_SYS_CHK_DECOMM_STATUS

Returns the LOC_ID and LOC_STATUS_CODE for decommissioned well locations (i.e.
those with a LOC_TYPE_CODE of [27]) where the latter has note been
appropriately assigned.  Appropriate LOC_STATUS_CODEs include

* Abandoned ([3])
* Unknown ([4])
* Assumed Abandoned ([5])
* Assumed Destroyed ([6])
* Decommissioned ([7])
* Decommissioned Pumping Well - Municipal ([13])
* Decommissioned Monitoring Well ([14])

All others should have their LOC_STATUS_CODE updated to a value of [7] (i.e.
Decommissioned).

#### V_SYS_CHK_DGL_BEDROCK

Returns all LOC_IDs where a bedrock material (as defined in the
R_GEOL_MAT1_CODE column GEOL_MAT1_ROCK) is present in GEOL_MAT1_CODE in
D_GEOLOGY_LAYER

#### V_SYS_CHK_DGL_COUNTS

This view returns the number of geologic layers in D_GEOLOGY_LAYER as well as
the number of these layers that consist only of whole numbers.  Likely,
multiple rows of whole numbers for a particular location indicate that the
row(s) should likely have the units 'fbgs' (or similar).

#### V_SYS_CHK_DGL_DEPTHS_MOE

This view returns information from D_GEOLOGY_LAYER where: the location is
identified as from the MOE WWDB; the units for the row is identified as
'mbgs'; the values for the row are whole numbers; the GEOL_SUBCLASS_CODE is
not '5' (i.e. 'Original (or Corrected)').  The MOE_PDF_LINK is incorporated
from W_GENERAL.  A total number of geologic layers as well as the number of
geologic layers whose depths are whole numbers is calculated.

#### V_SYS_CHK_DGL_ELEVS

Returns the original and re-calculated elevations (based on BH_GND_ELEV) for
the records in D_GEOLOGY_LAYER where these two sets of values do not match
(within a specified uncertainty).  Note that SYS_TEMP1 and SYS_TEMP2 are
tagged with the current date (such that they can be used as flagged values).
The OUOM values must be populated with units of either [mbgs] or [fbgs].

#### V_SYS_CHK_DGL_ELEV_OUOM

Recalculates the GEOL_TOP_OUOM and GEOL_BOT_OUOM values in D_GEOLOGY_LAYER
where the GEOL_UNIT_OUOM is recorded in [masl] or [fasl] (converting them to a
depth, instead).  When using this to update the table, remember to update the
original units field.

#### V_SYS_CHK_DGL_MAT1_DCR

This view checks D_GEOLOGY_LAYER where the particular location has an
INT_TYPE_CODE of '27' ('Decommissioned'; i.e. DCR) and returns the number of
geologic layers whose materials match common 'fill' (i.e. well
decommissioning) materials.  These include:

* Clay ('5')
* Fill ('1')
* Gravel ('11')
* Limestone ('28')
* Stones ('12') 

The count of these layers as well as the count of the total number of geologic
layers (from V_SYS_SUMMARY_GEOL_LAYER_NUM) is returned.  If these values match
(or are close) then it's possible that the well is decommissioned (otherwise,
it may be a valid well/borehole).  

#### V_SYS_CHK_DGL_MAT1_NULL_DCR

This view checks D_GEOLOGY_LAYER where the particular location has an
INT_TYPE_CODE of '27' ('Decommissioned'; i.e. DCR) and returns the number of
geologic layers where the GEOL_MAT1_CODE is NULL.  The total number of
geologic layers (from V_SYS_SUMMARY_GEOL_LAYER_NUM) is returned as well.  If
these values match, it's likely that the well is decommissioned.

#### V_SYS_CHK_DGL_MULT_UNIT_OUOM

This view examines the D_GEOLOGY_LAYER looking for rows, from a single
location, where differing 'original units of measure' (OUOM) for depth have
been used (i.e. the field GEOL_UNIT_OUOM).  These rows should subsequently be
updated to a single measurement unit consistent for that location.  Note that
this should be done before a number of the other V_SYS_CHK_DGL_* views are
examined.

#### V_SYS_CHK_DGL_SINGLE_LIME

This view returns those locations where only a single geologic layer has been
specified (using V_SYS_GEOL_LAY_UNIT_OUOM) and that layer material type has
been specified as GEOL_MAT1_CODE '15' (i.e. 'Limestone').  Note that the
GEOL_SUBCLASS_CODE (which is used to 'tag' those locations that have been
checked and/or corrected) must have a NULL value.  This is used to determine
those possible locations (generally from the MOE) where the original record is
for decommissioning a well (and the limestone reference here is for 'limestone
screenings' or gravel).  However, in many cases, a single record of limestone
will be correct; this should be handled on a case-by-case basis.

#### V_SYS_CHK_DGL_SINGLE_UNKN

This view is similar to V_SYS_CHK_DGL_SINGLE_LIME (above) with the exception
that GEOL_MAT1_CODE is '0' (i.e. 'Unknown').

#### V_SYS_CHK_DGL_SINGLE_UNKN_SFC

This view is similar to V_SYS_CHECK_DGL_SINGLE_UNKN; here, though, an
additional check is made as to whether the layer is occurring at surface (i.e.
GEOL_TOP_OUOM is '0').

#### V_SYS_CHK_DGL_SINGLE_UNKN_SFC_NOPUMP

This view is similar to V_SYS_CHK_DGL_SINGLE_UNKNOWN_SFC; here, though, an
additional check is made as to whether there is any pumping information
associated with this location.

#### V_SYS_CHK_DGL_SINGLE_UNKN_SFC_NOPUMP_ABD

This view is similar to V_SYS_CHK_DGL_SINGLE_UNKN_SFC_NOPUMP; here, though, an
additional check is made as to whether the locations LOC_STATUS_CODE has a
value of '3' (i.e. 'Abandoned').

#### V_SYS_CHK_DGL_UNITS

This view returns information from D_GEOLOGY_LAYER using locations (i.e. the
LOC_ID) that appear in V_SYS_CHK_DGL_COUNTS.  This allows a check of the depth
units for the complete geology at a particular location.

#### V_SYS_CHK_DGL_UNITS_UPDATE

Returns the original and re-calculated elevations (based on a non-null
BH_GND_ELEV) for the records in D_GEOLOGY_LAYER where the OUOM values are
entirly whole numbers and the current units are [mbgs].  These values are
interpreted as being, instead, in [fbgs] and should be updated.  Note that for
consistency, all of the records in D_GEOLOGY_LAYER must be whole numbers.  In
addition, SYS_TEMP1 and SYS_TEMP2 are tagged with the current date (such that
they can be used as flagged values).

#### V_SYS_CHK_DIFA_[model]_ADD

Using V_SYS_LOC_MODEL_[model] as a base, returns those records/intervals that
should be added to D_INTERVAL_FORM_ASSIGN for that particular model.  These
views include each of CM2004, DM2007, ECM2006, RM2004, WB2018, WB2021 and YT32011
models.

#### V_SYS_CHK_DIFA_[model]_REMOVE

Returns those records/intervals that should be removed from
D_INTERVAL_FORM_ASSIGN that should no longer be considered as touching upon
the particular [model] area.  These views include each of CM2004, DM2007, 
ECM2006, RM2004, WB2018, WB2021 and YT32011 models.

#### V_SYS_CHK_DIFA_GL_[geologic unit]_[model]_THICK

Using V_SYS_DIFA_GL_[geologic unit]_[model] as a base, extracts those records
from D_INTERVAL_FORM_ASSIGN that have a top- or bottom-layer assigned to the
[geologic unit] for the particular [model] and currently does not have a
record of thickness of the layer at this location (i.e. it is currently set to
NULL).

#### V_SYS_CHK_DIRE

This view returns pertinent information from D_INTERVAL_REF_ELEV with regard
to interval reference elevations.  Of particular importance is the
transformation of REF_POINT from a text field to a numeric value allowing for
direct update of REF_STICK_UP and REF_OFFSET.t

Note that REF_POINT is used to store the stick up value for the interval as it
is the only one of the offset fields available to be modified by SiteFX.

#### V_SYS_CHK_DLCH_ALL_ELEV_ID

Returns the coordinates for a location from D_LOCATION along with the current
coordinates from D_LOCATION_COORD_HIST where there is no LOC_ELEV_ID (i.e. an
elevation) directly associated with these records (in the latter table).  Note
that the QA_COORD_CONFIDENCE_CODE must be valid.

#### V_SYS_CHK_DLCH_BH_ELEV_ID

Using V_SYS_CHK_DLCH_ALL_ELEV_ID as a source, includes the BH_GND_ELEV from
D_BOREHOLE.

#### V_SYS_CHK_DLSH_ELEV_UPD

Returns those LOC_IDs from D_LOCATION_GEOM (as well as their associated
coordinates and spatial id) whose position has been checked (or changed) and
whose elevation needs to be updated.  These are marked with a COORD_CHECK
value matching DEF_DLSH_ELEV_UPD. 

This can be used by an external GIS to associated a new elevation with a
spatial id.

#### V_SYS_CHK_DOC_AUTHOR_AGENCY

This view assembles information from D_DOCUMENT where the
DOC_AUTHOR_AGENCY_CODE is NULL (or the DOC_AUTHOR_AGENCY_DESCRIPTION is NULL).

#### V_SYS_CHK_DOC_YN_FIELDS

This view examines the D_DOCUMENT table, specifically the '*_YN' fields.  It
reassigns all '0' values to NULL and all '-1' values to '1' (for consistency).
These values need to be reassigned back to the source table. 

#### V_SYS_CHK_DUP_DGEOLLAY

This view examines the D_GEOLOGY_LAYER table and looks for duplicate records
by LOC_ID.  The fields used include: GEOL_MAT_COLOUR_CODE, GEOL_MAT1_CODE
through GEOL_MAT4_CODE, as well as the top and bottom _OUOM values.  The
latter is rounded to the specified number of digits (using the DEF_ROUND_CMP
system constant).  All duplicates are returned.

#### V_SYS_CHK_DUP_DGEOLLAY_DEL

Using V_SYS_CHK_DUP_DGEOLLAY as a source, returns the LOC_ID and GEOL_ID
fields indicating what records are duplicate for a particular LOC_ID and that
can be deleted (the minimum GEOL_ID of the duplicates are kept).

#### V_SYS_CHK_DUP_DINT

This view examines D_INTERVAL and looks for duplicate records by LOC_ID.
The fields used include: INT_NAME, INT_TYPE_CODE and INT_COMMENT.  All
duplicates are returned.  In addition, the number of screens and soil
intervals as well as the counts of lab and field data are returned for 
each INT_ID associated with the particular LOC_ID.

#### V_SYS_CHK_DUP_DINT_DEL

Using V_SYS_CHK_DUP_DINT as a source, returns the LOC_ID and INT_ID fields
indicating those records that can be deleted.  Note that the presence of any
lab or field data for a particular interval disqualifies it from being deleted
(these should be manually examined).  Note that the minimum INT_ID of the
duplicates are kept.

In some cases, the maximum INT_ID should be chosen to be kept instead of the 
minimum INT_ID (this is determined manually).  Refer to V_SYS_CHK_DUP_DINT_DEL_MAX.

#### V_SYS_CHK_DUP_DINT_DEL_MAX

Using V_SYS_CHK_DUP_DINT as a source, returns the LOC_ID and INT_ID fields
indicating those records that can be deleted.  Note that the presence of any
lab or field data for a particular interval disqualifies it from being deleted
(these should be manually examined). Note that the maximum INT_ID of the
duplicates are kept. 

In some cases, the maximum INT_ID should be chosen to be kept instead of the
minimum INT_ID.  This must be manually determined.

#### V_SYS_CHK_DUP_DINTMON

This view examines D_INTERVAL_MONITOR and looks for duplicate records by
LOC_ID. The fields used include: MON_SCREEN_MATERIAL, MON_SCREEN_SLOT,
MON_COMMENT, MON_DIAMETER_OUOM and MON_DIAMETER_UNIT_OUOM as well as the
MON_TOP_OUOM and MON_BOT_OUOM values rounded to the specified number of digits
(as found in the system constant DEF_ROUND_CMP).  In addition, the number of
field and lab samples are included.

#### V_SYS_CHK_DUP_DINTMON_DEL

Using V_SYS_CHK_DUP_DINTMON as a source, returns the LOC_ID, INT_ID and MON_ID
fields indicating those records that can be deleted.  Note that the presence
of any lab or field data for a particular interval disqualifies it from being
deleted (these records should be manually examined).  Note that the minimum
MON_ID is kept.

#### V_SYS_CHK_DUP_DINTSOIL

This view examines D_INTERVAL_SOIL and looks for duplicate records by LOC_ID.
The fields used include: SOIL_UNIT_OUOM, SOIL_COMMENT, SOIL_BLOW_COUNT,
SOIL_RECOVERY (a rounded value), SOIL_MOISTURE (a rounded value) and both
SOIL_TOP_OUOM and SOIL_BOT_OUOM (also rounded).  The indicated fields are
rounded to the specified number of digits based upon the system constant
DEF_ROUND_CMP. In addition, the number of lab and field samples are included.
All duplicates are returned.

#### V_SYS_CHK_DUP_DINTSOIL_DEL

Using V_SYS_CHK_DUP_DINTSOIL as a source, returns the LOC_ID, INT_ID and
SYS_RECORD_ID indicating those records that can be deleted.  Note that the
presence of any lab or field data for a particular interval desqualifies it
from being deleted (these records should be manually examined).  Note that the
minimum SYS_RECORD_ID is kept.

In some cases, the maximum SYS_RECORD_ID should be kept - refer to
V_SYS_CHK_DUP_DINTSOIL_DEL_MAX.  This should be manually determined.

#### V_SYS_CHK_DUP_DINTSOIL_DEL_MAX

Using V_SYS_CHK_DUP_DINTSOIL as a source, returns the LOC_ID, INT_ID and
SYS_RECORD_ID indicating those records that can be deleted.  Note that the
presence of any lab or field data for a particular interval desqualifies it
from being deleted (these records should be manually examined).  Note that the
maximum SYS_RECORD_ID is kept.

In some cases, the maximum SYS_RECORD_ID should be chosen to remain instead of
the minium SYS_RECORD_ID.  This should be manually determined.

#### V_SYS_CHK_DUP_DINT_ALT1

This view examines D_INTERVAL and looks for duplicate records by LOC_ID.
The fields used include: INT_NAME_ALT1, INT_TYPE_CODE and INT_COMMENT.  All
duplicates are returned.  In addition, the number of screens and soil
intervals as well as the counts of lab and field data are returned for 
each INT_ID associated with the particular LOC_ID.

#### V_SYS_CHK_DUP_DINT_ALT1_DEL

Using V_SYS_CHK_DUP_DINT_ALT1 as a source, returns the LOC_ID and INT_ID fields
indicating those records that can be deleted.  Note that the presence of any
lab or field data for a particular interval disqualifies it from being deleted
(these should be manually examined).  Note that the minimum INT_ID of the
duplicates are kept.

#### V_SYS_CHK_DUP_DIRE

This view examines D_INTERVAL_REF_ELEV and looks for duplicate records by
LOC_ID.  The fields used include: REF_ELEV_UNIT_OUOM, REF_COMMENT and each of
REF_ELEV_OUOM and REF_STICK_UP (the latter two are rounded to the specified
digits by the DEF_ROUND_CMP system constant). In addition, the number of lab
and field samples are included.  All duplicates are returned.

#### V_SYS_CHK_DUP_DIRE_DEL

Using V_SYS_CHK_DUP_DIRE as a source, returns the LOC_ID, INT_ID and
SYS_RECORD_ID indicating those records that can be deleted.  Note that the
presence of any lab or field data for a particular interval desqualifies it
from being deleted (these records should be manually examined).  Note that the
minimum SYS_RECORD_ID is kept.

#### V_SYS_CHK_DUP_DIT1AB

This view examines D_INTERVAL_TEMPORAL_1A and D_INTERVAL_TEMPORAL_1B and looks
for duplicate records by LOC_ID.  The fields used include: RD_NAME_CODE,
SAM_SAMPLE_DATE, RD_VALUE, UNIT_CODE and RD_NAME_OUOM.

#### V_SYS_CHK_DUP_DIT1B_DEL

Using V_SYS_CHK_DUP_DIT1AB as a source, returns the LOC_ID, INT_ID, SAM_ID and
SYS_RECORD_ID indicating those records that can be deleted.  Note that the
minimum SYS_RECORD_ID is kept.

#### V_SYS_CHK_ELEV_DBORE

Returns those records from D_BOREHOLE where BH_GND_ELEV does not match
ASSIGNED_ELEV in D_LOCATION_ELEV (within a specified uncertainty).  The latter
is also returned along with the associated record in D_LOCATION_ELEV_HIST and
coordinate information from D_LOCATION.  The coordinates must be valid.

#### V_SYS_CHK_ELEV_DBORE_UPD

This view returns those records from D_BOREHOLE and D_LOCATION_ELEV where the
BH_GND_ELEV varies from the ASSIGNED_ELEV beyond a specified minimum range (as
determined by the SYS_ELEV_RANGE constant in S_CONSTANT).  Pertinent
information is included from D_LOCATION, D_LOCATION_QA and
D_LOCATION_ELEV_HIST in order to determine the reason for the change in
elevation.  New elevations should be added to D_LOCATION_ELEV_HIST following
by an update of D_LOCATION_ELEV. Various information is assembled in fields to
allow easy update of the requisite tables.

Note that only locations with valid QA_COORD_CONFIDENCE_CODEs (i.e. not [117]
or [118]) will be examined.  In addition, BH_GND_ELEV cannot be null and the
LOC_ELEV_CODE (from D_LOCATION_ELEV_HIST) must be [null] or have a value of
[3] (i.e. DEM - MNR 10m v2).

#### V_SYS_CHK_ELEV_DPICK

Checks elevation of pick (from D_PICK) against the elevations in D_BOREHOLE
and D_LOCATION_ELEV.  Calculates new elevations based upon these two values.

#### V_SYS_CHK_GEOL_LAY_BOT_ELEV_DEPTH

This view returns the deepest geologic layer elevation and calculated depth
(for the latter, subtracting the smallest elevation value from the largest
elevation value).

#### V_SYS_CHK_GEOL_LAY_ELEV

This view returns a subset of D_GEOLOGY_LAYER information as well as
associated elevation (from D_LOCATION_ELEV) for all locations.

#### V_SYS_CHK_INT_ELEVS_DEPTHS

This view returns all associated elevations and depths for all intervals.
This includes all elevations from D_BOREHOLE, D_INTERVAL_REF_ELEV (including
REF_STICK_UP and REF_OFFSET) and D_LOCATION_ELEV_HIST.  In addition, each of
the following is included: the deepest geologic formation from
D_GEOLOGY_LAYER; the top and bottom elevation and depths from
D_INTERVAL_MONITOR; the deepest construction bottom from
D_BOREHOLE_CONSTRUCTION; and the average water level elevation (and calculated
depth) from D_INTERVAL_SUMMARY.  Only those locations with valid coordinates
are examined.

This was originally used for correcting borehole depths (and screen depths).

#### V_SYS_CHK_INT_ELEVS_DEPTHS_\*

These series of views use V_SYS_CHK_INT_ELEVS_DEPTHS as a base with
comparisons between fields specifically defined to detect particular errors
(in borehole depth, screen elevations, etc?).  All of these views do not
consider any location whose QA_COORD_CONFIDENCE_CODE is '118' (i.e. 'YPDT -
Assigned Township Centroid').  These include

* V_SYS_CHK_INT_ELEVS_DEPTHS_BH_MON_BOT_DIFF
    + This view returns those rows whose BH_BOTTOM_ELEV and MON_BOTTOM_ELEV
    have a difference greater than '10m'.
* V_SYS_CHK_INT_ELEVS_DEPTHS_BH_VS_MAX
    + This view returns those rows whose BH_BOTTOM_DEPTH (plus '0.1m') is less
    than the MAX_DEPTH_M (i.e. the borehole bottom depth from D_BOREHOLE is
    above the maximum calculated depth available).
* V_SYS_CHK_INT_ELEVS_DEPTHS_BH_VS_MON_BOT
    + This view returns those rows whose BH_BOTTOM_ELEV is greater than the
    MON_BOT_ELEV (plus '0.1m'; i.e. the borehole bottom elevation from
    D_BOREHOLE is above the bottom of the screen elevation).
* V_SYS_CHK_INT_ELEVS_DEPTHS_BH_VS_WL
    + This view returns those rows whose BH_BOTTOM_ELEV is greater than the
    WL_AVG_MASL (i.e. the average water level is below the bottom of the
    borehole).
* V_SYS_CHK_INT_ELEVS_DEPTHS_MON_BOT_LT_0
    + This view returns those rows whose MON_BOT_ELEV has a value less than
    zero.
* V_SYS_CHK_INT_ELEVS_DEPTHS_MON_BOT_TOP
    + This view returns those rows whose MON_BOT_ELEV is above that of the
    MON_TOP_ELEV (i.e. the top and bottom screen elevations are likely
    reversed).
* V_SYS_CHK_INT_ELEVS_DEPTHS_MON_M_LT_0
    + This view returns those rows whose MON_TOP_DEPTH_M or MON_BOT_DEPTH_M
    are less than zero.

#### V_SYS_CHK_INT_MON_DEPTHS_M

This view returns the calculated screen depths from D_INTERVAL_MONITOR where
MON_TOP_DEPTH_M and MON_BOT_DEPTH_M is NULL and MON_TOP_OUOM and MON_BOT_OUOM
is not NULL.  Using the OUOM fields, the depths are calculated for the
original units of 'mbgs', 'fbgs' and 'masl' (which is subtracted from
ASSIGNED_ELEV); a '-9999' tag is returned for other units.  Only those with
valid coordinates are examined.

#### V_SYS_CHK_INT_MON_ELEV_DEPTH

This view returns the current depths and elevations from D_INTERVAL_MONITOR as
well as BH_GND_ELEV, BH_GND_BOTTOM_ELEV and BH_BOTTOM_DEPTH from D_BOREHOLE.
The ASSIGNED_ELEV is extracted from D_LOCATION_ELEV and LOC_ELEV_MASL_ORIG is
from V_SYS_ELEV_ORIGINAL. This should be used as a check between the borehole
depth and screened interval depth.

#### V_SYS_CHK_INT_MISSING

Assembles information from D_LOCATION for input into D_INTERVAL where no record 
currently exists.  This only applies to regional locations specified through the 
LOC_STUDY field in D_LOCATION.

Note that this is limited to interval types [Well or Borehole], [Surface Water], 
[Climate Station] and [Pumping Station].

#### V_SYS_CHK_INT_MON_MISSING

Assembles information from D_INTERVAL for input into D_INTERVAL_MONITOR where no 
record currently exists.  This only applies to regional locations specified through 
the LOC_STUDY field in D_LOCATION.

Note that this is limited to interval types [Surface Water Flow Gauge], 
[Surface Water Spot Stage Elevation], [Screen Information Omitted] and 
[Pumping Station].

Used in conjunction with V_SYS_CHK_INT_MISSING, this allows locations to be 
included in the V_CON_\* views highlighting their missing information.

#### V_SYS_CHK_INT_REF_ELEV

This view returns those locations where the ASSIGNED_ELEV (from
D_LOCATION_ELEV) does not lie within the REF_ELEV minus the REF_STICK_UP (from
D_INTERVAL_REF_ELEV).  Only those locations where ASSIGNED_ELEV matches
BH_GND_ELEV (from D_BOREHOLE) and only a single record (for the particular
interval) is present in D_INTERVAL_REF_ELEV (using V_SYS_INT_REF_ELEV_COUNT)
are considered.  The reference ground elevation, the new reference elevation
(using ASSIGNED_ELEV and REF_STICK_UP) and the absolute difference between
ASSIGNED_ELEV and the reference ground elevation is calculated.

#### V_SYS_CHK_INT_REF_ELEV_CURRENT

Using V_SYS_INT_REF_ELEV_CURRENT as a base, checks D_INTERVAL_REF_ELEV for
reference elevation date ranges that overlap with the current date range
(starting from REF_ELEV_START_DATE).  When this occurs, RCOUNT will have a
value greater than [1] for a particular INT_ID.  These should be corrected.

#### V_SYS_CHK_INT_REF_OFFSET

Returns those records from D_INTERVAL_REF_ELEV (and using
V_SYS_INT_REF_ELEV_RANGE) where REF_POINT (converted to a numeric value) does
not match REF_STICK_UP (in metres) within a specified uncertainty.  This
should be used to correct REF_STICK_UP as changes using SiteFX are only
applied to REF_POINT. 

#### V_SYS_CHK_INT_SOIL_DEPTHS_M

This view returns the calculated SOIL_TOP_M and SOIL_BOT_M from
D_INTERVAL_SOIL.  Both depths ('fbgs' and 'mbgs') and elevations ('masl'; the
latter in conjunction with ASSIGNED_ELEV) in the original units of measure are
used; a value of '-9999' is otherwise returned.  The original values must be
present and the SOIL_TOP_M and SOIL_BOT_M must be NULL.

#### V_SYS_CHK_INT_SUM_ADD

This view returns a list of INT_ID's not present in D_INTERVAL_SUMMARY.  This
is used to automatically update the table with new intervals.

#### V_SYS_CHK_INT_SUM_REMOVE

This view turns a list of INT_ID's that exist in D_INTERVAL_SUMMARY but are no
longer found in D_INTERVAL.  This is used to automatically remove rows from
the summary table.  Note that CASCADE rules are present as part of the
database schema to automatically remove intervals from this table once they
have been removed from D_INTERVAL.

#### V_SYS_CHK_INT_TMP1A_SAID

Returns a list of SAM_IDs present in D_INTERVAL_TEMPORAL_1A that likely refer
to the same sample (grouped by INT_ID, SAM_SAMPLE_DATE and SAM_SAMPLE_NAME).

In addition, a new SYS_ANALYIS_ID is calculated to allow these disparate
SAM_IDs to be grouped.  Note that only those records that have a current
SYS_ANALYSIS_ID value of NULL are examined.

#### V_SYS_CHK_INT_TMP1A_SAMID

This view returns a list of SAM_ID's from D_INTERVAL_TEMPORAL_1A that have no
related records in D_INTERVAL_TEMPORAL_1B.  This should be used to remove
these records.

#### V_SYS_CHK_INT_TMP1B_MOVE

Assembles the records from D_INTERVAL_TEMPORAL_1A and D_INTERVAL_TEMPORAL_1B
into a format that can be used as an input into D_INTERVAL_TEMPORAL_2.  In
some cases, data is loaded into the former tables that should be located in
the latter table - this allows the easy transfer between the two (the records
would then be deleted in the _1A/_1B tables).

#### V_SYS_CHK_INT_TMP1B_SAMID

This view returns a list of SAM_ID's from D_INTERVAL_TEMPORAL_1B that have no
related records in D_INTERVAL_TEMPORAL_1A.  This should be used to remove
these records.

#### V_SYS_CHK_INT_TMP1_DUPLICATES

This view returns duplicate records from D_INTERVAL_TEMPORAL_1B/1A using
comparisons between INT_ID, RD_NAME_CODE, SAM_SAMPLE_DATE, RD_VALUE and
UNIT_CODE.  The number of records and the minimum SYS_RECORD_ID (from
D_INTERVAL_TEMPORAL_1B) is also returned - the latter is chosen, by default,
to remain in the database.  Refer to V_SYS_CHK_INT_TMP1_DUPLICATES_DEL_SRI,
below.  Information from D_DATA_SOURCE (tagged by DATA_ID) is included.

#### V_SYS_CHK_INT_TMP1_DUPLICATES2

Similar to V_SYS_CHK_INT_TMP1_DUPLICATES, this view returns possible duplicate
records from D_INTERVAL_TEMPORAL_1B/1A.  However, only INT_ID, RD_NAME_CODE
and SAM_SAMPLE_DATE area examined.  As such, no automatic deletion should be
made (based upon minimum SYS_RECORD_ID) - a manual examination of the
results should be undertaken (deletion or assignment of an appropriate
REC_STATUS_CODE should be applied carefully).

#### V_SYS_CHK_INT_TMP1_DUPLICATES_DEL_SRI

This view returns the duplicate row SYS_RECORD_ID values - these can be used
to remove the records from D_INTERVAL_TEMPORAL_1B.

#### V_SYS_CHK_INT_TMP1_DUPLICATES_NUM

This view, using V_SYS_CHK_INT_TMP1_DUPLICATES as a source, returns the number
of duplicate records in D_INTERVAL_TEMPORAL_1B.  This includes all rows.

#### V_SYS_CHK_INT_TMP1_DUPLICATES_NUM_DEL

This view, using V_SYS_CHK_INT_TMP1_DUPLICATES as a source, returns the number
of records to be deleted from D_INTERVAL_TEMPORAL_1B.  This value should be
less than that returned from V_SYS_CHK_INT_TMP1_DUPLICATES_NUM.

#### V_SYS_CHK_INT_TMP1_UNITS

This view returns those records from D_INTERVAL_TEMPORAL_1A and
D_INTERVAL_TEMPORAL_1B where units in the latter table are inappropriate for
lab-based analysis (e.g.'masl' and 'mbgs'; any rows tagged with these units
should likely be in D_INTERVAL_TEMPORAL_2).

#### V_SYS_CHK_INT_TMP2_DUPLICATES

This view returns duplicate records from D_INTERVAL_TEMPORAL_2 using
comparisons between INT_ID, RD_NAME_CODE, RD_DATE, RD_VALUE and UNIT_CODE.
The number of records and the minimum as well as the maximum SYS_RECORD_ID
(from D_INTERVAL_TEMPORAL_2) is also returned - the minimum is usually chosen,
by default, to remain in the database.  Refer to
V_SYS_CHK_INT_TMP2_DUPLICATES_DEL_SRI, below.  Information from D_DATA_SOURCE
(tagged by DATA_ID) is included.

#### V_SYS_CHK_INT_TMP2_DUPLICATES2

This view is similar to V_SYS_CHK_INT_TMP2_DUPLICATES.  In this case, though,
the UNIT_CODE and RD_TYPE_CODE is not used for grouping records to find those
that are duplicates.  This should be used carefully and no automatic view
should subsequently be used to delete the records.  An example of its use can
be found in Appendix G.35.

#### V_SYS_CHK_INT_TMP2_DUPLICATES3

This view is similar to V_SYS_CHK_INT_TMP2_DUPLICATES2.  In this case, the
RD_VALUE is not used for grouping records in order to find those that are
duplicates.  This should be used extremely carefully and no automatic view
should subsequently be used to delete records.

#### V_SYS_CHK_INT_TMP2_DUPLICATES_DEL_SRI

This view returns the duplicate row SYS_RECORD_ID values - these can be used
to remove the records from D_INTERVAL_TEMPORAL_2.  The minimum SYS_RECORD_ID
(i.e. MIN_SYS_RECORD_ID) is used in this case.

#### V_SYS_CHK_INT_TMP2_DUPLICATES_NUM

This view, using V_SYS_CHK_INT_TMP2_DUPLICATES as a source, returns the number
of duplicate records in D_INTERVAL_TEMPORAL_2.  This includes all rows.

#### V_SYS_CHK_INT_TMP2_DUPLICATES_NUM_DEL

This view, using V_SYS_CHK_INT_TMP2_DUPLICATES as a source, returns the number
of records to be deleted from D_INTERVAL_TEMPORAL_2.  This value should be
less than that returned from V_SYS_CHK_INT_TMP2_DUPLICATES_NUM.

#### V_SYS_CHK_INT_TMP2_SOIL

This view returns all records from D_INTERVAL_TEMPORAL_2 that are associated
with soil intervals (i.e. INT_TYPE_CODE '29').

#### V_SYS_CHK_INT_TMP5_DUPLICATES

Returns duplicate records from D_INTERVAL_TEMPORAL_5 using comparisons
between: INT_ID, RD_NAME_CODE, RD_DATE, RD_VALUE and UNIT_CODE.  The number of
records and the minimum as well as the maximum SYS_RECORD_ID is also returned.
The minimum is usually chosen, by default, to remain in the database.
Information from D_DATA_SOURCE (tagged by DATA_ID) is included.

#### V_SYS_CHK_INT_TMP5_DUPLICATES_DEL_SRI

Returns the duplicate SYS_RECORD_ID values using V_SYS_CHK_INT_TMP2_DUPLICATES
as a source.  These can be used to remove the records from
D_INTERVAL_TEMPORAL_2 (using the minimum SYS_RECORD_ID in this case). 

#### V_SYS_CHK_INT_TMP5_MOVE_TMP1A

If chemistry data for surface water stations have been loaded into
D_INTERVAL_TEMPORAL_5, this view can be used to create the format by which to
populate required fields in D_INTERVAL_TEMPORAL_1A facilitating the movement
of the data between the two temporal tables. Note that SYS_TEMP1 and SYS_TEMP2
are populated with a date (string or integer) to allow these *new* samples to
be referenced.  

This should be used in combination with V_SYS_CHK_INT_TMP5_TMP1B to actually
*move* the information between the tables.

Additional checks are made to differentiate between chemistry-related data
captured in the field and that produced within a lab.  Only the following
reading groups will be allowed (which determines the RD_NAME_CODEs that
can be moved):

* Chemistry - General (Water or Soil/Rock) ([26])
* Chemistry - Metals (Water or Soil/Rock) ([2])
* Water - Bacteriological Related ([36])
* Water - Major Ions ([1])
* Water - Miscellaneous Organics ([28])

Additional groups could be included in the future.

In addition, the following RD_NAME_CODEs are ignored:

* Dissolved Oxygen ([201])
* Temperature (Water) - Field ([609])
* Temperature (Water) - Logger ([70871])

Additional RD_NAME_CODEs could be included in the future.

#### V_SYS_CHK_INT_TMP5_MOVE_TMP1B

In conjunction with V_SYS_CHK_INT_TMP5_MOVE_TMP1A, this view enables the
copying of information between the D_INTERVAL_TEMPORAL_5 and
D_INTERVAL_TEMPORAL_1B tables.  This should be the second view used.  The same
limitations as the V_SyS_CHK_INT_TMP5_MOVE_TMP1A are used.

Note that an RKEY value is generated which indicates a particular row number
of the data being assembled.  This can be used to generate a new SYS_RECORD_ID
for inclusion in D_INTERVAL_TEMPORAL_1B.  The D5_SYS_RECORD_ID field should be
used to tag the data that should be deleted once it has been copied.

#### V_SYS_CHK_LOC_ADDRESS

This view is to be used as an aid for correcting location position, it returns
various address fields as well as the current and original coordinates.  In
addition, the translated township and country descriptions (based upon
LOC_TOWNSHIP_CODE) are included.  If the location is an MOE borehole, the MOE
PDF link is returned.

#### V_SYS_CHK_LOC_COORDS

This view returns the coordinate and coordinate-quality information (from
D_LOCATION and D_LOCATION_QA) where LOC_COORD_EASTING or LOC_COORD_NORTHING is
NULL.  Only QA_COORD_CONFIDENCE_CODE's that do not have a value of '117' (i.e.
'YPDT - Invalid ?') are considered.

#### V_SYS_CHK_LOC_COORDS_CHECK

This view returns those locations whose spatial coordinates in D_LOCATION_GEOM
(i.e. in GEOM) do not match the (x,y) coordinates in D_LOCATION (i.e.
LOC_COORD_EASTING and LOC_COORD_NORTHING).  This is signified by COORD_CHECK
(in D_LOCATION_GEOM) having a non-null value (this column is increment using a
weekly check process).  The CURRENT_COORD coordinates from
D_LOCATION_COORD_HIST, if available, are also returned.  This should be used
to monitor and correct invalid changes in coordinates.

#### V_SYS_CHK_LOC_COORDS_CHECK_UPDATE

This view returns the calculated GEOM and GEOM_WKB for a location where
COORD_CHECK (from D_LOCATION_GEOM) is not null; the latter signifies that a
change has been made in the coordinates that do match the spatial geometry
(i.e. GEOM).  Note that the current coordinates in D_LOCATION_COORD_HIST must
match the coordinate values in D_LOCATION.  The two spatial geometry fields,
here, should be used to update the fields in D_LOCATION_GEOM.

#### V_SYS_CHK_LOC_COORDS_CURR

This view returns the coordinates from D_LOCATION where the location currently
has no recorded values in D_LOCATION_COORD_HIST.  This is used to update the
latter table - a CURRENT_COORD field is present set to a '1' value (indicating
that this is the current coordinates).  Note that there must be a valid
coordinate in either (or both) of LOC_COORD_EASTING or LOC_COORD_NORTHING.

#### V_SYS_CHK_LOC_COORDS_MOE_UPD

Extracts all coordinates associated with a particular LOC_ID that has had 
coordinates added in the latest MOE update (as specified by DEF_MOE_UPD_DID
in S_CONSTANT).

#### V_SYS_CHK_LOC_ELEV

This view extracts all elevations from D_LOCATION_ELEV_HIST and D_BORHOLE
where the ASSIGNED_ELEV in D_LOCATION_ELEV is NULL.  This can be used to
populate the latter table (with an ASSIGNED_ELEV value).  Note that this is an
older view and should be updated to incorporate changes in the two
location-elevation tables or discarded.

#### V_SYS_CHK_LOC_ELEV_ASSIGNED_ALL

This view returns all elevations from the D_LOCATION_ELEV and
D_LOCATION_ELEV_HIST (the latter through a series of views) associated with a
particular location.

#### V_SYS_CHK_LOC_ELEV_MISSING

This view returns all locations (by LOC_ID) that are currently not found in
D_LOCATION_ELEV (i.e. there is no ASSIGNED_ELEV).  Note that LOC_TYPE_CODE's
'22' (i.e. 'Permit to Take Water') and '25' (i.e. 'Documents') are excluded.
The QA_COORD_CONFIDENCE_CODE for the location cannot be '117' (i.e. 'YPDT -
Coordinate Invalid ?').

#### V_SYS_CHK_LOC_ELEV_MISSING_DEM_GEOM

This view returns the LOC_ID and GEOM from D_LOCATION_GEOM; this is mainly
used to determine various DEM elevations for these locations.  Note that
LOC_TYPE_CODE's '22' (i.e. 'Permit to Take Water') and '25' (i.e. 'Documents')
are excluded as well as those locations with a QA_COORD_CONFIDENCE_CODE of
'117' (i.e. 'YPDT - Coordinate Invalid ?') or '118' (i.e. 'YPDT - Assigned
Township Centroid ?').  The location is excluded, in addition, if it already
has the elevations from the 'DEM - MNR 10m v2' or 'DEM - SRTM 90m v41'
surfaces (i.e. LOC_ELEV_CODE's '3' and '5' as found in D_LOCATION_ELEV_HIST).

#### V_SYS_CHK_LOC_ELEV_MISSING_GEOM

Using V_SYS_CHK_LOC_ELEV_MISSING as a source this view returns the LOC_ID and
GEOM for each location.

#### V_SYS_CHK_LOC_ELEV_SURV_NULL

This view returns all elevations associated with a particular location
where the
QA_ELEV_CONFIDENCE_CODE is '1' (i.e. it has been surveyed) but no surveyed
elevation is present in D_LOCATION_ELEV_HIST (i.e. having a LOC_ELEV_CODE of
'1').  This should be used to determine the input surveyed elevation.

#### V_SYS_CHK_LOC_GEOM_ADD

This view returns any LOC_ID not currently present in D_LOCATION_GEOM (that
has a valid location).  This is used to automatically add missing locations
into the latter table.

#### V_SYS_CHK_LOC_GEOM_CHANGE

This view returns any LOC_ID where the calculated spatial geometry (from
V_SYS_LOC_GEOMETRY) does not match the stored spatial geometry in
D_LOCATION_GEOM.  This is used to automatically tag locations whose
coordinates should be checked.  Note that this view uses the built-in function
'STEquals' for spatial geometry comparisons (the function returns a '1' if
they match, a '0' otherwise).

#### V_SYS_CHK_LOC_GEOM_COORD_CHECK

This returns all locations as well as their spatial geometry from
D_LOCATION_GEOM where COORD_CHECK is not NULL.  The latter indicates where the
spatial geometry differs from the current LOC_COORD_EASTING and
LOC_COORD_NORTHING in D_LOCATION.

#### V_SYS_CHK_LOC_GEOM_COORD_CHECK_REVIEW

This view returns the original spatial geometries (both GEOM and GEOM_WKB) as
well as the new calculated spatial geometries (new_GEOM and new_GEOM_WKB) for
a location where the COORD_CHECK value is not NULL.  This can be used to
update D_LOCATION_GEOM after checking.

#### V_SYS_CHK_LOC_GEOM_REMOVE

This view returns all locations (by LOC_ID) from D_LOCATION_GEOM that no
longer exist in D_LOCATION.  Note that the database schema has been updated
with CASCADE statements to automate this removal process - this view may be
removed in the future.

#### V_SYS_CHK_LOC_GEOM_WKB_UPDATE

This view returns all locations (by LOC_ID) where GEOM_WKB in D_LOCATION_GEOM
is currently a NULL value.  This is used to tag locations where this field
should be populated.

#### V_SYS_CHK_LOC_SUM_ADD

This view returns all locations (by LOC_ID) from D_LOCATION that are currently
not found in D_LOCATION_SUMMARY.  This is used to automatically add locations
to the latter table.

#### V_SYS_CHK_LOC_SUM_REMOVE

This view returns all locations (by LOC_ID) from D_LOCATION_SUMMARY that are
no longer found in D_LOCATION.  This is used to automatically remove locations
from the former table.  Note that changes to the database schema using CASCADE
statements  may have made the use of this view surplus - it may be removed in
the future.

#### V_SYS_CHK_MOE_WELL_ID_ATAG

Returns the MOE ATAG and associated MOE_WELL_ID by location.  Note that, in
this case, an MOE well is defined as having a MOE_WELL_ID in the
D_LOCATION_ALIAS table (i.e. an LOC_ALIAS_TYPE_CODE of [1]).

#### V_SYS_CHK_MOE_WELL_ID_DUP

One of the views used to determine whether multiple boreholes have been
imported that are, in reality, the describing the same location.  This view
examines the D_LOCATION_ALIAS table, grouping by LOC_NAME_ALIAS for
MOE_WELL_IDs (i.e. LOC_ALIAS_TYPE_CODE of [4]) and returning those records
(and their related D_LOCATION information) where the MOE_WELL_ID has been
applied to multiple locations.

#### V_SYS_CHK_MOE_WELL_ID_DUP_UPD

One of the views used to determine whether multiple boreholes have been
imported that could be describing the same location.  Using
V_SYS_CHK_MOE_WELL_ID_DUP as a base, this view returns for each MOE_WELL_ID:
the LOC_ID and (possibly) duplicate LOC_IDs; the LOC_MASTER_LOC_ID and
duplicate LOC_MASTER_LOC_IDs; the DATA_IDs and duplicate DATA_IDs (using
V_SYS_MOE_DATA_ID); the SYS_TIME_STAMP and duplicate SYS_TIME_STAMPs. In
addition, the number of MOE_BORE_HOLE_IDs that have been used for the
particular MOE_WELL_ID (using V_SYS_MOE_LOCATIONS).

#### V_SYS_CHK_MOE_WELL_ID_DUP_UPD2

One of the views used to determine whether multiple boreholes have been
imported that could be describing the same location.  Using
V_SYS_CHK_MOE_WELL_ID_DUP_UPD as a base, this view returns MOE_BORE_HOLE_IDs
associated with both the LOC_IDs and (possibly) duplicate LOC_IDs.  This is
only looking for MOE_BORE_HOLE_ID counts of [1]; this removes the complication
of having grouped MOE locations with a null MOE_BORE_HOLE_ID (for
non-duplicates) indicative of a manual import of a borehole with a subsequent
MOE WWDB import.

#### V_SYS_CHK_MOE_WELL_ID_DUP_UPD3

One of the views used to determine whether multiple boreholes have been
imported that could be describing the same location.  Using
V_SYS_CHK_MOE_WELL_ID_DUP_UPD as a base, this view returns MOE_BORE_HOLE_IDs
where the LOC_ID matches the LOC_MASTER_LOC_ID (i.e. either a single or master
location) and the duplicate LOC_ID and LOC_MASTER_LOC_ID match as well (there
is a one-to-one relationship in both cases).  This should allow for relatively
easy comparison between the two locations.

#### V_SYS_CHK_MOE_WELL_ID_DUP_UPD4

One of the views used to determine whether multiple boreholes have been
imported that could be describing the same location.  Using
V_SYS_CHK_MOE_WELL_ID_DUP_UPD3 as a base, this view returns each of the Audit
Number (LOC_ALIAS_TYPE_CODE of [2]), ATAG Number (LOC_ALIAS_TYPE_CODE of [1]),
the MOE_BORE_HOLE_ID (LOC_ALIAS_TYPE_CODE of [3]) as well as the MOE_WELL_ID
(LOC_ALIAS_TYPE_CODE of [4]) for each LOC_ID and duplicate LOC_ID.

#### V_SYS_CHK_MOE_WELL_ID_DUP_UPD5

One of the views used to determine whether multiple boreholes have been
imported that could be describing the same location.  Using
V_SYS_CHK_MOE_WELL_ID_DUP_UPD3 as a base, this view returns records from
D_GEOLOGY_FEATURE that can be transferred from the duplicate LOC_ID (normally,
this information would not be manually entered for a non-MOE well).

#### V_SYS_CHK_MOE_WELL_ID_DUP_UPD6

One of the views used to determine whether multiple boreholes have been
imported that could be describing the same location.  Using
V_SYS_CHK_MOE_WELL_ID_DUP_UPD3 as a base, this view returns records from
D_PUMPTEST that can be transferred from the duplicate LOC_ID (normally, this
information would not be manually entered for a non-MOE well).

#### V_SYS_CHK_MOE_WELL_ID_DUP_UPD7

One of the views used to determine whether multiple boreholes have been
imported that could be describing the same location.  Using
V_SYS_CHK_MOE_WELL_ID_DUP_UPD6 as a base, this view returns records from
D_PUMPTEST_STEP that can be transferred from the duplicate LOC_ID (normally,
this information would not be manually entered for a non-MOE well).

#### V_SYS_CHK_MOE_WELL_ID_LON

This returns the MOE_WELL_ID from the D_LOCATION_ALIAS table based upon the
LOC_ALIAS_TYPE_CODE (of [4]) as well as assembling the MOE_WELL_ID from the
LOC_ORIGINAL_NAME (i.e. [LON]) from D_LOCATION. It should be used as an error
checking mechanism with regard to the correct assignment of the WELL_ID for
the location.

Note that only certain LOC_TYPE_CODEs are evaluated (i.e. [Well or Borehole],
[Archive], [Decommissioning Record], [MOE Error] or [MOE Upgrade/Maintenance
Well Record]).  In addition, the LOC_ORIGINAL_NAME must be seven characters
long and be numeric.

#### V_SYS_CHK_MON_BOT_GT_BOT_ELEV

This view checks if the elevation of the bottom of any screen (from
D_INTERVAL_MONITOR) is below the elevation of the bottom of the borehole (from
D_BOREHOLE).  Note that a value of '0.001' is added to the former to account
for slight rounding errors introduced during data entry.

#### V_SYS_CHK_PARAM_UNITS_DIT1B

Returns a count of records that are associated with a particular combined
RD_NAME_CODE and UNIT_CODE along with their descriptions.  This should be used
to consolidate the original records into consistent units.

#### V_SYS_CHK_PARAM_UNITS_DIT1B_MGL

Returns recalculated values for parameters with a reading group of [Water -
Major Ions] or [Chemistry - General (Water &/or Soil/Rock)] converting their
current units (of various form) to mg/L.

#### V_SYS_CHK_PARAM_UNITS_DIT1B_RNC_C

Returns the recalculated values (as necessary) for any units associated with 
temperature 'C' as defined by the UNIT_DEFAULT field in R_UNIT_CODE.  This 
is limited to those RD_NAME_CODEs that have a RD_NAME_DEFAULT_UNIT set to 'C'.
The 'new' units are indicated and can be used to update the associated fields.

#### V_SYS_CHK_PARAM_UNITS_DIT1B_RNC_MGL

Returns the recalculated values (as necessary) for any units associated with 
the units 'mg/L' as defined by the UNIT_DEFAULT field in R_UNIT_CODE.  This 
is limited to those RD_NAME_CODEs that have a RD_NAME_DEFAULT_UNIT set to
'mg/L'.  The 'new' units are indicated and can be used to update the associated fields.

#### V_SYS_CHK_PARAM_UNITS_DIT1B_RNC_OOO

Returns the recalculated values (as necessary) for any units associated with the 
units [o/oo] as defined by the UNIT_DEFAULT field in R_UNIT_CODE.  This is limited to 
those RD_NAME_CODEs that have a RD_NAME_DEFAULT_UNIT set to [o/oo].  The new units 
are indicated and can be used to update the associated fields.

#### V_SYS_CHK_PARAM_UNITS_DIT1B_RNC_PERC

Returns the recalculated values (as necessary) for any units associated with 
the units '%' (i.e. percentage) as defined by the UNIT_DEFAULT field in R_UNIT_CODE.  This 
is limited to those RD_NAME_CODEs that have a RD_NAME_DEFAULT_UNIT set to
'%'.  The 'new' units are indicated and can be used to update the associated fields.

#### V_SYS_CHK_PARAM_UNITS_DIT1B_RNC_PH

Returns the recalculated values (as necessary) for any units associated with the units 
[pH Units] as defined by the UNIT_DEFAULT field in R_UNIT_CODE.  This is limited to 
those RD_NAME_CODEs that have a RD_NAME_DEFAULT_UNIT set to [pH Units].  The new units 
are indicated and can be used to update the associated fields.

#### V_SYS_CHK_PARAM_UNITS_DIT1B_RNC_UGL

Returns the recalculated values (as necessary) for any units associated with 
the units 'ug/L' as defined by the UNIT_DEFAULT field in R_UNIT_CODE.  This 
is limited to those RD_NAME_CODEs that have a RD_NAME_DEFAULT_UNIT set to
'ug/L'.  The 'new' units are indicated and can be used to update the associated fields.

#### V_SYS_CHK_PARAM_UNITS_DIT1B_RNC_USCM

Returns the recalculated values (as necessary) for any units associated with 
the units 'uS/cm' as defined by the UNIT_DEFAULT field in R_UNIT_CODE.  This 
is limited to those RD_NAME_CODEs that have a RD_NAME_DEFAULT_UNIT set to
'uS/cm'.  The 'new' units are indicated and can be used to update the associated fields.

#### V_SYS_CHK_PARAM_UNITS_DIT1B_UGL

Returns recalculated values for parameters with a reading group of [Chemistry
- Metals (Water &/or Soil/Rock)], [Water - VOCs], [Water - Pesticides &
Herbicides], [PAHs (Water &/or Soil/Rock)], [Water - Miscellaneous Organics],
[SVOCs (Water &/or Soil/Rock)] or [PHCs (Water &/or Soil/Rock)] converting
their current units (of various form) to ug/L.

#### V_SYS_CHK_PARAM_UNITS_EQUIV

Using the DEFAULT_UNIT field in R_UNIT_CODE, this view returns the current
unit code and description matched to the preferred unit code (and related
description).  This is used by the various value conversion routines (usually
for temporal data).

#### V_SYS_CHK_PICK_ABOVE_GND_BELOW_BOT

Returns all records from D_PICK along with calculations comparing the pick
elevation (i.e. TOP_ELEV) with the ground elevation (i.e. GND_ELEV).  If this
elevation is above the ground surface, a value of [1] is stored in
DIFF_PICK_GND_ELEV_TOP_ELEV.  If this elevation is below the bottom of the
borehole, a value of [1] is stored in DIFF_TOP_ELEV_BH_BOTTOM_ELEV.  In
addition, the TOP_ELEV is compared with the BH_GND_ELEV and ASSIGNED_ELEV
values.

#### V_SYS_CHK_PICK_ELEV

This view compares the GND_ELEV (from D_PICK) with that of BH_GND_ELEV (from
D_BOREHOLE) and ASSIGNED_ELEV (from D_LOCATION_ELEV), calculating their
differences.  If either of these differences (which should contain the same
value) are greater than an absolute value of '0.1m' the resultant row(s) are
returned.  The difference can be added to TOP_ELEV (and GND_ELEV) as a
correction factor.

#### V_SYS_CHK_PICK_ELEV_CMP

Using the views V_SYS_PICK_\*, assembles picks for all formations (idenfified
by numeric layer) for each LOC_ID (using D_BOREHOLE as a master list of
locations).  This can be used to check for invalid picks with regard to
elevations of the ordered layers (i.e. the layers should have descending
elevation values). 

The possible layer names, their abbreviations and order are:

1. Late stage glaciolacustrine
    + LATESTG
    + LS
2. Halton/Kettleby Till
    + HALTON
    + HAL
3. Mackinaw/Oak Ridges (MIS/ORAC)
    + MISORAC
    + MIS
4. Channel - Clay or Channel - Silt
    + CHANAQUITARD
    + CAQT
5. Channel - Sand or Channel - Gravel
    + CHANAQUIFER
    + CAQF
6. Upper Newmarket
    + NEWMARKUPP
    + NUP
7. Inter New Market Sediment
    + NEWMARKINT
    + NIN
8. Lower Newmarket
    + NEWMARKLOW
    + NLO
9. Thorncliffe
    + THORNCLIFFE
    + THO
10. Sunnybrook
    + SUNNYBROOK
    + SUN
11. Scarborough
    + SCARBOROUGH
    + SCA
12. Bedrock
    + BEDROCK
    + BED

#### V_SYS_CHK_PICK_ELEV_CMP_\*

Using V_SYS_CHK_PICK_ELEV_CMP as a base, looks for erroneous picks for a
particular geologic layer where its elevation exceeds that of any layers above
it or is lower than that of any layers below it.

#### V_SYS_CHK_PICK_GEOL_UNIT_CODE

Using the text found in FORMATION (in the case of a [multi-pick], the final
[Top of ...] text is used), determines the appropriate GEOL_UNIT_CODE (from
R_GEOL_UNIT_CODE) to be assigned for the particular record.  This allows
for standardized comparison.

#### V_SYS_CHK_PICK_ORIG_GND_ELEV

This view compares the original ground elevation (from D_LOCATION_ELEV_HIST
using a LOC_ELEV_CODE of '2', i.e. 'Original') with the GND_ELEV from D_PICK.
If the difference is larger than +/- 1, a record is returned.  Note that
SYS_RECORD_ID is from D_PICK.

#### V_SYS_CHK_PICK_ORIG_GND_ELEV_DIFF

This view returns a variety of information using V_SYS_CHK_PICK_ORIG_GND_ELEV
as a base.  It is to be used to evaluate pick errors from D_PICK.

#### V_SYS_CHK_SCREEN_ASSUMED

Returns a variety of locational and other information associated with
intervals to which an [Assumed Screen] has been assigned; this is used for
error checking as these intervals have been seen to be problematic in some
cases (usually to do with the observed static water level)

#### V_SYS_CHK_SEARCH

This view assembles the names, coordinates and various elevations that can be
used when examining issues with, for example, water level surfaces (e.g. the
presence of bulleys).

#### V_SYS_CHK_SEARCH_LIDR

The LOC_ID from which coordinates are to be accessed when searching within 
the database for nearby locations.  This value is stored in the S_CONSTANT
table using the CONST_NAME [SYS_SEARCH_LOC_ID].

Note that the default LOC_ID is arbitrary.

#### V_SYS_CHK_SEARCH_XYR

This is a pre-defined routine that allow the user to search within a specified 
distance (as determined by [SYS_SEARCH_RADIUS]) from specified coordinates (as 
set by [SYS_SEARCH_XY]).  Note that both of these constants are found in S_CONSTANT; 
the latter makes use of both VALF (for the x-coordinate) and VALF2 (for the
y-coordinate).  These would need to be set by the 
user in advance of using this view.

Note that this was originally created as a means by which to check on locations 
based upon a given coordinate in order to fix errors in the calculation of the 
average water level.  The default coordinates are arbitrary.

#### V_SYS_CHK_SPEC_CAP_CALC

This view returns calculated values of specific capacity, using
V_SYS_SPEC_CAP_CALC as a source, that do not already appear in
D_INTERVAL_TEMPORAL_2 (by interval and date).  Note that the RD_NAME_CODE
'748' (i.e. 'Specific Capacity') is returned and used as a check.  The
calculated specific capacity cannot be a NULL value. 

#### V_SYS_CHK_WLS_GEOL_UNIT_RD_UNIT

This view compares water level elevation values and geology layer elevation
values based upon their OUOM units.  Where the average water level elevation
is below that of the bottom of the borehole, the GEOL_UNIT_OUOM and
RD_UNIT_OUOM values are returned along with the count of number of records.
Note that UGAIS wells are specifically ignored (using V_SYS_UGAIS_ALL).

#### V_SYS_CHK_WL_LOGGER

Calculates a new water level elevation for logger data from
D_INTERVAL_TEMPORAL_2 using the original values (where present).

#### V_SYS_CHK_WL_MIN_GT_BOT_ELEV

This view checks if the elevation of the lowest water level (from
D_INTERVAL_TEMPORAL_2) is below the elevation of the bottom of the borehole
(from D_BOREHOLE).  Note that a value of '0.001' is added to the former to
account for slight rounding errors introduced during data entry.  The minimum
water level is determined using V_SYS_WATERLEVELS_RANGE.

#### V_SYS_CHK_WL_OUOM_CORR

Returns calculated depths (in [mbref]) for those records in
D_INTERVAL_TEMPORAL_2 with a UNIT_CODE of [6] (i.e. [masl]) and with the OUOM
values and units stored as [above probe] (e.g. as [cmap uncomp uncal], [map
uncal] or [map uncomp uncal]).  The reference elevation is matched using
V_SYS_INT_REF_ELEV_RANGE.

#### V_SYS_CHK_WL_RUO_REF_ELEV

This view checks for those water level logger records where RD_VALUE is [0],
the RD_VALUE_OUOM matches the reference elevation and the RD_UNIT_OUOM is
[mbref].

This appears to be a problem with York database records

#### V_SYS_CHK_WL_STATIC

Calculates a new water level elevation for manual data from
D_INTERVAL_TEMPORAL_2 using the original values (where present).

#### V_SYS_CHK_WL_STATIC_CMP

Extracts the RD_DATE and RD_VALUE for every static water level in
D_INTERVAL_TEMPORAL_2 along with the average logger water level within a
plus/minus one-hour interval.  The number of logger values are record and the
difference between the manual and logger water level is calculated.

A combination of a NULL value for LOGGER_RD_VALUE with a non-NULL value for
LOGGER_RCOUNT indicates that the RD_VALUE for the logger data is not
populated.  If the LOGGER_RCOUNT value is also NULL then no logger data exists
to match against the manual water level.

#### V_SYS_CONST_ELEV_RANGE

Returns the value of the constant SYS_ELEV_RANGE as specified in S_CONSTANT.
This uses the value stored in the field VALF (i.e. a floating point value).

#### V_SYS_DATETIME_STR

Returns the current datetime.  In addition, converts this datetime to a text
string as well as breaking out each of its component parts as both numeric and
text.  It also creates a SYS_TEMP1 and SYS_TEMP2 compatible format.

#### V_SYS_DBLIST_FIELDS

Returns a list of fields/columns (as FIELD_NAME) present within the ORMPG
database.  These include all fields found in both tables and views (refer to
V_SYS_DBLIST_VIEWS for exceptions).

#### V_SYS_DBLIST_FIELDS_INFO

Returns a list of fields/columns (as FIELD_NAME) and their associated
characteristics as present within the ORMPG database.  This information
includes: the table or view source name; numeric (or other) typet; etc...
These include all fields found in both tables and views (refer to
V_SYS_DBLIST_VIEWS for exceptions).

#### V_SYS_DBLIST_FIELDS_MISSING

Returns a list of fields/columns (as FIELD_NAME), using V_SYS_DBLIST_FIELDS as
a source, that are not present within S_DESC_FIELDS.

#### V_SYS_DBLIST_TABLES

Returns a list of tables (as TABLE_NAME) present within the ORMPG database.

#### V_SYS_DBLIST_TABLES_MISSING

Returns a list of tables (as TABLE_NAME), using V_SYS_DBLIST_TABLES as a
source, that are not present within S_DESC_TABLES.

#### V_SYS_DBLIST_TABLES_REMOVED

Compares the TABLE_NAME from S_DESC_TABLE against a current list of tables
using V_SYS_DBLIST_TABLES returning those that are present in the former but
not in the latter.  These have been removed from the database and should be
removed from S_DESC_TABLE.

#### V_SYS_DBLIST_VIEWS

Returns a list of views (as VIEW_NAME) present within the ORMPG database.
Those with the prefix [VSFX] are ignored.

#### V_SYS_DBLIST_VIEWS_MISSING

Returns a list of views (as VIEW_NAME), using V_SYS_DBLIST_VIEWS as a source,
that are not present within S_DESC_VIEWS.

#### V_SYS_DBLIST_VIEWS_REMOVED

Compares the VIEW_NAME from S_DESC_VIEW against a current list of views using
V_SYS_DBLIST_VIEWS returning those that are present in the former but not in
the latter.  These have been removed from the database and should be removed
from S_DESC_VIEW.

#### V_SYS_DGF_TOP_FEATURE

Returns the top-most (shallowest) geologic feature for a particular location
(sourced from D_GEOLOGY_FEATURE)

#### V_SYS_DGL_GL

Similar in function to V_SYS_DIFA_GL, this view assembles the top and bottom
depths for each record found in D_GEOLOGY_LAYER along with the (X,Y)
coordinates for the particular location.  The top and bottom elevations cannot
be null and the former must have a larger value than the latter.  This is the
base view used to determine the geologic unit in which this geologic layer
lies.

#### V_SYS_DGL_GL_ASSIGN

This view is used to populate GEOL_ASSIGNED_UNIT in D_GEOLOGY_LAYER based 
upon geologic units present in GEOL_TLAYER or GEOL_BLAYER.

#### V_SYS_DGL_TOTAL_GEOL_MAT1

Returns the minimum and maximum elevation as well as total thickness of
material by location and GEOL_MAT1_CODE.  In addition, the total number of
differing materials for GEOL_MAT1_CODE is also returned.

#### V_SYS_DGL_TOTAL_GEOL_MAT1_MAX

Using V_SYS_DGL_TOTAL_GEOL_MAT1 as a base, returns the thickest GEOL_MAT1_CODE
material found at a location.

#### V_SYS_DGL_TOTAL_GRAVEL

Calculates the total gravel thickness present at a particular location (by
LOC_ID).  Note that only GEOL_MAT1_CODE is examined with multiple unit
thicknesses summed; a [0] value is returned if no gravel is present.  In
addition, the top- and bottom-elevation must be populated.

#### V_SYS_DGL_TOTAL_SAND_GRAVEL

Calculates the total sand and gravel thickness present at a particular
location (by LOC_ID).  Note that only GEOL_MAT1_CODE is examined with multiple
unit thicknesses summed; a [0] value is returned if no sand and gravel is
present.  In addition, the top- and bottom-elevation must be populated.

#### V_SYS_DGL_UNIT_GRAVEL

This view returns the ASSIGNED_UNIT associated with a particular geologic
layer found in D_GEOLOGY_LAYER that is related to coarse material.

#### V_SYS_DIFAF_ASSIGN

This view examines the contents of D_INTERVAL_FORM_ASSIGN then returns the
'final' geologic unit to be assigned to an interval based upon the preferred
geologic model for the particular location (refer to Section 2.4.1 for a
description of the assignment details).  This can be used to populate
D_INTERVAL_FORM_ASSIGN_FINAL.

#### V_SYS_DIFA_ASSIGNED_FINAL

This view returns the assigned 'final' geologic unit to the particular
interval.  The units descriptive text is included.

#### V_SYS_DIFA_CMP

Returns the assigned geologic unit and unit code (from D_INTERVAL_FORM_ASSIGN)
for each interval from the variety of geologic models under examination; this
currently includes CM2004, YT32011, WB2018 and WB2021

#### V_SYS_DIFA_GL

This is the base view for a number of routines/views accessing the
D_INTERVAL_FORM_ASSIGN table.  In particular, it is used to generate the
information necessary to determine the penetration of the interval (i.e.
GL_SCREEN_M) into an aquifer as part of the Transmissivity and Hydraulic
Conductivity calculation (refer to V_SYS_PUMP_MOE_TRANS_SOURCE). The following
tables and views are accessed: V_SYS_GENERAL_INTERVAL; V_SYS_INT_MON_MAX_MIN;
D_INTERVAL_FORM_ASSIGN; R_GEOL_UNIT_CODE (for determining if a given layer is
classified as an AQUIFER). Both the MON_TOP_ELEV and MON_BOT_ELEV values must
be non-null.

If the top layer matches the bottom layer (with regard to the screen top and
bottom), the length of the screen is considered for penetration.  If the
bottom layer, only, is considered an aquifer, the distance from the bottom to
the bottom of the prevous layer is considered (this is also the default if no
condition is otherwise met). If the top layer, only, is considered an aquifer,
the distance from the top to the top of the next layer is considered. 

#### V_SYS_DIFA_GL_ASSIGN

This view determines the appropriate ASSIGNED_UNIT, by geologic model and
interval, based upon: the top and bottom units encountered by the screen;
whether either is an aquifer; the degree of penetration of the geologic layer
by the screen; etc...  The coding for the view should be examined for complete
details.

#### V_SYS_DIFA_GL_[geologic unit]

Using V_SYS_DIFA_GL as a base, returns all records from D_INTERVAL_FORM_ASSIGN
for which the interval has an assigned formation of [geologic unit].  Note
that, currently (as of 20200622), either of the top or bottom of the interval
must lie within the formation.

#### V_SYS_DIFA_GL_[geologic unit]_[model]

Using V_SYS_DIFA_GL_[geologic unit] as a base, returns those records from
D_INTERVAL_FORM_ASSIGN that correspond to the specified [model].

#### V_SYS_DIFA_GL_MOD_[model]

Using V_SYS_DIFA_GL as a base, returns those records that pass some error
checks and that correspond to the specified [model].  These
checks include: having valid top and bottom screen depths; the bottom depth
must be greater than the top depth; the top depth must be greater than or
equal to zero; the bottom depth must be greater than zero.

Note that this is used as part of the process for calculating the
Transmissivity and Hydraulic Conductivity for the particular interval.

#### V_SYS_DIT1_INT_PAR_DAY

Extracts every parameter from D_INTERVAL_TEMPORAL_1A/B with the original
SAM_SAMPLE_DATE converted to a string in the format [yyyymmdd].  The parameter
name and units are also present.  As any parameter can be recorded multiple
times on a particular day the minimum, maximum, count and average value is
returned.  This view can be used as a base to create a table-format
spreadsheet for examination of parameter changes over time for a particular
interval.

#### V_SYS_DIT3_ENVSCAN_DATAID

This is to be used to populate null DATA_IDs in D_INTERVAL_TEMPORAL_3 for 
Environment Canada climate records.  This relies upon a start- and end-date
specified in S_CONSTANT through DEF_CLIMATE_DDS_DATES and the actual DATA_ID
value to be used found in DEF_CLIMATE_DDS_DATAID.  This relies upon the
climate location being defined in D_CLIMATE and having a LOC_NAME_ALT1 value
of [Env Canada - Climate Station].

#### V_SYS_DIT_COUNTS

Returns the number of records as found in each of the temporal tables related
through INT_ID (and the associated LOC_ID).  Note that the counts from 1A are
the number of samples while the counts from 1B are the number of parameters.

#### V_SYS_DOC_BH_NONMOE_LOCNS

This view returns a list of the non-MOE PDFs assembled within the ORMGP Report
Library. By default, these are entitled [\<LOC_ID\>.pdf] and are stored within
the DOC_FOLDER_ID [10000].  This relies upon a definition of
LOC_ALIAS_TYPE_CODE of [6] (i.e. Borehole Document Name) in D_LOCATION_ALIAS
with the LOC_ID stored in the LOC_ALIAS_NAME field.

#### V_SYS_DOC_LAST_MODIFIED

Examining the SYS_TIME_STAMP and SYS_LAST_MODIFIED fields in D_LOCATION and 
D_DOCUMENT, returns the most recent date as DOC_LAST_MODIFIED.

#### V_SYS_DOC_REPLIB_ENTRY

This view returns the fields and values from D_DOCUMENT and D_LOCATION that
mimics the format of the table in the Microsoft Access Report Library
template.  It is used as a source to represent all documents currently stored
in the database.

#### V_SYS_ELEV_ASSIGNED

This view returns the 'assigned' elevation (as found in D_LOCATION_ELEV) with
the supporting information from D_LOCATION_ELEV_HIST (linked on LOC_ELEV_ID).

#### V_SYS_ELEV_ASSIGNED_ALL

This view returns all elevations associated with a particular location (by
LOC_ID).  Note that these include:

* Assigned Elevation (from D_LOCATION_ELEV)
* Surveyed (LOC_ELEV_CODE '1' - 'Surveyed') as LOC_ELEV_MASL_SURV
* Original Elevation (LOC_ELEV_CODE '2' - 'Original') as LOC_ELEV_MASL_ORIG
* Ministry of Natural Resources (MNR) Digital Elevation Model (DEM), version 2
  (10m resolution; LOC_ELEV_CODE '3' - 'DEM - MNR 10m v2') as
  LOC_ELEV_MASL_MNRV2t
* Shuttle Radar Topography Mission (SRTM) DEM, version 4.1 (90m resolution;
  LOC_ELEV_CODE '5' - 'DEM - SRTM 90m v41') as LOC_ELEV_MASL_SRTMV41

Additional elevations, not listed here, may be available in
D_LOCATION_ELEV_HIST (refer to R_LOC_ELEV_CODE).  This uses
V_SYS_ELEV_ASSIGNED (which must have a value for a particular location),
V_SYS_ELEV_DEM_MNR_V2, V_SYS_ELEV_DEM_SRTM_V41, V_SYS_ELEV_ORIGINAL and
V_SYS_ELEV_SURVEYED as sources.

#### V_SYS_ELEV_ASSIGNED_UPDATE

Returns all elevations associated with a particular location as well as the
elevation that should be used to update the ASSIGNED_ELEV (if it does not
already match).

#### V_SYS_ELEV_DEM_MNR_V2

This view returns the elevations for all locations that have a LOC_ELEV_CODE
of '3' (i.e. 'DEM - MNR 10m v2').

#### V_SYS_ELEV_DEM_SRTM_V41

This view returns the elevations for all locations that have a LOC_ELEV_CODE
of '5' (i.e. 'DEM - SRTM 90m v41').

#### V_SYS_ELEV_ORIGINAL

This view returns the elevations for all locations that have a LOC_ELEV_CODE
of '2' (i.e. 'Original').

#### V_SYS_ELEV_SURVEYED

This view returns the elevations for all locations that have a LOC_ELEV_CODE
of '1' (i.e. 'Surveyed').

#### V_SYS_ELEV_SURVEYED_DURHAM

This view returns the elevations for all locations that have a LOC_ELEV_CODE
of '10' (i.e. 'Surveyed - Durham Update').  These were all assumed to be
surveyed at the time of entry/update.

#### V_SYS_EXAMPLE_SHEET_\*

These views return location and interval data, from the database, in the
format required for manual data entry using the spreadsheet(s) as described in
Section 3.4.  These are to be used to provide familiar example information to
requisite partner agencies whom are undergoing entry of data into a
database-friendly format outside of the SiteFX environment.  The resultant
rows should be included in the file sent to the partner agency as example
worksheets (in addition to the blank, data entry sheets).  Note that fields
with NULL values are converted to empty strings for incorporating into
spreadsheets.

The example data extracted include each of the following:

* V_SYS_EXAMPLE_SHEET_A_LOCATION
    + This view incorporates data from D_LOCATION, D_LOCATION_QA and
    D_DATA_SOURCE.
* V_SYS_EXAMPLE_SHEET_B_BOREHOLE
    + This view incorporates data from D_BOREHOLE and D_LOCATION.
* V_SYS_EXAMPLE_SHEET_C_GEOLOGY
    + This view incorporates data from V_GEN_GEOLOGY and D_GEOLOGY_LAYER.
* V_SYS_EXAMPLE_SHEET_D_SCREEN
    + This view incorporates data from V_GEN_HYDROGEOLOGY, D_INTERVAL,
    D_INTERVAL_REF_ELEV and D_INTERVAL_MONITOR.  This is used as a source in
    '*_SCREEN_AND_SOIL', below.
* V_SYS_EXAMPLE_SHEET_D_SOIL
    + This view incorporates data from D_INTERVAL_SOIL, D_INTERVAL and
    V_GEN_BOREHOLE.  This is used as a source in '\*_SCREEN_AND_SOIL', below.
* V_SYS_EXAMPLE_SHEET_D_SCREEN_AND_SOIL
    + This view combines the results from V_SYS_EXAMPLE_SHEET_D_SCREEN and
    V_SYS_EXAMPLE_SHEET_D_SOIL, above, into a single view.
* V_SYS_EXAMPLE_SHEET_E_LAB_DATA
    + This view incorporates data from V_GEN_LAB and D_INTERVAL_TEMPORAL_1A.
* V_SYS_EXAMPLE_SHEET_F_FIELD_DATA
    + This view incorporates data from V_GEN_FIELD.

#### V_SYS_FIELD_WATERLEVELS_DAILY

This view returns the calculated daily average water level for both logger
(RD_NAME_CODE '629') and manual (RD_NAME_CODE '628') data for each interval,
if available.  Only those rows in D_INTERVAL_TEMPORAL_2 with UNIT_CODE '6'
(i.e. 'masl') are included.  Note that the maximum SYS_RECORD_ID is included
for referencing (i.e. in order to distinguish between rows in the resultant
dataset).  The datetime field (RD_DATE) is modified, dropping the hour and
minute data.

#### V_SYS_FIELD_WATERLEVELS_YEARLY

This view returns the water level minimum, maximum, difference and total
number of records for each interval for each year of data.  Note that data
from RD_NAME_CODEs '628' (i.e. 'Water Level - Manual - Static') and '629'
(i.e. 'Water Level - Logger (Compensated & Corrected)') are combined for these
calculations.  Only those records with UNIT_CODE '6' (i.e. 'masl') are
included.

#### V_SYS_FILTER_LOC_COORDS

Selects a subset of LOC_IDs from D_LOCATION based upon a number of checks.
This includes: having a QA_COORD_CODE (from V_SYS_LOC_COORDS) less than the
value specified by DEF_QACC_MAX_DISPLAY (as found in S_CONSTANT); being
located within the ORMGP study area (as specified through
V_SYS_AGENCY_ORGMP_LARGE); not being an 'Archive' LOC_TYPE_CODE; excluding
the Viewlog header well location (as specifed by V_SYS_YPDT_VL_HEADER_WELL).

This can be used to update the ORMGP_AREA tag in D_LOCATION_SUMMARY (instead
of accessing the view directly).

#### V_SYS_FILTER_LOC_COORDS_DOCS

Similar to V_SYS_FILTER_LOC_COORDS but including all document locations
(whether they have valid coordinates or not).

#### V_SYS_GEN_WL_AVERAGE

This view, using V_SYS_CHK_INT_ELEVS_DEPTHS as a source, returns those records
where WL_MASL_AVG is not null and the QA_COORD_CONFIDENCE_CODE is less than 
'6' (i.e. 'Margin of Error: 300m - 1km'; the uncertainty, then, would be less 
than 300m horizontal).  Both the spatial geometry (from D_LOCATION_GEOM) and 
the coordinates (from D_LOCATION) are included.  This can then be used for 
creating regional water level surfaces.

#### V_SYS_GEN_WL_AVERAGE_DEEP

Using V_SYS_GEN_WL_AVERAGE as a base, returns those records/intervals where the 
top of the interval has a depth of greater than (or equal to) [40] metres.

#### V_SYS_GEN_WL_AVERAGE_DEEP_BR

Using V_SYS_GEN_WL_AVERAGE_DEEP as a base, returns those records/intervals where 
the borehole intersects bedrock.

#### V_SYS_GEN_WL_AVERAGE_DEEP_NBR

Using V_SYS_GEN_WL_AVERAGE_DEEP as a base, returns those records/intervals where 
the borehole does not intersect bedrock.

#### V_SYS_GEN_WL_AVERAGE_MID

Using V_SYS_GEN_WL_AVERAGE as a base, returns those records/intervals where the 
top of the interval has a depth of greater than [20] and less than [40] metres.

#### V_SYS_GEN_WL_AVERAGE_SHALLOW

Using V_SYS_GEN_WL_AVERAGE as a base, returns those records/intervals where the 
bottom of the interval has a depth of less than (or equal to) [20] metres.

#### V_SYS_GEN_WL_AVERAGE_SHALLOW_MOD

This is a modification of the V_SYS_GEN_WL_AVERAGE_SHALLOW view.  In this case, 
assumed screens (i.e. intervals) are discarded unless they have more than [4] water 
level measurements recorded.

#### V_SYS_GEN_WL_AVERAGE_UNIT_SCAR

Using V_SYS_GEN_WL_AVERAGE as a source, returns those records whose assigned
geologic unit is [59] (i.e. Scarborough).

#### V_SYS_GEN_WL_AVERAGE_UNIT_SHAL

Using V_SYS_GEN_WL_AVERAGE as a source, returns those records whose assigned
geologic units is any of

*Late Stage Glaciolacustrine-Glaciofluvial ([1])
*Halton/Kettleby Till ([2])
*Mackinaw/Oak Ridges (MIS/ORAC) ([3])
*Upper Newmarket ([4])
*Inter Newmarket SedimentLower ([5])
*Newmarket Till/Northern Till ([87])
*Halton Till ([89])

This is specified as the shallow groundwater system and differs from
V_SYS_GEN_WL_AVERAGE_SHALLOW which imposes a fixed depth delineating the
shallow system.

#### V_SYS_GEN_WL_AVERAGE_UNIT_THORN

Using V_SYS_GEN_WL_AVERAGE as a source, returns those records whose assigned
geologic unit is [65] (i.e. Thorncliffe).

#### V_SYS_GEN_WL_SPOTFLOW

Returns those locations than have a non-zero average spotflow value recorded 
(from D_INTERVAL_SUMMARY).  The [Z] value is the elevation of the location
which is assumed to be equivalent to the water level (at surface).

Note that this is used as a test for incorporation of spotflow values as part 
of the shallow water table surface creation process.

#### V_SYS_GENERAL

This view extracts locations from D_LOCATION with valid coordinates (i.e. not
having a QA_COORD_CONFIDENCE_CODE of '117').  Note that documents
(LOC_TYPE_CODE '25') and the 'Viewlog Well Header' location (i.e. LOC_ID
'-2147483443') are not included.  This is used as a base for many V_GEN_*
views.

#### V_SYS_GENERAL_INTERVAL

This view extracts all intervals from D_INTERVAL that are present in
V_SYS_GENERAL; refer to V_SYS_GENERAL, above.  This is used as a base for many
V_GEN_* views that include interval information.

#### V_SYS_GEN_BH_INT_MUNIC_WELL

This view returns various associated information for municipal wells.  The
latter is defined as having the following attributes:

* PURPOSE_PRIMARY_CODE of '10' (i.e. 'Water Supply')
* PURPOSE_SECONDARY_CODE of '22' (i.e. 'Municipal Supply')
* LOC_TYPE_CODE of '1' (i.e. 'Well or Borehole')

#### V_SYS_GEN_BH_INT_MUNIC_WELL_CHANNEL

This view returns all municipal wells, using V_SYS_GEN_BH_INT_MUNIC_WELL as a
source, that are determined to be screened within a 'channel' geologic unit
(as defined by V_SYS_GEOL_UNIT_CHANNEL).

#### V_SYS_GEN_BH_INT_MUNIC_WELL_DEEP

This view returns all municipal wells, using V_SYS_GEN_BH_INT_MUNIC_WELL as a
source, that are determined to be screened within 'deep' geologic units (as
defined by V_SYS_GEOL_UNIT_DEEP).

#### V_SYS_GEN_BH_INT_MUNIC_WELL_SHALLOW

This view returns all municipal wells, using V_SYS_GEN_BH_INT_MUNIC_WELL as a
source, that are determined to be screened within 'shallow' geologic units (as
defined by V_SYS_GEOL_UNIT_SHALLOW).

#### V_SYS_GEN_LAB_STANDARD

This view returns all records from D_INTERVAL_TEMPORAL_1B/1A where the
specific parameter (as defined by RD_NAME_CODE) is considered to be a
'standard' parameter.  In addition, the REC_STATUS_CODE must have a value less
than '10'(values '10' or higher are considered to be unreliable).  Standard
parameters include (the parameters RD_NAME_CODE is in brackets):

* Alkalinity (86)
* Alkalinity (as CaCO3) (653)
* Alkalinity (Total Fixed Endpoint) (10813)
* Aluminum (92)
* Ammonia (93)
* Ammonia (as Nitrogen) (94)
* Antimony (96)
* Arsenic (97)
* Barium (100)
* Benzene (102)
* Beryllium (109)
* Bicarbonate (as HCO3) (111)
* Bismuth (119)
* Boron (121)
* Bromide (124)
* Cadmium (132)
* Calcium (133)
* Chloride (143)
* Chromium (152)
* Cobalt (160)
* Conductivity (163)
* Conductivity (Calculated) (680)
* Copper (164)
* Cyanide (Free) (169)
* Cyanide (Total) (168)
* Dissolved Inorganic Carbon (10759)
* Dissolved Organic Carbon (200)
* Ethylbenzene (215)
* Fluoride (226)
* Fluorine (227)
* Hardness (as CaCO3) (235)
* Ionic Balance (504)
* Iron (252)
* Langelier Index (506)
* Lead (258)
* Magnesium (268)
* Manganese (270)
* Mercury (273)
* Molybdenum (290)
* Nickel (297)
* Nitrate (298)
* Nitrate (as Nitrogen) (718)
* Nitrate \+ Nitrite (as Nitrogen) (716)
* Nitrite (300)
* Nitrite (as Nitrogen) (723)
* Orthophosphate (314)
* pH (326)
* pH at Saturation (327)
* pH at Saturation (Estimated) (10784)
* Potassium (339)
* Selenium (353)
* Silica (354)
* Silver (356)
* SiO2 (70772)
* Sodium (358)
* Strontium (362)
* Sulphate (364)
* Thallium (374)
* Thorium (375)
* Titanium (377)
* Toluene (379)
* Total Dissolved Solids (384)
* Total Kjeldahl Nitrogen (388)
* Total Phosphorus (334)
* Trichloroethylene (407)
* Turbidity (412)
* Uranium (413)
* Vanadium (414)
* Vinyl Chloride (417)
* Xylene (395)
* Zinc (424)

#### V_SYS_GEN_WL_AVERAGE

This view, using V_SYS_CHK_INT_ELEVS_DEPTHS as a source, returns those records
where WL_MASL_AVG is not null and the QA_COORD_CONFIDENCE_CODE is less than
'6' (i.e. 'Margin of Error: 300m - 1km'; the uncertainty, then, would be less
than 300m horizontal).  Both the spatial geometry (from D_LOCATION_GEOM) and
the coordinates (from D_LOCATION) are included.  This can then be used for
creating regional water level surfaces.

#### V_SYS_GEOL_LAYER_COUNT

Returns the number of geologic layers found in D_GEOLOGY_LAYER where the
GEOL_MAT1_CODE is not [Unknown].  This does not exclude NULL values, though.
Refer also to V_SYS_SUMMARY_GEOL_LAYER_NUM.  Added by MJF (with subsequent
modifications).

#### V_SYS_GEOL_LAY_ELEVS

This view returns the current elevations found in D_GEOLOGY_LAYER as well as
newly calculated elevations based upon the *_OUOM fields (based upon the
specified units) and the current ASSIGNED_ELEV.  This can be used as a check
against the current geologic layer elevations and the BH_GND_ELEV (from
D_BOREHOLE).

#### V_SYS_GEOL_LAY_TOP_BOT_M

This view returns calculated depths for all geologic records in
D_GEOLOGY_LAYER (referenced by GEOL_ID) for locations with valid coordinates
(i.e. not having a QA_COORD_CONFIDENCE_CODE of '117').  In addition, a number
of checks are made:

* ASSIGNED_ELEV cannot be null
* GEOL_TOP_ELEV and GEOL_BOT_ELEV cannot be null and must not exceed the
  ASSIGNED_ELEV value
* All calculated depths must be greater than zero
* GEOL_TOP_ELEV must have a larger value than GEOL_BOT_ELEV

#### V_SYS_GEOL_LAY_UNIT_OUOM

This view returns the number of geologic layers for a location (from
V_SYS_SUMMARY_GEOL_LAYER_NUM, below) as well as the number of geologic layers
that have OUOM values (of depth or elevation) that are whole numbers (i.e.
having no fractional value).  The original 'units of measure' area also
returned.  This can be used as a base of comparison to determine whether the
original 'units of measure' (also listed) are correct; the assumption, here,
being that units of 'ft' or 'fasl' (and others) will have whole numbers while
metric units will have fractional/decimal numbers.

#### V_SYS_GEOL_UNIT_CHANNEL

This view extracts all records from R_GEOL_UNIT_CODE whose geologic units are
considered 'channel' related.  Note that these will almost exclusively consist
of 'YPDT ?' units.

#### V_SYS_GEOL_UNIT_DEEP

This view extracts all records from R_GEOL_UNIT_CODE whose geologic units are
considered to be 'deep'.  Note that these will almost exclusively consist of
'YPDT ?' units.

#### V_SYS_GEOL_UNIT_LNT

This view extracts all records from R_GEOL_UNIT_CODE whose geologic units are
considered to be related to the 'Lower Northern Till'.

#### V_SYS_GEOL_UNIT_SHALLOW

This view extracts all records from R_GEOL_UNIT_CODE whose geologic units are
considered to be 'shallow'.  Note that these will almost exclusively consist
of 'YPDT ?' units.

#### V_SYS_GEOM_BOREHOLE

This view extracts all records from D_LOCATION_GEOM where the location's
LOC_TYPE_CODE is '1' (i.e. 'Well or Borehole').  Both the native spatial
geometry and the 'well known binary' (WKB) geometry for the location is
returned.

#### V_SYS_GROUP_LOC_INT_SCREEN

Returns all LOC_IDs and INT_IDs that have been grouped as a well nest (i.e.
having a GROUP_LOC_TYPE_CODE of [6] or [7]).

#### V_SYS_INT_MON_COORDS

This view returns the coordinates and top- and bottom-depths for all valid
screened intervals.  Note that MON_TOP_DEPTH_M and MON_BOT_DEPTH_M cannot be
NULL and the former must be smaller than the latter.  The views
V_SYS_INT_MON_MAX_MIN and V_SYS_GENERAL_INTERVAL are used as sources.

#### V_SYS_INT_MON_COORDS_FLOWING

This view is similar to V_SYS_INT_MON_COORDS; only intervals where MON_FLOWING
(from D_INTERVAL_MONITOR) is true are returned.

#### V_SYS_INT_MON_DEPTHS_M

This view returns the top and bottom elevations of intervals in
D_INTERVAL_MONITOR.  In addition, both MON_TOP_DEPTH_M and MON_BOT_DEPTH_M are
calculated.  Note that BH_GND_ELEV, MON_TOP_ELEV and MON_BOT_ELEV cannot be
NULL.

#### V_SYS_INT_MON_ELEVS

This view returns the elevations currently found in D_INTERVAL_MONITOR as well
as the calculated elevations based upon the *_OUOM fields and the current
ASSIGNED_ELEV.  This can be used to compare the elevation fields and
BH_GND_ELEV (from D_BOREHOLE).

#### V_SYS_INT_MON_MAX_MIN

This view returns the maximum and minimum elevations and depths as well as a
count of the number of records associated with a screened interval in
D_INTERVAL_MONITOR.  This view should be used as a source for these values
instead of accessing the data from the source table directly.

#### V_SYS_INT_REF_ELEV_COUNT

This view returns the number of records associated with a particular interval
from D_INTERVAL_REF_ELEV.  Multiple records can exist in this table (for each
interval) when tracking changes in reference elevation over time.

#### V_SYS_INT_REF_ELEV_CURRENT

This view returns the information for the 'current' interval reference
elevation.  Current is defined as the latest, and still applicable (i.e. it
has no ending date), reference elevation.

#### V_SYS_INT_SOIL_COORDS

This view returns the coordinates as well as the top and bottom elevations and
depths of soil intervals (i.e. samples) from D_INTERVAL_SOIL.  Note that
SOIL_TOP_M and SOIL_BOT_M cannot be null and the latter must be larger value
than the former.

#### V_SYS_INT_TYPE_CODE_SCREEN

This view returns all INT_TYPE_CODE's whose INT_TYPE_ALT_CODE (in
R_INT_TYPE_CODE) matches 'Screen'.  All of these are considered 'screened'
intervals that will (likely) appear in D_INTERVAL_MONITOR.

#### V_SYS_INT_TYPE_CODE_SCREEN_REP

Returns those INT_TYPE_CODEs that are considered to be [reported] (as opposed
to, for example, assumed).

#### V_SYS_INTERVAL_ELEV

This view returns the top- and bottom-elevation of screened intervals in
D_INTERVAL_MONITOR.  Note that MON_TOP_ELEV and MON_BOT_ELEV cannot be NULL.

#### V_SYS_LAB_WATER_TYPE_MHM

Determines Water Types A through D based upon a Piper diagram distribution
(V_SYS_LAB_CB_PERC_FINAL is used as the data source).  In particular: Type A -
corresponds to standard Piper subdivision 5 (Magnesium bicarbonate type); Type
B - corresponds to standard Piper subdivision 6 and 9 (Calcium chloride type
to Mixed type); Type C - corresponds to standard Piper subdivision 7 (Sodium
chloride type); Type D - corresponds to standard Piper subdivision 8 and 9
(Sodium bicarbonate type to Mixed type). 

Refer to [Haile-Meskale, M. (2017) Groundwater Quality Analysis, An
Interpretation of the Analytical Data From York, Peel, Durham and Toronto –
Conservation Authorities Moraines Coalition (YPDT- CAMC) Study Area (December
2017).  Unpublished Technical Report.], Figure 16 in particular.

#### V_SYS_LAB_WATER_TYPE_MHM_AVG

Similar to the classification scheme outlined in V_SYS_LAB_WATER_TYPE_MHM
(refer to that view for further details).  In this case, all samples are used
to determine an average of each anion and cation for the final calculation of
water type (instead of on a sample-by-sample basis).  The numeric values
returned correspond to standard Piper diagram hydrochemical facies and have
the following equivalents: Type A has value [5]; Type B has value [6]; Type C
has value [7]; and Type D has value [8].  The [Mixed Type] (i.e. value [9]) is
not defined with these methods.  Note that a returned value of [0] indicates
an undefined type by the methodology.

Refer to [Haile-Meskale, M. (2017) Groundwater Quality Analysis, An
Interpretation of the Analytical Data From York, Peel, Durham and Toronto –
Conservation Authorities Moraines Coalition (YPDT- CAMC) Study Area (December
2017).  Unpublished Technical Report.], Figure 16 in particular.

#### V_SYS_LOC_COORDS

This view returns the current [x,y] and surface elevation for each location as
defined in D_LOCATION_SPATIAL and D_LOCATION_SPATIAL_HIST.  The ASSIGNED_ELEV
field is a duplicate of the Z field and is being kept for historical purposes
(i.e. this field name is used by other calling views).  Note that a location
is only returned if it has a valid QA_COORD_CODE (i.e. it does not have a 
value of [117]) 

#### V_SYS_LOC_COORDS_ALL

As V_SYS_LOC_COORDS but with no QA_COORD_CODE check.

#### V_SYS_LOC_DATA_SOURCE

This view returns, for each location in D_LOCATION: location names; location
study; data source information (based on DATA_ID); and, if the location was an
MOE well, each of the MOE ATAG, MOETAG and BORE_HOLE_ID.  In addition,
W_GENERAL is used as a source for MOE_PDF_LINK.

#### V_SYS_LOC_GEOMETRY

This view returns the calculated spatial geometry for each valid location
(i.e. not having a QA_COORD_CONFIDENCE_CODE of '117') in D_LOCATION.  This is
accomplished through the built-in function 'STGeomFromText'; the EPSG
projection code used is '26917'.

#### V_SYS_LOC_GEOMETRY_WKB

This view returns the calculated 'well known binary' (WKB) spatial geometry
(return as a varbinary type) for all locations in D_LOCATION_GEOM.  This is
accomplished through the built-in function 'STAsBinary'.

#### V_SYS_LOC_MODEL_\<model\>

Each of these views returns the locations (as LOC_ID) whose spatial geometry
(from D_LOCATION_GEOM) intersects the spatial geometry of the specified model
polygon (from D_AREA_GEOM).  The models and area objects include:

* CM2004 - AREA_ID '19' (YPDT-CAMC CORE Model 2004)
* DM2007 - AREA_ID '22' (YPDT-CAMC DURHAM Model 2007)
* ECM2006 - AREA_ID '28' (YPDT-CAMC EXTENDED CORE Model 2006)
* EM2010 - AREA_ID '24' (YPDT-CAMC EAST Model 2010)
* RM2004 - AREA_ID '26' (YPDT-CAMC REGIONAL Model 2004)
* WB2018 - AREA_ID '65' (ORMGP Model 2018)
* WB2021 - AREA_ID  '73' (ORMGP Model 2021)
* YT32011 - AREA_ID '63' (York Tier 3 Model 2011)

These views use the built-in function 'STIntersects'.

#### V_SYS_LOC_MODEL_\<model\>BUF

Each of these views returns the location (as LOC_ID) whose spatial geometry
(from D_LOCATION_GEOM) intersects the spatial geometry of the specified model
(with buffer) polygon (from D_AREA_GEOM).  The models and area objects
include:

* CM2004 - AREA_ID '20' (YPDT-CAMC CORE Model 2004 5km Buffer)
* DM2007 - AREA_ID '23' (YPDT-CAMC DURHAM Model 2007 5km Buffer)
* ECM2006 - AREA_ID '29' (YPDT-CAMC EXTENDED CORE Model 2006 5km Buffer)
* EM2010 - AREA_ID '25' (YPDT-CAMC EAST Model 2010 5km Buffer)
* RM2004 - AREA_ID '27' (YPDT-CAMC REGIONAL Model 2004 5km Buffer)

These views use the built-in function 'STIntersects'.

#### V_SYS_LOC_PURPOSE

This returns the single most important primary and secondary purposes ascribed
to a particular location.  If the PRIMACY tag is used in D_LOCATION_PURPOSE,
it is returned.  Otherwise the single row of purposes is returned.

#### V_SYS_LOC_UPD_CHANGES

Returns a list of LOC_IDs that have had some change implemented in any of the
main data tables (e.g. D_BOREHOLE_CONSTRUCTION, D_GEOLOGY_LAYER, etc...).
These changes must have occurred after the system constant DEF_CHANGE_DATE.
The location must have existed before this date (i.e. it is not a [new]
location).

#### V_SYS_LOC_UPD_CHANGES_XY

This view, using V_SYS_LOC_UPD_CHANGES as a source, returns the coordinates  
(and geometry) of those locatinos that have had any changes in the various 
checked tables.

#### V_SYS_LOC_UPD_COORDS_XY

This view returns the current coordinates (and geometry) of locations whose 
LOC_COORD_DATE is newer than the DEF_CHANGE_DATE system constant.  Only those 
locations with a null LOC_COORD_DATA_ID are included.

#### V_SYS_LOC_UPD_DIT

Returns a list of LOC_IDs that have had temporal data loaded into the
database after the specified datatime found in DEF_CHANGE_DATE (a system
constant).  These are for locations that are older than the same data (i.e.
they are not [new] locations).  The number of new records are indicated.

#### V_SYS_LOC_UPD_DIT_XY

This view, using V_SYS_LOC_UPD_DIT as a source, returns the coordinates (and 
geometry) of those locations that have updated temporal data.

#### V_SYS_LOC_UPD_NEW

This view returns a list of LOC_IDs that are newer (with regard to SYS_TIME_STAMP 
in D_LOCATION) than the datetime specified in the DEF_CHANGE_DATE system
constant.

#### V_SYS_LOC_UPD_NEW_XY

This view, using V_SYS_LOC_UPD_NEW as a source, returns the coordinates (and 
geometry) of these [new] locations.

#### V_SYS_MARK_ACTIVE_BAROLOG

For locations with a barologger interval (those with an INT_TYPE_CODE value of
[122]), this view examines its associated temporal data (summarized in
D_INTERVAL_SUMMARY) to determine whehter it has been updated within a
specified time period, marking it active or inactive.  The default time period
is stored in S_CONSTANT as DEF_ACTIVE_BAROLOG.  Note that, as of 20220727,
this returned value should only be applied against the W_GENERAL_OTHER table
(and STATUS field) as this occurs at the interval level as opposed to the
location level.

#### V_SYS_MARK_ACTIVE_CLIMATE

For Climate Station locations, this view examines its associated temporal data
(summarized in D_INTERVAL_SUMMARY) to determine whether it has been updated
within a specified time period, marking it active or inactive (through
LOC_STATUS_CODE) .  The default time period is stored in S_CONSTANT as
DEF_ACTIVE_CLIMATE.

#### V_SYS_MARK_ACTIVE_MONWELL

For Monitoring Well locations, this view examines its associated temporal data
(as summarized in D_INTERVAL_SUMMARY) to determine whether it has been updated
within a specified time period, marking it active or inactive.  The default
time period is stored in S_CONSTANT as DEF_ACTIVE_MONITOR_WELL.  Only those
loctions that have the number of water levels greater than DEF_WL_COUNT will
be processed.

#### V_SYS_MARK_ACTIVE_PGMN

For PGMN locations, this view examines its associated temporal data
(summarized in D_INTERVAL_SUMMARY) to determine whether it has been updated
within a specified time period, marking it active or inactive (through
LOC_STATUS_CODE) .  The default time period is stored in S_CONSTANT as
DEF_ACTIVE_PGMN_WELL.  Only those locations that have the number of water
levels greater than DEF_WL_COUNT will be processed. 

#### V_SYS_MARK_ACTIVE_PTTW

For Permit-To-Take_Water locations, this view examines the PTTW_EXPIRYDATE in
D_PTTW.  If this date is previous to the current date, the permit is considered
to have expired (and its LOC_STATUS_CODE updated).

#### V_SYS_MARK_ACTIVE_SW_GAUGE

For Surface Water Gauge locations, this view examines its associated temporal
data (as summarized in D_INTERVAL_SUMMARY) to determine whether it has been
updated within a specified time period, marking it active or inactive (through
the LOC_STATUS_CODE).  The default time period is stored in S_CONSTANT as 
DEF_ACTIVE_SFWATER.

#### V_SYS_MARK_ACTIVE_SW_SPOTFLOW

For Surface Water Spotflow locations, this view examines its associated temporal
data (as summarized in D_INTERVAL_SUMMARY) to determine whether it has been
updated within a specified time period, marking it active or inactive (through
LOC_STATUS_CODE).  The default time period is stored in S_CONSTANT as 
DEF_ACTIVE_SW_SPOTFLOW.

#### V_SYS_MOE_BORE_HOLE_ID

This view returns all locations from D_LOCATION_ALIAS where
LOC_ALIAS_TYPE_CODE is '3' (i.e. 'MOE bore_hold_id field').  Note that
LOC_NAME_ALIAS must convert to a numeric (integer) form.  If it cannot convert
correctly, a '-9999' value is returned instead.

#### V_SYS_MOE_DATA_ID

This view returns all DATA_ID's (and associated information) that are manually
specified as MOE WWDB imports.

#### V_SYS_MOE_DATA_ID_COUNT

This view returns the calculated number of records from D_LOCATION associated
with the MOE import DATA_ID's from V_SYS_MOE_DATA_ID.

#### V_SYS_MOE_LOCATIONS

This view returns the UNION of V_SYS_MOE_WELL_ID and V_SYS_MOE_WELL_ID_DLA
where the MOE_WELL_ID code is not '-9999'.  In addition, the MOD_PDF_LINK is
calculated.  The view V_SYS_MOE_BORE_HOLE_ID is used as the source for
MOE_BORE_HOLE_ID.

#### V_SYS_MOE_WELL

This view returns all locations from D_LOCATION that have a DATA_ID associated
with an MOE WWDB import using V_SYS_MOE_DATA_ID.  Only those locations with a
LOC_TYPE_CODE of '1' (i.e. 'Well or Borehole') are included.

#### V_SYS_MOE_WELL_ID

Using V_SYS_MOE_WELL as a source, the LOC_ORIGINAL_NAME from D_LOCATION is
used to calculate the MOE_WELL_ID field.  This value must be convertible to a
numeric (integer), a '-9999' value is returned otherwise.

#### V_SYS_MOE_WELL_ID_DLA

This view returns all locations from D_LOCATION_ALIAS where
LOC_ALIAS_TYPE_CODE is '4' (i.e. 'MOE well_id field').  Note that
LOC_NAME_ALIAS must be converted to a numeric (integer) form.  If it cannot
convert correctly, a '-9999' value is returned instead.

#### V_SYS_NAME

This view returns all names for a given location and interval as found in
D_LOCATION, D_LOCATION_ALIAS, D_INTERVAL and D_INTERVAL_ALIAS - each is found
on a separate row tagged with a LOC_ID.  The INT_ID is included if the name is
sourced from an interval table.  All names will be non-NULL.  Note that only
LOC_ALIAS_TYPE_CODE's '1' (i.e. 'MOE Tag Number', '2' (i.e. 'MOE Audit
Number') or NULL will be extracted from D_LOCATION_ALIAS.  This returns the
minimum number of rows (some INT_IDs may be missed in this first-pass view).

#### V_SYS_NAME_ALL

This view is similar to V_SYS_NAME, above.  In this case, a maximum number of
rows are returned - all relations will be specified; in some cases there will
be duplicates.  V_SYS_NAME is used as a base for this view.

#### V_SYS_NAME_INTERVAL

This view returns all names tied to intervals (i.e. INT_IDs).

#### V_SYS_NAME_LOCATION

This view returns all names tied to locations (i.e. LOC_IDs).

#### V_SYS_NAME_STUDY_AREA

This view uses V_SYS_NAME as a base and includes LOC_STUDY and LOC_AREA from
D_LOCATION.  This returns the minimum number of rows (see V_SYS_NAME, above).

#### V_SYS_NAME_STUDY_AREA_ALL

This view uses V_SYS_NAME_STUDY_AREA as a base.  This returns a maximum number
of rows (see V_SYS_NAME_ALL, above).

#### V_SYS_ORMGP_MON_INTERVAL

This view returns those intervals (and associated information) that are
directly related or monitored by the ORMGP.  In particular, an interval group
(i.e. GROUP_INT_CODE '22', 'YPDT-CAMC Groundwater Monitoring') is used to
access these INT_ID's.  Note that these are the 'old' intervals; refer to
V_SYS_GW_MON_INTERVAL_NEW, below.

#### V_SYS_ORMGP_MON_INTERVAL_NEW

This view is similar to V_SYS_ORMGP_MON_INTERVAL but uses, instead, the
GROUP_INT_CODE '18504083' (i.e. 'YPDT-CAMC Groundwater Monitoring - Update').

#### V_SYS_ORMGP_MON_LOCATION

This view returns those locations (and associated information) that are
directly related or monitored by the ORMGP program.  Refer to
V_SYS_GW_MON_INTERVAL (above) for details.

#### V_SYS_ORMGP_MON_LOCATION_NEW

#### V_SYS_PICK_\*

These series of views extract records from V_GEN_PICK based upon the text
description of each geologic unit.

#### V_SYS_PICK_\*_ALL

Extracts records from V_GEN_PICK and D_PICK_EXTERNAL which match a
specified GEOL_UNIT_CODE (e.g. [Bedrock - Undifferentiated (YPDT)] would have
a GEOL_UNIT_CODE of [7]).  Locations from V_GEN_PICK are limited to the extents
available through V_SYS_AGENCY_ORMGP_LARGE.  For D_PICK_EXTERNAL records, null
Z values are ignored and all records must have a valid status code (generally
less than a value of [100]).  Note that very limited information is returned
by this view - its general use is as a source when interpolating geologic
layers.

#### V_SYS_PICK_PUSHDOWN

For non-bedrock wells, returns the bottom elevation of the materials (from
D_GEOLOGY_LAYER) as well as the bottom of the borehole (from D_BOREHOLE) for
those locations within the ORMGP study area that do not intersect bedrock.  
This is meant to be used as a check against any generated bedrock surfaces. 

#### V_SYS_PICK_PUSHDOWN_ALL

This view returns non-bedrock borehole (using BH_BEDROCK_ELEV in D_BOREHOLE)
locations that have a non-null BH_BOTTOM_ELEV.  These are considered 'picks'
for interpolation with regard to checking against interpolated bedrock 
surfaces. In addition, bedrock elevations are included.

#### V_SYS_PTTW_EXPIRY_DATE_MAX

This view returns the maximum (i.e. latest) expiry date for a permit or
related permit using V_SYS_PTTW_RELATED_ALL.

#### V_SYS_PTTW_FIND_\*

These series of views are used when importing 'new' PTTW locations into the
master database.  They are not for the general user.

#### V_SYS_PTTW_FIND_PRESENT

This view returns all LOC_IDs indicating a PTTW location as well as any
related PTTW locations.

#### V_SYS_PTTW_FIND_RELATED_ALL

This view returns all permutations of PTTW_PERMIT_NUMBER (with LOC_ID) along
with their PTTW_EXPIRED_BY and PTTW_AMENDED_BY permit numbers.

#### V_SYS_PTTW_FIND_RELATED_NEW

Using V_SYS_PTTW_FIND_PRESENT and V_SYS_PTTW_FIND_RELATED_ALL as a base, this
view returns all 'new' related permits LOC_IDs.

#### V_SYS_PTTW_RELATED_ALL

This view returns the list of all locations (from D_PTTW) related to their
primary location from V_SYS_PTTW_RELATED_PRIMARY (below).  Note that the
primary location is listed, here, as being related to itself (i.e. the same
LOC_ID and PERMIT_NUMBER will appear, also, as LOC_ID_RELATED and
PERMIT_NUMBER_RELATED).

#### V_SYS_PTTW_RELATED_PRIMARY

This view returns a distinct list of locations (by LOC_ID) and their
associated PTTW_PERMIT_NUMBER from D_PTTW_RELATED.

#### V_SYS_PTTW_SOURCE

This view returns the source location (by LOC_ID, renamed SOURCE_LOC_ID)
linked to a 'permit to take water' (PTTW) location (i.e. the LOC_TYPE_CODE is
'22').  A record is returned if the LOC_ID does not have the same
LOC_MASTER_LOC_ID value (i.e. the latter is the source).

#### V_SYS_PTTW_SOURCE_VOLUME

This view combines the results of V_SYS_PTTW_SOURCE (above) and
V_SYS_PTTW_VOLUME (below).

#### V_SYS_PTTW_VOLUME

This view returns the calculated yearly volume (based upon the PTTW_MAX_L_DAY
and PTTW_MAX_DAYS_YEAR) between the years specified by PTTW_ISSUEDDATE and
PTTW_PERMIT_END.  Note that the former must be an earlier date than the
latter.

#### V_SYS_PUMP_LATEST

This returns the latest pump test information for each interval (using
PUMPTEST_DATE from D_PUMPTEST).

#### V_SYS_PUMP_MOE_DRAWDOWN

This view returns the minimum elevation and calculated depth of drawdown from
D_INTERVAL_TEMPORAL_2 where RD_NAME_CODE is '70899' (i.e. 'Water Level -
Manual - Other') and RD_TYPE_CODE is '65' (i.e. 'WL - MOE Well Record -
Pumping') or '64' (i.e. 'WL - MOE Well Record - Recovery').  The information
is linked to any records in D_PUMPTEST (based on INT_ID, RD_DATE and
PUMPTEST_DATE).  The ASSIGNED_ELEV is used to calculate the depths.

#### V_SYS_PUMP_MOE_TRANS

This is the third view (the calling veiw) of a three-view process used to
calculate Transmissivity and Hydraulic Conductivity using the process outlined
by Bradbury and Rothschild (1985).  Equations from this paper has been broken
down into component parts for ease of calculation.  The view
V_SYS_PUMP_MOE_TRANS_SOURCE2 is used as a source of information.  The final
equations are assembled and calculated here - the only checks, here,  are to
avoid divide-by-zero issues.  Calculated values are used to update
D_INTERVAL_FORM_ASSIGN.  Note that this is an iterative process and this view
must be called multiple times before reasonable values are returned.

#### V_SYS_PUMP_MOE_TRANS_BR1985

This is the third view (the calling view) of a three-view process used to
calculate Transmissivity and Hydraulic Conductivity using the process outlined
by Bradbury and Rothschild (1985).  Refer to V_SYS_PUMP_MOE_TRANS (the full
version) for additional details.  This particular view uses values from
S_CONSTANT to duplicate the values and check the calculations from the
original paper.  It was determined that the higher precision afforded by
modern systems delivers the same order-of-magnitude results.  Implementing the
methodology in older software (early 1990s) reproduces the published results.

#### V_SYS_PUMP_MOE_TRANS_CMP

Returns the calculated hydraulic conductivity and transmissivity records by
INT_ID as well as the processed MOE pump test data records and the various
hydraulic conductivity records in D_INTERVAL_TEMPORAL_2.  These can be used
for comparison purposes.

#### V_SYS_PUMP_MOE_TRANS_SCR

Similar to V_SYS_PUMP_MOE_TRANS but using the length of the screen as the
aquifer thickness.

#### V_SYS_PUMP_MOE_TRANS_SOURCE

This is the first view of a three-view process used to calculate
Transmissivity and Hydraulic Conductivity using the process outlined by
Bradbury and Rothschild (1985).  Equations from this paper has been broken
down into component parts for ease of calculation.  Additional views
V_SYS_PUMP_MOE_TEST and V_SYS_DIFA_GL are used as information sources; various
constants are sourced from S_CONSTANT.  Checks are made, here, to avoid
calculation errors, including: a non-zero/-null drawdown; a non-nuill pump
rate; a non-null well radius; a non-zero thickness; a non-zero pumping
interval.

#### V_SYS_PUMP_MOE_TRANS_SOURCE_BR1985

This is the first view of a three-view process used to calculate
Transmissivity and Hydraulic Conductivity using the process outlined by
Bradbury and Rothschild (1985).  Refer to V_SYS_PUMP_MOE_TRANS_SOURCE (the
full version) for additional details.  This particular view uses values from
S_CONSTANT to duplicate the values and check the calculations from the
original paper.  It was determined that the higher precision afforded by
modern systems delivers the same order-of-magnitude results.  Implementing the
methodology in older software (early 1990s) reproduces the published results.

#### V_SYS_PUMP_MOE_TRANS_SOURCE_SCR

Similar to V_SYS_PUMP_MOE_TRANS_SOURCE but using the length of the screen as
the aquifer thickness.

#### V_SYS_PUMP_MOE_TRANS_SOURCE2

This is the second view of a three-view process used to calculate
Transmissivity and Hydraulic Conductivity using the process outlined by
Bradbury and Rothschild (1985).  Equations from this paper has been broken
down into component parts for ease of calculation.  The view
V_SYS_PUMP_MOE_TRANS_SOURCE is used as a source of information as well as
D_INTERVAL_FORM_ASSIGN; various constants are sourced from S_CONSTANT.  Checks
are made, here, to avoid calculation errors as well as determining the point
at which the calculation will start and finsh (below a specified error).  For
example: a null T_ITER (number of iterations) or T_ERR (calculated error)
indicates that calculations can commence; a T_ERR less than a default error
allwos calculations to finish; a T_ITER below a maximum iteration allows the
calculation to continue.

#### V_SYS_PUMP_MOE_TRANS_SOURCE2_BR1985

This is the second view of a three-view process used to calculate
Transmissivity and Hydraulic Conductivity using the process outlined by
Bradbury and Rothschild (1985).  Refer to V_SYS_PUMP_MOE_TRANS_SOURCE2 (the
full version) for additional details.  This particular view uses values from
S_CONSTANT to duplicate the values and check the calculations from the
original paper.  It was determined that the higher precision afforded by
modern systems delivers the same order-of-magnitude results.  Implementing the
methodology in older software (early 1990s) reproduces the published results.

#### V_SYS_PUMP_MOE_TRANS_SOURCE2_SCR

Similar to V_SYS_PUMP_MOE_TRANS_SOURCE2 but using the length of the screen as
the aquifer thickness.

#### V_SYS_PUMP_OFF_WATERLEVEL

This view returns the pump off water levels by interval where RD_TYPE_CODE is
'67' (i.e. 'WL - Pump Off').

#### V_SYS_PUMP_ON_WATERLEVEL

This view returns the pump on water levels by interval where RD_TYPE_CODE is
'66' (i.e. 'WL - Pump On').

#### V_SYS_PUMP_VOLUME_MONTHLY

This view calculates the monthly pumping volume minimum, maximum, average, sum
and number of records by interval from D_INTERVAL_TEMPORAL_2 where
RD_NAME_CODE is '447' (i.e. 'Production - Pumped Volume (Daily Total)') and
UNIT_CODE is '74' (i.e. 'm3/d').

#### V_SYS_PUMP_VOLUME_YEARLY

This view is similar to V_SYS_PUMP_VOLUME_MONTHLY (above).  The field
AVG_VOLUME_M3_D_YEAR is the AVG_VOLUME_M3_D divided by '365'.

#### V_SYS_RANDOM_ID_\<numeric\>

Each of these views returns a series of numeric, non-repeating numbers within
the specified range of values assigned to various ORMGP personnel (make sure
to specify 'TOP \<number\>' as part of your query code; examine the source to
check on the maximum number of records that can be returned).  The following
figure specifies the ranges.

#### V_SYS_RANDOM_ID_BULK_\<numeric\>

These views are similar to V_SYS_RANDOM_ID_\<numeric\> (above); they are used
when a large number of records are to be input into the database. 

#### V_SYS_RANDOM_ID_\<partner agency\>

These views are similar to V_SYS_RANDOM_ID_\<numeric\> (above); they are used
to assign ranges based upon a particular partner agency.

#### V_SYS_S_USER_ID_RANGES

This view returns the user specified numeric ranges (see V_SYS_RANDOM_ID_\*,
above) as assigned within SiteFX.  These values are stored in S_USER where
'Name' matches 'uniqueIDranges'.

#### V_SYS_SFLOW_YEARLY

This view returns yearly stream flow minimum, maximum, average and number of
records by interval from D_INTERVAL_TEMPORAL_2 where RD_NAME_CODE is '1001'
(i.e. 'Stream Flow - Daily Discharge (Average)') or '70870' (i.e. 'Stream Flow
(Spot Flow)').

#### V_SYS_SPEC_CAP_CALC

This view calculates the specific capacity for intervals from
D_INTERVAL_TEMPORAL_2 where: 

* Water levels are calculated from manual readings where RD_NAME_CODE is '628'
  (i.e. 'Water Level - Manual - Static') and RD_TYPE_CODE is '0' (i.e. 'WL -
  MOE Well Record - Static')t
* Pumping water levels area available where RD_NAME_CODE is '70899' (i.e.
  'Water Level - Manual - Other') and RD_TYPE_CODE is '65' (i.e. 'WL - MOE
  Well Record - Pumping')t
* Pumping test data is available in D_PUMPTEST and D_PUMPTEST_STEP; all
  pumping rates are converted to 'litres per minute' (i.e. 'lpm').t

Note that the static water level must be shallower than the pumping water
level; a NULL is returned otherwise.

#### V_SYS_STAT_SUM_LAB_PAR

Calculates various statistics of a particular parameter from records in
D_INTERVAL_TEMPORAL_1B (the particular parameter is specified using the system
constant DEF_PARAM_RNC).  This includes:

* Minimum value (PAR_MIN)
* Maximum value (PAR_MAX)
* Average (mean) value (PAR_MEAN)
* Range of values (PAR_RANGE)
* Median value (PAR_MED)
* Mode value (PAR_MODE_MIN and PAR_MODE_MAX)
* The number of records with the particular mode value (PAR_MODE_NUM)
* The total number of records with the highest occurrences of the mode value
  (PAR_NUM)
* The standard deviation (PAR_STDEV)
* The variance (PAR_VAR)

Refer to V_SYS_STAT_WLS_LOGGER for additional details.

#### V_SYS_STAT_SUM_LAB_PAR_LOG

Calculates various statistics of a particular parameter from records in
D_INTERVAL_TEMPORAL_1B.  Refer to V_SYS_STAT_SUM_LAB_PAR for details.  In this
case, the log (base 10) of the RD_VALUE is used instead.

#### V_SYS_STAT_SUM_LAB_PAR_MED

Calculates the median value of parameter records from D_INTERVAL_TEMPORAL_1B
(as specified by the system constant DEF_PARAM_RNC). Note that this view uses
the SQLServer command [percentile_cont] that is not available in earlier
versions of the software.

#### V_SYS_STAT_SUM_LAB_PAR_MODE

Calculates the mode of parameter records from D_INTERVAL_TEMPORAL_1B (as
specified by the system constant DEF_PARAM_RNC).  Note that for a particular
parameter, multiple modes may be calculated (i.e. they have the same number of
records).  See also V_SYS_STAT_SUM_LAB_PAR_MODEC and
V_SYS_STAT_SUM_LAB_PAR_MODE_RANGE.

#### V_SYS_STAT_SUM_LAB_PAR_MODE_RANGE

Calculates the mode range (i.e. the minimum and maximum mode as well as the
count of records for each) of parameter records from D_INTERVAL_TEMPORAL_1B
(as specified by the system constant DEF_PARAM_RNC).  This allows a single row
to be returned for each interval.  See also V_SYS_STAT_SUM_LAB_PAR_MODE and
V_SYS_STAT_SUM_LAB_PAR_MODEC.

#### V_SYS_STAT_SUM_LAB_PAR_MODEC

Calculates the count of parameter records from D_INTERVAL_TEMPORAL_1B (as
specified by the system constant DEF_PARAM_RNC) that have the same value (the
values are compared to ten-decimal places).  See also
V_SYS_STAT_SUM_LAB_PAR_MODE and V_SYS_STAT_SUM_LAB_PAR_MODE_RANGE.

#### V_SYS_STAT_WLS_LOGGER/_MANUAL

This view assembles various statistical measures of the water level logger and
manual record distributions (by INT_ID).  This includes

* Minimum value (WLS_MIN)
* Maximum value (WLS_MAX)
* Average (mean) value (WLS_MEAN)
* The range of values (WLS_RANGE)
* Median value (WLS_MED); note that this value is being determined using the
  SQL Server function 'percentile_cont' which is only available in versions
  after (and including) v2016
* Mode value; note that a minimum (WLS_MODE_MIN) and maximum (WLS_MODE_MAX) is
  determined - if these values differ, it indicates that more than a single
  value has the highest number of occurrences for a particular INT_ID
* The number of records with the particular mode value (WLS_MODE_NUM)
* The total number of records with the highest occurrences of the mode values
  (MODE_NUM)
* The standard deviation (WLS_STDEV)
* The variance (WLS_VAR) 
* The start (WLS_START_DATE) and end (WLS_END_DATE) dates for the records

In general, the data can be described as right-skewed (i.e. positive skewed) if 

    WLS_MODE < WLS_MED < WLS_MEAN

and left-skewed  (i.e. negative skewed) if

    WLS_MEAN < WLS_MED < WLS_MOD.

#### V_SYS_STAT_WLS_LOGGER_MED/_MANUAL_MED

Calculate the median water level value for logger and manual records.

#### V_SYS_STAT_WLS_LOGGER_MODE/_MANUAL_MODE

Calculate the water level mode value (i.e. the most common occurrence of a
particular values within the dataset) for the logger and manual records.  Note
that the minimum and maximum value is calculated in the case that more than
one particular value as the largest number of records.

#### V_SYS_STAT_WLS_LOGGER_MODEC/_MANUAL_MODEC

Rounds the values of the water level records (for manual and logger data) to
five significant digits to allow calculation of the mode value(s).

#### V_SYS_STAT_WLS_LOGGER_MODE_RANGE/_MANUAL_MODE_RANGE

Returns the highest and lowest mode values calculated when more than a single
mode value is present for a particular logger and manual water level dataset.

#### V_SYS_STATCOUNT_BOREHOLE

This view calculates the number of boreholes present in the database.  This
uses D_BOREHOLE and LOC_TYPE_CODE of '1' (i.e. 'Well or Borehole').

#### V_SYS_STATCOUNT_BOREHOLE_MOE

This view is similar to V_SYS_STATCOUNT_BOREHOLE.  In addition, the borehole
must be originally from the MOE WWDB (this is determined by V_SYS_MOE_WELL).

#### V_SYS_STATCOUNT_CHEM_ANALYSIS_PARA

This view calculates the number of readings present in D_INTERVAL_TEMPORAL_1B.
This should be equivalent to the number of rows.

#### V_SYS_STATCOUNT_CLIMATE_MEASURE

This view calculates the number of climate readings present in
D_INTERVAL_TEMPORAL_3.  This should be equivalent to the number of rows.

#### V_SYS_STATCOUNT_CLIMATE_STN

This view determines the number of climate stations in the database.  These
are LOC_TYPE_CODE's of '9' (i.e. 'Climate Station').

#### V_SYS_STATCOUNT_DOCUMENT

This view determines the number of documents in the database.  This is
calculated by the number of records in D_DOCUMENT. 

#### V_SYS_STATCOUNT_GEOLOGY_LAYER

This view determines the number of geology layers in the database.  This is
calculated by the number of records in D_GEOLOGY_LAYER.

#### V_SYS_STATCOUNT_OUTCROP

This view determines the number of outcrops present in D_BOREHOLE.  These are
LOC_TYPE_CODE's of '11' (i.e. 'Outcrop').

#### V_SYS_STATCOUNT_PUMP_RATE_MUNIC

This view determines the number of pumping municipal records in
D_INTERVAL_TEMPORAL_2 where RD_NAME_CODE is '447' (i.e. 'Production - Pumped
Volume (Total Daily)' and LOC_STATUS_CODE is '11' (i.e. 'Active Municipal
Pumping Well').

#### V_SYS_STATCOUNT_SFC_WATER_MEASURE

This view determines the number of surface water readings in
D_INTERVAL_TEMPORAL_2 where LOC_TYPE_CODE is '6' (i.e. 'Surface Water').

#### V_SYS_STATCOUNT_SFC_WATER_STN

This view determines the number of surface water stations in the database.
These are LOC_TYPE_CODE's of '6' (i.e. 'Surface Water').

#### V_SYS_STATCOUNT_WATER_LEVEL

This view determines the number of water levels in D_INTERVAL_TEMPORAL_2.
These correspond to any with a READING_GROUP_CODE of '23' (i.e. 'Water
Level').

#### V_SYS_STATUS_INT_TYPE_CODE

This view extracts the number of interval types present in the database over
time.  D_VERSION_STATUS is used as the source.

#### V_SYS_STATUS_LOC_TYPE_CODE

This view extracts the number of location types present in the database over
time.  D_VERSION_STATUS is used as the source.

#### V_SYS_STATUS_READING_GROUP_CODE

This view extracts the number of values associated with particular reading
groups (from R_READING_GROUP_CODE) in the database over time.
D_VERSION_STATUS is used as the source.  Note that 'DIT1' or 'DIT2' is
appended to indicate the original temporal source table.

#### V_SYS_SUM_INT_TYPE_COUNTS

This view, using D_VERSION_CURRENT and V_SUM_INT_TYPE_COUNTS as sources,
formats interval type count data into a format for insertion into
D_VERSION_STATUS.  Note that CURRENT_VERSION corresponds to the current
'yyymmdd' format.

#### V_SYS_SUM_LAB_PARAM_CPERC_BIN

For a particular parameter in D_INTERVAL_TEMPORAL_1B (as specified through
the system constant DEF_PARAM_RNC) this view groups values into particular
ranges (as specified through the system constant DEF_BIN_SIZE; returned as B)
and calculates the counts per group (RCOUNT), its percentage (PERC) and
cumulative percentage (CPERC) as well as the total number of records
(TCOUNT).

#### V_SYS_SUM_LAB_PARAM_CPERC_BIN_LOG

Similar to V_SYS_SUM_LAB_PARAM_CPERC_BIN (refer to this for additiional
details) but using the log (base 10) of the pertinent RD_VALUEs from
D_INTERVAL_TEMPORAL_1B.

#### V_SYS_SUM_LOC_TYPE_COUNTS

This view, using D_VERSION_CURRENT and V_SUM_LOC_TYPE_COUNTS as sources,
formats location type count data into a format for insertion into
D_VERSION_STATUS.  Note that CURRENT_VERSION corresponds to the current
'yyyymmdd' format.

#### V_SYS_SUM_READING_GROUP_COUNTS

This view, using D_VERSION_CURRENT and V_SUM_READING_GROUP_COUNTS as sources,
formats reading group count data into a format for insertion into
D_VERSION_STATUS.  Note that CURRENT_VERSION corresponds to the current
'yyyymmdd' format.

#### V_SYS_SUMMARY_DDS_CHEMISTRY

Returns all DATA_ID values and associated information for incorporation of
chemistry records from major datasets (where the number of records exceed the
DEF_SUM_DDS_CHEM system constant).  Note that DDS refers to the D_DATA_SOURCE
table.

#### V_SYS_SUMMARY_DDS_CLIMATE

Returns all DATA_ID values and associated information for incorporation of
climate records from major datasets.  Note that DDS refers to the
D_DATA_SOURCE table.

#### V_SYS_SUMMARY_DDS_FIELD

Returns all DATA_ID values and associated information for incorporation of
field records from major datasets (where the number of records exceed the
DEF_SUM_DDS_FIELD system constant).  Note that DDS refers to the D_DATA_SOURCE
table.

#### V_SYS_SUMMARY_DDS_LOCATIONS

Returns all DATA_ID values and associated information for incorporation of
locations from major datasets (where the number of locations exceeds the
DEF_SUM_DDS_LOCNS system constant).  Note that DDS refers to the D_DATA_SOURCE
table.

#### V_SYS_SUMMARY_DDS_PICKS

Returns all DATA_ID values and associated information for incorporation of
geologic pick records from major datasets.  Note that DDS refers to the
D_DATA_SOURCE table.

#### V_SYS_SUMMARY_DDS_SW

Returns all DATA_ID values and associated information for incorporation of
surface water records from major datasets.  Note that DDS refers to the
D_DATA_SOURCE table.

#### V_SYS_SUMMARY_DEEPEST_SCREEN_TOP

This view returns the top elevation of the deepest screened interval (from
D_INTERVAL_MONITOR) and its associated assigned geologic unit code (from
V_SYS_DIFA_ASSIGNED_FINAL).

#### V_SYS_SUMMARY_GEOL_LAYER_NUM

This view returns the number of geologic layers associated with a particular
location from D_GEOLOGY_LAYER.

#### V_SYS_SUMMARY_MON_FLOWING

This view returns the locations that are tagged as flowing in
D_INTERVAL_MONITOR (i.e. MON_FLOWING is true).

#### V_SYS_SUMMARY_MON_NUM

This view returns the number of intervals associated with a location in
D_INTERVAL.

#### V_SYS_SUMMARY_PRECIP

This view returns the minimum and maximum dates as well as the number of
precipitation records by interval in D_INTERVAL_TEMPORAL_3.  The RD_NAME_CODE
used is '551' (i.e. 'Precipitation (Daily Total)').

#### V_SYS_SUMMARY_PUMP

This view returns the minimum and maximum dates as well as the number of
pumping records by interval in D_INTERVAL_TEMPORAL_2.  The RD_TYPE_CODE's must
be '64' (i.e. 'WL - MOE Well Record - Recovery') or '65' (i.e. 'WL - MOE Well
Record - Pumping') or the READING_GROUP_CODE must be '35' (i.e.
'Discharge/Production - From Wells ?').

#### V_SYS_SUMMARY_PUMP_DAILY_VOL

This view returns the minimum and maximum dates as well as the number of
pumping volume records by interval in D_INTERVAL_TEMPORAL_2.  The RD_NAME_CODE
used is '447' (i.e. 'Production - Pumped Volume (Total Daily)').

#### V_SYS_SUMMARY_PUMP_RATE

This view returns the maximum REC_PUMP_RATE_IGPM by location from D_PUMPTEST.
Note that REC_PUMP_RATE_IGPM must be greater than '50'.

#### V_SYS_SUMMARY_SFLOW

This view returns the minimum and maximum dates as well as the number of
streamflow records by interval in D_INTERVAL_TEMPORAL_2.  In addition,
minimum, maximum and average streamflow is calculated.  The RD_NAME_CODE's are
'1001' (i.e. 'Stream Flow - Daily Discharge (Average)') or '70870' (i.e.
'Stream Flow (Spot Flow)').

#### V_SYS_SUMMARY_SOIL

This view calculates the number of soil samples (from D_INTERVAL) and the
number of soil sample readings (from D_INTERVAL_TEMPORAL_1A/1B) for a
particular location.  Note that INT_TYPE_CODE is '29' (i.e. 'Soil or Rock').

#### V_SYS_SUMMARY_SOIL_GEOTECH

This view returns counts of interval geotechnical information for each
location (i.e. where it is available).  Both the temporal tables (1A/1B) and
D_INTERVAL_SOIL are examined.

#### V_SYS_SUMMARY_SPEC_CAP

This view determines the minimum, maximum and number of specific capacity
values by interval from D_INTERVAL_TEMPORAL_2.  The RD_NAME_CODE is '748'
(i.e. 'Specific Capacity').

#### V_SYS_SUMMARY_TEMP_AIR

This view returns the minimum and maximum dates as well as the number of air
temperature readings in D_INTERVAL_TEMPORAL_3.  The RD_NAME_CODE's used
include '369' (i.e. 'Temperature (Air)'), '546' (i.e. 'Temperature (Air) -
Daily Max'), '547' (i.e. 'Temperature (Air) - Daily Min') and '548' (i.e.
'Temperature (Air) - Daily Mean').

#### V_SYS_SUMMARY_TEMP_WATER

Returns the minimum and maximum dates as well as the number of water
temperature readings found in both of D_INTERVAL_TEMPORAL_2 and
D_INTERVAL_TEMPORAL_5 (surface water).  The parameter used in this case is
[Temperature (Water) - Field].

#### V_SYS_SUMMARY_WL

This view returns the minimum and maximum dates as well as the number of water
level readings in D_INTERVAL_TEMPORAL_2.  The READING_GROUP_CODE used is '23'
(i.e. 'Water Level').

#### V_SYS_SUMMARY_WL_ALL

This view returns all water level readings in D_INTERVAL_TEMPORAL_2 where the
READING_GROUP_CODE is '23' (i.e. 'Water Level').

#### V_SYS_SUMMARY_WL_AVG

This view returns the average as well as the number of water level records by
interval in D_INTERVAL_TEMPORAL_2 where the RD_NAME_CODE's are '628' (i.e.
'Water Level - Manual - Static') or '629' (i.e. 'Water Level - Logger
(Compensated & Corrected)').  Note that UNIT_CODE must be '6' (i.e. 'masl')
and the value must not be NULL.  In addition, the REC_STATUS_CODE for a record
must be null or have a value of less than '100'.

#### V_SYS_SUMMARY_WL_LOGGER

This view returns the first and last date and logger water level value as well
as the total number of records by interval from D_INTERVAL_TEMPORAL_2 where
the RD_NAME_CODE is '629' (i.e. 'Water Level - Logger (Compensated &
Corrected)').

#### V_SYS_SUMMARY_WL_MANUAL

This view is similar to V_SYS_SUMMARY_WL_MANUAL with the exception that the
RD_NAME_CODE is '628' (i.e. 'Water Level - Manual - Static').

#### V_SYS_SUMMARY_WQ

This view returns the minimum and maximum dates as well as the number of water
quality readings by interval in D_INTERVAL_TEMPORAL_1B.  Note that those
intervals of INT_TYPE_CODE '29' (i.e. 'Soil or Rock') are excluded.

#### V_SYS_SUMMARY_WQ_SAMPLES

This view returns the number of samples by interval in D_INTERVAL_TEMPORAL_1A.
Note that the interval samples are grouped by sample date (dropping the hour
and minute information, if present) to avoid possible duplication.

#### V_SYS_UGAIS_ALL

This view returns all LOC_ID's and associated INT_ID's identified as a UGAIS
source (i.e. from the Ontario Borehole Database 'Urban Geology Analysis
Information System').  The latter value may be a NULL (if no intervals are
assigned).  The UGAIS field is populated with a '1' value; this can be used as
a check in table joins.  These locations are determined by testing the text
string '%ugais%' against LOC_NAME in D_LOCATION.

#### V_SYS_UGAIS_LOCATION

Returns those LOC_IDs that were an original UGAIS location and the number of
intervals associated with it.  This uses V_SYS_UGAIS_ALL as a base.

#### V_SYS_UGAIS_SCREEN

Similar to V_SYS_GEN_UGAIS_ALL, this view returns all LOC_ID's and INT_ID's
with an identified screen type (using V_SYS_INT_TYPE_CODE_SCREEN).  No INT_ID
values will be NULL.

#### V_SYS_UGAIS_SOIL

Similar to V_SYS_GEN_UGAIS_SCREEN, this view returns all LOC_ID's and INT_ID's
with an INT_TYPE_CODE of '29' (i.e. 'Soil or Rock').

#### V_SYS_S_USER_ID_RANGES

This view returns the user identifier ranges (as specified through SiteFX;
this is based on names assigned to licensed accounts) as found in the S_USER
table tagged with 'uniqueIDranges'.  These range-of-values should conform to
those specified in the various V_SYS_RANDOM_ID_* views, above.

#### V_SYS_VERSION_CURRENT

This view returns the database version from D_VERSION_CURRENT and assigns the
current date to CUT_DATE.  This is used to record the current database version
and date-stamp exported datasets.

#### V_SYS_W_GENERAL

This view is used to populate the W_GENERAL table (generally weekly) and
consisting of those locations present in D_BOREHOLE.  Various substitutions,
in general, are made (for viewing purposes): NULL values are converted to '0';
NULL date fields are converted to NA; the bedrock elevation has a text field
(in addition to the numeric) where a NULL is converted to NA; the flowing
field has a text field (in addition to the numeric) where a 'Y' or 'N' is
added, appropriately.  Note that only those locations present in
V_SYS_AGENCY_YPDT are included here.  Those locations with LOC_TYPE_CODE of
'20' (i.e. 'Archive') are also not present.

A number of data tables and views are accessed to extract information, these
include:

* V_CON_GENERAL
* D_LOCATION_GEOM
* D_LOCATION_SUMMARY
* V_SYS_MOE_WELL_ID
* D_LOCATION_PURPOSE
* D_BOREHOLE
* V_SYS_SUMMARY_MON_FLOWING
* V_SYS_SUMMARY_FLOW_RATE
* D_LOCATION

#### V_SYS_W_GENERAL_DOCUMENT

This view is used to populate the W_GENERAL_DOCUMENT table (generally weekly).
This includes the bibliographic information for each document (using
V_GEN_DOCUMENT_BIBLIOGRAPHY) and their coordinates along with their sptail
geometry (if available).

#### V_SYS_W_GENERAL_GEOL_FEAT

This view assembles the features present in D_GEOLOGY_FEATURE into a coded
string for access, avoiding the addition of multiple columns to the W_GENERAL
table for indication of the presence of any type (where multiple feature types
are recorded) at a particular location.  Each position in the string denotes
the presence a particular feature type (indicated by a value of 1) as follows:

* Position 1: Water Found - Fresh
* Position 2: Water Found - Salty
* Position 3: Water Found - Sulphur
* Position 4: Water Found - Mineral
* Position 5: Water Found - Gas
* Position 6: Water Found - Iron

#### V_SYS_W_GENERAL_GROUP_INT

Returns all those grouped LOC_IDs and INT_IDs (along with their group names)
associated with borehole and surface water sites (i.e. those with a
GROUP_INT_TYPE_CODE of [4]).

#### V_SYS_W_GENERAL_GROUP_LOC

Returns all those grouped LOC_IDs (along with their group names) associated
with well nests (i.e. those with a GROUP_LOC_TYPE_CODE of [6] or [7]).

#### V_SYS_W_GENERAL_GW_LEVEL_LOG

This view is used to populate the W_GENERAL_GW_LEVEL table (generally weekly)
with logger water levels.  Here, the daily water level average and number of
records are extracted from V_GEN_WATER_LEVEL_AVG_DAILY_LOGGER while the date
is converted to 'mm/dd/yyyy' format and the RD_NAME_CODE changed to '645'
(i.e. 'Water Level - Logger - Calc - Daily Average').  Note that only
intervals where the WL_LOGGER_TOTAL_NUM is greater than '25' (or the
WL_LOGGER_TOTAL_NUM plus the WL_MANUAL_TOTAL_NUM is greater than '25') are
included.  The latter two fields are found in D_INTERVAL_SUMMARY.

#### V_SYS_W_GENERAL_GW_LEVEL_MAN

This view is used to populate the W_GENERAL_GW_LEVEL table (generally weekly)
with manual water levels.  Here, the manual water levels are extracted from
D_INTERVAL_TEMPORAL_2 where the RD_NAME_CODE is '628' (i.e. 'Water Level -
Manual - Static').  Note that only intervals where the WL_LOGGER_TOTAL_NUM or
WL_MANUAL_TOTAL_NUM (or the combination) is greater than '25' are included
here.  These two fields are found in D_INTERVAL_SUMMARY.  In addition, note
that the field name used WL_AVG_MASL does not apply to manuals (i.e. they are
not an average).  No NULL RD_DATE's are included.

#### V_SYS_W_GENERAL_OTHER

This view is used to populate the W_GENERAL_OTHER table (generally weekly).
Only the following location types are included (LOC_TYPE_CODE in brackets):

* Surface Water ('6')
* Climate Station ('9')
* Pumping Station ('10')
* Seismic Station ('15')
* Permit to Take Water ('22')

Refer to V_SYS_W_GENERAL (above) for additional details and changes.  A number
of data tables and views are accessed to extract information, these include:

* V_GEN
* V_SYS_GENERAL_INTERVAL
* D_LOCATION_GEOM
* D_LOCATION_SUMMARY
* D_INTERVAL_SUMMARY
* D_LOCATION_PURPOSE
* V_GEN_PTTW

#### V_SYS_W_GENERAL_OTHER_PTTW_ACTIVE

This view is used to change the status of 'permit to take water' (PTTW)
locations in W_GENERAL_OTHER (using the STATUS field).  If the PTTW_EXPIRYDATE
is in the future or within 6 months of the present the LOC_STATUS_DESCRIPTION
'PTTW Active' (i.e. LOC_STATUS_CODE '19') is returned.

#### V_SYS_W_GENERAL_SCREEN

This view is used to populate the W_GENERAL_SCREEN table (generally weekly).
Refer to V_SYS_W_GENERAL (above) for additional details and changes.  A number
of data tables and views are access to extract information, these include:

* V_CON_HYDROGEOLOGY
* D_LOCATION_GEOM
* D_LOCATION_SUMMARY
* D_LOCATION_PURPOSE
* W_GENERAL
* V_SYS_DIFA_ASSIGNED_FINAL
* D_BOREHOLE
* V_SYS_W_GENERAL_SCREEN_NEST

#### V_SYS_W_GENERAL_SCREEN_NEST

This view returns those locations that have been tagged as belonging to a
'nest' of wells (i.e. a grouping of wells usually from the same general area);
the GROUP_LOC_CODE (from D_GROUP_LOCATION) is included.  Note that these
groupings will correspond to GROUP_LOC_TYPE_CODE '6' (i.e. 'Well Nest').

#### V_SYS_WATERLEVELS

This view returns all water level records from D_INTERVAL_TEMPORAL_2 and
D_INTERVAL_TEMPORAL_5 (having a RD_NAME_CODE of [628] - [Water Level - Manual
- Static] - or [629] - [Water Level - Logger (Compensated & Corrected)]).  The
original SYS_RECORD_ID from each table are stored in SYS_RECORD_ID_D2 or
SYS_RECORD_ID_D5.  The values must be in [masl] (i.e. having a UNIT_CODE [6])
and have a REC_STATUS_CODE value less than [100] (values of [100] and above
indicate problematic values).

#### V_SYS_WATERLEVELS_BARO_DAILY

This view returns the number of barologger readings on a particular day for a
particular interval.  Only those intervals classified as 'Barometric Logger
Interval' ('122') are examined.  The RD_NAME_CODE must be '629' ('Water Level
- Logger (Compensated & Corrected)' with a UNIT_CODE of '128' ('cmap baro')
for a record (from D_INTERVAL_TEMPORAL_2) to be included.  Note that each of
year, month and day are returned as separate integer fields.

#### V_SYS_WATERLEVELS_BARO_YEARLY

This view returns the minimum and maximum barologger readings as well as
starting and ending dates (for the data) on a yearly basis, by interval.  The
number of days with barologger data is also indicated (using
V_SYS_WATERLEVELS_BARO_DAILY).

#### V_SYS_WATERLEVELS_DAILY_AVG

Calculates the daily average of all water levels from D_INTERVAL_TEMPORAL_2
and D_INTERVAL_TEMPORAL_5 for each interval.  These will have a RD_NAME_CODE
of either of [628] ([Water Level - Manual - Static]) or [629] ([Water Level -
Logger (Compensated & Corrected)]).  The date is converted to [mm/dd/yyyy]. 

#### V_SYS_WATERLEVELS_DAILY_AVG_LOGGER

Calculates the daily average of all water levels from D_INTERVAL_TEMPORAL_2
and D_INTERVAL_TEMPORAL_5 for each interval.  These will have a RD_NAME_CODE
of [629] ([Water Level - Logger (Compensated & Corrected)]).  The date is 
converted to [mm/dd/yyyy].

#### V_SYS_WATERLEVELS_MANUAL_FIRST

This view returns the first manual water level from D_INTERVAL_TEMPORAL_2 for
each interval.  These will have a RD_NAME_CODE of '628' (i.e. 'Water Level -
Manual - Static'); the date is converted to 'mm/dd/yyyy'.

#### V_SYS_WATERLEVELS_RANGE

This view returns the minimum, maximum and average value as well as number of
water level records from D_INTERVAL_TEMPORAL_2 for each interval.  These will
have an RD_NAME_CODE of '628' (i.e. 'Water Level - Manual - Static') or '629'
(i.e. 'Water Level - Logger (Compensated & Corrected)') as well as a UNIT_CODE
of '6' (i.e. 'masl').

#### V_SYS_WATERLEVELS_YEARLY_BOTH

This view returns the calculated minimum, maximum and average value as well as
the number of water level records from D_INTERVAL_TEMPORAL_2 for each interval
for each year of data.  This is similar to V_SYS_WATERLEVELS_YEARLY_LOGGER and
V_SYS_WATERLEVELS_YEARLY_MANUAL (below) with the exception that the logger and
manual data is combined to determine the values.

#### V_SYS_WATERLEVELS_YEARLY_LOGGER

This view returns the calculated minimum, maximum and average value as well as
the number of water level records from D_INTERVAL_TEMPORAL_2 for each interval
for each year of data.  These records must have an RD_NAME_CODE of '629' (i.e.
'Water Level - Logger (Compensated & Corrected)') and a UNIT_CODE of '6' (i.e.
'masl').

#### V_SYS_WATERLEVELS_YEARLY_MANUAL

This view is similar to V_SYS_WATERLEVELS_YEARLY_LOGGER (above) with the
exception that the records use an RD_NAME_CODE of '628' (i.e. 'Water Level -
Manual - Static').

#### V_SYS_YPDT_VL_GEOLOGY

This view was originally a source for V_VL_GEOLOGY that enabled inclusion of
the 'YPDT Viewlog Header Well'.  This has now been disabled and this view will
be removed in a future database version.

#### V_SYS_YPDT_VL_HEADER_LOG

This view was originally a source for V_VL_HEADER_LOG.  Refer to
V_SYS_YPDT_VL_GEOLOGY (above) for additional details.

#### V_SYS_YPDT_VL_HEADER_SCREEN

This view was originally a source for V_VL_HEADER_SCREEN.  Refer to
V_SYS_YPDT_VL_GEOLOGY (above) for additional details.

#### V_SYS_YPDT_VL_HEADER_WELL

This view returns the information in D_LOCATION related to the 'YPDT Viewlog
Header Well'.

*Last Modified: 2024-05-03*
