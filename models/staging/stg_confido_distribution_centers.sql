with source as (

    select *
    from {{ source('confido', 'confido_distribution_centers') }}

)

select
    id,
    _uuid,
    name,
    global_customer_id,
    muffin_location_id,
    company_detail_id,
    _updated_at

from source