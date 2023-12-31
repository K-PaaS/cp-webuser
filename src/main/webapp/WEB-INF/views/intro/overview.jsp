<%--
  Intro overview main

  @author kjhoon
  @version 1.0
  @since 2020.09.07
--%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="org.paasta.container.platform.web.user.common.Constants" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<link rel='stylesheet' type='text/css' href='<c:url value="/resources/css/jquery-ui-resourcequotas.min.css"/>'>
<div class="content">
    <jsp:include page="../common/contentsTab.jsp"/>
    <div class="cluster_tabs clearfix"></div>
    <!-- Intro 시작-->
    <div class="cluster_content01 row two_line two_view">
        <ul id="detailTab">
            <!-- Namespaces 시작 (Namespaces start)-->
            <li>
                <div class="sortable_wrap">
                    <div class="sortable_top">
                        <p>Namespace</p>
                    </div>
                    <div class="account_table view">
                        <table>
                            <colgroup>
                                <col style='width:20%'>
                                <col style=".">
                            </colgroup>
                            <tbody id="noResultAreaForNameSpaceDetails" style="display: none;"></tbody>
                            <tbody id="resultAreaForNameSpaceDetails" style="display: none;">
                            <tr>
                                <th><i class="cWrapDot"></i> Name</th>
                                <td id="nameSpaceName"></td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Creation Time</th>
                                <td id="nameSpaceCreationTime"></td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Status</th>
                                <td id="nameSpaceStatus"></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </li>
        </ul>
    </div>
</div>
<!-- Namespaces 끝 (Namespaces end)-->
<!--Resource Quotas 시작 (Resource Quotas start)-->
<div id="quota-template" style="display:none;">
    <li class="cluster_second_box">
        <div class="sortable_wrap">
            <div class="sortable_top">
                <p>Resource Quotas</p>
            </div>
            <div class="view_table_wrap">
                <table class="table_event condition alignL">
                    <colgroup>
                        <col style='width:20%;'>
                        <col style='width:auto;'>
                        <col style='width:30%;'>
                    </colgroup>
                    <thead>
                    <tr id="noResultAreaForResourceQuotas" style="display: none">
                        <td colspan='3'><p class='service_p'><spring:message code="M0074" text="생성한 Resource Quotas가 없습니다."/></p></td>
                    </tr>
                    <tr id="resultHeaderAreaForResourceQuotas" class="headerSortFalse">
                        <td>Name</td>
                        <td>Status</td>
                        <td>Created time</td>
                    </tr>
                    </thead>
                    <tbody id="resultAreaForResourceQuotas">
                    </tbody>
                </table>
            </div>
        </div>
    </li>
</div>
<!--Resource Quotas 끝 (Resource Quotas end)-->
<!--Limit Ranges 시작 (Limit Ranges start)-->
<div id="range-template" style="display:none;">
    <li class="cluster_third_box">
        <div class="sortable_wrap">
            <div class="sortable_top">
                <p>Limit Ranges</p>
            </div>
            <div class="view_table_wrap">
                <table class="table_event condition alignL">
                    <p class="p30" id="nameForLimitRanges">- <strong>Name</strong> : {{items.name}} </p>
                    <colgroup>
                        <col style='width:auto;'>
                        <col style='width:auto;'>
                        <col style='width:auto;'>
                        <col style='width:auto;'>
                    </colgroup>
                    <thead>
                    <tr id="noResultAreaForLimitRanges" style="display: none">
                        <td colspan='4'><p class='service_p'><spring:message code="M0075" text="생성한 Limit Ranges가 없습니다."/></p></td>
                    </tr>
                    <tr id="resultHeaderAreaForLimitRanges">
                        <td>Resource Name</td>
                        <td>Resource Type</td>
                        <td>Default Limit</td>
                        <td>Default Request</td>
                    </tr>
                    </thead>
                    <tbody id="resultAreaForLimitRanges"></tbody>
                </table>
            </div>
        </div>
    </li>
    <spring:eval expression="@environment.getProperty('cp.provider.type.service')" var="portal_provider_service" />
    <spring:eval expression="@environment.getProperty('cp.provider.type.standalone')" var="portal_provider_standalone" />
    <spring:eval expression="@environment.getProperty('cp.provider.id')" var="portal_provider_id" />
</div>
<!--Limit Ranges 끝 (Limit Ranges end)-->
<!-- Intro 끝 (Intro end)-->
<script type="text/javascript">

    var G_PVC_LIST_GET_FIRST = true;

    var getDetail = function () {
        procViewLoading('show');

        var reqUrl = "<%= Constants.API_URL %><%= Constants.URI_API_NAME_SPACES_DETAIL %>"
            .replace("{cluster:.+}", CLUSTER_NAME)
            .replace("{namespace:.+}", NAME_SPACE);

        procCallAjax(reqUrl, "GET", null, null, callbackGetDetail);
    };


    var callbackGetDetail = function (data) {

        var f_srch_namespaces = 'NameSpaces 조회에 실패하였습니다.';
        var s_msg_f_srch_namespaces= '<spring:message code="M0076" arguments='arg_f_srch_namespaces' javaScriptEscape="true" text="NameSpaces 조회에 실패하였습니다."/>';
        s_msg_f_srch_namespaces_lang = s_msg_f_srch_namespaces.replace('arg_f_srch_namespaces', f_srch_namespaces);

        var noResultAreaForNameSpaceDetails = $("#noResultAreaForNameSpaceDetails");
        var resultAreaForNameSpaceDetails = $("#resultAreaForNameSpaceDetails");

        if (!procCheckValidData(data)) {
            noResultAreaForNameSpaceDetails.show();
            procViewLoading('hide');
            procAlertMessage(s_msg_f_srch_namespaces_lang, false);
            return false;
        }

        $("#title").html(NAME_SPACE);

        var namespaceNameHtml = "<a href='javascript:void(0);' onclick='procMovePage(\"<%= Constants.URI_CLUSTER_NAMESPACES %>/" + NAME_SPACE + "\");'>" + NAME_SPACE + "</a>";

        $("#nameSpaceName").html(namespaceNameHtml);
        $("#nameSpaceCreationTime").html(data.metadata.creationTimestamp);
        $("#nameSpaceStatus").html(data.status.phase);

        resultAreaForNameSpaceDetails.show();

        procViewLoading('hide');
    };


    var getResourceQuotaList = function (namespace) {
        procViewLoading('show');

        var reqUrl = "<%= Constants.API_URL %><%= Constants.URI_API_NAME_SPACES_RESOURCE_QUOTAS %>"
            .replace("{cluster:.+}", CLUSTER_NAME)
            .replace("{namespace:.+}", namespace);

        procCallAjax(reqUrl, "GET", null, null, callbackGetResourceQuotaList);
    };

    var callbackGetResourceQuotaList = function (data) {

        var f_srch_resourceQuotas = 'ResourceQuotas 목록 조회에 실패하였습니다.';
        var s_msg_f_srch_resourceQuotas= '<spring:message code="M0077" arguments='arg_f_srch_resourceQuotas' javaScriptEscape="true" text="ResourceQuotas 목록 조회에 실패하였습니다."/>';
        s_msg_f_srch_resourceQuotas_lang = s_msg_f_srch_resourceQuotas.replace('arg_f_srch_resourceQuotas', f_srch_resourceQuotas);

        var html = $("#quota-template").html();

        if (!procCheckValidData(data)) {
            procViewLoading('hide');
            procAlertMessage(s_msg_f_srch_resourceQuotas_lang, false);
            return false;
        }

        var trHtml;
        if (data.items.length >= 1) {
            for (var i = 0; i < data.items.length; i++) {
                var htmlRe = "";

                trHtml = "";
                trHtml += "<tr>"
                    + "<td>" + data.items[i].metadata.name + "</td>"
                    + "<td><p>" + JSON.stringify(data.items[i].resourceQuotasStatus) + "</p></td>"
                    + "<td>" + data.items[i].metadata.creationTimestamp + "</td>"
                    + "</tr>";

                htmlRe = html.replace("<tbody id=\"resultAreaForResourceQuotas\">", "<tbody id=\"resultAreaForResourceQuotas\">" + trHtml);

                $("#detailTab").append(htmlRe);

            }
        } else {
            $("#detailTab").append(html);

            $("#resultHeaderAreaForResourceQuotas").hide();
            $("#resultAreaForResourceQuotas").hide();
            $("#noResultAreaForResourceQuotas").show();
        }

        procSetToolTipForTableTd('resultAreaForResourceQuotas');
        procViewLoading('hide');
    };


    var getLimitRangeList = function (namespace) {
        procViewLoading('show');

        var reqUrl = "<%= Constants.API_URL %><%= Constants.URI_API_NAME_SPACES_LIMIT_RANGES %>"
            .replace("{cluster:.+}", CLUSTER_NAME)
            .replace("{namespace:.+}", namespace);

        procCallAjax(reqUrl, "GET", null, null, callbackGetLimitRangeList);
    };

    var callbackGetLimitRangeList = function (data) {

        var f_srch_limitRanges = 'LimitRanges 목록 조회에 실패하였습니다.';
        var s_msg_f_srch_limitRanges= '<spring:message code="M0078" arguments='arg_f_srch_limitRanges' javaScriptEscape="true" text="LimitRanges 목록 조회에 실패하였습니다."/>';
        s_msg_f_srch_limitRanges_lang = s_msg_f_srch_limitRanges.replace('arg_f_srch_limitRanges', f_srch_limitRanges);

        var html = $("#range-template").html();

        if (!procCheckValidData(data)) {
            procViewLoading('hide');
            procAlertMessage(s_msg_f_srch_limitRanges_lang, false);
            return false;
        }

        var trHtml;

        dataLength = data.items.length;
        yCount = 0;

        for (var key = 0; key < data.items.length; key++) {
            if (data.items[key].checkYn == "Y") {
                yCount++;
            }
        };


        if (yCount > 0) {
            for (var key = 0; key < data.items.length; key++) {
                var htmlRe = "";
                trHtml = "";
                if (data.items[key].checkYn == "Y") {
                    trHtml += "<tr>"
                        + "<td>" + data.items[key].resource + "</td>"
                        + "<td>" + data.items[key].type + "</td>"
                        + "<td>" + data.items[key].defaultLimit + "</td>"
                        + "<td>" + data.items[key].defaultRequest + "</td>"
                        + "</tr>";

                    htmlRe = html.replace("<tbody id=\"resultAreaForLimitRanges\">", "<tbody id=\"resultAreaForLimitRanges\">" + trHtml);
                    htmlRe = htmlRe.replace("{{items.name}}", data.items[key].name);

                    $("#detailTab").append(htmlRe);

                }
            }
        } else {
            $("#detailTab").append(html);

            $("#nameForLimitRanges").hide();
            $("#resultHeaderAreaForLimitRanges").hide();
            $("#resultAreaForLimitRanges").hide();
            $("#noResultAreaForLimitRanges").show();

        }

        procViewLoading('hide');

    }


    var getUsersLoginMetaData = function () {
        procViewLoading('show');
        var portal_provider_service =  "${portal_provider_service}";
        var portal_provider_standalone = "${portal_provider_standalone}";
        var portal_provider_id = "${portal_provider_id}";

        if(portal_provider_id == portal_provider_service) {
            var reqUrl = "<%= Constants.API_URL %><%= Constants.URI_USER_LOGIN_METADATA %>";
            procCallAjax(reqUrl, "GET", null, null, setUsersLoginMetaData);
        }
    };

    var setUsersLoginMetaData = function(data) {
       var serviceInstanceId = data.serviceInstanceId;
        if(serviceInstanceId != null) {
        sessionStorage.setItem("<%= Constants.SERVICEINSTANCE_ID %>", serviceInstanceId);
        }
    };


    $(document.body).ready(function () {
        getUsersLoginMetaData();
        getDetail();
        getResourceQuotaList(NAME_SPACE);
        getLimitRangeList(NAME_SPACE);
    });

</script>
