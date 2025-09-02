/* Formatted on 01-Oct-24 5:07:41 PM (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_PROFIT_LOSS || Ticket Id : 391564 || Developer : Dipankar || ><><><*/
WITH RAWTREE AS (with recursive groups
				as (
				select
					t1.grpcode
						,
					t1.grpname::text grpname
						,
					t1.seq
						,
					t1.parcode
						,
					'GRP' || t1.parcode::TEXT tree_parent_code
						,
					'GRP' childtype
						,
					'GRP' || t1.grpcode::TEXT tree_child_code
				from
					(
					select
						grpcode
						,
						grpname::text as grpname
						,
						seq
						,
						parcode
					from
						fingrp f
					where
						grpcode in (
						select
							grpcode
						from
							fingl
						where
							type in ( 'I' , 'E' ) )
				union all
					select
						-1 grpcode,
						'COGS'::TEXT grpname,
						97 seq,
						14 parcode
				union all
					select
						-2 grpcode,
						'Gross Profit'::TEXT grpname,
						98 seq,
						14 parcode
				union all
					select
						-3 grpcode,
						'Gross Profit %'::TEXT grpname,
						99 seq,
						14 parcode ) t1
				union all
				select
					t2.grpcode
						,
					t2.grpname::TEXT
						,
					t2.seq
						,
					t2.parcode
						,
					'GRP' || t2.parcode::TEXT tree_parent_code
						,
					'GRP' childtype
						,
					'GRP' || t2.grpcode::TEXT tree_child_code
				from
					(
					select
						grpcode
						,
						grpname::text as grpname
						,
						seq
						,
						parcode
					from
						fingrp f
				union all
					select
						-1 grpcode,
						'COGS'::TEXT grpname,
						97 seq,
						14 parcode
				union all
					select
						-2 grpcode,
						'Gross Profit'::TEXT grpname,
						98 seq,
						14 parcode
				union all
					select
						-3 grpcode,
						'Gross Profit %'::TEXT grpname,
						99 seq,
						14 parcode ) t2
				join groups on
					GROUPS.parcode = t2.grpcode  
					), 
				GROUPS_N_LEDGERS as (
				select
					distinct grpcode child_code
						,
					grpname child_name
						,
					seq
						,
					parcode parent_code
						,
					tree_parent_code
						,
					childtype
						,
					tree_child_code
				from
					groups
				union all
				select
					glcode
						,
					glname
						,
					glseq
						,
					grpcode
						,
					'GRP' || cast(GRPCODE as TEXT)
						,
					'GL'
						,
					'GL' || cast(GLCODE as TEXT)
				from
					fingl
				where
					type in ( 'I' , 'E' ) 
					/*IF CUSTOM LEDGER/LEVEL REQUIRED ADD HERE*/
					),
				SORTED_ORDER as (
				select
					child_code,
					parent_code,
					child_name
						,
					tree_parent_code
						,
					childtype
						,
					tree_child_code
						,
					seq
						,
					1 LVL
						,
					array [cast(seq::text || child_code::text as int)::int] hierchy
				from
					GROUPS_N_LEDGERS
				where
					UPPER(child_name) = 'TREE'
				union
				select
					T2.child_code,
					T2.parent_code,
					T2.child_name
						,
					T2.tree_parent_code
						,
					T2.childtype
						,
					T2.tree_child_code
						,
					T2.seq
						,
					T1.LVL + 1 LVL
						,
					T1.hierchy || t2.seq::INT || T2.child_code::INT
				from
					GROUPS_N_LEDGERS T2
				join SORTED_ORDER T1 on
					T1.tree_child_code = T2.tree_parent_code
					)
				select
					child_code,
					parent_code,
					tree_parent_code,
					childtype,
					tree_child_code
					,
					LVL hierarchy_level
					,
					SUBSTRING(LPAD('    ',
					6 * (LVL - 2),
					'    ') || child_name,
					1,
					1000) tree
					,
					ginview.fnc_uk() display_order
				from
					SORTED_ORDER T1
				where
					UPPER(child_name) <> 'TREE'
				order by
					T1.hierchy),
     GLDATA
     AS (SELECT glcode,
                CASE WHEN OPENING >= 0 THEN OPENING ELSE 0 END OPENING_DEBIT,
                CASE WHEN OPENING < 0 THEN ABS (OPENING) ELSE 0 END
                   OPENING_CREDIT,
                OPENING
                   OPENING_BALANCE,
                CASE WHEN TXN >= 0 THEN TXN ELSE 0 END         TXN_DEBIT,
                CASE WHEN TXN < 0 THEN ABS (TXN) ELSE 0 END    TXN_CREDIT,
                TXN                                            TXN_BALANCE,
                CASE WHEN CLOSING >= 0 THEN CLOSING ELSE 0 END CLOSING_DEBIT,
                CASE WHEN CLOSING < 0 THEN ABS (CLOSING) ELSE 0 END
                   CLOSING_CREDIT,
                CLOSING
                   CLOSING_BALANCE
           FROM (  SELECT g.glcode,
                          0 OPENING,
                          SUM (
                             CASE
                                WHEN p.entdt::DATE <= TO_DATE (
                                                                '@DTTO@',
                                                                'YYYY-MM-DD')
                                THEN
                                   COALESCE(p.damount, 0) - COALESCE(p.camount, 0)
                                ELSE
                                   0
                             END)
                             TXN,
                          SUM (COALESCE(p.damount, 0) - COALESCE(p.camount, 0)) CLOSING
                     FROM finpost p
                          JOIN fingl g ON p.glcode = g.glcode
                          JOIN GINVIEW.LV_CHART_OF_ACCOUNTS coa
                             ON g.grpcode = coa.CODE
                    WHERE     TYPE IN ('I', 'E')
                           AND p.admou_code = nullif('@ConnOUCode@','')::int
                          AND (   (   '@OpeningOnly@' = 'N'
                                   OR '@OpeningOnly@' IS NULL)
                               OR ('@OpeningOnly@' = 'Y' AND YCODE = 2))
                          AND (   (    '@IncludeUnpostedRecords@' = '1|#|N'
                                   AND release_status = 'P')
                               OR (    '@IncludeUnpostedRecords@' = '0|#|Y'
                                   AND release_status IN ('P', 'U'))
                               OR '@IncludeUnpostedRecords@' IS NULL) 
                          AND p.entdt::DATE <=
                                 TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                          AND ycode =
                                 (SELECT ycode
                                    FROM admyear
                                   WHERE TO_DATE ('@DTTO@', 'YYYY-MM-DD') BETWEEN dtfr
                                                                              AND dtto)
                 GROUP BY g.glcode)) ,
     CUSTOM_CTE
     AS ( SELECT SUM (
                   CASE
                      WHEN  level3 IN
                              ('Stock Transfers',
                               'Purchase',
                               'Opening Stocks',
                               'Closing Stocks',
                               'Other Incomes')
                      THEN
                         txn_balance
                      ELSE
                         0
                   END)
                   TXN_STOCK_VALUE, 
                SUM (
                   CASE
                      WHEN  level3 IN ('Sales') THEN txn_balance*-1 
                      ELSE 0
                   END)
                   TXN_SALES_VALUE,
                   SUM (
                   CASE
                      WHEN level3 IN
                              ('Stock Transfers',
                               'Purchase',
                               'Opening Stocks',
                               'Closing Stocks',
                               'Other Incomes')
                      THEN
                          balance 
                      ELSE
                         0
                   END)
                   STOCK_VALUE, 
                SUM (
                   CASE
                      WHEN level3 IN ('Sales') THEN  balance*-1
                      ELSE 0
                   END)
                   SALES_VALUE
           FROM ( 
           SELECT  level3,sum(case when entdt::DATE <= TO_DATE ('@DTTO@', 'YYYY-MM-DD')  
                           then  COALESCE(p.damount, 0) - COALESCE(p.camount, 0)  else 0
                           end) txn_balance,
                           SUM (COALESCE(p.damount, 0) - COALESCE(p.camount, 0)) balance
                     FROM finpost p
                          JOIN fingl g ON p.glcode = g.glcode
                          JOIN GINVIEW.LV_CHART_OF_ACCOUNTS coa
                             ON g.grpcode = coa.CODE
                    WHERE     TYPE IN ('I', 'E')
                          AND p.admou_code = nullif ('@ConnOUCode@','')::int
                          AND (   (   '@OpeningOnly@' = 'N'
                                   OR '@OpeningOnly@' IS NULL)
                               OR ('@OpeningOnly@' = 'Y' AND YCODE = 2))
                          AND (   (    '@IncludeUnpostedRecords@' = '1|#|N'
                                   AND release_status = 'P')
                               OR (    '@IncludeUnpostedRecords@' = '0|#|Y'
                                   AND release_status IN ('P', 'U'))
                               OR '@IncludeUnpostedRecords@' IS NULL) 
                          AND p.entdt::DATE <=
                                 TO_DATE ('@DTTO@', 'YYYY-MM-DD')
                          AND ycode =
                                 (SELECT ycode
                                    FROM admyear
                                   WHERE TO_DATE ('@DTTO@', 'YYYY-MM-DD') BETWEEN dtfr
                                                                              AND dtto)
                          AND coa.level3 IN ('Stock Transfers',
                                             'Closing Stocks',
                                             'Opening Stocks',
                                             'Purchase',
                                             'Sales',
                                             'Other Incomes')
                 GROUP BY  level3 ) )  
SELECT RAWTREE.child_code,
       RAWTREE.TREE,
       RAWTREE.parent_code,
       RAWTREE.tree_parent_code,
       RAWTREE.childtype,
       RAWTREE.tree_child_code,
       RAWTREE.hierarchy_level,
       RAWTREE.display_order,
       GLDATA.OPENING_DEBIT,
       GLDATA.OPENING_CREDIT,
       GLDATA.OPENING_BALANCE,
       GLDATA.TXN_DEBIT,
       GLDATA.TXN_CREDIT,
       GLDATA.TXN_BALANCE,
       GLDATA.CLOSING_DEBIT,
       GLDATA.CLOSING_CREDIT,
       GLDATA.CLOSING_BALANCE,
       0 L2_OPENING_DEBIT,
       0 L2_OPENING_CREDIT,
       0 L2_OPENING_BALANCE,
       0 L2_TXN_DEBIT,
       0 L2_TXN_CREDIT,
       0 L2_TXN_BALANCE,
       0 L2_CLOSING_DEBIT,
       0 L2_CLOSING_CREDIT,
       0 L2_CLOSING_BALANCE
  FROM RAWTREE
       LEFT JOIN GLDATA
          ON (RAWTREE.CHILD_CODE = GLDATA.GLCODE AND RAWTREE.CHILDTYPE = 'GL')
 WHERE     RAWTREE.CHILDTYPE = 'GL'
       AND (   GLDATA.OPENING_BALANCE <> 0
            OR GLDATA.TXN_BALANCE <> 0
            OR GLDATA.CLOSING_BALANCE <> 0)
UNION ALL
SELECT t.child_code,
       t.TREE,
       t.parent_code,
       t.tree_parent_code,
       t.childtype,
       t.tree_child_code,
       t.hierarchy_level,
       t.display_order,
       CASE WHEN OPENING_BALANCE >= 0 THEN OPENING_BALANCE ELSE 0 END
          OPENING_DEBIT,
       CASE WHEN OPENING_BALANCE < 0 THEN ABS (OPENING_BALANCE) ELSE 0 END
          OPENING_CREDIT,
       OPENING_BALANCE,
       CASE WHEN TXN_BALANCE >= 0 THEN TXN_BALANCE ELSE 0 END      TXN_DEBIT,
       CASE WHEN TXN_BALANCE < 0 THEN ABS (TXN_BALANCE) ELSE 0 END TXN_CREDIT,
       TXN_BALANCE,
       CASE WHEN CLOSING_BALANCE >= 0 THEN CLOSING_BALANCE ELSE 0 END
          CLOSING_DEBIT,
       CASE WHEN CLOSING_BALANCE < 0 THEN ABS (CLOSING_BALANCE) ELSE 0 END
          CLOSING_CREDIT,
       CLOSING_BALANCE,
       CASE WHEN L2_OPENING_BALANCE >= 0 THEN L2_OPENING_BALANCE ELSE 0 END
          L2_OPENING_DEBIT,
       CASE
          WHEN L2_OPENING_BALANCE < 0 THEN ABS (L2_OPENING_BALANCE)
          ELSE 0
       END
          L2_OPENING_CREDIT,
       L2_OPENING_BALANCE,
       CASE WHEN L2_TXN_BALANCE >= 0 THEN L2_TXN_BALANCE ELSE 0 END
          L2_TXN_DEBIT,
       CASE WHEN L2_TXN_BALANCE < 0 THEN ABS (L2_TXN_BALANCE) ELSE 0 END
          L2_TXN_CREDIT,
       L2_TXN_BALANCE,
       CASE WHEN L2_CLOSING_BALANCE >= 0 THEN L2_CLOSING_BALANCE ELSE 0 END
          L2_CLOSING_DEBIT,
       CASE
          WHEN L2_CLOSING_BALANCE < 0 THEN ABS (L2_CLOSING_BALANCE)
          ELSE 0
       END
          L2_CLOSING_CREDIT,
       L2_CLOSING_BALANCE
  FROM (  SELECT p.child_code,
                 p.TREE,
                 p.parent_code,
                 p.tree_parent_code,
                 p.childtype,
                 p.tree_child_code,
                 p.hierarchy_level,
                 p.display_order,
                 SUM (OPENING_BALANCE) OPENING_BALANCE,
                 SUM (TXN_BALANCE)   TXN_BALANCE,
                 SUM (CLOSING_BALANCE) CLOSING_BALANCE,
                 SUM (
                    CASE
                       WHEN tree_parent_code = 'GRP1' THEN OPENING_BALANCE
                       ELSE 0
                    END)
                    L2_OPENING_BALANCE,
                 SUM (
                    CASE
                       WHEN tree_parent_code = 'GRP1' THEN TXN_BALANCE
                       ELSE 0
                    END)
                    L2_TXN_BALANCE,
                 SUM (
                    CASE
                       WHEN tree_parent_code = 'GRP1' THEN CLOSING_BALANCE
                       ELSE 0
                    END)
                    L2_CLOSING_BALANCE
            FROM (  SELECT 'GRP1'                            sec,
                           PAR.child_code,
                           PAR.TREE,
                           PAR.parent_code,
                           PAR.tree_parent_code,
                           PAR.childtype,
                           PAR.tree_child_code,
                           PAR.hierarchy_level,
                           PAR.display_order,
                           SUM (COALESCE(GLDATA.OPENING_BALANCE, 0)) OPENING_BALANCE,
                           SUM (COALESCE(GLDATA.TXN_BALANCE, 0)) TXN_BALANCE,
                           SUM (COALESCE(GLDATA.CLOSING_BALANCE, 0)) CLOSING_BALANCE
                      FROM RAWTREE
                           LEFT JOIN GLDATA
                              ON (    RAWTREE.CHILD_CODE = GLDATA.GLCODE
                                  AND RAWTREE.CHILDTYPE = 'GL')
                           JOIN RAWTREE PAR
                              ON (RAWTREE.tree_parent_code = PAR.tree_child_code)
                     WHERE RAWTREE.CHILDTYPE = 'GL'
                  GROUP BY PAR.child_code,
                           PAR.TREE,
                           PAR.parent_code,
                           PAR.tree_parent_code,
                           PAR.childtype,
                           PAR.tree_child_code,
                           PAR.hierarchy_level,
                           PAR.display_order
                  UNION ALL
                    SELECT 'GRP2'                            sec,
                           PAR1.child_code,
                           PAR1.TREE,
                           PAR1.parent_code,
                           PAR1.tree_parent_code,
                           PAR1.childtype,
                           PAR1.tree_child_code,
                           PAR1.hierarchy_level,
                           PAR1.display_order,
                           SUM (COALESCE(GLDATA.OPENING_BALANCE, 0)) OPENING_BALANCE,
                           SUM (COALESCE(GLDATA.TXN_BALANCE, 0)) TXN_BALANCE,
                           SUM (COALESCE(GLDATA.CLOSING_BALANCE, 0)) CLOSING_BALANCE
                      FROM RAWTREE
                           LEFT JOIN GLDATA
                              ON (    RAWTREE.CHILD_CODE = GLDATA.GLCODE
                                  AND RAWTREE.CHILDTYPE = 'GL')
                           JOIN RAWTREE PAR
                              ON (RAWTREE.tree_parent_code = PAR.tree_child_code)
                           JOIN RAWTREE PAR1
                              ON (PAR.tree_parent_code = PAR1.tree_child_code)
                     WHERE RAWTREE.CHILDTYPE = 'GL'
                  GROUP BY PAR1.child_code,
                           PAR1.TREE,
                           PAR1.parent_code,
                           PAR1.tree_parent_code,
                           PAR1.childtype,
                           PAR1.tree_child_code,
                           PAR1.hierarchy_level,
                           PAR1.display_order
                  UNION ALL
                    SELECT 'GRP3'                            sec,
                           PAR2.child_code,
                           PAR2.TREE,
                           PAR2.parent_code,
                           PAR2.tree_parent_code,
                           PAR2.childtype,
                           PAR2.tree_child_code,
                           PAR2.hierarchy_level,
                           PAR2.display_order,
                           SUM (COALESCE(GLDATA.OPENING_BALANCE, 0)) OPENING_BALANCE,
                           SUM (COALESCE(GLDATA.TXN_BALANCE, 0)) TXN_BALANCE,
                           SUM (COALESCE(GLDATA.CLOSING_BALANCE, 0)) CLOSING_BALANCE
                      FROM RAWTREE
                           LEFT JOIN GLDATA
                              ON (    RAWTREE.CHILD_CODE = GLDATA.GLCODE
                                  AND RAWTREE.CHILDTYPE = 'GL')
                           JOIN RAWTREE PAR
                              ON (RAWTREE.tree_parent_code = PAR.tree_child_code)
                           JOIN RAWTREE PAR1
                              ON (PAR.tree_parent_code = PAR1.tree_child_code)
                           JOIN RAWTREE PAR2
                              ON (PAR1.tree_parent_code = PAR2.tree_child_code)
                     WHERE RAWTREE.CHILDTYPE = 'GL'
                  GROUP BY PAR2.child_code,
                           PAR2.TREE,
                           PAR2.parent_code,
                           PAR2.tree_parent_code,
                           PAR2.childtype,
                           PAR2.tree_child_code,
                           PAR2.hierarchy_level,
                           PAR2.display_order
                  UNION ALL
                    SELECT 'GRP4'                            sec,
                           PAR3.child_code,
                           PAR3.TREE,
                           PAR3.parent_code,
                           PAR3.tree_parent_code,
                           PAR3.childtype,
                           PAR3.tree_child_code,
                           PAR3.hierarchy_level,
                           PAR3.display_order,
                           SUM (COALESCE(GLDATA.OPENING_BALANCE, 0)) OPENING_BALANCE,
                           SUM (COALESCE(GLDATA.TXN_BALANCE, 0)) TXN_BALANCE,
                           SUM (COALESCE(GLDATA.CLOSING_BALANCE, 0)) CLOSING_BALANCE
                      FROM RAWTREE
                           LEFT JOIN GLDATA
                              ON (    RAWTREE.CHILD_CODE = GLDATA.GLCODE
                                  AND RAWTREE.CHILDTYPE = 'GL')
                           JOIN RAWTREE PAR
                              ON (RAWTREE.tree_parent_code = PAR.tree_child_code)
                           JOIN RAWTREE PAR1
                              ON (PAR.tree_parent_code = PAR1.tree_child_code)
                           JOIN RAWTREE PAR2
                              ON (PAR1.tree_parent_code = PAR2.tree_child_code)
                           JOIN RAWTREE PAR3
                              ON (PAR2.tree_parent_code = PAR3.tree_child_code)
                     WHERE RAWTREE.CHILDTYPE = 'GL'
                  GROUP BY PAR3.child_code,
                           PAR3.TREE,
                           PAR3.parent_code,
                           PAR3.tree_parent_code,
                           PAR3.childtype,
                           PAR3.tree_child_code,
                           PAR3.hierarchy_level,
                           PAR3.display_order
                  UNION ALL
                    SELECT 'GRP5'                            sec,
                           PAR4.child_code,
                           PAR4.TREE,
                           PAR4.parent_code,
                           PAR4.tree_parent_code,
                           PAR4.childtype,
                           PAR4.tree_child_code,
                           PAR4.hierarchy_level,
                           PAR4.display_order,
                           SUM (COALESCE(GLDATA.OPENING_BALANCE, 0)) OPENING_BALANCE,
                           SUM (COALESCE(GLDATA.TXN_BALANCE, 0)) TXN_BALANCE,
                           SUM (COALESCE(GLDATA.CLOSING_BALANCE, 0)) CLOSING_BALANCE
                      FROM RAWTREE
                           LEFT JOIN GLDATA
                              ON (    RAWTREE.CHILD_CODE = GLDATA.GLCODE
                                  AND RAWTREE.CHILDTYPE = 'GL')
                           JOIN RAWTREE PAR
                              ON (RAWTREE.tree_parent_code = PAR.tree_child_code)
                           JOIN RAWTREE PAR1
                              ON (PAR.tree_parent_code = PAR1.tree_child_code)
                           JOIN RAWTREE PAR2
                              ON (PAR1.tree_parent_code = PAR2.tree_child_code)
                           JOIN RAWTREE PAR3
                              ON (PAR2.tree_parent_code = PAR3.tree_child_code)
                           JOIN RAWTREE PAR4
                              ON (PAR3.tree_parent_code = PAR4.tree_child_code)
                     WHERE RAWTREE.CHILDTYPE = 'GL'
                  GROUP BY PAR4.child_code,
                           PAR4.TREE,
                           PAR4.parent_code,
                           PAR4.tree_parent_code,
                           PAR4.childtype,
                           PAR4.tree_child_code,
                           PAR4.hierarchy_level,
                           PAR4.display_order) p
        GROUP BY p.child_code,
                 p.TREE,
                 p.parent_code,
                 p.tree_parent_code,
                 p.childtype,
                 p.tree_child_code,
                 p.hierarchy_level,
                 p.display_order) t     
                 WHERE (   t.OPENING_BALANCE <> 0
                        OR t.TXN_BALANCE <> 0
                        OR t.CLOSING_BALANCE <> 0)               /*Start - CUSTOM WORK*/
UNION ALL
SELECT t.child_code,
       t.TREE,
       t.parent_code,
       t.tree_parent_code,
       t.childtype,
       t.tree_child_code,
       t.hierarchy_level,
       t.display_order,
       NULL                  OPENING_DEBIT,
       NULL                  OPENING_CREDIT,
       NULL                  OPENING_BALANCE,
       CASE WHEN TXN_CLOSING_BALANCE >= 0 THEN TXN_CLOSING_BALANCE ELSE 0 END TXN_DEBIT,
       CASE WHEN TXN_CLOSING_BALANCE < 0 THEN ABS (TXN_CLOSING_BALANCE) ELSE 0 END TXN_CREDIT,
       ABS (TXN_CLOSING_BALANCE)  TXN_BALANCE,
       CASE WHEN CLOSING_BALANCE >= 0 THEN CLOSING_BALANCE ELSE 0 END
          CLOSING_DEBIT,
       CASE WHEN CLOSING_BALANCE < 0 THEN ABS (CLOSING_BALANCE) ELSE 0 END
          CLOSING_CREDIT,
       ABS (CLOSING_BALANCE) CLOSING_BALANCE,
       0                     L2_OPENING_DEBIT,
       0                     L2_OPENING_CREDIT,
       0                     L2_OPENING_BALANCE,
       0                     L2_TXN_DEBIT,
       0                     L2_TXN_CREDIT,
       0                     L2_TXN_BALANCE,
       0                     L2_CLOSING_DEBIT,
       0                     L2_CLOSING_CREDIT,
       0                     L2_CLOSING_BALANCE
  FROM (SELECT child_code,
               TREE,
               parent_code,
               tree_parent_code,
               childtype,
               tree_child_code,
               hierarchy_level,
               display_order,
               COALESCE(TXN_STOCK_VALUE, 0) TXN_CLOSING_BALANCE,
               COALESCE(STOCK_VALUE, 0)   CLOSING_BALANCE
          FROM CUSTOM_CTE c CROSS JOIN RAWTREE t
         WHERE tree_child_code = 'GRP-1'
        UNION ALL
        SELECT child_code,
               TREE,
               parent_code,
               tree_parent_code,
               childtype,
               tree_child_code,
               hierarchy_level,
               display_order,
               COALESCE(TXN_SALES_VALUE, 0) - (COALESCE(TXN_STOCK_VALUE, 0))  TXN_CLOSING_BALANCE,
               COALESCE(SALES_VALUE, 0) - (COALESCE(STOCK_VALUE, 0))  CLOSING_BALANCE
          FROM CUSTOM_CTE CROSS JOIN RAWTREE t
         WHERE tree_child_code = 'GRP-2'
        UNION ALL
        SELECT child_code,
               TREE,
               parent_code,
               tree_parent_code,
               childtype,
               tree_child_code,
               hierarchy_level,
               display_order,
               CASE
                  WHEN COALESCE(TXN_SALES_VALUE, 0) = 0
                  THEN
                     0
                  ELSE
                     ROUND (
                          (  (  COALESCE(TXN_SALES_VALUE, 0)
                              - (  COALESCE(TXN_STOCK_VALUE, 0) ))
                           / COALESCE(TXN_SALES_VALUE, 0))
                        * 100,
                        2)
               END
                  TXN_CLOSING_BALANCE,
               CASE
                  WHEN COALESCE(SALES_VALUE, 0) = 0
                  THEN
                     0
                  ELSE
                     ROUND (
                          (  (  COALESCE(SALES_VALUE, 0)
                              - (COALESCE(STOCK_VALUE, 0) ))
                           / COALESCE(SALES_VALUE, 0))
                        * 100,
                        2)
               END
                  CLOSING_BALANCE
          FROM CUSTOM_CTE CROSS JOIN RAWTREE t
         WHERE tree_child_code = 'GRP-3') t
/*End - CUSTOM WORK*/