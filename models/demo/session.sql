{{
    config
    (
        materialized = 'table'
    )
}}

with session_src as 
(
    select 
        SESSION_ID,
        USER_ID,
        BROWSER,
        DEVICE_TYPE,
        ctry.COUNTRY_NAME as country_name,
        ctry.CONTINENT as continent,
        ctry.CURRENCY as currency,
        START_TIME,
        END_TIME,
        PAGES_VISITED,
        CURRENT_TIMESTAMP as INSERT_DTS
    from {{source('session', 'SESSION_SRC')}} src
    left outer join {{ref('country_code')}} ctry
        on (src.COUNTRY_CODE = ctry.COUNTRY_CODE)
)
select * from session_src