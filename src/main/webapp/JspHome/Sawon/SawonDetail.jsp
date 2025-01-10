<%@page import="BeansHome.Sawon.SawonDTO"%>
<%@page import="Common.ComMgr"%>
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
	<meta http-equiv="Expires" content="0"/>
	<meta http-equiv="pragma" content="no-cache"/>
    <meta name="Description" content="검색 엔진을 위해 웹 페이지에 대한 설명을 명시"/>
    <meta name="keywords" content="검색 엔진을 위해 웹 페이지와 관련된 키워드 목록을 콤마로 구분해서 명시"/>
    <meta name="Author" content="문서의 저자를 명시"/>
	<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>사원정보 상세 페이지</title>
	<%----------------------------------------------------------------------
	[HTML Page - 스타일쉬트 구현 영역]
	[외부 스타일쉬트 연결 : <link rel="stylesheet" href="Hello.css?version=1.1"/>]
	--------------------------------------------------------------------------%>
	<link rel="stylesheet" href="CSS/SawonDetail.css?version=1.6"/>
	<style type="text/css">
		/* -----------------------------------------------------------------
			HTML Page 스타일시트
		   -----------------------------------------------------------------
		
        ----------------------------------------------------------------- */
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
	<script type="text/javascript" src="JS/SawonDetail.js"></script>
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
	
	public String[] StCdInfo	= { "회장[01]", "사장[02]", "부사장[03]", "임원[04]", "부장[05]",
									"차장[06]", "과장[07]", "대리[08]",  "계장[09]", "사원[10]" };
	
	// 사원정보 추가/수정/삭제 처리용 DAO 객체
	public SawonDAO sawonDAO = new SawonDAO();
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
	String  sJobStatus	= null;								// 파라미터 : 작업상태 - 사원정보 데이터베이스 작업상태(INSERT | UPDATE | DELETE)
	String  sSabun		= null;								// 파라미터 : 사번
	String  sName		= null;								// 파라미터 : 성명
	String  sAge		= null;								// 파라미터 : 나이
	String  sGender		= null;								// 파라미터 : 성별
	String  sTel		= null;								// 파라미터 : 전화
	String  sDept		= null;								// 파라미터 : 부서
	String  sStCd		= null;								// 파라미터 : 직급
	String  sBDate		= null;								// 파라미터 : 생일
	String  sAddress	= null;								// 파라미터 : 주소
	// ---------------------------------------------------------------------
	// [JSP 지역 변수 선언 : 데이터베이스 파라미터]
	// ---------------------------------------------------------------------
	SawonDTO oSawonDTO	= null;								// 사원정보 수정 작업시 선 검색 결과용 객체 
	// ---------------------------------------------------------------------
	// [JSP 지역 변수 선언 : 일반 변수]
	// ---------------------------------------------------------------------
	String  sJobTitle	= null;								// 사원정보 작업 타이틀(INSERT | UPDATE)
	String[] oDept		= null;								// 부서명/부서코드 분리용
	String[] oStCd		= null;								// 직급명/직급코드 분리용
	String sSelected	= null;								// 부서/직급 콤보박스 유지용
	Boolean bDbSave		= null;								// 사원정보 Db 저장 결과
	String  sDbSaveMsg	= null;								// 사원정보 Db 저장 후 메시지
	String  sKeyCss		= null;								// 사번 Key CSS : JobStatus UPDATE인 경우 "readonly"
	// ---------------------------------------------------------------------
	// [웹 페이지 get/post 파라미터 조건 필터링]
	// ---------------------------------------------------------------------
	// 사원정보 신규등록 | 수정을 위해 파라미터 값 읽기
	bJobProcess	= ComMgr.IsNull(request.getParameter("JobProcess"), false);		// 파라미터 : 작업처리 : null 확인(true : 데이터베이스 작업)
	sJobStatus	= ComMgr.IsNull(request.getParameter("jobstatus"), "SELECT");	// 파라미터 : 작업상태 : null 확인(INSERT | UPDATE | DELETE)
	sSabun		= ComMgr.IsNull(request.getParameter("sabun"),	"");			// 파라미터 : 사번
	sName		= ComMgr.IsNull(request.getParameter("name"),	"");			// 파라미터 : 성명
	sAge		= ComMgr.IsNull(request.getParameter("age"),	"");			// 파라미터 : 나이
	sGender		= ComMgr.IsNull(request.getParameter("gender"),	"");			// 파라미터 : 성별
	sTel		= ComMgr.IsNull(request.getParameter("tel"),	"");			// 파라미터 : 성별
	sDept		= ComMgr.IsNull(request.getParameter("dept"),	"");			// 파라미터 : 부서
	sStCd		= ComMgr.IsNull(request.getParameter("stcd"),	"");			// 파라미터 : 직급
	sBDate		= ComMgr.IsNull(request.getParameter("bdate"),	"");			// 파라미터 : 생일
	sAddress	= ComMgr.IsNull(request.getParameter("address"),"");			// 파라미터 : 주소
	
	switch (sJobStatus)
	{
		case "INSERT":
			sJobTitle = "사원정보 신규등록";
			sKeyCss = "'KeyData'";
			
			break;
		case "UPDATE":
			sJobTitle = "사원정보 수정";
			sKeyCss = "'ReadonlyData' readonly";
			
			if (bJobProcess == false && sJobStatus.equals("UPDATE") == true)
			{
				sSabun = ComMgr.IsNull(request.getParameter("sabun"), "");		// 사번 파라미터 읽기
				
				// 사원정보 수정시 검색 결과용 객체 생성
				oSawonDTO = new SawonDTO();
				
				// 사원정보 수정 작업인 경우 먼저 사원 번호로 검색
				if (this.sawonDAO.ReadSawon(Integer.valueOf(sSabun), oSawonDTO) == true)
				{
					if (this.sawonDAO.DBMgr != null && this.sawonDAO.DBMgr.Rs != null)
					{
						// 사원정보 수정을 위해 사원정보 값 읽기
						sSabun	= oSawonDTO.getSabun().toString();		// 사번
						sName	= oSawonDTO.getName();					// 성명
						sAge	= oSawonDTO.getAge().toString();		// 나이 파라미터 읽기
						sGender	= oSawonDTO.getGender();				// 성별 파라미터 읽기
						sTel	= oSawonDTO.getTel();					// 전화 파라미터 읽기
						sDept	= oSawonDTO.getDept();					// 부서 파라미터 읽기
						sStCd	= oSawonDTO.getStcd();					// 직급 파라미터 읽기
						sBDate	= oSawonDTO.getBdate();					// 생일 파라미터 읽기
						sAddress= oSawonDTO.getAddress();				// 주소 파라미터 읽기
					}
				}
			}
			
			break;
		case "DELETE":
			sJobTitle = "사원정보 삭제 페이지(바이패스)";
			
			break;
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
	// JobStatus 작업처리 허용인 경우 INSERT | UPDATE | DELETE 처리를 위한 파라미터 값을 DTO에 넣기
	if (bJobProcess == true)
	{
		switch (sJobStatus)
		{
			case "INSERT":
			case "UPDATE":
				SawonDTO.setJobstatus(sJobStatus);
				SawonDTO.setSabun(Integer.valueOf(sSabun));
				SawonDTO.setName(sName);
				SawonDTO.setAge(Integer.valueOf(sAge));
				SawonDTO.setGender(sGender);
				SawonDTO.setTel(sTel);
				SawonDTO.setDept(sDept);
				SawonDTO.setStcd(sStCd);
				SawonDTO.setBdate(sBDate);
				SawonDTO.setAddress(sAddress);
				
				break;
			case "DELETE":
				SawonDTO.setJobstatus(sJobStatus);
				SawonDTO.setSabun(Integer.valueOf(sSabun));
				
				break;
		}
	}
%>
<%--------------------------------------------------------------------------
[Beans DTO 읽기 및 로직 구현 영역]
------------------------------------------------------------------------------%>
<%
	// JobStatus 작업처리 허용인 경우
	if (bJobProcess == true)
	{
		// 사원정보 Db 저장 (INSERT | UPDATE | DELETE)
		bDbSave = this.sawonDAO.SaveSawonDetail(SawonDTO);
		
		if (bDbSave == true)
		{
			switch (sJobStatus)
			{
				case "INSERT":
					sDbSaveMsg = "사원정보를 새로 등록 하였습니다.\\n\\n확인 버튼을 누르면 이전화면으로 돌아갑니다.";
					
					break;
				case "UPDATE":
					sDbSaveMsg = "사원정보를 수정 완료 하였습니다.\\n\\n확인 버튼을 누르면 이전화면으로 돌아갑니다.";
					
					break;
			}
		}
		else sDbSaveMsg = "사원정보 처리 중 오류가 발생 하였습니다.";
		
		// 사원정보 Db 저장 결과 메시지 출력
		out.println(String.format("<script type='text/javascript'>DocumentInit('%s');</script>", sDbSaveMsg));
		
		if (bDbSave == true)
		{
			// 부모창을 스크롤 하기 위한 스크롤 위치 저장(INSERT | UPDATE 만)
			out.println(String.format("<script type='text/javascript'>parent.WindowScrollSetId('ScrollId', '%s')</script>", sSabun));
			
			// 모달 창 닫기 타입 #1 : 사원정보 화면(부모 폼)을 갱신하여 모달창이 닫히는 효과(다시검색)
			//out.println("<script type='text/javascript'>parent.document.form1.submit()</script>");
			
			// 모달 창 닫기 타입 #2 : 사원정보 화면(부모 폼)을 갱신하여 모달창이 닫히는 효과(다시검색)
			out.println("<script type='text/javascript'>parent.WindowSubmit()</script>");
			
			// 모달 창 닫기 타입 #3 : 단순하게 모달 창 닫기
			// out.println("<script type='text/javascript'>parent.HideModalWindow()</script>");
			
		}
	}
%>
<body class="Body">
	<%----------------------------------------------------------------------
	[HTML Page - FORM 디자인 영역]
	--------------------------------------------------------------------------%>
	<form name="form1" action="SawonDetail.jsp?JobProcess=true&jobstatus=<%=sJobStatus %>" method="post">
		<%------------------------------------------------------------------
			타이틀
		----------------------------------------------------------------------%>
		<hr class="Line">
		<div class="Title"><%=sJobTitle %></div>
		<hr class="Line">
		<%------------------------------------------------------------------
			입력필드 or 수정필드
		----------------------------------------------------------------------%>
		<table class="Table">
			<tr class="TableRow">
				<td class="TableCol"><label class="Label" for="Sabun">사번<span class="Essential">*</span></label></td>
				<td><input class=<%=sKeyCss %> type="text" id="Sabun" name="sabun" value="<%=sSabun %>" maxlength="5" placeholder="사원번호" required oninput="NumberMask(this)"/></td>
				<td class="TableCol"><label class="Label" for="Name">성명<span class="Essential">*</span></label></td>
				<td><input class="Data" type="text" id="Name" name="name" value="<%=sName %>" maxlength="20" placeholder="성명" required/></td>
			</tr>
			<tr class="TableRow">
				<td class="TableCol"><label class="Label" for="Age">나이<span class="Essential">*</span></label></td>
				<td><input class="Data" type="text" id="Age" name="age" value="<%=sAge %>" maxlength="2" placeholder="나이" required oninput="NumberMask(this)"/></td>
				<td class="TableCol"><label class="Label" for="Man">성별<span class="Essential">*</span></label></td>
				<td>
					<input class="RdoData"  type="radio"  id="Man"   name="gender" value="1"  <%=(sGender.equals("1"))  ? "checked" : "" %> required/><label class="Label"   for="Man">남성</label>
					<input class="RdoData"  type="radio"  id="Woman" name="gender" value="0"  <%=(sGender.equals("0"))  ? "checked" : "" %> required/><label class="Label"   for="Woman">여성</label>
				</td>
			</tr>
			<tr class="TableRow">
				<td class="TableCol"><label class="Label" for="Tel">전화&nbsp;</label></td>
				<td><input class="Data" type="tel" id="Tel" name="tel" value="<%=sTel %>" maxlength="14" placeholder="전화번호" oninput="PhoneMask(this)"/></td>
				<td class="TableCol"><label class="Label" for="Dept">부서<span class="Essential">*</span></label></td>
				<td>
					<select class="CmbData" id="Dept" name="dept" required>
						<option value="">-선 택-</option>
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
				</td>
			</tr>
			<tr class="TableRow">
				<td class="TableCol"><label class="Label" for="StCd">직급<span class="Essential">*</span></label></td>
				<td>
					<select class="CmbData" id="StCd" name="stcd" required>
						<option value="">-선 택-</option>
					<%------------------------------------------------------------------
						부서정보 콤보박스 동적으로 생성하기(표현식 사용)
					----------------------------------------------------------------------%>
					<%
						for(String stcd : this.StCdInfo)
						{
							// Java에서 '['를 정규식으로 인식해서 ','로 변경 후 분리
							oStCd = stcd.replace("[", ",").replace("]", "").split(","); 
							
							sSelected = (sStCd.equals(oStCd[1]) == true) ? "selected" : "";
					%>
							<option value="<%=oStCd[1] %>" <%=sSelected %>><%=oStCd[0] %></option>
					<%
						}
					%>
					</select>
				</td>
				<td class="TableCol"><label class="Label" for="BDate">생일&nbsp;</label></td>
				<td><input class="Data" type="text" id="BDate" name="bdate" value="<%=sBDate %>" maxlength="10" placeholder="생년월일" oninput="BDateMask(this)"/></td>
			</tr>
			<tr class="TableRow">
				<td class="TableCol"><label class="Label" for="Address">주소&nbsp;</label></td>
				<td colspan="3"><input class="DataLong" type="text" id="Address" name="address" value="<%=sAddress %>" maxlength="60" placeholder="주소"/></td>
			</tr>
			<tr class="TableRow">
				<td class="TableCol" colspan="4">
					<input class="Submit" type="submit" value=" 사원정보 저장 ">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input class="Submit" type="button" value=" 취     소 " onclick="parent.HideModalWindow()">
				</td>
			</tr>
		</table>
		<%
			switch (sJobStatus)
			{
				case "INSERT":
					out.println("<script type='text/javascript'>document.getElementById('Sabun').focus()</script>");
					
					break;
				case "UPDATE":
					out.println("<script type='text/javascript'>document.getElementById('Name').focus()</script>");
					
					break;
			}
		%>
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
		if (sJobStatus.equals("DELETE"))
		{
			String sUrl = String.format("SawonList_Ar.jsp?JobProcess=%s&jobstatuc=%s&age=%s&gender=%s&dept=%s",
										"true", "SELECT", sAge, sGender, sDept);
		
			response.sendRedirect(sUrl);
		}
		// -----------------------------------------------------------------
	%>
</body>
</html>
