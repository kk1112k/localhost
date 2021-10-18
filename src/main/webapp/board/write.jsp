<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.icia.common.util.StringUtil" %>
<%@ page import="com.icia.web.util.HttpUtil" %>
<%@ page import="com.icia.web.util.CookieUtil" %>
<%@ page import="com.icia.web.dao.UserDao" %>
<%@ page import="com.icia.web.model.User" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%
	Logger logger = LogManager.getLogger("/board/write.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	String searchType = HttpUtil.get(request, "requestType", "");
	String searchValue = HttpUtil.get(request, "searchValue", "");
	long curPage = HttpUtil.get(request, "curpage", (long)1);
	
	UserDao userDao = new UserDao();
	User user = userDao.userSelect(cookieUserId);

%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>
<script type="text/javascript">
$(document).ready(function() {
    
   // $("#bbsName").focus();
   $("#bbsTitle").focus();
   // console.log( "ready!" );
   $("#btnWrite").on("click", function() {
      
      /*
      if($.trim($("#bbsName").val()).length <= 0)
      {
         alert("이름을 입력하세요.");
         $("#bbsName").val("");
         $("#bbsName").focus();
         return;
      }
      
      if($.trim($("#bbsEmail").val()).length <= 0)
      {
         alert("이메일을 입력하세요.");
         $("#bbsEmail").val("");
         $("#bbsEmail").focus();
         return;
      }
      
      if(!fn_validateEmail($("#bbsEmail").val()))
      {
         alert("이메일 형식이 올바르지 않습니다.");
         $("#bbsEmail").focus();
         return;   
      }
      */
      if($.trim($("#bbsTitle").val()).length <= 0)
      {
         alert("제목을 입력하세요.");
         $("#bbsTitle").val("");
         $("#bbsTitle").focus();
         return;
      }
      
      if($.trim($("#bbsContent").val()).length <= 0)
      {
         alert("내용을 입력하세요.");
         $("#bbsContent").val("");
         $("#bbsContent").focus();
         return;
      }
      
      document.writeForm.submit();
   });
   
   $("#btnList").on("click", function() {
      document.bbsForm.action = "/board/list.jsp";
      document.bbsForm.submit();
   });
});

function fn_validateEmail(value)
{
   var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
   
   return emailReg.test(value);
}
</script>
</head>
<body>
<%@ include file="/include/navigation.jsp" %>
<div class="container">
   <h2>게시물 쓰기</h2>
   <form name="writeForm" id="writeForm" action="/board/writeProc.jsp" method="post" >
      <input type="text" name="bbsName" id="bbsName" maxlength="20" value="<%=user.getUserName() %>" style="ime-mode:active;" class="form-control mt-4 mb-2" placeholder="이름을 입력해주세요." readonly />
      <input type="text" name="bbsEmail" id="bbsEmail" maxlength="30" value="<%=user.getUserEmail() %>" style="ime-mode:inactive;" class="form-control mb-2" placeholder="이메일을 입력해주세요." readonly />
      <input type="text" name="bbsTitle" id="bbsTitle" maxlength="100" style="ime-mode:active;" class="form-control mb-2" placeholder="제목을 입력해주세요." required />
      <div class="form-group">
         <textarea class="form-control" rows="10" name="bbsContent" id="bbsContent" style="ime-mode:active;" placeholder="내용을 입력해주세요" required></textarea>
      </div>
      <div class="form-group row">
         <div class="col-sm-12">
            <button type="button" id="btnWrite" class="btn btn-primary" title="저장">저장</button>
            <button type="button" id="btnList" class="btn btn-secondary" title="리스트">리스트</button>
         </div>
      </div>
   </form>
   <form name="bbsForm" id="bbsForm" method="post">
      <input type="hidden" name="searchType" value="<%=searchType %>" />
      <input type="hidden" name="searchValue" value="<%=searchValue %>" />
      <input type="hidden" name="curPage" value="<%=curPage %>" />
   </form>
</div>
</body>
</html>