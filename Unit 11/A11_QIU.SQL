spool A11_QIU.LST


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
	CUS.CUST_ID as "Cust_ID"
	, CUS.CUST_NAME_LAST as "Cust_Name_Last"
	, (
	  select count(ORH.ORDER_ID)
	  from
		BK_ORDER_HEADERS ORH
	  where
		CUS.CUST_ID = ORH.CUST_ID	
	  ) as "Number Of Orders"
from
	BK_CUSTOMERS CUS
where	
	CUS.CUST_STATE in ('NJ', 'MA')
;


/*  TASK 02  */
select
	CUS.CUST_ID as "Cust_ID"
	, CUS.CUST_NAME_LAST as "Cust_Name_Last"
from
	BK_CUSTOMERS CUS
where	
	exists 
		(
		select 1
		from
			BK_ORDER_HEADERS ORH
		where
			ORH.CUST_ID = CUS.CUST_ID
			and to_char(ORH.ORDER_DATE, 'YYYY/MM') = (to_char(sysdate, 'YYYY') || '/01')
		)
	and exists 
		(
		select 2
		from
			BK_ORDER_HEADERS ORH
		where
			ORH.CUST_ID = CUS.CUST_ID
			and to_char(ORH.ORDER_DATE, 'YYYY/MM') = (to_char(sysdate, 'YYYY') || '/02')
		)
	and exists 
		(
		select 3
		from
			BK_ORDER_HEADERS ORH
		where
			ORH.CUST_ID = CUS.CUST_ID
			and to_char(ORH.ORDER_DATE, 'YYYY/MM') = (to_char(sysdate, 'YYYY') || '/03')
		)
order by
	CUS.CUST_ID
;


/*  TASK 03 */
with AUTHOR_BOOKS as
	(
	select
		TMP.AUTHOR_ID
		, (
		  select
			AUT.AUTHOR_NAME_FIRST 
		  from
			BK_AUTHORS AUT
		  where
			AUT.AUTHOR_ID = TMP.AUTHOR_ID
		  ) as AUTHOR_NAME_FIRST
		, (
		  select
			AUT.AUTHOR_NAME_LAST 
		  from
			BK_AUTHORS AUT
		  where
			AUT.AUTHOR_ID = TMP.AUTHOR_ID
		  ) as AUTHOR_NAME_LAST
		, Number_Of_Books
	from
		(
		select 
			AUTHOR_ID
			, count(BOOK_ID) as Number_Of_Books
		from
			BK_BOOK_AUTHORS
		group by
			AUTHOR_ID
		) TMP
	)
select 
	AUB.AUTHOR_NAME_FIRST as "Author_Name_First"
	, AUB.AUTHOR_NAME_LAST as "Author_Name_Last"
	, AUB.AUTHOR_ID as "Author_ID"
from
	AUTHOR_BOOKS AUB
where
	AUB.NUMBER_OF_BOOKS >= 2
	and not exists
		(
		select 1
		from
			BK_BOOK_AUTHORS BAU
		where
			BAU.AUTHOR_ID = AUB.AUTHOR_ID
			and exists
				(
				select 1
				from
					BK_ORDER_DETAILS ORD
				where
					ORD.BOOK_ID = BAU.BOOK_ID
				)
		)
order by
	AUB.AUTHOR_ID
;


/*  TASK 04 */
with SQL_TOPIC_BOOKS as
	(
	select
		TOP.BOOK_ID
		, count(TOP.TOPIC_ID) as NUMBER_OF_TOPICS
	from
		BK_BOOK_TOPICS TOP
	where
		TOPIC_ID in ('SSRV', 'ORA', 'MYSQL')
	group by
		TOP.BOOK_ID	
	)
select
	STB.BOOK_ID
	, (
	  select
		BOK.TITLE
	  from
		BK_BOOKS BOK
	  where
		BOK.BOOK_ID = STB.BOOK_ID
	  ) as Title
from
	SQL_TOPIC_BOOKS STB
where
	STB.NUMBER_OF_TOPICS = 2
;	


/*  TASK 05 */
select
	ORH.ORDER_DATE as "Order Date"
	, ORH.ORDER_ID as "Order ID"
	, ORH.CUST_ID as "Customer ID"
	, (
	  select 
		CUST_NAME_LAST 
	  from 
		BK_CUSTOMERS CUS
	  where
		CUS.CUST_ID = ORH.CUST_ID
	  ) as "Customer"
	, (
	  select 
		sum(nvl(ORD.QUANTITY, 0)) 
	  from 
		BK_ORDER_DETAILS ORD 
	  where 
		ORD.ORDER_ID = ORH.ORDER_ID
	  ) as "NumberBooks"
	, (
	  select 
		sum(nvl(ORD.QUANTITY, 0) * nvl(ORDER_PRICE, 0))  
	  from 
		BK_ORDER_DETAILS ORD 
	  where 
		ORD.ORDER_ID = ORH.ORDER_ID
	  ) as "OrderCost"
from
	BK_ORDER_HEADERS ORH
where
	extract(year from ORH.ORDER_DATE) = extract(year from sysdate) - 1
	and extract(month from ORH.ORDER_DATE) between 1 and 3
order by
	ORH.ORDER_DATE
; 


/*  TASK 06 */
with PREVYEAR_CUSTER_ORDERS as
	(
	select
		ORH.CUST_ID
		, count(ORH.ORDER_ID) as NUMBER_OF_ORDERS
	from
		BK_ORDER_HEADERS ORH
	where
		extract(year from ORH.ORDER_DATE) = extract(year from sysdate) - 1
	group by
		ORH.CUST_ID
	)
select
	CUS.CUST_ID
	, CUS.CUST_NAME_LAST
from
	BK_CUSTOMERS CUS
where
	CUS.CUST_ID in
		(
		select 
			PCO.CUST_ID
		from
			PREVYEAR_CUSTER_ORDERS PCO
		where
			PCO.NUMBER_OF_ORDERS between 3 and 5
		)
order by
	CUS.CUST_ID
;


/*  TASK 07 */
with QUARTERLY_CUSTER_ORDERS as
	(
	select
		ORH.CUST_ID
		, to_char(ORH.ORDER_DATE, 'YYYY') as YEAR
		, to_char(ORH.ORDER_DATE, 'Q') as QUARTER
		, count(ORH.ORDER_ID) as NUMBER_OF_ORDERS
	from
		BK_ORDER_HEADERS ORH
	group by
		ORH.CUST_ID
		, to_char(ORH.ORDER_DATE, 'YYYY') 
		, to_char(ORH.ORDER_DATE, 'Q') 
	)
select
	CUS.CUST_ID
	, CUS.CUST_NAME_LAST
from
	BK_CUSTOMERS CUS
where
	exists	
		(
		select
			1
		from
			QUARTERLY_CUSTER_ORDERS PYQCO
		where
			PYQCO.YEAR = to_char(extract(year from sysdate) - 1)
			and PYQCO.QUARTER = '1'
			and PYQCO.CUST_ID = CUS.CUST_ID
			and exists
				(
				select
					2
				from
					QUARTERLY_CUSTER_ORDERS CYQCO
				where
					CYQCO.YEAR = to_char(sysdate, 'YYYY')
					and CYQCO.QUARTER = '1'
					and CYQCO.CUST_ID = PYQCO.CUST_ID
					and PYQCO.NUMBER_OF_ORDERS >= PYQCO.NUMBER_OF_ORDERS
				)
		)
order by
	CUS.CUST_ID
;	


/*  THE END */



spool off

