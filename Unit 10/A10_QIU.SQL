spool A10_QIU.LST


set echo on
set feedback 1
set pagesize 999
set trimspool on
set linesize 200
set tab off
clear columns

column TITLE format a65


/* Jeffrey Qiu */


/*  TASK 00 */
select user, sysdate 
from dual;

/*  TASK 01 */
select
	BOK.BOOK_ID
	, BOK.TITLE
from
	BK_BOOKS BOK
where
	BOK.BOOK_ID in
		(
		select 
			BKT.BOOK_ID
		from
			BK_BOOK_TOPICS BKT
		where
			BKT.TOPIC_ID = 'DB'
			or BKT.TOPIC_ID = 'SQL'
		)
	and BOK.BOOK_ID in
		(
		select
			ORD.BOOK_ID
		from
			BK_ORDER_DETAILS ORD
		)
order by
	BOK.BOOK_ID		
;

/*  TASK 02  */
select
	BOK.BOOK_ID
	, BOK.TITLE
from
	BK_BOOKS BOK
where
	BOK.BOOK_ID in
		(
		select 
			BKT.BOOK_ID
		from
			BK_BOOK_TOPICS BKT
		where
			BKT.TOPIC_ID = 'DB'
		)
	and BOK.BOOK_ID in
		(
		select 
			BKT.BOOK_ID
		from
			BK_BOOK_TOPICS BKT
		where
			BKT.TOPIC_ID = 'SQL'
		)
	and BOK.BOOK_ID in
		(
		select
			ORD.BOOK_ID
		from
			BK_ORDER_DETAILS ORD
		)
order by
	BOK.BOOK_ID		
;


/*  TASK 03 */
select
	BOK.BOOK_ID
	, BOK.TITLE
from
	BK_BOOKS BOK
where
	BOK.BOOK_ID in
		(
		select 
			BKT.BOOK_ID
		from
			BK_BOOK_TOPICS BKT
		where
			BKT.TOPIC_ID = 'SQL'
		)
	and BOK.BOOK_ID not in
		(
		select 
			BKT.BOOK_ID
		from
			BK_BOOK_TOPICS BKT
		where
			BKT.TOPIC_ID = 'DB'
		)
	and BOK.BOOK_ID in
		(
		select
			ORD.BOOK_ID
		from
			BK_ORDER_DETAILS ORD
		)
order by
	BOK.BOOK_ID		
;

/*  TASK 04 */
/* 
	Assume that each order contains only one record in BK_ORDER_DETAILS table for a single book. 
	I.e. the same book in a single order cannot be recorded as 2 separate line items.	
 */
with BOOK_SALES as
	(
	select
		ORD.BOOK_ID as BOOK_ID
		, sum(nvl(ORD.QUANTITY, 0) * nvl(ORD.ORDER_PRICE, 0.0)) as TOTAL_SALES
	from
		BK_ORDER_DETAILS ORD
	group by 
		ORD.BOOK_ID
	)
select 
	BOK.BOOK_ID
	, BOK.TITLE
	, BOK.YEAR_PUBLD
	, (
		select
			max(TOTAL_SALES)
		from
			BOOK_SALES 
	  ) as LARGEST_SALES_AMOUNT
from
	BK_BOOKS BOK
where
	BOK.BOOK_ID in
		(
		select 
			BOS.BOOK_ID
		from
			BOOK_SALES BOS
		where
			BOS.TOTAL_SALES =
				(
				select
					max(TOTAL_SALES)
				from
					BOOK_SALES 
				)
		)
order by 
	BOK.BOOK_ID
;

/*  TASK 05 */
select
	CUS.CUST_ID
	, CUS.CUST_NAME_LAST
from
	BK_CUSTOMERS CUS
where
	CUS.CUST_ID in
		(
		select 
			ORH.CUST_ID
		from
			BK_ORDER_HEADERS ORH
		where
			ORH.ORDER_ID in
				(
				select
					ORD.ORDER_ID
				from
					BK_ORDER_DETAILS ORD
				where
					ORD.BOOK_ID in
						(
						select
							BKT.BOOK_ID 
						from
							BK_BOOK_TOPICS BKT
						where
							BKT.TOPIC_ID = 'ART'
						)
				)
		)
order by
	CUS.CUST_ID
;

select
	CUS.CUST_ID
	, CUS.CUST_NAME_LAST
from
	BK_CUSTOMERS CUS
where
	CUS.CUST_ID in
		(
		select 
			ORH.CUST_ID
		from
			BK_ORDER_HEADERS ORH
		where
			ORH.ORDER_ID in
				(
				select
					ORD.ORDER_ID
				from
					BK_ORDER_DETAILS ORD
				where
					ORD.BOOK_ID in
						(
						select
							BKT.BOOK_ID 
						from
							BK_BOOK_TOPICS BKT
						where
							BKT.TOPIC_ID = 'HIST'
						)
				)
		)
order by
	CUS.CUST_ID
;

/*  TASK 06 */
with BOOK_COPYSOLD as
	(
	select
		ORD.BOOK_ID as BOOK_ID
		, sum(nvl(ORD.QUANTITY, 0)) as COPY_SOLD
	from
		BK_ORDER_DETAILS ORD
	group by 
		ORD.BOOK_ID
	)
select
	BOK.BOOK_ID
	, BOK.TITLE
from
	BK_BOOKS BOK
where
	BOK.BOOK_ID in
		(
		select
			BCS.BOOK_ID
		from
			BOOK_COPYSOLD BCS
		where
			BCS.COPY_SOLD > 500
		)
order by 
	BOK.BOOK_ID
;

/*  TASK 07 */
with ORDER_STATISTICS as
(
	select 	
		OYM.YEAR_MONTH
		, count(OYM.ORDER_ID) as NUM_OF_ORDERS
	from
		(
		select 
			ORH.ORDER_ID
			, to_char(ORH.ORDER_DATE, 'YYYY') || '.' || to_char(ORH.ORDER_DATE, 'MM') as YEAR_MONTH
		from
			BK_ORDER_HEADERS ORH
		) OYM
	group by
		OYM.YEAR_MONTH
)
select 
	ORS.YEAR_MONTH
from
	ORDER_STATISTICS ORS
where
	ORS.NUM_OF_ORDERS = 
		(
		select
			min(NUM_OF_ORDERS)
		from
			ORDER_STATISTICS 
		)
order by
	ORS.YEAR_MONTH DESC
;


/*  TASK 08 */
with ORDER_STATISTICS as
(
	select 	
		OYM.YEAR_MONTH
		, count(OYM.ORDER_ID) as NUM_OF_ORDERS
	from
		(
		select 
			ORH.ORDER_ID
			, to_char(ORH.ORDER_DATE, 'YYYY') || '.' || to_char(ORH.ORDER_DATE, 'MM') as YEAR_MONTH
		from
			BK_ORDER_HEADERS ORH
		) OYM
	group by
		OYM.YEAR_MONTH
)
select 
	ORS.YEAR_MONTH
from
	ORDER_STATISTICS ORS
where
	ORS.NUM_OF_ORDERS = 
		(
		select
			max(NUM_OF_ORDERS)
		from
			ORDER_STATISTICS 
		)
order by
	ORS.YEAR_MONTH DESC
;


/*  THE END */




spool off














