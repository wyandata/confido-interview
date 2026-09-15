WITH item_product_counts AS (

    SELECT
        i.remote_id AS item_remote_id,
        COUNT(DISTINCT p.id) AS product_count,
        MIN(p.id) AS product_id
    FROM {{ ref('stg_items') }} i
    LEFT JOIN {{ ref('stg_products') }} p
        ON i.id = p.item_id
    GROUP BY 1

)

SELECT
    item_remote_id,
    product_id
FROM item_product_counts
WHERE product_count = 1