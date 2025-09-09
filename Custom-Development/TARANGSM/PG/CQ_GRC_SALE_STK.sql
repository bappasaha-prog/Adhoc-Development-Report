/*|| Custom Development || Object : CQ_GRC_SALE_STK || Ticket Id :  430241 || Developer : Dipankar ||*/

WITH GRC
     AS (  SELECT D.ICODE,
                  M.PCODE,
                  M.GRCDT::DATE     GRC_DATE,
                  SUM (D.ACQTY) GRC_QTY
             FROM INVGRCMAIN M INNER JOIN INVGRCDET D ON M.GRCCODE = D.GRCCODE
             where M.GRCDT::DATE between to_DATE('@DTFR@','YYYY-MM-DD') and to_DATE('@DTTO@','YYYY-MM-DD')
         GROUP BY D.ICODE, M.PCODE, M.GRCDT::DATE),
     SAL
     AS (  SELECT D.ICODE, SUM (D.QTY) SALE_QTY
             FROM PSITE_POSBILLITEM D
            WHERE D.ICODE IN (SELECT ICODE
                                FROM GRC)
         GROUP BY D.ICODE),
     STK
     AS (  SELECT ICODE, SUM (QTY) STK_QTY
             FROM INVSTOCK
            WHERE LOCCODE <> 2 AND ICODE IN (SELECT ICODE FROM GRC)
         GROUP BY ICODE),
     LSALE
     AS (SELECT ICODE,
                BILLDATE::DATE LAST_SALE_DATE,
                ROW_NUMBER ()
                   OVER (PARTITION BY ICODE ORDER BY BILLDATE DESC)
                   RN
           FROM (SELECT D.ICODE, M.BILLDATE
                   FROM PSITE_POSBILL M
                        INNER JOIN PSITE_POSBILLITEM D
                           ON M.CODE = D.PSITE_POSBILL_CODE))
  SELECT ROW_NUMBER () OVER () UK,
         A.ICODE,
         A.PCODE,
         A.GRC_DATE,
         D.LAST_SALE_DATE,
         SUM (A.GRC_QTY)     GRC_QTY,
         SUM (B.SALE_QTY)    SALE_QTY,
         SUM (C.STK_QTY)     STK_QTY
    FROM GRC A
         LEFT JOIN SAL B ON A.ICODE = B.ICODE
         LEFT JOIN STK C ON A.ICODE = C.ICODE
         LEFT JOIN (SELECT ICODE, LAST_SALE_DATE
                      FROM LSALE
                     WHERE RN = 1) D
            ON A.ICODE = D.ICODE
GROUP BY A.ICODE,
         A.PCODE,
         A.GRC_DATE,
         D.LAST_SALE_DATE