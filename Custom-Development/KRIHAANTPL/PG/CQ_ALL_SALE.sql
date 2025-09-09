/* Formatted on 2025-03-24 17:41:25 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_ALL_SALE || Ticket Id : 398878 || Developer : Dipankar || ><><><*/
select
	GINVIEW.FNC_UK() UK,
	F.type,
	F.SITE_CODE,
	F.SITE_NAME,
	F.NO_OF_BILL,
	F.BILL_QTY,
	F.BILL_AMT,
	F.FOOTFALL
from
	(
	select
		'EBO' type,
		s.shrtname SITE_CODE,
		S.NAME SITE_NAME,
		coalesce(NO_OF_BILL,0) NO_OF_BILL,
		coalesce(BILL_QTY,0) BILL_QTY,
		coalesce(BILL_AMT,0) BILL_AMT,
		coalesce(FOOTFALL,0) FOOTFALL
	from
		(select
			s.shrtname,
			S.NAME,
			s.code
		from
			admsite s
		where
			s.sitetype like '%MS%' 
			and s.ext = 'N')S
	left join (
		select
			M.ADMSITE_CODE,
			COUNT (distinct M.BILLNO) NO_OF_BILL,
			SUM (D.QTY) BILL_QTY,
			SUM (D.NETAMT) BILL_AMT,
			STLM.FOOTFALL
		from
			PSITE_POSBILL M
		inner join PSITE_POSBILLITEM D on
			M.CODE = D.PSITE_POSBILL_CODE
		inner join ginview.lv_item i on
			d.icode = i.code
		left outer join PSITE_POSSTLM STLM
            on
			M.ADMSITE_CODE = STLM.ADMSITE_CODE
			and M.BILLDATE::DATE = STLM.STLMFOR
		where
			M.BILLDATE::DATE = TO_DATE('@ASON@',
		'YYYY-MM-DD')
			and i.division in ('Accessories', 'Menswear')
		group by
			M.ADMSITE_CODE,
			STLM.FOOTFALL) f on
		s.code = f.admsite_code
union all
	select
		'ONLINE' type,
		S.SLNAME SITE_CODE,
		null SITE_NAME,
		coalesce(NO_OF_BILL,0) NO_OF_BILL,
		coalesce(BILL_QTY,0) BILL_QTY,
		coalesce(BILL_AMT,0) BILL_AMT,
		coalesce(FOOTFALL,0) FOOTFALL
	from
		(
		select
			slcode ,
			slname
		from
			finsl s
		inner join admcls c on
			s.clscode = c.clscode
		where
			clstype = 'H' ) s
	left join (
		select
			M.PCODE,
			COUNT (distinct M.CSCODE) NO_OF_BILL,
			SUM (D.QTY) BILL_QTY,
			SUM (D.NETAMT) BILL_AMT,
			0 FOOTFALL
		from
			SALCSMAIN M
		inner join SALCSDET D on
			M.CSCODE = D.CSCODE
		inner join ginview.lv_item i on
			d.icode = i.code
		where
			M.CHANNELTYPE = 'ETL'
			and M.csdate::DATE = TO_DATE('@ASON@',
		'YYYY-MM-DD')
				and i.division in ('Accessories', 'Menswear')
			group by
				M.PCODE) f on
		s.slcode = f.pcode
union all
	select
		'SIS' type,
		s.shrtname SITE_CODE,
		S.NAME SITE_NAME,
		coalesce(NO_OF_BILL,0) NO_OF_BILL,
		coalesce(BILL_QTY,0) BILL_QTY,
		coalesce(BILL_AMT,0) BILL_AMT,
		coalesce(FOOTFALL,0) FOOTFALL
	from
		(
		select
			s.shrtname,
			S.NAME,
			s.code
		from
			admsite s
		where
			s.sitetype = 'US-CO-OM-TS'
			and s.ext = 'N') s
	left join(
	select
		M.ADMSITE_CODE,
		COUNT (distinct M.SSCODE) NO_OF_BILL,
		SUM (D.QTY) BILL_QTY,
		SUM (D.NETAMT) BILL_AMT,
		0 FOOTFALL
	from
		SALSSMAIN M
	inner join SALSSDET D on
		M.SSCODE = D.SSCODE
	inner join ginview.lv_item i on
		d.icode = i.code
	inner join ADMSITE S on
		M.ADMSITE_CODE = S.CODE
	where
		M.ssdate::DATE = TO_DATE('@ASON@',
		'YYYY-MM-DD')
		and i.division in ('Accessories', 'Menswear')
		and s.sitetype = 'US-CO-OM-TS'
	group by
		M.ADMSITE_CODE)f on
		s.code = f.admsite_code )F