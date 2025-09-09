/* Formatted on 2025-05-27 16:28:01 (QP5 v5.294) */
/*|| Custom Development || Object : CQ_COMPOSITE_SALES || Ticket Id :  413915 || Developer : Dipankar ||*/
SELECT GINVIEW.FNC_UK () UK,
       INVOICE_TYPE,
       ACCOUNTING_PERIOD,
       ADMSITE_CODE_SRC,
       ADMSITE_CODE_DES,
       CUSTOMER_CODE,
       DOCUMENT_SCHEME,
       INVOICE_NO,
       INVOICE_DATE,
       DOC_NO,
       DOC_DATE,
       DUE_DATE,
       AGENT_NAME,
       AGENT_ALIAS,
       AGENCY_COMMISSION,
       SALES_LEDGER,
       SALES_SUBLEDGER,
       SALES_TERM_NAME,
       LOGISTIC_NO,
       LOGISTIC_DATE,
       LOGISTIC_DOCNO,
       LOGISTIC_DOCUMENT_DATE,
       LOGISTIC_QTY,
       GATEIN_NO,
       GATEIN_DATE,
       PREPARED_BY,
       PREPARED_TIME,
       LAST_ACCESS_BY,
       LAST_ACCESS_TIME,
       INVOICE_REMARKS,
       CHALLAN_NO,
       CHALLAN_DATE,
       BARCODE,
       ITEM_REMARKS,
       INVOICE_QTY,
       INVOICE_AMOUNT,
       INVOICE_GROSS_AMOUNT,
       INVOICE_OTHER_CHARGE_AMT,
       INVOICE_DISCOUNT_CHARGE_AMT,
       INVOICE_TAX_CHARGE_AMT,
       INVOICE_CHARGE_AMOUNT,
       INVOICE_NET_AMOUNT,
       INVOICE_RATE,
       INVOICE_COSTRATE,
       INVOICE_ADJ_AMOUNT,
       INVOICE_TRANSPORTER,
       SALETYPE,
       LOGISTIC_DOC_DATE,
       RELEASE_STATUS,
       PRICELIST_NAME,
       INCLUDE_TAX,
       TRADE_GROUP_NAME,
       INVOICE_RSP,
       DISCOUNT_FACTOR,
       CGST_RATE,
       CGST_AMOUNT,
       SGST_RATE,
       SGST_AMOUNT,
       IGST_RATE,
       IGST_AMOUNT,
       CESS_RATE,
       CESS_AMOUNT,
       TAXABLE_AMOUNT,
       RELEASE_BY,
       RELEASE_ON,
       SALES_ORDER_NO,
       SALES_ORDER_DATE,
       LOCCODE,
       REFERENCE_NO,
       REFERENCE_DATE,
       UDFSTRING01,
       UDFSTRING02,
       UDFSTRING03,
       UDFSTRING04,
       UDFSTRING05,
       UDFSTRING06,
       UDFSTRING07,
       UDFSTRING08,
       UDFSTRING09,
       UDFSTRING10,
       UDFNUM01,
       UDFNUM02,
       UDFNUM03,
       UDFNUM04,
       UDFNUM05,
       UDFDATE01,
       UDFDATE02,
       UDFDATE03,
       UDFDATE04,
       UDFDATE05
  FROM (SELECT CASE
                  WHEN SITE.SITETYPE LIKE '%CM%' THEN 'TRANSFER OUT'
                  ELSE 'SALES'
               END
                  AS INVOICE_TYPE,
               ADMYEAR.YNAME               AS ACCOUNTING_PERIOD,
               M.ADMSITE_CODE_OWNER        AS ADMSITE_CODE_SRC,
               M.ADMSITE_CODE              AS ADMSITE_CODE_DES,
               M.PCODE                     AS CUSTOMER_CODE,
               DOCSH.DOCNAME               AS DOCUMENT_SCHEME,
               M.SCHEME_DOCNO              AS INVOICE_NO,
               M.INVDT                     AS INVOICE_DATE,
               M.DOCNO                     AS DOC_NO,
               M.DOCDT                     AS DOC_DATE,
               M.DUEDT                     AS DUE_DATE,
               A.SLNAME                    AS AGENT_NAME,
               A.ABBRE                     AS AGENT_ALIAS,
               M.AGRATE                    AS AGENCY_COMMISSION,
               G.GLNAME                    AS SALES_LEDGER,
               SL.SLNAME AS SALES_SUBLEDGER,
               SALTERMMAIN.SALTERMNAME     AS SALES_TERM_NAME,
               LGT.LGTNO                   AS LOGISTIC_NO,
               LGT.LGTDT                   AS LOGISTIC_DATE,
               LGT.DOCNO                   AS LOGISTIC_DOCNO,
               LGT.DOCDT                   AS LOGISTIC_DOCUMENT_DATE,
               LGT.QTY1                    AS LOGISTIC_QTY,
               NULL                        AS GATEIN_NO,
               NULL                        AS GATEIN_DATE,
               HRDEMP.FNAME                AS PREPARED_BY,
               M.TIME                      AS PREPARED_TIME,
               MODIFIED_EMP.FNAME          AS LAST_ACCESS_BY,
               M.LAST_ACCESS_TIME,
               M.REM                       AS INVOICE_REMARKS,
               D.SCHEME_DOCNO              AS CHALLAN_NO,
               D.DCDT                      AS CHALLAN_DATE,
               D.ICODE                     AS BARCODE,
               D.REM                       AS ITEM_REMARKS,
               D.INVQTY                    AS INVOICE_QTY,
               D.INVAMT                    AS INVOICE_AMOUNT,
               D.INVAMT                    AS INVOICE_GROSS_AMOUNT,
               IOC.CHGAMT                  AS INVOICE_OTHER_CHARGE_AMT,
               IDC.CHGAMT                  AS INVOICE_DISCOUNT_CHARGE_AMT,
               ITC.CHGAMT                  AS INVOICE_TAX_CHARGE_AMT,
               NVL (TOT_CHG.TAX_AMOUNT, 0) AS INVOICE_CHARGE_AMOUNT,
               NVL (D.INVAMT, 0) + NVL (TOT_CHG.TAX_AMOUNT, 0)
                  AS INVOICE_NET_AMOUNT,
               D.RATE                      AS INVOICE_RATE,
               D.COSTRATE                  AS INVOICE_COSTRATE,
               M.ADJAMT                    AS INVOICE_ADJ_AMOUNT,
               T.SLNAME                    AS INVOICE_TRANSPORTER,
               CASE
                  WHEN M.SALETYPE = 'O' THEN 'Outright'
                  WHEN M.SALETYPE = 'C' THEN 'Consignment'
                  ELSE NULL
               END
                  AS SALETYPE,
               LGT.DOCDT                   AS LOGISTIC_DOC_DATE,
               CASE
                  WHEN M.RELEASE_STATUS = 'P' THEN 'Posted'
                  WHEN M.RELEASE_STATUS = 'U' THEN 'Unposted'
                  WHEN M.RELEASE_STATUS = 'R' THEN 'Reversed'
                  ELSE NULL
               END
                  AS RELEASE_STATUS,
               L.PRICELISTNAME             AS PRICELIST_NAME,
               CASE
                  WHEN NVL (L.INCLUDE_VAT_IN_DISCOUNT, 'N') = 'Y' THEN 'Yes'
                  WHEN NVL (L.INCLUDE_VAT_IN_DISCOUNT, 'N') = 'N' THEN 'No'
                  ELSE NULL
               END
                  AS INCLUDE_TAX,
               R.NAME                      AS TRADE_GROUP_NAME,
               D.MRP                       AS INVOICE_RSP,
               D.DISCOUNT_FACTOR,
               CHG.CGST_RATE,
               CHG.CGST_AMOUNT,
               CHG.SGST_RATE,
               CHG.SGST_AMOUNT,
               CHG.IGST_RATE,
               CHG.IGST_AMOUNT,
               CHG.CESS_RATE,
               CHG.CESS_AMOUNT,
               CHG.TAXABLE_AMOUNT,
               RLS.FNAME                   AS RELEASE_BY,
               M.RELEASE_TIME              AS RELEASE_ON,
               D.SALES_ORDER_NO,
               D.SALES_ORDER_DATE,
               M.INLOCCODE                 AS LOCCODE,
               NULL                        AS REFERENCE_NO,
               NULL                        AS REFERENCE_DATE,
               M.UDFSTRING01,
               M.UDFSTRING02,
               M.UDFSTRING03,
               M.UDFSTRING04,
               M.UDFSTRING05,
               M.UDFSTRING06,
               M.UDFSTRING07,
               M.UDFSTRING08,
               M.UDFSTRING09,
               M.UDFSTRING10,
               M.UDFNUM01,
               M.UDFNUM02,
               M.UDFNUM03,
               M.UDFNUM04,
               M.UDFNUM05,
               M.UDFDATE01,
               M.UDFDATE02,
               M.UDFDATE03,
               M.UDFDATE04,
               M.UDFDATE05
          FROM SALINVMAIN M
               LEFT JOIN
               (  SELECT T1.CODE,
                         T1.INVCODE,
                         T2.SCHEME_DOCNO,
                         T2.DCDT,
                         T1.ICODE,
                         SUM (NVL (T1.INVQTY, 0)) AS INVQTY,
                         NVL (T1.RATE, 0)       AS RATE,
                         T1.REM,
                         SUM (NVL (T1.INVAMT, 0)) AS INVAMT,
                         T1.COSTRATE,
                         T2.PRICELISTCODE,
                         T1.MRP,
                         T3.FACTOR              AS DISCOUNT_FACTOR,
                         T4.SCHEME_DOCNO        AS SALES_ORDER_NO,
                         T4.ORDDT               AS SALES_ORDER_DATE
                    FROM SALINVDET T1
                         LEFT JOIN INVDCMAIN T2 ON T1.DCCODE = T2.DCCODE
                         JOIN INVDCDET T3 ON T1.INVDCDET_CODE = T3.CODE
                         LEFT JOIN SALORDDET T5 ON T3.SALORDDET_CODE = T5.CODE
                         LEFT JOIN SALORDMAIN T4 ON T5.ORDCODE = T4.ORDCODE
                   WHERE (T1.INVCODE IN (SELECT SALINVMAIN.INVCODE
                                           FROM SALINVMAIN))
                GROUP BY T1.CODE,
                         T1.INVCODE,
                         T2.SCHEME_DOCNO,
                         T2.DCDT,
                         T1.ICODE,
                         T1.RATE,
                         T1.REM,
                         T1.COSTRATE,
                         T2.PRICELISTCODE,
                         T1.MRP,
                         T3.FACTOR,
                         T4.SCHEME_DOCNO,
                         T4.ORDDT) D
                  ON M.INVCODE = D.INVCODE
               JOIN ADMYEAR ON M.YCODE = ADMYEAR.YCODE
               JOIN FINGL G ON M.GLCODE = G.GLCODE
               LEFT JOIN FINSL SL ON M.SLCODE = SL.SLCODE
               LEFT JOIN SALTERMMAIN
                  ON M.SALTERMCODE = SALTERMMAIN.SALTERMCODE
               LEFT JOIN FINSL A ON M.AGCODE = A.SLCODE
               LEFT JOIN INVLGTNOTE LGT ON M.LGTCODE = LGT.LGTCODE
               JOIN HRDEMP ON M.ECODE = HRDEMP.ECODE
               LEFT JOIN HRDEMP MODIFIED_EMP
                  ON M.LAST_ACCESS_ECODE = MODIFIED_EMP.ECODE
               JOIN ADMDOCSCHEME DOCSH ON M.DOCCODE = DOCSH.DOCCODE
               JOIN ADMSITE SITE ON M.ADMSITE_CODE = SITE.CODE
               LEFT JOIN FINSL T ON M.TRPCODE = T.SLCODE
               JOIN ADMSITE SRC ON M.ADMSITE_CODE_OWNER = SRC.CODE
               LEFT JOIN FINTRADEGRP R ON M.SALTRADEGRP_CODE = R.CODE
               LEFT JOIN FINFORM N ON M.FORMCODE = N.FORMCODE
               LEFT JOIN HRDEMP RLS ON M.RELEASE_ECODE = RLS.ECODE
               LEFT JOIN SALPRICELISTMAIN L
                  ON D.PRICELISTCODE = L.PRICELISTCODE
               LEFT JOIN
               (  SELECT SCI.SALINVDET_CODE,
                         SCI.APPAMT                 TAXABLE_AMOUNT,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'CGST'
                               THEN
                                  SCI.RATE
                               ELSE
                                  0
                            END)
                            AS CGST_RATE,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'CGST'
                               THEN
                                  SCI.CHGAMT
                               ELSE
                                  0
                            END)
                            AS CGST_AMOUNT,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'SGST'
                               THEN
                                  SCI.RATE
                               ELSE
                                  0
                            END)
                            AS SGST_RATE,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'SGST'
                               THEN
                                  SCI.CHGAMT
                               ELSE
                                  0
                            END)
                            AS SGST_AMOUNT,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'IGST'
                               THEN
                                  SCI.RATE
                               ELSE
                                  0
                            END)
                            AS IGST_RATE,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'IGST'
                               THEN
                                  SCI.CHGAMT
                               ELSE
                                  0
                            END)
                            AS IGST_AMOUNT,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'CESS'
                               THEN
                                  SCI.RATE
                               ELSE
                                  0
                            END)
                            AS CESS_RATE,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'CESS'
                               THEN
                                  SCI.CHGAMT
                               ELSE
                                  0
                            END)
                            AS CESS_AMOUNT,
                         SUM (NVL (SCI.CHGAMT, 0)) AS TAX_AMOUNT
                    FROM SALINVCHG_ITEM SCI
                         JOIN SALCHG SC ON SCI.CHGCODE = SC.SALCHGCODE
                   WHERE     NVL (SCI.ISTAX, 'N') = 'Y'
                         AND (SCI.INVCODE IN (SELECT SALINVMAIN.INVCODE
                                                FROM SALINVMAIN))
                GROUP BY SCI.SALINVDET_CODE,SCI.APPAMT) CHG
                  ON D.CODE = CHG.SALINVDET_CODE
               LEFT JOIN
               (  SELECT SALINVCHG_ITEM.SALINVDET_CODE,
                         SUM (NVL (SALINVCHG_ITEM.CHGAMT, 0)) AS TAX_AMOUNT
                    FROM SALINVCHG_ITEM
                         JOIN SALCHG
                            ON SALINVCHG_ITEM.CHGCODE = SALCHG.SALCHGCODE
                   WHERE (SALINVCHG_ITEM.INVCODE IN (SELECT SALINVMAIN.INVCODE
                                                       FROM SALINVMAIN))
                GROUP BY SALINVCHG_ITEM.SALINVDET_CODE) TOT_CHG
                  ON D.CODE = TOT_CHG.SALINVDET_CODE
               LEFT JOIN
               (  SELECT SALINVCHG_ITEM.SALINVDET_CODE,
                         SUM (NVL (SALINVCHG_ITEM.CHGAMT, 0)) AS CHGAMT
                    FROM SALINVCHG_ITEM
                   WHERE     SALINVCHG_ITEM.ISTAX = 'N'
                         AND SALINVCHG_ITEM.CHGAMT > 0
                GROUP BY SALINVCHG_ITEM.SALINVDET_CODE) IOC
                  ON D.CODE = IOC.SALINVDET_CODE
               LEFT JOIN
               (  SELECT SALINVCHG_ITEM.SALINVDET_CODE,
                         SUM (NVL (SALINVCHG_ITEM.CHGAMT, 0)) AS CHGAMT
                    FROM SALINVCHG_ITEM
                   WHERE     SALINVCHG_ITEM.ISTAX = 'N'
                         AND SALINVCHG_ITEM.CHGAMT <= 0
                GROUP BY SALINVCHG_ITEM.SALINVDET_CODE) IDC
                  ON D.CODE = IDC.SALINVDET_CODE
               LEFT JOIN
               (  SELECT SALINVCHG_ITEM.SALINVDET_CODE,
                         SUM (NVL (SALINVCHG_ITEM.CHGAMT, 0)) AS CHGAMT
                    FROM SALINVCHG_ITEM
                   WHERE SALINVCHG_ITEM.ISTAX = 'Y'
                GROUP BY SALINVCHG_ITEM.SALINVDET_CODE) ITC
                  ON D.CODE = ITC.SALINVDET_CODE
        UNION ALL
        SELECT CASE
                  WHEN SITE.SITETYPE LIKE '%CM%' THEN 'TRANSFER IN'
                  ELSE 'RETURN'
               END
                  AS INVOICE_TYPE,
               ADMYEAR.YNAME                   AS ACCOUNTING_PERIOD,
               M.ADMSITE_CODE_OWNER            AS ADMSITE_CODE_SRC,
               M.ADMSITE_CODE                  AS ADMSITE_CODE_DES,
               M.PCODE                         AS CUSTOMER_CODE,
               DOCSH.DOCNAME                   AS DOCUMENT_SCHEME,
               M.SCHEME_DOCNO                  AS INVOICE_NO,
               M.RTDT                          AS INVOICE_DATE,
               M.DOCNO                         AS DOC_NO,
               M.DOCDT                         AS DOC_DATE,
               NULL                            AS DUE_DATE,
               A.SLNAME                        AS AGENT_NAME,
               A.ABBRE                         AS AGENT_ALIAS,
               M.AGRATE                        AS AGENCY_COMMISSION,
               G.GLNAME                        AS SALES_LEDGER,
               SL.SLNAME                       AS SALES_SUBLEDGER,
               SALTERMMAIN.SALTERMNAME         AS SALES_TERM_NAME,
               LGT.LGTNO                       AS LOGISTIC_NO,
               LGT.LGTDT                       AS LOGISTIC_DATE,
               LGT.DOCNO                       AS LOGISTIC_DOCNO,
               LGT.DOCDT                       AS LOGISTIC_DOCUMENT_DATE,
               LGT.QTY1                        AS LOGISTIC_QTY,
               MIS_FUN_DISPLAY_DOCNO ('GTI', GATE.YCODE, GATE.GATEINNO)
                  AS GATEIN_NO,
               GATE.GATEINDT                   AS GATEIN_DATE,
               HRDEMP.FNAME                    AS PREPARED_BY,
               M.TIME                          AS PREPARED_TIME,
               HRDEMP1.FNAME                   AS LAST_ACCESS_BY,
               M.LAST_ACCESS_TIME,
               M.REM                           AS INVOICE_REMARKS,
               D.SCHEME_DOCNO                  AS CHALLAN_NO,
               D.DCDT                          AS CHALLAN_DATE,
               D.ICODE                         AS BARCODE,
               D.REM                           AS ITEM_REMARKS,
               0 - D.QTY                       AS INVOICE_QTY,
               0 - D.RTAMT                     AS INVOICE_AMOUNT,
               0 - D.RTAMT                     AS INVOICE_GROSS_AMOUNT,
               IOC.CHGAMT                      AS INVOICE_OTHER_CHARGE_AMT,
               IDC.CHGAMT                      AS INVOICE_DISCOUNT_CHARGE_AMT,
               ITC.CHGAMT                      AS INVOICE_TAX_CHARGE_AMT,
               0 - NVL (TOT_CHG.TAX_AMOUNT, 0) AS INVOICE_CHARGE_AMOUNT,
               0 - (NVL (D.RTAMT, 0) + NVL (TOT_CHG.TAX_AMOUNT, 0))
                  AS INVOICE_NET_AMOUNT,
               D.RATE                          AS INVOICE_RATE,
               D.COSTRATE                      AS INVOICE_COSTRATE,
               M.ADJAMT                        AS INVOICE_ADJ_AMOUNT,
               NULL                            AS INVOICE_TRANSPORTER,
               CASE
                  WHEN M.SALETYPE = 'O' THEN 'Outright'
                  WHEN M.SALETYPE = 'C' THEN 'Consignment'
                  ELSE NULL
               END
                  AS SALETYPE,
               LGT.DOCDT                       AS LOGISTIC_DOC_DATE,
               CASE
                  WHEN M.RELEASE_STATUS = 'P' THEN 'Posted'
                  WHEN M.RELEASE_STATUS = 'U' THEN 'Unposted'
                  WHEN M.RELEASE_STATUS = 'R' THEN 'Reversed'
                  ELSE NULL
               END
                  AS RELEASE_STATUS,
               NULL                            AS PRICELIST_NAME,
               NULL                            AS INCLUDE_TAX,
               R.NAME                          AS TRADE_GROUP_NAME,
               D.MRP                           AS INVOICE_RSP,
               0                               AS DISCOUNT_FACTOR,
               CHG.CGST_RATE,
               CHG.CGST_AMOUNT,
               CHG.SGST_RATE,
               CHG.SGST_AMOUNT,
               CHG.IGST_RATE,
               CHG.IGST_AMOUNT,
               CHG.CESS_RATE,
               CHG.CESS_AMOUNT,
               CHG.TAXABLE_AMOUNT,
               RLS.FNAME                       AS RELEASE_BY,
               M.RELEASE_TIME                  AS RELEASE_ON,
               NULL                            AS SALES_ORDER_NO,
               NULL                            AS SALES_ORDER_DATE,
               M.INLOCCODE                     AS LOCCODE,
               CASE
                  /*WHEN m.invcode IS NOT NULL THEN d.reference_no*/
                  /*bug id - 111783*/
               WHEN D.INVCODE IS NOT NULL THEN D.REFERENCE_NO
                  ELSE GRT.DOCNO
               END
                  AS REFERENCE_NO,
               CASE
                  /*WHEN m.invcode IS NOT NULL THEN d.reference_date*/
                  /*bug id - 111783*/
               WHEN D.INVCODE IS NOT NULL THEN D.REFERENCE_DATE
                  ELSE GRT.DOCDT
               END
                  AS REFERENCE_DATE,
               M.UDFSTRING01,
               M.UDFSTRING02,
               M.UDFSTRING03,
               M.UDFSTRING04,
               M.UDFSTRING05,
               M.UDFSTRING06,
               M.UDFSTRING07,
               M.UDFSTRING08,
               M.UDFSTRING09,
               M.UDFSTRING10,
               M.UDFNUM01,
               M.UDFNUM02,
               M.UDFNUM03,
               M.UDFNUM04,
               M.UDFNUM05,
               M.UDFDATE01,
               M.UDFDATE02,
               M.UDFDATE03,
               M.UDFDATE04,
               M.UDFDATE05
          FROM SALRTMAIN M
               LEFT JOIN
               (  SELECT T1.CODE,
                         T1.RTCODE,
                         T2.SCHEME_DOCNO,
                         T2.DCDT,
                         T1.ICODE,
                         SUM (NVL (T1.QTY, 0))                  AS QTY,
                         NVL (T1.RATE, 0)                       AS RATE,
                         T1.REM,
                         SUM (NVL (T1.RATE, 0) * NVL (T1.QTY, 0)) AS RTAMT,
                         T1.COSTRATE,
                         T1.MRP,
                         T3.REFERENCE_NO,
                         T3.REFERENCE_DATE,
                         T1.INVCODE                        /*bug id - 111783*/
                    FROM SALRTDET T1
                         LEFT JOIN INVDCMAIN T2 ON T1.DCCODE = T2.DCCODE
                         LEFT JOIN
                         (SELECT D_1.CODE,
                                 M_1.SCHEME_DOCNO AS REFERENCE_NO,
                                 M_1.INVDT      AS REFERENCE_DATE
                            FROM SALINVMAIN M_1
                                 JOIN SALINVDET D_1
                                    ON D_1.INVCODE = M_1.INVCODE) T3
                            ON T1.SALINVDET_CODE = T3.CODE
                   WHERE (T1.RTCODE IN (SELECT SALRTMAIN.RTCODE
                                          FROM SALRTMAIN))
                GROUP BY T1.CODE,
                         T1.RTCODE,
                         T2.SCHEME_DOCNO,
                         T2.DCDT,
                         T1.ICODE,
                         T1.RATE,
                         T1.REM,
                         T1.COSTRATE,
                         T1.MRP,
                         T3.REFERENCE_NO,
                         T3.REFERENCE_DATE,
                         T1.INVCODE) D
                  ON M.RTCODE = D.RTCODE
               JOIN ADMYEAR ON M.YCODE = ADMYEAR.YCODE
               JOIN FINGL G ON M.GLCODE = G.GLCODE
               LEFT JOIN FINSL SL ON M.SLCODE = SL.SLCODE
               LEFT JOIN SALTERMMAIN
                  ON M.SALTERMCODE = SALTERMMAIN.SALTERMCODE
               LEFT JOIN FINSL A ON M.AGCODE = A.SLCODE
               JOIN HRDEMP ON M.ECODE = HRDEMP.ECODE
               LEFT JOIN HRDEMP HRDEMP1
                  ON M.LAST_ACCESS_ECODE = HRDEMP1.ECODE
               LEFT JOIN INVGATEIN GATE ON M.INVGATEIN_CODE = GATE.CODE
               LEFT JOIN INVLGTNOTE LGT
                  ON M.LGTCODE = LGT.LGTCODE OR GATE.LGTCODE = LGT.LGTCODE
               JOIN ADMDOCSCHEME DOCSH ON M.DOCCODE = DOCSH.DOCCODE
               JOIN ADMSITE SITE ON M.ADMSITE_CODE = SITE.CODE
               JOIN ADMSITE SRC ON M.ADMSITE_CODE_OWNER = SRC.CODE
               LEFT JOIN FINTRADEGRP R ON M.SALTRADEGRP_CODE = R.CODE
               LEFT JOIN FINFORM N ON M.FORMCODE = N.FORMCODE
               LEFT JOIN HRDEMP RLS ON M.RELEASE_ECODE = RLS.ECODE
               LEFT JOIN
               (  SELECT SCI.SALRTDET_CODE,
                         SCI.APPAMT                 TAXABLE_AMOUNT,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'CGST'
                               THEN
                                  SCI.RATE
                               ELSE
                                  0
                            END)
                            AS CGST_RATE,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'CGST'
                               THEN
                                  SCI.CHGAMT
                               ELSE
                                  0
                            END)
                            AS CGST_AMOUNT,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'SGST'
                               THEN
                                  SCI.RATE
                               ELSE
                                  0
                            END)
                            AS SGST_RATE,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'SGST'
                               THEN
                                  SCI.CHGAMT
                               ELSE
                                  0
                            END)
                            AS SGST_AMOUNT,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'IGST'
                               THEN
                                  SCI.RATE
                               ELSE
                                  0
                            END)
                            AS IGST_RATE,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'IGST'
                               THEN
                                  SCI.CHGAMT
                               ELSE
                                  0
                            END)
                            AS IGST_AMOUNT,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'CESS'
                               THEN
                                  SCI.RATE
                               ELSE
                                  0
                            END)
                            AS CESS_RATE,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'CESS'
                               THEN
                                  SCI.CHGAMT
                               ELSE
                                  0
                            END)
                            AS CESS_AMOUNT,
                         SUM (NVL (SCI.CHGAMT, 0)) AS TAX_AMOUNT
                    FROM SALRTCHG_ITEM SCI, SALCHG SC
                   WHERE     SCI.CHGCODE = SC.SALCHGCODE
                         AND NVL (SCI.ISTAX, 'N') = 'Y'
                         AND (SCI.RTCODE IN (SELECT SALRTMAIN.RTCODE
                                               FROM SALRTMAIN))
                GROUP BY SCI.SALRTDET_CODE,SCI.APPAMT) CHG
                  ON D.CODE = CHG.SALRTDET_CODE
               LEFT JOIN
               (  SELECT SALRTCHG_ITEM.SALRTDET_CODE,
                         SUM (NVL (SALRTCHG_ITEM.CHGAMT, 0)) AS TAX_AMOUNT
                    FROM SALRTCHG_ITEM, SALCHG
                   WHERE     SALRTCHG_ITEM.CHGCODE = SALCHG.SALCHGCODE
                         AND (SALRTCHG_ITEM.RTCODE IN (SELECT SALRTMAIN.RTCODE
                                                         FROM SALRTMAIN))
                GROUP BY SALRTCHG_ITEM.SALRTDET_CODE) TOT_CHG
                  ON D.CODE = TOT_CHG.SALRTDET_CODE
               LEFT JOIN
               (  SELECT SALRTCHG_ITEM.SALRTDET_CODE,
                         SUM (NVL (SALRTCHG_ITEM.CHGAMT, 0) * '-1') AS CHGAMT
                    FROM SALRTCHG_ITEM
                   WHERE SALRTCHG_ITEM.ISTAX = 'N' AND SALRTCHG_ITEM.CHGAMT > 0
                GROUP BY SALRTCHG_ITEM.SALRTDET_CODE) IOC
                  ON D.CODE = IOC.SALRTDET_CODE
               LEFT JOIN
               (  SELECT SALRTCHG_ITEM.SALRTDET_CODE,
                         SUM (NVL (SALRTCHG_ITEM.CHGAMT, 0) * '-1') AS CHGAMT
                    FROM SALRTCHG_ITEM
                   WHERE     SALRTCHG_ITEM.ISTAX = 'N'
                         AND SALRTCHG_ITEM.CHGAMT <= 0
                GROUP BY SALRTCHG_ITEM.SALRTDET_CODE) IDC
                  ON D.CODE = IDC.SALRTDET_CODE
               LEFT JOIN
               (  SELECT SALRTCHG_ITEM.SALRTDET_CODE,
                         SUM (NVL (SALRTCHG_ITEM.CHGAMT, 0) * '-1') AS CHGAMT
                    FROM SALRTCHG_ITEM
                   WHERE SALRTCHG_ITEM.ISTAX = 'Y'
                GROUP BY SALRTCHG_ITEM.SALRTDET_CODE) ITC
                  ON D.CODE = ITC.SALRTDET_CODE
               LEFT JOIN PSITE_GRT GRT ON M.PSITE_GRT_CODE = GRT.CODE
        UNION ALL
        SELECT CASE
                  WHEN JM.JRNTYPE = 'C' THEN 'SALES CREDIT NOTE'
                  WHEN JM.JRNTYPE = 'D' THEN 'SALES DEBIT NOTE'
                  ELSE NULL
               END
                  AS INVOICE_TYPE,
               Y.YNAME               AS ACCOUNTING_PERIOD,
               JM.ADMSITE_CODE_OWNER AS ADMSITE_CODE_SRC,
               JM.ADMSITE_CODE       AS ADMSITE_CODE_DES,
               JM.PCODE              AS CUSTOMER_CODE,
               DS.DOCNAME            AS DOCUMENT_SCHEME,
               JM.SCHEME_DOCNO       AS INVOICE_NO,
               JM.JRNDT              AS INVOICE_DATE,
               JM.DOCNO              AS DOC_NO,
               JM.DOCDT              AS DOC_DATE,
               NULL                  AS DUE_DATE,
               NULL                  AS AGENT_NAME,
               NULL                  AS AGENT_ALIAS,
               NULL                  AS AGENCY_COMMISSION,
               GL.GLNAME             AS SALES_LEDGER,
               SL.SLNAME             AS SALES_SUBLEDGER,
               CASE
                  WHEN SL.SLNAME IS NULL THEN STR.SALTERMNAME
                  ELSE SL.SLNAME
               END
                  AS SALES_TERM_NAME,
               NULL                  AS LOGISTIC_NO,
               NULL                  AS LOGISTIC_DATE,
               NULL                  AS LOGISTIC_DOCNO,
               NULL                  AS LOGISTIC_DOCUMENT_DATE,
               NULL                  AS LOGISTIC_QTY,
               NULL                  AS GATEIN_NO,
               NULL                  AS GATEIN_DATE,
               H.FNAME               AS PREPARED_BY,
               JM.TIME               AS PREPARED_TIME,
               H1.FNAME              AS LAST_ACCESS_BY,
               JM.LAST_MODIFIED_ON   AS LAST_ACCESS_TIME,
               JM.REMARKS            AS INVOICE_REMARKS,
               NULL                  AS CHALLAN_NO,
               NULL                  AS CHALLAN_DATE,
               JD.ICODE              AS BARCODE,
               JD.REMARKS            AS ITEM_REMARKS,
               CASE
                  WHEN JM.JRNTYPE = 'C' THEN JD.QTY * '-1'
                  WHEN JM.JRNTYPE = 'D' THEN JD.QTY
                  ELSE NULL
               END
                  AS INVOICE_QTY,
               CASE
                  WHEN JM.JRNTYPE = 'C' THEN JD.AMOUNT * '-1'
                  WHEN JM.JRNTYPE = 'D' THEN JD.AMOUNT
                  ELSE NULL
               END
                  AS INVOICE_AMOUNT,
               CASE
                  WHEN JM.JRNTYPE = 'C' THEN JD.AMOUNT * '-1'
                  WHEN JM.JRNTYPE = 'D' THEN JD.AMOUNT
                  ELSE NULL
               END
                  AS INVOICE_GROSS_AMOUNT,
               CASE
                  WHEN JM.JRNTYPE = 'C' THEN IOC.CHGAMT * '-1'
                  WHEN JM.JRNTYPE = 'D' THEN IOC.CHGAMT
                  ELSE NULL
               END
                  AS INVOICE_OTHER_CHARGE_AMT,
               CASE
                  WHEN JM.JRNTYPE = 'C' THEN IDC.CHGAMT * '-1'
                  WHEN JM.JRNTYPE = 'D' THEN IDC.CHGAMT
                  ELSE NULL
               END
                  AS INVOICE_DISCOUNT_CHARGE_AMT,
               CASE
                  WHEN JM.JRNTYPE = 'C' THEN ITC.CHGAMT * '-1'
                  WHEN JM.JRNTYPE = 'D' THEN ITC.CHGAMT
                  ELSE NULL
               END
                  AS INVOICE_TAX_CHARGE_AMT,
               CASE
                  WHEN JM.JRNTYPE = 'C' THEN ICM.CHGAMT * '-1'
                  WHEN JM.JRNTYPE = 'D' THEN ICM.CHGAMT
                  ELSE NULL
               END
                  AS INVOICE_CHARGE_AMOUNT,
               CASE
                  WHEN JM.JRNTYPE = 'C' THEN JM.NETAMT * '-1'
                  WHEN JM.JRNTYPE = 'D' THEN JM.NETAMT
                  ELSE NULL
               END
                  AS INVOICE_NET_AMOUNT,
               JD.RATE               AS INVOICE_RATE,
               NULL                  AS INVOICE_COSTRATE,
               CASE
                  WHEN JM.JRNTYPE = 'C' THEN JM.ADJAMT * '-1'
                  WHEN JM.JRNTYPE = 'D' THEN JM.ADJAMT
                  ELSE NULL
               END
                  AS INVOICE_ADJ_AMOUNT,
               NULL                  AS INVOICE_TRANSPORTER,
               CASE
                  WHEN SM.SALETYPE = 'C' THEN 'Consignment'
                  WHEN SM.SALETYPE = 'O' THEN 'Outright'
                  ELSE NULL
               END
                  AS SALETYPE,
               NULL                  AS LOGISTIC_DOC_DATE,
               CASE
                  WHEN JM.RELEASE_STATUS = 'P' THEN 'Posted'
                  WHEN JM.RELEASE_STATUS = 'U' THEN 'Unposted'
                  WHEN JM.RELEASE_STATUS = 'R' THEN 'Reversed'
                  ELSE NULL
               END
                  AS RELEASE_STATUS,
               NULL                  AS PRICELIST_NAME,
               NULL                  AS INCLUDE_TAX,
               TG.NAME               AS TRADE_GROUP_NAME,
               JD.RSP                AS INVOICE_RSP,
               NULL                  AS DISCOUNT_FACTOR,
               CHG.CGST_RATE,
               CHG.CGST_AMOUNT,
               CHG.SGST_RATE,
               CHG.SGST_AMOUNT,
               CHG.IGST_RATE,
               CHG.IGST_AMOUNT,
               CHG.CESS_RATE,
               CHG.CESS_AMOUNT,
               CHG.TAXABLE_AMOUNT,
               H2.FNAME              AS RELEASE_BY,
               JM.RELEASE_TIME       AS RELEASE_ON,
               NULL                  AS SALES_ORDER_NO,
               NULL                  AS SALES_ORDER_DATE,
               NULL                  AS LOCCODE,
               SM.SCHEME_DOCNO       AS REFERENCE_NO,
               SM.INVDT              AS REFERENCE_DATE,
               JM.UDFSTRING01,
               JM.UDFSTRING02,
               JM.UDFSTRING03,
               JM.UDFSTRING04,
               JM.UDFSTRING05,
               JM.UDFSTRING06,
               JM.UDFSTRING07,
               JM.UDFSTRING08,
               JM.UDFSTRING09,
               JM.UDFSTRING10,
               JM.UDFNUM01,
               JM.UDFNUM02,
               JM.UDFNUM03,
               JM.UDFNUM04,
               JM.UDFNUM05,
               JM.UDFDATE01,
               JM.UDFDATE02,
               JM.UDFDATE03,
               JM.UDFDATE04,
               JM.UDFDATE05
          FROM SALINVJRNMAIN JM
               JOIN SALINVJRNDET JD ON JM.JRNCODE = JD.JRNCODE
               JOIN ADMDOCSCHEME DS ON JM.DOCCODE = DS.DOCCODE
               JOIN ADMYEAR Y ON JM.YCODE = Y.YCODE
               LEFT JOIN SALINVMAIN SM ON SM.INVCODE = JM.SALINVMAIN_CODE
               JOIN SALINVDET SD ON JD.SALINVDET_CODE = SD.CODE
               LEFT JOIN FINTRADEGRP TG ON JM.SALTRADEGRP_CODE = TG.CODE
               LEFT JOIN FINGL GL ON JM.JRNGLCODE = GL.GLCODE
               LEFT JOIN FINSL SL ON JM.JRNSLCODE = SL.SLCODE
               JOIN HRDEMP H ON JM.ECODE = H.ECODE
               LEFT JOIN HRDEMP H1 ON H1.ECODE = JM.LAST_MODIFIED_BY
               LEFT JOIN HRDEMP H2 ON JM.RELEASE_ECODE = H2.ECODE
               JOIN ADMSITE SRC ON JM.ADMSITE_CODE_OWNER = SRC.CODE
               LEFT JOIN SALTERMMAIN STR ON JM.SALTERMCODE = STR.SALTERMCODE
               LEFT JOIN
               (  SELECT SALINVJRNCHG_ITEM.SALINVJRNDET_CODE,
                         SUM (NVL (SALINVJRNCHG_ITEM.CHGAMT, 0)) AS CHGAMT
                    FROM SALINVJRNCHG_ITEM
                GROUP BY SALINVJRNCHG_ITEM.SALINVJRNDET_CODE) ICM
                  ON JD.CODE = ICM.SALINVJRNDET_CODE
               LEFT JOIN
               (  SELECT SCI.SALINVJRNDET_CODE,
                         SCI.APPAMT                 TAXABLE_AMOUNT,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'CGST'
                               THEN
                                  SCI.RATE
                               ELSE
                                  0
                            END)
                            AS CGST_RATE,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'CGST'
                               THEN
                                  SCI.CHGAMT
                               ELSE
                                  0
                            END)
                            AS CGST_AMOUNT,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'SGST'
                               THEN
                                  SCI.RATE
                               ELSE
                                  0
                            END)
                            AS SGST_RATE,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'SGST'
                               THEN
                                  SCI.CHGAMT
                               ELSE
                                  0
                            END)
                            AS SGST_AMOUNT,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'IGST'
                               THEN
                                  SCI.RATE
                               ELSE
                                  0
                            END)
                            AS IGST_RATE,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'IGST'
                               THEN
                                  SCI.CHGAMT
                               ELSE
                                  0
                            END)
                            AS IGST_AMOUNT,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'CESS'
                               THEN
                                  SCI.RATE
                               ELSE
                                  0
                            END)
                            AS CESS_RATE,
                         SUM (
                            CASE
                               WHEN     SCI.SOURCE = 'G'
                                    AND SCI.GST_COMPONENT = 'CESS'
                               THEN
                                  SCI.CHGAMT
                               ELSE
                                  0
                            END)
                            AS CESS_AMOUNT,
                         SUM (NVL (SCI.CHGAMT, 0)) AS TAX_AMOUNT
                    FROM SALINVJRNCHG_ITEM SCI, SALCHG SC
                   WHERE     SCI.CHGCODE = SC.SALCHGCODE
                         AND NVL (SCI.ISTAX, 'N') = 'Y'
                         AND (SCI.JRNCODE IN (SELECT SALINVJRNMAIN.JRNCODE
                                                FROM SALINVJRNMAIN))
                GROUP BY SCI.SALINVJRNDET_CODE,SCI.APPAMT) CHG
                  ON JD.CODE = CHG.SALINVJRNDET_CODE
               LEFT JOIN
               (  SELECT SALINVJRNCHG_ITEM.SALINVJRNDET_CODE,
                         SUM (NVL (SALINVJRNCHG_ITEM.CHGAMT, 0)) AS CHGAMT
                    FROM SALINVJRNCHG_ITEM
                   WHERE     SALINVJRNCHG_ITEM.ISTAX = 'N'
                         AND SALINVJRNCHG_ITEM.CHGAMT > 0
                GROUP BY SALINVJRNCHG_ITEM.SALINVJRNDET_CODE) IOC
                  ON JD.CODE = IOC.SALINVJRNDET_CODE
               LEFT JOIN
               (  SELECT SALINVJRNCHG_ITEM.SALINVJRNDET_CODE,
                         SUM (NVL (SALINVJRNCHG_ITEM.CHGAMT, 0)) AS CHGAMT
                    FROM SALINVJRNCHG_ITEM
                   WHERE     SALINVJRNCHG_ITEM.ISTAX = 'N'
                         AND SALINVJRNCHG_ITEM.CHGAMT <= 0
                GROUP BY SALINVJRNCHG_ITEM.SALINVJRNDET_CODE) IDC
                  ON JD.CODE = IDC.SALINVJRNDET_CODE
               LEFT JOIN
               (  SELECT SALINVJRNCHG_ITEM.SALINVJRNDET_CODE,
                         SUM (NVL (SALINVJRNCHG_ITEM.CHGAMT, 0)) AS CHGAMT
                    FROM SALINVJRNCHG_ITEM
                   WHERE SALINVJRNCHG_ITEM.ISTAX = 'Y'
                GROUP BY SALINVJRNCHG_ITEM.SALINVJRNDET_CODE) ITC
                  ON JD.CODE = ITC.SALINVJRNDET_CODE) X