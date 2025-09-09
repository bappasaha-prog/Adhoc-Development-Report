/*|| Custom Development || Object : CQ_CUSTOMER_HISTORY || Ticket Id : 420478 || Developer : Dipankar ||*/

WITH CYCODE
     AS (SELECT YCODE
           FROM ADMYEAR
          WHERE TO_DATE ('@ASON@', 'YYYY-MM-DD') BETWEEN DTFR AND DTTO),
     LYCODE
     AS (SELECT YCODE
           FROM ADMYEAR
          WHERE ADD_MONTHS (TO_DATE ('@ASON@', 'YYYY-MM-DD'), -12) BETWEEN DTFR
                                                                       AND DTTO)
SELECT GINVIEW.FNC_UK ()             UK,
       P.CODE,
       P.NAME                        CUSTOMER_NAME,
       P.CREDIT_DAYS,
         ROUND (
            (CASE
                WHEN COALESCE (A.SALES_INVOICE, 0) = 0
                THEN
                   0
                ELSE
                     COALESCE (B.SALES_RETURN, 0)
                   / COALESCE (A.SALES_INVOICE, 0)
             END),
            2)
       * 100
          GR_CURRENT_YEAR,
         ROUND (
            (CASE
                WHEN COALESCE (A.SALES_INVOICE_LAST, 0) = 0
                THEN
                   0
                ELSE
                     COALESCE (B.SALES_RETURN_LAST, 0)
                   / COALESCE (A.SALES_INVOICE_LAST, 0)
             END),
            2)
       * 100
          GR_LAST_YEAR,
       C.NO_OF_DAYS                  AVG_PAY_DAYS,
       COALESCE (B.SALES_RETURN, 0)  SALES_RETURN,
       COALESCE (A.SALES_INVOICE, 0) SALES_INVOICE,
       GINVIEW.ERPBALANCE (
          'SL',
          P.CODE,
          TO_DATE ('@ASON@', 'YYYY-MM-DD'),
          (SELECT YNAME
             FROM ADMYEAR
            WHERE TO_DATE ('@ASON@', 'YYYY-MM-DD') BETWEEN DTFR AND DTTO),
          NULL,
          TO_NUMBER (NULLIF ('1', ''), '9G999g999999999999d99'))
          OUTSANDING,
       P.CREDIT_LIMIT,
       A.LAST_SALE_DATE,
       B.LAST_RETURN_DATE,
       D.LAST_PAYMENT_FDATE
  FROM GINVIEW.LV_CUSTOMER_SUPPLIER P
       LEFT JOIN
       (  SELECT M.PCODE,
                 SUM (
                    CASE
                       WHEN M.YCODE = (SELECT YCODE FROM CYCODE) THEN M.NETAMT
                       ELSE 0
                    END)
                    SALES_INVOICE,
                 SUM (
                    CASE
                       WHEN M.YCODE = (SELECT YCODE FROM LYCODE) THEN M.NETAMT
                       ELSE 0
                    END)
                    SALES_INVOICE_LAST,
                 MAX (TRUNC (M.INVDT)) LAST_SALE_DATE
            FROM SALINVMAIN M
           WHERE     M.SALETYPE = 'O'
                 AND M.YCODE BETWEEN (SELECT YCODE
                                        FROM LYCODE)
                                 AND (SELECT YCODE
                                        FROM CYCODE)
        GROUP BY M.PCODE) A
          ON P.CODE = A.PCODE
       LEFT JOIN
       (  SELECT M.PCODE,
                 SUM (
                    CASE
                       WHEN M.YCODE = (SELECT YCODE FROM CYCODE) THEN M.NETAMT
                       ELSE 0
                    END)
                    SALES_RETURN,
                 SUM (
                    CASE
                       WHEN M.YCODE = (SELECT YCODE FROM LYCODE) THEN M.NETAMT
                       ELSE 0
                    END)
                    SALES_RETURN_LAST,
                 MAX (TRUNC (M.RTDT)) LAST_RETURN_DATE
            FROM SALRTMAIN M
           WHERE     M.SALETYPE = 'O'
                 AND M.YCODE BETWEEN (SELECT YCODE
                                        FROM LYCODE)
                                 AND (SELECT YCODE
                                        FROM CYCODE)
        GROUP BY M.PCODE) B
          ON P.CODE = B.PCODE
       LEFT JOIN
       (  SELECT B.SUB_LEDGER_CODE PCODE,
                 CEIL (
                      SUM (
                         (ABS (A.RECEIPT_DT - B.DOCUMENT_DATE) * ABS (A.AMOUNT)))
                    / SUM (ABS (A.AMOUNT)))
                    NO_OF_DAYS
            FROM (SELECT POSTCODE1          POSTING_CODE,
                         ENTDT             RECEIPT_DT,
                         COALESCE (AMOUNT, 0) AMOUNT
                    FROM FINTAG
                         INNER JOIN FINPOST
                            ON (POSTCODE2 = POSTCODE)
                  UNION ALL
                  SELECT POSTCODE2,
                         ENTDT,
                         COALESCE (AMOUNT, 0)
                    FROM FINTAG
                         INNER JOIN FINPOST
                            ON (POSTCODE1 = POSTCODE)) A
                 INNER JOIN
                 (SELECT A.DOCUMENT_DATE,
                         A.YEAR,
                         A.POSTING_CODE,
                         A.SUB_LEDGER_CODE
                    FROM V_ADJ A, (SELECT YCODE Y FROM CYCODE) B
                   WHERE     A.YEAR BETWEEN (B.Y - 2) AND B.Y
                         AND A.ENTRY_TYPE = 'VDP') B
                    ON (A.POSTING_CODE = B.POSTING_CODE)
                 INNER JOIN ADMYEAR ON (B.YEAR = ADMYEAR.YCODE)
        GROUP BY B.SUB_LEDGER_CODE) C
          ON P.CODE = C.PCODE
       LEFT JOIN
       (  SELECT M.ARAP_SLCODE PCODE, MAX (M.VOUCHER_DATE) LAST_PAYMENT_FDATE
            FROM GINVIEW.LV_AR_VOUCHER M
           WHERE     M.YEAR_NAME = (SELECT YNAME
                                      FROM ADMYEAR
                                     WHERE YCODE = (SELECT YCODE FROM CYCODE))
        GROUP BY M.ARAP_SLCODE) D
          ON P.CODE = D.PCODE