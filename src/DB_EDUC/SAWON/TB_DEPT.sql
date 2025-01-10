/*-----------------------------------------------------------------
 1 테이블명	: TB_DEPT
 2 기능및 설명	: 부서코드 테이블
 3 관련스토어드	: SP_MAN

	DROP TABLE TB_DEPT;
	DROP INDEX IX1_DEPT;
	SELECT * FROM TB_DEPT;
------------------------------------------------------------------*/
	CREATE TABLE TB_DEPT
	(
		Dept		char(2)			NOT NULL,	-- 부서코드
		DeptName	nvarchar2(30)		NULL	-- 부서명
	);

	CREATE UNIQUE INDEX IX1_DEPT ON TB_DEPT (Dept);

	TRUNCATE TABLE TB_DEPT;
	INSERT	INTO TB_DEPT VALUES ('01', '영업부');
	INSERT	INTO TB_DEPT VALUES ('02', '회계부');
	INSERT	INTO TB_DEPT VALUES ('03', '구매부');
	INSERT	INTO TB_DEPT VALUES ('04', '자재부');
	INSERT	INTO TB_DEPT VALUES ('05', '총무부');
	INSERT	INTO TB_DEPT VALUES ('06', '생산부');
	INSERT	INTO TB_DEPT VALUES ('07', '원가부');
