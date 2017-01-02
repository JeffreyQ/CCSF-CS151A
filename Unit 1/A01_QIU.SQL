SPOOL A01_QIU.LST


set echo on
set feedback 1
set pagesize 999
set trimspool on
set linesize 200
set tab off
clear columns


/* Jeffrey Qiu */

SELECT 'JEFFREY QIU' AS NAME 
FROM DUAL;

/*  TASK 00 */

select user, sysdate 
from dual;

select * 
from v$version;

/*  TASK 01 */

delete
from zoo_2015
where z_id > 100;

select *
from zoo_2015;

/*  TASK 02  */

Insert Into zoo_2015  (z_id, z_name, z_type, z_cost, z_dob, z_acquired) Values
  (101, 'Tommy', 'Shark', 500.00, to_date('2015-05-15', 'YYYY-MM-DD'), date '2015-05-15');

Insert Into zoo_2015  (z_id, z_name, z_type, z_cost, z_dob, z_acquired) Values
  (102, 'Fan', 'Butterfly', 115.00, to_date('2015-06-15', 'YYYY-MM-DD'), date '2015-06-15');

Insert Into zoo_2015  (z_id, z_name, z_type, z_cost, z_dob, z_acquired) Values
  (103, 'Mask', 'Frog', 310.00, to_date('2015-01-11', 'YYYY-MM-DD'), date '2015-01-16');

/*  TASK 03 */

Insert Into zoo_2015 (z_id, z_name, z_type, z_cost, z_dob, z_acquired) Values 
  (111, 'Buddy', 'Dog', 1500, to_date('2014-03-17', 'YYYY-MM-DD'), date '2015-02-02');

Insert Into zoo_2015 (z_id, z_name, z_type, z_cost, z_dob, z_acquired) Values 
  (222, 'Sophie', 'Cat', 1500, to_date('2015-05-11', 'YYYY-MM-DD'), date '2015-07-17');

Insert Into zoo_2015 (z_id, z_name, z_type, z_cost, z_dob, z_acquired) Values 
  (333, 'Jake', 'Leopard', 23000, to_date('2013-8-18', 'YYYY-MM-DD'), date '2015-03-17');

Insert Into zoo_2015 (z_id, z_name, z_type, z_cost, z_dob, z_acquired) Values
  (325, 'John', 'Elephant', 15000.00, to_date('2012-03-27', 'YYYY-MM-DD'), date '2014-06-28');

Insert Into zoo_2015 (z_id, z_name, z_type, z_cost, z_dob, z_acquired) Values
  (326, 'George', 'Monkey', 9000.00, to_date('2012-05-23', 'YYYY-MM-DD'), date '2014-06-28');

Insert Into zoo_2015 (z_id, z_name, z_type, z_cost, z_dob, z_acquired) Values
  (327, 'Michael', 'Turtle', 200.00, to_date('2011-01-19', 'YYYY-MM-DD'), date '2014-06-28');

commit;

/*  TASK 04 */

select z_id, z_name, z_type, z_cost, z_dob, z_acquired
from zoo_2015;

/*  TASK 05 */

select z_type, z_name, z_cost
from zoo_2015
order by z_type, z_name;

/*  TASK 06 */

select z_id, z_name, z_dob
from zoo_2015
where z_type = 'Zebra'
order by z_dob desc;


/*  TASK 07 */

select tname
from tab;

/*  TASK 08 */

desc zoo_2015

/*  THE END */



SPOOL OFF
