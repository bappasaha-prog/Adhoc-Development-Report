/*|| Custom Development || Object : CQ_PO_PI || Ticket Id :  425501 || Developer : Dipankar ||*/

WITH DTA
     AS (  SELECT GM.SCHEME_DOCNO              GRC_RECEIVE_NO,
                  GM.DOCNO                     GRC_DOCUMENT_NO,
                  GM.GRCDT                     GRC_DATE,
                  GRM.SCHEME_DOCNO             GRT_NO,
                  GRM.GRTDT                    GRT_DATE,
                  SUM (GRT.QTY)                GRT_QTY,
                  POM.ADMSITE_CODE,
                  POD.ICODE,
                  POM.PCODE,
                  SUM (COALESCE (ACQTY, 0))    GRC_QTY,
                  PM.SCHEME_DOCNO              PI_INVOICE_NO,
                  PM.DOCNO                     PI_DOCUMENT_NO,
                  PM.DOCDT                     PI_DOCUMENT_DATE,
                  POM.SCHEME_DOCNO             PO_NUMBER,
                  POM.ORDDT                    PO_DATE,
                  CONCAT (CONCAT (CONCAT (MAR.FNAME, '['), MAR.ECODE), ']')
                     MARCHANDISER,
                  INITCAP (
                     CASE
                        WHEN POM.STAT = 'P' THEN 'PARTIAL RECEIVED'
                        WHEN POM.STAT = 'T' THEN 'TOTAL RECEIVED/CANCELLED'
                        WHEN POM.STAT = 'N' THEN 'NEW'
                        ELSE 'TOTAL RECEIVED/CANCELLED'
                     END)
                     STATUS,
                  POM.DTTO                     VALID_TILL,
                  SUM (COALESCE (POD.ORDQTY, 0)) PO_QTY,
                  SUM (COALESCE (PD.QTY, 0))   PI_QTY
             FROM PURORDMAIN POM
                  INNER JOIN PURORDDET POD ON POD.ORDCODE = POM.ORDCODE
                  LEFT JOIN HRDEMP MAR ON POM.MRCHNDSRCODE = MAR.ECODE
                  LEFT JOIN INVGRCDET GD
                     ON POD.CODE = GD.PO_CODE AND POD.ORDCODE = GD.ORDCODE
                  LEFT JOIN INVGRCMAIN GM ON GD.GRCCODE = GM.GRCCODE
                  LEFT JOIN PURINVDET PD ON GD.CODE = PD.INVGRCDET_CODE
                  LEFT JOIN PURINVMAIN PM ON PD.INVCODE = PM.INVCODE
                  LEFT JOIN INVGRTDET GRT
                     ON     GD.CODE = GRT.INVGRCDET_CODE
                        AND GD.GRCCODE = GRT.GRCCODE
                  LEFT JOIN INVGRTMAIN GRM ON GRT.GRTCODE = GRM.GRTCODE
            WHERE POM.ORDDT BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
         GROUP BY GM.SCHEME_DOCNO,
                  GM.DOCNO,
                  GM.GRCDT,
                  GRM.SCHEME_DOCNO,
                  GRM.GRTDT,
                  POM.ADMSITE_CODE,
                  POD.ICODE,
                  POM.PCODE,
                  POM.SCHEME_DOCNO,
                  POM.ORDDT,
                  CONCAT (CONCAT (CONCAT (MAR.FNAME, '['), MAR.ECODE), ']'),
                  INITCAP (
                     CASE
                        WHEN POM.STAT = 'P' THEN 'PARTIAL RECEIVED'
                        WHEN POM.STAT = 'T' THEN 'TOTAL RECEIVED/CANCELLED'
                        WHEN POM.STAT = 'N' THEN 'NEW'
                        ELSE 'TOTAL RECEIVED/CANCELLED'
                     END),
                  POM.DTTO,
                  PM.SCHEME_DOCNO,
                  PM.DOCNO,
                  PM.DOCDT),
     SELECTED_ICODE
     AS (SELECT DISTINCT ICODE
           FROM DTA)
SELECT GINVIEW.FNC_UK () UK,
       GRC_RECEIVE_NO,
       GRC_DOCUMENT_NO,
       GRC_DATE,
       GRT_NO,
       GRT_DATE,
       PI_DOCUMENT_NO,
       PI_INVOICE_NO,
       PI_DOCUMENT_DATE,
       PO_NUMBER,
       PO_DATE,
       MARCHANDISER,
       STATUS,
       VALID_TILL,
       ADMSITE_CODE,
       PCODE,
       GRC_PI.ICODE,
       GRC_QTY,
       PI_QTY,
       PO_QTY,
       GRT_QTY,
       ONLINE_SALE_QTY,
       STORE_SALE_QTY,
       HO_SALE_QTY,
       TOTAL_SALE_QTY,
       CURRENT_STOCK
  FROM DTA GRC_PI
       LEFT OUTER JOIN
       (  SELECT ICODE,
                 SUM (ETL_SALE_QTY) ONLINE_SALE_QTY,
                 SUM (RTL_SALE_QTY) STORE_SALE_QTY,
                 SUM (INV_SALE_QTY) HO_SALE_QTY,
                 (SUM (ETL_SALE_QTY) + SUM (RTL_SALE_QTY) + SUM (INV_SALE_QTY))
                    TOTAL_SALE_QTY,
                 SUM (CURRENT_STOCK) CURRENT_STOCK
            FROM (  SELECT 'ETL'                        SALE_TYPE,
                           ICODE,
                           SUM (COALESCE (SALCSDET.QTY, 0)) ETL_SALE_QTY,
                           0                            RTL_SALE_QTY,
                           0                            INV_SALE_QTY,
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
                             SUM (COALESCE (SALINVDET.INVQTY, 0))
                           - SUM (COALESCE (SALINVDET.RTQTY, 0))
                              INV_SALE_QTY,
                           0 CURRENT_STOCK
                      FROM SALINVMAIN
                           INNER JOIN SALINVDET
                              ON SALINVMAIN.INVCODE = SALINVDET.INVCODE
                     WHERE     SALETYPE = 'O'
                           AND ICODE IN (SELECT ICODE
                                           FROM SELECTED_ICODE)
                  GROUP BY ICODE
                  UNION ALL
                    SELECT NULL                  SALE_TYPE,
                           ICODE,
                           0                     ETL_SALE_QTY,
                           0                     RTL_SALE_QTY,
                           0                     INV_SALE_QTY,
                           SUM (COALESCE (K.QTY, 0)) CURRENT_STOCK
                      FROM INVSTOCK_ONHAND K
                     WHERE     K.LOCCODE <> 2
                           AND ICODE IN (SELECT ICODE
                                           FROM SELECTED_ICODE)
                  GROUP BY ICODE)
        GROUP BY ICODE) SAL
          ON GRC_PI.ICODE = SAL.ICODE