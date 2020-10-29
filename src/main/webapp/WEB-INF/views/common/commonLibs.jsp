<%--
  Common library

  @author kjhoon
  @version 1.0
  @since 2020.08.20
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.paasta.container.platform.web.user.common.Constants" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!--[if lt IE 9]>
<script type="text/javascript" src="/resources/js/html5shiv.min.js"></script>
<script type="text/javascript" src="/resources/js/respond.min.js"></script>
<![endif]-->

<%--CSS--%>
<link rel='stylesheet' type='text/css' href='<c:url value="/resources/css/fontawesome-all.css"/>'>
<link rel='stylesheet' type='text/css' href='<c:url value="/resources/css/nanumbarungothic.css"/>'>
<link rel='stylesheet' type='text/css' href='<c:url value="/resources/css/style.css"/>'>
<link rel='stylesheet' type='text/css' href='<c:url value="/resources/css/normalize.css"/>'>
<link rel='stylesheet' type='text/css' href='<c:url value="/resources/css/bootstrap.min.css"/>'>
<link rel='stylesheet' type='text/css' href='<c:url value="/resources/css/jquery-ui.min.css"/>'>
<link rel='stylesheet' type='text/css' href='<c:url value="/resources/css/jquery.jscrollpane.css"/>'>
<link rel='stylesheet' type='text/css' href='<c:url value="/resources/css/common.css"/>'>
<link rel='stylesheet' type='text/css' href='<c:url value="/resources/css/common_new.css"/>'>
<link rel='stylesheet' type='text/css' href='<c:url value="/resources/css/gspinner.min.css"/>'>
<link rel='stylesheet' type='text/css' href='<c:url value="/resources/css/cp-common.css"/>'>
<link rel="shortcut icon" type="image/x-icon" href="<c:url value="/resources/images/favicon.ico"/>">

<%--JS--%>
<script type="text/javascript" src='<c:url value="/resources/js/jquery-1.12.4.min.js"/>'></script>
<script type="text/javascript" src='<c:url value="/resources/js/jquery.cookie.js"/>'></script>
<script type="text/javascript" src='<c:url value="/resources/js/bootstrap.min.js"/>'></script>
<script type="text/javascript" src="<c:url value="/resources/js/jquery-ui.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/js/jquery.jscrollpane.min.js"/>"></script>
<script type="text/javascript" src='<c:url value="/resources/js/jquery.tablesorter.min.js"/>'></script>
<script type="text/javascript" src='<c:url value="/resources/js/g-spinner.min.js"/>'></script>

<script type="text/javascript" src='<c:url value="/resources/js/common.js"/>'></script>
<script type="text/javascript" src='<c:url value="/resources/js/cp-common.js"/>'></script>
<script type="text/javascript">

    var RESULT_STATUS_SUCCESS  = "<%= Constants.RESULT_STATUS_SUCCESS %>";
    var RESULT_STATUS_FAIL     = "<%= Constants.RESULT_STATUS_FAIL %>";
    var URI_API_EVENTS_LIST    = "<%= Constants.API_URL %><%= Constants.URI_API_EVENTS_LIST %>";
    var URI_API_PODS_RESOURCES = "<%= Constants.API_URL %><%= Constants.URI_API_PODS_LIST_BY_SELECTOR %>";
    var URI_WORKLOADS_PODS     = "<%= Constants.URI_WORKLOAD_PODS %>";

    var OVERVIEW_LIMIT_COUNT = "<%= Constants.OVERVIEW_LIMIT_COUNT %>";
    var DEFAULT_LIMIT_COUNT = "<%= Constants.DEFAULT_LIMIT_COUNT %>";


    // todo remove :: accessInfo.jsp
    var USER_ID = "admin";
    var USER_NAME = "admin";

    var cp_user_metadata =$.cookie("<%= Constants.CP_USER_METADATA_KEY %>");
    var current_select_ns = $.cookie("<%= Constants.CP_SELECTED_NAMESPACE_KEY %>");
    cp_user_metadata = JSON.parse(cp_user_metadata);

    var namespace = getNamespaceListByMetaData(cp_user_metadata);
    var current_user_type = getUserTypeByMetaData(cp_user_metadata, current_select_ns) ;
    var namespacesList = namespace;

</script>

