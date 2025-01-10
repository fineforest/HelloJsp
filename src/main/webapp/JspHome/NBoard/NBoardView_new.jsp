<%@page import="Common.ComMgr"%>
<%@page import="BeansHome.NBoard.NBoardDAO"%>
<%@page import="java.io.InputStream"%>
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
    <title>게시판 글보기 페이지</title>
	<%----------------------------------------------------------------------
	[HTML Page - 스타일쉬트 구현 영역]
	[외부 스타일쉬트 연결 : <link rel="stylesheet" href="Hello.css?version=1.1"/>]
	--------------------------------------------------------------------------%>
	<link rel="stylesheet" href="CSS/NBoardView.css?version=1.1"/>
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
		window.onload = function() { LoadContentViewer(); }
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
		// 저장한 게시글 내용을 글보기용 Html 형식으로 변환(태그가 반영되어 보이도록)
		function LoadContentViewer()
		{
			let Content = document.getElementById('Content').value;
			
			document.getElementById('ContentViewer').innerHTML = ToContentViewerHtml(Content);
		}
		// 저장한 게시글 내용을 글보기용 Html 형식으로 변환(입력한 태그가 반영되어 보이도록)
		// 붙여넣은 이미지 태그<img> 또는 엔터 태그<div><br></div>는 복원
		function ToContentViewerHtml(Content)
		{
			// div가 자동으로 만든 태그를 복원하고 임의로 입력한 태그도 반영되어 보이도록 변환
			let ContentHtml = Content.replaceAll('&lt;', '<').replaceAll('&gt;', '>')
									 .replaceAll('&br;', '<br>')
									 .replaceAll('&imgl;', '<img')
									 .replaceAll('&imgr;', '>');
			
			return ContentHtml;
		}
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
	Integer nNBoardId			= null;		// 게시글 Id
	String  sNBoardIdVector		= null;		// 게시글 Id 이동 방향(First, Before, Current, Next, Last)
	// ---------------------------------------------------------------------
	// [JSP 지역 변수 선언 : 데이터베이스 파라미터]
	// ---------------------------------------------------------------------
	String sAuthor				= null;		// 작성자
	String sSubject				= null;		// 글제목
	String sEMail				= null;		// E-Mail
	String sDateTime			= null;		// 등록일(년/월/일 시:분:초)
	String sAttachYn			= null;		// 첨부파일 유무(Y/N)
	String sContent				= null;		// 글내용
	String sNBoardIdVectorState = null;		// 게시글 Id 위치상태(First, Last, Middle)
	// ---------------------------------------------------------------------
	// [JSP 지역 변수 선언 : 일반 변수]
	// ---------------------------------------------------------------------
	String sUrl					= null;		// 이동 할 페이지 경로용
	Boolean bContinue			= false;	// 게시글 보기 진행 여부
	// ---------------------------------------------------------------------
	// [웹 페이지 get/post 파라미터 조건 필터링]
	// ---------------------------------------------------------------------
	// 검색 할 게시판 페이지 번호 파라미터 읽기
	nNBoardPageNum = ComMgr.IsNull(request.getParameter("NBoardPageNum"), 1);
	
	// 검색 할 게시글 번호 파라미터 읽기
	nNBoardId = ComMgr.IsNull(request.getParameter("NBoardId"), 1);
	
	// 게시글 Id 이동 방향 파라미터 읽기
	sNBoardIdVector = ComMgr.IsNull(request.getParameter("NBoardIdVector"), "First");
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
	// ---------------------------------------------------------------------
	// 오라클 데이터베이스에서 게시글 상세정보 읽기(Beans DTO 사용)
	// ---------------------------------------------------------------------
	if (nNBoardId > 0 && nboardDAO.ReadBoardDetail(nNBoardId, sNBoardIdVector) == true)
	{
		if (nboardDAO.DBMgr != null && nboardDAO.DBMgr.Rs != null)
		{
			if (nboardDAO.DBMgr.Rs.next() == true)
			{
				nNBoardId			= nboardDAO.DBMgr.Rs.getInt("NBoardId");
				sAuthor				= nboardDAO.DBMgr.Rs.getString("Author");
				sSubject			= nboardDAO.DBMgr.Rs.getString("Subject");
				sEMail				= nboardDAO.DBMgr.Rs.getString("EMail");
				sDateTime			= nboardDAO.DBMgr.Rs.getString("DateTime");
				sAttachYn			= nboardDAO.DBMgr.Rs.getString("AttachYn");
				sContent			= nboardDAO.DBMgr.Rs.getString("Content");
				sNBoardIdVectorState= nboardDAO.DBMgr.Rs.getString("NBoardIdVectorState");
				// ---------------------------------------------------------
				// 게시글 작성자/이메일은 태그 허용하지 않음. 글제목만 태그 허용
				// 게시글 글내용은 '\n' -> <br>, SPACE -> &nbsp; 로 변경(중요!)
				// ---------------------------------------------------------
				sAuthor				= sAuthor.replace("<", "").replace(">", "");
				sEMail				= sEMail.replace("<", "").replace(">", "");
				//sContent			= sContent.replace("\r", "<br>").replace(" ", "&nbsp;");
				/*sContent			= sContent.replace("&lt;", "<").replace("&gt;", ">")
											  .replaceAll("&br;", "<br>")
											  .replaceAll("&imgl;", "<img")
											  .replaceAll("&imgr;", ">");*/
				// ---------------------------------------------------------
				bContinue			= true;
			}
			
			if (nboardDAO.DBMgr != null) nboardDAO.DBMgr.DbDisConnect();
		}
	}
	// ---------------------------------------------------------------------
	out.println(String.format("alert(%d);", sContent.length()));
%>
<body class="Body">
	<%----------------------------------------------------------------------
	[HTML Page - FORM 디자인 영역]
	--------------------------------------------------------------------------%>
	<form name="form1" action="" method="post">
		<%------------------------------------------------------------------
			타이틀
		----------------------------------------------------------------------%>
		<hr class="Line">
		<div  class="Title">게시판 글보기</div>
		<hr class="Line">
		<%------------------------------------------------------------------
			게시글 상세정보 View 만들기
		----------------------------------------------------------------------%>
		<%
		if (bContinue == true)		// 게시글 보기 진행 여부
		{
		%>
		<div class="NBoard">
			<table class="NBoard_Table" border="1">
				<tr class="NBoard_Title">
					<td class="NBoard_Col1">
						작성자 : <%=sAuthor %><br>
						이메일 : <%=sEMail %><br>
					</td>
					<td class="NBoard_Col2">
						작성일 : <%=sDateTime %>&nbsp;
						첨부(<%=sAttachYn %>)
					</td>
				</tr>
				<tr class="NBoard_Subject">
					<td colspan="2"><%=sSubject %></td>
				</tr>
				<tr class="NBoard_Content">
<!--			<td colspan="2" class="NBoard_Content_Col">???</td>
 -->
 
 
					<td colspan="2" class="NBoard_Content_Col">
						<div class="ContentViewer" contenteditable="false"  id="ContentViewer"></div>
						<input type="text" id="Content" name="txtContent" value='<%=sContent %>' style="width:100%"/>
					</td>
					
					
					
				</tr>
		<%
			if (sAttachYn.equals("Y") == true)
			{
				// 첨부파일(이미지) 불러와서 보여주기
				sUrl = String.format("/HelloJsp/ServletNBoardImageRead?NBoardId=%d", nNBoardId);
		%>
				<tr class="NBoard_Image">
					<td colspan="2" class="Image_Col">
						<img class="Image" id="NBoardImage" name="imgNBoardImage" src="<%=sUrl %>" onerror="this.style.display='none'" alt="">
					</td>
				</tr>
		<%
			}
		%>
		<%------------------------------------------------------------------
			게시글 이동 만들기(처음/이전/다음/마지막)
		----------------------------------------------------------------------%>
				<tr class="Move">
					<td colspan="2">
		<%
			if (sNBoardIdVectorState.equals("First") == true)
			{
		%>
						<a class="MoveDeactive" href="#">처음</a>&nbsp;&nbsp;&nbsp;
						<a class="MoveDeactive" href="#">이전</a>&nbsp;&nbsp;&nbsp;
						<a class="MoveActive"   href="#" onclick="MoveNBoardView(<%=nNBoardPageNum %>, <%=nNBoardId %>, 'Next');">다음</a>&nbsp;&nbsp;&nbsp;
						<a class="MoveActive"   href="#" onclick="MoveNBoardView(<%=nNBoardPageNum %>, <%=nNBoardId %>, 'Last');">마지막</a>
		<%
			}
			else if (sNBoardIdVectorState.equals("Last") == true)
			{
		%>
						<a class="MoveActive"   href="#" onclick="MoveNBoardView(<%=nNBoardPageNum %>, <%=nNBoardId %>, 'First');">처음</a>&nbsp;&nbsp;&nbsp;
						<a class="MoveActive"   href="#" onclick="MoveNBoardView(<%=nNBoardPageNum %>, <%=nNBoardId %>, 'Before');">이전</a>&nbsp;&nbsp;&nbsp;
						<a class="MoveDeactive" href="#">다음</a>&nbsp;&nbsp;&nbsp;
						<a class="MoveDeactive" href="#">마지막</a>
		<%
			}
			else
			{
		%>
						<a class="MoveActive"	href="#" onclick="MoveNBoardView(<%=nNBoardPageNum %>, <%=nNBoardId %>, 'First');">처음</a>&nbsp;&nbsp;&nbsp;
						<a class="MoveActive"	href="#" onclick="MoveNBoardView(<%=nNBoardPageNum %>, <%=nNBoardId %>, 'Before');">이전</a>&nbsp;&nbsp;&nbsp;
						<a class="MoveActive"	href="#" onclick="MoveNBoardView(<%=nNBoardPageNum %>, <%=nNBoardId %>, 'Next');">다음</a>&nbsp;&nbsp;&nbsp;
						<a class="MoveActive"	href="#" onclick="MoveNBoardView(<%=nNBoardPageNum %>, <%=nNBoardId %>, 'Last');">마지막</a>
		<%
			}
		%>
					</td>
				</tr>
			</table>
		</div>
		<%
		}
		else
		{
		%>
		<%------------------------------------------------------------------
			오류 페이지 만들기
		----------------------------------------------------------------------%>
		<%
		}
		%>
		<%------------------------------------------------------------------
			페이지 이동
		----------------------------------------------------------------------%>
		<br>
		<hr class="Line">
		<div class="Link">
			<a class="Link" href="NBoardList.jsp?NBoardPageNum=<%=nNBoardPageNum %>&NBoardVector=Current">게시판 목록 페이지로 돌아가기(NBoardList.jsp)</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a class="Link" href="../Index.jsp">INDEX 페이지로 돌아가기(Index.jsp)</a>
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
