/* -------------------------------------------------------------
   MODULE 6: DIRECTOR & CAST ANALYSIS
   -------------------------------------------------------------
   GOALS:
   - Most frequent directors
   - Most frequent actors
   - Count titles per director
   - Actor co-appearance patterns (optional)
   - Director-country breakdown

   Write all director & cast queries below.
*/
/* 1. Identify the 5 directors who appear most frequently in the dataset */
SELECT 
director,
COUNT(*) AS title_count
FROM netflixdata
WHERE director IS NOT NULL AND director !=''
GROUP BY director
ORDER BY title_count DESC
LIMIT 5;

/* 2. Identify the actors who appear most frequently in the dataset */
SELECT 
cast,
COUNT(*) AS title_count
FROM netflixdata
WHERE cast IS NOT NULL AND cast !=''
GROUP BY cast
ORDER BY title_count DESC
LIMIT 1;

/* 3. Count the number of titles directed by each director */
SELECT
director,
COUNT(*) AS title_count
FROM netflixdata
WHERE director IS NOT NULL AND director != ''
GROUP BY director
ORDER BY title_count DESC;

/* 4. Analyze actor co-appearance patterns (which actors appear together most often) */
SELECT 
title,
cast
FROM netflixdata
WHERE cast LIKE '%,%';


/* 5. Show the breakdown of directors by country (how many titles each director has per country) */
SELECT
director,
country,
COUNT(*) AS total_titles
FROM netflixdata
WHERE director IS NOT NULL AND director != '' AND country != 'Unknown'
GROUP BY director, country
ORDER BY total_titles DESC;
