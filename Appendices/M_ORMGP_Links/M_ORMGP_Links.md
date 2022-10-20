---
title:  "Appendix M"
author: "ormgpmd"
date:   "20220825"
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

#### External Data Sources 

Summary: [https://owrc.github.io/interpolants/sources/sources.html](https://owrc.github.io/interpolants/sources/sources.html)

#### Analysis or Procedure

Hydrograph Explorer: [https://owrc.github.io/HydrographExplorerHelp/](https://owrc.github.io/HydrographExplorerHelp/)

Snowmelt Computation: [https://owrc.github.io/interpolants/modelling/waterbudget/data.html](https://owrc.github.io/interpolants/modelling/waterbudget/data.html#sub-daily-from-daily-snowmelt)

Automatic hydrograph separation: [https://owrc.github.io/info/hydrographseparation/](/info/hydrographseparation/)

Hydrograph disaggregation [https://owrc.github.io/interpolants/modelling/hydroparse.html](/interpolants/modelling/hydroparse.html)

Watershed characterization of the ORMGP region: [https://owrc.github.io/interpolants/interpolation/subwatershed.html](/interpolants/interpolation/subwatershed.html)

Watercourse Topology of the ORMGP Region: [https://owrc.github.io/interpolants/interpolation/watercourses.html](/interpolants/interpolation/watercourses.html)

Overland drainage pathways [https://owrc.github.io/interpolants/interpolation/overland.html](/interpolants/interpolation/overland.html)


#### Fact Sheets

Fact Sheet - Water Table Mapping: [https://owrc.github.io/watertable/](https://owrc.github.io/watertable/)

#### Metadata

The metadata master list can be accessed at: [https://owrc.github.io/metadata/content/toc.html](https://owrc.github.io/metadata/content/toc.html)

Potential Discharge Areas (Surface): [https://owrc.github.io/metadata/surfaces/potential_discharge.html](https://owrc.github.io/metadata/surfaces/potential_discharge.html)

Potentiometric Surface: [https://owrc.github.io/metadata/surfaces/potentiometric_surface.html](https://owrc.github.io/metadata/surfaces/potentiometric_surface.html)

Water Table (Surface): [https://owrc.github.io/metadata/surfaces/water_table.html](https://owrc.github.io/metadata/surfaces/water_table.html)

#### Other Information

Data Interpolation and Products: [https://owrc.github.io/interpolants/](https://owrc.github.io/interpolants/)

Data Snapshots: [https://owrc.github.io/snapshots/](https://owrc.github.io/snapshots/)

*Last Modified: 2022-08-25*
