select
    ginview.fnc_uk() uk,
    k.icode,
    sum(k.qty) stock_qty
from
    invstock_onhand k
where
    k.loccode in (4, 1508)
group by
    k.icode