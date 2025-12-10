/* -------------------------------------------------------------
   MODULE 5: DURATION INSIGHTS
   -------------------------------------------------------------
   GOALS:
   - Extract numeric duration
   - Identify longest & shortest movies
   - Extract season count for TV shows
   - Average duration by genre
   - Duration distribution

   Write all duration-based queries below.
*/

/* 1. Add columns to store the numeric value of duration and its type (minutes or seasons) */
ALTER TABLE netflixdata
ADD COLUMN duration_value INT,       -- numeric part of duration
ADD COLUMN duration_type VARCHAR(10);

/* 2. Fill the numeric duration and type columns for all titles */
UPDATE netflixdata
SET 
    duration_value = CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED),
    duration_type = SUBSTRING_INDEX(duration, ' ', -1) ;

/* 3. Find the movie with the longest duration */
SELECT 
title,
type,
duration_value,
duration_type
FROM netflixdata
WHERE type = 'Movie'
ORDER BY duration_value DESC LIMIT 1;

-- OR

SELECT title, 
duration_value AS minutes
FROM netflixdata
WHERE type = 'Movie' AND duration_value = (SELECT MAX(duration_value) FROM netflixdata WHERE type = 'Movie');


/* 4. Find the movie with the shortest duration */
SELECT 
title,
type,
duration_value,
duration_type
FROM netflixdata
WHERE type = 'Movie'
ORDER BY duration_value ASC LIMIT 1;

-- OR

SELECT 
title, 
duration_value AS minutes
FROM netflixdata
WHERE type = 'Movie' AND duration_value = (SELECT MIN(duration_value) FROM netflixdata WHERE type = 'Movie');


/* 5. List all TV shows with the number of seasons */
SELECT
title,
type,
duration_value,
duration_type
FROM netflixdata
WHERE type = 'TV Show'
ORDER BY duration_value DESC;

/* 6. Calculate the average duration of movies for each genre */
SELECT
listed_in AS genre,
ROUND(AVG(duration_value),2) As average 
FROM netflixdata
WHERE type = 'Movie'
GROUP BY listed_in
ORDER BY average DESC;

-- OR

SELECT
listed_in AS genre,
AVG(duration_value) OVER(PARTITION BY listed_in, type ORDER BY duration_value DESC) AS Average
FROM netflixdata
WHERE type = 'Movie';


/* 7. Group movies into duration ranges (<1 hr, 1–1.5 hr, 1.5–2 hr, >2 hr) and count how many titles fall in each range */
SELECT
CASE
	WHEN duration_value < 60 THEN '< 1 hr'
	WHEN duration_value BETWEEN 60 AND 90 THEN '1-1.5 hr'
	WHEN duration_value BETWEEN 91 AND 120 THEN '1.5-2 hr'
	WHEN duration_value > 120 THEN '> 2 hr'
	ELSE 'Unknown'
END AS duration_range,
COUNT(*) AS count_titles
FROM netflixdata
WHERE type = 'Movie'
GROUP BY duration_range
ORDER BY duration_range;

/* 8. Group TV shows by number of seasons (1, 2–3, 4–6, >6) and count how many shows fall in each range */
SELECT
CASE
	WHEN duration_value = 1 THEN '1 Season'
	WHEN duration_value BETWEEN 2 AND 3 THEN '2-3 Seasons'
	WHEN duration_value BETWEEN 4 AND 6 THEN '4-6 Seasons'
	WHEN duration_value > 6 THEN '> 6 Seasons'
	ELSE 'Unknown'
END AS season_range,
COUNT(*) AS count_titles
FROM netflixdata
WHERE type = 'TV Show'
GROUP BY season_range
ORDER BY season_range;
