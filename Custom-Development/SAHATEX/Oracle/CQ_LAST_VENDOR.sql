/* Formatted on 2024-12-19 15:48:44 (QP5 v5.294) */
 /*
Purpose              Object                        ID              Developer          
Custom Development   CQ_LAST_VENDOR                406642          Dipankar
*/
WITH GRC
     AS (SELECT D.ICODE,
                V.SLNAME        VENDOR,
                M.SCHEME_DOCNO  GRC_NO,
                M.GRCDT         GRC_DATE,
                ROW_NUMBER ()
                   OVER (PARTITION BY D.ICODE ORDER BY M.TIME DESC)
                   rn
           FROM INVGRCMAIN M
                INNER JOIN INVGRCDET D ON M.GRCCODE = D.GRCCODE
                LEFT OUTER JOIN FINSL V ON M.PCODE = V.SLCODE)
SELECT GINVIEW.FNC_UK () UK,
       ICODE,
       VENDOR,
       GRC_NO,
       GRC_DATE
  FROM GRC
 WHERE rn = 1