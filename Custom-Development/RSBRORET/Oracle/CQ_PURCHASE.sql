/*|| Custom Development || Object : CQ_PURCHASE || Ticket Id :  424505 || Developer : Dipankar ||*/

WITH SELECTED_PI
     AS (  SELECT F.ENTCODE                INVCODE,
                  F.SCHEME_DOCNO           INVOICE_NO,
                  SUM (COALESCE (ADJAMT, 0)) PAID_AMOUNT,
                  (SUM (COALESCE (CAMOUNT, 0)) - SUM (COALESCE (ADJAMT, 0)))
                     PENDING
             FROM FINPOST F LEFT JOIN FINENTTYPE ENT ON F.ENTTYPE = ENT.ENTTYPE
            WHERE ENT.ENTNAME = 'Purchase Invoice'
         GROUP BY F.ENTCODE, F.SCHEME_DOCNO
           HAVING ( (SUM (COALESCE (CAMOUNT, 0)) - SUM (COALESCE (ADJAMT, 0))) <>
                      0)),
     PI
     AS (  SELECT M.ADMSITE_CODE,
                  M.PCODE,
                  M.INVCODE,
                  M.SCHEME_DOCNO             INVOICE_NO,
                  M.INVDT                    INVOICE_DATE,
                  M.DOCNO                    INVOICE_DOCNO,
                  TRUNC (M.DOCDT)            INVOICE_DOCDATE,
                  D.ICODE,
                  SUM (COALESCE (D.QTY, 0))  INVOICE_QTY,
                  SUM (COALESCE (D.NETAMT, 0)) INVOICE_NETAMT
             FROM PURINVMAIN M INNER JOIN PURINVDET D ON M.INVCODE = D.INVCODE
            WHERE TO_CHAR (M.INVCODE) IN (SELECT INVCODE
                                            FROM SELECTED_PI)
         GROUP BY M.ADMSITE_CODE,
                  M.PCODE,
                  M.INVCODE,
                  M.SCHEME_DOCNO,
                  M.INVDT,
                  M.DOCNO,
                  TRUNC (M.DOCDT),
                  D.ICODE)
SELECT GINVIEW.FNC_UK () UK,
       ADMSITE_CODE,
       PCODE,
       F.INVCODE,
       F.INVOICE_NO,
       INVOICE_DATE,
       INVOICE_DOCNO,
       INVOICE_DOCDATE,
       INVOICE_QTY,
       INVOICE_NETAMT,
       PAID_AMOUNT,
       PENDING,
       SALE_QTY,
       RETURN_QTY,
       STOCK_QTY
  FROM (  SELECT ADMSITE_CODE,
                 PCODE,
                 INVCODE,
                 INVOICE_NO,
                 INVOICE_DATE,
                 INVOICE_DOCNO,
                 INVOICE_DOCDATE,
                 SUM (INVOICE_QTY)  INVOICE_QTY,
                 SUM (INVOICE_NETAMT) INVOICE_NETAMT,
                 SUM (SALE_QTY)     SALE_QTY,
                 SUM (RETURN_QTY)   RETURN_QTY,
                 SUM (STOCK_QTY)    STOCK_QTY
            FROM (SELECT ADMSITE_CODE,
                         PCODE,
                         PI.INVCODE,
                         INVOICE_NO,
                         INVOICE_DATE,
                         INVOICE_DOCNO,
                         INVOICE_DOCDATE,
                         PI.ICODE,
                         INVOICE_QTY,
                         INVOICE_NETAMT,
                         SALE_QTY,
                         RETURN_QTY,
                         STOCK_QTY
                    FROM PI
                         LEFT JOIN
                         (  SELECT D.ICODE, SUM (COALESCE (D.QTY, 0)) SALE_QTY
                              FROM PSITE_POSBILLITEM D
                             WHERE     D.ICODE IN (SELECT ICODE
                                                     FROM PI)
                                   AND D.QTY > 0
                          GROUP BY D.ICODE) S
                            ON PI.ICODE = S.ICODE
                         LEFT JOIN
                         (  SELECT D.ICODE, SUM (COALESCE (D.QTY, 0)) RETURN_QTY
                              FROM PSITE_POSBILLITEM D
                             WHERE     D.ICODE IN (SELECT ICODE
                                                     FROM PI)
                                   AND D.QTY < 0
                          GROUP BY D.ICODE) R
                            ON PI.ICODE = R.ICODE
                         LEFT JOIN
                         (  SELECT ICODE, SUM (STOCK_QTY) STOCK_QTY
                              FROM (  SELECT K.ICODE,
                                             SUM (COALESCE (K.QTY, 0)) STOCK_QTY
                                        FROM INVSTOCK K
                                             LEFT JOIN INVLOC L
                                                ON K.LOCCODE = L.LOCCODE
                                       WHERE     L.LOCTYPE <> 'T'
                                             AND K.ICODE IN (SELECT ICODE
                                                               FROM PI)
                                    GROUP BY K.ICODE
                                    UNION ALL
                                      SELECT D.ICODE,
                                             -1 * SUM (COALESCE (D.QTY, 0))
                                                STOCK_QTY
                                        FROM PSITE_POSBILLITEM_PARK D
                                       WHERE D.ICODE IN (SELECT ICODE
                                                           FROM PI)
                                    GROUP BY D.ICODE)
                          GROUP BY ICODE) STK
                            ON PI.ICODE = STK.ICODE)
        GROUP BY ADMSITE_CODE,
                 PCODE,
                 INVCODE,
                 INVOICE_NO,
                 INVOICE_DATE,
                 INVOICE_DOCNO,
                 INVOICE_DOCDATE) F
       INNER JOIN SELECTED_PI I ON F.INVCODE = I.INVCODE