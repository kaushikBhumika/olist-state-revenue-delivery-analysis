-- Create the order_reviews table (not part of the original Project 1 database)
CREATE TABLE order_reviews(
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INTEGER,
    review_comment_title VARCHAR(100),
    review_comment_message VARCHAR(500),
    review_creation_date DATE,
    review_answer_timestamp TIMESTAMP
);

-- Note: primary key intentionally omitted — see README "Challenges" section
-- for why (duplicate review_ids linked to multiple orders).

-- Final data extraction query: delivered orders with price, delivery dates,
-- review score, and customer state
SELECT 
    o.order_id,
    oi.price,
    o.order_estimated_delivery_date,
    o.order_delivered_customer_date,
    rv.review_score,
    c.customer_state
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN order_reviews rv ON o.order_id = rv.order_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered';