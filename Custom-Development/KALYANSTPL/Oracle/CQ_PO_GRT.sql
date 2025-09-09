/*|| Custom Development || Object : CQ_PO_GRT || Ticket Id :  425050 || Developer : Dipankar ||*/

SELECT GINVIEW.FNC_UK ()                                         UK,
       M.ADMSITE_CODE,
       M.PCODE,
       M.SCHEME_DOCNO                                            ORDER_NO,
       TRUNC (M.ORDDT)                                           ORDER_DATE,
       M.TIME                                                    PO_CREATION_DATE,
       CONCAT (CONCAT (CONCAT (MAR.FNAME, '['), MAR.ECODE), ']') MARCHANDISER,
       D.ICODE,
       D.ORDER_QTY,
       D.RATE,
       D.RSP,
       GRC.GRC_NO,
       GRC.GRC_DATE,
       GRC.GRC_QTY,
       GRT.GRT_NO,
       GRT.GRT_DATE,
       GRT.GRT_QTY
  FROM PURORDMAIN M
       INNER JOIN (  SELECT ORDCODE,
                            ICODE,
                            RATE,
                            RSP,
                            SUM (ORDQTY) ORDER_QTY
                       FROM PURORDDET
                   GROUP BY ORDCODE,
                            ICODE,
                            RATE,
                            RSP) D
          ON M.ORDCODE = D.ORDCODE
       LEFT JOIN HRDEMP MAR ON M.MRCHNDSRCODE = MAR.ECODE
       LEFT JOIN
       (  SELECT D.ORDCODE,
                 D.ICODE,
                 LISTAGG (TO_CHAR (M.GRCDT, 'DD-MM-YYYY'), ', ')
                    WITHIN GROUP (ORDER BY M.GRCDT ASC)
                    GRC_DATE,
                 LISTAGG (M.SCHEME_DOCNO, ', ')
                    WITHIN GROUP (ORDER BY M.SCHEME_DOCNO)
                    GRC_NO,
                 SUM (D.ACQTY) GRC_QTY
            FROM INVGRCDET D INNER JOIN INVGRCMAIN M ON D.GRCCODE = M.GRCCODE
           WHERE D.ORDCODE IS NOT NULL AND D.PO_CODE IS NOT NULL
        GROUP BY D.ORDCODE, D.ICODE) GRC
          ON D.ICODE = GRC.ICODE AND D.ORDCODE = GRC.ORDCODE
       LEFT JOIN
       (  SELECT GD.ORDCODE,
                 D.ICODE,
                 LISTAGG (TO_CHAR (M.GRTDT, 'DD-MM-YYYY'), ', ')
                    WITHIN GROUP (ORDER BY M.GRTDT ASC)
                    GRT_DATE,
                 LISTAGG (M.SCHEME_DOCNO, ', ')
                    WITHIN GROUP (ORDER BY M.SCHEME_DOCNO)
                    GRT_NO,
                 SUM (D.QTY) GRT_QTY
            FROM INVGRTDET D
                 INNER JOIN INVGRTMAIN M ON D.GRTCODE = M.GRTCODE
                 INNER JOIN INVGRCDET GD
                    ON D.INVGRCDET_CODE = GD.CODE AND D.GRCCODE = GD.GRCCODE
           WHERE GD.ORDCODE IS NOT NULL AND GD.PO_CODE IS NOT NULL
        GROUP BY GD.ORDCODE, D.ICODE) GRT
          ON D.ICODE = GRT.ICODE AND D.ORDCODE = GRT.ORDCODE
 WHERE TRUNC (M.ORDDT) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                           AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')