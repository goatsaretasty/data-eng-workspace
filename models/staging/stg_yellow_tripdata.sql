-- Source: NYC TLC Yellow Taxi trip records, Jan 2024 (public dataset, read directly as parquet over HTTPS)
with source as (

    select *
    from read_parquet('https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet')

),

cleaned as (

    select
        VendorID                                       as vendor_id,
        tpep_pickup_datetime                            as pickup_at,
        tpep_dropoff_datetime                           as dropoff_at,
        passenger_count::int                            as passenger_count,
        trip_distance::double                           as trip_distance_miles,
        PULocationID                                     as pickup_location_id,
        DOLocationID                                     as dropoff_location_id,
        payment_type                                     as payment_type,
        fare_amount::double                             as fare_amount,
        tip_amount::double                              as tip_amount,
        total_amount::double                            as total_amount,
        date_diff('minute', tpep_pickup_datetime, tpep_dropoff_datetime) as trip_minutes
    from source
    -- basic data quality filter: drop obviously bad rows before they hit the marts
    where tpep_dropoff_datetime > tpep_pickup_datetime
      and trip_distance::double > 0
      and fare_amount::double > 0
      and passenger_count::int > 0

)

select * from cleaned
