--Step:1
--A warehouse in snowflake provides the required resources, such as CPU, memory, and temporary storage, to perform the DML operations.
create warehouse DWH_WH;
create database DBT_DB;
create schema DBT_DB.Prod;

-- Create the `transform` role
CREATE ROLE IF NOT EXISTS transform;
GRANT ROLE TRANSFORM TO ROLE ACCOUNTADMIN;

-- Create the `dbt` user and assign to role
CREATE USER IF NOT EXISTS dbt
  PASSWORD='dbtPassword123'
  LOGIN_NAME='dbt'
  MUST_CHANGE_PASSWORD=FALSE
  DEFAULT_WAREHOUSE='DWH_WH'
  DEFAULT_ROLE='transform'
  DEFAULT_NAMESPACE='AIRBOLTIC.RAW'
  COMMENT='DBT user used for data transformation';
GRANT ROLE transform to USER dbt;

-- Set up permissions to role `transform`
GRANT ALL ON WAREHOUSE DWH_WH TO ROLE transform; 
GRANT ALL ON DATABASE DBT_DB to ROLE transform;
GRANT ALL ON ALL SCHEMAS IN DATABASE DBT_DB to ROLE transform;
GRANT ALL ON FUTURE SCHEMAS IN DATABASE DBT_DB to ROLE transform;
GRANT ALL ON ALL TABLES IN SCHEMA DBT_DB.Prod to ROLE transform;
GRANT ALL ON FUTURE TABLES IN SCHEMA DBT_DB.Prod to ROLE transform;



--Step:2
--Execute the below command to create storage object. This object helps you to connect to AWS bucket.
create or replace storage integration Snow_OBJ_2025
 type = external_stage
 storage_provider = s3
  enabled = true
  storage_aws_role_arn = 'arn:aws:iam::586794473880:role/Snowflake_Role_2025'
 storage_allowed_locations = ('s3://sriks3aws/');


--Step:3
--The below describe command helps you get the Amazon Resource Names ARN.Amazon Resource Names (ARNs) uniquely identify AWS resources.
desc integration Snow_OBJ_2025;


--Step:4
create or replace file format csv_format type = csv field_delimiter = ',' skip_header = 1 null_if = ('NULL', 'null') empty_field_as_null = true;


--Step:5
--A stage specifies where data files are stored so that the data in the files can be loaded into a table.
CREATE OR REPLACE STAGE customer_stage
URL = 's3://sriks3aws'
CREDENTIALS = (AWS_KEY_ID = 'XXX' AWS_SECRET_KEY = 'YYYY' -- Removed these for security
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1);


 -- Creating tables:
 --customers
CREATE OR REPLACE TABLE customers (
    customer_id STRING,
    name STRING,
    customer_group_id STRING,
    email STRING,
    phone_number STRING
);


COPY INTO customers (customer_id, name, customer_group_id, email, phone_number)
FROM @customer_stage/customer.csv
ON_ERROR = 'skip_file';

--customer_group
CREATE OR REPLACE TABLE customer_group(
    id STRING,
    type STRING,
    name STRING,
    registry_number STRING
);

COPY INTO customer_group (id, type, name, registry_number)
FROM @customer_stage/customer_group.csv
ON_ERROR = 'skip_file';

--aeroplane
CREATE OR REPLACE TABLE aeroplane (
    airplane_id STRING,
    airplane_model STRING,
    manufacturer STRING
);

COPY INTO aeroplane (airplane_id, airplane_model, manufacturer)
FROM @customer_stage/aeroplane.csv
ON_ERROR = 'skip_file';

--trip
CREATE OR REPLACE TABLE trip (
    trip_id STRING,
    origin_city STRING,
    destination_city STRING,
    airplane_id STRING,
    start_timestamp TIMESTAMP,
    end_timestamp TIMESTAMP
);

COPY INTO trip (trip_id, origin_city, destination_city, airplane_id, start_timestamp, end_timestamp)
FROM @customer_stage/trip.csv
ON_ERROR = 'skip_file';

--order
CREATE OR REPLACE TABLE order_raw (
    order_id STRING,
    customer_id STRING,
    trip_id STRING,
    price_eur STRING,
    seat_no STRING,
    status STRING
);

COPY INTO order_raw (order_id, customer_id, trip_id, price_eur, seat_no, status)
FROM @customer_stage/order.csv
ON_ERROR = 'skip_file';



select * from customers;
select * from customer_group;
select * from aeroplane;
select * from trip;
select * from order_raw;

--Loading JSON File- aeroplane-model

CREATE OR REPLACE TABLE aeroplane_model_raw (
    manufacturer STRING,
    model STRING,
    max_seats INT,
    max_weight INT,
    max_distance INT,
    engine_type STRING
);


CREATE OR REPLACE STAGE aeroplane_stage
URL = 's3://sriks3aws/'
CREDENTIALS = (AWS_KEY_ID = 'AKIAYRH5NDGMHE6MEQJV' AWS_SECRET_KEY = 'e+llj4rSA9MOTotiZAx7AxAKmtFHJUEdlCzjXx7t')
FILE_FORMAT = (TYPE = 'JSON');

CREATE OR REPLACE TABLE aeroplane_model_stage (
    raw_data VARIANT
);

COPY INTO aeroplane_model_stage
FROM @aeroplane_stage/aeroplane_model.json
FILE_FORMAT = (TYPE = 'JSON')
ON_ERROR = 'skip_file';

-- NOTE: I have used snowflake documentation and chatgpt to flatten the JSON File

INSERT INTO aeroplane_model_raw (manufacturer, model, max_seats, max_weight, max_distance, engine_type)
SELECT 
    manufacturer.key::STRING AS manufacturer,   
    model.key::STRING AS model,                 
    model.value:"max_seats"::INT AS max_seats,
    model.value:"max_weight"::INT AS max_weight,
    model.value:"max_distance"::INT AS max_distance,
    model.value:"engine_type"::STRING AS engine_type
FROM aeroplane_model_stage,
LATERAL FLATTEN(input => raw_data) manufacturer,  
LATERAL FLATTEN(input => manufacturer.value) model; 


SELECT * FROM aeroplane_model_raw LIMIT 10;



