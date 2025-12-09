/* -------------------------------------------------------------
   MODULE 3: GENRE ANALYSIS
   -------------------------------------------------------------
   GOALS:
   - Genre frequency
   - Genre split logic
   - Country-wise genre popularity
   - Movie vs TV genre comparison
   - Genre trend by decade

   Write all genre analysis queries below.
*/


/* -------------------------------------------------------------
   MODULE 3: GENRE ANALYSIS — QUESTION SET
   ------------------------------------------------------------- */

/* 1. Find the total number of titles for each genre. */
SELECT
    listed_in AS genre,
    COUNT(*) AS total_titles
FROM netflixdata
GROUP BY listed_in
ORDER BY total_titles DESC;


/* 2. List the top 5 most frequent genres based on total titles. */
SELECT
    listed_in AS Most_frequent_genre,
    COUNT(*) AS total_titles
FROM netflixdata
GROUP BY listed_in
ORDER BY total_titles DESC LIMIT 5;

/* 3. For each title, extract the first genre from the 'listed_in' column. */
/* 3. For each title, extract the first genre from the 'listed_in' column. */
SELECT
    title,
    listed_in,
    SUBSTRING_INDEX(listed_in, ',', 1) AS first_genre
FROM netflixdata;


/* 5. Show the most popular genre for each country based on total number of titles */
SELECT country, genre, total_titles
FROM (
    SELECT
        country,
        listed_in AS genre,
        COUNT(*) AS total_titles,
        ROW_NUMBER() OVER (PARTITION BY country ORDER BY COUNT(*) DESC) AS rn
    FROM netflixdata
    WHERE country IS NOT NULL
    GROUP BY country, listed_in
) AS t
WHERE rn = 1;


/* 10. For each title, classify its genre as:
        - 'Entertainment' (Comedy, Drama, Action)
        - 'Informative' (Documentary)
        - 'Kids' (Children, Family)
        - 'Other' (All remaining genres) */
SELECT
title,
type,
listed_in,
CASE
	WHEN listed_in LIKE '%Comedy%'
    OR listed_in LIKE '%Drama%'
    OR listed_in LIKE '%Action%'
    THEN 'Entertainment'
    
    WHEN listed_in LIKE '%Documentary%'
    THEN 'Informative'
    
    WHEN listed_in LIKE '%Children%'
    OR listed_in LIKE '%Family%'
    THEN 'Kids'
    
    ELSE 'Other'
END AS Classification
FROM netflixdata
ORDER BY type;


/* 11. Count how many multi-genre titles exist (titles with more than one genre). */
SELECT 
    COUNT(*) AS multi_genre_count
FROM netflixdata
WHERE LENGTH(listed_in) - LENGTH(REPLACE(listed_in, ',', '')) > 1;

/* 12. Find the rarest genre (genre with the lowest number of titles). */
SELECT genre,
 genre_count
FROM (
    SELECT
        listed_in AS genre,
        COUNT(*) OVER (PARTITION BY listed_in) AS genre_count
    FROM netflixdata
) AS t
ORDER BY genre_count ASC
LIMIT 1;

