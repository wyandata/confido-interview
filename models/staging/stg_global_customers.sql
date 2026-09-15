with source as (

    select *
    from {{ source('confido', 'global_customers') }}

)

select
    id,
    _uuid,
    name,
    company_detail_id,
    is_distributor,
    _updated_at

from source