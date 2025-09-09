SELECT   ROW_NUMBER() OVER() as UK,
         I.CODE RESERVATION_CODE,
         I.SCHEME_DOCNO,
         I.DOCCODE,
         I.ENTDT,
         A1.NAME                           AS DOCUMENT_SITE,
         A1.CODE                           AS DOCUMENT_SITE_CODE,
         INITCAP (
            CASE
               WHEN I.ORDER_TYPE = 'SO' THEN 'SALES ORDER'
               WHEN I.ORDER_TYPE = 'TO' THEN 'TRANSFER ORDER'
               WHEN I.ORDER_TYPE = 'RO' THEN 'RETAIL ORDER'
               ELSE NULL
            END)
            AS ORDER_TYPE,
         I.ORDER_CODE,
         I.LOCCODE,
         S.SCHEME_DOCNO                    AS ORDER_NO,
         S.ORDDT                           AS ORDER_DATE,
         S.ADMSITE_CODE                    AS DESTINATION_SITE_CODE,
         A2.NAME                           AS DESTINATION_SITE_NAME,
         A1.SHRTNAME                       AS DESTINATION_SITE_SHORT_NAME,
         A1.SITETYPE                       AS DESTINATION_SITE_TYPE,
         S.PCODE                           AS CUSTOMER_CODE,
         F.SLNAME                          AS CUSTOMER_NAME,
         F.SLID                            AS CUSTOMER_SLID,
         I.REMARKS,
         A1.FLOORLOCCODE,
         P.RULE_NAME                       AS PICK_LIST_RULE,
         ID.ICODE,
         ID.INVBIN_CODE,
         SUM (COALESCE (ID.RESERVE_QTY, 0)) AS RESERVATION_QTY,
         SUM (COALESCE (ID.CANCEL_QTY, 0)) AS CANCELLED_QTY,
         SUM (COALESCE (ID.PICKLIST_QTY, 0)) AS PICK_LIST_QTY,
         SUM (
              COALESCE (ID.RESERVE_QTY, 0)
            - COALESCE (ID.CANCEL_QTY, 0)
            - COALESCE (ID.PICKLIST_QTY, 0))
            AS PENDING_PICK_LIST_QTY,
         SUM (COALESCE (A.CONFIRMED_QTY, 0) - COALESCE (A.PACKED_QTY, 0))
            AS PENDING_PACKED_QTY,
         SUM (COALESCE (A.CONFIRMED_QTY, 0)) AS CONFIRM_QTY,
         SUM (
              COALESCE (A.PICKLIST_QTY, 0)
            - COALESCE (A.PICKLIST_CANCEL_QTY, 0)
            - COALESCE (A.CONFIRMED_QTY, 0))
            AS PICKLIST_IN_PROGRESS_QTY,
         SUM (
              COALESCE (ID.RESERVE_QTY, 0)
            - COALESCE (ID.CANCEL_QTY, 0)
            - COALESCE (ID.PICKLIST_QTY, 0)
            + (COALESCE (A.CONFIRMED_QTY, 0) - COALESCE (A.PACKED_QTY, 0)))
            AS CANCELLABLE_QTY,
         SUM (COALESCE (ID.RESERVE_QTY, 0) - COALESCE (ID.CANCEL_QTY, 0) - COALESCE (A.CONFIRMED_QTY, 0)) STOCK_QTY,
         H1.FNAME                          AS CREATED_BY,
         I.CREATEDON                       AS CREATED_ON,
         H2.FNAME                          AS LASTMODIFIED_BY,
         I.LASTMODIFIEDON                  AS LASTMODIFIED_ON,
         S.ENTRY_SOURCE
    FROM INVRESERVEMAIN I
         JOIN ADMSITE A1 ON I.ADMSITE_CODE_OWNER = A1.CODE
         JOIN PICKLIST_RULE P ON I.PICKLIST_RULE_CODE = P.CODE
         JOIN INVRESERVEDET ID ON I.CODE = ID.INVRESERVEMAIN_CODE
         JOIN HRDEMP H1 ON I.CREATEDBY = H1.ECODE
         LEFT JOIN HRDEMP H2 ON I.LASTMODIFIEDBY = H2.ECODE
         JOIN SALORDMAIN S ON I.ORDER_CODE = S.ORDCODE
         LEFT JOIN ADMSITE A2 ON S.ADMSITE_CODE = A2.CODE
         LEFT JOIN FINSL F ON S.PCODE = F.SLCODE
         LEFT JOIN
         (  SELECT INVPICKLISTDET.INVRESERVEDET_CODE,
                   SUM (INVPICKLISTDET.PICKLIST_QTY) AS PICKLIST_QTY,
                   SUM (INVPICKLISTDET.CONFIRM_QTY) AS CONFIRMED_QTY,
                   SUM (INVPICKLISTDET.PACKED_QTY) AS PACKED_QTY,
                   SUM (INVPICKLISTDET.CANCEL_QTY) AS PICKLIST_CANCEL_QTY
              FROM INVPICKLISTDET
          GROUP BY INVPICKLISTDET.INVRESERVEDET_CODE) A
            ON ID.CODE = A.INVRESERVEDET_CODE
   WHERE I.ORDER_TYPE IN ('SO', 'TO')
GROUP BY I.CODE,
         I.SCHEME_DOCNO,
         I.DOCCODE,
         I.ENTDT,
         A1.NAME,
         A1.CODE,
         I.ORDER_TYPE,
         I.ORDER_CODE,
         I.LOCCODE,
         S.SCHEME_DOCNO,
         S.ORDDT,
         S.ADMSITE_CODE,
         A2.NAME,
         A1.SHRTNAME,
         A1.SITETYPE,
         S.PCODE,
         F.SLNAME,
         F.SLID,
         I.REMARKS,
         A1.FLOORLOCCODE,
         P.RULE_NAME,
         ID.ICODE,
         ID.INVBIN_CODE,
         H1.FNAME,
         I.CREATEDON,
         H2.FNAME,
         I.LASTMODIFIEDON,
         S.ENTRY_SOURCE
  HAVING (    SUM (
                 COALESCE (A.CONFIRMED_QTY, 0) - COALESCE (A.PACKED_QTY, 0)) <>
                 0
          OR SUM (COALESCE (ID.RESERVE_QTY, 0) - COALESCE (ID.CANCEL_QTY, 0) - COALESCE (A.CONFIRMED_QTY, 0)) <> 0)