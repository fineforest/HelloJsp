/*-----------------------------------------------------------------
    DROP PROCEDURE SP_IMG_CUD;

	EXEC SP_IMG_CUD('INSERT', 1, 1, '토토로', '토토로1', 'image', 0, null);
	EXEC SP_IMG_CUD('UPDATE', 2, 1, '토토로11', '토토로111', 'image', 0, null);
	EXEC SP_IMG_CUD('DELETE', 2, 1);
	
	SELECT * FROM TB_IMG;
	DELETE TB_IMG;
  -----------------------------------------------------------------*/
CREATE OR REPLACE PROCEDURE SP_IMG_CUD
(
	iJopStatus			IN	varchar2,				-- 작업상태
	iNBoardId        	IN  int,					-- 게시물 Id
	iFileSeq			IN	int,					-- 첨부파일(이미지) Seq
	iFileNameOrigin		IN	varchar2	:= NULL,	-- 첨부파일(이미지) 원래이름
	iFileNameChange		IN	varchar2	:= NULL,	-- 첨부파일(이미지) 바뀐이름(중복방지)
	iFileType			IN	varchar2	:= NULL,	-- 첨부파일(이미지) 타입
	iFileLength			IN	int			:= 0,		-- 첨부파일(이미지) 길이
	iFileData			IN	blob		:= NULL		-- 첨부파일(이미지) 데이터
)
IS
BEGIN
	--------------------------------------------------------
	IF		iJopStatus = 'INSERT' THEN GOTO INSERT_;
	ELSIF	iJopStatus = 'UPDATE' THEN GOTO UPDATE_;
	ELSIF	iJopStatus = 'DELETE' THEN GOTO DELETE_;
	END IF;

	RETURN;
	--------------------------------------------------------
<<INSERT_>>
	INSERT INTO TB_IMG
	VALUES (iNBoardId, iFileSeq,
			iFileNameOrigin, iFileNameChange,
			iFileType, iFileLength, iFileData);

	RETURN;
	--------------------------------------------------------
<<UPDATE_>>
	DECLARE	ExistsNum int;
	
	BEGIN
		SELECT CASE WHEN EXISTS(SELECT 1 FROM TB_IMG WHERE NBoardId = iNBoardId)
					THEN 1 ELSE 0 END 
		INTO ExistsNum
		FROM DUAL;
		
		IF ExistsNum = 0 THEN
			GOTO INSERT_;
		ELSE
			UPDATE	TB_IMG
			SET		FileNameOrigin	= iFileNameOrigin,
					FileNameChange	= iFileNameChange,
					FileType		= iFileType,
					FileLength		= iFileLength,
					FileData		= iFileData
			WHERE	NBoardId		= iNBoardId		AND
					FileSeq			= iFileSeq;
			RETURN;
		END IF;
	END;
	--------------------------------------------------------
<<DELETE_>>
	DELETE	TB_IMG
	WHERE	NBoardId	= iNBoardId		AND
			FileSeq		= iFileSeq;

	RETURN;
	--------------------------------------------------------
END SP_IMG_CUD;
