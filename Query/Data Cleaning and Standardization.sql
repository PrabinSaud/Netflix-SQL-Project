/* =============================================================
   MODEL 1 : DATA CLEANING AND STANDARDIZATION
   ============================================================= 
   
   GOALS:
   - Convert date_added to DATE
   - Clean spaces in text columns
   - Handle missing values
   - Standardize rating categories
   - Extract numeric duration
   - Separate Movie vs TV Show duration types

   Write all data cleaning queries for this module below.
   */

/* -------------------------------------------------------------
   STEP 1: Convert date_added to proper DATE format (Preview)
   ------------------------------------------------------------- */
SELECT 
    show_id,
    STR_TO_DATE(date_added, '%M %d, %Y') AS clean_date
FROM netflixdata;

/* -------------------------------------------------------------
   STEP 2: Update the table to store converted date
   ------------------------------------------------------------- */
UPDATE netflixdata
SET date_added = STR_TO_DATE(date_added, '%M %d, %Y');

/* -------------------------------------------------------------
   STEP 3: Remove extra spaces from text columns
   ------------------------------------------------------------- */
UPDATE netflixdata
SET 
    director = TRIM(director),
    cast = TRIM(cast),
    country = TRIM(country),
    rating = TRIM(rating),
    listed_in = TRIM(listed_in);

/* -------------------------------------------------------------
   STEP 4: Replace NULL or blank country values with 'Unknown'
   ------------------------------------------------------------- */
UPDATE netflixdata
SET country = 'Unknown'
WHERE country IS NULL OR country = '' OR country = ' ';

/* -------------------------------------------------------------
   STEP 5: Standardize rating categories to uppercase
   ------------------------------------------------------------- */
UPDATE netflixdata
SET rating = UPPER(rating);

/* -------------------------------------------------------------
   STEP 6: Extract numeric duration (Preview only)
   ------------------------------------------------------------- */
SELECT
    show_id,
    type,
    duration,
    SUBSTRING_INDEX(duration, ' ', 1) AS duration_value
FROM netflixdata;

/* -------------------------------------------------------------
   STEP 7: Add duration_value column
   ------------------------------------------------------------- */
ALTER TABLE netflixdata
ADD COLUMN duration_value INT;

UPDATE netflixdata
SET duration_value = SUBSTRING_INDEX(duration, ' ', 1)
WHERE duration REGEXP '^[0-9]+';

/* -------------------------------------------------------------
   STEP 8: Add duration_type column
   ------------------------------------------------------------- */
ALTER TABLE netflixdata
ADD COLUMN duration_type VARCHAR(20);

UPDATE netflixdata
SET duration_type = 
    CASE 
        WHEN duration LIKE '%min%' THEN 'Minutes'
        WHEN duration LIKE '%Season%' THEN 'Seasons'
        ELSE 'Unknown'
    END;
    
SELECT * FROM netflixdata;
