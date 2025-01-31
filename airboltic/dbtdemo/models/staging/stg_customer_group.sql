WITH customer_group AS (
    SELECT
        ID AS CUSTOMER_GROUP_ID,
        TYPE AS CUSTOMER_GROUP_TYPE,
        NAME AS CUSTOMER_GROUP_NAME,
        REGISTRY_NUMBER
    FROM {{ source('dbt_db', 'customer_group') }}
)

SELECT * FROM customer_group