SELECT GINVIEW.FNC_UK () UK, T.*
  FROM (  SELECT C.CODE,
                 B.SPNO,
                 TRUNC (E.BILLDATE) BILLDATE,
                 A.SALESPERSON,
                 B.ADDRESS1,
                 B.ADDRESS2,
                 COUNT (
                    DISTINCT CASE
                                WHEN COALESCE (E.NETAMT, 0) BETWEEN 5000
                                                                AND 10000
                                THEN
                                   A.PSITE_POSBILL_CODE
                             END)
                    AS "5000-10000",
                 COUNT (
                    DISTINCT CASE
                                WHEN COALESCE (E.NETAMT, 0) BETWEEN 10001
                                                                AND 20000
                                THEN
                                   A.PSITE_POSBILL_CODE
                             END)
                    AS "10001 - 20000",
                 COUNT (
                    DISTINCT CASE
                                WHEN COALESCE (E.NETAMT, 0) BETWEEN 20001
                                                                AND 30000
                                THEN
                                   A.PSITE_POSBILL_CODE
                             END)
                    AS "20001 - 30000",
                 COUNT (
                    DISTINCT CASE
                                WHEN COALESCE (E.NETAMT, 0) BETWEEN 30001
                                                                AND 40000
                                THEN
                                   A.PSITE_POSBILL_CODE
                             END)
                    AS "30001 - 40000",
                 COUNT (
                    DISTINCT CASE
                                WHEN COALESCE (E.NETAMT, 0) BETWEEN 40001
                                                                AND 50000
                                THEN
                                   A.PSITE_POSBILL_CODE
                             END)
                    AS "40001 - 50000",
                 COUNT (
                    DISTINCT CASE
                                WHEN COALESCE (E.NETAMT, 0) >= 50000
                                THEN
                                   A.PSITE_POSBILL_CODE
                             END)
                    AS "50001 - ABOVE"
            FROM PSITE_POSBILLITEM A
                 INNER JOIN PSITE_SALESPERSON B
                    ON (    A.PSITE_SALESPERSON_ID = B.ID
                        AND A.ADMSITE_CODE = B.ADMSITE_CODE)
                 INNER JOIN ADMSITE C ON A.ADMSITE_CODE = C.CODE
                 INNER JOIN
                 (  SELECT PSITE_POSBILL_CODE,
                           COUNT (DISTINCT PSITE_SALESPERSON_ID) SM_COUNT
                      FROM PSITE_POSBILLITEM
                  GROUP BY PSITE_POSBILL_CODE) D
                    ON A.PSITE_POSBILL_CODE = D.PSITE_POSBILL_CODE
                 INNER JOIN PSITE_POSBILL E ON A.PSITE_POSBILL_CODE = E.CODE
                 INNER JOIN GINVIEW.LV_ITEM I ON A.ICODE = I.CODE
           WHERE     D.SM_COUNT IN (1, 0)
                 AND TRUNC (E.BILLDATE) BETWEEN TO_DATE ('@DTFR@',
                                                         'YYYY-MM-DD')
                                            AND TO_DATE ('@DTTO@',
                                                         'YYYY-MM-DD')
                 AND (   (    I.DIVISION = COALESCE ('@Division@', '-1')
                          AND COALESCE ('@Division@', '-1') <> '-1')
                      OR (COALESCE ('@Division@', '-1') = '-1'))
        GROUP BY C.CODE,
                 B.SPNO,
                 TRUNC (E.BILLDATE),
                 A.SALESPERSON,
                 B.ADDRESS1,
                 B.ADDRESS2) T
 WHERE (   "5000-10000" <> 0
        OR "10001 - 20000" <> 0
        OR "20001 - 30000" <> 0
        OR "30001 - 40000" <> 0
        OR "40001 - 50000" <> 0
        OR "50001 - ABOVE" <> 0)