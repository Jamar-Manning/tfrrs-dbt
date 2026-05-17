with source as (
    select distinct meet_date
    from {{ ref('stg_performances') }}
),

final as (
    select
        meet_date,
        year(meet_date) as year,
        month(meet_date) as month_number,
        monthname(meet_date) as month_name,
        dayofweek(meet_date) as day_of_week,
        dayname(meet_date) as day_name,
        quarter(meet_date) as quarter
    from source
)

select * from final