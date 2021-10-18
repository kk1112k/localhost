package com.icia.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.icia.common.util.StringUtil;
import com.icia.web.db.DBManager;
import com.icia.web.model.Board;

public class BoardDao 
{
   private static Logger logger = LogManager.getLogger(BoardDao.class);
   
   public BoardDao()
   {
      
   }
   
   //총 게시물 수 얻기
   public long boardTotalCount(Board search)
   {
      long totalCount = 0;
      
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      StringBuilder sql = new StringBuilder();
      
      sql.append("SELECT COUNT(A.BBS_SEQ) AS TOTAL_COUNT ");
      sql.append("  FROM TBL_BOARD A, TBL_USER B ");
      sql.append(" WHERE B.USER_ID = A.USER_ID ");

      
      if(search != null)
      {
         if(!StringUtil.isEmpty(search.getBbsName()))
         {   
            sql.append("   AND B.USER_NAME LIKE '%' || ? || '%' ");
         }
         
         if(!StringUtil.isEmpty(search.getBbsTitle()))
         {
            sql.append("   AND A.BBS_TITLE LIKE'%' || ? || '%' ");
         }
         
         if(!StringUtil.isEmpty(search.getBbsContent()))
         {
            sql.append("   AND DBMS_LOB.INSTR(A.BBS_CONTENT, ?) > 0 ");
         }
      }
      
      try
      {
         int idx = 0;
         conn = DBManager.getConnection();
         pstmt = conn.prepareStatement(sql.toString());
         
         if(search != null)
         {
            if(!StringUtil.isEmpty(search.getBbsName()))
            {
               pstmt.setString(++idx, search.getBbsName());
            }
            
            if(!StringUtil.isEmpty(search.getBbsTitle()))
            {
               pstmt.setString(++idx, search.getBbsTitle());
            }
            
            if(!StringUtil.isEmpty(search.getBbsContent()))
            {
               pstmt.setString(++idx, search.getBbsContent());
            }
         }
         
         logger.debug("[totalCount] : " + sql.toString());
         
         rs = pstmt.executeQuery();
         
         if(rs.next())
         {
            totalCount = rs.getLong("TOTAL_COUNT");
         }
         
      }
      catch(SQLException e)
      {
         logger.error("[BoardDao] boardTotalCount SQLException", e);
      }
      finally
      {
         DBManager.close(rs, pstmt, conn);
      }
      
      return totalCount;
   }
   
   //게시판 리스트
   public List<Board> boardList(Board search)
   {
      List<Board> list = new ArrayList<Board>();
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      StringBuilder sql = new StringBuilder();
      
      sql.append("SELECT BBS_SEQ, ");
      sql.append("       USER_ID, ");
      sql.append("       BBS_NAME, ");
      sql.append("       BBS_EMAIL, ");
      sql.append("      BBS_PWD, ");
      sql.append("       BBS_TITLE, ");
      sql.append("       BBS_CONTENT, ");
      sql.append("       BBS_READ_CNT, ");
      sql.append("       REG_DATE ");
      sql.append("  FROM (SELECT ROWNUM AS RNUM, ");
      sql.append("               BBS_SEQ, ");
      sql.append("               USER_ID, ");
      sql.append("               BBS_NAME, ");
      sql.append("               BBS_EMAIL, ");
      sql.append("               BBS_PWD, ");
      sql.append("               BBS_TITLE, ");
      sql.append("               BBS_CONTENT, ");
      sql.append("               BBS_READ_CNT, ");
      sql.append("               REG_DATE ");
      sql.append("          FROM (SELECT A.BBS_SEQ AS BBS_SEQ, ");
      sql.append("                       NVL(B.USER_ID, '') AS USER_ID, ");
      sql.append("                       NVL(B.USER_NAME, '') AS BBS_NAME, ");
      sql.append("                       NVL(B.USER_EMAIL, '') AS BBS_EMAIL, ");
      sql.append("                       NVL(A.BBS_PWD, '') AS BBS_PWD, ");
      sql.append("                       NVL(A.BBS_TITLE, '') AS BBS_TITLE, ");
      sql.append("                       NVL(A.BBS_CONTENT, '') AS BBS_CONTENT, ");
      sql.append("                       NVL(A.BBS_READ_CNT, 0) AS BBS_READ_CNT, ");
      sql.append("                       NVL(TO_CHAR(A.REG_DATE, 'YYYY.MM.DD HH24:MI:SS'), '') AS REG_DATE ");
      sql.append("                  FROM TBL_BOARD A, TBL_USER B ");
      sql.append("                 WHERE B.USER_ID = A.USER_ID ");
      
      if(search != null)
      {   
         if(!StringUtil.isEmpty(search.getBbsName()))
         {   
            sql.append("                   AND B.USER_NAME LIKE '%' || ? || '%' ");
         }
         
         if(!StringUtil.isEmpty(search.getBbsTitle()))
         {   
            sql.append("                   AND A.BBS_TITLE LIKE'%' || ? || '%' ");
         }
         if(!StringUtil.isEmpty(search.getBbsContent()))
         {   
            sql.append("                   AND DBMS_LOB.INSTR(A.BBS_CONTENT, ?) > 0 ");
         }
      }
      
      sql.append("                 ORDER BY A.BBS_SEQ DESC)) ");
      
      if(search != null)
      {
         sql.append(" WHERE RNUM >= ? ");
         sql.append("   AND RNUM <= ? ");
      }
      
      try
      {
         int idx = 0;
         conn = DBManager.getConnection();
         pstmt = conn.prepareStatement(sql.toString());
         
         if(search != null)
         {
            if(!StringUtil.isEmpty(search.getBbsName()))
            {
               pstmt.setString(++idx, search.getBbsName());
            }
            
            if(!StringUtil.isEmpty(search.getBbsTitle()))
            {
               pstmt.setString(++idx, search.getBbsTitle());
            }
            
            if(!StringUtil.isEmpty(search.getBbsContent()))
            {
               pstmt.setString(++idx, search.getBbsContent());
            }
            
            pstmt.setLong(++idx, search.getStartRow());
            pstmt.setLong(++idx, search.getEndRow());
            
            rs = pstmt.executeQuery();
            
            while(rs.next())
            {
               Board board = new Board();
               
               board.setBbsSeq(rs.getLong("BBS_SEQ"));
               board.setUserId(rs.getString("USER_ID"));
               board.setBbsName(rs.getString("BBS_NAME"));
               board.setBbsEMail(rs.getString("BBS_EMAIL"));
               board.setBbsPwd(rs.getString("BBS_PWD"));
               board.setBbsTitle(rs.getString("BBS_TITLE"));
               board.setBbsContent(rs.getString("BBS_CONTENT"));
               board.setBbsReadCnt(rs.getInt("BBS_READ_CNT"));
               board.setRegDate(rs.getString("REG_DATE"));
               
               list.add(board);
            }
         }
      }
      catch(SQLException e)
      {
         logger.error("[BoardDao] boardList SQLException", e);
      }
      finally
      {
         DBManager.close(rs, pstmt, conn);
      }
      
      return list;
   }
   
   // 게시물등록
   public int boardInsert(Board board)
   {
      int count = 0;
      Connection conn = null;
      PreparedStatement pstmt = null;
      StringBuilder sql = new StringBuilder();
      
      sql.append("INSERT INTO TBL_BOARD "); 
       sql.append("   (BBS_SEQ, USER_ID, BBS_NAME, BBS_EMAIL, BBS_PWD, BBS_TITLE, BBS_CONTENT, BBS_READ_CNT, REG_DATE) ");
       sql.append("VALUES (?, ?, ?, ?, ?, ?, ?, 0, SYSDATE) ");
       
       try
       {
          int idx = 0;
          long bbsSeq = 0;
          conn = DBManager.getConnection();
          
          //시퀀스를 통한 게시물 번호 조회
          bbsSeq = newBbsSeq(conn);
          board.setBbsSeq(bbsSeq);
          
          pstmt = conn.prepareStatement(sql.toString());
          
          pstmt.setLong(++idx, bbsSeq);
          pstmt.setString(++idx, board.getUserId());
          pstmt.setString(++idx, board.getBbsName());
          pstmt.setString(++idx, board.getBbsEMail());
          pstmt.setString(++idx, board.getBbsPwd());
          pstmt.setString(++idx, board.getBbsTitle());
          pstmt.setString(++idx, board.getBbsContent());
          
          count = pstmt.executeUpdate();
          
       }
       catch(SQLException e)
       {
          logger.error("[BoardDao] boardInsert SQLException", e);
       }
       finally
       {
          DBManager.close(pstmt, conn);
       }
      return count;
   }
   
   //게시물 수정
   public int boardUpdate(Board board)
   {
      int count = 0;
      Connection conn = null;
      PreparedStatement pstmt = null;
      StringBuilder sql = new StringBuilder();
      
      sql.append("UPDATE TBL_BOARD ");
      sql.append("   SET BBS_TITLE = ?, ");
      sql.append("       BBS_CONTENT = ? ");
      sql.append(" WHERE BBS_SEQ = ? ");
      
      try
      {
         int idx = 0;
         conn = DBManager.getConnection();
         pstmt = conn.prepareStatement(sql.toString());
         
         pstmt.setString(++idx, board.getBbsTitle());
         pstmt.setString(++idx, board.getBbsContent());
         pstmt.setLong(++idx, board.getBbsSeq());
         
         count = pstmt.executeUpdate();
      }
      catch(SQLException e)
      {
         logger.error("[BoardDao] boardUpdate SQLException", e);
      }
      finally
      {
         DBManager.close(pstmt, conn);
      }
      
      return count;
   }
   
   //게시물 삭제
   public int boardDelete(long bbsSeq)
   {
      int count = 0;
      Connection conn = null;
      PreparedStatement pstmt = null;
      StringBuilder sql = new StringBuilder();      
      
      sql.append("DELETE FROM TBL_BOARD ");
      sql.append(" WHERE BBS_SEQ = ? ");
      
      try
      {
         conn = DBManager.getConnection();
         pstmt = conn.prepareStatement(sql.toString());
         
         pstmt.setLong(1, bbsSeq);
         
         count = pstmt.executeUpdate();
      }
      catch(SQLException e)
      {
         logger.error("[BoardDao] boardDelete SQLException", e);
      }
      finally
      {
         DBManager.close(pstmt, conn);
      }
      
      return count;
   }
   
   //선택된 게시물에 대한 조회
   public Board boardSelect(long bbsSeq)
   {
      Board board = null;
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      StringBuilder sql = new StringBuilder();            
      
      
      sql.append("SELECT ");
      sql.append("       BBS_SEQ, ");
      sql.append("       NVL(USER_ID, '') AS USER_ID, ");
      sql.append("       NVL(BBS_NAME, '') AS BBS_NAME, ");
      sql.append("       NVL(BBS_EMAIL, '') AS BBS_EMAIL, ");
      sql.append("       NVL(BBS_PWD, '') AS BBS_PWD, ");
      sql.append("       NVL(BBS_TITLE, '') AS BBS_TITLE, ");
      sql.append("       NVL(BBS_CONTENT, '') AS BBS_CONTENT, ");
      sql.append("       NVL(BBS_READ_CNT, 0) AS BBS_READ_CNT, ");
      sql.append("       NVL(TO_CHAR(REG_DATE, 'YYYY.MM.DD HH24:MI:SS'), '') AS REG_DATE ");
      sql.append("  FROM ");
      sql.append("       TBL_BOARD ");
      sql.append(" WHERE BBS_SEQ = ? ");
      
      try
      {
         conn = DBManager.getConnection();
         pstmt = conn.prepareStatement(sql.toString());
         
         pstmt.setLong(1, bbsSeq);
         
         rs = pstmt.executeQuery();
         
         if(rs.next())
         {
            board = new Board();
            
            board.setBbsSeq(rs.getLong("BBS_SEQ"));
            board.setUserId(StringUtil.nvl(rs.getString("USER_ID")));
            board.setBbsName(StringUtil.nvl(rs.getString("BBS_NAME")));
            board.setBbsEMail(StringUtil.nvl(rs.getString("BBS_EMAIL")));
            board.setBbsPwd(StringUtil.nvl(rs.getString("BBS_PWD")));
            board.setBbsTitle(StringUtil.nvl(rs.getString("BBS_TITLE")));
            board.setBbsContent(StringUtil.nvl(rs.getString("BBS_CONTENT")));
            board.setBbsReadCnt(rs.getInt("BBS_READ_CNT"));
            board.setRegDate(StringUtil.nvl(rs.getString("REG_DATE")));
         }
      }
      catch(SQLException e)
      {
         logger.error("[BoardDao] boardSelect SQLException", e);
      }
      finally
      {
         DBManager.close(pstmt, conn);
      }      
      
      return board;            
   }
   //게시물 조회시 조회카운트 증가
   public int boardReadCntPlus(long bbsSeq)
   {
      int count = 0;
      Connection conn = null;
      PreparedStatement pstmt = null;
      StringBuilder sql = new StringBuilder();   

      sql.append("UPDATE TBL_BOARD ");
      sql.append("   SET BBS_READ_CNT = BBS_READ_CNT +1 ");
      sql.append(" WHERE BBS_SEQ = ? ");      
      
      try
      {
         conn = DBManager.getConnection();
         pstmt = conn.prepareStatement(sql.toString());
         
         pstmt.setLong(1, bbsSeq);
         
         count = pstmt.executeUpdate();
      }
      catch(SQLException e)
      {
         logger.error("[BoardDao] boardReadCntPlus SQLException", e);
      }
      finally
      {
         DBManager.close(pstmt, conn);
      }   
      
      return count;
   }
   
   
   //게시물번호 조회(SEQ_BOARD 시퀀스 사용)
   private long newBbsSeq(Connection conn)
   {
      long bbsSeq = 0;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      StringBuilder sql = new StringBuilder();
      
      sql.append("SELECT SEQ_BOARD.NEXTVAL FROM DUAL "); 
      
      try
      {
         pstmt = conn.prepareStatement(sql.toString());
         rs = pstmt.executeQuery();
         
         if(rs.next())
         {
            bbsSeq = rs.getLong(1);
         }
      }
      catch(SQLException e)
      {
         logger.error("[BoardDao] newBbsSeq SQLException", e);
      }
      finally
      {
         DBManager.close(rs, pstmt);
      }
      
      return bbsSeq;
   }
}



