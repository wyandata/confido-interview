with source as (

    select *
    from {{ source('confido', 'invoice_items') }}

)

select
    id,
    invoice_id,
    total_amount,
    quantity,
    unit_price,
    item_remote_id,
    _updated_at

from source