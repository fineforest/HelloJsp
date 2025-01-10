/*-----------------------------------------------------------------
 1 테이블명	: TB_STCD
 2 기능및 설명	: 직위 테이블
 3 관련스토어드	: SP_MAN

	DROP TABLE TB_STCD;
	DROP INDEX IX1_STCD;
	SELECT * FROM	TB_STCD;
------------------------------------------------------------------*/
	CREATE TABLE TB_STCD
	(
		StCd		char(2)			NOT NULL,	-- 직위코드
		StCdName	nvarchar2(30)	NULL		-- 직위명
	);

	CREATE UNIQUE INDEX IX1_STCD ON TB_STCD (StCd);

	TRUNCATE TABLE TB_STCD;
	INSERT	INTO TB_STCD VALUES ('01', '회장');
	INSERT	INTO TB_STCD VALUES ('02', '사장');
	INSERT	INTO TB_STCD VALUES ('03', '부사장');
	INSERT	INTO TB_STCD VALUES ('04', '임원');
	INSERT	INTO TB_STCD VALUES ('05', '부장');
	INSERT	INTO TB_STCD VALUES ('06', '차장');
	INSERT	INTO TB_STCD VALUES ('07', '과장');
	INSERT	INTO TB_STCD VALUES ('08', '대리');
	INSERT	INTO TB_STCD VALUES ('09', '계장');
	INSERT	INTO TB_STCD VALUES ('10', '사원');
