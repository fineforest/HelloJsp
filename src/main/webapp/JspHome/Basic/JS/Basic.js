// -----------------------------------------------------------------
// [사용자 함수 및 로직 구현]
// -----------------------------------------------------------------
// 쿠키 등록
document.cookie = "HelloCookie=Cookie-OK!";
// 날짜 출력
function PrintDate(Date)
{
	alert('현재 날짜/시간은 : ' + Date);
}
// Detail.jsp 페이지 이동
function MoveDetail()
{
	let sUrl = null;
	
	let Data1 = document.getElementById('Data1').value;
	let Data2 = document.getElementById('Data2').value;
	
	sUrl = 'Detail.jsp' +	'?txtData1=' + Data1 +
							'&txtData2=' + Data2;
	
	window.location.assign(sUrl);
}
// ServletDetail.java 페이지 이동
function MoveServletDetail()
{
	let sUrl = null;
	
	let Data1 = document.getElementById('Data1').value;
	let Data2 = document.getElementById('Data2').value;
	
	sUrl = '/HelloJsp/ServletDetail' +	'?txtData1=' + Data1 +
										'&txtData2=' + Data2;
	
	window.location.assign(sUrl);
}
// -----------------------------------------------------------------
