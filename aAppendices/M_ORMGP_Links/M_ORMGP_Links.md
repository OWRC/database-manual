---
title:  "Appendix M"
author: "ormgpmd"
date:   "20260527"
output: html_document
knit:   (
            function(input_file, encoding) {
                out_dir <- '';
                rmarkdown::render(
                    input_file,
                    encoding=encoding,
                    output_file=file.path(dirname(input_file), out_dir,
                    'M_ORMGP_Links.html')
                )
            }
        )
---

## Appendix M - ORMGP Analyses, Metadata and Other Links

#### Analysis or Procedure

Automatic Hydrograph Separation: [https://owrc.github.io/info/hydrographseparation/](/info/hydrographseparation/)

Hydrograph Explorer: [https://owrc.github.io/HydrographExplorerHelp/](https://owrc.github.io/HydrographExplorerHelp/)

Overland Drainage Pathways [https://owrc.github.io/interpolants/interpolation/overland.html](/interpolants/interpolation/overland.html)

Snowmelt Computation: [https://owrc.github.io/interpolants/modelling/waterbudget/data.html](https://owrc.github.io/interpolants/modelling/waterbudget/data.html#sub-daily-from-daily-snowmelt)

Watercourse Topology of the ORMGP Region: [https://owrc.github.io/interpolants/interpolation/watercourses.html](/interpolants/interpolation/watercourses.html)

#### External Data Sources and Other Information

Summary: [https://owrc.github.io/metadata/content/toc.html](https://owrc.github.io/metadata/content/toc.html)

Note that the Metadata links, found here, may replicate some of those found on
this page.

Data Interpolation and Products: [https://owrc.github.io/interpolants/](https://owrc.github.io/interpolants/)

Data Snapshots: [https://owrc.github.io/snapshots/](https://owrc.github.io/snapshots/)

#### Fact Sheets

Fact Sheet - Water Table Mapping: [https://owrc.github.io/watertable/](https://owrc.github.io/watertable/)

#### Metadata

An additional metadata list can be accessed at: [https://owrc.github.io/metadata/content/toc.html](https://owrc.github.io/metadata/content/toc.html)

Potential Discharge Areas (Surface): [https://owrc.github.io/metadata/surfaces/potential_discharge.html](https://owrc.github.io/metadata/surfaces/potential_discharge.html)

Potentiometric Surface: [https://owrc.github.io/metadata/surfaces/potentiometric_surface.html](https://owrc.github.io/metadata/surfaces/potentiometric_surface.html)

Water Table (Surface): [https://owrc.github.io/metadata/surfaces/water_table.html](https://owrc.github.io/metadata/surfaces/water_table.html)

*Last Modified: 2026-05-27*
