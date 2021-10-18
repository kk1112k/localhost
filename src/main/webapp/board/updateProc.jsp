<!-- 
오류메세지 종류
1.게시물 수정중 오류가 발생했습니다.(업데이트시)
2. 게시물이 존재하지 않습니다. (게시판에 해당 레코드가 없거나 쿠키아이다와 유저아이디가 다를때)
3.게시물수정값이 올바르지 않습니다. (파라미터 받은 값이 널일때)
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
   Logger logger = LogManager.getLogger("/board/updateProc.jsp");
   HttpUtil.requestLogString(request, logger);

   String cookieUserId=CookieUtil.getValue(request,"USER_ID");
   
   boolean bSuccess=false;
   String errorMsg="";
      
   long bbsSeq=HttpUtil.get(request, "bbsSeq", (long)0);
   String searchType=HttpUtil.get(request, "searchType", "");
   String searchValue=HttpUtil.get(request, "searchValue", "");
   long curPage=HttpUtil.get(request, "curPage", (long)1);
   
   String bbsName=HttpUtil.get(request, "bbsName", "");
   String bbsEmail=HttpUtil.get(request, "bbsEmail", "");
   String bbsTitle=HttpUtil.get(request, "bbsTitle", "");
   String bbsContent=HttpUtil.get(request, "bbsContent", "");
   
   if(bbsSeq>0 && !StringUtil.isEmpty(bbsName) && !StringUtil.isEmpty(bbsEmail) 
            && !StringUtil.isEmpty(bbsTitle) && !StringUtil.isEmpty(bbsContent))
   {
      BoardDao boardDao=new BoardDao();
      Board board=boardDao.boardSelect(bbsSeq);
      
      if(board != null && StringUtil.equals(cookieUserId, board.getUserId()))
      {
         board.setBbsSeq(bbsSeq);
         board.setBbsName(bbsName);
         board.setBbsEMail(bbsEmail);
         board.setBbsTitle(bbsTitle);
         board.setBbsContent(bbsContent);
         
         if(boardDao.boardUpdate(board)>0)
         {
            bSuccess=true;
         }
         else
         {
            errorMsg="게시물 수정중 오류가 발생하였습니다.";
         }
      }
      else
      {
         errorMsg="게시물이 존재하지 않습니다.";
      }
   }
   else
   {
      errorMsg="게시물 수정 값이 올바르지 않습니다.";
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
   alert("게시물이 수정 되었습니다.");
   document.bbsForm.action = "/board/view.jsp";
   document.bbsForm.submit();
<%
   }
   else
   {
%>
   alert("<%=errorMsg%>");
   location.href = "/board/list.jsp";
<%
   }
%>
});   
</script>
</head>
<body>
<form name="bbsForm" id="bbsForm" method="post">
   <input type="hidden" name="bbsSeq" value="<%=bbsSeq %>" />
   <input type="hidden" name="searchType" value="<%=searchType %>" />
   <input type="hidden" name="searchValue" value="<%=searchValue %>" />
   <input type="hidden" name="curPage" value="<%=curPage %>" />
</form>
</body>
</html>