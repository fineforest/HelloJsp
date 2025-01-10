/*-----------------------------------------------------------------
	EXEC SP_MAN_CUD('INSERT', 1001, '홍길동', 20, '1', '01');
	EXEC SP_MAN_CUD('UPDATE', 1001, '유관순', 18, '0', '03');
	EXEC SP_MAN_CUD('DELETE', 1001, '', 0, '', '');
	SELECT * FROM TB_MAN ORDER BY Sabun DESC;
------------------------------------------------------------------*/
CREATE OR REPLACE PROCEDURE SP_MAN_CUD
(
	iJopStatus	IN	varchar2,		-- 작업상태
	iSabun		IN	int,			-- 사원번호
	iName		IN	nvarchar2,		-- 사원명
	iAge		IN	int,			-- 나이
	iGender		IN	char,			-- 성별(1:M. 0:W)
    iTel        IN  char,			-- 전화
	iDept		IN	char,			-- 부서코드('01'~'07')
    iStCd       IN  char,			-- 직급
    iBDate      IN  char,			-- 생일
    iAddress    IN  nvarchar2		-- 주소
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
	INSERT INTO TB_MAN
	VALUES (iSabun, iName, iAge, iGender, iTel,
            iDept, iStCd, iBDate, iAddress);

	RETURN;
	--------------------------------------------------------
<<UPDATE_>>
	UPDATE TB_MAN
	SET	Name	= iName,
		Age		= iAge,
		Gender	= iGender,
		Tel		= iTel,
		Dept	= iDept,
		StCd	= iStCd,
		BDate	= iBDate,
		Address	= iAddress
	WHERE Sabun	= iSabun;

	RETURN;
	--------------------------------------------------------
<<DELETE_>>
	DELETE TB_MAN
	WHERE Sabun	= iSabun;

	RETURN;
END SP_MAN_CUD;
