-- MySQL Data Cleaning Script for Layoffs Dataset
-- This script removes duplicates, standardizes data, handles NULL values, and drops unnecessary columns.

-- Step 1: Create a duplicate table for cleaning
CREATE TABLE IF NOT EXISTS layoffs_staging LIKE layoffs;

-- Verify the table creation
SELECT * FROM layoffs_staging;

-- Insert data into the staging table
INSERT INTO layoffs_staging SELECT * FROM layoffs;

-- Step 2: Identify and remove duplicates
WITH dup_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company, industry, total_laid_off, percentage_laid_off, date, country, stage, funds_raised_millions, location
           ) AS row_num
    FROM layoffs_staging
)
SELECT * FROM dup_cte WHERE row_num > 1; -- Identify duplicates

-- Create a new table to store cleaned data
CREATE TABLE IF NOT EXISTS layoffs_staging2 (
    company TEXT,
    location TEXT,
    industry TEXT,
    total_laid_off INT DEFAULT NULL,
    percentage_laid_off TEXT,
    date TEXT,
    stage TEXT,
    country TEXT,
    funds_raised_millions INT DEFAULT NULL,
    row_num INT
);

-- Insert cleaned data into the new staging table
INSERT INTO layoffs_staging2
SELECT *,
       ROW_NUMBER() OVER (
           PARTITION BY company, industry, total_laid_off, percentage_laid_off, date, country, stage, funds_raised_millions, location
       ) AS row_num
FROM layoffs_staging;

-- Remove duplicate rows
DELETE FROM layoffs_staging2 WHERE row_num > 1;

-- Step 3: Standardize Data (Trim spaces and correct spelling)
-- Trim spaces from company names
UPDATE layoffs_staging2 SET company = TRIM(company);

-- Standardize industry names (e.g., fixing 'Crypto')
UPDATE layoffs_staging2 SET industry = 'Crypto' WHERE industry LIKE '%rypto%';

-- Standardize country names
UPDATE layoffs_staging2 SET country = 'United States' WHERE country LIKE 'United States%';

-- Convert `date` column to DATE format
ALTER TABLE layoffs_staging2 MODIFY COLUMN `date` DATE;
UPDATE layoffs_staging2 SET date = STR_TO_DATE(date, '%m/%d/%Y');

-- Step 4: Handle NULL Values
-- Identify rows with NULL total_laid_off and percentage_laid_off
SELECT * FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- Attempt to fill NULL industry values based on existing data
WITH industry_filled AS (
    SELECT company, industry
    FROM layoffs_staging2
    WHERE industry IS NOT NULL AND industry <> ''
)
UPDATE layoffs_staging2 
SET industry = (SELECT industry FROM industry_filled WHERE industry_filled.company = layoffs_staging2.company)
WHERE industry IS NULL OR industry = '';

-- Step 5: Remove Useless Data
DELETE FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- Drop the row_num column since it's no longer needed
ALTER TABLE layoffs_staging2 DROP COLUMN row_num;

-- Final Verification
SELECT * FROM layoffs_staging2;
-- MySQL Data Cleaning Script for Layoffs Dataset
-- This script removes duplicates, standardizes data, handles NULL values, and drops unnecessary columns.

-- Step 1: Create a duplicate table for cleaning
CREATE TABLE IF NOT EXISTS layoffs_staging LIKE layoffs;

-- Verify the table creation
SELECT * FROM layoffs_staging;

-- Insert data into the staging table
INSERT INTO layoffs_staging SELECT * FROM layoffs;

-- Step 2: Identify and remove duplicates
WITH dup_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company, industry, total_laid_off, percentage_laid_off, date, country, stage, funds_raised_millions, location
           ) AS row_num
    FROM layoffs_staging
)
SELECT * FROM dup_cte WHERE row_num > 1; -- Identify duplicates

-- Create a new table to store cleaned data
CREATE TABLE IF NOT EXISTS layoffs_staging2 (
    company TEXT,
    location TEXT,
    industry TEXT,
    total_laid_off INT DEFAULT NULL,
    percentage_laid_off TEXT,
    date TEXT,
    stage TEXT,
    country TEXT,
    funds_raised_millions INT DEFAULT NULL,
    row_num INT
);

-- Insert cleaned data into the new staging table
INSERT INTO layoffs_staging2
SELECT *,
       ROW_NUMBER() OVER (
           PARTITION BY company, industry, total_laid_off, percentage_laid_off, date, country, stage, funds_raised_millions, location
       ) AS row_num
FROM layoffs_staging;

-- Remove duplicate rows
DELETE FROM layoffs_staging2 WHERE row_num > 1;

-- Step 3: Standardize Data (Trim spaces and correct spelling)
-- Trim spaces from company names
UPDATE layoffs_staging2 SET company = TRIM(company);

-- Standardize industry names (e.g., fixing 'Crypto')
UPDATE layoffs_staging2 SET industry = 'Crypto' WHERE industry LIKE '%rypto%';

-- Standardize country names
UPDATE layoffs_staging2 SET country = 'United States' WHERE country LIKE 'United States%';

-- Convert `date` column to DATE format
ALTER TABLE layoffs_staging2 MODIFY COLUMN `date` DATE;
UPDATE layoffs_staging2 SET date = STR_TO_DATE(date, '%m/%d/%Y');

-- Step 4: Handle NULL Values
-- Identify rows with NULL total_laid_off and percentage_laid_off
SELECT * FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- Attempt to fill NULL industry values based on existing data
WITH industry_filled AS (
    SELECT company, industry
    FROM layoffs_staging2
    WHERE industry IS NOT NULL AND industry <> ''
)
UPDATE layoffs_staging2 
SET industry = (SELECT industry FROM industry_filled WHERE industry_filled.company = layoffs_staging2.company)
WHERE industry IS NULL OR industry = '';

-- Step 5: Remove Useless Data
DELETE FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- Drop the row_num column since it's no longer needed
ALTER TABLE layoffs_staging2 DROP COLUMN row_num;

-- Final Verification
SELECT * FROM layoffs_staging2;
