/*For Old POS Data*/

SELECT 'Offline'                                         SALE_TYPE,
       CAST (BILLDATE AS DATE)                           BILL_DATE,
       M.BILLNO,
       ''                                                NEW_BILLNO,
       'Offline'                                         CHANNEL_NAME,
       'Manual'                                          SITE_NAME,
       'Manusl'                                          SITE_SHORT_NAME,
       'Manual'                                          SITE_CODE,
       CASE WHEN D.QTY > 0 THEN 'Sale' ELSE 'Returm' END TYPE,
       NULL                                              REFERENCE_NO,
       NULL                                              PARTY_NAME,
       NULL                                              ORDER_NO,
       NULL                                              ORDERING_CHANNEL,
       NULL                                              AGAINST_INVOICE,
       I.HSNSACCODE                                      HSN_CODE,
       D.ITEMID                                          ITEM_CODE,
       I.BARCODE,
       I.DIVISION,
       I.SECTION,
       I.DEPARTMENT                                      BRAND,
       I.CAT1                                            PRODUCT,
       I.CAT2                                            STYLE,
       I.CAT3                                            COLOR,
       I.CAT4                                            ITEM_SIZE,
       I.DESC4                                           STYLE_STATUS,
       I.MRP,
       I.LRP                                             COST_PRICE,
       I.DESC1                                           INHOUSE_BRAND,
       I.DESC2                                           SOR_OUTRIGHT,
       I.UDFSTRING01                                     UPPER,
       I.UDFSTRING02                                     BOTTOM,
       I.UDFSTRING03                                     HEEL,
       NULL                                              CREATED_ON,
       NULL                                              CREATED_BY,
       CONCAT (C.FNAME, C.MNAME, C.LNAME)                CUSTOMER_NAME,
       C.MOBILE                                          CUSTOMER_NO,
       D.SALESPERSONID                                   SALESPERSON_ID,
       CONCAT (S.FNAME, S.MNAME, S.LNAME)                SALESPERSON_NAME,
       D.QTY                                             BILL_QUANTITY,
       PR.RETBILLNO                                      RETURN_BILL_NO,
       M.MDISCOUNTDESC                                   BILL_DISCOUNT_NAME,
       M.PROMONAME                                       BILL_PROMO_NAME,
       D.IDISCOUNTDESC                                   ITEM_DISCOUNT_NAME,
       D.PROMONAME                                       ITEM_PROMO_NAME,
       D.MDISCOUNTAMT
          ITEMBILL_DISCOUNT_AMOUNT,
       M.PROMOAMT                                        BILL_PROMO_AMOUNT,
       D.IDISCOUNTAMT                                    ITEM_DISCOUN_AMOUNT,
       D.PROMOAMT                                        ITEM_PROMO_AMOUNT,
       M.LPDISCOUNTAMT
          LOYALTY_DISCOUNT_AMOUNT,
       M.COUPONOFFERID                                   COUPON_CODE,
       D.NETAMT                                          NET_AMOUNT,
       D.TAXABLEAMT                                      TAXABLE_AMOUNT,
       D.TAXDESCRIPTION,
       D.TAXAMT                                          TAX_AMOUNT,
       0                                                 SHIPMENT_CHARGES,
       0                                                 GIFT_WRAP_CHARGES,
       0
          CASH_ON_DELIVERY_CHARGES,
       A.FIRST_SALE_DATE                                 FIRST_SALE_DATE,
       B.FIRST_DATE
          FIRST_GRCDATE_BRACODE_STORE_LEVEL,
       ''
          FIRST_GRCDATE_BRACODE_OVERALL,
       G.FIRST_IN_DATE
          FIRST_GRCDATE_STYLEWISE_STORE_LEVEL,
       ''
          FIRST_GRCDATE_STYLEWISE_OVERALL,
       ''                                                FY_YEAR
  FROM POSBILL M
       INNER JOIN POSBILLITEM D ON M.ID = D.POSBILLID
       LEFT JOIN POSBILLITEMRETURN PR
          ON D.ID = PR.POSBILLITEMID AND D.POSBILLID = PR.POSBILLID
       INNER JOIN V_ITEM I ON D.ITEMID = I.ITEMID
       LEFT JOIN SALESPERSON S ON D.SALESPERSONID = S.ID
       LEFT JOIN CUSTOMER C ON M.CUSTOMERID = C.CUSTOMERID
       LEFT JOIN
       (SELECT ITEMID, FIRST_SALE_DATE
          FROM (SELECT D.ITEMID,
                       CAST (M.BILLDATE AS DATE) AS FIRST_SALE_DATE,
                       ROW_NUMBER ()
                       OVER (PARTITION BY D.ITEMID ORDER BY M.CREATEDON ASC)
                          AS RN
                  FROM POSBILL M
                       INNER JOIN POSBILLITEM D ON M.ID = D.POSBILLID) SALE
         WHERE RN = 1) A
          ON D.ITEMID = A.ITEMID
       LEFT JOIN
       (SELECT ITEMID, FIRST_DATE
          FROM (SELECT D.ITEMID,
                       M.DOCDATE AS FIRST_DATE,
                       ROW_NUMBER ()
                       OVER (PARTITION BY D.ITEMID ORDER BY M.CREATEDON ASC)
                          AS RN
                  FROM GRCADVICEDOC M
                       INNER JOIN GRCADVICEITEM D
                          ON M.GRCADVICEDOCID = D.GRCADVICEDOCID) PGRC
         WHERE RN = 1) B
          ON D.ITEMID = B.ITEMID
       LEFT JOIN
       (SELECT CAT2, FIRST_IN_DATE
          FROM (SELECT I.CAT2,
                       M.DOCDATE AS FIRST_IN_DATE,
                       ROW_NUMBER ()
                          OVER (PARTITION BY I.CAT2 ORDER BY M.CREATEDON ASC)
                          AS RN
                  FROM GRCADVICEDOC M
                       INNER JOIN GRCADVICEITEM D
                          ON M.GRCADVICEDOCID = D.GRCADVICEDOCID
                       INNER JOIN V_ITEM I ON D.ITEMID = I.ITEMID) PGRC
         WHERE RN = 1) G
          ON I.CAT2 = G.CAT2
 WHERE CAST (BILLDATE AS DATE) BETWEEN CAST ('2025-02-28' AS DATE)
                                   AND CAST ('2025-07-11' AS DATE)