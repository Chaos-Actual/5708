/******************************
*     Lab 3                   *
*     Group:  G8              *
*     Member: Mark McGuire    *
*     X500:   mcgu0156        *
*     Member: Yadu Kiran013   *
*     X500:   Kiran03         *
******************************/

--Part A
--1 
Set AUTOCOMMIT OFF;
	
--2 data is loaded
	
--3 
SELECT VOTES FROM MOVIE WHERE TITLE = 'My Cousin Vinny';	
-- output 66825
--4
UPDATE MOVIE SET VOTES = 90782 WHERE TITLE = 'My Cousin Vinny';

--5
SELECT VOTES FROM MOVIE WHERE TITLE = 'My Cousin Vinny';
-- output 90782

--6 Process Killed

--7 
SELECT VOTES FROM MOVIE WHERE TITLE = 'My Cousin Vinny';
--output 66825

/*The update transaction was still active and had not committed. The record was updated in memory but had not flushed to disk yet.
The record in memory can be accesses and will show the updated result. When the transaction is terminated then the update is lost. 
When the system comes back up, after logging back in, the record is pulled from disk which has the value prior to the update. 
*/


--Part B 
--1
Set AUTOCOMMIT OFF;

--2
UPDATE MOVIE SET VOTES = 90782 WHERE TITLE = 'My Cousin Vinny';

--3
SAVEPOINT S0;

--4 Process Killed

--5 
SELECT VOTES FROM MOVIE WHERE TITLE = 'My Cousin Vinny';
-- output 66825
/*
The update transaction was still active and had not committed. Again, the record was updated in memory and not flushed to disk. 
The savepoint was set but is deleted when a transaction terminates. Savepoints are only used to rollback the transaction that created the savepoint. 
A savepoint is a point in the transaction that can be referenced using a rollback.  
*/


--Part C
--1 
SET AUTOCOMMIT OFF;

--2
SELECT SCORE, VOTES FROM MOVIE WHERE TITLE = 'My Cousin Vinny';
--output score = 7.5, votes = 66825

--3
SAVEPOINT S0;

--4
UPDATE MOVIE SET VOTES = 90782 WHERE TITLE = 'My Cousin Vinny';

--5
SAVEPOINT S1;

--6
UPDATE MOVIE SET SCORE = 9.0;
--9992 rows updated.

--7
SAVEPOINT S2;

--8
SELECT SCORE FROM MOVIE WHERE TITLE = 'My Cousin Vinny';
-- output 9 

--9
ROLLBACK TO S1;
--Rollback complete

--10
SELECT SCORE, VOTES FROM MOVIE WHERE TITLE = 'My Cousin Vinny';
-- output score = 7.5, votes = 90782
--The restoration was successful for score. The score is set to the value that My Cousin Vinny had at the savepoint s1. 
--The votes value did not change because this value was updated before savepoint S1.

--11
ROLLBACK TO S2;
-- output ORA-01086: savepoint 'S2' never established in this session or is invalid
--Oracle does not allow for a transaction to be rolled forward. 

--12
UPDATE MOVIE SET SCORE = 9.0 WHERE TITLE = 'My Cousin Vinny';

--13
COMMIT;

--14
ROLLBACK TO S1;
-- output ORA-01086: savepoint 'S1' never established in this session or is invalid
-- Oracle does not allow this rollback. A savepoint is only available when the transaction is active. 
-- Once a transaction commits or aborts then the savepoints are no longer available. 



-- Part D
--1 Both logged into SQL

--2
Set AUTOCOMMIT OFF;

--3
SELECT SCORE FROM MOVIE WHERE TITLE = 'My Cousin Vinny';
--output 7.5

--4
SELECT SCORE FROM MOVIE WHERE TITLE = 'My Cousin Vinny';
--output 7.5

--5
UPDATE MOVIE SET SCORE = (SELECT MAX(SCORE ) FROM MOVIE) WHERE TITLE = 'My Cousin Vinny';

--6
SELECT SCORE FROM MOVIE WHERE TITLE = 'My Cousin Vinny';
-- output 10

--7
SELECT SCORE FROM MOVIE WHERE TITLE = 'My Cousin Vinny';
-- output 7.5

--8
UPDATE MOVIE SET SCORE = 10 WHERE TITLE = 'My Cousin Vinny';
-- My partner gets 7.5 while I get 10. for step 6 and 7.
-- Step 8 When my partner tries to update the score from My Cousin Vinny it hangs. 
--This is because I have a lock on the record and his process cannot update until I release the lock.

--9
SELECT SCORE FROM MOVIE WHERE TITLE = 'My Cousin Vinny';
--output 7.5 
-- My partner cancels then requires and still sees 7.5. This happens because I have the lock and my partner is reading the value before I wrote to the record.

--10
commit;

--11
SELECT SCORE FROM MOVIE WHERE TITLE = 'My Cousin Vinny';
--output 10. 
-- I commit then he sees the correct score of 10. 

--12
--Oracle uses a 2 phase locking schemes. My process acquires a write lock and does not allow my partner to see my updates until I commit.
-- When I commit the all of the locks that I had are released and other transactions can see my changes. 

--13
Set AUTOCOMMIT OFF;

--14
--reload tables and commit;

--15
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

--16
--REDO STEPS
--3s
SELECT SCORE FROM MOVIE WHERE TITLE = 'My Cousin Vinny';
--output 7.5

--4s
SELECT SCORE FROM MOVIE WHERE TITLE = 'My Cousin Vinny';
--output 7.5

--5s
UPDATE MOVIE SET SCORE = (SELECT MAX(SCORE ) FROM MOVIE) WHERE TITLE = 'My Cousin Vinny';

--6s 
SELECT SCORE FROM MOVIE WHERE TITLE = 'My Cousin Vinny';
--output 10

--7s
SELECT SCORE FROM MOVIE WHERE TITLE = 'My Cousin Vinny';
--output 7.5
-- This is the same result as it was the first time we did this experiment.

--8s
UPDATE MOVIE SET SCORE = (SELECT MAX(SCORE ) FROM MOVIE) WHERE TITLE = 'My Cousin Vinny'; 
-- Again, this process hangs. Same result as before. 

--9s
SELECT SCORE FROM MOVIE WHERE TITLE = 'My Cousin Vinny';
--output 7.5

--10s
COMMIT;

--11s
SELECT SCORE FROM MOVIE WHERE TITLE = 'My Cousin Vinny';
--output 7.5
-- This is different result from before. 
-- 17 and 18
--After I commit my partner still sees the score as 7.5. 
--This is because the serializable transaction level my partner's transaction will read the score as 7.5 until his transaction commits.
-- I can update the score of My Cousin Vinny as much as I want but he will not be able to see any other score.
-- Read committed snapshot reads the score of the last committed transaction. This is the current scheme being used. 
-- Once my partner commits his transaction then he will be able to see the updated score.



--Part E
--1 
Set AUTOCOMMIT OFF;

--2 Drop all tables and reload tables and commit;

--3 
Set AUTOCOMMIT OFF;

--4
SELECT SCORE FROM MOVIE WHERE TITLE = 'My Cousin Vinny';
--output 7.5 

--5
UPDATE MOVIE SET SCORE = 10 WHERE TITLE = 'My Cousin Vinny';
--output 1 row updated.  My partner is allowed to update the score of My Cousin Vinny;

--6 Partner commits
COMMIT:

--7
SELECT * FROM MOVIE WEHRE TITLE = 'My Cousin Vinny' FOR UPDATE OF SCORE NOWAIT;
-- output all columns for movie titled 'My Cousin Vinny'

--8 
UPDATE MOIVE SET SCORE = 7.5 WHERE TITLE = 'My Cousin Vinny';

SELECT * FROM movie WHERE title = 'My Cousin Vinny' FOR UPDATE OF score NOWAIT;
--output the update hangs. 
--My partner is not allowed to update the score. The FOR UPDATE locks records that are being used for the query. 
--The nowait clause tells oracle not to wait if the record has been locked by another transaction.

--9
ROLLBACK;
--output ROLLBACK COMPLETE

--10
LOCK TABLE MOVIE IN EXCLUSIVE MODE;
--output TABLE(S) LOCKED

--11
UPDATE MOVIE SET SCORE = 10 WHERE TITLE = 'My Cousin Vinny';
--output The update hangs.
-- This is expected because my partner has an exclusive lock on the table movie. My transaction must wait until my partner releases the lock on the movie table. 


--part F:
--1
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

--2 
SET AUTOCOMMIT OFF;

--3
SELECT TITLE FROM MOIVE WHERE TITLE LIKE 'K%';
--output 164 rows selected

--4 
SELECT TITLE FROM MOVIE WHERE TITLE LIKE 'K%';
--output 164 rows selected 

--5 
DROP TABLE CASTING;
--output table dropped
DELETE FROM MOVIE WHERE TITLE LIKE 'K%';
--output 164 rows deleted 
INSERT INTO movie(id, title, yr, score, votes, director) VALUES(2632454,'Kingsman: The Secret Service', 2014, 8.2, 84535, 'Matthew Vaughn');
--output 1 row created 

--6
COMMIT;

--7
SELECT TITLE FROM MOVIE WHERE TITLE LIKE 'K%';
--output 'Kingsman: The Secret Service'

--My partner saw the inserted row only. This was different from his first select where he saw all 164 movies that started with K. 
--This is a non-repeatable read at the default isolation level.
--Phantom reads can also occur at this level because I can be inserting and/or updating a record while my partner is querying these same records.
-- This can be prevented in oracle by changing the isolation level to serializable.


--Part G:
/*
1: Oracles CCT is not conservative;
2. oracle cct is strict;
3. Oracle obeys 2-phase locking.
4. Oracle's cct can lead to phantom problems in the default isolation level. We saw this in step 7 of part F.
5. Oracle's default cct can lead to deadlocks because the database does not employ a conservative 2-phase locking strategy.
6. Oracle's CCT cannot lead to a livelock.
7. Oracle's cct default isolation level read committed does not allow dirty reads this means that it is not possible for a cascading rollback. It is possible to set the isolation level to read uncommitted which does allow for dirty reads. In this case it would be possible for oracle to have a cascading rollback.
8. Oracle's cct default isolation level read committed is recoverable. It is possible to set the isolation level to read uncommitted which would allow, dirty reads, and consequently allow schedules to become unrecoverable. 
*/

--Part H:
/*
hive> show databases;
OK
default
Time taken: 5.37 seconds, Fetched: 1 row(s)
hive> show tables;
OK
Time taken: 0.027 seconds
hive> create table employee (id string, name string, dept string) row format delimited fields terminated by
'\t' stored as textfile;
OK
Time taken: 0.822 seconds
hive> show tables;
OK
employee
Time taken: 0.072 seconds, Fetched: 1 row(s)

*/
