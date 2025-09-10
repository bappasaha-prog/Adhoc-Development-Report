/* Formatted on 01-08-2022 15:50:19 (QP5 v5.294) */
/*Header*/
SELECT M.STFCODE                       STFCODE,
       M.STFDT                         Transfer_Date,
       M.DOCNO                         Document_No,
       M.DOCDT                         Document_Date,
       M.INLOCCODE                     INLOCCODE,
       INSTK.LOCNAME                   IN_StockPoint_Name,
       INSTK.LOCTYPE                   IN_STOCKPOINT_TYPE,
       JB.CODE                         IN_STOCKPOINT_JOBBER_CODE,
       M.OUTLOCCODE,
       OUTSTK.LOCNAME                  OUT_StockPoint_Name,
       OUTSTK.LOCTYPE                  OUT_STOCKPOINT_TYPE,
       JBO.CODE                        OUT_STOCKPOINT_JOBBER_CODE,
       M.GENO                          Gate_Entry_No,
       M.REM                           Remarks,
       Y.YNAME                         Year_Name,
       C.FNAME || ' [' || C.ENO || ']' Created_By,
       M.TIME                          Creation_Time,
       M.LAST_ACCESS_TIME              Last_Modified_On,
       CASE
          WHEN MD.FNAME IS NOT NULL THEN MD.FNAME || ' [' || MD.ENO || ']'
          ELSE NULL
       END
          Last_Modified_By,
       M.SLCODE                        SLCODE,
       SL.SLNAME                       SLNAME,
       M.INLGTCODE                     INLGTCODE,
       INLGT.LGTNO                     IN_Logistic_No,
       INLGT.LGTDT                     IN_Logistic_Date,
       INLGTTRP.SLNAME                 IN_Logistic_Transporter,
       INLGT.DOCNO                     IN_Logistic_Document_No,
       INLGT.DOCDT                     IN_Logistic_Document_Date,
       INLGT.STFR                      IN_Logistic_Station_From,
       INLGT.STTO                      IN_Logistic_Station_To,
       INLGT.DECAMT                    IN_Logistic_Declared_Amount,
       M.OUTLGTCODE                    OUTLGTCODE,
       OUTLGT.LGTNO                    OUT_Logistic_No,
       OUTLGT.LGTDT                    OUT_Logistic_Date,
       OUTLGTTRP.SLNAME                OUT_Logistic_Transporter,
       OUTLGT.DOCNO                    OUT_Logistic_Document_No,
       OUTLGT.DOCDT                    OUT_Logistic_Document_Date,
       OUTLGT.STFR                     OUT_Logistic_Station_From,
       OUTLGT.STTO                     OUT_Logistic_Station_To,
       OUTLGT.DECAMT                   OUT_Logistic_Declared_Amount,
       M.DOCCODE                       Document_Code,
       M.SCHEME_DOCNO                  Transfer_No,
       M.ADMOU_CODE                    ADMOU_CODE,
       INITCAP (M.PRICETYPE)           Price_Type,
       M.PRICE_FACTOR                  Price_Factor,
       INITCAP (M.STFTYPE)             Stock_Transfer_Type,
       M.ADMOU_CODE_IN                 ADMOU_CODE_IN,
       M.ADMSITE_CODE                  ADMSITE_CODE,
       ST.SHRTNAME                     Owner_Site,
       M.EWAYBILLNO                    E_way_Bill_No,
       M.EWAYBILLGENERATEDON           E_way_Bill_Generated_On,
       M.EWAYBILLVALIDUPTO             E_way_Bill_Valid_Upto,
       INITCAP (INSTK.LOCTYPE)         Inter_Stockpoint_Transfer,
       --START FEATURE 115732
       M.UDFSTRING01                   INVSTFMAIN_UDFSTRING01,
       M.UDFSTRING02                   INVSTFMAIN_UDFSTRING02,
       M.UDFSTRING03                   INVSTFMAIN_UDFSTRING03,
       M.UDFSTRING04                   INVSTFMAIN_UDFSTRING04,
       M.UDFSTRING05                   INVSTFMAIN_UDFSTRING05,
       M.UDFSTRING06                   INVSTFMAIN_UDFSTRING06,
       M.UDFSTRING07                   INVSTFMAIN_UDFSTRING07,
       M.UDFSTRING08                   INVSTFMAIN_UDFSTRING08,
       M.UDFSTRING09                   INVSTFMAIN_UDFSTRING09,
       M.UDFSTRING10                   INVSTFMAIN_UDFSTRING10,
       M.UDFNUM01                      INVSTFMAIN_UDFNUM01,
       M.UDFNUM02                      INVSTFMAIN_UDFNUM02,
       M.UDFNUM03                      INVSTFMAIN_UDFNUM03,
       M.UDFNUM04                      INVSTFMAIN_UDFNUM04,
       M.UDFNUM05                      INVSTFMAIN_UDFNUM05,
       M.UDFDATE01                     INVSTFMAIN_UDFDATE01,
       M.UDFDATE02                     INVSTFMAIN_UDFDATE02,
       M.UDFDATE03                     INVSTFMAIN_UDFDATE03,
       M.UDFDATE04                     INVSTFMAIN_UDFDATE04,
       M.UDFDATE05                     INVSTFMAIN_UDFDATE05
  --END FEATURE 115732
  FROM ginssot.DIM$INVSTFMAIN M,
       ginssot.DIM$FINSL      SL,
       ginssot.DIM$INVLOC     INSTK,
       ginssot.DIM$INVLOC     OUTSTK,
       ginssot.DIM$ADMYEAR    Y,
       ginssot.DIM$HRDEMP     C,
       ginssot.DIM$HRDEMP     MD,
       ginssot.DIM$INVLGTNOTE INLGT,
       ginssot.DIM$FINSL      INLGTTRP,
       ginssot.DIM$INVLGTNOTE OUTLGT,
       ginssot.DIM$FINSL      OUTLGTTRP,
       ginssot.DIM$ADMSITE    ST,
       (SELECT DISTINCT T3.CODE, T1.LOCCODE
          FROM ginssot.DIM$FINSL_LOCCODE T1,
               ginssot.DIM$FINSL_OU      T2,
               ginview.LV_JOBBER         T3,
               ginssot.DIM$INVLOC        T4
         WHERE T1.FINSL_OU_CODE = T2.CODE AND T2.SLCODE = T3.CODE) JB,
       (SELECT DISTINCT T3.CODE, T1.LOCCODE
          FROM ginssot.DIM$FINSL_LOCCODE T1,
               ginssot.DIM$FINSL_OU      T2,
               ginview.LV_JOBBER         T3,
               ginssot.DIM$INVLOC        T4
         WHERE T1.FINSL_OU_CODE = T2.CODE AND T2.SLCODE = T3.CODE) JBO
 WHERE     M.SLCODE = SL.SLCODE(+)
       AND M.INLOCCODE = INSTK.LOCCODE
       AND M.OUTLOCCODE = OUTSTK.LOCCODE
       AND M.YCODE = Y.YCODE
       AND M.ECODE = C.ECODE
       AND M.LAST_ACCESS_ECODE = MD.ECODE(+)
       AND M.INLGTCODE = INLGT.LGTCODE(+)
       AND INLGT.TRPCODE = INLGTTRP.SLCODE(+)
       AND M.OUTLGTCODE = OUTLGT.LGTCODE(+)
       AND OUTLGT.TRPCODE = OUTLGTTRP.SLCODE(+)
       AND M.ADMSITE_CODE = ST.CODE
       AND M.INLOCCODE = JB.LOCCODE(+)
       AND M.OUTLOCCODE = JBO.LOCCODE(+)