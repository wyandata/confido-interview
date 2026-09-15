with invoice_items as (

    select *
    from {{ ref('stg_invoice_items') }}

),

invoices as (

    select *
    from {{ ref('stg_invoices') }}

),

customer_mapping as (

    select *
    from {{ ref('int_customer_mapping') }}

),

global_customers as (

    select *
    from {{ ref('stg_global_customers') }}

),

distribution_centers as (

    select *
    from {{ ref('stg_confido_distribution_centers') }}

),

item_product_mapping as (

    select *
    from {{ ref('int_item_product_mapping') }}

),

items as (

    select *
    from {{ ref('stg_items') }}

),

products as (

    select *
    from {{ ref('stg_products') }}

)

select
    -- Invoice line item
    ii.id as invoice_line_item_id,
    ii.invoice_id,
    ii.quantity,
    ii.total_amount,
    ii.unit_price,

    -- Invoice
    i.number as invoice_number,
    i.paid_on_date,
    i.currency,
    i.created_at as invoice_created_at,

    -- Product
    ipm.product_id,
    p.name as product_name,

    -- External item for traceability
    ii.item_remote_id,
    item.name as item_name,

    -- Customer
    cm.global_customer_id,
    gc.name as global_customer_name,

    -- Distribution center
    dc.id as distribution_center_id,
    dc.name as distribution_center_name

from invoice_items ii

left join invoices i
    on ii.invoice_id = i.id

left join customer_mapping cm
    on i.customer_remote_id = cm.customer_remote_id

left join global_customers gc
    on cm.global_customer_id = gc.id

left join distribution_centers dc
    on i.subsidiary_id = dc.id

left join items item
    on ii.item_remote_id = item.remote_id

left join item_product_mapping ipm
    on ii.item_remote_id = ipm.item_remote_id

left join products p
    on ipm.product_id = p.id