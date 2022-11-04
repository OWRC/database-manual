---
title:  "Section 2.1.5"
author: "ormgpmd"
date:   "20221104"
output: html_document
knit:   (
            function(input_file, encoding) {
                out_dir <- '';
                rmarkdown::render(
                    input_file,
                    encoding=encoding,
                    output_file=file.path(dirname(input_file), out_dir,
                    '02_01_05_Main_Views.html')
                )
            }
        )
---

## Section 2.1.5 Main Views

These views were created specifically for general users to allows 'snapshots' of information to be extracted from the database without having to manipulate the underlying tables directly.  Any look-up (i.e. reference) values should include their text descriptions.

#### V_CON_\* (Consultant Views)

These views were prepared to provide a 'cutout' of information from the database that can be provided to consultants working in a specific geographic area of a partner agencies jurisdiction.  Rather than providing the entire database to a consultant, specific locations in the project area can be flagged by making use, for example, of the SYS_TEMP_1 or SYS_TEMP_2 fields (though there are alternative methods).  Once the locations have been flagged using a specific, searchable, value (possibly created spatially through, for example, Viewlog or a GIS) then the V_CON_* views can be filtered to extract the locations (and their information) required by the consultant.  See also Appendix J.3 for an (internal) Microsoft SQL Server solution.  Note that these views honour the settings in LOC_CONFIDENTIALITY_CODE and INT_CONFIENTIALITY_CODE.

The views contain a subset of available data fields as well as introducing summary fields (especially with regard to temporal data) of available information found at each location.  All look-up codes have been translated to their named equivalents.  

#### V_CON_DOCUMENT

This view simplifies the listing of the documents residing within the ORMGP report library.  Only a certain number of fields from the D_LOCATION and D_DOCUMENT tables are included here.  Consultants may then wish to request specific report files as a follow up action.  The data returned here is meant to be a subset of V_GEN_DOCUMENT.

#### V_CON_GENERAL

This view summarizes the main location information from a number of tables including location names, coordinates, borehole depth, ground surface elevation, etc?  It also includes

* The number of water level readings associated with the/any screens
* The number of soil samples from the borehole
* The number of pumping measurements taken
* The number of water quality readings taken
* The number of geologic layers present
* The number of screens present

#### V_CON_GEOLOGY

This view includes the top- and bottom-elevations of the geologic units associated with a location.  In addition, the material codes have converted to their text descriptions.  The data returned here is meant to be a subset of V_GEN_GEOLOGY.

#### V_CON_HYDROGEOLOGY

This view includes the screen information by location (multiple screens at a location would be represented across multiple records).  Any associated pumping and water level data (including the date for the former and the date range for the latter) are indicated.  The formation assigned to the screen (if identified) is shown.  A well flowing tag (FLOWING) is also returned.  The data returned here is meant to be a subset of V_GEN_HYDROGEOLOGY.

#### V_CON_PICK

This view returns information from the PICKS table - additions including the location name and study as well as the borehole depth.  The data returned here is meant to be a subset of V_GEN_PICK.

#### V_CON_PTTW

This view returns information from the D_LOCATION and D_PTTW tables.  The data returned here is meant to be a subset of V_GEN_PTTW.

#### V_CON_STATION_SURFACEWATER

Extracts various streamflow values present in D_LOCATION_SUMMARY for Surface 
Water locations.  The data returned here is meant to be a subset of
V_GEN_STATION_SURFACEWATER (based upon SECURITY_CODE).

#### V_CON_WATER_LEVEL_AVG_DAILY

This view returns the daily calculated average water level as well as associated information (e.g. reference point, ground elevation, screen depths, etc?).

#### V_GEN_\* (General Views)

The base views provided in the database, and discussed here, are for the partner agencies to readily access information from the multitude of tables that have been described, above.  The purpose of the views is to pull or query out key information from the database and present it in an easy to understand manner.  The V_GEN_* views are preferentially to be used when accessing the database (by non-expert users).  Each view contains basic information from a particular location (e.g. LOC_ID, LOC_NAME, LOC_NAME_ALT1, LOC_COORD_EASTING, LOC_COORD_NORTHING, etc...) as well as information related to the particular view name (e.g. in addition to the previously mentioned fields, the V_GEN_GEOLOGY view contains BH_GND_ELEV, BH_TOP_ELEV, BH_BOTTOM_ELEV, etc...).  In many cases, the original field names have been modified to for ease of use or to more adequately describe the data contained within.

#### V_GEN

This is the base view used by many other V_GEN_* views.  Only basic information is available here (e.g. name, coordinates, purpose, etc?).

#### V_GEN_BOREHOLE

This view contains basic borehole information, combining data from D_LOCATION and D_BOREHOLE (in which the location must be present) as well as some screen information (if available).

#### V_GEN_BOREHOLE_BEDROCK

This view uses V_GEN_BOREHOLE as a base only extracting those locations that encounter bedrock.  This is dependent upon the BH_BEDROCK_ELEV being populated (in D_BOREHOLE; refer to Appendix G with regards to how this is accomplished).

#### V_GEN_BOREHOLE_OUTCROP

This view uses V_GEN_BOREHOLE as a base only extracting those locations that are identified as outcrop (i.e. LOC_TYPE_CODE '11').

#### V_GEN_DOCUMENT

This view extracts document (i.e. LOC_TYPE_CODE '25') information from the D_LOCATION and D_DOCUMENT tables.  Only basic information such as the title and folder number (as found within the ORMGP report library) and the author and client agencies are included.

#### V_GEN_DOCUMENT_ASSOCIATION

This view extracts all locations (usually boreholes) associated with a particular document.  This information is accessed from the D_DOCUMENT_ASSOCIATION table.

#### V_GEN_DOCUMENT_BIBLIOGRAPHY

This view assembles a bibliographic reference for each document in D_DOCUMENT.  The format handles reports, journal articles and texts appropriately.

#### V_GEN_FIELD

This view extracts all field data (i.e. from D_INTERVAL_TEMPORAL_2) by interval and location.  Parameter codes are converted to their text description.

#### V_GEN_FIELD_CLIMATE

This view extracts all climate data stored in D_INTERVAL_TEMPORAL_3 - this information is tied to an actual climate station.  The query only applies to data with a READING_GROUP_CODE of '22' (i.e. 'Meteorological').

#### V_GEN_FIELD_CLIMATE_SUMMARY

This view extracts summaries of climate data stored in D_INTERVAL_TEMPORAL_3.  Intervals are not checked with regard to being climate stations.

####  V_GEN_FIELD_METEOROLOGICAL

This view extracts all climate data stored in D_INTERVAL_TEMPORAL_2.  The query only applies to data with a READING_GROUP_CODE of '22' (i.e. 'Meteorological').  This is a subset of the V_GEN_FIELD view.

#### V_GEN_FIELD_PUMPING_PRODUCTION

This view extracts all pumping data stored in D_INTERVAL_TEMPORAL_2.  The query only applies to data with a READING_GROUP_CODE of '35' (i.e. 'Discharge/Production - From Wells?').

#### V_GEN_FIELD_STREAM_FLOW

This view extracts all stream flow data stored in D_INTERVAL_TEMPORAL_5.  The query only applies to data with a READING_GROUP_CODE of '25' (i.e. 'Stream Flow Related').  

#### V_GEN_FIELD_STREAM_FLOW_SUMMARY

This view extracts summaries of data stored in D_INTERVAL_TEMPORAL_5.  Intervals are not checked for being streamflow stations.

#### V_GEN_FIELD_SUMMARY

This view summarizes the data in D_INTERVAL_TEMPORAL_2 grouped by interval, parameter and parameter units (the latter should be used as a quality check).  This returns the start and end dates, count and average for each parameter.

#### V_GEN_GEOLOGY

This view extracts the information from D_GEOLOGY_LAYER by location.  Parameters are converted to their text descriptions.

#### V_GEN_GEOLOGY_DEEPEST_NONROCK

This view extracts the lowest geologic layer from D_GEOLOGY_LAYER for locations that do not intercept the bedrock surface.  Note that this relies upon BH_BEDROCK_ELEV being populated in D_BOREHOLE.

#### V_GEN_GEOLOGY_OUTCROP

This view extracts information from D_GEOLOGY_LAYER where the location has a LOC_TYPE_CODE of '7' (i.e. 'Testpit'), '11' (i.e. 'Outcrop') or '19' (i.e. 'Bedrock Outcrop').  This is a subset of V_GEN_GEOLOGY.

#### V_GEN_HYDROGEOLOGY

This view extracts hydrogeologic information by screened interval (based upon the presence of the interval in D_INTERVAL_MONITOR) and includes data on: screens; water levels; water quality; and pumping.  Note that D_INTERVAL_SUMMARY is used as a source for all summary data.  This view combines all intervals with the same INT_ID in D_INTERVAL_MONITOR (see V_GEN_HYDROGEOLOGY_FULL, below, if this is not desired).

#### V_GEN_HYDROGEOLOGY_BEDROCK

This view extracts hydrogeologic information by screened interval using V_GEN_HYDROGEOLOGY as the source.  All intervals here must have the bottom screen elevation below that of the bedrock surface (as found in D_BOREHOLE).

#### V_GEN_HYDROGEOLOGY_FULL

This view extracts information in a similar manner to V_GEN_HYDROGEOLOGY.  However, this view does not combine interval information in D_INTERVAL_MONITOR (where multiple records exist with the same INT_ID but differing top- and bottom-elevations).

#### V_GEN_INTERVAL_FORMATION

This view mimics the original format of the D_INTERVAL_FORMATION_ASSIGNMENT table extracting, for each screen or soil interval: the assigned geologic unit; the next and previous geologic unit; and the vertical distance to the next and previous geologic units.

#### V_GEN_LAB

This view extracts all laboratory data (i.e. from D_INTERVAL_TEMPORAL_1A and D_INTERVAL_TEMPORAL_1B) by interval and location.  Parameter codes are converted to their text description.

#### V_GEN_LAB_BACTERIOLOGICALS

This view returns a subset of V_GEN_LAB extracting only those parameters having a READING GROUP_CODE of '36' (i.e. 'Water - Bacteriological Related').

#### V_GEN_LAB_EXTRACTABLES

This view returns a subset of V_GEN_LAB extracting only those parameters having a READING GROUP_CODE of '5' (i.e. 'Water - Extractables').

#### V_GEN_LAB_GASES

This view returns a subset of V_GEN_LAB extracting only those parameters
having a READING_GROUP_CODE of '38' (i.e. 'Water - Dissolved Gases').

#### V_GEN_LAB_GENERAL

This view returns a subset of V_GEN_LAB extracting only those parameters having a READING GROUP_CODE of '26' (i.e. 'Chemistry - General).

#### V_GEN_LAB_HERBICIDES_PESTICIDES

This view returns a subset of V_GEN_LAB extracting only those parameters having a READING GROUP_CODE of '4' (i.e. 'Water - Pesticides and Herbicides').

#### V_GEN_LAB_IONS

This view returns a subset of V_GEN_LAB extracting only those parameters having a READING GROUP_CODE of '1' (i.e. 'Water - Major Ions').

#### V_GEN_LAB_ISOTOPES

This view returns a subset of V_GEN_LAB extracting only those parameters having a READING GROUP_CODE of '15' (i.e. 'Water - Isotopes').

#### V_GEN_LAB_METALS

This view returns a subset of V_GEN_LAB extracting only those parameters having a READING GROUP_CODE of '2' (i.e. 'Chemistry - Metals').

#### V_GEN_LAB_ORGANICS

This view returns a subset of V_GEN_LAB extracting only those parameters having a READING GROUP_CODE of '28' (i.e. 'Water - Miscellaneous Organics').

#### V_GEN_LAB_PAHS

This view returns a subset of V_GEN_LAB extracting only those parameters
having a READING_GROUP_CODE of '20' (i.e. 'Chemistry - PAHs (Water or
Soil/Rock)').

#### V_GEN_LAB_PHCS

This view returns a subset of V_GEN_LAB extracting only those parameters
having a READING_GROUP_CODE of '33' (i.e. 'Chemistry - PHCs (Water or
Soil/Rock)').

#### V_GEN_LAB_SOIL

This view returns a subset of V_GEN_LAB extracting only those intervals that are soil samples.

#### V_GEN_LAB_SUMMARY

This view summarizes the contents of D_INTERVAL_TEMPORAL_1A and D_INTERVAL_TEMPORAL_1B grouped by interval, parameter and parameter units (note that the latter should be used as a QA check).  This returns the start and end dates, count and average for each parameter.

#### V_GEN_LAB_SUMMARY_GROUP

This view summarizes each of the V_GEN_LAB_* views, returning the start and end dates as well as the number of records associated with a particular reading group.

#### V_GEN_LAB_SUMMARY_SAMPLE_COUNT

This view summarizes the V_GEN_LAB_\* views, returning the minimum and maximum dates of all samples as well as the count of each reading group.

#### V_GEN_LAB_SUMMARY_SAMPLE_COUNT_DETAIL

This view summarizes the V_GEN_LAB_\* views, returning the minimum and maximum dates and a count for each reading group.

#### V_GEN_LAB_SUMMARY_SAMPLE_COUNT_YEARLY

This view returns a count of samples by year for each interval in D_INTERVAL_TEMPORAL_1A.

#### V_GEN_LAB_SUMMARY_SAMPLE_COUNT_YEARLY_SOIL

This view returns a count of samples by year for each soil interval in D_INTERVAL_TEMPORAL_1A.  A subset of V_GEN_LAB_SUMMARY_SAMPLE_COUNT_YEARLY, using the INT_TYPE_CODE '29' (i.e. 'Soil or Rock'), is the source of this view.

#### V_GEN_LAB_SUMMARY_SAMPLE_GROUP

This view returns a number of readings count (by group) for a particular sample for a particular interval.

#### V_GEN_LAB_SVOCS

This view returns a subset of V_GEN_LAB extracting only those parameters having a READING GROUP_CODE of '29' (i.e. 'SVOCs').

#### V_GEN_LAB_VOCS

This view returns a subset of V_GEN_LAB extracting only those parameters having a READING GROUP_CODE of '3' (i.e. 'Water - VOCs').

#### V_GEN_MOE_REPORT

This view returns each MOE well in the old 'green book' format.  A value of 'ND' indicates 'not defined' (i.e. no value) for the particular column.

#### V_GEN_MOE_WELL

This view returns all the MOE wells (as tagged by DATA_ID in D_DATA_SOURCE) as a subset of V_GEN.  As of 20170614, these DATA_IDs are: -1809069713, 517, 156458478, 1229103552, 1257268550, 1285616179, 1350796350 and 1846079169.

#### V_GEN_PICK

This view returns the information from D_PICK in addition to location information from D_LOCATION.

#### V_GEN_PTTW

This view extracts all 'Permit to Take Water' records (i.e. LOC_TYPE_CODE '22') and associated location details.  All look-up codes are converted to their text descriptions.

#### V_GEN_PTTW_RELATED

This view returns all 'Permit to Take Water' (PTTW) records related to a particular PTTW record; the latter LOC_ID will be available in LOC_ID_RELATED.

#### V_GEN_PTTW_SOURCE

This view extracts all 'Permit to Take Water' (PTTW) records for which their source has been identified within the Master database.  In this case, the LOC_MASTER_LOC_ID for the PTTW record will contain the source LOC_ID.  The PERMIT_LOC_ID is the identifier for the PTTW; LOC_ID will be the source identifier.  Note that not all the PTTW records have been successfully linked to a source (these will have their LOC_ID present in LOC_MASTER_LOC_ID in D_LOCATION).

#### V_GEN_PUMPING_MUNICIPAL_PTTW_VOLUME_YEARLY

This view uses V_GEN_PUMPING_MUNICIPAL_VOLUME_YEARLY (below) as a source, including 'Permit to Take Water' (PTTW) data from V_SYS_PTTW_SOURCE_VOLUME where the source for the PTTW has been determined (refer to V_GEN_PTTW_SOURCE, above, for details).

#### V_GEN_PUMPING_MUNICIPAL_VOLUME_MONTHLY

This view is similar to V_GEN_PUMPING_VOLUME_MONTHLY (below) with the exception that only intervals with an LOC_STATUS_CODE of '8' (i.e. 'Standby Municipal Pumping Well'), '11' (i.e. 'Active Municipal Pumping Well'), '12' (i.e. 'In-active Municipal Pumping Well') or '13' (i.e. 'Decommissioned Municipal Pumping Well') will have data returned.  Note that these locations must not have a QA_COORD_CONFIDENCE_CODE of '117' (i.e. 'YPDT - Coordinate Invalid ?').

#### V_GEN_PUMPING_MUNICIPAL_VOLUME_YEARLY

This view is similar to V_GEN_PUMPING_VOLUME_YEARLY (below) with the exception that only municipal pumping well data will be returned, as V_GEN_PUMPING_MUNICIPAL_VOLUME_MONTHLY (above).

#### V_GEN_PUMPING_VOLUME_MONTHLY

This view extracts pumping data from D_INTERVAL_TEMPORAL_2 (using RD_NAME_CODE '447' - 'Production - Pumped Volume (Total Daily)' - and UNIT_CODE '74' - 'm3/d') calculating the minimum, maximum, average and total volume as well as the total number of records by interval for each month (for which data exists).  

#### V_GEN_PUMPING_VOLUME_YEARLY

This view is similar to V_GEN_PUMPING_VOLUME_YEARLY (above) with the exception that data is calculated for each interval for each year for which data exists.  In addition, the total volume is divided by '365' to calculate AVG_VOLUME_M3_D_YEAR.

#### V_GEN_STATION_BASEFLOW_ANNUAL

This view returns the minimum, maximum and average (as well as the total number of records) baseflow values from D_INTERVAL_TEMPORAL_2 (using RD_NAME_CODES '1002', '1003', '1004', '1005', '1006', '1007', '1008', '1009', '1010', '1011', '1012', '1013' and '70980') for each interval and year of data.

#### V_GEN_STATION_CLIMATE

This view extracts summary precipitation and temperature data (from D_LOCATION_SUMMARY) for all climate stations (i.e. LOC_TYPE_CODE '9') within the database.

#### V_GEN_STATION_CLIMATE_PRECIP_ANNUAL

This view determines the yearly maximum, average and number of precipitation records (having a RD_NAME_CODE of '551' - 'Precipitation - Daily Total') from D_INTERVAL_TEMPORAL_3 for the climate stations found in V_GEN_STATION_CLIMATE (above).

#### V_GEN_STATION_CLIMATE_PRECIP_WYEAR

Calculates the water-yearly maximum, average and number of precipitation records 
from D_INTERVAL_TEMPORAL_3 for those climate stations found in V_GEN_STATION_CLIMATE.  
Note that this corresponds to the date interval October 1st through September 30th. 

The original date of the record is modified by subtracting nine months to determine the water-year.
The WYEAR field value corresponds to the year in which the starting month (October)
occurs.

#### V_GEN_STATION_SURFACEWATER

For those locations of LOC_TYPE_CODE '6' (i.e. 'Surface Water'), this view extracts the various streamflow values present in D_LOCATION_SUMMARY.

#### V_GEN_STATION_SURFACEWATER_ANNUAL

This view calculates the yearly average, minimum, maximum and total number of records with RD_NAME_CODE '1001' (i.e. 'Stream Flow - Daily Discharge ?') and '70870' (i.e. 'Stream Flow - Spot Flow') for all intervals in D_INTERVAL_TEMPORAL_2.  Note that those values with UNIT_CODE '30' (i.e. 'L/s') are converted to 'm3/s' on-the-fly.

#### V_GEN_WATERLEVEL_BARO_YEARLY

This view returns the minimum, maximum and number of records for each interval for each year of record (from D_INTERVAL_TEMPORAL_2); V_SYS_WATERLEVELS_BARO_YEARLY is used as the source of the calculations.  Note that only those rows with an INT_TYPE_CODE of '122' ('Barometric Logger Interval'), an RD_NAME_CODE of '629' ('Water Level - Logger (Compensated & Corrected)') and UNIT_CODE of '128' ('cmap baro') will be included.

#### V_GEN_WATERLEVEL_LOGGER_YEARLY

This view returns the minimum, maximum, average and number of records for each interval for each year of record (from D_INTERVAL_TEMPORAL_2); V_SYS_WATERLEVELS_LOGGER_YEARLY is used as the source of the calculations.  Note that only those rows with a RD_NAME_CODE of '629' (i.e. 'Water Level - Logger (Compensated & Corrected)') and UNIT_CODE of '6' (i.e. 'masl') will be included.

#### V_GEN_WATERLEVEL_MANUAL_YEARLY

This view returns the minimum, maximum, average and number of records for each interval for each year of record (from D_INTERVAL_TEMPORAL_2); V_SYS_WATERLEVELS_MANUAL_YEARLY is used as the source of the calculations.  Note that only those rows with a RD_NAMECODE of '628' (i.e. 'Water Level - Manual - Static') and UNIT_CODE of '6' (i.e. 'masl') will be included.

#### V_GEN_WATERLEVEL_YEARLY

This view returns a combination of the data from V_GEN_WATERLEVEL_LOGGER_YEARLY and V_GEN_WATERLEVEL_MANUAL_YEARLY (as described above).  Note that the source of calculations, here, is V_SYS_WATERLEVELS_YEARLY_BOTH.

#### V_GEN_WATER_FOUND

This view returns the records from D_GEOLOGY_FEATURE where the top elevation is not null and the FEATURE_CODE is any of:

* WATER FOUND - FRESH (i.e. '1')
* WATER FOUND - SALTY (i.e. '2')
* WATER FOUND - SULPHUR (i.e. '3')
* WATER FOUND - MINERIAL (i.e. '4')
* WATER FOUND - NOT STATED (i.e. '5')
* WATER FOUND - GAS (i.e. '6')
* WATER FOUND - IRON (i.e. '7')
* WATER FOUND - Untested (i.e. '8')

Note that these, in general, relate to the original MOE records.

#### V_GEN_WATER_LEVEL

This view extracts all records from D_INTERVAL_TEMPORAL_2 that have a RD_NAME_CODE of '628' (i.e. 'Water Level - Manual - Static') or '629' (i.e. 'Water Level - Logger (Compensated & Corrected)').

#### V_GEN_WATER_LEVEL_AVG

This view returns the calculated average water level and number of records for each interval; note that V_GEN_WATER_LEVEL (above) is used as the source.

#### V_GEN_WATER_LEVEL_AVG_DAILY

This view returns the calculated daily average water level and number of records from D_INTERVAL_TEMPORAL_2 for each interval and day of record; similar to V_GEN_WATERLEVEL_YEARLY_BOTH (above) it uses manual and logger water level data as the source.  The lowest SYS_RECORD_ID value is also included.  Note that the RD_NAME_CODE of '645' (i.e. 'Water Level - Logger - Calc - Average Daily') is substituted instead of the original codes.

#### V_GEN_WATER_LEVEL_AVG_DAILY_LOGGER

This view returns the calculated daily average water level and number of records from D_INTERVAL_TEMPORAL_2 for each interval and day of record; similar to V_GEN_WATERLEVEL_LOGGER_YEARLY (above) it uses only logger water level data as the source.  Refer to V_GEN_WATER_LEVEL_AVG_DAILY (above) for additional details.

#### V_GEN_WATER_LEVEL_OTHER

This view extracts all water level records from D_INTERVAL_TEMPORAL_2 whose RD_NAME_CODE is associated with READING_GROUP_CODE '23' (i.e. 'Water Level') with the exception of RD_NAME_CODE's '628 (i.e. 'Water Level - Manual - Static') and '629' (i.e. 'Water Level - Logger (Compensated & Corrected)').

#### V_GROUP_INTERVAL

This view returns the number of intervals associated with a particular interval group.  The descriptive text for the interval groups and interval group types are included.  Note that empty (i.e. non-assigned) groups will also be included.

#### V_GROUP_LOCATION

This view returns the number of locations associated with a particular location group.  The descriptive text for the location groups and location group types are included.  Note that empty (i.e. non-assigned) groups will also be included.

#### V_QA_NEW_BOREHOLE

This view returns all 'new' records from the D_BOREHOLE table; this corresponds to any record entered into the database within the last 60 days.  The SYS_TIME_STAMP field is used as the date reference.

#### V_QA_NEW_D_INTERVAL

This view returns all 'new' records from the D_INTERVAL table.  Refer to V_QA_NEW_BOREHOLE (above) for additional details.

#### V_QA_NEW_D_LOCATION

This view returns all 'new' records from the D_LOCATION table.  Refer to V_QA_NEW_D_BOREHOLE (above) for additional details.

#### V_SUM_FIELD_LAB_VALUES

This view returns the summary of laboratory records (from D_INTERVAL_TEMPORAL_1A/1B) and field records (from D_INTERVAL_TEMPORAL_2) for all intervals.  The range of dates for each is indicated as well as the number of records.  Each of V_SUM_FIELD_VALUES and V_SUM_LAB_SAMPLES (see below) are used as a source.

#### V_SUM_FIELD_VALUES

This view returns the summary of field records (from D_INTERVAL_TEMPORAL_2) for all intervals.  The range of dates is indicated as well as the number of records.

#### V_SUM_INT_TYPE_COUNTS

This view returns the total number of intervals by interval type (see R_INT_TYPE_CODE) as found in D_INTERVAL.  Note that empty interval types will be indicated.  This view is used to (partially) populate D_VERSION_STATUS on a semi-regular basis.

#### V_SUM_LAB_SAMPLES

This view returns the summary of laboratory records (From D_INTERVAL_TEMPORAL_1A/1B) for all intervals.  The range of dates is indicated as is the number of samples as well as the number of individual values.

#### V_SUM_LOC_TYPE_COUNTS

This view returns the total number of locations by location type (see R_LOC_TYPE_CODE) as found in D_LOCATION.  Note that empty location types will be indicated.  This view is used to (partially) populate D_VERSION_STATUS on a semi-regular basis.

#### V_SUM_READING_GROUP_COUNTS

This view returns the total number of readings by reading group code (see R_RD_NAME_CODE and R_READING_GROUP_CODE) as found in D_INTERVAL_TEMPORAL_1B and D_INTERVAL_TEMPORAL_2.  The source for the particular record (i.e. from which of the temporal tables) is indicated by a '(DIT1)' or '(DIT2)' being appended to the reading group name.  Note that empty reading groups will not be indicated.  This view is used to (partially) populate D_VERSION_STATUS on a semi-regular basis.

This view should also be used as a quality check with regard to the appropriateness of data records residing in a particular temporal table (e.g. water level records should not occur in D_INTERVAL_TEMPORAL_1A/1B).

#### V_SUM_SCREEN_COUNTS

This view returns the number of screens by screen type present in the database.  Note that D_INTERVAL_MONITOR is used to delimit the intervals instead of reliance upon the INT_TYPE_CODE.

#### V_SUM_STATION_CLIMATE_PRECIP

This view returns the total precipitation (and record count) by year for each interval.  Note that only those records with an RD_NAME_CODE of '551' (i.e. 'Precipitation - Daily Total') will be included.  The source data is found in D_INTERVAL_TEMPORAL_3.

#### V_SUM_STATION_CLIMATE_RAINFALL

This view returns the total rainfall (and record count) by year for each interval.  Note that only those records with an RD_NAME_CODE of '549' (i.e. 'Rainfall (Daily Total)') will be included.  The source data is found in D_INTERVAL_TEMPORAL_3.

#### V_SUM_STATION_CLIMATE_SNOWFALL

This view returns the total snowfall (and record count) by year for each interval.  Note that only those records with an RD_NAME_CODE of '550' (i.e. 'Snowfall (Daily Total)') will be included.  The source data is found in D_INTERVAL_TEMPORAL_3.

#### V_SUM_STATION_CLIMATE_TEMP

This returns the minimum, maximum and average temperature (as well as the record count) by year for each interval.  Note that only those records with an RD_NAME_CODE of '548' (i.e. 'Temperature (Air) - Daily Mean') will be included.  The source data is found in D_INTERVAL_TEMPORAL_3.

#### V_SUM_SURFACE_WATER_FIELD

This view returns the yearly minimum, maximum and record count values for LOC_TYPE_CODE '6' (i.e. 'Surface Water') and the interval types (INT_TYPE_CODE)

* Surface Water Flow Gauge ('4')
* Surface Water Spot Flow ('10')
* Surface Water Spot Stage Elevation ('14')

Note that this does not include the any of the calculated baseflow RD_NAME_CODE's (i.e. codes '1002' through '1013').  If multiple UNIT_CODE's occur in the database, these will appear as multiple rows.

#### V_VL_BOREHOLES

This view returns the information necessary for Viewlog to plot and interact with boreholes when working with cross-sections.

#### V_VL_GEO_GSC

This view returns the information necessary or Viewlog to plot and interact with boreholes when working with cross-sections.  In particular, the GSC interpreted description of the geologic layer material (as well as its top and bottom elevations) are returned.  This description is converted to uppercase.

#### V_VL_GEO_MAT123

This view returns the information necessary for Viewlog to plot and interact with boreholes when working with cross-sections.  This is similar to V_VL_GEOLOGY with the exception that the GSC description is included (if available).  Additional fields are included from D_GEOLOGY_LAYER.

#### V_VL_GEOLOGY

This view returns the information necessary for Viewlog to plot and interact with boreholes when working with cross-sections.  In particular, the three possible materials for each geologic layer as well as their top and bottom elevations are returned.  The descriptive text is converted to uppercase.  

#### V_VL_HEADER_LOG

This view returns the information necessary for Viewlog to plot and interact with boreholes.  In particular, this view is used to populate a single borehole page for inclusion in reports.

#### V_VL_HEADER_SCREEN

This view returns the information necessary for Viewlog to plot and interact with boreholes when working with cross-sections.  In particular, top and bottom elevations for screens are returned for applicable locations; the TEXT field (name) must be populated with 'SCREEN'.

*Last Modified: 2022-11-04*
