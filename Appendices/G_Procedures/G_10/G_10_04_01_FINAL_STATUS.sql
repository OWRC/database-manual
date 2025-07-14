
--***** G_10_04_01

--***** convert the MOE final status code to the YPDT-CAMC status code; create a
--***** look-up table

select
 wwr.FINAL_STA
,case 
     when wwr.FINAL_STA is null then 4  -- Unknown to Unknown
     when wwr.FINAL_STA='0'     then 4  -- Unknown to Uknown
     when wwr.FINAL_STA='1'     then 1  -- Water Supply to Active
     when wwr.FINAL_STA='2'     then 1  -- Observation to Active
     when wwr.FINAL_STA='3'     then 1  -- Test Hole to Active
     when wwr.FINAL_STA='4'     then 1  -- Recharge to Active
     when wwr.FINAL_STA='5'     then 3  -- Abandoned Supply to Abandoned
     when wwr.FINAL_STA='6'     then 3  -- Abandoned Quality to Abandoned
     when wwr.FINAL_STA='7'     then 3  -- Unfinished to Abandoned
     when wwr.FINAL_STA='8'     then 4  -- Not A Well to Unknown
     when wwr.FINAL_STA='9'     then 1  -- Dewatering to Active
     when wwr.FINAL_STA='A'     then 3  -- Abondoned-Other to Abandoned
     when wwr.FINAL_STA='B'     then 4  -- Replacement Well to Unknown
     when wwr.FINAL_STA='C'     then 4  -- Alteration to Unknown
     when wwr.FINAL_STA='D'     then 4  -- Other Status to Unknown
	 when wwr.FINAL_STA='E'	  then 17 -- Monitoring and Test Hole to MOE Monitoring and Test Hole
	 when wwr.FINAL_STA='F'	  then 18 -- Abandoned Monitoring and Test Hole to MOE Abandoned Monitoring and Test Hole
     else -9999
 end
 as [LOC_STATUS_CODE]
,case 
     when wwr.FINAL_STA is null then 4     -- Unknown to Unknown; this should not be used as we're converting nulls to 0
     when wwr.FINAL_STA='0'     then null  -- Unknown to Unknown
     when wwr.FINAL_STA='1'     then 1     -- Water Supply to Active
     when wwr.FINAL_STA='2'     then 2     -- Observation to Active
     when wwr.FINAL_STA='3'     then 3     -- Test Hole to Active
     when wwr.FINAL_STA='4'     then 4     -- Recharge to Active
     when wwr.FINAL_STA='5'     then 5     -- Abandoned Supply to Abandoned
     when wwr.FINAL_STA='6'     then 6     -- Abandoned Quality to Abandoned
     when wwr.FINAL_STA='7'     then 7     -- Unfinished to Abandoned
     when wwr.FINAL_STA='8'     then 8     -- Not A Well to Unknown
     when wwr.FINAL_STA='9'     then 9     -- Dewatering to Active
     when wwr.FINAL_STA='A'     then 10    -- Abandoned-Other to Abandoned
     when wwr.FINAL_STA='B'     then 11    -- Replacement Well to Unknown
     when wwr.FINAL_STA='C'     then 12    -- Alteration to Unknown
     when wwr.FINAL_STA='D'     then 13    -- Other Status to Unknown
	 when wwr.FINAL_STA='E'	  then 14	   -- Abandoned Monitoring and Test Hole to MOE Abandoned Monitoring and Test Hole
	 when wwr.FINAL_STA='F'	  then 15	   -- Abandoned Monitoring and Test Hole to MOE Abandoned Monitoring and Test Hole
     else -9999
 end 
 as [BH_STATUS_CODE]
from 
MOE_20250711.dbo.TblWWR as wwr
group by
FINAL_STA
order by 
FINAL_STA


select
 wwr.FINAL_STA
,case 
     when wwr.FINAL_STA is null then 4  -- Unknown to Unknown; this should not be used as we're converting nulls to 0
     when wwr.FINAL_STA='0'     then 4  -- Unknown to Uknown
     when wwr.FINAL_STA='1'     then 1  -- Water Supply to Active
     when wwr.FINAL_STA='2'     then 1  -- Observation to Active
     when wwr.FINAL_STA='3'     then 1  -- Test Hole to Active
     when wwr.FINAL_STA='4'     then 1  -- Recharge to Active
     when wwr.FINAL_STA='5'     then 3  -- Abandoned Supply to Abandoned
     when wwr.FINAL_STA='6'     then 3  -- Abandoned Quality to Abandoned
     when wwr.FINAL_STA='7'     then 3  -- Unfinished to Abandoned
     when wwr.FINAL_STA='8'     then 4  -- Not A Well to Unknown
     when wwr.FINAL_STA='9'     then 1  -- Dewatering to Active
     when wwr.FINAL_STA='A'     then 3  -- Abandoned-Other to Abandoned
     when wwr.FINAL_STA='B'     then 4  -- Replacement Well to Unknown
     when wwr.FINAL_STA='C'     then 4  -- Alteration to Unknown
     when wwr.FINAL_STA='D'     then 4  -- Other Status to Unknown
	 when wwr.FINAL_STA='E'	  then 17 -- Monitoring and Test Hole to MOE Monitoring and Test Hole
	 when wwr.FINAL_STA='F'	  then 18 -- Abandoned Monitoring and Test Hole to MOE Abandoned Monitoring and Test Hole
     else -9999
 end
 as [LOC_STATUS_CODE]
,case 
     when wwr.FINAL_STA is null then 4     -- Unknown to Unknown; this should not be used as we're converting nulls to 0
     when wwr.FINAL_STA='0'     then null  -- Unknown to Uknown
     when wwr.FINAL_STA='1'     then 1     -- Water Supply to Active
     when wwr.FINAL_STA='2'     then 2     -- Observation to Active
     when wwr.FINAL_STA='3'     then 3     -- Test Hole to Active
     when wwr.FINAL_STA='4'     then 4     -- Recharge to Active
     when wwr.FINAL_STA='5'     then 5     -- Abandoned Supply to Abandoned
     when wwr.FINAL_STA='6'     then 6     -- Abandoned Quality to Abandoned
     when wwr.FINAL_STA='7'     then 7     -- Unfinished to Abandoned
     when wwr.FINAL_STA='8'     then 8     -- Not A Well to Unknown
     when wwr.FINAL_STA='9'     then 9     -- Dewatering to Active
     when wwr.FINAL_STA='A'     then 10    -- Abandoned-Other to Abandoned
     when wwr.FINAL_STA='B'     then 11    -- Replacement Well to Unknown
     when wwr.FINAL_STA='C'     then 12    -- Alteration to Unknown
     when wwr.FINAL_STA='D'     then 13    -- Other Status to Unknown
	 when wwr.FINAL_STA='E'	  then 14	   -- Abandoned Monitoring and Test Hole to MOE Abandoned Monitoring and Test Hole
	 when wwr.FINAL_STA='F'	  then 15	   -- Abandoned Monitoring and Test Hole to MOE Abandoned Monitoring and Test Hole
     else -9999
 end 
 as [BH_STATUS_CODE]
into
MOE_20250711.dbo.YC_20250711_FINAL_STATUS
from 
MOE_20250711.dbo.TblWWR as wwr
group by
FINAL_STA
order by 
FINAL_STA

-- update FINAL_STA nulls to 0 in the tblWWR table 

-- v20180530 18220 rows
-- v20190509 25614 rows
-- v20200721 23357 rows
-- v20210119 27088 rows
-- v20220328 41872 rows
-- v20230324 62706 rows
-- v20240326 70265 rows
-- v20250711 82564 rows

update MOE_20250711.dbo.[TblWWR]
set
FINAL_STA=0
where
FINAL_STA is null






