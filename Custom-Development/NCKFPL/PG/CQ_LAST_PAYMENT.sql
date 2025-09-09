/* Formatted on 10/04/2025 17:55:51 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_LAST_PAYMENT || Ticket Id : 407700 || Developer : Dipankar || ><><><*/
WITH SL
     AS (SELECT M.arap_slcode SLCODE,
                M.arap_sub_ledger SUB_LEDGER,
                M.vchcode ENTCODE,
                M.voucher_date::DATE PAYMENT_DATE,
                M.amount PAYMENT_AMOUNT,
                ROW_NUMBER ()
                   OVER (PARTITION BY M.arap_slcode ORDER BY M.created_on DESC)
                   RN
           FROM GINVIEW.lv_ar_voucher M)
  SELECT GINVIEW.FNC_UK() UK,
         SLCODE,
         SUB_LEDGER,
         PAYMENT_DATE,
         PAYMENT_AMOUNT
         FROM SL 
         WHERE RN = 1