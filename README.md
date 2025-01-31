

This repository contains Snowflake SQL scripts and a dbt project demo, covering end-to-end data pipeline setup, integration, and transformation.

1. Snowflake SQL Setup

	The Snowflake SQL scripts included in this repository cover the following steps:
	
	1. Data Warehouse and Role Setup
		•	Creating a Snowflake warehouse, database, and schema
		•	Defining user roles and permissions for secure access
	
	2. S3 Integration Configuration
		•	Creating a storage integration to connect with AWS S3
		•	Setting up external stages for loading data
	
	3. Loading Data from S3 into Snowflake
		•	Using the COPY command to load structured CSV files
		•	Defining file formats and handling missing/null values
	
	4. Handling JSON and Semi-Structured Data
		•	Loading JSON data into Snowflake using VARIANT
		•	Flattening nested JSON using LATERAL FLATTEN
	
	5. Creating and Populating Tables
		•	Creating tables for customers, orders, trips, and more
		•	Populating tables using staged files from S3

2. dbt Project Demo (Located in airboltic/dbtdemo)

	1. Schema Documentation (schema.yml)
		•	Documenting each model with descriptions
		•	Enforcing data integrity using built-in dbt tests
	
	2. Staging Layer Models
		•	Materialized as views for real-time updates and storage efficiency
		•	Extracts and standardizes raw data from the source tables
		•	Provides cleaned, structured data for downstream models
	
	3. Intermediate Layer Models
		•	Implemented incremental models for cost efficiency and performance
		•	Joins and aggregates data to create refined datasets
		•	Ensures only new or changed records are processed, reducing compute costs
