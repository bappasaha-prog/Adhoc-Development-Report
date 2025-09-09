/*><><>< || Custom Development || Object : CQ_PURORD || Ticket Id : 404272 || Developer : Dipankar || ><><><*/
with site_data
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
	st.EMAIL1 EMAIL1,
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
                   Shipping_Company_Name,
	case
		when ISBILLINGSHIPPINGSAME = 'Y' then ST.ADDRESS
		else ST.SHIP_ADDRESS
	end
                   Shipping_Address,
	case
		when ISBILLINGSHIPPINGSAME = 'Y' then ST.CTNAME
		else ST.SHIP_CTNAME
	end
                   Shipping_CITY,
	case
		when ISBILLINGSHIPPINGSAME = 'Y' then ST.PIN
		else ST.SHIP_PIN
	end
                   Shipping_Pincode,
	case
		when ISBILLINGSHIPPINGSAME = 'Y' then ST.OPH1
		else ST.SHIP_OPH1
	end
                   Shipping_Phone1,
	case
		when ISBILLINGSHIPPINGSAME = 'Y' then ST.OPH2
		else ST.SHIP_OPH2
	end
                   Shipping_Phone2,
	case
		when ISBILLINGSHIPPINGSAME = 'Y' then ST.OPH3
		else ST.SHIP_OPH3
	end
                   Shipping_Phone3,
	case
		when ISBILLINGSHIPPINGSAME = 'Y' then ST.EMAIL1
		else ST.SHIP_EMAIL1
	end
                   Shipping_Email1,
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
                   Shipping_GST_Identification_No,
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
                   Shipping_GST_State_Code,
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
                   Shipping_GST_State_Name,
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
	GINVIEW.FNC_UK() UK,
	h.ORDCODE L1_ORDCODE,
	h.ORDER_DATE L1_ORDER_DATE,
	h.PCODE L1_PCODE,
	h.DOCUMENT_NO L1_DOCUMENT_NO,
	h.AGCODE L1_AGCODE,
	h.AGENT_NAME L1_AGENT_NAME,
	h.AGENT_RATE L1_AGENT_RATE,
	h.TRPCODE L1_TRPCODE,
	h.TRANSPORTER_NAME L1_TRANSPORTER_NAME,
	h.INV_STATUS L1_INV_STATUS,
	h.AUTHORIZED_BY L1_AUTHORIZED_BY,
	h.REMARKS L1_REMARKS,
	h.CREATED_BY L1_CREATED_BY,
	h.CREATED_ON L1_CREATED_ON,
	h.VALID_FROM L1_VALID_FROM,
	h.VALID_TILL L1_VALID_TILL,
	h.LAST_ACCESSED_ON L1_LAST_ACCESSED_ON,
	h.LAST_ACCESSED_BY L1_LAST_ACCESSED_BY,
	h.TERMS L1_TERMS,
	h.TYPE L1_TYPE,
	h.ORDER_NO L1_ORDER_NO,
	h.ADMOU_CODE L1_ADMOU_CODE,
	h.MERCHANDISER L1_MERCHANDISER,
	h.TRADE_GROUP_NAME L1_TRADE_GROUP_NAME,
	h.INV_GROSS_AMOUNT L1_INV_GROSS_AMOUNT,
	h.INV_CHARGE_AMOUNT L1_INV_CHARGE_AMOUNT,
	h.NET_AMOUNT L1_NET_AMOUNT,
	h.CURRENCY L1_CURRENCY,
	h.CURRENCY_DECIMAL_SYMBOL L1_CURRENCY_DECIMAL_SYMBOL,
	h.CURRENCY_SYMBOL L1_CURRENCY_SYMBOL,
	h.CURRENCY_EXCHANGE_RATE L1_CURRENCY_EXCHANGE_RATE,
	h.ADMSITE_CODE L1_ADMSITE_CODE,
	h.SHIPMENT_TRACKING_APPLICABLE L1_SHIPMENT_TRACK_APPLICABLE,
	h.PURCHASE_TERM_NAME L1_PURCHASE_TERM_NAME,
	h.PURORDMAIN_UDFSTRIN01 L1_PURORDMAIN_UDFSTRIN01,
	h.PURORDMAIN_UDFSTRIN02 L1_PURORDMAIN_UDFSTRIN02,
	h.PURORDMAIN_UDFSTRIN03 L1_PURORDMAIN_UDFSTRIN03,
	h.PURORDMAIN_UDFSTRIN04 L1_PURORDMAIN_UDFSTRIN04,
	h.PURORDMAIN_UDFSTRIN05 L1_PURORDMAIN_UDFSTRIN05,
	h.PURORDMAIN_UDFSTRIN06 L1_PURORDMAIN_UDFSTRIN06,
	h.PURORDMAIN_UDFSTRIN07 L1_PURORDMAIN_UDFSTRIN07,
	h.PURORDMAIN_UDFSTRIN08 L1_PURORDMAIN_UDFSTRIN08,
	h.PURORDMAIN_UDFSTRIN09 L1_PURORDMAIN_UDFSTRIN09,
	h.PURORDMAIN_UDFSTRIN010 L1_PURORDMAIN_UDFSTRIN010,
	h.PURORDMAIN_UDFNUM01 L1_PURORDMAIN_UDFNUM01,
	h.PURORDMAIN_UDFNUM02 L1_PURORDMAIN_UDFNUM02,
	h.PURORDMAIN_UDFNUM03 L1_PURORDMAIN_UDFNUM03,
	h.PURORDMAIN_UDFNUM04 L1_PURORDMAIN_UDFNUM04,
	h.PURORDMAIN_UDFNUM05 L1_PURORDMAIN_UDFNUM05,
	h.PURORDMAIN_UDFDATE01 L1_PURORDMAIN_UDFDATE01,
	h.PURORDMAIN_UDFDATE02 L1_PURORDMAIN_UDFDATE02,
	h.PURORDMAIN_UDFDATE03 L1_PURORDMAIN_UDFDATE03,
	h.PURORDMAIN_UDFDATE04 L1_PURORDMAIN_UDFDATE04,
	h.PURORDMAIN_UDFDATE05 L1_PURORDMAIN_UDFDATE05,
	h.AUTHORIZED_ON L1_AUTHORIZED_ON,
	h.CUST_NAME L1_CUST_NAME,
	h.CUST_BILLING_ADDRESS L1_CUST_BILLING_ADDRESS,
	h.CUST_BILLING_CONTACT_PERSON L1_CUST_BILLING_CONTACT_PERSON,
	h.CUST_BILLING_CITY L1_CUST_BILLING_CITY,
	h.CUST_BILLING_STATE L1_CUST_BILLING_STATE,
	h.CUST_BILLING_DISTRICT L1_CUST_BILLING_DISTRICT,
	h.CUST_BILLING_ZONE L1_CUST_BILLING_ZONE,
	h.CUST_BILLING_EMAIL1 L1_CUST_BILLING_EMAIL1,
	h.CUST_BILLING_EMAIL2 L1_CUST_BILLING_EMAIL2,
	h.CUST_BILLING_FAX L1_CUST_BILLING_FAX,
	h.CUST_BILLING_MOBILE L1_CUST_BILLING_MOBILE,
	h.CUST_BILLING_OFFICE_PHONE1 L1_CUST_BILLING_OFFICE_PHONE1,
	h.CUST_BILLING_OFFICE_PHONE2 L1_CUST_BILLING_OFFICE_PHONE2,
	h.CUST_BILLING_OFFICE_PHONE3 L1_CUST_BILLING_OFFICE_PHONE3,
	h.CUST_BILLING_PINCODE L1_CUST_BILLING_PINCODE,
	h.CUST_BILLING_WEBSITE L1_CUST_BILLING_WEBSITE,
	h.CUST_GSTIN_NO L1_CUST_GSTIN_NO,
	h.CUST_GST_STATE_NAME L1_CUST_GST_STATE_NAME,
	h.CUST_GST_STATE_CODE L1_CUST_GST_STATE_CODE,
	h.CUST_CREDIT_DAYS L1_CUST_CREDIT_DAYS,
	h.CUST_IDENTITY_NO L1_CUST_IDENTITY_NO,
	h.ORGUNIT_NAME L1_ORGUNIT_NAME,
	h.ORGUNIT_WEBSITE L1_ORGUNIT_WEBSITE,
	h.ORGUNIT_CIN L1_ORGUNIT_CIN,
	h.OWNER_SITE_NAME L1_OWNER_SITE_NAME,
	h.OWNER_SHORT_CODE L1_OWNER_SHORT_CODE,
	h.OWNER_SITE_ADDRESS L1_OWNER_SITE_ADDRESS,
	h.OWNER_SITE_CITY L1_OWNER_SITE_CITY,
	h.OWNER_SITE_PINCODE L1_OWNER_SITE_PINCODE,
	h.OWNER_SITE_PHONE1 L1_OWNER_SITE_PHONE1,
	h.OWNER_SITE_PHONE2 L1_OWNER_SITE_PHONE2,
	h.OWNER_SITE_PHONE3 L1_OWNER_SITE_PHONE3,
	h.OWNER_SITE_EMAIL1 L1_OWNER_SITE_EMAIL1,
	h.OWNER_SITE_EMAIL2 L1_OWNER_SITE_EMAIL2,
	h.OWNER_GSTIN_NO L1_OWNER_GSTIN_NO,
	h.OWNER_GST_STATE_CODE L1_OWNER_GST_STATE_CODE,
	h.OWNER_GST_STATE_NAME L1_OWNER_GST_STATE_NAME,
	h.OWNER_SITE_WEBSITE L1_OWNER_SITE_WEBSITE,
	d.LVL,
	d.SEQ,
	D.SLNO L2_SLNO,
	D.ARTICLE_NAME L2_ARTICLE_NAME,
	D.IMAGE_NAME L2_IMAGE_NAME,
	D.CATEGORY2 L2_CATEGORY2,
	D.ITEM_HSN L2_ITEM_HSN,
	D.RATE L2_RATE,
	D.MRP L2_MRP,
	D.MRP_VALUE L2_MRP_VALUE,
	D.ITEM_GROSS_AMOUNT L2_ITEM_GROSS_AMOUNT,
	D.TOTAL_QTY L2_TOTAL_QTY,
	D.DISCOUNT L2_DISCOUNT,
	D.TAXABLE_AMOUNT L2_TAXABLE_AMOUNT,
	D.ITEM_NET_AMOUNT L2_ITEM_NET_AMOUNT,
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
	d.CHARGE_APPLICABLE_ON L3_CHARGE_APPLICABLE_ON,
	d.CHARGE_BASIS L3_CHARGE_BASIS,
	d.CHARGE_AMOUNT L3_CHARGE_AMOUNT,
	d.CHARGE_NAME L3_CHARGE_NAME,
	d.OPERATION_LEVEL L3_OPERATION_LEVEL,
	d.CHARGE_RATE L3_CHARGE_RATE,
	d.DISPLAY_SEQUENCE L3_DISPLAY_SEQUENCE,
	d.HSN_ORDER_QUANTITY L4_ORDER_QUANTITY,
	d.HSN_CODE L4_HSN_CODE,
	d.HSN_SAC_ID L4_HSN_SAC_ID,
	d.HSN_DESCRIPTION L4_HSN_DESCRIPTION,
	d.HSN_UOM L4_HSN_UOM,
	d.HSN_TAXABLE_AMOUNT L4_TAXABLE_AMOUNT,
	d.HSN_CGST_RATE L4_CGST_RATE,
	d.HSN_CGST_AMOUNT L4_CGST_AMOUNT,
	d.HSN_SGST_RATE L4_SGST_RATE,
	d.HSN_SGST_AMOUNT L4_SGST_AMOUNT,
	d.HSN_IGST_RATE L4_IGST_RATE,
	d.HSN_IGST_AMOUNT L4_IGST_AMOUNT,
	d.HSN_CESS_RATE L4_CESS_RATE,
	d.HSN_CESS_AMOUNT L4_CESS_AMOUNT,
	d.SCHEDULE_DATE L5_SCHEDULE_DATE,
	d.SCHEDULE_ORDER_QUANTITY L5_SCHEDULE_ORDER_QUANTITY
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
		ou.NAME ORGUNIT_NAME,
		ou.WEBSITE ORGUNIT_WEBSITE,
		ou.CINNO ORGUNIT_CIN,
		os.NAME OWNER_SITE_NAME,
		os.SHORT_CODE OWNER_SHORT_CODE,
		os.ADDRESS OWNER_SITE_ADDRESS,
		os.CITY OWNER_SITE_CITY,
		os.PINCODE OWNER_SITE_PINCODE,
		os.PHONE1 OWNER_SITE_PHONE1,
		os.PHONE2 OWNER_SITE_PHONE2,
		os.PHONE3 OWNER_SITE_PHONE3,
		os.EMAIL1 OWNER_SITE_EMAIL1,
		os.EMAIL2 OWNER_SITE_EMAIL2,
		OS.GST_IDENTIFICATION_NO OWNER_GSTIN_NO,
		OS.GST_STATE_CODE OWNER_GST_STATE_CODE,
		OS.GST_STATE_NAME OWNER_GST_STATE_NAME,
		os.website OWNER_SITE_WEBSITE
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
	inner join site_data os on
		(M.admsite_code = os.sitecode)
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
			S.SLNAME cust_NAME,
			S.SLCODE,
			S.BADDR cust_BILLING_ADDRESS,
			S.BCP cust_BILLING_CONTACT_PERSON,
			S.BCTNAME cust_BILLING_CITY,
			BCT.STNAME cust_BILLING_STATE,
			BCT.DIST cust_BILLING_DISTRICT,
			BCT.ZONE cust_BILLING_ZONE,
			S.BEMAIL cust_BILLING_EMAIL1,
			S.BEMAIL2 cust_BILLING_EMAIL2,
			S.BFX1 cust_BILLING_FAX,
			S.BFX2 cust_BILLING_MOBILE,
			S.BPH1 cust_BILLING_OFFICE_PHONE1,
			S.BPH2 cust_BILLING_OFFICE_PHONE2,
			S.BPH3 cust_BILLING_OFFICE_PHONE3,
			S.BPIN cust_BILLING_PINCODE,
			S.BWEBSITE cust_BILLING_WEBSITE,
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
		SLNO,
		ARTICLE_NAME,
		IMAGE_NAME,
		category2,
		ITEM_HSN,
		RATE,
		MRP,
		MRP_VALUE,
		ITEM_GROSS_AMOUNT,
		TOTAL_QTY,
		DISCOUNT,
		TAXABLE_AMOUNT,
		ITEM_NET_AMOUNT,
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
			row_number () over () SLNO,
			ORDCODE,
			ARTICLE_NAME,
			IMAGE_NAME,
			category2,
			HSN_CODE ITEM_HSN,
			RATE,
			MRP,
			SUM (QTY) * MRP MRP_VALUE,
			SUM (ITEM_GROSS_AMOUNT) ITEM_GROSS_AMOUNT,
			SUM (QTY) TOTAL_QTY,
			SUM (DISCOUNT) DISCOUNT,
			SUM (TAXABLE_AMOUNT) TAXABLE_AMOUNT,
			SUM (ITEM_NET_AMOUNT) ITEM_NET_AMOUNT,
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
			end) SIZE15
		from
			(
			select
				D.ORDCODE,
				I.ARTICLE_NAME,
				I.IMAGE_NAME,
				i.category2,
				I.HSN_CODE,
				dense_rank ()
                   over (
                      partition by D.ORDCODE
			order by
				TRIM (CONCAT (I.INVITEM_UDFSTRING07,
				I.CATEGORY3)))
                      SEQ,
				SUM (coalesce (D.ORDQTY,
				0)) QTY,
				case
					when SUM (coalesce (D.NETAMT,
					0)) = 0
                      then
                         SUM (D.ORDQTY * D.RATE)
					else
                         SUM (coalesce (D.NETAMT,
					0))
				end
                      ITEM_GROSS_AMOUNT,
				D.RATE,
				I.MRP,
				SUM (D.DISCOUNT) DISCOUNT,
				SUM (TAX.TAXABLE_AMOUNT) TAXABLE_AMOUNT,
				 SUM (coalesce (D.NETAMT,
					0))
                      ITEM_NET_AMOUNT
			from
				purorddet D
			inner join GINVIEW.LV_ITEM I on
				D.ICODE = I.CODE
			left outer join
                   (
				select
					PURORDDET_CODE,
					APPAMT TAXABLE_AMOUNT
				from
					purordchg_item
				where
					ISTAX = 'Y'
					and (ordcode in (
					select
								unnest(regexp_matches('@DocumentId@',
								'[^|~|]+',
								'g'))::bigint as col1)
						or coalesce (nullif ('@DocumentId@',
								''),
								'0')::text = 0::text)) TAX
						                      on
				(D.CODE = TAX.PURORDDET_CODE)
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
				I.IMAGE_NAME,
				i.category2,
				I.HSN_CODE,
				D.RATE,
				I.MRP,
				TRIM (CONCAT (I.INVITEM_UDFSTRING07,
				I.CATEGORY3)))
		group by
			ORDCODE,
			ARTICLE_NAME,
			IMAGE_NAME,
			category2,
			HSN_CODE,
			RATE,
			MRP
		order by
			ARTICLE_NAME) D
union all
        /*Charge Part*/
	select
		'L3#CHARGE' LVL,
		2 SEQ,
		ORDCODE,
		null SLNO,
		null ARTICLE_NAME,
		null IMAGE_NAME,
		null category2,
		null ITEM_HSN,
		null RATE,
		null MRP,
		null MRP_VALUE,
		null ITEM_GROSS_AMOUNT,
		null TOTAL_QTY,
		null DISCOUNT,
		null TAXABLE_AMOUNT,
		null ITEM_NET_AMOUNT,
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
		null::numeric HSN_ORDER_QUANTITY,
		null HSN_CODE,
		null HSN_SAC_ID,
		null HSN_DESCRIPTION,
		null HSN_UOM,
		null::numeric HSN_TAXABLE_AMOUNT,
		null::numeric HSN_CGST_RATE,
		null::numeric HSN_CGST_AMOUNT,
		null::numeric HSN_SGST_RATE,
		null::numeric HSN_SGST_AMOUNT,
		null::numeric HSN_IGST_RATE,
		null::numeric HSN_IGST_AMOUNT,
		null::numeric HSN_CESS_RATE,
		null::numeric HSN_CESS_AMOUNT,
		null::date SCHEDULE_DATE,
		null::numeric ORDER_QUANTITY
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
		null SLNO,
		null ARTICLE_NAME,
		null IMAGE_NAME,
		null category2,
		null ITEM_HSN,
		null RATE,
		null MRP,
		null MRP_VALUE,
		null ITEM_GROSS_AMOUNT,
		null TOTAL_QTY,
		null DISCOUNT,
		null TAXABLE_AMOUNT,
		null ITEM_NET_AMOUNT,
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
		SUM (SGST_amount) HSN_SGST_AMOUNT,
		IGST_RATE HSN_IGST_RATE,
		SUM (IGST_amount) HSN_IGST_AMOUNT,
		CESS_RATE HSN_CESS_RATE,
		SUM (CESS_amount) HSN_CESS_AMOUNT,
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
                              CESS_Rate,
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
		--Start Change 106725
		H.GOVT_IDENTIFIER,
		H.HSN_SAC_CODE,
		--End Change
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
		null SLNO,
		null ARTICLE_NAME,
		null IMAGE_NAME,
		null category2,
		null ITEM_HSN,
		null RATE,
		null MRP,
		null MRP_VALUE,
		null ITEM_GROSS_AMOUNT,
		null TOTAL_QTY,
		null DISCOUNT,
		null TAXABLE_AMOUNT,
		null ITEM_NET_AMOUNT,
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