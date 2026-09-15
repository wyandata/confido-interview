with source as (

    select *
    from {{ source('confido', 'product_prices') }}

)

select
    id,
    product_id,
    amount,
    global_customer_id,
    distribution_center_id,
    forecast_version_id,
    effective_at,
    _updated_at

from source