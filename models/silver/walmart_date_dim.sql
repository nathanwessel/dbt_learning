{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='date_id',
        merge_exclude_columns=['insert_date']
    )
}}

-- was: insert_dts

/*
-- potential keys from the raw data (not from the silver tables):

-- STORE, DEPT, DATE
SELECT * FROM DEPARTMENT_RAW;

-- STORE, DATE
SELECT * FROM FACT_RAW;

-- STORE
SELECT * FROM STORE_RAW;
*/

with walmart_date_dim as (
    select
        fact.date as date_id,
        dept.date as store_date,
        dept.isholiday as isholiday,
        -- insert_dts as src_insert_dts,
        current_timestamp as insert_date,
        current_timestamp as update_date

    from {{ source('raw', 'FACT_RAW') }} fact
    join {{ source('raw', 'DEPARTMENT_RAW') }} dept
        on fact.store = dept.store
        and fact.date = dept.date

    {% if is_incremental() %}
        -- where src_insert_dts >= (select max(insert_dts) from {{ this }})
        -- I think this is correct
        where fact.insert_dts >= (select max(insert_date) from {{ this }})
    {% endif %}

)

select *
from walmart_date_dim