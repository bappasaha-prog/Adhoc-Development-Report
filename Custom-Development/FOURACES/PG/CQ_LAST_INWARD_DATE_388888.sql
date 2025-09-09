/* Formatted on 2025-01-23 13:19:18 (QP5 v5.294) */
/*
Purpose              Object                        ID              Developer          
Custom Development   CQ_LAST_INWARD_DATE           388888          Dipankar
*/
  SELECT GINVIEW.FNC_UK () UK,
         K.ICODE,
         K.ADMSITE_CODE,
         MAX (K.ENTDT::DATE)   LAST_INWARD_DATE
    FROM INVSTOCK K INNER JOIN ADMSITE S ON K.ADMSITE_CODE = S.CODE
   WHERE K.ENTTYPE IN ('SOP',
                       'PRC',
                       'MIS',
                       'GRC',
                       'STI',
                       'ADJ',
                       'PIS')
GROUP BY K.ICODE, K.ADMSITE_CODE