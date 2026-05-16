with source as (
    select * from raw.tfrrs.performances
),

staged as (
    select
        event,
        gender,
        place::integer as place,
        athlete,
        year,
        team,
        result,
        converted,
        meet,
        meet_date
    from source
)

select * from staged