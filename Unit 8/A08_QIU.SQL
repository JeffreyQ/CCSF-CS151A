spool A08_QIU.LST


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
-- for animal id 16003
select 
	count(EX_ID) as NumberOfExams
	, nvl(sum(TotalFeesPerExam), 0.0) as TotalFees
from
	(
	select	
		EXH.AN_ID
		, EXH.EX_ID
		, nvl(sum(EXD.EX_FEE), 0.0) as TotalFeesPerExam
	from
		VT_EXAM_HEADERS EXH 
		join VT_EXAM_DETAILS EXD on (EXH.EX_ID = EXD.EX_ID)
	where
		EXH.AN_ID = 16003
	group by
		EXH.AN_ID	
		, EXH.EX_ID
	)
; 	

-- for animal id 21205 
select 
	count(EX_ID) as NumberOfExams
	, nvl(sum(TotalFeesPerExam), 0.0) as TotalFees
from
	(
	select	
		EXH.AN_ID
		, EXH.EX_ID
		, nvl(sum(EXD.EX_FEE), 0.0) as TotalFeesPerExam
	from
		VT_EXAM_HEADERS EXH 
		join VT_EXAM_DETAILS EXD on (EXH.EX_ID = EXD.EX_ID)
	where
		EXH.AN_ID = 21205
	group by
		EXH.AN_ID	
		, EXH.EX_ID
	)
; 	

/*  TASK 02  */
select
	count(EXH.EX_ID) as NumberOfExams
from
	VT_ANIMALS ANI
	join VT_EXAM_HEADERS EXH on (ANI.AN_ID = EXH.AN_ID) 
where
	ANI.AN_TYPE in ('hamster', 'capybara', 'porcupine', 'dormouse')
	and extract(year from EXH.EX_DATE) = extract(year from sysdate) - 1
;

/*  TASK 03 */
select
	CL_ID as "Client ID"
	, CL_NAME_LAST as "Client Name"
	, count(AN_ID) as "Number of Animals"
	, count(decode(AN_TYPE, 'hamster', 1, 'capybara', 1, 'porcupine', 1, 'dormouse', 1, NULL)) as "Number of Rodents"
from
	VT_CLIENTS CLI
	join VT_ANIMALS using (CL_ID)
group by
	CL_ID, CL_NAME_LAST
order by 
	CL_ID
;

/*  TASK 04 */
select
	sum(NumberofExams) as "Number of Exams"
	, count(AnimalwithExam) as "Number of Animals with Exams"
from
	(
	select
		AN_ID as AnimalwithExam	
		, count(EX_ID) as NumberofExams
	from
		VT_EXAM_HEADERS 
	where
		trunc(EX_DATE, 'Q') = add_months(trunc(sysdate, 'Q'), -3) 
	group by	
		AN_ID
	)
;

/*  TASK 05 */
with DataSource as
(
select 
	CL_ID
	, CL_NAME_LAST
	, sum(TotalFeePerAnimal) as TotalFee
from 
	(
	select 
		CL_ID
		, CL_NAME_LAST
		, AN_ID
		, nvl(sum(EX_FEE), 0.0) as TotalFeePerAnimal 
	from 
		VT_CLIENTS
		join VT_ANIMALS using (CL_ID)
		join VT_EXAM_HEADERS using (AN_ID)
		join VT_EXAM_DETAILS using (EX_ID)
	group by
		CL_ID
		, CL_NAME_LAST
		, AN_ID
	)
group by
	CL_ID
	, CL_NAME_LAST 
)
select 
	CL_ID
	, CL_NAME_LAST
from
	DataSource
where
	TotalFee = 
	(
	select 
		max(TotalFee)
	from 
		DataSource
	)
;


/*  TASK 06 */
select
	count(case when AN_TYPE = 'cat' then 1 end) as "Cats"
	, count(case when AN_TYPE = 'dog' then 1 end) as "Dogs"
	, count(case when AN_TYPE = 'hamster' or AN_TYPE = 'capybara' or AN_TYPE = 'porcupine' or AN_TYPE = 'dormouse' then 1 end) as "Rodents"
	, count(case when AN_TYPE = 'snake' or AN_TYPE = 'chelonian' or AN_TYPE = 'crocodilian' or AN_TYPE = 'lizard' then 1 end) as "Reptiles"
	, count(1) as "All Animals"
from
	VT_ANIMALS	
;

/*  TASK 07 */
with AnimalPossessions as
(
select
	CL_ID
	, CL_NAME_LAST
	, count(AN_ID) as NumberOfAnimals
from
	VT_CLIENTS CLI
	join VT_ANIMALS ANI using (CL_ID)
group by
	CL_ID
	, CL_NAME_LAST
)
select 
	CL_ID
	, CL_NAME_LAST
from
	AnimalPossessions
where
	NumberOfAnimals = 1
;

/*  TASK 08 */
with AnimalExams as
(
select
	AN_ID as AnimalID
	, to_char(max(EX_DATE), 'yyyy/mm/dd') as MostRecent
from
	VT_EXAM_HEADERS
group by
	AN_ID
)
select 
	AN_ID as "AnimalID" 
	, AN_TYPE
	, AN_NAME
	, nvl(MostRecent, 'No Exams') as "MostRecent"
from
	VT_ANIMALS ANI 
	left outer join	AnimalExams ANE on (ANI.AN_ID = ANE.AnimalID)
order by
	AN_ID
;

/*  TASK 09 */
column an_name format a15;
column an_type format a15;
column cl_id format 999999;
column an_id format 999999;

with AnimalExamFee as
(
select 
	AN_ID
	, nvl(sum(EX_FEE), 0.0) as TotalFee 
from 
	VT_ANIMALS 
	join VT_EXAM_HEADERS using (AN_ID)
	join VT_EXAM_DETAILS using (EX_ID)
group by
	AN_ID
)
select
	ANI.AN_ID
	, ANI.AN_TYPE
	, ANI.AN_NAME
	, CLI.CL_ID
	, CLI.CL_PHONE
from
	VT_ANIMALS ANI 
	join AnimalExamFee AEF on (ANI.AN_ID = AEF.AN_ID)
	join VT_CLIENTS CLI on (ANI.CL_ID = CLI.CL_ID)
where
	AEF.TotalFee > 150
	and ANI.AN_ID not in
		(
		select 
			AN_ID
		from
			VT_EXAM_HEADERS
		where
			to_char(EX_DATE, 'yyyy') = to_char(sysdate, 'yyyy')
		)  
;


/*  THE END */



spool off




