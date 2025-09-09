/*|| Custom Development || Object : CQ_PURORD || Ticket Id :  420289 || Developer : Dipankar ||*/

WITH site_data
     AS (SELECT ST.CODE     SITECODE,
                ST.NAME     NAME,
                ST.SHRTNAME SHORT_CODE,
                ST.ADDRESS  ADDRESS,
                ST.CTNAME   CITY,
                B.STNAME    STATE,
                B.DIST      DISTRICT,
                ST.PIN      PINCODE,
                ST.OPH1     PHONE1,
                ST.OPH2     PHONE2,
                ST.OPH3     PHONE3,
                st.EMAIL1   EMAIL1,
                ST.EMAIL2   EMAIL2,
                CASE
                   WHEN SITETYPE LIKE '%OO-CM' OR SITETYPE = 'MS-CO-CM'
                   THEN
                      SIN.GSTIN_NO
                   ELSE
                      ST.CP_GSTIN_NO
                END
                   GST_IDENTIFICATION_NO,
                CASE
                   WHEN SITETYPE LIKE '%OO-CM' OR SITETYPE = 'MS-CO-CM'
                   THEN
                      SIN.ADMGSTSTATE_CODE
                   ELSE
                      ST.CP_GSTIN_STATE_CODE
                END
                   GST_STATE_CODE,
                CASE
                   WHEN SITETYPE LIKE '%OO-CM' OR SITETYPE = 'MS-CO-CM'
                   THEN
                      STA.NAME
                   ELSE
                      STA1.NAME
                END
                   GST_STATE_NAME,
                CASE
                   WHEN ST.SITETYPE LIKE '%OM%'
                   THEN
                      CASE
                         WHEN ISBILLINGSHIPPINGSAME = 'Y' THEN F.SLNAME
                         ELSE ST.SHIP_LEGAL_NAME
                      END
                   ELSE
                      O.NAME
                END
                   Shipping_Company_Name,
                CASE
                   WHEN ISBILLINGSHIPPINGSAME = 'Y' THEN ST.ADDRESS
                   ELSE ST.SHIP_ADDRESS
                END
                   Shipping_Address,
                CASE
                   WHEN ISBILLINGSHIPPINGSAME = 'Y' THEN ST.CTNAME
                   ELSE ST.SHIP_CTNAME
                END
                   Shipping_CITY,
                CASE
                   WHEN ISBILLINGSHIPPINGSAME = 'Y' THEN ST.PIN
                   ELSE ST.SHIP_PIN
                END
                   Shipping_Pincode,
                CASE
                   WHEN ISBILLINGSHIPPINGSAME = 'Y' THEN ST.OPH1
                   ELSE ST.SHIP_OPH1
                END
                   Shipping_Phone1,
                CASE
                   WHEN ISBILLINGSHIPPINGSAME = 'Y' THEN ST.OPH2
                   ELSE ST.SHIP_OPH2
                END
                   Shipping_Phone2,
                CASE
                   WHEN ISBILLINGSHIPPINGSAME = 'Y' THEN ST.OPH3
                   ELSE ST.SHIP_OPH3
                END
                   Shipping_Phone3,
                CASE
                   WHEN ISBILLINGSHIPPINGSAME = 'Y' THEN ST.EMAIL1
                   ELSE ST.SHIP_EMAIL1
                END
                   Shipping_Email1,
                CASE
                   WHEN ST.SITETYPE LIKE '%CM'
                   THEN
                      SIN.GSTIN_NO
                   ELSE
                      CASE
                         WHEN ISBILLINGSHIPPINGSAME = 'Y' THEN ST.CP_GSTIN_NO
                         ELSE ST.SHIP_CP_GSTIN_NO
                      END
                END
                   Shipping_GST_Identification_No,
                CASE
                   WHEN ST.SITETYPE LIKE '%CM'
                   THEN
                      SIN.ADMGSTSTATE_CODE
                   ELSE
                      CASE
                         WHEN ISBILLINGSHIPPINGSAME = 'Y'
                         THEN
                            ST.CP_GSTIN_STATE_CODE
                         ELSE
                            ST.SHIP_CP_GSTIN_STATE_CODE
                      END
                END
                   Shipping_GST_State_Code,
                CASE
                   WHEN ST.SITETYPE LIKE '%CM'
                   THEN
                      STA.NAME
                   ELSE
                      CASE
                         WHEN ISBILLINGSHIPPINGSAME = 'Y' THEN STA1.NAME
                         ELSE STA2.NAME
                      END
                END
                   Shipping_GST_State_Name,
                ST.WEBSITE
           FROM ADMSITE ST
                LEFT OUTER JOIN FINSL F ON ST.SLCODE = F.SLCODE
                LEFT OUTER JOIN ADMCITY B ON ST.CTNAME = B.CTNAME
                LEFT OUTER JOIN ADMOU O ON ST.ADMOU_CODE = O.CODE
                LEFT OUTER JOIN ADMGSTIN SIN ON ST.ADMGSTIN_CODE = SIN.CODE
                LEFT OUTER JOIN ADMGSTSTATE STA
                   ON SIN.ADMGSTSTATE_CODE = STA.CODE
                LEFT OUTER JOIN ADMGSTSTATE STA1
                   ON ST.CP_GSTIN_STATE_CODE = STA1.CODE
                LEFT OUTER JOIN ADMGSTSTATE STA2
                   ON ST.SHIP_CP_GSTIN_STATE_CODE = STA2.CODE)
SELECT GINVIEW.FNC_UK()                 UK,
       h.ORDCODE                      L1_ORDCODE,
       h.ORDER_DATE                   L1_ORDER_DATE,
       h.PCODE                        L1_PCODE,
       h.DOCUMENT_NO                  L1_DOCUMENT_NO,
       h.AGCODE                       L1_AGCODE,
       h.AGENT_NAME                   L1_AGENT_NAME,
       h.AGENT_RATE                   L1_AGENT_RATE,
       h.TRPCODE                      L1_TRPCODE,
       h.TRANSPORTER_NAME             L1_TRANSPORTER_NAME,
       h.INV_STATUS                   L1_INV_STATUS,
       h.AUTHORIZED_BY                L1_AUTHORIZED_BY,
       h.REMARKS                      L1_REMARKS,
       h.CREATED_BY                   L1_CREATED_BY,
       h.CREATED_ON                   L1_CREATED_ON,
       h.VALID_FROM                   L1_VALID_FROM,
       h.VALID_TILL                   L1_VALID_TILL,
       h.LAST_ACCESSED_ON             L1_LAST_ACCESSED_ON,
       h.LAST_ACCESSED_BY             L1_LAST_ACCESSED_BY,
       h.TERMS                        L1_TERMS,
       h.TYPE                         L1_TYPE,
       h.ORDER_NO                     L1_ORDER_NO,
       h.ADMOU_CODE                   L1_ADMOU_CODE,
       h.MERCHANDISER                 L1_MERCHANDISER,
       h.TRADE_GROUP_NAME             L1_TRADE_GROUP_NAME,
       h.INV_GROSS_AMOUNT             L1_INV_GROSS_AMOUNT,
       h.INV_CHARGE_AMOUNT            L1_INV_CHARGE_AMOUNT,
       h.NET_AMOUNT                   L1_NET_AMOUNT,
       h.CURRENCY                     L1_CURRENCY,
       h.CURRENCY_DECIMAL_SYMBOL      L1_CURRENCY_DECIMAL_SYMBOL,
       h.CURRENCY_SYMBOL              L1_CURRENCY_SYMBOL,
       h.CURRENCY_EXCHANGE_RATE       L1_CURRENCY_EXCHANGE_RATE,
       h.ADMSITE_CODE                 L1_ADMSITE_CODE,
       h.SHIPMENT_TRACKING_APPLICABLE L1_SHIPMENT_TRACK_APPLICABLE,
       h.PURCHASE_TERM_NAME           L1_PURCHASE_TERM_NAME,
       h.PURORDMAIN_UDFSTRIN01        L1_PURORDMAIN_UDFSTRIN01,
       h.PURORDMAIN_UDFSTRIN02        L1_PURORDMAIN_UDFSTRIN02,
       h.PURORDMAIN_UDFSTRIN03        L1_PURORDMAIN_UDFSTRIN03,
       h.PURORDMAIN_UDFSTRIN04        L1_PURORDMAIN_UDFSTRIN04,
       h.PURORDMAIN_UDFSTRIN05        L1_PURORDMAIN_UDFSTRIN05,
       h.PURORDMAIN_UDFSTRIN06        L1_PURORDMAIN_UDFSTRIN06,
       h.PURORDMAIN_UDFSTRIN07        L1_PURORDMAIN_UDFSTRIN07,
       h.PURORDMAIN_UDFSTRIN08        L1_PURORDMAIN_UDFSTRIN08,
       h.PURORDMAIN_UDFSTRIN09        L1_PURORDMAIN_UDFSTRIN09,
       h.PURORDMAIN_UDFSTRIN010       L1_PURORDMAIN_UDFSTRIN010,
       h.PURORDMAIN_UDFNUM01          L1_PURORDMAIN_UDFNUM01,
       h.PURORDMAIN_UDFNUM02          L1_PURORDMAIN_UDFNUM02,
       h.PURORDMAIN_UDFNUM03          L1_PURORDMAIN_UDFNUM03,
       h.PURORDMAIN_UDFNUM04          L1_PURORDMAIN_UDFNUM04,
       h.PURORDMAIN_UDFNUM05          L1_PURORDMAIN_UDFNUM05,
       h.PURORDMAIN_UDFDATE01         L1_PURORDMAIN_UDFDATE01,
       h.PURORDMAIN_UDFDATE02         L1_PURORDMAIN_UDFDATE02,
       h.PURORDMAIN_UDFDATE03         L1_PURORDMAIN_UDFDATE03,
       h.PURORDMAIN_UDFDATE04         L1_PURORDMAIN_UDFDATE04,
       h.PURORDMAIN_UDFDATE05         L1_PURORDMAIN_UDFDATE05,
       h.AUTHORIZED_ON                L1_AUTHORIZED_ON,
       h.CUST_NAME                    L1_CUST_NAME,
       h.CUST_BILLING_ADDRESS         L1_CUST_BILLING_ADDRESS,
       h.CUST_BILLING_CONTACT_PERSON  L1_CUST_BILLING_CONTACT_PERSON,
       h.CUST_BILLING_CITY            L1_CUST_BILLING_CITY,
       h.CUST_BILLING_STATE           L1_CUST_BILLING_STATE,
       h.CUST_BILLING_DISTRICT        L1_CUST_BILLING_DISTRICT,
       h.CUST_BILLING_ZONE            L1_CUST_BILLING_ZONE,
       h.CUST_BILLING_EMAIL1          L1_CUST_BILLING_EMAIL1,
       h.CUST_BILLING_EMAIL2          L1_CUST_BILLING_EMAIL2,
       h.CUST_BILLING_FAX             L1_CUST_BILLING_FAX,
       h.CUST_BILLING_MOBILE          L1_CUST_BILLING_MOBILE,
       h.CUST_BILLING_OFFICE_PHONE1   L1_CUST_BILLING_OFFICE_PHONE1,
       h.CUST_BILLING_OFFICE_PHONE2   L1_CUST_BILLING_OFFICE_PHONE2,
       h.CUST_BILLING_OFFICE_PHONE3   L1_CUST_BILLING_OFFICE_PHONE3,
       h.CUST_BILLING_PINCODE         L1_CUST_BILLING_PINCODE,
       h.CUST_BILLING_WEBSITE         L1_CUST_BILLING_WEBSITE,
       h.CUST_GSTIN_NO                L1_CUST_GSTIN_NO,
       h.CUST_GST_STATE_NAME          L1_CUST_GST_STATE_NAME,
       h.CUST_GST_STATE_CODE          L1_CUST_GST_STATE_CODE,
       h.CUST_CREDIT_DAYS             L1_CUST_CREDIT_DAYS,
       h.CUST_IDENTITY_NO             L1_CUST_IDENTITY_NO,
       h.ORGUNIT_NAME                 L1_ORGUNIT_NAME,
       h.ORGUNIT_WEBSITE              L1_ORGUNIT_WEBSITE,
       h.ORGUNIT_CIN                  L1_ORGUNIT_CIN,
       h.OWNER_SITE_NAME              L1_OWNER_SITE_NAME,
       h.OWNER_SHORT_CODE             L1_OWNER_SHORT_CODE,
       h.OWNER_SITE_ADDRESS           L1_OWNER_SITE_ADDRESS,
       h.OWNER_SITE_CITY              L1_OWNER_SITE_CITY,
       h.OWNER_SITE_PINCODE           L1_OWNER_SITE_PINCODE,
       h.OWNER_SITE_PHONE1            L1_OWNER_SITE_PHONE1,
       h.OWNER_SITE_PHONE2            L1_OWNER_SITE_PHONE2,
       h.OWNER_SITE_PHONE3            L1_OWNER_SITE_PHONE3,
       h.OWNER_SITE_EMAIL1            L1_OWNER_SITE_EMAIL1,
       h.OWNER_SITE_EMAIL2            L1_OWNER_SITE_EMAIL2,
       h.OWNER_GSTIN_NO               L1_OWNER_GSTIN_NO,
       h.OWNER_GST_STATE_CODE         L1_OWNER_GST_STATE_CODE,
       h.OWNER_GST_STATE_NAME         L1_OWNER_GST_STATE_NAME,
       h.OWNER_SITE_WEBSITE           L1_OWNER_SITE_WEBSITE,
       d.LVL,
       d.SEQ,
       D.HSN_SAC_CODE L2_HSN_CODE,
	   D.category2 L2_category2,
	   D.category4 L2_category4,
	   D.RATE L2_RATE,
	   D.MRP L2_MRP,
	   D.cgst_rate L2_cgst_rate,
       D.igst_rate L2_igst_rate,
       D.sgst_rate L2_sgst_rate,
	   D.TOTAL_QTY L2_TOTAL_QTY,
	   D.tax_charge_amount L2_tax_charge_amount,
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
       d.CHARGE_APPLICABLE_ON         L3_CHARGE_APPLICABLE_ON,
       d.CHARGE_BASIS                 L3_CHARGE_BASIS,
       d.CHARGE_AMOUNT                L3_CHARGE_AMOUNT,
       d.CHARGE_NAME                  L3_CHARGE_NAME,
       d.OPERATION_LEVEL              L3_OPERATION_LEVEL,
       d.CHARGE_RATE                  L3_CHARGE_RATE,
       d.DISPLAY_SEQUENCE             L3_DISPLAY_SEQUENCE,
       d.HSN_ORDER_QUANTITY           L4_ORDER_QUANTITY,
       d.HSN_CODE                     L4_HSN_CODE,
       d.HSN_SAC_ID                   L4_HSN_SAC_ID,
       d.HSN_DESCRIPTION              L4_HSN_DESCRIPTION,
       d.HSN_UOM                      L4_HSN_UOM,
       d.HSN_TAXABLE_AMOUNT           L4_TAXABLE_AMOUNT,
       d.HSN_CGST_RATE                L4_CGST_RATE,
       d.HSN_CGST_AMOUNT              L4_CGST_AMOUNT,
       d.HSN_SGST_RATE                L4_SGST_RATE,
       d.HSN_SGST_AMOUNT              L4_SGST_AMOUNT,
       d.HSN_IGST_RATE                L4_IGST_RATE,
       d.HSN_IGST_AMOUNT              L4_IGST_AMOUNT,
       d.HSN_CESS_RATE                L4_CESS_RATE,
       d.HSN_CESS_AMOUNT              L4_CESS_AMOUNT,
       d.SCHEDULE_DATE                L5_SCHEDULE_DATE,
       d.SCHEDULE_ORDER_QUANTITY      L5_SCHEDULE_ORDER_QUANTITY
  FROM (SELECT M.ORDCODE                              ORDCODE,
               ORDDT                                  ORDER_DATE,
               PCODE                                  PCODE,
               DOCNO                                  DOCUMENT_NO,
               M.AGCODE                               AGCODE,
               AG.SLNAME                              AGENT_NAME,
               M.AGRATE                               AGENT_RATE,
               M.TRPCODE                              TRPCODE,
               TP.SLNAME                              TRANSPORTER_NAME,
               INITCAP (
                  CASE
                     WHEN M.STAT = 'P' THEN 'PARTIAL RECEIVED'
                     WHEN M.STAT = 'T' THEN 'TOTAL RECEIVED/CANCELLED'
                     WHEN M.STAT = 'N' THEN 'NEW'
                     ELSE 'TOTAL RECEIVED/CANCELLED'
                  END)
                  INV_STATUS,
               ( (AU.FNAME || ' [') || AU.ENO) || ']' AUTHORIZED_BY,
               M.REM                                  REMARKS,
               ( (CR.FNAME || ' [') || CR.ENO) || ']' CREATED_BY,
               TIME                                   CREATED_ON,
               M.DTFR                                 VALID_FROM,
               M.DTTO                                 VALID_TILL,
               LAST_ACCESS_TIME                       LAST_ACCESSED_ON,
               ( (LA.FNAME || ' [') || LA.ENO) || ']' LAST_ACCESSED_BY,
               PAYTERM                                TERMS,
               INITCAP (
                  CASE
                     WHEN M.WHETHER_CONSIGNMENT = 'Y' THEN 'YES'
                     WHEN M.WHETHER_CONSIGNMENT = 'N' THEN 'NO'
                  END)
                  TYPE,
               SCHEME_DOCNO                           ORDER_NO,
               M.ADMOU_CODE                           ADMOU_CODE,
               ( (MR.FNAME || ' [') || MR.ENO) || ']' MERCHANDISER,
               TR.NAME                                TRADE_GROUP_NAME,
               GRSAMT                                 INV_GROSS_AMOUNT,
               CHGAMT                                 INV_CHARGE_AMOUNT,
               NETAMT                                 NET_AMOUNT,
               CUR.SHORTCODE                          CURRENCY,
               DECIMAL_SYMBOL                         CURRENCY_DECIMAL_SYMBOL,
               SYMBOL                                 CURRENCY_SYMBOL,
               EXRATE                                 CURRENCY_EXCHANGE_RATE,
               ADMSITE_CODE                           ADMSITE_CODE,
               INITCAP (
                  CASE
                     WHEN M.ENABLE_LGT_TRACK = 0 THEN 'NO'
                     WHEN M.ENABLE_LGT_TRACK = 1 THEN 'YES'
                     ELSE 'NO'
                  END)
                  SHIPMENT_TRACKING_APPLICABLE,
               TRM.NAME                               PURCHASE_TERM_NAME,
               M.UDFSTRING01                          PURORDMAIN_UDFSTRIN01,
               M.UDFSTRING02                          PURORDMAIN_UDFSTRIN02,
               M.UDFSTRING03                          PURORDMAIN_UDFSTRIN03,
               M.UDFSTRING04                          PURORDMAIN_UDFSTRIN04,
               M.UDFSTRING05                          PURORDMAIN_UDFSTRIN05,
               M.UDFSTRING06                          PURORDMAIN_UDFSTRIN06,
               M.UDFSTRING07                          PURORDMAIN_UDFSTRIN07,
               M.UDFSTRING08                          PURORDMAIN_UDFSTRIN08,
               M.UDFSTRING09                          PURORDMAIN_UDFSTRIN09,
               M.UDFSTRING10                          PURORDMAIN_UDFSTRIN010,
               M.UDFNUM01                             PURORDMAIN_UDFNUM01,
               M.UDFNUM02                             PURORDMAIN_UDFNUM02,
               M.UDFNUM03                             PURORDMAIN_UDFNUM03,
               M.UDFNUM04                             PURORDMAIN_UDFNUM04,
               M.UDFNUM05                             PURORDMAIN_UDFNUM05,
               M.UDFDATE01                            PURORDMAIN_UDFDATE01,
               M.UDFDATE02                            PURORDMAIN_UDFDATE02,
               M.UDFDATE03                            PURORDMAIN_UDFDATE03,
               M.UDFDATE04                            PURORDMAIN_UDFDATE04,
               M.UDFDATE05                            PURORDMAIN_UDFDATE05,
               AUTHORIZATIONTIME                      AUTHORIZED_ON,
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
               ou.NAME                                ORGUNIT_NAME,
               ou.WEBSITE                             ORGUNIT_WEBSITE,
               ou.CINNO                               ORGUNIT_CIN,
               os.NAME                                OWNER_SITE_NAME,
               os.SHORT_CODE                          OWNER_SHORT_CODE,
               os.ADDRESS                             OWNER_SITE_ADDRESS,
               os.CITY                                OWNER_SITE_CITY,
               os.PINCODE                             OWNER_SITE_PINCODE,
               os.PHONE1                              OWNER_SITE_PHONE1,
               os.PHONE2                              OWNER_SITE_PHONE2,
               os.PHONE3                              OWNER_SITE_PHONE3,
               os.EMAIL1                              OWNER_SITE_EMAIL1,
               os.EMAIL2                              OWNER_SITE_EMAIL2,
               OS.GST_IDENTIFICATION_NO               OWNER_GSTIN_NO,
               OS.GST_STATE_CODE                      OWNER_GST_STATE_CODE,
               OS.GST_STATE_NAME                      OWNER_GST_STATE_NAME,
               os.website                             OWNER_SITE_WEBSITE
          FROM PURORDMAIN M
               INNER JOIN ADMYEAR Y ON (M.YCODE = Y.YCODE)
               INNER JOIN HRDEMP CR ON (M.ECODE = CR.ECODE)
               INNER JOIN FINTRADEGRP TR ON (M.FINTRADEGRP_CODE = TR.CODE)
               INNER JOIN ADMCURRENCY CUR ON (M.ADMCURRENCY_CODE = CUR.CODE)
               INNER JOIN ADMOU OU ON (M.ADMOU_CODE = OU.CODE)
               INNER JOIN site_data os ON (M.admsite_code = os.sitecode)
               LEFT OUTER JOIN FINSL AG ON (M.AGCODE = AG.SLCODE)
               LEFT OUTER JOIN FINSL TP ON (M.TRPCODE = TP.SLCODE)
               LEFT OUTER JOIN HRDEMP AU ON (AUTHORCODE = AU.ECODE)
               LEFT OUTER JOIN HRDEMP LA ON (LAST_ACCESS_ECODE = LA.ECODE)
               LEFT OUTER JOIN HRDEMP MR ON (MRCHNDSRCODE = MR.ECODE)
               LEFT OUTER JOIN PURTERMMAIN TRM ON (PURTERMCODE = TRM.CODE)
               INNER JOIN
               (SELECT S.SLNAME              cust_NAME,
                       S.SLCODE,
                       S.BADDR               cust_BILLING_ADDRESS,
                       S.BCP                 cust_BILLING_CONTACT_PERSON,
                       S.BCTNAME             cust_BILLING_CITY,
                       BCT.STNAME            cust_BILLING_STATE,
                       BCT.DIST              cust_BILLING_DISTRICT,
                       BCT.ZONE              cust_BILLING_ZONE,
                       S.BEMAIL              cust_BILLING_EMAIL1,
                       S.BEMAIL2             cust_BILLING_EMAIL2,
                       S.BFX1                cust_BILLING_FAX,
                       S.BFX2                cust_BILLING_MOBILE,
                       S.BPH1                cust_BILLING_OFFICE_PHONE1,
                       S.BPH2                cust_BILLING_OFFICE_PHONE2,
                       S.BPH3                cust_BILLING_OFFICE_PHONE3,
                       S.BPIN                cust_BILLING_PINCODE,
                       S.BWEBSITE            cust_BILLING_WEBSITE,
                       S.CP_GSTIN_NO         CUST_GSTIN_NO,
                       GTE.NAME              CUST_GST_STATE_NAME,
                       S.CP_GSTIN_STATE_CODE CUST_GST_STATE_CODE,
                       S.CRDAYS              CUST_CREDIT_DAYS,
                       S.SLID                CUST_IDENTITY_NO
                  FROM FINSL S
                       LEFT OUTER JOIN ADMCITY BCT ON S.BCTNAME = BCT.CTNAME
                       LEFT OUTER JOIN ADMGSTSTATE GTE
                          ON S.CP_GSTIN_STATE_CODE = GTE.CODE) CUS
                  ON (M.PCODE = CUS.SLCODE)
         WHERE (ordcode in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)) H
       INNER JOIN
       (                                                       /*Detail Part*/
        SELECT 'L2#DETAIL'                LVL,
               1                       SEQ,
               ORDCODE,
               HSN_SAC_CODE,
			   category2,
			   category4,
			   RATE,
			   MRP,
			   cgst_rate,
	           igst_rate,
	           sgst_rate,
			   TOTAL_QTY,
			   tax_charge_amount,
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
               NULL                    CHARGE_APPLICABLE_ON,
               NULL                    CHARGE_BASIS,
               NULL                    CHARGE_AMOUNT,
               NULL                    CHARGE_NAME,
               NULL                    OPERATION_LEVEL,
               NULL                    CHARGE_RATE,
               NULL                    DISPLAY_SEQUENCE,
               NULL                    HSN_ORDER_QUANTITY,
               NULL                    HSN_CODE,
               NULL                    HSN_SAC_ID,
               NULL                    HSN_DESCRIPTION,
               NULL                    HSN_UOM,
               NULL                    HSN_TAXABLE_AMOUNT,
               NULL                    HSN_CGST_RATE,
               NULL                    HSN_CGST_AMOUNT,
               NULL                    HSN_SGST_RATE,
               NULL                    HSN_SGST_AMOUNT,
               NULL                    HSN_IGST_RATE,
               NULL                    HSN_IGST_AMOUNT,
               NULL                    HSN_CESS_RATE,
               NULL                    HSN_CESS_AMOUNT,
               NULL                    SCHEDULE_DATE,
               NULL                    SCHEDULE_ORDER_QUANTITY
          FROM (select
			ORDCODE,
			HSN_CODE HSN_SAC_CODE,
			category2,
			category4,
			RATE,
			MRP,
			cgst_rate,
            igst_rate,
            sgst_rate,
			SUM (QTY) TOTAL_QTY,
			SUM (tax_charge_amount) tax_charge_amount,
			SUM (TAXABLE_AMOUNT) TAXABLE_AMOUNT,
			SUM (ITEM_NET_AMOUNT) ITEM_NET_AMOUNT,
			SUM (case when SEQ = 1 then QTY	else 0 end) SIZE1,
			SUM (case when SEQ = 2 then QTY else 0 end) SIZE2,
			SUM (case when SEQ = 3 then QTY else 0 end) SIZE3,
			SUM (case when SEQ = 4 then QTY else 0 end) SIZE4,
			SUM (case when SEQ = 5 then QTY else 0 end) SIZE5,
			SUM (case when SEQ = 6 then QTY else 0 end) SIZE6,
			SUM (case when SEQ = 7 then QTY else 0 end) SIZE7,
			SUM (case when SEQ = 8 then QTY else 0 end) SIZE8
		from
			(
			select
				M.ORDCODE,
				I.HSN_CODE,
				i.category2,
				i.category4,
				dense_rank ()
                   over (
                      partition by M.ORDCODE
			order by
				TRIM (I.CATEGORY3))
                      SEQ,
				SUM (coalesce (M.ORDQTY,0)) QTY,
				M.RATE,
				I.MRP,
				SUM (TAX.TAXABLE_AMOUNT) TAXABLE_AMOUNT,
				SUM (COALESCE (M.NETAMT, 0)) + SUM (COALESCE (TAX.TAX_CHARGE_AMOUNT, 0)) + SUM (COALESCE (OTX.OTHER_CHARGE_AMOUNT, 0)) ITEM_NET_AMOUNT,
                SUM(TAX.tax_charge_amount) tax_charge_amount,
                TAX.cgst_rate,
                TAX.igst_rate,
                TAX.sgst_rate
			FROM (SELECT * FROM PURORDDET WHERE (ordcode in (
											select
												unnest(regexp_matches('@DocumentId@',
												'[^|~|]+',
												'g'))::bigint as col1)
												or coalesce (nullif ('@DocumentId@',
												''),
												'0')::text = 0::text)) M
            LEFT OUTER JOIN (  SELECT PURORDDET_CODE,
                                   SUM (COALESCE (CHGAMT, 0)) OTHER_CHARGE_AMOUNT
                              FROM PURORDCHG_ITEM
                             WHERE     ISTAX = 'N'
                                   AND (ordcode in (
												select
													unnest(regexp_matches('@DocumentId@',
													'[^|~|]+',
													'g'))::bigint as col1)
													or coalesce (nullif ('@DocumentId@',
													''),
													'0')::text = 0::text)
                          GROUP BY PURORDDET_CODE) OTX
                            ON M.CODE = OTX.PURORDDET_CODE
             LEFT OUTER JOIN
                         (  SELECT PURORDDET_CODE,
                                   APPAMT                 TAXABLE_AMOUNT,
                                   SUM (COALESCE (CHGAMT, 0)) TAX_CHARGE_AMOUNT,
                                   SUM (
                                      CASE
                                         WHEN     GST_COMPONENT = 'CGST'
                                              AND ISREVERSE = 'N'
                                         THEN
                                            RATE
                                         ELSE
                                            0
                                      END)
                                      CGST_RATE,
                                   SUM (
                                      CASE
                                         WHEN     GST_COMPONENT = 'SGST'
                                              AND ISREVERSE = 'N'
                                         THEN
                                            RATE
                                         ELSE
                                            0
                                      END)
                                      SGST_RATE,
                                   SUM (
                                      CASE
                                         WHEN     GST_COMPONENT = 'IGST'
                                              AND ISREVERSE = 'N'
                                         THEN
                                            RATE
                                         ELSE
                                            0
                                      END)
                                      IGST_RATE
                              FROM PURORDCHG_ITEM
                             WHERE     istax = 'Y'
                                   AND (ordcode in (
											select
												unnest(regexp_matches('@DocumentId@',
												'[^|~|]+',
												'g'))::bigint as col1)
												or coalesce (nullif ('@DocumentId@',
												''),
												'0')::text = 0::text)
                          GROUP BY PURORDDET_CODE, APPAMT) TAX
                            ON M.CODE = TAX.PURORDDET_CODE
                inner join ginview.lv_item i on m.icode = i.code
			group by
				M.ORDCODE,
				I.HSN_CODE,
				i.category2,
				i.category4,
				M.RATE,
				I.MRP,
				TRIM (I.CATEGORY3),
				TAX.cgst_rate,
                TAX.igst_rate,
                TAX.sgst_rate)
		group by
			ORDCODE,
			HSN_CODE,
			category2,
			category4,
			RATE,
			MRP,
			cgst_rate,
            igst_rate,
            sgst_rate) D
        UNION ALL
        /*Charge Part*/
        SELECT 'L3#CHARGE' LVL,
               2        SEQ,
               ORDCODE,
               null HSN_SAC_CODE,
			   null category2,
			   null category4,
			   0 RATE,
			   0 MRP,
			   0 cgst_rate,
	           0 igst_rate,
	           0 sgst_rate,
			   0 TOTAL_QTY,
			   0 tax_charge_amount,
			   0 TAXABLE_AMOUNT,
			   0 ITEM_NET_AMOUNT,
			   0 SIZE1,
			   0 SIZE2,
		       0 SIZE3,
			   0 SIZE4,
			   0 SIZE5,
			   0 SIZE6,
			   0 SIZE7,
			   0 SIZE8,
               APPAMT   CHARGE_APPLICABLE_ON,
               INITCAP (
                  CASE
                     WHEN A.BASIS = 'P' THEN 'PERCENTAGE'
                     WHEN A.BASIS = 'A' THEN 'AMOUNT'
                  END)
                  CHARGE_BASIS,
               CHGAMT   CHARGE_AMOUNT,
               CHGNAME  CHARGE_NAME,
               INITCAP (
                  CASE
                     WHEN A.OPERATION_LEVEL = 'H' THEN 'HEADER'
                     WHEN A.OPERATION_LEVEL = 'L' THEN 'LINE'
                  END)
                  OPERATION_LEVEL,
               A.RATE   CHARGE_RATE,
               SEQ      DISPLAY_SEQUENCE,
               null::numeric     HSN_ORDER_QUANTITY,
               NULL     HSN_CODE,
               NULL     HSN_SAC_ID,
               NULL     HSN_DESCRIPTION,
               NULL     HSN_UOM,
               NULL::numeric     HSN_TAXABLE_AMOUNT,
               NULL::numeric     HSN_CGST_RATE,
               NULL::numeric     HSN_CGST_AMOUNT,
               NULL::numeric     HSN_SGST_RATE,
               NULL::numeric     HSN_SGST_AMOUNT,
               NULL::numeric     HSN_IGST_RATE,
               NULL::numeric     HSN_IGST_AMOUNT,
               NULL::numeric     HSN_CESS_RATE,
               NULL::numeric     HSN_CESS_AMOUNT,
               null::date     SCHEDULE_DATE,
               NULL::numeric     ORDER_QUANTITY
          FROM PURORDCHG A INNER JOIN FINCHG B ON (A.CHGCODE = B.CHGCODE)
         WHERE (ordcode in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)
        UNION ALL
          /*HSN Part*/
          SELECT 'L4#HSN'              LVL,
                 3                  SEQ,
                 ORDCODE,
                 null HSN_SAC_CODE,
			   null category2,
			   null category4,
			   0 RATE,
			   0 MRP,
			   0 cgst_rate,
	           0 igst_rate,
	           0 sgst_rate,
			   0 TOTAL_QTY,
			   0 tax_charge_amount,
			   0 TAXABLE_AMOUNT,
			   0 ITEM_NET_AMOUNT,
			   0 SIZE1,
			   0 SIZE2,
		       0 SIZE3,
			   0 SIZE4,
			   0 SIZE5,
			   0 SIZE6,
			   0 SIZE7,
			   0 SIZE8,
                 NULL               CHARGE_APPLICABLE_ON,
                 NULL               CHARGE_BASIS,
                 NULL               CHARGE_AMOUNT,
                 NULL               CHARGE_NAME,
                 NULL               OPERATION_LEVEL,
                 NULL               CHARGE_RATE,
                 NULL               DISPLAY_SEQUENCE,
                 SUM (D.ORDQTY)     HSN_ORDER_QUANTITY,
                 H.GOVT_IDENTIFIER  HSN_CODE,
                 H.HSN_SAC_CODE     HSN_SAC_ID,
                 H.DESCRIPTION      HSN_DESCRIPTION,
                 I.UNITNAME         HSN_UOM,
                 SUM (TAXABLE_AMOUNT) HSN_TAXABLE_AMOUNT,
                 CGST_RATE          HSN_CGST_RATE,
                 SUM (CGST_AMOUNT)  HSN_CGST_AMOUNT,
                 SGST_RATE          HSN_SGST_RATE,
                 SUM (SGST_amount)  HSN_SGST_AMOUNT,
                 IGST_RATE          HSN_IGST_RATE,
                 SUM (IGST_amount)  HSN_IGST_AMOUNT,
                 CESS_RATE          HSN_CESS_RATE,
                 SUM (CESS_amount)  HSN_CESS_AMOUNT,
                 NULL               SCHEDULE_DATE,
                 NULL               ORDER_QUANTITY
            FROM (SELECT *
                    FROM PURORDDET
                   WHERE (ordcode in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)) D
                 INNER JOIN INVITEM I ON D.ICODE = I.ICODE
                 INNER JOIN INVHSNSACMAIN H ON I.INVHSNSACMAIN_CODE = H.CODE
                 LEFT OUTER JOIN
                 (  SELECT PURORDDET_CODE,
                           APPAMT TAXABLE_AMOUNT,
                           SUM (
                              CASE
                                 WHEN GST_COMPONENT = 'CGST' AND ISREVERSE = 'N'
                                 THEN
                                    RATE
                                 ELSE
                                    0
                              END)
                              CGST_RATE,
                           SUM (
                              CASE
                                 WHEN GST_COMPONENT = 'CGST' AND ISREVERSE = 'N'
                                 THEN
                                    CHGAMT
                                 ELSE
                                    0
                              END)
                              CGST_AMOUNT,
                           SUM (
                              CASE
                                 WHEN GST_COMPONENT = 'SGST' AND ISREVERSE = 'N'
                                 THEN
                                    RATE
                                 ELSE
                                    0
                              END)
                              SGST_RATE,
                           SUM (
                              CASE
                                 WHEN GST_COMPONENT = 'SGST' AND ISREVERSE = 'N'
                                 THEN
                                    CHGAMT
                                 ELSE
                                    0
                              END)
                              SGST_AMOUNT,
                           SUM (
                              CASE
                                 WHEN GST_COMPONENT = 'IGST' AND ISREVERSE = 'N'
                                 THEN
                                    RATE
                                 ELSE
                                    0
                              END)
                              IGST_RATE,
                           SUM (
                              CASE
                                 WHEN GST_COMPONENT = 'IGST' AND ISREVERSE = 'N'
                                 THEN
                                    CHGAMT
                                 ELSE
                                    0
                              END)
                              IGST_AMOUNT,
                           SUM (
                              CASE
                                 WHEN GST_COMPONENT = 'CESS' AND ISREVERSE = 'N'
                                 THEN
                                    RATE
                                 ELSE
                                    0
                              END)
                              CESS_Rate,
                           SUM (
                              CASE
                                 WHEN GST_COMPONENT = 'CESS' AND ISREVERSE = 'N'
                                 THEN
                                    CHGAMT
                                 ELSE
                                    0
                              END)
                              CESS_AMOUNT
                      FROM PURORDCHG_ITEM
                     WHERE     SOURCE = 'G'
                           AND (ordcode in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)
                  GROUP BY PURORDDET_CODE, APPAMT) TAX
                    ON D.CODE = TAX.PURORDDET_CODE
           WHERE (ordcode in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)
        GROUP BY D.ORDCODE,
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
        UNION ALL
        /*Schedule Part*/
        SELECT 'L5#SCHEDULE' LVL,
               4          SEQ,
               ORDCODE,
               null HSN_SAC_CODE,
			   null category2,
			   null category4,
			   0 RATE,
			   0 MRP,
			   0 cgst_rate,
	           0 igst_rate,
	           0 sgst_rate,
			   0 TOTAL_QTY,
			   0 tax_charge_amount,
			   0 TAXABLE_AMOUNT,
			   0 ITEM_NET_AMOUNT,
			   0 SIZE1,
			   0 SIZE2,
		       0 SIZE3,
			   0 SIZE4,
			   0 SIZE5,
			   0 SIZE6,
			   0 SIZE7,
			   0 SIZE8,
               NULL       CHARGE_APPLICABLE_ON,
               NULL       CHARGE_BASIS,
               NULL       CHARGE_AMOUNT,
               NULL       CHARGE_NAME,
               NULL       OPERATION_LEVEL,
               NULL       CHARGE_RATE,
               NULL       DISPLAY_SEQUENCE,
               NULL       HSN_ORDER_QUANTITY,
               NULL       HSN_CODE,
               NULL       HSN_SAC_ID,
               NULL       HSN_DESCRIPTION,
               NULL       HSN_UOM,
               NULL       HSN_TAXABLE_AMOUNT,
               NULL       HSN_CGST_RATE,
               NULL       HSN_CGST_AMOUNT,
               NULL       HSN_SGST_RATE,
               NULL       HSN_SGST_AMOUNT,
               NULL       HSN_IGST_RATE,
               NULL       HSN_IGST_AMOUNT,
               NULL       HSN_CESS_RATE,
               NULL       HSN_CESS_AMOUNT,
               SCHEDULEDT SCHEDULE_DATE,
               ORDQTY     ORDER_QUANTITY
          FROM PURORDSCHEDULE
         WHERE (ordcode in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)) D
          ON (H.ORDCODE = D.ORDCODE)