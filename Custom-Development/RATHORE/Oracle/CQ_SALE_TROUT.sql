/*|| Custom Development || Object : CQ_SALE_TROUT || Ticket Id :  412577 || Developer : Dipankar ||*/

WITH SITE_DATA
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
                ST.EMAIL1   EMAIL1,
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
                   SHIPPING_COMPANY_NAME,
                CASE
                   WHEN ISBILLINGSHIPPINGSAME = 'Y' THEN ST.ADDRESS
                   ELSE ST.SHIP_ADDRESS
                END
                   SHIPPING_ADDRESS,
                CASE
                   WHEN ISBILLINGSHIPPINGSAME = 'Y' THEN ST.CTNAME
                   ELSE ST.SHIP_CTNAME
                END
                   SHIPPING_CITY,
                CASE
                   WHEN ISBILLINGSHIPPINGSAME = 'Y' THEN ST.PIN
                   ELSE ST.SHIP_PIN
                END
                   SHIPPING_PINCODE,
                CASE
                   WHEN ISBILLINGSHIPPINGSAME = 'Y' THEN ST.OPH1
                   ELSE ST.SHIP_OPH1
                END
                   SHIPPING_PHONE1,
                CASE
                   WHEN ISBILLINGSHIPPINGSAME = 'Y' THEN ST.OPH2
                   ELSE ST.SHIP_OPH2
                END
                   SHIPPING_PHONE2,
                CASE
                   WHEN ISBILLINGSHIPPINGSAME = 'Y' THEN ST.OPH3
                   ELSE ST.SHIP_OPH3
                END
                   SHIPPING_PHONE3,
                CASE
                   WHEN ISBILLINGSHIPPINGSAME = 'Y' THEN ST.EMAIL1
                   ELSE ST.SHIP_EMAIL1
                END
                   SHIPPING_EMAIL1,
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
                   SHIPPING_GST_IDENTIFICATION_NO,
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
                   SHIPPING_GST_STATE_CODE,
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
                   SHIPPING_GST_STATE_NAME,
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
SELECT GINVIEW.FNC_UK                  UK,
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
       D.LVL,
       D.SEQ,
       D.ICODE                         L2_ICODE,
       D.INVOICE_QUANTITY              L2_INVOICE_QUANTITY,
       D.HSN_SAC_CODE                  L2_HSN_SAC_CODE,
       D.INVOICE_RATE                  L2_INVOICE_RATE,
       D.INVOICE_RSP                   L2_INVOICE_RSP,
       D.DETAIL_ITEM_REMARKS           L2_ITEM_REMARKS,
       D.DETAIL_GROSS_AMOUNT           L2_ITEM_GROSS_AMOUNT,
       D.DETAIL_TAX_RATE               L2_ITEM_TAX_RATE,
       D.DETAIL_CHARGE_AMOUNT          L2_ITEM_CHARGE_AMOUNT,
       D.DETAIL_NET_AMOUNT             L2_ITEM_NET_AMOUNT,
       D.DETAIL_TAX_AMOUNT             L2_ITEM_TAX_AMOUNT,
       D.DETAIL_TAXABLE_AMOUNT         L2_TAXABLE_AMOUNT,
       D.DETAIL_CGST_RATE              L2_CGST_RATE,
       D.DETAIL_CGST_AMOUNT            L2_CGST_AMOUNT,
       D.DETAIL_SGST_RATE              L2_SGST_RATE,
       D.DETAIL_SGST_AMOUNT            L2_SGST_AMOUNT,
       D.DETAIL_IGST_RATE              L2_IGST_RATE,
       D.DETAIL_IGST_AMOUNT            L2_IGST_AMOUNT,
       D.LESS_AMOUNT                   L2_LESS_AMOUNT,
       D.PARTER_MARGIN                 L2_PARTER_MARGIN,
       D.DIVISION                      L2_DIVISION,
       D.SECTION                       L2_SECTION,
       D.DEPARTMENT                    L2_DEPARTMENT,
       D.BARCODE                       L2_BARCODE,
       D.ITEM_ARTICLE_NAME             L2_ARTICLE_NAME,
       D.ITEM_CATEGORY1                L2_CATEGORY1,
       D.ITEM_CATEGORY2                L2_CATEGORY2,
       D.ITEM_CATEGORY3                L2_CATEGORY3,
       D.ITEM_CATEGORY4                L2_CATEGORY4,
       D.ITEM_CATEGORY5                L2_CATEGORY5,
       D.ITEM_CATEGORY6                L2_CATEGORY6,
       D.ITEM_UOM                      L2_UOM,
       D.ITEM_RSP                      L2_RSP,
       D.ITEM_WSP                      L2_WSP,
       D.ITEM_MRP                      L2_MRP,
       D.ITEM_STANDARD_RATE            L2_STANDARD_RATE,
       D.ITEM_NAME                     L2_ITEM_NAME,
       D.DISPLAY_SEQUENCE              L3_DISPLAY_SEQUENCE,
       D.SALES_CHARGE_NAME             L3_SALES_CHARGE_NAME,
       D.CHARGE_RATE                   L3_CHARGE_RATE,
       D.CHARGE_AMOUNT                 L3_CHARGE_AMOUNT,
       D.CHARGE_BASIS                  L3_CHARGE_BASIS,
       D.CHARGE_APPLICABLE_ON          L3_CHARGE_APPLICABLE_ON,
       D.OPERATION_LEVEL               L3_OPERATION_LEVEL
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
               A.LGTCODE,
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
               CASE A.SALETYPE
                  WHEN 'O' THEN 'SALES INVOICE'
                  WHEN 'C' THEN 'TRANSFER OUT'
               END
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
               CUST_GST_STATE_CODE,
               CUST_GST_STATE_NAME,
               OU.NAME                              ORGUNIT_NAME,
               OU.WEBSITE                           ORGUNIT_WEBSITE,
               OU.CINNO                             ORGUNIT_CIN,
               OS.NAME                              OWNER_SITE_NAME,
               OS.SHORT_CODE                        OWNER_SHORT_CODE,
               OS.ADDRESS                           OWNER_SITE_ADDRESS,
               OS.CITY                              OWNER_SITE_CITY,
               OS.PINCODE                           OWNER_SITE_PINCODE,
               OS.PHONE1                            OWNER_SITE_PHONE1,
               OS.PHONE2                            OWNER_SITE_PHONE2,
               OS.PHONE3                            OWNER_SITE_PHONE3,
               OS.EMAIL1                            OWNER_SITE_EMAIL1,
               OS.EMAIL2                            OWNER_SITE_EMAIL2,
               OS.WEBSITE                           OWNER_SITE_WEBSITE,
               RS.NAME                              REFSITE_NAME,
               RS.SHORT_CODE                        REFSITE_SHORT_CODE,
               RS.ADDRESS                           REFSITE_ADDRESS,
               RS.CITY                              REFSITE_CITY,
               RS.PINCODE                           REFSITE_PINCODE,
               RS.PHONE1                            REFSITE_PHONE1,
               RS.PHONE2                            REFSITE_PHONE2,
               RS.PHONE3                            REFSITE_PHONE3,
               RS.EMAIL1                            REFSITE_EMAIL1,
               RS.GST_IDENTIFICATION_NO             REFSITE_GSTIN_NO,
               RS.GST_STATE_CODE                    REFSITE_GST_STATE_CODE,
               RS.GST_STATE_NAME                    REFSITE_GST_STATE_NAME,
               RS.SHIPPING_COMPANY_NAME
                  REFSITE_SHIPPING_COMPANY_NAME,
               RS.SHIPPING_ADDRESS                  REFSITE_SHIPPING_ADDRESS,
               RS.SHIPPING_CITY                     REFSITE_SHIPPING_CITY,
               RS.SHIPPING_PINCODE                  REFSITE_SHIPPING_PINCODE,
               RS.SHIPPING_PHONE1                   REFSITE_SHIPPING_PHONE1,
               RS.SHIPPING_PHONE2                   REFSITE_SHIPPING_PHONE2,
               RS.SHIPPING_PHONE3                   REFSITE_SHIPPING_PHONE3,
               RS.SHIPPING_EMAIL1                   REFSITE_SHIPPING_EMAIL1,
               RS.SHIPPING_GST_IDENTIFICATION_NO    REFSITE_SHIP_GSTIN_NO,
               RS.SHIPPING_GST_STATE_CODE
                  REFSITE_SHIP_GST_STATE_CODE,
               RS.SHIPPING_GST_STATE_NAME
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
               INNER JOIN ADMSITE OS ON (A.ADMSITE_CODE_OWNER = OS.CODE)
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
                  ON (TO_CHAR (A.INVCODE) = EI.TRANSACTION_CODE)
               LEFT OUTER JOIN
               (SELECT S.SLNAME              CUST_NAME,
                       S.SLCODE,
                       S.BADDR               CUST_BILLING_ADDRESS,
                       S.BCP                 CUST_BILLING_CONTACT_PERSON,
                       S.BCTNAME             CUST_BILLING_CITY,
                       BCT.STNAME            CUST_BILLING_STATE,
                       BCT.DIST              CUST_BILLING_DISTRICT,
                       BCT.ZONE              CUST_BILLING_ZONE,
                       S.BEMAIL              CUST_BILLING_EMAIL1,
                       S.BEMAIL2             CUST_BILLING_EMAIL2,
                       S.BFX1                CUST_BILLING_FAX,
                       S.BFX2                CUST_BILLING_MOBILE,
                       S.BPH1                CUST_BILLING_OFFICE_PHONE1,
                       S.BPH2                CUST_BILLING_OFFICE_PHONE2,
                       S.BPH3                CUST_BILLING_OFFICE_PHONE3,
                       S.BPIN                CUST_BILLING_PINCODE,
                       S.BWEBSITE            CUST_BILLING_WEBSITE,
                       S.CP_GSTIN_NO         CUST_GSTIN_NO,
                       S.CP_GSTIN_STATE_CODE CUST_GST_STATE_CODE,
                       GTE.NAME              CUST_GST_STATE_NAME
                  FROM FINSL S
                       LEFT OUTER JOIN ADMCITY BCT ON S.BCTNAME = BCT.CTNAME
                       LEFT OUTER JOIN ADMGSTSTATE GTE
                          ON S.CP_GSTIN_STATE_CODE = GTE.CODE) CUS
                  ON (A.PCODE = CUS.SLCODE)
               INNER JOIN ADMOU OU ON (A.ADMOU_CODE = OU.CODE)
               INNER JOIN SITE_DATA OS
                  ON (A.ADMSITE_CODE_OWNER = OS.SITECODE)
               INNER JOIN SITE_DATA RS ON (A.ADMSITE_CODE = RS.SITECODE)
         WHERE (   A.INVCODE IN
                      (    SELECT REGEXP_SUBSTR ('@DocumentId@',
                                                 '[^|~|]+',
                                                 1,
                                                 LEVEL)
                                     COL1
                             FROM DUAL
                       CONNECT BY LEVEL <=
                                     REGEXP_COUNT ('@DocumentId@', '|~|') + 1)
                OR NVL (REGEXP_COUNT ('@DocumentId@', '|~|') + 1, 0) = 0)) H
       INNER JOIN
       (                                                            /*Detail*/
        SELECT 'L2#DETAIL'        LVL,
               1                  SEQ,
               INVCODE,
               ICODE,
               INVOICE_QUANTITY   INVOICE_QUANTITY,
               HSN_SAC_CODE       HSN_SAC_CODE,
               INVOICE_RATE,
               INVOICE_RSP,
               ITEM_REMARKS       DETAIL_ITEM_REMARKS,
               ITEM_GROSS_AMOUNT  DETAIL_GROSS_AMOUNT,
               ITEM_TAX_RATE      DETAIL_TAX_RATE,
               ITEM_CHARGE_AMOUNT DETAIL_CHARGE_AMOUNT,
               ITEM_NET_AMOUNT    DETAIL_NET_AMOUNT,
               ITEM_TAX_AMOUNT    DETAIL_TAX_AMOUNT,
               TAXABLE_AMOUNT     DETAIL_TAXABLE_AMOUNT,
               CGST_RATE          DETAIL_CGST_RATE,
               CGST_AMOUNT        DETAIL_CGST_AMOUNT,
               SGST_RATE          DETAIL_SGST_RATE,
               SGST_AMOUNT        DETAIL_SGST_AMOUNT,
               IGST_RATE          DETAIL_IGST_RATE,
               IGST_AMOUNT        DETAIL_IGST_AMOUNT,
               LESS_AMOUNT,
               PARTER_MARGIN,
               DIVISION,
               SECTION,
               DEPARTMENT,
               BARCODE,
               ARTICLE_NAME       ITEM_ARTICLE_NAME,
               CATEGORY1          ITEM_CATEGORY1,
               CATEGORY2          ITEM_CATEGORY2,
               CATEGORY3          ITEM_CATEGORY3,
               CATEGORY4          ITEM_CATEGORY4,
               CATEGORY5          ITEM_CATEGORY5,
               CATEGORY6          ITEM_CATEGORY6,
               UOM                ITEM_UOM,
               RSP                ITEM_RSP,
               WSP                ITEM_WSP,
               MRP                ITEM_MRP,
               STANDARD_RATE      ITEM_STANDARD_RATE,
               ITEM_NAME,
               NULL               DISPLAY_SEQUENCE,
               NULL               SALES_CHARGE_NAME,
               NULL               CHARGE_RATE,
               NULL               CHARGE_AMOUNT,
               NULL               CHARGE_BASIS,
               NULL               CHARGE_APPLICABLE_ON,
               NULL               OPERATION_LEVEL
          FROM (  SELECT INVCODE             INVCODE,
                         M.ICODE             ICODE,
                         HSN_SAC_CODE,
                         SUM (INVQTY)        INVOICE_QUANTITY,
                         M.RATE              INVOICE_RATE,
                         SUM (RTQTY)         RETURNED_QUANTITY,
                         M.MRP               INVOICE_RSP,
                         REM                 ITEM_REMARKS,
                         SUM (INVAMT)        ITEM_GROSS_AMOUNT,
                         ROUND (ITEM_TAX_RATE) ITEM_TAX_RATE,
                         SUM (CHGAMT)        ITEM_CHARGE_AMOUNT,
                         SUM (
                              (COALESCE (INVAMT, 0) + COALESCE (CHGAMT, 0))
                            + COALESCE (TAXAMT, 0))
                            ITEM_NET_AMOUNT,
                         SUM (TAXAMT)        ITEM_TAX_AMOUNT,
                         SUM (TAXABLE_AMOUNT) TAXABLE_AMOUNT,
                         CGST_RATE,
                         SUM (CGST_AMOUNT)   CGST_AMOUNT,
                         SGST_RATE,
                         SUM (SGST_AMOUNT)   SGST_AMOUNT,
                         IGST_RATE,
                         SUM (IGST_AMOUNT)   IGST_AMOUNT,
                         SUM (LESS_AMOUNT)   LESS_AMOUNT,
                         SUM (PARTER_MARGIN) PARTER_MARGIN
                    FROM (SELECT *
                            FROM SALINVDET
                           WHERE (   INVCODE IN
                                        (    SELECT REGEXP_SUBSTR ('@DocumentId@',
                                                                   '[^|~|]+',
                                                                   1,
                                                                   LEVEL)
                                                       COL1
                                               FROM DUAL
                                         CONNECT BY LEVEL <=
                                                         REGEXP_COUNT (
                                                            '@DocumentId@',
                                                            '|~|')
                                                       + 1)
                                  OR NVL (
                                          REGEXP_COUNT ('@DocumentId@', '|~|')
                                        + 1,
                                        0) = 0)) M
                         LEFT OUTER JOIN INVDCDET DC
                            ON (INVDCDET_CODE = DC.CODE)
                         LEFT OUTER JOIN
                         (  SELECT SALINVDET_CODE,
                                   APPAMT                 TAXABLE_AMOUNT,
                                   ROUND (
                                      SUM (
                                         CASE
                                            WHEN SOURCE IN ('G', 'V')
                                            THEN
                                                 (  COALESCE (CHGAMT, 0)
                                                  / CASE
                                                       WHEN COALESCE (APPAMT, 0) =
                                                               0
                                                       THEN
                                                          1
                                                       ELSE
                                                          APPAMT
                                                    END)
                                               * 100
                                            ELSE
                                               0
                                         END),
                                      3)
                                      ITEM_TAX_RATE,
                                   SUM (COALESCE (CHGAMT, 0)) TAX_CHARGE_AMOUNT,
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
                                      IGST_AMOUNT
                              FROM SALINVCHG_ITEM
                             WHERE     ISTAX = 'Y'
                                   AND (   INVCODE IN
                                              (    SELECT REGEXP_SUBSTR (
                                                             '@DocumentId@',
                                                             '[^|~|]+',
                                                             1,
                                                             LEVEL)
                                                             COL1
                                                     FROM DUAL
                                               CONNECT BY LEVEL <=
                                                               REGEXP_COUNT (
                                                                  '@DocumentId@',
                                                                  '|~|')
                                                             + 1)
                                        OR NVL (
                                                REGEXP_COUNT ('@DocumentId@',
                                                              '|~|')
                                              + 1,
                                              0) = 0)
                          GROUP BY SALINVDET_CODE, APPAMT) TAX
                            ON (M.CODE = TAX.SALINVDET_CODE)
                         LEFT OUTER JOIN
                         (  SELECT SALINVDET_CODE,
                                   SUM (
                                      CASE
                                         WHEN CHGCODE = 66 THEN CHGAMT
                                         ELSE 0
                                      END)
                                      LESS_AMOUNT,
                                   SUM (
                                      CASE
                                         WHEN CHGCODE = 13426 THEN CHGAMT
                                         ELSE 0
                                      END)
                                      PARTER_MARGIN
                              FROM SALINVCHG_ITEM
                             WHERE     ISTAX = 'N'
                                   AND CHGCODE IN (66, 13426)
                                   AND (   INVCODE IN
                                              (    SELECT REGEXP_SUBSTR (
                                                             '@DocumentId@',
                                                             '[^|~|]+',
                                                             1,
                                                             LEVEL)
                                                             COL1
                                                     FROM DUAL
                                               CONNECT BY LEVEL <=
                                                               REGEXP_COUNT (
                                                                  '@DocumentId@',
                                                                  '|~|')
                                                             + 1)
                                        OR NVL (
                                                REGEXP_COUNT ('@DocumentId@',
                                                              '|~|')
                                              + 1,
                                              0) = 0)
                          GROUP BY SALINVDET_CODE) ADDT
                            ON (M.CODE = ADDT.SALINVDET_CODE)
                   WHERE (   INVCODE IN
                                (    SELECT REGEXP_SUBSTR ('@DocumentId@',
                                                           '[^|~|]+',
                                                           1,
                                                           LEVEL)
                                               COL1
                                       FROM DUAL
                                 CONNECT BY LEVEL <=
                                                 REGEXP_COUNT ('@DocumentId@',
                                                               '|~|')
                                               + 1)
                          OR NVL (REGEXP_COUNT ('@DocumentId@', '|~|') + 1, 0) =
                                0)
                GROUP BY INVCODE,
                         M.ICODE,
                         M.RATE,
                         M.MRP,
                         REM,
                         ROUND (ITEM_TAX_RATE),              /*Bug Id 108805*/
                         CGST_RATE,
                         SGST_RATE,
                         IGST_RATE,
                         DC.BASIC_RATE,
                         HSN_SAC_CODE) D
               INNER JOIN GINVIEW.INVITEM_AGG I ON (D.ICODE = I.CODE)
        UNION ALL
        SELECT 'L3#CHARGE' LVL,
               2           SEQ,
               INVCODE     INVCODE,
               NULL        ICODE,
               NULL        DETAIL_INVOICE_QUANTITY,
               NULL        DETAIL_HSN_SAC_CODE,
               NULL        INVOICE_RATE,
               NULL        INVOICE_RSP,
               NULL        DETAIL_ITEM_REMARKS,
               NULL        ITEM_GROSS_AMOUNT,
               NULL        ITEM_TAX_RATE,
               NULL        ITEM_CHARGE_AMOUNT,
               NULL        ITEM_NET_AMOUNT,
               NULL        ITEM_TAX_AMOUNT,
               NULL        DETAIL_TAXABLE_AMOUNT,
               NULL        DETAIL_CGST_RATE,
               NULL        DETAIL_CGST_AMOUNT,
               NULL        DETAIL_SGST_RATE,
               NULL        DETAIL_SGST_AMOUNT,
               NULL        DETAIL_IGST_RATE,
               NULL        DETAIL_IGST_AMOUNT,
               NULL        LESS_AMOUNT,
               NULL        PARTER_MARGIN,
               NULL        DIVISION,
               NULL        SECTION,
               NULL        DEPARTMENT,
               NULL        BARCODE,
               NULL        ITEM_ARTICLE_NAME,
               NULL        ITEM_CATEGORY1,
               NULL        ITEM_CATEGORY2,
               NULL        ITEM_CATEGORY3,
               NULL        ITEM_CATEGORY4,
               NULL        ITEM_CATEGORY5,
               NULL        ITEM_CATEGORY6,
               NULL        ITEM_UOM,
               NULL        ITEM_RSP,
               NULL        ITEM_WSP,
               NULL        ITEM_MRP,
               NULL        ITEM_STANDARD_RATE,
               NULL        ITEM_NAME,
               SEQ         DISPLAY_SEQUENCE,
               SALCHGNAME  SALES_CHARGE_NAME,
               RATE        CHARGE_RATE,
               CHGAMT      CHARGE_AMOUNT,
               INITCAP (
                  CASE
                     WHEN COALESCE (A.BASIS, 'P') = 'P' THEN 'PERCENTAGE'
                     WHEN COALESCE (A.BASIS, 'P') = 'A' THEN 'AMOUNT'
                  END)
                  CHARGE_BASIS,
               APPAMT      CHARGE_APPLICABLE_ON,
               INITCAP (
                  CASE
                     WHEN A.OPERATION_LEVEL = 'H' THEN 'HEADER'
                     WHEN A.OPERATION_LEVEL = 'L' THEN 'LINE'
                  END)
                  OPERATION_LEVEL
          FROM SALINVCHG A
               INNER JOIN SALCHG B ON (A.SALCHGCODE = B.SALCHGCODE)
         WHERE (   INVCODE IN
                      (    SELECT REGEXP_SUBSTR ('@DocumentId@',
                                                 '[^|~|]+',
                                                 1,
                                                 LEVEL)
                                     COL1
                             FROM DUAL
                       CONNECT BY LEVEL <=
                                     REGEXP_COUNT ('@DocumentId@', '|~|') + 1)
                OR NVL (REGEXP_COUNT ('@DocumentId@', '|~|') + 1, 0) = 0)) D
          ON (H.INVCODE = D.INVCODE)