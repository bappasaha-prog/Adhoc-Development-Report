/* Formatted on 2025-03-21 11:38:47 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_PL_SITE || Ticket Id : 401096 || Developer : Dipankar || ><><><*/
SELECT *
  FROM (  SELECT NULL                     AS REQUESTID,
                 GINVIEW.FNC_UK ()        AS UK,
                 GRP.LEVEL1               AS LEVEL1,
                 CASE
                    WHEN '@LevelCustom@' IN ('Level2',
                                       'Level3',
                                       'Level4',
                                       'Level5',
                                       'With Ledger')
                    THEN
                       GRP.LEVEL2
                 END
                    AS LEVEL2,
                 CASE
                    WHEN '@LevelCustom@' IN ('Level3',
                                       'Level4',
                                       'Level5',
                                       'With Ledger')
                    THEN
                       GRP.LEVEL3
                 END
                    AS LEVEL3,
                 CASE
                    WHEN '@LevelCustom@' IN ('Level4', 'Level5', 'With Ledger')
                    THEN
                       GRP.LEVEL4
                 END
                    AS LEVEL4,
                 CASE
                    WHEN '@LevelCustom@' IN ('Level5', 'With Ledger') THEN GRP.LEVEL5
                 END
                    AS LEVEL5,
                 CASE WHEN '@LevelCustom@' = 'With Ledger' THEN T1.GLCODE END
                    AS GLCODE,
                 CASE WHEN '@LevelCustom@' = 'With Ledger' THEN T1.GLNAME END
                    AS GLNAME,
                 T1.SLCODE,
                 T1.SLNAME,
                 T1.SITECODE,
                 S.NAME                   AS SITENAME,
                 SUM (DEBIT)              AS DEBIT,
                 SUM (CREDIT)             AS CREDIT,
                 SUM (DEBIT) - SUM (CREDIT) AS BALANCE
            FROM (SELECT T.GLCODE,
                         G.GLNAME,
                         T.SLCODE,
                         S.SLNAME,
                         T.REF_ADMSITE_CODE SITECODE,
                         CASE
                            WHEN COALESCE(T.DAMOUNT, 0) - COALESCE(T.CAMOUNT, 0) >= 0
                            THEN
                               COALESCE(T.DAMOUNT, 0) - COALESCE(T.CAMOUNT, 0)
                            ELSE
                               0
                         END
                            DEBIT,
                         CASE
                            WHEN COALESCE(T.DAMOUNT, 0) - COALESCE(T.CAMOUNT, 0) < 0
                            THEN
                               0 - (COALESCE(T.DAMOUNT, 0) - COALESCE(T.CAMOUNT, 0))
                            ELSE
                               0
                         END
                            CREDIT
                    FROM FINPOST  P,
                         FINCOSTTAG T,
                         FINGL    G,
                         FINSL    S
                   WHERE     P.POSTCODE = T.POSTCODE
                         AND P.ENTDT BETWEEN TO_DATE ('@DTFR@', 'yyyy-mm-dd')
                                         AND TO_DATE ('@DTTO@', 'yyyy-mm-dd')
                         AND T.GLCODE = G.GLCODE
                         AND T.SLCODE = S.SLCODE
                         AND G.TYPE IN ('I', 'E')
                         AND (   TO_NUMBER ('@FinIncludeUnpostedRecords@',
                                            '9G999g999999999999d99') = 1
                              OR (    TO_NUMBER ('@FinIncludeUnpostedRecords@',
                                                 '9G999g999999999999d99') = 0
                                  AND P.RELEASE_STATUS = 'P'))
                         AND P.ADMOU_CODE = to_number('@ConnOUCode@','9G999g999999999999d99')
                  UNION ALL
                  SELECT GLCODE,
                         GLNAME,
                         SLCODE,
                         SLNAME,
                         SITECODE,
                         CASE
                            WHEN SITE_OPENING >= 0 THEN SITE_OPENING
                            ELSE 0
                         END
                            DEBIT,
                         CASE
                            WHEN SITE_OPENING < 0 THEN SITE_OPENING * -1
                            ELSE 0
                         END
                            CREDIT
                    FROM (  SELECT P1.GLCODE,
                                   P1.GLNAME,
                                   P1.SLCODE,
                                   P1.SLNAME,
                                   P1.SITECODE,
                                   CASE
                                      WHEN (SELECT DTFR
                                              FROM ADMYEAR
                                             WHERE TO_DATE ('@DTFR@',
                                                            'yyyy-mm-dd') BETWEEN DTFR
                                                                              AND DTTO) =
                                              TO_DATE ('@DTFR@', 'yyyy-mm-dd')
                                      THEN
                                           SUM (COALESCE(P1.DAMOUNT, 0))
                                         - SUM (COALESCE(P1.CAMOUNT, 0))
                                      ELSE
                                         0
                                   END
                                      SITE_OPENING
                              FROM (SELECT O.GLCODE,
                                           G.GLNAME,
                                           O.SLCODE,
                                           S.SLNAME,
                                           O.ADMSITE_CODE SITECODE,
                                           COALESCE(O.DAMOUNT, 0) DAMOUNT,
                                           COALESCE(O.CAMOUNT, 0) CAMOUNT
                                      FROM FINCOSTTAG O,
                                           FINGL  G,
                                           FINPOST P,
                                           FINSL  S
                                     WHERE     O.GLCODE = G.GLCODE
                                           AND O.POSTCODE = P.POSTCODE
                                           AND O.SLCODE = S.SLCODE
                                           AND G.TYPE IN ('I', 'E')
                                           AND (   TO_NUMBER (
                                                      '@FinIncludeUnpostedRecords@',
                                                      '9G999g999999999999d99') =
                                                      1
                                                OR (    TO_NUMBER (
                                                           '@FinIncludeUnpostedRecords@',
                                                           '9G999g999999999999d99') =
                                                           0
                                                    AND RELEASE_STATUS = 'P'))
                                           AND O.YCODE =
                                                  (SELECT YCODE
                                                     FROM ADMYEAR
                                                    WHERE TO_DATE ('@DTFR@',
                                                                   'yyyy-mm-dd') BETWEEN DTFR
                                                                                     AND DTTO)
                                           AND O.ENTDT <
                                                  TO_DATE ('@DTFR@',
                                                           'yyyy-mm-dd')
                                           AND O.ADMOU_CODE = to_number('@ConnOUCode@','9G999g999999999999d99')) P1
                          GROUP BY P1.GLCODE,
                                   P1.GLNAME,
                                   P1.SLCODE,
                                   P1.SLNAME,
                                   P1.SITECODE)) T1
                 JOIN FINGL GL ON T1.GLCODE = GL.GLCODE
                 JOIN GINVIEW.LV_CHART_OF_ACCOUNTS GRP ON GL.GRPCODE = GRP.CODE
                 JOIN ADMSITE S ON T1.SITECODE = S.CODE
        GROUP BY GRP.LEVEL1,
                 GRP.LEVEL2,
                 GRP.LEVEL3,
                 GRP.LEVEL4,
                 GRP.LEVEL5,
                 T1.GLCODE,
                 T1.GLNAME,
                 T1.SLCODE,
                 T1.SLNAME,
                 T1.SITECODE,
                 S.NAME)
 WHERE (   TO_NUMBER ('@FinIncludeZeroBalanceRecords@',
                      '9G999g999999999999d99') = 1
        OR (    TO_NUMBER ('@FinIncludeZeroBalanceRecords@',
                           '9G999g999999999999d99') = 0
            AND BALANCE <> 0))