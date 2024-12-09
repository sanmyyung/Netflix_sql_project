# Netflix Movies and TV shows Data Analytics using SQL
![Netflix Logo](https://github.com/sanmyyung/Netflix_sql_project/blob/main/netflix.jpg)

---

## 📌 Overview
This project is a comprehensive analysis of Netflix's movies and TV shows dataset using SQL in PostgreSQL. The goal is to answer key business questions and uncover meaningful insights about content trends and audience preferences.

---

## 🎯 Objectives
- Analyze the distribution of content types (Movies vs. TV Shows).
- Identify the most common ratings for movies and TV shows.
- Explore content trends by release years, countries, and durations.
- Investigate specific trends in actors and content genres.

---

## 📂 Dataset
- **Dataset Link:** [Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

---

## 🗂️ Schema
```sql
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
```
##  Problems and Solutions
### How many Movies and TV shows are available?
```sql
SELECT type, COUNT(*) AS count
FROM netflix_content
where type in ('Movie','TV Show')
GROUP BY type;
```

### Find th most common rating for movies and TV shows?
```sql
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
```

### How is the content distributed based on release year?
```sql
SELECT
    release_year,
    COUNT(*) AS count
FROM netflix
GROUP BY release_year
ORDER BY release_year ASC;
```

### Which countries have the most Netflix content?
```sql
SELECT
    country,
    COUNT(*) AS total
FROM netflix
GROUP BY country
ORDER BY total DESC
LIMIT 10;
```

### Identify he longest movie or TVsow duration
```sql
select title,  
substring(duration, 1,position ('m' in duration)-1)::int duration
from Netflix
where type = 'Movie' and duration is not null
order by 2 desc
limit 1;
```

### Find content addedin the last 5 years
```sql
select 
	*,
	to_date(date_added, 'Month DD, YYYY') as Updated_date
from netflix
where 
	to_date(date_added, 'Month DD, YYYY')>= current_date - interval '5 years';
```

### Find all the movie/TV shows director 'Rajiv Chilaka'!
```sql
select *
from(
	select
		*,
		unnest(string_to_array(director,',')) as new_director
from netflix
)subquery
where new_director = 'Rajiv Chilaka'
```

### List all TV shows with more than 5 seasons
```sql
select 
	*
	--split_part(duration, ' ', 1)::numeric or int as seasons - I have to split the duration at spaces and extract the first part
from netflix
where
	type = 'TV Show'
	and
	split_part(duration, ' ', 1)::numeric > 5;
```

### Count the number of content items in each genre
```sql
select 
	unnest(string_to_array(listed_in, ',')) as genre,
	count(show_id)
from netflix
group by 1
order by count desc;
```

### Find each year and the average number of content released in United States on netflix. return top 5 year with highest avg content release
```sql
select
	extract(year from to_date(date_added, 'Month DD, YYYY')) as year_added,
	count(*) as yearly_content,
	round(count(*)::numeric/(select count(*) from netflix where country ='United States')::numeric * 100, 2) as avg_content_per_year
from netflix
where 
	country = 'United States'
	and date_added is not null
group by 1;
```

### List all movies that are documentaries
```sql
select * 
from netflix
where listed_in ilike '%Documentaries%';
```

### Find all content without a director
```sql
select * 
from netflix
where director is null;
```

### Find how many movies actor 'Vin Diesel' appeared in last 10 years
```sql
select *
from netflix
where 
	casts ilike '%Vin Diesel%'
	and 
	release_year >extract(year from current_date) - 10;
```

### Find the top 10 actors who have appeared in the highest number of movies produced in United Kingdom
```sql
select 
	unnest(string_to_array(casts, ',')) as actors,
	count(show_id) as total_movies_appeared
from netflix
where country ilike '%United Kingdom%'
group by 1
order by 2 desc
limit 10
```

## 📊 Findings and Conclusion
#### Key Findings:
##### 📊 Movies dominate Netflix's catalog, accounting for approximately 70%.
##### 🌟 TV-MA and TV-14 are the most common ratings.
##### 📅 The 2010s and 2020s witnessed significant growth in content production.
##### 🌍 The United States leads both in movie and TV show production, followed by India and the UK.
##### ⏱️ Movies average 90-120 minutes, while TV shows vary greatly in length.

## Conclusion:
The insights reveal Netflix's strategic focus on original content, global diversity, and an emphasis on recent productions. These findings provide valuable data for enhancing user engagement and targeting specific audience demographics.
