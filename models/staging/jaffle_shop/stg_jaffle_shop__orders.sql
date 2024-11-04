select
    id AS order_id,
    user_id AS customer_id,
    order_date,
    status
    
from {{ source('jaffle_shop', 'orders') }}