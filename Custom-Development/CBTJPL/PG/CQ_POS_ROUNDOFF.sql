select
    row_number() over () uk,
    d.icode,
    m.code,
    round(sum(d.qty)*(case
        when sum(sum(d.qty)) over (partition by m.code) = 0 then 0
        else m.roundoff / sum(sum(d.qty)) over (partition by m.code)
    end ),
    5) roundoff,
    sum(d.netamt) item_net_amount
from
    psite_posbill m
inner join psite_posbillitem d on
    m.code = d.psite_posbill_code
group by
    d.icode,
    m.code