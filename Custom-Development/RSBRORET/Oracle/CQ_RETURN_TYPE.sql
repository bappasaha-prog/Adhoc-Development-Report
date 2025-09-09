/* Formatted on 2025-05-14 19:18:01 (QP5 v5.294) */
SELECT M.GRTCODE,
       CASE
          WHEN M.GRCCODE IS NULL
          THEN
             'NON-CONSIGNMENT'
          ELSE
             INITCAP (
                CASE
                   WHEN G.WHETHER_CONSIGNMENT = 'Y' THEN 'CONSIGNMENT'
                   WHEN G.WHETHER_CONSIGNMENT = 'N' THEN 'NON-CONSIGNMENT'
                END)
       END
          AS RETURN_TYPE
  FROM INVGRTMAIN M LEFT JOIN INVGRCMAIN G ON M.GRCCODE = G.GRCCODE