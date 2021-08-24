<%--
  500 error page

  @author hrjin
  @version 1.0
  @since 2020.11.13
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <link rel="stylesheet" href="/resources/css/empty_layout.css">
    <title>PaaS-TA Container Platform User Portal</title>
</head>
<body>
<div class="layer">
    <div class="layer_inner">
        <div class="content">
            <div class="panel" style="">
                <div class="panel-heading" style="">
                    <div>
                        <img  class="panel-image" src="/resources/images/main/logo.png" style="width: 60px; height: 48px;">
                        <span class="header-title" style=""> Container Platform </span>
                    </div>
                </div>

                <div class="panel-body" style="">
                    <span style="">세션이 종료되었습니다.</span>
                    <hr/>
                    <div class="form-group">
                        <button type="button" id="pageBtn" onclick="location.href='/?serviceInstanceId=${serviceInstanceId}'">로그인 화면으로 이동</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>