# Hrdata Analysis

### Project Overview
This data analysis project aims to provide insights about employees who are working at a particular company. By analyzing the varous aspects of the hr data, we set to identify trends, make data driven recommendations, and gain a deeper understanding of the employees in the company.


### Data source
HR DATA: The primary dataset used for this analysis is the "HR DATA.csv" file, containing detailed informations about each employee in the company.

### Tools

- Excel - Data cleaning
- Microsoft SQL Server - Data analysis
- Power Bi - Creating a report
  
### Data cleaning

In the initial data preparation phase, I performed the following tasks:
1. Data loading and inspection
2. Handling missing values
3. Data cleaning and formatting


### EDA

1. What is the age distribution in the company?
2. What is the gender breakdown in the company?
3. How does gender vary accross departments and job tittle?
4. What is the race distribution in the company?
5. What is the average length of employment in the company?
6. Which department has the highest turnover rate?
7. What is te tenure distribution for each department?
8. How many employees work remotely for each department?
9. What is te distribution of employees accross different states?
10. How are job tittles distributed in the company?
11. How many employee hire counts varies over time?

### Data Analysis

``` sql
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
```

### Results
1. Most of the employees are Male.
2. Most of the employees are working at the headquaters
3. Most of the employees in the company are White.
4. Engineering department has the most numbers of employees in the company.
5. Most of the employees in the company are aged 51+
6. The year 2020 recorded the highest % hire change

  
