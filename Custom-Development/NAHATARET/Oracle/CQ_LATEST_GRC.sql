/* Formatted on 10/04/2025 17:55:51 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_LATEST_GRC || Ticket Id : 401459 || Developer : Dipankar || ><><><*/
WITH GRC
     AS (SELECT D.ICODE,
                D.ACRATE  GRC_RATE,
                ROUND (
                   CASE WHEN D.ACQTY = 0 THEN 0 ELSE D.NETAMT / D.ACQTY END,
                   2)
                   GRC_NETRATE,
                IT.TAXAMT GRC_TAXAMT,
                ROW_NUMBER ()
                   OVER (PARTITION BY D.ICODE ORDER BY M.TIME DESC)
                   rn
           FROM INVGRCMAIN M
                INNER JOIN INVGRCDET D ON M.GRCCODE = D.GRCCODE
                LEFT OUTER JOIN (  SELECT INVGRCDET_CODE, SUM (CHGAMT) TAXAMT
                                     FROM INVGRCCHG_ITEM
                                    WHERE ISTAX = 'Y'
                                 GROUP BY INVGRCDET_CODE) IT
                   ON D.CODE = IT.INVGRCDET_CODE)
SELECT GINVIEW.FNC_UK () UK,
       ICODE,
       GRC_RATE,
       GRC_NETRATE,
       GRC_TAXAMT
  FROM GRC
 WHERE rn = 1