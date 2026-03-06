
-- This query retrieves the names of employees
-- who do not belong to any department. 
select * from projects;  
select * from employee_projects;

select e.name, d.department_name from employees e
left join departments d
on e.department_id= d.department_id
where d.department_name is null

--employee who works on more than one projects


select e.name,
count(ep.project_id)  
from employees e
join employee_projects ep
on e.employee_id = ep.employee_id
group by e.name
having count(ep.project_id) > 1

--Show department name and number of employees

select d.department_name,
count(e.employee_id) from departments d
left join employees e
on d.department_id = e.department_id
group by d.department_name


select * from departments
select * from employees
select * from employee_projects
select * from projects

--Show employees and their projects
--(including employees without projects)

select e.name,p.project_name 
from employees e
left join employee_projects ep
on e.employee_id = ep.employee_id
left join projects p
on ep.project_id = p.project_id

--Show projects and the employees working on them

select p.project_name,
e.name from projects p
left join employee_projects ep
on p.project_id = ep.project_id
left join employees e
on ep.employee_id = e.employee_id

--Show the highest paid employee in each department

select *
from departments d
join employees e
on d.department_id = e.department_id
where 
e.salary =(
    select max(e2.salary) from employees e2
    where e2.department_id = d.department_id
    )


select e.name,
p.project_name,
d.department_name
from employees e
join employee_projects ep
on e.employee_id = ep.employee_id
join projects p
on ep.project_id = p.project_id
join departments d
on e.department_id = d.department_id

