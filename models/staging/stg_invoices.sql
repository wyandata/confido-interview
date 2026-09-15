with source as (

    select *
    from {{ source('confido', 'invoices') }}

)

select
    id,
    number,
    paid_on_date,
    customer_remote_id,
    subsidiary_id,
    created_at,
    company_detail_id,
    check_remit_item_id,
    currency,
    _updated_at

from source