
--***** G_10_23_01

--***** check each table's identifiers before import

--***** 20230324 
--***** the following queries are no longer run as we're generating IDs just before import

SELECT 
mdloc.[LOC_ID]
FROM 
[MOE_201304].[dbo].[FM_D_LOCATION] as mdloc
inner join 
[OAK_20120615_MASTER].dbo.D_LOCATION as dloc
on
mdloc.LOC_ID=dloc.LOC_ID

select
mdbore.LOC_ID
from 
[MOE_201304].dbo.FM_D_BOREHOLE as mdbore
inner join
[OAK_20120615_MASTER].dbo.D_BOREHOLE as dbore
on
mdbore.LOC_ID=dbore.LOC_ID

select
mdbore.BH_ID
from 
[MOE_201304].dbo.FM_D_BOREHOLE as mdbore
inner join
[OAK_20120615_MASTER].dbo.D_BOREHOLE as dbore
on
mdbore.BH_ID=dbore.BH_ID

select
mdbc.BH_ID
from 
[MOE_201304].dbo.FM_D_BOREHOLE_CONSTRUCTION as mdbc
inner join
[OAK_20120615_MASTER].dbo.D_BOREHOLE_CONSTRUCTION as dbc
on
mdbc.BH_ID=dbc.BH_ID

select
mdbc.SYS_RECORD_ID
from 
[MOE_201304].dbo.FM_D_BOREHOLE_CONSTRUCTION as mdbc
inner join
[OAK_20120615_MASTER].dbo.D_BOREHOLE_CONSTRUCTION as dbc
on
mdbc.SYS_RECORD_ID=dbc.SYS_RECORD_ID

select
mdgf.LOC_ID
from 
[MOE_201304].dbo.FM_D_GEOLOGY_FEATURE as mdgf
inner join 
[OAK_20120615_MASTER].dbo.D_GEOLOGY_FEATURE as dgf
on
mdgf.LOC_ID=dgf.LOC_ID

select
mdgf.SYS_RECORD_ID
from 
[MOE_201304].dbo.FM_D_GEOLOGY_FEATURE as mdgf
inner join 
[OAK_20120615_MASTER].dbo.D_GEOLOGY_FEATURE as dgf
on
mdgf.SYS_RECORD_ID=dgf.SYS_RECORD_ID

select
mdgl.LOC_ID
from 
[MOE_201304].dbo.FM_D_GEOLOGY_LAYER as mdgl
inner join 
[OAK_20120615_MASTER].dbo.D_GEOLOGY_LAYER as dgl
on
mdgl.LOC_ID=dgl.LOC_ID

select
mdgl.SYS_RECORD_ID
from 
[MOE_201304].dbo.FM_D_GEOLOGY_LAYER as mdgl
inner join 
[OAK_20120615_MASTER].dbo.D_GEOLOGY_LAYER as dgl
on
mdgl.SYS_RECORD_ID=dgl.SYS_RECORD_ID

select
mdla.LOC_ID
from 
[MOE_201304].dbo.FM_D_LOCATION_ALIAS as mdla
inner join 
[OAK_20120615_MASTER].dbo.D_LOCATION_ALIAS as dla
on
mdla.LOC_ID=dla.LOC_ID

select
mdle.LOC_ID
from 
[MOE_201304].dbo.FM_D_LOCATION_ELEV as mdle
inner join 
[OAK_20120615_MASTER].dbo.D_LOCATION_ELEV as dle
on
mdle.LOC_ID=dle.LOC_ID	

select
mdlp.LOC_ID
from 
[MOE_201304].dbo.FM_D_LOCATION_PURPOSE as mdlp
inner join 
[OAK_20120615_MASTER].dbo.D_LOCATION_PURPOSE as dlp
on
mdlp.LOC_ID=dlp.LOC_ID

 note that we had to add SYS_RECORD_ID to the above,
 now referencing a second table

select
mdlp.LOC_ID
from 
[MOE_201304].dbo.FM_D_LOCATION_PURPOSE_2 as mdlp
inner join 
[OAK_20120615_MASTER].dbo.D_LOCATION_PURPOSE as dlp
on
mdlp.LOC_ID=dlp.LOC_ID

select
mdlqa.LOC_ID
from 
[MOE_201304].dbo.FM_D_LOCATION_QA as mdlqa
inner join 
[OAK_20120615_MASTER].dbo.D_LOCATION_QA as dlqa
on
mdlqa.LOC_ID=dlqa.LOC_ID

--select
--mdint.INT_ID
--from 
--[MOE_201304].dbo.FM_D_INTERVAL as mdint
--inner join 
--[OAK_20120615_MASTER].dbo.D_INTERVAL as dint
--on
--mdint.INT_ID=dint.INT_ID

select
mdim.INT_ID
from 
[MOE_201304].dbo.FM_D_INTERVAL_MONITOR as mdim
inner join 
[OAK_20120615_MASTER].dbo.D_INTERVAL_MONITOR as dim
on
mdim.INT_ID=dim.INT_ID

select
mdim.SYS_RECORD_ID
from 
[MOE_201304].dbo.FM_D_INTERVAL_MONITOR as mdim
inner join 
[OAK_20120615_MASTER].dbo.D_INTERVAL_MONITOR as dim
on
mdim.SYS_RECORD_ID=dim.SYS_RECORD_ID

select
mdire.INT_ID
from 
[MOE_201304].dbo.FM_D_INTERVAL_REF_ELEV as mdire
inner join 
[OAK_20120615_MASTER].dbo.D_INTERVAL_REF_ELEV as dire
on
mdire.INT_ID=dire.INT_ID

select
mdire.SYS_RECORD_ID
from 
[MOE_201304].dbo.FM_D_INTERVAL_REF_ELEV as mdire
inner join 
[OAK_20120615_MASTER].dbo.D_INTERVAL_REF_ELEV as dire
on
mdire.SYS_RECORD_ID=dire.SYS_RECORD_ID

select
mdit2.INT_ID
from 
[MOE_201304].dbo.FM_D_INTERVAL_TEMPORAL_2 as mdit2
inner join 
[OAK_20120615_MASTER].dbo.D_INTERVAL_TEMPORAL_2 as dit2
on
mdit2.INT_ID=dit2.INT_ID

select
mdit2.SYS_RECORD_ID
from 
[MOE_201304].dbo.FM_D_INTERVAL_TEMPORAL_2 as mdit2
inner join 
[OAK_20120615_MASTER].dbo.D_INTERVAL_TEMPORAL_2 as dit2
on
mdit2.SYS_RECORD_ID=dit2.SYS_RECORD_ID

select
mdpump.INT_ID
from 
[MOE_201304].dbo.FM_D_PUMPTEST as mdpump
inner join 
[OAK_20120615_MASTER].dbo.D_PUMPTEST as dpump
on
mdpump.INT_ID=dpump.INT_ID

select
mdpump.PUMP_TEST_ID
from 
[MOE_201304].dbo.FM_D_PUMPTEST as mdpump
inner join 
[OAK_20120615_MASTER].dbo.D_PUMPTEST as dpump
on
mdpump.PUMP_TEST_ID=dpump.PUMP_TEST_ID

select
mdps.PUMP_TEST_ID
from 
[MOE_201304].dbo.FM_D_PUMPTEST_STEP as mdps
inner join
[OAK_20120615_MASTER].dbo.D_PUMPTEST_STEP as dps
on
mdps.PUMP_TEST_ID=dps.PUMP_TEST_ID

select
mdps.SYS_RECORD_ID
from 
[MOE_201304].dbo.FM_D_PUMPTEST_STEP as mdps
inner join
[OAK_20120615_MASTER].dbo.D_PUMPTEST_STEP as dps
on
mdps.SYS_RECORD_ID=dps.SYS_RECORD_ID
