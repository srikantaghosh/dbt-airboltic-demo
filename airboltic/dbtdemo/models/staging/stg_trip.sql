WITH trip AS (
    SELECT
        TRIP_ID,
        ORIGIN_CITY,
        DESTINATION_CITY,
        AIRPLANE_ID,
        START_TIMESTAMP,
        END_TIMESTAMP
    FROM {{ source('dbt_db', 'trip') }}
)

SELECT * FROM trip
