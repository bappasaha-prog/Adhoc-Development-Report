/* Formatted on 13-07-2022 15:38:32 (QP5 v5.294) */
/*|| Custom Development || Object : CQ_PO_ITEM_CUSTOM || Ticket Id :  412330 || Developer : Dipankar ||*/
with size_data
  as
  (
select
	   ordcode,
	department,
	category2,
	category3,
	category4,
	unit,
	image_name,
	item_remarks,
	string_desc1,
	max(case when seq = 1 then i_size else null end) col1,
	max(case when seq = 2 then i_size else null end) col2,
	max(case when seq = 3 then i_size else null end) col3,
	max(case when seq = 4 then i_size else null end) col4,
	max(case when seq = 5 then i_size else null end) col5,
	max(case when seq = 6 then i_size else null end) col6,
	max(case when seq = 7 then i_size else null end) col7,
	max(case when seq = 8 then i_size else null end) col8,
	max(case when seq = 9 then i_size else null end) col9,
	max(case when seq = 10 then i_size else null end) col10
from
	(
	select
		distinct
               ordcode,
		department,
		category2,
		category3,
		TRIM (category4) category4,
		uom unit,
		image_name,
		rem item_remarks,
		string_desc1,
		TRIM (category5) i_size,
		dense_rank ()
                  over (partition by ordcode,
		department,
		category2,
		category3,
		uom,
		image_name,
		rem,
		string_desc1
	order by
		TRIM (category5)) seq
	from
		purorddet d,
		ginview.lv_item i
	where
		d.icode = i.code
		and (ordcode in (
		select
			unnest(regexp_matches('@DocumentId@',
                        		'[^|~|]+',
                        		'g'))::bigint as col1)
			or coalesce (nullif ('@DocumentId@',
			''),
			'0')::text = 0::text))
group by
	ordcode,
	department,
	category2,
	category3,
	category4,
	unit,
	image_name,
	item_remarks,
	string_desc1
  )
select 
	  row_number() over() uk,
	q1.ordcode,
	q1.department,
	q1.category2,
	q1.category3,
	q1.category4,
	q1.unit,
	q1.image_name,
	q1.string_desc1,
	col1 || chr(10)|| '--------' || chr(10)|| round(size1)::text size_data1,
	col2 || chr(10)|| '--------' || chr(10)|| round(size2)::text size_data2,
	col3 || chr(10)|| '--------' || chr(10)|| round(size3)::text size_data3,
	col4 || chr(10)|| '--------' || chr(10)|| round(size4)::text size_data4,
	col5 || chr(10)|| '--------' || chr(10)|| round(size5)::text size_data5,
	col6 || chr(10)|| '--------' || chr(10)|| round(size6)::text size_data6,
	col7 || chr(10)|| '--------' || chr(10)|| round(size7)::text size_data7,
	col8 || chr(10)|| '--------' || chr(10)|| round(size8)::text size_data8,
	col9 || chr(10)|| '--------' || chr(10)|| round(size9)::text size_data9,
	col10 || chr(10)|| '--------' || chr(10)|| round(size10)::text size_data10,
	size1,
	size2,
	size3,
	size4,
	size5,
	size6,
	size7,
	size8,
	size9,
	size10,
	q1.item_remarks
from
	(
	select
		ordcode,
		department,
		category2,
		category3,
		category4,
		unit,
		image_name,
		item_remarks,
		string_desc1,
		SUM (case
			when seq = 1 then qty
			else 0
		end) size1,
		SUM (case
			when seq = 2 then qty
			else 0
		end) size2,
		SUM (case
			when seq = 3 then qty
			else 0
		end) size3,
		SUM (case
			when seq = 4 then qty
			else 0
		end) size4,
		SUM (case
			when seq = 5 then qty
			else 0
		end) size5,
		SUM (case
			when seq = 6 then qty
			else 0
		end) size6,
		SUM (case
			when seq = 7 then qty
			else 0
		end) size7,
		SUM (case
			when seq = 8 then qty
			else 0
		end) size8,
		SUM (case
			when seq = 9 then qty
			else 0
		end) size9,
		SUM (case
			when seq = 10 then qty
			else 0
		end) size10
	from
		(
		select
			ordcode,
			department,
			category2,
			category3,
			TRIM (category4) category4,
			image_name,
			string_desc1,
			TRIM (category4) item_size,
			dense_rank ()
                      over (partition by ordcode,
			department,
			category2,
			category3,
			uom,
			image_name,
			rem,
			string_desc1
		order by
			TRIM (category5))
                      seq,
			SUM (ordqty) qty,
			UOM UNIT,
			rem item_remarks
		from
			purorddet d,
			ginview.lv_item i
		where
			d.icode = i.code
			and (ordcode in (
			select
				unnest(regexp_matches('@DocumentId@',
                        		'[^|~|]+',
                        		'g'))::bigint as col1)
				or coalesce (nullif ('@DocumentId@',
				''),
				'0')::text = 0::text)
		group by
			ordcode,
			article_name,
			department,
			category2,
			category3,
			TRIM (category4),
			TRIM (category5),
			UOM,
			image_name,
			rem,
			string_desc1)
	group by
		ordcode,
		department,
		category2,
		category3,
		category4,
		unit,
		image_name,
		item_remarks,
		string_desc1) q1
inner join size_data s on
	(q1.ordcode = s.ordcode
		and q1.department = s.department
		and q1.category2 = s.category2
		and q1.category3 = s.category3
		and q1.category4 = s.category4
		and q1.unit = s.unit
		and q1.image_name = s.image_name
		and coalesce(q1.item_remarks, '99999999') = coalesce(s.item_remarks, '99999999'))