use company
------------------------------------------------------------------------------------------------------------------------------
/* 1) How many total employees in this company */
select count(employee_name) as totall_employee from staff

-------------------------------------------------------------------------------------------------------------------------------
/* 2) How many employees in each department */
select department ,count(*) as totall_employee_department from staff
group by department

------------------------------------------------------------------------------------------------------------------------------
/* 3) How many distinct departments ? */
SELECT department, COUNT(DISTINCT department) AS distinct_department
FROM staff
GROUP BY department

---------------------------------------------------------------------------------------------------------------------------------
/* 4) Total number of male and female employee */
SELECT gender, COUNT(employee_name) AS total_employees
FROM staff
GROUP BY gender

---------------------------------------------------------------------------------------------------------------------------------
/* 5) What about gender distribution by department? */

--  5.1) for male
select department,count(gender) as totall_male from staff
where gender ='male'
group by department
order by totall_male desc
-- Data analysis : maximum number of male are working in Industrial department 
-- 					where as minimum number of male are working in kids department

-- 5.2) for female

 select department,count(gender) as totall_female from staff
 where gender ='female'
 group by department
 order by totall_female desc
-- Data analysis : maxmimum number of female are working in home department and where as lowest number 
-- 				   of female are working in movies department 
------------------------------------------------------------------------------------------------------------------------

 /* 6) What about gender perenatge  distribution by each department department? */
select department,count(gender) as totall_gender,
sum(gender='male') as totall_male,
sum(gender='female') as totall_female,
round(sum(gender='male')/count(gender),2)*100 as male_percenatge,
round(sum(gender='female')/count(gender),2)* 100 as female_percenatge from staff
group by department
order by 6 desc
-- Data analysis : highest male percentage is in Industrial department and lowest male percentage is in Home
-- 				   similarly highest female percentage is in Home department and lowest female percentage is in Industrial
------------------------------------------------------------------------------------------------------------------------------
/* 7) Gender pay gap distribution department wise */

SELECT department, 
       AVG(CASE WHEN gender = 'Male' THEN salary END) AS avg_male_salary, 
       AVG(CASE WHEN gender = 'Female' THEN salary END) AS avg_female_salary, 
       ((AVG(CASE WHEN gender = 'Male' THEN salary END) - AVG(CASE WHEN gender = 'Female' THEN salary END)) / AVG(CASE WHEN gender = 'Male' THEN salary END)*100 )AS gender_pay_gap_perentage
FROM staff
WHERE gender IN ('Male', 'Female')
GROUP BY department
order by gender_pay_gap_perentage desc

-- Data Analysis : gender pay gap is highest percenatge for beauty department and lowest for clothing department
------------------------------------------------------------------------------------------------------------------------------
/* 8) How much total salary company is spending each year and by department? */

-- totall salary
select sum(salary) as totall_salary from staff

-- totall salary department wise 
select department, sum(salary) as total_salary from staff
group by department
order by sum(salary) desc

-----------------------------------------------------------------------------------------------------------------------
/* 9) want to know distribution of min, max average salary by department */
select department,min(salary) as min_salary,max(salary) as max_salary,avg(salary) as avg_Salary from staff
group by department
order by avg_Salary desc
-- data Analysis : avg salary of outdoor is highest and lowest avg salary is for jewelery 

-----------------------------------------------------------------------------------------------------------------------
/* 10) what about salary distribution by gender group? */
SELECT gender, MIN(salary) As Min_Salary, MAX(salary) AS Max_Salary, AVG(salary) AS Average_Salary FROM staff
GROUP BY gender
-- Data Analysis: it looks like maximum and minimum salary of both gender are close to each other 

-------------------------------------------------------------------------------------------------------------------------------
 /* 11) which department has the highest salary spread out ? */
select department,count(*) as totall_employee ,min(salary) as min_salary,max(salary) as max_Salary,
round(avg(salary),1) as avg_salary,round(variance(salary),1) as variance,round(std(salary),1) as standard_devaiton from staff
group by department
order by 6 desc
-- Data analysis : salary of minimum,maximum,average salary,standard deviation are very much close to each other 
-- 	 in every department but where as its variance that is very much spreadout and its highest for health department

-------------------------------------------------------------------------------------------------------------------------------
/* 12) so lets find out more about health department*/
with  Earning_capacity as(
select  department ,round (avg(salary) over(partition by department order by salary desc),2) as Average_salary,
 case 
	when salary >=100000 then 'High earner'
    when salary >= 50000 and salary<=100000 then 'medium earner'
    else 'low earner' 
    end as Earnings from staff )
select * from Earning_capacity
where department='health' and earnings='high earner'
-- Data analysis : In case of health department by average salary the earning capacity 
-- 					there are 24 high earner,14 medium earner,8 lo earner

-----------------------------------------------------------------------------------------------------------------------------------
/* 13.1) full details info of employees with company division */
select staff.staff_id,staff.employee_name,staff.department,company_divisions.company_division from staff
inner join  company_divisions
on staff.department=company_divisions.department
 

-- Data analysis: In staff table there are 1000 rows but the query returned 953 rows it implies 
-- 				  that there are 47 rows having null values
 
 /* 13.2) To find out null rows from company division and staff tables */ 
 
select staff.staff_id,staff.employee_name,staff.department,company_divisions.company_division from staff
left join  company_divisions
on staff.department=company_divisions.department
where company_divisions.company_division is null
-- so the only department which doesnt have any company division is books department

-----------------------------------------------------------------------------------------------------------------------------------
/* 14) find out which company region has maximum rank and its country and belongs to which department  */
select s.staff_id,  s.department,s.salary,s.job_designation,c.company_regions,c.country,
dense_RANK() OVER (partition by company_regions order by salary DESC) as regions_rank
from staff s
inner join company_regions c
on s.region_id=c.region_id 
group by  s.staff_id
order by regions_rank desc
limit 1
-- maxmimum rank is for home department belonging to southwest company region from usa country

---------------------------------------------------------------------------------------------------------------------------------- 
 /* 15) calaculate change in salary percentage from maximum salary of each department and find out which department has maximum percenatge change in salary   */ 
select department, employee_name, salary,
first_value(salary) over (partition by department order by salary desc) AS max_salary_department,
round(( first_value(salary) over (partition by department order by salary desc)-salary) / (first_value(salary) over (partition by department order by salary desc)) * 100, 2) as salary_percentage_change
from staff
order by 5 desc

-- maximum change is salary percenatge w.r.t maximum salary for each department is for toys department

-------------------------------------------------------END------------------------------------------------------------------------