{{ config(
    materialized='incremental',
    unique_key='trip_id'
) }}

WITH trips AS (
    SELECT 
        t.TRIP_ID, 
        t.ORIGIN_CITY, 
        t.DESTINATION_CITY, 
        t.AIRPLANE_ID, 
        t.START_TIMESTAMP, 
        t.END_TIMESTAMP,
        a.AIRPLANE_MODEL, 
        am.MANUFACTURER, 
        am.MAX_SEATS, 
        am.ENGINE_TYPE
    FROM {{ ref('stg_trip') }} t
    LEFT JOIN {{ ref('stg_aeroplane') }} a ON t.AIRPLANE_ID = a.AIRPLANE_ID
    LEFT JOIN {{ ref('stg_aeroplane_model') }} am ON a.AIRPLANE_MODEL = am.MODEL
)

SELECT * FROM trips

{% if is_incremental() %}
WHERE START_TIMESTAMP > (SELECT MAX(START_TIMESTAMP) FROM {{ this }})
{% endif %}
