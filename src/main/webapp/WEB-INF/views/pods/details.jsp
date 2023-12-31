<%--
  Pods details

  @author jjy
  @version 1.0
  @since 2020.09.01
--%>
<%@ page import="org.paasta.container.platform.web.user.common.Constants" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div class="content">
    <h1 class="view-title"><span class="detail_icon"><i class="fas fa-file-alt"></i></span><c:out value="${podName}" default="-"/></h1>

    <jsp:include page="../common/contentsTab.jsp"/>

    <!-- Details 시작 (Details start)-->
    <div class="cluster_content01 row two_line two_view harf_view">
        <ul class="maT30">
            <li class="cluster_first_box">
                <div class="sortable_wrap">
                    <div class="sortable_top">
                        <p>Details</p>
                    </div>
                    <div class="account_table view">
                        <table>
                            <colgroup>
                                <col style="width:20%">
                                <col style=".">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th><i class="cWrapDot"></i> Name</th>
                                <td id="name"> -</td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Labels</th>
                                <td id="labels" class="labels_wrap"> -</td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Creation Time</th>
                                <td id="creationTime"> -</td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Status</th>
                                <td id="status"> -</td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> QoS Class</th>
                                <td id="qosClass"> -</td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Node</th>
                                <td id="node"> -</td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> IP</th>
                                <td id="ip"> -</td>
                            </tr>

                            <tr>
                                <th><i class="cWrapDot"></i> Conditions</th>
                                <td id="conditions"> -</td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Controllers</th>
                                <td id="controllers"> -</td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Volumes</th>
                                <td id="volumes"> -</td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </li>
            <!-- Details 끝 (Details end)-->
            <!-- Containers 시작 (Containers start)-->
            <li class="cluster_third_box maB50">
                <div class="sortable_wrap">
                    <div class="sortable_top">
                        <p>Containers</p>
                    </div>
                    <div class="view_table_wrap toggle">
                        <table class="table_event condition alignL">
                            <colgroup>
                                <col style='width:auto;'>
                                <col style='width:15%;'>
                                <col style='width:25%;'>
                                <col style='width:15%;'>
                            </colgroup>
                            <tr id="noContainersResultArea" style="display: none;">
                                <td colspan='6'><p class='service_p'><spring:message code="M0111" text="실행 중인 Containers가 없습니다."/></p></td>
                            </tr>
                            <thead id="containersResultHeaderArea">
                            <tr>
                                <td>Name</td>
                                <td>Status</td>
                                <td>Images</td>
                                <td>Restart count</td>
                            </tr>
                            </thead>
                            <tbody id="containersResultArea">
                            </tbody>
                        </table>
                    </div>
                </div>
            </li>
            <!-- Containers 끝 (Containers end)-->
            <li class="cluster_fifth_box maB50">
                <jsp:include page="../common/commonDetailsBtn.jsp"/>
            </li>
        </ul>
    </div>
    <!-- Details 끝 (Details end)-->
</div>

<input type="hidden" id="hiddenNamespace" name="hiddenNamespace" value="" />
<input type="hidden" id="hiddenResourceKind" name="hiddenResourceKind" value="pods" />
<input type="hidden" id="hiddenResourceName" name="hiddenResourceName" value="" />

<script type="text/javascript">

    // GET POD'S DETAIL
    var getDetail = function() {
        var resourceName = '<c:out value="${podName}" default="" />';

        var reqUrl = '<%= Constants.API_URL %><%= Constants.URI_API_PODS_DETAIL %>'
            .replace("{cluster:.+}", CLUSTER_NAME)
            .replace('{namespace:.+}', NAME_SPACE).replace('{podName:.+}', resourceName);

        procCallAjax(reqUrl, 'GET', null, null, callbackGetDetail);
    };

    // REPLACE FIRST LETTER ONLY TO UPPER-CASE ALPHABET LETTER FROM EXTERNAL STRING(OR OBJECT)
    var upperCaseFirstLetterOnly = function(obj) {
        return (obj + '').charAt(0).toUpperCase() + (obj + '').substring(1);
    };

    // CREATE CONTAINER MAP (CONTAINER INFO + CONTAINER STATUS)
    var getContainerMap = function(containers, containerStatuses, podPhase) {
        var containerMap = {};
        var tempArr;

        if ('' === nvl(containers)) {
            return containerMap;
        }

        containers.map(function(container) {
            var name = nvl(container['name']);
            if ('' !== name) {
                containerMap[name] = container;
            }
        });

        if ('' !== nvl(containerStatuses)) {
            containerStatuses.map(function(status) {
                var name = nvl(status['name']);
                if ('' === name) {
                    return;
                }
                tempArr = Object.keys(status['state']);
                if (tempArr.length > 0) {
                    containerMap[name]['state'] = upperCaseFirstLetterOnly(tempArr[0]);
                } else {
                    containerMap[name]['state'] = upperCaseFirstLetterOnly(podPhase);
                }

                containerMap[name]['restartCount'] = status.restartCount;
                containerMap[name]['ready'] = status.ready;
            });
        } else {
            // default value
            containers.map(function(container) {
                var name = nvl(container['name']);
                containerMap[name]['state'] = ' -';
                containerMap[name]['restartCount'] = ' -';
                containerMap[name]['ready'] = ' -';
            });
        }

        return containerMap;
    };

    // CREATE CONTAINERS RESULT AREA CONTENT
    var createContainerResultArea = function(status, containers) {
        var resultArea = $('#containersResultArea');
        var resultHeaderArea = $('#containersResultHeaderArea');
        var noResultArea = $('#noContainersResultArea');

        var containerMap = getContainerMap(containers, status.containerStatuses, nvl(status.phase, 'Unknown'));
        var listCount = 0;

        //<%-- Container 정보에 대한 Table Form 시작 (start Table Form for Container info)--%>
        var containerDetailHtml =
            '<div><table class="table_detail alignL"> \
                <colgroup><col style="*"><col style="*"></colgroup> \
                <tbody> \
                    <tr><td>Name</td>                  <td name="cName" > -</td></tr> \
                    <tr><td>Image</td>                 <td name="cImage"> -</td></tr> \
                    <tr><td>Environment variables</td> <td name="cEnv"  > -</td></tr> \
                    <tr><td>Commands</td>              <td name="cCmd"  > -</td></tr> \
                    <tr><td>Args</td>                  <td name="cArgs" > -</td></tr> \
                </tbody></table></div>';

        $.each(Object.keys(containerMap), function(index, item) {
            var container = containerMap[item];

            var detailTable = $(containerDetailHtml);
            var tdList = detailTable.find('td[name]');
            tdList[0].innerHTML = container.name;
            tdList[1].innerHTML = container.image;
            tdList[2].innerHTML = envParser(container);
            tdList[3].innerHTML = nvl(container.command, '-');
            tdList[4].innerHTML = nvl(container.args, '-');

            resultArea.append('<tr>'
                + '<td><a href="javascript:void(0);" onclick="showHide(\'container-' + index + '\');">' + container.name + '</a></td>'
                + '<td><span>' + nvl(container.state, ' - ') + '</span></td>'
                + '<td><span>' + nvl(container.image, ' - ') + '</span></td>'
                + '<td>' + nvl(container.restartCount, ' - ') + '</td></tr>'
                + '<tr style="display:none;" id="container-' + index + '"><td colspan="4">' + detailTable.html() + '</td></tr>');

            listCount++;
        });

        if (listCount < 1) {
            resultHeaderArea.hide();
            resultArea.hide();
            noResultArea.show();
        } else {
            noResultArea.hide();
            resultHeaderArea.show();
            resultArea.show();
        }

        // TOOL TIP
        procSetToolTipForTableTd('containersResultArea');
        $('[data-toggle="tooltip"]').tooltip();
    };

    // CONTAINER ENVIRONMENT VARIABLE PARSER
    var envParser = function(container) {
        if (container.env == null) {
            return '-';
        }

        var envs = container.env;
        var tempStr = '';

        for (var i = 0; i < envs.length; i++) {
            if ('' !== tempStr) {
                tempStr += '<br>';
            }

            if (Object.keys(envs[i]).indexOf('valueFrom') > -1) {
                var valueFrom = envs[i]['valueFrom'];
                if (null == valueFrom['fieldRef']) {
                    tempStr += (Object.values(envs[i])[0] + ':&nbsp;' + JSON.stringify(valueFrom));
                } else {
                    tempStr += (Object.values(envs[i])[0] + ':&nbsp;' + JSON.stringify(valueFrom['fieldRef']));
                }
            } else {
                tempStr += (Object.values(envs[i])[0] + ':&nbsp;' + Object.values(envs[i])[1]);
            }
        }

        return tempStr;
    };

    // SHOW/HIDE ACTION FOR CONTAINER TABLE
    var showHide = function(indexId) {
        var tr = $('#' + indexId);

        if (tr.is(':visible')) {
            tr.css('display', 'none');
        } else {
            tr.css('display', 'table-row');
        }
    };

    // CALLBACK GET POD'S DETAIL
    var callbackGetDetail = function(data) {

        var f_srch_pods = 'Pods 상세 조회에 실패하였습니다.';
        var s_msg_f_srch_pods= '<spring:message code="M0112" arguments='arg_f_srch_pods' javaScriptEscape="true" text="Pods 상세 조회에 실패하였습니다."/>';
        s_msg_f_srch_pods_lang = s_msg_f_srch_pods.replace('arg_f_srch_pods', f_srch_pods);

        procViewLoading('show');

        if (!procCheckValidData(data)) {
            procViewLoading('hide');
            procAlertMessage(s_msg_f_srch_pods_lang, false);
            return;
        }

        data.metadata.labels = nvl(data.metadata.labels, {});
        var labelKeys = Object.keys(data.metadata.labels);
        for (var i = 0; i < labelKeys.length; i++) {
            // convert raw character of comma and quota to html symbol
            data.metadata.labels[labelKeys[i]] =
                data.metadata.labels[labelKeys[i]].replace(/,/g, '&comma;').replace(/"/g, '&quot;')
                    .replace(/{/g, '&lbrace;').replace(/}/g, '&rbrace;').replace(/:/g, '&colon;');
        }

        var labels = procSetSelector(data.metadata.labels);
        var conditionStr = '';
        if ('' !== nvl(data.status.conditions)) {
            for (var i = 0; i < data.status.conditions.length; i++) {
                if (i > 0) {
                    conditionStr += ', ';
                }
                conditionStr += (data.status.conditions[i].type + ': ' + data.status.conditions[i].status);
            }
        } else {
            conditionStr = '-';
        }

        var nodeNameHtml;
        if ('' !== nvl(data.spec.nodeName)) {
            nodeNameHtml = procCreateMovePageAnchorTag('<%= Constants.URI_CLUSTER_NODES %>/' + data.spec.nodeName + '/summary', data.spec.nodeName);
        } else {
            nodeNameHtml = '-';
        }

        var controllerNameHtml;
        if (data.metadata.ownerReferences instanceof Array && data.metadata.ownerReferences[0] instanceof Object) {
            var ownerName = nvl(data.metadata.ownerReferences[0].name, '-');
            if ('-' !== ownerName && labels.match('job-name')) {
                controllerNameHtml = ownerName;
            } else {
                controllerNameHtml = procCreateMovePageAnchorTag('<%= Constants.URI_WORKLOAD_REPLICA_SETS %>/' + ownerName, ownerName);
            }
        } else {
            controllerNameHtml = '-';
        }

        var volumeName;
        if (data.spec.volumes instanceof Array && data.spec.volumes[0] instanceof Object) {
            volumeName = nvl(data.spec.volumes[0].name, '-');
        } else {
            volumeName = '-';
        }

        var podName      = data.metadata.name;
        var namespace    = data.metadata.namespace;

        $('#name').html(data.metadata.name);
        $('#labels').html(procCreateSpans(labels));
        $('#creationTime').html(nvl(data.metadata.creationTimestamp, '-'));
        $('#status').html(nvl(data.status.phase, '-'));
        $('#qosClass').html(nvl(data.status.qosClass, '-'));
        $('#node').html(nodeNameHtml);
        $('#conditions').html(conditionStr);
        $('#ip').html(nvl(data.status.podIP, '-'));
        $('#controllers').html(controllerNameHtml);
        $('#volumes').html(volumeName);

        createContainerResultArea(data.status, data.spec.containers);

        procViewLoading('hide');

        $('#hiddenNamespace').val(namespace);
        $('#hiddenResourceName').val(podName);

    };

    // ON LOAD
    $(document.body).ready(function() {
        getDetail();
    });
</script>
