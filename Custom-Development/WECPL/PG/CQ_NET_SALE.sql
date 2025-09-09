/*|| Custom Development || Object : CQ_NET_SALE || Ticket Id :  422877 || Developer : Dipankar ||*/
SELECT ROW_NUMBER() OVER() UK,
       AGCODE,
       PCODE,
       SUM (SALES_NETAMT)          SALES_NETAMT,
       SUM (SALES_OTHER_CHARGE)    SALES_OTHER_CHARGE,
       SUM (SALES_TAXABLE_AMOUNT)  SALES_TAXABLE_AMOUNT,
       SUM (SALES_TAX_AMOUNT)      SALES_TAX_AMOUNT,
       SUM (RETURN_NETAMT)         RETURN_NETAMT,
       SUM (RETURN_OTHER_CHARGE)   RETURN_OTHER_CHARGE,
       SUM (RETURN_TAXABLE_AMOUNT) RETURN_TAXABLE_AMOUNT,
       SUM (RETURN_TAX_AMOUNT)     RETURN_TAX_AMOUNT
  FROM (  SELECT AGCODE,
                 PCODE,
                 SUM (
                      COALESCE (D.INVAMT, 0)
                    + COALESCE (D.CHGAMT, 0)
                    + COALESCE (D.TAXAMT, 0))
                    SALES_NETAMT,
                 SUM (COALESCE (OTX.OTHER_CHARGE, 0)) SALES_OTHER_CHARGE,
                 SUM (COALESCE (TAX.TAXABLE_AMOUNT, 0)) SALES_TAXABLE_AMOUNT,
                 SUM (COALESCE (TAX.TAX_AMOUNT, 0))   SALES_TAX_AMOUNT,
                 0                                    RETURN_NETAMT,
                 0                                    RETURN_OTHER_CHARGE,
                 0                                    RETURN_TAXABLE_AMOUNT,
                 0                                    RETURN_TAX_AMOUNT
            FROM SALINVMAIN M
                 INNER JOIN SALINVDET D ON M.INVCODE = D.INVCODE
                 LEFT JOIN (  SELECT INVCODE,
                                     SALINVDET_CODE,
                                     APPAMT                 TAXABLE_AMOUNT,
                                     SUM (COALESCE (CHGAMT, 0)) TAX_AMOUNT
                                FROM SALINVCHG_ITEM
                               WHERE ISTAX = 'Y'
                            GROUP BY INVCODE, SALINVDET_CODE, APPAMT) TAX
                    ON D.INVCODE = TAX.INVCODE AND D.CODE = TAX.SALINVDET_CODE
                 LEFT JOIN
                 (  SELECT INVCODE, SALINVDET_CODE, SUM (CHGAMT) OTHER_CHARGE
                      FROM SALINVCHG_ITEM
                     WHERE ISTAX = 'N'
                  GROUP BY INVCODE, SALINVDET_CODE) OTX
                    ON D.INVCODE = OTX.INVCODE AND D.CODE = OTX.SALINVDET_CODE
           WHERE M.SALETYPE = 'O'
           and M.invdt::DATE between TO_DATE('@DTFR@','YYYY-MM-DD') and TO_DATE('@DTTO@','YYYY-MM-DD')
        GROUP BY AGCODE, PCODE
        UNION ALL
          SELECT AGCODE,
                 PCODE,
                 0                                    SALES_NETAMT,
                 0                                    SALES_OTHER_CHARGE,
                 0                                    SALES_TAXABLE_AMOUNT,
                 0                                    SALES_TAX_AMOUNT,
                   SUM (COALESCE (D.QTY, 0) * COALESCE (D.RATE, 0))
                 + SUM (COALESCE (TAX.TAX_AMOUNT, 0))
                 + SUM (COALESCE (OTX.OTHER_CHARGE, 0))
                    RETURN_NETAMT,
                 SUM (COALESCE (OTX.OTHER_CHARGE, 0)) RETURN_OTHER_CHARGE,
                 SUM (COALESCE (TAX.TAXABLE_AMOUNT, 0)) RETURN_TAXABLE_AMOUNT,
                 SUM (COALESCE (TAX.TAX_AMOUNT, 0))   RETURN_TAX_AMOUNT
            FROM SALRTMAIN M
                 INNER JOIN SALRTDET D ON M.RTCODE = D.RTCODE
                 LEFT JOIN (  SELECT RTCODE,
                                     SALRTDET_CODE,
                                     APPAMT                 TAXABLE_AMOUNT,
                                     SUM (COALESCE (CHGAMT, 0)) TAX_AMOUNT
                                FROM SALRTCHG_ITEM
                               WHERE ISTAX = 'Y'
                            GROUP BY RTCODE, SALRTDET_CODE, APPAMT) TAX
                    ON D.RTCODE = TAX.RTCODE AND D.CODE = TAX.SALRTDET_CODE
                 LEFT JOIN
                 (  SELECT RTCODE, SALRTDET_CODE, SUM (CHGAMT) OTHER_CHARGE
                      FROM SALRTCHG_ITEM
                     WHERE ISTAX = 'N'
                  GROUP BY RTCODE, SALRTDET_CODE) OTX
                    ON D.RTCODE = OTX.RTCODE AND D.CODE = OTX.SALRTDET_CODE
           WHERE M.SALETYPE = 'O'
           and M.rtdt::DATE between TO_DATE('@DTFR@','YYYY-MM-DD') and TO_DATE('@DTTO@','YYYY-MM-DD')
        GROUP BY AGCODE, PCODE)
GROUP BY AGCODE,PCODE