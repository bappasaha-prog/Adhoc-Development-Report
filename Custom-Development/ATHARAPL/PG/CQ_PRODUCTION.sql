/*|| Custom Development || Object : CQ_PRODUCTION || Ticket Id :  416541 || Developer : Dipankar ||*/

SELECT ROW_NUMBER() OVER() AS UK,X.*,B.AMOUNT RAW_MATERIAL_COST FROM (
select 
    SITE_NAME,
	LOTCODE,
	LOTNO,
	CUTTING_DATE,
	size,
	D_NO,
	STRING_DESC1,
	STRING_DESC2,
	STRING_DESC3,
	STRING_DESC4,
	STRING_DESC5,
	STRING_DESC6,
	UDFNUM01,
	UDFNUM02,
	UDFNUM03,
	UDFNUM04,
	UDFNUM05,
	udfstring04,
	SUB_ASSEMBLY,
	SUB_ASSEMBLY_CODE,
	ROUTEGRP,
	ROUTENAME,
	QTY,
	CODE,
	PR1,
	PR2,
	PR3,
	PR4,
	PR5,
	PR6,
	PR7,
	PR8,
	PRJWRATE1,
	PRJWRATE2,
	PRJWRATE3,
	PRJWRATE4,
	PRJWRATE5,
	PRJWRATE6,
	PRJWRATE7,
	PRJWRATE8,
	PRJOBBER1,
	PRJOBBER2,
	PRJOBBER3,
	PRJOBBER4,
	PRJOBBER5,
	PRJOBBER6,
	PRJOBBER7,
	PRJOBBER8,
	PRJDATE1,
	PRJDATE2,
	PRJDATE3,
	PRJDATE4,
	PRJDATE5,
	PRJDATE6,
	PRJDATE7,
	PRJDATE8,
	PRJRDATE1,
	PRJRDATE2,
	PRJRDATE3,
	PRJRDATE4,
	PRJRDATE5,
	PRJRDATE6,
	PRJRDATE7,
	PRJRDATE8,
	PRSRVDATE1,
	PRSRVDATE2,
	PRSRVDATE3,
	PRSRVDATE4,
	PRSRVDATE5,
	PRSRVDATE6,
	PRSRVDATE7,
	PRSRVDATE8,
	PRSRVNO1,
	PRSRVNO2,
	PRSRVNO3,
	PRSRVNO4,
	PRSRVNO5,
	PRSRVNO6,
	PRSRVNO7,
	PRSRVNO8,
	PRAVL_TO_FRD1,
	PRAVL_TO_FRD2,
	PRAVL_TO_FRD3,
	PRAVL_TO_FRD4,
	PRAVL_TO_FRD5,
	PRAVL_TO_FRD6,
	PRAVL_TO_FRD7,
	PRAVL_TO_FRD8
	from (
select
	SITE_NAME,
	LOTCODE,
	LOTNO,
	CUTTING_DATE,
	size,
	D_NO,
	STRING_DESC1,
	STRING_DESC2,
	STRING_DESC3,
	STRING_DESC4,
	STRING_DESC5,
	STRING_DESC6,
	UDFNUM01,
	UDFNUM02,
	UDFNUM03,
	UDFNUM04,
	UDFNUM05,
	udfstring04,
	SUB_ASSEMBLY,
	SUB_ASSEMBLY_CODE,
	ROUTEGRP,
	ROUTENAME,
	QTY,
	CODE,
	MAX(case when SEQ = 1 then PRNAME else null end) PR1,
	MAX(case when SEQ = 2 then PRNAME else null end) PR2,
	MAX(case when SEQ = 3 then PRNAME else null end) PR3,
	MAX(case when SEQ = 4 then PRNAME else null end) PR4,
	MAX(case when SEQ = 5 then PRNAME else null end) PR5,
	MAX(case when SEQ = 6 then PRNAME else null end) PR6,
	MAX(case when SEQ = 7 then PRNAME else null end) PR7,
	MAX(case when SEQ = 8 then PRNAME else null end) PR8,
	MAX(case when SEQ = 1 then JWRATE else 0::numeric end) PRJWRATE1,
	MAX(case when SEQ = 2 then JWRATE else 0::numeric end) PRJWRATE2,
	MAX(case when SEQ = 3 then JWRATE else 0::numeric end) PRJWRATE3,
	MAX(case when SEQ = 4 then JWRATE else 0::numeric end) PRJWRATE4,
	MAX(case when SEQ = 5 then JWRATE else 0::numeric end) PRJWRATE5,
	MAX(case when SEQ = 6 then JWRATE else 0::numeric end) PRJWRATE6,
	MAX(case when SEQ = 7 then JWRATE else 0::numeric end) PRJWRATE7,
	MAX(case when SEQ = 8 then JWRATE else 0::numeric end) PRJWRATE8,
	MAX(case when SEQ = 1 then JOBBER else null end) PRJOBBER1,
	MAX(case when SEQ = 2 then JOBBER else null end) PRJOBBER2,
	MAX(case when SEQ = 3 then JOBBER else null end) PRJOBBER3,
	MAX(case when SEQ = 4 then JOBBER else null end) PRJOBBER4,
	MAX(case when SEQ = 5 then JOBBER else null end) PRJOBBER5,
	MAX(case when SEQ = 6 then JOBBER else null end) PRJOBBER6,
	MAX(case when SEQ = 7 then JOBBER else null end) PRJOBBER7,
	MAX(case when SEQ = 8 then JOBBER else null end) PRJOBBER8,
	MAX(case when SEQ = 1 then JDATE else null::DATE end) PRJDATE1,
	MAX(case when SEQ = 2 then JDATE else null::DATE end) PRJDATE2,
	MAX(case when SEQ = 3 then JDATE else null::DATE end) PRJDATE3,
	MAX(case when SEQ = 4 then JDATE else null::DATE end) PRJDATE4,
	MAX(case when SEQ = 5 then JDATE else null::DATE end) PRJDATE5,
	MAX(case when SEQ = 6 then JDATE else null::DATE end) PRJDATE6,
	MAX(case when SEQ = 7 then JDATE else null::DATE end) PRJDATE7,
	MAX(case when SEQ = 8 then JDATE else null::DATE end) PRJDATE8,
	MAX(case when SEQ = 1 then JRDATE else null::DATE end) PRJRDATE1,
	MAX(case when SEQ = 2 then JRDATE else null::DATE end) PRJRDATE2,
	MAX(case when SEQ = 3 then JRDATE else null::DATE end) PRJRDATE3,
	MAX(case when SEQ = 4 then JRDATE else null::DATE end) PRJRDATE4,
	MAX(case when SEQ = 5 then JRDATE else null::DATE end) PRJRDATE5,
	MAX(case when SEQ = 6 then JRDATE else null::DATE end) PRJRDATE6,
	MAX(case when SEQ = 7 then JRDATE else null::DATE end) PRJRDATE7,
	MAX(case when SEQ = 8 then JRDATE else null::DATE end) PRJRDATE8,
	MAX(case when SEQ = 1 then SRVDATE else null::DATE end) PRSRVDATE1,
	MAX(case when SEQ = 2 then SRVDATE else null::DATE end) PRSRVDATE2,
	MAX(case when SEQ = 3 then SRVDATE else null::DATE end) PRSRVDATE3,
	MAX(case when SEQ = 4 then SRVDATE else null::DATE end) PRSRVDATE4,
	MAX(case when SEQ = 5 then SRVDATE else null::DATE end) PRSRVDATE5,
	MAX(case when SEQ = 6 then SRVDATE else null::DATE end) PRSRVDATE6,
	MAX(case when SEQ = 7 then SRVDATE else null::DATE end) PRSRVDATE7,
	MAX(case when SEQ = 8 then SRVDATE else null::DATE end) PRSRVDATE8,
	MAX(case when SEQ = 1 then SRVNO else null end) PRSRVNO1,
	MAX(case when SEQ = 2 then SRVNO else null end) PRSRVNO2,
	MAX(case when SEQ = 3 then SRVNO else null end) PRSRVNO3,
	MAX(case when SEQ = 4 then SRVNO else null end) PRSRVNO4,
	MAX(case when SEQ = 5 then SRVNO else null end) PRSRVNO5,
	MAX(case when SEQ = 6 then SRVNO else null end) PRSRVNO6,
	MAX(case when SEQ = 7 then SRVNO else null end) PRSRVNO7,
	MAX(case when SEQ = 8 then SRVNO else null end) PRSRVNO8,
	MAX(case when SEQ = 1 then AVL_TO_FRD else null end) PRAVL_TO_FRD1,
	MAX(case when SEQ = 2 then AVL_TO_FRD else null end) PRAVL_TO_FRD2,
	MAX(case when SEQ = 3 then AVL_TO_FRD else null end) PRAVL_TO_FRD3,
	MAX(case when SEQ = 4 then AVL_TO_FRD else null end) PRAVL_TO_FRD4,
	MAX(case when SEQ = 5 then AVL_TO_FRD else null end) PRAVL_TO_FRD5,
	MAX(case when SEQ = 6 then AVL_TO_FRD else null end) PRAVL_TO_FRD6,
	MAX(case when SEQ = 7 then AVL_TO_FRD else null end) PRAVL_TO_FRD7,
	MAX(case when SEQ = 8 then AVL_TO_FRD else null end) PRAVL_TO_FRD8
from
	(
	select
		S.NAME SITE_NAME,
		M.CODE LOTCODE,
		M.LOTNO,
		JOB.CUTTING_DATE::DATE CUTTING_DATE,
		I.CATEGORY3 size,
		I.CATEGORY2 D_NO,
		I.STRING_DESC1,
		I.STRING_DESC2,
		I.STRING_DESC3,
		I.STRING_DESC4,
		I.STRING_DESC5,
		I.STRING_DESC6,
		CS.UDFNUM01,
		CS.UDFNUM02,
		CS.UDFNUM03,
		CS.UDFNUM04,
		CS.UDFNUM05,
		CS.udfstring04,
		SA.SAINAME SUB_ASSEMBLY,
		SA.CODE SUB_ASSEMBLY_CODE,
		GRP.GRPNAME ROUTEGRP,
		RM.NAME ROUTENAME,
		JOB.CUTTING_QTY QTY,
		I.CATEGORY1 CODE,
		P.PRNAME,
		JD.OPERATION_SEQ,
		dense_rank ()
                   over ( partition by M.LOTNO,
		I.CATEGORY3,
		I.CATEGORY2,
		SA.SAINAME,
		SA.CODE,
		I.CATEGORY1
	order by
		JD.OPERATION_SEQ,JD.CODE) SEQ,
		MAX(J.SLNAME) JOBBER,
		MAX(JRD.JOB_RATE) JWRATE,
		MAX(JM.JOB_DATE::DATE) JDATE,
		MAX(JRM.JRC_DATE::DATE) JRDATE,
		MAX(JRM.udfstring02) AVL_TO_FRD,
		MAX(SRV.SCHEME_DOCNO) SRVNO,
		MAX(SRV.SRVDT::DATE) SRVDATE
	from PRDJOBDET Jd
	left join PRDJOBMAIN JM on
		JD.JOBCODE = JM.CODE
	left join PRDLOTDET D on
		JD.LOTCODE = D.LOTCODE
	left join PRDLOTMAIN M ON
	D.LOTCODE = M.CODE
	left join (
		select
			P.LOTCODE,
			P.ASSEMBLY_ICODE,
			P.ASS_SAITEM_CODE
		from
			PRDLOTOPERATION P
		inner join PRDPR PR on
			P.PRCODE = PR.PRCODE
		where
			PR.PRNAME = 'CUTTING') PO on
		JD.LOTCODE = PO.LOTCODE
	left join (
		select
			D.LOTCODE,
			D.ASS_SAITEM_CODE,
			MIN (M.JOB_DATE) CUTTING_DATE,
			SUM(D.QTY) CUTTING_QTY
		from
			PRDJOBMAIN M
		inner join PRDJOBDET D on
			M.CODE = D.JOBCODE
		inner join PRDPR PR on
			M.PRCODE = PR.PRCODE
		where
			PR.PRNAME = 'CUTTING'
		group by
			D.LOTCODE,
			D.ASS_SAITEM_CODE) JOB
                  on
		JD.LOTCODE = JOB.LOTCODE
		and JD.ASS_SAITEM_CODE = JOB.ASS_SAITEM_CODE
	left join GINVIEW.LV_ITEM I on
		JD.ASSEMBLY_ICODE = I.CODE
	left join ADMSITE S on
		JM.ADMSITE_CODE = S.CODE
	left join PRDROUTEGRPDET R on
		D.ROUTECODE = R.ROUTECODE
		and D.ASSEMBLY_ICODE = R.ICODE
		and M.ROUTEGRP_CODE = R.ROUTEGRP_CODE
	left join PRDROUTEGRP GRP on
		R.ROUTEGRP_CODE = GRP.CODE
	left join PRDROUTEMAIN RM on
		R.ROUTECODE = RM.CODE
	left outer join PRD_SAITEM SA on
		JD.ASS_SAITEM_CODE = SA.CODE
	left join PRDPR P on
		JM.PRCODE = P.PRCODE
	left join FINSL J on
		JM.PCODE = J.SLCODE
	left join PRDJRCDET JRD on
		JD.CODE = JRD.JOBDET_CODE
		and JD.JOBCODE = JRD.JOBCODE
		and JD.LOTCODE = JRD.LOTCODE
	left join PRDJRCMAIN JRM on
		JRD.JRCCODE = JRM.CODE
	left join PURSRVMAIN SRV on
		JRM.SRVCODE = SRV.SRVCODE
	left join (
		select
			D.LOTCODE,
			PC.UDFNUM01,
			PC.UDFNUM02,
			PC.UDFNUM03,
			PC.UDFNUM04,
			PC.UDFNUM05,
			PC.udfstring04
		from
			PRDLOTDET D
		inner join INVITEM I on
			D.ASSEMBLY_ICODE = I.ICODE
		inner join PRDCOSTSHEETHEAD PC on
			I.COSTSHEET_CODE = PC.CODE) CS on
		JD.LOTCODE = CS.LOTCODE
	where
       JM.JOB_DATE::DATE between TO_DATE('@DTFR@', 'YYYY-MM-DD') and TO_DATE('@DTTO@', 'YYYY-MM-DD')
	group by
		S.NAME,
		M.CODE,
		M.LOTNO,
		JOB.CUTTING_DATE,
		I.CATEGORY3,
		I.CATEGORY2,
		I.STRING_DESC1,
		I.STRING_DESC2,
		I.STRING_DESC3,
		I.STRING_DESC4,
		I.STRING_DESC5,
		I.STRING_DESC6,
		CS.UDFNUM01,
		CS.UDFNUM02,
		CS.UDFNUM03,
		CS.UDFNUM04,
		CS.UDFNUM05,
		CS.udfstring04,
		SA.SAINAME,
		SA.CODE,
		GRP.GRPNAME,
		RM.NAME,
		JOB.CUTTING_QTY,
		I.CATEGORY1,
		P.PRNAME,
		JD.OPERATION_SEQ,
        JD.CODE)
group by
	SITE_NAME,
	LOTCODE,
	LOTNO,
	CUTTING_DATE,
	size,
	D_NO,
	STRING_DESC1,
	STRING_DESC2,
	STRING_DESC3,
	STRING_DESC4,
	STRING_DESC5,
	STRING_DESC6,
	UDFNUM01,
	UDFNUM02,
	UDFNUM03,
	UDFNUM04,
	UDFNUM05,
	udfstring04,
	SUB_ASSEMBLY,
	SUB_ASSEMBLY_CODE,
	ROUTEGRP,
	ROUTENAME,
	QTY,
	CODE))X
	left outer join (select  B.LOTCODE,
			B.ASS_SAITEM_CODE,
			ROUND(SUM((B.CONSUME_QTY /  B.JOBRECEIPT_QTY) * B.COSTRATE),3)   AMOUNT
		from
			PRDJRCBOM B
		inner join PRDJOBMAIN JM on
			B.JOBCODE = JM.CODE
		inner join GINVIEW.LV_COMPONENT_ITEM I
                            on
			B.COMPONENT_ICODE = I.CODE
			where i.material_type not in ('Finished Goods')
		group by
			B.LOTCODE,
			B.ASS_SAITEM_CODE) B on
		X.LOTCODE = B.LOTCODE
		and X.SUB_ASSEMBLY_CODE = B.ASS_SAITEM_CODE