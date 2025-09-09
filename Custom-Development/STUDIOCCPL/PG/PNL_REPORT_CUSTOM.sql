with dta
     as (  select coa.code,
                  level2,
                  level3,
                  level4,
                  level5,
                  p.glcode,
                  p.glname,
                  ref_admsite_code,
                  case
                     when(sum(coalesce(p.damount, 0)) - sum(coalesce(p.camount, 0))) >=
                             0
                     then (sum(coalesce(p.damount, 0)) - sum(coalesce(p.camount, 0)))
                     else
                        0
                  end
                     debit,
                  case
                     when(sum(coalesce(p.damount, 0)) - sum(coalesce(p.camount, 0))) <
                             0
                     then (sum(coalesce(p.damount, 0)) - sum(coalesce(p.camount, 0)))
                     else
                        0
                  end
                     credit
             from (select p.admsite_code_owner ref_admsite_code,
                          g.grpcode,
                          g.glcode,
                          g.glname,
                          p.damount,
                          p.camount
                     from finpost p inner join fingl g on p.glcode = g.glcode
                    where costapp = 'N'
                      and coalesce(p.release_status, 'U') = 'P'
                      and p.entdt between to_date('@DTFR@','yyyy-mm-dd')
                                      and to_date('@DTTO@','yyyy-mm-dd')
				   union all
                   select c.ref_admsite_code,
                          g.grpcode,
                          g.glcode,
                          g.glname,
                          c.damount,
                          c.camount
                     from finpost p
                          inner join fincosttag c on p.postcode = c.postcode
                          inner join fingl g on p.glcode = g.glcode
                    where costapp = 'Y'
                      and coalesce(p.release_status, 'U') = 'P'
                      and p.entdt between to_date('@DTFR@','yyyy-mm-dd')
                                      and to_date('@DTTO@','yyyy-mm-dd')
				  ) p
             inner join ginview.lv_chart_of_accounts coa
                     on p.grpcode = coa.code
             group by coa.code,
					  level2,
					  level3,
					  level4,
					  level5,
					  p.glcode,
					  p.glname,
					  ref_admsite_code
		),
     sales
     as (  select ref_admsite_code,
                  abs(sum(debit) + sum(credit)) sales_value
             from dta
            where level3 = 'Sales'
         group by ref_admsite_code
		)
select t.*, ginview.fnc_uk() uk
  from (select ('1.0')::numeric  seq,
                ref_admsite_code,
                'DIRECT EXPENSES' group_name,
                null            ledger_name,
                0               debit,
                0               credit,
                case
                   when sum(debit) + sum(credit) >= 0
                   then
                      sum(debit) + sum(credit)
                   else
                      0
                end
                   l2_debit,
                case
                   when sum(debit) + sum(credit) < 0
                   then
                      abs(sum(debit) + sum(credit))
                   else
                      0
                end
                   l2_credit
        from dta
        where level3 = 'Job Charges'
		group by ref_admsite_code
		union all
		select 	seq,
				ref_admsite_code,
				group_name,
                glname
				|| ' ('
				|| case
                    when     (val_percent)::numeric  between -1 and 1
                         and (val_percent)::numeric  <> 0
                    then
                       CONCAT('0' , abs(val_percent::numeric))::varchar
                    else
                       abs(val_percent::numeric)::varchar
                 end
				|| '%)'
                 glname,
				debit,
				credit,
				0 l2_debit,
				0 l2_credit
        from (select CONCAT('1.',( row_number() OVER (ORDER BY dta.ref_admsite_code, glname)))::numeric AS seq,
                     dta.ref_admsite_code,
                     'DIRECT EXPENSES' group_name,
                     glname,
                      (
                         round (
                            ( (debit + credit) / sales.sales_value) * 100,
                            2))::TEXT
                         val_percent,
                     debit,
                     abs(credit)      credit,
                     0                 l2_debit,
                     0                 l2_credit
                from dta 
				left outer join sales on (dta.ref_admsite_code=sales.ref_admsite_code)
                where level3 = 'Job Charges'
			  ) alias55
		union all
        select ('2.0')::numeric  seq,
                ref_admsite_code,
                'INDIRECT INCOME' group_name,
                null            ledger_name,
                0               debit,
                0               credit,
                case
                   when sum(debit) + sum(credit) >= 0
                   then
                      sum(debit) + sum(credit)
                   else
                      0
                end
                   l2_debit,
                case
                   when sum(debit) + sum(credit) < 0
                   then
                      abs(sum(debit) + sum(credit))
                   else
                      0
                end
                   l2_credit
          from dta
         where (level2 = 'Indirect Incomes')
		group by ref_admsite_code
		union all
		select 	seq,
				ref_admsite_code,
				group_name,
                glname
				 || ' ('
				 || case
                      when (val_percent)::numeric  between -1 and 1
                         and (val_percent)::numeric  <> 0
					  then
                       CONCAT('0' , abs(val_percent::numeric))::varchar
                      else
                       abs(val_percent::numeric)::varchar
                    end
				 || '%)'
                glname,
                debit,
                credit,
                0 l2_debit,
                0 l2_credit
          from (select CONCAT('2.',( row_number() OVER (ORDER BY dta.ref_admsite_code, glname)))::numeric AS seq,
                       dta.ref_admsite_code,
                       'INDIRECT INCOME' group_name,
                       glname,
                        (
                         round (
                            ( (debit + credit) / sales.sales_value) * 100,
                            2))::TEXT
                         val_percent,
                       debit,
                       abs(credit)      credit,
                       0                 l2_debit,
                       0                 l2_credit
                  from dta left outer join sales on (dta.ref_admsite_code=sales.ref_admsite_code)
                 where (level2 = 'Indirect Incomes'
                                                  )
				) alias81
		union all
        Select ('3.0')::numeric  seq,
                ref_admsite_code,
                'PURCHASE ACCOUNTS' group_name,
                null              ledger_name,
                0                 debit,
                0                 credit,
                case
                   when sum(debit) + sum(credit) >= 0
                   then
                      sum(debit) + sum(credit)
                   else
                      0
                end
                   l2_debit,
                case
                   when sum(debit) + sum(credit) < 0
                   then
                      abs(sum(debit) + sum(credit))
                   else
                      0
                end
                   l2_credit
           from dta
          where level3 = 'Purchase'
		  group by ref_admsite_code
		union all
		Select  seq,
                ref_admsite_code,
                group_name,
                glname
				 || ' ('
				 || case
                      when (val_percent)::numeric  between -1 and 1
                         and (val_percent)::numeric  <> 0
                      then
                       CONCAT('0' , abs(val_percent::numeric))::varchar
                      else
                       abs(val_percent::numeric)::varchar
                    end
                 || '%)'
                 glname,
                debit,
				credit,
				l2_debit,
				l2_credit
         from (select seq,
                      t.ref_admsite_code,
                      group_name,
                      glname,
                       (
                         round (
                            ( (debit + credit) / sales.sales_value) * 100,
                            2))::TEXT
                         val_percent,
                      debit,
                      credit,
                      l2_debit,
                      l2_credit
                 from (  select ('3.1')::numeric  seq,
                                ref_admsite_code,
                                'PURCHASE ACCOUNTS' group_name,
                                'Purchase'        glname,
                                sum(debit)       debit,
                                0                 credit,
                                0                 l2_debit,
                                0                 l2_credit
                           from dta
                          where level3 = 'Purchase'
                       group by ref_admsite_code
					   ) t
                      left outer join sales on (t.ref_admsite_code=sales.ref_admsite_code)
			   ) alias104
		union all
		select 	seq,
				ref_admsite_code,
				group_name,
                glname
                 || ' ('
                 || case
                     when(val_percent)::numeric  between -1 and 1
                      and (val_percent)::numeric  <> 0
                    then
                       CONCAT('0' , abs(val_percent::numeric))::varchar
                    else
                       abs(val_percent::numeric)::varchar
					end
				  || '%)'
                glname,
                debit,
                credit,
                l2_debit,
                l2_credit
         from (select seq,
                      t.ref_admsite_code,
                      group_name,
                      glname,
                       (
                         round (
                            ( (debit + credit) / sales.sales_value) * 100,
                            2))::TEXT
                         val_percent,
                      debit,
                      credit,
                      l2_debit,
                      l2_credit
                from (select ('3.2')::numeric  seq,
							ref_admsite_code,
							'PURCHASE ACCOUNTS' group_name,
							'PURCHASE RETURN' glname,
							0                 debit,
							abs(sum(credit)) credit,
							0                 l2_debit,
							0                 l2_credit
					   from dta
					  where level3 = 'Purchase'
					  group by ref_admsite_code
				     ) t
                     left outer join sales on (t.ref_admsite_code=sales.ref_admsite_code)
			  ) alias118
		union all
        select ('4.0')::numeric  seq,
                ref_admsite_code,
                'SALES ACCOUNTS' group_name,
                null            ledger_name,
                0               debit,
                0               credit,
                case
                   when sum(debit) + sum(credit) >= 0
                   then
                      sum(debit) + sum(credit)
                   else
                      0
                end
                   l2_debit,
                case
                   when sum(debit) + sum(credit) < 0
                   then
                      abs(sum(debit) + sum(credit))
                   else
                      0
                end
                   l2_credit
          from dta
         where (level3 = 'Sales')
		group by ref_admsite_code
		union all
		select seq,
              ref_admsite_code,
              group_name,
                 glname
              || ' ('
              || case
                    when     (val_percent)::numeric  between -1 and 1
                         and (val_percent)::numeric  <> 0
                    then
                       CONCAT('0' , abs(val_percent::numeric))::varchar
                    else
                       abs(val_percent::numeric)::varchar
                 end
              || '%)'
                 glname,
              debit,
              credit,
              l2_debit,
              l2_credit
         from (select CONCAT('4.',( row_number() OVER (partition by t.ref_admsite_code ORDER BY t.ref_admsite_code, glname)))::numeric AS seq,
					  t.ref_admsite_code,
					  'SALES ACCOUNTS'                            group_name,
					  glname                                      ,
					   (
								 round (
									( (debit + credit) / sales.sales_value) * 100,
									2))::TEXT
								 val_percent,
					  debit,
					  abs(credit) credit,
					  case when glcode in (35,48) then debit end        l2_debit,
					  case when glcode in (35,48) then abs(credit) end l2_credit
				 from (select ref_admsite_code,
							  glcode,
							  glname,
							  debit,
							  credit
						 from dta
						where (level3 = 'Sales' or glcode in (35,48))
			   union all
						select c.ref_admsite_code,
							   p.glcode,
							   glname || ' - Debit'   glname,
							   sum(coalesce(c.damount, 0)) debit,
							   0                      credit
						  from finpost p
							   inner join fincosttag c on p.postcode = c.postcode
							   inner join fingl gl on p.glcode = gl.glcode
						 where p.glcode = 36
						   and coalesce(p.release_status, 'U') = 'P'
						   and p.entdt between to_date('@DTFR@',
															 'yyyy-mm-dd')
											and to_date('@DTTO@',
															 'yyyy-mm-dd')
						   and c.camount = 0
						group by p.glcode, glname, c.ref_admsite_code
						union all
						 select c.ref_admsite_code,
								p.glcode,
								glname || ' - Credit'  glname,
								0                      debit,
								sum(coalesce(c.camount, 0)) credit
						   from finpost p
								inner join fincosttag c on p.postcode = c.postcode
								inner join fingl gl on p.glcode = gl.glcode
						  where     p.glcode = 36
								and coalesce(p.release_status, 'U') = 'P'
								and p.entdt between to_date('@DTFR@',
															 'yyyy-mm-dd')
												and to_date('@DTTO@',
															 'yyyy-mm-dd')
								and c.damount = 0
					   group by p.glcode, glname, c.ref_admsite_code)t
                      left outer join sales on (t.ref_admsite_code=sales.ref_admsite_code)) alias156
		union all
		select ('5')::numeric  seq,
               ref_admsite_code,
               'OPENING STOCK' group_name,
               null            ledger_name,
               0,
               0,
               debit           l2_debit,
               abs(credit)    l2_credit
          from dta
         where glcode = 51
		union all
		select 	('6')::numeric  seq,
				ref_admsite_code,
				'CLOSING STOCK' group_name,
				null            ledger_name,
				0,
				0,
				debit           l2_debit,
				abs(credit)    l2_credit
          from dta
         where glcode = 40
		union all
		select 	seq,
				ref_admsite_code,
				group_name
				|| ' ('
				|| case
                    when     (val_percent)::numeric  between -1 and 1
                         and (val_percent)::numeric  <> 0
                    then
                       CONCAT('0' , abs(val_percent::numeric))::varchar
                    else
                       abs(val_percent::numeric)::varchar
                 end
				|| '%)'
                group_name,
                glname,
				debit,
				credit,
				l2_debit,
				l2_credit
        from
		   (select  ('7')::numeric                                      seq,
				    t.ref_admsite_code,
					'Gross '
				    || case when balance > 0 then 'Loss' else 'Profit' end
				    || ' c/o'
					 group_name,
				    null                                                glname,
				    (
							 round (
								( abs(balance) / sales.sales_value) * 100,
								2))::TEXT
							 val_percent,
				    0                                                   debit,
				    0                                                   credit,
				    case when balance < 0 then abs(balance) else 0 end l2_debit,
				    case when balance >= 0 then balance else 0 end      l2_credit
			  from (select ref_admsite_code,
							case
							   when sum(debit) + sum(credit) >= 0
							   then
								  sum(debit) + sum(credit)
							   else
								  sum(debit) + sum(credit)
							end
							   balance
					  from dta
					 where (glcode in (40, 51, 35,48)
						or level3 in ('Sales', 'Purchase', 'Job Charges')
						or level2 = 'Indirect Incomes')
				    group by ref_admsite_code
				    )t 
				left outer join sales on (t.ref_admsite_code=sales.ref_admsite_code)
			) alias182
		union all
        select  ('8')::numeric  seq,
                ref_admsite_code,
                ' [Total]'    group_name,
                null          ledger_name,
                0             debit,
                0             credit,
                sum(l2_debit) l2_debit,
                sum(l2_credit) l2_credit
          from (select	'Profit',
                        ref_admsite_code,
                        case
                             when sum(debit) + sum(credit) < 0
                             then
                                abs(sum(debit) + sum(credit))
                             else
                                0
                        end l2_debit,
                        case
                             when sum(debit) + sum(credit) >= 0
                             then
                                abs(sum(debit) + sum(credit))
                             else
                                0
                        end l2_credit
                  from dta
                 where (glcode in (40, 51, 35,48)
                        or level3 in ('Sales', 'Purchase', 'Job Charges')
                        or level2 = 'Indirect Incomes'
					   )
                 group by ref_admsite_code
				union all
				select 	level3,
						ref_admsite_code,
						case
						 when sum(debit) + sum(credit) >= 0
						 then
							sum(debit) + sum(credit)
						 else
							0
						end
						 l2_debit,
						case
						 when sum(debit) + sum(credit) < 0
						 then
							abs(sum(debit) + sum(credit))
						 else
							0
						end
						 l2_credit
				 from dta
				where (   glcode in (40, 51, 35,48)
					   or level3 in ('Sales', 'Purchase', 'Job Charges')
					   or level2 = 'Indirect Incomes'
					   )
				group by level3, ref_admsite_code
				) alias211
		  group by ref_admsite_code
		union all
		select ('9')::numeric                                       seq,
              ref_admsite_code,
                 'Gross '
              || case when balance > 0 then 'Loss' else 'Profit' end
              || ' b/f'
                 group_name,
              null                                                 ledger_name,
              0                                                    debit,
              0                                                    credit,
              case when balance > 0 then balance else 0 end        l2_debit,
              case when balance <= 0 then abs(balance) else 0 end l2_credit
         from (  select ref_admsite_code,
                        case
                           when sum(debit) + sum(credit) >= 0
                           then
                              sum(debit) + sum(credit)
                           else
                              sum(debit) + sum(credit)
                        end
                           balance
                   from dta
                  where (   glcode in (40, 51, 35,48)
                         or level3 in ('Sales', 'Purchase', 'Job Charges')
                         or level2 = 'Indirect Incomes')
               group by ref_admsite_code) alias223
		union all
         select (10)::numeric       seq,
                ref_admsite_code,
                'EXPENSES (INDIRECT)' group_name,
                null                glname,
                0                   debit,
                0                   credit,
                case
                   when sum(debit) + sum(credit) >= 0
                   then
                      sum(debit) + sum(credit)
                   else
                      0
                end
                   l2_debit,
                case
                   when sum(debit) + sum(credit) < 0
                   then
                      abs(sum(debit) + sum(credit))
                   else
                      0
                end
                   l2_credit
           from dta
          where level2 = 'Indirect Expenses'
		group by level2, ref_admsite_code
		union all
        select (10
                   + row_number()
                     over (partition by ref_admsite_code
                           order by ref_admsite_code))::numeric 
                   seq,
                ref_admsite_code,
                'EXPENSES (INDIRECT)' group_name,
                level3              glname,
                0                   debit,
                0                   credit,
                case
                   when sum(debit) + sum(credit) >= 0
                   then
                      sum(debit) + sum(credit)
                   else
                      0
                end
                   l2_debit,
                case
                   when sum(debit) + sum(credit) < 0
                   then
                      abs(sum(debit) + sum(credit))
                   else
                      0
                end
                   l2_credit
           from dta
          where level2 = 'Indirect Expenses'
		group by level3, ref_admsite_code
		union all
		select  (grpcode::varchar
                 || '.'
                 || case
                       when seq <= 9 then '0' || seq::varchar
                       else seq::varchar
                    end)::numeric 
                 seq,
				ref_admsite_code,
				group_name,
				glname,
				debit,
				credit,
				l2_debit,
				l2_credit
         from (select 10 + dense_rank() over (order by level3) grpcode,
                      row_number()
                      over (partition by ref_admsite_code, level3
                            order by ref_admsite_code, glname)
                         seq,
                      ref_admsite_code,
                      group_name,
                         glname
                      || ' ('
                      || case
                            when     (val_percent)::numeric  between -1
                                                                 and 1
                                 and (val_percent)::numeric  <> 0
                            then 
                       CONCAT('0' , abs(val_percent::numeric))::varchar
                    else
                       abs(val_percent::numeric)::varchar
                         end
                      || '%)'
                         glname,
                      debit,
                      credit,
                      l2_debit,
                      l2_credit
                 from (select 'EXPENSES (INDIRECT)' group_name,
                              dta.ref_admsite_code,
                              level3,
                              glname,
                               (
                                 round (
                                      ( (debit + credit) / sales.sales_value)
                                    * 100,
                                    2))::TEXT
                                 val_percent,
                              debit,
                              abs(credit)          credit,
                              0                     l2_debit,
                              0                     l2_credit
                         from dta  left outer join sales on (dta.ref_admsite_code=sales.ref_admsite_code)
                        where level2 = 'Indirect Expenses') alias261) alias262
		union all
        select seq,
               ref_admsite_code,
                  group_name
               || ' ('
               || case
                     when     (val_percent)::numeric  between -1 and 1
                          and (val_percent)::numeric  <> 0
                     then
                       CONCAT('0' , abs(val_percent::numeric))::varchar
                    else
                       abs(val_percent::numeric)::varchar
                  end
               || '%)'
                  group_name,
               glname,
               debit,
               credit,
               l2_debit,
               l2_credit
          from (select seq,
                       t.ref_admsite_code,
                       case
                          when l2_debit > l2_credit then 'Net Profit'
                          when l2_credit > l2_debit then 'Net Loss'
                          else 'Net Profit/Loss'
                       end
                          group_name,
                       glname,
                        (
                          round (
                             ( (l2_debit + l2_credit) / sales.sales_value) * 100,
                             2))::TEXT
                          val_percent,
                       debit,
                       credit,
                       l2_debit,
                       l2_credit
                  from (  select (999)::numeric  seq,
                                 ref_admsite_code,
                                 null          group_name,
                                 null          glname,
                                 0             debit,
                                 0             credit,
                                 case
                                    when sum(l2_debit) - sum(l2_credit) < 0
                                    then
                                       abs(sum(l2_debit) - sum(l2_credit))
                                    else
                                       0
                                 end
                                    l2_debit,
                                 case
                                    when sum(l2_debit) - sum(l2_credit) >= 0
                                    then
                                       sum(l2_debit) - sum(l2_credit)
                                    else
                                       0
                                 end
                                    l2_credit
                            from (select ref_admsite_code,
                                         case
                                            when balance > 0 then balance
                                            else 0
                                         end
                                            l2_debit,
                                         case
                                            when balance <= 0
                                            then
                                               abs(balance)
                                            else
                                               0
                                         end
                                            l2_credit
                                    from (  select ref_admsite_code,
                                                   case
                                                      when   sum(debit)
                                                           + sum(credit) >= 0
                                                      then
                                                           sum(debit)
                                                         + sum(credit)
                                                      else
                                                           sum(debit)
                                                         + sum(credit)
                                                   end
                                                      balance
                                              from dta
                                             where (   glcode in (40, 51, 35,48)
                                                    or level3 in ('Sales','Purchase','Job Charges')
                                                    or level2 = 'Indirect Incomes')
                                          group by ref_admsite_code
										 ) alias291
									union all
                                    select ref_admsite_code,
                                           case
                                              when sum(debit) + sum(credit) >=
                                                      0
                                              then
                                                 sum(debit) + sum(credit)
                                              else
                                                 0
                                           end
                                              l2_debit,
                                           case
                                              when sum(debit) + sum(credit) < 0
                                              then
                                                 abs(sum(debit) + sum(credit))
                                              else
                                                 0
                                           end
                                              l2_credit
                                      from dta
                                     where level2 = 'Indirect Expenses'
                                  group by ref_admsite_code
								 ) alias301
                        group by ref_admsite_code) t
                       left outer join sales
                          on (t.ref_admsite_code = sales.ref_admsite_code)
			   ) alias304
		)
       t