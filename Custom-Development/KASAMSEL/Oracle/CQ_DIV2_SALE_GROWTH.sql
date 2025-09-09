/* Formatted on 2025-04-24 16:29:34 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_DIV_SALE_GROWTH || Ticket Id : 381026,408003 || Developer : Dipankar || ><><><*/
  SELECT GINVIEW.FNC_UK () UK,
         M.ADMSITE_CODE,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period1DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period1DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION = 'SAREES'
               THEN
                  CASE
                     WHEN PD.NAME = 'DISCOUNT'
                     THEN
                        COALESCE (D.NETAMT, 0) + COALESCE (D.MDISCOUNTAMT, 0)
                     ELSE
                        COALESCE (D.NETAMT, 0)
                  END
            END)
            PERIOD_1_SAREES_AMT,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period2DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period2DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION = 'SAREES'
               THEN
                  CASE
                     WHEN PD.NAME = 'DISCOUNT'
                     THEN
                        COALESCE (D.NETAMT, 0) + COALESCE (D.MDISCOUNTAMT, 0)
                     ELSE
                        COALESCE (D.NETAMT, 0)
                  END
            END)
            PERIOD_2_SAREES_AMT,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period1DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period1DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION = 'SAREES'
               THEN
                  I.STANDARD_RATE * D.QTY
               ELSE
                  0
            END)
            PERIOD_1_SAREES_COSTAMT,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period2DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period2DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION = 'SAREES'
               THEN
                  I.STANDARD_RATE * D.QTY
               ELSE
                  0
            END)
            PERIOD_2_SAREES_COSTAMT,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period1DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period1DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION = 'LADIES WEAR'
               THEN
                  CASE
                     WHEN PD.NAME = 'DISCOUNT'
                     THEN
                        COALESCE (D.NETAMT, 0) + COALESCE (D.MDISCOUNTAMT, 0)
                     ELSE
                        COALESCE (D.NETAMT, 0)
                  END
            END)
            PERIOD_1_LW_AMT,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period2DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period2DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION = 'LADIES WEAR'
               THEN
                  CASE
                     WHEN PD.NAME = 'DISCOUNT'
                     THEN
                        COALESCE (D.NETAMT, 0) + COALESCE (D.MDISCOUNTAMT, 0)
                     ELSE
                        COALESCE (D.NETAMT, 0)
                  END
            END)
            PERIOD_2_LW_AMT,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period1DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period1DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION = 'LADIES WEAR'
               THEN
                  I.STANDARD_RATE * D.QTY
               ELSE
                  0
            END)
            PERIOD_1_LW_COSTAMT,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period2DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period2DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION = 'LADIES WEAR'
               THEN
                  I.STANDARD_RATE * D.QTY
               ELSE
                  0
            END)
            PERIOD_2_LW_COSTAMT,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period1DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period1DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION = 'KIDS WEAR'
               THEN
                  CASE
                     WHEN PD.NAME = 'DISCOUNT'
                     THEN
                        COALESCE (D.NETAMT, 0) + COALESCE (D.MDISCOUNTAMT, 0)
                     ELSE
                        COALESCE (D.NETAMT, 0)
                  END
            END)
            PERIOD_1_KW_AMT,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period2DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period2DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION = 'KIDS WEAR'
               THEN
                  CASE
                     WHEN PD.NAME = 'DISCOUNT'
                     THEN
                        COALESCE (D.NETAMT, 0) + COALESCE (D.MDISCOUNTAMT, 0)
                     ELSE
                        COALESCE (D.NETAMT, 0)
                  END
            END)
            PERIOD_2_KW_AMT,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period1DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period1DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION = 'KIDS WEAR'
               THEN
                  I.STANDARD_RATE * D.QTY
               ELSE
                  0
            END)
            PERIOD_1_KW_COSTAMT,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period2DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period2DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION = 'KIDS WEAR'
               THEN
                  I.STANDARD_RATE * D.QTY
               ELSE
                  0
            END)
            PERIOD_2_KW_COSTAMT,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period1DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period1DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION = 'MENS WEAR'
               THEN
                  CASE
                     WHEN PD.NAME = 'DISCOUNT'
                     THEN
                        COALESCE (D.NETAMT, 0) + COALESCE (D.MDISCOUNTAMT, 0)
                     ELSE
                        COALESCE (D.NETAMT, 0)
                  END
            END)
            PERIOD_1_MW_AMT,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period2DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period2DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION = 'MENS WEAR'
               THEN
                  CASE
                     WHEN PD.NAME = 'DISCOUNT'
                     THEN
                        COALESCE (D.NETAMT, 0) + COALESCE (D.MDISCOUNTAMT, 0)
                     ELSE
                        COALESCE (D.NETAMT, 0)
                  END
            END)
            PERIOD_2_MW_AMT,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period1DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period1DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION = 'MENS WEAR'
               THEN
                  I.STANDARD_RATE * D.QTY
               ELSE
                  0
            END)
            PERIOD_1_MW_COSTAMT,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period2DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period2DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION = 'MENS WEAR'
               THEN
                  I.STANDARD_RATE * D.QTY
               ELSE
                  0
            END)
            PERIOD_2_MW_COSTAMT,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period1DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period1DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION = 'TEXTILES'
               THEN
                  CASE
                     WHEN PD.NAME = 'DISCOUNT'
                     THEN
                        COALESCE (D.NETAMT, 0) + COALESCE (D.MDISCOUNTAMT, 0)
                     ELSE
                        COALESCE (D.NETAMT, 0)
                  END
            END)
            PERIOD_1_T_AMT,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period2DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period2DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION = 'TEXTILES'
               THEN
                  CASE
                     WHEN PD.NAME = 'DISCOUNT'
                     THEN
                        COALESCE (D.NETAMT, 0) + COALESCE (D.MDISCOUNTAMT, 0)
                     ELSE
                        COALESCE (D.NETAMT, 0)
                  END
            END)
            PERIOD_2_T_AMT,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period1DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period1DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION = 'TEXTILES'
               THEN
                  I.STANDARD_RATE * D.QTY
               ELSE
                  0
            END)
            PERIOD_1_T_COSTAMT,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period2DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period2DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION = 'TEXTILES'
               THEN
                  I.STANDARD_RATE * D.QTY
               ELSE
                  0
            END)
            PERIOD_2_T_COSTAMT,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period1DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period1DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION IN ('HOME FURNISHINGS', 'MATCHINGS')
               THEN
                  CASE
                     WHEN PD.NAME = 'DISCOUNT'
                     THEN
                        COALESCE (D.NETAMT, 0) + COALESCE (D.MDISCOUNTAMT, 0)
                     ELSE
                        COALESCE (D.NETAMT, 0)
                  END
            END)
            PERIOD_1_HM_AMT,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period2DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period2DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION IN ('HOME FURNISHINGS', 'MATCHINGS')
               THEN
                  CASE
                     WHEN PD.NAME = 'DISCOUNT'
                     THEN
                        COALESCE (D.NETAMT, 0) + COALESCE (D.MDISCOUNTAMT, 0)
                     ELSE
                        COALESCE (D.NETAMT, 0)
                  END
            END)
            PERIOD_2_HM_AMT,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period1DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period1DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION IN ('HOME FURNISHINGS', 'MATCHINGS')
               THEN
                  I.STANDARD_RATE * D.QTY
               ELSE
                  0
            END)
            PERIOD_1_HM_COSTAMT,
         SUM (
            CASE
               WHEN     TRUNC (M.BILLDATE) BETWEEN TO_DATE (
                                                      '@Period2DateFrom@',
                                                      'yyyy-mm-dd')
                                               AND TO_DATE ('@Period2DateTo@',
                                                            'yyyy-mm-dd')
                    AND I.DIVISION IN ('HOME FURNISHINGS', 'MATCHINGS')
               THEN
                  I.STANDARD_RATE * D.QTY
               ELSE
                  0
            END)
            PERIOD_2_HM_COSTAMT
    FROM PSITE_POSBILL M
         INNER JOIN PSITE_POSBILLITEM D ON M.CODE = D.PSITE_POSBILL_CODE
         LEFT OUTER JOIN PSITE_DISCOUNT PD ON m.MPSITE_DISCOUNT_CODE = PD.CODE
         INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
   WHERE     (   (TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@Period1DateFrom@',
                                                      'yyyy-mm-dd')
                                         AND TO_DATE ('@Period1DateTo@',
                                                      'yyyy-mm-dd'))
              OR (TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@Period2DateFrom@',
                                                      'yyyy-mm-dd')
                                         AND TO_DATE ('@Period2DateTo@',
                                                      'yyyy-mm-dd')))
         AND (   (    I.DIVISION = COALESCE ('@Division@', '-1')
                  AND COALESCE ('@Division@', '-1') <> '-1')
              OR (COALESCE ('@Division@', '-1') = '-1'))
         AND (   (    I.SECTION = COALESCE ('@Section@', '-1')
                  AND COALESCE ('@Section@', '-1') <> '-1')
              OR (COALESCE ('@Section@', '-1') = '-1'))
         AND (   (    I.DEPARTMENT = COALESCE ('@Department@', '-1')
                  AND COALESCE ('@Department@', '-1') <> '-1')
              OR (COALESCE ('@Department@', '-1') = '-1'))
GROUP BY M.ADMSITE_CODE