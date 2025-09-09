SELECT row_number() over () UK
,TYPE
	,glcode
	,glname
	,costcode
	,cost_centre
	,ARP_budget_balance
	,APR_actual_balance
	,(APR_actual_balance - ARP_budget_balance) APR_Variance
	,CASE 
		WHEN ARP_budget_balance = 0
			THEN 0
		ELSE round(((APR_actual_balance - ARP_budget_balance) / ARP_budget_balance) * 100, 2)
		END APR_Variance_PERCENT
	,MAY_budget_balance
	,MAY_actual_balance
	,(MAY_actual_balance - MAY_budget_balance) MAY_Variance
	,CASE 
		WHEN MAY_budget_balance = 0
			THEN 0
		ELSE round(((MAY_actual_balance - MAY_budget_balance) / MAY_budget_balance) * 100, 2)
		END MAY_Variance_PERCENT
	,JUN_budget_balance
	,JUN_actual_balance
	,(JUN_actual_balance - JUN_budget_balance) JUN_Variance
	,CASE 
		WHEN JUN_budget_balance = 0
			THEN 0
		ELSE round(((JUN_actual_balance - JUN_budget_balance) / JUN_budget_balance) * 100, 2)
		END JUN_Variance_PERCENT
	,JUL_budget_balance
	,JUL_actual_balance
	,(JUL_actual_balance - JUL_budget_balance) JUL_Variance
	,CASE 
		WHEN JUL_budget_balance = 0
			THEN 0
		ELSE round(((JUL_actual_balance - JUL_budget_balance) / JUL_budget_balance) * 100, 2)
		END JUL_Variance_PERCENT
	,AUG_budget_balance
	,AUG_actual_balance
	,(AUG_actual_balance - AUG_budget_balance) AUG_Variance
	,CASE 
		WHEN AUG_budget_balance = 0
			THEN 0
		ELSE round(((AUG_actual_balance - AUG_budget_balance) / AUG_budget_balance) * 100, 2)
		END AUG_Variance_PERCENT
	,SEP_budget_balance
	,SEP_actual_balance
	,(SEP_actual_balance - SEP_budget_balance) SEP_Variance
	,CASE 
		WHEN SEP_budget_balance = 0
			THEN 0
		ELSE round(((SEP_actual_balance - SEP_budget_balance) / SEP_budget_balance) * 100, 2)
		END SEP_Variance_PERCENT
	,OCT_budget_balance
	,OCT_actual_balance
	,(OCT_actual_balance - OCT_budget_balance) OCT_Variance
	,CASE 
		WHEN OCT_budget_balance = 0
			THEN 0
		ELSE round(((OCT_actual_balance - OCT_budget_balance) / OCT_budget_balance) * 100, 2)
		END OCT_Variance_PERCENT
	,NOV_budget_balance
	,NOV_actual_balance
	,(NOV_actual_balance - NOV_budget_balance) NOV_Variance
	,CASE 
		WHEN NOV_budget_balance = 0
			THEN 0
		ELSE round(((NOV_actual_balance - NOV_budget_balance) / NOV_budget_balance) * 100, 2)
		END NOV_Variance_PERCENT
	,DEC_budget_balance
	,DEC_actual_balance
	,(DEC_actual_balance - DEC_budget_balance) DEC_Variance
	,CASE 
		WHEN DEC_budget_balance = 0
			THEN 0
		ELSE round(((DEC_actual_balance - DEC_budget_balance) / DEC_budget_balance) * 100, 2)
		END DEC_Variance_PERCENT
	,JAN_budget_balance
	,JAN_actual_balance
	,(JAN_actual_balance - JAN_budget_balance) JAN_Variance
	,CASE 
		WHEN JAN_budget_balance = 0
			THEN 0
		ELSE round(((JAN_actual_balance - JAN_budget_balance) / JAN_budget_balance) * 100, 2)
		END JAN_Variance_PERCENT
	,FEB_budget_balance
	,FEB_actual_balance
	,(FEB_actual_balance - FEB_budget_balance) FEB_Variance
	,CASE 
		WHEN FEB_budget_balance = 0
			THEN 0
		ELSE round(((FEB_actual_balance - FEB_budget_balance) / FEB_budget_balance) * 100, 2)
		END FEB_Variance_PERCENT
	,MAR_budget_balance
	,MAR_actual_balance
	,(MAR_actual_balance - MAR_budget_balance) MAR_Variance
	,CASE 
		WHEN MAR_budget_balance = 0
			THEN 0
		ELSE round(((MAR_actual_balance - MAR_budget_balance) / MAR_budget_balance) * 100, 2)
		END MAR_Variance_PERCENT
FROM (
	SELECT TYPE
		,glcode
		,glname
		,costcode
		,cost_centre
		,0 - SUM(CASE 
				WHEN month_name ilike '%apr%'
					THEN COALESCE(budget_Debit, 0) - COALESCE(budget_Credit, 0)
				ELSE 0
				END) ARP_budget_balance
		,0 - SUM(CASE 
				WHEN month_name ilike '%apr%'
					THEN COALESCE(acc_damount, 0) - COALESCE(acc_camount, 0)
				ELSE 0
				END) APR_actual_balance
		,0 - SUM(CASE 
				WHEN month_name ilike '%may%'
					THEN COALESCE(budget_Debit, 0) - COALESCE(budget_Credit, 0)
				ELSE 0
				END) MAY_budget_balance
		,0 - SUM(CASE 
				WHEN month_name ilike '%may%'
					THEN COALESCE(acc_damount, 0) - COALESCE(acc_camount, 0)
				ELSE 0
				END) MAY_actual_balance
		,0 - SUM(CASE 
				WHEN month_name ilike '%jun%'
					THEN COALESCE(budget_Debit, 0) - COALESCE(budget_Credit, 0)
				ELSE 0
				END) JUN_budget_balance
		,0 - SUM(CASE 
				WHEN month_name ilike '%jun%'
					THEN COALESCE(acc_damount, 0) - COALESCE(acc_camount, 0)
				ELSE 0
				END) JUN_actual_balance
		,0 - SUM(CASE 
				WHEN month_name ilike '%jul%'
					THEN COALESCE(budget_Debit, 0) - COALESCE(budget_Credit, 0)
				ELSE 0
				END) JUL_budget_balance
		,0 - SUM(CASE 
				WHEN month_name ilike '%jul%'
					THEN COALESCE(acc_damount, 0) - COALESCE(acc_camount, 0)
				ELSE 0
				END) JUL_actual_balance
		,0 - SUM(CASE 
				WHEN month_name ilike '%aug%'
					THEN COALESCE(budget_Debit, 0) - COALESCE(budget_Credit, 0)
				ELSE 0
				END) AUG_budget_balance
		,0 - SUM(CASE 
				WHEN month_name ilike '%aug%'
					THEN COALESCE(acc_damount, 0) - COALESCE(acc_camount, 0)
				ELSE 0
				END) AUG_actual_balance
		,0 - SUM(CASE 
				WHEN month_name ilike '%sep%'
					THEN COALESCE(budget_Debit, 0) - COALESCE(budget_Credit, 0)
				ELSE 0
				END) SEP_budget_balance
		,0 - SUM(CASE 
				WHEN month_name ilike '%sep%'
					THEN COALESCE(acc_damount, 0) - COALESCE(acc_camount, 0)
				ELSE 0
				END) SEP_actual_balance
		,0 - SUM(CASE 
				WHEN month_name ilike '%oct%'
					THEN COALESCE(budget_Debit, 0) - COALESCE(budget_Credit, 0)
				ELSE 0
				END) OCT_budget_balance
		,0 - SUM(CASE 
				WHEN month_name ilike '%oct%'
					THEN COALESCE(acc_damount, 0) - COALESCE(acc_camount, 0)
				ELSE 0
				END) OCT_actual_balance
		,0 - SUM(CASE 
				WHEN month_name ilike '%nov%'
					THEN COALESCE(budget_Debit, 0) - COALESCE(budget_Credit, 0)
				ELSE 0
				END) NOV_budget_balance
		,0 - SUM(CASE 
				WHEN month_name ilike '%nov%'
					THEN COALESCE(acc_damount, 0) - COALESCE(acc_camount, 0)
				ELSE 0
				END) NOV_actual_balance
		,0 - SUM(CASE 
				WHEN month_name ilike '%dec%'
					THEN COALESCE(budget_Debit, 0) - COALESCE(budget_Credit, 0)
				ELSE 0
				END) DEC_budget_balance
		,0 - SUM(CASE 
				WHEN month_name ilike '%dec%'
					THEN COALESCE(acc_damount, 0) - COALESCE(acc_camount, 0)
				ELSE 0
				END) DEC_actual_balance
		,0 - SUM(CASE 
				WHEN month_name ilike '%jan%'
					THEN COALESCE(budget_Debit, 0) - COALESCE(budget_Credit, 0)
				ELSE 0
				END) JAN_budget_balance
		,0 - SUM(CASE 
				WHEN month_name ilike '%jan%'
					THEN COALESCE(acc_damount, 0) - COALESCE(acc_camount, 0)
				ELSE 0
				END) JAN_actual_balance
		,0 - SUM(CASE 
				WHEN month_name ilike '%feb%'
					THEN COALESCE(budget_Debit, 0) - COALESCE(budget_Credit, 0)
				ELSE 0
				END) FEB_budget_balance
		,0 - SUM(CASE 
				WHEN month_name ilike '%feb%'
					THEN COALESCE(acc_damount, 0) - COALESCE(acc_camount, 0)
				ELSE 0
				END) FEB_actual_balance
		,0 - SUM(CASE 
				WHEN month_name ilike '%mar%'
					THEN COALESCE(budget_Debit, 0) - COALESCE(budget_Credit, 0)
				ELSE 0
				END) MAR_budget_balance
		,0 - SUM(CASE 
				WHEN month_name ilike '%mar%'
					THEN COALESCE(acc_damount, 0) - COALESCE(acc_camount, 0)
				ELSE 0
				END) MAR_actual_balance
	FROM (
		SELECT CASE 
				WHEN (TYPE = 'I')
					THEN 'Income'
				WHEN (TYPE = 'E')
					THEN 'Expenses'
				END TYPE
			,BUD.GLCODE
			,GLNAME
			,BUD.SLCODE
			,SLNAME
			,COSTCODE
			,ST.name cost_centre
			,BUD.MCODE
			,MONTH_NAME
			,BUDDAMT BUDGET_DEBIT
			,BUDCAMT BUDGET_CREDIT
			,0 ACC_DAMOUNT
			,0 ACC_CAMOUNT
			,GL_SLAPP
			,BUD.COSTAPP
			,YCODE
			,BUD.ADMOU_CODE
		FROM FINGLBUD BUD
		INNER JOIN FINGL GL ON (BUD.GLCODE = GL.GLCODE)
		LEFT OUTER JOIN FINSL SL ON (BUD.SLCODE = SL.SLCODE)
		LEFT OUTER JOIN ADMSITE ST ON (COSTCODE = ST.CODE)
		INNER JOIN ADMMONTH MON ON (BUD.MCODE = MON.MCODE)
		WHERE (BUD.ADMOU_CODE = to_number('@ConnOUCode@','9G999g999999999999d99'))
			AND (YCODE = to_number('@YearCode@','9G999g999999999999d99')) 
		UNION ALL 
		SELECT CASE 
				WHEN TYPE = 'I'
					THEN 'Income'
				WHEN TYPE = 'E'
					THEN 'Expenses'
				END TYPE
			,bud.glcode
			,glname
			,bud.slcode
			,slname
			,CASE 
				WHEN f.ref_admsite_code IS NULL
					THEN st.code
				ELSE a.code
				END costcode
			,CASE 
				WHEN f.ref_admsite_code IS NULL
					THEN st.name
				ELSE a.name
				END cost_centre
			,(
				SELECT mcode
				FROM admmonth
				WHERE bud.ENTDT BETWEEN dtfr
						AND dtto
				) mcode
			,(
				SELECT MONTH_NAME
				FROM admmonth
				WHERE bud.ENTDT BETWEEN dtfr
						AND dtto
				) month_name
			,0 budget_Debit
			,0 budget_Credit
			,bud.DAMOUNT acc_damount
			,bud.camount acc_camount
			,gl.SLAPP
			,gl.COSTAPP
			,bud.YCODE
			,bud.ADMOU_CODE
		FROM finpost bud
		INNER JOIN fingl gl ON bud.glcode = gl.glcode
		LEFT OUTER JOIN finsl sl ON bud.slcode = sl.slcode
		LEFT OUTER JOIN admsite st ON bud.ADMSITE_CODE_OWNER = st.CODE
		INNER JOIN fincosttag f ON bud.postcode = f.postcode
		INNER JOIN admsite a ON a.code = f.ref_admsite_code
		WHERE bud.admou_code = to_number('@ConnOUCode@','9G999g999999999999d99')
			AND bud.ycode = to_number('@YearCode@','9G999g999999999999d99')
			AND gl.TYPE IN ( 'I' ,'E' )
		) X
	GROUP BY TYPE
		,glcode
		,glname
		,costcode
		,cost_centre
		,YCODE
	)