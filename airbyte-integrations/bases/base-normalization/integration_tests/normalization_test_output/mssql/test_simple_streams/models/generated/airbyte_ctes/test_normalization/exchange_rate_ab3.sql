{{ config(
    unique_key = env_var('AIRBYTE_DEFAULT_UNIQUE_KEY', '_airbyte_ab_id'),
    schema = "_airbyte_test_normalization",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
select
    {{ dbt_utils.surrogate_key([
        'id',
        'currency',
        adapter.quote('date'),
        'timestamp_col',
        adapter.quote('HKD@spéçiäl & characters'),
        'hkd_special___characters',
        'nzd',
        'usd',
    ]) }} as _airbyte_exchange_rate_hashid,
    tmp.*
from {{ ref('exchange_rate_ab2') }} tmp
-- exchange_rate
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

