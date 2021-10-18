<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.icia.common.util.StringUtil" %>
<%@ page import="com.icia.web.util.HttpUtil" %>
<%@ page import="com.icia.web.util.CookieUtil" %>
<%@ page import="com.icia.web.dao.BoardDao" %>
<%@ page import="com.icia.web.model.Board" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%
   Logger logger = LogManager.getLogger("/board/view.jsp");
   HttpUtil.requestLogString(request, logger);
   
   String cookieUserId = CookieUtil.getValue(request, "USER_ID");
   
   long bbsSeq = HttpUtil.get(request, "bbsSeq", (long)0);
   String searchType = HttpUtil.get(request, "searchType", "");
   String searchValue = HttpUtil.get(request, "searchValue", "");
   long curPage = HttpUtil.get(request, "curPage", (long)1);
   
   BoardDao boardDao = new BoardDao();
   Board board = boardDao.boardSelect(bbsSeq);
   
   if(board != null)
   {
	   //조회수 증가
	  	boardDao.boardReadCntPlus(board.getBbsSeq());
	   
	   
   }
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>
<script type="text/javascript">
$(document).ready(function() {
<%
	if(board == null)
	{		
%>
	alert("조회하신 게시물이 존재하지 않습니다.");
	document.bbsForm.action = "/board/list.jsp";
	document.bbsForm.submit();
<%
	}
	else
	{
		

%>
	// console.log( "ready!" );
	$("#btnList").on("click", function() {
		document.bbsForm.action = "/board/list.jsp";
		document.bbsForm.submit();
	});
	
	$("#btnUpdate").on("click", function() {
		document.bbsForm.action = "/board/update.jsp";
		document.bbsForm.submit();
	});
	
	$("#btnDelete").on("click", function() {
		
		if(confirm("게시물을 삭제 하시겠습니까?") == true)
		{
			document.bbsForm.action = "/board/delete.jsp";
			document.bbsForm.submit();
		}
	});
<%
	}
%>
});
</script>
</head>
<body>
<%
	if(board !=null)
	{
	
%>
<%@ include file="/include/navigation.jsp" %>
<div class="container">
	<h2>게시물 보기</h2>
	<div class="row" style="margin-right:0; margin-left:0;">
		<table class="table">
			<thead>
				<tr class="table-active">
					<th scope="col" style="width:60%">
						<%= HttpUtil.filter(board.getBbsTitle()) %><br/>
						<%= HttpUtil.filter(board.getBbsName()) %>&nbsp;&nbsp;&nbsp;
						<a href="mailto:<%= board.getBbsEMail() %>" style="color:#828282;"><%= board.getBbsEMail() %></a>
						
					</th>
					<th scope="col" style="width:40%" class="text-right">
						조회 : <%= StringUtil.toNumberFormat(board.getBbsReadCnt()) %><br/>
						<%= board.getRegDate() %>
					</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td colspan="2"><pre><%=StringUtil.replace(HttpUtil.filter(board.getBbsContent()),"\n", "<br />") %></pre></td>
				</tr>
			</tbody>
			<tfoot>
			<tr>
	            <td colspan="2"></td>
	        </tr>
			</tfoot>
		</table>
	</div>

	<button type="button" id="btnList" class="btn btn-secondary">리스트</button>
<%
		if(StringUtil.equals(cookieUserId, board.getUserId()))
		{
%>	
	<button type="button" id="btnUpdate" class="btn btn-secondary">수정</button>
	<button type="button" id="btnDelete" class="btn btn-secondary">삭제</button>
<%
		}
%>
	<br/>
	<br/>
</div>
<%
	}
%>
<form name="bbsForm" id="bbsForm" method="post">
	<input type="hidden" name="bbsSeq" value="<%=bbsSeq %>" />
	<input type="hidden" name="searchType" value="<%= searchType %>" />
	<input type="hidden" name="searchValue" value="<%= searchValue %>" />
	<input type="hidden" name="curPage" value="<%= curPage %>" />
</form>

</body>
</html>