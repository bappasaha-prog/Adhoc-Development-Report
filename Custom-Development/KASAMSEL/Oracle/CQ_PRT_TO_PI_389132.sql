/* Formatted on 2025-01-27 17:37:48 (QP5 v5.294) */
/*
Purpose              Object                        ID              Developer          
Custom Development   CQ_PRT_TO_PI                  389132          Dipankar
*/

  SELECT D.ICODE,
         M.ADMSITE_CODE,
         M.PCODE,
         M.LGTCODE,
         M.SCHEME_DOCNO RETURN_NO,
         M.RTDT         RETURN_DATE,
         CASE WHEN M.RELEASE_STATUS = 'P' THEN 'Posted' ELSE 'Un-Posted' END
            RELEASE_STATUS,
         M.REM          REMARKS,
         SUM (D.QTY)    RETURN_QTY,
         SUM (D.NETAMT) RETURN_AMT,
         GTM.SCHEME_DOCNO GRT_NO,
         GTM.GRTDT      GRT_DATE,
         GCM.SCHEME_DOCNO GRC_NO,
         GCM.GRCDT      GRC_DATE,
         PIM.SCHEME_DOCNO PI_NO,
         PIM.INVDT      PI_DATE,
         GCM.LGTCODE    PI_LGTCODE
    FROM PURRTMAIN M
         INNER JOIN PURRTDET D ON M.RTCODE = D.RTCODE
         INNER JOIN INVGRTDET GT ON D.INVGRTDET_CODE = GT.CODE
         INNER JOIN INVGRTMAIN GTM ON GTM.GRTCODE = GT.GRTCODE
         INNER JOIN INVGRCDET GC ON GT.INVGRCDET_CODE = GC.CODE
         INNER JOIN INVGRCMAIN GCM ON GC.GRCCODE = GCM.GRCCODE
         INNER JOIN PURINVDET PID ON GC.CODE = PID.INVGRCDET_CODE
         INNER JOIN PURINVMAIN PIM ON PID.INVCODE = PIM.INVCODE
   WHERE TRUNC (M.RTDT) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                            AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
GROUP BY D.ICODE,
         M.ADMSITE_CODE,
         M.PCODE,
         M.LGTCODE,
         M.SCHEME_DOCNO,
         M.RTDT,
         CASE WHEN M.RELEASE_STATUS = 'P' THEN 'Posted' ELSE 'Un-Posted' END,
         M.REM,
         GTM.SCHEME_DOCNO,
         GTM.GRTDT,
         GCM.SCHEME_DOCNO,
         GCM.GRCDT,
         PIM.SCHEME_DOCNO,
         PIM.INVDT,
         GCM.LGTCODE