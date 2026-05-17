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
            -- Handles times with colons like 4:02.12
            when result like '%:%' then
                round(
                    (try_to_double(split_part(result, ':', 1)) * 60) 
                    + try_to_double(split_part(result, ':', 2)), 
                    2
                )
            -- Safely handles clean numbers and turns "DNF"/"DQ" into NULLs
            else
                try_to_double(result)
        end as result_seconds,
        converted,
        meet,
        meet_date
    from source
)

select * from staged