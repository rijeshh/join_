
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

-- Show employees, their department, and their projects together
select e.name,
p.project_name,
d.department_name
from employees e
left join employee_projects ep
on e.employee_id = ep.employee_id
left join projects p
on ep.project_id = p.project_id
left join departments d
on e.department_id = d.department_id

select e.name, d.department_name,e.salary,
-- avg(e.salary) over (partition by d.department_name) as avg_salary,
row_number() over (order by e.salary desc) as salary_rank
 from employees e
join departments d
on e.department_id = d.department_id


create table empl 
            (
                e_id int primary key,
                name varchar(200),
                d_id int,
                salary int
                            );
                          
insert into empl values
            ( 1,'ram 1',2, 20000),
            ( 2,'ram 2',1, 30000),
            ( 3,'ram 3',1,50000),
            ( 4,'ram 4',2,70000);
create table dp
                ( 
                    d_id int primary key,
                    name varchar
                )
insert into dp (d_id, name)
values
(1,'HR'),
(2,'data')


--=== emplyoee with salary >sal avg of that dep

select   
        e.name,
        e.salary,
        d.d_id,
        d.name
        from empl as e
join dp d
on   e.d_id=d.d_id
where e.salary>
(
    select avg(salary) as sal_avg_dep
    from empl z
    where z.d_id=e.d_id
    
)
group by d.name


select * from empl


 with sep_Dep as (
    select 
    d.name,
    sum (salary) as salary_sum
    from empl e
    join dp d
    on d.d_id=e.d_id
    group by d.name
 )
select name from sep_Dep where salary_sum>80000

with avgs as (
    select e.name,e.salary,
d.d_id,d.name as dname,
round(avg(e.salary) over(partition by e.d_id),2) as dep_avg_sal
from empl e
join dp d
on e.d_id=d.d_id)
select name, salary, dname, dep_avg_sal from avgs
where salary>dep_avg_sal
