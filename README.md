# Confido Invoice Line Items

dbt project for building a standardized invoice line items table for downstream use.

## Overview

The final model, `fct_invoice_line_items`, has one row per source invoice line item and includes:

* Invoice and line item IDs
* Quantity, unit price, and total amount
* Invoice number, dates, and currency
* Confido product and global customer IDs where they can be mapped
* Distribution center
* Original external item ID and name for traceability

The project uses a simple staging → intermediate → mart structure.

```text
staging
   ↓
intermediate mappings
   ↓
fct_invoice_line_items
```

Staging models are views, intermediate models are tables, and the final model is a table.

## Mapping Decisions

### Products

The product mapping follows:

```text
invoice_items.item_remote_id
→ items.remote_id
→ items.id
→ products.item_id
```

Some external items map to multiple Confido products. Rather than arbitrarily choosing one, the intermediate mapping only keeps items that map to exactly one product.

Unmapped or ambiguous items have a `NULL` `product_id`, while the original external item ID and name are retained.

This gives approximately 65% product coverage.

### Customers

Customer mapping follows:

```text
invoices.customer_remote_id
→ contacts.remote_id
→ contacts.global_customer_id
```

Only valid mappings are used. Where no mapping exists, `global_customer_id` is left `NULL`.

This gives approximately 36% customer coverage.

### Distribution Centers

`invoices.subsidiary_id` maps directly to `confido_distribution_centers.id`.

This relationship was validated against the source data and provides 100% coverage, so no additional mapping layer was necessary.

## Amounts, Quantity, and Currency

The source `total_amount`, `quantity`, and `unit_price` are preserved as provided.

Some invoice lines have `NULL` quantities or unit prices, particularly non-product lines such as services and discounts. These are intentionally left `NULL` rather than converted to zero.

The source `total_amount` is also not calculated from `quantity × unit_price`. The source data contains material differences between these values, so recalculating the amount could change the source financial data.

A warning-level test, `flag_invoice_line_item_amount_discrepancies`, flags larger differences for investigation without preventing the model from building.

Currency is also preserved from the source. There are USD, CAD, and missing values, and the missing values could not be reliably inferred, so they remain `NULL`.

## Data Quality

The final model was reconciled to the source:

| Check                        | Result |
| ---------------------------- | -----: |
| Source invoice lines         |  2,527 |
| Final invoice lines          |  2,527 |
| Distinct final line IDs      |  2,527 |
| Product coverage             |   ~65% |
| Customer coverage            |   ~36% |
| Distribution center coverage |   100% |

The final model also preserves the source quantity and total amount:

* Source total amount: `8,329,402.07796897`
* Final total amount: `8,329,402.07796897`
* Source quantity: `1,893,875.904`
* Final quantity: `1,893,875.904`

## Modeling Notes

I kept the staging layer relatively thin and put mapping logic into intermediate models so that the assumptions are easy to find and test.

A few available source tables were investigated but not included in the final joins because they weren't needed for the requested output. In particular, `product_prices` was not used to calculate invoice amounts because the invoice already contains its own pricing information and the product price data did not explain the invoice totals.

I also avoided incremental logic given the small source dataset and the additional complexity it would introduce around updates and remapping.

## Running

```bash
dbt debug
dbt build
```

The main deliverable is:

```text
models/marts/fct_invoice_line_items.sql
```
