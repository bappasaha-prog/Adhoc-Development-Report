/* Formatted on 2025-03-24 17:41:25 (QP5 v5.294) */
/*><><>< || Custom Development || Object : CQ_WTD_MTD_YTD || Ticket Id : 400289 || Developer : Dipankar || ><><><*/
with DTA as (
SELECT month_start_date::DATE                 MTDSTART,
       WEEK_START_DATE::DATE              WEEKSTART,
       (TO_DATE ('@ASON@', 'yyyy-mm-dd'))     TODAY,
       FISCAL_YEAR_START_DATE::DATE           YEARSTART
  FROM ginview.lv_calendar
 WHERE date_value::DATE = TO_DATE ('@ASON@', 'yyyy-mm-dd'))
select GINVIEW.FNC_UK() UK,F.type,F.TD_BILL_QTY,F.WTD_BILL_QTY,F.MTD_BILL_QTY,F.YTD_BILL_QTY,F.TD_BILL_AMT,F.WTD_BILL_AMT,F.MTD_BILL_AMT,F.YTD_BILL_AMT
from
	(
	select
		'EBO' type,
		SUM (case when M.BILLDATE::DATE = (select TODAY from DTA) then D.QTY else 0 end) TD_BILL_QTY,
		SUM (case when M.BILLDATE::DATE between (select WEEKSTART from DTA) and (select TODAY from DTA) then D.QTY else 0 end) WTD_BILL_QTY,
		SUM (case when M.BILLDATE::DATE between (select MTDSTART from DTA) and (select TODAY from DTA) then D.QTY else 0 end) MTD_BILL_QTY,
		SUM (case when M.BILLDATE::DATE between (select YEARSTART from DTA) and (select TODAY from DTA) then D.QTY else 0 end) YTD_BILL_QTY,
		SUM (case when M.BILLDATE::DATE = (select TODAY from DTA) then D.NETAMT else 0 end) TD_BILL_AMT,
		SUM (case when M.BILLDATE::DATE between (select WEEKSTART from DTA) and (select TODAY from DTA) then D.NETAMT else 0 end) WTD_BILL_AMT,
		SUM (case when M.BILLDATE::DATE between (select MTDSTART from DTA) and (select TODAY from DTA) then D.NETAMT else 0 end) MTD_BILL_AMT,
		SUM (case when M.BILLDATE::DATE between (select YEARSTART from DTA) and (select TODAY from DTA) then D.NETAMT else 0 end) YTD_BILL_AMT
	from
		PSITE_POSBILL M
	inner join PSITE_POSBILLITEM D on
		M.CODE = D.PSITE_POSBILL_CODE
	inner join ginview.lv_item i on d.icode = i.code
	where
		M.BILLDATE::DATE between (select YEARSTART from DTA) and (select TODAY from DTA)
		and i.division in ('Accessories','Menswear')
union all
	select
		'ONLINE' type,
		SUM (case when M.csdate::DATE = (select TODAY from DTA) then D.QTY else 0 end) TD_BILL_QTY,
		SUM (case when M.csdate::DATE between (select WEEKSTART from DTA) and (select TODAY from DTA) then D.QTY else 0 end) WTD_BILL_QTY,
		SUM (case when M.csdate::DATE between (select MTDSTART from DTA) and (select TODAY from DTA) then D.QTY else 0 end) MTD_BILL_QTY,
		SUM (case when M.csdate::DATE between (select YEARSTART from DTA) and (select TODAY from DTA) then D.QTY else 0 end) YTD_BILL_QTY,
		SUM (case when M.csdate::DATE = (select TODAY from DTA) then D.NETAMT else 0 end) TD_BILL_AMT,
		SUM (case when M.csdate::DATE between (select WEEKSTART from DTA) and (select TODAY from DTA) then D.NETAMT else 0 end) WTD_BILL_AMT,
		SUM (case when M.csdate::DATE between (select MTDSTART from DTA) and (select TODAY from DTA) then D.NETAMT else 0 end) MTD_BILL_AMT,
		SUM (case when M.csdate::DATE between (select YEARSTART from DTA) and (select TODAY from DTA) then D.NETAMT else 0 end) YTD_BILL_AMT
	from
		SALCSMAIN M
	inner join SALCSDET D on
		M.CSCODE = D.CSCODE
	inner join ginview.lv_item i on d.icode = i.code
	where
		M.CHANNELTYPE = 'ETL'
		and M.csdate::DATE between (select YEARSTART from DTA) and (select TODAY from DTA)
		and i.division in ('Accessories','Menswear')
union all
	select
		'SIS' type,
		SUM (case when M.ssdate::DATE = (select TODAY from DTA) then D.QTY else 0 end) TD_BILL_QTY,
		SUM (case when M.ssdate::DATE between (select WEEKSTART from DTA) and (select TODAY from DTA) then D.QTY else 0 end) WTD_BILL_QTY,
		SUM (case when M.ssdate::DATE between (select MTDSTART from DTA) and (select TODAY from DTA) then D.QTY else 0 end) MTD_BILL_QTY,
		SUM (case when M.ssdate::DATE between (select YEARSTART from DTA) and (select TODAY from DTA) then D.QTY else 0 end) YTD_BILL_QTY,
		SUM (case when M.ssdate::DATE = (select TODAY from DTA) then D.NETAMT else 0 end) TD_BILL_AMT,
		SUM (case when M.ssdate::DATE between (select WEEKSTART from DTA) and (select TODAY from DTA) then D.NETAMT else 0 end) WTD_BILL_AMT,
		SUM (case when M.ssdate::DATE between (select MTDSTART from DTA) and (select TODAY from DTA) then D.NETAMT else 0 end) MTD_BILL_AMT,
		SUM (case when M.ssdate::DATE between (select YEARSTART from DTA) and (select TODAY from DTA) then D.NETAMT else 0 end) YTD_BILL_AMT
	from
		SALSSMAIN M
	inner join SALSSDET D on
		M.SSCODE = D.SSCODE
	inner join ginview.lv_item i on d.icode = i.code
	inner join admsite s on m.admsite_code  = s.code
	where
		M.ssdate::DATE between (select YEARSTART from DTA) and (select TODAY from DTA)
		and i.division in ('Accessories','Menswear')
		and s.sitetype = 'US-CO-OM-TS' )F