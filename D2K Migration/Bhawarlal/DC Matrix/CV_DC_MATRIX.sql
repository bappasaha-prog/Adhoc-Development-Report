/* Formatted on 25-01-2022 14:00:05 (QP5 v5.294) */
CREATE OR REPLACE FORCE VIEW GINVIEW.CV_DC_MATRIX
AS
     SELECT ginview.fnc_uk                         UK,
            dccode,
            invarticle_code || ' : ' || article_name article,
            division,
            section,
            department,
               category1
            || ' '
            || category2
            || ' '
            || category3
            || ' '
            || category5
            || ' '
            || category6
               item,
            hsn_code,
            challan_rsp,
            mrp                                    mrp,
            wsp                                    wsp,
            challan_net_rate,
            TRIM (category4)                       Item_size,
            SUM (challan_quantity)                 qty
       FROM ginview.lv_dc_item A, ginview.lv_item B
      WHERE A.icode = B.code                               --AND dccode = 3135
   GROUP BY dccode,
            invarticle_code || ' : ' || article_name,
            division,
            section,
            department,
               category1
            || ' '
            || category2
            || ' '
            || category3
            || ' '
            || category5
            || ' '
            || category6,
            hsn_code,
            challan_rsp,
            mrp,
            WSP,
            challan_net_rate,
            TRIM (category4);