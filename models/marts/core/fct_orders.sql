with orders as 
    (
        select * from {{ref('stg_orders')}}
    
    ),

    payments as
    (
        select * from {{ref('stg_payments')}}


    ),

    order_payments as
    (

        select order_id
               ,sum(case when status = 'success' then amount end) as amount
        from payments
        group by order_id
    )

    select o.order_id
           ,dc.customer_id
           ,o.order_date
           ,coalesce(op.amount,0) as amount
    from orders as o
    left join order_payments as op 
        on o.order_id = op.order_id
    left join {{ref('dim_customer')}} as dc
        on o.customer_id = dc.customer_id

