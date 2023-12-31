<%--
  ReplicaSets detail

  @author kjhoon
  @version 1.0
  @since 2020.08.25
--%>
<%@ page import="org.paasta.container.platform.web.user.common.Constants" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="org.paasta.container.platform.web.user.common.Constants" %>

<div class="content">
    <h1 class="view-title"><span class="detail_icon"><i class="fas fa-file-alt"></i></span><c:out value="${replicaSetName}"/></h1>
    <jsp:include page="../common/contentsTab.jsp"/>
    <!-- Details 시작 (Details start)-->
    <div class="cluster_content01 row two_line two_view harf_view">
        <ul class="maT30">
            <!-- Details 시작 (Details start)-->
            <li class="cluster_first_box">
                <div class="sortable_wrap">
                    <div class="sortable_top">
                        <p>Details</p>
                    </div>
                    <div class="account_table view">
                        <table>
                            <colgroup>
                                <col style="width:20%">
                                <col style="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th><i class="cWrapDot"></i> Name</th>
                                <td id="resultResourceName"></td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Namespace</th>
                                <td id="resultNamespace"></td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Labels</th>
                                <td id="resultLabel" class="labels_wrap">
                                </td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Annotations</th>
                                <td id="resultAnnotation" class="labels_wrap">
                                </td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Creation Time</th>
                                <td id="resultCreationTimestamp"></td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Selector</th>
                                <td id="resultSelector"><span class="bg_gray"></span></td>
                            </tr>

                            <tr>
                                <th><i class="cWrapDot"></i> Image</th>
                                <td id="resultImage"></td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Pods</th>
                                <td id="resultPods"></td><!-- 3 running -->
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Managing deployment</th>
                                <td id="resultDeployment"><a href="#"></a></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </li>
            <!-- Details 끝 (Details end)-->
            <!-- Pods 시작 (Pods start)-->
            <li class="cluster_third_box">
                <jsp:include page="../pods/list.jsp"/>
            </li>
            <!-- Pods 끝 (Pods end)-->
            <!-- Services 시작 (Services start)-->
            <li class="cluster_fourth_box maB50">
                <div class="sortable_wrap">
                    <div class="sortable_top">
                        <p>Services</p>
                    </div>
                    <div class="view_table_wrap">
                        <table class="table_event condition alignL service-lh" id="resultTableForServices">
                            <colgroup>
                                <col style='width:auto;'>
                                <col style='width:10%;'>
                                <col style='width:10%;'>
                                <col style='width:15%;'>
                                <col style='width:15%;'>
                                <col style='width:20%;'>
                            </colgroup>
                            <thead>
                            <tr id="noResultAreaForServices"><td colspan='6'><p class='service_p'><spring:message code="M0115" text="실행 중인 Services가 없습니다."/></p></td></tr>
                            <tr id="resultHeaderAreaForService" style="display: none;">
                                <td>Name<button class="sort-arrow" onclick="procSetSortList('resultTableForServices', this, '0')"><i class="fas fa-caret-down"></i></button></td>
                                <td>Labels</td>
                                <td>Cluster IP</td>
                                <td>Internal endpoints</td>
                                <td>External endpoints</td>
                                <td>Created on<button class="sort-arrow" onclick="procSetSortList('resultTableForServices', this, '5')"><i class="fas fa-caret-down"></i></button></td>
                            </tr>
                            </thead>
                            <tbody id="resultAreaForService">
                            </tbody>
                        </table>
                    </div>
                </div>
            </li>
            <!-- Services 끝 (Services end) -->
            <li class="cluster_fifth_box maB50">
                <jsp:include page="../common/commonDetailsBtn.jsp"/>
            </li>
        </ul>
    </div>
</div>

<input type="hidden" id="hiddenNamespace" name="hiddenNamespace" value="" />
<input type="hidden" id="hiddenResourceKind" name="hiddenResourceKind" value="replicaSets" />
<input type="hidden" id="hiddenResourceName" name="hiddenResourceName" value="" />

<script type="text/javascript">
    var ownerParamForPodsByReplicaSets ='';
    var replicasetLabel = ""; // it label variable for Search Service List
    // GET DETAIL
    var getDetail = function() {
        var reqUrl = "<%= Constants.API_URL %><%= Constants.URI_API_REPLICA_SETS_DETAIL%>"
            .replace("{cluster:.+}", CLUSTER_NAME)
            .replace("{namespace:.+}", NAME_SPACE)
            .replace("{replicaSetName:.+}", '<c:out value="${replicaSetName}"/>');
        procCallAjax(reqUrl, "GET", null, null, callbackGetDetail);
    };
    // CALLBACK
    var callbackGetDetail = function(data) {

        var f_srch_replicaSets = 'ReplicaSets 상세 조회에 실패하였습니다.';
        var s_msg_f_srch_replicaSets= '<spring:message code="M0116" arguments='arg_f_srch_replicaSets' javaScriptEscape="true" text="ReplicaSets 상세 조회에 실패하였습니다."/>';
        s_msg_f_srch_replicaSets_lang = s_msg_f_srch_replicaSets.replace('arg_f_srch_replicaSets', f_srch_replicaSets);

        if (!procCheckValidData(data)) {
            procViewLoading('hide');
            procAlertMessage(s_msg_f_srch_replicaSets_lang, false);
            return false;
        }
        var replicaSetName      = data.metadata.name;
        var namespace           = data.metadata.namespace;
        var labels              = procSetSelector(data.metadata.labels);
        var annotations         = data.metadata.annotations;
        var creationTimestamp   = data.metadata.creationTimestamp;
        var selector            = procSetSelector(data.spec.selector.matchLabels); // 필수값 (Required value)
        var images              = [];
        var replicaSetUid       = data.metadata.uid;
        // 서비스 리스트를 조회하기 위한 replicaset label 참조 (Reference replicaset label for service List)
        replicasetLabel = data.spec.selector.matchLabels;

        //set Labels, UID by ReplicaSets details view
        ownerParamForPodsByReplicaSets = selector + "&type=replicaSets&ownerReferencesUid=" + replicaSetUid;

        var containers = data.spec.template.spec.containers;
        for(var i=0; i < containers.length; i++){
            images.push(containers[i].image);
        }
        $('#resultResourceName').html(replicaSetName);
        $('#resultNamespace').html(namespace);
        $('#resultLabel').html(procCreateSpans(labels));
        $('#resultAnnotation').html(procSetAnnotations(annotations));
        $('#resultCreationTimestamp').html(creationTimestamp);
        $('#resultSelector').html(procCreateSpans(selector));
        $('#resultImage').html(images.join("<br>"));
        $('#resultPods').html(data.status.availableReplicas+" running");
        $('#hiddenNamespace').val(namespace);
        $('#hiddenResourceName').val(replicaSetName);
        getDeploymentsInfo(data);
        getDetailForPodsList(ownerParamForPodsByReplicaSets, null);
        getServices();
    };
    // GET DEPLOYMENTS INFO
    var getDeploymentsInfo = function(data) {
        // URI_API_DEPLOYMENTS_DETAIL
        /*
           Deployments 조회 : replicaset 상세에서 ownerReferences 를 참조(metadata.ownerReferences.name == deployment name).
        */
        var deploymentName = "";
        var deploymentsInfo = "";
        if(data.metadata.ownerReferences == null){
            deploymentsInfo = "-";
        }else{
            deploymentName = data.metadata.ownerReferences[0].name;
            deploymentsInfo = "<a href='<%= Constants.URI_WORKLOAD_DEPLOYMENTS %>/"+deploymentName+"'>"+deploymentName+"</a>";
            var reqUrl = "<%= Constants.API_URL %><%= Constants.URI_API_DEPLOYMENTS_DETAIL %>"
                .replace("{cluster:.+}", CLUSTER_NAME)
                .replace("{namespace:.+}", NAME_SPACE)
                .replace("{deploymentName:.+}", deploymentName);
            procCallAjax(reqUrl, "GET", null, null, callbackGetDeploymentsInfo);
        }
        $('#resultDeployment').append(deploymentsInfo);
    };
    // CALLBACK
    var callbackGetDeploymentsInfo = function(data) {

        var f_srch_deployments = 'Deployments 상세 조회에 실패하였습니다.';
        var s_msg_f_srch_deployments = '<spring:message code="M0054" arguments='arg_f_srch_deployments' javaScriptEscape="true" text="Deployments 상세 조회에 실패하였습니다."/>';
        s_msg_f_srch_deployments_lang = s_msg_f_srch_deployments.replace('arg_f_srch_deployments', f_srch_deployments);

        if (!procCheckValidData(data)) {
            procViewLoading('hide');
            procAlertMessage(s_msg_f_srch_deployments_lang, false);
            return false;
        }
    };

    // GET DETAIL FOR PODS LIST
    var getDetailForPodsList = function(selector, searchName) {
        var param = "?selector=" + selector ;
        var reqUrl = "<%= Constants.API_URL %><%= Constants.URI_API_PODS_LIST_BY_SELECTOR %>" + param;
        reqUrl = reqUrl.replace("{cluster:.+}", CLUSTER_NAME).replace("{namespace:.+}", NAME_SPACE);

        if (searchName != null) {
            reqUrl += "&searchName=" + searchName;
        }

        getPodListUsingRequestURL(reqUrl);
        procViewLoading('hide');
    };



    // GET SERVICE LIST
    var getServices = function() {
        var reqUrl = "<%= Constants.API_URL %><%= Constants.URI_API_SERVICES_LIST%>"
            .replace("{cluster:.+}", CLUSTER_NAME)
            .replace("{namespace:.+}", NAME_SPACE);
        procCallAjax(reqUrl, "GET", null, null, callbackGetServices);
    };
    // CALLBACK
    var callbackGetServices = function(data) {

        var f_srch_services = 'Services 상세 조회에 실패하였습니다.';
        var s_msg_f_srch_services = '<spring:message code="M0117" arguments='arg_f_srch_services' javaScriptEscape="true" text="Services 상세 조회에 실패하였습니다."/>';
        s_msg_f_srch_services_lang = s_msg_f_srch_services.replace('arg_f_srch_services', f_srch_services);

        if (!procCheckValidData(data)) {
            procViewLoading('hide');
            procAlertMessage(s_msg_f_srch_services_lang, false);
            return false;
        }
        var serviceName,
            selector,
            endpointsPreString,
            nodePort,
            specPortsList,
            specPortsListLength,
            endpointProtocol,
            endpointWithSpecPort,
            endpointWithNodePort;
        var resultArea       = $('#resultAreaForService');
        var resultHeaderArea = $('#resultHeaderAreaForService');
        var noResultArea     = $('#noResultAreaForServices');
        var resultTable      = $('#resultTableForServices');

        var items = data.items;
        var listLength = items.length;
        var endpoints = "";
        var htmlString = [];
        var serviceListCount = 0;

        // replica set 에서 자동으로 생성되는 hash label 은 비교 대상에서 삭제 (Hash label in replica set is deleted from comparison)
        if(replicasetLabel["pod-template-hash"] !== undefined){
            delete replicasetLabel["pod-template-hash"];
        }

        for (var i = 0; i < listLength; i++) {

            // replicaset 과 service 의 spec.selector 를 비교해서 같은 항목의 서비스만 출력 (Output only services of the same item)
            if(!procCompareObj(items[i].spec.selector, replicasetLabel)){
                continue;
            }

            serviceListCount ++;
            serviceName = items[i].metadata.name;
            selector = procSetSelector(items[i].spec.selector);
            endpointsPreString = serviceName + "." + items[i].metadata.namespace + ":";
            nodePort = items[i].spec.ports.nodePort;

            var labels = procSetSelector(items[i].metadata.labels);
            specPortsList = items[i].spec.ports;

            if (nvl(specPortsList) !== '') {
                specPortsListLength = specPortsList.length;

                for (var j = 0; j < specPortsListLength; j++) {
                    nodePort = nvl(specPortsList[j].nodePort, '0');
                    endpointProtocol = specPortsList[j].protocol;
                    endpointWithSpecPort = endpointsPreString + specPortsList[j].port + " " + endpointProtocol;
                    endpointWithNodePort = endpointsPreString + nodePort + " " + endpointProtocol;

                    endpoints += '<p>' + endpointWithSpecPort + '</p>' + '<p>' + endpointWithNodePort + '</p>';
                }
            }

            //External Endpoints
            var externalEndpoints = [];
            externalEndpoints = items[i].spec.externalIPs;

            if( (externalEndpoints != null) && (externalEndpoints.length > 0) ){
                externalEndpoints = externalEndpoints.join('</BR>')
            }else{
                externalEndpoints = "-";
            }

            htmlString.push(
                "<tr>"
                + "<td><span class='green2'><i class='fas fa-check-circle'></i></span> "
                + "<a href='javascript:void(0);' onclick='procMovePage(\"<%= Constants.CP_BASE_URL %>/services/"
                + serviceName + "\");'>" + serviceName + "</a>"
                + "</td>"
                + "<td>" + procCreateSpans(labels, "LB") + "</td>"
                + "<td>" + items[i].spec.clusterIP + "</td>"
                + "<td>" + endpoints + "</td>"
                + "<td>" + externalEndpoints + "</td>"
                + "<td>" + items[i].metadata.creationTimestamp + "</td>"
                + "</tr>");
            endpoints = "";

        }

        if (serviceListCount < 1) {
            resultHeaderArea.hide();
            resultArea.hide();
            noResultArea.show();
        } else {
            noResultArea.hide();
            resultHeaderArea.show();
            resultArea.show();
            resultArea.html(htmlString);

            resultTable.tablesorter({
                sortList: [[5, 1]] // 0 = ASC, 1 = DESC
            });

            resultTable.trigger("update");
        }

        procSetToolTipForTableTd('resultAreaForService');
        procViewLoading('hide');

    };
    // ON LOAD
    $(document.body).ready(function () {
        getDetail();
    });
</script>