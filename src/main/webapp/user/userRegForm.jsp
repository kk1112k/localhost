<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.icia.common.util.StringUtil" %>
<%@ page import="com.icia.web.util.HttpUtil" %>
<%@ page import="com.icia.web.util.CookieUtil" %>
<%@ page import="com.icia.web.dao.UserDao" %>
<%@ page import="com.icia.web.model.User" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%
   Logger logger = LogManager.getLogger("/user/userRegForm.jsp");
   HttpUtil.requestLogString(request, logger);
   
   //회원가입 가능여부
   boolean bSuccess = false;
   //쿠키값 가져오기
   String cookieUserId = CookieUtil.getValue(request, "USER_ID");
   
   if(!StringUtil.isEmpty(cookieUserId))
   {
      //쿠키가 있다면
      logger.debug("cookie userId : " + cookieUserId);
      
      UserDao userDao = new UserDao();
      User user = userDao.userSelect(cookieUserId);
      
      if(user != null)
      {
         //사용자 정보가 있다면
         if(StringUtil.equals(user.getStatus(), "Y"))
         {
            response.sendRedirect("/");   //("/board/list.jsp");
         }
         else
         {
            CookieUtil.deleteCookie(request, response, "USER_ID");
            response.sendRedirect("/");
         }
      }
      else
      {
         //쿠키는 있고 사용자 정보가 없을때
         CookieUtil.deleteCookie(request, response, "USER_ID");
         response.sendRedirect("/");
      }
   }
   else
   {
      bSuccess = true;
   }

   if(bSuccess == true)
   {
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>
<script>
$(document).ready(function() {
    
   $("#userId").focus();
   
   $("#btnReg").on("click", function() {
      
      // 모든 공백 체크 정규식
      var emptCheck = /\s/g;
      // 영문 대소문자, 숫자로만 이루어진 4~12자리 정규식
      var idPwCheck = /^[a-zA-Z0-9]{4,12}$/;
            
      if($.trim($("#userId").val()).length <= 0)
      {
         alert("사용자 아이디를 입력하세요.");
         $("#userId").val("");
         $("#userId").focus();
         return;
      }
      
      if (emptCheck.test($("#userId").val())) 
      {
         alert("사용자 아이디는 공백을 포함할 수 없습니다.");
         $("#userId").focus();
         return;
      }
      
      if (!idPwCheck.test($("#userId").val())) 
      {
         alert("사용자 아이디는 4~12자의 영문 대소문자와 숫자로만 입력하세요");
         $("#userId").focus();
         return;
      }
      
      if($.trim($("#userPwd1").val()).length <= 0)
      {
         alert("비밀번호를 입력하세요.");
         $("#userPwd1").val("");
         $("#userPwd1").focus();
         return;
      }
      
      if (emptCheck.test($("#userPwd1").val())) 
      {
         alert("비밀번호는 공백을 포함할 수 없습니다.");
         $("#userPwd1").focus();
         return;
      }
      
      if (!idPwCheck.test($("#userPwd1").val())) 
      {
         alert("비밀번호는 영문 대소문자와 숫자로 4~12자리 입니다.");
         $("#userPwd1").focus();
         return;
      }
      
      if ($("#userPwd1").val() != $("#userPwd2").val()) 
      {
         alert("비밀번호가 일치하지 않습니다.");
         $("#userPwd2").focus();
         return;
      }
      
      if($.trim($("#userName").val()).length <= 0)
      {
         alert("사용자 이름을 입력하세요.");
         $("#userName").val("");
         $("#userName").focus();
         return;
      }
      
      if(!fn_validateEmail($("#userEmail").val()))
      {
         alert("사용자 이메일 형식이 올바르지 않습니다.");
         $("#userEmail").focus();
         return;   
      }
      
      $("#userPwd").val($("#userPwd1").val());
      
      $.ajax({
         type : "POST",
         url : "/user/userIdCheckAjax.jsp",
         data : {
            userId : $("#userId").val()
         },
         datatype : "JSON",
         success : function(obj) {
            var data = JSON.parse(obj);

            if(data.flag == 0)
            {
               document.regForm.submit();
            }
            else
            {
               alert("중복된 아이디 입니다.");
            }   
         },
         complete : function(data) {// 응답이 종료되면 실행, 잘 사용하지않는다
            console.log(data);
         },
         error : function(xhr, status, error) {
            alert("아이디 중복 체크 에러!");
         }
      });
   });
   
});

function fn_validateEmail(value)
{
   var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
   
   return emailReg.test(value);
}
</script>
</head>
<body>
<%@ include file="/include/navigation.jsp" %>
<div class="container">
    <div class="row mt-5">
       <h1>회원가입</h1>
    </div>
    <div class="row mt-2">
        <div class="col-12">
            <form id="regForm" name="regForm" action="/user/userProc.jsp" method="post">
                <div class="form-group">
                    <label for="username">사용자 아이디</label>
                    <input type="text" class="form-control" id="userId" name="userId" placeholder="사용자 아이디" maxlength="12" />
                </div>
                <div class="form-group">
                    <label for="username">비밀번호</label>
                    <input type="password" class="form-control" id="userPwd1" name="userPwd1" placeholder="비밀번호" maxlength="12" />
                </div>
                <div class="form-group">
                    <label for="username">비밀번호 확인</label>
                    <input type="password" class="form-control" id="userPwd2" name="userPwd2" placeholder="비밀번호 확인" maxlength="12" />
                </div>
                <div class="form-group">
                    <label for="username">사용자 이름</label>
                    <input type="text" class="form-control" id="userName" name="userName" placeholder="사용자 이름" maxlength="15" />
                </div>
                <div class="form-group">
                    <label for="username">사용자 이메일</label>
                    <input type="text" class="form-control" id="userEmail" name="userEmail" placeholder="사용자 이메일" maxlength="30" />
                </div>
                <input type="hidden" id="userPwd" name="userPwd" value="" />
                <button type="button" id="btnReg" class="btn btn-primary">등록</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
<%
   }
%>