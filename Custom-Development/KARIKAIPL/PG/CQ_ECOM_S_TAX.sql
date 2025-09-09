/*|| Custom Development || Object : CQ_ECOM_S_TAX || Ticket Id :  430664 || Developer : Dipankar ||*/

select
	row_number() over() as UK,
	F.*
from
	(
	select
		M.CSCODE SALE_CODE,
		'IGST' as TAX_NAME,
		M.IGSTRATE as TAX_RATE,
		SUM (M.IGSTAMT) as TAX_AMOUNT,
		SUM (M.QTY) as INVOICED_QUANTITY,
		SUM (M.TAXABLEAMT) as TAXABLE_AMOUNT
	from
		SALCSDET M
	where
		(M.CSCODE in (
		select
			unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
			or coalesce (nullif ('@DocumentId@',
			''),
			'0')::text = 0::text)
		and M.IGSTRATE > 0
	group by
		M.CSCODE,
		M.IGSTRATE
union all
	select
		M.CSCODE SALE_CODE,
		'CGST' as TAX_NAME,
		M.CGSTRATE as TAX_RATE,
		SUM (M.CGSTAMT) as TAX_AMOUNT,
		SUM (M.QTY) as INVOICED_QUANTITY,
		SUM (M.TAXABLEAMT) as TAXABLE_AMOUNT
	from
		SALCSDET M
	where
		(M.CSCODE in (
		select
			unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
			or coalesce (nullif ('@DocumentId@',
			''),
			'0')::text = 0::text)
		and M.CGSTRATE > 0
	group by
		M.CSCODE,
		M.CGSTRATE
union all
	select
		M.CSCODE SALE_CODE,
		'SGST' as TAX_NAME,
		M.SGSTRATE as TAX_RATE,
		SUM (M.SGSTAMT) as TAX_AMOUNT,
		SUM (M.QTY) as INVOICED_QUANTITY,
		SUM (M.TAXABLEAMT) as TAXABLE_AMOUNT
	from
		SALCSDET M
	where
		(M.CSCODE in (
		select
			unnest(regexp_matches('@DocumentId@',
		'[^|~|]+',
		'g'))::bigint as col1)
			or coalesce (nullif ('@DocumentId@',
			''),
			'0')::text = 0::text)
		and M.SGSTRATE > 0
	group by
		M.CSCODE,
		M.SGSTRATE)F