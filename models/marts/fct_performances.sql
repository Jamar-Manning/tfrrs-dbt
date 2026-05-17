with performances as (
    select * from {{ ref('stg_performances') }}
),

events as (
    select * from {{ ref('dim_event') }}
),

final as (
    select
        performances.event,
        performances.gender,
        performances.place,
        performances.athlete,
        performances.year,
        performances.team,
        performances.result,
        performances.converted,
        performances.meet,
        performances.meet_date,
        events.category
    from performances
    left join events on performances.event = events.event
)

select * from final