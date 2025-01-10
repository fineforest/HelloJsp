// -----------------------------------------------------------------
// [사용자 함수 및 로직 구현]
// -----------------------------------------------------------------
// NBoardView.jsp 페이지 이동(게시글 Id 기준으로 처음/이전/다음/마지막)
function MoveNBoardView(NBoardPageNum, NBoardId, NBoardIdVector)
{
	let sUrl = null;
	
	try
	{
		sUrl = 'NBoardView.jsp' +	'?NBoardPageNum='	+ NBoardPageNum +
									'&NBoardId='		+ NBoardId +
									'&NBoardIdVector='	+ NBoardIdVector;
		
		window.location.assign(sUrl);
	}
	catch(ex)
	{
		alert(ex);
	}
}
// NBoardList.jsp 페이지 이동(게시판 페이지 번호 기준으로 처음/이전/다음/마지막)
function MoveNBoardList(NBoardPageNum, VectorMethod)
{
	let sUrl = null;
	
	try
	{
		sUrl = 'NBoardList.jsp?' +	'NBoardPageNum=' + NBoardPageNum +
									'&NBoardVector=' + VectorMethod;
	
		window.location.assign(sUrl);
	}
	catch(ex)
	{
		alert(ex);
	}
}
// NBoardDetail.jsp 페이지 이동(글쓰기(예시포함)에서 사용)
function MoveNBoardDetail(NBoardPageNum, NBoardId, JopStatus)
{
	let sUrl = null;
	
	// 작업상태(Insert | Update | Ex : 개발중... 완료 후 New 변경)
	sUrl = 'NBoardDetail.jsp' +	'?NBoardPageNum='	+ NBoardPageNum	+
								'&NBoardId='		+ NBoardId		+
								'&JopStatus='		+ JopStatus;
	
	window.location.assign(sUrl);
}
// NBoardSave.jsp 페이지 이동
function MoveNBoardDelete(NBoardPageNum, NBoardId, Author, Subject)
{
	let sUrl = null;
	let sMsg = null;
	
	// 작업상태('Delete')
	sUrl = 'NBoardSave.jsp' +	'?NBoardPageNum='	+ NBoardPageNum +
								'&NBoardId='		+ NBoardId		+
								'&JopStatus='		+ "Delete";
	
	sMsg =	'다음의 게시글을 삭제 합니다.'	+ '\n\n'	+
			'글번호 : ' + NBoardId	+ '\n'		+
			'작성자 : ' + Author		+ '\n'		+
			'글제목 : ' + Subject		+ '\n\n'	+
			'계속 진행 하시겠습니까?';
	
	if(confirm(sMsg) == true)
	{
		window.location.assign(sUrl);
	}
}
// 선택한 첨부파일(이미지) 보이기
function ReadImage(FileObject, ImageName)
{
	let oReader = null;
	let oImage = null;
	
	try
	{
		oReader = new FileReader();
		
		if (FileObject.files && FileObject.files[0])
		{
		    oReader.onload = function(e)
		    {
		    	oImage = document.getElementById(ImageName);
		    	
		    	if (oImage != null)
		    	{
		    		oImage.src = e.target.result;
		    		oImage.style = 'width:auto; height:auto';
		    	}
		    };
		    
		    oReader.readAsDataURL(FileObject.files[0]);
		}
		else
		{
			document.getElementById(ImageName).src = "";
		}
	}
	catch(ex)
	{
		alert(ex);
	}
}
// -----------------------------------------------------------------
