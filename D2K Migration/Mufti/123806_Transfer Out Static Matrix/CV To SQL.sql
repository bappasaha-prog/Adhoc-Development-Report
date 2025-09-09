/* Formatted on 17-10-2023 10:38:07 (QP5 v5.294) */
/*CV_TROUT_REF_DOCS*/

  SELECT ginview.fnc_uk () UK,
         invcode,
         DC_NO,
         DC_DATE,
         SUM (DCQTY)     DCQTY
    FROM ginview.LV_TROUT_REF_DOCS
   WHERE    invcode IN
               (    SELECT REGEXP_SUBSTR ('@DocumentId@',
                                          '[^|~|]+',
                                          1,
                                          LEVEL)
                              col1
                      FROM DUAL
                CONNECT BY LEVEL <= REGEXP_COUNT ('@DocumentId@', '|~|') + 1)
         OR NVL (REGEXP_COUNT ('@DocumentId@', '|~|') + 1, 0) = 0
GROUP BY invcode, DC_NO, DC_DATE;



/*CV_TROUT_ITEM_STATIC_MATRIX*/
  SELECT ginview.fnc_uk              UK,
         a.invcode,
         NPW.NPW,
         division,
         category1 || ' ' || category3 Item,
         HSN_CODE                    HSN,
         UOM                         Unit,
         rate                        rate,
         SUM (
            CASE
               WHEN TRIM (b.category4) IN ('M', '28') THEN a.invqty
               ELSE 0
            END)
            SIZE_M28,
         SUM (
            CASE
               WHEN TRIM (b.category4) IN ('L', '30') THEN a.invqty
               ELSE 0
            END)
            SIZE_L30,
         SUM (
            CASE
               WHEN TRIM (b.category4) IN ('XL', '32') THEN a.invqty
               ELSE 0
            END)
            SIZE_XL32,
         SUM (
            CASE
               WHEN TRIM (b.category4) IN ('XXL', '34') THEN a.invqty
               ELSE 0
            END)
            SIZE_XXL34,
         SUM (
            CASE
               WHEN TRIM (b.category4) IN ('3XL', '36') THEN a.invqty
               ELSE 0
            END)
            SIZE_3XL36,
         SUM (
            CASE
               WHEN TRIM (b.category4) IN ('4XL', '38') THEN a.invqty
               ELSE 0
            END)
            SIZE_4XL38,
         SUM (
            CASE
               WHEN TRIM (b.category4) IN ('5XL', '40') THEN a.invqty
               ELSE 0
            END)
            SIZE_5XL40,
         SUM (CASE WHEN TRIM (b.category4) = '42' THEN a.invqty ELSE 0 END)
            SIZE_42,
         SUM (CASE WHEN TRIM (b.category4) = '44' THEN a.invqty ELSE 0 END)
            SIZE_44,
         SUM (CASE WHEN TRIM (b.category4) = '46' THEN a.invqty ELSE 0 END)
            SIZE_46,
         SUM (CASE
                 WHEN NVL (TRIM (b.category4), '99999') NOT IN ('M',
                                                                '28',
                                                                'L',
                                                                '30',
                                                                'XL',
                                                                '32',
                                                                'XXL',
                                                                '34',
                                                                '3XL',
                                                                '36',
                                                                '4XL',
                                                                '38',
                                                                '5XL',
                                                                '40',
                                                                '42',
                                                                '44',
                                                                '46')
                 THEN
                    A.invqty
                 ELSE
                    0
              END)
            undiff,
         SUM (A.invqty)              INVOICE_QUANTITY
    FROM (SELECT *
            FROM SALINVDET
           WHERE    invcode IN
                       (    SELECT REGEXP_SUBSTR ('@DocumentId@',
                                                  '[^|~|]+',
                                                  1,
                                                  LEVEL)
                                      col1
                              FROM DUAL
                        CONNECT BY LEVEL <=
                                      REGEXP_COUNT ('@DocumentId@', '|~|') + 1)
                 OR NVL (REGEXP_COUNT ('@DocumentId@', '|~|') + 1, 0) = 0) A,
         GINVIEW.LV_ITEM B,
         (  SELECT d.invcode,
                   ROUND (SUM (NVL (D.INVQTY, 0) * NVL (I.NUM1, 0)) / 1000, 2)
                      NPW
              --  INTO  V_NPW
              FROM (SELECT *
                      FROM SALINVDET
                     WHERE    invcode IN
                                 (    SELECT REGEXP_SUBSTR ('@DocumentId@',
                                                            '[^|~|]+',
                                                            1,
                                                            LEVEL)
                                                col1
                                        FROM DUAL
                                  CONNECT BY LEVEL <=
                                                  REGEXP_COUNT ('@DocumentId@',
                                                                '|~|')
                                                + 1)
                           OR NVL (REGEXP_COUNT ('@DocumentId@', '|~|') + 1, 0) =
                                 0) D,
                   V_ITEM I
             WHERE D.ICODE = I.ICODE               --AND D.INVCODE = 124304139
          GROUP BY invcode) NPW
   WHERE        a.icode = b.code
            AND a.invcode = npw.invcode
GROUP BY a.invcode,
         NPW.NPW,
         division,
         category1 || ' ' || category3,
         HSN_CODE,
         UOM,
         rate
         
         
/*CV_TROUT_DIVQTY*/
/* Formatted on 17-10-2023 10:41:24 (QP5 v5.294) */
  SELECT ginview.fnc_uk uk,
         invcode,
         division,
         SUM (invqty) div_qty
    FROM (SELECT *
            FROM SALINVDET
           WHERE    invcode IN
                       (    SELECT REGEXP_SUBSTR ('@DocumentId@',
                                                  '[^|~|]+',
                                                  1,
                                                  LEVEL)
                                      col1
                              FROM DUAL
                        CONNECT BY LEVEL <=
                                      REGEXP_COUNT ('@DocumentId@', '|~|') + 1)
                 OR NVL (REGEXP_COUNT ('@DocumentId@', '|~|') + 1, 0) = 0) A,
         GINVIEW.LV_ITEM B
   WHERE        a.icode = b.code                     --AND invcode = 124304139
            AND invcode IN
                   (    SELECT REGEXP_SUBSTR ('@DocumentId@',
                                              '[^|~|]+',
                                              1,
                                              LEVEL)
                                  col1
                          FROM DUAL
                    CONNECT BY LEVEL <=
                                  REGEXP_COUNT ('@DocumentId@', '|~|') + 1)
         OR NVL (REGEXP_COUNT ('@DocumentId@', '|~|') + 1, 0) = 0
GROUP BY invcode, division;