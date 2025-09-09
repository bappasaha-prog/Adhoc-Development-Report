/* Formatted on 2025-03-10 15:13:26 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_PO_GRC || Ticket Id :  397557 || Developer : Dipankar || ><><><*/

SELECT GINVIEW.FNC_UK () UK,
       F.TYPE,
       F.ICODE,
       F.ORDER_NO,
       F.ORDER_DATE,
       F.VALID_DATE,
       F.PO_REMARKS,
       F.GRC_REMARKS,
       F.PCODE,
       F.GRC_NO,
       F.GRC_DATE,
       F.GRC_DOC_NO,
       F.GRC_DOC_DATE,
       F.ORDER_QTY,
       F.RECEIVE_QTY,
       F.PENDING_QTY
  FROM (  SELECT 'Against Order'                   TYPE,
                 D.ICODE,
                 M.SCHEME_DOCNO                    ORDER_NO,
                 M.ORDDT                           ORDER_DATE,
                 M.DTTO                            VALID_DATE,
                 M.REM                             PO_REMARKS,
                 GM.REM                            GRC_REMARKS,
                 M.PCODE,
                 LISTAGG (GM.SCHEME_DOCNO, ',')
                    WITHIN GROUP (ORDER BY GM.SCHEME_DOCNO)
                    GRC_NO,
                 LISTAGG (
                    TO_CHAR (TO_DATE (GM.GRCDT, 'DD/MON/YY'), 'DD-MM-YYYY'),
                    ',')
                 WITHIN GROUP (ORDER BY GM.GRCDT)
                    GRC_DATE,
                 LISTAGG (GM.DOCNO, ',') WITHIN GROUP (ORDER BY GM.DOCNO)
                    GRC_DOC_NO,
                 LISTAGG (
                    TO_CHAR (TO_DATE (GM.DOCDT, 'DD/MON/YY'), 'DD-MM-YYYY'),
                    ',')
                 WITHIN GROUP (ORDER BY GM.DOCDT)
                    GRC_DOC_DATE,
                 SUM (D.ORDQTY)                    ORDER_QTY,
                 SUM (D.RCQTY)                     RECEIVE_QTY,
                 SUM (D.ORDQTY - D.RCQTY - D.CNLQTY) PENDING_QTY
            FROM PURORDMAIN M
                 INNER JOIN PURORDDET D ON M.ORDCODE = D.ORDCODE
                 LEFT JOIN INVGRCDET GD
                    ON D.CODE = GD.PO_CODE AND D.ORDCODE = GD.ORDCODE
                 LEFT JOIN INVGRCMAIN GM ON GD.GRCCODE = GM.GRCCODE
           WHERE TRUNC (M.ORDDT) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                     AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
        GROUP BY D.ICODE,
                 M.SCHEME_DOCNO,
                 M.ORDDT,
                 M.DTTO,
                 M.REM,
                 GM.REM,
                 M.PCODE
        UNION ALL
          SELECT 'Adhoc'      TYPE,
                 D.ICODE,
                 NULL         ORDER_NO,
                 NULL         ORDER_DATE,
                 NULL         VALID_DATE,
                 NULL         PO_REMARKS,
                 M.REM        GRC_REMARKS,
                 M.PCODE,
                 M.SCHEME_DOCNO GRC_NO,
                 TO_CHAR (TO_DATE (M.GRCDT, 'DD/MON/YY'), 'DD-MM-YYYY')
                    GRC_DATE,
                 M.DOCNO      GRC_DOC_NO,
                 TO_CHAR (TO_DATE (M.DOCDT, 'DD/MON/YY'), 'DD-MM-YYYY')
                    GRC_DOC_DATE,
                 0            ORDER_QTY,
                 SUM (D.ACQTY) RECEIVE_QTY,
                 SUM (D.ACQTY) PENDING_QTY
            FROM INVGRCMAIN M INNER JOIN INVGRCDET D ON M.GRCCODE = D.GRCCODE
           WHERE     D.ORDCODE IS NULL
                 AND TRUNC (M.GRCDT) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                         AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
        GROUP BY D.ICODE,
                 M.REM,
                 M.PCODE,
                 M.SCHEME_DOCNO,
                 TO_CHAR (TO_DATE (M.GRCDT, 'DD/MON/YY'), 'DD-MM-YYYY'),
                 M.DOCNO,
                 TO_CHAR (TO_DATE (M.DOCDT, 'DD/MON/YY'), 'DD-MM-YYYY')) F