/*-----------------------------------------------------------------
 	DROP SEQUENCE SEQ_NBOARDID;
	DROP TABLE TB_NBOARD;
	DROP INDEX IX1_NBOARD;
	
	SELECT * FROM TB_NBOARD;
	
	DELETE TB_NBOARD;
------------------------------------------------------------------*/
CREATE TABLE TB_NBOARD
(
	NBoardId	int					NOT NULL,	-- 게시글 Id
	Author		nvarchar2(100)		NULL,		-- 작성자
	Subject		nvarchar2(100)		NULL,		-- 글제목
	EMail		nvarchar2(100)		NULL,		-- E-Mail
	DateTime	varchar2(20)		NULL,		-- 등록일(년/월/일 시:분:초)
	AttachYn    char(1)				NULL,       -- 첨부파일 유무(Y/N)
	Content		nclob				NULL		-- 글내용
);

CREATE UNIQUE INDEX IX1_NBOARD ON TB_NBOARD (NBoardId);

CREATE SEQUENCE SEQ_NBOARDID INCREMENT BY 1 START WITH 1;
