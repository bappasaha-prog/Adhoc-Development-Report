/*|| Custom Development || Object : TV_LOT_SALES_CUS || Ticket Id :  411692 || Developer : Dipankar ||*/
/*Additdion of 6 columns*/
select
	null datasetid,
	ginview.fnc_uk() uk,
	division,
	section,
	department,
	category6,
	category4,
	size_XS,
	size_S,
	size_M,
	size_L,
	size_XL,
	size_XXL,
	size_3XL,
	size_4XL,
	size_5XL,
	size_6XL,
	size_SS,
	size_MS,
	size_LS,
	size_LR,
	size_KI,
	size_FR,
	size_FS,
	size_230X275,
	size_275X275,
	size_30,
	size_32,
	size_33,
	size_34,
	size_35,
	size_36,
	size_37,
	size_38,
	size_40,
	size_42,
	size_44,
	size_46,
	size_48,
	size_50,
	size_52,
	size_54,
	size_56,
	undiff,
	total_sale_qty,
	FIRST_dateofsale,
	grc_qty,
	Production_qty,
	Consumption_qty,
	misc_Issue,
	misc_receive,
	stock_qty,
	transit_qty,
	return_qty,
	unsettle_qty,
	(current_date - FIRST_dateofsale) No_of_days,
	case
		when (CURRENT_DATE - FIRST_dateofsale) = 0
                   then
                       total_sale_qty
		else
                       ROUND ( total_sale_qty / (CURRENT_DATE - FIRST_dateofsale),
		2)
	end Sale_rate_Per_day,
	case
		when grc_qty = 0 then 0
		else ROUND ((total_sale_qty / grc_qty) * 100,
		2)
	end Sale_through_percent
from
	(
	select
		I.division,
		I.section,
		I.department,
		I.category6,
		I.category4,
		SUM (size_XS) size_XS,
		SUM (size_S) size_S,
		SUM (size_M) size_M,
		SUM (size_L) size_L,
		SUM (size_XL) size_XL,
		SUM (size_XXL) size_XXL,
		SUM (size_3XL) size_3XL,
		SUM (size_4XL) size_4XL,
		SUM (size_5XL) size_5XL,
		SUM (size_6XL) size_6XL,
		SUM (size_SS) size_SS,
		SUM (size_MS) size_MS,
		SUM (size_LS) size_LS,
		SUM (size_LR) size_LR,
		SUM (size_KI) size_KI,
		SUM (size_FR) size_FR,
		SUM (size_FS) size_FS,
		SUM (size_230X275) size_230X275,
		SUM (size_275X275) size_275X275,
		SUM (size_30) size_30,
		SUM (size_32) size_32,
		SUM (size_33) size_33,
		SUM (size_34) size_34,
		SUM (size_35) size_35,
		SUM (size_36) size_36,
		SUM (size_37) size_37,
		SUM (size_38) size_38,
		SUM (size_40) size_40,
		SUM (size_42) size_42,
		SUM (size_44) size_44,
		SUM (size_46) size_46,
		SUM (size_48) size_48,
		SUM (size_50) size_50,
		SUM (size_52) size_52,
		SUM (size_54) size_54,
		SUM (size_56) size_56,
		SUM (undiff) undiff,
		SUM (coalesce (total_sale_qty,
		0)) total_sale_qty,
		MIN (FIRST_dateofsale) FIRST_dateofsale,
		SUM (coalesce (grc_qty,
		0)) grc_qty,
		sum(coalesce(Production_qty, 0)) Production_qty,
		sum(coalesce(Consumption_qty, 0)) Consumption_qty,
		sum(coalesce(misc_Issue, 0)) misc_Issue,
		sum(coalesce(misc_receive, 0)) misc_receive,
		sum(coalesce(stock_qty, 0)) stock_qty,
		sum(coalesce(transit_qty, 0)) transit_qty,
		sum(coalesce(return_qty, 0)) return_qty,
		sum(coalesce(unsettle_qty, 0)) unsettle_qty
	from
		(
		select
			f.icode,
			sum(f.grc_qty) grc_qty,
			sum(f.Production_qty) Production_qty,
			sum(f.Consumption_qty) Consumption_qty,
			sum(f.misc_Issue) misc_Issue,
			sum(f.misc_receive) misc_receive,
			sum(f.stock_qty) stock_qty,
			SUM(F.transit_qty) transit_qty,
			SUM(F.return_qty) return_qty,
			SUM(F.unsettle_qty) unsettle_qty
		from
			(
			select
				b.icode,
				SUM (coalesce (b.ACQTY,
				0)) grc_qty,
				0 Production_qty ,
				0 Consumption_qty,
				0 misc_Issue,
				0 misc_receive,
				0 stock_qty,
				0 TRANSIT_QTY,
				0 return_qty,
				0 unsettle_qty
			from
				invgrcmain a
			join invgrcdet b on
				(a.grccode = b.grccode)
			where
				a.grcdt::DATE between TO_DATE('@DTFR@', 'YYYY-MM-DD') and TO_DATE('@DTTO@', 'YYYY-MM-DD')
			group by
				b.icode
		union all
			select
				b.icode,
				0 grc_qty,
				0 Production_qty ,
				0 Consumption_qty,
				0 misc_Issue,
				0 misc_receive,
				0 stock_qty,
				0 TRANSIT_QTY,
				SUM (coalesce (b.qty,
				0)) return_qty,
				0 unsettle_qty
			from
				invgrtmain a
			join invgrtdet b on
				(a.grtcode = b.grtcode)
			where
				a.grtdt::DATE between TO_DATE('@DTFR@', 'YYYY-MM-DD') and TO_DATE('@DTTO@', 'YYYY-MM-DD')
			group by
				b.icode
		union all
			select
				rc.icode,
				0 grc_qty,
				sum(coalesce(rc.qty, 0)) Production_qty ,
				0 Consumption_qty,
				0 misc_Issue,
				0 misc_receive,
				0 stock_qty,
				0 TRANSIT_QTY,
				0 return_qty,
				0 unsettle_qty
			from
				PRDRC RC
			inner join PRDORD ORD on
				RC.ORDCODE = ORD.ORDCODE
			inner join PRDPR PR on
				ORD.PRCODE = PR.PRCODE
			where
				PR.PRTYPE = 'P'
				and ord.orddt::date between TO_DATE('@DTFR@', 'YYYY-MM-DD') and TO_DATE('@DTTO@', 'YYYY-MM-DD')
			group by
				rc.icode
		union all
			select
				rc.icode,
				0 grc_qty,
				0 Production_qty,
				sum(coalesce(rc.qty, 0)) Consumption_qty,
				0 misc_Issue,
				0 misc_receive,
				0 stock_qty,
				0 TRANSIT_QTY,
				0 return_qty,
				0 unsettle_qty
			from
				PRDIS RC
			inner join PRDORD ORD on
				RC.ORDCODE = ORD.ORDCODE
			inner join PRDPR PR on
				ORD.PRCODE = PR.PRCODE
			where
				PR.PRTYPE = 'P'
				and ord.orddt::date between TO_DATE('@DTFR@', 'YYYY-MM-DD') and TO_DATE('@DTTO@', 'YYYY-MM-DD')
			group by
				rc.icode
		union all
			select
				d.icode,
				0 grc_qty,
				0 Production_qty,
				0 Consumption_qty,
				sum(case when D.QTY >= 0 then D.QTY else 0 end) misc_Issue,
				sum(case when D.QTY < 0 then D.QTY else 0 end) misc_receive,
				0 stock_qty,
				0 TRANSIT_QTY,
				0 return_qty,
				0 unsettle_qty
			from
				INVMISCMAIN M
			inner join INVMISCDET D on
				M.MISCCODE = D.MISCCODE
			where
				m.miscdt::date between TO_DATE('@DTFR@', 'YYYY-MM-DD') and TO_DATE('@DTTO@', 'YYYY-MM-DD')
			group by
				d.icode
		union all
			select
				k.icode,
				0 grc_qty,
				0 Production_qty,
				0 Consumption_qty,
				0 misc_Issue,
				0 misc_receive,
				sum(case when L.loctype <> 'T' then k.qty else 0 end ) stock_qty,
				sum(case when L.loctype = 'T' then k.qty else 0 end ) TRANSIT_QTY,
				0 return_qty,
				0 unsettle_qty
			from
				invstock k
				left join INVLOC L on K.loccode = L.loccode
				where K.entdt::DATE <= TO_DATE('@ASON@','YYYY-MM-DD')
			group by
				k.icode
		union all
		select
				d.icode,
				0 grc_qty,
				0 Production_qty,
				0 Consumption_qty,
				0 misc_Issue,
				0 misc_receive,
				0 stock_qty,
				0 TRANSIT_QTY,
				0 return_qty,
				sum(d.qty) unsettle_qty
			from
				psite_posbill_park m inner join psite_posbillitem_park d on m.code = d.psite_posbill_code 
				where m.billdate::DATE <= TO_DATE('@ASON@','YYYY-MM-DD')
			group by
				d.icode)f
		group by
			f.icode)grc
	left outer join (
		select
			i.code icode,
			SUM(case
				when Category3 = 'XS' then qty
				else 0
			end) size_XS,
			SUM(case
				when Category3 = 'S' then qty
				else 0
			end) size_S,
			SUM(case
				when Category3 = 'M' then qty
				else 0
			end ) size_M,
			SUM(case
				when Category3 = 'L' then qty
				else 0
			end ) size_L,
			SUM(case
				when Category3 = 'XL' then qty
				else 0
			end ) size_XL,
			SUM(case
				when Category3 = 'XXL' then qty
				else 0
			end ) size_XXL,
			SUM(case
				when Category3 = '3XL' then qty
				else 0
			end ) size_3XL,
			SUM(case
				when Category3 = '4XL' then qty
				else 0
			end ) size_4XL,
			SUM(case
				when Category3 = '5XL' then qty
				else 0
			end ) size_5XL,
			SUM(case
				when Category3 = '6XL' then qty
				else 0
			end) size_6XL,
			SUM(case
				when Category3 = 'SS' then qty
				else 0
			end) size_SS,
			SUM(case
				when Category3 = 'MS' then qty
				else 0
			end) size_MS,
			SUM(case
				when Category3 = 'LS' then qty
				else 0
			end) size_LS,
			SUM(case
				when Category3 = 'LR' then qty
				else 0
			end) size_LR,
			SUM(case
				when Category3 = 'KI' then qty
				else 0
			end) size_KI,
			SUM(case
				when Category3 = 'FR' then qty
				else 0
			end) size_FR,
			SUM(case
				when Category3 = 'FS' then qty
				else 0
			end) size_FS,
			SUM(case
				when Category3 = '230Cms X 275Cms'
                                       then
                                           qty
				else
                                           0
			end) size_230X275,
			SUM(case
				when Category3 = '275Cms X 275Cms'
                                       then
                                           qty
				else
                                           0
			end) size_275X275,
			SUM(case
				when Category3 = '30' then qty
				else 0
			end) size_30,
			SUM(case
				when Category3 = '32' then qty
				else 0
			end) size_32,
			SUM(case
				when Category3 = '33' then qty
				else 0
			end) size_33,
			SUM(case
				when Category3 = '34' then qty
				else 0
			end) size_34,
			SUM(case
				when Category3 = '35' then qty
				else 0
			end) size_35,
			SUM(case
				when Category3 = '36' then qty
				else 0
			end) size_36,
			SUM(case
				when Category3 = '37' then qty
				else 0
			end) size_37,
			SUM(case
				when Category3 = '38' then qty
				else 0
			end) size_38,
			SUM(case
				when Category3 = '40' then qty
				else 0
			end) size_40,
			SUM(case
				when Category3 = '42' then qty
				else 0
			end) size_42,
			SUM(case
				when Category3 = '44' then qty
				else 0
			end) size_44,
			SUM(case
				when Category3 = '46' then qty
				else 0
			end) size_46,
			SUM(case
				when Category3 = '48' then qty
				else 0
			end) size_48,
			SUM(case
				when Category3 = '50' then qty
				else 0
			end) size_50,
			SUM(case
				when Category3 = '52' then qty
				else 0
			end) size_52,
			SUM(case
				when Category3 = '54' then qty
				else 0
			end) size_54,
			SUM(case
				when Category3 = '56' then qty
				else 0
			end) size_56,
			SUM(case
				when Category3 not in
               ('XS',
                'S',
                'M',
                'L',
                'XL',
                'XXL',
                '3XL',
                '4XL',
                '5XL',
                '6XL',
                'SS',
                'MS',
                'LS',
                'LR',
                'KI',
                'FR',
                'FS',
                '230Cms X 275Cms',
                '275Cms X 275Cms',
                '30',
                '32',
                '33',
                '34',
                '35',
                '36',
                '37',
                '38',
                '40',
                '42',
                '44',
                '46',
                '48',
                '50',
                '52',
                '54',
                '56')
					or category3 is null
                                       then
                                           qty
					else
                                           0
				end) undiff,
				SUM (coalesce (qty,
				0)) total_sale_qty,
				MIN (t1.csdate::DATE) FIRST_dateofsale
			from
				(
				select
					b.icode,
					csdate::DATE csdate,
					b.qty
				from
					salcsmain a
				join salcsdet b on
					(a.cscode = b.cscode)
				where
					a.csdate::DATE between TO_DATE('@DTFR@', 'YYYY-MM-DD') and TO_DATE('@DTTO@', 'YYYY-MM-DD')
			union all
				select
					b.icode,
					ssdate::DATE,
					b.qty
				from
					salssmain a
				join salssdet b on
					(a.sscode = b.sscode)
				where
					a.ssdate::DATE between TO_DATE('@DTFR@', 'YYYY-MM-DD')
                                                                    and TO_DATE('@DTTO@', 'YYYY-MM-DD')) T1
			left join MAIN.INVITEM_DETAIL_AGG i on
				(i.code = t1.icode)
			group by
				i.code) sal on 
		(grc.icode = sal.icode)
		inner join GINVIEW.LV_ITEM I on GRC.ICODE = I.CODE
	group by
		I.division,
		I.section,
		I.department,
		I.category6,
		I.Category4)