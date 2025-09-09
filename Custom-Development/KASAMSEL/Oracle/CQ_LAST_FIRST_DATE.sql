/*|| Custom Development || Object : CQ_LAST_FIRST_DATE || Ticket Id : 427005 || Developer : Dipankar ||*/

WITH DTA
     AS (SELECT I.CATEGORY6,
                GM.GRCCODE,
                GM.GRCDT GRC_DATE,
                GM.TIME
           FROM PURORDMAIN M
                INNER JOIN PURORDDET D ON M.ORDCODE = D.ORDCODE
                INNER JOIN INVGRCDET GD
                   ON D.CODE = GD.PO_CODE AND D.ORDCODE = GD.ORDCODE
                INNER JOIN INVGRCMAIN GM ON GD.GRCCODE = GM.GRCCODE
                INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
          WHERE     TRUNC (M.ORDDT) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                        AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                AND (   (    I.DIVISION = COALESCE ('@Division@', '-1')
                         AND COALESCE ('@Division@', '-1') <> '-1')
                     OR (COALESCE ('@Division@', '-1') = '-1'))
                AND (   (    I.SECTION = COALESCE ('@Section@', '-1')
                         AND COALESCE ('@Section@', '-1') <> '-1')
                     OR (COALESCE ('@Section@', '-1') = '-1'))
                AND (   (    I.DEPARTMENT = COALESCE ('@Department@', '-1')
                         AND COALESCE ('@Department@', '-1') <> '-1')
                     OR (COALESCE ('@Department@', '-1') = '-1'))
                AND (   I.CATEGORY6 IN
                           (    SELECT REGEXP_SUBSTR ('@#ItemCategory6Multi#@',
                                                      '[^æ]+',
                                                      1,
                                                      LEVEL)
                                          COL1
                                  FROM DUAL
                            CONNECT BY LEVEL <=
                                            REGEXP_COUNT (
                                               '@#ItemCategory6Multi#@',
                                               'æ')
                                          + 1)
                     OR NVL (
                           REGEXP_COUNT ('@#ItemCategory6Multi#@', 'æ') + 1,
                           0) = 0)
                AND (   I.CATEGORY2 IN
                           (    SELECT REGEXP_SUBSTR ('@#ItemCategory2Multi#@',
                                                      '[^æ]+',
                                                      1,
                                                      LEVEL)
                                          COL1
                                  FROM DUAL
                            CONNECT BY LEVEL <=
                                            REGEXP_COUNT (
                                               '@#ItemCategory2Multi#@',
                                               'æ')
                                          + 1)
                     OR NVL (
                           REGEXP_COUNT ('@#ItemCategory2Multi#@', 'æ') + 1,
                           0) = 0))
  SELECT GINVIEW.FNC_UK () UK,
         CATEGORY6,
         MAX (FIRST_DATE)  FIRST_DATE,
         MAX (LAST_DATE)   LAST_DATE,
         SUM (RECEIVE_COUNT) RECEIVE_COUNT
    FROM (SELECT CATEGORY6,
                 GRC_DATE FIRST_DATE,
                 NULL   LAST_DATE,
                 0      RECEIVE_COUNT
            FROM (SELECT CATEGORY6,
                         GRC_DATE,
                         ROW_NUMBER ()
                            OVER (PARTITION BY CATEGORY6 ORDER BY TIME ASC)
                            RN
                    FROM DTA)
           WHERE RN = 1
          UNION ALL
          SELECT CATEGORY6,
                 NULL,
                 GRC_DATE LAST_DATE,
                 0
            FROM (SELECT CATEGORY6,
                         GRC_DATE,
                         ROW_NUMBER ()
                            OVER (PARTITION BY CATEGORY6 ORDER BY TIME DESC)
                            RN
                    FROM DTA)
           WHERE RN = 1
          UNION ALL
            SELECT CATEGORY6,
                   NULL,
                   NULL,
                   COUNT (DISTINCT GRCCODE) RECEIVE_COUNT
              FROM DTA
          GROUP BY CATEGORY6)
GROUP BY CATEGORY6