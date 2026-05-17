with performances as (
    select * from {{ ref('stg_performances') }}
),

events as (
    select * from {{ ref('dim_event') }}
),

dates as (
    select * from {{ ref('dim_date') }}
),

final as (
    select
        performances.season_year,
        performances.season_type,
        performances.event,
        performances.gender,
        performances.place,
        performances.athlete,
        performances.academic_year,
        performances.team,
        performances.result,
        performances.converted,
        performances.meet,
        performances.meet_date,
        events.category,
        dates.year as meet_year,
        dates.month_number,
        dates.month_name,
        dates.day_of_week,
        dates.day_name
    from performances
    left join events on performances.event = events.event
    left join dates on performances.meet_date = dates.meet_date
)

select * from final