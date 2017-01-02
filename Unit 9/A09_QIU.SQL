spool A09_QIU.LST

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
/* assume that "No Last Name" and "No First Name" will be displayed if corresponding column is NULL */

drop view BkOrdersPriorYear;

create view BkOrdersPriorYear
as
	select 
		CUST_ID as "C_ID"
		, nvl(CUST_NAME_LAST, 'No Last Name') || ', ' || nvl(CUST_NAME_FIRST, 'No First Name') as "C_NAME"
		, extract(month from ORDER_DATE) as ORDER_MONTH
	from
		BK_CUSTOMERS CUS
		join BK_ORDER_HEADERS ORH using (CUST_ID)
	where
		extract(year from ORDER_DATE) = extract(year from sysdate) - 1;
	

/*  TASK 02  */
(
select
	C_ID
	, C_NAME
--	, ORDER_MONTH
from
	BkOrdersPriorYear
where
	ORDER_MONTH = 3
)
intersect
(
select
	C_ID
	, C_NAME
--	, ORDER_MONTH
from
	BkOrdersPriorYear
where
	ORDER_MONTH = 6
)
intersect
(
select
	C_ID
	, C_NAME
--	, ORDER_MONTH
from
	BkOrdersPriorYear
where
	ORDER_MONTH = 9
)
;

/*  TASK 03 */
(
select
	C_ID
	, C_NAME
--	, ORDER_MONTH
from
	BkOrdersPriorYear
where
	ORDER_MONTH = 4
)
union
(
select
	C_ID
	, C_NAME
--	, ORDER_MONTH
from
	BkOrdersPriorYear
where
	ORDER_MONTH = 6
)
union
(
select
	C_ID
	, C_NAME
--	, ORDER_MONTH
from
	BkOrdersPriorYear
where
	ORDER_MONTH = 8
)
;

/*  TASK 04 */
(
select
	C_ID
	, C_NAME
--	, ORDER_MONTH
from
	BkOrdersPriorYear
where
	ORDER_MONTH = 4
)
intersect
(
select
	C_ID
	, C_NAME
--	, ORDER_MONTH
from
	BkOrdersPriorYear
where
	ORDER_MONTH = 5
)
minus
(
select
	C_ID
	, C_NAME
--	, ORDER_MONTH
from
	BkOrdersPriorYear
where
	ORDER_MONTH = 6
)
;


/*  TASK 05 */
(
select
	C_ID
	, C_NAME
--	, ORDER_MONTH
from
	BkOrdersPriorYear
where
	ORDER_MONTH = 3
)
union
(
select
	C_ID
	, C_NAME
--	, ORDER_MONTH
from
	BkOrdersPriorYear
where
	ORDER_MONTH = 6
)
minus
(
select
	C_ID
	, C_NAME
--	, ORDER_MONTH
from
	BkOrdersPriorYear
where
	ORDER_MONTH = 9
)
;

/*  TASK 06 */
(
select
	C_ID
	, C_NAME
--	, ORDER_MONTH
from
	BkOrdersPriorYear
)
minus
(
select
	C_ID
	, C_NAME
--	, ORDER_MONTH
from
	BkOrdersPriorYear
where
	ORDER_MONTH = 3
)
minus
(
select
	C_ID
	, C_NAME
--	, ORDER_MONTH
from
	BkOrdersPriorYear
where
	ORDER_MONTH = 6
)
minus
(
select
	C_ID
	, C_NAME
--	, ORDER_MONTH
from
	BkOrdersPriorYear
where
	ORDER_MONTH = 9
)
;

/*  TASK 07 */
(
select
	C_ID
	, C_NAME
--	, ORDER_MONTH
from
	BkOrdersPriorYear
where
	ORDER_MONTH = 1
)
minus
(
select
	C_ID
	, C_NAME
--	, ORDER_MONTH
from
	BkOrdersPriorYear
where
	ORDER_MONTH = 2
)
minus
(
select
	C_ID
	, C_NAME
--	, ORDER_MONTH
from
	BkOrdersPriorYear
where
	ORDER_MONTH = 3
)
;


/*  TASK 08 */
(
(
select
	C_ID
	, C_NAME
--	, ORDER_MONTH
from
	BkOrdersPriorYear
where
	ORDER_MONTH = 3
)
union
(
select
	C_ID
	, C_NAME
--	, ORDER_MONTH
from
	BkOrdersPriorYear
where
	ORDER_MONTH = 6
)
)
minus
(
(
select
	C_ID
	, C_NAME
--	, ORDER_MONTH
from
	BkOrdersPriorYear
where
	ORDER_MONTH = 3
)
intersect
(
select
	C_ID
	, C_NAME
--	, ORDER_MONTH
from
	BkOrdersPriorYear
where
	ORDER_MONTH = 6
)
)
;

/*  THE END */


spool off