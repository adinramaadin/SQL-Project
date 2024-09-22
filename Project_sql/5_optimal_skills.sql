/*
Answer: What are the most optimal skills to learn (aka it's in high demand and a high-paying skill)?
- identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on job_location LIKE '%Indonesia%' OR job_country = 'Indonesia' with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
    - offering strategic insights for career development in data related professions
*/

WITH skills_demand AS (
    SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    count(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title LIKE '%Data%' 
    AND salary_year_avg IS NOT NULL
    AND (job_postings_fact.job_location LIKE '%Indonesia%' OR job_country = 'Indonesia')
GROUP BY
    skills_dim.skill_id
), average_salary AS (
    SELECT 
    skills_job_dim.skill_id,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title LIKE '%Data%'
    AND salary_year_avg IS NOT NULL
    AND (job_postings_fact.job_location LIKE '%Indonesia%' OR job_country = 'Indonesia')
GROUP BY
    skills_job_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
ORDER BY
    avg_salary DESC,
    demand_count DESC