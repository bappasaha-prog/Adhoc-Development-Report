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
SELECT ROW_NUMBER() OVER()                  UK,
       h.RTCODE                        L1_RTCODE,
       h.RETURN_DATE                   L1_RETURN_DATE,
       h.PCODE                         L1_PCODE,
       h.DOCUMENT_NO                   L1_DOCUMENT_NO,
       h.DOCUMENT_DATE                 L1_DOCUMENT_DATE,
       h.AGCODE                        L1_AGCODE,
       h.AGENT_NAME                    L1_AGENT_NAME,
       h.AGENT_RATE                    L1_AGENT_RATE,
       h.GROSS_AMOUNT                  L1_GROSS_AMOUNT,
       h.NET_AMOUNT                    L1_NET_AMOUNT,
       h.REMARKS                       L1_REMARKS,
       h.CREATED_BY                    L1_CREATED_BY,
       h.CREATED_ON                    L1_CREATED_ON,
       h.STOCK_POINT_NAME              L1_STOCK_POINT_NAME,
       h.LOGISTIC_NO                   L1_LOGISTIC_NO,
       h.LOGISTIC_DATE                 L1_LOGISTIC_DATE,
       h.LOGISTIC_TRANSPORTER          L1_LOGISTIC_TRANSPORTER,
       h.LOGISTIC_DOCUMENT_NO          L1_LOGISTIC_DOCUMENT_NO,
       h.LOGISTIC_DOCUMENT_DATE        L1_LOGISTIC_DOCUMENT_DATE,
       h.LOGISTIC_STATION_FROM         L1_LOGISTIC_STATION_FROM,
       h.LOGISTIC_STATION_TO           L1_LOGISTIC_STATION_TO,
       h.LOGISTIC_DECLARED_AMOUNT      L1_LOGISTIC_DECLARED_AMOUNT,
       h.RETURN_INVOICE_NO             L1_RETURN_INVOICE_NO,
       h.LOGISTIC_QUANTITY             L1_LOGISTIC_QUANTITY,
       h.ADMOU_CODE                    L1_ADMOU_CODE,
       h.ADMSITE_CODE                  L1_ADMSITE_CODE,
       h.GATE_INWARD_NO                L1_GATE_INWARD_NO,
       h.GATE_INWARD_DATE              L1_GATE_INWARD_DATE,
       h.GATE_INWARD_QUANTITY          L1_GATE_INWARD_QUANTITY,
       h.GATE_INWARD_DECLARED_AMOUNT   L1_GATE_INWARD_DECLARED_AMOUNT,
       h.ADMOU_CODE_IN                 L1_ADMOU_CODE_IN,
       h.ADMSITE_CODE_OWNER            L1_ADMSITE_CODE_OWNER,
       h.STORE_GRT_NO                  L1_STORE_GRT_NO,
       h.STORE_GRT_DATE                L1_STORE_GRT_DATE,
       h.STORE_GRT_REASON              L1_STORE_GRT_REASON,
       h.STORE_GRT_REMARKS             L1_STORE_GRT_REMARKS,
       h.SHORT_EXCESS_AMOUNT           L1_SHORT_EXCESS_AMOUNT,
       h.RELEASE_STATUS                L1_RELEASE_STATUS,
       h.RELEASE_ON                    L1_RELEASE_ON,
       h.RELEASE_BY                    L1_RELEASE_BY,
       h.OWNER_GSTIN_NO                L1_OWNER_GSTIN_NO,
       h.OWNER_GSTIN_STATE_CODE        L1_OWNER_GSTIN_STATE_CODE,
       h.OWNER_GSTIN_STATE_NAME        L1_OWNER_GSTIN_STATE_NAME,
       h.CP_GSTIN_NO                   L1_CP_GSTIN_NO,
       h.CP_GSTIN_STATE_CODE           L1_CP_GSTIN_STATE_CODE,
       h.CP_GSTIN_STATE_NAME           L1_CP_GSTIN_STATE_NAME,
       h.SALRTMAIN_UDFSTRING01         L1_SALRTMAIN_UDFSTRING01,
       h.SALRTMAIN_UDFSTRING02         L1_SALRTMAIN_UDFSTRING02,
       h.SALRTMAIN_UDFSTRING03         L1_SALRTMAIN_UDFSTRING03,
       h.SALRTMAIN_UDFSTRING04         L1_SALRTMAIN_UDFSTRING04,
       h.SALRTMAIN_UDFSTRING05         L1_SALRTMAIN_UDFSTRING05,
       h.SALRTMAIN_UDFSTRING06         L1_SALRTMAIN_UDFSTRING06,
       h.SALRTMAIN_UDFSTRING07         L1_SALRTMAIN_UDFSTRING07,
       h.SALRTMAIN_UDFSTRING08         L1_SALRTMAIN_UDFSTRING08,
       h.SALRTMAIN_UDFSTRING09         L1_SALRTMAIN_UDFSTRING09,
       h.SALRTMAIN_UDFSTRING10         L1_SALRTMAIN_UDFSTRING10,
       h.SALRTMAIN_UDFNUM01            L1_SALRTMAIN_UDFNUM01,
       h.SALRTMAIN_UDFNUM02            L1_SALRTMAIN_UDFNUM02,
       h.SALRTMAIN_UDFNUM03            L1_SALRTMAIN_UDFNUM03,
       h.SALRTMAIN_UDFNUM04            L1_SALRTMAIN_UDFNUM04,
       h.SALRTMAIN_UDFNUM05            L1_SALRTMAIN_UDFNUM05,
       h.SALRTMAIN_UDFDATE01           L1_SALRTMAIN_UDFDATE01,
       h.SALRTMAIN_UDFDATE02           L1_SALRTMAIN_UDFDATE02,
       h.SALRTMAIN_UDFDATE03           L1_SALRTMAIN_UDFDATE03,
       h.SALRTMAIN_UDFDATE04           L1_SALRTMAIN_UDFDATE04,
       h.SALRTMAIN_UDFDATE05           L1_SALRTMAIN_UDFDATE05,
       h.E_INVOICE_IRN                 L1_E_INVOICE_IRN,
       h.E_INVOICE_ACK_DATETIME        L1_E_INVOICE_ACK_DATETIME,
       h.E_INVOICE_ACK_NO              L1_E_INVOICE_ACK_NO,
       h.E_INVOICE_SIGNED_QR_DATA      L1_E_INVOICE_SIGNED_QR_DATA,
       h.E_INVOICE_UPDATED_BY          L1_E_INVOICE_UPDATED_BY,
       h.E_INVOICE_UPDATED_ON          L1_E_INVOICE_UPDATED_ON,
       H.SALETYPE                      L1_SALETYPE,
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
       h.CUST_GST_STATE_CODE           L1_CUST_GST_STATE_CODE,
       h.CUST_GST_STATE_NAME           L1_CUST_GST_STATE_NAME,
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
       h.OWNER_SITE_WEBSITE            L1_OWNER_SITE_WEBSITE,
       h.REFSITE_NAME                  L1_REFSITE_NAME,
       h.REFSITE_SHORT_CODE            L1_REFSITE_SHORT_CODE,
       h.REFSITE_ADDRESS               L1_REFSITE_ADDRESS,
       h.REFSITE_CITY                  L1_REFSITE_CITY,
       h.REFSITE_PINCODE               L1_REFSITE_PINCODE,
       h.REFSITE_PHONE1                L1_REFSITE_PHONE1,
       h.REFSITE_PHONE2                L1_REFSITE_PHONE2,
       h.REFSITE_PHONE3                L1_REFSITE_PHONE3,
       h.REFSITE_EMAIL1                L1_REFSITE_EMAIL1,
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
       d.LVL,
       d.SEQ,
       d.DETAIL_ICODE                  L2_DETAIL_ICODE,
       d.DETAIL_RETURNED_QUANTITY      L2_DETAIL_RETURNED_QUANTITY,
       d.DETAIL_RETURNED_RATE          L2_DETAIL_RETURNED_RATE,
       d.DETAIL_ITEM_REMARKS           L2_DETAIL_ITEM_REMARKS,
       d.DETAIL_RETURN_RSP             L2_DETAIL_RETURN_RSP,
       d.DETAIL_ITEM_COST_RATE         L2_DETAIL_ITEM_COST_RATE,
       d.DETAIL_DC_NO                  L2_DETAIL_DC_NO,
       d.DETAIL_SALES_INVOICE_NO       L2_SALES_INVOICE_NO,
       d.DETAIL_ITEM_GROSS_AMOUNT      L2_DETAIL_ITEM_GROSS_AMOUNT,
       d.DETAIL_TAX_CHARGE_AMOUNT      L2_DETAIL_TAX_CHARGE_AMOUNT,
       d.DETAIL_OTHER_CHARGE_AMOUNT    L2_DETAIL_OTHER_CHARGE_AMOUNT,
       d.DETAIL_ITEM_NET_AMOUNT        L2_DETAIL_ITEM_NET_AMOUNT,
       d.DETAIL_ITEM_TAX_RATE          L2_DETAIL_ITEM_TAX_RATE,
       d.DETAIL_SEND_QUANTITY          L2_DETAIL_SEND_QUANTITY,
       d.DETAIL_SHORT_EXCESS_QUANTITY  L2_DETAIL_SHORT_EXCESS_QTY,
       d.DETAIL_SHORT_EXCESS_AMOUNT    L2_DETAIL_SHORT_EXCESS_AMT,
       d.DETAIL_ALLOW_TAX_REVERSAL     L2_DETAIL_ALLOW_TAX_REVERSAL,
       d.DETAIL_TAXABLE_AMOUNT         L2_DETAIL_TAXABLE_AMOUNT,
       d.DETAIL_CGST_RATE              L2_DETAIL_CGST_RATE,
       d.DETAIL_CGST_AMOUNT            L2_DETAIL_CGST_AMOUNT,
       d.DETAIL_SGST_RATE              L2_DETAIL_SGST_RATE,
       d.DETAIL_SGST_AMOUNT            L2_DETAIL_SGST_AMOUNT,
       d.DETAIL_IGST_RATE              L2_DETAIL_IGST_RATE,
       d.DETAIL_IGST_AMOUNT            L2_DETAIL_IGST_AMOUNT,
       d.DETAIL_CESS_RATE              L2_DETAIL_CESS_RATE,
       d.DETAIL_CESS_AMOUNT            L2_DETAIL_CESS_AMOUNT,
       d.DETAIL_HSN_SAC_CODE           L2_DETAIL_HSN_SAC_CODE,
       d.DETAIL_VAT_RATE               L2_DETAIL_VAT_RATE,
       d.DETAIL_VAT_AMOUNT             L2_DETAIL_VAT_AMOUNT,
       d.BATCH_SERIAL_STRING           L2_BATCH_SERIAL_STRING,
       d.DIVISION                      L2_DIVISION,
       d.SECTION                       L2_SECTION,
       d.DEPARTMENT                    L2_DEPARTMENT,
       d.BARCODE                       L2_BARCODE,
       d.ITEM_ARTICLE_NAME             L2_ITEM_ARTICLE_NAME,
       d.ITEM_CATEGORY1                L2_ITEM_CATEGORY1,
       d.ITEM_CATEGORY2                L2_ITEM_CATEGORY2,
       d.ITEM_CATEGORY3                L2_ITEM_CATEGORY3,
       d.ITEM_CATEGORY4                L2_ITEM_CATEGORY4,
       d.ITEM_CATEGORY5                L2_ITEM_CATEGORY5,
       d.ITEM_CATEGORY6                L2_ITEM_CATEGORY6,
       d.ITEM_UOM                      L2_ITEM_UOM,
       d.ITEM_RSP                      L2_ITEM_RSP,
       d.ITEM_WSP                      L2_ITEM_WSP,
       d.ITEM_MRP                      L2_ITEM_MRP,
       d.ITEM_STANDARD_RATE            L2_ITEM_STANDARD_RATE,
       d.ITEM_NAME                     L2_ITEM_NAME,
       d.ITEM_MANAGEMENT_MODE          L2_ITEM_MANAGEMENT_MODE,
       d.CHARGE_NAME                   L3_CHARGE_NAME,
       d.DISPLAY_SEQUENCE              L3_DISPLAY_SEQUENCE,
       d.CHARGE_RATE                   L3_CHARGE_RATE,
       d.CHARGE_AMOUNT                 L3_CHARGE_AMOUNT,
       d.CHARGE_BASIS                  L3_CHARGE_BASIS,
       d.CHARGE_APPLICABLE_ON          L3_CHARGE_APPLICABLE_ON,
       d.OPERATION_LEVEL               L3_OPERATION_LEVEL,
       d.HSN_RETURN_QUANTITY           L4_HSN_RETURN_QUANTITY,
       d.HSN_AMOUNT                    L4_HSN_AMOUNT,
       d.HSN_HSN_CODE                  L4_HSN_HSN_CODE,
       d.HSN_HSN_SAC_ID                L4_HSN_HSN_SAC_ID,
       d.HSN_HSN_DESCRIPTION           L4_HSN_HSN_DESCRIPTION,
       d.HSN_UOM                       L4_HSN_UOM,
       d.HSN_TAXABLE_AMOUNT            L4_HSN_TAXABLE_AMOUNT,
       d.HSN_CGST_RATE                 L4_HSN_CGST_RATE,
       d.HSN_CGST_AMOUNT               L4_HSN_CGST_AMOUNT,
       d.HSN_SGST_RATE                 L4_HSN_SGST_RATE,
       d.HSN_SGST_AMOUNT               L4_HSN_SGST_AMOUNT,
       d.HSN_IGST_RATE                 L4_HSN_IGST_RATE,
       d.HSN_IGST_AMOUNT               L4_HSN_IGST_AMOUNT,
       d.HSN_CESS_RATE                 L4_HSN_CESS_RATE,
       d.HSN_CESS_AMOUNT               L4_HSN_CESS_AMOUNT,
       d.REFDOC_DC_NO                  L5_REFDOC_DC_NO,
       d.REFDOC_DC_DATE                L5_REFDOC_DC_DATE,
       d.REFDOC_RETURN_QUANTITY        L5_REFDOC_RETURN_QUANTITY,
       d.REFDOC_STORE_PACKET_NO        L5_REFDOC_STORE_PACKET_NO,
       d.REFDOC_INVOICE_NO             L5_REFDOC_INVOICE_NO,
       d.REFDOC_INVOICE_DATE           L5_REFDOC_INVOICE_DATE
  FROM (SELECT A.RTCODE                             RTCODE,
               RTDT                                 RETURN_DATE,
               PCODE                                PCODE,
               A.DOCNO                              DOCUMENT_NO,
               A.DOCDT                              DOCUMENT_DATE,
               A.AGCODE                             AGCODE,
               COALESCE (AG.SLNAME, 'No Agent')     AGENT_NAME,
               A.AGRATE                             AGENT_RATE,
               A.GRSAMT                             GROSS_AMOUNT,
               A.NETAMT                             NET_AMOUNT,
               A.REM                                REMARKS,
               ( (C.FNAME || ' [') || C.ENO) || ']' CREATED_BY,
               A.TIME                               CREATED_ON,
               LOCNAME                              STOCK_POINT_NAME,
               COALESCE (GTEL.LGTNO, LGT.LGTNO)     LOGISTIC_NO,
               COALESCE (GTEL.LGTDT, LGT.LGTDT)     LOGISTIC_DATE,
               COALESCE (GTET.SLNAME, TRN.SLNAME)   LOGISTIC_TRANSPORTER,
               COALESCE (GTEL.DOCNO, LGT.DOCNO)     LOGISTIC_DOCUMENT_NO,
               COALESCE (GTEL.DOCDT, LGT.DOCDT)     LOGISTIC_DOCUMENT_DATE,
               COALESCE (GTEL.STFR, LGT.STFR)       LOGISTIC_STATION_FROM,
               COALESCE (GTEL.STTO, LGT.STTO)       LOGISTIC_STATION_TO,
               COALESCE (GTEL.DECAMT, LGT.DECAMT)   LOGISTIC_DECLARED_AMOUNT,
               SCHEME_DOCNO                         RETURN_INVOICE_NO,
               A.LGTRECQTY                          LOGISTIC_QUANTITY,
               A.ADMOU_CODE                         ADMOU_CODE,
               A.ADMSITE_CODE                       ADMSITE_CODE,
               GATEINNO                             GATE_INWARD_NO,
               GATEINDT                             GATE_INWARD_DATE,
               GTE.GATEINQTY                        GATE_INWARD_QUANTITY,
               GTEL.DECAMT
                  GATE_INWARD_DECLARED_AMOUNT,
               ADMOU_CODE_IN                        ADMOU_CODE_IN,
               A.ADMSITE_CODE_OWNER                 ADMSITE_CODE_OWNER,
               GRT.DOCNO                            STORE_GRT_NO,
               GRT.DOCDT                            STORE_GRT_DATE,
               REASON                               STORE_GRT_REASON,
               GRT.REMARKS                          STORE_GRT_REMARKS,
               SHORTEXCESSAMT                       SHORT_EXCESS_AMOUNT,
               INITCAP (
                  CASE
                     WHEN A.RELEASE_STATUS = 'P' THEN 'POSTED'
                     WHEN A.RELEASE_STATUS = 'U' THEN 'UNPOSTED'
                     WHEN A.RELEASE_STATUS = 'R' THEN 'REVERSED'
                  END)
                  RELEASE_STATUS,
               RELEASE_TIME                         RELEASE_ON,
               ( (R.FNAME || ' [') || R.ENO) || ']' RELEASE_BY,
               A.OWNER_GSTIN_NO                     OWNER_GSTIN_NO,
               A.OWNER_GSTIN_STATE_CODE             OWNER_GSTIN_STATE_CODE,
               GST.NAME                             OWNER_GSTIN_STATE_NAME,
               A.CP_GSTIN_NO                        CP_GSTIN_NO,
               A.CP_GSTIN_STATE_CODE                CP_GSTIN_STATE_CODE,
               CPGST.NAME                           CP_GSTIN_STATE_NAME,
               A.UDFSTRING01                        SALRTMAIN_UDFSTRING01,
               A.UDFSTRING02                        SALRTMAIN_UDFSTRING02,
               A.UDFSTRING03                        SALRTMAIN_UDFSTRING03,
               A.UDFSTRING04                        SALRTMAIN_UDFSTRING04,
               A.UDFSTRING05                        SALRTMAIN_UDFSTRING05,
               A.UDFSTRING06                        SALRTMAIN_UDFSTRING06,
               A.UDFSTRING07                        SALRTMAIN_UDFSTRING07,
               A.UDFSTRING08                        SALRTMAIN_UDFSTRING08,
               A.UDFSTRING09                        SALRTMAIN_UDFSTRING09,
               A.UDFSTRING10                        SALRTMAIN_UDFSTRING10,
               A.UDFNUM01                           SALRTMAIN_UDFNUM01,
               A.UDFNUM02                           SALRTMAIN_UDFNUM02,
               A.UDFNUM03                           SALRTMAIN_UDFNUM03,
               A.UDFNUM04                           SALRTMAIN_UDFNUM04,
               A.UDFNUM05                           SALRTMAIN_UDFNUM05,
               A.UDFDATE01                          SALRTMAIN_UDFDATE01,
               A.UDFDATE02                          SALRTMAIN_UDFDATE02,
               A.UDFDATE03                          SALRTMAIN_UDFDATE03,
               A.UDFDATE04                          SALRTMAIN_UDFDATE04,
               A.UDFDATE05                          SALRTMAIN_UDFDATE05,
               CASE
                  WHEN a.saletype = 'O' THEN 'SALES RETURN'
                  ELSE 'TRANSFER IN'
               END
                  SALETYPE,
               E_INVOICE_IRN,
               E_INVOICE_ACK_DATETIME,
               E_INVOICE_ACK_NO,
               E_INVOICE_SIGNED_QR_DATA,
               E_INVOICE_UPDATED_BY,
               E_INVOICE_UPDATED_ON,
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
          FROM SALRTMAIN A
               LEFT OUTER JOIN FINSL AG ON (A.AGCODE = AG.SLCODE)
               INNER JOIN HRDEMP C ON (A.ECODE = C.ECODE)
               INNER JOIN site_data os
                  ON (A.ADMSITE_CODE_OWNER = os.sitecode)
               INNER JOIN INVLOC L ON (A.INLOCCODE = L.LOCCODE)
               INNER JOIN site_data RS ON (A.ADMSITE_CODE = rs.sitecode)
               INNER JOIN admou ou ON (A.ADMOU_CODE = ou.code)
               LEFT OUTER JOIN HRDEMP R ON (RELEASE_ECODE = R.ECODE)
               LEFT OUTER JOIN INTGMAIN I ON (A.INTGCODE = I.INTGCODE)
               LEFT OUTER JOIN INVGATEIN GTE ON (INVGATEIN_CODE = GTE.CODE)
               LEFT OUTER JOIN PSITE_GRT GRT ON (PSITE_GRT_CODE = GRT.CODE)
               LEFT OUTER JOIN ADMGSTSTATE GST
                  ON (A.OWNER_GSTIN_STATE_CODE = GST.CODE)
               LEFT OUTER JOIN ADMGSTSTATE CPGST
                  ON (A.CP_GSTIN_STATE_CODE = CPGST.CODE)
               LEFT OUTER JOIN INVLGTNOTE LGT ON (A.LGTCODE = LGT.LGTCODE)
               LEFT OUTER JOIN FINSL TRN ON (LGT.TRPCODE = TRN.SLCODE)
               LEFT OUTER JOIN INVLGTNOTE GTEL
                  ON (GTE.LGTCODE = GTEL.LGTCODE)
               LEFT OUTER JOIN FINSL GTET ON (GTEL.TRPCODE = GTET.SLCODE)
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
                 WHERE TRANSACTION_TABLE = 'SALRTMAIN') EI
                  ON (A.RTCODE::text = EI.TRANSACTION_CODE)
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
         WHERE (   RTCODE in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)) h
       INNER JOIN
       (                                                    /*L2 Detail Part*/
        SELECT 'L2#DETAIL'           LVL,
               1                     SEQ,
               RTCODE,
               ICODE                 DETAIL_ICODE,
               RETURNED_QUANTITY     DETAIL_RETURNED_QUANTITY,
               RETURNED_RATE         DETAIL_RETURNED_RATE,
               ITEM_REMARKS          DETAIL_ITEM_REMARKS,
               RETURN_RSP            DETAIL_RETURN_RSP,
               ITEM_COST_RATE        DETAIL_ITEM_COST_RATE,
               DETAIL_DC_NO,
               Sales_invoice_no      DETAIL_SALES_INVOICE_NO,
               ITEM_GROSS_AMOUNT     DETAIL_ITEM_GROSS_AMOUNT,
               TAX_CHARGE_AMOUNT     DETAIL_TAX_CHARGE_AMOUNT,
               OTHER_CHARGE_AMOUNT   DETAIL_OTHER_CHARGE_AMOUNT,
               ITEM_NET_AMOUNT       DETAIL_ITEM_NET_AMOUNT,
               ITEM_TAX_RATE         DETAIL_ITEM_TAX_RATE,
               SEND_QUANTITY         DETAIL_SEND_QUANTITY,
               SHORT_EXCESS_QUANTITY DETAIL_SHORT_EXCESS_QUANTITY,
               SHORT_EXCESS_AMOUNT   DETAIL_SHORT_EXCESS_AMOUNT,
               ALLOW_TAX_REVERSAL    DETAIL_ALLOW_TAX_REVERSAL,
               TAXABLE_AMOUNT        DETAIL_TAXABLE_AMOUNT,
               CGST_RATE             DETAIL_CGST_RATE,
               CGST_AMOUNT           DETAIL_CGST_AMOUNT,
               SGST_RATE             DETAIL_SGST_RATE,
               SGST_AMOUNT           DETAIL_SGST_AMOUNT,
               IGST_RATE             DETAIL_IGST_RATE,
               IGST_AMOUNT           DETAIL_IGST_AMOUNT,
               CESS_RATE             DETAIL_CESS_RATE,
               CESS_AMOUNT           DETAIL_CESS_AMOUNT,
               HSN_SAC_CODE          DETAIL_HSN_SAC_CODE,
               VAT_RATE              DETAIL_VAT_RATE,
               VAT_AMOUNT            DETAIL_VAT_AMOUNT,
               BATCH_SERIAL_STRING   BATCH_SERIAL_STRING,
               DIVISION,
               SECTION,
               DEPARTMENT,
               BARCODE,
               ARTICLE_NAME          ITEM_ARTICLE_NAME,
               CATEGORY1             ITEM_CATEGORY1,
               CATEGORY2             ITEM_CATEGORY2,
               CATEGORY3             ITEM_CATEGORY3,
               CATEGORY4             ITEM_CATEGORY4,
               CATEGORY5             ITEM_CATEGORY5,
               CATEGORY6             ITEM_CATEGORY6,
               UOM                   ITEM_UOM,
               RSP                   ITEM_RSP,
               WSP                   ITEM_WSP,
               MRP                   ITEM_MRP,
               STANDARD_RATE         ITEM_STANDARD_RATE,
               ITEM_NAME,
               ITEM_MANAGEMENT_MODE,
               NULL                  CHARGE_NAME,
               NULL                  DISPLAY_SEQUENCE,
               NULL                  CHARGE_RATE,
               NULL                  CHARGE_AMOUNT,
               NULL                  CHARGE_BASIS,
               NULL                  CHARGE_APPLICABLE_ON,
               NULL                  OPERATION_LEVEL,
               0                  HSN_RETURN_QUANTITY,
               0                  HSN_AMOUNT,
               NULL                  HSN_HSN_CODE,
               NULL                  HSN_HSN_SAC_ID,
               NULL                  HSN_HSN_DESCRIPTION,
               NULL                  HSN_UOM,
               0                  HSN_TAXABLE_AMOUNT,
               0                  HSN_CGST_RATE,
               0                  HSN_CGST_AMOUNT,
               0                  HSN_SGST_RATE,
               0                  HSN_SGST_AMOUNT,
               0                  HSN_IGST_RATE,
               0                  HSN_IGST_AMOUNT,
               0                  HSN_CESS_RATE,
               0                  HSN_CESS_AMOUNT,
               NULL                  REFDOC_DC_NO,
               null::DATE                  REFDOC_DC_DATE,
               0                  REFDOC_RETURN_QUANTITY,
               NULL                  REFDOC_STORE_PACKET_NO,
               NULL                  REFDOC_INVOICE_NO,
               null::DATE                  REFDOC_INVOICE_DATE
          FROM (SELECT RTCODE,
                       ICODE,
                       RETURNED_QUANTITY,
                       RETURNED_RATE,
                       ITEM_REMARKS,
                       RETURN_RSP,
                       ITEM_COST_RATE,
                       dc_no DETAIL_DC_NO,
                       Sales_invoice_no,
                       ITEM_GROSS_AMOUNT,
                       TAX_CHARGE_AMOUNT,
                       OTHER_CHARGE_AMOUNT,
                       ITEM_NET_AMOUNT,
                       ROUND (ITEM_TAX_RATE, 2) ITEM_TAX_RATE,
                       Send_Quantity,
                       SHORT_EXCESS_QUANTITY,
                       SHORT_EXCESS_AMOUNT,
                       ALLOW_TAX_REVERSAL,
                       Taxable_Amount,
                       CGST_Rate,
                       CGST_Amount,
                       SGST_Rate,
                       SGST_Amount,
                       IGST_Rate,
                       IGST_Amount,
                       CESS_Rate,
                       CESS_Amount,
                       HSN_SAC_CODE,
                       VAT_RATE,
                       VAT_AMOUNT,
                       fnc_get_batch_string(rtcode::text::character varying, icode, return_rsp, 'SALRTDET'::character varying)
                          batch_serial_string
                  FROM (  SELECT RTCODE                    RTCODE,
                                 M.ICODE                   ICODE,
                                 SUM (M.QTY)                 RETURNED_QUANTITY,
                                 M.RATE                      RETURNED_RATE,
                                 M.REM                       ITEM_REMARKS,
                                 M.MRP                     RETURN_RSP,
                                 M.COSTRATE                ITEM_COST_RATE,
                                 dcm.scheme_docno dc_no,
                                 inv.scheme_docno Sales_invoice_no,
                                 SUM (QTY * RATE)          ITEM_GROSS_AMOUNT,
                                 SUM (TAX_CHARGE_AMOUNT)   TAX_CHARGE_AMOUNT,
                                 SUM (OTHER_CHARGE_AMOUNT) OTHER_CHARGE_AMOUNT,
                                   (  SUM (
                                         COALESCE (QTY, 0) * COALESCE (RATE, 0))
                                    + SUM (COALESCE (TAX_CHARGE_AMOUNT, 0)))
                                 + SUM (COALESCE (OTHER_CHARGE_AMOUNT, 0))
                                    ITEM_NET_AMOUNT,
                                 SUM (ITEM_TAX_RATE)       ITEM_TAX_RATE,
                                 SUM (COALESCE (SENDQTY, 0)) SEND_QUANTITY,
                                 SUM (SHORTEXCESSQTY)
                                    SHORT_EXCESS_QUANTITY,
                                 SUM (SHORTEXCESSAMT)
                                    SHORT_EXCESS_AMOUNT,
                                 INITCAP (ALLOWTAXREVERSAL) ALLOW_TAX_REVERSAL,
                                 SUM (TAXABLE_AMOUNT)      TAXABLE_AMOUNT,
                                 CGST_RATE,
                                 SUM (CGST_AMOUNT)         CGST_AMOUNT,
                                 SGST_RATE,
                                 SUM (SGST_AMOUNT)         SGST_AMOUNT,
                                 IGST_RATE,
                                 SUM (IGST_AMOUNT)         IGST_AMOUNT,
                                 CESS_RATE,
                                 SUM (CESS_AMOUNT)         CESS_AMOUNT,
                                 HSN_SAC_CODE,
                                 VAT_RATE,
                                 SUM (VAT_AMOUNT)          VAT_AMOUNT
                            FROM (SELECT *
                                    FROM SALRTDET
                                   WHERE (   RTCODE in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)) M
		JOIN invdcmain dcm ON m.dccode = dcm.dccode
             LEFT JOIN salinvmain inv ON m.invcode = inv.invcode
                                 LEFT OUTER JOIN
                                 (  SELECT SALRTDET_CODE,
                                           SUM (COALESCE (CHGAMT, 0))
                                              OTHER_CHARGE_AMOUNT
                                      FROM SALRTCHG_ITEM
                                     WHERE     ISTAX = 'N'
                                           AND (   RTCODE in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)
                                  GROUP BY SALRTDET_CODE) OTX
                                    ON (M.CODE = OTX.SALRTDET_CODE)
                                 LEFT OUTER JOIN
                                 (  SELECT SALRTDET_CODE,
                                           APPAMT TAXABLE_AMOUNT,
                                           ROUND (
                                              SUM (
                                                 CASE
                                                    WHEN source IN ('G', 'V')
                                                    THEN
                                                         (  COALESCE (CHGAMT, 0)
                                                          / CASE
                                                               WHEN COALESCE (
                                                                       APPAMT,
                                                                       0) = 0
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
                                           SUM (COALESCE (CHGAMT, 0))
                                              TAX_CHARGE_AMOUNT,
                                           SUM (
                                              CASE
                                                 WHEN GST_COMPONENT = 'CGST'
                                                 THEN
                                                    RATE
                                                 ELSE
                                                    0
                                              END)
                                              CGST_RATE,
                                           SUM (
                                              CASE
                                                 WHEN GST_COMPONENT = 'CGST'
                                                 THEN
                                                    CHGAMT
                                                 ELSE
                                                    0
                                              END)
                                              CGST_AMOUNT,
                                           SUM (
                                              CASE
                                                 WHEN GST_COMPONENT = 'SGST'
                                                 THEN
                                                    RATE
                                                 ELSE
                                                    0
                                              END)
                                              SGST_RATE,
                                           SUM (
                                              CASE
                                                 WHEN GST_COMPONENT = 'SGST'
                                                 THEN
                                                    CHGAMT
                                                 ELSE
                                                    0
                                              END)
                                              SGST_AMOUNT,
                                           SUM (
                                              CASE
                                                 WHEN GST_COMPONENT = 'IGST'
                                                 THEN
                                                    RATE
                                                 ELSE
                                                    0
                                              END)
                                              IGST_RATE,
                                           SUM (
                                              CASE
                                                 WHEN GST_COMPONENT = 'IGST'
                                                 THEN
                                                    CHGAMT
                                                 ELSE
                                                    0
                                              END)
                                              IGST_AMOUNT,
                                           SUM (
                                              CASE
                                                 WHEN GST_COMPONENT = 'CESS'
                                                 THEN
                                                    RATE
                                                 ELSE
                                                    0
                                              END)
                                              CESS_RATE,
                                           SUM (
                                              CASE
                                                 WHEN GST_COMPONENT = 'CESS'
                                                 THEN
                                                    CHGAMT
                                                 ELSE
                                                    0
                                              END)
                                              CESS_AMOUNT,
                                           SUM (
                                              CASE
                                                 WHEN SOURCE = 'V' THEN RATE
                                                 ELSE 0
                                              END)
                                              VAT_RATE,
                                           SUM (
                                              CASE
                                                 WHEN SOURCE = 'V' THEN CHGAMT
                                                 ELSE 0
                                              END)
                                              VAT_AMOUNT
                                      FROM SALRTCHG_ITEM
                                     WHERE     ISTAX = 'Y'
                                           AND (   RTCODE in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)
                                  GROUP BY SALRTDET_CODE, APPAMT) TAX
                                    ON (M.CODE = TAX.SALRTDET_CODE)
                        GROUP BY M.RTCODE,
                                 M.ICODE,
                                 M.RATE,
                                 dcm.scheme_docno,
                                 inv.scheme_docno,
                                 M.REM,
                                 M.MRP,
                                 M.COSTRATE,
                                 INITCAP (M.ALLOWTAXREVERSAL),
                                 CGST_Rate,
                                 SGST_Rate,
                                 IGST_Rate,
                                 CESS_Rate,
                                 M.HSN_SAC_CODE,
                                 VAT_RATE)) d
               INNER JOIN ginview.invitem_agg i ON (d.icode = i.code)
        UNION ALL
        /*L3 CHARGE PART*/
        SELECT 'L3#CHARGE' LVL,
               2           SEQ,
               RTCODE      RTCODE,
               NULL        DETAIL_ICODE,
               NULL        DETAIL_RETURNED_QUANTITY,
               NULL        DETAIL_RETURNED_RATE,
               NULL        DETAIL_ITEM_REMARKS,
               NULL        DETAIL_RETURN_RSP,
               NULL        DETAIL_ITEM_COST_RATE,
               null        DETAIL_DC_NO,
               NULL        DETAIL_SALES_INVOICE_NO,
               NULL        DETAIL_ITEM_GROSS_AMOUNT,
               NULL        DETAIL_TAX_CHARGE_AMOUNT,
               NULL        DETAIL_OTHER_CHARGE_AMOUNT,
               NULL        DETAIL_ITEM_NET_AMOUNT,
               NULL        DETAIL_ITEM_TAX_RATE,
               NULL        DETAIL_SEND_QUANTITY,
               NULL        DETAIL_SHORT_EXCESS_QUANTITY,
               NULL        DETAIL_SHORT_EXCESS_AMOUNT,
               NULL        DETAIL_ALLOW_TAX_REVERSAL,
               NULL        DETAIL_TAXABLE_AMOUNT,
               NULL        DETAIL_CGST_RATE,
               NULL        DETAIL_CGST_AMOUNT,
               NULL        DETAIL_SGST_RATE,
               NULL        DETAIL_SGST_AMOUNT,
               NULL        DETAIL_IGST_RATE,
               NULL        DETAIL_IGST_AMOUNT,
               NULL        DETAIL_CESS_RATE,
               NULL        DETAIL_CESS_AMOUNT,
               NULL        DETAIL_HSN_SAC_CODE,
               NULL        DETAIL_VAT_RATE,
               NULL        DETAIL_VAT_AMOUNT,
               NULL        BATCH_SERIAL_STRING,
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
               NULL        ITEM_MANAGEMENT_MODE,
               SALCHGNAME  CHARGE_NAME,
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
                     WHEN A.OPERATION_LEVEL = 'H' THEN 'HEADER'
                     WHEN A.OPERATION_LEVEL = 'L' THEN 'LINE'
                  END)
                  OPERATION_LEVEL,
               0        HSN_RETURN_QUANTITY,
               0        HSN_AMOUNT,
               NULL        HSN_HSN_CODE,
               NULL        HSN_HSN_SAC_ID,
               NULL        HSN_HSN_DESCRIPTION,
               NULL        HSN_UOM,
               0        HSN_TAXABLE_AMOUNT,
               0        HSN_CGST_RATE,
               0        HSN_CGST_AMOUNT,
               0        HSN_SGST_RATE,
               0        HSN_SGST_AMOUNT,
               0        HSN_IGST_RATE,
               0        HSN_IGST_AMOUNT,
               0        HSN_CESS_RATE,
               0        HSN_CESS_AMOUNT,
               NULL        REFDOC_DC_NO,
               NULL::DATE         REFDOC_DC_DATE,
               0        REFDOC_RETURN_QUANTITY,
               NULL        REFDOC_STORE_PACKET_NO,
               NULL        REFDOC_INVOICE_NO,
               NULL::DATE         REFDOC_INVOICE_DATE
          FROM SALRTCHG A
               INNER JOIN SALCHG B ON (A.SALCHGCODE = B.SALCHGCODE)
         WHERE (   RTCODE in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)
        UNION ALL
          /*L4 HSN PART*/
          SELECT 'L4#HSN'         LVL,
                 3                SEQ,
                 RTCODE,
                 NULL             DETAIL_ICODE,
                 NULL             DETAIL_RETURNED_QUANTITY,
                 NULL             DETAIL_RETURNED_RATE,
                 NULL             DETAIL_ITEM_REMARKS,
                 NULL             DETAIL_RETURN_RSP,
                 NULL             DETAIL_ITEM_COST_RATE,
                 null        DETAIL_DC_NO,
                 NULL        DETAIL_SALES_INVOICE_NO,
                 NULL             DETAIL_ITEM_GROSS_AMOUNT,
                 NULL             DETAIL_TAX_CHARGE_AMOUNT,
                 NULL             DETAIL_OTHER_CHARGE_AMOUNT,
                 NULL             DETAIL_ITEM_NET_AMOUNT,
                 NULL             DETAIL_ITEM_TAX_RATE,
                 NULL             DETAIL_SEND_QUANTITY,
                 NULL             DETAIL_SHORT_EXCESS_QUANTITY,
                 NULL             DETAIL_SHORT_EXCESS_AMOUNT,
                 NULL             DETAIL_ALLOW_TAX_REVERSAL,
                 NULL             DETAIL_TAXABLE_AMOUNT,
                 NULL             DETAIL_CGST_RATE,
                 NULL             DETAIL_CGST_AMOUNT,
                 NULL             DETAIL_SGST_RATE,
                 NULL             DETAIL_SGST_AMOUNT,
                 NULL             DETAIL_IGST_RATE,
                 NULL             DETAIL_IGST_AMOUNT,
                 NULL             DETAIL_CESS_RATE,
                 NULL             DETAIL_CESS_AMOUNT,
                 NULL             DETAIL_HSN_SAC_CODE,
                 NULL             DETAIL_VAT_RATE,
                 NULL             DETAIL_VAT_AMOUNT,
                 NULL             BATCH_SERIAL_STRING,
                 NULL             DIVISION,
                 NULL             SECTION,
                 NULL             DEPARTMENT,
                 NULL             BARCODE,
                 NULL             ITEM_ARTICLE_NAME,
                 NULL             ITEM_CATEGORY1,
                 NULL             ITEM_CATEGORY2,
                 NULL             ITEM_CATEGORY3,
                 NULL             ITEM_CATEGORY4,
                 NULL             ITEM_CATEGORY5,
                 NULL             ITEM_CATEGORY6,
                 NULL             ITEM_UOM,
                 NULL             ITEM_RSP,
                 NULL             ITEM_WSP,
                 NULL             ITEM_MRP,
                 NULL             ITEM_STANDARD_RATE,
                 NULL             ITEM_NAME,
                 NULL             ITEM_MANAGEMENT_MODE,
                 NULL             CHARGE_NAME,
                 NULL             DISPLAY_SEQUENCE,
                 NULL             CHARGE_RATE,
                 NULL             CHARGE_AMOUNT,
                 NULL             CHARGE_BASIS,
                 NULL             CHARGE_APPLICABLE_ON,
                 NULL             OPERATION_LEVEL,
                 SUM (QTY)        HSN_RETURN_QUANTITY,
                 SUM (QTY * D.RATE) HSN_AMOUNT,
                 D.HSN_SAC_CODE   HSN_HSN_CODE,
                 H.HSN_SAC_CODE   HSN_HSN_SAC_ID,
                 DESCRIPTION      HSN_HSN_DESCRIPTION,
                 UNITNAME         HSN_UOM,
                 COALESCE (SUM (TAXABLE_AMOUNT), SUM (QTY * D.RATE))
                    HSN_TAXABLE_AMOUNT,
                 CGST_RATE        HSN_CGST_RATE,
                 SUM (CGST_AMOUNT) HSN_CGST_AMOUNT,
                 SGST_RATE        HSN_SGST_RATE,
                 SUM (SGST_AMOUNT) HSN_SGST_AMOUNT,
                 IGST_RATE        HSN_IGST_RATE,
                 SUM (IGST_AMOUNT) HSN_IGST_AMOUNT,
                 CESS_RATE        HSN_CESS_RATE,
                 SUM (CESS_AMOUNT) HSN_CESS_AMOUNT,
                 NULL             REFDOC_DC_NO,
                 NULL::DATE              REFDOC_DC_DATE,
                 0             REFDOC_RETURN_QUANTITY,
                 NULL             REFDOC_STORE_PACKET_NO,
                 NULL             REFDOC_INVOICE_NO,
                 NULL::DATE              REFDOC_INVOICE_DATE
            FROM SALRTDET D
                 INNER JOIN INVITEM I ON (D.ICODE = I.ICODE)
                 LEFT OUTER JOIN
                 (  SELECT SALRTDET_CODE,
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
                      FROM SALRTCHG_ITEM
                     WHERE     SOURCE = 'G'
                           AND (   RTCODE in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)
                  GROUP BY SALRTDET_CODE, APPAMT) TAX
                    ON (D.CODE = SALRTDET_CODE)
                 INNER JOIN INVHSNSACMAIN H ON (INVHSNSACMAIN_CODE = H.CODE)
        GROUP BY RTCODE,
                 D.HSN_SAC_CODE,
                 H.HSN_SAC_CODE,
                 DESCRIPTION,
                 UNITNAME,
                 CGST_RATE,
                 SGST_RATE,
                 IGST_RATE,
                 CESS_RATE
        UNION ALL
        /*L5 REFDOC PART*/
        SELECT 'L5#REFDOC'     LVL,
               4               SEQ,
               RTCODE,
               NULL            DETAIL_ICODE,
               NULL            DETAIL_RETURNED_QUANTITY,
               NULL            DETAIL_RETURNED_RATE,
               NULL            DETAIL_ITEM_REMARKS,
               NULL            DETAIL_RETURN_RSP,
               NULL            DETAIL_ITEM_COST_RATE,
               null        DETAIL_DC_NO,
               NULL        DETAIL_SALES_INVOICE_NO,
               NULL            DETAIL_ITEM_GROSS_AMOUNT,
               NULL            DETAIL_TAX_CHARGE_AMOUNT,
               NULL            DETAIL_OTHER_CHARGE_AMOUNT,
               NULL            DETAIL_ITEM_NET_AMOUNT,
               NULL            DETAIL_ITEM_TAX_RATE,
               NULL            DETAIL_SEND_QUANTITY,
               NULL            DETAIL_SHORT_EXCESS_QUANTITY,
               NULL            DETAIL_SHORT_EXCESS_AMOUNT,
               NULL            DETAIL_ALLOW_TAX_REVERSAL,
               NULL            DETAIL_TAXABLE_AMOUNT,
               NULL            DETAIL_CGST_RATE,
               NULL            DETAIL_CGST_AMOUNT,
               NULL            DETAIL_SGST_RATE,
               NULL            DETAIL_SGST_AMOUNT,
               NULL            DETAIL_IGST_RATE,
               NULL            DETAIL_IGST_AMOUNT,
               NULL            DETAIL_CESS_RATE,
               NULL            DETAIL_CESS_AMOUNT,
               NULL            DETAIL_HSN_SAC_CODE,
               NULL            DETAIL_VAT_RATE,
               NULL            DETAIL_VAT_AMOUNT,
               NULL            BATCH_SERIAL_STRING,
               NULL            DIVISION,
               NULL            SECTION,
               NULL            DEPARTMENT,
               NULL            BARCODE,
               NULL            ITEM_ARTICLE_NAME,
               NULL            ITEM_CATEGORY1,
               NULL            ITEM_CATEGORY2,
               NULL            ITEM_CATEGORY3,
               NULL            ITEM_CATEGORY4,
               NULL            ITEM_CATEGORY5,
               NULL            ITEM_CATEGORY6,
               NULL            ITEM_UOM,
               NULL            ITEM_RSP,
               NULL            ITEM_WSP,
               NULL            ITEM_MRP,
               NULL            ITEM_STANDARD_RATE,
               NULL            ITEM_NAME,
               NULL            ITEM_MANAGEMENT_MODE,
               NULL            CHARGE_NAME,
               NULL            DISPLAY_SEQUENCE,
               NULL            CHARGE_RATE,
               NULL            CHARGE_AMOUNT,
               NULL            CHARGE_BASIS,
               NULL            CHARGE_APPLICABLE_ON,
               NULL            OPERATION_LEVEL,
               0            HSN_RETURN_QUANTITY,
               0            HSN_AMOUNT,
               NULL            HSN_HSN_CODE,
               NULL            HSN_HSN_SAC_ID,
               NULL            HSN_HSN_DESCRIPTION,
               NULL            HSN_UOM,
               0            HSN_TAXABLE_AMOUNT,
               0            HSN_CGST_RATE,
               0            HSN_CGST_AMOUNT,
               0            HSN_SGST_RATE,
               0            HSN_SGST_AMOUNT,
               0            HSN_IGST_RATE,
               0            HSN_IGST_AMOUNT,
               0            HSN_CESS_RATE,
               0            HSN_CESS_AMOUNT,
               DC_No           REFDOC_DC_No,
               DC_DATE         REFDOC_DC_DATE,
               RETURN_Quantity REFDOC_RETURN_Quantity,
               Store_Packet_No REFDOC_Store_Packet_No,
               Invoice_No      REFDOC_Invoice_No,
               Invoice_Date    REFDOC_Invoice_Date
          FROM (  SELECT RTCODE,
                         DCM.SCHEME_DOCNO DC_NO,
                         DCDT           DC_DATE,
                         PACKETNO       STORE_PACKET_NO,
                         INV.SCHEME_DOCNO INVOICE_NO,
                         INVDT          INVOICE_DATE,
                         SUM (QTY)      RETURN_QUANTITY
                    FROM SALRTDET SR
                         INNER JOIN INVDCMAIN DCM ON (SR.DCCODE = DCM.DCCODE)
                         LEFT OUTER JOIN SALINVMAIN INV
                            ON (SR.INVCODE = INV.INVCODE)
                   WHERE (   RTCODE in (
	select
		unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
		or coalesce (nullif ('@DocumentId@',
		''),
		'0')::text = 0::text)
                GROUP BY RTCODE,
                         DCM.SCHEME_DOCNO,
                         DCDT,
                         PACKETNO,
                         INV.SCHEME_DOCNO,
                         INVDT)) D
          ON (H.RTCODE = D.RTCODE)