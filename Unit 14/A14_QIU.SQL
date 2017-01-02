spool A14_QIU.LST



set echo on
set feedback 1
set pagesize 999
set trimspool on
set linesize 200
set tab off
clear columns


set Long 99999

column BookID format A10
column Title format A35
column Price format 9,990.00
column AuthorList format A50
column Subject format A15
column AvgPrice format 9,990.00



/* Jeffrey Qiu */


/*  TASK 00 */
select user, sysdate 
from dual;

/*  TASK 01 */
with XML2TBL as 
	(
	select 
		extractvalue(OBJECT_VALUE, '/book/bk_id') as BookID 
		, extractvalue(OBJECT_VALUE, '/book/bk_title') as Title 
		, extractvalue(OBJECT_VALUE, '/book/bk_price') as Price 
		, extractvalue(OBJECT_VALUE, '/book/bk_subject') as Subject 
	from 
		xml_A14_books
	)
select
	BookID as "BookID"
	, Title as "Title"
	, cast(Price as number) as "Price"
	, Subject as "Subject"
from 
	XML2TBL
;

/* Alternative way to extract value from the XML document by using extract() function.
with XML2TBL as 
	(
	select 
		extract(OBJECT_VALUE, '/book/bk_id/text()') as BookID 
		, extract(OBJECT_VALUE, '/book/bk_title/text()') as Title 
		, extract(OBJECT_VALUE, '/book/bk_price/text()') as Price 
		, extract(OBJECT_VALUE, '/book/bk_subject/text()') as Subject 
	from 
		xml_A14_books
	)
select
	BookID as "BookID"
	, Title as "Title"
	, to_number(Price) as "Price"
	, Subject as "Subject"
from 
	XML2TBL
;
*/


/*  TASK 02  */
with XML2TBL as 
	(
	select 
		extractvalue(OBJECT_VALUE, '/book/bk_id') as BookID 
		, extractvalue(OBJECT_VALUE, '/book/bk_title') as Title 
		, extractvalue(OBJECT_VALUE, '/book/bk_price') as Price 
		, extractvalue(OBJECT_VALUE, '/book/bk_subject') as Subject
		, extract(OBJECT_VALUE, '/book/bk_authors') as AuthorList
	from 
		xml_A14_books
	)
select
	BookID as "BookID"
	, Title as "Title"
	, cast(Price as number) as "Price"
	, AuthorList as "AuthorList"
from 
	XML2TBL
where 
	Price >= 30 
	and Subject = 'Fiction'
;

/*  TASK 03 */
with XML2TBL as 
	(
	select 
		extractvalue(OBJECT_VALUE, '/book/bk_id') as BookID 
		, extractvalue(OBJECT_VALUE, '/book/bk_title') as Title 
		, extractvalue(OBJECT_VALUE, '/book/bk_subject') as Subject
		, extractvalue(OBJECT_VALUE, '/book/bk_price') as Price 
		, extract(OBJECT_VALUE, '/book/bk_authors') as AuthorList
	from 
		xml_A14_books
	where
		existsnode(OBJECT_VALUE, '/book [bk_price > 30]') = 1
		and existsnode(OBJECT_VALUE, '/book [bk_subject="Fiction"]') = 1
	)
select
	BookID as "BookID"
	, Title as "Title"
	, cast(Price as number) as "Price"
	, AuthorList as "AuthorList"
from 
	XML2TBL
;

/*  TASK 04 */
with XML2TBL as 
	(
	select 
		extractvalue(XB.OBJECT_VALUE, '/book/bk_id') as BookID 
		, extractvalue(XB.OBJECT_VALUE, '/book/bk_title') as Title 
		, extractvalue(XB.OBJECT_VALUE, '/book/bk_price') as Price 
		, extract(XB.OBJECT_VALUE, '/book/bk_authors') as AuthorList
	from 
		xml_A14_books XB
	where
		XB.OBJECT_VALUE.extract('//bk_authors').getStringVal() like '%>Martin<%'
	)
select
	BookID as "BookID"
	, Title as "Title"
	, AuthorList as "AuthorList"
from 
	XML2TBL
;


/*  TASK 05 */
with XML2TBL as 
	(
	select 
		extractvalue(XB.OBJECT_VALUE, '/book/bk_id') as BookID 
		, extractvalue(XB.OBJECT_VALUE, '/book/bk_title') as Title 
		, extractvalue(XB.OBJECT_VALUE, '/book/bk_price') as Price 
		, extract(XB.OBJECT_VALUE, '/book/bk_authors') as AuthorList
	from 
		xml_A14_books XB
	where
		XB.OBJECT_VALUE.extract('//author[1]/text()').getStringVal() = 'Martin'
	)
select
	BookID as "BookID"
	, Title as "Title"
	, AuthorList as "AuthorList"
from 
	XML2TBL
;


/*  TASK 06 */
with XML2TBL as 
	(
	select 
		extractvalue(XB.OBJECT_VALUE, '/book/bk_id') as BookID 
		, extractvalue(XB.OBJECT_VALUE, '/book/bk_title') as Title 
		, extractvalue(XB.OBJECT_VALUE, '/book/bk_price') as Price 
		, extract(XB.OBJECT_VALUE, '/book/bk_authors') as AuthorList
	from 
		xml_A14_books XB
	where
		XB.OBJECT_VALUE.extract('//bk_authors').getStringVal() not like '%>Martin<%'
	)
select
	BookID as "BookID"
	, Title as "Title"
	, AuthorList as "AuthorList"
from 
	XML2TBL
;

/*  TASK 07 */
with XML2TBL as 
	(
	select 
		extractvalue(XB.OBJECT_VALUE, '/book/bk_id') as BookID 
		, extractvalue(XB.OBJECT_VALUE, '/book/bk_title') as Title 
		, extract(XB.OBJECT_VALUE, '/book/bk_authors') as AuthorList
		, (
		  select count(*)
		  from
			table(xmlsequence(extract(XB.OBJECT_VALUE, '/book/bk_authors/author')))
		  ) as NumberOfAuthors
	from 
		xml_A14_books XB
	)
select
	BookID as "BookID"
	, Title as "Title"
from 
	XML2TBL
where
	NumberOfAuthors between 4 and 10
;


/*  TASK 08 */
with XML2TBL as 
	(
	select
		1 as Grouping 
		, extractvalue(XB.OBJECT_VALUE, '/book/bk_id') as BookID 
		, extractvalue(XB.OBJECT_VALUE, '/book/bk_title') as Title 
		, cast(extractvalue(XB.OBJECT_VALUE, '/book/bk_price') as number) as Price 
	from 
		xml_A14_books XB
	)
select
	BookID as "BookID"
	, Title as "Title"
	, Price as "Price"
	, dense_rank() over (partition by Grouping order by nvl(Price, -1) desc) as "PRICERANK"
from 
	XML2TBL
;


/*  TASK 09 */
with XML2TBL as 
	(
	select 
		extractvalue(OBJECT_VALUE, '/book/bk_subject') as Subject
		, cast(extractvalue(OBJECT_VALUE, '/book/bk_price') as number) as Price 
		, extractvalue(XB.OBJECT_VALUE, '/book/bk_id') as BookID 
	from 
		xml_A14_books XB
	)
, TMP as
	(select
		Subject 
		, nvl(avg(Price), 0.00) as AvgPrice
		, count(BookID) as NumberBooks
	from 
		XML2TBL
	group by 
		Subject
	)
(
select
	Subject as "Subject"
	, NumberBooks as "Number Books"
	, to_char(AvgPrice, '9,990.00') as "Avg Price"
from
	TMP
)
union all
(
-- this query is to generate a SUMMARY row
select 
	'SUMMARY' as "Subject"
	, sum(NumberBooks) as "Number Books"
	, to_char(avg(AvgPrice), '9,990.00') as "Avg Price"
from
	TMP
)
;


/*  TASK 10 */
with XML2TBL as 
	(
	select 
		extractvalue(OBJECT_VALUE, '/book/bk_subject') as Subject
		, cast(extractvalue(OBJECT_VALUE, '/book/bk_price') as number) as Price 
		, extractvalue(XB.OBJECT_VALUE, '/book/bk_id') as BookID 
	from 
		xml_A14_books XB
	)
, TMP as 
	(
	select
		Subject 
		, nvl(avg(Price), 0.00) as AvgPrice
	from 
		XML2TBL
	group by
		Subject
	)
select
	  (
	  select 
		to_char(avg(AvgPrice), '999,999,999.99')  
	  from 
		TMP 
	  where 
		Subject = 'SQL'
	  ) as "AvgPrice_SQL"
	, (
	  select 
		to_char(avg(AvgPrice), '999,999,999.99') 
	  from 
		TMP 
	  where 
		Subject != 'SQL'
	  ) as "AvgPrice_Other"
from
	dual
;



spool off