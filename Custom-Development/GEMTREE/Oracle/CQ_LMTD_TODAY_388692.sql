/* Formatted on 2025-01-21 16:54:31 (QP5 v5.294) */
/*
Purpose              Object                        ID              Developer          
Custom Development   CQ_LMTD_TODAY                 388692          Dipankar
*/
WITH DTA
     AS (SELECT TO_DATE (MONTH_START_DATE)             MTDSTART,
                TO_DATE (
                      (TO_CHAR (MONTH_START_DATE, 'YYYY') - 1)
                   || '-'
                   || TO_CHAR (MONTH_START_DATE, 'MM-DD'),
                   'YYYY-MM-DD')
                   LMTDSTART,
                (TO_DATE ('@ASON@', 'YYYY-MM-DD')) TODAY,
                TO_DATE (
                      (  TO_CHAR (TO_DATE ('@ASON@', 'YYYY-MM-DD'),
                                  'YYYY')
                       - 1)
                   || '-'
                   || TO_CHAR (TO_DATE ('@ASON@', 'YYYY-MM-DD'), 'MM-DD'),
                   'YYYY-MM-DD')
                   LTODAY
           FROM GINVIEW.LV_CALENDAR
          WHERE TO_DATE (DATE_VALUE) = TO_DATE ('@ASON@', 'YYYY-MM-DD'))
  SELECT GINVIEW.FNC_UK () UK,
         M.ADMSITE_CODE,
         S.NAME          SITENAME,
         SUM (
            CASE
               WHEN TRUNC (M.BILLDATE) = (SELECT TODAY FROM DTA)
               THEN
                  COALESCE (D.NETAMT, 0)
               ELSE
                  0
            END)
            TODAY_AMT,
         SUM (
            CASE
               WHEN TRUNC (M.BILLDATE) = (SELECT LTODAY FROM DTA)
               THEN
                  COALESCE (D.NETAMT, 0)
               ELSE
                  0
            END)
            LTODAY_AMT,
         SUM (
            CASE
               WHEN TRUNC (M.BILLDATE) BETWEEN (SELECT MTDSTART
                                                  FROM DTA)
                                           AND (SELECT TODAY
                                                  FROM DTA)
               THEN
                  COALESCE (D.NETAMT, 0)
               ELSE
                  0
            END)
            MONTH_AMT,
         SUM (
            CASE
               WHEN TRUNC (M.BILLDATE) BETWEEN (SELECT LMTDSTART
                                                  FROM DTA)
                                           AND (SELECT LTODAY
                                                  FROM DTA)
               THEN
                  COALESCE (D.NETAMT, 0)
               ELSE
                  0
            END)
            LMONTH_AMT
    FROM PSITE_POSBILL M
         INNER JOIN PSITE_POSBILLITEM D ON (M.CODE = D.PSITE_POSBILL_CODE)
         INNER JOIN ADMSITE S ON M.ADMSITE_CODE = S.CODE
   WHERE TRUNC (M.BILLDATE) BETWEEN (SELECT LMTDSTART
                                       FROM DTA)
                                AND (SELECT TODAY
                                       FROM DTA)
GROUP BY M.ADMSITE_CODE, S.NAME