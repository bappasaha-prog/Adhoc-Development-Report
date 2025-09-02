/*><><>< || Custom Development || Object : CQ_ESTD_COST || Ticket Id : 394991 || Developer : Dipankar || ><><><*/
SELECT GINVIEW.FNC_UK ()        UK,
       H.COSTSHEET_CODE         L1_COSTSHEET_CODE,
       H.COST_SHEET_ID          L1_COST_SHEET_ID,
       H.COST_SHEET_DATE        L1_COST_SHEET_DATE,
       H.COST_SHEET_DESCRIPTION L1_COST_SHEET_DESCRIPTION,
       H.CREATED_ON             L1_CREATED_ON,
       H.GROUP_NAME             L1_DEPARTMENT,
       H.size 					L1_SIZE,
       H.UNIT 					L1_UNIT,
       H.CODE					L1_CODE,
       D.LVL,
       D.SEQ,
       D.ITEM                   L2_ITEM,
       D.WIDTH                  L2_WIDTH,
       D.COLOR                  L2_COLOR,
       D.COMPONENT_QUANTITY     L2_COMPONENT_QUANTITY,
       D.COMPONENT_RATE         L2_COMPONENT_RATE,
       D.UDF_NAME               L3_UDF_NAME,
       D.UDF_VALUE              L3_UDF_VALUE,
       D.JOB_COST               L4_JOB_COST,
       D.MATERIAL_COST          L4_MATERIAL_COST,
       D.PROCESS_NAME           L4_PROCESS_NAME,
       d.remarks 				L4_REMARKS,
       D.OPERATION_SEQ			L4_OPERATION_SEQ,
       D.UDF2_NAME              L5_UDF2_NAME,
       D.UDF2_VALUE             L5_UDF2_VALUE
  FROM (SELECT M.CODE        COSTSHEET_CODE,
               M.ID          COST_SHEET_ID,
               M.COST_DATE   COST_SHEET_DATE,
               M.DESCRIPTION COST_SHEET_DESCRIPTION,
               M.TIME        CREATED_ON,
               G.GRPNAME     GROUP_NAME,
               M.udfstring01 size,
               M.udfstring02 UNIT,
               M.udfstring03 CODE
          FROM PRDCOSTSHEETHEAD M
               INNER JOIN HRDEMP C ON M.ECODE = C.ECODE
               LEFT OUTER JOIN HRDEMP L ON M.LAST_ACCESS_ECODE = L.ECODE
               LEFT OUTER JOIN HRDEMP A ON M.APPROVED_ECODE = A.ECODE
               LEFT OUTER JOIN INVGRP G ON M.GRPCODE = G.GRPCODE
               where 
			( M.CODE in (
			select
				unnest(regexp_matches('@DocumentId@',
				'[^|~|]+',
				'g'))::bigint as col1)
				or coalesce (nullif ('@DocumentId@',
				''),
				'0')::text = 0::text)) H
       INNER JOIN
       (  SELECT B.COSTSHEET_CODE                COSTSHEET_CODE,
                 'L2#DETAIL'                     LVL,
                 1                               SEQ,
                 CONCAT_WS ('-',I.CATEGORY2, I.CATEGORY4) ITEM,
                 I.CATEGORY3                     WIDTH,
                 I.CATEGORY5                     COLOR,
                 SUM (B.QTY)                     COMPONENT_QUANTITY,
                 B.RATE                          COMPONENT_RATE,
                 NULL                            UDF_NAME,
                 NULL                            UDF_VALUE,
                 0                            JOB_COST,
                 0                            MATERIAL_COST,
                 NULL                            PROCESS_NAME,
                  null remarks,
                 null::INT OPERATION_SEQ,
                 NULL                            UDF2_NAME,
                 0                            UDF2_VALUE
            FROM PRDCOSTSHEETBOM B
                 INNER JOIN PRDCOSTSHEETHEAD H ON B.COSTSHEET_CODE = H.CODE
                 INNER JOIN GINVIEW.LV_COMPONENT_ITEM I
                    ON B.COMPONENT_ICODE = I.CODE
                    where 
					( B.COSTSHEET_CODE in (
					select
						unnest(regexp_matches('@DocumentId@',
						'[^|~|]+',
						'g'))::bigint as col1)
						or coalesce (nullif ('@DocumentId@',
						''),
						'0')::text = 0::text)
        GROUP BY B.COSTSHEET_CODE,
                 CONCAT_WS ('-',I.CATEGORY2, I.CATEGORY4),
                 I.CATEGORY3,
                 I.CATEGORY5,
                 B.RATE
        UNION ALL
        SELECT U1.COSTSHEET_CODE,
               'L3#DETAIL' LVL,
               2           SEQ,
               NULL        ITEM,
               NULL        WIDTH,
               NULL        COLOR,
               NULL        COMPONENT_QUANTITY,
               NULL        COMPONENT_RATE,
               U1.NAME     UDF_NAME,
               U1.UDF_VALUE,
               0        JOB_COST,
               0        MATERIAL_COST,
               NULL        PROCESS_NAME,
                null remarks,
               null::INT OPERATION_SEQ,
               NULL        UDF2_NAME,
               0        UDF2_VALUE
          FROM (SELECT M.CODE        COSTSHEET_CODE,
                       'C.ACCESSORIES' NAME,
                       M.UDFNUM01    UDF_VALUE
                  FROM PRDCOSTSHEETHEAD M
                  where 
					( M.CODE in (
					select
						unnest(regexp_matches('@DocumentId@',
						'[^|~|]+',
						'g'))::bigint as col1)
						or coalesce (nullif ('@DocumentId@',
						''),
						'0')::text = 0::text)
                UNION ALL
                SELECT M.CODE              COSTSHEET_CODE,
                       'D.PACKING MATERILES' NAME,
                       M.UDFNUM02
                  FROM PRDCOSTSHEETHEAD M
                  where 
					( M.CODE in (
					select
						unnest(regexp_matches('@DocumentId@',
						'[^|~|]+',
						'g'))::bigint as col1)
						or coalesce (nullif ('@DocumentId@',
						''),
						'0')::text = 0::text)) U1
        UNION ALL
        SELECT M.COSTSHEET_CODE COSTSHEET_CODE,
               'L4#DETAIL'      LVL,
               3                SEQ,
               NULL             ITEM,
               NULL             WIDTH,
               NULL             COLOR,
               NULL             COMPONENT_QUANTITY,
               NULL             COMPONENT_RATE,
               NULL             UDF_NAME,
               NULL             UDF_VALUE,
               M.JOB_COST       JOB_COST,
               M.MAT_COST       MATERIAL_COST,
               P.PRNAME         PROCESS_NAME,
               m.rem            remarks,
               M.OPERATION_SEQ,
               NULL             UDF2_NAME,
               0             UDF2_VALUE
          FROM PRDCOSTSHEETOPERATION M
               INNER JOIN PRDCOSTSHEETHEAD H ON M.COSTSHEET_CODE = H.CODE
               INNER JOIN PRDPR P ON M.PRCODE = P.PRCODE
               where 
					( M.COSTSHEET_CODE in (
					select
						unnest(regexp_matches('@DocumentId@',
						'[^|~|]+',
						'g'))::bigint as col1)
						or coalesce (nullif ('@DocumentId@',
						''),
						'0')::text = 0::text)
		UNION ALL
        SELECT M.CODE COSTSHEET_CODE,
               'L4#DETAIL'      LVL,
               3                SEQ,
               NULL             ITEM,
               NULL             WIDTH,
               NULL             COLOR,
               NULL             COMPONENT_QUANTITY,
               NULL             COMPONENT_RATE,
               NULL             UDF_NAME,
               NULL             UDF_VALUE,
               m.udfstring04::numeric    JOB_COST,
               0       MATERIAL_COST,
               'IRONING'  PROCESS_NAME,
               null remarks,
               999 OPERATION_SEQ,
               NULL             UDF2_NAME,
               0             UDF2_VALUE
          FROM PRDCOSTSHEETHEAD M
                  where 
					( M.CODE in (
					select
						unnest(regexp_matches('@DocumentId@',
						'[^|~|]+',
						'g'))::bigint as col1)
						or coalesce (nullif ('@DocumentId@',
						''),
						'0')::text = 0::text)
        UNION ALL
        SELECT U2.COSTSHEET_CODE,
               'L5#DETAIL' LVL,
               4           SEQ,
               NULL        ITEM,
               NULL        WIDTH,
               NULL        COLOR,
               NULL        COMPONENT_QUANTITY,
               NULL        COMPONENT_RATE,
               NULL        UDF_NAME,
               NULL        UDF_VALUE,
               NULL        JOB_COST,
               NULL        MATERIAL_COST,
               NULL        PROCESS_NAME,
                null remarks,
               null::INT OPERATION_SEQ,
               U2.NAME     UDF2_NAME,
               U2.UDF2_VALUE
          FROM (SELECT M.CODE      COSTSHEET_CODE,
                       'E. Overheads' NAME,
                       M.UDFNUM03  UDF2_VALUE
                  FROM PRDCOSTSHEETHEAD M
                  where 
					( M.CODE in (
					select
						unnest(regexp_matches('@DocumentId@',
						'[^|~|]+',
						'g'))::bigint as col1)
						or coalesce (nullif ('@DocumentId@',
						''),
						'0')::text = 0::text)
                UNION ALL
                SELECT M.CODE       COSTSHEET_CODE,
                       'F. Other Cost' NAME,
                       M.UDFNUM04   UDF2_VALUE
                  FROM PRDCOSTSHEETHEAD M
                  where 
					( M.CODE in (
					select
						unnest(regexp_matches('@DocumentId@',
						'[^|~|]+',
						'g'))::bigint as col1)
						or coalesce (nullif ('@DocumentId@',
						''),
						'0')::text = 0::text)
                UNION ALL
                SELECT M.CODE     COSTSHEET_CODE,
                       'G. Freight'  NAME,
                       M.UDFNUM05 UDF2_VALUE
                  FROM PRDCOSTSHEETHEAD M
                  where 
					( M.CODE in (
					select
						unnest(regexp_matches('@DocumentId@',
						'[^|~|]+',
						'g'))::bigint as col1)
						or coalesce (nullif ('@DocumentId@',
						''),
						'0')::text = 0::text)) U2) D
          ON H.COSTSHEET_CODE = D.COSTSHEET_CODE