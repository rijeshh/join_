--==================== Subqueries ====================
-- Subqueries are queries nested inside another query. 
--They can be used in various clauses such as SELECT, FROM, WHERE, and HAVING.


--==================== Scalar Subqueries ====================
-- Example: Find job titles that have an average salary above the overall average salary.
select job_title_short,
salary_year_avg
from job_postings_fact
    where salary_year_avg>
        (
            select avg(salary_year_avg) 
            from job_postings_fact
        )
limit 10;

select job_title_short,
max(salary_year_avg) as max_salary
from job_postings_fact
group by job_title_short
order by max_salary desc

--==================== Multiple-Column/multiple-row Subqueries ====================
--multiple column subqueries return more than one column and/or more than one row.
select job_title_short,job_title,
job_health_insurance,
salary_year_avg
from job_postings_fact
where (job_title_short, salary_year_avg) in
(
    select job_title_short,
    max(salary_year_avg) 
    from job_postings_fact
    group by job_title_short

)
order by salary_year_avg desc

--==================single column/multiple-row subqueries ====================
--single column/multiple-row subqueries return one column but multiple rows.

select job_title_short, salary_year_avg
from job_postings_fact
 where salary_year_avg is null
 limit 10



--===================== Correlated Subqueries ====================
/**
correlated subquery
→ runs again and again
→ runs once for every row in outer query
→ depends on outer query column

that’s why it’s called “correlated” (connected).
**/

--find jobs that pay more than the average salary for that same job title.
select job_title_short,
job_title,
salary_year_avg
from job_postings_fact as j1
where salary_year_avg>
(
    select avg(j2.salary_year_avg)
    from job_postings_fact as j2
    where j1.job_title_short = j2.job_title_short
)
limit 100



--find job postings where the salary is higher than the average salary of that job_schedule_type.

select job_title_short,
job_title,
salary_year_avg
from job_postings_fact as j1
where salary_year_avg is not null 
and salary_year_avg>
(
    select avg(j2.salary_year_avg)
    from job_postings_fact as j2
    where j1.job_schedule_type = j2.job_schedule_type  --j1.job_schedule_type = j2.job_schedule_type 
                                                       --ensures you compare salaries within the same schedule type.
)


select job_title_short from job_postings_fact limit 100

select job_title_short,
job_title
from job_postings_fact as j1
where 
(
    select max(j2.salary_year_avg)
    from job_postings_fact as j2
    where j1.job_title_short = j2.job_title_short
)>150000
limit 100


select 
job_title_short,
job_title,
max(salary_year_avg)
from job_postings_fact
group by job_title_short, job_title
having max(salary_year_avg)>150000
limit 100


--find job titles that have more job postings than the average postings per job title.


select 
        job_title_short,
        count(*) as total_jobs
        from job_postings_fact
        group by  job_title_short
        having 
        count(*)>
        (
            select avg(jobs_count) as avg_num
            from (
                select count(*) as jobs_count
                from job_postings_fact
                group by job_title_short
            )

        )

select job_title_short
from job_postings_fact 
group by job_title_short
having count(*)>(
select avg(post_count) 
from
(
    select count(*) as post_count
    from job_postings_fact
    group by job_title_short
)
)



select job_title_short,job_title,salary_year_avg    
from job_postings_fact as j1
where j1.salary_year_avg is not null and
j1.salary_year_avg=
(
    select max(j2.salary_year_avg)
    from job_postings_fact as j2
    where j1.job_title_short=j2.job_title_short
)



select job_title_short, job_title, salary_year_avg
from job_postings_fact as j1
where salary_year_avg is not null and
salary_year_avg=
(
    select max(salary_year_avg)
    from job_postings_fact
    where job_title_short = j1.job_title_short
)


--find job postings where salary is below the average salary of that company.


select job_title_short, job_title, salary_year_avg
from job_postings_fact as j1
where salary_year_avg is not null and
salary_year_avg<
(
    select avg(salary_year_avg)
    from job_postings_fact
    where j1.job_title_short = job_title_short
)