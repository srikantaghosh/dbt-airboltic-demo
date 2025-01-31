
WITH customer AS(
SELECT
    CUSTOMER_ID, 
    NAME, 
    CUSTOMER_GROUP_ID, 
    EMAIL, 
    PHONE_NUMBER
FROM 
    {{ source('dbt_db', 'customers') }}
)

SELECT * FROM customer