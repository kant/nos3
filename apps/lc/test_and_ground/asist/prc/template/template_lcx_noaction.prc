PROC $sc_$cpu_lcx_noaction
;*******************************************************************************
;  Test Name:  lcx_noaction
;  Test Level: Build Verification
;  Test Type:  Functional
;
;  Test Description
;	The purpose of this test is to verify that Limit Checker eXtended (LCX)
;	functions properly when monitoring WatchPoints (WP). All WP evaluate to
;	a mix of true, false, and not measured. All ActionPoints (AP) Pass so a
;	threshold is not reached causing and action to take place. 
;	During this test the LCX is set as follows:
;       	LCX Active with all AP disabled.  
;	        LCX Active with all AP active.
;        	LCX Active with all AP passive
;       	LCX Active with AP in mix of states (active, passive, disabled,
;		permanently disabled, unused)
;
;      The following WP true/false transitions will be tested:
;      WP1	T, T, T, T	WP7	F, T, F, T
;      WP2	T, T, T, F	WP8	F, T, T, F
;      WP3	T, T, F, F	WP9	F, T, T, T
;      WP4	T, F, F, F	WP10	F, F, T, T
;      WP5	T, F, F, T	WP11	F, F, F, T
;      WP6	T, F, T, F	WP12	F, F, F, F
;
;  Requirements Tested
;    LCX1003	If LCX accepts any command as valid, LCX shall execute the
;		command, increment the LCX Valid Command Counter and issue an
;		event message
;    LCX2003	Upon receipt of a message, LCX shall compare the data in the
;		message to the table-defined value using the table-defined
;		comparison value and comparison operator for each data point
;               defined in the Watchpoint Definition Table (WDT) if the LCX
;		Application State is one of the following:
;                 a) Active
;                 b) Passive
;    LCX2003.2	LCX shall support the following comparison values:
;                 a) =
;                 b) !=
;                 c) >
;                 d) >=
;                 e) <
;                 f) <=
;    LCX2003.4	If the comparison result for a Watchpoint results in a False,
;		LCX shall set the Number of Consecutive True values to zero
;    LCX2004	For each Watchpoint, the flight software shall maintain the
;		following statistics in the dump-only Watchpoint Results Table:
;                 a) The result of the last relational comparison (False, True,
;		     Error or Stale)
;                 b) The number of times this Watchpoint has been compared
;                 c) The number of times this Watchpoint has crossed from the
;		     False to True result
;                 d) The number of consecutive times the comparison has yielded
;		     a True result
;                 e) The cumulative number of times the comparison has yielded a;		     True result
;                 f) Most recent FALSE to TRUE transition value
;                 g) Most recent FALSE to TRUE transition timestamp
;                 h) Most recent TRUE to FALSE transition value
;                 i) Most recent TRUE to FALSE transition timestamp
;    LCX3001	Upon receipt of a Sample Request, LCX shall process the request
;		specified actionpoints defined in the Actionpoint Definition
;		Table (ADT) if the LCX Application State is one of the
;		following:
;                 a) Active
;                 b) Passive
;    LCX3001.1	LCX shall support the following Reverse Polish Operators:
;                 a) and
;                 b) or
;                 c) xor
;                 d) not
;                 e) equals
;    LCX3002	Each table-defined Actionpoint shall be evaluated and the
;		results stored in the dump-only Actionpoint Results Table if the
;		Actionpoint state is either:
;                 a) Active
;                 b) Passive
;    LCX3003	If the Actionpoint is Disabled, LCX shall skip processing that
;		actionpoint
;    LCX3004	If the Actionpoint is Unused, LCX shall skip processing that
;		actionpoint
;    LCX3005	If the Actionpoint is Permanently Disabled, LCX shall skip
;		processing that actionpoint
;    LCX3006	For each Actionpoint, the flight software shall maintain the
;		following statistics in the dump-only Actionpoint Results Table:
;                 a) The result of the last Sample(Pass,Fail,Error,Stale)
;                 b) The current state (PermOff,Disabled,Active,Passive,Unused)
;                 c) The number of times this Actionpoint has crossed from the
;		     Fail to Pass state
;                 d) The number of times this Actionpoint has crossed from the
;		     Pass to Fail state
;                 e) The number of consecutive times the equation result =Failed
;                 f) The cumulative number of times the equation result =Failed
;                 g) The cumulative count of the RTS executions
;                 h) Total number of event messages sent
;    LCX4000	Upon receipt of a Set LCX Application State To Active Command,
;		LCX shall set the state of the LCX Application to Active
;    LCX4003	Upon receipt of a Set Actionpoint to Active Command, LCX shall
;		set the state for the command-specified Actionpoint to ACTIVE
;		such that the actionpoint is evaluated and the table-defined 
;               actions are taken based on the evaluation
;    LCX4004	Upon receipt of a Set All Actionpoints to Active Command, LCX
;		shall set the state for all Actionpoints to ACTIVE such that the
;		actionpoints are evaluated and the table-defined actions are
;		taken based on the evaluation
;    LCX4005	Upon receipt of a Set Actionpoint to Passive Command, LCX shall
;		set the state for the command-specified Actionpoint to PASSIVE
;		such that the actionpoint is evaluated, however, no actions 
;               are taken
;    LCX4006	Upon receipt of a Set All Actionpoints to Passive Command, LCX
;		shall set the state for all Actionpoints to PASSIVE such that
;		all actionpoints are evaluated, however, no actions are taken
;    LCX4007	Upon receipt of a Set Actionpoint to Disabled Command, LCX shall
;		set the state for the command-specified Actionpoint to DISABLED
;		such that the actionpoints are not evaluated and no actions are
;		taken
;    LCX4009	Upon receipt of a Set Actionpoint to Permanent Disable, LCX 
;		shall mark the command-specified Actionpoint such that the 
;		Actionpoint cannot be Activated
;    LCX8000	LCX shall generate a housekeeping message containing the
;		following:
;                 a) Valid  Command Counter
;                 b) Command Rejected Counter
;                 c) Number of Start RTS commands NOT sent to SC task because
;		     LCX Application is PASSIVE
;                 d) Current LC Application State (LCX_ACTIVE, LCX_PASSIVE,
;		     LCX_DISABLED)...
;                 e) Total count of actionpoints sampled while LCX_ACTIVE or
;		     LCX_PASSIVE...
;                 f) Total count of packets monitored for watchpoints (cmd and
;		     tlm)
;                 g) Total count of commands sent to SC task to start an RTS
;                 h) Selected data from watchpoint results table
;                 i) Selected data from actionpoint results table
;    LCX9000	Upon cFE Power-On LCX shall initialize the following
;		Housekeeping data to Zero (or value specified):
;                 a) Valid Command Counter
;                 b) Command Rejected Counter
;                 c) Passive RTS Execution Counter
;                 d) Current LC State to <PLATFORM_DEFINED> Default Power-on
;		     State
;                 e) Actionpoint Sample Count
;                 f) TLM Count
;                 g) RTS Execution Counter
;                 h) Watch Results (bitmapped)
;                 i) Action Results (bitmapped)
;    LCX9001	Upon cFE Power-On LCX shall initialize the following Watchpoint
;		data to Zero (or value specified) for all Watchpoints:
;                 a) The result of the last watchpoint relational comparison to
;		     STALE
;                 b) The number of times this Watchpoint has been compared
;                 c) The number of times this Watchpoint has crossed from the
;		     False to True result
;                 d) The number of consecutive times the comparison has yielded
;		     a True result
;                 e) The cumulative number of times the comparison has yielded a
;		     True result
;                 f) The value that caused the last False-to-True crossing, and
;		     the crossing time stamp
;                 g) The value that caused the last True-to-False crossing, and
;		     the crossing time stamp
;    LCX9002	Upon cFE Power-On LCX shall initialize the following Actionpoint
;		data to Zero (or value specified for all Actionpoints:
;                 a) The result of the last Actionpoint Sample to STALE
;                 b) The current state as defined in the ADT
;                 c) The number of times this Actionpoint has crossed from the
;		     Fail to Pass state
;                 d) The number of times this Actionpoint has crossed from the
;		     Pass to Fail state
;                 e) The number of consecutive times the equation result =Failed
;                 f) The cumulative number of times the equation result = Failed
;                 g) The cumulative count of the RTS executions
;                 h) Total number of event messages sent
;
;  Prerequisite Conditions
;	The cFE is up and running and ready to accept commands. 
;	The LC commands and TLM items exist in the GSE database. 
;	A display page exists for the LC Housekeeping telemetry packet. 
;	LC Test application loaded and running
;
;  Assumptions and Constraints
;	None.
;
;  Change History
;
;	Date	        Name		Description
;	01/30/09	Barbie Medina	Original Procedure.
;	02/07/11	Walt Moleski	Added variable for app and table names
;					and replaced hard-coded instances
;       08/10/12        Walt Moleski    Added UpdateAge argument to the TST_LC
;                                       SendSample command for the LCx app
;
;  Arguments
;	None.
;
;  Procedures Called
;	Name			Description
;       ut_tlmwait        Wait for a specified telemetry point to update to
;                         a specified value. 
;       ut_sendcmd        Send commands to the spacecraft. Verifies command
;                         processed and command error counters.
;       ut_sendrawcmd     Send raw commands to the spacecraft. Verifies command
;                         processed and command error counters.
;       ut_pfindicate     Print the pass fail status of a particular requirement
;                         number.
;       ut_setupevents       Performs setup to verify that a particular event
;                         message was received by ASIST.
;	ut_setrequirements    A directive to set the status of the cFE
;			      requirements array.
;       ftp_file      Procedure to load file containing a table
;       lcx_wdt1      Sets up the Watchpoint Definition table files for testing
;       lcx_adt1a     Sets up the Actionpoint Definition table files for testing
;
;  Expected Test Results and Analysis
;
;**********************************************************************

local logging = %liv (log_procedure)
%liv (log_procedure) = FALSE

#include "ut_statusdefs.h"
#include "ut_cfe_info.h"
#include "cfe_platform_cfg.h"
#include "cfe_evs_events.h"
#include "cfe_es_events.h"
#include "to_lab_events.h"
#include "lc_platform_cfg.h"
#include "lc_msgdefs.h"
#include "lc_tbldefs.h"
#include "lc_events.h"
#include "tst_lc_events.h"

%liv (log_procedure) = logging

#define LCX_1003       0
#define LCX_2003       1
#define LCX_20032      2
#define LCX_20033      3
#define LCX_2004       4
#define LCX_3001       5
#define LCX_30011      6
#define LCX_3002       7
#define LCX_3003       8
#define LCX_3004       9
#define LCX_3005      10
#define LCX_3006      11
#define LCX_4000      12
#define LCX_4003      13
#define LCX_4004      14
#define LCX_4005      15
#define LCX_4006      16
#define LCX_4007      17
#define LCX_4009      18
#define LCX_8000      19
#define LCX_9000      20
#define LCX_9001      21
#define LCX_9002      22

#define WPACKED     (LC_MAX_WATCHPOINTS + 3) / 4
#define APACKED     (LC_MAX_ACTIONPOINTS + 1) / 2

#define CMDFAIL       1
#define CMDSUCCESS    2
global ut_req_array_size = 22
global ut_requirement[0 .. ut_req_array_size]

for i = 0 to ut_req_array_size DO
  ut_requirement[i] = "U"
enddo

;**********************************************************************
; Set the local values
;**********************************************************************

local cfe_requirements[0 .. ut_req_array_size] = ["LCX_1003","LCX_2003", ;;
    "LCX_2003.2","LCX_2003.3","LCX_2004","LCX_3001","LCX_30011","LCX_3002", ;;
    "LCX_3003","LCX_3004","LCX_3005","LCX_3006","LCX_4000","LCX_4003", ;;
    "LCX_4004","LCX_4005","LCX_4006","LCX_4007","LCX_4009","LCX_8000", ;;
    "LCX_9000","LCX_9001","LCX_9002"]

;**********************************************************************
; Define local variables
;**********************************************************************
LOCAL rawcmd
LOCAL stream1
LOCAL index
LOCAL wpindex
LOCAL apindex
LOCAL ADTentries = 10
LOCAL APResults = ADTentries/2
LOCAL WDTentries = 30
LOCAL CmdStatus 
LOCAL State
Local rdlindex
Local maxwp = LC_MAX_WATCHPOINTS - 1
Local maxap = LC_MAX_ACTIONPOINTS - 1
local LCAppName = LC_APP_NAME
local ramDir = "RAM:0"
local defaultTblDir = "CF:0/apps"
local ARTTblName = LCAppName & ".LC_ART"
local WRTTblName = LCAppName & ".LC_WRT"

write ";*********************************************************************"
write ";  Step 1.0:  Initialize the CPU for this test. "
write ";*********************************************************************"
write ";  Step 1.1:  Command a Power-On Reset on $CPU. "
write ";********************************************************************"
/$SC_$CPU_ES_POWERONRESET
wait 10

close_data_center
wait 75
                                                                                
cfe_startup $CPU
wait 5

write ";*********************************************************************"
write ";  Step 1.2: Creating the WDT and ADT used for testing and upload it"
write ";********************************************************************"
s $SC_$CPU_lcx_wdt1

;; Parse the filename configuration parameters for the default table filenames
local wdtFileName = LC_WDT_FILENAME
local slashLoc = %locate(wdtFileName,"/")

;; loop until all slashes are found for the Destination File Table Name
while (slashLoc <> 0) do
  wdtFileName = %substring(wdtFileName,slashLoc+1,%length(wdtFileName))
  slashLoc = %locate(wdtFileName,"/")
enddo

write "==> Default LC Watchpoint Table filename = '",wdtFileName,"'"

s ftp_file(defaultTblDir, "lc_def_wdt1.tbl", wdtFileName, "$CPU", "P")

s $SC_$CPU_lcx_adt1a

;; Parse the filename configuration parameters for the default table filenames
local adtFileName = LC_ADT_FILENAME
slashLoc = %locate(adtFileName,"/")

;; loop until all slashes are found for the Actionpoint Definitaion Table Name
while (slashLoc <> 0) do
  adtFileName = %substring(adtFileName,slashLoc+1,%length(adtFileName))
  slashLoc = %locate(adtFileName,"/")
enddo

write "==> Default LC Actionpoint Table filename = '",adtFileName,"'"

s ftp_file(defaultTblDir, "lc_def_adt1a.tbl", adtFileName, "$CPU", "P")

;; Display the pages
page $SC_$CPU_LC_HK
page $SC_$CPU_TST_LC_HK
page $SC_$CPU_LC_ADT
page $SC_$CPU_LC_WDT
page $SC_$CPU_LC_ART
page $SC_$CPU_LC_WRT

write ";*********************************************************************"
write ";  Step 1.3:  Start the Limit Checker (LC) Application and "
write ";  add any required subscriptions.  "
write ";********************************************************************"
ut_setupevents "$SC", "$CPU", "CFE_ES", CFE_ES_START_INF_EID, "INFO", 1
ut_setupevents "$SC", "$CPU", {LCAppName}, LC_INIT_INF_EID, "INFO", 2

s load_start_app (LCAppName,"$CPU", "LC_AppMain")

; Wait for app startup events
ut_tlmwait  $SC_$CPU_find_event[2].num_found_messages, 1
IF (UT_TW_Status = UT_Success) THEN
  if ($SC_$CPU_find_event[1].num_found_messages = 1) then
    write "<*> Passed - LC Application Started"
  else
    write "<!> Failed - CFE_ES start Event Message for LC not received."
  endif
else
  write "<!> Failed - LC Application start Event Message not received."
endif

;;; Need to set the stream based upon the cpu being used
;;; CPU1 is the default
stream1 = x'8A7'

if ("$CPU" = "CPU2") then
  stream1 = x'9A7'
elseif ("$CPU" = "CPU3") then
  stream1 = x'AA7'
endif

write "Sending command to add subscription for LC housekeeping packet."
/$SC_$CPU_TO_ADDPACKET Stream=stream1 Pkt_Size=x'0' Priority=x'0' Reliability=x'1' Buflimit=x'4'
wait 10

write ";**********************************************************************"
write ";  Step 1.4:  Start the Limit Checker Test Application (TST_LC) and "
write ";  add any required subscriptions.  "
write ";**********************************************************************"
ut_setupevents "$SC", "$CPU", "CFE_ES", CFE_ES_START_INF_EID, "INFO", 1
ut_setupevents "$SC", "$CPU", "TST_LC", TST_LC_INIT_INF_EID, "INFO", 2
                                                                                
s load_start_app ("TST_LC", "$CPU", "TST_LC_AppMain")
                                                                                
; Wait for app startup events
ut_tlmwait  $SC_$CPU_find_event[2].num_found_messages, 1
IF (UT_TW_Status = UT_Success) THEN
  if ($SC_$CPU_find_event[1].num_found_messages = 1) then
    write "<*> Passed - TST_LC Application Started"
  else
    write "<!> Failed - CFE_ES start Event Message for TST_LC not received."
    write "Event Message count = ",$SC_$CPU_find_event[1].num_found_messages
  endif
else
  write "<!> Failed - TST_LC Application start Event Message not received."
endif

;;; Need to set the stream based upon the cpu being used
;;; CPU1 is the default
stream1 = x'933'

if ("$CPU" = "CPU2") then
  stream1 = x'A33'
elseif ("$CPU" = "CPU3") then
  stream1 = x'B33'
endif
                                                                                
write "Sending command to add subscription for TST_LC HK packet."
/$SC_$CPU_TO_ADDPACKET Stream=stream1 Pkt_Size=x'0' Priority=x'0' Reliability=x'1' Buflimit=x'4'
wait 10

wait 5


write ";*********************************************************************"
write ";  Step 1.5: Verify that the LC Housekeeping telemetry items are "
write ";  initialized to zero (0). "
write ";*********************************************************************"
;; Add the HK message receipt test
local hkPktId
                                                                                
;; Set the SC HK packet ID based upon the cpu being used
;; CPU1 is the default
hkPktId = "p0A7"
                                                                                
if ("$CPU" = "CPU2") then
  hkPktId = "p1A7"
elseif ("$CPU" = "CPU3") then
  hkPktId = "p2A7"
endif
                                                                                
;; Verify the HK Packet is getting generated by waiting for the
;; sequencecount to increment twice
local seqTlmItem = hkPktId & "scnt"
local currSCnt = {seqTlmItem}
local expectedSCnt = currSCnt + 2
                                                                                
ut_tlmwait {seqTlmItem}, {expectedSCnt}
if (UT_TW_Status = UT_Success) then
  write "<*> Passed (8000) - Housekeeping packet is being generated."
  ut_setrequirements LCX_8000, "P"
else
  write "<!> Failed (8000) - Housekeeping packet sequence count did not increment. Housekeeping packet is not being received."
  ut_setrequirements LCX_8000, "P"
endif

;check initialization of housekeeping 
if ($SC_$CPU_LC_CMDPC = 0) AND ($SC_$CPU_LC_CMDEC = 0) AND ;;
   ($SC_$CPU_LC_PASSRTSCNT = 0) AND ($SC_$CPU_LC_APSAMPLECNT = 0) AND ;;
   ($SC_$CPU_LC_CURLCSTATE=LC_STATE_POWER_ON_RESET) AND ;;
   ($SC_$CPU_LC_MONMSGCNT = 0) AND ($SC_$CPU_LC_RTSCNT = 0) THEN
;; 255 because the WPs are all not measured   
  for wpindex = 1 to WPACKED do
    if ($SC_$CPU_LC_WRRESULTS[wpindex].WPByteEntry.AllStatus <> 255) then
      break
    endif
  enddo
;first check the 10 APs that are being used
;;255 is because they are disabled and not measured
  for apindex = 1 to 10 do
    if ($SC_$CPU_LC_ARRESULTS[apindex].APByteEntry.AllStatus <> 255) then
      break                                   
    endif
  enddo
;then check the rest of the APs
;; 51 is because the APs are not used and not measured
  for apindex = 11 to APACKED do
    if ($SC_$CPU_LC_ARRESULTS[apindex].APByteEntry.AllStatus <> 51) then
      break                                   
    endif
  enddo

  if (wpindex < WPACKED) OR (apindex < APACKED) then
    write "<!> Failed (9000) - Housekeeping telemetry NOT initialized at startup."
    write "  CMDPC             = ", $SC_$CPU_LC_CMDPC 
    write "  CMDEC             = ", $SC_$CPU_LC_CMDEC 
    write "  PASSRTSCNT        = ", $SC_$CPU_LC_PASSRTSCNT
    write "  CURLCSTATE        = ", p@$SC_$CPU_LC_CURLCSTATE
    write "  APSAMPLECNT       = ", $SC_$CPU_LC_APSAMPLECNT 
    write "  MONMSGCNT         = ", $SC_$CPU_LC_MONMSGCNT
    write "  RTSCNT            = ", $SC_$CPU_LC_RTSCNT 
    if (wpindex < WPACKED) then
      write "  WP Packed Results = ", %hex($SC_$CPU_LC_WRRESULTS[wpindex].WPByteEntry.AllStatus,2)
    endif
    if (apindex < APACKED) then
      write "  AP Packed Results = ", %hex($SC_$CPU_LC_ARRESULTS[apindex].APByteEntry.AllStatus,2)
    endif
    ut_setrequirements LCX_9000, "F"
  else
    write "<*> Passed (9000) - Housekeeping telemetry initialized properly."
    ut_setrequirements LCX_9000, "P"
  endif  
else
  write "<!> Failed (9000) - Housekeeping telemetry NOT initialized at startup."
  write "  CMDPC             = ", $SC_$CPU_LC_CMDPC 
  write "  CMDEC             = ", $SC_$CPU_LC_CMDEC 
  write "  PASSRTSCNT        = ", $SC_$CPU_LC_PASSRTSCNT
  write "  CURLCSTATE        = ", p@$SC_$CPU_LC_CURLCSTATE
  write "  APSAMPLECNT       = ", $SC_$CPU_LC_APSAMPLECNT 
  write "  MONMSGCNT         = ", $SC_$CPU_LC_MONMSGCNT
  write "  RTSCNT            = ", $SC_$CPU_LC_RTSCNT 
  if (wpindex < WPACKED) then
    write "  WP Packed Results = ", %hex($SC_$CPU_LC_WRRESULTS[wpindex].WPByteEntry.AllStatus,2)
  endif
  if (apindex < APACKED) then
    write "  AP Packed Results = ", %hex($SC_$CPU_LC_ARRESULTS[apindex].APByteEntry.AllStatus,2)
  endif
  ut_setrequirements LCX_9000, "F"
endif

;check initialization of WRT
;;; CPU1 is the default
wpindex = "0FB9"

if ("$CPU" = "CPU2") then
   wpindex = "0FD7"
elseif ("$CPU" = "CPU3") then
   wpindex = "0FF7"
endif

s get_tbl_to_cvt(ramDir, WRTTblName, "A", "$cpu_dumpwrt", "$CPU", wpindex)
wait 5

for index = 0 to LC_MAX_WATCHPOINTS-1 do
  if ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_STALE) or ;;
     ($SC_$CPU_LC_WRT[index].EvaluationCount <> 0) or ;;
     ($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 0) or ;;
     ($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
     ($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 0) or ;;
     ($SC_$CPU_LC_WRT[index].FtoTValue <> 0) or ;;
     ($SC_$CPU_LC_WRT[index].TtoFValue <> 0) then
    break
  endif
enddo

if (index < LC_MAX_WATCHPOINTS-1) then
  write "<!> Failed (9001) - Watchpoint Results Table NOT initialized at startup."
  write " Error occurred at index = ", index
  write " WatchResults            = ", p@$SC_$CPU_LC_WRT[index].WatchResults
  write " Evaluation Count        = ", $SC_$CPU_LC_WRT[index].EvaluationCount
  write " False to True Count     = ", $SC_$CPU_LC_WRT[index].FalsetoTrueCount
  write " Consecutive True        = ", $SC_$CPU_LC_WRT[index].ConsectiveTrueCount
  write " Cum True Count          = ", $SC_$CPU_LC_WRT[index].CumulativeTrueCount
  write " F to T Value            = ", $SC_$CPU_LC_WRT[index].FtoTValue
  write " T to F Value            = ", $SC_$CPU_LC_WRT[index].TtoFValue
  ut_setrequirements LCX_9001, "F"
else
  write "<*> Passed (9001) - Watchpoint Results Table initialized properly."
  ut_setrequirements LCX_9001, "P"  
endif

;check initialization of ART
;;; CPU1 is the default
apindex = "0FB8"

if ("$CPU" = "CPU2") then
   apindex = "0FD6"
elseif ("$CPU" = "CPU3") then
   apindex = "0FF6"
endif

s get_tbl_to_cvt(ramDir, ARTTblName, "A", "$cpu_dumpart", "$CPU", apindex)
wait 5 

for index = 0 to LC_MAX_ACTIONPOINTS-1 do
  if (index < ADTentries) then
    if  ($SC_$CPU_LC_ART[index].ActionResult <> LC_ACTION_STALE) or ;;
	($SC_$CPU_LC_ART[index].CurrentState <> LC_APSTATE_DISABLED) or ;;
	($SC_$CPU_LC_ART[index].FailToPassCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].PassToFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].ConsecutiveFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].CumulativeFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].CumulativeRTSExecCount <> 0) then
      break
    endif
  else
    if  ($SC_$CPU_LC_ART[index].ActionResult <> LC_ACTION_STALE) or ;;
	($SC_$CPU_LC_ART[index].CurrentState <> LC_ACTION_NOT_USED) or ;;
	($SC_$CPU_LC_ART[index].FailToPassCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].PassToFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].ConsecutiveFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].CumulativeFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].CumulativeRTSExecCount <> 0) then
      break
    endif
  endif
enddo

if (index < LC_MAX_ACTIONPOINTS-1) then
  write "<!> Failed (9002) - Actionpoint Results Table NOT initialized at startup."
  write "  Error occurred at index = ", index
  write "  Action Results          = ", p@$SC_$CPU_LC_ART[index].ActionResult
  write "  Current State           = ", p@$SC_$CPU_LC_ART[index].CurrentState
  write "  Fail to Pass Count      = ", $SC_$CPU_LC_ART[index].FailToPassCount
  write "  Pass to Fail Count      = ", $SC_$CPU_LC_ART[index].PassToFailCount
  write "  Consecutive Fail Count  = ", $SC_$CPU_LC_ART[index].ConsecutiveFailCount
  write "  Cum Fail Count          = ", $SC_$CPU_LC_ART[index].CumulativeFailCount
  write "  Cum RTS Count           = ", $SC_$CPU_LC_ART[index].CumulativeRTSExecCount
  ut_setrequirements LCX_9002, "F"
else
  write "<*> Passed (9002) - Actionpoint Results Table initialized properly."
  ut_setrequirements LCX_9002, "P"  
endif

write ";*********************************************************************"
write ";  Step 2.0: Test LC Active All AP disabled, WP cause a mix of "
write ";  thresholds to be reached.  All AP pass "
write ";*********************************************************************"
write ";  Step 2.1:  Send a Set LC Application State to Active Command"
write ";*********************************************************************"
ut_setupevents "$SC", "$CPU", {LCAppName}, LC_LCSTATE_INF_EID, "INFO", 1
State = LC_STATE_ACTIVE
ut_sendcmd "$SC_$CPU_LC_SETLCSTATE NewLCState=State"
 
if (ut_sc_status = UT_SC_Success) and ($SC_$CPU_LC_CURLCSTATE=LC_STATE_ACTIVE) then
  write "<*> Passed (1003;4000) - Set LC Application State to Active command properly sent."
  ut_setrequirements LCX_1003, "P"
  ut_setrequirements LCX_4000, "P"
else
  write "<!> Failed (1003;4000) - Set LC Application State to Active command not sent properly (", ut_sc_status, ")."
  ut_setrequirements LCX_1003, "F"
  ut_setrequirements LCX_4000, "F"
endif

if ($SC_$CPU_find_event[1].num_found_messages = 1) THEN
  write "<*> Passed (1003;4000) - Event message ",$SC_$CPU_find_event[1].eventid, " received"
  ut_setrequirements LCX_1003, "P"
  ut_setrequirements LCX_4000, "P"
else
  write "<!> Failed (1003;4000) - Event message ",$SC_$CPU_evs_eventid," received. Expected Event message ",LC_LCSTATE_INF_EID, "."
  ut_setrequirements LCX_1003, "F"
  ut_setrequirements LCX_4000, "F"
endif

wait 5

write ";*********************************************************************"
write ";  Step 2.2 Send packets for all WP defined in WDT, data run 1"
write ";*********************************************************************"

s $sc_$cpu_lcx_sendpackets("2.2",1)

write ";*********************************************************************"
write ";  Step 2.3 Send Sample Request for all 10 APs.  Nothing should"
write ";  happen since all AP disabled"
write ";*********************************************************************"

/$SC_$CPU_TST_LC_SENDSAMPLE StartAP=0 EndAP=9 UpdateAge=0
ut_tlmupdate $SC_$CPU_TST_LC_CMDPC

write ";*********************************************************************"
write ";  Step 2.4 Check housekeeping counters"
write ";*********************************************************************"

if ($SC_$CPU_LC_APSAMPLECNT = 0) AND ($SC_$CPU_LC_MONMSGCNT = 20) AND ;;
   ($SC_$CPU_LC_RTSCNT = 0) AND ($SC_$CPU_LC_PASSRTSCNT = 0) AND ;;
   ($SC_$CPU_LC_WPSINUSE = 30) AND ($SC_$CPU_LC_ACTIVEAPS = 0) AND ;;
   ($SC_$CPU_LC_CURLCSTATE=LC_STATE_ACTIVE) THEN
  for wpindex = 1 to WPACKED do
    if (wpindex = 1) then
      if ($SC_$CPU_LC_WRRESULTS[wpindex].WPByteEntry.AllStatus <> 0x55) then
        break
      endif
    elseif  (wpindex = 2) then
      if ($SC_$CPU_LC_WRRESULTS[wpindex].WPByteEntry.AllStatus <> 0x5) then
        break
      endif
    elseif (wpindex >=3) and (wpindex <=7) then
      if ($SC_$CPU_LC_WRRESULTS[wpindex].WPByteEntry.AllStatus <> 0) then
        break
      endif
    elseif  (wpindex = 8) then
      if ($SC_$CPU_LC_WRRESULTS[wpindex].WPByteEntry.AllStatus <> 0xf0) then
        break
      endif
    else
      if ($SC_$CPU_LC_WRRESULTS[wpindex].WPByteEntry.AllStatus <> 0xff) then
        break
      endif
    endif 
  enddo

;; for the 10 APs that are being used, should be 0xFF since they are disabled have not been measured
;; rest should be 0x33 since they are not used and not measured
  for apindex = 1 to APACKED do
    if (apindex <= 5) then
      if ($SC_$CPU_LC_ARRESULTS[apindex].APByteEntry.AllStatus <> 0xff) then
        break                                   
      endif
    else
      if ($SC_$CPU_LC_ARRESULTS[apindex].APByteEntry.AllStatus <> 0x33) then
        break                                   
      endif
    endif
  enddo
 
  if (wpindex < WPACKED) OR (apindex < APACKED) then
    write "<!> Failed (8000) - Housekeeping telemetry NOT correct after processing WPs."
    write "  CMDPC             = ", $SC_$CPU_LC_CMDPC 
    write "  CMDEC             = ", $SC_$CPU_LC_CMDEC 
    write "  PASSRTSCNT        = ", $SC_$CPU_LC_PASSRTSCNT
    write "  CURLCSTATE        = ", p@$SC_$CPU_LC_CURLCSTATE
    write "  APSAMPLECNT       = ", $SC_$CPU_LC_APSAMPLECNT 
    write "  MONMSGCNT         = ", $SC_$CPU_LC_MONMSGCNT
    write "  RTSCNT            = ", $SC_$CPU_LC_RTSCNT 
    write "  Passive RTSCNT    = ", $SC_$CPU_LC_PASSRTSCNT 
    write "  WP in use         = ", $SC_$CPU_LC_WPSINUSE
    write "  Active APs        = ", $SC_$CPU_LC_ACTIVEAPS

    if (wpindex < WPACKED) then
      write "  WP Packed index   = ", wpindex
      write "  WP Packed Results = ", %hex($SC_$CPU_LC_WRRESULTS[wpindex].WPByteEntry.AllStatus,2)
    endif
    if (apindex < APACKED) then
      write "  AP Packed index   = ", apindex
      write "  AP Packed Results = ", %hex($SC_$CPU_LC_ARRESULTS[apindex].APByteEntry.AllStatus,2)
    endif
    ut_setrequirements LCX_8000, "F"
  else
    write "<*> Passed (8000) - Housekeeping telemetry updated properly."
    ut_setrequirements LCX_8000, "P"
  endif  
else
  write "<!> Failed (8000) - Housekeeping telemetry NOT correct after processing WPs."
  write "  CMDPC          = ", $SC_$CPU_LC_CMDPC 
  write "  CMDEC          = ", $SC_$CPU_LC_CMDEC 
  write "  PASSRTSCNT     = ", $SC_$CPU_LC_PASSRTSCNT
  write "  CURLCSTATE     = ", p@$SC_$CPU_LC_CURLCSTATE
  write "  APSAMPLECNT    = ", $SC_$CPU_LC_APSAMPLECNT 
  write "  MONMSGCNT      = ", $SC_$CPU_LC_MONMSGCNT
  write "  RTSCNT         = ", $SC_$CPU_LC_RTSCNT 
  write "  Passive RTSCNT = ", $SC_$CPU_LC_PASSRTSCNT 
  write "  WP in use      = ", $SC_$CPU_LC_WPSINUSE
  write "  Active APs     = ", $SC_$CPU_LC_ACTIVEAPS
  write "  Failed due to housekeeping counters so Packed Results were not checked"
  ut_setrequirements LCX_8000, "F"
endif

write ";*********************************************************************"
write ";  Step 2.5 Dump WRT and check counters"
write ";*********************************************************************"

;;; CPU1 is the default
wpindex = "0FB9"

if ("$CPU" = "CPU2") then
   wpindex = "0FD7"
elseif ("$CPU" = "CPU3") then
   wpindex = "0FF7"
endif
s get_tbl_to_cvt(ramDir, WRTTblName, "A", "$cpu_dumpwrt", "$CPU", wpindex)
wait 5

for index = 0 to LC_MAX_WATCHPOINTS-1 do
  if (index = 0) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <>0x19) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0) then
      break
    endif
  elseif (index = 1) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x45) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0) then
      break
    endif
  elseif (index = 2) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x1346) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0) then
      break
    endif
  elseif (index = 3) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x54) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0) then
      break
    endif
  elseif (index = 4) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0xff60) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0) then
      break
    endif
  elseif (index = 5) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x230) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0) then
      break
    endif
  elseif (index > 5) and (index < WDTentries) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_FALSE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0) then
;;	($SC_$CPU_LC_WRT[index].TtoFValue <> 0) then
      break
    endif
  else
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_STALE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0) then
      break
    endif
  endif
enddo

if (index < LC_MAX_WATCHPOINTS-1) then
  write "<!> Failed (2003;2003.2;2003.3;2004) - WRT show WPs not evaluated properly."
  write "<!> Error occurred at WP = ", index
  write " WatchResults            = ", p@$SC_$CPU_LC_WRT[index].WatchResults
  write " Evaluation Count        = ", $SC_$CPU_LC_WRT[index].EvaluationCount
  write " False to True Count     = ", $SC_$CPU_LC_WRT[index].FalsetoTrueCount
  write " Consecutive True        = ", $SC_$CPU_LC_WRT[index].ConsectiveTrueCount
  write " Cum True Count          = ", $SC_$CPU_LC_WRT[index].CumulativeTrueCount
  write " F to T Value            = ", $SC_$CPU_LC_WRT[index].FtoTValue
  write " T to F Value            = ", $SC_$CPU_LC_WRT[index].TtoFValue
  ut_setrequirements LCX_2003, "F"
  ut_setrequirements LCX_20032, "F"
  ut_setrequirements LCX_20033, "F"
  ut_setrequirements LCX_2004, "F"
else
  write "<*> Passed (2003;2003.2;2003.3;2004) -  WRT shows WPs evaluated properly."
  ut_setrequirements LCX_2003, "P"
  ut_setrequirements LCX_20032, "P"
  ut_setrequirements LCX_20033, "P"
  ut_setrequirements LCX_2004, "P"
endif

write ";*********************************************************************"
write ";  Step 2.6 Dump ART and check counters"
write ";*********************************************************************"
;;; CPU1 is the default
apindex = "0FB8"

if ("$CPU" = "CPU2") then
   apindex = "0FD6"
elseif ("$CPU" = "CPU3") then
   apindex = "0FF6"
endif

s get_tbl_to_cvt(ramDir, ARTTblName, "A", "$cpu_dumpart", "$CPU", apindex)
wait 5 

for index = 0 to LC_MAX_ACTIONPOINTS-1 do
  if (index < ADTentries) then
    if  ($SC_$CPU_LC_ART[index].ActionResult <> LC_ACTION_STALE) or ;;
	($SC_$CPU_LC_ART[index].CurrentState <> LC_APSTATE_DISABLED) or ;;
	($SC_$CPU_LC_ART[index].FailToPassCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].PassToFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].ConsecutiveFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].CumulativeFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].CumulativeRTSExecCount <> 0) then
      break
    endif
  else
    if  ($SC_$CPU_LC_ART[index].ActionResult <> LC_ACTION_STALE) or ;;
	($SC_$CPU_LC_ART[index].CurrentState <> LC_ACTION_NOT_USED) or ;;
	($SC_$CPU_LC_ART[index].FailToPassCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].PassToFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].ConsecutiveFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].CumulativeFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].CumulativeRTSExecCount <> 0) then
      break
    endif
  endif
enddo

if (index < LC_MAX_ACTIONPOINTS-1) then
  write "<!> Failed (3001;3001.1;3002;3003;3004;3006) - ART show APs not evaluated properly."
  write "<!> Error occurred at AP = ", index
  write "  Action Results         = ", p@$SC_$CPU_LC_ART[index].ActionResult
  write "  Current State          = ", p@$SC_$CPU_LC_ART[index].CurrentState
  write "  Fail to Pass Count     = ", $SC_$CPU_LC_ART[index].FailToPassCount
  write "  Pass to Fail Count     = ", $SC_$CPU_LC_ART[index].PassToFailCount
  write "  Consecutive Fail Count = ", $SC_$CPU_LC_ART[index].ConsecutiveFailCount
  write "  Cum Fail Count         = ", $SC_$CPU_LC_ART[index].CumulativeFailCount
  write "  Cum RTS Count          = ", $SC_$CPU_LC_ART[index].CumulativeRTSExecCount
  ut_setrequirements LCX_3001, "F"
  ut_setrequirements LCX_30011, "F"
  ut_setrequirements LCX_3002, "F"
  ut_setrequirements LCX_3003, "F"
  ut_setrequirements LCX_3004, "F"
  ut_setrequirements LCX_3006, "F"
else
  write "<*> Passed (3001;3001.1;3002;3003;3004;3006) -  ART shows APs evaluated properly."
  ut_setrequirements LCX_3001, "P"
  ut_setrequirements LCX_30011, "P"
  ut_setrequirements LCX_3002, "P"
  ut_setrequirements LCX_3003, "P"
  ut_setrequirements LCX_3004, "P"
  ut_setrequirements LCX_3006, "P"
endif

write ";*********************************************************************"
write ";  Step 3.0:  Test LC Active All AP active, WP cause a mix of thresholds"
write ";  to be reached.  All AP pass"
write ";*********************************************************************"
write ";  Step 3.1:  Send a Set all AP to Active Command"
write ";*********************************************************************"
ut_setupevents "$SC", "$CPU", {LCAppName}, LC_APSTATE_INF_EID, "INFO", 1
State = LC_APSTATE_ACTIVE
ut_sendcmd "$SC_$CPU_LC_SETAPSTATE APNumber=0xFFFF NewAPState=State"
CmdStatus = CMDSUCCESS

if ($SC_$CPU_find_event[1].num_found_messages = 1) THEN
  write "<*> Passed (1003;4004) - Event message ",$SC_$CPU_find_event[1].eventid, " received"
  ut_setrequirements LCX_1003, "P"
  ut_setrequirements LCX_4004, "P"
else
  write "<!> Failed (1003;4004) - Event message ",$SC_$CPU_evs_eventid," received. Expected Event message ",LC_APSTATE_INF_EID, "."
  ut_setrequirements LCX_1003, "F"
  ut_setrequirements LCX_4004, "F"
endif

s get_tbl_to_cvt(ramDir, ARTTblName, "A", "$cpu_dumpart", "$CPU", apindex)
wait 5

for index = 0 to ADTEntries-1 do
  if ($SC_$CPU_LC_ART[index].CurrentState <> LC_APSTATE_ACTIVE) then
    CmdStatus = CMDFAIL
    break
  endif
enddo

for index = ADTEntries to LC_MAX_ACTIONPOINTS-1 do
  if ($SC_$CPU_LC_ART[index].CurrentState <> LC_ACTION_NOT_USED) then
    CmdStatus = CMDFAIL
    break
  endif
enddo

if (ut_sc_status = UT_SC_Success) and (CmdStatus = CMDSUCCESS) then
  write "<*> Passed (1003;4004) - Set All APs to Passive command properly sent."
  ut_setrequirements LCX_1003, "P"
  ut_setrequirements LCX_4004, "P"
else
  write "<!> Failed (1003;4004) - Set All APs to Active command not sent properly (", ut_sc_status, ")."
  write "<*> AP State = ", $SC_$CPU_LC_ART[index].CurrentState 
  ut_setrequirements LCX_1003, "F"
  ut_setrequirements LCX_4004, "F"
endif

wait 5

write ";*********************************************************************"
write ";  Step 3.2 Send packets for all WP defined in WDT, data run 2"
write ";*********************************************************************"

s $sc_$cpu_lcx_sendpackets("3.2",2)

write ";*********************************************************************"
write ";  Step 3.3 Send Sample Request for all 10 APs.  Nothing should"
write ";  all AP Pass"
write ";*********************************************************************"

/$SC_$CPU_TST_LC_SENDSAMPLE StartAP=0 EndAP=9 UpdateAge=0
ut_tlmupdate $SC_$CPU_TST_LC_CMDPC

write ";*********************************************************************"
write ";  Step 3.4 Check housekeeping counters"
write ";*********************************************************************"
if ($SC_$CPU_LC_APSAMPLECNT = 10) AND ($SC_$CPU_LC_MONMSGCNT = 40) AND ;;
   ($SC_$CPU_LC_RTSCNT = 0) AND ($SC_$CPU_LC_PASSRTSCNT = 0) AND ;;
   ($SC_$CPU_LC_WPSINUSE = 30) AND ($SC_$CPU_LC_ACTIVEAPS = 10) AND ;;
   ($SC_$CPU_LC_CURLCSTATE=LC_STATE_ACTIVE) THEN
  CmdStatus = CMDSUCCESS
  if ($SC_$CPU_LC_WRRESULTS[1].WPByteEntry.AllStatus <> 0x15) then
    CmdStatus = CMDFAIL
    wpindex = 1
  endif
  if (CmdStatus = CMDSUCCESS) then
    if ($SC_$CPU_LC_WRRESULTS[2].WPByteEntry.AllStatus <> 0x50) then
      CmdStatus = CMDFAIL
      wpindex = 2
    endif
  endif
  if (CmdStatus = CMDSUCCESS) then
    if ($SC_$CPU_LC_WRRESULTS[3].WPByteEntry.AllStatus <> 0x01) then
      CmdStatus = CMDFAIL
      wpindex = 3
    endif
  endif

  if (CmdStatus = CMDSUCCESS) then
    for wpindex = 4 to WPACKED do
      if (wpindex <=7) then
        if ($SC_$CPU_LC_WRRESULTS[wpindex].WPByteEntry.AllStatus <> 0) then
          break
        endif
      elseif  (wpindex = 8) then
        if ($SC_$CPU_LC_WRRESULTS[wpindex].WPByteEntry.AllStatus <> 0xf0) then
          break
        endif
      else
        if ($SC_$CPU_LC_WRRESULTS[wpindex].WPByteEntry.AllStatus <> 0xff) then
          break
        endif
      endif 
    enddo
  endif

  ;; for the 10 APs that are being used, the result should be 0x44 since they 
  ;; are active and pass. 2 APs are represented by each packed result
  ;; rest should be 0x33 since they are not used and not measured
  for apindex = 1 to APACKED do
    if (apindex <= 5) then
      if ($SC_$CPU_LC_ARRESULTS[apindex].APByteEntry.AllStatus <> 0x44) then
        break                                   
      endif
    else
      if ($SC_$CPU_LC_ARRESULTS[apindex].APByteEntry.AllStatus <> 0x33) then
        break                                   
      endif
    endif
  enddo
 
  if (wpindex < WPACKED) OR (apindex < APACKED) then
    write "<!> Failed (8000) - Housekeeping telemetry NOT correct after processing WPs."
    write "  CMDPC             = ", $SC_$CPU_LC_CMDPC 
    write "  CMDEC             = ", $SC_$CPU_LC_CMDEC 
    write "  PASSRTSCNT        = ", $SC_$CPU_LC_PASSRTSCNT
    write "  CURLCSTATE        = ", p@$SC_$CPU_LC_CURLCSTATE
    write "  APSAMPLECNT       = ", $SC_$CPU_LC_APSAMPLECNT 
    write "  MONMSGCNT         = ", $SC_$CPU_LC_MONMSGCNT
    write "  RTSCNT            = ", $SC_$CPU_LC_RTSCNT 
    write "  Passive RTSCNT    = ", $SC_$CPU_LC_PASSRTSCNT 
    write "  WP in use         = ", $SC_$CPU_LC_WPSINUSE
    write "  Active APs        = ", $SC_$CPU_LC_ACTIVEAPS
    if (wpindex < WPACKED) then
      write "  WP Packed index   = ", wpindex
      write "  WP Packed Results = ", %hex($SC_$CPU_LC_WRRESULTS[wpindex].WPByteEntry.AllStatus,2)
    endif
    if (apindex < APACKED) then
      write "  AP Packed index   = ", apindex
      write "  AP Packed Results = ", %hex($SC_$CPU_LC_ARRESULTS[apindex].APByteEntry.AllStatus,2)
    endif
    ut_setrequirements LCX_8000, "F"
  else
    write "<*> Passed (8000) - Housekeeping telemetry updated properly."
    ut_setrequirements LCX_8000, "P"
  endif  
else
  write "<!> Failed (8000) - Housekeeping telemetry NOT correct after processing WPs."
  write "  CMDPC          = ", $SC_$CPU_LC_CMDPC 
  write "  CMDEC          = ", $SC_$CPU_LC_CMDEC 
  write "  PASSRTSCNT     = ", $SC_$CPU_LC_PASSRTSCNT
  write "  CURLCSTATE     = ", p@$SC_$CPU_LC_CURLCSTATE
  write "  APSAMPLECNT    = ", $SC_$CPU_LC_APSAMPLECNT 
  write "  MONMSGCNT      = ", $SC_$CPU_LC_MONMSGCNT
  write "  RTSCNT         = ", $SC_$CPU_LC_RTSCNT 
  write "  Passive RTSCNT = ", $SC_$CPU_LC_PASSRTSCNT 
  write "  WP in use      = ", $SC_$CPU_LC_WPSINUSE
  write "  Active APs     = ", $SC_$CPU_LC_ACTIVEAPS
  write "  Failed due to housekeeping counters so Packed Results were not checked"
  ut_setrequirements LCX_8000, "F"
endif

write ";*********************************************************************"
write ";  Step 3.5 Dump WRT and check counters, message monitored should be 2 "
write ";  for all entries "
write ";*********************************************************************"
;;; CPU1 is the default
wpindex = "0FB9"

if ("$CPU" = "CPU2") then
  wpindex = "0FD7"
elseif ("$CPU" = "CPU3") then
  wpindex = "0FF7"
endif

s get_tbl_to_cvt(ramDir, WRTTblName, "A", "$cpu_dumpwrt", "$CPU", wpindex)
wait 5

for index = 0 to LC_MAX_WATCHPOINTS-1 do
  if (index = 0) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x19) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0) then
      break
    endif
  elseif (index = 1) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x45) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0) then
      break
    endif
  elseif (index = 2) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x1346) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0) then
      break
    endif
  elseif (index = 3) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_FALSE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x0054) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0x45) then
      break
    endif
  elseif (index = 4) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_FALSE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0xff60) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0xff54) then
      break
    endif
  elseif (index = 5) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_FALSE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x0230) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0x130) then
      break
    endif 
  elseif (index = 6) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x0012456f) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0x0012546f) then
      break
    endif
  elseif (index = 7) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x23451200) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0x23451300) then
      break
    endif
  elseif (index = 8) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x542) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0x546) then
      break
    endif
  elseif (index= 9) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_FALSE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0xf0ab1543) then
      break
    endif
  elseif (index = 10) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_FALSE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0x3f9ddcc6) then
      break
    endif
  elseif (index > 10) and (index < WDTentries) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_FALSE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0) then
;;	($SC_$CPU_LC_WRT[index].TtoFValue <> 0) then
      break
    endif
  else
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_STALE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0) then
      break
    endif
  endif
enddo

if (index < LC_MAX_WATCHPOINTS-1) then
  write "<!> Failed (2003;2003.2;2003.3;2004) - WRT show WPs not evaluated properly."
  write "<!> Error occurred at WP = ", index
  write " WatchResults            = ", p@$SC_$CPU_LC_WRT[index].WatchResults
  write " Evaluation Count        = ", $SC_$CPU_LC_WRT[index].EvaluationCount
  write " False to True Count     = ", $SC_$CPU_LC_WRT[index].FalsetoTrueCount
  write " Consecutive True        = ", $SC_$CPU_LC_WRT[index].ConsectiveTrueCount
  write " Cum True Count          = ", $SC_$CPU_LC_WRT[index].CumulativeTrueCount
  write " F to T Value            = ", $SC_$CPU_LC_WRT[index].FtoTValue
  write " T to F Value            = ", $SC_$CPU_LC_WRT[index].TtoFValue
  ut_setrequirements LCX_2003, "F"
  ut_setrequirements LCX_20032, "F"
  ut_setrequirements LCX_20033, "F"
  ut_setrequirements LCX_2004, "F"
else
  write "<*> Passed (2003;2003.2;2003.3;2004) -  WRT shows WPs evaluated properly."
  ut_setrequirements LCX_2003, "P"
  ut_setrequirements LCX_20032, "P"
  ut_setrequirements LCX_20033, "P"
  ut_setrequirements LCX_2004, "P"
endif

write ";*********************************************************************"
write ";  Step 3.6 Dump ART and check counters"
write ";*********************************************************************"
;;; CPU1 is the default
apindex = "0FB8"

if ("$CPU" = "CPU2") then
   apindex = "0FD6"
elseif ("$CPU" = "CPU3") then
   apindex = "0FF6"
endif

s get_tbl_to_cvt(ramDir, ARTTblName, "A", "$cpu_dumpart", "$CPU", apindex)
wait 5 

for index = 0 to LC_MAX_ACTIONPOINTS-1 do
  if (index < ADTentries) then
    if  ($SC_$CPU_LC_ART[index].ActionResult <> LC_ACTION_PASS) or ;;
	($SC_$CPU_LC_ART[index].CurrentState <> LC_APSTATE_ACTIVE) or ;;
	($SC_$CPU_LC_ART[index].FailToPassCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].PassToFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].ConsecutiveFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].CumulativeFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].CumulativeRTSExecCount <> 0) then
      break
    endif
  else
    if  ($SC_$CPU_LC_ART[index].ActionResult <> LC_ACTION_STALE) or ;;
	($SC_$CPU_LC_ART[index].CurrentState <> LC_ACTION_NOT_USED) or ;;
	($SC_$CPU_LC_ART[index].FailToPassCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].PassToFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].ConsecutiveFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].CumulativeFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].CumulativeRTSExecCount <> 0) then
      break
    endif
  endif
enddo

if (index < LC_MAX_ACTIONPOINTS-1) then
  write "<!> Failed (3001;3001.1;3002;3004;3006) - ART show APs not evaluated properly."
  write "<!> Error occurred at AP = ", index
  write "  Action Results         = ", p@$SC_$CPU_LC_ART[index].ActionResult
  write "  Current State          = ", p@$SC_$CPU_LC_ART[index].CurrentState
  write "  Fail to Pass Count     = ", $SC_$CPU_LC_ART[index].FailToPassCount
  write "  Pass to Fail Count     = ", $SC_$CPU_LC_ART[index].PassToFailCount
  write "  Consecutive Fail Count = ", $SC_$CPU_LC_ART[index].ConsecutiveFailCount
  write "  Cum Fail Count         = ", $SC_$CPU_LC_ART[index].CumulativeFailCount
  write "  Cum RTS Count          = ", $SC_$CPU_LC_ART[index].CumulativeRTSExecCount
  ut_setrequirements LCX_3001, "F"
  ut_setrequirements LCX_30011, "F"
  ut_setrequirements LCX_3002, "F"
  ut_setrequirements LCX_3004, "F"
  ut_setrequirements LCX_3006, "F"
else
  write "<*> Passed (3001;3001.1;3002;3004;3006) -  ART shows APs evaluated properly."
  ut_setrequirements LCX_3001, "P"
  ut_setrequirements LCX_30011, "P"
  ut_setrequirements LCX_3002, "P"
  ut_setrequirements LCX_3004, "P"
  ut_setrequirements LCX_3006, "P"
endif

write ";*********************************************************************"
write ";  Step 4.0:  Test LC Active All AP passive, WP cause a mix of "
write ";             thresholds to be reached.  All AP pass"
write ";*********************************************************************"
write ";  Step 4.1:  Send a Set all AP to Passive Command"
write ";*********************************************************************"
ut_setupevents "$SC", "$CPU", {LCAppName}, LC_APSTATE_INF_EID, "INFO", 1
State = LC_APSTATE_PASSIVE
ut_sendcmd "$SC_$CPU_LC_SETAPSTATE APNumber=0xFFFF NewAPState=State"
CmdStatus = CMDSUCCESS

if ($SC_$CPU_find_event[1].num_found_messages = 1) THEN
  write "<*> Passed (1003;4006) - Event message ",$SC_$CPU_find_event[1].eventid, " received"
  ut_setrequirements LCX_1003, "P"
  ut_setrequirements LCX_4006, "P"
else
  write "<!> Failed (1003;4006) - Event message ",$SC_$CPU_evs_eventid," received. Expected Event message ",LC_APSTATE_INF_EID, "."
  ut_setrequirements LCX_1003, "F"
  ut_setrequirements LCX_4006, "F"
endif

s get_tbl_to_cvt(ramDir, ARTTblName, "A", "$cpu_dumpart", "$CPU", apindex)
wait 5

for index = 0 to ADTentries-1 do
  if ($SC_$CPU_LC_ART[index].CurrentState <> LC_APSTATE_PASSIVE) then
     CmdStatus = CMDFAIL
     break
  endif
enddo
for index = ADTentries to LC_MAX_ACTIONPOINTS-1 do
  if ($SC_$CPU_LC_ART[index].CurrentState <> LC_ACTION_NOT_USED) then
     CmdStatus = CMDFAIL
     break
  endif
enddo

if (ut_sc_status = UT_SC_Success) and (CmdStatus = CMDSUCCESS) then
  write "<*> Passed (1003;4006) - Set All APs to Passive command properly sent."
  ut_setrequirements LCX_1003, "P"
  ut_setrequirements LCX_4006, "P"
else
  write "<!> Failed (1003;4006) - Set All APs to Passive command not sent properly (", ut_sc_status, ")."
  write "<*> AP State = ", $SC_$CPU_LC_ART[index].CurrentState 
  ut_setrequirements LCX_1003, "F"
  ut_setrequirements LCX_4006, "F"
endif

wait 5

write ";*********************************************************************"
write ";  Step 4.2 Send packets for all WP defined in WDT, data run 3"
write ";*********************************************************************"

s $sc_$cpu_lcx_sendpackets("4.2",3)

write ";*********************************************************************"
write ";  Step 4.3 Send Sample Request for all 10 APs.  Nothing should"
write ";  happen since all AP are passive"
write ";*********************************************************************"

/$SC_$CPU_TST_LC_SENDSAMPLE StartAP=0 EndAP=9 UpdateAge=0
ut_tlmupdate $SC_$CPU_TST_LC_CMDPC


write ";*********************************************************************"
write ";  Step 4.4 Check housekeeping counters"
write ";*********************************************************************"
if ($SC_$CPU_LC_APSAMPLECNT = 20) AND ($SC_$CPU_LC_MONMSGCNT = 60) AND ;;
   ($SC_$CPU_LC_RTSCNT = 0) AND ($SC_$CPU_LC_PASSRTSCNT = 0) AND ;;
   ($SC_$CPU_LC_WPSINUSE = 30) AND ($SC_$CPU_LC_ACTIVEAPS = 0) AND ;;
   ($SC_$CPU_LC_CURLCSTATE=LC_STATE_ACTIVE) THEN
  CmdStatus = CMDSUCCESS
  if ($SC_$CPU_LC_WRRESULTS[1].WPByteEntry.AllStatus <> 0x05) then
    CmdStatus = CMDFAIL
    wpindex = 1
  endif
  if (CmdStatus = CMDSUCCESS) then
    if ($SC_$CPU_LC_WRRESULTS[2].WPByteEntry.AllStatus <> 0x44) then
      CmdStatus = CMDFAIL
      wpindex = 2
    endif
  endif
  if (CmdStatus = CMDSUCCESS) then
    if ($SC_$CPU_LC_WRRESULTS[3].WPByteEntry.AllStatus <> 0x05) then
      CmdStatus = CMDFAIL
      wpindex = 3
    endif
  endif

  if (CmdStatus = CMDSUCCESS) then
    for wpindex = 4 to WPACKED do
      if (wpindex <=7) then
        if ($SC_$CPU_LC_WRRESULTS[wpindex].WPByteEntry.AllStatus <> 0) then
          break
        endif
      elseif  (wpindex = 8) then
        if ($SC_$CPU_LC_WRRESULTS[wpindex].WPByteEntry.AllStatus <> 0xf0) then
          break
        endif
      else
        if ($SC_$CPU_LC_WRRESULTS[wpindex].WPByteEntry.AllStatus <> 0xff) then
          break
        endif
      endif 
     enddo
  endif

  ;; for the 10 APs that are being used, should be 136 (x88) since they are passive and pass
  ;; rest should be 51 (0x33) since they are not used and not measured
  for apindex = 1 to APACKED do
    if (apindex <= 5) then
      if ($SC_$CPU_LC_ARRESULTS[apindex].APByteEntry.AllStatus <> 136) then
        break                                   
      endif
    else
      if ($SC_$CPU_LC_ARRESULTS[apindex].APByteEntry.AllStatus <> 51) then
        break                                   
      endif
    endif
  enddo
 
  if (wpindex < WPACKED) OR (apindex < APACKED) then
    write "<!> Failed (8000) - Housekeeping telemetry NOT correct after processing WPs."
    write "  CMDPC             = ", $SC_$CPU_LC_CMDPC 
    write "  CMDEC             = ", $SC_$CPU_LC_CMDEC 
    write "  PASSRTSCNT        = ", $SC_$CPU_LC_PASSRTSCNT
    write "  CURLCSTATE        = ", p@$SC_$CPU_LC_CURLCSTATE
    write "  APSAMPLECNT       = ", $SC_$CPU_LC_APSAMPLECNT 
    write "  MONMSGCNT         = ", $SC_$CPU_LC_MONMSGCNT
    write "  RTSCNT            = ", $SC_$CPU_LC_RTSCNT 
    write "  Passive RTSCNT    = ", $SC_$CPU_LC_PASSRTSCNT 
    write "  WP in use         = ", $SC_$CPU_LC_WPSINUSE
    write "  Active APs        = ", $SC_$CPU_LC_ACTIVEAPS
    if (wpindex < WPACKED) then
      write "  WP Packed index   = ", wpindex
      write "  WP Packed Results = ", %hex($SC_$CPU_LC_WRRESULTS[wpindex].WPByteEntry.AllStatus,2)
    endif
    if (apindex < APACKED) then
      write "  AP Packed index   = ", apindex
      write "  AP Packed Results = ", %hex($SC_$CPU_LC_ARRESULTS[apindex].APByteEntry.AllStatus,2)
    endif
    ut_setrequirements LCX_8000, "F"
  else
    write "<*> Passed (8000) - Housekeeping telemetry updated properly."
    ut_setrequirements LCX_8000, "P"
  endif  
else
  write "<!> Failed (8000) - Housekeeping telemetry NOT correct after processing WPs."
  write "  CMDPC          = ", $SC_$CPU_LC_CMDPC 
  write "  CMDEC          = ", $SC_$CPU_LC_CMDEC 
  write "  PASSRTSCNT     = ", $SC_$CPU_LC_PASSRTSCNT
  write "  CURLCSTATE     = ", p@$SC_$CPU_LC_CURLCSTATE
  write "  APSAMPLECNT    = ", $SC_$CPU_LC_APSAMPLECNT 
  write "  MONMSGCNT      = ", $SC_$CPU_LC_MONMSGCNT
  write "  RTSCNT         = ", $SC_$CPU_LC_RTSCNT 
  write "  Passive RTSCNT = ", $SC_$CPU_LC_PASSRTSCNT 
  write "  WP in use      = ", $SC_$CPU_LC_WPSINUSE
  write "  Active APs     = ", $SC_$CPU_LC_ACTIVEAPS
  write "  Failed due to housekeeping counters so Packed Results were not checked"
  ut_setrequirements LCX_8000, "F"
endif

write ";*********************************************************************"
write ";  Step 4.5 Dump WRT and check counters, message monitored should be 4"
write ";  for all entries."
write ";*********************************************************************"
;;; CPU1 is the default
wpindex = "0FB9"

if ("$CPU" = "CPU2") then
   wpindex = "0FD7"
elseif ("$CPU" = "CPU3") then
   wpindex = "0FF7"
endif

s get_tbl_to_cvt(ramDir, WRTTblName, "A", "$cpu_dumpwrt", "$CPU", wpindex)
wait 5

for index = 0 to LC_MAX_WATCHPOINTS-1 do
  if (index = 0) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 3) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 3) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 3) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x19) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0) then
      break
    endif
  elseif (index = 1) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 3) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 3) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 3) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x45) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0) then
      break
    endif
  elseif (index = 2) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_FALSE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 3) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x1346) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0x1345) then
      break
    endif
  elseif (index = 3) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_FALSE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 3) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x0054) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0x0045) then
      break
    endif
  elseif (index = 4) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_FALSE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 3) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0xff60) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0xff54) then
      break
    endif
  elseif (index = 5) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 3) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x0133) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0x0130) then
      break
    endif 
  elseif (index = 6) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_FALSE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 3) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x0012456f) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0x0012546f) then
      break
    endif
  elseif (index = 7) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 3) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x23451200) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0x23451300) then
      break
    endif
  elseif (index = 8) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 3) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x00000542) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0x546) then
      break
    endif
  elseif (index= 9) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 3) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x00ab1543) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0xf0ab1543) then
      break
    endif
  elseif (index = 10) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_FALSE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 3) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0x3f9ddcc6) then
      break
    endif
  elseif (index > 10) and  (index < WDTentries) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_FALSE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 3) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0) then
;;	($SC_$CPU_LC_WRT[index].TtoFValue <> 0) then
      break
    endif
  else
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_STALE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0) then
      break
    endif
  endif
enddo

if (index < LC_MAX_WATCHPOINTS-1) then
  write "<!> Failed (2003;2003.2;2003.3;2004) - WRT show WPs not evaluated properly."
  write "<!> Error occurred at WP = ", index
  write " WatchResults            = ", p@$SC_$CPU_LC_WRT[index].WatchResults
  write " Evaluation Count        = ", $SC_$CPU_LC_WRT[index].EvaluationCount
  write " False to True Count     = ", $SC_$CPU_LC_WRT[index].FalsetoTrueCount
  write " Consecutive True        = ", $SC_$CPU_LC_WRT[index].ConsectiveTrueCount
  write " Cum True Count          = ", $SC_$CPU_LC_WRT[index].CumulativeTrueCount
  write " F to T Value            = ", $SC_$CPU_LC_WRT[index].FtoTValue
  write " T to F Value            = ", $SC_$CPU_LC_WRT[index].TtoFValue
  ut_setrequirements LCX_2003, "F"
  ut_setrequirements LCX_20032, "F"
  ut_setrequirements LCX_20033, "F"
  ut_setrequirements LCX_2004, "F"
else
  write "<*> Passed (2003;2003.2;2003.2;2004) -  WRT shows WPs evaluated properly."
  ut_setrequirements LCX_2003, "P"
  ut_setrequirements LCX_20032, "P"
  ut_setrequirements LCX_20033, "P"
  ut_setrequirements LCX_2004, "P"
endif

write ";*********************************************************************"
write ";  Step 4.6 Dump ART and check counters, state is passive"
write ";*********************************************************************"
;;; CPU1 is the default
apindex = "0FB8"

if ("$CPU" = "CPU2") then
   apindex = "0FD6"
elseif ("$CPU" = "CPU3") then
   apindex = "0FF6"
endif

s get_tbl_to_cvt(ramDir, ARTTblName, "A", "$cpu_dumpart", "$CPU", apindex)
wait 5 

for index = 0 to LC_MAX_ACTIONPOINTS-1 do
  if (index < ADTentries) then
    if  ($SC_$CPU_LC_ART[index].ActionResult <> LC_ACTION_PASS) or ;;
	($SC_$CPU_LC_ART[index].CurrentState <> LC_APSTATE_PASSIVE) or ;;
	($SC_$CPU_LC_ART[index].FailToPassCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].PassToFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].ConsecutiveFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].CumulativeFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].CumulativeRTSExecCount <> 0) then
      break
    endif
  else
    if  ($SC_$CPU_LC_ART[index].ActionResult <> LC_ACTION_STALE) or ;;
	($SC_$CPU_LC_ART[index].CurrentState <> LC_ACTION_NOT_USED) or ;;
	($SC_$CPU_LC_ART[index].FailToPassCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].PassToFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].ConsecutiveFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].CumulativeFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].CumulativeRTSExecCount <> 0) then
      break
    endif
  endif
enddo

if (index < LC_MAX_ACTIONPOINTS-1) then
  write "<!> Failed (3001;3001.1;3002;3004;3006) - ART show APs not evaluated properly."
  write "<!> Error occurred at AP = ", index
  write "  Action Results         = ", p@$SC_$CPU_LC_ART[index].ActionResult
  write "  Current State          = ", p@$SC_$CPU_LC_ART[index].CurrentState
  write "  Fail to Pass Count     = ", $SC_$CPU_LC_ART[index].FailToPassCount
  write "  Pass to Fail Count     = ", $SC_$CPU_LC_ART[index].PassToFailCount
  write "  Consecutive Fail Count = ", $SC_$CPU_LC_ART[index].ConsecutiveFailCount
  write "  Cum Fail Count         = ", $SC_$CPU_LC_ART[index].CumulativeFailCount
  write "  Cum RTS Count          = ", $SC_$CPU_LC_ART[index].CumulativeRTSExecCount
  ut_setrequirements LCX_3001, "F"
  ut_setrequirements LCX_30011, "F"
  ut_setrequirements LCX_3002, "F"
  ut_setrequirements LCX_3004, "F"
  ut_setrequirements LCX_3006, "F"
else
  write "<*> Passed (3001;3001.1;3002;3004;3006) -  ART shows APs evaluated properly."
  ut_setrequirements LCX_3001, "P"
  ut_setrequirements LCX_30011, "P"
  ut_setrequirements LCX_3002, "P"
  ut_setrequirements LCX_3004, "P"
  ut_setrequirements LCX_3006, "P"
endif

write ";*********************************************************************"
write ";  Step 5.0:  Test LC Active, AP in mixed states, WP cause a mix of "
write ";             thresholds to be reached.  All AP pass"
write ";*********************************************************************"
write ";  Step 5.1:  Set AP to mix of States"
write ";*********************************************************************"
State = LC_APSTATE_ACTIVE
ut_sendcmd "$SC_$CPU_LC_SETAPSTATE APNumber=0 NewAPState=State"
ut_sendcmd "$SC_$CPU_LC_SETAPSTATE APNumber=4 NewAPState=State"
ut_sendcmd "$SC_$CPU_LC_SETAPSTATE APNumber=5 NewAPState=State"

State = LC_APSTATE_PASSIVE
ut_sendcmd "$SC_$CPU_LC_SETAPSTATE APNumber=1 NewAPState=State"
ut_sendcmd "$SC_$CPU_LC_SETAPSTATE APNumber=8 NewAPState=State"
ut_sendcmd "$SC_$CPU_LC_SETAPSTATE APNumber=9 NewAPState=State"

State = LC_APSTATE_DISABLED
ut_sendcmd "$SC_$CPU_LC_SETAPSTATE APNumber=2 NewAPState=State"
ut_sendcmd "$SC_$CPU_LC_SETAPSTATE APNumber=6 NewAPState=State"
ut_sendcmd "$SC_$CPU_LC_SETAPSTATE APNumber=7 NewAPState=State"

ut_sendcmd "$SC_$CPU_LC_SETAPSTATE APNumber=3 NewAPState=State"
/$SC_$CPU_LC_SETAPPERMOFF APNumber=3

write ";*********************************************************************"
write ";  Step 5.2 Send packets for all WP defined in WDT, data run 4"
write ";*********************************************************************"

s $sc_$cpu_lcx_sendpackets("5.2",4)

write ";*********************************************************************"
write ";  Step 5.3 Send Sample Request for all 10 APs.  Nothing should"
write ";  happen since all AP pass"
write ";*********************************************************************"

/$SC_$CPU_TST_LC_SENDSAMPLE StartAP=0 EndAP=9 UpdateAge=0
ut_tlmupdate $SC_$CPU_TST_LC_CMDPC

write ";*********************************************************************"
write ";  Step 5.4 Check housekeeping counters"
write ";*********************************************************************"

if ($SC_$CPU_LC_APSAMPLECNT = 26) AND ($SC_$CPU_LC_MONMSGCNT = 80) AND ;;
   ($SC_$CPU_LC_RTSCNT = 0) AND ($SC_$CPU_LC_PASSRTSCNT = 0) AND ;;
   ($SC_$CPU_LC_WPSINUSE = 30) AND ($SC_$CPU_LC_ACTIVEAPS = 3) AND ;;
   ($SC_$CPU_LC_CURLCSTATE=LC_STATE_ACTIVE) THEN
  CmdStatus = CMDSUCCESS
  if ($SC_$CPU_LC_WRRESULTS[1].WPByteEntry.AllStatus <> 0x01) then
    CmdStatus = CMDFAIL
    wpindex = 1
  endif
  if (CmdStatus = CMDSUCCESS) then
    if ($SC_$CPU_LC_WRRESULTS[2].WPByteEntry.AllStatus <> 0x11) then
      CmdStatus = CMDFAIL
      wpindex = 2
    endif
  endif
  if (CmdStatus = CMDSUCCESS) then
    if ($SC_$CPU_LC_WRRESULTS[3].WPByteEntry.AllStatus <> 0x15) then
      CmdStatus = CMDFAIL
      wpindex = 3
    endif
  endif

  if (CmdStatus = CMDSUCCESS) then
    for wpindex = 4 to WPACKED do
      if (wpindex <=7) then
        if ($SC_$CPU_LC_WRRESULTS[wpindex].WPByteEntry.AllStatus <> 0) then
          break
        endif
      elseif  (wpindex = 8) then
        if ($SC_$CPU_LC_WRRESULTS[wpindex].WPByteEntry.AllStatus <> 0xf0) then
          break
        endif
      else
        if ($SC_$CPU_LC_WRRESULTS[wpindex].WPByteEntry.AllStatus <> 0xff) then
          break
        endif
      endif 
    enddo
  endif

  CmdStatus = CMDSUCCESS
  apindex = 1
  if ($SC_$CPU_LC_ARRESULTS[apindex].APByteEntry.AllStatus <> 0x84) then
    CmdStatus = CMDFAIL                                  
  endif

  if (CMDStatus = CMDSUCCESS) then
    apindex = apindex + 1
    if ($SC_$CPU_LC_ARRESULTS[apindex].APByteEntry.AllStatus <> 0x0C) then
      CmdStatus = CMDFAIL                                  
    endif
  endif

  if (CMDStatus = CMDSUCCESS) then
    apindex = apindex + 1
    if ($SC_$CPU_LC_ARRESULTS[apindex].APByteEntry.AllStatus <> 0x44) then
      CmdStatus = CMDFAIL                                  
    endif
  endif

  if (CMDStatus = CMDSUCCESS) then
    apindex = apindex + 1
    if ($SC_$CPU_LC_ARRESULTS[apindex].APByteEntry.AllStatus <> 0xCC) then
      CmdStatus = CMDFAIL                                  
    endif
  endif

  if (CMDStatus = CMDSUCCESS) then
    apindex = apindex + 1
    if ($SC_$CPU_LC_ARRESULTS[apindex].APByteEntry.AllStatus <> 0x88) then
      CmdStatus = CMDFAIL                                  
    endif
  endif

  if (CmdStatus = CMDSUCCESS) then
    for apindex = 6 to APACKED do
      if ($SC_$CPU_LC_ARRESULTS[apindex].APByteEntry.AllStatus <> 0x33) then
        break                                   
      endif
    enddo
  endif
 
  if (wpindex < WPACKED) OR (apindex < APACKED) then
    write "<!> Failed (8000) - Housekeeping telemetry NOT correct after processing WPs."
    write "  CMDPC             = ", $SC_$CPU_LC_CMDPC 
    write "  CMDEC             = ", $SC_$CPU_LC_CMDEC 
    write "  PASSRTSCNT        = ", $SC_$CPU_LC_PASSRTSCNT
    write "  CURLCSTATE        = ", $SC_$CPU_LC_CURLCSTATE
    write "  APSAMPLECNT       = ", $SC_$CPU_LC_APSAMPLECNT 
    write "  MONMSGCNT         = ", $SC_$CPU_LC_MONMSGCNT
    write "  RTSCNT            = ", $SC_$CPU_LC_RTSCNT 
    write "  Passive RTSCNT    = ", $SC_$CPU_LC_PASSRTSCNT 
    write "  WP in use         = ", $SC_$CPU_LC_WPSINUSE
    write "  Active APs        = ", $SC_$CPU_LC_ACTIVEAPS
    if (wpindex < WPACKED) then
      write "  WP Packed index   = ", wpindex
      write "  WP Packed Results = ", $SC_$CPU_LC_WRRESULTS[wpindex].WPByteEntry.AllStatus
    endif
    if (apindex < APACKED) then
      write "  AP Packed index   =", apindex
      write "  AP Packed Results =", $SC_$CPU_LC_ARRESULTS[apindex].APByteEntry.AllStatus
    endif
    ut_setrequirements LCX_8000, "F"
  else
    write "<*> Passed (8000) - Housekeeping telemetry updated properly."
    ut_setrequirements LCX_8000, "P"
  endif  
else
  write "<!> Failed (8000) - Housekeeping telemetry NOT correct after processing WPs."
  write "  CMDPC          = ", $SC_$CPU_LC_CMDPC 
  write "  CMDEC          = ", $SC_$CPU_LC_CMDEC 
  write "  PASSRTSCNT     = ", $SC_$CPU_LC_PASSRTSCNT
  write "  CURLCSTATE     = ", $SC_$CPU_LC_CURLCSTATE
  write "  APSAMPLECNT    = ", $SC_$CPU_LC_APSAMPLECNT 
  write "  MONMSGCNT      = ", $SC_$CPU_LC_MONMSGCNT
  write "  RTSCNT         = ", $SC_$CPU_LC_RTSCNT 
  write "  Passive RTSCNT = ", $SC_$CPU_LC_PASSRTSCNT 
  write "  WP in use      = ", $SC_$CPU_LC_WPSINUSE
  write "  Active APs     = ", $SC_$CPU_LC_ACTIVEAPS
  write "  Failed due to housekeeping counters so Packed Results were not checked"
  ut_setrequirements LCX_8000, "F"
endif


write ";*********************************************************************"
write ";  Step 5.5 Dump WRT and check counters, message monitored should be 5"
write ";  for all entries."
write ";*********************************************************************"
;;; CPU1 is the default
wpindex = "0FB9"

if ("$CPU" = "CPU2") then
   wpindex = "0FD7"
elseif ("$CPU" = "CPU3") then
   wpindex = "0FF7"
endif
s get_tbl_to_cvt(ramDir, WRTTblName, "A", "$cpu_dumpwrt", "$CPU", wpindex)
wait 5

for index = 0 to LC_MAX_WATCHPOINTS-1 do
  if (index = 0) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 4) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 4) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 4) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x19) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0) then
      break
    endif
  elseif (index = 1) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_FALSE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 4) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 3) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x45) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0x50) then
      break
    endif
  elseif (index = 2) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_FALSE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 4) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x1346) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0x1345) then
      break
    endif
  elseif (index = 3) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_FALSE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 4) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x0054) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0x0045) then
      break
    endif
  elseif (index = 4) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 4) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0xff60) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0xff54) then
      break
    endif
  elseif (index = 5) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_FALSE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 4) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x0133) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0x0130) then
      break
    endif 
  elseif (index = 6) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 4) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x0012456f) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0x0012546f) then
      break
    endif
  elseif (index = 7) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_FALSE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 4) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x23451200) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0x23451300) then
      break
    endif
  elseif (index = 8) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 4) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 3) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 3) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x00000542) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0x546) then
      break
    endif
  elseif (index = 9) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 4) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 2) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0x00ab1543) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0xf0ab1543) then
      break
    endif
  elseif (index = 10) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_TRUE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 4) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 1) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> $SC_$CPU_LC_WDT[index].ComparisonValue.UnSigned32) or ;;
	($SC_$CPU_LC_WRT[index].TtoFValue <> 0x3f9ddcc6) then
      break
    endif
  elseif (index > 10) and  (index < WDTentries) then
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_FALSE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 4) or ;;
	($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0) then
;;	($SC_$CPU_LC_WRT[index].TtoFValue <> 0) then
      break
    endif
  else
    if  ($SC_$CPU_LC_WRT[index].WatchResults <> LC_WATCH_STALE) or ;;
	($SC_$CPU_LC_WRT[index].EvaluationCount <> 0) or ;;
        ($SC_$CPU_LC_WRT[index].FalsetoTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].ConsectiveTrueCount <> 0) or ;;
        ($SC_$CPU_LC_WRT[index].CumulativeTrueCount <> 0) or ;;
	($SC_$CPU_LC_WRT[index].FtoTValue <> 0) or ;;
        ($SC_$CPU_LC_WRT[index].TtoFValue <> 0) then
      break
    endif
  endif
enddo

if (index < LC_MAX_WATCHPOINTS-1) then
  write "<!> Failed (2003;2003.2;2003.3;2004) - WRT show WPs not evaluated properly."
  write "<!> Error occurred at WP = ", index
  write " WatchResults            = ", p@$SC_$CPU_LC_WRT[index].WatchResults
  write " Evaluation Count        = ", $SC_$CPU_LC_WRT[index].EvaluationCount
  write " False to True Count     = ", $SC_$CPU_LC_WRT[index].FalsetoTrueCount
  write " Consecutive True        = ", $SC_$CPU_LC_WRT[index].ConsectiveTrueCount
  write " Cum True Count          = ", $SC_$CPU_LC_WRT[index].CumulativeTrueCount
  write " F to T Value            = ", $SC_$CPU_LC_WRT[index].FtoTValue
  write " T to F Value            = ", $SC_$CPU_LC_WRT[index].TtoFValue
  ut_setrequirements LCX_2003, "F"
  ut_setrequirements LCX_20032, "F"
  ut_setrequirements LCX_20033, "F"
  ut_setrequirements LCX_2004, "F"
else
  write "<*> Passed (2003;2003.2;2003.3;2004) -  WRT shows WPs evaluated properly."
  ut_setrequirements LCX_2003, "P"
  ut_setrequirements LCX_20032, "P"
  ut_setrequirements LCX_20033, "P"
  ut_setrequirements LCX_2004, "P"
endif

write ";*********************************************************************"
write ";  Step 5.6 Dump ART and check counters, states are mixed"
write ";*********************************************************************"
;;; CPU1 is the default
apindex = "0FB8"

if ("$CPU" = "CPU2") then
   apindex = "0FD6"
elseif ("$CPU" = "CPU3") then
   apindex = "0FF6"
endif

s get_tbl_to_cvt(ramDir, ARTTblName, "A", "$cpu_dumpart", "$CPU", apindex)
wait 5 

;checking that States did not change
CmdStatus = CMDSUCCESS
index = 0
if ($SC_$CPU_LC_ART[index].ActionResult <> LC_ACTION_PASS) or ;;
   ($SC_$CPU_LC_ART[index].CurrentState <> LC_APSTATE_ACTIVE) or ;;
   ($SC_$CPU_LC_ART[index].FailToPassCount <> 0) or ;;
   ($SC_$CPU_LC_ART[index].PassToFailCount <> 0) or ;;
   ($SC_$CPU_LC_ART[index].ConsecutiveFailCount <> 0) or ;;
   ($SC_$CPU_LC_ART[index].CumulativeFailCount <> 0) or ;;
   ($SC_$CPU_LC_ART[index].CumulativeRTSExecCount <> 0) then
  CmdStatus = CMDFAIL
endif

if (CmdStatus = CMDSUCCESS) then
  index = index + 1
  if ($SC_$CPU_LC_ART[index].ActionResult <> LC_ACTION_PASS) or ;;
     ($SC_$CPU_LC_ART[index].CurrentState <> LC_APSTATE_PASSIVE) or ;;
     ($SC_$CPU_LC_ART[index].FailToPassCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].PassToFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].ConsecutiveFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].CumulativeFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].CumulativeRTSExecCount <> 0) then
    CmdStatus = CMDFAIL
  endif
endif

if (CmdStatus = CMDSUCCESS) then
  index = index + 1
  if ($SC_$CPU_LC_ART[index].ActionResult <> LC_ACTION_PASS) or ;;
     ($SC_$CPU_LC_ART[index].CurrentState <> LC_APSTATE_DISABLED) or ;;
     ($SC_$CPU_LC_ART[index].FailToPassCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].PassToFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].ConsecutiveFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].CumulativeFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].CumulativeRTSExecCount <> 0) then
    CmdStatus = CMDFAIL
  endif
endif

if (CmdStatus = CMDSUCCESS) then
  index = index + 1
  if ($SC_$CPU_LC_ART[index].ActionResult <> LC_ACTION_PASS) or ;;
     ($SC_$CPU_LC_ART[index].CurrentState <> LC_APSTATE_PERMOFF) or ;;
     ($SC_$CPU_LC_ART[index].FailToPassCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].PassToFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].ConsecutiveFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].CumulativeFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].CumulativeRTSExecCount <> 0) then
    CmdStatus = CMDFAIL
  endif
endif

if (CmdStatus = CMDSUCCESS) then
  index = index + 1
  if ($SC_$CPU_LC_ART[index].ActionResult <> LC_ACTION_PASS) or ;;
     ($SC_$CPU_LC_ART[index].CurrentState <> LC_APSTATE_ACTIVE) or ;;
     ($SC_$CPU_LC_ART[index].FailToPassCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].PassToFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].ConsecutiveFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].CumulativeFailCount <> 0) or ;; 
     ($SC_$CPU_LC_ART[index].CumulativeRTSExecCount <> 0) then
    CmdStatus = CMDFAIL
  endif
endif

if (CmdStatus = CMDSUCCESS) then
  index = index + 1
  if ($SC_$CPU_LC_ART[index].ActionResult <> LC_ACTION_PASS) or ;;
     ($SC_$CPU_LC_ART[index].CurrentState <> LC_APSTATE_ACTIVE) or ;;
     ($SC_$CPU_LC_ART[index].FailToPassCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].PassToFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].ConsecutiveFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].CumulativeFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].CumulativeRTSExecCount <> 0) then
    CmdStatus = CMDFAIL
  endif
endif

if (CmdStatus = CMDSUCCESS) then
  index = index + 1
  if ($SC_$CPU_LC_ART[index].ActionResult <> LC_ACTION_PASS) or ;;
     ($SC_$CPU_LC_ART[index].CurrentState <> LC_APSTATE_DISABLED) or ;;
     ($SC_$CPU_LC_ART[index].FailToPassCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].PassToFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].ConsecutiveFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].CumulativeFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].CumulativeRTSExecCount <> 0) then
    CmdStatus = CMDFAIL
  endif
endif

if (CmdStatus = CMDSUCCESS) then
  index = index + 1
  if ($SC_$CPU_LC_ART[index].ActionResult <> LC_ACTION_PASS) or ;;
     ($SC_$CPU_LC_ART[index].CurrentState <> LC_APSTATE_DISABLED) or ;;
     ($SC_$CPU_LC_ART[index].FailToPassCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].PassToFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].ConsecutiveFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].CumulativeFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].CumulativeRTSExecCount <> 0) then
    CmdStatus = CMDFAIL
  endif
endif

if (CmdStatus = CMDSUCCESS) then
  index = index + 1
  if ($SC_$CPU_LC_ART[index].ActionResult <> LC_ACTION_PASS) or ;;
     ($SC_$CPU_LC_ART[index].CurrentState <> LC_APSTATE_PASSIVE) or ;;
     ($SC_$CPU_LC_ART[index].FailToPassCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].PassToFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].ConsecutiveFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].CumulativeFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].CumulativeRTSExecCount <> 0) then
    CmdStatus = CMDFAIL
  endif
endif

if (CmdStatus = CMDSUCCESS) then
  index = index + 1
  if ($SC_$CPU_LC_ART[index].ActionResult <> LC_ACTION_PASS) or ;;
     ($SC_$CPU_LC_ART[index].CurrentState <> LC_APSTATE_PASSIVE) or ;;
     ($SC_$CPU_LC_ART[index].FailToPassCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].PassToFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].ConsecutiveFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].CumulativeFailCount <> 0) or ;;
     ($SC_$CPU_LC_ART[index].CumulativeRTSExecCount <> 0) then
    CmdStatus = CMDFAIL
  endif
endif

if (CmdStatus = CMDSUCCESS) then
  for index = 10 to LC_MAX_ACTIONPOINTS-1 do
    if  ($SC_$CPU_LC_ART[index].ActionResult <> LC_ACTION_STALE) or ;;
	($SC_$CPU_LC_ART[index].CurrentState <> LC_ACTION_NOT_USED) or ;;
	($SC_$CPU_LC_ART[index].FailToPassCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].PassToFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].ConsecutiveFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].CumulativeFailCount <> 0) or ;;
	($SC_$CPU_LC_ART[index].CumulativeRTSExecCount <> 0) then
      break
    endif
  enddo
endif

if (index < LC_MAX_ACTIONPOINTS-1) then
  write "<!> Failed (3001;3001.1;3002;3003;3004;3005;3006;4003;4005;4007;4009) - ART show APs not evaluated properly."
  write "<!> Error occurred at AP = ", index
  write "  Action Results         = ", p@$SC_$CPU_LC_ART[index].ActionResult
  write "  Current State          = ", p@$SC_$CPU_LC_ART[index].CurrentState
  write "  Fail to Pass Count     = ", $SC_$CPU_LC_ART[index].FailToPassCount
  write "  Pass to Fail Count     = ", $SC_$CPU_LC_ART[index].PassToFailCount
  write "  Consecutive Fail Count = ", $SC_$CPU_LC_ART[index].ConsecutiveFailCount
  write "  Cum Fail Count         = ", $SC_$CPU_LC_ART[index].CumulativeFailCount
  write "  Cum RTS Count          = ", $SC_$CPU_LC_ART[index].CumulativeRTSExecCount
  ut_setrequirements LCX_3001, "F"
  ut_setrequirements LCX_30011, "F"
  ut_setrequirements LCX_3002, "F"
  ut_setrequirements LCX_3003, "F"
  ut_setrequirements LCX_3004, "F"
  ut_setrequirements LCX_3005, "F"
  ut_setrequirements LCX_3006, "F"
  ut_setrequirements LCX_4003, "F"
  ut_setrequirements LCX_4005, "F"
  ut_setrequirements LCX_4007, "F"
  ut_setrequirements LCX_4009, "F"
else
  write "<*> Passed (3001;3001.1;3002;3003;3004;3005;3006;4003;4005;4007;4009) -  ART shows APs evaluated properly."
  ut_setrequirements LCX_3001, "P"
  ut_setrequirements LCX_30011, "P"
  ut_setrequirements LCX_3002, "P"
  ut_setrequirements LCX_3003, "P"
  ut_setrequirements LCX_3004, "P"
  ut_setrequirements LCX_3005, "P"
  ut_setrequirements LCX_3006, "P"
  ut_setrequirements LCX_4003, "P"
  ut_setrequirements LCX_4005, "P"
  ut_setrequirements LCX_4007, "P"
  ut_setrequirements LCX_4009, "P"
endif

write ";*********************************************************************"
write ";  Step 6.0:  Clean-up"
write ";*********************************************************************"

/$SC_$CPU_ES_POWERONRESET
wait 10

close_data_center
wait 75
                                                                                
cfe_startup $CPU
wait 5

write "**** Requirements Status Reporting"
                                                                                
write "--------------------------"
write "   Requirement(s) Report"
write "--------------------------"
                                                                                
FOR i = 0 to ut_req_array_size DO
  ut_pfindicate {cfe_requirements[i]} {ut_requirement[i]}
ENDDO
                                                                                
drop ut_requirement ; needed to clear global variables
drop ut_req_array_size ; needed to clear global variables

write ";*********************************************************************"
write ";  End procedure $SC_$CPU_lcx_noaction                                "
write ";*********************************************************************"
ENDPROC
