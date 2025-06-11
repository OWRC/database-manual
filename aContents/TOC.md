---
title:  "Cover and Table of Contents"
author: "ormgpmd"
date:   "20250611"
output: html_document
knit:   (
            function(input_file, encoding) {
                out_dir <- '';
                rmarkdown::render(
                    input_file,
                    encoding=encoding,
                    output_file=file.path(dirname(input_file), out_dir,
                    'TOC.html')
                )
            }
        )
---

![Cover Page](/database-manual/aCover/cover.png)

## Table of Contents

### [Forward](/database-manual/aForward/Forward.html)

### **[Section 1 - Introduction](/database-manual/a01_Introduction/01_01-02_Overview_and_Background.html)**

* **1.0 Overview**
* **1.1 Background**
* **1.2 Database Versions**

### Section 2 - Understanding the ORMGP Database

* **[2.1 Tables and Views](/database-manual/a02_Understanding_ORMGP_Database/02_01_Tables_and_Views/02_01_Tables_and_Views.html)**

    + **[2.1.1 Data Tables (D_\*)](/database-manual/a02_Understanding_ORMGP_Database/02_01_Tables_and_Views/02_01_01_Data_Tables.html)**
    + **[2.1.2 Reference Tables (R_\*)](/database-manual/a02_Understanding_ORMGP_Database/02_01_Tables_and_Views/02_01_02_Reference_Tables.html)**
    + **[2.1.3 Other Tables](/database-manual/a02_Understanding_ORMGP_Database/02_01_Tables_and_Views/02_01_03_Other_Tables.html)**

<!--
    + **[2.1.4 Views Outline](/database-manual/02_Understanding_ORMGP_Database/02_01_Tables_and_Views/02_01_04_Views.html)**
    + **[2.1.5 Main Views (V_\*)](/database-manual/02_Understanding_ORMGP_Database/02_01_Tables_and_Views/02_01_05_Main_Views.html)**
    + **[2.1.6 System Views (V_SYS_\*)](/database-manual/02_Understanding_ORMGP_Database/02_01_Tables_and_Views/02_01_06_System_Views.html)**
-->

* **[2.2 General Overview of Relationships](/database-manual/a02_Understanding_ORMGP_Database/02_02_General_Overview_of_Relationships/02_02_General_Overview_of_Relationships.html)**

* **2.3 Primary Data Relationships**

    + **[2.3.1 MOE Records](/database-manual/a02_Understanding_ORMGP_Database/02_03_Primary_Data_Relationships/02_03_01_MOE_Records.html)**
    + **[2.3.2 Consultant Borehole Records](/database-manual/a02_Understanding_ORMGP_Database/02_03_Primary_Data_Relationships/02_03_02_Consultant_Report.html)**
    + **[2.3.3 Grain Size Data](/database-manual/a02_Understanding_ORMGP_Database/02_03_Primary_Data_Relationships/02_03_03_Grain_Size.html)**
    + **[2.3.7 Report Library (Documents)](/database-manual/a02_Understanding_ORMGP_Database/02_03_Primary_Data_Relationships/02_03_07_Report_Library.html)**
    + **[2.3.8 Permit To Take Water](/database-manual/a02_Understanding_ORMGP_Database/02_03_Primary_Data_Relationships/02_03_08_PTTW.html)**

<!--
    + **[2.3.4 Chemistry Data](/database-manual/02_Understanding_ORMGP_Database/02_03_Primary_Data_Relationships/02_03_04_Chemistry.html)**
    + **[2.3.5 Water Level Data](/database-manual/02_Understanding_ORMGP_Database/02_03_Primary_Data_Relationships/02_03_05_Water_Level.html)**
    + **[2.3.6 Climate Station Data](/database-manual/02_Understanding_ORMGP_Database/02_03_Primary_Data_Relationships/02_03_06_Climate_Station.html)**
    + **[2.3.9 HYDAT and Spotflow Data](/database-manual/02_Understanding_ORMGP_Database/02_03_Primary_Data_Relationships/02_03_09_HYDAT.html)**

* **[2.4 Secondary (or Derived) Data Relationships)](/database-manual/02_Understanding_ORMGP_Database/02_04_Secondary_Data_Relationships/02_04_Secondary_Data_Relationships.html)**

    + **2.4.1 Formation Assignment**
    + **2.4.2 Elevations**
    + **2.4.3 Geologic Picks**
    + **2.4.4 Baseflow Estimation**
    + **2.4.5 Specific Capacity, Transmissivity and Hydraulic Conductivity**

* **[2.5 Locations, Groups and Study Areas](/database-manual/02_Understanding_ORMGP_Database/02_05_Locations_Groups_and_Study_Areas/02_05_Locations_Groups_and_Study_Areas.html)**

* **[2.6 Report Library](/database-manual/02_Understanding_ORMGP_Database/02_06_Report_Library/02_06_Report_Library.html)**

    + **2.6.1 Document Association**
    + **2.6.2 Directory and Files, Naming and Structure**
    + **2.6.3 Report Entry**

* **[2.7 Multi-Screen Installations](/database-manual/02_Understanding_ORMGP_Database/02_07_Multi-Screen_Installations/02_07_Multi-Screen_Installations.html)**

* **[2.8 Multi-Borehole Records](/database-manual/02_Understanding_ORMGP_Database/02_08_Multi-Borehole_Records/02_08_Multi-Borehole_Records.html)**

### Section 3 - Practical Applications

* **3.1 Working with the Database**

    + **[3.1.1 General Database Access](/database-manual/03_Practical_Applications/03_01_Working_with_the_Database/03_01_01_Database_Access.html)**
    + **[3.1.2 Microsoft Access](/database-manual/03_Practical_Applications/03_01_Working_with_the_Database/03_01_02_MS_Access.html)**
    + **[3.1.3 Microsoft SQL Management Studio](/database-manual/03_Practical_Applications/03_01_Working_with_the_Database/03_01_03_MSSQLMS.html)** 
    + **[3.1.4 Microsoft Excel](/database-manual/03_Practical_Applications/03_01_Working_with_the_Database/03_01_04_MS_Excel.html)**
    + **[3.1.5 SiteFX](/database-manual/03_Practical_Applications/03_01_Working_with_the_Database/03_01_05_SiteFX.html)**
    + **[3.1.6 Viewlog](/database-manual/03_Practical_Applications/03_01_Working_with_the_Database/03_01_06_Viewlog.html)**

* **[3.2 Training Exercises](/database-manual/03_Practical_Applications/03_02_Training_Exercises/03_02_Training_Exercises.html)**

* **3.3 Guidelines and FAQ**

    + **[3.3.1 Naming Conventions](/database-manual/03_Practical_Applications/03_03_Guidelines_and_FAQ/03_03_01_Naming_Conventions.html)**
    + **[3.3.2 Quality Assurance (QA) and Quality Control (QC)](/database-manual/03_Practical_Applications/03_03_Guidelines_and_FAQ/03_03_02_QA-QC.html)**
    + **[3.3.3 Data Source Tracking](/database-manual/03_Practical_Applications/03_03_Guidelines_and_FAQ/03_03_03_Data_Source_Tracking.html)**
    + **[3.3.4 Frequently Asked Questions (FAQ)](/database-manual/03_Practical_Applications/03_03_Guidelines_and_FAQ/03_03_04_FAQ.html)**

* **3.4 Adding New Data**

    + **[3.4.1 Locations - Mandatory Fields](/database-manual/03_Practical_Applications/03_04_Adding_New_Data/03_04_01-06_Guidelines.html)**
    + **[3.4.2 Geologic Information](/database-manual/03_Practical_Applications/03_04_Adding_New_Data/03_04_01-06_Guidelines.html)**
    + **[3.4.3 Hydraulic Properties](/database-manual/03_Practical_Applications/03_04_Adding_New_Data/03_04_01-06_Guidelines.html)**
    + **[3.4.4 Geophysical Logging](/database-manual/03_Practical_Applications/03_04_Adding_New_Data/03_04_01-06_Guidelines.html)**
    + **[3.4.5 Temporal Data](/database-manual/03_Practical_Applications/03_04_Adding_New_Data/03_04_01-06_Guidelines.html)**
    + **[3.4.6 Data Validation and Conversion](/database-manual/03_Practical_Applications/03_04_Adding_New_Data/03_04_01-06_Guidelines.html)**
    + **[3.4.7 Adding New Data - Methods](/database-manual/03_Practical_Applications/03_04_Adding_New_Data/03_04_07_Methods.html)**
    + **[3.4.8 Data Selection](/database-manual/03_Practical_Applications/03_04_Adding_New_Data/03_04_08_Data_Selection.html)**

* **[3.5 Changes to Existing Data](/database-manual/03_Practical_Applications/03_05_Changing_Existing_Data/03_05_Changing_Existing_Data.html)**

### Section 4 - Technical

* **[4.1 Detailed Overview of Relationships](/database-manual/04_Technical/04_01_Detailed_Relationships/04_01_Detailed_Relationships.html)**

* **4.2 Table Details (D_\*, R_\* and Other)**

* **4.3 View Details (V_\*)**

* **[4.4 Database Distribution](/database-manual/04_Technical/04_04_Database_Distribution/04_04_Database_Distribution.html)**

* **[4.5 Background Processing and Updates](/database-manual/04_Technical/04_05_Background_Processing_Updates/04_05_Background_Processing_Updates.html)**

-->

### [References](/database-manual/aReferences/References.html)

### Appendices

<!--

* **[A - Basic Outline and Use of Structured Query Language (SQL)](/database-manual/Appendices/A_SQL_Outline/A_SQL_Outline.html)**

* **[B - Soil Classification Systems and Translation of Geologic Layers](/database-manual/Appendices/B_Soil_Classification/B_Soil_Classification.html)**

* **[C - Baseflow Estimation](/database-manual/Appendices/C_Baseflow/C_Baseflow_Estimation.html)**

* **[D - External Data Sources](/database-manual/Appendices/D_External_Data/D_External_Data_Sources.html)**

    + **D.1 Datasets Summary Page - Locations**
    + **D.2 Specific Sources of Datasets - Locations**
    + **D.3 Datasets Summary Page - Chemistry Records**
    + **D.4 Datasets Summary Page - Climate Records**
    + **D.5 Datasets Summary Page - Field Records**
    + **D.6 Datasets Summary Page - Surface Water Records**
    + **D.7 Datasets Summary Page - Pick Records**

-->

* **[E - ORMGP Database Schema Update](/database-manual/aAppendices/E_Database_Schema/E_Database_Schema.html)**

<!--

* **[F - Accessory ORMGP Databases](/database-manual/Appendices/F_Accessory_Databases/F_Accessory_Databases.html)**

* **G - Procedures**

    + **[G.1 Formation Assignment and Associated Calculations (Automated)](/database-manual/Appendices/G_Procedures/G_01.html)**
    + **[G.2 Update of D_LOCATION_GEOM (Automated)](/database-manual/Appendices/G_Procedures/G_02.html)**
    + **[G.3 Report Library - Addition](/database-manual/Appendices/G_Procedures/G_03.html)**
    + **[G.4 Ground Elevation Assignment](/database-manual/Appendices/G_Procedures/G_04.html)**
    + **[G.5 Correction of Bedrock Wells](/database-manual/Appendices/G_Procedures/G_05.html)**
    + **[G.6 Addition to/Population of D_LOCATION_AGENCY (REPLACED)](/database-manual/Appendices/G_Procedures/G_06.html)**
    + **[G.7 Update of Bedrock Elevation (Automated)](/database-manual/Appendices/G_Procedures/G_07.html)**
    + **[G.8 Assignment of MOE Elevations as Original Elevations](/database-manual/Appendices/G_Procedures/G_08.html)**
    + **[G.9 Correction of Datalogger Information (DESCRIPTION NEEDED)](/database-manual/Appendices/G_Procedures/G_09.html)**
    + **[G.10 Import of MOE Water Well Database](/database-manual/Appendices/G_Procedures/G_10.html)**
    + **[G.11 Correction of D_GEOLOGY_LAYER - Missing Depths and Units](/database-manual/Appendices/G_Procedures/G_11.html)**
    + **[G.12 Creation of the TRAINING database (REPLACED)](/database-manual/Appendices/G_Procedures/G_12.html)**
    + **[G.13 Synchronizing non-replicating databases (REPLACED)](/database-manual/Appendices/G_Procedures/G_13.html)**
    + **[G.14 Population of coordinates (REVIEW)](/database-manual/Appendices/G_Procedures/G_14.html)**
    + **[G.15 Synchronize elevations between D_BOREHOLE and D_LOCATION_ELEV (REVIEW)](/database-manual/Appendices/G_Procedures/G_15.html)**
    + **[G.16 Check D_INTERVAL_FORMATION_ASSIGNMENT for Invalid (Null) Rows](/database-manual/Appendices/G_Procedures/G_16.html)**
    + **[G.17 Correction of elevations (D_BOREHOLE and D_LOCATION_ELEV) (REVIEW)](/database-manual/Appendices/G_Procedures/G_17.html)**
    + **[G.18 Extracting LOC_IDs for the Training database](/database-manual/Appendices/G_Procedures/G_18.html)**
    + **[G.19 Addition of INT_ID to D_INTERVAL_FORMATION_ASSIGNMENT (REPLACED)](/database-manual/Appendices/G_Procedures/G_19.html)**
    + **[G.20 Calculate and Incorporate Specific Capacity (REPLACED)](/database-manual/Appendices/G_Procedures/G_20.html)**
    + **[G.21 Perform QA/QC Check Against OAK_20120615_MASTER Backup (REPLACED)](/database-manual/Appendices/G_Procedures/G_21.html)**
    + **[G.22 Incorporation of the MOE Permit-To-Take-Water database (REVIEW)](/database-manual/Appendices/G_Procedures/G_22.html)**
    + **[G.23 Population of D_INTERVAL_MONITOR (Top and Bottom)](/database-manual/Appendices/G_Procedures/G_23.html)**
    + **[G.24 Update D_INTERVAL_MONITOR Depths (REPLACED)](/database-manual/Appendices/G_Procedures/G_24.html)**
    + **[G.25 Correction of Water Levels and Associated Data (REVIEW)](/database-manual/Appendices/G_Procedures/G_25.html)**
    + **[G.26 Correction or Update of Borehole Coordinates (MOE WWDB)](/database-manual/Appendices/G_Procedures/G_26.html)**
    + **[G.27 York Database - Incorporation of Temporal Data](/database-manual/Appendices/G_Procedures/G_27.html)**
    + **[G.28 Updating Elevations in D_* tables](/database-manual/Appendices/G_Procedures/G_28.html)**
    + **[G.29 Update MOE BORE_HOLE_ID (D_LOCATION_ALIAS)](/database-manual/Appendices/G_Procedures/G_29.html)**
    + **[G.30 Update Locations from MOE WWDB](/database-manual/Appendices/G_Procedures/G_30.html)**
    + **[G.31 Incorporate D_LOCATION_COORD_HIST and D_LOCATION_ELEV_HIST Records in D_LOCATION_SPATIAL_HIST](/database-manual/Appendices/G_Procedures/G_31.html)**
    + **[G.32 Automated Scripts (Listing and Calling Order)](/database-manual/Appendices/G_Procedures/G_32.html)**
    + **[G.33 Update of D_AREA_GEOM](/database-manual/Appendices/G_Procedures/G_33.html)**
    + **[G.34 Incorporation of Bedrock Elevations as Bedrock Picks](/database-manual/Appendices/G_Procedures/G_34.html)**
    + **[G.35 Handling Temporal Data Duplicates](/database-manual/Appendices/G_Procedures/G_35.html)**

* **[H - Current Problems (to be Corrected)](/database-manual/Appendices/H_Current_Problems/H_Current_Problems.html)**

* **[I - Training Setup and Access](/database-manual/Appendices/I_Training_Setup/I_Training_Setup.html)**

    + **I.1 Citrix XenDesktop**
    + **I.2 Geocortex**

* **J - Training Exercises**

    + **[J.1 Training Exercises - Easy](/database-manual/Appendices/J_Training_Exercises/J_1_Easy.html)**
    + **[J.2 Training Exercises - Moderate](/database-manual/Appendices/J_Training_Exercises/J_2_Moderate.html)**
    + **[J.3 Training Exercises - Difficult](/database-manual/Appendices/J_Training_Exercises/J_3_Difficult.html)**

* **[K - Alternate Software Instructions](/database-manual/Appendices/K_Alternate_Software/K_Alternate_Software.html)**

* **[L - Database Reports](/database-manual/Appendices/L_Database_Reports/L_Database_Reports.html)**

* **[M - ORMGP Analyses, Metadata and Other Links](/database-manual/Appendices/M_ORMGP_Links/M_ORMGP_Links.html)**

-->

*Last modified: 2025-06-11*
