/*CQ_SUBLEDGERDETAIL_NEW*/
/* Formatted on 16/Nov/22 5:27:41 PM (QP5 v5.294) */
select
	*
from
	(
	select
		datasetid requestid,
		keyval,
		entcode,
		glcode,
		entname,
		maingl_code,
		source_type,
		entdt entrydate,
		entno entryno,
		docno refno,
		docdt refdate,
		brsdt brsdate,
		created_sitecode owner_sitecode,
		slcode,
		nartext,
		document_details,
		particulars,
		/*Start: Particulars Work Addition/Bug Id :*/
		particulars_2,
		particulars_3,
		particulars_4,
		particulars_5,
		/*End: Particulars Work Addition/Bug Id :*/
		--opening,
               case
			when PARCODE is null
                  then
                     opening
			else
                     coalesce (
                        lag (CLOSING)
                           over (partition by GLCODE
		order by
			KEYVAL),
			0)
		end
                  OPENING,
		debit,
		credit,
		closing,
		parcode,
		year_month,
		release_status,
		enttype,
		chqno,
		chqdt,
		drawnon,
		refdetail,
		/*Start: Particulars Work Addition/Bug Id :*/
		refdetail_2,
		refdetail_3,
		refdetail_4,
		refdetail_5,
		/*End: Particulars Work Addition/Bug Id :*/
		agcode,
		agname
	from
		(
		select
			null datasetid,
			keyval,
			entcode,
			glcode,
			entname,
			maingl_code,
			source_type,
			entdt,
			entno,
			docno,
			docdt,
			brsdt,
			created_sitecode,
			slcode,
			nartext,
			document_details,
			particulars,
			/*Start: Particulars Work Addition/Bug Id :*/
			particulars_2,
			particulars_3,
			particulars_4,
			particulars_5,
			/*End: Particulars Work Addition/Bug Id :*/
			opening,
			debit,
			credit,
			SUM (balance)
                          over (partition by glcode,
			slcode
		order by
			keyval)
                          closing,
			lag (keyval)
                          over (partition by glcode,
			slcode
		order by
			keyval)
                          parcode,
			year_month,
			release_status,
			enttype,
			chqno,
			chqdt,
			drawnon,
			refdetail,
			 /*Start: Particulars Work Addition/Bug Id :*/
			refdetail_2,
			refdetail_3,
			refdetail_4,
			refdetail_5,
			/*End: Particulars Work Addition/Bug Id :*/
			agcode,
			agname
		from
			(
			select
				keyval,
				entcode,
				glcode,
				entname,
				maingl_code,
				source_type,
				entdt,
				entno,
				docno,
				docdt,
				brsdt,
				created_sitecode,
				slcode,
				nartext,
				document_details,
				particulars,
				/*Start: Particulars Work Addition/Bug Id :*/
				particulars_2,
				particulars_3,
				particulars_4,
				particulars_5,
				/*End: Particulars Work Addition/Bug Id :*/
				opening,
				debit,
				credit,
				(opening + debit - credit) balance,
				year_month,
				release_status,
				enttype,
				chqno,
				chqdt,
				drawnon,
				refdetail,
				/*Start: Particulars Work Addition/Bug Id :*/
				refdetail_2,
				refdetail_3,
				refdetail_4,
				refdetail_5,
				/*End: Particulars Work Addition/Bug Id :*/
				agcode,
				agname
			from
				(
				select
					a.glcode ::text || a.slcode ::text
                                       || entdt::date
                                       || a.postcode::text
                                       || coalesce (ref_admsite_code::text,
					a.admsite_code_owner::text)
                                          keyval,
					entcode,
					a.glcode,
					b.entname,
					vch.GLCODE maingl_code,
					fgl.SRCTYPE source_type,
					entdt,
					a.scheme_docno entno,
					C.docno docno,
					/*Bug 106626*/
					/*Bug 107403*/
					C.docdt docdt,
					/*Bug 106626*/
					/*Bug 107403*/
					brsdt,
					a.admsite_code_owner created_sitecode,
					a.slcode,
					a.nartext,
					'Doc No.  '
                                       || coalesce (a.docno,
					a.scheme_docno)
                                       || case
						when
                                             a.docno is
                                             null then null
						else
                                             case
							when 
                                                a.docdt is
                                                null then null
							else
                                                   ' ('
                                                || a.docdt::date
                                                || ')'
						end
					end 
                                       || CHR (10)
                                       || case
						when a.TDSRATE is
                                             null then null
						else
                                                'TDS Rate '
                                             || a.TDSRATE ::text
                                             || '   TDS App. Amt. '
                                             || a.TDS_APPAMT::text
                                             || CHR (10)
                                             || 'TDS Amt.  '::text
                                             || ROUND (
                                                     ( a.TDSRATE::numeric
                                                      * a.TDS_APPAMT::numeric)
                                                   / 100,
						2)::text
					end document_details,
					/*Start: Particulars Work Addition/Bug Id :*/
					/*ginview.fnc_ledgerdetails (postcode,
                                                                  entcode,
                                                                  a.enttype,
                                                                  a.glcode,
                                                                  a.damount,
                                                                  a.camount)
                                          particulars,*/
					case
						when p1.postcode is null
						and p2.POSTCODE is null
                                          then
                                             ginview.fnc_ledgerdetails (
                                                a.postcode,
						entcode,
						a.enttype,
						a.glcode,
						a.damount,
						a.camount)
						when p1.postcode is not null
						and p2.POSTCODE is null
                                          then
                                             ginview.fnc_ledgerdetails (
                                                p1.postcode,
						entcode,
						a.enttype,
						a.glcode,
						a.damount,
						a.camount)
						else
                                             p2.particulars1
					end
                                          particulars,
					case
						when p1.postcode is null
						and p2.POSTCODE is null
                                          then
                                             null
						when p1.postcode is not null
						and p2.POSTCODE is null
                                          then
                                             null
						else
                                             p2.particulars2
					end
                                          particulars_2,
					case
						when p1.postcode is null
						and p2.POSTCODE is null
                                          then
                                             null
						when p1.postcode is not null
						and p2.POSTCODE is null
                                          then
                                             null
						else
                                             p2.particulars3
					end
                                          particulars_3,
					case
						when p1.postcode is null
						and p2.POSTCODE is null
                                          then
                                             null
						when p1.postcode is not null
						and p2.POSTCODE is null
                                          then
                                             null
						else
                                             p2.particulars4
					end
                                          particulars_4,
					case
						when p1.postcode is null
						and p2.POSTCODE is null
                                          then
                                             null
						when p1.postcode is not null
						and p2.POSTCODE is null
                                          then
                                             null
						else
                                             p2.particulars5
					end
                                          particulars_5,
					/*End: Particulars Work Addition/Bug Id :*/
					0 opening,
					coalesce (a.damount,
					0) debit,
					coalesce (a.camount,
					0) credit,
					TO_CHAR (entdt,
					'YYYY-MMMON') year_month,
					case
						a.release_status
                                               when 'P' then 'Posted'
						when 'U' then 'Unposted'
						when 'R' then 'Reversed'
					end
                                          release_status,
					a.enttype,
					a.chqno,
					a.chqdt,
					a.drawnon,
					/*Start: Particulars Work Addition/Bug Id :*/
					/*ginview.FNC_REFDETAIL (a.postcode)
                                          refdetail,*/
					case
						when p1.postcode is null
						and p2.POSTCODE is null
                                          then
                                             ginview.FNC_REFDETAIL (a.postcode)
						when p1.postcode is not null
						and p2.POSTCODE is null
                                          then
                                             ginview.FNC_REFDETAIL (a.postcode)
						else
                                             p2.refdetail1
					end
                                          refdetail,
					case
						when p1.postcode is null
						and p2.POSTCODE is null
                                          then
                                             null
						when p1.postcode is not null
						and p2.POSTCODE is null
                                          then
                                             null
						else
                                             p2.refdetail2
					end
                                          refdetail_2,
					case
						when p1.postcode is null
						and p2.POSTCODE is null
                                          then
                                             null
						when p1.postcode is not null
						and p2.POSTCODE is null
                                          then
                                             null
						else
                                             p2.refdetail3
					end
                                          refdetail_3,
					case
						when p1.postcode is null
						and p2.POSTCODE is null
                                          then
                                             null
						when p1.postcode is not null
						and p2.POSTCODE is null
                                          then
                                             null
						else
                                             p2.refdetail4
					end
                                          refdetail_4,
					case
						when p1.postcode is null
						and p2.POSTCODE is null
                                          then
                                             null
						when p1.postcode is not null
						and p2.POSTCODE is null
                                          then
                                             null
						else
                                             p2.refdetail5
					end
                                          refdetail_5,
					/*End: Particulars Work Addition/Bug Id :*/
					sl.agcode,
					ag.slname agname
				from
					(select * from finpost where entdt::date between to_date('@DTFR@',
					'yyyy-mm-dd') and to_date('@DTTO@',
					'yyyy-mm-dd')
					and admou_code =
                                              TO_NUMBER (
                                                 nullif ('@ConnOUCode@',
					'999999999'),
					'999999999')
					and (nullif('@FinIncludeUnpostedRecords@','')::int = 1
					or (nullif('@FinIncludeUnpostedRecords@','')::int = 0 and release_status = 'P'))) a
				inner join finenttype b on
					(a.enttype = b.enttype)
				inner join fingl gl on
					(a.glcode = gl.glcode)
				inner join finsl sl on
					(a.slcode = sl.slcode)
				left outer join finsl ag on
					(sl.agcode = ag.slcode)
				inner join admcls cl on
					(sl.clscode = cl.clscode)
				left outer join FINVCHMAIN vch on
					(a.ENTCODE = vch.VCHCODE::text)
				left outer join fingl fgl on
					(vch.GLCODE = fgl.GLCODE)
				inner join (
					select
						entcode entcode1,
						glcode,
						slcode,
						MAX (
                                                    case
							when docno is null
                                                       then
                                                          (
							select
								docno
							from
								finpost
							where
								entcode =
                                                                         x.entcode
								and postcode =
                                                                         (
								select
									MIN (postcode)
								from
									finpost
								where
									entcode =
                                                                                      x.entcode
								group by
									entcode))
							else
                                                          docno
						end)
                                                    docno,
						MAX (
                                                    case
							when docdt is null
                                                       then
                                                          (
							select
								docdt
							from
								finpost
							where
								entcode =
                                                                         x.entcode
								and postcode =
                                                                         (
								select
									MIN (postcode)
								from
									finpost
								where
									entcode =
                                                                                      x.entcode
								group by
									entcode))
							else
                                                          docdt
						end)
                                                    docdt
					from
						(select * from finpost where entdt::date between to_date('@DTFR@',
					'yyyy-mm-dd') and to_date('@DTTO@',
					'yyyy-mm-dd')
					and admou_code =
                                              TO_NUMBER (
                                                 nullif ('@ConnOUCode@',
					'999999999'),
					'999999999')
					and (nullif('@FinIncludeUnpostedRecords@','')::int = 1
					or (nullif('@FinIncludeUnpostedRecords@','')::int = 0 and release_status = 'P')))x
					where
						slcode is not null
					group by
						entcode,
						glcode,
						slcode) C on
					(a.ENTCODE = C.ENTCODE1
						and a.SLCODE = C.slcode
						and a.glcode = c.glcode)/*Bug 106626*/
						/*Start: Particulars Work Addition/Bug Id :*/
				left outer join (
					select
						distinct postcode
					from
						GINVIEW.FINPOST_PARTICULARS_STAGE
					where
						DML_TYPE <> 'D') p1 on
					(a.POSTCODE = p1.POSTCODE)
				left outer join GINVIEW.FINPOST_PARTICULARS p2 on
					(a.POSTCODE = p2.POSTCODE)
                                 /*End: Particulars Work Addition/Bug Id :*/
					/*Bug 107403*/
				where
					a.entdt::date between to_date('@DTFR@',
					'yyyy-mm-dd') and to_date('@DTTO@',
					'yyyy-mm-dd')
					and a.admou_code =
                                              TO_NUMBER (
                                                 nullif ('@ConnOUCode@',
					'999999999'),
					'999999999')
					and (nullif('@FinIncludeUnpostedRecords@','')::int = 1
					or (nullif('@FinIncludeUnpostedRecords@','')::int = 0 and a.release_status = 'P'))
					and (gl.glname in (
					select
						unnest(regexp_matches('@#LedgerNameMulti#@',
						'[^æ]+',
						'g')) as col1
					from
						generate_series(1,
						(
						select
							count(*)
						from
							regexp_matches('@#LedgerNameMulti#@',
							'æ',
							'g'))+ 1) as g
)
						or coalesce (nullif ('@#LedgerNameMulti#@',
						''),
						'0')::text = 0::text)
					and (sl.slname || '|' || sl.slid in (
					select
						unnest(regexp_matches('@#SubLedgerDisplayNameMulti#@',
						'[^æ]+',
						'g')) as col1
					from
						generate_series(1,
						(
						select
							count(*)
						from
							regexp_matches('@#SubLedgerDisplayNameMulti#@',
							'æ',
							'g'))+ 1) as g
)
						or coalesce (nullif ('@#SubLedgerDisplayNameMulti#@',
						''),
						'0')::text = 0::text)
					and (coalesce(nullif('@AllClass@',''),'-1')='-1'
					or(coalesce(nullif('@AllClass@',''),'-1')<>'-1' and cl.clsname = coalesce(nullif('@AllClass@',''),'-1')))
					and (coalesce(nullif('@Agent@',''),'-1')::int=-1
					or (coalesce(nullif('@Agent@',''),'-1')::int<>-1 and sl.agcode = coalesce(nullif('@Agent@',''),'-1')::int))
			union all
				select
					keyval,
					null entcode,
					glcode,
					'OP' entname,
					null entdt,
					null maingl_code,
					null source_type,
					null entno,
					null docno,
					null docdt,
					null brsdt,
					null created_sitecode,
					slcode,
					null nartext,
					null document_details,
					null particulars,
					/*Start: Particulars Work Addition/Bug Id :*/
					null particulars_2,
					null particulars_3,
					null particulars_4,
					null particulars_5,
					/*End: Particulars Work Addition/Bug Id :*/
					SUM (opening) opening,
					0 debit,
					0 credit,
					year_month,
					null release_status,
					null enttype,
					null chqno,
					null chqdt,
					null drawnon,
					null refdetail,
					/*Start: Particulars Work Addition/Bug Id :*/
					null refdetail_2,
					null refdetail_3,
					null refdetail_4,
					null refdetail_5,
					/*End: Particulars Work Addition/Bug Id :*/
					null agcode,
					null agname
				from
					(
					select
						( P.GLCODE::text || P.SLCODE::text)::text
           || to_date('@DTFR@',
						'yyyy-mm-dd')::DATE
       || 0::text KEYVAL,
						P.GLCODE GLCODE,
						P.SLCODE SLCODE,
						SUM (coalesce (DAMOUNT,
						0)) - SUM (coalesce (CAMOUNT,
						0)) OPENING,
						0 DEBIT,
						0 CREDIT,
						TO_CHAR (to_date('@DTFR@',
						'yyyy-mm-dd'),
						'YYYY-MMMON') YEAR_MONTH
					from
						FINPOST P
					inner join FINGL GL on
						(P.GLCODE = GL.GLCODE)
					inner join FINSL SL on
						(P.SLCODE = SL.SLCODE)
					where
						entdt <
                                                          to_date('@DTFR@',
						'yyyy-mm-dd')
							and ycode =
                                                          (
							select
								ycode
							from
								admyear
							where
								to_date('@DTFR@',
								'yyyy-mm-dd') between dtfr and dtto)
								and admou_code =
                                                          TO_NUMBER (
                                                             nullif (
                                                                '@ConnOUCode@',
								'999999999'),
								'999999999')
									and (gl.glname in (
									select
										unnest(regexp_matches('@#LedgerNameMulti#@',
										'[^æ]+',
										'g')) as col1
									from
										generate_series(1,
										(
										select
											count(*)
										from
											regexp_matches('@#LedgerNameMulti#@',
											'æ',
											'g'))+ 1) as g
)
										or coalesce (nullif ('@#LedgerNameMulti#@',
										''),
										'0')::text = 0::text)
										and (sl.slname || '|' || sl.slid in (
										select
											unnest(regexp_matches('@#SubLedgerDisplayNameMulti#@',
											'[^æ]+',
											'g')) as col1
										from
											generate_series(1,
											(
											select
												count(*)
											from
												regexp_matches('@#SubLedgerDisplayNameMulti#@',
												'æ',
												'g'))+ 1) as g
)
											or coalesce (nullif ('@#SubLedgerDisplayNameMulti#@',
											''),
											'0')::text = 0::text)
											and (coalesce(nullif('@Agent@',''),'-1')::int=-1
					or (coalesce(nullif('@Agent@',''),'-1')::int<>-1 and sl.agcode = coalesce(nullif('@Agent@',''),'-1')::int))/*Bug 106862*/
												and (nullif('@FinIncludeUnpostedRecords@','')::int = 1
					or (nullif('@FinIncludeUnpostedRecords@','')::int = 0 and release_status = 'P'))
											group by
												p.glcode::text
                                                   || p.slcode::text
                                                   || TO_CHAR ( to_date('@DTFR@',
												'yyyy-mm-dd'),
												'yyyy-mm-dd')
                                                   || 0::text,
												p.slcode,
												p.glcode,
												TO_CHAR (to_date('@DTFR@',
												'yyyy-mm-dd'),
												'YYYY-MMMON')
										union all
											select
												( (P.GLCODE::text || P.SLCODE::text)
           || TO_CHAR (to_date('@DTFR@',
												'yyyy-mm-dd'),
												'yyyy-mm-dd'))
       || 0::text KEYVAL,
												P.GLCODE GLCODE,
												P.SLCODE SLCODE,
												SUM (coalesce (OPDAMT,
												0)) - SUM (coalesce (OPCAMT,
												0)) OPENING,
												0 DEBIT,
												0 CREDIT,
												TO_CHAR (to_date('@DTFR@',
												'yyyy-mm-dd'),
												'YYYY-MMMON') YEAR_MONTH
											from
												FINSLOP P
											inner join FINGL GL on
												(P.GLCODE = GL.GLCODE)
											inner join FINSL SL on
												(P.SLCODE = SL.SLCODE)
											where
												ycode =
                                                          (
												select
													ycode
												from
													admyear
												where
													to_date('@DTFR@',
													'yyyy-mm-dd') between dtfr and dtto)
													and admou_code =
                                                          TO_NUMBER (
                                                             nullif (
                                                                '@ConnOUCode@',
													'999999999'),
													'999999999')
														and (coalesce(nullif('@Agent@',''),'-1')::int=-1
					or (coalesce(nullif('@Agent@',''),'-1')::int<>-1 and sl.agcode = coalesce(nullif('@Agent@',''),'-1')::int))/*Bug 106862*/
															and (gl.glname in (
															select
																unnest(regexp_matches('@#LedgerNameMulti#@',
																'[^æ]+',
																'g')) as col1
															from
																generate_series(1,
																(
																select
																	count(*)
																from
																	regexp_matches('@#LedgerNameMulti#@',
																	'æ',
																	'g'))+ 1) as g
)
																or coalesce (nullif ('@#LedgerNameMulti#@',
																''),
																'0')::text = 0::text)
																and (sl.slname || '|' || sl.slid in (
																select
																	unnest(regexp_matches('@#SubLedgerDisplayNameMulti#@',
																	'[^æ]+',
																	'g')) as col1
																from
																	generate_series(1,
																	(
																	select
																		count(*)
																	from
																		regexp_matches('@#SubLedgerDisplayNameMulti#@',
																		'æ',
																		'g'))+ 1) as g
)
																	or coalesce (nullif ('@#SubLedgerDisplayNameMulti#@',
																	''),
																	'0')::text = 0::text)
															group by
																p.glcode::text
                                                   || p.slcode::text
                                                   || to_date('@DTFR@',
																'yyyy-mm-dd')
                                                   || 0::text,
																p.slcode,
																p.glcode,
																TO_CHAR (to_date('@DTFR@',
																'yyyy-mm-dd'),
																'YYYY-MMMON'))X
				group by
					keyval,
					glcode,
					slcode,
					year_month)Z)X1)Z1)XZ
where
	( coalesce (
              TO_NUMBER (nullif ('@FinIncludeZeroBalanceRecords@',
	'999999999'),
	'999999999'),
	1) = 1
		or ( coalesce (
                   TO_NUMBER (nullif ('@FinIncludeZeroBalanceRecords@',
		'999999999'),
		'999999999'),
		1) = 0
			and GINVIEW.ERPBALANCE(
                   'SL'::text,
			slcode::INTEGER,
			to_date('@DTTO@',
			'yyyy-mm-dd'),
			(
			select
				yname::text
			from
				admyear
			where
				to_date('@DTTO@',
				'yyyy-mm-dd') between dtfr and dtto),
				 null::INTEGER,
			TO_NUMBER (nullif ('@ConnOUCode@',
			'999999999'),
			'999999999')::INTEGER) <> 0))