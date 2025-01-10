<%@page import="Common.ComMgr"%>
<%@page import="BeansHome.NBoard.NBoardDAO"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="org.apache.commons.io.FileUtils"%>
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
    <title>게시판 저장 페이지</title>
	<%----------------------------------------------------------------------
	[HTML Page - 스타일쉬트 구현 영역]
	[외부 스타일쉬트 연결 : <link rel="stylesheet" href="Hello.css?version=1.1"/>]
	--------------------------------------------------------------------------%>
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
	Integer nNBoardPageNum	= null;				// 게시판 페이지 번호
	Integer nNBoardId		= null;				// 게시글 Id
	String  sJopStatus		= null;				// 작업상태(Insert | Update | Delete)
	
	// 게시글 기본 정보 변수
	String txtAuthor		= null;				// 작성자
	String txtSubject		= null;				// 글제목
	String txtEMail			= null;				// E-Mail
	String txtContent		= null;				// 글내용
	// ---------------------------------------------------------------------
	// [JSP 지역 변수 선언 : 데이터베이스 파라미터]
	// ---------------------------------------------------------------------
	// 업로드 첨부파일(이미지) 기본 정보 변수 => 나중에 다중 첨부파일을 처리 하려면 여기를 첨부파일 수 만큼 배열로 선언
	String sUploadFileNameOrigin	= null;		// 업로드 첨부파일(이미지) 원래이름
	String sUploadFileNameChange	= null;		// 업로드 첨부파일(이미지) 바뀐이름(중복방지를 위해 자동으로 바뀜)
	File oUploadFile				= null;		// 업로드 첨부파일(이미지) 정보 객체
	String sUploadFileType			= null;		// 업로드 첨부파일(이미지) 타입(ex : image/jpeg)
	Long nUploadFileLength			= null;		// 업로드 첨부파일(이미지) 길이
	byte[] oUploadFileData			= null;		// 업로드 첨부파일(이미지) 바이트 배열
	// ---------------------------------------------------------------------
	// [JSP 지역 변수 선언 : 일반 변수]
	// ---------------------------------------------------------------------
	// 게시글 정보 수집용 변수 및 객체
	MultipartRequest oMultipartRequest = null;	// 업로드 첨부파일(이미지)의 모든 정보를 담고있는 객체
	Enumeration<?> oFiles			= null;		// 업로드 첨부파일(이미지)의 <input type="file" name="file1"> 태그 정보 객체
	String  sFileTagName			= null;		// 업로드 첨부파일(이미지)의 <input type="file" name="file1">의 name 속성 정보
	String  sUploadFilePath			= null;		// 업로드 첨부파일(이미지)이 저장 될 서버쪽 업로드 임시폴더 전체 경로
	Integer nMaxUploadFileLength	= null;		// 업로드 첨부파일(이미지) 최대 크기
	
	Boolean bContinue 				= false;	// 게시글 저장(등록/수정/삭제) 진행 여부
	// ---------------------------------------------------------------------
	// [웹 페이지 get/post 파라미터 조건 필터링]
	// ---------------------------------------------------------------------
	// 검색 할 게시판 페이지 번호 파라미터 읽기
	nNBoardPageNum = ComMgr.IsNull(request.getParameter("NBoardPageNum"), 1);
	
	// MultipartRequest 객체를 사용 한 게시글 등록/수정 파라미터 읽기
	// 업로드 첨부파일(이미지)이 저장 될 서버쪽 업로드 임시폴더 전체 경로
	// JSP 루트에 UploadImageFiles 폴더 생성 해야 함!
	sUploadFilePath = application.getRealPath("/UploadImageFiles");
	
	// 업로드 첨부파일(이미지) 길이 초기화
	nUploadFileLength = 0L;
	
	// 업로드 첨부파일(이미지) 최대 크기 지정
	nMaxUploadFileLength = 1024 * 1024 * 1024;
	
	// 업로드 첨부파일(이미지) 정보 객체 생성
	// 첨부파일(이미지) 객체가 있는 페이지에서 폼 태그에 enctype="multipart/form-data" 있는 경우만 가능
	try
	{
		oMultipartRequest = new MultipartRequest(request, sUploadFilePath, nMaxUploadFileLength,
												 "utf-8", new DefaultFileRenamePolicy());
	}
	// 첨부파일(이미지) 객체가 없는 페이지에서 post/get 방식으로 호출한 경우
	catch (Exception Ex)
	{
		// -----------------------------------------------------------------
		// 게시판 목록 페이지에서 게시글 삭제하는 경우 MultipartRequest 객체 생성 시 오류 발생
		// 여기에 오게되면 게시글 삭제 작업이므로 상관 없이 진행해도 무관
		// 게시글 삭제를 위한 파라미터 읽기
		// -----------------------------------------------------------------
		nNBoardId  = ComMgr.IsNull(request.getParameter("NBoardId"), 0);
		sJopStatus = ComMgr.IsNull(request.getParameter("JopStatus"), "");
		// -----------------------------------------------------------------
		// 삭제 작업이 아니고 try 부분에서 오류 발생되는 경우가 있음!
		// 이경우는 이미지 임시저장 폴더가 없는 경우 발생할 수 있음!
		// 반드시 이미지 임시저장 폴더를 생성 해야 함! => UploadImageFiles
		// -----------------------------------------------------------------
	}
	
	// 게시글 등록 및 수정인 경우만 해당
	if (oMultipartRequest != null)
	{
		// -----------------------------------------------------------------
		// 게시글 기본 정보 파라미터 읽기
		// -----------------------------------------------------------------
		sJopStatus	= oMultipartRequest.getParameter("txtJopStatus");
		nNBoardId	= Integer.parseInt(oMultipartRequest.getParameter("txtNBoardId"));
		
		txtAuthor	= oMultipartRequest.getParameter("txtAuthor");
		txtSubject	= oMultipartRequest.getParameter("txtSubject");
		txtEMail	= oMultipartRequest.getParameter("txtEMail");
		txtContent	= oMultipartRequest.getParameter("txtContent");
		// -----------------------------------------------------------------
		// 업로드 첨부파일(이미지) 기본 정보 파라미터 읽기
		// -----------------------------------------------------------------
		// 업로드 첨부파일(이미지)의 <input type="file" name="file1"> 의
		// 태그 정보 객체 가져오기(다중 업로드 구현 가능) 
		oFiles = oMultipartRequest.getFileNames();
		// -----------------------------------------------------------------
		// 업로드 첨부파일(이미지)이 여러개인 경우를 대비(다중 업로드 구현 가능)
		// -----------------------------------------------------------------
		while(oFiles.hasMoreElements())
		{
			// 업로드 첨부파일(이미지)의 <input type="file" name="file1"> 태그의 name 속성 읽기
			sFileTagName = (String)oFiles.nextElement();
			
			sUploadFileNameOrigin	= oMultipartRequest.getOriginalFileName(sFileTagName);
			sUploadFileNameChange	= oMultipartRequest.getFilesystemName(sFileTagName);
			sUploadFileType			= oMultipartRequest.getContentType(sFileTagName);
			oUploadFile				= oMultipartRequest.getFile(sFileTagName);
		
			if (oUploadFile != null)
			{
				// 업로드 첨부파일(이미지) 길이 구하기
				nUploadFileLength = oUploadFile.length();
				
				// 업로드 첨부파일(이미지) 데이터 저장
				oUploadFileData = FileUtils.readFileToByteArray(oUploadFile);
				
				// 업로드 첨부파일(이미지) 삭제(임시 보관 폴더:/UploadImageFiles)
				oUploadFile.delete();
			}
		}
		// -----------------------------------------------------------------
		// 선택한 게시글 저장(등록/수정)용 파라미터 확인(작성자 & 글제목 & 이메일 & 글내용)
		// -----------------------------------------------------------------
		if (sJopStatus != null				&&
			txtAuthor.trim().length() > 0	&& txtSubject.trim().length() > 0	&&
			txtEMail.trim().length()  > 0	&& txtContent.trim().length() > 0)
			bContinue = true;
	}
	// 게시글 삭제인 경우만 해당
	else
	{
		// 선택 한 게시글 삭제용 파라미터 확인
		if (sJopStatus != null && nNBoardId > 0) bContinue = true;
	}
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
	--------------------------------------------------------------------------%>
	<jsp:useBean id="NBoardDTO" class="BeansHome.NBoard.NBoardDTO" scope="request"></jsp:useBean>
	
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
	// 게시글 저장을 위해 게시글 정보 저장용 데이터 DTO에 넣기
	// 게시글 등록 및 수정인 경우만 해당
	if (oMultipartRequest != null && bContinue == true)
	{
		// 게시글 기본 정보
		NBoardDTO.setTxtAuthor(txtAuthor);
		NBoardDTO.setTxtSubject(txtSubject);
		NBoardDTO.setTxtEMail(txtEMail);
		NBoardDTO.setTxtContent(txtContent);
		// 업로드 첨부파일(이미지) 기본 정보
		NBoardDTO.setUploadFileNameOrigin(sUploadFileNameOrigin);
		NBoardDTO.setUploadFileNameChange(sUploadFileNameChange);
		NBoardDTO.setUploadFile(oUploadFile);
		NBoardDTO.setUploadFileType(sUploadFileType);
		NBoardDTO.setUploadFileLength(nUploadFileLength);
		NBoardDTO.setUploadFileData(oUploadFileData);
	}
%>
<%--------------------------------------------------------------------------
[Beans DTO 읽기 및 로직 구현 영역]
------------------------------------------------------------------------------%>
<%
	// ---------------------------------------------------------------------
	// 게시글 저장(등록/수정/삭제) 진행 여부
	// ---------------------------------------------------------------------
	if (bContinue == true)
	{
		nboardDAO.NBoardSave(sJopStatus, nNBoardId, NBoardDTO);
	}
   	// ---------------------------------------------------------------------
%>
<body class="Body">
	<%----------------------------------------------------------------------
	[HTML Page - FORM 디자인 영역]
	--------------------------------------------------------------------------%>
	<form name="form1" action="" method="post">
		<%------------------------------------------------------------------
			메인 페이지
		----------------------------------------------------------------------%>
		
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
		String sUrl	= null;
		
		if (sJopStatus != null && sJopStatus.equals("Insert") == true)
			sUrl = "NBoardList.jsp?NBoardPageNum=1&NBoardVector=Current";
		else
			sUrl = String.format("NBoardList.jsp?NBoardPageNum=%s&NBoardVector=Current", nNBoardPageNum);
		
		RequestDispatcher dispatcher = request.getRequestDispatcher(sUrl);
		dispatcher.forward(request, response);
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
