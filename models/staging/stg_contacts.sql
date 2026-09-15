with source as (

    select *
    from {{ source('confido', 'contacts') }}

)

select
    id,
    remote_id,
    parent_remote_id,
    global_customer_id,
    distribution_center_id,
    name,
    company_detail_id,
    _updated_at

from source