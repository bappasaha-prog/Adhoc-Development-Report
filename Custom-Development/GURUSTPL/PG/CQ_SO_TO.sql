/*><><>< || Custom Development || Object : CQ_SO_TO || Ticket Id : 390416 || Developer : Dipankar || ><><><*/
/*><><>< || Rectification      || Object : CQ_SO_TO || Ticket Id : 414477 || Developer : Ujjal    || ><><><*/
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
	/*Start Bug :63055*/
	ST.WEBSITE
                   /*End Bug :63055*/
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
	h.DOCUMENT_DATE L1_DOCUMENT_DATE,
	h.AGCODE L1_AGCODE,
	h.AGENT_NAME L1_AGENT_NAME,
	h.AGENT_RATE L1_AGENT_RATE,
	h.TRPCODE L1_TRPCODE,
	h.TRANSPORTER_NAME L1_TRANSPORTER_NAME,
	h.DUE_DATE L1_DUE_DATE,
	h.STATUS L1_STATUS,
	h.AUTHORIZED_BY L1_AUTHORIZED_BY,
	h.REMARKS L1_REMARKS,
	h.CREATED_BY L1_CREATED_BY,
	h.CREATED_ON L1_CREATED_ON,
	h.ORDER_NO L1_ORDER_NO,
	h.ADMOU_CODE L1_ADMOU_CODE,
	h.ADMSITE_CODE L1_ADMSITE_CODE,
	h.PRICE_TYPE L1_PRICE_TYPE,
	h.PRICE_LIST_NAME L1_PRICE_LIST_NAME,
	h.DISCOUNT_FACTOR L1_DISCOUNT_FACTOR,
	h.PRICE_ROUND_OFF L1_PRICE_ROUND_OFF,
	h.PRICE_ROUND_OFF_LIMIT L1_PRICE_ROUND_OFF_LIMIT,
	h.ADMSITE_CODE_OWNER L1_ADMSITE_CODE_OWNER,
	h.PRICE_INCLUSION_OF_TAX L1_PRICE_INCLUSION_OF_TAX,
	h.PRICE_MODE L1_PRICE_MODE,
	h.PRICE_BASIS L1_PRICE_BASIS,
	h.SALES_TERM L1_SALES_TERM,
	h.INV_GROSS_AMOUNT L1_INV_GROSS_AMOUNT,
	h.INV_CHARGE_AMOUNT L1_INV_CHARGE_AMOUNT,
	h.INV_NET_AMOUNT L1_INV_NET_AMOUNT,
	h.TRADE_GROUP_NAME L1_TRADE_GROUP_NAME,
	h.STORE_POS_ORDER_NO L1_STORE_POS_ORDER_NO,
	h.STORE_POS_ORDER_DATE L1_STORE_POS_ORDER_DATE,
	h.STORE_POS_ORDER_REMARKS L1_STORE_POS_ORDER_REMARKS,
	h.TAX_BASED_ON L1_TAX_BASED_ON,
	h.AUTHORIZED_ON L1_AUTHORIZED_ON,
	h.LAST_ACCESSED_BY L1_LAST_ACCESSED_BY,
	h.LAST_ACCESSED_ON L1_LAST_ACCESSED_ON,
	h.ON_HOLD L1_ON_HOLD,
	h.HELD_BY L1_HELD_BY,
	h.HELD_ON L1_HELD_ON,
	h.AGAINST_RESERVATION L1_AGAINST_RESERVATION,
	h.CHALLAN_NO L1_CHALLAN_NO,
	h.SALORDMAIN_UDFSTRING01 L1_SALORDMAIN_UDFSTRING01,
	h.SALORDMAIN_UDFSTRING02 L1_SALORDMAIN_UDFSTRING02,
	h.SALORDMAIN_UDFSTRING03 L1_SALORDMAIN_UDFSTRING03,
	h.SALORDMAIN_UDFSTRING04 L1_SALORDMAIN_UDFSTRING04,
	h.SALORDMAIN_UDFSTRING05 L1_SALORDMAIN_UDFSTRING05,
	h.SALORDMAIN_UDFSTRING06 L1_SALORDMAIN_UDFSTRING06,
	h.SALORDMAIN_UDFSTRING07 L1_SALORDMAIN_UDFSTRING07,
	h.SALORDMAIN_UDFSTRING08 L1_SALORDMAIN_UDFSTRING08,
	h.SALORDMAIN_UDFSTRING09 L1_SALORDMAIN_UDFSTRING09,
	h.SALORDMAIN_UDFSTRING10 L1_SALORDMAIN_UDFSTRING10,
	h.SALORDMAIN_UDFNUM01 L1_SALORDMAIN_UDFNUM01,
	h.SALORDMAIN_UDFNUM02 L1_SALORDMAIN_UDFNUM02,
	h.SALORDMAIN_UDFNUM03 L1_SALORDMAIN_UDFNUM03,
	h.SALORDMAIN_UDFNUM04 L1_SALORDMAIN_UDFNUM04,
	h.SALORDMAIN_UDFNUM05 L1_SALORDMAIN_UDFNUM05,
	h.SALORDMAIN_UDFDATE01 L1_SALORDMAIN_UDFDATE01,
	h.SALORDMAIN_UDFDATE02 L1_SALORDMAIN_UDFDATE02,
	h.SALORDMAIN_UDFDATE03 L1_SALORDMAIN_UDFDATE03,
	h.SALORDMAIN_UDFDATE04 L1_SALORDMAIN_UDFDATE04,
	h.SALORDMAIN_UDFDATE05 L1_SALORDMAIN_UDFDATE05,
	h.SALETYPE L1_SALETYPE,
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
	/*Start Bug :63055*/
	h.OWNER_SITE_WEBSITE L1_OWNER_SITE_WEBSITE,
	/*End Bug :63055*/
	h.OWNER_GST_IDENTIFICATION_NO L1_OWNER_GST_IDENTIFICATION_NO,
	h.OWNER_GST_STATE_CODE L1_OWNER_GST_STATE_CODE,
	h.OWNER_GST_STATE_NAME L1_OWNER_GST_STATE_NAME,
	h.REFSITE_NAME L1_REFSITE_NAME,
	h.REFSITE_SHORT_CODE L1_REFSITE_SHORT_CODE,
	h.REFSITE_ADDRESS L1_REFSITE_ADDRESS,
	h.REFSITE_CITY L1_REFSITE_CITY,
	h.REFSITE_PINCODE L1_REFSITE_PINCODE,
	h.REFSITE_PHONE1 L1_REFSITE_PHONE1,
	h.REFSITE_PHONE2 L1_REFSITE_PHONE2,
	h.REFSITE_PHONE3 L1_REFSITE_PHONE3,
	h.REFSITE_EMAIL L1_REFSITE_EMAIL,
	h.REFSITE_GSTIN_NO L1_REFSITE_GSTIN_NO,
	h.REFSITE_GST_STATE_CODE L1_REFSITE_GST_STATE_CODE,
	h.REFSITE_GST_STATE_NAME L1_REFSITE_GST_STATE_NAME,
	h.REFSITE_SHIPPING_COMPANY_NAME L1_REFSITE_SHIP_COMPANY_NAME,
	h.REFSITE_SHIPPING_ADDRESS L1_REFSITE_SHIP_ADDRESS,
	h.REFSITE_SHIPPING_CITY L1_REFSITE_SHIP_CITY,
	h.REFSITE_SHIPPING_PINCODE L1_REFSITE_SHIP_PINCODE,
	h.REFSITE_SHIPPING_PHONE1 L1_REFSITE_SHIP_PHONE1,
	h.REFSITE_SHIPPING_PHONE2 L1_REFSITE_SHIP_PHONE2,
	h.REFSITE_SHIPPING_PHONE3 L1_REFSITE_SHIP_PHONE3,
	h.REFSITE_SHIPPING_EMAIL1 L1_REFSITE_SHIP_EMAIL1,
	h.REFSITE_SHIP_GSTIN_NO L1_REFSITE_SHIP_GSTIN_NO,
	h.REFSITE_SHIP_GST_STATE_CODE L1_REFSITE_SHIP_GST_STATE_CODE,
	h.REFSITE_SHIP_GST_STATE_NAME L1_REFSITE_SHIP_GST_STATE_NAME,
	D.LVL,
	D.SEQ,
	D.SLNO L2_SLNO,
	D.ARTICLE_NAME L2_ARTICLE_NAME,
	D.IMAGE_NAME L2_IMAGE_NAME,
	D.CATEGORY2 L2_CATEGORY2,
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
	D.SALES_CHARGE_NAME L3_SALES_CHARGE_NAME,
	D.DISPLAY_SEQUENCE L3_DISPLAY_SEQUENCE,
	D.CHARGE_RATE L3_CHARGE_RATE,
	D.CHARGE_AMOUNT L3_CHARGE_AMOUNT,
	D.CHARGE_BASIS L3_CHARGE_BASIS,
	D.CHARGE_APPLICABLE_ON L3_CHARGE_APPLICABLE_ON,
	D.OPERATION_LEVEL L3_OPERATION_LEVEL,
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
	D.HSN_CESS_AMOUNT L4_CESS_AMOUNT
from
	(/*Header Part*/
	select
		M.ORDCODE ORDCODE,
		M.ORDDT ORDER_DATE,
		M.PCODE PCODE,
		M.DOCNO DOCUMENT_NO,
		M.DOCDT DOCUMENT_DATE,
		M.AGCODE AGCODE,
		AG.SLNAME AGENT_NAME,
		M.AGRATE AGENT_RATE,
		M.TRPCODE TRPCODE,
		TR.SLNAME TRANSPORTER_NAME,
		M.DUEDT DUE_DATE,
		INITCAP (
                  case
			when coalesce (M.STAT,
			'T') = 'T'
                     then
                        'TOTAL PROCESSED'
			when coalesce (M.STAT,
			'T') = 'P'
                     then
                        'PARTIAL PROCESSED'
			when coalesce (M.STAT,
			'T') = 'N'
                     then
                        'NEW'
		end)
                  STATUS,
		AU.FNAME || ' [' || AU.ENO || ']' AUTHORIZED_BY,
		M.REM REMARKS,
		CR.FNAME || ' [' || CR.ENO || ']' CREATED_BY,
		M.TIME CREATED_ON,
		M.SCHEME_DOCNO ORDER_NO,
		M.ADMOU_CODE ADMOU_CODE,
		M.ADMSITE_CODE ADMSITE_CODE,
		INITCAP (
                  case
			when coalesce (M.PRICETYPE,
			'M') = 'M'
                     then
                        'RSP'
			when coalesce (M.PRICETYPE,
			'M') = 'L'
                     then
                        'MRP'
			when coalesce (M.PRICETYPE,
			'M') = 'W'
                     then
                        'WSP'
			when coalesce (M.PRICETYPE,
			'M') = 'C'
                     then
                        'EFFECTIVE RATE (LAST LANDING COST)'
			when coalesce (M.PRICETYPE,
			'M') = 'R'
                     then
                        'STANDARD RATE'
			when coalesce (M.PRICETYPE,
			'M') = 'B'
                     then
                        'BASIC RATE (LAST PURCHASE)'
		end)
                  PRICE_TYPE,
		PR.PRICELISTNAME PRICE_LIST_NAME,
		M.DISCOUNT_FACTOR DISCOUNT_FACTOR,
		M.PRICE_ROUNDOFF PRICE_ROUND_OFF,
		INITCAP (
                  case
			when coalesce (M.ROUNDOFF_LIMIT,
			'N') = 'N' then 'NO'
			when coalesce (M.ROUNDOFF_LIMIT,
			'N') = 'Y' then 'YES'
		end)
                  PRICE_ROUND_OFF_LIMIT,
		M.ADMSITE_CODE_OWNER ADMSITE_CODE_OWNER,
		INITCAP (
                  case
			when coalesce (M.INCL_VAT_IN_DIST,
			'N') = 'N' then 'NO'
			when coalesce (M.INCL_VAT_IN_DIST,
			'N') = 'Y' then 'YES'
		end)
                  PRICE_INCLUSION_OF_TAX,
		INITCAP (
                  case
			when coalesce (M.DISCOUNT_MODE,
			'U') = 'U'
                     then
                        'MARKUP'
			when coalesce (M.DISCOUNT_MODE,
			'U') = 'D'
                     then
                        'MARKDOWN'
		end)
                  PRICE_MODE,
		INITCAP (
                  case
			when coalesce (M.DISCOUNT_BASIS,
			'N') = 'B'
                     then
                        'ON BASE PRICE'
			when coalesce (M.DISCOUNT_BASIS,
			'N') = 'N'
                     then
                        'ON NET PRICE'
		end)
                  PRICE_BASIS,
		ST.SALTERMNAME SALES_TERM,
		M.GRSAMT INV_GROSS_AMOUNT,
		M.CHGAMT INV_CHARGE_AMOUNT,
		M.NETAMT INV_NET_AMOUNT,
		TD.NAME TRADE_GROUP_NAME,
		POS.ORDERNO STORE_POS_ORDER_NO,
		POS.ORDERDATE STORE_POS_ORDER_DATE,
		M.POS_REMARKS STORE_POS_ORDER_REMARKS,
		INITCAP (
                  case
			when coalesce (M.CMPTAX_CODE_BASIS,
			'D') = 'S'
                     then
                        'SOURCE'
			when coalesce (M.CMPTAX_CODE_BASIS,
			'D') = 'D'
                     then
                        'DESTINATION'
		end)
                  TAX_BASED_ON,
		M.AUTHORIZATIONTIME AUTHORIZED_ON,
		LA.FNAME || ' [' || LA.ENO || ']' LAST_ACCESSED_BY,
		M.LAST_ACCESS_TIME LAST_ACCESSED_ON,
		INITCAP (
                  case
			when M.ISHOLD = 'Y' then 'YES'
			when M.ISHOLD = 'N' then 'NO'
		end)
                  ON_HOLD,
		HB.FNAME || ' [' || HB.ENO || ']' HELD_BY,
		M.HELDON HELD_ON,
		INITCAP (
                  case
			when M.RESERVE_INV = 'Y' then 'YES'
			else 'NO'
		end)
                  AGAINST_RESERVATION,
		(
		select
			string_agg (scheme_docno,
			', '
		order by
			scheme_docno)
		from
			invdcmain DCH,
			(
			select
				distinct dccode
			from
				invdcdet
			where
				ordcode = m.ordcode) DCD
		where
			DCH.DCCODE = DCD.DCCODE)
                  CHALLAN_NO,
		M.UDFSTRING01 SALORDMAIN_UDFSTRING01,
		M.UDFSTRING02 SALORDMAIN_UDFSTRING02,
		M.UDFSTRING03 SALORDMAIN_UDFSTRING03,
		M.UDFSTRING04 SALORDMAIN_UDFSTRING04,
		M.UDFSTRING05 SALORDMAIN_UDFSTRING05,
		M.UDFSTRING06 SALORDMAIN_UDFSTRING06,
		M.UDFSTRING07 SALORDMAIN_UDFSTRING07,
		M.UDFSTRING08 SALORDMAIN_UDFSTRING08,
		M.UDFSTRING09 SALORDMAIN_UDFSTRING09,
		M.UDFSTRING10 SALORDMAIN_UDFSTRING10,
		M.UDFNUM01 SALORDMAIN_UDFNUM01,
		M.UDFNUM02 SALORDMAIN_UDFNUM02,
		M.UDFNUM03 SALORDMAIN_UDFNUM03,
		M.UDFNUM04 SALORDMAIN_UDFNUM04,
		M.UDFNUM05 SALORDMAIN_UDFNUM05,
		M.UDFDATE01 SALORDMAIN_UDFDATE01,
		M.UDFDATE02 SALORDMAIN_UDFDATE02,
		M.UDFDATE03 SALORDMAIN_UDFDATE03,
		M.UDFDATE04 SALORDMAIN_UDFDATE04,
		M.UDFDATE05 SALORDMAIN_UDFDATE05,
		case
			when m.SALETYPE = 'O' then 'SALES ORDER'
			else 'TRANSFER ORDER'
		end
                  SALETYPE,
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
		/*Start Bug :63055*/
		os.website OWNER_SITE_WEBSITE,
		/*End Bug :63055*/
		OS.GST_IDENTIFICATION_NO OWNER_GST_IDENTIFICATION_NO,
		OS.GST_STATE_CODE OWNER_GST_STATE_CODE,
		OS.GST_STATE_NAME OWNER_GST_STATE_NAME,
		rs.NAME REFSITE_NAME,
		rs.SHORT_CODE REFSITE_SHORT_CODE,
		rs.ADDRESS REFSITE_ADDRESS,
		rs.CITY REFSITE_CITY,
		rs.PINCODE REFSITE_PINCODE,
		rs.PHONE1 REFSITE_PHONE1,
		rs.PHONE2 REFSITE_PHONE2,
		rs.PHONE3 REFSITE_PHONE3,
		rs.EMAIL1 REFSITE_EMAIL,
		rs.GST_IDENTIFICATION_NO REFSITE_GSTIN_NO,
		rs.GST_STATE_CODE REFSITE_GST_STATE_CODE,
		rs.GST_STATE_NAME REFSITE_GST_STATE_NAME,
		rs.SHIPPING_COMPANY_NAME
                  REFSITE_SHIPPING_COMPANY_NAME,
		rs.SHIPPING_ADDRESS REFSITE_SHIPPING_ADDRESS,
		rs.SHIPPING_CITY REFSITE_SHIPPING_CITY,
		rs.SHIPPING_PINCODE REFSITE_SHIPPING_PINCODE,
		rs.SHIPPING_PHONE1 REFSITE_SHIPPING_PHONE1,
		rs.SHIPPING_PHONE2 REFSITE_SHIPPING_PHONE2,
		rs.SHIPPING_PHONE3 REFSITE_SHIPPING_PHONE3,
		rs.SHIPPING_EMAIL1 REFSITE_SHIPPING_EMAIL1,
		rs.SHIPPING_GST_IDENTIFICATION_NO REFSITE_SHIP_GSTIN_NO,
		rs.SHIPPING_GST_STATE_CODE REFSITE_SHIP_GST_STATE_CODE,
		rs.SHIPPING_GST_STATE_NAME REFSITE_SHIP_GST_STATE_NAME
	from
		SALORDMAIN M
	inner join HRDEMP CR on
		(M.ECODE = CR.ECODE)
               /*Start Bug Id : 63057*/
	left join ADMOU OU on
		(M.ADMOU_CODE = OU.CODE)
               /*End Bug Id : 63057*/
	inner join site_data os
                  on
		(M.admsite_code_owner = os.sitecode)
	inner join site_data rs on
		(M.admsite_code = Rs.sitecode)
	inner join ADMYEAR YR on
		(M.YCODE = YR.YCODE)
	left outer join FINSL AG on
		(M.AGCODE = AG.SLCODE)
	left outer join FINSL TR on
		(M.TRPCODE = TR.SLCODE)
	left outer join HRDEMP LA on
		(LAST_ACCESS_ECODE = LA.ECODE)
	left outer join HRDEMP AU on
		(AUTHORCODE = AU.ECODE)
	left outer join HRDEMP HB on
		(HELDBY = HB.ECODE)
	left outer join SALPRICELISTMAIN PR
                  on
		(M.PRICELISTCODE = PR.PRICELISTCODE)
	left outer join SALTERMMAIN ST
                  on
		(M.SALTERMCODE = ST.SALTERMCODE)
	left outer join FINTRADEGRP TD
                  on
		(M.SALTRADEGRP_CODE = TD.CODE)
	left outer join PSITE_POSORDER POS
                  on
		(PSITE_POSORDER_CODE = POS.CODE)
	left outer join
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
			S.CP_GSTIN_STATE_CODE CUST_GST_STATE_CODE
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
		(m.ordcode in (
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
		null SALES_CHARGE_NAME,
		null DISPLAY_SEQUENCE,
		null CHARGE_RATE,
		null CHARGE_AMOUNT,
		null CHARGE_BASIS,
		null CHARGE_APPLICABLE_ON,
		null OPERATION_LEVEL,
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
		null HSN_CESS_AMOUNT
	from
		(
		select
			row_number () over ( partition by ORDCODE,ARTICLE_NAME order by ORDCODE,ARTICLE_NAME ) SLNO,
			ORDCODE,
			ARTICLE_NAME,
			MAX(IMAGE_NAME) IMAGE_NAME,
			category2,
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
				dense_rank ()
                   over (
                      partition by D.ORDCODE
			order by
				TRIM (CONCAT (I.INVITEM_UDFSTRING07,I.CATEGORY3)))
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
				I.RSP MRP,
				SUM (D.DISCOUNT) DISCOUNT,
				SUM (TAX.TAXABLE_AMOUNT) TAXABLE_AMOUNT,
				case
					when SUM (coalesce (D.NETAMT,
					0)) = 0
                      then
                           ( SUM (D.ORDQTY * D.RATE)
                            + SUM (coalesce (D.CHGAMT,
					0)))
                         + SUM (coalesce (D.TAXAMT,
					0))
					else
                         SUM (coalesce (D.NETAMT,
					0))
				end
                      ITEM_NET_AMOUNT
			from
				SALORDDET D
			inner join GINVIEW.LV_ITEM I on
				D.ICODE = I.CODE
			left outer join
                   (
				select
					distinct SALORDDET_CODE,
					APPAMT TAXABLE_AMOUNT
				from
					SALORDCHG_ITEM
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
				(D.CODE = TAX.SALORDDET_CODE)
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
				D.RATE,
				I.RSP,
				TRIM (CONCAT (I.INVITEM_UDFSTRING07,I.CATEGORY3)))
		group by
			ORDCODE,
			ARTICLE_NAME,
			category2,
			RATE,
			MRP
		order by ORDCODE,
			ARTICLE_NAME,category2) d
union all
        /*Charge Part*/
	select
		'L3#CHARGE' LVL,
		2 SEQ,
		ORDCODE ORDCODE,
		null SLNO,
		null ARTICLE_NAME,
		null IMAGE_NAME,
		null category2,
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
		SALCHGNAME SALES_CHARGE_NAME,
		SEQ DISPLAY_SEQUENCE,
		RATE CHARGE_RATE,
		CHGAMT CHARGE_AMOUNT,
		INITCAP (
                  case
			when coalesce (A.BASIS,
			'P') = 'P' then 'PERCENTAGE'
			when coalesce (A.BASIS,
			'P') = 'A' then 'AMOUNT'
		end)
                  CHARGE_BASIS,
		APPAMT CHARGE_APPLICABLE_ON,
		INITCAP (
                  case
			when coalesce (A.OPERATION_LEVEL,
			'H') = 'H'
                     then
                        'HEADER'
			when coalesce (A.OPERATION_LEVEL,
			'H') = 'L'
                     then
                        'LINE'
		end)
                  OPERATION_LEVEL,
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
		null::numeric HSN_CESS_AMOUNT
	from
		SALORDCHG A
	inner join SALCHG B on
		(CHGCODE = SALCHGCODE)
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
		ORDCODE ORDCODE,
		null SLNO,
		null ARTICLE_NAME,
		null IMAGE_NAME,
		null category2,
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
		null SALES_CHARGE_NAME,
		null DISPLAY_SEQUENCE,
		null CHARGE_RATE,
		null CHARGE_AMOUNT,
		null CHARGE_BASIS,
		null CHARGE_APPLICABLE_ON,
		null OPERATION_LEVEL,
		SUM (ORDQTY) HSN_ORDER_QUANTITY,
		GOVT_IDENTIFIER HSN_CODE,
		HSN_SAC_CODE HSN_SAC_ID,
		DESCRIPTION HSN_DESCRIPTION,
		UNITNAME HSN_UOM,
		SUM (TAXABLE_AMOUNT) HSN_TAXABLE_AMOUNT,
		CGST_RATE HSN_CGST_RATE,
		SUM (CGST_AMOUNT) HSN_CGST_AMOUNT,
		SGST_RATE HSN_SGST_RATE,
		SUM (SGST_AMOUNT) HSN_SGST_AMOUNT,
		IGST_RATE HSN_IGST_RATE,
		SUM (IGST_AMOUNT) HSN_IGST_AMOUNT,
		CESS_RATE HSN_CESS_RATE,
		SUM (CESS_AMOUNT) HSN_CESS_AMOUNT
	from
		(
		select
			*
		from
			SALORDDET
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
		(D.ICODE = I.ICODE)
	left outer join
                 (
		select
			SALORDDET_CODE,
			APPAMT TAXABLE_AMOUNT,
			SUM (
                              case
				when GST_COMPONENT = 'CGST' then RATE
				else 0
			end)
                              CGST_RATE,
			SUM (
                              case
				when GST_COMPONENT = 'CGST' then CHGAMT
				else 0
			end)
                              CGST_AMOUNT,
			SUM (
                              case
				when GST_COMPONENT = 'SGST' then RATE
				else 0
			end)
                              SGST_RATE,
			SUM (
                              case
				when GST_COMPONENT = 'SGST' then CHGAMT
				else 0
			end)
                              SGST_AMOUNT,
			SUM (
                              case
				when GST_COMPONENT = 'IGST' then RATE
				else 0
			end)
                              IGST_RATE,
			SUM (
                              case
				when GST_COMPONENT = 'IGST' then CHGAMT
				else 0
			end)
                              IGST_AMOUNT,
			SUM (
                              case
				when GST_COMPONENT = 'CESS' then RATE
				else 0
			end)
                              CESS_RATE,
			SUM (
                              case
				when GST_COMPONENT = 'CESS' then CHGAMT
				else 0
			end)
                              CESS_AMOUNT
		from
			SALORDCHG_ITEM
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
			SALORDDET_CODE,
			APPAMT) TAX
                    on
		(D.CODE = SALORDDET_CODE)
	inner join INVHSNSACMAIN H on
		(INVHSNSACMAIN_CODE = H.CODE)
	where
		(d.ordcode in (
		select
			unnest(regexp_matches('@DocumentId@',
			'[^|~|]+',
			'g'))::bigint as col1)
			or coalesce (nullif ('@DocumentId@',
			''),
			'0')::text = 0::text)
	group by
		ORDCODE,
		GOVT_IDENTIFIER,
		HSN_SAC_CODE,
		DESCRIPTION,
		UNITNAME,
		CGST_RATE,
		SGST_RATE,
		IGST_RATE,
		CESS_RATE) D
          on
	(H.ORDCODE = D.ORDCODE)