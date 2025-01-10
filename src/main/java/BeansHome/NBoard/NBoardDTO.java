// #################################################################################################
// NBoardDTO.java - 게시판 DTO 모듈
// #################################################################################################
// ═════════════════════════════════════════════════════════════════════════════════════════
// 외부모듈 영역
// ═════════════════════════════════════════════════════════════════════════════════════════
package BeansHome.NBoard;

import java.io.File;

import Common.ExceptionMgr;

// ═════════════════════════════════════════════════════════════════════════════════════════
// 사용자정의 클래스 영역
// ═════════════════════════════════════════════════════════════════════════════════════════
/***********************************************************************
 * NBoardDTO	: 게시판 DTO 클래스<br>
 * Inheritance	: None | 부모 클래스 명
 ***********************************************************************/
public class NBoardDTO
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
	/** txtAuthor				: Bean 작성자 필드 선언(JSP 입력 객체와 1:1 대응, 소문자로 시작) */
	private String txtAuthor = null;
	/** txtSubject				: Bean 제목 필드 선언(JSP 입력 객체와 1:1 대응, 소문자로 시작) */
	private String txtSubject = null;
	/** txtEMail				: Bean 이메일 필드 선언(JSP 입력 객체와 1:1 대응, 소문자로 시작) */
	private String txtEMail = null;
	/** txtContent				: Bean 내용 필드 선언(JSP 입력 객체와 1:1 대응, 소문자로 시작) */
	private String txtContent = null;
	/** UploadFileNameOrigin	: Bean 업로드 파일 원래이름 필드 선언(JSP 입력 객체와 1:1 대응, 소문자로 시작) */
	private String UploadFileNameOrigin = null;
	/** UploadFileNameChange	: Bean 업로드 파일 바뀐이름 필드 선언(JSP 입력 객체와 1:1 대응, 소문자로 시작) */
	private String UploadFileNameChange = null;
	/** UploadFile				: Bean 업로드 파일 정보 필드 선언(JSP 입력 객체와 1:1 대응, 소문자로 시작) */
	private File UploadFile = null;
	/** UploadFileType			: Bean 업로드 파일 타입 필드 선언(JSP 입력 객체와 1:1 대응, 소문자로 시작) */
	private String UploadFileType = null;
	/** UploadFileLength		: Bean 업로드 파일 길이 필드 선언(JSP 입력 객체와 1:1 대응, 소문자로 시작) */
	private long UploadFileLength = 0;
	/** UploadFileData			: Bean 업로드 파일 바이트 배열 필드 선언(JSP 입력 객체와 1:1 대응, 소문자로 시작) */
	private byte[] UploadFileData = null;
	// —————————————————————————————————————————————————————————————————————————————————————
    // 생성자 관리 - 필수영역(인스턴스함수)
	// —————————————————————————————————————————————————————————————————————————————————————
	/***********************************************************************
	 * NBoardDTO()	: 생성자
	 * @param void	: None
	 ***********************************************************************/
	public NBoardDTO()
	{
		try
		{
			// -----------------------------------------------------------------------------
			// 초기화 작업 관리
			// -----------------------------------------------------------------------------
			ExceptionMgr.SetMode(ExceptionMgr.RUN_MODE.DEBUG);
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
	public String getTxtAuthor()
	{
		return txtAuthor;
	}

	public void setTxtAuthor(String txtAuthor)
	{
		this.txtAuthor = txtAuthor;
	}

	public String getTxtSubject()
	{
		return txtSubject;
	}

	public void setTxtSubject(String txtSubject)
	{
		this.txtSubject = txtSubject;
	}

	public String getTxtEMail()
	{
		return txtEMail;
	}

	public void setTxtEMail(String txtEMail)
	{
		this.txtEMail = txtEMail;
	}

	public String getTxtContent()
	{
		return txtContent;
	}

	public void setTxtContent(String txtContent)
	{
		this.txtContent = txtContent;
	}

	public String getUploadFileNameOrigin()
	{
		return UploadFileNameOrigin;
	}

	public void setUploadFileNameOrigin(String UploadFileNameOrigin)
	{
		this.UploadFileNameOrigin = UploadFileNameOrigin;
	}

	public String getUploadFileNameChange()
	{
		return UploadFileNameChange;
	}

	public void setUploadFileNameChange(String UploadFileNameChange)
	{
		this.UploadFileNameChange = UploadFileNameChange;
	}

	public File getUploadFile()
	{
		return UploadFile;
	}
	public void setUploadFile(File UploadFile)
	{
		this.UploadFile = UploadFile;
	}
	
	public String getUploadFileType()
	{
		return UploadFileType;
	}

	public void setUploadFileType(String UploadFileType)
	{
		this.UploadFileType = UploadFileType;
	}

	public long getUploadFileLength()
	{
		return UploadFileLength;
	}

	public void setUploadFileLength(long UploadFileLength)
	{
		this.UploadFileLength = UploadFileLength;
	}

	public byte[] getUploadFileData()
	{
		return UploadFileData;
	}
	
	public void setUploadFileData(byte[] UploadFileData)
	{
		this.UploadFileData = UploadFileData;
	}
	// —————————————————————————————————————————————————————————————————————————————————————
}
// #################################################################################################
// <END>
// #################################################################################################
