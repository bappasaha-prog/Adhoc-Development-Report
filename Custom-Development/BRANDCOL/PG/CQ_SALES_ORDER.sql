/* Formatted on 20-02-2024 16:01:48 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_SALES_ORDER || Ticket Id : 400082 || Developer : Dipankar || ><><><*/
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
                   /*Start Bug :63055*/
                   ST.WEBSITE
                   /*End Bug :63055*/
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
SELECT GINVIEW.FNC_UK()                  UK,
       h.ORDCODE                       L1_ORDCODE,
       h.ORDER_DATE                    L1_ORDER_DATE,
       h.PCODE                         L1_PCODE,
       h.DOCUMENT_NO                   L1_DOCUMENT_NO,
       h.DOCUMENT_DATE                 L1_DOCUMENT_DATE,
       h.AGCODE                        L1_AGCODE,
       h.AGENT_NAME                    L1_AGENT_NAME,
       h.AGENT_RATE                    L1_AGENT_RATE,
       h.TRPCODE                       L1_TRPCODE,
       h.TRANSPORTER_NAME              L1_TRANSPORTER_NAME,
       h.DUE_DATE                      L1_DUE_DATE,
       h.STATUS                        L1_STATUS,
       h.AUTHORIZED_BY                 L1_AUTHORIZED_BY,
       h.REMARKS                       L1_REMARKS,
       h.CREATED_BY                    L1_CREATED_BY,
       h.CREATED_ON                    L1_CREATED_ON,
       h.ORDER_NO                      L1_ORDER_NO,
       h.ADMOU_CODE                    L1_ADMOU_CODE,
       h.ADMSITE_CODE                  L1_ADMSITE_CODE,
       h.PRICE_TYPE                    L1_PRICE_TYPE,
       h.PRICE_LIST_NAME               L1_PRICE_LIST_NAME,
       h.DISCOUNT_FACTOR               L1_DISCOUNT_FACTOR,
       h.PRICE_ROUND_OFF               L1_PRICE_ROUND_OFF,
       h.PRICE_ROUND_OFF_LIMIT         L1_PRICE_ROUND_OFF_LIMIT,
       h.ADMSITE_CODE_OWNER            L1_ADMSITE_CODE_OWNER,
       h.PRICE_INCLUSION_OF_TAX        L1_PRICE_INCLUSION_OF_TAX,
       h.PRICE_MODE                    L1_PRICE_MODE,
       h.PRICE_BASIS                   L1_PRICE_BASIS,
       h.SALES_TERM                    L1_SALES_TERM,
       h.INV_GROSS_AMOUNT              L1_INV_GROSS_AMOUNT,
       h.INV_CHARGE_AMOUNT             L1_INV_CHARGE_AMOUNT,
       h.INV_NET_AMOUNT                L1_INV_NET_AMOUNT,
       h.TRADE_GROUP_NAME              L1_TRADE_GROUP_NAME,
       h.STORE_POS_ORDER_NO            L1_STORE_POS_ORDER_NO,
       h.STORE_POS_ORDER_DATE          L1_STORE_POS_ORDER_DATE,
       h.STORE_POS_ORDER_REMARKS       L1_STORE_POS_ORDER_REMARKS,
       h.TAX_BASED_ON                  L1_TAX_BASED_ON,
       h.AUTHORIZED_ON                 L1_AUTHORIZED_ON,
       h.LAST_ACCESSED_BY              L1_LAST_ACCESSED_BY,
       h.LAST_ACCESSED_ON              L1_LAST_ACCESSED_ON,
       h.ON_HOLD                       L1_ON_HOLD,
       h.HELD_BY                       L1_HELD_BY,
       h.HELD_ON                       L1_HELD_ON,
       h.AGAINST_RESERVATION           L1_AGAINST_RESERVATION,
       h.CHALLAN_NO                    L1_CHALLAN_NO,
       h.SALORDMAIN_UDFSTRING01        L1_SALORDMAIN_UDFSTRING01,
       h.SALORDMAIN_UDFSTRING02        L1_SALORDMAIN_UDFSTRING02,
       h.SALORDMAIN_UDFSTRING03        L1_SALORDMAIN_UDFSTRING03,
       h.SALORDMAIN_UDFSTRING04        L1_SALORDMAIN_UDFSTRING04,
       h.SALORDMAIN_UDFSTRING05        L1_SALORDMAIN_UDFSTRING05,
       h.SALORDMAIN_UDFSTRING06        L1_SALORDMAIN_UDFSTRING06,
       h.SALORDMAIN_UDFSTRING07        L1_SALORDMAIN_UDFSTRING07,
       h.SALORDMAIN_UDFSTRING08        L1_SALORDMAIN_UDFSTRING08,
       h.SALORDMAIN_UDFSTRING09        L1_SALORDMAIN_UDFSTRING09,
       h.SALORDMAIN_UDFSTRING10        L1_SALORDMAIN_UDFSTRING10,
       h.SALORDMAIN_UDFNUM01           L1_SALORDMAIN_UDFNUM01,
       h.SALORDMAIN_UDFNUM02           L1_SALORDMAIN_UDFNUM02,
       h.SALORDMAIN_UDFNUM03           L1_SALORDMAIN_UDFNUM03,
       h.SALORDMAIN_UDFNUM04           L1_SALORDMAIN_UDFNUM04,
       h.SALORDMAIN_UDFNUM05           L1_SALORDMAIN_UDFNUM05,
       h.SALORDMAIN_UDFDATE01          L1_SALORDMAIN_UDFDATE01,
       h.SALORDMAIN_UDFDATE02          L1_SALORDMAIN_UDFDATE02,
       h.SALORDMAIN_UDFDATE03          L1_SALORDMAIN_UDFDATE03,
       h.SALORDMAIN_UDFDATE04          L1_SALORDMAIN_UDFDATE04,
       h.SALORDMAIN_UDFDATE05          L1_SALORDMAIN_UDFDATE05,
       h.SALETYPE                      L1_SALETYPE,
       h.CUST_NAME                     L1_CUST_NAME,
       h.CUST_BILLING_ADDRESS          L1_CUST_BILLING_ADDRESS,
       h.CUST_BILLING_CONTACT_PERSON   L1_CUST_BILLING_CONTACT_PERSON,
       h.CUST_BILLING_CITY             L1_CUST_BILLING_CITY,
       h.CUST_BILLING_STATE            L1_CUST_BILLING_STATE,
       h.CUST_BILLING_DISTRICT         L1_CUST_BILLING_DISTRICT,
       h.CUST_BILLING_ZONE             L1_CUST_BILLING_ZONE,
       h.CUST_BILLING_EMAIL1           L1_CUST_BILLING_EMAIL1,
       h.CUST_BILLING_EMAIL2           L1_CUST_BILLING_EMAIL2,
       h.CUST_BILLING_FAX              L1_CUST_BILLING_FAX,
       h.CUST_BILLING_MOBILE           L1_CUST_BILLING_MOBILE,
       h.CUST_BILLING_OFFICE_PHONE1    L1_CUST_BILLING_OFFICE_PHONE1,
       h.CUST_BILLING_OFFICE_PHONE2    L1_CUST_BILLING_OFFICE_PHONE2,
       h.CUST_BILLING_OFFICE_PHONE3    L1_CUST_BILLING_OFFICE_PHONE3,
       h.CUST_BILLING_PINCODE          L1_CUST_BILLING_PINCODE,
       h.CUST_BILLING_WEBSITE          L1_CUST_BILLING_WEBSITE,
       h.CUST_GSTIN_NO                 L1_CUST_GSTIN_NO,
       h.CUST_GST_STATE_NAME           L1_CUST_GST_STATE_NAME,
       h.CUST_GST_STATE_CODE           L1_CUST_GST_STATE_CODE,
       h.ORGUNIT_NAME                  L1_ORGUNIT_NAME,
       h.ORGUNIT_WEBSITE               L1_ORGUNIT_WEBSITE,
       h.ORGUNIT_CIN                   L1_ORGUNIT_CIN,
       h.OWNER_SITE_NAME               L1_OWNER_SITE_NAME,
       h.OWNER_SHORT_CODE              L1_OWNER_SHORT_CODE,
       h.OWNER_SITE_ADDRESS            L1_OWNER_SITE_ADDRESS,
       h.OWNER_SITE_CITY               L1_OWNER_SITE_CITY,
       h.OWNER_SITE_PINCODE            L1_OWNER_SITE_PINCODE,
       h.OWNER_SITE_PHONE1             L1_OWNER_SITE_PHONE1,
       h.OWNER_SITE_PHONE2             L1_OWNER_SITE_PHONE2,
       h.OWNER_SITE_PHONE3             L1_OWNER_SITE_PHONE3,
       h.OWNER_SITE_EMAIL1             L1_OWNER_SITE_EMAIL1,
       h.OWNER_SITE_EMAIL2             L1_OWNER_SITE_EMAIL2,
       /*Start Bug :63055*/
       h.OWNER_SITE_WEBSITE            L1_OWNER_SITE_WEBSITE,
       /*End Bug :63055*/
       h.OWNER_GST_IDENTIFICATION_NO   L1_OWNER_GST_IDENTIFICATION_NO,
       h.OWNER_GST_STATE_CODE          L1_OWNER_GST_STATE_CODE,
       h.OWNER_GST_STATE_NAME          L1_OWNER_GST_STATE_NAME,
       h.REFSITE_NAME                  L1_REFSITE_NAME,
       h.REFSITE_SHORT_CODE            L1_REFSITE_SHORT_CODE,
       h.REFSITE_ADDRESS               L1_REFSITE_ADDRESS,
       h.REFSITE_CITY                  L1_REFSITE_CITY,
       h.REFSITE_PINCODE               L1_REFSITE_PINCODE,
       h.REFSITE_PHONE1                L1_REFSITE_PHONE1,
       h.REFSITE_PHONE2                L1_REFSITE_PHONE2,
       h.REFSITE_PHONE3                L1_REFSITE_PHONE3,
       h.REFSITE_EMAIL                 L1_REFSITE_EMAIL,
       h.REFSITE_GSTIN_NO              L1_REFSITE_GSTIN_NO,
       h.REFSITE_GST_STATE_CODE        L1_REFSITE_GST_STATE_CODE,
       h.REFSITE_GST_STATE_NAME        L1_REFSITE_GST_STATE_NAME,
       h.REFSITE_SHIPPING_COMPANY_NAME L1_REFSITE_SHIP_COMPANY_NAME,
       h.REFSITE_SHIPPING_ADDRESS      L1_REFSITE_SHIP_ADDRESS,
       h.REFSITE_SHIPPING_CITY         L1_REFSITE_SHIP_CITY,
       h.REFSITE_SHIPPING_PINCODE      L1_REFSITE_SHIP_PINCODE,
       h.REFSITE_SHIPPING_PHONE1       L1_REFSITE_SHIP_PHONE1,
       h.REFSITE_SHIPPING_PHONE2       L1_REFSITE_SHIP_PHONE2,
       h.REFSITE_SHIPPING_PHONE3       L1_REFSITE_SHIP_PHONE3,
       h.REFSITE_SHIPPING_EMAIL1       L1_REFSITE_SHIP_EMAIL1,
       h.REFSITE_SHIP_GSTIN_NO         L1_REFSITE_SHIP_GSTIN_NO,
       h.REFSITE_SHIP_GST_STATE_CODE   L1_REFSITE_SHIP_GST_STATE_CODE,
       h.REFSITE_SHIP_GST_STATE_NAME   L1_REFSITE_SHIP_GST_STATE_NAME,
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
       SPLIT_PART(D.ITEM_REMARKS,',',1) L2_DISC,
       SPLIT_PART(D.ITEM_REMARKS,',',2) L2_SPDISC,
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
       D.HSN_CESS_AMOUNT               L4_CESS_AMOUNT
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
               (SELECT string_agg (scheme_docno, ', ' ORDER BY scheme_docno)
                  FROM invdcmain DCH,
                       (SELECT DISTINCT dccode
                          FROM invdcdet
                         WHERE ordcode = m.ordcode) DCD
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
                  WHEN m.SALETYPE = 'O' THEN 'SALES ORDER'
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
               ou.NAME                           ORGUNIT_NAME,
               ou.WEBSITE                        ORGUNIT_WEBSITE,
               ou.CINNO                          ORGUNIT_CIN,
               os.NAME                           OWNER_SITE_NAME,
               os.SHORT_CODE                     OWNER_SHORT_CODE,
               os.ADDRESS                        OWNER_SITE_ADDRESS,
               os.CITY                           OWNER_SITE_CITY,
               os.PINCODE                        OWNER_SITE_PINCODE,
               os.PHONE1                         OWNER_SITE_PHONE1,
               os.PHONE2                         OWNER_SITE_PHONE2,
               os.PHONE3                         OWNER_SITE_PHONE3,
               os.EMAIL1                         OWNER_SITE_EMAIL1,
               os.EMAIL2                         OWNER_SITE_EMAIL2,
               /*Start Bug :63055*/
               os.website                        OWNER_SITE_WEBSITE,
               /*End Bug :63055*/
               OS.GST_IDENTIFICATION_NO          OWNER_GST_IDENTIFICATION_NO,
               OS.GST_STATE_CODE                 OWNER_GST_STATE_CODE,
               OS.GST_STATE_NAME                 OWNER_GST_STATE_NAME,
               rs.NAME                           REFSITE_NAME,
               rs.SHORT_CODE                     REFSITE_SHORT_CODE,
               rs.ADDRESS                        REFSITE_ADDRESS,
               rs.CITY                           REFSITE_CITY,
               rs.PINCODE                        REFSITE_PINCODE,
               rs.PHONE1                         REFSITE_PHONE1,
               rs.PHONE2                         REFSITE_PHONE2,
               rs.PHONE3                         REFSITE_PHONE3,
               rs.EMAIL1                         REFSITE_EMAIL,
               rs.GST_IDENTIFICATION_NO          REFSITE_GSTIN_NO,
               rs.GST_STATE_CODE                 REFSITE_GST_STATE_CODE,
               rs.GST_STATE_NAME                 REFSITE_GST_STATE_NAME,
               rs.SHIPPING_COMPANY_NAME
                  REFSITE_SHIPPING_COMPANY_NAME,
               rs.SHIPPING_ADDRESS               REFSITE_SHIPPING_ADDRESS,
               rs.SHIPPING_CITY                  REFSITE_SHIPPING_CITY,
               rs.SHIPPING_PINCODE               REFSITE_SHIPPING_PINCODE,
               rs.SHIPPING_PHONE1                REFSITE_SHIPPING_PHONE1,
               rs.SHIPPING_PHONE2                REFSITE_SHIPPING_PHONE2,
               rs.SHIPPING_PHONE3                REFSITE_SHIPPING_PHONE3,
               rs.SHIPPING_EMAIL1                REFSITE_SHIPPING_EMAIL1,
               rs.SHIPPING_GST_IDENTIFICATION_NO REFSITE_SHIP_GSTIN_NO,
               rs.SHIPPING_GST_STATE_CODE        REFSITE_SHIP_GST_STATE_CODE,
               rs.SHIPPING_GST_STATE_NAME        REFSITE_SHIP_GST_STATE_NAME
          FROM SALORDMAIN M
               INNER JOIN HRDEMP CR ON (M.ECODE = CR.ECODE)
               /*Start Bug Id : 63057*/
               LEFT JOIN ADMOU OU ON (M.ADMOU_CODE = OU.CODE)
               /*End Bug Id : 63057*/
               INNER JOIN site_data os
                  ON (M.admsite_code_owner = os.sitecode)
               left Outer JOIN site_data rs ON (M.admsite_code = Rs.sitecode)/*ADO Id : 81406*/
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
                       S.CP_GSTIN_STATE_CODE CUST_GST_STATE_CODE
                  FROM FINSL S
                       LEFT OUTER JOIN ADMCITY BCT ON S.BCTNAME = BCT.CTNAME
                       LEFT OUTER JOIN ADMGSTSTATE GTE
                          ON S.CP_GSTIN_STATE_CODE = GTE.CODE) CUS
                  ON (M.PCODE = CUS.SLCODE)
         WHERE (m.ordcode in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)) H
       INNER JOIN
       (                                                       /*Detail Part*/
        SELECT 'L2#DETAIL'                      LVL,
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
               i.hsn_code                    item_hsn,
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
                     (coalesce (ORDERED_QUANTITY, 0) * coalesce (ORDER_RATE, 0))
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
               fnc_get_batch_string(d.ordcode::text::character varying, d.icode,d.order_rate, 'SALORDDET'::character varying)
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
               NULL                          HSN_CESS_AMOUNT
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
                           /*Start Bug : 60348*/
                         CASE
                            WHEN SUM (COALESCE (NETAMT, 0)) = 0
                            THEN
                                 (  SUM (ORDQTY * RATE)
                                  + SUM (COALESCE (CHGAMT, 0)))
                               + SUM (COALESCE (TAXAMT, 0))
                            ELSE
                               SUM (COALESCE (NETAMT, 0))
                         END
                            ITEM_NET_AMOUNT,
                         /*End Bug : 60348*/
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
                           WHERE (ordcode in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)) M
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
                                   AND (ordcode in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)
                          GROUP BY SALORDDET_CODE) OTX
                            ON (M.CODE = OTX.SALORDDET_CODE)
                         LEFT OUTER JOIN
                         (  SELECT SALORDDET_CODE,
                                   APPAMT                 TAXABLE_AMOUNT,
                                   ROUND (
                                      SUM (
                                         CASE
                                            WHEN source IN ('G', 'V')
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
                                   AND (ordcode in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)
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
                         VAT_RATE) d
               INNER JOIN main.invitem_detail_agg I ON (D.ICODE = I.CODE)
         WHERE (ordcode in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)
        UNION ALL
        /*Charge Part*/
        SELECT 'L3#CHARGE'   LVL,
               2          SEQ,
               ORDCODE    ORDCODE,
               NULL       ICODE,
               NULL       BARCODE,
               NULL       DIVISION,
               NULL       SECTION,
               NULL       DEPARTMENT,
               NULL       ITEM_ARTICLE_NAME,
               NULL       ITEM_MANAGEMENT_MODE,
               NULL       ITEM_CATEGORY1,
               NULL       ITEM_CATEGORY2,
               NULL       ITEM_CATEGORY3,
               NULL       ITEM_CATEGORY4,
               NULL       ITEM_CATEGORY5,
               NULL       ITEM_CATEGORY6,
               NULL       ITEM_MRP,
               NULL       ITEM_RSP,
               NULL       ITEM_WSP,
               NULL       ITEM_STANDARD_RATE,
               NULL       ITEM_UOM,
               NULL       ITEM_NAME,
               NULL       item_hsn,
               NULL       ITEM_ORD_QTY,
               NULL       ITEM_CANCEL_QTY,
               NULL       ITEM_ORD_RATE,
               NULL       ITEM_RESERVED_QTY,
               NULL       ITEM_PICK_LIST_QTY,
               NULL       ITEM_PICK_CONFIRM_QTY,
               NULL       ITEM_DELIVERED_QTY,
               NULL       ITEM_ORIGINAL_ORD_QTY,
               NULL       ITEM_INVOICED_QTY,
               NULL       ITEM_REMARKS,
               NULL       ITEM_DISCOUNT_FACTOR,
               NULL       ITEM_DISCOUNT_AMOUNT,
               NULL       ITEM_ORD_BASIC_RATE,
               NULL       ITEM_ROUND_OFF_AMOUNT,
               NULL       ITEM_GROSS_AMOUNT,
               NULL       ITEM_OTHER_CHARGE_AMOUNT,
               NULL       ITEM_TAX_CHARGE_AMOUNT,
               NULL       ITEM_NET_AMOUNT,
               NULL       ITEM_TAX_RATE,
               NULL       ITEM_ORD_RSP,
               NULL       ITEM_STORE_POS_ORD_REMARKS,
               NULL       ITEM_STORE_POS_ORD_CANCEL_QTY,
               NULL       ITEM_STORE_POS_ORD_CANCEL_REM,
               NULL       ITEM_TAXABLE_AMOUNT,
               NULL       ITEM_CGST_RATE,
               NULL       ITEM_CGST_AMOUNT,
               NULL       ITEM_SGST_RATE,
               NULL       ITEM_SGST_AMOUNT,
               NULL       ITEM_IGST_RATE,
               NULL       ITEM_IGST_AMOUNT,
               NULL       ITEM_CESS_RATE,
               NULL       ITEM_CESS_AMOUNT,
               NULL       ITEM_VAT_RATE,
               NULL       ITEM_VAT_AMOUNT,
               NULL       ITEM_BATCH_SERIAL_STRING,
               SALCHGNAME SALES_CHARGE_NAME,
               SEQ        DISPLAY_SEQUENCE,
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
                     WHEN COALESCE (A.OPERATION_LEVEL, 'H') = 'H'
                     THEN
                        'HEADER'
                     WHEN COALESCE (A.OPERATION_LEVEL, 'H') = 'L'
                     THEN
                        'LINE'
                  END)
                  OPERATION_LEVEL,
               null::numeric       HSN_ORDER_QUANTITY,
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
               NULL::numeric       HSN_IGST_AMOUNT,
               NULL::numeric       HSN_CESS_RATE,
               NULL::numeric       HSN_CESS_AMOUNT
          FROM SALORDCHG A INNER JOIN SALCHG B ON (CHGCODE = SALCHGCODE)
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
                 NULL               item_hsn,
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
                 SUM (CESS_AMOUNT)  HSN_CESS_AMOUNT
            FROM (SELECT *
                    FROM SALORDDET
                   WHERE (ordcode in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)) D
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
                           AND (ordcode in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)
                  GROUP BY SALORDDET_CODE, APPAMT) TAX
                    ON (D.CODE = SALORDDET_CODE)
                 INNER JOIN INVHSNSACMAIN H ON (INVHSNSACMAIN_CODE = H.CODE)
           WHERE (d.ordcode in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)
        GROUP BY ORDCODE,
                 GOVT_IDENTIFIER,
                 HSN_SAC_CODE,
                 DESCRIPTION,
                 UNITNAME,
                 CGST_RATE,
                 SGST_RATE,
                 IGST_RATE,
                 CESS_RATE) D
          ON (H.ORDCODE = D.ORDCODE)