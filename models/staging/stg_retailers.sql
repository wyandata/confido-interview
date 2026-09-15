with source as (

    select * 
    from {{ source('confido', 'retailers') }}

),

renamed as (

    select
        id,
        _uuid,
        name,
        company_detail_id,
        is_custom,
        muffin_account_id,
        muffin_chain_id,
        _updated_at

    from source

)

select * from renamed
