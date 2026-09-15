with source as (

    select *
    from {{ source('confido', 'company_details') }}

)

select
    id,
    name,
    merge_uuid,
    muffin_organization_id,
    forecast_end_day_of_week,
    prevent_customer_remapping,
    _updated_at

from source