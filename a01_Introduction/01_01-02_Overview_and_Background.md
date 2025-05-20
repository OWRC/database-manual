---
title:  "Section 1.0"
author: "ORMGP"
date:   "20250520"
output: html_document
knit:   (
            function(input_file, encoding) {
                out_dir <- '';
                rmarkdown::render(
                    input_file,
                    encoding=encoding,
                    output_file=file.path(dirname(input_file), out_dir, 
                    '01_01-02_Overview_and_Background.html')
                )
            }
        )
---

## Section 1.0 Overview

This document has been created to provide information pertaining to the  Oak
Ridges Moraine Groundwater Program (ORMGP) database and the underlying data
model.  Specifically the document provides:

* Information on what is contained within the database 
* Technical details describing how information is contained within the 
  database 
* Direction on where to find the varying types of information and the 
  methodology to do so
* Guidelines regarding consistent procedures and standards that should be
  followed when editing existing or adding new data into the database

This document should provide a user with a sufficient background in relational
databases (and the ORMGP data model in particular) to allow navigation and
extraction of information.  From a broader perspective, the ORMGP data model
and the management of the database can serve as an example to other
orgnaizations (whether at the municipal, provincial or national scales).
A central theme in the overall database design and management is the balance 
between relational theory and the capacity and needs of users.  Currently, the 
database has numerous users from the various partner regions, partner 
conservation authorities and consulting partners.

More general background information regarding databases and data models (not
specific to the ORMGP database) is included in two preceding database reports,
namely EarthFX (2003) and YPDT-CAMC (2006), and is not repeated here.  It is 
the intent of ORMGP staff to periodically refine and update this document over
time to reflect either feedback from the partner agencies or incremental
changes in the underlying structure (and content) of the database.  This
document specifically applies to Database Version 8 and is a complete
replacement of the previous database manual version (i.e. Database Version 7
and before).

The ultimate goal of ORMGP data management is to maintain a water
management database system that is reliable, up to date and relatively easy to
use.  The guiding philosophy for the ORMGP database can be summarized as

*One piece of absolutely reliable data is far better than a million pieces of
unreliable data.*

### Database Contents

The database contains information that can be grouped into three broad
headings:

1. Geology and Groundwater Related Locations
    + Borehole Records (location, depth, drill date, etc...) including: MOE
      well records (geology, water levels, well construction, etc...);
      geotechnical boreholes (geology, water levels, soil properties); oil and
      gas wells (geology); consultant drilled wells from previous studies
      (geology, water levels, well construction, etc...)
    + Picks - the geological layer picks for each well (used to construct surfaces); 
    + Outcrops (sedimentological sections and bedrock outcrops) - only geology;
    + Geophysical logs from key wells;
    + Screened formation assignment (a screened interval has been assigned to
      one of the geological units); 
    + Temporal data (water levels, pumping rates, water quality, etc...)
    + MOE PTTW records with some linkage to source locations
    + MOE EASR records

2. Surface Water Related Locations
    + MOE PTTW records (from surface water sources)
    + MOE PWQMN records (from surface water sources)
    + Temporal Data (including daily discharge from continuous gauges - HYDAT
      stations or other - or instantaneous discharge from various low
      streamflow - baseflow - surveys)

3. Climate Related Locations
    + Temporal Data (daily temperature, rain, snow and total precipitation
      from Environment Canada stations or other locations)

4. Library of Scanned Reports/Papers
    + Technical reports as well as scientific articles/papers have been
      scanned and converted to PDF
    + These file are not stored within the database but are accessible through
      the ORMGP website
    + Details of these reports are stored within the document and related
      tables within the database

A few key points should be highlighted:

* the data coverage is not necessarily uniform over the entire area of study
  (e.g. the City of Toronto has many more geotechnical records as a result of
  the City having captured these in a database many years ago);
* throughout the document the terms borehole and well are used interchangeably
  (the database does not distinguish between the two);
* responsibility for maintaining and updating the database in a reliable
  manner and to check data prior to (and after) incorporation into the database 
  is a shared responsibility between all users.

## Section 1.1 Background

In 1999, the Regional Municipalities of York, Peel, Durham, the City of
Toronto (YPDT), and their associated six Conservation Authorities (Credit
Valley; Toronto and Region; Lake Simcoe and Region; Central Lake Ontario;
Kawartha; and Ganaraska) formed a cooperative alliance for addressing
groundwater issues within the collective geographical area of all partnered
agencies.  In addition to these partners, three additional conservation
authorities (Otonabee, Lower Trent, and Nottawasaga) also having jurisdiction
on portions of the Oak Ridges Moraine


, through the Conservation Authorities
Moraine Coalition (CAMC) have also supported the development of the technical
tools that have been developed for groundwater management.  The study area is
shown in Figure 1.1.  At the request of the Source Water Protection project
managers, the area was expanded slightly in recent years to incorporate more
northerly areas to assist with Source Water Protection Planning.

![*Figure 1.1.1 Oak Ridges Moraine Groundwater Management Program study area
displayed with a 25km boundary buffer; the Oak Ridges Moraine is also
shown.*](f01_01_01_study_area.png)*Figure 1.1.1 Oak Ridges Moraine
Groundwater Managment Program study area displayed with a 25km boundary
buffer; the Oak Ridges Moraine is also shown.*

Since its inception in 1999 the project has transitioned through what can be
identified as three stages: A

* Stage 1 - 1999 to 2001 - this stage of work was undertaken by a consultant
  team and was focused on identifying issues related to groundwater management
  and protection.  The work culminated in a report (AMEC Earth and
  Environmental et al, 2001) that documented some of the groundwater work
  taking place in other jurisdictions across Canada and the U.S.  The report
  also inventoried and prioritized areas and issues to be considered for
  additional work.

* Stage 2 - 2001 to 2008 -  this stage of work has been characterized by
  developing and building an analysis system that includes several well
  defined tools required for understanding and managing the groundwater flow
  system across the area (e.g. database, digital geology, groundwater flow
  model). 

* Stage 3 - 2008 and onward - This stage of work to date has focused on
  implementing the tools to assist in various groundwater studies that have
  arisen, as well as on infilling geological and hydrogeological data gaps and
  on maintaining and updating the available tools and database.

* Stage 4 - 2016 and onward - This stage has focused on ease-of-access to the
  database and other products, concentrating on web/internet access and
  dissemination of data.  This is to be applied to both public and Partner
  access.

* Stage 5 - 2025 and onward - An update of the database schema with a review
  of existing tables and views has been undertaken.  

### Program Mandate

The program was initially established in 2000 recognizing that effective
protection and management of groundwater resources require an adequate
information base and coordinated practices and policies.  The intent of the
groundwater management strategy at the time was to ensure co-ordination and
consistency in approaches, policies and practices across the regions and
conservation authorities such that common goals and objectives could be met.
At the time a series of objectives were laid out that spoke to the need to
protect and/or restore various groundwater based functions (e.g. sustainable
use of groundwater, habitat, stream form, assimilative capacity, etc...).  It
was also recognized early on that protection, restoration and management of
the groundwater flow system first required that an adequate level of
understanding be acquired.  In 2001, the program was steered in this
direction.

In 2004 the program developed a Governance Document entitled *Towards a
Sustained Long Term Program* that set out a structure and future direction for
the program, recognizing that coordination of the work of the partnership and
that of the individual agencies was critical for success.  In 2007 a second
document, *Overview of Operations and Future Planning*, was prepared
and outlined six areas where the partnership could coordinate efforts:
database management; data collection; technical analyses (geology and
groundwater flow modeling); planning and policy initiatives;
provincial/federal funding; and education.  

The report set the following agreed upon mandate:

*The YPDT-CAMC Groundwater Management Program partnership can be summarized as
to provide a multi-agency, collaborative approach to collecting, analyzing and
disseminating water resource data as a basis for effective stewardship of
water resources.  The YPDT-CAMC Groundwater Management Program is to build,
maintain and provide to partnered agencies the regional geological and
hydrogeological context for ongoing groundwater studies and management
initiatives within the partnership area.*

As such the program will: 

1. Build and maintain a master database of water related information that is
   accessible to all partner agencies.
2. Build and maintain a digital geological construction of the subsurface
   layers that is accessible to all partner agencies.
3. Build and maintain a numerical groundwater flow model that can be used to
   address any number of issues that arise at any of the partner agencies.
4. Coordinate and lead investigations that will acquire new field data that
   will strategically infill key data gaps.
5. Provide technical support to Source Water Protection Teams to ensure that
   interpretations used in source water are consistent with the regional
   understanding.
6. Provide technical support to planning authorities to ensure that Official
   Plan policies are developed in a manner which makes them consistent with
   up-to-date groundwater science as derived from the project. 
7. Provide technical support to all partnered agencies for addressing other
   Provincial legislation.

The desired outcome from the partnership project is significantly improved
water management decisions.

## Section 1.2 Database Versions and Current Status

The following is a summary of the *official* versions of the ORMGP (previously
the YPDT-CAMC) database since the inception of the program in 2001.  In
addition, a high level overview of significant changes and additions to the database
over time is provided.  A more detailed outline is found in Appendix E of the
previous version of this manual (i.e. *ORMGP Database Manual, Version 7
(2022)*).

### Database Release 1

* Date: 2002 - 2003
* Database Type: Microsoft Access
* Documentation: EarthFX (2003) Data Management System, 2002 Report.
* Major Components include: 
    + MOE data (to December 2000); 
    + ORM location updates (from Hunter); 
    + City of Toronto boreholes
* Release: used by the YPDT-CAMC Group and released to Partner Agencies (2002 
  through 2003)

### Database Release 2

* Date: October 2004
* Database Type: Microsoft Access
* Documentation: EarthFX (2005) Database Release Report Addendum.
* Major Additions/Changes include: 
    + MOE update (to June 2003); 
    + GSC data;
    + UGAIS geotechnical wells; 
    + Environment Canada climate and streamflow data
* Release: Database released along with geological surfaces (the Core
  Model and Regional Model layers) as a combined package (2004)

### Database Release 3

* Date: April 2006
* Database Type: Microsoft Access
* Documentation: YPDT-CAMC (2006) Database Manual, September 2006.
* Major Additions/Changes include: 
    + Update of GSC data; 
    + Addition of oil and gas wells; 
    + Inclusion of geophyscial logs; 
    + Update of Environment Canada climate and streamflow data
* Release: May to July 2006, Database release included an updated 
geologic model (extending from the CVC, above the escarpment, to east 
of the Durham Region)

### Database Release 4

* Date: Unreleased - incorporated into Database Release 5, described below
* Database Type:  No specific documentation on this work
* Major Additions and Changes include: 
    + Corrections to individual boreholes; 
    + Addition of new boreholes tied to construction projects (e.g.  York
      sewer projects); 
    + Addition of temporal pumping and water level data (stored as Binary
      Large Objects - BLOBs);
    + York Region monitoring data (including some reconciliation of monitoring
      locations and addition of pumping rates and water levels to October 2006;
      completed in November 2006; duplicates for some York wells still in
      database)
    + York Region Monitoring data (some reconciliation of York monitoring
      locations and addition of pumping rates and water levels to Oct 2006 -
      completed in Nov 2006 (Duplicate locations for some York wells still in
      database)
    + Addition of 8,470 MOE wells and miscellaneous new consultant wells
    + Addition of Halton area MOE wells to the west; note that at this time
      EFX created a separate Halton/Hamilton database that covers the Source
      Water Protection area - the YPDT database did not include the wells added
      by Halton CA under a program with the Ontario Geological Survey;
    + Incorporation of 236 Durham Region high quality monitoring wells - this
      created some duplicates of these wells within the database
* Release: Unreleased, used internally by the YPDT-CAMC group

### Database Release 5

* Dated Version: 20120615
* Date: June 6, 2012
* Database Type: Microsoft SQL Server 2008 (or 2005; see Comments, below)
* Documentation: YPDT-CAMC (2014) Database Manual Version 4.
* Major Additions and Changes
    + Incorporation of scanned library reports/papers (previously separate);
    + Incorporation of additional MTO boreholes
    + Addition of location grouping capability
    + Extraction of temporal data from BLOBs
    + Addition of formation assignment data based upon existing geologic models
    + Addition of historical chemistry data
    + Incorporation of Halton borehole data
    + Incorporation of geological picks
    + Addition of historical MOE water level monitoring data
    + Removal of most duplicate wells and water levels
* Release: June, 2012 through August, 2016
* Comments: This version incorporates all modifications necessary for
  conversion between Microsoft Access (MS Access) and Microsoft SQL Server
  2008 (MSSQL2008) and also includes structural changes to many existing
  tables and the addition of tables, fields, constraints, triggers, etc...
  Refer to Appendix E in ORMGP (2022) for detailed changes.

### Database Release 6

* Dated Version: 20160831
* Date: August 31, 2016
* Database Type: Microsoft SQL Server 2016 
* Documentation: YPDT-CAMC (2017) Database Manual Version 6.
* Major Additions and Changes
    + 20170524 - All climate station data has been moved to 
      D_INTERVAL_TEMPORAL_3
    + 20170922 - All streamflow data has been moved to D_INTERVAL_TEPORAL_5;
      all calculated baseflow information has been removed from the database
      (this is replaced by a web-based on-the-fly calculation)
* Release: August, 2016

### Database Release 7

* Dated Version: 20160831 (main schema)
* Secondary Dated Version: 20210901 (updated schema)
* Date: September 01, 2021
* Database Type: Microsoft SQL Server 2016
* Documentation: ORMGP (2022) Database Manual, Version 7.
* Major Additions and Changes
    + Centralized spatial tables binding coordinates and elevations together
      (along with associated quality assurance codes)
    + Interval formation assignment update (from earlier versions) and
      calculation of transmissivity and hydraulic conductivity values (by
      geologic model)
    + Inclusion of 'Knowledge-Based' locations
    + Many other modifications ...
* Release: September, 2021 through December, 2025

### Database Release 8

* Dated Version: 20250207 (main schema)
* Secondary Dated Version: 20250520 (updated schema)
* Date: TBD
* Database Type: Microsoft SQL Server 2022
* Documentation: ORMGP (2025) Database Manual, Version 8 (this document)
* Major Additions and Changes
    + Complete review and update of the original schema
* Release: TBD

The current distribution of all locations found within the database is shown
(Figure 1.2.1).

![*Figure 1.2.1 The spatial extents of the study area showing locations
(boreholes, climate stations, surface water stations, reports, etc...) currently
residing in the database.*](f01_02_01_locations.jpg)*Figure 1.2.1 The spatial
extents of the study area showing locations (boreholes, climate stations,
surface water stations, reports, etc...) currently residing in the database.*

*Last Modified: 2025-05-20*
