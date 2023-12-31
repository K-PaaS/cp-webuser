<%--
  Token Expired View

  @author kjhoon
  @version 1.0
  @since 2021.03.24
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<html>
<head>
    <title>PaaS-TA Container Platform User Portal</title>
    <style>
        .layer {
            position: absolute;
            display: table;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%
        }

        .layer .layer_inner {
            display: table-cell;
            text-align: center;
            vertical-align: middle
        }

        .layer .content {
            display: inline-block;
            background: #fff;
            width: 28%;
            margin-top: -100px;
        }

        .panel {
            border: solid 1px #bbb;
        }

        .panel-heading {
            background-color: #2a6575;
            padding: 20px;
        }

        .panel-image {
            vertical-align: middle;
            margin-left: -20px;
        }

        .header-title {
            font-size: 16px;
            font-weight: 600;
            color: #dfe3e8;
            vertical-align: middle;
            margin-left: 6px;
        }

        .panel-body {
            padding: 40px;
        }

        .panel-body span {
            color: #343942;
        }

        hr {
            margin-top: 20px;
            margin-bottom: 20px;
            border: 0;
            border-top: 1px solid #ccc;
        }

        #pageBtn {
            background-color: white;
            border: 2px solid #e7e7e7;
            color: black;
            padding: 5px 38px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 4px 2px;
            transition-duration: 0.4s;
            cursor: pointer;
        }

        #pageBtn:hover {
            background-color: #e7e7e7;
        }

        #pageBtn:focus {
            outline: 0;
        }

    </style>
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
                    <span style=""><spring:message code="M0052" text="토큰이 만료되어 자동 로그아웃 되었습니다."/></span>
                    <hr/>
                    <div class="form-group">
                        <button type="button" id="pageBtn" onclick="location.href='/login'"><spring:message code="M0053" text="로그인 페이지로 이동"/></button>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
