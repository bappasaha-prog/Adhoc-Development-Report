/*|| Custom Development || Object : CQ_NET_SALES_NEW || Ticket Id :  422671 || Developer : Dipankar ||*/

WITH DATA_SET
     AS (  SELECT M.ADMSITE_CODE,
                  I.DIVISION,
                  'RTL'                               CHANNELTYPE,
                  CASE
                     WHEN M.BILLDATE::DATE = TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                     THEN
                        M.BILLNO
                     ELSE
                        NULL
                  END
                     DATE_BILLNO,
                  M.BILLNO                            MTD_BILLNO,
                  SUM (
                     CASE
                        WHEN M.BILLDATE::DATE = TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                        THEN
                           D.QTY * COALESCE (CATEGORY1::numeric, 0)
                        ELSE
                           0
                     END)
                     DATE_NET_WEIGHT,
                  SUM (D.QTY * COALESCE (CATEGORY1::numeric, 0)) MTD_NET_WEIGHT,
                  SUM (
                     CASE
                        WHEN M.BILLDATE::DATE = TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                        THEN
                           D.QTY
                        ELSE
                           0
                     END)
                     DATE_NET_QTY,
                  SUM (D.QTY)                         MTD_NET_QTY,
                  SUM (
                     CASE
                        WHEN M.BILLDATE::DATE = TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                        THEN
                           D.NETAMT
                        ELSE
                           0
                     END)
                     DATE_NET_AMOUNT,
                  SUM (D.NETAMT)                      MTD_NET_AMOUNT,
                  SUM (
                     CASE
                        WHEN M.BILLDATE::DATE = TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                        THEN
                           CASE
                              WHEN PSITE_POSORDER_CODE IS NOT NULL THEN D.QTY
                              ELSE 0
                           END
                        ELSE
                           0
                     END)
                     DATE_ORDER_ITEMS_QTY,
                  SUM (
                     CASE
                        WHEN PSITE_POSORDER_CODE IS NOT NULL THEN D.QTY
                        ELSE 0
                     END)
                     MTD_ORDER_ITEMS_QTY,
                  SUM (
                     CASE
                        WHEN M.BILLDATE::DATE = TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                        THEN
                           CASE
                              WHEN PSITE_POSORDER_CODE IS NOT NULL
                              THEN
                                 D.NETAMT
                              ELSE
                                 0
                           END
                        ELSE
                           0
                     END)
                     DATE_ORDER_ITEMS_AMOUNT,
                  SUM (
                     CASE
                        WHEN PSITE_POSORDER_CODE IS NOT NULL THEN D.NETAMT
                        ELSE 0
                     END)
                     MTD_ORDER_ITEMS_AMOUNT
             FROM PSITE_POSBILL M
                  JOIN PSITE_POSBILLITEM D ON M.CODE = D.PSITE_POSBILL_CODE
                  JOIN INVITEM_DETAIL_AGG I ON D.ICODE = I.CODE
            WHERE     M.BILLDATE::DATE BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                     AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                  AND M.ADMSITE_CODE IN (3, 4)
         GROUP BY M.ADMSITE_CODE,
                  I.DIVISION,
                  CASE
                     WHEN M.BILLDATE::DATE = TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                     THEN
                        M.BILLNO
                     ELSE
                        NULL
                  END,
                  M.BILLNO
         UNION ALL
           SELECT M.ADMSITE_CODE,
                  I.DIVISION,
                  'ETL'                               CHANNELTYPE,
                  CASE
                     WHEN M.CSDATE::DATE = TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                     THEN
                        M.SCHEME_DOCNO
                     ELSE
                        NULL
                  END
                     DATE_BILLNO,
                  M.SCHEME_DOCNO                      MTD_BILLNO,
                  SUM (
                     CASE
                        WHEN M.CSDATE::DATE = TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                        THEN
                           D.QTY * COALESCE (CATEGORY1::numeric, 0)
                        ELSE
                           0
                     END)
                     DATE_NET_WEIGHT,
                  SUM (D.QTY * COALESCE (CATEGORY1::numeric, 0)) MTD_NET_WEIGHT,
                  SUM (
                     CASE
                        WHEN M.CSDATE::DATE = TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                        THEN
                           D.QTY
                        ELSE
                           0
                     END)
                     DATE_NET_QTY,
                  SUM (D.QTY)                         MTD_NET_QTY,
                  SUM (
                     CASE
                        WHEN M.CSDATE::DATE = TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                        THEN
                           D.NETAMT
                        ELSE
                           0
                     END)
                     DATE_NET_AMOUNT,
                  SUM (D.NETAMT)                      MTD_NET_AMOUNT,
                  SUM (
                     CASE
                        WHEN M.CSDATE::DATE = TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                        THEN
                           CASE
                              WHEN D.RETAILORDERDET_CODE IS NOT NULL THEN D.QTY
                              ELSE 0
                           END
                        ELSE
                           0
                     END)
                     DATE_ORDER_ITEMS_QTY,
                  SUM (
                     CASE
                        WHEN D.RETAILORDERDET_CODE IS NOT NULL THEN D.QTY
                        ELSE 0
                     END)
                     MTD_ORDER_ITEMS_QTY,
                  SUM (
                     CASE
                        WHEN M.CSDATE::DATE = TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                        THEN
                           CASE
                              WHEN D.RETAILORDERDET_CODE IS NOT NULL
                              THEN
                                 D.NETAMT
                              ELSE
                                 0
                           END
                        ELSE
                           0
                     END)
                     DATE_ORDER_ITEMS_AMOUNT,
                  SUM (
                     CASE
                        WHEN D.RETAILORDERDET_CODE IS NOT NULL THEN D.NETAMT
                        ELSE 0
                     END)
                     MTD_ORDER_ITEMS_AMOUNT
             FROM SALCSMAIN M
                  JOIN SALCSDET D
                     ON (M.CSCODE = D.CSCODE AND CHANNELTYPE = 'ETL')
                  JOIN INVITEM_DETAIL_AGG I ON D.ICODE = I.CODE
            WHERE     M.CSDATE::DATE BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                   AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                  AND M.ADMSITE_CODE IN (2, 3, 4)
         GROUP BY M.ADMSITE_CODE,
                  I.DIVISION,
                  CASE
                     WHEN M.CSDATE::DATE = TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                     THEN
                        M.SCHEME_DOCNO
                     ELSE
                        NULL
                  END,
                  M.SCHEME_DOCNO),
     SUM_DATA
     AS (  SELECT ADMSITE_CODE,
                  DIVISION,
                  CHANNELTYPE,
                  SUM (DATE_NET_QTY)  AS DATE_NET_QTY,
                  SUM (MTD_NET_QTY)   AS MTD_NET_QTY,
                  SUM (DATE_NET_WEIGHT) AS DATE_NET_WEIGHT,
                  SUM (MTD_NET_WEIGHT) AS MTD_NET_WEIGHT
             FROM DATA_SET D
         GROUP BY ADMSITE_CODE, DIVISION, CHANNELTYPE),
     TOP_DIVISION
     AS (  SELECT ADMSITE_CODE,
                  CHANNELTYPE,
                  MAX (DATE_NET_QTY)    DATE_NET_QTY,
                  MAX (MTD_NET_QTY)     MTD_NET_QTY,
                  MAX (DATE_TOP_DIVISION) DATE_TOP_DIVISION,
                  MAX (MTD_TOP_DIVISION) MTD_TOP_DIVISION
             FROM (SELECT ADMSITE_CODE,
                          CHANNELTYPE,
                          DATE_NET_QTY,
                          NULL MTD_NET_QTY,
                          DATE_TOP_DIVISION,
                          NULL MTD_TOP_DIVISION
                     FROM (SELECT D.ADMSITE_CODE,
                                  D.CHANNELTYPE,
                                     ROUND (D.DATE_NET_QTY, 0)::varchar
                                  || ' ('
                                  || DIVISION
                                  || ')'
                                     DATE_NET_QTY,
                                  DIVISION DATE_TOP_DIVISION,
                                  ROW_NUMBER ()
                                     OVER (PARTITION BY D.ADMSITE_CODE)
                                     RN
                             FROM SUM_DATA D
                                  JOIN
                                  (  SELECT ADMSITE_CODE,
                                            MAX (DATE_NET_QTY) DATE_NET_QTY
                                       FROM SUM_DATA D
                                      WHERE D.CHANNELTYPE = 'RTL'
                                   GROUP BY ADMSITE_CODE) X
                                     ON (    D.ADMSITE_CODE = X.ADMSITE_CODE
                                         AND D.DATE_NET_QTY = X.DATE_NET_QTY)
                            WHERE D.CHANNELTYPE = 'RTL')
                    WHERE RN = 1
                   UNION ALL
                   SELECT ADMSITE_CODE,
                          CHANNELTYPE,
                          NULL   DATE_NET_QTY,
                          MTD_NET_QTY,
                          NULL   DATE_TOP_DIVISION,
                          DIVISION MTD_TOP_DIVISION
                     FROM (SELECT D.ADMSITE_CODE,
                                  D.CHANNELTYPE,
                                     ROUND (D.MTD_NET_QTY, 0)::varchar
                                  || ' ('
                                  || DIVISION
                                  || ')'
                                     MTD_NET_QTY,
                                  DIVISION,
                                  ROW_NUMBER ()
                                     OVER (PARTITION BY D.ADMSITE_CODE)
                                     RN
                             FROM SUM_DATA D
                                  JOIN
                                  (  SELECT ADMSITE_CODE,
                                            MAX (MTD_NET_QTY) MTD_NET_QTY
                                       FROM SUM_DATA D
                                      WHERE D.CHANNELTYPE = 'RTL'
                                   GROUP BY ADMSITE_CODE) X
                                     ON (    D.ADMSITE_CODE = X.ADMSITE_CODE
                                         AND D.MTD_NET_QTY = X.MTD_NET_QTY)
                            WHERE D.CHANNELTYPE = 'RTL')
                    WHERE RN = 1
                   UNION ALL
                   SELECT ADMSITE_CODE,
                          CHANNELTYPE,
                          DATE_NET_QTY,
                          NULL MTD_NET_QTY,
                          DATE_TOP_DIVISION,
                          NULL MTD_TOP_DIVISION
                     FROM (SELECT D.ADMSITE_CODE,
                                  D.CHANNELTYPE,
                                     ROUND (D.DATE_NET_QTY, 0)::varchar
                                  || ' ('
                                  || DIVISION
                                  || ')'
                                     DATE_NET_QTY,
                                  DIVISION            DATE_TOP_DIVISION,
                                  ROW_NUMBER () OVER () RN
                             FROM SUM_DATA D
                                  JOIN
                                  (  SELECT ADMSITE_CODE,
                                            MAX (DATE_NET_QTY) DATE_NET_QTY
                                       FROM SUM_DATA D
                                      WHERE D.CHANNELTYPE = 'ETL'
                                   GROUP BY ADMSITE_CODE) X
                                     ON (    D.ADMSITE_CODE = X.ADMSITE_CODE
                                         AND D.DATE_NET_QTY = X.DATE_NET_QTY)
                            WHERE D.CHANNELTYPE = 'ETL')
                    WHERE RN = 1
                   UNION ALL
                   SELECT ADMSITE_CODE,
                          CHANNELTYPE,
                          NULL   DATE_NET_QTY,
                          MTD_NET_QTY,
                          NULL   DATE_TOP_DIVISION,
                          DIVISION MTD_TOP_DIVISION
                     FROM (SELECT D.ADMSITE_CODE,
                                  D.CHANNELTYPE,
                                     ROUND (D.MTD_NET_QTY, 0)::varchar
                                  || ' ('
                                  || DIVISION
                                  || ')'
                                     MTD_NET_QTY,
                                  DIVISION,
                                  ROW_NUMBER () OVER () RN
                             FROM SUM_DATA D
                                  JOIN
                                  (  SELECT ADMSITE_CODE,
                                            MAX (MTD_NET_QTY) MTD_NET_QTY
                                       FROM SUM_DATA D
                                      WHERE D.CHANNELTYPE = 'ETL'
                                   GROUP BY ADMSITE_CODE) X
                                     ON (    D.ADMSITE_CODE = X.ADMSITE_CODE
                                         AND D.MTD_NET_QTY = X.MTD_NET_QTY)
                            WHERE D.CHANNELTYPE = 'ETL')
                    WHERE RN = 1)
         GROUP BY ADMSITE_CODE, CHANNELTYPE)
SELECT 1           SEQ,
       'Net Sales' METRIC,
       SUM (
          CASE
             WHEN ADMSITE_CODE = 4 AND CHANNELTYPE = 'RTL'
             THEN
                DATE_NET_AMOUNT
             ELSE
                0
          END)::VARCHAR
          CS_DATE,
       SUM (
          CASE
             WHEN ADMSITE_CODE = 4 AND CHANNELTYPE = 'RTL'
             THEN
                MTD_NET_AMOUNT
             ELSE
                0
          END)::VARCHAR
          CS_MTD,
       SUM (
          CASE
             WHEN ADMSITE_CODE = 3 AND CHANNELTYPE = 'RTL'
             THEN
                DATE_NET_AMOUNT
             ELSE
                0
          END)::VARCHAR
          HSR_DATE,
       SUM (
          CASE
             WHEN ADMSITE_CODE = 3 AND CHANNELTYPE = 'RTL'
             THEN
                MTD_NET_AMOUNT
             ELSE
                0
          END)::VARCHAR
          HSR_MTD,
       SUM (
          CASE
             WHEN ADMSITE_CODE IN (2, 3, 4) AND CHANNELTYPE = 'ETL'
             THEN
                DATE_NET_AMOUNT
             ELSE
                0
          END)::VARCHAR
          ONLINE_DATE,
       SUM (
          CASE
             WHEN ADMSITE_CODE IN (2, 3, 4) AND CHANNELTYPE = 'ETL'
             THEN
                MTD_NET_AMOUNT
             ELSE
                0
          END)::VARCHAR
          ONLINE_MTD
  FROM DATA_SET D
UNION ALL
SELECT 2                 SEQ,
       'Number of Bills' METRIC,
       COUNT (
          DISTINCT CASE
                      WHEN ADMSITE_CODE = 4 AND CHANNELTYPE = 'RTL'
                      THEN
                         DATE_BILLNO
                      ELSE
                         NULL
                   END)::VARCHAR
          CS_DATE,
       COUNT (
          DISTINCT CASE
                      WHEN ADMSITE_CODE = 4 AND CHANNELTYPE = 'RTL'
                      THEN
                         MTD_BILLNO
                      ELSE
                         NULL
                   END)::VARCHAR
          CS_MTD,
       COUNT (
          DISTINCT CASE
                      WHEN ADMSITE_CODE = 3 AND CHANNELTYPE = 'RTL'
                      THEN
                         DATE_BILLNO
                      ELSE
                         NULL
                   END)::VARCHAR
          HSR_DATE,
       COUNT (
          DISTINCT CASE
                      WHEN ADMSITE_CODE = 3 AND CHANNELTYPE = 'RTL'
                      THEN
                         MTD_BILLNO
                      ELSE
                         NULL
                   END)::VARCHAR
          HSR_MTD,
       COUNT (
          DISTINCT CASE
                      WHEN ADMSITE_CODE IN (2, 3, 4) AND CHANNELTYPE = 'ETL'
                      THEN
                         DATE_BILLNO
                      ELSE
                         NULL
                   END)::VARCHAR
          ONLINE_DATE,
       COUNT (
          DISTINCT CASE
                      WHEN ADMSITE_CODE IN (2, 3, 4) AND CHANNELTYPE = 'ETL'
                      THEN
                         MTD_BILLNO
                      ELSE
                         NULL
                   END)::VARCHAR
          ONLINE_MTD
  FROM DATA_SET D
UNION ALL
SELECT 3                SEQ,
       'Items Sold Qty' METRIC,
       SUM (
          CASE
             WHEN ADMSITE_CODE = 4 AND CHANNELTYPE = 'RTL' THEN DATE_NET_QTY
             ELSE 0
          END)::VARCHAR
          CS_DATE,
       SUM (
          CASE
             WHEN ADMSITE_CODE = 4 AND CHANNELTYPE = 'RTL' THEN MTD_NET_QTY
             ELSE 0
          END)::VARCHAR
          CS_MTD,
       SUM (
          CASE
             WHEN ADMSITE_CODE = 3 AND CHANNELTYPE = 'RTL' THEN DATE_NET_QTY
             ELSE 0
          END)::VARCHAR
          HSR_DATE,
       SUM (
          CASE
             WHEN ADMSITE_CODE = 3 AND CHANNELTYPE = 'RTL' THEN MTD_NET_QTY
             ELSE 0
          END)::VARCHAR
          HSR_MTD,
       SUM (
          CASE
             WHEN ADMSITE_CODE IN (2, 3, 4) AND CHANNELTYPE = 'ETL'
             THEN
                DATE_NET_QTY
             ELSE
                0
          END)::VARCHAR
          ONLINE_DATE,
       SUM (
          CASE
             WHEN ADMSITE_CODE IN (2, 3, 4) AND CHANNELTYPE = 'ETL'
             THEN
                MTD_NET_QTY
             ELSE
                0
          END)::VARCHAR
          ONLINE_MTD
  FROM DATA_SET D
UNION ALL
SELECT 4                     SEQ,
       'Net Sales in Weight' METRIC,
       SUM (
          CASE
             WHEN ADMSITE_CODE = 4 AND CHANNELTYPE = 'RTL'
             THEN
                DATE_NET_WEIGHT
             ELSE
                0
          END)::VARCHAR
          CS_DATE,
       SUM (
          CASE
             WHEN ADMSITE_CODE = 4 AND CHANNELTYPE = 'RTL'
             THEN
                MTD_NET_WEIGHT
             ELSE
                0
          END)::VARCHAR
          CS_MTD,
       SUM (
          CASE
             WHEN ADMSITE_CODE = 3 AND CHANNELTYPE = 'RTL'
             THEN
                DATE_NET_WEIGHT
             ELSE
                0
          END)::VARCHAR
          HSR_DATE,
       SUM (
          CASE
             WHEN ADMSITE_CODE = 3 AND CHANNELTYPE = 'RTL'
             THEN
                MTD_NET_WEIGHT
             ELSE
                0
          END)::VARCHAR
          HSR_MTD,
       SUM (
          CASE
             WHEN ADMSITE_CODE IN (2, 3, 4) AND CHANNELTYPE = 'ETL'
             THEN
                DATE_NET_WEIGHT
             ELSE
                0
          END)::VARCHAR
          ONLINE_DATE,
       SUM (
          CASE
             WHEN ADMSITE_CODE IN (2, 3, 4) AND CHANNELTYPE = 'ETL'
             THEN
                MTD_NET_WEIGHT
             ELSE
                0
          END)::VARCHAR
          ONLINE_MTD
  FROM DATA_SET D
UNION ALL
SELECT 5                             SEQ,
       'POS order Net Sales Revenue' METRIC,
       SUM (
          CASE
             WHEN ADMSITE_CODE = 4 AND CHANNELTYPE = 'RTL'
             THEN
                DATE_ORDER_ITEMS_AMOUNT
             ELSE
                0
          END)::VARCHAR
          CS_DATE,
       SUM (
          CASE
             WHEN ADMSITE_CODE = 4 AND CHANNELTYPE = 'RTL'
             THEN
                MTD_ORDER_ITEMS_AMOUNT
             ELSE
                0
          END)::VARCHAR
          CS_MTD,
       SUM (
          CASE
             WHEN ADMSITE_CODE = 3 AND CHANNELTYPE = 'RTL'
             THEN
                DATE_ORDER_ITEMS_AMOUNT
             ELSE
                0
          END)::VARCHAR
          HSR_DATE,
       SUM (
          CASE
             WHEN ADMSITE_CODE = 3 AND CHANNELTYPE = 'RTL'
             THEN
                MTD_ORDER_ITEMS_AMOUNT
             ELSE
                0
          END)::VARCHAR
          HSR_MTD,
       SUM (
          CASE
             WHEN ADMSITE_CODE IN (2, 3, 4) AND CHANNELTYPE = 'ETL'
             THEN
                DATE_ORDER_ITEMS_AMOUNT
             ELSE
                0
          END)::VARCHAR
          ONLINE_DATE,
       SUM (
          CASE
             WHEN ADMSITE_CODE IN (2, 3, 4) AND CHANNELTYPE = 'ETL'
             THEN
                MTD_ORDER_ITEMS_AMOUNT
             ELSE
                0
          END)::VARCHAR
          ONLINE_MTD
  FROM DATA_SET D
UNION ALL
SELECT 6                     SEQ,
       'POS Order Items Qty' METRIC,
       SUM (
          CASE
             WHEN ADMSITE_CODE = 4 AND CHANNELTYPE = 'RTL'
             THEN
                DATE_ORDER_ITEMS_QTY
             ELSE
                0
          END)::VARCHAR
          CS_DATE,
       SUM (
          CASE
             WHEN ADMSITE_CODE = 4 AND CHANNELTYPE = 'RTL'
             THEN
                MTD_ORDER_ITEMS_QTY
             ELSE
                0
          END)::VARCHAR
          CS_MTD,
       SUM (
          CASE
             WHEN ADMSITE_CODE = 3 AND CHANNELTYPE = 'RTL'
             THEN
                DATE_ORDER_ITEMS_QTY
             ELSE
                0
          END)::VARCHAR
          HSR_DATE,
       SUM (
          CASE
             WHEN ADMSITE_CODE = 3 AND CHANNELTYPE = 'RTL'
             THEN
                MTD_ORDER_ITEMS_QTY
             ELSE
                0
          END)::VARCHAR
          HSR_MTD,
       SUM (
          CASE
             WHEN ADMSITE_CODE IN (2, 3, 4) AND CHANNELTYPE = 'ETL'
             THEN
                DATE_ORDER_ITEMS_QTY
             ELSE
                0
          END)::VARCHAR
          ONLINE_DATE,
       SUM (
          CASE
             WHEN ADMSITE_CODE IN (2, 3, 4) AND CHANNELTYPE = 'ETL'
             THEN
                MTD_ORDER_ITEMS_QTY
             ELSE
                0
          END)::VARCHAR
          ONLINE_MTD
  FROM DATA_SET D
UNION ALL
SELECT 7                                                       SEQ,
       'Total Advance (Deposite against Order)'                METRIC,
       SUM (
          CASE
             WHEN     ADMSITE_CODE = 4
                  AND M.BILLDATE = TO_DATE ('@DTTO@', 'YYYY-MM-DD')
             THEN
                AMOUNT
             ELSE
                0
          END)::VARCHAR
          CS_DATE,
       SUM (CASE WHEN ADMSITE_CODE = 4 THEN AMOUNT ELSE 0 END)::VARCHAR CS_MTD,
       SUM (
          CASE
             WHEN     ADMSITE_CODE = 3
                  AND M.BILLDATE = TO_DATE ('@DTTO@', 'YYYY-MM-DD')
             THEN
                AMOUNT
             ELSE
                0
          END)::VARCHAR
          HSR_DATE,
       SUM (CASE WHEN ADMSITE_CODE = 3 THEN AMOUNT ELSE 0 END)::VARCHAR HSR_MTD,
       SUM (
          CASE
             WHEN     ADMSITE_CODE = 2
                  AND M.BILLDATE = TO_DATE ('@DTTO@', 'YYYY-MM-DD')
             THEN
                AMOUNT
             ELSE
                0
          END)::VARCHAR
          ONLINE_DATE,
       SUM (CASE WHEN ADMSITE_CODE = 2 THEN AMOUNT ELSE 0 END)::VARCHAR ONLINE_MTD
  FROM PSITE_POSDEPREFBILL M
 WHERE     PSITE_POSORDER_CODE IS NOT NULL
       AND M.BILLDATE::DATE BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                          AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
       AND M.ADMSITE_CODE IN (2, 3, 4)
       AND DEPREFTYPE = 'D'
UNION ALL
SELECT 8                                                              SEQ,
       'Total Footfall'                                               METRIC,
       SUM (CASE WHEN ADMSITE_CODE = 4 THEN DATE_FOOTFALL ELSE 0 END)::VARCHAR CS_DATE,
       SUM (CASE WHEN ADMSITE_CODE = 4 THEN MTD_FOOTFALL ELSE 0 END)::VARCHAR  CS_MTD,
       SUM (CASE WHEN ADMSITE_CODE = 3 THEN DATE_FOOTFALL ELSE 0 END)::VARCHAR
          HSR_DATE,
       SUM (CASE WHEN ADMSITE_CODE = 3 THEN MTD_FOOTFALL ELSE 0 END)::VARCHAR  HSR_MTD,
       SUM (CASE WHEN ADMSITE_CODE = 2 THEN DATE_FOOTFALL ELSE 0 END)::VARCHAR
          ONLINE_DATE,
       SUM (CASE WHEN ADMSITE_CODE = 2 THEN MTD_FOOTFALL ELSE 0 END)::VARCHAR
          ONLINE_MTD
  FROM (  SELECT ADMSITE_CODE,
                 SUM (
                    CASE
                       WHEN STLMFOR::DATE = TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                       THEN
                          FOOTFALL
                       ELSE
                          0
                    END)
                    DATE_FOOTFALL,
                 SUM (FOOTFALL) MTD_FOOTFALL
            FROM PSITE_POSSTLM
           WHERE     ADMSITE_CODE IN (3, 4)
                 AND STLMFOR::DATE BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                 AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
        GROUP BY ADMSITE_CODE)
UNION ALL
SELECT 9                                                          SEQ,
       'Conversion Rate'                                          METRIC,
       SUM (CASE WHEN ADMSITE_CODE = 4 THEN DATE_CONV ELSE 0 END)::VARCHAR CS_DATE,
       SUM (CASE WHEN ADMSITE_CODE = 4 THEN MTD_CONV ELSE 0 END)::VARCHAR  CS_MTD,
       SUM (CASE WHEN ADMSITE_CODE = 3 THEN DATE_CONV ELSE 0 END)::VARCHAR HSR_DATE,
       SUM (CASE WHEN ADMSITE_CODE = 3 THEN MTD_CONV ELSE 0 END)::VARCHAR  HSR_MTD,
       SUM (CASE WHEN ADMSITE_CODE = 2 THEN DATE_CONV ELSE 0 END)::VARCHAR ONLINE_DATE,
       SUM (CASE WHEN ADMSITE_CODE = 2 THEN MTD_CONV ELSE 0 END)::VARCHAR  ONLINE_MTD
  FROM (SELECT F.ADMSITE_CODE,
               ROUND (
                  CASE
                     WHEN COALESCE (DATE_FOOTFALL, 0) = 0 THEN 0
                     ELSE (DATE_BILLCOUNT / DATE_FOOTFALL) * 100
                  END,
                  2)
                  DATE_CONV,
               ROUND (
                  CASE
                     WHEN COALESCE (MTD_FOOTFALL, 0) = 0 THEN 0
                     ELSE (MTD_BILLCOUNT / MTD_FOOTFALL) * 100
                  END,
                  2)
                  MTD_CONV
          FROM (  SELECT ADMSITE_CODE,
                         SUM (
                            CASE
                               WHEN STLMFOR::DATE = TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                               THEN
                                  FOOTFALL
                               ELSE
                                  0
                            END)
                            DATE_FOOTFALL,
                         SUM (FOOTFALL) MTD_FOOTFALL
                    FROM PSITE_POSSTLM
                   WHERE     ADMSITE_CODE IN (3, 4)
                         AND STLMFOR::DATE BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                         AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                GROUP BY ADMSITE_CODE) F
               JOIN
               (  SELECT ADMSITE_CODE,
                         COUNT (DISTINCT DATE_BILLNO) DATE_BILLCOUNT,
                         COUNT (DISTINCT MTD_BILLNO) MTD_BILLCOUNT
                    FROM DATA_SET
                   WHERE ADMSITE_CODE IN (3, 4) AND CHANNELTYPE = 'RTL'
                GROUP BY ADMSITE_CODE) B
                  ON F.ADMSITE_CODE = B.ADMSITE_CODE)
UNION ALL
SELECT 10                                   SEQ,
       'Top Performing Division Item Count' METRIC,
       MAX (
          CASE
             WHEN ADMSITE_CODE = 4 AND CHANNELTYPE = 'RTL' THEN DATE_NET_QTY
             ELSE NULL
          END)::VARCHAR
          CS_DATE,
       MAX (
          CASE
             WHEN ADMSITE_CODE = 4 AND CHANNELTYPE = 'RTL' THEN MTD_NET_QTY
             ELSE NULL
          END)::VARCHAR
          CS_MTD,
       MAX (
          CASE
             WHEN ADMSITE_CODE = 3 AND CHANNELTYPE = 'RTL' THEN DATE_NET_QTY
             ELSE NULL
          END)::VARCHAR
          HSR_DATE,
       MAX (
          CASE
             WHEN ADMSITE_CODE = 3 AND CHANNELTYPE = 'RTL' THEN MTD_NET_QTY
             ELSE NULL
          END)::VARCHAR
          HSR_MTD,
       MAX (
          CASE
             WHEN ADMSITE_CODE IN (2, 3, 4) AND CHANNELTYPE = 'ETL'
             THEN
                DATE_NET_QTY
             ELSE
                NULL
          END)::VARCHAR
          ONLINE_DATE,
       MAX (
          CASE
             WHEN ADMSITE_CODE IN (2, 3, 4) AND CHANNELTYPE = 'ETL'
             THEN
                MTD_NET_QTY
             ELSE
                NULL
          END)::VARCHAR
          ONLINE_MTD
  FROM TOP_DIVISION
UNION ALL
SELECT 11                                    SEQ,
       'Top Performing Division Weight Wise' METRIC,
       ROUND (MAX (CS_DATE), 2)::VARCHAR              CS_DATE,
       ROUND (MAX (CS_MTD), 2)::VARCHAR               CS_MTD,
       ROUND (MAX (HSR_DATE), 2)::VARCHAR             HSR_DATE,
       ROUND (MAX (HSR_MTD), 2)::VARCHAR              HSR_MTD,
       ROUND (MAX (ONLINE_DATE), 2)::VARCHAR          ONLINE_DATE,
       ROUND (MAX (ONLINE_MTD), 2)::VARCHAR           ONLINE_MTD
  FROM (SELECT CASE
                  WHEN T.ADMSITE_CODE = 4 AND T.CHANNELTYPE = 'RTL'
                  THEN
                     DATE_NET_WEIGHT
                  ELSE
                     0
               END
                  CS_DATE,
               NULL CS_MTD,
               CASE
                  WHEN T.ADMSITE_CODE = 3 AND T.CHANNELTYPE = 'RTL'
                  THEN
                     DATE_NET_WEIGHT
                  ELSE
                     0
               END
                  HSR_DATE,
               NULL HSR_MTD,
               CASE
                  WHEN T.ADMSITE_CODE IN (2, 3, 4) AND T.CHANNELTYPE = 'ETL'
                  THEN
                     DATE_NET_WEIGHT
                  ELSE
                     0
               END
                  ONLINE_DATE,
               NULL ONLINE_MTD
          FROM TOP_DIVISION T
               JOIN SUM_DATA S
                  ON (    T.ADMSITE_CODE = S.ADMSITE_CODE
                      AND T.DATE_TOP_DIVISION = S.DIVISION
                      AND T.CHANNELTYPE = S.CHANNELTYPE)
        UNION ALL
        SELECT NULL CS_DATE,
               CASE
                  WHEN T.ADMSITE_CODE = 4 AND T.CHANNELTYPE = 'RTL'
                  THEN
                     MTD_NET_WEIGHT
                  ELSE
                     0
               END
                  CS_MTD,
               NULL HSR_DATE,
               CASE
                  WHEN T.ADMSITE_CODE = 3 AND T.CHANNELTYPE = 'RTL'
                  THEN
                     MTD_NET_WEIGHT
                  ELSE
                     0
               END
                  HSR_MTD,
               NULL ONLINE_DATE,
               CASE
                  WHEN T.ADMSITE_CODE IN (2, 3, 4) AND T.CHANNELTYPE = 'ETL'
                  THEN
                     MTD_NET_WEIGHT
                  ELSE
                     0
               END
                  ONLINE_MTD
          FROM TOP_DIVISION T
               JOIN SUM_DATA S
                  ON (    T.ADMSITE_CODE = S.ADMSITE_CODE
                      AND T.MTD_TOP_DIVISION = S.DIVISION
                      AND T.CHANNELTYPE = S.CHANNELTYPE))