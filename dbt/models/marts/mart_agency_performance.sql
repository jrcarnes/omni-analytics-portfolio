with base as (
    select * from {{ ref('stg_nyc_311_requests') }}
),

agency_performance as (
    select
        agency_code,
        agency_name,
        complaint_type,
        borough,
        COUNT(*)                            as complaint_count,
        AVG(response_time_hours)            as avg_response_time_hours,
        MEDIAN(response_time_hours)         as median_response_time_hours,
        MIN(response_time_hours)            as min_response_time_hours,
        MAX(response_time_hours)            as max_response_time_hours,
        SUM(CASE WHEN response_time_hours <= 24
            THEN 1 ELSE 0 END) * 100.0
            / COUNT(*)                      as pct_resolved_within_24hrs
    from base
    group by 1, 2, 3, 4
)

select * from agency_performance