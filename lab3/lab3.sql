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



-- part D
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
-- Step 8 When my partner trys to update the score from My Cousin Vinny it hangs. 
--This is becuase I have a lock on the record and his process cannot update until I release the lock.

--9
SELECT SCORE FROM MOVIE WHERE TITLE = 'My Cousin Vinny';
--output 7.5 
-- My partner  cancels then requries and still sees 7.5. This happens because I have the lock and my partner is reading the value before I wrote to the record.

--10
commit;

--11
SELECT SCORE FROM MOVIE WHERE TITLE = 'My Cousin Vinny';
--output 10. 
-- I commit then he sees the correct score of 10. 

--12
--Oracle uses a 2 phase locking schemes. My process aquires a write lock and does not allow my partner to see my updates until I commit.
-- When I commit the all of the locks that I had are relased and other trasactions can see my changes. 

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
-- Again this process hangs. Same result as before. 

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
--This is because the serializable trasaction level my partner's transaction will read the score as 7.5 until his trasaction commits.
-- I can update the score of My Cousin Vinny as much as i want be he will not be able to see any other score.
-- Read commited snapshot reads the score of the last commited transation. This is the current scheme being used. 
-- Once my partner commits his trasaction then he will be able to see the updated score.

















update movie set score = (select max(score) from movie) where title = 'My Cousin Vinny';




--part e
step 5: My partner is allowed to update the score of My Cousin Vinny;


SELECT * FROM movie WHERE title = 'My Cousin Vinny' FOR UPDATE OF score NOWAIT;

--step 8 My partner is not allowed to update the score. THe FOR UPDATE locks records that are being used for the query. the nowait clause tells oracle not to wait if the recored has been locked by another trasaction.

step 11;
I receive and error ORA-0054;resource busy and acquire with NOWAIT specified or timeout expired. This is expected becuase The nowaite clause is set so my trasaction will not wait for resources that are locked by another trasaction.

--part F:

INSERT INTO movie(id, title, yr, score, votes, director) VALUES(2632454,'Kingsman: The Secret Service', 2014, 8.2, 84535, 'Matthew Vaughn');

step 7; My partner saw the inserted row only. This was different from his first select where he saw all 164 movies that started with K. This is a non-repeatble read at the default isolation level.
Phantom reads can also occur at this level because i can be inserting and/or updating a recored while my partner is querying these records. This can be prevented in oracle by changing the isolation level to serializable.


--Part G:

1: Oracles CCT is not conservative;
2. oracle cct is strict;
3. Oracle obays 2-phase locking.
4. Oracle's cct can lead to phatom problems in the default isolation level. We saw this in step 7 of part F.
5. Oracle's default cct can lead to deadlocks because the database does not employ a conservative 2-phase locking stratigy.
6. Oracle's CCT cannot lead to a livelock.
7. Oracle's cct default isolation level read committed does not allow dirty reads this means that it is not possible for a cascading rollback. It is possible to set the isolation level to read uncommmitted which does allow for dirty reads. In this case it would be possible for oracle to have a cascading rollback.
8. Oracle's cct dedauld isolation level read committed is recoverable. It is possible to set the isolation level to read uncommitted which would allow,dirty reads, and consequently allow schedules to become unrecoverable. 












part D
Ask your partner to re-query the score of ' 'My Cousin Vinny' '. Does your partner see the change by your update ?
Recall that 2 phase locking schemes with read/write locks. Does Oracle follow the 2 phase locking schemes? Which kind of locking does Oracle follow? Explain your observation. 

Next, we examine the effect of a change of transaction isolation level. 

You and your partner re-login to SQL*Plus and ensure that AUTOCOMMIT is OFF.

--step 9 he cancels then requries and still sees 7.5 he can read but I have not commited the changes yet.
-- I commit then he sees the correct score of 10.
--IT releases the locks once the original process commit. When a process commits then it will release all of the locks that it has obtained.

step 16;
after I commit my partner still sees the score as 7.5; This is because the serializable trasaction level my partner's transaction will read the score as 7.5 until his trasaction commits. I can update the score of My Cousin Vinny as much as i want be he will not be able to see any other score.
read commited snapshot reads the score of the last commited transation.  once my partner commits his trasaction then he will be able to see the updated score.








 releases the locks once the original process commit. When a process commits then it will release all of the locks that it has obtained.