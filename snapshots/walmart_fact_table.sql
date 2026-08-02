{% snapshot walmart_fact_table %}

{{
    config(
        target_database='walmart_db',
        target_schema='silver',
        unique_key=['store_id', 'dept_id', 'date_id'],
        strategy='timestamp',
        updated_at='update_date',
        snapshot_meta_column_names={'dbt_valid_from': 'start_date', 'dbt_valid_to': 'end_date'}
    )
}}
-- fix the updated_at parameter above with the correct column

select
    dept.store as store_id,
    dept.dept as dept_id,
    dept.date as date_id,
    -- don't need sum() here I don't think
    dept.weekly_sales as store_weekly_sales,
    fact.fuel_price as fuel_price,
    fact.temperature as store_temperature,
    fact.unemployment as unemployment,
    fact.cpi as cpi,
    fact.markdown1 as markdown1,
    fact.markdown2 as markdown2,
    fact.markdown3 as markdown3,
    fact.markdown4 as markdown4,
    fact.markdown5 as markdown5,
    dept.insert_dts as insert_date,
    current_timestamp as update_date
    -- something as vrsn_start_date,
    -- something as vrsn_end_date

-- dept has the actual fact of weekly_sales, so start with
-- that on left side of inner join
from {{ source('raw', 'DEPARTMENT_RAW') }} dept
join {{ source('raw', 'FACT_RAW') }} fact
    on (dept.store = fact.store
        and dept.date = fact.date)

{% endsnapshot %}