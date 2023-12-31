<%--
  PersistentVolumeClaims details

  @author jjy
  @version 1.0
  @since 2020.09.17
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.paasta.container.platform.web.user.common.Constants" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div class="content">
    <h1 class="view-title"><span class="detail_icon"><i class="fas fa-file-alt"></i></span> <c:out value="${persistentVolumeClaimName}"/></h1>
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
                                <td id="name"></td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Namespace</th>
                                <td id="namespaceID"></td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Labels</th>
                                <td id="labels" class="labels_wrap"></td>
                            </tr>

                            <tr>
                                <th><i class="cWrapDot"></i> Annotations</th>
                                <td id="annotations" class="labels_wrap">
                                </td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Creation Time</th>
                                <td id="creationTime"></td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Selector</th>
                                <td id="selector"></td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Requested Storage</th>
                                <td id="requestedStorage"></td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Access Modes</th>
                                <td id="accessModes"></td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Volume Name</th>
                                <td id="volumeName"></td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Volume Mode</th>
                                <td id="volumeMode"></td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Capacity</th>
                                <td id="capacity"></td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Storage Class name</th>
                                <td id="storageClassName"></td>
                            </tr>
                            <tr>
                                <th><i class="cWrapDot"></i> Status</th>
                                <td id="status"></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </li>
            <!-- Details 끝 (Details end)-->
            <li class="cluster_fifth_box maB50">
                <jsp:include page="../common/commonDetailsBtn.jsp"/>
            </li>
        </ul>
    </div>
    <!-- Details  끝 (Details end)-->
</div>

<input type="hidden" id="hiddenNamespace" name="hiddenNamespace" value="" />
<input type="hidden" id="hiddenResourceKind" name="hiddenResourceKind" value="persistentVolumeClaims" />
<input type="hidden" id="hiddenResourceName" name="hiddenResourceName" value="" />

<script type="text/javascript">

    // GET DETAIL
    var getPersistentVolumeClaimDetail = function () {
        procViewLoading('show');

        var reqUrl = "<%= Constants.API_URL %><%= Constants.URI_API_STORAGES_DETAIL %>"
            .replace("{cluster:.+}", CLUSTER_NAME)
            .replace("{namespace:.+}", NAME_SPACE)
            .replace("{persistentVolumeClaimName:.+}", "<c:out value='${persistentVolumeClaimName}'/>");

        procCallAjax(reqUrl, "GET", null, null, callbackGetPersistentVolumeClaimDetail);
    };

    // CALLBACK
    var callbackGetPersistentVolumeClaimDetail = function (data) {

        var f_srch_pvc = 'PersistentVolumeClaims 상세 조회에 실패하였습니다.';
        var s_msg_f_srch_pvc= '<spring:message code="M0109" arguments='arg_f_srch_pvc' javaScriptEscape="true" text="PersistentVolumeClaims 상세 조회에 실패하였습니다."/>';
        s_msg_f_srch_pvc_lang = s_msg_f_srch_pvc.replace('arg_f_srch_pvc', f_srch_pvc);

        if (!procCheckValidData(data)) {
            procViewLoading('hide');
            procAlertMessage(s_msg_f_srch_pvc_lang, false);
            return false;
        }

        var metadata = data.metadata;
        var spec = data.spec;
        var status = data.status;

        var persistentVolumeName = metadata.name;
        var namespace = NAME_SPACE;
        var labels = procSetSelector(metadata.labels);
        var annotations = metadata.annotations;
        var creationTimestamp = metadata.creationTimestamp;
        var selector = "";
        if(spec.selector != null) {
            selector = procSetSelector(spec.selector).replace(/matchLabels=/g, '');
        }

        var accessModes = "";
        for(var i = 0; i < spec.accessModes.length; i++) {
            accessModes += '<p>' + spec.accessModes[i] + '</p>';
        }
        var requestedStorage = spec.resources.requests.storage;
        var volumeName = nvl(spec.volumeName, '-');
        var volumeMode = nvl(spec.volumeMode, '-');
        var capacity;
        if(status.capacity != null) {
            capacity = status.capacity.storage;
        } else {
            capacity = '-';
        }

        var storageClassName = spec.storageClassName;
        var status = status.phase;


        $('#name').html(persistentVolumeName);
        $('#namespaceID').html("<a href='javascript:void(0);' onclick='procMovePage(\"<%= Constants.URI_CLUSTER_NAMESPACES %>/" + namespace + "\");'>" + namespace);
        $('#labels').html(procCreateSpans(labels));
        $('#annotations').html(procSetAnnotations(annotations));
        $('#creationTime').html(creationTimestamp);
        $('#selector').html(nvl(procCreateSpans(selector), '-'));
        $('#requestedStorage').html(requestedStorage);
        $('#accessModes').html(accessModes);
        $('#volumeName').html(volumeName);
        $('#volumeMode').html(volumeMode);
        $('#capacity').html(capacity);
        $('#storageClassName').html(nvl(storageClassName, '-'));
        $('#status').html(status);

        //hidden값 추가
        $('#hiddenNamespace').val(namespace);
        $('#hiddenResourceName').val(persistentVolumeName);

        procViewLoading('hide');
    };


    // ON LOAD
    $(document.body).ready(function () {
        getPersistentVolumeClaimDetail();
    });
</script>