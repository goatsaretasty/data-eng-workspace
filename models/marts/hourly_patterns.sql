with trips as (

    select * from {{ ref('stg_yellow_tripdata') }}

)

select
    extract(hour from pickup_at)    as pickup_hour,
    count(*)                         as total_trips,
    round(avg(trip_distance_miles), 2) as avg_distance_miles,
    round(avg(total_amount), 2)      as avg_fare,
    round(avg(tip_amount / nullif(fare_amount, 0)) * 100, 1) as avg_tip_pct
from trips
group by 1
order by 1
