//#################################################################################################
//SawonDAO.java - 사원검색 DAO 모듈
//#################################################################################################
//═════════════════════════════════════════════════════════════════════════════════════════
//외부모듈 영역
//═════════════════════════════════════════════════════════════════════════════════════════
package BeansHome.Sawon;

import java.util.ArrayList;

import Common.ComMgr;
import Common.ExceptionMgr;

//═════════════════════════════════════════════════════════════════════════════════════════
//사용자정의 클래스 영역
//═════════════════════════════════════════════════════════════════════════════════════════
/***********************************************************************
* SawonDAO		: 사원검색 Bean DAO 클래스<br>
* Inheritance	: None
***********************************************************************/
public class SawonDAO
{
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역상수 관리 - 필수영역
	// —————————————————————————————————————————————————————————————————————————————————————
	
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역변수 관리 - 필수영역(정적변수)
	// —————————————————————————————————————————————————————————————————————————————————————
	
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역변수 관리 - 필수영역(인스턴스변수)
	// —————————————————————————————————————————————————————————————————————————————————————
	/** DBMgr : 오라클 데이터베이스 DAO 객체 선언 */
	public DAO.DBOracleMgr DBMgr = null;
	// —————————————————————————————————————————————————————————————————————————————————————
	// 생성자 관리 - 필수영역(인스턴스함수)
	// —————————————————————————————————————————————————————————————————————————————————————
	/***********************************************************************
	 * SawonDAO()	: 생성자
	 * @param void	: None
	 ***********************************************************************/
	public SawonDAO()
	{
		try
		{
			// -----------------------------------------------------------------------------
			// 초기화 작업 관리
			// -----------------------------------------------------------------------------
			ExceptionMgr.SetMode(ExceptionMgr.RUN_MODE.DEBUG);
			
			this.DBMgr = new DAO.DBOracleMgr();								// DAO 객체 생성
			this.DBMgr.SetConnectionStringFromProperties("db.properties");	// DB 연결문자열 읽기 
			
			//this.DBMgr.SetConnectionString("172.30.1.44", 1521, "educ", "educ", "XE");	// My
			//this.DBMgr.SetConnectionString("192.168.0.100", 1521, "educ", "educ", "XE");	// My
			//this.DBMgr.SetConnectionString("172.24.210.162", 1521, "educ", "educ", "XE");	// 301
			//this.DBMgr.SetConnectionString("172.24.162.45", 1521, "educ", "educ", "XE");	// 306
			// -----------------------------------------------------------------------------
		}
		catch (Exception Ex)
		{
			ExceptionMgr.DisplayException(Ex);	// 예외처리(콘솔)
		}
	}
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역함수 관리 - 필수영역(정적함수)
	// —————————————————————————————————————————————————————————————————————————————————————
	
	// —————————————————————————————————————————————————————————————————————————————————————
	// 전역함수 관리 - 필수영역(인스턴스함수)
	// —————————————————————————————————————————————————————————————————————————————————————
	/***********************************************************************
	 * ReadSawon()		: 오라클 데이터베이스에서 사원정보 읽기
	 * @param Sabun		: 사번(조건용)
	 * @param sawonDTO	: 사원정보 DTO(결과 반환용)
	 * @return boolean	: 사원정보 검색 처리 여부(true | false)
	 * @throws Exception 
	 ***********************************************************************/
	public boolean ReadSawon(Integer Sabun, SawonDTO sawonDTO) throws Exception
	{
		String sSql = null;						// DML 문장
		Object[] oPaValue = null;				// DML 문장에 필요한 파라미터 객체
		boolean bResult = false;
		
		try
		{
	    	// -----------------------------------------------------------------------------
			// 사원정보 읽기
	    	// -----------------------------------------------------------------------------
			if (Sabun != null)
			{
				if (this.DBMgr.DbConnect() == true)
				{
					// 사원정보 읽기
					sSql = "BEGIN SP_MAN_R(?,?,?,?,?,?); END;";
					// sSql = "{call SP_MAN_R(?,?,?,?,?,?)}";
					
					// IN 파라미터 만큼만 할당
					oPaValue = new Object[5];
					
					oPaValue[0] = Sabun;
					oPaValue[1] = "-1";
					oPaValue[2] = 0;
					oPaValue[3] = "-1";
					oPaValue[4] = "-1";
					
					if (this.DBMgr.RunQuery(sSql, oPaValue, 6, true) == true)
					{
						while(this.DBMgr.Rs.next() == true)
						{
							sawonDTO.setSabun(this.DBMgr.Rs.getInt("Sabun"));
							sawonDTO.setName(ComMgr.IsNull(this.DBMgr.Rs.getString("Name"), "").trim());
							sawonDTO.setAge(this.DBMgr.Rs.getInt("Age"));
							sawonDTO.setGender(ComMgr.IsNull(this.DBMgr.Rs.getString("Gender"), "").trim());
							sawonDTO.setTel(ComMgr.IsNull(this.DBMgr.Rs.getString("Tel"), "").trim());
							sawonDTO.setDept(ComMgr.IsNull(this.DBMgr.Rs.getString("Dept"), "").trim());
							sawonDTO.setDeptname(ComMgr.IsNull(this.DBMgr.Rs.getString("DeptName"), "").trim());
							sawonDTO.setStcd(ComMgr.IsNull(this.DBMgr.Rs.getString("StCd"), "").trim());
							sawonDTO.setStcdname(ComMgr.IsNull(this.DBMgr.Rs.getString("StCdName"), "").trim());
							sawonDTO.setBdate(ComMgr.IsNull(this.DBMgr.Rs.getString("BDate"), "").trim());
							sawonDTO.setAddress(ComMgr.IsNull(this.DBMgr.Rs.getString("Address"), "").trim());
						}
						
						bResult = true;
					}
				}
			}
	    	// -----------------------------------------------------------------------------
		}
		catch (Exception Ex)
		{
			Common.ExceptionMgr.DisplayException(Ex);		// 예외처리(콘솔)
		}
		
		return bResult;
	}
	/***********************************************************************
	 * ReadSawonList()	: 오라클 데이터베이스에서 사원정보 읽기
	 * @param sawonDTO	: 사원정보 DTO(조건용)
	 * @return boolean	: 사원정보 검색 처리 여부(true | false)
	 * @throws Exception 
	 ***********************************************************************/
	public boolean ReadSawonList(SawonDTO sawonDTO) throws Exception
	{
		String sSql = null;						// DML 문장
		Object[] oPaValue = null;				// DML 문장에 필요한 파라미터 객체
		boolean bResult = false;
		
		try
		{
	    	// -----------------------------------------------------------------------------
			// 사원정보 읽기
	    	// -----------------------------------------------------------------------------
			if (this.DBMgr.DbConnect() == true)
			{
				// 사원정보 읽기
				sSql = "BEGIN SP_MAN_R(?,?,?,?,?,?); END;";
				// sSql = "{call SP_MAN_R(?,?,?,?,?,?)}";
				
				// IN 파라미터 만큼만 할당
				oPaValue = new Object[5];
				
				oPaValue[0] = 0;
				oPaValue[1] = "-1";
				oPaValue[2] = sawonDTO.getAge();
				oPaValue[3] = sawonDTO.getGender();
				oPaValue[4] = sawonDTO.getDept();
				
				if (this.DBMgr.RunQuery(sSql, oPaValue, 6, true) == true)
				{
					bResult = true;
				}
			}
	    	// -----------------------------------------------------------------------------
		}
		catch (Exception Ex)
		{
			Common.ExceptionMgr.DisplayException(Ex);		// 예외처리(콘솔)
		}
		
		return bResult;
	}
	/***********************************************************************
	 * ReadSawonList()	: 오라클 데이터베이스에서 사원정보 읽기
	 * @param sawonDTO	: 사원정보 DTO(조건용)
	 * @param Sawons	: 사원정보 DTO(결과 반환용)
	 * @return boolean	: 사원정보 검색 처리 여부(true | false)
	 * @throws Exception 
	 ***********************************************************************/
	public boolean ReadSawonList(SawonDTO sawonDTO, ArrayList<SawonDTO> Sawons) throws Exception
	{
		String sSql = null;						// DML 문장
		Object[] oPaValue = null;				// DML 문장에 필요한 파라미터 객체
		boolean bResult = false;
		
		try
		{
	    	// -----------------------------------------------------------------------------
			// 사원정보 읽기
	    	// -----------------------------------------------------------------------------
			if (this.DBMgr.DbConnect() == true)
			{
				// 사원정보 읽기
				sSql = "BEGIN SP_MAN_R(?,?,?,?,?,?); END;";
				// sSql = "{call SP_MAN_R(?,?,?,?,?,?)}";
				
				// IN 파라미터 만큼만 할당
				oPaValue = new Object[5];
				
				oPaValue[0] = 0;
				oPaValue[1] = "-1";
				oPaValue[2] = sawonDTO.getAge();
				oPaValue[3] = sawonDTO.getGender();
				oPaValue[4] = sawonDTO.getDept();
				
				if (this.DBMgr.RunQuery(sSql, oPaValue, 6, true) == true)
				{
					while(this.DBMgr.Rs.next() == true)
					{
						SawonDTO Sawon = new SawonDTO();
						
						Sawon.setSabun(this.DBMgr.Rs.getInt("Sabun"));
						Sawon.setName(ComMgr.IsNull(this.DBMgr.Rs.getString("Name"), "").trim());
						Sawon.setAge(this.DBMgr.Rs.getInt("Age"));
						Sawon.setGender(ComMgr.IsNull(this.DBMgr.Rs.getString("Gender"), "").trim());
						Sawon.setTel(ComMgr.IsNull(this.DBMgr.Rs.getString("Tel"), "").trim());
						Sawon.setDept(ComMgr.IsNull(this.DBMgr.Rs.getString("Dept"), "").trim());
						Sawon.setDeptname(ComMgr.IsNull(this.DBMgr.Rs.getString("DeptName"), "").trim());
						Sawon.setStcd(ComMgr.IsNull(this.DBMgr.Rs.getString("StCd"), "").trim());
						Sawon.setStcdname(ComMgr.IsNull(this.DBMgr.Rs.getString("StCdName"), "").trim());
						Sawon.setBdate(ComMgr.IsNull(this.DBMgr.Rs.getString("BDate"), "").trim());
						Sawon.setAddress(ComMgr.IsNull(this.DBMgr.Rs.getString("Address"), "").trim());
						
						Sawons.add(Sawon);
					}
					
					bResult = true;
				}
			}
	    	// -----------------------------------------------------------------------------
		}
		catch (Exception Ex)
		{
			Common.ExceptionMgr.DisplayException(Ex);		// 예외처리(콘솔)
		}
		
		return bResult;
	}
	/***********************************************************************
	 * SaveSawonDetail()	: 오라클 데이터베이스에 사원정보 저장
	 * @param sawonDTO		: 사원정보 DTO(저장용)
	 * @return boolean		: 사원정보 저장 처리 여부(true | false)
	 * @throws Exception 
	 ***********************************************************************/
	public boolean SaveSawonDetail(SawonDTO sawonDTO) throws Exception
	{
		String sSql = null;						// DML 문장
		Object[] oPaValue = null;				// DML 문장에 필요한 파라미터 객체
		boolean bResult = false;
		
		try
		{
	    	// -----------------------------------------------------------------------------
			// 사원정보 저장(JobStatus : INSERT | UPDATE | DELETE)
	    	// -----------------------------------------------------------------------------
			if (this.DBMgr.DbConnect() == true)
			{
				sSql = "BEGIN SP_MAN_CUD(?,?,?,?,?,?,?,?,?,?); END;";
				
				// IN 파라미터 만큼만 할당
				oPaValue = new Object[10];
				
				oPaValue[0] = sawonDTO.getJobstatus();
				oPaValue[1] = sawonDTO.getSabun();
				oPaValue[2] = ComMgr.IsNull(sawonDTO.getName(), "");
				oPaValue[3] = sawonDTO.getAge();
				oPaValue[4] = ComMgr.IsNull(sawonDTO.getGender(), "");
				oPaValue[5] = ComMgr.IsNull(sawonDTO.getTel(), "");
				oPaValue[6] = ComMgr.IsNull(sawonDTO.getDept(), "");
				oPaValue[7] = ComMgr.IsNull(sawonDTO.getStcd(), "");
				oPaValue[8] = ComMgr.IsNull(sawonDTO.getBdate(), "");
				oPaValue[9] = ComMgr.IsNull(sawonDTO.getAddress(), "");
				
				if (this.DBMgr.RunQuery(sSql, oPaValue, 0, false) == true)
				{
					this.DBMgr.DbCommit();
					
					bResult = true;
				}
			}
	    	// -----------------------------------------------------------------------------
		}
		catch (Exception Ex)
		{
			Common.ExceptionMgr.DisplayException(Ex);		// 예외처리(콘솔)
		}
		finally
		{
			this.DBMgr.DbDisConnect();
		}
		
		return bResult;
	}
	// —————————————————————————————————————————————————————————————————————————————————————
}
//#################################################################################################
//<END>
//#################################################################################################
