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
        result,
        converted,
        meet,
        meet_date
    from source
)

select * from staged