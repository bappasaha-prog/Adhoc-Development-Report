WITH RAWTREE AS (with RECURSIVE lev5 AS (
         SELECT fingrp.grpcode,
            fingrp.parcode,
            fingrp.grpname,
            1 AS level,
            fingrp.seq,
			array [cast( fingrp.seq::text || fingrp.grpcode::text as text)::text] hierchy
           FROM fingrp
          WHERE fingrp.grpcode = 1 
        UNION
         SELECT lev0.grpcode,
            lev0.parcode,
            lev0.grpname,
            lev5_1.level + 1,
            lev0.seq,
			lev5_1.hierchy || case when lev0.seq <= 9 then '0'||lev0.seq::TEXT else lev0.seq::TEXT end
			|| case when lev0.grpcode <=9 then '0'||lev0.grpcode::TEXT else lev0.grpcode::TEXT end AS hierchy
           FROM fingrp lev0  
             JOIN lev5 lev5_1 ON lev5_1.grpcode = lev0.parcode
        )
select code as grpcode,seq,
	parent_code, 
	level1,
	level2,
	level3,
	level4,
	level5,
	glcode,
	glseq,
	case when glcode = 35 then 'Stock Transfer Sent (On Cost)'
         when glcode = 48 then 'Stock Transfer Received (On Cost)' 
        else glname end
       as glname,
	gl.type, 
	hierchy,
	row_number() over (
  order by 
    case 
      when glname in ('COGS', 'Gross Profit', 'Gross Profit %') then 1
      else 0
    end,
    level1,
    hierchy,
    glseq
) display_order
from 
(select  lev5.seq, 
		CASE lev5.level - 1
            WHEN 1 THEN
            CASE
                WHEN upper(lev5.grpname::text) = 'ASSETS'::text THEN '01-Assets'::character varying
                WHEN upper(lev5.grpname::text) = 'LIABILITIES'::text THEN '02-Liabilities'::character varying
                WHEN upper(lev5.grpname::text) = 'INCOME'::text THEN '03-Income'::character varying
                WHEN upper(lev5.grpname::text) = 'EXPENSE'::text THEN '04-Expense'::character varying
                ELSE lev5.grpname
            END
            WHEN 2 THEN
            CASE
                WHEN upper(lev4.grpname::text) = 'ASSETS'::text THEN '01-Assets'::character varying
                WHEN upper(lev4.grpname::text) = 'LIABILITIES'::text THEN '02-Liabilities'::character varying
                WHEN upper(lev4.grpname::text) = 'INCOME'::text THEN '03-Income'::character varying
                WHEN upper(lev4.grpname::text) = 'EXPENSE'::text THEN '04-Expense'::character varying
                ELSE lev4.grpname
            END
            WHEN 3 THEN
            CASE
                WHEN upper(lev3.grpname::text) = 'ASSETS'::text THEN '01-Assets'::character varying
                WHEN upper(lev3.grpname::text) = 'LIABILITIES'::text THEN '02-Liabilities'::character varying
                WHEN upper(lev3.grpname::text) = 'INCOME'::text THEN '03-Income'::character varying
                WHEN upper(lev3.grpname::text) = 'EXPENSE'::text THEN '04-Expense'::character varying
                ELSE lev3.grpname
            END
            WHEN 4 THEN
            CASE
                WHEN upper(lev2.grpname::text) = 'ASSETS'::text THEN '01-Assets'::character varying
                WHEN upper(lev2.grpname::text) = 'LIABILITIES'::text THEN '02-Liabilities'::character varying
                WHEN upper(lev2.grpname::text) = 'INCOME'::text THEN '03-Income'::character varying
                WHEN upper(lev2.grpname::text) = 'EXPENSE'::text THEN '04-Expense'::character varying
                ELSE lev2.grpname
            END
            WHEN 5 THEN
            CASE
                WHEN upper(lev1.grpname::text) = 'ASSETS'::text THEN '01-Assets'::character varying
                WHEN upper(lev1.grpname::text) = 'LIABILITIES'::text THEN '02-Liabilities'::character varying
                WHEN upper(lev1.grpname::text) = 'INCOME'::text THEN '03-Income'::character varying
                WHEN upper(lev1.grpname::text) = 'EXPENSE'::text THEN '04-Expense'::character varying
                ELSE lev1.grpname
            END
            ELSE 'NA'::character varying
        END AS level1,
        CASE lev5.level - 1
            WHEN 2 THEN lev5.grpname
            WHEN 3 THEN lev4.grpname
            WHEN 4 THEN lev3.grpname
            WHEN 5 THEN lev2.grpname
            ELSE 'NA'::character varying
        END AS level2,
        CASE lev5.level - 1
            WHEN 3 THEN lev5.grpname
            WHEN 4 THEN lev4.grpname
            WHEN 5 THEN lev3.grpname
            ELSE 'NA'::character varying
        END AS level3,
        CASE lev5.level - 1
            WHEN 4 THEN lev5.grpname
            WHEN 5 THEN lev4.grpname
            ELSE 'NA'::character varying
        END AS level4, 
		CASE lev5.level - 1 
            WHEN 5 THEN lev5.grpname
            ELSE 'NA'::character varying
        END AS level5,
    lev5.grpcode AS code,
    lev5.parcode AS parent_code,
	hierchy 
   FROM fingrp lev4
     JOIN lev5 ON lev5.parcode = lev4.grpcode
     LEFT JOIN fingrp lev3 ON lev4.parcode = lev3.grpcode
     LEFT JOIN fingrp lev2 ON lev3.parcode = lev2.grpcode
     LEFT JOIN fingrp lev1 ON lev2.parcode = lev1.grpcode
	 order by hierchy) gr 
	 join (select 
		 		glcode,
				glseq,
				glname,
				grpcode,
				type
	 		from fingl where type in ('I','E')
			UNION
			SELECT -1 AS glcode, 
					97 AS seq,
					'COGS' AS glname, 
					14 AS parcode,
					NULL type
			UNION
			SELECT -2 AS grpcode, 
					98 AS seq, 
					'Gross Profit', 
					14 AS parcode,
					 NULL type
			UNION ALL
			SELECT -3 AS grpcode, 
					99 AS seq,  
					'Gross Profit %', 
					14 AS parcode,
					NULL type) gl on (gr.code=gl.grpcode)
	 order by display_order),
CUSTOM_CTE AS (  SELECT sitecode,
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
             FROM (  SELECT t.ref_admsite_code                        sitecode,
                            level3,
                            SUM (COALESCE(t.damount, 0) - COALESCE(t.camount, 0)) balance
                       FROM finpost p
                            JOIN fincosttag t ON p.postcode = t.postcode
                            JOIN fingl g ON t.glcode = g.glcode
                            JOIN GINVIEW.LV_CHART_OF_ACCOUNTS coa
                               ON g.grpcode = coa.CODE
                      WHERE     TYPE IN ('I', 'E') and g.glcode not in (35,48)
                            AND p.admou_code = nullif('@ConnOUCode@','')::int
                            AND (   TO_NUMBER ('@FinIncludeUnpostedRecords@',
                                               '9G999g999999999999d99') = 1
                                 OR (    TO_NUMBER (
                                            '@FinIncludeUnpostedRecords@',
                                            '9G999g999999999999d99') = 0
                                     AND p.RELEASE_STATUS = 'P')) 
                            AND p.entdt::date BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD') AND TO_DATE ('@DTTO@', 'YYYY-MM-DD') 
                            AND coa.level3 IN ('Stock Transfers',
                                             'Closing Stocks',
                                             'Opening Stocks',
                                             'Purchase',
                                             'Sales',
                                             'Other Incomes')
                   GROUP BY t.ref_admsite_code, level3
                    union all 
                    select d.admsite_code sitecode,
                      'Stock Transfers' level3,
                      sum (d.COSTAMOUNT) balance
                    from
                  (select k.admsite_code,
                          round(sum(coalesce(costamount,0))::numeric,2) COSTAMOUNT 
                    from invstock k 
                    join invloc l on (k.loccode=l.loccode and l.loctype <> 'T')
                  where k.entdt::date BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD') AND TO_DATE ('@DTTO@', 'YYYY-MM-DD') 
                    and enttype in ('STO','STI')
                    group by k.admsite_code) d
                     group by d.admsite_code)
         GROUP BY sitecode)
SELECT *
  FROM (  SELECT NULL                                                 requestid,
                 ginview.FNC_UK ()                                    uk,
                 grp.level1                                           level1,
                 CASE
                    WHEN '@Level@' IN ('Level2',
                                       'Level3',
                                       'Level4',
                                       'With Ledger')
                    THEN
                       grp.level2
                 END
                    level2,
                 CASE
                    WHEN '@Level@' IN ('Level3', 'Level4', 'With Ledger')
                    THEN
                       grp.level3
                 END
                    level3,
                 CASE
                    WHEN '@Level@' IN ('Level4', 'With Ledger') THEN grp.level4
                 END
                    level4,
                 CASE WHEN '@Level@' = 'With Ledger' THEN grp.glcode END glcode,
                 CASE WHEN '@Level@' = 'With Ledger' THEN grp.glname END glname,
                 t1.sitecode,
                 s.name sitename,
                 SUM (debit)                                          debit,
                 SUM (credit)                                         credit,
                 SUM (debit) - SUM (credit)                           balance,
                 SUM (debit) - SUM (credit) 			      L2_balance,
                 display_order
            FROM (SELECT t.glcode, 
                         t.ref_admsite_code sitecode,
                         CASE
                            WHEN COALESCE(t.damount, 0) - COALESCE(t.camount, 0) >= 0
                            THEN
                               COALESCE(t.damount, 0) - COALESCE(t.camount, 0)
                            ELSE
                               0
                         END
                            debit,
                         CASE
                            WHEN COALESCE(t.damount, 0) - COALESCE(t.camount, 0) < 0
                            THEN
                               0 - (COALESCE(t.damount, 0) - COALESCE(t.camount, 0))
                            ELSE
                               0
                         END
                            credit
                    FROM finpost p
                    join fincosttag t on p.postcode = t.postcode
                    join fingl g on (t.glcode = g.glcode AND g.TYPE IN ('I', 'E') and g.glcode not in (35,48))
                   WHERE p.entdt::date BETWEEN TO_DATE ('@DTFR@', 'yyyy-mm-dd')
                                         AND TO_DATE ('@DTTO@', 'yyyy-mm-dd')  
                         AND (   TO_NUMBER ('@FinIncludeUnpostedRecords@', 
                                            '9G999g999999999999d99') = 1
                              OR (    TO_NUMBER ('@FinIncludeUnpostedRecords@',
                                                 '9G999g999999999999d99') = 0
                                  AND p.RELEASE_STATUS = 'P'))
                         AND p.admou_code = nullif('@ConnOUCode@','')::int
                  UNION ALL 
                  select glcode,
                      admsite_code,
                      case when COSTAMOUNT >= 0 then COSTAMOUNT else 0 end debit,
                      case when COSTAMOUNT < 0 then 0 - COSTAMOUNT else 0 end credit
                    from
                  (select k.admsite_code, 
                          case enttype when 'STO' then 35 else 48 end GLCODE,
                          round(sum(coalesce(costamount,0))::numeric,2) COSTAMOUNT 
                    from invstock k 
                    join invloc l on (k.loccode=l.loccode and l.loctype <> 'T')
                  where k.entdt::date BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD') AND TO_DATE ('@DTTO@', 'YYYY-MM-DD') 
                    and enttype in ('STO','STI')
                    group by k.admsite_code, 
                            case enttype when 'STO' then 35 else 48 end) d  
                  UNION ALL
                  SELECT glcode, 
                         sitecode,
                         CASE
                            WHEN site_opening >= 0 THEN site_opening
                            ELSE 0
                         END
                            debit,
                         CASE
                            WHEN site_opening < 0 THEN site_opening * -1
                            ELSE 0
                         END
                            credit
                    FROM (  SELECT p1.glcode, 
                                   p1.sitecode,
                                   CASE
                                      WHEN (SELECT dtfr
                                              FROM admyear
                                             WHERE TO_DATE ('@DTFR@',
                                                            'yyyy-mm-dd') BETWEEN dtfr
                                                                              AND dtto) =
                                              TO_DATE ('@DTFR@', 'yyyy-mm-dd')
                                      THEN
                                           SUM (COALESCE(p1.damount, 0))
                                         - SUM (COALESCE(p1.camount, 0))
                                      ELSE
                                         0
                                   END
                                      site_opening
                              FROM (SELECT o.glcode, 
                                           o.admsite_code sitecode,
                                           COALESCE(o.damount, 0) damount,
                                           COALESCE(o.camount, 0) camount
                                      FROM fincosttag o
                                      join fingl g on (o.glcode = g.glcode AND g.TYPE IN ('I', 'E') and g.glcode not in (35,48) )
                                      join finpost p on o.postcode = p.postcode
                                     WHERE  (   TO_NUMBER (
                                                      '@FinIncludeUnpostedRecords@',
                                                      '9G999g999999999999d99') =
                                                      1
                                                OR (    TO_NUMBER (
                                                           '@FinIncludeUnpostedRecords@',
                                                           '9G999g999999999999d99') =
                                                           0
                                                    AND RELEASE_STATUS = 'P'))
                                           AND o.ycode =
                                                  (SELECT ycode
                                                     FROM admyear
                                                    WHERE TO_DATE ('@DTFR@',
                                                                   'yyyy-mm-dd') BETWEEN dtfr
                                                                                     AND dtto)
                                           AND o.entdt <
                                                  TO_DATE ('@DTFR@',
                                                           'yyyy-mm-dd')
                                           AND o.admou_code = nullif('@ConnOUCode@','')::int) P1
                          GROUP BY p1.glcode,  p1.sitecode)) t1
                          join rawtree grp on  t1.glcode=grp.glcode
                          join admsite s on t1.sitecode = s.code 
        GROUP BY grp.level1,
                 CASE
                    WHEN '@Level@' IN ('Level2',
                                       'Level3',
                                       'Level4',
                                       'With Ledger')
                    THEN
                       grp.level2
                 END,
                 CASE
                    WHEN '@Level@' IN ('Level3', 'Level4', 'With Ledger')
                    THEN
                       grp.level3
                 END,
                 CASE
                    WHEN '@Level@' IN ('Level4', 'With Ledger')
                    THEN
                       grp.level4
                 END,
                 CASE WHEN '@Level@' = 'With Ledger' THEN grp.glcode END,
                 CASE WHEN '@Level@' = 'With Ledger' THEN grp.glname END,
                 t1.sitecode,
                 s.name,
                 display_order)
 WHERE (   TO_NUMBER ('@FinIncludeZeroBalanceRecords@',
                      '9G999g999999999999d99') = 1
        OR (    TO_NUMBER ('@FinIncludeZeroBalanceRecords@',
                           '9G999g999999999999d99') = 0
            AND balance <> 0))                          
UNION ALL
  SELECT NULL                                                      requestid,
         ginview.FNC_UK ()                                         uk,
         NULL level1,
         NULL level2,
         NULL level3,
         NULL level4,
          grp.glcode glcode,
          grp.glname glname,
         t1.sitecode,
         s.name                                                    sitename,
         SUM (CASE WHEN balance >= 0 THEN balance ELSE 0 END)*-1      debit,
         SUM (CASE WHEN balance < 0 THEN balance ELSE 0 END)*-1       credit,
         SUM (balance)*-1                                             balance, 
         0 L2_balance,
         display_order
    FROM (SELECT sitecode,
                 -1                                          glcode,
                 'COGS'                                      glname,
                 COALESCE(STOCK_VALUE, 0) balance
            FROM CUSTOM_CTE c
          UNION ALL
          SELECT sitecode,
                 -2           glcode,
                 'Gross Profit' glname,
                   COALESCE(SALES_VALUE, 0)
                 - (COALESCE(STOCK_VALUE, 0))
                    balance
            FROM CUSTOM_CTE
          UNION ALL
          SELECT sitecode,
                 -3             glcode,
                 'Gross Profit %' glname,
                 CASE
                    WHEN COALESCE(SALES_VALUE, 0) = 0
                    THEN
                       0
                    ELSE
                       ROUND (
                            (  (  COALESCE(SALES_VALUE, 0)
                                - (  COALESCE(STOCK_VALUE, 0)))
                             / COALESCE(SALES_VALUE, 0))
                          * 100,
                          2)
                 END
                    balance
            FROM CUSTOM_CTE) t1
            join rawtree grp on t1.glcode=grp.glcode
         JOIN admsite s ON t1.sitecode = s.code
GROUP BY  grp.glcode ,
          grp.glname ,
         t1.sitecode,
         s.name,
         display_order