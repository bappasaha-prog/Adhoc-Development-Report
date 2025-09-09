/*|| Custom Development || Object : CQ_PENDING_INVOKICE || Ticket Id :  419937 || Developer : Dipankar ||*/

SELECT
       M.ENTRY_TYPE,
       M.DOCUMENT_TYPE,
       M.DOCUMENT_CODE INVCODE,
       M.DOCUMENT_DATE INVOICE_DATE,
       M.DISPLAY_DOCNO INVOICE_NO,
       M.SUB_LEDGER_CODE PCODE,
       M.AMOUNT,
       M.ADJUSTED,
       M.PENDING,
       M.overdue_days
  FROM V_ADJ M
       INNER JOIN (SELECT 'SIM'   ENTRY_TYPE,
                          INVCODE ENTCODE,
                          PCODE,
                          TIME
                     FROM SALINVMAIN
                    WHERE SALETYPE = 'O'
                   UNION
                   SELECT 'SRM'  ENTRY_TYPE,
                          RTCODE ENTCODE,
                          PCODE,
                          TIME
                     FROM SALRTMAIN
                    WHERE SALETYPE = 'O') A
          ON     M.ENTRY_TYPE = A.ENTRY_TYPE
             AND M.DOCUMENT_CODE = A.ENTCODE::TEXT
             AND M.SUB_LEDGER_CODE = A.PCODE
 WHERE M.PENDING <> 0
 AND      A.TIME < (SELECT TIME FROM salinvmain
                                  WHERE ( invcode::text IN (select
										unnest(regexp_matches('@DocumentId@',
										'[^|~|]+',
										'g')) as col1)
										or coalesce (nullif ('@DocumentId@',
										''),
										'0')::text = 0::text))
                         AND M.SUB_LEDGER_CODE IN
                                (SELECT pcode
                                   FROM salinvmain
                                  WHERE (invcode::text IN ( select
										unnest(regexp_matches('@DocumentId@',
										'[^|~|]+',
										'g')) as col1)
										or coalesce (nullif ('@DocumentId@',
										''),
										'0')::text = 0::text))
                         AND M.YEAR =
                                (SELECT ycode
                                   FROM admyear
                                  WHERE ycode =
                                           (SELECT ycode
                                              FROM salinvmain
                                             WHERE (invcode::text IN (select
										unnest(regexp_matches('@DocumentId@',
										'[^|~|]+',
										'g')) as col1)
										or coalesce (nullif ('@DocumentId@',
										''),
										'0')::text = 0::text)))