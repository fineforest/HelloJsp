/*-----------------------------------------------------------------
 1 테이블명	: TB_MAN
 2 기능및 설명	: 사원정보 테이블
 3 관련스토어드	: SP_MAN

	DROP TABLE TB_MAN;
	DROP INDEX IX1_MAN;
	SELECT * FROM TB_MAN;
------------------------------------------------------------------*/
	CREATE TABLE TB_MAN
	(
		Sabun		int				NOT NULL,	-- 사번
		Name		nvarchar2(20)	NULL,		-- 성명
		Age			int				NULL,		-- 나이
		Gender		char(1)			NULL,		-- 성별(0:여자/1:남자)
		Tel			varchar2(14)	NULL,		-- 전화
		Dept		char(2)			NULL,		-- 부서코드(1~7)
		StCd		char(2)			NULL,		-- 직위(1~10)
		BDate		char(10)		NULL,		-- 생일
		Address		nvarchar2(60)	NULL		-- 주소
	);

	CREATE UNIQUE INDEX IX1_MAN ON TB_MAN (Sabun);
