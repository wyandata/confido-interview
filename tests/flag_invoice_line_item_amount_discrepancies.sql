-- Flag invoice lines where the source total differs materially from
-- quantity * unit price. This is an informational data-quality check;
-- total_amount remains the authoritative source value.

{{ config(severity = 'warn') }}

select
    invoice_line_item_id,
    item_remote_id,
    quantity,
    unit_price,
    total_amount,
    quantity * unit_price as expected_amount,
    total_amount - (quantity * unit_price) as amount_difference
from {{ ref('fct_invoice_line_items') }}
where quantity is not null
  and unit_price is not null
  and total_amount is not null
  and abs(total_amount - (quantity * unit_price)) >= 5
  and abs(total_amount - (quantity * unit_price))
      / nullif(abs(quantity * unit_price), 0) >= 0.01