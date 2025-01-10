/*-----------------------------------------------------------------
	EXEC SP_BUILDDATA_MAN(1000);
	SELECT * FROM TB_MAN;
------------------------------------------------------------------*/
CREATE OR REPLACE PROCEDURE SP_BUILDDATA_MAN
(
	iCount		IN NUMBER		-- 레코드수
)
IS
BEGIN
	DECLARE
		mKey		int;
		mSabun		int;
		mName		nvarchar2(20);
		mAge		int;
		mGender		char(1);
		mTel		varchar2(14);
		mDept		char(2);
		mStCd		char(2);
		mBDate		char(10);
		mAddress	nvarchar2(60);

	BEGIN
		mKey := 1;

		DELETE  TB_MAN;

		WHILE mKey <= iCount
		LOOP
			mSabun	:= mKey;
			mName	:= '성명' || mKey;
			mAge	:= ROUND(DBMS_RANDOM.VALUE(18, 50), 0);
			mGender	:= TO_CHAR(ROUND(DBMS_RANDOM.VALUE(0, 1), 0));
			mTel	:= '010-' || ROUND(DBMS_RANDOM.VALUE(1111, 9999), 0) || '-' || ROUND(DBMS_RANDOM.VALUE(1111, 9999), 0);
			mDept	:= LPAD(ROUND(DBMS_RANDOM.VALUE(1, 7), 0), 2, '0');
			mStCd	:= LPAD(ROUND(DBMS_RANDOM.VALUE(1, 10), 0), 2, '0');
			mBDate	:= TO_CHAR(ADD_MONTHS(ADD_MONTHS(SYSDATE, mAge*12*-1), 12), 'YYYY') || '/' ||
						LPAD(ROUND(DBMS_RANDOM.VALUE(1, 12), 0), 2, '0') || '/' ||
						LPAD(ROUND(DBMS_RANDOM.VALUE(1, 28), 0), 2, '0');
			mAddress := '주소' || mKey;

			INSERT INTO TB_MAN
			VALUES (mSabun, mName, mAge, mGender, mTel, mDept, mStCd, mBDate, mAddress);

			mKey := mKey + 1;
		END LOOP;
	END;
END SP_BUILDDATA_MAN;
