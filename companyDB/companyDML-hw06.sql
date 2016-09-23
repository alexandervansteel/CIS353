
-- File: companyDML-b-solution 
-- SQL/DML HOMEWORK (on the COMPANY database)
/*
Every query is worth 2 point. There is no partial credit for a
partially working query - think of this hwk as a large program and each query is a small part of the program.
--
IMPORTANT SPECIFICATIONS
--
(A)
-- Download the script file company.sql and use it to create your COMPANY database.
-- Dowlnoad the file companyDBinstance.pdf; it is provided for your convenience when checking the results of your queries.
(B)
Implement the queries below by ***editing this file*** to include
your name and your SQL code in the indicated places.   
--
(C)
IMPORTANT:
-- Don't use views
-- Don't use inline queries in the FROM clause - see our class notes.
--
(D)
After you have written the SQL code in the appropriate places:
** Run this file (from the command line in sqlplus).
** Print the resulting spooled file (companyDML-b.out) and submit the printout in class on the due date.
--
**** Note: you can use Apex to develop the individual queries. However, you ***MUST*** run this file from the command line as just explained above and then submit a printout of the spooled file. Submitting a printout of the webpage resulting from Apex will *NOT* be accepted.
--
*/
-- Please don't remove the SET ECHO command below.
SPOOL companyDML-b.out
SET ECHO ON
-- ------------------------------------------------------------
-- 
-- Name: < ***** Alexander Vansteel ***** >
--
-- -------------------------------------------------------------
--
-- NULL AND SUBSTRINGS -------------------------------
--
/*(10B)
Find the ssn and last name of every employee whose ssn contains two consecutive 8's, and has a supervisor. Sort the results by ssn.
*/
select 		ssn, lname
from 		employee 
where 		ssn like '%88%' and 
		super_ssn is not null
order by 	ssn;

--
-- JOINING 3 TABLES ------------------------------
-- 
/*(11B)
For every employee who works for more than 20 hours on any project that is controlled by the research department: Find the ssn, project number,  and number of hours. Sort the results by ssn.
*/
select 		e.ssn, p.pnumber, w.hours
from 		employee e, project p, works_on w
where 		e.ssn = w.essn and
		w.hours > 20 and
		w.pno = p.pnumber and
		p.dnum = 5
order by 	e.ssn;

--
-- JOINING 3 TABLES ---------------------------
--
/*(12B)
Write a query that consists of one block only.
For every employee who works less than 10 hours on any project that is controlled by the department he works for: Find the employee's lname, his department number, project number, the number of the department controlling it, and the number of hours he works on that project. Sort the results by lname.
*/
select 		e.lname, e.dno, p.pnumber, p.dnum, w.hours
from 		employee e, project p, works_on w
where 		e.dno = p.dnum and
		p.pnumber = w.pno and
		w.hours < 10
order by 	e.lname;

--
-- JOINING 4 TABLES -------------------------
--
/*(13B)
For every employee who works on any project that is located in Houston: Find the employees ssn and lname, and the names of his/her dependent(s) and their relationship(s) to the employee. Notice that there will be one row per qualyfing dependent. Sort the results by employee lname.
*/
select 		e.ssn, e.lname, d.dependent_name, d.relationship
from 		employee e, project p, works_on w, dependent d
where		e.ssn = w.essn and
		w.pno = p.pnumber and
		p.plocation = 'Houston'  and
		e.ssn = d.essn
order by	e.lname;

--
-- SELF JOIN -------------------------------------------
-- 
/*(14B)
Write a query that consists of one block only.
For every employee who works for a department that is different from his supervisor's department: Find his ssn, lname, department number; and his supervisor's ssn, lname, and department number. Sort the results by ssn.  
*/
select		e1.ssn, e1.lname, e1.dno, e2.ssn, e2.lname, e2.dno
from		employee e1, employee e2
where		e1.super_ssn = e2.ssn and
		e1.dno != e2.dno and
		e1.ssn < e2.ssn
order by	e1.ssn;

--
-- USING MORE THAN ONE RANGE VARIABLE ON ONE TABLE -------------------
--
/*(15B)
Find pairs of employee lname's such that the two employees in the pair work on the same project for the same number of hours. List every pair once only. Sort the result by the lname in the left column in the result. 
*/
select 		e1.lname, e2.lname
from		employee e1, employee e2, works_on w1, works_on w2
where		e1.ssn = w1.essn and
		e2.ssn = w2.essn and
		w1.pno = w2.pno and
		w1.hours = w2.hours and
		e1.ssn < e2.ssn
order by	e1.lname;

--
/*(16B)
For every employee who has more than one dependent: Find the ssn, lname, and number of dependents. Sort the result by lname
*/
select		e.ssn, e.lname, count(d.dependent_name)
from		employee e, dependent d
where		e.ssn = d.essn
group by	e.ssn, e.lname
having 		count(d.dependent_name) > 1
order by	e.lname;

-- 
/*(17B)
For every project that has more than 2 employees working on and the total hours worked on it is less than 40: Find the project number, project name, number of employees working on it, and the total number of hours worked by all employees on that project. Sort the results by project number.
*/
select 		p.pnumber, p.pname, count(w.essn), sum(w.hours)
from		project p, works_on w
where		w.pno = p.pnumber
group by	p.pnumber, p.pname
having		sum(w.hours) < 40 and
		count(w.essn) > 1
order by	p.pnumber;
			 
--
-- CORRELATED SUBQUERY --------------------------------
--
/*(18B)
For every employee whose salary is above the average salary in his department: Find the dno, ssn, lname, and salary. Sort the results by department number.
*/
select		e.dno, e.ssn, e.lname, e.salary
from		employee e
where		salary > (
			select 	avg(e2.salary)
			from 	employee e2
			where	e.dno = e2.dno)
order by	e.dno;

--
-- CORRELATED SUBQUERY -------------------------------
--
/*(19B)
For every employee who works for the research department but does not work on any one project for more than 20 hours: Find the ssn and lname. Sort the results by lname
*/
select		distinct e.ssn, e.lname
from		employee e, department d, project p, works_on w
where		e.dno = d.dnumber and
		d.dname = 'Research' and
		d.dnumber = p.dnum and
		p.pnumber = w.pno and
		w.hours < 20
order by 	e.lname;			

--
-- DIVISION ---------------------------------------------
--
/*(20B) Hint: This is a DIVISION query
For every employee who works on every project that is controlled by department 4: Find the ssn and lname. Sort the results by lname
*/
select 			ssn, lname
from 			employee
where not exists ( (	select pnumber 
			from project 
			where dnum = 4)
                MINUS( 
                	select pno 
                	from works_on 
                	where essn = ssn)
                 );

--
SET ECHO OFF
SPOOL OFF


