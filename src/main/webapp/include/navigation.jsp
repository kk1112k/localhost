<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.icia.common.util.StringUtil" %>
<%@ page import="com.icia.web.util.CookieUtil" %>

<%
	if(!StringUtil.isEmpty(CookieUtil.getValue(request, "USER_ID")))
	{
%>
<nav class="navbar navbar-expand-sm bg-secondary navbar-dark mb-3"> 
   <ul class="navbar-nav"> 
       <li class="nav-item"> 
         <a class="nav-link" href="/loginOut.jsp">로그아웃</a> 
       </li> 
       <li class="nav-item"> 
         <a class="nav-link" href="/user/userUpdateForm.jsp">회원정보수정</a> 
       </li> 
       <li class="nav-item"> 
         <a class="nav-link" href="/board/list.jsp">게시판</a> 
       </li> 
  </ul> 
</nav>

<%
	}
	else
	{
%>

<nav class="navbar navbar-expand-sm bg-secondary navbar-dark mb-3"> 
   <ul class="navbar-nav"> 
       <li class="nav-item"> 
         <a class="nav-link" href="/"> 로그인</a> 
       </li> 
       <li class="nav-item"> 
         <a class="nav-link" href="/user/userRegForm.jsp">회원가입</a> 
       </li> 
  </ul> 
</nav>

<%
	}
%>
