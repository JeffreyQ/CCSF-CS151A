spool A02_QIU.LST

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
from dual
;

/*  TASK 01 */
select STF_NAME_FIRST, STF_NAME_LAST, STF_JOB_TITLE
from VT_STAFF
;

/*  TASK 02  */
select AN_ID as "ID", AN_NAME as "Name", AN_TYPE as "Animal Type", AN_DOB as "BirthDate"
from VT_ANIMALS
order by AN_DOB asc
;

/*  TASK 03 */
select distinct AN_TYPE
from VT_ANIMAL_TYPES
;

/*  TASK 04 */
select SRV_TYPE, SRV_DESC
from VT_SERVICES
order by SRV_TYPE, SRV_LIST_PRICE
;

/*  TASK 05 */

/* 
I assume that not every row in the column EX_DESC from VT_EXAM_DETAILS is an exam. 
Only the rows that contain the word "exam" in the column EX_DESC are considered an exam.
*/

select EX_ID as "EXAM_ID", SRV_ID as "SERVICE", EX_FEE as "FEE_CHARGED"
from VT_EXAM_DETAILS
where EX_DESC like '%exam%' 
;

/*  TASK 06 */
select distinct AN_NAME, AN_TYPE, AN_DOB
from VT_ANIMALS
order by AN_TYPE, AN_NAME
;

/*  TASK 07 */
select AN_ID as "Animal", EX_DATE as "Exam Date", STF_ID as "Staff"
from VT_EXAM_HEADERS
order by STF_ID, EX_DATE
;

/*  TASK 08 */
select distinct CL_STATE, CL_CITY
from VT_CLIENTS
order by CL_STATE, CL_CITY
;

/*  THE END */

spool off




