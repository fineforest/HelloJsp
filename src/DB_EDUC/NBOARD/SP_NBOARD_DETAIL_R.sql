/*-----------------------------------------------------------------
    DROP PROCEDURE SP_NBOARD_DETAIL_R;
    
	VAR oCur REFCURSOR;
	EXEC SP_NBOARD_DETAIL_R(10000, 'Current', :oCur);
	PRINT oCur;

	VAR oCur REFCURSOR;
--	EXEC SP_NBOARD_DETAIL_R(10, 'First',   :oCur);
--	EXEC SP_NBOARD_DETAIL_R(10, 'Before',  :oCur);
--	EXEC SP_NBOARD_DETAIL_R(10, 'Current', :oCur);
--	EXEC SP_NBOARD_DETAIL_R(10, 'Next', :oCur);
--	EXEC SP_NBOARD_DETAIL_R(10, 'Last', :oCur);
	PRINT oCur;
  -----------------------------------------------------------------*/
CREATE OR REPLACE PROCEDURE SP_NBOARD_DETAIL_R
(
	iNBoardId		IN	int,				-- 게시글 Id
	iNBoardIdVector	IN	varchar2,			-- 게시글 Id 방향
											-- First, Before, Current, Next, Last
	oCur			OUT	SYS_REFCURSOR		-- 결과 반환용 커서
)
IS
BEGIN
    --------------------------------------------------------
	-- 게시글 상세정보 읽기
	--------------------------------------------------------
	DECLARE	mNBoardIdMin			int;			-- 게시글 Id 최소값
			mNBoardIdMax			int;			-- 게시글 Id 최대값
			mNBoardId				int;			-- 게시글 Id 최종 검색용
			mNBoardIdVectorState	varchar2(10);	-- 게시글 Id 위치상태(First, Last, Middle)
	BEGIN
		--------------------------------------------------------
		-- 게시글 Id 최소값/최대값
		--------------------------------------------------------
		SELECT NVL(MIN(a.NBoardId), 1) INTO mNBoardIdMin FROM TB_NBOARD a;
		SELECT NVL(MAX(a.NBoardId), 1) INTO mNBoardIdMax FROM TB_NBOARD a;
		--------------------------------------------------------
		-- Current 게시글 Id 저장
		--------------------------------------------------------
		mNBoardId := iNBoardId;
		--------------------------------------------------------
		-- 게시글 Id 번호 저장
		--------------------------------------------------------
		IF iNBoardIdVector = 'First' THEN				-- 게시글 Id 처음으로 이동인 경우
			mNBoardId := mNBoardIdMax;
		ELSIF iNBoardIdVector = 'Before' THEN			-- 게시글 Id 이전으로 이동인 경우
			SELECT	NVL(MIN(a.NBoardId), mNBoardIdMax)
			INTO	mNBoardId
			FROM	TB_NBOARD a
			WHERE	a.NBoardId > iNBoardId;
		ELSIF iNBoardIdVector = 'Next' THEN				-- 게시글 Id 다음으로 이동인 경우
			SELECT	NVL(MAX(a.NBoardId), mNBoardIdMin)
			INTO	mNBoardId
			FROM	TB_NBOARD a
			WHERE	a.NBoardId < iNBoardId;
		ELSIF iNBoardIdVector = 'Last' THEN
			mNBoardId := mNBoardIdMin;
		END IF;
		
		IF mNBoardId < mNBoardIdMin THEN
			mNBoardId := mNBoardIdMin;
		ELSIF mNBoardId > mNBoardIdMax THEN
			mNBoardId := mNBoardIdMax;
		END IF;
		--------------------------------------------------------
		-- 게시글 Id 현재 위치상태 파악
		--------------------------------------------------------
		IF mNBoardId = mNBoardIdMax THEN
			mNBoardIdVectorState := 'First';
		ELSIF mNBoardId = mNBoardIdMin THEN
			mNBoardIdVectorState := 'Last';
		ELSE
			mNBoardIdVectorState := 'Middle';
		END IF;
		--------------------------------------------------------
		-- 최종 게시글 상세정보 읽기
		--------------------------------------------------------
		OPEN oCur FOR
		SELECT	a.NBoardId, a.Author, a.Subject,
				a.EMail, a.DateTime, a.AttachYn, a.Content,
				mNBoardIdVectorState AS NBoardIdVectorState
		FROM	TB_NBOARD a
		WHERE	a.NBoardId = mNBoardId;
		
		RETURN;
	END;
    --------------------------------------------------------
END SP_NBOARD_DETAIL_R;
