--Practice--

--aggregate fns
SELECT AVG(PRICE) AS "AVG",SUM(PRICE) AS "SUM" FROM ITEMS;

SELECT SUM(INVENTORY) AS "TOTAL_INVENTORY" FROM INGREDIENTS;

SELECT MAX(DATEADDED) AS "LAST_ITEM_ADDED_ON" FROM ITEMS;

SELECT * FROM ORDERS; --test

SELECT STOREID,SUM(PRICE) FROM ORDERS
GROUP BY STOREID;

--distinct
SELECT COUNT(FOODGROUP) AS "FGINGREDS",COUNT(DISTINCT FOODGROUP) AS "NOFGS" FROM INGREDIENTS;

--mixing aggregates n literals
SELECT 'RESULTS: ' AS " ",COUNT(*) AS "NOINGREDIENTS", COUNT(INVENTORY) AS "COUNTEDINGREDIENTS",SUM(DISTINCT INVENTORY) AS "TOTALINGREDIENTS" FROM INGREDIENTS;

--group aggregation
SELECT STOREID,ORDERNUMBER,SUM(PRICE) FROM ORDERS
GROUP BY STOREID,ORDERNUMBER;

SELECT VENDORID,COUNT(DISTINCT FOODGROUP) FROM INGREDIENTS
GROUP BY VENDORID;

SELECT STOREID,SUM(PRICE),COUNT(*) FROM ORDERS
GROUP BY STOREID
ORDER BY COUNT(*);

SELECT * FROM ORDERS; --test

SELECT VENDORID,FOODGROUP FROM INGREDIENTS
GROUP BY VENDORID,FOODGROUP;

SELECT * FROM ORDERS;

SELECT STOREID,COUNT(*) AS "NO." FROM ORDERS
WHERE MENUITEMID NOT IN ('SODA','WATER')
GROUP BY STOREID;

--sorting groups with order by
SELECT STOREID,SUM(PRICE) AS "SALES",COUNT(*) AS "NO_SOLD" FROM ORDERS
GROUP BY STOREID
ORDER BY NO_SOLD;

--removing groups with having
SELECT STOREID,MAX(LINENUMBER),SUM(PRICE) AS "SALES" FROM ORDERS
GROUP BY STOREID
HAVING SUM(PRICE)>20; 

SELECT SUM(PRICE) AS "SALES" FROM ORDERS
WHERE STOREID='#2STR'; --OR 2nd way below.

SELECT SUM(PRICE) AS "SALES" FROM ORDERS
GROUP BY STOREID
HAVING STOREID='#2STR';

SELECT FOODGROUP,MIN(UNITPRICE) AS "MIN",MAX(UNITPRICE) AS "MAX" FROM INGREDIENTS
GROUP BY FOODGROUP
HAVING FOODGROUP IS NOT NULL AND (COUNT(*)>=2 OR SUM(INVENTORY)>500);


--Exercise-1--

--1
SELECT * FROM INGREDIENTS; --test

SELECT VENDORID FROM VENDORS
WHERE REPLNAME='GRAPE';

--2
SELECT * FROM INGREDIENTS
WHERE FOODGROUP='FRUIT' AND INVENTORY>100;

--3
SELECT INGREDIENTID,UNITPRICE FROM INGREDIENTS
WHERE VENDORID='VGRUS'
ORDER BY UNITPRICE ASC;

--4
SELECT MAX(DATEADDED) FROM ITEMS;

SELECT * FROM ITEMS; --test

--5
SELECT REFERREDBY,COUNT(VENDORID) AS "NO_REFERRED" FROM VENDORS
GROUP BY REFERREDBY
HAVING COUNT(*)>1;

SELECT * FROM VENDORS;

--Exercise-2--

--1
SELECT AVG(SALARY) FROM EMPLOYEES;

--2
SELECT DEPTCODE,AVG(SALARY) FROM EMPLOYEES
GROUP BY DEPTCODE;

--3
SELECT MIN(REVENUE) AS "MIN_R",MAX(REVENUE) AS "MAX_R" FROM PROJECTS
WHERE (ENDDATE IS NULL OR ENDDATE>GETDATE()) AND REVENUE>0;

SELECT * FROM PROJECTS;

--4
SELECT * FROM WORKSON;

SELECT COUNT(*) FROM WORKSON
WHERE EMPLOYEEID IS NOT NULL;

--5
SELECT MAX(LASTNAME) FROM EMPLOYEES;

--6
SELECT STDEV(SALARY) AS "STD_DEV_SALARY" FROM EMPLOYEES;

--7
SELECT COUNT(DEPTCODE) FROM EMPLOYEES;

--8
SELECT DEPTCODE,COUNT(EMPLOYEEID) FROM EMPLOYEES
GROUP BY DEPTCODE;

--9
SELECT DEPTCODE,AVG(REVENUE),COUNT(PROJECTID) FROM PROJECTS
WHERE PROJECTID IS NOT NULL
GROUP BY DEPTCODE; --or

SELECT COUNT(PROJECTID),DEPTCODE,AVG(REVENUE) FROM PROJECTS
GROUP BY DEPTCODE HAVING COUNT(DEPTCODE)>0;

--10
SELECT * FROM WORKSON;

SELECT EMPLOYEEID,SUM(ASSIGNEDTIME) FROM WORKSON
GROUP BY EMPLOYEEID
HAVING SUM(ASSIGNEDTIME)>=1;

--11
SELECT DEPTCODE,SUM(SALARY*1.10) AS "SALARY_COST" FROM EMPLOYEES
WHERE NOT LASTNAME LIKE '%RE'
GROUP BY DEPTCODE;

--Practice--
SELECT VENDORS.VENDORID,NAME,COMPANYNAME FROM INGREDIENTS,VENDORS
WHERE INGREDIENTS.VENDORID=VENDORS.VENDORID;

SELECT NAME FROM INGREDIENTS,VENDORS
WHERE INGREDIENTS.VENDORID=VENDORS.VENDORID AND
	  COMPANYNAME='VEGGIES_R_US';

SELECT V1.COMPANYNAME FROM VENDORS V1,VENDORS V2
WHERE V1.REFERREDBY=V2.VENDORID AND V2.COMPANYNAME='VEGGIES_R_US';

SELECT * FROM MADEWITH;
SELECT * FROM INGREDIENTS;

SELECT ITEMS.NAME,INGREDIENTS.NAME FROM ITEMS,MADEWITH,INGREDIENTS
WHERE ITEMS.ITEMID=MADEWITH.ITEMID AND MADEWITH.INGREDIENTID=INGREDIENTS.INGREDIENTID
AND (QUANTITY*3)>INVENTORY;

SELECT I1.NAME FROM ITEMS I1,ITEMS I2
WHERE I1.PRICE>I2.PRICE AND I2.NAME='GARDEN SALAD';

--join operators
SELECT NAME FROM INGREDIENTS I INNER JOIN VENDORS V ON I.VENDORID=V.VENDORID
WHERE V.COMPANYNAME='VEGGIES_R_US';

SELECT I1.NAME FROM ITEMS I1 INNER JOIN ITEMS I2 ON I1.PRICE>I2.PRICE
WHERE I2.NAME='GARDEN SALAD';

SELECT DISTINCT I.NAME FROM ITEMS I JOIN MADEWITH MW ON I.ITEMID=MW.ITEMID 
JOIN INGREDIENTS ING ON MW.INGREDIENTID=ING.INGREDIENTID 
JOIN VENDORS V ON ING.VENDORID=V.VENDORID
WHERE COMPANYNAME='VEGGIES_R_US';

SELECT I.NAME,I.VENDORID,COMPANYNAME FROM INGREDIENTS I FULL JOIN VENDORS V ON I.VENDORID=V.VENDORID;

SELECT COMPANYNAME FROM VENDORS V LEFT JOIN INGREDIENTS I ON V.VENDORID=I.VENDORID
WHERE INGREDIENTID IS NULL;

SELECT I.NAME,COMPANYNAME FROM INGREDIENTS I CROSS JOIN VENDORS V
ORDER BY V.VENDORID; --or

SELECT I.NAME,COMPANYNAME FROM INGREDIENTS I,VENDORS V
ORDER BY V.VENDORID;

--Exercise 3--
--1
SELECT FIRSTNAME+' '+LASTNAME AS "NAME" FROM EMPLOYEES E,DEPARTMENTS D
WHERE E.DEPTCODE=D.CODE AND D.NAME='CONSULTING';

SELECT FIRSTNAME+' '+LASTNAME AS "NAME" FROM EMPLOYEES E CROSS JOIN DEPARTMENTS D
WHERE E.DEPTCODE=D.CODE AND D.NAME='CONSULTING';

--2
SELECT FIRSTNAME+' '+LASTNAME AS "NAME" FROM EMPLOYEES E,WORKSON W,DEPARTMENTS D
WHERE E.DEPTCODE=D.CODE AND E.EMPLOYEEID=W.EMPLOYEEID AND
D.NAME='CONSULTING' AND W.PROJECTID='ADT4MFIA' AND (W.ASSIGNEDTIME/(SELECT SUM(ASSIGNEDTIME) FROM WORKSON
																	WHERE EMPLOYEEID=E.EMPLOYEEID))*100>20;
SELECT FIRSTNAME+' '+LASTNAME AS "NAME" FROM EMPLOYEES E JOIN WORKSON W ON E.EMPLOYEEID=W.EMPLOYEEID JOIN DEPARTMENTS D ON E.DEPTCODE=D.CODE
WHERE
D.NAME='CONSULTING' AND W.PROJECTID='ADT4MFIA' AND (W.ASSIGNEDTIME/(SELECT SUM(ASSIGNEDTIME) FROM WORKSON
																	WHERE EMPLOYEEID=E.EMPLOYEEID))*100>20;
--3
SELECT (SATIME.SAT/ TOTALASSIGN.TOTAL)*100 AS PERCENTAGE FROM
(SELECT SUM(ASSIGNEDTIME)AS TOTAL FROM WORKSON) TOTALASSIGN,
(SELECT SUM(ASSIGNEDTIME) AS SAT FROM WORKSON W, EMPLOYEES E
WHERE W.EMPLOYEEID=E.EMPLOYEEID AND E.FIRSTNAME='Abe' AND
E.LASTNAME='Advice' GROUP BY W.EMPLOYEEID) SATIME;

SELECT (SATIME.SAT/ TOTALASSIGN.TOTAL)*100 AS PERCENTAGE FROM
(SELECT SUM(ASSIGNEDTIME)AS TOTAL FROM WORKSON) TOTALASSIGN,
(SELECT SUM(ASSIGNEDTIME) AS SAT FROM WORKSON W JOIN
EMPLOYEES E ON E.EMPLOYEEID = W.EMPLOYEEID WHERE
E.FIRSTNAME='Abe' AND E.LASTNAME='Advice' GROUP BY
W.EMPLOYEEID) SATIME;

--4
SELECT DISTINCT DESCRIPTION FROM PROJECTS P,
(SELECT P.PROJECTID,W.EMPLOYEEID,ASSIGNEDTIME AS "PROJ_AT" FROM WORKSON W,PROJECTS P
WHERE P.PROJECTID=W.PROJECTID) T1,
(SELECT EMPLOYEEID,SUM(ASSIGNEDTIME) AS "EMP_AT" FROM WORKSON
GROUP BY EMPLOYEEID) T2
WHERE P.PROJECTID=T1.PROJECTID AND T1.EMPLOYEEID=T2.EMPLOYEEID
AND (T1.PROJ_AT/T2.EMP_AT)*100>70;

--5
SELECT E.EMPLOYEEID,
COUNT(W.PROJECTID) AS "NUMBER OF PROJECTS",
SUM(ASSIGNEDTIME)*100 AS "TOTAL PERCENTAGE OF TIME"
FROM EMPLOYEES E LEFT JOIN WORKSON W ON
E.EMPLOYEEID=W.EMPLOYEEID JOIN PROJECTS P ON
W.PROJECTID=P.PROJECTID WHERE P.ENDDATE >GETDATE() OR
P.ENDDATE IS NULL GROUP BY E.EMPLOYEEID; 

--6
SELECT DESCRIPTION FROM PROJECTS P,WORKSON W
WHERE P.PROJECTID=W.PROJECTID AND W.EMPLOYEEID IS NULL;

--7
SELECT PROJECTID,SUM(ASSIGNEDTIME) FROM EMPLOYEES E,WORKSON W
WHERE W.EMPLOYEEID=E.EMPLOYEEID
GROUP BY W.PROJECTID;

--8
SELECT E1.EMPLOYEEID,E2.LASTNAME FROM EMPLOYEES E1,EMPLOYEES E2
WHERE E2.SALARY>E1.SALARY;

SELECT PRICE FROM ITEMS
UNION
SELECT UNITPRICE FROM INGREDIENTS;

SELECT name, price FROM items    
UNION    
SELECT m.name, SUM(quantity * price * (1.0 - discount)) FROM meals m, partof p, items i    WHERE m.mealid = p.mealid AND p.itemid = i.itemid 
GROUP BY m.mealid, m.name;

SELECT MW.ITEMID FROM MADEWITH MW JOIN INGREDIENTS I ON MW.INGREDIENTID=I.INGREDIENTID
WHERE FOODGROUP='FRUIT'
INTERSECT
SELECT MW.ITEMID FROM MADEWITH MW JOIN INGREDIENTS I ON MW.INGREDIENTID=I.INGREDIENTID
WHERE FOODGROUP='VEGETABLE';

SELECT ITEMID FROM ITEMS
EXCEPT
SELECT MW.ITEMID FROM MADEWITH MW JOIN INGREDIENTS I ON MW.INGREDIENTID=I.INGREDIENTID
WHERE I.NAME='CHEESE';

SELECT foodgroup FROM madewith m, ingredients i    
WHERE m.ingredientid = i.ingredientid AND m.itemid = 'FRPLT'    
EXCEPT    
SELECT foodgroup FROM madewith m, ingredients i    
WHERE m.ingredientid = i.ingredientid AND m.itemid = 'FRTSD';

SELECT COMPANYNAME FROM VENDORS V LEFT JOIN INGREDIENTS I
WHERE V.VENDORID=I.VENDORID 
AND I.INGREDIENTID IS NULL; --or

SELECT COMPANYNAME FROM VENDORS
EXCEPT
SELECT COMPANYNAME FROM VENDORS V JOIN INGREDIENTS I ON V.VENDORID=I.VENDORID;

--Exercise 4--
--1
SELECT STARTDATE AS "DATES" FROM PROJECTS
WHERE STARTDATE IS NOT NULL
UNION 
SELECT ENDDATE AS "DATES" FROM PROJECTS
WHERE ENDDATE IS NOT NULL
ORDER BY DATES DESC;

--2
SELECT FOODGROUP FROM INGREDIENTS
EXCEPT
SELECT FOODGROUP FROM INGREDIENTS WHERE NAME ='Grape' GROUP BY
FOODGROUP HAVING FOODGROUP IS NOT NULL;

--3
SELECT FIRSTNAME,LASTNAME FROM EMPLOYEES E,WORKSON W,PROJECTS P
WHERE E.EMPLOYEEID=W.EMPLOYEEID AND W.PROJECTID=P.PROJECTID AND 
P.DESCRIPTION='ROBOTIC SPOUSE'
INTERSECT
SELECT FIRSTNAME,LASTNAME FROM EMPLOYEES E,DEPARTMENTS D
WHERE E.DEPTCODE=D.CODE AND 
D.NAME='HARDWARE';

--4
SELECT FIRSTNAME,LASTNAME FROM EMPLOYEES E,WORKSON W,PROJECTS P
WHERE E.EMPLOYEEID=W.EMPLOYEEID AND W.PROJECTID=P.PROJECTID AND 
P.DESCRIPTION='ROBOTIC SPOUSE'
INTERSECT
SELECT FIRSTNAME,LASTNAME FROM EMPLOYEES E,DEPARTMENTS D
WHERE E.DEPTCODE=D.CODE AND 
NOT D.NAME='HARDWARE';

SELECT FIRSTNAME, LASTNAME FROM EMPLOYEES INNER JOIN WORKSON
ON EMPLOYEES.EMPLOYEEID=WORKSON.EMPLOYEEID INNER JOIN
projects ps ON ps.projectid = workson.projectid AND
ps.description ='Robotic Spouse'
EXCEPT
SELECT FIRSTNAME,LASTNAME FROM EMPLOYEES WHERE
DEPTCODE='HDWRE';--5SELECT FIRSTNAME,LASTNAME FROM EMPLOYEES E,WORKSON W,PROJECTS P
WHERE E.EMPLOYEEID=W.EMPLOYEEID AND W.PROJECTID=P.PROJECTID AND 
P.DESCRIPTION='DWONLOAD CLIENT'
EXCEPT
SELECT FIRSTNAME,LASTNAME FROM EMPLOYEES E,WORKSON W,PROJECTS P
WHERE E.EMPLOYEEID=W.EMPLOYEEID AND W.PROJECTID=P.PROJECTID AND 
P.DESCRIPTION='ROBOTIC SPOUSE';--6SELECT FIRSTNAME,LASTNAME FROM EMPLOYEES E,WORKSON W,PROJECTS P
WHERE E.EMPLOYEEID=W.EMPLOYEEID AND W.PROJECTID=P.PROJECTID AND 
P.DESCRIPTION='DWONLOAD CLIENT'
INTERSECT
SELECT FIRSTNAME,LASTNAME FROM EMPLOYEES E,WORKSON W,PROJECTS P
WHERE E.EMPLOYEEID=W.EMPLOYEEID AND W.PROJECTID=P.PROJECTID AND 
P.DESCRIPTION='ROBOTIC SPOUSE';

--7
SELECT FIRSTNAME,LASTNAME FROM EMPLOYEES E,WORKSON W,PROJECTS P
WHERE E.EMPLOYEEID=W.EMPLOYEEID AND W.PROJECTID=P.PROJECTID AND 
P.DESCRIPTION='DWONLOAD CLIENT'
UNION
SELECT FIRSTNAME,LASTNAME FROM EMPLOYEES E,WORKSON W,PROJECTS P
WHERE E.EMPLOYEEID=W.EMPLOYEEID AND W.PROJECTID=P.PROJECTID AND 
P.DESCRIPTION='ROBOTIC SPOUSE';

--8
SELECT FIRSTNAME,LASTNAME FROM EMPLOYEES E,WORKSON W,PROJECTS P
WHERE E.EMPLOYEEID=W.EMPLOYEEID AND W.PROJECTID=P.PROJECTID AND 
P.DESCRIPTION='DWONLOAD CLIENT'
UNION
SELECT FIRSTNAME,LASTNAME FROM EMPLOYEES E,WORKSON W,PROJECTS P
WHERE E.EMPLOYEEID=W.EMPLOYEEID AND W.PROJECTID=P.PROJECTID AND 
P.DESCRIPTION='ROBOTIC SPOUSE'
EXCEPT
SELECT FIRSTNAME,LASTNAME FROM EMPLOYEES E,WORKSON W,PROJECTS P
WHERE E.EMPLOYEEID=W.EMPLOYEEID AND W.PROJECTID=P.PROJECTID AND 
P.DESCRIPTION='DWONLOAD CLIENT'
INTERSECT
SELECT FIRSTNAME,LASTNAME FROM EMPLOYEES E,WORKSON W,PROJECTS P
WHERE E.EMPLOYEEID=W.EMPLOYEEID AND W.PROJECTID=P.PROJECTID AND 
P.DESCRIPTION='ROBOTIC SPOUSE';

--9
SELECT DISTINCT NAME FROM DEPARTMENTS
EXCEPT
SELECT DISTINCT NAME FROM DEPARTMENTS D,PROJECTS P
WHERE P.DEPTCODE=D.CODE AND P.PROJECTID IS NOT NULL;
