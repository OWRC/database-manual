---
title:  "Section 2.8"
author: "ORMGP"
date:   "20250612"
output: html_document
knit:   (
            function(input_file, encoding) {
                out_dir <- '';
                rmarkdown::render(
                    input_file,
                    encoding=encoding,
                    output_file=file.path(dirname(input_file), out_dir,
                    '02_08_Multi-Borehole_Records.html')
                )
            }
        )
---

## Section 2.8 Multi-Borehole Wells (MOE)

Since 2003 the MOE has allowed consultants to provide only one well record for
a site upon which many boreholes may be drilled.  This option was provided so
that the geology, which may be similar at different boreholes located at the
same site, need only be submitted and entered into the Water Well Information
System (WWIS) once.  For these cases, within the WWIS, each borehole is given
a BORE_HOLE_ID (as found in the *tblBore_Hole* table) and they are all linked
using a single WELL_ID.  The *tblBore_Hole* table provides limited information
on each borehole including the UTM coordinates, the completion date and
whether the borehole is a bedrock or overburden well.

When transferred to the ORMGP database, each of these boreholes is given a
unique LOC_ID and are linked to the original MOE borehole WELL_ID through an
alias in D_LOC_ALIAS (tagged as an *MOE WELL_ID field (4)*).  Each location
will also have an alias for the original BORE_HOLE_ID (tagged as *MOE
BORE_HOLE_ID field (3)*) allowing a direct link to the original record set
found in the WWIS database.  The MOE WELL_ID, as an aside, is used to
determine those locations (from the WWIS) that have already been incorporated
within the ORMGP database.

Note that the locations derived from these multi-borehole records may have
incomplete information (especially with regard to geology present in the
D_LOC_GEOL_LAYER table).  All locations tied to a particular MOE WELL_ID can
be accessed, then, by referencing the pertinent D_LOC_ALIAS records.

*Last Modified: 2025-06-12*
