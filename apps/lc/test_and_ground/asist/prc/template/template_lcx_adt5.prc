PROC $sc_$cpu_lcx_adt5
;*******************************************************************************
;  Test Name:  lcx_adt5
;  Test Level: Build Verification
;  Test Type:  Functional
;
;  Test Description
;	The purpose of this procedure is to generate ActionPoint Definition
;	Table (ADT) 5 BVT. This ADT contains event counts for AP 5 & 6 that
;	are to be exceeded in the event filtering test procedure.
;       NOTE: the message ids used are borrowed from the other CFS applications
;	      (MM, FM, MD, and SCH). 
;
;  ADT5:  Used by Event Filter procedure.  
;         Contains 12 APs, uses all event types and RPN operators;  
;
;  Requirements Tested
;       None
;
;  Prerequisite Conditions
;	The cFE is up and running and ready to accept commands.	
;       The LC commands and TLM items exist in the GSE database. 
;	A display page exists for the LC Housekeeping telemetry packet
;       LC Test application loaded and running;
;
;  Assumptions and Constraints
;	None.
;
;  Change History
;
;	Date		   Name		Description
;      09/27/12         W. Moleski	Initial release for LCX
;
;  Arguments
;	None.
;
;  Procedures Called
;	Name			 Description
;       create_tbl_file_from_cvt Procedure that creates a load file from
;                                the specified arguments and cvt
;
;  Expected Test Results and Analysis
;
;**********************************************************************
local logging = %liv (log_procedure)
%liv (log_procedure) = FALSE

#include "ut_statusdefs.h"
#include "ut_cfe_info.h"
#include "cfe_platform_cfg.h"
#include "lc_platform_cfg.h"
#include "lc_msgdefs.h"
#include "lc_tbldefs.h"
#include "lc_events.h"

write ";*********************************************************************"
write ";  define local variables "
write ";*********************************************************************"

LOCAL entry
LOCAL i
LOCAL appid
LOCAL RTS1
LOCAL RTS2
LOCAL RTS3
LOCAL RTS4
LOCAL RTS5
LOCAL RTS6
LOCAL RTS7
LOCAL RTS8
LOCAL RTS9
LOCAL RTS10
local ADTTblName = LC_APP_NAME & ".LC_ADT"

;; Set up the default values to be CPU1
appid = 0xfb6
;; Use the CPU2 Message IDs
RTS1 = 0x99d
RTS2 = 0x99e
RTS3 = 0x99f
RTS4 = 0x9a0
RTS5 = 0x9a1
RTS6 = 0x9a2
RTS7 = 0x9a3
RTS8 = 0x9a4
RTS9 = 0x9a5
RTS10 = 0x9a6  

if ("$CPU" = "CPU2") then
   appid = 0xfd4
   ;; Use the CPU3 Message IDs
   RTS1 = 0xa9d
   RTS2 = 0xa9e
   RTS3 = 0xa9f
   RTS4 = 0xaa0
   RTS5 = 0xaa1
   RTS6 = 0xaa2
   RTS7 = 0xaa3
   RTS8 = 0xaa4
   RTS9 = 0xaa5
   RTS10 = 0xaa6
elseif ("$CPU" = "CPU3") then
   appid = 0xff4
   ;; Use the CPU1 Message IDs
   RTS1 = 0x89d
   RTS2 = 0x89e
   RTS3 = 0x89f
   RTS4 = 0x8a0
   RTS5 = 0x8a1
   RTS6 = 0x8a2
   RTS7 = 0x8a3
   RTS8 = 0x8a4
   RTS9 = 0x8a5
   RTS10 = 0x8a6
endif 

write ";*********************************************************************"
write ";  Step 1.0:  Define Action Point Definition Table 1. "
write ";*********************************************************************"

; Entry 1 (AP 0)
entry = 0
$SC_$CPU_LC_ADT[entry].DefaultState = LC_APSTATE_DISABLED
$SC_$CPU_LC_ADT[entry].RTSId = RTS1
$SC_$CPU_LC_ADT[entry].MaxPassiveEvents  = 1
$SC_$CPU_LC_ADT[entry].MaxPassFailEvents = 1
$SC_$CPU_LC_ADT[entry].MaxFailPassEvents = 1
$SC_$CPU_LC_ADT[entry].MaxFailsBefRTS    = 1
$SC_$CPU_LC_ADT[entry].RPNEquation[1]    = 12
$SC_$CPU_LC_ADT[entry].RPNEquation[2]    = 19
$SC_$CPU_LC_ADT[entry].RPNEquation[3]    = LC_RPN_AND
$SC_$CPU_LC_ADT[entry].RPNEquation[4]    = LC_RPN_EQUAL

for i = 5 to LC_MAX_RPN_EQU_SIZE do
  $SC_$CPU_LC_ADT[entry].RPNEquation[i] = 0
enddo

$SC_$CPU_LC_ADT[entry].EventType= 1
$SC_$CPU_LC_ADT[entry].EventId = LC_BASE_AP_EID + 1
$SC_$CPU_LC_ADT[entry].EventText = "AP 1 Fired RTS"

; Entry 2 (AP 1)
entry = entry + 1
$SC_$CPU_LC_ADT[entry].DefaultState = LC_APSTATE_DISABLED
$SC_$CPU_LC_ADT[entry].RTSId = RTS2
$SC_$CPU_LC_ADT[entry].MaxPassiveEvents  = 3
$SC_$CPU_LC_ADT[entry].MaxPassFailEvents = 3
$SC_$CPU_LC_ADT[entry].MaxFailPassEvents = 3
$SC_$CPU_LC_ADT[entry].MaxFailsBefRTS = 3 
$SC_$CPU_LC_ADT[entry].RPNEquation[1] = 1
$SC_$CPU_LC_ADT[entry].RPNEquation[2] = LC_RPN_NOT
$SC_$CPU_LC_ADT[entry].RPNEquation[3] = 21
$SC_$CPU_LC_ADT[entry].RPNEquation[4] = LC_RPN_OR
$SC_$CPU_LC_ADT[entry].RPNEquation[5] = LC_RPN_EQUAL

for i = 6 to LC_MAX_RPN_EQU_SIZE do
  $SC_$CPU_LC_ADT[entry].RPNEquation[i] = 0
enddo

$SC_$CPU_LC_ADT[entry].EventType= 2
$SC_$CPU_LC_ADT[entry].EventId = LC_BASE_AP_EID + 2
$SC_$CPU_LC_ADT[entry].EventText = "AP 2 Fired RTS"

; Entry 3 (AP 2)
entry = entry +1
$SC_$CPU_LC_ADT[entry].DefaultState = LC_APSTATE_DISABLED
$SC_$CPU_LC_ADT[entry].RTSId = RTS3
$SC_$CPU_LC_ADT[entry].MaxPassiveEvents  = 5
$SC_$CPU_LC_ADT[entry].MaxPassFailEvents = 5
$SC_$CPU_LC_ADT[entry].MaxFailPassEvents = 5
$SC_$CPU_LC_ADT[entry].MaxFailsBefRTS = 5
$SC_$CPU_LC_ADT[entry].RPNEquation[1] = 9
$SC_$CPU_LC_ADT[entry].RPNEquation[2] = 0
$SC_$CPU_LC_ADT[entry].RPNEquation[3] = LC_RPN_NOT
$SC_$CPU_LC_ADT[entry].RPNEquation[4] = LC_RPN_XOR
$SC_$CPU_LC_ADT[entry].RPNEquation[5] = 25
$SC_$CPU_LC_ADT[entry].RPNEquation[6] = LC_RPN_NOT
$SC_$CPU_LC_ADT[entry].RPNEquation[7] = LC_RPN_AND
$SC_$CPU_LC_ADT[entry].RPNEquation[8] = LC_RPN_EQUAL

for i = 9 to LC_MAX_RPN_EQU_SIZE do
  $SC_$CPU_LC_ADT[entry].RPNEquation[i] = 0
enddo

$SC_$CPU_LC_ADT[entry].EventType = 3
$SC_$CPU_LC_ADT[entry].EventId = LC_BASE_AP_EID + 3
$SC_$CPU_LC_ADT[entry].EventText = "AP 3 Fired RTS"

; Entry 4 (AP 3)
entry = entry + 1
$SC_$CPU_LC_ADT[entry].DefaultState = LC_APSTATE_DISABLED
$SC_$CPU_LC_ADT[entry].RTSId = RTS4
$SC_$CPU_LC_ADT[entry].MaxPassiveEvents  = 2
$SC_$CPU_LC_ADT[entry].MaxPassFailEvents = 2
$SC_$CPU_LC_ADT[entry].MaxFailPassEvents = 2
$SC_$CPU_LC_ADT[entry].MaxFailsBefRTS = 2
$SC_$CPU_LC_ADT[entry].RPNEquation[1] = 8
$SC_$CPU_LC_ADT[entry].RPNEquation[2] = LC_RPN_EQUAL

for i = 3 to LC_MAX_RPN_EQU_SIZE do
  $SC_$CPU_LC_ADT[entry].RPNEquation[i] = 0
enddo

$SC_$CPU_LC_ADT[entry].EventType= 4
$SC_$CPU_LC_ADT[entry].EventId = LC_BASE_AP_EID + 4
$SC_$CPU_LC_ADT[entry].EventText = "AP 4 Fired RTS"

; Entry 5 (AP 4)
entry = entry + 1
$SC_$CPU_LC_ADT[entry].DefaultState = LC_APSTATE_DISABLED
$SC_$CPU_LC_ADT[entry].RTSId = RTS5
$SC_$CPU_LC_ADT[entry].MaxPassiveEvents  = 4
$SC_$CPU_LC_ADT[entry].MaxPassFailEvents = 4
$SC_$CPU_LC_ADT[entry].MaxFailPassEvents = 4
$SC_$CPU_LC_ADT[entry].MaxFailsBefRTS = 4
$SC_$CPU_LC_ADT[entry].RPNEquation[1] = 4
$SC_$CPU_LC_ADT[entry].RPNEquation[2] = LC_RPN_NOT
$SC_$CPU_LC_ADT[entry].RPNEquation[3] = LC_RPN_EQUAL

for i = 4 to LC_MAX_RPN_EQU_SIZE do
  $SC_$CPU_LC_ADT[entry].RPNEquation[i] = 0
enddo

$SC_$CPU_LC_ADT[entry].EventType = 1
$SC_$CPU_LC_ADT[entry].EventId = LC_BASE_AP_EID + 5
$SC_$CPU_LC_ADT[entry].EventText = "AP 5 Fired RTS"

; Entry 6 (AP 5)
entry = entry + 1
$SC_$CPU_LC_ADT[entry].DefaultState = LC_APSTATE_DISABLED
$SC_$CPU_LC_ADT[entry].RTSId = RTS6
$SC_$CPU_LC_ADT[entry].MaxPassiveEvents  = 2
$SC_$CPU_LC_ADT[entry].MaxPassFailEvents = 2
$SC_$CPU_LC_ADT[entry].MaxFailPassEvents = 2
$SC_$CPU_LC_ADT[entry].MaxFailsBefRTS = 6
$SC_$CPU_LC_ADT[entry].RPNEquation[1] = 6
$SC_$CPU_LC_ADT[entry].RPNEquation[2] = 24
$SC_$CPU_LC_ADT[entry].RPNEquation[3] = LC_RPN_XOR
$SC_$CPU_LC_ADT[entry].RPNEquation[4] = 0
$SC_$CPU_LC_ADT[entry].RPNEquation[5] = LC_RPN_AND
$SC_$CPU_LC_ADT[entry].RPNEquation[6] = LC_RPN_EQUAL

for i = 7 to LC_MAX_RPN_EQU_SIZE do
  $SC_$CPU_LC_ADT[entry].RPNEquation[i] = 0
enddo

$SC_$CPU_LC_ADT[entry].EventType= 2
$SC_$CPU_LC_ADT[entry].EventId = LC_BASE_AP_EID + 6
$SC_$CPU_LC_ADT[entry].EventText = "AP 6 Fired RTS"

; Entry 7 (AP 6)
entry = entry + 1
$SC_$CPU_LC_ADT[entry].DefaultState = LC_APSTATE_DISABLED
$SC_$CPU_LC_ADT[entry].RTSId = RTS7
$SC_$CPU_LC_ADT[entry].MaxPassiveEvents  = 3
$SC_$CPU_LC_ADT[entry].MaxPassFailEvents = 3
$SC_$CPU_LC_ADT[entry].MaxFailPassEvents = 3
$SC_$CPU_LC_ADT[entry].MaxFailsBefRTS = 5
$SC_$CPU_LC_ADT[entry].RPNEquation[1] = 5 
$SC_$CPU_LC_ADT[entry].RPNEquation[2] = 18
$SC_$CPU_LC_ADT[entry].RPNEquation[3] = 0
$SC_$CPU_LC_ADT[entry].RPNEquation[4] = LC_RPN_OR
$SC_$CPU_LC_ADT[entry].RPNEquation[5] = LC_RPN_AND
$SC_$CPU_LC_ADT[entry].RPNEquation[6] = LC_RPN_EQUAL

for i = 7 to LC_MAX_RPN_EQU_SIZE do
  $SC_$CPU_LC_ADT[entry].RPNEquation[i] = 0
enddo

$SC_$CPU_LC_ADT[entry].EventType= 3
$SC_$CPU_LC_ADT[entry].EventId = LC_BASE_AP_EID + 7
$SC_$CPU_LC_ADT[entry].EventText = "AP 7 Fired RTS"

; Entry 8 (AP 7)
entry = entry + 1
$SC_$CPU_LC_ADT[entry].DefaultState = LC_APSTATE_DISABLED
$SC_$CPU_LC_ADT[entry].RTSId = RTS8
$SC_$CPU_LC_ADT[entry].MaxPassiveEvents  = 5
$SC_$CPU_LC_ADT[entry].MaxPassFailEvents = 5
$SC_$CPU_LC_ADT[entry].MaxFailPassEvents = 5
$SC_$CPU_LC_ADT[entry].MaxFailsBefRTS =  5
$SC_$CPU_LC_ADT[entry].RPNEquation[1] = 4
$SC_$CPU_LC_ADT[entry].RPNEquation[2] = 0
$SC_$CPU_LC_ADT[entry].RPNEquation[3] = LC_RPN_NOT
$SC_$CPU_LC_ADT[entry].RPNEquation[4] = LC_RPN_OR
$SC_$CPU_LC_ADT[entry].RPNEquation[5] = LC_RPN_EQUAL

for i = 6 to LC_MAX_RPN_EQU_SIZE do
  $SC_$CPU_LC_ADT[entry].RPNEquation[i] = 0
enddo

$SC_$CPU_LC_ADT[entry].EventType= 4
$SC_$CPU_LC_ADT[entry].EventId = LC_BASE_AP_EID + 8
$SC_$CPU_LC_ADT[entry].EventText = "AP 8 Fired RTS"

; Entry 9 (AP 8)
entry = entry + 1
$SC_$CPU_LC_ADT[entry].DefaultState = LC_APSTATE_DISABLED
$SC_$CPU_LC_ADT[entry].RTSId = RTS9
$SC_$CPU_LC_ADT[entry].MaxPassiveEvents  = 3
$SC_$CPU_LC_ADT[entry].MaxPassFailEvents = 3
$SC_$CPU_LC_ADT[entry].MaxFailPassEvents = 3
$SC_$CPU_LC_ADT[entry].MaxFailsBefRTS = 3 
$SC_$CPU_LC_ADT[entry].RPNEquation[1] = 3
$SC_$CPU_LC_ADT[entry].RPNEquation[2] = 0
$SC_$CPU_LC_ADT[entry].RPNEquation[3] = LC_RPN_XOR
$SC_$CPU_LC_ADT[entry].RPNEquation[4] = LC_RPN_NOT
$SC_$CPU_LC_ADT[entry].RPNEquation[5] = LC_RPN_EQUAL

for i = 6 to LC_MAX_RPN_EQU_SIZE do
  $SC_$CPU_LC_ADT[entry].RPNEquation[i] = 0
enddo

$SC_$CPU_LC_ADT[entry].EventType= 1
$SC_$CPU_LC_ADT[entry].EventId = LC_BASE_AP_EID + 9
$SC_$CPU_LC_ADT[entry].EventText = "AP 9 Fired RTS"

; Entry 10 (AP 9)
entry = entry + 1
$SC_$CPU_LC_ADT[entry].DefaultState = LC_APSTATE_DISABLED
$SC_$CPU_LC_ADT[entry].RTSId = RTS10
$SC_$CPU_LC_ADT[entry].MaxPassiveEvents  = 1
$SC_$CPU_LC_ADT[entry].MaxPassFailEvents = 1
$SC_$CPU_LC_ADT[entry].MaxFailPassEvents = 1
$SC_$CPU_LC_ADT[entry].MaxFailsBefRTS = 1
$SC_$CPU_LC_ADT[entry].RPNEquation[1] = 2
$SC_$CPU_LC_ADT[entry].RPNEquation[2] = LC_RPN_EQUAL

for i = 3 to LC_MAX_RPN_EQU_SIZE do
  $SC_$CPU_LC_ADT[entry].RPNEquation[i] = 0
enddo

$SC_$CPU_LC_ADT[entry].EventType = 2
$SC_$CPU_LC_ADT[entry].EventId = LC_BASE_AP_EID + 10
$SC_$CPU_LC_ADT[entry].EventText = "AP 10 Fired RTS"

; Entry 11 (AP 10)
entry = entry + 1
$SC_$CPU_LC_ADT[entry].DefaultState = LC_APSTATE_DISABLED
$SC_$CPU_LC_ADT[entry].RTSId = RTS9
$SC_$CPU_LC_ADT[entry].MaxPassiveEvents  = 3
$SC_$CPU_LC_ADT[entry].MaxPassFailEvents = 3
$SC_$CPU_LC_ADT[entry].MaxFailPassEvents = 3
$SC_$CPU_LC_ADT[entry].MaxFailsBefRTS = 3 
$SC_$CPU_LC_ADT[entry].RPNEquation[1] = 1
$SC_$CPU_LC_ADT[entry].RPNEquation[2] = 19
$SC_$CPU_LC_ADT[entry].RPNEquation[3] = LC_RPN_OR
$SC_$CPU_LC_ADT[entry].RPNEquation[4] = LC_RPN_EQUAL

for i = 5 to LC_MAX_RPN_EQU_SIZE do
  $SC_$CPU_LC_ADT[entry].RPNEquation[i] = 0
enddo

$SC_$CPU_LC_ADT[entry].EventType= 3
$SC_$CPU_LC_ADT[entry].EventId = LC_BASE_AP_EID + 11
$SC_$CPU_LC_ADT[entry].EventText = "AP 11 Fired RTS"

; Entry 12 (AP 11)
entry = entry + 1
$SC_$CPU_LC_ADT[entry].DefaultState = LC_APSTATE_DISABLED
$SC_$CPU_LC_ADT[entry].RTSId = RTS10
$SC_$CPU_LC_ADT[entry].MaxPassiveEvents  = 1
$SC_$CPU_LC_ADT[entry].MaxPassFailEvents = 1
$SC_$CPU_LC_ADT[entry].MaxFailPassEvents = 1
$SC_$CPU_LC_ADT[entry].MaxFailsBefRTS = 2
$SC_$CPU_LC_ADT[entry].RPNEquation[1] = 11
$SC_$CPU_LC_ADT[entry].RPNEquation[2] = LC_RPN_NOT
$SC_$CPU_LC_ADT[entry].RPNEquation[3] = LC_RPN_EQUAL

for i = 4 to LC_MAX_RPN_EQU_SIZE do
  $SC_$CPU_LC_ADT[entry].RPNEquation[i] = 0
enddo

$SC_$CPU_LC_ADT[entry].EventType = 2
$SC_$CPU_LC_ADT[entry].EventId = LC_BASE_AP_EID + 12
$SC_$CPU_LC_ADT[entry].EventText = "AP 12 Fired RTS"

;zero out the rest of the table
for entry=12 to LC_MAX_ACTIONPOINTS-1 do
  $SC_$CPU_LC_ADT[entry].DefaultState = LC_ACTION_NOT_USED
  $SC_$CPU_LC_ADT[entry].RTSId = 0
  $SC_$CPU_LC_ADT[entry].MaxPassiveEvents  = 0
  $SC_$CPU_LC_ADT[entry].MaxPassFailEvents = 0
  $SC_$CPU_LC_ADT[entry].MaxFailPassEvents = 0
  $SC_$CPU_LC_ADT[entry].MaxFailsBefRTS = 0
  for i = 1 to LC_MAX_RPN_EQU_SIZE do
    $SC_$CPU_LC_ADT[entry].RPNEquation[i] = 0
  enddo
  $SC_$CPU_LC_ADT[entry].EventType= 0
  $SC_$CPU_LC_ADT[entry].EventId = LC_BASE_AP_EID
  $SC_$CPU_LC_ADT[entry].EventText = " "
enddo 
;; Restore procedure logging
%liv (log_procedure) = logging

local maxAPIndex = LC_MAX_ACTIONPOINTS - 1
local startMnemonic = "$SC_$CPU_LC_ADT[0]"
local endMnemonic = "$SC_$CPU_LC_ADT[" & maxAPIndex & "]"

s create_tbl_file_from_cvt("$CPU",appid,"ADTTable1","lc_def_adt5.tbl",ADTTblName,startMnemonic,endMnemonic)

write ";*********************************************************************"
write ";  End procedure $SC_$CPU_lcx_adt5                                     "
write ";*********************************************************************"
ENDPROC
