with source as (

    select *
    from {{ source('confido', 'items') }}

)

select
    id,
    remote_id,
    name,
    company_detail_id,
    _updated_at

from source