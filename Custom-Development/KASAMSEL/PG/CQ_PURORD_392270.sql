/* Formatted on 2025-02-11 12:23:34 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_PURORD || Ticket Id : 392270 || Developer : Dipankar || ><><><*/
with SITE_DATA
     as (
select
	ST.CODE SITECODE,
	ST.NAME NAME,
	ST.SHRTNAME SHORT_CODE,
	ST.ADDRESS ADDRESS,
	ST.CTNAME CITY,
	B.STNAME STATE,
	B.DIST DISTRICT,
	ST.PIN PINCODE,
	ST.OPH1 PHONE1,
	ST.OPH2 PHONE2,
	ST.OPH3 PHONE3,
	ST.EMAIL1 EMAIL1,
	ST.EMAIL2 EMAIL2,
	case
		when SITETYPE like '%OO-CM'
		or SITETYPE = 'MS-CO-CM'
                   then
                      SIN.GSTIN_NO
		else
                      ST.CP_GSTIN_NO
	end
                   GST_IDENTIFICATION_NO,
	case
		when SITETYPE like '%OO-CM'
		or SITETYPE = 'MS-CO-CM'
                   then
                      SIN.ADMGSTSTATE_CODE
		else
                      ST.CP_GSTIN_STATE_CODE
	end
                   GST_STATE_CODE,
	case
		when SITETYPE like '%OO-CM'
		or SITETYPE = 'MS-CO-CM'
                   then
                      STA.NAME
		else
                      STA1.NAME
	end
                   GST_STATE_NAME,
	case
		when ST.SITETYPE like '%OM%'
                   then
                      case
			when ISBILLINGSHIPPINGSAME = 'Y' then F.SLNAME
			else ST.SHIP_LEGAL_NAME
		end
		else
                      O.NAME
	end
                   SHIPPING_COMPANY_NAME,
	case
		when ISBILLINGSHIPPINGSAME = 'Y' then ST.ADDRESS
		else ST.SHIP_ADDRESS
	end
                   SHIPPING_ADDRESS,
	case
		when ISBILLINGSHIPPINGSAME = 'Y' then ST.CTNAME
		else ST.SHIP_CTNAME
	end
                   SHIPPING_CITY,
	case
		when ISBILLINGSHIPPINGSAME = 'Y' then ST.PIN
		else ST.SHIP_PIN
	end
                   SHIPPING_PINCODE,
	case
		when ISBILLINGSHIPPINGSAME = 'Y' then ST.OPH1
		else ST.SHIP_OPH1
	end
                   SHIPPING_PHONE1,
	case
		when ISBILLINGSHIPPINGSAME = 'Y' then ST.OPH2
		else ST.SHIP_OPH2
	end
                   SHIPPING_PHONE2,
	case
		when ISBILLINGSHIPPINGSAME = 'Y' then ST.OPH3
		else ST.SHIP_OPH3
	end
                   SHIPPING_PHONE3,
	case
		when ISBILLINGSHIPPINGSAME = 'Y' then ST.EMAIL1
		else ST.SHIP_EMAIL1
	end
                   SHIPPING_EMAIL1,
	case
		when ST.SITETYPE like '%CM'
                   then
                      SIN.GSTIN_NO
		else
                      case
			when ISBILLINGSHIPPINGSAME = 'Y' then ST.CP_GSTIN_NO
			else ST.SHIP_CP_GSTIN_NO
		end
	end
                   SHIPPING_GST_IDENTIFICATION_NO,
	case
		when ST.SITETYPE like '%CM'
                   then
                      SIN.ADMGSTSTATE_CODE
		else
                      case
			when ISBILLINGSHIPPINGSAME = 'Y'
                         then
                            ST.CP_GSTIN_STATE_CODE
			else
                            ST.SHIP_CP_GSTIN_STATE_CODE
		end
	end
                   SHIPPING_GST_STATE_CODE,
	case
		when ST.SITETYPE like '%CM'
                   then
                      STA.NAME
		else
                      case
			when ISBILLINGSHIPPINGSAME = 'Y' then STA1.NAME
			else STA2.NAME
		end
	end
                   SHIPPING_GST_STATE_NAME,
	ST.WEBSITE
from
	ADMSITE ST
left outer join FINSL F on
	ST.SLCODE = F.SLCODE
left outer join ADMCITY B on
	ST.CTNAME = B.CTNAME
left outer join ADMOU O on
	ST.ADMOU_CODE = O.CODE
left outer join ADMGSTIN SIN on
	ST.ADMGSTIN_CODE = SIN.CODE
left outer join ADMGSTSTATE STA
                   on
	SIN.ADMGSTSTATE_CODE = STA.CODE
left outer join ADMGSTSTATE STA1
                   on
	ST.CP_GSTIN_STATE_CODE = STA1.CODE
left outer join ADMGSTSTATE STA2
                   on
	ST.SHIP_CP_GSTIN_STATE_CODE = STA2.CODE)
select
	GINVIEW.FNC_UK UK,
	H.ORDCODE L1_ORDCODE,
	H.ORDER_DATE L1_ORDER_DATE,
	H.PCODE L1_PCODE,
	H.DOCUMENT_NO L1_DOCUMENT_NO,
	H.AGCODE L1_AGCODE,
	H.AGENT_NAME L1_AGENT_NAME,
	H.AGENT_RATE L1_AGENT_RATE,
	H.TRPCODE L1_TRPCODE,
	H.TRANSPORTER_NAME L1_TRANSPORTER_NAME,
	H.INV_STATUS L1_INV_STATUS,
	H.AUTHORIZED_BY L1_AUTHORIZED_BY,
	H.REMARKS L1_REMARKS,
	H.CREATED_BY L1_CREATED_BY,
	H.CREATED_ON L1_CREATED_ON,
	H.VALID_FROM L1_VALID_FROM,
	H.VALID_TILL L1_VALID_TILL,
	H.LAST_ACCESSED_ON L1_LAST_ACCESSED_ON,
	H.LAST_ACCESSED_BY L1_LAST_ACCESSED_BY,
	H.TERMS L1_TERMS,
	H.TYPE L1_TYPE,
	H.ORDER_NO L1_ORDER_NO,
	H.ADMOU_CODE L1_ADMOU_CODE,
	H.MERCHANDISER L1_MERCHANDISER,
	H.TRADE_GROUP_NAME L1_TRADE_GROUP_NAME,
	H.INV_GROSS_AMOUNT L1_INV_GROSS_AMOUNT,
	H.INV_CHARGE_AMOUNT L1_INV_CHARGE_AMOUNT,
	H.NET_AMOUNT L1_NET_AMOUNT,
	H.CURRENCY L1_CURRENCY,
	H.CURRENCY_DECIMAL_SYMBOL L1_CURRENCY_DECIMAL_SYMBOL,
	H.CURRENCY_SYMBOL L1_CURRENCY_SYMBOL,
	H.CURRENCY_EXCHANGE_RATE L1_CURRENCY_EXCHANGE_RATE,
	H.ADMSITE_CODE L1_ADMSITE_CODE,
	H.SHIPMENT_TRACKING_APPLICABLE L1_SHIPMENT_TRACK_APPLICABLE,
	H.PURCHASE_TERM_NAME L1_PURCHASE_TERM_NAME,
	H.PURORDMAIN_UDFSTRIN01 L1_PURORDMAIN_UDFSTRIN01,
	H.PURORDMAIN_UDFSTRIN02 L1_PURORDMAIN_UDFSTRIN02,
	H.PURORDMAIN_UDFSTRIN03 L1_PURORDMAIN_UDFSTRIN03,
	H.PURORDMAIN_UDFSTRIN04 L1_PURORDMAIN_UDFSTRIN04,
	H.PURORDMAIN_UDFSTRIN05 L1_PURORDMAIN_UDFSTRIN05,
	H.PURORDMAIN_UDFSTRIN06 L1_PURORDMAIN_UDFSTRIN06,
	H.PURORDMAIN_UDFSTRIN07 L1_PURORDMAIN_UDFSTRIN07,
	H.PURORDMAIN_UDFSTRIN08 L1_PURORDMAIN_UDFSTRIN08,
	H.PURORDMAIN_UDFSTRIN09 L1_PURORDMAIN_UDFSTRIN09,
	H.PURORDMAIN_UDFSTRIN010 L1_PURORDMAIN_UDFSTRIN010,
	H.PURORDMAIN_UDFNUM01 L1_PURORDMAIN_UDFNUM01,
	H.PURORDMAIN_UDFNUM02 L1_PURORDMAIN_UDFNUM02,
	H.PURORDMAIN_UDFNUM03 L1_PURORDMAIN_UDFNUM03,
	H.PURORDMAIN_UDFNUM04 L1_PURORDMAIN_UDFNUM04,
	H.PURORDMAIN_UDFNUM05 L1_PURORDMAIN_UDFNUM05,
	H.PURORDMAIN_UDFDATE01 L1_PURORDMAIN_UDFDATE01,
	H.PURORDMAIN_UDFDATE02 L1_PURORDMAIN_UDFDATE02,
	H.PURORDMAIN_UDFDATE03 L1_PURORDMAIN_UDFDATE03,
	H.PURORDMAIN_UDFDATE04 L1_PURORDMAIN_UDFDATE04,
	H.PURORDMAIN_UDFDATE05 L1_PURORDMAIN_UDFDATE05,
	H.AUTHORIZED_ON L1_AUTHORIZED_ON,
	H.CUST_NAME L1_CUST_NAME,
	H.CUST_BILLING_ADDRESS L1_CUST_BILLING_ADDRESS,
	H.CUST_BILLING_CONTACT_PERSON L1_CUST_BILLING_CONTACT_PERSON,
	H.CUST_BILLING_CITY L1_CUST_BILLING_CITY,
	H.CUST_BILLING_STATE L1_CUST_BILLING_STATE,
	H.CUST_BILLING_DISTRICT L1_CUST_BILLING_DISTRICT,
	H.CUST_BILLING_ZONE L1_CUST_BILLING_ZONE,
	H.CUST_BILLING_EMAIL1 L1_CUST_BILLING_EMAIL1,
	H.CUST_BILLING_EMAIL2 L1_CUST_BILLING_EMAIL2,
	H.CUST_BILLING_FAX L1_CUST_BILLING_FAX,
	H.CUST_BILLING_MOBILE L1_CUST_BILLING_MOBILE,
	H.CUST_BILLING_OFFICE_PHONE1 L1_CUST_BILLING_OFFICE_PHONE1,
	H.CUST_BILLING_OFFICE_PHONE2 L1_CUST_BILLING_OFFICE_PHONE2,
	H.CUST_BILLING_OFFICE_PHONE3 L1_CUST_BILLING_OFFICE_PHONE3,
	H.CUST_BILLING_PINCODE L1_CUST_BILLING_PINCODE,
	H.CUST_BILLING_WEBSITE L1_CUST_BILLING_WEBSITE,
	H.CUST_GSTIN_NO L1_CUST_GSTIN_NO,
	H.CUST_GST_STATE_NAME L1_CUST_GST_STATE_NAME,
	H.CUST_GST_STATE_CODE L1_CUST_GST_STATE_CODE,
	H.CUST_CREDIT_DAYS L1_CUST_CREDIT_DAYS,
	H.CUST_IDENTITY_NO L1_CUST_IDENTITY_NO,
	H.ORGUNIT_NAME L1_ORGUNIT_NAME,
	H.ORGUNIT_WEBSITE L1_ORGUNIT_WEBSITE,
	H.ORGUNIT_CIN L1_ORGUNIT_CIN,
	H.OWNER_SITE_NAME L1_OWNER_SITE_NAME,
	H.OWNER_SHORT_CODE L1_OWNER_SHORT_CODE,
	H.OWNER_SITE_ADDRESS L1_OWNER_SITE_ADDRESS,
	H.OWNER_SITE_CITY L1_OWNER_SITE_CITY,
	H.OWNER_SITE_PINCODE L1_OWNER_SITE_PINCODE,
	H.OWNER_SITE_PHONE1 L1_OWNER_SITE_PHONE1,
	H.OWNER_SITE_PHONE2 L1_OWNER_SITE_PHONE2,
	H.OWNER_SITE_PHONE3 L1_OWNER_SITE_PHONE3,
	H.OWNER_SITE_EMAIL1 L1_OWNER_SITE_EMAIL1,
	H.OWNER_SITE_EMAIL2 L1_OWNER_SITE_EMAIL2,
	H.OWNER_GSTIN_NO L1_OWNER_GSTIN_NO,
	H.OWNER_GST_STATE_CODE L1_OWNER_GST_STATE_CODE,
	H.OWNER_GST_STATE_NAME L1_OWNER_GST_STATE_NAME,
	H.OWNER_SITE_WEBSITE L1_OWNER_SITE_WEBSITE,
	D.LVL,
	D.SEQ,
	D.ARTICLE_NAME L2_ARTICLE_NAME,
	D.STYLE_NO L2_STYLE_NO,
	D.RATE L2_RATE,
	D.AMOUNT L2_AMOUNT,
	D.TOTAL_QTY L2_TOTAL_QTY,
	D.SIZE1 L2_SIZE1,
	D.SIZE2 L2_SIZE2,
	D.SIZE3 L2_SIZE3,
	D.SIZE4 L2_SIZE4,
	D.SIZE5 L2_SIZE5,
	D.SIZE6 L2_SIZE6,
	D.SIZE7 L2_SIZE7,
	D.SIZE8 L2_SIZE8,
	D.SIZE9 L2_SIZE9,
	D.SIZE10 L2_SIZE10,
	D.SIZE11 L2_SIZE11,
	D.SIZE12 L2_SIZE12,
	D.SIZE13 L2_SIZE13,
	D.SIZE14 L2_SIZE14,
	D.SIZE15 L2_SIZE15,
	D.SIZE16 L2_SIZE16,
	D.SIZE17 L2_SIZE17,
	D.SIZE18 L2_SIZE18,
	D.SIZE19 L2_SIZE19,
	D.SIZE20 L2_SIZE20,
	D.CHARGE_APPLICABLE_ON L3_CHARGE_APPLICABLE_ON,
	D.CHARGE_BASIS L3_CHARGE_BASIS,
	D.CHARGE_AMOUNT L3_CHARGE_AMOUNT,
	D.CHARGE_NAME L3_CHARGE_NAME,
	D.OPERATION_LEVEL L3_OPERATION_LEVEL,
	D.CHARGE_RATE L3_CHARGE_RATE,
	D.DISPLAY_SEQUENCE L3_DISPLAY_SEQUENCE,
	D.HSN_ORDER_QUANTITY L4_ORDER_QUANTITY,
	D.HSN_CODE L4_HSN_CODE,
	D.HSN_SAC_ID L4_HSN_SAC_ID,
	D.HSN_DESCRIPTION L4_HSN_DESCRIPTION,
	D.HSN_UOM L4_HSN_UOM,
	D.HSN_TAXABLE_AMOUNT L4_TAXABLE_AMOUNT,
	D.HSN_CGST_RATE L4_CGST_RATE,
	D.HSN_CGST_AMOUNT L4_CGST_AMOUNT,
	D.HSN_SGST_RATE L4_SGST_RATE,
	D.HSN_SGST_AMOUNT L4_SGST_AMOUNT,
	D.HSN_IGST_RATE L4_IGST_RATE,
	D.HSN_IGST_AMOUNT L4_IGST_AMOUNT,
	D.HSN_CESS_RATE L4_CESS_RATE,
	D.HSN_CESS_AMOUNT L4_CESS_AMOUNT,
	D.SCHEDULE_DATE L5_SCHEDULE_DATE,
	D.SCHEDULE_ORDER_QUANTITY L5_SCHEDULE_ORDER_QUANTITY
from
	(
	select
		M.ORDCODE ORDCODE,
		ORDDT ORDER_DATE,
		PCODE PCODE,
		DOCNO DOCUMENT_NO,
		M.AGCODE AGCODE,
		AG.SLNAME AGENT_NAME,
		M.AGRATE AGENT_RATE,
		M.TRPCODE TRPCODE,
		TP.SLNAME TRANSPORTER_NAME,
		INITCAP (
                  case
			when M.STAT = 'P' then 'PARTIAL RECEIVED'
			when M.STAT = 'T' then 'TOTAL RECEIVED/CANCELLED'
			when M.STAT = 'N' then 'NEW'
			else 'TOTAL RECEIVED/CANCELLED'
		end)
                  INV_STATUS,
		( (AU.FNAME || ' [') || AU.ENO) || ']' AUTHORIZED_BY,
		M.REM REMARKS,
		( (CR.FNAME || ' [') || CR.ENO) || ']' CREATED_BY,
		TIME CREATED_ON,
		M.DTFR VALID_FROM,
		M.DTTO VALID_TILL,
		LAST_ACCESS_TIME LAST_ACCESSED_ON,
		( (LA.FNAME || ' [') || LA.ENO) || ']' LAST_ACCESSED_BY,
		PAYTERM TERMS,
		INITCAP (
                  case
			when M.WHETHER_CONSIGNMENT = 'Y' then 'YES'
			when M.WHETHER_CONSIGNMENT = 'N' then 'NO'
		end)
                  type,
		SCHEME_DOCNO ORDER_NO,
		M.ADMOU_CODE ADMOU_CODE,
		( (MR.FNAME || ' [') || MR.ENO) || ']' MERCHANDISER,
		TR.NAME TRADE_GROUP_NAME,
		GRSAMT INV_GROSS_AMOUNT,
		CHGAMT INV_CHARGE_AMOUNT,
		NETAMT NET_AMOUNT,
		CUR.SHORTCODE CURRENCY,
		DECIMAL_SYMBOL CURRENCY_DECIMAL_SYMBOL,
		SYMBOL CURRENCY_SYMBOL,
		EXRATE CURRENCY_EXCHANGE_RATE,
		ADMSITE_CODE ADMSITE_CODE,
		INITCAP (
                  case
			when M.ENABLE_LGT_TRACK = 0 then 'NO'
			when M.ENABLE_LGT_TRACK = 1 then 'YES'
			else 'NO'
		end)
                  SHIPMENT_TRACKING_APPLICABLE,
		TRM.NAME PURCHASE_TERM_NAME,
		M.UDFSTRING01 PURORDMAIN_UDFSTRIN01,
		M.UDFSTRING02 PURORDMAIN_UDFSTRIN02,
		M.UDFSTRING03 PURORDMAIN_UDFSTRIN03,
		M.UDFSTRING04 PURORDMAIN_UDFSTRIN04,
		M.UDFSTRING05 PURORDMAIN_UDFSTRIN05,
		M.UDFSTRING06 PURORDMAIN_UDFSTRIN06,
		M.UDFSTRING07 PURORDMAIN_UDFSTRIN07,
		M.UDFSTRING08 PURORDMAIN_UDFSTRIN08,
		M.UDFSTRING09 PURORDMAIN_UDFSTRIN09,
		M.UDFSTRING10 PURORDMAIN_UDFSTRIN010,
		M.UDFNUM01 PURORDMAIN_UDFNUM01,
		M.UDFNUM02 PURORDMAIN_UDFNUM02,
		M.UDFNUM03 PURORDMAIN_UDFNUM03,
		M.UDFNUM04 PURORDMAIN_UDFNUM04,
		M.UDFNUM05 PURORDMAIN_UDFNUM05,
		M.UDFDATE01 PURORDMAIN_UDFDATE01,
		M.UDFDATE02 PURORDMAIN_UDFDATE02,
		M.UDFDATE03 PURORDMAIN_UDFDATE03,
		M.UDFDATE04 PURORDMAIN_UDFDATE04,
		M.UDFDATE05 PURORDMAIN_UDFDATE05,
		AUTHORIZATIONTIME AUTHORIZED_ON,
		CUST_NAME,
		CUST_BILLING_ADDRESS,
		CUST_BILLING_CONTACT_PERSON,
		CUST_BILLING_CITY,
		CUST_BILLING_STATE,
		CUST_BILLING_DISTRICT,
		CUST_BILLING_ZONE,
		CUST_BILLING_EMAIL1,
		CUST_BILLING_EMAIL2,
		CUST_BILLING_FAX,
		CUST_BILLING_MOBILE,
		CUST_BILLING_OFFICE_PHONE1,
		CUST_BILLING_OFFICE_PHONE2,
		CUST_BILLING_OFFICE_PHONE3,
		CUST_BILLING_PINCODE,
		CUST_BILLING_WEBSITE,
		CUST_GSTIN_NO,
		CUST_GST_STATE_NAME,
		CUST_GST_STATE_CODE,
		CUST_CREDIT_DAYS,
		CUST_IDENTITY_NO,
		OU.NAME ORGUNIT_NAME,
		OU.WEBSITE ORGUNIT_WEBSITE,
		OU.CINNO ORGUNIT_CIN,
		OS.NAME OWNER_SITE_NAME,
		OS.SHORT_CODE OWNER_SHORT_CODE,
		OS.ADDRESS OWNER_SITE_ADDRESS,
		OS.CITY OWNER_SITE_CITY,
		OS.PINCODE OWNER_SITE_PINCODE,
		OS.PHONE1 OWNER_SITE_PHONE1,
		OS.PHONE2 OWNER_SITE_PHONE2,
		OS.PHONE3 OWNER_SITE_PHONE3,
		OS.EMAIL1 OWNER_SITE_EMAIL1,
		OS.EMAIL2 OWNER_SITE_EMAIL2,
		OS.GST_IDENTIFICATION_NO OWNER_GSTIN_NO,
		OS.GST_STATE_CODE OWNER_GST_STATE_CODE,
		OS.GST_STATE_NAME OWNER_GST_STATE_NAME,
		OS.WEBSITE OWNER_SITE_WEBSITE
	from
		PURORDMAIN M
	inner join ADMYEAR Y on
		(M.YCODE = Y.YCODE)
	inner join HRDEMP CR on
		(M.ECODE = CR.ECODE)
	inner join FINTRADEGRP TR on
		(M.FINTRADEGRP_CODE = TR.CODE)
	inner join ADMCURRENCY CUR on
		(M.ADMCURRENCY_CODE = CUR.CODE)
	inner join ADMOU OU on
		(M.ADMOU_CODE = OU.CODE)
	inner join SITE_DATA OS on
		(M.ADMSITE_CODE = OS.SITECODE)
	left outer join FINSL AG on
		(M.AGCODE = AG.SLCODE)
	left outer join FINSL TP on
		(M.TRPCODE = TP.SLCODE)
	left outer join HRDEMP AU on
		(AUTHORCODE = AU.ECODE)
	left outer join HRDEMP LA on
		(LAST_ACCESS_ECODE = LA.ECODE)
	left outer join HRDEMP MR on
		(MRCHNDSRCODE = MR.ECODE)
	left outer join PURTERMMAIN TRM on
		(PURTERMCODE = TRM.CODE)
	inner join
               (
		select
			S.SLNAME CUST_NAME,
			S.SLCODE,
			S.BADDR CUST_BILLING_ADDRESS,
			S.BCP CUST_BILLING_CONTACT_PERSON,
			S.BCTNAME CUST_BILLING_CITY,
			BCT.STNAME CUST_BILLING_STATE,
			BCT.DIST CUST_BILLING_DISTRICT,
			BCT.ZONE CUST_BILLING_ZONE,
			S.BEMAIL CUST_BILLING_EMAIL1,
			S.BEMAIL2 CUST_BILLING_EMAIL2,
			S.BFX1 CUST_BILLING_FAX,
			S.BFX2 CUST_BILLING_MOBILE,
			S.BPH1 CUST_BILLING_OFFICE_PHONE1,
			S.BPH2 CUST_BILLING_OFFICE_PHONE2,
			S.BPH3 CUST_BILLING_OFFICE_PHONE3,
			S.BPIN CUST_BILLING_PINCODE,
			S.BWEBSITE CUST_BILLING_WEBSITE,
			S.CP_GSTIN_NO CUST_GSTIN_NO,
			GTE.NAME CUST_GST_STATE_NAME,
			S.CP_GSTIN_STATE_CODE CUST_GST_STATE_CODE,
			S.CRDAYS CUST_CREDIT_DAYS,
			S.SLID CUST_IDENTITY_NO
		from
			FINSL S
		left outer join ADMCITY BCT on
			S.BCTNAME = BCT.CTNAME
		left outer join ADMGSTSTATE GTE
                          on
			S.CP_GSTIN_STATE_CODE = GTE.CODE) CUS
                  on
		(M.PCODE = CUS.SLCODE)
	where
		(ordcode in (
		select
							unnest(regexp_matches('@DocumentId@',
							'[^|~|]+',
							'g'))::bigint as col1)
			or coalesce (nullif ('@DocumentId@',
							''),
							'0')::text = 0::text)) H
inner join
       (/*Detail Part*/
	select
		'L2#DETAIL' LVL,
		1 SEQ,
		ORDCODE,
		ARTICLE_NAME,
		STYLE_NO,
		RATE,
		AMOUNT,
		TOTAL_QTY,
		SIZE1,
		SIZE2,
		SIZE3,
		SIZE4,
		SIZE5,
		SIZE6,
		SIZE7,
		SIZE8,
		SIZE9,
		SIZE10,
		SIZE11,
		SIZE12,
		SIZE13,
		SIZE14,
		SIZE15,
		SIZE16,
		SIZE17,
		SIZE18,
		SIZE19,
		SIZE20,
		null CHARGE_APPLICABLE_ON,
		null CHARGE_BASIS,
		null CHARGE_AMOUNT,
		null CHARGE_NAME,
		null OPERATION_LEVEL,
		null CHARGE_RATE,
		null DISPLAY_SEQUENCE,
		null HSN_ORDER_QUANTITY,
		null HSN_CODE,
		null HSN_SAC_ID,
		null HSN_DESCRIPTION,
		null HSN_UOM,
		null HSN_TAXABLE_AMOUNT,
		null HSN_CGST_RATE,
		null HSN_CGST_AMOUNT,
		null HSN_SGST_RATE,
		null HSN_SGST_AMOUNT,
		null HSN_IGST_RATE,
		null HSN_IGST_AMOUNT,
		null HSN_CESS_RATE,
		null HSN_CESS_AMOUNT,
		null SCHEDULE_DATE,
		null SCHEDULE_ORDER_QUANTITY
	from
		(
		select
			ORDCODE,
			ARTICLE_NAME,
			STYLE_NO,
			RATE,
			SUM (AMOUNT) AMOUNT,
			SUM (QTY) TOTAL_QTY,
			SUM (case
				when SEQ = 1 then QTY
				else 0
			end) SIZE1,
			SUM (case
				when SEQ = 2 then QTY
				else 0
			end) SIZE2,
			SUM (case
				when SEQ = 3 then QTY
				else 0
			end) SIZE3,
			SUM (case
				when SEQ = 4 then QTY
				else 0
			end) SIZE4,
			SUM (case
				when SEQ = 5 then QTY
				else 0
			end) SIZE5,
			SUM (case
				when SEQ = 6 then QTY
				else 0
			end) SIZE6,
			SUM (case
				when SEQ = 7 then QTY
				else 0
			end) SIZE7,
			SUM (case
				when SEQ = 8 then QTY
				else 0
			end) SIZE8,
			SUM (case
				when SEQ = 9 then QTY
				else 0
			end) SIZE9,
			SUM (case
				when SEQ = 10 then QTY
				else 0
			end) SIZE10,
			SUM (case
				when SEQ = 11 then QTY
				else 0
			end) SIZE11,
			SUM (case
				when SEQ = 12 then QTY
				else 0
			end) SIZE12,
			SUM (case
				when SEQ = 13 then QTY
				else 0
			end) SIZE13,
			SUM (case
				when SEQ = 14 then QTY
				else 0
			end) SIZE14,
			SUM (case
				when SEQ = 15 then QTY
				else 0
			end) SIZE15,
			SUM (case
				when SEQ = 16 then QTY
				else 0
			end) SIZE16,
			SUM (case
				when SEQ = 17 then QTY
				else 0
			end) SIZE17,
			SUM (case
				when SEQ = 18 then QTY
				else 0
			end) SIZE18,
			SUM (case
				when SEQ = 19 then QTY
				else 0
			end) SIZE19,
			SUM (case
				when SEQ = 20 then QTY
				else 0
			end) SIZE20
		from
			(
			select
				GINVIEW.FNC_UK UK,
				D.ORDCODE,
				I.ARTICLE_NAME,
				I.CATEGORY2 || '-' || I.CATEGORY5 STYLE_NO,
				TRIM (I.CATEGORY3) ITEM_SIZE,
				dense_rank ()
                                   over (partition by D.ORDCODE
			order by
				TRIM (I.CATEGORY3))
                                      SEQ,
				SUM (D.ORDQTY) QTY,
				SUM (D.NETAMT) AMOUNT,
				D.RATE
			from
				PURORDDET D
			inner join GINVIEW.LV_ITEM I
                                      on
				D.ICODE = I.CODE
			where
				(ordcode in (
				select
													unnest(regexp_matches('@DocumentId@',
													'[^|~|]+',
													'g'))::bigint as col1)
					or coalesce (nullif ('@DocumentId@',
													''),
													'0')::text = 0::text)
			group by
				D.ORDCODE,
				I.ARTICLE_NAME,
				I.CATEGORY2 || '-' || I.CATEGORY5,
				D.RATE,
				TRIM (I.CATEGORY3))
		group by
			ORDCODE,
			ARTICLE_NAME,
			STYLE_NO,
			RATE) D
union all
        /*Charge Part*/
	select
		'L3#CHARGE' LVL,
		2 SEQ,
		ORDCODE,
		null ARTICLE_NAME,
		null STYLE_NO,
		null RATE,
		null AMOUNT,
		null TOTAL_QTY,
		null SIZE1,
		null SIZE2,
		null SIZE3,
		null SIZE4,
		null SIZE5,
		null SIZE6,
		null SIZE7,
		null SIZE8,
		null SIZE9,
		null SIZE10,
		null SIZE11,
		null SIZE12,
		null SIZE13,
		null SIZE14,
		null SIZE15,
		null SIZE16,
		null SIZE17,
		null SIZE18,
		null SIZE19,
		null SIZE20,
		APPAMT CHARGE_APPLICABLE_ON,
		INITCAP (
                  case
			when A.BASIS = 'P' then 'PERCENTAGE'
			when A.BASIS = 'A' then 'AMOUNT'
		end)
                  CHARGE_BASIS,
		CHGAMT CHARGE_AMOUNT,
		CHGNAME CHARGE_NAME,
		INITCAP (
                  case
			when A.OPERATION_LEVEL = 'H' then 'HEADER'
			when A.OPERATION_LEVEL = 'L' then 'LINE'
		end)
                  OPERATION_LEVEL,
		A.RATE CHARGE_RATE,
		SEQ DISPLAY_SEQUENCE,
		null HSN_ORDER_QUANTITY,
		null HSN_CODE,
		null HSN_SAC_ID,
		null HSN_DESCRIPTION,
		null HSN_UOM,
		null HSN_TAXABLE_AMOUNT,
		null HSN_CGST_RATE,
		null HSN_CGST_AMOUNT,
		null HSN_SGST_RATE,
		null HSN_SGST_AMOUNT,
		null HSN_IGST_RATE,
		null HSN_IGST_AMOUNT,
		null HSN_CESS_RATE,
		null HSN_CESS_AMOUNT,
		null SCHEDULE_DATE,
		null ORDER_QUANTITY
	from
		PURORDCHG A
	inner join FINCHG B on
		(A.CHGCODE = B.CHGCODE)
	where
		(ordcode in (
		select
								unnest(regexp_matches('@DocumentId@',
								'[^|~|]+',
								'g'))::bigint as col1)
			or coalesce (nullif ('@DocumentId@',
								''),
								'0')::text = 0::text)
union all
          /*HSN Part*/
	select
		'L4#HSN' LVL,
		3 SEQ,
		ORDCODE,
		null ARTICLE_NAME,
		null STYLE_NO,
		null RATE,
		null AMOUNT,
		null TOTAL_QTY,
		null SIZE1,
		null SIZE2,
		null SIZE3,
		null SIZE4,
		null SIZE5,
		null SIZE6,
		null SIZE7,
		null SIZE8,
		null SIZE9,
		null SIZE10,
		null SIZE11,
		null SIZE12,
		null SIZE13,
		null SIZE14,
		null SIZE15,
		null SIZE16,
		null SIZE17,
		null SIZE18,
		null SIZE19,
		null SIZE20,
		null CHARGE_APPLICABLE_ON,
		null CHARGE_BASIS,
		null CHARGE_AMOUNT,
		null CHARGE_NAME,
		null OPERATION_LEVEL,
		null CHARGE_RATE,
		null DISPLAY_SEQUENCE,
		SUM (D.ORDQTY) HSN_ORDER_QUANTITY,
		H.GOVT_IDENTIFIER HSN_CODE,
		H.HSN_SAC_CODE HSN_SAC_ID,
		H.DESCRIPTION HSN_DESCRIPTION,
		I.UNITNAME HSN_UOM,
		SUM (TAXABLE_AMOUNT) HSN_TAXABLE_AMOUNT,
		CGST_RATE HSN_CGST_RATE,
		SUM (CGST_AMOUNT) HSN_CGST_AMOUNT,
		SGST_RATE HSN_SGST_RATE,
		SUM (SGST_AMOUNT) HSN_SGST_AMOUNT,
		IGST_RATE HSN_IGST_RATE,
		SUM (IGST_AMOUNT) HSN_IGST_AMOUNT,
		CESS_RATE HSN_CESS_RATE,
		SUM (CESS_AMOUNT) HSN_CESS_AMOUNT,
		null SCHEDULE_DATE,
		null ORDER_QUANTITY
	from
		(
		select
			*
		from
			PURORDDET
		where
			(ordcode in (
			select
											unnest(regexp_matches('@DocumentId@',
											'[^|~|]+',
											'g'))::bigint as col1)
				or coalesce (nullif ('@DocumentId@',
											''),
											'0')::text = 0::text)) D
	inner join INVITEM I on
		D.ICODE = I.ICODE
	inner join INVHSNSACMAIN H on
		I.INVHSNSACMAIN_CODE = H.CODE
	left outer join
                 (
		select
			PURORDDET_CODE,
			APPAMT TAXABLE_AMOUNT,
			SUM (
                              case
				when GST_COMPONENT = 'CGST'
					and ISREVERSE = 'N'
                                 then
                                    RATE
					else
                                    0
				end)
                              CGST_RATE,
			SUM (
                              case
				when GST_COMPONENT = 'CGST'
					and ISREVERSE = 'N'
                                 then
                                    CHGAMT
					else
                                    0
				end)
                              CGST_AMOUNT,
			SUM (
                              case
				when GST_COMPONENT = 'SGST'
					and ISREVERSE = 'N'
                                 then
                                    RATE
					else
                                    0
				end)
                              SGST_RATE,
			SUM (
                              case
				when GST_COMPONENT = 'SGST'
					and ISREVERSE = 'N'
                                 then
                                    CHGAMT
					else
                                    0
				end)
                              SGST_AMOUNT,
			SUM (
                              case
				when GST_COMPONENT = 'IGST'
					and ISREVERSE = 'N'
                                 then
                                    RATE
					else
                                    0
				end)
                              IGST_RATE,
			SUM (
                              case
				when GST_COMPONENT = 'IGST'
					and ISREVERSE = 'N'
                                 then
                                    CHGAMT
					else
                                    0
				end)
                              IGST_AMOUNT,
			SUM (
                              case
				when GST_COMPONENT = 'CESS'
					and ISREVERSE = 'N'
                                 then
                                    RATE
					else
                                    0
				end)
                              CESS_RATE,
			SUM (
                              case
				when GST_COMPONENT = 'CESS'
					and ISREVERSE = 'N'
                                 then
                                    CHGAMT
					else
                                    0
				end)
                              CESS_AMOUNT
		from
			PURORDCHG_ITEM
		where
			source = 'G'
			and (ordcode in (
			select
											unnest(regexp_matches('@DocumentId@',
											'[^|~|]+',
											'g'))::bigint as col1)
				or coalesce (nullif ('@DocumentId@',
											''),
											'0')::text = 0::text)
		group by
			PURORDDET_CODE,
			APPAMT) TAX
                    on
		D.CODE = TAX.PURORDDET_CODE
	where
		(ordcode in (
		select
								unnest(regexp_matches('@DocumentId@',
								'[^|~|]+',
								'g'))::bigint as col1)
			or coalesce (nullif ('@DocumentId@',
								''),
								'0')::text = 0::text)
	group by
		D.ORDCODE,
		H.GOVT_IDENTIFIER,
		H.HSN_SAC_CODE,
		H.DESCRIPTION,
		I.UNITNAME,
		CGST_RATE,
		SGST_RATE,
		IGST_RATE,
		CESS_RATE
union all
        /*Schedule Part*/
	select
		'L5#SCHEDULE' LVL,
		4 SEQ,
		ORDCODE,
		null ARTICLE_NAME,
		null STYLE_NO,
		null RATE,
		null AMOUNT,
		null TOTAL_QTY,
		null SIZE1,
		null SIZE2,
		null SIZE3,
		null SIZE4,
		null SIZE5,
		null SIZE6,
		null SIZE7,
		null SIZE8,
		null SIZE9,
		null SIZE10,
		null SIZE11,
		null SIZE12,
		null SIZE13,
		null SIZE14,
		null SIZE15,
		null SIZE16,
		null SIZE17,
		null SIZE18,
		null SIZE19,
		null SIZE20,
		null CHARGE_APPLICABLE_ON,
		null CHARGE_BASIS,
		null CHARGE_AMOUNT,
		null CHARGE_NAME,
		null OPERATION_LEVEL,
		null CHARGE_RATE,
		null DISPLAY_SEQUENCE,
		null HSN_ORDER_QUANTITY,
		null HSN_CODE,
		null HSN_SAC_ID,
		null HSN_DESCRIPTION,
		null HSN_UOM,
		null HSN_TAXABLE_AMOUNT,
		null HSN_CGST_RATE,
		null HSN_CGST_AMOUNT,
		null HSN_SGST_RATE,
		null HSN_SGST_AMOUNT,
		null HSN_IGST_RATE,
		null HSN_IGST_AMOUNT,
		null HSN_CESS_RATE,
		null HSN_CESS_AMOUNT,
		SCHEDULEDT SCHEDULE_DATE,
		ORDQTY ORDER_QUANTITY
	from
		PURORDSCHEDULE
	where
		(ordcode in (
		select
								unnest(regexp_matches('@DocumentId@',
								'[^|~|]+',
								'g'))::bigint as col1)
			or coalesce (nullif ('@DocumentId@',
								''),
								'0')::text = 0::text)) D
          on
	(H.ORDCODE = D.ORDCODE)