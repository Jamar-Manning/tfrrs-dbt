with source as (
    select distinct event
    from {{ ref('stg_performances') }}
),

final as (
    select
        event,
        case
            when event in ('60 Meters', '100 Meters', '200 Meters', '400 Meters') then 'Sprints'
            when event in ('60 Hurdles', '100 Hurdles', '110 Hurdles', '400 Hurdles') then 'Hurdles'
            when event in ('800 Meters', '1500 Meters', 'Mile') then 'Mid Distance'
            when event in ('3000 Meters', '3000 Steeplechase', '5000 Meters', '10,000 Meters') then 'Distance'
            when event in ('High Jump', 'Long Jump', 'Triple Jump', 'Pole Vault') then 'Jumps'
            when event in ('Shot Put', 'Discus', 'Javelin', 'Hammer', 'Weight Throw') then 'Throws'
            when event in ('Heptathlon', 'Pentathlon', 'Decathlon') then 'Combined'
        end as category
    from source
)

select * from final