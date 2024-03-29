
/******************************
*     Lab 1                   *
*     Group:  G8              *
*     Member: Mark McGuire    *
*     X500:   mcgu0156        *
*     Member: Yadu Kiran013   *
*     X500:   Kiran03         *
******************************/



/* Part A */
/* The script works correctly. The examples and instructions are correct. */


/* Part B */

/* This section was straightforward and had no errors. */
--1)
  --1.
      SELECT UNIQUE NAME FROM COUNTRY WHERE NAME LIKE 'C%' OR NAME LIKE 'D%' FETCH FIRST 10 ROWS ONLY;
  --2.
      SELECT NAME FROM COUNTRY WHERE GDP > .15 AND YEAR = '2011' FETCH FIRST 10 ROWS ONLY;
  --3.
      SELECT UNIQUE REGION FROM COUNTRY FETCH FIRST 10 ROWS ONLY;
  --4.
      SELECT NAME FROM COUNTRY WHERE POPULATION < 1000000 AND YEAR = '2011' FETCH FIRST 10 ROWS ONLY;
  --5.
      SELECT NAME FROM COUNTRY WHERE REGION = 'Europe' AND AREA > 100000 AND YEAR = '2005' ORDER BY GDP DESC FETCH FIRST 10 ROWS ONLY;


/* The second question could be worded better. It should read “For each year” not “For all the year”.*/
--2)
  --1.
      SELECT COUNT (NAME) FROM COUNTRY WHERE GDP > .15 AND YEAR = '2005' FETCH FIRST 10 ROWS ONLY;
  --2.
      SELECT YEAR , COUNT(NAME) AS NUMBER_COUNTRIES, SUM(POPULATION) AS TOTAL_POPULATION, ( (SUM(POPULATION) ) / (COUNT(NAME) ) ) AS AVE_POPULATION , SUM(GDP) AS TOTAL_GDP FROM COUNTRY WHERE REGION = 'Europe' GROUP BY REGION, YEAR ORDER BY YEAR DESC FETCH FIRST 10 ROWS ONLY;
  --3.
      SELECT A.REGION FROM COUNTRY A WHERE A.YEAR = '2005' GROUP BY A.REGION HAVING COUNT(*) > 4 AND SUM(A.POPULATION) > 45000000 FETCH FIRST 10 ROWS ONLY;
  --4.
      SELECT YEAR , SUM ((POPULATION /AREA )) AS DENSITY FROM COUNTRY WHERE REGION = 'Europe' GROUP BY YEAR  ORDER BY YEAR DESC FETCH FIRST 10 ROWS ONLY;


/* The first question was slightly confusing as to what approve was needed to solve. It would be helpful to have a hint to use a group by clause. */
--3)
  --1.
      SELECT A.REGION , SUM(A.AREA) AS TOTAL_AREA FROM COUNTRY A WHERE A.YEAR = '2002' GROUP BY A.REGION HAVING SUM(A.AREA) > (SELECT SUM(B.AREA) FROM COUNTRY B WHERE B.YEAR = '2002' AND B.REGION = 'Middle East') FETCH FIRST 10 ROWS ONLY;
  --2..
      SELECT A.REGION, SUM(A.POPULATION) AS REGION_POPULATION FROM COUNTRY A GROUP BY A.REGION ORDER BY SUM(A.POPULATION) ASC FETCH FIRST 1 ROWS ONLY ;
  --3.
      SELECT A.NAME FROM COUNTRY A WHERE A.YEAR = '2006' AND A.REGION = 'Europe' AND A.POPULATION > (SELECT B.POPULATION FROM COUNTRY B WHERE A.YEAR = B.YEAR AND B.NAME = 'Spain') FETCH FIRST 10 ROWS ONLY;
  --4.
      SELECT A.NAME FROM COUNTRY A WHERE A.YEAR ='2008' AND A.AREA NOT IN (SELECT B.AREA FROM COUNTRY B , COUNTRY C WHERE B.YEAR = C.YEAR AND B.YEAR = '2008' AND B.AREA > C.AREA) FETCH FIRST 10 ROWS ONLY;


/* The fourth question needs to have a statement that says it needs two statements. One statement to update the China records and another to delete the Hong Kong records.  */
--4)
  --1.
      DELETE FROM COUNTRY WHERE GDP = 0;
  --2.
      UPDATE COUNTRY SET AREA = 35000 WHERE NAME = 'Belgium';
  --3.
      UPDATE COUNTRY SET AREA = (AREA * 1.3) WHERE NAME = 'Peru';
  --4..
      UPDATE COUNTRY A SET  A.POPULATION = (A.POPULATION + (SELECT B.POPULATION FROM COUNTRY B WHERE B.NAME = 'Hong Kong' AND A.YEAR = B.YEAR)),
      A.AREA = (A.AREA + (SELECT B.AREA FROM COUNTRY B WHERE B.NAME = 'Hong Kong' AND A.YEAR = B.YEAR )),
      A.GDP = (A.GDP + (SELECT B.GDP FROM COUNTRY B WHERE B.NAME = 'Hong Kong' AND A.YEAR = B.YEAR))
      WHERE A.NAME = 'China' AND YEAR > 1997;
      DELETE FROM COUNTRY WHERE NAME = 'Hong Kong' AND YEAR > 1997;

/* The first question should read “Which kind of index would you like to use?”.
 * This question has a part that requires a written statement. It is unclear how these answers should be turned in.  */
--5)
  --1.
      CREATE INDEX POPULATION_RANGE ON COUNTRY (AREA);
-- Written answer: The index that I would like to use is a B+ tree. The index that has been created on area has an INDEX_TYPE of NORMAL which is by default is a B+ Tree.
  --2.
     CREATE INDEX POP_INDEX ON COUNTRY (POPULATION);
  --3.
     CREATE VIEW COUNTRY_VIEW AS SELECT REGION, POPULATION, AREA FROM COUNTRY;

/* Part C */
/* It is unclear how the written answers should be turned in.
 * Should we turn it in in a SQL file or should we just write the statements in Word? */
--1)
  --1.
      SELECT TABLE_NAME , TABLESPACE_NAME, STATUS FROM USER_TABLES FETCH FIRST 10 ROWS ONLY;
--Written answer: Table spaces can have more than one table but a table can only be a part of one tablespace. 
  --2.
      SELECT COMMENTS FROM ALL_TAB_COMMENTS WHERE COMMENTS IS NOT NULL FETCH FIRST 10 ROWS ONLY;
  --3.
      ANALYZE TABLE COUNTRY COMPUTE STATISTICS;
  --4.
      SELECT VIEW_NAME, TEXT_VC FROM USER_VIEWS FETCH FIRST 10 ROWS ONLY;
  --5.
      SELECT NUM_ROWS, BLOCKS, AVG_ROW_LEN, LAST_ANALYZED, DEPENDENCIES  FROM USER_TABLES FETCH FIRST 10 ROWS ONLY;
  --6.
      SELECT INDEX_NAME, INDEX_TYPE FROM USER_INDEXES FETCH FIRST 10 ROWS ONLY;
  --7.
      SELECT NUM_DISTINCT, NUM_NULLS, DENSITY, LOW_VALUE, HIGH_VALUE FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'COUNTRY' FETCH FIRST 10 ROWS ONLY;
  --8.
      SELECT INDEX_NAME, TABLE_NAME, COLUMN_NAME FROM USER_IND_COLUMNS FETCH FIRST 10 ROWS ONLY;
  --9.
      SELECT INDEX_NAME FROM USER_INDEXES FETCH FIRST 10 ROWS ONLY;
  --10.
      SELECT TABLE_NAME, TABLE_TYPE FROM USER_CATALOG FETCH FIRST 10 ROWS ONLY;
  --11. Written Answer: The coutry.sql script does not have any statements to create an index. Oracle created an index on column NAME because NAME is a primary key for the table country. The system also created an index on the column YEAR beacuse YEAR is also part of the primary key for the table COUNTRY;
  --12.
      SELECT A.LEAF_BLOCKS, A.INDEX_NAME, A.INDEX_TYPE, A.CLUSTERING_FACTOR, B.COLUMN_NAME  FROM USER_INDEXES A, USER_IND_COLUMNS B WHERE A.INDEX_NAME = B.INDEX_NAME FETCH FIRST 10 ROWS ONLY;
  --13.
      SELECT VIEW_NAME, TEXT FROM USER_VIEWS FETCH FIRST 10 ROWS ONLY;

/* The first and second questions that alter tables will not execute.
 * If there are fields that violate the constraints then the statements will not execute.
 * The Country table currently has values that violate the constraints therefore these two statement error out. */
--2)
  --1.
      ALTER TABLE COUNTRY MODIFY AREA NOT NULL ENABLE NOVALIDATE ;
  --2.
      ALTER TABLE COUNTRY ADD CONSTRAINT CHK_AREA1 CHECK (AREA > 1000)  NOVALIDATE;
  --3.
      SELECT A.CONSTRAINT_NAME, A.CONSTRAINT_TYPE, B.COLUMN_NAME FROM ALL_CONSTRAINTS A, ALL_CONS_COLUMNS B WHERE A.TABLE_NAME = B.TABLE_NAME AND A.TABLE_NAME = 'COUNTRY' AND A.CONSTRAINT_NAME = B.CONSTRAINT_NAME AND A.OWNER = B.OWNER FETCH FIRST 10 ROWS ONLY;

--3)
  --1.
      SELECT TABLE_NAME, PRIVILEGE FROM ALL_TAB_PRIVS WHERE GRANTOR = 'ORDDATA' FETCH FIRST 10 ROWS ONLY;
