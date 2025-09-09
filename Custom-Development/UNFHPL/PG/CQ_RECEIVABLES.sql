/*><><>< || Custom Development || Object : CQ_RECEIVABLES || Ticket Id : 398007 || Developer : Dipankar || ><><><*/
select
	GINVIEW.FNC_UK() uk,
	admou_code,
	t.ref_admsite_code,
	s.slab_name,
	balance_amount
from
	ginview.custom_age_slab s
left outer join( select t.admou_code,
               			t.ref_admsite_code,
                         outstanding_age_slab,
                         sum(balance_amount) balance_amount
                    from (with CUSTOM_AGE_SLAB as(
		select 1 CODE , '0-30' SLAB_NAME, '0' SLAB_DAY_FROM, '30' SLAB_DAY_TO
		union all
		select 2 CODE, '31-45' SLAB_NAME, '31' SLAB_DAY_FROM, '45' SLAB_DAY_TO
		union all
		select 3 CODE, '46-60' SLAB_NAME, '46' SLAB_DAY_FROM, '60' SLAB_DAY_TO
		union all
		select 4 CODE, '61-90' SLAB_NAME, '61' SLAB_DAY_FROM, '90' SLAB_DAY_TO
		union all
		select 5 CODE, '90 days or more' SLAB_NAME, '91' SLAB_DAY_FROM, '9999' SLAB_DAY_TO
		union all
		select 6 CODE, 'Total' SLAB_NAME, '' SLAB_DAY_FROM, '' SLAB_DAY_TO
		)
		select slcode,
            glcode,
            admou_code,
            ref_admsite_code,
            SUM (pending) balance_amount,
            outstanding_age_slab
       from (select slcode,
                    ref_admsite_code,
                    glcode,
                    agcode,
                    admou_code,
                    amount,
                    adjusted,
                    pending,
                    (select slab_name
                       from custom_age_slab
                      where outstanding_age::TEXT between SLAB_DAY_FROM
                                                and SLAB_DAY_TO)
                       outstanding_age_slab,
                    cheque_amount,
                    case
                       when DOCUMENT_TYPE = 'AR/AP Voucher'
                       then
                          case when adjusted <> amount then pending else 0 end
                       else
                          0
                    end
                       unadjust_payment
               from ( select sl.slcode,
                              aj.ADMSITE_CODE_OWNER,
                              aj.ref_admsite_code,
                              aj.general_ledger_code glcode,
                              case coalesce (nullif ('M', ''), 'M')
                                 when 'T' then coalesce (ag.agcode, sl.agcode)
                                 when 'M' then sl.agcode
                              end
                                 agcode,
                              aj.admou_code,
                              ( to_date('@ASON@', 'YYYY-MM-DD')
                               - (case coalesce (nullif ('3DOC', ''), '-1')
                                     when '3DOC'
                                     then
                                        aj.document_date
                                     when '2DUE'
                                     then
                                        aj.due_dt
                                     when '4REF'
                                     then
                                        coalesce (aj.ref_dt, aj.document_date)
                                     when '1VND'
                                     then
                                        case sl.due_date_basis
                                           when 'ENTRY DATE'
                                           then
                                              aj.document_date
                                           else
                                              coalesce (aj.ref_dt,
                                                        aj.document_date)
                                        end
                                  end))
                                 outstanding_age,
                              SUM (
                                 case drcr
                                    when 'Dr' then coalesce (amount, 0)
                                    when 'Cr' then 0 - coalesce (amount, 0)
                                 end)
                                 amount,
                              SUM (
                                 case
                                    when drcr = 'Dr'
                                    then
                                       case
                                          when coalesce (detail_receipt_amt, 0) <=
                                                  0
                                          then
                                             coalesce (detail_receipt_amt, 0)
                                          else
                                             0 - coalesce (detail_receipt_amt, 0)
                                       end
                                    else
                                       case
                                          when coalesce (detail_receipt_amt, 0) <=
                                                  0
                                          then
                                             0 - coalesce (detail_receipt_amt, 0)
                                          else
                                             coalesce (detail_receipt_amt, 0)
                                       end
                                 end)
                                 adjusted,
                                (SUM (
                                    case DRCR
                                       when 'Dr' then coalesce (AMOUNT, 0)
                                       when 'Cr' then 0 - coalesce (AMOUNT, 0)
                                    end))
                              + SUM (
                                   case
                                      when DRCR = 'Dr'
                                      then
                                         case
                                            when coalesce (DETAIL_RECEIPT_AMT, 0) <=
                                                    0
                                            then
                                               coalesce (DETAIL_RECEIPT_AMT, 0)
                                            else
                                                 0
                                               - coalesce (DETAIL_RECEIPT_AMT, 0)
                                         end
                                      else
                                         case
                                            when coalesce (DETAIL_RECEIPT_AMT, 0) <=
                                                    0
                                            then
                                                 0
                                               - coalesce (DETAIL_RECEIPT_AMT, 0)
                                            else
                                               coalesce (DETAIL_RECEIPT_AMT, 0)
                                         end
                                   end)
                                 PENDING,
                              0 cheque_amount,
                              aj.document_type
                         from v_adj aj
                              inner join finsl sl
                                 on (aj.sub_ledger_code = sl.slcode)
                              inner join admcls cl on sl.clscode = cl.clscode
                              left outer join
                              ( select detail_post_code,
                                        SUM (detail_receipt_amt) detail_receipt_amt
                                   from (select a.postcode1 detail_post_code,
                                                case
                                                   when entdt <= to_date('@ASON@', 'YYYY-MM-DD')
                                                   then
                                                      case
                                                         when a.enttype1 = 'VDP'
                                                         then
                                                            coalesce (a.amount, 0)
                                                         else
                                                            case coalesce (
                                                                    b.damount,
                                                                    0)
                                                               when 0
                                                               then
                                                                  -a.amount
                                                               else
                                                                  a.amount
                                                            end
                                                      end
                                                   else
                                                      0
                                                end
                                                   detail_receipt_amt
                                           from fintag a,
                                                finpost b,
                                                finsl s,
                                                admcls cl
                                          where a.postcode2 = b.postcode
                                                and b.slcode = s.slcode
                                                and s.clscode = cl.clscode
                                                and b.release_status = 'P'
                                         union all
                                         select a.postcode2 detail_post_code,
                                                case
                                                   when entdt <= to_date('@ASON@', 'YYYY-MM-DD') then
                                                      case
                                                         when a.enttype2 = 'VDP'
                                                         then
                                                            ABS (
                                                               coalesce (a.amount,
                                                                         0))
                                                         else
                                                            case coalesce (
                                                                    b.damount,
                                                                    0)
                                                               when 0
                                                               then
                                                                  -a.amount
                                                               else
                                                                  a.amount
                                                            end
                                                      end
                                                   else
                                                      0
                                                end
                                                   detail_receipt_amt
                                           from fintag a,
                                                finpost b,
                                                finsl s,
                                                admcls cl
                                          where a.postcode1 = b.postcode
                                                and b.slcode = s.slcode
                                                and s.clscode = cl.clscode
                                                and b.release_status = 'P') T1
                               group by detail_post_code) adjustment
                                 on (aj.posting_code =
                                        adjustment.detail_post_code)
                              left outer join
                              (select a.invcode::TEXT entcode,
                                      a.agcode,
                                      s.slname agname
                                 from salinvmain a,
                                      finsl s
                                where a.agcode = s.slcode
                               union all
                               select a.rtcode::text entcode,
                                      a.agcode,
                                      s.slname agname
                                 from salrtmain a,
                                      finsl s
                                where a.agcode = s.slcode
                               union all
                               select a.invcode::text entcode,
                                      a.agcode,
                                      s.slname agname
                                 from purinvmain a,
                                      finsl s
                                where a.agcode = s.slcode
                               union all
                               select a.rtcode::text ENTCODE,
                                      a.agcode,
                                      s.slname agname
                                 from purrtmain a,
                                      finsl s
                                where a.agcode = s.slcode
                               union all
                               select a.entcode::text ENTCODE,
                                      a.agcode,
                                      s.slname agname
                                 from finopdoc a,
                                      finsl s
                                where a.agcode = s.slcode
                                      and a.enttype in ('SIM',
                                                        'SRM',
                                                        'PIM',
                                                        'PRM')) ag
                                 on (aj.document_code = ag.entcode)
                        where 1 =
                                     case
                                        when 'E' = 'E'
                                             and aj.document_date <= to_date('@ASON@', 'YYYY-MM-DD')
                                        then
                                           1
                                        when 'E' = 'D'
                                             and case sl.due_date_basis
                                                    when 'ENTRY DATE'
                                                    then
                                                       aj.document_date
                                                    else
                                                       coalesce (
                                                          aj.ref_dt,
                                                          aj.document_date)
                                                 end <= to_date('@ASON@', 'YYYY-MM-DD')
                                        then
                                           1
                                     end
                              and aj.release_status = 'Posted'
                              and aj.general_ledger_code in
                                     (select glcode
                                        from fingl
                                       where srctype = 'R')
                     group by sl.slcode,
                              aj.ADMSITE_CODE_OWNER,
                              aj.ref_admsite_code,
                              aj.general_ledger_code,
                              case coalesce (nullif ('M', ''), 'M')
                                 when 'T' then coalesce (ag.agcode, sl.agcode)
                                 when 'M' then sl.agcode
                              end,
                              aj.admou_code,
                              ( to_date('@ASON@', 'YYYY-MM-DD')
                               - (case coalesce (nullif ('3DOC', ''), '-1')
                                     when '3DOC'
                                     then
                                        aj.document_date
                                     when '2DUE'
                                     then
                                        aj.due_dt
                                     when '4REF'
                                     then
                                        coalesce (aj.ref_dt, aj.document_date)
                                     when '1VND'
                                     then
                                        case sl.due_date_basis
                                           when 'ENTRY DATE'
                                           then
                                              aj.document_date
                                           else
                                              coalesce (aj.ref_dt,
                                                        aj.document_date)
                                        end
                                  end)),
                              aj.document_type) T7) t8
   group by slcode,
            glcode,
            admou_code,
            ref_admsite_code,
            outstanding_age_slab) t
            			inner join admsite r on t.ref_admsite_code = r.code
                         inner join fingl g
                            on t.glcode = g.glcode
                               and g.glcode in (1037)/*sundry debtors for goods*/
                               and t.admou_code = nullif('@ConnOUCode@', '')::int
                               where r.sitetype like '%US%'
                group by t.admou_code, t.ref_admsite_code, outstanding_age_slab) t
                  on
	s.slab_name = t.outstanding_age_slab