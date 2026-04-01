with source as (
    select * from {{ source('nyc_311', 'nyc_311_requests') }}
),

renamed as (
    select
        "Unique Key"                            as complaint_id,
        "Created Date"                          as created_at,
        "Closed Date"                           as closed_at,
        "Agency"                                as agency_code,
        "Agency Name"                           as agency_name,
        "Problem (formerly Complaint Type)"     as complaint_type,
        "Problem Detail (formerly Descriptor)"  as descriptor,
        "Borough"                               as borough,
        "Incident Zip"                          as incident_zip,
        "Status"                                as status,
        "Latitude"                              as latitude,
        "Longitude"                             as longitude,
        DATE_DIFF(
            'hour',
            CAST("Created Date" AS TIMESTAMP),
            CAST("Closed Date" AS TIMESTAMP)
        )                                       as response_time_hours
    from source
    where DATE_DIFF(
        'hour',
        CAST("Created Date" AS TIMESTAMP),
        CAST("Closed Date" AS TIMESTAMP)
    ) between 0 and 720
)

select * from renamed