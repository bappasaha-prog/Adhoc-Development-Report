/* Formatted on 2025-02-24 12:41:01 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_PRD_JOB_JRC || Ticket Id : 393952 || Developer : Dipankar || ><><><*/
  SELECT GINVIEW.FNC_UK() UK,
         JOB_DATE,
         PRNAME,
         DIVISION,
         AVG (AGEING)    AGEING,
         SUM (ORDER_QTY) ORDER_QTY,
         SUM (RECEIVE_QTY) RECEIVE_QTY
    FROM (  SELECT M.JOB_DATE,
                   P.PRNAME,
                   I.CODE,
                   I.DIVISION,
                   AVG (M.JOB_DATE - RM.JRC_DATE) AGEING,
                   SUM (D.QTY)                ORDER_QTY,
                   SUM (R.QTY)                RECEIVE_QTY
              FROM PRDJOBMAIN M
                   INNER JOIN PRDJOBDET D ON M.CODE = D.JOBCODE
                   INNER JOIN PRDJRCDET R ON M.CODE = R.JOBCODE
                   INNER JOIN PRDJRCMAIN RM ON R.JRCCODE = RM.CODE
                   INNER JOIN GINVIEW.LV_ASSEMBLY_ITEM I
                      ON D.ASSEMBLY_ICODE = I.CODE
                   INNER JOIN PRDPR P ON M.PRCODE = P.PRCODE
             WHERE M.JOB_DATE::DATE BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                          AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
          GROUP BY M.JOB_DATE,
                   P.PRNAME,
                   I.CODE,
                   I.DIVISION)
GROUP BY JOB_DATE, PRNAME, DIVISION