/*><><>< || Custom Development || Object : CQ_SO_STOCK || Ticket Id : 395417 || Developer : Dipankar || ><><><*/
select
	GINVIEW.FNC_UK() UK,
	A.ICODE,
	A.PCODE,
	A.ORDER_DATE,
	A.ORDER_NO,
	A.ORDER_QTY,
	A.DELIVERY_QTY,
	A.PENDING_QTY,
	A.TOTAL_ORDER_QTY,
	A.TOTAL_DELIVERY_QTY,
	A.TOTAL_PENDING_QTY,
	B.SITE_NAME,
	B.STOCKPOINT,
	B.STOCK_QTY
from
	(
	select
		D.icode,
		M.pcode,
		M.orddt::DATE ORDER_DATE,
		M.scheme_docno ORDER_NO,
		SUM(coalesce(D.ordqty,0)) ORDER_QTY,
		SUM(coalesce(D.dqty,0)) DELIVERY_QTY,
		SUM(coalesce(D.ordqty,0)-coalesce(D.dqty,0)-coalesce(D.cnlqty,0)) PENDING_QTY,
		SUM(SUM(coalesce(D.ordqty,0))) over (partition by I.CATEGORY2) TOTAL_ORDER_QTY,
		SUM(SUM(coalesce(D.dqty,0))) over (partition by I.CATEGORY2) TOTAL_DELIVERY_QTY,
		SUM(SUM(coalesce(D.ordqty,0)-coalesce(D.dqty,0)-coalesce(D.cnlqty,0))) over (partition by I.CATEGORY2) TOTAL_PENDING_QTY
	from
		SALORDMAIN M
	inner join SALORDDET D on
		M.ORDCODE = D.ORDCODE
	inner join GINVIEW.LV_ITEM I on
		D.icode = I.code
	where
		M.orddt::DATE between TO_DATE('@DTFR@',
		'YYYY-MM-DD') and TO_DATE('@DTTO@',
		'YYYY-MM-DD')
	group by
		D.icode,
		M.pcode,
		M.orddt::DATE,
		M.scheme_docno,
		I.CATEGORY2) A
inner join (
	select
		K.icode,
		S.name SITE_NAME,
		L.locname STOCKPOINT,
		SUM(K.qty) STOCK_QTY
	from
		invstock_onhand K
	inner join ADMSITE S on
		K.admsite_code = S.code
	left join INVLOC L on
		K.loccode = L.loccode
	group by
		K.icode,
		S.name,
		L.locname) B on
	A.ICODE = B.ICODE