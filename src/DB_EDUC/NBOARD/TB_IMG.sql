/*-----------------------------------------------------------------
 	DROP TABLE TB_IMG;
	DROP INDEX IX1_IMG;
	
	SELECT * FROM TB_IMG;
	
	DELETE TB_IMG;
------------------------------------------------------------------*/
CREATE TABLE TB_IMG
(
	NBoardId        	int				NOT NULL,	-- 게시글 Id
	FileSeq				int				NOT NULL,	-- 첨부파일(이미지) Seq
	FileNameOrigin		nvarchar2(100)	NULL,		-- 첨부파일(이미지) 원래이름
	FileNameChange		nvarchar2(100)	NULL,		-- 첨부파일(이미지) 바뀐이름(중복방지)
	FileType			nvarchar2(100)	NULL,		-- 첨부파일(이미지) 타입
	FileLength			int				NULL,		-- 첨부파일(이미지) 길이
	FileData			blob			NULL		-- 첨부파일(이미지) 데이터
);

CREATE UNIQUE INDEX IX1_IMG ON TB_IMG (NBoardId, FileSeq);
