/*CV_PO_ITEM_SETBARCODE*/
DROP VIEW GINVIEW.CV_PO_ITEM_SETBARCODE;

/* Formatted on 2022/08/10 13:07 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW ginview.cv_po_item_setbarcode (uk,
                                                            ordcode,
                                                            set_barcode,
                                                            item_code,
                                                            hsn,
                                                            item,
                                                            color,
                                                            desc1,
                                                            item_size,
                                                            no_color,
                                                            set_qty,
                                                            single_set_qty,
                                                            mrp,
                                                            listed_mrp,
                                                            rate,
                                                            purordset_qty,
                                                            set_order_qty,
                                                            single_set_order_qty,
                                                            amount,
                                                            set_value
                                                           )
AS
   WITH set_heade AS
        (SELECT sd.setcode, 'S$001' || sd.setcode set_barcode, sd.icode,
                sd.qty set_qty,
                SUM (sd.qty) OVER (PARTITION BY os.ordcode, sd.setcode)
                                                               single_set_qty,
                os.invsetmain_code, os.ordcode,
                os.qty - NVL (os.cnlqty, 0) purordset_qty,
                sd.qty * (os.qty - NVL (os.cnlqty, 0)) set_order_qty,
                SUM (sd.qty * (os.qty - NVL (os.cnlqty, 0))
                    ) OVER (PARTITION BY os.ordcode, sd.setcode)
                                                         single_set_order_qty
           FROM invsetdet sd, purordset os
          WHERE sd.setcode = os.invsetmain_code    --AND os.ordcode = 57561709
                                               ),
        ord_det AS
        (SELECT   od.ordcode, od.icode, od.rate, od.invsetmain_code,
                  od.ordqty, i.hsn_code,
                     i.category4
                  || ' '
                  || i.category3
                  || ' '
                  || i.string_desc3
                  || ' '
                  || i.category6 item,
                  i.string_desc2 color,
                     i.string_desc1
                  || DECODE (i.invitem_udfstring01,
                             NULL, NULL,
                             ' (' || i.invitem_udfstring01 || ')'
                            ) desc1,
                  i.category5 item_size, i.rsp mrp, i.mrp listed_mrp,
                  COUNT (DISTINCT i.category5) no_color,
                  NVL (od.cnlqty, 0) cnlqty, NVL (od.rcqty, 0) rcqty
             FROM purorddet od, ginview.lv_item i
            WHERE od.icode = i.code
         --AND od.ordcode = 57561709
         GROUP BY od.ordcode,
                  od.icode,
                  od.rate,
                  od.invsetmain_code,
                  od.ordqty,
                  i.hsn_code,
                     i.category4
                  || ' '
                  || i.category3
                  || ' '
                  || i.string_desc3
                  || ' '
                  || i.category6,
                  i.string_desc2,
                  i.string_desc1,
                  i.invitem_udfstring01,
                  i.category5,
                  i.rsp,
                  i.mrp,
                  NVL (od.cnlqty, 0),
                  NVL (od.rcqty, 0))
   SELECT   ginview.fnc_uk uk, ord_det.ordcode, set_heade.set_barcode,
            ord_det.icode item_code, ord_det.hsn_code hsn, ord_det.item,
            ord_det.color, ord_det.desc1, ord_det.item_size, ord_det.no_color,
            set_heade.set_qty, set_heade.single_set_qty, ord_det.mrp,
            ord_det.listed_mrp, ord_det.rate rate, set_heade.purordset_qty,
            set_heade.set_order_qty, set_heade.single_set_order_qty,
            set_heade.set_order_qty * ord_det.rate amount,
            SUM (set_heade.set_order_qty * ord_det.rate) OVER (PARTITION BY ord_det.ordcode, set_heade.set_barcode)
                                                                    set_value
       FROM set_heade, ord_det
      WHERE set_heade.ordcode = ord_det.ordcode
        AND set_heade.setcode = ord_det.invsetmain_code
        AND set_heade.icode = ord_det.icode
   --AND set_heade.ordcode = (SELECT m.ordcode FROM PURORDMAIN m WHERE m.scheme_docno = 'PO/00005197/21-22')
   ORDER BY ord_det.ordcode,
            ord_det.desc1,
            set_heade.set_barcode,
            ord_det.icode;




/*CV_SET_BARCODE_HEADER*/
DROP VIEW GINVIEW.CV_SET_BARCODE_HEADER;

/* Formatted on 2022/08/10 13:08 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW ginview.cv_set_barcode_header (uk,
                                                            ordcode,
                                                            set_barcode,
                                                            no_color,
                                                            single_set_qty,
                                                            total_no_set,
                                                            single_set_order_qty,
                                                            set_value
                                                           )
AS
   SELECT   ginview.fnc_uk uk, ordcode, set_barcode, no_color, single_set_qty,
            purordset_qty total_no_set, single_set_order_qty, set_value
       FROM ginview.cv_po_item_setbarcode
   --   WHERE ordcode = 43160389
   GROUP BY ordcode,
            set_barcode,
            no_color,
            single_set_qty,
            purordset_qty,
            single_set_order_qty,
            set_value;

