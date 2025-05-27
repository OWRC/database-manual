---
title:  "Section 2.2"
author: "ORMGP"
date:   "20250527"
output: html_document
knit:   (
            function(input_file, encoding) {
                out_dir <- '';
                rmarkdown::render(
                    input_file,
                    encoding=encoding,
                    output_file=file.path(dirname(input_file), out_dir,
                    '02_02_General_Overview_of_Relationships.html')
                )
            }
        )
---

## Section 2.2 General Overview of Relationships

The following tables provide the general relationship between the data tables
(i.e. those prepended with a *D_*) and the reference tables (prepended with a
*R_*) within the database (Table 2.2.1).  Additional web tables (prepended
with a *W_*) contain a weekly summary of information as found within the
database by location.  These are used as the source for all web-based mapping.

Note that, for the subsequent tables (i.e. Tables 2.2.2 through 2.2.4), any
listed key in the second *Key* column implies a change in the name of the
field between the related tables.

![Table 2.2.1 Table relationships between the data (D_) and web (W_) tables
using LOC_ID and INT_ID keys](t02_02_01_locns.png)*Table 2.2.1 Table
relationships between the data (D_) and web (W_) tables using LOC_ID and
INT_ID keys. Stand alone tables and their keys are listed*

![Table 2.2.2 Table relationships and associated keys for all data tables](t02_02_02_data.png)
*Table 2.2.2 Table relationships and associated keys for all data tables*

![Table 2.2.3 Table relationships and associated keys for all reference
tables](t02_02_03_ref.png)*Table 2.2.3 Table relationships and associated
keys for all reference tables*

![Table 2.2.4 Table relationships and associated keys for all system and web
tables](t02_02_04_sw.png)*Table 2.2.4 Table relationships and associated keys
for all system and web tables*

*Last Modified: 2025-05-27*
