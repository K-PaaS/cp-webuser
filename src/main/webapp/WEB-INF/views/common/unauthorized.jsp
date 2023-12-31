<%--
  Unauthorized

  @author kjhoon
  @version 1.0
  @since 2020.08.21
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
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
                        <img class="panel-image" src="<c:url value="/resources/images/main/logo.png"/>"
                             style="width: 60px; height: 48px;">
                        <span class="header-title" style=""> Container Platform </span>
                    </div>
                </div>

                <div class="panel-body" style="">
                    <span style=""><spring:message code="M0003" text="페이지를 볼 수 있는 권한이 없습니다."/></span>
                    <hr/>
                    <div class="form-group">
                        <button type="button" id="pageBtn" onclick="location.href='/'"><spring:message code="M0008" text="메인화면으로 이동"/></button>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
