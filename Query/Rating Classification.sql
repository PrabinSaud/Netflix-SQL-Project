  /*-------------------------------------------------------------
   MODULE 4: RATING CLASSIFICATION
   -------------------------------------------------------------
   AGE GROUP CATEGORIES:
   - Kids: G, TV-Y, TV-Y7, TV-G
   - Teens: PG, PG-13, TV-14
   - Adults: R, TV-MA, NC-17

   ANALYSIS GOALS:
   - Count titles per age group
   - Distribution per country
   - Genre-based rating comparison
   -------------------------------------------------------------*/

/* 1. List all titles with their rating. */
SELECT
	title,
	rating
FROM netflixdata;


/* 2. Count how many titles exist for each rating. */
SELECT
	rating,
	COUNT(title) AS Title_Count
FROM netflixdata
GROUP BY rating;


/* 3. Count how many movies vs TV shows exist for each rating. */
SELECT
    type,
    rating,
    COUNT(*) AS total_titles
FROM netflixdata
GROUP BY type, rating
ORDER BY type, total_titles DESC;


/* 4. Find all titles that have the "TV-MA" rating. */
SELECT 
	title,
	rating
FROM netflixdata
WHERE rating ='TV-MA';


/* 5. Find all titles that have the "PG-13" rating. */
SELECT 
	title,
	rating
FROM netflixdata
WHERE rating ='PG-13';

/* 6. Create an age group column using CASE (Kids, Teens, Adults). */
SELECT
*,
CASE 
	WHEN rating IN ('G', 'TV-Y', 'TV-G') THEN 'Kids'
	WHEN rating IN ('PG', 'TV-Y7', 'TV-PG') THEN 'Teens'
	WHEN rating IN ('PG-13', 'TV-14', 'R', 'TV-MA') THEN 'Adults'
	ELSE 'Other'
END AS Age_group
FROM netflixdata;

/* 7. Show each title with its age group category. */
SELECT
title,
CASE 
	WHEN rating IN ('G', 'TV-Y', 'TV-G') THEN 'Kids'
	WHEN rating IN ('PG', 'TV-Y7', 'TV-PG') THEN 'Teens'
	WHEN rating IN ('PG-13', 'TV-14', 'R', 'TV-MA') THEN 'Adults'
	ELSE 'Other'
END AS Age_group
FROM netflixdata
ORDER BY Age_group;

/* 8. Count how many titles belong to each age group category. */
SELECT
CASE 
	WHEN rating IN ('G', 'TV-Y', 'TV-G') THEN 'Kids'
	WHEN rating IN ('PG', 'TV-Y7', 'TV-PG') THEN 'Teens'
	WHEN rating IN ('PG-13', 'TV-14', 'R', 'TV-MA') THEN 'Adults'
	ELSE 'Other'
END AS Age_group,
COUNT(title) AS Total_title_count 
FROM netflixdata
GROUP BY Age_group;


/* 9. Count how many movies fall into each age group category. */
SELECT
CASE 
	WHEN rating IN ('G', 'TV-Y', 'TV-G') THEN 'Kids'
	WHEN rating IN ('PG', 'TV-Y7', 'TV-PG') THEN 'Teens'
	WHEN rating IN ('PG-13', 'TV-14', 'R', 'TV-MA') THEN 'Adults'
	ELSE 'Other'
END AS Age_group,
SUM(CASE WHEN type = 'Movie' THEN 1 ELSE 0 END) AS Number_Movies
FROM netflixdata
GROUP BY Age_group;

/* 10. Count how many TV shows fall into each age group category. */
SELECT
CASE 
	WHEN rating IN ('G', 'TV-Y', 'TV-G') THEN 'Kids'
	WHEN rating IN ('PG', 'TV-Y7', 'TV-PG') THEN 'Teens'
	WHEN rating IN ('PG-13', 'TV-14', 'R', 'TV-MA') THEN 'Adults'
	ELSE 'Other'
END AS Age_group,
SUM(CASE WHEN type = 'TV Show' THEN 1 ELSE 0 END) AS Number_TVshows
FROM netflixdata
GROUP BY Age_group;

/* 11. List all Kids category titles based on the classification. */
SELECT
title,
CASE 
	WHEN rating IN ('G', 'TV-Y', 'TV-G') THEN 'Kids'
	WHEN rating IN ('PG', 'TV-Y7', 'TV-PG') THEN 'Teens'
	WHEN rating IN ('PG-13', 'TV-14', 'R', 'TV-MA') THEN 'Adults'
	ELSE 'Other'
END AS Age_group
FROM netflixdata
WHERE rating IN ('G', 'TV-Y', 'TV-G')
ORDER BY Age_group;


/* 12. List all Adults category titles based on the classification. */
SELECT
title,
CASE 
	WHEN rating IN ('G', 'TV-Y', 'TV-G') THEN 'Kids'
	WHEN rating IN ('PG', 'TV-Y7', 'TV-PG') THEN 'Teens'
	WHEN rating IN ('PG-13', 'TV-14', 'R', 'TV-MA') THEN 'Adults'
	ELSE 'Other'
END AS Age_group
FROM netflixdata
WHERE rating IN('PG-13', 'TV-14', 'R', 'TV-MA')
ORDER BY Age_group;


-- FROM ChatGPT


/* 13. Show the top countries with the most Kids category titles. */
WITH kids_titles AS (
    SELECT *
    FROM netflixdata
    WHERE rating IN ('G', 'TV-Y', 'TV-G')
),
country_split AS (
    SELECT
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(country, ',', n.n), ',', -1)) AS country
    FROM kids_titles
    JOIN (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) n
      ON n.n <= 1 + LENGTH(country) - LENGTH(REPLACE(country, ',', ''))
)
SELECT 
    country,
    COUNT(*) AS kids_title_count
FROM country_split
GROUP BY country
ORDER BY kids_title_count DESC
LIMIT 10;



/* 14. Show the top genres that appear in the Adults category. */
WITH adults_titles AS (
    SELECT *
    FROM netflixdata
    WHERE rating IN ('PG-13', 'TV-14', 'R', 'TV-MA')
),
genre_split AS (
    SELECT
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', n.n), ',', -1)) AS genre
    FROM adults_titles
    JOIN (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) n
      ON n.n <= 1 + LENGTH(listed_in) - LENGTH(REPLACE(listed_in, ',', ''))
)
SELECT 
    genre,
    COUNT(*) AS adults_count
FROM genre_split
GROUP BY genre
ORDER BY adults_count DESC
LIMIT 10;



/* 15. Show the distribution of ratings by genre. */
WITH genre_split AS (
    SELECT
        rating,
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', n.n), ',', -1)) AS genre
    FROM netflixdata
    JOIN (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) n
      ON n.n <= 1 + LENGTH(listed_in) - LENGTH(REPLACE(listed_in, ',', ''))
)
SELECT
    genre,
    rating,
    COUNT(*) AS title_count
FROM genre_split
GROUP BY genre, rating
ORDER BY genre, title_count DESC;
