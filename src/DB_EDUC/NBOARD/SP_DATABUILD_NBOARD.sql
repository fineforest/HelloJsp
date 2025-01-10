/*-----------------------------------------------------------------
	EXEC SP_BUILDDATA_NBOARD(100000);
	SELECT * FROM TB_NBOARD;
------------------------------------------------------------------*/
CREATE OR REPLACE PROCEDURE SP_BUILDDATA_NBOARD
(
	iCount		IN NUMBER		-- 레코드수
)
IS
BEGIN
	DECLARE
		mKey		int;
		mNBoardId	int;				-- 게시글 Id
		mAuthor		nvarchar2(100);		-- 작성자
		mSubject	nvarchar2(100);		-- 글제목
		mEMail		nvarchar2(100);		-- E-Mail
		mDateTime	varchar2(20);		-- 등록일(년/월/일 시:분:초)
		mAttachYn   char(1);       		-- 첨부파일 유무(Y/N)
		mContent	nclob;				-- 글내용

	BEGIN
		mKey		:= 1;
		
		DELETE	TB_IMG;
		DELETE  TB_NBOARD;

		WHILE mKey <= iCount
		LOOP
			mNBoardId	:= SEQ_NBoardId.NEXTVAL;
			mAuthor		:= '작성자 - ' || mKey;
			mSubject	:= '글제목 - ' || mKey;
			mEMail		:= 'E-Mail' || mKey || '@hello.com';
			mDatetime	:= TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS');
			mAttachYn	:= 'N';
			mContent	:= '이거슨 예시 글내용 입니다 - ' || mKey || chr(13) || chr(10);

			INSERT INTO TB_NBOARD
			VALUES (mNBoardId, mAuthor, mSubject, mEMail, mDatetime, mAttachYn,
					'1> ' || mContent ||
					'2> ' || mContent ||
					'3> ' || mContent ||
					'4> ' || mContent ||
					'5> ' || mContent);

			mKey := mKey + 1;
		END LOOP;
	END;
END SP_BUILDDATA_NBOARD;
