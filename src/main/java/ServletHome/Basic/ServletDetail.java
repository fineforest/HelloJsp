// #################################################################################################
// ServletDetail.java - 서블릿 상세 페이지 모듈
// #################################################################################################
// ═════════════════════════════════════════════════════════════════════════════════════════
// 외부모듈 영역
// ═════════════════════════════════════════════════════════════════════════════════════════
package ServletHome.Basic;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import BeansHome.Basic.BasicDTO;

// ═════════════════════════════════════════════════════════════════════════════════════════
// 사용자정의 클래스 영역
// ═════════════════════════════════════════════════════════════════════════════════════════
/***********************************************************************
 * ServletDetail	: 서블릿 상세 페이지 클래스<br>
 * Inheritance		: HttpServlet
 ***********************************************************************/
@WebServlet(description = "서블릿 상세 페이지 모듈", urlPatterns = { "/ServletDetail" })
public class ServletDetail extends HttpServlet
{
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역상수 관리 - 필수영역
	// —————————————————————————————————————————————————————————————————————————————————————
	/** serialVersionUID : Bean 객체(메모리 객체 데이터) 직렬화 아이디(Servlet 구현시 필수 사항) */
	private static final long serialVersionUID = 1L;
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역변수 관리 - 필수영역(정적변수) : JSP 쪽에 노출시키려면 Static 등록 필요!
	// —————————————————————————————————————————————————————————————————————————————————————
	
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역변수 관리 - 필수영역(인스턴스변수)
	// —————————————————————————————————————————————————————————————————————————————————————
	
	// —————————————————————————————————————————————————————————————————————————————————————
    // 생성자 관리 - 필수영역(인스턴스함수)
	// —————————————————————————————————————————————————————————————————————————————————————
	/***********************************************************************
	 * ServletDetail()	: 생성자
	 * @param void		: None
	 ***********************************************************************/
	public ServletDetail()
	{
		super();	// Servlet 부모 객체 생성(생성자 첫 행에서 호출해야 함)
		
		try
		{
			// -----------------------------------------------------------------------------
			// 기타 초기화 작업 관리
			// -----------------------------------------------------------------------------
			
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
		PrintWriter out = null;					// 브라우저 출력용 스트림 객체
		
		Cookie[] oCookies = null;				// 쿠키 객체
		String sCookieName = null;				// 쿠키 변수명
		String sCookieValue = null;				// 쿠키 변수값
		BasicDTO oBasicDTO = null;		// Beans DTO 객체
		
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
			out = response.getWriter();
			// -----------------------------------------------------------------------------
			// 쿠키 읽기
			// -----------------------------------------------------------------------------
			oCookies = request.getCookies();
			
			if (oCookies != null)
			{		
				sCookieName = oCookies[0].getName();
				sCookieValue = oCookies[0].getValue();
			}
			// -----------------------------------------------------------------	
			// Beans 객체 생성
			// -----------------------------------------------------------------
			oBasicDTO = new BasicDTO();
			// -----------------------------------------------------------------	
			// Beans 속성에 데이터 넣기
			// -----------------------------------------------------------------
			oBasicDTO.setTxtData1(request.getParameter("txtData1"));
			oBasicDTO.setTxtData2(request.getParameter("txtData2"));
			// -----------------------------------------------------------------------------
			// [HTML Page - 헤드 영역]
			// -----------------------------------------------------------------------------
			out.println("<!DOCTYPE html>");
			out.println("<html>");
			out.println("<head>");
			out.println("<meta charset=\"UTF-8\"/>");
			out.println("<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge,chrome=1\"/>");
			out.println("<meta http-equiv=\"Cache-Control\" content=\"no-cache, no-store, must-revalidate\">");
			out.println("<meta name=\"Description\" content=\"검색 엔진을 위해 웹 페이지에 대한 설명을 명시\"/>");
			out.println("<meta name=\"keywords\" content=\"검색 엔진을 위해 웹 페이지와 관련된 키워드 목록을 콤마로 구분해서 명시\"/>");
			out.println("<meta name=\"Author\" content=\"문서의 저자를 명시\"/>");
			out.println("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">");
			out.println("<title>Servlet Detail Page</title>");
			// -----------------------------------------------------------------------------
			// [HTML Page - 스타일쉬트 영역]
			// -----------------------------------------------------------------------------
			out.println("<style type=\"text/css\">");
			out.println("	.Body	 	{ padding: 30px;");
			out.println("	.Line		{ border: 0px; height: 2px;");
			out.println("				  background-color: black; box-shadow: 5px 5px 10px gray; }");
			out.println("	.Title	 	{ color: black; font-size: 24px; font-weight: bold;");
			out.println("				  text-align: center; text-shadow: 5px 5px 10px darkgray; }");
			out.println("	.Subject 	{ color: blue; font-size: 20px; font-weight: bold;");
			out.println("				  text-shadow: 5px 5px 10px darkgray; }");
			out.println("	.Content	{ color: black; margin: 15px;");
			out.println("				  font-size: 16px; font-weight: bold; }");
			out.println("	.Submit		{ font-size: 16px; font-weight: bold; }");
			out.println("</style>");
			out.println("</head>");
			out.println("<body class=\"Body\">");
			// -----------------------------------------------------------------------------
			// [HTML Page - FORM 디자인 영역]
			// -----------------------------------------------------------------------------
			out.println("<form name=\"form1\" action=\"JspHome/Basic/Basic.jsp\" method=\"post\">");
			// -----------------------------------------------------------------	
			// 타이틀
			// -----------------------------------------------------------------
			out.println("<hr class=\"Line\">");
			out.println("<div class=\"Title\">Servlet 상세 페이지</div>");
			out.println("<hr class=\"Line\">");
			// -----------------------------------------------------------------	
			// 샘플 텍스트 데이터 화면 출력
			// -----------------------------------------------------------------
			out.println("<ul>");
			out.println("	<li>");
			out.println("		<p class=\"Subject\">[샘플 텍스트 데이터 화면 출력]</p>");
			out.println("		<ul>");
			out.println("			<li class=\"Content\">ServletDetail.jsp</li>");
			out.println("			<li class=\"Content\">안녕하세요...! ServletDetail.jsp 페이지 입니다.</li>");
			out.println("		</ul>");
			out.println("	</li>");
			// -----------------------------------------------------------------	
			// request.getParameter 파라미터 출력
			// -----------------------------------------------------------------
			out.println("	<li>");
			out.println("		<p class=\"Subject\">[request.getParameter 파라미터 출력]</p>");
			out.println("		<ul>");
			out.println(String.format("<li class=\"Content\">다른 이전 페이지의 데이터-1 : %s</li>", request.getParameter("txtData1")));
			out.println(String.format("<li class=\"Content\">다른 이전 페이지의 데이터-2 : %s</li>", request.getParameter("txtData2")));
			out.println("		</ul>");
			out.println("	</li>");
			// -----------------------------------------------------------------	
			// session/application 및 request 값 출력
			// -----------------------------------------------------------------
			out.println("	<li>");
			out.println("		<p class=\"Subject\">[session/application 및 request 값 출력]</p>");
			out.println("		<ul>");
			out.println(String.format("<li class=\"Content\">쿠키 : getName(), getValue() : %s, %s</li>", sCookieName, sCookieValue));
			out.println(String.format("<li class=\"Content\">세션 : HelloSession = 사용불가	</li>"));
			out.println(String.format("<li class=\"Content\">어플 : HelloApplication = 사용불가</li>"));
			out.println(String.format("<li class=\"Content\">주소 : request.getRemoteAddr() =	 %s</li>", request.getRemoteAddr()));
			out.println(String.format("<li class=\"Content\">방식 : request.getMethod() =	 %s</li>", request.getMethod()));
			out.println(String.format("<li class=\"Content\">언어 : request.getProtocol() = %s</li>", request.getProtocol()));
			out.println("		</ul>");
			out.println("	</li>");
			// -----------------------------------------------------------------	
			// Beans 변수/속성/함수 출력
			// -----------------------------------------------------------------
			out.println("	<li>");
			out.println("		<p class=\"Subject\">[Beans 변수/속성/함수 출력]</p>");
			out.println("		<ul>");
			out.println(String.format("<li class=\"Content\">Beans 변수 사용 - oArrayValue = %s</li>", Arrays.toString(oBasicDTO.oArrayValue)));
			out.println(String.format("<li class=\"Content\">Beans 속성 사용 - txtData1 =	%s</li>", oBasicDTO.getTxtData1()));
			out.println(String.format("<li class=\"Content\">Beans 속성 사용 - txtData2 =	%s</li>", oBasicDTO.getTxtData2()));
			out.println(String.format("<li class=\"Content\">Beans 함수 호출 - HelloCheck() =	%s</li>", oBasicDTO.HelloCheck()));
			out.println("		</ul>");
			out.println("	</li>");
			// -----------------------------------------------------------------	
			// 페이지 이동
			// -----------------------------------------------------------------
			out.println("	<li>");
			out.println("		<p class=\"Subject\">[페이지 이동]</p>");
			out.println("		<ul>");
			out.println("			<li class=\"Content\">Submit사용(POST) : <input class=\"Submit\" type=\"submit\" value=\"이전 기본 페이지로 이동하기(Basic.jsp)\"></li>");
			out.println("			<li class=\"Content\">하이퍼링크사용(GET) : <a href=\"JspHome/Index.jsp\">INDEX 페이지로 돌아가기(Index.jsp)</a></li>");
			out.println("		</ul>");
			out.println("	</li>");
			out.println("</ul>");
			out.println("<hr class=\"Line\">");
			// -----------------------------------------------------------------	
			// Servlet 페이지에서 바로 이동(바이패스)
			// -----------------------------------------------------------------
			// String sUrl = "Basic.jsp";
			// -----------------------------------------------------------------	
			// 바이패스 방법2	: RequestDispatcher을 사용 한 페이지 이동
			//				: 이 방법은 기다리지 않고 바로 이동하기 때문에 현재 화면이 표시되지 않음
			//				: JSP 내에서 다른 파일로 request를 보내고 바로 response를 받는것
			//				: 이동 할 페이지에 request, response를 파라미터를 넘겨 줌
			//				: 이동 할 새로운 페이지 갱신됨
			// -----------------------------------------------------------------
			// RequestDispatcher dispatcher = request.getRequestDispatcher(sUrl);
			// dispatcher.forward(request,response);
			// -----------------------------------------------------------------	
			// 바이패스 방법3	: response.sendRedirect을 사용 한 페이지 이동
			//				: 이 방법은 기다리지 않고 바로 이동하기 때문에 현재 화면이 표시되지 않음
			//				: response로 서버에 지정된 경로를 다시 요청하여 새로운 페이지를 호출
			//				: 이동 할 페이지에 GET 방식의 파라미터를 넘겨줄 수 있음
			//				: 이동 할 새로운 페이지 갱신 없음
			// -----------------------------------------------------------------
			// response.sendRedirect(sUrl);
			// -----------------------------------------------------------------
			out.println("</form>");
			out.println("</body>");
			out.println("</html>");
			// -----------------------------------------------------------------	
			// [HTML Page - END]
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
