/* Formatted on @ASON@ 13:53:01 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_STK_PI || Ticket Id : 391766 || Developer : Dipankar || ><><><*/
select
	ginview.fnc_uk() uk,
	A.icode ,
	A.admsite_code ,
	A.realtime_stock,
	coalesce(B.L3_PURAMT,0) L3_PURAMT,
	coalesce(B.L6_PURAMT,0) L6_PURAMT,
	coalesce(B.L12_PURAMT,0) L12_PURAMT
from
	(
	select
		K.ICODE,
		K.ADMSITE_CODE,
		SUM (coalesce (K.QTY,0)) REALTIME_STOCK
	from
		INVSTOCK K
		where k.entdt::date <= TO_DATE ('@ASON@', 'YYYY-MM-DD')
	group by
		K.ICODE,
		K.ADMSITE_CODE) A
left join (
	select
		D.ICODE,
		M.ADMSITE_CODE,
		coalesce(sum(case when M.INVDT::DATE between TO_DATE ('@ASON@', 'YYYY-MM-DD') - interval '3 months'
       and TO_DATE ('@ASON@', 'YYYY-MM-DD') then coalesce(d.NETAMT, 0) else 0 end ),0) L3_PURAMT,
		coalesce(sum(case when M.INVDT::DATE between TO_DATE ('@ASON@', 'YYYY-MM-DD') - interval '6 months'
       and TO_DATE ('@ASON@', 'YYYY-MM-DD') then coalesce(d.NETAMT, 0) else 0 end ),0) L6_PURAMT,
		coalesce(sum(case when M.INVDT::DATE between TO_DATE ('@ASON@', 'YYYY-MM-DD') - interval '12 months'
       and TO_DATE ('@ASON@', 'YYYY-MM-DD') then coalesce(d.NETAMT, 0) else 0 end ),0) L12_PURAMT
	from
			PURINVMAIN M
	inner join PURINVDET D on
			M.INVCODE = D.INVCODE
	where
			M.INVDT::date between TO_DATE ('@ASON@','YYYY-MM-DD') - interval '12 months'
            and TO_DATE ('@ASON@','YYYY-MM-DD')
	group by
			D.ICODE,
			M.ADMSITE_CODE) B on
	A.ICODE = B.ICODE and A.ADMSITE_CODE = B.ADMSITE_CODE
	order by A.icode