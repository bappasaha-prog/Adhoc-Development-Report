/*|| Custom Development || Object : CQ_FIRST_SALE_DATE || Ticket Id :  417847 || Developer : Dipankar ||*/

WITH SALE
     AS (SELECT ICODE ,
                ADMSITE_CODE,
                FIRST_IN_DATE,
                ROW_NUMBER ()
                OVER (PARTITION BY ICODE, ADMSITE_CODE
                      ORDER BY CREATEDON ASC)
                   RN
           FROM (SELECT D.ICODE,
                        M.ADMSITE_CODE,
                        TRUNC(M.BILLDATE) FIRST_IN_DATE,
                        M.CREATEDON
                   FROM PSITE_POSBILL M
                   INNER JOIN PSITE_POSBILLITEM D
                  ON M.CODE = D.PSITE_POSBILL_CODE
                 UNION ALL
                 SELECT D.ICODE,
                        M.ADMSITE_CODE ADMSITE_CODE,
                        M.CSDATE           FIRST_IN_DATE,
                        M.TIME            CREATEDON
                   FROM SALCSMAIN M
               INNER JOIN SALCSDET D ON (M.CSCODE = D.CSCODE)
               WHERE     M.CHANNELTYPE = 'ETL'
               UNION ALL
                 SELECT D.ICODE,
                        M.ADMSITE_CODE ADMSITE_CODE,
                        M.SSDATE           FIRST_IN_DATE,
                        M.TIME            CREATEDON
                   FROM SALSSMAIN M
               INNER JOIN SALSSDET D ON (M.SSCODE = D.SSCODE)
               WHERE     M.CHANNELTYPE = 'ETL'))
SELECT GINVIEW.FNC_UK() UK,
       ICODE,
       ADMSITE_CODE,
       FIRST_IN_DATE
  FROM SALE
 WHERE RN = 1