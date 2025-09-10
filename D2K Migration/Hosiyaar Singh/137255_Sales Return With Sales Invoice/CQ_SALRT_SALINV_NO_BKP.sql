SELECT ginview.fnc_uk uk,
       t2.rtcode,
       t2.section,
       t2.department,
       item_name,
       rt_item,
       hsn_code,
       uom,
       returned_quantity,
       returned_rate,
       scheme_docno,
       invdt,
       invqty,
       returned_rate rate
  FROM (  SELECT '@DocumentId@' rtcode,
                 rt_invcode,
                 section,
                 department,
                 rt_item,
                 M.SCHEME_DOCNO,
                 M.INVDT,
                 sum(d.invqty) invqty
                 /*due to different rate 2 records showing  d.invqty , d.rate*/
            FROM (  SELECT MAX (SALINVMAIN.INVCODE) RT_INVCODE, ITEM RT_ITEM
                      FROM SALINVDET, SALINVMAIN, V_ITEM
                     WHERE     SALINVDET.INVCODE = SALINVMAIN.INVCODE
                           AND SALINVDET.ICODE = V_ITEM.ICODE
                           AND SALINVMAIN.PCODE =
                                  (SELECT Pcode
                                     FROM salrtmain
                                    WHERE rtcode = '@DocumentId@')
                           AND V_ITEM.ITEM IN
                                  (SELECT item_name
                                     FROM ginview.lv_item
                                    WHERE code IN
                                             (SELECT icode
                                                FROM salrtdet
                                               WHERE rtcode = '@DocumentId@'))
                           AND SALINVMAIN.INVDT <=
                                  (SELECT rtdt
                                     FROM salrtmain
                                    WHERE rtcode = '@DocumentId@')
                  /*AND SALINVMAIN.INVCODE NOT IN
                         (SELECT MAIN.INVCODE
                            FROM SALINVMAIN MAIN,
                                 SALINVDET DET,
                                 V_ITEM   ITM,
                                 INVDCMAIN DC
                           WHERE     MAIN.INVCODE = DET.INVCODE
                                 AND MAIN.PCODE =
                                        (SELECT Pcode
                                           FROM salrtmain
                                          WHERE rtcode = '@DocumentId@')
                                 AND DET.ICODE = ITM.ICODE
                                 AND DET.DCCODE = DC.DCCODE
                                 AND ITM.ITEM =
                                        (SELECT item_name
                                           FROM invitem
                                          WHERE icode IN
                                                   (SELECT icode
                                                      FROM salrtdet
                                                     WHERE rtcode =
                                                              '@DocumentId@'))
                                 AND DC.OUTLOCCODE = 14795302
                                 AND MAIN.INVDT <=
                                        (SELECT rtdt
                                           FROM salrtmain
                                          WHERE rtcode = '@DocumentId@'))*/
                  GROUP BY ITEM) A,
                 Salinvmain M,
                 (  SELECT invcode,
                           section,
                           department,
                           item_name item,
                           SUM (invqty) invqty,
                           A.rate
                      FROM salinvdet A,
                           (SELECT code,
                                   section,
                                   department,
                                   item_name
                              FROM (  SELECT code,
                                             section,
                                             department,
                                             item_name,
                                             last_stock_inward_date,
                                             ROW_NUMBER ()
                                             OVER (
                                                PARTITION BY section,
                                                             department,
                                                             item_name
                                                ORDER BY
                                                   last_stock_inward_date DESC)
                                                Row_num
                                        FROM ginview.lv_item
                                    GROUP BY code,
                                             section,
                                             department,
                                             item_name,
                                             last_stock_inward_date)
                             WHERE row_num = 1
                             AND code in (SELECT icode
                                                FROM salrtdet
                                               WHERE rtcode = '@DocumentId@')) I
                     WHERE     A.icode = I.code
                           AND item_name IN
                                  (SELECT item_name
                                     FROM ginview.lv_item
                                    WHERE code IN
                                             (SELECT icode
                                                FROM salrtdet
                                               WHERE rtcode = '@DocumentId@'))
                  GROUP BY invcode,
                           section,
                           department,
                           item_name
                           ,A.rate) D
           WHERE     A.RT_INVCODE = M.INVCODE
                 AND A.RT_INVCODE = D.INVCODE
                 AND A.RT_ITEM = D.ITEM
        GROUP BY rt_invcode,
                 section,
                 department,
                 rt_item,
                 M.SCHEME_DOCNO,
                 M.INVDT
                 /*,d.invqty,
                 d.rate*/
        ORDER BY 4, 5) T1,
       (SELECT rtcode,
               section,
               department,
               item_name,
               HSN_CODE,
               UOM,
               returned_quantity,
               returned_rate
          FROM ginview.lv_salrt_item A, ginview.lv_item B
         WHERE A.icode = B.code AND rtcode = '@DocumentId@') T2
 WHERE T1.RTCODE(+) = T2.RTCODE AND T1.RT_ITEM(+) = T2.ITEM_NAME