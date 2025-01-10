/*-----------------------------------------------------------------
    DROP PROCEDURE SP_NBOARD_CUD;
    
	EXEC SP_NBOARD_CUD('INSERT', 1000141, '홍길동', '의적', 'hong@daum.net', 'N', '조선의 의적');
	EXEC SP_NBOARD_CUD('UPDATE', 1, '홍길동', '의적', 'hong@daum.net', 'N', '조선의 의적...');
	EXEC SP_NBOARD_CUD('DELETE', 1);
	
	SELECT * FROM TB_NBOARD;
	DELETE TB_NBOARD;
  -----------------------------------------------------------------*/
CREATE OR REPLACE PROCEDURE SP_NBOARD_CUD
(
	iJopStatus		IN	varchar2,				-- 작업상태
	iNBoardId		IN	int,					-- 게시글 Id
	iAuthor			IN	nvarchar2	:= NULL,	-- 작성자
	iSubject		IN	nvarchar2	:= NULL,	-- 글제목
	iEMail			IN	nvarchar2	:= NULL,	-- E-Mail
    iAttachYn       IN	char     	:= NULL,    -- 첨부파일 유무(Y/N)
	iContent		IN	nclob		:= NULL 	-- 글내용
)
IS
BEGIN
	DECLARE	mDatetime	char(19);
	
	BEGIN
		--------------------------------------------------------
		SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') INTO mDatetime FROM DUAL;
		--------------------------------------------------------
		IF		iJopStatus = 'INSERT' THEN GOTO INSERT_;
		ELSIF	iJopStatus = 'UPDATE' THEN GOTO UPDATE_;
		ELSIF	iJopStatus = 'DELETE' THEN GOTO DELETE_;
		END IF;
	
		RETURN;
		--------------------------------------------------------
<<INSERT_>>
		--SELECT SEQ_IMGFILEID.NEXTVAL INTO mImgFileID FROM DUAL;
		-- VALUES (SEQ_NBoardId.NEXTVAL, iAuthor, iSubject, iEMail, iContent);
	
		INSERT INTO TB_NBOARD
		VALUES (iNBoardId, iAuthor, iSubject, iEMail, mDatetime, iAttachYn, iContent);
	
		RETURN;
		--------------------------------------------------------
<<UPDATE_>>
		UPDATE TB_NBOARD
		SET	Author		= iAuthor,
			Subject		= iSubject,
			EMail		= iEMail,
			Datetime	= mDatetime,
            AttachYn	= iAttachYn,
			Content		= iContent
		WHERE NBoardId	= iNBoardId;
	
		RETURN;
		--------------------------------------------------------
<<DELETE_>>
		DELETE TB_NBOARD
		WHERE NBoardId	= iNBoardId;
	
		RETURN;
		--------------------------------------------------------
	END;
END SP_NBOARD_CUD;
