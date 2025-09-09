/*|| Custom Development || Object : CQ_PROMO_SITE_ASSIGN || Ticket Id :  429097 || Developer : Dipankar ||*/
SELECT 
    row_number() over() uk,
    psite_promo_assign.STATUS
	,to_char(psite_promo_assign.starttime, 'HH24:MI:SS'::TEXT) AS starttime
	,psite_promo_assign.startdate::DATE AS startdate
	,psite_promo_assign.promo_code
	,promo_master.name AS promo_name
	,psite_promo_assign.priority
	,psite_promo_assign.lastmodifiedon
	,((appuserlastmod.fullname::TEXT || '['::TEXT) || appuserlastmod.empno::TEXT) || ']'::TEXT AS lastmodifiedby
	,to_char(psite_promo_assign.endtime, 'HH24:MI:SS'::TEXT) AS endtime
	,psite_promo_assign.enddate::DATE AS enddate
	,psite_promo_assign.closurecomment AS closure_comment
	,psite_promo_assign.closedon
	,((appuserclosedby.fullname::TEXT || '['::TEXT) || appuserclosedby.empno::TEXT) || ']'::TEXT AS closedby
	,psite_promo_assign.approvedon
	,((appuserapprovedby.fullname::TEXT || '['::TEXT) || appuserapprovedby.empno::TEXT) || ']'::TEXT AS approvedby
	,psite_promo_assign.allocatedon
	,((appuserallocatedby.fullname::TEXT || '['::TEXT) || appuserallocatedby.empno::TEXT) || ']'::TEXT AS allocatedby
	,psite_promo_assign.admsite_code
	,admsite.name AS owner_site
	,psite_promo_assign.activation_type
	,CASE 
		WHEN CURRENT_TIMESTAMP >= to_date((to_char(psite_promo_assign.startdate::DATE::TIMESTAMP WITH TIME zone, 'DD-MM-YYYY'::TEXT) || ' '::TEXT) || coalesce(to_char(psite_promo_assign.starttime, 'HH24:MI:SS'::TEXT), '00:00:00'::TEXT), 'DD-MM-YYYY HH24:MI:SS'::TEXT)
			AND CURRENT_TIMESTAMP <= to_date((to_char(psite_promo_assign.enddate::DATE::TIMESTAMP WITH TIME zone, 'DD-MM-YYYY'::TEXT) || ' '::TEXT) || coalesce(to_char(psite_promo_assign.endtime, 'HH24:MI:SS'::TEXT), '00:00:00'::TEXT), 'DD-MM-YYYY HH24:MI:SS'::TEXT)
			THEN 'ACTIVE'::TEXT
		ELSE 'EXPIRED'::TEXT
		END AS current_state
	,CASE 
		WHEN coalesce(promo_master.is_topup_promo, 0::BIGINT) = 0
			THEN 'No'::TEXT
		ELSE 'Yes'::TEXT
		END AS is_addl_promo
	,CASE 
		WHEN coalesce(promo_master.is_topup_on_all_assrt_item, 0::BIGINT) = 0
			THEN 'No'::TEXT
		ELSE 'Yes'::TEXT
		END AS is_addl_on_all_assrt_item
		,psite_promo_assign.allocatedon allocated_datetime
		,psite_promo_assign.approvedon approved_datetime,
		promo_master.creation_time AS created_on,
        promo_master.modification_time AS modified_on,
        promo_master.creation_time AS created_datetime,
        promo_master.modification_time AS modified_datetime,
        promo_buy.assortment_name
FROM psite_promo_assign
JOIN promo_master ON promo_master.code = psite_promo_assign.promo_code
left join promo_buy on promo_master.code = promo_buy.promo_code and promo_master.buy_assortment_code = promo_buy.assortment_code
LEFT JOIN appuser appuserlastmod ON appuserlastmod.id = psite_promo_assign.lastmodifiedby
LEFT JOIN appuser appuserclosedby ON appuserclosedby.id = psite_promo_assign.closedby
LEFT JOIN appuser appuserapprovedby ON appuserapprovedby.id = psite_promo_assign.approvedby
LEFT JOIN appuser appuserallocatedby ON appuserallocatedby.id = psite_promo_assign.allocatedby
JOIN admsite ON admsite.code = psite_promo_assign.admsite_code
