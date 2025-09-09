/* Formatted on 04-06-2025 14:12:47 (QP5 v5.294) */
/*|| Custom Development || Object : CQ_SOTO || Ticket Id :  413443 || Developer : Dipankar ||*/

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
       D.L2_D_NO,
       D.L2_ITEM,
       D.L2_DESC3,
       D.L2_COLOUR,
       D.L2_1ST_SIZE_QUANTITY,
       D.L2_2ND_SIZE_QUANTITY,
       D.L2_3RD_SIZE_QUANTITY,
       D.L2_4TH_SIZE_QUANTITY,
       D.L2_UNDIFF,
       D.L2_QTY,
       D.L3_SECTION,
       D.L3_D_COUNT,
       D.L4_ITEM,
       D.L4_SECTION,
       D.L4_QTY,
       D.L4_ITEM_COUNT
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
               INNER JOIN SITE_DATA RS ON (M.ADMSITE_CODE = RS.SITECODE)
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
        SELECT   'L2#DETAIL'                    LVL,
                 1                              SEQ,
                 ORDCODE,
                 STRING_DESC6                   L2_D_NO,
                 SECTION || ' - ' || I.DEPARTMENT L2_ITEM,
                 TRIM (I.STRING_DESC3)          L2_DESC3,
                 CATEGORY4                      L2_COLOUR,
                 SUM (
                    CASE
                       WHEN I.STRING_DESC4 = '1ST SIZE' THEN A.ORDQTY
                       ELSE 0
                    END)
                    L2_1ST_SIZE_QUANTITY,
                 SUM (
                    CASE
                       WHEN I.STRING_DESC4 = '2ND SIZE' THEN A.ORDQTY
                       ELSE 0
                    END)
                    L2_2ND_SIZE_QUANTITY,
                 SUM (
                    CASE
                       WHEN I.STRING_DESC4 = '3RD SIZE' THEN A.ORDQTY
                       ELSE 0
                    END)
                    L2_3RD_SIZE_QUANTITY,
                 SUM (
                    CASE
                       WHEN I.STRING_DESC4 = '4TH SIZE' THEN A.ORDQTY
                       ELSE 0
                    END)
                    L2_4TH_SIZE_QUANTITY,
                 SUM (
                    CASE
                       WHEN     NVL (I.STRING_DESC4, '99999') <> '1ST SIZE'
                            AND NVL (I.STRING_DESC4, '99999') <> '2ND SIZE'
                            AND NVL (I.STRING_DESC4, '99999') <> '3RD SIZE'
                            AND NVL (I.STRING_DESC4, '99999') <> '4TH SIZE'
                       THEN
                          A.ORDQTY
                       ELSE
                          0
                    END)
                    L2_UNDIFF,
                 SUM (A.ORDQTY)                 L2_QTY,
                 NULL                           L3_SECTION,
                 0                              L3_D_COUNT,
                 NULL                           L4_ITEM,
                 NULL                           L4_SECTION,
                 0                              L4_QTY,
                 0                              L4_ITEM_COUNT
            FROM SALORDDET A INNER JOIN GINVIEW.LV_ITEM I ON A.ICODE = I.CODE
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
        GROUP BY ORDCODE,
                 STRING_DESC6,
                 SECTION || ' - ' || I.DEPARTMENT,
                 TRIM (I.STRING_DESC3),
                 CATEGORY4
        UNION ALL
          SELECT 'L3#DETAIL'          LVL,
                 2                    SEQ,
                 F.ORDCODE,
                 NULL                 L2_D_NO,
                 NULL                 L2_ITEM,
                 NULL                 L2_DESC3,
                 NULL                 L2_COLOUR,
                 0                    L2_1ST_SIZE_QUANTITY,
                 0                    L2_2ND_SIZE_QUANTITY,
                 0                    L2_3RD_SIZE_QUANTITY,
                 0                    L2_4TH_SIZE_QUANTITY,
                 0                    L2_UNDIFF,
                 0                    L2_QTY,
                 F.SECTION            L3_SECTION,
                 COUNT (F.STRING_DESC6) L3_D_COUNT,
                 NULL                 L4_ITEM,
                 NULL                 L4_SECTION,
                 0                    L4_QTY,
                 0                    L4_ITEM_COUNT
            FROM (  SELECT A.ORDCODE,
                           I.STRING_DESC6,
                           I.SECTION,
                           I.DEPARTMENT,
                           TRIM (I.STRING_DESC3) DESC3,
                           I.CATEGORY4       COLOUR,
                           SUM (A.ORDQTY)    QTY
                      FROM SALORDDET A
                           INNER JOIN GINVIEW.LV_ITEM I ON A.ICODE = I.CODE
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
                                  0)
                  GROUP BY A.ORDCODE,
                           I.STRING_DESC6,
                           I.SECTION,
                           I.DEPARTMENT,
                           TRIM (I.STRING_DESC3),
                           I.CATEGORY4) F
        GROUP BY F.ORDCODE, F.SECTION
        UNION ALL
          SELECT 'L4#DETAIL' LVL,
                 3          SEQ,
                 ORDCODE,
                 NULL       L2_D_NO,
                 NULL       L2_ITEM,
                 NULL       L2_DESC3,
                 NULL       L2_COLOUR,
                 0          L2_1ST_SIZE_QUANTITY,
                 0          L2_2ND_SIZE_QUANTITY,
                 0          L2_3RD_SIZE_QUANTITY,
                 0          L2_4TH_SIZE_QUANTITY,
                 0          L2_UNDIFF,
                 0          L2_QTY,
                 NULL       L3_SECTION,
                 0          L3_D_COUNT,
                 ITEM       L4_ITEM,
                 SECTION    L4_SECTION,
                 SUM (QTY)  L4_QTY,
                 COUNT (ITEM) L4_ITEM_COUNT
            FROM (  SELECT ORDCODE,
                           STRING_DESC6,
                           SECTION,
                           SECTION || ' - ' || I.DEPARTMENT ITEM,
                           TRIM (I.STRING_DESC3)        DESC3,
                           CATEGORY4                    COLOUR,
                           SUM (ORDQTY)                 QTY
                      FROM SALORDDET M
                           INNER JOIN GINVIEW.LV_ITEM I ON M.ICODE = I.CODE
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
                                  0)
                  GROUP BY ORDCODE,
                           STRING_DESC6,
                           SECTION,
                           SECTION || ' - ' || I.DEPARTMENT,
                           TRIM (I.STRING_DESC3),
                           CATEGORY4)
        GROUP BY ORDCODE, SECTION, ITEM) D
          ON (H.ORDCODE = D.ORDCODE)