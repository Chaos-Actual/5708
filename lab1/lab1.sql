1)
  1. SELECT UNIQUE NAME FROM COUNTRY WHERE NAME LIKE 'C%' OR NAME LIKE 'D%';
  2. SELECT NAME FROM COUNTRY WHERE GDP > .15 AND YEAR = '2011';
  3. SELECT UNIQUE REGION FROM COUNTRY;
  4. SELECT NAME FROM COUNTRY WHERE POPULATION < 1000000 AND YEAR = '2011';
  5. SELECT NAME FROM COUNTRY WHERE REGION = 'Europe' AND AREA > 100000 AND YEAR = '2005' ORDER BY GDP DESC;

2)
  1. SELECT COUNT (NAME) FROM COUNTRY WHERE GDP > .15 AND YEAR = '2005';
 --This is not correct english. For each year,...
  2..  SELECT YEAR , COUNT(NAME) AS NUMBER_COUNTRIES, SUM(POPULATION) AS TOTAL_POPULATION, ( (SUM(POPULATION) ) / (COUNT(NAME) ) ) AS AVE_POPULATION , SUM(GDP) AS TOTAL_GDP FROM COUNTRY WHERE REGION = 'Europe' GROUP BY REGION, YEAR ORDER BY YEAR DESC;
  3. SELECT A.REGION FROM COUNTRY A WHERE A.YEAR = '2005' GROUP BY A.REGION HAVING COUNT(*) > 4 AND SUM(A.POPULATION) > 45000000;
  4. SELECT YEAR , SUM ((POPULATION /AREA )) AS DENSITY FROM COUNTRY WHERE REGION = 'Europe' GROUP BY YEAR  ORDER BY YEAR DESC;

3)
 -- This takes a little while to figure out what it is asking. It would be more clear if find names of regions and the area of these regions with.. bc name is a field in the table
  1. SELECT A.REGION , SUM(A.AREA) AS TOTAL_AREA FROM COUNTRY A WHERE A.YEAR = '2002' GROUP BY A.REGION HAVING SUM(A.AREA) > (SELECT SUM(B.AREA) FROM COUNTRY B WHERE B.YEAR = '2002' AND B.REGION = 'Middle East');   1
  2..  SELECT A.REGION, SUM(A.POPULATION) AS REGION_POPULATION FROM COUNTRY A GROUP BY A.REGION ORDER BY SUM(A.POPULATION) ASC FETCH FIRST 1 ROWS ONLY ;
  3. SELECT A.NAME FROM COUNTRY A WHERE A.YEAR = '2006' AND A.REGION = 'Europe' AND A.POPULATION > (SELECT B.POPULATION FROM COUNTRY B WHERE A.YEAR = B.YEAR AND B.NAME = 'Spain');
  4. SELECT A.NAME FROM COUNTRY A WHERE A.YEAR ='2008' AND A.AREA NOT IN (SELECT B.AREA FROM COUNTRY B , COUNTRY C WHERE B.YEAR = C.YEAR AND B.YEAR = '2008' AND B.AREA > C.AREA);


4)
  1.  DELETE FROM COUNTRY WHERE GDP = 0;
  2.  UPDATE COUNTRY SET AREA = 35000 WHERE NAME = 'Belgium';
  3.  UPDATE COUNTRY SET AREA = (AREA * 1.3) WHERE NAME = 'Peru';

-- CAN WE HAVE MORE THAN ONE STATEMENT?
  4.. UPDATE COUNTRY A SET  A.POPULATION = (A.POPULATION + (SELECT B.POPULATION FROM COUNTRY B WHERE B.NAME = 'Hong Kong' AND A.YEAR = B.YEAR)),
  A.AREA = (A.AREA + (SELECT B.AREA FROM COUNTRY B WHERE B.NAME = 'Hong Kong' AND A.YEAR = B.YEAR )),
   A.GDP = (A.GDP + (SELECT B.GDP FROM COUNTRY B WHERE B.NAME = 'Hong Kong' AND A.YEAR = B.YEAR))
   WHERE A.NAME = 'China' AND YEAR > 1997;
    DELETE FROM COUNTRY WHERE NAME = 'Hong Kong' AND YEAR > 1997;

5)
  -- ENGLISH WOULD YOU NOT YOU WOULD
  1. CREATE INDEX POPULATION_RANGE ON COUNTRY (POPULATION); -- THIS IS HAVE AN INDEX_TYPE OF NORMAL WHICH IS BY DEFAULT A B+ TREE IN ORACLE.

  2. CREATE INDEX POP_INDEX ON COUNTRY (POPULATION);
  3. CREATE VIEW COUNTRY_VIEW AS SELECT REGION, POPULATION, AREA FROM COUNTRY;


Part C
1)
  1. SELECT TABLE_NAME , TABLESPACE_NAME, STATUS FROM USER_TABLES; --TABLES SPACES CAN HAVE MORE THAN ONE TABLE BUT A TABLE CAN ONLY PE A PART OF ONE TABLESAPCEA.
  -- THIS DOES NOT RETURN ANY VALUES.
  2. SELECT COMMENTS FROM ALL_TAB_COMMENTS WHERE COMMENTS IS NOT NULL;
  3. ANALYZE TABLE COUNTRY COMPUTE STATISTICS;
  4. SELECT VIEW_NAME, TEXT_VC FROM USER_VIEWS;
  5. SELECT NUM_ROWS, BLOCKS, AVG_ROW_LEN, LAST_ANALYZED, DEPENDENCIES  FROM USER_TABLES;
  6. SELECT INDEX_NAME, INDEX_TYPE FROM USER_INDEXES;
  7. SELECT NUM_DISTINCT, NUM_NULLS, DENSITY, LOW_VALUE, HIGH_VALUE FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'COUNTRY';
  8. SELECT INDEX_NAME, TABLE_NAME, COLUMN_NAME FROM USER_IND_COLUMNS;
  9. SELECT INDEX_NAME FROM USER_INDEXES;
  10. SELECT TABLE_NAME, TABLE_TYPE FROM USER_CATALOG;
  11. -- The coutry.sql script does not have any statements to create an index. Oracle created an index on column NAME because NAME is a primary key for the table country. The system also created an index on the column YEAR beacuse YEAR is also part of the primary key for the table COUNTRY;
  12. SELECT A.LEAF_BLOCKS, A.INDEX_NAME, A.INDEX_TYPE, A.CLUSTERING_FACTOR, B.COLUMN_NAME  FROM USER_INDEXES A, USER_IND_COLUMNS B WHERE A.INDEX_NAME = B.INDEX_NAME;
  13. SELECT VIEW_NAME, TEXT FROM USER_VIEWS;

2)
  1. ALTER TABLE COUNTRY MODIFY (AREA NOT NULL);
  -- This constraint will not work if there is data in the database that already violates the constraint
  2. ALTER TABLE COUNTRY MODIFY (AREA CHECK (AREA > 1000));
  3. SELECT A.CONSTRAINT_NAME, A.CONSTRAINT_TYPE, B.COLUMN_NAME FROM ALL_CONSTRAINTS A, ALL_CONS_COLUMNS B WHERE A.TABLE_NAME = B.TABLE_NAME AND A.TABLE_NAME = 'COUNTRY' AND A.CONSTRAINT_NAME = B.CONSTRAINT_NAME AND A.OWNER = B.OWNER;

3)
  1. SELECT TABLE_NAME, PRIVILEGE FROM ALL_TAB_PRIVS WHERE GRANTOR = 'ORDDATA';
