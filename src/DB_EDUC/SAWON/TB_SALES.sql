/*-----------------------------------------------------------------
 1 테이블명	: TB_SALES
 2 기능및 설명	: 판매정보 테이블
 3 관련스토어드	: SP_MAN

	DROP TABLE TB_SALES;
	DROP INDEX IX1_SALES;
	DROP INDEX IX2_SALES;
	DROP INDEX IX3_SALES;
	SELECT * FROM TB_SALES;
------------------------------------------------------------------*/
	CREATE TABLE TB_SALES
	(
		SaleDate	char(8)		NOT NULL,		-- 판매일자
		Sabun		int			NOT NULL,		-- 사원번호
		PCode		char(2)		NOT NULL,		-- 제품코드
		PCount		int		    NULL,			-- 판매수량
		Price		int		    NULL			-- 제품단가
	);

	CREATE INDEX IX1_SALES ON TB_SALES (SaleDate, Sabun, PCode);
	CREATE INDEX IX2_SALES ON TB_SALES (Sabun, PCode);
	CREATE INDEX IX3_SALES ON TB_SALES (PCode);
