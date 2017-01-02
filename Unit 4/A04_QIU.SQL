spool A04_QIU.LST


set echo on
set feedback 1
set pagesize 999
set trimspool on
set linesize 200
set tab off
clear columns

/* Jeffrey Qiu */

/*  TASK 00 */
select user, sysdate 
from dual;

/*  TASK 01 */
select CL_ID as "Client Id", AN_ID as "Animal Id", AN_TYPE as "Animal Type", AN_NAME as "Animal Name"
from VT_ANIMALS
where extract( year from AN_DOB ) <= 2009
;

/*  TASK 02  */
select
	EXH.EX_ID as "Exam Id"
	, EXH.EX_DATE as "Exam Date"
	, EXD.SRV_ID as "Service Id"
	, EXD.EX_FEE as "Fee Charged"  
--	, ANI.AN_TYPE as "Animal Type"
from 
	VT_EXAM_HEADERS EXH
	join VT_EXAM_DETAILS EXD on (EXH.EX_ID = EXD.EX_ID)
	join VT_ANIMALS ANI on (EXH.AN_ID = ANI.AN_ID)
where
	ANI.AN_TYPE in ('hamster', 'capybara', 'porcupine', 'dormouse')
order by
	EXD.EX_ID
	, EXD.SRV_ID
;

/*  TASK 03 */
select
	STF.STF_ID as "STF.ID"
	, STF.STF_NAME_FIRST || STF.STF_NAME_LAST as "STAFF"
	, EXH.EX_DATE as "EX_DATE"
from 
	VT_EXAM_HEADERS EXH
	join VT_STAFF STF on (EXH.STF_ID = STF.STF_ID)
	join VT_ANIMALS ANI on (EXH.AN_ID = ANI.AN_ID)
where
	ANI.AN_TYPE not in ('snake', 'chelonian', 'crocodilian', 'lizard', 'bird')
order by
	EXH.EX_DATE
;

/*  TASK 04 */
/* I assume that the display order is by date rather than date & time. Thus, the trunc() function is used. */
select
	ANI.CL_ID as "Client Id"
	, EXH.EX_ID as "Exam Id"
	, EXH.EX_DATE as "Exam Date"
	, EXD.SRV_ID as "Service Id"
	, EXD.EX_FEE as "Exam Fee"  
from 
	VT_EXAM_HEADERS EXH
	join VT_EXAM_DETAILS EXD on (EXH.EX_ID = EXD.EX_ID)
	join VT_ANIMALS ANI on (EXH.AN_ID = ANI.AN_ID)
where
	EXD.EX_FEE not between 50 and 100
order by
	trunc(EXH.EX_DATE) asc
	, EXD.SRV_ID asc
;

/*  TASK 05 */
select * 
from 
	VT_SERVICES
where
	SRV_DESC like '%Feline%' and SRV_DESC not like '%Dental%'
order by
	SRV_TYPE
	, SRV_ID
;

/*  TASK 06 */
select distinct
	CLI.CL_ID as "Client Id"
	, CLI.CL_NAME_LAST as "Last Name"
from 
	VT_ANIMALS ANI
	join VT_CLIENTS CLI on (ANI.CL_ID = CLI.CL_ID)
where
	ANI.AN_TYPE = 'dog'
order by
	CLI.CL_ID
;

/*  TASK 07 */
/* I assume that any client who has at least one non-dog animal meets the criteria. */ 
select distinct
	CLI.CL_ID as "Client Id"
	, CLI.CL_NAME_LAST as "Last Name"
from 
	VT_ANIMALS ANI
	join VT_CLIENTS CLI on (ANI.CL_ID = CLI.CL_ID)
where
	ANI.AN_TYPE != 'dog'
order by
	CLI.CL_ID
;

/*  TASK 08 */
select distinct
	CLI.CL_ID as "Client Id"
	, CLI.CL_NAME_LAST as "Last Name"
from 
	VT_ANIMALS ANI
	join VT_CLIENTS CLI on (ANI.CL_ID = CLI.CL_ID)
where
	ANI.AN_TYPE in ('hamster', 'capybara', 'porcupine', 'dormouse')
order by
	CLI.CL_ID
;


/*  TASK 09 */
/* I assume that any client who has at least one non-rodent animal meets the criteria. */ 
select distinct
	CLI.CL_ID as "Client Id"
	, CLI.CL_NAME_LAST as "Last Name"
, ANI.AN_TYPE
from 
	VT_ANIMALS ANI
	join VT_CLIENTS CLI on (ANI.CL_ID = CLI.CL_ID)
where
	ANI.AN_TYPE not in ('hamster', 'capybara', 'porcupine', 'dormouse')
order by
	CLI.CL_ID
;


/*  THE END */



spool off