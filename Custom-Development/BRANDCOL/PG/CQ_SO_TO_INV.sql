/*|| Custom Development || Object : CQ_SO_TO_INV || Ticket Id :  413252 || Developer : Dipankar ||*/

select
	row_number() over() as UK,
    M.ADMSITE_CODE_OWNER,
    M.ADMSITE_CODE,
	S.NAME SITE_NAME,
	M.SCHEME_DOCNO ORDER_NO,
	M.ORDDT::DATE ORDER_DATE,
	M.TIME ORDER_TIME,
	H.FNAME AUTHORIZED_BY,
	M.AUTHORIZATIONTIME::DATE AUTHORIZED_ON,
	RESERVE_NO,
	RESERVE_DATE,
	PICKLIST_NO,
	PICKLIST_DATE,
	DC_NO,
	DC_DATE,
	M.DOCNO ORDER_DOC_NO,
	SL.SLNAME CUSTOMER,
	DS.NAME DES_SITE_NAME,
	INVOICE_NO,
	INVOICE_DATE,
	LR_DOC_NO,
	LR_DOC_DATE,
	DELIVERED_DATE,
	DELIVERD_BY,
	OTHER_REMARKS2,
	OTHER_REMARKS3,
	LR_REMARKS,
	LR_TRANSPORTER,
	ORDER_QTY,
	SO_CANCEL_QTY,
	ORDER_MRP_VALUE,
	RESERVE_QTY,
	reserve_cancel_qty,
	ORDER_QTY - RESERVE_QTY SO_PENDING_QTY,
	picklist_qty,
	confirm_qty,
	pick_cancel_qty,
	ISQTY DC_QTY,
	BILL_QTY,
	BILL_MRP_VALUE,
	ORDER_TOTAL_VALUE,
	BILL_TOTAL_VALUE,
	RESERVE_QTY - BILL_QTY PENDING_QTY
from
	SALORDMAIN M
inner join (
	select
		D.ORDCODE,
		SUM(coalesce(D.ORDQTY, 0)) ORDER_QTY,
		SUM(coalesce(D.cnlqty, 0)) SO_CANCEL_QTY,
		SUM(coalesce(D.ORDQTY, 0) * I.MRP) ORDER_MRP_VALUE,
		sum( case when coalesce(D.netamt, 0) = 0 then coalesce(D.ordqty, 0) * coalesce(D.rate, 0)
                    else coalesce(D.netamt, 0)
                end) + sum(coalesce(D.chgamt, 0)) + sum(coalesce(D.taxamt, 0)) ORDER_TOTAL_VALUE
	from
		sALORDDET D
	inner join GINVIEW.LV_ITEM I on
		D.ICODE = I.CODE
	group by
		D.ORDCODE ) D on
	M.ORDCODE = D.ORDCODE
inner join ADMSITE S on
	M.ADMSITE_CODE_OWNER = S.CODE
left join FINSL SL on
	M.PCODE = SL.SLCODE
left join HRDEMP H on
	M.AUTHORCODE = H.ECODE
inner join ADMSITE DS on
	M.ADMSITE_CODE = DS.CODE
left join (
	select
		D.ORDCODE,
		STRING_AGG(distinct M.SCHEME_DOCNO, ',' order by M.SCHEME_DOCNO) DC_NO,
		STRING_AGG(distinct TO_CHAR(M.DCDT, 'DD-MM-YYYY'), ',' order by TO_CHAR(M.DCDT, 'DD-MM-YYYY')) DC_DATE,
		sum(coalesce(D.ISQTY, 0)) ISQTY
	from
		INVDCDET d
	inner join INVDCMAIN m on
		d.DCCODE = m.dccode
	where
		D.SALORDDET_CODE is not null
	group by
		D.ORDCODE) DCD on
	M.ORDCODE = DCD.ORDCODE
left join (
	select
		SD.ORDCODE,
		STRING_AGG(distinct M.SCHEME_DOCNO, ',' order by M.SCHEME_DOCNO) PICKLIST_NO,
		STRING_AGG(distinct TO_CHAR(M.ENTDT, 'DD-MM-YYYY'), ',' order by TO_CHAR(M.ENTDT, 'DD-MM-YYYY')) PICKLIST_DATE,
		SUM(coalesce(D.picklist_qty, 0)) picklist_qty,
		SUM(coalesce(D.confirm_qty, 0)) confirm_qty,
		SUM(coalesce(D.cancel_qty, 0)) pick_cancel_qty
	from
		INVPICKLISTDET d
	inner join INVPICKLISTMAIN m on
		D.invpicklistmain_code = M.CODE
	inner join sALORDDET SD on
		D.ORDDET_CODE = SD.CODE
	group by
		SD.ORDCODE ) PD on
	M.ORDCODE = PD.ORDCODE
left join (
	select
		SD.ORDCODE,
		STRING_AGG(distinct M.SCHEME_DOCNO, ',' order by M.SCHEME_DOCNO) RESERVE_NO,
		STRING_AGG(distinct TO_CHAR(M.ENTDT, 'DD-MM-YYYY'), ',' order by TO_CHAR(M.ENTDT, 'DD-MM-YYYY')) RESERVE_DATE,
		SUM(coalesce(D.RESERVE_QTY, 0)) RESERVE_QTY,
		SUM(coalesce(D.cancel_qty, 0)) reserve_cancel_qty
	from
		INVRESERVEDET d
	inner join INVRESERVEMAIN m on
		D.INVRESERVEMAIN_CODE = M.CODE
	inner join sALORDDET SD on
		D.ORDDET_CODE = SD.CODE
	group by
		SD.ORDCODE) RD on
	M.ORDCODE = RD.ORDCODE
left join (
	select
		DC.ORDCODE,
		STRING_AGG(distinct M.SCHEME_DOCNO, ',' order by M.SCHEME_DOCNO) INVOICE_NO,
		STRING_AGG(distinct TO_CHAR(M.INVDT, 'DD-MM-YYYY'), ',' order by TO_CHAR(M.INVDT, 'DD-MM-YYYY')) INVOICE_DATE,
		STRING_AGG(distinct L.DOCNO, ',' order by L.DOCNO) LR_DOC_NO,
		STRING_AGG(distinct TO_CHAR(L.DOCDT, 'DD-MM-YYYY'), ',' order by TO_CHAR(L.DOCDT, 'DD-MM-YYYY')) LR_DOC_DATE,
		STRING_AGG(distinct TO_CHAR(L.UDFDATE01, 'DD-MM-YYYY'), ',' order by TO_CHAR(L.UDFDATE01, 'DD-MM-YYYY')) DELIVERED_DATE,
		STRING_AGG(distinct L.UDFSTRING01, ',' order by L.UDFSTRING01) DELIVERD_BY,
		STRING_AGG(distinct L.UDFSTRING02, ',' order by L.UDFSTRING02) OTHER_REMARKS2,
		STRING_AGG(distinct L.UDFSTRING03, ',' order by L.UDFSTRING03) OTHER_REMARKS3,
		STRING_AGG(distinct L.REM, ',' order by L.REM) LR_REMARKS,
		STRING_AGG(distinct T.SLNAME, ',' order by T.SLNAME) LR_TRANSPORTER,
		SUM(coalesce(D.INVQTY, 0)) BILL_QTY,
		SUM(coalesce(D.INVQTY, 0) * I.MRP) BILL_MRP_VALUE,
		sum(coalesce(D.invamt, 0) + coalesce(D.chgamt, 0) + coalesce(D.taxamt, 0)) BILL_TOTAL_VALUE
	from
		INVDCDET DC
	inner join SALINVDET D on
		DC.CODE = D.INVDCDET_CODE
	inner join SALINVMAIN M on
		D.INVCODE = M.INVCODE
	left join INVLGTNOTE L on
		M.LGTCODE = L.LGTCODE
	left join FINSL T on
		L.TRPCODE = T.TRPCODE
	inner join GINVIEW.LV_ITEM I on
		D.ICODE = I.CODE
	where
		DC.SALORDDET_CODE is not null
		and DC.ORDCODE is not null
	group by
		DC.ORDCODE)SD on 
		M.ORDCODE = SD.ORDCODE
where
		M.ORDDT::DATE between TO_DATE('@DTFR@', 'YYYY-MM-DD') and TO_DATE('@DTTO@', 'YYYY-MM-DD')