He There,

1. The Snowflake SQL scripts included here cover the following steps:
	1.	Setting up the Data Warehouse and Roles
	•	Creating a Snowflake warehouse, database, and schema
	•	Defining user roles and assigning permissions
	2.	Configuring S3 Integration
	•	Creating a Snowflake storage integration to securely connect with AWS S3
	•	Setting up external stages to load data
	3.	Loading Data from S3 into Snowflake
	•	Using the COPY command to load structured data (CSV files)
	•	Defining file formats and handling missing/null values
	4.	Handling JSON and Semi-Structured Data
	•	Loading JSON data into Snowflake using VARIANT
	•	Flattening nested JSON structures using LATERAL FLATTEN
	5.	Creating and Populating Tables
	•	Creating tables for customers, orders, trips, and more
	•	Populating tables using staged files from S3

2. dbt Project Demo- Go to airboltic/dbtdemo

