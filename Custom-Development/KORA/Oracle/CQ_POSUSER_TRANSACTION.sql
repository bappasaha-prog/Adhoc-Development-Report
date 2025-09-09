/* Formatted on 2025-04-24 14:16:33 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_POSUSER_TRANSACTION || Ticket Id : 404986 || Developer : Dipankar || ><><><*/

SELECT GINVIEW.FNC_UK () UK,
       SITE_SHORT_NAME,
       USER_NAME,
       TC,
       CREATION_DATE,
       MODULE_NAME
  FROM (  SELECT S.SHRTNAME        SITE_SHORT_NAME,
                 M.CREATEBY        USER_NAME,
                 COUNT (M.CODE)    TC,
                 TRUNC (M.CREATEDON) CREATION_DATE,
                 'Bill Count'      MODULE_NAME
            FROM PSITE_POSBILL M
                 INNER JOIN ADMSITE S ON M.ADMSITE_CODE = S.CODE
           WHERE TRUNC (M.CREATEDON) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                         AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
        GROUP BY S.SHRTNAME, M.CREATEBY, TRUNC (M.CREATEDON)
        UNION ALL
          SELECT S.SHRTNAME        SITE_SHORT_NAME,
                 M.CREATEDBY       USER_NAME,
                 COUNT (M.CODE)    TC,
                 TRUNC (M.CREATEDON) CREATION_DATE,
                 'GOODS RECEIVE'   MODULE_NAME
            FROM PSITE_GRC M INNER JOIN ADMSITE S ON M.ADMSITE_CODE = S.CODE
           WHERE TRUNC (M.CREATEDON) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                         AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
        GROUP BY S.SHRTNAME, M.CREATEDBY, TRUNC (M.CREATEDON)
        UNION ALL
          SELECT S.SHRTNAME                      SITE_SHORT_NAME,
                 COALESCE (B.FULLNAME, C.FULLNAME) USER_NAME,
                 COUNT (M.ID)                    TC,
                 TRUNC (M.CREATEDON)             CREATION_DATE,
                 'PACKET'                        MODULE_NAME
            FROM PSITE_PACKET M
                 INNER JOIN ADMSITE S ON M.ADMSITE_CODE = S.CODE
                 LEFT JOIN PSITE_APPUSER B
                    ON M.ADMSITE_CODE = B.ADMSITE_CODE AND M.CREATEDBY = B.ID
                 LEFT JOIN APPUSER C ON M.CREATEDBY = C.ID
           WHERE TRUNC (M.CREATEDON) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                         AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
        GROUP BY S.SHRTNAME,
                 COALESCE (B.FULLNAME, C.FULLNAME),
                 TRUNC (M.CREATEDON)
        UNION ALL
          SELECT S.SHRTNAME        SITE_SHORT_NAME,
                 M.CREATEDBY       USER_NAME,
                 COUNT (M.CODE)    TC,
                 TRUNC (M.CREATEDON) CREATION_DATE,
                 'GOODS RETURN'    MODULE_NAME
            FROM PSITE_GRT M INNER JOIN ADMSITE S ON M.ADMSITE_CODE = S.CODE
           WHERE TRUNC (M.CREATEDON) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                         AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
        GROUP BY S.SHRTNAME, M.CREATEDBY, TRUNC (M.CREATEDON)
        UNION ALL
          SELECT S.SHRTNAME        SITE_SHORT_NAME,
                 M.SETTLEDBY       USER_NAME,
                 COUNT (M.CODE)    TC,
                 TRUNC (M.SETTLEDON) CREATION_DATE,
                 'SETTLEMENT'      MODULE_NAME
            FROM PSITE_POSSTLM M
                 INNER JOIN ADMSITE S ON M.ADMSITE_CODE = S.CODE
           WHERE TRUNC (M.SETTLEDON) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                         AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
        GROUP BY S.SHRTNAME, M.SETTLEDBY, TRUNC (M.SETTLEDON)
        UNION ALL
          SELECT S.SHRTNAME                      SITE_SHORT_NAME,
                 COALESCE (B.FULLNAME, C.FULLNAME) USER_NAME,
                 COUNT (M.CODE)                  TC,
                 TRUNC (M.CREATEDON)             CREATION_DATE,
                 'STOCK POINT TRANSFER'          MODULE_NAME
            FROM PSITE_STFDOC M
                 INNER JOIN ADMSITE S ON M.ADMSITE_CODE = S.CODE
                 LEFT JOIN PSITE_APPUSER B
                    ON M.ADMSITE_CODE = B.ADMSITE_CODE AND M.CREATEDBY = B.ID
                 LEFT JOIN APPUSER C ON M.CREATEDBY = C.ID
           WHERE TRUNC (M.CREATEDON) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                         AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
        GROUP BY S.SHRTNAME,
                 COALESCE (B.FULLNAME, C.FULLNAME),
                 TRUNC (M.CREATEDON)
        UNION ALL
          SELECT S.SHRTNAME                      SITE_SHORT_NAME,
                 COALESCE (B.FULLNAME, C.FULLNAME) USER_NAME,
                 COUNT (M.CODE)                  TC,
                 TRUNC (M.CREATEDON)             CREATION_DATE,
                 'AUDIT PLAN'                    MODULE_NAME
            FROM PSITE_STFDOC M
                 INNER JOIN ADMSITE S ON M.ADMSITE_CODE = S.CODE
                 LEFT JOIN PSITE_APPUSER B
                    ON M.ADMSITE_CODE = B.ADMSITE_CODE AND M.CREATEDBY = B.ID
                 LEFT JOIN APPUSER C ON M.CREATEDBY = C.ID
           WHERE TRUNC (M.CREATEDON) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                         AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
        GROUP BY S.SHRTNAME,
                 COALESCE (B.FULLNAME, C.FULLNAME),
                 TRUNC (M.CREATEDON)
        UNION ALL
          SELECT S.SHRTNAME        SITE_SHORT_NAME,
                 M.CREATEDBY       USER_NAME,
                 COUNT (M.CODE)    TC,
                 TRUNC (M.CREATEDON) CREATION_DATE,
                 'AUDIT JOURNAL'   MODULE_NAME
            FROM PSITE_AUDITJOURNAL M
                 INNER JOIN ADMSITE S ON M.ADMSITE_CODE = S.CODE
           WHERE TRUNC (M.CREATEDON) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                         AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
        GROUP BY S.SHRTNAME, M.CREATEDBY, TRUNC (M.CREATEDON)
        UNION ALL
          SELECT S.SHRTNAME                      SITE_SHORT_NAME,
                 COALESCE (B.FULLNAME, C.FULLNAME) USER_NAME,
                 COUNT (M.CODE)                  TC,
                 TRUNC (M.CREATEDON)             CREATION_DATE,
                 'GIFT VOUCHER ISSUE'            MODULE_NAME
            FROM GVISSUE_JOURNAL M
                 INNER JOIN ADMSITE S ON M.ADMSITE_CODE = S.CODE
                 LEFT JOIN PSITE_APPUSER B
                    ON M.ADMSITE_CODE = B.ADMSITE_CODE AND M.CREATEDBY = B.ID
                 LEFT JOIN APPUSER C ON M.CREATEDBY = C.ID
           WHERE TRUNC (M.CREATEDON) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                         AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
        GROUP BY S.SHRTNAME,
                 COALESCE (B.FULLNAME, C.FULLNAME),
                 TRUNC (M.CREATEDON)
        UNION ALL
          SELECT S.SHRTNAME        SITE_SHORT_NAME,
                 M.CREATEBY        USER_NAME,
                 COUNT (M.CODE)    TC,
                 TRUNC (M.CREATEDON) CREATION_DATE,
                 'DEPOSIT/REFUND'  MODULE_NAME
            FROM PSITE_POSDEPREFBILL M
                 INNER JOIN ADMSITE S ON M.ADMSITE_CODE = S.CODE
           WHERE TRUNC (M.CREATEDON) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                         AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
        GROUP BY S.SHRTNAME, M.CREATEBY, TRUNC (M.CREATEDON)
        UNION ALL
          SELECT S.SHRTNAME        SITE_SHORT_NAME,
                 M.CREATEDBY       USER_NAME,
                 COUNT (M.CODE)    TC,
                 TRUNC (M.CREATEDON) CREATION_DATE,
                 'PETTY CASH'      MODULE_NAME
            FROM PSITE_PTCBILL M
                 INNER JOIN ADMSITE S ON M.ADMSITE_CODE = S.CODE
           WHERE TRUNC (M.CREATEDON) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                         AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
        GROUP BY S.SHRTNAME, M.CREATEDBY, TRUNC (M.CREATEDON)
        UNION ALL
          SELECT S.SHRTNAME      SITE_SHORT_NAME,
                 C.FULLNAME      USER_NAME,
                 COUNT (M.GRCCODE) TC,
                 TRUNC (M.TIME)  CREATION_DATE,
                 'PURCHASE'      MODULE_NAME
            FROM INVGRCMAIN M
                 INNER JOIN ADMSITE S ON M.ADMSITE_CODE_IN = S.CODE
                 INNER JOIN APPUSER C ON M.ECODE = C.ID
           WHERE TRUNC (M.TIME) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                    AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
        GROUP BY S.SHRTNAME, C.FULLNAME, TRUNC (M.TIME)
        UNION ALL
          SELECT S.SHRTNAME      SITE_SHORT_NAME,
                 C.FULLNAME      USER_NAME,
                 COUNT (M.GRTCODE) TC,
                 TRUNC (M.TIME)  CREATION_DATE,
                 'PURCHASE RETURN' MODULE_NAME
            FROM INVGRTMAIN M
                 INNER JOIN ADMSITE S ON M.ADMSITE_CODE = S.CODE
                 INNER JOIN APPUSER C ON M.ECODE = C.ID
           WHERE TRUNC (M.TIME) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                    AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
        GROUP BY S.SHRTNAME, C.FULLNAME, TRUNC (M.TIME)
        UNION ALL
          SELECT S.SHRTNAME        SITE_SHORT_NAME,
                 M.CREATEDBY       USER_NAME,
                 COUNT (M.CODE)    TC,
                 TRUNC (M.CREATEDON) CREATION_DATE,
                 'POS ORDER'       MODULE_NAME
            FROM PSITE_POSORDER M
                 INNER JOIN ADMSITE S ON M.ADMSITE_CODE = S.CODE
           WHERE TRUNC (M.CREATEDON) BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                                         AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')
        GROUP BY S.SHRTNAME, M.CREATEDBY, TRUNC (M.CREATEDON))