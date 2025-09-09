/*|| Custom Development || Object : CQ_SALE_GROWTH || Ticket Id : 427532 || Developer : Dipankar ||*/

  SELECT GINVIEW.FNC_UK () UK,
         M.ADMSITE_CODE,
         TRUNC (M.BILLDATE) BILL_DATE,
         SUM (
            CASE
               WHEN I.DIVISION = 'SAREES'
               THEN
                  CASE
                     WHEN PD.NAME = 'DISCOUNT'
                     THEN
                        COALESCE (D.NETAMT, 0) + COALESCE (D.MDISCOUNTAMT, 0)
                     ELSE
                        COALESCE (D.NETAMT, 0)
                  END
            END)
            SAREES_AMT,
         SUM (
            CASE
               WHEN I.DIVISION = 'SAREES' THEN I.STANDARD_RATE * D.QTY
               ELSE 0
            END)
            SAREES_COSTAMT,
         SUM (
            CASE
               WHEN I.DIVISION = 'LADIES WEAR'
               THEN
                  CASE
                     WHEN PD.NAME = 'DISCOUNT'
                     THEN
                        COALESCE (D.NETAMT, 0) + COALESCE (D.MDISCOUNTAMT, 0)
                     ELSE
                        COALESCE (D.NETAMT, 0)
                  END
            END)
            LW_AMT,
         SUM (
            CASE
               WHEN I.DIVISION = 'LADIES WEAR' THEN I.STANDARD_RATE * D.QTY
               ELSE 0
            END)
            LW_COSTAMT,
         SUM (
            CASE
               WHEN I.DIVISION = 'KIDS WEAR'
               THEN
                  CASE
                     WHEN PD.NAME = 'DISCOUNT'
                     THEN
                        COALESCE (D.NETAMT, 0) + COALESCE (D.MDISCOUNTAMT, 0)
                     ELSE
                        COALESCE (D.NETAMT, 0)
                  END
            END)
            KW_AMT,
         SUM (
            CASE
               WHEN I.DIVISION = 'KIDS WEAR' THEN I.STANDARD_RATE * D.QTY
               ELSE 0
            END)
            KW_COSTAMT,
         SUM (
            CASE
               WHEN I.DIVISION = 'MENS WEAR'
               THEN
                  CASE
                     WHEN PD.NAME = 'DISCOUNT'
                     THEN
                        COALESCE (D.NETAMT, 0) + COALESCE (D.MDISCOUNTAMT, 0)
                     ELSE
                        COALESCE (D.NETAMT, 0)
                  END
            END)
            MW_AMT,
         SUM (
            CASE
               WHEN I.DIVISION = 'MENS WEAR' THEN I.STANDARD_RATE * D.QTY
               ELSE 0
            END)
            MW_COSTAMT,
         SUM (
            CASE
               WHEN I.DIVISION = 'TEXTILES'
               THEN
                  CASE
                     WHEN PD.NAME = 'DISCOUNT'
                     THEN
                        COALESCE (D.NETAMT, 0) + COALESCE (D.MDISCOUNTAMT, 0)
                     ELSE
                        COALESCE (D.NETAMT, 0)
                  END
            END)
            T_AMT,
         SUM (
            CASE
               WHEN I.DIVISION = 'TEXTILES' THEN I.STANDARD_RATE * D.QTY
               ELSE 0
            END)
            T_COSTAMT,
         SUM (
            CASE
               WHEN I.DIVISION IN ('HOME FURNISHINGS', 'MATCHINGS')
               THEN
                  CASE
                     WHEN PD.NAME = 'DISCOUNT'
                     THEN
                        COALESCE (D.NETAMT, 0) + COALESCE (D.MDISCOUNTAMT, 0)
                     ELSE
                        COALESCE (D.NETAMT, 0)
                  END
            END)
            HM_AMT,
         SUM (
            CASE
               WHEN I.DIVISION IN ('HOME FURNISHINGS', 'MATCHINGS', 'Others')
               THEN
                  I.STANDARD_RATE * D.QTY
               ELSE
                  0
            END)
            HM_COSTAMT
    FROM PSITE_POSBILL M
         INNER JOIN PSITE_POSBILLITEM D ON M.CODE = D.PSITE_POSBILL_CODE
         LEFT OUTER JOIN PSITE_DISCOUNT PD ON m.MPSITE_DISCOUNT_CODE = PD.CODE
         INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
   WHERE     TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@DTFR@', 'yyyy-mm-dd')
                                    AND TO_DATE ('@DTTO@', 'yyyy-mm-dd')
         AND (   (    I.DIVISION = COALESCE ('@Division@', '-1')
                  AND COALESCE ('@Division@', '-1') <> '-1')
              OR (COALESCE ('@Division@', '-1') = '-1'))
         AND (   (    I.SECTION = COALESCE ('@Section@', '-1')
                  AND COALESCE ('@Section@', '-1') <> '-1')
              OR (COALESCE ('@Section@', '-1') = '-1'))
         AND (   (    I.DEPARTMENT = COALESCE ('@Department@', '-1')
                  AND COALESCE ('@Department@', '-1') <> '-1')
              OR (COALESCE ('@Department@', '-1') = '-1'))
GROUP BY M.ADMSITE_CODE, TRUNC (M.BILLDATE)