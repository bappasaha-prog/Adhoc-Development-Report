/* Formatted on 2025-02-11 12:23:34 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_PURORD || Ticket Id : 392270 || Developer : Dipankar || ><><><*/
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
SELECT GINVIEW.FNC_UK                 UK,
       H.ORDCODE                      L1_ORDCODE,
       H.ORDER_DATE                   L1_ORDER_DATE,
       H.PCODE                        L1_PCODE,
       H.DOCUMENT_NO                  L1_DOCUMENT_NO,
       H.AGCODE                       L1_AGCODE,
       H.AGENT_NAME                   L1_AGENT_NAME,
       H.AGENT_RATE                   L1_AGENT_RATE,
       H.TRPCODE                      L1_TRPCODE,
       H.TRANSPORTER_NAME             L1_TRANSPORTER_NAME,
       H.INV_STATUS                   L1_INV_STATUS,
       H.AUTHORIZED_BY                L1_AUTHORIZED_BY,
       H.REMARKS                      L1_REMARKS,
       H.CREATED_BY                   L1_CREATED_BY,
       H.CREATED_ON                   L1_CREATED_ON,
       H.VALID_FROM                   L1_VALID_FROM,
       H.VALID_TILL                   L1_VALID_TILL,
       H.LAST_ACCESSED_ON             L1_LAST_ACCESSED_ON,
       H.LAST_ACCESSED_BY             L1_LAST_ACCESSED_BY,
       H.TERMS                        L1_TERMS,
       H.TYPE                         L1_TYPE,
       H.ORDER_NO                     L1_ORDER_NO,
       H.ADMOU_CODE                   L1_ADMOU_CODE,
       H.MERCHANDISER                 L1_MERCHANDISER,
       H.TRADE_GROUP_NAME             L1_TRADE_GROUP_NAME,
       H.INV_GROSS_AMOUNT             L1_INV_GROSS_AMOUNT,
       H.INV_CHARGE_AMOUNT            L1_INV_CHARGE_AMOUNT,
       H.NET_AMOUNT                   L1_NET_AMOUNT,
       H.CURRENCY                     L1_CURRENCY,
       H.CURRENCY_DECIMAL_SYMBOL      L1_CURRENCY_DECIMAL_SYMBOL,
       H.CURRENCY_SYMBOL              L1_CURRENCY_SYMBOL,
       H.CURRENCY_EXCHANGE_RATE       L1_CURRENCY_EXCHANGE_RATE,
       H.ADMSITE_CODE                 L1_ADMSITE_CODE,
       H.SHIPMENT_TRACKING_APPLICABLE L1_SHIPMENT_TRACK_APPLICABLE,
       H.PURCHASE_TERM_NAME           L1_PURCHASE_TERM_NAME,
       H.PURORDMAIN_UDFSTRIN01        L1_PURORDMAIN_UDFSTRIN01,
       H.PURORDMAIN_UDFSTRIN02        L1_PURORDMAIN_UDFSTRIN02,
       H.PURORDMAIN_UDFSTRIN03        L1_PURORDMAIN_UDFSTRIN03,
       H.PURORDMAIN_UDFSTRIN04        L1_PURORDMAIN_UDFSTRIN04,
       H.PURORDMAIN_UDFSTRIN05        L1_PURORDMAIN_UDFSTRIN05,
       H.PURORDMAIN_UDFSTRIN06        L1_PURORDMAIN_UDFSTRIN06,
       H.PURORDMAIN_UDFSTRIN07        L1_PURORDMAIN_UDFSTRIN07,
       H.PURORDMAIN_UDFSTRIN08        L1_PURORDMAIN_UDFSTRIN08,
       H.PURORDMAIN_UDFSTRIN09        L1_PURORDMAIN_UDFSTRIN09,
       H.PURORDMAIN_UDFSTRIN010       L1_PURORDMAIN_UDFSTRIN010,
       H.PURORDMAIN_UDFNUM01          L1_PURORDMAIN_UDFNUM01,
       H.PURORDMAIN_UDFNUM02          L1_PURORDMAIN_UDFNUM02,
       H.PURORDMAIN_UDFNUM03          L1_PURORDMAIN_UDFNUM03,
       H.PURORDMAIN_UDFNUM04          L1_PURORDMAIN_UDFNUM04,
       H.PURORDMAIN_UDFNUM05          L1_PURORDMAIN_UDFNUM05,
       H.PURORDMAIN_UDFDATE01         L1_PURORDMAIN_UDFDATE01,
       H.PURORDMAIN_UDFDATE02         L1_PURORDMAIN_UDFDATE02,
       H.PURORDMAIN_UDFDATE03         L1_PURORDMAIN_UDFDATE03,
       H.PURORDMAIN_UDFDATE04         L1_PURORDMAIN_UDFDATE04,
       H.PURORDMAIN_UDFDATE05         L1_PURORDMAIN_UDFDATE05,
       H.AUTHORIZED_ON                L1_AUTHORIZED_ON,
       H.CUST_NAME                    L1_CUST_NAME,
       H.CUST_BILLING_ADDRESS         L1_CUST_BILLING_ADDRESS,
       H.CUST_BILLING_CONTACT_PERSON  L1_CUST_BILLING_CONTACT_PERSON,
       H.CUST_BILLING_CITY            L1_CUST_BILLING_CITY,
       H.CUST_BILLING_STATE           L1_CUST_BILLING_STATE,
       H.CUST_BILLING_DISTRICT        L1_CUST_BILLING_DISTRICT,
       H.CUST_BILLING_ZONE            L1_CUST_BILLING_ZONE,
       H.CUST_BILLING_EMAIL1          L1_CUST_BILLING_EMAIL1,
       H.CUST_BILLING_EMAIL2          L1_CUST_BILLING_EMAIL2,
       H.CUST_BILLING_FAX             L1_CUST_BILLING_FAX,
       H.CUST_BILLING_MOBILE          L1_CUST_BILLING_MOBILE,
       H.CUST_BILLING_OFFICE_PHONE1   L1_CUST_BILLING_OFFICE_PHONE1,
       H.CUST_BILLING_OFFICE_PHONE2   L1_CUST_BILLING_OFFICE_PHONE2,
       H.CUST_BILLING_OFFICE_PHONE3   L1_CUST_BILLING_OFFICE_PHONE3,
       H.CUST_BILLING_PINCODE         L1_CUST_BILLING_PINCODE,
       H.CUST_BILLING_WEBSITE         L1_CUST_BILLING_WEBSITE,
       H.CUST_GSTIN_NO                L1_CUST_GSTIN_NO,
       H.CUST_GST_STATE_NAME          L1_CUST_GST_STATE_NAME,
       H.CUST_GST_STATE_CODE          L1_CUST_GST_STATE_CODE,
       H.CUST_CREDIT_DAYS             L1_CUST_CREDIT_DAYS,
       H.CUST_IDENTITY_NO             L1_CUST_IDENTITY_NO,
       H.ORGUNIT_NAME                 L1_ORGUNIT_NAME,
       H.ORGUNIT_WEBSITE              L1_ORGUNIT_WEBSITE,
       H.ORGUNIT_CIN                  L1_ORGUNIT_CIN,
       H.OWNER_SITE_NAME              L1_OWNER_SITE_NAME,
       H.OWNER_SHORT_CODE             L1_OWNER_SHORT_CODE,
       H.OWNER_SITE_ADDRESS           L1_OWNER_SITE_ADDRESS,
       H.OWNER_SITE_CITY              L1_OWNER_SITE_CITY,
       H.OWNER_SITE_PINCODE           L1_OWNER_SITE_PINCODE,
       H.OWNER_SITE_PHONE1            L1_OWNER_SITE_PHONE1,
       H.OWNER_SITE_PHONE2            L1_OWNER_SITE_PHONE2,
       H.OWNER_SITE_PHONE3            L1_OWNER_SITE_PHONE3,
       H.OWNER_SITE_EMAIL1            L1_OWNER_SITE_EMAIL1,
       H.OWNER_SITE_EMAIL2            L1_OWNER_SITE_EMAIL2,
       H.OWNER_GSTIN_NO               L1_OWNER_GSTIN_NO,
       H.OWNER_GST_STATE_CODE         L1_OWNER_GST_STATE_CODE,
       H.OWNER_GST_STATE_NAME         L1_OWNER_GST_STATE_NAME,
       H.OWNER_SITE_WEBSITE           L1_OWNER_SITE_WEBSITE,
       D.LVL,
       D.SEQ,
       D.ARTICLE_NAME                 L2_ARTICLE_NAME,
       D.STYLE_NO                     L2_STYLE_NO,
       D.RATE                         L2_RATE,
       D.AMOUNT                       L2_AMOUNT,
       D.TOTAL_QTY                    L2_TOTAL_QTY,
       D.SIZE1                        L2_SIZE1,
       D.SIZE2                        L2_SIZE2,
       D.SIZE3                        L2_SIZE3,
       D.SIZE4                        L2_SIZE4,
       D.SIZE5                        L2_SIZE5,
       D.SIZE6                        L2_SIZE6,
       D.SIZE7                        L2_SIZE7,
       D.SIZE8                        L2_SIZE8,
       D.SIZE9                        L2_SIZE9,
       D.SIZE10                       L2_SIZE10,
       D.SIZE11                       L2_SIZE11,
       D.SIZE12                       L2_SIZE12,
       D.SIZE13                       L2_SIZE13,
       D.SIZE14                       L2_SIZE14,
       D.SIZE15                       L2_SIZE15,
       D.SIZE16                       L2_SIZE16,
       D.SIZE17                       L2_SIZE17,
       D.SIZE18                       L2_SIZE18,
       D.SIZE19                       L2_SIZE19,
       D.SIZE20                       L2_SIZE20,
       D.CHARGE_APPLICABLE_ON         L3_CHARGE_APPLICABLE_ON,
       D.CHARGE_BASIS                 L3_CHARGE_BASIS,
       D.CHARGE_AMOUNT                L3_CHARGE_AMOUNT,
       D.CHARGE_NAME                  L3_CHARGE_NAME,
       D.OPERATION_LEVEL              L3_OPERATION_LEVEL,
       D.CHARGE_RATE                  L3_CHARGE_RATE,
       D.DISPLAY_SEQUENCE             L3_DISPLAY_SEQUENCE,
       D.HSN_ORDER_QUANTITY           L4_ORDER_QUANTITY,
       D.HSN_CODE                     L4_HSN_CODE,
       D.HSN_SAC_ID                   L4_HSN_SAC_ID,
       D.HSN_DESCRIPTION              L4_HSN_DESCRIPTION,
       D.HSN_UOM                      L4_HSN_UOM,
       D.HSN_TAXABLE_AMOUNT           L4_TAXABLE_AMOUNT,
       D.HSN_CGST_RATE                L4_CGST_RATE,
       D.HSN_CGST_AMOUNT              L4_CGST_AMOUNT,
       D.HSN_SGST_RATE                L4_SGST_RATE,
       D.HSN_SGST_AMOUNT              L4_SGST_AMOUNT,
       D.HSN_IGST_RATE                L4_IGST_RATE,
       D.HSN_IGST_AMOUNT              L4_IGST_AMOUNT,
       D.HSN_CESS_RATE                L4_CESS_RATE,
       D.HSN_CESS_AMOUNT              L4_CESS_AMOUNT,
       D.SCHEDULE_DATE                L5_SCHEDULE_DATE,
       D.SCHEDULE_ORDER_QUANTITY      L5_SCHEDULE_ORDER_QUANTITY
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
               OU.NAME                                ORGUNIT_NAME,
               OU.WEBSITE                             ORGUNIT_WEBSITE,
               OU.CINNO                               ORGUNIT_CIN,
               OS.NAME                                OWNER_SITE_NAME,
               OS.SHORT_CODE                          OWNER_SHORT_CODE,
               OS.ADDRESS                             OWNER_SITE_ADDRESS,
               OS.CITY                                OWNER_SITE_CITY,
               OS.PINCODE                             OWNER_SITE_PINCODE,
               OS.PHONE1                              OWNER_SITE_PHONE1,
               OS.PHONE2                              OWNER_SITE_PHONE2,
               OS.PHONE3                              OWNER_SITE_PHONE3,
               OS.EMAIL1                              OWNER_SITE_EMAIL1,
               OS.EMAIL2                              OWNER_SITE_EMAIL2,
               OS.GST_IDENTIFICATION_NO               OWNER_GSTIN_NO,
               OS.GST_STATE_CODE                      OWNER_GST_STATE_CODE,
               OS.GST_STATE_NAME                      OWNER_GST_STATE_NAME,
               OS.WEBSITE                             OWNER_SITE_WEBSITE
          FROM PURORDMAIN M
               INNER JOIN ADMYEAR Y ON (M.YCODE = Y.YCODE)
               INNER JOIN HRDEMP CR ON (M.ECODE = CR.ECODE)
               INNER JOIN FINTRADEGRP TR ON (M.FINTRADEGRP_CODE = TR.CODE)
               INNER JOIN ADMCURRENCY CUR ON (M.ADMCURRENCY_CODE = CUR.CODE)
               INNER JOIN ADMOU OU ON (M.ADMOU_CODE = OU.CODE)
               INNER JOIN SITE_DATA OS ON (M.ADMSITE_CODE = OS.SITECODE)
               LEFT OUTER JOIN FINSL AG ON (M.AGCODE = AG.SLCODE)
               LEFT OUTER JOIN FINSL TP ON (M.TRPCODE = TP.SLCODE)
               LEFT OUTER JOIN HRDEMP AU ON (AUTHORCODE = AU.ECODE)
               LEFT OUTER JOIN HRDEMP LA ON (LAST_ACCESS_ECODE = LA.ECODE)
               LEFT OUTER JOIN HRDEMP MR ON (MRCHNDSRCODE = MR.ECODE)
               LEFT OUTER JOIN PURTERMMAIN TRM ON (PURTERMCODE = TRM.CODE)
               INNER JOIN
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
                       GTE.NAME              CUST_GST_STATE_NAME,
                       S.CP_GSTIN_STATE_CODE CUST_GST_STATE_CODE,
                       S.CRDAYS              CUST_CREDIT_DAYS,
                       S.SLID                CUST_IDENTITY_NO
                  FROM FINSL S
                       LEFT OUTER JOIN ADMCITY BCT ON S.BCTNAME = BCT.CTNAME
                       LEFT OUTER JOIN ADMGSTSTATE GTE
                          ON S.CP_GSTIN_STATE_CODE = GTE.CODE) CUS
                  ON (M.PCODE = CUS.SLCODE)
         WHERE (   ORDCODE IN
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
       (                                                       /*Detail Part*/
        SELECT 'L2#DETAIL' LVL,
               1           SEQ,
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
               NULL        CHARGE_APPLICABLE_ON,
               NULL        CHARGE_BASIS,
               NULL        CHARGE_AMOUNT,
               NULL        CHARGE_NAME,
               NULL        OPERATION_LEVEL,
               NULL        CHARGE_RATE,
               NULL        DISPLAY_SEQUENCE,
               NULL        HSN_ORDER_QUANTITY,
               NULL        HSN_CODE,
               NULL        HSN_SAC_ID,
               NULL        HSN_DESCRIPTION,
               NULL        HSN_UOM,
               NULL        HSN_TAXABLE_AMOUNT,
               NULL        HSN_CGST_RATE,
               NULL        HSN_CGST_AMOUNT,
               NULL        HSN_SGST_RATE,
               NULL        HSN_SGST_AMOUNT,
               NULL        HSN_IGST_RATE,
               NULL        HSN_IGST_AMOUNT,
               NULL        HSN_CESS_RATE,
               NULL        HSN_CESS_AMOUNT,
               NULL        SCHEDULE_DATE,
               NULL        SCHEDULE_ORDER_QUANTITY
          FROM (  SELECT ORDCODE,
                         ARTICLE_NAME,
                         STYLE_NO,
                         RATE,
                         SUM (AMOUNT)                               AMOUNT,
                         SUM (QTY)                                  TOTAL_QTY,
                         SUM (CASE WHEN SEQ = 1 THEN QTY ELSE 0 END) SIZE1,
                         SUM (CASE WHEN SEQ = 2 THEN QTY ELSE 0 END) SIZE2,
                         SUM (CASE WHEN SEQ = 3 THEN QTY ELSE 0 END) SIZE3,
                         SUM (CASE WHEN SEQ = 4 THEN QTY ELSE 0 END) SIZE4,
                         SUM (CASE WHEN SEQ = 5 THEN QTY ELSE 0 END) SIZE5,
                         SUM (CASE WHEN SEQ = 6 THEN QTY ELSE 0 END) SIZE6,
                         SUM (CASE WHEN SEQ = 7 THEN QTY ELSE 0 END) SIZE7,
                         SUM (CASE WHEN SEQ = 8 THEN QTY ELSE 0 END) SIZE8,
                         SUM (CASE WHEN SEQ = 9 THEN QTY ELSE 0 END) SIZE9,
                         SUM (CASE WHEN SEQ = 10 THEN QTY ELSE 0 END) SIZE10,
                         SUM (CASE WHEN SEQ = 11 THEN QTY ELSE 0 END) SIZE11,
                         SUM (CASE WHEN SEQ = 12 THEN QTY ELSE 0 END) SIZE12,
                         SUM (CASE WHEN SEQ = 13 THEN QTY ELSE 0 END) SIZE13,
                         SUM (CASE WHEN SEQ = 14 THEN QTY ELSE 0 END) SIZE14,
                         SUM (CASE WHEN SEQ = 15 THEN QTY ELSE 0 END) SIZE15,
                         SUM (CASE WHEN SEQ = 16 THEN QTY ELSE 0 END) SIZE16,
                         SUM (CASE WHEN SEQ = 17 THEN QTY ELSE 0 END) SIZE17,
                         SUM (CASE WHEN SEQ = 18 THEN QTY ELSE 0 END) SIZE18,
                         SUM (CASE WHEN SEQ = 19 THEN QTY ELSE 0 END) SIZE19,
                         SUM (CASE WHEN SEQ = 20 THEN QTY ELSE 0 END) SIZE20
                    FROM (  SELECT GINVIEW.FNC_UK UK,
                                   D.ORDCODE,
                                   I.ARTICLE_NAME,
                                   I.CATEGORY2|| '-' ||I.CATEGORY5     STYLE_NO,
                                   TRIM (I.CATEGORY3) ITEM_SIZE,
                                   DENSE_RANK ()
                                   OVER (PARTITION BY D.ORDCODE
                                         ORDER BY TRIM (I.CATEGORY3))
                                      SEQ,
                                   SUM (D.ORDQTY) QTY,
                                   SUM (D.NETAMT) AMOUNT,
                                   D.RATE
                              FROM PURORDDET D
                                   INNER JOIN GINVIEW.LV_ITEM I
                                      ON D.ICODE = I.CODE
                             WHERE (   ORDCODE IN
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
                                          0) = 0)
                          GROUP BY D.ORDCODE,
                                   I.ARTICLE_NAME,
                                   I.CATEGORY2|| '-' ||I.CATEGORY5,
                                   D.RATE,
                                   TRIM (I.CATEGORY3))
                GROUP BY ORDCODE,
                         ARTICLE_NAME,
                         STYLE_NO,
                         RATE) D
        UNION ALL
        /*Charge Part*/
        SELECT 'L3#CHARGE' LVL,
               2           SEQ,
               ORDCODE,
               NULL        ARTICLE_NAME,
               NULL        STYLE_NO,
               NULL        RATE,
               NULL        AMOUNT,
               NULL        TOTAL_QTY,
               NULL        SIZE1,
               NULL        SIZE2,
               NULL        SIZE3,
               NULL        SIZE4,
               NULL        SIZE5,
               NULL        SIZE6,
               NULL        SIZE7,
               NULL        SIZE8,
               NULL        SIZE9,
               NULL        SIZE10,
               NULL        SIZE11,
               NULL        SIZE12,
               NULL        SIZE13,
               NULL        SIZE14,
               NULL        SIZE15,
               NULL        SIZE16,
               NULL        SIZE17,
               NULL        SIZE18,
               NULL        SIZE19,
               NULL        SIZE20,
               APPAMT      CHARGE_APPLICABLE_ON,
               INITCAP (
                  CASE
                     WHEN A.BASIS = 'P' THEN 'PERCENTAGE'
                     WHEN A.BASIS = 'A' THEN 'AMOUNT'
                  END)
                  CHARGE_BASIS,
               CHGAMT      CHARGE_AMOUNT,
               CHGNAME     CHARGE_NAME,
               INITCAP (
                  CASE
                     WHEN A.OPERATION_LEVEL = 'H' THEN 'HEADER'
                     WHEN A.OPERATION_LEVEL = 'L' THEN 'LINE'
                  END)
                  OPERATION_LEVEL,
               A.RATE      CHARGE_RATE,
               SEQ         DISPLAY_SEQUENCE,
               NULL        HSN_ORDER_QUANTITY,
               NULL        HSN_CODE,
               NULL        HSN_SAC_ID,
               NULL        HSN_DESCRIPTION,
               NULL        HSN_UOM,
               NULL        HSN_TAXABLE_AMOUNT,
               NULL        HSN_CGST_RATE,
               NULL        HSN_CGST_AMOUNT,
               NULL        HSN_SGST_RATE,
               NULL        HSN_SGST_AMOUNT,
               NULL        HSN_IGST_RATE,
               NULL        HSN_IGST_AMOUNT,
               NULL        HSN_CESS_RATE,
               NULL        HSN_CESS_AMOUNT,
               NULL        SCHEDULE_DATE,
               NULL        ORDER_QUANTITY
          FROM PURORDCHG A INNER JOIN FINCHG B ON (A.CHGCODE = B.CHGCODE)
         WHERE (   ORDCODE IN
                      (    SELECT REGEXP_SUBSTR ('@DocumentId@',
                                                 '[^|~|]+',
                                                 1,
                                                 LEVEL)
                                     COL1
                             FROM DUAL
                       CONNECT BY LEVEL <=
                                     REGEXP_COUNT ('@DocumentId@', '|~|') + 1)
                OR NVL (REGEXP_COUNT ('@DocumentId@', '|~|') + 1, 0) = 0)
        UNION ALL
          /*HSN Part*/
          SELECT 'L4#HSN'           LVL,
                 3                  SEQ,
                 ORDCODE,
                 NULL               ARTICLE_NAME,
                 NULL               STYLE_NO,
                 NULL               RATE,
                 NULL               AMOUNT,
                 NULL               TOTAL_QTY,
                 NULL               SIZE1,
                 NULL               SIZE2,
                 NULL               SIZE3,
                 NULL               SIZE4,
                 NULL               SIZE5,
                 NULL               SIZE6,
                 NULL               SIZE7,
                 NULL               SIZE8,
                 NULL               SIZE9,
                 NULL               SIZE10,
                 NULL               SIZE11,
                 NULL               SIZE12,
                 NULL               SIZE13,
                 NULL               SIZE14,
                 NULL               SIZE15,
                 NULL               SIZE16,
                 NULL               SIZE17,
                 NULL               SIZE18,
                 NULL               SIZE19,
                 NULL               SIZE20,
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
                 SUM (SGST_AMOUNT)  HSN_SGST_AMOUNT,
                 IGST_RATE          HSN_IGST_RATE,
                 SUM (IGST_AMOUNT)  HSN_IGST_AMOUNT,
                 CESS_RATE          HSN_CESS_RATE,
                 SUM (CESS_AMOUNT)  HSN_CESS_AMOUNT,
                 NULL               SCHEDULE_DATE,
                 NULL               ORDER_QUANTITY
            FROM (SELECT *
                    FROM PURORDDET
                   WHERE (   ORDCODE IN
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
                                0)) D
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
                              CESS_RATE,
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
                           AND (   ORDCODE IN
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
                                OR NVL (REGEXP_COUNT ('@DocumentId@', '|~|') + 1,
                                        0) = 0)
                  GROUP BY PURORDDET_CODE, APPAMT) TAX
                    ON D.CODE = TAX.PURORDDET_CODE
           WHERE (   ORDCODE IN
                        (    SELECT REGEXP_SUBSTR ('@DocumentId@',
                                                   '[^|~|]+',
                                                   1,
                                                   LEVEL)
                                       COL1
                               FROM DUAL
                         CONNECT BY LEVEL <=
                                       REGEXP_COUNT ('@DocumentId@', '|~|') + 1)
                  OR NVL (REGEXP_COUNT ('@DocumentId@', '|~|') + 1, 0) = 0)
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
               4             SEQ,
               ORDCODE,
               NULL          ARTICLE_NAME,
               NULL          STYLE_NO,
               NULL          RATE,
               NULL          AMOUNT,
               NULL          TOTAL_QTY,
               NULL          SIZE1,
               NULL          SIZE2,
               NULL          SIZE3,
               NULL          SIZE4,
               NULL          SIZE5,
               NULL          SIZE6,
               NULL          SIZE7,
               NULL          SIZE8,
               NULL          SIZE9,
               NULL          SIZE10,
               NULL          SIZE11,
               NULL          SIZE12,
               NULL          SIZE13,
               NULL          SIZE14,
               NULL          SIZE15,
               NULL          SIZE16,
               NULL          SIZE17,
               NULL          SIZE18,
               NULL          SIZE19,
               NULL          SIZE20,
               NULL          CHARGE_APPLICABLE_ON,
               NULL          CHARGE_BASIS,
               NULL          CHARGE_AMOUNT,
               NULL          CHARGE_NAME,
               NULL          OPERATION_LEVEL,
               NULL          CHARGE_RATE,
               NULL          DISPLAY_SEQUENCE,
               NULL          HSN_ORDER_QUANTITY,
               NULL          HSN_CODE,
               NULL          HSN_SAC_ID,
               NULL          HSN_DESCRIPTION,
               NULL          HSN_UOM,
               NULL          HSN_TAXABLE_AMOUNT,
               NULL          HSN_CGST_RATE,
               NULL          HSN_CGST_AMOUNT,
               NULL          HSN_SGST_RATE,
               NULL          HSN_SGST_AMOUNT,
               NULL          HSN_IGST_RATE,
               NULL          HSN_IGST_AMOUNT,
               NULL          HSN_CESS_RATE,
               NULL          HSN_CESS_AMOUNT,
               SCHEDULEDT    SCHEDULE_DATE,
               ORDQTY        ORDER_QUANTITY
          FROM PURORDSCHEDULE
         WHERE (   ORDCODE IN
                      (    SELECT REGEXP_SUBSTR ('@DocumentId@',
                                                 '[^|~|]+',
                                                 1,
                                                 LEVEL)
                                     COL1
                             FROM DUAL
                       CONNECT BY LEVEL <=
                                     REGEXP_COUNT ('@DocumentId@', '|~|') + 1)
                OR NVL (REGEXP_COUNT ('@DocumentId@', '|~|') + 1, 0) = 0)) D
          ON (H.ORDCODE = D.ORDCODE)