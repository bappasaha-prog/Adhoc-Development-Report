/*|| Custom Development || Object : CQ_YEARLY_SALE || Ticket Id : 428343 || Developer : Dipankar ||*/

  SELECT GINVIEW.FNC_UK () UK,
         M.ADMSITE_CODE,
         TO_CHAR(TRUNC(M.BILLDATE),'YYYY') YEAR_NAME,
         SUM (
            CASE
               WHEN PD.NAME = 'DISCOUNT'
               THEN
                  COALESCE (D.NETAMT, 0) + COALESCE (D.MDISCOUNTAMT, 0)
               ELSE
                  COALESCE (D.NETAMT, 0)
            END)
            NETAMT
    FROM PSITE_POSBILL M
         INNER JOIN PSITE_POSBILLITEM D ON M.CODE = D.PSITE_POSBILL_CODE
         LEFT OUTER JOIN PSITE_DISCOUNT PD ON m.MPSITE_DISCOUNT_CODE = PD.CODE
         INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
   WHERE     TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
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
GROUP BY M.ADMSITE_CODE,TO_CHAR(TRUNC(M.BILLDATE),'YYYY')