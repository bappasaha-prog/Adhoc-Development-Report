/*><><>< || Custom Development || Object : CQ_MOP_COLLECTION || Ticket Id : 399604 || Developer : Dipankar || ><><><*/
select
	GINVIEW.FNC_UK() UK,
    b.admsite_code,
    S.name SITE_NAME,
    SUM(case when m.mopdesc = 'Cash' then m.baseamt else 0 end ) Cash,
    SUM(case when m.mopdesc = 'Bank EDC' then m.baseamt else 0 end ) Bank_EDC,
    SUM(case when m.mopdesc = 'Digital Payment' then m.baseamt else 0 end ) Digital_Payment,
    SUM(case when m.mopdesc = 'Debit Note Adjusted' then m.baseamt else 0 end ) Debit_Note_Adjusted,
    SUM(case when m.mopdesc = 'Debit Note Issued' then m.baseamt else 0 end ) Debit_Note_Issued,
    SUM(case when m.mopdesc = 'Credit Note Issued' then m.baseamt else 0 end ) Credit_Note_Issued,
    SUM(case when m.mopdesc = 'Credit Note Received' then m.baseamt else 0 end ) Credit_Note_Received,
    SUM(case when b.head_name = 'Cash Deposit Bank' then m.baseamt else 0 end ) BANK_DEPOSIT,
    SUM(case when b.head_name = 'Cash Transfer To HO' then m.baseamt else 0 end ) HO_TRANSFER,
    SUM(case when b.head_name not in ('Cash Deposit Bank', 'Cash Transfer To HO') then m.baseamt else 0 end ) OTHER_EXPENSES,
    sum(case when m.paymentsource = 'POSBill' then m.baseamt else 0 end) BILL_AMT,
    OPENING
from
    psite_posbillmop m
inner join (
    select
        code billid,
        billdate::DATE billdate,
        admsite_code,
        null head_name
    from
        psite_posbill
union all
    select
        m.code billid,
        m.billdate::DATE billdate,
        m.admsite_code,
        h.name head_name
    from
        psite_ptcbill m
    inner join psite_ptchead h on
        m.psite_ptchead_code = h.code
        ) b on
    (m.psite_posbill_code = b.billid)
inner join (select
	M.admsite_code,
	M.stlmfor::DATE BILL_DATE,
	SUM(D.amount) opening
from
	PSITE_POSSTLM M
inner join PSITE_POSSTLMDETAIL D on
	M.CODE = D.psite_posstlm_code
where
	D.TYPE = 'CashSummary'
	and D.SUBTYPE = 'Opening'
group by
	M.admsite_code,
	M.stlmfor::DATE)STLM on 
    b.billdate = STLM.BILL_DATE
    and B.admsite_code = STLM.admsite_code
inner join admsite s on
    (m.admsite_code = s.code)
where
    b.billdate::date = to_date('@ASON@',
    'yyyy-mm-dd')
group by
    b.admsite_code,
    S.name,
    OPENING