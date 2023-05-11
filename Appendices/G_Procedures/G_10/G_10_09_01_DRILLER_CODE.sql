
--***** G_10_09_01

--***** Determine if there are any drillers not listed in R_BH_DRILLER_CODE

select
m.CONTRACTOR
from 
MOE_20230324.dbo.TblWWR as m
where
m.CONTRACTOR collate database_default 
not in 
(
select bh_driller_alt_code collate database_default 
from OAK_20160831_MASTER.dbo.R_BH_DRILLER_CODE
)

-- if any are returned, these need to be added into the R_BH_DRILLER_CODE table

-- none are returned v20160531
--                   v20180530
--                   v20190509
-- none are returned v20200721
-- none are returned v20210119
-- none are returned v20220328
-- none are returned v20230324
