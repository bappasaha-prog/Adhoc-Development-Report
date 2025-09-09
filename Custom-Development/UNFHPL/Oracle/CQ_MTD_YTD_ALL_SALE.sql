/* Formatted on 2025-03-18 19:12:19 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_MTD_YTD_ALL_SALE || Ticket Id : 398005 || Developer : Dipankar || ><><><*/

WITH DATASET
     AS (  SELECT L.BRAND,
                  L.MONTH_NAME,
                  L.MCODE,
                  SUM (L.QTY)  QTY,
                  SUM (L.YTDQTY) YTDQTY,
                  SUM (L.AMOUNT) AMOUNT,
                  SUM (L.YTDAMT) YTDAMT
             FROM (  SELECT I.CATEGORY1              BRAND,
                            MON.MONTH_NAME,
                            MON.MCODE,
                            SUM (COALESCE (D.INVQTY, 0)) QTY,
                            SUM (SUM (COALESCE (D.INVQTY, 0)))
                               OVER (PARTITION BY I.CATEGORY1 ORDER BY MON.MCODE)
                               YTDQTY,
                            SUM (COALESCE (D.INVAMT, 0)) AMOUNT,
                            SUM (SUM (COALESCE (D.INVAMT, 0)))
                               OVER (PARTITION BY I.CATEGORY1 ORDER BY MON.MCODE)
                               YTDAMT
                       FROM SALINVMAIN M
                            INNER JOIN SALINVDET D ON M.INVCODE = D.INVCODE
                            INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
                            INNER JOIN ADMMONTH MON
                               ON MON.MONTH_NAME =
                                     TO_CHAR (TO_DATE (M.INVDT, 'DD-MM-YYYY'),
                                              'MON-YY')
                      WHERE     M.SALETYPE = 'O'
                            AND I.CATEGORY1 IN ('FCUK',
                                                'FC',
                                                'PUMA',
                                                'MILOU')
                            AND TRUNC (M.INVDT) BETWEEN (SELECT DTFR
                                                           FROM ADMYEAR
                                                          WHERE TO_DATE (
                                                                   '@ASON@',
                                                                   'YYYY-MM-DD') BETWEEN DTFR
                                                                                     AND DTTO)
                                                    AND TO_DATE ('@ASON@',
                                                                 'YYYY-MM-DD')
                   GROUP BY I.CATEGORY1, MON.MONTH_NAME, MON.MCODE
                   UNION ALL
                     SELECT I.CATEGORY1              BRAND,
                            MON.MONTH_NAME,
                            MON.MCODE,
                            SUM (COALESCE (D.QTY, 0)) QTY,
                            SUM (SUM (COALESCE (D.QTY, 0)))
                               OVER (PARTITION BY I.CATEGORY1 ORDER BY MON.MCODE)
                               YTDQTY,
                            SUM (COALESCE (D.NETAMT, 0)) AMOUNT,
                            SUM (SUM (COALESCE (D.NETAMT, 0)))
                               OVER (PARTITION BY I.CATEGORY1 ORDER BY MON.MCODE)
                               YTDAMT
                       FROM SALCSMAIN M
                            INNER JOIN SALCSDET D ON M.CSCODE = D.CSCODE
                            INNER JOIN ADMMONTH MON
                               ON MON.MONTH_NAME =
                                     TO_CHAR (TO_DATE (M.CSDATE, 'DD-MM-YYYY'),
                                              'MON-YY')
                            INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
                      WHERE     I.CATEGORY1 IN ('FCUK',
                                                'FC',
                                                'PUMA',
                                                'MILOU')
                            AND TRUNC (M.CSDATE) BETWEEN (SELECT DTFR
                                                            FROM ADMYEAR
                                                           WHERE TO_DATE (
                                                                    '@ASON@',
                                                                    'YYYY-MM-DD') BETWEEN DTFR
                                                                                      AND DTTO)
                                                     AND TO_DATE ('@ASON@',
                                                                  'YYYY-MM-DD')
                   GROUP BY I.CATEGORY1, MON.MONTH_NAME, MON.MCODE) L
         GROUP BY L.BRAND, L.MONTH_NAME, L.MCODE)
SELECT GINVIEW.FNC_UK () UK,
       F.BRAND,
       F.SEQ,
       F.MONTH_NAME,
       F.MCODE,
       F.QTY,
       F.YTDQTY,
       F.AMOUNT,
       F.YTDAMT,
       F.AVF_QTY_PERCENTAGE,
       F.AVF_YTDQTY_PERCENTAGE,
       F.AVF_AMOUNT_PERCENTAGE,
       F.AVF_YTDAMT_PERCENTAGE
  FROM (  SELECT 'ALL BRAND'  BRAND,
                 1            SEQ,
                 D.MONTH_NAME,
                 D.MCODE,
                 SUM (D.QTY)  QTY,
                 SUM (D.YTDQTY) YTDQTY,
                 SUM (D.AMOUNT) AMOUNT,
                 SUM (D.YTDAMT) YTDAMT,
                 100          AVF_QTY_PERCENTAGE,
                 100          AVF_YTDQTY_PERCENTAGE,
                 100          AVF_AMOUNT_PERCENTAGE,
                 100          AVF_YTDAMT_PERCENTAGE
            FROM DATASET D
        GROUP BY MONTH_NAME, D.MCODE
        UNION ALL
        SELECT D.BRAND,
               CASE
                  WHEN D.BRAND = 'FCUK' THEN 2
                  WHEN D.BRAND = 'FC' THEN 3
                  WHEN D.BRAND = 'PUMA' THEN 4
                  WHEN D.BRAND = 'MILOU' THEN 5
               END
                  AS SEQ,
               D.MONTH_NAME,
               D.MCODE,
               D.QTY,
               D.YTDQTY,
               D.AMOUNT,
               D.YTDAMT,
               CASE
                  WHEN SUM (D.QTY)
                       OVER (PARTITION BY D.MONTH_NAME ORDER BY D.MONTH_NAME) =
                          0
                  THEN
                     0
                  ELSE
                       ROUND (
                            D.QTY
                          / SUM (
                               D.QTY)
                            OVER (PARTITION BY D.MONTH_NAME
                                  ORDER BY D.MONTH_NAME),
                          2)
                     * 100
               END
                  AVF_QTY_PERCENTAGE,
               CASE
                  WHEN SUM (D.YTDQTY)
                       OVER (PARTITION BY D.MONTH_NAME ORDER BY D.MONTH_NAME) =
                          0
                  THEN
                     0
                  ELSE
                       ROUND (
                            D.YTDQTY
                          / SUM (
                               D.YTDQTY)
                            OVER (PARTITION BY D.MONTH_NAME
                                  ORDER BY D.MONTH_NAME),
                          2)
                     * 100
               END
                  AVF_YTDQTY_PERCENTAGE,
               CASE
                  WHEN SUM (D.AMOUNT)
                       OVER (PARTITION BY D.MONTH_NAME ORDER BY D.MONTH_NAME) =
                          0
                  THEN
                     0
                  ELSE
                       ROUND (
                            D.AMOUNT
                          / SUM (
                               D.AMOUNT)
                            OVER (PARTITION BY D.MONTH_NAME
                                  ORDER BY D.MONTH_NAME),
                          2)
                     * 100
               END
                  AVF_AMOUNT_PERCENTAGE,
               CASE
                  WHEN SUM (D.YTDAMT)
                       OVER (PARTITION BY D.MONTH_NAME ORDER BY D.MONTH_NAME) =
                          0
                  THEN
                     0
                  ELSE
                       ROUND (
                            D.YTDAMT
                          / SUM (
                               D.YTDAMT)
                            OVER (PARTITION BY D.MONTH_NAME
                                  ORDER BY D.MONTH_NAME),
                          2)
                     * 100
               END
                  AVF_YTDAMT_PERCENTAGE
          FROM DATASET D) F