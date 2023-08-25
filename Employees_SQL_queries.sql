
In this project, I delve into a comprehensive analysis of the workforce composition and salary distribution within a company over the span of twelve years,
from 1990 to 2002. My primary focus is to address critical questions regarding gender diversity, managerial distribution, and salary disparities across 
departments and years. To conduct this analysis, I use employees_mod data sets that include employee records spanning from 1990 to 2002. These records encompass
employee gender, department, year of employment, managerial roles, and salary information. This project culminates in a comprehensive report that presents a
holistic view of gender diversity, managerial distribution, and salary disparities within the company. The report provides actionable insights, enabling the
company's decision-makers to develop targeted strategies for improving gender balance, promoting diversity in leadership roles, and addressing potential 
gender-based salary inequalities.



/*  What is the breakdown between the male and female employees working in the company each year, starting from 1990?*/

SELECT 
    YEAR(d.from_date) AS calendar_year,
    e.gender,    
    COUNT(e.emp_no) AS num_of_employees
FROM     
     t_employees e         
          JOIN    
     t_dept_emp d ON d.emp_no = e.emp_no
GROUP BY calendar_year , e.gender 
HAVING calendar_year >= 1990;

/*Lets compare the number of male managers to the number of female managers from different departments for each year, starting from 1990.*/
SELECT 
    d.dept_name,
    ee.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calendar_year,
    CASE
        WHEN YEAR(dm.to_date) >= e.calendar_year AND YEAR(dm.from_date) <= e.calendar_year THEN 1
        ELSE 0
    END AS active
FROM
    (SELECT 
        YEAR(hire_date) AS calendar_year
    FROM
        t_employees
    GROUP BY calendar_year) e
        CROSS JOIN
    t_dept_manager dm
        JOIN
    t_departments d ON dm.dept_no = d.dept_no
        JOIN 
    t_employees ee ON dm.emp_no = ee.emp_no
ORDER BY dm.emp_no, calendar_year;

/*Compare the average salary of female versus male employees in the entire company until year 2002, and add a filter allowing you to see that per each department.*/

SELECT 
    e.gender,
    d.dept_name,
    ROUND(AVG(s.salary), 2) AS salary,
    YEAR(s.from_date) AS calendar_year
FROM
    t_salaries s
        JOIN
    t_employees e ON s.emp_no = e.emp_no
        JOIN
    t_dept_emp de ON de.emp_no = e.emp_no
        JOIN
    t_departments d ON d.dept_no = de.dept_no
GROUP BY d.dept_no , e.gender , calendar_year
HAVING calendar_year <= 2002
ORDER BY d.dept_no;

