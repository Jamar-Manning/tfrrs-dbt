with time_results as (
    select *, time_seconds as result_numeric, 'time' as result_type
    from {{ ref('int_performances_time') }}
),

mark_results as (
    select *, distance_meters as result_numeric, 'mark' as result_type
    from {{ ref('int_performances_mark') }}
),

point_results as (
    select *, total_points as result_numeric, 'points' as result_type
    from {{ ref('int_performances_points') }}
),

performances as (
    select * from time_results
    union all
    select * from mark_results
    union all
    select * from point_results
),

dates as (
    select * from {{ ref('dim_date') }}
),

events as (
    select * from {{ ref('dim_event') }}
),

final as (
    select
        performances.division,
        performances.season_year,
        performances.season_type,
        performances.event,
        performances.gender,
        performances.place,
        performances.athlete,
        performances.academic_year,
        performances.team,
        performances.result,
        performances.result_numeric,
        performances.result_type,
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