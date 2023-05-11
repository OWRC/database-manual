
--***** G_10_09_02

--***** Determine what drill methods have not been specified correctly

-- match the methods from the MOE to the ORMGP db

-- v20230324 0 returned

select
y.BORE_HOLE_ID
,m.METHOD_CONSTRUCTION_CODE
,m.OTHER_METHOD_CONSTRUCTION
from 
MOE_20230324.dbo.YC_20230324_BH_ID as y
inner join MOE_20230324.dbo.tblMethod_Construction as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
where 
OTHER_METHOD_CONSTRUCTION is not null
and METHOD_CONSTRUCTION_CODE is null

select
distinct( other_method_construction ) as OTHER_METHOD_CONSTRUCTION
from 
(
select
y.BORE_HOLE_ID
,m.METHOD_CONSTRUCTION_CODE
,m.OTHER_METHOD_CONSTRUCTION
from 
MOE_20230324.dbo.YC_20230324_BH_ID as y
inner join MOE_20230324.dbo.tblMethod_Construction as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
where 
OTHER_METHOD_CONSTRUCTION is not null
and METHOD_CONSTRUCTION_CODE is null
) as t

-- Methods to correct

--***** v20180530
--***** v20190509
--***** v20200721
--***** v20210119

-- Update all method_construction_code's which are null with the method specified in other_method_construction

update MOE_20230324.dbo.tblMethod_Construction
set
method_construction_code= '0'
where 
bore_hole_id in
(
select
y.BORE_HOLE_ID
from
MOE_20230324.dbo.YC_20230324_BH_ID as y
inner join MOE_20230324.dbo.tblMethod_Construction as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
where 
OTHER_METHOD_CONSTRUCTION is not null
and METHOD_CONSTRUCTION_CODE is null
--and other_method_construction like '%CORING%'
and ( other_method_construction like '%ABANDONED%' or other_method_construction like '%WELDER%' or other_method_construction like '%UNKNOWN%' 
   or other_method_construction like '%well upgrade%' or other_method_construction like '%PRESSURE GROUT%' or other_method_construction like 'POINTER' 
   or other_method_construction like 'P' or other_method_construction like '`' or other_method_construction like '%WELDING%' or other_method_construction like '%DECOMMISSION%'
   or other_method_construction like '%WELD%' or other_method_construction=',' or other_method_construction like 'DECOMISSIONED%')
)

update MOE_20230324.dbo.tblMethod_Construction
set
method_construction_code= '2'
where 
bore_hole_id in
(
select
y.BORE_HOLE_ID
from 
MOE_20230324.dbo.YC_20230324_BH_ID as y
inner join MOE_20230324.dbo.tblMethod_Construction as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
where 
OTHER_METHOD_CONSTRUCTION is not null
and METHOD_CONSTRUCTION_CODE is null
and ( other_method_construction like 'ROTARY' or other_method_construction like '%DVD ROTARY%' )
)


update MOE_20230324.dbo.tblMethod_Construction
set
method_construction_code= '4'
where 
bore_hole_id in
(
select
y.BORE_HOLE_ID
from 
MOE_20230324.dbo.YC_20230324_BH_ID as y
inner join MOE_20230324.dbo.tblMethod_Construction as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
where 
OTHER_METHOD_CONSTRUCTION is not null
and METHOD_CONSTRUCTION_CODE is null
and ( other_method_construction like '%AIR DR%' or other_method_construction like '%AIR D.R.%' or other_method_construction like '%ROTARY AIR%' 
   or other_method_construction like '%air rotary%'or other_method_construction like '%AIR D.R%' or other_method_construction like '%HYDRATE FRENCH%' 
   or other_method_construction like '%AIR ROTARY%' or other_method_construction like 'AIR' or other_method_construction like 'AIR DUAL ROTARY')
)



update MOE_20230324.dbo.tblMethod_Construction
set
method_construction_code= '5'
where 
bore_hole_id in
(
select
y.BORE_HOLE_ID
from 
MOE_20230324.dbo.YC_20230324_BH_ID as y
inner join MOE_20230324.dbo.tblMethod_Construction as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
where 
OTHER_METHOD_CONSTRUCTION is not null
and METHOD_CONSTRUCTION_CODE is null
and ( other_method_construction='AIR PERCUSSION' or other_method_construction like 'AIR ROCK%' )
)

update MOE_20230324.dbo.tblMethod_Construction
set
method_construction_code= '6'
where 
bore_hole_id in
(
select
y.BORE_HOLE_ID
from 
MOE_20230324.dbo.YC_20230324_BH_ID as y
inner join MOE_20230324.dbo.tblMethod_Construction as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
where 
OTHER_METHOD_CONSTRUCTION is not null
and METHOD_CONSTRUCTION_CODE is null
and other_method_construction like 'BORING%'
)


update MOE_20230324.dbo.tblMethod_Construction
set
method_construction_code= '7'
where 
bore_hole_id in
(
select
y.BORE_HOLE_ID
from 
MOE_20230324.dbo.YC_20230324_BH_ID as y
inner join MOE_20230324.dbo.tblMethod_Construction as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
where 
OTHER_METHOD_CONSTRUCTION is not null
and METHOD_CONSTRUCTION_CODE is null
and ( other_method_construction like '%DIAMOND BORING%' or other_method_construction like '%DIAMOND%'  or other_method_construction like '%HQ%'
   or other_method_construction like 'PQ%' )
)

update MOE_20230324.dbo.tblMethod_Construction
set
method_construction_code= '9'
where 
bore_hole_id in
(
select
y.BORE_HOLE_ID
from 
MOE_20230324.dbo.YC_20230324_BH_ID as y
inner join MOE_20230324.dbo.tblMethod_Construction as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
where 
OTHER_METHOD_CONSTRUCTION is not null
and METHOD_CONSTRUCTION_CODE is null
and ( other_method_construction='DRIVING' or other_method_construction='DR' or other_method_construction like '%dr-12w%' 
      or other_method_construction like 'D.R. 24%' or other_method_construction like 'DRIVING%')
)

update MOE_20230324.dbo.tblMethod_Construction
set
method_construction_code= 'A'
where 
bore_hole_id in
(
select
y.BORE_HOLE_ID
from 
MOE_20230324.dbo.YC_20230324_BH_ID as y
inner join MOE_20230324.dbo.tblMethod_Construction as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
where 
OTHER_METHOD_CONSTRUCTION is not null
and METHOD_CONSTRUCTION_CODE is null
and other_method_construction like 'EXCAVATION%'
)

update MOE_20230324.dbo.tblMethod_Construction
set
method_construction_code= 'D'
where 
bore_hole_id in
(
select
y.BORE_HOLE_ID
from 
MOE_20230324.dbo.YC_20230324_BH_ID as y
inner join MOE_20230324.dbo.tblMethod_Construction as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
where 
OTHER_METHOD_CONSTRUCTION is not null
and METHOD_CONSTRUCTION_CODE is null
and other_method_construction='DIRECT PUSH'
)

update MOE_20230324.dbo.tblMethod_Construction
set
method_construction_code= 'E'
where 
bore_hole_id in
(
select
y.BORE_HOLE_ID
from 
MOE_20230324.dbo.YC_20230324_BH_ID as y
inner join MOE_20230324.dbo.tblMethod_Construction as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
where 
OTHER_METHOD_CONSTRUCTION is not null
and METHOD_CONSTRUCTION_CODE is null
and ( other_method_construction like 'AUGER%' ) -- or other_method_construction like 'AUGER%' )
)

update MOE_20230324.dbo.tblMethod_Construction
set
method_construction_code= 'F'
where 
bore_hole_id in
(
select
y.BORE_HOLE_ID
from 
MOE_20230324.dbo.YC_20230324_BH_ID as y
inner join MOE_20230324.dbo.tblMethod_Construction as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
where 
OTHER_METHOD_CONSTRUCTION is not null
and METHOD_CONSTRUCTION_CODE is null
and ( other_method_construction like '%HSA%' or other_method_construction like '%H.S.A.%'  or other_method_construction like 'HOLLOW STEM AUGER%' )
)

update MOE_20230324.dbo.tblMethod_Construction
set
method_construction_code= 'G'
where 
bore_hole_id in
(
select
y.BORE_HOLE_ID
from 
MOE_20230324.dbo.YC_20230324_BH_ID as y
inner join MOE_20230324.dbo.tblMethod_Construction as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
where 
OTHER_METHOD_CONSTRUCTION is not null
and METHOD_CONSTRUCTION_CODE is null
and other_method_construction like '%AUGER SSA%'
)

update MOE_20230324.dbo.tblMethod_Construction
set
method_construction_code= 'I'
where 
bore_hole_id in
(
select
y.BORE_HOLE_ID
from 
MOE_20230324.dbo.YC_20230324_BH_ID as y
inner join MOE_20230324.dbo.tblMethod_Construction as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
where 
OTHER_METHOD_CONSTRUCTION is not null
and METHOD_CONSTRUCTION_CODE is null
and ( other_method_construction like '%Roto sonic%' or other_method_construction like '%P%' or other_method_construction like 'sonic%' )
)

update MOE_20230324.dbo.tblMethod_Construction
set
method_construction_code= 'X'
where 
bore_hole_id in
(
select
y.BORE_HOLE_ID
from 
MOE_20230324.dbo.YC_20230324_BH_ID as y
inner join MOE_20230324.dbo.tblMethod_Construction as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
where 
OTHER_METHOD_CONSTRUCTION is not null
and METHOD_CONSTRUCTION_CODE is null
and ( other_method_construction like 'VAC%' ) -- or other_method_construction like '%PIONJAC%' )
)

update MOE_20230324.dbo.tblMethod_Construction
set
method_construction_code= 'Y'
where 
bore_hole_id in
(
select
y.BORE_HOLE_ID
from 
MOE_20230324.dbo.YC_20230324_BH_ID as y
inner join MOE_20230324.dbo.tblMethod_Construction as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
where 
OTHER_METHOD_CONSTRUCTION is not null
and METHOD_CONSTRUCTION_CODE is null
and ( other_method_construction like '%PIONJAR%' or other_method_construction like '%PIONJAC%' )
)

update MOE_20230324.dbo.tblMethod_Construction
set
method_construction_code= 'Z'
where 
bore_hole_id in
(
select
y.BORE_HOLE_ID
from 
MOE_20230324.dbo.YC_20230324_BH_ID as y
inner join MOE_20230324.dbo.tblMethod_Construction as m
on y.BORE_HOLE_ID=m.BORE_HOLE_ID
where 
OTHER_METHOD_CONSTRUCTION is not null
and METHOD_CONSTRUCTION_CODE is null
and 
( other_method_construction like '%DUAL ROTARY%' or other_method_construction like '%dual rotary%' or other_method_construction like '%DUAL ROATRY%' 
  or other_method_construction like '%DUAL ROTORY%' or other_method_construction like 'RUAL ROTARY' )
)







