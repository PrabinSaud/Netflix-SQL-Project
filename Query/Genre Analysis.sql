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




/* 6. Compare genre count between Movies and TV Shows 
      (which genres Movies dominate vs TV Shows dominate). */

/* 7. Find the number of titles released per decade for every genre. */

/* 8. Identify genres that appear in more than 30 countries. */

/* 9. Show genres where the average release year is higher than 2010. */

/* 10. For each title, classify its genre as:
        - 'Entertainment' (Comedy, Drama, Action)
        - 'Informative' (Documentary)
        - 'Kids' (Children, Family)
        - 'Other' (All remaining genres) */

/* 11. Count how many multi-genre titles exist (titles with more than one genre). */

/* 12. Find the rarest genre (genre with the lowest number of titles). */

/* 13. Show countries that have at least 10 titles in the 'Documentary' genre. */

/* 14. Calculate the percentage contribution of each genre to total titles. */

/* 15. List genres whose count is above the global average genre count. */

/* 16. Identify the fastest growing genre by comparing titles before and after 2015. */

/* 17. Show how many genres each country contributes to (genre diversity score). */

/* 18. For each genre, show:
        - Oldest title release year
        - Newest title release year */

/* 19. List genres that appear in both Movies and TV Shows. */

/* 20. Tag genres as:
        - 'High Volume' (> 500 titles)
        - 'Medium Volume' (200–500 titles)
        - 'Low Volume' (< 200 titles) */
