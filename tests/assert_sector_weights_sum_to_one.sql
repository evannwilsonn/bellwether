select sum(index_weight) as total_weight
from {{ ref('rpt_sector_valuation') }}
having abs(sum(index_weight) - 1) > 1e-6
