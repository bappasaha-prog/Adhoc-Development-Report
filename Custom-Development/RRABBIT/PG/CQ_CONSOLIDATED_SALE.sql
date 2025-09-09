/*|| Custom Development || Object : CQ_CONSOLIDATED_SALE || Ticket Id :  412283 || Developer : Dipankar ||*/
  SELECT GINVIEW.FNC_UK ()    UK,
         F.ENTRY_TYPE,
         F.SITE_CODE,
         F.PCODE,
         F.ICODE,
         F.CLASS_NAME,
         F.INVOICE_DATE,
         F.INVOICE_NO,
         F.TRADEGRP,
         F.DOCUMENT_NO,
         F.COSTRATE,
         F.INVOICE_RATE,
         F.TAX_RATE,
         SUM (F.TAXABLE_AMOUNT) TAXABLE_AMOUNT,
         SUM (F.NETAMT)       NETAMT,
         SUM (F.TAXAMT)       TAXAMT,
         SUM (F.QTY)          QTY,
         SUM (F.COST_AMOUNT)  COST_AMOUNT
    FROM (  SELECT 'B2B'                   ENTRY_TYPE,
                   M.ADMSITE_CODE_OWNER    SITE_CODE,
                   M.PCODE,
                   D.ICODE,
                   S.CLSNAME               CLASS_NAME,
                   M.INVDT                 INVOICE_DATE,
                   M.SCHEME_DOCNO          INVOICE_NO,
                   T.NAME                  TRADEGRP,
                   M.DOCNO                 DOCUMENT_NO,
                   D.COSTRATE,
                   D.RATE                  INVOICE_RATE,
                   ROUND (TAX.ITEM_TAX_RATE) TAX_RATE,
                   SUM (TAX.TAXABLE_AMOUNT) TAXABLE_AMOUNT,
                   SUM (
                        (COALESCE (D.INVAMT, 0) + COALESCE (D.CHGAMT, 0))
                      + COALESCE (D.TAXAMT, 0))
                      NETAMT,
                   SUM (D.TAXAMT)          TAXAMT,
                   SUM (D.INVQTY)          QTY,
                   SUM (D.COSTRATE * D.INVQTY) COST_AMOUNT
              FROM SALINVMAIN M
                   INNER JOIN SALINVDET D ON M.INVCODE = D.INVCODE
                   LEFT JOIN FINSL C ON M.PCODE = C.SLCODE
                   LEFT JOIN ADMCLS S ON C.CLSCODE = S.CLSCODE
                   LEFT JOIN FINTRADEGRP T ON M.SALTRADEGRP_CODE = T.CODE
                   LEFT OUTER JOIN
                   (  SELECT SALINVDET_CODE,
                             APPAMT             TAXABLE_AMOUNT,
                             SUM (COALESCE (RATE, 0)) ITEM_TAX_RATE
                        FROM SALINVCHG_ITEM
                       WHERE ISTAX = 'Y'
                    GROUP BY SALINVDET_CODE, APPAMT) TAX
                      ON (D.CODE = TAX.SALINVDET_CODE)
             WHERE     M.SALETYPE = 'O'
                   AND M.INVDT::date BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                           AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
          GROUP BY M.ADMSITE_CODE_OWNER,
                   M.PCODE,
                   D.ICODE,
                   S.CLSNAME,
                   M.INVDT,
                   M.SCHEME_DOCNO,
                   T.NAME,
                   M.DOCNO,
                   D.COSTRATE,
                   D.RATE,
                   ROUND (TAX.ITEM_TAX_RATE)
          UNION ALL
            SELECT 'CDN',
                   M.ADMSITE_CODE_OWNER,
                   M.PCODE,
                   D.ICODE,
                   S.CLSNAME,
                   M.RTDT,
                   M.SCHEME_DOCNO,
                   T.NAME,
                   M.DOCNO,
                   D.COSTRATE,
                   D.RATE,
                   ROUND (TAX.ITEM_TAX_RATE),
                   SUM (TAX.TAXABLE_AMOUNT),
                     (  SUM (COALESCE (QTY, 0) * COALESCE (RATE, 0))
                      + SUM (COALESCE (TAX_CHARGE_AMOUNT, 0)))
                   + SUM (COALESCE (OTHER_CHARGE_AMOUNT, 0)),
                   SUM (TAX.TAX_CHARGE_AMOUNT),
                   SUM (D.QTY),
                   SUM (D.COSTRATE * D.QTY)
              FROM SALRTMAIN M
                   INNER JOIN SALRTDET D ON M.RTCODE = D.RTCODE
                   INNER JOIN FINSL C ON M.PCODE = C.SLCODE
                   INNER JOIN ADMCLS S ON C.CLSCODE = S.CLSCODE
                   LEFT JOIN FINTRADEGRP T ON M.SALTRADEGRP_CODE = T.CODE
                   LEFT OUTER JOIN
                   (  SELECT RTCODE,
                             SALRTDET_CODE,
                             APPAMT               TAXABLE_AMOUNT,
                             SUM (COALESCE (RATE, 0)) ITEM_TAX_RATE,
                             SUM (COALESCE (CHGAMT, 0)) TAX_CHARGE_AMOUNT
                        FROM SALRTCHG_ITEM
                       WHERE ISTAX = 'Y'
                    GROUP BY RTCODE, SALRTDET_CODE, APPAMT) TAX
                      ON (D.RTCODE = TAX.RTCODE AND D.CODE = TAX.SALRTDET_CODE)
                   LEFT OUTER JOIN
                   (  SELECT RTCODE,
                             SALRTDET_CODE,
                             SUM (COALESCE (CHGAMT, 0)) OTHER_CHARGE_AMOUNT
                        FROM SALRTCHG_ITEM
                       WHERE ISTAX = 'N'
                    GROUP BY RTCODE, SALRTDET_CODE) OTX
                      ON (D.RTCODE = OTX.RTCODE AND D.CODE = OTX.SALRTDET_CODE)
             WHERE     M.SALETYPE = 'O'
                   AND M.RTDT::date BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                          AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
          GROUP BY M.ADMSITE_CODE_OWNER,
                   M.PCODE,
                   D.ICODE,
                   S.CLSNAME,
                   M.RTDT,
                   M.SCHEME_DOCNO,
                   T.NAME,
                   M.DOCNO,
                   D.COSTRATE,
                   D.RATE,
                   ROUND (TAX.ITEM_TAX_RATE)
          UNION ALL
            SELECT 'B2C',
                   M.ADMSITE_CODE,
                   9999999999,
                   D.ICODE,
                   C.SLNAME,
                   M.CSDATE,
                   M.SCHEME_DOCNO,
                   T.NAME,
                   M.GST_DOC_NO,
                   D.COSTRATE,
                   D.RATE,
                   ROUND (D.CGSTAMT + D.SGSTRATE + D.IGSTRATE),
                   SUM (D.TAXABLEAMT),
                   SUM (D.NETAMT),
                   SUM (D.TAXAMT),
                   SUM (D.QTY),
                   SUM (D.COSTRATE * D.QTY)
              FROM SALCSMAIN M
                   LEFT JOIN SALCSDET D ON M.CSCODE = D.CSCODE
                   LEFT JOIN FINSL C ON M.PCODE = C.SLCODE
                   LEFT JOIN FINTRADEGRP T ON M.FINTRADEGRP_CODE = T.CODE
             WHERE M.CSDATE::date BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                        AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
          GROUP BY M.ADMSITE_CODE,
                   D.ICODE,
                   C.SLNAME,
                   M.CSDATE,
                   M.SCHEME_DOCNO,
                   T.NAME,
                   M.GST_DOC_NO,
                   D.COSTRATE,
                   D.RATE,
                   ROUND (D.CGSTAMT + D.SGSTRATE + D.IGSTRATE)
          UNION ALL
            SELECT 'B2C',
                   M.ADMSITE_CODE,
                   9999999999,
                   D.ICODE,
                   C.SLNAME,
                   M.SSDATE,
                   M.SCHEME_DOCNO,
                   T.NAME,
                   NULL ,
                   D.COSTRATE,
                   D.RATE,
                   ROUND (D.CGSTAMT + D.SGSTRATE + D.IGSTRATE),
                   SUM (D.TAXABLEAMT),
                   SUM (D.NETAMT),
                   SUM (D.TAXAMT),
                   SUM (D.QTY),
                   SUM (D.COSTRATE * D.QTY)
              FROM SALSSMAIN M
                   LEFT JOIN SALSSDET D ON M.SSCODE = D.SSCODE
                   LEFT JOIN FINSL C ON M.PCODE = C.SLCODE
                   LEFT JOIN FINTRADEGRP T ON M.FINTRADEGRP_CODE = T.CODE
             WHERE M.SSDATE::date BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                        AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
          GROUP BY M.ADMSITE_CODE,
                   D.ICODE,
                   C.SLNAME,
                   M.SSDATE,
                   M.SCHEME_DOCNO,
                   T.NAME,
                   D.COSTRATE,
                   D.RATE,
                   ROUND (D.CGSTAMT + D.SGSTRATE + D.IGSTRATE)) F
GROUP BY F.ENTRY_TYPE,
         F.SITE_CODE,
         F.PCODE,
         F.ICODE,
         F.CLASS_NAME,
         F.INVOICE_DATE,
         F.INVOICE_NO,
         F.TRADEGRP,
         F.DOCUMENT_NO,
         F.COSTRATE,
         F.INVOICE_RATE,
         F.TAX_RATE