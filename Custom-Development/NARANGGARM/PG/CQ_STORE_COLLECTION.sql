/*|| Custom Development || Object : CQ_STORE_COLLECTION || Ticket Id :  411004 || Developer : Dipankar ||*/
SELECT null REQUESTID
        ,ginview.fnc_uk() uk
        ,admsite_code
        ,billdate
        ,billno
        ,PAYMENTSOURCE
        ,MOPDESC
        ,sum(BASEAMT) BASEAMT
        ,IS_VOID 
        ,UDFSTRING1
        ,UDFSTRING2
        ,UDFSTRING3
        ,UDFSTRING4
        ,UDFSTRING5
        ,UDFSTRING6
        ,UDFSTRING7
        ,UDFSTRING8
        ,UDFSTRING9
        ,UDFSTRING10
        ,UDFNUM01
        ,UDFNUM02
        ,UDFNUM03
        ,UDFNUM04
        ,UDFNUM05
        ,UDFDATE01
        ,UDFDATE02
        ,UDFDATE03
        ,UDFDATE04
        ,UDFDATE05
        ,CREATEBY
        ,CREATEDON
        ,LASTMODIFIEDBY
        ,LASTMODIFIEDON
        ,PSITE_CUSTOMER_CODE,
        /*Start Changes Bug Id : 110781*/
        WALLET_REF_NUMBER,
        TPEDC_RESPONSE
        /*End Changes Bug Id : 110781*/,
        terminal
FROM
(
    select b.admsite_code,
            b.billdate::date billdate,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillNo@',''),'-1'),'9G999g999') = 1 then billno else 'All Bill' end billno,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then paymentsource else 'All Type' end paymentsource,
            mopdesc,
            baseamt,
            'No' is_void,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillNo@',''),'-1'),'9G999g999')  = 1 then b.udfstring1 end udfstring1,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillNo@',''),'-1'),'9G999g999')  = 1 then b.udfstring2 end udfstring2,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.udfstring3 end udfstring3,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.udfstring4 end udfstring4,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.udfstring5 end udfstring5,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.udfstring6 end udfstring6,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.udfstring7 end udfstring7,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.udfstring8 end udfstring8,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.udfstring9 end udfstring9,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.udfstring10 end udfstring10,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.UDFNUM01 end UDFNUM01,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.UDFNUM02 end UDFNUM02,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.UDFNUM03 end UDFNUM03,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.UDFNUM04 end UDFNUM04,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.UDFNUM05 end UDFNUM05,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.UDFDATE01 end UDFDATE01,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.UDFDATE02 end UDFDATE02,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.UDFDATE03 end UDFDATE03,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.UDFDATE03 end UDFDATE04,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.UDFDATE05  end UDFDATE05,
            CREATEBY,
            CREATEDON,
            LASTMODIFIEDBY,
            LASTMODIFIEDON,
            PSITE_CUSTOMER_CODE,
            /*Start Changes Bug Id : 110781*/
            m.WLT_REFNUMBER WALLET_REF_NUMBER,
            m.TPEDCRESPONSE TPEDC_RESPONSE
            /*End Changes Bug Id : 110781*/,
            b.terminal
    from psite_posbillmop m
        inner join (
            SELECT admsite_code,
                  code billid,
                  billno,
                  billdate,
                  psite_customer_code,
                  createby,
                  createdon,
                  lastmodifiedon,
                  lastmodifiedby,
                  udfstring1,
                  udfstring2,
                  udfstring3,
                  udfstring4,
                  udfstring5,
                  udfstring6,
                  udfstring7,
                  udfstring8,
                  udfstring9,
                  udfstring10,
                  UDFNUM01,
                  UDFNUM02, 
                  UDFNUM03, 
                  UDFNUM04, 
                  UDFNUM05, 
                  UDFDATE01, 
                  UDFDATE02, 
                  UDFDATE03, 
                  UDFDATE04, 
                  UDFDATE05,
                  terminal
            FROM psite_posbill
            UNION ALL
            SELECT admsite_code,
                  code billid,
                  billno,
                  billdate,
                  psite_customer_code,
                  createdby,
                  createdon,
                  lastmodifiedon,
                  lastmodifiedby,
                  udfstring1,
                  udfstring2,
                  udfstring3,
                  udfstring4,
                  udfstring5,
                  udfstring6,
                  udfstring7,
                  udfstring8,
                  udfstring9,
                  udfstring10,
                  UDFNUM01,
                  UDFNUM02, 
                  UDFNUM03, 
                  UDFNUM04, 
                  UDFNUM05, 
                  UDFDATE01, 
                  UDFDATE02, 
                  UDFDATE03, 
                  UDFDATE04, 
                  UDFDATE05,
                  terminal
            FROM psite_posgvbill
            UNION ALL
            SELECT admsite_code,
                  code billid,
                  billno,
                  billdate,
                  psite_customer_code,
                  createby,
                  createdon,
                  lastmodifiedon,
                  lastmodifiedby,
                  udfstring1,
                  udfstring2,
                  udfstring3,
                  udfstring4,
                  udfstring5,
                  udfstring6,
                  udfstring7,
                  udfstring8,
                  udfstring9,
                  udfstring10,
                  UDFNUM01,
                  UDFNUM02, 
                  UDFNUM03, 
                  UDFNUM04, 
                  UDFNUM05, 
                  UDFDATE01, 
                  UDFDATE02, 
                  UDFDATE03, 
                  UDFDATE04, 
                  UDFDATE05,
                  terminal
            FROM psite_posdeprefbill
            UNION ALL
            SELECT admsite_code,
                  code billid,
                  billno,
                  billdate,
                  null psite_customer_code,
                  createdby,
                  createdon,
                  lastmodifiedon,
                  lastmodifiedby,
                  null udfstring1,
                  null udfstring2,
                  null udfstring3,
                  null udfstring4,
                  null udfstring5,
                  null udfstring6,
                  null udfstring7,
                  null udfstring8,
                  null udfstring9,
                  null udfstring10,
                  null UDFNUM01,
                  null UDFNUM02, 
                  null UDFNUM03, 
                  null UDFNUM04, 
                  null UDFNUM05, 
                  null UDFDATE01, 
                  null UDFDATE02, 
                  null UDFDATE03, 
                  null UDFDATE04, 
                  null UDFDATE05,
                  terminal
             FROM psite_ptcbill
        ) b on (m.psite_posbill_code = b.billid)
        inner join admsite s on (m.admsite_code = s.code)
    Where  TO_NUMBER(COALESCE(nullif('@ShowVoidOnly@',''),'-1'),'9G999g999') = 0
    AND   b.billdate::date BETWEEN  to_date('@DTFR@', 'yyyy-mm-dd') AND to_date('@DTTO@', 'yyyy-mm-dd')
    AND (s.sitetype IN (
SELECT unnest(regexp_matches('@#OwnerSiteSiteTypeMulti#@', '[^æ]+', 'g')) AS col1
FROM generate_series(1, (SELECT count(*) FROM regexp_matches('@#OwnerSiteSiteTypeMulti#@', 'æ', 'g'))+1) AS g
) or COALESCE (NULLIF ('@#OwnerSiteSiteTypeMulti#@', ''), '0')::text =0::text)
    AND (s.name IN (
SELECT unnest(regexp_matches('@#OwnerSiteNameMulti#@', '[^æ]+', 'g')) AS col1
FROM generate_series(1, (SELECT count(*) FROM regexp_matches('@#OwnerSiteNameMulti#@', 'æ', 'g'))+1) AS g
) or COALESCE (NULLIF ('@#OwnerSiteNameMulti#@', ''), '0')::text =0::text)
    union all
    select b.admsite_code,
            b.billdate::date billdate,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then billno else 'All Bill' end billno,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then paymentsource else 'All Type' end paymentsource,
            mopdesc,
            baseamt,
            'Yes' is_void,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.udfstring1 end udfstring1,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.udfstring2 end udfstring2,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.udfstring3 end udfstring3,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.udfstring4 end udfstring4,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.udfstring5 end udfstring5,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.udfstring6 end udfstring6,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.udfstring7 end udfstring7,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.udfstring8 end udfstring8,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.udfstring9 end udfstring9,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.udfstring10 end udfstring10,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.UDFNUM01 end UDFNUM01,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.UDFNUM02 end UDFNUM02,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.UDFNUM03 end UDFNUM03,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.UDFNUM04 end UDFNUM04,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.UDFNUM05 end UDFNUM05,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.UDFDATE01 end UDFDATE01,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.UDFDATE02 end UDFDATE02,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.UDFDATE03 end UDFDATE03,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.UDFDATE03 end UDFDATE04,
            case when TO_NUMBER(COALESCE(nullif('@ShowBillType@',''),'-1'),'9G999g999') = 1 then b.UDFDATE05  end UDFDATE05,
            CREATEBY,
            CREATEDON,
            LASTMODIFIEDBY,
            cast(null as timestamp without time zone) LASTMODIFIEDON,
            PSITE_CUSTOMER_CODE,
            /*Start Changes Bug Id : 110781*/
            m.WLT_REFNUMBER WALLET_REF_NUMBER,
            m.TPEDCRESPONSE TPEDC_RESPONSE
            /*End Changes Bug Id : 110781*/,
            b.terminal
    from psite_posbillmopvoid m
        inner join (
            SELECT admsite_code,
                  code billid,
                  voidbillno billno,
                  voidbilldate billdate,
                  psite_customer_code,
                  createby,
                  createdon,
                  null lastmodifiedon,
                  null lastmodifiedby,
                  udfstring1,
                  udfstring2,
                  udfstring3,
                  udfstring4,
                  udfstring5,
                  udfstring6,
                  udfstring7,
                  udfstring8,
                  udfstring9,
                  udfstring10,
                  UDFNUM01,
                  UDFNUM02, 
                  UDFNUM03, 
                  UDFNUM04, 
                  UDFNUM05, 
                  UDFDATE01, 
                  UDFDATE02, 
                  UDFDATE03, 
                  UDFDATE04, 
                  UDFDATE05,
                  terminal
            FROM psite_posbillvoid
            UNION ALL
            SELECT admsite_code,
                  code billid,
                  voidbillno billno,
                  voidbilldate billdate,
                  psite_customer_code,
                  createby,
                  createdon,
                  null lastmodifiedon,
                  null lastmodifiedby,
                  udfstring1,
                  udfstring2,
                  udfstring3,
                  udfstring4,
                  udfstring5,
                  udfstring6,
                  udfstring7,
                  udfstring8,
                  udfstring9,
                  udfstring10,
                  UDFNUM01,
                  UDFNUM02, 
                  UDFNUM03, 
                  UDFNUM04, 
                  UDFNUM05, 
                  UDFDATE01, 
                  UDFDATE02, 
                  UDFDATE03, 
                  UDFDATE04, 
                  UDFDATE05,
                  terminal
            FROM psite_posdeprefbillvoid
            UNION ALL
            SELECT admsite_code,
                  code billid,
                  voidbillno billno,
                  voidbilldate billdate,
                  null psite_customer_code,
                  createdby,
                  createdon,
                  null lastmodifiedon,
                  null lastmodifiedby,
                  null udfstring1,
                  null udfstring2,
                  null udfstring3,
                  null udfstring4,
                  null udfstring5,
                  null udfstring6,
                  null udfstring7,
                  null udfstring8,
                  null udfstring9,
                  null udfstring10,
                  null UDFNUM01,
                  null UDFNUM02, 
                  null UDFNUM03, 
                  null UDFNUM04, 
                  null UDFNUM05, 
                  null UDFDATE01, 
                  null UDFDATE02, 
                  null UDFDATE03, 
                  null UDFDATE04, 
                  null UDFDATE05,
                  terminal
             FROM psite_ptcbillvoid
        ) b on (m.psite_posbillvoid_code = b.billid)    
        inner join admsite s on (b.admsite_code = s.code)
    Where  TO_NUMBER(COALESCE(nullif('@ShowVoidOnly@',''),'-1'),'9G999g999') = 1
    AND   b.billdate::date BETWEEN  to_date('@DTFR@', 'yyyy-mm-dd') AND to_date('@DTTO@', 'yyyy-mm-dd')
    AND (s.sitetype IN (
SELECT unnest(regexp_matches('@#OwnerSiteSiteTypeMulti#@', '[^æ]+', 'g')) AS col1
FROM generate_series(1, (SELECT count(*) FROM regexp_matches('@#OwnerSiteSiteTypeMulti#@', 'æ', 'g'))+1) AS g
) or COALESCE (NULLIF ('@#OwnerSiteSiteTypeMulti#@', ''), '0')::text =0::text)
    AND (s.name IN (
SELECT unnest(regexp_matches('@#OwnerSiteNameMulti#@', '[^æ]+', 'g')) AS col1
FROM generate_series(1, (SELECT count(*) FROM regexp_matches('@#OwnerSiteNameMulti#@', 'æ', 'g'))+1) AS g
) or COALESCE (NULLIF ('@#OwnerSiteNameMulti#@', ''), '0')::text =0::text)   
) q1
GROUP BY
        admsite_code
        ,billdate
        ,billno
        ,PAYMENTSOURCE
        ,MOPDESC
        ,IS_VOID
        ,UDFSTRING1
        ,UDFSTRING2
        ,UDFSTRING3
        ,UDFSTRING4
        ,UDFSTRING5
        ,UDFSTRING6
        ,UDFSTRING7
        ,UDFSTRING8
        ,UDFSTRING9
        ,UDFSTRING10
        ,UDFNUM01
        ,UDFNUM02
        ,UDFNUM03
        ,UDFNUM04
        ,UDFNUM05
        ,UDFDATE01
        ,UDFDATE02
        ,UDFDATE03
        ,UDFDATE04
        ,UDFDATE05
        ,CREATEBY
        ,CREATEDON
        ,LASTMODIFIEDBY
        ,LASTMODIFIEDON
        ,PSITE_CUSTOMER_CODE
        /*Start Changes Bug Id : 110781*/
        ,WALLET_REF_NUMBER,
        TPEDC_RESPONSE
        /*End Changes Bug Id : 110781*/,
        terminal