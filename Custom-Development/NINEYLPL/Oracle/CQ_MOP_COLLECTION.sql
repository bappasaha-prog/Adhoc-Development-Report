/* Formatted on 2025-02-18 12:57:20 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_MOP_COLLECTION || Ticket Id : 393591 || Developer : Dipankar || ><><><*/

WITH DTA
     AS (SELECT TO_DATE (MONTH_START_DATE)         MTDSTART,
                (TO_DATE ('@ASON@', 'YYYY-MM-DD')) TODAY,
                TO_DATE (FISCAL_YEAR_START_DATE)   YEARSTART
           FROM GINVIEW.LV_CALENDAR
          WHERE TO_DATE (DATE_VALUE) = TO_DATE ('@ASON@', 'YYYY-MM-DD'))
  SELECT GINVIEW.FNC_UK () UK,
         B.ADMSITE_CODE,
         SUM (
            CASE
               WHEN TRUNC (B.BILLDATE) = (SELECT TODAY FROM DTA) THEN M.BASEAMT
               ELSE 0
            END)
            TODAY_COLLECTION,
         SUM (
            CASE
               WHEN TRUNC (B.BILLDATE) BETWEEN (SELECT MTDSTART
                                                  FROM DTA)
                                           AND (SELECT TODAY
                                                  FROM DTA)
               THEN
                  M.BASEAMT
               ELSE
                  0
            END)
            MONTH_COLLECTION,
         SUM (
            CASE
               WHEN TRUNC (B.BILLDATE) BETWEEN (SELECT YEARSTART
                                                  FROM DTA)
                                           AND (SELECT TODAY
                                                  FROM DTA)
               THEN
                  M.BASEAMT
               ELSE
                  0
            END)
            YEAR_COLLECTION
    FROM PSITE_POSBILLMOP M,
         (SELECT ADMSITE_CODE,
                 CODE           BILLID,
                 BILLNO,
                 TRUNC (BILLDATE) BILLDATE
            FROM PSITE_POSBILL
           WHERE TRUNC (BILLDATE) BETWEEN (SELECT YEARSTART
                                             FROM DTA)
                                      AND (SELECT TODAY
                                             FROM DTA)
          UNION ALL
          SELECT ADMSITE_CODE,
                 CODE           BILLID,
                 BILLNO,
                 TRUNC (BILLDATE) BILLDATE
            FROM PSITE_POSGVBILL
           WHERE TRUNC (BILLDATE) BETWEEN (SELECT YEARSTART
                                             FROM DTA)
                                      AND (SELECT TODAY
                                             FROM DTA)
          UNION ALL
          SELECT ADMSITE_CODE,
                 CODE           BILLID,
                 BILLNO,
                 TRUNC (BILLDATE) BILLDATE
            FROM PSITE_POSDEPREFBILL
           WHERE TRUNC (BILLDATE) BETWEEN (SELECT YEARSTART
                                             FROM DTA)
                                      AND (SELECT TODAY
                                             FROM DTA)
          UNION ALL
          SELECT ADMSITE_CODE,
                 CODE           BILLID,
                 BILLNO,
                 TRUNC (BILLDATE) BILLDATE
            FROM PSITE_PTCBILL
           WHERE TRUNC (BILLDATE) BETWEEN (SELECT YEARSTART
                                             FROM DTA)
                                      AND (SELECT TODAY
                                             FROM DTA)) B,
         ADMSITE        S
   WHERE     M.PSITE_POSBILL_CODE = B.BILLID
         AND M.ADMSITE_CODE = S.CODE
         AND M.MOPDESC NOT IN ('Credit Note Issued')
GROUP BY B.ADMSITE_CODE