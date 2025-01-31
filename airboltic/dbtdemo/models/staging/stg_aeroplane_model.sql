WITH aeroplane_model AS (
    SELECT 
        MANUFACTURER, 
        MODEL, 
        MAX_SEATS, 
        MAX_WEIGHT, 
        MAX_DISTANCE, 
        ENGINE_TYPE
    FROM {{ source('dbt_db', 'aeroplane_model_raw') }}
)

SELECT * FROM aeroplane_model
