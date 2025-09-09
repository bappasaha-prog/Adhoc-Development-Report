/*|| Custom Development || Object : CQ_SO_TO || Ticket Id :  429801 || Developer : Dipankar ||*/

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
       H.ORDCODE                       L1_ORDCODE,
       H.ORDER_DATE                    L1_ORDER_DATE,
       H.PCODE                         L1_PCODE,
       H.DOCUMENT_NO                   L1_DOCUMENT_NO,
       H.DOCUMENT_DATE                 L1_DOCUMENT_DATE,
       H.AGCODE                        L1_AGCODE,
       H.AGENT_NAME                    L1_AGENT_NAME,
       H.AGENT_RATE                    L1_AGENT_RATE,
       H.TRPCODE                       L1_TRPCODE,
       H.TRANSPORTER_NAME              L1_TRANSPORTER_NAME,
       H.DUE_DATE                      L1_DUE_DATE,
       H.STATUS                        L1_STATUS,
       H.AUTHORIZED_BY                 L1_AUTHORIZED_BY,
       H.REMARKS                       L1_REMARKS,
       H.CREATED_BY                    L1_CREATED_BY,
       H.CREATED_ON                    L1_CREATED_ON,
       H.ORDER_NO                      L1_ORDER_NO,
       H.ADMOU_CODE                    L1_ADMOU_CODE,
       H.ADMSITE_CODE                  L1_ADMSITE_CODE,
       H.PRICE_TYPE                    L1_PRICE_TYPE,
       H.PRICE_LIST_NAME               L1_PRICE_LIST_NAME,
       H.DISCOUNT_FACTOR               L1_DISCOUNT_FACTOR,
       H.PRICE_ROUND_OFF               L1_PRICE_ROUND_OFF,
       H.PRICE_ROUND_OFF_LIMIT         L1_PRICE_ROUND_OFF_LIMIT,
       H.ADMSITE_CODE_OWNER            L1_ADMSITE_CODE_OWNER,
       H.PRICE_INCLUSION_OF_TAX        L1_PRICE_INCLUSION_OF_TAX,
       H.PRICE_MODE                    L1_PRICE_MODE,
       H.PRICE_BASIS                   L1_PRICE_BASIS,
       H.SALES_TERM                    L1_SALES_TERM,
       H.INV_GROSS_AMOUNT              L1_INV_GROSS_AMOUNT,
       H.INV_CHARGE_AMOUNT             L1_INV_CHARGE_AMOUNT,
       H.INV_NET_AMOUNT                L1_INV_NET_AMOUNT,
       H.TRADE_GROUP_NAME              L1_TRADE_GROUP_NAME,
       H.STORE_POS_ORDER_NO            L1_STORE_POS_ORDER_NO,
       H.STORE_POS_ORDER_DATE          L1_STORE_POS_ORDER_DATE,
       H.STORE_POS_ORDER_REMARKS       L1_STORE_POS_ORDER_REMARKS,
       H.TAX_BASED_ON                  L1_TAX_BASED_ON,
       H.AUTHORIZED_ON                 L1_AUTHORIZED_ON,
       H.LAST_ACCESSED_BY              L1_LAST_ACCESSED_BY,
       H.LAST_ACCESSED_ON              L1_LAST_ACCESSED_ON,
       H.ON_HOLD                       L1_ON_HOLD,
       H.HELD_BY                       L1_HELD_BY,
       H.HELD_ON                       L1_HELD_ON,
       H.AGAINST_RESERVATION           L1_AGAINST_RESERVATION,
       H.CHALLAN_NO                    L1_CHALLAN_NO,
       H.SALORDMAIN_UDFSTRING01        L1_SALORDMAIN_UDFSTRING01,
       H.SALORDMAIN_UDFSTRING02        L1_SALORDMAIN_UDFSTRING02,
       H.SALORDMAIN_UDFSTRING03        L1_SALORDMAIN_UDFSTRING03,
       H.SALORDMAIN_UDFSTRING04        L1_SALORDMAIN_UDFSTRING04,
       H.SALORDMAIN_UDFSTRING05        L1_SALORDMAIN_UDFSTRING05,
       H.SALORDMAIN_UDFSTRING06        L1_SALORDMAIN_UDFSTRING06,
       H.SALORDMAIN_UDFSTRING07        L1_SALORDMAIN_UDFSTRING07,
       H.SALORDMAIN_UDFSTRING08        L1_SALORDMAIN_UDFSTRING08,
       H.SALORDMAIN_UDFSTRING09        L1_SALORDMAIN_UDFSTRING09,
       H.SALORDMAIN_UDFSTRING10        L1_SALORDMAIN_UDFSTRING10,
       H.SALORDMAIN_UDFNUM01           L1_SALORDMAIN_UDFNUM01,
       H.SALORDMAIN_UDFNUM02           L1_SALORDMAIN_UDFNUM02,
       H.SALORDMAIN_UDFNUM03           L1_SALORDMAIN_UDFNUM03,
       H.SALORDMAIN_UDFNUM04           L1_SALORDMAIN_UDFNUM04,
       H.SALORDMAIN_UDFNUM05           L1_SALORDMAIN_UDFNUM05,
       H.SALORDMAIN_UDFDATE01          L1_SALORDMAIN_UDFDATE01,
       H.SALORDMAIN_UDFDATE02          L1_SALORDMAIN_UDFDATE02,
       H.SALORDMAIN_UDFDATE03          L1_SALORDMAIN_UDFDATE03,
       H.SALORDMAIN_UDFDATE04          L1_SALORDMAIN_UDFDATE04,
       H.SALORDMAIN_UDFDATE05          L1_SALORDMAIN_UDFDATE05,
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
       H.CUST_GST_STATE_NAME           L1_CUST_GST_STATE_NAME,
       H.CUST_GST_STATE_CODE           L1_CUST_GST_STATE_CODE,
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
       H.OWNER_GST_IDENTIFICATION_NO   L1_OWNER_GST_IDENTIFICATION_NO,
       H.OWNER_GST_STATE_CODE          L1_OWNER_GST_STATE_CODE,
       H.OWNER_GST_STATE_NAME          L1_OWNER_GST_STATE_NAME,
       H.REFSITE_NAME                  L1_REFSITE_NAME,
       H.REFSITE_SHORT_CODE            L1_REFSITE_SHORT_CODE,
       H.REFSITE_ADDRESS               L1_REFSITE_ADDRESS,
       H.REFSITE_CITY                  L1_REFSITE_CITY,
       H.REFSITE_PINCODE               L1_REFSITE_PINCODE,
       H.REFSITE_PHONE1                L1_REFSITE_PHONE1,
       H.REFSITE_PHONE2                L1_REFSITE_PHONE2,
       H.REFSITE_PHONE3                L1_REFSITE_PHONE3,
       H.REFSITE_EMAIL                 L1_REFSITE_EMAIL,
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
       D.LVL,
       D.SEQ,
       D.ICODE                         L2_ICODE,
       D.BARCODE                       L2_BARCODE,
       D.DIVISION                      L2_DIVISION,
       D.SECTION                       L2_SECTION,
       D.DEPARTMENT                    L2_DEPARTMENT,
       D.ITEM_ARTICLE_NAME             L2_ARTICLE_NAME,
       D.ITEM_MANAGEMENT_MODE          L2_ITEM_MANAGEMENT_MODE,
       D.ITEM_CATEGORY1                L2_CATEGORY1,
       D.ITEM_CATEGORY2                L2_CATEGORY2,
       D.ITEM_CATEGORY3                L2_CATEGORY3,
       D.ITEM_CATEGORY4                L2_CATEGORY4,
       D.ITEM_CATEGORY5                L2_CATEGORY5,
       D.ITEM_CATEGORY6                L2_CATEGORY6,
       D.ITEM_MRP                      L2_MRP,
       D.ITEM_RSP                      L2_RSP,
       D.ITEM_WSP                      L2_WSP,
       D.ITEM_STANDARD_RATE            L2_STANDARD_RATE,
       D.ITEM_UOM                      L2_ITEM_UOM,
       D.ITEM_NAME                     L2_ITEM_NAME,
       D.ITEM_HSN                      L2_HSN_CODE,
       D.ITEM_ORD_QTY                  L2_ORD_QTY,
       D.ITEM_CANCEL_QTY               L2_CANCEL_QTY,
       D.ITEM_ORD_RATE                 L2_ORD_RATE,
       D.ITEM_RESERVED_QTY             L2_RESERVED_QTY,
       D.ITEM_PICK_LIST_QTY            L2_PICK_LIST_QTY,
       D.ITEM_PICK_CONFIRM_QTY         L2_PICK_CONFIRM_QTY,
       D.ITEM_DELIVERED_QTY            L2_DELIVERED_QTY,
       D.ITEM_ORIGINAL_ORD_QTY         L2_ORIGINAL_ORD_QTY,
       D.ITEM_INVOICED_QTY             L2_INVOICED_QTY,
       D.ITEM_REMARKS                  L2_ITEM_REMARKS,
       D.ITEM_DISCOUNT_FACTOR          L2_DISCOUNT_FACTOR,
       D.ITEM_DISCOUNT_AMOUNT          L2_DISCOUNT_AMOUNT,
       D.ITEM_ORD_BASIC_RATE           L2_ORD_BASIC_RATE,
       D.ITEM_ROUND_OFF_AMOUNT         L2_ROUND_OFF_AMOUNT,
       D.ITEM_GROSS_AMOUNT             L2_ITEM_GROSS_AMOUNT,
       D.ITEM_OTHER_CHARGE_AMOUNT      L2_ITEM_OTHER_CHARGE_AMOUNT,
       D.ITEM_TAX_CHARGE_AMOUNT        L2_ITEM_TAX_CHARGE_AMOUNT,
       D.ITEM_NET_AMOUNT               L2_ITEM_NET_AMOUNT,
       D.ITEM_TAX_RATE                 L2_ITEM_TAX_RATE,
       D.ITEM_ORD_RSP                  L2_ORD_RSP,
       D.ITEM_STORE_POS_ORD_REMARKS    L2_STORE_POS_ORD_REMARKS,
       D.ITEM_STORE_POS_ORD_CANCEL_QTY L2_STORE_POS_ORD_CANCEL_QTY,
       D.ITEM_STORE_POS_ORD_CANCEL_REM L2_STORE_POS_ORD_CANCEL_REM,
       D.ITEM_TAXABLE_AMOUNT           L2_TAXABLE_AMOUNT,
       D.ITEM_CGST_RATE                L2_CGST_RATE,
       D.ITEM_CGST_AMOUNT              L2_CGST_AMOUNT,
       D.ITEM_SGST_RATE                L2_SGST_RATE,
       D.ITEM_SGST_AMOUNT              L2_SGST_AMOUNT,
       D.ITEM_IGST_RATE                L2_IGST_RATE,
       D.ITEM_IGST_AMOUNT              L2_IGST_AMOUNT,
       D.ITEM_CESS_RATE                L2_CESS_RATE,
       D.ITEM_CESS_AMOUNT              L2_CESS_AMOUNT,
       D.ITEM_VAT_RATE                 L2_VAT_RATE,
       D.ITEM_VAT_AMOUNT               L2_VAT_AMOUNT,
       D.ITEM_BATCH_SERIAL_STRING      L2_BATCH_SERIAL_STRING,
       D.SALES_CHARGE_NAME             L3_SALES_CHARGE_NAME,
       D.DISPLAY_SEQUENCE              L3_DISPLAY_SEQUENCE,
       D.CHARGE_RATE                   L3_CHARGE_RATE,
       D.CHARGE_AMOUNT                 L3_CHARGE_AMOUNT,
       D.CHARGE_BASIS                  L3_CHARGE_BASIS,
       D.CHARGE_APPLICABLE_ON          L3_CHARGE_APPLICABLE_ON,
       D.OPERATION_LEVEL               L3_OPERATION_LEVEL,
       D.HSN_ORDER_QUANTITY            L4_ORDER_QUANTITY,
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
       D.GST_ORDER_QUANTITY            L5_GST_ORDER_QUANTITY,
       D.GST_TAXABLE_AMOUNT            L5_GST_TAXABLE_AMOUNT,
       D.GST_RATE                      L5_GST_RATE,
       D.GST_CGST_AMOUNT               L5_GST_CGST_AMOUNT,
       D.GST_SGST_AMOUNT               L5_GST_SGST_AMOUNT,
       D.GST_IGST_AMOUNT               L5_GST_IGST_AMOUNT
  FROM (                                                       /*Header Part*/
        SELECT M.ORDCODE                         ORDCODE,
               M.ORDDT                           ORDER_DATE,
               M.PCODE                           PCODE,
               M.DOCNO                           DOCUMENT_NO,
               M.DOCDT                           DOCUMENT_DATE,
               M.AGCODE                          AGCODE,
               AG.SLNAME                         AGENT_NAME,
               M.AGRATE                          AGENT_RATE,
               M.TRPCODE                         TRPCODE,
               TR.SLNAME                         TRANSPORTER_NAME,
               M.DUEDT                           DUE_DATE,
               INITCAP (
                  CASE
                     WHEN COALESCE (M.STAT, 'T') = 'T'
                     THEN
                        'TOTAL PROCESSED'
                     WHEN COALESCE (M.STAT, 'T') = 'P'
                     THEN
                        'PARTIAL PROCESSED'
                     WHEN COALESCE (M.STAT, 'T') = 'N'
                     THEN
                        'NEW'
                  END)
                  STATUS,
               AU.FNAME || ' [' || AU.ENO || ']' AUTHORIZED_BY,
               M.REM                             REMARKS,
               CR.FNAME || ' [' || CR.ENO || ']' CREATED_BY,
               M.TIME                            CREATED_ON,
               M.SCHEME_DOCNO                    ORDER_NO,
               M.ADMOU_CODE                      ADMOU_CODE,
               M.ADMSITE_CODE                    ADMSITE_CODE,
               INITCAP (
                  CASE
                     WHEN COALESCE (M.PRICETYPE, 'M') = 'M'
                     THEN
                        'RSP'
                     WHEN COALESCE (M.PRICETYPE, 'M') = 'L'
                     THEN
                        'MRP'
                     WHEN COALESCE (M.PRICETYPE, 'M') = 'W'
                     THEN
                        'WSP'
                     WHEN COALESCE (M.PRICETYPE, 'M') = 'C'
                     THEN
                        'EFFECTIVE RATE (LAST LANDING COST)'
                     WHEN COALESCE (M.PRICETYPE, 'M') = 'R'
                     THEN
                        'STANDARD RATE'
                     WHEN COALESCE (M.PRICETYPE, 'M') = 'B'
                     THEN
                        'BASIC RATE (LAST PURCHASE)'
                  END)
                  PRICE_TYPE,
               PR.PRICELISTNAME                  PRICE_LIST_NAME,
               M.DISCOUNT_FACTOR                 DISCOUNT_FACTOR,
               M.PRICE_ROUNDOFF                  PRICE_ROUND_OFF,
               INITCAP (
                  CASE
                     WHEN COALESCE (M.ROUNDOFF_LIMIT, 'N') = 'N' THEN 'NO'
                     WHEN COALESCE (M.ROUNDOFF_LIMIT, 'N') = 'Y' THEN 'YES'
                  END)
                  PRICE_ROUND_OFF_LIMIT,
               M.ADMSITE_CODE_OWNER              ADMSITE_CODE_OWNER,
               INITCAP (
                  CASE
                     WHEN COALESCE (M.INCL_VAT_IN_DIST, 'N') = 'N' THEN 'NO'
                     WHEN COALESCE (M.INCL_VAT_IN_DIST, 'N') = 'Y' THEN 'YES'
                  END)
                  PRICE_INCLUSION_OF_TAX,
               INITCAP (
                  CASE
                     WHEN COALESCE (M.DISCOUNT_MODE, 'U') = 'U'
                     THEN
                        'MARKUP'
                     WHEN COALESCE (M.DISCOUNT_MODE, 'U') = 'D'
                     THEN
                        'MARKDOWN'
                  END)
                  PRICE_MODE,
               INITCAP (
                  CASE
                     WHEN COALESCE (M.DISCOUNT_BASIS, 'N') = 'B'
                     THEN
                        'ON BASE PRICE'
                     WHEN COALESCE (M.DISCOUNT_BASIS, 'N') = 'N'
                     THEN
                        'ON NET PRICE'
                  END)
                  PRICE_BASIS,
               ST.SALTERMNAME                    SALES_TERM,
               M.GRSAMT                          INV_GROSS_AMOUNT,
               M.CHGAMT                          INV_CHARGE_AMOUNT,
               M.NETAMT                          INV_NET_AMOUNT,
               TD.NAME                           TRADE_GROUP_NAME,
               POS.ORDERNO                       STORE_POS_ORDER_NO,
               POS.ORDERDATE                     STORE_POS_ORDER_DATE,
               M.POS_REMARKS                     STORE_POS_ORDER_REMARKS,
               INITCAP (
                  CASE
                     WHEN COALESCE (M.CMPTAX_CODE_BASIS, 'D') = 'S'
                     THEN
                        'SOURCE'
                     WHEN COALESCE (M.CMPTAX_CODE_BASIS, 'D') = 'D'
                     THEN
                        'DESTINATION'
                  END)
                  TAX_BASED_ON,
               M.AUTHORIZATIONTIME               AUTHORIZED_ON,
               LA.FNAME || ' [' || LA.ENO || ']' LAST_ACCESSED_BY,
               M.LAST_ACCESS_TIME                LAST_ACCESSED_ON,
               INITCAP (
                  CASE
                     WHEN M.ISHOLD = 'Y' THEN 'YES'
                     WHEN M.ISHOLD = 'N' THEN 'NO'
                  END)
                  ON_HOLD,
               HB.FNAME || ' [' || HB.ENO || ']' HELD_BY,
               M.HELDON                          HELD_ON,
               INITCAP (
                  CASE WHEN M.RESERVE_INV = 'Y' THEN 'YES' ELSE 'NO' END)
                  AGAINST_RESERVATION,
               (SELECT LISTAGG (SCHEME_DOCNO, ', ')
                          WITHIN GROUP (ORDER BY SCHEME_DOCNO)
                  FROM INVDCMAIN DCH,
                       (SELECT DISTINCT DCCODE
                          FROM INVDCDET
                         WHERE ORDCODE = M.ORDCODE) DCD
                 WHERE DCH.DCCODE = DCD.DCCODE)
                  CHALLAN_NO,
               M.UDFSTRING01                     SALORDMAIN_UDFSTRING01,
               M.UDFSTRING02                     SALORDMAIN_UDFSTRING02,
               M.UDFSTRING03                     SALORDMAIN_UDFSTRING03,
               M.UDFSTRING04                     SALORDMAIN_UDFSTRING04,
               M.UDFSTRING05                     SALORDMAIN_UDFSTRING05,
               M.UDFSTRING06                     SALORDMAIN_UDFSTRING06,
               M.UDFSTRING07                     SALORDMAIN_UDFSTRING07,
               M.UDFSTRING08                     SALORDMAIN_UDFSTRING08,
               M.UDFSTRING09                     SALORDMAIN_UDFSTRING09,
               M.UDFSTRING10                     SALORDMAIN_UDFSTRING10,
               M.UDFNUM01                        SALORDMAIN_UDFNUM01,
               M.UDFNUM02                        SALORDMAIN_UDFNUM02,
               M.UDFNUM03                        SALORDMAIN_UDFNUM03,
               M.UDFNUM04                        SALORDMAIN_UDFNUM04,
               M.UDFNUM05                        SALORDMAIN_UDFNUM05,
               M.UDFDATE01                       SALORDMAIN_UDFDATE01,
               M.UDFDATE02                       SALORDMAIN_UDFDATE02,
               M.UDFDATE03                       SALORDMAIN_UDFDATE03,
               M.UDFDATE04                       SALORDMAIN_UDFDATE04,
               M.UDFDATE05                       SALORDMAIN_UDFDATE05,
               CASE
                  WHEN M.SALETYPE = 'O' THEN 'SALES ORDER'
                  ELSE 'TRANSFER ORDER'
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
               CUST_GST_STATE_NAME,
               CUST_GST_STATE_CODE,
               OU.NAME                           ORGUNIT_NAME,
               OU.WEBSITE                        ORGUNIT_WEBSITE,
               OU.CINNO                          ORGUNIT_CIN,
               OS.NAME                           OWNER_SITE_NAME,
               OS.SHORT_CODE                     OWNER_SHORT_CODE,
               OS.ADDRESS                        OWNER_SITE_ADDRESS,
               OS.CITY                           OWNER_SITE_CITY,
               OS.PINCODE                        OWNER_SITE_PINCODE,
               OS.PHONE1                         OWNER_SITE_PHONE1,
               OS.PHONE2                         OWNER_SITE_PHONE2,
               OS.PHONE3                         OWNER_SITE_PHONE3,
               OS.EMAIL1                         OWNER_SITE_EMAIL1,
               OS.EMAIL2                         OWNER_SITE_EMAIL2,
               OS.WEBSITE                        OWNER_SITE_WEBSITE,
               OS.GST_IDENTIFICATION_NO          OWNER_GST_IDENTIFICATION_NO,
               OS.GST_STATE_CODE                 OWNER_GST_STATE_CODE,
               OS.GST_STATE_NAME                 OWNER_GST_STATE_NAME,
               RS.NAME                           REFSITE_NAME,
               RS.SHORT_CODE                     REFSITE_SHORT_CODE,
               RS.ADDRESS                        REFSITE_ADDRESS,
               RS.CITY                           REFSITE_CITY,
               RS.PINCODE                        REFSITE_PINCODE,
               RS.PHONE1                         REFSITE_PHONE1,
               RS.PHONE2                         REFSITE_PHONE2,
               RS.PHONE3                         REFSITE_PHONE3,
               RS.EMAIL1                         REFSITE_EMAIL,
               RS.GST_IDENTIFICATION_NO          REFSITE_GSTIN_NO,
               RS.GST_STATE_CODE                 REFSITE_GST_STATE_CODE,
               RS.GST_STATE_NAME                 REFSITE_GST_STATE_NAME,
               RS.SHIPPING_COMPANY_NAME
                  REFSITE_SHIPPING_COMPANY_NAME,
               RS.SHIPPING_ADDRESS               REFSITE_SHIPPING_ADDRESS,
               RS.SHIPPING_CITY                  REFSITE_SHIPPING_CITY,
               RS.SHIPPING_PINCODE               REFSITE_SHIPPING_PINCODE,
               RS.SHIPPING_PHONE1                REFSITE_SHIPPING_PHONE1,
               RS.SHIPPING_PHONE2                REFSITE_SHIPPING_PHONE2,
               RS.SHIPPING_PHONE3                REFSITE_SHIPPING_PHONE3,
               RS.SHIPPING_EMAIL1                REFSITE_SHIPPING_EMAIL1,
               RS.SHIPPING_GST_IDENTIFICATION_NO REFSITE_SHIP_GSTIN_NO,
               RS.SHIPPING_GST_STATE_CODE        REFSITE_SHIP_GST_STATE_CODE,
               RS.SHIPPING_GST_STATE_NAME        REFSITE_SHIP_GST_STATE_NAME
          FROM SALORDMAIN M
               INNER JOIN HRDEMP CR ON (M.ECODE = CR.ECODE)
               /*Start Bug : 112160*/
               LEFT OUTER JOIN ADMOU OU ON (M.ADMOU_CODE = OU.CODE)
               /*Chnage the join type inner to left outer - End Bug : 112160*/
               INNER JOIN SITE_DATA OS
                  ON (M.ADMSITE_CODE_OWNER = OS.SITECODE)
               LEFT OUTER JOIN SITE_DATA RS ON (M.ADMSITE_CODE = RS.SITECODE) /*ADO Id : 81406*/
               INNER JOIN ADMYEAR YR ON (M.YCODE = YR.YCODE)
               LEFT OUTER JOIN FINSL AG ON (M.AGCODE = AG.SLCODE)
               LEFT OUTER JOIN FINSL TR ON (M.TRPCODE = TR.SLCODE)
               LEFT OUTER JOIN HRDEMP LA ON (LAST_ACCESS_ECODE = LA.ECODE)
               LEFT OUTER JOIN HRDEMP AU ON (AUTHORCODE = AU.ECODE)
               LEFT OUTER JOIN HRDEMP HB ON (HELDBY = HB.ECODE)
               LEFT OUTER JOIN SALPRICELISTMAIN PR
                  ON (M.PRICELISTCODE = PR.PRICELISTCODE)
               LEFT OUTER JOIN SALTERMMAIN ST
                  ON (M.SALTERMCODE = ST.SALTERMCODE)
               LEFT OUTER JOIN FINTRADEGRP TD
                  ON (M.SALTRADEGRP_CODE = TD.CODE)
               LEFT OUTER JOIN PSITE_POSORDER POS
                  ON (PSITE_POSORDER_CODE = POS.CODE)
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
                       GTE.NAME              CUST_GST_STATE_NAME,
                       S.CP_GSTIN_STATE_CODE CUST_GST_STATE_CODE
                  FROM FINSL S
                       LEFT OUTER JOIN ADMCITY BCT ON S.BCTNAME = BCT.CTNAME
                       LEFT OUTER JOIN ADMGSTSTATE GTE
                          ON S.CP_GSTIN_STATE_CODE = GTE.CODE) CUS
                  ON (M.PCODE = CUS.SLCODE)
         WHERE (   M.ORDCODE IN
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
        SELECT 'L2#DETAIL'                   LVL,
               1                             SEQ,
               ORDCODE,
               ICODE,
               BARCODE,
               DIVISION,
               SECTION,
               DEPARTMENT,
               ARTICLE_NAME                  ITEM_ARTICLE_NAME,
               ITEM_MANAGEMENT_MODE,
               CATEGORY1                     ITEM_CATEGORY1,
               CATEGORY2                     ITEM_CATEGORY2,
               CATEGORY3                     ITEM_CATEGORY3,
               CATEGORY4                     ITEM_CATEGORY4,
               CATEGORY5                     ITEM_CATEGORY5,
               CATEGORY6                     ITEM_CATEGORY6,
               MRP                           ITEM_MRP,
               RSP                           ITEM_RSP,
               WSP                           ITEM_WSP,
               STANDARD_RATE                 ITEM_STANDARD_RATE,
               UOM                           ITEM_UOM,
               ITEM_NAME,
               I.HSN_CODE                    ITEM_HSN,
               ORDERED_QUANTITY              ITEM_ORD_QTY,
               CANCELLED_QUANTITY            ITEM_CANCEL_QTY,
               ORDER_RATE                    ITEM_ORD_RATE,
               RESERVED_QUANTITY             ITEM_RESERVED_QTY,
               PICK_LIST_QUANTITY            ITEM_PICK_LIST_QTY,
               PICK_CONFIRM_QUANTITY         ITEM_PICK_CONFIRM_QTY,
               DELIVERED_QUANTITY            ITEM_DELIVERED_QTY,
               ORIGINAL_ORDERED_QUANTITY     ITEM_ORIGINAL_ORD_QTY,
               INVOICED_QUANTITY             ITEM_INVOICED_QTY,
               ITEM_REMARKS,
               DISCOUNT_FACTOR               ITEM_DISCOUNT_FACTOR,
               ITEM_DISCOUNT_AMOUNT,
               ORDER_BASIC_RATE              ITEM_ORD_BASIC_RATE,
               ITEM_ROUND_OFF_AMOUNT         ITEM_ROUND_OFF_AMOUNT,
               CASE
                  WHEN ITEM_GROSS_AMOUNT IS NULL
                  THEN
                     (NVL (ORDERED_QUANTITY, 0) * NVL (ORDER_RATE, 0))
                  ELSE
                     ITEM_GROSS_AMOUNT
               END
                  ITEM_GROSS_AMOUNT,                         /*BUG ID 109779*/
               OTHER_CHARGE_AMOUNT           ITEM_OTHER_CHARGE_AMOUNT,
               TAX_CHARGE_AMOUNT             ITEM_TAX_CHARGE_AMOUNT,
               ITEM_NET_AMOUNT               ITEM_NET_AMOUNT,
               ITEM_TAX_RATE                 ITEM_TAX_RATE,
               ORDER_RSP                     ITEM_ORD_RSP,
               STORE_POS_ORDER_REMARKS       ITEM_STORE_POS_ORD_REMARKS,
               STORE_POS_ORDER_CANCELLED_QTY ITEM_STORE_POS_ORD_CANCEL_QTY,
               STORE_POS_ORDER_CANCELLED_REM ITEM_STORE_POS_ORD_CANCEL_REM,
               TAXABLE_AMOUNT                ITEM_TAXABLE_AMOUNT,
               CGST_RATE                     ITEM_CGST_RATE,
               CGST_AMOUNT                   ITEM_CGST_AMOUNT,
               SGST_RATE                     ITEM_SGST_RATE,
               SGST_AMOUNT                   ITEM_SGST_AMOUNT,
               IGST_RATE                     ITEM_IGST_RATE,
               IGST_AMOUNT                   ITEM_IGST_AMOUNT,
               CESS_RATE                     ITEM_CESS_RATE,
               CESS_AMOUNT                   ITEM_CESS_AMOUNT,
               VAT_RATE                      ITEM_VAT_RATE,
               VAT_AMOUNT                    ITEM_VAT_AMOUNT,
               GINVIEW.FNC_GET_BATCH_STRING (ORDCODE,
                                             ICODE,
                                             ORDER_RATE,
                                             'SALORDDET')    /*Bug Id 108209*/
                  ITEM_BATCH_SERIAL_STRING,
               NULL                          SALES_CHARGE_NAME,
               NULL                          DISPLAY_SEQUENCE,
               NULL                          CHARGE_RATE,
               NULL                          CHARGE_AMOUNT,
               NULL                          CHARGE_BASIS,
               NULL                          CHARGE_APPLICABLE_ON,
               NULL                          OPERATION_LEVEL,
               NULL                          HSN_ORDER_QUANTITY,
               NULL                          HSN_CODE,
               NULL                          HSN_SAC_ID,
               NULL                          HSN_DESCRIPTION,
               NULL                          HSN_UOM,
               NULL                          HSN_TAXABLE_AMOUNT,
               NULL                          HSN_CGST_RATE,
               NULL                          HSN_CGST_AMOUNT,
               NULL                          HSN_SGST_RATE,
               NULL                          HSN_SGST_AMOUNT,
               NULL                          HSN_IGST_RATE,
               NULL                          HSN_IGST_AMOUNT,
               NULL                          HSN_CESS_RATE,
               NULL                          HSN_CESS_AMOUNT,
               NULL                          GST_ORDER_QUANTITY,
               NULL                          GST_TAXABLE_AMOUNT,
               NULL                          GST_RATE,
               NULL                          GST_CGST_AMOUNT,
               NULL                          GST_SGST_AMOUNT,
               NULL                          GST_IGST_AMOUNT
          FROM (  SELECT ORDCODE                 ORDCODE,
                         M.ICODE                 ICODE,
                         SUM (ORDQTY)            ORDERED_QUANTITY,
                         SUM (CNLQTY)            CANCELLED_QUANTITY,
                         RATE                    ORDER_RATE,
                         SUM (RESERVE_QTY)       RESERVED_QUANTITY,
                         SUM (PICKLIST_QTY)      PICK_LIST_QUANTITY,
                         SUM (CONFIRM_QTY)       PICK_CONFIRM_QUANTITY,
                         SUM (DQTY)              DELIVERED_QUANTITY,
                         SUM (OQTY)              ORIGINAL_ORDERED_QUANTITY,
                         SUM (INVQTY)            INVOICED_QUANTITY,
                         REM                     ITEM_REMARKS,
                         FACTOR                  DISCOUNT_FACTOR,
                         SUM (DISCOUNT)          ITEM_DISCOUNT_AMOUNT,
                         BASIC_RATE              ORDER_BASIC_RATE,
                         SUM (ROUNDOFF)          ITEM_ROUND_OFF_AMOUNT,
                         SUM (NETAMT)            ITEM_GROSS_AMOUNT,
                         SUM (OTHER_CHARGE_AMOUNT) OTHER_CHARGE_AMOUNT,
                         SUM (TAX_CHARGE_AMOUNT) TAX_CHARGE_AMOUNT,
                         /*Start Bug : 60348,83453*/
                         CASE
                            WHEN SUM (COALESCE (NETAMT, 0)) = 0
                            THEN
                                 (  SUM (ORDQTY * RATE)
                                  + SUM (COALESCE (OTX.OTHER_CHARGE_AMOUNT, 0)))
                               + SUM (COALESCE (TAX.TAX_CHARGE_AMOUNT, 0))
                            ELSE
                               SUM (COALESCE (NETAMT, 0))
                         END
                            ITEM_NET_AMOUNT,
                         /*End Bug : 60348,83453*/
                         SUM (ITEM_TAX_RATE)     ITEM_TAX_RATE,
                         RSP                     ORDER_RSP,
                         POS_REMARKS             STORE_POS_ORDER_REMARKS,
                         SUM (POS_CNLQTY)
                            STORE_POS_ORDER_CANCELLED_QTY,
                         POS_CANCELLATIONREMARKS
                            STORE_POS_ORDER_CANCELLED_REM,
                         SUM (TAXABLE_AMOUNT)    TAXABLE_AMOUNT,
                         CGST_RATE,
                         SUM (CGST_AMOUNT)       CGST_AMOUNT,
                         SGST_RATE,
                         SUM (SGST_AMOUNT)       SGST_AMOUNT,
                         IGST_RATE,
                         SUM (IGST_AMOUNT)       IGST_AMOUNT,
                         CESS_RATE,
                         SUM (CESS_AMOUNT)       CESS_AMOUNT,
                         VAT_RATE,
                         SUM (VAT_AMOUNT)        VAT_AMOUNT
                    FROM (SELECT *
                            FROM SALORDDET
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
                                        0) = 0)) M
                         LEFT OUTER JOIN
                         (  SELECT ORDDET_CODE, SUM (PICKLIST_QTY) PICKLIST_QTY
                              FROM INVRESERVEDET
                          GROUP BY ORDDET_CODE) B
                            ON (M.CODE = B.ORDDET_CODE)
                         LEFT OUTER JOIN
                         (  SELECT ORDDET_CODE, SUM (CONFIRM_QTY) CONFIRM_QTY
                              FROM INVPICKLISTDET
                          GROUP BY ORDDET_CODE) C
                            ON (M.CODE = C.ORDDET_CODE)
                         LEFT OUTER JOIN
                         (  SELECT SALORDDET_CODE,
                                   SUM (COALESCE (CHGAMT, 0)) OTHER_CHARGE_AMOUNT
                              FROM SALORDCHG_ITEM
                             WHERE     ISTAX = 'N'
                                   AND (   ORDCODE IN
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
                          GROUP BY SALORDDET_CODE) OTX
                            ON (M.CODE = OTX.SALORDDET_CODE)
                         LEFT OUTER JOIN
                         (  SELECT SALORDDET_CODE,
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
                                      CESS_AMOUNT,
                                   SUM (
                                      CASE WHEN SOURCE = 'V' THEN RATE ELSE 0 END)
                                      VAT_RATE,
                                   SUM (
                                      CASE
                                         WHEN SOURCE = 'V' THEN CHGAMT
                                         ELSE 0
                                      END)
                                      VAT_AMOUNT
                              FROM SALORDCHG_ITEM
                             WHERE     ISTAX = 'Y'
                                   AND (   ORDCODE IN
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
                          GROUP BY SALORDDET_CODE, APPAMT) TAX
                            ON (M.CODE = TAX.SALORDDET_CODE)
                GROUP BY ORDCODE,
                         M.ICODE,
                         RATE,
                         REM,
                         FACTOR,
                         BASIC_RATE,
                         RSP,
                         POS_REMARKS,
                         POS_CANCELLATIONREMARKS,
                         CGST_RATE,
                         SGST_RATE,
                         IGST_RATE,
                         CESS_RATE,
                         VAT_RATE) D
               INNER JOIN GINVIEW.INVITEM_AGG I ON (D.ICODE = I.CODE)
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
        /*Charge Part*/
        SELECT 'L3#CHARGE' LVL,
               2           SEQ,
               ORDCODE     ORDCODE,
               NULL        ICODE,
               NULL        BARCODE,
               NULL        DIVISION,
               NULL        SECTION,
               NULL        DEPARTMENT,
               NULL        ITEM_ARTICLE_NAME,
               NULL        ITEM_MANAGEMENT_MODE,
               NULL        ITEM_CATEGORY1,
               NULL        ITEM_CATEGORY2,
               NULL        ITEM_CATEGORY3,
               NULL        ITEM_CATEGORY4,
               NULL        ITEM_CATEGORY5,
               NULL        ITEM_CATEGORY6,
               NULL        ITEM_MRP,
               NULL        ITEM_RSP,
               NULL        ITEM_WSP,
               NULL        ITEM_STANDARD_RATE,
               NULL        ITEM_UOM,
               NULL        ITEM_NAME,
               NULL        ITEM_HSN,
               NULL        ITEM_ORD_QTY,
               NULL        ITEM_CANCEL_QTY,
               NULL        ITEM_ORD_RATE,
               NULL        ITEM_RESERVED_QTY,
               NULL        ITEM_PICK_LIST_QTY,
               NULL        ITEM_PICK_CONFIRM_QTY,
               NULL        ITEM_DELIVERED_QTY,
               NULL        ITEM_ORIGINAL_ORD_QTY,
               NULL        ITEM_INVOICED_QTY,
               NULL        ITEM_REMARKS,
               NULL        ITEM_DISCOUNT_FACTOR,
               NULL        ITEM_DISCOUNT_AMOUNT,
               NULL        ITEM_ORD_BASIC_RATE,
               NULL        ITEM_ROUND_OFF_AMOUNT,
               NULL        ITEM_GROSS_AMOUNT,
               NULL        ITEM_OTHER_CHARGE_AMOUNT,
               NULL        ITEM_TAX_CHARGE_AMOUNT,
               NULL        ITEM_NET_AMOUNT,
               NULL        ITEM_TAX_RATE,
               NULL        ITEM_ORD_RSP,
               NULL        ITEM_STORE_POS_ORD_REMARKS,
               NULL        ITEM_STORE_POS_ORD_CANCEL_QTY,
               NULL        ITEM_STORE_POS_ORD_CANCEL_REM,
               NULL        ITEM_TAXABLE_AMOUNT,
               NULL        ITEM_CGST_RATE,
               NULL        ITEM_CGST_AMOUNT,
               NULL        ITEM_SGST_RATE,
               NULL        ITEM_SGST_AMOUNT,
               NULL        ITEM_IGST_RATE,
               NULL        ITEM_IGST_AMOUNT,
               NULL        ITEM_CESS_RATE,
               NULL        ITEM_CESS_AMOUNT,
               NULL        ITEM_VAT_RATE,
               NULL        ITEM_VAT_AMOUNT,
               NULL        ITEM_BATCH_SERIAL_STRING,
               SALCHGNAME  SALES_CHARGE_NAME,
               SEQ         DISPLAY_SEQUENCE,
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
                     WHEN COALESCE (A.OPERATION_LEVEL, 'H') = 'H'
                     THEN
                        'HEADER'
                     WHEN COALESCE (A.OPERATION_LEVEL, 'H') = 'L'
                     THEN
                        'LINE'
                  END)
                  OPERATION_LEVEL,
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
               NULL        GST_ORDER_QUANTITY,
               NULL        GST_TAXABLE_AMOUNT,
               NULL        GST_RATE,
               NULL        GST_CGST_AMOUNT,
               NULL        GST_SGST_AMOUNT,
               NULL        GST_IGST_AMOUNT
          FROM SALORDCHG A INNER JOIN SALCHG B ON (CHGCODE = SALCHGCODE)
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
                 ORDCODE            ORDCODE,
                 NULL               ICODE,
                 NULL               BARCODE,
                 NULL               DIVISION,
                 NULL               SECTION,
                 NULL               DEPARTMENT,
                 NULL               ITEM_ARTICLE_NAME,
                 NULL               ITEM_MANAGEMENT_MODE,
                 NULL               ITEM_CATEGORY1,
                 NULL               ITEM_CATEGORY2,
                 NULL               ITEM_CATEGORY3,
                 NULL               ITEM_CATEGORY4,
                 NULL               ITEM_CATEGORY5,
                 NULL               ITEM_CATEGORY6,
                 NULL               ITEM_MRP,
                 NULL               ITEM_RSP,
                 NULL               ITEM_WSP,
                 NULL               ITEM_STANDARD_RATE,
                 NULL               ITEM_UOM,
                 NULL               ITEM_NAME,
                 NULL               ITEM_HSN,
                 NULL               ITEM_ORD_QTY,
                 NULL               ITEM_CANCEL_QTY,
                 NULL               ITEM_ORD_RATE,
                 NULL               ITEM_RESERVED_QTY,
                 NULL               ITEM_PICK_LIST_QTY,
                 NULL               ITEM_PICK_CONFIRM_QTY,
                 NULL               ITEM_DELIVERED_QTY,
                 NULL               ITEM_ORIGINAL_ORD_QTY,
                 NULL               ITEM_INVOICED_QTY,
                 NULL               ITEM_REMARKS,
                 NULL               ITEM_DISCOUNT_FACTOR,
                 NULL               ITEM_DISCOUNT_AMOUNT,
                 NULL               ITEM_ORD_BASIC_RATE,
                 NULL               ITEM_ROUND_OFF_AMOUNT,
                 NULL               ITEM_GROSS_AMOUNT,
                 NULL               ITEM_OTHER_CHARGE_AMOUNT,
                 NULL               ITEM_TAX_CHARGE_AMOUNT,
                 NULL               ITEM_NET_AMOUNT,
                 NULL               ITEM_TAX_RATE,
                 NULL               ITEM_ORD_RSP,
                 NULL               ITEM_STORE_POS_ORD_REMARKS,
                 NULL               ITEM_STORE_POS_ORD_CANCEL_QTY,
                 NULL               ITEM_STORE_POS_ORD_CANCEL_REM,
                 NULL               ITEM_TAXABLE_AMOUNT,
                 NULL               ITEM_CGST_RATE,
                 NULL               ITEM_CGST_AMOUNT,
                 NULL               ITEM_SGST_RATE,
                 NULL               ITEM_SGST_AMOUNT,
                 NULL               ITEM_IGST_RATE,
                 NULL               ITEM_IGST_AMOUNT,
                 NULL               ITEM_CESS_RATE,
                 NULL               ITEM_CESS_AMOUNT,
                 NULL               ITEM_VAT_RATE,
                 NULL               ITEM_VAT_AMOUNT,
                 NULL               ITEM_BATCH_SERIAL_STRING,
                 NULL               SALES_CHARGE_NAME,
                 NULL               DISPLAY_SEQUENCE,
                 NULL               CHARGE_RATE,
                 NULL               CHARGE_AMOUNT,
                 NULL               CHARGE_BASIS,
                 NULL               CHARGE_APPLICABLE_ON,
                 NULL               OPERATION_LEVEL,
                 SUM (ORDQTY)       HSN_ORDER_QUANTITY,
                 GOVT_IDENTIFIER    HSN_CODE,
                 HSN_SAC_CODE       HSN_SAC_ID,
                 DESCRIPTION        HSN_DESCRIPTION,
                 UNITNAME           HSN_UOM,
                 SUM (TAXABLE_AMOUNT) HSN_TAXABLE_AMOUNT,
                 CGST_RATE          HSN_CGST_RATE,
                 SUM (CGST_AMOUNT)  HSN_CGST_AMOUNT,
                 SGST_RATE          HSN_SGST_RATE,
                 SUM (SGST_AMOUNT)  HSN_SGST_AMOUNT,
                 IGST_RATE          HSN_IGST_RATE,
                 SUM (IGST_AMOUNT)  HSN_IGST_AMOUNT,
                 CESS_RATE          HSN_CESS_RATE,
                 SUM (CESS_AMOUNT)  HSN_CESS_AMOUNT,
                 NULL               GST_ORDER_QUANTITY,
                 NULL               GST_TAXABLE_AMOUNT,
                 NULL               GST_RATE,
                 NULL               GST_CGST_AMOUNT,
                 NULL               GST_SGST_AMOUNT,
                 NULL               GST_IGST_AMOUNT
            FROM (SELECT *
                    FROM SALORDDET
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
                 INNER JOIN INVITEM I ON (D.ICODE = I.ICODE)
                 LEFT OUTER JOIN
                 (  SELECT SALORDDET_CODE,
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
                      FROM SALORDCHG_ITEM
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
                  GROUP BY SALORDDET_CODE, APPAMT) TAX
                    ON (D.CODE = SALORDDET_CODE)
                 INNER JOIN INVHSNSACMAIN H ON (INVHSNSACMAIN_CODE = H.CODE)
           WHERE (   D.ORDCODE IN
                        (    SELECT REGEXP_SUBSTR ('@DocumentId@',
                                                   '[^|~|]+',
                                                   1,
                                                   LEVEL)
                                       COL1
                               FROM DUAL
                         CONNECT BY LEVEL <=
                                       REGEXP_COUNT ('@DocumentId@', '|~|') + 1)
                  OR NVL (REGEXP_COUNT ('@DocumentId@', '|~|') + 1, 0) = 0)
        GROUP BY ORDCODE,
                 GOVT_IDENTIFIER,
                 HSN_SAC_CODE,
                 DESCRIPTION,
                 UNITNAME,
                 CGST_RATE,
                 SGST_RATE,
                 IGST_RATE,
                 CESS_RATE
        UNION ALL
          /*HSN Part*/
          SELECT 'L5#GST'           LVL,
                 4                  SEQ,
                 ORDCODE            ORDCODE,
                 NULL               ICODE,
                 NULL               BARCODE,
                 NULL               DIVISION,
                 NULL               SECTION,
                 NULL               DEPARTMENT,
                 NULL               ITEM_ARTICLE_NAME,
                 NULL               ITEM_MANAGEMENT_MODE,
                 NULL               ITEM_CATEGORY1,
                 NULL               ITEM_CATEGORY2,
                 NULL               ITEM_CATEGORY3,
                 NULL               ITEM_CATEGORY4,
                 NULL               ITEM_CATEGORY5,
                 NULL               ITEM_CATEGORY6,
                 NULL               ITEM_MRP,
                 NULL               ITEM_RSP,
                 NULL               ITEM_WSP,
                 NULL               ITEM_STANDARD_RATE,
                 NULL               ITEM_UOM,
                 NULL               ITEM_NAME,
                 NULL               ITEM_HSN,
                 NULL               ITEM_ORD_QTY,
                 NULL               ITEM_CANCEL_QTY,
                 NULL               ITEM_ORD_RATE,
                 NULL               ITEM_RESERVED_QTY,
                 NULL               ITEM_PICK_LIST_QTY,
                 NULL               ITEM_PICK_CONFIRM_QTY,
                 NULL               ITEM_DELIVERED_QTY,
                 NULL               ITEM_ORIGINAL_ORD_QTY,
                 NULL               ITEM_INVOICED_QTY,
                 NULL               ITEM_REMARKS,
                 NULL               ITEM_DISCOUNT_FACTOR,
                 NULL               ITEM_DISCOUNT_AMOUNT,
                 NULL               ITEM_ORD_BASIC_RATE,
                 NULL               ITEM_ROUND_OFF_AMOUNT,
                 NULL               ITEM_GROSS_AMOUNT,
                 NULL               ITEM_OTHER_CHARGE_AMOUNT,
                 NULL               ITEM_TAX_CHARGE_AMOUNT,
                 NULL               ITEM_NET_AMOUNT,
                 NULL               ITEM_TAX_RATE,
                 NULL               ITEM_ORD_RSP,
                 NULL               ITEM_STORE_POS_ORD_REMARKS,
                 NULL               ITEM_STORE_POS_ORD_CANCEL_QTY,
                 NULL               ITEM_STORE_POS_ORD_CANCEL_REM,
                 NULL               ITEM_TAXABLE_AMOUNT,
                 NULL               ITEM_CGST_RATE,
                 NULL               ITEM_CGST_AMOUNT,
                 NULL               ITEM_SGST_RATE,
                 NULL               ITEM_SGST_AMOUNT,
                 NULL               ITEM_IGST_RATE,
                 NULL               ITEM_IGST_AMOUNT,
                 NULL               ITEM_CESS_RATE,
                 NULL               ITEM_CESS_AMOUNT,
                 NULL               ITEM_VAT_RATE,
                 NULL               ITEM_VAT_AMOUNT,
                 NULL               ITEM_BATCH_SERIAL_STRING,
                 NULL               SALES_CHARGE_NAME,
                 NULL               DISPLAY_SEQUENCE,
                 NULL               CHARGE_RATE,
                 NULL               CHARGE_AMOUNT,
                 NULL               CHARGE_BASIS,
                 NULL               CHARGE_APPLICABLE_ON,
                 NULL               OPERATION_LEVEL,
                 NULL               HSN_ORDER_QUANTITY,
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
                 SUM (ORDQTY)       GST_ORDER_QUANTITY,
                 SUM (TAXABLE_AMOUNT) GST_TAXABLE_AMOUNT,
                   COALESCE (CGST_RATE, 0)
                 + COALESCE (SGST_RATE, 0)
                 + COALESCE (IGST_RATE, 0)
                    GST_RATE,
                 SUM (CGST_AMOUNT)  GST_CGST_AMOUNT,
                 SUM (SGST_AMOUNT)  GST_SGST_AMOUNT,
                 SUM (IGST_AMOUNT)  GST_IGST_AMOUNT
            FROM (SELECT *
                    FROM SALORDDET
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
                 LEFT OUTER JOIN
                 (  SELECT SALORDDET_CODE,
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
                      FROM SALORDCHG_ITEM
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
                  GROUP BY SALORDDET_CODE, APPAMT) TAX
                    ON (D.CODE = SALORDDET_CODE)
           WHERE (   D.ORDCODE IN
                        (    SELECT REGEXP_SUBSTR ('@DocumentId@',
                                                   '[^|~|]+',
                                                   1,
                                                   LEVEL)
                                       COL1
                               FROM DUAL
                         CONNECT BY LEVEL <=
                                       REGEXP_COUNT ('@DocumentId@', '|~|') + 1)
                  OR NVL (REGEXP_COUNT ('@DocumentId@', '|~|') + 1, 0) = 0)
        GROUP BY ORDCODE,
                   COALESCE (CGST_RATE, 0)
                 + COALESCE (SGST_RATE, 0)
                 + COALESCE (IGST_RATE, 0)) D
          ON (H.ORDCODE = D.ORDCODE)