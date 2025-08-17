use healthcare_db;
select * from clean_healthcare;

/* 🧹 Step 1: Create a clean table */
CREATE TABLE clean_healthcare AS
SELECT * FROM staging_healthcare;

/* 🧹 Step 2: Fix missing Patient IDs */

DELETE FROM clean_healthcare
WHERE (Patient_ID IS NULL OR Patient_ID = '')
  AND Patient_ID IS NOT NULL;

 /* 🧹 Step 3: Fix Age column
Remove wrong ages like negative or >120
Replace text values with NULL  */

UPDATE clean_healthcare
SET Age = NULL
WHERE Age NOT REGEXP '^[0-9]+$' OR Age < 0 OR Age > 120;

/*  🧹 Step 4: Standardize Gender */

UPDATE clean_healthcare SET Gender = 'Male' WHERE Gender IN ('M', 'male');
UPDATE clean_healthcare SET Gender = 'Female' WHERE Gender IN ('F', 'female');
UPDATE clean_healthcare SET Gender = 'Other' WHERE Gender NOT IN ('Male','Female') OR Gender IS NULL;

/* 🧹 Step 5: Fix Diagnosis typos */

UPDATE clean_healthcare SET Diagnosis = 'Hypertension' WHERE Diagnosis = 'Hypertensn';
UPDATE clean_healthcare SET Diagnosis = NULL WHERE Diagnosis = '';

/* 🧹 Step 6: Standardize Dates */ 

UPDATE clean_healthcare 
SET Admission_Date = NULL 
WHERE Admission_Date NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

UPDATE clean_healthcare 
SET Discharge_Date = NULL 
WHERE Discharge_Date NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

/* 🧹 Step 7: Clean Bill Amount
Remove text values
Fix negatives */

UPDATE clean_healthcare 
SET Bill_Amount = NULL
WHERE Bill_Amount REGEXP '[^0-9.]';

UPDATE clean_healthcare 
SET Bill_Amount = ABS(Bill_Amount);

-- Check whether patient_Id has duplicates or not
SELECT Patient_ID, COUNT(*) as duplicate_count
FROM clean_healthcare
GROUP BY Patient_ID
HAVING COUNT(*) > 1;

-- Remove Duplicates
-- Add a unique row identifier (if you don’t already have one).
ALTER TABLE clean_healthcare ADD id INT AUTO_INCREMENT PRIMARY KEY;

-- Delete duplicates while keeping the first record for each Patient_ID.
DELETE c1 
FROM clean_healthcare c1
JOIN clean_healthcare c2 
  ON c1.Patient_ID = c2.Patient_ID 
 AND c1.id > c2.id;


-- 🔹 Patient Demographics

-- 1. Total number of patients
SELECT COUNT(*) AS total_patients
FROM clean_healthcare;

-- 2. Count by gender
SELECT Gender, COUNT(*) AS patient_count
FROM clean_healthcare
GROUP BY Gender;

-- 3. Average age
SELECT AVG(Age) AS avg_age
FROM clean_healthcare;

-- 4. Oldest and youngest patient
SELECT MAX(Age) AS oldest, MIN(Age) AS youngest
FROM clean_healthcare;

-- 5. Patients by age bracket
SELECT 
  CASE 
    WHEN Age BETWEEN 0 AND 18 THEN '0-18'
    WHEN Age BETWEEN 19 AND 35 THEN '19-35'
    WHEN Age BETWEEN 36 AND 60 THEN '36-60'
    ELSE '60+'
  END AS age_group,
  COUNT(*) AS patient_count
FROM clean_healthcare
WHERE Age IS NOT NULL
GROUP BY age_group;

-- 🔹 Disease / Diagnosis Analysis

-- 6. Most common diagnosis
SELECT Diagnosis, COUNT(*) AS count
FROM clean_healthcare
GROUP BY Diagnosis
ORDER BY count DESC
LIMIT 1;

-- 7. Count patients per diagnosis
SELECT Diagnosis, COUNT(*) AS patient_count
FROM clean_healthcare
GROUP BY Diagnosis
ORDER BY patient_count DESC;

-- 8. Number of unique diagnoses
SELECT COUNT(DISTINCT Diagnosis) AS unique_diagnoses
FROM clean_healthcare;

-- 9. Patients with missing diagnosis
SELECT *
FROM clean_healthcare
WHERE Diagnosis IS NULL OR Diagnosis = '';

-- 10. Diabetes vs Hypertension count
SELECT Diagnosis, COUNT(*) AS patient_count
FROM clean_healthcare
WHERE Diagnosis IN ('Diabetes', 'Hypertension')
GROUP BY Diagnosis;

-- 🔹 Hospital Stay Analysis

-- 11. Average length of stay
SELECT AVG(DATEDIFF(Discharge_Date, Admission_Date)) AS avg_stay_days
FROM clean_healthcare
WHERE Discharge_Date IS NOT NULL AND Admission_Date IS NOT NULL;

-- 12. Patient with the longest stay
SELECT Patient_ID, Name, DATEDIFF(Discharge_Date, Admission_Date) AS stay_days
FROM clean_healthcare
WHERE Discharge_Date IS NOT NULL AND Admission_Date IS NOT NULL
ORDER BY stay_days DESC
LIMIT 1;

-- 13. Patients not discharged yet
SELECT *
FROM clean_healthcare
WHERE Discharge_Date IS NULL;

-- 14. Monthly admissions trend
SELECT YEAR(Admission_Date) AS year, MONTH(Admission_Date) AS month, COUNT(*) AS admissions
FROM clean_healthcare
WHERE Admission_Date IS NOT NULL
GROUP BY YEAR(Admission_Date), MONTH(Admission_Date)
ORDER BY year, month;

-- 15. Doctor with most patients
SELECT Doctor_Name, COUNT(*) AS patient_count
FROM clean_healthcare
GROUP BY Doctor_Name
ORDER BY patient_count DESC
LIMIT 1;

-- 🔹 Financial Analysis

-- 16. Total revenue
SELECT SUM(Bill_Amount) AS total_revenue
FROM clean_healthcare;

-- 17. Average bill per patient
SELECT AVG(Bill_Amount) AS avg_bill
FROM clean_healthcare;

-- 18. Highest bill
SELECT Patient_ID, Name, Bill_Amount
FROM clean_healthcare
ORDER BY Bill_Amount DESC
LIMIT 1;

-- 19. Total bills by diagnosis
SELECT Diagnosis, SUM(Bill_Amount) AS total_billing
FROM clean_healthcare
GROUP BY Diagnosis
ORDER BY total_billing DESC;

-- 20. Top 3 doctors by billing
SELECT Doctor_Name, SUM(Bill_Amount) AS total_billing
FROM clean_healthcare
GROUP BY Doctor_Name
ORDER BY total_billing DESC
LIMIT 3;

