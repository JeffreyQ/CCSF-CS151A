spool A03_QIU.LST

set echo on
set feedback 1
set pagesize 999
set trimspool on
set linesize 200
set tab off
clear columns


/* JEFFREY QIU */


/*  TASK 00 */
select user, sysdate 
from dual;


/*  TASK 01 */

select distinct CL_POSTAL_CODE || ': ' || CL_CITY || ' ' || CL_STATE as "Location"
from VT_CLIENTS
where CL_STATE in ('CA', 'NV')
;


/*  TASK 02  */
/* Assume there are three columns to show the results. */

select CL_NAME_FIRST, CL_NAME_LAST, CL_PHONE
from VT_CLIENTS
where CL_PHONE IS NOT NULL
order by CL_ID
;


/*  TASK 03 */

select distinct SRV_ID
from VT_EXAM_DETAILS
where EX_FEE > 50
;


/*  TASK 04 */

select STF_NAME_FIRST, STF_NAME_LAST, STF_ID
from VT_STAFF
where STF_JOB_TITLE not in ('vet', 'vet assnt')
;


/*  TASK 05 */

select SRV_ID as "Service ID", SRV_TYPE as "Service Type", SRV_DESC as "Description", SRV_LIST_PRICE as "Curr Price", SRV_LIST_PRICE * 1.15 as "Incr Price"
from VT_SERVICES
where SRV_TYPE != 'office visit'
order by SRV_ID
;


/*  TASK 06 */
/* I found that porcupine, dormouse, and hamster are rodents. Assume that only these three animal types are rodents. */

select CL_ID, AN_ID, AN_NAME
from VT_ANIMALS
where AN_TYPE in ('porcupine', 'dormouse', 'hamster')
order by CL_ID, AN_ID
;


/*  TASK 07 */
/* I found that lizard, chelonian, and snake are reptiles. Assume that only these three animal types are reptiles. */

select distinct CL_ID, AN_TYPE
from VT_ANIMALS
where AN_TYPE in ('lizard', 'chelonian', 'snake')
order by CL_ID
;



/*  TASK 08 */

select CL_ID, AN_ID, AN_NAME, AN_DOB
from VT_ANIMALS
where AN_TYPE not in ('porcupine', 'dormouse', 'hamster', 'lizard', 'chelonian', 'snake')
order by AN_DOB desc
;


/*  THE END */


spool off