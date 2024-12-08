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
- **Dataset Link:** [Dataset]()

---

## 🗂️ Database Schema
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
