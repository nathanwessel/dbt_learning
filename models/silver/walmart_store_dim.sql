{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key=['store_id', 'dept_id'],
        merge_exclude_columns=['insert_date']
    )
}}

with walmart_store_dim as (
    select
        dept.store as store_id,
        dept.dept as dept_id,
        store.type as store_type,
        store.size as store_size,
        -- insert_dts as src_insert_dts,
        current_timestamp as insert_date,
        current_timestamp as update_date

    from {{ source('raw', 'DEPARTMENT_RAW') }} dept
    join {{ source('raw', 'STORE_RAW') }} store
        on (dept.store = store.store)

    {% if is_incremental() %}
        where dept.insert_dts >= (select max(insert_date) from {{ this }})
    {% endif %}
)

select * from walmart_store_dim