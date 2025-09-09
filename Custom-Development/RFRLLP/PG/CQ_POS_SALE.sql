/*|| Custom Development || Object : CQ_POS_SALE || Ticket Id :  413829 || Developer : Dipankar ||*/
  SELECT GINVIEW.FNC_UK ()          UK,
         A.ADMSITE_CODE,
         I.DIVISION,
         A.BILLDATE,
         SUM (A.SALE_QTY)           SALE_QTY,
         SUM (A.SALE_AMT)           SALE_AMT,
         SUM (A.NET_SALE_AMT)       NET_SALE_AMT,
         SUM ( (A.SALE_QTY * B.RATE)) CP
    FROM (  SELECT D.ICODE,
                   M.ADMSITE_CODE,
                   M.BILLDATE::DATE BILLDATE,
                   SUM (D.QTY)     SALE_QTY,
                   SUM (D.RSP * D.QTY) SALE_AMT,
                   SUM (D.NETAMT)  NET_SALE_AMT
              FROM PSITE_POSBILL M
                   INNER JOIN PSITE_POSBILLITEM D
                      ON M.CODE = D.PSITE_POSBILL_CODE
          GROUP BY D.ICODE, M.ADMSITE_CODE, M.BILLDATE::DATE) A
         LEFT JOIN
         (WITH PGRC
               AS (SELECT D.ICODE,
                          M.ADMSITE_CODE,
                          D.RATE,
                          ROW_NUMBER ()
                          OVER (PARTITION BY D.ICODE ORDER BY M.CREATEDON DESC)
                             RN
                     FROM PSITE_GRC M
                          INNER JOIN PSITE_GRCITEM D
                             ON M.CODE = D.PSITE_GRC_CODE)
          SELECT ICODE, ADMSITE_CODE, RATE
            FROM PGRC
           WHERE RN = 1) B
            ON A.ICODE = B.ICODE AND A.ADMSITE_CODE = B.ADMSITE_CODE
         INNER JOIN GINVIEW.LV_ITEM I ON A.ICODE = I.CODE
GROUP BY A.ADMSITE_CODE, I.DIVISION, A.BILLDATE