<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.icia.common.util.StringUtil" %>
<%@ page import="com.icia.web.util.HttpUtil" %>
<%@ page import="com.icia.web.util.CookieUtil" %>
<%@ page import="com.icia.web.dao.UserDao" %>
<%@ page import="com.icia.web.model.User" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%
	Logger logger=LogManager.getLogger("/user/userUpdateForm.jsp");
	HttpUtil.requestLogString(request, logger);	
	
	User user = null;
	String cookieUserId =CookieUtil.getValue(request, "USER_ID");
	
	if(!StringUtil.isEmpty(cookieUserId))
	{
		//쿠키정보가 있으면
		logger.debug("cookieUserId : " +  cookieUserId);
		
		UserDao userDao = new UserDao();
		user = userDao.userSelect(cookieUserId);
		
		if(user == null)
		{
			CookieUtil.deleteCookie(request, response, "USER_ID");
			response.sendRedirect("/");
		}
		else
		{
			if(!StringUtil.equals(user.getStatus(), "Y"))
			{
				CookieUtil.deleteCookie(request, response, "USER_ID");
				user = null;
				
				response.sendRedirect("/");
			}
		}
	}

	if(user != null)
	{
		
	
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>
<script type="text/javascript">
$(document).ready(function() {

   $("#btnUpdate").on("click", function() {
      
      // 모든 공백 체크 정규식
      var emptCheck = /\s/g;
      // 영문 대소문자, 숫자로만 이루어진 4~12자리 정규식
      var idPwCheck = /^[a-zA-Z0-9]{4,12}$/;
            
      if($.trim($("#userPwd1").val()).length <= 0)
      {
         alert("비밀번호를 입력하세요.");
         $("#userPwd1").val("");
         $("#userPwd1").focus();
         return;
      }
      
      if (emptCheck.test($("#userPwd1").val())) 
      {
         alert("비밀번호는 공백을 포함할 수 없습니다.");
         $("#userPwd1").focus();
         return;
      }
      
      if (!idPwCheck.test($("#userPwd1").val())) 
      {
         alert("비밀번호는 영문 대소문자와 숫자로 4~12자리 입니다.");
         $("#userPwd1").focus();
         return;
      }
      
      if ($("#userPwd1").val() != $("#userPwd2").val()) 
      {
         alert("비밀번호가 일치하지 않습니다.");
         $("#userPwd2").focus();
         return;
      }
      
      if($.trim($("#userName").val()).length <= 0)
      {
         alert("사용자 이름을 입력하세요.");
         $("#userName").val("");
         $("#userName").focus();
         return;
      }
      
      if(!fn_validateEmail($("#userEmail").val()))
      {
         alert("사용자 이메일 형식이 올바르지 않습니다.");
         $("#userEmail").focus();
         return;   
      }
      
      $("#userPwd").val($("#userPwd1").val());
      
      document.updateForm.submit();
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
    <div class="row mt-5">
       <h1>회원정보수정</h1>
    </div>
    <div class="row mt-2">
        <div class="col-12">
            <form name="updateForm" id="updateForm" action="/user/userProc.jsp" method="post">
                <div class="form-group">
                    <label for="username">사용자 아이디</label>
                    <%=user.getUserId() %> icia
                </div>
                <div class="form-group">
                    <label for="username">비밀번호</label>
                    <input type="password" class="form-control" id="userPwd1" name="userPwd1" value="<%=user.getUserPwd() %>" placeholder="비밀번호" maxlength="12" />        
                </div>
                <div class="form-group">
                    <label for="username">비밀번호 확인</label>
                    <input type="password" class="form-control" id="userPwd2" name="userPwd2" value="<%=user.getUserPwd() %>" placeholder="비밀번호 확인" maxlength="12" />
                </div>
                <div class="form-group">
                    <label for="username">사용자 이름</label>
                    <input type="text" class="form-control" id="userName" name="userName" value="<%=user.getUserName() %>" placeholder="사용자 이름" maxlength="15" />
                </div>
                <div class="form-group">
                    <label for="username">사용자 이메일</label>
                    <input type="text" class="form-control" id="userEmail" name="userEmail" value="<%=user.getUserEmail() %>" placeholder="사용자 이메일" maxlength="30" />
                </div>
                <input type="hidden" id="userId" name="userId" value="<%=user.getUserId() %>" />
                <input type="hidden" id="userPwd" name="userPwd" value="" />
                <button type="button" id="btnUpdate" class="btn btn-primary">수정</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
  <%
	}
  %>
  