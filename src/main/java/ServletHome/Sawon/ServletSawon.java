// #################################################################################################
// ServletSawon.java - 서블릿 사원검색 페이지 모듈
// #################################################################################################
// ═════════════════════════════════════════════════════════════════════════════════════════
// 외부모듈 영역
// ═════════════════════════════════════════════════════════════════════════════════════════
package ServletHome.Sawon;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// ═════════════════════════════════════════════════════════════════════════════════════════
// 사용자정의 클래스 영역
// ═════════════════════════════════════════════════════════════════════════════════════════
/***********************************************************************
 * ServletSawon	: 서블릿 사원검색 클래스<br>
 * Inheritance	: HttpServlet
 ***********************************************************************/
@WebServlet(description = "서블릿 사원검색 페이지 모듈", urlPatterns = { "/ServletSawon" })
public class ServletSawon extends HttpServlet
{
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역상수 관리 - 필수영역
	// —————————————————————————————————————————————————————————————————————————————————————
	/** serialVersionUID : Bean 객체(메모리 객체 데이터) 직렬화 아이디(Servlet 구현시 필수 사항) */
	private static final long serialVersionUID = 1L;
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역변수 관리 - 필수영역(정적변수) : JSP 쪽에 노출시키려면 Static 등록 필요!
	// —————————————————————————————————————————————————————————————————————————————————————
	/** DBMgr : 오라클 데이터베이스 DAO 객체 선언 */
	public static DAO.DBOracleMgr DBMgr = null;
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역변수 관리 - 필수영역(인스턴스변수)
	// —————————————————————————————————————————————————————————————————————————————————————
	
	// —————————————————————————————————————————————————————————————————————————————————————
    // 생성자 관리 - 필수영역(인스턴스함수)
	// —————————————————————————————————————————————————————————————————————————————————————
	/***********************************************************************
	 * ServletSawon()	: 생성자
	 * @param void		: None
	 ***********************************************************************/
	public ServletSawon()
	{
		super();	// Servlet 부모 객체 생성(생성자 첫 행에서 호출해야 함)
		
		try
		{
			// -----------------------------------------------------------------------------
			// 기타 초기화 작업 관리
			// -----------------------------------------------------------------------------
			Common.ExceptionMgr.SetMode(Common.ExceptionMgr.RUN_MODE.DEBUG);
			
			ServletSawon.DBMgr = new DAO.DBOracleMgr();								// DAO 객체 생성
			ServletSawon.DBMgr.SetConnectionStringFromProperties("db.properties");	// DB 연결문자열 읽기 
			
			//this.DBMgr.SetConnectionString("172.30.1.44", 1521, "educ", "educ", "XE");	// My
			//this.DBMgr.SetConnectionString("192.168.0.100", 1521, "educ", "educ", "XE");	// My
			//ServletSawon.DBMgr.SetConnectionString("172.24.210.162", 1521, "educ", "educ", "XE");	// 301
			//ServletSawon.DBMgr.SetConnectionString("172.24.162.45", 1521, "educ", "educ", "XE");	// 306
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
		
		String sSql = null;						// DML 문장
		Object[] oPaValue = null;				// DML 문장에 필요한 파라미터 객체

		String sAge = null;						// 나이 파라미터
		String sGender = null;					// 성별 파라미터
		String sDept = null;					// 부서 파라미터
		
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
			sAge = request.getParameter("age");						// 나이 파라미터 읽기
			sAge = (sAge != null) ? sAge : "0";						// 나이 null 확인(0 : 전체)
			sAge = (sAge.trim().length() > 0) ? sAge : "0";			// 나이 길이 확인(0 : 전체)
			
			sGender = request.getParameter("gender");				// 성별 파라미터 읽기
			sGender = (sGender != null) ? sGender : "-1";			// 성별 null 확인(-1 : 전체)
			
			sDept = request.getParameter("dept");					// 부서 파라미터 읽기
			sDept = (sDept != null) ? sDept : "-1";					// 부서 null 확인(-1 : 전체)
	    	// -----------------------------------------------------------------------------
			// 사원정보 읽기
	    	// -----------------------------------------------------------------------------
			if (sGender != null && sDept != null)
			{
				if (ServletSawon.DBMgr.DbConnect() == true)
				{
					sSql = "BEGIN SP_MAN_R(?,?,?,?,?,?); END;";
					sSql = "{call SP_MAN_R(?,?,?,?,?,?)}";
					
					// IN 파라미터 만큼만 할당
					oPaValue = new Object[5];
					
					oPaValue[0] = 0;
					oPaValue[1] = "-1";
					oPaValue[2] = sAge;
					oPaValue[3] = sGender;
					oPaValue[4] = sDept;
					
					ServletSawon.DBMgr.RunQuery(sSql, oPaValue, 6, true);
				}
			}
			// -----------------------------------------------------------------	
			// [Servlet 페이지에서 바로 이동(바이패스)]
			// -----------------------------------------------------------------	
			// -----------------------------------------------------------------
			//	바이패스 방법3	: response.sendRedirect을 사용 한 페이지 이동
			//				:---------------------------------------------------
			//				: sUrl	- 이동 할 새로운 페이지 주소
			//				:		- sUrl 페이지에 GET 파라미터만 전달 가능
			//				:		- sUrl 페이지 갱신 없음 즉,
			//				:		- sUrl 페이지 주소에 GET 파라미터 있는 경우만
			//				:		- sUrl 페이지 쪽에서 request.getParameter() 사용가능
			//				:-------------------------------------------------------
			//				: 이 방법은 기다리지 않고 바로 이동하기 때문에 현재 화면이 표시되지 않음
			//				: 브라우저의 Url 주소는 sUrl 페이지로 변경 됨
			// -----------------------------------------------------------------
			String sUrl = String.format("JspHome/Sawon/SawonList_Sv.jsp?age=%s&gender=%s&dept=%s", sAge, sGender, sDept);
			
			response.sendRedirect(sUrl);
	    	// -----------------------------------------------------------------------------
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
