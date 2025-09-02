/* Formatted on 2025-02-24 14:22:52 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_PRD_WIP_TRANSACTION_DETAIL || Ticket Id : 391568 || Developer : Dipankar || ><><><*/
  SELECT GINVIEW.FNC_UK()           UK,
         D.WIPTXN_CODE               WIPTXN_CODE,
         D.JOBCODE                   JOBCODE,
         J.JOBNO                     JOB_ORDER_NO,
         J.JOB_DATE                  JOB_ORDER_DATE,
         L.LOTNO                     PLAN_NO,
         L.SCHEDULE_DATE             PLAN_DATE,
         D.COMPONENT_ICODE           COMPONENT_ICODE,
         D.ASSEMBLY_ICODE            ASSEMBLY_ICODE,
         D.WIP_LOCCODE,
         SK.LOCNAME                  WIP_STOCKPOINT,
         SUM (D.QTY)                 COMPONENT_QUANTITY,
         D.COSTRATE                  COST_RATE,
         D.SITE_COSTRATE             SITE_COSTRATE,
         D.CNLCODE                   CNLCODE,
         CN.CNLNO                    CANCELLATION_NO,
         CN.CNLDT                    CANCELLATION_DATE,
         D.ASS_SAITEM_CODE,
         SA.SAINAME                  SUB_ASSEMBLY_ITEM,
         D.COM_SAITEM_CODE,
         SC.SAINAME                  SUB_COMPONENT_ITEM,
         D.JOB_ASSEMBLY_ICODE        ORDER_ASSEMBLY_ICODE,
         COALESCE (
            ITEM_NAME,
               concat_ws(' ',CNAME1,CNAME2,CNAME3,CNAME4,CNAME5,CNAME6))
            ORDER_ASSEMBLY_ITEM_NAME,
         COALESCE (D.RATE, D.COSTRATE) RATE,
         SUM(B.amount) COST_AMOUNT,
         JD.job_rate
    FROM PRDWIPDET D
         LEFT OUTER JOIN INVITEM I ON D.JOB_ASSEMBLY_ICODE = I.ICODE
         INNER JOIN PRDJOBMAIN J ON D.JOBCODE = J.CODE
         inner join prdjobdet JD on J.code  = JD.jobcode 
         LEFT OUTER JOIN PRDLOTMAIN L ON D.LOTCODE = L.CODE
         LEFT OUTER JOIN INVLOC SK ON D.WIP_LOCCODE = SK.LOCCODE
         LEFT OUTER JOIN PRDJOBCNLMAIN CN ON D.CNLCODE = CN.CODE
         LEFT OUTER JOIN PRD_SAITEM SA ON D.ASS_SAITEM_CODE = SA.CODE
         LEFT OUTER JOIN PRD_SAITEM SC ON D.COM_SAITEM_CODE = SC.CODE
         left outer join (/* Formatted on 2025-02-24 16:21:30 (QP5 v5.294) */
  SELECT P.WIPTXN_CODE,
         P.LOTCODE,
         P.JOBCODE,
         P.DET_CODE,
         P.COMPONENT_ICODE,
         P.RATE,
         SUM (P.AMOUNT) AMOUNT
    FROM PRDWIPTRANS P
   WHERE P.TXN_TYPE = 'ISS' AND P.ITEM_TYPE IN ('ASS', 'COM')
GROUP BY P.WIPTXN_CODE,
         P.LOTCODE,
         P.JOBCODE,
         P.DET_CODE,
         P.COMPONENT_ICODE,
         P.RATE) B on 
         D.wiptxn_code = B.wiptxn_code 
         and D.jobcode = B.jobcode 
         and D.lotcode = B.lotcode 
         and D.code = B.det_code
         and D.component_icode = B.component_icode
GROUP BY D.WIPTXN_CODE,
         D.JOBCODE,
         J.JOBNO,
         J.JOB_DATE,
         L.LOTNO,
         L.SCHEDULE_DATE,
         D.COMPONENT_ICODE,
         D.ASSEMBLY_ICODE,
         D.WIP_LOCCODE,
         SK.LOCNAME,
         D.COSTRATE,
         D.SITE_COSTRATE,
         D.CNLCODE,
         CN.CNLNO,
         CN.CNLDT,
         D.ASS_SAITEM_CODE,
         SA.SAINAME,
         D.COM_SAITEM_CODE,
         SC.SAINAME,
         D.JOB_ASSEMBLY_ICODE,
         COALESCE (
            ITEM_NAME,
               concat_ws(' ',CNAME1,CNAME2,CNAME3,CNAME4,CNAME5,CNAME6)),
         COALESCE (D.RATE, D.COSTRATE),
         JD.job_rate