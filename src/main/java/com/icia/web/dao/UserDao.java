
package com.icia.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.icia.common.util.StringUtil;
import com.icia.web.db.DBManager;
import com.icia.web.model.User;

public class UserDao 
{
   public UserDao()
   {
      
   }
   
   public int userInsert(User user)
   {
      int count = 0;
      Connection conn = null;
      PreparedStatement pstmt = null;
      StringBuilder sql = new StringBuilder();
      
      sql.append("INSERT INTO TBL_USER "); 
      sql.append("   (USER_ID, USER_PWD, USER_NAME, USER_EMAIL, STATUS, REG_DATE) ");
      sql.append("VALUES ");
      sql.append("   (?, ?, ?, ?, ?, SYSDATE) ");
      
      try
      {
         int idx = 0;
         conn = DBManager.getConnection();
         pstmt = conn.prepareStatement(sql.toString());
         
         pstmt.setString(++idx, user.getUserId());
         pstmt.setString(++idx, user.getUserPwd());
         pstmt.setString(++idx, user.getUserName());
         pstmt.setString(++idx, user.getUserEmail());
         pstmt.setString(++idx, user.getStatus());
         
         count = pstmt.executeUpdate();
      }
      catch(Exception e)
      {
         System.out.println("[UserDao] userInsert SQLException");
      }
      finally
      {
         DBManager.close(pstmt, conn);
      }
      
      return count;
   }
   
   public int userUpdate(User user)
   {
      int count = 0;
      Connection conn = null;
      PreparedStatement pstmt = null;
      StringBuilder sql = new StringBuilder();
      
      sql.append("UPDATE TBL_USER SET ");
      sql.append("    USER_PWD = ?, ");
      sql.append("    USER_NAME = ?, ");
      sql.append("    USER_EMAIL = ? ");
      sql.append(" WHERE ");
      sql.append("    USER_ID = ? ");
      
      try
      {
         int idx = 0;
         conn = DBManager.getConnection();
         pstmt = conn.prepareStatement(sql.toString());
         
         pstmt.setString(++idx, user.getUserPwd());
         pstmt.setString(++idx, user.getUserName());
         pstmt.setString(++idx, user.getUserEmail());
         pstmt.setString(++idx, user.getUserId());
         
         count = pstmt.executeUpdate();
      }
      catch(Exception e)
      {
         System.out.println("[UserDao] userUpdate SQLException");
      }
      finally
      {
         DBManager.close(pstmt, conn);
      }
      
      return count;
   }

   public int userStatusUpdate(User user)
   {
      int count = 0;
      Connection conn = null;
      PreparedStatement pstmt = null;
      StringBuilder sql = new StringBuilder();
      
      sql.append("UPDATE TBL_USER SET ");
      sql.append("    STATUS = ?, ");
      sql.append(" WHERE ");
      sql.append("    USER_ID = ? ");
      
      try
      {
         int idx = 0;
         conn = DBManager.getConnection();
         pstmt = conn.prepareStatement(sql.toString());
         
         pstmt.setString(++idx, user.getStatus());
         pstmt.setString(++idx, user.getUserId());
         
         count = pstmt.executeUpdate();
      }
      catch(Exception e)
      {
         System.out.println("[UserDao] userStatusUpdate SQLException");
      }
      finally
      {
         DBManager.close(pstmt, conn);
      }
      
      return count;
   }

   
   public User userSelect(String userId)
   {
      User user = null;
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      StringBuilder sql = new StringBuilder();
      
      sql.append("SELECT ");
      sql.append("      USER_ID, ");
      sql.append("      NVL(USER_PWD, '') AS USER_PWD, ");
      sql.append("      NVL(USER_NAME, '') AS USER_NAME, ");
      sql.append("      NVL(USER_EMAIL, '') AS USER_EMAIL, ");
      sql.append("      NVL(STATUS, '') AS STATUS, ");
      sql.append("      NVL(TO_CHAR(REG_DATE, 'YYYY.MM.DD HH24:MI:SS'), '') AS REG_DATE ");
      sql.append(" FROM ");
      sql.append("      TBL_USER ");
      sql.append("WHERE USER_ID = ? ");  
      
      try
      {
         conn = DBManager.getConnection();
         pstmt = conn.prepareStatement(sql.toString());
         
         pstmt.setString(1, userId);
         
         rs = pstmt.executeQuery();
         
         if(rs.next())
         {
            user = new User();
            
            user.setUserId(StringUtil.nvl(rs.getString("USER_ID")));
            user.setUserPwd(StringUtil.nvl(rs.getString("USER_PWD")));
            user.setUserName(StringUtil.nvl(rs.getString("USER_NAME")));
            user.setUserEmail(StringUtil.nvl(rs.getString("USER_EMAIL")));
            user.setStatus(StringUtil.nvl(rs.getString("STATUS")));
            user.setRegDate(StringUtil.nvl(rs.getString("REG_DATE")));
         }
      }
      catch(Exception e)
      {
         System.out.println("[UserDao] userSelect SQLException");
      }
      finally
      {
         DBManager.close(rs, pstmt, conn);
      }
      
      return user;
   }
   
   
   public int userIdSelect(String userId)
   {
      int count = 0;
      User user = null;
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      StringBuilder sql = new StringBuilder();
      
      sql.append("SELECT ");
      sql.append("      COUNT(USER_ID) AS CNT ");
      sql.append(" FROM ");
      sql.append("      TBL_USER ");
      sql.append("WHERE USER_ID = ? ");  
      
      try
      {
         conn = DBManager.getConnection();
         pstmt = conn.prepareStatement(sql.toString());
         
         pstmt.setString(1, userId);
         
         rs = pstmt.executeQuery();
         
         if(rs.next())
         {
            count = rs.getInt("CNT");
         }
      }
      catch(Exception e)
      {
         System.out.println("[UserDao] userIdSelect SQLException");
      }
      finally
      {
         DBManager.close(rs, pstmt, conn);
      }
      
      return count;
   }
   
}