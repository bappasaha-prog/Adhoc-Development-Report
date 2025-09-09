/*|| Custom Development || Object : CQ_RESALE || Ticket Id :  427094 || Developer : Dipankar ||*/

WITH RET
     AS (  SELECT D.ICODE,
                  AG.SLNAME               AGENT_NAME,
                  M.RTDT                  RETURN_DATE,
                  SUM (COALESCE (D.QTY, 0)) RETURN_QTY
             FROM SALRTMAIN M
                  INNER JOIN SALRTDET D ON M.RTCODE = D.RTCODE
                  LEFT JOIN FINSL AG ON M.AGCODE = AG.SLCODE
            WHERE     M.SALETYPE = 'O'
                  AND TRUNC (M.RTDT) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                         AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
         GROUP BY D.ICODE, AG.SLNAME, M.RTDT),
     SAL
     AS (  SELECT D.ICODE,
                  AG.SLNAME                  AGENT_NAME,
                  M.INVDT                    INVOICE_DATE,
                  SUM (COALESCE (D.INVQTY, 0)) SALE_QTY
             FROM SALINVMAIN M
                  INNER JOIN SALINVDET D ON M.INVCODE = D.INVCODE
                  LEFT JOIN FINSL AG ON M.AGCODE = AG.SLCODE
            WHERE     TRUNC (M.INVDT) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                          AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                  AND M.SALETYPE = 'O'
                  AND D.ICODE IN (SELECT ICODE
                                    FROM RET)
         GROUP BY D.ICODE, AG.SLNAME, M.INVDT),
     STK
     AS (  SELECT K.ICODE, SUM (COALESCE (K.QTY, 0)) STOCK_QTY
             FROM INVSTOCK K LEFT JOIN INVLOC L ON K.LOCCODE = L.LOCCODE
            WHERE     K.ENTDT <= SYSDATE
                  AND L.LOCTYPE = 'W'
                  AND K.ICODE IN (SELECT ICODE
                                    FROM RET)
         GROUP BY K.ICODE)
SELECT GINVIEW.FNC_UK () UK,
       A.ICODE,
       A.AGENT_NAME,
       A.RETURN_QTY,
       B.SALE_QTY,
       C.STOCK_QTY,
       D.RESALE_QTY
  FROM (  SELECT ICODE,
                 AGENT_NAME,
                 COALESCE (SUM (COALESCE (RETURN_QTY, 0)), 0) RETURN_QTY
            FROM RET
        GROUP BY ICODE, AGENT_NAME) A
       LEFT JOIN
       (  SELECT ICODE,
                 AGENT_NAME,
                 COALESCE (SUM (COALESCE (SALE_QTY, 0)), 0) SALE_QTY
            FROM SAL
        GROUP BY ICODE, AGENT_NAME) B
          ON (A.ICODE = B.ICODE AND A.AGENT_NAME = B.AGENT_NAME)
       LEFT JOIN STK C ON A.ICODE = C.ICODE
       LEFT JOIN
       (  SELECT A.ICODE,
                 SUM (
                    CASE
                       WHEN B.INVOICE_DATE >= A.RETURN_DATE THEN B.SALE_QTY
                       ELSE 0
                    END)
                    RESALE_QTY
            FROM (  SELECT ICODE, AGENT_NAME, MIN (RETURN_DATE) RETURN_DATE
                      FROM RET
                  GROUP BY ICODE, AGENT_NAME) A
                 LEFT JOIN (  SELECT ICODE, INVOICE_DATE, SUM (SALE_QTY) SALE_QTY
                                FROM SAL
                            GROUP BY ICODE, INVOICE_DATE) B
                    ON A.ICODE = B.ICODE
        GROUP BY A.ICODE) D
          ON A.ICODE = D.ICODE