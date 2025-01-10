/*-----------------------------------------------------------------
	VAR oCur REFCURSOR;
	EXEC SP_MAN_R(1001, '-1', 0, '-1', '-1', :oCur);
	EXEC SP_MAN_R(0, '유관순', 0, '-1', '-1', :oCur);
	EXEC SP_MAN_R(0, '-1', 20, '1', '-1', :oCur);
	EXEC SP_MAN_R(0, '-1', 20, '0', '-1', :oCur);
	EXEC SP_MAN_R(0, '-1', 20, '1', '01', :oCur);
	PRINT oCur;
------------------------------------------------------------------*/
CREATE OR REPLACE PROCEDURE SP_MAN_R
(
	iSabun		IN	int,			-- 사번
	iName		IN	nvarchar2,		-- 성명
	iAge		IN	int,			-- 나이
	iGender		IN	char,			-- 성별
	iDept		IN	char,			-- 부서코드
	oCur		OUT	SYS_REFCURSOR	-- 결과 반환용 커서
)
IS
BEGIN
	DECLARE
		mName	nvarchar2(20);

	BEGIN
		mName := '%' || iName || '%';

		OPEN oCur FOR
		SELECT	a.Sabun, a.Name, a.Age, a.Gender, a.Tel, 
				a.Dept,
				(SELECT b.DeptName FROM TB_DEPT b WHERE b.Dept = a.Dept) AS DeptName,
				a.StCd,
				(SELECT b.StCdName FROM TB_STCD b WHERE b.StCd = a.StCd) AS StCdName,
				a.BDate, a.Address
		FROM	TB_MAN a
		WHERE	(iSabun	= 0		OR a.Sabun	= iSabun)	AND
				(iName	= '-1'	OR a.Name	LIKE mName)	AND
				(iAge	= 0		OR a.Age	= iAge)		AND
				(iGender= '-1'	OR a.Gender	= iGender)	AND
				(iDept	= '-1'	OR a.Dept	= iDept)
		ORDER BY a.Sabun;
	END;
END SP_MAN_R;
