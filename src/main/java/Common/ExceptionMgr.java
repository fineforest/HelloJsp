// #################################################################################################
// ExceptionMgr.java - 예외 처리 모듈
// #################################################################################################
// ═════════════════════════════════════════════════════════════════════════════════════════
// 외부모듈 영역
// ═════════════════════════════════════════════════════════════════════════════════════════
package Common;

import java.awt.Toolkit;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.StringSelection;
import java.text.MessageFormat;
import java.util.Arrays;
import java.util.HashMap;
// ═════════════════════════════════════════════════════════════════════════════════════════
// 사용자정의 클래스 영역
// ═════════════════════════════════════════════════════════════════════════════════════════
/***********************************************************************
* ExceptionMgr	: 예외 처리 클래스<br>
* Inheritance	: None
***********************************************************************/
public class ExceptionMgr
{
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역상수 관리 - 필수영역
	// —————————————————————————————————————————————————————————————————————————————————————
	/***********************************************************************
	 * RUN_MODE	: 예외처리 모드 관리<br><br>
	 * DEBUG	: 개발모드<br>RELEASE : 배포모드
	 ***********************************************************************/
	public enum RUN_MODE { DEBUG, RELEASE }
	// -----------------------------------------------------------------------------
	// 예외 키코드를 여기에 등록(예외 클래스 명으로 등록)
	// -----------------------------------------------------------------------------
	/** ERROR_SAMPLE_KEYCODE : 샘플 예외 키코드(예외 클래스명)*/
	private static final String ERROR_SAMPLE_KEYCODE = "예외 키코드(예외 클래스명)";
	/** ERROR_ARITHMETIC : 연산 예외(java.lang.ArithmeticException)*/
	private static final String ERROR_ARITHMETIC = "java.lang.ArithmeticException";
	/** ERROR_ARRAYINDEXOUTOFBOUND : 배열 범위 예외(java.lang.ArrayIndexOutOfBoundsException)*/
	private static final String ERROR_ARRAYINDEXOUTOFBOUND = "java.lang.ArrayIndexOutOfBoundsException";
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역변수 관리 - 필수영역(정적변수)
	// —————————————————————————————————————————————————————————————————————————————————————
    /** ErrTable : 메시지 관리 HashMap */
	private static HashMap<String, String> ErrTable = new HashMap<String, String>();
	/** RunMode : 예외처리 모드 관리<br><br>DEBUG : 개발모드<br>RELEASE : 배포모드 */
	private static RUN_MODE RunMode = RUN_MODE.DEBUG;
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역변수 관리 - 필수영역(인스턴스변수)
	// —————————————————————————————————————————————————————————————————————————————————————

	// —————————————————————————————————————————————————————————————————————————————————————
    // 생성자 관리 - 필수영역(인스턴스함수)
	// —————————————————————————————————————————————————————————————————————————————————————
	/***********************************************************************
	 * ExceptionMgr()	: 생성자
	 * @param Age		: None
	 ***********************************************************************/
	public ExceptionMgr(int Age)
	{
		try
		{
			// -----------------------------------------------------------------------------
			// 기타 초기화 작업 관리
			// -----------------------------------------------------------------------------

			// -----------------------------------------------------------------------------
		}
		catch (Exception Ex)
		{
			ExceptionMgr.DisplayException(Ex);		// 예외처리(콘솔)
		}
    }
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역함수 관리 - 필수영역(정적함수)
	// —————————————————————————————————————————————————————————————————————————————————————
	/***********************************************************************
	 * SetMode()		: 프로그램 개발 모드 지정(반드시 프로그램 진입점에서 호출)
	 * @param RunMode	: 운영모드 - DEBUG | RELEASE
	 * @return void		: None
	 ***********************************************************************/
	public static void SetMode(RUN_MODE RunMode)
	{
		try
		{
			// -----------------------------------------------------------------------------
			// 예외 처리 모드 지정
			// -----------------------------------------------------------------------------
			ExceptionMgr.RunMode = RunMode;
			// -----------------------------------------------------------------------------
			// 새로운 예외 메시지를 여기에 등록...
			// -----------------------------------------------------------------------------
			ExceptionMgr.ErrTable.put(ExceptionMgr.ERROR_SAMPLE_KEYCODE, "에러 샘플 메시지 입니다.");
			ExceptionMgr.ErrTable.put(ExceptionMgr.ERROR_ARITHMETIC, "계산 오류가 발생 하였습니다.");
			ExceptionMgr.ErrTable.put(ExceptionMgr.ERROR_ARRAYINDEXOUTOFBOUND, "배열 범위 오류가 발생 하였습니다.");
			// -----------------------------------------------------------------------------
		}
		catch (Exception Ex)
		{
			ExceptionMgr.DisplayException(Ex);		// 예외처리(콘솔)
		}
	}
	/***********************************************************************
	 * DisplayException()	: 예외 메시지 출력
	 * @param Ex			: 발생된 예외 객체
	 * @return void			: None
	 ***********************************************************************/
	public static void DisplayException(Exception Ex)
	{
		String sErrClassName = null;		// 발생한 예외 클래스 명(예외 키로 사용)
        boolean bContainsClassName = false;	// 예외 코드 등록 여부
        
		String sErrTitle = null;			// 예외 타이틀
		String sErrMsg = null;				// 예외 메시지
        String sTagMsg = null;				// 태그 예외 메시지(예외에 대한 추가 설명 메시지)
        String sAllErrMsg = null;			// 출력 할 전체 메시지

        Clipboard oClipboard = null;		// 클립보드 객체
        StringSelection oContents = null;	// 클립보드 내용 등록용 객체
        String sClipMsg = null;				// 클립보드 메시지

        int nMaxMsgLen = 0;					// 가장 긴 메시지 길이
        int nTitleLeftSpaceLen = 0;			// 타이틀 왼쪽 공백 길이
        String sLineTopBottom = "";			// 예외 메시지 상단/하단 라인
        String sLineMiddle = "";			// 예외 메시지 중간 라인
        
        try
		{
			// -----------------------------------------------------------------------------
			// 예외 코드 등록 여부
			// -----------------------------------------------------------------------------
        	sErrClassName = Ex.getClass().getName();
        	bContainsClassName = ExceptionMgr.ErrTable.containsKey(sErrClassName);
			// -----------------------------------------------------------------------------
			// 예외 타이틀 만들기(개발용 | 배포용)
			// -----------------------------------------------------------------------------
	        if (ExceptionMgr.RunMode == RUN_MODE.DEBUG) sErrTitle = "[Dev-Exception Message]";
	        else if (ExceptionMgr.RunMode == RUN_MODE.RELEASE) sErrTitle = "[User-Exception Message]";
			// -----------------------------------------------------------------------------
			// 예외 메시지 만들기(개발용 | 배포용)
			// -----------------------------------------------------------------------------
			sErrMsg = MessageFormat.format("<Error Trace>\n{0}\n\n<Error Class>\n{1}\n\n<Error Message>\n{2}",
										   Arrays.toString(Ex.getStackTrace()),
										   Ex.getClass().getName(),
										   Ex.fillInStackTrace().toString());
			
			sErrMsg = sErrMsg.replace("[", "").replace("]", "").replace(", ", "\n");
			sClipMsg = sErrMsg; 
			
			if (ExceptionMgr.RunMode == RUN_MODE.RELEASE)
			{
				if (bContainsClassName == true)
					sErrMsg = ExceptionMgr.ErrTable.get(sErrClassName);
				else
					sErrMsg = "오류가 발생 하였습니다.";
			}
			// -----------------------------------------------------------------------------
			// 태그 예외 메시지 만들기(개발용 | 배포용)
			// -----------------------------------------------------------------------------
			if (ExceptionMgr.RunMode == RUN_MODE.DEBUG)
			{
				if (bContainsClassName == true)
					sTagMsg = "[오류가 발생 하였습니다.]";
				else
				{
					sTagMsg = "오류 키코드를 클립보드에 복사 하였습니다.\n\n" +
							  "[배포용 오류 메시지를 등록하세요.]";
				}
			}
			else if (ExceptionMgr.RunMode == RUN_MODE.RELEASE)
			{
				if (bContainsClassName == true)
					sTagMsg = "[전산실로 문의 하세요.]";
				else
				{
					sTagMsg = "오류 정보를 클립보드에 복사 하였습니다.\n" +
							  "메모장에 [Ctrl + V]로 붙여넣기 하고,\n\n" +
							  "[전산실로 문의 하세요.]";
				}
			}
			// -----------------------------------------------------------------------------
			// 클립보드 메시지 만들기 & 클립보드에 복사(개발용 | 배포용)
			// -----------------------------------------------------------------------------
			if (bContainsClassName == false)
			{
				if (ExceptionMgr.RunMode == RUN_MODE.DEBUG)
					sClipMsg = sErrClassName;
				else if (ExceptionMgr.RunMode == RUN_MODE.RELEASE)
					sClipMsg = MessageFormat.format("[오류 내용]\n{0}\n\n[오류 키코드]\n{1}\n",
													sClipMsg,
													sErrClassName);
	
				oClipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
				oContents = new StringSelection(sClipMsg);
				oClipboard.setContents(oContents, null);
			}
			// -----------------------------------------------------------------------------
			// 예외 메시지가 긴경우 메시지안에 '. '를 두줄로 처리
			// -----------------------------------------------------------------------------
			sErrMsg = sErrMsg.replace(". ", "\n");
			// -----------------------------------------------------------------------------
			// 예외 메시지 출력에 필요한 헤더 & 라인 만들기 
			// -----------------------------------------------------------------------------
			nMaxMsgLen = ComMgr.GetLengthOfArray(MessageFormat.format("{0}\n{1}\n{2}", sErrTitle, sErrMsg, sTagMsg).trim().split("\n"));
			nTitleLeftSpaceLen = (nMaxMsgLen - sErrTitle.length()) / 2;
	        
			sLineTopBottom = ComMgr.MakeString(nMaxMsgLen, "=");
			sLineMiddle = ComMgr.MakeString(nMaxMsgLen, "-");
	        sErrTitle = MessageFormat.format("{0}{1}", ComMgr.MakeString(nTitleLeftSpaceLen, " "), sErrTitle);
			// -----------------------------------------------------------------------------
			// 예외 메시지 출력 
			// -----------------------------------------------------------------------------
	        sAllErrMsg = MessageFormat.format("{0}\n{1}\n{2}\n{3}\n{4}\n{5}\n{6}",
	        								  sLineTopBottom,
			   		 						  sErrTitle,
			   		 						  sLineMiddle,
			   		 						  sErrMsg,
			   		 						  sLineMiddle,
			   		 						  sTagMsg,
			   		 						  sLineTopBottom);
			
			System.out.println(sAllErrMsg);
			// -----------------------------------------------------------------------------
		}
        catch (Exception ex)
        {
        	System.out.println(ex.toString());
        }
	}
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역함수 관리 - 필수영역(인스턴스함수)
	// —————————————————————————————————————————————————————————————————————————————————————

	// —————————————————————————————————————————————————————————————————————————————————————
}
// #################################################################################################
// <END>
// #################################################################################################
