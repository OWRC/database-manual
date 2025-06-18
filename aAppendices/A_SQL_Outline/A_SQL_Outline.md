---
title:  "Appendix A"
author: "ormgpmd"
date:   "20250618"
output: html_document
knit:   (
            function(input_file, encoding) {
                out_dir <- '';
                rmarkdown::render(
                    input_file,
                    encoding=encoding,
                    output_file=file.path(dirname(input_file), out_dir,
                    'A_SQL_Outline.html')
                )
            }
        )
---

## Appendix A - Basic Outline and Use of Structured Query Language (SQL)

This is an introduction to the syntax and applied use of SQL with specific
reference to the ORMGP database.  SQL allows users to access (and manipulate)
data from relational databases (or more formally known as a *Relational
Database Management System*, i.e. RDBMS) in a fairly straightforward manner
using a language-natural syntax.  In general, no knowledge of computer
programming is necessary.

Almost all cases can be considered to use *standard* SQL (also referred to as
*ANSI* SQL) that should be, for the most part, applicable across a number of
relational database software (e.g. Microsoft SQL Server, Oracle, MySQL,
SQLITE, etc ...).  Though there are slight differences in the supported syntax
between these packages, most of the keywords and concepts will still (likely)
be applicable.

Note that all SQL syntax will be shown in uppercase though, in general, it is
case-insensitive.  Comments and placeholders will be shown in lowercase.
Single quotes (i.e. 'example') are used where text is being examined.  For the
latter, in some cases, double quotes (i.e.  "example") would be used instead.

### A.1 Select Statement

#### Select Statement - Overview

SELECT is the most common statement used within a relational database,
allowing the user to *select* specific information from an existing table (or
tables).  The general syntax is of the form

    SELECT <comma-delimited list of fields> FROM <a single table name>

Examining the contents of the D_LOC table would require 

    SELECT * FROM D_LOC

which would return all the fields and all the rows within the D_LOC table.
Note the use of the *\** wildcard; this allows the user to specify the
selection of all existing fields without having to list the fields
individually.  Alternatively, the fields desired can be explicitely listed
using:

    SELECT 
    LOC_ID,
    LOC_NAME,
    LOC_NAME_ALT1,
    LOC_TYPE_CODE,
    OWN_ID
    FROM
    D_LOC

Note that the fields are comma-delimited and are listed across multiple lines.
Line spacing and any additional blank space on the lines themselves do not
affect the query and can be used as a formatting tool (which eases
interpretation and viewing).

In general, you would likely not wish to examine all the rows from a
particular table at once (the D_LOC table in this example contains
approximately *824,000* records).  If you were assembling a query, then, you
could choose to examine only a certain number of records using the TOP
keyword.

    SELECT TOP 1000 LOC_ID,LOC_NAME FROM D_LOC

This extracts the location identifier and the associated location name from
the D_LOC table but limits the number of rows returned to the first *1,000*.
The order the rows are returned should not be relied upon (the means for
specifying a particular order will be outlined in a subsequent section).

In many cases, the user is looking for particular information.  For example,
if you wanted to see the names associated with a particular location in the
database and provided with a LOC_ID of *-828830263*, then the query

    SELECT * FROM D_LOC WHERE LOC_ID = -828830263

would return all fields but only a single row from the D_LOC table.  This
would be the row matching the provided location identifier (i.e. LOC_ID; this
is the primary key to the D_LOC table).  Other operators can also be used
during a comparison.  These include

* Not equal (!=)
* Less than (\<)
* Greater than (\>)
* Less than or equal to (\<=)
* Greater than or equal to (\>=)

So a user could determine all those boreholes (from the D_LOC_BOREHOLE table) with
a bottom depth greater than *20* metres using

    SELECT * FROM D_LOC_BOREHOLE WHERE BOTD > 20

The name fields from D_LOC (e.g. LOC_NAME, LOC_NAME_ALT1, etc ...) could also
be used to extract information about a particular location .  If only a name
was known then

    SELECT * FROM D_LOC WHERE LOC_NAME='Port Perry OW 05/3'

would pull the same information as using the LOC_ID (above) of *-828830263*.
However, searching through text fields differs from numeric in that
rarely do the text fields match the exact text the user enters.  Instead of an
exact match, the user (when looking for location names containing certain
text) can instead use the LIKE keyword

    SELECT * FROM D_LOC WHERE LOC_NAME LIKE '%UGAIS%'

This extracts all rows (and fields) of information where the location name
contains, anywhere within its name, the *UGAIS* key.  Note the use of the *%*
sign (in other packages, a *\**' can be used instead) as part of the quoted
text; these are text wildcards specifying that any number of characters can
occur in front of the *UGAIS* text and that any number of characters can take
place after it.  This includes the case where there are no characters before
and/or after.

Multiple checks can be specified as part of the query - these are the
statements after the WHERE keyword. This is
accomplished through additional boolean (or logical) operators (e.g. AND)

    SELECT 
    *
    FROM D_LOC
    WHERE
    LOC_NAME LIKE '%UGAIS%' AND LOC_NAME_ORG LIKE 'TR%'

In this case, we're specifying two checks - one against the LOC_NAME field,
another against the LOC_NAME_ORG field.  For the latter, notice that the '%'
character only appears after the *TR* text.  This indicates that the text must
be placed at the beginning of the name.  The boolean operator used is AND -
both checks must be true for any particular record to be returned (i.e.
*UGAIS* must appear in LOC_NAME and *TR* must be at the beginning of the
LOC_NAME_ORG).  Another boolean operation is OR, as in

    SELECT
    * 
    FROM D_LOC
    WHERE 
    LOC_NAME LIKE '%UGAIS%' OR LOC_NAME LIKE '%OGS'

where the rows returned from D_LOC depend on whether the *UGAIS* or the *OGS*
text appear as part of LOC_NAME.  For numeric comparisons, if we wanted to
find all boreholes from D_LOC_BOREHOLE with a  depth of greater than *20*
metres but less than or equal to *40* metres, the following could be used

    SELECT
    *
    FROM D_LOC_BOREHOLE
    WHERE
    BOTD > 20 AND BOTD <= 40

#### Select Statement - IN condition

Multiple OR statements could be used to find all locations given a particular
characteristic.  For example, if we wanted to find any location that could
have geological information we could use

    SELECT 
    LOC_ID,
    LOC_NAME,
    LOC_NAME_ALT1,
    LOC_TYPE_CODE
    FROM 
    D_LOC
    WHERE
    LOC_TYPE_CODE= 1
    OR LOC_TYPE_CODE= 7
    OR LOC_TYPE_CODE= 11
    OR LOC_TYPE_CODE= 17
    OR LOC_TYPE_CODE= 18
    OR LOC_TYPE_CODE= 19

where the values of LOC_TYPE_CODE (found in R_LOC_TYPE_CODE) are equivalent to

* Bedrock Outcrop (19)
* Geological Section (17)
* Oil and Gas Well (18)
* Outcrop (11)
* Testpit (7)
* Well or Borehole (1)

However, this statement can be simplified by using the IN keyword.  Here, the
possible values against which the user is checking is a comma-delimited list,
as in

    SELECT 
    LOC_ID,
    LOC_NAME,
    LOC_NAME_ALT1,
    LOC_TYPE_CODE
    FROM D_LOC
    WHERE
    LOC_TYPE_CODE IN (1,7,11,17,18,19)

which is shorter and much easier to understand.

The IN condition also allows us to combine SELECT queries.  Here, for example,
is a query which returns a list of single values:

    SELECT LOC_ID FROM D_LOC_BOREHOLE

This is a list of all locations that have a record in D_LOC_BOREHOLE (where
LOC_ID is also a primary key).  This is approximately equivalent to listing
all the LOC_TYPE_CODE values in the prevous example (i.e. those locations that
could have geological information associated with it).  Now that we have a
list of identifiers, we can pull their names and type codes from D_LOC using
the IN keyword:

    SELECT
    LOC_ID,
    LOC_NAME,
    LOC_NAME_ALT1,
    LOC_TYPE_CODE
    FROM 
    D_LOC
    where
    LOC_ID IN 
    (
        SELECT LOC_ID FROM D_LOC_BOREHOLE
    )

This should return equivalent results to that of using the LOC_TYPE_CODE
earlier.  Note that this type of query statement only works if the contained
SELECT (i.e. the one in brackets) just returns a list of single values.  If we
needed multiple fields from another table, we would need to create a JOIN
between the tables.

#### Select Statement - Joins

In a relational database, only certain information for a particular
object or entity would be contained in a single table.  For example, D_LOC
contains basic information for any location with the ORMGP database.  This
includes a variety of names, the type of location, the area it lies within and
any study associated with it.  The D_LOC_BOREHOLE, in comparison, contains the
depth of a borehole, the means by which it was drilled and the date upon which
it was done as well as whether it intersects bedrock.

A borehole location might also have a screen, i.e. that part of the well where
water is collected from the surrounding geologic formation (usually an
aquifer).  This information is stored in other tables including D_INT (which
includes the interval name and type), D_INT_DEPTH (containing the top and
bottom depth of the screen), etc...  The information from each table is
linked through the use of keys.  For example, primary key fields are those where
each row in a table can be distinguished between based upon the unique value
within the field.  Foreign keys, alternatively, are fields in a particular
table whose values are not unique but ... they refer to another table where
the values in that field are unique.  This is the basis of the relationship
between tables.

Examples of such keys within the ORMGP database that are used across multiple
tables are the fields LOC_ID and INT_ID.  The former is found in the D_LOC\*
tables while the lattter is found in the D_INT\* tables.  Means of combining
informtion from multiple tables, based upon these keys, are call joins.  We'll
examine two types - inner joins and outer joins.

***Select Statement - Inner Joins***

Inner joins require that the particular key field and value exists in both
tables being referenced.  For example, if we wanted the location information
(found in D_LOC) and borehole depth for any borehole (in D_LOC_BOREHOLE) with
depths greater than *20* metres, our query would look like

    SELECT
    dloc.LOC_ID,
    LOC_NAME,
    LOC_NAME_ALT1,
    LOC_NAME_ORG,
    BOTD
    FROM
    D_LOC_BOREHOLE AS dbore
    INNER JOIN D_LOC AS dloc
    ON dbore.LOC_ID = dloc.LOC_ID
    WHERE
    dbore.BOTD > 20

Here, we are *joining* our two tables using the INNER JOIN keywords based upon
the presence of LOC_ID in both tables.  In this case, LOC_ID is actually the
primary key in both of these tables.  Another concept is also being
introduced, namely the use of the AS keyword.  As there are some fields
(specifically LOC_ID) which occurs in both tables, we need to specify which
table we are referencing when using that field name.  AS allows us to
associate an alias with a particular table (or field); here, we're stating
that dloc is equivalent to D_LOC and dbore is equivalent to D_LOC_BOREHOLE.
This makes clear source of the field being accessed as well as (possibly)
shortening the name required in the query itself (through the use of *Dot
Notation*; i.e. having a *period* between the aliased name of the table and
the name of the field).

Multiple tables can be joined at the same time.  If we wanted to include
interval data as part of our query, we could then use

    SELECT
    dloc.LOC_ID,
    dint.INT_ID,
    dloc.LOC_NAME,
    dint.INT_NAME
    dloc.LOC_NAME_ALT1,
    dloc.LOC_NAME_ORG,
    dbore.BOTD
    FROM
    D_LOC_BOREHOLE AS dbore
    INNER JOIN D_LOC AS dloc 
    ON dbore.LOC_ID = dloc.LOC_ID
    INNER JOIN D_INT AS dint 
    ON dloc.LOC_ID = dint.LOC_ID

Note that we have specified exactly (using the \<table\>.\<field\> syntax)
which field is coming from which table in all cases.  The use of AS is
optional; the complete source table name can be specified instead.

***Select Statement - Outer Joins***

Outer joins are used when the key field is found in both the associated tables
but we are unsure whether the key value exists in one of those tables.  Outer
joins are different in that they are specified using a LEFT or RIGHT keyword;
this stresses which of the two tables (i.e. the left or right table in the
query) is the one we are using as the base (i.e. the one that has the key we
are using).

For example, if we wanted to pull all wells with a bedrock depth specified (in
D_LOC_BOREHOLE) as well as all surface water stations (which would not have
records in D_LOC_BOREHOLE) we would use

    select
    dloc.LOC_ID,
    dloc.LOC_NAME,
    dloc.LOC_NAME_ALT1,
    dloc.LOC_NAME_ORG,
    dbore.BOTD,
    dbore.BEDROCKD,
    dloc.LOC_TYPE_CODE
    from 
    D_LOC as dloc
    LEFT OUTER JOIN D_LOC_BOREHOLE as dbore
    on dloc.LOC_ID = dbore.LOC_ID
    WHERE
    dloc.LOC_TYPE_CODE IN (1,6)
    and dbore.BEDROCKD IS NOT NULL

We are using a LEFT OUTER JOIN in this instance as the LOC_ID value, which we
are using to link the tables, will be present in D_LOC (the left or first
table) while it may not be present in D_LOC_BOREHOLE (the right or second
table).  Three additional keywords have been specified: IS NOT NULL.  NULL is
used as a placeholder - no value is present in that field for that particular
record.  NOT NULL indicates that there is a value in that field.  The IS key
is used to check if a field value matches a specific condition.

#### Select Statement - BETWEEN condition

The BETWEEN condition can be used for comparisons for a range of values.  If
we wanted to extract locations falling within a particular set of coordinates,
we could specify

    SELECT
    dloc.LOC_ID,
    dloc.LOC_NAME,
    dhist.X,
    dhist.Y
    FROM
    D_LOC as dloc
    INNER JOIN D_LOC_SPATIAL as dspat
    ON dloc.LOC_ID = dspat.LOC_ID
    INNER JOIN D_LOC_SPATIAL_HIST as dhist
    on dspat.SPAT_ID = dhist.SPAT_ID
    WHERE
    dhist.X BETWEEN 620000 AND 640000
    AND dhist.Y BETWEEN 4831000 AND 4841000
    AND ( dloc.LOC_NAME LIKE '%UGAIS%' OR LOC_NAME LIKE '%OGS%' )

Note that the relation between D_LOC_SPATIAL and D_LOC_SPATIAL_HIST is relient
upon the SPAT_ID key (the latter table contains the coordinate information for
all locations within the ORMGP database).  This pulls all *UGAIS* and *OGS)
locations.  The equivalent statement without using the BETWEEN keyword would be

    SELECT
    dloc.LOC_ID,
    dloc.LOC_NAME,
    dhist.X,
    dhist.Y
    FROM
    D_LOC as dloc
    INNER JOIN D_LOC_SPATIAL as dspat
    ON dloc.LOC_ID = dspat.LOC_ID
    INNER JOIN D_LOC_SPATIAL_HIST as dhist
    ON dspat.SPAT_ID = dhist.SPAT_ID
    WHERE
    ( dhist.X >= 620000 AND dhist.X <= 640000 )
    AND (dhist.Y >= 4831000 AND dhist.Y <= 4841000 )
    AND ( dloc.LOC_NAME LIKE '%UGAIS%' OR LOC_NAME LIKE '%OGS%' )

#### Select Statement - Calculations (Arithmetic Operations) and Mathematical Functions

In many cases, a user would wish to combine values in some sort of calculation
and return the result of that calculation as part of the query.  If, for
example, we wanted to return the ground elevation, bottom elevation and
bedrock elevation for boreholes from D_LOC_BOREHOLE we would use

    SELECT
    dloc.LOC_ID,
    dloc.LOC_NAME,
    dhist.X,
    dhist.Y,
    dhist.Z AS GROUND_ELEV,
    dhist.Z - dbore.BOTD AS BOT_ELEV,
    dhist.Z - dbore.BEDROCKD AS BEDROCK_ELEV
    FROM
    D_LOC as dloc
    INNER JOIN D_LOC_SPATIAL AS dspat
    ON dloc.LOC_ID = dspat.LOC_ID
    INNER JOIN D_LOC_SPATIAL_HIST AS dhist
    ON dspat.SPAT_ID = dhist.SPAT_ID
    INNER JOIN D_LOC_BOREHOLE AS dbore
    ON dloc.LOC_ID = dbore.LOC_ID
    WHERE
    dloc.LOC_TYPE_CODE = 1

Note that we are renaming the two calculated fields (as well as the Z field
from D_LOC_SPATIAL_HIST) using the AS keyword.  Here, we are subtracting the
particular depths from the elevation of the location to calculate the bottom
and bedrock elevations.  In addition, we are limiting the query to only
include boreholes (i.e. having a LOC_TYPE_CODE of *1*).

Standard arithmetic operations include

* Addition (+)
* Subtraction (-)
* Multiplication (\*)
* Division (/)
* Modulo (%)

The results of *'Modulo* (for those unfamiliar with the operation) would be the
(integer) remainder after a division operation.  For example: *3 % 2* would
return a value of *1*; *2 % 2* would return a value of *0*.

In addition there are a number of mathematical functions that can be useful.
Note that these may not necessarily available in all relational database
software.  Examples include:

* ABS(x) - Returns the absolute value of (x) 
* CEILING(x) - Returns the smallest integer greater than or equal to (x); 
  also CEIL(x)
* FLOOR(x) - Returns the largest value less than or equal to (x)
* MOD(x,y) - Modulo; returns the integer remainder of x divided by y (same as
  *x % y*
* POWER(x,y) - Returns the value of x raised to the power of y 
* ROUND(x) - Returns the value of x rounded to the nearest integer; users 
  must be careful when using this function as various ROUND(x) implementations 
  (across software platforms) may calculate this value differently 
* SIGN(x) -  Returns the sign of (x) (i.e. one of -1, 0 or 1)
* SQRT(x) - Returns the square-root value of (x)

Other functions, including trigonometric functions, are also available but are
not described here.

#### Select Statement - CASE condition

The CASE conditional statement can be used when the user would likea
particular value returned where multiple values are possible.  For example, if
we were performing a check on the calculation of depth in metres for boreholes
based upon their original units of measure (OUOM) there could be an issue.
The units found within the OUOM fields can vary; we would need to account for
this within the calculation:

    SELECT
    dbore.LOC_ID
    ,dbore.BOTD
    ,CASE
    WHEN dbore.UNIT_OUOM LIKE 'mbgs' THEN dbore.BOT_OUOM
    WHEN dbore.UNIT_OUOM LIKE 'fbgs' THEN ( dbore.BOT_OUOM * 0.3048 )
    ELSE -9999
    END AS CHK_BOTD
    FROM
    D_LOC_BOREHOLE as dbore

This returns the calculated CHK_BOTD field that can be compared against the
original BOTD field.  If the OUOM text is *mbgs*, no change is necessary for
the comparison (i.e. both the BOTD and BOT_OUOM values are in equivalent
units).  If the OUOM text is, instead, *fbgs* then we would need to convert
the BOT_OUOM field from feet to meters (below-ground-surface).  Note that the
default value *-9999* is being used as a tag in case not all of the possible
text units within UNIT_OUOM have been accounted for.

#### Select Statement - ORDER BY

Information returned from a query can, at times, be more useful when it is
ordered in some manner.  For example, when working with time-stamped data
(i.e. data with an associated date-time field).  If we wanted to examine all
manual water levels from the borehole *Port Perry OW 05/3* (with LOC_ID
*-828830263*) we would first need to determine the interval associated with
the location (remember, temporal information is linked against intervals and
not directly to locations) 

    SELECT 
    INT_ID,
    INT_NAME,
    INT_NAME_ALT1
    FROM 
    D_INT 
    WHERE 
    LOC_ID= -828830263

This would return the interval identifier (a numeric) and the interval names
associated with the particular location we're examining.  However, we can skip
this step by including the determination of the INT_ID as part of the water
level query:

    SELECT
    *
    FROM
    D_INT_TEMPORAL_2 AS dit2
    INNER JOIN D_INT AS dint
    ON dit2.INT_ID=dint.INT_ID
    WHERE
    dint.LOC_ID= -828830263

where we have only specified the original location identifier.  This query,
though, extracts all information linked against the particular interval.  We
need to limit what is returned to only include the information that we are
interested in:

    SELECT
     dit2.INT_ID
    ,dit2.RD_DATE 
    ,dit2.RD_VALUE 
    ,ruc.UNIT_DESC
    FROM
    D_INT_TEMPORAL_2 AS dit2
    INNER JOIN D_INT AS dint
    ON dit2.INT_ID=dint.INT_ID
    INNER JOIN R_UNIT_CODE AS ruc
    ON dit2.UNIT_CODE=ruc.UNIT_CODE
    WHERE
    dint.LOC_ID= -828830263
    AND dit2.RD_NAME_CODE= 628

Here, we've specified that we're only intersted in manual water levels (this
matches a RD_NAME_CODE of *628* as found imn R_RD_NAME_CODE).  We have
included the particular unit name (UNIT_DESC) from the lined reference table
R_UNIT_CODE.  This is a check to make sure that all values returned (found in
RD_VALUE) are using consistent units; these should all be *masl* in this
instance.

The information returned would be in some random order making it difficult to
examine the values for trends.  We could assemble the returned results,
instead, using an ORDER BY clause against the RD_DATE:

    SELECT
     dit2.INT_ID
    ,dit2.RD_DATE 
    ,dit2.RD_VALUE 
    ,ruc.UNIT_DESC
    FROM
    D_INT_TEMPORAL_2 AS dit2
    INNER JOIN D_INT AS dint
    ON dit2.INT_ID=dint.INT_ID
    INNER JOIN R_UNIT_CODE AS ruc
    ON dit2.UNIT_CODE=ruc.UNIT_CODE
    WHERE
    dint.LOC_ID= -828830263
    AND dit2.RD_NAME_CODE= 628
    ORDER BY
    dit2.RD_DATE

By default, the returned information would be an ascending order (i.e. from
the earliest date to the latest).  If we wished to reverse this order (from
the latest date to the earliest) we would append a DESC:

    SELECT
     dit2.INT_ID
    ,dit2.RD_DATE 
    ,dit2.RD_VALUE 
    ,ruc.UNIT_DESC
    FROM
    D_INT_TEMPORAL_2 AS dit2
    INNER JOIN D_INT AS dint
    ON dit2.INT_ID=dint.INT_ID
    INNER JOIN R_UNIT_CODE AS ruc
    ON dit2.UNIT_CODE=ruc.UNIT_CODE
    WHERE
    dint.LOC_ID= -828830263
    AND dit2.RD_NAME_CODE= 628
    ORDER BY
    dit2.RD_DATE DESC
    
#### Select Statement - Aggregate Functions and GROUP BY

If we needed to examine the average, minimum or maximum of values returned by
the manual water levels query used previously, we would make use of an
aggregate function.  This would require that a GROUP BY statement be
incorporated as part of the query.  The GROUP BY allows a list of values to be
created from a query with the particlar aggregate function returning a single
value from that listing.  Examples of aggregate functions include:

* AVG - the average of the values from the specified field
* COUNT - the number of records satisfying the GROUP BY condition
* MAX - the largest value from the specified field
* MIN - the smallest value from the specified field
* SUM - the total of all values found in the specified field

An example use, calculating the average of the returned values, would then be:

    SELECT
    dit2.INT_ID
    ,AVG( dit2.RD_VALUE ) AS AVG_WL
    FROM 
    D_INT_TEMPORAL_2 AS dit2
    INNER JOIN D_INT AS dint
    ON dit2.INT_ID=dint.INT_ID
    WHERE
    dint.LOC_ID= -828830263
    AND dit2.RD_NAME_CODE= 628
    GROUP BY
    dit2.INT_ID

Here, we're grouping the returned information by the INT_ID.  This means that
any values related to a particular INT_ID will become part of a (virtual) list.
From this list, we then calculate the average value using the AVG keyword.
This would return one record for the specified INT_ID (through LOC_ID) from
the source table.  Note that multiple aggregate functions can be applied at the
same time:

    SELECT
    dit2.INT_ID
    ,AVG( dit2.RD_VALUE ) AS AVG_WL
    ,MIN( dit2.RD_VALUE ) AS MIN_WL
    ,MAX( dit2.RD_VALUE ) AS MAX_WL
    ,COUNT( dit2.RD_VALUE ) as NUM_WL
    FROM 
    D_INT_TEMPORAL_2 AS dit2
    INNER JOIN D_INT AS dint
    ON dit2.INT_ID=dint.INT_ID
    WHERE
    dint.LOC_ID= -828830263
    AND dit2.RD_NAME_CODE= 628
    GROUP BY
    dit2.INT_ID

This query returns the average, minimum, maximum and number of manual water
levels associated with the particular INT_ID (found through the D_INT using
the LOC_ID value).  

### A.2 UNION and UNION ALL

This function allows the results of a combination of SELECT statements to be
*appended* as a single output set.  Between each statement, though, the number
of fields, the field types and the field name order must be equivalent.  Note
that the use of UNION removes duplicate records resulting from the SELECT
statements; the UNION ALL will retain all records.  Thus, the following
statement 


    SELECT
    dit1a.SAM_ID
    ,dit1a.SAM_NAME
    ,dit1a.SAM_DATE
    ,dit2.RD_NAME_CODE
    ,dit2.RD_VALUE 
    ,dit2.UNIT_CODE
    ,NULL AS RD_MDL
    ,NULL AS RD_VALUE_QUALIFIER
    ,NULL AS RD_UNCERTAINTY
    FROM
    D_INTL_TEMPORAL_2 AS dit2
    INNER JOIN D_INT_TEMPORAL_1A AS dit1a
    ON dit2.INT_ID=dit1a.INT_ID AND dit2.RD_DATE=dit1a.SAM_SAMPLE_DATE
    WHERE
    dit2.RD_TYPE_CODE= 77
    UNION ALL
    SELECT
    dit1a.SAM_ID
    ,dit1a.SAM_NAME
    ,dit1a.SAM_DATE
    ,dit1b.RD_NAME_CODE
    ,dit1b.RD_VALUE 
    ,dit1b.UNIT_CODE
    ,dit1b.RD_MDL
    ,dit1b.RD_VALUE_QUALIFIER
    ,dit1b.RD_UNCERTAINTY
    FROM
    D_INT_TEMPORAL_1B AS dit1b
    INNER JOIN D_INT_TEMPORAL_1A AS dit1a
    ON dit1b.SAM_ID=dit1a.SAM_ID

would combine the parameter results from D_INT_TEMPORAL_1A/1B and
D_INT_TEMPORAL_2 that were collected for the same interval upon the same
datetime.  That D_INT_TEMPORAL_2 does not have uncertainty and mean detection
limit fields; the NULL values are being used as placeholders so as to match
the field names between the two SELECT statements.  Note the use of an
RD_TYPE_CODE of *77*; this indicates that the parameter was collected while in
the field as opposed to being analyzed in the laboratory.  The
D_INT_TEMPORAL_1\* tables are more commonly used for the latter type of
information.

*Last Modified: 2025-06-18*
