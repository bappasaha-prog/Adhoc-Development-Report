/*><><>< || Custom Development || Object : CQ_POS_ONLINE || Ticket Id : 394420 || Developer : Dipankar || ><><><*/
select
	ginview.fnc_uk() uk,
	f.type,
	f.CHANNEL,
	f.bill_date,
	f.billno,
	f.icode,
	f.bill_qty,
	f.return_qty,
	f.taxable_amt,
	f.round_off,
	f.netpayable,
	f.grossamt,
	f.discountamt,
	f.cgstrate,
	f.cgstamt,
	f.igstrate,
	f.igstamt,
	f.sgstrate,
	f.sgstamt
from
	(
	select
		'POS' type,
		'POS' CHANNEL,
		m.billdate::date bill_date,
		m.billno,
		d.icode,
		sum(d.qty) bill_qty,
		sum(d.rtqty) return_qty,
		sum(d.taxableamt) taxable_amt,
		m.roundoff round_off,
		m.netpayable,
		m.grossamt,
		m.discountamt,
		d.cgstrate,
		sum(d.cgstamt) cgstamt,
		d.igstrate,
		sum(d.igstamt) igstamt,
		d.sgstrate,
		sum(d.sgstamt) sgstamt
	from
		psite_posbill M
	inner join psite_posbillitem D on
		M.CODE = D.psite_posbill_code
	where
		M.billdate::DATE between to_date('@DTFR@',
		'YYYY-MM-DD') and to_date('@DTTO@',
		'YYYY-MM-DD')
	group by
		m.billdate::date,
		m.billno,
		d.icode,
		m.roundoff,
		m.netpayable,
		m.grossamt,
		m.discountamt,
		d.cgstrate,
		d.igstrate,
		d.sgstrate
union all
	select
		'ONLINE' type,
		cu.slname channel,
		m.csdate::date bill_date,
		m.scheme_docno bill_no,
		d.icode,
		sum(case when d.qty >0 then d.qty else 0 end) bill_qty,
		sum(case when d.qty <0 then d.qty else 0 end ) return_qty,
		sum(d.taxableamt) taxable_amt,
		m.roundoff round_off,
		m.netamt netpayable,
		sum(d.grsamt) grossamt,
		sum(d.discount) discountamt,
		d.cgstrate,
		sum(d.cgstamt) cgstamt,
		d.igstrate,
		sum(d.igstamt) igstamt,
		d.sgstrate,
		sum(d.sgstamt) sgstamt
	from
		SALCSMAIN M
	inner join SALCSDET D on
		M.cscode = D.cscode
	inner join finsl cu on
		m.pcode = cu.slcode
	where
		M.csdate::DATE between to_date('@DTFR@',
		'YYYY-MM-DD') and to_date('@DTTO@',
		'YYYY-MM-DD')
	group by
		cu.slname ,
		m.csdate::date ,
		m.scheme_docno ,
		d.icode,
		m.roundoff,
		m.netamt ,
		d.cgstrate,
		d.igstrate,
		d.sgstrate)f