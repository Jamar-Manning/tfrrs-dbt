with mark_events as (
    select
        p.*
    from {{ ref('stg_performances') }} p
    inner join {{ ref('dim_event') }} e
        on p.event = e.event
    where e.category in ('Throws', 'Jumps')
)

select
    division,
    season_year,
    season_type,
    event,
    gender,
    place,
    athlete,
    academic_year,
    team,
    result,
    try_to_double(result) as distance_meters,
    meet,
    meet_date
from mark_events