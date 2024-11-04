WITH customers AS (

    SELECT *
    FROM {{ ref('stg_jaffle_shop__customers') }}

),

orders AS (
    
    SELECT * 
    FROM {{ ref ('fct_orders')}}

),

customer_orders AS (

    SELECT
        customer_id,

        min(order_date) AS first_order_date,
        max(order_date) AS most_recent_order_date,
        count(order_id) AS number_of_orders,
        sum(amount) as lifetime_value

    FROM orders
    GROUP BY 1    

),

final AS (

    SELECT
        customers.id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) AS number_of_orders,
        customer_orders.lifetime_value

    FROM customers

    LEFT JOIN customer_orders ON customers.id = customer_orders.customer_id

)

SELECT * FROM final