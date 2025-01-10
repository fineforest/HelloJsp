// -----------------------------------------------------------------
// [브라우저 모달 창 함수 및 로직 구현 - 필수]
// -----------------------------------------------------------------
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
// 쿠키 등록
function SetCookie(Name, Value)
{
	document.cookie = Name + '=' + Value;
}
// Hello 메시지 출력 & 쿠키 등록 함수(예시)
function HelloSetCookie()
{
	SetCookie('user', 'hello');
	
	alert('Hello...Jsp! & Add Cookie!');
}
// -----------------------------------------------------------------
