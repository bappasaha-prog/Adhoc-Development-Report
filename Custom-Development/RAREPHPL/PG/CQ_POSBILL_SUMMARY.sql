/* Formatted on 2025-03-24 13:08:23 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_POSBILL_SUMMARY || Ticket Id : 399391 || Developer : Dipankar || ><><><*/
WITH DTA
     AS (SELECT MONTH_START_DATE::date MTDSTART, current_date TODAY,day_of_month_number DAY_NO
           FROM GINVIEW.LV_CALENDAR
          WHERE DATE_VALUE::date =  current_date::date)
  SELECT 
  ROW_NUMBER() OVER() AS  UK,
  M.ADMSITE_CODE,
         S.NAME SITE_NAME,
         COUNT (
            DISTINCT (CASE
                         WHEN M.BILLDATE::DATE = (SELECT TODAY FROM DTA)
                         THEN
                            M.BILLNO
                         ELSE
                            NULL
                      END))
            BILL_COUNT,
            COUNT (
            DISTINCT (CASE
                         WHEN M.BILLDATE::DATE BETWEEN (SELECT MTDSTART
                                                  FROM DTA)
                                           AND (SELECT TODAY
                                                  FROM DTA)
                         THEN
                            M.BILLNO
                         ELSE
                            NULL
                      END))
            MTD_BILL_COUNT,
         SUM (
            CASE
               WHEN M.BILLDATE::DATE = (SELECT TODAY FROM DTA) THEN D.QTY
               ELSE 0
            END)
            BILL_QUANTITY,
            SUM (
            CASE
               WHEN M.BILLDATE::DATE BETWEEN (SELECT MTDSTART
                                                  FROM DTA)
                                           AND (SELECT TODAY
                                                  FROM DTA) THEN D.QTY
               ELSE 0
            END)
            MTD_BILL_QUANTITY,
         SUM (
            CASE
               WHEN M.BILLDATE::DATE = (SELECT TODAY FROM DTA)
               THEN
                  M.NETPAYABLE
               ELSE
                  0
            END)
            NET_PAYABLE_AMOUNT,
         SUM (CASE
               WHEN M.BILLDATE::DATE BETWEEN (SELECT MTDSTART
                                                  FROM DTA)
                                           AND (SELECT TODAY
                                                  FROM DTA)
               THEN
                  M.NETPAYABLE
               ELSE
                  0
            END) MTD_NET_PAYABLE_AMOUNT,
            ROUND(SUM ((
            (CASE
               WHEN M.BILLDATE::DATE BETWEEN (SELECT MTDSTART
                                                  FROM DTA)
                                           AND (SELECT TODAY
                                                  FROM DTA)
               THEN
                  D.TAXABLE_AMOUNT
               ELSE
                  0
            END)+(
            CASE
               WHEN M.BILLDATE::DATE BETWEEN (SELECT MTDSTART
                                                  FROM DTA)
                                           AND (SELECT TODAY
                                                  FROM DTA)
               THEN
                  D.NONTAXABLE_AMOUNT
               ELSE
                  0
            END))/(SELECT DAY_NO FROM DTA)),2)
            AVG_MTD_NET_PAYABLE_AMOUNT,
         SUM (
            CASE
               WHEN M.BILLDATE::DATE = (SELECT TODAY FROM DTA)
               THEN
                  D.TAXABLE_AMOUNT
               ELSE
                  0
            END)
            TAXABLE_AMOUNT,
         SUM (
            CASE
               WHEN M.BILLDATE::DATE = (SELECT TODAY FROM DTA)
               THEN
                  D.NONTAXABLE_AMOUNT
               ELSE
                  0
            END)
            NONTAXABLE_AMOUNT,
         SUM (
            CASE
               WHEN M.BILLDATE::DATE = (SELECT TODAY FROM DTA)
               THEN
                  T.TOTALCOLLECTION
               ELSE
                  0
            END)
            MOP_TOTAL_COLLECTION,
         SUM (
            CASE
               WHEN M.BILLDATE::DATE BETWEEN (SELECT MTDSTART
                                                  FROM DTA)
                                           AND (SELECT TODAY
                                                  FROM DTA)
               THEN
                  D.TAXABLE_AMOUNT
               ELSE
                  0
            END)
            MTD_TAXABLE_AMOUNT,
         SUM (
            CASE
               WHEN M.BILLDATE::DATE BETWEEN (SELECT MTDSTART
                                                  FROM DTA)
                                           AND (SELECT TODAY
                                                  FROM DTA)
               THEN
                  D.NONTAXABLE_AMOUNT
               ELSE
                  0
            END)
            MTD_NONTAXABLE_AMOUNT
    FROM PSITE_POSBILL M
         INNER JOIN ADMSITE S ON (M.ADMSITE_CODE = S.CODE)
         INNER JOIN
         (  SELECT PSITE_POSBILL_CODE,
                   SUM (QTY) QTY,
                   SUM (CASE WHEN TAXAMT <> 0 THEN TAXABLEAMT ELSE 0 END)
                      TAXABLE_AMOUNT,
                   SUM (CASE WHEN TAXAMT = 0 THEN TAXABLEAMT ELSE 0 END)
                      NONTAXABLE_AMOUNT
              FROM PSITE_POSBILLITEM
          GROUP BY PSITE_POSBILL_CODE) D
            ON (M.CODE = D.PSITE_POSBILL_CODE)
         LEFT OUTER JOIN
         (  SELECT PSITE_POSBILL_CODE,
                   SUM (CASE WHEN MOPTYPE = 'CSH' THEN BASEAMT ELSE 0 END)
                      CASHCOLLECTION,
                   SUM (CASE WHEN MOPTYPE = 'EDC' THEN BASEAMT ELSE 0 END)
                      EDCCOLLECTION,
                   SUM (CASE WHEN MOPTYPE = 'VCH' THEN BASEAMT ELSE 0 END)
                      VCHCOLLECTION,
                   SUM (CASE WHEN MOPTYPE = 'CNI' THEN BASEAMT ELSE 0 END)
                      CNICOLLECTION,
                   SUM (CASE WHEN MOPTYPE = 'CNR' THEN BASEAMT ELSE 0 END)
                      CNRCOLLECTION,
                   SUM (CASE WHEN MOPTYPE = 'RED' THEN BASEAMT ELSE 0 END)
                      REDCOLLECTION,
                   SUM (CASE WHEN MOPTYPE = 'DNI' THEN BASEAMT ELSE 0 END)
                      DNICOLLECTION,
                   SUM (CASE WHEN MOPTYPE = 'DNA' THEN BASEAMT ELSE 0 END)
                      DNRCOLLECTION,
                   SUM (CASE WHEN MOPTYPE = 'WLT' THEN BASEAMT ELSE 0 END)
                      WLTCOLLECTION,
                   SUM (CASE WHEN MOPTYPE = 'GVH' THEN BASEAMT ELSE 0 END)
                      GVCOLLECTION,
                   SUM (BASEAMT) TOTALCOLLECTION
              FROM PSITE_POSBILLMOP
          GROUP BY PSITE_POSBILL_CODE) T
            ON (M.CODE = T.PSITE_POSBILL_CODE)
   WHERE M.BILLDATE::DATE BETWEEN (SELECT MTDSTART
                                       FROM DTA)
                                AND (SELECT TODAY
                                       FROM DTA)
GROUP BY M.ADMSITE_CODE, S.NAME