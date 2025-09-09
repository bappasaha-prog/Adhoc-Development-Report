/* Formatted on 2025-04-04 14:09:09 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_MTD_SALE_STK || Ticket Id : 398006 || Developer : Dipankar || ><><><*/
WITH DTA
     AS (SELECT MONTH_START_DATE::date             MTDSTART,
                TO_DATE ('@ASON@', 'YYYY-MM-DD') TODAY
           FROM GINVIEW.LV_CALENDAR
          WHERE DATE_VALUE::date = TO_DATE ('@ASON@', 'YYYY-MM-DD')),
     MAIN_TABLE
     AS (  SELECT BRAND,
                  SUM (SALES_QTY) SALES_QTY,
                  SUM (SOH_QTY) SOH_QTY,
                  SUM (SOH_VALUE) SOH_VALUE
             FROM (  SELECT BRAND,
                            SUM (SALE_QTY) SALES_QTY,
                            0          SOH_QTY,
                            0          SOH_VALUE
                       FROM GINVIEW.CV_ALL_SALE
                      WHERE     BILL_DATE BETWEEN (SELECT MTDSTART
                                                     FROM DTA)
                                              AND (SELECT TODAY
                                                     FROM DTA)
                            AND ADMOU_CODE = nullif('@ConnOUCode@','')::int
                            AND BRAND IN ('FCUK',
                                          'FC',
                                          'PUMA',
                                          'MILOU')
                   GROUP BY BRAND
                   UNION
                     SELECT CATEGORY1         BRAND,
                            0                 SALES_QTY,
                            SUM (CLOSINGSTOCKQTY) SOH_QTY,
                            SUM (CLOSINGAMOUNT) SOH_VALUE
                       FROM GINVIEW.LV_REALTIME_STOCK K
                            INNER JOIN ADMSITE S ON K.SITECODE = S.CODE
                            INNER JOIN GINVIEW.LV_ITEM I ON K.ICODE = I.CODE
                      WHERE     CLOSINGSTOCKQTY <> 0
                            AND S.ADMOU_CODE = nullif('@ConnOUCode@','')::int
                            AND I.CATEGORY1 IN ('FCUK',
                                                'FC',
                                                'PUMA',
                                                'MILOU')
                   GROUP BY CATEGORY1)
         GROUP BY BRAND)
SELECT F.SEQ,
       F.BRAND,
       F.SALES_QTY,
       F.SOH_QTY,
       F.SOH_VALUE
  FROM (SELECT '01' SEQ,
               BRAND,
               SALES_QTY,
               SOH_QTY,
               SOH_VALUE
          FROM MAIN_TABLE
         WHERE BRAND = 'FCUK'
        UNION ALL
        SELECT '02' SEQ,
               BRAND,
               SALES_QTY,
               SOH_QTY,
               SOH_VALUE
          FROM MAIN_TABLE
         WHERE BRAND = 'FC'
        UNION ALL
        SELECT '03' SEQ,
               BRAND,
               SALES_QTY,
               SOH_QTY,
               SOH_VALUE
          FROM MAIN_TABLE
         WHERE BRAND = 'PUMA'
        UNION ALL
        SELECT '04'                   SEQ,
               'Total (FCUK+FC+PUMA)' BRAND,
               SUM (SALES_QTY)        SALES_QTY,
               SUM (SOH_QTY)          SOH_QTY,
               SUM (SOH_VALUE)        SOH_VALUE
          FROM MAIN_TABLE
         WHERE BRAND IN ('FCUK', 'FC', 'PUMA')
        UNION ALL
        SELECT '05' SEQ,
               BRAND,
               SALES_QTY,
               SOH_QTY,
               SOH_VALUE
          FROM MAIN_TABLE
         WHERE BRAND = 'MILOU') F