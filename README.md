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
- **Dataset Link:** [Dataset](https://github.com/sanmyyung/Netflix_sql_project/blob/main/netflix_titles.csv)

---

## 🗂️ Schema
```sql
CREATE TABLE netflix_content (
    id SERIAL PRIMARY KEY,
    title TEXT,
    type TEXT,
    director TEXT,
    cast TEXT,
    country TEXT,
    release_year INT,
    rating TEXT,
    duration TEXT,
    listed_in TEXT,
    description TEXT
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

###
