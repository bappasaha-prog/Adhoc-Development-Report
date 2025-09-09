/*|| Custom Development || Object : CQ_PI_SALE_STK || Ticket Id :  429510 || Developer : Dipankar ||*/

WITH PUR
     AS (  SELECT D.ICODE,
                  M.PCODE,
                  M.SCHEME_DOCNO PI_NO,
                  M.INVDT::DATE      PI_DATE,
                  M.DOCNO      DOC_NO,
                  M.DOCDT::DATE      DOC_DATE,
                  M.ADJAMT,
                  SUM (D.QTY)  PI_QTY,
                  SUM (D.NETAMT) PI_AMOUNT
             FROM PURINVMAIN M INNER JOIN PURINVDET D ON M.INVCODE = D.INVCODE
             where M.INVDT::DATE between to_DATE('@DTFR@','YYYY-MM-DD') and to_DATE('@DTTO@','YYYY-MM-DD')
         GROUP BY D.ICODE,
                  M.PCODE,
                  M.SCHEME_DOCNO,
                  M.INVDT::DATE,
                  M.DOCNO,
                  M.DOCDT::DATE,
                  M.ADJAMT),
     SAL
     AS (  SELECT ICODE, SUM (SALE_QTY) SALE_QTY
             FROM (  SELECT D.ICODE, SUM (D.INVQTY) SALE_QTY
                       FROM SALINVMAIN M
                            INNER JOIN SALINVDET D ON M.INVCODE = D.INVCODE
                      WHERE     M.SALETYPE = 'O'
                            AND D.ICODE IN (SELECT ICODE
                                              FROM PUR)
                   GROUP BY D.ICODE
                   UNION ALL
                     SELECT D.ICODE, SUM (D.QTY) SALE_QTY
                       FROM SALCSDET D
                      WHERE D.ICODE IN (SELECT ICODE
                                          FROM PUR)
                   GROUP BY D.ICODE)
         GROUP BY ICODE),
     STK
     AS (  SELECT ICODE, SUM (QTY) STK_QTY
             FROM INVSTOCK
            WHERE LOCCODE <> 2 AND ICODE IN (SELECT ICODE FROM PUR)
         GROUP BY ICODE),
     PRT
     as ( SELECT ICODE, SUM (QTY) RETURN_QTY
             FROM PURRTDET
            WHERE ICODE IN (SELECT ICODE FROM PUR)
         GROUP BY ICODE)
  SELECT ROW_NUMBER() OVER() UK,
         A.PCODE,
         A.PI_NO,
         A.PI_DATE,
         A.DOC_NO,
         A.DOC_DATE,
         A.ADJAMT,
         SUM (A.PI_QTY) PI_QTY,
         SUM (PI_AMOUNT) PI_AMOUNT,
         SUM (B.SALE_QTY) SALE_QTY,
         SUM (C.STK_QTY) STK_QTY,
         SUM (D.RETURN_QTY) RETURN_QTY
    FROM PUR A
         LEFT JOIN SAL B ON A.ICODE = B.ICODE
         LEFT JOIN STK C ON A.ICODE = C.ICODE
         LEFT JOIN PRT D ON A.ICODE = D.ICODE
GROUP BY A.PCODE,
         A.PI_NO,
         A.PI_DATE,
         A.DOC_NO,
         A.DOC_DATE,
         A.ADJAMT