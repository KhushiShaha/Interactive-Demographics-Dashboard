Select *
from Race.dbo.ultracleanedupdata_output

--How many States were represented in the race
Select COUNT(Distinct state) as distinct_count
from Race.dbo.ultracleanedupdata_output

--What wa the average time of Men Vs Women
Select Gender, AVG(total_minutes) as avg_time
from Race.dbo.ultracleanedupdata_output
Group by Gender

--What were the youngest and oldest ages in the race
Select Gender, Min(age) as youngest, Max(age) as oldest
from Race.dbo.ultracleanedupdata_output
group by Gender

--What was the average time for each age group
with age_buckets as (
select total_minutes,
	case when age < 30 then 'age_20-29'
		 when age < 40 then 'age_30-39'
		 when age < 50 then 'age_40-49'
		 when age < 60 then 'age_50-59'
	else 'age_60+' end as age_group
from Race.dbo.ultracleanedupdata_output
)

select age_group, avg(total_minutes) avg_race_time
from age_buckets
group by age_group

--Top 3 Males and Females

with gender_rank as (
Select rank() over (partition by Gender order by total_minutes asc) as gender_rank,
fullname,
gender,
total_minutes
from Race.dbo.ultracleanedupdata_output
)

select * 
from gender_rank
where gender_rank < 4
order by total_minutes