/*-----------------------------------------------------------------
 1 테이블명	: TB_PROD
 2 기능및 설명	: 제품코드 테이블
 3 관련스토어드	: SP_MAN

	DROP TABLE TB_PROD;
	DROP INDEX IX1_PROD;
	SELECT * FROM TB_PROD;
------------------------------------------------------------------*/
	CREATE TABLE TB_PROD
	(
		PCode 		char(2)			NOT NULL,	-- 제품코드
		ProdName	nvarchar2(30)	NULL		-- 제품명
	);

	CREATE UNIQUE INDEX IX1_PROD ON TB_PROD (PCode);

	TRUNCATE TABLE TB_PROD;
	INSERT	INTO TB_PROD VALUES ('01', '컴퓨터');
	INSERT	INTO TB_PROD VALUES ('02', '오디오');
	INSERT	INTO TB_PROD VALUES ('03', '자동차');
	INSERT	INTO TB_PROD VALUES ('04', '핸드폰');
	INSERT	INTO TB_PROD VALUES ('05', 'PDA폰');
	INSERT	INTO TB_PROD VALUES ('06', '아파트');
	INSERT	INTO TB_PROD VALUES ('07', '운동화');
	INSERT	INTO TB_PROD VALUES ('08', '세탁기');
	INSERT	INTO TB_PROD VALUES ('09', '냉장고');
	INSERT	INTO TB_PROD VALUES ('10', '프린터');
