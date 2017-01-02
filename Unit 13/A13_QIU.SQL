spool A13_QIU.SQL



set echo on
set feedback 1
set pagesize 999
set trimspool on
set linesize 200
set tab off
clear columns


column line format 999
column text format a70
column text wrapped


/* Jeffrey Qiu */

/* function source code */
create or replace function booksize
	(
	SIZE_IN integer
	)
return varchar
as
	V_MSG varchar(100);
begin

	if SIZE_IN is null then
		V_MSG := 'Input value is missing';
	elsif SIZE_IN <= 0 then
		V_MSG := 'Input value must be a strictly positive value';
	elsif SIZE_IN between 1 and 200 then
		V_MSG := 'Short';
	elsif SIZE_IN between 201 and 500 then
		V_MSG := 'Medium';
	elsif SIZE_IN between 501 and 1200 then
		V_MSG := 'Long';
	elsif SIZE_IN between 1201 and 4000 then
		V_MSG := 'ExtraLong';
	else	-- SIZE_IN > 4000
		V_MSG := 'SuperLong';
	end if;
	return V_MSG;

end booksize;
/


/* function source code */
create or replace function PrevMonth
	(
	IN_DATE date
	, IN_MN_ADJUST integer
	)
return varchar
as
	V_TMP_DATE date;
begin

	if IN_DATE is null then
		V_TMP_DATE := sysdate;
	else
		V_TMP_DATE := IN_DATE;
	end if;
		
	if IN_MN_ADJUST is null or IN_MN_ADJUST < 0 then
		return '';
	end if;

	V_TMP_DATE := add_months(V_TMP_DATE, -1 * IN_MN_ADJUST);

	return to_char(V_TMP_DATE, 'YYYY-MM');

end PrevMonth;
/


/*  TASK 00 */
select user, sysdate 
from dual;

/*  TASK 01 */
column actual format a30
column expected format a30

with MY_TEST_DATA as
	(
	select 1 as testrun, -1 as PageCount, 'Input value must be a strictly positive value' as expected from dual
	union all
	select 2 as testrun, 0 as PageCount, 'Input value must be a strictly positive value' as expected from dual
	union all
	select 3 as testrun, 1 as PageCount, 'Short' as expected from dual
	union all
	select 4 as testrun, 199 as PageCount, 'Short' as expected from dual
	union all
	select 5 as testrun, 200 as PageCount, 'Short' as expected from dual
	union all
	select 6 as testrun, 201 as PageCount, 'Medium' as expected from dual
	union all
	select 7 as testrun, 325 as PageCount, 'Medium' as expected from dual
	union all
	select 8 as testrun, 500 as PageCount, 'Medium' as expected from dual
	union all
	select 9 as testrun, 501 as PageCount, 'Long' as expected from dual
	union all
	select 10 as testrun, 999 as PageCount, 'Long' as expected from dual
	union all
	select 11 as testrun, 1200 as PageCount, 'Long' as expected from dual
	union all
	select 12 as testrun, 1201 as PageCount, 'ExtraLong' as expected from dual
	union all
	select 13 as testrun, 1250 as PageCount, 'ExtraLong' as expected from dual
	union all
	select 15 as testrun, 4000 as PageCount, 'ExtraLong' as expected from dual
	union all
	select 16 as testrun, 4001 as PageCount, 'SuperLong' as expected from dual
	union all
	select 17 as testrun, 13009 as PageCount, 'SuperLong' as expected from dual
	union all
	select 18 as testrun, null as PageCount, 'Input value is missing' as expected from dual
	)
select 
	testrun
	, PageCount
	, booksize(PageCount) as actual
	, expected
from 
	MY_TEST_DATA
order by 
	testrun
;

/*  TASK 02  */
with MY_TEST_DATA as
	(
	select 1 as testrun, NULL as ddate_in, -1 as month_in, '' as expected from dual
	union all
	select 2 as testrun, NULL as ddate_in, NULL as month_in, '' as expected from dual
	union all
	select 3 as testrun, NULL as ddate_in, 0 as month_in, '2015-12' as expected from dual
	union all
	select 4 as testrun, DATE '2012-04-01' as ddate_in, NULL as month_in, '' as expected from dual
	union all
	select 5 as testrun, DATE '2012-04-01' as ddate_in, 0 as month_in, '2012-04' as expected from dual
	union all
	select 6 as testrun, DATE '2012-04-01' as ddate_in, 1 as month_in, '2012-03' as expected from dual
	union all
	select 7 as testrun, DATE '2012-04-30' as ddate_in, 6 as month_in, '2011-10' as expected from dual
	union all
	select 8 as testrun, DATE '2012-04-30' as ddate_in, 12 as month_in, '2011-04' as expected from dual
	union all
	select 9 as testrun, DATE '2012-04-30' as ddate_in, 13 as month_in, '2011-03' as expected from dual
	union all
	select 10 as testrun, DATE '2012-04-19' as ddate_in, NULL as month_in, NULL as expected from dual
	union all
	select 11 as testrun, DATE '2012-04-19' as ddate_in, -25 as month_in, NULL as expected from dual
	)
, MY_TEST_VIEW as
	(
	select
		testrun
		, ddate_in
		, month_in
		, expected
		, PrevMonth(ddate_in, month_in) as actual
	from 
		MY_TEST_DATA
	)
select
	testrun
	, to_char(ddate_in, 'YYYY-MM-DD') as date_in
	, month_in
	, actual
	, expected
	, decode(actual, expected, 'pass', '***FAIL***') as status
from 
	MY_TEST_VIEW
order by
	testrun
;

/*  TASK 03 */
column booksize format a50

with IDX_ORDER as
	(
	select 1 as IDX, 'Short' as BOOKSIZE from dual
	union all
	select 2 as IDX, 'Medium' as BOOKSIZE from dual
	union all
	select 3 as IDX, 'Long' as BOOKSIZE from dual
	union all
	select 4 as IDX, 'ExtraLong' as BOOKSIZE from dual
	union all
	select 5 as IDX, 'SuperLong' as BOOKSIZE from dual
	)
, BOOKSIZE_COUNT as 
	(
	select
		BOOK_ID
		, booksize(page_count) as booksize
	from
		BK_BOOKS
	)  
, TMP_RESULT as
	(
	select
		IDX
		, BOOKSIZE
		, count(BOOK_ID) as NUMBOOKS
	from
		IDX_ORDER
		join BOOKSIZE_COUNT using (BOOKSIZE)
	group by
		IDX
		, BOOKSIZE
	order by
		IDX
	)
select 
	BOOKSIZE
	, NUMBOOKS
from
	TMP_RESULT
;


/*  TASK 04 */
column booksize format a50

with IDX_ORDER as
	(
	select 1 as IDX, 'Short' as BOOKSIZE from dual
	union all
	select 2 as IDX, 'Medium' as BOOKSIZE from dual
	union all
	select 3 as IDX, 'Long' as BOOKSIZE from dual
	union all
	select 4 as IDX, 'ExtraLong' as BOOKSIZE from dual
	union all
	select 5 as IDX, 'SuperLong' as BOOKSIZE from dual
	)
, BOOKSIZE_COUNT as 
	(
	select
		BOOK_ID
		, booksize(page_count) as booksize
	from
		BK_BOOKS
	)  
, TMP_RESULT as
	(
	select
		IDX
		, BOOKSIZE
		, count(BOOK_ID) as NUMBOOKS
	from
		IDX_ORDER
		left outer join BOOKSIZE_COUNT using (BOOKSIZE)
	group by
		IDX
		, BOOKSIZE
	order by
		IDX
	)
select 
	BOOKSIZE
	, NUMBOOKS
from
	TMP_RESULT
;

/*  TASK 05 */
with ORDER_IN_PREV2MONTHS as 
	(
	select 
		ORDER_ID
		, CUST_ID
	from
		BK_ORDER_HEADERS
	where
		to_char(ORDER_DATE, 'YYYY-MM') between PrevMonth(sysdate, 2) and to_char(sysdate, 'YYYY-MM')  
	)
, TTL_ORDERS as
	(
	select
		count(ORDER_ID) as NumberOrders
	from
		ORDER_IN_PREV2MONTHS
	)
, TTL_CUSTOMERS as
	(
	select
		count(distinct CUST_ID) as NumberCustWithOrders
	from
		ORDER_IN_PREV2MONTHS
	)
select
	NumberOrders
	, NumberCustWithOrders
from
	TTL_ORDERS
	cross join TTL_CUSTOMERS
;



/*  THE END */


spool off


spool off
