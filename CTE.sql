/**create table employeez (
    e_id int primary key,
    name varchar(200),
    department varchar(200),
    salary int
);

insert into employeez values
(1,'Ram','IT',60000),
(2,'Sita','HR',45000),
(3,'Hari','IT',70000),
(4,'Gita','Finance',55000),
(5,'Shyam','HR',40000),
(6,'Maya','Marketing',50000),
(7,'Ravi','Marketing',52000);

select * from employeez;    

select * ,
round(avg(salary) over (order by department),2)
 as avg_salary_per_dep

from employeez;

with avg as (
    select department,
    round(avg(salary),2) as avg_salary_per_dep
    from employeez
    group by department
    )
select d.department,
d.name,
a.avg_salary_per_dep
from employeez d
join avg a
on d.department = a.department
order by a.avg_salary_per_dep desc;**/

CREATE TABLE employeess (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    department_id INT,
    salary INT
);

INSERT INTO employeess 
(employee_id, name, department_id, salary) VALUES
(1, 'Alice', 1, 5000),
(2, 'Bob', 2, 6000),
(3, 'Carol', 2, 7000),
(4, 'Dave', 1, 5500),
(5, 'Eve', 3, 4000);

CREATE TABLE departmentss (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

INSERT INTO departmentss (department_id, department_name) VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Sales');

CREATE TABLE projectss (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    department_id INT
);

INSERT INTO projectss (project_id, project_name, department_id) VALUES
(1, 'Website', 2),
(2, 'Recruitment', 1),
(3, 'Marketing', 3);

CREATE TABLE employee_projectss (
    employee_id INT,
    project_id INT,
    PRIMARY KEY (employee_id, project_id)
);

INSERT INTO employee_projectss (employee_id, project_id) VALUES
(1, 2),
(2, 1),
(3, 1),
(4, 2),
(5, 3);



select * from employeess

--CTE that selects all employees earning 
--more than 5000 and show their names and salary.

with sal as (
    select name,salary ,employee_id
    from employeess 
    where salary > 5000 
)

select * from sal

select * from department

--CTE that stores employees from the IT department

with emp as 
(
    select e.name,d.department_name
    from employeess e
    join departmentss d 
    on e.department_id = d.department_id
    where d.department_name = 'IT'
)

select * from employeess

-- CTE that calculates average salary per department, then list employees 
--whose salary is higher than their department average.

with average as(
    select
    round(avg(salary),2) as avg
    from employeess

)

select e.name,e.salary from employeess e
cross join average a
where e.salary>a.avg

--or

with avg2 as (
    select round(avg(salary)) as avgg
    from employeess
)
select name,salary 
from employeess 
where salary > (select avgg from avg2)

--===========================================================
--counts how many employees are in each department, then display 
--only departments with more than 1 employee.
with countt as (
    select d.department_name, 
    count(e.name) as no_of_employee
    from employeess e
    join departmentss d
    on e.department_id=d.department_id
    group by d.department_name
)

select * from countt 
where no_of_employee>1

--===============================================
with joinn as (
    select *
    from employeess e
    join departmentss d
    on e.department_id=d.department_id 
)
select 
name,
department_name,
salary
from joinn    
-- employee with their respective working projects============
with emp_pro as (
    select name,
   
    department_name,
    project_name,
     salary from employeess e
    join departments d
    on e.department_id=d.department_id
    left join projectss p
    on p.department_id=d.department_id

)

select * from emp_pro
where project_name = 'Website'


--========================== total emp per department/// avg salary per depp============
with total_emp as (
    select d.department_name,
    count(*)  as total_employee
    from employeess e
    join departmentss d
    on e.department_id=d.department_id
    group by department_name
),
 avg_sal as (
    select d.department_name,
    round(avg (e.salary),2)  as avg_salary
    from employeess e
    join departmentss d
    on e.department_id=d.department_id
    group by department_name
)

select 
    te.department_name,
    te.total_employee,
    asal.avg_salary
    from total_emp as te
    join avg_sal as asal
    on te.department_name=asal.department_name

-- ========================OR-============================
with total_emp as (
    select dd.department_id,dd.department_name,
    count(*)  as total_employee
    from employeess e
    join departmentss dd
    on dd.department_id=e.department_id 
    group by dd.department_id, dd.department_name),

 avg_sal as(
    select department_id,
    round(avg(salary),2) as salary_average
    from employeess
    group by department_id
)

select 
   te.department_id
   ,te.department_name,
   te.total_employee,
   ass.salary_average
   from total_emp as te
   join avg_sal as ass
   on ass.department_id=te.department_id
   order by department_id asc

select * from departmentss
select * from employeess

--============================= ranking high paid employee ===================
with salary_ranking as (select e.name ,
    e.salary,
    d.department_name,
    row_number() over (partition by department_name
    order by e.salary desc) as salary_rank
from employeess e
    join departmentss d
    on e.department_id=d.department_id)

select * from salary_ranking where salary_rank = 1

--==================CTE that finds the total salary expense per department,
--============ then display departments where the total salary is above 10000.
with total_salary as (
    select 
           d.department_name,
           sum (e.salary) as dep_total_exp
    from employeess e
    join departmentss d
    on d.department_id=e.department_id
    group by d.department_name
         
)
select * from total_salary
select * from total_salary where dep_total_exp > 10000