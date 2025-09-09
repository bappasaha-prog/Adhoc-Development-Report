/*|| Custom Development || Object : CQ_SAL_TROUT_DOC || Ticket Id :  420262,420293 || Developer : Dipankar ||*/

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
SELECT ginview.fnc_uk()                  uk,
       H.INVCODE                       L1_INVCODE,
       H.INVOICE_DATE                  L1_INVOICE_DATE,
       H.PCODE                         L1_PCODE,
       H.DOCUMENT_NO                   L1_DOCUMENT_NO,
       H.DUE_DATE                      L1_DUE_DATE,
       H.AGCODE                        L1_AGCODE,
       H.AGENT_NAME                    L1_AGENT_NAME,
       H.AGENT_RATE                    L1_AGENT_RATE,
       H.GROSS_AMOUNT                  L1_GROSS_AMOUNT,
       H.NET_AMOUNT                    L1_NET_AMOUNT,
       H.REMARKS                       L1_REMARKS,
       H.INVOICE_CREATED_BY            L1_INVOICE_CREATED_BY,
       H.INVOICE_CREATED_ON            L1_INVOICE_CREATED_ON,
       H.SALES_TERM                    L1_SALES_TERM,
       H.LAST_ACCESSED_ON              L1_LAST_ACCESSED_ON,
       H.LAST_ACCESSED_BY              L1_LAST_ACCESSED_BY,
       H.LGTCODE                       L1_LGTCODE,
       H.LOGISTIC_NO                   L1_LOGISTIC_NO,
       H.LOGISTIC_DATE                 L1_LOGISTIC_DATE,
       H.LOGISTIC_TRANSPORTER          L1_LOGISTIC_TRANSPORTER,
       H.LOGISTIC_DECLARED_AMOUNT      L1_LOGISTIC_DECLARED_AMOUNT,
       H.DOCUMENT_DATE                 L1_DOCUMENT_DATE,
       H.INVOICE_NO                    L1_INVOICE_NO,
       H.TRPCODE                       L1_TRPCODE,
       H.TRANSPORTER_NAME              L1_TRANSPORTER_NAME,
       H.TRANSIT_DAYS                  L1_TRANSIT_DAYS,
       H.ADMOU_CODE                    L1_ADMOU_CODE,
       H.ADMSITE_CODE                  L1_ADMSITE_CODE,
       H.AUTHORIZED_BY                 L1_AUTHORIZED_BY,
       H.AUTHORIZED_ON                 L1_AUTHORIZED_ON,
       H.ADMSITE_CODE_OWNER            L1_ADMSITE_CODE_OWNER,
       H.SALINMAIN_UDFSTRING01         L1_SALINMAIN_UDFSTRING01,
       H.SALINMAIN_UDFSTRING02         L1_SALINMAIN_UDFSTRING02,
       H.SALINMAIN_UDFSTRING03         L1_SALINMAIN_UDFSTRING03,
       H.SALINMAIN_UDFSTRING04         L1_SALINMAIN_UDFSTRING04,
       H.SALINMAIN_UDFSTRING05         L1_SALINMAIN_UDFSTRING05,
       H.SALINMAIN_UDFSTRING06         L1_SALINMAIN_UDFSTRING06,
       H.SALINMAIN_UDFSTRING07         L1_SALINMAIN_UDFSTRING07,
       H.SALINMAIN_UDFSTRING08         L1_SALINMAIN_UDFSTRING08,
       H.SALINMAIN_UDFSTRING09         L1_SALINMAIN_UDFSTRING09,
       H.SALINMAIN_UDFSTRING10         L1_SALINMAIN_UDFSTRING10,
       H.SALINVMAIN_UDFNUM01           L1_SALINVMAIN_UDFNUM01,
       H.SALINVMAIN_UDFNUM02           L1_SALINVMAIN_UDFNUM02,
       H.SALINVMAIN_UDFNUM03           L1_SALINVMAIN_UDFNUM03,
       H.SALINVMAIN_UDFNUM04           L1_SALINVMAIN_UDFNUM04,
       H.SALINVMAIN_UDFNUM05           L1_SALINVMAIN_UDFNUM05,
       H.SALINVMAIN_UDFDATE01          L1_SALINVMAIN_UDFDATE01,
       H.SALINVMAIN_UDFDATE02          L1_SALINVMAIN_UDFDATE02,
       H.SALINVMAIN_UDFDATE03          L1_SALINVMAIN_UDFDATE03,
       H.SALINVMAIN_UDFDATE04          L1_SALINVMAIN_UDFDATE04,
       H.SALINVMAIN_UDFDATE05          L1_SALINVMAIN_UDFDATE05,
       H.RELEASE_STATUS                L1_RELEASE_STATUS,
       H.RELEASE_ON                    L1_RELEASE_ON,
       H.RELEASE_BY                    L1_RELEASE_BY,
       H.TRADE_GROUP_NAME              L1_TRADE_GROUP_NAME,
       H.PRICE_LIST_NAME               L1_PRICE_LIST_NAME,
       H.PRICE_ROUND_OFF               L1_PRICE_ROUND_OFF,
       H.PRICE_ROUND_OFF_LIMIT         L1_PRICE_ROUND_OFF_LIMIT,
       H.PRICE_INCLUSION_OF_TAX        L1_PRICE_INCLUSION_OF_TAX,
       H.PRICE_MODE                    L1_PRICE_MODE,
       H.PRICE_BASIS                   L1_PRICE_BASIS,
       H.OWNER_GSTIN_NO                L1_OWNER_GSTIN_NO,
       H.OWNER_GSTIN_STATE_CODE        L1_OWNER_GSTIN_STATE_CODE,
       H.OWNER_GSTIN_STATE_NAME        L1_OWNER_GSTIN_STATE_NAME,
       H.CP_GSTIN_NO                   L1_CP_GSTIN_NO,
       H.CP_GSTIN_STATE_CODE           L1_CP_GSTIN_STATE_CODE,
       H.CP_GSTIN_STATE_NAME           L1_CP_GSTIN_STATE_NAME,
       H.E_WAY_BILL_NO                 L1_E_WAY_BILL_NO,
       H.E_WAY_BILL_GENERATED_ON       L1_E_WAY_BILL_GENERATED_ON,
       H.E_WAY_BILL_VALID_UPTO         L1_E_WAY_BILL_VALID_UPTO,
       H.E_INVOICE_IRN                 L1_E_INVOICE_IRN,
       H.E_INVOICE_ACK_DATETIME        L1_E_INVOICE_ACK_DATETIME,
       H.E_INVOICE_ACK_NO              L1_E_INVOICE_ACK_NO,
       H.E_INVOICE_SIGNED_QR_DATA      L1_E_INVOICE_SIGNED_QR_DATA,
       H.E_INVOICE_UPDATED_BY          L1_E_INVOICE_UPDATED_BY,
       H.E_INVOICE_UPDATED_ON          L1_E_INVOICE_UPDATED_ON,
       H.SALETYPE                      L1_SALETYPE,
       H.CUST_NAME                     L1_CUST_NAME,
       H.CUST_BILLING_ADDRESS          L1_CUST_BILLING_ADDRESS,
       H.CUST_BILLING_CONTACT_PERSON   L1_CUST_BILLING_CONTACT_PERSON,
       H.CUST_BILLING_CITY             L1_CUST_BILLING_CITY,
       H.CUST_BILLING_STATE            L1_CUST_BILLING_STATE,
       H.CUST_BILLING_DISTRICT         L1_CUST_BILLING_DISTRICT,
       H.CUST_BILLING_ZONE             L1_CUST_BILLING_ZONE,
       H.CUST_BILLING_EMAIL1           L1_CUST_BILLING_EMAIL1,
       H.CUST_BILLING_EMAIL2           L1_CUST_BILLING_EMAIL2,
       H.CUST_BILLING_FAX              L1_CUST_BILLING_FAX,
       H.CUST_BILLING_MOBILE           L1_CUST_BILLING_MOBILE,
       H.CUST_BILLING_OFFICE_PHONE1    L1_CUST_BILLING_OFFICE_PHONE1,
       H.CUST_BILLING_OFFICE_PHONE2    L1_CUST_BILLING_OFFICE_PHONE2,
       H.CUST_BILLING_OFFICE_PHONE3    L1_CUST_BILLING_OFFICE_PHONE3,
       H.CUST_BILLING_PINCODE          L1_CUST_BILLING_PINCODE,
       H.CUST_BILLING_WEBSITE          L1_CUST_BILLING_WEBSITE,
       H.CUST_GSTIN_NO                 L1_CUST_GSTIN_NO,
       H.CUST_GST_STATE_CODE           L1_CUST_GST_STATE_CODE,
       H.CUST_GST_STATE_NAME           L1_CUST_GST_STATE_NAME,
       H.ORGUNIT_NAME                  L1_ORGUNIT_NAME,
       H.ORGUNIT_WEBSITE               L1_ORGUNIT_WEBSITE,
       H.ORGUNIT_CIN                   L1_ORGUNIT_CIN,
       H.OWNER_SITE_NAME               L1_OWNER_SITE_NAME,
       H.OWNER_SHORT_CODE              L1_OWNER_SHORT_CODE,
       H.OWNER_SITE_ADDRESS            L1_OWNER_SITE_ADDRESS,
       H.OWNER_SITE_CITY               L1_OWNER_SITE_CITY,
       H.OWNER_SITE_PINCODE            L1_OWNER_SITE_PINCODE,
       H.OWNER_SITE_PHONE1             L1_OWNER_SITE_PHONE1,
       H.OWNER_SITE_PHONE2             L1_OWNER_SITE_PHONE2,
       H.OWNER_SITE_PHONE3             L1_OWNER_SITE_PHONE3,
       H.OWNER_SITE_EMAIL1             L1_OWNER_SITE_EMAIL1,
       H.OWNER_SITE_EMAIL2             L1_OWNER_SITE_EMAIL2,
       H.OWNER_SITE_WEBSITE            L1_OWNER_SITE_WEBSITE,
       H.REFSITE_NAME                  L1_REFSITE_NAME,
       H.REFSITE_SHORT_CODE            L1_REFSITE_SHORT_CODE,
       H.REFSITE_ADDRESS               L1_REFSITE_ADDRESS,
       H.REFSITE_CITY                  L1_REFSITE_CITY,
       H.REFSITE_PINCODE               L1_REFSITE_PINCODE,
       H.REFSITE_PHONE1                L1_REFSITE_PHONE1,
       H.REFSITE_PHONE2                L1_REFSITE_PHONE2,
       H.REFSITE_PHONE3                L1_REFSITE_PHONE3,
       H.REFSITE_EMAIL1                L1_REFSITE_EMAIL1,
       H.REFSITE_GSTIN_NO              L1_REFSITE_GSTIN_NO,
       H.REFSITE_GST_STATE_CODE        L1_REFSITE_GST_STATE_CODE,
       H.REFSITE_GST_STATE_NAME        L1_REFSITE_GST_STATE_NAME,
       H.REFSITE_SHIPPING_COMPANY_NAME L1_REFSITE_SHIP_COMPANY_NAME,
       H.REFSITE_SHIPPING_ADDRESS      L1_REFSITE_SHIP_ADDRESS,
       H.REFSITE_SHIPPING_CITY         L1_REFSITE_SHIP_CITY,
       H.REFSITE_SHIPPING_PINCODE      L1_REFSITE_SHIP_PINCODE,
       H.REFSITE_SHIPPING_PHONE1       L1_REFSITE_SHIP_PHONE1,
       H.REFSITE_SHIPPING_PHONE2       L1_REFSITE_SHIP_PHONE2,
       H.REFSITE_SHIPPING_PHONE3       L1_REFSITE_SHIP_PHONE3,
       H.REFSITE_SHIPPING_EMAIL1       L1_REFSITE_SHIP_EMAIL1,
       H.REFSITE_SHIP_GSTIN_NO         L1_REFSITE_SHIP_GSTIN_NO,
       H.REFSITE_SHIP_GST_STATE_CODE   L1_REFSITE_SHIP_GST_STATE_CODE,
       H.REFSITE_SHIP_GST_STATE_NAME   L1_REFSITE_SHIP_GST_STATE_NAME,
       TRANSIT_DUE_DATE                L1_TRANSIT_DUE_DATE,
       d.lvl,
       d.seq,
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
       D.DISPLAY_SEQUENCE              L3_DISPLAY_SEQUENCE,
       D.SALES_CHARGE_NAME             L3_SALES_CHARGE_NAME,
       D.CHARGE_RATE                   L3_CHARGE_RATE,
       D.CHARGE_AMOUNT                 L3_CHARGE_AMOUNT,
       D.CHARGE_BASIS                  L3_CHARGE_BASIS,
       D.CHARGE_APPLICABLE_ON          L3_CHARGE_APPLICABLE_ON,
       D.OPERATION_LEVEL               L3_OPERATION_LEVEL,
       D.HSN_INVOICED_QUANTITY         L4_INVOICED_QUANTITY,
       D.HSN_CODE                      L4_HSN_CODE,
       D.HSN_SAC_ID                    L4_HSN_SAC_ID,
       D.HSN_DESCRIPTION               L4_HSN_DESCRIPTION,
       D.HSN_UOM                       L4_HSN_UOM,
       D.HSN_TAXABLE_AMOUNT            L4_TAXABLE_AMOUNT,
       D.HSN_CGST_RATE                 L4_CGST_RATE,
       D.HSN_CGST_AMOUNT               L4_CGST_AMOUNT,
       D.HSN_SGST_RATE                 L4_SGST_RATE,
       D.HSN_SGST_AMOUNT               L4_SGST_AMOUNT,
       D.HSN_IGST_RATE                 L4_IGST_RATE,
       D.HSN_IGST_AMOUNT               L4_IGST_AMOUNT,
       D.HSN_CESS_RATE                 L4_CESS_RATE,
       D.HSN_CESS_AMOUNT               L4_CESS_AMOUNT,
       D.DC_NO                         L5_DC_NO,
       D.DC_DATE                       L5_DC_DATE,
       D.SO_NO                         L5_SO_NO,
       D.SO_DATE                       L5_SO_DATE
  FROM (                                                       /*Header Part*/
        SELECT A.INVCODE                            INVCODE,
               INVDT                                INVOICE_DATE,
               PCODE                                PCODE,
               A.DOCNO                              DOCUMENT_NO,
               DUEDT                                DUE_DATE,
               A.AGCODE                             AGCODE,
               COALESCE (AG.SLNAME, 'No Agent')     AGENT_NAME,
               A.AGRATE                             AGENT_RATE,
               GRSAMT                               GROSS_AMOUNT,
               NETAMT                               NET_AMOUNT,
               A.REM                                REMARKS,
               ( (C.FNAME || ' [') || C.ENO) || ']' INVOICE_CREATED_BY,
               A.TIME                               INVOICE_CREATED_ON,
               SALTERMNAME                          SALES_TERM,
               A.LAST_ACCESS_TIME                   LAST_ACCESSED_ON,
               ( (M.FNAME || ' [') || M.ENO) || ']' LAST_ACCESSED_BY,
               a.lgtcode,
               LGTNO                                LOGISTIC_NO,
               LGTDT                                LOGISTIC_DATE,
               TR.SLNAME                            LOGISTIC_TRANSPORTER,
               DECAMT                               LOGISTIC_DECLARED_AMOUNT,
               A.DOCDT                              DOCUMENT_DATE,
               SCHEME_DOCNO                         INVOICE_NO,
               A.TRPCODE                            TRPCODE,
               TRP.SLNAME                           TRANSPORTER_NAME,
               TRANSITDAYS                          TRANSIT_DAYS,
               A.ADMOU_CODE,
               A.ADMSITE_CODE                       ADMSITE_CODE,
               ( (U.FNAME || ' [') || U.ENO) || ']' AUTHORIZED_BY,
               AUTHORIZE_TIME                       AUTHORIZED_ON,
               A.ADMSITE_CODE_OWNER                 ADMSITE_CODE_OWNER,
               A.UDFSTRING01                        SALINMAIN_UDFSTRING01,
               A.UDFSTRING02                        SALINMAIN_UDFSTRING02,
               A.UDFSTRING03                        SALINMAIN_UDFSTRING03,
               A.UDFSTRING04                        SALINMAIN_UDFSTRING04,
               A.UDFSTRING05                        SALINMAIN_UDFSTRING05,
               A.UDFSTRING06                        SALINMAIN_UDFSTRING06,
               A.UDFSTRING07                        SALINMAIN_UDFSTRING07,
               A.UDFSTRING08                        SALINMAIN_UDFSTRING08,
               A.UDFSTRING09                        SALINMAIN_UDFSTRING09,
               A.UDFSTRING10                        SALINMAIN_UDFSTRING10,
               A.UDFNUM01                           SALINVMAIN_UDFNUM01,
               A.UDFNUM02                           SALINVMAIN_UDFNUM02,
               A.UDFNUM03                           SALINVMAIN_UDFNUM03,
               A.UDFNUM04                           SALINVMAIN_UDFNUM04,
               A.UDFNUM05                           SALINVMAIN_UDFNUM05,
               A.UDFDATE01                          SALINVMAIN_UDFDATE01,
               A.UDFDATE02                          SALINVMAIN_UDFDATE02,
               A.UDFDATE03                          SALINVMAIN_UDFDATE03,
               A.UDFDATE04                          SALINVMAIN_UDFDATE04,
               A.UDFDATE05                          SALINVMAIN_UDFDATE05,
               TRANSIT_DUE_DATE,
               INITCAP (
                  CASE
                     WHEN A.RELEASE_STATUS = 'P' THEN 'POSTED'
                     WHEN A.RELEASE_STATUS = 'U' THEN 'UNPOSTED'
                     WHEN A.RELEASE_STATUS = 'R' THEN 'REVERSED'
                  END)
                  RELEASE_STATUS,
               RELEASE_TIME                         RELEASE_ON,
               ( (R.FNAME || ' [') || R.ENO) || ']' RELEASE_BY,
               P.NAME                               TRADE_GROUP_NAME,
               PRICELISTNAME                        PRICE_LIST_NAME,
               PRICE_ROUNDOFF                       PRICE_ROUND_OFF,
               INITCAP (
                  CASE
                     WHEN COALESCE (A.ROUNDOFF_LIMIT, 'U') = 'U' THEN 'UPPER'
                     WHEN COALESCE (A.ROUNDOFF_LIMIT, 'U') = 'L' THEN 'LOWER'
                     WHEN COALESCE (A.ROUNDOFF_LIMIT, 'U') = 'R' THEN 'ROUND'
                     WHEN COALESCE (A.ROUNDOFF_LIMIT, 'U') = 'N' THEN 'NONE'
                  END)
                  PRICE_ROUND_OFF_LIMIT,
               INITCAP (
                  CASE
                     WHEN COALESCE (A.INCL_VAT_IN_DIST, 'N') = 'Y'
                     THEN
                        'INCLUDE'
                     WHEN COALESCE (A.INCL_VAT_IN_DIST, 'N') = 'N'
                     THEN
                        'DO NOT INCLUDE'
                  END)
                  PRICE_INCLUSION_OF_TAX,
               INITCAP (
                  CASE
                     WHEN COALESCE (A.DISCOUNT_MODE, 'U') = 'U'
                     THEN
                        'MARKUP'
                     WHEN COALESCE (A.DISCOUNT_MODE, 'U') = 'D'
                     THEN
                        'MARKDOWN'
                  END)
                  PRICE_MODE,
               INITCAP (
                  CASE
                     WHEN COALESCE (A.DISCOUNT_BASIS, 'B') = 'B'
                     THEN
                        'ON BASE PRICE'
                     WHEN COALESCE (A.DISCOUNT_BASIS, 'B') = 'N'
                     THEN
                        'ON NET PRICE'
                  END)
                  PRICE_BASIS,
               OWNER_GSTIN_NO                       OWNER_GSTIN_NO,
               OWNER_GSTIN_STATE_CODE               OWNER_GSTIN_STATE_CODE,
               GST.NAME                             OWNER_GSTIN_STATE_NAME,
               A.CP_GSTIN_NO                        CP_GSTIN_NO,
               A.CP_GSTIN_STATE_CODE                CP_GSTIN_STATE_CODE,
               CPGST.NAME                           CP_GSTIN_STATE_NAME,
               EWAYBILLNO                           E_WAY_BILL_NO,
               EWAYBILLGENERATEDON                  E_WAY_BILL_GENERATED_ON,
               EWAYBILLVALIDUPTO                    E_WAY_BILL_VALID_UPTO,
               E_INVOICE_IRN,
               E_INVOICE_ACK_DATETIME,
               E_INVOICE_ACK_NO,
               E_INVOICE_SIGNED_QR_DATA,
               E_INVOICE_UPDATED_BY,
               E_INVOICE_UPDATED_ON,
               CASE A.saletype
                  WHEN 'O' THEN 'SALES INVOICE'
                  WHEN 'C' THEN 'TRANSFER OUT'
               END
                  SALETYPE,
               cust_NAME,
               cust_BILLING_ADDRESS,
               cust_BILLING_CONTACT_PERSON,
               cust_BILLING_CITY,
               cust_BILLING_STATE,
               cust_BILLING_DISTRICT,
               cust_BILLING_ZONE,
               cust_BILLING_EMAIL1,
               cust_BILLING_EMAIL2,
               cust_BILLING_FAX,
               cust_BILLING_MOBILE,
               cust_BILLING_OFFICE_PHONE1,
               cust_BILLING_OFFICE_PHONE2,
               cust_BILLING_OFFICE_PHONE3,
               cust_BILLING_PINCODE,
               cust_BILLING_WEBSITE,
               CUST_GSTIN_NO,
               cust_GST_STATE_CODE,
               cust_GST_STATE_NAME,
               ou.NAME                              ORGUNIT_NAME,
               ou.WEBSITE                           ORGUNIT_WEBSITE,
               ou.CINNO                             ORGUNIT_CIN,
               os.NAME                              OWNER_SITE_NAME,
               os.SHORT_CODE                        OWNER_SHORT_CODE,
               os.ADDRESS                           OWNER_SITE_ADDRESS,
               os.CITY                              OWNER_SITE_CITY,
               os.PINCODE                           OWNER_SITE_PINCODE,
               os.PHONE1                            OWNER_SITE_PHONE1,
               os.PHONE2                            OWNER_SITE_PHONE2,
               os.PHONE3                            OWNER_SITE_PHONE3,
               os.EMAIL1                            OWNER_SITE_EMAIL1,
               os.EMAIL2                            OWNER_SITE_EMAIL2,
               os.website                           OWNER_SITE_WEBSITE,
               rs.NAME                              REFSITE_NAME,
               rs.SHORT_CODE                        REFSITE_SHORT_CODE,
               rs.ADDRESS                           REFSITE_ADDRESS,
               rs.CITY                              REFSITE_CITY,
               rs.PINCODE                           REFSITE_PINCODE,
               rs.PHONE1                            REFSITE_PHONE1,
               rs.PHONE2                            REFSITE_PHONE2,
               rs.PHONE3                            REFSITE_PHONE3,
               rs.EMAIL1                            REFSITE_EMAIL1,
               rs.GST_IDENTIFICATION_NO             REFSITE_GSTIN_NO,
               rs.GST_STATE_CODE                    REFSITE_GST_STATE_CODE,
               rs.GST_STATE_NAME                    REFSITE_GST_STATE_NAME,
               rs.SHIPPING_COMPANY_NAME
                  REFSITE_SHIPPING_COMPANY_NAME,
               rs.SHIPPING_ADDRESS                  REFSITE_SHIPPING_ADDRESS,
               rs.SHIPPING_CITY                     REFSITE_SHIPPING_CITY,
               rs.SHIPPING_PINCODE                  REFSITE_SHIPPING_PINCODE,
               rs.SHIPPING_PHONE1                   REFSITE_SHIPPING_PHONE1,
               rs.SHIPPING_PHONE2                   REFSITE_SHIPPING_PHONE2,
               rs.SHIPPING_PHONE3                   REFSITE_SHIPPING_PHONE3,
               rs.SHIPPING_EMAIL1                   REFSITE_SHIPPING_EMAIL1,
               rs.SHIPPING_GST_IDENTIFICATION_NO    REFSITE_SHIP_GSTIN_NO,
               rs.SHIPPING_GST_STATE_CODE
                  REFSITE_SHIP_GST_STATE_CODE,
               rs.SHIPPING_GST_STATE_NAME
                  REFSITE_SHIP_GST_STATE_NAME
          FROM SALINVMAIN A
               LEFT OUTER JOIN FINSL AG ON (A.AGCODE = AG.SLCODE)
               LEFT OUTER JOIN FINSL TRP ON (A.TRPCODE = TRP.SLCODE)
               INNER JOIN HRDEMP C ON (A.ECODE = C.ECODE)
               LEFT OUTER JOIN SALTERMMAIN T
                  ON (A.SALTERMCODE = T.SALTERMCODE)
               LEFT OUTER JOIN HRDEMP M ON (A.LAST_ACCESS_ECODE = M.ECODE)
               LEFT OUTER JOIN HRDEMP U ON (AUTHORIZE_ECODE = U.ECODE)
               LEFT OUTER JOIN HRDEMP R ON (RELEASE_ECODE = R.ECODE)
               LEFT OUTER JOIN FINTRADEGRP P ON (A.SALTRADEGRP_CODE = P.CODE)
               LEFT OUTER JOIN SALPRICELISTMAIN PL
                  ON (A.PRICELISTCODE = PL.PRICELISTCODE)
               LEFT OUTER JOIN ADMGSTSTATE GST
                  ON (OWNER_GSTIN_STATE_CODE = GST.CODE)
               LEFT OUTER JOIN ADMGSTSTATE CPGST
                  ON (A.CP_GSTIN_STATE_CODE = CPGST.CODE)
               LEFT OUTER JOIN INVLGTNOTE L ON (A.LGTCODE = L.LGTCODE)
               LEFT OUTER JOIN FINSL TR ON (L.TRPCODE = TR.SLCODE)
               LEFT OUTER JOIN
               (SELECT TRANSACTION_CODE,
                       IRN                              E_INVOICE_IRN,
                       ACK_DATETIME                     E_INVOICE_ACK_DATETIME,
                       ACK_NO                           E_INVOICE_ACK_NO,
                       SIGNED_QR_DATA                   E_INVOICE_SIGNED_QR_DATA,
                       ( (FNAME || ' [') || ENO) || ']' E_INVOICE_UPDATED_BY,
                       UPDATED_ON                       E_INVOICE_UPDATED_ON
                  FROM INVGST_EINVOICE A
                       LEFT OUTER JOIN HRDEMP E ON (UPDATED_BY = ECODE)
                 WHERE TRANSACTION_TABLE = 'SALINVMAIN') EI
                  ON (A.INVCODE::text = EI.TRANSACTION_CODE)
               LEFT OUTER JOIN
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
                       S.CP_GSTIN_STATE_CODE cust_GST_STATE_CODE,
                       GTE.NAME              cust_GST_STATE_NAME
                  FROM FINSL S
                       LEFT OUTER JOIN ADMCITY BCT ON S.BCTNAME = BCT.CTNAME
                       LEFT OUTER JOIN ADMGSTSTATE GTE
                          ON S.CP_GSTIN_STATE_CODE = GTE.CODE) CUS
                  ON (A.PCODE = CUS.SLCODE)
               INNER JOIN admou ou ON (a.admou_code = ou.code)
               INNER JOIN site_data os
                  ON (a.admsite_code_owner = os.sitecode)
               INNER JOIN site_data rs ON (a.admsite_code = Rs.sitecode)
         WHERE (a.INVCODE in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)) H
       INNER JOIN
       (                                                            /*Detail*/
        SELECT 'L2#DETAIL'           LVL,
               1                  SEQ,
               INVCODE,
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
               NULL               DISPLAY_SEQUENCE,
               NULL               SALES_CHARGE_NAME,
               NULL               CHARGE_RATE,
               NULL               CHARGE_AMOUNT,
               NULL               CHARGE_BASIS,
               NULL               CHARGE_APPLICABLE_ON,
               NULL               OPERATION_LEVEL,
               NULL               HSN_INVOICED_QUANTITY,
               NULL               HSN_CODE,
               NULL               HSN_SAC_ID,
               NULL               HSN_DESCRIPTION,
               NULL               HSN_UOM,
               NULL               HSN_TAXABLE_AMOUNT,
               NULL               HSN_CGST_RATE,
               NULL               HSN_CGST_AMOUNT,
               NULL               HSN_SGST_RATE,
               NULL               HSN_SGST_AMOUNT,
               NULL               HSN_IGST_RATE,
               NULL               HSN_IGST_AMOUNT,
               NULL               HSN_CESS_RATE,
               NULL               HSN_CESS_AMOUNT,
               NULL               DC_NO,
               NULL               DC_DATE,
               NULL               SO_NO,
               NULL               SO_DATE
          FROM (select
			INVCODE,
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
				M.INVCODE,
				I.HSN_CODE,
				i.category2,
				i.category4,
				dense_rank ()
                   over (
                      partition by M.INVCODE
			order by
				TRIM (I.CATEGORY3))
                      SEQ,
				SUM (coalesce (M.INVQTY,0)) QTY,
				M.RATE,
				I.MRP,
				SUM (TAX.TAXABLE_AMOUNT) TAXABLE_AMOUNT,
				SUM ( (COALESCE (INVAMT, 0) + COALESCE (CHGAMT, 0)) + COALESCE (TAXAMT, 0))  ITEM_NET_AMOUNT,
                SUM(TAX.tax_charge_amount) tax_charge_amount,
                TAX.cgst_rate,
                TAX.igst_rate,
                TAX.sgst_rate
			FROM (SELECT *
                            FROM SALINVDET
                           WHERE (INVCODE in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)) M
                         LEFT OUTER JOIN
                         (  SELECT SALINVDET_CODE,
                                   APPAMT                 TAXABLE_AMOUNT,
                                   SUM (COALESCE (CHGAMT, 0)) TAX_CHARGE_AMOUNT,
                                   SUM (
                                      CASE
                                         WHEN GST_COMPONENT = 'CGST' THEN RATE
                                         ELSE 0
                                      END)
                                      CGST_RATE,
                                   SUM (
                                      CASE
                                         WHEN GST_COMPONENT = 'SGST' THEN RATE
                                         ELSE 0
                                      END)
                                      SGST_RATE,
                                   SUM (
                                      CASE
                                         WHEN GST_COMPONENT = 'IGST' THEN RATE
                                         ELSE 0
                                      END)
                                      IGST_RATE
                              FROM SALINVCHG_ITEM
                             WHERE     ISTAX = 'Y'
                                   AND (INVCODE in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)
                          GROUP BY SALINVDET_CODE, APPAMT) TAX
                            ON (M.CODE = SALINVDET_CODE)
                            inner join ginview.lv_item i on m.icode = i.code
                   WHERE (INVCODE in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)
			group by
				M.INVCODE,
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
			INVCODE,
			HSN_CODE,
			category2,
			category4,
			RATE,
			MRP,
			cgst_rate,
            igst_rate,
            sgst_rate) d
        UNION ALL
        /*Charge Part*/
        SELECT 'L3#CHARGE'   LVL,
               2          SEQ,
               INVCODE    INVCODE,
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
               SEQ        DISPLAY_SEQUENCE,
               SALCHGNAME SALES_CHARGE_NAME,
               RATE       CHARGE_RATE,
               CHGAMT     CHARGE_AMOUNT,
               INITCAP (
                  CASE
                     WHEN COALESCE (A.BASIS, 'P') = 'P' THEN 'PERCENTAGE'
                     WHEN COALESCE (A.BASIS, 'P') = 'A' THEN 'AMOUNT'
                  END)
                  CHARGE_BASIS,
               APPAMT     CHARGE_APPLICABLE_ON,
               INITCAP (
                  CASE
                     WHEN A.OPERATION_LEVEL = 'H' THEN 'HEADER'
                     WHEN A.OPERATION_LEVEL = 'L' THEN 'LINE'
                  END)
                  OPERATION_LEVEL,
               null::numeric       HSN_INVOICED_QUANTITY,
               NULL       HSN_CODE,
               NULL       HSN_SAC_ID,
               NULL       HSN_DESCRIPTION,
               NULL       HSN_UOM,
               NULL::numeric       HSN_TAXABLE_AMOUNT,
               NULL::numeric       HSN_CGST_RATE,
               NULL::numeric       HSN_CGST_AMOUNT,
               NULL::numeric       HSN_SGST_RATE,
               NULL::numeric       HSN_SGST_AMOUNT,
               NULL::numeric       HSN_IGST_RATE,
               NULL::numeric      HSN_IGST_AMOUNT,
               NULL::numeric       HSN_CESS_RATE,
               NULL::numeric       HSN_CESS_AMOUNT,
               NULL       DC_NO,
               NULL::date       DC_DATE,
               NULL       SO_NO,
               NULL::date       SO_DATE
          FROM SALINVCHG A
               INNER JOIN SALCHG B ON (A.SALCHGCODE = B.SALCHGCODE)
         WHERE (INVCODE in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)
        UNION ALL
          /*HSN PART*/
          SELECT 'L4#HSN'           LVL,
                 3               SEQ,
                 INVCODE,
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
                 NULL            DISPLAY_SEQUENCE,
                 NULL            SALES_CHARGE_NAME,
                 NULL            CHARGE_RATE,
                 NULL            CHARGE_AMOUNT,
                 NULL            CHARGE_BASIS,
                 NULL            CHARGE_APPLICABLE_ON,
                 NULL            OPERATION_LEVEL,
                 SUM (INVQTY)    HSN_INVOICED_QUANTITY,
                 D.HSN_SAC_CODE  HSN_CODE,
                 H.HSN_SAC_CODE  HSN_SAC_ID,
                 DESCRIPTION     HSN_DESCRIPTION,
                 UNITNAME        HSN_UOM,
                 COALESCE (SUM (TAXABLE_AMOUNT), SUM (D.INVAMT))
                    HSN_TAXABLE_AMOUNT,
                 CGST_RATE       HSN_CGST_RATE,
                 SUM (CGST_AMOUNT) HSN_CGST_AMOUNT,
                 SGST_RATE       HSN_SGST_RATE,
                 SUM (SGST_AMOUNT) HSN_SGST_AMOUNT,
                 IGST_RATE       HSN_IGST_RATE,
                 SUM (IGST_AMOUNT) HSN_IGST_AMOUNT,
                 CESS_RATE       HSN_CESS_RATE,
                 SUM (CESS_AMOUNT) HSN_CESS_AMOUNT,
                 NULL            DC_NO,
                 NULL            DC_DATE,
                 NULL            SO_NO,
                 NULL            SO_DATE
            FROM (SELECT *
                    FROM SALINVDET
                   WHERE (INVCODE in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)) D
                 INNER JOIN INVITEM I ON (D.ICODE = I.ICODE)
                 LEFT OUTER JOIN
                 (  SELECT SALINVDET_CODE,
                           APPAMT TAXABLE_AMOUNT,
                           SUM (
                              CASE
                                 WHEN GST_COMPONENT = 'CGST' THEN RATE
                                 ELSE 0
                              END)
                              CGST_RATE,
                           SUM (
                              CASE
                                 WHEN GST_COMPONENT = 'CGST' THEN CHGAMT
                                 ELSE 0
                              END)
                              CGST_AMOUNT,
                           SUM (
                              CASE
                                 WHEN GST_COMPONENT = 'SGST' THEN RATE
                                 ELSE 0
                              END)
                              SGST_RATE,
                           SUM (
                              CASE
                                 WHEN GST_COMPONENT = 'SGST' THEN CHGAMT
                                 ELSE 0
                              END)
                              SGST_AMOUNT,
                           SUM (
                              CASE
                                 WHEN GST_COMPONENT = 'IGST' THEN RATE
                                 ELSE 0
                              END)
                              IGST_RATE,
                           SUM (
                              CASE
                                 WHEN GST_COMPONENT = 'IGST' THEN CHGAMT
                                 ELSE 0
                              END)
                              IGST_AMOUNT,
                           SUM (
                              CASE
                                 WHEN GST_COMPONENT = 'CESS' THEN RATE
                                 ELSE 0
                              END)
                              CESS_RATE,
                           SUM (
                              CASE
                                 WHEN GST_COMPONENT = 'CESS' THEN CHGAMT
                                 ELSE 0
                              END)
                              CESS_AMOUNT
                      FROM SALINVCHG_ITEM
                     WHERE     SOURCE = 'G'
                           AND (INVCODE in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)
                  GROUP BY SALINVDET_CODE, APPAMT) TAX
                    ON (D.CODE = SALINVDET_CODE)
                 INNER JOIN INVHSNSACMAIN H ON (INVHSNSACMAIN_CODE = H.CODE)
           WHERE (INVCODE in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)
        GROUP BY INVCODE,
                 D.HSN_SAC_CODE,
                 H.HSN_SAC_CODE,
                 DESCRIPTION,
                 UNITNAME,
                 CGST_RATE,
                 SGST_RATE,
                 IGST_RATE,
                 CESS_RATE
        UNION ALL
          /*REFDOC PART*/
          SELECT 'L5#REFDOCS'      LVL,
                 4              SEQ,
                 SI.INVCODE,
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
                 NULL           DISPLAY_SEQUENCE,
                 NULL           SALES_CHARGE_NAME,
                 NULL           CHARGE_RATE,
                 NULL           CHARGE_AMOUNT,
                 NULL           CHARGE_BASIS,
                 NULL           CHARGE_APPLICABLE_ON,
                 NULL           OPERATION_LEVEL,
                 NULL           HSN_INVOICED_QUANTITY,
                 NULL           HSN_CODE,
                 NULL           HSN_SAC_ID,
                 NULL           HSN_DESCRIPTION,
                 NULL           HSN_UOM,
                 NULL           HSN_TAXABLE_AMOUNT,
                 NULL           HSN_CGST_RATE,
                 NULL           HSN_CGST_AMOUNT,
                 NULL           HSN_SGST_RATE,
                 NULL           HSN_SGST_AMOUNT,
                 NULL           HSN_IGST_RATE,
                 NULL           HSN_IGST_AMOUNT,
                 NULL           HSN_CESS_RATE,
                 NULL           HSN_CESS_AMOUNT,
                 DCM.SCHEME_DOCNO DC_NO,
                 DCDT           DC_DATE,
                 ORM.SCHEME_DOCNO SO_NO,
                 ORDDT          SO_DATE
            FROM (SELECT *
                    FROM SALINVDET
                   WHERE (INVCODE in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)) SI
                 INNER JOIN INVDCMAIN DCM ON (SI.DCCODE = DCM.DCCODE)
                 INNER JOIN INVDCDET DCD
                    ON (DCD.CODE = INVDCDET_CODE) AND (DCM.DCCODE = DCD.DCCODE)
                 LEFT OUTER JOIN SALORDMAIN ORM ON (DCD.ORDCODE = ORM.ORDCODE)
           WHERE (si.INVCODE in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)
        GROUP BY SI.INVCODE,
                 DCM.SCHEME_DOCNO,
                 DCM.DCDT,
                 ORM.SCHEME_DOCNO,
                 ORM.ORDDT,
                 DCM.REM,
                 DCM.DCBARCODE,
                 ORM.DOCNO,
                 ORM.DOCDT) d
          ON (h.invcode = d.invcode)