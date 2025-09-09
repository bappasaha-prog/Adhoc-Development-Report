/* Formatted on 2025-02-28 16:05:49 (QP5 v5.294) */
  SELECT GINVIEW.FNC_UK UK, A.*
    FROM (SELECT A.CODE,
                 A.NAME   ASSORTMENT_NAME,
                 A.DESCRIPTION,
                 A.EXTINCT,
                 TIME     CREATED_ON,
                 A.LAST_ACCESS_TIME,
                 E.ICODE,
                 'Excluded' AS TYPE
            FROM SI_ASSORTMENT A
                 LEFT OUTER JOIN SI_ASSORTMENT_EXCLUDE E
                    ON E.ASSORTMENT_CODE = A.CODE
          UNION ALL
          SELECT A.CODE,
                 A.NAME   ASSORTMENT_NAME,
                 A.DESCRIPTION,
                 A.EXTINCT,
                 A.TIME     CREATED_ON,
                 A.LAST_ACCESS_TIME,
                 I.ICODE,
                 'Included' AS TYPE
            FROM SI_ASSORTMENT A
                 LEFT OUTER JOIN SI_ASSORTMENT_INCLUDE I
                    ON I.ASSORTMENT_CODE = A.CODE) A
   WHERE ICODE IS NOT NULL
ORDER BY CODE ASC