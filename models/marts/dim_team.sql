with source as (
    select distinct team
    from {{ ref('stg_performances') }}
)

select team
from source