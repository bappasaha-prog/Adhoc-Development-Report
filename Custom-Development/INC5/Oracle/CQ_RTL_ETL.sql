/* Formatted on 2025/06/18 17:18:26 (QP5 v5.294) */
/*|| Custom Development || Object : CQ_RTL_ETL || Ticket Id :  417847 || Developer : Dipankar ||*/

SELECT GINVIEW.FNC_UK () UK, X.*
  FROM (SELECT 'Offline'                                         SALE_TYPE,
               TRUNC (M.BILLDATE)                                BILL_DATE,
               M.BILLNO,
               'Offline'                                         CHANNEL_NAME,
               M.ADMSITE_CODE,
               D.ICODE,
               I.CATEGORY2,
               CASE WHEN D.QTY > 0 THEN 'Sale' ELSE 'Returm' END TYPE,
               NULL                                              REFERENCE_NO,
               NULL                                              ORDER_NO,
               NULL
                  ORDERING_CHANNEL,
               NULL
                  AGAINST_INVOICE,
               NULL                                              CREATED_ON,
               NULL                                              CREATED_BY,
               M.PSITE_CUSTOMER_CODE
                  CUSTOMER_CODE,
               D.PSITE_SALESPERSON_ID
                  SALESPERSON_CODE,
               D.SALESPERSON,
               D.QTY
                  BILL_QUANTITY,
               D.RTQTY
                  RETURN_QUANTITY,
               D.GROSSAMT                                        GROSS_AMOUNT,
               D.RTQTY * D.RSP
                  RETURN_AMOUNT,
               PR.RET_BILLNO
                  RETURN_BILL_NO,
               M.MDISCOUNTDESC
                  BILL_DISCOUNT_NAME,
               M.PROMONAME
                  BILL_PROMO_NAME,
               D.IDISCOUNTDESC
                  ITEM_DISCOUNT_NAME,
               D.PROMONAME
                  ITEM_PROMO_NAME,
               M.MDISCOUNTAMT
                  BILL_DISCOUNT_AMOUNT,
               M.PROMOAMT
                  BILL_PROMO_AMOUNT,
               D.IDISCOUNTAMT
                  ITEM_DISCOUN_AMOUNT,
               D.PROMOAMT
                  ITEM_PROMO_AMOUNT,
               M.LPDISCOUNTAMT
                  LOYALTY_DISCOUNT_AMOUNT,
               M.COUPONOFFER_CODE                                COUPON_CODE,
               D.NETAMT                                          NET_AMOUNT,
               D.TAXABLEAMT
                  TAXABLE_AMOUNT,
               D.TAXDESCRIPTION,
               D.TAXAMT                                          TAX_AMOUNT,
               0
                  SHIPMENT_CHARGES,
               0
                  GIFT_WRAP_CHARGES,
               0
                  CASH_ON_DELIVERY_CHARGES
          FROM PSITE_POSBILL M
               INNER JOIN PSITE_POSBILLITEM D
                  ON M.CODE = D.PSITE_POSBILL_CODE
               LEFT JOIN PSITE_POSBILLITEMRETURN PR
                  ON     D.CODE = PR.PSITE_POSBILLITEM_CODE
                     AND D.PSITE_POSBILL_CODE = PR.PSITE_POSBILL_CODE
               INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
         WHERE TRUNC (M.BILLDATE) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                      AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
        UNION ALL
        SELECT 'Online'                                          SALE_TYPE,
               TRUNC (M.CSDATE)                                  BILL_DATE,
               M.SCHEME_DOCNO                                    BILLNO,
               C.SLNAME                                          CHANNEL_NAME,
               M.ADMSITE_CODE,
               D.ICODE,
               I.CATEGORY2,
               CASE WHEN D.QTY > 0 THEN 'Sale' ELSE 'Returm' END TYPE,
               M.REFNO                                           REFERENCE_NO,
               M.INTGREF1                                        ORDER_NO,
               M.INTGREF2
                  ORDERING_CHANNEL,
               M.INTGREF3
                  AGAINST_INVOICE,
               M.TIME                                            CREATED_ON,
               H.FNAME                                           CREATED_BY,
               M.PSITE_CUSTOMER_CODE
                  CUSTOMER_CODE,
               NULL
                  SALESPERSON_CODE,
               NULL                                              SALESPERSON,
               D.QTY
                  BILL_QUANTITY,
               CASE WHEN D.QTY < 0 THEN D.QTY END
                  RETURN_QUANTITY,
               D.GRSAMT                                          GROSS_AMOUNT,
               CASE WHEN D.QTY < 0 THEN D.NETAMT ELSE 0 END
                  RETURN_AMOUNT,
               NULL
                  RETURN_BILL_NO,
               NULL
                  BILL_DISCOUNT_NAME,
               NULL
                  BILL_PROMO_NAME,
               NULL
                  ITEM_DISCOUNT_NAME,
               D.PROMONAME
                  ITEM_PROMO_NAME,
               M.DISCOUNT
                  BILL_DISCOUNT_AMOUNT,
               0
                  BILL_PROMO_AMOUNT,
               D.IDISCOUNTAMT
                  ITEM_DISCOUN_AMOUNT,
               D.PROMOAMT
                  ITEM_PROMO_AMOUNT,
               0
                  LOYALTY_DISCOUNT_AMOUNT,
               NULL                                              COUPON_CODE,
               D.NETAMT                                          NET_AMOUNT,
               D.TAXABLEAMT
                  TAXABLE_AMOUNT,
               D.TAXDESCRIPTION,
               D.TAXAMT                                          TAX_AMOUNT,
               M.SHIPCHG
                  SHIPMENT_CHARGES,
               M.GWCHG
                  GIFT_WRAP_CHARGES,
               M.CODCHG
                  CASH_ON_DELIVERY_CHARGES
          FROM SALCSMAIN M
               INNER JOIN SALCSDET D ON (M.CSCODE = D.CSCODE)
               LEFT OUTER JOIN FINSL C ON (PCODE = C.SLCODE)
               LEFT JOIN HRDEMP H ON M.ECODE = H.ECODE
               INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
         WHERE     M.CHANNELTYPE = 'ETL'
               AND TRUNC (M.CSDATE) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                        AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
        UNION ALL
        SELECT 'Online'                                          SALE_TYPE,
               TRUNC (M.SSDATE)                                  BILL_DATE,
               M.SCHEME_DOCNO                                    BILLNO,
               C.SLNAME                                          CHANNEL_NAME,
               M.ADMSITE_CODE,
               D.ICODE,
               I.CATEGORY2,
               CASE WHEN D.QTY > 0 THEN 'Sale' ELSE 'Returm' END TYPE,
               M.REFNO                                           REFERENCE_NO,
               M.INTGREF1                                        ORDER_NO,
               M.INTGREF2
                  ORDERING_CHANNEL,
               M.INTGREF3
                  AGAINST_INVOICE,
               M.TIME                                            CREATED_ON,
               H.FNAME                                           CREATED_BY,
               M.PSITE_CUSTOMER_CODE
                  CUSTOMER_CODE,
               NULL
                  SALESPERSON_CODE,
               NULL                                              SALESPERSON,
               D.QTY
                  BILL_QUANTITY,
               CASE WHEN D.QTY < 0 THEN D.QTY END
                  RETURN_QUANTITY,
               D.GRSAMT                                          GROSS_AMOUNT,
               CASE WHEN D.QTY < 0 THEN D.NETAMT ELSE 0 END
                  RETURN_AMOUNT,
               NULL
                  RETURN_BILL_NO,
               NULL
                  BILL_DISCOUNT_NAME,
               NULL
                  BILL_PROMO_NAME,
               NULL
                  ITEM_DISCOUNT_NAME,
               D.PROMONAME
                  ITEM_PROMO_NAME,
               M.DISCOUNT
                  BILL_DISCOUNT_AMOUNT,
               0
                  BILL_PROMO_AMOUNT,
               D.IDISCOUNTAMT
                  ITEM_DISCOUN_AMOUNT,
               D.PROMOAMT
                  ITEM_PROMO_AMOUNT,
               0
                  LOYALTY_DISCOUNT_AMOUNT,
               NULL                                              COUPON_CODE,
               D.NETAMT                                          NET_AMOUNT,
               D.TAXABLEAMT
                  TAXABLE_AMOUNT,
               D.TAXDESCRIPTION,
               D.TAXAMT                                          TAX_AMOUNT,
               NULL
                  SHIPMENT_CHARGES,
               NULL
                  GIFT_WRAP_CHARGES,
               NULL
                  CASH_ON_DELIVERY_CHARGES
          FROM SALSSMAIN M
               INNER JOIN SALSSDET D ON (M.SSCODE = D.SSCODE)
               LEFT OUTER JOIN FINSL C ON (PCODE = C.SLCODE)
               LEFT JOIN HRDEMP H ON M.ECODE = H.ECODE
               INNER JOIN GINVIEW.LV_ITEM I ON D.ICODE = I.CODE
         WHERE     M.CHANNELTYPE = 'ETL'
               AND TRUNC (M.SSDATE) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                        AND TO_DATE ('@DTTO@', 'YYYY-MM-DD'))
       X