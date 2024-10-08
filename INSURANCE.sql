CREATE DATABASE INSURANCE;
USE INSURANCE;
SELECT * FROM INVOICE;
ALTER TABLE INVOICE CHANGE COLUMN `Account Executive` ACCOUNT_EXECUTIVE VARCHAR(30);
SELECT ACCOUNT_EXECUTIVE,COUNT(INVOICE_DATE) AS NO_OF_INVOICE FROM INVOICE
GROUP BY ACCOUNT_EXECUTIVE ORDER BY NO_OF_INVOICE DESC;

#KPI 2
SELECT *FROM MEETING;
SELECT YEAR(MEETING_DATE) AS YEAR,COUNT(MEETING_DATE) AS NO_OF_MEETINGS FROM MEETING
GROUP BY YEAR;

#KPI 3
SELECT *FROM INVOICE;
SELECT *FROM BUDGETS;
SELECT *FROM BROKEAGE;

ALTER TABLE BUDGETS CHANGE COLUMN `Cross sell bugdet` CROSS_BUDGET INT;
ALTER TABLE BUDGETS CHANGE COLUMN `New Budget`  NEW_BUDGET INT;
ALTER TABLE BUDGETS CHANGE COLUMN `Renewal Budget` RENEWAL_BUDGET INT;

#CROSS SELL
SELECT 
(SELECT CONCAT(ROUND(SUM(CROSS_BUDGET)/1000000,0),'M') FROM BUDGETS ) AS TARGET,
(SELECT CONCAT(ROUND(SUM(AMOUNT)/1000000,0),'M') FROM BROKEAGE WHERE INCOME_CLASS='CROSS SELL' ) AS ACHIEVED,
(SELECT CONCAT(ROUND(SUM(AMOUNT)/1000000,0),'M') FROM INVOICE WHERE INCOME_CLASS='CROSS SELL' ) AS INVOICE;

#NEW SELL
SELECT
(SELECT CONCAT(ROUND(SUM(NEW_BUDGET)/1000000,0),'M') FROM BUDGETS ) AS TARGET,
(SELECT CONCAT(ROUND(SUM(AMOUNT)/1000000,0),'M') FROM BROKEAGE WHERE INCOME_CLASS='NEW' ) AS ACHIEVED,
(SELECT CONCAT(ROUND(SUM(AMOUNT)/1000000,0),'M') FROM INVOICE WHERE INCOME_CLASS='NEW' ) AS INVOICE;

#RENEWAL SELL
SELECT
(SELECT CONCAT(ROUND(SUM(RENEWAL_BUDGET)/1000000,0),'M') FROM BUDGETS ) AS TARGET,
(SELECT CONCAT(ROUND(SUM(AMOUNT)/1000000,0),'M') FROM BROKEAGE WHERE INCOME_CLASS='RENEWAL' ) AS ACHIEVED,
(SELECT CONCAT(ROUND(SUM(AMOUNT)/1000000,0),'M') FROM INVOICE WHERE INCOME_CLASS='RENEWAL' ) AS INVOICE;

#KPI 4
SELECT *FROM OPPORTUNITY;
SELECT STAGE,SUM(REVENUE_AMOUNT) AS REVENUE_AMOUNT FROM OPPORTUNITY
GROUP BY STAGE ORDER BY REVENUE_AMOUNT DESC;

#KPI 5
SELECT *FROM MEETING;
ALTER TABLE MEETING CHANGE COLUMN `Account Executive` ACCOUNT_EXECUTIVE VARCHAR(30);
SELECT ACCOUNT_EXECUTIVE,COUNT(MEETING_DATE) AS NO_OF_MEETINGS FROM MEETING
GROUP BY ACCOUNT_EXECUTIVE ORDER BY NO_OF_MEETINGS DESC;

#KPI 6
SELECT *FROM OPPORTUNITY;
ALTER TABLE OPPORTUNITY CHANGE COLUMN `ï»¿opportunity_name` OPPORTUNITY_NAME VARCHAR(30);

#TOTAL OPPORTUNITY
SELECT COUNT(OPPORTUNITY_ID) AS TOTAL_OPPORTUNITY FROM OPPORTUNITY;

#TOP 5 OPPORTUNITY
SELECT OPPORTUNITY_NAME,SUM(REVENUE_AMOUNT) AS AMOUNT FROM OPPORTUNITY
GROUP BY OPPORTUNITY_NAME ORDER BY AMOUNT DESC LIMIT 5;

#OPPORTUNITY-PRODUCT DISTRIBUTION
SELECT PRODUCT_GROUP,COUNT(OPPORTUNITY_ID) AS COUNT_OF_OPPORTUNITY_ID FROM OPPORTUNITY
GROUP BY PRODUCT_GROUP ORDER BY COUNT_OF_OPPORTUNITY_ID DESC;


#PERCENTAGES
SELECT INV.INCOME_CLASS,
CASE WHEN INV.INCOME_CLASS="CROSS SELL" THEN SUM(INV.AMOUNT)/SUM(B.AMOUNT)
ELSE 0
END AS PERCENTAGE
FROM INVOICE AS INV INNER JOIN BUDGET AS B USING(ACCOUNT_EXE_ID)
GROUP BY INV.INCOME_CLASS;

SELECT INV.INCOME_CLASS,
CASE WHEN INV.INCOME_CLASS="NEW" THEN SUM(INV.AMOUNT)/SUM(B.AMOUNT)
ELSE 0
END AS PERCENTAGE
FROM INVOICE AS INV INNER JOIN BUDGET AS B USING(ACCOUNT_EXE_ID)
GROUP BY INV.INCOME_CLASS;

SELECT INV.INCOME_CLASS,
CASE WHEN INV.INCOME_CLASS="RENEWAL" THEN SUM(INV.AMOUNT)/SUM(B.AMOUNT)
ELSE 0
END AS PERCENTAGE
FROM INVOICE AS INV INNER JOIN BUDGET AS B USING(ACCOUNT_EXE_ID)
GROUP BY INV.INCOME_CLASS;



SELECT INV.INCOME_CLASS,SUM(INV.AMOUNT)/SUM(B.AMOUNT) AS PERCENT FROM INVOICE AS INV INNER JOIN BUDGET AS B
WHERE INV.INCOME_CLASS="CROSS SELL" AND B.INCOME_CLASS="CROSS SELL";

SELECT INV.INCOME_CLASS,SUM(INV.AMOUNT)/SUM(B.AMOUNT) AS PERCENT FROM INVOICE AS INV INNER JOIN BUDGET AS B
WHERE INV.INCOME_CLASS="NEW " AND B.INCOME_CLASS="NEW";

