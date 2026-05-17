with source as (
    select * from {{ source('tfrrs', 'performances') }}
),

staged as (
    select
        event,
        gender,
        place::integer as place,
        athlete,
        year as academic_year,
        team,
        round(regexp_replace(result, '[^0-9\\.]', '')::float, 2) as result, -- Converting to decimals
        converted,
        meet,
        meet_date
    from source
)

select * from staged