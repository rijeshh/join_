create table departments (
    department_id int primary key,
    department_name varchar(50)
);

create table employees (
    employee_id int primary key,
    name varchar(50),
    department_id int,
    salary int,
    foreign key (department_id) references departments(department_id)
);

create table projects (
    project_id int primary key,
    project_name varchar(50)
);

create table employee_projects (
    employee_id int,
    project_id int,
    foreign key (employee_id) references employees(employee_id),
    foreign key (project_id) references projects(project_id)
);


--values
insert into departments values
(1,'IT'),
(2,'HR'),
(3,'Finance'),
(4,'Marketing');

insert into employees values
(1,'Ram',1,60000),
(2,'Sita',2,45000),
(3,'Hari',1,70000),
(4,'Gita',3,55000),
(5,'Shyam',null,40000);

insert into projects values
(1,'Website Development'),
(2,'Payroll System'),
(3,'Marketing Campaign'),
(4,'Mobile App');

insert into employee_projects values
(1,1),
(1,4),
(2,2),
(3,1),
(4,2),
(4,3);
