WITH PGRC
     AS (SELECT ICODE,
                ADMOU_CODE,
                LAST_DATE,
                VENDOR,
                ROW_NUMBER ()
                   OVER (PARTITION BY ICODE,ADMOU_CODE ORDER BY CREATEDON DESC)
                   RN
           FROM (SELECT M.ADMOU_CODE,
                        D.ICODE,
                        M.GRCDT  LAST_DATE,
                        S.SLNAME VENDOR,
                        M.TIME   CREATEDON
                   FROM INVGRCMAIN M
                        INNER JOIN INVGRCDET D ON M.GRCCODE = D.GRCCODE
                        INNER JOIN FINSL S ON M.PCODE = S.SLCODE))
SELECT GINVIEW.FNC_UK ()                     UK,
       I.ICODE,
       COALESCE (A.LAST_DATE, B.LAST_DATE) LAST_DATE,
       COALESCE (A.VENDOR, B.VENDOR)         VENDOR
  FROM INVITEM I
       LEFT JOIN (SELECT ICODE,
                         LAST_DATE,
                         VENDOR,
                         ADMOU_CODE
                    FROM PGRC
                   WHERE RN = 1 AND ADMOU_CODE = 2) A
          ON I.ICODE = A.ICODE
       LEFT JOIN (SELECT ICODE,
                         LAST_DATE,
                         VENDOR,
                         ADMOU_CODE
                    FROM PGRC
                   WHERE RN = 1 AND ADMOU_CODE = 1) B
          ON I.ICODE = B.ICODE