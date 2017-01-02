spool A05_QIU.LST


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
	, nvl(CL_NAME_FIRST, '(ZLS)')
	, nvl(CL_PHONE, 'No phone number')
from
	VT_CLIENTS
;
	

/*  TASK 02  */
select
	AN_ID || ': ' || AN_TYPE || ' ' || nvl(AN_NAME, 'no name') as "ANIMAL"
from
	VT_ANIMALS
;

/*  TASK 03 */
select
	CL_ID as "Client Id"
	, CL_NAME_LAST || decode(CL_NAME_FIRST, NULL, '', ', ' || CL_NAME_FIRST) as "Name"
from 
	VT_CLIENTS
;

/*  TASK 04 */
select
	SRV_ID
	, to_char(SRV_LIST_PRICE, 9999.99) as "PRICE"
	, to_char(round(SRV_LIST_PRICE, -1), 9999.99) as "TO_TENS"
	, to_char(round(SRV_LIST_PRICE, 0), 9999.99) as "UNTO_DLR"
from
	VT_SERVICES
;

/*  TASK 05 */
select *
from 
	VT_SERVICES
where
	regexp_instr(SRV_DESC, '*Feline*') > 0 
	and regexp_instr(SRV_DESC, '*Dental*') = 0
;

/*  TASK 06 */
select 
	EX_ID
	, to_char(EX_DATE, 'DD-MON-YY') as "EXAMDATE1"
	, to_char(EX_DATE, 'YYYY-MM-DD') as "EXAMDATE2"
	, to_char(EX_DATE, 'MON DD, YYYY') as "EXAMDATE3"
	, to_char(EX_DATE, 'fmMonth DD, YYYY') as "EXAMDATE4"
--	, to_char(EX_DATE, 'Month DD, YYYY') as "EXAMDATE5"
from
	VT_EXAM_HEADERS
;

/*  TASK 07 */
/* I assume that duplicates should all be shown. */
select
	ANI.AN_ID
	, ANI.AN_NAME
from
	VT_ANIMALS ANI
	join VT_EXAM_HEADERS EXH on (ANI.AN_ID = EXH.AN_ID)
where
	to_char(EXH.EX_DATE, 'YYYY-MM') between '2015-01' and '2015-06'
;

/*  TASK 08 */
/* I assume that duplicates should all be shown. */
select
	ANI.AN_ID
	, ANI.AN_NAME
from
	VT_ANIMALS ANI
	join VT_EXAM_HEADERS EXH on (ANI.AN_ID = EXH.AN_ID)
where
	to_char(EXH.EX_DATE, 'YYYY-MM') = to_char(add_months(sysdate, -1), 'YYYY-MM')
;
	

/*  TASK 09 */
select
	ANI.AN_ID as "ID"
	, ANI.AN_NAME as "NAME"
	, to_char(EXH.EX_DATE, 'YYYY-MM-DD') as "EXAM DATE"
from
	VT_ANIMALS ANI
	join VT_EXAM_HEADERS EXH on (ANI.AN_ID = EXH.AN_ID)
where
	to_char(EXH.EX_DATE, 'YYYY-MM-DD') = to_char(last_day(EXH.EX_DATE), 'YYYY-MM-DD')
;

/*  TASK 10 */
VAR 	var_random_row NUMBER;
/* After the declaration, a value can be assigned to the variable. */
BEGIN
	select round(dbms_random.value(10, 25)) into :var_random_row from DUAL;
END;
/

select :var_random_row from dual;

select EX_ID, SRV_ID, EX_FEE from VT_EXAM_DETAILS where rownum <= :var_random_row;


/* The End */



spool off