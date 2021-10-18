<!-- 
오류처리
1.게시물 키 값이 올바르지 않습니다. (게시물 번호가 넘어오지 않았을때)
2.게시물 키 값이 올바르지 않습니다. (게시물 레코드 정보가 없을때)
3.로그인 사용자의 게시물이 아닙니다. (쿠키아이디와 게시물 아이디가 다른경우)
4.게시물 삭제 중 오류가 발생 했습니다. (삭제시 오류발생한 경우)
 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.icia.common.util.StringUtil" %>
<%@ page import="com.icia.web.util.HttpUtil" %>
<%@ page import="com.icia.web.util.CookieUtil" %>
<%@ page import="com.icia.web.dao.BoardDao" %>
<%@ page import="com.icia.web.model.Board" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%
   Logger logger = LogManager.getLogger("/board/delete.jsp");
   HttpUtil.requestLogString(request, logger);

   String cookieUserId=CookieUtil.getValue(request,"USER_ID");
   
   boolean bSuccess=false;
   String errorMsg="";
      
   long bbsSeq=HttpUtil.get(request, "bbsSeq", (long)0);
  
   
   if(bbsSeq > 0 )
   {
      BoardDao boardDao=new BoardDao();
      Board board=boardDao.boardSelect(bbsSeq);
      
      if(board != null)
      {
         if(StringUtil.equals(cookieUserId,board.getUserId()))  
         { 
        	 bSuccess=true;
         }
      		if(boardDao.boardDelete(bbsSeq) > 0)
      		{
      			
      		}
      		else
      		{
      			errorMsg="게시물 삭제 중 오류가 발생 했습니다.";
      		}
         }   
         else
         {
            errorMsg="로그인 사용자의 게시물이 아닙니다.  ";
         }
      }
      else
      {
            errorMsg="게시물 키 값이 올바르지 않습니다.";
      }
  
%>  
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>
<script type="text/javascript">
$(document).ready(function() {
<%
   if(bSuccess == true)
   {
%>
   alert("게시물이 삭제 되었습니다.");
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