WITH aeroplane AS (
    SELECT
        AIRPLANE_ID,
        AIRPLANE_MODEL,
        MANUFACTURER
    FROM {{ source('dbt_db', 'aeroplane') }}
)

SELECT * FROM aeroplane
