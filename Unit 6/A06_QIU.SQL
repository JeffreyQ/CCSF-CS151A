spool A06_QIU.LST


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
select
	CL_ID
	, CL_NAME_LAST
from 
	VT_CLIENTS CLI
	left outer join VT_ANIMALS ANI using (CL_ID)
where
	AN_ID is null
;

/*  TASK 02  */
select 
	CL_ID
	, CL_NAME_LAST
from 
	VT_CLIENTS CLI
where
	not exists 
	(
		select 
			1
		from	
			VT_ANIMALS ANI
		where
			ANI.CL_ID = CLI.CL_ID  
	)
;

/*  TASK 03 */
select 
	CL_ID
	, CL_NAME_LAST
from 
	VT_CLIENTS CLI
where
	CLI.CL_ID not in 
	(
		select 
			ANI.CL_ID
		from	
			VT_ANIMALS ANI
		where
			ANI.CL_ID = CLI.CL_ID
			and ANI.AN_TYPE in ('snake', 'chelonian', 'crocodilian', 'lizard')
	)
;

/*
--	This query is used to verify whether the previous query includes the "no animal" clients.

(
select 
	CL_ID
	, CL_NAME_LAST
from 
	VT_CLIENTS CLI
where
	not exists 
	(
		select 
			1
		from	
			VT_ANIMALS ANI
		where
			ANI.CL_ID = CLI.CL_ID  
	)
)
UNION
( 
select 
	CL_ID
	, CL_NAME_LAST
from 
	VT_CLIENTS CLI
where
	CLI.CL_ID not in 
	(
		select 
			ANI.CL_ID
		from	
			VT_ANIMALS ANI
		where
			ANI.CL_ID = CLI.CL_ID
			and ANI.AN_TYPE in ('snake', 'chelonian', 'crocodilian', 'lizard')
	)
)
;

*/

/*  TASK 04 */
select
	CL_ID
	, CL_NAME_LAST
	, decode(AN_TYPE, NULL, 'no animals', nvl(AN_NAME, 'no name')) as AN_NAME
	, decode(AN_TYPE, NULL, 'no animals', AN_TYPE) as AN_TYPE
from 
	VT_CLIENTS CLI
	left outer join VT_ANIMALS ANI using (CL_ID)
;

/*  TASK 05 */
select
	CL_ID
	, CL_NAME_LAST
	, AN_ID
	, AN_NAME
	, AN_TYPE
from
	VT_CLIENTS CLI
	join VT_ANIMALS ANI using (CL_ID)
	left outer join VT_EXAM_HEADERS EXH using (AN_ID)
where
	EXH.EX_ID is null
order by
	CL_ID, AN_ID
;

/*  TASK 06 */
select
	CL_ID
	, CL_NAME_LAST
	, AN_ID
	, AN_NAME
	, AN_TYPE
from
	VT_CLIENTS CLI
	left outer join VT_ANIMALS ANI using (CL_ID)
	left outer join VT_EXAM_HEADERS EXH using (AN_ID)
where
	EXH.EX_ID is null
order by
	CL_ID, AN_ID
;

/*  TASK 07 */
select
	CLI.CL_ID
	, CLI.CL_NAME_LAST
	, ANI.AN_ID
	, ANI.AN_NAME
	, ANI.AN_DOB
from
	VT_CLIENTS CLI
	join VT_ANIMALS ANI on (CLI.CL_ID = ANI.CL_ID)
where
	CLI.CL_STATE in ('NY', 'MA')
	and ANI.AN_TYPE not in ('dog', 'cat', 'bird')
;

/*  TASK 08 */
select distinct
	ANI.AN_ID
	, ANI.AN_NAME
from
	VT_ANIMALS ANI 
	join VT_EXAM_HEADERS EXH on (ANI.AN_ID = EXH.AN_ID)
where
	to_char(EXH.EX_DATE, 'YYYY') = to_char(sysdate, 'YYYY')
;

/*  TASK 09 */
select distinct
	SER.SRV_ID
	, SER.SRV_LIST_PRICE
	, SER.SRV_DESC
	, SER.SRV_TYPE
from
	VT_SERVICES SER
	left outer join VT_EXAM_DETAILS EXD on (SER.SRV_ID = EXD.SRV_ID)
where
	SER.SRV_LIST_PRICE >= 100
	and EXD.EX_ID is null
;

/*  THE END */



spool off