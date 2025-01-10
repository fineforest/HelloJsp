// #################################################################################################
// ComMgr.java - 공통 모듈
// #################################################################################################
// ═════════════════════════════════════════════════════════════════════════════════════════
// 외부모듈 영역
// ═════════════════════════════════════════════════════════════════════════════════════════
package Common;

import java.util.Scanner;
// ═════════════════════════════════════════════════════════════════════════════════════════
// 사용자정의 클래스 영역
// ═════════════════════════════════════════════════════════════════════════════════════════
/***********************************************************************
 * ComMgr		: 공통 클래스<br>
 * Inheritance	: None
 ***********************************************************************/
public class ComMgr
{
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역상수 관리 - 필수영역
	// —————————————————————————————————————————————————————————————————————————————————————
	/** ESC : Escape Sequence Code(VT100) 실행용 헤더 코드 */
	public static final char ESC = 0x1B;
	/***********************************************************************
	 * NUMBER_TYPE	: 숫자형 상수 관리<br><br>
	 * BYTE			: 1바이트 정수형<br>SHORT : 2바이트 정수형<br>INTEGER : 4바이트 정수형<br>
	 * LONG			: 8바이트 정수형<br>FLOAT : 4바이트 실수형<br>DOUBLE : 8바이트 실수형
	 ***********************************************************************/
	public enum NUMBER_TYPE { BYTE, SHORT, INTEGER, LONG, FLOAT, DOUBLE }
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역변수 관리 - 필수영역(정적변수)
	// —————————————————————————————————————————————————————————————————————————————————————
    /** Scan : 키보드로 부터 입력 받는 Scanner 객체 */
    public static Scanner Scan = new Scanner(System.in);
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역변수 관리 - 필수영역(인스턴스변수)
	// —————————————————————————————————————————————————————————————————————————————————————

	// —————————————————————————————————————————————————————————————————————————————————————
    // 생성자 관리 - 필수영역(인스턴스함수)
	// —————————————————————————————————————————————————————————————————————————————————————
	/***********************************************************************
	 * ComMgr()		: 생성자
	 * @param void	: None
	 ***********************************************************************/
	public ComMgr()
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
	 * ClearScreen()	: 콘솔 창 지우기
	 * @param void		: None
	 * @return void		: None
	 * @throws Exception
	 ***********************************************************************/
	public static void ClearScreen() throws Exception
	{
	    try
	    {
	        if (System.getProperty("os.name").contains("Windows"))
	        {
	            new ProcessBuilder("cmd", "/c", "cls").inheritIO().start().waitFor();
	        }
	        else if (System.getProperty("os.name").contains("Mac"))
	        {
	            //new ProcessBuilder("clear").inheritIO().start().waitFor();
	        	
	            // or
	        	
	        	System.out.printf("%c[2J", ComMgr.ESC);				// 콘솔창 지우기
	        	System.out.printf("%c[%d;%df", ComMgr.ESC, 1, 1);	// 콘솔창 커서 위치 시키기
	        }
	        else if (System.getProperty("os.name").contains("Linux"))
	        	Runtime.getRuntime().exec("clear");
	        else
	        {
	        	System.out.printf("%c[2J", ComMgr.ESC);				// 콘솔창 지우기
	        	System.out.printf("%c[%d;%df", ComMgr.ESC, 1, 1);	// 콘솔창 커서 위치 시키기
	        }
	    }
	    catch (Exception Ex)
	    {
	    	throw Ex;
	    }
	}
	/***********************************************************************
	 * CursorHide()	: 콘솔창에서 커서 숨기기
	 * @param void	: None
	 * @return void	: None
	 ***********************************************************************/
	public static void CursorHide()
	{
		System.out.printf("%c[?25l", ComMgr.ESC);
	}
	/***********************************************************************
	 * CursorHide()	: 콘솔창에서 커서 보이기
	 * @param void	: None
	 * @return void	: None
	 ***********************************************************************/
	public static void CursorShow()
	{
		System.out.printf("%c[?25h", ComMgr.ESC);
	}
	/***********************************************************************
	 * GetLengthOfArray()	: 문자열 배열에서 가장긴 문자열의 길이 구하기
	 * @param StrArray		: 문자열 배열
	 * @return int			: 가장긴 문자열의 길이(한글 1글자:2바이트 처리) 반환
	 ***********************************************************************/
	public static int GetLengthOfArray(String[] StrArray)
	{
		int nLength = 0;
		int nByteLength = 0;
		
		try
		{
			for (String sLine : StrArray)
			{
				nByteLength = GetByteLenStr(sLine);
				
				if (nLength < nByteLength) nLength = nByteLength;
			}
		}
		catch (Exception Ex)
		{
			throw Ex;
		}
		
		return nLength;
	}
	/***********************************************************************
	 * GetByteLenStr()	: 문자열의 바이트 길이 구하기
	 * @param Str		: 영문/한글이 섞인 문자열
	 * @return int		: 문자열의 길이(영문 1글자:1바이트, 한글 1글자:2바이트 처리)
	 ***********************************************************************/
	public static int GetByteLenStr(String Str)
	{
		int nLength = 0;
		
		try
		{
			if ("가".getBytes().length == 3)
				// 'a' : 1 byte, '가' : 3 bytes 인 경우
				nLength = Str.length() + ((Str.getBytes().length - Str.length()) / 2);
			else
				// 'a' : 1 byte, '가' : 2 bytes 인 경우
				nLength = Str.getBytes().length;
		}
		catch (Exception Ex)
		{
			throw Ex;
		}
		
		return nLength;
	}
	/***********************************************************************
	 * PrintXY()		: 콘솔창 x, y 좌표에 커서 위치 시키기
	 * @param x			: 콘솔창 x 좌표
	 * @param y			: 콘솔창 y 좌표
	 * @param Message	: 출력 할 문자열
	 * @return void		: None
	 ***********************************************************************/
	public static void GotoXY(int x, int y)
	{
		try
		{
			System.out.printf("%c[%d;%df", ComMgr.ESC, y, x);
			// or System.out.printf("%c[%d;%dH", ComMgr.ESC, y, x);
		}
		catch (Exception Ex)
		{
			throw Ex;
		}
	}
	/***********************************************************************
	 * InputInteger()		: 키보드로 정수형 숫자 입력 받기
	 * @param DefaultValue	: 정수형 숫자가 아닌 경우 반환 할 기본 값
	 * @return int			: 정수형 숫자 반환(숫자:입력된 숫자 | 문자열:DefaultValue)
	 ***********************************************************************/
	public static int InputInteger(int DefaultValue)
	{
		int nNum = 0;
		String sNum = null;
		
	    try
	    {
	        sNum = ComMgr.Scan.nextLine();
	        
	        if (ComMgr.IsNumber(NUMBER_TYPE.INTEGER, sNum) == true)
	        	nNum = Integer.parseInt(sNum);
	        else
	        	nNum = DefaultValue;
	    }
	    catch (Exception Ex)
	    {
	    	throw Ex;
	    }
	    
	    return nNum;
	}
	/***********************************************************************
	 * InputInteger()			: 키보드로 정수형 숫자 입력 받기
	 * @param DefaultEnterValue	: [Enter]만 누르는 경우 반환 할 기본 값
	 * @param DefaultValue		: 정수형 숫자가 아닌 경우 반환 할 기본 값
	 * @return int				: 정수형 숫자 반환(숫자:입력된 숫자 | Enter:DefaultEnterValue | 문자열:DefaultValue)
	 ***********************************************************************/
	public static int InputInteger(int DefaultEnterValue, int DefaultValue)
	{
		int nNum = 0;
		String sNum = null;
		
	    try
	    {
	        sNum = ComMgr.Scan.nextLine();
	        
	        // [Enter]만 누르는 경우
	        if (sNum.equals("") == true) nNum = DefaultEnterValue;
	        else
	        {
	        	if (ComMgr.IsNumber(NUMBER_TYPE.INTEGER, sNum) == true)
	        		nNum = Integer.parseInt(sNum);
	        	else
	        		nNum = DefaultValue;
	        }
	    }
	    catch (Exception Ex)
	    {
	    	throw Ex;
	    }
	    
	    return nNum;
	}
	/***********************************************************************
	 * InputInteger()			: 키보드로 정수형 숫자 입력 받기
	 * @param Message			: 입력 메시지 출력
	 * @param DefaultEnterValue	: [Enter]만 누르는 경우 반환 할 기본 값
	 * @param DefaultValue		: 정수형 숫자가 아닌 경우 반환 할 기본 값
	 * @return int				: 정수형 숫자 반환(숫자:입력된 숫자 | Enter:DefaultEnterValue | 문자열:DefaultValue)
	 ***********************************************************************/
	public static int InputInteger(String Message, int DefaultEnterValue, int DefaultValue)
	{
		int nNum = 0;
		String sNum = null;
		
	    try
	    {
	    	// 입력 메시지 출력
	    	System.out.print(String.format("%s[Enter:%d]? ", Message, DefaultEnterValue));
	    	
	        sNum = ComMgr.Scan.nextLine();
	        
	        // [Enter]만 누르는 경우
	        if (sNum.equals("") == true) nNum = DefaultEnterValue;
	        else
	        {
	        	if (ComMgr.IsNumber(NUMBER_TYPE.INTEGER, sNum) == true)
	        		nNum = Integer.parseInt(sNum);
	        	else
	        		nNum = DefaultValue;
	        }
	    }
	    catch (Exception Ex)
	    {
	    	throw Ex;
	    }
	    
	    return nNum;
	}
	/***********************************************************************
	 * InputString()			: 키보드로 문자열 입력 받기
	 * @param DefaultEnterValue	: [Enter]만 누르는 경우 반환 할 기본 값
	 * @return String			: 입력된 문자열 | Enter:DefaultEnterValue
	 ***********************************************************************/
	public static String InputString(String DefaultEnterValue)
	{
		String sStr = null;
		
	    try
	    {
	    	sStr = ComMgr.Scan.nextLine();
	        
	        // [Enter]만 누르는 경우
	        if (sStr.equals("") == true)
	        	sStr = DefaultEnterValue;
	    }
	    catch (Exception Ex)
	    {
	    	throw Ex;
	    }
	    
	    return sStr;
	}
	/***********************************************************************
	 * InputString()		: 키보드로 문자열 입력 받기
	 * @param Message		: 입력 메시지 출력
	 * @param DefaultString	: [Enter]만 누르는 경우 반환 할 기본 값
	 * @return String		: 입력된 문자열 | Enter:DefaultEnterValue
	 ***********************************************************************/
	public static String InputString(String Message, String DefaultEnterValue)
	{
		String sStr = null;
		
	    try
	    {
	    	// 입력 메시지 출력
	    	System.out.print(String.format("%s[Enter:%s]? ", Message, DefaultEnterValue));
	    	
	    	sStr = ComMgr.Scan.nextLine();
	        
	        // [Enter]만 누르는 경우
	        if (sStr.equals("") == true)
	        	sStr = DefaultEnterValue;
	    }
	    catch (Exception Ex)
	    {
	    	throw Ex;
	    }
	    
	    return sStr;
	}
	/***********************************************************************
	 * IsNumber()			: Number가 정수형 숫자인지 아닌지 확인
	 * @param NumberType	: 확인 할 숫자 형(Type)
	 * @param Number		: 숫자인지 확인 할 문자열
	 * @return boolean		: 숫자형(true) | 문자열(false) 반환
	 ***********************************************************************/
	public static boolean IsNumber(NUMBER_TYPE NumberType, String Number)
	{
		boolean bResult = true;
		
	    try
	    {
	    	switch (NumberType)
			{
				case BYTE:
					Byte.parseByte(Number);
					break;
					
				case SHORT:
					Short.parseShort(Number);
					break;
					
				case INTEGER:
					Integer.parseInt(Number);
					break;
					
				case LONG:
					Long.parseLong(Number);
					break;
					
				case FLOAT:
					Float.parseFloat(Number);
					break;
					
				case DOUBLE:
					Double.parseDouble(Number);
					break;
			}
	    }
	    catch (Exception Ex)
	    {
	    	bResult = false;
	    }
	    
	    return bResult;
	}
	/***********************************************************************
	 * IsNull()				: null 확인
	 * @param CheckValue	: 확인 할 값
	 * @param DefaultValue	: null인 경우 반환 할 기본값
	 * @return Boolean		: null이 아닌 true | false 반환
	 ***********************************************************************/
	public static Boolean IsNull(Boolean CheckValue, Boolean DefaultValue)
	{
		Boolean bResult = null;
		
	    try
	    {
	    	bResult = (CheckValue != null) ? Boolean.valueOf(CheckValue) : DefaultValue;
	    }
	    catch (Exception Ex)
	    {
	    	bResult = DefaultValue;
	    }
	    
	    return bResult;
	}
	/***********************************************************************
	 * IsNull()				: null 확인
	 * @param CheckValue	: 확인 할 값
	 * @param DefaultValue	: null인 경우 반환 할 기본값
	 * @return Boolean		: null이 아닌 true | false 반환
	 ***********************************************************************/
	public static Boolean IsNull(String CheckValue, Boolean DefaultValue)
	{
		Boolean bResult = null;
		
	    try
	    {
	    	bResult = (CheckValue != null) ? Boolean.valueOf(CheckValue) : DefaultValue;
	    }
	    catch (Exception Ex)
	    {
	    	bResult = DefaultValue;
	    }
	    
	    return bResult;
	}
	/***********************************************************************
	 * IsNull()				: null 확인
	 * @param CheckValue	: 확인 할 값
	 * @param DefaultValue	: null인 경우 반환 할 기본값
	 * @return Double		: null이 아닌 실수값 반환
	 ***********************************************************************/
	public static Double IsNull(Double CheckValue, Double DefaultValue)
	{
		Double nResult = null;
		
	    try
	    {
	    	nResult = (CheckValue != null) ? Double.valueOf(CheckValue) : DefaultValue;
	    	
	    	nResult = (nResult.toString().trim().length() > 0) ? nResult : DefaultValue;
	    }
	    catch (Exception Ex)
	    {
	    	nResult = DefaultValue;
	    }
	    
	    return nResult;
	}
	/***********************************************************************
	 * IsNull()				: null 확인
	 * @param CheckValue	: 확인 할 값
	 * @param DefaultValue	: null인 경우 반환 할 기본값
	 * @return Double		: null이 아닌 실수값 반환
	 ***********************************************************************/
	public static Double IsNull(String CheckValue, Double DefaultValue)
	{
		Double nResult = null;
		
	    try
	    {
	    	nResult = (CheckValue != null) ? Double.valueOf(CheckValue) : DefaultValue;
	    	
	    	nResult = (nResult.toString().trim().length() > 0) ? nResult : DefaultValue;
	    }
	    catch (Exception Ex)
	    {
	    	nResult = DefaultValue;
	    }
	    
	    return nResult;
	}
	/***********************************************************************
	 * IsNull()				: null 확인
	 * @param CheckValue	: 확인 할 값
	 * @param DefaultValue	: null인 경우 반환 할 기본값
	 * @return Integer		: null이 아닌 정수값 반환
	 ***********************************************************************/
	public static Integer IsNull(Integer CheckValue, Integer DefaultValue)
	{
		Integer nResult = null;
		
	    try
	    {
	    	nResult = (CheckValue != null) ? Integer.valueOf(CheckValue) : DefaultValue;
	    	
	    	nResult = (nResult.toString().trim().length() > 0) ? nResult : DefaultValue;
	    }
	    catch (Exception Ex)
	    {
	    	nResult = DefaultValue;
	    }
	    
	    return nResult;
	}
	/***********************************************************************
	 * IsNull()				: null 확인
	 * @param CheckValue	: 확인 할 값
	 * @param DefaultValue	: null인 경우 반환 할 기본값
	 * @return Integer		: null이 아닌 정수값 반환
	 ***********************************************************************/
	public static Integer IsNull(String CheckValue, Integer DefaultValue)
	{
		Integer nResult = null;
		
	    try
	    {
	    	nResult = (CheckValue != null) ? Integer.valueOf(CheckValue) : DefaultValue;
	    	
	    	nResult = (nResult.toString().trim().length() > 0) ? nResult : DefaultValue;
	    }
	    catch (Exception Ex)
	    {
	    	nResult = DefaultValue;
	    }
	    
	    return nResult;
	}
	/***********************************************************************
	 * IsNull()				: null 확인
	 * @param CheckValue	: 확인 할 값
	 * @param DefaultValue	: null인 경우 반환 할 기본값
	 * @return String		: null이 아닌 문자열 반환
	 ***********************************************************************/
	public static String IsNull(String CheckValue, String DefaultValue)
	{
		String sResult = null;
		
	    try
	    {
	    	sResult = (CheckValue != null) ? CheckValue : DefaultValue;
	    }
	    catch (Exception Ex)
	    {
	    	sResult = DefaultValue;
	    }
	    
	    return sResult;
	}
	/***********************************************************************
	 * MakeString()		: Size 만큼 RepeatStr을 반복해서 문자열 만들기
	 * @param Size		: 문자열 반복 횟수
	 * @param RepeatStr	: 반복 할 문자열
	 * @return String	: 생성된 문자열 반환
	 ***********************************************************************/
	public static String MakeString(int Size, String RepeatStr)
	{
		StringBuilder oResult = new StringBuilder();
		
		try
		{
			for (int i = 0; i < Size; i++)
			{
				oResult.append(RepeatStr);
			}
		}
		catch (Exception Ex)
		{
			throw Ex;
		}
		
		return oResult.toString();
	}
	/***********************************************************************
	 * PrintXY()		: 콘솔창 x, y 좌표에 문자열 출력
	 * @param x			: 콘솔창 x 좌표
	 * @param y			: 콘솔창 y 좌표
	 * @param Message	: 출력 할 문자열
	 * @return void		: None
	 ***********************************************************************/
	public static void PrintXY(int x, int y, String Message)
	{
		try
		{
			System.out.printf("%c[%d;%df%s", ComMgr.ESC, y, x, Message);
			// or System.out.printf("%c[%d;%dH%s", ComMgr.ESC, y, x, Message);
		}
		catch (Exception Ex)
		{
			throw Ex;
		}
	}
	/***********************************************************************
	 * Wait()			: 메시지를 출력하고 [Enter] 키 누를 때 까지 멈추기
	 * @param Message	: 콘솔창에 출력 할 메시지
	 * @return void		: None
	 * @throws Exception
	 ***********************************************************************/
	public static void Wait(String Message) throws Exception
	{
		try
		{
			System.out.println();
			System.out.print(Message);
			
	    	System.in.read();
	    	
	    	while (System.in.available() > 0)
			{
	    		System.in.read();
			}
		}
	    catch (Exception Ex)
		{
	    	throw Ex;
		}
	}
	/***********************************************************************
	 * WaitXY()			: 콘솔창 x, y 좌표에 메시지를 출력하고 [Enter] 키 누를 때 까지 멈추기
	 * @param x			: 콘솔창 x 좌표
	 * @param y			: 콘솔창 y 좌표
	 * @param Message	: 콘솔창에 출력 할 메시지
	 * @return void		: None
	 * @throws Exception
	 ***********************************************************************/
	public static void WaitXY(int x, int y, String Message) throws Exception
	{
		try
		{
			ComMgr.PrintXY(x, y, Message);
			
	    	System.in.read();
	    	
	    	while (System.in.available() > 0)
			{
	    		System.in.read();
			}
		}
	    catch (Exception Ex)
		{
	    	throw Ex;
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
