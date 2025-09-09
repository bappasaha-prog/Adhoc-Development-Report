/* Formatted on 2025-01-21 12:43:51 (QP5 v5.294) */
/*
Purpose              Object                        ID              Developer          
Custom Development   CQ_POSBILL_DASH_CUS           387921          Dipankar
*/

SELECT GINVIEW.FNC_UK () UK,
       SITENAME,
       SHRTNAME,
       BILLLDATE,
       NETAMT,
       NETPAYABLE,
       DISCOUNTAMT,
       PROMOAMT,
       RETURNAMT,
       SALEAMT,
       ROUNDOFF,
       NO_OF_POSBILL,
       SUM (NETAMT) OVER (PARTITION BY BILLLDATE ORDER BY BILLLDATE)
          DAY_SUMMARY,
       BILL_PROMO_AMT,
       BILL_DISC_APPORTIONED_AMT,
       BILL_COUPON_AMT,
       TAXABLE_AMOUNT,
       NONTAXABLE_AMOUNT
  FROM (  SELECT NAME                  SITENAME,
                 SHRTNAME,
                 BILLLDATE,
                 SUM (NETAMT)          NETAMT,
                 SUM (NETPAYABLE)      NETPAYABLE,
                 SUM (DISCOUNTAMT)     DISCOUNTAMT,
                 SUM (PROMOAMT)        PROMOAMT,
                 SUM (RETURNAMT)       RETURNAMT,
                 SUM (SALEAMT)         SALEAMT,
                 SUM (ROUNDOFF)        ROUNDOFF,
                 SUM (NO_OF_POSBILL)   NO_OF_POSBILL,
                 BILL_PROMO_AMT,
                 BILL_DISC_APPORTIONED_AMT,
                 BILL_COUPON_AMT,
                 SUM (TAXABLE_AMOUNT)  TAXABLE_AMOUNT,
                 SUM (NONTAXABLE_AMOUNT) NONTAXABLE_AMOUNT
            FROM (  SELECT A.CODE,
                           S.NAME,
                           S.SHRTNAME,
                           TRUNC (BILLDATE)         BILLLDATE,
                           A.NETAMT                 NETAMT,
                           NETPAYABLE               NETPAYABLE,
                           A.DISCOUNTAMT            DISCOUNTAMT,
                           A.PROMOAMT               PROMOAMT,
                           A.RETURNAMT              RETURNAMT,
                           A.SALEAMT                SALEAMT,
                           A.ROUNDOFF               ROUNDOFF,
                           COUNT (1)                NO_OF_POSBILL,
                           A.MPROMOAMOUNT           BILL_PROMO_AMT,
                           A.MDISCOUNTAPPORTIONEDAMOUNT BILL_DISC_APPORTIONED_AMT,
                           A.MCOUPONAMOUNT          BILL_COUPON_AMT,
                           SUM (
                              CASE
                                 WHEN (B.TAXAMT <> 0) THEN B.TAXABLEAMT
                                 ELSE 0
                              END)
                              TAXABLE_AMOUNT,
                           SUM (
                              CASE
                                 WHEN (B.TAXAMT = 0) THEN B.TAXABLEAMT
                                 ELSE 0
                              END)
                              NONTAXABLE_AMOUNT
                      FROM PSITE_POSBILL A
                           INNER JOIN PSITE_POSBILLITEM B
                              ON A.CODE = B.PSITE_POSBILL_CODE
                           INNER JOIN ADMSITE S
                              ON     A.ADMSITE_CODE = S.CODE
                                 AND (   TRUNC (BILLDATE) BETWEEN TRUNC (
                                                                     ADD_MONTHS (
                                                                        SYSDATE,
                                                                        -12),
                                                                     'mm')
                                                              AND TRUNC (
                                                                     ADD_MONTHS (
                                                                        SYSDATE,
                                                                        -12))
                                      OR TRUNC (BILLDATE) BETWEEN TRUNC (
                                                                     ADD_MONTHS (
                                                                        SYSDATE,
                                                                        -1),
                                                                     'mm')
                                                              AND TRUNC (SYSDATE))
                     WHERE S.ADMOU_CODE = '@ConnOUCode@'
                  GROUP BY A.CODE,
                           S.NAME,
                           S.SHRTNAME,
                           TRUNC (BILLDATE),
                           A.NETAMT,
                           NETPAYABLE,
                           A.DISCOUNTAMT,
                           A.PROMOAMT,
                           A.RETURNAMT,
                           A.SALEAMT,
                           A.ROUNDOFF,
                           A.MPROMOAMOUNT,
                           A.MDISCOUNTAPPORTIONEDAMOUNT,
                           A.MCOUPONAMOUNT)
        GROUP BY NAME,
                 SHRTNAME,
                 BILLLDATE,
                 BILL_PROMO_AMT,
                 BILL_DISC_APPORTIONED_AMT,
                 BILL_COUPON_AMT)