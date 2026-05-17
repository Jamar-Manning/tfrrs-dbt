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
        case
            when result like '%:%' then
                round((split_part(result, ':', 1)::float * 60) + split_part(result, ':', 2)::float, 2)
            else
                result::float
        end as result_seconds,
        converted,
        meet,
        meet_date
    from source
)

select * from staged