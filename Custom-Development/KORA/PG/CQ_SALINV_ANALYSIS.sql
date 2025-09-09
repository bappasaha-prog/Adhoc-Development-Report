/* Formatted on 01-05-2024 11:06:42 (QP5 v5.294) */
/*cube$salinv*/
/*Modified Ticket : 420137 */

select   
	ROW_NUMBER() OVER() AS UK,
	null SEQ,
	null CUBE_CODE,
	null CUBENAME,
	null CREATOR,
	now()::timestamp REPORT_DATE,
	TO_DATE ('@DTFR@',
	'yyyy-mm-dd') START_DATE,
	TO_DATE ('@DTTO@',
	'yyyy-mm-dd') END_DATE,
	INVOICE_TYPE,
	ACCOUNTING_PERIOD,
	ADMSITE_CODE_SRC,
	ADMSITE_CODE_DES,
	CUSTOMER_CODE,
	DOCUMENT_SCHEME,
	INVOICE_NO,
	INVOICE_DATE,
	DOC_NO,
	DOC_DATE,
	DUE_DATE,
	AGENT_NAME,
	AGENT_ALIAS,
	AGENCY_COMMISSION,
	SALES_LEDGER,
	SALES_TERM_NAME,
	LOGISTIC_NO,
	LOGISTIC_DATE,
	LOGISTIC_DOCNO,
	LOGISTIC_DOCUMENT_DATE,
	LOGISTIC_QTY,
	GATEIN_NO,
	GATEIN_DATE,
	PREPARED_BY,
	PREPARED_TIME,
	LAST_ACCESS_BY,
	LAST_ACCESS_TIME,
	INVOICE_REMARKS,
	CHALLAN_NO,
	CHALLAN_DATE,
	BARCODE,
	ITEM_REMARKS,
	INVOICE_QTY,
	INVOICE_AMOUNT,
	INVOICE_GROSS_AMOUNT,
	INVOICE_CHARGE_AMOUNT,
	INVOICE_NET_AMOUNT,
	INVOICE_RATE,
	INVOICE_COSTRATE,
	INVOICE_ADJ_AMOUNT,
	INVOICE_TRANSPORTER,
	SALETYPE,
	SOURCE_TAXDET,
	LOGISTIC_DOC_DATE,
	RELEASE_STATUS,
	PRICELIST_NAME,
	INCLUDE_TAX,
	TRADE_GROUP_NAME,
	FORMNAME,
	INVOICE_RSP,
	DISCOUNT_FACTOR,
	INVOICE_TAX_RATE,
	INVOICE_TAX_NAME,
	INVOICE_TAX_AMOUNT,
	CGST_RATE,
	CGST_AMOUNT,
	SGST_RATE,
	SGST_AMOUNT,
	IGST_RATE,
	IGST_AMOUNT,
	CESS_RATE,
	CESS_AMOUNT,
	RELEASE_BY,
	RELEASE_ON,
	SALES_ORDER_NO,
	SALES_ORDER_DATE,
	FORM_NO,
	FORM_DATE,
	FORM_AMOUNT,
	LOCCODE,
	REFERENCE_NO,
	REFERENCE_DATE,
	UDFSTRING01,
	UDFSTRING02,
	UDFSTRING03,
	UDFSTRING04,
	UDFSTRING05,
	UDFSTRING06,
	UDFSTRING07,
	UDFSTRING08,
	UDFSTRING09,
	UDFSTRING10,
	UDFNUM01,
	UDFNUM02,
	UDFNUM03,
	UDFNUM04,
	UDFNUM05,
	UDFDATE01,
	UDFDATE02,
	UDFDATE03,
	UDFDATE04,
	UDFDATE05,
	/*Start Ticket : 420137 */
	"Transportation & Fright",
	"Discount (In Amount - Manual)",
	"Discount (In Percentage)",
	"Packing & Forwarding Charges",
	"Transportation Charges",
	"Trade Discount"
	/*End Ticket : 420137 */
from
	(
	select
		case
			when SITE.SITETYPE like '%CM%' then 'TRANSFER OUT'
			else 'SALES'
		end
                  INVOICE_TYPE,
		ADMYEAR.YNAME ACCOUNTING_PERIOD,
		M.ADMSITE_CODE_OWNER ADMSITE_CODE_SRC,
		M.ADMSITE_CODE ADMSITE_CODE_DES,
		M.PCODE CUSTOMER_CODE,
		DOCSH.DOCNAME DOCUMENT_SCHEME,
		M.SCHEME_DOCNO INVOICE_NO,
		M.INVDT INVOICE_DATE,
		M.DOCNO DOC_NO,
		M.DOCDT DOC_DATE,
		M.DUEDT DUE_DATE,
		A.SLNAME AGENT_NAME,
		A.ABBRE AGENT_ALIAS,
		M.AGRATE AGENCY_COMMISSION,
		G.GLNAME SALES_LEDGER,
		SALTERMMAIN.SALTERMNAME SALES_TERM_NAME,
		LGT.LGTNO LOGISTIC_NO,
		LGT.LGTDT LOGISTIC_DATE,
		LGT.DOCNO LOGISTIC_DOCNO,
		LGT.DOCDT LOGISTIC_DOCUMENT_DATE,
		LGT.QTY1 LOGISTIC_QTY,
		null GATEIN_NO,
		null::date GATEIN_DATE,
		HRDEMP.FNAME PREPARED_BY,
		M.TIME PREPARED_TIME,
		MODIFIED_EMP.FNAME LAST_ACCESS_BY,
		M.LAST_ACCESS_TIME LAST_ACCESS_TIME,
		M.REM INVOICE_REMARKS,
		D.SCHEME_DOCNO CHALLAN_NO,
		D.DCDT CHALLAN_DATE,
		D.ICODE BARCODE,
		D.REM ITEM_REMARKS,
		D.INVQTY INVOICE_QTY,
		D.INVAMT INVOICE_AMOUNT,
		D.INVAMT INVOICE_GROSS_AMOUNT,
		coalesce (TOT_CHG.TAX_AMOUNT,
		0) INVOICE_CHARGE_AMOUNT,
		coalesce (D.INVAMT,
		0) + coalesce (TOT_CHG.TAX_AMOUNT,
		0)
                  INVOICE_NET_AMOUNT,
		D.RATE INVOICE_RATE,
		D.COSTRATE INVOICE_COSTRATE,
		M.ADJAMT INVOICE_ADJ_AMOUNT,
		T.SLNAME INVOICE_TRANSPORTER,
		case
			M.SALETYPE
                  when 'O' then 'Outright'
			when 'C' then 'Consignment'
		end
                  SALETYPE,
		ginview.MIS_FUN_GET_TAXNAME (D.ICODE::varchar,
		M.INVDT::date,
		SRC.PSITE_ADMCMPTAX_CODE::int8,
		M.SALTRADEGRP_CODE::int8,
		M.FORMCODE::int8,
		D.MRP::numeric,
		D.RATE::numeric)
                  SOURCE_TAXDET,
		LGT.DOCDT LOGISTIC_DOC_DATE,
		case
			M.RELEASE_STATUS
                  when 'P' then 'Posted'
			when 'U' then 'Unposted'
			when 'R' then 'Reversed'
		end
                  RELEASE_STATUS,
		L.PRICELISTNAME PRICELIST_NAME,
		case
			coalesce (L.INCLUDE_VAT_IN_DISCOUNT,
			'N')
			when 'Y' then 'Yes'
			when 'N' then 'No'
		end
                  INCLUDE_TAX,
		R.NAME TRADE_GROUP_NAME,
		N.FORMNAME FORMNAME,
		D.MRP INVOICE_RSP,
		D.DISCOUNT_FACTOR DISCOUNT_FACTOR,
		null INVOICE_TAX_RATE,
		null INVOICE_TAX_NAME,
		CHG.TAX_AMOUNT INVOICE_TAX_AMOUNT,
		CHG.CGST_RATE,
		CHG.CGST_AMOUNT,
		CHG.SGST_RATE,
		CHG.SGST_AMOUNT,
		CHG.IGST_RATE,
		CHG.IGST_AMOUNT,
		CHG.CESS_RATE,
		CHG.CESS_AMOUNT,
		RLS.FNAME RELEASE_BY,
		M.RELEASE_TIME RELEASE_ON,
		D.SALES_ORDER_NO,
		D.SALES_ORDER_DATE,
		M.FORMNO FORM_NO,
		M.FORMDT FORM_DATE,
		M.FORMAMT FORM_AMOUNT,
		M.INLOCCODE LOCCODE,
		null REFERENCE_NO,
		null REFERENCE_DATE,
		M.UDFSTRING01,
		M.UDFSTRING02,
		M.UDFSTRING03,
		M.UDFSTRING04,
		M.UDFSTRING05,
		M.UDFSTRING06,
		M.UDFSTRING07,
		M.UDFSTRING08,
		M.UDFSTRING09,
		M.UDFSTRING10,
		M.UDFNUM01,
		M.UDFNUM02,
		M.UDFNUM03,
		M.UDFNUM04,
		M.UDFNUM05,
		M.UDFDATE01,
		M.UDFDATE02,
		M.UDFDATE03,
		M.UDFDATE04,
		M.UDFDATE05,
		"Transportation & Fright",
	    "Discount (In Amount - Manual)",
	    "Discount (In Percentage)",
	    "Packing & Forwarding Charges",
	    "Transportation Charges",
	    "Trade Discount"
	from
		SALINVMAIN M
	left outer join
               (
		select
			T1.CODE,
			T1.INVCODE,
			T2.SCHEME_DOCNO,
			T2.DCDT,
			T1.ICODE,
			SUM (coalesce (T1.INVQTY,
			0)) INVQTY,
			coalesce (T1.RATE,
			0) RATE,
			T1.REM,
			SUM (coalesce (T1.INVAMT,
			0)) INVAMT,
			T1.COSTRATE,
			T2.PRICELISTCODE,
			T1.MRP,
			T3.FACTOR DISCOUNT_FACTOR,
			T4.SCHEME_DOCNO SALES_ORDER_NO,
			T4.ORDDT SALES_ORDER_DATE
		from
			SALINVDET T1
		left outer join INVDCMAIN T2
                            on
			(T1.DCCODE = T2.DCCODE)
		inner join INVDCDET T3 on
			(T1.INVDCDET_CODE = T3.CODE)
		left outer join SALORDDET T5
                            on
			(T3.SALORDDET_CODE = T5.CODE)
		left outer join SALORDMAIN T4
                            on
			(T5.ORDCODE = T4.ORDCODE)
		where
			T1.INVCODE in
                            (
			select
				INVCODE
			from
				SALINVMAIN
			where
				INVDT between TO_DATE ('@DTFR@',
				'yyyy-mm-dd')
                                              and TO_DATE ('@DTTO@',
				'yyyy-mm-dd'))
		group by
			T1.CODE,
			T1.INVCODE,
			T2.SCHEME_DOCNO,
			T2.DCDT,
			T1.ICODE,
			T1.RATE,
			T1.REM,
			T1.COSTRATE,
			T2.PRICELISTCODE,
			T1.MRP,
			T3.FACTOR,
			T4.SCHEME_DOCNO,
			T4.ORDDT) D
                  on
		(M.INVCODE = D.INVCODE)
	inner join ADMYEAR on
		(M.YCODE = ADMYEAR.YCODE)
	inner join FINGL G on
		(M.GLCODE = G.GLCODE)
	left outer join SALTERMMAIN
                  on
		(M.SALTERMCODE = SALTERMMAIN.SALTERMCODE)
	left outer join FINSL A on
		(M.AGCODE = A.SLCODE)
	left outer join INVLGTNOTE LGT on
		(M.LGTCODE = LGT.LGTCODE)
	inner join HRDEMP on
		(M.ECODE = HRDEMP.ECODE)
	left outer join HRDEMP MODIFIED_EMP
                  on
		(M.LAST_ACCESS_ECODE = MODIFIED_EMP.ECODE)
	inner join ADMDOCSCHEME DOCSH on
		(M.DOCCODE = DOCSH.DOCCODE)
	inner join ADMSITE SITE on
		(M.ADMSITE_CODE = SITE.CODE)
	left outer join FINSL T on
		(M.TRPCODE = T.SLCODE)
	inner join ADMSITE SRC on
		(M.ADMSITE_CODE_OWNER = SRC.CODE)
	left outer join SALPRICELISTMAIN L
                  on
		(D.PRICELISTCODE = L.PRICELISTCODE)
	left outer join FINTRADEGRP R on
		(M.SALTRADEGRP_CODE = R.CODE)
	left outer join FINFORM N on
		(M.FORMCODE = N.FORMCODE)
	left outer join HRDEMP RLS on
		(M.RELEASE_ECODE = RLS.ECODE)
	left outer join
               (
		select
			SCI.SALINVDET_CODE,
			SUM (
                            case
				when SCI.SOURCE = 'G'
					and SCI.GST_COMPONENT = 'CGST'
                               then
                                  RATE
					else
                                  0
				end)
                            CGST_RATE,
			SUM (
                            case
				when SCI.SOURCE = 'G'
					and SCI.GST_COMPONENT = 'CGST'
                               then
                                  CHGAMT
					else
                                  0
				end)
                            CGST_AMOUNT,
			SUM (
                            case
				when SCI.SOURCE = 'G'
					and SCI.GST_COMPONENT = 'SGST'
                               then
                                  RATE
					else
                                  0
				end)
                            SGST_RATE,
			SUM (
                            case
				when SCI.SOURCE = 'G'
					and SCI.GST_COMPONENT = 'SGST'
                               then
                                  CHGAMT
					else
                                  0
				end)
                            SGST_AMOUNT,
			SUM (
                            case
				when SCI.SOURCE = 'G'
					and SCI.GST_COMPONENT = 'IGST'
                               then
                                  RATE
					else
                                  0
				end)
                            IGST_RATE,
			SUM (
                            case
				when SCI.SOURCE = 'G'
					and SCI.GST_COMPONENT = 'IGST'
                               then
                                  CHGAMT
					else
                                  0
				end)
                            IGST_AMOUNT,
			SUM (
                            case
				when SCI.SOURCE = 'G'
					and SCI.GST_COMPONENT = 'CESS'
                               then
                                  RATE
					else
                                  0
				end)
                            CESS_RATE,
			SUM (
                            case
				when SCI.SOURCE = 'G'
					and SCI.GST_COMPONENT = 'CESS'
                               then
                                  CHGAMT
					else
                                  0
				end)
                            CESS_AMOUNT,
			SUM (coalesce (SCI.CHGAMT,
			0)) TAX_AMOUNT
		from
			SALINVCHG_ITEM SCI,
			SALCHG SC
		where
			SCI.CHGCODE = SC.SALCHGCODE
			and coalesce (SCI.ISTAX,
			'N') = 'Y'
				and SCI.INVCODE in
                                (
				select
					INVCODE
				from
					SALINVMAIN
				where
					INVDT between TO_DATE ('@DTFR@',
					'yyyy-mm-dd')
                                                  and TO_DATE ('@DTTO@',
					'yyyy-mm-dd'))
			group by
				SCI.SALINVDET_CODE) CHG
                  on
		(D.CODE = CHG.SALINVDET_CODE)
	left outer join
               (
		select
			SALINVCHG_ITEM.SALINVDET_CODE,
			SUM (coalesce (SALINVCHG_ITEM.CHGAMT,
			0)) TAX_AMOUNT
		from
			SALINVCHG_ITEM,
			SALCHG
		where
			SALINVCHG_ITEM.CHGCODE = SALCHG.SALCHGCODE
			and SALINVCHG_ITEM.INVCODE in
                                (
			select
				INVCODE
			from
				SALINVMAIN
			where
				INVDT between TO_DATE ('@DTFR@',
				'yyyy-mm-dd')
                                                  and TO_DATE ('@DTTO@',
				'yyyy-mm-dd'))
		group by
			SALINVCHG_ITEM.SALINVDET_CODE) TOT_CHG
                  on
		(D.CODE = TOT_CHG.SALINVDET_CODE)
		left join (select
	m.invcode,
	m.salinvdet_code,
	sum(case when m.chgcode = 97185 then m.chgamt else 0 end ) "Transportation & Fright",
	sum(case when m.chgcode = 97265 then m.chgamt else 0 end ) "Discount (In Amount - Manual)",
	sum(case when m.chgcode = 10 then m.chgamt else 0 end ) "Discount (In Percentage)",
	sum(case when m.chgcode = 97245 then m.chgamt else 0 end ) "Packing & Forwarding Charges",
	sum(case when m.chgcode = 97445 then m.chgamt else 0 end ) "Transportation Charges",
	sum(case when m.chgcode = 97425 then m.chgamt else 0 end ) "Trade Discount"
from
	salinvchg_item m
where
	m.chgcode in (97185,
				  97265,
				  10,
				  97245,
				  97445,
				  97425)
	and M.INVCODE in
                                (
			select
				INVCODE
			from
				SALINVMAIN
			where
				INVDT between TO_DATE ('@DTFR@',
				'yyyy-mm-dd')
                                                  and TO_DATE ('@DTTO@',
				'yyyy-mm-dd'))
group by
	m.invcode,
	m.salinvdet_code) dis on D.CODE = dis.SALINVDET_CODE and d.INVCODE = dis.invcode
	where
		M.INVDT between TO_DATE ('@DTFR@',
		'yyyy-mm-dd')
                           and TO_DATE ('@DTTO@',
		'yyyy-mm-dd')
union all
	select
		case
			when SITE.SITETYPE like '%CM%' then 'TRANSFER IN'
			else 'RETURN'
		end
                  INVOICE_TYPE,
		ADMYEAR.YNAME ACCOUNTING_PERIOD,
		M.ADMSITE_CODE_OWNER ADMSITE_CODE_SRC,
		M.ADMSITE_CODE ADMSITE_CODE_DES,
		M.PCODE CUSTOMER_CODE,
		DOCSH.DOCNAME DOCUMENT_SCHEME,
		M.SCHEME_DOCNO INVOICE_NO,
		M.RTDT INVOICE_DATE,
		M.DOCNO DOC_NO,
		M.DOCDT DOC_DATE,
		null DUE_DATE,
		A.SLNAME AGENT_NAME,
		A.ABBRE AGENT_ALIAS,
		M.AGRATE AGENCY_COMMISSION,
		G.GLNAME SALES_LEDGER,
		SALTERMMAIN.SALTERMNAME SALES_TERM_NAME,
		LGT.LGTNO LOGISTIC_NO,
		LGT.LGTDT LOGISTIC_DATE,
		LGT.DOCNO LOGISTIC_DOCNO,
		LGT.DOCDT LOGISTIC_DOCUMENT_DATE,
		LGT.QTY1 LOGISTIC_QTY,
		ginview.MIS_FUN_DISPLAY_DOCNO ('GTI'::bpchar,
		GATE.YCODE::int4,
		GATE.GATEINNO::bpchar)
                  GATEIN_NO,
		GATEINDT GATEIN_DATE,
		HRDEMP.FNAME PREPARED_BY,
		M.TIME PREPARED_TIME,
		null LAST_ACCESS_BY,
		null LAST_ACCESS_TIME,
		M.REM INVOICE_REMARKS,
		D.SCHEME_DOCNO CHALLAN_NO,
		D.DCDT CHALLAN_DATE,
		D.ICODE BARCODE,
		D.REM ITEM_REMARKS,
		0 - D.QTY INVOICE_QTY,
		0 - D.RTAMT INVOICE_AMOUNT,
		0 - D.RTAMT INVOICE_GROSS_AMOUNT,
		0 - coalesce (TOT_CHG.TAX_AMOUNT,
		0) INVOICE_CHARGE_AMOUNT,
		0 - (coalesce (D.RTAMT,
		0) + coalesce (TOT_CHG.TAX_AMOUNT,
		0))
                  INVOICE_NET_AMOUNT,
		D.RATE INVOICE_RATE,
		D.COSTRATE INVOICE_COSTRATE,
		M.ADJAMT ADJAMT,
		null INVOICE_TRANSPORTER,
		case
			M.SALETYPE
                  when 'O' then 'Outright'
			when 'C' then 'Consignment'
		end
                  SALETYPE,
		ginview.MIS_FUN_GET_TAXNAME (D.ICODE::varchar,
		M.RTDT::date,
		SRC.PSITE_ADMCMPTAX_CODE::int8,
		M.SALTRADEGRP_CODE::int8,
		M.FORMCODE::int8,
		D.MRP::numeric,
		D.RATE::numeric)
                  SOURCE_TAXDET,
		LGT.DOCDT LOGISTIC_DOC_DATE,
		case
			M.RELEASE_STATUS
                  when 'P' then 'Posted'
			when 'U' then 'Unposted'
			when 'R' then 'Reversed'
		end
                  RELEASE_STATUS,
		null,
		null,
		R.NAME,
		N.FORMNAME,
		D.MRP,
		0 DISCOUNT_FACTOR,
		null INVOICE_TAX_RATE,
		null INVOICE_TAX_NAME,
		0 - CHG.TAX_AMOUNT INVOICE_TAX_AMOUNT,
		CHG.CGST_RATE,
		CHG.CGST_AMOUNT,
		CHG.SGST_RATE,
		CHG.SGST_AMOUNT,
		CHG.IGST_RATE,
		CHG.IGST_AMOUNT,
		CHG.CESS_RATE,
		CHG.CESS_AMOUNT,
		-- 005
		RLS.FNAME RELEASE_BY,
		M.RELEASE_TIME RELEASE_ON,
		null,
		null,
		M.FORMNO FORM_NO,
		M.FORMDT FORM_DATE,
		M.FORMAMT FORM_AMOUNT,
		M.INLOCCODE LOCODE,
		D.REFERENCE_NO,
		D.REFERENCE_DATE,
		M.UDFSTRING01,
		M.UDFSTRING02,
		M.UDFSTRING03,
		M.UDFSTRING04,
		M.UDFSTRING05,
		M.UDFSTRING06,
		M.UDFSTRING07,
		M.UDFSTRING08,
		M.UDFSTRING09,
		M.UDFSTRING10,
		M.UDFNUM01,
		M.UDFNUM02,
		M.UDFNUM03,
		M.UDFNUM04,
		M.UDFNUM05,
		M.UDFDATE01,
		M.UDFDATE02,
		M.UDFDATE03,
		M.UDFDATE04,
		M.UDFDATE05,
		"Transportation & Fright",
	    "Discount (In Amount - Manual)",
	    "Discount (In Percentage)",
	    "Packing & Forwarding Charges",
	    "Transportation Charges",
	    "Trade Discount"
	from
		SALRTMAIN M
	left outer join
               (
		select
			T1.CODE,
			RTCODE,
			SCHEME_DOCNO,
			DCDT,
			ICODE,
			SUM (coalesce (QTY,
			0)) QTY,
			coalesce (RATE,
			0) RATE,
			T1.REM,
			SUM (coalesce (RATE,
			0) * coalesce (QTY,
			0)) RTAMT,
			T1.COSTRATE,
			T1.MRP,
			T3.REFERENCE_NO,
			T3.REFERENCE_DATE
		from
			SALRTDET T1
		left outer join INVDCMAIN T2
                            on
			(T1.DCCODE = T2.DCCODE)
		left outer join
                         (
			select
				D.CODE,
				M.SCHEME_DOCNO REFERENCE_NO,
				M.INVDT REFERENCE_DATE
			from
				SALINVDET D,
				SALINVMAIN M
			where
				D.INVCODE = M.INVCODE) T3
                            on
			(T1.SALINVDET_CODE = T3.CODE)
		where
			T1.RTCODE in
                            (
			select
				RTCODE
			from
				SALRTMAIN
			where
				RTDT between TO_DATE ('@DTFR@',
				'yyyy-mm-dd')
                                             and TO_DATE ('@DTTO@',
				'yyyy-mm-dd'))
		group by
			T1.CODE,
			RTCODE,
			SCHEME_DOCNO,
			DCDT,
			ICODE,
			RATE,
			T1.REM,
			T1.COSTRATE,
			T1.MRP,
			T3.REFERENCE_NO,
			T3.REFERENCE_DATE) D
                  on
		(M.RTCODE = D.RTCODE)
	inner join ADMYEAR on
		(M.YCODE = ADMYEAR.YCODE)
	inner join FINGL G on
		(M.GLCODE = G.GLCODE)
	left outer join SALTERMMAIN
                  on
		(M.SALTERMCODE = SALTERMMAIN.SALTERMCODE)
	left outer join FINSL A on
		(M.AGCODE = A.SLCODE)
	left outer join INVLGTNOTE LGT on
		(M.LGTCODE = LGT.LGTCODE)
	inner join HRDEMP on
		(M.ECODE = HRDEMP.ECODE)
	left outer join INVGATEIN GATE
                  on
		(M.INVGATEIN_CODE = GATE.CODE)
	inner join ADMDOCSCHEME DOCSH on
		(M.DOCCODE = DOCSH.DOCCODE)
	inner join ADMSITE SITE on
		(M.ADMSITE_CODE = SITE.CODE)
	inner join ADMSITE SRC on
		(M.ADMSITE_CODE_OWNER = SRC.CODE)
	left outer join FINTRADEGRP R on
		(M.SALTRADEGRP_CODE = R.CODE)
	left outer join FINFORM N on
		(M.FORMCODE = N.FORMCODE)
	left outer join HRDEMP RLS on
		(M.RELEASE_ECODE = RLS.ECODE)
	left outer join
               (
		select
			SCI.SALRTDET_CODE,
			SUM (
                            case
				when SCI.SOURCE = 'G'
					and SCI.GST_COMPONENT = 'CGST'
                               then
                                  RATE
					else
                                  0
				end)
                            CGST_RATE,
			SUM (
                            case
				when SCI.SOURCE = 'G'
					and SCI.GST_COMPONENT = 'CGST'
                               then
                                  CHGAMT
					else
                                  0
				end)
                            CGST_AMOUNT,
			SUM (
                            case
				when SCI.SOURCE = 'G'
					and SCI.GST_COMPONENT = 'SGST'
                               then
                                  RATE
					else
                                  0
				end)
                            SGST_RATE,
			SUM (
                            case
				when SCI.SOURCE = 'G'
					and SCI.GST_COMPONENT = 'SGST'
                               then
                                  CHGAMT
					else
                                  0
				end)
                            SGST_AMOUNT,
			SUM (
                            case
				when SCI.SOURCE = 'G'
					and SCI.GST_COMPONENT = 'IGST'
                               then
                                  RATE
					else
                                  0
				end)
                            IGST_RATE,
			SUM (
                            case
				when SCI.SOURCE = 'G'
					and SCI.GST_COMPONENT = 'IGST'
                               then
                                  CHGAMT
					else
                                  0
				end)
                            IGST_AMOUNT,
			SUM (
                            case
				when SCI.SOURCE = 'G'
					and SCI.GST_COMPONENT = 'CESS'
                               then
                                  RATE
					else
                                  0
				end)
                            CESS_RATE,
			SUM (
                            case
				when SCI.SOURCE = 'G'
					and SCI.GST_COMPONENT = 'CESS'
                               then
                                  CHGAMT
					else
                                  0
				end)
                            CESS_AMOUNT,
			SUM (coalesce (SCI.CHGAMT,
			0)) TAX_AMOUNT
		from
			SALRTCHG_ITEM SCI,
			SALCHG SC
		where
			SCI.CHGCODE = SC.SALCHGCODE
			and coalesce (SCI.ISTAX,
			'N') = 'Y'
				and SCI.RTCODE in
                                (
				select
					RTCODE
				from
					SALRTMAIN
				where
					RTDT between TO_DATE ('@DTFR@',
					'yyyy-mm-dd')
                                                 and TO_DATE ('@DTTO@',
					'yyyy-mm-dd'))
			group by
				SCI.SALRTDET_CODE) CHG
                  on
		(D.CODE = CHG.SALRTDET_CODE)
	left outer join
               (
		select
			SALRTCHG_ITEM.SALRTDET_CODE,
			SUM (coalesce (SALRTCHG_ITEM.CHGAMT,
			0)) TAX_AMOUNT
		from
			SALRTCHG_ITEM,
			SALCHG
		where
			SALRTCHG_ITEM.CHGCODE = SALCHG.SALCHGCODE
			and SALRTCHG_ITEM.RTCODE in
                                (
			select
				RTCODE
			from
				SALRTMAIN
			where
				RTDT between TO_DATE ('@DTFR@',
				'yyyy-mm-dd')
                                                 and TO_DATE ('@DTTO@',
				'yyyy-mm-dd'))
		group by
			SALRTCHG_ITEM.SALRTDET_CODE) TOT_CHG
                  on
		(D.CODE = TOT_CHG.SALRTDET_CODE)
	left join (select
	m.rtcode,
	m.salrtdet_code,
	sum(case when m.chgcode = 97185 then m.chgamt else 0 end ) "Transportation & Fright",
	sum(case when m.chgcode = 97265 then m.chgamt else 0 end ) "Discount (In Amount - Manual)",
	sum(case when m.chgcode = 10 then m.chgamt else 0 end ) "Discount (In Percentage)",
	sum(case when m.chgcode = 97245 then m.chgamt else 0 end ) "Packing & Forwarding Charges",
	sum(case when m.chgcode = 97445 then m.chgamt else 0 end ) "Transportation Charges",
	sum(case when m.chgcode = 97425 then m.chgamt else 0 end ) "Trade Discount"
from
	salrtchg_item m
where
	m.chgcode in (97185,
				  97265,
				  10,
				  97245,
				  97445,
				  97425)
	and M.rtcode in
                                (
			select
				RTCODE
			from
				SALRTMAIN
			where
				RTDT::DATE between TO_DATE ('@DTFR@',
				'yyyy-mm-dd')
                                                  and TO_DATE ('@DTTO@',
				'yyyy-mm-dd'))
group by
	m.rtcode,
	m.salrtdet_code) DIS on D.CODE = DIS.salrtdet_code and D.RTCODE = DIS.RTCODE
	where
		M.RTDT between TO_DATE ('@DTFR@',
		'yyyy-mm-dd')
                          and TO_DATE ('@DTTO@',
		'yyyy-mm-dd') 
		)