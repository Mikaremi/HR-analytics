USE HUMANRESOURCE;

SELECT *
FROM hr_data;

SELECT termdate
FROM hr_data
ORDER BY termdate DESC;

UPDATE hr_data
SET termdate = FORMAT(CONVERT(DATETIME, LEFT(termdate, 19), 120), 'yyyy-MM-dd');

ALTER TABLE hr_data
ADD new_termdate DATE;

-- copy converted time values from termdate to new_termdate

UPDATE hr_data
SET new_termdate = CASE
WHEN termdate IS NOT NULL AND ISDATE(termdate) = 1 THEN CAST (termdate AS DATETIME) ELSE NULL END;


-- create new column "age"
ALTER TABLE hr_data
ADD age nvarchar(50);

--populate new column with age
UPDATE hr_data
SET age = DATEDIFF(YEAR, birthdate, GETDATE());

SELECT age
FROM hr_data;


--QUESTIONS TO ANSWER FROM THE DATA

-- 1) What's the age dstribution in the company?

--age distribution

SELECT
MIN(age) AS youngest,
MAX(age) AS oldest
FROM hr_data;
--age group distribution

SELECT age_group,
COUNT(*) AS count
FROM
(SELECT
 CASE 
  WHEN age <= 22 AND age <= 30 THEN '22 to 31'
  WHEN age <= 32 AND age <= 41 THEN '32 to 41'
  WHEN age <= 42 AND age <= 51 THEN '42 to 51'
  ELSE '51+'
  END AS age_group
 FROM hr_data
 WHERE new_termdate IS NULL
 ) AS subquery
GROUP BY age_group
ORDER BY age_group;

SELECT gender
FROM hr_data;

-- age group be gender

SELECT age_group,
gender,
COUNT(*) AS count
FROM
(SELECT
 CASE
  WHEN age <= 22 AND age <= 31 THEN  '22 to 31'
  WHEN age <= 32 AND age <= 41 THEN '31 to 41'
  WHEN age <= 42 AND age <=51 THEN '41 to 51'
  ELSE '51+'
  END AS age_group,
  gender
 FROM hr_data
 WHERE new_termdate IS NULL
 ) AS subquery
GROUP BY age_group, gender
ORDER BY age_group, gender;





--2) What's the gender breakdown in the company?

SELECT 
gender,
COUNT(gender) AS count
FROM hr_data
WHERE new_termdate IS NULL
GROUP BY gender 
ORDER BY gender ASC;



--3) How does gender vary accross departments and job tittle?
SELECT 
department,
gender,
COUNT(gender) AS count
FROM hr_data
WHERE new_termdate IS NULL
GROUP BY department, gender 
ORDER BY department, gender ASC;

--job tittles

SELECT 
department, jobtitle,
gender,
COUNT(gender) AS count
FROM hr_data
WHERE new_termdate IS NULL
GROUP BY department, jobtitle, gender 
ORDER BY department, jobtitle, gender ASC;

--4) What's the race distribution in the company?
SELECT 
race,
COUNT(*) AS count
FROM 
hr_data
WHERE new_termdate IS NULL
GROUP BY race
order by count DESC;

--5) What's the average lenght of employment in the company?
SELECT 
AVG(DATEDIFF(year, hire_date, new_termdate)) AS tenure
FROM hr_data
WHERE new_termdate IS NOT NULL AND new_termdate <= GETDATE();

--6) Which department has the highest turnover rate?
--get the total count
--get the terminated count
--terminated count/total count
SELECT 
 department,
 total_count,
 terminated_count,
 (round((CAST(terminated_count AS FLOAT)/total_count), 2))*100 AS turnover_rate
 FROM
    (SELECT 
     department,
     COUNT(*) AS total_count,
     SUM(CASE
        WHEN new_termdate IS NOT NULL AND new_termdate <= GETDATE() THEN 1 ELSE 0
	    END
	    ) AS terminated_count
     FROM hr_data
     GROUP BY department
	 ) AS subquery
ORDER BY turnover_rate DESC;


--7) What is the tenure distribution for each department?
SELECT 
department,
AVG(DATEDIFF(year, hire_date, new_termdate)) AS tenure
FROM hr_data
WHERE new_termdate IS NOT NULL AND new_termdate <= GETDATE()
GROUP BY department
ORDER BY tenure DESC;


--8) How many employees work remotely for each department?
SELECT 
 location,
 count(*) as count
FROM hr_data
WHERE new_termdate IS NULL
GROUP BY location;

--9) What's the distribution of employees across different states?
SELECT
 location_state,
 COUNT(*) AS count
FROM hr_data
WHERE new_termdate IS NULL
GROUP BY location_state
ORDER BY count DESC;

--10) How are job tittles distributed in the company?

SELECT 
 jobtitle,
 COUNT(*) AS count
FROM hr_data
WHERE new_termdate IS NULL
GROUP BY jobtitle
ORDER BY count DESC;

--11) How many employee hire counts varies over time?
--calculate hires
--calculate terminations 
--(hires-termination)/hires percent hire change
SELECT
 hire_year,
 hires,
 terminations,
 hires - terminations AS net_change,
 (round(CAST(hires-terminations AS FLOAT)/hires, 2))*100 AS percent_hire_change
 FROM
   (SELECT
    YEAR(hire_date) AS hire_year,
    COUNT(*) AS hires,
    SUM(CASE
         WHEN new_termdate IS NOT NULL AND new_termdate <= getdate() THEN 1 ELSE 0
	     END
	     )AS terminations
   FROM hr_data
   GROUP BY YEAR(hire_date)
   ) AS subquery
ORDER BY percent_hire_change ASC;