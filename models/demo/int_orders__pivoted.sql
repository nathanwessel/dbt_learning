with payments as (
    select *
    from {{ ref('purchase') }}
),

pivoted as
(
    select
        purchase_id,
        {%- set purchase_statuses = ['PROCESSING', 'SHIPPED', 'DELIVERED'] -%}
        {% for status in purchase_statuses %}
            sum(case when purchase_status = '{{ status }}' then PURCHASE_AMOUNT else 0 end) as {{ status | lower }}_amount

            {%- if not loop.last -%}
                ,
            {%- endif -%}
        {% endfor %}
        
    from payments
    group by 1
)
select * 
from pivoted