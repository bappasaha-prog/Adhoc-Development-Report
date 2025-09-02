/*|| Custom Development || Object : CQ_WIP_PENDING || Ticket Id :  402077 || Developer : Dipankar ||*/

select
	row_number() OVER() as UK,
	m.admsite_code,
	d.assembly_icode ,
	sa.sainame sub_assembly_item,
	sum(p.txn_qty) pending_qty
from
	prdlotmain m
inner join prdlotdet d on
	m.code = d.lotcode
left join prdwiptrans p on
	d.lotcode = p.lotcode
	and d.assembly_icode = p.assembly_icode
inner join ginview.lv_assembly_item i on
	p.assembly_icode = i.code
left outer join PRD_SAITEM SA on p.ASS_SAITEM_CODE = SA.CODE
where
	m.schedule_date::date <= to_date('@ASON@', 'YYYY-MM-DD')
group by
	m.admsite_code,
	d.assembly_icode,
	sa.sainame