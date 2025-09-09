/* Formatted on 2025-08-25 13:19:11 (QP5 v5.294) */
WITH DTA
     AS (  SELECT GM.SCHEME_DOCNO            GRC_RECEIVE_NO,
                  GM.DOCNO                   GRC_DOCUMENT_NO,
                  GM.GRCDT                   GRC_DATE,
                  GM.ADMSITE_CODE_IN,
                  GD.ICODE,
                  GM.PCODE,
                  SUM (COALESCE (ACQTY, 0))  GRC_QTY,
                  SUM (COALESCE (GD.RTQTY, 0)) GRT_QTY,
                  PM.SCHEME_DOCNO            PI_INVOICE_NO,
                  PM.DOCNO                   PI_DOCUMENT_NO,
                  PM.DOCDT                   PI_DOCUMENT_DATE,
                  LISTAGG (POM.SCHEME_DOCNO, ', ')
                     WITHIN GROUP (ORDER BY POM.SCHEME_DOCNO)
                     PO_NUMBER,
                  LISTAGG (POD.ORDQTY, ', ')
                     WITHIN GROUP (ORDER BY POM.SCHEME_DOCNO)
                     AS PO_QTY,
                  SUM (COALESCE (QTY, 0))    PI_QTY
             FROM INVGRCMAIN GM
                  INNER JOIN INVGRCDET GD ON GM.GRCCODE = GD.GRCCODE
                  LEFT JOIN PURINVDET PD ON GD.CODE = PD.INVGRCDET_CODE
                  LEFT JOIN PURINVMAIN PM ON PD.INVCODE = PM.INVCODE
                  LEFT JOIN PURORDDET POD ON GD.PO_CODE = POD.CODE
                  LEFT JOIN PURORDMAIN POM ON POD.ORDCODE = POM.ORDCODE
            WHERE GM.GRCDT BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                               AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
         GROUP BY GM.SCHEME_DOCNO,
                  GM.DOCNO,
                  GM.GRCDT,
                  GM.ADMSITE_CODE_IN,
                  GD.ICODE,
                  GM.PCODE,
                  PM.SCHEME_DOCNO,
                  PM.DOCNO,
                  PM.DOCDT),
     SELECTED_ICODE
     AS (SELECT DISTINCT ICODE
           FROM DTA)
SELECT GINVIEW.FNC_UK UK,
       GRC_RECEIVE_NO,
       GRC_DOCUMENT_NO,
       GRC_DATE,
       PI_DOCUMENT_NO,
       PI_INVOICE_NO,
       PI_DOCUMENT_DATE,
       PO_NUMBER,
       ADMSITE_CODE_IN,
       PCODE,
       GRC_PI.ICODE,
       GRC_QTY,
       GRT_Qty,
       PI_QTY,
       PO_QTY,
       ONLINE_SALE_QTY,
       STORE_SALE_QTY,
       HO_SALE_QTY,
       TOTAL_SALE_QTY,
       HO_TROUT_QTY,
       POS_GRT_QTY,
       CURRENT_STOCK
  FROM DTA GRC_PI
       LEFT OUTER JOIN
       (  SELECT ICODE,
                 SUM (ETL_SALE_QTY) ONLINE_SALE_QTY,
                 SUM (RTL_SALE_QTY) STORE_SALE_QTY,
                 SUM (INV_SALE_QTY) HO_SALE_QTY,
                 SUM (TROUT_QTY)   HO_TROUT_QTY,
                 SUM (POS_GRT_QTY) POS_GRT_QTY,
                 (SUM (ETL_SALE_QTY) + SUM (RTL_SALE_QTY) + SUM (INV_SALE_QTY))
                    TOTAL_SALE_QTY,
                 SUM (CURRENT_STOCK) CURRENT_STOCK
            FROM (  SELECT 'ETL'                        SALE_TYPE,
                           ICODE,
                           SUM (COALESCE (SALCSDET.QTY, 0)) ETL_SALE_QTY,
                           0                            RTL_SALE_QTY,
                           0                            INV_SALE_QTY,
                           0                            TROUT_QTY,
                           0                            POS_GRT_QTY,
                           0                            CURRENT_STOCK
                      FROM SALCSMAIN
                           INNER JOIN SALCSDET
                              ON SALCSMAIN.CSCODE = SALCSDET.CSCODE
                     WHERE     CHANNELTYPE = 'ETL'
                           AND ICODE IN (SELECT ICODE
                                           FROM SELECTED_ICODE)
                  GROUP BY ICODE
                  UNION ALL
                    SELECT 'ETL'                        SALE_TYPE,
                           ICODE,
                           SUM (COALESCE (SALSSDET.QTY, 0)) ETL_SALE_QTY,
                           0                            RTL_SALE_QTY,
                           0                            INV_SALE_QTY,
                           0                            TROUT_QTY,
                           0                            POS_GRT_QTY,
                           0                            CURRENT_STOCK
                      FROM SALSSMAIN
                           INNER JOIN SALSSDET
                              ON SALSSMAIN.SSCODE = SALSSDET.SSCODE
                     WHERE     CHANNELTYPE = 'ETL'
                           AND ICODE IN (SELECT ICODE
                                           FROM SELECTED_ICODE)
                  GROUP BY ICODE
                  UNION ALL
                    SELECT 'RTL'                                 SALE_TYPE,
                           ICODE,
                           0                                     ETL_SALE_QTY,
                           SUM (COALESCE (PSITE_POSBILLITEM.QTY, 0)) RTL_SALE_QTY,
                           0                                     INV_SALE_QTY,
                           0                                     TROUT_QTY,
                           0                                     POS_GRT_QTY,
                           0
                              CURRENT_STOCK
                      FROM PSITE_POSBILL
                           INNER JOIN PSITE_POSBILLITEM
                              ON PSITE_POSBILL.CODE =
                                    PSITE_POSBILLITEM.PSITE_POSBILL_CODE
                     WHERE ICODE IN (SELECT ICODE
                                       FROM SELECTED_ICODE)
                  GROUP BY ICODE
                  UNION ALL
                    SELECT 'INV' SALE_TYPE,
                           ICODE,
                           0 ETL_SALE_QTY,
                           0 RTL_SALE_QTY,
                           SUM (
                              CASE
                                 WHEN SALETYPE = 'O'
                                 THEN
                                      COALESCE (SALINVDET.INVQTY, 0)
                                    - COALESCE (SALINVDET.RTQTY, 0)
                                 ELSE
                                    0
                              END)
                              INV_SALE_QTY,
                           SUM (
                              CASE
                                 WHEN SALETYPE = 'C'
                                 THEN
                                      COALESCE (SALINVDET.INVQTY, 0)
                                    - COALESCE (SALINVDET.RTQTY, 0)
                                 ELSE
                                    0
                              END)
                              TROUT_QTY,
                           0 POS_GRT_QTY,
                           0 CURRENT_STOCK
                      FROM SALINVMAIN
                           INNER JOIN SALINVDET
                              ON SALINVMAIN.INVCODE = SALINVDET.INVCODE
                     WHERE ICODE IN (SELECT ICODE
                                       FROM SELECTED_ICODE)
                  GROUP BY ICODE
                  UNION ALL
                    SELECT 'RTL'                   SALE_TYPE,
                           D.ICODE,
                           0                       ETL_SALE_QTY,
                           0                       RTL_SALE_QTY,
                           0                       INV_SALE_QTY,
                           0                       TROUT_QTY,
                           SUM (COALESCE (D.RTQTY, 0)) POS_GRT_QTY,
                           0                       CURRENT_STOCK
                      FROM PSITE_GRT M
                           INNER JOIN PSITE_GRTITEM D
                              ON M.CODE = D.PSITE_GRT_CODE
                     WHERE D.ICODE IN (SELECT ICODE
                                         FROM SELECTED_ICODE)
                  GROUP BY D.ICODE
                  UNION ALL
                    SELECT NULL                  SALE_TYPE,
                           ICODE,
                           0                     ETL_SALE_QTY,
                           0                     RTL_SALE_QTY,
                           0                     INV_SALE_QTY,
                           0                     TROUT_QTY,
                           0                     POS_GRT_QTY,
                           SUM (COALESCE (K.QTY, 0)) CURRENT_STOCK
                      FROM INVSTOCK_ONHAND K
                     WHERE     K.LOCCODE <> 2
                           AND ICODE IN (SELECT ICODE
                                           FROM SELECTED_ICODE)
                  GROUP BY ICODE)
        GROUP BY ICODE) SAL
          ON GRC_PI.ICODE = SAL.ICODE