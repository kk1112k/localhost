<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.icia.common.util.StringUtil" %>
<%@ page import="com.icia.web.util.HttpUtil" %>
<%@ page import="com.icia.web.util.CookieUtil" %>
<%@ page import="com.icia.web.dao.BoardDao" %>
<%@ page import="com.icia.web.model.Board" %>
<%@ page import="com.icia.web.model.Paging" %>
<%@ page import="com.icia.web.model.BoardFileConfig" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%
   Logger logger = LogManager.getLogger("/board/list.jsp");
   HttpUtil.requestLogString(request, logger);
   
   //조회항목 (1:작성자 조회,  2:제목 조회,  3:내용 조회)
   String searchType = HttpUtil.get(request, "searchType", "");
   //조회값
   String searchValue = HttpUtil.get(request, "searchValue", "");
   //현재 페이지
   long curPage = HttpUtil.get(request, "curPage", (long)1);
   //총 게시물 수
   long totalCount = 0;
   //게시물 리스트
   List<Board> list = null;
   //페이징
   Paging paging = null;
   
   Board search = new Board();
   BoardDao boardDao = new BoardDao();
   
   if(!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue))
   {
      if(StringUtil.equals(searchType, "1")) //작성자 조회
      {
         search.setBbsName(searchValue);
      }
      else if(StringUtil.equals(searchType, "2")) //제목 조회
      {
         search.setBbsTitle(searchValue);
      }
      else if(StringUtil.equals(searchType, "3"))  //내용 조회
      {
         search.setBbsContent(searchValue);
      }
   }
   else
   {
      searchType = "";
      searchValue = "";
   }
   
   totalCount = boardDao.boardTotalCount(search);
   
   
   if(totalCount > 0)
   {
      paging = new Paging("/board/list.jsp", totalCount, BoardFileConfig.LIST_COUNT, BoardFileConfig.PAGE_COUNT, curPage, "curPage");
      
      paging.addParam("searchType", searchType);
      paging.addParam("searchValue", searchValue);
      
      search.setStartRow(paging.getStartRow());
      search.setEndRow(paging.getEndRow());
      
      list = boardDao.boardList(search);
   }
%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>
<script type="text/javascript">
$(document).ready(function() {
    
   $("#btnWrite").on("click", function() {
      
      document.bbsForm.bbsSeq.value = "";
      document.bbsForm.action = "/board/write.jsp";
      document.bbsForm.submit();
      
   });
   
   $("#btnSearch").on("click", function() {
      
      document.bbsForm.bbsSeq.value = "";
      document.bbsForm.searchType.value = $("#_searchType").val();
      document.bbsForm.searchValue.value = $("#_searchValue").val();
      document.bbsForm.curPage.value = "1";
      document.bbsForm.action = "/board/list.jsp";
      document.bbsForm.submit();
      
   });
});

function fn_view(bbsSeq)
{
   document.bbsForm.bbsSeq.value = bbsSeq;
   document.bbsForm.action = "/board/view.jsp";
   document.bbsForm.submit();
}

function fn_list(curPage)
{
   document.bbsForm.bbsSeq.value = "";
   document.bbsForm.curPage.value = curPage;
   document.bbsForm.action = "/board/list.jsp";
   document.bbsForm.submit();   
}
</script>
</head>
<body>
<%@ include file="/include/navigation.jsp" %>
<div class="container">
   
   <div class="d-flex">
      <div style="width:50%;">
         <h2>게시판</h2>
      </div>
      <div class="ml-auto input-group" style="width:50%;">
         <select name="_searchType" id="_searchType" class="custom-select" style="width:auto;">
            <option value="">조회 항목</option>
            <option value="1" <%if(StringUtil.equals(searchType, "1")){ %>selected<% }%>>작성자</option>
            <option value="2" <%if(StringUtil.equals(searchType, "2")){ %>selected<% }%>>제목</option>
            <option value="3" <%if(StringUtil.equals(searchType, "3")){ %>selected<% }%>>내용</option>
         </select>
         <input type="text" name="_searchValue" id="_searchValue" value="<%=searchValue %>" class="form-control mx-1" maxlength="20" style="width:auto;ime-mode:active;" placeholder="조회값을 입력하세요." />
         <button type="button" id="btnSearch" class="btn btn-secondary mb-3 mx-1">조회</button>
      </div>
    </div>
    
   <table class="table table-hover">
      <thead>
      <tr style="background-color: #dee2e6;">
         <th scope="col" class="text-center" style="width:10%">번호</th>
         <th scope="col" class="text-center" style="width:55%">제목</th>
         <th scope="col" class="text-center" style="width:10%">작성자</th>
         <th scope="col" class="text-center" style="width:15%">날짜</th>
         <th scope="col" class="text-center" style="width:10%">조회수</th>
      </tr>
      </thead>
      <tbody>
      
<%
   if(list != null && list.size() > 0)
   {
      long startNum = paging.getStartNum();
      
      for(int i = 0; i < list.size(); i++)
      {
         Board board = list.get(i);
%>      
      <tr>
         <td class="text-center"><%=startNum %></td>
         <td><a href="javascript:void(0)" onclick="fn_view(<%=board.getBbsSeq()%>)"><%=board.getBbsTitle()%></a></td>
         <td class="text-center"><%=board.getBbsName() %></td>
         <td class="text-center"><%=board.getRegDate() %></td>
         <td class="text-center"><%=StringUtil.toNumberFormat(board.getBbsReadCnt()) %></td>
      </tr>
<%
         startNum = startNum - 1;
      }
   }
%>      
      </tbody>
      <tfoot>
      <tr>
            <td colspan="5"></td>
        </tr>
      </tfoot>
   </table>
   <nav>
      <ul class="pagination justify-content-center">
<%
   if(paging != null)
   {
      if(paging.getPrevBlockPage() > 0)
      {   
%>      
         <li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_list(1)">이전블럭</a></li>
<%
      }
      
      for(long i = paging.getStartPage(); i <= paging.getEndPage(); i++)
      {
         if(paging.getCurPage() == i)
         {
%>         
         <li class="page-item active"><a class="page-link" href="javascript:void(0)" style="cursor:default;"><%=i %></a></li>
<%
         }
         else
         {
               
%>         
         <li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_list(<%=i %>)"><%=i %></a></li>
         
<%
         }
      }
      
      if(paging.getNextBlockPage() > 0)
      {
%>         
         <li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_list(2)">다음블럭</a></li>   
<%
      }
   }
%>         
      </ul>
   </nav>
   
   <button type="button" id="btnWrite" class="btn btn-secondary mb-3">글쓰기</button>
   
   <form name="bbsForm" id="bbsForm" method="post">
      <input type="hidden" name="bbsSeq" value="" />
      <input type="hidden" name="searchType" value="<%=searchType %>" />
      <input type="hidden" name="searchValue" value="<%=searchValue %>" />
      <input type="hidden" name="curPage" value="<%=curPage %>" />
   </form>
</div>
</body>
</html>