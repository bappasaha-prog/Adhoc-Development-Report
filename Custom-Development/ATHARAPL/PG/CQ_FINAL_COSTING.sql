/*><><>< || Custom Development || Object : CQ_FINAL_COSTING || Ticket Id : 394948 || Developer : Dipankar || ><><><*/
select
	GINVIEW.FNC_UK() UK,
	H.ADMOU_CODE L1_ADMOU_CODE,
	H.ADMSITE_CODE L1_ADMSITE_CODE,
	H.CUTTING_DATE L1_CUTTING_DATE,
	H.cutting_qty  L1_CUTTING_QTY,
	H.DESIGN_NO L1_DESIGN_NO,
	H.ITEM L1_ITEM,
	H.ITEM_SIZE L1_ITEM_SIZE,
	H.LOTCODE L1_LOTCODE,
	H.PLAN_NO L1_PLAN_NO,
	H.PLAN_QTY L1_PLAN_QTY,
	H.RECEIVE_DATE L1_RECEIVE_DATE,
	H.CATEGORY1 L1_CATEGORY1,
	D.LVL,
	D.SEQ,
	D.ITEM_NAME L2_ITEM_NAME,
	D.WIDTH L2_WIDTH,
	D.QTY L2_QTY,
	D.COST_RATE L2_COST_RATE,
	D.SUB_ASSEMBLY_ITEM L2_SUB_ASSEMBLY_ITEM,
	D.AMOUNT L2_AMOUNT,
	D.PRNAME L3_PRNAME,
	D.SUB_ASSEM_ITEM L3_SUB_ASSEM_ITEM,
	D.JOBBER L3_JOBBER,
	D.JRC_RATE L3_JRC_RATE,
	d.operation_seq l3_operation_seq,
	d.jrc_date  l3_jrc_date,
	D.NAME L4_NAME,
	D.UDF_AMOUNT L4_UDF_AMOUNT
from
	(/* HEADER PART*/
	select
		M.ADMOU_CODE,
		M.ADMSITE_CODE,
		M.CODE LOTCODE,
		M.LOTNO PLAN_NO,
		I.CATEGORY3 ITEM_SIZE,
		I.CATEGORY2 DESIGN_NO,
		D.QTY PLAN_QTY,
		JRC.RECEIVE_DATE,
		JOB.CUTTING_DATE,
		JOB.CUTTING_QTY,
		I.DEPARTMENT ITEM,
		I.CATEGORY1
	from
		PRDLOTMAIN M
	inner join PRDLOTDET D on
		M.CODE = D.LOTCODE
	inner join
               (
		select
			D.LOTCODE,
			MAX (M.JRC_DATE) RECEIVE_DATE
		from
			PRDJRCMAIN M
		inner join PRDJRCDET D on
			M.CODE = D.JRCCODE
		group by
			D.LOTCODE) JRC
                  on
		D.LOTCODE = JRC.LOTCODE
	inner join
               (
		select
			D.LOTCODE,
			MIN (M.JOB_DATE) CUTTING_DATE,
			MAX(D.qty) CUTTING_QTY
		from
			PRDJOBMAIN M
		inner join PRDJOBDET D on
			M.CODE = D.JOBCODE
		inner join PRDPR PR on
			M.PRCODE = PR.PRCODE
		where
			PR.PRNAME = 'CUTTING'
		group by
			D.LOTCODE) JOB
                  on
		D.LOTCODE = JOB.LOTCODE
	inner join GINVIEW.LV_ASSEMBLY_ITEM I
                  on
		D.ASSEMBLY_ICODE = I.CODE) H
inner join
       (
	select
		D.LOTCODE,
		'L2#DETAIL' LVL,
		1 SEQ,
		D.ITEM_NAME,
		D.WIDTH,
		D.QTY,
		D.COST_RATE,
		D.SUB_ASSEMBLY_ITEM,
		D.AMOUNT,
		null PRNAME,
		null SUB_ASSEM_ITEM,
		null JOBBER,
		null JRC_RATE,
		null operation_seq,
		null::date jrc_date,
		null NAME,
		0 UDF_AMOUNT
	from
		(
		select
			B.LOTCODE,
			CONCAT_WS('-',
			I.CATEGORY2,
			I.CATEGORY3,
			I.CATEGORY4) ITEM_NAME,
			I.CATEGORY5 WIDTH,
			ROUND (SUM (B.CONSUME_QTY) / SUM (B.JOBRECEIPT_QTY),
			3)
                            QTY,
			B.COSTRATE COST_RATE,
			SA.SAINAME
                            SUB_ASSEMBLY_ITEM,
			(ROUND (
                               SUM (B.CONSUME_QTY) / SUM (B.JOBRECEIPT_QTY),
			3))
                         * B.COSTRATE
                            AMOUNT
		from
			PRDJRCBOM B
		inner join PRDJOBMAIN JM on
			B.JOBCODE = JM.CODE
		left outer join PRD_SAITEM SA
                            on
			B.ASS_SAITEM_CODE = SA.CODE
		inner join GINVIEW.LV_COMPONENT_ITEM I
                            on
			B.COMPONENT_ICODE = I.CODE
			where i.material_type not in ('Finished Goods')
		group by
			B.LOTCODE,
			CONCAT_WS('-',
			I.CATEGORY2,
			I.CATEGORY3,
			I.CATEGORY4),
			I.CATEGORY5,
			B.COSTRATE,
			SA.SAINAME
	union all
		select
			D.LOTCODE,
			'FREIGHT ON FABRIC' ITEM_NAME,
			null WIDTH,
			null::numeric QTY,
			null::numeric COST_RATE,
			'A' SUB_ASSEMBLY_ITEM,
			PC.UDFNUM05 AMOUNT
		from
			PRDLOTDET D
		inner join INVITEM I on
			D.ASSEMBLY_ICODE = I.ICODE
		inner join PRDCOSTSHEETHEAD PC
                          on
			I.COSTSHEET_CODE = PC.CODE) D
union all
	select
		D.LOTCODE,
		'L3#DETAIL' LVL,
		2 SEQ,
		null ITEM_NAME,
		null WIDTH,
		null QTY,
		null COST_RATE,
		null SUB_ASSEMBLY_ITEM,
		null AMOUNT,
		P.PRNAME,
		SA.SAINAME SUB_ASSEM_ITEM,
		J.SLNAME JOBBER,
		D.JOB_RATE JRC_RATE,
		0 operation_seq,
		m.jrc_date,
		null NAME,
		0 UDF_AMOUNT
	from
		PRDJRCDET D
	inner join PRDJRCMAIN M on
		D.JRCCODE = M.CODE 
	left join PRDPR P on
		M.PRCODE = P.PRCODE 
	left outer join PRD_SAITEM SA on
		D.ASS_SAITEM_CODE = SA.CODE
	left join FINSL J on
		M.PCODE = J.SLCODE
		where D.JOB_RATE<>0
	union all
	select
		D.LOTCODE,
		'L3#DETAIL' LVL,
		2 SEQ,
		null ITEM_NAME,
		null WIDTH,
		null QTY,
		null COST_RATE,
		null SUB_ASSEMBLY_ITEM,
		null AMOUNT,
		'IRONING' PRNAME,
		NULL SUB_ASSEM_ITEM,
		NULL JOBBER,
		PC.udfstring04::numeric  JRC_RATE,
		999 operation_seq,
		null::date jrc_date,
		null NAME,
		0 UDF_AMOUNT
	from
			PRDLOTDET D
		inner join INVITEM I on
			D.ASSEMBLY_ICODE = I.ICODE
		inner join PRDCOSTSHEETHEAD PC
                          on
	I.COSTSHEET_CODE = PC.CODE
union all
	select
		U.LOTCODE,
		'L4#DETAIL' LVL,
		3 SEQ,
		null ITEM_NAME,
		null WIDTH,
		null QTY,
		null COST_RATE,
		null SUB_ASSEMBLY_ITEM,
		null AMOUNT,
		null PRNAME,
		null SUB_ASSEMBLY_ITEM,
		null JOBBER,
		null JRC_RATE,
		null operation_seq,
		null::date jrc_date,
		U.NAME,
		U.UDF_AMOUNT
	from
		(
		select
			D.LOTCODE,
			'C.PACKING MATERIALS' NAME,
			PC.UDFNUM02 UDF_AMOUNT
		from
			PRDLOTDET D
		inner join INVITEM I on
			D.ASSEMBLY_ICODE = I.ICODE
		inner join PRDCOSTSHEETHEAD PC
                          on
			I.COSTSHEET_CODE = PC.CODE
	union all
		select
			D.LOTCODE,
			'D.ACCESSORIES' NAME,
			PC.UDFNUM01 UDF_AMOUNT
		from
			PRDLOTDET D
		inner join INVITEM I on
			D.ASSEMBLY_ICODE = I.ICODE
		inner join PRDCOSTSHEETHEAD PC
                          on
			I.COSTSHEET_CODE = PC.CODE
	union all
		select
			D.LOTCODE,
			'E.OVERHEAD' NAME,
			PC.UDFNUM03 UDF_AMOUNT
		from
			PRDLOTDET D
		inner join INVITEM I on
			D.ASSEMBLY_ICODE = I.ICODE
		inner join PRDCOSTSHEETHEAD PC
                          on
			I.COSTSHEET_CODE = PC.CODE
	union all
		select
			D.LOTCODE,
			'F.OTHERS COST' NAME,
			PC.UDFNUM04 UDF_AMOUNT
		from
			PRDLOTDET D
		inner join INVITEM I on
			D.ASSEMBLY_ICODE = I.ICODE
		inner join PRDCOSTSHEETHEAD PC
                          on
			I.COSTSHEET_CODE = PC.CODE) U) D
          on
	H.LOTCODE = D.LOTCODE