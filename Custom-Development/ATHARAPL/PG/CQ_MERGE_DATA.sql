/*|| Custom Development || Object : CQ_MERGE_DATA || Ticket Id : 421802 || Developer : Dipankar ||*/

with GDN
     as (
select
	k.icode,
	SUM (coalesce(k.qty,
    0)) gdn_qty
from
	INVSTOCK K
where
	K.ENTDT::DATE <= to_date('@ASON@',
    'YYYY-MM-DD')
	and 
    admsite_code = 1
	and loccode in (1026, 1027, 1028)
group by
	k.icode),
OTHER
     as (
select
	k.icode,
	SUM (coalesce(k.qty,
    0)) other_qty
from
	INVSTOCK K
left join invloc l on
	k.loccode = l.loccode
where
	K.ENTDT::DATE <= to_date('@ASON@',
    'YYYY-MM-DD')
		and l.LOCNAME like any (array[
    '%SFG%',
		'%IRON Rec%',
		'%Iron Alter%'
])
	group by
		k.icode),
IRON
as(
select
    d.assembly_icode icode,
    SUM (coalesce(D.qty,
    0)) iron_qty
from
    prdjobmain m
inner join prdjobdet d on
    m.code = d.jobcode
where
    m.job_date::date <= to_date('@ASON@',
    'YYYY-MM-DD')
        and
    m.code not in
                (
        select
            distinct jobcode jobcode
        from
            prdjrcmain m
        inner join prdjrcdet d on
            m.code = d.jrccode
        where
            m.prcode = 1079)
        and m.prcode = 1079
    group by
        d.assembly_icode),
WIP
as (
select
	P.ASSEMBLY_ICODE ICODE,
	SUM(coalesce(P.TXN_QTY, 0)) wip_qty
from
	prdlotmain m
inner join prdlotdet d on
	m.code = d.lotcode
left join prdwiptrans p on
	d.lotcode = p.lotcode
	and d.assembly_icode = p.assembly_icode
where
	m.schedule_date::date <= to_date('@ASON@',
    'YYYY-MM-DD')
		and P.PRCODE not in (1079)
	group by
		P.ASSEMBLY_ICODE)
select
	row_number() over() as UK,
	I.DIVISION,
	I.department,
	I.CATEGORY1,
	I.CATEGORY2,
	SUM(coalesce(gdn_qty, 0)) gdn_qty,
	SUM(coalesce(other_qty, 0)) other_qty,
	SUM(coalesce(iron_qty, 0)) iron_qty,
	SUM(coalesce(wip_qty, 0)) wip_qty
from
	GINVIEW.LV_ITEM I
left join (
	select
		icode,
		coalesce(gdn_qty, 0) gdn_qty
	from
		GDN) A on
	I.code = A.icode
left join (
	select
		icode,
		coalesce(other_qty, 0) other_qty
	from
		OTHER) B on
	I.code = B.icode
left join (
	select
		icode,
		coalesce(iron_qty, 0) iron_qty
	from
		IRON) C on
	I.code = C.icode
left join (
	select
		icode,
		coalesce(wip_qty, 0) wip_qty
	from
		WIP) D on
	I.code = D.icode
group by
    I.DIVISION,
	I.department,
	I.CATEGORY1,
	I.CATEGORY2
HAVING(SUM(coalesce(gdn_qty, 0))<>0
 and SUM(coalesce(other_qty, 0))<>0
 and SUM(coalesce(iron_qty, 0))<>0
 and SUM(coalesce(wip_qty, 0))<>0)