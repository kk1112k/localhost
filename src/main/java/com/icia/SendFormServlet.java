package com.icia;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class SendFormServlet
 */
@WebServlet("/sendForm")
public class SendFormServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SendFormServlet() {
        super();
        System.out.println("SendFormServlet ������ȣ��.......");
    }

	/**
	 * @see Servlet#init(ServletConfig)
	 */
	public void init(ServletConfig config) throws ServletException {
		System.out.println("SendFormServlet init().......");
	}

	/**
	 * @see Servlet#destroy()
	 */
	public void destroy() {
		System.out.println("SendFormServlet destory().......");
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("SendFormServlet doGet().......");
		process(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("SendFormServlet doPost().......");
		process(request, response);
	}
	
	private void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		System.out.println("SendFormServlet process().......");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		
		out.println("<!doctype html>");
		out.println("<html>");
		out.println("<head>");
		out.println("<meta charset=\"UTF-8\">");
		out.println("<title>sendForm</title>");
		out.println("</head>");
		out.println("<body>");
		out.println("<a href=\"/sendProc?name=��õ�Ϻ�$email=icia@naver.com\">"
				+ "GET �������</a>");
		out.println("<br/><br />");
		out.println("<form name =\"form1\" method =\"post\" action=\"sendProc\">");
		out.println("�̸� : <input type=text name=name style=\"width:200px;\" />");
		out.println("<br><br>");
		out.println("�̸��� : <input type=text name=email style\"width=200px\" />");
		out.println("<br><br>");
		out.println("<button type=button onclick=submit()>POST��� ����</button>");
		out.println("</form>");
		out.println("</body>");
		out.println("</html>");
	}
}












