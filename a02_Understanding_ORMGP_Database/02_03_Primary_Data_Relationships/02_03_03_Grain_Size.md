---
title:  "Section 2.3.3"
author: "ormgpmd"
date:   "20250603"
output: html_document
knit:   (
            function(input_file, encoding) {
                out_dir <- '';
                rmarkdown::render(
                    input_file,
                    encoding=encoding,
                    output_file=file.path(dirname(input_file), out_dir,
                    '02_03_03_Grain_Size.html')
                )
            }
        )
---

## Section 2.3.3 Grain Size Data

When grain size data is available, it may be indicated as part of the borehole
log (refer to **Section 2.3.2** for details) or as a separate analysis.  An
example of the latter is found here.  A number of tables are utilized to store
these results.

![Figure 2.3.3.1 Grain Size Analysis - source data](f02_03_03_01.png)
*Figure 2.3.3.1 Grain Size Analysis - source data*

Here, the results of three sample analyses are shown.  If the values related
to *Borehole 1, Sample 7* are examined (which has a number of data points), we
can see that the components break down into:

* 3% Clay
* 21% Silt
* 50% Sand
* 26% Gravel

This analysis is found in a report held within the ORMGP Report Library
(document folder *6354*) from which the particular borehole (i.e. *Borehole
1*) has been entered into the database (using LOC_NAME *MTO-30M14-066/1*).

![Figure 2.3.3.2 Borehole 1 Record ](f02_03_03_02.png)
*Figure 2.3.3.2 Borehole 1 Record*

This borehole location has the distinct LOC_ID of *341102* (note that this
is a *Version 8* database location identifier; the *Version 7* identifier is
*1125539377*) but no soil samples are currently identified; a screened
interval, for water levels, does exist.  As such, a new soil interval needs to
be created.  The affected tables would be:

##### D_INT

* LOC_ID - 341102
    + This location was already present in the ORMGP database
* INT_ID - 363068
    + As this is a new record for the D_INT table, an identifier is
    automatically generated; in *Version 8* of the ORMGP database, INT_ID is
    an identify field - a counter that increments when a record is added 
* INT_NAME - MTO-30M14-66-1 Soil-549
    + The name of the location (and interval) is included here along with a
    means by which the particular sample can be identified;  in this case, it
    is the original elevation of the sample-top as identified up the borehole
    record
* INT_TYPE_CODE - 29
    + R_INT_TYPE_CODE - *Soil or Rock [29]*
* INT_START_DATE - 1967-09-07
    + As no sample analysis date is provided, the date of the borehole
    construction (from the report) is used instead

##### D_INT_DEPTH

* INT_ID - 363068
    + This is copied from the D_INT table
* TOPD - 7.37616
* BOTD - 7.52856
    + Note that these are calculated from the TOP_OUOM and BOT_OUOM fields
* TOP_OUOM - 24.2
* BOT_OUOM - 24.7
    + These values, extracted from the original borehole record, have units
    specified through UNIT_OUOM; note that the values have been converted from
    elevations (as presented on the borehole record) to depths using the
    specified ground elevation
* UNIT_OUOM - fbgs





The following information needs to be captured in the data entry:

* The LOC_ID from D_LOCATION (i.e. from what location is the sample from)
* The INT_ID from D_INTERVAL associated with this sample at this location; if this is a new interval/soil sample, a new INT_ID must be created that is tied back or related to the LOC_ID; the depths from which the sample was taken must also be known and they would be entered into D_INTERVAL_SOIL linked by the INT_ID to the LOC_ID
* If this is a new interval, the interval type needs to be specified in D_INTERVAL (this is from R_INT_TYPE_CODE with an INT_TYPE_CODE of 118 - Soil)
* The names and name codes for the attributes (the fields RD_NAME_CODE and RD_NAME_OUOM from the R_RD_NAME_CODE table:
    + %Clay (70756)
    + %Silt (70757)
    + %Sand (70758)
    + %Gravel (70759)
* The units and unit codes for the attribute values (the fields UNIT_CODE and RD_UNIT_OUOM from the R_UNIT_CODE table):
    + % (107; i.e. percent)
* The date the information was collected (for SAM_SAMPLE_DATE)
* As this is lab data, the sample name (for SAM_SAMPLE_NAME in D_INTERVAL_TEMPORAL_1A)

Combining the information that would reside in D_INTERVAL_TEMPORAL 1A/1B, the
input data, then, would have the following approximate form.

Note that there are four rows of data, dependent upon the reading name code,
and they are all tied back to a single soil sample.  This information, upon
entry into the database, would then populate one record in the
D_INTERVAL_TEMPORAL_1A table (including the sample name and sample date) and
four records in the D_INTERVAL_TEMPORAL_1B table (the actual parameter data).
The two tables would be linked based upon an imposed (randomly assigned) key
(SAM_ID).  Refer to Section 2.3.4 for a breakdown of fields affected in
D_INTERVAL_TEMPORAL_1A and D_INTERVAL_TEMPORAL_1B upon data import.

Note also, that in the D_INTERVAL_TEMPORAL_1A table, there are additional
fields that can be used to track information regarding the laboratory that
performed the analyses including the laboratories sample numbering (through
SAM_LAB_SAMPLE_ID), its internal job number (through SAM_LAB_JOB_NUMBER) and
analysis date (through SAM_ANALYSIS_DATE).  This allows one to go back to the
original laboratory report or the laboratory itself to check the data entry
(or possible analysis error) should a problem with the data be discovered in
the future.

*Last Modified: 2026-06-03*
