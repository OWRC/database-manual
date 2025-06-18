---
title:  "Section 3.3.1"
author: "ORMGP"
date:   "20250618"
output: html_document
knit:   (
            function(input_file, encoding) {
                out_dir <- '';
                rmarkdown::render(
                    input_file,
                    encoding=encoding,
                    output_file=file.path(dirname(input_file), out_dir,
                    '03_03_01_Naming_Conventions.html')
                )
            }
        )
---

## Section 3.3.1 Naming Conventions

When naming a new location or changing the name of an existing location within
the ORMGP database it is important to consider other users.  Namely, the means
by which they would be able to find this particular location.  The common
naming fields (in D_LOC) of LOC_NAME, LOC_NAME_ALT1, LOC_NAME_ALT2 and
LOC_NAME_ORG are often used for any initial queries against the database.
Another field, LOC_NAME_MAP, is used primarily for spatial display purposes
(where the length of the name is kept as short as possible).  

Additional names can added into the D_LOC_ALIAS table allowing, for example,
any region or conservation area specific names to be captured for any
location.  In addition, the LOC_STUDY field can be used to assist in grouping
and locating wells that may be tied to a particular study (e.g. a development
application).  

In many cases, any intial names assigned are too ambiguous (e.g. *MW 6*)
resulting in hard-to-find or, in some cases, duplication of locations.  These
names where existing in the ORMGP database have been, slowly, updated to
better represent their locations.  All users are encouraged to assist with
implementing a consistent naming structure.  As such, the following should be
considered when naming locations in the database:

* In the D_LOC table, the LOC_NAME_ORG field should contain (as appropriate)
  the MOE WWIS well identifier (note that this is explicitly captured in the
  D_LOC_ALIAS table); alternatively, an historical name can be substituted

* Geographical references should be relatively specific; e.g. *Heart Lake Road
  well* as opposed to *CVC well* or *Grasshopper Road well* versus *CLOCA
  well*

* For new municipal wells it is recommended that users follow the current
  naming strategy of prefixing the well name with the community name in the
  LOC_NAME field (e.g. *King City PW 1*); the LOC_NAME_ALT1 field for municipal
  wells should also contain the Region (e.g. *York - King City - PW 1*); any future
  user looking for a York Region well should have these locations; many municipal wells
  also have a local name which can also be added to the name (e.g. a LOC_NAME
  of *Aurora MW 7 (Henderson TW)*; a LOC_NAME_ALT1 of *York - Aurora MW 7 -
  Henderson TW (GLL)*)

UPTO HERE

* For municipal and consultant drilled wells, the following prefixes are recommended:
   + PW (Pumping Well) - currently used, previously used, and backup pumping
   wells should be designated with a PW (for wells in Durham the MW,
   indicating 'Municipal Well', prefix is also incorporated - e.g. a LOC_NAME
   of 'Blackstock MW 3 (PW 3)'; a LOC_NAME_ALT1 of 'Durham - Blackstock - MW
   #3 (PW #3)') 
   + TW (Test Well) or TH (Test Hole) - an exploration well that was
   unsuccessful and has been abandoned is typically referred to as a test well
   and should be given a TW prefix; it is worth noting that there are
   exceptions since at times these exploration wells are not abandoned but,
   rather, left in place as longer term monitoring wells - the TW moniker
   remains with the well; note that the TW prefix is preferred over the TH
   prefix
   + BH (Borehole) - this prefix should be given to any borehole where a
   screen is installed for monitoring purposes (water levels and/or water
   quality); however, unlike longer term monitoring (MW) wells (see below),
   these are generally intended for a short term life (e.g. those wells
   drilled on proposed development sites that subsequently get abandoned)
   + MW (Monitoring Well) - current or previously used monitoring wells from
   which water levels or water quality data have been derived are typically
   designated with an MW prefix
   + EW (Early Warning Well) or SW (Sentry Well) - these prefixes can be used
   for the subset of monitoring wells that are specifically used to look at
   the water quality in wellhead protection areas; note that the LOC_TYPE_CODE
   of '1' (i.e. 'Well or Borehole') would differentiate these wells from
   surface water monitoring locations which have, instead, a LOC_TYPE_CODE of
   '6' (i.e. 'Surface Water'), and (frequently) an SW prefix
   + DP (Drive Point) or MP (Mini-Piezometer) - these prefixes are applied to
   temporary drive points or mini-piezometers that are pounded by hand into
   the shallow subsurface (often in stream beds or in wetlands or adjacent to
   these features) to provide an indication of SW/GW interactions; typically
   they are short-lived, however they can remain in place as active monitoring
   locations for years; note that in the case of a mini-piezometer in a stream
   where the water levels both inside and outside of the pipe are recorded, it
   is recommended that the outside measurement be tied to a 'Staff Gauge'
   station (i.e. SG, see below) as opposed to an MP station;  within the
   database the two stations (e.g. an MP and SG) can be linked together
   through the LOC_MASTER_LOC_ID field and can also be grouped using the
   D_GROUP_LOCATION table
   + SG (Staff Gauge) - the prefix is to be used where a staff gauge is placed
   into a water body (e.g. a lake, stream or wetland) to measure the
   elevation/depth of the water levels over time; the prefix should also be
   used in the case of a mini-piezometer where the water level is measured on
   the outside of a mini-piezometer pipe; generally these staff gauges are
   temporary - however, when they are attached to a bridge (over/in a river)
   or other infrastructure they can remain in place for years
   + SW (Surface Water) - this prefix can be used for both spot flow as well
   as gauged surface water stations
   + CS (Climate Station) - this prefix can be used for any climate station
   that is established for short or long term monitoring purposes

It is important to note that the status of municipal or consultant drilled
wells can change over time.  For example, pumping wells can be abandoned or
converted to monitoring wells or vice-versa.  In such cases the prefix should
be changed and the former name (with the earlier prefix designation) can be
stored in the D_LOCATION_ALIAS table.  Alternatively, to clearly identify that
the well was converted, the former prefix can also be saved in parenthesis at
the end of the current name.  Decommissioned pumping wells should retain the
PW prefix indefinitely and the name should not be changed.  The
LOC_STATUS_CODE (in D_LOCATION) should be changed from 'Active' (i.e. a value
of '1') to 'Decommissioned' (i.e. a value of '7'; refer to R_LOC_STATUS_CODE
for details).

Examples are provided in the following table (broken into two sections for
readability).  Refer also to the D_LOCATION table outline in Section 2.1.1.  

![Table 3.3.1.1 D_LOCATION naming conventions (LOC_NAME and
LOC_NAME_ALT1)](t03_03_01_01_conv.jpg)*Table 3.3.1.1 D_LOCATION naming
conventions (LOC_NAME and LOC_NAME_ALT1).*

![Table 3.3.1.2 D_LOCATION naming conventions (LOC_ORIGINAL_NAME, LOC_NAME_MAP
and LOC_STUDY)](t03_03_01_02_conv.jpg)*Table 3.3.1.2 D_LOCATION naming
conventions (LOC_ORIGINAL_NAME, LOC_NAME_MAP and LOC_STUDY).*

*Last Modified: 2025-06-18*
