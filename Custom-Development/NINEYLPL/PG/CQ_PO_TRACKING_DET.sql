/* Formatted on 2025-02-06 16:31:18 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_PO_TRACKING_DET || Ticket Id : 391732 || Developer : Dipankar || ><><><*/
SELECT GINVIEW.FNC_UK () AS UK,
       ST.NAME           AS SITE_NAME,
       CUST_VEN.SLNAME   AS VENDOR_NAME,
       ITEM.DIVISION     DIVISION,
       ITEM.SECTION      SECTION,
       ITEM.DEPARTMENT   DEPARTMENT,
       ITEM.BARCODE      BARCODE,
       ITEM.ITEM_CODE    ITEMCODE,
       A.PURCHASE_RATE,
       ORDER_QTY,
       CANCEL_QTY,
       RECEIVE_QTY,
       A.SCHEME_DOCNO    PO_NO,
       A.ORDDT           PO_DATE,
       A.GRCNO           GRC_NO,
       A.GRCDT           GRC_DATE,
       A.INVNO           PI_NO,
       A.INVDT           PI_DATE
  FROM (SELECT PM.ORDCODE,
               PM.SCHEME_DOCNO,
               PM.ORDDT,
               PM.DTFR,
               PM.DTTO,
               PD.ICODE,
               PD.RATE   PURCHASE_RATE,
               CASE
                  WHEN COALESCE (PD.OQTY, 0) > 0 THEN PD.OQTY
                  ELSE COALESCE (PD.ORDQTY, 0)
               END
                  ORDER_QTY,
               PD.CNLQTY CANCEL_QTY,
               CASE
                  WHEN GRC.GRCNO IS NOT NULL THEN GRC.ACQTY
                  ELSE PD.RCQTY
               END
                  RECEIVE_QTY,
               GRC.GRCNO,
               GRC.GRCDT,
               GRC.GRCCODE,
               GRC.ACQTY,
               INV.INVNO,
               INV.INVDT,
               PM.ADMSITE_CODE,
               PM.PCODE
          FROM PURORDMAIN PM
               INNER JOIN PURORDDET PD ON PM.ORDCODE = PD.ORDCODE
               LEFT JOIN
               (  SELECT GM.GRCCODE    GRCCODE,
                         GM.SCHEME_DOCNO GRCNO,
                         GM.GRCDT      GRCDT,
                         GD.ORDCODE    PO_ORDCODE,
                         GD.ICODE,
                         SUM (GD.ACQTY) ACQTY
                    FROM INVGRCMAIN GM
                         INNER JOIN INVGRCDET GD ON GM.GRCCODE = GD.GRCCODE
                   WHERE GD.ORDCODE IS NOT NULL
                GROUP BY GM.GRCCODE,
                         GM.SCHEME_DOCNO,
                         GM.GRCDT,
                         GD.ORDCODE,
                         GD.ICODE) GRC
                  ON PD.ICODE = GRC.ICODE AND PD.ORDCODE = GRC.PO_ORDCODE
               LEFT JOIN
               (  SELECT MAX (IM.SCHEME_DOCNO) INVNO,
                         MAX (IM.INVDT)      INVDT,
                         ID.GRCCODE          IV_GRCCODE,
                         ID.ICODE
                    FROM PURINVMAIN IM, PURINVDET ID
                   WHERE IM.INVCODE = ID.INVCODE AND ID.GRCCODE IS NOT NULL
                GROUP BY ID.GRCCODE, ID.ICODE) INV
                  ON GRC.GRCCODE = INV.IV_GRCCODE AND GRC.ICODE = INV.ICODE)
       A
       INNER JOIN GINVIEW.LV_ITEM ITEM ON ITEM.ITEM_CODE = A.ICODE
       INNER JOIN ADMSITE ST ON A.ADMSITE_CODE = ST.CODE
       INNER JOIN FINSL CUST_VEN ON A.PCODE = CUST_VEN.SLCODE
 WHERE     (   A.ADMSITE_CODE =
                  COALESCE (
                     TO_NUMBER (NULLIF ('@OrgSiteName@', ''),
                                '9G999g999999999999d99'),
                     -1)
            OR COALESCE (
                  TO_NUMBER (NULLIF ('@OrgSiteName@', ''),
                             '9G999g999999999999d99'),
                  -1) = -1)
       AND (   A.PCODE =
                  COALESCE (
                     TO_NUMBER (NULLIF ('@VendorName@', ''),
                                '9G999g999999999999d99'),
                     -1)
            OR COALESCE (
                  TO_NUMBER (NULLIF ('@VendorName@', ''),
                             '9G999g999999999999d99'),
                  -1) = -1)
       AND (   ITEM.DIVISION = COALESCE (NULLIF ('@Division@', ''), '-1')
            OR COALESCE (NULLIF ('@Division@', ''), '-1') = '-1')
       AND (   ITEM.SECTION = COALESCE (NULLIF ('@Section@', ''), '-1')
            OR COALESCE (NULLIF ('@Section@', ''), '-1') = '-1')
       AND (   ITEM.DEPARTMENT = COALESCE (NULLIF ('@Department@', ''), '-1')
            OR COALESCE (NULLIF ('@Department@', ''), '-1') = '-1')
       AND A.ORDDT::DATE BETWEEN TO_DATE ('@DTFR@', 'YYYY-MM-DD')
                               AND TO_DATE ('@DTTO@', 'YYYY-MM-DD')