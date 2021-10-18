/**
 * <pre>
 * 프로젝트명 : BasicBoard
 * 패키지명   : com.icia.web.db
 * 파일명     : DBManager.java
 * 작성일     : 2021. 1. 5.
 * 작성자     : daekk
 * </pre>
 */
package com.icia.web.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

//import org.apache.logging.log4j.LogManager;
//import org.apache.logging.log4j.Logger;

/**
 * <pre>
 * 패키지명   : com.icia.web.db
 * 파일명     : DBManager.java
 * 작성일     : 2021. 1. 5.
 * 작성자     : daekk
 * 설명       : DB 관리자
 * </pre>
 */
public final class DBManager
{
	//private static Logger logger = LogManager.getLogger(DBManager.class);
	
	// JDBC 드라이버명
	private static final String driverClassName = "oracle.jdbc.OracleDriver";
	// JDBC URL
	private static final String jdbcUrl = "jdbc:oracle:thin:@localhost:1521:XE";
	// 계정
	private static final String userName = "iciauser";
	// 비밀번호
	private static final String password = "1234";
	
	private DBManager() {}

	/**
	 * <pre>
	 * 메소드명   : getConnection
	 * 작성일     : 2021. 1. 5.
	 * 작성자     : daekk
	 * 설명       : 데이터베이스 연결 객체를 얻는다.
	 * </pre>
	 * @return java.sql.Connection
	 */
	public static Connection getConnection()
	{
		Connection conn = null;
				
		try
		{
			// 드라이버 로드
			Class.forName(driverClassName);
			
			// Database 연결 객체를 얻는다.
			conn = DriverManager.getConnection(jdbcUrl, userName, password);
		}
		catch (ClassNotFoundException e)
		{
			System.out.println("[DBManager] getConnection ClassNotFoundException");
		}
		catch (SQLException e)
		{
			System.out.println("[DBManager] getConnection SQLException");
		}				
		
		return conn;
	}
	
	/**
	 * <pre>
	 * 메소드명   : close
	 * 작성일     : 2021. 1. 5.
	 * 작성자     : daekk
	 * 설명       : ResultSet 객체를 닫는다.
	 * </pre>
	 * @param rs java.sql.ResultSet
	 */
	public static void close(ResultSet rs)
	{
		close(rs, null, null);
	}
	
	/**
	 * <pre>
	 * 메소드명   : close
	 * 작성일     : 2021. 1. 5.
	 * 작성자     : daekk
	 * 설명       : PreparedStatement 객체를 닫는다.
	 * </pre>
	 * @param pstmt java.sql.PreparedStatement
	 */
	public static void close(PreparedStatement pstmt)
	{
		close(null, pstmt, null);
	}
	
	/**
	 * <pre>
	 * 메소드명   : close
	 * 작성일     : 2021. 1. 5.
	 * 작성자     : daekk
	 * 설명       : Connection 객체를 닫는다.
	 * </pre>
	 * @param conn java.sql.Connection
	 */
	public static void close(Connection conn)
	{
		close(null, null, conn);
	}
	
	/**
	 * <pre>
	 * 메소드명   : close
	 * 작성일     : 2021. 1. 5.
	 * 작성자     : daekk
	 * 설명       : ResultSet, PreparedStatement 객체를 닫는다.
	 * </pre>
	 * @param rs    java.sql.ResultSet
	 * @param pstmt java.sql.PreparedStatement
	 */
	public static void close(ResultSet rs, PreparedStatement pstmt)
	{
		close(rs, pstmt, null);
	}
	
	/**
	 * <pre>
	 * 메소드명   : close
	 * 작성일     : 2021. 1. 5.
	 * 작성자     : daekk
	 * 설명       : PreparedStatement, Connection 객체를 닫는다.
	 * </pre>
	 * @param pstmt java.sql.PreparedStatement
	 * @param conn  java.sql.Connection
	 */
	public static void close(PreparedStatement pstmt, Connection conn)
	{
		close(null, pstmt, conn);
	}
	
	/**
	 * <pre>
	 * 메소드명   : close
	 * 작성일     : 2021. 1. 5.
	 * 작성자     : daekk
	 * 설명       : 데이터베이스 객체를 닫는다.
	 * </pre>
	 * @param rs    java.sql.ResultSet
	 * @param pstmt java.sql.PreparedStatement
	 * @param conn  java.sql.Connection
	 */
	public static void close(ResultSet rs, PreparedStatement pstmt, Connection conn)
	{
		if(rs != null)
		{
			try
			{
				rs.close();
			}
			catch (SQLException e)
			{
				System.out.println("[DBManager] close ResultSet SQLException");
			}
		}
		
		if(pstmt != null)
		{
			try
			{
				pstmt.close();
			}
			catch (SQLException e)
			{
				System.out.println("[DBManager] close PreparedStatement SQLException");
			}
		}
		
		if(conn != null)
		{
			try
			{
				conn.close();
			}
			catch (SQLException e)
			{
				System.out.println("[DBManager] close Connection SQLException");
			}
		}
	}
	
	/**
	 * <pre>
	 * 메소드명   : setAutoCommit
	 * 작성일     : 2021. 1. 5.
	 * 작성자     : daekk
	 * 설명       : commit 모드 변경
	 * </pre>
	 * @param conn java.sql.Connection
	 * @param flag boolean
	 */
	public static void setAutoCommit(Connection conn, boolean flag)
	{
		if(conn != null)
		{
			try
			{
				if(conn.getAutoCommit() != flag)
				{
					conn.setAutoCommit(flag);
				}
			}
			catch (SQLException e)
			{
				System.out.println("[DBManager] setAutoCommit SQLException");
			}
		}
	}
	
	/**
	 * <pre>
	 * 메소드명   : rollback
	 * 작성일     : 2021. 1. 5.
	 * 작성자     : daekk
	 * 설명       : rollback
	 * </pre>
	 * @param conn java.sql.Connection
	 */
	public static void rollback(Connection conn)
	{
		if(conn != null)
		{
			try
			{
				conn.rollback();
			}
			catch (SQLException e)
			{
				System.out.println("[DBManager] rollback SQLException");
			}
		}
	}
}
