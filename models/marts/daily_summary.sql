with trips as (

    select * from {{ ref('stg_yellow_tripdata') }}

)

select
    date_trunc('day', pickup_at)   as trip_date,
    count(*)                        as total_trips,
    round(avg(trip_distance_miles), 2) as avg_distance_miles,
    round(avg(trip_minutes), 2)     as avg_trip_minutes,
    round(sum(total_amount), 2)     as total_revenue,
    round(avg(tip_amount), 2)       as avg_tip
from trips
group by 1
order by 1
