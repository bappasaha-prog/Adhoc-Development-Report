/*><><>< || Custom Development || Object : CQ_INVENTORY_MOVEMENT || Ticket Id : 406642 || Developer : Dipankar || ><><><*/

SELECT GINVIEW.FNC_UK () UK,
       I.CODE            ICODE,
       A.GRC_RATE,
       A.RECEIVE_QTY     SITE1_GRC_QTY,
       B.SITE1_TROUT_QTY,
       B.SITE1_SALE_QTY,
       C.QTY             SITE1_GRT_QTY,
       J.QTY             SITE1_SALRT_QTY,
       D.SITE1_STK_QTY,
       D.SITE2_STK_QTY,
       D.SITE3_STK_QTY,
       D.SITE4_STK_QTY,
       D.SITE5_STK_QTY,
       E.SITE2_GRC_QTY,
       E.SITE3_GRC_QTY,
       E.SITE4_GRC_QTY,
       E.SITE5_GRC_QTY,
       F.SITE2_TROUT_QTY,
       F.SITE3_TROUT_QTY,
       F.SITE4_TROUT_QTY,
       F.SITE5_TROUT_QTY,
       G.SITE2_SALE_QTY,
       G.SITE3_SALE_QTY,
       G.SITE4_SALE_QTY,
       G.SITE5_SALE_QTY,
       H.SITE2_RET_QTY,
       H.SITE3_RET_QTY,
       H.SITE4_RET_QTY,
       H.SITE5_RET_QTY
  FROM GINVIEW.LV_ITEM I
       INNER JOIN
       (  SELECT D.ICODE, D.ACRATE GRC_RATE, SUM (D.ACQTY) RECEIVE_QTY
            FROM INVGRCMAIN M INNER JOIN INVGRCDET D ON M.GRCCODE = D.GRCCODE
           WHERE TRUNC (M.GRCDT) <= SYSDATE AND M.ADMSITE_CODE_IN = 1
        GROUP BY D.ICODE, D.ACRATE) A
          ON I.CODE = A.ICODE
       LEFT JOIN
       (  SELECT D.ICODE,
                 SUM (CASE WHEN M.SALETYPE = 'C' THEN D.INVQTY ELSE 0 END)
                    SITE1_TROUT_QTY,
                 SUM (CASE WHEN M.SALETYPE = 'O' THEN D.INVQTY ELSE 0 END)
                    SITE1_SALE_QTY
            FROM SALINVMAIN M INNER JOIN SALINVDET D ON M.INVCODE = D.INVCODE
           WHERE M.ADMSITE_CODE_OWNER = 1 AND TRUNC (M.INVDT) <= SYSDATE
        GROUP BY D.ICODE) B
          ON I.CODE = B.ICODE
       LEFT JOIN
       (  SELECT D.ICODE, SUM (D.QTY) QTY
            FROM INVGRTMAIN M INNER JOIN INVGRTDET D ON M.GRTCODE = D.GRTCODE
           WHERE M.ADMSITE_CODE = 1 AND TRUNC (M.GRTDT) <= SYSDATE
        GROUP BY D.ICODE) C
          ON I.CODE = C.ICODE
       LEFT JOIN
       (  SELECT K.ICODE,
                 SUM (CASE WHEN K.ADMSITE_CODE = 1 THEN K.QTY ELSE 0 END)
                    SITE1_STK_QTY,
                 SUM (CASE WHEN K.ADMSITE_CODE = 3 THEN K.QTY ELSE 0 END)
                    SITE2_STK_QTY,
                 SUM (CASE WHEN K.ADMSITE_CODE = 15 THEN K.QTY ELSE 0 END)
                    SITE3_STK_QTY,
                 SUM (CASE WHEN K.ADMSITE_CODE = 2 THEN K.QTY ELSE 0 END)
                    SITE4_STK_QTY,
                 SUM (CASE WHEN K.ADMSITE_CODE = 17 THEN K.QTY ELSE 0 END)
                    SITE5_STK_QTY
            FROM INVSTOCK_ONHAND K
           WHERE     K.ADMSITE_CODE IN (1,
                                        2,
                                        3,
                                        15,
                                        17)
                 AND K.LOCCODE <> 2
        GROUP BY K.ICODE) D
          ON I.CODE = D.ICODE
       LEFT JOIN
       (  SELECT D.ICODE,
                 SUM (
                    CASE WHEN M.ADMSITE_CODE = 3 THEN D.RECEIVEQTY ELSE 0 END)
                    SITE2_GRC_QTY,
                 SUM (
                    CASE WHEN M.ADMSITE_CODE = 15 THEN D.RECEIVEQTY ELSE 0 END)
                    SITE3_GRC_QTY,
                 SUM (
                    CASE WHEN M.ADMSITE_CODE = 2 THEN D.RECEIVEQTY ELSE 0 END)
                    SITE4_GRC_QTY,
                 SUM (
                    CASE WHEN M.ADMSITE_CODE = 17 THEN D.RECEIVEQTY ELSE 0 END)
                    SITE5_GRC_QTY
            FROM PSITE_GRC M
                 INNER JOIN PSITE_GRCITEM D ON M.CODE = D.PSITE_GRC_CODE
           WHERE     M.ADMSITE_CODE IN (2,
                                        3,
                                        15,
                                        17)
                 AND TRUNC (M.DOCDT) <= SYSDATE
        GROUP BY D.ICODE) E
          ON I.CODE = E.ICODE
       LEFT JOIN
       (  SELECT D.ICODE,
                 SUM (CASE WHEN M.ADMSITE_CODE = 3 THEN D.RTQTY ELSE 0 END)
                    SITE2_TROUT_QTY,
                 SUM (CASE WHEN M.ADMSITE_CODE = 15 THEN D.RTQTY ELSE 0 END)
                    SITE3_TROUT_QTY,
                 SUM (CASE WHEN M.ADMSITE_CODE = 2 THEN D.RTQTY ELSE 0 END)
                    SITE4_TROUT_QTY,
                 SUM (CASE WHEN M.ADMSITE_CODE = 17 THEN D.RTQTY ELSE 0 END)
                    SITE5_TROUT_QTY
            FROM PSITE_GRT M
                 INNER JOIN PSITE_GRTITEM D ON M.CODE = D.PSITE_GRT_CODE
           WHERE     M.ADMSITE_CODE IN (2,
                                        3,
                                        15,
                                        17)
                 AND TRUNC (M.DOCDT) <= SYSDATE
        GROUP BY D.ICODE) F
          ON I.CODE = F.ICODE
       LEFT JOIN
       (  SELECT D.ICODE,
                 SUM (CASE WHEN M.ADMSITE_CODE = 3 THEN D.QTY ELSE 0 END)
                    SITE2_SALE_QTY,
                 SUM (CASE WHEN M.ADMSITE_CODE = 15 THEN D.QTY ELSE 0 END)
                    SITE3_SALE_QTY,
                 SUM (CASE WHEN M.ADMSITE_CODE = 2 THEN D.QTY ELSE 0 END)
                    SITE4_SALE_QTY,
                 SUM (CASE WHEN M.ADMSITE_CODE = 17 THEN D.QTY ELSE 0 END)
                    SITE5_SALE_QTY
            FROM PSITE_POSBILL M
                 INNER JOIN PSITE_POSBILLITEM D
                    ON M.CODE = D.PSITE_POSBILL_CODE
           WHERE     M.ADMSITE_CODE IN (2,
                                        3,
                                        15,
                                        17)
                 AND D.QTY > 0
                 AND TRUNC (M.BILLDATE) <= SYSDATE
        GROUP BY D.ICODE) G
          ON I.CODE = G.ICODE
       LEFT JOIN
       (  SELECT D.ICODE,
                 SUM (CASE WHEN M.ADMSITE_CODE = 3 THEN D.QTY ELSE 0 END)
                    SITE2_RET_QTY,
                 SUM (CASE WHEN M.ADMSITE_CODE = 15 THEN D.QTY ELSE 0 END)
                    SITE3_RET_QTY,
                 SUM (CASE WHEN M.ADMSITE_CODE = 2 THEN D.QTY ELSE 0 END)
                    SITE4_RET_QTY,
                 SUM (CASE WHEN M.ADMSITE_CODE = 17 THEN D.QTY ELSE 0 END)
                    SITE5_RET_QTY
            FROM PSITE_POSBILL M
                 INNER JOIN PSITE_POSBILLITEM D
                    ON M.CODE = D.PSITE_POSBILL_CODE
           WHERE     M.ADMSITE_CODE IN (2,
                                        3,
                                        15,
                                        17)
                 AND D.QTY < 0
                 AND TRUNC (M.BILLDATE) <= SYSDATE
        GROUP BY D.ICODE) H
          ON I.CODE = H.ICODE
       LEFT JOIN
       (  SELECT D.ICODE, SUM (D.QTY) QTY
            FROM SALRTMAIN M INNER JOIN SALRTDET D ON M.RTCODE = D.RTCODE
           WHERE     M.ADMSITE_CODE_OWNER = 1
                 AND TRUNC (M.RTDT) <= SYSDATE
                 AND M.SALETYPE = 'C'
        GROUP BY D.ICODE) J
          ON I.CODE = J.ICODE