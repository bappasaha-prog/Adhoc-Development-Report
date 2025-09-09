/* Formatted on 2025/06/18 16:36:58 (QP5 v5.294) */
/*|| Custom Development || Object : CQ_LAST_FIRST_DATE || Ticket Id :  417847 || Developer : Dipankar ||*/

WITH PGRC
     AS (SELECT ICODE,
                ADMSITE_CODE,
                FIRST_IN_DATE,
                ROW_NUMBER ()
                OVER (PARTITION BY ICODE, ADMSITE_CODE
                      ORDER BY CREATEDON ASC)
                   RN
           FROM (SELECT D.ICODE,
                        M.ADMSITE_CODE,
                        M.DOCDT FIRST_IN_DATE,
                        M.CREATEDON
                   FROM PSITE_GRC M
                        INNER JOIN PSITE_GRCITEM D
                           ON M.CODE = D.PSITE_GRC_CODE
                 UNION ALL
                 SELECT D.ICODE,
                        M.ADMSITE_CODE_IN ADMSITE_CODE,
                        M.GRCDT           FIRST_IN_DATE,
                        M.TIME            CREATEDON
                   FROM INVGRCMAIN M
                        INNER JOIN INVGRCDET D ON M.GRCCODE = D.GRCCODE))
SELECT GINVIEW.FNC_UK() UK,
       ICODE,
       ADMSITE_CODE,
       FIRST_IN_DATE
  FROM PGRC
 WHERE RN = 1