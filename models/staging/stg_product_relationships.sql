with source as (

    select *
    from {{ source('confido', 'product_relationships') }}

)

select
    id,
    product_id,
    child_product_id,
    quantity,
    _updated_at

from source