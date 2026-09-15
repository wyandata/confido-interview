with source as (

    select *
    from {{ source('confido', 'map_contact_subsidiaries') }}

)

select
    id,
    contact_id,
    subsidiary_id,
    _updated_at

from source
