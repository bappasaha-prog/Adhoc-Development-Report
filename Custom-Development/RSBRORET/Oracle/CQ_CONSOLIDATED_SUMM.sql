/* Formatted on 2025-07-18 17:11:39 (QP5 v5.294) */
  SELECT GINVIEW.FNC_UK () UK,
         TYPE,
         ADMSITE_CODE,
         DESSITE_CODE,
         ADMOU_CODE,
         SUM (NETAMT)    NETAMT
    FROM (  SELECT 'Retail'   TYPE,
                   M.ADMSITE_CODE,
                   NULL       DESSITE_CODE,
                   S.ADMOU_CODE,
                   SUM (M.NETAMT) NETAMT
              FROM PSITE_POSBILL M, admsite S
             WHERE     M.ADMSITE_CODE = S.CODE
                   AND TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@DTFR@',
                                                           'yyyy-mm-dd')
                                              AND TO_DATE ('@DTTO@',
                                                           'yyyy-mm-dd')
          GROUP BY M.ADMSITE_CODE, S.ADMOU_CODE
          UNION ALL
            SELECT 'Whole Sale' TYPE,
                   ADMSITE_CODE,
                   DESSITE_CODE,
                   ADMOU_CODE,
                   SUM (AMT) NETAMT
              FROM (  SELECT M.ADMSITE_CODE_OWNER ADMSITE_CODE,
                             M.ADMSITE_CODE DESSITE_CODE,
                             M.ADMOU_CODE,
                             SUM (M.NETAMT) AMT
                        FROM SALINVMAIN M
                       WHERE     M.INVDT BETWEEN TO_DATE ('@DTFR@', 'yyyy-mm-dd')
                                             AND TO_DATE ('@DTTO@', 'yyyy-mm-dd')
                             AND M.SALETYPE = 'O'
                    GROUP BY M.ADMSITE_CODE_OWNER, M.ADMSITE_CODE, M.ADMOU_CODE
                    UNION ALL
                      SELECT M.ADMSITE_CODE_OWNER ADMSITE_CODE,
                             M.ADMSITE_CODE DESSITE_CODE,
                             M.ADMOU_CODE,
                             -SUM (M.NETAMT) AMT
                        FROM SALRTMAIN M
                       WHERE     M.RTDT BETWEEN TO_DATE ('@DTFR@', 'yyyy-mm-dd')
                                            AND TO_DATE ('@DTTO@', 'yyyy-mm-dd')
                             AND M.SALETYPE = 'O'
                    GROUP BY M.ADMSITE_CODE_OWNER, M.ADMSITE_CODE, M.ADMOU_CODE)
          GROUP BY ADMSITE_CODE, ADMOU_CODE, DESSITE_CODE)
GROUP BY TYPE,
         ADMSITE_CODE,
         ADMOU_CODE,
         DESSITE_CODE