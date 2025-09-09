/*|| Custom Development || Object : CQ_LAST_DATE || Ticket Id :  417847 || Developer : Dipankar ||*/

WITH PGRC
     AS (SELECT ICODE,
                FIRST_DATE,
                ROW_NUMBER ()
                OVER (PARTITION BY ICODE
                      ORDER BY CREATEDON ASC)
                   RN
           FROM (SELECT D.ICODE,
                        M.DOCDT FIRST_DATE,
                        M.CREATEDON
                   FROM PSITE_GRC M
                        INNER JOIN PSITE_GRCITEM D
                           ON M.CODE = D.PSITE_GRC_CODE
                 UNION ALL
                 SELECT D.ICODE,
                        M.GRCDT           FIRST_DATE,
                        M.TIME            CREATEDON
                   FROM INVGRCMAIN M
                        INNER JOIN INVGRCDET D ON M.GRCCODE = D.GRCCODE))
SELECT GINVIEW.FNC_UK() UK,
       ICODE,
       FIRST_DATE
  FROM PGRC
 WHERE RN = 1