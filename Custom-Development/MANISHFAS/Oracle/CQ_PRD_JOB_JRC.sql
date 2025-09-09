/* Formatted on 2025-02-25 17:18:12 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_PRD_JOB_JRC || Ticket Id : 393952 || Developer : Dipankar || ><><><*/

WITH DTA
     AS (SELECT DATE_VALUE
           FROM GINVIEW.LV_CALENDAR
          WHERE DATE_VALUE BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                               AND TO_DATE ('@DTTO@', 'YYYY-MM-DD'))
  SELECT GINVIEW.FNC_UK ()       UK,
         F.DATE_VALUE,
         F.PRNAME,
         F.DIVISION,
         ROUND (AVG (F.AGEING), 2) AGEING,
         SUM (F.ORDER_QTY)       ORDER_QTY,
         SUM (F.RECEIVE_QTY)     RECEIVE_QTY
    FROM (  SELECT A.DATE_VALUE,
                   I.CODE,
                   CASE
                      WHEN B.JRC_DATE IS NULL THEN 0
                      ELSE B.JRC_DATE - A.JOB_DATE
                   END
                      AGEING,
                   A.PRNAME,
                   I.DIVISION,
                   SUM (A.ORDER_QTY) ORDER_QTY,
                   SUM (B.RECEIVE_QTY) RECEIVE_QTY
              FROM GINVIEW.LV_ASSEMBLY_ITEM I
                   LEFT OUTER JOIN
                   (  SELECT DTA.DATE_VALUE,
                             M.JOB_DATE,
                             P.PRNAME,
                             D.ASSEMBLY_ICODE,
                             SUM (D.QTY) ORDER_QTY
                        FROM PRDJOBMAIN M
                             INNER JOIN PRDJOBDET D ON M.CODE = D.JRCCODE
                             INNER JOIN PRDPR P ON M.PRCODE = P.PRCODE
                             RIGHT JOIN DTA ON TRUNC (M.JOB_DATE) = DTA.DATE_VALUE
                    GROUP BY DTA.DATE_VALUE,
                             M.JOB_DATE,
                             P.PRNAME,
                             D.ASSEMBLY_ICODE) A
                      ON I.CODE = A.ASSEMBLY_ICODE
                   LEFT OUTER JOIN
                   (  SELECT DTA.DATE_VALUE,
                             JRC_DATE,
                             P.PRNAME,
                             D.ASSEMBLY_ICODE,
                             SUM (D.QTY) RECEIVE_QTY
                        FROM PRDJRCMAIN M
                             INNER JOIN PRDJRCDET D ON M.CODE = D.JOBCODE
                             INNER JOIN PRDPR P ON M.PRCODE = P.PRCODE
                             RIGHT JOIN DTA ON TRUNC (M.JRC_DATE) = DTA.DATE_VALUE
                    GROUP BY DTA.DATE_VALUE,
                             M.JRC_DATE,
                             P.PRNAME,
                             D.ASSEMBLY_ICODE) B
                      ON I.CODE = B.ASSEMBLY_ICODE
          GROUP BY A.DATE_VALUE,
                   I.CODE,
                   CASE
                      WHEN B.JRC_DATE IS NULL THEN 0
                      ELSE B.JRC_DATE - A.JOB_DATE
                   END,
                   A.PRNAME,
                   I.DIVISION) F
   WHERE F.PRNAME IS NOT NULL
GROUP BY F.DATE_VALUE, F.PRNAME, F.DIVISION