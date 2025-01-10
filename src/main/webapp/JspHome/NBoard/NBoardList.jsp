<%@page import="Common.ComMgr"%>
<%@page import="BeansHome.NBoard.NBoardDAO"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.apache.naming.java.javaURLContextFactory"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%----------------------------------------------------------------------
	[HTML Page - 헤드 영역]
	--------------------------------------------------------------------------%>
	<%--<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">--%>
    <meta charset="UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
	<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate"/>
	<meta http-equiv="Expires" content="0"/>
	<meta http-equiv="pragma" content="no-cache"/>
    <meta name="Description" content="검색 엔진을 위해 웹 페이지에 대한 설명을 명시"/>
    <meta name="keywords" content="검색 엔진을 위해 웹 페이지와 관련된 키워드 목록을 콤마로 구분해서 명시"/>
    <meta name="Author" content="문서의 저자를 명시"/>
	<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>게시판 목록 페이지</title>
	<%----------------------------------------------------------------------
	[HTML Page - 스타일쉬트 구현 영역]
	[외부 스타일쉬트 연결 : <link rel="stylesheet" href="Hello.css?version=1.1"/>]
	--------------------------------------------------------------------------%>
	<link rel="stylesheet" href="CSS/NBoardList.css?version=1.1"/>
	<style type="text/css">
		/* -----------------------------------------------------------------
			HTML Page 스타일시트
		   ----------------------------------------------------------------- */
			
        /* ----------------------------------------------------------------- */
	</style>
	<%----------------------------------------------------------------------
	[HTML Page - 자바스크립트 구현 영역(상단)]
	[외부 자바스크립트 연결(각각) : <script type="text/javascript" src="Hello.js"></script>]
	--------------------------------------------------------------------------%>
	<script type="text/javascript" src="JS/NBoard.js"></script>
	<script type="text/javascript">
		// -----------------------------------------------------------------
		// [브라우저 갱신 완료 시 호출 할 이벤트 핸들러 연결 - 필수]
		// -----------------------------------------------------------------
		// window.onload = function () { DocumentInit('페이지가 모두 로드되었습니다!'); }
		// window.addEventListener('load', DocumentInit('페이지가 모두 로드되었습니다!'));
		// window.addEventListener('load', DocumentInit);
		// -----------------------------------------------------------------
		// [브라우저 갱신 완료 및 초기화 구현 함수 - 필수]
		// -----------------------------------------------------------------
		// 브라우저 갱신 완료 까지 기다리는 함수 - 필수
		// 일반적인 방식 : setTimeout(()=>alert('페이지가 모두 로드되었습니다!'), 50);
		function DocumentInit(Msg)
		{
			requestAnimationFrame(function() {
				requestAnimationFrame(function() {
					alert(Msg);
				});
			});
        }
		// -----------------------------------------------------------------
		// [사용자 함수 및 로직 구현]
		// -----------------------------------------------------------------
		
		// -----------------------------------------------------------------
	</script>
</head>
<%--------------------------------------------------------------------------
[JSP 전역 변수/함수 선언 영역 - 선언문 영역]
	- this 로 접근 가능 : 같은 페이지가 여러번 갱신 되더라도 변수/함수 유지 됨
	- 즉 현재 페이지가 여러번 갱신 되는 경우 선언문은 한번만 실행 됨
------------------------------------------------------------------------------%>
<%!
	// ---------------------------------------------------------------------
	// [JSP 전역 변수/함수 선언]
	// ---------------------------------------------------------------------
	// 게시판 테이블 헤더
	public String[] BoardHead = { "순서", "글-Id", "작성자", "글제목", "E-Mail",
								  "날짜시간", "첨부", "글내용", "편집", "삭제" };

	// 게시판 검색(리스트,상세)/추가/수정/삭제 처리용 DAO 객체
	public NBoardDAO nboardDAO = new NBoardDAO();
	// ---------------------------------------------------------------------
%>
<%--------------------------------------------------------------------------
[JSP 지역 변수 선언 및 로직 구현 영역 - 스크립트릿 영역]
	- this 로 접근 불가 : 같은 페이지가 여러번 갱신되면 변수/함수 유지 안 됨
	- 즉 현재 페이지가 여러번 갱신 될 때마다 스크립트릿 영역이 다시 실행되어 모두 초기화 됨
------------------------------------------------------------------------------%>
<%
	// ---------------------------------------------------------------------
	// [JSP 지역 변수 선언 : 웹 페이지 get/post 파라미터]
	// ---------------------------------------------------------------------
	Integer nNBoardPageNum		= null;		// 게시판 페이지 번호
	String  sNBoardVector		= null;		// 게시판 페이지 번호 이동 방향(First, Before, Current, Next, Last)
	// ---------------------------------------------------------------------
	// [JSP 지역 변수 선언 : 데이터베이스 파라미터]
	// ---------------------------------------------------------------------
	Integer nNo					= null;		// 게시글 순서
	Integer nNBoardId			= null;		// 게시글 Id
	String  sAuthor				= null;		// 작성자
	String  sSubject			= null;		// 글제목
	String  sEMail				= null;		// 이메일
	String  sDateTime			= null;		// 작성일
	String  sAttachYn			= null;		// 첨부파일 여부
	String  sContent			= null;		// 글내용
	
	Integer nNBoardPageNumMax	= null;		// 게시판 페이지 번호(최대값)
	String  sNBoardVectorState	= null;		// 게시판 페이지 번호 위치상태(First, Last, Middle)
	// ---------------------------------------------------------------------
	// [JSP 지역 변수 선언 : 일반 변수]
	// ---------------------------------------------------------------------
	String sNBoardViewUrl		= null;		// 게시글 상세정보 페이지 이동 경로
	String sNBoardUpdateUrl		= null;		// 게이글 수정 페이지 이동 경로
	String sNBoardDeleteCall	= null;		// 게이글 삭제 페이지 호출 함수
	
	Integer nNBoardPageSize		= 50;		// 게시판 페이지 크기
	Integer nNBoardPageLinkSize	= 10;		// 게시판 페이지 크기
	Boolean bContinue			= false;	// 게시글 보기 진행 여부
	// ---------------------------------------------------------------------
	// [웹 페이지 get/post 파라미터 조건 필터링]
	// ---------------------------------------------------------------------
	// 검색 할 게시판 페이지 번호 파라미터 읽기
	nNBoardPageNum = ComMgr.IsNull(request.getParameter("NBoardPageNum"), 1);
	
	// 게시판 페이지 번호 이동 방향 파라미터 읽기
	sNBoardVector = ComMgr.IsNull(request.getParameter("NBoardVector"), "First");
	// ---------------------------------------------------------------------
	// [일반 변수 조건 필터링]
	// ---------------------------------------------------------------------
	
	// ---------------------------------------------------------------------
%>
<%--------------------------------------------------------------------------
[Beans/DTO 선언 및 속성 지정 영역]
------------------------------------------------------------------------------%>
	<%----------------------------------------------------------------------
	Beans 객체 사용 선언	: id	- 임의의 이름 사용 가능(클래스 명 권장)
						: class	- Beans 클래스 명
 						: scope	- Beans 사용 기간을 request 단위로 지정 Hello.HelloDTO 
	------------------------------------------------------------------------
	<jsp:useBean id="HelloDTO" class="Hello.HelloDTO" scope="request"></jsp:useBean>
	--%>
	<%----------------------------------------------------------------------
	Beans 속성 지정 방법1	: Beans Property에 * 사용
						:---------------------------------------------------
						: name		- <jsp:useBean>의 id
						: property	- HTML 태그 입력양식 객체 전체
						:---------------------------------------------------
	주의사항				: HTML 태그의 name 속성 값은 소문자로 시작!
						: HTML 태그에서 데이터 입력 없는 경우 null 입력 됨!
	------------------------------------------------------------------------
	<jsp:setProperty name="HelloDTO" property="*"/>
	--%>
	<%----------------------------------------------------------------------
	Beans 속성 지정 방법2	: Beans Property에 HTML 태그 name 사용
						:---------------------------------------------------
						: name		- <jsp:useBean>의 id
						: property	- HTML 태그 입력양식 객체 name
						:---------------------------------------------------
	주의사항				: HTML 태그의 name 속성 값은 소문자로 시작!
						: HTML 태그에서 데이터 입력 없는 경우 null 입력 됨!
						: Property를 각각 지정 해야 함!
	------------------------------------------------------------------------
	<jsp:setProperty name="HelloDTO" property="data1"/>
	<jsp:setProperty name="HelloDTO" property="data2"/>
	--%>
	<%----------------------------------------------------------------------
	Beans 속성 지정 방법3	: Beans 메서드 직접 호출
						:---------------------------------------------------
						: Beans 메서드를 각각 직접 호출 해야함!
	--------------------------------------------------------------------------%>
<%
	// HelloDTO.setData1(request.getParameter("data1"));
%>
<%--------------------------------------------------------------------------
[Beans DTO 읽기 및 로직 구현 영역]
------------------------------------------------------------------------------%>
<%
// -----------------------------------------------------------------
// 데이터베이스에서 게시판 목록 읽기(Beans DAO 사용)
// -----------------------------------------------------------------
if (nboardDAO.ReadBoardList(nNBoardPageNum, nNBoardPageSize, sNBoardVector) == true)
{
	if (nboardDAO.DBMgr != null && nboardDAO.DBMgr.Rs != null)
	{
		bContinue = true;
	}
}
// -----------------------------------------------------------------
%>
<body class="Body">
	<%----------------------------------------------------------------------
	[HTML Page - FORM 디자인 영역]
	--------------------------------------------------------------------------%>
	<form name="form1" action="" method="post">
		<%------------------------------------------------------------------
			Top 고정 영역
		----------------------------------------------------------------------%>
		<div class="Top-Fixed" id="TopArea">
			<%------------------------------------------------------------------
				타이틀
			----------------------------------------------------------------------%>
			<hr class="Line">
			<div class="Title">JSP 게시판 목록(Use JSP/Beans/Servlet/ResultSet)</div>
			<hr class="Line">
		</div>
		<%------------------------------------------------------------------
			Middle 고정 영역
		----------------------------------------------------------------------%>
		<div class="Middle-Fixed" id="MiddleArea">
			<%------------------------------------------------------------------
				게시판 목록 테이블 동적으로 생성하기
			----------------------------------------------------------------------%>
			<table class="Table">
			<%
			out.println("<tr class=\"TableHead\">");
			
			// 게시판 목록 테이블 헤더 만들기
			for(String sHead : this.BoardHead)
			{
				out.println(String.format("<th>%s</th>", sHead));
			}
			
			out.println("</tr>");
			// -----------------------------------------------------------------
			// 게시판 목록 출력
			// -----------------------------------------------------------------
			if (bContinue == true)
			{
				while(nboardDAO.DBMgr.Rs.next() == true)
				{
					// -----------------------------------------------------
					// 게시판 목록 읽기
					// -----------------------------------------------------
					nNo					= ComMgr.IsNull(nboardDAO.DBMgr.Rs.getString("No"), 0);	// Oracle rownum
					nNBoardId			= ComMgr.IsNull(nboardDAO.DBMgr.Rs.getString("NBoardId"), 0);
					sAuthor				= ComMgr.IsNull(nboardDAO.DBMgr.Rs.getString("Author"), "");
					sSubject			= ComMgr.IsNull(nboardDAO.DBMgr.Rs.getString("Subject"), "");
					sEMail				= ComMgr.IsNull(nboardDAO.DBMgr.Rs.getString("EMail"), "");
					sDateTime			= ComMgr.IsNull(nboardDAO.DBMgr.Rs.getString("DateTime"), "");
					sAttachYn			= ComMgr.IsNull(nboardDAO.DBMgr.Rs.getString("AttachYn"), "");
					sContent			= ComMgr.IsNull(nboardDAO.DBMgr.Rs.getString("Content"), "");
					
					nNBoardPageNum		= ComMgr.IsNull(nboardDAO.DBMgr.Rs.getString("NBoardPageNum"), 0);
					nNBoardPageNumMax	= ComMgr.IsNull(nboardDAO.DBMgr.Rs.getString("NBoardPageNumMax"), 0);
					sNBoardVectorState	= ComMgr.IsNull(nboardDAO.DBMgr.Rs.getString("NBoardVectorState"), "");
					// -----------------------------------------------------
					// 게시판 목록는 태그 허용하지 않음(중요!)
					// -----------------------------------------------------
					sAuthor				= sAuthor.replace("<", "").replace(">", "");
					sSubject			= sSubject.replace("<", "").replace(">", "");
					sEMail				= sEMail.replace("<", "").replace(">", "");
					sContent			= sContent.replace("<", "").replace(">", "");
					// -----------------------------------------------------
					// 게시글 상세정보 페이지 및 게이글 수정/삭제 페이지 이동 경로 만들기
					// -----------------------------------------------------
					sNBoardViewUrl		= String.format("NBoardView.jsp?NBoardPageNum=%d&NBoardId=%d&NBoardIdVector=Current", nNBoardPageNum, nNBoardId);
					sNBoardUpdateUrl	= String.format("NBoardDetail.jsp?NBoardPageNum=%d&NBoardId=%d&JopStatus=Update", nNBoardPageNum, nNBoardId);
					sNBoardDeleteCall	= String.format("MoveNBoardDelete(%d, %d,'%s','%s')", nNBoardPageNum, nNBoardId, sAuthor, sSubject);
			%>
			<%------------------------------------------------------------------
				게시판 목록 행/열 만들기
			----------------------------------------------------------------------%>
				<tr class="TableRow">
					<td><%=nNo %></td>
					<td><%=nNBoardId %></td>
					<td><%=sAuthor %></td>
					<td><a href="<%=sNBoardViewUrl %>"><%=sSubject %></a></td>
					<td><%=sEMail %></td>
					<td><%=sDateTime %></td>
					<td><%=sAttachYn %></td>
					<td><a href="<%=sNBoardViewUrl %>"><%=sContent %></a></td>
					<td><a href="<%=sNBoardUpdateUrl %>">수정</a></td>
					<td><a href="#" onclick="<%=sNBoardDeleteCall %>">삭제</a></td>
				</tr>
			<%
				}
				
				if (nboardDAO.DBMgr != null) nboardDAO.DBMgr.DbDisConnect();
				
				if (sNBoardVectorState == null) sNBoardVectorState = "";
			}
			else	// 데이터베이스 검색이 오류인 경우
			{
				nNo					= ComMgr.IsNull(nNo, 0);	// Oracle rownum
				nNBoardId			= ComMgr.IsNull(nNBoardId, 0);
				sAuthor				= ComMgr.IsNull(sAuthor, "");
				sSubject			= ComMgr.IsNull(sSubject, "");
				sEMail				= ComMgr.IsNull(sEMail, "");
				sDateTime			= ComMgr.IsNull(sDateTime, "");
				sAttachYn			= ComMgr.IsNull(sAttachYn, "");
				sContent			= ComMgr.IsNull(sContent, "");
				
				nNBoardPageNum		= ComMgr.IsNull(nNBoardPageNum, 0);
				nNBoardPageNumMax	= ComMgr.IsNull(nNBoardPageNumMax, 0);
				sNBoardVectorState	= ComMgr.IsNull(sNBoardVectorState, "");
			}
			%>
			
			</table>
		</div>
		<%------------------------------------------------------------------
			Bottom 고정 영역
		----------------------------------------------------------------------%>
		<div class="Bottom-Fixed" id="BottomArea">
			<table class="Table">
			<%------------------------------------------------------------------
				게시판 페이지 링크 만들기
			----------------------------------------------------------------------%>
				<tr class="MovePage">
					<td colspan=10>
			<%
				int nCurrentPageNum = nNBoardPageNum - 1;
			
				int nMok = nCurrentPageNum / nNBoardPageLinkSize;
				int nStartPageNum = nMok * nNBoardPageLinkSize;
				int nEndPageNum = nStartPageNum + nNBoardPageLinkSize;
				
				if (nEndPageNum > nNBoardPageNumMax)
					nEndPageNum = nNBoardPageNumMax;
			
				for(int PageNum = nStartPageNum; PageNum < nEndPageNum; PageNum++)
				{
					if (PageNum != nCurrentPageNum)
					{
			%>
						<a class="LinkPage" href="#" onclick="MoveNBoardList(<%=PageNum+1 %>, 'Current');"><%=PageNum+1 %>&nbsp;&nbsp;&nbsp;</a>
			<%
					}
					else
					{
			%>
						<a class="LinkPageCurrent" href="#"><%=PageNum+1 %>&nbsp;&nbsp;&nbsp;</a>
			<%
					}
				}
			%>
					</td>
				</tr>
			<%------------------------------------------------------------------
				게시판 갱신/새글쓰기/게시글 이동 만들기(처음/이전/다음/마지막)
			----------------------------------------------------------------------%>
				<tr class="Move">
					<td colspan=10>
			<%
				if (sNBoardVectorState.equals("First") == true)
				{
			%>
						<a class="MoveDeactive" href="#">처음</a>&nbsp;&nbsp;&nbsp;
						<a class="MoveDeactive" href="#">이전</a>&nbsp;&nbsp;&nbsp;
						<a class="MoveActive"   href="#" onclick="MoveNBoardList(<%=nNBoardPageNum %>, 'Next');">다음</a>&nbsp;&nbsp;&nbsp;
						<a class="MoveActive"   href="#" onclick="MoveNBoardList(<%=nNBoardPageNum %>, 'Last');">마지막</a>
			<%
				}
				else if (sNBoardVectorState.equals("Middle") == true)
				{
			%>
						<a class="MoveActive"	href="#" onclick="MoveNBoardList(<%=nNBoardPageNum %>, 'First');">처음</a>&nbsp;&nbsp;&nbsp;
						<a class="MoveActive"	href="#" onclick="MoveNBoardList(<%=nNBoardPageNum %>, 'Before');">이전</a>&nbsp;&nbsp;&nbsp;
						<a class="MoveActive"	href="#" onclick="MoveNBoardList(<%=nNBoardPageNum %>, 'Next');">다음</a>&nbsp;&nbsp;&nbsp;
						<a class="MoveActive"	href="#" onclick="MoveNBoardList(<%=nNBoardPageNum %>, 'Last');">마지막</a>
			<%
				}
				else if (sNBoardVectorState.equals("Last") == true)
				{
			%>
						<a class="MoveActive"   href="#" onclick="MoveNBoardList(<%=nNBoardPageNum %>, 'First');">처음</a>&nbsp;&nbsp;&nbsp;
						<a class="MoveActive"   href="#" onclick="MoveNBoardList(<%=nNBoardPageNum %>, 'Before');">이전</a>&nbsp;&nbsp;&nbsp;
						<a class="MoveDeactive" href="#">다음</a>&nbsp;&nbsp;&nbsp;
						<a class="MoveDeactive" href="#">마지막</a>
			<%
				}
				else
				{
			%>
						<a class="MoveDeactive" href="#">- 게시글 내용이 없거나 게시글 검색에 문제가 있습니다 -</a>
			<%
				}
			%>
					</td>
				</tr>
				<tr class="Move">
					<td colspan=10>
						<input class="Submit" type="button" value=" 게시판 갱신 "		onclick="MoveNBoardList(<%=nNBoardPageNum %>, 'Current');">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input class="Submit" type="button" value=" 글쓰기(예시포함) "	onclick="MoveNBoardDetail(<%=nNBoardPageNum %>, <%=nNBoardId %>, 'Ex');">
					</td>
				</tr>
			</table>
			<%------------------------------------------------------------------
				페이지 이동
			----------------------------------------------------------------------%>
			<hr class="Line">
			<div class="Link">
				<a class="Link" href="../Index.jsp">INDEX 페이지로 돌아가기(Index.jsp)</a>
			</div>
			<hr class="Line">
		</div>
	</form>
	<%----------------------------------------------------------------------
	[HTML Page - END]
	--------------------------------------------------------------------------%>
	<%----------------------------------------------------------------------
	[HTML Page - 자바스크립트 구현 영역(하단)]
	[외부 자바스크립트 연결(각각) : <script type="text/javascript" src="Hello.js"></script>]
	--------------------------------------------------------------------------%>
	<script type="text/javascript">
		// -----------------------------------------------------------------
		// [사용자 함수 및 로직 구현]
		// -----------------------------------------------------------------
		
		// -----------------------------------------------------------------
	</script>
	<%------------------------------------------------------------------
	[JSP 페이지에서 바로 이동(바이패스)]
	----------------------------------------------------------------------%>
	<%------------------------------------------------------------------
	바이패스 방법1	: JSP forward 액션을 사용 한 페이지 이동
				:-------------------------------------------------------
				: page	- 이동 할 새로운 페이지 주소
				: name	- page 쪽에 전달 할 파라미터 명칭
				: value	- page 쪽에 전달 할 파라미터 데이터
				:		- page 쪽에서 request.getParameter("name1")로 읽음
				:-------------------------------------------------------
				: 이 방법은 기다리지 않고 바로 이동하기 때문에 현재 화면이 표시되지 않음
				: 브라우저 Url 주소는 현재 페이지로 유지 됨
	--------------------------------------------------------------------
	<jsp:forward page="Hello.jsp">
		<jsp:param name="name1" value='value1'/>
		<jsp:param name="name2" value='value2'/>
	</jsp:forward>
	--%>
	<%
		// -----------------------------------------------------------------
		//	바이패스 방법2	: RequestDispatcher을 사용 한 페이지 이동
		//				:---------------------------------------------------
		//				: sUrl	- 이동 할 새로운 페이지 주소
		//				:		- sUrl 페이지 주소에 GET 파라미터 전달 가능
		//				:		- sUrl 페이지가 갱신됨 즉,
		//				:		- sUrl 페이지 주소에 GET 파라미터 유무에 상관없이
		//				:		- sUrl 페이지 쪽에서 request.getParameter() 사용가능
		//				:-------------------------------------------------------
		//				: 이 방법은 기다리지 않고 바로 이동하기 때문에 현재 화면이 표시되지 않음
		//				: 브라우저 Url 주소는 현재 페이지로 유지 됨
		// -----------------------------------------------------------------
		// String sUrl = "Hello.jsp?name1=value1&name2=value2";
		//
		// RequestDispatcher dispatcher = request.getRequestDispatcher(sUrl);
		// dispatcher.forward(request, response);
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
		//String sUrl = "Hello.jsp?name1=value1&name2=value2";
		//
		//response.sendRedirect(sUrl);
		// -----------------------------------------------------------------
	%>
</body>
</html>
