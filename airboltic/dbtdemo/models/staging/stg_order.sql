WITH order_data AS (
    SELECT
        ORDER_ID,
        CUSTOMER_ID,
        TRIP_ID,
        CAST(PRICE_EUR AS FLOAT) AS PRICE_EUR,
        SEAT_NO,
        LOWER(STATUS) AS STATUS
    FROM {{ source('dbt_db', 'order_raw') }}
)

SELECT * FROM order_data
