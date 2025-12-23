use hr_analytics;
CREATE TABLE recruitment_data (
    Candidate_ID VARCHAR(20) PRIMARY KEY,   
    Name VARCHAR(100),
    Gender VARCHAR(10),
    Position VARCHAR(50),
    Source VARCHAR(50),
    Location VARCHAR(50),
    Experience_Years INT,
    Notice_Period_Days INT,                 
    Application_Date DATE,
    Interview_Date DATE,
    Offer_Date DATE,
    Offered_Salary DECIMAL(10,2),
    Final_Status VARCHAR(50)
);
select * from recruitment_data;

-- Count of candidates by final status

SELECT Final_Status, COUNT(*) AS candidate_count
FROM recruitment_data
GROUP BY Final_Status;

-- How many candidates were selected?

SELECT COUNT(*) AS selected_candidates
FROM recruitment_data
WHERE Final_Status = 'Selected';

-- Distinct job positions applied for

SELECT DISTINCT Position
FROM recruitment_data;

-- Source-wise candidate count

SELECT Source, COUNT(*) AS total_candidates
FROM recruitment_data
GROUP BY Source
ORDER BY total_candidates DESC;

-- Average offered salary by position

SELECT Position, AVG(Offered_Salary) AS avg_salary
FROM recruitment_data
WHERE Final_Status = 'Selected'
GROUP BY Position;

-- Gender-wise selection count

SELECT Gender, COUNT(*) AS selected_count
FROM recruitment_data
WHERE Final_Status = 'Selected'
GROUP BY Gender;

-- Candidates who declined offers

SELECT *
FROM recruitment_data
WHERE Final_Status = 'Offer Declined';

-- Average time to hire (Application → Interview)

SELECT 
    AVG(DATEDIFF(Interview_Date, Application_Date)) AS avg_days_to_interview
FROM recruitment_data;

-- Average time from interview to offer

SELECT 
    AVG(DATEDIFF(Offer_Date, Interview_Date)) AS avg_days_to_offer
FROM recruitment_data
WHERE Offer_Date IS NOT NULL;

-- Source-wise selection rate (%)

SELECT 
    Source,
    COUNT(CASE WHEN Final_Status = 'Selected' THEN 1 END) * 100.0 / COUNT(*) AS selection_rate
FROM recruitment_data
GROUP BY Source;

-- Highest salary offered by position

SELECT Position, MAX(Offered_Salary) AS max_salary
FROM recruitment_data
GROUP BY Position;

-- Rank candidates by offered salary within each position

SELECT 
    Candidate_ID,
    Position,
    Offered_Salary,
    RANK() OVER (PARTITION BY Position ORDER BY Offered_Salary DESC) AS salary_rank
FROM recruitment_data
WHERE Final_Status = 'Selected';

-- Running count of applications by date

SELECT 
    Application_Date,
    COUNT(*) OVER (ORDER BY Application_Date) AS running_total
FROM recruitment_data;

-- Which location has the highest hiring

SELECT Location, COUNT(*) AS hires
FROM recruitment_data
WHERE Final_Status = 'Selected'
GROUP BY Location
ORDER BY hires DESC;

-- Experience vs selection probability

SELECT 
    Experience_Years,
    COUNT(CASE WHEN Final_Status = 'Selected' THEN 1 END) * 100.0 / COUNT(*) AS selection_rate
FROM recruitment_data
GROUP BY Experience_Years
ORDER BY Experience_Years;


