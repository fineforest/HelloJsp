<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WYSIWYG 에디터</title>
    <style>
    	.Body {
    		margin: 10px;
    		padding: 0;
    		width1: 100%;
    	}
    	
        .ContentEditor,
		.ContentViewer {
            border: 1px solid gray;
            font-size: 20px;
            padding: 10px;
            min-height: 120px;
        }
        
        .Text {
            border: 1px solid gray;
            font-size: 20px;
            min-height: 50px;
            padding: 10px;
            width: 1000px;
        }
    </style>
	<script>
		window.onload = function() { LoadContentEditor(); LoadContentViewer(); }
		
		// 저장한 게시글 내용을 편집용 Html 형식으로 변환(태그가 그대로 보이도록)
		function LoadContentEditor()
		{
			let Content = document.getElementById('Content').value;
			Content = Content.replace(/</g, '&lt;')
							 .replace(/>/g, '&gt;');
			document.getElementById('ContentEditor').innerHTML = Content;//ToContentEditorHtml(Content);
		}
		
		// 저장한 게시글 내용을 글보기용 Html 형식으로 변환(태그가 반영되어 보이도록)
		function LoadContentViewer()
		{
			let Content = document.getElementById('Content').value;
			
			document.getElementById('ContentViewer').innerHTML = Content;//ToContentViewerHtml(Content);
		}
		
		// 저장한 게시글 내용을 편집용 Html 형식으로 변환(입력한 태그가 그대로 보이도록)
		// 붙여넣은 이미지 태그<img> 또는 엔터 태그<div><br></div>는 복원 
		function ToContentEditorHtml(Content)
		{
			// div가 자동으로 만든 태그를 복원하고 임의로 입력한 태그는 그대로 보이도록 변환
			let ContentHtml = Content.replaceAll('<', '&lt;')
									 .replaceAll('>', '&gt;')
									 .replaceAll('&br;', '<br>')
									 .replaceAll('&imgl;', '<img')
									 .replaceAll('&imgr;', '>');
			
			return ContentHtml;
		}
		
		// 저장한 게시글 내용을 글보기용 Html 형식으로 변환(입력한 태그가 반영되어 보이도록)
		// 붙여넣은 이미지 태그<img> 또는 엔터 태그<div><br></div>는 복원
		function ToContentViewerHtml(Content)
		{
			// div가 자동으로 만든 태그를 복원하고 임의로 입력한 태그도 반영되어 보이도록 변환
			let ContentHtml = Content.replaceAll('&lt;', '<')
									 .replaceAll('&gt;', '>')
									 .replaceAll('&br;', '<br>')
									 .replaceAll('&imgl;', '<img')
									 .replaceAll('&imgr;', '>');
			
			return ContentHtml;
		}
		
    	// 입력한 게시글 내용에 div가 자동으로 만든 태그를 저장용으로 모두 변환해서 저장
    	// 붙여넣은 이미지 태그<img> 또는 엔터 태그<div><br></div>를 저장용으로 변환
        function SaveNBoardContent() {
            var ContentHtml1 = document.getElementById('ContentEditor').innerHTML;
            var ContentHtml = document.getElementById('ContentEditor').innerText;
            ContentHtml = ContentHtml.replace(/\n/g, '<br>');
            document.getElementById('Content').value  = ContentHtml;//HtmlToContent(ContentHtml);
        }
    	
		// 입력한 게시글 내용에 div가 자동으로 만든 태그를 저장용으로 모두 변환
		// 붙여넣은 이미지 태그<img> 또는 엔터 태그<div><br></div>를 저장용으로 변환
		function HtmlToContent(ContentHtml)
		{
			// div가 자동으로 만든 태그를 모두 변환
			let Content = ContentHtml.replaceAll('<div><br></div>', '&br;')
									 .replaceAll('<div>', '&br;')
									 .replaceAll('</div>', '')
									 .replaceAll('<br>', '&br;')
									 .replaceAll('<img', '&imgl;')
									 .replaceAll('>', '&imgr;')
									 .replaceAll("'", '&#039;');
			
			return Content;
		}
	</script>
</head>
<%
	String sContent  = request.getParameter("content");
	String sContent1 = request.getParameter("content1");
%>
<body class="Body">
    <form action="NBoard.jsp" method="post">
    	ContentEditor:<br>
        <div class="ContentEditor" contenteditable="true"  id="ContentEditor"></div>
        ContentViewer:<br>
        <div class="ContentViewer" contenteditable="false" id="ContentViewer"></div>
        Content:<br>
		<input class="Text" type="text" id="Content"   name="content" value='<%=sContent %>'/>
        <br><br>
        <button type="submit" onclick="SaveNBoardContent()">다음 페이지</button>
    </form>

    <script>
    </script>
</body>
</html>
