/*|| Custom Development || Object : CQ_PO_GRC || Ticket Id :  426265 || Developer : Dipankar ||*/

  SELECT GINVIEW.FNC_UK ()                   UK,
         M.ADMSITE_CODE,
         M.PCODE,
         D.ICODE,
         M.SCHEME_DOCNO                      ORDER_NO,
         M.ORDDT                             ORDER_DATE,
         M.DOCNO                             ORDER_DOC_NO,
         M.DTFR                              PO_VALID_FROM,
         M.DTTO                              PO_VALID_TILL,
         H.FNAME || '[' || H.ENO || ']'      PO_CREATED_BY,
         D.RATE                              ORDER_RATE,
         GM.SCHEME_DOCNO                     GRC_NO,
         GM.GRCDT                            GRC_DATE,
         GD.ACRATE                           GRC_RATE,
         INITCAP (
            CASE
               WHEN M.STAT = 'P' THEN 'PARTIAL RECEIVED'
               WHEN M.STAT = 'T' THEN 'TOTAL RECEIVED/CANCELLED'
               WHEN M.STAT = 'N' THEN 'NEW'
               ELSE 'TOTAL RECEIVED/CANCELLED'
            END)
            STATUS,
         SUM (COALESCE (D.ORDQTY, 0))        ORDER_QTY,
         SUM (COALESCE (D.CNLQTY, 0))        CANCEL_QTY,
         SUM (COALESCE (D.RCQTY, 0))         ORDER_GRC_QTY,
         SUM (COALESCE (GD.ACQTY, 0))        GRC_QTY,
         SUM (
              COALESCE (D.ORDQTY, 0)
            - COALESCE (D.RCQTY, 0)
            - COALESCE (D.CNLQTY, 0))
            PENDING_QTY,
         SUM (D.RATE * COALESCE (D.ORDQTY, 0)) ORDER_AMOUNT,
         SUM (COALESCE (D.NETAMT, 0))        PO_ITEM_NET_AMOUNT
    FROM PURORDMAIN M
         INNER JOIN PURORDDET D ON M.ORDCODE = D.ORDCODE
         INNER JOIN HRDEMP H ON M.ECODE = H.ECODE
         LEFT JOIN INVGRCDET GD
            ON D.CODE = GD.PO_CODE AND D.ORDCODE = GD.ORDCODE
         LEFT JOIN INVGRCMAIN GM ON GD.GRCCODE = GM.GRCCODE
   WHERE TRUNC (M.ORDDT) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                             AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
GROUP BY M.ADMSITE_CODE,
         M.PCODE,
         D.ICODE,
         M.SCHEME_DOCNO,
         M.ORDDT,
         M.DOCNO,
         M.DTFR,
         M.DTTO,
         H.FNAME || '[' || H.ENO || ']',
         D.RATE,
         GM.SCHEME_DOCNO,
         GM.GRCDT,
         GD.ACRATE,
         INITCAP (
            CASE
               WHEN M.STAT = 'P' THEN 'PARTIAL RECEIVED'
               WHEN M.STAT = 'T' THEN 'TOTAL RECEIVED/CANCELLED'
               WHEN M.STAT = 'N' THEN 'NEW'
               ELSE 'TOTAL RECEIVED/CANCELLED'
            END)