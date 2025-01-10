// -----------------------------------------------------------------
// [브라우저 모달 창 함수 및 로직 구현 - 필수]
// -----------------------------------------------------------------
// 모달 창 보이기
function ShowModalWindow(ModalSrc)
{
    let divModalParent = document.getElementById("divModalParent");	// 모달 창 아래 부모
    let divModalFrame  = document.getElementById("divModalFrame");	// 모달 창 프레임
	let ifModalWindow  = document.getElementById("ifModalWindow");	// 모달 창
    let btnClose = document.getElementById("btnClose");				// 모달 창 내부 닫기 버튼
	
 	// 모달 창 아래 메인 배경 흐리게 처리(브라우저에서 속도저하 발생할 수 있음)
    // divModalParent.classList.add("Modal-Parent-Background");
    
 	// 모달 창 프레임 열기
    divModalFrame.style.display = "block";
 	
 	// 모달 창 src(소스경로) 연결
 	ifModalWindow.src = ModalSrc;
	
 	// 모달 창 내부 닫기 버튼 이벤트 핸들러
    btnClose.onclick = HideModalWindow;
}
// 모달 창 숨기기
function HideModalWindow()
{
	// 모달 창 아래 메인 배경 기본으로 처리
	// divModalParent.classList.remove("Modal-Parent-Background");
	
	// 모달 창 프레임 닫기
	divModalFrame.style.display = "none";
}
// -----------------------------------------------------------------
// [사용자 함수 및 로직 구현]
// -----------------------------------------------------------------
// 브라우저 크기가 변경되는 경우 중간 영역의 크기 계산(수직 스크롤바)- 현재 사용 안함
function MiddleAreaResize()
{
	let TopArea		= document.getElementById('TopArea');
	let MiddleArea	= document.getElementById('MiddleArea');
	let BottomArea	= document.getElementById('BottomArea');
	
	let Window_h	= window.innerHeight;
	let TopArea_h	= TopArea.offsetHeight;
	let MiddleArea_h= MiddleArea.offsetHeight;
	let BottomArea_h= BottomArea.offsetHeight;
	
	MiddleArea.style.marginTop = TopArea_h + 'px';
	MiddleArea.style.height = (Window_h - (TopArea_h + BottomArea_h)) + 'px';
}
// Submit 버튼에 검색한 사원정보 수를 출력
function PrintRowCount(Id, Text)
{
	btn = document.getElementById(Id);
	
	btn.value = Text;
}
// 사원정보 삭제 확인 메시지 창 출력
function SawonDelete(Sabun, Name, Age, Gender, Dept, Deptname, StCdName)
{
	let sUrl = null;
	let sMsg = null;
	
	// 사원정보 삭제 버튼용 모달 창 src(주소) 만들기
	sUrl = 'SawonDetail.jsp';
	sUrl = sUrl.concat('?', 'JobProcess=',	true,		'&',
							'jobstatus=',	'DELETE',	'&',
							'sabun=',		Sabun,		'&',
							'age=',			Age,		'&',
							'gender=',		Gender,		'&',
							'dept=',		Dept
						);
	

	sMsg =	'다음의 사원정보를 삭제 합니다.'	+ '\n\n'	+
			'[사번] - ' + Sabun			+ '\n'		+
			'[이름] - ' + Name			+ '\n'		+
			'[부서] - ' + Deptname		+ '\n'		+
			'[직급] - ' + StCdName		+ '\n\n'	+
			'계속 진행 하시겠습니까?';
	
	if(confirm(sMsg) == true)
	{
		window.location.assign(sUrl);
	}
}
// 사원정보 Update 버튼 글자 색상 변경
function UpdateSetColor(Id)
{
	btn = document.getElementById(Id);
	
	btn.style.color = "red";
}
// 브라우저 화면을 스크롤 하기위해 Id 값 저장
function WindowScrollSetId(Id, Value)
{
	let oScrollId = document.getElementById(Id);
	
	if (oScrollId != null)
	{
		oScrollId.value = Value;
	}
}
// 브라우저 화면을 특정 Id 위치까지 Y축으로 스크롤 시킴
function WindowScrollToId(Id)
{
	let oScrollLoc = document.getElementById('ScrollId-' + Id);
	let nTop = null;
	
	if (oScrollLoc != null)
	{
		// 브라우저에 특정 객체 위치로 스크롤 하는 경우
		// behavior: 'auto', 'smooth' / block: start, center, end, nearest
		oScrollLoc.scrollIntoView({ behavior: 'smooth', block: 'end' });
		
		// 브라우저 자체를 스크롤 하는 경우
		nTop = oScrollLoc.offsetTop;
		parent.window.scrollTo({top:nTop, behavior:'smooth'});
	}
}
// 브라우저 화면을 특정 form/action을 사용해서 갱신
function WindowSubmit()
{
	document.form1.submit();
}
// -----------------------------------------------------------------
