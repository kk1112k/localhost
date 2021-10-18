<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.icia.common.util.StringUtil" %>
<%@ page import="com.icia.web.util.HttpUtil" %>
<%@ page import="com.icia.web.util.CookieUtil" %>
<%@ page import="com.icia.web.dao.BoardDao" %>
<%@ page import="com.icia.web.model.Board" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%
   Logger logger = LogManager.getLogger("/board/writeProc.jsp");
   HttpUtil.requestLogString(request, logger);
   
   String cookieUserId = CookieUtil.getValue(request, "USER_ID");
   
   boolean bSuccess = false;
   String errorMsg = "";
   
   String bbsTitle = HttpUtil.get(request, "bbsTitle", "");
   String bbsContent = HttpUtil.get(request, "bbsContent", "");
   
   if(!StringUtil.isEmpty(bbsTitle) && !StringUtil.isEmpty(bbsContent))
   {
      BoardDao boardDao = new BoardDao();
      Board board = new Board();
      
      board.setUserId(cookieUserId);
      board.setBbsTitle(bbsTitle);
      board.setBbsContent(bbsContent);
      
      if(boardDao.boardInsert(board) > 0)
      {
         bSuccess = true;
      }
      else
      {
         errorMsg = "게시물 등록 중 오류가 발생하였습니다.";
      }
   }
   else
   {
      errorMsg = "게시물 입력값이 올바르지 않습니다.";
   }
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>
<script>
$(document).ready(function(){
<%
   if(bSuccess == true)
   {
%>
   alert("게시물이 등록 되었습니다.");
<%
   }
   else
   {
%>
   alert("<%=errorMsg%>");
<%
   }
%>
   location.href = "/board/list.jsp";
});
</script>
</head>
<body>

</body>
</html>