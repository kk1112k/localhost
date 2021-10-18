<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.icia.common.util.StringUtil" %>
<%@ page import="com.icia.web.util.HttpUtil" %>
<%@ page import="com.icia.web.util.CookieUtil" %>
<%@ page import="com.icia.web.dao.UserDao" %>
<%@ page import="com.icia.web.model.User" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%
   Logger logger=LogManager.getLogger("/user/userProc.jsp");
   HttpUtil.requestLogString(request, logger);
   
   String redirectUrl="";
   String msg="";
   
   String userId=HttpUtil.get(request, "userId");
   String userPwd=HttpUtil.get(request, "userPwd");
   String userName=HttpUtil.get(request, "userName");
   String userEmail=HttpUtil.get(request, "userEmail");
   String cookieUserId=CookieUtil.getValue(request, "USER_ID");
   
   UserDao userDao=new UserDao();
   
   if(StringUtil.isEmpty(cookieUserId))
   {
      //회원가입
      if(!StringUtil.isEmpty(userId)&&!StringUtil.isEmpty(userPwd)
            &&!StringUtil.isEmpty(userName)&&!StringUtil.isEmpty(userEmail))
      {
         //정상가입
         if(userDao.userIdSelect(userId)>0)
         {
            msg="사용자 아이디가 중복되었습니다.";
            redirectUrl="/user/userRegForm.jsp";
         }
         else
         {
            User user=new User();
            user.setUserId(userId);
            user.setUserPwd(userPwd);
            user.setUserName(userName);
            user.setUserEmail(userEmail);
            user.setStatus("Y");
            
            if(userDao.userInsert(user)>0)
            {
               msg="회원가입이 완료되었습니다.";
               redirectUrl="/";
            }
            else
            {
               msg="회원가입중 오류가 발생했습니다.";
               redirectUrl="user/userRegForm.jsp";
            }
         }
      }
      else
      {
         //입력값이 넘어오지 않는경우
         msg="회원가입 중 입력정보가 올바르지 않습니다.";
         redirectUrl="/user/userRegForm.jsp";
      }
   }
   else
   {
      //회원정보수정
      User user = userDao.userSelect(cookieUserId);
      
      if(user != null)
      {
    	  if(StringUtil.equals(user.getUserId(),userId) && 
    			  StringUtil.equals(user.getStatus(), "Y"))
    	  {
    		  user.setUserPwd(userPwd);
    		  user.setUserName(userName);
    		  user.setUserEmail(userEmail);
    		  
    		  if(userDao.userUpdate(user) > 0)
    		  {
    			  msg = "회원정보가 수정되었습니다.";
    			  redirectUrl = "/user/userUpdateForm.jsp";
    		  }
    		  else
    		  {
    			  msg="회원정보 수정 중 오류가 발생했습니다.";
    			  redirectUrl="/user/userUpdateForm.jsp";
    		  }
    	  }
    	  else
    	  {
    		  msg ="회원 정보중 값이 올바르지 않습니다.";
    		  redirectUrl = "/";
    	  }
      }
      else
      {
    	  CookieUtil.deleteCookie(request, response,"USER_ID");
    	  
    	  msg = "올바른 사용자가 아닙니다.";
		  redirectUrl= "/" ;
		  
      }
   }
%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>
<script>
$(document).ready(function(){
   alert("<%=msg%>");
   location.href="<%=redirectUrl%>";
});
</script>
</head>
<body>

</body>
</html>