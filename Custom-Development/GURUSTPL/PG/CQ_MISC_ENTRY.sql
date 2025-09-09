/*|| Custom Development || Object : CQ_MISC_ENTRY || Ticket Id :  429356 || Developer : Dipankar ||*/
select
    row_number() over() UK,
    row_number() over(
    order by F.MISCCODE) SEQ,
    F.*
from
    (
    select
        M.MISCCODE MISCCODE,
        M.SCHEME_DOCNO MISC_NO,
        MISCDT MISC_DATE,
        M.ADMOU_CODE ADMOU_CODE,
        M.ADMSITE_CODE ADMSITE_CODE,
        M.REMARKS REMARKS,
        CREATION_TIME CREATION_TIME,
        ( (C.FNAME || ' [') || C.ENO) || ']' CREATED_BY,
        M.UDFSTRING01 INVMISCMAIN_UDFSTRING01,
        M.UDFSTRING02 INVMISCMAIN_UDFSTRING02,
        M.UDFSTRING03 INVMISCMAIN_UDFSTRING03,
        M.UDFSTRING04 INVMISCMAIN_UDFSTRING04,
        M.UDFSTRING05 INVMISCMAIN_UDFSTRING05,
        M.UDFSTRING06 INVMISCMAIN_UDFSTRING06,
        M.UDFSTRING07 INVMISCMAIN_UDFSTRING07,
        M.UDFSTRING08 INVMISCMAIN_UDFSTRING08,
        M.UDFSTRING09 INVMISCMAIN_UDFSTRING09,
        M.UDFSTRING10 INVMISCMAIN_UDFSTRING10,
        M.UDFNUM01 INVMISCMAIN_UDFNUM01,
        M.UDFNUM02 INVMISCMAIN_UDFNUM02,
        M.UDFNUM03 INVMISCMAIN_UDFNUM03,
        M.UDFNUM04 INVMISCMAIN_UDFNUM04,
        M.UDFNUM05 INVMISCMAIN_UDFNUM05,
        M.UDFDATE01 INVMISCMAIN_UDFDATE01,
        M.UDFDATE02 INVMISCMAIN_UDFDATE02,
        M.UDFDATE03 INVMISCMAIN_UDFDATE03,
        M.UDFDATE04 INVMISCMAIN_UDFDATE04,
        M.UDFDATE05 INVMISCMAIN_UDFDATE05,
        I.CATEGORY2,
        I.UOM,
        SUM (D.QTY) QUANTITY
    from
        INVMISCMAIN M
    inner join HRDEMP C on
        (CREATION_ECODE = C.ECODE)
    inner join INVMISCDET D on
        M.MISCCODE = D.MISCCODE
    inner join GINVIEW.LV_ITEM I on
        D.ICODE = I.CODE
    where
        D.QTY >= 0
        and (M.MISCCODE in (
        select
            unnest(regexp_matches('@DocumentId@',
            '[^|~|]+',
            'g'))::bigint as col1)
            or coalesce (nullif ('@DocumentId@',
            ''),
            '0')::text = 0::text)
    group by
        M.MISCCODE,
        M.SCHEME_DOCNO,
        MISCDT,
        M.ADMOU_CODE,
        M.ADMSITE_CODE,
        M.REMARKS,
        CREATION_TIME,
        ( (C.FNAME || ' [') || C.ENO) || ']',
        M.UDFSTRING01,
        M.UDFSTRING02,
        M.UDFSTRING03,
        M.UDFSTRING04,
        M.UDFSTRING05,
        M.UDFSTRING06,
        M.UDFSTRING07,
        M.UDFSTRING08,
        M.UDFSTRING09,
        M.UDFSTRING10,
        M.UDFNUM01,
        M.UDFNUM02,
        M.UDFNUM03,
        M.UDFNUM04,
        M.UDFNUM05,
        M.UDFDATE01,
        M.UDFDATE02,
        M.UDFDATE03,
        M.UDFDATE04,
        M.UDFDATE05,
        I.CATEGORY2,
        I.UOM
    order by
        I.CATEGORY2)F