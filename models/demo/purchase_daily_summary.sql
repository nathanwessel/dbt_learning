select
    purchase_id,
    purchase_date,
    {{ dbt_utils.generate_surrogate_key(['purchase_id', 'purchase_date']) }} as primary_key,
    count(*) as c
from {{ ref('purchase') }}
group by 1, 2