/* Formatted on 2025-01-21 11:51:28 (QP5 v5.294) */
/*
Purpose              Object                        ID              Developer          
Custom Development   CQ_POSBILL_DASH               387921          Dipankar
*/
SELECT GINVIEW.FNC_UK() UK,
       NAME           SITENAME,
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
       BILL_COUPON_AMT
  FROM (  SELECT S.NAME,
                 S.SHRTNAME,
                 BILLDATE::date           BILLLDATE,
                 SUM (NETAMT)               NETAMT,
                 SUM (NETPAYABLE)           NETPAYABLE,
                 SUM (DISCOUNTAMT)          DISCOUNTAMT,
                 SUM (PROMOAMT)             PROMOAMT,
                 SUM (A.RETURNAMT)          RETURNAMT,
                 SUM (A.SALEAMT)            SALEAMT,
                 SUM (A.ROUNDOFF)           ROUNDOFF,
                 COUNT (1)                  NO_OF_POSBILL,
                 A.MPROMOAMOUNT             BILL_PROMO_AMT,
                 A.MDISCOUNTAPPORTIONEDAMOUNT BILL_DISC_APPORTIONED_AMT,
                 A.MCOUPONAMOUNT            BILL_COUPON_AMT
            FROM PSITE_POSBILL A
                 INNER JOIN ADMSITE S
                    ON     A.ADMSITE_CODE = S.CODE
                       AND ((DATE_TRUNC('day', BILLDATE) BETWEEN 
						        DATE_TRUNC('month', CURRENT_DATE - INTERVAL '12 months') 
						        AND 
						        DATE_TRUNC('day', CURRENT_DATE - INTERVAL '12 months'))
						    OR 
						    (DATE_TRUNC('day', BILLDATE) BETWEEN 
						        DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month') 
						        AND 
						        DATE_TRUNC('day', CURRENT_DATE)))
           WHERE S.ADMOU_CODE = '@ConnOUCode@'
        GROUP BY S.NAME,
                 S.SHRTNAME,
                 BILLDATE::date,
                 A.MPROMOAMOUNT,
                 A.MDISCOUNTAPPORTIONEDAMOUNT,
                 A.MCOUPONAMOUNT)