/*-----------------------------------------------------------------
    DROP PROCEDURE SP_IMG_R;
    
	VAR oCur REFCURSOR;
	EXEC SP_IMG_R(1519, :oCur);
	PRINT oCur;
  -----------------------------------------------------------------*/
CREATE OR REPLACE PROCEDURE SP_IMG_R
(
	iNBoardId       IN  int,			-- 게시물 Id
	oCur			OUT	SYS_REFCURSOR	-- 결과 반환용 커서
)
IS
BEGIN
	--------------------------------------------------------
    OPEN oCur FOR
    SELECT	a.NBoardId, a.FileSeq,
			a.FileNameOrigin, a.FileNameChange,
			a.FileType, a.FileLength, a.FileData
    FROM	TB_IMG a
    WHERE	a.NBoardId = iNBoardId
    ORDER BY a.NBoardId, a.FileSeq;
	--------------------------------------------------------
END SP_IMG_R;
