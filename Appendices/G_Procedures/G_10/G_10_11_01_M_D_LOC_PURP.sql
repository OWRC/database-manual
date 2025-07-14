
--***** G_10_11_01

--***** extract D_LOCATION_PURPOSE equivalent

-- we're using ther previously prepared look-up table YC_20130923_MOE_USE
-- to determine the primary and secondary purpose for each location; in some
-- cases, the BH_STATUS_CODE also influences the primary and secondary purpose;

-- note that the end of the query is tagged with the text END_TAG
-- the secondary purpose section is tagged with the text SECONDARY_PURPOSE

select
 dloc.LOC_ID 
,case 
--***** MOE USE1 0 - Undefined
when dloc.LOC_MOE_USE_1ST_CODE=0 then 
    case
    -- MOE USE2 0 - Undefined
    when dloc.LOC_MOE_USE_2ND_CODE=0 then
        case
        when dbore.BH_STATUS_CODE is null then 11 -- Unknown
        when dbore.BH_STATUS_CODE in (1,5,6) then 10 -- Water Supply
        when dbore.BH_STATUS_CODE in (2,3,4,14,15) then 3 -- Engineering
        when dbore.BH_STATUS_CODE in (9) then 4 -- Dewatering
        when dbore.BH_STATUS_CODE in (7,8,10,11,12,13) then 11 -- Unknown
        else null
        end
    -- MOE USE2 1 - Domestic
    when dloc.LOC_MOE_USE_2ND_CODE=1 then
        case
        when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
        when dbore.BH_STATUS_CODE in (1,5) then 10 -- Water Supply
        when dbore.BH_STATUS_CODE in (12) then 3 -- Engineering
        else null
        end
    -- MOE USE2 3 - Irrigation
    when dloc.LOC_MOE_USE_2ND_CODE=3 then
        case
        when dbore.BH_STATUS_CODE in (1) then 1 -- Agricultural
        else null
        end
    -- MOE USE2 9 - Not used
    when dloc.LOC_MOE_USE_2ND_CODE=9 then
        case
        when dbore.BH_STATUS_CODE is null then 11 -- Unknown
        when dbore.BH_STATUS_CODE in (2,3,6) then 3 -- Engineering
        when dbore.BH_STATUS_CODE in (10) then 11 -- Unknown
        else null
        end
    -- MOE USE2 10 - Other
    when dloc.LOC_MOE_USE_2ND_CODE=10 then
        case
        when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
        when dbore.BH_STATUS_CODE in (2) then 3 -- Engineering
        when dbore.BH_STATUS_CODE in (10) then 11 -- Unknown
        else null
        end
    -- MOE USE2 11 - Test Hole
    when dloc.LOC_MOE_USE_2ND_CODE=11 then
        case
        when dbore.BH_STATUS_CODE in (2,3) then 3 -- Engineering
        else null
        end
    ---- MOE USE2 13 - Monitoring
    when dloc.LOC_MOE_USE_2ND_CODE=13 then
        case 
        when dbore.BH_STATUS_CODE is null then 3 -- Engineering
        when dbore.BH_STATUS_CODE in (2,3,10) then 3 -- Engineering
        else null
        end
    ---- MOE USE2 14 - Monitoring and Test Hole
    when dloc.LOC_MOE_USE_2ND_CODE=14 then
        case
        when dbore.BH_STATUS_CODE is null then 3 -- Engineering
        when dbore.BH_STATUS_CODE in (14) then 3 -- Engineering
        else null
        end
    else null
    end
--***** MOE USE1 1 - Domestic
 when dloc.LOC_MOE_USE_1ST_CODE=1 then 
     case 
     -- MOE USE2 0 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case
         when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (1,5,7,10,11,13) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (2,3,4,6,12) then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (8) then 11 -- Unknown
         when dbore.BH_STATUS_CODE in (9) then 4 -- Dewatering
         else null
         end 
	-- MOE USE2 1 - Domestic
	when dloc.LOC_MOE_USE_2ND_CODE=1 then 
	     case 
		 when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
		 when dbore.BH_STATUS_CODE in (1,12) then 10 -- Water Supply
		 else null 
		 end 
     -- MOE USE2 2 - Livestock
     when dloc.LOC_MOE_USE_2ND_CODE=2 then 
         case 
		 when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (1,5,6,7,8,10,11,12) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (2) then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (9) then 4 -- Dewatering
         else null 
         end 
     -- MOE USE2 3 - Irrigation
     when dloc.LOC_MOE_USE_2ND_CODE=3 then 
         case 
		 when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (1,5) then 10 -- Water Supply
         else null 
         end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (1,5,6,7,10,11,12,13) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (2,3,4) then 3 -- Engineering
         when dbore.BH_STATUS_CODE=9 then 4 -- Dewatering
         when dbore.BH_STATUS_CODE=15 then 3 -- Engineering
         else null 
         end
     -- MOE USE2 5 - Commercial
     when dloc.LOC_MOE_USE_2ND_CODE=5 then 
         case 
         when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (1,5,6,7,10,11,12) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (3,4) then 3 -- Engineering
         else null 
         end 
     -- MOE USE2 6 - Municipal
     when dloc.LOC_MOE_USE_2ND_CODE=6 then 
         case 
         when dbore.BH_STATUS_CODE in (1,5,6,7,10) then 10 -- Water Supply
         else null 
         end 
     -- MOE USE2 7 - Public Supply
     when dloc.LOC_MOE_USE_2ND_CODE=7 then 
         case 
         when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (1,3,5,10,11,12) then 10 -- Water Supply
         else null 
         end 
     -- MOE USE2 8 - Cooling or A/C
     when dloc.LOC_MOE_USE_2ND_CODE=8 then 
         case
         when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (1,6) then 10 -- Water Supply
	    when dbore.BH_STATUS_CODE in (4) then 3  -- Engineering
	    when dbore.BH_STATUS_CODE in (9) then 4 -- Dewatering
         else null 
         end 
     -- MOE USE2 9 - Not Used
     when dloc.LOC_MOE_USE_2ND_CODE=9 then 
         case 
         when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (1,5,6,7,10,13) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (2,3,4) then 3 -- Engineering
         else null 
         end
     -- MOE USE2 10 - Other
     when dloc.LOC_MOE_USE_2ND_CODE=10 then 
         case 
		 when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
           when dbore.BH_STATUS_CODE in (1,5,6,7,10,13) then 10 -- Water Supply
		 when dbore.BH_STATUS_CODE in (9) then 4 -- Dewatering
         else null 
         end 
     -- MOE USE2 11 - Test Hole
     when dloc.LOC_MOE_USE_2ND_CODE=11 then 
         case
         when dbore.BH_STATUS_CODE in (1,5,6,7,10) then 10 -- Water Supply
	    when dbore.BH_STATUS_CODE in (2,3) then 3 -- Engineering
	    when dbore.BH_STATUS_CODE in (11) then 10 -- Water Supply
         else null  
         end 
     when dloc.LOC_MOE_USE_2ND_CODE=12 then
         case
         when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (9) then 4 -- Dewatering
         else null
         end
     when dloc.LOC_MOE_USE_2ND_CODE=13 then 
         case 
           when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
           when dbore.BH_STATUS_CODE in (1,5,6,7,10) then 10 -- Water Supply
		 when dbore.BH_STATUS_CODE in (2,3) then 3 -- Engineering
		 when dbore.BH_STATUS_CODE in (9) then 4 -- Dewatering
         else null 
         end
     else null
     end
 --***** MOE USE1  2 - Livestock
 when dloc.LOC_MOE_USE_1ST_CODE=2 then 
     case 
     -- MOE USE2 0 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case
         when dbore.BH_STATUS_CODE is null then 1 -- Agriculture
         when dbore.BH_STATUS_CODE in (1,4,5,6,10,11,12) then 1 -- Agriculture
         when dbore.BH_STATUS_CODE in (2,3) then 2 -- Engineering
         when dbore.BH_STATUS_CODE in (9) then 4 -- Dewatering
         else null
         end
     -- MOE USE2 1 - Domestic
     when dloc.LOC_MOE_USE_2ND_CODE=1 then 
         case 
         when dbore.BH_STATUS_CODE in (1,13) then 1 -- Agriculture
         else null 
         end 
     -- MOE USE2 3 - Irrigation
     when dloc.LOC_MOE_USE_2ND_CODE=3 then
         case
         when dbore.BH_STATUS_CODE in (1,5) then 1 -- Agriculture
         end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 1 -- Agriculture
         when dbore.BH_STATUS_CODE in (1,5,6,7,10,11,12) then 1 -- Agriculture
         else null 
         end
     -- MOE USE2 5 - Commercial
	 when dloc.LOC_MOE_USE_2ND_CODE=5 then
	     case
		 when dbore.BH_STATUS_CODE=1 then 1 -- Agriculture
		 else null
		 end
      -- MOE USE2 6 - Municipal
      when dloc.LOC_MOE_USE_2ND_CODE=6 then
          case
          when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
          else null
          end
      -- MOE USE2 9 - Not Used
      when dloc.LOC_MOE_USE_2ND_CODE=9 then 
          case
          when dbore.BH_STATUS_CODE in (5,10) then 1 -- Agriculture
          else null
          end 
	 -- MOE USE2 10 - Other 
	 when dloc.LOC_MOE_USE_2ND_CODE=10 then 
	     case 
		 when dbore.BH_STATUS_CODE is null then 1 -- Agriculture
		 else null 
		 end
     else null
     end
 --***** MOE USE1  3 - Irrigation
 when dloc.LOC_MOE_USE_1ST_CODE=3 then 
     case 
     -- MOE USE2 0 -- Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case
         when dbore.BH_STATUS_CODE is null then 1 -- Agricultural
         when dbore.BH_STATUS_CODE in (1,2,3,4,5,10,11,12) then 1 -- Agricultural
         else null
         end
     -- MOE USE2 1 - Domestic
     when dloc.LOC_MOE_USE_2ND_CODE=1 then
         case
         when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
         else null
         end
     -- MOE USE2 2 -- Livestock
     when dloc.LOC_MOE_USE_2ND_CODE=2 then
         case
         when dbore.BH_STATUS_CODE in (1) then 1 -- Water Supply
         else null
         end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 1 -- Agriculture
         when dbore.BH_STATUS_CODE in (1,2,3,5,10,11,12) then 1 -- Agriculture
         when dbore.BH_STATUS_CODE in (4) then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (9) then 4 -- Dewatering
         else null 
         end
     -- MOE USE2 5 - Commercial
     when dloc.LOC_MOE_USE_2ND_CODE=5 then 
         case 
         when dbore.BH_STATUS_CODE is null then 1 -- Agriculture
         when dbore.BH_STATUS_CODE=1 then 1 -- Agriculture
         else null 
         end
     -- MOE USE2 6 - Municipal
     when dloc.LOC_MOE_USE_2ND_CODE=6 then
         case
         when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
         else null
         end
     -- MOE USE2 7 - Public Supply
     when dloc.LOC_MOE_USE_2ND_CODE=7 then
         case
         when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
         else null
         end
     -- MOE USE2 9 - Not Used
     when dloc.LOC_MOE_USE_2ND_CODE=9 then
         case
         when dbore.BH_STATUS_CODE in (5) then 1 -- Agricultural
         else null
         end
     -- MOE USE2 10 - Other
     when dloc.LOC_MOE_USE_2ND_CODE=10 then 
         case
         when dbore.BH_STATUS_CODE=1 then 1 -- Agriculture
         else null  
         end 
	 -- MOE USE2 11 -- Test Hole
	 when dloc.LOC_MOE_USE_2ND_CODE=11 then 
	     case 
		 when dbore.BH_STATUS_CODE in (1,3,15) then 3 -- Engineering
		 else null 
		 end 
     -- MOE USE2 13 - Monitoring
     when dloc.LOC_MOE_USE_2ND_CODE=13 then 
         case 
         when dbore.BH_STATUS_CODE=2 then 1 -- Agriculture
         when dbore.BH_STATUS_CODE=9 then 4 -- Dewatering
         else null 
         end
     else null
     end
 --***** MOE USE1  4 - Industrial
 when dloc.LOC_MOE_USE_1ST_CODE=4 then 
     case 
     -- MOE USE2 0 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case
         when dbore.BH_STATUS_CODE is null then 5 -- Industrial
         when dbore.BH_STATUS_CODE in (1,5,10) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (2,3) then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (9) then 4 -- Dewatering
         else null
         end
     -- MOE USE2 1 - Domestic
     when dloc.LOC_MOE_USE_2ND_CODE=1 then 
         case 
         when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (1,5,10) then 10 -- Water Supply
         else null 
         end 
	 -- MOE USE2 2 - Livestock
	 when dloc.LOC_MOE_USE_2ND_CODE=2 then 
	     case 
		 when dbore.BH_STATUS_CODE in (5) then 10 -- Water Supply
		 else null 
		 end 
	 -- MOE USE2 3 - Irrigation
	 when dloc.LOC_MOE_USE_2ND_CODE=3 then 
	     case 
		 when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
		 when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
		 else null 
		 end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 5 -- Industrial
         when dbore.BH_STATUS_CODE=1 then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (2,3,4,5,6,7,10,11,12,13) then 5 -- Industrial
         when dbore.BH_STATUS_CODE=9 then 4 -- Dewatering
		 when dbore.BH_STATUS_CODE in (14,15) then 3 -- Engineering
         else null 
         end
	 -- MOE USE2 5 - Commercial
	 when dloc.LOC_MOE_USE_2ND_CODE=5 then 
	     case 
		 when dbore.BH_STATUS_CODE in (1,5) then 10 -- Water Supply
		 else null 
		 end 
	 -- MOE USE2 6 - Municipal
	 when dloc.LOC_MOE_USE_2ND_CODE=6 then 
	     case 
	     when dbore.BH_STATUS_CODE in (2) then 10 -- Water Supply
		when dbore.BH_STATUS_CODE in (9) then 4 -- Dewatering
		else null 
		end 
     -- MOE USE2 7 - Public Supply
     when dloc.LOC_MOE_USE_2ND_CODE=7 then 
         case 
         when dbore.BH_STATUS_CODE is null then 5 -- Industrial
         when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
         else null
         end
     -- MOE USE2 9 - Not Used
     when dloc.LOC_MOE_USE_2ND_CODE=9 then 
         case 
         when dbore.BH_STATUS_CODE is null then 5 -- Industrial
         when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (5,6,7,10,13) then 5 -- Industrial
         else null 
         end
     -- MOE USE2 10 - Other
     when dloc.LOC_MOE_USE_2ND_CODE=10 then 
         case 
         when dbore.BH_STATUS_CODE is null then 5 -- Industrial
         when dbore.BH_STATUS_CODE in (1,4,5,6,7,10,13) then 5 -- Industrial
         else null 
         end 
     -- MOE USE2 11 - Test Hole
     when dloc.LOC_MOE_USE_2ND_CODE=11 then 
         case
         when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (2,3,5,6,7,10,11) then 5 -- Industrial
         else null  
         end 
	 -- MOE USE2 12 - Dewatering
	 when dloc.LOC_MOE_USE_2ND_CODE=12 then 
	     case 
		 when dbore.BH_STATUS_CODE in (2) then 3 -- Engineering
		 when dbore.BH_STATUS_CODE in (9,10) then 4 -- Dewatering
		 else null 
		 end
     -- MOE USE2 13 - Monitoring
     when dloc.LOC_MOE_USE_2ND_CODE=13 then 
         case 
         when dbore.BH_STATUS_CODE is null then 5 -- Industrial
         when dbore.BH_STATUS_CODE in (2,3,5,10,13,14,15) then 5 -- Industrial
         else null 
         end 
     else null
     end     
 --***** MOE USE1  5 - Commercial
 when dloc.LOC_MOE_USE_1ST_CODE=5 then 
     case 
     -- MOE USE2 0 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case
         when dbore.BH_STATUS_CODE is null then 2 -- Commercial
         when dbore.BH_STATUS_CODE in (1,5) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (2,3,6) then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (9) then 4 -- Dewatering
         when dbore.BH_STATUS_CODE in (10,11,12) then 2 -- Commercial
         else null
         end
     -- MOE USE2 1 - Domestic
     when dloc.LOC_MOE_USE_2ND_CODE=1 then
         case
         when dbore.BH_STATUS_CODE=1 then 10 -- Water Supply
         else null
         end
     -- MOE USE2 2 - Livestock
     when dloc.LOC_MOE_USE_2ND_CODE=2 then
         case
         when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
         else null
         end
     -- MOE_USE2 3 - Irrigation
     when dloc.LOC_MOE_USE_2ND_CODE=3 then 
         case
         when dbore.BH_STATUS_CODE is null then 1 -- Agriculture
         when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
         else null
         end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (1,5,6,7,10,11,12,13) then 10 -- Water Supply
		 when dbore.BH_STATUS_CODE in (2,3,4) then 3 -- Engineering
         when dbore.BH_STATUS_CODE=9 then 4 -- Dewatering
         else null 
         end
     -- MOE USE2 6 - Municipal
     when dloc.LOC_MOE_USE_2ND_CODE=6 then 
         case 
         when dbore.BH_STATUS_CODE=1 then 10 -- Water Supply
         else null 
         end 
     -- MOE USE2 7 - Public Supply
     when dloc.LOC_MOE_USE_2ND_CODE=7 then
         case
         when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
         else null
         end
     -- MOE USE2 8 - Cooling or A/C
     when dloc.LOC_MOE_USE_2ND_CODE=8 then
         case
         when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
         else null
         end
     -- MOE USE2 9 - Not Used
     when dloc.LOC_MOE_USE_2ND_CODE=9 then 
         case 
         when dbore.BH_STATUS_CODE is null then 2 -- Commercial
         when dbore.BH_STATUS_CODE in (4,10) then 2 -- Commercial
         when dbore.BH_STATUS_CODE in (5) then 10 -- Water Supply
         else null 
         end
     -- MOE USE2 10 - OTHER
     when dloc.LOC_MOE_USE_2ND_CODE=10 then
         case
         when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (10) then 2 -- Commerical
         else null
         end
     -- MOE USE2 11 - Test Hole
     when dloc.LOC_MOE_USE_2ND_CODE=11 then
         case 
         when dbore.BH_STATUS_CODE is null then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (1,2) then 3  -- Engineering
         else null
         end
     -- MOE USE2 12 - Dewatering
     when dloc.LOC_MOE_USE_2ND_CODE=12 then 
         case 
         when dbore.BH_STATUS_CODE=9 then 4 -- Dewatering
         else null 
         end
     -- MOE USE2 13 - Monitoring
     when dloc.LOC_MOE_USE_2ND_CODE=13 then 
         case 
         when dbore.BH_STATUS_CODE is null then 3 -- Engineering
		 when dbore.BH_STATUS_CODE in (2) then 3 -- Engineering
         else null 
         end
     else null
     end     
 --***** MOE USE1  6 - Municipal
 when dloc.LOC_MOE_USE_1ST_CODE=6 then 
     case 
     -- MOE USE2 0 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case
         when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (1,4,5,6,10,11,12,13) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (2,3) then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (8) then 11 -- Unknown
         when dbore.BH_STATUS_CODE in (9) then 4 -- Dewatering
         else null
         end
     -- MOE USE2 1 - Domestic
     when dloc.LOC_MOE_USE_2ND_CODE=1 then
         case 
         when dbore.BH_STATUS_CODE in (1,4) then 10 -- Water Supply
         else null
         end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (1,2,3,5,6,7,10,11,12,13,14) then 10 -- Water Supply
         else null 
         end
     -- MOE USE2 5 - Commercial
     when dloc.LOC_MOE_USE_2ND_CODE=5 then
         case
         when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
         else null
         end  
     -- MOE USE2 7 - Public Supply
     when dloc.LOC_MOE_USE_2ND_CODE=7 then
         case
         when dbore.BH_STATUS_CODE in (1,10) then 10 -- Water Supply
         else null
         end 
	-- MOE USE2 8 - Cooling or A/C
     when dloc.LOC_MOE_USE_2ND_CODE=8 then 
	    case 
	    when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
	    when dbore.BH_STATUS_CODE in (9) then 4 -- Dewatering
	    else null 
	    end
     -- MOE USE2 9 - Not Used
     when dloc.LOC_MOE_USE_2ND_CODE=9 then 
         case 
         when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (2,3,5,6,7,10) then 10 -- Water Supply
         else null 
         end
	 -- MOE USE2 10 - Other
	 when dloc.LOC_MOE_USE_2ND_CODE=10 then 
	     case 
		 when dbore.BH_STATUS_CODE in (1,10) then 10 -- Water Supply
		 else null 
		 end
     -- MOE USE2 11 - Test Hole
     when dloc.LOC_MOE_USE_2ND_CODE=11 then 
         case
         when dbore.BH_STATUS_CODE in (1,2,3,5,6,7,10,13,14) then 10 -- Water Supply
         else null  
         end 
     -- MOE USE2 12 - Dewatering
     when dloc.LOC_MOE_USE_2ND_CODE=12 then 
         case
		 when dbore.BH_STATUS_CODE in (2) then 3 -- Engineering
		 when dbore.BH_STATUS_CODE in (9) then 4 -- Dewatering
         when dbore.BH_STATUS_CODE in (10,11) then 10 -- Water Supply
         else null  
         end          
     -- MOE USE2 13 - Monitoring
     when dloc.LOC_MOE_USE_2ND_CODE=13 then 
         case 
         when dbore.BH_STATUS_CODE in (2,3,4,10,14) then 10 -- Water Supply
         else null 
         end
     -- MOE USE2 14 - Monitoring and Test Hole
     when dloc.LOC_MOE_USE_2ND_CODE=14 then
         case
         when dbore.BH_STATUS_CODE in (14) then 10 -- Water Supply
         else null
         end
     else null
     end    
 --***** MOE USE1  7 - Public Supply
 when dloc.LOC_MOE_USE_1ST_CODE=7 then 
     case 
     -- MOE USE2 0 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case 
         when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (1,5,6,10,11,13) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (2,3,12) then 3 -- Engineering
         else null
         end
     -- MOE USE2 1 - Domestic
     when dloc.LOC_MOE_USE_2ND_CODE=1 then 
         case 
         when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (1,5,6,7,10,11,13) then 10 -- Water Supply
         else null 
         end 
     -- MOE USE2 2 - Livestock
     when dloc.LOC_MOE_USE_2ND_CODE=2 then
         case
         when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
         else null
         end
     -- MOE USE2 3 - Irrigation
     when dloc.LOC_MOE_USE_2ND_CODE=3 then
         case
         when dbore.BH_STATUS_CODE=1 then 10 -- Water Supply
         else null
         end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (1,3,4,5,6,7,10,11,12,13) then 10 -- Water Supply
         else null 
         end
	 -- MOE USE2 5 - Commercial
	 when dloc.LOC_MOE_USE_2ND_CODE=5 then 
	     case 
		 when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
		 when dbore.BH_STATUS_CODE in (1,10) then 10 -- Water Supply
		 when dbore.BH_STATUS_CODE in (2) then 3 -- Engineering
		 else null
		 end
     -- MOE USE2 6 - Municipal
     when dloc.LOC_MOE_USE_2ND_CODE=6 then 
         case 
         when dbore.BH_STATUS_CODE in (1,3,10) then 10 -- Water Supply
		 when dbore.BH_STATUS_CODE in (15) then 3 -- Engineering
         else null 
         end 
     -- MOE USE2 10 - Other
     when dloc.LOC_MOE_USE_2ND_CODE=10 then 
         case 
         when dbore.BH_STATUS_CODE=1 then 10 -- Water Supply
         else null 
         end 
     -- MOE USE2 11 - Test Hole
     when dloc.LOC_MOE_USE_2ND_CODE=11 then
         case
         when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (2) then 3 -- Engineering
         else null
         end
     -- MOE USE2 13 - Monitoring
     when dloc.LOC_MOE_USE_2ND_CODE=13 then 
         case
         when dbore.BH_STATUS_CODE in (5,10) then 10 -- Water Supply
         else null  
         end 
     else null
     end  
 --***** MOE USE1  8 - Cooling or A/C
 when dloc.LOC_MOE_USE_1ST_CODE=8 then 
     case 
     -- MOE USE2 0 - Undefined
     when dloc.loC_MOE_USE_2ND_CODE=0 then
         case
         when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (1,4,5,10) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (2,11,13) then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (9) then 4 -- Dewatering
         else null
         end
     -- MOE USE2 1 - Domestic
     when dloc.LOC_MOE_USE_2ND_CODE=1 then
         case
         when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
         else null
         end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 3 -- Engineering
	    when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (4,12,13) then 3 -- Engineering
         else null 
         end
	 -- MOE USE2 9 - Not Used
	 when dloc.LOC_MOE_USE_2ND_CODE=9 then 
	     case 
		 when dbore.BH_STATUS_CODE in (5) then 10 -- Water Supply
		 else null 
		 end
     -- MOE USE2 10 - Other
     when dloc.LOC_MOE_USE_2ND_CODE=10 then 
         case 
	    when dbore.BH_STATUS_CODE is null then 3 -- Engineering
	    when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (4,13) then 3 -- Engineering
         else null 
         end 
	 -- MOE USE2 13 - Monitoring
	 when dloc.LOC_MOE_USE_2ND_CODE=13 then
	     case 
		 when dbore.BH_STATUS_CODE in (2,14) then 3 -- Engineering
		 else null 
		 end
     else null
     end    
 --***** MOE USE1  9 - Not Used
 when dloc.LOC_MOE_USE_1ST_CODE=9 then 
     case 
     -- MOE USE2 0 -- Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case
         when dbore.BH_STATUS_CODE is null then 11 -- Unknown
         when dbore.BH_STATUS_CODE in (1,5,6,10) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (2,3,4,11,14,15) then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (7,8,12,13) then 11 -- Unknown
         when dbore.BH_STATUS_CODE in (9) then 4 -- Dewatering
         else null
         end
     -- MOE USE2 1 - Domestic
     when dloc.LOC_MOE_USE_2ND_CODE=1 then 
         case 
         when dbore.BH_STATUS_CODE in (10) then 10 -- Water Supply
         else null
         end
     -- MOE USE2 2 - Livestock
     when dloc.LOC_MOE_USE_2ND_CODE=2 then
         case
         when dbore.BH_STATUS_CODE in ( 10 ) then 1 -- Agricultural
         else null
         end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 5 -- Industrial
         when dbore.BH_STATUS_CODE in (1,2,3,5,6,7,10,11,12,13) then 5 -- Industrial
         when dbore.BH_STATUS_CODE in (4,14,15) then 3 -- Engineering
         else null 
         end
     -- MOE USE2 5 - Commercial
     when dloc.LOC_MOE_USE_2ND_CODE=5 then 
         case 
         when dbore.BH_STATUS_CODE=4 then 2 -- Commercial
         else null 
         end 
     -- MOE USE2 6 - Municipal
     when dloc.LOC_MOE_USE_2ND_CODE=6 then 
         case
         when dbore.BH_STATUS_CODE in (1,3) then 10 -- Water Supply
         else null
         end
     -- MOE USE2 7 - Public Supply
     when dloc.LOC_MOE_USE_2ND_CODE=7 then
         case
         when dbore.BH_STATUS_CODE is null then 10
         when dbore.BH_STATUS_CODE in (7) then 10
         else null
         end 
     -- MOE USE2 8 -- Cooling or A/C
     when dloc.LOC_MOE_USE_2ND_CODE=8 then
         case
         when dbore.BH_STATUS_CODE in (4) then 10 -- Water Supply
         else null
         end
     -- MOE USE2 9 - Not Used
     when dloc.LOC_MOE_USE_2ND_CODE=9 then 
         case 
         when dbore.BH_STATUS_CODE=2 then 3 -- Engineering
         else null 
         end
     -- MOE USE2 10 - Other
     when dloc.LOC_MOE_USE_2ND_CODE=10 then 
         case 
         when dbore.BH_STATUS_CODE in (2) then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (5,6,7,10) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (13) then 11 -- Unknown
         else null 
         end 
     -- MOE USE2 11 - Test Hole
     when dloc.LOC_MOE_USE_2ND_CODE=11 then
         case
         when dbore.BH_STATUS_CODE in (3,10) then 3 -- Engineering
         else null
         end
     -- MOE USE2 12 - Dewatering
     when dloc.LOC_MOE_USE_2ND_CODE=12 then 
         case 
         when dbore.BH_STATUS_CODE is null then 4 -- Dewatering
         when dbore.BH_STATUS_CODE in (5,6,7,10) then 4 -- Dewatering
         else null 
         end
     -- MOE USE2 13 - Monitoring
     when dloc.LOC_MOE_USE_2ND_CODE=13 then 
         case 
         when dbore.BH_STATUS_CODE is null then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (2,3,5,6,7,10,13) then 3 -- Engineering
         else null 
         end
     -- MOE USE2 14 - Monitoring and Test Hole
     when dloc.LOC_MOE_USE_2ND_CODE=14 then
         case
         when dbore.BH_STATUS_CODE in (10,15) then 3 -- Engineering
         else null
         end
     else null
     end
 --***** MOE USE1 10 - Other
 when dloc.LOC_MOE_USE_1ST_CODE=10 then 
     case 
     -- MOE USE2 0 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case
         when dbore.BH_STATUS_CODE is null then 11 -- Unknown
         when dbore.BH_STATUS_CODE in (1,5,6,10) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (2,3,4,11,14,15) then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (12,13) then 11 -- Unknown
         else null
         end
     -- MOE USE2 1 - Domestic
     when dloc.LOC_MOE_USE_2ND_CODE=1 then
         case
         when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
         else null
         end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (1,5,6,7,10,13) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (2,4) then 5 -- Industrial
         when dbore.BH_STATUS_CODE in (3,11,14) then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (9) then 4 -- Dewatering
         else null 
         end
     -- MOE USE2 9 - Not Used
     when dloc.LOC_MOE_USE_2ND_CODE=9 then 
         case 
         when dbore.BH_STATUS_CODE in (3) then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (5,6,7,10) then 10 -- Water Supply
         else null 
         end
     -- MOE USE2 10 - Other
     when dloc.LOC_MOE_USE_2ND_CODE=10 then 
         case 
         when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (10) then 10 -- Water Supply
         else null 
         end 
	 -- MOE USE2 11 - Test Hole
	 when dloc.LOC_MOE_USE_2ND_CODE=11 then
	     case 
	     when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
		when dbore.BH_STATUS_CODE in (3,13,14) then 3 -- Engineering
		else null 
		end
     -- MOE USE2 13 - Monitoring
     when dloc.LOC_MOE_USE_2ND_CODE=13 then 
         case 
         when dbore.BH_STATUS_CODE is null then 3 -- Engineering
		 when dbore.BH_STATUS_CODE in (2,6,13,14) then 3 -- Engineering
         else null 
         end 
     else null
     end    
 --***** MOE USE1 11 - Test Hole
 when dloc.LOC_MOE_USE_1ST_CODE=11 then 
     case 
     -- MOE USE2 0 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case
         when dbore.BH_STATUS_CODE is null then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (1,5,6) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (2,3,9,10,12,13,14,15) then 3 -- Engineering
         else null
         end
     -- MOE USE2 3 - Irrigation
     when dloc.LOC_MOE_USE_2ND_CODE=3 then
         case
         when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
         else null
         end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (1,2,3,5,6,7,10,11,13,14,15) then 3 -- Engineering
		 when dbore.BH_STATUS_CODE in (9) then 4 -- Dewatering
         else null 
         end
     -- MOE USE2 5 - Commercial
     when dloc.LOC_MOE_USE_2ND_CODE= 5 then
         case 
         when dbore.BH_STATUS_CODE in (12) then 3 -- Engineering
         else null
         end
     -- MOE USE2 6 - Municipal
     when dloc.LOC_MOE_USE_2ND_CODE=6 then 
         case 
         when dbore.BH_STATUS_CODE is null then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (1,2,3,5,10) then 10 -- Water Supply
		 when dbore.BH_STATUS_CODE in (14) then 3 -- Engineering
         else null 
         end 
     -- MOE USE2 8 - Cooling or A/C
     when dloc.LOC_MOE_USE_2ND_CODE=8 then 
         case
         when dbore.BH_STATUS_CODE in (1) then 5 -- Industrial
         when dbore.BH_STATUS_CODE in (2,3) then 3 -- Engineering
         else null 
         end 
     -- MOE USE2 9 - Not Used
     when dloc.LOC_MOE_USE_2ND_CODE=9 then 
         case 
         when dbore.BH_STATUS_CODE is null then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (2,3,10,14,15) then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (5,6) then 10 -- Water Supply
         else null 
         end
     -- MOE USE2 10 - Other
     when dloc.LOC_MOE_USE_2ND_CODE=10 then 
         case 
         when dbore.BH_STATUS_CODE in (3,10,13,14) then 3 -- Engineering
         else null 
         end
     -- MOE USE2 11 - Test Hole
     when dloc.LOC_MOE_USE_2ND_CODE=11 then
         case
         when dbore.BH_STATUS_CODE in (3,10) then 3 -- Engineering
         else null
         end 
     -- MOE USE2 12 - Dewatering
     when dloc.LOC_MOE_USE_2ND_CODE=12 then 
         case 
	    when dbore.BH_STATUS_CODE is null then 4 -- Dewatering
         when dbore.BH_STATUS_CODE in (2,3,9,10,11,14) then 4 -- Dewatering
         else null 
         end
     -- MOE USE2 13 - Monitoring
     when dloc.LOC_MOE_USE_2ND_CODE=13 then 
         case 
         when dbore.BH_STATUS_CODE is null then 3 -- Engineering
		 when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (2,3,4,5,6,7,8,10,11,12,13,14,15) then 3 -- Engineering
         when dbore.BH_STATUS_CODE=9 then 4 -- Dewatering
         else null 
         end
     else null
     end   
 --***** MOE USE1 12 - Dewatering
 when dloc.LOC_MOE_USE_1ST_CODE=12 then 
     case 
     -- MOE USE2 0 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case
         when dbore.BH_STATUS_CODE is null then 4 -- Dewatering 
         when dbore.BH_STATUS_CODE in (1,5,9,10) then 4 -- Dewatering
         when dbore.BH_STATUS_CODE in (2,3,11,12) then 3 -- Engineering
         else null
         end 
	 -- MOE USE2 2 - Livestock
	 when dloc.LOC_MOE_USE_2ND_CODE=2 then 
	     case 
	     when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
	     when dbore.BH_STATUS_CODE in (10) then 4 -- Dewatering
		else null 
		end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 4 -- Dewatering
         when dbore.BH_STATUS_CODE in (1,2,3,5,6,7,9,10,14) then 4 -- Dewatering
         else null 
         end
     -- MOE USE2 5 - Commericial
     when dloc.LOC_MOE_USE_2ND_CODE=5 then
         case
         when dbore.BH_STATUS_CODE in (1,9) then 4 -- Dewatering
         end
     -- MOE USE2 6 - Municipal
     when dloc.LOC_MOE_USE_2ND_CODE=6 then 
         case
         when dbore.BH_STATUS_CODE in (4) then 4 -- Dewatering
         else null
         end
     -- MOE USE2 10 - Other
	when dloc.LOC_MOE_USE_2ND_CODE=10 then 
	     case 
		 when dbore.BH_STATUS_CODE in (9) then 4 -- Dewatering
		 else null
		 end
     -- MOE USE2 11 - Test Hole
     when dloc.LOC_MOE_USE_2ND_CODE=11 then 
         case
         when dbore.BH_STATUS_CODE in (3,9) then 4 -- Dewatering
         else null  
         end 
     -- MOE USE2 13 - Monitoring
     when dloc.LOC_MOE_USE_2ND_CODE=13 then 
         case 
         when dbore.BH_STATUS_CODE in (2,3,9,10,14) then 4 -- Dewatering
         else null 
         end
     else null
     end   
 --***** MOE USE1 13 - Monitoring
 when dloc.LOC_MOE_USE_1ST_CODE=13 then 
     case 
     -- MOE USE2 0 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case
         when dbore.BH_STATUS_CODE is null then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (1,5,6) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (2,3,4,10,11,12,13,14,15) then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (9) then 4 -- Dewatering
         else null
         end
     -- MOE USE2 3 - Irrigation
     when dloc.LOC_MOE_USE_2ND_CODE=3 then 
         case 
         when dbore.BH_STATUS_CODE in (2,9) then 1 -- Agriculture
         else null 
         end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 3 -- Engineering
		 when dbore.BH_STATUS_CODE in (1) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (2,3,4,5,6,7,10,11,12,13,14,15) then 3 -- Engineering
         when dbore.BH_STATUS_CODE=9 then 4 -- Dewatering
         else null 
         end
     -- MOE USE2 6 - Municipal
     when dloc.LOC_MOE_USE_2ND_CODE=6 then
         case
         when dbore.BH_STATUS_CODE in (3) then 3 -- Engineering
         else null
         end
     -- MOE USE2 7 -- Public Supply
     when dloc.LOC_MOE_USE_2ND_CODE=7 then
         case
         when dbore.BH_STATUS_CODE in (11) then 3 -- Engineering
         else null
         end
     -- MOE USE2 8 -- Cooling or A/C
     when dloc.LOC_MOE_USE_2ND_CODE=8 then
         case
         when dbore.BH_STATUS_CODE in (3) then 3 -- Engineering
         else null
         end
     -- MOE USE2 9 - Not Used
     when dloc.LOC_MOE_USE_2ND_CODE=9 then 
         case 
         when dbore.BH_STATUS_CODE is null then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (2,10) then 3 -- Engineering
         else null 
         end
     -- MOE USE2 10 - Other
     when dloc.LOC_MOE_USE_2ND_CODE=10 then 
         case 
         when dbore.BH_STATUS_CODE is null then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (2,4,10,11,13) then 3 -- Engineering
         else null 
         end 
     -- MOE USE2 11 - Test Hole
     when dloc.LOC_MOE_USE_2ND_CODE=11 then 
         case
         when dbore.BH_STATUS_CODE is null then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (2,3,5,6,7,10,13,14,15) then 3 -- Engineering
         else null  
         end 
     -- MOE USE2 12 - Dewatering
     when dloc.LOC_MOE_USE_2ND_CODE=12 then 
         case 
         when dbore.BH_STATUS_CODE in (2,9,14) then 4 -- Dewatering
         when dbore.BH_STATUS_CODE in (10) then 3 -- Engineering
         else null 
         end
	 -- MOE USE2 13 - Monitoring
	 when dloc.LOC_MOE_USE_2ND_CODE=13 then 
	     case 
	     when dbore.BH_STATUS_CODE is null then 3 -- Engineering
		when dbore.BH_STATUS_CODE in (2,3,14) then 3 -- Engineering
		else null
		end
     else null
     end
 --***** MOE USE1 14 - Monitoring and Test Hole
 when dloc.LOC_MOE_USE_1ST_CODE=14 then 
     case 
     -- MOE USE2 0 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case
         when dbore.BH_STATUS_CODE is null then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (1,5,6) then 10 -- Water Supply
         when dbore.BH_STATUS_CODE in (2,3,10,11,12,13,14,15) then 3 -- Engineering
         when dbore.BH_STATUS_CODE in (9) then 4 -- Dewatering
         else null
         end
     -- MOE USE2 3 - Irrigation
     when dloc.LOC_MOE_USE_2ND_CODE=3 then
         case 
         when dbore.BH_STATUS_CODE in (14) then 1 -- Agricultural
         else null
         end 
	-- MOE USE2 4 - Industrial
	when dloc.LOC_MOE_USE_2ND_CODE=4 then 
	    case 
	    when dbore.BH_STATUS_CODE is null then 3 -- Engineering
	    when dbore.BH_STATUS_CODE in (1,2,3,4,5,6,10,13,14,15) then 3 -- Engineering
	    when dbore.BH_STATUS_CODE in (9) then 4 -- Dewatering
	    else null 
	    end
	-- MOE USE2 6 - Municipal
	when dloc.LOC_MOE_USE_2ND_CODE=6 then
		case
		when dbore.BH_STATUS_CODE in (2,13) then 3 -- Engineering
		else null
		end
	-- MOE USE2 10 - Other
	when dloc.LOC_MOE_USE_2ND_CODE=10 then
	    case
	    when dbore.BH_STATUS_CODE in (2,3,10,14) then 3 -- Engineering
	    else null
	    end
	-- MOE USE2 12 -- Dewatering
	when dloc.LOC_MOE_USE_2ND_CODE=12 then
	    case
	    when dbore.BH_STATUS_CODE is null then 4 -- Dewatering
	    when dbore.BH_STATUS_CODE in (10) then 4 -- Dewatering
	    else null
	    end
	-- MOE USE2 14 - Monitoring and Test Hole
	when dloc.LOC_MOE_USE_2ND_CODE=14 then 
	    case
	    when dbore.BH_STATUS_CODE in (14) then 3 -- Engineering
	    else null
	    end
	else null 
	end
 else null 
 end as [PRIMARY_PURPOSE_CODE] 
--***** SECONDARY PURPOSE Starts Here
--***** SECONDARY_PURPOSE
,case 
--***** MOE USE1 0 - Undefined
when dloc.LOC_MOE_USE_1ST_CODE=0 then
    case
    -- MOE USE2 0 - Undefined
    when dloc.LOC_MOE_USE_2ND_CODE=0 then
        case
        when dbore.BH_STATUS_CODE is null then 71 -- Unknown
        when dbore.BH_STATUS_CODE in (1,5,6) then 33 -- Other Water Supply
        when dbore.BH_STATUS_CODE in (2,14,15) then 51 -- Monitoring Well
        when dbore.BH_STATUS_CODE in (3) then 30 -- Other Miscellaneous
        when dbore.BH_STATUS_CODE in (4) then 83 -- Recharge Well
        when dbore.BH_STATUS_CODE in (9) then 27 -- Other Dewatering
        when dbore.BH_STATUS_CODE in (7,8,10,11,12,13) then 71 -- Unknown
        else null
        end
    -- MOE USE2 1 - Domestic
    when dloc.LOC_MOE_USE_2ND_CODE=1 then
        case 
        when dbore.BH_STATUS_CODE is null then 49 -- Domestic
        when dbore.BH_STATUS_CODE in (1,5) then 33 -- Other Water Supply
        when dbore.BH_STATUS_CODE in (12) then 49 -- Domestic
        else null
        end
    ---- MOE USE2 3 - Irrigation
    when dloc.LOC_MOE_USE_2ND_CODE=3 then
        case
        when dbore.BH_STATUS_CODE in (1) then 33 -- Other Water Supply
        else null
        end
    -- MOE USE2 9 - Not Used
    when dloc.LOC_MOE_USE_2ND_CODE=9 then
        case
        when dbore.BH_STATUS_CODE is null then 77 -- Not Used, Possibly Abandoned
        when dbore.BH_STATUS_CODE in (2,3,6) then 51 -- Monitoring Well
        when dbore.BH_STATUS_CODE in (10) then 71 -- Unknown
        else null
        end
    -- MOE USE2 10 - Other
    when dloc.LOC_MOE_USE_2ND_CODE=10 then
        case
        when dbore.BH_STATUS_CODE in (1) then 33 -- Other Water Supply
        when dbore.BH_STATUS_CODE in (2) then 51 -- Monitoring Well
        when dbore.BH_STATUS_CODE in (10) then 71 -- Unknown
        else null
        end
    -- MOE USE2 11 - Test Hole
    when dloc.LOC_MOE_USE_2ND_CODE=11 then
        case
        when dbore.BH_STATUS_CODE in (2,3) then 51 -- Monitoring Well
        else null
        end
    -- MOE USE2 13 - Monitoring
    when dloc.LOC_MOE_USE_2ND_CODE=13 then
        case
        when dbore.BH_STATUS_CODE is null then 51 -- Monitoring Well
        when dbore.BH_STATUS_CODE in (2,3,10) then 51 -- Monitoring Well
        else null
        end
    -- MOE USE2 14 -- Monitoring and Test Hole
    when dloc.LOC_MOE_USE_2ND_CODE=14 then
        case
        when dbore.BH_STATUS_CODE is null then 51 -- Monitoring Well
        when dbore.BH_STATUS_CODE in (14) then 51 -- Monitoring Well
        else null
        end
    else null
    end
--***** MOE USE1  1 - Domestic
when dloc.LOC_MOE_USE_1ST_CODE=1 then 
     case 
     -- MOE USE2 0 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case 
         when dbore.BH_STATUS_CODE is null then 49 -- Domestic
         when dbore.BH_STATUS_CODE in (1,4,7,8,10,11,12,13) then 49 -- Domestic
	    when dbore.BH_STATUS_CODE in (2,6) then 51 -- Monitoring Well
	    when dbore.BH_STATUS_CODE in (3) then 47 -- Geotech Testhole
	    when dbore.BH_STATUS_CODE in (5) then 33 -- Other Water Supply
	    when dbore.BH_STATUS_CODE in (9) then 27 -- Other Dewatering
	    else null
         end 
	-- MOE USE2 1 - Domestic
	when dloc.LOC_MOE_USE_2ND_CODE=1 then
	     case 
		 when dbore.BH_STATUS_CODE in (1,12) then 49 -- Domestic
		 else null
		 end
     -- MOE USE2 2 - Livestock
     when dloc.LOC_MOE_USE_2ND_CODE=2 then 
         case 
	    when dbore.BH_STATUS_CODE is null then 49 -- Domestic
         when dbore.BH_STATUS_CODE in (1,5,6,7,10,11) then 49 -- Domestic
         when dbore.BH_STATUS_CODE in (2) then 51 -- Monitoring Well
         when dbore.BH_STATUS_CODE in (8,9) then 24 -- Other Agricultural
         when dbore.BH_STATUS_CODE in (12) then 28 -- Other Industrial
         else null 
         end 
     -- MOE USE2 3 - Irrigation
     when dloc.LOC_MOE_USE_2ND_CODE=3 then 
         case 
         when dbore.BH_STATUS_CODE in (1) then 49 -- Domestic
         when dbore.BH_STATUS_CODE in (5) then 24 -- Other Agricultural
         else null 
         end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 28 -- Other Industrial
         when dbore.BH_STATUS_CODE in (1,5,6,7,10) then 49 -- Domestic
         when dbore.BH_STATUS_CODE=3 then 47 -- Geotech Testhole
         when dbore.BH_STATUS_CODE=4 then 83 -- Recharge Well
         when dbore.BH_STATUS_CODE=9 then 27 -- Other Dewatering
         when dbore.BH_STATUS_CODE=15 then 51 -- Monitoring Well
         when dbore.BH_STATUS_CODE in (2,11,12,13) then 28 -- Other Industrial
         else null 
         end
     -- MOE USE2 5 - Commercial
     when dloc.LOC_MOE_USE_2ND_CODE=5 then 
         case 
         when dbore.BH_STATUS_CODE is null then 33 -- Other Water Supply
         when dbore.BH_STATUS_CODE in (1,3,4,5,6,7,10,12) then 25 -- Other Commercial
         when dbore.BH_STATUS_CODE in (11) then 49 -- Domestic
         else null 
         end 
     -- MOE USE2 6 - Municipal
     when dloc.LOC_MOE_USE_2ND_CODE=6 then 
         case 
         when dbore.BH_STATUS_CODE in (1,5,6,7,10) then 22 -- Municipal Supply
         else null 
         end 
     -- MOE USE2 7 - Public Supply
     when dloc.LOC_MOE_USE_2ND_CODE=7 then 
         case 
         when dbore.BH_STATUS_CODE is null then 33 -- Other Water Supply
         when dbore.BH_STATUS_CODE in (1,3,5,10,11,12) then 33 -- Other Water Supply
         else null 
         end 
     -- MOE USE2 8 - Cooling or A/C
     when dloc.LOC_MOE_USE_2ND_CODE=8 then 
         case
         when dbore.BH_STATUS_CODE is null then 9 -- Cooling Water
         when dbore.BH_STATUS_CODE in (1,4) then 49 -- Domestic
         when dbore.BH_STATUS_CODE in (6,9) then 9 -- Cooling Water
         else null 
         end 
     -- MOE USE2 9 - Not Used
     when dloc.LOC_MOE_USE_2ND_CODE=9 then 
         case 
         when dbore.BH_STATUS_CODE is null then 33 -- Water Supply
         when dbore.BH_STATUS_CODE in (1,5,6,7,10,13) then 33 -- Other Water Supply
         when dbore.BH_STATUS_CODE in (2) then 51 -- Monitoring Well
         when dbore.BH_STATUS_CODE in (3) then 30 -- Other Miscellaneous
         when dbore.BH_STATUS_CODE in (4) then 83 -- Rechage Well
         else null 
         end
     -- MOE USE2 10 - Other
     when dloc.LOC_MOE_USE_2ND_CODE=10 then 
         case 
	    when dbore.BH_STATUS_CODE is null then 49 -- Domestic
         when dbore.BH_STATUS_CODE in (1,5,6,7,10) then 49 -- Domestic
	    when dbore.BH_STATUS_CODE in (9) then 27 -- Other Dewatering
	    when dbore.BH_STATUS_CODE in (13) then 33 -- Other Water Supply
         else null 
         end 
     -- MOE USE2 11 - Test Hole
     when dloc.LOC_MOE_USE_2ND_CODE=11 then 
         case
         when dbore.BH_STATUS_CODE in (1,3,5,6,7,10) then 47 -- Geotech Testhole
	    when dbore.BH_STATUS_CODE in (2) then 51 -- Monitoring Well
	    when dbore.BH_STATUS_CODE in (11) then 49 -- Domestic
         else null  
         end 
     -- MOE USE2 12 - Dewatering
     when dloc.LOC_MOE_USE_2ND_CODE=12 then
         case
         when dbore.BH_STATUS_CODE in (1,9) then 27 -- Other Dewatering
         else null
         end
     -- MOE USE2 13 - Monitoring
     when dloc.LOC_MOE_USE_2ND_CODE=13 then 
         case 
         when dbore.BH_STATUS_CODE is null then 51 -- Monitor/Obs Well
         when dbore.BH_STATUS_CODE in (1,2,3,5,6,7,9,10) then 51 -- Monitor/Obs Well
         else null 
         end
     else null
     end    
 --***** MOE USE1  2 - Livestock
 when dloc.LOC_MOE_USE_1ST_CODE=2 then 
     case 
     -- MOE USE2 - - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case
         when dbore.BH_STATUS_CODE is null then 50 -- Stock
         when dbore.BH_STATUS_CODE in (1,4,5,10,11,12) then 50 -- Stock
         when dbore.BH_STATUS_CODE in (2,6) then 51 -- Monitoring Well
         when dbore.BH_STATUS_CODE in (3,9) then 24 -- Other Agricultural
         else null
         end
     -- MOE USE2 1 - Domestic
     when dloc.LOC_MOE_USE_2ND_CODE=1 then 
         case 
         when dbore.BH_STATUS_CODE in (1,13) then 50 -- Stock
         else null 
         end 
      -- MOE USE2 3 - Irrigation
      when dloc.LOC_MOE_USE_2ND_CODE=3 then
         case
         when dbore.BH_STATUS_CODE in (1) then 50 -- Stock
         when dbore.BH_STATUS_CODE in (5) then 33 -- Other Water Supply
         else null
         end 
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 50 -- Stock
         when dbore.BH_STATUS_CODE in (1,5,6,7,10,11,12) then 50 -- Stock
         else null 
         end
	 -- MOE USE2 5 - Commercial
	 when dloc.LOC_MOE_USE_2ND_CODE=5 then 
	     case 
		 when dbore.BH_STATUS_CODE in (1) then 50 -- Stock
		 else null 
		 end
      -- MOE USE2 6 - Municipal
      when dloc.LOC_MOE_USE_2ND_CODE=6 then
          case
          when dbore.BH_STATUS_CODE in (1) then 22 -- Municipal Supply
          else null
          end
      -- MOE USE2 9 - Not Used
      when dloc.LOC_MOE_USE_2ND_CODE=9 then
          case 
          when dbore.BH_STATUS_CODE in (5,10) then 50 -- Stock
          else null
          end
	 -- MOE USE2 10 - Other
	 when dloc.LOC_MOE_USE_2ND_CODE=10 then 
	     case 
		 when dbore.BH_STATUS_CODE is null then 50 -- Stock
		 else null 
		 end
     else null
     end    
 --***** MOE USE1  3 - Irrigation
 when dloc.LOC_MOE_USE_1ST_CODE=3 then 
     case 
     -- MOE USE2 0 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case
         when dbore.BH_STATUS_CODE is null then 24 -- Other Agricultural
         when dbore.BH_STATUS_CODE in (1,2,3,10,11,12) then 24 -- Other Agricultural
         when dbore.BH_STATUS_CODE in (4,5) then 33 -- Other Water Supply
         else null
         end
     -- MOE USE2 1 - Domestic
     when dloc.LOC_MOE_USE_2ND_CODE=1 then 
         case 
         when dbore.BH_STATUS_CODE in (1) then 49 -- Domestic
         else null
         end
     -- MOE USE2 2 - Livestock
     when dloc.LOC_MOE_USE_2ND_CODE=2 then 
         case
         when dbore.BH_STATUS_CODE in (1) then 33 -- Other Water Supply
         else null
         end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 24 -- Other Agricultural
         when dbore.BH_STATUS_CODE in (1) then 11 -- Field Pasture Crops
         when dbore.BH_STATUS_CODE in (2,3) then 51 -- Monitor/Obs Well
         when dbore.BH_STATUS_CODE in (4) then 83 -- Recharge Well
         when dbore.BH_STATUS_CODE in (5,10,11,12) then 24 -- Other Agricultural
         when dbore.BH_STATUS_CODE in (9) then 27 -- Other Dewatering
         else null 
         end
     -- MOE USE2 5 - Commercial
     when dloc.LOC_MOE_USE_2ND_CODE=5 then 
         case 
         when dbore.BH_STATUS_CODE is null then 25 -- Other Commercial
         when dbore.BH_STATUS_CODE in (1) then 11 -- Field Pasture Crops
         else null 
         end 
     -- MOE USE2 6 - Municipal
     when dloc.LOC_MOE_USE_2ND_CODE=6 then
         case
         when dbore.BH_STATUS_CODE in (1) then 33 -- Other Water Supply
         else null
         end
     -- MOE USE2 7 - Public Supply
     when dloc.LOC_MOE_USE_2ND_CODE=7 then
         case
         when dbore.BH_STATUS_CODE in (1) then 24 -- Other Agricultural
         else null
         end 
     -- MOE USE2 9 -- Not Used
     when dloc.LOC_MOE_USE_2ND_CODE=9 then
         case
         when dbore.BH_STATUS_CODE in (5) then 33 -- Other Water Supply
         else null
         end
     -- MOE USE2 10 - Other
     when dloc.LOC_MOE_USE_2ND_CODE=10 then 
         case
         when dbore.BH_STATUS_CODE=1 then 11 -- Field Pasture Crops 
         else null
         end 
	 -- MOE USE2 11 - Test Hole
	 when dloc.LOC_MOE_USE_2ND_CODE=11 then 
	     case 
		when dbore.BH_STATUS_CODE in (1,3) then 33 -- Other Water Supply
		when dbore.BH_STATUS_CODE in (15) then 51 -- Monitoring Well
		else null 
		end
     -- MOE USE2 13 - Monitoring
     when dloc.LOC_MOE_USE_2ND_CODE=13 then 
         case 
         when dbore.BH_STATUS_CODE=2 then 51 -- Monitor/Obs Well
         when dbore.BH_STATUS_CODE=9 then 27 -- Other Dewatering
         else null 
         end
     else null
     end 
 --***** MOE USE1  4 - Industrial
 when dloc.LOC_MOE_USE_1ST_CODE=4 then 
     case 
     -- MOE USE2 0 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case
         when dbore.BH_STATUS_CODE is null then 28 -- Other Industrial
         when dbore.BH_STATUS_CODE in (1,3,5,9,10) then 28 -- Other Industrial
         when dbore.BH_STATUS_CODE in (2) then 51 -- Monitoring Well
         else null
         end
     -- MOE USE2 1 - Domestic
     when dloc.LOC_MOE_USE_2ND_CODE=1 then 
         case 
         when dbore.BH_STATUS_CODE is null then 28 -- Other Industrial
         when dbore.BH_STATUS_CODE in (1,5,10) then 28 -- Other Industrial
         else null 
         end 
	 -- MOE USE2 2 - Livestock
	 when dloc.LOC_MOE_USE_2ND_CODE=2 then 
	     case 
		 when dbore.BH_STATUS_CODE in (5) then 24 -- Other Agricultural
		 else null 
		 end
	 -- MOE USE2 3 - Irrigation
	 when dloc.LOC_MOE_USE_2ND_CODE=3 then 
	     case 
		 when dbore.BH_STATUS_CODE is null then 24 -- Other Agricultural
		 when dbore.BH_STATUS_CODE in (1) then 24 -- Other Agricultural
		 else null 
		 end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 28 -- Other Industrial
         when dbore.BH_STATUS_CODE in (1,6,7,10,11,12,13) then 28 -- Other Industrial
         when dbore.BH_STATUS_CODE in (2,14,15) then 51 -- Monitor/Obs Well
         when dbore.BH_STATUS_CODE=3 then 47 -- Geotech Testhole
         when dbore.BH_STATUS_CODE=4 then 83 -- Recharge Well
		 when dbore.BH_STATUS_CODE in (5) then 33 -- Other Water Supply
         when dbore.BH_STATUS_CODE=9 then 27 -- Other Dewatering
         else null 
         end
	 -- MOE USE2 5 - Commercial
	 when dloc.LOC_MOE_USE_2ND_CODE=5 then 
	     case 
		when dbore.BH_STATUS_CODE in (1,5) then 33 -- Other Water Supply
		else null 
		end
	 -- MOE USE2 6 - Municipal
	 when dloc.LOC_MOE_USE_2ND_CODE=6 then 
	     case 
		when dbore.BH_STATUS_CODE in (2) then 51 -- Monitor/Obs Well
		when dbore.BH_STATUS_CODE in (9) then 27 -- Other Dewatering
		else null 
		end
     -- MOE USE2 7 - Public Supply
     when dloc.LOC_MOE_USE_2ND_CODE=7 then 
         case 
         when dbore.BH_STATUS_CODE is null then 33 -- Other Water Supply
         when dbore.BH_STATUS_CODE in (1) then 28  -- Other Industrial
         else null
         end 
     -- MOE USE2 9 - Not Used
     when dloc.LOC_MOE_USE_2ND_CODE=9 then 
         case 
         when dbore.BH_STATUS_CODE is null then 28 -- Other Industrial
         when dbore.BH_STATUS_CODE in (1,5,6,7,10,13) then 28 -- Other Industrial
         else null 
         end
     -- MOE USE2 10 - Other
     when dloc.LOC_MOE_USE_2ND_CODE=10 then 
         case 
         when dbore.BH_STATUS_CODE is null then 28 -- Other Industrial
         when dbore.BH_STATUS_CODE=1 then 33 -- Other Water Supply
         when dbore.BH_STATUS_CODE=4 then 83 -- Recharge Well
         when dbore.BH_STATUS_CODE in (5,6,7,10,13) then 28 -- Other Industrial
         else null 
         end 
     -- MOE USE2 11 - Test Hole
     when dloc.LOC_MOE_USE_2ND_CODE=11 then 
         case
         when dbore.BH_STATUS_CODE in (1,3,5,6,7,10) then 28 -- Other Industrial
         when dbore.BH_STATUS_CODE in (2) then 51  -- Monitoring Well
         else null  
         end 
	 -- MOE USE2 12 - Dewatering
	 when dloc.LOC_MOE_USE_2ND_CODE=12 then 
	     case 
		 when dbore.BH_STATUS_CODE in (2,9,10) then 27 -- Other Dewatering
		 else null 
		 end
     -- MOE USE2 13 - Monitoring
     when dloc.LOC_MOE_USE_2ND_CODE=13 then 
         case 
         when dbore.BH_STATUS_CODE is null then 51 -- Monitor/Obs Well
         when dbore.BH_STATUS_CODE in (2,3,10,13,14,15) then 51 -- Monitor/Obs Well
         when dbore.BH_STATUS_CODE in (5) then  33  -- Other Water Supply
         else null 
         end          
     else null
     end
 --***** MOE USE1  5 - Commercial
 when dloc.LOC_MOE_USE_1ST_CODE=5 then 
     case 
     -- MOE USE2 0 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case 
         when dbore.BH_STATUS_CODE is null then 71 -- Unknown
         when dbore.BH_STATUS_CODE in (1,2,3,5,6,9,10,11,12) then 25 -- Other Commericial
         else null
         end
     -- MOE USE2 1 - Domestic
     when dloc.LOC_MOE_USE_2ND_CODE=1 then
         case 
         when dbore.BH_STATUS_CODE=1 then 25 -- Other Commercial
         else null
         end
     -- MOE USE2 2 - Livestock
     when dloc.LOC_MOE_USE_2ND_CODE=2 then
         case
         when dbore.BH_STATUS_CODE in (1) then 24 -- Other Agricultural
         else null
         end
     -- MOE USE2 3 - Irrigation
     when dloc.LOC_MOE_USE_2ND_CODE=3 then
         case
         when dbore.BH_STATUS_CODE is null then 25  -- Other Commercial
         when dbore.BH_STATUS_CODE in (1) then 24 -- Other Agricultural
         else null
         end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 25 -- Other Commercial
         when dbore.BH_STATUS_CODE in (1,2,3,4,5,6,7,10,11,12,13) then 25 -- Other Commercial
         when dbore.BH_STATUS_CODE in (9) then 27 -- Other Dewatering
         else null 
         end
     -- MOE USE2 6 - Municipal
     when dloc.LOC_MOE_USE_2ND_CODE=6 then 
         case 
         when dbore.BH_STATUS_CODE in (1) then 22 -- Municipal Supply
         else null 
         end 
     -- MOE USE2 7 - Public Supply
     when dloc.LOC_MOE_USE_2ND_CODE=7 then
         case
         when dbore.BH_STATUS_CODE in (1) then 25 -- Other Commercial
         else null
         end
     -- MOE USE2 8 - Cooling or AC
     when dloc.LOC_MOE_USE_2ND_CODE=8 then
         case
         when dbore.BH_STATUS_CODE in (1) then 9 -- Cooling Water
         else null
         end
     -- MOE USE2 9 - Not Used
     when dloc.LOC_MOE_USE_2ND_CODE=9 then 
         case 
         when dbore.BH_STATUS_CODE is null then 25 -- Other Commercial
         when dbore.BH_STATUS_CODE in (4,5,10) then 25 -- Other Commercial
         else null 
         end
     -- MOE USE2 10 - Other
     when dloc.LOC_MOE_USE_2ND_CODE=10 then
         case
         when dbore.BH_STATUS_CODE in (1,10) then 25 -- Other Commercial
         else null
         end
     -- MOE USE2 11 - Test Hole
     when dloc.LOC_MOE_USE_2ND_CODE=11 then
         case
         when dbore.BH_STATUS_CODE is null then 51 -- Monitor/Obs Well
         when dbore.BH_STATUS_CODE in (1) then  33  -- Other Water Supply
         when dbore.BH_STATUS_CODE in (2) then 51  -- Monitor/Obs Well
         else null
         end
     -- MOE USE2 12 - Dewatering
     when dloc.LOC_MOE_USE_2ND_CODE=12 then 
         case 
         when dbore.BH_STATUS_CODE=9 then 27 -- Other Dewatering
         else null 
         end
     -- MOE USE2 13 - Monitoring
     when dloc.LOC_MOE_USE_2ND_CODE=13 then 
         case 
         when dbore.BH_STATUS_CODE is null then 51 -- Monitor/Obs Well
		 when dbore.BH_STATUS_CODE in (2) then 51 -- Monitoring Well
         else null 
         end
     else null
     end
 --***** MOE USE1  6 - Municipal
 when dloc.LOC_MOE_USE_1ST_CODE=6 then 
     case 
     -- MOE USE2 0 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case
         when dbore.BH_STATUS_CODE is null then 33 -- Other Water Supply
         when dbore.BH_STATUS_CODE in (1,3,4,5,6,9,10,11,12,13) then 33 -- Other Water Supply
         when dbore.BH_STATUS_CODE in (2) then 58 -- Munipal Monitor
         when dbore.BH_STATUS_CODE in (8) then 30 -- Other Miscellaneous
         else null
         end 
     -- MOE USE2 1 - Domestic
     when dloc.LOC_MOE_USE_2ND_CODE=1 then
         case
         when dbore.BH_STATUS_CODE in (1,4) then 33 -- Other Water Supply
         else null
         end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 22 -- Muncipal Supply
         when dbore.BH_STATUS_CODE in (1,5,6,7,10,11,12,13) then 22 -- Municipal Supply
         when dbore.BH_STATUS_CODE in (2,14) then 58 -- Municipal Monitor
         when dbore.BH_STATUS_CODE in (3) then 59 -- Municipal Explore
         else null 
         end
     -- MOE USE2 5 - Commercial
     when dloc.LOC_MOE_USE_2ND_CODE=5 then
         case 
         when dbore.BH_STATUS_CODE in (1) then 25 -- Other Commerical
         else null
         end
     -- MOE USE2 7 - Public Supply
     when dloc.LOC_MOE_USE_2ND_CODE=7 then 
         case
         when dbore.BH_STATUS_CODE in (1) then 22 -- Municipal Supply
         when dbore.BH_STATUS_CODE in (10) then 33 -- Other Water Supply
         else null
         end
	-- MOE USE2 8 -- Cooling or A/C
	when dloc.LOC_MOE_USE_2ND_CODE=8 then 
	    case 
	    when dbore.BH_STATUS_CODE in (1) then 9 -- Cooling Water
	    when dbore.BH_STATUS_CODE in (9) then 27 -- Other Dewatering
	    else null 
	    end
     -- MOE USE2 9 - Not Used
     when dloc.LOC_MOE_USE_2ND_CODE=9 then 
         case 
         when dbore.BH_STATUS_CODE is null then 33 -- Other Water Supply
         when dbore.BH_STATUS_CODE in (2) then 58 -- Municipal Monitor
         when dbore.BH_STATUS_CODE in (3,5,6,7,10) then 59 -- Municipal Explore
         else null 
         end
	-- MOE USE2 10 -- Other 
	when dloc.LOC_MOE_USE_2ND_CODE=10 then 
	    case 
	    when dbore.BH_STATUS_CODE in (1) then 22 -- Municipal Supply
	    when dbore.BH_STATUS_CODE in (10) then 33 -- Other Water Supply
	    else null 
	    end 
     -- MOE USE2 11 - Test Hole
     when dloc.LOC_MOE_USE_2ND_CODE=11 then 
         case
         when dbore.BH_STATUS_CODE in (1,3,5,6,7,10,13,14) then 59 -- Municipal Explore
         when dbore.BH_STATUS_CODE in (2) then 58 -- Municipal Monitor
         else null  
         end 
     -- MOE USE2 12 - Dewatering
     when dloc.LOC_MOE_USE_2ND_CODE=12 then 
         case
		 when dbore.BH_STATUS_CODE in (2) then 58 -- Municipal Monitor
         when dbore.BH_STATUS_CODE in (9,10,11) then 27 -- Other Dewatering
         else null  
         end          
     -- MOE USE2 13 - Monitoring
     when dloc.LOC_MOE_USE_2ND_CODE=13 then 
         case 
         when dbore.BH_STATUS_CODE in (2,4,10,14) then 58 -- Municipal Monitor
         when dbore.BH_STATUS_CODE=3 then 59 -- Municipal Explore
         else null 
         end
     -- MOE USE2 14 - Monitoring and Test Hold
     when dloc.LOC_MOE_USE_2ND_CODE=14 then
         case
         when dbore.BH_STATUS_CODE in (14) then 58 -- Municipal Monitor
         else null
         end
     else null
     end
 --***** MOE USE1  7 - Public Supply
 when dloc.LOC_MOE_USE_1ST_CODE=7 then 
     case 
     -- MOE USE2 0 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case 
         when dbore.BH_STATUS_CODE is null then 71 -- Unknown
         when dbore.BH_STATUS_CODE in (1) then 22 -- Municipal Supply
         when dbore.BH_STATUS_CODE in (2) then 51 -- Monitoring Well
         when dbore.BH_STATUS_CODE in (3,5,6,10,11,12,13) then 33 -- Other Water Supply
         else null
         end
     -- MOE USE2 1 - Domestic
     when dloc.LOC_MOE_USE_2ND_CODE=1 then 
         case 
         when dbore.BH_STATUS_CODE is null then 33 -- Other Water Supply
         when dbore.BH_STATUS_CODE in (1,5,6,7,10,11,13) then 33 -- Other Water Supply
         else null 
         end 
     -- MOE USE2 2 -- Livestock
     when dloc.LOC_MOE_USE_2ND_CODE=2 then
         case
         when dbore.BH_STATUS_CODE in (1) then 24 -- Other Agricultural
         else null
         end
     -- MOE USE2 3 - Irrigation
     when dloc.LOC_MOE_USE_2ND_CODE=3 then
         case
         when dbore.BH_STATUS_CODE=1 then 24 -- Other Agricultural
         else null
         end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 28 -- Other Industrial
         when dbore.BH_STATUS_CODE in (1,3,4,5,6,7,10,11,12,13) then 28 -- Other Industrial
         else null 
         end
	-- MOE USE2 5 - Commercial
	when dloc.LOC_MOE_USE_2ND_CODE=5 then 
	    case 
	    when dbore.BH_STATUS_CODE is null then 25 -- Other Commercial
	    when dbore.BH_STATUS_CODE in (1,10) then 25 -- Other Commerical
	    when dbore.BH_STATUS_CODE in (2) then 51 -- Monitoring Well
	    else null 
	    end
     -- MOE USE2 6 - Municipal
     when dloc.LOC_MOE_USE_2ND_CODE=6 then 
         case 
         when dbore.BH_STATUS_CODE in (1,10,15) then 22 -- Municipal Supply
         when dbore.BH_STATUS_CODE in (3) then 59 -- Municipal Exploration
         else null 
         end 
     -- MOE USE2 10 - Other
     when dloc.LOC_MOE_USE_2ND_CODE=10 then 
         case 
         when dbore.BH_STATUS_CODE=1 then 33 -- Other Water Supply
         else null 
         end 
     -- MOE USE2 11 - Test Hole
     when dloc.LOC_MOE_USE_2ND_CODE=11 then
         case
         when dbore.BH_STATUS_CODE in (1) then 33 -- Other Water Supply
         when dbore.BH_STATUS_CODE in (2) then 51 -- Monitoring Well
         else null
         end
     -- MOE USE2 13 - Monitoring
     when dloc.LOC_MOE_USE_2ND_CODE=13 then 
         case
         when dbore.BH_STATUS_CODE in (5,10) then 33 -- Other Water Supply 
         else null 
         end 
     else null
     end
 --***** MOE USE1  8 - Cooling or A/C
 when dloc.LOC_MOE_USE_1ST_CODE=8 then 
     case 
     -- MOE USE2 0 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then 
         case
         when dbore.BH_STATUS_CODE is null then 33 -- Other Water Supply
         when dbore.BH_STATUS_CODE in (1,10,11) then 33 -- Other Water Supply
         when dbore.BH_STATUS_CODE in (2) then 51 -- Monitoring Well
         when dbore.BH_STATUS_CODE in (4) then 83 -- Recharge Well
         when dbore.BH_STATUS_CODE in (5,9) then 9 -- Cooling Water
         when dbore.BH_STATUS_CODE in (13) then 71 -- Unknown
         else null
         end
     -- MOE USE2 1 - Domestic
     when dloc.LOC_MOE_USE_2ND_CODE=1 then 
         case
         when dbore.BH_STATUS_CODE in (1) then 49 -- Domestic
         else null
         end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 28 -- Other Industrial
	    when dbore.BH_STATUS_CODE in (1) then 33 -- Other Water Supply
         when dbore.BH_STATUS_CODE in (4,12,13) then 83 -- Recharge Well
         else null 
         end
	 -- MOE USE2 9 - Not Used 
	 when dloc.LOC_MOE_USE_2ND_CODE=9 then 
	     case 
		 when dbore.BH_STATUS_CODE in (5) then 33 -- Other Water Supply
		 else null 
		 end
     -- MOE USE2 10 - Other
     when dloc.LOC_MOE_USE_2ND_CODE=10 then 
         case 
	    when dbore.BH_STATUS_CODE is null then 30 -- Other Miscellaneous
	    when dbore.BH_STATUS_CODE in (1) then 33 -- Other Water Supply
	    when dbore.BH_STATUS_CODE in (4) then 83 -- Recharge Well
         when dbore.BH_STATUS_CODE in (13) then 30 -- Other Miscellaneous
         else null 
         end 
	 -- MOE USE2 13 - Monitoring
	 when dloc.LOC_MOE_USE_2ND_CODE=13 then 
	     case 
		 when dbore.BH_STATUS_CODE in (2,14) then 51 -- Monitoring Well
		 else null 
		 end
     else null
     end
 --***** MOE USE1  9 - Not Used
 when dloc.LOC_MOE_USE_1ST_CODE=9 then 
     case 
     -- MOE USE2 0 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case
         when dbore.BH_STATUS_CODE is null then 71 -- Unknown
         when dbore.BH_STATUS_CODE in (1,5,6,10) then 33 -- Other Water Supply
         when dbore.BH_STATUS_CODE in (2,3,14,15) then 51 -- Monitoring Well
         when dbore.BH_STATUS_CODE in (4) then 83 -- Recharge Well
         when dbore.BH_STATUS_CODE in (7,8,12,13) then 71 -- Unknown
         when dbore.BH_STATUS_CODE in (9) then 27 -- Other Dewatering
         when dbore.BH_STATUS_CODE in (11) then 30 -- Other Miscellaneous
         else null
         end
     -- MOE USE2 1 - Domestic
     when dloc.LOC_MOE_USE_2ND_CODE=1 then
         case 
         when dbore.BH_STATUS_CODE in (10) then 33 -- Other Water Supply
         else null
         end
     -- MOE USE2 2 - Livestock
     when dloc.LOC_MOE_USE_2ND_CODE=2 then
         case
         when dbore.BH_STATUS_CODE in ( 9,10 ) then 50 -- Stock
         else null
         end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 29 -- Other Industrial
         when dbore.BH_STATUS_CODE in (1,5,6,7,10,11,12,13) then 29 -- Other Industrial
         when dbore.BH_STATUS_CODE in (2,14,15) then 51 -- Monitor/Obs Well
         when dbore.BH_STATUS_CODE in (4) then 83 -- Recharge Well
         when dbore.BH_STATUS_CODE in (3) then 47 -- Geotech Testhole
         else null 
         end
     -- MOE USE2 5 - Commercial
     when dloc.LOC_MOE_USE_2ND_CODE=5 then 
         case 
         when dbore.BH_STATUS_CODE=4 then 25 -- Other Commercial
         else null 
         end 
     -- MOE USE2 6 - Municipal
     when dloc.LOC_MOE_USE_2ND_CODE=6 then
         case
         when dbore.BH_STATUS_CODE=1 then 77 -- Not Used
         when dbore.BH_STATUS_CODE=3 then 59 -- Municipal Exploration
         else null
         end
     -- MOE USE2 7 - Public Supply
     when dloc.LOC_MOE_USE_2ND_CODE=9 then
         case
         when dbore.BH_STATUS_CODE is null then 33 -- Other Water Supply
         when dbore.BH_STATUS_CODE in (7) then 77 -- Not Used - Possibly Abandoned
         else null
         end
     -- MOE USE2 8 - Cooling or A/C
     when dloc.LOC_MOE_USE_2ND_CODE=8 then
         case
         when dbore.BH_STATUS_CODE in (4) then 83 -- Recharge Well
         else null
         end
     -- MOE USE2 9 - Not Used
     when dloc.LOC_MOE_USE_2ND_CODE=9 then 
         case 
         when dbore.BH_STATUS_CODE=2 then 51 -- Monitor/Obs Well
         else null 
         end 
     -- MOE USE2 10 - Other
     when dloc.LOC_MOE_USE_2ND_CODE=10 then 
         case 
         when dbore.BH_STATUS_CODE in (2) then 51 -- Monitoring Well
         when dbore.BH_STATUS_CODE in (5,6,7,10) then 27 -- Other Industrial
         when dbore.BH_STATUS_CODE in (13) then 71 -- Unknown
         else null 
         end 
	 -- MOE USE2 11 - Test Hole
	 when dloc.LOC_MOE_USE_2ND_CODE=11 then 
	     case 
		 when dbore.BH_STATUS_CODE in (3,10,11,14) then 51 -- Monitoring Well
		 else null 
		 end
     -- MOE USE2 12 - Dewatering
     when dloc.LOC_MOE_USE_2ND_CODE=12 then 
         case 
         when dbore.BH_STATUS_CODE is null then 27 -- Other Dewatering
         when dbore.BH_STATUS_CODE in (5,6,7,10) then 27 -- Other Dewatering
         else null 
         end
     -- MOE USE2 13 - Monitoring
     when dloc.LOC_MOE_USE_2ND_CODE=13 then 
         case 
         when dbore.BH_STATUS_CODE is null then 51 -- Monitor/Obs Well
         when dbore.BH_STATUS_CODE in (1,2,5,6,7,10,13) then 51 -- Monitor/Obs Well
         when dbore.BH_STATUS_CODE=3 then 47 -- Geotech Testhole
         else null 
         end
     -- MOE USE2 15 -- Monitoring and Test Hole
     when dloc.LOC_MOE_USE_2ND_CODE=14 then
         case
         when dbore.BH_STATUS_CODE in (10,15) then 51 -- Monitoring Well
         else null
         end
     else null
     end
 --***** MOE USE1 10 - Other
 when dloc.LOC_MOE_USE_1ST_CODE=10 then 
     case 
     -- MOE USE2 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case 
         when dbore.BH_STATUS_CODE is null then 71 -- Unknown
         when dbore.BH_STATUS_CODE in (1,5,6,10) then 33 -- Other Water Supply
         when dbore.BH_STATUS_CODE in (2,3,14,15) then 51 -- Monitoring Well
         when dbore.BH_STATUS_CODE in (4) then 83 -- Recharge Well
         when dbore.BH_STATUS_CODE in (11) then 30 -- Other Miscellaneous
         when dbore.BH_STATUS_CODE in (12,13) then 71 -- Unknown
         else null
         end
     -- MOE USE2 1 - Domestic
     when dloc.LOC_MOE_USE_2ND_CODE=1 then
         case
         when dbore.BH_STATUS_CODE is null then 33 -- Other Water Supply
         else null
         end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 28 -- Other Industrial
         when dbore.BH_STATUS_CODE in (1,5,6,7,10,11,12,13) then 28 -- Other Industrial
         when dbore.BH_STATUS_CODE in (2,14) then 51 -- Monitor/Obs Well
         when dbore.BH_STATUS_CODE=3 then 47 -- Geotech Testhole
         when dbore.BH_STATUS_CODE=4 then 83 -- Recharge Well
         when dbore.BH_STATUS_CODE=9 then 27 -- Other Dewatering
         else null 
         end
     -- MOE USE2 9 - Not Used
     when dloc.LOC_MOE_USE_2ND_CODE=9 then 
         case 
         when dbore.BH_STATUS_CODE in (1,3,5,6,7,10) then 33 -- Other Water Supply
         else null 
         end
     -- MOE USE2 10 - Other
     when dloc.LOC_MOE_USE_2ND_CODE=10 then 
         case 
         when dbore.BH_STATUS_CODE is null then 33 -- Other Water Supply
         when dbore.BH_STATUS_CODE in (10) then 77 -- Not Used
         else null 
         end 
	 -- MOE USE2 11 - Test Hole
	 when dloc.LOC_MOE_USE_2ND_CODE=11 then 
	     case 
	     when dbore.BH_STATUS_CODE in (1) then 33 -- Other Water Supply
		when dbore.BH_STATUS_CODE in (3,14) then 51 -- Monitoring Well
		when dbore.BH_STATUS_CODE in (13) then 71 -- Unknown
		else null 
		end
     -- MOE USE2 13 - Monitoring
     when dloc.LOC_MOE_USE_2ND_CODE=13 then 
         case 
         when dbore.BH_STATUS_CODE is null then 51 -- Monitor/Obs Well
		 when dbore.BH_STATUS_CODE in (2,6,13,14) then 51 -- Monitoring Well
         else null 
         end      
     else null
     end
 --***** MOE USE1 11 - Test Hole
 when dloc.LOC_MOE_USE_1ST_CODE=11 then 
     case 
     -- MOE USE2 0 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case
         when dbore.BH_STATUS_CODE is null then 51 -- Monitoring Well
         when dbore.BH_STATUS_CODE in (1,5,6) then 33 -- Other Water Supply
         when dbore.BH_STATUS_CODE in (2,3,10,12,13,14,15) then 51 -- Monitoring Well
         when dbore.BH_STATUS_CODE in (9) then 27 -- Other Dewatering
         else null
         end
     -- MOE USE2 3 - Irrigation
     when dloc.LOC_MOE_USE_2ND_CODE=3 then
         case
         when dbore.BH_STATUS_CODE in (1) then 33 -- Other Water Supply
         else null
         end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 47 -- Geotech Testhole
         when dbore.BH_STATUS_CODE in (1,3,5,6,7,9,10,11,13) then 47 -- Geotech Testhole
         when dbore.BH_STATUS_CODE in (2,14,15) then 51 -- Monitor/Obs Well
         else null 
         end
     -- MOE USE2 5 - Commercial
     when dloc.LOC_MOE_USE_2ND_CODE=5 then
         case
         when dbore.BH_STATUS_CODE in (12) then 25 -- Other Commerical
         else null
         end
     -- MOE USE2 6 - Municipal
     when dloc.LOC_MOE_USE_2ND_CODE=6 then 
         case 
         when dbore.BH_STATUS_CODE is null then 59 -- Municipal Explore
         when dbore.BH_STATUS_CODE in (1,2,3,5,10,14) then 59 -- Municipal Explore
         else null 
         end 
     -- MOE USE2 8 - Cooling or A/C
     when dloc.LOC_MOE_USE_2ND_CODE=8 then 
         case
         when dbore.BH_STATUS_CODE in (1) then 28 -- Other Industrial
         when dbore.BH_STATUS_CODE in (2,3) then 9 -- Cooling Water
         else null 
         end 
     -- MOE USE2 9 - Not Used
     when dloc.LOC_MOE_USE_2ND_CODE=9 then 
         case 
         when dbore.BH_STATUS_CODE is null then 51 -- Monitor/Obs Well
         when dbore.BH_STATUS_CODE in (2,10,14,15) then 51 -- Monitor/Obs Well
         when dbore.BH_STATUS_CODE in (3) then 71 -- Unknown
         when dbore.BH_STATUS_CODE in (5,6) then 33 -- Other Water Supply
         else null 
         end
     -- MOE USE2 10 - Other
     when dloc.LOC_MOE_USE_2ND_CODE=10 then 
         case 
         when dbore.BH_STATUS_CODE in (10,14) then 51 -- Monitor/Obs Well
         when dbore.BH_STATUS_CODE in (3,13) then 71 -- Unknown 
         else null 
         end 
     -- MOE USE2 11 - Test Hole
     when dloc.LOC_MOE_USE_2ND_CODE=11 then
         case 
         when dbore.BH_STATUS_CODE=10 then 51 -- Monitor/Obs Well
         else null
         end
     -- MOE USE2 12 - Dewatering
     when dloc.LOC_MOE_USE_2ND_CODE=12 then 
         case 
         when dbore.BH_STATUS_CODE is null then 27 -- Other Dewatering
         when dbore.BH_STATUS_CODE in (2,14) then 51 -- Monitoring/Obs Well
         when dbore.BH_STATUS_CODE in (3,9,10,11) then 27 -- Other Dewatering
         else null 
         end
     -- MOE USE2 13 - Monitoring
     when dloc.LOC_MOE_USE_2ND_CODE=13 then 
         case 
         when dbore.BH_STATUS_CODE is null then 51 -- Monitor/Obs Well
         when dbore.BH_STATUS_CODE in (1,2,4,5,6,7,8,9,10,11,12,13,14,15) then 51 -- Monitor/Obs Well
         when dbore.BH_STATUS_CODE=3 then 47 -- Geotech Testhole
         else null 
         end
     else null
     end
 --***** MOE USE1 12 - Dewatering
 when dloc.LOC_MOE_USE_1ST_CODE=12 then 
     case 
     -- MOE USE2 0 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case 
         when dbore.BH_STATUS_CODE is null then 27 -- Other Dewatering
         when dbore.BH_STATUS_CODE in (1,5) then 33 -- Other Water Supply
         when dbore.BH_STATUS_CODE in (2,3,9,10,11,12) then 27 -- Other Dewatering
         else null
         end
	-- MOE USE2 2 - Livestock
	when dloc.LOC_MOE_USE_2ND_CODE=2 then 
	    case 
	    when dbore.BH_STATUS_CODE in (1) then 27 -- Other Dewatering
	    when dbore.BH_STATUS_CODE in (10) then 24 -- Other Agricultural
	    else null 
	    end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 27 -- Other Dewatering
         when dbore.BH_STATUS_CODE in (1,3,5,6,7,9,10) then 27 -- Other Dewatering
         when dbore.BH_STATUS_CODE in (2,14) then 51 -- Monitor/Obs Well
         else null 
         end
     -- MOE USE2 5 - Commericial 
     when dloc.LOC_MOE_USE_2ND_CODE=5 then
         case
         when dbore.BH_STATUS_CODE in (1) then 33 -- Other Water Supply
         when dbore.BH_STATUS_CODE in (9) then 27 -- Other Dewatering
         end
     -- MOE USE2 6 - Municipal
     when dloc.LOC_MOE_USE_2ND_CODE=6 then
         case
         when dbore.BH_STATUS_CODE in (4) then 33 -- Other Water Supply
         else null
         end
	-- MOE USE2 10 - Other
	when dloc.LOC_MOE_USE_2ND_CODE=10 then 
	     case
		 when dbore.BH_STATUS_CODE in (9) then 27 -- Other Dewatering
		 else null
		 end
     -- MOE USE2 11 - Test Hole
     when dloc.LOC_MOE_USE_2ND_CODE=11 then 
         case
         when dbore.BH_STATUS_CODE=3 then 47 -- Geotech Testhole
		 when dbore.BH_STATUS_CODE in (9) then 27 -- Other Dewatering
         else null  
         end 
     -- MOE USE2 13 - Monitoring
     when dloc.LOC_MOE_USE_2ND_CODE=13 then 
         case 
         when dbore.BH_STATUS_CODE in (2,3,9,10,14) then 51 -- Monitor/Obs Well
         else null 
         end
     else null
     end
 --***** MOE USE1 13 - Monitoring    
 when dloc.LOC_MOE_USE_1ST_CODE=13 then 
     case 
     -- MOE USE2 0 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case 
         when dbore.BH_STATUS_CODE is null then 51 -- Monitoring Well
         when dbore.BH_STATUS_CODE in (1,2,3,5,6,9,10,11,12,13,14,15) then 51 -- Monitoring Well
         when dbore.BH_STATUS_CODE in (4) then 83 -- Recharge Well
         else null
         end
     -- MOE USE2 3 - Irrigation
     when dloc.LOC_MOE_USE_2ND_CODE=3 then 
         case 
         when dbore.BH_STATUS_CODE=2 then 51 -- Monitor/Obs Well
         when dbore.BH_STATUS_CODE=9 then 27 -- Other Dewatering
         else null 
         end
     -- MOE USE2 4 - Industrial
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
         case 
         when dbore.BH_STATUS_CODE is null then 51 -- Monitor/Obs Well
	    when dbore.BH_STATUS_CODE in (1) then 33 -- Other Water Supply
         when dbore.BH_STATUS_CODE in (2,3,5,6,7,9,10,11,12,13,14,15) then 51 -- Monitor/Obs Well
	    when dbore.BH_STATUS_CODE in (4) then 83 -- Recharge Well
         else null 
         end
     -- MOE USE2 6 - Municipal
     when dloc.LOC_MOE_USE_2ND_CODE=6 then
         case
         when dbore.BH_STATUS_CODE in (3) then 33 -- Other Water Supply
         else null
         end
     -- MOE USE2 7 - Public Supply
     when dloc.LOC_MOE_USE_2ND_CODE=7 then
         case 
         when dbore.BH_STATUS_CODE in (11) then 33 -- Other Water Supply
         else null
         end
     -- MOE USe2 8 - Cooling or A/C
     when dloc.LOC_MOE_USE_2ND_CODE=8 then
         case 
         when dbore.BH_STATUS_CODE in (3) then 30 -- Other Miscellaneous
         else null
         end
     -- MOE USE2 9 - Not Used
     when dloc.LOC_MOE_USE_2ND_CODE=9 then 
         case 
         when dbore.BH_STATUS_CODE is null then 51 -- Monitor/Obs Well
         when dbore.BH_STATUS_CODE in (2,10) then 51 -- Monitor/Obs Well
         else null 
         end
     -- MOE USE2 10 - Other
     when dloc.LOC_MOE_USE_2ND_CODE=10 then 
         case
         when dbore.BH_STATUS_CODE is null then 30 -- Other Miscellaneous 
		 when dbore.BH_STATUS_CODE in (2,10,11,13) then 51 -- Monitoring Well
         when dbore.BH_STATUS_CODE=4 then 83 -- Recharge Well
         else null 
         end 
     -- MOE USE2 11 - Test Hole
     when dloc.LOC_MOE_USE_2ND_CODE=11 then 
         case
         when dbore.BH_STATUS_CODE is null then 51 -- Monitor/Obs Well
         when dbore.BH_STATUS_CODE in (2,3,5,6,7,10,13,14,15) then 51 -- Monitor/Obs Well
         else null  
         end 
     -- MOE USE2 12 - Dewatering
     when dloc.LOC_MOE_USE_2ND_CODE=12 then 
         case 
         when dbore.BH_STATUS_CODE in (2,9,14) then 51 -- Monitor/Obs Well
         when dbore.BH_STATUS_CODE in (10) then 27 -- Other Dewatering
         else null 
         end
	 -- MOE USE2 13 - Monitoring
	 when dloc.LOC_MOE_USE_2ND_CODE=13 then 
	     case 
	     when dbore.BH_STATUS_CODE is null then 51 -- Monitoring Well
		when dbore.BH_STATUS_CODE in (2,3,14) then 51 -- Monitoring Well
		else null 
		end
     else null
     end   
 -- MOE USE1 14 - Monitoring and Test Well
 when dloc.LOC_MOE_USE_1ST_CODE=14 then  
     case
     -- MOE USE2 0 - Undefined
     when dloc.LOC_MOE_USE_2ND_CODE=0 then
         case 
         when dbore.BH_STATUS_CODE is null then 51 -- Monitoring Well
         when dbore.BH_STATUS_CODE in (1,2,3,5,6,9,10,11,12,13,14,15) then 51 -- Monitoring Well
         else null
         end 
     -- MOE USE2 3 - Irrigation
     when dloc.LOC_MOE_USE_2ND_CODE=3 then
         case
         when dbore.BH_STATUS_CODE in (14) then 51 -- Monitoring Well
         else null
         end
     -- MOE USE2 4 - Dewatering
     when dloc.LOC_MOE_USE_2ND_CODE=4 then 
		 case 
		 when dbore.BH_STATUS_CODE is null then 51 -- Monitoring Well
		 when dbore.BH_STATUS_CODE in (1) then 33 -- Other Water Supply
		 when dbore.BH_STATUS_CODE in (2,3,4,5,6,9,10,13,14,15) then 51 -- Monitoring Well
		 else null 
		 end
     -- MOE USE2 6 - Municipal
     when dloc.LOC_MOE_USE_2ND_CODE=6 then
         case
         when dbore.BH_STATUS_CODE in (2,13) then 51 -- Monitoring Well
         else null
         end
     -- MOE USE2 10 - Other
     when dloc.LOC_MOE_USE_2ND_CODE=10 then
         case
         when dbore.BH_STATUS_CODE in (2,3,10,14) then 51 -- Monitoring Well
         else null
         end
     -- MOE USE2 12 - Dewatering
     when dloc.LOC_MOE_USE_2ND_CODE=12 then
         case
         when dbore.BH_STATUS_CODE is null then 51 -- Monitoring Well
         when dbore.BH_STATUS_CODE in (10) then 51 -- Monitoring Well
         else null
         end
     -- MOE USE2 14 - Monitoring and Test Hole
     when dloc.LOC_MOE_USE_2ND_CODE=14 then
         case
         when dbore.BH_STATUS_CODE in (14) then 51 -- Monitoring Well
         else null
         end
	else null 
	end 
 else null 
 end as [SECONDARY_PURPOSE_CODE]
,cast(null as int) as SYS_RECORD_ID
,row_number() over (order by dloc.LOC_ID) as rkey
into MOE_20250711.dbo.M_D_LOCATION_PURPOSE
from 
MOE_20250711.dbo.M_D_LOCATION as dloc
inner join MOE_20250711.dbo.M_D_BOREHOLE as dbore
on dloc.LOC_ID=dbore.LOC_ID 

--***** END_TAG

drop table moe_20250711.dbo.m_d_location_purpose

--***** The following check is used when NULL values are calculated when assigning the
--***** purpose codes to each location

-- v20180530 28 rows
-- v20190509 11 rows
-- v20200721 10 rows
-- v20210119 162 rows
-- v20220328 8 rows
-- v20230324 2 rows
-- v20240326 7 rows
-- v20250711 4 rows

select
t2.LOC_STATUS_CODE
,rlsc.LOC_STATUS_DESCRIPTION
,t2.BH_STATUS_CODE
,rbsc.BH_STATUS_DESCRIPTION
,t2.LOC_MOE_USE_1ST_CODE
,moe1.LOC_MOE_USE_PRIMARY_DESCRIPTION
,t2.LOC_MOE_USE_2ND_CODE
,moe2.LOC_MOE_USE_SECONDARY_DESCRIPTION
from 
(
select 
yloc.LOC_STATUS_CODE
,ybore.BH_STATUS_CODE
,yloc.LOC_MOE_USE_1ST_CODE
,yloc.LOC_MOE_USE_2ND_CODE
from 
(
select 
dpurp.LOC_ID 
from 
MOE_20250711.dbo.M_D_LOCATION_PURPOSE as dpurp
where 
dpurp.PRIMARY_PURPOSE_CODE is null
or dpurp.SECONDARY_PURPOSE_CODE is null
group by 
dpurp.LOC_ID
) as t
inner join MOE_20250711.dbo.M_D_LOCATION as yloc
on t.LOC_ID=yloc.LOC_ID 
left outer join MOE_20250711.dbo.M_D_BOREHOLE as ybore
on t.LOC_ID=ybore.LOC_ID
group by
yloc.LOC_STATUS_CODE,ybore.BH_STATUS_CODE,yloc.LOC_MOE_USE_1ST_CODE,yloc.LOC_MOE_USE_2ND_CODE
) as t2
left outer join OAK_20160831_MASTER.dbo.R_LOC_STATUS_CODE as rlsc
on t2.LOC_STATUS_CODE=rlsc.LOC_STATUS_CODE
left outer join OAK_20160831_MASTER.dbo.R_BH_STATUS_CODE as rbsc
on t2.BH_STATUS_CODE=rbsc.BH_STATUS_CODE
left outer join OAK_20160831_MASTER.dbo.R_LOC_MOE_USE_PRIMARY_CODE as moe1
on t2.LOC_MOE_USE_1ST_CODE=moe1.LOC_MOE_USE_PRIMARY_CODE
left outer join OAK_20160831_MASTER.dbo.R_LOC_MOE_USE_SECONDARY_CODE as moe2
on t2.LOC_MOE_USE_2ND_CODE=moe2.LOC_MOE_USE_SECONDARY_CODE 
order by
t2.LOC_MOE_USE_1ST_CODE,t2.LOC_MOE_USE_2ND_CODE




