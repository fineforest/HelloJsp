<%@page import="Common.ComMgr"%>
<%@page import="BeansHome.NBoard.NBoardDAO"%>
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
    <title>게시판 상세 페이지</title>
	<%----------------------------------------------------------------------
	[HTML Page - 스타일쉬트 구현 영역]
	[외부 스타일쉬트 연결 : <link rel="stylesheet" href="Hello.css?version=1.1"/>]
	--------------------------------------------------------------------------%>
	<link rel="stylesheet" href="CSS/NBoardDetail.css?version=1.1"/>
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
	String  sJopStatus			= null;		// 작업상태(Insert | Update | Ex)
	// ---------------------------------------------------------------------
	// [JSP 지역 변수 선언 : 데이터베이스 파라미터]
	// ---------------------------------------------------------------------
	String txtAuthor			= null;		// 작성자
	String txtSubject			= null;		// 글제목
	String txtEMail				= null;		// E-Mail
	String sDateTime			= null;		// 등록일(년/월/일 시:분:초)
	String sAttachYn			= null;		// 첨부파일 유무(Y/N)
	String txtContent			= null;		// 글내용
	// ---------------------------------------------------------------------
	// [JSP 지역 변수 선언 : 일반 변수]
	// ---------------------------------------------------------------------
	String  sTitleText			= null;		// 게시판 타이틀
	Boolean bContinue			= false;	// 게시글 등록/수정 진행 여부
	// ---------------------------------------------------------------------
	// [웹 페이지 get/post 파라미터 조건 필터링]
	// ---------------------------------------------------------------------
	// 검색 할 게시판 페이지 번호 파라미터 읽기
	nNBoardPageNum = ComMgr.IsNull(request.getParameter("NBoardPageNum"), 1);
	
	// 검색 할 게시글 번호 파라미터 읽기
	nNBoardId = ComMgr.IsNull(request.getParameter("NBoardId"), 1);
	
	// JopStatus : 한 페이지로 여러 일을 하기위한 작업상태 파라미터 읽기
	// ---------------------------------------------------------------------
	// Insert	 : 게시글 추가 - 모든 입력 필드를 비어 놓음(JopStatus 파라미터를 생략해도 동일)
	// Update	 : 게시글 수정 - 게시글을 검색해서 채워 놓음
	// Delete	 : 게시글 삭제 - 게시글을 삭제
	// Ex		 : 게시글 채움 - 예시글을 채워 놓음
	// ---------------------------------------------------------------------
	sJopStatus = ComMgr.IsNull(request.getParameter("JopStatus"), "");
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
switch (sJopStatus)
{
	case "Insert":
		sTitleText = "게시판 글쓰기";
		sJopStatus = "Insert";
		// -------------------------------------------------------------
		// 게시판 새글 쓰기
		// -------------------------------------------------------------
		txtAuthor	= "";
		txtSubject	= "";
		txtEMail	= "";
		sDateTime	= "";
		sAttachYn	= "";
		txtContent	= "";
		
		bContinue	= true;

		break;
	case "Ex":
		// -------------------------------------------------------------
		sTitleText	= "게시판 글쓰기(예시글 포함)";
		sJopStatus	= "Insert";
		// -------------------------------------------------------------
		// 예시글 채우기
		// -------------------------------------------------------------
		txtAuthor	= "홍길동";
		txtSubject	= "홍길동과 함께하는 JSP";
		txtEMail	= "hong@daum.net";
		txtContent	= String.format("%s\n%s\n%s\n%s\n%s\n\n%s\n\n%s\n",
									"홍길동은 그 누구보다도 JSP를 좋아 했습니다.",
									"또한 Servlet도 무척 좋아 했습니다.",
									"JSP의 복잡성을 Servlet으로 해결하며 즐거워 하던 어느날,",
									"홍길동은 Mr.빈의 소게로 Java.Bean을 만나게 되었습니다.",
									"Bean과의 만남은 홍길동의 인생에서 가장 흥미로운 것 이었습니다.",
									"그런데 말입니다!",
									"구란데 말입니다 ~ ...!");
		
		bContinue	= true;
		
		break;
	case "Update":
		// -------------------------------------------------------------
		sTitleText	= "게시판 글수정 페이지";
		// -------------------------------------------------------------
		// 오라클 데이터베이스에서 게시글 상세정보 읽기(Beans DTO 사용)
		// -------------------------------------------------------------
		if (nNBoardId > 0 && nboardDAO.ReadBoardDetail(nNBoardId, "Current") == true)
		{
			if (nboardDAO.DBMgr != null && nboardDAO.DBMgr.Rs != null)
			{
				if (nboardDAO.DBMgr.Rs.next() == true)
				{
					txtAuthor	= nboardDAO.DBMgr.Rs.getString("Author");
					txtSubject	= nboardDAO.DBMgr.Rs.getString("Subject");
					txtEMail	= nboardDAO.DBMgr.Rs.getString("EMail");
					sDateTime	= nboardDAO.DBMgr.Rs.getString("DateTime");
					sAttachYn	= nboardDAO.DBMgr.Rs.getString("AttachYn");
					txtContent	= nboardDAO.DBMgr.Rs.getString("Content");
					
					bContinue	= true;
				}
				
				if (nboardDAO.DBMgr != null) nboardDAO.DBMgr.DbDisConnect();
			}
		}
		
		break;
	case "Delete":
		// -------------------------------------------------------------
		// 오라클 데이터베이스에서 게시글 상세정보 삭제(Beans DTO 사용) 
		// -------------------------------------------------------------
		// 게시글 삭제 작업은 게시판 목록에서 직접 NBoardSave.jsp 페이지 호출해서 처리
		break;
		// -------------------------------------------------------------
}
%>
<body class="Body">
	<%----------------------------------------------------------------------
	[HTML Page - FORM 디자인 영역]
	--------------------------------------------------------------------------%>
	<form name="form1" action="NBoardSave.jsp?NBoardPageNum=<%=nNBoardPageNum %>" method="post" enctype="multipart/form-data">
		<%------------------------------------------------------------------
			타이틀
		----------------------------------------------------------------------%>
		<hr class="Line">
		<div class="Title"><%=sTitleText %></div>
		<hr class="Line">
		<%------------------------------------------------------------------
			입력필드 or 수정필드
		----------------------------------------------------------------------%>
		<%
		if (bContinue == true)		// 게시글 보기 진행 여부
		{
		%>
		<table class="Table">
			<tr class="TableRow">
				<td class="TableCol"><label class="Data"   for="Author">작성자<span class="Essential">*</span></label></td>
				<td><input class="Data"   type="text" id="Author" name="txtAuthor" value="<%=txtAuthor %>" required/></td>
			</tr>
 			<tr class="TableRow">
				<td class="TableCol"><label class="Data"   for="Subject">글제목<span class="Essential">*</span></label></td>
				<td><input class="Data"   type="text" id="Subject" name="txtSubject" value="<%=txtSubject %>" required/></td>
			</tr>
			<tr class="TableRow">
				<td class="TableCol"><label class="Data"   for="E-Mail">이메일<span class="Essential">*</span></label></td>
				<td><input class="Data"   type="text" id="E-Mail" name="txtEMail" value="<%=txtEMail %>" required/></td>
			</tr>
			<tr class="TableRow">
				<td class="TableCol"><label class="Data"   for="Content">글내용<span class="Essential">*</span></label></td>
				<td><textarea class="Content" id="Content" name="txtContent" cols="70" rows="7" required><%=txtContent %></textarea></td>
			</tr>
			<tr class="TableRow">
				<td class="TableCol"><label class="Data"   for="File">파일첨부</label></td>
				<td>
					<input class="Data"   type="file" id="File" name="txtFile" accept="image/*, video/*, audio/*" onchange="ReadImage(this, 'Preview');"/>
				</td>
			</tr>
			<tr class="TableRow">
				<td class="TableCol"><span class="Data">이미지</span></td>
				<td>
					<img class="Image" id="Preview" name="imgPreview" alt=""/>
				</td>
			</tr>
			<tr class="TableRow" align="left">
				<td class="TableCol" colspan="2">
					<input class="Submit" type="submit" value=" 글쓰기저장 "/>
					<input type="hidden" id="JopStatus" name="txtJopStatus" value="<%=sJopStatus %>"/>
					<input type="hidden" id="NBoardId"  name="txtNBoardId"  value="<%=nNBoardId %>"/>
				</td>
			</tr>
		</table>
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
		<hr class="Line">
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
