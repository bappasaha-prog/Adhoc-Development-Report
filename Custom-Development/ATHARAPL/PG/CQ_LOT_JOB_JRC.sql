/*|| Custom Development || Object : CQ_LOT_JOB_JRC || Ticket Id :  409720 || Developer : Dipankar ||*/

select ginview.fnc_uk() uk,
s.name site_name,
m.lotno,
JOB.cutting_date,
i.category3 size,
i.category2 d_no,
sa.sainame sub_assembly,
grp.grpname routegrp,
rm.name  routename,
JOB.cutting_qty qty,
i.category1 code,
i.string_desc4,
i.string_desc5,
MAX(case when p.prname = 'CUTTING' then j.slname end) cutting_jobber,
MAX(case when p.prname = 'CUTTING' then jd.job_rate end) cutting_jwrate,
MAX(case when p.prname = 'CUTTING' then jm.job_date::date  end) cutting_jdate,
MAX(case when p.prname = 'CUTTING' then jrm.jrc_date::date  end) cutting_jrdate,
MAX(case when p.prname = 'EMBROIDERY' then j.slname end) embroidery_jobber,
MAX(case when p.prname = 'EMBROIDERY' then jd.job_rate  end) embroidery_jwrate,
MAX(case when p.prname = 'EMBROIDERY' then jm.job_date::date  end) embroidery_jdate,
MAX(case when p.prname = 'EMBROIDERY' then jrm.jrc_date::date  end) embroidery_jrdate,
MAX(case when p.prname = 'STITCHING' then j.slname  end) stitching_jobber,
MAX(case when p.prname = 'STITCHING' then jd.job_rate end) stitching_jwrate,
MAX(case when p.prname = 'STITCHING' then jm.job_date::date end) stitching_jdate,
MAX(case when p.prname = 'STITCHING' then jrm.jrc_date::date end) stitching_jrdate,
MAX(case when p.prname = 'PRINTING' then j.slname  end) printing_jobber,
MAX(case when p.prname = 'PRINTING' then jd.job_rate  end) printing_jwrate,
MAX(case when p.prname = 'PRINTING' then jm.job_date::date  end) printing_jdate,
MAX(case when p.prname = 'PRINTING' then jrm.jrc_date::date end) printing_jrdate,
MAX(case when p.prname = 'FUSING' then j.slname  end) fusing_jobber,
MAX(case when p.prname = 'FUSING' then jd.job_rate end) fusing_jwrate,
MAX(case when p.prname = 'FUSING' then jm.job_date::date end) fusing_jdate,
MAX(case when p.prname = 'FUSING' then jrm.jrc_date::date end) fusing_jrdate,
MAX(case when p.prname = 'HANDWORK' then j.slname  end) handwork_jobber,
MAX(case when p.prname = 'HANDWORK' then jd.job_rate end) handwork_jwrate,
MAX(case when p.prname = 'HANDWORK' then jm.job_date::date end) handwork_jdate,
MAX(case when p.prname = 'HANDWORK' then jrm.jrc_date::date end) handwork_jrdate,
MAX(case when p.prname = 'REFINISHING' then j.slname end) refinishing_jobber,
MAX(case when p.prname = 'REFINISHING' then jd.job_rate end) refinishing_jwrate,
MAX(case when p.prname = 'REFINISHING' then jm.job_date::date end) refinishing_jdate,
MAX(case when p.prname = 'REFINISHING' then jrm.jrc_date::date end) refinishing_jrdate,
MAX(case when p.prname = 'PLEATING' then j.slname  end) pleating_jobber,
MAX(case when p.prname = 'PLEATING' then jd.job_rate  end) pleating_jwrate,
MAX(case when p.prname = 'PLEATING' then jm.job_date::date end) pleating_jdate,
MAX(case when p.prname = 'PLEATING' then jrm.jrc_date::date end) pleating_jrdate,
MAX(case when p.prname = 'WASHING' then j.slname  end) washing_jobber,
MAX(case when p.prname = 'WASHING' then jd.job_rate end) washing_jwrate,
MAX(case when p.prname = 'WASHING' then jm.job_date::date end) washing_jdate,
MAX(case when p.prname = 'WASHING' then jrm.jrc_date::date end) washing_jrdate,
MAX(case when p.prname = 'SMOCKING' then j.slname end) smocking_jobber,
MAX(case when p.prname = 'SMOCKING' then jd.job_rate end) smocking_jwrate,
MAX(case when p.prname = 'SMOCKING' then jm.job_date::date end) smocking_jdate,
MAX(case when p.prname = 'SMOCKING' then jrm.jrc_date::date end) smocking_jrdate,
MAX(case when p.prname = 'BARTAG' then j.slname end) bartag_jobber,
MAX(case when p.prname = 'BARTAG' then jd.job_rate end) bartag_jwrate,
MAX(case when p.prname = 'BARTAG' then jm.job_date::date end) bartag_jdate,
MAX(case when p.prname = 'BARTAG' then jrm.jrc_date::date end) bartag_jrdate,
MAX(case when p.prname = 'CHK/READY' then j.slname end) chk_jobber,
MAX(case when p.prname = 'CHK/READY' then jd.job_rate end) chk_jwrate,
MAX(case when p.prname = 'CHK/READY' then jm.job_date::date end) chk_jdate,
MAX(case when p.prname = 'CHK/READY' then jrm.jrc_date::date end) chk_jrdate,
max(jrm.time)::date last_jrc_date
from prdlotmain m 
left join prdlotdet d ON m.CODE = d.lotcode 
LEFT join (
		select
			D.LOTCODE,
			MIN (M.JOB_DATE) CUTTING_DATE,
			SUM(D.qty) CUTTING_QTY
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
left join ginview.lv_item i on d.assembly_icode = i.code
left join admsite s on m.admsite_code = s.code 
left join prdroutegrpdet r on d.routecode = r.routecode and d.assembly_icode = r.icode and m.routegrp_code = r.routegrp_code 
left join prdroutegrp grp on r.routegrp_code = grp.code 
left join prdroutemain rm on r.routecode = rm.code 
left join prdjobdet jd on d.lotcode = jd.lotcode 
left outer join PRD_SAITEM SA on jd.ass_saitem_code = sa.code 
left join prdjobmain jm on jd.jobcode = jm.code
left join prdpr p on jm.prcode = p.prcode
left join finsl j on jm.pcode = j.slcode 
left join prdjrcdet jrd on jd.code = jrd.jobdet_code and jd.jobcode = jrd.jobcode and jd.lotcode = jrd.lotcode 
left join prdjrcmain jrm on jrd.jrccode = jrm.code
where job.cutting_date::date between to_date('@DTFR@','YYYY-MM-DD') and to_date('@DTTO@','YYYY-MM-DD')
group by
s.name,
m.lotno,
JOB.cutting_date,
i.category3,
i.category2,
sa.sainame,
grp.grpname,
rm.name,
JOB.cutting_qty,
i.category1,
i.string_desc4,
i.string_desc5