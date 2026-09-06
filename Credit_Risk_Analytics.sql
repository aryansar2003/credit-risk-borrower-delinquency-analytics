CREATE DATABASE credit_risk;
USE credit_risk;

-- Check the data
select *
from credit_risk_clean
limit 10;

select count(*) as total_borrowers
from credit_risk_clean;


-- What is the overall serious delinquency rate?
SELECT 
    SUM(CASE 
            WHEN SeriousDlqin2yrs = 1 THEN 1 
            ELSE 0 
        END) * 100.0 / COUNT(*) AS delinquency_rate
FROM credit_risk_clean;


-- Which age groups have the highest serious-delinquency rate?
SELECT Age_Group , count(*) as total_borrowers , 
 SUM(CASE 
            WHEN SeriousDlqin2yrs = 1 THEN 1 
            ELSE 0 
        END) * 100.0 / COUNT(*) AS delinquency_rate
from credit_risk_clean
group by Age_Group
order by delinquency_rate desc;

-- How does the number of previous 30–59 day late payments relate to serious delinquency?
SELECT 
    Late_30_59_Group ,
    COUNT(*) AS total_borrowers,
    SUM(CASE 
            WHEN SeriousDlqin2yrs = 1 THEN 1 
            ELSE 0 
        END) * 100.0 / COUNT(*) AS delinquency_rate
FROM credit_risk_clean
GROUP BY Late_30_59_Group
ORDER BY delinquency_rate DESC;


-- How does the number of previous 60–89 days late payments relate to serious delinquency?
SELECT 
    Late_60_89_Group,
    COUNT(*) AS total_borrowers,
    SUM(CASE 
            WHEN SeriousDlqin2yrs = 1 THEN 1 
            ELSE 0 
        END) * 100.0 / COUNT(*) AS delinquency_rate
FROM credit_risk_clean
GROUP BY Late_60_89_Group
ORDER BY delinquency_rate DESC;


-- How does the number of previous 90+ day late payments relate to serious delinquency?
SELECT 
    Late_90Plus_Group,
    COUNT(*) AS total_borrowers,
    SUM(CASE 
            WHEN SeriousDlqin2yrs = 1 THEN 1 
            ELSE 0 
        END) * 100.0 / COUNT(*) AS delinquency_rate
FROM credit_risk_clean
GROUP BY Late_90Plus_Group
ORDER BY delinquency_rate DESC;


-- For each past-due category, which one has the highest serious-delinquency rate among borrowers with 3+ previous late payments?
SELECT 
    '30-59 Days' AS past_due_type,
    SUM(CASE WHEN SeriousDlqin2yrs = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS delinquency_rate
FROM credit_risk_clean
WHERE Late_30_59_Group = '3+'

UNION ALL

SELECT 
    '60-89 Days' AS past_due_type,
    SUM(CASE WHEN SeriousDlqin2yrs = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS delinquency_rate
FROM credit_risk_clean
WHERE Late_60_89_Group = '3+'

UNION ALL

SELECT 
    '90+ Days' AS past_due_type,
    SUM(CASE WHEN SeriousDlqin2yrs = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS delinquency_rate
FROM credit_risk_clean
WHERE Late_90Plus_Group = '3+'

ORDER BY delinquency_rate DESC;

-- Which 10 borrowers have the highest number of previous 90+ day late payments?
Select  `Unnamed: 0` as borrower_id , NumberOfTimes90DaysLate , SeriousDlqin2yrs
from  credit_risk_clean 
order by NumberOfTimes90DaysLate desc 
limit 10 ;

-- What percentage of borrowers fall into each previous 90+ day late-payment group?

SELECT 
    Late_90Plus_Group,
    COUNT(*) AS total_borrowers,
    COUNT(*) * 100.0 / (
        SELECT COUNT(*)
        FROM credit_risk_clean
    ) AS borrower_percentage
FROM credit_risk_clean
GROUP BY Late_90Plus_Group
ORDER BY borrower_percentage DESC;
