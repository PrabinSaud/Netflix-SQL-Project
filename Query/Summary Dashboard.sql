/* -------------------------------------------------------------
   MODULE 2: SUMMARY DASHBOARD
   -------------------------------------------------------------
   GOALS:
   - Count total titles
   - Count movies vs TV shows
   - Most common countries
   - Most common genres
   - Most common rating
   - Titles added by year
   - Release year trend analysis 
   */
   
   
/* -------------------------------------------------------------
   STEP 1: Count total titles
   ------------------------------------------------------------- */
   SELECT 
	COUNT(title) AS Total_title
   FROM netflixdata;

/* -------------------------------------------------------------
   STEP 2: Count movies vs TV shows
   ------------------------------------------------------------- */
SELECT 
	type,
    COUNT(*) AS Total_Count
FROM netflixdata
GROUP BY type;

/* -------------------------------------------------------------
   STEP 3: Most common countries
   ------------------------------------------------------------- */
SELECT 
	country,
	COUNT(*) AS Common_countries
FROM netflixdata
WHERE country IS NOT NULL
GROUP BY country
ORDER BY Common_countries DESC;

/* -------------------------------------------------------------
   STEP 4: Most common genres
   ------------------------------------------------------------- */
SELECT 
	listed_in,
	COUNT(*) AS Common_genres
FROM netflixdata
WHERE listed_in IS NOT NULL
GROUP BY listed_in
ORDER BY Common_genres DESC ;

/* -------------------------------------------------------------
   STEP 5: Most common rating
   ------------------------------------------------------------- */
SELECT 
	rating,
	COUNT(*) AS Common_rating
FROM netflixdata
WHERE rating IS NOT NULL
GROUP BY rating
ORDER BY Common_rating DESC ;

/* -------------------------------------------------------------
   STEP 6: Titles added by Date
   ------------------------------------------------------------- */
SELECT
	title,
	date_added
FROM netflixdata
WHERE date_added IS NOT NULL
ORDER BY date_added DESC;

/* -------------------------------------------------------------
   STEP 7: Release year trend analysis
   ------------------------------------------------------------- */
SELECT
    release_year,
    COUNT(*) AS total_titles
FROM netflixdata
WHERE release_year IS NOT NULL
GROUP BY release_year
ORDER BY release_year DESC;
