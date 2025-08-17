

# 🏥 Healthcare Data Analysis using SQL

## 📌 Project Overview

This project is a **SQL-based data analysis** of healthcare patient records.
The dataset is intentionally messy with duplicates, missing values, and inconsistent formats, to simulate *real-world data cleaning and analysis challenges*.

The project demonstrates how to:

* Import raw healthcare data (CSV) into MySQL
* Clean and preprocess messy data for accuracy
* Perform SQL queries to extract meaningful insights
* Solve real-world healthcare business problems

---

## 📂 Dataset Description

The dataset is a **synthetic patient dataset** containing hospital admission details.

**Columns in the dataset:**

* `Patient_ID` – Unique patient identifier
* `Name` – Patient name (may contain duplicates/typos)
* `Age` – Patient age (includes missing/invalid entries)
* `Gender` – Male/Female/Other/NULL
* `Diagnosis` – Disease/condition (some missing or inconsistent)
* `Admission_Date` – Date of hospital admission
* `Discharge_Date` – Date of discharge (NULL if ongoing)
* `Doctor_Name` – Treating doctor
* `Bill_Amount` – Hospital billing amount (includes missing/invalid values)

---

⚙️ Steps Performed
🔹 1. Import Data into MySQL

Created a staging table to load raw CSV data.

Used LOAD DATA LOCAL INFILE to import messy data.

🔹 2. Data Cleaning

* Removed rows with missing or invalid `Patient_ID`.
* Handled missing values in `Diagnosis`, `Discharge_Date`, and `Bill_Amount`.
* Removed duplicate `Patient_ID` using `ROW_NUMBER()`.
* Standardized inconsistent values (`Gender`, date formats, etc.).

🔹 3. SQL Analysis Performed

👨‍⚕️ Patient Demographics

* Total patients
* Gender distribution
* Age statistics & brackets

🦠 Diagnosis Insights

* Most common diagnoses
* Patients per disease
* Missing diagnosis records

🏥 Hospital Stay Analysis

* Average length of stay
* Longest hospital stay
* Admissions trend by month
* Doctor with the maximum patients

💰 Financial Analysis

* Total hospital revenue
* Average bill per patient
* Top 3 doctors by billing amount
* Billing by diagnosis


## 🚀 Tech Stack

* **Database**: MySQL
* **Language**: SQL
* **Dataset**: Synthetic healthcare data (CSV)
* **SQL Concepts Used**:

  * Joins (future scope with multiple tables)
  * Aggregations (`SUM`, `AVG`, `COUNT`, `MAX`, `MIN`)
  * Filtering with `WHERE`, `HAVING`
  * Window functions (`ROW_NUMBER()`)
  * Date functions (`DATEDIFF`, `YEAR`, `MONTH`)

---

## 📎 Repository Structure

```
├── data/
│   └── messy_healthcare_dataset.csv
├── scripts/
│   └── mysql_import.sql          # Script to import data
│   └── data_cleaning.sql         # Script to clean messy data
│   └── analysis_queries.sql      # SQL queries for analysis
├── README.md                     # Project documentation
```

---

## 📌 Key Learnings

✔️ How to handle messy real-world healthcare data
✔️ Removing duplicates and cleaning missing values in SQL
✔️ Extracting insights with aggregate queries
✔️ Understanding hospital data for business decisions

---

## 📢 Future Scope

* Create **visual dashboards** in Power BI or Tableau
* Add relational tables for **Doctors, Departments, Insurance**
* Perform **predictive analytics** on healthcare costs
* Extend project to a **data warehouse pipeline**

---

✅ This project is a complete **end-to-end SQL data analysis case study** for healthcare data.


