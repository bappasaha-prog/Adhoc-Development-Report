/* Formatted on 08/07/2022 11:44:03 (QP5 v5.294) */
/*Start Changes Bug 107129*/
/*Bill Wise Outstanding*/
/*CQ_BILLWISE_OUTSTANDING_01*/
/*Ticket : 407700*/

SELECT tab1.*,
       ag.slname   agent_name,
       gl.glname,
       os.SHRTNAME admsite_name,
       rs.SHRTNAME refsite_name
  /*End Changes Bug 107129*/
  FROM (SELECT *
          FROM (SELECT NULL                                 datasetid,
                       ROW_NUMBER () OVER (ORDER BY slcode) uk,
                       due_date_basis,
                       crdays                               credit_days,
                       slcode,
                       glcode,
                       agcode                               agent_code,
                       agrate                               agent_rate_doc,
                       admou_code,
                       created_sitecode
                          admsite_code_owner,
                       sitecode                             ref_admsite_code,
                       entcode                              entry_code,
                       entno                                document_no,
                       entdt                                document_date,
                       docno                                ref_document_no,
                       docdt                                ref_document_date,
                       duedt                                due_date,
                       entname                              document_type,
                       amount                               amount,
                       adjusted                             adjusted_amount,
                       pending                              balance_amount,
                       running_pending_amount,
                       COALESCE (NULLIF ('@OutstandingAgeDayBasis@', ''),
                                 '-1')
                          outstanding_basis,
                       outstanding_age,
                       slab_name
                          outstanding_age_slab,
                       gst_taxable_amount,
                       cgst_tax_amount,
                       sgst_tax_amount,
                       igst_tax_amount,
                       cess_amount,
                       total_gst_amount,
                       group1,
                       group2,
                       group3,
                       group4,
                       lvl,
                       cheq_no,
                       cheq_date,
                       chque_type,
                       chque_drawn_on,
                       chque_reference,
                       cheque_amount,
                       remarks,
                       doc_ref_date,
                        (nullif('@FinIncludeUnpostedRecords@',''))::int
                          IncludeZeroFlag,
                       nullif('@ShowPendingAboveValue@','')::int
                          showpendingaboveamt
                  FROM (SELECT due_date_basis,
                               crdays,
                               slcode,
                               glcode,
                               agcode,
                               agrate,
                               admou_code,
                               created_sitecode,
                               sitecode,
                               entcode,
                               entno,
                               entdt,
                               docno,
                               docdt,
                               duedt,
                               entname,
                               amount,
                               adjusted,
                               pending,
                               running_pending_amount,
                               COALESCE (
                                  NULLIF ('@OutstandingAgeDayBasis@', ''),
                                  '-1'),
                               outstanding_age,
                               (SELECT    LPAD (slab_day_from::text,
                                                3,
                                                '0')
                                       || '#'
                                       || slab_name
                                  FROM findoc_age_slab
                                 WHERE outstanding_age BETWEEN slab_day_from
                                                           AND slab_day_to)
                                  slab_name,
                               gst_taxable_amount,
                               cgst_tax_amount,
                               sgst_tax_amount,
                               igst_tax_amount,
                               cess_amount,
                               total_gst_amount,
                               group1,
                               group2,
                               group3,
                               group4,
                               lvl,
                               cheq_no,
                               cheq_date,
                               chque_type,
                               chque_drawn_on,
                               chque_reference,
                               cheque_amount,
                               remarks,
                               doc_ref_date
                          FROM (  SELECT case coalesce (sl.DUE_DATE_BASIS, 'E') when 
                                          'E' then 'ENTRY DATE' when
                                          'D' then 'DOCUMENT DATE' end    due_date_basis,
                                         sl.crdays,
                                         sl.slcode,
                                         aj.general_ledger_code glcode,
                                         CASE COALESCE (
                                                 NULLIF ('@AgentSource@', ''),
                                                 'M')
                                            WHEN 'T'
                                            THEN
                                               COALESCE (ag.agcode, sl.agcode)
                                            WHEN 'M'
                                            THEN
                                               sl.agcode
                                         END
                                            agcode,
                                         sl.agrate,
                                         aj.admou_code,
                                         aj.admsite_code_owner
                                            created_sitecode,
                                         aj.ref_admsite_code  sitecode,
                                         aj.document_code     entcode,
                                         display_docno        entno,
                                         aj.document_date     entdt,
                                         ref_no               docno,
                                         ref_dt               docdt,
                                         due_dt               duedt,
                                         aj.document_type     entname,
                                         SUM (
                                            CASE drcr
                                               WHEN 'Dr'
                                               THEN
                                                  COALESCE (amount, 0)
                                               WHEN 'Cr'
                                               THEN
                                                  0 - COALESCE (amount, 0)
                                            END)
                                            amount,
                                         SUM (
                                            CASE
                                               WHEN drcr = 'Dr'
                                               THEN
                                                  CASE
                                                     WHEN COALESCE (
                                                             detail_receipt_amt,
                                                             0) <= 0
                                                     THEN
                                                        COALESCE (
                                                           detail_receipt_amt,
                                                           0)
                                                     ELSE
                                                          0
                                                        - COALESCE (
                                                             detail_receipt_amt,
                                                             0)
                                                  END
                                               ELSE
                                                  CASE
                                                     WHEN COALESCE (
                                                             detail_receipt_amt,
                                                             0) <= 0
                                                     THEN
                                                          0
                                                        - COALESCE (
                                                             detail_receipt_amt,
                                                             0)
                                                     ELSE
                                                        COALESCE (
                                                           detail_receipt_amt,
                                                           0)
                                                  END
                                            END)
                                            adjusted,
                                           (SUM (
                                               CASE DRCR
                                                  WHEN 'Dr'
                                                  THEN
                                                     COALESCE (AMOUNT, 0)
                                                  WHEN 'Cr'
                                                  THEN
                                                     0 - COALESCE (AMOUNT, 0)
                                               END))
                                         + SUM (
                                              CASE
                                                 WHEN DRCR = 'Dr'
                                                 THEN
                                                    CASE
                                                       WHEN COALESCE (
                                                               DETAIL_RECEIPT_AMT,
                                                               0) <= 0
                                                       THEN
                                                          COALESCE (
                                                             DETAIL_RECEIPT_AMT,
                                                             0)
                                                       ELSE
                                                            0
                                                          - COALESCE (
                                                               DETAIL_RECEIPT_AMT,
                                                               0)
                                                    END
                                                 ELSE
                                                    CASE
                                                       WHEN COALESCE (
                                                               DETAIL_RECEIPT_AMT,
                                                               0) <= 0
                                                       THEN
                                                            0
                                                          - COALESCE (
                                                               DETAIL_RECEIPT_AMT,
                                                               0)
                                                       ELSE
                                                          COALESCE (
                                                             DETAIL_RECEIPT_AMT,
                                                             0)
                                                    END
                                              END)
                                            PENDING,
                                         NULL
                                            running_pending_amount,
                                         ROUND (
                                              TO_DATE ('@ASON@', 'yyyy-mm-dd')
                                            - (CASE COALESCE (
                                                       NULLIF (
                                                          '@OutstandingAgeDayBasis@',
                                                          ''),
                                                       '-1')
                                                  WHEN '3DOC'
                                                  THEN
                                                     aj.document_date::date
                                                  WHEN '2DUE'
                                                  THEN
                                                     aj.due_dt::date
                                                  WHEN '4REF'
                                                  THEN
                                                     COALESCE (
                                                        aj.ref_dt::date,
                                                        aj.document_date::date)
                                                  WHEN '1VND'
                                                  THEN
                                                     CASE sl.due_date_basis
                                                        WHEN 'E'
                                                        THEN
                                                           aj.document_date::date
                                                        ELSE
                                                           COALESCE (
                                                              aj.ref_dt,
                                                              aj.document_date)::date
                                                     END
                                               END))
                                            outstanding_age,
                                         SUM (taxable_amount)
                                            gst_taxable_amount,
                                         SUM (cgst_amount)    cgst_tax_amount,
                                         SUM (sgst_amount)    sgst_tax_amount,
                                         SUM (igst_amount)    igst_tax_amount,
                                         SUM (cess_amount)    cess_amount,
                                           SUM (cgst_amount)
                                         + SUM (sgst_amount)
                                         + SUM (igst_amount)
                                         + SUM (cess_amount)
                                            total_gst_amount,
                                         CASE
                                            WHEN nullif('@ShowAgent@','')::int =
                                                    1
                                            THEN
                                               CASE COALESCE (
                                                       NULLIF ('@AgentSource@',
                                                               ''),
                                                       'M')
                                                  WHEN 'T'
                                                  THEN
                                                     COALESCE (
                                                        COALESCE (ag.agname,
                                                                  ag1.slname),
                                                        'No Agent Defined in Document')
                                                  WHEN 'M'
                                                  THEN
                                                     COALESCE (
                                                        ag1.slname,
                                                        'No Agent Defined in Document')
                                               END
                                            ELSE
                                               'Do not show Agent'
                                         END
                                            group1,
                                         CASE
                                            WHEN  nullif('@ShowClassWise@','')::int =
                                                    1
                                            THEN
                                               ls.clsname
                                            ELSE
                                               'Do Not Show Class'
                                         END
                                            group2,
                                         sl.slname            group3,
                                         CASE
                                            WHEN '@DisplayType@' = 'D'
                                            THEN
                                               aj.document_type
                                            WHEN '@DisplayType@' = 'E'
                                            THEN
                                               'Date wise Display'
                                         END
                                            group4,
                                         1                    lvl,
                                         chqno                cheq_no,
                                         chqdt                cheq_date,
                                         CASE
                                            WHEN drcr = 'Dr' THEN 'Payment'
                                            ELSE 'Receipt'
                                         END
                                            chque_type,
                                         drawnon              chque_drawn_on,
                                         ref_no               chque_reference,
                                         SUM (amount)         cheque_amount,
                                         NULL                 remarks,
                                         CASE sl.due_date_basis
                                            WHEN 'E'
                                            THEN
                                               aj.document_date
                                            ELSE
                                               COALESCE (aj.ref_dt,
                                                         aj.document_date)
                                         END
                                            doc_ref_date
                                    FROM v_adj aj
                                         INNER JOIN finsl sl
                                            ON (    aj.sub_ledger_code =
                                                       sl.slcode
                                                AND (sl.slname|| '|'|| sl.slid IN (
    SELECT unnest(regexp_matches('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', '[^æ]+', 'g')) AS col1
    FROM generate_series(1, (SELECT count(*) FROM regexp_matches('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', 'æ', 'g'))+1) AS g
)
or COALESCE (NULLIF ('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', ''), '0')::text =0::text))
                                         INNER JOIN admcls ls
                                            ON (sl.clscode = ls.clscode)
                                         LEFT OUTER JOIN admcity ct
                                            ON (sl.bctname = ct.ctname)
                                         LEFT OUTER JOIN finsl ag1
                                            ON (sl.agcode = ag1.slcode)
                                         LEFT OUTER JOIN
                                         (  SELECT detail_post_code,
                                                   SUM (detail_receipt_amt)
                                                      detail_receipt_amt
                                              FROM (
                                              SELECT POSTCODE1 DETAIL_POST_CODE,
       CASE
          WHEN (ENTDT <= TO_DATE ('@ASON@', 'yyyy-mm-dd'))
          THEN
             (CASE
                 WHEN (ENTTYPE1 = 'VDP')
                 THEN
                    COALESCE (AMOUNT, 0)
                 ELSE
                    (CASE COALESCE (b.damount, 0)
                        WHEN 0 THEN (-AMOUNT)
                        ELSE AMOUNT
                     END)
              END)
          ELSE
             0
       END
          DETAIL_RECEIPT_AMT
  FROM FINTAG A
       INNER JOIN FINPOST B ON (POSTCODE2 = POSTCODE)
       INNER JOIN FINSL S ON (B.SLCODE = S.SLCODE)
       INNER JOIN ADMCLS CL ON (S.CLSCODE = CL.CLSCODE)     
                                                           Where (s.slname|| '|'|| s.slid IN (
    SELECT unnest(regexp_matches('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', '[^æ]+', 'g')) AS col1
    FROM generate_series(1, (SELECT count(*) FROM regexp_matches('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', 'æ', 'g'))+1) AS g
)
or COALESCE (NULLIF ('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', ''), '0')::text =0::text)
                                                           AND 1 =
                                                                  CASE
                                                                     WHEN     '@DocumentConsiderationDate@' =
                                                                                 'E'
                                                                          AND b.entdt <=
                                                                                 TO_DATE (
                                                                                    '@ASON@',
                                                                                    'yyyy-mm-dd')
                                                                     THEN
                                                                        1
                                                                     WHEN     '@DocumentConsiderationDate@' =
                                                                                 'D'
                                                                          AND CASE s.due_date_basis
                                                                                 WHEN 'E'
                                                                                 THEN
                                                                                    entdt
                                                                                 ELSE
                                                                                    COALESCE (
                                                                                       docdt,
                                                                                       entdt)
                                                                              END <=
                                                                                 TO_DATE (
                                                                                    '@ASON@',
                                                                                    'yyyy-mm-dd')
                                                                     THEN
                                                                        1
                                                                  END
                                                           AND ( coalesce(nullif('@ConnOUCode@',''),'-1')::bigint = -1
                                                 	or
                                                 	(coalesce(nullif('@ConnOUCode@',''),'-1')::bigint <> -1 and b.admou_code = coalesce(nullif('@ConnOUCode@',''),'-1')::bigint))
                                                           AND (   (
                                                                      nullif('@FinIncludeUnpostedRecords@',''))::int =
                                                                      1
                                                                OR (    (
                                                                      nullif('@FinIncludeUnpostedRecords@',''))::int =
                                                                           0
                                                                    AND b.release_status =
                                                                           'P'))
                                                           AND (   (    cl.clsname =
                                                                           COALESCE (
                                                                              NULLIF (
                                                                                 '@Class@',
                                                                                 ''),
                                                                              '-1')
                                                                    AND COALESCE (
                                                                           NULLIF (
                                                                              '@Class@',
                                                                              ''),
                                                                           '-1') <>
                                                                           '-1')
                                                                OR COALESCE (
                                                                      NULLIF (
                                                                         '@Class@',
                                                                         ''),
                                                                      '-1') =
                                                                      '-1')
                                                           AND (   (    s.agcode =
                                                                              COALESCE (
                                                                                 NULLIF (
                                                                                    '@Agent@',
                                                                                    ''),
                                                                                 '-1')::int
                                                                    AND COALESCE (
                                                                              NULLIF (
                                                                                 '@Agent@',
                                                                                 ''),
                                                                              '-1')::int <>
                                                                           -1)
                                                                OR COALESCE (
                                                                         NULLIF (
                                                                            '@Agent@',
                                                                            ''),
                                                                         '-1')::int =
                                                                      -1)
                                                           AND (   (    b.glcode =
                                                                           COALESCE (
                                                                                 NULLIF (
                                                                                    '@ARAPLedger@',
                                                                                    ''),
                                                                                 '-1')::int
                                                                    AND COALESCE (
                                                                              NULLIF (
                                                                                 '@ARAPLedger@',
                                                                                 ''),
                                                                              '-1')::int <>
                                                                           -1)
                                                                OR COALESCE (
                                                                         NULLIF (
                                                                            '@ARAPLedger@',
                                                                            ''),
                                                                         '-1')::int =
                                                                      -1)
                                                    UNION ALL
                                                    SELECT POSTCODE2 DETAIL_POST_CODE,
       CASE
          WHEN (ENTDT <= TO_DATE ('@ASON@', 'yyyy-mm-dd'))
          THEN
             (CASE
                 WHEN (ENTTYPE2 = 'VDP')
                 THEN
                    ABS (COALESCE (AMOUNT, 0))
                 ELSE
                    (CASE COALESCE (b.damount, 0)
                        WHEN 0 THEN (-AMOUNT)
                        ELSE AMOUNT
                     END)
              END)
          ELSE
             0
       END
          DETAIL_RECEIPT_AMT
  FROM FINTAG A
       INNER JOIN FINPOST B ON (POSTCODE1 = POSTCODE)
       INNER JOIN FINSL S ON (B.SLCODE = S.SLCODE)
       INNER JOIN ADMCLS CL ON (S.CLSCODE = CL.CLSCODE)     
                                                           Where (s.slname|| '|'|| s.slid IN (
    SELECT unnest(regexp_matches('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', '[^æ]+', 'g')) AS col1
    FROM generate_series(1, (SELECT count(*) FROM regexp_matches('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', 'æ', 'g'))+1) AS g
)
or COALESCE (NULLIF ('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', ''), '0')::text =0::text)
                                                           AND 1 =
                                                                  CASE
                                                                     WHEN     '@DocumentConsiderationDate@' =
                                                                                 'E'
                                                                          AND b.entdt <=
                                                                                 TO_DATE (
                                                                                    '@ASON@',
                                                                                    'yyyy-mm-dd')
                                                                     THEN
                                                                        1
                                                                     WHEN     '@DocumentConsiderationDate@' =
                                                                                 'D'
                                                                          AND CASE s.due_date_basis
                                                                                 WHEN 'E'
                                                                                 THEN
                                                                                    entdt
                                                                                 ELSE
                                                                                    COALESCE (
                                                                                       docdt,
                                                                                       entdt)
                                                                              END <=
                                                                                 TO_DATE (
                                                                                    '@ASON@',
                                                                                    'yyyy-mm-dd')
                                                                     THEN
                                                                        1
                                                                  END
                                                           AND ( coalesce(nullif('@ConnOUCode@',''),'-1')::bigint = -1
                                                 	or
                                                 	(coalesce(nullif('@ConnOUCode@',''),'-1')::bigint <> -1 and b.admou_code = coalesce(nullif('@ConnOUCode@',''),'-1')::bigint))
                                                           AND ((
                                                                      nullif('@FinIncludeUnpostedRecords@',''))::int =
                                                                      1
                                                                OR (    (
                                                                      nullif('@FinIncludeUnpostedRecords@',''))::int =
                                                                           0
                                                                    AND b.release_status =
                                                                           'P'))
                                                           AND (   (    cl.clsname =
                                                                           COALESCE (
                                                                              NULLIF (
                                                                                 '@Class@',
                                                                                 ''),
                                                                              '-1')
                                                                    AND COALESCE (
                                                                           NULLIF (
                                                                              '@Class@',
                                                                              ''),
                                                                           '-1') <>
                                                                           '-1')
                                                                OR COALESCE (
                                                                      NULLIF (
                                                                         '@Class@',
                                                                         ''),
                                                                      '-1') =
                                                                      '-1')
                                                           AND (   (    s.agcode = COALESCE (
                                                                                 NULLIF (
                                                                                    '@Agent@',
                                                                                    ''),
                                                                                 '-1')::int
                                                                    AND COALESCE (
                                                                              NULLIF (
                                                                                 '@Agent@',
                                                                                 ''),
                                                                              '-1')::int <>
                                                                           -1)
                                                                OR COALESCE (
                                                                         NULLIF (
                                                                            '@Agent@',
                                                                            ''),
                                                                         '-1')::int =
                                                                      -1)
                                                           AND (   (    b.glcode =
                                                                            COALESCE (
                                                                                 NULLIF (
                                                                                    '@ARAPLedger@',
                                                                                    ''),
                                                                                 '-1')::int
                                                                    AND COALESCE (
                                                                              NULLIF (
                                                                                 '@ARAPLedger@',
                                                                                 ''),
                                                                              '-1')::int <>
                                                                           -1)
                                                                OR COALESCE (
                                                                         NULLIF (
                                                                            '@ARAPLedger@',
                                                                            ''),
                                                                         '-1')::int =
                                                                      -1)) T1
                                          GROUP BY detail_post_code) adjustment
                                            ON (aj.posting_code =
                                                   adjustment.detail_post_code)
                                         LEFT OUTER JOIN
                                         (  SELECT invcode::text entcode,
                                                   SUM (taxable_amount)
                                                      taxable_amount,
                                                   SUM (cgst_amount) cgst_amount,
                                                   SUM (sgst_amount) sgst_amount,
                                                   SUM (igst_amount) igst_amount,
                                                   SUM (cess_amount) cess_amount
                                              FROM (  SELECT invcode,
                                                             salinvdet_code,
                                                             appamt taxable_amount,
                                                             SUM (
                                                                CASE
                                                                   WHEN gst_component =
                                                                           'CGST'
                                                                   THEN
                                                                      chgamt
                                                                   ELSE
                                                                      0
                                                                END)
                                                                cgst_amount,
                                                             SUM (
                                                                CASE
                                                                   WHEN gst_component =
                                                                           'SGST'
                                                                   THEN
                                                                      chgamt
                                                                   ELSE
                                                                      0
                                                                END)
                                                                sgst_amount,
                                                             SUM (
                                                                CASE
                                                                   WHEN gst_component =
                                                                           'IGST'
                                                                   THEN
                                                                      chgamt
                                                                   ELSE
                                                                      0
                                                                END)
                                                                igst_amount,
                                                             SUM (
                                                                CASE
                                                                   WHEN gst_component =
                                                                           'CESS'
                                                                   THEN
                                                                      chgamt
                                                                   ELSE
                                                                      0
                                                                END)
                                                                cess_amount
                                                        FROM salinvchg_item
                                                       WHERE     source = 'G'
                                                             AND nullif('@ShowTaxableAmount@','')::int =
                                                                    1
                                                    GROUP BY invcode,
                                                             salinvdet_code,
                                                             appamt) T2
                                          GROUP BY invcode::text
                                          UNION ALL
                                            SELECT rtcode::text,
                                                   SUM (taxable_amount)
                                                      taxable_amount,
                                                   SUM (cgst_amount) cgst_amount,
                                                   SUM (sgst_amount) sgst_amount,
                                                   SUM (igst_amount) igst_amount,
                                                   SUM (cess_amount) cess_amount
                                              FROM (  SELECT rtcode,
                                                             salrtdet_code,
                                                             appamt taxable_amount,
                                                             SUM (
                                                                CASE
                                                                   WHEN gst_component =
                                                                           'CGST'
                                                                   THEN
                                                                      chgamt
                                                                   ELSE
                                                                      0
                                                                END)
                                                                cgst_amount,
                                                             SUM (
                                                                CASE
                                                                   WHEN gst_component =
                                                                           'SGST'
                                                                   THEN
                                                                      chgamt
                                                                   ELSE
                                                                      0
                                                                END)
                                                                sgst_amount,
                                                             SUM (
                                                                CASE
                                                                   WHEN gst_component =
                                                                           'IGST'
                                                                   THEN
                                                                      chgamt
                                                                   ELSE
                                                                      0
                                                                END)
                                                                igst_amount,
                                                             SUM (
                                                                CASE
                                                                   WHEN gst_component =
                                                                           'CESS'
                                                                   THEN
                                                                      chgamt
                                                                   ELSE
                                                                      0
                                                                END)
                                                                cess_amount
                                                        FROM salrtchg_item
                                                       WHERE     source = 'G'
                                                             AND nullif('@ShowTaxableAmount@','')::int =
                                                                    1
                                                    GROUP BY rtcode,
                                                             salrtdet_code,
                                                             appamt) T3
                                          GROUP BY rtcode::text
                                          UNION ALL
                                            SELECT invcode::text,
                                                   SUM (taxable_amount)
                                                      taxable_amount,
                                                   SUM (cgst_amount) cgst_amount,
                                                   SUM (sgst_amount) sgst_amount,
                                                   SUM (igst_amount) igst_amount,
                                                   SUM (cess_amount) cess_amount
                                              FROM (  SELECT invcode,
                                                             purinvdet_code,
                                                             appamt taxable_amount,
                                                             SUM (
                                                                CASE
                                                                   WHEN     gst_component =
                                                                               'CGST'
                                                                        AND isreverse =
                                                                               'NO'
                                                                   THEN
                                                                      chgamt
                                                                   ELSE
                                                                      0
                                                                END)
                                                                cgst_amount,
                                                             SUM (
                                                                CASE
                                                                   WHEN     gst_component =
                                                                               'SGST'
                                                                        AND isreverse =
                                                                               'NO'
                                                                   THEN
                                                                      chgamt
                                                                   ELSE
                                                                      0
                                                                END)
                                                                sgst_amount,
                                                             SUM (
                                                                CASE
                                                                   WHEN     gst_component =
                                                                               'IGST'
                                                                        AND isreverse =
                                                                               'NO'
                                                                   THEN
                                                                      chgamt
                                                                   ELSE
                                                                      0
                                                                END)
                                                                igst_amount,
                                                             SUM (
                                                                CASE
                                                                   WHEN     gst_component =
                                                                               'CESS'
                                                                        AND isreverse =
                                                                               'NO'
                                                                   THEN
                                                                      chgamt
                                                                   ELSE
                                                                      0
                                                                END)
                                                                cess_amount
                                                        FROM purinvchg_item
                                                       WHERE     source = 'G'
                                                             AND nullif('@ShowTaxableAmount@','')::int =
                                                                    1
                                                    GROUP BY invcode,
                                                             purinvdet_code,
                                                             appamt) T4
                                          GROUP BY invcode::text
                                          UNION ALL
                                            SELECT rtcode::text,
                                                   SUM (taxable_amount)
                                                      taxable_amount,
                                                   SUM (cgst_amount) cgst_amount,
                                                   SUM (sgst_amount) sgst_amount,
                                                   SUM (igst_amount) igst_amount,
                                                   SUM (cess_amount) cess_amount
                                              FROM (  SELECT rtcode,
                                                             purrtdet_code,
                                                             appamt taxable_amount,
                                                             SUM (
                                                                CASE
                                                                   WHEN     gst_component =
                                                                               'CGST'
                                                                        AND isreverse =
                                                                               'NO'
                                                                   THEN
                                                                      chgamt
                                                                   ELSE
                                                                      0
                                                                END)
                                                                cgst_amount,
                                                             SUM (
                                                                CASE
                                                                   WHEN     gst_component =
                                                                               'SGST'
                                                                        AND isreverse =
                                                                               'NO'
                                                                   THEN
                                                                      chgamt
                                                                   ELSE
                                                                      0
                                                                END)
                                                                sgst_amount,
                                                             SUM (
                                                                CASE
                                                                   WHEN     gst_component =
                                                                               'IGST'
                                                                        AND isreverse =
                                                                               'NO'
                                                                   THEN
                                                                      chgamt
                                                                   ELSE
                                                                      0
                                                                END)
                                                                igst_amount,
                                                             SUM (
                                                                CASE
                                                                   WHEN     gst_component =
                                                                               'CESS'
                                                                        AND isreverse =
                                                                               'NO'
                                                                   THEN
                                                                      chgamt
                                                                   ELSE
                                                                      0
                                                                END)
                                                                cess_amount
                                                        FROM purrtchg_item
                                                       WHERE     source = 'G'
                                                             AND nullif('@ShowTaxableAmount@','')::int  =
                                                                    1
                                                    GROUP BY rtcode,
                                                             purrtdet_code,
                                                             appamt) T5
                                          GROUP BY rtcode::text
                                          UNION ALL
                                            SELECT srvcode::text,
                                                   SUM (taxable_amount)
                                                      taxable_amount,
                                                   SUM (cgst_amount) cgst_amount,
                                                   SUM (sgst_amount) sgst_amount,
                                                   SUM (igst_amount) igst_amount,
                                                   SUM (cess_amount) cess_amount
                                              FROM (  SELECT srvcode,
                                                             pursrvdet_code,
                                                             appamt taxable_amount,
                                                             SUM (
                                                                CASE
                                                                   WHEN     gst_component =
                                                                               'CGST'
                                                                        AND isreverse =
                                                                               'NO'
                                                                   THEN
                                                                      chgamt
                                                                   ELSE
                                                                      0
                                                                END)
                                                                cgst_amount,
                                                             SUM (
                                                                CASE
                                                                   WHEN     gst_component =
                                                                               'SGST'
                                                                        AND isreverse =
                                                                               'NO'
                                                                   THEN
                                                                      chgamt
                                                                   ELSE
                                                                      0
                                                                END)
                                                                sgst_amount,
                                                             SUM (
                                                                CASE
                                                                   WHEN     gst_component =
                                                                               'IGST'
                                                                        AND isreverse =
                                                                               'NO'
                                                                   THEN
                                                                      chgamt
                                                                   ELSE
                                                                      0
                                                                END)
                                                                igst_amount,
                                                             SUM (
                                                                CASE
                                                                   WHEN     gst_component =
                                                                               'CESS'
                                                                        AND isreverse =
                                                                               'NO'
                                                                   THEN
                                                                      chgamt
                                                                   ELSE
                                                                      0
                                                                END)
                                                                cess_amount
                                                        FROM pursrvchg_item
                                                       WHERE     source = 'G'
                                                             AND (nullif('@ShowTaxableAmount@',''))::int =
                                                                    1
                                                    GROUP BY srvcode,
                                                             pursrvdet_code,
                                                             appamt) T6
                                          GROUP BY srvcode::text) vtax
                                            ON (aj.document_code = vtax.entcode)
                                         LEFT OUTER JOIN
                                         (
                                         SELECT INVCODE::text ENTCODE, A.AGCODE, SLNAME AGNAME
  FROM SALINVMAIN A
       INNER JOIN FINSL S ON (A.AGCODE = S.SLCODE)
                                                 Where COALESCE (
                                                        NULLIF (
                                                           '@AgentSource@',
                                                           ''),
                                                        'M') = 'T'
                                          UNION ALL
                                          SELECT RTCODE::text ENTCODE, A.AGCODE, SLNAME AGNAME
  FROM SALRTMAIN A
       INNER JOIN FINSL S ON (A.AGCODE = S.SLCODE)
                                                 Where COALESCE (
                                                        NULLIF (
                                                           '@AgentSource@',
                                                           ''),
                                                        'M') = 'T'
                                          UNION ALL
                                          SELECT INVCODE::text ENTCODE, A.AGCODE, SLNAME AGNAME
  FROM PURINVMAIN A
       INNER JOIN FINSL S ON (A.AGCODE = S.SLCODE)
                                                 Where COALESCE (
                                                        NULLIF (
                                                           '@AgentSource@',
                                                           ''),
                                                        'M') = 'T'
                                          UNION ALL
                                          SELECT RTCODE::text ENTCODE, A.AGCODE, SLNAME AGNAME
  FROM PURRTMAIN A
       INNER JOIN FINSL S ON (A.AGCODE = S.SLCODE)
                                                 Where COALESCE (
                                                        NULLIF (
                                                           '@AgentSource@',
                                                           ''),
                                                        'M') = 'T'
                                          UNION ALL
                                          SELECT ENTCODE::text ENTCODE, A.AGCODE, SLNAME AGNAME
  FROM FINOPDOC A
       INNER JOIN FINSL S ON (A.AGCODE = s.SLCODE)
                                                 Where a.enttype IN ('SIM',
                                                                   'SRM',
                                                                   'PIM',
                                                                   'PRM')
                                                 AND COALESCE (
                                                        NULLIF (
                                                           '@AgentSource@',
                                                           ''),
                                                        'M') = 'T') ag
                                            ON (aj.document_code = ag.entcode)
                                   WHERE     1 =
                                                CASE
                                                   WHEN     '@DocumentConsiderationDate@' =
                                                               'E'
                                                        AND aj.document_date <=
                                                               TO_DATE (
                                                                  '@DocumentTillDate@',
                                                                  'yyyy-mm-dd')
                                                   THEN
                                                      1
                                                   WHEN     '@DocumentConsiderationDate@' =
                                                               'D'
                                                        AND CASE sl.due_date_basis
                                                               WHEN 'E'
                                                               THEN
                                                                  aj.document_date
                                                               ELSE
                                                                  COALESCE (
                                                                     aj.ref_dt,
                                                                     aj.document_date)
                                                            END <=
                                                               TO_DATE (
                                                                  '@DocumentTillDate@',
                                                                  'yyyy-mm-dd')
                                                   THEN
                                                      1
                                                END
                                         AND (   COALESCE (nullif('@City@',''), '-1') = '-1'
                                              OR (    COALESCE (nullif('@City@',''), '-1') <>
                                                         '-1'
                                                  AND ct.ctname = nullif('@City@','')))
                                         AND (   COALESCE (nullif('@District@',''), '-1') =
                                                    '-1'
                                              OR (    COALESCE (nullif('@District@',''), '-1') <>
                                                         '-1'
                                                  AND ct.dist = nullif('@District@','')))
                                         AND (   COALESCE (nullif('@State@',''), '-1') = '-1'
                                              OR (    COALESCE (nullif('@State@',''), '-1') <>
                                                         '-1'
                                                  AND ct.stname = nullif('@State@','')))
                                         AND ( coalesce(nullif('@ConnOUCode@',''),'-1')::bigint = -1
                                                 	or
                                                 	(coalesce(nullif('@ConnOUCode@',''),'-1')::bigint <> -1 and aj.admou_code = coalesce(nullif('@ConnOUCode@',''),'-1')::bigint))
                                         AND (   (
                                                    nullif('@FinIncludeUnpostedRecords@',''))::int =
                                                    1
                                              OR (    (
                                                         nullif('@FinIncludeUnpostedRecords@',''))::int =
                                                         0
                                                  AND aj.release_status =
                                                         'Posted'))
                                         AND aj.general_ledger_code IN
                                                (SELECT glcode
                                                   FROM fingl
                                                  WHERE srctype = 'R')
                                         AND (   (    ls.clsname =
                                                         COALESCE (
                                                            NULLIF ('@Class@',
                                                                    ''),
                                                            '-1')
                                                  AND COALESCE (
                                                         NULLIF ('@Class@', ''),
                                                         '-1') <> '-1')
                                              OR COALESCE (
                                                    NULLIF ('@Class@', ''),
                                                    '-1') = '-1')
                                         AND (   (    sl.agcode =
                                                         COALESCE (
                                                               NULLIF (
                                                                  '@Agent@',
                                                                  ''),
                                                               '-1')::int
                                                  AND COALESCE (
                                                            NULLIF ('@Agent@',
                                                                    ''),
                                                            '-1')::int <>
                                                         -1)
                                              OR COALESCE (
                                                       NULLIF ('@Agent@', ''),
                                                       '-1')::int =
                                                    -1)
                                         AND (   (    aj.general_ledger_code =
                                                         COALESCE (
                                                               NULLIF (
                                                                  '@ARAPLedger@',
                                                                  ''),
                                                               '-1')::int
                                                  AND COALESCE (
                                                            NULLIF (
                                                               '@ARAPLedger@',
                                                               ''),
                                                            '-1')::int <>
                                                         -1)
                                              OR COALESCE (
                                                       NULLIF ('@ARAPLedger@',
                                                               ''),
                                                       '-1')::int =
                                                    -1)
                                         AND (sl.slname|| '|'|| sl.slid IN (
    SELECT unnest(regexp_matches('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', '[^æ]+', 'g')) AS col1
    FROM generate_series(1, (SELECT count(*) FROM regexp_matches('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', 'æ', 'g'))+1) AS g
)
or COALESCE (NULLIF ('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', ''), '0')::text =0::text)
                                GROUP BY coalesce(sl.due_date_basis,'E'),
                                         sl.crdays,
                                         sl.slcode,
                                         aj.general_ledger_code,
                                         CASE COALESCE (
                                                 NULLIF ('@AgentSource@', ''),
                                                 'M')
                                            WHEN 'T'
                                            THEN
                                               COALESCE (ag.agcode,
                                                         sl.agcode)
                                            WHEN 'M'
                                            THEN
                                               sl.agcode
                                         END,
                                         sl.agrate,
                                         aj.admou_code,
                                         aj.admsite_code_owner,
                                         aj.ref_admsite_code,
                                         aj.document_code,
                                         display_docno,
                                         aj.document_date,
                                         ref_no,
                                         ref_dt,
                                         due_dt,
                                         aj.document_type,
                                         ROUND (
                                              TO_DATE ('@ASON@',
                                                       'yyyy-mm-dd')
                                            - (CASE COALESCE (
                                                       NULLIF (
                                                          '@OutstandingAgeDayBasis@',
                                                          ''),
                                                       '-1')
                                                  WHEN '3DOC'
                                                  THEN
                                                     aj.document_date::date
                                                  WHEN '2DUE'
                                                  THEN
                                                     aj.due_dt::date
                                                  WHEN '4REF'
                                                  THEN
                                                     COALESCE (
                                                        aj.ref_dt,
                                                        aj.document_date)::date
                                                  WHEN '1VND'
                                                  THEN
                                                     CASE sl.due_date_basis
                                                        WHEN 'E'
                                                        THEN
                                                           aj.document_date::date
                                                        ELSE
                                                           COALESCE (
                                                              aj.ref_dt,
                                                              aj.document_date)::date
                                                     END
                                               END)),
                                         CASE
                                            WHEN nullif('@ShowAgent@','')::int =
                                                    1
                                            THEN
                                               CASE COALESCE (
                                                       NULLIF (
                                                          '@AgentSource@',
                                                          ''),
                                                       'M')
                                                  WHEN 'T'
                                                  THEN
                                                     COALESCE (
                                                        COALESCE (ag.agname,
                                                                  ag1.slname),
                                                        'No Agent Defined in Document')
                                                  WHEN 'M'
                                                  THEN
                                                     COALESCE (
                                                        ag1.slname,
                                                        'No Agent Defined in Document')
                                               END
                                            ELSE
                                               'Do not show Agent'
                                         END,
                                         CASE
                                            WHEN nullif('@ShowClassWise@','')::int =
                                                    1
                                            THEN
                                               ls.clsname
                                            ELSE
                                               'Do Not Show Class'
                                         END,
                                         sl.slname,
                                         chqno,
                                         chqdt,
                                         CASE
                                            WHEN drcr = 'Dr' THEN 'Payment'
                                            ELSE 'Receipt'
                                         END,
                                         drawnon,
                                         ref_no,
                                         CASE sl.due_date_basis
                                            WHEN 'E'
                                            THEN
                                               aj.document_date
                                            ELSE
                                               COALESCE (aj.ref_dt,
                                                         aj.document_date)
                                         END
                                UNION ALL
                                  SELECT case coalesce (sl.DUE_DATE_BASIS, 'E') when 
                                          'E' then 'ENTRY DATE' when
                                          'D' then 'DOCUMENT DATE' end due_date_basis,
                                         sl.crdays,
                                         sl.slcode,
                                         gl.glcode,
                                         sl.agcode       agcode,
                                         sl.agrate       agrate,
                                         aj.admou_code,
                                         aj.admsite_code_owner,
                                         aj.ref_admsite_code,
                                         NULL            entcode,
                                         NULL            entno,
                                         NULL            entdt,
                                         NULL            docno,
                                         entdt           docdt,
                                         NULL            duedt,
                                         NULL            entname,
                                         NULL            amount,
                                         NULL            adjusted,
                                         NULL            pending,
                                         NULL::int
                                            running_pending_amount,
                                         NULL            outstanding_age,
                                         NULL            gst_taxable_amount,
                                         NULL            cgst_tax_amount,
                                         NULL            sgst_tax_amount,
                                         NULL            igst_tax_amount,
                                         NULL            cess_tax_amount,
                                         NULL            total_gst_amount,
                                         CASE
                                            WHEN nullif('@ShowAgent@','')::int =
                                                    1
                                            THEN
                                               COALESCE (
                                                  ag.slname,
                                                  'No Agent Defined in Document')
                                            ELSE
                                               'Do not show Agent'
                                         END
                                            group1,
                                         CASE
                                            WHEN nullif('@ShowClassWise@','')::int =
                                                    1
                                            THEN
                                               ls.clsname
                                            ELSE
                                               'Do Not Show Class'
                                         END
                                            group2,
                                         sl.slname       group3,
                                         'Not to Show'   group4,
                                         2               lvl,
                                         chqno           cheq_no,
                                         chqdt           cheq_date,
                                         CASE COALESCE (camount, 0)
                                            WHEN 0 THEN 'Payment'
                                            ELSE 'Receipt'
                                         END
                                            chque_type,
                                         drawnon         chque_drawn_on,
                                         docno           chque_reference,
                                         SUM (damount) - SUM (camount)
                                            cheque_amount,
                                         NULL            remarks,
                                         NULL            doc_ref_date
                                    FROM finpost aj
                                         JOIN finsl sl
                                            ON (aj.slcode = sl.slcode)
                                         JOIN fingl gl
                                            ON (aj.glcode = gl.glcode)
                                         JOIN admcls ls
                                            ON (sl.clscode = ls.clscode)
                                         LEFT OUTER JOIN finsl ag
                                            ON (sl.agcode = ag.slcode)
                                         LEFT OUTER JOIN admcity ct
                                            ON (sl.bctname = ct.ctname)
                                   WHERE     (   gl.glcode IS NULL
                                              OR gl.srctype = 'R')
                                         AND aj.chqdt >
                                                TO_DATE ('@ASON@',
                                                         'yyyy-mm-dd')
                                         AND aj.time::date <=
                                                TO_DATE ('@ASON@',
                                                         'yyyy-mm-dd')
                                         AND (   COALESCE (nullif('@City@',''), '-1') = '-1'
                                              OR (    COALESCE (nullif('@City@',''), '-1') <>
                                                         '-1'
                                                  AND ct.ctname = nullif('@City@','')))
                                         AND (   COALESCE (nullif('@District@',''), '-1') =
                                                    '-1'
                                              OR (    COALESCE (nullif('@District@',''), '-1') <>
                                                         '-1'
                                                  AND ct.dist = nullif('@District@','')))
                                         AND (   COALESCE (nullif('@State@',''), '-1') = '-1'
                                              OR (    COALESCE (nullif('@State@',''), '-1') <>
                                                         '-1'
                                                  AND ct.stname = nullif('@State@','')))
                                         AND ( coalesce(nullif('@ConnOUCode@',''),'-1')::bigint = -1
                                                 	or
                                                 	(coalesce(nullif('@ConnOUCode@',''),'-1')::bigint <> -1 and aj.admou_code = coalesce(nullif('@ConnOUCode@',''),'-1')::bigint))
                                         AND (  (
                                                    nullif('@FinIncludeUnpostedRecords@',''))::int =
                                                    1
                                              OR (    (
                                                         nullif('@FinIncludeUnpostedRecords@',''))::int =
                                                         0
                                                  AND aj.release_status =
                                                         'P'))
                                         AND (   (    ls.clsname =
                                                         COALESCE (
                                                            NULLIF ('@Class@',
                                                                    ''),
                                                            '-1')
                                                  AND COALESCE (
                                                         NULLIF ('@Class@', ''),
                                                         '-1') <> '-1')
                                              OR COALESCE (
                                                    NULLIF ('@Class@', ''),
                                                    '-1') = '-1')
                                         AND (   (    sl.agcode =
                                                          COALESCE (
                                                               NULLIF (
                                                                  '@Agent@',
                                                                  ''),
                                                               '-1')::int
                                                  AND COALESCE (
                                                            NULLIF ('@Agent@',
                                                                    ''),
                                                            '-1')::int <>
                                                         -1)
                                              OR COALESCE (
                                                       NULLIF ('@Agent@', ''),
                                                       '-1')::int =
                                                    -1)
                                         AND (   (    aj.glcode =
                                                         COALESCE (
                                                               NULLIF (
                                                                  '@ARAPLedger@',
                                                                  ''),
                                                               '-1')::int
                                                  AND COALESCE (
                                                            NULLIF (
                                                               '@ARAPLedger@',
                                                               ''),
                                                            '-1')::int <>
                                                         -1)
                                              OR COALESCE (
                                                       NULLIF ('@ARAPLedger@',
                                                               ''),
                                                       '-1')::int =
                                                    -1)
                                         AND nullif('@ShowPDC@','')::int = 1
                                         AND (sl.slname|| '|'|| sl.slid IN (
    SELECT unnest(regexp_matches('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', '[^æ]+', 'g')) AS col1
    FROM generate_series(1, (SELECT count(*) FROM regexp_matches('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', 'æ', 'g'))+1) AS g
)
or COALESCE (NULLIF ('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', ''), '0')::text =0::text)
                                GROUP BY coalesce(sl.due_date_basis,'E'),
                                         sl.crdays,
                                         sl.slcode,
                                         gl.glcode,
                                         sl.agcode,
                                         sl.agrate,
                                         aj.admou_code,
                                         aj.admsite_code_owner,
                                         aj.ref_admsite_code,
                                         chqno,
                                         chqdt,
                                         drawnon,
                                         sl.slname,
                                         CASE
                                            WHEN nullif('@ShowAgent@','')::int =
                                                    1
                                            THEN
                                               COALESCE (
                                                  ag.slname,
                                                  'No Agent Defined in Document')
                                            ELSE
                                               'Do not show Agent'
                                         END,
                                         CASE
                                            WHEN 
                                                    nullif('@ShowClassWise@','')::int =
                                                    1
                                            THEN
                                               ls.clsname
                                            ELSE
                                               'Do Not Show Class'
                                         END,
                                         docno,
                                         entdt,
                                         CASE COALESCE (camount, 0)
                                            WHEN 0 THEN 'Payment'
                                            ELSE 'Receipt'
                                         END
                                UNION ALL
                                  SELECT case coalesce (sl.DUE_DATE_BASIS, 'E') when 
                                          'E' then 'ENTRY DATE' when
                                          'D' then 'DOCUMENT DATE' end due_date_basis,
                                         sl.crdays,
                                         sl.slcode,
                                         sl.glcode,
                                         CASE COALESCE (
                                                 NULLIF ('@AgentSource@', ''),
                                                 'M')
                                            WHEN 'T'
                                            THEN
                                               COALESCE (t1.agcode, sl.agcode)
                                            WHEN 'M'
                                            THEN
                                               sl.agcode
                                         END
                                            agcode,
                                         sl.agrate,
                                         t1.admou_code,
                                         t1.created_sitecode,
                                         t1.sitecode,
                                         t1.entcode::text entcode,
                                         t1.entno,
                                         t1.entdt,
                                         t1.refno,
                                         t1.refdt,
                                         CURRENT_DATE       due_dt,
                                         t1.entname,
                                         SUM (t1.amount)    amount,
                                         0                  adjusted,
                                         0                  PENDING,
                                         0::int
                                            running_pending_amount,
                                         NULL               outstanding_age,
                                         0
                                            gst_taxable_amount,
                                         0                  cgst_tax_amount,
                                         0                  sgst_tax_amount,
                                         0                  igst_tax_amount,
                                         0                  cess_amount,
                                         0                  total_gst_amount,
                                         CASE
                                            WHEN nullif('@ShowAgent@','')::int =
                                                    1
                                            THEN
                                               CASE COALESCE (
                                                       NULLIF ('@AgentSource@',
                                                               ''),
                                                       'M')
                                                  WHEN 'T'
                                                  THEN
                                                     COALESCE (
                                                        COALESCE (t1.agname,
                                                                  ag.slname),
                                                        'No Agent Defined in Document')
                                                  WHEN 'M'
                                                  THEN
                                                     COALESCE (
                                                        ag.slname,
                                                        'No Agent Defined in Document')
                                               END
                                            ELSE
                                               'Do not show Agent'
                                         END
                                            group1,
                                         CASE
                                            WHEN nullif('@ShowClassWise@','')::int =
                                                    1
                                            THEN
                                               ls.clsname
                                            ELSE
                                               'Do Not Show Class'
                                         END
                                            group2,
                                         sl.slname          group3,
                                         CASE
                                            WHEN '@DisplayType@' = 'D'
                                            THEN
                                               t1.entname
                                            WHEN '@DisplayType@' = 'E'
                                            THEN
                                               'Date wise Display'
                                         END
                                            group4,
                                         3                  lvl,
                                         NULL               cheq_no,
                                         NULL               cheq_date,
                                         NULL               chque_type,
                                         NULL               chque_drawn_on,
                                         NULL               chque_reference,
                                         0                  cheque_amount,
                                         remarks,
                                         NULL               doc_ref_date
                                    FROM (SELECT 'Purchase Invoice' entname,
                                                 m.grccode        entcode,
                                                 scheme_docno     entno,
                                                 m.grcdt          entdt,
                                                 m.geno           refno,
                                                 NULL::date            refdt,
                                                 -1 * COALESCE (d.netamt, 0)
                                                    amount,
                                                 m.pcode          pcode,
                                                 m.rem            remarks,
                                                 m.agcode         agcode,
                                                 s.slname         agname,
                                                 m.admou_code     admou_code,
                                                 m.admsite_code_in
                                                    created_sitecode,
                                                 m.admsite_code_in sitecode
                                            FROM invgrcmain m
                                                 JOIN invgrcdet d
                                                    ON (m.grccode = d.grccode)
                                                 LEFT OUTER JOIN
                                                 finsl s
                                                    ON (m.agcode = s.slcode)
                                                 JOIN finsl sl
                                                    ON (m.pcode = sl.slcode)
                                           WHERE     m.ycode =
                                                        (SELECT ycode
                                                           FROM admyear
                                                          WHERE TO_DATE (
                                                                   '@ASON@',
                                                                   'yyyy-mm-dd') BETWEEN dtfr
                                                                                     AND dtto)
                                                 AND m.whether_consignment =
                                                        'NON-CONSIGNMENT'
                                                 AND nullif('@showopndoc@','')::int =
                                                        1
                                                 AND (sl.slname|| '|'|| sl.slid IN (
    SELECT unnest(regexp_matches('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', '[^æ]+', 'g')) AS col1
    FROM generate_series(1, (SELECT count(*) FROM regexp_matches('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', 'æ', 'g'))+1) AS g
)
or COALESCE (NULLIF ('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', ''), '0')::text =0::text)
                                                 AND ( coalesce(nullif('@ConnOUCode@',''),'-1')::bigint = -1
                                                 	or
                                                 	(coalesce(nullif('@ConnOUCode@',''),'-1')::bigint <> -1 and m.admou_code = coalesce(nullif('@ConnOUCode@',''),'-1')::bigint))
                                                 AND (   m.rcinvqty = 0
                                                      OR (      COALESCE (
                                                                   m.rcqty,
                                                                   0)
                                                              - COALESCE (
                                                                   m.rtqty,
                                                                   0)
                                                              - COALESCE (
                                                                   m.rcinvqty,
                                                                   0) <> 0
                                                          AND m.grccode IN
                                                                 (
                                                                 SELECT GRCCODE
  FROM PURINVMAIN M
       INNER JOIN PURINVDET D ON (M.INVCODE = D.INVCODE)       
                                                                         Where m.invdt >
                                                                                TO_DATE (
                                                                                   '@ASON@',
                                                                                   'yyyy-mm-dd'))))
                                          UNION ALL
                                          SELECT 'Purchase Return Debit Note'
                                                    entname,
                                                 m.grtcode            entcode,
                                                 m.scheme_docno       entno,
                                                 m.grtdt              entdt,
                                                 m.geno               refno,
                                                 NULL::date                 refdt,
                                                 COALESCE (d.netamt, 0) amount,
                                                 m.pcode              pcode,
                                                 m.rem                remarks,
                                                 m.agcode             agcode,
                                                 s.slname             agname,
                                                 m.admou_code
                                                    admou_code,
                                                 m.admsite_code
                                                    created_sitecode,
                                                 m.admsite_code
                                                    sitecode
                                            FROM invgrtmain m
                                                 JOIN invgrtdet d
                                                    ON (m.grtcode = d.grtcode)
                                                 LEFT OUTER JOIN
                                                 purrtmain r
                                                    ON (m.rtcode = r.rtcode)
                                                 LEFT OUTER JOIN
                                                 invgrcdet gd
                                                    ON (m.grccode = gd.grccode)
                                                 LEFT OUTER JOIN
                                                 finsl s
                                                    ON (m.agcode = s.slcode)
                                                 JOIN finsl sl
                                                    ON (m.pcode = sl.slcode)
                                           WHERE    nullif('@showopndoc@','')::int =
                                                        1
                                                 AND (sl.slname|| '|'|| sl.slid IN (
    SELECT unnest(regexp_matches('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', '[^æ]+', 'g')) AS col1
    FROM generate_series(1, (SELECT count(*) FROM regexp_matches('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', 'æ', 'g'))+1) AS g
)
or COALESCE (NULLIF ('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', ''), '0')::text =0::text)
                                                 AND m.rtcode IS NULL
                                                 AND m.ycode =
                                                        (SELECT ycode
                                                           FROM admyear
                                                          WHERE TO_DATE (
                                                                   '@ASON@',
                                                                   'yyyy-mm-dd') BETWEEN dtfr
                                                                                     AND dtto)
                                                 AND ( coalesce(nullif('@ConnOUCode@',''),'-1')::bigint = -1
                                                 	or
                                                 	(coalesce(nullif('@ConnOUCode@',''),'-1')::bigint <> -1 and m.admou_code = coalesce(nullif('@ConnOUCode@',''),'-1')::bigint))
                                                 AND (   m.grccode IS NULL
                                                      OR (    m.grccode
                                                                 IS NOT NULL
                                                          AND m.grccode IN
                                                                 (SELECT grccode
                                                                    FROM invgrcmain
                                                                   WHERE whether_consignment =
                                                                            'NON-CONSIGNMENT')))
                                                 AND (   m.rtcode IS NULL
                                                      OR r.rtdt >
                                                            TO_DATE (
                                                               '@ASON@',
                                                               'yyyy-mm-dd'))
                                          UNION ALL
                                          SELECT 'Sales Invoice' entname,
                                                 i.dccode      entcode,
                                                 scheme_docno  entno,
                                                 i.dcdt        entdt,
                                                 i.docno       refno,
                                                 NULL::date          refdt,
                                                   COALESCE (id.isqty, 0)
                                                 * COALESCE (id.rate, 0)
                                                    amount,
                                                 i.pcode       pcode,
                                                 i.rem         remarks,
                                                 i.agcode      agcode,
                                                 s.slname      agname,
                                                 i.admou_code  admou_code,
                                                 i.admsite_code_owner
                                                    created_sitecode,
                                                 i.admsite_code sitecode
                                            FROM invdcmain I
                                                 JOIN invdcdet id
                                                    ON (i.dccode = id.dccode)
                                                 LEFT OUTER JOIN
                                                 finsl s
                                                    ON (i.agcode = s.slcode)
                                                 JOIN finsl sl
                                                    ON (i.pcode = sl.slcode)
                                           WHERE    
                                                        nullif('@showopndoc@','')::int =
                                                        1
                                                 AND (sl.slname|| '|'|| sl.slid IN (
    SELECT unnest(regexp_matches('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', '[^æ]+', 'g')) AS col1
    FROM generate_series(1, (SELECT count(*) FROM regexp_matches('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', 'æ', 'g'))+1) AS g
)
or COALESCE (NULLIF ('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', ''), '0')::text =0::text)
                                                 AND i.status <> 'CANCELLED'
                                                 AND i.ycode =
                                                        (SELECT ycode
                                                           FROM admyear
                                                          WHERE TO_DATE (
                                                                   '@ASON@',
                                                                   'yyyy-mm-dd') BETWEEN dtfr
                                                                                     AND dtto)
                                                 AND (   i.invcode IS NULL
                                                      OR i.invcode IN
                                                            (SELECT invcode
                                                               FROM salinvmain
                                                                    M
                                                              WHERE m.invdt >
                                                                       TO_DATE (
                                                                          '@ASON@',
                                                                          'yyyy-mm-dd')))
                                                 AND ( coalesce(nullif('@ConnOUCode@',''),'-1')::bigint = -1
                                                 	or
                                                 	(coalesce(nullif('@ConnOUCode@',''),'-1')::bigint <> -1 and i.admou_code = coalesce(nullif('@ConnOUCode@',''),'-1')::bigint))
                                          UNION ALL
                                          SELECT 'Service Invoice'             ENTNAME,
       M.ORDCODE                     ENTCODE,
       SCHEME_DOCNO                  ENTNO,
       m.ORDDT::date                         ENTDT,
       DOCNO                         REFNO,
       NULL::date                          REFDT,
       (-1) * COALESCE (D.SRVAMT, 0) AMOUNT,
       PCODE                         PCODE,
       M.REM                         REMARKS,
       NULL                          AGCODE,
       NULL                          AGNAME,
       ADMOU_CODE                    ADMOU_CODE,
       ADMSITE_CODE                  CREATED_SITECODE,
       ADMSITE_CODE                  SITECODE
  FROM PRDORD M
       INNER JOIN PRDRC D ON (M.ORDCODE = D.ORDCODE)
       INNER JOIN FINSL SL ON (PCODE = SLCODE)
                                                 Where (sl.slname|| '|'|| sl.slid IN (
    SELECT unnest(regexp_matches('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', '[^æ]+', 'g')) AS col1
    FROM generate_series(1, (SELECT count(*) FROM regexp_matches('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', 'æ', 'g'))+1) AS g
)
or COALESCE (NULLIF ('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', ''), '0')::text =0::text)
                                                 AND nullif('@showopndoc@','')::int =
                                                        1
                                                 AND m.ycode =
                                                        (SELECT ycode
                                                           FROM admyear
                                                          WHERE TO_DATE (
                                                                   '@ASON@',
                                                                   'yyyy-mm-dd') BETWEEN dtfr
                                                                                     AND dtto)
                                                 AND (   m.srvcode IS NULL
                                                      OR m.srvcode IN
                                                            (SELECT srvcode
                                                               FROM pursrvmain
                                                                    P
                                                              WHERE p.srvdt >
                                                                       TO_DATE (
                                                                          '@ASON@',
                                                                          'yyyy-mm-dd')))
                                                 AND ( coalesce(nullif('@ConnOUCode@',''),'-1')::bigint = -1
                                                 	or
                                                 	(coalesce(nullif('@ConnOUCode@',''),'-1')::bigint <> -1 and m.admou_code = coalesce(nullif('@ConnOUCode@',''),'-1')::bigint))
                                          UNION ALL
                                          SELECT 'Service Invoice'                                     ENTNAME,
       M.CODE                                                ENTCODE,
       JRCNO                                                 ENTNO,
       JRC_DATE                                              ENTDT,
       REFNO                                                 REFNO,
       REF_DATE::date                                        REFDT,
       ROUND (COALESCE (QTY, 0) * COALESCE (JOB_RATE, 0), 2) AMOUNT,
       PCODE                                                 PCODE,
       M.REMARKS                                             REMARKS,
       NULL                                                  AGCODE,
       NULL                                                  AGNAME,
       ADMOU_CODE                                            ADMOU_CODE,
       ADMSITE_CODE                                          CREATED_SITECODE,
       ADMSITE_CODE                                          SITECODE
  FROM PRDJRCMAIN M
       INNER JOIN PRDJRCDET D ON (M.CODE = JRCCODE)
       INNER JOIN FINSL SL ON (PCODE = SLCODE)
                                                 Where 
                                                        nullif('@showopndoc@','')::int =
                                                        1
                                                 AND (sl.slname|| '|'|| sl.slid IN (
    SELECT unnest(regexp_matches('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', '[^æ]+', 'g')) AS col1
    FROM generate_series(1, (SELECT count(*) FROM regexp_matches('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', 'æ', 'g'))+1) AS g
)
or COALESCE (NULLIF ('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', ''), '0')::text =0::text)
                                                 AND m.ycode =
                                                        (SELECT ycode
                                                           FROM admyear
                                                          WHERE TO_DATE (
                                                                   '@ASON@',
                                                                   'yyyy-mm-dd') BETWEEN dtfr
                                                                                     AND dtto)
                                                 AND (   m.srvcode IS NULL
                                                      OR m.srvcode IN
                                                            (SELECT srvcode
                                                               FROM pursrvmain
                                                                    P
                                                              WHERE p.srvdt >
                                                                       TO_DATE (
                                                                          '@ASON@',
                                                                          'yyyy-mm-dd')))
                                                 AND ( coalesce(nullif('@ConnOUCode@',''),'-1')::bigint = -1
                                                 	or
                                                 	(coalesce(nullif('@ConnOUCode@',''),'-1')::bigint <> -1 and m.admou_code = coalesce(nullif('@ConnOUCode@',''),'-1')::bigint))
                                          UNION ALL
                                          SELECT 'Service Invoice'                                    ENTNAME,
       LGTCODE                                              ENTCODE,
       LGTNO::text                                      ENTNO,
       LGTDT                                                ENTDT,
       DOCNO                                                REFNO,
       DOCDT                                                REFDT,
       (-1) * (COALESCE (FRTAMT, 0) + COALESCE (OTHAMT, 0)) AMOUNT,
       M.TRPCODE                                            PCODE,
       M.REM                                                REMARKS,
       NULL                                                 AGCODE,
       NULL                                                 AGNAME,
       ADMOU_CODE                                           ADMOU_CODE,
       ADMSITE_CODE_OWNER                                   CREATED_SITECODE,
       ADMSITE_CODE                                         SITECODE
  FROM INVLGTNOTE M
       INNER JOIN FINSL SL ON (M.TRPCODE = SLCODE)
     Where (sl.slname|| '|'|| sl.slid IN (
    SELECT unnest(regexp_matches('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', '[^æ]+', 'g')) AS col1
    FROM generate_series(1, (SELECT count(*) FROM regexp_matches('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', 'æ', 'g'))+1) AS g
)
or COALESCE (NULLIF ('@#ARAPSubLedgerDisplayNameShortCodeMulti#@', ''), '0')::text =0::text)
                                                 AND m.ycode =
                                                        (SELECT ycode
                                                           FROM admyear
                                                          WHERE TO_DATE (
                                                                   '@ASON@',
                                                                   'yyyy-mm-dd') BETWEEN dtfr
                                                                                     AND dtto)
                                                 AND nullif('@showopndoc@','')::int =
                                                        1
                                                 AND COALESCE (m.topay, 'NO') =
                                                        'YES'
                                                 AND ( coalesce(nullif('@ConnOUCode@',''),'-1')::bigint = -1
                                                 	or
                                                 	(coalesce(nullif('@ConnOUCode@',''),'-1')::bigint <> -1 and m.admou_code = coalesce(nullif('@ConnOUCode@',''),'-1')::bigint))
                                                 AND (   m.srvcode IS NULL
                                                      OR m.srvcode IN
                                                            (SELECT srvcode
                                                               FROM pursrvmain
                                                                    p
                                                              WHERE p.srvdt >
                                                                       TO_DATE (
                                                                          '@ASON@',
                                                                          'yyyy-mm-dd'))))
                                         t1
                                         INNER JOIN finsl sl
                                            ON (t1.pcode = sl.slcode)
                                         LEFT OUTER JOIN finsl ag
                                            ON (sl.agcode = ag.slcode)
                                         INNER JOIN admcls ls
                                            ON (sl.clscode = ls.clscode)
                                   WHERE t1.entdt <= TO_DATE ('@ASON@', 'yyyy-mm-dd')
                                GROUP BY coalesce(sl.due_date_basis,'E'),
                                         sl.crdays,
                                         sl.slcode,
                                         sl.glcode,
                                         CASE COALESCE (
                                                 NULLIF ('@AgentSource@', ''),
                                                 'M')
                                            WHEN 'T'
                                            THEN
                                               COALESCE (t1.agcode,
                                                         sl.agcode)
                                            WHEN 'M'
                                            THEN
                                               sl.agcode
                                         END,
                                         sl.agrate,
                                         t1.admou_code,
                                         t1.created_sitecode,
                                         t1.sitecode,
                                         t1.entcode::text,
                                         t1.entno,
                                         t1.entdt,
                                         t1.refno,
                                         t1.refdt,
                                         CURRENT_DATE,
                                         t1.entname,
                                         CASE
                                            WHEN nullif('@ShowAgent@','')::int =
                                                    1
                                            THEN
                                               CASE COALESCE (
                                                       NULLIF (
                                                          '@AgentSource@',
                                                          ''),
                                                       'M')
                                                  WHEN 'T'
                                                  THEN
                                                     COALESCE (
                                                        COALESCE (t1.agname,
                                                                  ag.slname),
                                                        'No Agent Defined in Document')
                                                  WHEN 'M'
                                                  THEN
                                                     COALESCE (
                                                        ag.slname,
                                                        'No Agent Defined in Document')
                                               END
                                            ELSE
                                               'Do not show Agent'
                                         END,
                                         CASE
                                            WHEN 
                                                    nullif('@ShowClassWise@','')::int =
                                                    1
                                            THEN
                                               ls.clsname
                                            ELSE
                                               'Do Not Show Class'
                                         END,
                                         sl.slname,
                                         remarks) T7) T1) q1
         WHERE     1 =
                      CASE
                         WHEN     COALESCE (showpendingaboveamt, -1) <> -1
                              AND LVL IN (2, 3)
                         THEN
                            1
                         WHEN     COALESCE (showpendingaboveamt, -1) <> -1
                              AND LVL = 1
                              AND balance_amount > showpendingaboveamt
                         THEN
                            1
                         WHEN     COALESCE (showpendingaboveamt, -1) <> -1
                              AND LVL = 1
                              AND balance_amount <= showpendingaboveamt
                         THEN
                            0
                         WHEN COALESCE (showpendingaboveamt, -1) = -1
                         THEN
                            1
                      END
               /*New protion added
              Change for compatable with Oracle 12.1.0.1.0*/
               /*Bug 106921*/
               AND ADMOU_CODE = (nullif('@ConnOUCode@',''))::bigint
               AND (   OUTSTANDING_AGE >=
                          COALESCE (nullif('@ShowPendingAboveDays@','')::INT, 0)::int
                    OR LVL IN (3, 2))
               AND (   (   (BALANCE_AMOUNT <> 0 AND INCLUDEZEROFLAG = 0)
                        OR LVL IN (2, 3))
                    OR INCLUDEZEROFLAG = 1)
               AND (   (       OUTSTANDING_BASIS = '2DUE'
                           AND LVL = 1
                           AND OUTSTANDING_AGE <> 0
                        OR OUTSTANDING_AGE > 0)
                    OR OUTSTANDING_BASIS <> '2DUE'
                    OR LVL IN (2, 3))                           /*End Change*/
                                                                /*Bug 106921*/
       ) tab1                                    /*Start Changes Bug 107129*/
       left outer join finsl ag on (tab1.agent_code = ag.SLCODE)
       inner join fingl gl on (tab1.glcode = gl.GLCODE)
       left outer join admsite os on (tab1.ADMSITE_CODE_OWNER = os.code)
       left outer join admsite rs on (tab1.REF_ADMSITE_CODE = rs.code)
/*End Changes Bug 107129*/