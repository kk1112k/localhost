<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.icia.common.util.StringUtil" %>
<%@ page import="com.icia.web.util.HttpUtil" %>
<%@ page import="com.icia.web.util.CookieUtil" %>
<%@ page import="com.icia.web.dao.BoardDao" %>
<%@ page import="com.icia.web.model.Board" %>
<%@ page import="com.icia.web.dao.UserDao" %>
<%@ page import="com.icia.web.model.User" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%
	Logger logger = LogManager.getLogger("/board/update.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	long bbsSeq = HttpUtil.get(request, "bbsSeq", (long)0);
	String searchType = HttpUtil.get(request, "searchType","");
	String searchValue = HttpUtil.get(request, "searchValue", "");
	long curPage = HttpUtil.get(request, "curPage", (long)1);
	
	BoardDao boardDao = new BoardDao();
	Board board = boardDao.boardSelect(bbsSeq);
	User user = null; 
	
	if(board !=null)
	{
		//본인 게시물이 아니면 수정 불가
		if(!StringUtil.equals(cookieUserId, board.getUserId()))
		{
			board = null;
		}
		else
		{
			UserDao userDao = new UserDao();
			user = userDao.userSelect(cookieUserId);
			
		}
	}
	
	
%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>
<script type="text/javascript">
$(document).ready(function() {
<%
	if(board == null || user == null)
	{
%>
	alert("게시물이 존재하지 않숩니다.")
	location href = "/board/list.jsp";	
<%
	}
	else
	{
	
%>
	// $("#bbsName").focus();
	$("#bbsTitle").focus();
	
	$("#btnUpdate").on("click", function() {
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
		
		document.updateForm.submit();
	});
	
	$("#btnList").on("click", function() {
		document.bbsForm.action = "/board/list.jsp";
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

function fn_validateEmail(value)
{
	var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
	
	return emailReg.test(value);
}
</script>
</head>
<body>
<%
	if(board !=null && user != null)
	{
%>
<%@ include file="/include/navigation.jsp" %>
<div class="container">
	<h2>게시물 수정</h2>
	<form name="updateForm" id="updateForm" action="/board/updateProc.jsp" method="post">
		<input type="text" name="bbsName" id="bbsName" maxlength="20" value="<%= user.getUserName() %>" style="ime-mode:active;" class="form-control mt-4 mb-2" placeholder="이름을 입력해주세요." readonly />
		<input type="text" name="bbsEmail" id="bbsEmail" maxlength="30" value="<%= user.getUserEmail() %>"  style="ime-mode:inactive;" class="form-control mb-2" placeholder="이메일을 입력해주세요." readonly />
		<input type="text" name="bbsTitle" id="bbsTitle" maxlength="100" style="ime-mode:active;" value="<%= board.getBbsTitle() %>" class="form-control mb-2" placeholder="제목을 입력해주세요." required />
		<div class="form-group">
			<textarea class="form-control" rows="10" name="bbsContent" id="bbsContent" style="ime-mode:active;" placeholder="내용을 입력해주세요" required><%= board.getBbsContent() %></textarea>
		</div>
		
		<input type="hidden" name="bbsSeq" value="<%= bbsSeq %>" />
		<input type="hidden" name="searchType" value="<%= searchType %>" />
		<input type="hidden" name="searchValue" value="<%= searchValue %>" />
		<input type="hidden" name="curPage" value="<%=curPage %>" />
	</form>
	
	<div class="form-group row">
		<div class="col-sm-12">
			<button type="button" id="btnUpdate" class="btn btn-primary" title="수정">수정</button>
			<button type="button" id="btnList" class="btn btn-secondary" title="리스트">리스트</button>
		</div>
	</div>
</div>
<form name="bbsForm" id="bbsForm" method="post">
	<input type="hidden" name="bbsSeq" value="<%= bbsSeq %>" />
	<input type="hidden" name="searchType" value="<%= searchType %>" />
	<input type="hidden" name="searchValue" value="<%= searchValue %>" />
	<input type="hidden" name="curPage" value="<%=curPage %>" />
</form>
<%
	}
%>
</body>
</html>