/* Formatted on 2025-02-10 18:56:59 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_SIZE_STOCK || Ticket Id : 388812 || Developer : Dipankar || ><><><*/
with size as (
select
	ARTICLE_NAME,
	row_number() over (
order by
	ARTICLE_NAME) as repseq,
	ARTICLE_NAME as ITEM_NAME,
	null::numeric as MRP,
	null::text HSN_CODE,
	null::text invitem_udfstring08,
	null::text invitem_udfstring09,
	null::text invitem_udfstring10,
	null::DATE invitem_udfdate01,
	MAX(case when SEQ = 1 then I_SIZE else null end) as SIZE1,
	MAX(case when SEQ = 2 then I_SIZE else null end) as SIZE2,
	MAX(case when SEQ = 3 then I_SIZE else null end) as SIZE3,
	MAX(case when SEQ = 4 then I_SIZE else null end) as SIZE4,
	MAX(case when SEQ = 5 then I_SIZE else null end) as SIZE5,
	MAX(case when SEQ = 6 then I_SIZE else null end) as SIZE6,
	MAX(case when SEQ = 7 then I_SIZE else null end) as SIZE7,
	MAX(case when SEQ = 8 then I_SIZE else null end) as SIZE8,
	MAX(case when SEQ = 9 then I_SIZE else null end) as SIZE9,
	MAX(case when SEQ = 10 then I_SIZE else null end) as SIZE10,
	MAX(case when SEQ = 11 then I_SIZE else null end) as SIZE11,
	MAX(case when SEQ = 12 then I_SIZE else null end) as SIZE12,
	MAX(case when SEQ = 13 then I_SIZE else null end) as SIZE13,
	MAX(case when SEQ = 14 then I_SIZE else null end) as SIZE14,
	MAX(case when SEQ = 15 then I_SIZE else null end) as SIZE15,
	null::numeric as TOTAL_QTY,
	0 QTY1,
	0 QTY2,
	0 QTY3,
	0 QTY4,
	0 QTY5,
	0 QTY6,
	0 QTY7,
	0 QTY8,
	0 QTY9,
	0 QTY10,
	0 QTY11,
	0 QTY12,
	0 QTY13,
	0 QTY14,
	0 QTY15,
	0 TOTAL_QTY1,
	0 MRP_VALUE
from
	(
	select
		distinct
            I.ARTICLE_NAME,
		I.CATEGORY3 as I_SIZE,
		dense_rank() over ( partition by I.ARTICLE_NAME
	order by
		TRIM(CONCAT(I.INVITEM_UDFSTRING07,I.CATEGORY3)) ) as SEQ
	from
		GINVIEW.LV_ITEM I
    )
group by
	ARTICLE_NAME
), 
STOCK as (
select
	ARTICLE_NAME,
	ITEM_NAME,
	MRP,
	HSN_CODE,
	invitem_udfstring08,
	invitem_udfstring09,
	invitem_udfstring10,
	invitem_udfdate01,
	SUM(case when SEQ = 1 then CLOSING_STOCK else 0 end)::text as SIZE1,
	SUM(case when SEQ = 2 then CLOSING_STOCK else 0 end)::text as SIZE2,
	SUM(case when SEQ = 3 then CLOSING_STOCK else 0 end)::text as SIZE3,
	SUM(case when SEQ = 4 then CLOSING_STOCK else 0 end)::text as SIZE4,
	SUM(case when SEQ = 5 then CLOSING_STOCK else 0 end)::text as SIZE5,
	SUM(case when SEQ = 6 then CLOSING_STOCK else 0 end)::text as SIZE6,
	SUM(case when SEQ = 7 then CLOSING_STOCK else 0 end)::text as SIZE7,
	SUM(case when SEQ = 8 then CLOSING_STOCK else 0 end)::text as SIZE8,
	SUM(case when SEQ = 9 then CLOSING_STOCK else 0 end)::text as SIZE9,
	SUM(case when SEQ = 10 then CLOSING_STOCK else 0 end)::text as SIZE10,
	SUM(case when SEQ = 11 then CLOSING_STOCK else 0 end)::text as SIZE11,
	SUM(case when SEQ = 12 then CLOSING_STOCK else 0 end)::text as SIZE12,
	SUM(case when SEQ = 13 then CLOSING_STOCK else 0 end)::text as SIZE13,
	SUM(case when SEQ = 14 then CLOSING_STOCK else 0 end)::text as SIZE14,
	SUM(case when SEQ = 15 then CLOSING_STOCK else 0 end)::text as SIZE15,
	SUM(CLOSING_STOCK) as TOTAL_QTY,
	SUM(case when SEQ = 1 then CLOSING_STOCK else 0 end) as QTY1,
	SUM(case when SEQ = 2 then CLOSING_STOCK else 0 end) as QTY2,
	SUM(case when SEQ = 3 then CLOSING_STOCK else 0 end) as QTY3,
	SUM(case when SEQ = 4 then CLOSING_STOCK else 0 end) as QTY4,
	SUM(case when SEQ = 5 then CLOSING_STOCK else 0 end) as QTY5,
	SUM(case when SEQ = 6 then CLOSING_STOCK else 0 end) as QTY6,
	SUM(case when SEQ = 7 then CLOSING_STOCK else 0 end) as QTY7,
	SUM(case when SEQ = 8 then CLOSING_STOCK else 0 end) as QTY8,
	SUM(case when SEQ = 9 then CLOSING_STOCK else 0 end) as QTY9,
	SUM(case when SEQ = 10 then CLOSING_STOCK else 0 end) as QTY10,
	SUM(case when SEQ = 11 then CLOSING_STOCK else 0 end) as QTY11,
	SUM(case when SEQ = 12 then CLOSING_STOCK else 0 end) as QTY12,
	SUM(case when SEQ = 13 then CLOSING_STOCK else 0 end) as QTY13,
	SUM(case when SEQ = 14 then CLOSING_STOCK else 0 end) as QTY14,
	SUM(case when SEQ = 15 then CLOSING_STOCK else 0 end) as QTY15,
	SUM(CLOSING_STOCK) as TOTAL_QTY1,
	SUM(CLOSING_STOCK)*MRP MRP_VALUE
from
	(
	select
		I.ARTICLE_NAME,
		I.CATEGORY2 as ITEM_NAME,
		I.MRP,
		I.HSN_CODE,
		I.invitem_udfstring08,
		I.invitem_udfstring09,
		I.invitem_udfstring10,
		I.invitem_udfdate01,
		dense_rank() over ( partition by I.ARTICLE_NAME
	order by
		TRIM(CONCAT(I.INVITEM_UDFSTRING07, I.CATEGORY3)) ) as SEQ,
		SUM(K.QTY) as CLOSING_STOCK
	from
		INVSTOCK K
	inner join GINVIEW.LV_ITEM I on
		K.ICODE = I.CODE
	where
		K.ENTDT::DATE <= TO_DATE ('@ASON@',
		'YYYY-MM-DD')
		and ( ( K.ADMSITE_CODE::text = coalesce ('@SiteName@',
		'-1')
			and coalesce ('@SiteName@',
			'-1') <> '-1')
			or (coalesce ('@SiteName@',
			'-1') = '-1'))
		and LOCCODE <> 2
	group by
		I.ARTICLE_NAME,
		I.CATEGORY2,
		I.MRP,
		I.HSN_CODE,
		I.invitem_udfstring08,
		I.invitem_udfstring09,
		I.invitem_udfstring10,
		I.invitem_udfdate01,
		CONCAT(I.INVITEM_UDFSTRING07,
		I.CATEGORY3)
    )
group by
	ARTICLE_NAME,
	ITEM_NAME,
	MRP,
	HSN_CODE,
	invitem_udfstring08,
	invitem_udfstring09,
	invitem_udfstring10,
	invitem_udfdate01
)
select
	GINVIEW.FNC_UK() UK,
	ARTICLE_NAME,
	repseq,
	ITEM_NAME,
	MRP,
	HSN_CODE,
	invitem_udfstring08,
	invitem_udfstring09,
	invitem_udfstring10,
	invitem_udfdate01,
	SIZE1,
	SIZE2,
	SIZE3,
	SIZE4,
	SIZE5,
	SIZE6,
	SIZE7,
	SIZE8,
	SIZE9,
	SIZE10,
	SIZE11,
	SIZE12,
	SIZE13,
	SIZE14,
	SIZE15,
	TOTAL_QTY,
	QTY1,
	QTY2,
	QTY3,
	QTY4,
	QTY5,
	QTY6,
	QTY7,
	QTY8,
	QTY9,
	QTY10,
	QTY11,
	QTY12,
	QTY13,
	QTY14,
	QTY15,
	TOTAL_QTY1,
	MRP_VALUE
from
	(
	select
		ARTICLE_NAME,
		repseq,
		ITEM_NAME,
		MRP,
		HSN_CODE,
		invitem_udfstring08,
		invitem_udfstring09,
		invitem_udfstring10,
		invitem_udfdate01,
		SIZE1,
		SIZE2,
		SIZE3,
		SIZE4,
		SIZE5,
		SIZE6,
		SIZE7,
		SIZE8,
		SIZE9,
		SIZE10,
		SIZE11,
		SIZE12,
		SIZE13,
		SIZE14,
		SIZE15,
		TOTAL_QTY,
		QTY1,
		QTY2,
		QTY3,
		QTY4,
		QTY5,
		QTY6,
		QTY7,
		QTY8,
		QTY9,
		QTY10,
		QTY11,
		QTY12,
		QTY13,
		QTY14,
		QTY15,
		TOTAL_QTY1,
		MRP_VALUE
	from
		size
union all
	select
		S.ARTICLE_NAME,
		coalesce(SD.repseq,
		row_number() over (
	order by
		S.ARTICLE_NAME)) + 0.1 as repseq,
		S.ITEM_NAME,
		S.MRP,
		S.HSN_CODE,
		S.invitem_udfstring08,
		S.invitem_udfstring09,
		S.invitem_udfstring10,
		S.invitem_udfdate01,
		S.SIZE1,
		S.SIZE2,
		S.SIZE3,
		S.SIZE4,
		S.SIZE5,
		S.SIZE6,
		S.SIZE7,
		S.SIZE8,
		S.SIZE9,
		S.SIZE10,
		S.SIZE11,
		S.SIZE12,
		S.SIZE13,
		S.SIZE14,
		S.SIZE15,
		S.TOTAL_QTY,
		S.QTY1,
		S.QTY2,
		S.QTY3,
		S.QTY4,
		S.QTY5,
		S.QTY6,
		S.QTY7,
		S.QTY8,
		S.QTY9,
		S.QTY10,
		S.QTY11,
		S.QTY12,
		S.QTY13,
		S.QTY14,
		S.QTY15,
		S.TOTAL_QTY1,
		S.MRP_VALUE
	from
		STOCK S
	left join size SD on
		S.ARTICLE_NAME = SD.ARTICLE_NAME
union all
	select
            S.ARTICLE_NAME,
            coalesce(SD.repseq,
            row_number() over (
        order by
            S.ARTICLE_NAME)) + 0.2 as repseq,
            S.ARTICLE_NAME ITEM_NAME,
            null::numeric as MRP,
            null::text HSN_CODE,
            null::text invitem_udfstring08,
            null::text invitem_udfstring09,
            null::text invitem_udfstring10,
            null::DATE invitem_udfdate01,
            sum(S.SIZE1::numeric)::text SIZE1,
            sum(S.SIZE2::numeric)::text SIZE2,
            sum(S.SIZE3::numeric)::text SIZE3,
            sum(S.SIZE4::numeric)::text SIZE4,
            sum(S.SIZE5::numeric)::text SIZE5,
            sum(S.SIZE6::numeric)::text SIZE6,
            sum(S.SIZE7::numeric)::text SIZE7,
            sum(S.SIZE8::numeric)::text SIZE8,
            sum(S.SIZE9::numeric)::text SIZE9,
            sum(S.SIZE10::numeric)::text SIZE10,
            sum(S.SIZE11::numeric)::text SIZE11,
            sum(S.SIZE12::numeric)::text SIZE12,
            sum(S.SIZE13::numeric)::text SIZE13,
            sum(S.SIZE14::numeric)::text SIZE14,
            sum(S.SIZE15::numeric)::text SIZE15,
            sum(S.TOTAL_QTY::numeric) TOTAL_QTY,
            sum(S.QTY1::numeric) QTY1,
            sum(S.QTY2::numeric) QTY2,
            sum(S.QTY3::numeric) QTY3,
            sum(S.QTY4::numeric) QTY4,
            sum(S.QTY5::numeric) QTY5,
            sum(S.QTY6::numeric) QTY6,
            sum(S.QTY7::numeric) QTY7,
            sum(S.QTY8::numeric) QTY8,
            sum(S.QTY9::numeric) QTY9,
            sum(S.QTY10::numeric) QTY10,
            sum(S.QTY11::numeric) QTY11,
            sum(S.QTY12::numeric) QTY12,
            sum(S.QTY13::numeric) QTY13,
            sum(S.QTY14::numeric) QTY14,
            sum(S.QTY15::numeric) QTY15,
            sum(S.TOTAL_QTY1::numeric) TOTAL_QTY1,
            sum(S.MRP_VALUE::numeric) MRP_VALUE
        from
            STOCK S
        left join size SD on
            S.ARTICLE_NAME = SD.ARTICLE_NAME
        group by
            S.ARTICLE_NAME,
            SD.repseq
)
order by
	ARTICLE_NAME,
	repseq,
	ITEM_NAME