/**
 * <pre>
 * 프로젝트명 : BasicBoard
 * 패키지명   : com.icia.web.filter
 * 파일명     : UrlUserAuthFilter.java
 * 작성일     : 2021. 1. 13.
 * 작성자     : daekk
 * </pre>
 */
package com.icia.web.filter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.icia.common.util.StringUtil;
import com.icia.web.dao.UserDao;
import com.icia.web.model.User;
import com.icia.web.util.CookieUtil;

/**
 * <pre>
 * 패키지명   : com.icia.web.filter
 * 파일명     : UrlUserAuthFilter.java
 * 작성일     : 2021. 1. 13.
 * 작성자     : daekk
 * 설명       :
 * </pre>
 */
public class UrlUserAuthFilter implements Filter
{
	private static Logger logger = LogManager.getLogger(UrlUserAuthFilter.class);
	private List<String> authUrlList;
		
	/* (non-Javadoc)
	 * @see javax.servlet.Filter#init(javax.servlet.FilterConfig)
	 */
	@Override
    public void init(FilterConfig filterConfig) throws  ServletException 
	{
		authUrlList = null;
		
		String authUrl = filterConfig.getInitParameter("authUrl");
          
        if(!StringUtil.isEmpty(authUrl))
        {
        	String[] authUrls = StringUtil.tokenizeToStringArray(authUrl, ",");
        	
        	if(authUrls != null && authUrls.length > 0)
        	{
        		authUrlList = new ArrayList<String>(Arrays.asList( authUrls));
        		
        		
        	}
        }
    }

	/* (non-Javadoc)
	 * @see javax.servlet.Filter#doFilter(javax.servlet.ServletRequest, javax.servlet.ServletResponse, javax.servlet.FilterChain)
	 */
	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) throws IOException, ServletException
	{
		HttpServletRequest httpServletRequest = ((HttpServletRequest) request);
		HttpServletResponse httpServletResponse = ((HttpServletResponse) response);
		boolean bFlag = true;
		
		String url = httpServletRequest.getRequestURI();
		
		if(authUrlCheck(url)) // url이 인증 체크 인지 검사
		{
			logger.debug("UserAuthFilter url : " + url);
			
			if(!isUserLogin(httpServletRequest, httpServletResponse)) //
			{
				httpServletResponse.sendRedirect("/");
				bFlag = false;
			}
		}
		
		if(bFlag)
		{
			filterChain.doFilter(request, response);
		}
	}
	
	/**
	 * <pre>
	 * 메소드명   : isUserLogin
	 * 작성일     : 2021. 1. 13.
	 * 작성자     : daekk
	 * 설명       : 로그인 체크
	 * </pre>
	 * @param request HttpServletRequest
	 * @param response HttpServletResponse
	 * @return boolean
	 */
	private boolean isUserLogin(HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getValue(request, "USER_ID");
		
		if(!StringUtil.isEmpty(cookieUserId))
		{
			UserDao userDao = new UserDao();
			User user = userDao.userSelect(cookieUserId);
			
			if(user != null && StringUtil.equals(user.getStatus(), "Y"))
			{
				return true;
			}
			else
			{
				CookieUtil.deleteCookie(request, response, "USER_ID");
			}
		}
		
		return false;
	}
	
	/**
	 * <pre>
	 * 메소드명   : authUrlCheck
	 * 작성일     : 2021. 1. 13.
	 * 작성자     : daekk
	 * 설명       : 인증 체크 url인지 검사
	 * </pre>
	 * @param url 경로
	 * @return boolean
	 */
	private boolean authUrlCheck(String url)
	{
		if(authUrlList != null && authUrlList.size() > 0 && !StringUtil.isEmpty(url))
		{
			for(int i=0; i<authUrlList.size(); i++)
			{
				String checkUrl = StringUtil.trim(authUrlList.get(i));
				
				if(!StringUtil.isEmpty(checkUrl))
				{
					if(checkUrl.length() <= url.length())
					{
						if(url.startsWith(checkUrl))
						{
							return true;
						}
					}
				}
			}
		}
		
		return false;
	}
}
