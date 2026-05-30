{% snapshot patient_snapshot %}

{{
    config(
        strategy = 'check',
        unique_key = 'PATIENT_ID',
        check_cols = [
            'PATIENT_NAME',
            'PATIENT_CONTACT_NUMBER',
            'PATIENT_EMAIL_ID',
            'PATIENT_ADDRESS'
        ]
    )
}}

select *
from {{ source('patient', 'PATIENT_SRC') }}
qualify row_number() over (
    partition by PATIENT_ID
    order by CREATED_AT desc
) = 1

{% endsnapshot %}