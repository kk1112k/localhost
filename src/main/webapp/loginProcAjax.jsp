<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.icia.common.util.StringUtil" %>
<%@ page import="com.icia.web.util.CookieUtil" %>
<%@ page import="com.icia.web.util.HttpUtil" %>
<%@ page import="com.icia.web.model.User" %>
<%@ page import="com.icia.web.dao.UserDao" %>
<%
	System.out.println("loginProcAjax.jsp start . . . . ..");
	
	String userId = HttpUtil.get(request, "userId");
	String userPwd = HttpUtil.get(request, "userPwd");
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	System.out.println("cookieUserId : " + cookieUserId);
	
	if(!StringUtil.isEmpty(cookieUserId))
	{
		//쿠키삭제
		CookieUtil.deleteCookie(request, response, "USER_ID");
		System.out.println("쿠키[" + cookieUserId + "] 삭제");
	}
	
	if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd))
	{
		UserDao userDao = new UserDao();
		User user = userDao.userSelect(userId);
		
		// 여기에서 낙서되어야 한다.... 아니면 큰일난다.....
		
		if(user != null)
		{
			if(StringUtil.equals(user.getStatus(),"Y"))
			{
				if(StringUtil.equals(user.getUserPwd(), userPwd))
				{
					//쿠키 생성
					CookieUtil.addCookie(response, "USER_ID", userId);
					response.getWriter().write("{\"flag\":0}");
				}
				else
				{
					System.out.println("아이디[" + userId + "]의 비밀번호 [" + userPwd + "]가 일치하지 않음");
					response.getWriter().write("{\"flag\":-1}");			
				}
			}
			else
			{
				System.out.println("아이디[" + userId + "]는 사용이 정지되어 있습니다^_^");
				response.getWriter().write("{\"flag\":-2}");
			}
		}
		else
		{
			System.out.println("아이디[" + userId + "] 사용자 정보 없음.");
			response.getWriter().write("{\"flag\":-3}");
		}
	}
	else
	{
		response.getWriter().write("{\"flag\":-100}");
	}
	
	
	
%>
