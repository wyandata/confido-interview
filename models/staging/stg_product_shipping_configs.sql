with source as (

    select *
    from {{ source('confido', 'product_shipping_configs') }}

)

select
    product_id,
    shipping_product_id,
    global_customer_id,
    distribution_center_id,
    forecast_version_id,
    effective_at,
    _updated_at

from source