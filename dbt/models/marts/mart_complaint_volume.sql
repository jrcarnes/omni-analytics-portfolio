with base as (
    select * from {{ ref('stg_nyc_311_requests') }}
),

complaint_volume as (
    select
        DATE_TRUNC('month', created_at)     as complaint_month,
        borough,
        complaint_type,
        COUNT(*)                            as complaint_count,
        AVG(response_time_hours)            as avg_response_time_hours,
        MEDIAN(response_time_hours)         as median_response_time_hours,
        SUM(CASE WHEN response_time_hours <= 24
            THEN 1 ELSE 0 END)              as resolved_within_24hrs,
        SUM(CASE WHEN response_time_hours <= 72
            THEN 1 ELSE 0 END)              as resolved_within_72hrs
    from base
    group by 1, 2, 3
)

select * from complaint_volume