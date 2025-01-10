/*-----------------------------------------------------------------
	EXEC SP_BUILDDATA_SALES(1000, 200000);
	SELECT COUNT(*) FROM TB_SALES ORDER BY SaleDate DESC;
------------------------------------------------------------------*/
CREATE OR REPLACE PROCEDURE SP_BUILDDATA_SALES
(
	iManCount	IN NUMBER,		-- 생성할 사원 레코드수
	iSalesCount	IN NUMBER		-- 생성할 판매 레코드수
)
IS
BEGIN
	DECLARE
		mKey		int;
		mSabun		int;
		mYY			char(4);
		mCurYY		char(4);
		mMM			char(2);
		mDD			char(2);
		mPCode		char(2);
		mPCount		int;

	BEGIN
		mKey := 1;

		DELETE TB_SALES;

		WHILE mKey <= iSalesCount
		LOOP
			mSabun   := ROUND(DBMS_RANDOM.VALUE(1, iManCount), 0);
			SELECT TO_CHAR(SYSDATE, 'YYYY') INTO mCurYY FROM DUAL;
			mYY      := TO_CHAR(ROUND(DBMS_RANDOM.VALUE(2005, mCurYY), 0));
			mMM      := LPAD(ROUND(DBMS_RANDOM.VALUE(1, 12), 0), 2, '0');
			mDD      := LPAD(ROUND(DBMS_RANDOM.VALUE(1, 28), 0), 2, '0');
			mPCode   := LPAD(ROUND(DBMS_RANDOM.VALUE(1, 10), 0), 2, '0');
			mPCount  := ROUND(DBMS_RANDOM.VALUE(1, 50), 0);

			INSERT	INTO TB_SALES
			VALUES (mYY || mMM || mDD, mSabun, mPCode, mPCount, mPCount * 1000);

			mKey := mKey + 1;
		END LOOP;
	END;
END SP_BUILDDATA_SALES;
