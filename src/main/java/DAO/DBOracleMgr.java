// #################################################################################################
// DBOracleMgr.java - 오라클 데이터베이스 DAO 모듈
// #################################################################################################
// ═════════════════════════════════════════════════════════════════════════════════════════
// 외부모듈 영역
// ═════════════════════════════════════════════════════════════════════════════════════════
package DAO;

import java.io.InputStream;
import java.sql.*;
import java.util.Properties;

import oracle.jdbc.internal.OracleCallableStatement;
import oracle.jdbc.internal.OracleTypes;
// ═════════════════════════════════════════════════════════════════════════════════════════
// 사용자정의 클래스 영역
// ═════════════════════════════════════════════════════════════════════════════════════════
/***********************************************************************
 * DBOracleMgr : 오라클 데이터베이스 클래스<br>
 * Inheritance : None
 ***********************************************************************/
public class DBOracleMgr
{
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역상수 관리 - 필수영역
	// —————————————————————————————————————————————————————————————————————————————————————

	// —————————————————————————————————————————————————————————————————————————————————————
	// 보조클래스 관리 - 보조 사용자정의 클래스 설명
	// —————————————————————————————————————————————————————————————————————————————————————
    /***********************************************************************
     * ConnectString	: 오라클 데이터베이스 연결문자열 클래스<br>
     * Inheritance		: None
     ***********************************************************************/
    private static class ConnectionString
    {
        public String  ServerIp	= null;				// 오라클 서버 주소
        public Integer Port		= null;				// 오라클 서버 연결 포트
        public String  UserId	= null;				// 오라클 사용자 계정
        public String  Password	= null;				// 오라클 사용자 암호
        public String  SId		= null;				// 오라클 SID
    }
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역변수 관리 - 필수영역(정적변수)
	// —————————————————————————————————————————————————————————————————————————————————————

	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역변수 관리 - 필수영역(인스턴스변수)
	// —————————————————————————————————————————————————————————————————————————————————————
	/** Cn : 오라클 데이터베이스 연결용 객체 */
	private Connection Cn = null;
	// -----------------------------------------------------------------------------
	// 사용 안함
	// -----------------------------------------------------------------------------
//	/** Sm : Embeded(Query/Non-Query) 등록용 객체 */
//	private Statement Sm = null;
//	/** Ps : Procedure(IN Bound)/Embeded(Query/Non-Query) 실행용 객체 */
//	private PreparedStatement Ps = null;
	// -----------------------------------------------------------------------------
	/** Cs : Procedure(IN/OUT Bound)/Embeded(Query/Non-Query) 실행용 객체 */
	public CallableStatement Cs = null;
	/** Rs : Query 결과 저장용 객체 */
	public ResultSet Rs = null;
	/** ConStr : 오라클 데이터베이스 연결문자열 객체 */
	private ConnectionString ConStr = null;
	// -----------------------------------------------------------------------------
	// 개발 중...
	// -----------------------------------------------------------------------------
	///** Rs : Query 결과 저장용 객체 */
	//private OracleResultSet ORs = null;
	///** RowCount : ResultSet(Query 결과 저장용 객체) 행 수 */
	//private Integer RowCount = 0;
	///** ColumnCount : ResultSet(Query 결과 저장용 객체) 컬럼 수 */
	//private Integer ColumnCount = 0;
	// —————————————————————————————————————————————————————————————————————————————————————
	// 생성자 관리 - 필수영역(인스턴스함수)
	// —————————————————————————————————————————————————————————————————————————————————————
	/***********************************************************************
	 * DBOracleMgr()	: 생성자
	 * @param void		: None
	 ***********************************************************************/
	public DBOracleMgr()
	{
		try
		{
			// -----------------------------------------------------------------------------
			// 기타 초기화 작업 관리
			// -----------------------------------------------------------------------------
			this.ConStr = new ConnectionString();	// 오라클 데이터베이스 연결문자열 객체 생성
			// -----------------------------------------------------------------------------
		}
		catch (Exception Ex)
		{
			Common.ExceptionMgr.DisplayException(Ex);		// 예외처리(콘솔)
		}
    }
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역함수 관리 - 필수영역(정적함수)
	// —————————————————————————————————————————————————————————————————————————————————————

	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역함수 관리 - 필수영역(인스턴스함수)
	// —————————————————————————————————————————————————————————————————————————————————————
	/***********************************************************************
	 * SetConnectionString(): 오라클 데이터베이스 연결문자열 지정
	 * @param ServerIp		: 오라클서버 주소
	 * @param Port			: 오라클서버 연결 포트
	 * @param UserId		: 오라클사용자 계정
	 * @param Password		: 오라클사용자 암호
	 * @param SId			: 오라클 SID
	 * @return void			: None
	 ***********************************************************************/
    public synchronized void SetConnectionString(String ServerIp, Integer Port,
    											 String UserId, String Password, String SId)
	{
		try
		{
	    	this.ConStr.ServerIp = ServerIp;
	    	this.ConStr.Port = Port;
	    	this.ConStr.UserId = UserId;
	    	this.ConStr.Password = Password;
	    	this.ConStr.SId = SId;
		}
		catch (Exception Ex)
		{
			throw Ex;								// 예외 던지기
		}
	}
	/***********************************************************************
	 * SetConnectionStringFromProperties()	: 오라클 데이터베이스 연결문자열 지정
	 * @param Resource						: Property File Name and Path
	 * @param ServerIp						: 오라클서버 주소
	 * @param Port							: 오라클서버 연결 포트
	 * @param UserId						: 오라클사용자 계정
	 * @param Password						: 오라클사용자 암호
	 * @param SId							: 오라클 SID
	 * @return void							: None
	 * @throws Exception 
	 ***********************************************************************/
    public synchronized Boolean SetConnectionStringFromProperties(String Resource) throws Exception
	{
		InputStream oInputStream	= null;
		Properties oProperties		= null;
		
		Boolean bResult		= false;
		String  sServerIp	= null;
		Integer nPort		= null;
		String  sUserId		= null;
		String  sPassword	= null;
		String  sSId		= null;;
		
		try
		{
			// -----------------------------------------------------------------------------
			// 오라클 데이터베이스 연결 정보 읽기
			// -----------------------------------------------------------------------------
			oInputStream = this.getClass().getResourceAsStream(Resource);
			
			if (oInputStream != null)
			{
				oProperties = new Properties();
				oProperties.load(oInputStream);
				
				sServerIp = oProperties.getProperty("Oracle.ServerIp");
				nPort = Integer.valueOf(oProperties.getProperty("Oracle.Port"));
				sUserId = oProperties.getProperty("Oracle.UserId");
				sPassword = oProperties.getProperty("Oracle.Password");
				sSId = oProperties.getProperty("Oracle.SId");
				
				this.SetConnectionString(sServerIp, nPort, sUserId, sPassword, sSId);
				
				bResult = true;
			}
		}
		catch (Exception Ex)
		{
			throw Ex;								// 예외 던지기
		}
		
		return bResult;
	}
	/***********************************************************************
	 * SetTransaction	 : 트랜잭션 모드 설정
	 * @param AutoCommit : 트랜잭션 모드
	 * 					   true  - 자동 커밋 모드
	 * 					   false - 수동 커밋 모드
	 * @return Boolean	 : true | false
	 * @throws Exception
	 ***********************************************************************/
    public synchronized Boolean SetTransaction(Boolean AutoCommit) throws Exception
    {
    	Boolean bResult = false;

        try
        {
        	if (this.DbIsConnect() == true)
            {
                this.Cn.setAutoCommit(AutoCommit);
                
                bResult = true;
            }
        }
		catch (Exception Ex)
		{
			throw Ex;								// 예외 던지기
		}

        return bResult;
    }
	/***********************************************************************
	 * DbCommit			: 실행한 DML(INSERT/UPDATE/DELETE) 처리 결과를
	 * 					: 오라클 데이터베이스에 반영
	 * @return Boolean	: true | false
	 * @throws Exception
	 ***********************************************************************/
    public synchronized Boolean DbCommit() throws Exception
    {
    	Boolean bResult = false;

        try
        {
            if(this.DbIsConnect() == true)
            {
                this.Cn.commit();
                
                bResult = true;
            }
        }
		catch (Exception Ex)
		{
			throw Ex;								// 예외 던지기
		}

        return bResult;
    }
	/***********************************************************************
	 * DbRollback		: 실행한 DML(INSERT/UPDATE/DELETE) 처리 결과를
	 * 					: 오라클 데이터베이스에서 취소
	 * @return Boolean	: true | false
	 * @throws Exception
	 ***********************************************************************/
    public synchronized Boolean DbRollback() throws Exception
    {
    	Boolean bResult = false;

        try
        {
        	if(this.DbIsConnect() == true)
            {
                this.Cn.rollback();
                
                bResult = true;
            }
        }
        catch(Exception ex)
        {
        	throw ex;
        }

        return bResult;
    }
	/***********************************************************************
	 * DbConnect()		: 오라클 데이터베이스 연결
	 * 					: 트랜잭션 모드는 기본 수동으로 전환 됨
	 * @return Boolean	: true | false
	 * @throws Exception
	 ***********************************************************************/
	public synchronized Boolean DbConnect() throws Exception
	{
		Boolean bResult = false;					// 데이터베이스 연결 상태
		String sUrl = null;							// 데이터베이스 연결문자열 저장
		
		try
		{
			// -----------------------------------------------------------------------------
        	// 오라클 데이터베이스에 연결되어 있지 않은 경우
			// -----------------------------------------------------------------------------
			if (this.DbIsConnect() == false)
			{
				// 오라클 데이터베이스 드라이버 로드
	            Class.forName("oracle.jdbc.driver.OracleDriver");
	            
				sUrl = String.format("jdbc:oracle:thin:@%s:%d:%s",
									 this.ConStr.ServerIp,
									 this.ConStr.Port,
									 this.ConStr.SId);
				
				if (sUrl != null)
				{
					// 데이터베이스 연결 시도
					this.Cn = DriverManager.getConnection(sUrl,
                    									  this.ConStr.UserId,
                    									  this.ConStr.Password);
					
				}
			}
			
			bResult = this.DbIsConnect();
			
			if (bResult == true)
				this.SetTransaction(false);
			// -----------------------------------------------------------------------------
		}
		catch (Exception Ex)
		{
			throw Ex;								// 예외 던지기
		}

		return bResult;
	}
	/***********************************************************************
	 * DbConnect()		: 오라클 데이터베이스 연결
	 * @return Boolean	: true | false
	 * @throws Exception
	 ***********************************************************************/
	public synchronized Boolean DbConnect(String UserId, String Password) throws Exception
	{
		Boolean bResult = false;					// 데이터베이스 연결 상태
		String sUrl = null;							// 데이터베이스 연결문자열 저장
		
		try
		{
			// -----------------------------------------------------------------------------
        	// 오라클 데이터베이스에 연결되어 있지 않은 경우
			// -----------------------------------------------------------------------------
			if (this.DbIsConnect() == false)
			{
				// 오라클 데이터베이스 드라이버 로드
	            Class.forName("oracle.jdbc.driver.OracleDriver");
	            
				sUrl = String.format("jdbc:oracle:thin:@%s:%d:%s",
									 this.ConStr.ServerIp,
									 this.ConStr.Port,
									 this.ConStr.SId);
				
				if (sUrl != null)
				{
					// 데이터베이스 연결 시도
					this.Cn = DriverManager.getConnection(sUrl,
                    									  UserId,
                    									  Password);
					
					// 데이터베이스 연결 확인
					bResult = this.DbIsConnect();
				}
			}
			
			bResult = this.DbIsConnect();
			
			if (bResult == true)
				this.SetTransaction(false);
			// -----------------------------------------------------------------------------
		}
		catch (Exception Ex)
		{
			throw Ex;								// 예외 던지기
		}

		return bResult;
	}
	/***********************************************************************
	 * DbIsConnect()	: 오라클 데이터베이스 연결 끊기
	 * @return Boolean	: true | false
	 * @throws Exception
	 ***********************************************************************/
	public synchronized Boolean DbDisConnect() throws Exception
	{
		Boolean bResult = false;					// 오라클 데이터베이스 연결 끊기 상태
		
		try
		{
			// -----------------------------------------------------------------------------
			// 오라클 데이터베이스 모든 객체 닫기
			// -----------------------------------------------------------------------------
			if (this.Rs != null && this.Rs.isClosed() == false)	// 오라클 결과셋 객체 닫기
				this.Rs.close();
			
			if (this.Cs != null && this.Cs.isClosed() == false)	// 오라클 명령 객체 닫기
				this.Cs.close();
			
			if (this.Cn != null && this.Cn.isClosed() == false)	// 연결 객체 닫기
				this.Cn.close();
			// -----------------------------------------------------------------------------
			// 오라클 데이터베이스 모든 객체 초기화
			// -----------------------------------------------------------------------------
			this.Rs = null;
			this.Cs = null;
			this.Cn = null;
		
			bResult = true;
			// -----------------------------------------------------------------------------
		}
		catch (Exception Ex)
		{
			throw Ex;								// 예외 던지기
		}

		return bResult;
	}
	/***********************************************************************
	 * DbIsConnect()	: 오라클 데이터베이스 연결상태 확인
	 * @return Boolean	: true | false
	 * @throws Exception
	 ***********************************************************************/
	public synchronized Boolean DbIsConnect() throws Exception
	{
		Boolean bResult = false;					// 데이터베이스 연결 상태

		try
		{
			if (this.Cn != null && this.Cn.isClosed() == false)
				bResult = true;
		}
        catch(Exception ex)
        {
        	throw ex;
        }

        return bResult;
	}
	/***********************************************************************
	 * RunQuery()				: 오라클 데이터베이스에 SQL(DML) 문장 실행
	 * 							  1.Procedure   사용 가능(IN/OUT Bound 파라미터 사용)
	 * 							  2.Embeded-SQL 사용 가능(IN Bound 파라미터 만 사용)
	 * 							  3.IN  파라미터 - ? 사용
	 * 							  4.OUT 파라미터 - OutCursorIndex 위치 지정
	 * @param Sql				: 실행할 DML 문장
	 * 								ex) BEGIN SP_HELLO(?,?,?); END;
	 * 								ex) SELECT * FROM TB_HELLO WHERE id = ?
	 * @param PaValue			: IN Bound '?' 파라미터 자리에 들어갈 인자값을 inValue에 순서대로 전달
	 *								ex) PaValue[0] = "Hello...";
	 * @param OutCursorIndex	: 1 ~ n	- OUT Bound Cursor 위치 지정(검색용 Procedure 인 경우 사용)
	 * 							  0		- OUT Bound Cursor 위치 없음(Embeded-SQL 인 경우 사용)
	 * @param QueryOK			: true	- Query 인 경우
	 * 									- 검색용 Procedure   인 경우 사용
	 * 									- 검색용 Embeded-SQL 인 경우 사용(SELECT)
	 * 							  false	- Non-Query 인 경우
	 * 									- 등록용 Procedure  인 경우
	 * 									- 등록용 Embeded-SQL 인 경우 사용(INSERT/UPDATE/DELETE)
	 * @return Boolean			: true | false
	 * @throws Exception
	 ***********************************************************************/
    public synchronized Boolean RunQuery(String Sql, Object[] PaValue, Integer OutCursorIndex, Boolean QueryOK) throws Exception
    {
    	Boolean bResult = false;
        OracleCallableStatement oOCs = null;
        Object oDummy = null;
        
        try
        {
        	// 데이터베이스에 연결 중인 경우
            if (DbIsConnect() == true)
            {
                // --------------------------------------------------------------------------
                // 객체 초기화
                // --------------------------------------------------------------------------
                if (this.Cs != null) { this.Cs.close(); this.Cs = null; }
                if (this.Rs != null) { this.Rs.close(); this.Rs = null; }
                // --------------------------------------------------------------------------
                // Procedure/Embeded-SQL 실행에 사용
                // --------------------------------------------------------------------------
                this.Cs = this.Cn.prepareCall(Sql,
                							  ResultSet.TYPE_SCROLL_INSENSITIVE,
                							  ResultSet.CONCUR_READ_ONLY);
                // --------------------------------------------------------------------------
                // DML 문장에 '?'를 사용한 부분에 파라메타 값을 넣기
                // --------------------------------------------------------------------------
                if (PaValue != null)
                {
                    for(int i = 0; i < PaValue.length; i++)
                    {
                    	// 오라클은 ""을 인식할 수 있으므로 공백을 넘긴다
                    	oDummy = (PaValue[i].equals("") == true) ? " " : PaValue[i];
                    	
                    	this.Cs.setObject(i + 1, oDummy);
                    }
                }
                // --------------------------------------------------------------------------
            	// Query 문장 실행
                // --------------------------------------------------------------------------
                if (QueryOK)
               	{
                	// DML 문장 실행(OUT Bound가 있는 Procedure type 인 경우)
                	if (OutCursorIndex > 0)
                	{
                		// ojdbc8 인 경우
                		this.Cs.registerOutParameter(OutCursorIndex, OracleTypes.CURSOR);
	                	this.Cs.execute();
	                	oOCs = (OracleCallableStatement) this.Cs;
	            		this.Rs = oOCs.getCursor(OutCursorIndex);
	            		
	            		// ojdbc11 이상인 경우
//                		this.Cs.registerOutParameter(OutCursorIndex, Types.REF_CURSOR);
//	                	this.Cs.execute();
//	            		this.Rs = (ResultSet) this.Cs.getObject(OutCursorIndex);
                	}
                	// DML 문장 실행(OUT Bound가 없는 Procedure typeEmbeded type 인 경우)
                	else
                	{
                		this.Rs = this.Cs.executeQuery();
                	}
               	}
                // --------------------------------------------------------------------------
            	// Non-Query 문장 실행
                // --------------------------------------------------------------------------
                else
				{
                	this.Cs.executeUpdate();
				}
                
                bResult = true;
                // --------------------------------------------------------------------------
            }
        }
        catch(Exception ex)
        {
        	throw ex;
        }

        return bResult;
    }
	// —————————————————————————————————————————————————————————————————————————————————————
}
// #################################################################################################
// <END>
// #################################################################################################
