<%@page import="java.text.MessageFormat"%>
<%@page import="Common.ComMgr"%>
<%@page import="BeansHome.Sawon.SawonDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="BeansHome.Sawon.SawonDAO"%>
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
	<meta http-equiv="Expires" content="-1"/>
	<meta http-equiv="Pragma" content="no-cache"/>
    <meta name="Description" content="검색 엔진을 위해 웹 페이지에 대한 설명을 명시"/>
    <meta name="keywords" content="검색 엔진을 위해 웹 페이지와 관련된 키워드 목록을 콤마로 구분해서 명시"/>
    <meta name="Author" content="문서의 저자를 명시"/>
	<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>사원정보 리스트 페이지(ArrayList)</title>
	<%----------------------------------------------------------------------
	[HTML Page - 스타일쉬트 구현 영역]
	[외부 스타일쉬트 연결 : <link rel="stylesheet" href="Hello.css?version=1.1"/>]
	--------------------------------------------------------------------------%>
	<link rel="stylesheet" href="CSS/SawonList.css?version=2.4"/>
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
	<script type="text/javascript" src="JS/SawonList.js"></script>
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
	// 부서명[코드]
	public String[] DeptInfo	= { "영업부[01]", "회계부[02]", "구매부[03]", "자재부[04]",
									"총무부[05]", "생산부[06]", "원가부[07]" };
	
	//사원정보 테이블 헤더
	public String[] SawonHead	= { "사원", "성명", "나이", "성별", "전화",
									"부서", "부서명", "직급", "직급명",
									"생일", "주소", "수정", "삭제" };
	
	// 사원정보 검색용 DAO 객체
	public SawonDAO sawonDAO = new SawonDAO();
	
	public String Id = "btnUpdate300";
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
	Boolean bJobProcess	= null;								// 파라미터 : 작업처리 - 사원정보 JobStatus 작업처리 허용 여부
	String  sJobStatus	= null;								// 파라미터 : 작업상태 - 사원정보 데이터베이스 작업상태(SELECT | INSERT | UPDATE | DELETE)
	String  sAge		= null;								// 파라미터 : 나이
	String  sGender		= null;								// 파라미터 : 성별
	String  sDept		= null;								// 파라미터 : 부서
	
	String  ScrollId	= null;								// 파라미터 : bJobProcess 작업처리 후 처리 위치까지 검색 결과를 Y축으로 스크롤하기 위한 Id
	// ---------------------------------------------------------------------
	// [JSP 지역 변수 선언 : 데이터베이스 파라미터]
	// ---------------------------------------------------------------------
	ArrayList<SawonDTO> Sawons = null;						// 사원정보 검색 결과용 ArrayList 객체 
	// ---------------------------------------------------------------------
	// [JSP 지역 변수 선언 : 일반 변수]
	// ---------------------------------------------------------------------
	String sGenderName		= null;							// 성별명
	String[] oDept			= null;							// 부서명/부서코드 분리용
	String sSelected		= null;							// 부서 콤보박스 유지용
	String sSawonDeleteCall	= null;							// 사원정보 삭제 함수 호출용
	String sModalSrc		= null;							// 사원정보 신규등록/수정 모달 창 경로용
	
	Integer nRowCount		= 0;							// 사원정보 검색 레코드 수
	Boolean bContinue		= false;						// 사원정보 검색 유무
	// ---------------------------------------------------------------------
	// [웹 페이지 get/post 파라미터 조건 필터링]
	// ---------------------------------------------------------------------
	bJobProcess	= ComMgr.IsNull(request.getParameter("JobProcess"), false);		// 파라미터 : 작업처리 : null 확인(false : 아무동작 없음)
	sJobStatus	= ComMgr.IsNull(request.getParameter("jobstatus"), "SELECT");	// 파라미터 : 작업상태 : null 확인(SELECT : 사원정보 검색)
	sAge		= ComMgr.IsNull(request.getParameter("age"), 0).toString();		// 파라미터 : 나이 : null 확인(0 : 전체)
	sGender		= ComMgr.IsNull(request.getParameter("gender"), "-1");			// 파라미터 : 성별 : null 확인(-1 : 전체)
	sDept		= ComMgr.IsNull(request.getParameter("dept"), "-1");			// 파라미터 : 부서 : null 확인(-1 : 전체)
	
	ScrollId	= ComMgr.IsNull(request.getParameter("ScrollId"), "");			// 파라미터 : Y축으로 스크롤하기 위한 Id('' : 아무동작 없음)
	
	// ---------------------------------------------------------------------
	// [일반 변수 조건 필터링]
	// ---------------------------------------------------------------------
	// 사원정보 신규등록 버튼용 모달 창 src(주소) 만들기
	sModalSrc = MessageFormat.format("SawonDetail.jsp?JobProcess={0}&jobstatus={1}", false, "INSERT");
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
	<jsp:useBean id="SawonDTO" class="BeansHome.Sawon.SawonDTO" scope="request"></jsp:useBean>
	
	<%----------------------------------------------------------------------
	Beans 속성 지정 방법1	: Beans Property에 * 사용
						:---------------------------------------------------
						: name		- <jsp:useBean>의 id
						: property	- HTML 태그 입력양식 객체 전체
						:---------------------------------------------------
	주의사항				: HTML 태그의 name 속성 값은 소문자로 시작!
						: HTML 태그에서 데이터 입력 없는 경우 null 입력 됨!
	------------------------------------------------------------------------
	<jsp:setProperty name="SawonDTO" property="*"/>
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
	// bJobProcess 작업처리 허용인 경우 검색을 위한 조건을 DTO에 넣기
	if (bJobProcess == true)
	{
		SawonDTO.setAge(Integer.valueOf(sAge));
		SawonDTO.setGender(sGender);
		SawonDTO.setDept(sDept);
	}
%>
<%--------------------------------------------------------------------------
[Beans DTO 읽기 및 로직 구현 영역]
------------------------------------------------------------------------------%>
<%
	// bJobProcess 작업처리 허용 && 검색인 경우 사원정보 검색
	if (bJobProcess == true && sJobStatus.equals("SELECT") == true)
	{
		// 사원정보 검색 결과용 ArrayList 객체 생성
		Sawons = new ArrayList<SawonDTO>(); 
		
		// 사원정보 검색
		if (this.sawonDAO.ReadSawonList(SawonDTO, Sawons) == true)
		{
			if (this.sawonDAO.DBMgr != null && this.sawonDAO.DBMgr.Rs != null)
			{
				bContinue = true;
			}
		}
	}
%>
<body class="Body">
	<%----------------------------------------------------------------------
	[HTML Page - FORM 디자인 영역]
	--------------------------------------------------------------------------%>
	<form name="form1" action="SawonList_Ar.jsp?JobProcess=true&jobstatus=SELECT" method="post">
		<%------------------------------------------------------------------
			모달 창 아래 메인 페이지
		----------------------------------------------------------------------%>
		<div id="divModalParent">
			<%------------------------------------------------------------------
				Top 고정 영역
			----------------------------------------------------------------------%>
			<div class="Top-Fixed" id="TopArea">
				<%------------------------------------------------------------------
					타이틀
				----------------------------------------------------------------------%>
				<hr  class="Line">
				<div class="Title">JSP 사원검색(Use JSP/Beans/ArrayList)</div>
				<hr  class="Line">
				<%------------------------------------------------------------------
					조건 입력필드 & 검색 & 신규등록 버튼
				----------------------------------------------------------------------%>
				<input class="NumData"  type="hidden" id ="ScrollId" name="scrollid" value="<%=request.getParameter("scrollid") %>"/>
				&nbsp;
				<label class="Label"    for="Age">나이</label>&nbsp;
				<input class="NumData"  type="number" id="Age"   name="age"    value="<%=sAge %>">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<label class="Label"    for="All">성별</label>
				<input class="RdoData"  type="radio"  id="All"   name="gender" value="-1" <%=(sGender.equals("-1")) ? "checked" : "" %>><label class="Label"   for="All">전체</label>
				<input class="RdoData"  type="radio"  id="Man"   name="gender" value="1"  <%=(sGender.equals("1"))  ? "checked" : "" %>><label class="Label"   for="Man">남성</label>
				<input class="RdoData"  type="radio"  id="Woman" name="gender" value="0"  <%=(sGender.equals("0"))  ? "checked" : "" %>><label class="Label"   for="Woman">여성</label>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<label class="Label"    for="Dept">부서</label>&nbsp;
				<select class="CmbData" id="Dept" name="dept">
					<option value="-1" selected>-전 체-</option>
				<%------------------------------------------------------------------
					부서정보 콤보박스 동적으로 생성하기(표현식 사용)
				----------------------------------------------------------------------%>
				<%
					for(String dept : this.DeptInfo)
					{
						// Java에서 '['를 정규식으로 인식해서 ','로 변경 후 분리
						oDept = dept.replace("[", ",").replace("]", "").split(","); 
						
						sSelected = (sDept.equals(oDept[1]) == true) ? "selected" : "";
				%>
						<option value="<%=oDept[1] %>" <%=sSelected %>><%=oDept[0] %></option>
				<%
					}
				%>
				</select>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input class="Submit" type="submit" id="Submit" value=" SEARCH [ Rows:<%=nRowCount %> ] " onclick="WindowScrollSetId('ScrollId', '')">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input class="Submit" type="button" id="NewSawon" value=" 사원정보 신규등록 " onclick="ShowModalWindow('<%=sModalSrc %>');">
				<hr class="Line">
			</div>
			<%------------------------------------------------------------------
				Middle 고정 영역
			----------------------------------------------------------------------%>
			<div class="Middle-Fixed" id="MiddleArea">
				<%------------------------------------------------------------------
					사원검색 결과 테이블 동적으로 생성하기(스크립트립 사용)
				----------------------------------------------------------------------%>
				<table class="Table">
					<tr class="TableHead">
					<%
						// 사원정보 테이블 헤더 만들기
						for(String sHead : this.SawonHead)
						{
							out.println(String.format("<th>%s</th>", sHead));
						}
					%>
					</tr>
					<%
						if (bContinue == true)
						{
							// 사원정보 출력하기
							for(SawonDTO Sawon : Sawons)
							{
								// 성별명 만들기
								sGenderName = ComMgr.IsNull(Sawon.getGender(), "");
								if (sGenderName.equals("1") == true) sGenderName = "남성";
								if (sGenderName.equals("0") == true) sGenderName = "여성";
								
								// 사원정보 삭제 버튼용 javascript 만들기(삭제 함수 호출용)
								sSawonDeleteCall = String.format("SawonDelete(%d, '%s', '%s', '%s', '%s', '%s', '%s')",
																  Sawon.getSabun(), Sawon.getName(),
																  sAge, sGender, sDept,
																  Sawon.getDeptname(), Sawon.getStcdname());
		
								// 사원정보 수정 버튼용 모달 창 src(주소) 만들기
								sModalSrc = String.format("SawonDetail.jsp?JobProcess=%s&jobstatus=%s&sabun=%d",
										 				  "false", "UPDATE", Sawon.getSabun());
	
					%>
					<tr class="TableRow">
					<%
								out.println(String.format("<td id='ScrollId-%d'>%d</td>",	Sawon.getSabun(), Sawon.getSabun()));
								out.println(String.format("<td>%s</td>",	Sawon.getName()));
								out.println(String.format("<td>%d</td>",	Sawon.getAge()));
								out.println(String.format("<td>%s</td>",	sGenderName));
								out.println(String.format("<td>%s</td>",	Sawon.getTel()));
								out.println(String.format("<td>[%s]</td>",	Sawon.getDept()));
								out.println(String.format("<td>%s</td>",	Sawon.getDeptname()));
								out.println(String.format("<td>[%s]</td>",	Sawon.getStcd()));
								out.println(String.format("<td>%s</td>",	Sawon.getStcdname()));
								out.println(String.format("<td>%s</td>",	Sawon.getBdate()));
								out.println(String.format("<td>%s</td>",	Sawon.getAddress()));
								
								nRowCount = nRowCount + 1;
					%>
						<td><a     class="UpdateLink" id="btnUpdate<%=nRowCount %>" onclick="UpdateSetColor('btnUpdate<%=nRowCount %>'); ShowModalWindow('<%=sModalSrc %>');">[수정]</a></td>
						<td><input class="DeleteBtn"  id="btnDelete<%=nRowCount %>" type="button" value="삭제" onclick="<%=sSawonDeleteCall %>"/></td>
					</tr>
					<%
							}
							
							this.sawonDAO.DBMgr.DbDisConnect();
						}
					%>
				</table>
				<script type="text/javascript">PrintRowCount("Submit", " SEARCH [ Rows:<%=nRowCount %> ] ")</script>
			</div>
			<%------------------------------------------------------------------
				Bottom 고정 영역
			----------------------------------------------------------------------%>
			<div class="Bottom-Fixed" id="BottomArea">
				<%------------------------------------------------------------------
					페이지 이동
				----------------------------------------------------------------------%>
				<hr class="Line">
				<div class="Link">
					<a class="Link" href="../Index.jsp">INDEX 페이지로 돌아가기(Index.jsp)</a>
					<%
					out.println(String.format("<span class='RowsData'>&nbsp;< 검색결과 : %d 명 ></span>", nRowCount));
					%>
				</div>
				<hr class="Line">
			</div>
	    </div>
		<%------------------------------------------------------------------
		[모달 창 페이지 - START]
		----------------------------------------------------------------------%>
		<div class="Modal-Frame" id="divModalFrame">
	        <div class="Modal-Content">
	            <span class="Modal-Close" id="btnClose">&times;&nbsp;</span>
	            <iframe class="Modal-Window" id="ifModalWindow"></iframe>
	        </div>
        </div>
		<%------------------------------------------------------------------
		[모달 창 페이지 - END]
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
		WindowScrollToId('<%=request.getParameter("scrollid") %>')
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
