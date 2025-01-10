// #################################################################################################
// ServletNBoardImageRead.java - 서블릿 첨부파일(이미지) 출력 페이지 모듈
// #################################################################################################
// ═════════════════════════════════════════════════════════════════════════════════════════
// 외부모듈 영역
// ═════════════════════════════════════════════════════════════════════════════════════════
package ServletHome.NBoard;

import java.io.IOException;
import java.io.InputStream;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import BeansHome.NBoard.NBoardDAO;
// ═════════════════════════════════════════════════════════════════════════════════════════
// 사용자정의 클래스 영역
// ═════════════════════════════════════════════════════════════════════════════════════════
/***********************************************************************
 * ServletNBoardImageRead	: 서블릿 첨부파일(이미지) 출력 클래스<br>
 * Inheritance				: HttpServlet
 ***********************************************************************/
@WebServlet(description = "서블릿 첨부파일(이미지) 출력 페이지 모듈", urlPatterns = { "/ServletNBoardImageRead" })
public class ServletNBoardImageRead extends HttpServlet
{
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역상수 관리 - 필수영역
	// —————————————————————————————————————————————————————————————————————————————————————
	/** serialVersionUID : Bean 객체(메모리 객체 데이터) 직렬화 아이디(Servlet 구현시 필수 사항) */
	private static final long serialVersionUID = 1L;
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역변수 관리 - 필수영역(정적변수) : JSP 쪽에 노출시키려면 Static 등록 필요!
	// —————————————————————————————————————————————————————————————————————————————————————
	// /** DBMgr : 오라클 데이터베이스 DAO 객체 선언 */
	// public static DAO.DBOracleMgr DBMgr = null;
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역변수 관리 - 필수영역(인스턴스변수)
	// —————————————————————————————————————————————————————————————————————————————————————
	
	// —————————————————————————————————————————————————————————————————————————————————————
    // 생성자 관리 - 필수영역(인스턴스함수)
	// —————————————————————————————————————————————————————————————————————————————————————
	/***********************************************************************
	 * ServletNBoardImageRead()	: 생성자
	 * @param void				: None
	 ***********************************************************************/
	public ServletNBoardImageRead()
	{
		super();	// Servlet 부모 객체 생성(생성자 첫 행에서 호출해야 함)
		
		try
		{
			// -----------------------------------------------------------------------------
			// 기타 초기화 작업 관리
			// -----------------------------------------------------------------------------
			Common.ExceptionMgr.SetMode(Common.ExceptionMgr.RUN_MODE.DEBUG);
			// -----------------------------------------------------------------------------
		}
		catch (Exception Ex)
		{
			Common.ExceptionMgr.DisplayException(Ex);	// 예외처리(콘솔)
		}
    }
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역함수 관리 - 필수영역(정적함수)
	// —————————————————————————————————————————————————————————————————————————————————————

	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역함수 관리 - 필수영역(인스턴스함수)
	// —————————————————————————————————————————————————————————————————————————————————————
	/***********************************************************************
	 * doGet()			: Servlet doGet 함수 선언(필수 함수)
	 * 					: get 방식으로 파라미터를 전달하는 경우 호출됨
	 * @param request	: 웹 서버 요청에 사용하는 파라미터
	 * @param response	: 웹 서버 응답시 사용하는 파라미터
	 * @return void		: None
	 * @exception ServletException
	 * @exception IOException
	 ***********************************************************************/
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		try
		{
			doPost(request, response);
		}
		catch (Exception Ex)
		{
			Common.ExceptionMgr.DisplayException(Ex);	// 예외처리(콘솔)
		}
	}
	/***********************************************************************
	 * doGet()			: Servlet doPost 함수 선언(필수 함수)
	 * 					: post 방식으로 파라미터를 전달하는 경우 호출됨
	 * @param request	: 웹 서버 요청에 사용하는 파라미터
	 * @param response	: 웹 서버 응답시 사용하는 파라미터
	 * @return void		: None
	 * @exception ServletException
	 * @exception IOException
	 ***********************************************************************/
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		// PrintWriter out = null;				// 브라우저 출력용 스트림 객체
		
		int nNBoardId					= -1;	// 게시글 Id
		String sFileType				= null;	// 게시글 첨부파일 타입(ex : image/jpeg)	
		InputStream oFileData			= null;	// 데이터베이스에서 읽은 blob 타입의 이진 데이터를 저장
		ServletOutputStream oOutStream	= null;	// 클라이언트 출력용 브라우저 객체
		int nBinaryData					= 0;	// blob 타입의 이진 데이터에서 한 픽셀씩 읽어서 저장
		
		NBoardDAO nboardDAO			= null;	// 게시판 용 DAO Bean 객체(Database Access Object)
		
		try
		{
			// -----------------------------------------------------------------------------
			// 한글 인코딩 지정(가장 첫번째로 지정!)
			// -----------------------------------------------------------------------------
			response.setContentType("text/html; charset=UTF-8");	// 출력 할 브라우저 한글 환경
			response.setCharacterEncoding("UTF-8");					// 출력 할 브라우저 한글 인코딩
			request.setCharacterEncoding("UTF-8");					// 입력 된 파라미터 한글 인코딩
			// -----------------------------------------------------------------------------
			// 브라우저 출력 스트림 객체 생성
			// -----------------------------------------------------------------------------
			// out = response.getWriter();
			// -----------------------------------------------------------------------------
			// 검색 조건 필터링
			// -----------------------------------------------------------------------------
			if (request.getParameter("NBoardId") != null)			// 게시글 Id
				nNBoardId = Integer.parseInt(request.getParameter("NBoardId"));
	    	// -----------------------------------------------------------------------------
			// 게시글에 첨부된 파일(이미지) 읽기
			// -----------------------------------------------------------------------------
			if (nNBoardId > 0)
			{
				nboardDAO = new NBoardDAO();
				
				if (nboardDAO.ReadBoardDetailFileData(nNBoardId) == true)
				{
					if (nboardDAO.DBMgr != null && nboardDAO.DBMgr.Rs != null)
					{
						if (nboardDAO.DBMgr.Rs.next() == true)
						{
							sFileType = nboardDAO.DBMgr.Rs.getString("FileType");
							oFileData = nboardDAO.DBMgr.Rs.getBinaryStream("FileData");
							
							response.setContentType(sFileType);
							
							oOutStream = response.getOutputStream();
							
							while ((nBinaryData = oFileData.read()) != -1)
							{
								oOutStream.write(nBinaryData);
							}
							
							nboardDAO.DBMgr.DbDisConnect();
						}
					}
				}
			}
			// -----------------------------------------------------------------	
			// [Servlet 페이지에서 바로 이동(바이패스)]
			// -----------------------------------------------------------------	
			// String sUrl = "";
			// -----------------------------------------------------------------	
		}
		catch(Exception Ex)
		{
			Common.ExceptionMgr.DisplayException(Ex);		// 예외처리(콘솔)
		}
	}
	// —————————————————————————————————————————————————————————————————————————————————————
}
// #################################################################################################
// <END>
// #################################################################################################
