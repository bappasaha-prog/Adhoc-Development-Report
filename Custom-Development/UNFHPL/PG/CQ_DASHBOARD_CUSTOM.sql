 /*|| Custom Development || Object : CQ_DASHBOARD_CUSTOM || Ticket Id :  420308 || Developer : Dipankar ||*/
 
 WITH CUSTOM_AGE_SLAB AS(
		SELECT 1 CODE ,'0-30'   SLAB_NAME,	'0' SLAB_DAY_FROM,	'30' SLAB_DAY_TO
		UNION ALL
		SELECT  2 CODE,	'31-45' SLAB_NAME,	'31' SLAB_DAY_FROM,	'45' SLAB_DAY_TO
		UNION ALL
		SELECT  3 CODE,	'46-60' SLAB_NAME,	'46' SLAB_DAY_FROM, '60' SLAB_DAY_TO
		UNION ALL
		SELECT  4 CODE,	'61-90' SLAB_NAME,	'61' SLAB_DAY_FROM, 	'90' SLAB_DAY_TO
		UNION ALL
		SELECT  5 CODE,	'90 days or more'SLAB_NAME,	'91' SLAB_DAY_FROM,	'9999' SLAB_DAY_TO
		UNION ALL
		SELECT  6 CODE,	'Total'	SLAB_NAME,'' SLAB_DAY_FROM, '' SLAB_DAY_TO
		),date_range
             AS (SELECT CASE
           WHEN TO_CHAR(CURRENT_DATE, 'MM')::INTEGER < 4 THEN
               (DATE_TRUNC('YEAR', CURRENT_DATE) - INTERVAL '9 months')
           ELSE
               (DATE_TRUNC('YEAR', CURRENT_DATE) + INTERVAL '3 months')
         END AS FY_START_DATE,
         DATE_TRUNC('MONTH', CURRENT_DATE - INTERVAL '1 day') AS TM_START_DATE,
         CURRENT_DATE AS END_DATE
                          ),
        DATASET
     AS (  SELECT L.BRAND,
                  L.MONTH_NAME,
                  L.MCODE,
                  SUM (L.QTY)  QTY,
                  SUM (L.YTDQTY) YTDQTY,
                  SUM (L.AMOUNT) AMOUNT,
                  SUM (L.YTDAMT) YTDAMT
             FROM (  SELECT I.CATEGORY1              BRAND,
                            MON.MONTH_NAME,
                            MON.MCODE,
                            SUM (COALESCE (D.INVQTY, 0)) QTY,
                            SUM (SUM (COALESCE (D.INVQTY, 0)))
                               OVER (PARTITION BY I.CATEGORY1 ORDER BY MON.MCODE)
                               YTDQTY,
                            SUM (COALESCE (D.INVAMT, 0)) AMOUNT,
                            SUM (SUM (COALESCE (D.INVAMT, 0)))
                               OVER (PARTITION BY I.CATEGORY1 ORDER BY MON.MCODE)
                               YTDAMT
                       FROM SALINVMAIN M
                            INNER JOIN SALINVDET D ON M.INVCODE = D.INVCODE
                            INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
                            INNER JOIN ADMMONTH MON
                               ON MON.MONTH_NAME =
                                     TO_CHAR (M.INVDT::date,'MON-YY')
                      WHERE     M.SALETYPE = 'O'
                            AND I.CATEGORY1 IN ('FCUK',
                                                'FC',
                                                'PUMA',
                                                'MILOU')
                            and m.admou_code= 1
                            AND M.INVDT::date BETWEEN (SELECT DTFR
                                                           FROM ADMYEAR
                                                          WHERE CURRENT_DATE BETWEEN DTFR
                                                                                     AND DTTO)
                                                    AND CURRENT_DATE
                   GROUP BY I.CATEGORY1, MON.MONTH_NAME, MON.MCODE
                   UNION ALL
                     SELECT I.CATEGORY1              BRAND,
                            MON.MONTH_NAME,
                            MON.MCODE,
                            SUM (COALESCE (D.QTY, 0)) QTY,
                            SUM (SUM (COALESCE (D.QTY, 0)))
                               OVER (PARTITION BY I.CATEGORY1 ORDER BY MON.MCODE)
                               YTDQTY,
                            SUM (COALESCE (D.NETAMT, 0)) AMOUNT,
                            SUM (SUM (COALESCE (D.NETAMT, 0)))
                               OVER (PARTITION BY I.CATEGORY1 ORDER BY MON.MCODE)
                               YTDAMT
                       FROM SALCSMAIN M
                            INNER JOIN SALCSDET D ON M.CSCODE = D.CSCODE
                            INNER JOIN ADMMONTH MON
                               ON MON.MONTH_NAME =
                                     TO_CHAR (M.CSDATE::date, 'MON-YY')
                            INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
                      WHERE     I.CATEGORY1 IN ('FCUK',
                                                'FC',
                                                'PUMA',
                                                'MILOU')
                            and m.admou_code= 1
                            AND M.CSDATE::date BETWEEN (SELECT DTFR
                                                            FROM ADMYEAR
                                                           WHERE CURRENT_DATE BETWEEN DTFR
                                                                                      AND DTTO)
                                                     AND CURRENT_DATE
                   GROUP BY I.CATEGORY1, MON.MONTH_NAME, MON.MCODE) L
         GROUP BY L.BRAND, L.MONTH_NAME, L.MCODE)
        SELECT ROW_NUMBER() OVER() UK,
               seq,
               admou_code,
               Particulars,
               brand,
               detail,
               qty,
               AMOUNT,
               YTDAMT,
		       AVG_PRICE,
		       AVF_QTY_PERCENTAGE,
		       AVF_YTDQTY_PERCENTAGE,
		       AVF_AMOUNT_PERCENTAGE,
		       AVF_YTDAMT_PERCENTAGE,
		       REPSEQ,
		       MCODE
          FROM (  SELECT '1.01'             seq,
                         admou_code,
                         'Sales'            Particulars,
                         NULL               brand,
                         'Yesterday'        detail,
                         SUM (SALE_QTY)::bigint     qty,
                         SUM (TAXABLE_AMOUNT) AMOUNT,
                         0 YTDAMT,
		       0 AVG_PRICE,
		       0 AVF_QTY_PERCENTAGE,
		       0 AVF_YTDQTY_PERCENTAGE,
		       0 AVF_AMOUNT_PERCENTAGE,
		       0 AVF_YTDAMT_PERCENTAGE,
		       0 REPSEQ,
		       0 MCODE
                    FROM ginview.CV_ALL_SALE
                   WHERE     bill_date = (SELECT END_DATE FROM date_range)
                         AND admou_code = '1'
                GROUP BY admou_code
                UNION ALL
                  SELECT '1.02'             seq,
                         admou_code,
                         'Sales'            Particulars,
                         NULL               brand,
                         'MTD'              detail,
                         SUM (SALE_QTY)::bigint      qty,
                         SUM (TAXABLE_AMOUNT) AMOUNT,
                         0 YTDAMT,
		       0 AVG_PRICE,
		       0 AVF_QTY_PERCENTAGE,
		       0 AVF_YTDQTY_PERCENTAGE,
		       0 AVF_AMOUNT_PERCENTAGE,
		       0 AVF_YTDAMT_PERCENTAGE,
		       0 REPSEQ,
		       0 MCODE
                    FROM ginview.CV_ALL_SALE
                   WHERE     bill_date BETWEEN (SELECT TM_START_DATE
                                                  FROM date_range)
                                           AND (SELECT END_DATE
                                                  FROM date_range)
                         AND admou_code = '1'
                GROUP BY admou_code
                UNION ALL
                  SELECT '1.03'             seq,
                         admou_code,
                         'Sales'            Particulars,
                         NULL               brand,
                         'YTD'              detail,
                         SUM (SALE_QTY)::bigint      qty,
                         SUM (TAXABLE_AMOUNT) AMOUNT,
                         0 YTDAMT,
		       0 AVG_PRICE,
		       0 AVF_QTY_PERCENTAGE,
		       0 AVF_YTDQTY_PERCENTAGE,
		       0 AVF_AMOUNT_PERCENTAGE,
		       0 AVF_YTDAMT_PERCENTAGE,
		       0 REPSEQ,
		       0 MCODE
                    FROM ginview.CV_ALL_SALE
                   WHERE     bill_date BETWEEN (SELECT FY_START_DATE
                                                  FROM date_range)
                                           AND (SELECT END_DATE
                                                  FROM date_range)
                         AND admou_code = '1'
                GROUP BY admou_code
                UNION ALL 
                SELECT    '2.'
                       || CASE
                             WHEN seq <= 9 THEN '0' || seq::text
                             ELSE seq::text
                          END
                          seq,
                       admou_code,
                       Particulars,
                       coalesce(brand,'Others') brand,
                       detail,
                       qty::bigint ,
                       AMOUNT,
                       0 YTDAMT,
		       0 AVG_PRICE,
		       0 AVF_QTY_PERCENTAGE,
		       0 AVF_YTDQTY_PERCENTAGE,
		       0 AVF_AMOUNT_PERCENTAGE,
		       0 AVF_YTDAMT_PERCENTAGE,
		       0 REPSEQ,
		       0 MCODE
                  FROM (  SELECT ROW_NUMBER ()
                                 OVER (PARTITION BY admou_code
                                       ORDER BY admou_code, brand)
                                    seq,
                                 admou_code,
                                 'Sales'            Particulars,
                                 brand,
                                 'YTD'              detail,
                                 SUM (SALE_QTY)::bigint      qty,
                                 SUM (TAXABLE_AMOUNT) AMOUNT
                            FROM ginview.CV_ALL_SALE
                           WHERE     bill_date BETWEEN (SELECT FY_START_DATE
                                                          FROM date_range)
                                                   AND (SELECT END_DATE
                                                          FROM date_range)
                                 AND admou_code = '1'
                        GROUP BY admou_code,  brand 
                        UNION ALL
                        SELECT  99 seq,
                                 admou_code,
                                 'Sales'            Particulars,
                                 'Total',
                                 'YTD'              detail,
                                 SUM (SALE_QTY)::bigint      qty,
                                 SUM (TAXABLE_AMOUNT) AMOUNT
                            FROM ginview.CV_ALL_SALE
                           WHERE     bill_date BETWEEN (SELECT FY_START_DATE
                                                          FROM date_range)
                                                   AND (SELECT END_DATE
                                                          FROM date_range)
                                 AND admou_code = '1'
                        GROUP BY admou_code ) 
                UNION ALL
                SELECT    '3.'
                       || CASE
                             WHEN seq <= 9 THEN '0' || seq::text
                             ELSE seq::text
                          END
                          seq,
                       admou_code,
                       Particulars,
                       coalesce(brand,'Others'),
                       detail,
                       qty::bigint ,
                       AMOUNT,
                       0 YTDAMT,
		       0 AVG_PRICE,
		       0 AVF_QTY_PERCENTAGE,
		       0 AVF_YTDQTY_PERCENTAGE,
		       0 AVF_AMOUNT_PERCENTAGE,
		       0 AVF_YTDAMT_PERCENTAGE,
		       0 REPSEQ,
		       0 MCODE
                  FROM (  SELECT ROW_NUMBER ()
                                 OVER (PARTITION BY s.admou_code
                                       ORDER BY s.admou_code, category1)
                                    seq,
                                 s.admou_code,
                                 'SOH'          Particulars,
                                 category1      brand,
                                 'As on Stock'  detail,
                                 SUM (QTY)::bigint       qty,
                                 SUM (costamount) amount
                            FROM invstock k
                                 INNER JOIN admsite s
                                    ON k.admsite_code = s.code
                                 INNER JOIN ginview.lv_item i
                                    ON k.icode = i.code
                           WHERE s.admou_code = '1'
                        GROUP BY s.admou_code,  category1 
                        UNION ALL
                        SELECT 99 seq,
                                 s.admou_code,
                                 'SOH'          Particulars,
                                 'Total'      brand,
                                 'As on Stock'  detail,
                                 SUM (QTY)::bigint       qty,
                                 SUM (costamount) amount
                            FROM invstock k
                                 INNER JOIN admsite s
                                    ON k.admsite_code = s.code
                                 INNER JOIN ginview.lv_item i
                                    ON k.icode = i.code
                           WHERE s.admou_code = '1'
                        GROUP BY s.admou_code )
                UNION ALL
                SELECT '4.0'::text || s.CODE::text seq,
                       admou_code,
                       'Ageing'        Particulars,
                       s.SLAB_NAME     brand,
                       NULL            detail,
                       NULL::bigint             qty,
                       balance_amount  amount,
                       0 YTDAMT,
		       0 AVG_PRICE,
		       0 AVF_QTY_PERCENTAGE,
		       0 AVF_YTDQTY_PERCENTAGE,
		       0 AVF_AMOUNT_PERCENTAGE,
		       0 AVF_YTDAMT_PERCENTAGE,
		       0 REPSEQ,
		       0 MCODE
                  FROM custom_age_slab s
                       LEFT OUTER JOIN
                       (  SELECT admou_code,
                                 OUTSTANDING_AGE_SLAB,
                                 SUM (balance_amount) balance_amount
                            FROM ginview.CV_OTSD t
                                 INNER JOIN fingl g
                                    ON     t.glcode = g.glcode
                                       AND g.glcode IN (14, 1037, 1097) /*Sundry Debtors, Sundry Debtors for Goods, Sundry Debtors - Online*/
                                       AND t.admou_code = '1'
                        GROUP BY admou_code, OUTSTANDING_AGE_SLAB
                        UNION ALL
                        SELECT NULL                 admou_code,
                               'Total'              OUTSTANDING_AGE_SLAB,
                               SUM (balance_amount) balance_amount
                          FROM ginview.CV_OTSD t
                               INNER JOIN fingl g
                                  ON     t.glcode = g.glcode
                                     AND g.glcode IN (14, 1037, 1097) /*Sundry Debtors, Sundry Debtors for Goods, Sundry Debtors - Online*/
                                     AND t.admou_code = '1') t
                          ON s.SLAB_NAME = t.OUTSTANDING_AGE_SLAB
                UNION ALL
                SELECT '5.0'::text || s.CODE::text seq,
                       admou_code,
                       'Ageing'        Particulars,
                       s.SLAB_NAME     brand,
                       NULL            detail,
                       NULL::bigint             qty,
                       balance_amount  amount,
                       0 YTDAMT,
		       0 AVG_PRICE,
		       0 AVF_QTY_PERCENTAGE,
		       0 AVF_YTDQTY_PERCENTAGE,
		       0 AVF_AMOUNT_PERCENTAGE,
		       0 AVF_YTDAMT_PERCENTAGE,
		       0 REPSEQ,
		       0 MCODE
                  FROM custom_age_slab s
                       LEFT OUTER JOIN
                       (  SELECT admou_code,
                                 OUTSTANDING_AGE_SLAB,
                                 SUM (balance_amount) balance_amount
                            FROM ginview.CV_OTSD t
                                 INNER JOIN fingl g
                                    ON     t.glcode = g.glcode
                                       AND g.glcode IN (1099,
                                                        25,
                                                        24,
                                                        26) /*Sundry Creditors for Expenses, Sundry Creditors for Fixed Assets, Sundry Creditors for Goods, Sundry Creditors  - Logistics*/
                                       AND t.admou_code = '1'
                        GROUP BY admou_code, OUTSTANDING_AGE_SLAB
                        UNION ALL
                        SELECT NULL                 admou_code,
                               'Total'              OUTSTANDING_AGE_SLAB,
                               SUM (balance_amount) balance_amount
                          FROM ginview.CV_OTSD t
                               INNER JOIN fingl g
                                  ON     t.glcode = g.glcode
                                     AND g.glcode IN (1099,
                                                      25,
                                                      24,
                                                      26) /*Sundry Debtors, Sundry Debtors for Goods, Sundry Debtors - Online*/
                                     AND t.admou_code = '1') t
                          ON s.SLAB_NAME = t.OUTSTANDING_AGE_SLAB
                union all
SELECT 
	   '6.01'::TEXT seq,
	   null::int admou_code,
       F.MONTH_NAME particulars,
       F.BRAND,
       F.QTY::TEXT detail,
       F.AMOUNT qty,
       F.YTDQTY AMOUNT,
       F.YTDAMT,
       ROUND(case when F.YTDQTY = 0 then 0 else F.YTDAMT/F.YTDQTY end ,2) AVG_PRICE,
       F.AVF_QTY_PERCENTAGE,
       F.AVF_YTDQTY_PERCENTAGE,
       F.AVF_AMOUNT_PERCENTAGE,
       F.AVF_YTDAMT_PERCENTAGE,
       F.REPSEQ,
       F.MCODE
  FROM (select   BRAND,
                 REPSEQ,
                 MONTH_NAME,
                 MCODE,
                 QTY,
                 YTDQTY,
                 AMOUNT,
                 YTDAMT,
                 AVF_QTY_PERCENTAGE,
                 AVF_YTDQTY_PERCENTAGE,
                 AVF_AMOUNT_PERCENTAGE,
                 AVF_YTDAMT_PERCENTAGE
                 from (SELECT 'ALL BRAND'  BRAND,
                 1            REPSEQ,
                 D.MONTH_NAME,
                 D.MCODE,
                 SUM (D.QTY)  QTY,
                 SUM (D.YTDQTY) YTDQTY,
                 SUM (D.AMOUNT) AMOUNT,
                 SUM (D.YTDAMT) YTDAMT,
                 100          AVF_QTY_PERCENTAGE,
                 100          AVF_YTDQTY_PERCENTAGE,
                 100          AVF_AMOUNT_PERCENTAGE,
                 100          AVF_YTDAMT_PERCENTAGE
            FROM DATASET D
        GROUP BY MONTH_NAME, D.MCODE
        UNION all
        SELECT 'Total FCUK, FC and PUMA'  BRAND,
                 2            REPSEQ,
                 D.MONTH_NAME,
                 D.MCODE,
                 SUM (D.QTY)  QTY,
                 SUM (D.YTDQTY) YTDQTY,
                 SUM (D.AMOUNT) AMOUNT,
                 SUM (D.YTDAMT) YTDAMT,
                 CASE
                  WHEN SUM(SUM (D.QTY))
                       OVER (PARTITION BY D.MONTH_NAME ORDER BY D.MONTH_NAME) =
                          0
                  THEN
                     0
                  ELSE
                       ROUND (
                            SUM(D.QTY)
                          / SUM(SUM (
                               D.QTY))
                            OVER (PARTITION BY D.MONTH_NAME
                                  ORDER BY D.MONTH_NAME),
                          2)
                     * 100
               END
                  AVF_QTY_PERCENTAGE,
               CASE
                  WHEN SUM(SUM (D.YTDQTY))
                       OVER (PARTITION BY D.MONTH_NAME ORDER BY D.MONTH_NAME) =
                          0
                  THEN
                     0
                  ELSE
                       ROUND (
                            SUM(D.YTDQTY)
                          / SUM(SUM (
                               D.YTDQTY))
                            OVER (PARTITION BY D.MONTH_NAME
                                  ORDER BY D.MONTH_NAME),
                          2)
                     * 100
               END
                  AVF_YTDQTY_PERCENTAGE,
               CASE
                  WHEN SUM(SUM (D.AMOUNT))
                       OVER (PARTITION BY D.MONTH_NAME ORDER BY D.MONTH_NAME) =
                          0
                  THEN
                     0
                  ELSE
                       ROUND (
                            SUM(D.AMOUNT)
                          / SUM(SUM (
                               D.AMOUNT))
                            OVER (PARTITION BY D.MONTH_NAME
                                  ORDER BY D.MONTH_NAME),
                          2)
                     * 100
               END
                  AVF_AMOUNT_PERCENTAGE,
               CASE
                  WHEN SUM(SUM (D.YTDAMT))
                       OVER (PARTITION BY D.MONTH_NAME ORDER BY D.MONTH_NAME) =
                          0
                  THEN
                     0
                  ELSE
                       ROUND (
                            SUM(D.YTDAMT)
                          / SUM(SUM (
                               D.YTDAMT))
                            OVER (PARTITION BY D.MONTH_NAME
                                  ORDER BY D.MONTH_NAME),
                          2)
                     * 100
               END
                  AVF_YTDAMT_PERCENTAGE
            FROM DATASET D
        where D.BRAND IN ('FCUK','FC','PUMA')
        GROUP BY MONTH_NAME, D.MCODE
        UNION all
        SELECT 'Total FCUK and FC'  BRAND,
                 3            REPSEQ,
                 D.MONTH_NAME,
                 D.MCODE,
                 SUM (D.QTY)  QTY,
                 SUM (D.YTDQTY) YTDQTY,
                 SUM (D.AMOUNT) AMOUNT,
                 SUM (D.YTDAMT) YTDAMT,
                 CASE
                  WHEN SUM(SUM (D.QTY))
                       OVER (PARTITION BY D.MONTH_NAME ORDER BY D.MONTH_NAME) =
                          0
                  THEN
                     0
                  ELSE
                       ROUND (
                            SUM(D.QTY)
                          / SUM(SUM (
                               D.QTY))
                            OVER (PARTITION BY D.MONTH_NAME
                                  ORDER BY D.MONTH_NAME),
                          2)
                     * 100
               END
                  AVF_QTY_PERCENTAGE,
               CASE
                  WHEN SUM(SUM (D.YTDQTY))
                       OVER (PARTITION BY D.MONTH_NAME ORDER BY D.MONTH_NAME) =
                          0
                  THEN
                     0
                  ELSE
                       ROUND (
                            SUM(D.YTDQTY)
                          / SUM(SUM (
                               D.YTDQTY))
                            OVER (PARTITION BY D.MONTH_NAME
                                  ORDER BY D.MONTH_NAME),
                          2)
                     * 100
               END
                  AVF_YTDQTY_PERCENTAGE,
               CASE
                  WHEN SUM(SUM (D.AMOUNT))
                       OVER (PARTITION BY D.MONTH_NAME ORDER BY D.MONTH_NAME) =
                          0
                  THEN
                     0
                  ELSE
                       ROUND (
                            SUM(D.AMOUNT)
                          / SUM(SUM (
                               D.AMOUNT))
                            OVER (PARTITION BY D.MONTH_NAME
                                  ORDER BY D.MONTH_NAME),
                          2)
                     * 100
               END
                  AVF_AMOUNT_PERCENTAGE,
               CASE
                  WHEN SUM(SUM (D.YTDAMT))
                       OVER (PARTITION BY D.MONTH_NAME ORDER BY D.MONTH_NAME) =
                          0
                  THEN
                     0
                  ELSE
                       ROUND (
                            SUM(D.YTDAMT)
                          / SUM(SUM (
                               D.YTDAMT))
                            OVER (PARTITION BY D.MONTH_NAME
                                  ORDER BY D.MONTH_NAME),
                          2)
                     * 100
               END
                  AVF_YTDAMT_PERCENTAGE
            FROM DATASET D
        where D.BRAND IN ('FCUK','FC')
        GROUP BY MONTH_NAME, D.MCODE
        union ALL
        SELECT D.BRAND,
               CASE
                  WHEN D.BRAND = 'FCUK' THEN 4
                  WHEN D.BRAND = 'FC' THEN 5
                  WHEN D.BRAND = 'PUMA' THEN 6
                  WHEN D.BRAND = 'MILOU' THEN 7
               END
                  AS REPSEQ,
               D.MONTH_NAME,
               D.MCODE,
               D.QTY,
               D.YTDQTY,
               D.AMOUNT,
               D.YTDAMT,
               CASE
                  WHEN SUM (D.QTY)
                       OVER (PARTITION BY D.MONTH_NAME ORDER BY D.MONTH_NAME) =
                          0
                  THEN
                     0
                  ELSE
                       ROUND (
                            D.QTY
                          / SUM (
                               D.QTY)
                            OVER (PARTITION BY D.MONTH_NAME
                                  ORDER BY D.MONTH_NAME),
                          2)
                     * 100
               END
                  AVF_QTY_PERCENTAGE,
               CASE
                  WHEN SUM (D.YTDQTY)
                       OVER (PARTITION BY D.MONTH_NAME ORDER BY D.MONTH_NAME) =
                          0
                  THEN
                     0
                  ELSE
                       ROUND (
                            D.YTDQTY
                          / SUM (
                               D.YTDQTY)
                            OVER (PARTITION BY D.MONTH_NAME
                                  ORDER BY D.MONTH_NAME),
                          2)
                     * 100
               END
                  AVF_YTDQTY_PERCENTAGE,
               CASE
                  WHEN SUM (D.AMOUNT)
                       OVER (PARTITION BY D.MONTH_NAME ORDER BY D.MONTH_NAME) =
                          0
                  THEN
                     0
                  ELSE
                       ROUND (
                            D.AMOUNT
                          / SUM (
                               D.AMOUNT)
                            OVER (PARTITION BY D.MONTH_NAME
                                  ORDER BY D.MONTH_NAME),
                          2)
                     * 100
               END
                  AVF_AMOUNT_PERCENTAGE,
               CASE
                  WHEN SUM (D.YTDAMT)
                       OVER (PARTITION BY D.MONTH_NAME ORDER BY D.MONTH_NAME) =
                          0
                  THEN
                     0
                  ELSE
                       ROUND (
                            D.YTDAMT
                          / SUM (
                               D.YTDAMT)
                            OVER (PARTITION BY D.MONTH_NAME
                                  ORDER BY D.MONTH_NAME),
                          2)
                     * 100
               END
                  AVF_YTDAMT_PERCENTAGE
          FROM DATASET D) order by REPSEQ,MCODE) F
                UNION ALL
                  SELECT '7.01'                                        seq,
                         p.admou_code,
                         grp.GRPNAME                                   Particulars,
                         NULL                                          brand,
                         NULL                                          detail,
                         NULL::bigint                                           qty,
                         SUM (coalesce (damount, 0)) - SUM (coalesce (camount, 0)) amount,
                         0 YTDAMT,
		       0 AVG_PRICE,
		       0 AVF_QTY_PERCENTAGE,
		       0 AVF_YTDQTY_PERCENTAGE,
		       0 AVF_AMOUNT_PERCENTAGE,
		       0 AVF_YTDAMT_PERCENTAGE,
		       8 REPSEQ,
		       9999999 MCODE
                    FROM finpost p
                         INNER JOIN fingl g ON p.glcode = g.glcode
                         INNER JOIN fingrp grp ON g.grpcode = grp.grpcode
                   WHERE     g.grpcode = 2437          /*Distributor Deposit*/
                         AND entdt::date <= current_date::date
                         AND p.admou_code = '1'
                         AND release_status = 'P'
                GROUP BY p.admou_code, grp.GRPNAME
                UNION ALL
                SELECT    '8.'
                       || CASE
                             WHEN seq <= 9 THEN '0' || seq::text
                             ELSE seq::text
                          END
                          seq,
                       admou_code,
                       Particulars,
                       brand,
                       detail,
                       qty::bigint ,
                       AMOUNT,
                       0 YTDAMT,
		       0 AVG_PRICE,
		       0 AVF_QTY_PERCENTAGE,
		       0 AVF_YTDQTY_PERCENTAGE,
		       0 AVF_AMOUNT_PERCENTAGE,
		       0 AVF_YTDAMT_PERCENTAGE,
		       9 REPSEQ,
		       9999999 MCODE
                  FROM (  SELECT ROW_NUMBER ()
                                 OVER (PARTITION BY p.admou_code
                                       ORDER BY p.admou_code, g.GLNAME)
                                    seq,
                                 p.admou_code,
                                 g.GLNAME Particulars,
                                 NULL   brand,
                                 NULL   detail,
                                 NULL::bigint    qty,
                                   SUM (coalesce (damount, 0))
                                 - SUM (coalesce (camount, 0))
                                    amount
                            FROM finpost p
                                 INNER JOIN fingl g ON p.glcode = g.glcode
                           WHERE     g.grpcode = 48                /*Deposit*/
                                 AND entdt <= (SELECT END_DATE FROM date_range)
                                 AND p.admou_code = '1'
                                 AND release_status = 'P'
                        GROUP BY p.admou_code,  g.GLNAME 
                        UNION ALL
                        SELECT 99 seq,
                                 p.admou_code,
                                 NULL Particulars,
                                 'Total'   brand,
                                 NULL   detail,
                                 NULL::bigint    qty,
                                   SUM (coalesce (damount, 0))
                                 - SUM (coalesce (camount, 0))
                                    amount
                            FROM finpost p
                                 INNER JOIN fingl g ON p.glcode = g.glcode
                           WHERE     g.grpcode = 48                /*Deposit*/
                                 AND entdt <= (SELECT END_DATE FROM date_range)
                                 AND p.admou_code = '1'
                                 AND release_status = 'P'
                        GROUP BY p.admou_code )
                UNION ALL
                SELECT    '9.'
                       || CASE
                             WHEN seq <= 9 THEN '0' || seq::text
                             ELSE seq::text
                          END
                          seq,
                       admou_code,
                       Particulars,
                       brand,
                       detail,
                       qty::bigint ,
                       AMOUNT,
                       0 YTDAMT,
		       0 AVG_PRICE,
		       0 AVF_QTY_PERCENTAGE,
		       0 AVF_YTDQTY_PERCENTAGE,
		       0 AVF_AMOUNT_PERCENTAGE,
		       0 AVF_YTDAMT_PERCENTAGE,
		       10 REPSEQ,
		       9999999 MCODE
                  FROM (  SELECT ROW_NUMBER ()
                                 OVER (PARTITION BY p.admou_code
                                       ORDER BY p.admou_code, g.GLNAME)
                                    seq,
                                 p.admou_code,
                                 g.glname Particulars,
                                 NULL   brand,
                                 NULL   detail,
                                 NULL::bigint    qty,
                                   SUM (coalesce (damount, 0))
                                 - SUM (coalesce (camount, 0))
                                    amount
                            FROM finpost p
                                 INNER JOIN fingl g ON p.glcode = g.glcode
                           WHERE     g.grpcode IN (44)        /*Bank Account*/
                                 AND p.admou_code = '1'
                                 AND release_status = 'P'
                                 AND g.glname NOT LIKE '%OD%'
                        GROUP BY p.admou_code,  g.glname 
                        UNION ALL
                         SELECT 99 seq,
                                 p.admou_code,
                                 NULL Particulars,
                                 'Total'   brand,
                                 NULL   detail,
                                 NULL::bigint    qty,
                                   SUM (coalesce (damount, 0))
                                 - SUM (coalesce (camount, 0))
                                    amount
                            FROM finpost p
                                 INNER JOIN fingl g ON p.glcode = g.glcode
                           WHERE     g.grpcode IN (44)        /*Bank Account*/
                                 AND p.admou_code = '1'
                                 AND release_status = 'P'
                                 AND g.glname NOT LIKE '%OD%'
                        GROUP BY p.admou_code )
                UNION ALL
                SELECT    '10.'
                       || CASE
                             WHEN seq <= 9 THEN '0' || seq::text
                             ELSE seq::text
                          END
                          seq,
                       admou_code,
                       Particulars,
                       brand,
                       detail,
                       qty::bigint ,
                       AMOUNT,
                       0 YTDAMT,
		       0 AVG_PRICE,
		       0 AVF_QTY_PERCENTAGE,
		       0 AVF_YTDQTY_PERCENTAGE,
		       0 AVF_AMOUNT_PERCENTAGE,
		       0 AVF_YTDAMT_PERCENTAGE,
		       11 REPSEQ,
		       9999999 MCODE
                  FROM (  SELECT ROW_NUMBER ()
                                 OVER (PARTITION BY p.admou_code
                                       ORDER BY p.admou_code, g.GLNAME)
                                    seq,
                                 p.admou_code,
                                 g.glname Particulars,
                                 NULL   brand,
                                 NULL   detail,
                                 NULL::bigint    qty,
                                   SUM (coalesce (damount, 0))
                                 - SUM (coalesce (camount, 0))
                                    amount
                            FROM finpost p
                                 INNER JOIN fingl g ON p.glcode = g.glcode
                           WHERE     g.grpcode IN (44, 52)    /*Bank Account*/
                                 AND entdt <= (SELECT END_DATE FROM date_range)
                                 AND p.admou_code = '1'
                                 AND release_status = 'P'
                                 AND g.glname LIKE '%OD%'
                        GROUP BY p.admou_code, g.glname)) 