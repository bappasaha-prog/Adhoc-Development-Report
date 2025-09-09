/*|| Custom Development || Object : CQ_POS_STOCK_MOVEMENT || Ticket Id :  426548 || Developer : Dipankar ||*/

WITH CTE
     AS (  SELECT K.ICODE,
                  K.ADMSITE_CODE,
                  TRUNC (K.ENTDT) ENTRY_DATE,
                  COALESCE (SUM (CASE
                                    WHEN K.ENTTYPE IN ('ADJ',
                                                       'MIS',
                                                       'PIS',
                                                       'PRC')
                                    THEN
                                       COALESCE (K.QTY, 0)
                                 END),
                            0)
                     OTHER,
                  COALESCE (
                     SUM (
                        CASE
                           WHEN    K.ENTTYPE = 'GRC'
                                OR (K.ENTTYPE = 'STI' AND K.SUBENTTYPE = 'CII')
                           THEN
                              COALESCE (K.QTY, 0)
                        END),
                     0)
                     TOTAL_PURCHASE,
                  COALESCE (
                     SUM (
                        CASE
                           WHEN    K.ENTTYPE = 'GRT'
                                OR (K.ENTTYPE = 'STO' AND K.SUBENTTYPE = 'COO')
                           THEN
                              COALESCE (K.QTY, 0)
                        END),
                     0)
                     PURCHASE_RETURN,
                  0             TOTAL_SALES,
                  0             SALES_RETURN,
                  0             ONLINE_SALES,
                  0             ONLINE_SALES_RETURNS
             FROM INVSTOCK K LEFT JOIN ADMSITE S ON K.ADMSITE_CODE = S.CODE
            WHERE     S.ISPOS = 'Y'
                  AND S.ISSECONDARY = 'N'
                  AND K.ENTTYPE IN ('ADJ',
                                    'MIS',
                                    'PIS',
                                    'PRC',
                                    'GRC',
                                    'STI',
                                    'GRT',
                                    'STO')
                  AND TRUNC (K.ENTDT) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                          AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
         GROUP BY K.ICODE, K.ADMSITE_CODE, TRUNC (K.ENTDT)
         UNION ALL
           SELECT D.ICODE,
                  M.ADMSITE_CODE,
                  TRUNC (M.BILLDATE) ENTRY_DATE,
                  0                OTHER,
                  0                TOTAL_PURCHASE,
                  0                PURCHASE_RETURN,
                  COALESCE (
                     SUM (
                        CASE
                           WHEN COALESCE (D.QTY, 0) > 0
                           THEN
                              COALESCE (D.QTY, 0)
                        END),
                     0)
                     TOTAL_SALES,
                  COALESCE (
                     SUM (
                        CASE
                           WHEN COALESCE (D.QTY, 0) < 0
                           THEN
                              COALESCE (D.QTY, 0)
                        END),
                     0)
                     SALES_RETURN,
                  0                ONLINE_SALES,
                  0                ONLINE_SALES_RETURNS
             FROM PSITE_POSBILL M
                  INNER JOIN PSITE_POSBILLITEM D
                     ON M.CODE = D.PSITE_POSBILL_CODE
                  INNER JOIN ADMSITE S ON M.ADMSITE_CODE = S.CODE
            WHERE     S.ISPOS = 'Y'
                  AND S.ISSECONDARY = 'N'
                  AND TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@DTFR@',
                                                          'YYYY-MM-DD')
                                             AND TO_DATE ('@DTTO@',
                                                          'YYYY-MM-DD')
         GROUP BY D.ICODE, M.ADMSITE_CODE, TRUNC (M.BILLDATE)
         UNION ALL
           SELECT D.ICODE,
                  M.ADMSITE_CODE,
                  M.CSDATE ENTRY_DATE,
                  0      OTHER,
                  0      TOTAL_PURCHASE,
                  0      PURCHASE_RETURN,
                  0      TOTAL_SALES,
                  0      SALES_RETURN,
                  COALESCE (
                     SUM (
                        CASE
                           WHEN COALESCE (D.QTY, 0) > 0
                           THEN
                              COALESCE (D.QTY, 0)
                        END),
                     0)
                     ONLINE_SALES,
                  COALESCE (
                     SUM (
                        CASE
                           WHEN COALESCE (D.QTY, 0) < 0
                           THEN
                              COALESCE (D.QTY, 0)
                        END),
                     0)
                     ONLINE_SALES_RETURNS
             FROM SALCSMAIN M
                  INNER JOIN SALCSDET D ON M.CSCODE = D.CSCODE
                  INNER JOIN ADMSITE S ON M.ADMSITE_CODE = S.CODE
            WHERE     S.ISPOS = 'Y'
                  AND S.ISSECONDARY = 'N'
                  AND CHANNELTYPE = 'ETL'
                  AND TRUNC (M.CSDATE) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                           AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
         GROUP BY D.ICODE, M.ADMSITE_CODE, M.CSDATE)
  SELECT GINVIEW.FNC_UK ()                               UK,
         ICODE,
         ADMSITE_CODE,
         ENTRY_DATE,
         COALESCE (SUM (COALESCE (OTHER, 0)), 0)         OTHERS,
         COALESCE (SUM (COALESCE (TOTAL_PURCHASE, 0)), 0) TOTAL_PURCHASE,
         COALESCE (SUM (COALESCE (PURCHASE_RETURN, 0)), 0) PURCHASE_RETURNS,
         COALESCE (SUM (COALESCE (TOTAL_SALES, 0)), 0)   TOTAL_SALES,
         COALESCE (SUM (COALESCE (SALES_RETURN, 0)), 0)  SALES_RETURNS,
         COALESCE (SUM (COALESCE (ONLINE_SALES, 0)), 0)  ONLINE_SALES,
         COALESCE (SUM (COALESCE (ONLINE_SALES_RETURNS, 0)), 0)
            ONLINE_SALES_RETURNS
    FROM CTE
GROUP BY ICODE, ADMSITE_CODE, ENTRY_DATE
  HAVING (   COALESCE (SUM (COALESCE (OTHER, 0)), 0) <> 0
          OR COALESCE (SUM (COALESCE (TOTAL_PURCHASE, 0)), 0) <> 0
          OR COALESCE (SUM (COALESCE (PURCHASE_RETURN, 0)), 0) <> 0
          OR COALESCE (SUM (COALESCE (TOTAL_SALES, 0)), 0) <> 0
          OR COALESCE (SUM (COALESCE (SALES_RETURN, 0)), 0) <> 0
          OR COALESCE (SUM (COALESCE (ONLINE_SALES, 0)), 0) <> 0
          OR COALESCE (SUM (COALESCE (ONLINE_SALES_RETURNS, 0)), 0) <> 0)