SELECT s.name AS store, p.name AS product, i.stock_quantity, i.last_restock_date
FROM inventory i
JOIN stores s ON i.store_id = s.store_id
JOIN products p ON i.product_id = p.product_id
WHERE i.stock_quantity < 10
   OR i.last_restock_date < CURRENT_DATE - INTERVAL '30 days';
