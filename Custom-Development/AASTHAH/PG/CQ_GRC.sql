/*|| Custom Development || Object : CQ_GRC || Ticket Id :  402077 || Developer : Dipankar ||*/

select
    row_number() over() as uk,
    D.icode,
    M.scheme_docno GRC_NO,
    M.grcdt::DATE GRC_DATE,
    M.pcode VENDOR_CODE,
    M.admsite_code_in SITE_CODE,
    M.docno VENDOR_DOC_NO,
    M.docdt::DATE VENDOR_DOC_DATE,
    D.acrate PURCHASE_RATE,
    SUM(D.acqty) RECEIVE_QTY,
    chg."Discount %",
    chg."Freight",
    chg."DISCOUNT(2ND)%",
    chg."Corrier & Postage",
    chg."Disc.Amt (PCS)",
    (sum(sum(chg."Disc.Amt (PCS)")) over(partition by M.scheme_docno)/sum(SUM(D.acqty)) over(partition by M.scheme_docno)) "Per Disc.Amt (PCS)",
    (sum(sum(chg."Freight")) over(partition by M.scheme_docno)/sum(SUM(D.acqty)) over(partition by M.scheme_docno)) "Per Freight",
    (sum(sum(chg."Packing Charges")) over(partition by M.scheme_docno)/sum(SUM(D.acqty)) over(partition by M.scheme_docno)) "Per Packing Charges",
    (sum(sum(chg."Corrier & Postage")) over(partition by M.scheme_docno)/sum(SUM(D.acqty)) over(partition by M.scheme_docno)) "Per Corrier & Postage",
    chg."GST LESS",
    chg."Packing Charges",
    chg."Gst%"
from
    invgrcmain m
inner join invgrcdet d on
    m.grccode = d.grccode
left join (
    select
        C.GRCCODE,
        SUM (A.CHGAMT) CHARGE_AMOUNT,
        C.ICODE,
        sum(case when a.chgcode = 1 then a.rate else 0 end) "Discount %",
        sum(case when a.chgcode = 11 then a.chgamt else 0 end) "Freight",
        sum(case when a.chgcode = 17 then a.rate else 0 end) "DISCOUNT(2ND)%",
        sum(case when a.chgcode = 15 then a.chgamt else 0 end) "Corrier & Postage",
        sum(case when a.chgcode = 10 then a.chgamt else 0 end) "Disc.Amt (PCS)",
        sum(case when a.chgcode = 18 then a.chgamt else 0 end) "GST LESS",
        sum(case when a.chgcode = 12 then a.chgamt else 0 end) "Packing Charges",
        SUM ( case
            when a.isreverse = 'N'
                and a.istax = 'Y' then RATE
                else 0
            end) "Gst%"
    from
        INVGRCCHG_ITEM A
    inner join INVGRCDET C on
        A.INVGRCDET_CODE = C.CODE
    where
        a.grccode in (
        select
            grccode
        from
            invgrcmain
        where
            grcdt::date between to_date('@DTFR@',
            'YYYY-MM-DD') and to_date('@DTTO@',
            'YYYY-MM-DD'))
    group by
        C.GRCCODE,
        C.ICODE
) chg on
    d.grccode = chg.grccode
    and d.icode = chg.icode
where
    m.grcdt::date between to_date('@DTFR@',
    'YYYY-MM-DD') and to_date('@DTTO@',
    'YYYY-MM-DD')
group by
    D.icode,
    M.scheme_docno,
    M.grcdt::DATE,
    M.pcode,
    M.admsite_code_in,
    M.docno,
    M.docdt::DATE,
    D.acrate,
    chg."Discount %",
    chg."Freight",
    chg."DISCOUNT(2ND)%",
    chg."Corrier & Postage",
    chg."Disc.Amt (PCS)",
    chg."GST LESS",
    chg."Packing Charges",
    chg."Gst%"