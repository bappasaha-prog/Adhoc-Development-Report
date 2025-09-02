/* Formatted on 2025-02-24 14:22:52 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_JOB_RECEIPT_ITEM || Ticket Id : 398595 || Developer : Dipankar || ><><><*/
  select
	GINVIEW.FNC_UK() UK,
	D.jrccode,
	L.LOTNO PLAN_NO,
	I.category2 ITEM_NAME,
	I.CATEGORY3 size,
	I.uom ,
	D.rate JRC_RATE,
	D.job_rate ,
	SUM (D.qty) QUANTITY,
	SA.SAINAME SUB_ASSEMBLY_ITEM,
	SUM(B.amount) COST_AMOUNT
from
	prdjRCdet D
left outer join PRDLOTMAIN L on
	D.LOTCODE = L.CODE
left outer join PRD_SAITEM SA on
	D.ASS_SAITEM_CODE = SA.CODE
left join GINVIEW.lv_assembly_item I on
	D.assembly_icode = I.code
left outer join (/* Formatted on 2025-02-24 16:21:30 (QP5 v5.294) */
	select
		P.assembly_icode ,
		P.LOTCODE,
		P.JRCCODE,
		-1*SUM (P.AMOUNT) AMOUNT
	from
		PRDWIPTRANS P
	where
		P.TXN_TYPE = 'REC'
		and P.ITEM_TYPE in ('ASS', 'COM')
	group by
		P.assembly_icode ,
		P.LOTCODE,
		P.JRCCODE) B on
	D.JRCCODE = B.JRCCODE
	and D.lotcode = B.lotcode
	and D.assembly_icode = B.assembly_icode
group by
	D.jrccode,
	L.LOTNO,
	I.category2,
	I.CATEGORY3,
	I.uom ,
	D.rate ,
	D.job_rate ,
	SA.SAINAME