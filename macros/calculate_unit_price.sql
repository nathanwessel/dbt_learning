{% macro calculate_unit_price(column_name, decimals=2) %}
    ROUND({{column_name}} / QUANTITY, {{ decimals }})
{%- endmacro -%}