

-- employee info
CREATE TABLE Employee(
eId varchar(10) primary key,
eName varchar(20) not null
);
-- department info
CREATE TABLE Department(
dId varchar(5) primary key,
dName varchar(20) not null unique
);
-- working record 
CREATE TABLE worksIn(
emp varchar(10) references Employee(eId),
dept varchar(5) references Department(dId),
primary key (emp, dept)
);
-- paying record 
CREATE TABLE Payroll(
checkNumber varchar(30) primary key,
emp varchar(10) not null references Employee(eId) ,
year char(4) not null,
amount numeric not null
);
-- for second question
CREATE TABLE train(
origin varchar (45) not null,
destination varchar(45)not null,
cost numeric not null,
primary key(origin, destination)
);


# 1.1 Find the employee who works for at most 2 departments, so 0,1,2 (name)

SELECT worker.eName AS Employee_Name
FROM
	employee worker,
	(   -- employee won't work for same deparment 
		SELECT COUNT(DISTINCT worRec.dept) AS numOfDepOfaPer, worRec.emp
		FROM worksin worRec
		GROUP BY worRec.emp
	) AS wor_db
WHERE worker.eId = wor_db.emp AND wor_db.numOfDepOfaPer <= 2;


-- #1.2 Employee gets the paycheck at three different years or more 
-- (id , name) 

SELECT worker.eId AS Employee_ID , worker.eName AS Employee_Name
FROM
    employee worker,
    (
	    SELECT COUNT(DISTINCT payRec.year) AS numOfDisYeOfaPer, payRec.emp
	    FROM payroll payRec
	    GROUP BY payRec.emp
    ) AS pay_db
WHERE pay_db.emp = worker.eId AND pay_db.numOfDisYeOfaPer > 2;


-- #1.3 Find the income of employee in 2016 (name , income)

SELECT worker.eName AS Employee_Name, inc_db.income AS Employee_income
FROM employee worker 
    LEFT JOIN 
    (
    	SELECT payRec.emp, SUM(payRec.amount) AS income
    	FROM payroll payRec
    	WHERE year = '2016'
    	GROUP BY payRec.emp
    )AS inc_db
ON worker.eId = inc_db.emp;

-- # 1.4 For every department, list the department id and the total number of employees in the
-- department that had total income in 2016 more than the departmental average income of 2016,
-- (department_id, over_avg ）

SELECT _department.dId AS Department_ID, avg_db.overWa AS Number_Of_Over_Avg 
FROM
	department AS _department,
	(
		SELECT SUM(payRec.amount) AS sumAmout,worRec.dept
		FROM payroll AS payRec, worksin AS worRec
		WHERE payRec.emp = worRec.emp AND payRec.year = '2016'
		GROUP BY worRec.dept
	) AS sum_db,
	
    (
		SELECT AVG(payRec.amount) AS avgAmount, COUNT(worRec.emp) AS overWa, worRec.dept
		FROM payroll AS payRec, worksin AS worRec
		WHERE payRec.emp = worRec.emp AND payRec.year = '2016'
		GROUP BY worRec.dept
	) AS avg_db
WHERE sum_db.dept = avg_db.dept AND _department.dId = avg_db.dept AND sum_db.sumAmout > avg_db.avgAmount;


  /* 
     2.1 Find all the stations that reachable from buffalo
   */
WITH RECURSIVE train1 AS ( 
	 SELECT * 
     FROM train 
     WHERE origin = 'BUF'
	UNION ALL 
	 SELECT train.origin, train.destination, train.cost+train1.cost
     FROM train, train1 
     WHERE train.origin = train1.destination
) 
SELECT Destination, MIN(Cost) AS Cost
FROM train1
GROUP BY origin,destination;  
  
  /*
	2.2 What could happen if you run your query on an instance with cycles? and why
	
    Answer:
			The instance with cycles would be rejected by my query if I run my query
            on an instance with cycles, because both of origin and destination are 
            defined as the primary keys, that is, the query will not be allowed to 
            add any duplicate data into the train table by default if the data already
            occur. Therefore, the invalid data such as the instance with cycles will be
            rejected by default and it won't impact the result of my query,
  */
  
