------------------------------COVID-19 ANALYSIS-----------------------------------------
SELECT * 
FROM [Corona Virus Dataset]

-- Q1. Write a code to check NULL values
SELECT *
FROM [Corona Virus Dataset]
WHERE Confirmed IS NULL AND Deaths IS NULL AND Recovered IS NULL;

--Q2. If NULL values are present, update them with zeros for all columns. 
UPDATE [Corona Virus Dataset]
SET 
    confirmed = ISNULL(Confirmed, 0),
    deaths = ISNULL(deaths, 0),
    recovered = ISNULL(recovered, 0);

	-- Q3. check total number of rows
SELECT COUNT(*)
FROM [Corona Virus Dataset]

-- Q4. Check what is start_date and end_date
SELECT MIN(Date) AS start_date,
           MAX(Date) AS end_date
FROM [Corona Virus Dataset];

-- Q5. Number of month present in dataset
SELECT COUNT(DISTINCT (Date)) AS Number_of_Months
FROM [Corona Virus Dataset];

-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT 
    MONTH(TRY_CONVERT(DATE, Date)) AS Month,
    AVG(CAST(Confirmed AS FLOAT)) AS Average_Confirmed,
    AVG(CAST(Deaths AS FLOAT)) AS Average_Deaths,
    AVG(CAST(Recovered AS FLOAT)) AS Average_Recovered
FROM [Corona Virus Dataset]
WHERE TRY_CONVERT(DATE, Date) IS NOT NULL  -- Filter out rows with invalid date values
GROUP BY MONTH(TRY_CONVERT(DATE, Date));

 -- Q7. Find most frequent value for confirmed, deaths, recovered each month 
  WITH MonthlyCounts AS (
    SELECT 
        MONTH(CONVERT(DATE, Date, 105)) AS Month,
        Confirmed,
        Deaths,
        Recovered,
        ROW_NUMBER() OVER (PARTITION BY MONTH(CONVERT(DATE, Date, 105)), Confirmed ORDER BY COUNT(*) DESC) AS ConfirmedRank,
        ROW_NUMBER() OVER (PARTITION BY MONTH(CONVERT(DATE, Date, 105)), Deaths ORDER BY COUNT(*) DESC) AS DeathsRank,
        ROW_NUMBER() OVER (PARTITION BY MONTH(CONVERT(DATE, Date, 105)), Recovered ORDER BY COUNT(*) DESC) AS RecoveredRank
    FROM 
       [Corona Virus Dataset]
    WHERE 
        TRY_CONVERT(DATE, Date, 105) IS NOT NULL
    GROUP BY 
        MONTH(CONVERT(DATE, Date, 105)), Confirmed, Deaths, Recovered
)
SELECT 
    Month,
    MAX(CASE WHEN ConfirmedRank = 1 THEN Confirmed END) AS Most_Frequent_Confirmed,
    MAX(CASE WHEN DeathsRank = 1 THEN Deaths END) AS Most_Frequent_Deaths,
    MAX(CASE WHEN RecoveredRank = 1 THEN Recovered END) AS Most_Frequent_Recovered
FROM 
    MonthlyCounts
GROUP BY 
    Month;

	-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT 
    YEAR(CONVERT(DATE, Date, 105)) AS Year,
    MIN(Confirmed) AS Min_Confirmed,
    MIN(Deaths) AS Min_Deaths,
    MIN(Recovered) AS Min_Recovered
FROM 
    [Corona Virus Dataset]
WHERE 
    TRY_CONVERT(DATE, Date, 105) IS NOT NULL
GROUP BY 
    YEAR(CONVERT(DATE, Date, 105));

	 -- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT 
    YEAR(CONVERT(DATE, Date, 105)) AS Year,
    MAX(Confirmed) AS Max_Confirmed,
    MAX(Deaths) AS Max_Deaths,
    MAX(Recovered) AS Max_Recovered
FROM 
   [Corona Virus Dataset]
WHERE 
    TRY_CONVERT(DATE, Date, 105) IS NOT NULL
GROUP BY 
    YEAR(CONVERT(DATE, Date, 105));

-- Q10. The total number of case of confirmed, deaths, recovered each month
SELECT 
    YEAR(CONVERT(DATE, Date, 105)) AS Year,
    MONTH(CONVERT(DATE, Date, 105)) AS Month,
    SUM(CAST(Confirmed AS INT)) AS Total_Confirmed,
    SUM(CAST(Deaths AS INT)) AS Total_Deaths,
    SUM(CAST(Recovered AS INT)) AS Total_Recovered
FROM 
    [Corona Virus Dataset]
WHERE 
    TRY_CONVERT(DATE, Date, 105) IS NOT NULL
GROUP BY 
    YEAR(CONVERT(DATE, Date, 105)),
    MONTH(CONVERT(DATE, Date, 105))
ORDER BY 
    Year, Month;

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

-- Total confirmed cases
SELECT 
    SUM(CAST(Confirmed AS FLOAT)) AS Total_Confirmed
FROM 
    [Corona Virus Dataset]
WHERE 
    ISNUMERIC(Confirmed) = 1;

-- Average confirmed cases
SELECT 
    AVG(CAST(Confirmed AS FLOAT)) AS Average_Confirmed
FROM 
   [Corona Virus Dataset]
WHERE 
    ISNUMERIC(Confirmed) = 1;

--Variance of confirmed cases:
SELECT 
    VAR(CAST(Confirmed AS FLOAT)) AS Variance_Confirmed
FROM 
   [Corona Virus Dataset]
WHERE 
    ISNUMERIC(Confirmed) = 1;

--Standard deviation of confirmed cases:
SELECT 
    STDEV(CAST(Confirmed AS FLOAT)) AS STDEV_Confirmed
FROM 
    [Corona Virus Dataset]
WHERE 
    ISNUMERIC(Confirmed) = 1;

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
-- Total death cases per month
SELECT 
    YEAR(CONVERT(DATE, Date, 105)) AS Year,
    MONTH(CONVERT(DATE, Date, 105)) AS Month,
    SUM(CAST(Deaths AS INT)) AS Total_Deaths
FROM 
    [Corona Virus Dataset]
WHERE 
    TRY_CONVERT(DATE, Date, 105) IS NOT NULL
GROUP BY 
    YEAR(CONVERT(DATE, Date, 105)),
    MONTH(CONVERT(DATE, Date, 105))
ORDER BY 
    Year, Month;

-- Average death cases per month
SELECT 
    YEAR(CONVERT(DATE, Date, 105)) AS Year,
    MONTH(CONVERT(DATE, Date, 105)) AS Month,
    AVG(CAST(Deaths AS FLOAT)) AS Average_Deaths
FROM 
    [Corona Virus Dataset]
WHERE 
    TRY_CONVERT(DATE, Date, 105) IS NOT NULL
GROUP BY 
    YEAR(CONVERT(DATE, Date, 105)),
    MONTH(CONVERT(DATE, Date, 105))
ORDER BY 
    Year, Month;

-- Variance of death cases per month
SELECT 
    YEAR(CONVERT(DATE, Date, 105)) AS Year,
    MONTH(CONVERT(DATE, Date, 105)) AS Month,
    VAR(CAST(Deaths AS FLOAT)) AS Variance_Deaths
FROM 
    [Corona Virus Dataset]
WHERE 
    TRY_CONVERT(DATE, Date, 105) IS NOT NULL
GROUP BY 
    YEAR(CONVERT(DATE, Date, 105)),
    MONTH(CONVERT(DATE, Date, 105))
ORDER BY 
    Year, Month;

-- Standard deviation of death cases per month
SELECT 
    YEAR(CONVERT(DATE, Date, 105)) AS Year,
    MONTH(CONVERT(DATE, Date, 105)) AS Month,
    STDEV(CAST(Deaths AS FLOAT)) AS STDEV_Deaths
FROM 
   [Corona Virus Dataset]
WHERE 
    TRY_CONVERT(DATE, Date, 105) IS NOT NULL
GROUP BY 
    YEAR(CONVERT(DATE, Date, 105)),
    MONTH(CONVERT(DATE, Date, 105))
ORDER BY 
    Year, Month;

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

-- Total recovered cases
SELECT 
    SUM(CAST(REPLACE(Recovered, ',', '') AS BIGINT)) AS Total_Recovered
FROM 
    [Corona Virus Dataset];

--Average recovered cases:
SELECT 
    AVG(CAST(REPLACE(Recovered, ',', '') AS FLOAT)) AS Average_Recovered
FROM 
    [Corona Virus Dataset];

--Variance of recovered cases:
SELECT 
    VAR(CAST(REPLACE(Recovered, ',', '') AS FLOAT)) AS Variance_Recovered
FROM 
    [Corona Virus Dataset];

--Standard deviation of recovered cases:
SELECT 
    STDEV(CAST(REPLACE(Recovered, ',', '') AS FLOAT)) AS STDEV_Recovered
FROM 
  [Corona Virus Dataset];

  -- Q14. Find Country having highest number of the Confirmed case
SELECT 
    [Country Region],
    Confirmed
FROM 
   [Corona Virus Dataset]
WHERE 
    Confirmed = (SELECT MAX(Confirmed) FROM [Corona Virus Dataset]);

-- Q15. Find Country having lowest number of the death case
SELECT TOP 1
    [Country Region],
    CAST(Deaths AS INT) AS Deaths
FROM 
   [Corona Virus Dataset]
WHERE 
    TRY_CAST(Deaths AS INT) IS NOT NULL
    AND TRY_CAST(Deaths AS INT) > 0
    AND Deaths != '' -- Exclude empty strings if present
ORDER BY 
    Deaths ASC;

-- Q16. Find top 5 countries having highest recovered case
SELECT TOP 5
    [Country Region],
    Recovered
FROM 
   [Corona Virus Dataset]
ORDER BY 
    Recovered DESC;


