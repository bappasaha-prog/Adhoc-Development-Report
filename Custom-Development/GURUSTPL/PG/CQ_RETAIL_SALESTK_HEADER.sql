/*|| Custom Development || Object : CQ_RETAIL_SALESTK_HEADER || Ticket Id :  424726 || Developer : Dipankar ||*/

with pt as (SELECT q1.admsite_code,
       q1.icode,
       q1.salqty  saleqty,
       q1.stkqty,
       q1.closing_transit_quantity,
       q1.unsettled_sale_qty,
       q1.unsettled_stk_qty
  FROM (  SELECT t1.admsite_code,
                 t1.icode,
                 SUM (t1.salqty)              salqty,
                 SUM (t1.stkqty)              stkqty,
                 SUM (closing_transit_quantity) closing_transit_quantity,
                 SUM (unsettled_sale_qty)     unsettled_sale_qty,
                 SUM (unsettled_stk_qty)      unsettled_stk_qty
            FROM (
            SELECT admsite_code_owner ADMSITE_CODE,
       ICODE,
       SUM (D.invqty ) SALQTY,
       0           STKQTY,
       0           CLOSING_TRANSIT_QUANTITY,
       0           UNSETTLED_SALE_QTY,
       0           UNSETTLED_STK_QTY
  FROM salinvmain M INNER JOIN salinvdet D ON (M.invcode = D.invcode)
                           Where m.saletype = 'O'
                           AND (coalesce('@RetailChannelType@','-1') = '-1') 
                           AND m.invdt::date BETWEEN TO_DATE ('@DTFR@', 'yyyy-mm-dd')
                                            AND TO_DATE ('@DTTO@', 'yyyy-mm-dd')
                  GROUP BY m.admsite_code_owner , d.icode
                  union all
            SELECT ADMSITE_CODE,
       ICODE,
       SUM (D.QTY) SALQTY,
       0           STKQTY,
       0           CLOSING_TRANSIT_QUANTITY,
       0           UNSETTLED_SALE_QTY,
       0           UNSETTLED_STK_QTY
  FROM SALCSMAIN M INNER JOIN SALCSDET D ON (M.CSCODE = D.CSCODE)
                           Where (   (    coalesce (m.CHANNELTYPE, 'RTL') =
                                           '@RetailChannelType@'
                                    AND coalesce ('@RetailChannelType@', '-1') <> '-1')
                                OR coalesce ('@RetailChannelType@', '-1') = '-1') 
                           AND m.csdate BETWEEN TO_DATE ('@DTFR@', 'yyyy-mm-dd')
                                            AND TO_DATE ('@DTTO@', 'yyyy-mm-dd')
                  GROUP BY m.admsite_code, d.icode
UNION ALL
SELECT ADMSITE_CODE,
       ICODE,
       SUM (D.QTY) SALQTY,
       0           STKQTY,
       0           CLOSING_TRANSIT_QUANTITY,
       0           UNSETTLED_SALE_QTY,
       0           UNSETTLED_STK_QTY
  FROM SALSSMAIN M INNER JOIN SALSSDET D ON (M.SSCODE = D.SSCODE)
                           Where (   (    coalesce (m.CHANNELTYPE, 'RTL') =
                                           '@RetailChannelType@'
                                    AND coalesce ('@RetailChannelType@', '-1') <> '-1')
                                OR coalesce ('@RetailChannelType@', '-1') = '-1') 
                           AND m.ssdate BETWEEN TO_DATE ('@DTFR@', 'yyyy-mm-dd')
                                            AND TO_DATE ('@DTTO@', 'yyyy-mm-dd')
                  GROUP BY m.admsite_code, d.icode
                  UNION ALL
                    SELECT K.ADMSITE_CODE,
       ICODE,
       0                                                    SALQTY,
       SUM (CASE WHEN loctype <> 'T' THEN k.qty ELSE 0 END) STKQTY,
       SUM (CASE WHEN loctype = 'T' THEN k.qty ELSE 0 END)
          CLOSING_TRANSIT_QUANTITY,
       0
          UNSETTLED_SALE_QTY,
       0                                                    UNSETTLED_STK_QTY
  FROM INVSTOCK K INNER JOIN INVLOC L ON (K.LOCCODE = L.LOCCODE)
                           Where k.entdt <= TO_DATE ('@ASON@', 'yyyy-mm-dd')
                  GROUP BY k.admsite_code, k.icode
UNION ALL
SELECT PB.ADMSITE_CODE,
       ICODE,
       0         SALQTY,
       0         STKQTY,
       0         CLOSING_TRANSIT_QUANTITY,
       SUM (QTY) UNSETTLED_SALE_QTY,
       0         UNSETTLED_STK_QTY
  FROM PSITE_POSBILL_PARK PB
       INNER JOIN PSITE_POSBILLITEM_PARK PBI
          ON (PB.CODE = PSITE_POSBILL_CODE)
                           Where pb.billdate::date BETWEEN TO_DATE ('@DTFR@',
                                                                    'yyyy-mm-dd')
                                                       AND TO_DATE ('@DTTO@',
                                                                    'yyyy-mm-dd')
				           AND (('@RetailChannelType@' = '-1') OR ('@RetailChannelType@' = 'RTL')) 
                  GROUP BY pb.admsite_code, pbi.icode
                 )t1
                 inner join v_item i on (t1.icode = i.icode)
                 inner join admsite s on (t1.admsite_code = s.code)
                 Where (   (    i.lev1grpname = nullif('@Division@','')
                          AND coalesce (nullif('@Division@',''), '-1') <> '-1')
                      OR coalesce (nullif('@Division@',''), '-1') = '-1')
                 AND (   (    i.lev2grpname = nullif('@Section@','')
                          AND coalesce (nullif('@Section@',''), '-1') <> '-1')
                      OR coalesce (nullif('@Section@',''), '-1') = '-1')
                 AND (   (    i.grpname = nullif('@Department@','')
                          AND coalesce (nullif('@Department@',''), '-1') <> '-1')
                      OR coalesce (nullif('@Department@',''), '-1') = '-1')
                 AND (   (    nullif('@SiteTypeMSOS@','') IN ('MS-OO-CM',
                                                   'MS-CO-CM',
                                                   'MS-CO-OM-TS',
                                                   'OS-OO-CM')
                          AND (   (    coalesce (to_number(nullif('@SiteTypeSiteNameMSOS@',''),'9G999g999999999999d99'), -1) = -1
                                   AND sitetype = nullif('@SiteTypeMSOS@',''))
                               OR (    to_number(nullif('@SiteTypeSiteNameMSOS@',''),'9G999g999999999999d99') <> -1
                                   AND s.code = to_number(nullif('@SiteTypeSiteNameMSOS@',''),'9G999g999999999999d99'))))
                      OR (    coalesce (nullif('@SiteTypeMSOS@',''), '-1') = '-1'
                          AND (   (    coalesce (to_number(nullif('@SiteTypeSiteNameMSOS@',''),'9G999g999999999999d99'), -1) =
                                          -1
                                   AND sitetype IN ('MS-OO-CM',
                                                    'MS-CO-CM',
                                                    'MS-CO-OM-TS',
                                                    'OS-OO-CM'))
                               OR (    to_number(nullif('@SiteTypeSiteNameMSOS@',''),'9G999g999999999999d99') <> -1
                                   AND s.code = to_number(nullif('@SiteTypeSiteNameMSOS@',''),'9G999g999999999999d99')))))
        GROUP BY t1.admsite_code, t1.icode
          HAVING (   (SUM (salqty) + SUM (unsettled_sale_qty)) <> 0
                  OR SUM (closing_transit_quantity) <> 0
                  OR (SUM (stkqty) - SUM (unsettled_stk_qty)) <> 0)) q1
 WHERE (   (    to_number('@ShowSoldItemsOnly@','9G999g999999999999d99') = 1
            AND (salqty <> 0 OR unsettled_sale_qty <> 0))
        OR to_number('@ShowSoldItemsOnly@','9G999g999999999999d99') = 0))
        select 
         row_number() over() as UK,
         1 FF,
         MAX (CASE WHEN SEQ = 1 THEN I_SIZE ELSE NULL END) SIZE1,
         MAX (CASE WHEN SEQ = 2 THEN I_SIZE ELSE NULL END) SIZE2,
         MAX (CASE WHEN SEQ = 3 THEN I_SIZE ELSE NULL END) SIZE3,
         MAX (CASE WHEN SEQ = 4 THEN I_SIZE ELSE NULL END) SIZE4,
         MAX (CASE WHEN SEQ = 5 THEN I_SIZE ELSE NULL END) SIZE5,
         MAX (CASE WHEN SEQ = 6 THEN I_SIZE ELSE NULL END) SIZE6,
         MAX (CASE WHEN SEQ = 7 THEN I_SIZE ELSE NULL END) SIZE7,
         MAX (CASE WHEN SEQ = 8 THEN I_SIZE ELSE NULL END) SIZE8,
         MAX (CASE WHEN SEQ = 9 THEN I_SIZE ELSE NULL END) SIZE9,
         MAX (CASE WHEN SEQ = 10 THEN I_SIZE ELSE NULL END) SIZE10,
         MAX (CASE WHEN SEQ = 11 THEN I_SIZE ELSE NULL END) SIZE11,
         MAX (CASE WHEN SEQ = 12 THEN I_SIZE ELSE NULL END) SIZE12,
         MAX (CASE WHEN SEQ = 13 THEN I_SIZE ELSE NULL END) SIZE13,
         MAX (CASE WHEN SEQ = 14 THEN I_SIZE ELSE NULL END) SIZE14,
         MAX (CASE WHEN SEQ = 15 THEN I_SIZE ELSE NULL END) SIZE15
    FROM (SELECT DISTINCT
                 TRIM (I.CATEGORY3) I_SIZE,
                 DENSE_RANK ()
                    OVER ( ORDER BY TRIM (CONCAT (I.INVITEM_UDFSTRING07, I.CATEGORY3)))
                    SEQ
            FROM pt D INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE)