spool A12_QIU.LST


set echo on
set feedback 1
set pagesize 999
set trimspool on
set linesize 200
set tab off
clear columns


Column Title format A25 truncated
Column "Book_Title" format A25 truncated



/* Jeffrey Qiu */


/*  TASK 00 */
select user, sysdate 
from dual;


/*  TASK 01 */
select
	row_number () over (order by LIST_PRICE) as "ListPrice Order"
	, BOOK_ID as "Book ID"
	, TITLE as "Book_Title"
	, PUBL_ID as "Publ"
	, to_char(LIST_PRICE, '999.99') as "Price"
from 
	BK_BOOKS
order by 
	LIST_PRICE 
;


/*  TASK 02  */
with BOOKS_PUBLD_AFTER_2005 as
	(
	select * from BK_BOOKS where YEAR_PUBLD >= '2005'
	)
select
	dense_rank () over (order by PUBL_ID, LIST_PRICE desc) as "Publ-ListPrice Order"
	, PUBL_ID as "Publ"
	, to_char(LIST_PRICE, '999.99') as "Price"
	, BOOK_ID as "Book ID"
	, TITLE as "Book_Title"
from
	BOOKS_PUBLD_AFTER_2005
order by
	PUBL_ID
	, LIST_PRICE desc
;


/*  TASK 03 */
with BOOK_ORDER_QTY as 
	(
	select
		BOOK_ID
		, round(sum(nvl(QUANTITY, 0)), -1) as QTY
	from
		BK_ORDER_DETAILS
	group by
		BOOK_ID
	)
, BOOK_SALES as 
	(
	select
		rank () over (order by QTY desc) as SALES_RANKING
		, BOOK_ID
		, TITLE
		, QTY
	from
		BK_BOOKS
		join BOOK_ORDER_QTY using (BOOK_ID)
	)
select
	SALES_RANKING as "Sales Ranking"
	, BOOK_ID as "Book ID"
	, TITLE as "Book_Title"
	, to_char(QTY, '999,999') as "TotQuantSale"
from 
	BOOK_SALES 
where
	SALES_RANKING <= 15
order by
	1
;


/*  TASK 04 */
Column "RunningSalesByCustomer" format 999,999.99

with CURRENT_YEAR_SALES as
	(
	select
		CUST_ID
		, to_char(ORDER_DATE, 'YYYY-MM-DD') as ORD_DATE 
		, sum(nvl(QUANTITY, 0) * nvl(ORDER_PRICE, 0)) as TOTSALES
	from
		BK_ORDER_HEADERS ORH
		join BK_ORDER_DETAILS ORD using (ORDER_ID)
	where
		extract(year from ORDER_DATE) = extract(year from sysdate)
	group by
		CUST_ID
		, to_char(ORDER_DATE, 'YYYY-MM-DD')  
	)
select
	CUST_ID as "cust_id"
	, ORD_DATE as "order_date"
	, to_char(TOTSALES, '999,999.99') as "SalesByDay"
	, sum(TOTSALES) over (partition by CUST_ID order by ORD_DATE) as "RunningSalesByCustomer"
from
	CURRENT_YEAR_SALES 
where
	CUST_ID < 220000
order by
	CUST_ID
	, ORD_DATE
;


/*  TASK 05 */
Column "Quantity" format 999,999

with AUTHOR_BOOK_SALES as
	(
	select
		AUTHOR_ID
		, BOOK_ID
		, sum(QUANTITY) as QTY
		, sum(QUANTITY * ORDER_PRICE) as TOTSALES
	from
		BK_BOOK_AUTHORS
		join BK_BOOKS using (BOOK_ID)
		left outer join BK_ORDER_DETAILS using (BOOK_ID)
	where
		AUTHOR_ID < 'J'
	group by	
		AUTHOR_ID
		, BOOK_ID
	)
select 
	AUTHOR_ID as "Author ID"
	, decode(BOOK_ID, NULL, '  Total', BOOK_ID) as "Book ID"
	, sum(nvl(QTY, 0)) as "Quantity"
	, decode(sum(TOTSALES), NULL, 'No sales', to_char(sum(TOTSALES), '999,999.99')) as "Total Sales"
from 
	AUTHOR_BOOK_SALES 
group by 
	rollup (AUTHOR_ID, BOOK_ID)
;


/*  TASK 06 */
/* In order to generate a calendar for 35 days, we pick up a big enough table BK_ORDER_DETAILS and use ROWNUM. */

Column "TotalSales" format 999,999.99

define START_DATE = "'2014-03-01'"
define DAYS_IN_CAL = "35"

with CALENDAR as
	(
	select 
		to_date(&START_DATE, 'YYYY-MM-DD') - 2 + rownum as CAL_DATE
	from
		BK_ORDER_DETAILS
	where
		rownum <= &DAYS_IN_CAL
	)
, DAILY_SALES_RECORDS as
	(
	select
		CAL_DATE as ORD_DATE
		, sum(nvl(QUANTITY, 0) * nvl(ORDER_PRICE, 0)) as TOTALSALES
	from 
		CALENDAR CAL
		left outer join BK_ORDER_HEADERS ORH on (CAL.CAL_DATE = trunc(ORH.ORDER_DATE))  
		left outer join BK_ORDER_DETAILS ORD on (ORH.ORDER_ID = ORD.ORDER_ID)
	group by
		CAL_DATE
	)
select 
	to_char(ORD_DATE, 'YYYY-MM-DD') as "Date"
	, TOTALSALES as "TotalSales"
	, to_char(sum(TOTALSALES) over (order by ORD_DATE rows between 2 preceding and 2 following), '999,999.99') as "5 DaySUM"
	, to_char(avg(TOTALSALES) over (order by ORD_DATE rows between 2 preceding and 2 following), '999,999.99') as "5 DayAvg"
from 
	DAILY_SALES_RECORDS 
where
	extract(month from ORD_DATE) = 3
order by
	1
;



/*  THE END */



spool off