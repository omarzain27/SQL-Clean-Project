# Layoffs Data Cleaning Project

## Project Overview
This project focuses on cleaning and processing a layoffs dataset to ensure data quality and integrity. The dataset contains information on company layoffs, industries, locations, funding, and other key attributes. The script performs essential data cleaning tasks, including:

- **Removing Duplicates**: Identifying and eliminating duplicate entries.
- **Standardizing Data**: Ensuring uniform capitalization, correcting spelling errors, and trimming spaces.
- **Handling NULL Values**: Filling missing data where possible and removing unusable records.
- **Dropping Unnecessary Columns**: Keeping only relevant data for better performance.

The cleaned dataset can be used for further analysis, visualization, and insights into global layoffs trends.

## How to Run the Project
1. **Clone or Download the Repository**:
   ```sh
   git clone https://github.com/yourusername/layoffs-data-cleaning.git
   ```
   or download the `.sql` file.

2. **Import the Dataset into MySQL**:
   - Use a MySQL client like **MySQL Workbench** or **phpMyAdmin** to load the `layoffs` dataset.

3. **Execute the Cleaning Script**:
   - Open MySQL Workbench or another SQL editor.
   - Run the script `layoffs_data_cleaning.sql`.

4. **Verify Cleaned Data**:
   - Query the `layoffs_staging2` table to inspect the cleaned data:
   ```sql
   SELECT * FROM layoffs_staging2;
   ```

## Key Steps in Data Cleaning
### 1. Removing Duplicates
- A staging table `layoffs_staging` is created to work with a copy of the original data.
- A **Common Table Expression (CTE)** identifies and removes duplicate records based on key attributes.

### 2. Standardizing Data
- Trims spaces in company names.
- Corrects spelling inconsistencies (e.g., "rypto" → "Crypto").
- Standardizes country names (e.g., "United States of America" → "United States").
- Converts date formats to **YYYY-MM-DD**.

### 3. Handling NULL Values
- Missing **industry** values are inferred from existing data.
- Records with both `total_laid_off` and `percentage_laid_off` as NULL are removed.

### 4. Removing Unnecessary Columns
- The `row_num` column (used for duplicate detection) is dropped after cleaning.

## Dependencies
To run this project, ensure you have:
- **MySQL 8.0+**
- **MySQL Workbench** (or another SQL client)
- **A valid `layoffs` dataset**

## Sample Queries for Analysis
Once the data is cleaned, you can run insightful queries like:

- **Top 10 Companies with the Most Layoffs**:
  ```sql
  SELECT company, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company
  ORDER BY total_laid_off DESC
  LIMIT 10;
  ```

- **Layoffs Trend Over Time**:
  ```sql
  SELECT YEAR(date) AS year, SUM(total_laid_off) AS layoffs
  FROM layoffs_staging2
  GROUP BY year
  ORDER BY year;
  ```

## Future Enhancements
- **Normalization**: Further breaking down tables to improve database efficiency.
- **Data Visualization**: Connecting the cleaned data to visualization tools like **Power BI** or **Tableau**.
- **Predictive Analytics**: Using machine learning models to predict layoff trends.

---
### Author
Omar Zain | [GitHub Profile](https://github.com/omarzain27)  
Feel free to contribute or report any issues!

