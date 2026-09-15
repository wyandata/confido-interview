with source as (

    select *
    from {{ source('confido', 'products') }}

)

select
    id,
    _uuid,
    upc,
    name,
    product_family_id,
    cleaned_upc,
    company_detail_id,
    type,
    item_id,
    internal_item_number,
    ship_with_product_relationship_id,
    updated_at,
    _updated_at

from source