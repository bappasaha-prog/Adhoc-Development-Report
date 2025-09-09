/* Formatted on 2025-04-15 18:02:11 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_PO_TRACKING_DET || Ticket Id : 405316 || Developer : Dipankar || ><><><*/
  SELECT GINVIEW.FNC_UK () UK,
         M.SCHEME_DOCNO    PO_NO,
         M.ORDDT::date   PO_DATE,
         C.NAME            SUPPLIER_NAME,
         M.UDFDATE01::date SUPPLIER_DELIVERY_DATE,
         SUM (D.ORDQTY)    PO_QTY,
         G.GATEINDT        GATE_ENTRY_DATE,
         GM.GRCDT::date  GRC_DATE,
         SUM (GD.ACQTY)    GRC_QTY
    FROM PURORDMAIN M
         INNER JOIN PURORDDET D ON M.ORDCODE = D.ORDCODE
         LEFT JOIN GINVIEW.LV_CUSTOMER_SUPPLIER C ON M.PCODE = C.CODE
         LEFT JOIN INVGRCDET GD ON D.CODE = GD.PO_CODE
         LEFT JOIN INVGRCMAIN GM ON GD.GRCCODE = GM.GRCCODE
         LEFT JOIN INVGATEIN G ON GM.INVGATEIN_CODE = G.CODE
   WHERE M.ORDDT::date BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                             AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
GROUP BY M.SCHEME_DOCNO,
         M.ORDDT::date,
         C.NAME,
         M.UDFDATE01::date,
         G.GATEINDT,
         GM.GRCDT::date