/******************************
*     Lab 4                   *
*     Group:  G8              *
*     Member: Mark McGuire    *
*     X500:   mcgu0156        *
*     Member: Yadu Kiran      *
*     X500:   Kiran013        *
******************************/

--Admin
/*
SET LINESIZE 10000;
set pagesize 1000;

/home/mcgu0156/Desktop/5708/5708/lab3/lab2.sql
module load soft/oracle
sqlplus S18C5708G8@o12g/S18C5708G8
sqlplus S18C5708G26@o12g/S18C5708G26
sqlplus S18C5708G27@o12g/S18C5708G27
*/


--Part A

CREATE TABLE movie08 (id INTEGER NOT NULL, title VARCHAR(100), yr DECIMAL(4), score FLOAT,  votes INTEGER, director VARCHAR(100), PRIMARY KEY (id) );

INSERT INTO movie08	SELECT * FROM movie	COMMIT;

SELECT TABLE_NAME, GRANTOR, GRANTEE, PRIVILEGE, GRANTABLE, TABLE_SCHEMA FROM ALL_TAB_PRIVS WHERE GRANTOR= 'S18C5708G8';

REVOKE SELECT ON MOVIE08 FROM S18C5708G27;

-- A
S18C5708G8

-- B
S18C5708G26@o12g/S18C5708G26


-- C
S18C5708G27@o12g/S18C5708G27


--1
CREATE VIEW MOVIE08VW AS SELECT * FROM MOVIE08 WHERE YR = 1955;
GRANT SELECT ON  MOVIE08VW TO S18C5708G27;
--SELECT count(*) FROM S18C5708G8.movie08;

--2
CREATE VIEW MOVIE08VW1965 AS SELECT * FROM MOVIE08 WHERE YR = 1965;
GRANT SELECT ON MOVIE08VW1965 TO PUBLIC;
-- Testing query
--SELECT * FROM S18C5708G8.MOVIE08VW1965;


--3
GRANT SELECT, DELETE , UPDATE (id, title, yr, votes) ON MOVIE08 TO S18C5708G26;
/* Testing queries
UPDATE S18C5708G8.movie08 SET VOTES = 1 WHERE TITLE = 'Crack in the World';
SELECT * FROM  S18C5708G8.movie08  WHERE TITLE = 'Crack in the World';
DELETE FROM S18C5708G8.movie08  WHERE TITLE = 'Crack in the World';
*/

--4
--AS USER A
GRANT SELECT, INSERT ON movie08 TO S18C5708G26 WITH GRANT OPTION;

-- AS USER B
GRANT SELECT, INSERT ON S18C5708G8.movie08 TO S18C5708G27;

-- AS USER A
REVOKE SELECT, INSERT ON MOVIE08 FROM S18C5708G26;

/*User B gets an error for insufficient permissions and User C gets an error for the table does not exist after user a revokes user b's
permission. Both B and C were able to view the table with the correct permissions. This shows that user C losses his permissions when A revokes B.
*/

--5
--AS USER A
GRANT SELECT, INSERT ON movie08 TO S18C5708G26 WITH GRANT OPTION;

--AS USER B
GRANT SELECT, INSERT ON S18C5708G8.movie08 TO S18C5708G27 WITH GRANT OPTION;

--AS USER C
GRANT SELECT, INSERT ON S18C5708G8.movie08 TO S18C5708G26 WITH GRANT OPTION;

--AS USER A
REVOKE SELECT, INSERT ON MOVIE08 FROM S18C5708G26;
--SELECT count(*) FROM S18C5708G8.movie08;
/* After user A revokes the permissions of user B on table MOVIE08 user B cannot access the table and will receive the insufficient privileges error.
This happens because user B no longer has the permission to grant and therefore any user that B granted permission must also have their permissions revoked. */


--6
--AS USER A
GRANT INSERT ON movie08 TO  S18C5708G26;
--AS USER A
GRANT INSERT (title) ON movie08 TO  S18C5708G26;
-- AS USER A
REVOKE INSERT ON movie08 FROM  S18C5708G26;

-- TESTING
INSERT INTO S18C5708G8.movie08 (id , title , yr, score ,  votes, director ) VALUES (99999, 'TEST', 9999, 9999, 999, 'TEST' );
-- ORA-01031: insufficient privileges

INSERT INTO S18C5708G8.movie08 (title ) VALUES ('TEST');
-- ORA-01031: insufficient privileges

/* When user A revokes the INSERT permission all columns that the user B had permissions on will be revoked even if individual columns had permissions.*/

--7
-- AS USER A
GRANT DELETE ON movie08 TO  S18C5708G26 WITH GRANT OPTION;
-- AS USER B
GRANT DELETE on S18C5708G8.movie08 to  S18C5708G27;
-- AS USER A
REVOKE DELETE ON movie08 FROM  S18C5708G26;

--TESTING
-- AS USER B
DELETE FROM S18C5708G8.movie08 WHERE TITLE = '';
-- ORA-01031: insufficient privileges

-- AS USER C
DELETE FROM S18C5708G8.movie08 WHERE TITLE = '';
-- ORA-00942: table or view does not exist
/* Neither user B nor C have the ability to delete from the movie08 table.
This happens because user B no longer has the permission to grant and therefore any user that B granted permission must also have their permissions revoked. */


--8
-- AS USER A
GRANT SELECT ON movie08 TO  S18C5708G26 WITH GRANT OPTION;
-- AS USER B
GRANT SELECT ON S18C5708G8.movie08 TO  S18C5708G27;
--AS USER A
GRANT SELECT ON movie08 TO  S18C5708G27;
-- AS USER A
REVOKE SELECT ON movie08 FROM  S18C5708G26;

--TESTING
--AS USER C
SELECT count(*) FROM S18C5708G8.movie08;
--OUTPUT 9992
/* Both users A and B granted SELECT permissions to user C. When user B had its permissions revoked then the tuple that held
the permissions that it granted to user C was also deleted. This action does not delete the permissions that A granted C.
This allows user C to still have the SELECT permission on table movie08. */



--9
--AS USER A
GRANT SELECT ON movie08 TO  S18C5708G26;
--AS USER B
CREATE VIEW viewXY AS SELECT * FROM S18C5708G8.movie08;
--AS USER A
REVOKE SELECT ON movie08 FROM  S18C5708G26;

--TESTING
SELECT * FROM viewXY;
--ORA-01031: insufficient privileges
/* Once user B's SELECT permissions were revoked on movie08 then all the
views that have movie08 are also revoked. This makes sense because user B could have made a view that selected all rows movie08
and we do not want user B to have SELECT permission on movie08. */


--Part B
--1
@ /home/mcgu0156/Desktop/5708/5708/lab4/city.sql

--2
CREATE TYPE CITY_DESC AS OBJECT (
 CITY_NAME VARCHAR(70), CNTRY_NAME VARCHAR(70), STATUS VARCHAR(50), POP_RANK INTEGER, POP_CLASS VARCHAR(50)
);
/
--OUTPUT Type created.

--3
CREATE TABLE MYCITY (
	ID INTEGER NOT NULL,
	AREA NUMBER(9,2),
	PERIMETER NUMBER(9,2),
	DESCRIPTION CITY_DESC,
	LOCATION SDO_GEOMETRY,
	PRIMARY KEY (id)
   );
/
--OUTPUT Table created
CREATE TABLE CITY (
	ID INTEGER NOT NULL,
	AREA NUMBER(9,2),
	PERIMETER NUMBER(9,2),
	CITY_NAME VARCHAR(70),
	CNTRY_NAME VARCHAR(70),
	STATUS VARCHAR(50),
	POP_RANK INTEGER,
	POP_CLASS VARCHAR(50),
	LOCATION SDO_GEOMETRY,
	PRIMARY KEY (id)
);

--4
INSERT INTO MYCITY (ID, AREA, PERIMETER, DESCRIPTION, LOCATION)
SELECT ID, AREA, PERIMETER, CITY_DESC(CITY_NAME, CNTRY_NAME, STATUS, POP_RANK, POP_CLASS), LOCATION FROM CITY;
--OUTPUT 10 rows created

--5
SELECT C.DESCRIPTION.CITY_NAME FROM MYCITY C WHERE C.DESCRIPTION.POP_RANK < 5;
--OUTPUT 5 rows selected
/*
DESCRIPTION.CITY_NAME
----------------------------------------------------------------------
Winnipeg
Saint Paul
Minneapolis
Milwaukee
Chicago
*/

--6
SELECT SDO_GEOM.SDO_DISTANCE(C1.location, C2.location, 0.5)
FROM city C1, city C2
WHERE C1.CITY_NAME = 'Madison' AND C2.CITY_NAME = 'Minneapolis';

--OUTPUT
/*

SDO_GEOM.SDO_DISTANCE(C1.LOCATION,C2.LOCATION,0.5)
--------------------------------------------------
                                        4.32680234
*/

--7

SELECT C2.CITY_NAME, SDO_GEOM.SDO_DISTANCE(C1.location, C2.location, 0.5) AS DISTANCE
FROM city C1, city C2
WHERE C1.CITY_NAME = 'Chicago' AND  SDO_GEOM.SDO_DISTANCE(C1.location, C2.location, 0.5) = (SELECT MAX(SDO_GEOM.SDO_DISTANCE(C1.location, C3.location, 0.5)) FROM CITY C3);

--OUTPUT
/*

CITY_NAME                                                                DISTANCE
---------------------------------------------------------------------- ----------
Bismarck                                                               14.0515968

*/


--Part C
--1
-- Account Class
CREATE OR REPLACE TYPE account AS OBJECT(
   accountNumber NUMBER,
   balance NUMBER,
   MEMBER FUNCTION getAccountNumber RETURN NUMBER,
   MEMBER FUNCTION getBalance RETURN NUMBER,
   MEMBER PROCEDURE setAccountNumber(newAccountNumber NUMBER),
   MEMBER PROCEDURE setBalance(newBalance NUMBER),
   MEMBER PROCEDURE printAccountInfo
) NOT FINAL NOT INSTANTIABLE;
/
SHOW ERRORS;

-- Account Implementation
CREATE OR REPLACE TYPE BODY account AS
   -- accessors for accountNumber and balance coordinates
   MEMBER FUNCTION getAccountNumber RETURN NUMBER AS
   BEGIN
      RETURN accountNumber;
   END;
   MEMBER FUNCTION getBalance RETURN NUMBER AS
   BEGIN
      RETURN balance;
   END;
   MEMBER PROCEDURE setAccountNumber(newAccountNumber NUMBER) AS
   BEGIN
      accountNumber := newAccountNumber;
   END;
   MEMBER PROCEDURE setBalance(newBalance NUMBER) AS
   BEGIN
      balance := newBalance;
   END;

   -- abstract printAccountInfo method
   MEMBER PROCEDURE printAccountInfo AS
   BEGIN
      NULL;
   END;
END;
/
SHOW ERRORS;

--2
-- Checking Account Class
CREATE OR REPLACE TYPE checkingaccount UNDER account(
   rewardPoints NUMBER,
   CONSTRUCTOR FUNCTION checkingaccount(accountNumber NUMBER, balance NUMBER, rewardPoints NUMBER)
      RETURN SELF AS RESULT,
   MEMBER FUNCTION getRewardPoints RETURN NUMBER,
   MEMBER PROCEDURE setRewardPoints(newRewardPoints NUMBER),
   OVERRIDING MEMBER PROCEDURE printAccountInfo
);
/
SHOW ERRORS;

-- Checking Account Implementation
CREATE OR REPLACE TYPE BODY checkingaccount AS
   -- constructor
   CONSTRUCTOR FUNCTION checkingaccount(accountNumber NUMBER, balance NUMBER, rewardPoints NUMBER)
      RETURN SELF AS RESULT AS
   BEGIN
      SELF.setAccountNumber(accountNumber);
	  SELF.setBalance(balance);
      setRewardPoints(rewardPoints);
      RETURN;
   END;

   -- accessors for reward points
   MEMBER FUNCTION getRewardPoints RETURN NUMBER AS
   BEGIN
      RETURN rewardPoints;
   END;
   MEMBER PROCEDURE setRewardPoints(newRewardPoints NUMBER) AS
   BEGIN
      rewardPoints := newRewardPoints;
   END;

   -- print the account info
   OVERRIDING MEMBER PROCEDURE printAccountInfo AS
   BEGIN
      DBMS_OUTPUT.PUT_LINE('Account Number: ' || SELF.getAccountNumber() || ', Balance: ' || SELF.getBalance() ||
         ', Reward Points: ' || getRewardPoints());
   END;
END;
/
SHOW ERRORS;


--3
-- Savings Account Class
CREATE OR REPLACE TYPE savingsaccount UNDER account(
   interestEarned NUMBER,
   numberOfWithdrawals NUMBER,
   CONSTRUCTOR FUNCTION savingsaccount(accountNumber NUMBER, balance NUMBER, interestEarned NUMBER, numberOfWithdrawals NUMBER)
      RETURN SELF AS RESULT,
   MEMBER FUNCTION getInterestEarned RETURN NUMBER,
   MEMBER FUNCTION getNumberOfWithdrawals RETURN NUMBER,
   MEMBER PROCEDURE setInterestEarned(newInterestEarned NUMBER),
   MEMBER PROCEDURE setNumberOfWithdrawals(newNumberOfWithdrawals NUMBER),
   OVERRIDING MEMBER PROCEDURE printAccountInfo
);
/
SHOW ERRORS;
-- Savings Account Implementation
CREATE OR REPLACE TYPE BODY savingsaccount AS
   -- constructor
   CONSTRUCTOR FUNCTION savingsaccount(accountNumber NUMBER, balance NUMBER, interestEarned NUMBER, numberOfWithdrawals NUMBER)
      RETURN SELF AS RESULT AS
   BEGIN
      SELF.setAccountNumber(accountNumber);
	  SELF.setBalance(balance);
      setInterestEarned(interestEarned);
	  setNumberOfWithdrawals(numberOfWithdrawals);
      RETURN;
   END;

   -- accessors for interestEarned and numberOfWithdrawals
   MEMBER FUNCTION getInterestEarned RETURN NUMBER AS
   BEGIN
      RETURN interestEarned;
   END;
   MEMBER FUNCTION getNumberOfWithdrawals RETURN NUMBER AS
   BEGIN
      RETURN numberOfWithdrawals ;
   END;
   MEMBER PROCEDURE setInterestEarned (newInterestEarned NUMBER) AS
   BEGIN
      interestEarned := newInterestEarned;
   END;
   MEMBER PROCEDURE setNumberOfWithdrawals (newNumberOfWithdrawals NUMBER) AS
   BEGIN
      numberOfWithdrawals := newNumberOfWithdrawals;
   END;

   -- print the account info
   OVERRIDING MEMBER PROCEDURE printAccountInfo AS
   BEGIN
      DBMS_OUTPUT.PUT_LINE('Account Number: ' || SELF.getAccountNumber() || ', Balance: ' || SELF.getBalance() ||
         ', Interest Earned: ' || getInterestEarned() || ', Number of Withdrawals: ' || getNumberOfWithdrawals());
   END;
END;
/
SHOW ERRORS;


--4
SET SERVEROUTPUT ON;

-- Driver
DECLARE
   TYPE accounts IS TABLE OF account;
   scribble accounts;
   i PLS_INTEGER;
BEGIN
   -- create some account instances
   scribble := accounts(checkingaccount(1, 200, 500), savingsaccount(2, 350, 10, 10));

   -- iterate through the list and print accounts polymorphically
   FOR i IN scribble.FIRST..scribble.LAST LOOP
      scribble(i).printAccountInfo();
   END LOOP;
END;
/
SHOW ERRORS;

--OUTPUT
/*
Account Number: 1, Balance: 200, Reward Points: 500
Account Number: 2, Balance: 350, Interest Earned: 10, Number of Withdrawals: 10

PL/SQL procedure successfully completed.
*/

--5
/*Polymorphism is supported. There is an object account class that is a super class. This has a procedural function that is printAccountInfo. This is set to null and is an abstract class. This allows for the child classes to implement their own versions of the printAccountInfo.  In step 4, printAccountInfo is called from both the checking account class and from the savings account class within the same procedure. The output of the call depends on the object it being called on.  At compile time there is no way to determine how the printAccountInfo will behave so it is done at runtime based on the object that is calling it.
*/


--Part D
module load math/matlab
activitySet = csvread('Downloads/kmeans_data1.csv')
scatter(activitySet(:,1),activitySet(:,2))
--1
/*In the scatter1.jpg there are three distinct clusters. One small dense cluster and then two larger less dense clusters. */
--2
/*The k-means does not follow the clusters. This is unexpected becuase the cluseters are clear to see with the human eye.
One of the clusters has three of the k-means while the other two clusters have just one of the k-means.
This is most likly due to the starting poistions of the k-means. */

activitySet = csvread('Downloads/kmeans_data2.csv')
--1
/*There are two dense clusters with two large clusters that are sparesly filled in scatter2.jpg.
These large clusters with a few points in them are the outliers because most
of the points are in the two small clusters. */

--2
/* The outilers impact the results significantly. It would be expected that there would be two kmeans one for each of the dense clusters.
This is not the case. The outliers fool kmeans. One of the outlier clusters get one of the kmeans
while both of the dense clusters get the other kmean group. */

activitySet = csvread('Downloads/kmeans_dataset3.csv')
--1

activitySet = csvread('Downloads/kmeans_data4.csv')
