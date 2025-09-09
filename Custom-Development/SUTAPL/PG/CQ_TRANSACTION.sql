/*|| Custom Development || Object : CQ_TRANSACTION || Ticket Id :  415070 || Developer : Dipankar ||*/

select
	row_number() over() as uk,
	entcode::varchar entcode,
	slcode ,
	taxable_value,
	gross_value,
	ref_ledger
from
	(
	select
		m.srvcode entcode,
		m.pcode slcode,
		m.grsamt taxable_value,
		m.netamt gross_value,
		STRING_AGG(distinct g.glname, ',' order by g.glname) ref_ledger
	from
		pursrvmain m
	inner join pursrvdet d on
		m.srvcode = d.srvcode
	left join fingl g on
		d.glcode = g.glcode
	group by 
		m.srvcode ,
		m.pcode ,
		m.grsamt ,
		m.netamt
union all
	select
		m.jrncode entcode,
		m.pcode slcode,
		m.grsamt taxable_value,
		m.netamt gross_value,
		g.glname ref_ledger
	from
		PURINVJRNMAIN m
	left join fingl g on
		m.pglcode = g.glcode
	where
		M.JRNTYPE = 'D'
union all
	select
		m.jrncode entcode,
		m.pcode slcode,
		m.grsamt taxable_value,
		m.netamt gross_value,
		g.glname ref_ledger
	from
		PURINVJRNMAIN m
	left join fingl g on
		m.pglcode = g.glcode
	where
		M.JRNTYPE = 'C'
union all
	select
		m.invcode entcode,
		m.pcode slcode,
		m.grsamt taxable_value,
		m.netamt gross_value,
		g.glname ref_ledger
	from
		PURINVMAIN m
	left join fingl g on
		m.glcode = g.glcode
union all
	select
		m.jrncode entcode,
		m.pcode slcode,
		m.grsamt taxable_value,
		m.netamt gross_value,
		STRING_AGG(distinct g.glname, ',' order by g.glname) ref_ledger
	from
		PURSRVJRNMAIN m
	inner join PURSRVJRNDET D on
		m.jrncode = d.jrncode
	left join fingl g on
		d.glcode = g.glcode
	where
		M.JRNTYPE = 'D'
	group by 
		m.jrncode,
		m.pcode,
		m.grsamt,
		m.netamt
union all
	select
		m.RTCODE entcode,
		m.pcode slcode,
		m.grsamt taxable_value,
		m.netamt gross_value,
		g.glname ref_ledger
	from
		PURRTMAIN m
	left join fingl g on
		m.glcode = g.glcode
union all
	select
		m.invcode entcode,
		m.pcode slcode,
		m.grsamt taxable_value,
		m.netamt gross_value,
		null ref_ledger
	from
		salinvmain m
		where m.saletype = 'O'
union all
	select
		m.rtcode entcode,
		m.pcode slcode,
		m.grsamt taxable_value,
		m.netamt gross_value,
		null ref_ledger
	from
		salrtmain m
		where m.saletype = 'O'
union all
	select
		m.cscode entcode,
		m.pcode slcode,
		m.grsamt taxable_value,
		m.netamt gross_value,
		null ref_ledger
	from
		salcsmain m
		where m.channeltype = 'ETL')