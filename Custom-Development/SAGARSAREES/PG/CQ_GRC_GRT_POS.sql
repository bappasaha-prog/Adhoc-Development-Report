/* Formatted on 2025-02-25 18:39:40 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_GRC_GRT_POS || Ticket Id : 394421 || Developer : Dipankar || ><><><*/
SELECT GINVIEW.FNC_UK () UK,
       F.DOCUMENT_TYPE,
       F.ADMSITE_CODE,
       F.VENDOR,
       F.DOCUMENT_DATE,
       F.DOCUMENT_NO,
       F.QTY,
       F.AMOUNT
  FROM (  SELECT 'GRC'           DOCUMENT_TYPE,
                 M.ADMSITE_CODE_IN ADMSITE_CODE,
                 I.CATEGORY1     VENDOR,
                 M.GRCDT::DATE DOCUMENT_DATE,
                 M.SCHEME_DOCNO  DOCUMENT_NO,
                 SUM (D.ACQTY)   QTY,
                 SUM (D.NETAMT)  AMOUNT
            FROM INVGRCMAIN M
                 INNER JOIN INVGRCDET D ON M.GRCCODE = D.GRCCODE
                 INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
        GROUP BY M.ADMSITE_CODE_IN,
                 I.CATEGORY1,
                 M.GRCDT::DATE,
                 M.SCHEME_DOCNO
        UNION ALL
          SELECT 'GRT'         DOCUMENT_TYPE,
                 M.ADMSITE_CODE,
                 I.CATEGORY1   VENDOR,
                 M.GRTDT::DATE DOCUMENT_DATE,
                 M.SCHEME_DOCNO DOCUMENT_NO,
                 SUM (D.QTY)   QTY,
                 SUM (D.NETAMT) AMOUNT
            FROM INVGRTMAIN M
                 INNER JOIN INVGRTDET D ON M.GRTCODE = D.GRTCODE
                 INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
        GROUP BY M.ADMSITE_CODE,
                 I.CATEGORY1,
                 M.GRTDT::DATE,
                 M.SCHEME_DOCNO
        UNION ALL
          SELECT 'POS SALE'       DOCUMENT_TYPE,
                 M.ADMSITE_CODE,
                 I.CATEGORY1      VENDOR,
                 M.BILLDATE::DATE DOCUMENT_DATE,
                 M.BILLNO         DOCUMENT_NO,
                 SUM (D.QTY)      QTY,
                 SUM (D.NETAMT)   AMOUNT
            FROM PSITE_POSBILL M
                 INNER JOIN PSITE_POSBILLITEM D
                    ON M.CODE = D.PSITE_POSBILL_CODE
                 INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
           WHERE D.QTY > 0
        GROUP BY M.ADMSITE_CODE,
                 I.CATEGORY1,
                 M.BILLDATE::DATE,
                 M.BILLNO
        UNION ALL
          SELECT 'POS SALE RETURN' DOCUMENT_TYPE,
                 M.ADMSITE_CODE,
                 I.CATEGORY1      VENDOR,
                 M.BILLDATE::DATE DOCUMENT_DATE,
                 M.BILLNO         DOCUMENT_NO,
                 SUM (D.QTY)      QTY,
                 SUM (D.NETAMT)   AMOUNT
            FROM PSITE_POSBILL M
                 INNER JOIN PSITE_POSBILLITEM D
                    ON M.CODE = D.PSITE_POSBILL_CODE
                 INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
           WHERE D.QTY < 0
        GROUP BY M.ADMSITE_CODE,
                 I.CATEGORY1,
                 M.BILLDATE::DATE,
                 M.BILLNO) F