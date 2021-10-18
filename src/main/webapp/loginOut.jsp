<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.icia.common.util.StringUtil" %>
<%@ page import="com.icia.web.util.HttpUtil" %>
<%@ page import="com.icia.web.util.CookieUtil" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%
   //http 로깅
   Logger logger = LogManager.getLogger("/loginOut.jsp");
   HttpUtil.requestLogString(request, logger);
   
   //쿠키가 있으면 삭제
   if(CookieUtil.getCookie(request, "USER_ID") != null)
   {
      CookieUtil.deleteCookie(request, response, "USER_ID");
   }
   
   response.sendRedirect("/");
%>