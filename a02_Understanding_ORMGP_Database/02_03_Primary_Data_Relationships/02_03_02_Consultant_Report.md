---
title:  "Section 2.3.2"
author: "ormgpmd"
date:   "20250910"
output: html_document
knit:   (
            function(input_file, encoding) {
                out_dir <- '';
                rmarkdown::render(
                    input_file,
                    encoding=encoding,
                    output_file=file.path(dirname(input_file), out_dir,
                    '02_03_02_Consultant_Report.html')
                )
            }
        )
---

## Section 2.3.2 Consultant Borehole Records

From a standard borehole reporting sheet, a number of tables are affected when
recording and transcribing information into the database.  These have been
grouped into the following sections:

* **A** - General Information (location and borehole)
* **B** - Geologic Information
* **C** - Soil Intervals (blow count data)
* **D** - Water Levels
* **E** - Water Content 
* **F** - Grain Size 

Note that the example borehole sheet has been pulled from a geotechnical
foundation report.

Affected tables are listed within each alphabetic section along with their
related reference tables and fields.  A short description and/or the reference
table (along with the record which is being used, both text description and
[coded value]) is provided with each field used.

![Figure 2.3.2.1 Borehole Record - example with sections indicated](f02_03_02_01.jpg)
*Figure 2.3.2.1 Borehole Record - example with sections indicated*

#### A - General Information

##### D_LOC

* LOC_NAME - GO-ALRT - 6
* LOC_NAME_ALT1 - 470-711-611
    + Note that the various name fields found in the data tables are
    searchable using a single query; adding project and associated information
    in these fields allows a particular borehole to be readily found
* LOC_TYPE_CODE - 1
    + R_LOC_TYPE_CODE - *Well or Borehole [1]*
* STATUS_CODE - 1
    + R_LOC_STATUS_CODE - *Active [1]*

##### D_LOC_BOREHOLE

* BOTD - 17
* BOT_OUOM - 17
* UNIT_OUOM - mbgs
* DRILL_METHOD_CODE - 13
    + R_DRILL_METHOD_CODE - *Hollow Stem Auger [13]*
* LOGGED_BY - EFO
* CHECKED_BY - JRB
* DRILL_START_DATE - 1983-07-29

##### D_LOC_PURPOSE_HIST

* PURPOSE_PRI_CODE - 3
    + R_PURPOSE_PRI_CODE - *Engineering [3]*
* PURPOSE_SEC_CODE - 47
    + R_PURPOSE_SEC_CODE - *Geotech Testhole [47]*

##### D_LOC_SPATIAL_HIST

* X - 657490.5
* Y - 4857028
* EPSG_CODE - 26917
    + Refer to **Section 2.3.1** for details concerning the assignment of the
    EPSG_CODE
* X_OUOM - 341716
* Y_OUOM - 4856463
* EPSG_CODE_OUOM - 7991
    + This corresponds to MTM Zone 10 and is tied to the NAD27 datum (as this 
    was drilled in 1983, it is likely that partiuclar datum was being used)
* QA_COORD_CODE - 3
    + R_QA_COORD_CODE - *Margin of Error : 10 - 30 m [3]*
    + This is estimated for this location
* ELEV_CODE - 2
    + R_QA_ELEV_CODE - *Original [2]*
* ELEV - 92.0
    + This is the value copied from the ELEV_OUOM field
* ELEV_UNIT_CODE - 6
    + R_UNIT_CODE - *masl [6]*
* ELEV_OUOM - 92.0
    + This is the original elevation
* ELEV_UNIT_OUOM - masl
* QA_ELEV_CODE - 9
    + R_QA_ELEV_CODE - *Unknown Elevation [9]*
    + There are no details concerning the source of the elevation so no
    accuracy can be assigned; note that a DEM elevation will subsequently be
    assigned as this is not a surveyed elevation (i.e. a new record will be
    added to the D_LOC_SPATIAL_HIST to capture the updated DEM elevation);
    refer to **Section 2.4.2** for details

These tables are related through LOC_ID, a whole number assigned to each
location within the ORMGP database.  Note that if this borehole record was
pulled from a report within the ORMGP Report Library (refer to **Section
2.3.7** and **2.6** for additional details), the D_LOC_RELATED table would be
used to create an association between the document (which would have its own
LOC_ID) and this borehole.

#### B - Geologic Information

##### D_LOC_GEOL_LAYER

Within this table, there will be one data record for each geologic layer
specified on the borehole record.  The following example uses the information
from the third stratigraphic layer (out of six layers total).  The geologic
materials are converted from text descriptions to geologic codes (as found in
the R_GEOL_MAT_CODE table).

* TOPD - 4.7
* BOTD - 5.6
* TOP_OUOM - 4.7
* BOT_OUOM - 5.6
* UNIT_OUOM - mbgs
* MATC_CODE - 2
    + R_GEOL_MATC_CODE - *GREY [2]*
* MAT1_CODE - 6
    + R_GEOL_MAT_CODE - *Silt [6]*
* MAT2_CODE - 28
    + R_GEOL_MAT_CODE - *Sand [28]*
* MAT3_CODE - 11
    + R_GEOL_MAT_CODE - *Gravel [11]*
* MAT4_CODE - 5
    + R_GEOL_MAT_CODE - *Clay [5]*
* MATD_CODE - 66
    + R_GEOL_MAT_CODE - *Dense [66]*
    + This particular field provides information on the layers consistency
* GEOL_DESC - Grey silt to sandy silt, trace gravel and clay, very dense
    + Note that the complete geologic description, if available, should be
    included within this field as an aid to interpretation

The D_LOC_GEOL_LAYER table is linked to a location (D_LOC) through the LOC_ID
field.  Note that in addition, though not used as part of this example,
details such as *Brown, becoming grey at 88.7m* could be captured in the
D_LOC_ATTR table.

#### C - Soil Intervals (Blow Count Data)

This type of information is actually related to a (field-collected) soil
sample with a specific top and bottom.  As such, this is considered an
interval.  The example here is the sixth soil (split spoon) sample.

##### D_INT

* INT_NAME - GO-ALRT - 6 (SS 6)
    + The name is equivalent to LOC_NAME (in D_LOC) with the addition of the
    sample type (i.e. split spoon - SS) and the sample number (6) within the
    borehole record
* INT_TYPE_CODE - 29
    + R_INT_TYPE_CODE - *Soil or Rock [29]*
* INT_START_DATE - 1983-07-29

##### D_INT_ATTR

* ATTR_CODE - 40
    + R_ATTR_CODE - *Interval - Screen or Soil Depths [40]*
* TOPD - 4.65
* BOTD - 4.8
* TOP_OUOM - 4.65
* BOT_OUOM - 4.8
    + Not that the top and bottom depths are estimated from the borehole
    record
* UNIT_OUOM - mbgs
* VALI - 100
    + A blow count should be a whole (integer) number; it is generally
    considered to be the number of blows to drive the split spoon six inches
* VAL_DEF - 100
* COMMENT - 100 blows for 15cm penetration

The D_INT table contains the keys LOC_ID and INT_ID; only the latter is a
primary key.  This table allows a single location to be linked to multiple
(types of) intervals.  All other interval tables are accessed, and linked,
through the INT_ID field.  Note that there is grain size data associated with
this particular sample.  The means to capture this information is found in *F
- Lab Analysis*, following.

Note that for these type of intervals, the various VAL\* fields have been
adopted to hold particular data related to the particular soil interval.
These include:

* VALF - <Recovery as a percent>
* VALF2 - <Moisture as a percentage>

In most cases, these soil samples will have limited data associated with them
(e.g. blow count, recovery  and moisture).  Any additional information would
then be found in D_INT_TEMPORAL_1A/1B (if a complete laboratory record is
available or multiple records over time have been recorded) or D_INT_ATTR_RD
(again, if limited information is available).

#### D - Water Levels

Water levels are also tied to intervals, as was the case with the *C - Soil
Intervals* discussed previously.  These, however are associated with screened
rather than soil intervals.

##### D_INT

* INT_NAME - GO-ALRT
    + This name is equivalent to LOC_NAME (in D_LOC) 
* INT_TYPE_CODE - 18
    + R_INT_TYPE_CODE - *Reported Screen [18]*
* INT_START_DATE - 1983-07-29

##### D_INT_DEPTH

* TOPD - 9
* BOTD - 9.3
* TOP_OUOM - 9
* BOT_OUOM - 9.3
    + Not that the top and bottom depths are estimated from the borehole
    record
* UNIT_OUOM - mbgs

There is little information concerning the screened interval.  The values here
are estimated from the borehole record.  In most cases, a diameter would also
be available.

##### D_INT_TEMPORAL_2

* RD_TYPE_CODE - 74
    + R_RD_TYPE_CODE - *WL - Static (Not MOE) [74]*
* RD_NAME_CODE - 628
    + R_RD_NAME_CODE - *Water Level - Manual - Static [628]*
* RD_DATE - 1983-08-05
* RD_VALUE - 2.8
* UNIT_CODE - 18
    + R_UNIT_CODE - *mbgs [18]*
* RD_NAME_OUOM - Water Level - Manual - Static
* RD_VALUE_OUOM - 2.8
    + In this case, the original ground elevation is used to calculate the
    depth to the static water level
* RD_UNIT_OUOM - mbgs

Both D_INT_DEPTH and D_INT_TEMPORAL_2 are linked to D_INT through the INT_ID
field.

#### E - Water Content 

Information or data produced or determined in a laboratory is generally found
in the D_INT_TEMPORAL_1A/1B tables.  However, in many cases, the information
concerning the laboratory analysis is not available.  When this occurs,
pseudo-lab records can be created or the D_INT_ATTR table can be used in its
stead.  Refer to *C - Soil Intervals (Blow Count)*, as described
previously.  There is usually a water content measurement for each soil sample
taken.  The example here is the sixth soil (split spoon) sample and it is
evaluated for both storage methodologies.

##### D_INT_ATTR

The same record, as described in D_INT_ATTR, is used.  In this case, the
moisture percentage is stored in VALF2.

* VALF2 - 17
    + A soil moisture reading should be stored as a floating point number
    (expressed as a percentage)

The D_INT_ATTR table is linked through INT_ID to D_INT.

Alternatively, if we are using the temporal tables, the setup would consist of
the following.

##### D_INT_TEMPORAL_1A

* SAM_NAME - GO-ALRT
* SAM_DATE - 1983-07-29
* SAM_TYPE_CODE - 12
    + R_SAM_TYPE_CODE - *Regular Sample [12]*

##### D_INT_TEMPORAL_1B

* RD_NAME_CODE - 289
    + R_RD_NAME_CODE - *Moisture Content [289]*
* RD_VALUE - 17
* UNIT_CODE - 1
    + R_UNIT_CODE - *% [1]*
* RD_NAME_OUOM - Moisture Content
* RD_VALUE_OUOM - 17
* RD_UNIT_OUOM - %

The D_INT_TEMPORAL_1A table is linked through INT_ID to D_INT.  The
D_INT_TEMPORAL_1B table is linked to D_INT_TEMPORAL_1A through SAM_ID.  Note
that for this methodology, any number of parameters can be associated with a
particular sample (i.e. SAM_ID).

#### F - Grain Size 

Similarly to *E - Water Content*, grain size analysis information can be
stored in either the temporal or attribute tables tied to a particular
interval.  For the latter, the D_INT_ATTR_RD table is also used.  From this
borehole record, only two grain size analyses were performed.  The example
here is the sixth soil (split spoon) sample and it is evaluated for both
storage methodologies.

##### D_INT_ATTR_RD

Four grain size percentages are available here.  Namely: gravel (0%); sand
(25%); Silt (68%); and Clay (7%).  This would result in four records tied to
the interval in this table.  The example shown here is only for sand.

* RD_NAME_CODE - 70578
    + R_RD_NAME_CODE - *%Sand [70578]*
* RD_VALUE - 25
* UNIT_CODE - 1
    + R_UNIT_CODE - *% [1]*
* RD_NAME_OUOM - %Sand
* RD_VALUE_OUOM - 25
* RD_UNIT_OUOM - %

The D_INT_ATTR table is linked through INT_ID to D_INT while the D_INT_ATTR_RD
table is linked to D_INT_ATTR through IATTR_ID.

Alternatively, if we are using the temporal tables, the setup would consist of
the following.  Note that this dataset could piggy-back on top of that
described in *E - Water Content*.  

##### D_INT_TEMPORAL_1A

* SAM_NAME - GO-ALRT
* SAM_DATE - 1983-07-29
* SAM_TYPE_CODE - 12
    + R_SAM_TYPE_CODE - *Regular Sample [12]*

##### D_INT_TEMPORAL_1B

As described in D_INT_ATTR_RD, previously, only the example of sand is provided
(four records would actually be recorded).

* RD_NAME_CODE - 70578
    + R_RD_NAME_CODE - *%Sand [70578]*
* RD_VALUE - 25
* UNIT_CODE - 1
    + R_UNIT_CODE - *% [1]*
* RD_NAME_OUOM - %Sand
* RD_VALUE_OUOM - 25
* RD_UNIT_OUOM - %

*Last Modified: 2025-09-10*
