/*-----------------------------------------------------------------
    DROP PROCEDURE SP_NBOARD_LIST_R;
    
	VAR oCur REFCURSOR;
	EXEC SP_NBOARD_LIST_R(1, 10, 'First',:oCur);
	PRINT oCur;
  -----------------------------------------------------------------*/
CREATE OR REPLACE PROCEDURE SP_NBOARD_LIST_R
(
	iNBoardPageNum	IN	int,				-- 게시판 페이지 번호
	iNBoardPageSize	IN	int,				-- 게시판 페이지 크기
	iNBoardVector	IN	varchar2,			-- 게시판 페이지 번호 방향
											-- First, Before, Current, Next, Last
	oCur			OUT	SYS_REFCURSOR		-- 결과 반환용 커서
)
IS
BEGIN
    --------------------------------------------------------
	-- 게시판 리스트 읽기
	--------------------------------------------------------
	DECLARE	mNBoardRecordCount		int;			-- 게시판 게시글 총 수
			mNBoardPageNumMin		int;			-- 게시판 페이지 번호 최소값
			mNBoardPageNumMax		int;			-- 게시판 페이지 번호 최대값
			mNBoardPageNum			int;			-- 게시판 페이지 번호 최종 검색용
			mNBoardVectorState		varchar2(10);	-- 게시판 페이지 번호 위치상태(First, Last, Middle)
	BEGIN
		--------------------------------------------------------
		-- 게시판 게시글 총 수
		--------------------------------------------------------
		SELECT	COUNT(*) INTO mNBoardRecordCount FROM TB_NBOARD;
		--------------------------------------------------------
		-- 게시판 페이지 번호 최소값/최대값
		--------------------------------------------------------
		IF mNBoardRecordCount = 0 THEN
			mNBoardPageNumMin := 1;
			mNBoardPageNumMax := 1;
		ELSE
			mNBoardPageNumMin := 1;
			mNBoardPageNumMax := CEIL(mNBoardRecordCount / iNBoardPageSize);
		END IF;
		--------------------------------------------------------
		-- 게시판 Current 페이지 번호 저장
		--------------------------------------------------------
		mNBoardPageNum := iNBoardPageNum;
		--------------------------------------------------------
		-- 게시판 페이지 이동 처리
		--------------------------------------------------------
		IF iNBoardVector = 'First' THEN				-- 게시판 페이지 처음으로 이동인 경우
			mNBoardPageNum := mNBoardPageNumMin;
		ELSIF iNBoardVector = 'Before' THEN			-- 게시판 페이지 이전으로 이동인 경우
			mNBoardPageNum := mNBoardPageNum - 1;
		ELSIF iNBoardVector = 'Next' THEN			-- 게시판 페이지 다음으로 이동인 경우
			mNBoardPageNum := mNBoardPageNum + 1;
		ELSIF iNBoardVector = 'Last' THEN			-- 게시판 페이지 마지막으로 이동인 경우
			mNBoardPageNum := mNBoardPageNumMax;
		END IF;
		
		IF mNBoardPageNum < mNBoardPageNumMin THEN
			mNBoardPageNum := mNBoardPageNumMin;
		ELSIF mNBoardPageNum > mNBoardPageNumMax THEN
			mNBoardPageNum := mNBoardPageNumMax;
		END IF;

		--------------------------------------------------------
		-- 게시판 페이지 현재 위치상태 파악
		--------------------------------------------------------
		IF mNBoardPageNum = mNBoardPageNumMin THEN
			mNBoardVectorState := 'First';
		ELSIF mNBoardPageNum = mNBoardPageNumMax THEN
			mNBoardVectorState := 'Last';
		ELSE
			mNBoardVectorState := 'Middle';
		END IF;
		--------------------------------------------------------
		-- 최종 게시판 특정 페이지 읽기
		--------------------------------------------------------
		OPEN oCur FOR
		SELECT	a.No, a.NBoardId, a.Author, a.Subject,
				a.EMail, a.DateTime, a.AttachYn,
				SUBSTR(a.Content, 1, 20) AS Content,
				mNBoardPageNum AS NBoardPageNum,
				mNBoardVectorState AS NBoardVectorState,
				mNBoardPageNumMax AS NBoardPageNumMax
		FROM	(
					SELECT	ROWNUM AS No,
							b.*
					FROM	(
								SELECT	c.*
								FROM	TB_NBOARD c
								ORDER BY c.NBoardId DESC
							) b
					WHERE	ROWNUM <= mNBoardPageNum * iNBoardPageSize
				) a
		WHERE	No > (mNBoardPageNum - 1) * iNBoardPageSize;		
	END;
	
	RETURN;
    --------------------------------------------------------
END SP_NBOARD_LIST_R;



/*		OPEN iCur FOR
		SELECT	a.No, a.NBoardId, a.Author, a.Subject,
				a.EMail, a.DateTime, a.AttachYn,
				SUBSTR(a.Content, 1, 20) AS Content
		FROM	(
					SELECT	ROWNUM AS No, b.*
					FROM	TB_NBOARD b
					WHERE	ROWNUM <= mNBoardPageNum * iNBoardPageSize
					ORDER BY b.NBoardId DESC
				) a
		WHERE	No > (mNBoardPageNum - 1) * iNBoardPageSize;
*/
		



/*
	-- 다음버전(페이지적용)
	OPEN iCur FOR		
	SELECT	a.*
	FROM	(
				SELECT	ROWNUM AS No, b.*
				FROM	TB_NBOARD b
				WHERE	ROWNUM <= iPageNum * 10
				ORDER BY b.NBoardId DESC
			) a
	WHERE	No > (iPageNum - 1) * 10;
*/



/*
	-- 처음버전
    OPEN iCur FOR
	SELECT	ROWNUM AS No, a.*
	FROM   (	SELECT	b.NBoardId, b.Author, b.Subject,
						b.EMail, b.DateTime, b.AttachYn,
						SUBSTR(b.Content, 1, 20) AS Content
				FROM	TB_NBOARD b
				ORDER BY b.NBoardId DESC
			) a;
*/
