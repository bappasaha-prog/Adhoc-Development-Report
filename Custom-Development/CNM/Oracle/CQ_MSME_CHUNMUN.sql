/*|| Custom Development || Object : CQ_MSME_CHUNMUN || Ticket Id :  421162 || Developer : Dipankar ||*/

WITH ENT
     AS (SELECT *
           FROM FINENTTYPE
          WHERE ENTNAME IN ('Purchase Invoice', 'Perchase Service')),
     FIN_POST
     AS (SELECT DISTINCT ENTCODE
           FROM FINPOST),
     LEDGER
     AS (SELECT DISTINCT ENTCODE2 ENTCODE
           FROM (SELECT T.ENTCODE2
                   FROM FINTAG T INNER JOIN ENT E ON (T.ENTTYPE2 = E.ENTTYPE)
                  WHERE TO_CHAR (ENTCODE1) IN (SELECT ENTCODE
                                                 FROM FIN_POST)
                 UNION ALL
                 SELECT T.ENTCODE1
                   FROM FINTAG T INNER JOIN ENT E ON (T.ENTTYPE1 = E.ENTTYPE)
                  WHERE TO_CHAR (ENTCODE2) IN (SELECT ENTCODE
                                                 FROM FIN_POST))),
     DTA
     AS (  SELECT ENTCODE,
                  SLCODE,
                  SCHEME_DOCNO,
                  TRUNC (ENTDT) ENTDT,
                  TRUNC (DOCDT) DOCDT,
                  SUM (COALESCE (DAMOUNT, 0) - COALESCE (CAMOUNT, 0)) * -1
                     DOC_AMOUNT,
                  SUM (ADJAMT) ADJ_AMT
             FROM FINPOST P INNER JOIN ENT T ON (P.ENTTYPE = T.ENTTYPE)
            WHERE     ENTDT BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                  AND SLCODE IS NOT NULL
                  AND P.ADMOU_CODE = TO_NUMBER ('@ConnOUCode@')
         GROUP BY ENTCODE,
                  SLCODE,
                  SCHEME_DOCNO,
                  TRUNC (ENTDT),
                  TRUNC (DOCDT)),
     OTSD
     AS (  SELECT P.ENTCODE,
                  P.SLCODE,
                  P.SCHEME_DOCNO,
                  TRUNC (P.ENTDT)              ENTDT,
                  TRUNC (P.DOCDT)              DOCDT,
                  SUM (COALESCE (P.DAMOUNT, 0) - COALESCE (P.CAMOUNT, 0)) * -1
                     DOC_AMOUNT,
                  SUM (COALESCE (TAG.ADJAMT, 0)) ADJ_AMT
             FROM FINPOST P
                  INNER JOIN ENT T ON (P.ENTTYPE = T.ENTTYPE)
                  LEFT JOIN
                  (  SELECT ENTCODE, SUM (AMOUNT) ADJAMT
                       FROM (SELECT ENTCODE1 ENTCODE, AMOUNT
                               FROM FINTAG
                              WHERE TRUNC (TIME) <=
                                       TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                             UNION ALL
                             SELECT ENTCODE2, AMOUNT
                               FROM FINTAG
                              WHERE TRUNC (TIME) <=
                                       TO_DATE ('@DTTO@', 'YYYY-MM-DD'))
                   GROUP BY ENTCODE) TAG
                     ON P.ENTCODE = TAG.ENTCODE
            WHERE     TRUNC (ENTDT) <= TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                  AND SLCODE IS NOT NULL
                  AND P.ADMOU_CODE = TO_NUMBER ('@ConnOUCode@')
         GROUP BY P.ENTCODE,
                  P.SLCODE,
                  P.SCHEME_DOCNO,
                  TRUNC (P.ENTDT),
                  TRUNC (P.DOCDT)),
     ADJ
     AS (SELECT ENTCODE2             ENTCODE,
                SLCODE,
                COALESCE (AMOUNT, 0) RECEIPT_AMT,
                TRUNC (TIME)         RECEIPT_DT,
                ENTCODE1
           FROM FINTAG T INNER JOIN ENT E ON (T.ENTTYPE2 = E.ENTTYPE)
          WHERE TRUNC (T.TIME) <= TO_DATE ('@DTTO@', 'YYYY-MM-DD')
         UNION ALL
         SELECT ENTCODE1             ENTCODE,
                SLCODE,
                COALESCE (AMOUNT, 0) RECEIPT_AMT,
                TRUNC (TIME)         RECEIPT_DT,
                ENTCODE2
           FROM FINTAG T INNER JOIN ENT E ON (T.ENTTYPE1 = E.ENTTYPE)
          WHERE TRUNC (T.TIME) <= TO_DATE ('@DTTO@', 'YYYY-MM-DD')),
     WITH_LEDGER
     AS (  SELECT A.ENTCODE,
                  SLCODE,
                  SUM (COALESCE (RECEIPT_AMT, 0)) RECEIPT_AMT,
                  MAX (RECEIPT_DT)              RECEIPT_DT
             FROM ADJ A
            WHERE A.ENTCODE IN (SELECT ENTCODE
                                  FROM LEDGER)
         GROUP BY A.ENTCODE, SLCODE)
SELECT GINVIEW.FNC_UK () UK,
       ENTCODE,
       SLCODE,
       SCHEME_DOCNO,
       ENTDT,
       DOCDT,
       RECEIPT_DT,
       DOC_AMOUNT,
       ADJ_AMT,
       RECEIPT_AMT,
       AGE,
       DOC_AGE,
       LVL
  FROM (SELECT D.ENTCODE,
               D.SLCODE,
               D.SCHEME_DOCNO,
               D.ENTDT,
               D.DOCDT,
               L.RECEIPT_DT,
               D.DOC_AMOUNT,
               D.ADJ_AMT,
               L.RECEIPT_AMT,
               L.RECEIPT_DT - D.ENTDT AGE,
               0 DOC_AGE,
               'WL'                   LVL
          FROM DTA D INNER JOIN WITH_LEDGER L ON (D.ENTCODE = L.ENTCODE)
         WHERE     D.DOC_AMOUNT = L.RECEIPT_AMT
               AND ENTDT BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                             AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
        UNION ALL
        SELECT D.ENTCODE,
               D.SLCODE,
               D.SCHEME_DOCNO,
               D.ENTDT,
               D.DOCDT,
               NULL                                       RECEIPT_DT,
               D.DOC_AMOUNT,
               D.ADJ_AMT,
               NULL                                       RECEIPT_AMT,
               TO_DATE ('@DTTO@', 'YYYY-MM-DD') - D.ENTDT AGE,
               TO_DATE ('@DTTO@', 'YYYY-MM-DD') - D.DOCDT DOC_AGE,
               'OTSD'                                     LVL
          FROM OTSD D
         WHERE D.DOC_AMOUNT <> D.ADJ_AMT)