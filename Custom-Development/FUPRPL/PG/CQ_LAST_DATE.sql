/*|| Custom Development || Object : CQ_LAST_DATE || Ticket Id :  420409 || Developer : Dipankar ||*/

WITH PGRC
     AS (SELECT ICODE,
                ADMSITE_CODE,
                FIRST_IN_DATE,
                ROW_NUMBER ()
                OVER (PARTITION BY ICODE, ADMSITE_CODE
                      ORDER BY CREATEDON DESC)
                   RN
           FROM (SELECT D.ICODE,
                        M.ADMSITE_CODE,
                        M.DOCDT::date FIRST_IN_DATE,
                        M.CREATEDON
                   FROM PSITE_GRC M
                        INNER JOIN PSITE_GRCITEM D
                           ON M.CODE = D.PSITE_GRC_CODE
                 UNION ALL
                 SELECT D.ICODE,
                        M.ADMSITE_CODE_IN ADMSITE_CODE,
                        M.GRCDT::date           FIRST_IN_DATE,
                        M.TIME            CREATEDON
                   FROM INVGRCMAIN M
                        INNER JOIN INVGRCDET D ON M.GRCCODE = D.GRCCODE))
SELECT row_number() over() as  UK,
       coalesce(I.BARCODE,I.CODE) BARCODE,
       ADMSITE_CODE,
       FIRST_IN_DATE LAST_DATE
  FROM PGRC P
  inner join GINVIEW.LV_ITEM I on P.icode  = I.CODE
 WHERE RN = 1