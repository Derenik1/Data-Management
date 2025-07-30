def validate_and_insert_sales(conn, sales_df):
    cur = conn.cursor()
    for _, row in sales_df.iterrows():
        if row['quantity'] <= 0:
            log_error(cur, f"Invalid quantity {row['quantity']} in sale", 'sales_import')
            continue

        # Check stock before sale
        cur.execute("""
        SELECT stock_quantity FROM inventory
        WHERE store_id = %s AND product_id = %s
        """, (row['store_id'], row['product_id']))
        stock = cur.fetchone()
        if not stock or stock[0] < row['quantity']:
            log_error(cur, f"Insufficient stock for product {row['product_id']} at store {row['store_id']}", 'sales_import')
            continue
        
        # Insert sale and update stock
        cur.execute("""
        INSERT INTO sales (store_id, customer_id, product_id, quantity, sale_date)
        VALUES (%s, %s, %s, %s, %s)
        """, (row['store_id'], row['customer_id'], row['product_id'], row['quantity'], row['sale_date']))

        cur.execute("""
        UPDATE inventory
        SET stock_quantity = stock_quantity - %s
        WHERE store_id = %s AND product_id = %s
        """, (row['quantity'], row['store_id'], row['product_id']))
    conn.commit()
