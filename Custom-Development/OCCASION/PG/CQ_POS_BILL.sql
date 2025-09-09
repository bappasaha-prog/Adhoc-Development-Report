/*|| Custom Development || Object : CQ_POS_BILL || Ticket Id :  430557 || Developer : Dipankar ||*/

with mop as (
select
	m.psite_posbill_code,
	m.mopdesc ,
	m.baseamt,
	d.dnno debit_note_no,
	d.amount debit_note_amt,
	dep.billdate::date depref_bill_date,
	dep.billno depref_bill_no,
	dep.amount depref_bill_amt,
	dep.remarks depref_remarks
from
	psite_posbillmop m
left join psite_posbilldn d on
	m.psite_posbilldn_code = d.code
left join psite_posdeprefbill dep on
	d.dna_bill_code = dep.code )
select
    row_number() OVER() as UK,
	m.admsite_code ,
	m.billdate::date bill_date,
	m.billno ,
	m.remarks bill_remarks,
	string_agg(distinct concat_ws(' ', ps.fname, ps.mname, ps.lname), ',' order by concat_ws(' ', ps.fname, ps.mname, ps.lname) ) sales_person_name,
	concat_ws(' ', pc.fname, pc.mname, pc.lname) customer_name,
	pc.mobile,
	m.udfdate01,
	a.mop_name,
	b.debit_note_no,
	b.debit_note_amt,
	b.depref_bill_date,
	b.depref_bill_no,
	b.depref_bill_amt,
	b.depref_remarks,
	sum(d.qty) bill_qty,
	sum(d.netamt) bill_net_amt
from
	PSITE_POSBILL M
inner join PSITE_POSBILLITEM D on
	M.CODE = D.PSITE_POSBILL_CODE
left join psite_customer pc on
	m.psite_customer_code = pc.code
left join psite_salesperson ps on
	d.psite_salesperson_id = ps.id
	and d.admsite_code = ps.admsite_code
left join (
	select
		psite_posbill_code ,
		string_agg(concat_ws('/', mopdesc, baseamt), ', ' order by concat_ws('/', mopdesc, baseamt)) mop_name
	from
		mop
	where
		mopdesc <> 'Debit Note Issued'
	group by
		psite_posbill_code) A on
	M.CODE = A.psite_posbill_code
left join (
	select
		psite_posbill_code ,
		debit_note_no,
		debit_note_amt,
		depref_bill_date,
		depref_bill_no,
		depref_bill_amt,
		depref_remarks
	from
		mop
	where
		mopdesc = 'Debit Note Issued') B on
	M.CODE = B.psite_posbill_code
	where m.billdate::date between to_date('@DTFR@','YYYY-MM-DD') and to_date('@DTTO@','YYYY-MM-DD')
group by 
	m.admsite_code ,
	m.billdate::date,
	m.billno ,
	m.remarks,
	concat_ws(' ', pc.fname, pc.mname, pc.lname),
	pc.mobile,
	m.udfdate01,
	a.mop_name,
	b.debit_note_no,
	b.debit_note_amt,
	b.depref_bill_date,
	b.depref_bill_no,
	b.depref_bill_amt,
	b.depref_remarks