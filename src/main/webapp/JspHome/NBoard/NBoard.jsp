<%@page import="Common.ComMgr"%>
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
    	}
    	
    	.Table {
    		width: 100%;
    	}
    	
    	.TableHead {
    		width: 50%;
    	}
    	
        .ContentEditorHTML,
		.ContentViewerHTML {
            border: 1px solid gray;
            font-weight: bold;
            font-size: 17px;
            padding: 10px;
            min-height: 200px;
        }
        
        .ContentEditor,
        .ContentViewer {
        	font-weight: bold;
            font-size: 17px;
            margin: 0;
            min-height: 120px;
            padding-left: 10px;
            width: calc(100% - 12px);
        }
        
        .Text {
            border: 1px solid gray;
            font-size: 17px;
            min-height: 30px;
            padding: 10px;
            width: 100%;
        }
    </style>
	<script>
		window.onload = function() { LoadContentEditor(); LoadContentViewer(); }
		
		// ---------------------------------------------------------------------
		// DB에 저장한 게시글 내용을 읽어서 글편집용 HTML로 지정
		// 직접 입력한 HTML : HTML 그대로 보임
		// 자동 생성된 HTML : HTML로 해석되어 반영됨
		// ---------------------------------------------------------------------
		function LoadContentEditor()
		{
			let ContentEditorHTML	= null;
			let ContentEditor		= null;
			
			ContentEditor = sessionStorage.getItem('ContentEditor');
			//ContentEditor = document.getElementById('ContentEditor').value
			
			if (ContentEditor != null)
			{
				ContentEditorHTML = ContentToHTML(ContentEditor, true);
				
				document.getElementById('ContentEditorHTML').innerHTML	= ContentEditorHTML;
				document.getElementById('ContentEditor').value			= ContentEditor;
			}
		}
		// ---------------------------------------------------------------------
		// DB에 저장한 게시글 내용을 읽어서 글보기용 HTML로 지정('<', '>', '&' 복원)
		// 직접 입력한 HTML : HTML로 해석되어 반영됨
		// 자동 생성된 HTML : HTML로 해석되어 반영됨
		// ---------------------------------------------------------------------
		function LoadContentViewer()
		{
			let ContentEditor		= null;
			let ContentViewerHTML	= null;
			
			ContentEditor = sessionStorage.getItem('ContentEditor');
			//ContentEditor = document.getElementById('ContentEditor').value
			
			if (ContentEditor != null)
			{
				ContentViewerHTML = ContentToHTML(ContentEditor, false);
				
				document.getElementById('ContentViewerHTML').innerHTML	= ContentViewerHTML;
				document.getElementById('ContentViewer').value			= ContentEditor;
			}
		}
		// ---------------------------------------------------------------------
		// 글편집용에서 입력한 태그와 DB에 저장을 위해서 바꾼문자(< -> &lt, " -> &quot; 등)을 태그가 반영되어 보이도록 복원
		// DB에 저장한 게시글 내용을 읽어서 글편집용|글보기용 HTML로 지정('<', '>', '&', ", ' 복원)
		// 복원기준 : 글편집용 - DB에 저장하기 위해 변환한 ", '를 복원
		// 복원기준 : 글보기용 - 글편집용에서 입력한 태그문자와 DB에 저장하기 위해 변환한 ", '를 복원
		// 글편집용 : true | 글보기용 : false
		// ---------------------------------------------------------------------
		function ContentToHTML(ContentEditor, Editor)
		{
			let ContentHTML = null;
			
			ContentHTML = ContentEditor;
			
			// 글보기용 변환
			if (Editor == false)
			{
				ContentHTML = ContentHTML.replace(/&lt;/g,  '<')
										 .replace(/&gt;/g,  '>')
										 .replace(/&amp;/g, '&');
			}
			
			// 글편집용 | 글보기용 변환
			ContentHTML = ContentHTML.replace(/&quot;/g, '"')
									 .replace(/&apos;/g, "'");
			
			return ContentHTML;
		}
		// ---------------------------------------------------------------------
		// 글편집용에서 입력한 ", '와 자동 변환/생성된 태그에 들어있는 "를 DB에 저장용으로 변환
		// 나중에 읽어서 할당할때 "" | '' 안에 넣어야 하기 때문에 변환 필요
       	// 변환대상 : " -> &quot;
       	// 변환대상 : ' -> &apos;
		// ---------------------------------------------------------------------
		function ContentToDB(ContentEditorHTML)
		{
			let ContentDB = null;
			
			ContentDB = ContentEditorHTML.replace(/"/g, '&quot;')
										 .replace(/'/g, '&apos;');
			
			return ContentDB;
		}
		// ---------------------------------------------------------------------
    	// 입력한 게시글 내용을 DB에 저장하기 위해 sessionStorage에 보관
    	// 이유 :	 ContentEditorHTML - 사용자가 입력한 게시글 내용이 입력한 그대로 보이도록 함
    	//		 ContentViewerHTML - 사용자가 입력한 게시글 내용이 HTML로 해석되어서 보이도록 함
    	// 내용 : <div contenteditable="true"></div>에 입력된 내용을 읽어보면
    	//		 HTML 태그로 해석되는 문자는 HTML로 해석되지 않도록 자동으로 변환되어 입력 됨
    	//		 예를들어 <br>  -> &lt;br&gt;     / &nbsp;     -> &amp;nbsp;
    	//		 그러나  엔터버튼 -> <div><br><div> / 이미지 붙여넣기 -> <img ... > 으로 자동 변환/생성 됨
    	//		 그리고 <div contenteditable="true"></div>는 request.getParameter()로 읽을 수 없어서
    	//		 <input type="hidden" value="..."> 에 넣어 사용하게 되면
    	//		 글편집용에서 입력한 HTML이 HTML로 해석되어 ContentEditor에 표현하면 문제가 발생 함
    	//		 이 부분을 해결하기 위해 sessionStorage를 사용 함
		// ---------------------------------------------------------------------
        function SaveNBoardContent()
    	{
        	let ContentEditorHTML = null;
        	let ContentEditor	  = null;
            
        	ContentEditorHTML = document.getElementById('ContentEditorHTML').innerHTML;
            
			ContentEditor = ContentToDB(ContentEditorHTML);
            
            sessionStorage.setItem('ContentEditor', ContentEditor);
        }
		// Div -> Text
        function GetNBoardDivToText()
    	{
            let ContentEditorHTML = null;
            let ContentViewerHTML = null;
            
            ContentEditorHTML = document.getElementById('ContentEditorHTML').innerHTML;
            ContentViewerHTML = document.getElementById('ContentViewerHTML').innerHTML;
            
            document.getElementById('ContentEditor').value = ContentEditorHTML;
            document.getElementById('ContentViewer').value = ContentViewerHTML;
        }
     	// Text -> Div
        function SetNBoardTextToDiv()
    	{
            let ContentEditorHTML = null;
            let ContentViewerHTML = null;
            let ContentEditor	  = null;
            let ContentViewer	  = null;
            
            ContentEditor = document.getElementById('ContentEditor').value;
            ContentViewer = document.getElementById('ContentViewer').value;
            
            ContentEditorHTML = ContentToHTML(ContentEditor, true);
            ContentViewerHTML = ContentToHTML(ContentEditor, false);
            
            document.getElementById('ContentEditorHTML').innerHTML = ContentEditorHTML;
            document.getElementById('ContentViewerHTML').innerHTML = ContentViewerHTML;
        }
	</script>
</head>
<body class="Body">
    <form action="NBoard.jsp" method="post">
    	<table class="Table" border="1">
    		<tr>
    			<th class="TableHead">ContentEditor</th>
    			<th class="TableHead">ContentViewer</th>
    		</tr>
    		<tr>
    			<td><div class="ContentEditorHTML" contenteditable="true"  id="ContentEditorHTML"></div></td>
    			<td><div class="ContentViewerHTML" contenteditable="false" id="ContentViewerHTML"></div></td>
    		</tr>
    		<tr class="TableRow">
    			<td class="TableCol"><textarea class="ContentEditor" id="ContentEditor" name="contenteditor"></textarea></td>
    			<td class="TableCol"><textarea class="ContentViewer" id="ContentViewer" name="contentviewer"></textarea></td>
    		</tr>
    		<tr>
    			<td colspan="2">
			        <button type="submit" onclick="SaveNBoardContent()" >Submit</button>
			        <button type="button" onclick="GetNBoardDivToText()">Div  -> Text</button>
			        <button type="button" onclick="SetNBoardTextToDiv()">Text -> Div</button>
    			</td>
    		</tr>
		</table>
	</form>
	<%
		//DB -> 브라우저 객체
		String EditorHTML = "a&apos;a&quot;a<div>&lt;a href=&quot;#&quot;&gt;bbb&lt;/a&gt;</div><div><div>&lt;input type=&quot;text&quot; value=&quot;Hello...&quot;/&gt;</div><div>&lt;input type=&quot;button&quot; value=&quot;Hello...&quot; onclick=&quot;alert(&apos;Hello...&apos;);&quot;/&gt;</div></div><div><img src=&quot;data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEYAAAAPCAYAAABZebkgAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAAEnQAABJ0Ad5mH3gAAAysSURBVFhHbZcJWM3p38bP+7peDKVOdVZLZuxLUdGOCKUQkZESIYwwtmwZ21iSMUhU1GlXkf0tS8TIIBRt57Qok+0188dkieic3+d/naPXy/v/39f5nt8553c9z3W+93Pf9/P8RGg3k546gfg4f17dDaE+1wYqJ3FgkwvGxiJ2rXOB6plcSxiBTRcxcouOmIhNWOA3nnWzJyG1aM39/Bhyts3D7JtWrAzxhkcn0alVaNWJCOokqD9K3aW9xIRN5t2jbJK2h2DyHyLyDoXB01MI6mSoyebZ1ThS1gdQdGQD1GahLU8ETRp/X/wV6rJJjQxmxfdu8OAo1GZQdymKbyVGBHo4MMXTGbGpMRJ5R7p1NCZzuyt3sybyyxJX+nYR0/4/Rbj0NeLRle+hdiJ/3A5muMcA+jg60E5mhu+iIAIW+uI+vDvhy4cievf3j1y5NJncUzN4lu9DUWpvHl4ez0jb9kSF20KdHy+uuLE4sDdSM3OUSgmm4lbsXh6M3yhXJoyyQqvOZEewB/2VxtQXxCDUp/FRE4dWcxBd5SF0mnioP87d7I0c2joN255mbP7BCx4dR9Cko61MRnf/CCciF1B24md0mkR05Sp06kS4nwYVyfDnaUrPbCRqqR88OAI1aby8EcPALqbM9xvBDB93JCbGyBRKTEzbE+Tdk6p0T7jtT80JXyLmDsRG3gZvO3Mqc6fy8el6/Ge7004mx2WCB3PXBjJ3ziBit48ncf9kRLCarGM+VN6ahaD2gepJnImyY39Yf9AEoLs1jMsHHbEfYIlUKkcmk9Gji4TUnaH0sTRj/7qpoE5l2RRnNs7xgqeneV+TQHN1PLqqQy0Vj1CVCI9PEzDKioCxtuj+OGYgQNAkoatK5kNpIpWntyGoUxAqY6EmBaHmMOrczVxULSEveRVHdwVzPHIh/JUD9xP5UJ6GW38Fq+b5EuzrjbSDMUqlDHOphH7dZJzYOognx+2h3AvK/HicM4WdIdaETe7O5YxAJnrb0N22PwFL/Jk7azCRPw0nLc6PlFh/PTEbSM8Iou5WANpSd5qLx3BbZce7q55Q5MXzHHfWhfRGam6EQiZHKpFgb9OHHWuC6Cprzc0jG2gujGb5ZHsqTu2E+myozzJInao0qMuE6hR4msGZA8uZ5WHH8+I0qE1HV6EyEGMgR2+nqgy0FSqD9f4oOEj0plkcSfqVixdOk3P2JKmqKCJWzKPw1A54chyh9ghBnjZsXTKdqV6jkXboQEeFFJlCgUJsTGSoNeVpdjRdG4pwezgUjwLNWF4XDKf00mxmTx+F86SRTAvxZsUCFw7tHk/SAT+ito9D1NS4ieg9/pzeY42ufCzCPf0krlDmCXe8uZ3kidtgGRbmpnRUKLAwE+Pu5szaZUH0+9aEhjuHeHFhG9ELJ6Arz6LhXhrnDq7k8JbZZEcu4OSuRTz47SCPCqNZEzCEx/nR8CAb9PnTQoq+tOoEtOo4g1JqL+wlfudGqjXl/H80/N3AwajtnNy/El7kEbnUl72rp+E+eAAKsTmdFHI6KpVIjIyZObYHt5MdeZ7nglAyFG2xExS7gnoUEMW2yCCGTR+J9zgbItd7knpwkkEtaxa5IqrTLGJvhC95sSP58+Ionp0fxJPcAdSeGUixypb5Pt8hNW+HTCZHoZBgbmLCJC8Pli2ezlRvB6jO4OF/h3M2OpRLqnBitqzk7MljFBVep1pdwm+X8oj6ZQuhQcN4diMWHmaBOv5fidF8sl5j2SGO7g3j5T/+/MSEYHihayk9dDodcds28vB6AomRc0mJDMauVxfkZhZ0VMhRKuTIxBY49peQG+1MzbERCEW+aAvH0XBlBNUnnbmdN4sJflaM9B/KyOGWRG70In7fZKIjJrA8xB5RnXoR+7e5s32+Hed3DiQ/sj+Fh5ypPTWS81FDsO1jjpFJG3p0lWFt1ROxkTEB3p4sWzCFdaE+8PgMOk0S8VtmEr87gveNTV8u8GdkH0kmaed8mmtS0VXFIrTky6fSf1ZBbSa3Tm3h2pUcwxhB0FPy71GnqSJrTxhnU8PZs34aSnF75BIJSrkUuUKKhVRBry4SopfZkL6qH9diBlAQa015xkCuxvSi6Pwslq6cgOvo/sybYcvmNZ6sCHViztSBbFk1BlFN2SKOJ3lzao8tN2P6cnHbd9yO6Qtl40nYYI+ZUSssTFqxNNgRB6vutDNui8/YYawL9SVi+Xh4fp7q3F/Zt2Xlp6UFtLxHELSGxr5s7uCureTELIT6Y4Yt+jMx+nwpSzOEc8LuxdRVV38eoxMEamtrP3//X2i1zagvJ/PkZjyR62ZiZtzOQIxCJkEmk2AhldNNLmbf4gFcP+DIq6tuNBcNR3d7LJT7UHk9CL+QcVjZ9+DAVk8yYyeSEhNI0OQhTPDsi6iyeAFn0kZxft9AdMUTaL4+BO650lDghctAMcatRYTPtiduszeWFh1ob9KOoa5W7F/tT+au6fDiPFHrZqMpLzX8YUHQoRWav2pCaPHA6xd/kR27jg+Vh7+ykb70W7JQk0nxxQM0vPxkI71lNmzYgLm5OfHx8V9M2PL2uoiminTCQwOZ7j+NDkYdUMoVyCUyLKQSlOYmLBrfhejFnbn6Sy8qDvWhIq4vDZdGc/dKMB6BI/DytCNjny9pMRMJX+LGCPuuTJ3QE5GmaC45h73J3uoI5ZPgjgs88EL1ky2S9iLWhlhzL9OHORO7Idarx0KMTa+uFKjWUHZqLe8qU9kWFkxDQ8OnZvSZoIPmj80UFBTw+PHjT720CKf5VRVNhoPb/+1IehsJ+jNPuQqe5gJvDb03NTXhONgBkUiE/1T/Fk4EdIa0aYY3RZRkhZMVv5OIrRG0bt0OuVRCn57f0bNnF7rJjdgUaEVJynDeXnZDuDka3VUn0Eyl6OYqXH2cCPZ3J26XD3NnWTPMScb8QBtUUdMQaYpnk3PEj4hlgxAqfKDEHc3REUxzsmB/qDWliQ5cjXPG2dYcM3FbpOZmdFdKuJYazqsbe3hTEkvxxRSDUr7Evn37DA0NGTKExsbGlqZA1/gAbYVeIfoAVrVUAmjiECri0daeQNC90rdtQFHhLUJmBlNRWm6YoBkBreGOjubnBeTFhPKiOp8VS36kdWtjpKamuDt0Y+SQHviN7EbYlP6UHh7F+99c4M5QKHLi7Q135k3vh8NYR3wm2RPo35cff3Dhh+ARhqvn8B6IygsDKf49hNULrXh+xR1tiRvXVYOoTR9NbYoj6oSBJG+0o7PUGAux1CBTk9atSNg0B56dprkiFuEf1w3J8mVW7t6920CMk5MTb968MdzTr7b2VTnasoSvialMQnc/DV1FPB80R9A1flLZv6CFe/0lK+UAzwoP8q4kEe3ze8ycMYVv2hohaduGIK9eBHj15ueQPmyc3pf7ma403xwK99xA40ZzpS9zploxbJIH9s5dWbViDMuWeuBo0wupqRFSsRhR+c3vqSkJISlqDHcSnBFKJ6Mtm0zTtYnkbO/DxT2O+I3qjIlRGyw7KZCZm2P8X20ImzYG4dFJgwWaao9+kvYXaGr6QH5+Pg8fPvzq949PrqArjYeKhE+kVCXxOH8nF1I3ITw4hlCdTvXviVw8d5wPHz98NVbPe5WmnB0blpGbuJm/ClXUndvO2/qrODv1p4NRWxx7mBDmZ82aGXaciBzCodAeNF324OV5B0qT+nA3w4HfUkcybkR3xs70Y7SnPb4+gxBL22Mh1Z+DOtFZaomo6s4squ5NJ/+cH9t/tCJj0wgyV/fm2M+d2T6/IysC+2BhKiJg0gBc7HtgbmKOWXszPO370ViSCNUqPlan8rjy+mfL/Du8b3rP2SNxNNxOAk2KwT66ShXcT6bq7BZ2hM+Hd2U0V6fSWJnA2dR1pESvIT0ugkzVPjIO7iV933qSd8zjdNwKju9dQlbkTO7n/8IbdQ79enelg9E3rJkzgPS1jkSFDuRq7BAqk5yhcAwUefIkdxhFqWP5wac3c4Lt8fzena6Wlpi0+waZVIpCKUem7IhMaYnoTKov9++GUlMRwk/LrbmV5cbNuH7cS3PgWrwno61MWRHYnXMHvLD+1hyJqRIzUwm9ulnwPwXRUJ0O1YepzItk18aFFFy6wJP6B7x9/TevXr3k0cN6rl/NJyoijLyUDQhVGQal6ANXp39+qk2hUZ1MoJcTly6dQnhzB21VPNQm0VyewNOCKEpO76Ag8SfuJK9CfWwtZ/bPZbpHP24kL4fnpyk5p8JS2YkunZQsCbYje5sjF3YO5vcoG17n+/A8z43rcTaUnBzN/dyxDHORs2nHHBKS97Jp0xa6WnZFLDYzPIDKlZ1QKDrzTy1zJ5JG1wZaAAAAAElFTkSuQmCC&quot; alt=&quot;&quot;></div><div>ccc</div><div><br></div>";
	%>
	<script>
		//document.getElementById('ContentEditorHTML').innerHTML = "<1%=EditorHTML %>";
		//document.getElementById('ContentViewerHTML').innerHTML = "<1%=EditorHTML %>";
		document.getElementById('ContentEditor').value = "<%=EditorHTML %>";
		document.getElementById('ContentViewer').value = "<%=EditorHTML %>";
	</script>
</body>
</html>
