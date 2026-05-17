with source as (
    select * from {{ source('tfrrs', 'performances') }}
),

staged as (
    select
        season_year,
        season_type,
        event,
        gender,
        place,
        athlete,
        academic_year,
        team,
        result,
        converted,
        meet,
        meet_date
    from source
)

select * from staged