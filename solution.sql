-- Netflix Project
drop table if exists netflix;
create table netflix
(
show_id varchar(10),
type varchar(10),
title varchar(150),
director varchar(250),
casts varchar(1000),
country varchar(150),
date_added varchar(50),
release_year int,
rating varchar(10),
duration varchar(15),
listed_in varchar(150),
description varchar(250)
);
select * from netflix;

select count(*) as total_content
from netflix;

select distinct type
from netflix;

-- 15 Business Problems
-- 1. count the number of Movies vs Tv Shows

select type, 
count(*) as total_content
from netflix
where type in ('Movie','TV Show')
group by type;


--2. Find th most common rating for movies and TV shows

select type,rating,
count(*) as ranking
from netflix
group by type, rating
order by ranking desc;

WITH RankedRatings AS (
    SELECT 
        type, 
        rating, 
        COUNT(*) AS ranking,
        ROW_NUMBER() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rank
    FROM netflix
    GROUP BY type, rating
)
SELECT type, rating, ranking
FROM RankedRatings
WHERE rank = 1;


--3. List all movies released in a specific year (e.g., 2020)

select title --release_year
from netflix
where type = 'Movie' and release_year = '2020';

--4. Findthtop  countries with the most conent on Neflix
select 
	unnest(string_to_array(country, ',')) as new_country,
	count(distinct show_id)as total_content
from netflix
group by 1
order by total_content desc
limit 5;

--5. Identify he longest movie or TVsow dration

select *
from netflix
where 
	type = 'Movie'
	and
	duration = (select max(duration) from netflix)

	
-- 6. Find content addedin the last 5 years

select 
	*,
	to_date(date_added, 'Month DD, YYYY') as Updated_date
from netflix
where 
	to_date(date_added, 'Month DD, YYYY')>= current_date - interval '5 years'; 


-- 7. Find all the movie/TV shows director 'Rajiv Chilaka'!
select *
from(
	select
		*,
		unnest(string_to_array(director,',')) as new_director
from netflix
)subquery
where new_director = 'Rajiv Chilaka'

----- OR 

select *
from netflix
where director ilike '%Rajiv Chilaka%'; -- we use 'ilike' because of case sensitivity

-- 8. List all TV shows with more than 5 seasons


select 
	*
	--split_part(duration, ' ', 1)::numeric or int as seasons - I have to split the duration at spaces and extract the first part
from netflix
where
	type = 'TV Show'
	and
	split_part(duration, ' ', 1)::numeric > 5;




9. Count the number of content items in each genre

select 
	unnest(string_to_array(listed_in, ',')) as genre,
	count(show_id)
from netflix
group by 1
order by count desc;

10. Find each year and the average number of content released in United States on netflix. return top 5 year with highest avg content release

select
	extract(year from to_date(date_added, 'Month DD, YYYY')) as year_added,
	count(*) as yearly_content,
	round(count(*)::numeric/(select count(*) from netflix where country ='United States')::numeric * 100, 2) as avg_content_per_year
from netflix
where 
	country = 'United States'
	and date_added is not null
group by 1;

11. List all movies that are documentaries

select * 
from netflix
where listed_in ilike '%Documentaries%';


12. Find all content without a director

select * 
from netflix
where director is null;


13. Find how many movies actor'' appeared in last 10 years


select *
from netflix
where 
	casts ilike '%Vin Diesel%'
	and 
	release_year >extract(year from current_date) - 10;

14. Find the top 10 actors who have appeared in the highest number of movies produced in United Kingdom


select 
	unnest(string_to_array(casts, ',')) as actors,
	count(show_id) as total_movies_appeared
from netflix
where country ilike '%United Kingdom%'
group by 1
order by 2 desc
limit 10