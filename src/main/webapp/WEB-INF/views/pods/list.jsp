<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%--
  Pods list

  @author kjhoon
  @version 1.0
  @since 2020.09.01
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.paasta.container.platform.web.user.common.Constants" %>
<div class="sortable_wrap">
    <div class="sortable_top">
        <p>Pods</p>
        <ul id="pod-list-search-form" class="colright_btn">
            <li>
                <input type="text" id="table-search-01" name="table-search" class="table-search" placeholder="search"
                       onkeypress="if (event.keyCode === 13) { searchPodsList(this.value); }" maxlength="100"/>
                <button name="button" class="btn table-search-on" type="button">
                    <i class="fas fa-search"></i>
                </button>
            </li>
        </ul>
    </div>
    <div class="view_table_wrap">
        <table class="table_event condition alignL service-lh" id="resultTableForPod">
            <colgroup>
                <col style='width:auto;'>
                <col style='width:10%;'>
                <col style='width:10%;'>
                <col style='width:7%;'>
                <col style='width:5%;'>
                <col style='width:15%;'>
                <col style='width:10%;'>
                <col style='width:10%;'>
            </colgroup>
            <thead>
            <tr id="noPodListResultArea" style="display: none;">
                <td colspan='8'><p class='service_p'><spring:message code="M0113" text="실행 중인 Pods가 없습니다."/></p></td>
            </tr>
            <tr id="podListResultHeaderArea" class="headerSortFalse">
                <td>Name</td>
                <td>Namespace</td>
                <td>Node</td>
                <td>Status</td>
                <td>Restarts</td>
                <td>Created on</td>
                <td>CPU (cores)</td>
                <td>Memory (bytes)</td>
            </tr>
            </thead>
            <tbody id="podListResultArea">
            </tbody>
        </table>
    </div>
    <div class="resourceMoreDetailWrapDiv">
        <button id="podsMoreDetailBtn" class="resourceMoreDetailBtn"><spring:message code="M0056" text="더보기(More)"/></button>
    </div>
</div>
<script type="text/javascript">

    var G_PODS_LIST;

    // Overview 통계용 데이터 (Statistics Data for Overview)
    var G_PODS_LIST_LENGTH = 0;
    var G_PODS_CHART_RUNNING_CNT = 0;
    var G_PODS_CHART_FAILED_CNT = 0;
    var G_PODS_CHART_PENDING_CNT = 0;
    var G_PODS_CHART_SUCCEEDED_CNT = 0;
    var G_PODS_LIST_GET_FIRST = true;
    var G_PODS_LIST_OFFSET = 0;
    var G_PODS_LIST_LIMIT_COUNT= 0;
    var G_PODS_LIST_SEARCH_KEYWORD = null;
    var G_PODS_MORE_BTN_ID = 'podsMoreDetailBtn';

    // GET PODS' LIST USING REQUEST URL FOR OTHER WORKLOADS
    var getPodListUsingRequestURL = function (reqUrl) {
        procCallAjax(reqUrl, 'GET', null, null, callbackGetPodList);
    };

    // GET PODS' LIST FOR OTHER PAGES
    var getPodsList = function (offset, limit, searchName) {
        procViewLoading('show');

        var param = makeResourceListParamQuery(offset, limit, searchName);
        var reqUrl = "<%= Constants.API_URL %><%= Constants.URI_API_PODS_LIST %>" + param;
        reqUrl = reqUrl.replace("{cluster:.+}", CLUSTER_NAME).replace('{namespace:.+}', NAME_SPACE);

        procCallAjax(reqUrl, 'GET', null, null, callbackGetPodList);
    };

    // CALLBACK POD LIST
    var callbackGetPodList = function (data) {

        var f_srch_pods = 'Pods 목록 조회에 실패하였습니다.';
        var s_msg_f_srch_pods= '<spring:message code="M0114" arguments='arg_f_srch_pods' javaScriptEscape="true" text="Pods 목록 조회에 실패하였습니다."/>';
        s_msg_f_srch_pods_lang = s_msg_f_srch_pods.replace('arg_f_srch_pods', f_srch_pods);

        if (!procCheckValidData(data)) {
            procViewLoading('hide');
            procAlertMessage(s_msg_f_srch_pods_lang, false);
            return false;
        }

        G_PODS_LIST = data;
        G_PODS_LIST_LENGTH = data.items.length;

        resourceListMoreBtnDisplay('<%= Constants.REMAIN_ITEM_COUNT_KEY %>', data, G_PODS_MORE_BTN_ID);
        setPodsList("");
        procViewLoading('hide');
    };

    var setPodsList = function (searchKeyword) {
        procViewLoading('show');

        var resultArea = $('#podListResultArea');//.hide();
        var resultHeaderArea = $('#podListResultHeaderArea');//.hide();
        var noResultArea = $('#noPodListResultArea');//.show();
        var resultTable = $('#resultTableForPod');

        var checkListCount = 0;
        var htmlString = [];

        var podList = [];
        var podNameList = [];
        var pod;

        $.each(G_PODS_LIST.items, function (index, item) {

            var podName = item.metadata.name;
            pod = getPod(item);
            podList.push(pod);

            if ((nvl(searchKeyword) === "") || podName.indexOf(searchKeyword) > -1) {

                if (!('Running' === pod.podStatus || 'Succeeded' === pod.podStatus)) {
                    podNameList.push(pod.name);
                }

                switch (pod.podStatus) {
                    case 'Pending':
                        G_PODS_CHART_PENDING_CNT++;
                        break;
                    case 'Running':
                        G_PODS_CHART_RUNNING_CNT++;
                        break;
                    case 'Succeeded':
                        G_PODS_CHART_SUCCEEDED_CNT++;
                        break;
                    default:
                        G_PODS_CHART_FAILED_CNT++;
                        break;
                }

                var nodeNameHtml;
                if (pod.nodeName !== '-') {
                    nodeNameHtml = procCreateMovePageAnchorTag('<%= Constants.URI_CLUSTER_NODES %>/' + pod.nodeName + '/summary', pod.nodeName);
                } else {
                    nodeNameHtml = '-';
                }

                var namespaceHtml = procCreateMovePageAnchorTag('<%= Constants.URI_CLUSTER_NAMESPACES %>/' + pod.namespace, pod.namespace);
                // GET POD EVENTS
                procSetEventStatusForPods(pod.uid, pod.podStatus);
                var eventHtml = G_EVENT_STR.replace("{podLink}", procCreateMovePageAnchorTag('<%= Constants.URI_WORKLOAD_PODS %>/' + pod.name, pod.name));
                htmlString.push('<tr name="podRow" data-search-key="' + pod.name + '">'
                    + '<td>' + eventHtml + '</td>'
                    + '<td>' + namespaceHtml + '</td>'
                    + '<td>' + nodeNameHtml + '</td>'
                    + '<td><span>' + pod.podStatus + '</span></td>'
                    + '<td>' + pod.restartCount + '</td>'
                    + '<td>' + pod.creationTimestamp + '</td>'
                    + '<td><span>' + pod.usageCPU + '</span></td>'
                    + '<td><span>' + pod.usageMemory + '</span></td>'
                    + '</tr>');
                checkListCount++;
            }
        });

        if (G_PODS_LIST_LENGTH < 1 || checkListCount < 1) {
            resultHeaderArea.hide();
            resultArea.hide();
            noResultArea.show();
        } else if (G_PODS_LIST_GET_FIRST == true) {
            noResultArea.hide();
            resultHeaderArea.show();
            resultArea.html(htmlString);
            resultArea.show();

            $('.headerSortFalse > td').unbind();
        } else if (G_PODS_LIST_GET_FIRST == false) {
            $('#podListResultArea tr:last').after(htmlString);
        }


        procSetToolTipForTableTd('podListResultArea');
        $('[data-toggle="tooltip"]').tooltip();
        procViewLoading('hide');
    };

    // GET POD STATUS FROM POD'S STATUS DATA
    var getPodStatus = function (podStatus) {
        var podStatusStr = nvl(podStatus.phase, 'Unknown');
        if (podStatusStr.includes('Succeeded')) {
            return podStatusStr;
        }

        // default value is empty array, callback is none.
        var containerStatuses = [];
        if ('' !== nvl(podStatus['containerStatuses'])) {
            containerStatuses = podStatus['containerStatuses']
        }

        if (containerStatuses instanceof Array && 0 === containerStatuses.length) {
            return podStatusStr;
        }

        var notRunningIndex = -1;
        var notRunningState = podStatusStr.toLowerCase();
        containerStatuses.map(function (item, index) {
            var state = Object.keys(item.state)[0];
            // terminated state : highest order
            if ('running' !== state && 'terminated' !== notRunningState) {
                notRunningIndex = index;
                notRunningState = state;
            }
        });

        if (-1 === notRunningIndex) {
            return 'Running';
        } else {
            var statusStr = notRunningState.charAt(0).toUpperCase() + notRunningState.substring(1);
            var reason = nvl(containerStatuses[notRunningIndex].state[notRunningState]['reason'], 'Unknown');
            return (statusStr + ': ' + reason);
        }
    };

    // GET POD DATA
    var getPod = function (podItem) {
        var metadata = podItem.metadata;
        var spec = podItem.spec;
        var status = getPodStatus(podItem.status);
        var errorMsg;
        if (status !== 'Running' && status !== 'Succeeded') {
            errorMsg = 'Unknown Error';
            if ('' !== nvl(podItem.status.conditions)) {
                var findConditions = podItem.status.conditions.filter(function (item) {
                    return item.reason != null && item.message != null
                });
                if (findConditions.length > 0) {
                    errorMsg = findConditions[0].reason;
                    if ('' !== nvl(findConditions[0].message)) {
                        errorMsg += ' (' + findConditions[0].message + ')';
                    }
                }
            }
        } else {
            errorMsg = '';
        }

        var containerStatuses = [];
        if ('' !== nvl(podItem.status.containerStatuses)) {
            containerStatuses = podItem.status.containerStatuses;
        }
        var restartCountSum = 0;
        for (var i = 0; i < containerStatuses.length; i++) {
            if ('' !== nvl(containerStatuses[i].restartCount)) {
                restartCountSum += containerStatuses[i].restartCount;
            }
        }

        var cpuSum = 0;
        var memorySum = 0;
        var hasResources = false;
        if ('' != nvl(spec.containers)) {
            try {
                $.each(spec.containers, function (index, container) {
                    if ('' === nvl(container.resources))
                        return;
                    var resource = {};
                    if ('' !== nvl(container.resources.usage)) {
                        resource = container.resources.usage;
                    } else if ('' !== nvl(container.resources.requests)) {
                        resource = container.resources.requests;
                    } else if ('' !== nvl(container.resources.limits)) {
                        resource = container.resources.limits;
                    } else {
                        return;
                    }
                    hasResources = true;

                    if (resource.cpu.indexOf('m') > 0) {
                        cpuSum += Number(resource.cpu.substring(0, resource.cpu.length - 1));
                    }
                    else if (resource.cpu.indexOf('n') > 0) {
                        cpuSum += Number(resource.cpu.substring(0, resource.cpu.length - 1));
                    }
                    else {
                        cpuSum += Number(resource.cpu) * 1000;
                    }

                    var multiple = 1;
                    if (resource.memory.toLowerCase().indexOf('gi') > 0) {
                        multiple = 1024;
                    }

                    memorySum += (multiple * Number(resource.memory.substring(0, resource.memory.length - 2)));
                });
            } catch (e) {
                cpuSum = memorySum = -1;
            }
        }

        if (!hasResources) {
            cpuSum = memorySum = -1;
        }

        if (cpuSum <= -1) {
            cpuSum = '-';
        } else {
            var cpuFloat = Number.parseFloat(cpuSum / (1000*1000));
            cpuSum = Math.ceil(cpuFloat).toFixed(2) + 'm';
        }

        if (memorySum <= -1) {
            memorySum = '-';
        } else if (memorySum > (1024*1024)) {
            var memoryFloat = Number.parseFloat(memorySum / (1024*1024)).toFixed(2);
            var memoryInt = Number.parseInt(memorySum / (1024*1024));
            if (Math.abs(memoryFloat - memoryInt) === 0) {
                memorySum = memoryInt + 'Gi';
            } else {
                memorySum = memoryFloat + 'Gi';
            }
        } else {
            var memoryFloat = Number.parseFloat(memorySum / 1024).toFixed(2);
            memorySum = memoryFloat + 'Mi';
        }

        return {
            name: metadata.name,
            namespace: metadata.namespace,
            nodeName: nvl(spec.nodeName, '-'),
            podStatus: status,
            podErrorMsg: errorMsg,
            restartCount: restartCountSum,
            creationTimestamp: metadata.creationTimestamp,
            usageCPU: cpuSum,
            usageMemory: memorySum,
            uid: metadata.uid
        };
    };

    // SET EVENT STATUS FOR PODS
    var procSetEventStatusForPods = function (podUidName, status) {
        var reqUrl;

        reqUrl = URI_API_EVENTS_LIST.replace("{cluster:.+}", CLUSTER_NAME).replace("{namespace:.+}", NAME_SPACE).replace("{resourceUid:.+}", podUidName + '?status=' + status);
        return procCallAjax(reqUrl, "GET", null, null, callbackSetEventStatusForPods);
    };

    // CALLBACK SET EVENT(STATUS) FOR PODS AND RESOURCES RELATED PODS
    var G_EVENT_STR;
    var callbackSetEventStatusForPods = function (data) {
        var statusIconHtml = "";
        var statusMessageHtml = [];
        G_EVENT_STR = "";
        var itemList = data.items;

        if (data.status === 'Running' || data.status === 'Succeeded') {
            statusIconHtml = "<span class='green2 tableTdToolTipFalse'><i class='fas fa-check-circle'></i> </span>";
        } else {
            statusIconHtml = "<span class='red2 tableTdToolTipFalse'><i class='fas fa-exclamation-circle'></i> </span>";
            $.each(itemList, function (index, item) {
                if (item.type == 'Warning') { // [Warning]과 [Warning] 외 두 가지 상태로 분류
                    statusMessageHtml += "<p class='red2 custom-content-overflow'>" + item.message + "</p>";
                }
            });
        }

        G_EVENT_STR = statusIconHtml + '{podLink}' + statusMessageHtml;
        procViewLoading('hide');
    };
</script>

<script>

    $(document).on('click', '#' + G_PODS_MORE_BTN_ID, function () {

        G_PODS_LIST_GET_FIRST = false;
        G_PODS_LIST_OFFSET++;
        G_PODS_LIST_LIMIT_COUNT = setResourceListLimitCount();

        getPodsList(G_PODS_LIST_OFFSET, G_PODS_LIST_LIMIT_COUNT, G_PODS_LIST_SEARCH_KEYWORD);

    });

    var searchPodsList = function (searchName) {

        searchName = searchName.trim();
        if (searchName == null || searchName.length == 0) {
            searchName = null;
        }
        G_PODS_LIST_GET_FIRST = true;
        G_PODS_LIST_SEARCH_KEYWORD = searchName;
        G_PODS_LIST_OFFSET = 0;
        G_PODS_LIST_LIMIT_COUNT = setResourceListLimitCount();


        if (typeof ownerParamForPodsByWorkloadsOverview !== 'undefined') {
            //search by workloads overview
            $("#" + G_PODS_MORE_BTN_ID).css("display", "block");
            getPodsList(0, G_PODS_LIST_LIMIT_COUNT, G_PODS_LIST_SEARCH_KEYWORD);

        }
        else if (typeof ownerParamForPodsByReplicaSets !== 'undefined') {
            //search by replicaSets
            getDetailForPodsList(ownerParamForPodsByReplicaSets, G_PODS_LIST_SEARCH_KEYWORD);
        }
        else if (typeof ownerParamForPodsByServices !== 'undefined') {
            //search by services
            getDetailForPodsList(ownerParamForPodsByServices, G_PODS_LIST_SEARCH_KEYWORD);
        }
        else if (typeof ownerParamForPodsByNodes !== 'undefined') {
            //search by nodes
            getDetailForPodsList(ownerParamForPodsByNodes, G_PODS_LIST_SEARCH_KEYWORD);
        }
        else {
            // search by pods
            $("#" + G_PODS_MORE_BTN_ID).css("display", "block");
            getPodsList(0, G_PODS_LIST_LIMIT_COUNT, G_PODS_LIST_SEARCH_KEYWORD);
        }

    };

</script>