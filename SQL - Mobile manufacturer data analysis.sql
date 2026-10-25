----- Mobile Manufacturer Data Analysis -----

--Q1. List all the states in which we have customers who have bought cellphones  
-- from 2005 till today?
SELECT DISTINCT L.State
FROM FACT_TRANSACTIONS AS T
JOIN DIM_LOCATION AS L
 ON T.IDLocation = L.IDLocation
WHERE YEAR(T.Date) >= 2005


--Q2. What state in the US is buying the most 'Samsung' cell phones?  
SELECT TOP 1 L.State, SUM(T.Quantity) AS TotalQuantity
FROM FACT_TRANSACTIONS AS T
JOIN DIM_MODEL AS M 
 ON T.IDModel = M.IDModel
JOIN DIM_MANUFACTURER AS MF 
 ON M.IDManufacturer = MF.IDManufacturer
JOIN DIM_LOCATION L 
 ON T.IDLocation = L.IDLocation
WHERE MF.Manufacturer_Name = 'Samsung'
  AND L.Country = 'US'
GROUP BY L.State
ORDER BY TotalQuantity DESC


--Q3. Show the number of transactions for each model per zip code per state?
SELECT M.Model_Name, L.ZipCode, L.State,
COUNT(*) AS NumberOfTransactions
FROM FACT_TRANSACTIONS AS T
JOIN DIM_MODEL AS M 
 ON T.IDModel = M.IDModel
JOIN DIM_LOCATION AS L 
 ON T.IDLocation = L.IDLocation
GROUP BY M.Model_Name, L.ZipCode, L.State


--Q4. Show the cheapest cellphone (Output should contain the price also)? 
SELECT TOP 1 Model_Name, Unit_Price
FROM DIM_MODEL
ORDER BY Unit_Price ASC


--Q5. Find out the average price for each model in the top5 manufacturers in  
--terms of sales quantity and order by average price? 
SELECT Model_Name, AVG(M.Unit_price) AS AVG_PRICE
FROM FACT_TRANSACTIONS AS T
JOIN DIM_MODEL AS M
ON T.IDModel = M.IDModel
WHERE M.IDManufacturer IN (
				SELECT TOP 5 M2.IDManufacturer
				FROM FACT_TRANSACTIONS AS T2
				JOIN DIM_MODEL AS M2
				ON T2.IDModel = M2.IDModel
				GROUP BY M2.IDManufacturer
				ORDER BY SUM(T2.Quantity) DESC )
GROUP BY Model_Name
ORDER BY AVG_PRICE DESC


--Q6. List the names of the customers and the average amount spent in 2009,  
--where the average is higher than 500?  
SELECT C.Customer_Name, AVG(T.TotalPrice) AS AvgSpent
FROM FACT_TRANSACTIONS AS T
JOIN DIM_CUSTOMER AS C 
 ON T.IDCustomer = C.IDCustomer
WHERE YEAR(T.Date) = 2009
GROUP BY C.Customer_Name
HAVING AVG(T.TotalPrice) > 500


--Q7. List if there is any model that was in the top 5 in terms of quantity,  
-- simultaneously in 2008, 2009 and 2010?  
WITH RankedModels AS (
SELECT YEAR(T.Date) AS SalesYear, M.Model_Name, SUM(T.Quantity) AS TotalQty,
DENSE_RANK() OVER (
  PARTITION BY YEAR(T.Date)
  ORDER BY SUM(T.Quantity) DESC) AS rnk
FROM FACT_TRANSACTIONS AS T
JOIN DIM_MODEL AS M
  ON T.IDModel = M.IDModel
WHERE YEAR(T.Date) IN (2008, 2009, 2010)
GROUP BY YEAR(T.Date), M.Model_Name
)
SELECT Model_Name
FROM RankedModels
WHERE rnk <= 5
GROUP BY Model_Name
HAVING COUNT(DISTINCT SalesYear) = 3


--Q8. Show the manufacturer with the 2nd top sales in the year of 2009 and the  
-- manufacturer with the 2nd top sales in the year of 2010. 
WITH ManufacturerSales AS (
SELECT YEAR(T.Date) AS SalesYear, MF.Manufacturer_Name,
SUM(T.TotalPrice) AS TotalSales,
DENSE_RANK() OVER (
            PARTITION BY YEAR(T.Date)
            ORDER BY SUM(T.TotalPrice) DESC) AS rnk
FROM FACT_TRANSACTIONS AS T
JOIN DIM_MODEL AS M 
  ON T.IDModel = M.IDModel
JOIN DIM_MANUFACTURER MF
  ON M.IDManufacturer = MF.IDManufacturer
WHERE YEAR(T.Date) IN (2009, 2010)
GROUP BY YEAR(T.Date), MF.Manufacturer_Name
)
SELECT SalesYear, Manufacturer_Name, TotalSales
FROM ManufacturerSales
WHERE rnk = 2


--Q9. Show the manufacturers that sold cellphones in 2010 but did not in 2009?
SELECT DISTINCT MF.Manufacturer_Name
FROM FACT_TRANSACTIONS AS T
JOIN DIM_MODEL AS M
  ON T.IDModel = M.IDModel
JOIN DIM_MANUFACTURER AS MF 
  ON M.IDManufacturer = MF.IDManufacturer
WHERE YEAR(T.Date) = 2010
AND MF.Manufacturer_Name NOT IN (
	SELECT DISTINCT mf2.Manufacturer_Name
	FROM FACT_TRANSACTIONS AS T2
	JOIN DIM_MODEL AS M2 
	  ON T2.IDModel = M2.IDModel
	JOIN DIM_MANUFACTURER AS MF2 
	  ON M2.IDManufacturer = MF2.IDManufacturer
	WHERE YEAR(T2.Date) = 2009
	)


--Q10. Find top 100 customers and their average spend, average quantity by each  
-- year. Also find the percentage of change in their spend? 
WITH CustomerTotals AS (
    SELECT
        IDCustomer,
        SUM(TotalPrice) AS OverallSpend
    FROM FACT_TRANSACTIONS
    GROUP BY IDCustomer
),
Top100Customers AS (
    SELECT TOP 100
        IDCustomer
    FROM CustomerTotals
    ORDER BY OverallSpend DESC, IDCustomer
),
CustomerYearly AS (
    SELECT
        F.IDCustomer,
        C.Customer_Name,
        D.[YEAR] AS SalesYear,
        AVG(F.TotalPrice) AS AvgSpend,
        AVG(CAST(F.Quantity AS DECIMAL(18, 2))) AS AvgQuantity,
        SUM(F.TotalPrice) AS TotalSpend
    FROM FACT_TRANSACTIONS AS F
    JOIN DIM_CUSTOMER AS C
        ON F.IDCustomer = C.IDCustomer
    JOIN DIM_DATE AS D
        ON F.Date = D.[DATE]
    JOIN Top100Customers AS T
        ON F.IDCustomer = T.IDCustomer
    GROUP BY
        F.IDCustomer,
        C.Customer_Name,
        D.[YEAR]
),
SpendWithPreviousYear AS (
    SELECT *,
        LAG(TotalSpend) OVER (
            PARTITION BY IDCustomer
            ORDER BY SalesYear
        ) AS PreviousYearSpend,
        LAG(SalesYear) OVER (
            PARTITION BY IDCustomer
            ORDER BY SalesYear
        ) AS PreviousYear
    FROM CustomerYearly
)
SELECT
    IDCustomer,
    Customer_Name,
    SalesYear,
    AvgSpend,
    AvgQuantity,
    TotalSpend,
    PreviousYearSpend,
    CASE
        WHEN PreviousYear = SalesYear - 1
         AND PreviousYearSpend <> 0
        THEN CAST(
            100.0 * (TotalSpend - PreviousYearSpend)
            / PreviousYearSpend
            AS DECIMAL(10, 2)
        )
        ELSE NULL
    END AS SpendPercentageChange
FROM SpendWithPreviousYear
ORDER BY IDCustomer, SalesYear;
