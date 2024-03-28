
--***** G_10_14_03

--***** Determine the maximum depth from that recorded by the MOE

-- check that the moe reported max depths are in ft or m only

-- v20170905 0 rows are in units other than m or ft
-- v20180530 0 rows are in units other than m or ft
-- v20190509 0 rows are in units other than m or ft
-- v20200721 1 row
-- v20210119 0 rows
-- v20220328 0 rows
-- v20230324 0 rows
-- v20240327 0 rows

select
ycb.LOC_ID
,ycb.BH_ID
,moeh.*
from 
MOE_20240326.dbo.TblHole as moeh
inner join MOE_20240326.dbo.YC_20240326_BH_ID as ycb
on moeh.Bore_Hole_ID=ycb.BORE_HOLE_ID
where
moeh.Depth_to is not null
and not(moeh.HOLE_DEPTH_UOM in ('m','ft'))

--***** 20200731

select
*
from 
MOE_20240326.dbo.TblHole as moeh
where 
bore_hole_id= 1007382101

update MOE_20240326.dbo.TblHole
set
depth_to= depth_to/12
,hole_depth_uom= 'ft'
where 
bore_hole_id= 1007382101

-- compare and change those values that are not, the course followed will
-- likely vary for each set of imports an example is provided here
-- with regard to the MOE_201304 import

-- check against fm_d_geol_lay, fm_d_bore_cons, fm_d_int_mon

--update [MOE_201304].dbo.TblHole
--set 
-- HOLE_DEPTH_UOM='ft'
--where
--Bore_Hole_ID=1001860610

--update [MOE_201304].dbo.TblHole
--set 
-- HOLE_DEPTH_UOM='ft'
--where
--Bore_Hole_ID=1001860613

--update [MOE_201304].dbo.TblHole
--set 
-- HOLE_DEPTH_UOM='ft'
--,Depth_to=Depth_to/12
--where
--Bore_Hole_ID=11177545

--update [MOE_201304].dbo.TblHole
--set 
-- HOLE_DEPTH_UOM='ft'
--,Depth_to=Depth_to/0.3048
--,Depth_from=Depth_from/0.3048
--where
--Bore_Hole_ID=11177570

--update [MOE_201304].dbo.TblHole
--set 
-- HOLE_DEPTH_UOM='m'
--where
--Bore_Hole_ID=1001492864