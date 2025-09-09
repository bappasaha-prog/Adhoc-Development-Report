/*|| Custom Development || Object : CQ_LAST_DATE_CATEGORY2 || Ticket Id :  417847 || Developer : Dipankar ||*/

WITH PGRC
     AS (SELECT I.CATEGORY2 ,
                A.FIRST_DATE,
                ROW_NUMBER ()
                OVER (PARTITION BY I.CATEGORY2
                      ORDER BY A.CREATEDON ASC)
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
                        INNER JOIN INVGRCDET D ON M.GRCCODE = D.GRCCODE) A
                        INNER JOIN GINVIEW.LV_ITEM I ON A.ICODE = I.CODE )
SELECT GINVIEW.FNC_UK() UK,
       CATEGORY2,
       FIRST_DATE
  FROM PGRC
 WHERE RN = 1