with time_events as (
    select
        p.*
    from {{ ref('stg_performances') }} p
    inner join {{ ref('dim_event') }} e
        on p.event = e.event
    where e.category in ('Sprints', 'Hurdles', 'Mid Distance', 'Distance')
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
    result_seconds as time_seconds,
    meet,
    meet_date
from time_events