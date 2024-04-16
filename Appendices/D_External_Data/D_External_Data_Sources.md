---
title:  "Appendix D"
author: "ormgpmd"
date:   "20240416"
output: html_document
knit:   (
            function(input_file, encoding) {
                out_dir <- '';
                rmarkdown::render(
                    input_file,
                    encoding=encoding,
                    output_file=file.path(dirname(input_file), out_dir,
                    'D_External_Data_Sources.html')
                )
            }
        )
---

## Appendix D - External Data Sources

The following sources have been used for adding a variety of information into
the database.  This is not to be taken as an exhaustive list as it generally
only includes moderately large datasets.  Both locations and temporal data
additions are indicated.

For the summary tables, the following fields are populated:

##### *DATA_ID*

The numeric identifier used to link datasets to data records within the
database.

##### *RCOUNT*

The number of records attributable to the specific data source for the
particular source table (e.g. number of locations, number of records of
chemistry data, etc...).

##### *DATA_TYPE*

A text description of the base type of information loaded.

##### *DATA_DESCRIPTION*

A description of the data source (dataset) loaded into the database.  This
should generally indicate the primary source.

##### *DATA_COMMENT*

Additional information concering the data source or dataset loaded ino the
database.  

##### *DATA_FILENAME*

The original file name of the data source or dataset previously to be loaded
into the database.

##### *DATA_ADDED_DATE*

The added date of the data source or dataset.  If this does not match (or is
close to) the date in SYS_TIME_STAMP it may indicate the dataset date.

##### *SYS_TIME_STAMP*

The date of the addition of the DATA_ID to the D_DATA_SOURCE table.  This may
have been added subsequent to the incorporation of the original data.

##### *SYS_USER_STAMP*

The user who added the DATA_ID to the D_DATA_SOURCE table.  This is usually
the same user who loaded the dataset.

### Appendix D.1 - Datasets Summary Page - Locations

[Summary table of moderately sized datasets (greater than 50 locations) used as
a data source (a PDF).](./DDS_Locations.pdf)

### Appendix D.2 - Specific Sources of Datasets - Locations

#### Environment Canada

##### Date: February 2004
##### Name: Climate Data
##### Source: Sandy Radecki - Burlington

##### Description 

Climate data up to the end of 2003 has been added to the database.  Included
is the following data, provided on a daily average basis:

1.	Precipitation
2.	Rain
3.	Snow on ground
4.	Maximum, minimum and average temperature
5.	Solar radiation where available

##### Details	

Approximately 560 climate stations are listed in the database, 517 operated by Environment Canada, and the remaining 43 operated by CA and other agencies.  Locations are shown in the following figure.  Climate stations are identified in the database using a LOC_TYPE_CODE of 9 in the D_LOCATION table.  

#### Geological Survey of Canada Data

##### Date: August 2004
##### Name: Outcrops
##### Source: Dave Sharpe's ORM database, August 2004 version from Charles Logan

##### Description	

Outcrops mapped by the GSC and the OGS where compiled into a database by the Terrain Science Group to complement their well log data for the ORM.  Outcrop data basically looks like well log data, with an X, Y and Z positions and a geological sequence.  The geological sequence can range from several centimeters to many meters in the case of large exposed faces.  Geological descriptions have, for the most part, been mapped into the MAT1,2,3 and 4 descriptions used in the database.

##### Details	

Approximately 30,000 outcrops have been added to the database, covering an
area from xx to yy.  Locations are shown in the following figure.  Outcrops
are identified in the database using a LOC_TYPE_CODE of 11 in the D_LOCATION
table.  A standard ORMGP view is provided in the database to display
information conncering these - V_GEN_BOREHOLE_OUTCROP.

#### MNR Surface Water Station Coordinates

##### Date: June 2004
##### Name: Updated UTM coordinates for MNR and EC stations
##### Source: MNR

##### Description	

The original Environment Canada coordinates were initially provided in digital lat long format with limited accuracy, resulting in stations not plotting on their assigned water course.  This has been updated using MNR GPS data.

#### MOE PTTW Database

##### Dates:

Mutliple import periods, including (with approximate dates):

* February, 2006
* August, 2015
* September, 2017
* May, 2020
* June, 2021

##### Description

The Ministry of Environments 'Permit to Take Water' (PTTW) datasets.

#### MOE South Simcoe Groundwater Study Data Files

##### Date: June 2004
##### Name: Dixon Hydrogeology database for MOE GW study
##### Source: Dixon Hydrogeology

##### Description

DHL released their updated project database for use in the ORMGP database.  Of value were several hundred new wells installed as monitoring wells by DHL during previous projects, and updated UTM coordinates for about 6000 MOE wells across Simcoe County

#### MOE WWDB (Water Well Database)

##### Dates:

Multiple import periods, including (with approximate dates):

* January, 2001
* April, 2006
* December, 2008
* November, 2009
* May and September, 2010
* April, 2014
* June, 2016
* September, 2017
* June, 2018
* May, 2019
* July, 2020
* January, 2021
* March, 2022

#### Scarborough Report

##### Date: April, 2011

##### Description

120 Wells in digital form from a project with between the University of
Toronto and the City of Scarborough (refer to Eyles and Doughty, 1996).

#### UGAIS Wells

##### Date: June 2004
##### Name: Geotechnical borehole data for urban areas
##### Source: GSC - MNR

##### Description	

UGAIS (Urban Geology Automated Information System) is a compilation of largely urban boreholes for major municipalities across Canada prepared by the GSC in the mid seventies.   Wells from Hamilton to Oshawa were added to the ORMGP database.  These wells are largely geotechnical investigation test holes, offering descriptive and accurate soil descriptions and blow counts.  Soil descriptions have be mapped into the standard look up fields of the D_GEOLOGY_LAYER table in the database.  The geological descriptions provided are based on the soils recovered in split spoon samples, and the depths provided were the depths of the split spoon sample.  

##### Details	

Approximately 33,200 geotechnical boreholes, with depths ranging from 0.1 m (soil sample) to in excess of 100 m were converted from ASCII format and appended to the database  These boreholes are identified in the database using a LOC_TYPE_CODE of 1 and DATA_SOURCE = 'ugais' in the D_LOCATION table.  A standard ORMGP query is provided in the database called ORMGP - Wells UGAIS.  The wells have been assigned as position certainly code of 3 (10 to 30 m), although as geotechnical borings, it is expected the accuracy may be greater, but this cannot be confirmed.  Only about 7,040 of the 33,200 include water level information.

### Appendix D.3 - Datasets Summary Page - Chemistry Records 

[Summary table of moderately sized datasets (greater than 500 records) used as a data source (a PDF).](./DDS_Chemistry.pdf)

### Appendex D.4 - Datasets Summary Page - Climate Records

[Summary table of datasets used as a data source (a PDF).](./DDS_Climate.pdf)

### Appendix D.5 - Datasets Summary Page - Field Records

[Summary table of moderately sized datasets (greater than 50000 records) used as a data source (a PDF).](./DDS_Field.pdf)

### Appendix D.6 - Datasets Summary Page - Surface Water Records

[Summary table of datasets used as a data source (a PDF).](./DDS_SW.pdf)

### Appendix D.7 - Datasets Summary Page - Pick Records

[Summary table of datasets (greater than 50000 records) used as a data source (a PDF).](./DDS_Picks.pdf)


*Last Modified: 2024-04-16*
