// #################################################################################################
// NBoardDAO.java - 게시판 DAO 모듈
// #################################################################################################
// ═════════════════════════════════════════════════════════════════════════════════════════
// 외부모듈 영역
// ═════════════════════════════════════════════════════════════════════════════════════════
package BeansHome.NBoard;

import java.sql.Types;

import Common.ExceptionMgr;

// ═════════════════════════════════════════════════════════════════════════════════════════
// 사용자정의 클래스 영역
// ═════════════════════════════════════════════════════════════════════════════════════════
/***********************************************************************
 * NBoardDTO	: 게시판 DTO 클래스<br>
 * Inheritance	: None | 부모 클래스 명
 ***********************************************************************/
public class NBoardDAO
{
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역상수 관리 - 필수영역
	// —————————————————————————————————————————————————————————————————————————————————————
	
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역변수 관리 - 필수영역(정적변수)
	// —————————————————————————————————————————————————————————————————————————————————————
    
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역변수 관리 - 필수영역(인스턴스변수)
	// —————————————————————————————————————————————————————————————————————————————————————
	/** DBMgr : 오라클 데이터베이스 DAO 객체 선언 */
	public DAO.DBOracleMgr DBMgr = null;
	// —————————————————————————————————————————————————————————————————————————————————————
    // 생성자 관리 - 필수영역(인스턴스함수)
	// —————————————————————————————————————————————————————————————————————————————————————
	/***********************************************************************
	 * NBoardDAO()	: 생성자
	 * @param void	: None
	 ***********************************************************************/
	public NBoardDAO()
	{
		try
		{
			// -----------------------------------------------------------------------------
			// 초기화 작업 관리
			// -----------------------------------------------------------------------------
			ExceptionMgr.SetMode(ExceptionMgr.RUN_MODE.DEBUG);
			
			this.DBMgr = new DAO.DBOracleMgr();								// DAO 객체 생성
			this.DBMgr.SetConnectionStringFromProperties("db.properties");	// DB 연결문자열 읽기 
			
			//this.DBMgr.SetConnectionString("172.30.1.44", 1521, "educ", "educ", "XE");	// My
			//this.DBMgr.SetConnectionString("192.168.0.100", 1521, "educ", "educ", "XE");	// My
			//this.DBMgr.SetConnectionString("172.24.210.162", 1521, "educ", "educ", "XE");	// 301
			//this.DBMgr.SetConnectionString("172.24.162.45", 1521, "educ", "educ", "XE");	// 306
			// -----------------------------------------------------------------------------
		}
		catch (Exception Ex)
		{
			ExceptionMgr.DisplayException(Ex);		// 예외처리(콘솔)
		}
    }
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역함수 관리 - 필수영역(정적함수)
	// —————————————————————————————————————————————————————————————————————————————————————
	
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역함수 관리 - 필수영역(인스턴스함수)
	// —————————————————————————————————————————————————————————————————————————————————————
	/***********************************************************************
	 * ReadBoardList()			: 오라클 데이터베이스에서 게시판 목록 읽기
	 * @param NBoardPageNum		: 게시판 페이지 번호
	 * @param NBoardPageSize	: 게시판 페이지 크기
	 * @param NBoardVector		: 게시판 페이지 번호 방향 - First, Before, Current, Next, Last
	 * @return boolean			: true | false
	 ***********************************************************************/
	public boolean ReadBoardList(int NBoardPageNum, int NBoardPageSize, String NBoardVector)
	{
		String sSql = null;						// DML 문장
		Object[] oPaValue = null;				// DML 문장에 필요한 파라미터 객체
		boolean bResult = false;
		
		try
		{
	    	// -----------------------------------------------------------------------------
			// 사원정보 읽기
	    	// -----------------------------------------------------------------------------
			if (this.DBMgr.DbConnect() == true)
			{
				// 게시판 읽기
				sSql = "BEGIN SP_NBOARD_LIST_R(?,?,?,?); END;";
				
				// IN 파라미터 만큼만 할당
				oPaValue = new Object[3];
				
				oPaValue[0] = NBoardPageNum;	// 게시판 페이지 번호
				oPaValue[1] = NBoardPageSize;	// 게시판 페이지 크기
				oPaValue[2] = NBoardVector;		// 게시판 페이지 번호 방향(First, Before, Current, Next, Last)
				
				if (this.DBMgr.RunQuery(sSql, oPaValue, 4, true) == true)
				{
					bResult = true;
				}
			}
	    	// -----------------------------------------------------------------------------
		}
		catch (Exception Ex)
		{
			Common.ExceptionMgr.DisplayException(Ex);		// 예외처리(콘솔)
		}
		
		return bResult;
	}
	/***********************************************************************
	 * ReadBoardDetail()		: 오라클 데이터베이스에서 게시글 상세정보 읽기
	 * @param NBoardId			: 게시글 Id
	 * @param NBoardIdVector	: 게시글 Id 방향 - First, Before, Current, Next, Last
	 * @return boolean			: true | false
	 ***********************************************************************/
	public boolean ReadBoardDetail(int NBoardId, String NBoardIdVector)
	{
		String sSql = null;						// DML 문장
		Object[] oPaValue = null;				// DML 문장에 필요한 파라미터 객체
		boolean bResult = false;
		
		try
		{
	    	// -----------------------------------------------------------------------------
			// 사원정보 읽기
	    	// -----------------------------------------------------------------------------
			if (this.DBMgr.DbConnect() == true)
			{
				// 게시판 읽기
				sSql = "BEGIN SP_NBOARD_DETAIL_R(?,?,?); END;";
				
				// IN 파라미터 만큼만 할당
				oPaValue = new Object[2];
				
				oPaValue[0] = NBoardId;			// 게시글 Id
				oPaValue[1] = NBoardIdVector;	// 게시글 Id 방향(First, Before, Current, Next, Last)
				
				if (this.DBMgr.RunQuery(sSql, oPaValue, 3, true) == true)
				{
					bResult = true;
				}
			}
	    	// -----------------------------------------------------------------------------
		}
		catch (Exception Ex)
		{
			Common.ExceptionMgr.DisplayException(Ex);		// 예외처리(콘솔)
		}
		
		return bResult;
	}
	/***********************************************************************
	 * ReadBoardDetailFileData()	: 오라클 데이터베이스에서 게시글 첨부파일(이미지) 데이터 읽기
	 * @param NBoardId				: 게시글 Id
	 * @return boolean				: true | false
	 ***********************************************************************/
	public boolean ReadBoardDetailFileData(int NBoardId)
	{
		String sSql = null;						// DML 문장
		Object[] oPaValue = null;				// DML 문장에 필요한 파라미터 객체
		boolean bResult = false;
		
		try
		{
	    	// -----------------------------------------------------------------------------
			// 게시글 첨부파일(이미지) 데이터 읽기
	    	// -----------------------------------------------------------------------------
			if (this.DBMgr.DbConnect() == true)
			{
				// 게시글 첨부파일(이미지) 읽기
				sSql = "BEGIN SP_IMG_R(?, ?); END;";
				
				// IN 파라미터 만큼만 할당
				oPaValue = new Object[1];
				
				oPaValue[0] = NBoardId;
				
				if (this.DBMgr.RunQuery(sSql, oPaValue, 2, true) == true)
				{
					bResult = true;
				}
			}
	    	// -----------------------------------------------------------------------------
		}
		catch (Exception Ex)
		{
			Common.ExceptionMgr.DisplayException(Ex);		// 예외처리(콘솔)
		}
		
		return bResult;
	}
	/***********************************************************************
	 * NBoardSave()		: 게시글을 오라클 데이터베이스에 저장
	 * @param JopStatus	: 게시판 작업 상태(Insert|Update|Delete)
	 * @param NBoardId	: 게시글 Id
	 * @param NBoardDTO	: 게시판 DTO 객체
	 * @return boolean	: true | false
	 ***********************************************************************/
	public boolean NBoardSave(String JopStatus, int NBoardId, NBoardDTO nboardDTO)
	{
		boolean bResult = false;
		
		try
		{
	    	// -----------------------------------------------------------------------------
			// 게시글 저장
	    	// -----------------------------------------------------------------------------
			switch (JopStatus)
			{
				case "Insert":
					bResult = NBoardDetailInsert(nboardDTO);			// 게시글 등록
					
					break;
				case "Update":
					bResult = NBoardDetailUpdate(NBoardId, nboardDTO);	// 게시글 수정
					
					break;
				case "Delete":
					bResult = NBoardDetailDelete(NBoardId);				// 게시글 삭제
					
					break;
			}
	    	// -----------------------------------------------------------------------------
		}
		catch (Exception Ex)
		{
			Common.ExceptionMgr.DisplayException(Ex);		// 예외처리(콘솔)
		}
		
		return bResult;
	}
	/***********************************************************************
	 * NBoardDetailInsert()	: 게시글을 오라클 데이터베이스에 등록(Insert)
	 * @param NBoardDTO		: 게시판 DTO 객체
	 * @return boolean		: true | false
	 ***********************************************************************/
	public boolean NBoardDetailInsert(NBoardDTO nboardDTO)
	{
		String sSql = null;						// DML 문장
		Object[] oPaValue = null;				// DML 문장에 필요한 파라미터 객체
		int nNBoardId = 0;						// 게시글 ID
		int nFileSeq = 1;						// 게시글에 첨부된 업로드 첨부파일 순서(현재는 한개만)
		String sUploadFileYN = null;			// 첨부파일 유무(Y/N)
		boolean bResult = false;
		
		try
		{
	    	// -----------------------------------------------------------------------------
			// 게시글 등록
	    	// -----------------------------------------------------------------------------
			if (this.DBMgr.DbConnect() == true)
			{
				// 게시글 ID 추출
				sSql = "SELECT SEQ_NBOARDID.NEXTVAL AS NBoardId FROM DUAL";
				
				// 첨부파일 유무(Y/N)
				sUploadFileYN = (nboardDTO.getUploadFile() != null) ? "Y" : "N";
				
				if (this.DBMgr.RunQuery(sSql, oPaValue, 0, true) == true)
				{
					if (this.DBMgr != null && this.DBMgr.Rs != null)
					{
						if (this.DBMgr.Rs.next() == true)
						{
							nNBoardId = this.DBMgr.Rs.getInt("NBoardId");
							
							// 게시글 등록
							sSql = "BEGIN SP_NBOARD_CUD(?,?,?,?,?,?,?); END;";
							
							// IN 파라미터 만큼만 할당
							oPaValue = new Object[7];
							
							oPaValue[0] = "INSERT";
							oPaValue[1] = nNBoardId;
							oPaValue[2] = nboardDTO.getTxtAuthor();
							oPaValue[3] = nboardDTO.getTxtSubject();
							oPaValue[4] = nboardDTO.getTxtEMail();
							oPaValue[5] = sUploadFileYN;
							oPaValue[6] = nboardDTO.getTxtContent();
							
							if (this.DBMgr.RunQuery(sSql, oPaValue, 0, false) == true)
							{
								if (sUploadFileYN.equals("Y") == true)
								{
									// 첨부파일(이미지) 저장
									sSql = "BEGIN SP_IMG_CUD(?,?,?,?,?,?,?,?); END;";
									
									// IN 파라미터 만큼만 할당
									oPaValue = new Object[8];
									
									oPaValue[0] = "INSERT";
									oPaValue[1] = nNBoardId;
									oPaValue[2] = nFileSeq;
									oPaValue[3] = (nboardDTO.getUploadFile() != null) ? nboardDTO.getUploadFileNameOrigin() : Types.NULL;
									oPaValue[4] = (nboardDTO.getUploadFile() != null) ? nboardDTO.getUploadFileNameChange() : Types.NULL;
									oPaValue[5] = (nboardDTO.getUploadFile() != null) ? nboardDTO.getUploadFileType() : Types.NULL;
									oPaValue[6] = (nboardDTO.getUploadFile() != null) ? nboardDTO.getUploadFileLength() : 0;
									oPaValue[7] = (nboardDTO.getUploadFile() != null) ? nboardDTO.getUploadFileData() : Types.NULL;
									
									this.DBMgr.RunQuery(sSql, oPaValue, 0, false);
								}
								
								this.DBMgr.DbCommit();
								
								bResult = true;
							}
						}
					}
				}
				
				this.DBMgr.DbDisConnect();
			}
	    	// -----------------------------------------------------------------------------
		}
		catch (Exception Ex)
		{
			Common.ExceptionMgr.DisplayException(Ex);		// 예외처리(콘솔)
		}
		
		return bResult;
	}
	/***********************************************************************
	 * NBoardDetailUpdate()	: 게시글을 오라클 데이터베이스에서 수정(Update)
	 * @param NBoardId		: 게시글 Id
	 * @param NBoardDTO		: 게시판 DTO 객체
	 * @return boolean		: true | false
	 ***********************************************************************/
	public boolean NBoardDetailUpdate(int NBoardId, NBoardDTO nboardDTO)
	{
		String sSql	= null;						// DML 문장
		Object[] oPaValue = null;				// DML 문장에 필요한 파라미터 객체
		int nFileSeq = 1;						// 게시글에 첨부된 업로드 첨부파일 순서(현재는 한개만)
		String sUploadFileYN = null;			// 첨부파일 유무(Y/N)
		boolean bResult = false;
		
		try
		{
	    	// -----------------------------------------------------------------------------
			// 게시글 수정
	    	// -----------------------------------------------------------------------------
			if (this.DBMgr.DbConnect() == true)
			{
				// 게시글 수정
				sSql = "BEGIN SP_NBOARD_CUD(?,?,?,?,?,?,?); END;";
				
				// 첨부파일 유무(Y/N)
				sUploadFileYN = (nboardDTO.getUploadFile() != null) ? "Y" : "N";
				
				// IN 파라미터 만큼만 할당
				oPaValue = new Object[7];
				
				oPaValue[0] = "UPDATE";
				oPaValue[1] = NBoardId;
				oPaValue[2] = nboardDTO.getTxtAuthor();
				oPaValue[3] = nboardDTO.getTxtSubject();
				oPaValue[4] = nboardDTO.getTxtEMail();
				oPaValue[5] = sUploadFileYN;
				oPaValue[6] = nboardDTO.getTxtContent();
				
				if (this.DBMgr.RunQuery(sSql, oPaValue, 0, false) == true)
				{
					if (sUploadFileYN.equals("Y") == true)
					{
						// 첨부파일(이미지) 수정
						sSql = "BEGIN SP_IMG_CUD(?,?,?,?,?,?,?,?); END;";
						
						// IN 파라미터 만큼만 할당
						oPaValue = new Object[8];
						
						oPaValue[0] = "UPDATE";
						oPaValue[1] = NBoardId;
						oPaValue[2] = nFileSeq;
						oPaValue[3] = (nboardDTO.getUploadFile() != null) ? nboardDTO.getUploadFileNameOrigin() : Types.NULL;
						oPaValue[4] = (nboardDTO.getUploadFile() != null) ? nboardDTO.getUploadFileNameChange() : Types.NULL;
						oPaValue[5] = (nboardDTO.getUploadFile() != null) ? nboardDTO.getUploadFileType() : Types.NULL;
						oPaValue[6] = (nboardDTO.getUploadFile() != null) ? nboardDTO.getUploadFileLength() : 0;
						oPaValue[7] = (nboardDTO.getUploadFile() != null) ? nboardDTO.getUploadFileData() : Types.NULL;
					}
					
					if (this.DBMgr.RunQuery(sSql, oPaValue, 0, false) == true)
					{
						this.DBMgr.DbCommit();
					
						bResult = true;
					}
				}
				
				this.DBMgr.DbDisConnect();
			}
	    	// -----------------------------------------------------------------------------
		}
		catch (Exception Ex)
		{
			Common.ExceptionMgr.DisplayException(Ex);		// 예외처리(콘솔)
		}
		
		return bResult;
	}
	/***********************************************************************
	 * NBoardDetailDelete()	: 게시글을 오라클 데이터베이스에서 삭제(Delete)
	 * @param NBoardId		: 게시글 Id
	 * @return boolean		: true | false
	 ***********************************************************************/
	public boolean NBoardDetailDelete(int NBoardId)
	{
		String sSql = null;						// DML 문장
		Object[] oPaValue = null;				// DML 문장에 필요한 파라미터 객체
		int nFileSeq = 1;						// 게시글에 첨부된 업로드 첨부파일 순서(현재는 한개만)
		boolean bResult = false;
		
		try
		{
	    	// -----------------------------------------------------------------------------
			// 게시글 삭제
	    	// -----------------------------------------------------------------------------
			if (this.DBMgr.DbConnect() == true)
			{
				// 게시글 삭제
				sSql = "BEGIN SP_NBOARD_CUD(?,?); END;";
				
				// IN 파라미터 만큼만 할당
				oPaValue = new Object[2];
				
				oPaValue[0] = "DELETE";
				oPaValue[1] = NBoardId;
				
				if (this.DBMgr.RunQuery(sSql, oPaValue, 0, false) == true)
				{
					// 첨부파일(이미지) 삭제
					sSql = "BEGIN SP_IMG_CUD(?,?,?); END;";
					
					// IN 파라미터 만큼만 할당
					oPaValue = new Object[3];
					
					oPaValue[0] = "DELETE";
					oPaValue[1] = NBoardId;
					oPaValue[2] = nFileSeq;
					
					if (this.DBMgr.RunQuery(sSql, oPaValue, 0, false) == true)
					{
						this.DBMgr.DbCommit();
					
						bResult = true;
					}
				}
				
				this.DBMgr.DbDisConnect();
			}
	    	// -----------------------------------------------------------------------------
		}
		catch (Exception Ex)
		{
			Common.ExceptionMgr.DisplayException(Ex);		// 예외처리(콘솔)
		}
		
		return bResult;
	}
	// —————————————————————————————————————————————————————————————————————————————————————
}
// #################################################################################################
// <END>
// #################################################################################################
