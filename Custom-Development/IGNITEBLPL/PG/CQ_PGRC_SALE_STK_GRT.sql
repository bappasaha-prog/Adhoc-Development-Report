/*|| Custom Development || Object : CQ_PGRC_SALE_STK_GRT || Ticket Id :  412713 || Developer : Dipankar ||*/
WITH DTA
     AS (  SELECT D.ICODE,
                  M.ADMSITE_CODE,
                  MIN (M.CREATEDON)::DATE TRANSFER_IN_DATE,
                  SUM (D.RECEIVEQTY) TRANSFER_IN_QTY
             FROM PSITE_GRC M
                  INNER JOIN PSITE_GRCITEM D ON M.CODE = D.PSITE_GRC_CODE
            WHERE M.DOCDT::DATE BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                              AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
         GROUP BY D.ICODE, M.ADMSITE_CODE)
  SELECT ROW_NUMBER() OVER() AS UK,
         A.ADMSITE_CODE,
         A.ICODE,
         A.TRANSFER_IN_DATE,
         A.TRANSFER_IN_QTY,
         D.QTY OPENING_QTY,
         C.SALE_QTY,
         B.TRANSFER_OUT_QTY
    FROM DTA A
         LEFT JOIN
         (  SELECT D.ICODE, M.ADMSITE_CODE, SUM (D.RTQTY) TRANSFER_OUT_QTY
              FROM PSITE_GRT M
                   INNER JOIN PSITE_GRTITEM D ON M.CODE = D.PSITE_GRT_CODE
             WHERE M.DOCDT::DATE BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                               AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
          GROUP BY D.ICODE, M.ADMSITE_CODE) B
            ON A.ICODE = B.ICODE AND A.ADMSITE_CODE = B.ADMSITE_CODE
         LEFT JOIN (  SELECT K.ICODE,
                             K.ADMSITE_CODE,
                             SUM (CASE WHEN K.ENTDT::DATE < A.TRANSFER_IN_DATE THEN K.QTY ELSE 0 END) QTY
                        FROM INVSTOCK K
                        inner join DTA A on K.ICODE = A.ICODE and K.ADMSITE_CODE = A.ADMSITE_CODE
                       WHERE K.LOCCODE <> 2
                    GROUP BY K.ICODE, K.ADMSITE_CODE) D
            ON A.ICODE = D.ICODE AND A.ADMSITE_CODE = D.ADMSITE_CODE
         LEFT JOIN
         (  SELECT D.ICODE,
                   M.ADMSITE_CODE,
                   SUM (
            CASE
               WHEN M.BILLDATE::DATE BETWEEN A.TRANSFER_IN_DATE
                                   AND A.TRANSFER_IN_DATE + 30
               THEN
                  D.QTY
               ELSE
                  0
            END) SALE_QTY
              FROM PSITE_POSBILL M
                   INNER JOIN PSITE_POSBILLITEM D
                      ON M.CODE = D.PSITE_POSBILL_CODE
                      inner join DTA A on D.ICODE = A.ICODE and M.ADMSITE_CODE = A.ADMSITE_CODE
          GROUP BY D.ICODE, M.ADMSITE_CODE) C
            ON A.ADMSITE_CODE = C.ADMSITE_CODE AND A.ICODE = C.ICODE