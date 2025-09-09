/*|| Custom Development || Object : CQ_ALL_SALE || Ticket Id :  420232 || Developer : Dipankar ||*/

select row_number() over() uk,f.* from (
SELECT 'Sales Invoice' TYPE,C.GST_IDENTIFICATION_NO GSTIN_NO,C.NAME RECEIVER_NAME,M.docno GST_DOCNO,M.INVDT::DATE INVOICE_DATE,M.scheme_docno ENTRY_NO,
C.billing_city DELIVERY_CITY,P."name" INVOICE_TYPE,D.hsn_sac_code,case when M.release_status ='P'then 'Posted' else 'Un-Posted' end release_status,
                       SUM ( (COALESCE (D.INVAMT, 0) + COALESCE (D.CHGAMT, 0))
                       + COALESCE (D.TAXAMT, 0)) NET_AMOUNT,
                       SUM(D.INVQTY) QTY,
                       D.rate INVOICE_RATE,
                       SUM(TAX.taxable_amount) TAXABLE_AMOUNT,
                       TAX.cgst_rate,
                       SUM(TAX.cgst_amount) cgst_amount,
                       TAX.igst_rate,
                       SUM(TAX.igst_amount) igst_amount,
                       TAX.sgst_rate,
                       SUM(TAX.sgst_amount) sgst_amount
  FROM SALINVMAIN M
       INNER JOIN SALINVDET D ON M.INVCODE = D.INVCODE
       LEFT JOIN GINVIEW.LV_CUSTOMER_SUPPLIER C ON M.PCODE = C.CODE
       LEFT OUTER JOIN FINTRADEGRP P ON (M.SALTRADEGRP_CODE = P.CODE)
       LEFT OUTER JOIN
       (  SELECT SALINVDET_CODE,
                 INVCODE,
                 APPAMT                   TAXABLE_AMOUNT,
                 SUM (COALESCE (CHGAMT, 0)) TAX_CHARGE_AMOUNT,
                 SUM (CASE WHEN GST_COMPONENT = 'CGST' THEN RATE ELSE 0 END)
                    CGST_RATE,
                 SUM (CASE WHEN GST_COMPONENT = 'CGST' THEN CHGAMT ELSE 0 END)
                    CGST_AMOUNT,
                 SUM (CASE WHEN GST_COMPONENT = 'SGST' THEN RATE ELSE 0 END)
                    SGST_RATE,
                 SUM (CASE WHEN GST_COMPONENT = 'SGST' THEN CHGAMT ELSE 0 END)
                    SGST_AMOUNT,
                 SUM (CASE WHEN GST_COMPONENT = 'IGST' THEN RATE ELSE 0 END)
                    IGST_RATE,
                 SUM (CASE WHEN GST_COMPONENT = 'IGST' THEN CHGAMT ELSE 0 END)
                    IGST_AMOUNT
            FROM SALINVCHG_ITEM
           WHERE ISTAX = 'Y'
        GROUP BY SALINVDET_CODE, INVCODE, APPAMT) TAX
          ON (D.CODE = TAX.SALINVDET_CODE AND D.INVCODE = TAX.INVCODE)
          WHERE M.SALETYPE = 'O' and M.INVDT::DATE between TO_DATE('@DTFR@','YYYY-MM-DD') AND TO_DATE('@DTTO@','YYYY-MM-DD')
group by C.GST_IDENTIFICATION_NO ,C.NAME ,M.docno ,M.INVDT::DATE ,M.scheme_docno ,
C.billing_city ,P."name" ,D.hsn_sac_code,M.release_status,D.rate,TAX.cgst_rate,TAX.igst_rate,TAX.sgst_rate
UNION ALL
SELECT 'Sales Return' TYPE,C.GST_IDENTIFICATION_NO GSTIN_NO,C.NAME RECEIVER_NAME,M.docno GST_DOCNO,M.RTDT::DATE INVOICE_DATE,M.scheme_docno ENTRY_NO,
C.billing_city DELIVERY_CITY,P."name" INVOICE_TYPE,D.hsn_sac_code,case when M.release_status ='P'then 'Posted' else 'Un-Posted' end release_status,
                       (  SUM (COALESCE (D.QTY, 0) * COALESCE (D.RATE, 0))
                       + SUM (COALESCE (TAX.TAX_CHARGE_AMOUNT, 0)))
                       + SUM (COALESCE (OTX.OTHER_CHARGE_AMOUNT, 0)) NET_AMOUNT,
                       SUM(D.QTY) QTY,
                       D.rate INVOICE_RATE,
                       SUM(TAX.taxable_amount) TAXABLE_AMOUNT,
                       TAX.cgst_rate,
                       SUM(TAX.cgst_amount) cgst_amount,
                       TAX.igst_rate,
                       SUM(TAX.igst_amount) igst_amount,
                       TAX.sgst_rate,
                       SUM(TAX.sgst_amount) sgst_amount
  FROM SALRTMAIN M
       INNER JOIN SALRTDET D ON M.RTCODE = D.RTCODE
       LEFT JOIN GINVIEW.LV_CUSTOMER_SUPPLIER C ON M.PCODE = C.CODE
       LEFT OUTER JOIN FINTRADEGRP P ON (M.SALTRADEGRP_CODE = P.CODE)
       LEFT OUTER JOIN
                    (  SELECT RTCODE,
                              SALRTDET_CODE,
                              SUM (COALESCE (CHGAMT, 0)) OTHER_CHARGE_AMOUNT
                         FROM SALRTCHG_ITEM
                        WHERE ISTAX = 'N'
                     GROUP BY RTCODE, SALRTDET_CODE) OTX
                       ON (D.RTCODE = OTX.RTCODE AND D.CODE = OTX.SALRTDET_CODE)
       LEFT OUTER JOIN
       (  SELECT SALRTDET_CODE,
                 RTCODE,
                 APPAMT                   TAXABLE_AMOUNT,
                 SUM (COALESCE (CHGAMT, 0)) TAX_CHARGE_AMOUNT,
                 SUM (CASE WHEN GST_COMPONENT = 'CGST' THEN RATE ELSE 0 END)
                    CGST_RATE,
                 SUM (CASE WHEN GST_COMPONENT = 'CGST' THEN CHGAMT ELSE 0 END)
                    CGST_AMOUNT,
                 SUM (CASE WHEN GST_COMPONENT = 'SGST' THEN RATE ELSE 0 END)
                    SGST_RATE,
                 SUM (CASE WHEN GST_COMPONENT = 'SGST' THEN CHGAMT ELSE 0 END)
                    SGST_AMOUNT,
                 SUM (CASE WHEN GST_COMPONENT = 'IGST' THEN RATE ELSE 0 END)
                    IGST_RATE,
                 SUM (CASE WHEN GST_COMPONENT = 'IGST' THEN CHGAMT ELSE 0 END)
                    IGST_AMOUNT
            FROM SALRTCHG_ITEM
           WHERE ISTAX = 'Y'
        GROUP BY SALRTDET_CODE, RTCODE, APPAMT) TAX
          ON (D.CODE = TAX.SALRTDET_CODE AND D.RTCODE = TAX.RTCODE)
          WHERE M.SALETYPE = 'O' and M.RTDT::DATE between TO_DATE('@DTFR@','YYYY-MM-DD') AND TO_DATE('@DTTO@','YYYY-MM-DD')
group by C.GST_IDENTIFICATION_NO ,C.NAME ,M.docno ,M.RTDT::DATE ,M.scheme_docno ,
C.billing_city ,P."name" ,D.hsn_sac_code,M.release_status,D.rate,TAX.cgst_rate,TAX.igst_rate,TAX.sgst_rate
UNION ALL
SELECT 'POS Bill' TYPE,C.gst_identification_no  GSTIN_NO,C.full_name  RECEIVER_NAME,M.gstdocno GST_DOCNO,M.billdate::DATE INVOICE_DATE,M.billno ENTRY_NO,
C.CITY DELIVERY_CITY,case when COALESCE(d.igstrate,0) = 0 then 'Local' else 'Inter State' end  INVOICE_TYPE,D.hsn_sac_code,'No' release_status,
                       SUM(D.netamt) NET_AMOUNT,
                       SUM(D.QTY) QTY,
                       d.rsp INVOICE_RATE,
                       SUM(d.taxableamt) TAXABLE_AMOUNT,
                       d.cgstrate ,
                       SUM(d.cgstamt) ,
                       d.igstrate ,
                       SUM(d.igstamt) ,
                       d.sgstrate ,
                       SUM(d.sgstamt)
  FROM PSITE_POSBILL M
       INNER JOIN PSITE_POSBILLITEM D ON M.CODE = D.PSITE_POSBILL_CODE
       left JOIN GINVIEW.lv_pos_customer C ON M.PSITE_CUSTOMER_CODE = C.CODE
       WHERE D.QTY>0 and M.billdate::DATE between TO_DATE('@DTFR@','YYYY-MM-DD') AND TO_DATE('@DTTO@','YYYY-MM-DD')
group by C.gst_identification_no,C.full_name,M.gstdocno,M.billdate::DATE,M.billno,
C.CITY,D.hsn_sac_code,d.rsp,d.cgstrate,d.igstrate,d.sgstrate
UNION ALL
SELECT 'POS Bill' TYPE,C.gst_identification_no  GSTIN_NO,C.full_name  RECEIVER_NAME,M.gstdocno GST_DOCNO,M.voidbilldate::DATE INVOICE_DATE,M.voidbillno ENTRY_NO,
C.CITY DELIVERY_CITY,case when COALESCE(d.igstrate,0) = 0 then 'Local' else 'Inter State' end INVOICE_TYPE,D.hsn_sac_code,'Yes' release_status,
                       SUM(D.netamt) NET_AMOUNT,
                       SUM(D.QTY) QTY,
                       d.rsp  INVOICE_RATE,
                       SUM(d.taxableamt) TAXABLE_AMOUNT,
                       d.cgstrate ,
                       SUM(d.cgstamt) ,
                       d.igstrate ,
                       SUM(d.igstamt) ,
                       d.sgstrate ,
                       SUM(d.sgstamt)
  FROM PSITE_POSBILLVOID M
       INNER JOIN PSITE_POSBILLITEMVOID D ON M.CODE = D.PSITE_POSBILLVOID_CODE
       left JOIN GINVIEW.lv_pos_customer C ON M.PSITE_CUSTOMER_CODE = C.CODE
       WHERE D.QTY>0 and M.voidbilldate::DATE between TO_DATE('@DTFR@','YYYY-MM-DD') AND TO_DATE('@DTTO@','YYYY-MM-DD')
group by C.gst_identification_no,C.full_name,M.gstdocno,M.voidbilldate::DATE,M.voidbillno,
C.CITY,D.hsn_sac_code,d.rsp,d.cgstrate,d.igstrate,d.sgstrate
UNION ALL
SELECT 'POS Return' TYPE,C.gst_identification_no  GSTIN_NO,C.full_name  RECEIVER_NAME,M.gstdocno GST_DOCNO,M.billdate::DATE INVOICE_DATE,M.billno ENTRY_NO,
C.CITY DELIVERY_CITY,case when COALESCE(d.igstrate,0) = 0 then 'Local' else 'Inter State' end INVOICE_TYPE,D.hsn_sac_code,'No' release_status,
                       SUM(D.netamt) NET_AMOUNT,
                       SUM(D.QTY) QTY,
                       d.rsp  INVOICE_RATE,
                       SUM(d.taxableamt) TAXABLE_AMOUNT,
                       d.cgstrate ,
                       SUM(d.cgstamt) ,
                       d.igstrate ,
                       SUM(d.igstamt) ,
                       d.sgstrate ,
                       SUM(d.sgstamt)
  FROM PSITE_POSBILL M
       INNER JOIN PSITE_POSBILLITEM D ON M.CODE = D.PSITE_POSBILL_CODE
       left JOIN GINVIEW.lv_pos_customer C ON M.PSITE_CUSTOMER_CODE = C.CODE
       WHERE D.QTY<0 and M.billdate::DATE between TO_DATE('@DTFR@','YYYY-MM-DD') AND TO_DATE('@DTTO@','YYYY-MM-DD')
group by C.gst_identification_no,C.full_name,M.gstdocno,M.billdate::DATE,M.billno,
C.CITY,D.hsn_sac_code,d.rsp,d.cgstrate,d.igstrate,d.sgstrate
UNION ALL
SELECT 'POS Return' TYPE,C.gst_identification_no  GSTIN_NO,C.full_name  RECEIVER_NAME,M.gstdocno GST_DOCNO,M.voidbilldate::DATE INVOICE_DATE,M.voidbillno ENTRY_NO,
C.CITY DELIVERY_CITY,case when COALESCE(d.igstrate,0) = 0 then 'Local' else 'Inter State' end INVOICE_TYPE,D.hsn_sac_code,'Yes' release_status,
                       SUM(D.netamt) NET_AMOUNT,
                       SUM(D.QTY) QTY,
                       d.rsp  INVOICE_RATE,
                       SUM(d.taxableamt) TAXABLE_AMOUNT,
                       d.cgstrate ,
                       SUM(d.cgstamt) ,
                       d.igstrate ,
                       SUM(d.igstamt) ,
                       d.sgstrate ,
                       SUM(d.sgstamt)
  FROM PSITE_POSBILLVOID M
       INNER JOIN PSITE_POSBILLITEMVOID D ON M.CODE = D.PSITE_POSBILLVOID_CODE
       left JOIN GINVIEW.lv_pos_customer C ON M.PSITE_CUSTOMER_CODE = C.CODE
       WHERE D.QTY<0 and M.voidbilldate::DATE between TO_DATE('@DTFR@','YYYY-MM-DD') AND TO_DATE('@DTTO@','YYYY-MM-DD')
group by C.gst_identification_no,C.full_name,M.gstdocno,M.voidbilldate::DATE,M.voidbillno,
C.CITY,D.hsn_sac_code,d.rsp,d.cgstrate,d.igstrate,d.sgstrate)f