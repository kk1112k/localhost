<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.icia.common.util.StringUtil" %>
<%@ page import="com.icia.web.util.HttpUtil" %>
<%@ page import="com.icia.web.util.CookieUtil" %>
<%@ page import="com.icia.web.dao.UserDao" %>
<%@ page import="com.icia.web.model.User" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%
   Logger logger = LogManager.getLogger("/user/userIdCheckAjax.jsp");
   HttpUtil.requestLogString(request, logger);
   
   String userId = HttpUtil.get(request, "userId");
   
   if(!StringUtil.isEmpty(userId))
   {
      UserDao userDao = new UserDao();
      if(userDao.userIdSelect(userId) <= 0)
      {
         //사용 가능
         response.getWriter().write("{\"flag\":0}");
      }
      else
      {
         //중복
         response.getWriter().write("{\"flag\":1}");
      }
   }
   else
   {
      //userId 값이 없을때
      response.getWriter().write("{\"flag\":-1}");
   }

%>