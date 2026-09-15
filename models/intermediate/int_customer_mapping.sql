with customer_mapping as (

    select
        c.remote_id as customer_remote_id,
        c.global_customer_id
    from {{ ref('stg_contacts') }} c
    inner join {{ ref('stg_global_customers') }} gc
        on c.global_customer_id = gc.id
    where c.remote_id is not null
      and c.global_customer_id is not null

)

select
    customer_remote_id,
    global_customer_id
from customer_mapping