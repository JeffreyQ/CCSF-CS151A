spool A07_QIU.LST

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
	, AN_ID
	, AN_TYPE
	, AN_NAME
from
	VT_CLIENTS CLI
	left outer join VT_ANIMALS ANI using (CL_ID)
;	

/*  TASK 02  */
select distinct
	AN_ID
	, AN_TYPE
	, AN_NAME
	, EX_ID
	, to_char(EX_DATE, 'yyyy') as EX_DATE
	, SRV_ID
from
	VT_ANIMALS ANI
	left outer join VT_EXAM_HEADERS EXH using (AN_ID)
	left outer join VT_EXAM_DETAILS EXD using (EX_ID)
;

/*  TASK 03 */
select distinct
	CLI.CL_ID
	, CLI.CL_NAME_LAST
from
	VT_CLIENTS CLI
where
	CLI.CL_ID in
	(
		select 
			CL_ID
		from 
			VT_ANIMALS
		where
			AN_TYPE not in ('snake', 'chelonian', 'crocodilian', 'lizard')
	)
;

/*  TASK 04 */
select distinct
	CLI.CL_ID
	, CLI.CL_NAME_LAST
from
	VT_CLIENTS CLI
where
	CLI.CL_ID in
	(
		select 
			CL_ID
		from 
			VT_ANIMALS
		where
			AN_TYPE in ('snake', 'chelonian', 'crocodilian', 'lizard')
	)
	and CLI.CL_ID in
	(
		select 
			CL_ID
		from 
			VT_ANIMALS
		where
			AN_TYPE = 'bird'
	)
;

/*  TASK 05 */
select distinct
	CLI.CL_ID
	, CLI.CL_NAME_LAST
from
	VT_CLIENTS CLI
where
	CLI.CL_ID not in
	(
		select 
			CL_ID
		from 
			VT_ANIMALS
		where
			AN_TYPE in ('snake', 'chelonian', 'crocodilian', 'lizard')
	)
	and CLI.CL_ID in
	(
		select 
			CL_ID
		from 
			VT_ANIMALS
		where
			AN_TYPE = 'bird'
	)
;

/*  TASK 06 */
select distinct
	ANI.AN_ID
	, ANI.AN_NAME
from
	VT_ANIMALS ANI
	join VT_EXAM_HEADERS EXH on (ANI.AN_ID = EXH.AN_ID)
where
	EXH.EX_ID not in
	(
		select
			EX_ID
		from
			VT_EXAM_DETAILS
		where
			SRV_ID in (104, 105, 106, 108)
	)
;

/*  TASK 07 */
select distinct
	AN_ID
	, AN_NAME
	, AN_TYPE
	, CL_ID
from
	VT_ANIMALS 
where
	AN_ID in
	(
		select AN_ID
		from
			VT_EXAM_HEADERS
		where
			to_char(EX_DATE, 'yyyy') = '2014'
	)
	and
	AN_ID in
	(
		select AN_ID
		from
			VT_EXAM_HEADERS
		where
			to_char(EX_DATE, 'yyyy') = '2015'
	)
;

/*  TASK 08 */
select distinct
	AN_ID
	, AN_NAME
	, AN_TYPE
	, CL_ID
from
	VT_ANIMALS 
where
	AN_TYPE in ('snake', 'chelonian', 'crocodilian', 'lizard')
	and AN_ID in
	(
		select AN_ID
		from
			VT_EXAM_HEADERS
		where
			to_char(EX_DATE, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy')
	)
	and
	AN_ID not in
	(
		select AN_ID
		from
			VT_EXAM_HEADERS
		where
			to_char(EX_DATE, 'yyyy') = to_char(sysdate, 'yyyy')
	)
;

/*  TASK 09 */
select distinct
	ANI.AN_ID
	, ANI.AN_NAME
	, ANI.CL_ID
from
	VT_ANIMALS ANI
	join VT_EXAM_HEADERS EXH on (ANI.AN_ID = EXH.AN_ID)
where
	EXH.EX_ID in
	(
		select
			EX_ID
		from
			VT_EXAM_DETAILS
		where
			SRV_ID = 603
	)
	and EXH.EX_ID in
	(
		select
			EX_ID
		from
			VT_EXAM_DETAILS
		where
			SRV_ID = 606 
			or SRV_ID = 607 
	)
;

/*  THE END */


spool off









