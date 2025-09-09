/*|| Custom Development || Object : CQ_DC || Ticket Id :  410754 || Developer : Dipankar ||*/
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
	ginview.fnc_uk() uk,
	h.DCCODE L1_DCCODE,
	h.CHALLAN_DATE L1_CHALLAN_DATE,
	h.PCODE L1_PCODE,
	h.CUST_NAME L1_CUST_NAME,
	h.CUST_BILLING_ADDRESS L1_CUST_BILLING_ADDRESS,
	h.CUST_BILLING_CITY L1_CUST_BILLING_CITY,
	h.CUST_BILLING_CONTACT_PERSON L1_CUST_BILLING_CONTACT_PERSON,
	h.CUST_BILLING_DISTRICT L1_CUST_BILLING_DISTRICT,
	h.CUST_BILLING_EMAIL1 L1_CUST_BILLING_EMAIL1,
	h.CUST_BILLING_EMAIL2 L1_CUST_BILLING_EMAIL2,
	h.CUST_BILLING_FAX L1_CUST_BILLING_FAX,
	h.CUST_BILLING_MOBILE L1_CUST_BILLING_MOBILE,
	h.CUST_BILLING_OFFICE_PHONE1 L1_CUST_BILLING_OFFICE_PHONE1,
	h.CUST_BILLING_OFFICE_PHONE2 L1_CUST_BILLING_OFFICE_PHONE2,
	h.CUST_BILLING_OFFICE_PHONE3 L1_CUST_BILLING_OFFICE_PHONE3,
	h.CUST_BILLING_PINCODE L1_CUST_BILLING_PINCODE,
	h.CUST_BILLING_STATE L1_CUST_BILLING_STATE,
	h.CUST_BILLING_WEBSITE L1_CUST_BILLING_WEBSITE,
	h.CUST_BILLING_ZONE L1_CUST_BILLING_ZONE,
	h.CUST_GSTIN_NO L1_CUST_GSTIN_NO,
	h.CUST_GST_STATE_NAME L1_CUST_GST_STATE_NAME,
	h.CUST_GST_STATE_CODE L1_CUST_GST_STATE_CODE,
	h.INVOICE_NO L1_INVOICE_NO,
	h.INVOICE_DATE L1_INVOICE_DATE,
	h.OUT_STOCKPOINT L1_OUT_STOCKPOINT,
	h.HEADER_REMARKS L1_HEADER_REMARKS,
	h.CREATED_BY L1_CREATED_BY,
	h.CREATED_ON L1_CREATED_ON,
	h.REFERENCE_NO L1_REFERENCE_NO,
	h.AGCODE L1_AGCODE,
	h.AGENT_NAME L1_AGENT_NAME,
	h.TRPCODE L1_TRPCODE,
	h.TRANSPORTER_NAME L1_TRANSPORTER_NAME,
	h.SALE_TYPE L1_SALE_TYPE,
	h.CANCELLED_BY L1_CANCELLED_BY,
	h.STATUS L1_STATUS,
	h.CANCELLED_ON L1_CANCELLED_ON,
	h.AGAINST_ORDER L1_AGAINST_ORDER,
	h.CHALLAN_BARCODE L1_CHALLAN_BARCODE,
	h.CHALLAN_NO L1_CHALLAN_NO,
	h.ADMOU_CODE L1_ADMOU_CODE,
	h.ORGUNIT_NAME L1_ORGUNIT_NAME,
	h.ORGUNIT_WEBSITE L1_ORGUNIT_WEBSITE,
	h.ORGUNIT_CIN L1_ORGUNIT_CIN,
	h.ADMSITE_CODE L1_ADMSITE_CODE,
	h.REFSITE_NAME L1_REFSITE_NAME,
	h.REFSITE_SHORT_CODE L1_REFSITE_SHORT_CODE,
	h.REFSITE_ADDRESS L1_REFSITE_ADDRESS,
	h.REFSITE_CITY L1_REFSITE_CITY,
	h.REFSITE_PINCODE L1_REFSITE_PINCODE,
	h.REFSITE_EMAIL L1_REFSITE_EMAIL,
	h.REFSITE_EMAIL1 L1_REFSITE_EMAIL1,
	h.REFSITE_PHONE1 L1_REFSITE_PHONE1,
	h.REFSITE_PHONE2 L1_REFSITE_PHONE2,
	h.REFSITE_PHONE3 L1_REFSITE_PHONE3,
	h.REFSITE_GST_IDENTIFICATION_NO L1_REFSITE_GSTIN_NO,
	h.REFSITE_GST_STATE_NAME L1_REFSITE_GST_STATE_NAME,
	h.REFSITE_GST_STATE_CODE L1_REFSITE_GST_STATE_CODE,
	h.REFSITE_SHIPPING_COMPANY_NAME L1_REFSITE_SHIP_COMPANY_NAME,
	h.REFSITE_SHIPPING_ADDRESS L1_REFSITE_SHIP_ADDRESS,
	h.REFSITE_SHIPPING_CITY L1_REFSITE_SHIP_CITY,
	h.REFSITE_SHIPPING_PINCODE L1_REFSITE_SHIP_PINCODE,
	h.REFSITE_SHIPPING_PHONE1 L1_REFSITE_SHIP_PHONE1,
	h.REFSITE_SHIPPING_PHONE2 L1_REFSITE_SHIP_PHONE2,
	h.REFSITE_SHIPPING_PHONE3 L1_REFSITE_SHIP_PHONE3,
	h.REFSITE_SHIPPING_EMAIL1 L1_REFSITE_SHIP_EMAIL1,
	h.REFSITE_SHIP_GSTIN_NO L1_REFSITE_SHIP_GSTIN_NO,
	h.REFSITE_SHIP_GST_STATE_NAME L1_REFSITE_SHIP_GST_STATE_NAME,
	h.REFSITE_SHIP_GST_STATE_CODE L1_REFSITE_SHIP_GST_STATE_CODE,
	h.PRICE_TYPE L1_PRICE_TYPE,
	h.PRICE_LIST_NAME L1_PRICE_LIST_NAME,
	h.DISCOUNT_FACTOR L1_DISCOUNT_FACTOR,
	h.ADMSITE_CODE_OWNER L1_ADMSITE_CODE_OWNER,
	h.OWNER_SITE_NAME L1_OWNER_SITE_NAME,
	h.OWNER_SHORT_CODE L1_OWNER_SHORT_CODE,
	h.OWNER_SITE_ADDRESS L1_OWNER_SITE_ADDRESS,
	h.OWNER_SITE_CITY L1_OWNER_SITE_CITY,
	h.OWNER_SITE_PINCODE L1_OWNER_SITE_PINCODE,
	h.OWNER_SITE_EMAIL1 L1_OWNER_SITE_EMAIL1,
	h.OWNER_SITE_EMAIL2 L1_OWNER_SITE_EMAIL2,
	h.OWNER_SITE_PHONE1 L1_OWNER_SITE_PHONE1,
	h.OWNER_SITE_PHONE2 L1_OWNER_SITE_PHONE2,
	h.OWNER_SITE_PHONE3 L1_OWNER_SITE_PHONE3,
	h.OWNER_GSTIN_NO L1_OWNER_GSTIN_NO,
	h.OWNER_GST_STATE_CODE L1_OWNER_GST_STATE_CODE,
	h.OWNER_GST_STATE_NAME L1_OWNER_GST_STATE_NAME,
	h.owner_site_website L1_OWNER_SITE_WEBSITE,
	h.TRANSFER_IN_NO L1_TRANSFER_IN_NO,
	h.PRICE_MODE L1_PRICE_MODE,
	h.PRICE_BASIS L1_PRICE_BASIS,
	h.TRADE_GROUP_NAME L1_TRADE_GROUP_NAME,
	h.FORM_NAME L1_FORM_NAME,
	h.TAX_BASED_ON L1_TAX_BASED_ON,
	h.DOCUMENT_STATUS L1_DOCUMENT_STATUS,
	h.DC_STATUS L1_DC_STATUS,
	h.OUTLOCCODE L1_OUTLOCCODE,
	h.ENTRY_MODE L1_ENTRY_MODE,
	h.LAST_MODIFIED_BY L1_LAST_MODIFIED_BY,
	h.LAST_MODIFIED_ON L1_LAST_MODIFIED_ON,
	h.INVDCMAIN_UDFSTRING01 L1_INVDCMAIN_UDFSTRING01,
	h.INVDCMAIN_UDFSTRING02 L1_INVDCMAIN_UDFSTRING02,
	h.INVDCMAIN_UDFSTRING03 L1_INVDCMAIN_UDFSTRING03,
	h.INVDCMAIN_UDFSTRING04 L1_INVDCMAIN_UDFSTRING04,
	h.INVDCMAIN_UDFSTRING05 L1_INVDCMAIN_UDFSTRING05,
	h.INVDCMAIN_UDFSTRING06 L1_INVDCMAIN_UDFSTRING06,
	h.INVDCMAIN_UDFSTRING07 L1_INVDCMAIN_UDFSTRING07,
	h.INVDCMAIN_UDFSTRING08 L1_INVDCMAIN_UDFSTRING08,
	h.INVDCMAIN_UDFSTRING09 L1_INVDCMAIN_UDFSTRING09,
	h.INVDCMAIN_UDFSTRING10 L1_INVDCMAIN_UDFSTRING10,
	h.INVDCMAIN_UDFNUM01 L1_INVDCMAIN_UDFNUM01,
	h.INVDCMAIN_UDFNUM02 L1_INVDCMAIN_UDFNUM02,
	h.INVDCMAIN_UDFNUM03 L1_INVDCMAIN_UDFNUM03,
	h.INVDCMAIN_UDFNUM04 L1_INVDCMAIN_UDFNUM04,
	h.INVDCMAIN_UDFNUM05 L1_INVDCMAIN_UDFNUM05,
	h.INVDCMAIN_UDFDATE01 L1_INVDCMAIN_UDFDATE01,
	h.INVDCMAIN_UDFDATE02 L1_INVDCMAIN_UDFDATE02,
	h.INVDCMAIN_UDFDATE03 L1_INVDCMAIN_UDFDATE03,
	h.INVDCMAIN_UDFDATE04 L1_INVDCMAIN_UDFDATE04,
	h.INVDCMAIN_UDFDATE05 L1_INVDCMAIN_UDFDATE05,
	h.LINKED_CHALLAN_NO L1_LINKED_CHALLAN_NO,
	h.LINKED_STORE_PACKET_NO L1_LINKED_STORE_PACKET_NO,
	h.PRICE_INCLUSION_OF_TAX L1_PRICE_INCLUSION_OF_TAX,
	h.PRICE_ROUND_OFF L1_PRICE_ROUND_OFF,
	H.PRICE_ROUND_OFF_LIMIT L1_PRICE_ROUND_OFF_LIMIT,
	LVL,
	SEQ,
	d.l2_item,
	d.l2_uom,
	d.l2_CHALLAN_QUANTITY,
	d.l3_item,
	d.l3_CHALLAN_QUANTITY
from
	(/*Header Part*/
	select
		A.DCCODE DCCODE,
		A.DCDT CHALLAN_DATE,
		A.PCODE PCODE,
		S.SLNAME CUST_NAME,
		S.BADDR CUST_BILLING_ADDRESS,
		S.BCTNAME CUST_BILLING_CITY,
		S.BCP CUST_BILLING_CONTACT_PERSON,
		BCT.DIST CUST_BILLING_DISTRICT,
		S.BEMAIL CUST_BILLING_EMAIL1,
		S.BEMAIL2 CUST_BILLING_EMAIL2,
		S.BFX1 CUST_BILLING_FAX,
		S.BFX2 CUST_BILLING_MOBILE,
		S.BPH1 CUST_BILLING_OFFICE_PHONE1,
		S.BPH2 CUST_BILLING_OFFICE_PHONE2,
		S.BPH3 CUST_BILLING_OFFICE_PHONE3,
		S.BPIN CUST_BILLING_PINCODE,
		BCT.STNAME CUST_BILLING_STATE,
		S.BWEBSITE CUST_BILLING_WEBSITE,
		BCT.ZONE CUST_BILLING_ZONE,
		S.CP_GSTIN_NO CUST_GSTIN_NO,
		GTE.NAME CUST_GST_STATE_NAME,
		S.CP_GSTIN_STATE_CODE CUST_GST_STATE_CODE,
		INV.SCHEME_DOCNO INVOICE_NO,
		INV.INVDT INVOICE_DATE,
		LOC.LOCNAME OUT_STOCKPOINT,
		A.REM HEADER_REMARKS,
		(CR.FNAME || ' ') || CR.ENO CREATED_BY,
		A.TIME CREATED_ON,
		A.DOCNO REFERENCE_NO,
		A.AGCODE AGCODE,
		AG.SLNAME AGENT_NAME,
		A.TRPCODE TRPCODE,
		TRP.SLNAME TRANSPORTER_NAME,
		INITCAP (
                  case
			when A.SALETYPE = 'C' then 'CONSIGNMENT'
			when A.SALETYPE = 'O' then 'OUTRIGHT'
		end)
                  SALE_TYPE,
		(CN.FNAME || ' ') || CN.ENO CANCELLED_BY,
		INITCAP (
                  case
			when A.STATUS = 'P' then 'PENDING'
			when A.STATUS = 'I' then 'INVOICED'
			when A.STATUS = 'C' then 'CANCELLED'
		end)
                  STATUS,
		A.CNLDT CANCELLED_ON,
		INITCAP (
                  case
			when coalesce (A.AGAINST_SO,
			'N') = 'Y' then 'YES'
			when coalesce (A.AGAINST_SO,
			'N') = 'N' then 'NO'
		end)
                  AGAINST_ORDER,
		A.DCBARCODE CHALLAN_BARCODE,
		A.SCHEME_DOCNO CHALLAN_NO,
		A.ADMOU_CODE ADMOU_CODE,
		OU.NAME ORGUNIT_NAME,
		OU.WEBSITE ORGUNIT_WEBSITE,
		OU.CINNO ORGUNIT_CIN,
		A.ADMSITE_CODE ADMSITE_CODE,
		RS.NAME REFSITE_NAME,
		RS.SHORT_CODE REFSITE_SHORT_CODE,
		RS.ADDRESS REFSITE_ADDRESS,
		RS.CITY REFSITE_CITY,
		RS.PINCODE REFSITE_PINCODE,
		RS.EMAIL1 REFSITE_EMAIL,
		RS.EMAIL2 REFSITE_EMAIL1,
		RS.PHONE1 REFSITE_PHONE1,
		RS.PHONE2 REFSITE_PHONE2,
		RS.PHONE3 REFSITE_PHONE3,
		RS.GST_IDENTIFICATION_NO REFSITE_GST_IDENTIFICATION_NO,
		RS.GST_STATE_NAME REFSITE_GST_STATE_NAME,
		RS.GST_STATE_CODE REFSITE_GST_STATE_CODE,
		RS.SHIPPING_COMPANY_NAME REFSITE_SHIPPING_COMPANY_NAME,
		RS.SHIPPING_ADDRESS REFSITE_SHIPPING_ADDRESS,
		RS.SHIPPING_CITY REFSITE_SHIPPING_CITY,
		RS.SHIPPING_PINCODE REFSITE_SHIPPING_PINCODE,
		RS.SHIPPING_PHONE1 REFSITE_SHIPPING_PHONE1,
		RS.SHIPPING_PHONE2 REFSITE_SHIPPING_PHONE2,
		RS.SHIPPING_PHONE3 REFSITE_SHIPPING_PHONE3,
		RS.SHIPPING_EMAIL1 REFSITE_SHIPPING_EMAIL1,
		RS.SHIPPING_GST_IDENTIFICATION_NO REFSITE_SHIP_GSTIN_NO,
		RS.SHIPPING_GST_STATE_NAME REFSITE_SHIP_GST_STATE_NAME,
		RS.SHIPPING_GST_STATE_CODE REFSITE_SHIP_GST_STATE_CODE,
		INITCAP (
                  case
			when coalesce (A.PRICETYPE,
			'M') = 'F'
                     then
                        'FIFO'
			when coalesce (A.PRICETYPE,
			'M') = 'M'
                     then
                        'RSP'
			when coalesce (A.PRICETYPE,
			'M') = 'L'
                     then
                        'MRP'
			when coalesce (A.PRICETYPE,
			'M') = 'W'
                     then
                        'WSP'
			when coalesce (A.PRICETYPE,
			'M') = 'C'
                     then
                        'EFFECTIVE RATE (LAST LANDING COST)'
			when coalesce (A.PRICETYPE,
			'M') = 'R'
                     then
                        'STANDARD RATE'
			when coalesce (A.PRICETYPE,
			'M') = 'B'
                     then
                        'BASIC RATE (LAST PURCHASE)'
		end)
                  PRICE_TYPE,
		PR.PRICELISTNAME PRICE_LIST_NAME,
		A.DISCOUNT_FACTOR DISCOUNT_FACTOR,
		A.ADMSITE_CODE_OWNER ADMSITE_CODE_OWNER,
		OS.NAME OWNER_SITE_NAME,
		OS.SHORT_CODE OWNER_SHORT_CODE,
		OS.ADDRESS OWNER_SITE_ADDRESS,
		OS.CITY OWNER_SITE_CITY,
		OS.PINCODE OWNER_SITE_PINCODE,
		OS.EMAIL1 OWNER_SITE_EMAIL1,
		OS.EMAIL2 OWNER_SITE_EMAIL2,
		OS.PHONE1 OWNER_SITE_PHONE1,
		OS.PHONE2 OWNER_SITE_PHONE2,
		OS.PHONE3 OWNER_SITE_PHONE3,
		os.GST_IDENTIFICATION_NO OWNER_GSTIN_NO,
		os.GST_STATE_CODE OWNER_GST_STATE_CODE,
		os.GST_STATE_NAME OWNER_GST_STATE_NAME,
		/*Start Bug :63055*/
		os.website owner_site_website,
		/*End Bug :63055*/
		RT.SCHEME_DOCNO TRANSFER_IN_NO,
		INITCAP (
                  case
			when coalesce (A.DISCOUNT_MODE,
			'U') = 'U'
                     then
                        'MARKUP'
			when coalesce (A.DISCOUNT_MODE,
			'U') = 'D'
                     then
                        'MARKDOWN'
		end)
                  PRICE_MODE,
		INITCAP (
                  case
			when coalesce (A.DISCOUNT_BASIS,
			'B') = 'B'
                     then
                        'ON BASE PRICE'
			when coalesce (A.DISCOUNT_BASIS,
			'B') = 'N'
                     then
                        'ON NET PRICE'
		end)
                  PRICE_BASIS,
		P.NAME TRADE_GROUP_NAME,
		FR.FORMNAME FORM_NAME,
		INITCAP (
                  case
			when coalesce (A.CMPTAX_CODE_BASIS,
			'D') = 'S'
                     then
                        'SOURCE'
			when coalesce (A.CMPTAX_CODE_BASIS,
			'D') = 'D'
                     then
                        'DESTINATION'
		end)
                  TAX_BASED_ON,
		INITCAP (
                  case
			when A.DOC_STATUS = 'O' then 'OPEN'
			when A.DOC_STATUS = 'C' then 'CLOSED'
		end)
                  DOCUMENT_STATUS,
		case
			when ( (A.STATUS = 'I')
				and (INV.RELEASE_STATUS = 'U'))
                  then
                     'Invoiced'
			when ( ( (A.STATUS = 'I')
				and (INV.RELEASE_STATUS = 'P'))
				and ( ( (UPPER (RF.SITETYPE) like 'MS%')
					and (not (exists
                                              (
					select
						1
					from
						PSITE_GRCITEM P
					where
						A.DCCODE = P.DCCODE))))
				or ( (UPPER (RF.SITETYPE) like 'OS%')
					and (not (exists
                                              (
					select
						1
					from
						SALINVDET SALINVDET
					where
						SALINVDET.INVCODE =
                                                         TRANSFEROUT_INVCODE))))))
                  then
                     'Transit'
			when ( ( (A.STATUS = 'I')
				and (INV.RELEASE_STATUS = 'P'))
				and ( ( (UPPER (RF.SITETYPE) like 'US%')
					or ( (UPPER (RF.SITETYPE) like 'MS%')
						and (exists
                                             (
						select
							1
						from
							PSITE_GRCITEM P
						where
							A.DCCODE = P.DCCODE))))
				or ( (UPPER (RF.SITETYPE) like 'OS%')
					and (exists
                                         (
					select
						1
					from
						SALINVDET SALINVDET
					where
						(SALINVDET.INVCODE =
                                                         TRANSFEROUT_INVCODE)
							and (A.DCCODE =
                                                         SALINVDET.DCCODE))))))
                  then
                     'Received'
			else
                     INITCAP (
                        case
				when A.STATUS = 'P' then 'PENDING'
				when A.STATUS = 'I' then 'INVOICED'
				when A.STATUS = 'C' then 'CANCELLED'
			end)
		end
                  DC_STATUS,
		A.OUTLOCCODE OUTLOCCODE,
		case
			when A.ENTRY_MODE = 'A' then 'Adhoc'
			when A.ENTRY_MODE = 'O' then 'Against Order'
			when A.ENTRY_MODE = 'R' then 'Reservation'
		end
                  ENTRY_MODE,
		case
			when (A.LAST_ACCESS_ECODE is not null)
                  then
                     ( ( (LM.FNAME || ' [') || LM.ENO) || ']')
		end
                  LAST_MODIFIED_BY,
		A.LAST_ACCESS_TIME LAST_MODIFIED_ON,
		LNK.SCHEME_DOCNO LINKED_CHALLAN_NO,
		PACKETNO LINKED_STORE_PACKET_NO,
		A.UDFSTRING01 INVDCMAIN_UDFSTRING01,
		A.UDFSTRING02 INVDCMAIN_UDFSTRING02,
		A.UDFSTRING03 INVDCMAIN_UDFSTRING03,
		A.UDFSTRING04 INVDCMAIN_UDFSTRING04,
		A.UDFSTRING05 INVDCMAIN_UDFSTRING05,
		A.UDFSTRING06 INVDCMAIN_UDFSTRING06,
		A.UDFSTRING07 INVDCMAIN_UDFSTRING07,
		A.UDFSTRING08 INVDCMAIN_UDFSTRING08,
		A.UDFSTRING09 INVDCMAIN_UDFSTRING09,
		A.UDFSTRING10 INVDCMAIN_UDFSTRING10,
		A.UDFNUM01 INVDCMAIN_UDFNUM01,
		A.UDFNUM02 INVDCMAIN_UDFNUM02,
		A.UDFNUM03 INVDCMAIN_UDFNUM03,
		A.UDFNUM04 INVDCMAIN_UDFNUM04,
		A.UDFNUM05 INVDCMAIN_UDFNUM05,
		A.UDFDATE01 INVDCMAIN_UDFDATE01,
		A.UDFDATE02 INVDCMAIN_UDFDATE02,
		A.UDFDATE03 INVDCMAIN_UDFDATE03,
		A.UDFDATE04 INVDCMAIN_UDFDATE04,
		A.UDFDATE05 INVDCMAIN_UDFDATE05,
		INITCAP (
                  case
			when coalesce (A.INCL_VAT_IN_DIST,
			'N') = 'Y' then 'YES'
			when coalesce (A.INCL_VAT_IN_DIST,
			'N') = 'N' then 'NO'
		end)
                  PRICE_INCLUSION_OF_TAX,
		A.PRICE_ROUNDOFF PRICE_ROUND_OFF,
		INITCAP (
                  case
			when coalesce (A.ROUNDOFF_LIMIT,
			'N') = 'Y' then 'YES'
			when coalesce (A.ROUNDOFF_LIMIT,
			'N') = 'N' then 'NO'
		end)
                  PRICE_ROUND_OFF_LIMIT
	from
		INVDCMAIN A
	left outer join FINSL S on
		A.PCODE = S.SLCODE
	left outer join ADMCITY BCT on
		S.BCTNAME = BCT.CTNAME
	left outer join SALINVMAIN INV on
		A.INVCODE = INV.INVCODE
	inner join INVLOC LOC on
		A.OUTLOCCODE = LOC.LOCCODE
	inner join HRDEMP CR on
		A.ECODE = CR.ECODE
	left outer join FINSL AG on
		A.AGCODE = AG.SLCODE
	left outer join FINSL TRP on
		A.TRPCODE = TRP.SLCODE
	left outer join HRDEMP CN on
		A.CNLECODE = CN.ECODE
	inner join ADMOU OU on
		A.ADMOU_CODE = OU.CODE
	left outer join ADMGSTSTATE GTE
                  on
		S.CP_GSTIN_STATE_CODE = GTE.CODE
	inner join SITE_DATA OS on
		A.ADMSITE_CODE_OWNER = OS.SITECODE
	inner join SITE_DATA RS on
		A.ADMSITE_CODE = RS.SITECODE
	left outer join SALPRICELISTMAIN PR
                  on
		A.PRICELISTCODE = PR.PRICELISTCODE
	left outer join SALRTMAIN RT on
		A.TRANSFERIN_RTCODE = RTCODE
	left outer join INVDCMAIN LNK on
		A.LINKED_DCCODE = LNK.DCCODE
	left outer join FINTRADEGRP P on
		A.SALTRADEGRP_CODE = P.CODE
	left outer join FINFORM FR on
		A.FORMCODE = FR.FORMCODE
	left outer join PSITE_PACKET PK
                  on
		A.LINKED_PSITE_PACKET_ID = PK.ID
	inner join ADMSITE RF on
		A.ADMSITE_CODE = RF.CODE
	left outer join HRDEMP LM on
		A.LAST_ACCESS_ECODE = LM.ECODE
	where
		(a.dccode in (
		select
			unnest(regexp_matches('@DocumentId@',
			'[^|~|]+',
			'g'))::bigint as col1)
			or coalesce (nullif ('@DocumentId@',
			''),
			'0')::text = 0::text)) H
inner join
       (
	select
		'L2#DETAIL' LVL,
		1 SEQ,
		DCCODE,
		l2_DCCODE,
		m.item l2_item,
		m.uom l2_uom,
		m.CHALLAN_QUANTITY l2_CHALLAN_QUANTITY,
		null l3_item,
		0 l3_CHALLAN_QUANTITY
	from
		(
		select
			M.DCCODE DCCODE,
			concat_ws(' ', i.division, i.department, i.category1) item,
			i.uom,
			SUM (M.ISQTY) CHALLAN_QUANTITY
		from
			INVDCDET M
		inner join ginview.lv_item i on
			m.icode = i.code
		where
			(dccode in (
			select
				unnest(regexp_matches('@DocumentId@',
				'[^|~|]+',
				'g'))::bigint as col1)
				or coalesce (nullif ('@DocumentId@',
				''),
				'0')::text = 0::text)
		group by
			M.DCCODE,
			concat_ws(' ', i.division, i.department, i.category1),
			i.uom) M
union all
	select
		'L3#DETAIL' LVL,
		2 SEQ,
		DCCODE,
		null l2_item,
		null l2_uom,
		0 l2_CHALLAN_QUANTITY,
		m.item l3_item,
		m.CHALLAN_QUANTITY l3_CHALLAN_QUANTITY
	from
		(
		select
			M.DCCODE DCCODE,
			concat_ws(' ', i.division, i.department, i.category1) item,
			SUM (M.ISQTY) CHALLAN_QUANTITY
		from
			INVDCDET M
		inner join ginview.lv_item i on
			m.icode = i.code
		where
			(dccode in (
			select
				unnest(regexp_matches('@DocumentId@',
				'[^|~|]+',
				'g'))::bigint as col1)
				or coalesce (nullif ('@DocumentId@',
				''),
				'0')::text = 0::text)
		group by
			M.DCCODE,
			concat_ws(' ', i.division, i.department, i.category1) ) M) D
          on
	(H.DCCODE = D.DCCODE)