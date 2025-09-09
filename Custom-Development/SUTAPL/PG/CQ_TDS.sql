/*|| Custom Development || Object : CQ_TDS || Ticket Id :  415070 || Developer : Dipankar ||*/
select
	row_number() over() uk,
	entcode,
	enttype,
	slcode,
	ENTRY_NO,
	slname,
	AMOUNT
from
	(
	select
		P1.entcode ,
		P1.enttype,
		P1.slcode,
		P1.scheme_docno ENTRY_NO,
		S.slname,
		P2.camount AMOUNT
	from
		(
		select
			ENTCODE1 ,
			ENTTYPE1,
			ENTCODE2,
			ENTTYPE2
		from
			FINTAG
		where
			ENTTYPE1 in ('VDP', 'PIM', 'PSM')
	union
		select
			ENTCODE2 ,
			ENTTYPE2,
			ENTCODE1,
			ENTTYPE1
		from
			FINTAG
		where
			ENTTYPE2 in ('VDP', 'PIM', 'PSM')) T
	join FINPOST P1 on
		(T.entcode1::VARCHAR = P1.entcode
			and T.enttype1 = P1.enttype)
	join FINPOST P2 on
		(T.entcode2::VARCHAR = P2.entcode
			and T.enttype2 = P2.enttype)
	left join FINSL S on
		P2.slcode = S.slcode
	where
		T.ENTTYPE2 in ('JDT')
		and P2.camount <> 0
union all
	select
		P1.entcode ,
		P1.enttype,
		P1.slcode,
		P1.scheme_docno ENTRY_NO,
		S.slname,
		(-1 * P2.damount) AMOUNT
	from
		(
		select
			ENTCODE1 ,
			ENTTYPE1,
			ENTCODE2,
			ENTTYPE2
		from
			FINTAG
		where
			ENTTYPE1 in ('VDP', 'PRM', 'PDM', 'PJM')
	union
		select
			ENTCODE2 ,
			ENTTYPE2,
			ENTCODE1,
			ENTTYPE1
		from
			FINTAG
		where
			ENTTYPE2 in ('VDP', 'PRM', 'PDM', 'PJM')) T
	join FINPOST P1 on
		(T.entcode1::VARCHAR = P1.entcode
			and T.enttype1 = P1.enttype)
	join FINPOST P2 on
		(T.entcode2::VARCHAR = P2.entcode
			and T.enttype2 = P2.enttype)
	left join FINSL S on
		P2.slcode = S.slcode
	where
		T.ENTTYPE2 in ('JDR')
		and p1.slcode is not null
		and p2.damount <> 0)